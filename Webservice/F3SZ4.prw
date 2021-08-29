#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
//#INCLUDE 'FIVEWIN.CH'
#INCLUDE 'DBTREE.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F3SZ4     ºAutor  ³Helio Ferreira      º Data ³  23/04/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*
DBADDTREE oTree PROMPT "Menu 001"          RESOURCE "BMPTABLE" CARGO "#0001"
DBADDITEM oTree PROMPT "Item 001"          RESOURCE "BMPSXG"   CARGO "#0002"
DBENDTREE oTree
DBADDITEM oTree PROMPT "Item 002"          RESOURCE "BMPTRG"   CARGO "#0003"
DBADDITEM oTree PROMPT "Item 003"          RESOURCE "BMPCONS"  CARGO "#0004"
DBADDITEM oTree PROMPT "Item 004"          RESOURCE "BMPPARAM" CARGO "#0005"

//DBADDTREE oTree PROMPT "Menu 002" OPENED RESOURCE "BMPTABLE" CARGO "#0006"
DBADDTREE oTree PROMPT "Menu 002"          RESOURCE "BMPTABLE" CARGO "#0006"
DBADDITEM oTree PROMPT "Item 005"          RESOURCE "BMPSXG"   CARGO "#0007"
                                           
//DBADDTREE oTree PROMPT "Menu 003" OPENED RESOURCE "BMPTABLE" CARGO "#0008"
DBADDTREE oTree PROMPT "Menu 003"          RESOURCE "BMPTABLE" CARGO "#0008"
DBADDITEM oTree PROMPT "Item 006"          RESOURCE "BMPSXG"   CARGO "#0009"

DBENDTREE oTree

DBADDTREE oTree PROMPT "Menu 004" OPENED   RESOURCE "BMPTABLE" CARGO "#0010"
DBADDITEM oTree PROMPT "Item 007"          RESOURCE "BMPSXG"   CARGO "#0011"

DBENDTREE oTree

DBADDITEM oTree PROMPT "Item 008"          RESOURCE "BMPSXG"   CARGO "#0012"
DBENDTREE oTree

DBENDTREE oTree

DBADDITEM oTree PROMPT "Item 009"         RESOURCE "BMPSXB"   CARGO "#0013"
*/


User Function F3SZ4(cCliente,lFiltra)

Local aAreaGER  := GetArea()
//Local aAreaSZ2  := SZ2->( GetArea() )

Default lFiltra := .T.

If Type("cCliPre") <> 'U'
	Default cCliente := cCliPre
Else
	Default cCliente := M->Z1_CLIENTE
EndIf

Private aVetor     := {}
Private oTree
Private _Retorno   := ""
Private lMostraCon := .T.

dbSelectArea("SZ4")

If lMostraCon
   cQuery := "SELECT * FROM SZ4010 WHERE Z4_CLIENTE = '"+cCliente+"' AND Z4_NIVEL = '1' AND D_E_L_E_T_ = '' ORDER BY Z4_DTAUTOR "
Else
   cQuery := "SELECT * FROM SZ4010 WHERE Z4_CLIENTE = '"+cCliente+"' AND Z4_NIVEL = '1' AND Z4_DTFIM = '' AND D_E_L_E_T_ = '' ORDER BY Z4_DTAUTOR "
EndIf

If Select("QUERYSZ4_1") <> 0
	QUERYSZ4_1->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QUERYSZ4_1"

