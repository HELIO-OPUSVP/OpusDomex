#include "TbiConn.ch"
#include "TbiCode.ch"
#include "Rwmake.ch"
#include "Topconn.ch"
#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDOMACD26  บAutor  ณMichel Sander       บ Data ณ  01.10.16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Confer๊ncia de Carga 									 			  บฑฑ
ฑฑบ          ณ 														                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DOMACD26()

Private oTxtOP,__oGetNF,__oTxtNFS,oGetEtiq,oTxtProd,oGetProd,oTxtQtd,oGetQtd,oMark,oTxtQtdEmp,oMainEti,oEtiqueta,oTxtVal,oSldLido
Private oTxtProdCod,oTxtProdEmp,oNumOp
Private cNfDanfe       := ""
Private cSemana        := ""
Private cTransp        := ""
Private aEmbBip        := {}
Private aDanfes        := {}
Private _nTamDanfe     := 45
Private _nTamEtiq      := 21
Private _cNumEtqPA     := Space(_nTamEtiq)
Private _cNumDanfe     := Space(_nTamDanfe)
Private _cProduto      := CriaVar("B1_COD",.F.)
Private _cCliEmp	     := Space(06)
Private _cNomCli       := Space(15)
Private _cDescric	     := Space(27)
Private _cDescEmb      := Space(27)
Private _cEmbalag	     := Space(15)
Private _cNumOp        := SPACE(11)
Private _cNumNFS       := SPACE(06)
Private _nCont
Private nQtdCaixa      := 0
Private _nValNf        := ""
Private __oTelaNF
Private oTxtQtdEmp
Private oDanfes
Private nVolDanfe      := 0
Private nLido          := 0
Private nDanfeLida     := 0
Private _cPedido       := ""
Private cVolAtu        := ""
Private cDanfes        := ""
Private cTotVol        := ""
Private cVolLido       := "0"

If cUsuario == 'HELIO'
	_cNumDanfe := Space(_nTamDanfe)
	//	_cNumDanfe := "35161154821137000136550010000605121002311414"
	_cNumDanfe := "35170654821137000136550010000653731009665704"
EndIf

Define MsDialog __oTelaNF Title OemToAnsi("Confer๊ncia de Cargas " + DtoC(dDataBase) ) From 0,0 To 293,233 Pixel of oMainWnd PIXEL

nLin := 005
@ nLin,001 Say __oTxtNFS    Var "Danfe" Pixel Of __oTelaNF
@ nLin-2,020 MsGet __oGetNF  Var _cNumDanfe Valid VldDanfe() Size 095,10 Pixel Of __oTelaNF
__oTxtNFS:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
__oGetNF:oFont := TFont():New('Arial',,12,,.T.,,,,.T.,.F.)
nLin += 15

@ nLin,001 Say oTxtEtiq    Var "Num.Etiqueta" Pixel Of __oTelaNF
@ nLin-2,045 MsGet oGetEtq  Var _cNumEtqPA Valid VldEtiq() Size 70,10 Pixel Of __oTelaNF
oTxtEtiq:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
oGetEtq:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
nLin += 15

@ 032,001 To 134,115 Pixel Of oMainWnd PIXEL

@ nLin,005 Say oTxtPed Var "Nota Fiscal: " Pixel Of __oTelaNF
@ nLin,035 Say oNumPed Var _cNumNFS Size 120,10 Pixel Of __oTelaNF
oNumPed:oFont:= TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
nLin += 015
@ nLin,005 Say oTxtProdEmp  Var "Cliente: "        Pixel Of __oTelaNF
@ nLin,035 Say oTxtProdCod  Var _cCliEmp           Pixel Of __oTelaNF
oTxtProdCod:oFont  := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
nLin += 10
@ nLin,005 Say oTxtDes      Var "Descri็ใo: "      Pixel Of __oTelaNF
@ nLin,035 say oTxtDescPro  Var _cDescric      Size 075,15 Pixel Of __oTelaNF
oTxtDescPro:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
nLin += 15
@ nLin,005   Say oTxtDanfes Var "Notas Lidas:" Pixel Of __oTelaNF
@ nLin-1,060 MSGET oDanfes  Var cDanfes When .F. Size 50,10 Pixel Of __oTelaNF
oDanfes:oFont:= TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
nLin+= 15
@ nLin,005   Say oTxtTotVol Var "Volumes Totais:" Pixel Of __oTelaNF
@ nLin-1,060 MSGET oTotVol  Var cTotVol When .F. Size 50,10 Pixel Of __oTelaNF
oTotVol:oFont:= TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
nLin+= 15
@ nLin,005   Say oTxtSldNF Var "Volumes da NF:" Pixel Of __oTelaNF
@ nLin-1,060 MSGET oSldNF  Var cVolAtu When .F. Size 50,10 Pixel Of __oTelaNF
oSldNF:oFont:= TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
nLin+=15
@ nLin,005   Say oTxtSldGrupo Var "Volumes Lidos:" Pixel Of __oTelaNF
@ nLin-1,060 MSGET oSldLido  Var cVolLido When .F. Size 50,10 Pixel Of __oTelaNF
oSldLido:oFont:= TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
nLin += 15

