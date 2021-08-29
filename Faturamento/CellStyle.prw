#include "protheus.ch"

User Function CellStyle()
Return .T.

CLASS CellStyle
	DATA   cID
	DATA   cVAlign
	DATA   cHAlign
	DATA   lTopBorder
	DATA   nTopBorderWeight
	DATA   cTopBorderStyle
	DATA   lBottomBorder
	DATA   nBottomBorderWeight
	DATA   cBottomBorderStyle
	DATA   lRightBorder
	DATA   nRightBorderWeight
	DATA   cRightBorderStyle
	DATA   lLeftBorder
	DATA   nLeftBorderWeight
	DATA   cLeftBorderStyle
	DATA   cFontName
	DATA   nFontSize
	DATA   cFontColor
	DATA   lFontBold
	DATA   lFontItalic
	DATA   cFontVAlign
	DATA   cFontUnderline
	DATA   lStrikeThrough
	DATA   cInteriorColor
	DATA   cInteriorPattern
	DATA   cNumberFormat
	DATA   lWrapText
	DATA   nRotate
	
	METHOD New(cID) CONSTRUCTOR
	METHOD SetVAlign(cVAlign)
	METHOD SetHAlign(cHAlign)
	METHOD SetWrapText(lWrapText)
	METHOD SetRotate(nRotate)
	METHOD SetBorder(cBorderPos, cStyle, nWeight, lEnable)
	METHOD RemoveBorder(cBorderPos)
	METHOD SetFont(cName, nSize, cColor, lBold, lItalic, cUnderline, cVAlign, lStrikeThrough)
	METHOD SetInterior(cColor, cPattern)
	METHOD SetNumberFormat(cFormat)
	METHOD GetXML()
	METHOD GetID()
ENDCLASS



METHOD New(cID) CLASS CellStyle  

::cID                   := cID
::cVAlign               := "Center"
::cHAlign               := "Center"
::lTopBorder            := .F.
::nTopBorderWeight      := 1
::cTopBorderStyle       := "Continuous"
::lBottomBorder         := .F.
::nBottomBorderWeight   := 1
::cBottomBorderStyle    := "Continuous"
::lRightBorder          := .F.
::nRightBorderWeight    := 1
::cRightBorderStyle     := "Continuous"
::lLeftBorder           := .F.
::nLeftBorderWeight     := 1
::cLeftBorderStyle      := "Continuous"
::cFontName             := "Calibri"
::nFontSize             := 11
::cFontColor            := "#000000"
::lFontBold             := .F.
::lFontItalic           := .F.
::cFontVAlign           := ""
::cFontUnderline        := ""
::lStrikeThrough        := .F.
::cInteriorColor        := ""
::cInteriorPattern      := "Solid"
::cNumberFormat         := ""
::lWrapText             := .F. 
::nRotate               := 0
	
Return Nil
METHOD SetVAlign(cVAlign) CLASS CellStyle

::cVAlign := Capital(cVAlign)

Return Nil

METHOD SetHAlign(cHAlign) CLASS CellStyle

::cHAlign := Capital(cHAlign)

Return Nil

METHOD SetWrapText(lWrapText) CLASS CellStyle

::lWrapText := lWrapText

Return Nil

METHOD SetRotate(nRotate) CLASS CellStyle

::nRotate := NoRound(nRotate,0)

Return Nil

METHOD SetBorder(cBorderPos, cStyle, nWeight, lEnable) CLASS CellStyle

Default cStyle  := "Continuous"
Default nWeight := 1
Default lEnable := .T.

Do Case
Case Upper(cBorderPos) == "BOTTOM"
	::lBottomBorder          := lEnable
	::nBottomBorderWeight    := nWeight
	::cBottomBorderStyle     := cStyle
Case Upper(cBorderPos) == "LEFT"
	::lLeftBorder            := lEnable
	::nLeftBorderWeight      := nWeight
	::cLeftBorderStyle       := cStyle
Case Upper(cBorderPos) == "RIGHT"
	::lRightBorder           := lEnable
	::nRightBorderWeight     := nWeight
	::cRightBorderStyle      := cStyle
Case Upper(cBorderPos) == "TOP"
	::lTopBorder             := lEnable
	::nTopBorderWeight       := nWeight
	::cTopBorderStyle        := cStyle
Case Upper(cBorderPos) == "ALL"
	::lTopBorder             := lEnable
	::nTopBorderWeight       := nWeight
	::cTopBorderStyle        := cStyle
	::lBottomBorder          := lEnable
	::nBottomBorderWeight    := nWeight
	::cBottomBorderStyle     := cStyle
	::lLeftBorder            := lEnable
	::nLeftBorderWeight      := nWeight
	::cLeftBorderStyle       := cStyle
	::lRightBorder           := lEnable
	::nRightBorderWeight     := nWeight
	::cRightBorderStyle      := cStyle
