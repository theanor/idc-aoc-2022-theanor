Class dc.aoc2022.Day10 Extends Base
{

ClassMethod Run(fileName As %String = "input10.txt") As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException

    #Dim inputStream as %Stream.Object
    
    set sc = $$$OK
    try {
        set inputStream = ..GetInputStream(fileName,.sc)
        $$$TOE(sc,sc)
        $$$TOE(sc,..Part1And2(inputStream))
      }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
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
   
    set sc = $$$OK
    try {
        set total = 0
        set X = 1
        set clk = 1
        while 'inputStream.AtEnd {

            set line = inputStream.ReadLine(,.sc)
            set line = $zstrip(line,"<>C")

            set opcode = $piece(line," ",1)
            set arg = $piece(line, " ",2)
            set dur = $case(opcode,"noop":1,"addx":2,:0)

            while dur > 0 {

              set pos = (clk-1) # 40              
              set px = $select((pos>=(X-1))&&(pos<=(X+1)):"#",1:".")
              write px
              write:(pos=39) !

              set:((clk-20)#40)=0 total = total + (clk*X)
              
              set clk = clk+1
              set dur = dur-1               
            }            
            if opcode="addx" {
              set X = X+arg
            }
        }
        write "Part 1 answer : ",total,!
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

}
