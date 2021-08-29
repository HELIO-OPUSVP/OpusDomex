#include "protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DOMETQ90 บAutor  ณ Michel A. Sander   บ Data ณ  05/04/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Etiqueta de Embalagem Nivel 3 (Expedi็ใo)                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
 
User Function DOMETQ90(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,cVolumeAtu,lColetor,cNumSerie,cNumPeca,cItemPed)

Local lPrinOK    := MSCBModelo("ZPL","Z4M")

Local aPar       := {}
Local aRet       := {}
Local nVar       := 0

Local aItemXD2  := {}
Local MVPAR02   := 1         //Qtd Embalagem
Local MVPAR03   := 1         //Qtd Etiquetas

Private cModelo  := "Z4M"
Private cPorta   := "LPT2"
Private cRotacao := "N"      //(N,R,I,B)
Private lAchou   := .T.
Private aGrpAnat := {}     //Codigos Anatel Agrupados
Private nColV    := 0
Private nCol     := 0
Private nIni     := 0
Private nLin     := 0
Private cImpSenf := ""

Default cNumOP     := ""
Default cNumSenf   := ""
Default nQtdEmb    := 0
Default nQtdEtq    := 0
Default cNivel     := ""
Default aFilhas    := {}
Default cVolumeAtu := ''
Default cNumSerie  := ""
Default cNumPeca   := ""   
Default cItemPed   := ""

MVPAR02  := nQtdEmb   //Qtd Embalagem
MVPAR03  := nQtdEtq   //Qtd Etiquetas /*revisar*/
cImpSenf := cNumSenf

//U_MsgColetor("Teste na " + cPorta)

If !Empty(cNumOP)
	//Localiza SC2
	SC2->(DbSetOrder(1))
	If lAchou .And. SC2->(!DbSeek(xFilial("SC2")+cNumOP))
		Alert("Numero O.P. "+AllTrim(cNumOP)+" nใo localizada!")
		lAchou := .F.
	EndIf
	
	//Localiza SC5
	If !Empty(SC2->C2_PEDIDO)
		SC5->(DbSetOrder(1))
		If lAchou .And. !SC5->(DbSeek(xFilial("SC5")+SC2->C2_PEDIDO))
			Alert("Numero de Senf "+AllTrim(SC2->C2_PEDIDO)+" nใo localizado!")
			lAchou := .F.
		EndIf
		
		//Localiza SC6
		SC6->(DbSetOrder(1))
		If lAchou .And. SC6->(!DbSeek(xFilial("SC6")+SC2->C2_PEDIDO+SC2->C2_ITEMPV))
			Alert("Item Senf "+AllTrim(SC2->C2_ITEMPV)+" nใo localizado!")
			lAchou := .F.
		EndIf
	EndIf
	
EndIf

If !Empty(cNumSenf)
	//Localiza SC5
	SC5->(DbSetOrder(1))
	If lAchou .And. SC5->(!DbSeek(xFilial("SC5")+Subs(cNumSenf,1,6) ))
		Alert("Numero de Senf "+Subs(cNumSenf,1,6)+" nใo localizado!")
		lAchou := .F.
	EndIf
	
	//Localiza SC6
	SC6->(DbSetOrder(1))
	If lAchou .And. SC6->(!DbSeek(xFilial("SC6")+Subs(cNumSenf,1,8) ))
		Alert("Item Senf "+Subs(cNumSenf,7,2) +" nใo localizado!")
		lAchou := .F.
	EndIf
EndIf

