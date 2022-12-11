Class dc.aoc2022.Day9 Extends Base
{

ClassMethod Run(fileName As %String = "input9.txt") As %Status
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

ClassMethod PrintGrid(ByRef grid, hx, hy, tx, ty)
{
  for row=4:-1:0 {
    for col=0:1:5 {
      if (row=ty)&&(col=tx) {
        write "T"
      } elseif (row=ty)&&(col=hx) {
        write "H"
      } elseif $get(grid(col,row),0) {
        write "#"
      } else {
        write "."
      }          
    }
    write !
  }
}

ClassMethod MoveNode(hx As %Integer, hy As %Integer, ByRef tx As %Integer, ByRef ty As %Integer)
{
          if $zabs(tx-hx) > 1 {
          if tx > hx {
            set tx = tx-1
          } else {
            set tx = tx+1
          }    
          set:ty<hy ty=ty+1
          set:ty>hy ty=ty-1
        }
        if $zabs(ty-hy) > 1 {
          if ty > hy {
            set ty=ty-1
          } else {
            set ty=ty+1
          }     
          set:tx>hx tx=tx-1
          set:tx<hx tx=tx+1    
        }
}

ClassMethod MoveNodeArr(hx As %Integer, hy As %Integer, ByRef tx As %Integer, ByRef ty As %Integer, i As %Integer)
{
  set ttx = tx(i)
  set tty = ty(i)
  do ..MoveNode(hx,hy,.ttx,.tty)
  set tx(i) = ttx
  set ty(i) = tty
}

ClassMethod Part1(inputStream As %Stream.Object) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException
    
    #Dim line as %String

   
    set sc = $$$OK
    try {        
        set hx=0
        set hy=0
        set tx=0
        set ty=0
        set tot=1
        set grid(tx,ty)=1

      while 'inputStream.AtEnd {
        set line = inputStream.ReadLine(,.sc)
        set line = $zstrip(line,"<>C")
        set dir = $piece(line," ",1)
        set steps = $piece(line," ",2)
        set ox = $case(dir,"L":-1,"R":1,:0)
        set oy = $case(dir,"U":1,"D":-1,:0)

        for i=1:1:steps {

        set hx=hx+ox
        set hy=hy+oy
        do ..MoveNode(hx,hy,.tx,.ty)
        if '$get(grid(tx,ty),0) {
          set tot = tot+1
          set grid(tx,ty)=1
        }
        }
      }
      //d ..PrintGrid(.grid,hx,hy,tx,ty)
      write "Part 1 answer : ",tot,!
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

ClassMethod Part2(inputStream As %Stream.Object) As %Status
{
    #Dim line as %String
    #Dim len as %Integer

    set sc = $$$OK
    try {
        set hx=0
        set hy=0
        
        set len=9
        for i = 1:1:len {
          set tx(i) = 0
          set ty(i) = 0
        }
        set tot=1
        set grid(0,0)=1

      while 'inputStream.AtEnd {
        set line = inputStream.ReadLine(,.sc)
        set line = $zstrip(line,"<>C")
        set dir = $piece(line," ",1)
        set steps = $piece(line," ",2)
        set ox = $case(dir,"L":-1,"R":1,:0)
        set oy = $case(dir,"U":1,"D":-1,:0)
        for i=1:1:steps {
        set hx=hx+ox
        set hy=hy+oy

        set nx=hx
        set ny=hy

        for j=1:1:len {
         do ..MoveNodeArr(nx,ny,.tx,.ty,j)
         set nx = tx(j)
         set ny = ty(j)
        }

        if '$get(grid(tx(len),ty(len)),0) {
          set tot = tot+1
          set grid(tx(len),ty(len))=1
        }
        }
      }
      //d ..PrintGrid(.grid,hx,hy,tx,ty)
      write "Part 2 answer : ",tot,!
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

}
