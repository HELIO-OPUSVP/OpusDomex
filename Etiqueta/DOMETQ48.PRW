#include "protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DOMETQ48 ºAutor  ³ Ricardo Roda       º Data ³  11/02/2022 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ 	    Etiqueta para Embalagem Ericsson via Zebra            º±±
±±º          ³                (Substituta Layout 097)                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DOMETQ48(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,lColetor,cNumSerie,cNumPeca,cFila)

	Local aPar       := {}
	Local aRet       := {}
	Local nVar       := 0
	Local MVPAR02    := 1         //Qtd Embalagem
	Local MVPAR03    := 1         //Qtd Etiquetas
	Local aRetAnat   := {}        //Codigos Anatel, Array
	Local aCodAnat   := {}        //Codigos Anatel, Array
	Local cCdAnat1   := ""        //Codigo Anatel 1
	Local cCdAnat2   := ""        //Codigo Anatel 2
	Local cCdAnat3   := ""        //Codigo Anatel 3
	Local x
	Local _nX
	Private lAchou   := .T.
	Private lNokia   := .F.
	Private aGrpAnat := {}     //Codigos Anatel Agrupados
	Private lFatSZY  := .T.
	Private _aArq	  :={}
	Private aCodEtq	  :={}
	Private cLocImp  := ""

	private aPar     	:= {}
	private aRetPar   := {}

	Default cNumOP   := ""
	Default cNumSenf := ""
	Default nQtdEmb  := 0
	Default nQtdEtq  := 0
	Default cNivel   := ""
	Default aFilhas  := {}
	Default cNumSerie := ""
	Default cNumPeca  := ""
	Default cFila := "" 

	cLocImp  := cFila

	MVPAR02:= nQtdEmb   //Qtd Embalagem
	MVPAR03:= nQtdEtq   //Qtd Etiquetas /*revisar*/

	If cNivel == '2'
		If Empty(aFilhas)
			cAssunto  := "Chamada da etiqueta layout 097 com o afilhas vazio."
			cTexto    := "OP: " + cNumOP
			cPara     := "denis.vieira@rdt.com.br;michel@opusvp.com.br;helio@opusvp.com.br"
			cCC       := ""
			cArquivo  := ""

			U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
		EndIf
	EndIf

	If !Empty(cNumOP)
		//Localiza SC2
		SC2->(DbSetOrder(1))
		If lAchou .And. SC2->(!DbSeek(xFilial("SC2")+cNumOP))
			Alert("Numero O.P. "+AllTrim(cNumOP)+" não localizada!")
			lAchou := .F.
		EndIf

		If !Empty(SC2->C2_PEDIDO)
			//Localiza SC5
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

			//Localiza SC6
			SZY->(DbSetOrder(1))
			If lAchou .And. SZY->(DbSeek(xFilial()+SC2->C2_PEDIDO+SC2->C2_ITEMPV))
				While !SZY->( EOF() ) .and. SZY->ZY_PEDIDO == SC2->C2_PEDIDO .and. SZY->ZY_ITEM == SC2->C2_ITEMPV .AND. !Empty(SZY->ZY_NOTA)
					SZY->( dbSkip() )
				End
				If !SZY->( EOF() ) .and. SZY->ZY_PEDIDO == SC2->C2_PEDIDO .and. SZY->ZY_ITEM == SC2->C2_ITEMPV .AND. Empty(SZY->ZY_NOTA)

				Else
					//Alert("Programação de Faturamento não encontrado para o item.")
					lFatSZY := .F.
				EndIf
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

	If !Empty(SC2->C2_PEDIDO)
		//Localiza SA1
		SA1->(DbSetOrder(1))
		If lAchou .And. SA1->(!DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
			Alert("Cliente "+SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI+" não localizado!")
			lAchou := .F.
		EndIf
	EndIf

//Localiza SB1
//posicionar produto de acordo com OP ou SENF
	If !Empty(cNumOp) .And. Empty(cNumSenf)
		SB1->(DbSetOrder(1))
		If lAchou .And. SB1->(!DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
			Alert("Produto "+AllTrim(SC2->C2_PRODUTO)+" não localizado!")
			lAchou := .F.
		EndIf
	ElseIf !Empty(cNumSenf)
		SB1->(DbSetOrder(1))
		If lAchou .And. SB1->(!DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
			Alert("Produto "+AllTrim(SC6->C6_PRODUTO)+" não localizado!")
			lAchou := .F.
		EndIf
	EndIf

//
	If lAchou
		aRetAnat := U_fCodNat(SB1->B1_COD)
		lAchou   := aRetAnat[1]
		aCodAnat := aRetAnat[2]

		If lAchou .And. Empty(SB1->B1_XXNANAT)
			Alert("Não foi preenchido o campo 'Nº Codigo Anatel' para o produto: "+AllTrim(SB1->B1_COD) + Chr(13)+Chr(10)+ "[B1_XXNANAT]")
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
			cCdAnat3 := ""

		Case Val(SB1->B1_XXNANAT) == 1 .And. Len(aGrpAnat) == 1
			cCdAnat1 := aGrpAnat[1]
			cCdAnat2 := ""
			cCdAnat3 := ""

		Case Val(SB1->B1_XXNANAT) == 2 .And. Len(aGrpAnat) == 1
			cCdAnat1 := aGrpAnat[1]
			cCdAnat2 := aGrpAnat[1]
			cCdAnat3 := ""

		Case Val(SB1->B1_XXNANAT) == 3 .And. Len(aGrpAnat) == 2
			cCdAnat1 := aGrpAnat[1]
			cCdAnat2 := aGrpAnat[2]
			cCdAnat3 := ""

		Case Val(SB1->B1_XXNANAT) == 4 .And. Len(aGrpAnat) == 3
			cCdAnat1 := aGrpAnat[1]
			cCdAnat2 := aGrpAnat[2]
			cCdAnat3 := aGrpAnat[3]

		OtherWise
			cCdAnat1 := " E R R O "
			cCdAnat2 := " E R R O "
			If !Empty(cNumOP)
				Alert("Erro no tratamento dos codigos ANATEL (DOMETQ03)."+Chr(13)+Chr(10)+"Favor procurar TI e informar dificuldade! "+Chr(13)+Chr(10)+"OP:"+cNumOP)
			ElseIf !Empty(cNumSenf)
				Alert("Erro no tratamento dos codigos ANATEL (DOMETQ03)."+Chr(13)+Chr(10)+"Favor procurar TI e informar dificuldade! "+Chr(13)+Chr(10)+"Senf:"+cNumSenf)
			EndIf
			lAchou   := .F.

		EndCase

	EndIf

//Valida se Campo Descricao do Produto está preenchido
	If lAchou .And. Empty(SB1->B1_DESC)
		Alert("Campo Descricao do Produto não está preenchido no cadastro do produto! "+Chr(13)+Chr(10)+"[B1_DESC]")
		lAchou := .F.
	EndIf

/**/
//Valida se Campo PN HUAWEI está preenchido
	If !Empty(SC2->C2_PEDIDO)
		If lAchou .And. Empty(SC6->C6_SEUCOD)
			Alert("Campo PN não está preenchido no Item do Pedido de Vendas! "+Chr(13)+Chr(10)+"[C6_SEUCOD]")
			lAchou := .F.
		EndIf
	EndIf

//Em 25/02/2014 foi definido que esse campo não será obrigatorio para esta etiqueta
//Valida se Campo PN HUAWEI está preenchido
//If lAchou .And. Empty(SC6->C6_SEUDES)
//	Alert("Campo ITEM PEDIDO CLIENTE não está preenchido no Item do Pedido de Vendas! "+Chr(13)+Chr(10)+"[C6_SEUDES]")
//	lAchou := .F.
//EndIf

//Valida se Campo PEDIDO CLIENTE está preenchido
	If !Empty(SC2->C2_PEDIDO)
		If lAchou .And. Empty(SC5->C5_ESP1)
			Alert("Campo PEDIDO CLIENTE não está preenchido no Cabeçalho do Pedido de Vendas! "+Chr(13)+Chr(10)+"[C5_ESP1]")
			lAchou := .F.
		EndIf
	EndIf

//Caso algum registro não seja localizado, sair da rotina
	If !lAchou
		Return(.F.)
	EndIf

// Verifica nivel da embalagem
	If cNivel < "3"		// Nivel 3 não contem na estrutura
		aRetEmbala := U_RetEmbala(SB1->B1_COD,cNivel)
		If !aRetEmbala[4]
			Alert("Emissão de etiqueta não permitida por falta de nivel da embalagem na estrutura.")
			Return(.F.)
		EndIf
	EndIf

	If lImpressao
		
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
				If ValType(aFilhas[_nX])  == "A"
					XD2->XD2_PCFILH := aFilhas[_nX][1]
				Else
					XD2->XD2_PCFILH := aFilhas[_nX]
				EndIf
				XD2->( msUnlock() )
			Next _nX

			For x := 1 To MVPAR03 

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
			XD1->XD1_QTDORI  := nQtdEmb
			XD1->XD1_QTDATU  := nQtdEmb
			aRetEmbala       := U_RetEmbala(XD1->XD1_COD,cNivel)
			XD1->XD1_EMBALA  := aRetEmbala[1]
			XD1->XD1_QTDEMB  := aRetEmbala[2]
			XD1->XD1_NIVEMB  := If(AllTrim(cNivel)=="3",cNivel,aRetEmbala[3]) // Nivel 3 (Volumes parar expedição não constam na estrutura)
			If !Empty(SC2->C2_PEDIDO)
				XD1->XD1_PVSEP   := If(AllTrim(cNivel)=="3",SC5->C5_NUM,"")
			EndIf
			XD1->XD1_PESOB   := nPesoVol
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

		__MVPAR01 := _cProxPeca
		__MVPAR02 := ""
		__MVPAR03 := StrZero(MVPAR02,4)+" Unidade(s)"
		__MVPAR04 := U_fTratTxt(SB1->B1_DESC)                                       
		__MVPAR05 := "PN RDT: "+U_fTratTxt(SB1->B1_COD)
		__MVPAR06 := U_fTratTxt(SA1->A1_NREDUZ)+" - "+U_fTratTxt(SC6->C6_SEUCOD)
		__MVPAR07 := "PED.CLIENTE: "+Subs(U_fTratTxt(SC5->C5_ESP1),1,45)
		__MVPAR08 := "ITEM DO PEDIDO/CLIENTE: "+U_fTratTxt(SC6->C6_SEUDES)
		__MVPAR09 := "SEMANA: "+U_fSemaAno()+"/"+SubStr(StrZero(Year(Date()),4),3,2)

			
			cVar1:= StrZero(MVPAR02,4)
			cVar2:= U_fTratTxt(SB1->B1_DESC)
			cVar3:= U_fTratTxt(SB1->B1_COD)
			cVar4:= U_fTratTxt(SA1->A1_NREDUZ)+" - "+U_fTratTxt(SC6->C6_SEUCOD)
			cVar5:= Subs(U_fTratTxt(SC5->C5_ESP1),1,45)
			cVar6:= U_fTratTxt(SC6->C6_SEUDES)
			cVar9:= U_fSemaAno()+"/"+SubStr(StrZero(Year(Date()),4),3,2)
			cVar10:= DtoC(SZY->ZY_PRVFAT)


			If !Empty(cCdAnat1)
				cVar7:= U_fTratTxt(cCdAnat1)
				cVar11:= U_fTratTxt(cCdAnat1)
			Else
				cVar7:=""
				cVar11:=""
			EndIf

			If !Empty(cCdAnat2)
				cVar8:= U_fTratTxt(cCdAnat2)
				cVar12:= U_fTratTxt(cCdAnat2)
			Else
				cVar8:= ""
				cVar12:= ""
			EndIf

			cVar13:= __MVPAR01 

			aVar:={}
			AADD(aVar,cVar1)
			AADD(aVar,cVar2)
			AADD(aVar,cVar3)
			AADD(aVar,cVar4)
			AADD(aVar,cVar5)
			AADD(aVar,cVar6)
			AADD(aVar,cVar7)
			AADD(aVar,cVar8)
			AADD(aVar,cVar9)
			AADD(aVar,cVar10)
			AADD(aVar,cVar11)
			AADD(aVar,cVar12)
			AADD(aVar,cVar13)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
			//³Executa IMPRESSÃO NA ZEBRA			         	 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿

			// cLocImp      := ""
			cPrn         := "DOMETQ48.prn"
			aVar         := aVar
			cVetor      := "!aVar"
			lTemperatura := .T.
			U_IMPPRN(cLocImp,cPrn,aVar,cVetor,lTemperatura)

		Next x

	EndIf

Return(.T.)
