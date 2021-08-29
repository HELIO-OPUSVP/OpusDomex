#include "protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DOMETQ92 ºAutor  ³ Michel A. Sander   º Data ³  26.07.2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Etiqueta de Palete Nivel P (Expedição) 	                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMETQ92(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,cVolumeAtu,lColetor,cNumSerie,cNumPeca)

Local cModelo    := "Z4M"
Local cPorta     := "LPT2"

Local lPrinOK    := MSCBModelo("ZPL",cModelo)

Local aPar       := {}
Local aRet       := {}
Local nVar       := 0

Local aItemXD2  := {}
Local MVPAR02   := 1         //Qtd Embalagem
Local MVPAR03   := 1         //Qtd Etiquetas

Private lAchou   := .T.
Private aGrpAnat := {}     //Codigos Anatel Agrupados
Private nColV    := 0
Private nCol     := 0
Private nIni     := 0
Private nLin     := 0
Private nIniXD2  := 0
Private cRotacao   := "N"      //(N,R,I,B)
Private cPaisDest := ""

Default cNumOP   := ""
Default cNumSenf := ""
Default nQtdEmb  := 0
Default nQtdEtq  := 0
Default cNivel   := ""
Default aFilhas  := {}
Default cNumSerie := ""
Default cNumPeca  := ""

MVPAR02:= nQtdEmb   //Qtd Embalagem
MVPAR03:= nQtdEtq   //Qtd Etiquetas /*revisar*/

If !Empty(cNumOP)
	//Localiza SC2
	SC2->(DbSetOrder(1))
	If lAchou .And. SC2->(!DbSeek(xFilial("SC2")+cNumOP))
		Alert("Numero O.P. "+AllTrim(cNumOP)+" não localizada!")
		lAchou := .F.
	EndIf
	
	//Localiza SC5
	If !Empty(SC2->C2_PEDIDO)
		SC5->(DbSetOrder(1))
		If lAchou .And. SC5->(!DbSeek(xFilial("SC5")+SC2->C2_PEDIDO))
			Alert("Numero de Senf "+AllTrim(SC2->C2_PEDIDO)+" não localizado!")
			lAchou := .F.
		EndIf
		
		//Localiza SC6
		SC6->(DbSetOrder(1))
		If lAchou .And. SC6->(!DbSeek(xFilial("SC6")+SC2->C2_PEDIDO+SC2->C2_ITEMPV))
			Alert("Item Senf "+AllTrim(SC2->C2_ITEMPV)+" não localizado!")
			lAchou := .F.
		EndIf
	EndIf
EndIf

If !Empty(cNumSenf)
	//Localiza SC5
	SC5->(DbSetOrder(1))
	If lAchou .And. SC5->(!DbSeek(xFilial("SC5")+Subs(cNumSenf,1,6) ))
		Alert("Numero de Senf "+Subs(cNumSenf,1,6)+" não localizado!")
		lAchou := .F.
	EndIf
	
	//Localiza SC6
	SC6->(DbSetOrder(1))
	If lAchou .And. SC6->(!DbSeek(xFilial("SC6")+Subs(cNumSenf,1,8) ))
		Alert("Item Senf "+Subs(cNumSenf,7,2) +" não localizado!")
		lAchou := .F.
	EndIf
EndIf

