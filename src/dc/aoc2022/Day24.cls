Class dc.aoc2022.Day24 Extends Base
{

ClassMethod Run(fileName As %String = "input24-test.txt") As %Status
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

ClassMethod BuildCellTimes(ByRef grid, ByRef pos, row As %Integer, col As %Integer, period As %Integer)
{
  s cperiod = grid("cols")-2
  for i=1:1:grid("cols")-2 {
    if ($get(grid(row,i))="<") || ($get(grid(row,i))=">") {

      if $get(grid(row,i))="<" {
        s offset = ((i-1)-(col-1)) # cperiod
      } elseif $get(grid(row,i))=">" {
        s offset = ((col-1)-(i-1)) # cperiod
      }      
      s t = offset
      while t < period {
        s pos("h",row,col,t) = 1
        s t = t + cperiod
      }
    }    
  }

  s rperiod = grid("rows")-2
  for i=1:1:grid("rows")-2 {
    if ($get(grid(i,col))="^") || ($get(grid(i,col))="v") {      
      if $get(grid(i,col))="^" {
        s offset = ((i-1)-(row-1)) # rperiod
      } elseif $get(grid(i,col))="v" {
        s offset = ((row-1)-(i-1)) # rperiod
      }
      s t = offset
      while t < period {
        s pos("v",row,col,t) = 1
        s t = t + rperiod
      }
    }    
  }
}

ClassMethod BuildPositions(ByRef grid, ByRef pos, ByRef period)
{
  s period = ..LCM(grid("rows")-2,grid("cols")-2)
  for row=1:1:grid("rows")-2 {
    for col=1:1:grid("cols")-2 {
      d ..BuildCellTimes(.grid,.pos,row,col,period)
    }
  }
}

ClassMethod LCM(a As %Integer, b As %Integer) As %Integer
{
  return:((a=0)||(b=0)) 0
  s aa = $zabs(a)
  s ab = $zabs(b)
  if ab < aa  {
    s z =ab 
    s ab = aa
    s aa = z 
  }
  s result = ab
  while ((result # aa) '= 0) {
    s result = result + ab
  }
  return result
}

ClassMethod Neighbours(node As %List, ByRef grid, ByRef pos, period As %Integer) As %List
{
  s dirs = $lb($lb(-1,0),$lb(1,0),$lb(0,-1),$lb(0,1),$lb(0,0))

  s t0 = $listget(node,1)
  s row = $listget(node,2)
  s col = $listget(node,3)
  
  s t1 = t0 + 1
  s t1p = t1 # period
  s result = ""

  s dp = 0
  while $listnext(dirs,dp,dir) {
    s dy = $listget(dir,1)
    s dx = $listget(dir,2)
    s scol = col+dx
    s srow = row+dy
    if (scol >= 0) && (scol < grid("cols")) && (srow >=0) && (srow < grid("rows")) && ($get(grid(srow,scol))'="#") && '$get(pos("h",srow,scol,t1p),0) && '$get(pos("v",srow,scol,t1p),0) {
      s $list(result,*+1) = $lb(t1,srow,scol)
    }    
  }  
  return result
}

ClassMethod SearchPath(ByRef grid, ByRef pos, period As %Integer, t As %Integer, srow As %Integer, scol As %Integer, erow As %Integer, ecol As %Integer) As %Integer
{
  s curNode = $lb(t,srow,scol)
  s q = $listbuild(curNode)
  s visited(t,srow,scol)=1
  while $listlength(q) > 0 {    
    s curNode = $listget(q,1)
    s q = $list(q,2,*)
    return:(($listget(curNode,2)=erow)&&($listget(curNode,3)=ecol)) $listget(curNode,1)
    s neighbours = ..Neighbours(curNode,.grid,.pos,period) 
    s pn = 0
    while $listnext(neighbours,pn,neighbour) {
      if '$get(visited($listget(neighbour,1),$listget(neighbour,2),$listget(neighbour,3)),0) {
        s $list(q,*+1) = neighbour
        s visited($listget(neighbour,1),$listget(neighbour,2),$listget(neighbour,3)) = 1
      }
    }
  }
  return -999
}

ClassMethod DrawGrid(ByRef grid)
{
  for row=0:1:grid("rows")-1 {
    for col=0:1:grid("cols")-1 {
      w grid(row,col)
    }
    w !
  }
}

ClassMethod Part1And2(inputStream As %Stream.Object) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException
    
    #Dim line as %String

   
    set sc = $$$OK
    try {        
      s row = 0
      while ('inputStream.AtEnd)
      {
        set line = inputStream.ReadLine(,.sc)
        set line = $zstrip(line,"<>C")
        s col = 0
        for i=1:1:$length(line) {
          s c = $extract(line,i,i)
          s grid(row,col) = c
          s col = col+1
        }
        s row = row+1
      }
      s grid("rows") = row
      s grid("cols") = $length(line)

      // find start
      s srow = 0
      for scol=0:1:grid("cols")-1 {
        quit:$get(grid(srow,scol),".")="." 
      }

      // find exit
      s erow = grid("rows")-1
      for ecol=0:1:grid("cols")-1 {
        quit:$get(grid(erow,ecol),".")="." 
      }
      

      d ..BuildPositions(.grid,.pos,.period)


      s t = ..SearchPath(.grid,.pos,period,0,srow,scol,erow,ecol)
      write "Part 1 answer : ",t,!

      s tb = ..SearchPath(.grid,.pos,period,t,erow,ecol,srow,scol)
      s tr = ..SearchPath(.grid,.pos,period,tb,srow,scol,erow,ecol)

      write "Part 2 answer : ",tr,!
      
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

}
