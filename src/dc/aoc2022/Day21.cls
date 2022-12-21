Class dc.aoc2022.Day21 Extends Base
{

ClassMethod Run(fileName As %String = "input21.txt") As %Status
{
    #Dim sc as %Status
    #Dim ex 
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

ClassMethod Node(ByRef t, node As %String, child As %String) As %Boolean
{
  return:node=child 1
  return:$data(t(node,"left"))&&..Node(.t,t(node,"left"),child) 1
  return:$data(t(node,"right"))&&..Node(.t,t(node,"right"),child) 1
  return 0
}

ClassMethod Operator(left As %Integer, op As %String, right As %Integer) As %Integer
{
  return $case(op,"+":left+right,"-":left-right,"*":left*right,"/":left\right,:0)
}

ClassMethod Evaluate(ByRef t, node As %String) As %Integer
{
  return:'$data(t(node,"op")) t(node,"value")
  return ..Operator(..Evaluate(.t,t(node,"left")),t(node,"op"),..Evaluate(.t,t(node,"right")))
}

ClassMethod Solve(ByRef t, node As %String, target As %Integer) As %Integer
{
  #Dim humanLeft As %Boolean
  #Dim humnSide,monkSide As %String
  #Dim monkValue As %Integer

  return:node="humn" target  

  s humanLeft = ..Node(.t,t(node,"left"),"humn")

  if humanLeft {
    s humnSide = t(node,"left")
    s monkSide = t(node,"right")
  } else {
    s humnSide = t(node,"right")
    s monkSide = t(node,"left")
  }  

  s monkValue = ..Evaluate(.t,monkSide)

  if t(node,"op")="+" {
    s target = target - monkValue
  } elseif t(node,"op")="-" {
    if humanLeft {
     s target = target+monkValue
    } else {
     s target = monkValue-target
    }
  } elseif t(node,"op")="*" {
    s target = target \ monkValue
  } elseif t(node,"op")="/" {
    if humanLeft {
      s target = target * monkValue
    } else {
      s target = monkValue \ target
    } 
  }

  return ..Solve(.t,humnSide,target)
}

ClassMethod ParseInput(inputStream As %Stream.Object, ByRef t) As %Status
{
  #Dim sc as %Status = $$$OK
  #Dim ex as %Exception.AbstractException

  #Dim matcher as %Regex.Matcher
  #Dim line as %String
  #Dim node,left,op,right As %String


  s sc = $$$OK  
  try {
      s matcher = ##class(%Regex.Matcher).%New("([a-z]+)\:\s+([0-9,a-z]+)\s?([\+\-\*\/]?)\s?([a-z,0-9]*)")
      while ('inputStream.AtEnd)
      {
        set line = inputStream.ReadLine(,.sc)
        set line = $zstrip(line,"<>C")
        if matcher.Match(line) {
          s node = matcher.Group(1)
          s left = matcher.Group(2)
          s op = matcher.Group(3)
          s right = matcher.Group(4)
                 
          if right="" {
            s t(node,"value") = left+0
          } else {
           s t(node,"op") = op
           s t(node,"left") = left
           s t(node,"right") = right
          }                    
        } else {
          throw ##class(%Exception.General).%New("invalid input")
        }
      }
  } catch (ex) {
    s sc = ex.AsStatus()
  }
  q sc
}

ClassMethod Part1And2(inputStream As %Stream.Object) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException
    

    #Dim t
    #Dim humn,monk As %String
    #Dim expected As %Integer
    #Dim x As %Integer
    #Dim human As %Integer

    set sc = $$$OK
    try {        
      $$$TOE(sc,..ParseInput(inputStream,.t))
      write "Part 1 answer : ",..Evaluate(.t,"root"),!

      if ..Node(.t,t("root","left"),"humn") {
        s humn = t("root","left")
        s monk = t("root","right")
      } else {
        s humn = t("root","right")
        s monk = t("root","left")
      }
      s expected = ..Evaluate(.t,monk)
      s t(humn,"value") = expected
      s x = ..Solve(.t,humn,expected)
      write "Part 2 answer : ",x,!

      s t("humn","value") = x
      s human = ..Evaluate(.t,humn)
      if expected '= human {
        write "!! root monkey is angry : human side value ",human," not matching value expected by root monkey ",expected,!
      }      
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

}
