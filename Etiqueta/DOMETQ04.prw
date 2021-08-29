#include "protheus.ch"                  
#include "rwmake.ch"

//DOMETQ01 + DOMETQ02 == DOMETQ04 == Layout 001

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DOMETQ04 ºAutor  ³ Felipe A. Melo     º Data ³  19/02/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DOMETQ04(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,lColetor,cNumSerie,cNumPeca)

Local cModelo   := "Z4M"
Local cPorta    := "LPT1"

Local lPrinOK   := MSCBModelo("ZPL",cModelo)

Local aPar := {}
Local aRet := {}
Local nVar := 0

Local cRotacao := "R" //(N,R,I,B)

Local MVPAR01:= Space(11) //Numero OP
Local MVPAR02:= 0         //Qtd Embalagem
Local MVPAR03:= 0         //Qtd Etiquetas

Local aRetAnat:= {}        //Codigos Anatel, Array
Local aCodAnat:= {}        //Codigos Anatel, Array
Local cCdAnat1:= ""        //Codigo Anatel 1
Local cCdAnat2:= ""        //Codigo Anatel 2
Private lHuawei  := .f.
Private lAchou   := .T.
Private aGrpAnat := {}        //Codigos Anatel Agrupados

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


//			ZA1->( dbSetOrder(2) )
//			If ZA1->( dbSeek(xFilial()+SB1->B1_GRUPO+SB1->B1_SUBCLAS) )

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

If  ("HUAWEI" $ Upper(SA1->A1_NOME)) .OR.  ("FOXCONN" $ Upper(SA1->A1_NOME))  
	lHuawei := .t.
EndIf    

//Valida se Cliente é HUAWEI
If lAchou .and. !lHuawei
	Alert("Não é cliente HUAWEI!")
	lAchou := .F.
EndIf

//Localiza SB1
SB1->(DbSetOrder(1))
If lAchou .And. SB1->(!DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
	Alert("Produto "+AllTrim(SC2->C2_PRODUTO)+" não localizado!")
	lAchou := .F.
EndIf
//MAURICIO TEMPORARIO força posicionamento no sb1 não estava posicionando produto Revenda sem OP
SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))  //<--------------------------------------------------------
//
//
If lAchou
	aRetAnat := fCodNat(SB1->B1_COD)
	lAchou   := aRetAnat[1]
	aCodAnat := aRetAnat[2]
	If ALLTRIM(SB1->B1_TIPO) <> "PR"
		If lAchou .And. Empty(SB1->B1_XXNANAT)
			Alert("Não foi preenchido o campo 'Nº Codigo Anatel' para o produto: "+AllTrim(SB1->B1_COD) + Chr(13)+Chr(10)+ "[B1_XXNANAT]")
			lAchou := .F.
		EndIf
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
	
	//--> Alterado por Michel A. Sander em 25.06.2014 para verificar se o tipo PR de produto está sendo impresso
	If ALLTRIM(SB1->B1_TIPO) == 'PR'
		Do Case
			Case Val(SB1->B1_XXNANAT) == 0
				cCdAnat1 := ""
				cCdAnat2 := ""
				
			Case Val(SB1->B1_XXNANAT) == 1
				cCdAnat1 := SB1->B1_XXANAT1
				cCdAnat2 := ""
				
			Case Val(SB1->B1_XXNANAT) == 2
				cCdAnat1 := SB1->B1_XXANAT1
				cCdAnat2 := SB1->B1_XXANAT1
				
			Case Val(SB1->B1_XXNANAT) == 3
				cCdAnat1 := SB1->B1_XXANAT1
				cCdAnat2 := SB1->B1_XXANAT2
				cCdAnat3 := SB1->B1_XXANAT3
			OtherWise
				cCdAnat1 := " E R R O "
				cCdAnat2 := " E R R O "
				Alert("Erro no tratamento dos codigos ANATEL(DOMETQ04)."+Chr(13)+Chr(10)+"Favor procurar TI e informar dificuldade! "+Chr(13)+Chr(10)+"OP:"+MVPAR01)
				lAchou   := .F.
				
		EndCase
	Else
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
				
			Case Val(SB1->B1_XXNANAT) == 3 .And. Len(aGrpAnat) == 1
				cCdAnat1 := aGrpAnat[1]
				cCdAnat2 := aGrpAnat[1]
				
			OtherWise
				cCdAnat1 := " E R R O "
				cCdAnat2 := " E R R O "
				Alert("Erro no tratamento dos codigos ANATEL (DOMETQ04)."+Chr(13)+Chr(10)+"Favor procurar TI e informar dificuldade! "+Chr(13)+Chr(10)+"OP:"+MVPAR01)
				lAchou   := .F.
				
		EndCase
	EndIf
