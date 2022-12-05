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
        $$$TOE(sc,..Part1(inputStream))
        $$$TOE(sc,inputStream.Rewind())
        $$$TOE(sc,..Part2(inputStream))
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

ClassMethod Part1(inputStream As %Stream.Object) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException
    
    #Dim line as %String
    #Dim stacks as %String
    #Dim numCrates,sourceStack,destStack as %Integer

   
    Set sc = $$$OK
    Try {
        
        Set stacks = ""
        While 'inputStream.AtEnd {
            Set line = inputStream.ReadLine(,.sc)
            Set line = $ZSTRIP(line,"<>C")
            Quit:line=""
            Do ..ParseStackLine(line,.stacks)
        }
        While 'inputStream.AtEnd {            
            Set line = inputStream.ReadLine(,.sc)
            Set line = $ZSTRIP(line,"<>C")
            Do ..ParseMoveLine(line,.numCrates,.sourceStack,.destStack)
            Set movedCrates = $EXTRACT(stacks(sourceStack),$LENGTH(stacks(sourceStack))-(numCrates-1),*)
            Set stacks(destStack) = stacks(destStack)_$REVERSE(movedCrates)
            Set stacks(sourceStack) = $EXTRACT(stacks(sourceStack),1,$LENGTH(stacks(sourceStack))-numCrates)
        }
        Write "Part 1 answer : ",..StackTops(.stacks),!
    }
    Catch (ex) {
      Set sc = ex.AsStatus()
    }
    Return sc
}

ClassMethod Part2(inputStream As %Stream.Object) As %Status
{
    #Dim line as %String
    #Dim stacks as %String
    #Dim numCrates,sourceStack,destStack as %Integer

    Set sc = $$$OK
    Try {
        Set stacks=""
        While 'inputStream.AtEnd {
            Set line = inputStream.ReadLine(,.sc)
            Set line = $ZSTRIP(line,"<>C")
            Quit:line=""
            Do ..ParseStackLine(line,.stacks)
        }
        While 'inputStream.AtEnd {            
            Set line = inputStream.ReadLine(,.sc)
            Set line = $ZSTRIP(line,"<>C")
            Do ..ParseMoveLine(line,.numCrates,.sourceStack,.destStack)
            Set movedCrates = $EXTRACT(stacks(sourceStack),$LENGTH(stacks(sourceStack))-(numCrates-1),*)
            Set stacks(destStack) = stacks(destStack)_movedCrates
            Set stacks(sourceStack) = $EXTRACT(stacks(sourceStack),1,$LENGTH(stacks(sourceStack))-numCrates)
        }
        Write "Part 2 answer : ",..StackTops(.stacks),!
    }
    Catch (ex) {
      Set sc = ex.AsStatus()
    }
    Return sc
}

}