//Localiza SA1
SA1->(DbSetOrder(1))
If !Empty(SC2->C2_PEDIDO)
	If lAchou .And. SA1->(!DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
		Alert("Cliente "+SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI+" não localizado!")
		lAchou := .F.
	EndIf
	cPaisDest := Posicione("SYA",1,SA1->A1_FILIAL+SA1->A1_PAIS,"YA_DESCR")
EndIf

//Localiza SB1
SB1->(DbSetOrder(1))
If lAchou .And. SB1->(!DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
	Alert("Produto "+AllTrim(SC2->C2_PRODUTO)+" não localizado!")
	lAchou := .F.
EndIf

//Caso algum registro não seja localizado, sair da rotina
If !lAchou
	Return(.F.)
EndIf

//Se impressora não identificada, sair da rotina
If !lPrinOK
	Alert("Erro de configuração!")
	Return(.F.)
EndIf

If lImpressao
	
	//Chamando função da impressora ZEBRA
	
	//MSCBPRINTER(cModelo,cPorta,,,.F.)
	//MSCBChkStatus(.F.)
	
	
	cFila := SuperGetMv("MV_XFILEXP",.F.,"000005")
	IF !CB5SetImp(cFila,.F.)
			U_MsgColetor("Local de impressao invalido!")
			Return .F.
	EndIf

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
	
	For _nX := 1 to Len(aFilhas)
		Reclock("XD2",.T.)
		XD2->XD2_FILIAL := xFilial("XD2")
		XD2->XD2_XXPECA := _cProxPeca
		XD2->XD2_PCFILH := aFilhas[_nX,1]
		XD2->( msUnlock() )
		
		If XD1->(dbSeek(xFilial()+XD2->XD2_PCFILH))
			AADD( aItemXD2, { aFilhas[_NX,1], aFilhas[_NX,3], XD1->XD1_COD, XD1->XD1_QTDATU } )
		Else
			U_MsgColetor("Registro do XD2 não encontrado no XD1")
		EndIf
		
	Next _nX
	
	ASORT(aItemXD2,2,,{ |x, y| x[1] < y[1] })
	
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
	XD1->XD1_QTDORI    := nQtdEtq
	XD1->XD1_QTDATU    := nQtdEtq
	XD1->XD1_EMBALA    := ""
	XD1->XD1_QTDEMB    := nQtdEtq
	XD1->XD1_NIVEMB    := "P"
    XD1->XD1_ULTNIV    := "S"
	If !Empty(SC2->C2_PEDIDO)
		XD1->XD1_PVSEP     := SC5->C5_NUM
	EndIf
	XD1->XD1_PESOB    := nPesoVol
	XD1->XD1_VOLUME   := cVolumeAtu
   	XD1->XD1_SERIAL   := cNumSerie
	XD1->( MsUnlock() )
	
	//Imprime o formulario da etiqueta
	fFormEtq()

	nPointer := 0
	For y := 1 to Len(aItemXD2) 

		//Se atingiu limite de linha da etiqueta imprime novo formulario
	   nPointer++
	   If nPointer > 38
			MSCBEND()
			Sleep(500)
			fFormEtq()
			nPointer:=1
      EndIf

		If nPointer == 1
			nCol := 6
			nIni := nIniXD2
		EndIf
		If nPointer == 20
			nCol := 60
			nIni := nIniXD2
		EndIf
		
		MSCBSAY(nCol+1 ,nIni ,StrZero(Y,3)                          ,cRotacao,"0","26,26")
		MSCBSAY(nCol+10,nIni ,aItemXD2[Y,1]                         ,cRotacao,"0","26,26")
		MSCBSAY(nCol+42,nIni ,TransForm(aItemXD2[Y,2],"@E 99,999")  ,cRotacao,"0","26,26")
		
		nIni += 3

	Next y
	
	If Type("cDomEtDl31_CancEtq") <> "U"
		cDomEtDl31_CancEtq := XD1->XD1_XXPECA
	EndIf
	
	MSCBInfoEti("DOMEX","80X60")
	
	//Finaliza impressão da etiqueta
	MSCBEND()
	Sleep(500)
	
	MSCBCLOSEPRINTER()
	
EndIf

Return(.T.)

Static Function fFormEtq()	

	//Inicia impressão da etiqueta

	MSCBBEGIN(1,5)
	
	nColV := 40
	nCol  := 06
	nIni  := 15
	nLin  := 07
	
	//Contorno/Borda
	MSCBBOX(03,05,115,88,3,"B")
	//Grade de Itens
	MSCBBOX(05,20,113,86,3,"B")
	//Grade do Cabeçalho dos Itens
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
	
	MSCBSAYBAR(75  ,07      ,U_fTratTxt(XD1->XD1_XXPECA)                                       ,cRotacao,"MB04",7.361,.F.,.T.,.F.,,3,2,.F.,.F.,"1",.T.)
	MSCBSAY(nColV  ,nLin    ,"PEDIDO:    " + Subs(XD1->XD1_PVSEP,1,6)                          ,cRotacao,"0","26,26")
	MSCBSAY(nColV  ,nLin+4  ,"PALETE:    " + Alltrim(XD1->XD1_VOLUME)                          ,cRotacao,"0","26,26")
	MSCBSAY(nColV  ,nLin+8  ,"PAIS: " + Alltrim(cPaisDest)												 ,cRotacao,"0","26,26")
	
	MSCBSAY(nCol   ,nIni+7  ," SEQ"                                                            ,cRotacao,"0","26,26")
	MSCBSAY(nCol+10,nIni+7  ,U_fTratTxt("ETIQUETA VOLUME")                                     ,cRotacao,"0","26,26")
	MSCBSAY(nCol+42,nIni+7  ,U_fTratTxt("QTDE")                                                ,cRotacao,"0","26,26")
	nCol += 54
	
	MSCBSAY(nCol   ,nIni+7  ," SEQ"                                                             ,cRotacao,"0","26,26")
	MSCBSAY(nCol+10,nIni+7  ,U_fTratTxt("ETIQUETA VOLUME")                                     ,cRotacao,"0","26,26")
	MSCBSAY(nCol+42,nIni+7  ,U_fTratTxt("QTDE")                                                ,cRotacao,"0","26,26")
	
	nIni    += 13
	nIniXD2 := nIni

Return

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
