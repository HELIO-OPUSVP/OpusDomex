#include "tbiconn.ch"
#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO4     บAutor  ณMicrosiga           บ Data ณ  12/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STATINV()
Private nLargBut      := 95
Private nAltuBut      := 13
Private nPerPrimeira  := 0
Private nPerSegunda   := 0
Private nTotProd      := 0
Private nProdOK       := 0
Private cConclusao    := "(indeterminada)"
Private nPerTermino   := 0
Private aTempo        := {}
Private nPrimeira     := 0
Private nSegunda      := 0
Private cTime         := ""
Private oMainWnd
Private nAjuste       := 0
Private cAmoxarifados := "'01','02','11','13','17','20','21','97','99'"

/*
01 - MATERIA PRIMA
02 - MATERIA PRIMA IMPORTADA
03 - MATERIAL DE TERCEIROS
04 - ENGENHARIA
05 - FERRAMENTAS
06 - MAQUINAS DA ENGENHARIA
07 - MATERIAL DA MANUTENวรO
08 - MรO DE OBRA DA PRODUวรO
09 - FERRAMENTAS
10 - QUALIDADE
11 - MATERIAIS REJEITADOS
12 - MATERIAL DO MARKETING
13 - EXPEDIวรO
14 - MATERIAL DE ESCRITำRIO
15 - MATERIAL PARA CUSTEIO DAS OBRAS
16 - NETOP
17 - AUTOMOTIVO
20 - MATERIAL OBSOLETO
21 - MATERIAL DRAWBACK
97 - WIP
99 - STK 99
*/

RPCSetType(3)
aAbreTab := {}
RpcSetEnv("01","01",,,,,aAbreTab)

AADD(aTempo,{GetMV("MV_XXDTINV")  ,"08:00","18:00"})
AADD(aTempo,{GetMV("MV_XXDTINV")+1,"08:00","18:00"})
AADD(aTempo,{GetMV("MV_XXDTINV")+2,"08:00","18:00"})
AADD(aTempo,{GetMV("MV_XXDTINV")+3,"08:00","18:00"})
AADD(aTempo,{GetMV("MV_XXDTINV")+4,"08:00","18:00"})
AADD(aTempo,{GetMV("MV_XXDTINV")+5,"08:00","18:00"})
AADD(aTempo,{GetMV("MV_XXDTINV")+6,"08:00","18:00"})
//AADD(aTempo,{StoD("20141218"),"08:00","18:00"})
//AADD(aTempo,{StoD("20141219"),"08:00","18:00"})
//AADD(aTempo,{StoD("20141220"),"08:00","18:00"})
//AADD(aTempo,{StoD("20141221"),"08:00","18:00"})
//AADD(aTempo,{StoD("20141222"),"08:00","18:00"})
//AADD(aTempo,{StoD("20141223"),"08:00","18:00"})
//AADD(aTempo,{StoD("20141224"),"08:00","18:00"})
//AADD(aTempo,{StoD("20141225"),"08:00","18:00"})
//AADD(aTempo,{StoD("20141226"),"08:00","18:00"})
//AADD(aTempo,{StoD("20141227"),"08:00","18:00"})
//AADD(aTempo,{StoD("20141228"),"08:00","18:00"})
//AADD(aTempo,{StoD("20141229"),"08:00","18:00"})
//AADD(aTempo,{StoD("20141230"),"08:00","18:00"})
//AADD(aTempo,{StoD("20141231"),"08:00","18:00"})

//MsgRun("Processando resumo do inventแrio...","Aguarde...",{|| fAtualiza() })
//Processa( fAtualiza() )

Define MsDialog oInv Title "Posi็ใo de Inventแrio: " From 0,0 To 320,250 Pixel of oMainWnd PIXEL

nLin := 05
@ nLin, 010	SAY oTexto1 Var 'Inventแrio: ' + DtoC(GetMV("MV_XXDTINV"))    SIZE 100,10 PIXEL
oTexto1:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

nLin += 15
@ nLin, 010	SAY oTexto2 Var 'Posi็ใo em:'    SIZE 100,10 PIXEL
oTexto2:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)

@ nLin, 65  Say oTime Var cTime Size 130,50 COLOR CLR_HBLUE     PIXEL OF oMainWnd
oTime:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)

nLin += 15
@ nLin, 010	SAY oTexto2 Var 'Primeira Contagem:'    SIZE 100,10 PIXEL
oTexto2:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)

@ nLin, 85  Say oPerce2 Var Transform(nPerPrimeira,"@E 999.9999")+'%' Size 130,50 COLOR CLR_HBLUE     PIXEL OF oMainWnd
oPerce2:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)

