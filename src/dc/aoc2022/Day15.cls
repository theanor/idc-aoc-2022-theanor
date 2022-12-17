Class dc.aoc2022.Day15 Extends Base
{

ClassMethod Run(fileName As %String = "input15.txt") As %Status
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

/// manhattan distance
ClassMethod Distance(x1 As %Integer, y1 As %Integer, x2 As %Integer, y2 As %Integer) As %Integer
{
  return $zabs(x1-x2)+$zabs(y1-y2)
}

ClassMethod DrawCircleLine(ByRef scan, cx As %Integer, cy As %Integer, r As %Integer, ByRef minx As %Integer, ByRef maxx As %Integer, ByRef miny As %Integer, ByRef maxy As %Integer, targetY As %Integer)
{
  set fy = cy-r
  set ty = cy+r
  if (targetY >= fy) && (targetY <= ty) {
      set y=targetY
      set l = r-$zabs((y-cy))
      set fx = cx-l
      set tx = cx+l
      for x=fx:1:tx {
        set scan(x,y) = "#"
        set:x<minx minx = x
        set:x>maxx maxx = x
        set:y<miny miny = y
        set:y>maxy maxy = y
      }
  }
}

// hahem, very crude : draw diamonds on a grid, restricted to the line we are looking for (targetY)

ClassMethod Part1(inputStream As %Stream.Object) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException
    
    #Dim line as %String        
    #Dim matcher as %Regex.Matcher

    #Dim sx,sy,bx,by as %Integer
    #Dim radius as %Integer

    #Dim minx,miny,maxx,maxy as %Integer
    #Dim targetY as %Integer
    #Dim sensors as %Integer
    #Dim x,pcnt as %Integer


    set sc = $$$OK
    try {        

     set targetY = 2000000
     set minx = 999999
     set miny = 999999
     set maxx = -999999
     set maxy = -999999

     s matcher = ##class(%Regex.Matcher).%New("Sensor at x=(-?[0-9]+), y=(-?[0-9]+): closest beacon is at x=(-?[0-9]+), y=(-?[0-9]+)")

     while 'inputStream.AtEnd {
      set line = inputStream.ReadLine(,.sc)
      $$$TOE(sc,sc)
      set line = $zstrip(line,"<>C")
      if matcher.Match(line) {
        s sx = matcher.Group(1)
        s sy = matcher.Group(2)
        s bx = matcher.Group(3)
        s by = matcher.Group(4)
      } else {
        throw ##class(%Exception.General).%New("invalid input")
      }
      set radius = ..Distance(sx,sy,bx,by)
      do ..DrawCircleLine(.scan,sx,sy,radius,.minx,.maxx,.miny,.maxy,targetY)
      set scan(sx,sy)="S"
      set scan(bx,by)="B"
     }

     set pcnt =0
     for x=minx:1:maxx {
       set:$get(scan(x,targetY))="#" pcnt = pcnt+1
     }
     write "Part 1 answer : ",pcnt,!
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

/// returns true if x,y is in range of any sensor
ClassMethod InRange(ByRef sensors, x As %Integer, y As %Integer, hx As %Integer, hy As %Integer, radius As %Integer) As %Boolean
{
    
  set f=0
  for i=0:1:sensors-1 {
    set d = sensors(i,"r")
    set mx = x+radius
    set:hx<mx mx = hx
    set my = y+radius
    set:hy<my my = hy    
    set f = f || ((..Distance(x,y,sensors(i,"sx"),sensors(i,"sy")) <= d) &&
                (..Distance(mx,y,sensors(i,"sx"),sensors(i,"sy")) <= d) &&
                (..Distance(x,my,sensors(i,"sx"),sensors(i,"sy")) <= d) &&
                (..Distance(mx,my,sensors(i,"sx"),sensors(i,"sy")) <= d))
    quit:f 
  }
  return f
}

// search if for dark spots (not covered by any sensor)

ClassMethod Search(ByRef sensors, ByRef dark, x As %Integer, y As %Integer, hx As %Integer, hy As %Integer, radius As %Integer)
{
  if '..InRange(.sensors,x,y,hx,hy,radius) {
    if radius <= 1 {
     set dark = $get(dark,0)
     set dark(dark,"x") = x
     set dark(dark,"y") = y
     set dark(dark,"r") = radius
     set dark = dark+1
    } else {
     set radius = $number(radius / 2,0)
     do ..Search(.sensors,.dark,x,y,hx,hy,radius)
     do ..Search(.sensors,.dark,x+radius,y,hx,hy,radius)
     do ..Search(.sensors,.dark,x,y+radius,hx,hy,radius)
     do ..Search(.sensors,.dark,x+radius,y+radius,hx,hy,radius)
    }
  }
}

/// in part 2, crude approach would take a very long time to compute
/// searches for dark spots (areas not covered by any sensor) in the specified range (0,4000000),(0,4000000)
ClassMethod Part2(inputStream As %Stream.Object) As %Status
{
  #Dim sc as %Status
  #Dim ex as %Exception.AbstractException
    
  #Dim line as %String
  #Dim matcher as %Regex.Matcher

  #Dim sx,sy,bx,by as %Integer
  #Dim radius as %Integer

  #Dim lx,hx,ly,hy as %Integer
  #Dim sensors as %Integer

  #Dim dark as %Integer
  #Dim f as %Boolean
  #Dim z,i,j as %Integer
  #Dim freq as %Integer

  set sc = $$$OK
  try {        

   set lx = 0
   set hx = 4000000
   set ly = 0
   set hy = 4000000


   set sensors = 0

   while 'inputStream.AtEnd {
    set line = inputStream.ReadLine(,.sc)
    s matcher = ##class(%Regex.Matcher).%New("Sensor at x=(-?[0-9]+), y=(-?[0-9]+): closest beacon is at x=(-?[0-9]+), y=(-?[0-9]+)")

    $$$TOE(sc,sc)
    set line = $zstrip(line,"<>C")
    if matcher.Match(line) {
      s sx = matcher.Group(1)
      s sy = matcher.Group(2)
      s bx = matcher.Group(3)
      s by = matcher.Group(4)
    } else {
      throw ##class(%Exception.General).%New("invalid input")
    }
    set radius = ..Distance(sx,sy,bx,by)     
    set sensors(sensors,"sx") = sx
    set sensors(sensors,"sy") = sy
    set sensors(sensors,"bx") = bx
    set sensors(sensors,"by") = by
    set sensors(sensors,"r") = radius
    set sensors = sensors+1
   }

   set dark=0
   do ..Search(.sensors,.dark,0,0,4000000,4000000,4000000)

   set f=0
   for z = 0:1:dark-1 {
     for i= dark(z,"x"):1:dark(z,"x")+dark(z,"r") {
       for j=dark(z,"y"):1:dark(z,"y")+dark(z,"r") {
         if '..InRange(.sensors,i,j,4000000,4000000,0) {
           set freq = i*4000000+j
           write "Part 2 answer : ",freq,!
           set f=1
           quit
         }
       }
       quit:f
     }
     quit:f
   }
  }
  catch (ex) {
    set sc = ex.AsStatus()
  }
  return sc
}

}
