Class dc.aoc2022.Day12 Extends Base
{

ClassMethod Run(fileName As %String = "input12.txt") As %Status
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

ClassMethod AddSucc(ByRef graph, row As %Integer, col As %Integer, tgtRow As %Integer, tgtCol As %Integer, rowCnt As %Integer, colCnt As %Integer) As %Status
{
  #Dim sc as %Status
  #Dim ex as %Exception.AbstractException

  #Dim tgtNode,node,diff As %Integer
  #Dim alt As %String
  
  set sc = $$$OK
  try {
    set tgtNode = tgtRow*colCnt+tgtCol
    set node = row*colCnt+col
    if (tgtNode >= 0) && (tgtNode < (rowCnt*colCnt)) && (node >= 0) && (node < (rowCnt*colCnt)) {
      set alt = graph(node,"alt")
      set tgtAlt = graph(tgtNode,"alt")           
      set diff = $ascii(tgtAlt)-$ascii(alt)
      if (diff <= 1) {                
           set $list(graph(node,"succ"),*+1) = tgtNode
      }           
    }
  } catch (ex) {
    set sc = ex.AsStatus()
  }
  quit sc
}

/// An overkill to use Dijkstra alg. (graph shortest path) to solve this puzzle :) 
/// I started with this directly for Part 1 as I expected something more complex for Part 2 ^^
ClassMethod ShortestPath(ByRef graph, startNode As %Integer, endNode As %Integer, rowCnt As %Integer, colCnt As %Integer, ByRef seq As %List)
{
  #Dim sc as %Status
  #Dim ex as %Exception.AbstractException

  #Dim thisNode,lastNode,neighbour as %Integer 
  #Dim queue,neighbours as %List
  #Dim dist,prev as %Integer
  #Dim i,nodeIdx,vidx,da as %Integer
  #Dim minDist as %Integer
  #Dim ptr as %Integer


  
  set sc = $$$OK
  try {

      set lastNode = (colCnt*rowCnt)-1
      for nodeIdx=0:1:lastNode {
        set dist(nodeIdx) = 9999999
        set prev(nodeIdx) = ""        
        set $list(queue,*+1) = nodeIdx
      }

      set dist(startNode) = 0   

      while $listlength(queue) > 0 {         

       kill minDist
       set i=0
       set ptr=0
       while $listnext(queue,ptr,thisNode) {
        set i = i+1
        if $data(minDist) {
          if dist(thisNode) < minDist {
            set minDist = dist(thisNode)
            set node = thisNode
            set nodeIdx = i
          }
        } else {
          set minDist = dist(thisNode)        
          set node = thisNode
          set nodeIdx = i
        }        
       }

       quit:node=endNode

       set queue = $list(queue,1,nodeIdx-1)_$list(queue,nodeIdx+1,*)                    
       set neighbours = graph(node,"succ")          

       set ptr=0
       while $listnext(neighbours,ptr,neighbour) {
         set vidx = $listfind(queue,neighbour)
         if vidx > 0 {
           set da = dist(node)+1
           if da < dist(neighbour) {
             set dist(neighbour) = da
             set prev(neighbour) = node
           }
         }
       }       
      }          
      set seq = ""
      set node = endNode
      if (prev(node) '= "") || (node = startNode) {
        while node '= "" {
          set $list(seq,*+1) = node
          set node = prev(node)
        }
      }
    
  } catch (ex) {
    set sc = ex.AsStatus()
  }
  quit sc
}

ClassMethod Part1And2(inputStream As %Stream.Object) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException
    
    #Dim graph as %Integer

    #Dim line as %String
    #Dim rowCnt,colCnt as %Integer
    #Dim i as %Integer
    #Dim startNode,endNode,node as %Integer

    #Dim steps,minSteps as %Integer
    #Dim seq as %List


   
    set sc = $$$OK
    try {   

      set rowCnt = 0

      while ('inputStream.AtEnd) {
        set line = inputStream.ReadLine(,.sc)
        set line = $zstrip(line,"<>C")
        set colCnt = $length(line)
        set rowCnt = rowCnt + 1
        for i = 1:1:colCnt {          
          set alt = $extract(line,i,i)
          set node = (rowCnt-1)*colCnt+(i-1)
          if alt="S" {
            set graph(node,"alt") = "a"
            set startNode = node
          } elseif alt="E" {
            set graph(node,"alt") = "z"
            set endNode = node
          } else {
            set graph(node,"alt") = alt
          }
          set graph(node,"succ") = ""
        }
      }

      for row=0:1:rowCnt-1 {
        for col=0:1:colCnt-1 {
          do ..AddSucc(.graph,row,col,row-1,col,rowCnt,colCnt)
          do ..AddSucc(.graph,row,col,row+1,col,rowCnt,colCnt)
          do ..AddSucc(.graph,row,col,row,col-1,rowCnt,colCnt)
          do ..AddSucc(.graph,row,col,row,col+1,rowCnt,colCnt)
        }
      }

      write "start node : ",startNode,!
      write "end node : ",endNode,!

      do ..ShortestPath(.graph,startNode,endNode,rowCnt,colCnt,.seq)
      write "Part 1 answer : ",$listlength(seq)-1,!

      set minSteps = 999999
      for i=0:1:(rowCnt*colCnt)-1 {
        if graph(i,"alt") = "a" {
          write "row ",i\colCnt," col ",i#colCnt," "
          kill seq
          do ..ShortestPath(.graph,i,endNode,rowCnt,colCnt,.seq)
          if seq'="" {
            set steps = $listlength(seq)-1
            write steps," steps",!
            set:steps<minSteps minSteps = steps          
          } else {
            write "no path",!
          }
        }
      }
      write "Part 2 answer : ",minSteps,!
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

}