EndIf

//Valida se Campo Descricao do Produto está preenchido
If lAchou .And. Empty(SB1->B1_DESC)
	Alert("Campo Descricao do Produto não está preenchido no cadastro do produto! "+Chr(13)+Chr(10)+"[B1_DESC]")
	lAchou := .F.
EndIf

//Valida se Campo PN HUAWEI está preenchido
If !Empty(SC2->C2_PEDIDO)
	If lAchou .And. Empty(SC6->C6_SEUCOD)
		Alert("Campo PN HUAWEI não está preenchido no Item do Pedido de Vendas! "+Chr(13)+Chr(10)+"[C6_SEUCOD]")
		lAchou := .F.
	EndIf
EndIf

//Valida se Campo PN HUAWEI está preenchido
If !Empty(SC2->C2_PEDIDO)
	If lAchou .And. Empty(SC6->C6_SEUDES)
		Alert("Campo ITEM PEDIDO CLIENTE não está preenchido no Item do Pedido de Vendas! "+Chr(13)+Chr(10)+"[C6_SEUDES]")
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
aRetEmbala := U_RetEmbala(SB1->B1_COD,cNivel)
If !aRetEmbala[4]
	Alert("Emissão de etiqueta não permitida por falta de nivel da embalagem na estrutura.")
	Return(.F.)
EndIf

