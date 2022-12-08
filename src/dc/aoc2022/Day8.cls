Class dc.aoc2022.Day8 Extends Base
{

ClassMethod Run(fileName As %String = "input8.txt") As %Status
{
    #Dim sc as %Status
    #Dim ex 
    #Dim inputStream as %Stream.Object
    
    Set sc = $$$OK
    Try {
        Set inputStream = ..GetInputStream(fileName,.sc)
        $$$TOE(sc,sc)
        $$$TOE(sc,..BuildGrid(inputStream,.grid,.rowCnt,.colCnt))        
        $$$TOE(sc,..Part1(.grid,rowCnt,colCnt))
        $$$TOE(sc,..Part2(.grid,rowCnt,colCnt))
    }
    Catch (ex) {
      Set sc = ex.AsStatus()
    }
    Return sc
}

ClassMethod IsVisible(ByRef grid, rowCnt As %Integer, colCnt As %Integer, row As %Integer, col As %Integer) As %Boolean
{
    #Dim height,l,r,t,b as %Integer

    If (row=1) || (row = rowCnt) || (col = 1) || (col=colCnt) Return 1
   
    Set height = grid(row,col)

    Set l = 0
    For i=1:1:col-1 {
      If grid(row,i) >= height {
          Set l = 1
          Quit
      }        
    }    

    Set r  = 0
    For i=col+1:1:colCnt {
      If grid(row,i) >= height {
          Set r  = 1
          Quit
      }        
    }    

    Set t=0
    For j=1:1:row-1 {
      If grid(j,col) >= height {
          Set t=1
          Quit
      }
    }

    Set b=0
    For j=row+1:1:rowCnt {
      If grid(j,col) >= height {
         Set b=1
         Quit
      }
    }

    Return 'l || 'r || 't || 'b
}

ClassMethod Score(ByRef grid, rowCnt As %Integer, colCnt As %Integer, row As %Integer, col As %Integer) As %Integer
{
    #Dim sc as %Status = $$$OK
    #Dim ex as %Exception.AbstractException

    #Dim lvd,rvd,tvd,bvd as %Integer
    #Dim ht as %Integer
    #Dim i as %Integer
    
    Try {
        If (row=1) || (row = rowCnt) || (col = 1) || (col=colCnt) Return 0

        Set lvd=0
        Set ht = grid(row,col)    
        For i=col-1:-1:1 {
           Set lvd=lvd+1
           Quit:grid(row,i)>=ht
        }
        Set rvd = 0
        Set ht = grid(row,col)
        For i=col+1:1:colCnt {
           Set rvd = rvd+1 
           Quit:grid(row,i)>=ht
        }
        Set tvd = 0
        Set ht = grid(row,col)
        For i=row-1:-1:1 {
            Set tvd=tvd+1
            Quit:grid(i,col)>=ht
        }

        Set bvd = 0
        Set ht = grid(row,col)
        For i = row+1:1:rowCnt {
            Set bvd = bvd+1
            Quit:grid(i,col)>=ht
        }
        Return lvd*rvd*tvd*bvd
    }
    Catch (ex) {
      Set sc = ex.AsStatus()
    }
    Quit sc
}

ClassMethod BuildGrid(inputStream As %Stream.Object, ByRef grid, ByRef rowCnt As %Integer, ByRef colCnt As %Integer) As %Status
{
    #Dim ex as %Exception.AbstractException
    #Dim sc as %Status

    #Dim line as %String
    #Dim i as %Integer

    Set sc = $$$OK
    Try {
        Set rowCnt = 0     
        Set colCnt = 0
        Set grid = 0
        While 'inputStream.AtEnd {
            Set line = inputStream.ReadLine(,.sc)
            Set line = $ZSTRIP(line,"<>C")
            Set rowCnt = rowCnt + 1
            Set colCnt = $LENGTH(line)
            For i=1:1:colCnt {                                
                Set grid(rowCnt,i)=$EXTRACT(line,i,i)
            }        
        }
    }
    Catch (ex) {
      Set sc = ex.AsStatus()
    }
    Quit sc
}

ClassMethod Part1(ByRef grid, rowCnt As %Integer, colCnt As %Integer) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException

    #Dim tot,i,j As %Integer

       
    Set sc = $$$OK
    Try {   
        Set tot = 0
        Set maxScore = 0
        For i=1:1:rowCnt {
            For j=1:1:colCnt {
                Set tot = tot +..IsVisible(.grid,rowCnt,colCnt,i,j)
            }
        }
        Write "Part 1 answer : ",tot,!
    }
    Catch (ex) {
      Set sc = ex.AsStatus()
    }
    Return sc
}

ClassMethod Part2(ByRef grid, rowCnt As %Integer, colCnt As %Integer) As %Status
{
    #Dim line as %String

    #Dim curdir as %String
    #Dim maxScore,i,j,score as %Integer

    Set sc = $$$OK

    Try {
        Set maxScore = 0
        For i=1:1:rowCnt {
            For j=1:1:colCnt {
                Set score = ..Score(.grid,rowCnt,colCnt,i,j)
                Set:score>maxScore maxScore = score
            }
        }
        Write "Part 2 answer : ",maxScore,!
    }
    Catch (ex) {
      Set sc = ex.AsStatus()
    }
    Return sc
}

}
