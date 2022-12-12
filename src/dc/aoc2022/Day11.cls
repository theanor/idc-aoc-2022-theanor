Class dc.aoc2022.Day11 Extends Base
{

ClassMethod Run(fileName As %String = "input11.txt") As %Status
{
    #Dim sc as %Status
    #Dim ex 
    #Dim inputStream as %Stream.Object

    #Dim monkeys1,monkeys2 As %String
    #Dim monkeyCnt As %Integer

    #Dim reliefExpr As %String
    #Dim relief,mky As %Integer

    
    set sc = $$$OK
    try {
        set inputStream = ..GetInputStream(fileName,.sc)
        $$$TOE(sc,sc)

        $$$TOE(sc,..ParseMonkeys(inputStream,.monkeys1,.monkeyCnt))
        merge monkeys2=monkeys1

        // part 1 : manage worry level by dividing it by 3, run monkey business for 20 rounds
        $$$TOE(sc,..RunMonkeyBusiness(.monkeys1,monkeyCnt,"newValue \ 3",20))        
        write "Part 1 answer : ",..TopMonkeyBusiness(.monkeys1,monkeyCnt),!


        // part 2 : manage worry level by setting it to modulo of product of monkey's divisors, run monkey business for 10000 rounds
        // 
        // By Rudolf's nose, this was tricky and requires college level integer math :
        //   * monkey's divisors are prime numbers, so they are pairwise coprimes and https://en.wikipedia.org/wiki/Chinese_remainder_theorem applies
        //   * if they were not, instead of the product of divisors, the lowest common multiple of the divisors would achieve the same effect

        set relief=1
        for mky=0:1:monkeyCnt-1 {
          set relief = relief*monkeys2(mky,"div")
        }
        set reliefExpr = "newValue # "_relief
        $$$TOE(sc,..RunMonkeyBusiness(.monkeys2,monkeyCnt,reliefExpr,10000))        
        write "Part 2 answer : ",..TopMonkeyBusiness(.monkeys2,monkeyCnt),!
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

ClassMethod ParseMonkeys(inputStream As %Stream.Object, ByRef monkeys, ByRef monkeyCnt As %Integer) As %Status
{
  #Dim sc as %Status = $$$OK
  #Dim ex as %Exception.AbstractException

  #Dim line As %String
  #Dim monkeyIdx As %Integer
  
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
  } catch (ex) {
    set sc = ex.AsStatus()
  }
  quit sc
}

ClassMethod TopMonkeyBusiness(ByRef monkeys, monkeyCnt As %Integer) As %Integer
{
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
 return top1*top2
}

ClassMethod RunMonkeyBusiness(ByRef monkeys, monkeyCnt As %Integer, reliefExpr As %String, roundCnt As %Integer) As %Status
{
  #Dim sc as %Status = $$$OK
  #Dim ex as %Exception.AbstractException

  #Dim round,mky,it,old,newValue as %Integer
  #Dim items as %List
  
  try {
        set round=1
        while (round <= roundCnt) {
          set mky = 0
          while (mky < monkeyCnt) {            
            set items = monkeys(mky,"items")
            for it=1:1:$listlength(items) {

              set old = $listget(items,it)
              set newValue = old              

              xecute ("(old,newValue) set "_monkeys(mky,"fct"), old, .newValue)                            
              xecute ("(old,newValue) set newValue="_reliefExpr,old,.newValue)            

              set dest = $select((newValue # monkeys(mky,"div"))=0:monkeys(mky,"true"),1:monkeys(mky,"false"))

              set $list(monkeys(dest,"items"),*+1) = newValue
              set monkeys(mky,"isp") = monkeys(mky,"isp") + 1
            }
            set monkeys(mky,"items")=""            
            set mky = mky + 1
          }
          set round = round+1
        }
  } catch (ex) {
    set sc = ex.AsStatus()
  }
  quit sc
}

}
