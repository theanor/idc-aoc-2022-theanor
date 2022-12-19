Class dc.aoc2022.Day19 Extends Base
{

ClassMethod Run(fileName As %String = "input19.txt") As %Status
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

ClassMethod ParseInput(inputStream As %Stream.Object, ByRef blueprints As %DynamicArray) As %Status
{
  #Dim sc as %Status = $$$OK
  #Dim ex as %Exception.AbstractException

  #Dim matcher As %Regex.Matcher
  #Dim blueprint as %DynamicAbstractObject

  
  try {
      set blueprints = []
      set matcher = ##class(%Regex.Matcher).%New("Blueprint ([0-9]+): Each ore robot costs ([0-9]+) ore\. Each clay robot costs ([0-9]+) ore\. Each obsidian robot costs ([0-9]+) ore and ([0-9]+) clay\. Each geode robot costs ([0-9]+) ore and ([0-9]+) obsidian\.")            
      while ('inputStream.AtEnd)
      {
        set line = inputStream.ReadLine(,.sc)
        set line = $zstrip(line,"<>C")
        if matcher.Match(line) {          
          set blueprint = {
            "id" : (matcher.Group(1)+0),
            "geoOre" : (matcher.Group(6)+0),
            "geoObs" : (matcher.Group(7)+0),
            "obsOre" : (matcher.Group(4)+0),
            "obsCla" : (matcher.Group(5)+0),
            "oreOre" : (matcher.Group(2)+0),
            "claOre" : (matcher.Group(3)+0)
          }
          do blueprints.%Push(blueprint)          
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
    
    #Dim line as %String

    #Dim i,t,p as %Integer    

   
    set sc = $$$OK

    try {
      $$$TOE(sc,..ParseInput(inputStream,.blueprints))

      // part 1

      set t = 0
      for i=0:1:blueprints.%Size()-1 {
        write "mining with blueprint id ",blueprints.%Get(i).id,!
        set t = t + (blueprints.%Get(i).id*..Mine(blueprints.%Get(i),0,0,0,1,0,0,24))
      }
      write "Part 1 answer : ",t,!
 
      // part 2

      set p = 1
      for i=0:1:2 {
        write "mining with salvaged blueprint id ",blueprints.%Get(i).id,!
        set p = p *..Mine(blueprints.%Get(i),0,0,0,1,0,0,32)
      }
      write "Part 2 answer : ",p,!

    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

ClassMethod Mine(costs As %DynamicAbstractObject, ore As %Integer, cla As %Integer, obs As %Integer, oreRbt As %Integer, claRbt As %Integer, obsRbt As %Integer, clk As %Integer) As %Integer
{
  #Dim result,t as %Integer

  return:clk<=0 0

  // mine geodes
  return:(costs.geoOre <= ore)&&(costs.geoObs <= obs) (clk-1)+..Mine(costs,ore+oreRbt-costs.geoOre,cla+claRbt,obs+obsRbt-costs.geoObs,oreRbt,claRbt,obsRbt,clk-1)

  // build obsidian mining robot
  return:(costs.obsOre <= ore)&&(costs.obsCla <= cla) ..Mine(costs,ore+oreRbt-costs.obsOre,cla+claRbt-costs.obsCla,obs+obsRbt,oreRbt,claRbt,obsRbt+1,clk-1)

  set result = 0

  if costs.oreOre <= ore { // build ore mining robot
    set t = ..Mine(costs,ore+oreRbt-costs.oreOre,cla+claRbt,obs+obsRbt,oreRbt+1,claRbt,obsRbt,clk-1)
    set:result<t result = t
  }

  if costs.claOre <= ore { // build clay mining robot
    set t = ..Mine(costs,ore+oreRbt-costs.claOre,cla+claRbt,obs+obsRbt,oreRbt,claRbt+1,obsRbt,clk-1)
    set:result<t result = t
  }

  if ore < 6 {  // just let the robot(s) mine
    set t = ..Mine(costs,ore+oreRbt,cla+claRbt,obs+obsRbt,oreRbt,claRbt,obsRbt,clk-1)
    set:result<t result = t
  }
  return result
}

}
