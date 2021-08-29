#include "protheus.ch"

#define  TAMANHO_LIMITE 50000 

User Function ExcelXML()
Return .T.

CLASS ExcelXML
	DATA   aRowCount
	DATA   aColCount
	DATA   aCells
	DATA   cStyles          // String contendo o c€digo XML de todos os estilos utilizados pela planilha.
	DATA   cStylesAux       // String auxiliar que cont»m o ID de todos os estilos utilizados (separado por | ). Utilizado para otimiza¡Ño de performance.
	DATA   aColSizes
	DATA   aRowSizes
	DATA   aMerge
	DATA   aShowGridLine
	DATA   aZoom
	DATA   aLayout
	DATA   aHCenter
	DATA   aVCenter
	DATA   aTopMar
	DATA   aBottomMar
	DATA   aLeftMar
	DATA   aRightMar
	DATA   aHeaderMar
	DATA   aFooterMar
	DATA   aPaperSize
	DATA   aZoomScale
	DATA   aValidPrinter
	DATA   aFitWidth
	DATA   aFitHeight
	DATA   aRowBreak
	DATA   aColBreak
	DATA   aFreezeRow
	DATA   aFilter
	DATA   nFolderCount
	DATA   nFolderIndex
	DATA   aFolderName
	
	METHOD New() CONSTRUCTOR
	METHOD AddRow(aRowSize, aItens, xStyles, nPos)
	METHOD SetColSize(aColSize)
	METHOD SkipLine(cRowSize, xStyle, nQtdLin)
	METHOD SetMerge(nRow, nCol, nRowSize, nColSize)
	METHOD DefMergeData(nLinIni, nColIni, nLinQtd, nColQtd)
	METHOD ShowGridLine(lShow)
	METHOD SetZoom(nZoom)
	METHOD SetPageSetup(nLayout, lHCenter, lVCenter, nTopMar, nBottomMar, nLeftMar, nRightMar, nHeaderMar, nFooterMar)
	METHOD SetPrintSetup(nPaperSize, nZoomScale, nFitWidth, nFitHeight, lValidPrinter)
	METHOD SetRowBreak(nRow)
	METHOD SetColBreak(nCol)
	METHOD SetFreezeRow(nRow)
	METHOD SetFilter(nLinIni, nColIni, nLinFim, nColFim)
	METHOD SetFolder(nFolder)
	METHOD SetFolderName(cName)
	METHOD GetXML(cArquivo)
	METHOD GetCSV()
ENDCLASS

METHOD New() CLASS ExcelXML

::aCells        := {{}}
::aRowSizes     := {{}}
::aColSizes     := {{}}
::cStyles       := ""
::cStylesAux    := "|"
::aMerge        := {{}}
::aRowCount     := {0}
::aColCount     := {0}
::aShowGridLine := {.T.}
::aZoom         := {100}
::aLayout       := {1}
::aHCenter      := {.F.}
::aVCenter      := {.F.}
::aTopMar       := {2}
::aBottomMar    := {2}
::aLeftMar      := {1.3}
::aRightMar     := {1.3} 
::aHeaderMar    := {0.8}
::aFooterMar    := {0.8}
::aPaperSize    := {9}
::aZoomScale    := {100}
::aValidPrinter := {.F.}
::aFitWidth     := {0}
::aFitHeight    := {0}
::aRowBreak     := {{}}
::aColBreak     := {{}}
::aFreezeRow    := {0}
::aFilter       := {{}}
::nFolderIndex  := 1
::nFolderCount  := 1
::aFolderName   := {"Plan1"}

Return Nil

METHOD AddRow(cRowSize, aItens, xStyles, nPos) CLASS ExcelXML

Local nI       := 0

aAdd(::aCells[::nFolderIndex], {}) // Adiciona a nova linha a planilha

For nI := 1 To Len(aItens)
	If ValType(xStyles) == "A" // Passado um array, onde vocÕ tem um estilo para cada c»lula
		If nI > Len(xStyles)
			aAdd(::aCells[::nFolderIndex, Len(::aCells[::nFolderIndex])], {aItens[nI], Nil})
		Else
			If ValType(xStyles[nI]) == "O"
				aAdd(::aCells[::nFolderIndex, Len(::aCells[::nFolderIndex])], {aItens[nI], xStyles[nI]:cID})
				If !"|"+xStyles[nI]:cID+"|" $ ::cStylesAux
					::cStyles += xStyles[nI]:GetXML()
					::cStylesAux += xStyles[nI]:cID+"|"
				EndIf
			Else
				aAdd(::aCells[::nFolderIndex, Len(::aCells[::nFolderIndex])], {aItens[nI], Nil})
			EndIf				
		EndIf
	Else
		If ValType(xStyles) == "O" 
			aAdd(::aCells[::nFolderIndex, Len(::aCells[::nFolderIndex])], {aItens[nI], xStyles:cID})
			If !"|"+xStyles:cID+"|" $ ::cStylesAux
				::cStyles += xStyles:GetXML()
				::cStylesAux += xStyles:cID+"|"
			EndIF
		Else
			aAdd(::aCells[::nFolderIndex, Len(::aCells[::nFolderIndex])], {aItens[nI], Nil})
		EndIf	
	EndIf	
