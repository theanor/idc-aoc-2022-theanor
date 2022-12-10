Class dc.aoc2022.Day9 Extends Base
{

ClassMethod Run(fileName As %String = "input9.txt") As %Status
{
    #Dim sc as %Status
    #Dim ex 
    #Dim inputStream as %Stream.Object
    
    Set sc = $$$OK
    Try {
        Set inputStream = ..GetInputStream(fileName,.sc)
        $$$TOE(sc,sc)
        $$$TOE(sc,..Part1(inputStream))
        $$$TOE(sc,inputStream.Rewind())
        $$$TOE(sc,..Part2(inputStream))
    }
    Catch (ex) {
      Set sc = ex.AsStatus()
    }
    Return sc
}

ClassMethod PrintGrid(ByRef grid, hx, hy, tx, ty)
{
  For row=4:-1:0 {
    For col=0:1:5 {
      If (row=ty)&&(col=tx) {
        Write "T"
      } ElseIf (row=ty)&&(col=hx) {
        Write "H"
      } ElseIf $GET(grid(col,row),0) {
        Write "#"
      } Else {
        Write "."
      }          
    }
    Write !
  }
}

ClassMethod MoveNode(hx As %Integer, hy As %Integer, ByRef tx As %Integer, ByRef ty As %Integer)
{
          If $ZABS(tx-hx) > 1 {
          If tx > hx {
            Set tx = tx-1
          } Else {
            Set tx = tx+1
          }    
          Set:ty<hy ty=ty+1
          Set:ty>hy ty=ty-1
        }
        If $ZABS(ty-hy) > 1 {
          If ty > hy {
            Set ty=ty-1
          } Else {
            Set ty=ty+1
          }     
          Set:tx>hx tx=tx-1
          Set:tx<hx tx=tx+1    
        }
}

ClassMethod MoveNodeArr(hx As %Integer, hy As %Integer, ByRef tx As %Integer, ByRef ty As %Integer, i As %Integer)
{
  Set ttx = tx(i)
  Set tty = ty(i)
  Do ..MoveNode(hx,hy,.ttx,.tty)
  Set tx(i) = ttx
  Set ty(i) = tty
}

ClassMethod Part1(inputStream As %Stream.Object) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException
    
    #Dim line as %String

   
    Set sc = $$$OK
    Try {        
        Set hx=0
        Set hy=0
        Set tx=0
        Set ty=0
        Set tot=1
        Set grid(tx,ty)=1

      While 'inputStream.AtEnd {
        Set line = inputStream.ReadLine(,.sc)
        Set line = $ZSTRIP(line,"<>C")
        Set dir = $PIECE(line," ",1)
        Set steps = $PIECE(line," ",2)
        Set ox = $CASE(dir,"L":-1,"R":1,:0)
        Set oy = $CASE(dir,"U":1,"D":-1,:0)

        For i=1:1:steps {

        Set hx=hx+ox
        Set hy=hy+oy
        Do ..MoveNode(hx,hy,.tx,.ty)
        If '$GET(grid(tx,ty),0) {
          Set tot = tot+1
          Set grid(tx,ty)=1
        }
        }
      }
      //d ..PrintGrid(.grid,hx,hy,tx,ty)
      Write "Part 1 answer : ",tot,!
    }
    Catch (ex) {
      Set sc = ex.AsStatus()
    }
    Return sc
}

ClassMethod Part2(inputStream As %Stream.Object) As %Status
{
    #Dim line as %String
    #Dim len as %Integer

    Set sc = $$$OK
    Try {
        Set hx=0
        Set hy=0
        
        Set len=9
        For i = 1:1:len {
          Set tx(i) = 0
          Set ty(i) = 0
        }
        Set tot=1
        Set grid(0,0)=1

      While 'inputStream.AtEnd {
        Set line = inputStream.ReadLine(,.sc)
        Set line = $ZSTRIP(line,"<>C")
        Set dir = $PIECE(line," ",1)
        Set steps = $PIECE(line," ",2)
        Set ox = $CASE(dir,"L":-1,"R":1,:0)
        Set oy = $CASE(dir,"U":1,"D":-1,:0)
        For i=1:1:steps {
        Set hx=hx+ox
        Set hy=hy+oy

        Set nx=hx
        Set ny=hy

        For j=1:1:len {
         Do ..MoveNodeArr(nx,ny,.tx,.ty,j)
         Set nx = tx(j)
         Set ny = ty(j)
        }

        If '$GET(grid(tx(len),ty(len)),0) {
          Set tot = tot+1
          Set grid(tx(len),ty(len))=1
        }
        }
      }
      //d ..PrintGrid(.grid,hx,hy,tx,ty)
      Write "Part 2 answer : ",tot,!
    }
    Catch (ex) {
      Set sc = ex.AsStatus()
    }
    Return sc
}

}
