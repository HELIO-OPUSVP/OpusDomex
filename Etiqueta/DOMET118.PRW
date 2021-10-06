#include "protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DOMETQ94 ºAutor  ³ RICARDO RODA       º Data ³  17/09/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³     Nova Etiqueta padrão Ericsson (não grava XD1)          º±±
±±º          ³           Para padrão ZEBRA                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMET118(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,lColetor,cNumSerie,cNumPeca)

	Local aPar       := {}
	Local aRet       := {}
	Local nVar       := 0

	Local MVPAR02   := 1         //Qtd Embalagem
	Local MVPAR03   := 1         //Qtd Etiquetas

	Local aRetAnat   := {}        //Codigos Anatel, Array
	Local aCodAnat   := {}        //Codigos Anatel, Array
	Local cCdAnat1   := ""        //Codigo Anatel 1
	Local cCdAnat2   := ""        //Codigo Anatel 2
	Local cCdAnat3   := ""        //Codigo Anatel 3
	Local cNumPedido := ""
	Local cCodProdut := ""
	Private lAchou   := .T.
	Private aGrpAnat := {}     //Codigos Anatel Agrupados
	Private cLocImp  := ""
	Private lFatSZY  := .T.
	private aRetPar   := {}
	Private aPar:= {}
	Private aCodEtq:= {}
	Private _aArq:={}


	Default cNumOP   := ""
	Default cNumSenf := ""
	Default nQtdEmb  := 0
	Default nQtdEtq  := 0
	Default cNivel   := ""
	Default aFilhas  := {}
	Default cNumSerie := ""
	Default cNumPeca  := ""

	MVPAR02:= nQtdEmb   //Qtd Embalagem
	MVPAR03:= nQtdEtq   //Qtd Etiquetas /*revisar*/

	If cNivel == '2'
		If Empty(aFilhas)
			cAssunto  := "Chamada da etiqueta layout 002 com o afilhas vazio."
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
		Else
			cCodProdut := SC2->C2_PRODUTO
		EndIf

		If !Empty(SC2->C2_PEDIDO)
			cNumPedido := SC2->C2_PEDIDO
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

		cNumPedido := SC5->C5_NUM

		//Localiza SC6
		SC6->(DbSetOrder(1))
		If lAchou .And. SC6->(!DbSeek(xFilial("SC6")+Subs(cNumSenf,1,8) ))
			Alert("Item Senf "+Subs(cNumSenf,7,2) +" não localizado!")
			lAchou := .F.
		Else
			cCodProdut := SC6->C6_PRODUTO
		EndIf

	EndIf

	If !Empty(cNumPedido)
		//Localiza SA1
		SA1->(DbSetOrder(1))
		If lAchou .And. SA1->(!DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
			Alert("Cliente "+SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI+" não localizado!")
			lAchou := .F.
		EndIf
	EndIf

//Localiza SB1
	SB1->(DbSetOrder(1))
	If lAchou .And. SB1->(!DbSeek(xFilial("SB1")+cCodProdut))
		Alert("Produto "+AllTrim(SC2->C2_PRODUTO)+" não localizado!")
		lAchou := .F.
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

	If lImpressao

		if empty(Alltrim(cLocImp))
			aAdd(aPar,{1,"Escolha a Impressora " ,SPACE(6) ,"@!"       ,'.T.' , 'CB5', '.T.', 20 , .T. } )
		Endif

		If !ParamBox(aPar,"INFORMAR IMPRESSORA",@aRetPar)
			Return
		EndIf

		cLocImp := ALLTRIM(aRetPar[1])

		If !CB5SetImp(cLocImp,.F.)
			MsgAlert("Local de impressao invalido!","Aviso")
			Return .F.
		EndIf

		//    For x:= 1 To MVPAR03

		// 		// Armazenando informacoes para um possivel cancelamento da etiqueta por falha na impressao
		// 		If Type("cErictDl31_CancEtq") <> "U"
		// 			cErictDl31_CancEtq := cNumPeca
		// 			cErictDl32_CancOP  := cNumOP
		// 			cErictDl33_CancEmb := cNumSenf
		// 			cErictDl34_CancKit := nQtdEmb
		// 			cErictDl35_CancUni := nQtdEtq
		// 			cErictDl38_CancNiv := cNivel
		// 			aErictDl3A_CancFil := aFilhas
		// 			cErictDl39_CancPes := nPesoVol
		// 		EndIf

		// 		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
		// 		//³Montagem do código de barras 2D						 ³
		// 		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
		cSQL    := "SELECT dbo.SemanaProtheus() AS SEMANA"
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"WEEK",.F.,.T.)
		cSemana := WEEK->SEMANA
		WEEK->(dbCloseArea())

		cPDF417 := "[)>06"																// [)>06
		cPDF417 += "18VLELME"                          							// 18VLELME
		cPDF417 += "1P"																	// 1P Ericsson Product No.
		cPDF417 += PADR(ALLTRIM(SC6->C6_SEUCOD),20)								// <F1>
		cPDF417 += "21P"                               							// 21P Ericsson R-State
		cPDF417 += PADR(SC6->C6_XXRSTAT,7)             							// <F2>
		cPDF417 += "11D"																	// 11D Man.Week
		cPDF417 += PADR(cSemana,6)                      						// YYYYWW
		cPDF417 += "Q"																		// Q
		cPDF417 += PADR(ALLTRIM(STR(nQtdEmb)),6)									// <F8> Quantity
		cPDF417 += "1V"																	// 1V
		cPDF417 += PADR("BG7",3)														// <F5> Factory Code
		cPDF417 += "1T"																	// 1T
		cPDF417 += PADR(ALLTRIM(SC2->C2_NUM)+ALLTRIM(SC2->C2_ITEM),14)		// <F9> Batch No.
		cPDF417 += "4L"																	// 4L
		cPDF417 += PADR("BRAZIL",6)													// <F17> Country Origin
		cPDF417 += "OT"

		// 		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
		// 		//³Montagem dos parâmetros de saída da etiqueta 	 ³
		// 		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
		// 		cCodBar  := ALLTRIM(SC6->C6_SEUCOD)+";"+ALLTRIM(SC6->C6_XXRSTAT)+";"+ALLTRIM(STR(nQtdEmb))+";"+ALLTRIM(SC2->C2_NUM)+ALLTRIM(SC2->C2_ITEM)+";"+"BRAZIL"+";"+"BG7"+";"
		// 		cCodBar  += ALLTRIM(SC6->C6_SEUCOD)+";"+ALLTRIM(SC6->C6_XXRSTAT)+";"+ALLTRIM(STR(nQtdEmb))+";"+"BG7"+";"+ALLTRIM(SC2->C2_NUM)+ALLTRIM(SC2->C2_ITEM)+";"+"BRAZIL"+";"
		// 		cCodBar  += ALLTRIM(cSemana)+";"+cPDF417

		// 		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
		// 		//³Parâmetros de impressão do Crystal Reports		 ³
		// 		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
		// 	   //cOptions := "2;0;1;Ericsson"			// Parametro 1 (2= Impressora 1=Visualiza)
		// 	   //cOptions := "2;0;1;Ericsson"			// Parametro 1 (2= Impressora 1=Visualiza)

		// 		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
		// 		//³Executa Crystal Reports para impressão			 	 ³
		// 		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
		// 		//CALLCRYS('ericsson', cCodBar ,cOptions)


		//NOVO LAYOUT ZEBRA PARA ETIQEUTA ERICSSONN
		AADD(_aArq,'CT~~CD,~CC^~CT~'+CRLF)
		AADD(_aArq,'^XA'+CRLF)
		AADD(_aArq,'~TA000'+CRLF)
		AADD(_aArq,'~JSN'+CRLF)
		AADD(_aArq,'^LT0'+CRLF)
		AADD(_aArq,'^MNW'+CRLF)
		AADD(_aArq,'^MTT'+CRLF)
		AADD(_aArq,'^PON'+CRLF)
		AADD(_aArq,'^PMN'+CRLF)
		AADD(_aArq,'^LH0,0'+CRLF)
		AADD(_aArq,'^JMA'+CRLF)
		AADD(_aArq,'^PR6,6'+CRLF)
