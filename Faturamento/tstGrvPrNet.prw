#Include "rwMake.ch"
#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GrvPrNet   ºAutor  ³Osmar Ferreira      º Data ³  14/04/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Calculo do preço Net - DOMEX 			                  º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function tstGrvPrNet(cNumPV)
	Local nItAtu    := 0
	Local nQtdPeso  := 0
	Local nTotalST  := 0
	Local nTotIPI   := 0
	Local nValorTot := 0
	Local aValorNet := {}
	Local nOpcao    := 3

//Posiciona no cabeçalho do pedido de venda

    cNumPV := "042778"

	SC5->(dbSetOrder(1))
	SC5->(dbSeek(xFilial()+cNumPV))

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
		MaFisAdd(SC6->C6_PRODUTO,;    // 01 - Codigo do Produto                    ( Obrigatorio )
		SC6->C6_TES,;             // 02 - Codigo do TES                        ( Opcional )
		SC6->C6_QTDVEN,;          // 03 - Quantidade                           ( Obrigatorio )
		SC6->C6_PRCVEN,;          // 04 - Preco Unitario                       ( Obrigatorio )
		SC6->C6_VALDESC,;         // 05 - Desconto
		SC6->C6_NFORI,;           // 06 - Numero da NF Original                ( Devolucao/Benef )
		SC6->C6_SERIORI,;         // 07 - Serie da NF Original                 ( Devolucao/Benef )
		0,;                       // 08 - RecNo da NF Original no arq SD1/SD2
		0,;                       // 09 - Valor do Frete do Item               ( Opcional )
		0,;                       // 10 - Valor da Despesa do item             ( Opcional )
		0,;                       // 11 - Valor do Seguro do item              ( Opcional )
		0,;                       // 12 - Valor do Frete Autonomo              ( Opcional )
		SC6->C6_VALOR,;           // 13 - Valor da Mercadoria                  ( Obrigatorio )
		0,;                       // 14 - Valor da Embalagem                   ( Opcional )
		SB1->(RecNo()),;          // 15 - RecNo do SB1
		0)                        // 16 - RecNo do SF4
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

	//Reposiciona nos itens para pegar os dados
	SC6->(DbGoTop())
	SC6->(DbSeek(FWxFilial('SC6') + SC5->C5_NUM))
	nItAtu := 0
	While ! SC6->(EoF()) .And. SC6->C6_NUM == SC5->C5_NUM
		//Pega os valores
		nItAtu++
		nBasICM    := MaFisRet(nItAtu, "IT_BASEICM")
		nValICM    := MaFisRet(nItAtu, "IT_VALICM")
		nValIPI    := MaFisRet(nItAtu, "IT_VALIPI")
		nAlqICM    := MaFisRet(nItAtu, "IT_ALIQICM")
		nAlqIPI    := MaFisRet(nItAtu, "IT_ALIQIPI")
		nValSol    := (MaFisRet(nItAtu, "IT_VALSOL") / SC6->C6_QTDVEN)
		nBasSol    := MaFisRet(nItAtu, "IT_BASESOL")
		nVlrPis 	:= MaFisRet(nItAtu,"IT_VALPS2")
		nVlrCof     := MaFisRet(nItAtu,"IT_VALCF2")
		nPrcUniSol := SC6->C6_PRCVEN + nValSol
		nTotSol    := nPrcUniSol * SC6->C6_QTDVEN
		nTotalST   += MaFisRet(nItAtu, "IT_VALSOL")
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

        
	    Alert('Pr. NET '+ AllTrim(STR(aValorNet[nOpcao])))
		
        /*
		RecLock("SC6",.f.)
		SC6->C6_XPRCNET := aValorNet[nOpcao]
		SC6->(MsUnLock())
        */

		SC6->(DbSkip())
	EndDo
	nTotFrete := MaFisRet(, "NF_FRETE")
	nTotVal := MaFisRet(, "NF_TOTAL")

	MaFisEnd()
	MaFisRestore()

Return

/*
Definição dos valores totais dos produtos que constarão na proposta
1 - PRECO UNIT. SEM PIS/ COFINS, ICMS E IPI 		Sem imposto nenhum            
2 - PRECO UNIT. COM PIS/ COFINS, SEM ICMS E IPI 	Só com PIS/COFINS
3 - PRECO UNIT. COM PIS/ COFINS E ICMS, SEM IPI     Com PIS/COFINS e ICMS       
4 - PRECO UNIT. COM PIS/ COFINS, ICMS E IPI         Com todos       
5 - PRECO UNIT. COM PIS/ COFINS, ICMS, IPI E ST     Com todos + ST       

	Do Case
	Case cA1XXORPR1 == "1"
		nA1XXORPR1 := Round((SCK->CK_PRCVEN * ((100 - ( nIpi + nPiscof)) /100)) - nVIcmPorPC ,2)
	Case cA1XXORPR1 == "2"
		nA1XXORPR1 := Round(SCK->CK_PRCVEN  - nVIcmPorPC,2) //* ((100 - nIcm) / 100),2) 
	Case cA1XXORPR1 == "3"
		nA1XXORPR1 := SCK->CK_PRCVEN 
	Case cA1XXORPR1 == "4"
		nA1XXORPR1 := ROUND(SCK->CK_PRCVEN * (1+(nIpi /100)),2)
	Case cA1XXORPR1 == "5"
		nA1XXORPR1 := ROUND((SCK->CK_PRCVEN * (1+(nIpi /100))) + Round(nValIcmSt/ nQtd,3),2)
	End Case
*/

