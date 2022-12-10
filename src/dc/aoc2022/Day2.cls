Class dc.aoc2022.Day2 Extends Base
{

ClassMethod Run(fileName As %String = "input2.txt") As %Status
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

ClassMethod Part1(inputStream As %Stream.Object) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException

    #Dim opMove,myMove as %String
    #Dim score,totalScore as %Integer
   
    Set sc = $$$OK
    Set totalScore = 0
    Set moveScore("X")=1
    Set moveScore("Y")=2
    Set moveScore("Z")=3
    Set matchScore("A","X") = 3
    Set matchScore("B","Y") = 3
    Set matchScore("C","Z") = 3
    Set matchScore("A","Y") = 6
    Set matchScore("B","Z") = 6
    Set matchScore("C","X") = 6
    Try {
        While 'inputStream.AtEnd {
            Set line = inputStream.ReadLine(,.sc)
            $$$TOE(sc,sc)
            $$$TOE(sc,..ParseInputLine(line,.opMove,.myMove))
            Set score = $GET(moveScore(myMove),0)+$GET(matchScore(opMove,myMove),0)
            Set totalScore = totalScore+score
        }
        Write !,"Part 1 answer : ",totalScore
    }
    Catch (ex) {
      Set sc = ex.AsStatus()
    }
    Return sc
}

ClassMethod Part2(inputStream As %Stream.Object) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException

    #Dim moves,opMove,myMove as %String
    #Dim score,totalScore as %Integer
   
    Set sc = $$$OK
    Set totalScore = 0
    Set moveScore("X")=1
    Set moveScore("Y")=2
    Set moveScore("Z")=3
    Set matchScore("A","X") = 3
    Set matchScore("B","Y") = 3
    Set matchScore("C","Z") = 3
    Set matchScore("A","Y") = 6
    Set matchScore("B","Z") = 6
    Set matchScore("C","X") = 6
    Set moves("A","X") = "Z"
    Set moves("A","Y") = "X"
    Set moves("A","Z") = "Y"
    Set moves("B","X") = "X"
    Set moves("B","Y") = "Y"
    Set moves("B","Z") = "Z"
    Set moves("C","X") = "Y"
    Set moves("C","Y") = "Z"
    Set moves("C","Z") = "X"
    Try {
        While 'inputStream.AtEnd {
            Set line = inputStream.ReadLine(,.sc)
            $$$TOE(sc,sc)
            $$$TOE(sc,..ParseInputLine(line,.opMove,.expEnd))
            Set myMove = moves(opMove,expEnd)
            Set score = $GET(moveScore(myMove),0)+$GET(matchScore(opMove,myMove),0)
            Set totalScore = totalScore+score
        }
        Write !,"Part 2 answer : ",totalScore
    }
    Catch (ex) {
      Set sc = ex.AsStatus()
    }
    Return sc
}

ClassMethod ParseInputLine(line As %String, ByRef opponentMove As %String(MAXLEN=1), ByRef move As %String(MAXLEN=1)) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException
    
    Set sc = $$$OK
    Try {
      Set opponentMove = $ZSTRIP($PIECE(line," ",1),"<>C")
      Set move = $ZSTRIP($PIECE(line," ",2),"<>C")
      If ('("ABC" [ opponentMove)) || ('("XYZ" [ move)) || ($LENGTH(opponentMove) '= 1) || ($LENGTH(move) '= 1) {
        Throw ##class(%Exception.General).%New("invalid input line : """_line_"""")
      }
    }
    Catch (ex) {
      Set sc = ex.AsStatus()
    }
    Quit sc
}

}
