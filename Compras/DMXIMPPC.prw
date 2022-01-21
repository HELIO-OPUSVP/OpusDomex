#Include "Protheus.ch"
#include "FWPrintSetup.ch"

User Function DMXIMPPC(nOpc)

	If nOpc == 1

		MsgRun("Imprimindo PC","Gerando PC",{|| DOMGeraPC(nOpc) })

	Else

	DomGeraPC(nOpc)

EndIf

Return Nil

Static Function DOMGeraPC(nOpc)

	Local lAdjustToLegacy 	:= .F.
	Local lDisableSetup  	:= .F.
	Local cNumPedido		:= ""
	Private lRoda :=.F.
	Private oPrinter
	Private nI				:= 0
	Private nLin				:= 0
	Private nProdutos			:= 0
	Private nPagina			:= 1
	Private nTotPaginas		:= 0
	Private cDescProd			:= ""
	Private nValorTotal		:= 0
	Private nValorIpi			:= 0
	Private nX				:= 0
	Private nContador			:= 0
	Private nProdImpresso		:= 0
	Private nProdPagina			:= 0
	
	Private nValDespesas			:= 0
	Private nValImpostos			:= 0

	Private cLogo			:= "\SYSTEM\logopc.png"
	Private oFont8		:= TFont():New('Verdana',,-08,.F.,.F.)
	Private oFont9		:= TFont():New('Verdana',,-09,.F.,.F.)
	Private oFont10		:= TFont():New('Verdana',,-10,.F.,.F.)
	Private oFont12		:= TFont():New('Verdana',,-12,.F.,.F.)
	Private oFont15		:= TFont():New('Verdana',,-15,.F.,.F.)
	Private oFont10N	:= TFont():New('Verdana',,-10,.T.,.T.)
	Private oFont12N	:= TFont():New('Verdana',,-12,.T.,.T.)
	Private oFont15N	:= TFont():New('Verdana',,-15,.T.,.T.)
	Private oFont20N	:= TFont():New('Verdana',,-20,.T.,.T.)
	Private oFont30N	:= TFont():New('Verdana',,-30,.T.,.T.)

	Default nOpc := 1

	/*
	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
	
	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))
	If SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
		While SC6->C6_NUM == SC5->C5_NUM .And. !(Eof())
			nProdutos ++
			SC6->(DbSkip())
		EndDo
	EndIf
	
	DbSelectArea("SA4")
	SA4->(DbSetOrder(1))
	SA4->(DbSeek(xFilial()+SC5->C5_TRANSP))
	*/

	If SC7->C7_CONAPRO <> 'L'
		Alert("Pedido nao aprovado, nao e possivel a impressao")
		Return
	EndIf

	cNumPedido := SC7->C7_NUM

	If nOpc == 1
		oPrinter := FWMSPrinter():New(SC7->C7_NUM+".rel", 2, lAdjustToLegacy,, lDisableSetup, , , , , , .F., )
	ElseIf nOpc == 2
		oPrinter := FWMSPrinter():New(SC7->C7_NUM+".rel", 6, lAdjustToLegacy,, .T., , , , , , .F.,.F. )
	EndIf

	oPrinter:SetResolution(72)
	oPrinter:SetPortrait()
	oPrinter:SetPaperSize(9)

	If nOpc == 2
		oPrinter:cPathPDF :="\pedido_compra\"
		oPrinter:cFilePrint := "\pedido_compra\"+SC7->C7_NUM +".rel"
	EndIf

	SC7->(DbSetOrder(1))

	If SC7->(DbSeek(xFilial("SC7")+SC7->C7_NUM))
		While SC7->C7_NUM == cNumPedido .And. !(Eof())
			nProdutos ++
			SC7->(DbSkip())
		EndDo
	EndIf

	If nProdutos % 14 > 10
		nTotPaginas := Int(nProdutos / 14) + 2
	Else
		nTotPaginas := Int(nProdutos / 14) + 1
	EndIf

	SC7->(DbGoTop())
	SC7->(DbSeek(xFilial("SC7")+cNumPedido))

	If nTotPaginas == 1
		CabecPC(1)
		nProdPagina := 10
	Else
		CabecPC(2)
		nProdPagina := 14
	EndIf


	SC7->(DbGoTop())

	If SC7->(DbSeek(xFilial("SC7")+cNumPedido))
		While SC7->C7_NUM == cNumPedido .And. !(Eof())

			DbSelectArea("SB1")
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial()+SC7->C7_PRODUTO))

			cDescProd := AllTrim(SB1->B1_DESCR1) + " " + AllTrim(SB1->B1_DESCR2) + " " + AllTrim(SB1->B1_DESCR3) + " " + AllTrim(SB1->B1_DESCR4)

			//		MaFisAdd(SC6->C6_PRODUTO, SC6->C6_TES, SC6->C6_QTDVEN, SC6->C6_PRCVEN, 0, "", "",, 0, 0, 0, 0, SC6->C6_VALOR, 0)

			oPrinter:Say(nLin,11,AllTrim(SC7->C7_ITEM),oFont9)
			oPrinter:Say(nLin,29,AllTrim(SC7->C7_PRODUTO),oFont9)
			oPrinter:Say(nLin ,101,SubStr(cDescProd,1,45),oFont9)
			oPrinter:Say(nLin + 10,101,SubStr(cDescProd,46,45),oFont9)
			oPrinter:Say(nLin + 20,101,SubStr(cDescProd,91,45),oFont9)
			oPrinter:Say(nLin + 30,101,SubStr(cDescProd,135,45),oFont9)
			oPrinter:Say(nLin,302,AllTrim(SC7->C7_UM),oFont9)
			oPrinter:Say(nLin,316,AllTrim(Transform(SC7->C7_QUANT,"@E 999,999,999.99")),oFont9)
			oPrinter:Say(nLin,371,"R$ " + AllTrim(Transform(SC7->C7_PRECO,"@E 999,999,999.9999")),oFont9)
			oPrinter:Say(nLin,441,AllTrim(Str(SC7->C7_IPI)) + "%",oFont9)
			oPrinter:Say(nLin,461,"R$ " + AllTrim(Transform(SC7->C7_TOTAL,PesqPict("SC6","C6_VALOR"))),oFont9)
			oPrinter:Say(nLin,541,DtoC(SC7->C7_DATPRF),oFont9)
			If nContador <> 7
				oPrinter:Line(nLin+40,10,nLin+40,585,,"-1")
			EndIf
			nLin += 50

			nValorTotal += SC7->C7_TOTAL
			nValDespesas += SC7->C7_DESPESA
			nValImpostos += SC7->C7_VALIPI

			nContador ++
			nProdImpresso++

			If nPagina == nTotPaginas
				If nProdutos == nProdImpresso
					RodapePC(2)
				EndIf
			Else
				If (nProdImpresso % nProdPagina) == 0
					RodapePC(1)
					nPagina++
					If nPagina == nTotPaginas
						CabecPC(1)
					Else
						CabecPC(2)
					EndIf
				ElseIf nProdImpresso == nProdutos
					RodapePC(1)
					nPagina++
					CabecPC(1)
					RodapePC(2)
				EndIf
			EndIf

			SC7->(DbSkip())
		EndDo
	EndIf

	IF lRoda ==.F.
		RodapePC(2)
	ENDIF

	If nOpc == 1
		If oPrinter:nModalResult == PD_OK
			//MaFisEnd()
			oPrinter:Preview()
		EndIf
	ElseIf nOpc == 2
		oPrinter:Preview()
	EndIf


