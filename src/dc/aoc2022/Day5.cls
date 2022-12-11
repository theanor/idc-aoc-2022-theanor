Class dc.aoc2022.Day5 Extends Base
{

ClassMethod Run(fileName As %String = "input5.txt") As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException

    #Dim inputStream as %Stream.Object
    
    set sc = $$$OK
    try {
        set inputStream = ..GetInputStream(fileName,.sc)
        $$$TOE(sc,sc)

        $$$TOE(sc,..ParseStacks(inputStream,.stacks))
        $$$TOE(sc,..ParseMoves(inputStream,.moves))
        merge part1Stacks=stacks,part2Stacks=stacks

        $$$TOE(sc,..Part1(.part1Stacks,.moves))
        $$$TOE(sc,..Part2(.part2Stacks,.moves))
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

ClassMethod ParseStacks(inputStream As %Stream.Object, ByRef stacks As %String) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException

    #Dim line as %String

    set sc = $$$OK
    try {        
        set stacks = ""
        while 'inputStream.AtEnd {
            set line = inputStream.ReadLine(,.sc)
            set line = $zstrip(line,"<>C")
            quit:line=""
            do ..ParseStackLine(line,.stacks)
        }
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

ClassMethod ParseMoves(inputStream As %Stream.Object, ByRef moves As %Integer) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException

    #Dim line as %String
    #Dim cnt,numCrates,sourceStack,destStack as %Integer

    set sc = $$$OK
    try {        
        set moves = ""
        set cnt = 0
        while 'inputStream.AtEnd {
            set line = inputStream.ReadLine(,.sc)
            set line = $zstrip(line,"<>C")
            quit:line=""
            
            do ..ParseMoveLine(line,.numCrates,.sourceStack,.destStack)
            set cnt = cnt + 1
            set moves(cnt,"num") = numCrates
            set moves(cnt,"src") = sourceStack
            set moves(cnt,"dst") = destStack
        }
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

ClassMethod ParseStackLine(line As %String, ByRef stacks)
{
  #Dim col as %Integer
  #Dim crate as %String
  set col = 0            
  set stacks=0            
  while (col*4) < $length(line) {               
    set crate = $extract(line,(col*4)+2,(col*4)+2)
    if crate?1U  {
      set stacks(col) = crate_$get(stacks(col),"")                
    }            
    set col = col+1
  }
}

ClassMethod ParseMoveLine(line As %String, ByRef numCrates As %Integer, ByRef sourceStack As %Integer, ByRef destStack As %Integer)
{
  set numCrates = $zstrip($extract(line,$find(line,"move"),$find(line,"from")-5),"<>W")
  set sourceStack = $zstrip($extract(line,$find(line,"from"),$find(line,"to")-3),"<>W")-1
  set destStack = $zstrip($extract(line,$find(line,"to"),*),"<>W")-1
}

ClassMethod StackTops(ByRef stacks) As %String
{
  set result = ""
  set k = $order(stacks(""))
  while k '= "" {
    set result = result_$extract(stacks(k),$length(stacks(k)),$length(stacks(k)))
    set k = $order(stacks(k))
  }
  return result
}

ClassMethod Part1(ByRef stacks As %String, ByRef moves As %Integer) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException
    
    #Dim k as %Integer

    set sc = $$$OK
    try {
        set k = $order(moves(""))
        while k'="" {            
            set movedCrates = $extract(stacks(moves(k,"src")),$length(stacks(moves(k,"src")))-(moves(k,"num")-1),*)
            set stacks(moves(k,"dst")) = stacks(moves(k,"dst"))_$reverse(movedCrates)
            set stacks(moves(k,"src")) = $extract(stacks(moves(k,"src")),1,$length(stacks(moves(k,"src")))-moves(k,"num"))
            set k = $order(moves(k))
        }        
        write "Part 1 answer : ",..StackTops(.stacks),!
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

ClassMethod Part2(ByRef stacks As %String, ByRef moves As %Integer) As %Status
{
    #Dim k as %Integer

    set sc = $$$OK
    try {
        set k = $order(moves(""))
        while k'="" {            
            set movedCrates = $extract(stacks(moves(k,"src")),$length(stacks(moves(k,"src")))-(moves(k,"num")-1),*)
            set stacks(moves(k,"dst")) = stacks(moves(k,"dst"))_movedCrates
            set stacks(moves(k,"src")) = $extract(stacks(moves(k,"src")),1,$length(stacks(moves(k,"src")))-moves(k,"num"))
            set k = $order(moves(k))
        }        
        write "Part 2 answer : ",..StackTops(.stacks),!
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

}