If lImpressao
	
	If !Empty(aFilhas)
		If ValType(aFilhas[1])=="A"
			cPorta    := "LPT2"
		EndIf
	EndIf
	
	If lColetor
		If SUBSTR(SB1->B1_GRUPO,1,3) == "DIO" 
			cPorta := "LPT3"
		EndIf
	EndIf
	
	//Chamando função da impressora ZEBRA
	MSCBPRINTER(cModelo,cPorta,,,.F.)
	MSCBChkStatus(.F.)
	MSCBLOADGRF("RDT.GRF")
	MSCBLOADGRF("ANATEL.GRF")
	
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
	
	For x := 1 To MVPAR03
      If x > 1
         _cProxPeca := U_IXD1PECA()
      EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Busca o próximo número de sequencia da etiqueta 		 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cSeqEtiq := ""
		If cNivel == "1"
			cSeqEtiq := NEXTSEQ()
	   Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Próximo nivel deve manter sequencia em 1/1		 		 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	      If MVPAR02 == 1
	         For nQ := 1 to Len( aFilhas ) 
					If ValType(aFilhas[1]) == "A"
						cBuscaSerie := aFilhas[nQ,1]
					Else
						cBuscaSerie := aFilhas[nQ]
					EndIf         
					If XD1->(dbSeek(xFilial()+cBuscaSerie))
					   cSeqEtiq := ALLTRIM(XD1->XD1_SERIAL)
					Else
					   cSeqEtiq := NEXTSEQ()
					EndIf
	         Next nQ
	      Else
				cSeqEtiq := NEXTSEQ()      
	      EndIf   
	   EndIf

		aRetEmbala       := U_RetEmbala(SB1->B1_COD,cNivel)
		
		Reclock("XD1",.T.)
		XD1->XD1_FILIAL  :=  xFilial("XD1")
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
		XD1->XD1_QTDORI  := nQtdEmb
		XD1->XD1_QTDATU  := nQtdEmb
		XD1->XD1_EMBALA  := aRetEmbala[1]
		XD1->XD1_QTDEMB  := aRetEmbala[2]
		XD1->XD1_NIVEMB  := If(AllTrim(cNivel)=="3",cNivel,aRetEmbala[3])
		XD1->XD1_PESOB   := nPesoVol

		If !Empty(SC2->C2_PEDIDO)
			XD1->XD1_PVSEP   := If(AllTrim(cNivel)=="3",SC5->C5_NUM,"")
		EndIf

      XD1->XD1_SERIAL := cSeqEtiq
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
		
		nCol := 03
		nIni := 07
		nLin := 04
		
		MSCBGRAFIC(90,020,"RDT",.T.)
		MSCBGRAFIC(90,135,"ANATEL",.T.)
		// Linha, coluna
		// linha (invertida), coluna (normal)
		MSCBSAYBAR(54  ,156  ,U_fTratTxt(XD1->XD1_XXPECA)             ,"N","MB04",8.361,.F.,.T.,.F.,,3,2,.F.,.F.,"1",.T.)
		
		//Contorno/Borda
		//Grupo 01
		MSCBBOX(07,05,102,170,3,"B")
		//-------------------------------------XXXXXXXXXX XXXXXXXXXX XXXX.XXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXX--------------------
		/*01*/ //MSCBSAY(nCol+(nLin*23),nIni   ,""                                                              ,cRotacao,"0","25,40")
		/*02*/   MSCBSAY(nCol+(nLin*22),nIni+65,StrZero(MVPAR02,4)+" Unidade(s)"                               ,cRotacao,"0","35,50")
		/*03*/ //MSCBSAY(nCol+(nLin*21),nIni   ,"XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXX",cRotacao,"0","25,40")
		/*04*/   MSCBSAY(nCol+(nLin*20),nIni   ,fTrataText(SB1->B1_DESC)                                        ,cRotacao,"0","25,40")
		/*05a*/  MSCBSAY(nCol+(nLin*19),nIni   ,"PN RDT: "+fTrataText(SB1->B1_COD)                              ,cRotacao,"0","25,40")
		If !Empty(SC2->C2_PEDIDO)
			/*05b*/  MSCBSAY(nCol+(nLin*19),nIni+80,"PN HUAWEI: "+fTrataText(SC6->C6_SEUCOD)                        ,cRotacao,"0","25,40")
			/*06a*/  MSCBSAY(nCol+(nLin*18),nIni   ,"PEDIDO CLIENTE: "+fTrataText(SC5->C5_ESP1)                     ,cRotacao,"0","25,40")
			/*06b*/  MSCBSAY(nCol+(nLin*18),nIni+80,"ITEM PEDIDO CLIENTE: "+fTrataText(SC6->C6_SEUDES)              ,cRotacao,"0","25,40")
		EndIf
		/*07*/ //MSCBSAY(nCol+(nLin*17),nIni   ,"XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXX",cRotacao,"0","25,40")
		/*08*/ //MSCBSAY(nCol+(nLin*16),nIni   ,"XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXX",cRotacao,"0","25,40")
		
		
		/*TESTE*///MSCBSAY(nCol+(nLin*14),nIni+78," [ HOMOLOGACÇO ]"                                                ,cRotacao,"0","65,80")
		
		
		If !Empty(cCdAnat1)
			/*09*/MSCBSAYBAR(nCol+(nLin*15)+3,nIni+4 ,fTrataText(cCdAnat1)                                            ,cRotacao,"MB07",8.361,.F.,.F.,.F.,,3,2,.F.,.F.,"1",.T.)
			/*09*/   MSCBSAY(nCol+(nLin*14)+3,nIni+13,fTrataText(cCdAnat1)                                            ,cRotacao,"0","25,40")
		EndIf
		/*10*/ //MSCBSAY(nCol+(nLin*14),nIni   ,"XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXX",cRotacao,"0","25,40")
		/*11*/ //MSCBSAY(nCol+(nLin*13),nIni   ,"XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXX",cRotacao,"0","25,40")
		If !Empty(cCdAnat2)
			/*12*/MSCBSAYBAR(nCol+(nLin*12)+2,nIni+4 ,fTrataText(cCdAnat2)                                          ,cRotacao,"MB07",8.361,.F.,.F.,.F.,,3,2,.F.,.F.,"1",.T.)
			/*12*/   MSCBSAY(nCol+(nLin*11)+2,nIni+13,fTrataText(cCdAnat2)                                          ,cRotacao,"0","25,40")
		EndIf
		
		//Grupo 02
		MSCBLineV(48,05,170,3,"B")
		//------------------------------------------------------------------------------------------------------------------------
		/*13*/ //MSCBSAY(nCol+(nLin*11),nIni   ,"XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXX",cRotacao,"0","25,40")
		/*14*/ //MSCBSAY(nCol+(nLin*10),nIni   ,"XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXX",cRotacao,"0","25,40")
		If !Empty(SC2->C2_PEDIDO)
			If !Empty(SC6->C6_SEUCOD)
				//	/*15*/MSCBSAYBAR(nCol+(nLin*09),nIni+04,"Part No: "+fTrataText(SC6->C6_SEUCOD)                          ,cRotacao,"MB07",8.361,.F.,.F.,.F.,,3,2,.F.,.F.,"1",.T.)
				//	/*15*/   MSCBSAY(nCol+(nLin*08),nIni+13,"Part No: "+fTrataText(SC6->C6_SEUCOD)                          ,cRotacao,"0","25,40")
				// Diminuiada a Dimensao do CODBAR em 09.05.2014 por Michel A. Sander
				/*15*/MSCBSAYBAR(nCol+(nLin*09),nIni+01,"Part No: "+fTrataText(SC6->C6_SEUCOD)                          ,cRotacao,"MB07",7.361,.F.,.F.,.F.,,3,2,.F.,.F.,"1",.T.)
				/*15*/   MSCBSAY(nCol+(nLin*08),nIni+10,"Part No: "+fTrataText(SC6->C6_SEUCOD)                          ,cRotacao,"0","25,40")
				
			EndIf
		EndIf
		
		MSCBSayBar(nCol+(nLin*09),nIni+100+10,"Quantity: "+StrZero(MVPAR02,4)                            ,cRotacao,"MB07",7  ,.F.,.F.,.F.,,2,1  ,Nil,Nil,Nil,Nil)
		
		//MSCBSayBar (          32            ,21       ,AllTrim(XD1->XD1_XXPECA)                                  ,"MB07"  ,"C"  ,13.36       ,.T.         ,.T.       ,.F.           ,              ,3           ,2                                                                                        )
		//MSCBSayBar (          nXmm           nYmm     cConteudo                                                   cRotação cTypePrt                                               [ nAltura ] [ *lDigver ] [ lLinha ] [ *lLinBaixo ] [ cSubSetIni ] [ nLargura ] [ nRelacao ] [ lCompacta ] [ lSerial ] [ cIncr ] [ lZerosL ] )
		
		/*15*/   //  MSCBSAYBAR(nCol+(nLin*09),nIni+90,"Quantity: "+StrZero(MVPAR02,4)                            ,cRotacao,"MB07",7  ,.F.,.F.,.F.,,2.5  ,2  ,.F.,.F.,"0.2",.T.)
		
		/*15*/       MSCBSAY(nCol+(nLin*08),nIni+110+10,"Quantity: "+StrZero(MVPAR02,4)                                  ,cRotacao,"0","25,40")
		
		//Grupo 03
		MSCBLineV(34,05,170,3,"B")
		//------------------------------------------------------------------------------------------------------------------------
		/*16*/ //MSCBSAY(nCol+(nLin*08),nIni   ,"XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXX",cRotacao,"0","25,40")
		/*17*/   MSCBSAY(nCol+(nLin*07)-2,nIni ,"Model./Desc: "+fTrataText(SB1->B1_DESC)                        ,cRotacao,"0","25,40")
		/*18*/ //MSCBSAY(nCol+(nLin*06),nIni   ,"XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXX",cRotacao,"0","25,40")
		
		//Grupo 04
		MSCBLineV(28,05,170,3,"B")
		//------------------------------------------------------------------------------------------------------------------------
		/*19*/ //MSCBSAY(nCol+(nLin*05),nIni   ,"XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXX",cRotacao,"0","25,40")
		
		//cVar := "39"+AllTrim(SC6->C6_SEUCOD)+"AZ0163"+SubStr(StrZero(Year(Date()),4),3,2)+fSemanaAno()+StrZero(MVPAR02,4)+cSeqEtiq //MV_XXSEQET = sequencial
		cVar := "19"+AllTrim(SC6->C6_SEUCOD)+"/AZ0163"+SubStr(StrZero(Year(Date()),4),3,2)+fSemanaAno()+"Q"+StrZero(MVPAR02,4)+"S"+cSeqEtiq //MV_XXSEQET = sequencial
		
		/*20*/MSCBSAYBAR(nCol+(nLin*04)-1,nIni   ,cVar                                                            ,cRotacao,"MB07"  ,9.361  ,.F.    ,.F.   ,.F.      ,          ,3       ,0.9     ,.F.      ,.F.    ,"1"  ,.T.)
			//	MSCBSAYBAR(nXmm            ,nYmm   ,cConteudo                                                       ,cRotacao,cTypePrt,nAltura,lDigVer,lLinha,lLinBaixo,cSubSetIni,nLargura,nRelacao,lCompacta,lSerial,cIncr,lZerosL)
		/*21*/   MSCBSAY(nCol+(nLin*03)-1,nIni+13,cVar                                                            ,cRotacao,"0","25,40")
		/*22*/ //MSCBSAY(nCol+(nLin*02),nIni    ,"XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXX",cRotacao,"0","25,40")
		
		//Grupo 05
		MSCBLineV(13,05,170,3,"B")
		//------------------------------------------------------------------------------------------------------------------------
		/*23*/   MSCBSAY(nCol+(nLin*01)+1,nIni    ,"Remark:"                                                 ,cRotacao,"0","25,40")
		cVar := fSemanaAno()+"/"+SubStr(StrZero(Year(Date()),4),3,2)
		/*23*/   MSCBSAY(nCol+(nLin*01)+1,nIni+75 ,"INDUSTRIA BRASILEIRA.  Semana: "+cVar                    ,cRotacao,"0","25,40")
		
		MSCBInfoEti("DOMEX","120X77")
		
		//Finaliza impressão da etiqueta
		MSCBEND()
		Sleep(500)
		
	Next x
	
	MSCBCLOSEPRINTER()
	
