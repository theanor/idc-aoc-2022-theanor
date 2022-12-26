Class dc.aoc2022.Day14 Extends Base
{

ClassMethod Run(fileName As %String = "input14-test.txt") As %Status
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
  #Dim x,y As %Integer
  
  for y=0:1:scan("height")-1 {
   for x=0:1:scan("width")-1 {
    write $get(scan(x,y),".")
   }
   write !
  }
  write "height=",scan("height")," width=",scan("width"),!
}

ClassMethod ParseInput1(inputStream As %Stream.Object, ByRef scan) As %Status
{
  #Dim sc as %Status = $$$OK
  #Dim ex as %Exception.AbstractException
  
  try {
      s miny = ..#MAXINT
      s minx = ..#MAXINT
      s maxy = -..#MAXINT
      s maxx = -..#MAXINT      
      while ('inputStream.AtEnd)
      {
        set line = inputStream.ReadLine(,.sc)
        set line = $zstrip(line,"<>C")
        set points = $listfromstring(line,"->")        
        set ptr = 0          
        s next = $listnext(points,ptr,point)        
        set x1=$zstrip($piece(point,",",1),"<>W"),y1=$zstrip($piece(point,",",2),"<>W")        
        set:y1>maxy maxy = y1        
        set:y1<miny miny = y1
        set:x1>maxx maxx = x1
        set:x1<minx minx = x1        
        while $listnext(points,ptr,point) {
         set x2 = $zstrip($piece(point,",",1),"<>W")
         set y2 = $zstrip($piece(point,",",2),"<>W")
         set:y2>maxy maxy = y2        
         set:y2<miny miny = y2
         set:x2>maxx maxx = x2
         set:x2<minx minx = x2        
         set x1=x2
         set y1=y2
        }
      }
      s scan("height") = maxy+1
      s scan("width") = (maxx-minx)+1
      s scan("minx") = minx
      s scan("maxx") = maxx
      s scan("miny") = miny
      s scan("maxy") = maxy


      for x=0:1:scan("width")-1 {
        for y=0:1:scan("height")-1 {
          s scan(x,y)="."
        }
      }
      $$$TOE(sc,inputStream.Rewind())
      while ('inputStream.AtEnd)
      {
        set line = inputStream.ReadLine(,.sc)
        set line = $zstrip(line,"<>C")
        set points = $listfromstring(line,"->")        
        set ptr = 0          
        s next = $listnext(points,ptr,point)        
        set x1=$zstrip($piece(point,",",1),"<>W"),y1=$zstrip($piece(point,",",2),"<>W")        
        s x1 = x1 - minx
        

        while $listnext(points,ptr,point) {
         set x2 = $zstrip($piece(point,",",1),"<>W")
         set y2 = $zstrip($piece(point,",",2),"<>W")

         s x2 = x2 - minx
        
         
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
        }
      }
  } catch (ex) {
    s sc = ex.AsStatus()
  }
  q sc
}

ClassMethod ParseInput2(inputStream As %Stream.Object, ByRef scan) As %Status
{
  #Dim sc as %Status = $$$OK
  #Dim ex as %Exception.AbstractException
  
  try {
      s miny = ..#MAXINT
      s minx = ..#MAXINT
      s maxy = -..#MAXINT
      s maxx = -..#MAXINT      
      while ('inputStream.AtEnd)
      {
        set line = inputStream.ReadLine(,.sc)
        set line = $zstrip(line,"<>C")
        set points = $listfromstring(line,"->")        
        set ptr = 0          
        s next = $listnext(points,ptr,point)        
        set x1=$zstrip($piece(point,",",1),"<>W"),y1=$zstrip($piece(point,",",2),"<>W")        
        set:y1>maxy maxy = y1        
        set:y1<miny miny = y1
        set:x1>maxx maxx = x1
        set:x1<minx minx = x1        
        while $listnext(points,ptr,point) {
         set x2 = $zstrip($piece(point,",",1),"<>W")
         set y2 = $zstrip($piece(point,",",2),"<>W")
         set:y2>maxy maxy = y2        
         set:y2<miny miny = y2
         set:x2>maxx maxx = x2
         set:x2<minx minx = x2        
         set x1=x2
         set y1=y2
        }
      }
      s scan("height") = maxy+3
      s scan("width") = maxx+2*scan("height")
      s scan("minx") = minx
      s scan("maxx") = maxx
      s scan("miny") = miny
      s scan("maxy") = maxy


      for x=0:1:scan("width")-1 {
        for y=0:1:scan("height")-1 {
          s scan(x,y)="."
        }
      }
      for x=0:1:scan("width")-1 {
        s scan(x,scan("height")-1)="#"
      }
      $$$TOE(sc,inputStream.Rewind())
      while ('inputStream.AtEnd)
      {
        set line = inputStream.ReadLine(,.sc)
        set line = $zstrip(line,"<>C")
        set points = $listfromstring(line,"->")        
        set ptr = 0          
        s next = $listnext(points,ptr,point)        
        set x1=$zstrip($piece(point,",",1),"<>W"),y1=$zstrip($piece(point,",",2),"<>W")        
        s x1 = x1 
        

        while $listnext(points,ptr,point) {
         set x2 = $zstrip($piece(point,",",1),"<>W")
         set y2 = $zstrip($piece(point,",",2),"<>W")

         s x2 = x2 
         
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
    #Dim sx,sy As %Integer
    #Dim cnt As %Integer
    #Dim settled As %Boolean

   
    set sc = $$$OK
    try {    
         
      $$$TOE(sc,..ParseInput1(inputStream,.scan))
      s cnt = 0        
      while(1) {
        s sx = 500-scan("minx")
        s sy = 0
        s settled = 0
        s cnt = cnt+1
        while (sx >=0) && (sx < scan("width")) && (sy < scan("height")) {
          if $data(scan(sx,sy+1)) && (scan(sx,sy+1) '= "#") {
            s sy = sy+1
          } else {
            if (sy=(scan("height")-1)) || (sx=0) || (sx=(scan("width")-1)) {
              quit
            } else {
              if (scan(sx-1,sy+1) '= "#") {
                s sx = sx-1
                s sy = sy+1
              } elseif (scan(sx+1,sy+1) '= "#") {
                s sx=sx+1
                s sy=sy+1
              } else {
                s scan(sx,sy)="#"
                s settled = 1        
                quit
              }
            }
          }
        }
        quit:'settled
      }      
      write "Part 1 answer : ",cnt-1,!      
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
    #Dim sx,sy As %Integer
    #Dim cnt As %Integer
    #Dim settled As %Boolean

   
    set sc = $$$OK
    try {    

      $$$TOE(sc,..ParseInput2(inputStream,.scan))
      s cnt = 0        
      while(1) {
        s sx = 500
        s sy = 0
        s cnt = cnt+1
        while (1) {
          if $data(scan(sx,sy+1)) && (scan(sx,sy+1) '= "#") {
            s sy = sy+1
          } else {
              if $get(scan(sx-1,sy+1)) '= "#" {
                s sx = sx-1
                s sy = sy+1
              } elseif $get(scan(sx+1,sy+1)) '= "#" {
                s sx=sx+1
                s sy=sy+1
              } else {
                s scan(sx,sy)="#"
                quit
              }
          }
        }
        quit:(sy=0)
      }      
      write "Part 2 answer : ",cnt,!      
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

}
