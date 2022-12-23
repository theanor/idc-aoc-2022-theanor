Class dc.aoc2022.Day14 Extends Base
{

ClassMethod Run(fileName As %String = "input14.txt") As %Status
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

ClassMethod DrawScan(ByRef scan)
{
  #Dim minx,miny,maxx,maxy,x,y As %Integer
  
  set minx=..#MAXINT
  set miny=..#MAXINT
  set maxx=-..#MAXINT
  set maxy=-..#MAXINT

  set x=$order(scan(""))
  while x '= "" {
    set y=$order(scan(x,""))
    while y '= "" {
      set:x<minx minx=x
      set:x>maxx maxx=x
      set:y<miny miny=y
      set:y>maxy maxy=y      
      set y = $order(scan(x,y))
    }
    set x = $order(scan(x))
  }
  for y=miny:1:maxy {
   for x=minx:1:maxx {
    write $get(scan(x,y),".")
   }
   write !
  }
}

ClassMethod Scan(inputStream As %Stream.Object, ByRef scan, Output maxy As %Integer) As %Status
{
  #Dim sc as %Status
  #Dim ex as %Exception.AbstractException

  #Dim line as %String
  #Dim points as %List
  #Dim point as %String
  #Dim x1,y1,x2,y2 As %Integer
  #Dim d As %Integer
  #Dim ptr As %Integer
  
  s sc = $$$OK
  try {
      while ('inputStream.AtEnd)
      {
        set line = inputStream.ReadLine(,.sc)
        set line = $zstrip(line,"<>C")        
        set points = $listfromstring(line,"->")        
        if $listlength(points) > 0 {
        set ptr = 0
        set point = $listget(points,1)
        set x1=$zstrip($piece(point,",",1),"<>W")
        set y1=$zstrip($piece(point,",",2),"<>W")
        set maxy=-..#MAXINT
        s pi = 2
        while pi <= $listlength(points) {
         s point = $listget(points,pi) 
         set x2 = $zstrip($piece(point,",",1),"<>W")
         set y2 = $zstrip($piece(point,",",2),"<>W")
         set:y2>maxy maxy = y2
         if x1=x2 {
          set d = $select(y1<=y2:1,1:-1)
          for y=y1:d:y2 {
            set scan(x1,y) = "#"
          }
         }
         if y1=y2 {
          set d = $select(x1<=x2:1,1:-1)
          for x=x1:d:x2 {
            set scan(x,y1) = "#"
          }            
         }
         set x1=x2
         set y1=y2
         set pi = pi +1
        }
      }
     }
  } catch (ex) {
    s sc = ex.AsStatus()
  }
  q sc
}

ClassMethod Part1(inputStream As %Stream.Object) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException
    
    #Dim scan
    #Dim maxy As %Integer
    #Dim ox,oy,sx,sy,nx,ny As %Integer
    #Dim restCnt As %Integer
    #Dim falling As %Boolean

   
    set sc = $$$OK
    try {    
         
      $$$TOE(sc,..Scan(inputStream,.scan,.maxy))      

      set ox=500,oy=0
      set scan(ox,oy) = "+"
      set sy=oy,sx=ox
      set restCnt = 0
      
      while sy<=maxy {
       set falling=1
       while (sy<=maxy) && falling {
         set scan(sx,sy)="+"         
         if $get(scan(sx,sy+1)," ")=" " {
          set nx = sx
          set ny = sy+1
         } elseif $get(scan(sx-1,sy+1)," ")=" " {
          set nx=sx-1,ny=sy+1
         } elseif $get(scan(sx+1,sy+1)," ")=" " {
          set nx=sx+1,ny=sy+1
         } else {
          set falling=0
         }
         if falling {
          set scan(sx,sy)=" ",sx=nx,sy=ny
         } else {
          set scan(sx,sy) = "o"
          s restCnt = restCnt+1
          s sx=ox,sy=oy
          quit
         }
       }

      }
      
      write "Part 1 answer : ",restCnt,!
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

ClassMethod Part2(inputStream As %Stream.Object) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException
    
    #Dim scan
    #Dim maxy As %Integer
    #Dim ox,oy,sx,sy,nx,ny As %Integer
    #Dim restCnt As %Integer
    #Dim falling As %Boolean

   
    set sc = $$$OK
    try {    

      $$$TOE(sc,..Scan(inputStream,.scan,.maxy))
         
      set ox=500,oy=0
      set scan(ox,oy) = "+"      
      set sy=oy,sx=ox
      set restCnt = 0
      
      while $get(scan(ox,oy)) '= "o" {
       set falling=1
       while (sy<=(maxy+1)) && falling {
         set scan(sx,sy)="+"
         if (sy=(maxy+1)) {
          set scan(sx,sy)="o"
          set falling=0
          set restCnt = restCnt+1
          set sx=ox,sy=oy
          quit
         }
         if $get(scan(sx,sy+1)," ")=" " {
          set nx = sx,ny = sy+1
         } elseif $get(scan(sx-1,sy+1)," ")=" " {
          set nx=sx-1,ny=sy+1
         } elseif $get(scan(sx+1,sy+1)," ")=" " {
          set nx=sx+1,ny=sy+1
         } else {
          set falling=0
         }
         if falling {
          set scan(sx,sy)=" "
          set sx = nx,sy = ny        
         } else {
          set scan(sx,sy) = "o"
          set restCnt = restCnt+1
          set sx=ox,sy=oy
          quit
         }
       }

      }      
      write "Part 2 answer : ",restCnt,!
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

}