Return Nil

Static Function RodapePC(nOpc)

	Local cAprovadores := ""

	If nOpc == 2
		lRoda :=.T.
		oPrinter:Line(600,10,600,585)
		oPrinter:Say(610,12,"Descontos -->" + TransForm(SC7->C7_DESC,PesqPict("SC7","C7_DESC")) + "     " + TransForm(SC7->C7_DESC1,PesqPict("SC7","C7_DESC1")) + "     " + TransForm(SC7->C7_DESC2,PesqPict("SC7","C7_DESC2")) + "     " + TransForm(SC7->C7_DESC3,PesqPict("SC7","C7_DESC3")) + "     ",oFont12)
		oPrinter:Line(615,10,615,585)
		oPrinter:Say(625,12,"Local de Entrega:" + AllTrim(SM0->M0_ENDENT) + " - " + AllTrim(SM0->M0_BAIRENT) + " - " + AllTrim(SM0->M0_CIDENT) + "/" + AllTrim(SM0->M0_ESTENT) + " - CEP: " + AllTrim(SM0->M0_CEPCOB) + " - CNPJ: " + AllTrim(SM0->M0_CGC) + " - IE: " + AllTrim(SM0->M0_INSC) ,oFont9)
		oPrinter:Say(635,12,"Local de Cobranca: " + AllTrim(SM0->M0_ENDCOB) + " - " + AllTrim(SM0->M0_BAIRCOB) + " - " + AllTrim(SM0->M0_CIDCOB) + "/" + AllTrim(SM0->M0_ESTCOB) + " - CEP: " + AllTrim(SM0->M0_CEPCOB) + " - CNPJ: " + AllTrim(SM0->M0_CGC) + " - IE: " + AllTrim(SM0->M0_INSC),oFont9)
		oPrinter:Line(640,10,640,585)
		oPrinter:Say(650,12,"Condicao de pagamento",oFont12)
		oPrinter:Say(660,12,Alltrim(Posicione("SE4",1,xFilial("SE4")+SC7->C7_COND,"E4_DESCRI")),oFont12)
		oPrinter:Line(640,180,665,180)
		oPrinter:Say(650,182,"Data de Emissao",oFont12)
		oPrinter:Say(660,182,Alltrim(DtoC(SC7->C7_EMISSAO)),oFont12)
		oPrinter:Line(640,280,665,280)
		oPrinter:Say(650,282,"Total de Mercadorias: R$ " + AllTrim(TransForm(nValorTotal,PesqPict("SC7","C7_TOTAL"))),oFont12)
		oPrinter:Say(660,282,"Total com Impostos: R$ " + AllTrim(TransForm(nValImpostos+nValorTotal,PesqPict("SC7","C7_TOTAL"))),oFont12)
		oPrinter:Line(665,10,665,585)
		oPrinter:Say(675,12,"Reajuste:",oFont12)
		oPrinter:Say(675,282,"IPI: R$ "  + AllTrim(TransForm(SC7->C7_VALIPI,PesqPict("SC7","C7_VALIPI"))),oFont12) //AllTrim(TransForm(SC7->C7_VALIPI,PesqPict("SC7","C7_VALIPI"))),oFont12)
		oPrinter:Say(685,282,"Frete: R$ "+ AllTrim(TransForm(SC7->C7_VALFRE,"@E 999,999.99")),oFont12)//AllTrim(TransForm(SC7->C7_VALFRE,PesqPict("SC7","C7_VALFRE"))),oFont12)
		oPrinter:Say(675,402,"ICMS: R$ " + AllTrim(TransForm(SC7->C7_VALICM,"@E 999,999.99")),oFont12)//AllTrim(TransForm(SC7->C7_VALICM,PesqPict("SC7","C7_VALICM"))),oFont12)
		oPrinter:Say(685,402,"Despesas: R$ "+ AllTrim(TransForm(nValDespesas,"@E 999,999.99")),oFont12)
		oPrinter:Line(665,280,765,280)
		oPrinter:Line(690,10,690,585)
		oPrinter:Say(700,12,"Observacoes",oFont12)
		oPrinter:Say(710,12,AllTrim(SC7->C7_OBS),oFont12)
		oPrinter:Line(745,10,745,280)
		oPrinter:Say(700,282,"Total Geral: R$ "+ AllTrim(TransForm(nValorTotal ,PesqPict("SC7","C7_TOTAL"))),oFont12)
		oPrinter:Line(705,280,705,585)
		//Ajustador por Jackson Santos - Conforme solicitação do usuário para atender o chamado 013001
		//Indicando que deve ser coloca do nome do comprador.
		//oPrinter:Say(755,12,"Emitido por: " + AllTrim(LogUserName()),oFont12)
		oPrinter:Say(755,12,"Emitido por: " + Alltrim(Substr(UsrRetName(SC7->C7_USER),1,15)),oFont12)

		oPrinter:Say(715,282,"     Aceite do Fornecedor    ",oFont12)
		oPrinter:Say(745,282,"  ___________________________",oFont12)
		oPrinter:Line(705,450,765,450)
		oPrinter:Say(715,452,"Obs do Frete: " + Iif(SC7->C7_TPFRETE == "C","CIF","FOB"),oFont12)
		//oPrinter:Say(725,452,"Transportadora",oFont12)
		//oPrinter:Say(735,452,SubStr(SA4->A4_NOME,1,23),oFont12)
		//oPrinter:Say(745,452,SubStr(SA4->A4_NOME,24,23),oFont12)
		oPrinter:Line(765,10,765,585)
		//oPrinter:Say(775,12,"Motivo Rev.: " + SubStr(SC5->C5_MOTREVI,1,80),oFont12)
		//oPrinter:Say(785,12,SubStr(SC5->C5_MOTREVI,81,80),oFont12)
		oPrinter:Say(800,12,"NOTA: So aceitaremos a mercadoria se na sua Nota Fiscal constar o numero de nosso pedido de compra.",oFont10)

		DbSelectArea("SCR")
		SCR->(DbSetOrder(1))
		If SCR->(DbSeek(xFilial("SCR")+"PC"+SC7->C7_NUM))
			While SCR->(!Eof()) .And. AllTrim(SCR->CR_NUM) == AllTrim(SC7->C7_NUM)
				cAprovadores += UsrRetName(SCR->CR_USER) + " - "
				SCR->(DbSkip())
			EndDo
		EndIf

		oPrinter:Say(815,12,"Aprovador: " + cAprovadores ,oFont10)
		oPrinter:Say(825,12,"Impressao: " + DtoC(Date()) + " - " + Time(),oFont10)

	EndIf
	oPrinter:EndPage()

