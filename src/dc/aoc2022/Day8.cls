Class dc.aoc2022.Day8 Extends Base
{

ClassMethod Run(fileName As %String = "input8.txt") As %Status
{
    #Dim sc as %Status
    #Dim ex 
    #Dim inputStream as %Stream.Object
    
    set sc = $$$OK
    try {
        set inputStream = ..GetInputStream(fileName,.sc)
        $$$TOE(sc,sc)
        $$$TOE(sc,..BuildGrid(inputStream,.grid,.rowCnt,.colCnt))        
        $$$TOE(sc,..Part1(.grid,rowCnt,colCnt))
        $$$TOE(sc,..Part2(.grid,rowCnt,colCnt))
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

ClassMethod IsVisible(ByRef grid, rowCnt As %Integer, colCnt As %Integer, row As %Integer, col As %Integer) As %Boolean
{
    #Dim height,l,r,t,b as %Integer

    if (row=1) || (row = rowCnt) || (col = 1) || (col=colCnt) return 1
   
    set height = grid(row,col)

    set l = 0
    for i=1:1:col-1 {
      if grid(row,i) >= height {
          set l = 1
          quit
      }        
    }    

    set r  = 0
    for i=col+1:1:colCnt {
      if grid(row,i) >= height {
          set r  = 1
          quit
      }        
    }    

    set t=0
    for j=1:1:row-1 {
      if grid(j,col) >= height {
          set t=1
          quit
      }
    }

    set b=0
    for j=row+1:1:rowCnt {
      if grid(j,col) >= height {
         set b=1
         quit
      }
    }

    return 'l || 'r || 't || 'b
}

ClassMethod Score(ByRef grid, rowCnt As %Integer, colCnt As %Integer, row As %Integer, col As %Integer) As %Integer
{
    #Dim sc as %Status = $$$OK
    #Dim ex as %Exception.AbstractException

    #Dim lvd,rvd,tvd,bvd as %Integer
    #Dim ht as %Integer
    #Dim i as %Integer
    
    try {
        if (row=1) || (row = rowCnt) || (col = 1) || (col=colCnt) return 0

        set lvd=0
        set ht = grid(row,col)    
        for i=col-1:-1:1 {
           set lvd=lvd+1
           quit:grid(row,i)>=ht
        }
        set rvd = 0
        set ht = grid(row,col)
        for i=col+1:1:colCnt {
           set rvd = rvd+1 
           quit:grid(row,i)>=ht
        }
        set tvd = 0
        set ht = grid(row,col)
        for i=row-1:-1:1 {
            set tvd=tvd+1
            quit:grid(i,col)>=ht
        }

        set bvd = 0
        set ht = grid(row,col)
        for i = row+1:1:rowCnt {
            set bvd = bvd+1
            quit:grid(i,col)>=ht
        }
        return lvd*rvd*tvd*bvd
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    quit sc
}

ClassMethod BuildGrid(inputStream As %Stream.Object, ByRef grid, ByRef rowCnt As %Integer, ByRef colCnt As %Integer) As %Status
{
    #Dim ex as %Exception.AbstractException
    #Dim sc as %Status

    #Dim line as %String
    #Dim i as %Integer

    set sc = $$$OK
    try {
        set rowCnt = 0     
        set colCnt = 0
        set grid = 0
        while 'inputStream.AtEnd {
            set line = inputStream.ReadLine(,.sc)
            set line = $zstrip(line,"<>C")
            set rowCnt = rowCnt + 1
            set colCnt = $length(line)
            for i=1:1:colCnt {                                
                set grid(rowCnt,i)=$extract(line,i,i)
            }        
        }
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    quit sc
}

ClassMethod Part1(ByRef grid, rowCnt As %Integer, colCnt As %Integer) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException

    #Dim tot,i,j As %Integer

       
    set sc = $$$OK
    try {   
        set tot = 0
        for i=1:1:rowCnt {
            for j=1:1:colCnt {
                set tot = tot +..IsVisible(.grid,rowCnt,colCnt,i,j)
            }
        }
        write "Part 1 answer : ",tot,!
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

ClassMethod Part2(ByRef grid, rowCnt As %Integer, colCnt As %Integer) As %Status
{
    #Dim maxScore,i,j,score as %Integer

    set sc = $$$OK

    try {
        set maxScore = 0
        for i=1:1:rowCnt {
            for j=1:1:colCnt {
                set score = ..Score(.grid,rowCnt,colCnt,i,j)
                set:score>maxScore maxScore = score
            }
        }
        write "Part 2 answer : ",maxScore,!
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

}
