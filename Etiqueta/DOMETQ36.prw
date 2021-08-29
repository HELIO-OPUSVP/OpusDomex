#include "protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DOMETQ36 ºAutor  ³ Michel A. Sander   º Data ³  25.03.15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Etiqueta de exportação modelo 36                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMETQ36(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,lColetor,cNumSerie,cNumPeca)

Local cModelo    := "Z4M"
Local cPorta     := "LPT1"

Local lPrinOK    := MSCBModelo("ZPL",cModelo)

Local aPar       := {}
Local aRet       := {}
Local nVar       := 0

Local cRotacao   := "N"      //(N,R,I,B)

Local mv_par02   := 1         //Qtd Embalagem
Local mv_par03   := 1         //Qtd Etiquetas

Local aRetAnat   := {}        //Codigos Anatel, Array
Local aCodAnat   := {}        //Codigos Anatel, Array
Local cCdAnat1   := ""        //Codigo Anatel 1
Local cCdAnat2   := ""        //Codigo Anatel 2
Local cCdAnat3   := ""        //Codigo Anatel 3

Private lAchou   := .T.
Private aGrpAnat := {}     //Codigos Anatel Agrupados
Private lCrystal := .F.

Default cNumOP   := ""
Default cNumSenf := ""
Default nQtdEmb  := 0
Default nQtdEtq  := 0
Default cNivel   := ""
Default cNumSerie := "1"
Default cNumPeca  := ""

mv_par02:= nQtdEmb   //Qtd Embalagem
mv_par03:= nQtdEtq   //Qtd Etiquetas

If !Empty(cNumOP)
	//Localiza SC2
	SC2->(DbSetOrder(1))
	If lAchou .And. SC2->(!DbSeek(xFilial("SC2")+cNumOP))
		Alert("Numero O.P. "+AllTrim(cNumOP)+" não localizada!")
		lAchou := .F.
	EndIf
	
	//Localiza SB1
	SB1->(DbSetOrder(1))
	If lAchou .And. SB1->(!DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
		Alert("Produto "+AllTrim(SC2->C2_PRODUTO)+" não localizado!")
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
	
	//Localiza SB1
	SB1->(DbSetOrder(1))
	If lAchou .And. SB1->(!DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
		Alert("Produto "+AllTrim(SC6->C6_PRODUTO)+" não localizado!")
		lAchou := .F.
	EndIf

EndIf
                       
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta o número de série										   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
cSerieFim := If( cNumSerie=="1" .Or. Empty(cNumSerie), 1, Val(cNumSerie) )

If SC2->C2_QUANT <=9
	cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,1)	// MV_PAR07 Sequencial Serial
ElseIf SC2->C2_QUANT >=10 .And.  SC2->C2_QUANT <= 99
	cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,2)	// MV_PAR07 Sequencial Serial
ElseIf SC2->C2_QUANT >=100 .And. SC2->C2_QUANT <= 999
	cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,3)	// MV_PAR07 Sequencial Serial
ElseIf SC2->C2_QUANT >=1000 .And. SC2->C2_QUANT <= 9999
	cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,4)	// MV_PAR07 Sequencial Serial
ElseIf SC2->C2_QUANT >=10000 .And. SC2->C2_QUANT <= 99999
	cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,5)	// MV_PAR07 Sequencial Serial
Else
   cNumSerie:="1"
EndIf

