#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RetCusB9  ºAutor  ³ Osmar            º Data ³  11/05/2020   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Retorna o custo médio do produto                          º±±
±±º          ³  pesquisando no B9 caso seja zero e o parametro            º±±
±±º          ³  cGera = 'S' cria uma SC e cotação                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//Faz a busca no SB9 (último fechamento)
//não encontrou no B9, busca a última NF de entrada
//não encontrou no F1, busca o última pedido colocado
//não encontrou no C7, busca a última SC com cotação
//não encontrou no C1, se o segundo parametro = "S" gera SC e cotação para atualização do preço 

User Function RetCusB9(cCodigo,cGera)
	Local cQry     := ''
	Local nValor   := 0
	Local aAreaSC1 := SC1->(GetArea())
	Local cNumSC   := ""

	cQry := "Select B9_COD As CODIGO, B9_QINI As QTDE, B9_LOCAL As ARMAZ, B9_CM1 As CustoM, B9_DATA As DATA "
	cQry += "From "+ RetSQLTab("SB9") +" With(Nolock) "
	cQry += "Inner Join "+RetSQLTab("SB1") +" With(Nolock) On B1_FILIAL = '"+xFilial("SB1")+"' AND B9_FILIAL = '"+xFilial("SB9")+"' And B1_COD = B9_COD And SB1.D_E_L_E_T_ = '' And B9_LOCAL = B1_LOCPAD "
	cQry += "Where B9_FILIAL = '"+xFilial("SB9")+"' And B9_COD = '"+cCodigo+"' And SB9.D_E_L_E_T_ = '' And "
	cQry += "	   B9_DATA = ( Select MAX(B9_DATA) As B9_DATA "
	cQry += "				  From "+ RetSQLTab("SB9") +" With(Nolock) "
	cQry += "		          Where B9_FILIAL = '"+xFilial("SB9")+"' And B9_COD = '"+cCodigo+"' And D_E_L_E_T_='')"

	If Select("CUS") <> 0
		CUS->( dbCloseArea() )
	EndIf

	dbusearea(.t.,"TOPCONN",TCGenQRY(,,cQry),"CUS",.f.,.t.)
	nValor := CUS->CustoM
	CUS->(dbCloseArea())

	// Verificar NF de entrada
	IF Empty(nValor)

		cQry := " Select Top 1 D1_COD, D1_QUANT As QTDE, D1_CUSTO As Custo "
		cQry += " From "+RetSQLTab("SD1")+" With(Nolock) "
		cQry += " Where D1_FILIAL = '"+xFilial("SD1")+"' And D_E_L_E_T_ = '' And D1_TIPO = 'N' And D1_COD = '"+cCodigo+"'"
		cQry += " ORDER BY D1_NUMSEQ DESC "
		If Select("D1CUS") <> 0
			D1CUS->( dbCloseArea() )
		EndIf
		dbUseArea(.t.,"TOPCONN",TCGenQRY(,,cQry),"D1CUS",.f.,.t.)
		nValor := D1CUS->Custo / D1CUS->QTDE
		D1CUS->(dbCloseArea())
	EndIf

	// Verificar se já tem o PC colocado
	If Empty(nValor)
		cQry := "Select C7_PRODUTO, C7_PRECO As PRECO "
		cQry += "From " +RetSQLTab("SC7")+" With(Nolock) "
		cQry += "Where C7_FILIAL = '"+xFilial("SC7")+"' And D_E_L_E_T_ = '' And C7_PRODUTO = '"+cCodigo+"'"
		If Select("C7CUS") <> 0
			C7CUS->( dbCloseArea() )
		EndIf
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
		cQry += "	C1_NUM = C8_NUMSC And C1_ITEM = C8_ITEMSC And C1_COTACAO = C8_NUM And /*C8_PRECO > 0 And*/ SC8.D_E_L_E_T_ = '' "
		cQry += "Where C1_FILIAL = '01' And SC1.D_E_L_E_T_ = '' And C1_PRODUTO = '"+cCodigo+"'"
		cQry += "Order By C8_NUM Desc "
		If Select("C8CUS") <> 0
			C8CUS->( dbCloseArea() )
		EndIf
		DBUSEAREA(.t.,"TOPCONN",TCGenQry(,,cQry),"C8CUS",.f.,.t.)
		nValor := C8CUS->PRECO
		cNumSC := C8CUS->C1_NUM
	EndIf


	//Cria a SC para cotação
	If dDataBase > GetMV("MV_XGRVSC")
		IF Empty(nValor) .And. cGera == "S" .And. Empty(AllTrim(cNumSC))

			//Verifica se tem fornecedor para pode criar SC e Cotação
			//SA5->( dbSetOrder(2) )
			//If SA5->(dbSeek(xFilial()+cCodigo))
			cNum := GetSXENum("SC1","C1_NUM")
			SC1->(dbSetOrder(1))
			While SC1->(dbSeek(xFilial()+cNum))
				ConfirmSX8()
				cNum := GetSXENum("SC1","C1_NUM")
			EndDo
			ConfirmSX8()
			RecLock("SC1",.t.)
			SC1->C1_FILIAL   := xFilial("SC1")
			SC1->C1_NUM 	  := cNum
			SC1->C1_SOLICIT  := UsrFullName(RetCodUsr())
			SC1->C1_EMISSAO  := dDataBase
			SC1->C1_ITEM     := '0001'
			SC1->C1_PRODUTO  := cCodigo
			SC1->C1_DESCRI   := Posicione("SB1",1,xFilial("SB1")+cCodigo,"B1_DESC")
			SC1->C1_LOCAL    := Posicione("SB1",1,xFilial("SB1")+cCodigo,"B1_LOCPAD")
			SC1->C1_QUANT    := 1
			SC1->C1_QUJE     := 1
			SC1->C1_XOPER    := "99"
			SC1->C1_CC		  := "421004"
			SC1->C1_OBS      := "NÃO COMPRAR - APENAS COTAÇÃO PARA MARGEM DE VENDA"
			SC1->C1_MSBLQL   := "1"
			SC1->(MsUnLock())

			// Cria cotações SC8
			U_GERASC8B(cNum)

			//EndIf
		EndIf
	EndIf

	RestArea(aAreaSC1)
