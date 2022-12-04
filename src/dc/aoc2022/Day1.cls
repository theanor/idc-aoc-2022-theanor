Class dc.aoc2022.Day1 Extends Base
{

ClassMethod Run(fileName As %String = "input1.txt") As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException

    #Dim inputStream as %Stream.Object
    
    Set sc = $$$OK
    Try {
        Set inputStream = ..GetInputStream(fileName,.sc)
        $$$TOE(sc,sc)
        $$$TOE(sc,..Part1(inputStream))
        $$$TOE(sc,inputStream.Rewind())
        $$$TOE(sc,..Part2Algol(inputStream))
        $$$TOE(sc,inputStream.Rewind())
        $$$TOE(sc,..Part2Mumps(inputStream))
    }
    Catch (ex) {
      Set sc = ex.AsStatus()
    }
    Return sc
}

ClassMethod Part1(inputStream As %Stream.Object) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException

    #Dim stars,curStars,maxStars as %Integer
    
    Set sc = $$$OK
    Try {

        Set maxStars = 0
        Set curStars = 0
        For {
            Set:'inputStream.AtEnd stars = inputStream.ReadLine(,.sc)
            $$$TOE(sc,sc)
            If stars="" {
                Set:(curStars>maxStars) maxStars = curStars
                Set curStars = 0
            } Else {
                Set curStars = curStars + stars
            }
            Quit:inputStream.AtEnd
        }
        Write !,"Part 1 answer : ",maxStars
    }
    Catch (ex) {
      Set sc = ex.AsStatus()
    }
    Return sc
}

ClassMethod Part2Algol(inputStream As %Stream.Object) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException


    #Dim stars,curStars,totalStars as %Integer
    #Dim maxStars as %Integer
    #Dim i as %Integer
    
    Set sc = $$$OK
    Try {
        Set curStars = 0
        Set maxStars(1) = 0
        Set maxStars(2) = 0
        Set maxStars(3) = 0
        Set stars = ""
        While(1) {
            Set:'inputStream.AtEnd stars = inputStream.ReadLine(,.sc)
            $$$TOE(sc,sc)
            If (stars="") {
                Set i = 1
                While (i <= 3) && (curStars <= maxStars(i)) {
                    Set i = i + 1
                }                                
                Set j = 3
                While (j > i) {                    
                    Set maxStars(j) = maxStars(j-1)
                    Set j = j - 1
                }
                Set maxStars(i) = curStars
                Quit:inputStream.AtEnd
                Set curStars = 0                
            } Else {
                Set curStars = curStars + stars
            }
            Set stars = ""
        }
        Set totalStars = 0
        For i = 1:1:3 Set totalStars = totalStars + maxStars(i)
        Write !,"Part 2 algol style answer : ",totalStars
    }
    Catch (ex) {
      Set sc = ex.AsStatus()
    }
    Return sc
}

ClassMethod Part2Mumps(inputStream As %Stream.Object) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException


    #Dim stars,curStars,totalStars as %Integer
    #Dim maxStars as %Boolean
    #Dim i as %Integer
    
    Set sc = $$$OK
    Try {
        Set curStars = 0
        Set stars = ""
        For {
            Set:'inputStream.AtEnd stars = inputStream.ReadLine(,.sc)
            $$$TOE(sc,sc)
            If (stars="") {
                Set maxStars(curStars)=1
                Quit:inputStream.AtEnd
                Set curStars = 0                
            } Else {
                Set curStars = curStars + stars
            }
            Set stars = ""
        }
        Set stars=""
        Set stars =$ORDER(maxStars(stars),-1)
        Set totalStars = 0
        Set cnt=0
        While (stars '= "") && (cnt < 3) {
          Set totalStars = totalStars + stars
          Set cnt=cnt+1
          Set stars = $ORDER(maxStars(stars),-1)
        }
        Write !,"Part 2 mumps style answer : ",totalStars
    }
    Catch (ex) {
      Set sc = ex.AsStatus()
    }
    Return sc
}

}
