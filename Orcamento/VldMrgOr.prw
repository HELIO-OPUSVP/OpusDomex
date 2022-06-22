
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VLDMRGOR  ºAutor  ³Osmar Ferreira      º Data ³  20/06/2022 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida a margem de lucro do Orcamento                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VldMrgOr(lMsg,lWflow)
	Loca lRet        := .T.
	Local nPerMargem := 0 //Percentual mínimo aceito como margem de lucro
	Local cTexto     := ""
	Local cAssunto   := ""
	Local cPara      := ""
	Local cCC        := ""
	Local cArquivo   := ""
	Local cMudouMargem := ""
	Local aAreaSA1   := SA1->( GetArea() )
	Local aAreaZZF   := ZZF->( GetArea() )
	Local aAreaSB1   := SB1->( GetArea() )
	Local aAreaTMP1  := TMP1->( GetArea() )

	U_yGrvPrnet()

	SA1->(dbSetOrder(01))
	SA1->( dbSeek(xFilial()+M->CJ_CLIENTE+M->CJ_LOJA) )

	If SA1->A1_XMARGEM > 0
		nPerMargem := SA1->A1_XMARGEM
	Else
		nPerMargem := GetMV("MV_XMARGEM")
	Endif

	TMP1->( dbGotop() )
	While TMP1->(!Eof())
		//Tira a margem de lucro para produtos tipo serviço
		SB1->( dbSeek(xFilial() + TMP1->CK_PRODUTO  ) )
		If TMP1->CK_XMARGEM < nPerMargem .And. (SB1->B1_TIPO <> "SI" .And. SB1->B1_TIPO <> "SV")
			cTexto += TMP1->CK_ITEM +" / "+ TMP1->CK_PRODUTO+"  Margem -> " + Str(TMP1->CK_XMARGEM)+ Chr(13)
		EndIf
		TMP1->( dbSkip() )
	EndDo

	If lMsg .And. cTexto <> ""
		cAssunto := "ITENS COM MARGEM DE LUCRO ABAIXO DO PADRÃO ("+ Str(nPerMargem)+"%)"
		cTexto := cAssunto + Chr(13) + cTexto + Chr(13)
		cTexto := cTexto + "Se gravar os dados o Orçamento será bloqueado!!"

		If "COLETOR" $ Funname()
			U_MsgColetor(cTexto)
		Else
			apMsgAlert(cTexto)
		EndIf
	EndIf


	cMudouMargem := ""
	If ZZF->( dbSeek(xFilial()+"MGO" + M->CJ_NUM ) )
		cMudouMargem := ZZF->ZZF_STACUS
	Else
		cMudouMargem := "T"
	EndIf

	If lWflow .And. cTexto <> ""  //.And. cMudouMargem = "T"
		cAssunto := "Orçamento de Venda "+M->C5_NUM+ " BLOQUEADO - Margem Abaixo do Padrão "
		//cPara := "osmar@opusvp.com.br;dayse.paschoal@rosenbergerdomex.com.br;" + UsrRetMail(M->C5_USER)
		cPara := "osmar@opusvp.com.br;"
		cCC := ""
		cArquivo := ""
		cTexto := "CLIENTE: "+M->CJ_CLIENTE+"/"+M->CJ_LOJA+" - "+ SA1->A1_NREDUZ + Chr(13)+;
			"MARGEM PADRÃO: "+Str(nPerMargem)+"%" + Chr(13) + Chr(13) + cTexto
		cTexto   := StrTran(cTexto,Chr(13),"<br>")

		If cMudouMargem = "T"
			U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
		EndIf

		lRet := .f.  // Irá travar o pedido de venda

	EndIf

	If cTexto == ""
		Alert("Margem de lucro dentro dos parametros!...")
	EndIf

	RestArea(aAreaTMP1)
	RestArea(aAreaSB1)
	RestArea(aAreaZZF)
	RestArea(aAreaSA1)
Return(lRet)

//Verifica o preço net para o Pedido de Venda
User Function yGrvPrNet()
	Local nItAtu     := 0
	Local nQtdPeso   := 0
	Local nTotalST   := 0
	Local nTotIPI    := 0
	Local nValorTot  := 0
	Local aValorNet  := {}
	Local nOpcao     := 3
	Local nCusMedio  := 0
	Local cStatus    := 0
	Local aCusto     := {}
	Local nPrcNet    := 0
	Local nMargem    := 0
	Local cProdVenda := ""
	Local aAreaSCK   := SCK->( GetArea() )
	Local aAreaSB1   := SB1->( GetArea() )
	Local aAreaTMP1  := TMP1->( GetArea() )