While !QUERYSZ4_1->( EOF() )
	AADD(aVetor,{Val(QUERYSZ4_1->Z4_NIVEL),QUERYSZ4_1->R_E_C_N_O_})
	
	If lMostraCon
	   cQuery := "SELECT * FROM SZ4010 WHERE Z4_NIVEL = '2' AND Z4_SUPERIO = '"+QUERYSZ4_1->Z4_CODIGO+"' AND D_E_L_E_T_ = '' ORDER BY Z4_LINHA "
	Else
	   cQuery := "SELECT * FROM SZ4010 WHERE Z4_NIVEL = '2' AND Z4_SUPERIO = '"+QUERYSZ4_1->Z4_CODIGO+"' AND Z4_DTFIM = '' AND D_E_L_E_T_ = '' ORDER BY Z4_LINHA "
	EndIf
	
	If Select("QUERYSZ4_2") <> 0
		QUERYSZ4_2->( dbCloseArea() )
	EndIf
	
	TCQUERY cQuery NEW ALIAS "QUERYSZ4_2"
	
	While !QUERYSZ4_2->( EOF() )
		AADD(aVetor,{Val(QUERYSZ4_2->Z4_NIVEL),QUERYSZ4_2->R_E_C_N_O_})
		
		If lMostraCon
		   cQuery := "SELECT * FROM SZ4010 WHERE Z4_NIVEL = '3' AND Z4_SUPERIO = '"+QUERYSZ4_2->Z4_CODIGO+"' AND D_E_L_E_T_ = '' ORDER BY Z4_LINHA "
		Else
		   cQuery := "SELECT * FROM SZ4010 WHERE Z4_NIVEL = '3' AND Z4_SUPERIO = '"+QUERYSZ4_2->Z4_CODIGO+"' AND Z4_DTFIM = '' AND D_E_L_E_T_ = '' ORDER BY Z4_LINHA "
		EndIf
		
		If Select("QUERYSZ4_3") <> 0
			QUERYSZ4_3->( dbCloseArea() )
		EndIf
		
		TCQUERY cQuery NEW ALIAS "QUERYSZ4_3"
		
		While !QUERYSZ4_3->( EOF() )
			AADD(aVetor,{Val(QUERYSZ4_3->Z4_NIVEL),QUERYSZ4_3->R_E_C_N_O_})
			
			QUERYSZ4_3->( dbSkip() )
		End
		
		QUERYSZ4_2->( dbSkip() )
	End
	
	QUERYSZ4_1->( dbSkip() )
End

// Selecionando os projetos com algum problema cadastral
If lMostraCon
   cQuery := "SELECT * FROM SZ4010 WHERE (Z4_NIVEL = '' OR (Z4_SUPERIO = '' AND  Z4_NIVEL <> '1') ) AND Z4_CLIENTE = '"+cCliente+"' AND D_E_L_E_T_ = '' ORDER BY Z4_DTAUTOR "
Else
   cQuery := "SELECT * FROM SZ4010 WHERE (Z4_NIVEL = '' OR (Z4_SUPERIO = '' AND  Z4_NIVEL <> '1') ) AND Z4_CLIENTE = '"+cCliente+"' AND Z4_DTFIM = '' AND D_E_L_E_T_ = '' ORDER BY Z4_DTAUTOR "
EndIf

If Select("QUERYSZ4_4") <> 0
	QUERYSZ4_4->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QUERYSZ4_4"

While !QUERYSZ4_4->( EOF() )
	AADD(aVetor,{0,QUERYSZ4_4->R_E_C_N_O_})
	QUERYSZ4_4->( dbSkip() )
End


 
DEFINE DIALOG oDlg TITLE "Consulta Projetos OPUS" FROM 10,10 TO 500,900 COLOR CLR_BLACK,CLR_WHITE PIXEL

//DEFINE DBTREE oTree FROM 00,00 TO oDlg:nHeight,oDlg:nWidth OF oDlg
DEFINE DBTREE oTree FROM 00,00 TO 220,440 OF oDlg
oTree:oFont := TFont():New('Courier',,14,,.T.,,,,.T.,.F.)
//oTree:BLDBLCLICK := {|| Detalhes() }


nSintetic := 0
nNivel    := 0

