#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RetCust   ºAutor  ³ Osmar / Helio   º Data ³  27/02/2020    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Retorna o custo do produto                                º±±
±±º          ³  pela estrutura e último custo médio                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*--------------------------------------------------------------------------*
User Function  RetCust(cProduto,cGrvSC)
	*--------------------------------------------------------------------------*
	Local aRetorno   := {}
	Local nCusTotal  := 0

	PRIVATE aEstruPA   := {}
	Private aCustErros := {}
	PRIVATE nQtdBase   := 1
	PRIVATE cComp      := ''
	PRIVATE nQtdComp   := 0
	Private nQtdPai    := 1
	Private nCusto     := 0
	Private cGeraSC    := cGrvSC
	Private aAreaGER   := GetArea()
	Private aAreaSG1_2 := SG1->( GetArea() )
	Private lOk        := .T.

	SG1->( dbSetOrder(1) )
	SG1->( dbSeek(xFilial() + cProduto ))

	ExplCusSG1(cProduto,cProduto,1,@nCusTotal)

	RestArea(aAreaSG1_2)
	RestARea(aAreaGER)

	AADD(aRetorno,nCusTotal)

	If lOk
		AADD(aRetorno,"1") //Todos tem custo
	else
		AADD(aRetorno,"2") //Há itens com custo zero
	EndIf

//For w:=1 To Len(aEstruPA)  
//	RecLock("ZZF",.T.)
//	ZZF_FILIAL := xFilial("ZZF")
//	ZZF_ORIGEM := "TST"
//	ZZF_NUMERO := "290122"
//	ZZF_ITEM  := "00"
//	ZZF_COD   := AllTrim(aEstruPA[w,2])
//	ZZF_DATA  := dDataBase
//	ZZF_PRCVEN := aEstruPA[w,3]			//Qtde na estrutura
//	ZZF_CUSUNI := aEstruPA[w,4] 		//Custo médio
//	ZZF_STATUS := '1'
//	ZZF_PRCNET := aEstruPA[w,3] * aEstruPA[w,4]  //Custo total
//	ZZF_ZZF_MARGEM := 0
//	ZZF_OBS   := AllTrim(aEstruPA[w,1])   //Cod Pai
//	ZZF->(MsUnLock())
//Next


RETURN aRetorno

//
//Faz a explosão da estrutura do produto
//
Static Function ExplCusSG1(cProduto,cCod,nQtde,nCusTotal)

	Local aAreaSG1
	Local cComponente  //alteracao

	SG1->(DbSeek(xFilial() + cCod))

	While xFilial("SG1") == SG1->G1_FILIAL .and. AllTrim(cCod) == AllTrim(SG1->G1_COD) .And. SG1->(!Eof())

		If  (SG1->G1_INI <= dDataBase .And. SG1->G1_FIM >= dDataBase)

			aAreaSG1    := SG1->(GetArea())
			cComponente := SG1->G1_COMP
			nG1_QTDE    := SG1->G1_QUANT

			If SG1->( DbSeek( xFilial() + cComponente ) ) //é PI
				ExplCusSG1(cProduto,cComponente,(nQtde*nG1_QTDE),@nCusTotal)
			EndIf

			nCusto :=  U_RetCusB9(cComponente,cGeraSC)

			AADD(aEstruPA,{cProduto,cComponente,(nG1_QTDE*nQtde),nCusto})

			SB1->(dbSeek(xFilial()+cComponente))
			If SB1->B1_TIPO <> "PI"
				nCusTotal += (nCusto * nG1_QTDE * nQtde)
			Endif

			//Guarda o produto com custo zerado
			If nCusto = 0 .And. (cProduto <> SG1->G1_COMP)
				//AADD(aCustErros,{SG1->G1_COMP,'Componente sem custo!!'})
				lOk := .F.
			EndIf

			SG1->(RestArea(aAreaSG1))
		EndIf
		SG1->(DbSkip())
	EndDo

Return




