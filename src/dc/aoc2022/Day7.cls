Class dc.aoc2022.Day7 Extends Base
{

ClassMethod Run(fileName As %String = "input7.txt") As %Status
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

ClassMethod SizeDirs(inputStream As %Stream.Object, ByRef fs As %Integer) As %Status
{
    #Dim sc as %Status = $$$OK
    #Dim ex as %Exception.AbstractException

    #Dim line as %String

    #Dim curdir,totdir,cmdline,cmd,arg As %String
    #Dim size as %Integer

    set fs = ""
    set curdir="."
    try {        
        while 'inputStream.AtEnd {
          set line = inputStream.ReadLine(,.sc)
          set line = $zstrip(line,"<>C")    
          if ($extract(line,1,1) = "$") { // command prompt
            set cmdline = $extract(line,3,*)
            set cmd = $piece(cmdline," ",1)
            set arg = $piece(cmdline," ",2)
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
            set size = $piece(line," ",1)
            // ignore file name s fname = $piece(line," ",2)
            if size="dir" {
              // ignore
            } else {
              set totdir = curdir
              while(totdir '= ".") {
                set fs(totdir) = $get(fs(totdir),0)+size+0
                set totdir = $piece(totdir,"/",1,*-1)
              }                
              set fs(totdir) = $get(fs(totdir),0)+size
            }            
          }
        } 
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
    

    #Dim fs As %Integer
    #Dim curdir As %String
    #Dim total as %Integer

   
    set sc = $$$OK
    try {        
        $$$TOE(sc,..SizeDirs(inputStream,.fs))
        set curdir = $order(fs(""))
        set total=0
        while curdir '= "" {
          if fs(curdir) <= 100000 {
            set total = total + fs(curdir)
          }
          set curdir = $order(fs(curdir))
        }
        write "Part 1 answer : ",total,!
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

Parameter TOTALSIZE = 70000000;

Parameter MINFREE = 30000000;

ClassMethod Part2(inputStream As %Stream.Object) As %Status
{
    
    #Dim curdir as %String
    #Dim tofree,free,mindir as %Integer

    set sc = $$$OK

    try {
        $$$TOE(sc,..SizeDirs(inputStream,.fs))        
        set curdir = $order(fs(""))
        set free = ..#TOTALSIZE-fs(".")
        set tofree = ..#MINFREE - free
        set mindir = ..#TOTALSIZE
        while curdir '= "" {
          if (fs(curdir) >= tofree) && (fs(curdir) < mindir) {
            set mindir = fs(curdir)
      
          }
          set curdir = $order(fs(curdir))
        }
        write "Part 2 answer : ",mindir,!
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

}