Return(nValor)

//
//Gera as cotações para a SC
//
User Function GeraSC8B(cNumSC)
	Local cNumero  := ""
	Local cProduto := ""
	Local aAreaSC8 := SC8->(GetArea())
	Local aAreaSA5 := SA5->(GetArea())
	Local aAreaSA2 := SA2->(GetArea())

	cNumero := GetSXENum("SC8","C8_NUM")

	SC8->(dbSetOrder(1))
	While SC8->(dbSeek(xFilial()+cNumero))
		ConfirmSX8()
		cNumero := GetSXENum("SC8","C8_NUM")
	EndDo
	ConfirmSX8()

	SC1->( dbSetOrder(1) )
	SC1->(dbSeek(xFilial()+cNumSC))
	SA5->( dbSetOrder(2) )

	While SC1->(!EOF()) .And. SC1->C1_NUM == cNumSC .AND. SC1->C1_FILIAL==xFILIAL('SC1')

		cProduto := SC1->C1_PRODUTO

		//Verifica se tem fornecedor cadastrado
		//(1) C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO+C8_ITEMGRD
		//(8) C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_FORNOME
		SA5->( dbSetOrder(2) )
		SC8->( dbSetOrder(8) )
		If SA5->(dbSeek(xFilial()+cProduto))
			While SA5->(!EOF()) .And. SA5->A5_PRODUTO == cProduto
				If !(SC8->(dbSeek(xFilial()+cNumero+SA5->A5_FORNECE+SA5->A5_LOJA)))
					RecLock("SC8",.t.)
					SC8->C8_FILIAL  := xFilial("SC8")
					SC8->C8_NUM     := cNumero
					SC8->C8_ITEM    := SC1->C1_ITEM
					SC8->C8_NUMPRO  := '01'
					SC8->C8_PRODUTO := cProduto
					SC8->C8_UM      := SC1->C1_UM
					SC8->C8_QUANT   := SC1->C1_QUANT
					SC8->C8_FORNECE := SA5->A5_FORNECE
					SC8->C8_LOJA    := SA5->A5_LOJA
					SC8->C8_FILENT  := SC1->C1_FILENT
					SC8->C8_EMISSAO := dDatabase
					SC8->C8_VALIDA  := dDatabase + 15
					SC8->C8_NUMSC   := SC1->C1_NUM
					SC8->C8_ITEMSC  := SC1->C1_ITEM
					SC8->C8_DATPRF  := dDatabase
					SC8->C8_IDENT   := SC1->C1_IDENT
					SC8->C8_MOEDA   := 1
					SC8->C8_CODORCA := '20050000'
					SC8->C8_TPDOC   := '1'
					SC8->C8_FORNOME := SA5->A5_NOMEFOR
					SC8->C8_WF      := .F.
					SC8->C8_XIMPORT := Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_IMPORT")

					SC8->(MsUnlock())
				ENDIF
				SA5->(dbSkip())
			EndDo
		Else
			//Gera cotação para fornecedor padrão
			SA2->( dbSetOrder(01) )
			SA2->(dbSeek(xFilial()+GetMV("MV_XFORPAD")))

			If !(SC8->(dbSeek(xFilial()+cNumero+SA2->A2_COD+SA2->A2_LOJA)))
				RecLock("SC8",.t.)
				SC8->C8_FILIAL  := xFilial("SC8")
				SC8->C8_NUM     := cNumero
				SC8->C8_ITEM    := SC1->C1_ITEM
				SC8->C8_NUMPRO  := '01'
				SC8->C8_PRODUTO := cProduto
				SC8->C8_UM      := SC1->C1_UM
				SC8->C8_QUANT   := SC1->C1_QUANT
				SC8->C8_FORNECE := SA2->A2_COD
				SC8->C8_LOJA    := SA2->A2_LOJA
				SC8->C8_FILENT  := SC1->C1_FILENT
				SC8->C8_EMISSAO := dDatabase
				SC8->C8_VALIDA  := dDatabase + 15
				SC8->C8_NUMSC   := SC1->C1_NUM
				SC8->C8_ITEMSC  := SC1->C1_ITEM
				SC8->C8_DATPRF  := dDatabase
				SC8->C8_IDENT   := SC1->C1_IDENT
				SC8->C8_MOEDA   := 1
				SC8->C8_CODORCA := '20050000'
				SC8->C8_TPDOC   := '1'
				SC8->C8_FORNOME := SA2->A2_NOME
				SC8->C8_WF      := .F.
				SC8->C8_XIMPORT := Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_IMPORT")
				SC8->(MsUnlock())
			Endif
		EndIf
		//Criou cotação para a SC
		If SC8->C8_NUMSC == SC1->C1_NUM
			RecLock("SC1",.F.)
			SC1->C1_COTACAO := cNumero
			SC1->(MsUnLock())

			U_FatMail1(cNumero,cProduto)

		EndIf

		SC1->(dbSkip())

	EndDo

	RestArea(aAreaSA2)
	RestArea(aAreaSA5)
	RestArea(aAreaSC8)

Return


/*
Envia email informando cotação pendente
*/

User Function FatMail1(cCotacao,cProduto)

	Local cMsg			:= ""
	Local cEmail		:= "osmar@opusvp.com.br"

	cMsg := "A cotação número: "+cCotacao +Chr(13)
	cMsg += "Produto: "+AllTrim(cProduto)+ " - "+Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_DESC") +Chr(13)
	cMsg += "Esta aguardando atualização para compor o custo do produto no processo de venda."

	Sleep(4000)

	U_EnvMailto("Cotação Pendente " ,cMsg,cEmail,"",)

Return









