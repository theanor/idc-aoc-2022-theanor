Class dc.aoc2022.Day1 Extends Base
{

ClassMethod Run(fileName As %String = "input1.txt") As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException

    #Dim inputStream as %Stream.Object
    
    set sc = $$$OK
    try {
        set inputStream = ..GetInputStream(fileName,.sc)
        $$$TOE(sc,sc)
        $$$TOE(sc,..Part1(inputStream))
        $$$TOE(sc,inputStream.Rewind())
        $$$TOE(sc,..Part2Algol(inputStream))
        $$$TOE(sc,inputStream.Rewind())
        $$$TOE(sc,..Part2Mumps(inputStream))
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

ClassMethod Part1(inputStream As %Stream.Object) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException

    #Dim stars,curStars,maxStars as %Integer
    
    set sc = $$$OK
    try {

        set maxStars = 0
        set curStars = 0
        for {
            set:'inputStream.AtEnd stars = $zstrip(inputStream.ReadLine(,.sc),"<>C")
            $$$TOE(sc,sc)
            if stars="" {
                set:(curStars>maxStars) maxStars = curStars
                set curStars = 0
            } else {
                set curStars = curStars + stars
            }
            quit:inputStream.AtEnd
        }
        write !,"Part 1 answer : ",maxStars
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

ClassMethod Part2Algol(inputStream As %Stream.Object) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException


    #Dim stars,curStars,totalStars as %Integer
    #Dim maxStars as %Integer
    #Dim i as %Integer
    
    set sc = $$$OK
    try {
        set curStars = 0
        set maxStars(1) = 0
        set maxStars(2) = 0
        set maxStars(3) = 0
        set stars = ""
        while(1) {
            set:'inputStream.AtEnd stars = inputStream.ReadLine(,.sc)
            $$$TOE(sc,sc)
            if (stars="") {
                set i = 1
                while (i <= 3) && (curStars <= maxStars(i)) {
                    set i = i + 1
                }                                
                set j = 3
                while (j > i) {                    
                    set maxStars(j) = maxStars(j-1)
                    set j = j - 1
                }
                set maxStars(i) = curStars
                quit:inputStream.AtEnd
                set curStars = 0                
            } else {
                set curStars = curStars + stars
            }
            set stars = ""
        }
        set totalStars = 0
        for i = 1:1:3 set totalStars = totalStars + maxStars(i)
        write !,"Part 2 algol style answer : ",totalStars
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

ClassMethod Part2Mumps(inputStream As %Stream.Object) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException


    #Dim stars,curStars,totalStars as %Integer
    #Dim maxStars as %Boolean
    
    set sc = $$$OK
    try {
        set curStars = 0
        set stars = ""
        for {
            set:'inputStream.AtEnd stars = inputStream.ReadLine(,.sc)
            $$$TOE(sc,sc)
            if (stars="") {
                set maxStars(curStars)=1
                quit:inputStream.AtEnd
                set curStars = 0                
            } else {
                set curStars = curStars + stars
            }
            set stars = ""
        }
        set stars=""
        set stars =$order(maxStars(stars),-1)
        set totalStars = 0
        set cnt=0
        while (stars '= "") && (cnt < 3) {
          set totalStars = totalStars + stars
          set cnt=cnt+1
          set stars = $order(maxStars(stars),-1)
        }
        write !,"Part 2 mumps style answer : ",totalStars
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

}
