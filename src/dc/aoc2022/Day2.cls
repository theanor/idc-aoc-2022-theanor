Class dc.aoc2022.Day2 Extends Base
{

ClassMethod Run(fileName As %String = "input2.txt") As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException

    #Dim inputStream as %Stream.Object
    
    set sc = $$$OK
    try {
        set inputStream = ..GetInputStream(fileName,.sc)
        $$$TOE(sc,sc)
        $$$TOE(sc,..Part1(inputStream))
        $$$TOE(sc,inputStream.Rewind())
        $$$TOE(sc,..Part2(inputStream))
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

ClassMethod Part1(inputStream As %Stream.Object) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException

    #Dim opMove,myMove as %String
    #Dim score,totalScore as %Integer
   
    set sc = $$$OK
    set totalScore = 0
    set moveScore("X")=1
    set moveScore("Y")=2
    set moveScore("Z")=3
    set matchScore("A","X") = 3
    set matchScore("B","Y") = 3
    set matchScore("C","Z") = 3
    set matchScore("A","Y") = 6
    set matchScore("B","Z") = 6
    set matchScore("C","X") = 6
    try {
        while 'inputStream.AtEnd {
            set line = inputStream.ReadLine(,.sc)
            $$$TOE(sc,sc)
            $$$TOE(sc,..ParseInputLine(line,.opMove,.myMove))
            set score = $get(moveScore(myMove),0)+$get(matchScore(opMove,myMove),0)
            set totalScore = totalScore+score
        }
        write "Part 1 answer : ",totalScore,!
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

ClassMethod Part2(inputStream As %Stream.Object) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException

    #Dim moves,opMove,myMove as %String
    #Dim score,totalScore as %Integer
   
    set sc = $$$OK
    set totalScore = 0
    set moveScore("X")=1
    set moveScore("Y")=2
    set moveScore("Z")=3
    set matchScore("A","X") = 3
    set matchScore("B","Y") = 3
    set matchScore("C","Z") = 3
    set matchScore("A","Y") = 6
    set matchScore("B","Z") = 6
    set matchScore("C","X") = 6
    set moves("A","X") = "Z"
    set moves("A","Y") = "X"
    set moves("A","Z") = "Y"
    set moves("B","X") = "X"
    set moves("B","Y") = "Y"
    set moves("B","Z") = "Z"
    set moves("C","X") = "Y"
    set moves("C","Y") = "Z"
    set moves("C","Z") = "X"
    try {
        while 'inputStream.AtEnd {
            set line = inputStream.ReadLine(,.sc)
            $$$TOE(sc,sc)
            $$$TOE(sc,..ParseInputLine(line,.opMove,.expEnd))
            set myMove = moves(opMove,expEnd)
            set score = $get(moveScore(myMove),0)+$get(matchScore(opMove,myMove),0)
            set totalScore = totalScore+score
        }
        write "Part 2 answer : ",totalScore,!
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

ClassMethod ParseInputLine(line As %String, ByRef opponentMove As %String(MAXLEN=1), ByRef move As %String(MAXLEN=1)) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException
    
    set sc = $$$OK
    try {
      set opponentMove = $zstrip($piece(line," ",1),"<>C")
      set move = $zstrip($piece(line," ",2),"<>C")
      if ('("ABC" [ opponentMove)) || ('("XYZ" [ move)) || ($length(opponentMove) '= 1) || ($length(move) '= 1) {
        throw ##class(%Exception.General).%New("invalid input line : """_line_"""")
      }
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    quit sc
}

}
