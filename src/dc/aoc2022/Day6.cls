Class dc.aoc2022.Day6 Extends Base
{

ClassMethod Run(fileName As %String = "input6.txt") As %Status
{
    #Dim sc as %Status
    #Dim ex 
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

   
    Set sc = $$$OK
    Try {        
      Set line = inputStream.ReadLine(,.sc)
      Set line = $ZSTRIP(line,"<>C")
      Write "Part 1 answer : ",..MarkerPosition(line,4),!
    }
    Catch (ex) {
      Set sc = ex.AsStatus()
    }
    Return sc
}

ClassMethod Part2(inputStream As %Stream.Object) As %Status
{
    #Dim line as %String

    Set sc = $$$OK
    Try {
        Set line = inputStream.ReadLine(,.sc)
        Set line = $ZSTRIP(line,"<>C")        
        Set p = ..MarkerPosition(line,14)
        Write "Part 2 answer : ",p,!
    }
    Catch (ex) {
      Set sc = ex.AsStatus()
    }
    Return sc
}

ClassMethod MarkerPosition(msg As %String, len As %Integer) As %Integer
{
  #Dim p,i,j,l as %Integer
  #Dim buf as %String

  Set p = 1
  Set buf = ""
  Set j=0

  Set l = $LENGTH(msg)
  While (p <= l) {
    Set c = $EXTRACT(msg,p,p)                    
    Set buf = buf_c
    If $LENGTH(buf) = len {
      Set i = 1                    
      While (i < len) {
        Set c = $EXTRACT(buf,i,i)
        Set j = i+1                        
        While (j <= len) {
         Set d = $EXTRACT(buf,j,j)
         Quit:c=d                            
         Set j = j +1
        }   
        Quit:c=d                     
        Set i = i+1
      }      
      Quit:i=len
      Set buf = $EXTRACT(buf,2,len)
    }                                
    Set p = p + 1
  }            
  Return p
}

}
