#include "protheus.ch"
#include "rwmake.ch"

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ? DOMETQ06 ?Autor  ? Michel A. Sander   ? Data ?  08/05/2014 ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ? Etiqueta Modelo 04                                         ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? P11                                                        ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
User Function DOMETQ06(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,lColetor,cNumSerie,cNumPeca)

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
	Private lCrystal := GetMv("MV_XXCRYST")		// Imprime Layout pelo Crystal Reports
//	Private aCodEtq	:= {}
//	Private _aArq	:= {}
//	Private lTelefonic:= .T.
	Default cNumOP    := ""
	Default cNumSenf  := ""
	Default nQtdEmb   := 0
	Default nQtdEtq   := 0
	Default cNumSerie := "1"
	Default cNivel    := ""
	Default cNumSerie := ""
	Default cNumPeca  := ""

	MVPAR02:= nQtdEmb   //Qtd Embalagem
	MVPAR03:= nQtdEtq   //Qtd Etiquetas

	cProdFilho := ""
	cProOp:= ""
	If !Empty(cNumOP)

		//Localiza SC2
		SC2->(DbSetOrder(1))
		If lAchou .And. SC2->(!DbSeek(xFilial("SC2")+cNumOP))
			Alert("Numero O.P. "+AllTrim(cNumOP)+" n?o localizada!")
			lAchou := .F.
		EndIf

		cSC2Recno := SC2->(Recno())
		__cPedido := ""
		__cItem   := ""
		If ALLTRIM(SC2->C2_SEQUEN) == "001"
			__cPedido  := SC2->C2_PEDIDO
			__cItem    := SC2->C2_ITEMPV
			cProdFilho := SC2->C2_PRODUTO
			cProdOp 	:= SC2->C2_PRODUTO

		Else
			SC2->(dbSeek(xFilial("SC2")+SUBSTR(cNumOP,1,8)+'001'))
			__cPedido := SC2->C2_PEDIDO
			__cItem   := SC2->C2_ITEMPV
			// Alterado Por Michel A. Sander em 15/05/2014
			// Busca Descri??o da OP Filha para impress?o na etiqueta
			SC2->(dbSeek(xFilial("SC2")+SUBSTR(cNumOP,1,11)))
			cProdFilho := SC2->C2_PRODUTO
			cProdOp := SC2->C2_PRODUTO

			SC2->(dbGoto(cSC2Recno))
		EndIf

		//Localiza SC5
		If !Empty(SC2->C2_PEDIDO)
			SC5->(DbSetOrder(1))
			If lAchou .And. SC5->(!DbSeek(xFilial("SC5")+__cPedido))
				Alert("Numero de Senf "+AllTrim(__cPedido)+" n?o localizado!")
				lAchou := .F.
			EndIf

			//Localiza SC6
			SC6->(DbSetOrder(1))
			If lAchou .And. SC6->(!DbSeek(xFilial("SC6")+__cPedido+__cItem))
				Alert("Item Senf "+AllTrim(__cItem)+" n?o localizado!")
				lAchou := .F.
			EndIf
		EndIf

		//Localiza SA1
		SA1->(DbSetOrder(1))
		If lAchou .And. SA1->(!DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
			Alert("Cliente "+SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI+" n?o localizado!")
			lAchou := .F.
		EndIf

		//Localiza SB1
		SB1->(DbSetOrder(1))
		If lAchou .And. !SB1->(DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
			Alert("Produto "+AllTrim(SC2->C2_PRODUTO)+" n?o localizado!")
			lAchou := .F.
		EndIf

	ElseIf !Empty(cNumSenf)

		//Localiza SC5
		SC5->(DbSetOrder(1))
		If lAchou .And. SC5->(!DbSeek(xFilial("SC5")+Subs(cNumSenf,1,6) ))
			Alert("Numero de Senf "+Subs(cNumSenf,1,6)+" n?o localizado!")
			lAchou := .F.
		EndIf

		//Localiza SC6
		SC6->(DbSetOrder(1))
		If lAchou .And. SC6->(!DbSeek(xFilial("SC6")+Subs(cNumSenf,1,8) ))
			Alert("Item Senf "+Subs(cNumSenf,7,2) +" n?o localizado!")
			lAchou := .F.
		EndIf

		cProdFilho := SC6->C6_PRODUTO
		//Localiza SB1
		SB1->(DbSetOrder(1))
		If lAchou .And. !SB1->(DbSeek(xFilial("SB1")+cProdFilho))
			Alert("Produto "+AllTrim(SC2->C2_PRODUTO)+" n?o localizado!")
			lAchou := .F.
		EndIf

		//Localiza SA1
		SA1->(DbSetOrder(1))
		If lAchou .And. SA1->(!DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
			Alert("Cliente "+SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI+" n?o localizado!")
			lAchou := .F.
		EndIf


	EndIf

	//????????????????????????????????????????????????????????????????Ŀ
	//?Monta o n?mero de s?rie										   ?
	//????????????????????????????????????????????????????????????????Ŀ
	cSerieFim := If( cNumSerie=="1" .Or. Empty(cNumSerie), 1, Val(cNumSerie) )

	Do Case
	Case SC2->C2_QUANT <=9
		cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,1)	// MV_PAR07 Sequencial Serial
	Case  SC2->C2_QUANT >=10 .And.  SC2->C2_QUANT <= 99
		cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,2)	// MV_PAR07 Sequencial Serial
	Case  SC2->C2_QUANT >=100 .And. SC2->C2_QUANT <= 999
		cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,3)	// MV_PAR07 Sequencial Serial
	Case  SC2->C2_QUANT >=1000 .And. SC2->C2_QUANT <= 9999
		cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,4)	// MV_PAR07 Sequencial Serial
	Case  SC2->C2_QUANT >=10000 .And. SC2->C2_QUANT <= 99999
		cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,5)	// MV_PAR07 Sequencial Serial
	EndCase

	//???????????????????????????????????????????????x?[?
	//?Montagem do c?digo de barras 2D					?
	//???????????????????????????????????????????????x?[?
	cSQL    := "SELECT dbo.SemanaProtheus() AS SEMANA"
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"WEEK",.F.,.T.)
	cSemana := WEEK->SEMANA
	cYY     := SUBSTR(cSemana,3,2)
	cWW     := StrZero(Val(SubStr(cSemana,5,2)),2)

	WEEK->(dbCloseArea())

	// Verifica se DIO pertence a classe MTP para impress?o de layout com DATAMATRIX
	If AllTrim(SB1->B1_SUBCLAS)=="MTP"
		lCrystal := .T.
	Else
		lCrystal := .F.
	EndIf

	//
	If lAchou
		aRetAnat := U_fCodNat(SB1->B1_COD)
		lAchou   := aRetAnat[1]
		aCodAnat := aRetAnat[2]

		If lAchou .And. Empty(SB1->B1_XXNANAT)
			Alert("N?o foi preenchido o campo 'N? Codigo Anatel' para o produto: "+AllTrim(SB1->B1_COD) + Chr(13)+Chr(10)+ "[B1_XXNANAT]")
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
				Alert("Erro no tratamento dos codigos ANATEL (DOMETQ06)."+Chr(13)+Chr(10)+"Favor procurar TI e informar dificuldade! "+Chr(13)+Chr(10)+"OP:"+cNumOP)
			ElseIf !Empty(cNumSenf)
				Alert("Erro no tratamento dos codigos ANATEL (DOMETQ06)."+Chr(13)+Chr(10)+"Favor procurar TI e informar dificuldade! "+Chr(13)+Chr(10)+"Senf:"+cNumSenf)
			EndIf
			lAchou   := .F.

		EndCase

	EndIf

	//Valida se Campo Descricao do Produto est? preenchido
	If lAchou .And. Empty(SB1->B1_DESC)
		Alert("Campo Descricao do Produto n?o est? preenchido no cadastro do produto! "+Chr(13)+Chr(10)+"[B1_DESC]")
		lAchou := .F.
	EndIf

	//Valida se Campo PN HUAWEI est? preenchido
	If !Empty(SC2->C2_PEDIDO)
		If lAchou .And. Empty(SC6->C6_SEUCOD)
			Alert("Campo PN n?o est? preenchido no Item do Pedido de Vendas! "+Chr(13)+Chr(10)+"[C6_SEUCOD]")
			lAchou := .F.
		EndIf
	EndIf

	//Valida se Campo PEDIDO CLIENTE est? preenchido
	If !Empty(SC2->C2_PEDIDO)
		If lAchou .And. Empty(SC5->C5_ESP1)
			Alert("Campo PEDIDO CLIENTE n?o est? preenchido no Cabe?alho do Pedido de Vendas! "+Chr(13)+Chr(10)+"[C5_ESP1]")
			lAchou := .F.
		EndIf
	EndIf

	//Caso algum registro n?o seja localizado, sair da rotina
	If !lAchou
		Return(.f.)
	EndIf

	//Se impressora n?o identificada, sair da rotina
	If !lPrinOK
		Alert("Erro de configura??o!")
		Return(.f.)
	EndIf

	//???????????????????????????????????????????????x?[?
	//?Busca ?ltimo n?mero de s?rie							?
	//???????????????????????????????????????????????x?[?
	If cNivel == "1"
		cSQL := "SELECT MAX(XD1_SERIAL) XD1_SERIAL FROM XD1010 (NOLOCK) WHERE "
		cSQL += "D_E_L_E_T_='' AND XD1_OCORRE <> '5' AND XD1_OP='"+AllTrim(cNumOp)+"' AND XD1_NIVEMB='1'"
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"TMP",.F.,.T.)
		If !TMP->(Eof())
			If !Empty(TMP->XD1_SERIAL)
				cNumSerie := Soma1(TMP->XD1_SERIAL)
			EndIf
		EndIf
		TMP->(dbCloseArea())
	Else
		cNumSerie := ""
		lCrystal  := .F.
	EndIf

	If lImpressao

		If lColetor
			If SUBSTR(SB1->B1_GRUPO,1,3) == "DIO"
				cPorta := "LPT3"
			EndIf
		EndIf

		If !lCrystal
			//Chamando fun??o da impressora ZEBRA
			MSCBPRINTER(cModelo,cPorta,,,.F.)
			MSCBChkStatus(.F.)
			MSCBLOADGRF("RDT2.GRF")
			MSCBLOADGRF("ANATEL2.GRF")
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
		//XD2->XD2_PCFILH := IIF(ValType(aFilhas[_nX]) =="U"," ",iif(ValType(aFilhas[_nX]) == "N",Alltrim(Str(aFilhas[_nX])),aFilhas[_nX]))
		//XD2->XD2_PCFILH := IIF(Type(aFilhas[_nX]) =="U"," ",iif(Type(aFilhas[_nX]) == "N",Alltrim(Str(aFilhas[_nX])),aFilhas[_nX])) // mls 08/02/2021 alterado por Type, por nao estar declarado
		If ValType(aFilhas[_nX])  == "A"
			XD2->XD2_PCFILH := aFilhas[_nX][1]
		Else
			XD2->XD2_PCFILH := aFilhas[_nX]
		EndIf
		XD2->( msUnlock() )
	Next _nX

	For __nEtq := 1 To MVPAR03


		If __nEtq > 1
			_cProxPeca := U_IXD1PECA()
		EndIf

		aRetEmbala       := U_RetEmbala(SB1->B1_COD,cNivel)

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
		XD1->XD1_NIVEMB  := If(AllTrim(cNivel)=="3",cNivel,aRetEmbala[3]) // 3 = Nivel 3 (Volumes parar expedi??o n?o constam na estrutura)
		If !Empty(SC2->C2_PEDIDO)
			XD1->XD1_PVSEP   := If(AllTrim(cNivel)=="3",SC5->C5_NUM,"")
		EndIf
		XD1->XD1_SERIAL  := cNumSerie
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
			cMVPAR02 := StrZero(MVPAR02,4)+" Unidade(s)"
			cMVPAR03 := U_fTratTxt(SB1->B1_DESC)
			cMVPAR04 := "PN RDT: "+SB1->B1_COD
			cMVPAR05 := U_fTratTxt(SA1->A1_NREDUZ)+" - "+U_fTratTxt(SC6->C6_SEUCOD)
			cMVPAR06 := "PED.CLIENTE: "+U_fTratTxt(SC5->C5_ESP1)
			cMVPAR07 := "ITEM DO PEDIDO/CLIENTE: "+U_fTratTxt(SC6->C6_SEUDES)
			cMVPAR08 := "SN: "+cNumSerie
			cMVPAR09 := "SEMANA: "+cWW+"/"+cYY
			cMVPAR10 := If(Empty(cNumSerie),SPACE(10),cNumSerie)
			cParam   := cMVPAR01+";"+cMVPAR02+";"+cMVPAR03+";"+cMVPAR04+";"+cMVPAR05+";"+cMVPAR06+";"+cMVPAR07+";"+cMVPAR08+";"+cMVPAR09+";"+cMVPAR10+";"

			//???????????????????????????????????????????????x?[?
			//?Par?metros de impress?o do Crystal Reports		 ?
			//???????????????????????????????????????????????x?[?
			cOptions := "2;0;1;Layout004"			// Parametro 1 (2= Impressora 1=Visualiza)

			//???????????????????????????????????????????????x?[?
			//?Executa Crystal Reports para impress?o			 	 ?
			//???????????????????????????????????????????????x?[?
			CALLCRYS('Layout004', cParam ,cOptions)
			Sleep(1500)

		Else

			//Inicia impress?o da etiqueta
				MSCBBEGIN(1,5)
				nCol := 05
				nIni := 07
				nLin := 04

				//Contorno/Borda
				MSCBBOX(03,05,115,88,3,"B")
				//Logos
				MSCBGRAFIC(10,10,"RDT2")
				MSCBGRAFIC(50,07,"ANATEL2")
				MSCBSAYBAR(75  ,07               ,U_fTratTxt(XD1->XD1_XXPECA)                                                               ,cRotacao,"MB04",7.361,.F.,.T.,.F.,,3,2,.F.,.F.,"1",.T.)
				MSCBSAY(045,nIni+(nLin*04)   ,StrZero(MVPAR02,4)+" Unidade(s)"                                                          ,cRotacao,"0","40,50")

				SB1->(dbSeek(xFilial("SB1")+cProdFilho))
			    MSCBSAY(nCol,nIni+(nLin*06)   ,U_fTratTxt(SB1->B1_DESC)                                                                  ,cRotacao,"0","28,28")
			    MSCBSAY(nCol,nIni+(nLin*07)   ,"PN RDT: "+U_fTratTxt(SB1->B1_COD)                                                        ,cRotacao,"0","30,30")

			If !Empty(SC2->C2_PEDIDO)
					   MSCBSAY(nCol,nIni+(nLin*08)   ,U_fTratTxt(SA1->A1_NREDUZ)+" - "+U_fTratTxt(SC6->C6_SEUCOD)                               ,cRotacao,"0","30,30")
					   MSCBSAY(nCol,nIni+(nLin*09)   ,"PED.CLIENTE: "+U_fTratTxt(SC5->C5_ESP1)                                                  ,cRotacao,"0","30,30")
					   MSCBSAY(nCol,nIni+(nLin*10)   ,"ITEM DO PEDIDO/CLIENTE: "+U_fTratTxt(SC6->C6_SEUDES)                                     ,cRotacao,"0","30,30")
			EndIf
				   MSCBSAY(nCol+80,nIni+(nLin*11),"SEMANA: "+U_fSemaAno()+"/"+SubStr(StrZero(Year(Date()),4),3,2)                           ,cRotacao,"0","30,30")

				   //MSCBSAY(nCol,nIni+(nLin*14)   ,"TESTES:"                                                                                 ,cRotacao,"0","30,30")
				   //MSCBSAY(nCol,nIni+(nLin*15)   ,"SM - IL<0.30dB   RL:>45dB (PC)   >55dB (APC)"                                            ,cRotacao,"0","30,30")
				   //MSCBSAY(nCol,nIni+(nLin*16)   ,"MM - IL<0.30dB   RL:>30dB (PC)"                                                          ,cRotacao,"0","30,30")

			If !Empty(SC6->C6_XXSITE)
					MSCBSAY(nCol,nIni+(nLin*15)+11, "SITE     : " + SC6->C6_XXSITE							                                           ,cRotacao,"0","30,30")
			EndIf
				   MSCBSAY(nCol,nIni+(nLin*19)   ,"INDUSTRIA BRASILEIRA"                                                                    ,cRotacao,"0","30,30")
				   MSCBSAY(nCol+90,nIni+(nLin*19),"Layout 004"                                                                              ,cRotacao,"0","30,30")

				MSCBInfoEti("DOMEX","80X60")
				
			/*
			lTelefonic := If ((("TELEFONICA" $ Upper(SA1->A1_NOME)) .Or. ("TELEFONICA" $ Upper(SA1->A1_NREDUZ))),.T.,.F.)

			cFila := "000000"
			IF !CB5SetImp(cFila,.F.)
				U_MsgColetor("Local de impressao invalido!")
				Return .F.
			EndIf

			SB1->(dbSeek(xFilial("SB1")+cProdOP))
			
			MSCBBEGIN(1,5)
			AADD(_aArq,'CT~~CD,~CC^~CT~'+ CRLF)
			AADD(_aArq,'^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR2,2~SD28^JUS^LRN^CI0^XZ'+ CRLF)
			AADD(_aArq,'^XA'+ CRLF)
			AADD(_aArq,'^MMT'+ CRLF)
			AADD(_aArq,'^PW945'+ CRLF)
			AADD(_aArq,'^LL0709'+ CRLF)
			AADD(_aArq,'^LS0'+ CRLF)
			AADD(_aArq,'^FO384,64^GFA,01536,01536,00016,:Z64:'+ CRLF)
			AADD(_aArq,'eJzN1DFuwyAUBuBYDGylB6jCRSxzpY4ZIuFMPUYuEjWOPGTMEYqVwaNTdXFlK688avDDatNEXcLkbwD+9wDPZnc6dBuRA+TUCsBQAwCdwKzPxNIa4unRgkgoAhPncQPufAoWzuOGqtWRtZvRB7duxRAoMW7HYG6TaBLwYUjs/TTYB34cIpAC3IZTF8TsChvi5D9uYwubjFrZL2psHXGCrSNm2CpiLI3ateKCsXUFMR5+wWKbC8ajOU3Nb7S40fIPq/H8frT+3a4+8gDQFTFutZu4JMaoL+RBTY2lC2I8P0nuO56vovd/iBesvuOF92PvT+TZcxL78mArc1oAfBqfb1VZN8FiV5kemm70e9VLwbxlaT2XrPDxyu44cdlnc+6tS9hvMll7d/vtYZOqOh/8UW8PaZrx3LejXq/7ZSqoz6PZsRGv2SIVvpyyEZtsoQ/D/4ZbL63f4j/mdeMLGRXtbA==:BDC0'+ CRLF)
			AADD(_aArq,'^FO32,64^GFA,03456,03456,00036,:Z64:'+ CRLF)
			AADD(_aArq,'eJztlDFr20AUx9/JEgVBsQM+NHrXHjzqDPoAMlhDh0I+ggMx3srhDIEsnTpXaDruSzRfokM3hw4dm9JFaYOu750tWwZdlLFDng77nvz81+/+73QAr/Ea/0XEumhloeyq4XzcygKHju7V8dO0nbl0Wv918MC8lbFuHRn36vj2AoQSOPxU0NTHxBf2VqOji1DLWHtah1p5uojjuCxiFTbWceCMjzh+jYNgHPAR4zAe8zPgo4AfeTZaodtab0iHpGJt87BZsQ+pL1IESH20aj+lifAJrvEnLHXslTrc2Cl+7e/dNjp8vmAi48CyYJbxQCw4LHLI2CwLWHbwWYUyjqVXhJsipikoHF5ZhLdF4w89Gx9tvfHRKwRM0SMhDjiWB/+sS63LnY7WVkfrgw6HHL0J0CQeAA3OR2MYM5sf/bmVMehSqb2O2vEodeQhArwEdWjHAzse27GWjofr8Lz9ugBlQ8zDIw+ZAmyeARPcWgUZzM9mlB900Af0uVDWnwJXiTzYLxWe8KBF1CjrE3UqJTzKjzpN34mH9g/plNT3Fs9uq+AH+WT3D7AZ7aejP7gW6WkIFekgA25JAGyfOujsmPb7ucmAtraAdng0mosGlF5h58/F6OCNO+L2y+sIP+0tQZ3+GjZ69uek7kfh+V1vTWKq3prp+uoFOnU/D8v7dcBADUU1lINtsu3WPIcVW7HLdXTBr/ismy2B5Nrc/zXmIamH37vXSC9KPsvzPMu/4lHi0vn485cxpqqTm98PnTVTiCJ2eRXNlg/RYH3RrSOTz/LxaSKranhtti6eT/ANX9c5nmy5cPF8kY/VRD4ac2ekg2cawWrJ4XK1EuvOkj0P2lz90dLcOXjwYHuPPO/w5HDymInlqSpv4FjXlK3Rn2UEyyUM1stuHYNt+kU89fDmR7fPPF9gv5Any/O3rn6ZamDuiScxrr6frwTuH/Rn+cz+QW9rRjzDKpFPnTWnsei8653MP7xAx9GwUzrZX8NFf81k21/z5qK/ZvgCnaC7YafP6j+MYNC9gV7jEP8A2BorUg==:0F0C'+ CRLF)

			AADD(_aArq,'^FT337,228^A0N,46,48^FH\^FD'+StrZero(MVPAR02,4)+' Unidade(s)^FS'+ CRLF)

			if !Empty(SB1->B1_XMODELO) .AND. lTelefonic

				XD6->(dbSetOrder(1))
				If XD6->(dbSeek(xFilial()+SB1->B1_XMODELO))
					AADD(_aArq,'^FT715,579^BQN,2,3'+ CRLF)
					AADD(_aArq,'^FDMA,'+alltrim(XD6->XD6_LINK)+'^FS'+ CRLF)
				Else
					msginfo("N?o existe nenhum Link Cadastrado na XD6", "Aten??o")
				Endif
			Endif
			AADD(_aArq,'^FO22,37^GB901,631,2^FS'+ CRLF)
			AADD(_aArq,'^BY3,2,69^FT590,126^BUN,,Y,N'+ CRLF)
			AADD(_aArq,'^FD'+U_fTratTxt(XD1->XD1_XXPECA)+'^FS'+ CRLF)

			AADD(_aArq,'^FT40,267^A0N,29,28^FH\^FD'+U_fTratTxt(SB1->B1_DESC)+'^FS'+ CRLF)
			AADD(_aArq,'^FT40,304^A0N,29,28^FH\^FDPN RDT: '+SB1->B1_COD+'^FS'+ CRLF)
			AADD(_aArq,'^FT40,341^A0N,29,28^FH\^FD'+U_fTratTxt(SA1->A1_NREDUZ)+" - "+U_fTratTxt(SC6->C6_SEUCOD)+'^FS'+ CRLF)
			AADD(_aArq,'^FT40,379^A0N,29,28^FH\^FDPED.CLIENTE: '+U_fTratTxt(SC5->C5_ESP1)+'^FS'+ CRLF)
			AADD(_aArq,'^FT40,416^A0N,29,28^FH\^FDITEM DO PEDIDO: '+U_fTratTxt(SC6->C6_SEUDES)+'^FS'+ CRLF)

			AADD(_aArq,'^FT715,446^A0N,29,28^FH\^FDSEMANA: '+cWW+'/'+cYY+'^FS'+ CRLF)

			If !Empty(SC6->C6_XXSITE)
				AADD(_aArq,'^FT59,611^A0N,29,28^FH\^FDSITE:' + SC6->C6_XXSITE+'^FS'+ CRLF)
			Endif
			AADD(_aArq,'^FT55,653^A0N,29,28^FH\^FDINDUSTRIA BRASILEIRA^FS'+ CRLF)
			AADD(_aArq,'^FT766,651^A0N,29,28^FH\^FDLayout 004^FS'+ CRLF)
			AADD(_aArq,'^PQ1,0,1,Y^XZ'+ CRLF)

			AaDd(aCodEtq,_aArq)

			For nY:=1 To Len(aCodEtq)
				For nP:=1 To Len(aCodEtq[nY])
					MSCBWrite(aCodEtq[nY][nP])
				Next nP
			Next nY
*/
			//Finaliza impress?o da etiqueta
			MSCBEND()

		//	_aArq:= {}
		//	aCodEtq:= {}
			Sleep(500)

		EndIf

		cNumSerie := Soma1(cNumSerie)

	Next __nEtq

	If !lCrystal
		MSCBCLOSEPRINTER()
	EndIf

EndIf

Return(.T.)