@ nLin,005 Button oRomaneio PROMPT "Gerar Romaneio" Size 45,10 Action Close(__oTelaNF) Pixel Of __oTelaNF
@ nLin,077 Button oEtiqueta PROMPT "Sair" Size 35,10 Action Close(__oTelaNF) Pixel Of __oTelaNF

Activate MsDialog __oTelaNF

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ            '
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VldEtq   บAutor  ณHelio Ferreira      บ Data ณ  15/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida็ใo da etiqueta para faturamento						     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldDanfe()

Local _lRet := .T.
_cCliEmp    := ""
_cDescric   := ""
_cEmbalag   := ""
cNfDanfe    := ""
cSemana     := ""
cTransp     := ""
aEmbBip     := {}
nVolLido    := 0
nVolAtu     := 0
nLido       := 0

If Empty(_cNumDanfe)
	Return ( .T. )
EndIf

If aScan(aDanfes,{ |aVet| aVet[1] == _cNumDanfe }) == 0

	nDanfeLida++
	cDanfes := ALLTRIM(STR(nDanfeLida))
	oDanfes:Refresh()
	AADD(aDanfes, { _cNumDanfe } )
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica os volumes da DANFE							 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cAliasSF2 := GetNextAlias()
	cWhereSF2 := "%F2_CHVNFE = '"+ALLTRIM(_cNumDanfe)+"'%"
	_cPedido  := ""
	
	BeginSQL Alias cAliasSF2
		
		SELECT * FROM %table:SF2% SF2 (NOLOCK)
		WHERE SF2.%NotDel%
		AND %Exp:cWhereSF2%
		
	EndSQL
	
	If (cAliasSF2)->(!Eof())
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVerifica volume													ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		SD2->(dbSetOrder(3))
		If SD2->(dbSeek((cAliasSF2)->F2_FILIAL+(cAliasSF2)->F2_DOC+(cAliasSF2)->F2_SERIE))
			
			SC5->(dbSetOrder(1))
			SC5->(dbSeek(xFilial("SC5")+SD2->D2_PEDIDO))
			SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE))
			_cNumNFS    := (cAliasSF2)->F2_DOC+"-"+(cAliasSF2)->F2_SERIE
			cNfDanfe    := (cAliasSF2)->F2_DOC+" "+ALLTRIM(SA1->A1_MUN)
			cSemana     := fSemanaAno()+"/"+SubStr(StrZero(Year(Date()),4),3,2)
			cTransp     := SUBSTR(Posicione("SA4",1,xFilial("SA4")+SC5->C5_TRANSP,"A4_NOME"),1,25)
			_cNomCli    := SA1->A1_NOME
			_cPedido    := SD2->D2_PEDIDO
			cAliasXD1   := GetNextAlias()
			cWhere      := "%XD1_ZYNOTA  = '"+(cAliasSF2)->F2_DOC+"'%"
			
			BeginSQL Alias cAliasXD1
				SELECT COUNT(*) NQTDECAIXA FROM %table:XD1% XD1 (NOLOCK) WHERE %exp:cWhere% AND XD1.%NotDel%
			EndSQL
			nVolDanfe := (cAliasXD1)->NQTDECAIXA
			(cAliasXD1)->(dbCloseArea())
			
		EndIf
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVerifica faturamento												ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If nVolDanfe == 0
			U_MsgColetor("Carga nใo permitida. Calculo de volumes igual a zero.")
			_cNumDanfe := Space(_nTamDanfe)
			__oGetNF:Refresh()
			__oGetNF:SetFocus()
			Return(.F.)
		EndIf
		
		_cNumNFS  := (cAliasSF2)->F2_DOC
		_nValNF   := "R$ "+Transform((cAliasSF2)->F2_VALBRUT,"@E 999,999,999.99")
		_cCliEmp  := (cAliasSF2)->F2_CLIENTE
		_cDescric := Posicione("SA1",1,xFilial("SA1")+(cAliasSF2)->F2_CLIENTE,"A1_NOME")
		cVolAtu   := ALLTRIM(STR(nVolDanfe))
		_lRet := .T.
		
	Else
		
		U_MsgColetor("Nota Fiscal nใo encontrada.")
		(cAliasSF2)->(dbCloseArea())
		_cNumDanfe := Space(_nTamDanfe)
		__oGetNF:Refresh()
		__oGetNF:SetFocus()
		Return ( .F. )
		
	EndIf
	
	(cAliasSF2)->(dbCloseArea())
	_lRet      := .T.
	__oTelaNF:Refresh()
	__oGetNF:Refresh()
	oGetEtq:SetFocus()
	
