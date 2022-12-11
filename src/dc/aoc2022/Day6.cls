Class dc.aoc2022.Day6 Extends Base
{

ClassMethod Run(fileName As %String = "input6.txt") As %Status
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

ClassMethod Part1(inputStream As %Stream.Object) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException
    
    #Dim line as %String

   
    set sc = $$$OK
    try {        
      set line = inputStream.ReadLine(,.sc)
      set line = $zstrip(line,"<>C")
      write "Part 1 answer : ",..MarkerPosition(line,4),!
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

ClassMethod Part2(inputStream As %Stream.Object) As %Status
{
    #Dim line as %String

    set sc = $$$OK
    try {
        set line = inputStream.ReadLine(,.sc)
        set line = $zstrip(line,"<>C")        
        set p = ..MarkerPosition(line,14)
        write "Part 2 answer : ",p,!
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

ClassMethod MarkerPosition(msg As %String, len As %Integer) As %Integer
{
  #Dim p,i,j,l as %Integer
  #Dim buf as %String

  set p = 1
  set buf = ""
  set j=0

  set l = $length(msg)
  while (p <= l) {
    set c = $extract(msg,p,p)                    
    set buf = buf_c
    if $length(buf) = len {
      set i = 1                    
      while (i < len) {
        set c = $extract(buf,i,i)
        set j = i+1                        
        while (j <= len) {
         set d = $extract(buf,j,j)
         quit:c=d                            
         set j = j +1
        }   
        quit:c=d                     
        set i = i+1
      }      
      quit:i=len
      set buf = $extract(buf,2,len)
    }                                
    set p = p + 1
  }            
  return p
}

}
