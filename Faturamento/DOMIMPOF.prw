#Include "Protheus.ch"   
#include "FWPrintSetup.ch"

User Function DOMIMPOF()

	MsgRun("Imprimindo OF","Gerando OF",{|| DOMGeraOF() })

Return Nil

Static Function DOMGeraOF()
	
	Local lAdjustToLegacy 	:= .F.
	Local lDisableSetup  	:= .F.   
	Private oPrinter
	Private nI					:= 0
	Private nLin				:= 0
	Private nProdutos			:= 0
	Private nPagina			:= 1
	Private nTotPaginas		:= 0
	Private cDescProd			:= ""
	Private nValorTotal		:= 0
	Private nValorIpi			:= 0
	Private nX					:= 0
	Private nContador			:= 0
	Private nProdImpresso	:= 0
	Private nProdPagina		:= 0
	
	Private cLogo				:= "\SYSTEM\logoof.png"
	Private oFont8				:= TFont():New('Verdana',,-08,.F.,.F.)
	Private oFont9				:= TFont():New('Verdana',,-09,.F.,.F.)
	Private oFont10			:= TFont():New('Verdana',,-10,.F.,.F.)
	Private oFont12			:= TFont():New('Verdana',,-12,.F.,.F.)
	Private oFont15			:= TFont():New('Verdana',,-15,.F.,.F.)
	Private oFont10N			:= TFont():New('Verdana',,-10,.T.,.T.)
	Private oFont12N			:= TFont():New('Verdana',,-12,.T.,.T.)
	Private oFont15N			:= TFont():New('Verdana',,-15,.T.,.T.)
	Private oFont20N			:= TFont():New('Verdana',,-20,.T.,.T.)
	Private oFont30N			:= TFont():New('Verdana',,-30,.T.,.T.)
	
	MaFisIni(	SC5->C5_CLIENTE,;               // 1-Codigo Cliente/Fornecedor
			SC5->C5_LOJACLI,;                         // 2-Loja do Cliente/Fornecedor
			"C",;                         // 3-C:Cliente , F:Fornecedor
			SC5->C5_TIPO,;                         // 4-Tipo da NF
			SC5->C5_TIPOCLI,;                         // 5-Tipo do Cliente/Fornecedor
			MaFisRelImp("MTR700",{"SC5","SC6"}),;   // 6-Relacao de Impostos que suportados no arquivo
			,;                               // 7-Tipo de complemento
			,;                               // 8-Permite Incluir Impostos no Rodape .T./.F.
			"SB1",;               // 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
			"MTR700")            // 10-Nome da rotina que esta utilizando a funcao
	
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
	 
	oPrinter := FWMSPrinter():New(SC5->C5_NUM+".rel", 2, lAdjustToLegacy,, lDisableSetup, , , , , , .F., )
	
	oPrinter:SetResolution(72)
	oPrinter:SetPortrait()
	oPrinter:SetPaperSize(9) 
	
	If nProdutos % 11 > 8
		nTotPaginas := Int(nProdutos / 11) + 2
	Else
		nTotPaginas := Int(nProdutos / 11) + 1
	EndIf

	 
	If nTotPaginas == 1
		CabecOF(1)
		nProdPagina := 8
	Else
		CabecOF(2)
		nProdPagina := 11
	EndIf
		
		If SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
			While SC6->C6_NUM == SC5->C5_NUM .And. !(Eof())
				
				DbSelectArea("SB1")
				SB1->(DbSetOrder(1))
				SB1->(DbSeek(xFilial()+SC6->C6_PRODUTO))
	
				cDescProd := AllTrim(SB1->B1_DESCR1) + " " + AllTrim(SB1->B1_DESCR2) + " " + AllTrim(SB1->B1_DESCR3) + " " + AllTrim(SB1->B1_DESCR4)
				If Empty(cDescProd)
					cDescProd := SB1->B1_XDESC
				EndIf
				
				MaFisAdd(SC6->C6_PRODUTO, SC6->C6_TES, SC6->C6_QTDVEN, SC6->C6_PRCVEN, 0, "", "",, 0, 0, 0, 0, SC6->C6_VALOR, 0)
				
				oPrinter:Say(nLin,12,AllTrim(SC6->C6_ITEM),oFont9)
				oPrinter:Say(nLin,29,AllTrim(SC6->C6_PRODUTO),oFont9)
				oPrinter:Say(nLin,101,SubStr(cDescProd,1,45),oFont9)
				oPrinter:Say(nLin + 10,101,SubStr(cDescProd,46,45),oFont9)
				oPrinter:Say(nLin + 20,101,SubStr(cDescProd,91,45),oFont9)
				oPrinter:Say(nLin + 30,101,SubStr(cDescProd,135,45),oFont9)
				oPrinter:Say(nLin + 40,101,"Codigo do Cliente: " + SC6->C6_SEUCOD,oFont9)
				oPrinter:Say(nLin + 50,101,"Desenho do Cliente: " + SC6->C6_SEUDES,oFont9)
				oPrinter:Say(nLin,301,AllTrim(SC6->C6_UM),oFont9)
				oPrinter:Say(nLin,316,AllTrim(Transform(SC6->C6_QTDVEN,"@E 999,999,999.99")),oFont9)
				oPrinter:Say(nLin,371,"R$ " + AllTrim(Transform(SC6->C6_PRCVEN,"@E 999,999,999.99")),oFont9)
				oPrinter:Say(nLin,441,AllTrim(Str(SC6->C6_IPI)) + "%",oFont9)
				oPrinter:Say(nLin,461,"R$ " + AllTrim(Transform(SC6->C6_VALOR,PesqPict("SC6","C6_VALOR"))),oFont9)
				oPrinter:Say(nLin,541,DtoC(SC6->C6_DTFATUR),oFont9)
				If nContador <> 7
					oPrinter:Line(nLin+52,10,nLin+52,585,,"-1")
				EndIf
				nLin += 62
				
				nValorTotal += SC6->C6_VALOR
			
				nContador ++
				nProdImpresso++
				
				If nPagina == nTotPaginas
					If nProdutos == nProdImpresso
						RodapeOF(2)
					EndIf
				Else
					If (nProdImpresso % nProdPagina) == 0
						RodapeOF(1)
						nPagina++
						If nPagina == nTotPaginas
							CabecOF(1)
						Else
							CabecOF(2)
						EndIf
					ElseIf nProdImpresso == nProdutos
						RodapeOF(1)
						nPagina++
						CabecOF(1)
						RodapeOF(2)
					EndIf
				EndIf
			
				SC6->(DbSkip())
			EndDo
		EndIf
	 
	If nProdutos % 11 == 0
		RodapeOF(2)
	EndIf
			                                         
	If oPrinter:nModalResult == PD_OK
		MaFisEnd()
		oPrinter:Preview()
	EndIf


