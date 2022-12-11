Class dc.aoc2022.Day4 Extends Base
{

ClassMethod Run(fileName As %String = "input4.txt") As %Status
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
    
    #Dim line as %String
    #Dim total,p1l,p1h,p2l,p2h as %Integer
    #Dim overlap as %Boolean


   
    set sc = $$$OK
    try {
        set total = 0
        while 'inputStream.AtEnd {
            set line = inputStream.ReadLine(,.sc)
            $$$TOE(sc,..ParseInputLine(line,.p1l,.p1h,.p2l,.p2h))
            set overlap = ((p2l >= p1l) && (p2h <= p1h))||((p1l >= p2l) && (p1h <= p2h))
            set total = total + overlap
        }
        write "Part 1 answer : ",total,!
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
    
    #Dim line as %String
    #Dim total,p1l,p1h,p2l,p2h as %Integer
    #Dim overlap as %Boolean

   
    set sc = $$$OK
    try {
        set total = 0
        while 'inputStream.AtEnd {
            set line = inputStream.ReadLine(,.sc)
            $$$TOE(sc,..ParseInputLine(line,.p1l,.p1h,.p2l,.p2h))
            set overlap = ((p2h>=p1l)&&(p2h <= p1h)) || ((p1h>=p2l)&&(p1h <= p2h))
            set total = total + overlap
        }
        write "Part 1 answer : ",total,!
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

ClassMethod ParseInputLine(line As %String, ByRef p1l As %String, ByRef p1h As %String, ByRef p2l As %String, ByRef p2h As %String) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException

    #Dim p1,p2 As %String
    
    set sc = $$$OK
    try {
      set p1 = $piece(line,",",1)
      set p2 = $piece(line,",",2)
      set p1l = $piece(p1,"-",1)
      set p1h = $piece(p1,"-",2)
      set p2l = $piece(p2,"-",1)
      set p2h = $piece(p2,"-",2)
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    quit sc
}

}
