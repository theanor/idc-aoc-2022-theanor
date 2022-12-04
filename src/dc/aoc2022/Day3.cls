Class dc.aoc2022.Day3 Extends Base
{

ClassMethod Run(fileName As %String = "input3.txt") As %Status
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
    
    #Dim line,comp1,comp2,it as %String
    #Dim len,cnt,total as %Integer
   
    Set sc = $$$OK
    Try {
        Set total = 0
        While 'inputStream.AtEnd {
            Set line = inputStream.ReadLine(,.sc)
            Set len = $LENGTH(line)
            Set cnt = len/2
            Set comp1 = $EXTRACT(line,1,cnt)
            Set comp2 = $EXTRACT(line,cnt+1,len)
            Set it = ..CommonItems(comp1,comp2)
            Set total = total+..ItemPriority(it)
        }
        Write "Part 1 answer : ",total,!
    }
    Catch (ex) {
      Set sc = ex.AsStatus()
    }
    Return sc
}

ClassMethod ItemPriority(it As %String) As %Integer
{
  #Dim itc As %Integer

  Set itc = $ASCII(it)            
  Return $SELECT(itc>96:itc-96,1:itc-38)
}

ClassMethod CommonItems(comp1 As %String, comp2 As %String) As %String
{
  #Dim l1,l2,p1,p2 As %Integer
  #Dim bl As %String

  Set l1 = $LENGTH(comp1)
  Set l2 = $LENGTH(comp2)
  Set bl = ""
  Set $EXTRACT(bl,$SELECT(l1>l2:l1,1:l2)) = " "
  Set p1 = 1
  Set result = ""
  For {
   Set p1 = $FIND($TRANSLATE(comp1,comp2,bl)," ",p1)
   Quit:p1<1
   Set p2 = $FIND(comp2,$EXTRACT(comp1,p1-1))-1
   Set:p2>=1 result = result_$EXTRACT(comp2,p2)
  }
  Return result
}

ClassMethod Part2(inputStream As %Stream.Object) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException
    
    #Dim rug1,rug2,rug3,it as %String
    #Dim total as %Integer
   
    Set sc = $$$OK
    Try {
        Set total = 0
        While 'inputStream.AtEnd {
            Set rug1 = inputStream.ReadLine(,.sc)
            Set rug2 = inputStream.ReadLine(,.sc)
            Set rug3 = inputStream.ReadLine(,.sc)            
            Set it = $EXTRACT(..CommonItems(rug1,..CommonItems(rug2,rug3)),1)
            Set total = total + ..ItemPriority(it)
        }
        Write "Part 2 answer : ",total,!
    }
    
    Catch (ex) {
      Set sc = ex.AsStatus()
    }
    Return sc
}

}
