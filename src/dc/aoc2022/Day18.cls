Class dc.aoc2022.Day18 Extends Base
{

ClassMethod Run(fileName As %String = "input18.txt") As %Status
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

ClassMethod AddCube(ByRef lava, x As %Integer, y As %Integer, z As %Integer)
{
  #Dim sides As %Integer
    
  set sides = 6
  if $data(lava(x+1,y,z)) {    
    set sides = sides - 1
    set lava(x+1,y,z) = lava(x+1,y,z) -1
    set lava = lava - 1
  }
  if $data(lava(x-1,y,z)) {        
    set sides = sides - 1
    set lava(x-1,y,z) = lava(x-1,y,z) -1
    set lava = lava - 1
  }
  if $data(lava(x,y+1,z)) {    
    set sides = sides - 1
    set lava(x,y+1,z) = lava(x,y+1,z) -1
    set lava = lava - 1
  }
  if $data(lava(x,y-1,z)) {    
    set sides = sides - 1
    set lava(x,y-1,z) = lava(x,y-1,z) -1
    set lava = lava - 1
  }
  if $data(lava(x,y,z+1)) {    
    set sides = sides - 1
    set lava(x,y,z+1) = lava(x,y,z+1) -1
    set lava = lava - 1
  }
  if $data(lava(x,y,z-1)) {    
    set sides = sides - 1
    set lava(x,y,z-1) = lava(x,y,z-1) -1
    set lava = lava - 1
  }
  set lava(x,y,z) = sides
  set lava = lava+sides
}

// icy (-5°C outside here...), lazy Sunday : pretty straightforward, inefficient solution

ClassMethod PerimeterArea(ByRef lava) As %Integer
{
  #Dim f as %Boolean
  #Dim x,y,z As %Integer
  #Dim fx,fy,fz As %Integer
  #Dim q,n as %List
  #Dim nx,ny,nz As %Integer
  #Dim air

  // find air cell to start flood
  set f=0
  for x=lava("minx"):1:lava("maxx") {
    for y=lava("miny"):1:lava("maxy") {
      for z=lava("minz"):1:lava("maxz") {
        if '$data(lava(x,y,z)) {
          set fx = x,fy=y,fz=z
          set f=1
          quit
        }
      }
      quit:f
    }    
    quit:f
  }

  // flood air around lava
  set q = $listbuild($listbuild(fx,fy,fz))
  set air = 0
  while $listlength(q) > 0 {
    set n = $listget(q,1)
    set q = $list(q,2,*)
    set nx=$listget(n,1)
    set ny=$listget(n,2)
    set nz=$listget(n,3)
    if '$data(lava(nx,ny,nz)) && '$data(air(nx,ny,nz)) {
      set air(nx,ny,nz)=1      
      set:(nx+1)<=lava("maxx") $list(q,*+1) = $listbuild(nx+1,ny,nz)
      set:(nx-1)>=lava("minx") $list(q,*+1) = $listbuild(nx-1,ny,nz)
      set:(ny+1)<=lava("maxy") $list(q,*+1) = $listbuild(nx,ny+1,nz)
      set:(ny-1)>=lava("miny") $list(q,*+1) = $listbuild(nx,ny-1,nz)
      set:(nz+1)<=lava("maxz") $list(q,*+1) = $listbuild(nx,ny,nz+1)
      set:(nz-1)>=lava("minz") $list(q,*+1) = $listbuild(nx,ny,nz-1)
    }
  }

  // count exposed facets of solid = -air
  set solid = 0
  for x=lava("minx"):1:lava("maxx") {
    for y=lava("miny"):1:lava("maxy") {
      for z=lava("minz"):1:lava("maxz") {
        if '$data(air(x,y,z)) {
          do ..AddCube(.solid,x,y,z)
        }
      }
    }    
  }
  return solid
}

ClassMethod Part1(inputStream As %Stream.Object) As %Status
{
    #Dim sc as %Status
    #Dim ex as %Exception.AbstractException
    
    #Dim line as %String
    #Dim x,y,z as %Integer
    #Dim lava

   
    set sc = $$$OK
    try {       
      set lava = 0
      while ('inputStream.AtEnd)
      {
        set line = inputStream.ReadLine(,.sc)
        set line = $zstrip(line,"<>C")
        set x = $piece(line,",",1)
        set y = $piece(line,",",2)
        set z = $piece(line,",",3)

        do ..AddCube(.lava,x,y,z)
      }
      write "Part 1 answer : ",lava,!
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

ClassMethod Part2(inputStream As %Stream.Object) As %Status
{
    #Dim line as %String

    set sc = $$$OK
    try {        
      set lava = 0
      while ('inputStream.AtEnd)
      {
        set line = inputStream.ReadLine(,.sc)
        set line = $zstrip(line,"<>C")
        set x = $piece(line,",",1)
        set y = $piece(line,",",2)
        set z = $piece(line,",",3)

        set:x<$get(lava("minx"),..#MAXINT) lava("minx") = x
        set:x>$get(lava("maxx"),-..#MAXINT) lava("maxx") = x

        set:y<$get(lava("miny"),..#MAXINT) lava("miny") = y
        set:y>$get(lava("maxy"),-..#MAXINT) lava("maxy") = y
 
        set:z<$get(lava("minz"),..#MAXINT) lava("minz") = z
        set:z>$get(lava("maxz"),-..#MAXINT) lava("maxz") = z 

        set lava(x,y,z) = 1

      }      
      write "Part 2 answer : ",..PerimeterArea(.lava),!
    }
    catch (ex) {
      set sc = ex.AsStatus()
    }
    return sc
}

}