EndIf

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fSemanaAnoºAutor  ³ Felipe Melo        º Data ³  11/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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

//Função padrão que retorna a semana e o ano
//RetSem(dDataAtu)

Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fTrataTextºAutor  ³ Felipe Melo        º Data ³  11/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fTrataText(cTexto)

Default := cTexto

_cDesc:=StrTran(cTexto,"–"," ")
_cDesc:=StrTran(_cDesc,"_"," ")
_cDesc:=StrTran(StrTran(StrTran(StrTran(StrTran(_cDesc,"(",""),")",""),",","."),"Ø","0"),"/","-")
_cDesc:=StrTran(StrTran(StrTran(StrTran(StrTran(_cDesc,"Á","A"),"É","E"),"Í","I"),"Ó","O"),"Ú","U")
_cDesc:=StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(_cDesc,"Ç","C"),"Ã","A"),"Í","I"),"Ó","O"),"Ú","U"),":","")
_cDesc:=AllTrim(_cDesc)

Return(_cDesc)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fCodNat  ºAutor  ³ Felipe Melo        º Data ³  16/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fCodNat(cCodProd)

Local aRet     := {}
Local x        := 0
Local lOk      := .T.
Local cErro    := ""

Local aAreaSB1 := SB1->(GetArea())
Local aAreaSG1 := SG1->(GetArea())