For _nX := 1 to Len(aVetor)
	SZ4->( dbGoTo(aVetor[_nX,2]) )
	
	If aVetor[_nX,1] == 1
		nNivTipo1 := 1
		nNivTipo2 := 0
		nNivTipo3 := 0
		cCodNiv1  := SZ4->Z4_CODIGO
		If _nX <> 1
			For nSintetic := nSintetic to 1 Step (-1)
				DBENDTREE oTree
			Next
		EndIf
		
		//If Alltrim(SZ4->Z4_LINHA) <> Alltrim(Str(nNivTipo1)) .and. (SZ4->Z4_CLIENTE <> '000031' .or. Empty(SZ4->Z4_LINHA))
		//	Reclock("SZ4",.F.)
		//	SZ4->Z4_LINHA := Alltrim(Str(nNivTipo1))
		//	SZ4->( MsUnlock() )
		//EndIf
		If Alltrim(cCodNiv1) <> Alltrim(SZ4->Z4_SUPN1)
			Reclock("SZ4",.F.)
			SZ4->Z4_SUPN1 := cCodNiv1
			SZ4->( msUnlock() )
		EndIf
		// Nivel 1
		DBADDTREE oTree PROMPT Subs(SZ4->Z4_LINHA,1,11)+" : " + Subs(SZ4->Z4_DESC,1,83) + RetHrPrj1()  RESOURCE "PROJETPMS" CARGO "#"+StrZero(_nX,4)
		nSintetic++
		nNivel   := aVetor[_nX,1]
	Else
		For nNivel := nNivel to (aVetor[_nX,1] + 1) Step (-1)
			DBENDTREE oTree
			nSintetic--
		Next
		
		If aVetor[_nX,1] == 2
			nNivTipo2++
			nNivTipo3:= 0
			//If Alltrim(SZ4->Z4_LINHA) <> Alltrim(Str(nNivTipo1))+'.'+Alltrim(StrZero(nNivTipo2,2)) .and. (SZ4->Z4_CLIENTE <> '000031' .or. Empty(SZ4->Z4_LINHA))
			//	Reclock("SZ4",.F.)
			//	SZ4->Z4_LINHA := Alltrim(Str(nNivTipo1))+'.'+Alltrim(StrZero(nNivTipo2,2))
			//	SZ4->( MsUnlock() )
			//EndIf
			If Alltrim(cCodNiv1) <> Alltrim(SZ4->Z4_SUPN1)
				Reclock("SZ4",.F.)
				SZ4->Z4_SUPN1 := cCodNiv1
				SZ4->( msUnlock() )
			EndIf
			// Nivel 2
			DBADDTREE oTree PROMPT Subs(SZ4->Z4_LINHA,1,8)+" : " + Subs(SZ4->Z4_DESC,1,83) + RetHrPrj2() RESOURCE "SDURECALL" CARGO "#"+StrZero(_nX,4)
			nSintetic++
			nNivel   := aVetor[_nX,1]
		Else
			If aVetor[_nX,1] == 3
				nNivTipo3++
				//If Alltrim(SZ4->Z4_LINHA) <> Alltrim(Str(nNivTipo1))+'.'+Alltrim(StrZero(nNivTipo2,2))+'.'+Alltrim(StrZero(nNivTipo3,2)) .and. (SZ4->Z4_CLIENTE <> '000031' .or. Empty(SZ4->Z4_LINHA))
				//	Reclock("SZ4",.F.)                                                                                                 
				//	SZ4->Z4_LINHA := Alltrim(Str(nNivTipo1))+'.'+Alltrim(StrZero(nNivTipo2,2))+'.'+Alltrim(StrZero(nNivTipo3,2))
				//	SZ4->( MsUnlock() )
				//EndIf
				If Alltrim(cCodNiv1) <> Alltrim(SZ4->Z4_SUPN1)
					Reclock("SZ4",.F.)
					SZ4->Z4_SUPN1 := cCodNiv1
					SZ4->( msUnlock() )
				EndIf
				// Nivel 3
				If Empty(SZ4->Z4_DTFIM)
				   DBADDITEM oTree PROMPT Subs(SZ4->Z4_LINHA,1,7)+" : "+Subs(SZ4->Z4_DESC,1,83) + RetHrPrj3()  RESOURCE "PMSTASK4"   CARGO "#"+StrZero(_nX,4)
				Else
				   DBADDITEM oTree PROMPT Subs(SZ4->Z4_LINHA,1,7)+" : "+Subs(SZ4->Z4_DESC,1,83) + RetHrPrj3()  RESOURCE "PMSTASK1"   CARGO "#"+StrZero(_nX,4)
				EndIf
				nNivel   := aVetor[_nX,1]
			EndIf
		EndIf
	EndIf
	
	
	If aVetor[_nX,1] == 0
		
		For nNivel := nNivel to (aVetor[_nX,1] + 1) Step (-1)
			DBENDTREE oTree
			nSintetic--
		Next
		
		DBADDITEM oTree PROMPT "Tipo: " + SZ4->Z4_NIVEL + " - Superior: " + SZ4->Z4_SUPERIO+"  "+" - " + Subs(SZ4->Z4_DESC,1,70) + RetHrPrj3()  RESOURCE "AMARELO"   CARGO "#"+StrZero(_nX,4)
		
	EndIf
Next _nX

//U_VERSAOZ4()

DBENDTREE oTree

@ 225,230 BUTTON oBtn PROMPT "Selecionar" Size 45,14 OF oDlg PIXEL ACTION fOK()
@ 225,290 BUTTON oBtn PROMPT "Criar Item" Size 45,14 OF oDlg PIXEL ACTION fCriaItm()
@ 225,350 BUTTON oBtn PROMPT "Cancelar"   Size 45,14 OF oDlg PIXEL ACTION oDlg:End()

