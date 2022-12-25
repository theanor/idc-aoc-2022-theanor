Class dc.aoc2022.Day23 Extends Base
{

ClassMethod Run(fileName As %String = "input23.txt") As %Status
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

ClassMethod ParseInput(inputStream As %Stream.Object, ByRef grid) As %Status
{
  #Dim ex as %Exception.AbstractException
  #Dim sc as %Status

  #Dim row,col as %Integer
  #Dim line,c as %String
  #Dim ln as %Integer

  
  set sc = $$$OK
  try {
      set row = 0
      while ('inputStream.AtEnd)
      {
        set line = inputStream.ReadLine(,.sc)
        set line = $zstrip(line,"<>C")
        set row = row+1
        set ln = $length(line)
        set:ln>$get(grid("maxCol"),-..#MAXINT) grid("maxCol") = ln
        for col=1:1:ln {
          set c =$extract(line,col,col)          
          set:c="#" grid(row,col) = c
        }        
      }
      set grid("minRow")=1
      set grid("maxRow")=row
      set grid("minCol")=1

  } catch (ex) {
    set sc = ex.AsStatus()
  }
  quit sc
}

ClassMethod CountEmptyCells(ByRef grid) As %Integer
{
  #Dim minRow,maxRow,minCol,maxCol,row,col as %Integer
  
  set cnt = 0
  set minRow = grid("minRow")
  set grid("minRow") = ..#MAXINT
  set maxRow = grid("maxRow")
  set grid("maxRow") = -..#MAXINT

  set minCol = grid("minCol")
  set grid("minCol") = ..#MAXINT
  set maxCol = grid("maxCol")
  set grid("maxCol") = -..#MAXINT
  for row=minRow:1:maxRow
  {
    for col=minCol:1:maxCol {
      if $get(grid(row,col),".")="#" {        
        set:row<grid("minRow") grid("minRow") = row
        set:row>grid("maxRow") grid("maxRow") = row
        set:col<grid("minCol") grid("minCol") = col
        set:col>grid("maxCol") grid("maxCol") = col
      }    
    }  
  }
  for row=grid("minRow"):1:grid("maxRow")
  {
    for col=grid("minCol"):1:grid("maxCol") {
      set:$get(grid(row,col),".")="." cnt = cnt +1
    }    
  }  
  return cnt
}

ClassMethod Directions(ByRef directions)
{
  set directions("N","dy") = -1
  set directions("N","dx") = 0
  set directions("S","dy") = 1
  set directions("S","dx") = 0
  set directions("W","dy") = 0
  set directions("W","dx") = -1
  set directions("E","dy") = 0
  set directions("E","dx") = 1
  set directions("NW","dy") = -1
  set directions("NW","dx") = -1
  set directions("NE","dy") = -1
  set directions("NE","dx") = 1
  set directions("SW","dy") = 1
  set directions("SW","dx") = -1
  set directions("SE","dy") = 1
  set directions("SE","dx") = 1
}

ClassMethod CountNeighbours(ByRef grid, ByRef directions, row As %Integer, col As %Integer, dirs As %List) As %Integer
{
  set cnt = 0
  set ptr = 0
  while $listnext(dirs,ptr,dir) {
    set:$get(grid(row+directions(dir,"dy"),col+directions(dir,"dx")),"")="#" cnt = cnt + 1
  }
  return cnt
}

ClassMethod PlayTurn(ByRef grid, ByRef directions, ByRef rotation) As %Integer
{
        // phase 1 : proposals

        kill proposals

        for row=grid("minRow"):1:grid("maxRow") {
          for col=grid("minCol"):1:grid("maxCol") {
            if $get(grid(row,col))="#" {
              if ..CountNeighbours(.grid,.directions,row,col,$listbuild("N","S","W","E","NW","NE","SW","SE")) > 0 { // elf tries to move
                set ptr = 0
                while $listnext(rotation,ptr,dirs) {
                  if ..CountNeighbours(.grid,.directions,row,col,dirs) = 0 {
                    set pr = $list(dirs,1)
                    set dx = directions(pr,"dx")
                    set dy = directions(pr,"dy")
                    set $list(proposals(row+dy,col+dx),*+1) = $listbuild(row,col)
                    quit
                  }
                }
              }              
            }
          }
        }

        // phase 2 : move

        set prow = $order(proposals(""))
        set moves = 0
        while prow '= "" {
          set moves = moves+1
          set pcol = $order(proposals(prow,""))
          while pcol '= "" {
            if $listlength(proposals(prow,pcol))=1 {
              set srow = $listget($listget(proposals(prow,pcol),1),1)
              set scol = $listget($listget(proposals(prow,pcol),1),2)
              kill grid(srow,scol)
              set grid(prow,pcol) = "#"
              set:prow<grid("minRow") grid("minRow")=prow
              set:prow>grid("maxRow") grid("maxRow")=prow
              set:pcol<grid("minCol") grid("minCol")=pcol
              set:pcol>grid("maxCol") grid("maxCol")=pcol
            }
            set pcol = $order(proposals(prow,pcol))
          }
          set prow = $order(proposals(prow))
        }
        set rotation = $list(rotation,2,*)_$list(rotation,1,1)

        return moves
}

ClassMethod Part1(inputStream As %Stream.Object) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException
       
    set sc = $$$OK
    try {        

      do ..Directions(.directions)      
      $$$TOE(sc,..ParseInput(inputStream,.grid))

      set rotation = $listbuild($listbuild("N","NW","NE"),$listbuild("S","SW","SE"),$listbuild("W","NW","SW"),$listbuild("E","NE","SE"))

      for turn=1:1:10 {
        do ..PlayTurn(.grid,.directions,.rotation)
      }

      write "Part 1 answer : ",..CountEmptyCells(.grid),!
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

ClassMethod Part2(inputStream As %Stream.Object) As %Status
{
    set sc = $$$OK
    try {        
      do ..Directions(.directions)      
      $$$TOE(sc,..ParseInput(inputStream,.grid))

      set rotation = $listbuild($listbuild("N","NW","NE"),$listbuild("S","SW","SE"),$listbuild("W","NW","SW"),$listbuild("E","NE","SE"))

      set turn = 1
      while ..PlayTurn(.grid,.directions,.rotation) > 0 {
        set turn = turn + 1
      }

      write "Part 2 answer : ",turn,!
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

}
