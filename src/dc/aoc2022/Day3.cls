Class dc.aoc2022.Day3 Extends Base
{

ClassMethod Run(fileName As %String = "input3.txt") As %Status
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
    
    #Dim line,comp1,comp2,it as %String
    #Dim len,cnt,total as %Integer
   
    set sc = $$$OK
    try {
        set total = 0
        while 'inputStream.AtEnd {
            set line = inputStream.ReadLine(,.sc)
            set len = $length(line)
            set cnt = len/2
            set comp1 = $extract(line,1,cnt)
            set comp2 = $extract(line,cnt+1,len)
            set it = ..CommonItems(comp1,comp2)
            set total = total+..ItemPriority(it)
        }
        write "Part 1 answer : ",total,!
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

ClassMethod ItemPriority(it As %String) As %Integer
{
  #Dim itc As %Integer

  set itc = $ascii(it)            
  return $select(itc>96:itc-96,1:itc-38)
}

ClassMethod CommonItems(comp1 As %String, comp2 As %String) As %String
{
  #Dim l1,l2,p1,p2 As %Integer
  #Dim bl As %String

  set l1 = $length(comp1)
  set l2 = $length(comp2)
  set bl = ""
  set $extract(bl,$select(l1>l2:l1,1:l2)) = " "
  set p1 = 1
  set result = ""
  for {
   set p1 = $find($translate(comp1,comp2,bl)," ",p1)
   quit:p1<1
   set p2 = $find(comp2,$extract(comp1,p1-1))-1
   set:p2>=1 result = result_$extract(comp2,p2)
  }
  return result
}

ClassMethod Part2(inputStream As %Stream.Object) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException
    
    #Dim rug1,rug2,rug3,it as %String
    #Dim total as %Integer
   
    set sc = $$$OK
    try {
        set total = 0
        while 'inputStream.AtEnd {
            set rug1 = inputStream.ReadLine(,.sc)
            set rug2 = inputStream.ReadLine(,.sc)
            set rug3 = inputStream.ReadLine(,.sc)            
            set it = $extract(..CommonItems(rug1,..CommonItems(rug2,rug3)),1)
            set total = total + ..ItemPriority(it)
        }
        write "Part 2 answer : ",total,!
    }
    
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

}
