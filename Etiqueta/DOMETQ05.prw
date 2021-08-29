#include "protheus.ch"
#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DOMETQ05 �Autor  � Felipe A. Melo     � Data �  25/02/2014 ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function DOMETQ05(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,lColetor,cNumSerie,cNumPeca)

Local cModelo     := "Z4M"
Local cPorta      := "LPT1"

Local lPrinOK     := MSCBModelo("ZPL",cModelo)

Local aPar        := {}
Local aRet        := {}
Local nVar        := 0

Local cRotacao    := "N"      //(N,R,I,B)

Local mv_par02    := 1         //Qtd Embalagem
Local mv_par03    := 1         //Qtd Etiquetas

Local aRetAnat    := {}        //Codigos Anatel, Array
Local aCodAnat    := {}        //Codigos Anatel, Array
Local cCdAnat1    := ""        //Codigo Anatel 1
Local cCdAnat2    := ""        //Codigo Anatel 2

Private lAchou    := .T.
Private aGrpAnat  := {}     //Codigos Anatel Agrupados

Default cNumOP    := ""
Default cNumSenf  := ""
Default nQtdEmb   := 0
Default nQtdEtq   := 0
Default cNivel    := ""
Default cNumSerie := ""
Default cNumPeca  := ""

mv_par02:= nQtdEmb   //Qtd Embalagem
mv_par03:= nQtdEtq   //Qtd Etiquetas

cProdFilho := ""
If !Empty(cNumOP)
	//Localiza SC2
	SC2->(DbSetOrder(1))
	If lAchou .And. SC2->(!DbSeek(xFilial("SC2")+cNumOP))
		Alert("Numero O.P. "+AllTrim(cNumOP)+" n�o localizada!")
		lAchou := .F.
	EndIf
	
	// Inserido por Michel A. Sander em 08.05.2014 para tratar numero de pedidos pelas OPs Filhas
	cSC2Recno := SC2->(Recno())
	__cPedido := ""
	__cItem   := ""
	If ALLTRIM(SC2->C2_SEQUEN) == "001"
		__cPedido  := SC2->C2_PEDIDO
		__cItem    := SC2->C2_ITEMPV
		cProdFilho := SC2->C2_PRODUTO
	Else
		SC2->(dbSeek(xFilial("SC2")+SUBSTR(cNumOP,1,8)+'001'))
		__cPedido := SC2->C2_PEDIDO
		__cItem   := SC2->C2_ITEMPV
		// Alterado Por Michel A. Sander em 15/05/2014
		// Busca Descri��o da OP Filha para impress�o na etiqueta
		SC2->(dbSeek(xFilial("SC2")+SUBSTR(cNumOP,1,8)+SUBSTR(cNumOp,9,3)))
		cProdFilho := SC2->C2_PRODUTO
		SC2->(dbGoto(cSC2Recno))
	EndIf
	
	//Localiza SC5
	If !Empty(SC2->C2_PEDIDO)
		SC5->(DbSetOrder(1))
		If lAchou .And. SC5->(!DbSeek(xFilial("SC5")+__cPedido))
			Alert("Numero de Senf "+AllTrim(__cPedido)+" n�o localizado!")
			lAchou := .F.
		EndIf
		
		//Localiza SC6
		SC6->(DbSetOrder(1))
		If lAchou .And. SC6->(!DbSeek(xFilial("SC6")+__cPedido+__cItem))
			Alert("Item Senf "+AllTrim(__cItem)+" n�o localizado!")
			lAchou := .F.
		EndIf
	EndIf
EndIf

If !Empty(cNumSenf)
	//Localiza SC5
	SC5->(DbSetOrder(1))
	If lAchou .And. SC5->(!DbSeek(xFilial("SC5")+Subs(cNumSenf,1,6) ))
		Alert("Numero de Senf "+Subs(cNumSenf,1,6)+" n�o localizado!")
		lAchou := .F.
	EndIf
	
	//Localiza SC6
	SC6->(DbSetOrder(1))
	If lAchou .And. SC6->(!DbSeek(xFilial("SC6")+Subs(cNumSenf,1,8) ))
		Alert("Item Senf "+Subs(cNumSenf,7,2) +" n�o localizado!")
		lAchou := .F.
	EndIf
	
	cProdFilho := SC6->C6_PRODUTO
EndIf