/*
//
//Busca o último custo médio do item no SB9
//
Static Function fBuscaCusto(cCodigo)
	Local cQry   := ''
	Local nValor := 0

	cQry := "Select B9_COD As CODIGO, B9_QINI As QTDE, B9_LOCAL As ARMAZ, B9_CM1 As CustoM, B9_DATA As DATA "
	cQry += "From "+ RetSQLTab("SB9") +" With(Nolock) "
	cQry += "Inner Join "+RetSQLTab("SB1") +" With(Nolock) On B1_FILIAL = B9_FILIAL And B1_COD = B9_COD And SB1.D_E_L_E_T_ = '' And B9_LOCAL = B1_LOCPAD "
	cQry += "Where B9_FILIAL = '"+xFilial("SB9")+"' And B9_COD = '"+cCodigo+"' And SB9.D_E_L_E_T_ = '' And "
	cQry += "	   B9_DATA = ( Select MAX(B9_DATA) As B9_DATA "
	cQry += "				  From "+ RetSQLTab("SB9") +" With(Nolock) "
	cQry += "		          Where B9_FILIAL = '"+xFilial("SB9")+"' And B9_COD = '"+cCodigo+"' And D_E_L_E_T_='')"
	dbusearea(.t.,"TOPCONN",TCGenQRY(,,cQry),"CUS",.f.,.t.)
	nValor := CUS->CustoM
	CUS->(dbCloseArea())

	// Verificar NF de entrada
	IF Empty(nValor)
		cQry := " Select D1_COD, D1_CUSTO,D1_QUANT As Custo "
		cQry += " From "+RetSQLTab("SD1")+" With(Nolock) "
		cQry += " Where D1_FILIAL = '"+xFilial("SD1")+"' And D_E_L_E_T_ = '' And D1_TIPO = 'N' And D1_COD = '"+cCodigo+"'"
		cQry += " ORDER BY D1_NUMSEQ DESC "
		dbUseArea(.t.,"TOPCONN",TCGenQRY(,,cQry),"D1CUS",.f.,.t.)
		nValor := D1CUS->Custo/D1CUS->D1_QUANT
		D1CUS->(dbCloseArea())
	EndIf

	// Verificar se já tem o PC colocado
	If Empty(nValor)
		cQry := "Select C7_PRODUTO, C7_PRECO As PRECO "
		cQry += "From " +RetSQLTab("SC7")+" With(Nolock) "
		cQry += "Where C7_FILIAL = '"+xFilial("SC7")+"' And D_E_L_E_T_ = '' And C7_PRODUTO = '"+cCodigo+"'"
		dbUseArea(.t.,"TOPCONN",TCGenQRY(,,cQry),"C7CUS",.f.,.t.)
		nValor := C7CUS->PRECO   // Futuramente, verificar necessidade de retirar os impostos
		C7CUS->(dbCloseArea())
	EndIf

	// Verificar se já tem SC para esse produto com cotação e com valor
	If Empty(nValor)
		cQry := "Select Top 1 C1_NUM, C1_PRODUTO, C1_QUANT, C8_PRECO As PRECO, "
		cQry += " 		C8_NUM As COTACAO, C8_FORNECE "
		cQry += "From "+RetSQLTab("SC1")+" With(Nolock) "
		cQry += "Inner Join "+RetSQLTab("SC8")+" With(Nolock) On C1_FILIAL = C8_FILIAL And C1_PRODUTO = C8_PRODUTO And "
		cQry += "	C1_NUM = C8_NUMSC And C1_ITEM = C8_ITEMSC And C1_COTACAO = C8_NUM And C8_PRECO > 0 And SC8.D_E_L_E_T_ = '' "
		cQry += "Where C1_FILIAL = '01' And SC1.D_E_L_E_T_ = '' And C1_PRODUTO = '"+cCodigo+"'"
		cQry += "Order By C8_NUM Desc "
		dbUseAre(.t.,"TOPCONN",TCGenQry(,,cQry),"C8CUS",.f.,.t.)
		nValor := C8CUS->PRECO
	EndIf

	//Cria a SC para cotação
	IF Empty(nValor)
		cNum := GetSXENum("SC1","C1_NUM")
		SC1->(dbSetOrder(1))
		While SC1->(dbSeek(xFilial()+cNum))
			ConfirmSX8()
			cNum := GetSXENum("SC1","C1_NUM")
		EndDo
		ConfirmSX8()
		RecLock("SC1",.t.)
		SC1->C1_FILIAL   := xFilial("SC1")
		SC1->C1_NUM 	 := cNum
		SC1->C1_SOLICIT  := UsrFullName(RetCodUsr())
		SC1->C1_EMISSAO  := dDataBase
		SC1->C1_ITEM     := '0001'
		SC1->C1_PRODUTO  := cCodigo
		SC1->C1_QUANT    := 1
		SC1->C1_XOPER    := "99"
		SC1->C1_CC		 := "421004"
		SC1->C1_OBS      := "NÃO COMPRAR - APENAS COTAÇÃO PARA MARGEM DE VENDA"
		SC1->C1_MSBLQL   := "1"
		SC1->(MsUnLock())

		// Criar aqui as cotações SC8
	EndIf

Return(nValor)
*/
