Class dc.aoc2022.Day13 Extends Base
{

ClassMethod Run(fileName As %String = "input13.txt") As %Status
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

ClassMethod Compare(left, right) As %Integer
{
  #Dim result as %Integer
  #Dim minl,i as %Integer
  
  if $isobject(left) && $isobject(right) {
   set minl = left.%Size()
   if right.%Size() < minl set minl = right.%Size()
   for i=0:1:minl-1 {
     set result = ..Compare(left.%Get(i),right.%Get(i))
     return:(result<0) -1
     return:(result>0) 1
   }
   return left.%Size() - right.%Size()
  } elseif '$isobject(left) && '$isobject(right) {
   return left - right
  } elseif $isobject(left) && '$isobject(right) {
   return ..Compare(left,[(right)])
  } else {
   return ..Compare([(left)],right)
  }
}

ClassMethod Part1(inputStream As %Stream.Object) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException
    
    #Dim line as %String

   
    set sc = $$$OK
    set index = 0
    set total = 0
    try {        
      while ('inputStream.AtEnd) {

        set line = inputStream.ReadLine(,.sc)
        $$$TOE(sc,sc)
        set line = $zstrip(line,"<>C")
        set left = [].%FromJSON(line)

        set line = inputStream.ReadLine(,.sc)
        $$$TOE(sc,sc)
        set line = $zstrip(line,"<>C")
        set right = [].%FromJSON(line)
       
        set index = index+1
        set order = ..Compare(left,right)
        set:order<0 total = total+index

        set line = inputStream.ReadLine(,.sc)       

      }
      write "Part 1 answer : ",total,!
    }    
     
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

ClassMethod PartitionPackets(ByRef packets, low As %Integer, high As %Integer)
{
  #Dim pv,z As %DynamicArray
  #Dim i,j As %Integer

  set pv = packets(high)  
  set i = low-1
  for j = low:1:high-1 {
    if ..Compare(packets(j),pv) <= 0 {
      set i=i+1
      set z = packets(j)
      set packets(j) = packets(i)
      set packets(i) = z      
    }
  }
  set i=i+1
  set z = packets(i)
  set packets(i) = packets(high)
  set packets(high) = z        
  return i
}

ClassMethod SortPackets(ByRef packets, low As %Integer, high As %Integer)
{
  #Dim pi As %Integer

  if low < high {
   set pi = ..PartitionPackets(.packets,low,high)
   do ..SortPackets(.packets,low,pi-1)
   do ..SortPackets(.packets,pi+1,high)
  }
}

ClassMethod Part2(inputStream As %Stream.Object) As %Status
{
    #Dim sc as %Status
    #Dim ex 

    #Dim line as %String

    #Dim packets as %DynamicArray
    #Dim pkt,div1,div2 as %DynamicArray
    #Dim idx,k,idxdiv2,idxdiv6 as %Integer



    set sc = $$$OK

    set div1 = [[2]]
    set div2 = [[6]]

    try {
        set idx = 0
        while ('inputStream.AtEnd) {
         set line = inputStream.ReadLine(,.sc)         
         set line = $zstrip(line,"<>C")       
         if line '= "" {
          set pkt = [].%FromJSON(line)
          set packets(idx) = pkt
          set idx = idx + 1 
         }
        }
        set packets(idx) = div1
        set idx = idx+1
        set packets(idx) = div2
        set idx = idx+1

        do ..SortPackets(.packets,0,idx-1)

        set k = $order(packets(""))
        while k '= "" {
          set pkt = packets(k)
          if (pkt.%Size()=1) && (pkt.%Get(0).%Size()=1) && (pkt.%Get(0).%Get(0)=2) { set idxdiv2 = k+1}
          if (pkt.%Size()=1) && (pkt.%Get(0).%Size()=1) && (pkt.%Get(0).%Get(0)=6) { set idxdiv6 = k+1}
          set k = $order(packets(k))
        }
        write "Part 2 answer : ",idxdiv2*idxdiv6
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

}