//Localiza SA1
If !Empty(SC2->C2_PEDIDO)
	SA1->(DbSetOrder(1))
	If lAchou .And. SA1->(!DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
		Alert("Cliente "+SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI+" n�o localizado!")
		lAchou := .F.
	EndIf
EndIf

/*//Localiza SB1
SB1->(DbSetOrder(1))
If lAchou .And. SB1->(!DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
	Alert("Produto "+AllTrim(SC2->C2_PRODUTO)+" n�o localizado!")
	lAchou := .F.
EndIf
*/

//Localiza SB1
// Michel Sander em 12.01.2017 posicionar produto de acordo com OP ou SENF
If !Empty(cNumOp) .And. Empty(cNumSenf)
	SB1->(DbSetOrder(1))
	If lAchou .And. SB1->(!DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
		Alert("Produto "+AllTrim(SC2->C2_PRODUTO)+" n�o localizado!")
		lAchou := .F.
	EndIf
ElseIf !Empty(cNumSenf)
	SB1->(DbSetOrder(1))
	If lAchou .And. SB1->(!DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
		Alert("Produto "+AllTrim(SC6->C6_PRODUTO)+" n�o localizado!")
		lAchou := .F.
	EndIf
EndIf

//
If lAchou
	aRetAnat := U_fCodNat(SB1->B1_COD)
	lAchou   := aRetAnat[1]
	aCodAnat := aRetAnat[2]
	
	If lAchou .And. Empty(SB1->B1_XXNANAT)
		Alert("N�o foi preenchido o campo 'N� Codigo Anatel' para o produto: "+AllTrim(SB1->B1_COD) + Chr(13)+Chr(10)+ "[B1_XXNANAT]")
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
				Alert("Erro no tratamento dos codigos ANATEL (DOMETQ05)."+Chr(13)+Chr(10)+"Favor procurar TI e informar dificuldade! "+Chr(13)+Chr(10)+"OP:"+cNumOP)
			ElseIf !Empty(cNumSenf)
				Alert("Erro no tratamento dos codigos ANATEL (DOMETQ05)."+Chr(13)+Chr(10)+"Favor procurar TI e informar dificuldade! "+Chr(13)+Chr(10)+"Senf:"+cNumSenf)
			EndIf
			lAchou   := .F.
			
	EndCase
	
EndIf

If Empty(cNivel)
   Alert("N�vel de embalagem do produto vazio. "+Chr(13)+Chr(10)+"[G1_XXEMBNI Estrutura] ou [B1_XXNIVFT Produto]")
   lAchou := .F.
EndIf   
   
//Valida se Campo Descricao do Produto est� preenchido
If lAchou .And. Empty(SB1->B1_DESC)
	Alert("Campo Descricao do Produto n�o est� preenchido no cadastro do produto! "+Chr(13)+Chr(10)+"[B1_DESC]")
	lAchou := .F.
EndIf

//Valida se Campo PN HUAWEI est� preenchido
If !Empty(SC2->C2_PEDIDO)
	If lAchou .And. Empty(SC6->C6_SEUCOD)
		Alert("Campo PN n�o est� preenchido no Item do Pedido de Vendas! "+Chr(13)+Chr(10)+"[C6_SEUCOD]")
		lAchou := .F.
	EndIf
EndIf

//Valida se Campo PEDIDO CLIENTE est� preenchido
If !Empty(SC2->C2_PEDIDO)
	If lAchou .And. Empty(SC5->C5_ESP1)
		Alert("Campo PEDIDO CLIENTE n�o est� preenchido no Cabe�alho do Pedido de Vendas! "+Chr(13)+Chr(10)+"[C5_ESP1]")
		lAchou := .F.
	EndIf
EndIf

//Caso algum registro n�o seja localizado, sair da rotina
If !lAchou
	Return(.F.)
EndIf

//Se impressora n�o identificada, sair da rotina
If !lPrinOK
	Alert("Erro de configura��o!")
	Return(.F.)
EndIf

// Verifica nivel da embalagem
aRetEmbala := U_RetEmbala(SB1->B1_COD,cNivel)
If !aRetEmbala[4]
	Alert("Emiss�o de etiqueta n�o permitida por falta de nivel da embalagem na estrutura.")
	Return(.F.)
EndIf

If lColetor
	If AllTrim(SB1->B1_GRUPO) == "DIO"
		cPorta := "LPT3"
	EndIf
EndIf

If lImpressao
	
	//Chamando fun��o da impressora ZEBRA
	MSCBPRINTER(cModelo,cPorta,,,.F.)
	MSCBChkStatus(.F.)
	MSCBLOADGRF("RDT2.GRF")
	MSCBLOADGRF("ANATEL2.GRF")
	
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
	
	For x := 1 To mv_par03
	   If x > 1
			_cProxPeca := U_IXD1PECA()
   	EndIf
	
		aRetEmbala := U_RetEmbala(SB1->B1_COD,cNivel)
		
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
		XD1->XD1_EMBALA  := aRetEmbala[1]
		XD1->XD1_QTDEMB  := aRetEmbala[2]
		XD1->XD1_NIVEMB  := If(AllTrim(cNivel)=="3",cNivel,aRetEmbala[3]) // 3 = Nivel 3 (Volumes parar expedi��o n�o constam na estrutura)
		XD1->XD1_SERIAL  := cNumSerie
		
		If !Empty(SC2->C2_PEDIDO)
			XD1->XD1_PVSEP   := If(AllTrim(cNivel)=="3",SC5->C5_NUM,"")
		EndIf
		
		If AllTrim(SB1->B1_GRUPO) == "DIO" .and. XD1->XD1_NIVEMB == '2'
		   XD1->XD1_ULTNIV  := 'S'
		Else
		   XD1->XD1_ULTNIV  := 'N'
		EndIf
		
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
		
		//Inicia impress�o da etiqueta
		MSCBBEGIN(1,5)
		
		nCol := 05
		nIni := 07
		nLin := 04
		
		//Contorno/Borda
		MSCBBOX(03,05,115,88,3,"B")
		
		//Logos
		MSCBGRAFIC(10,10,"RDT2")
		MSCBGRAFIC(50,07,"ANATEL2")
		
		/*01*/   MSCBSAYBAR(75  ,07            ,U_fTratTxt(XD1->XD1_XXPECA)                                                                ,cRotacao,"MB04",7.361,.F.,.T.,.F.,,3,2,.F.,.F.,"1",.T.)
		
		/*01*/   MSCBSAY(045,nIni+(nLin*04)    ,StrZero(mv_par02,4)+" Unidade(s)"                                                          ,cRotacao,"0","40,50")
		
		SB1->(dbSeek(xFilial("SB1")+cProdFilho))
		/*01*/   MSCBSAY(nCol,nIni+(nLin*06)   ,U_fTratTxt(SB1->B1_DESC)                                                                  ,cRotacao,"0","28,28")
		/*01*/   MSCBSAY(nCol,nIni+(nLin*07)   ,"PN RDT: "+U_fTratTxt(SB1->B1_COD)                                                        ,cRotacao,"0","30,30")
		If !Empty(SC2->C2_PEDIDO)
			/*01*/   MSCBSAY(nCol,nIni+(nLin*08)   ,U_fTratTxt(SA1->A1_NREDUZ)+" - "+U_fTratTxt(SC6->C6_SEUCOD)                               ,cRotacao,"0","30,30")
			/*01*/   MSCBSAY(nCol,nIni+(nLin*09)   ,"PED.CLIENTE: "+U_fTratTxt(SC5->C5_ESP1)                                                  ,cRotacao,"0","30,30")
			/*01*/   MSCBSAY(nCol,nIni+(nLin*10)   ,"ITEM DO PEDIDO/CLIENTE: "+U_fTratTxt(SC6->C6_SEUDES)                                     ,cRotacao,"0","30,30")
		EndIf
		/*01*/   MSCBSAY(nCol+80,nIni+(nLin*11),"SEMANA: "+U_fSemaAno()+"/"+SubStr(StrZero(Year(Date()),4),3,2)                           ,cRotacao,"0","30,30")
		
		/*01*/   MSCBSAY(nCol,nIni+(nLin*14)   ,"TESTES:"                                                                                 ,cRotacao,"0","30,30")
		/*01*/   MSCBSAY(nCol,nIni+(nLin*15)   ,"SM - IL<0.30dB   RL:>45dB (PC)   >55dB (APC)"                                            ,cRotacao,"0","30,30")
		/*01*/   MSCBSAY(nCol,nIni+(nLin*16)   ,"SM PREMIUM - IL:<0.1dB   RL:>45dB (PC) >55dB (APC)"                                      ,cRotacao,"0","30,30")
		/*01*/   MSCBSAY(nCol,nIni+(nLin*17)   ,"MM - IL<0.30dB   RL:>30dB (PC)"                                                          ,cRotacao,"0","30,30")
		
      If !Empty(SC6->C6_XXSITE)
		/*01*/   MSCBSAY(nCol+90,nIni+(nLin*15)   ,"SITE : "+SC6->C6_XXSITE                                                                  ,cRotacao,"0","30,30")
		EndIf
		
		/*01*/   MSCBSAY(nCol,nIni+(nLin*19)   ,"INDUSTRIA BRASILEIRA"                                                                    ,cRotacao,"0","30,30")
		/*01*/   MSCBSAY(nCol+90,nIni+(nLin*19),"Layout 003"                                                                              ,cRotacao,"0","30,30")
		
		MSCBInfoEti("DOMEX","80X60")
		
		//Finaliza impress�o da etiqueta
		MSCBEND()
		Sleep(500)
	Next x
	
	MSCBCLOSEPRINTER()
	
EndIf

Return(.T.)
