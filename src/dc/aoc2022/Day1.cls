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
        $$$TOE(sc,..Part2(inputStream))
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
        write !,"Part 1 answer : ",maxStars,!
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


    #Dim stars,curStars,totalStars as %Integer
    #Dim maxStars as %Boolean
    
    set sc = $$$OK
    try {
        set curStars = 0
        set stars = ""
        while 'inputStream.AtEnd
        {
            s line = inputStream.ReadLine(,.sc)
            $$$TOE(sc,sc)
            s line = $zstrip(line,"<>C")
            if line="" {
                s maxStars(curStars) = 1
                s curStars = 0                
            } else {
                s curStars = curStars+line+0                
            }
        }
        s maxStars(curStars) = 1        
        set stars=""
        set stars =$order(maxStars(stars),-1)
        set totalStars = 0
        set cnt=0
        while (stars '= "") && (cnt < 3) {
          set totalStars = totalStars + stars
          set cnt=cnt+1
          set stars = $order(maxStars(stars),-1)
        }
        write "Part 2 answer : ",totalStars,!
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

}
