
#Include "Protheus.ch"
#include "rwmake.ch"   
#Include "Topconn.ch"    


User Function ICMSST()
	Local cPedido  := '054679' //'054816'  //'054679'
	Local aAreaSC5 := SC5->( GetArea() )
	Local aAreaSC6 := SC6->( GetArea() )

    SC5->( dbSetOrder(01) )
	SC5->( dbSeek(xFilial() + cPedido) )
	
    Alert("Gerando ST...")

    //While !SC5->( Eof() )
        U_fGrvPrNet(cPedido)
	//	SC5->( dbSkip() )
	//EndDo

    Alert("Fim de operação...")
	
    RestArea(aAreaSC6)
	RestArea(aAreaSC5)
Return



User Function fGrvPrNet(cNumPV)
	Local nItAtu    := 0
	Local nQtdPeso  := 0
	Local nTotalST  := 0
	Local nTotIPI   := 0
	Local nValorTot := 0
	Local aValorNet := {}
	Local nOpcao    := 3
	Local nCusMedio := 0
	Local cStatus   := 0
	Local aCusto    := {}

//Posiciona no cabeçalho do pedido de venda

	//SC5->(dbSetOrder(1))
	//SC5->(dbSeek(xFilial()+cNumPV))

	MaFisSave()

	MaFisIni(SC5->C5_CLIENTE,;               // 01 - Codigo Cliente/Fornecedor
	SC5->C5_LOJACLI,;                        // 02 - Loja do Cliente/Fornecedor
	Iif(SC5->C5_TIPO $ "D;B", "F", "C"),;    // 03 - C:Cliente , F:Fornecedor
	SC5->C5_TIPO,;                           // 04 - Tipo da NF
	SC5->C5_TIPOCLI,;                        // 05 - Tipo do Cliente/Fornecedor
	MaFisRelImp("MT100", {"SF2", "SD2"}),;   // 06 - Relacao de Impostos que suportados no arquivo
	,;                                       // 07 - Tipo de complemento
	,;                                       // 08 - Permite Incluir Impostos no Rodape .T./.F.
	"SB1",;                                  // 09 - Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
	"MATA461")                               // 10 - Nome da rotina que esta utilizando a funcao

	//Posiciona nos itens do pedido de venda
	SC6->(DbSeek(FWxFilial('SC6') + SC5->C5_NUM))
	While ! SC6->(EoF()) .And. SC6->C6_NUM == SC5->C5_NUM
		//Adiciona o item nos tratamentos de impostos
		nItAtu++
		SB1->(DbSeek(FWxFilial("SB1")+SC6->C6_PRODUTO))
		MaFisAdd(SC6->C6_PRODUTO,;  // 01 - Codigo do Produto                    ( Obrigatorio )
		SC6->C6_TES,;               // 02 - Codigo do TES                        ( Opcional )
		SC6->C6_QTDVEN,;            // 03 - Quantidade                           ( Obrigatorio )
		SC6->C6_PRCVEN,;            // 04 - Preco Unitario                       ( Obrigatorio )
		SC6->C6_VALDESC,;           // 05 - Desconto
		SC6->C6_NFORI,;             // 06 - Numero da NF Original                ( Devolucao/Benef )
		SC6->C6_SERIORI,;           // 07 - Serie da NF Original                 ( Devolucao/Benef )
		0,;                         // 08 - RecNo da NF Original no arq SD1/SD2
		0,;                         // 09 - Valor do Frete do Item               ( Opcional )
		0,;                         // 10 - Valor da Despesa do item             ( Opcional )
		0,;                         // 11 - Valor do Seguro do item              ( Opcional )
		0,;                         // 12 - Valor do Frete Autonomo              ( Opcional )
		SC6->C6_VALOR,;             // 13 - Valor da Mercadoria                  ( Obrigatorio )
		0,;                         // 14 - Valor da Embalagem                   ( Opcional )
		SB1->(RecNo()),;            // 15 - RecNo do SB1
		0)                          // 16 - RecNo do SF4
		MaFisLoad("IT_VALMERC", SC6->C6_VALOR, nItAtu)
		MaFisAlt("IT_PESO", nQtdPeso, nItAtu)
		SC6->(DbSkip())
	EndDo

	//Altera dados do cabeçalho
	MaFisAlt("NF_FRETE", SC5->C5_FRETE)
	MaFisAlt("NF_SEGURO", SC5->C5_SEGURO)
	MaFisAlt("NF_DESPESA", SC5->C5_DESPESA)
	MaFisAlt("NF_AUTONOMO", SC5->C5_FRETAUT)
	If SC5->C5_DESCONT > 0
		MaFisAlt("NF_DESCONTO", Min(MaFisRet(, "NF_VALMERC")-0.01, SC5->C5_DESCONT+MaFisRet(, "NF_DESCONTO")) )
	EndIf
	If SC5->C5_PDESCAB > 0
		MaFisAlt("NF_DESCONTO", A410Arred(MaFisRet(, "NF_VALMERC")*SC5->C5_PDESCAB/100, "C6_VALOR") + MaFisRet(, "NF_DESCONTO"))
	EndIf

	//27/04/2022
	
		MaFisEndLoad(1,1)
		MafisRecal(,1)
	//27/04/2022	



	//Reposiciona nos itens para pegar os dados
	SC6->(DbGoTop())
	SC6->(DbSeek(FWxFilial('SC6') + SC5->C5_NUM))
	nItAtu := 0
	While ! SC6->(EoF()) .And. SC6->C6_NUM == SC5->C5_NUM
		//Pega os valores
		nItAtu++
		
		SB1->(DbSeek(FWxFilial("SB1")+SC6->C6_PRODUTO))

		nBasICM    := MaFisRet(nItAtu, "IT_BASEICM")
		nValICM    := MaFisRet(nItAtu, "IT_VALICM")
		nValIPI    := MaFisRet(nItAtu, "IT_VALIPI")
		nAlqICM    := MaFisRet(nItAtu, "IT_ALIQICM")
		nAlqIPI    := MaFisRet(nItAtu, "IT_ALIQIPI")
		nICMSRet   := MaFisRet(nItAtu, "IT_VALSOL")
		nValSol    := nICMSRet / SC6->C6_QTDVEN
		nBasSol    := MaFisRet(nItAtu, "IT_BASESOL")     
		nVlrPis    := MaFisRet(nItAtu,"IT_VALPS2")
		nVlrCof    := MaFisRet(nItAtu,"IT_VALCF2")
		nPrcUniSol := SC6->C6_PRCVEN + nValSol
		nTotSol    := nPrcUniSol * SC6->C6_QTDVEN
		nTotalST   += nICMSRet
		nTotIPI    += nValIPI
		nValorTot  += SC6->C6_VALOR
	
		aValorNet := {}

		//Definição do valor do produto
		//1 - Com todos os imposto (PIS / COFINS e ICMS)
		AADD(aValorNet,SC6->C6_PRCVEN)
		//2 - Sem PIS/COFINS
		AADD(aValorNet,SC6->C6_PRCVEN - (nVlrPis / SC6->C6_QTDVEN) - (nVlrCof / SC6->C6_QTDVEN))
		//3 - Sem PIS/COFINS e ICMS
		AADD(aValorNet,SC6->C6_PRCVEN - (nVlrPis / SC6->C6_QTDVEN) - (nVlrCof / SC6->C6_QTDVEN) - ;
			(nValICM  / SC6->C6_QTDVEN))
		//4 - Sem PIS/COFINS, ICMS e IPI
		AADD(aValorNet,SC6->C6_PRCVEN - (nVlrPis / SC6->C6_QTDVEN) - (nVlrCof / SC6->C6_QTDVEN) - ;
			(nValICM  / SC6->C6_QTDVEN) - (nValIPI / SC6->C6_QTDVEN))
		//5 - Sem PIS/COFINS, ICMS, IPI e ST
		AADD(aValorNet,SC6->C6_PRCVEN - (nVlrPis / SC6->C6_QTDVEN) - (nVlrCof / SC6->C6_QTDVEN) - ;
			(nValICM  / SC6->C6_QTDVEN) - (nValIPI / SC6->C6_QTDVEN) - nValSol)

		//RecLock("SC6",.f.)
		//If SC6->C6_XCUSUNI == 0
		//	aCusto    :=  {}
		//    aCusto    := U_RetCust(SC6->C6_PRODUTO,'S')
		//	nCusMedio := aCusto[1]
		//	cStatus   := aCusto[2]
		//    SC6->C6_XCUSUNI := nCusMedio
		//    SC6->C6_XSTACUS := cStatus
		//EndIf

		//SC6->C6_XPRCNET := aValorNet[nOpcao]
		//If SC6->C6_XICMRET = 0
			RecLock("SC6",.f.)
			  //SC6->C6_XICMRET := NoRound(nValSol,2)
			  SC6->C6_XICMRET := nICMSRet
			SC6->(MsUnLock())
		//EndIf

		//If U_Validacao("OSMAR")
		//	SB1->(dbSeek(xFilial()+SC6->C6_PRODUTO))
		//	If (SB1->B1_TIPO == "SI" .Or. SB1->B1_TIPO == "SV")
		//		SC6->C6_XMARGEM := 0
		//	Else
		//        SC6->C6_XMARGEM := ((SC6->C6_XPRCNET - SC6->C6_XCUSUNI) / SC6->C6_XPRCNET) * 100
		//    EndIf
		//Else
		//   SC6->C6_XMARGEM := ((SC6->C6_XPRCNET - SC6->C6_XCUSUNI) / SC6->C6_XPRCNET) * 100
		//EndIf
		//SC6->(MsUnLock())

		SC6->(DbSkip())
	EndDo
	nTotFrete := MaFisRet(, "NF_FRETE")
	nTotVal := MaFisRet(, "NF_TOTAL")

	MaFisEnd()
	MaFisRestore()

Return

