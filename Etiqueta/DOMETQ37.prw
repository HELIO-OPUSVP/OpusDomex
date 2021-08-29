#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDOMETQ37  บAutor  ณMichel A. Sander    บ Data ณ  13/11/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Etiqueta de Controle SGP                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DOMETQ37()

	Local mv_par02 := 1         //Qtd Embalagem
	Local mv_par03 := 1         //Qtd Etiquetas

	Private cModelo    := "TLP 2844"  // "Z4M"
	Private lPrinOK    := MSCBModelo("ZPL",cModelo)
	Private _cPorta    := "LPT2"
	Private lAchou     := .T.
	Private _cSerieIni := ""
	Private oGetEtq
	Private oGetSGP
	Private nTamSGP    := 19
	Private nTamNossa  := 21
	Private cNumSGP    := Space(nTamSGP)
	Private cNossaEtq  := Space(nTamNossa)
	Private cNumOP     := ""
	Private cNumSerie  := 1

	Private cNumPV     := Space(6)
	Private cItemPV    := Space(2)

	DEFINE MSDIALOG oTelaSGP TITLE OemToAnsi("Impressใo de etiquetas SGP") FROM 20,20 TO 150,620 PIXEL OF oMainWnd PIXEL
	@ 1,005 TO 1,310 PIXEL OF oTelaSGP
	nLin := 010
	@ nLin,005 SAY   oTxtETQ VAR "Etiqueta da Embalagem" PIXEL OF oTelaSGP
	@ nLin,085 MSGET oGetETQ VAR cNossaEtq WHEN .T. PICTURE "@!" VALID ValNossa() SIZE 150,10 PIXEL OF oTelaSGP
	nLin += 015
	@ nLin,005 SAY   oTxtSGP VAR "Numero da Placa SGP  " PIXEL Of oTelaSGP
	@ nLin,085 MSGET oGetSGP VAR cNumSGP   WHEN .T. PICTURE "@!" VALID ValSGP()   SIZE 150,10 PIXEL OF oTelaSGP
	oTxtETQ:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
	oGetETQ:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
	oTxtSGP:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
	oGetSGP:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
	nLin += 016
	@ nLin,260 BUTTON oBotSGP PROMPT "Cancelar" SIZE 35,15 ACTION {|| oTelaSGP:End()} PIXEL OF oTelaSGP
	ACTIVATE MSDIALOG oTelaSGP


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValNossa  บAutor  ณMichel A. Sander    บ Data ณ  13/11/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida nossa etiqueta de embalagem                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValNossa()
	//Local cQry   := ''
	Local lNossa := .T.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPrepara n๚mero da etiqueta bipada							ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Len(AllTrim(cNossaEtq))==12 //EAN 13 s/ dํgito verificador.
		cNossaEtq := "0"+cNossaEtq
		cNossaEtq := Subs(cNossaEtq,1,12)
	EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica etiqueta bipada										ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	XD1->(dbSetOrder(1))
	If !XD1->(dbSeek(xFilial()+cNossaEtq))
		While !MsgNoYes("Etiqueta de embalagem invแlida."+CHR(13)+CHR(13)+"Deseja continuar?")
		End
		lNossa := .F.
		cNossaEtq := Space(nTamNossa)
		oGetETQ:Refresh()
		oGetETQ:SetFocus()
	Else
		If XD1->XD1_OCORRE == "5"
			While !MsgNoYes("Etiqueta cancelada."+CHR(13)+CHR(13)+"Deseja continuar?")
			End
			lNossa := .F.
			cNossaEtq := Space(nTamNossa)
			oGetETQ:Refresh()
			oGetETQ:SetFocus()
		EndIf
	EndIf
	
	If lNossa
	    cNumOp := XD1->XD1_OP
		//Osmar 03/02/21 - Identifcar o n๚mero do PV e validar a Etiqueta x PV
		SC2->(dbSetOrder(1))
		If SC2->(dbSeek(xFilial()+cNumOP))
			cNumPV  := SC2->C2_PEDIDO
			cItemPV := SC2->C2_ITEMPV
		EndIf

	//	ZZP->(dbSetOrder(2))
	//	If ZZP->(dbSeek(xFilial()+cNossaEtq))
	//	   If cNumpv <> ZZP->ZZP_PEDIDO
	//	       msgAlert("N๚mero do Pedido nใo confere com a Etiqueta SGP!!"+CHR(13)+CHR(13)+;
	//		             "Pedido Informado.: "+cNumPV+" / "+cItemPV+CHR(13)+CHR(13)+;
	//					 "Pedido Correto...: "+ZZP->ZZP_PEDIDO+" / "+ZZP->ZZP_ITEM)
	//	    EndIf
	//	Else
	//	   msgAlert("Etiqueta SGP nใo cadastrada!!")
	//	EndIf
	EndIf