ACTIVATE DIALOG oDlg CENTER

RestArea(aAreaGER)

Return _Retorno


Static Function fOK()

dbSelectArea(oTree:cArqTree)
nRecno := Recno()

If nRecno <> 0
	SZ4->( dbGoTo(aVetor[nRecno,2]))
	If SZ4->Z4_NIVEL == '2'
		_Retorno := SZ4->Z4_CODIGO
		
		cCodigo := SZ4->Z4_CODIGO
		cDesc   := SZ4->Z4_DESC
		nHrPrev := SZ4->Z4_PREVISA
		
		oDlg:End()
	Else
	   MsgYesNo("Para seleção, o projeto dever ser do nível 2.")
	EndIf
EndIf

Return



Static Function fCriaItm()

dbSelectArea(oTree:cArqTree)
nRecno := Recno()

If nRecno <> 0
	SZ4->( dbGoTo(aVetor[nRecno,2]))
	If SZ4->Z4_NIVEL == '2'
		_Retorno := SZ4->Z4_CODIGO
		
		cCodigo := SZ4->Z4_CODIGO
		cDesc   := SZ4->Z4_DESC
		nHrPrev := SZ4->Z4_PREVISA
		
		oDlg:End()
	Else
	   MsgYesNo("Selecione um projeto de nível 2 para a ciração de um novo item.")
	EndIf
EndIf

Return

/*
dbSelectArea(oTree:cArqTree)
aAreaTRE := GetArea()
cPai     := T_IDTREE


dbSelectArea(oTree:cArqTree)
RecLock((oTree:cArqTree), .F.)
Replace T_CARGO With (SG1->G1_COD+SG1->G1_TRT+SG1->G1_COMP+StrZero(SG1->(Recno()),9)+StrZero(nIndex ++, 9)+'COMP')
MsUnlock()
*/

User Function Teste2()

Return (M->Z2_PROJETO)


Static Function RetHrPrj1()
Local _Retorno

nHrsPrj := 0

cQuery := "SELECT * FROM SZ4010 WHERE Z4_SUPN1 = '"+SZ4->Z4_CODIGO+"' AND Z4_NIVEL = '3' AND D_E_L_E_T_ = '' "

If Select("QUERYSZ4_6") <> 0
	QUERYSZ4_6->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QUERYSZ4_6"

/*
While !QUERYSZ4_6->( EOF() )
	SZ2->( dbSetOrder(2) )  // Z2_FILIAL + Z2_PROJETO
	If SZ2->( dbSeek( xFilial() + QUERYSZ4_6->Z4_CODIGO ) )
		While !SZ2->( EOF() ) .and. SZ2->Z2_PROJETO == QUERYSZ4_6->Z4_CODIGO
			nHrsPrj += HrCtoMin(SZ2->Z2_TEMPO)
			SZ2->( dbSkip() )
		End
	EndIf
	QUERYSZ4_6->( dbSkip() )
End
*/

_Retorno := Transform(SZ4->Z4_PREVISA,'@E 9,999.9')+' '

_Retorno += MinToHrC(nHrsPrj)

Return _Retorno


Static Function RetHrPrj2()
Local _Retorno

nHrsPrj := 0

cQuery := "SELECT * FROM SZ4010 WHERE Z4_SUPERIO = '"+SZ4->Z4_CODIGO+"' AND D_E_L_E_T_ = '' "

If Select("QUERYSZ4_5") <> 0
	QUERYSZ4_5->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QUERYSZ4_5"

/*
While !QUERYSZ4_5->( EOF() )
	SZ2->( dbSetOrder(2) )  // Z2_FILIAL + Z2_PROJETO
	If SZ2->( dbSeek( xFilial() + QUERYSZ4_5->Z4_CODIGO ) )
		While !SZ2->( EOF() ) .and. SZ2->Z2_PROJETO == QUERYSZ4_5->Z4_CODIGO
			nHrsPrj += HrCtoMin(SZ2->Z2_TEMPO)
			SZ2->( dbSkip() )
		End
	EndIf
	QUERYSZ4_5->( dbSkip() )
End
*/

_Retorno := Transform(SZ4->Z4_PREVISA,'@E 9,999.9')+' '

_Retorno += MinToHrC(nHrsPrj)

Return _Retorno


Static Function RetHrPrj3()
Local _Retorno

