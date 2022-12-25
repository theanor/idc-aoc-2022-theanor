Class dc.aoc2022.Day25 Extends Base
{

ClassMethod Run(fileName As %String = "input25.txt") As %Status
{
    #Dim sc as %Status
    #Dim ex 
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

ClassMethod SnafuToDec(sn As %String) As %Integer
{
  #Dim rn as %String
  #Dim f,i,d,result as %Integer

  set rn = $reverse(sn)
  set result = 0
  set f = 1
  for i=1:1:$length(rn) {
    set d = $case($extract(rn,i,i),"2":"2","1":"1","0":"0","-":-1,"=":-2)
    set result = result+(d*f)
    set f = f * 5
  }
  return result
}

ClassMethod DecToSnafuInternal(n As %Integer) As %String
{
  #Dim r,d As %Integer
  
  if n=0 return ""
  set r = n # 5
  for d=-2:1:2 {
    if ((d+5)#5) = r {
      return ..DecToSnafuInternal((n-d)\5)_$case(d,-2:"=",-1:"-",0:"0",1:"1",2:"2")
    }
  }   
  return ""
}

ClassMethod DecToSnafu(n As %Integer) As %String
{
  return:n=0 "0"
  return ..DecToSnafuInternal(n)
}

ClassMethod Part1(inputStream As %Stream.Object) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException
    
    #Dim line as %String

   
    set sc = $$$OK
    try {        
      set total = 0
      while ('inputStream.AtEnd)
      {
        set line = inputStream.ReadLine(,.sc)
        set line = $zstrip(line,"<>C")
        set total = total + ..SnafuToDec(line)
      }
      write "Part 1 answer : ",..DecToSnafu(total),!
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

ClassMethod Part2(inputStream As %Stream.Object) As %Status
{
    set sc = $$$OK
    try {        
      write "Part 2 answer : \o/ start the blender and enjoy a ... merry Christmas and happy 2023 !",!
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

}
