Class dc.aoc2022.Day10 Extends Base
{

ClassMethod Run(fileName As %String = "input10.txt") As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException

    #Dim inputStream as %Stream.Object
    
    Set sc = $$$OK
    Try {
        Set inputStream = ..GetInputStream(fileName,.sc)
        $$$TOE(sc,sc)
        $$$TOE(sc,..Part1And2(inputStream))
      }
    Catch (ex) {
      Set sc = ex.AsStatus()
    }
    Return sc
}

ClassMethod Part1And2(inputStream As %Stream.Object) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException
    
    #Dim line as %String

    #Dim total as %Integer
    #Dim X as %Integer
    #Dim clk,dur as %Integer
    #Dim opcode as %String
    #Dim arg as %Integer
   
    Set sc = $$$OK
    Try {
        Set total = 0
        Set X = 1
        Set clk = 1
        While 'inputStream.AtEnd {

            Set line = inputStream.ReadLine(,.sc)
            Set line = $ZSTRIP(line,"<>C")

            Set opcode = $PIECE(line," ",1)
            Set arg = $PIECE(line, " ",2)
            Set dur = $CASE(opcode,"noop":1,"addx":2,:0)

            While dur > 0 {

              Set pos = (clk-1) # 40              
              Set px = $SELECT((pos>=(X-1))&&(pos<=(X+1)):"#",1:".")
              Write px
              Write:(pos=39) !

              Set:((clk-20)#40)=0 total = total + (clk*X)
              
              Set clk = clk+1
              Set dur = dur-1               
            }            
            If opcode="addx" {
              Set X = X+arg
            }
        }
        Write "Part 1 answer : ",total,!
    }
    Catch (ex) {
      Set sc = ex.AsStatus()
    }
    Return sc
}

}
