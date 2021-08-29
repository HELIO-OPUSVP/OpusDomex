#Include "rwMake.ch"
#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OrcPrNet   ºAutor  ³Osmar Ferreira      º Data ³  02/07/20  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Calculo do preço Net - DOMEX 			                  º±±
±±º          ³  Para o Orçamento                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function OrcPrNet(cNumPV)
	Local nItAtu    := 0
	Local nQtdPeso  := 0
	Local nTotalST  := 0
	Local nTotIPI   := 0
	Local nValorTot := 0
	Local aValorNet := {}
	Local nOpcao    := 3
	Local aAreaSCJ  := GetArea("SCJ")
	Local aAreaSCK  := GetArea("SCK")

//Posiciona no cabeçalho do Orçamento de venda

	SCJ->(dbSetOrder(1))
	SCJ->(dbSeek(xFilial()+cNumPV))

	MaFisSave()

	MaFisIni(SCJ->CJ_CLIENTE,;               // 01 - Codigo Cliente/Fornecedor
	SCJ->CJ_LOJA,;                           // 02 - Loja do Cliente/Fornecedor
	"C",;                                    // 03 - C:Cliente , F:Fornecedor
	"N",;                                    // 04 - Tipo da NF
	SCJ->CJ_TIPOCLI,;                        // 05 - Tipo do Cliente/Fornecedor
	MaFisRelImp("MT100", {"SF2", "SD2"}),;   // 06 - Relacao de Impostos que suportados no arquivo
	,;                                       // 07 - Tipo de complemento
	,;                                       // 08 - Permite Incluir Impostos no Rodape .T./.F.
	"SB1",;                                  // 09 - Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
	"MATA461")                               // 10 - Nome da rotina que esta utilizando a funcao

	//Posiciona nos itens do Orçamento de venda
	SCK->(DbSeek(FWxFilial('SCK') + SCJ->CJ_NUM))
	While ! SCK->(EoF()) .And. SCK->CK_NUM == SCJ->CJ_NUM
		//Adiciona o item nos tratamentos de impostos
		nItAtu++
		SB1->(DbSeek(FWxFilial("SB1")+SCK->CK_PRODUTO))
		MaFisAdd(SCK->CK_PRODUTO,;  // 01 - Codigo do Produto                    ( Obrigatorio )
		SCK->CK_TES,;               // 02 - Codigo do TES                        ( Opcional )
		SCK->CK_QTDVEN,;            // 03 - Quantidade                           ( Obrigatorio )
		SCK->CK_PRCVEN,;            // 04 - Preco Unitario                       ( Obrigatorio )
		SCK->CK_VALDESC,;           // 05 - Desconto
		"",;                        // 06 - Numero da NF Original                ( Devolucao/Benef )
		"",;                        // 07 - Serie da NF Original                 ( Devolucao/Benef )
		0,;                         // 08 - RecNo da NF Original no arq SD1/SD2
		0,;                         // 09 - Valor do Frete do Item               ( Opcional )
		0,;                         // 10 - Valor da Despesa do item             ( Opcional )
		0,;                         // 11 - Valor do Seguro do item              ( Opcional )
		0,;                         // 12 - Valor do Frete Autonomo              ( Opcional )
		SCK->CK_VALOR,;             // 13 - Valor da Mercadoria                  ( Obrigatorio )
		0,;                         // 14 - Valor da Embalagem                   ( Opcional )
		SB1->(RecNo()),;            // 15 - RecNo do SB1
		0)                          // 16 - RecNo do SF4
		MaFisLoad("IT_VALMERC", SCK->CK_VALOR, nItAtu)
		MaFisAlt("IT_PESO", nQtdPeso, nItAtu)
		SCK->(DbSkip())
	EndDo

	//Altera dados do cabeçalho
	MaFisAlt("NF_FRETE", SCJ->CJ_FRETE)
	MaFisAlt("NF_SEGURO", SCJ->CJ_SEGURO)
	MaFisAlt("NF_DESPESA", SCJ->CJ_DESPESA)
	MaFisAlt("NF_AUTONOMO", SCJ->CJ_FRETAUT)
	If SCJ->CJ_DESCONT > 0
		MaFisAlt("NF_DESCONTO", Min(MaFisRet(, "NF_VALMERC")-0.01, SCJ->CJ_DESCONT+MaFisRet(, "NF_DESCONTO")) )
	EndIf
	If SCJ->CJ_PDESCAB > 0
		MaFisAlt("NF_DESCONTO", A410Arred(MaFisRet(, "NF_VALMERC")*SCJ->CJ_PDESCAB/100, "C6_VALOR") + MaFisRet(, "NF_DESCONTO"))
	EndIf

	//Reposiciona nos itens para pegar os dados
	SCK->(DbGoTop())
	SCK->(DbSeek(FWxFilial('SCK') + SCJ->CJ_NUM))
	nItAtu := 0
	While ! SCK->(EoF()) .And. SCK->CK_NUM == SCJ->CJ_NUM
		//Pega os valores
		nItAtu++
		nBasICM    := MaFisRet(nItAtu, "IT_BASEICM")
		nValICM    := MaFisRet(nItAtu, "IT_VALICM")
		nValIPI    := MaFisRet(nItAtu, "IT_VALIPI")
		nAlqICM    := MaFisRet(nItAtu, "IT_ALIQICM")
		nAlqIPI    := MaFisRet(nItAtu, "IT_ALIQIPI")
		nValSol    := (MaFisRet(nItAtu, "IT_VALSOL") / SCK->CK_QTDVEN)
		nBasSol    := MaFisRet(nItAtu, "IT_BASESOL")
		nVlrPis    := MaFisRet(nItAtu,"IT_VALPS2")
		nVlrCof    := MaFisRet(nItAtu,"IT_VALCF2")
		nPrcUniSol := SCK->CK_PRCVEN + nValSol
		nTotSol    := nPrcUniSol * SCK->CK_QTDVEN
		nTotalST   += MaFisRet(nItAtu, "IT_VALSOL")
		nTotIPI    += nValIPI
		nValorTot  += SCK->CK_VALOR

		aValorNet := {}

		//Definição do valor do produto
		//1 - Com todos os imposto (PIS / COFINS e ICMS)
		AADD(aValorNet,SCK->CK_PRCVEN)
		//2 - Sem PIS/COFINS
		AADD(aValorNet,SCK->CK_PRCVEN - (nVlrPis / SCK->CK_QTDVEN) - (nVlrCof / SCK->CK_QTDVEN))
		//3 - Sem PIS/COFINS e ICMS
		AADD(aValorNet,SCK->CK_PRCVEN - (nVlrPis / SCK->CK_QTDVEN) - (nVlrCof / SCK->CK_QTDVEN) - ;
			(nValICM  / SCK->CK_QTDVEN))
		//4 - Sem PIS/COFINS, ICMS e IPI
		AADD(aValorNet,SCK->CK_PRCVEN - (nVlrPis / SCK->CK_QTDVEN) - (nVlrCof / SCK->CK_QTDVEN) - ;
			(nValICM  / SCK->CK_QTDVEN) - (nValIPI / SCK->CK_QTDVEN))
		//5 - Sem PIS/COFINS, ICMS, IPI e ST
		AADD(aValorNet,SCK->CK_PRCVEN - (nVlrPis / SCK->CK_QTDVEN) - (nVlrCof / SCK->CK_QTDVEN) - ;
			(nValICM  / SCK->CK_QTDVEN) - (nValIPI / SCK->CK_QTDVEN) - nValSol)

		// Alert('Pr. NET '+SCK->CK_NUM+" - "+ AllTrim(STR(aValorNet[nOpcao])))

		RecLock("SCK",.f.)
		SCK->CK_XPRCNET := aValorNet[nOpcao]
		If (((SCK->CK_XPRCNET - SCK->CK_XCUSUNI) / SCK->CK_XPRCNET) * 100) > 999
			SCK->CK_XMARGEM := 999
		ElseIf (((SCK->CK_XPRCNET - SCK->CK_XCUSUNI) / SCK->CK_XPRCNET) * 100) < -999
			SCK->CK_XMARGEM := -999
		Else
			SCK->CK_XMARGEM := ((SCK->CK_XPRCNET - SCK->CK_XCUSUNI) / SCK->CK_XPRCNET) * 100
		EndIf
		SCK->(MsUnLock())

		SCK->(DbSkip())
	EndDo
	nTotFrete := MaFisRet(, "NF_FRETE")
	nTotVal   := MaFisRet(, "NF_TOTAL")

	MaFisEnd()
	MaFisRestore()

	RestArea(aAreaSCK)
	RestArea(aAreaSCJ)

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