nLin += 15
@ nLin, 010	SAY oTexto3 Var 'Segunda Contagem:'    SIZE 100,10 PIXEL
oTexto3:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)

@ nLin, 85  Say oPerce3 Var Transform(nPerSegunda,"@E 999.9999")+'%' Size 130,50 COLOR CLR_HBLUE     PIXEL OF oMainWnd
oPerce3:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)

nLin += 15
@ nLin, 010	SAY oTexto4 Var 'Total de Produtos:'    SIZE 100,10 PIXEL
oTexto4:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)

@ nLin, 90  Say oPerce4 Var Transform(nTotProd,"@E 999,999") Size 130,50 COLOR CLR_HBLUE     PIXEL OF oMainWnd
oPerce4:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)

nLin += 15
@ nLin, 010	SAY oTexto5 Var 'Produtos concluํdos:'    SIZE 100,10 PIXEL
oTexto5:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)

@ nLin, 90  Say oPerce5 Var Transform(nProdOK,"@E 999,9999") Size 130,50 COLOR CLR_HBLUE     PIXEL OF oMainWnd
oPerce5:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)

nLin += 15
@ nLin, 010	SAY oTexto5 Var 'Vlr. previsใo ajuste:'    SIZE 100,10 PIXEL
oTexto5:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)

@ nLin, 80  Say oAjuste Var "R$ " + Transform(nAjuste,"@E 999,999,999.99") Size 130,50 COLOR CLR_HBLUE     PIXEL OF oMainWnd
oAjuste:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)

nLin += 15
@ nLin, 010	SAY oTexto6 Var 'Prev. Conclusใo:'    SIZE 100,10 PIXEL
oTexto6:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)

@ nLin, 65 Say oConclusao Var cConclusao Size 130,50 COLOR CLR_HBLUE     PIXEL OF oMainWnd
oConclusao:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)

nLin += 15
@ nLin, 010	SAY oTexto7 Var 'Conclusใo Inventแrio:'    SIZE 100,10 PIXEL
oTexto7:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)

@ nLin, 85  Say oPerce7 Var Transform(nPerTermino,"@E 999.9999")+'%' Size 130,50 COLOR CLR_RED     PIXEL OF oMainWnd
oPerce7:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)

nLin += 15
@ nLin, 10 BUTTON "Atualizar" ACTION MsgRun("Atualizando...","Aguarde.....",{|| fAtualiza() }) SIZE nLargBut,nAltuBut PIXEL OF oInv
//@ nLin, 10 BUTTON "Atualizar" ACTION Processa({|| fAtualiza() },"Calculando dados para exibi็ใo...") SIZE nLargBut,nAltuBut PIXEL OF oInv

Activate MsDialog oInv

Return


Static Function fAtualiza()
nAjuste := 0
nProdOK := 0

cTime := DtoC(Date()) + " : " + Subs(Time(),1,5)

// Total de produtos
cQuery := "SELECT COUNT(*) AS CONTAGEM FROM ( SELECT B2_COD,B2_LOCAL FROM SB2010 WHERE B2_QATU <> 0 AND B2_LOCAL IN ("+cAmoxarifados+") AND D_E_L_E_T_ = '' GROUP BY B2_COD,B2_LOCAL ) TMP"
If Select("TEMP") <> 0
	TEMP->( dbCloseArea() )
EndIf
TCQUERY cQuery NEW ALIAS "TEMP"
nTotProd := TEMP->CONTAGEM // - 603

// Percentual da primeira contagem
//cQuery := "SELECT COUNT(*) AS CONTAGEM FROM ( SELECT ZC_PRODUTO,ZC_LOCAL FROM SZC010 WHERE ZC_DATAINV = '"+DtoS(GetMV("MV_XXDTINV"))+"' AND D_E_L_E_T_ = '' AND ZC_CONTAGE = '001' GROUP BY ZC_PRODUTO,ZC_LOCAL ) TMP"
//If Select("TEMP") <> 0
//	TEMP->( dbCloseArea() )
//EndIf

//TCQUERY cQuery NEW ALIAS "TEMP"
//nPrimeira    := TEMP->CONTAGEM

//nTotProd     := nPrimeira

//nPerPrimeira := (nPrimeira / nTotProd) * 100

nPerPrimeira := 100

// Percentual da segunda contagem
cQuery := "SELECT COUNT(*) AS CONTAGEM FROM ( SELECT ZC_PRODUTO,ZC_LOCAL FROM SZC010 WHERE ZC_DATAINV = '"+DtoS(GetMV("MV_XXDTINV"))+"' AND D_E_L_E_T_ = '' AND ZC_CONTAGE = '002' GROUP BY ZC_PRODUTO,ZC_LOCAL ) TMP"
If Select("TEMP") <> 0
	TEMP->( dbCloseArea() )
