Class dc.aoc2022.Day16 Extends Base
{

ClassMethod Run(fileName As %String = "input16.txt") As %Status
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

ClassMethod ParseGraph(inputStream As %Stream.Object, ByRef graph) As %Status
{
  #Dim sc as %Status = $$$OK
  #Dim ex as %Exception.AbstractException

  #Dim line as %String      
  #Dim matcher as %Regex.Matcher
  #Dim node As %String
  #Dim nodePress As %Integer
  #Dim succs As %String
  
  try {

    set sc = $$$OK
    set matcher = ##class(%Regex.Matcher).%New("Valve ([A-Z]+) has flow rate=([0-9]+); tunnels? leads? to valves? (.*)")  
     while 'inputStream.AtEnd {
      set line = inputStream.ReadLine(,.sc)
      $$$TOE(sc,sc)
      set line = $zstrip(line,"<>C")
      if matcher.Match(line) {
        set node = matcher.Group(1)
        set nodePress = matcher.Group(2)
        set succs = $replace(matcher.Group(3)," ","")
        set graph(node,"p") = nodePress
        set graph(node,"s") = $listfromstring(succs,",")      
      } else {
        throw ##class(%Exception.General).%New("invalid input")
      }
    }
  } catch (ex) {
    set sc = ex.AsStatus()
  }
  quit sc
}

ClassMethod ShortestPaths(ByRef graph, ByRef dist, ByRef nodes) As %Status
{
  #Dim sc as %Status
  #Dim ex as %Exception.AbstractException

  #Dim n as %String
  #Dim ptr as %Integer
  #Dim succs as %List
  #Dim i,j,k as %Integer
  #Dim ni,nj,nk as %String

  set sc = $$$OK  
  try {
    set n=$order(graph(""))
    while n '= "" {
      set ptr = 0
      set succs = graph(n,"s")
      while $listnext(succs,ptr,succ) {
        set dist(n,succ)=1        
      }
      set dist(n,n) = 0      
      set $list(nodes,*+1) = n
      set n = $order(graph(n))
    }    
    
    set i = 0
    set j = 0
    set k = 0
    while $listnext(nodes,k,nk) {
      while $listnext(nodes,i,ni) {
         while $listnext(nodes,j,nj) {            
              if $get(dist(ni,nj),99999) > ($get(dist(ni,nk),999999)+$get(dist(nk,nj),999999)) {
                set dist(ni,nj) = dist(ni,nk)+dist(nk,nj)
              }
        }
      }
    }
  } catch (ex) {
    set sc = ex.AsStatus()
  }
  quit sc
}

ClassMethod Traverse(ByRef graph, ByRef dist, nodes As %List, curNode As %String, remTicks As %Integer, state, flow As %Integer, ByRef result)
{
  #Dim ni,nx As %Integer
  #Dim node As %String
  #Dim ticks As %Integer  

  set:(flow > $get(result(state),0)) result(state) = flow
  set ni = 0
  set nx = 0
  while $listnext(nodes,ni,node) {
    set nx = nx + 1
    set ticks = remTicks - dist(curNode,node) - 1
    if '(($bit($factor(state),nx) = 1)||(ticks <= 0)) {
      do ..Traverse(.graph,.dist,nodes,node,ticks,state+(2**(nx-1)),flow+(ticks*graph(node,"p")),.result)
    }
  }
}

ClassMethod Max(ByRef result) As %Integer
{
  #Dim max As %Integer
  #Dim k 
  
   set max = 0
   set k = $order(result("")) 
   while k'="" {
    set:result(k)>max max = result(k)
    set k = $order(result(k)) 
   }
   return max
}

ClassMethod Part1And2(inputStream As %Stream.Object) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException
    
    #Dim graph
    #Dim dist
    #Dim nodes,pressureNodes As %List
    #Dim result
    #Dim best,best2,b1,b2,t as %Integer
    #Dim n1,n2 as %Integer
    #Dim bn1,bn2



    set sc = $$$OK
    try {        
     $$$TOE(sc,..ParseGraph(inputStream,.graph))
     $$$TOE(sc,..ShortestPaths(.graph,.dist,.nodes))

     set i = 0
     set pressureNodes = ""
     while $listnext(nodes,i,node) {
       if (graph(node,"p") > 0)  {
         set $list(pressureNodes,*+1) = node        
       }
     }         

     // part 1
     //
     // find yield of opening valves in all possible sequences for 30 ticks
     do ..Traverse(.graph,.dist,.pressureNodes,"AA",30,0,0,.result)

     // find best sequence
     set best = ..Max(.result)
     write "Part 1 answer : ",best,!


    // part 2
    // 
    // find yield of opening valves in all possible sequences for 26 ticks
    do ..Traverse(.graph,.dist,.pressureNodes,"AA",26,0,0,.result2)

    // find best sequences for human and elephant as max(human sequence yield + elephant sequence yield) for all possible sequences)
    set best2 = 0
    set n1 = $order(result2(""))
    while n1 '= "" {
      set b1 = result2(n1)
      set bn1 = $factor(n1)
      set n2 = $order(result2(""))
      while n2 '= "" {
        set bn2 = $factor(n2)        
        if ($bitcount($bitlogic(bn1&bn2),1)) = 0 {  // TODO: check if there is a faster way
          set b2 = result2(n2)
          set t = b1+b2
          set:best2<t best2 = t        
        }
        set n2 = $order(result2(n2))
      }
      set n1 = $order(result2(n1))
    }
    write "Part 2 answer : ",best2,!
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

}
