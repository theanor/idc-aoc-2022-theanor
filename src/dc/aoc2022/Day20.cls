Class dc.aoc2022.Day20 Extends Base
{

ClassMethod Run(fileName As %String = "input20.txt") As %Status
{
    #Dim sc as %Status
    #Dim ex 
    #Dim inputStream as %Stream.Object
    
    set sc = $$$OK
    try {
        set inputStream = ..GetInputStream(fileName,.sc)
        $$$TOE(sc,sc)
        $$$TOE(sc,..Part1And2(inputStream))
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

ClassMethod FindIndex(f As %ListOfDataTypes, index As %Integer) As %Integer
{
  #Dim k As %Integer
  #Dim l As %Integer
  
  s l = f.Size
  for k=1:1:l {    
   quit:$listget(f.GetAt(k),1)=index
  }        
  return k
}

ClassMethod FindValue(f As %ListOfDataTypes, value As %Integer) As %Integer
{
  #Dim k As %Integer
  #Dim l As %Integer
  
  s l = f.Size
  for k=1:1:l {    
   quit:$listget(f.GetAt(k),2)=value
  }        
  return k
}

ClassMethod Decrypt(f As %ListOfDataTypes, iter As %Integer = 1) As %Status
{
  #Dim sc as %Status
  #Dim ex as %Exception.AbstractException

  #Dim it as %Integer
  #Dim l as %Integer
  #Dim i,k As %Integer
  #Dim v,np As %Integer
    
  s sc = $$$OK
  try {
    for it=1:1:iter {
      s l = f.Size
      for i=0:1:l-1 {
        s k = ..FindIndex(f,i)-1       
        s v = $listget(f.GetAt(k+1),2)        
        s np = (k+v+l-1) # (l-1)        
        d f.RemoveAt(k+1)    
        $$$TOE(sc,f.InsertAt($listbuild(i,v),np+1))
      }            
    }
  } catch (ex) {
    s sc = ex.AsStatus()
  }
  q sc
}

ClassMethod Total(f As %ListOfDataTypes) As %Integer
{
  #Dim k,l as %Integer
  #Dim v1,v2,v3 as %Integer

  s k = ..FindValue(f,0)-1      
  s l = f.Size
  s v1 = $listget(f.GetAt(((k+1000)#l)+1),2)
  s v2 = $listget(f.GetAt(((k+2000)#l)+1),2)
  s v3 = $listget(f.GetAt(((k+3000)#l)+1),2)

  return v1+v2+v3
}

ClassMethod Part1And2(inputStream As %Stream.Object) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException
    
    
    #Dim m1,m2 as %ListOfDataTypes
    #Dim i as %Integer
    #Dim line as %String
  
    set sc = $$$OK
    try {        

      s m1 = ##class(%ListOfDataTypes).%New()
      s m2 = ##class(%ListOfDataTypes).%New()

      s i=0
      while ('inputStream.AtEnd)
      {
        set line = inputStream.ReadLine(,.sc)
        set line = $zstrip(line,"<>C")
        $$$TOE(sc,m1.Insert($listbuild(i,line+0)))
        $$$TOE(sc,m2.Insert($listbuild(i,line*811589153)))
        s i = i + 1
      }      

      $$$TOE(sc,..Decrypt(m1))      
      write "Part 1 answer : ",..Total(m1),!      

      $$$TOE(sc,..Decrypt(m2,10))
      write "Part 2 answer : ",..Total(m2),!      
      
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

}