//Localiza SA1
SA1->(DbSetOrder(1))
If lAchou .And. SA1->(!DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
	Alert("Cliente "+SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI+" não localizado!")
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
			cCdAnat3 := ""
			
		Case Val(SB1->B1_XXNANAT) == 1 .And. Len(aGrpAnat) == 1
			cCdAnat1 := aGrpAnat[1]
			cCdAnat2 := ""
			cCdAnat3 := ""
			
		Case Val(SB1->B1_XXNANAT) == 2 .And. Len(aGrpAnat) == 1
			cCdAnat1 := aGrpAnat[1]
			cCdAnat2 := aGrpAnat[1]
			cCdAnat3 := ""
			
		Case Val(SB1->B1_XXNANAT) == 3 .And. Len(aGrpAnat) == 2
			cCdAnat1 := aGrpAnat[1]
			cCdAnat2 := aGrpAnat[2]
			cCdAnat3 := ""
			
		Case Val(SB1->B1_XXNANAT) == 4 .And. Len(aGrpAnat) == 3
			cCdAnat1 := aGrpAnat[1]
			cCdAnat2 := aGrpAnat[2]
			cCdAnat3 := aGrpAnat[3]
			
		OtherWise
			cCdAnat1 := " E R R O "
			cCdAnat2 := " E R R O "
			If !Empty(cNumOP)
				Alert("Erro no tratamento dos codigos ANATEL (DOMETQ03)."+Chr(13)+Chr(10)+"Favor procurar TI e informar dificuldade! "+Chr(13)+Chr(10)+"OP:"+cNumOP)
			ElseIf !Empty(cNumSenf)
				Alert("Erro no tratamento dos codigos ANATEL (DOMETQ03)."+Chr(13)+Chr(10)+"Favor procurar TI e informar dificuldade! "+Chr(13)+Chr(10)+"Senf:"+cNumSenf)
			Else
				Alert("Erro (Indefinido) no tratamento dos codigos ANATEL (DOMETQ03)."+Chr(13)+Chr(10)+"Favor procurar TI e informar dificuldade! "+Chr(13)+Chr(10))			
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

//Valida se Campo PEDIDO CLIENTE está preenchido
If !Empty(SC2->C2_PEDIDO)
	If lAchou .And. Empty(SC5->C5_ESP1)
		Alert("Campo PEDIDO CLIENTE não está preenchido no Cabeçalho do Pedido de Vendas! "+Chr(13)+Chr(10)+"[C5_ESP1]")
		lAchou := .F.
	EndIf
EndIf

// Verifica se DIO pertence a classe MTP para impressão de layout com DATAMATRIX
If AllTrim(SB1->B1_SUBCLAS)=="MTP"
   lCrystal := .T.
Else
   lCrystal := .F.
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
	
   If !lCrystal

		If lColetor
			If SUBSTR(SB1->B1_GRUPO,1,3) == "DIO"
				cPorta := "LPT3"
			EndIf
		EndIf
		
		//Chamando função da impressora ZEBRA
		MSCBPRINTER(cModelo,cPorta,,,.F.)
		MSCBChkStatus(.F.)
		MSCBLOADGRF("RDT2.GRF")
		//MSCBLOADGRF("ANATEL2.GRF")
		MSCBLOADGRF("ROHS.GRF")

	EndIf
	
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
		If ValType(aFilhas[1]) == "A"
			XD2->XD2_PCFILH := aFilhas[_nX,1]
		Else
			XD2->XD2_PCFILH := aFilhas[_nX]
		EndIf
		XD2->( msUnlock() )
	Next _nX
	
	For __nEtq := 1 To mv_par03
		
		If __nEtq > 1
   		_cProxPeca := U_IXD1PECA()
		EndIf
		
		aRetEmbala      := U_RetEmbala(SB1->B1_COD,cNivel)
		
		Reclock("XD1",.T.)
		XD1->XD1_FILIAL  := xFilial("XD1")
		// Substituido por Michel Sander em 28.08.2014 para gravar o documento a partir do programa IXD1PECA()
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
		XD1->XD1_NIVEMB  := If(AllTrim(cNivel)=="3",cNivel,aRetEmbala[3])
		
		If !Empty(SC2->C2_PEDIDO)
			XD1->XD1_PVSEP  := If(AllTrim(cNivel)=="3",SC5->C5_NUM,"")
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
		
		If lCrystal
		
		   cMVPAR01 := U_fTratTxt(XD1->XD1_XXPECA)
		   cMVPAR02 := StrZero(mv_par02,4)+" Unit(s)"
		   cMVPAR03 := "Product: "+SUBSTR(U_fTratTxt(SB1->B1_DESC),1,30)
		   cMVPAR04 := SUBSTR(U_fTratTxt(SB1->B1_DESC),31,30)
		   cMVPAR05 := "PN RDT: "+U_fTratTxt(SB1->B1_COD)
		   cMVPAR06 := "W/Y: "+U_fSemaAno()+"/"+SubStr(StrZero(Year(Date()),4),3,2)

			If !Empty(SC2->C2_PEDIDO)
			   cMVPAR07 := "CUSTOMER PN: "+U_fTratTxt(SC6->C6_SEUCOD)
			   cMVPAR08 := "PO: "+AllTrim(SC5->C5_ESP1)
			   cMVPAR09 := "PO ITEM: "+AllTrim(SC6->C6_SEUDES)
			Else
			   cMVPAR07 := SPACE(1)
			   cMVPAR08 := SPACE(1)
			   cMVPAR09 := SPACE(1)
			EndIf
                 
			cMVPAR10 := cNumSerie
			cMVPAR11 := "SN: "+cNumSerie
			
			cParam   := cMVPAR01+";"+cMVPAR02+";"+cMVPAR03+";"+cMVPAR04+";"+cMVPAR05+";"+cMVPAR06+";"+cMVPAR07+";"+cMVPAR08+";"+cMVPAR09+";"+cMVPAR10+";"+cMVPAR11+";"

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
			//³Parâmetros de impressão do Crystal Reports		 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
			cOptions := "2;0;1;Layout036"			// Parametro 1 (2= Impressora 1=Visualiza)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
			//³Executa Crystal Reports para impressão			 	 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
			CALLCRYS('Layout036', cParam ,cOptions)
			Sleep(1100)

		Else
			
			//Inicia impressão da etiqueta
			MSCBBEGIN(1,5)
			
			nCol := 05
			nIni := 07
			nLin := 04
			
			//Contorno/Borda
			MSCBBOX(03,05,115,88,3,"B")
			
			//Logos
			MSCBGRAFIC(10,10,"RDT2")
			MSCBGRAFIC(15,20,"ROHS")
			
			/*01*/MSCBSAYBAR(105  ,nIni+(nLin*09)  ,U_fTratTxt(XD1->XD1_XXPECA)                                                               ,"R","MB04",8.361,.F.,.T.,.F.,,3,2,.F.,.F.,"1",.T.)
			
			/*01*/   MSCBSAY(045,nIni+(nLin*05.5)   ,StrZero(mv_par02,4)+" Unit(s)"                                                           ,cRotacao,"0","40,50")
			/*01*/   MSCBSAY(054,nIni+(nLin*00)   ,"Rosenberger Domex Telecom S/A"                                                            ,cRotacao,"0","30,30")
			/*01*/   MSCBSAY(054,nIni+(nLin*01)   ,"Cabletech Av., 601 - Guamirim"                                                            ,cRotacao,"0","30,30")
			/*01*/   MSCBSAY(054,nIni+(nLin*02)   ,"Zip Code: 12.295-230 - Cacapava/SP"                                                       ,cRotacao,"0","30,30")
			/*01*/   MSCBSAY(054,nIni+(nLin*03)   ,"Phone: +55 12 3221-8500" 				                                                       ,cRotacao,"0","30,30")
			/*01*/   MSCBSAY(054,nIni+(nLin*04)   ,"www.rdt.com.br" 							                                                       ,cRotacao,"0","30,30")
			/*01*/   MSCBSAY(nCol,nIni+(nLin*07)   ,"Product: "+SUBSTR(U_fTratTxt(SB1->B1_DESC),1,30)                                         ,cRotacao,"0","28,28")
			/*01*/   MSCBSAY(nCol,nIni+(nLin*08)   ,SUBSTR(U_fTratTxt(SB1->B1_DESC),31,30)				   				                         ,cRotacao,"0","28,28")
			/*01*/   MSCBSAY(nCol,nIni+(nLin*09)   ,"PN RDT: "+U_fTratTxt(SB1->B1_COD)                                                        ,cRotacao,"0","30,30")
			/*01*/   MSCBSAY(nCol,nIni+(nLin*10)   ,"W/Y: "+U_fSemaAno()+"/"+SubStr(StrZero(Year(Date()),4),3,2)                              ,cRotacao,"0","30,30")
			If !Empty(SC2->C2_PEDIDO)
			   /*01*/   MSCBSAY(nCol,nIni+(nLin*11)   ,"CUSTOMER PN: "+U_fTratTxt(SC6->C6_SEUCOD)  						                             ,cRotacao,"0","30,30")
				/*01*/   MSCBSAY(nCol,nIni+(nLin*12)   ,"PO: "+SC5->C5_ESP1									  						                             ,cRotacao,"0","30,30")
				/*01*/   MSCBSAY(nCol,nIni+(nLin*13)   ,"PO ITEM: "+SC6->C6_SEUDES						  						                             ,cRotacao,"0","30,30")
			EndIf
			/*01*/   MSCBSAY(nCol,nIni+(nLin*19)   ,"MADE IN BRAZIL"                                                                          ,cRotacao,"0","30,30")
			/*01*/   MSCBSAY(nCol+90,nIni+(nLin*19),"Layout 036"                                                                              ,cRotacao,"0","30,30")
			
			MSCBInfoEti("DOMEX","80X60")
			
			//Finaliza impressão da etiqueta
			MSCBEND()
			Sleep(500)
		
		EndIf

		cNumSerie := Soma1(cNumSerie)
					
	Next x
	
   If !lCrystal
		MSCBCLOSEPRINTER()
	EndIf
	
EndIf

Return(.T.)