EndIf
TCQUERY cQuery NEW ALIAS "TEMP"
nSegunda    := TEMP->CONTAGEM
nPerSegunda := (nSegunda / nTotProd) * 100

// Percentual de conclusใo do inventแrio
cQuery := "SELECT COUNT(*) AS CONTAGEM FROM ( SELECT ZI_PRODUTO,ZI_LOCAL FROM SZI010 WHERE ZI_DATA = '"+DtoS(GetMV("MV_XXDTINV"))+"' AND ZI_STATPRO = 'V' AND D_E_L_E_T_ = ''  GROUP BY ZI_PRODUTO,ZI_LOCAL ) TMP"
If Select("TEMP") <> 0
	TEMP->( dbCloseArea() )
EndIf
TCQUERY cQuery NEW ALIAS "TEMP"
nProdOK := TEMP->CONTAGEM
nPerTermino := (nProdOK / nTotProd) * 100

// Calculando o valor do ajuste
//cQuery := "SELECT COUNT(*) AS CONTAGEM FROM SZI010 WHERE ZI_DATA = '"+DtoS(GetMV("MV_XXDTINV"))+"' AND D_E_L_E_T_ = '' AND ZI_STATLIN <> '*' AND ZI_STATPRO = 'V' GROUP BY ZI_PRODUTO, ZI_LOCAL "
//If Select("QUERYSZI") <> 0
//	QUERYSZI->( dbCloseArea() )
//EndIf
//TCQUERY cQuery NEW ALIAS "QUERYSZI"
//nRecnos := QUERYSZI->CONTAGEM
//ProcRegua(nRecnos)

cQuery := "SELECT ZI_PRODUTO, ZI_LOCAL FROM SZI010 WHERE ZI_DATA = '"+DtoS(GetMV("MV_XXDTINV"))+"' AND D_E_L_E_T_ = '' AND ZI_STATLIN <> '*' AND ZI_STATPRO = 'V' GROUP BY ZI_PRODUTO, ZI_LOCAL "
If Select("QUERYSZI") <> 0
	QUERYSZI->( dbCloseArea() )
EndIf
TCQUERY cQuery NEW ALIAS "QUERYSZI"

nRecnos := 0
While !QUERYSZI->( EOF() )
   nRecnos++
   QUERYSZI->( dbSkip() )
End
ProcRegua(nRecnos)

QUERYSZI->( dbGoTop() )

While !QUERYSZI->( EOF() )
	
	cQuery := "SELECT ZC_PRODUTO, ZC_LOCAL, MAX(ZC_CONTAGE) AS ZC_CONTAGE FROM " + RetSqlName("SZC") + " "
	cQuery += "WHERE ZC_DATAINV = '"+DtoS(GetMV("MV_XXDTINV"))+"' "
	cQuery += "AND ZC_PRODUTO = '"+QUERYSZI->ZI_PRODUTO+"' AND ZC_LOCAL = '"+QUERYSZI->ZI_LOCAL+"' AND  D_E_L_E_T_ = '' "
	cQuery += "GROUP BY ZC_PRODUTO, ZC_LOCAL "
	
	If Select("SZCPRODLOC") <> 0
		SZCPRODLOC->( dbCloseArea() )
	EndIf
	
	TCQUERY cQuery NEW ALIAS "SZCPRODLOC"
	
	While !SZCPRODLOC->( EOF() )
		cQuery := "SELECT ZC_PRODUTO, ZC_LOCAL, SUM(ZC_QUANT) AS ZC_QUANT FROM " + RetSqlName("SZC") + " "
		cQuery += "WHERE ZC_DATAINV = '"+DtoS(GetMV("MV_XXDTINV"))+"' "
		cQuery += "AND D_E_L_E_T_ = '' AND ZC_PRODUTO = '"+SZCPRODLOC->ZC_PRODUTO+"' AND ZC_LOCAL = '"+SZCPRODLOC->ZC_LOCAL+"' AND ZC_CONTAGE = '"+SZCPRODLOC->ZC_CONTAGE+"' "
		cQuery += "GROUP BY ZC_PRODUTO, ZC_LOCAL "
		
		If Select("QUERYSZC") <> 0
			QUERYSZC->( dbCloseArea() )
		EndIf
		
		TCQUERY cQuery NEW ALIAS "QUERYSZC"
		
		//While !QUERYSZC->( EOF() )
			If SB2->( dbSeek( xFilial() + QUERYSZC->ZC_PRODUTO + QUERYSZC->ZC_LOCAL ) )
				If QUERYSZC->ZC_QUANT <> SB2->B2_QATU
					If QUERYSZC->ZC_QUANT > SB2->B2_QATU
						nAjuste += Round((QUERYSZC->ZC_QUANT - SB2->B2_QATU) * (SB2->B2_VATU1/SB2->B2_QATU),2)
					Else
						nAjuste += Round(((SB2->B2_QATU - QUERYSZC->ZC_QUANT) * (SB2->B2_VATU1/SB2->B2_QATU)) * (-1),2)
					EndIf
				Else
					_nTemp := 1
				EndIf
			EndIf
		//	QUERYSZC->( dbSkip() )
		//End
		SZCPRODLOC->( dbSkip() )
	End
	QUERYSZI->( dbSkip() )
	IncProc()