Next nI
                                                     
//+-------------------------------------------------+
//| Define o tamanho da linha                       |
//+-------------------------------------------------+
aAdd(::aRowSizes[::nFolderIndex], cRowSize)

//+-------------------------------------------------+
//| Incrementa a contagem de linhas                 |
//+-------------------------------------------------+
::aRowCount[::nFolderIndex]++

//+-------------------------------------------------+
//| Incrementa a contagem de colunas                |
//| (atualiza com o maior valor)                    |
//+-------------------------------------------------+
If Len(aItens) > ::aColCount[::nFolderIndex]
	::aColCount[::nFolderIndex] := Len(aItens)
EndIf

Return Nil


METHOD SetColSize(aColSize) CLASS ExcelXML
                        
::aColSizes[::nFolderIndex] := aColSize

Return Nil

METHOD SkipLine(cRowSize, xStyle, nQtdLin) CLASS ExcelXML

Local aCols := {}
Local nA := 1

Default nQtdLin := 1

If ::aColCount[::nFolderIndex] > 0
	For nA := 1 To ::aColCount[::nFolderIndex]
		aAdd(aCols, "")
	Next nA
EndIf

For nA := 1 To nQtdLin
	Self:AddRow(cRowSize, aCols, xStyle)
Next nA

Return Nil

METHOD SetMerge(nRow, nCol, nRowSize, nColSize) CLASS ExcelXML

Default nRow     := ::aRowCount[::nFolderIndex]
Default nCol     := 1
Default nRowSize := 0
Default nColSize := 0

If nRowSize <> 0 .Or. nColSize <> 0
	::DefMergeData(nRow, nCol, nRowSize, nColSize)
EndIf

Return .T.

METHOD DefMergeData(nLinIni, nColIni, nLinQtd, nColQtd) CLASS ExcelXML

Local nLin      := 0
Local nCol      := 0
Local nLinFim   := nLinIni + nLinQtd
Local nColFim   := nColIni + nColQtd

For nLin := nLinIni To nLinFim
                              
	For nCol := nColIni To nColFim + 1 //Adiciona 1, pois a pr€xima coluna pode ter a informa¡Ño do indice
		oMrgSts := GetObjArray(::aMerge[::nFolderIndex], nLin, nCol)
		
		If oMrgSts == Nil
			oMrgSts := MergeCellInfo():New()
		EndIf
	
		If nLin == nLinIni .And. nCol == nColIni
			If nColQtd > 0
				//+---------------+
				//|  Merge Across |
				//+---------------+
	    		oMrgSts:nMergeAcross := nColQtd
			EndIf
			If nLinQtd > 0
				//+---------------+
				//| Merge Down    |
				//+---------------+
	    		oMrgSts:nMergeDown := nLinQtd
			EndIf			
		ElseIf nCol <= nColFim
			//+---------------+
			//| Skip          |
			//+---------------+
	  		oMrgSts:lSkip := .T.
		ElseIf nCol > nColFim .And. nLin > nLinIni
			//+---------------+
			//| Index         |
			//+---------------+
	    	oMrgSts:nIndex := nColFim + 1
		EndIf		
	    
	    //+-----------------------------------------+
	    //| Adiciona o status de merge ao array     |
	    //+-----------------------------------------+
		AddObjArray(@::aMerge[::nFolderIndex], nLin, nCol, oMrgSts)
	Next nCol

Next nLin

Return .T.

METHOD ShowGridLine(lShow) CLASS ExcelXML

::aShowGridLine[::nFolderIndex] := lShow

Return Nil

METHOD SetZoom(nZoom) CLASS ExcelXML

::aZoom[::nFolderIndex] := NoRound(nZoom,0)

Return Nil

METHOD SetPageSetup(nLayout, lHCenter, lVCenter, nTopMar, nBottomMar, nLeftMar, nRightMar, nHeaderMar, nFooterMar) CLASS ExcelXML

Default nLayout       := 1
Default lHCenter      := .F.
Default lVCenter      := .F.
Default nTopMar       := 2
Default nBottomMar    := 2
Default nLeftMar      := 1.3
Default nRightMar     := 1.3
Default nHeaderMar    := 0.8
Default nFooterMar    := 0.8
      
::aLayout[::nFolderIndex]     := nLayout
::aHCenter[::nFolderIndex]    := lHCenter
::aVCenter[::nFolderIndex]    := lVCenter
::aTopMar[::nFolderIndex]     := nTopMar * 0.3937 // 0.3937 = Constante do tamanho para 1 centÃmetro
::aBottomMar[::nFolderIndex]  := nBottomMar * 0.3937
::aLeftMar[::nFolderIndex]    := nLeftMar * 0.3937
::aRightMar[::nFolderIndex]   := nRightMar * 0.3937
::aHeaderMar[::nFolderIndex]  := nHeaderMar * 0.3937
::aFooterMar[::nFolderIndex]  := nFooterMar * 0.3937