Return Nil      

Static Function RodapeOF(nOpc)

		If nOpc == 2                  
		
		
	  		MaFisAlt("NF_FRETE"   ,SC5->C5_FRETE)		
		
		
			oPrinter:Line(600,10,600,585)
			oPrinter:Say(610,12,"Descontos -->" + TransForm(SC5->C5_DESC1,PesqPict("SC5","C5_DESC1")) + "     " + TransForm(SC5->C5_DESC2,PesqPict("SC5","C5_DESC2")) + "     " + TransForm(SC5->C5_DESC3,PesqPict("SC5","C5_DESC3")) + "     " + TransForm(SC5->C5_DESC4,PesqPict("SC5","C5_DESC4")) + "     ",oFont12)
			oPrinter:Line(615,10,615,585)
			oPrinter:Say(625,12,"Local de Entrega:" + AllTrim(SA1->A1_ENDENT) + " - " + AllTrim(SA1->A1_BAIENT) + " - " + AllTrim(SA1->A1_MUNENT) + "/" + AllTrim(SA1->A1_ESTENT) + " - CEP: " + AllTrim(SA1->A1_CEPCOB),oFont9)
			oPrinter:Say(635,12,"Local de Cobranca: " + AllTrim(SA1->A1_ENDCOB) + " - " + AllTrim(SA1->A1_BAICOB) + " - " + AllTrim(SA1->A1_MUNCOB) + "/" + AllTrim(SA1->A1_ESTCOB) + " - CEP: " + AllTrim(SA1->A1_CEPCOB),oFont9)
			oPrinter:Line(640,10,640,585)
			oPrinter:Say(650,12,"Condicao de pagamento",oFont12)
			oPrinter:Say(660,12,Posicione("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,"E4_DESCRI"),oFont12)
			oPrinter:Line(640,180,665,180)
			oPrinter:Say(650,182,"Data de Emissao",oFont12)
			oPrinter:Say(660,182,DtoC(SC5->C5_EMISSAO),oFont12)
			oPrinter:Line(640,280,665,280)
			oPrinter:Say(650,282,"Total de Mercadorias: R$ " + AllTrim(TransForm(MaFisRet(,"NF_VALMERC"),PesqPict("SC6","C6_VALOR"))),oFont12) 
			oPrinter:Line(665,10,665,585)
			oPrinter:Say(675,12,"Reajuste:",oFont12)			
			oPrinter:Say(675,282,"IPI: R$ " + AllTrim(TransForm(MaFisRet(,"NF_VALIPI") ,PesqPict("SF2","F2_VALIPI"))),oFont12)
			oPrinter:Say(685,282,"Frete: R$ "+ AllTrim(TransForm(MaFisRet(,"NF_FRETE") ,PesqPict("SC6","C6_VALOR"))),oFont12)
			oPrinter:Say(675,402,"ST: R$ " + AllTrim(TransForm(MaFisRet(,"NF_VALSOL") ,PesqPict("SF2","F2_ICMSRET"))),oFont12)
			oPrinter:Say(685,402,"Difal: R$ "+ AllTrim(TransForm(MaFisRet(,"NF_DIFAL") ,PesqPict("SC6","C6_VALOR"))),oFont12)
			oPrinter:Line(665,280,765,280)
			oPrinter:Line(690,10,690,585)
			oPrinter:Say(700,12,"Inst. Especificacao Cliente",oFont12)
			oPrinter:Say(710,12,AllTrim(SC5->C5_ESP1),oFont12)
			oPrinter:Line(745,10,745,280)
			oPrinter:Say(700,282,"Total Geral: R$ "+ AllTrim(TransForm(MaFisRet(,"NF_TOTAL") ,PesqPict("SF2","F2_VALBRUT"))),oFont12)
			oPrinter:Line(705,280,705,585)
			oPrinter:Say(755,12,"Emitido por: " + AllTrim(LogUserName()),oFont12)
			oPrinter:Say(715,282,"       Aceite do Cliente     ",oFont12)
			oPrinter:Say(745,282,"  ___________________________",oFont12)
			oPrinter:Line(705,450,765,450)
			oPrinter:Say(715,452,"Obs do Frete: " + Iif(SC5->C5_FRET == "1","CIF","FOB"),oFont12)
			oPrinter:Say(725,452,"Transportadora",oFont12)
			oPrinter:Say(735,452,SubStr(SA4->A4_NOME,1,23),oFont12)
			oPrinter:Say(745,452,SubStr(SA4->A4_NOME,24,23),oFont12)
			oPrinter:Line(765,10,765,585)
			oPrinter:Say(775,12,"Motivo Rev.: " + SubStr(SC5->C5_MOTREVI,1,80),oFont12)
			oPrinter:Say(785,12,SubStr(SC5->C5_MOTREVI,81,80),oFont12)
			oPrinter:Say(825,12,"Impressao: " + DtoC(Date()) + " - " + Time(),oFont10)
			
		EndIf
		oPrinter:EndPage()

Return

Static Function CabecOF(nOpc) 

	Local nColuna := 0

		If nOpc == 1
			nColuna := 600
		Else
			nColuna := 830
		EndIf

		oPrinter:StartPage()
		
		oPrinter:Box(10,10,830,585)
		
		oPrinter:SayBitmap( 040, 60, cLogo, 120, 21)
		
		oPrinter:Say(20,440,"Rev.: " +Alltrim(SC5->C5_REVISAO) + " - Pag.: " + AllTrim(Str(nPagina)) + "/" + AllTrim(Str(nTotPaginas)) ,oFont8)
		oPrinter:Say(30,220,"ORDEM DE FORNECIMENTO: " + SC5->C5_NUM,oFont15N)
		oPrinter:Say(40,220,AllTrim(SA1->A1_NOME) + " - CNPJ: " + TransForm(AllTrim(SA1->A1_CGC),"@r 99.999.999/9999-99"),oFont12)
		oPrinter:Say(50,220,AllTrim(SA1->A1_END) + " - " + AllTrim(SA1->A1_BAIRRO) + " - " + AllTrim(SA1->A1_MUN) + "/" + AllTrim(SA1->A1_EST),oFont9)
		oPrinter:Say(60,220,"CEP: " + AllTrim(SA1->A1_CEP) + " - Telefone: " + AllTrim(SA1->A1_TEL),oFont9)
		oPrinter:Say(70,220,"Contato: " + AllTrim(SA1->A1_CONTATO),oFont9)
		
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
       