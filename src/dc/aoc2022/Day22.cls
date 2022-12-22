Class dc.aoc2022.Day22 Extends Base
{

ClassMethod Run(fileName As %String = "input22.txt") As %Status
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

ClassMethod ParseInput(inputStream As %Stream.Object, ByRef grid, ByRef moves, ByRef rows, ByRef cols) As %Status
{
  #Dim sc as %Status
  #Dim ex as %Exception.AbstractException

  #Dim line as %String
  #Dim state as %Integer
  #Dim row,col as %Integer
  #Dim tile,mvtstr as %String
  #Dim c,d as %String

  
  set sc = $$$OK
  try {
      set state = 0
      set row = 0
      while ('inputStream.AtEnd)
      {
        set line = inputStream.ReadLine(,.sc)
        set line = $zstrip(line,"<>C")
        if line="" {
          set state = 1
        } else {
          if state=0 {
            set tiles = line
            set row = row + 1
            for col=1:1:$length(tiles) {
              set tile = $extract(tiles,col,col)
              if (tile=".") || (tile="#") {
                set grid(row,col) = tile
                set:row<$get(cols(col,"min"),..#MAXINT) cols(col,"min")  = row
                set:row>$get(cols(col,"max"),-..#MAXINT) cols(col,"max")  = row
                set:col<$get(rows(row,"min"),..#MAXINT) rows(row,"min")  = col
                set:col>$get(rows(row,"max"),-..#MAXINT) rows(row,"max")  = col
              } else {

              }
            }
          } elseif state=1 {
            set mvtstr = line            
            quit
          }
        }
      }

      set d = ""
      set moves=0
      for i=1:1:$length(mvtstr) {
        set c = $extract(mvtstr,i,i)
        if (c="R") || (c="L") {
          if d'="" {
            set moves=moves+1
            set moves(moves) = d
            set d = ""
          }
          set moves=moves+1
          set moves(moves) = c
        } else {
          set d = d_c
        }
      }
      if d'="" {
        set moves=moves+1
        set moves(moves) = d
        set d = ""
      }
  } catch (ex) {
    set sc = ex.AsStatus()
  }
  quit sc
}

ClassMethod Password(row As %Integer, col As %Integer, f As %String) As %Integer
{
  return (row*1000)+(col*4)+$case(f,">":0,"v":1,"<":2,"^":3)
}

ClassMethod Part1(inputStream As %Stream.Object) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException
    
    #Dim grid
    #Dim moves
    #Dim rows,cols
    #Dim f as %String
    #Dim i as %Integer
    #Dim move
    #Dim s,dx,dy as %Integer
    #Dim row,col,nrow,ncol as %Integer
  
    set sc = $$$OK
    try {        

      $$$TOE(sc,..ParseInput(inputStream,.grid,.moves,.rows,.cols))

      set row = 1
      set col = rows(1,"min")
      set f = ">"
      // apply moves
      for i=1:1:moves {
        set move = moves(i)
        if move="R" {
          set f = $case(f,"^":">",">":"v","v":"<","<":"^")
        } elseif move="L" {
          set f = $case(f,"^":"<","<":"v","v":">",">":"^")
        } else {
          set dx = $case(f,">":1,"<":-1,:0)
          set dy = $case(f,"^":-1,"v":1,:0)
          for s=1:1:move {
            set nrow = row+dy
            set ncol = col+dx
            if $get(grid(nrow,ncol))="." { // move
              set row = nrow
              set col = ncol
            } elseif $get(grid(nrow,ncol))="#" { // stop
              quit
            } elseif $get(grid(nrow,ncol))="" { // wrap
              if dx = -1 {
                quit:grid(row,rows(row,"max"))'="." 
                set col = rows(row,"max")
              } elseif dx=1 {
                quit:grid(row,rows(row,"min"))'="."
                set col = rows(row,"min")
              } elseif dy=-1 {
                quit:grid(cols(col,"max"),col)'="."
                set row = cols(col,"max")
              } elseif dy=1 {
                quit:grid(cols(col,"min"),col)'="."
                set row = cols(col,"min")
              }
            }
          }
        }
      }
      write "Part 1 answer : ",..Password(row,col,f),!
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

/// caveat: works only for the specific cube folding in the input provided by AoC for this day 22 part 2 puzzle
/// 
/// facets labels used in comments : 
/// 
///  12
///  3
/// 45
/// 6
/// 
ClassMethod Part2(inputStream As %Stream.Object) As %Status
{
    #Dim line as %String
    #Dim grid
    #Dim moves
    #Dim rows,cols
    #Dim f as %String
    #Dim i as %Integer
    #Dim move
    #Dim s,dx,dy as %Integer
    #Dim row,col,nrow,ncol as %Integer


    set sc = $$$OK
    try {        
      $$$TOE(sc,..ParseInput(inputStream,.grid,.moves,.rows,.cols))

      set row = 1
      set col = rows(1,"min")
      set f = ">"
      set c =  (cols(1,"max")-cols(1,"min")+1)\2
      write "cube size : ",c,!
      // apply moves
      for i=1:1:moves {
        set move = moves(i)
        if move="R" {
          set f = $case(f,"^":">",">":"v","v":"<","<":"^")
        } elseif move="L" {
          set f = $case(f,"^":"<","<":"v","v":">",">":"^")
        } else {
          for s=1:1:move {
            set dx = $case(f,">":1,"<":-1,:0)
            set dy = $case(f,"^":-1,"v":1,:0)

            set nrow = row+dy
            set ncol = col+dx
            if $get(grid(nrow,ncol))="." { // move
              set row = nrow
              set col = ncol
            } elseif $get(grid(nrow,ncol))="#" { // stop
              quit
            } elseif $get(grid(nrow,ncol))="" { // wrap
               if ((row >=1) && (row <= c) && (col >= (c+1)) && (col <= (2*c)))  { // currently in facet 1 
                if f="<" { // go to facet 4 left edge
                  set ncol = 1
                  set nrow = ((c+1)-row)+(2*c)
                  set nf = ">"
                } elseif f="^" { // go to facet 6 left edge
                  set nrow = col+(2*c)
                  set ncol = 1
                  set nf = ">"
                }
                } elseif ((row >=1) && (row <= c) && (col >=((2*c)+1)) && (col <= (3*c))) { // currently in facet 2
                  if f="^" {  // go to facet 6 bottom edge
                    set nrow= 4*c
                    set ncol = col-(2*c)
                    set nf="^"
                  } elseif f="v" { // go to facet 3 right edge
                    set nrow = col-c
                    set ncol = (2*c)
                    set nf = "<"
                  } elseif f=">" { // go to facet 5 right edge
                     set nrow = ((c+1)-row)+(2*c)
                     set ncol = 2*c
                     set nf = "<"
                  } 
                } elseif ((row >=(c+1)) && (row <= (2*c)) && (col >=(c+1)) && (col <= (2*c))) { // currently in facet 3                
                  if f = ">" { // go to facet 2 bottom edge
                    set nrow = c
                    set ncol = row+c
                    set nf = "^"
                  } elseif f = "<" { // go to facet 4 top edge
                    set nrow = (2*c)+1
                    set ncol = row-c
                    set nf = "v"
                  }
               } elseif ((row >=((2*c)+1)) && (row <= (3*c)) && (col >=1) && (col <= c)) { // currently in facet 4
                  if f="<" { // go to facet 1 left edge
                    set nrow = (c+1)-(row-(2*c))
                    set ncol = c+1
                    set nf = ">"
                  } elseif f="^" { // go to facet 3 left edge
                    set ncol=c+1
                    set nrow = col+c
                    set nf =">"
                  }
               } elseif ((row >= ((2*c)+1)) && (row <= (3*c)) && (col >=(c+1)) && (col <= (2*c))) { // currently in facet 5
                  if f=">" { // go to facet 2 right edge
                    set nrow = (c+1)-(row - (2*c))
                    set ncol = 3*c
                    set nf = "<"
                  } elseif f="v" { // go to facet 6 right edge
                    set nrow = col+(2*c)
                    set ncol = c
                    set nf = "<"
                  }
               } elseif ((row >= ((3*c)+1)) && (row <= (4*c)) && (col >=1) && (col <= c)) { // currently in facet 6
                  if f="<" { // go to facet 1 top edge
                    set nrow = 1
                    set ncol = row -(2*c)
                    set nf = "v"
                  } elseif f="v" { // go to facet 2 top edge
                    set nrow = 1
                    set ncol = col+(2*c)
                    set nf = "v"
                  } elseif f=">" { // go to facet 5 bottom edge
                    set nrow = 3*c
                    set ncol=row-(2*c)
                    set nf = "^"
                  }
               }
                if grid(nrow,ncol)="#" {
                  quit
                } else {
                  set f = nf
                  set row = nrow
                  set col = ncol
                }                      
             }   
           }
        }
      }
      write "Part 2 answer : ",..Password(row,col,f),!
    }
   catch (ex) {
      set sc = ex.AsStatus()
    }
   return sc
}

}