Return

Static Function CabecPC(nOpc)

	Local nColuna := 0

	If nOpc == 1
		nColuna := 600
	Else
		nColuna := 830
	EndIf

	oPrinter:StartPage()

	oPrinter:Box(10,10,830,585)

	oPrinter:SayBitmap( 040, 60, cLogo, 120, 21)

	DbSelectArea("SA2")
	SA2->(DbSetOrder(1))
	SA2->(DbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA))

	oPrinter:Say(20,540,"Pag.: " + AllTrim(Str(nPagina)) + "/" + AllTrim(Str(nTotPaginas)) ,oFont8)
	oPrinter:Say(30,220,"PEDIDO DE COMPRA: " + SC7->C7_NUM,oFont15N)
	oPrinter:Say(40,220,AllTrim(SA2->A2_NOME) + " - I.E.: " + AllTrim(SA2->A2_INSCR),oFont12)
	oPrinter:Say(50,220,AllTrim(SA2->A2_END) + " - " + AllTrim(SA2->A2_BAIRRO) + " - " + AllTrim(SA2->A2_MUN) + "/" + AllTrim(SA2->A2_EST) + " - CGC/CPF: " + AllTrim(SA2->A2_CGC) ,oFont9)
	oPrinter:Say(60,220,"CEP: " + AllTrim(SA2->A2_CEP) + " - Telefone: " + AllTrim("("+Substr(SA2->A2_DDD,1,3)+") "+Substr(SA2->A2_TEL,1,15)) + " - Cel: " + AllTrim("("+Substr(SA2->A2_DDD,1,3)+") "+Substr(SA2->A2_TEL,1,15)),oFont9)


	oPrinter:Say(70,220,"Contato: " + AllTrim(SA2->A2_CONTATO),oFont9)
	//oPrinter:Say(78,460,"Data de Emissao: " + DtoC(SC7->C7_EMISSAO))
	oPrinter:Line(81,10,81,585)

	oPrinter:Say(90,12,"It.",oFont10N)
	oPrinter:Line(81,28,nColuna,28)
	oPrinter:Say(90,29,"Codigo",oFont10N)
	oPrinter:Line(81,100,nColuna,100)
	oPrinter:Say(90,101,"Descricao do Material",oFont10N)
	oPrinter:Line(81,300,nColuna,300)
	oPrinter:Say(90,301,"UM",oFont10N)
	oPrinter:Line(81,314,nColuna,314)
	oPrinter:Say(90,315,"Quantidade",oFont10N)
	oPrinter:Line(81,370,nColuna,370)
	oPrinter:Say(90,371,"Valor Unitario",oFont10N)
	oPrinter:Line(81,440,nColuna,440)
	oPrinter:Say(90,441,"IPI",oFont10N)
	oPrinter:Line(81,460,nColuna,460)
	oPrinter:Say(90,461,"Valor Total",oFont10N)
	oPrinter:Line(81,540,nColuna,540)
	oPrinter:Say(90,541,"Entrega",oFont10N)

	oPrinter:Line(93,10,93,585)

	nLin := 105


Return