Local cNEtiquetas :=''

SB1->(DbSetOrder(1))
SG1->(DbSetOrder(1))

//SB1->(DbSeek(xFilial("SB1")+cCodProd)) //MLS
//MSGALERT('DOMETQ01:'+cCodProd)        //MLS


If SG1->(DbSeek(xFilial("SG1")+cCodProd))
	cNEtiquetas := Alltrim(SB1->B1_XXNANAT)
	
	While SG1->(!Eof()) .And. AllTrim(cCodProd) == AllTrim(SG1->G1_COD)
		If SB1->(DbSeek(xFilial("SB1")+SG1->G1_COMP)) .And. !Empty(SB1->B1_XXANAT1)
			//For x:=1 To SG1->G1_QUANT
			aAdd(aRet,SB1->B1_XXANAT1)
			//Next x
			//If (SG1->G1_QUANT%1) > 0
			//	lOk := .F.
			//	cErro += IIf(Empty(cErro),""," / ") + AllTrim(SG1->G1_COMP)
			//EndIf
		EndIf
		SG1->(DbSkip())
	End
EndIf

IF ALLTRIM(SB1->B1_TIPO) <> "PR"
	If Empty(cNEtiquetas)
		MsgStop('Não foi preenchido o número de códigos de Barra Anatel no produto ' + cCodProd)
	Else
		If cNEtiquetas == '0'
			If Len(aRet) <> 0
				MsgStop('No produto ' + Alltrim(cCodProd) + ' foi selecionado a opção de 0 códigos de Barra Anatel, e foi encontrado ' + Alltrim(Str(Len(aRet)))+' código Anatel na Etrutura do Produto.')
				lOk := .F.
			EndIf
		Else
			If cNEtiquetas == '1' .or. cNEtiquetas == '2'
				If Len(aRet) <> 1
					MsgStop('No produto ' + Alltrim(cCodProd) + ' foi selecionado a opção de 1 códigos de Barra Anatel, e foi encontrado ' + Alltrim(Str(Len(aRet)))+' código Anatel na Etrutura do Produto.')
					lOk := .F.
				EndIf
			Else
				If cNEtiquetas == '3'
					If Len(aRet) <> 2
						MsgStop('No produto ' + Alltrim(cCodProd) + ' foi selecionado a opção de 2 códigos de Barra Anatel, e foi encontrado ' + Alltrim(Str(Len(aRet)))+' código Anatel na Etrutura do Produto.')
						lOk := .F.
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
ENDIF

