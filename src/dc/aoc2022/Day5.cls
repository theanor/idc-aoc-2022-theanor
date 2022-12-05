Class dc.aoc2022.Day5 Extends Base
{

ClassMethod Run(fileName As %String = "input5.txt") As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException

    #Dim inputStream as %Stream.Object
    
    Set sc = $$$OK
    Try {
        Set inputStream = ..GetInputStream(fileName,.sc)
        $$$TOE(sc,sc)

        $$$TOE(sc,..ParseStacks(inputStream,.stacks))
        $$$TOE(sc,..ParseMoves(inputStream,.moves))
        Merge part1Stacks=stacks,part2Stacks=stacks

        $$$TOE(sc,..Part1(.part1Stacks,.moves))
        $$$TOE(sc,..Part2(.part2Stacks,.moves))
    }
    Catch (ex) {
      Set sc = ex.AsStatus()
    }
    Return sc
}

ClassMethod ParseStacks(inputStream As %Stream.Object, ByRef stacks As %String) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException

    #Dim line as %String

    Set sc = $$$OK
    Try {        
        Set stacks = ""
        While 'inputStream.AtEnd {
            Set line = inputStream.ReadLine(,.sc)
            Set line = $ZSTRIP(line,"<>C")
            Quit:line=""
            Do ..ParseStackLine(line,.stacks)
        }
    }
    Catch (ex) {
      Set sc = ex.AsStatus()
    }
    Return sc
}

ClassMethod ParseMoves(inputStream As %Stream.Object, ByRef moves As %Integer) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException

    #Dim line as %String
    #Dim cnt,numCrates,sourceStack,destStack as %Integer

    Set sc = $$$OK
    Try {        
        Set moves = ""
        Set cnt = 0
        While 'inputStream.AtEnd {
            Set line = inputStream.ReadLine(,.sc)
            Set line = $ZSTRIP(line,"<>C")
            Quit:line=""
            
            Do ..ParseMoveLine(line,.numCrates,.sourceStack,.destStack)
            Set cnt = cnt + 1
            Set moves(cnt,"num") = numCrates
            Set moves(cnt,"src") = sourceStack
            Set moves(cnt,"dst") = destStack
        }
    }
    Catch (ex) {
      Set sc = ex.AsStatus()
    }
    Return sc
}

ClassMethod ParseStackLine(line As %String, ByRef stacks)
{
  #Dim col as %Integer
  #Dim crate as %String
  Set col = 0            
  Set stacks=0            
  While (col*4) < $LENGTH(line) {               
    Set crate = $EXTRACT(line,(col*4)+2,(col*4)+2)
    If crate?1U  {
      Set stacks(col) = crate_$GET(stacks(col),"")                
    }            
    Set col = col+1
  }
}

ClassMethod ParseMoveLine(line As %String, ByRef numCrates As %Integer, ByRef sourceStack As %Integer, ByRef destStack As %Integer)
{
  Set numCrates = $ZSTRIP($EXTRACT(line,$FIND(line,"move"),$FIND(line,"from")-5),"<>W")
  Set sourceStack = $ZSTRIP($EXTRACT(line,$FIND(line,"from"),$FIND(line,"to")-3),"<>W")-1
  Set destStack = $ZSTRIP($EXTRACT(line,$FIND(line,"to"),*),"<>W")-1
}

ClassMethod StackTops(ByRef stacks) As %String
{
  Set result = ""
  Set k = $ORDER(stacks(""))
  While k '= "" {
    Set result = result_$EXTRACT(stacks(k),$LENGTH(stacks(k)),$LENGTH(stacks(k)))
    Set k = $ORDER(stacks(k))
  }
  Return result
}

ClassMethod Part1(ByRef stacks As %String, ByRef moves As %Integer) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException
    
    #Dim k as %Integer

    Set sc = $$$OK
    Try {
        Set k = $ORDER(moves(""))
        While k'="" {            
            Set movedCrates = $EXTRACT(stacks(moves(k,"src")),$LENGTH(stacks(moves(k,"src")))-(moves(k,"num")-1),*)
            Set stacks(moves(k,"dst")) = stacks(moves(k,"dst"))_$REVERSE(movedCrates)
            Set stacks(moves(k,"src")) = $EXTRACT(stacks(moves(k,"src")),1,$LENGTH(stacks(moves(k,"src")))-moves(k,"num"))
            Set k = $ORDER(moves(k))
        }        
        Write "Part 1 answer : ",..StackTops(.stacks),!
    }
    Catch (ex) {
      Set sc = ex.AsStatus()
    }
    Return sc
}

ClassMethod Part2(ByRef stacks As %String, ByRef moves As %Integer) As %Status
{
    #Dim k as %Integer

    Set sc = $$$OK
    Try {
        Set k = $ORDER(moves(""))
        While k'="" {            
            Set movedCrates = $EXTRACT(stacks(moves(k,"src")),$LENGTH(stacks(moves(k,"src")))-(moves(k,"num")-1),*)
            Set stacks(moves(k,"dst")) = stacks(moves(k,"dst"))_movedCrates
            Set stacks(moves(k,"src")) = $EXTRACT(stacks(moves(k,"src")),1,$LENGTH(stacks(moves(k,"src")))-moves(k,"num"))
            Set k = $ORDER(moves(k))
        }        
        Write "Part 2 answer : ",..StackTops(.stacks),!
    }
    Catch (ex) {
      Set sc = ex.AsStatus()
    }
    Return sc
}

}
