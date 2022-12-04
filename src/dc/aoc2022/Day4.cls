Class dc.aoc2022.Day4 Extends Base
{

ClassMethod Run(fileName As %String = "input4.txt") As %Status
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
    
    #Dim line as %String
    #Dim total,p1l,p1h,p2l,p2h as %Integer
    #Dim overlap as %Boolean


   
    Set sc = $$$OK
    Try {
        Set total = 0
        While 'inputStream.AtEnd {
            Set line = inputStream.ReadLine(,.sc)
            $$$TOE(sc,..ParseInputLine(line,.p1l,.p1h,.p2l,.p2h))
            Set overlap = ((p2l >= p1l) && (p2h <= p1h))||((p1l >= p2l) && (p1h <= p2h))
            Set total = total + overlap
        }
        Write "Part 1 answer : ",total,!
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
    
    #Dim line as %String
    #Dim total,p1l,p1h,p2l,p2h as %Integer
    #Dim overlap as %Boolean

   
    Set sc = $$$OK
    Try {
        Set total = 0
        While 'inputStream.AtEnd {
            Set line = inputStream.ReadLine(,.sc)
            $$$TOE(sc,..ParseInputLine(line,.p1l,.p1h,.p2l,.p2h))
            Set overlap = ((p2h>=p1l)&&(p2h <= p1h)) || ((p1h>=p2l)&&(p1h <= p2h))
            Set total = total + overlap
        }
        Write "Part 1 answer : ",total,!
    }
    Catch (ex) {
      Set sc = ex.AsStatus()
    }
    Return sc
}

ClassMethod ParseInputLine(line As %String, ByRef p1l As %String, ByRef p1h As %String, ByRef p2l As %String, ByRef p2h As %String) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException

    #Dim p1,p2 As %String
    
    Set sc = $$$OK
    Try {
      Set p1 = $PIECE(line,",",1)
      Set p2 = $PIECE(line,",",2)
      Set p1l = $PIECE(p1,"-",1)
      Set p1h = $PIECE(p1,"-",2)
      Set p2l = $PIECE(p2,"-",1)
      Set p2h = $PIECE(p2,"-",2)
    }
    Catch (ex) {
      Set sc = ex.AsStatus()
    }
    Quit sc
}

}
