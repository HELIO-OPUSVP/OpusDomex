#include "protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DOMETQ95 บAutor  ณ Michel A. Sander   บ Data ณ  05/04/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Etiqueta Serial Cliente COMBA					                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DOMETQ95(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,cVolumeAtu,lColetor,cNumSerie,cNumPeca)

Local lPrinOK    := MSCBModelo("ZPL","Z4M")

Local aPar       := {}
Local aRet       := {}
Local nVar       := 0

Local aItemXD2  := {}
Local MVPAR02   := 1         //Qtd Embalagem
Local MVPAR03   := 1         //Qtd Etiquetas

Private cModelo  := "Z4M"
Private cPorta   := "LPT1"
Private cRotacao := "N"      //(N,R,I,B)
Private lAchou   := .T.
Private aGrpAnat := {}     //Codigos Anatel Agrupados
Private nColV    := 0
Private nCol     := 0
Private nIni     := 0
Private nLin     := 0

Default cNumOP   := ""
Default cNumSenf := ""
Default nQtdEmb  := 0
Default nQtdEtq  := 0
Default cNivel   := ""
Default aFilhas  := {}
Default cVolumeAtu := ''
Default cNumSerie := ""
Default cNumPeca  := ""

MVPAR02:= nQtdEmb   //Qtd Embalagem
MVPAR03:= nQtdEtq   //Qtd Etiquetas /*revisar*/

If lImpressao
	
	//Chamando fun็ใo da impressora ZEBRA
	
	MSCBPRINTER(cModelo,cPorta,,,.F.)
	MSCBChkStatus(.F.)
	
	//Controla o numero da etiqueta de embalagens
	cNewPeca := cNumPeca
	
	If Empty(cNewPeca)
		_cProxPeca := U_IXD1PECA()
	Else
		_cProxPeca := cNewPeca
	EndIf

	XD1->(dbSetOrder(1))
	aItemXD2 := {}
	//ณcPARAM 01 - Numero da Pe็a	//ณcPARAM 01 - Numero da OP // nPARAM 01 - Quantidade lida									  ณ
	For _nX := 1 to Len(aFilhas)
		Reclock("XD2",.T.)
		XD2->XD2_FILIAL := xFilial("XD2")
		XD2->XD2_XXPECA := _cProxPeca
		XD2->XD2_PCFILH := aFilhas[_nX,1]
		XD2->( msUnlock() )
		
		If XD1->(dbSeek(xFilial()+XD2->XD2_PCFILH))
			AADD( aItemXD2, { aFilhas[_NX,2], aFilhas[_NX,3], XD1->XD1_COD, XD1->XD1_QTDATU, XD1->XD1_SERIAL } ) //mls
		Else
			U_MsgColetor("Registro do XD2 nใo encontrado no XD1")
		EndIf
		
	Next _nX
	
	ASORT(aItemXD2,2,,{ |x, y| x[1] < y[1] })
	
	For x := 1 To MVPAR03
	
		Reclock("XD1",.T.)
		XD1->XD1_FILIAL    := xFilial("XD1")
		XD1->XD1_XXPECA    := _cProxPeca
		XD1->XD1_FORNEC    := Space(06)
		XD1->XD1_LOJA      := Space(02)
		XD1->XD1_DOC       := Space(06)
		XD1->XD1_SERIE     := Space(03)
		XD1->XD1_ITEM      := ""
		XD1->XD1_COD       := SB1->B1_COD
		XD1->XD1_LOCAL     := SB1->B1_LOCPAD
		XD1->XD1_TIPO      := SB1->B1_TIPO
		XD1->XD1_LOTECT    := U_RetLotC6(cNumOP)
		XD1->XD1_DTDIGI    := dDataBase
		XD1->XD1_FORMUL    := ""
		XD1->XD1_LOCALI    := ""
		XD1->XD1_USERID    := __cUserId
		XD1->XD1_OCORRE    := "6"
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
		If Type("XD1->XD1_VOLUME") <> 'U'
			XD1->XD1_VOLUME := cVolumeAtu
		EndIf
		XD1->XD1_SERIAL := cNumSerie
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
				//MSCBSAY(nCol+10,nIni ,aItemXD2[Y,3]                         ,cRotacao,"0","26,26")
				MSCBSAY(nCol+10,nIni ,aItemXD2[Y,5]                         ,cRotacao,"0","26,26")
				MSCBSAY(nCol+42,nIni ,TransForm(aItemXD2[Y,4],"@E 99,999")  ,cRotacao,"0","26,26")
				nIni += 3
			Else
				nLimite := 0
				nIni    := 13
				nIniXD2 := nIni
				nCol    := 6
				MSCBInfoEti("DOMEX","80X60")
				//Finaliza impressใo da etiqueta
				MSCBEND()
				Sleep(500)
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณImprime corpo da etiqueta										ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				ImpCabEtq(1)
				MSCBSAY(nCol+1 ,nIni ,aItemXD2[Y,2]                         ,cRotacao,"0","26,26")
				//MSCBSAY(nCol+10,nIni ,aItemXD2[Y,3]                         ,cRotacao,"0","26,26")
				MSCBSAY(nCol+10,nIni ,aItemXD2[Y,5]                         ,cRotacao,"0","26,26")
				MSCBSAY(nCol+42,nIni ,TransForm(aItemXD2[Y,4],"@E 99,999")  ,cRotacao,"0","26,26")
				nIni += 3
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

If nBarra == 0
	MSCBSAYBAR(75  ,07      ,U_fTratTxt(XD1->XD1_XXPECA)                                    ,cRotacao,"MB04",7.361,.F.,.T.,.F.,,3,2,.F.,.F.,"1",.T.)
EndIf

MSCBSAY(nCol   ,nIni+7  ,"ITEM"                                                            ,cRotacao,"0","26,26")
MSCBSAY(nCol+10,nIni+7  ,U_fTratTxt("PRODUTO")                                             ,cRotacao,"0","26,26")
MSCBSAY(nCol+42,nIni+7  ,U_fTratTxt("QTDE")                                                ,cRotacao,"0","26,26")
nCol += 54

MSCBSAY(nCol   ,nIni+7  ,"ITEM"                                                            ,cRotacao,"0","26,26")
MSCBSAY(nCol+10,nIni+7  ,U_fTratTxt("PRODUTO")                                             ,cRotacao,"0","26,26")
MSCBSAY(nCol+42,nIni+7  ,U_fTratTxt("QTDE")                                                ,cRotacao,"0","26,26")

Return
