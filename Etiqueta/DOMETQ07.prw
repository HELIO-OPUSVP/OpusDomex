#include "protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DOMETQ07 ºAutor  ³ Michel A. Sander   º Data ³  08/05/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Etiqueta Modelo 05                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMETQ07(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,lColetor,cNumSerie,cNumPeca)

Local cModelo    := "Z4M"
Local cPorta     := "LPT1"

Local lPrinOK    := MSCBModelo("ZPL",cModelo)

Local aPar       := {}
Local aRet       := {}
Local nVar       := 0

Local cRotacao   := "N"      //(N,R,I,B)

Local mv_par02   := 1         //Qtd Embalagem
Local MVPAR03   := 1         //Qtd Etiquetas

Local aRetAnat   := {}        //Codigos Anatel, Array
Local aCodAnat   := {}        //Codigos Anatel, Array
Local cCdAnat1   := ""        //Codigo Anatel 1
Local cCdAnat2   := ""        //Codigo Anatel 2

Private lAchou   := .T.
Private aGrpAnat := {}     //Codigos Anatel Agrupados

Default cNumOP   := ""
Default cNumSenf := ""
Default nQtdEmb  := 0
Default nQtdEtq  := 0
Default cNivel   := ""
Default aFilhas  := {}
Default cNumSerie := ""
Default cNumPeca  := ""