//Posiciona no cabeçalho do pedido de venda

	//SC5->(dbSetOrder(1))
	//SC5->(dbSeek(xFilial()+cNumPV))

	MaFisSave()

	MaFisIni(M->CJ_CLIENTE,;               // 01 - Codigo Cliente/Fornecedor
	M->CJ_LOJA,;                        // 02 - Loja do Cliente/Fornecedor
	Iif(M->CJ_TIPO $ "D;B", "F", "C"),;    // 03 - C:Cliente , F:Fornecedor
	M->CJ_TIPO,;                           // 04 - Tipo da NF
	M->CJ_TIPOCLI,;                        // 05 - Tipo do Cliente/Fornecedor
	MaFisRelImp("MT100", {"SF2", "SD2"}),;   // 06 - Relacao de Impostos que suportados no arquivo
	,;                                       // 07 - Tipo de complemento
	,;                                       // 08 - Permite Incluir Impostos no Rodape .T./.F.
	"SB1",;                                  // 09 - Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
	"MATA461")                               // 10 - Nome da rotina que esta utilizando a funcao

	//Posiciona nos itens do Orcamento
	TMP1->( dbGotop() )
	While TMP1->( !Eof() )

		//For x := 1 To Len(aCols)
		//Adiciona o item nos tratamentos de impostos
		/*
		nPC6_PRODUTO := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_PRODUTO" } )
		nPC6_TES     := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_TES" } )
		nPC6_QTDVEN  := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_QTDVEN" } )
		nPC6_PRCVEN  := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_PRCVEN" } )
		nPC6_VALDESC := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_VALDESC" } )
		nPC6_NFORI   := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_NFORI" } )
		nPC6_SERIORI := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_SERIORI" } )
		nPC6_VALOR   := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_VALOR" } )
		*/
		cProduto := TMP1->CK_PRODUTO
		cTes     := TMP1->CK_TES
		nQtdven  := TMP1->CK_QTDVEN
		nPrcven  := TMP1->CK_PRCVEN
		nValdesc := TMP1->CK_VALDESC
		cNfori   := ""
		cSeriori := ""
		nValor   := TMP1->CK_VALOR


		nItAtu++
		SB1->(DbSeek(FWxFilial("SB1")+cProduto))
		MaFisAdd(cProduto,; 		// 01 - Codigo do Produto                    ( Obrigatorio )
		cTes,;   		            // 02 - Codigo do TES                        ( Opcional )
		nQtdven,;		            // 03 - Quantidade                           ( Obrigatorio )
		nPrcven,;		            // 04 - Preco Unitario                       ( Obrigatorio )
		nValdesc,;			        // 05 - Desconto
		cNfori,; 		            // 06 - Numero da NF Original                ( Devolucao/Benef )
		cSeriori,;           // 07 - Serie da NF Original                 ( Devolucao/Benef )
		0,;                         // 08 - RecNo da NF Original no arq SD1/SD2
		0,;                         // 09 - Valor do Frete do Item               ( Opcional )
		0,;                         // 10 - Valor da Despesa do item             ( Opcional )
		0,;                         // 11 - Valor do Seguro do item              ( Opcional )
		0,;                         // 12 - Valor do Frete Autonomo              ( Opcional )
		nValor,;             // 13 - Valor da Mercadoria                  ( Obrigatorio )
		0,;                         // 14 - Valor da Embalagem                   ( Opcional )
		SB1->(RecNo()),;            // 15 - RecNo do SB1
		0)                          // 16 - RecNo do SF4
		MaFisLoad("IT_VALMERC", nValor, nItAtu)
		MaFisAlt("IT_PESO", nQtdPeso, nItAtu)
		//SC6->(DbSkip())
		TMP1->( dbSkip() )
	EndDo
	//Next x
	//EndDo

	//Altera dados do cabeçalho
	MaFisAlt("NF_FRETE",    M->CJ_FRETE)
	MaFisAlt("NF_SEGURO",   M->CJ_SEGURO)
	MaFisAlt("NF_DESPESA",  M->CJ_DESPESA)
	MaFisAlt("NF_AUTONOMO", M->CJ_FRETAUT)
	If M->CJ_DESCONT > 0
		MaFisAlt("NF_DESCONTO", Min(MaFisRet(, "NF_VALMERC")-0.01, M->CJ_DESCONT+MaFisRet(, "NF_DESCONTO")) )
	EndIf
	If M->CJ_PDESCAB > 0
		MaFisAlt("NF_DESCONTO", A410Arred(MaFisRet(, "NF_VALMERC")*M->CJ_PDESCAB/100, "CK_VALOR") + MaFisRet(, "NF_DESCONTO"))
	EndIf

	//Reposiciona nos itens para pegar os dados
	//SC6->(DbGoTop())
	//SC6->(DbSeek(FWxFilial('SC6') + SC5->C5_NUM))
	nItAtu := 0
	//While ! SC6->(EoF()) .And. SC6->C6_NUM == SC5->C5_NUM

	TMP1->( dbGotop() )
	While TMP1->( !Eof() )
		//For x := 1 To Len(aCols)
		//Pega os valores

		/*
		nPC6_QTDVEN  := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_QTDVEN" } )
		nPC6_VALOR   := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_VALOR" } )
		nPC6_PRCVEN  := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_PRCVEN" } )

		nPC6_XCUSUNI := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_XCUSUNI" } )
		nPC6_XSTACUS := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_XSTACUS" } )
		nPC6_PRODUTO := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_PRODUTO" } )

		nPC6_XPRCNET := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_XPRCNET" } )
		nPC6_XMARGEM := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_XMARGEM" } )
		*/

		cProdVenda := TMP1->CK_PRODUTO

		nQtdven  := TMP1->CK_QTDVEN
		nValor   := TMP1->CK_VALOR
		nPrcven  := TMP1->CK_PRCVEN

		nItAtu++
		nBasICM    := MaFisRet(nItAtu, "IT_BASEICM")
		nValICM    := MaFisRet(nItAtu, "IT_VALICM")
		nValIPI    := MaFisRet(nItAtu, "IT_VALIPI")
		nAlqICM    := MaFisRet(nItAtu, "IT_ALIQICM")
		nAlqIPI    := MaFisRet(nItAtu, "IT_ALIQIPI")
		nValSol    := (MaFisRet(nItAtu, "IT_VALSOL") / nQtdven)
		nBasSol    := MaFisRet(nItAtu, "IT_BASESOL")
		nVlrPis    := MaFisRet(nItAtu,"IT_VALPS2")
		nVlrCof    := MaFisRet(nItAtu,"IT_VALCF2")
		nPrcUniSol := nPrcven + nValSol
		nTotSol    := nPrcUniSol * nQtdven
		nTotalST   += MaFisRet(nItAtu, "IT_VALSOL")
		nTotIPI    += nValIPI
		nValorTot  += nValor

		aValorNet := {}

		//Definição do valor do produto
		//1 - Com todos os imposto (PIS / COFINS e ICMS)
		AADD(aValorNet,nPrcven)
		//2 - Sem PIS/COFINS
		AADD(aValorNet,nPrcven - (nVlrPis / nQtdven) - (nVlrCof / nQtdven))
		//3 - Sem PIS/COFINS e ICMS
		AADD(aValorNet,nPrcven - (nVlrPis / nQtdven) - (nVlrCof / nQtdven) - ;
			(nValICM  / nQtdven))
		//4 - Sem PIS/COFINS, ICMS e IPI
		AADD(aValorNet,nPrcven - (nVlrPis / nQtdven) - (nVlrCof / nQtdven) - ;
			(nValICM  / nQtdven) - (nValIPI / nQtdven))
		//5 - Sem PIS/COFINS, ICMS, IPI e ST
		AADD(aValorNet,nPrcven - (nVlrPis / nQtdven) - (nVlrCof / nQtdven) - ;
			(nValICM  / nQtdven) - (nValIPI / nQtdven) - nValSol)

		nPrcNet := aValorNet[nOpcao]

		aCusto    := U_RetCust(cProdVenda,'N')
		nCusMedio := aCusto[1]
		cStatus   := aCusto[2]

		nMargem := ((nPrcNet - nCusMedio) / nPrcNet) * 100

		RecLock("TMP1",.F.)
		TMP1->CK_XCUSUNI := nCusMedio
		TMP1->CK_XSTACUS := cStatus
		TMP1->CK_XPRCNET := nPrcNet

		//Tira a margem de lucro para produtos tipo serviço
		SB1->(dbSeek(xFilial()+cProdVenda))
		If (SB1->B1_TIPO == "SI" .Or. SB1->B1_TIPO == "SV")
			TMP1->CK_XMARGEM :=  0
		Else
			TMP1->CK_XMARGEM := nMargem
		EndIf
		TMP1->(msUnLock())

		TMP1->( dbSkip() )
	EndDo
	nTotFrete := MaFisRet(, "NF_FRETE")
	nTotVal := MaFisRet(, "NF_TOTAL")

	MaFisEnd()
	MaFisRestore()

	RestArea(aAreaTMP1)
	RestArea(aAreaSB1)
	RestArea(aAreaSCK)
Return