EndCase

Return Nil

METHOD RemoveBorder(cBorderPos) CLASS CellStyle

Self:SetBorder(cBorderPos,,.F.)

Return Nil

METHOD SetFont(cName, nSize, cColor, lBold, lItalic, cUnderline, cVAlign, lStrike) CLASS CellStyle

Default cName             := "Calibri"
Default nSize             := 11
Default cColor            := "#000000"
Default lBold             := .F.
Default lItalic           := .F.
Default cVAlign           := ""
Default cUnderline        := ""
Default lStrike           := .F.

::cFontName             := cName
::nFontSize             := nSize
::cFontColor            := cColor
::lFontBold             := lBold
::lFontItalic           := lItalic
::cFontUnderline        := cUnderline
::cFontVAlign           := cVAlign
::lStrikeThrough        := lStrike

Return Nil

METHOD SetInterior(cColor, cPattern) CLASS CellStyle

Default cColor    := "#FFFFFF" // Branco
Default cPattern  := "Solid"

::cInteriorColor        := cColor
::cInteriorPattern      := cPattern

Return Nil

METHOD SetNumberFormat(cFormat) CLASS CellStyle

Default cFormat := ""

::cNumberFormat   := cFormat

Return Nil

METHOD GetXML() CLASS CellStyle

Local cRet       := ""
Local cBold      := Iif(::lFontBold, ' ss:Bold="1"', '')
Local cItalic    := Iif(::lFontItalic, ' ss:Italic="1"', '')
Local cStrike    := Iif(::lStrikeThrough, ' ss:StrikeThrough="1"', '')
Local cVAlign    := Iif(!Empty(::cFontVAlign), ' ss:VerticalAlign="'+::cFontVAlign+'"', "")
Local cUnderline := Iif(!Empty(::cFontUnderline), ' ss:Underline="'+::cFontUnderline+'"', "")
Local cRotate    := ""
Local cWrapText  := ""

If ::nRotate <> 0
	cRotate := ' ss:Rotate="'+AllTrim(Str(::nRotate))+'"' 
EndIf

If ::lWrapText
	cWrapText := ' ss:WrapText="1"' 
EndIf

cRet  +=  '<Style ss:ID="'+::cID+'">'+CRLF
cRet  +=  '   <Alignment ss:Horizontal="'+::cHAlign+'" ss:Vertical="'+::cVAlign+'"'+cRotate+cWrapText+'/>'+CRLF

If ::lTopBorder .Or. ::lBottomBorder .Or. ::lRightBorder .Or. ::lLeftBorder	
	cRet  +=  '   <Borders>'+CRLF
	If ::lTopBorder
		cRet  +=  '      <Border ss:Position="Top" ss:LineStyle="'+::cTopBorderStyle+'" ss:Weight="'+AllTrim(Str(::nTopBorderWeight))+'"/>'+CRLF
	EndIf
	If ::lBottomBorder
		cRet  +=  '      <Border ss:Position="Bottom" ss:LineStyle="'+::cBottomBorderStyle+'" ss:Weight="'+AllTrim(Str(::nBottomBorderWeight))+'"/>'+CRLF
	EndIf
	If ::lRightBorder
		cRet  +=  '      <Border ss:Position="Right" ss:LineStyle="'+::cRightBorderStyle+'" ss:Weight="'+AllTrim(Str(::nRightBorderWeight))+'"/>'+CRLF
	EndIf
	If ::lLeftBorder
		cRet  +=  '      <Border ss:Position="Left" ss:LineStyle="'+::cLeftBorderStyle+'" ss:Weight="'+AllTrim(Str(::nLeftBorderWeight))+'"/>'+CRLF
	EndIf
    cRet  +=  '   </Borders>'+CRLF
EndIf	

cRet  +=  '   <Font ss:FontName="'+::cFontName+'" ss:Size="'+AllTrim(Str(::nFontSize))+'"'+CRLF
cRet  +=  '         ss:Color="'+::cFontColor+'"'+cBold+cItalic+cStrike+cVAlign+cUnderline+'/>'+CRLF

If !Empty(::cInteriorColor)
	cRet  +=  '   <Interior ss:Color="'+::cInteriorColor+'" ss:Pattern="'+::cInteriorPattern+'"/>'+CRLF
EndIf

If !Empty(::cNumberFormat)
	cRet  +=  '   <NumberFormat ss:Format="'+::cNumberFormat+'"/>'+CRLF
EndIf
cRet  +=  '</Style>'+CRLF

Return cRet

METHOD GetID() CLASS CellStyle

Local _ID := ::cID
 
Return _ID