Return ( lNossa )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValSGP    บAutor  ณMichel A. Sander    บ Data ณ  13/11/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida Etiqueta de Controle SGP                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValSGP()

	Local lSGP := .T.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica etiqueta SGP											ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	XD5->(dbSetOrder(1))
	If XD5->(dbSeek(xFilial()+AllTrim(cNumSGP)))
		While !MsgNoYes("N๚mero SGP jแ impresso."+CHR(13)+CHR(13)+"Deseja continuar?")
		End
		lSGP := .F.
		cNumSGP := Space(nTamSGP)
		cNumOP  := ""	
		cNumPV  := Space(06)
		cItemPV := Space(02) 
		oGetSGP:Refresh()
		oGetSGP:SetFocus()
		Return (lSGP)
	EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValida a etiqueta SGP x Pedido						ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
ZZP->(dbSetOrder(2))
If ZZP->(dbSeek(xFilial()+cNumSGP))
   If cNumpv <> ZZP->ZZP_PEDIDO
       While !MsgNoYes("N๚mero do Pedido nใo confere com a Etiqueta SGP!!"+CHR(13)+CHR(13)+;
	             "Pedido Informado.: "+cNumPV+" / "+cItemPV+CHR(13)+CHR(13)+;
				 "Pedido Correto...: "+ZZP->ZZP_PEDIDO+" / "+ZZP->ZZP_ITEM+CHR(13)+CHR(13)+"Deseja continuar?")
		End		 
	    lSGP := .F.
    EndIf
Else
   While !MsgNoYes("Etiqueta SGP nใo cadastrada!!"+CHR(13)+CHR(13)+"Deseja continuar?")
	End
    lSGP := .F.
EndIf

If !lSGP 
	cNumSGP := Space(nTamSGP)
	cNumOP  := ""	
	cNumPV  := Space(06)
	cItemPV := Space(02) 
	oGetSGP:Refresh()
	oGetSGP:SetFocus()
	Return (lSGP)
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime etiqueta													ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	MSCBPrinter(cModelo,_cPorta,,,.F.)
	MSCBChkStatus(.F.)
	MSCBBegin(1,6)
	MSCBSayBar(35,03,AllTrim(cNumSGP),"N","MB07",10   ,.F.,.F.,.F.,,2,2,.F.,.F.,"1",.T.)
//MSCBSayBar(30,03,cConteudo       ,"N",      ,[ nAltura ] [ *lDigver ] [ lLinha ] [ *lLinBaixo ] [ cSubSetIni ]      [ nLargura ] [ nRelacao ] [ lCompacta ] [ lSerial ] [ cIncr ] [ lZerosL ] )
	MSCBSay(35,15,"SGP " + cNumSGP,"N","2","1,1")
	MSCBEnd()
	Sleep(500)
	MSCBClosePrinter()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGrava n๚mero da etiqueta SGP									ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


Reclock("XD5",.T.)
XD5->XD5_FILIAL := xFilial("XD5")
XD5->XD5_NUMSGP := cNumSGP
XD5->XD5_NUMOP  := cNumOP
XD5->XD5_PECA   := cNossaEtq
XD5->(MsUnlock())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtualiza tela														ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cNumOP  := ""	
cNumPV  := Space(06)
cItemPV := Space(02) 
cNumSGP := Space(nTamSGP)
oGetSGP:Refresh()
cNossaEtq := Space(nTamNossa)
oGetETQ:Refresh()
oGetETQ:SetFocus()

Return ( lSGP )
