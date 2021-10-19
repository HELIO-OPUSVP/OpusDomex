#include "protheus.ch"
#include "rwmake.ch"

//--------------------------------------------------------------
/*/{Protheus.doc} DOMETQ39 (NOVA ETIQUETA PARA SUBSTITUIR LAYOUT002)
Description  
@param xParam Parameter Description
@return xRet Return Description
@author  -
@since 01/09/2021
/*/
//-------------------------------------------------------------

User Function DOMETQ39(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,lColetor,cNumSerie,cNumPeca)

	Local nVar       := 0
	Local cRotacao   := "N"      //(N,R,I,B)
	Local MVPAR02   := 1         //Qtd Embalagem
	Local MVPAR03   := 1         //Qtd Etiquetas
	Local aRetAnat   := {}        //Codigos Anatel, Array
	Local aCodAnat   := {}        //Codigos Anatel, Array
	Local cCdAnat1   := ""        //Codigo Anatel 1
	Local cCdAnat2   := ""        //Codigo Anatel 2
	Local cCdAnat3   := ""        //Codigo Anatel 3
	Local x			 := 0
	Local _nX		 := 0
	Local nP		 := 0
	Local nY		 := 0
	Private lAchou   := .T.
	Private lNokia   := .F.
	Private aGrpAnat := {}     //Codigos Anatel Agrupados
	Private lFatSZY  := .T.
	Private lTelefonic:= .F.
	Private _aArq	:= {}
	Private aCodEtq	:= {}

	Default cNumOP   := ""
	Default cNumSenf := ""
	Default nQtdEmb  := 0
	Default nQtdEtq  := 0
	Default cNivel   := ""
	Default aFilhas  := {}
	Default cNumSerie := ""
	Default cNumPeca  := ""

	MVPAR02:= nQtdEmb
	MVPAR03:= nQtdEtq

	dbSelectArea("SC5")
	dbSetOrder(1)
	dbSelectArea("SC6")
	dbSetOrder(1)
	dbSelectArea("SC2")
	dbSetOrder(1)
	dbSelectArea("SZY")
	dbSetOrder(1)

	If !Empty(cNumOP)
		SC2->(DbSetOrder(1))
		If lAchou .And. SC2->(!DbSeek(xFilial("SC2")+cNumOP))
			MsgAlert("Numero O.P. "+AllTrim(cNumOP)+" não localizada!","Erro")
			lAchou := .F.
		EndIf

		If !Empty(SC2->C2_PEDIDO)
			SC5->(DbSetOrder(1))
			If lAchou .And. SC5->(!DbSeek(xFilial("SC5")+SC2->C2_PEDIDO))
				MsgAlert("Numero de Senf "+AllTrim(SC2->C2_PEDIDO)+" não localizado!","Erro")
				lAchou := .F.
			EndIf

			SC6->(DbSetOrder(1))
			If lAchou .And. SC6->(!DbSeek(xFilial("SC6")+SC2->C2_PEDIDO+SC2->C2_ITEMPV))
				MsgAlert("Item Senf "+AllTrim(SC2->C2_ITEMPV)+" não localizado!","Erro")
				lAchou := .F.
			EndIf

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
			MsgAlert("Numero de Senf "+Subs(cNumSenf,1,6)+" não localizado!","Erro")
			lAchou := .F.
		EndIf

		//Localiza SC6
		SC6->(DbSetOrder(1))
		If lAchou .And. SC6->(!DbSeek(xFilial("SC6")+Subs(cNumSenf,1,8) ))
			MsgAlert("Item Senf "+Subs(cNumSenf,7,2) +" não localizado!","Erro")
			lAchou := .F.
		EndIf
	EndIf

	If !Empty(SC2->C2_PEDIDO) .OR. !Empty(cNumSenf)//If !Empty(SC2->C2_PEDIDO) //MLS, NÃO ESTAVA POSICIONANDO NO SA1
		//Localiza SA1
		SA1->(DbSetOrder(1))
		If lAchou .And. SA1->(!DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
			MsgAlert("Cliente "+SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI+" não localizado!","Erro")
			lAchou := .F.
		EndIf
	EndIf

	If !Empty(cNumOp) .And. Empty(cNumSenf)
		SB1->(DbSetOrder(1))
		If lAchou .And. SB1->(!DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
			MsgAlert("Produto "+AllTrim(SC2->C2_PRODUTO)+" não localizado!","Erro")
			lAchou := .F.
		EndIf
	ElseIf !Empty(cNumSenf)
		SB1->(DbSetOrder(1))
		If lAchou .And. SB1->(!DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
			MsgAlert("Produto "+AllTrim(SC6->C6_PRODUTO)+" não localizado!","Erro")
			lAchou := .F.
		EndIf
	EndIf

	If lAchou
		aRetAnat := fCodNat(SB1->B1_COD)
		lAchou   := aRetAnat[1]
		aCodAnat := aRetAnat[2]

		If lAchou .And. Empty(SB1->B1_XXNANAT)
			MsgAlert("Não foi preenchido o campo 'Nº Codigo Anatel' para o produto: "+AllTrim(SB1->B1_COD) + Chr(13)+Chr(10)+ "[B1_XXNANAT]","Erro")
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

		Case Val(SB1->B1_XXNANAT) == 3 .And. Len(aGrpAnat) == 1
			cCdAnat1 := aGrpAnat[1]
			cCdAnat2 := aGrpAnat[1]
			cCdAnat3 := ""

		Case Val(SB1->B1_XXNANAT) == 4 .And. Len(aGrpAnat) == 3
			cCdAnat1 := aGrpAnat[1]
			cCdAnat2 := aGrpAnat[2]
			cCdAnat3 := aGrpAnat[3]

			//retirado do fonte em 05/04/2019
		OtherWise
			//cCdAnat1 := " E R R O "
			//cCdAnat2 := " E R R O "
			//If !Empty(cNumOP)
			//	Alert("Erro no tratamento dos codigos ANATEL (DOMETQ03)."+Chr(13)+Chr(10)+"Favor procurar TI e informar dificuldade! "+Chr(13)+Chr(10)+"OP:"+cNumOP)
			//ElseIf !Empty(cNumSenf)
			//	Alert("Erro no tratamento dos codigos ANATEL (DOMETQ03)."+Chr(13)+Chr(10)+"Favor procurar TI e informar dificuldade! "+Chr(13)+Chr(10)+"Senf:"+cNumSenf)
			//	EndIf
			//	lAchou   := .F.

		EndCase

	EndIf

//Valida se Campo Descricao do Produto está preenchido
	If lAchou .And. Empty(SB1->B1_DESC)
		MsgAlert("Campo Descricao do Produto não está preenchido no cadastro do produto! "+Chr(13)+Chr(10)+"[B1_DESC]","Erro")
		lAchou := .F.
	EndIf

/**/
//Valida se Campo PN HUAWEI está preenchido
	If !Empty(SC2->C2_PEDIDO)
		If lAchou .And. Empty(SC6->C6_SEUCOD)
			MsgAlert("Campo PN não está preenchido no Item do Pedido de Vendas! "+Chr(13)+Chr(10)+"[C6_SEUCOD]","Erro")
			lAchou := .F.
		EndIf
	EndIf

//Valida se Campo PEDIDO CLIENTE está preenchido
	If !Empty(SC2->C2_PEDIDO)
		If lAchou .And. Empty(SC5->C5_ESP1)
			MsgAlert("Campo PEDIDO CLIENTE não está preenchido no Cabeçalho do Pedido de Vendas! "+Chr(13)+Chr(10)+"[C5_ESP1]","Erro")
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
			MsgAlert("Emissão de etiqueta não permitida por falta de nivel da embalagem na estrutura.","Erro")
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

		aRetEmbala       := U_RetEmbala(SB1->B1_COD,cNivel)
		nQtdEmb := aRetEmbala[2]
		If cNivel == "1" .And. nQtdEmb > 1
			MVPAR03:= 1
			MVPAR02:= nQtdEmb
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
			If x > 1
				_cProxPeca := U_IXD1PECA()
			EndIf
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
			XD1->XD1_QTDATU  := nQtdEmb
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

			lTelefonic := If ((("TELEFONICA" $ Upper(SA1->A1_NOME)) .Or. ("TELEFONICA" $ Upper(SA1->A1_NREDUZ))),.T.,.F.)

			IF lTelefonic

				cFila := "000000"
				IF !CB5SetImp(cFila,.F.)
					U_MsgColetor("Local de impressao invalido!")
					Return .F.
				EndIf

				//MSCBBEGIN(1,5)
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

				if !Empty(SB1->B1_XMODELO)
					XD6->(dbSetOrder(1))
					If XD6->(dbSeek(xFilial()+SB1->B1_XMODELO))
						AADD(_aArq,'^FT715,579^BQN,2,3'+ CRLF)
						AADD(_aArq,'^FDMA,'+alltrim(XD6->XD6_LINK)+'^FS'+ CRLF)
					Else
						msginfo("Não existe nenhum Link Cadastrado na XD6", "Atenção")
					Endif
				Endif

				AADD(_aArq,'^BY3,2,69^FT590,126^BEN,,Y,N'+ CRLF)
				AADD(_aArq,'^FH\^FD'+XD1->XD1_XXPECA+'^FS'+ CRLF)


				If !Empty(cCdAnat1)
					AADD(_aArq,'^BY3,3,60^FT40,483^BCN,,N,N'+ CRLF)
					AADD(_aArq,'^FD>:'+U_fTratTxt(cCdAnat1)+'^FS'+ CRLF)
					AADD(_aArq,'^FT40,515^A0N,35,35^FH\^FD'+U_fTratTxt(cCdAnat1)+'^FS'+ CRLF)
				EndIf

				If !Empty(cCdAnat2)
					AADD(_aArq,'^BY3,3,60^FT45,584^BCN,,N,N'+ CRLF)
					AADD(_aArq,'^FD>:'+U_fTratTxt(cCdAnat2)+'^FS'+ CRLF)
					AADD(_aArq,'^FT40,615^A0N,35,35^FH\^FD'+U_fTratTxt(cCdAnat2)+'^FS'+ CRLF)
				EndIf

				AADD(_aArq,'^FO22,37^GB901,631,2^FS'+ CRLF)

				AADD(_aArq,'^FT40,267^A0N,29,28^FH\^FD'+U_fTratTxt(SB1->B1_DESC)+'^FS'+ CRLF)
				AADD(_aArq,'^FT40,304^A0N,29,28^FH\^FDPN RDT: '+SB1->B1_COD+'^FS'+ CRLF)
				If !Empty(SC2->C2_PEDIDO)
					AADD(_aArq,'^FT40,341^A0N,29,28^FH\^FD'+U_fTratTxt(SA1->A1_NREDUZ)+' - '+U_fTratTxt(SC6->C6_SEUCOD)+'^FS'+ CRLF)
					AADD(_aArq,'^FT40,379^A0N,29,28^FH\^FDCOD:'+U_fTratTxt(SC5->C5_ESP1)+'^FS'+ CRLF)
					AADD(_aArq,'^FT40,416^A0N,29,28^FH\^FDITEM DO PEDIDO/CLIENTE: '+U_fTratTxt(SC6->C6_SEUDES)+'^FS'+ CRLF)
				Endif
				AADD(_aArq,'^FT715,446^A0N,29,28^FH\^FDSEMANA: '+U_fSemaAno()+"/"+SubStr(StrZero(Year(Date()),4),3,2) +'^FS'+ CRLF)
				If !Empty(SC6->C6_XXSITE)
					AADD(_aArq,'^FT40,621^A0N,29,28^FH\^FDSITE:'+alltrim( SC6->C6_XXSITE)+'^FS'+ CRLF)
				Endif
				AADD(_aArq,'^FT40,658^A0N,29,28^FH\^FDINDUSTRIA BRASILEIRA^FS'+ CRLF)
				AADD(_aArq,'^FT766,651^A0N,29,28^FH\^FDLayout 039^FS'+ CRLF)

				AADD(_aArq,'^PQ1,0,1,Y^XZ'+ CRLF)

				AaDd(aCodEtq,_aArq)

				For nY:=1 To Len(aCodEtq)
					For nP:=1 To Len(aCodEtq[nY])
						MSCBWrite(aCodEtq[nY][nP])
					Next nP
				Next nY

				//Finaliza impressão da etiqueta
				MSCBEND()

				_aArq:= {}
				aCodEtq:= {}
				//Sleep(500)


			Else
				MsgAlert("Ordem de produção não é do Cliente Telefônica... Verifique!","Atenção")
			Endif

			MSCBCLOSEPRINTER()
		Next x




	EndIf

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fCodNat  ºAutor  ³ Felipe Melo        º Data ³  16/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fCodNat(cCodProd)

	Private aRet     := {}
	Private x        := 0
	Private lOk      := .T.
	Private cErro    := ""

	Private aAreaSB1 := SB1->(GetArea())
	Private aAreaSG1 := SG1->(GetArea())

	Private cNEtiquetas := ''

	SB1->(DbSetOrder(1))
	SG1->(DbSetOrder(1))

//SB1->(DbSeek(xFilial("SB1")+cCodProd)) //MLS
//MSGALERT('DOMETQ01x:'+cCodProd)        //MLS

	If SG1->(DbSeek(xFilial("SG1")+cCodProd))
		cNEtiquetas := Alltrim(SB1->B1_XXNANAT)

		While SG1->(!Eof()) .And. AllTrim(cCodProd) == AllTrim(SG1->G1_COD)
			If SB1->(DbSeek(xFilial("SB1")+SG1->G1_COMP)) .And. !Empty(SB1->B1_XXANAT1)
				//For x:=1 To SG1->G1_QUANT
				aAdd(aRet,SB1->B1_XXANAT1)
				//Next x
				//If (SG1->G1_QUANT%1) > 0
				//	lOk := .F.
				//	cErro += IIf(Empty(cErro),""," / ") + AllTrim(SG1->G1_COMP)
				//EndIf
			EndIf
			SG1->(DbSkip())
		End
	EndIf


	If Empty(cNEtiquetas)
		MsgStop('Não foi preenchido o número de códigos de Barra Anatel no produto ' + cCodProd)
	Else
		If cNEtiquetas == '0'
			If Len(aRet) <> 0
				MsgStop('No produto ' + Alltrim(cCodProd) + ' foi selecionado a opção de 0 códigos de Barra Anatel, e foi encontrado ' + Alltrim(Str(Len(aRet)))+' código Anatel na Estrutura do Produto.')
				lOk := .F.
			EndIf
		Else
			If cNEtiquetas == '1' .or. cNEtiquetas == '2'
				If Len(aRet) <> 1
					MsgStop('No produto ' + Alltrim(cCodProd) + ' foi selecionado a opção de 1 códigos de Barra Anatel, e foi encontrado ' + Alltrim(Str(Len(aRet)))+' código Anatel na Estrutura do Produto.')
					lOk := .F.
				EndIf
			Else
				If cNEtiquetas == '3'
					If Len(aRet) <> 2
						MsgStop('No produto ' + Alltrim(cCodProd) + ' foi selecionado a opção de 2 códigos de Barra Anatel, e foi encontrado ' + Alltrim(Str(Len(aRet)))+' código Anatel na Estrutura do Produto.')
						lOk := .F.
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf

//If !lOk
//	Alert("A quantidade da(s) MP(s) "+cErro+" está(ão) com casas decimais na quantidade da estrutura e isso não é permitido!")
//EndIf

	RestArea(aAreaSB1)
	RestArea(aAreaSG1)

Return({lOk,aRet})