Return .T.

METHOD SetPrintSetup(nPaperSize, nZoomScale, nFitWidth, nFitHeight, lValidPrinter) CLASS ExcelXML
                                                                  
Default nPaperSize    := 9
Default nZoomScale    := 100
Default nFitWidth     := 0
Default nFitHeight    := 0
Default lValidPrinter := .F.

::aPaperSize[::nFolderIndex]    := nPaperSize
::aZoomScale[::nFolderIndex]    := nZoomScale
::aFitWidth[::nFolderIndex]     := nFitWidth
::aFitHeight[::nFolderIndex]    := nFitHeight
::aValidPrinter[::nFolderIndex] := lValidPrinter

Return .T.

METHOD SetRowBreak(nRow) CLASS ExcelXML
                      
Default nRow := ::aRowCount[::nFolderIndex]

If aScan(::aRowBreak[::nFolderIndex], {|x| x == nRow}) == 0
	aAdd(::aRowBreak[::nFolderIndex], nRow)
EndIf

Return Nil

METHOD SetColBreak(nCol) CLASS ExcelXML

Default nCol := ::aColCount[::nFolderIndex]

If aScan(::aColBreak[::nFolderIndex], {|x| x == nCol}) == 0
	aAdd(::aColBreak[::nFolderIndex], nCol)
EndIf

Return Nil
	
METHOD SetFreezeRow(nRow) CLASS ExcelXML
                      
Default nRow := ::aRowCount[::nFolderIndex]

::aFreezeRow[::nFolderIndex] := nRow

Return Nil

METHOD SetFilter(nLinIni, nColIni, nLinFim, nColFim) CLASS ExcelXML
                      
Default nLinIni := ::aRowCount[::nFolderIndex]
Default nLinFim := ::aRowCount[::nFolderIndex]
Default nColIni := 1
Default nColFim := ::aColCount[::nFolderIndex]

::aFilter[::nFolderIndex] := {nLinIni, nColIni, nLinFim, nColFim}

Return Nil

METHOD SetFolder(nFolder) CLASS ExcelXML

Local nI
Default nFolder := 1

For nI := (::nFolderCount+1) To nFolder
	aAdd(::aCells, {})
	aAdd(::aRowSizes, {})
	aAdd(::aColSizes, {})
	aAdd(::aMerge, {})
	aAdd(::aRowCount, 0)
	aAdd(::aColCount, 0)
	aAdd(::aShowGridLine, .T.)
	aAdd(::aZoom, 100)
	aAdd(::aLayout, 1)
	aAdd(::aHCenter, .F.)
	aAdd(::aVCenter, .F.)
	aAdd(::aTopMar, 2)
	aAdd(::aBottomMar, 2)
	aAdd(::aLeftMar, 1.3)
	aAdd(::aRightMar, 1.3) 
	aAdd(::aHeaderMar, 0.8)
	aAdd(::aFooterMar, 0.8)
	aAdd(::aPaperSize, 9)
	aAdd(::aZoomScale, 100)
	aAdd(::aValidPrinter, .F.)
	aAdd(::aFitWidth, 0)
	aAdd(::aFitHeight, 0)
	aAdd(::aRowBreak, {})
	aAdd(::aColBreak, {})
	aAdd(::aFreezeRow, 0)
	aAdd(::aFilter, {})
	aAdd(::aFolderName, "Plan"+AllTrim(Str(nI)))
Next nI
If nFolder > ::nFolderCount
	::nFolderCount := nFolder
EndIf
::nFolderIndex := nFolder

Return Nil

METHOD SetFolderName(cName) CLASS ExcelXML

Default cName := "Plan"+AllTrim(Str(::nFolderIndex))

::aFolderName[::nFolderIndex] := cName

Return Nil

METHOD GetXML(cArquivo) CLASS ExcelXML
Local cRet         := ""
Local nA, nB
Local cStyle       := ""
Local nPosMerge    := 0
Local lSkipCell    := .F. // Indica se deve omitir a impressÑo de uma c»lula
Local nMerRowIni   := 0
Local nMerColIni   := 0
Local nMerRowLim   := 0
Local nMerColLim   := 0
Local lLastPos     := .F.
Local cColCount    := ""
Local cRowCount    := ""
Local cLayout      := ""
Local cHorCenter   := ""
Local cVerCenter   := ""
Local bGravaLinha  := {|cLinha| Iif(lGravaDisco, FWrite(nHandle, cLinha), cRet += cLinha)}
Local nHandle      := 0
Local cArqTemp     := "\EXCELXML"
Local aArqTemp     := {}
Local lGravaDisco  := .F.
Local cDirDestino  := ""
Local nFldIdx      := 1
Local nI           := 0
Local oMerge       := Nil