//AADD(_aArq,'~SD15'+CRLF)
		AADD(_aArq,'^JUS'+CRLF)
		AADD(_aArq,'^LRN'+CRLF)
		AADD(_aArq,'^CI27'+CRLF)
		AADD(_aArq,'^PA0,1,1,0'+CRLF)
		AADD(_aArq,'^XZ'+CRLF)
		AADD(_aArq,'^XA'+CRLF)
		AADD(_aArq,'^MMT'+CRLF)
		AADD(_aArq,'^PW827'+CRLF)
		AADD(_aArq,'^LL1394'+CRLF)
		AADD(_aArq,'^LS0'+CRLF)

		AADD(_aArq,'^FO42,830^GFA,681,3944,8,:Z64:eJztl7FuwjAQhmN58IJkRgaEeQTGDhF5lT5Gh0oYdehrWerQ18gjZGRAuLHvv6QKxA5DVVL1pOYbejn/+H5fkqJASEfUDXH9RFytiLtFmpzH93EdrntvVN77OsE2DFhZoseKZ6JqkmmC004QzGkQfEDaJZ02QeejhqjTnBzP4bLBfQMa7IP+RtdStbSURzFkH+QsYek/ylaR2lFDjdMu0pLV9oWM65fQkeMGFjWFclTXxLoa+lqhtL6HYao6uRnDMPDBGPtfrCyRj4xg1mlKUHFdB1oQOs536UZk/a2ciYka+nk/8/tPurlfvP/mav/pBN69/8jj+yTqcF1dwz9Yl3VP9Q/nXfkHdXkdmdGPudm5oMyQ87Qlqqy/pgXmnCT3tGXpbu1pjJojDUBTnCDjBbJewfJHObs5K/h8gHrQlwp5ezDX9zXY9R/kaZGfMxNjJudmPMiQUtDc0xJz8A1z8f2TqD5Ijz6SviGNGBC695hXF+g+m0h1orklG+7M4o/pnfVzuMQ5GOPIr/39uYznfNmxeSjObi4XFT3QZPdeRDoP3ocnm/BWhcEjT/QJEEwd/sJLTjB0bHdbYRfYXraByxvL/D9Pb8bYevx9QIe/f6ntPkbwNYdt6snnb2Jsw2XZ94/7yf3lfsf+294P7I/OL+wf9lM6vgBVMh7O:683F'+CRLF)
		AADD(_aArq,'^FO42,152^GFA,629,2048,8,:Z64:eJzNlUFOwzAQRcfywiwQ5gQxR+AAVnIVjsEC0VRdcK0gFl1yhVRcIKwoUqnxzB+3NCUSEiAYqXmqFM98j/84REfRnAhMOhPaFIQuhZbpH33HDN4JK297ZvTmS6z1/bzuII9/RH6XUou6W9WxUV39sdbDuJK8hDojhpQS039gh3KoV2mSMafqWOThRMKwp+ynqdC3unKSP+p+95zok5tDtzLcLcDlEvUekN8tQDOHfqLbacUfdP9+f27kaU0Seov1QfWGuyXoHqR+7bHPOGYwI6pvajBs1TebIHRr+McOXnWcTio8CBzPz/M4LpQ9Pzbou03kmD61AeyajrhNvfQv2JX4vzZPa2Y0L7I8EtqZSeBWuVGulcO32Kgfpvj/ooHwPJ/CMpezlLgjJrWOO2Xzn1kmX2b842FlY0V+N2e4ZF7qmZ1/UgbtzmU6odNu+ITyYY7+Bz2Hiq6FUccjotKv8a/ObapeuVcwtOg1hyliBuX1iPGbgnZz1gpd6gz09Lj3FgNo1sKaboQxTxwYlLiXIrl70K6Uz1hnXiUP0ZuwpZnUGfDhcgPJfOd9e9lyv2sBFXJc8ON877/ix+LP4lfxb7v3c/H3zu/F/2UePo93m6o3sQ==:44B6'+CRLF)
		AADD(_aArq,'^FO224,1096^GFA,497,1864,8,:Z64:eJzllL1txDAMhWkYOHfRBvYihzijZISULg6Wu6zlDbJCNojLKwwzot5jkAj3WyRNiMN9gCVTj48WRQ6CiBO5gP0KNsoF5UK3gbXO3MkFXfkcG8IambCzDJVOwRg2aSa8lRlncBTZ2faBep6kjFqwHk4xqmoWQ3YKGYmrfM9b8kwMEXnO8Yb4U72pT9DVk7Eg2ylHcrnCl+LcPdmRZf6Stwd8Cmf143NaByg5DlCy7NuC4SKHFhxbVBA7sA/I35K7hk5V7sRtcd0Pd9SdbMkHMlyhO98z71ZwJe/TnQrFKcd6xvuZlerrJHab9cPYLE2uI8zVRjGj8TH/8t/I4vJ6Giu4L1K9/aQ4wykeWOee/nj+lr51gomVdOQvOenK9Sad7wLdM30Q1nWnHb8d1BfYL//eFcLrDfM0vEttG2x2mrFmghljl8Dm5XNiNXFMTicP+pd9dT/cH/fL/XM/3V/32/3/6of3x/t1OT4B9m8CqQ==:3E38'+CRLF)
		AADD(_aArq,'^FO245,591^GFA,501,2296,8,:Z64:eJzNlT1uwzAMhaWqqJbCuUDg5AgdMxTJtTIErbZuOUEPo6JDtpxBR/DoobAa+z06iGPZQX9DwPhgi6II8olW6tR0jFUflQ7rhsZNG1qVDdPl8A8bBi5xQizAlVeDtpyD1QL7q0fE2+N8s0V8m2UjZB5b7ttfls8daRM0DtTcZlmnLscsve+BnJL3ZJZgTi4Z54MsyWI4j/4+tv2PjCfs1qO1uQcDztMB5xuP/okuxvQjOvuyftQN/ZG/acn8X6Erm1PP2WV6Mi/U0w5x9Duo3pq8RA56l+CxnuCz9J1Zn9WzY9eil9ZkPnTqbB3zVZfxp+7TP/U9Zal5qgtZp2MM4KRKfNCykJ++yzr9O68S/3heYr7/ua0CE0IdJzG6mjM38zU3TPngVf94alnUDdOH57YvnJFyRI/w1O+Thp5LhTlS4H7oQHrOue/yl+t6Fle4psOClNvfve1jc+VK85F+S/9FD60+RC+iH9GT6Cthnw948jQ=:63AD'+CRLF)
		AADD(_aArq,'^FO224,57^GFA,705,2808,8,:Z64:eJzVlU1u4zAMhakaiJa6gXWRws5ReoQutQgiH81H8RG89MKIKvGRbp0mjjMdDKYskA+pJOrxRwzRYtORYad3pp8mZjvNzCacmafQMEPwzDG4nfRyrl75aQL8+wS6hHttGqAr0TMWU0pbJE/w/5r/WA9Bz0huFydCHCeC/kgXZps0jj/Tb1K3Oqd+1G9L8+pe1a169urWc+pH/f5UP70AR9tzOL3l83awY6EbKvbre9yXxfD9jTAXo4Ys6AwE3U/Qf/WjVP+eXefNvWEddrTMKiFOkxLrzo2CONy0M+6/bG/CkzB2whFsUaZcH1lIsuDRhzmiXnbKghS2Stjg5igOffGQ+84VugvZDqeYsQfzqz+U7eFKn34fH1D3NUIv7zDe4V77ve+lEr/uFnVOtcKcrotwln10k5/W8+dBKlAbyYvB+UiY4+cn8zEuOtf5iA/z0W3k4qshL076oP3WH2jfOSDiKWB+j6/1Fd0mQw2ea8QdPdg6+K+FBysPzWgnb9q9soSq/6d8+Pv335mMK6fvVnQmDOTqgjnmBqrKhjKzSgOX5iuFK3kuc+ot02Qey9nuxhhVDmAr491KVky6u9CvF9yycOXarb/ruvSTnld/6n/734tevUTj0fh+avf6xAs1KP4tyCZtRmZY89vc32nH8tF91k/rqfXVemv9tR+0P5Z+0f7Rftq2D5wkbY4=:4EE8'+CRLF)
		AADD(_aArq,'^FO379,538^GFA,1237,5648,16,:Z64:eJzVmDtuGzEQhrnYgiVTpgjCHCEHEEwfJUfIAQwvgRQpfYRcZQ0fQFfYwEXKqFSxEEPOg9wZJVrD3gD2FJI+SEsOf85whjLGG2l+UnxUnDTLB2ya5Q+SesCpBzr9QFAP2DSq78UAXZLsUjrI+e2Ss3/9krP/nWQj+ah4UiydNe9XOGzMen4XJYvFlt8rubbmzS2MkpMMyD6dBFsVbzkc4iX2k5zAj15wiG4SbOy2rMbX82v/1taj16/10fqdJfzGluNjVpw0jys8XeB+unIiv0cv8t1F903mq31Ycjjnx0M5VSbBgWXM+5W5q15k/nUoqpOuYQq/J/DyxP7uJzNkxn1ywFkTh8vM/GM05fMAnEfy0RTJHHA+Hj8aUzzsRpogv8BQ12YLC+/gbabRuvQB3Ji/IvcJThg33yDbFMrkfiY9XIL4DDPtqkceKu8hnofdQNPdQbyfdjBMZmcLzzv/XHbIPJ4a3+/Rn131D3QfOAopf+r+Uv54jlrKH8dpQ+XK1iID+5HTKponmY+4r41hPVV/4qo/MesfKPBYf04H1t8RDwuG9ZL+lpj16Skdq5709mQmq/qTnRRX/bN9Mgv9s4H/rH9P62P9HXLVn7jqz/WH9fc48BcePND6Kt+B440t7MeCv2ue/sI3iq8qP+zB35HYP+J+8DGt2f3keETu7yWbET40xqmG9NSAU/bZjIIPopvJ7UJXllqXa4/dacnu2Bc9Zzsh+8xxyZMRnJOv5F/jaPySc1SWfK18e852Sx4UB9wq7V89rjXn9Q1xyccuLdlhPlW2WAcq96ocGtWt5ngdBVuuO0baW+dnG9UrDn+uVywj1SvP5wXVq3q+cL1i5nqVZL1KkSbgemJkvdI888G4zjDeDTfuNP4tC0T16qpELvoHAeFjOw/jIp6oXjXuZbxRvWqM9WrBYJovGOnPRvpXI/2rof5dO0BAb1dPf9Tf16hH/dsdD/UZGoOeQyu/wO2Oh3zqj/9kOF+6yneSUf8Fg/6NUf/GqH9j1L8x6t8Y9W+M98Omf9iY/8/9EAa5btz6U+TWvyK3/hat9b9ogwrA2j+T+7W/piyp/XfgtKJ8Zub+nZntjNV1QvPa9cMptknrJedbZSPbw7fPLzXqr9n030VW3W9X7/vyelnua2KCs/v+C+//+b4p5tP9v4syAuwkKuVafL6UN7dBYq/bGdXu1L6ezJ+x3O5wrzieLjPX0dfCr3s//wAvlnxL:1A90'+CRLF)
		AADD(_aArq,'^FO409,1068^GFA,521,2088,8,:Z64:eJzVlDFuwzAMRSV40FJAGTMEVo6QsYNhXaXH6NQ4yJBj9CaFgA65Ro7g0UMQ1eIn69SA7RhwgZZA/BaG/PqkpBRHFkBbg5tncL0Gd0/jlDz5n9SRunPDxxgvI2zDMX0FRu54BU09mqYlrWHBksaC95x2G097QOffCs26DNMynbBCXsn5xQQ3zJxpmSYQFvAHm6UrdDCVR5+AgbpgA3Rj1UqVXaBPP8ScV9SxYhvgQOsLsfUJ/SMvjJ+U/YK6Uv8HHZ/b3jGgDfqJj30O9cmG5oi6yueOksvcUP3C4rwd2Y8+zQG6me50BM9n9PtEfXME9QH6lXobVnwfGjfqam44hiWfTXynOjZ+0FzdqaG55LohvaWuSV+hfpf/7l4rj/cu432VPdjHmIzWsSKjswZPWzI3/dJypAtD17mtsEtsP9vEVVd96hmYyyl/l+63VAzplfvMzx4/QoovvyJvKV57nClwmz6rbk4yN5mjzJXmXHVzlz343gvZE9mb8fgCd74qjw==:6262'+CRLF)
		AADD(_aArq,'^FO409,166^GFA,509,1936,8,:Z64:eJzNlE1OwzAQhR15YVa4B0B2j8ABouQqnISk6oJrBbHoslcIN+iySFDj8bxJSIRpipDoSPGXpPbMm59UqZwVIfREA1rQgzX2VWB5hnegAy2oO6af+Z/zQitxLsfrsfomoQi3iTr4RBN8S7R72xG9NYnO6p5Y2mIRK+yP5yZ+7J79x/62HPcEHe/Q1V+UReC65qhMx3lZZVI8h86XCnqzZP0V6BXr9x3qA/3m9/ofaNGZOY9M8WrH+ivH+kvUc2SmD2aT6ED/tGXudhzvhf2bLbPYcD5KPS7V/9XO9UE+2/oActVi2j3foIwxb34x1NOzvvgCO6XAevosv2O/nBd/8C/xJP6gZ2Ee12fIIM5RosxPE8JRURlaQ6nq+NBE0kdNFw0VFTD9TUYP98S4rImrSQCep3/i3/Xj53A5/x60B96nj8zihPMNWD8z7SvTvDGLD8SZj68HDSjjzLamZTX2RfokfZM+pr62Y5+l78McyFwMk/6tfQKRnjI3:665F'+CRLF)
		AADD(_aArq,'^FO655,40^GFA,1621,7376,16,:Z64:eJztl7Fu40YQhodmBAYWEKYxrqSR0in0CMsr0qeIkFKvkC7l8pLG3b0CS0Mp3F5HPoK7q4KwFBIgYeGCEGROZklxd2YlkXewDzZwN5AN//g81O7sz51dgCePGX1SCNJBqxwWG5hvB726g6SG6H7Q2AC2sGizXga4A72DBPc47LlCzlvQjrfEs0JwpE/GOGYK84Fjz0vLM+IFVpyXmmnilbK6T06wHsa/55u9JrjCynHdJS9oGpYnWEWWF11yTMPuI+keHllNyTE2MU1j4PUryQk2c84Jhlb3ySHjTcfRcUr+DYcFIBiYjyvw1vwzIucoFiDsarDns4G7AptkLQucMY7HFmA18LMe2gUwycpbgAI3Sha4jC2npVdYx5b3yU53D29ill8dWYDIK7Djiy45ZgU3fGY5wX2NhgLeh7zA/eq8kQUWC9DuazhoWWBavd6krqCBPlwAr8COQ/cG5JaDtwD965fzBSBtfMp5Flu96l7fyGplOE0zGwpIr/+OhgVDATZw3sD5duCzEoI7gJ+AxWX3+RJf4jOMqzVF7vTSxI9Oo4nGaW30/QSvP10+je5nnk/j/4NzMJtcLfStx1c8v2sCFdcByvyF3R37SPBBPA5xyyXtj3dcz73HJ3bzHb5dpnvfHqPt/l1EiCnXSj6O6icn66WzrXng+SXf/rR83Itbfz/f2Hd9AyfjuovTfDq+Hsdn67XQM88etzgcD/tYofAHrb8wAK2/7e4myD72+GQiMvNnPDaa8cTo0mlldOW09vQhl+8Pttfnov5Ue8055SrOUxoDX18aW+wmFJixR1wTj9rT3KB4godjfOL53fgY1yDGezi/0pvflpZQ1icQ9cH17Zi//fonnvbXN55Y/8DjoecfkK+TOaLKHeICH1Ku5zId4AeBPySycXyVS53wDfCmOwO6WEIg5odZKOavzRsieCz9bSrMdAtHeM254gUL8JC3BeOUv0sEL5q3jNP1spb+1Y30t+BA5+eN8CM5kHP8nS58rEA6QMn/I840+U9y2p5EPlUzkvtzxr+fti/g3PSfmBnKtLeIzZ9uIBnn5jIaMz6n4i4YD6i4rxg/I3d+ww36FTx1+P7T/HiwzkC8APpD/Jdx7vsremr/CX7Mf/Go/1Qj97+P9N8bz3+vPX/9Q1dc7r/3B/7LPP/B4/z3MOq/yPNfOOE/wBs4HzlfPDYu7a/jUVQg5mf6Dx+/OVwITj98/l7/7flOclF/jxvvj/Rf8Puvlz/Zfw0a4eD35wkOx/q3mH/p9e/K6+9UuxWvX9P/DLHadRaxodr8e9m/7xJ5vmoP+3vpdNe/c6f98938SH/n58OuvzNtXiBxgfD7fYLyBjDHbc61OL2YGDtdPz6+M3F5mr/0+4fPl8uL5QW7P0/dTz5JfMv+vs4A3jFN/TNg4w/JfHL/K8UBLMbNHMX+Wc/4/BfYKBT7707z+hXG/6J+D6J+6mPrT+n8Box/F+L+pNMEf2EaqwJvJOevD+0fSty/tTx+mv7dPCv/t5Dz//OvF+1/bYItwLP4fypS9+dVBqK//woXqeyfaiP7a1KK80mmqgMu8guZn07lq/J5v9/Pf/z3v+W89PLXxfb2Jfn3ZP7/JuTBPQ==:F841'+CRLF)

		AADD(_aArq,'^BY3,3,65^FT225,1329^BCB,,N,N'+CRLF)
		AADD(_aArq,'^FH\^FD>:1P'+PADR(ALLTRIM(SC6->C6_SEUCOD),20)+'^FS'+CRLF)

		AADD(_aArq,'^BY2,3,67^FT222,408^BCB,,N,N'+CRLF)
		AADD(_aArq,'^FH\^FD>:21P'+PADR(SC6->C6_XXRSTAT,7)+'^FS'+CRLF)

		AADD(_aArq,'^BY2,3,70^FT404,1329^BCB,,N,N'+CRLF)
		AADD(_aArq,'^FH\^FD>:Q'+PADR(ALLTRIM(STR(nQtdEmb)),6)+'^FS'+CRLF)

		AADD(_aArq,'^BY2,3,70^FT596,1323^BCB,,N,N'+CRLF)
		AADD(_aArq,'^FH\^FD>:1T'+PADR(ALLTRIM(SC2->C2_NUM)+ALLTRIM(SC2->C2_ITEM),14)+'^FS'+CRLF)

		AADD(_aArq,'^BY2,3,70^FT404,408^BCB,,N,N'+CRLF)
		AADD(_aArq,'^FH\^FD>:1VBG7^FS'+CRLF)

		AADD(_aArq,'^BY2,3,70^FT596,409^BCB,,N,N'+CRLF)
		AADD(_aArq,'^FH\^FD>:4LBRASIL^FS'+CRLF)

		AADD(_aArq,'^FT152,1329^A0B,58,58^FH\^CI28^FD'+PADR(ALLTRIM(SC6->C6_SEUCOD),20)+'^FS^CI27'+CRLF)
		AADD(_aArq,'^FT152,408^A0B,58,58^FH\^CI28^FD'+PADR(SC6->C6_XXRSTAT,7)+'^FS^CI27'+CRLF)
		AADD(_aArq,'^FT331,1329^A0B,58,58^FH\^CI28^FD'+PADR(ALLTRIM(STR(nQtdEmb)),6)+'^FS^CI27'+CRLF)
		AADD(_aArq,'^FT327,788^A0B,46,46^FH\^CI28^FD'+PADR(cSemana,6)+'^FS^CI27'+CRLF)
		AADD(_aArq,'^FT519,1329^A0B,58,58^FH\^CI28^FD'+PADR(ALLTRIM(SC2->C2_NUM)+ALLTRIM(SC2->C2_ITEM),14)+'^FS^CI27'+CRLF)
		AADD(_aArq,'^FT331,408^A0B,58,58^FH\^CI28^FDBG7^FS^CI27'+CRLF)
		AADD(_aArq,'^FT519,408^A0B,58,58^FH\^CI28^FDBRAZIL^FS^CI27'+CRLF)
		AADD(_aArq,'^BY7,7^FT776,1358^B7B,7,2,0,0,N'+CRLF)
		AADD(_aArq,'^FH\^FD'+cPDF417+'^FS'+ CRLF)
		AADD(_aArq,'^PQ'+cValtochar(MVPAR03)+',0,1,Y'+ CRLF)
		AADD(_aArq,'^XZ'+CRLF)
		//Next x
		AaDd(aCodEtq,_aArq)

		For nY:=1 To Len(aCodEtq)
			For nP:=1 To Len(aCodEtq[nY])
				MSCBWrite(aCodEtq[nY][nP])
			Next nP
		Next nY

		MSCBEND()
		MSCBCLOSEPRINTER()

	EndIf

Return(.T.)
