Class dc.aoc2022.Day7 Extends Base
{

ClassMethod Run(fileName As %String = "input7.txt") As %Status
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

ClassMethod SizeDirs(inputStream As %Stream.Object, ByRef fs As %Integer) As %Status
{
    #Dim sc as %Status = $$$OK
    #Dim ex as %Exception.AbstractException

    #Dim line as %String

    #Dim curdir,totdir,cmdline,cmd,arg As %String
    #Dim size as %Integer

    Set fs = ""
    Set curdir="."
    Try {        
        While 'inputStream.AtEnd {
          Set line = inputStream.ReadLine(,.sc)
          Set line = $ZSTRIP(line,"<>C")    
          If ($EXTRACT(line,1,1) = "$") { // command prompt
            Set cmdline = $EXTRACT(line,3,*)
            Set cmd = $PIECE(cmdline," ",1)
            Set arg = $PIECE(cmdline," ",2)
            If cmd="cd" {
              If arg="/" {
                Set curdir = "."
              } ElseIf arg=".." {
                Set curdir = $PIECE(curdir,"/",1,*-1)
              } Else {
                Set curdir = $GET(curdir)_"/"_arg
              }
            } ElseIf cmd="ls" {
              // ignore 
            }
          } Else {
            Set size = $PIECE(line," ",1)
            // ignore file name s fname = $piece(line," ",2)
            If size="dir" {
              // ignore
            } Else {
              Set totdir = curdir
              While(totdir '= ".") {
                Set fs(totdir) = $GET(fs(totdir),0)+size+0
                Set totdir = $PIECE(totdir,"/",1,*-1)
              }                
              Set fs(totdir) = $GET(fs(totdir),0)+size
            }            
          }
        } 
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
    

    #Dim fs As %Integer
    #Dim curdir As %String
    #Dim total as %Integer

   
    Set sc = $$$OK
    Try {        
        $$$TOE(sc,..SizeDirs(inputStream,.fs))
        Set curdir = $ORDER(fs(""))
        Set total=0
        While curdir '= "" {
          If fs(curdir) <= 100000 {
            Set total = total + fs(curdir)
          }
          Set curdir = $ORDER(fs(curdir))
        }
        Write "Part 1 answer : ",total,!
    }
    Catch (ex) {
      Set sc = ex.AsStatus()
    }
    Return sc
}

Parameter TOTALSIZE = 70000000;

Parameter MINFREE = 30000000;

ClassMethod Part2(inputStream As %Stream.Object) As %Status
{
    
    #Dim curdir as %String
    #Dim tofree,free,mindir as %Integer

    Set sc = $$$OK

    Try {
        $$$TOE(sc,..SizeDirs(inputStream,.fs))        
        Set curdir = $ORDER(fs(""))
        Set free = ..#TOTALSIZE-fs(".")
        Set tofree = ..#MINFREE - free
        Set mindir = ..#TOTALSIZE
        While curdir '= "" {
          If (fs(curdir) >= tofree) && (fs(curdir) < mindir) {
            Set mindir = fs(curdir)
      
          }
          Set curdir = $ORDER(fs(curdir))
        }
        Write "Part 2 answer : ",mindir,!
    }
    Catch (ex) {
      Set sc = ex.AsStatus()
    }
    Return sc
}

}