EndIf

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ            '
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldEtiq   บAutor  ณHelio Ferreira      บ Data ณ  15/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida a etiqueta pelo coletor								     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldEtiq()

Local lVld  := .T.

If Empty(_cNumEtqPA)
	Return .T.
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPrepara n๚mero da etiqueta bipada							ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Len(AllTrim(_cNumEtqPA))==12 //EAN 13 s/ dํgito verificador.
	_cNumEtqPA := "0"+_cNumEtqPA
	_cNumEtqPA := Subs(_cNumEtqPA,1,12)
EndIf

XD1->(dbSetOrder(1))
If XD1->(dbSeek(xFilial("XD1")+_cNumEtqPA))
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica separa็ใo												ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If SUBSTR(XD1->XD1_PVSEP,1,6) <> _cPedido
		U_MsgColetor("Esta caixa pertence a outra Nota Fiscal.")
		_cNumEtqPA := Space(_nTamEtiq)
		oGetEtq:Refresh()
		oGetEtq:SetFocus()
		Return ( .F. )
	EndIf
	
	If aScan(aEmbBip,{ |aVet| aVet[1] == _cNumEtqPA }) == 0
		nLido++
		cVolLido := ALLTRIM(STR(nLido))
		oSldLido:Refresh()
		AADD(aEmbBip, { _cNumEtqPA, XD1->XD1_QTDATU } )
		If nLido == nVolDanfe
			If U_uMsgYesNo("Carga completa. Deseja encerrar confer๊ncia dessa Nota?")
				//ImpEtqDanfe()
				_cNumNFS  := ""
				_nValNF   := ""
				_cCliEmp  := ""
				_cDescric := ""
				cVolAtu   := ""
				cVolLido  := "0"
				cTotVol   += ALLTRIM(STR(nLido))
				_cNumDanfe := Space(_nTamDanfe)
				_cNumEtqPA := Space(_nTamEtiq)
				oGetEtq:Refresh()
				__oGetNF:Refresh()
				__oGetNF:SetFocus()
				Return ( .T. )
			EndIf
		EndIf
	EndIf
	
	_cNumEtqPA := Space(_nTamEtiq)
	oGetEtq:Refresh()
	oGetEtq:SetFocus()
	lVld := .T.
	
Else
	
	U_MsgColetor("Etiqueta Invalida.")
	_cNumEtqPA := Space(_nTamEtiq)
	oGetEtq:Refresh()
	oGetEtq:SetFocus()
	Return ( .F. )
	
EndIf

Return ( lVld )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ImpEtqDanfeบAutor ณ Michel A. Sander  บ Data ณ  05/04/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressใo da etiqueta							                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ImpEtqDanfe()

Local cPathTmp   := AllTrim( GetSrvProfString("RootPath","") )
Local cFileDes   := ""
LOCAL cModelo    := "Z4M"
Local cPorta     := "LPT2"
Local cRotacao   := "N"      //(N,R,I,B)