//Localiza SB1
// Michel Sander em 12.01.2017 posicionar produto de acordo com OP ou SENF
If !Empty(cNumOp) .And. Empty(cNumSenf)
	SB1->(DbSetOrder(1))
	If lAchou .And. SB1->(!DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
		Alert("Produto "+AllTrim(SC2->C2_PRODUTO)+" nใo localizado!")
		lAchou := .F.
	EndIf
ElseIf !Empty(cNumSenf)
	SB1->(DbSetOrder(1))
	If lAchou .And. SB1->(!DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
		Alert("Produto "+AllTrim(SC6->C6_PRODUTO)+" nใo localizado!")
		lAchou := .F.
	EndIf
EndIf

//Localiza SA1
If !Empty(SC2->C2_PEDIDO)
	SA1->(DbSetOrder(1))
	If lAchou .And. SA1->(!DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
		Alert("Cliente "+SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI+" nใo localizado!")
		lAchou := .F.
	EndIf
EndIf

//Caso algum registro nใo seja localizado, sair da rotina
If !lAchou
	Return(.F.)
EndIf

//Se impressora nใo identificada, sair da rotina
If !lPrinOK
	Alert("Erro de configura็ใo!")
	Return(.F.)
EndIf

If lImpressao
	
	cFila := SuperGetMv("MV_XFILEXP",.F.,"000005")
	IF !CB5SetImp(cFila,.F.)
		Aviso("Local de impressao invalido!","Aviso")
		Return .F.
	EndIf
  
	//Chamando fun็ใo da impressora ZEBRA
	
	// MSCBPRINTER(cModelo,cPorta,,,.F.)
	// MSCBChkStatus(.F.)
	MSCBLOADGRF("RDT2.GRF")
	//	MSCBLOADGRF("ANATEL2.GRF")
	
	//Controla o numero da etiqueta de embalagens
	If Empty(cNumPeca)
		_cProxPeca := U_IXD1PECA()
	Else
		_cProxPeca := cNumPeca
	EndIf
	
	XD1->(dbSetOrder(1))
	aItemXD2 := {}             
	
	If ISINCALLSTACK('U_DOMACD34')
		AADD( aItemXD2, { "", "01", SC2->C2_PRODUTO, SC2->C2_QUANT } )
	EndIf
	
	For _nX := 1 to Len(aFilhas)
		Reclock("XD2",.T.)
		XD2->XD2_FILIAL := xFilial("XD2")
		XD2->XD2_XXPECA := _cProxPeca
		XD2->XD2_PCFILH := aFilhas[_nX,1]
		XD2->( msUnlock() )
		
		If XD1->(dbSeek(xFilial()+XD2->XD2_PCFILH))
			AADD( aItemXD2, { aFilhas[_NX,2], aFilhas[_NX,3], XD1->XD1_COD, XD1->XD1_QTDATU } )
		Else
			U_MsgColetor("Registro do XD2 nใo encontrado no XD1")
		EndIf
		
	Next _nX
	
	If !ISINCALLSTACK('U_DOMACD34')                          
	
   		ASORT(aItemXD2,2,,{ |x, y| x[1] < y[1] })  
 	EndIf
	
	For x:=1 To MVPAR03

		Reclock("XD1",.T.)
		XD1->XD1_FILIAL    := xFilial("XD1")
		XD1->XD1_XXPECA    := _cProxPeca
		XD1->XD1_FORNEC    := Space(06)
		XD1->XD1_LOJA      := Space(02)
		XD1->XD1_DOC       := Space(06)
		XD1->XD1_SERIE     := Space(03)
		XD1->XD1_ITEM      := cItemPed
		XD1->XD1_COD       := SB1->B1_COD
		XD1->XD1_LOCAL     := SB1->B1_LOCPAD
		XD1->XD1_TIPO      := SB1->B1_TIPO
		XD1->XD1_LOTECT    := U_RetLotC6(cNumOP)
		XD1->XD1_DTDIGI    := dDataBase
		XD1->XD1_FORMUL    := ""
		XD1->XD1_LOCALI    := ""
		XD1->XD1_USERID    := __cUserId
		XD1->XD1_OCORRE    := "6"
		//XD1->XD1_OP        := cNumOP
		XD1->XD1_PV        := cNumSenf
		XD1->XD1_QTDORI    := nQtdEmb
		XD1->XD1_QTDATU    := nQtdEmb
		aRetEmbala         := U_RetEmbala(XD1->XD1_COD,cNivel)
		XD1->XD1_EMBALA    := aRetEmbala[1]
		XD1->XD1_QTDEMB    := aRetEmbala[2]
		XD1->XD1_NIVEMB    := If(AllTrim(cNivel)=="3",cNivel,aRetEmbala[3]) // Nivel 3 (Volumes parar expedi็ใo nใo constam na estrutura)
		If !Empty(SC2->C2_PEDIDO)
			XD1->XD1_PVSEP     := If(AllTrim(cNivel)=="3",SC5->C5_NUM,"")
		EndIf
		XD1->XD1_PESOB     := nPesoVol
		XD1->XD1_PVSENF    := cNumSenf
		XD1->XD1_VOLUME    := cVolumeAtu
		XD1->XD1_SERIAL    := cNumSerie
		XD1->( MsUnlock() )
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime corpo da etiqueta										ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		ImpCabEtq(0)
		
		nIni    += 13
		nIniXD2 := nIni
		nLimite := 0
		For y := 1 to Len(aItemXD2)
			nLimite += 1
			If nLimite <= 38
				If nLimite == 1
					nCol := 6
					nIni := nIniXD2
				EndIf
				If nLimite == 20
					nCol := 60
					nIni := nIniXD2
				EndIf
				MSCBSAY(nCol+1 ,nIni ,aItemXD2[Y,2]                         ,cRotacao,"0","26,26")
				MSCBSAY(nCol+10,nIni ,aItemXD2[Y,3]                         ,cRotacao,"0","26,26")
				MSCBSAY(nCol+42,nIni ,TransForm(aItemXD2[Y,4],"@E 99,999")  ,cRotacao,"0","26,26")
				nIni += 3
			Else
				MSCBInfoEti("DOMEX","80X60")
				//Finaliza impressใo da etiqueta
				MSCBEND()
				Sleep(500)
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณImprime corpo da etiqueta										ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				ImpCabEtq(1)
				nLimite := 0
				nIni    := 13
				nCol    := 6
				MSCBSAY(nCol+1 ,nIni ,aItemXD2[Y,2]                         ,cRotacao,"0","26,26")
				MSCBSAY(nCol+10,nIni ,aItemXD2[Y,3]                         ,cRotacao,"0","26,26")
				MSCBSAY(nCol+42,nIni ,TransForm(aItemXD2[Y,4],"@E 99,999")  ,cRotacao,"0","26,26")
				nIni += 3
				nIniXD2 := nIni
			EndIf
		Next y
		
		MSCBInfoEti("DOMEX","80X60")
		
		//Finaliza impressใo da etiqueta
		MSCBEND()
		Sleep(500)
		
	Next x
	
	MSCBCLOSEPRINTER()
	
EndIf

Return(.T.)

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

Static Function ImpCabEtq(nBarra)

//Inicia impressใo da etiqueta
MSCBBEGIN(1,5)

nColV := 40
nCol  := 06
nIni  := 15
nLin  := 07

//Contorno/Borda
MSCBBOX(03,05,115,88,3,"B")
//Grade de Itens
MSCBBOX(05,20,113,86,3,"B")
//Grade do Cabe็alho dos Itens
MSCBBOX(05,26,113,26,3,"B")

//Grade do 1o. Item
MSCBBOX(14,20,14,86,3,"B")
//Grade do 1o. Produto
MSCBBOX(46,20,46,86,3,"B")
//Grade da 1o. Quantidade
MSCBBOX(59,20,59,86,3,"B")
//Grade do 2o. Item
MSCBBOX(68,20,68,86,3,"B")
//Grade do 2o. Produto
MSCBBOX(100,20,100,86,3,"B")

//Logos
MSCBGRAFIC(05,07,"RDT2")

If nBarra == 0
	MSCBSAYBAR(75  ,07      ,U_fTratTxt(XD1->XD1_XXPECA)                                    ,cRotacao,"MB04",7.361,.F.,.T.,.F.,,3,2,.F.,.F.,"1",.T.)
EndIf

If !Empty(cImpSenf)
	MSCBSAY(nColV  ,nLin    ,"PEDIDO:    " + cImpSenf , cRotacao,"0","26,26")
Else
	MSCBSAY(nColV  ,nLin    ,"PEDIDO:    " + If(!Empty(XD1->XD1_PVSENF),XD1->XD1_PVSENF,Subs(XD1->XD1_PVSEP,1,6)) , cRotacao,"0","26,26")
EndIf

If Type("XD1->XD1_VOLUME") <> 'U'
	MSCBSAY(nColV  ,nLin+4  ,"VOLUME: " + Alltrim(XD1->XD1_VOLUME)                          ,cRotacao,"0","26,26")
Else
	MSCBSAY(nColV  ,nLin+4  ,"VOLUME: "                                                     ,cRotacao,"0","26,26")
EndIf

MSCBSAY(nColV  ,nLin+8  ,"PESO:   " + Alltrim(Transform(XD1->XD1_PESOB,"@E 999,999.99"))+" Kg",cRotacao,"0","26,26")

MSCBSAY(nCol   ,nIni+7  ,"ITEM"                                                            ,cRotacao,"0","26,26")
MSCBSAY(nCol+10,nIni+7  ,U_fTratTxt("PRODUTO")                                             ,cRotacao,"0","26,26")
MSCBSAY(nCol+42,nIni+7  ,U_fTratTxt("QTDE")                                                ,cRotacao,"0","26,26")
nCol += 54

MSCBSAY(nCol   ,nIni+7  ,"ITEM"                                                            ,cRotacao,"0","26,26")
MSCBSAY(nCol+10,nIni+7  ,U_fTratTxt("PRODUTO")                                             ,cRotacao,"0","26,26")
MSCBSAY(nCol+42,nIni+7  ,U_fTratTxt("QTDE")                                                ,cRotacao,"0","26,26")

Return