Default cArquivo   := ""
lGravaDisco        := !Empty(cArquivo)

//+------------------------------------------------------+
//| Abre o arquivo onde ser∑ salvo o XML caso seja usado |
//+------------------------------------------------------+
If lGravaDisco
	makeDir(cArqTemp)
	cArqTemp +="\"+DtoS(Date())+StrTran(Time(),":","")+__cUserID // Gera um diret€rio tempor∑rio no servidor com a data + o c€digo do usu∑rio
	makeDir(cArqTemp)
	cArqtemp += SubStr(cArquivo, Rat("\", cArquivo))
	nHandle := FCreate(cArqTemp, 1) // 1 = FC_NORMAL (leitura + grava¡Ño)
EndIf

Eval(bGravaLinha, '<?xml version="1.0" encoding="ISO-8859-1" ?>'+CRLF)
Eval(bGravaLinha, '<?mso-application progid="Excel.Sheet"?>'+CRLF)
Eval(bGravaLinha, '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"'+CRLF)
Eval(bGravaLinha, ' xmlns:o="urn:schemas-microsoft-com:office:office"'+CRLF)
Eval(bGravaLinha, ' xmlns:x="urn:schemas-microsoft-com:office:excel"'+CRLF)
Eval(bGravaLinha, ' xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"'+CRLF)
Eval(bGravaLinha, ' xmlns:html="http://www.w3.org/TR/REC-html40">'+CRLF)
Eval(bGravaLinha, ' <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">'+CRLF)
Eval(bGravaLinha, '  <Created></Created>'+CRLF)
Eval(bGravaLinha, '  <Version>12.00</Version>'+CRLF)
Eval(bGravaLinha, ' </DocumentProperties>'+CRLF)
Eval(bGravaLinha, ' <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">'+CRLF)
Eval(bGravaLinha, '  <WindowHeight>8415</WindowHeight>'+CRLF)
Eval(bGravaLinha, '  <WindowWidth>19095</WindowWidth>'+CRLF)
Eval(bGravaLinha, '  <WindowTopX>0</WindowTopX>'+CRLF)
Eval(bGravaLinha, '  <WindowTopY>150</WindowTopY>'+CRLF)
Eval(bGravaLinha, '  <ProtectStructure>False</ProtectStructure>'+CRLF)
Eval(bGravaLinha, '  <ProtectWindows>False</ProtectWindows>'+CRLF)
Eval(bGravaLinha, ' </ExcelWorkbook>'+CRLF)
Eval(bGravaLinha, ' <Styles>'+CRLF)
Eval(bGravaLinha, '  <Style ss:ID="Default" ss:Name="Normal">'+CRLF)
Eval(bGravaLinha, '   <Alignment ss:Vertical="Bottom"/>'+CRLF)
Eval(bGravaLinha, '   <Borders/>'+CRLF)
Eval(bGravaLinha, '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'+CRLF)
Eval(bGravaLinha, '   <Interior/>'+CRLF)
Eval(bGravaLinha, '   <NumberFormat/>'+CRLF)
Eval(bGravaLinha, '   <Protection/>'+CRLF)
Eval(bGravaLinha, '  </Style>'+CRLF)
Eval(bGravaLinha, '  <Style ss:ID="sData">'+CRLF)
Eval(bGravaLinha, '     <NumberFormat ss:Format="Short Date"/>'+CRLF)
Eval(bGravaLinha, '    </Style>'+CRLF)
//+-------------------------------+
//| Insere os estilos criados     |
//+-------------------------------+
Eval(bGravaLinha, ::cStyles)
Eval(bGravaLinha, ' </Styles>'+CRLF)

For nFldIdx := 1 To ::nFolderCount
	cColCount := Iif(::aColCount[nFldIdx] > 1, AllTrim(Str(::aColCount[nFldIdx])), "1")
	cRowCount := Iif(::aRowCount[nFldIdx] > 1, AllTrim(Str(::aRowCount[nFldIdx])), "1")

	Eval(bGravaLinha, ' <Worksheet ss:Name="'+::aFolderName[nFldIdx]+'">'+CRLF)
	Eval(bGravaLinha, '  <Table ss:ExpandedColumnCount="'+cColCount+'" ss:ExpandedRowCount="'+cRowCount+'" x:FullColumns="1"'+CRLF)
	Eval(bGravaLinha, '   x:FullRows="1" ss:DefaultRowHeight="15">'+CRLF)
	                                   
	//+-------------------------------+
	//| Insere a largura das colunas  |
	//+-------------------------------+
	If ValType(::aColSizes[nFldIdx]) == "A" .And. Len(::aColSizes[nFldIdx]) > 0
		For nA := 1 To Min(Len(::aColSizes[nFldIdx]),::aColCount[nFldIdx])
			Eval(bGravaLinha, '   <Column ss:AutoFitWidth="0" ss:Width="'+AllTrim(::aColSizes[nFldIdx, nA])+'"/>'+CRLF)
		Next nA
	EndIf
	
	//+-------------------------------+
	//| Insere as c»lulas na planilha |
	//+-------------------------------+
	If Len(::aCells[nFldIdx]) > 0
		ProcRegua(Len(::aCells[nFldIdx]))	
		For nA := 1 To Len(::aCells[nFldIdx])
			IncProc("Gravando dados no arquivo ("+AllTrim(Str(nFldIdx))+"/"+AllTrim(Str(::nFolderCount))+")...")
			If ValType(::aCells[nFldIdx, nA]) == "A"
				
				// Define a altura da linha caso tenha sido informado
				If ValType(::aRowSizes[nFldIdx]) == "A" .And. Len(::aRowSizes[nFldIdx]) >= nA .And. ValType(::aRowSizes[nFldIdx, nA]) == "C" 
					Eval(bGravaLinha, '    <Row ss:AutoFitHeight="0" ss:Height="'+AllTrim(::aRowSizes[nFldIdx, nA])+'">'+CRLF)
				Else
					Eval(bGravaLinha, '    <Row>'+CRLF)
				EndIf
				
				For nB := 1 To Len(::aCells[nFldIdx, nA])
				    
				    lSkipCell := .F.
				    cMerge    := "" 
				    
				    //+-------------------------------------------+
				    //| Tratamento para o merge entre as c»lulas. |
				    //+-------------------------------------------+
				    oMerge := GetObjArray(::aMerge[nFldIdx], nA, nB)
				    
				    If ValType(oMerge) == "O"
				    	If oMerge:lSkip
				    		lSkipCell := .T.
				    	Else
					    	If oMerge:nMergeAcross > 0
					    		cMerge := ' ss:MergeAcross="'+AllTrim(Str(oMerge:nMergeAcross))+'"'
					    	EndIf
					    	If oMerge:nMergeDown > 0
					    		cMerge += ' ss:MergeDown="'+AllTrim(Str(oMerge:nMergeDown))+'"'
					    	EndIf
					    	If oMerge:nIndex > 0 
				    			cMerge += ' ss:Index="'+AllTrim(Str(oMerge:nIndex))+'"'
					    	EndIf
					    EndIf		    
				    EndIf
				    
				    
				    If !lSkipCell
					    cStyle := ""
					    If ValType(::aCells[nFldIdx, nA, nB, 2]) == "C"
					    	cStyle := ' ss:StyleID="'+::aCells[nFldIdx, nA, nB, 2]+'"'
					    EndIf
					
						// Define o tipo de dado da c»lula
						If ValType(::aCells[nFldIdx, nA, nB, 1]) == "C"
							If  Len(::aCells[nFldIdx, nA, nB, 1]) == 9 .And. SubStr(::aCells[nFldIdx, nA, nB, 1],1,1) == "T" .And. SubStr(::aCells[nFldIdx, nA, nB, 1],4,1) == ":" .And. SubStr(::aCells[nFldIdx, nA, nB, 1],7,1) == ":" // Formato Hora => T99:99:99
								cStyle   := Iif(Empty(cStyle), ' ss:StyleID="sData"', cStyle)
								Eval(bGravaLinha, '      <Cell'+cMerge+cStyle+'><Data ss:Type="DateTime">1899-12-31'+::aCells[nFldIdx, nA, nB, 1]+'.000</Data></Cell>'+CRLF)	
							ElseIf SubStr(::aCells[nFldIdx, nA, nB, 1],1,1) == "=" // F€rmula
								Eval(bGravaLinha, '      <Cell'+cMerge+cStyle+' ss:Formula="'+::aCells[nFldIdx, nA, nB, 1]+'"><Data ss:Type="Number"></Data></Cell>'+CRLF)	
							ElseIf Upper(SubStr(::aCells[nFldIdx, nA, nB, 1],1,5)) == "HREF=" // Link Web
								Eval(bGravaLinha, '      <Cell'+cMerge+cStyle+' ss:HRef="'+SubStr(::aCells[nFldIdx, nA, nB, 1],6,At("|", ::aCells[nFldIdx, nA, nB, 1])-6)+'"><Data ss:Type="String">'+SubStr(::aCells[nFldIdx, nA, nB, 1],At("|", ::aCells[nFldIdx, nA, nB, 1])+1)+'</Data></Cell>'+CRLF)
					  		Else
					  			Eval(bGravaLinha, '      <Cell'+cMerge+cStyle+'><Data ss:Type="String">'+::aCells[nFldIdx, nA, nB, 1]+'</Data></Cell>'+CRLF)
							EndIf
						ElseIf ValType(::aCells[nFldIdx, nA, nB, 1]) == "N"
							Eval(bGravaLinha, '      <Cell'+cMerge+cStyle+'><Data ss:Type="Number">'+AllTrim(Str(::aCells[nFldIdx, nA, nB, 1]))+'</Data></Cell>'+CRLF)
						ElseIf ValType(::aCells[nFldIdx, nA, nB, 1]) == "D"
							If !Empty(DtoS(::aCells[nFldIdx, nA, nB, 1]))
								cStyle := Iif(Empty(cStyle), ' ss:StyleID="sData"', cStyle)
								Eval(bGravaLinha, '      <Cell'+cMerge+cStyle+'><Data ss:Type="DateTime">'+SubStr(DtoS(::aCells[nFldIdx, nA, nB, 1]),1,4)+'-'+SubStr(DtoS(::aCells[nFldIdx, nA, nB, 1]),5,2)+'-'+SubStr(DtoS(::aCells[nFldIdx, nA, nB, 1]),7,2)+'T00:00:00.000</Data></Cell>'+CRLF)
							Else // Tratamento para data em branco
								Eval(bGravaLinha, '      <Cell'+cMerge+cStyle+'><Data ss:Type="String"></Data></Cell>'+CRLF)
							EndIf
						Else
							Eval(bGravaLinha, '      <Cell'+cMerge+cStyle+'><Data ss:Type="String"></Data></Cell>'+CRLF)
						EndIf
				    EndIf
				Next nB
				Eval(bGravaLinha, '    </Row>'+CRLF)
			EndIf
		Next nA
	EndIf
	
	Eval(bGravaLinha, '  </Table>'+CRLF)
	Eval(bGravaLinha, '  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">'+CRLF)
		
	//+----------------------------------------------+
	//| Tratamento para a configura¡Ño da p∑gina     |
	//+----------------------------------------------+
	cLayout    := Iif(::aLayout[nFldIdx] <> 1, ' x:Orientation="Landscape"', '') // Retrato = 1 / Paisagem = 2
	cHorCenter := Iif(::aHCenter[nFldIdx], ' x:CenterHorizontal="1"', '')
	cVerCenter := Iif(::aVCenter[nFldIdx], ' x:CenterVertical="1"', '')	
	
	Eval(bGravaLinha, '   <PageSetup>'+CRLF)
	If !Empty(cLayout) .Or. !Empty(cHorCenter) .Or. !Empty(cVerCenter) 
		Eval(bGravaLinha, '    <Layout'+cLayout+cHorCenter+cVerCenter+'/>'+CRLF)
	EndIf
	Eval(bGravaLinha, '    <Header x:Margin="'+AllTrim(Str(::aHeaderMar[nFldIdx]))+'"/>'+CRLF)
	Eval(bGravaLinha, '    <Footer x:Margin="'+AllTrim(Str(::aFooterMar[nFldIdx]))+'"/>'+CRLF)
	Eval(bGravaLinha, '    <PageMargins x:Bottom="'+AllTrim(Str(::aBottomMar[nFldIdx]))+'" x:Left="'+AllTrim(Str(::aLeftMar[nFldIdx]))+'"'+CRLF)
	Eval(bGravaLinha, '     x:Right="'+AllTrim(Str(::aRightMar[nFldIdx]))+'" x:Top="'+AllTrim(Str(::aTopMar[nFldIdx]))+'"/>'+CRLF)
	Eval(bGravaLinha, '   </PageSetup>'+CRLF)
	Eval(bGravaLinha, '   <Unsynced/>'+CRLF)
	

	Eval(bGravaLinha, '   <Print>'+CRLF)
	Eval(bGravaLinha, '    <FitWidth>'+AllTrim(Str(::aFitWidth[nFldIdx]))+'</FitWidth>'+CRLF)
	Eval(bGravaLinha, '    <FitHeight>'+AllTrim(Str(::aFitHeight[nFldIdx]))+'</FitHeight>'+CRLF)
	If ::aValidPrinter[nFldIdx]
		Eval(bGravaLinha, '    <ValidPrinterInfo/>'+CRLF)
	EndIf
	Eval(bGravaLinha, '    <FitHeight>'+AllTrim(Str(::aFitHeight[nFldIdx]))+'</FitHeight>'+CRLF)
	Eval(bGravaLinha, '    <PaperSizeIndex>'+AllTrim(Str(::aPaperSize[nFldIdx]))+'</PaperSizeIndex>'+CRLF)
	Eval(bGravaLinha, '    <Scale>'+AllTrim(Str(::aZoomScale[nFldIdx]))+'</Scale>'+CRLF)
	Eval(bGravaLinha, '   </Print>'+CRLF)
	   
	//+----------------------------------------------+
	//| Tratamento para o zoom da planilha.          |
	//+----------------------------------------------+
	If ::aZoom[nFldIdx] <> 100
		Eval(bGravaLinha, '   <Zoom>'+AllTrim(Str(::aZoom[nFldIdx]))+'</Zoom>'+CRLF)
	EndIf
	
	Eval(bGravaLinha, '   <Selected/>'+CRLF)
	//+----------------------------------------------+
	//| Tratamento para exibi¡Ño das linhas de grade |
	//+----------------------------------------------+
	If !::aShowGridLine[nFldIdx]
		Eval(bGravaLinha, '   <DoNotDisplayGridlines/>'+CRLF)
	EndIf
	//+----------------------------------------------+
	//| Tratamento para o congelamento da linha      |
	//+----------------------------------------------+
	If ::aFreezeRow[nFldIdx] <> 0
		Eval(bGravaLinha, '   <FreezePanes/>'+CRLF)
		Eval(bGravaLinha, '   <FrozenNoSplit/>'+CRLF)
		Eval(bGravaLinha, '   <SplitHorizontal>'+AllTrim(Str(::aFreezeRow[nFldIdx]))+'</SplitHorizontal>'+CRLF)
		Eval(bGravaLinha, '   <TopRowBottomPane>'+AllTrim(Str(::aFreezeRow[nFldIdx]))+'</TopRowBottomPane>'+CRLF)
		Eval(bGravaLinha, '   <ActivePane>2</ActivePane>'+CRLF)
	EndIf
	Eval(bGravaLinha, '   <ProtectObjects>False</ProtectObjects>'+CRLF)
	Eval(bGravaLinha, '   <ProtectScenarios>False</ProtectScenarios>'+CRLF)
	Eval(bGravaLinha, '  </WorksheetOptions>'+CRLF)
	//+----------------------------------------------+
	//| Tratamento para a quebra de impressÑo        |
	//+----------------------------------------------+
	If Len(::aRowBreak[nFldIdx]) > 0 .Or. Len(::aColBreak[nFldIdx]) > 0
		Eval(bGravaLinha, '    <PageBreaks xmlns="urn:schemas-microsoft-com:office:excel">'+CRLF)
		If Len(::aColBreak[nFldIdx]) > 0
			Eval(bGravaLinha, '     <ColBreaks>'+CRLF)
			For nI := 1 To Len(::aColBreak[nFldIdx])
				Eval(bGravaLinha, '      <ColBreak>'+CRLF)
				Eval(bGravaLinha, '       <Column>'+AllTrim(Str(::aColBreak[nFldIdx, nI]))+'</Column>'+CRLF)
				Eval(bGravaLinha, '      </ColBreak>'+CRLF)
			Next nI
			Eval(bGravaLinha, '     </ColBreaks>'+CRLF)
		EndIf
		If Len(::aRowBreak[nFldIdx]) > 0
			Eval(bGravaLinha, '     <RowBreaks>'+CRLF)
			For nI := 1 To Len(::aRowBreak[nFldIdx])
				Eval(bGravaLinha, '      <RowBreak>'+CRLF)
				Eval(bGravaLinha, '       <Row>'+AllTrim(Str(::aRowBreak[nFldIdx, nI]))+'</Row>'+CRLF)
				Eval(bGravaLinha, '      </RowBreak>'+CRLF)
			Next nI
			Eval(bGravaLinha, '     </RowBreaks>'+CRLF)
		EndIf	
		Eval(bGravaLinha, '    </PageBreaks>'+CRLF)
	EndIf
	
	If Len(::aFilter[nFldIdx]) > 0
		Eval(bGravaLinha, '    <AutoFilter x:Range="R' + AllTrim(Str(::aFilter[nFldIdx, 1])) + 'C' + AllTrim(Str(::aFilter[nFldIdx, 2])) + ':R' + AllTrim(Str(::aFilter[nFldIdx, 3])) + 'C' + AllTrim(Str(::aFilter[nFldIdx, 4])) + '" xmlns="urn:schemas-microsoft-com:office:excel">'+CRLF)
  		Eval(bGravaLinha, '    </AutoFilter>'+CRLF)
	EndIf
	 
	Eval(bGravaLinha, ' </Worksheet>'+CRLF)
	
Next nFldIdx

Eval(bGravaLinha, '</Workbook>')

//+-------------------------------------------------------+
//| Fecha o arquivo onde ser∑ salvo o XML caso seja usado |
//+-------------------------------------------------------+
If lGravaDisco
	cDirDestino := SubStr(cArquivo, 1, RAt("\", cArquivo))
	If FClose(nHandle)
		FT_FUSE()
		cRet := cArquivo // Retorna o nome do arquivo caso tudo esteja ok.
	EndIf
	CpyS2T(cArqTemp, cDirDestino, .T.) // Copia do Servidor para a esta¡Ño
	FErase(cArqTemp)                                               // Apaga o arquivo tempor∑rio do server
	DirRemove(SubStr(cArqTemp, 1, RAt("\", cArqTemp)))             // Apaga o diret€rio tempor∑rio
	//+-----------------------------------------------------------------+
	//| Tratamento efetuado para apagar o arquivo tempor∑rio (ap*.tmp)  |
	//| que era deixado na pasta do client. Isto estava gerando erros   |
	//| durante a gera¡Ño de alguns arquivos excel.                     |
	//+-----------------------------------------------------------------+
	aArqTemp := Directory(cDirDestino+"ap*.tmp")
	aEval(aArqTemp, {|x| FErase(cDirDestino+x[1])})	
EndIf

Return cRet

METHOD GetCSV(cArquivo) CLASS ExcelXML
Local cRet         := ""
Local nA, nB
Local nPosID       := 0
Local cID          := ""
Local aIDs         := {}
Local cStyle       := ""
Local bGravaLinha  := {|cLinha| Iif(lGravaDisco, FWrite(nHandle, cLinha), cRet += cLinha)}
Local nHandle      := 0
Local cArqTemp     := "\EXCELXML"
Local lGravaDisco  := .F.

Default cArquivo   := ""
lGravaDisco        := !Empty(cArquivo)

//+------------------------------------------------------+
//| Abre o arquivo onde ser∑ salvo o XML caso seja usado |
//+------------------------------------------------------+
If lGravaDisco
	makeDir(cArqTemp)
	cArqTemp +="\"+DtoS(Date())+StrTran(Time(),":","")+__cUserID
	makeDir(cArqTemp)
	cArqtemp += SubStr(cArquivo, Rat("\", cArquivo))
	nHandle := FCreate(cArqTemp, 1) // 1 = FC_NORMAL (leitura + grava¡Ño)
EndIf


//+-------------------------------+
//| Insere as c»lulas na planilha |
//+-------------------------------+
If Len(::aCells[1]) > 0
	For nA := 1 To Len(::aCells[1])	
		
		For nB := 1 To Len(::aCells[1, nA])		    
		    
		    If nB <> 1
		    	Eval(bGravaLinha, ";")
		    EndIf
		    
			// Define o tipo de dado da c»lula e concatena a string de retorno
			If ValType(::aCells[1, nA, nB, 1]) == "C"
				If SubStr(::aCells[1, nA, nB, 1],1,1) <> "="
					Eval(bGravaLinha, ::aCells[1, nA, nB, 1])
				EndIf
			ElseIf ValType(::aCells[1, nA, nB, 1]) == "N"
				Eval(bGravaLinha, AllTrim(Str(::aCells[1, nA, nB, 1])))
			ElseIf ValType(::aCells[1, nA, nB, 1]) == "D"
				Eval(bGravaLinha, DtoS(::aCells[1, nA, nB, 1]))
			EndIf
		  
		Next nB
		Eval(bGravaLinha, CRLF)
	Next nA
EndIf

//+-------------------------------------------------------+
//| Fecha o arquivo onde ser∑ salvo o XML caso seja usado |
//+-------------------------------------------------------+
If lGravaDisco
	If FClose(nHandle)
		FT_FUSE()
		cRet := cArquivo // Retorna o nome do arquivo caso tudo esteja ok.
	EndIf
	CpyS2T(cArqTemp, SubStr(cArquivo, 1, RAt("\", cArquivo)), .T.) // Copia do Servidor para a esta¡Ño
	FErase(cArqTemp)                                               // Apaga o arquivo tempor∑rio
	DirRemove(SubStr(cArqTemp, 1, RAt("\", cArqTemp)))             // Apaga o diret€rio tempor∑rio
EndIf

Return cRet                    

Static Function AddObjArray(aArray, nLin, nCol, xConteudo)

Local nPagina := Int(nLin/(TAMANHO_LIMITE+0.1))+1
Local nLinPag := Iif(Int(nLin % TAMANHO_LIMITE)==0,TAMANHO_LIMITE,Int(nLin % TAMANHO_LIMITE))

// Adiciona nova pagina de array caso necess∑rio
If nPagina > Len(aArray)
	aAdd(aArray, {})
EndIf

// Redimensiona o tamanho da linha caso necess∑rio
If nLinPag > Len(aArray[nPagina])
	aSize(aArray[nPagina], nLinPag)
	aTail(aArray[nPagina]) := {}
EndIf

// Redimensiona o tamanho da coluna caso necess∑rio
If nCol > Len(aArray[nPagina,nLinPag])
	aSize(aArray[nPagina,nLinPag], nCol)
EndIf

aArray[nPagina, nLinPag, nCol] := xConteudo

Return .T.


Static Function GetObjArray(aArray, nLin, nCol)

Local nPagina := Int(nLin/(TAMANHO_LIMITE+0.1))+1
Local xDado   := Nil

If Len(aArray) >= nPagina .And. Len(aArray[nPagina]) >= nLin .And. ValType(aArray[nPagina, nLin]) == "A" .And.;
   Len(aArray[nPagina, nLin]) >= nCol .And. ValType(aArray[nPagina, nLin, nCol]) == "O"
	xDado   := aArray[nPagina, nLin, nCol] 
EndIf
				       
Return xDado

CLASS MergeCellInfo
	DATA   lSkip
	DATA   nMergeAcross
	DATA   nMergeDown
	DATA   nIndex
	
	METHOD New() CONSTRUCTOR
ENDCLASS

METHOD New() CLASS MergeCellInfo

::lSkip         := .F.
::nMergeAcross  := 0
::nMergeDown    := 0
::nIndex        := 0

Return Nil