nHrsPrj := 0
/*
SZ2->( dbSetOrder(2) )  // Z2_FILIAL + Z2_PROJETO
If SZ2->( dbSeek( xFilial() + SZ4->Z4_CODIGO ) )
	While !SZ2->( EOF() ) .and. SZ2->Z2_PROJETO == SZ4->Z4_CODIGO
		nHrsPrj += HrCtoMin(SZ2->Z2_TEMPO)
		SZ2->( dbSkip() )
	End
EndIf
*/

_Retorno := Transform(SZ4->Z4_PREVISA,'@E 9,999.9')+' '

_Retorno += MinToHrC(nHrsPrj)

Return _Retorno


Static Function HrCtoMin(cTemp)
Local _Retorno

_Retorno := Val(Subs(cTemp,1,2)) * 60
_Retorno += Val(Subs(cTemp,3,2))

Return _Retorno


Static Function MinToHrC(nTemp)
Local _Retorno

//_Retorno := StrZero(Int(nTemp/60),4)
//_Retorno += 
(nTemp - (Int(nTemp/60)*60),2)

_Retorno := Round(nTemp/60,2)

_Retorno := Transform(_Retorno,'@E 9,999.99')

Return _Retorno


Static Function  Detalhes()
Local oCodigo
Local cCodigo := ''
Local cDesc   := ''
Local cTipo   := ''
Local nLin
Local nCol
Local nOpc    := 0

dbSelectArea(oTree:cArqTree)
nRecno := Recno()

If nRecno <> 0
	
	SZ4->( dbGoTo(aVetor[nRecno,2]))
	cCodigo := SZ4->Z4_CODIGO
	cDesc   := SZ4->Z4_DESC
	nHrPrev := SZ4->Z4_PREVISA
	cTipo   := SZ4->Z4_NIVEL
	
	DEFINE DIALOG oDlg2 TITLE "Detalhes do Projeto" FROM 0,0 TO 260,500 COLOR CLR_BLACK,CLR_WHITE PIXEL
	
	nLin := 10
	nCol := 08
	@ nLin, nCol	SAY oTexto1   VAR OemToAnsi('Codigo:')  PIXEL SIZE 180,15
	oTexto1:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
	@ nLin+10, nCol MSGET oCodigo VAR cCodigo  Picture "@!"  When .F. SIZE 75,12 Valid .T. PIXEL
	oCodigo:oFont := TFont():New('Courier New',,15,,.T.,,,,.T.,.F.)
	
	
	@ nLin, nCol+80	SAY oTexto2   VAR OemToAnsi('Tipo (Nível):')  PIXEL SIZE 180,15
	oTexto2:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
	@ nLin+10, nCol+80 MSGET oTipo VAR cTipo  Picture "@!"  When .F. SIZE 60,12 Valid .T. PIXEL
	oTipo:oFont := TFont():New('Courier New',,15,,.T.,,,,.T.,.F.)
	
	nLin += 30
	@ nLin, nCol	SAY oTexto3   VAR OemToAnsi('Horas Previstas:')  PIXEL SIZE 180,15
	oTexto3:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
	@ nLin+10, nCol MSGET oHrPrev VAR nHrPrev  Picture "@E 9,999.9"  SIZE 60,12 Valid .T. PIXEL
	oHrPrev:oFont := TFont():New('Courier New',,15,,.T.,,,,.T.,.F.)
	
	nLin += 30
	@ nLin, nCol	SAY oTexto4   VAR OemToAnsi('Descrição:')  PIXEL SIZE 180,15
	oTexto4:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
	@ nLin+10, nCol MSGET oDesc VAR cDesc  Picture "@!"  SIZE 175,12 Valid .T. PIXEL
	oCodigo:oFont := TFont():New('Courier New',,15,,.T.,,,,.T.,.F.)
	
	nLin+= 40
	@ nLin,50 BUTTON oBtn PROMPT "Salvar"       Size 45,14 OF oDlg2 PIXEL ACTION {||nOpc:=1,oDlg2:End()}
	@ nLin,110 BUTTON oBtn PROMPT "Cancelar"     Size 45,14 OF oDlg2 PIXEL ACTION oDlg2:End()
	
	ACTIVATE DIALOG oDlg2 CENTER
	
	If nOpc == 1
		Reclock("SZ4",.F.)
		SZ4->Z4_DESC    := cDesc
		SZ4->Z4_PREVISA := nHrPrev
		SZ4->( msUnlock() )
	EndIf
	
EndIf

Return