End

// Calculando o tempo de coleta de cada produto
cQuery := "SELECT ZC_PRODUTO,ZC_DATA,ZC_CONTAGE, MIN(ZC_HORA) AS HMIN,MAX(ZC_HORA) AS HMAX FROM SZC010 "
cQuery += "WHERE ZC_DATAINV = '"+DtoS(GetMV("MV_XXDTINV"))+"' AND D_E_L_E_T_ = '' GROUP BY ZC_PRODUTO,ZC_DATA,ZC_CONTAGE "
cQuery += "ORDER BY ZC_DATA, ZC_PRODUTO, ZC_CONTAGE "
If Select("TEMP") <> 0
	TEMP->( dbCloseArea() )
EndIf
TCQUERY cQuery NEW ALIAS "TEMP"
nTotmim := 0
nProds  := 0
While !TEMP->( EOF() )
	If ConvHMin(TEMP->HMAX) == ConvHMin(TEMP->HMIN)
		nTotmim += 1
	Else
		nTotmim += ConvHMin(TEMP->HMAX) - ConvHMin(TEMP->HMIN)
	EndIf
	nProds++
	TEMP->( dbSkip() )
End

nMediaMin := Round(nTotmim / nProds,0)

nTotMin   := nMediaMin * (nTotProd - nPrimeira)  // Quantos produtos faltam para a primeira contagem
nTotMin   += nMediaMin * (nTotProd - nSegunda )  // Quantos produtos faltam para a primeira contagem


// Calculando o total de equipes
cQuery := "SELECT COUNT(*) AS CONTAGEM FROM ( SELECT ZC_USUARIO FROM SZC010 WHERE ZC_DATAINV = '"+DtoS(GetMV("MV_XXDTINV"))+"' AND D_E_L_E_T_ = '' GROUP BY ZC_USUARIO ) TMP"
If Select("TEMP") <> 0
	TEMP->( dbCloseArea() )
EndIf
TCQUERY cQuery NEW ALIAS "TEMP"

nTotUsu := TEMP->CONTAGEM

nTotGER := Round(nTotMin / nTotUsu,0)   // Dividindo o total de minutos necessแrio pelo totla de equipes

lFim := .F.
For x := 1 to Len(aTempo)
	If !lFim
		If aTempo[x,1] == dDataBase
			If ConvHMin(Time()) > ConvHMin(aTempo[x,2])
				nMinIni    := ConvHMin(Time())
				nMinMax    := ConvHMin(aTempo[x,3])
			Else
				nMinIni    := ConvHMin(aTempo[x,2])
				nMinMax    := ConvHMin(aTempo[x,3])
			EndIf
			
			For y := nMinIni to nMinMax
				nTotGER--
				If nTotGER == 0
					// Concluiu
					cConclusao := DtoC(aTempo[x,1]) + " : " + ConvMtoH(y)
					lFim := .T.
					Exit
				EndIf
			Next y
		Else
			If aTempo[x,1] > dDataBase
				nMinIni    := ConvHMin(aTempo[x,2])
				nMinMax    := ConvHMin(aTempo[x,3])
				
				For y := nMinIni to nMinMax
					nTotGER--
					If nTotGER == 0
						// Concluiu
						cConclusao := DtoC(aTempo[x,1]) + " : " + ConvMtoH(y)
						lFim := .T.
						Exit
					EndIf
				Next y
			EndIf
		EndIf
	EndIf
Next x

If Type("oMainWnd") <> 'U'
	oMainWnd:Refresh()
	oAjuste:Refresh()
EndIf

Return


Static Function ConvHMin(cArgumento)
Local _Retorno
Local cHora := Subs(cArgumento,1,2)
Local cMin  := Subs(cArgumento,4,2)
_Retorno := (Val(cHora) * 60) + Val(cMin)

Return _Retorno

Static Function ConvMtoH(nArgumento)
Local _Retorno
Local nHora := Int(nArgumento/60)
Local nMin  := nArgumento - (nHora*60)
_Retorno := StrZero(nHora,2)+":"+StrZero(nMin,2)

Return _Retorno
