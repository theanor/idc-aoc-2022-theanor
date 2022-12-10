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

    s fs = ""
    s curdir="."
    Try {        
        While 'inputStream.AtEnd {
          Set line = inputStream.ReadLine(,.sc)
          Set line = $ZSTRIP(line,"<>C")    
          if ($extract(line,1,1) = "$") { // command prompt
            s cmdline = $extract(line,3,*)
            s cmd = $piece(cmdline," ",1)
            s arg = $piece(cmdline," ",2)
            if cmd="cd" {
              if arg="/" {
                set curdir = "."
              } elseif arg=".." {
                set curdir = $piece(curdir,"/",1,*-1)
              } else {
                set curdir = $get(curdir)_"/"_arg
              }
            } elseif cmd="ls" {
              // ignore 
            }
          } else {
            s size = $piece(line," ",1)
            s fname = $piece(line," ",2)
            if size="dir" {
              // ignore
            } else {
              s totdir = curdir
              while(totdir '= ".") {
                s fs(totdir) = $get(fs(totdir),0)+size+0
                set totdir = $piece(totdir,"/",1,*-1)
              }                
              s fs(totdir) = $get(fs(totdir),0)+size
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
        s curdir = $order(fs(""))
        s total=0
        while curdir '= "" {
          if fs(curdir) <= 100000 {
            s total = total + fs(curdir)
          }
          s curdir = $order(fs(curdir))
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
        s curdir = $order(fs(""))
        s free = ..#TOTALSIZE-fs(".")
        s tofree = ..#MINFREE - free
        s mindir = ..#TOTALSIZE
        while curdir '= "" {
          if (fs(curdir) >= tofree) && (fs(curdir) < mindir) {
            s mindir = fs(curdir)
      
          }
          s curdir = $order(fs(curdir))
        }
        Write "Part 2 answer : ",mindir,!
    }
    Catch (ex) {
      Set sc = ex.AsStatus()
    }
    Return sc
}

}