//If !lOk
//	Alert("A quantidade da(s) MP(s) "+cErro+" está(ão) com casas decimais na quantidade da estrutura e isso não é permitido!")
//EndIf

RestArea(aAreaSB1)
RestArea(aAreaSG1)

Return({lOk,aRet})

Static Function NEXTSEQ()
Local _Retorno := 0
Local nLoop    := 0
Local lLoop    := .T.
Local aAreaGER := GetArea()
Local aAreaSX6 := SX6->( GetArea() )

SX6->( Dbsetorder(1) )

//cSeqEtiq := AllTrim(GetMV("MV_XXSEQET"))
//PutMv("MV_XXSEQET",Soma1(cSeqEtiq))

If SX6->( dbSeek("  " + "MV_XXSEQET") )
	While lLoop .and. nLoop < 1000
		If RecLock("SX6",.F.) .And. lLoop
			_NextDoc        := Alltrim(SX6->X6_CONTEUD)
			SX6->X6_CONTEUD := SOMA1(_NextDoc)
			SX6->( Msunlock() )
			
			lLoop    := .F.
			_Retorno := _NextDoc
		EndIf
		nLoop ++
	End
EndIf

If Empty(_Retorno)
	aPar := {}
	aAdd(aPar,{1,"Codigo Sequencial"     ,Space(06) ,"@!"    ,"NaoVazio()",      ,,60,.T.})
	aRet := {}
	aAdd(aRet,Space(06))
	If ParamBox(aPar,"Cadastro Produto",@aRet)
		PutMv("MV_XXSEQET",aRet[1])
		_Retorno := AllTrim(aRet[1])
	Else
		lAchou := .F.
	EndIf
EndIf

If Empty(_Retorno)
	MsgYesNo('Erro no campo sequencial!')
EndIf

RestArea(aAreaSX6)
RestArea(aAreaGER)

Return _Retorno