MVPAR02:= nQtdEmb   //Qtd Embalagem
MVPAR03:= nQtdEtq   //Qtd Etiquetas

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
If !Empty(SC2->C2_PEDIDO)
	SA1->(DbSetOrder(1))
	If lAchou .And. SA1->(!DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
		Alert("Cliente "+SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI+" não localizado!")
		lAchou := .F.
	EndIf
EndIf

//Localiza SB1
SB1->(DbSetOrder(1))
If lAchou .And. SB1->(!DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
	Alert("Produto "+AllTrim(SC2->C2_PRODUTO)+" não localizado!")
	lAchou := .F.
EndIf

//
If lAchou
	aRetAnat := U_fCodNat(SB1->B1_COD)
	lAchou   := aRetAnat[1]
	aCodAnat := aRetAnat[2]
	
	If lAchou .And. Empty(SB1->B1_XXNANAT)
		Alert("Não foi preenchido o campo 'Nº Codigo Anatel' para o produto: "+AllTrim(SB1->B1_COD) + Chr(13)+Chr(10)+ "[B1_XXNANAT]")
		lAchou := .F.
	EndIf
	
EndIf

If lAchou
	//Agrupando Codigos Anatel
	For x:=1 To Len(aCodAnat)
		nVar := aScan(aGrpAnat,aCodAnat[x])
		If nVar == 0
			aAdd(aGrpAnat,aCodAnat[x])
		EndIf
	Next x
	
	Do Case
		Case Val(SB1->B1_XXNANAT) == 0 .And. Len(aGrpAnat) == 0
			cCdAnat1 := ""
			cCdAnat2 := ""
			
		Case Val(SB1->B1_XXNANAT) == 1 .And. Len(aGrpAnat) == 1
			cCdAnat1 := aGrpAnat[1]
			cCdAnat2 := ""
			
		Case Val(SB1->B1_XXNANAT) == 2 .And. Len(aGrpAnat) == 1
			cCdAnat1 := aGrpAnat[1]
			cCdAnat2 := aGrpAnat[1]
			
		Case Val(SB1->B1_XXNANAT) == 3 .And. Len(aGrpAnat) == 2
			cCdAnat1 := aGrpAnat[1]
			cCdAnat2 := aGrpAnat[2]
			
		OtherWise
			cCdAnat1 := " E R R O "
			cCdAnat2 := " E R R O "
			If !Empty(cNumOP)
				Alert("Erro no tratamento dos codigos ANATEL (DOMETQ07)."+Chr(13)+Chr(10)+"Favor procurar TI e informar dificuldade! "+Chr(13)+Chr(10)+"OP:"+cNumOP)
			ElseIf !Empty(cNumSenf)
				Alert("Erro no tratamento dos codigos ANATEL (DOMETQ07)."+Chr(13)+Chr(10)+"Favor procurar TI e informar dificuldade! "+Chr(13)+Chr(10)+"Senf:"+cNumSenf)
			EndIf
			lAchou   := .F.
			
	EndCase
	
EndIf

//Valida se Campo Descricao do Produto está preenchido
If lAchou .And. Empty(SB1->B1_DESC)
	Alert("Campo Descricao do Produto não está preenchido no cadastro do produto! "+Chr(13)+Chr(10)+"[B1_DESC]")
	lAchou := .F.
EndIf

//Valida se Campo PN HUAWEI está preenchido
If !Empty(SC2->C2_PEDIDO)
	If lAchou .And. Empty(SC6->C6_SEUCOD)
		Alert("Campo PN não está preenchido no Item do Pedido de Vendas! "+Chr(13)+Chr(10)+"[C6_SEUCOD]")
		lAchou := .F.
	EndIf
EndIf

//Em 25/02/2014 foi definido que esse campo não será obrigatorio para esta etiqueta
//Valida se Campo PN HUAWEI está preenchido
//If lAchou .And. Empty(SC6->C6_SEUDES)
//	Alert("Campo ITEM PEDIDO CLIENTE não está preenchido no Item do Pedido de Vendas! "+Chr(13)+Chr(10)+"[C6_SEUDES]")
//	lAchou := .F.
//EndIf

//Valida se Campo PEDIDO CLIENTE está preenchido
If !Empty(SC2->C2_PEDIDO)
	If lAchou .And. Empty(SC5->C5_ESP1)
		Alert("Campo PEDIDO CLIENTE não está preenchido no Cabeçalho do Pedido de Vendas! "+Chr(13)+Chr(10)+"[C5_ESP1]")
		lAchou := .F.
	EndIf
EndIf

//Caso algum registro não seja localizado, sair da rotina
If !lAchou
	Return(.T.)
EndIf

//Se impressora não identificada, sair da rotina
If !lPrinOK
	Alert("Erro de configuração!")
	Return(.T.)
EndIf

// Verifica nivel da embalagem
If cNivel < "3"		// Nivel 3 não contem na estrutura
	aRetEmbala := U_RetEmbala(SB1->B1_COD,cNivel)
	If !aRetEmbala[4]
		Alert("Emissão de etiqueta não permitida por falta de nivel da embalagem na estrutura.")
		Return(.F.)
	EndIf
EndIf

If lImpressao
	
	//Chamando função da impressora ZEBRA
	MSCBPRINTER(cModelo,cPorta,,,.F.)
	MSCBChkStatus(.F.)
	MSCBLOADGRF("RDT2.GRF")
	MSCBLOADGRF("ANATEL2.GRF")
	MSCBLOADGRF("ROHS.GRF")
	
	//Controla o numero da etiqueta de embalagens
	If Empty(cNumPeca)
		_cProxPeca := U_IXD1PECA()
	Else
		_cProxPeca := cNumPeca
	EndIf
	
	For _nX := 1 to Len(aFilhas)
		Reclock("XD2",.T.)
		XD2->XD2_FILIAL := xFilial("XD2")
		XD2->XD2_XXPECA := _cProxPeca
		XD2->XD2_PCFILH := aFilhas[_nX]
		XD2->( msUnlock() )
	Next _nX
	
	For __nEtq :=1 To MVPAR03
	
		Reclock("XD1",.T.)
		XD1->XD1_FILIAL  := xFilial("XD1")
		XD1->XD1_XXPECA  := _cProxPeca
		XD1->XD1_FORNEC  := Space(06)
		XD1->XD1_LOJA    := Space(02)
		XD1->XD1_DOC     := Space(06)
		XD1->XD1_SERIE   := Space(03)
		XD1->XD1_ITEM    := ""
		XD1->XD1_COD     := SB1->B1_COD
		XD1->XD1_LOCAL   := SB1->B1_LOCPAD
		XD1->XD1_TIPO    := SB1->B1_TIPO
		XD1->XD1_LOTECT  := U_RetLotC6(cNumOP)
		XD1->XD1_DTDIGI  := dDataBase
		XD1->XD1_FORMUL  := ""
		XD1->XD1_LOCALI  := ""
		XD1->XD1_USERID  := __cUserId
		XD1->XD1_OCORRE  := "6"
		XD1->XD1_OP      := cNumOP
		XD1->XD1_PV      := cNumSenf
		XD1->XD1_PESOB   := nPesoVol
		XD1->XD1_QTDORI  := nQtdEmb
		XD1->XD1_QTDATU  := nQtdEmb
		
		aRetEmbala := U_RetEmbala(XD1->XD1_COD,cNivel)
		XD1->XD1_EMBALA  := aRetEmbala[1]
		XD1->XD1_QTDEMB  := aRetEmbala[2]
		XD1->XD1_NIVEMB  := If(AllTrim(cNivel)=="3",cNivel,aRetEmbala[3]) // 3 = Nivel 3 (Volumes parar expedição não constam na estrutura)
		If !Empty(SC2->C2_PEDIDO)
			XD1->XD1_PVSEP   := If(AllTrim(cNivel)=="3",SC5->C5_NUM,"")
		EndIf
		XD1->XD1_SERIAL := cNumSerie
		XD1->( MsUnlock() )
		
		// Armazenando informacoes para um possivel cancelamento da etiqueta por falha na impressao
		If Type("cDomEtDl31_CancEtq") <> "U"
			cDomEtDl31_CancEtq := XD1->XD1_XXPECA
			cDomEtDl32_CancOP  := cNumOP
			cDomEtDl33_CancEmb := cNumSenf
			cDomEtDl34_CancKit := nQtdEmb
			cDomEtDl35_CancUni := nQtdEtq
			cDomEtDl38_CancNiv := cNivel
			aDomEtDl3A_CancFil := aFilhas
			cDomEtDl39_CancPes := nPesoVol
		EndIf
		
		
		//Inicia impressão da etiqueta
		MSCBBEGIN(1,5)
		
		nCol := 05
		nIni := 07
		nLin := 04
		
		//Contorno/Borda
		MSCBBOX(03,05,115,88,3,"B")
		
		//Logos
		MSCBGRAFIC(10,10,"RDT2")
		MSCBGRAFIC(20,10,"ROHS")
		
		/*01*/MSCBSAYBAR(105  ,nIni+(nLin*09)  ,U_fTratTxt(XD1->XD1_XXPECA)                                                               ,"R","MB04",8.361,.F.,.T.,.F.,,3,2,.F.,.F.,"1",.T.)
		
		/*01*/   MSCBSAY(045,nIni+(nLin*05.5)   ,StrZero(MVPAR02,4)+" Unit(s)"                                                             ,cRotacao,"0","40,50")
		/*01*/   MSCBSAY(054,nIni+(nLin*00)   ,"Rosenberger Domex Telecom S/A"                                                            ,cRotacao,"0","30,30")
		/*01*/   MSCBSAY(054,nIni+(nLin*01)   ,"Cabletech Av., 601 - Guamirim"                                                            ,cRotacao,"0","30,30")
		/*01*/   MSCBSAY(054,nIni+(nLin*02)   ,"Zip Code: 12.295-230 - Cacapava/SP"                                                       ,cRotacao,"0","30,30")
		/*01*/   MSCBSAY(054,nIni+(nLin*03)   ,"Phone: +55 12 3221-8500" 				                                                       ,cRotacao,"0","30,30")
		/*01*/   MSCBSAY(054,nIni+(nLin*04)   ,"www.rdt.com.br" 							                                                       ,cRotacao,"0","30,30")
		/*01*/   MSCBSAY(nCol,nIni+(nLin*07)   ,"Product: "+SUBSTR(U_fTratTxt(SB1->B1_DESC),1,30)                                         ,cRotacao,"0","28,28")
		/*01*/   MSCBSAY(nCol,nIni+(nLin*08)   ,"         "+SUBSTR(U_fTratTxt(SB1->B1_DESC),31,30)   				                         ,cRotacao,"0","28,28")
		/*01*/   MSCBSAY(nCol,nIni+(nLin*09)   ,"PN RDT: "+U_fTratTxt(SB1->B1_COD)                                                        ,cRotacao,"0","30,30")
		/*01*/   MSCBSAY(nCol,nIni+(nLin*10)   ,"W/Y: "+U_fSemaAno()+"/"+SubStr(StrZero(Year(Date()),4),3,2)                              ,cRotacao,"0","30,30")
		If !Empty(SC2->C2_PEDIDO)
			/*01*/   MSCBSAY(nCol,nIni+(nLin*11)   ,"CUSTOMER PN: "+U_fTratTxt(SC6->C6_SEUCOD)  						                             ,cRotacao,"0","30,30")
		EndIf
		/*01*/   //MSCBSAY(nCol,nIni+(nLin*14)   ,"TESTES:"                                                                                 ,cRotacao,"0","30,30")
		/*01*/   //MSCBSAY(nCol,nIni+(nLin*15)   ,"SM - IL<0.30dB   RL:>45dB (PC)   >55dB (APC)"                                            ,cRotacao,"0","30,30")
		/*01*/   //MSCBSAY(nCol,nIni+(nLin*16)   ,"MM - IL<0.30dB   RL:>30dB (PC)"                                                          ,cRotacao,"0","30,30")
		
		If !Empty(cCdAnat1)
			/*01*/MSCBSAYBAR(nCol,nIni+(nLin*12.5)-2 ,U_fTratTxt(cCdAnat1)                                                                      ,cRotacao,"MB07",8.361,.F.,.F.,.F.,,3,2,.F.,.F.,"1",.T.)
			/*01*/   MSCBSAY(nCol,nIni+(nLin*12.5)+7 ,U_fTratTxt(cCdAnat1)                                                                      ,cRotacao,"0","30,40")
		EndIf
		
		If !Empty(cCdAnat2)
			/*01*/MSCBSAYBAR(nCol,nIni+(nLin*15)+2 ,U_fTratTxt(cCdAnat2)                                                                      ,cRotacao,"MB07",8.361,.F.,.F.,.F.,,3,2,.F.,.F.,"1",.T.)
			/*01*/   MSCBSAY(nCol,nIni+(nLin*15)+11,U_fTratTxt(cCdAnat2)                                                                      ,cRotacao,"0","30,40")
		EndIf
		
  		If !Empty(SC6->C6_XXSITE)
			MSCBSAY(nCol+90,nIni+(nLin*15), "SITE     : " + SC6->C6_XXSITE							                                           ,cRotacao,"0","30,30")
   	EndIf

		/*01*/   MSCBSAY(nCol,nIni+(nLin*19)   ,"MADE IN BRAZIL"                                                                          ,cRotacao,"0","30,30")
		/*01*/   MSCBSAY(nCol+90,nIni+(nLin*19),"Layout 005"                                                                              ,cRotacao,"0","30,30")
		
		MSCBInfoEti("DOMEX","80X60")
		
		//Finaliza impressão da etiqueta
		MSCBEND()
		Sleep(500)
		
	Next __nEtq
	
	MSCBCLOSEPRINTER()
	
EndIf

Return(.T.)
