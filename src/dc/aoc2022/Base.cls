Class dc.aoc2022.Base
{

Parameter Folder = "/irisdev/app/data/";

ClassMethod GetInputStream(fileName As %String, Output sc As %Status) As %Stream.Object
{
    #Dim ex as %Exception.AbstractException
    #Dim stream as %Stream.Object
    #Dim filePath as %String
    
    Set sc = $$$OK
    Try {
      Set filePath = ##class(%File).NormalizeFilename(fileName,..#Folder)
      Set stream = ##Class(%Stream.FileCharacter).%New()
      $$$TOE(sc,stream.LinkToFile(filePath))
    }
    Catch (ex) {
      Set sc = ex.AsStatus()
    }
    Return stream
}

}
