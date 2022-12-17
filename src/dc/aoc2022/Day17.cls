Class dc.aoc2022.Day17 Extends Base
{

ClassMethod Run(fileName As %String = "input17.txt") As %Status
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

ClassMethod BuildShapes(ByRef shapes)
{
  s shapes = 5
  // - shape
  s shapes(0,"w") = 4
  s shapes(0,"h") = 1
  s shapes(0,0,0) = "@"
  s shapes(0,1,0) = "@"
  s shapes(0,2,0) = "@"
  s shapes(0,3,0) = "@"

  // + shape
  s shapes(1,"w") = 3
  s shapes(1,"h") = 3
  s shapes(1,0,0) = "."
  s shapes(1,1,0) = "@"
  s shapes(1,2,0) = "."
  s shapes(1,0,1) = "@"
  s shapes(1,1,1) = "@"
  s shapes(1,2,1) = "@"
  s shapes(1,0,2) = "."
  s shapes(1,1,2) = "@"
  s shapes(1,2,2) = "."

  // L shape
  s shapes(2,"w") = 3
  s shapes(2,"h") = 3
  s shapes(2,0,0) = "."
  s shapes(2,1,0) = "."
  s shapes(2,2,0) = "@"
  s shapes(2,0,1) = "."
  s shapes(2,1,1) = "."
  s shapes(2,2,1) = "@"
  s shapes(2,0,2) = "@"
  s shapes(2,1,2) = "@"
  s shapes(2,2,2) = "@"

  // I shape
  s shapes(3,"w") = 1
  s shapes(3,"h") = 4
  s shapes(3,0,0) = "@"
  s shapes(3,0,1) = "@"
  s shapes(3,0,2) = "@"
  s shapes(3,0,3) = "@"

  // # shape
  s shapes(4,"w") = 2
  s shapes(4,"h") = 2  
  s shapes(4,0,0) = "@"
  s shapes(4,1,0) = "@"
  s shapes(4,0,1) = "@"
  s shapes(4,1,1) = "@"
}

ClassMethod Part1(inputStream As %Stream.Object) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException
    
    #Dim line as %String

   
    set sc = $$$OK
    try {        

      while ('inputStream.AtEnd)
      {
        set line = inputStream.ReadLine(,.sc)
        set line = $zstrip(line,"<>C")
        quit        
      }


      d ..BuildShapes(.shapes)

      s grid("jets") = line
      s grid("jet") = 0
      s grid("h") = 0
      s grid("w") = 7
      s grid("turn") = 0
      d ..Iterate(.grid,.shapes,2022)

      write "Part 1 answer : ",grid("h"),!
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

ClassMethod DrawGrid(ByRef grid)
{
  for y=grid("h")-1:-1:0 {
    for x=0:1:grid("w")-1 {
      write $get(grid(x,y),".")
    }
    write !
  }
}

ClassMethod AddShape(ByRef grid, ByRef shapes, shape As %Integer, x As %Integer, y As %Integer)
{
  for sx = 0:1:shapes(shape,"w")-1 {
    for sy = shapes(shape,"h")-1:-1:0 {
      if shapes(shape,sx,sy)="@" {
        s grid(x+sx,y-sy) = "#"
        s:(y-sy)>=grid("h") grid("h")=(y-sy)+1
      }      
    }
  }
}

ClassMethod IsBlocked(ByRef grid, ByRef shapes, shape As %Integer, x As %Integer, y As %Integer) As %Boolean
{
  s w = shapes(shape,"w")
  s h = shapes(shape,"h")

  s blocked = 0
  for sx = 0:1:shapes(shape,"w")-1 {
    for sy = shapes(shape,"h")-1:-1:0 {
      if shapes(shape,sx,sy)="@" {
        s blocked = $select((x+sx)<0:1,(x+sx)>(grid("w")-1):1,(y-sy)<0:1,$get(grid(x+sx,y-sy),".")="#":1,1:0)
        quit:blocked        
      }      
     quit:blocked        
    }
   quit:blocked        
  }
  return blocked
}

ClassMethod Iterate(ByRef grid, ByRef shapes, turns As %Integer, stopAtCycle As %Boolean = 0)
{
      s jl=$length(grid("jets"))

    
      s i=0

      while i < turns {

       quit:(stopAtCycle && (grid("jet")=0) && (i > 0))

        s shape = grid("turn") # shapes

        s shapex = 2
        s shapey = grid("h")+shapes(shape,"h")+2

        while 1 {


         s jetdir = $extract(grid("jets"),grid("jet")+1,grid("jet")+1)
         s grid("jet") = (grid("jet")+1) # jl



         if jetdir = ">" {
          if '..IsBlocked(.grid,.shapes,shape,shapex+1,shapey) {
            s shapex = shapex + 1
          }
         } elseif jetdir = "<" {
          if '..IsBlocked(.grid,.shapes,shape,shapex-1,shapey) > 0 {
            s shapex = shapex - 1
          }
         }  
         quit:..IsBlocked(.grid,.shapes,shape,shapex,shapey-1)
         s shapey=shapey-1
        }
        d ..AddShape(.grid,.shapes,shape,shapex,shapey)
        s grid("turn") = grid("turn") + 1
        s i = i + 1
      }
}

ClassMethod Part2(inputStream As %Stream.Object) As %Status
{
    #Dim line as %String

    set sc = $$$OK
    try {        

      while ('inputStream.AtEnd)
      {
        set line = inputStream.ReadLine(,.sc)
        set line = $zstrip(line,"<>C")
        quit        
      }


      d ..BuildShapes(.shapes)

      write "jets=",$length(line),!

      s grid("jets") = line
      s grid("jet") = 0
      s grid("h") = 0
      s grid("w") = 7
      s grid("turn") = 0

      s rocks = 1000000000000
      write "rocks=",rocks,!

      
      d ..Iterate(.grid,.shapes,rocks,1)
      s fh = grid("h")
      s ft = grid("turn")

      d ..Iterate(.grid,.shapes,rocks,1)
      s ch = grid("h")
      s ct = grid("turn")

      s cycleHeight = ch-fh

      s cycleTurns = ct-ft
      s cycleCount = (rocks-ft) \ cycleTurns

      write "ft=",ft,!
      write "cycleHeight=",cycleHeight,!
      write "cycleTurns=",cycleTurns,!
      write "cycleCount=",cycleCount,!

      s rturns = rocks-(cycleCount*cycleTurns)-ft
      write "rturns=",rturns,!

      d ..Iterate(.grid,.shapes,rturns,0)

      s lh = grid("h")-ch
      s lt = grid("turn")-ct


      write "lh=",lh,!
      write "lt=",lt,!

      write ft+(cycleTurns*cycleCount)+rturns,!

      s totalHeight = fh+(cycleHeight*cycleCount)+lh

      write "Part 2 answer : ",totalHeight,!

      


      

      //d ..Iterate(.grid,.shapes,rocks,0)
      //s lh = grid("h")
      //s lt = grid("turn")


      /*
      s firstHeight = grid("h")
      s firstRocks = grid("turn")

      write "firstHeight=",firstHeight,!
      write "firstRocks=",firstRocks,!

      d ..Iterate(.grid,.shapes,rocks,1)      
      s cycleHeight = grid("h")-firstHeight
      s cycleRocks = grid("turn")-firstRocks



      write "cycleHeight=",cycleHeight,!
      write "cycleRocks=",cycleRocks,!
      
      s cycles = (rocks-firstRocks) \ cycleRocks

      write "cycles=",cycles,!

      s totalRocks = (cycleRocks*cycles)+firstRocks
      s totalHeight = (cycleHeight*cycles)+firstHeight
      s exceedRocks = totalRocks-rocks
      write "exceedRocks=",exceedRocks,!

      d ..Iterate(.grid,.shapes,firstRocks-exceedRocks,0)      
      
      s totalHeight = totalHeight-(firstHeight-grid("h"))
 
      

      

      //d ..Iterate(.grid,.shapes,lastRocks)
      // s totalHeight = (cycles*cycleHeight)-

      write "Part 2 answer : ",totalHeight,!
      */


    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

}
