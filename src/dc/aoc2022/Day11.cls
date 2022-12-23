Class dc.aoc2022.Day11 Extends Base
{

ClassMethod Run(fileName As %String = "input11.txt") As %Status
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

ClassMethod Part1(inputStream As %Stream.Object) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException
   
    set sc = $$$OK


    try {        
        set monkeys = ""
        set monkeyCnt = 0

        while 'inputStream.AtEnd {

          set line = inputStream.ReadLine(,.sc)
          set line = $zstrip(line,"<>C")    

          if line '= "" {
          set monkeyIdx = $replace($piece(line," ",2),":","")+0         

          set line = inputStream.ReadLine(,.sc)
          set line = $zstrip(line,"<>C")    
          set monkeys(monkeyIdx,"items") = $listfromstring($replace($piece(line,":",2)," ",""))
         
          set line = inputStream.ReadLine(,.sc)
          set line = $zstrip(line,"<>C")    
          set monkeys(monkeyIdx,"fct") = $replace($piece(line,":",2)," ","")


          set line = inputStream.ReadLine(,.sc)
          set line = $zstrip(line,"<>C")    
          set monkeys(monkeyIdx,"div") = $replace($piece(line,"by",2)," ","")+0

        
          set line = inputStream.ReadLine(,.sc)
          set line = $zstrip(line,"<>C")    
          set monkeys(monkeyIdx,"true") = $replace($piece(line,"monkey",2)," ","")+0

          set line = inputStream.ReadLine(,.sc)
          set line = $zstrip(line,"<>C")    
          set monkeys(monkeyIdx,"false") = $replace($piece(line,"monkey",2)," ","")+0

          set monkeys(monkeyIdx,"isp") = 0

          set monkeyCnt = monkeyCnt+1
          }
        } 

        set round=1
        while (round <= 20) {
          set mky = 0
          while (mky < monkeyCnt) {            
            set items = monkeys(mky,"items")
            for it=1:1:$listlength(items) {

              set old = $listget(items,it)
              set new = old              
              xecute ("(old,new) set "_monkeys(mky,"fct"), old, .new)              
              set new = new \ 3              
              if (new # monkeys(mky,"div"))=0 {
                set dest = monkeys(mky,"true")
              } else {
                set dest = monkeys(mky,"false")
              }              

              set $list(monkeys(dest,"items"),*+1) = new

              set monkeys(mky,"isp") = monkeys(mky,"isp") + 1
            }
            set monkeys(mky,"items")=""
            
            set mky = mky + 1
          }
          set round = round+1
        }

        set top1 = 0
        set top2 = 0

        for i = 0:1:monkeyCnt-1 {
          if monkeys(i,"isp") > top2 {
            if monkeys(i,"isp") > top1 {
              set top2 = top1 
              set top1 = monkeys(i,"isp")
            } else {
              set top2 = monkeys(i,"isp")
            }
          }
        }        

        write "Part 1 answer : ",top1*top2,!
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
   
    set sc = $$$OK


    try {        
        set monkeys = ""
        set monkeyCnt = 0

        set p2div = 1

        while 'inputStream.AtEnd {

          set line = inputStream.ReadLine(,.sc)
          set line = $zstrip(line,"<>C")    

          if line '= "" {
          set monkeyIdx = $replace($piece(line," ",2),":","")+0         

          set line = inputStream.ReadLine(,.sc)
          set line = $zstrip(line,"<>C")    
          set monkeys(monkeyIdx,"items") = $listfromstring($replace($piece(line,":",2)," ",""))
         
          set line = inputStream.ReadLine(,.sc)
          set line = $zstrip(line,"<>C")    
          set monkeys(monkeyIdx,"fct") = $replace($piece(line,":",2)," ","")


          set line = inputStream.ReadLine(,.sc)
          set line = $zstrip(line,"<>C")    
          set monkeys(monkeyIdx,"div") = $replace($piece(line,"by",2)," ","")+0
          set p2div = p2div*monkeys(monkeyIdx,"div")
        
          set line = inputStream.ReadLine(,.sc)
          set line = $zstrip(line,"<>C")    
          set monkeys(monkeyIdx,"true") = $replace($piece(line,"monkey",2)," ","")+0

          set line = inputStream.ReadLine(,.sc)
          set line = $zstrip(line,"<>C")    
          set monkeys(monkeyIdx,"false") = $replace($piece(line,"monkey",2)," ","")+0

          set monkeys(monkeyIdx,"isp") = 0

          set monkeyCnt = monkeyCnt+1
          }
        } 

        set round=1
        while (round <= 10000) {
          set mky = 0
          while (mky < monkeyCnt) {            
            set items = monkeys(mky,"items")
            for it=1:1:$listlength(items) {

              set old = $listget(items,it)
              set new = old              
              xecute ("(old,new) set "_monkeys(mky,"fct"), old, .new)              

              set new = new # p2div

              if (new # monkeys(mky,"div"))=0 {
                set dest = monkeys(mky,"true")
              } else {
                set dest = monkeys(mky,"false")
              }              

              set $list(monkeys(dest,"items"),*+1) = new

              set monkeys(mky,"isp") = monkeys(mky,"isp") + 1
            }
            set monkeys(mky,"items")=""
            
            set mky = mky + 1
          }
          set round = round+1
        }

        set top1 = 0
        set top2 = 0

        for i = 0:1:monkeyCnt-1 {
          if monkeys(i,"isp") > top2 {
            if monkeys(i,"isp") > top1 {
              set top2 = top1 
              set top1 = monkeys(i,"isp")
            } else {
              set top2 = monkeys(i,"isp")
            }
          }
        }

        write "Part 2 answer : ",top1*top2,!
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

}