//Chamando fun็ใo da impressora ZEBRA

For nX := 1 to nVolDanfe
	
	MSCBPRINTER(cModelo,cPorta,,,.F.)
	MSCBChkStatus(.F.)
	MSCBLOADGRF("RDT2.GRF")
	
	//Inicia impressใo da etiqueta
	MSCBBEGIN(1,5)
	
	nCol  := 06
	nLin  := 17
	
	//Logos
	MSCBGRAFIC(05,07,"RDT2")
	
	MSCBSAY(nCol   ,nLin      ,"Rosenberger Domex Telecomunica็๕es"                              ,cRotacao,"0","26,26")
	MSCBSAY(nCol   ,nLin+3    ,"Av. Cabletech, 601 - Ca็apava - SP"	                             ,cRotacao,"0","26,26")
	MSCBSAY(nCol   ,nLin+6    ,"Tel (12) 3221 8500"												 ,cRotacao,"0","26,26")
	MSCBSAY(nCol   ,nLin+9    ,"www.rdt.com.br"                                                  ,cRotacao,"0","26,26")
	
	//Contorno/Borda
	MSCBBOX(03,30,115,80,3,"B")
	
	//Grade de Separacao de coluna
	MSCBBOX(40,30,40,80,3,"B")
	MSCBSAY(nCol,    35, "Cliente"                              ,cRotacao,"0","35,35")
	MSCBSAY(nCol+40, 35, SUBSTR(SA1->A1_NOME,1,20)              ,cRotacao,"0","35,35")
	
	//Grade de Clientes
	MSCBBOX(03,40,115,80,3,"B")
	MSCBSAY(nCol   , 45, "Pedido Compra"                       ,cRotacao,"0","35,35")
	MSCBSAY(nCol+40, 45, SC5->C5_ESP1			                 ,cRotacao,"0","35,35")
	
	//Grade da Nota Fiscal/Local
	MSCBBOX(03,50,115,80,3,"B")
	MSCBSAY(nCol   , 55, "NF/LOCAL"     	                    ,cRotacao,"0","35,35")
	MSCBSAY(nCol+40, 55, cNfDanfe    			                ,cRotacao,"0","35,35")
	
	//Grade da Semana/Ano
	MSCBBOX(03,60,115,80,3,"B")
	MSCBSAY(nCol   , 65, "Semana/Ano"                           ,cRotacao,"0","35,35")
	MSCBSAY(nCol+40, 65, cSemana  				                ,cRotacao,"0","35,35")
	
	//Grade da Semana/Ano
	MSCBBOX(03,70,115,80,3,"B")
	MSCBSAY(nCol   , 75, "Transportadora"                      ,cRotacao,"0","35,35")
	MSCBSAY(nCol+40, 75, cTransp  				               ,cRotacao,"0","35,35")
	MSCBInfoEti("DOMEX","80X60")
	
	//Finaliza impressใo da etiqueta
	MSCBEND()
	Sleep(500)
	
	MSCBCLOSEPRINTER()
	
Next nX

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSemanaAnoบAutor  ณ Felipe Melo        บ Data ณ  11/12/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fSemanaAno()

Local dDataIni := StoD(StrZero(Year(Date()),4)+"0101")
Local dDataAtu := Date()
Local nRet     := 0
Local cRet     := ""
Local nDiff    := Dow(dDataIni)

nDias := (dDataAtu - dDataIni) + nDiff

nRet  := nDias
nRet  := nRet / 7
nRet  := Int(nRet)

//Se iniciou a semana, soma 1
If nDias % 7 > 0
	nRet := nRet + 1
EndIf

cRet := StrZero(nRet,2)

//Fun็ใo padrใo que retorna a semana e o ano
//RetSem(dDataAtu)

Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ            '
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAlertC    บAutor  ณHelio Ferreira      บ Data ณ  15/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Mensagem de alerta para o coletor de dados				     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AlertC(cTexto)

Local aTemp := U_QuebraString(cTexto,20)
Local cTemp := ''
Local lRet  := .T.

For x := 1 to Len(aTemp)
	cTemp += aTemp[x] + Chr(13)
Next x

cTemp += 'Continuar?'

While !apMsgNoYes( cTemp )
	lRet:=.F.
End

Return(lRet)
