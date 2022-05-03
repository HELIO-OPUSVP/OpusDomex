#include "protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DOMETQ52 ºAutor  ³ Michel A. Sander   º Data ³  31.01.2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Etiqueta Modelo 29 - Junção Trunk 					           º±±
±±º          ³ (Substitui Leiaute 71)                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMETQ52(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,lColetor,cNumSerie,cNumPeca,cLocImp)

	Local mv_par02    := 1         //Qtd Embalagem
	Local mv_par03    := 1         //Qtd Etiquetas
	Local x,nQ,_y
	Private lAchou    := .T.
	Private aPar:={}
	Private aRetPar:={}
	
	
	Default cNumOP    := ""
	Default cNumSenf  := ""
	Default nQtdEmb   := 0
	Default nQtdEtq   := 0
	Default cNumSerie := ""
	Default cNumPeca  := ""
	Default cLocImp   := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca quantidades para impressão											 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	mv_par02:= nQtdEmb   //Qtd Embalagem
	mv_par03:= nQtdEtq   //Qtd Etiquetas

	If !Empty(cNumOP)

		//Localiza SC2
		SC2->(DbSetOrder(1))
		If lAchou .And. SC2->(!DbSeek(xFilial("SC2")+cNumOP))
			Alert("Numero O.P. "+AllTrim(cNumOP)+" não localizada!")
			lAchou := .F.
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Monta o número de série														 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		cSerieFim := If( cNumSerie == 1, 1, cNumSerie )

		Do Case
		Case SC2->C2_QUANT <=9
			cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,1)	// MV_PAR07 Sequencial Serial
		Case  SC2->C2_QUANT >=10 .And.  SC2->C2_QUANT <= 99
			cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,2)	// MV_PAR07 Sequencial Serial
		Case  SC2->C2_QUANT >=100 .And. SC2->C2_QUANT <= 999
			cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,3)	// MV_PAR07 Sequencial Serial
		Case  SC2->C2_QUANT >=1000 .And. SC2->C2_QUANT <= 9999
			cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,4)	// MV_PAR07 Sequencial Serial
		Case  SC2->C2_QUANT >=10000 .And. SC2->C2_QUANT <= 99999
			cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,5)	// MV_PAR07 Sequencial Serial
		EndCase

	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona no PA																 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	SB1->(DbSetOrder(1))
	If lAchou .And. SB1->(!DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
		Alert("Produto "+AllTrim(SC2->C2_PRODUTO)+" não localizado!")
		lAchou := .F.
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona no Cliente					    									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	SA1->(DbSetOrder(1))
	If lAchou .And. SA1->(!DbSeek(xFilial("SA1")+SC2->C2_CLIENT))
		Alert("Cliente "+SC2->C2_CLIENT+"não localizado!")
		lAchou := .F.
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida descrição do produto		    									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	If lAchou .And. Empty(SB1->B1_DESC)
		Alert("Campo Descricao do Produto não está preenchido no cadastro do produto! "+Chr(13)+Chr(10)+"[B1_DESC]")
		lAchou := .F.
	EndIf

//Caso algum registro não seja localizado, sair da rotina
	If !lAchou
		Return(.T.)
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
//³Montagem do código de barras 2D						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
	cSQL    := "SELECT dbo.SemanaProtheus() AS SEMANA"
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"WEEK",.F.,.T.)
	cSemana := WEEK->SEMANA
	WEEK->(dbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Consiste a quantidade de conectores na estrutura					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	nEtq := 0
	cSQL := "SELECT B1_GRUPO, B1_DESC, G1_COD, G1_COMP, G1_XXQTET1, G1_XXQTET2, G1_QUANT FROM "+RetSqlName("SG1")+" JOIN "+RetSqlName("SB1")+" ON "
	cSQL += "G1_FILIAL = B1_FILIAL AND G1_COD = B1_COD WHERE "
	cSQL += RetSqlName("SB1")+".D_E_L_E_T_ = '' AND "
	cSQL += RetSqlName("SG1")+".D_E_L_E_T_ = '' AND "
	cSQL += "G1_COD = '"+SC2->C2_PRODUTO+"' AND "
	cSQL += "(G1_XXQTET1 > 0 OR G1_XXQTET2 > 0) AND "
	cSQL += "SUBSTRING(B1_GRUPO,1,3) = 'TRU'"
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"ETQ",.F.,.T.)

	If ETQ->(Eof())

		Aviso("Atenção","Um ou mais Componentes da estrutura está sem o lado definido. Altere a estrutura e tente novamente.",{"Ok"})
		cTxtMsg  := " Um Componente da estrutura está sem o lado definido. Altere a estrutura e tente novamente." + Chr(13)
		cTxtMsg  += " Estrutura  = " + ETQ->G1_COD  + Chr(13)
		cTxtMsg  += " Componente = " + ETQ->G1_COMP + Chr(13)
		cTexto   := StrTran(cTxtMsg,Chr(13),"<br>")
		cAssunto := "Etiqueta Layout 084 - Junção Trunk 29"
		cPara    := 'denis.vieira@rdt.com.br;fabiana.santos@rdt.com.br;tatiane.alves@rosenbergerdomex.com.br;monique.garcia@rosenbergerdomex.com.br;daniel.cavalcante@rosenbergerdomex.com.br'
		cCC      := 'natalia.silva@rosenbergerdomex.com.br;keila.gamt@rosenbergerdomex.com.br;leonardo.andrade@rosenbergerdomex.com.br;gabriel.cenato@rosenbergerdomex.com.br;luiz.pavret@rdt.com.br' //chamado monique 015475
		cArquivo := Nil
		U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
		ETQ->(dbCloseArea())
		Return

	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
//³Parâmetros de impressão do Crystal Reports		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿

	nQ 		:= 1
	nSomaSer := cNumSerie
	nDobra   := If(SUBSTR(SB1->B1_GRUPO,1,4)=="TRUN", 2, 1)
	cIL1     := AllTrim(TransForm(SB1->B1_XXIL1,"9.99"))
	cIL2     := AllTrim(TransForm(SB1->B1_XXIL2,"9.99"))
	nAviso   := Aviso("Atenção","Tipo de impressão",{"Total","Parcial"})
	nChoice  := If(nAviso==1,SC2->C2_QUANT,mv_par03)
	aEtqs    := {}

	if empty(Alltrim(cLocImp))
		aAdd(aPar,{1,"Escolha a Impressora " ,SPACE(6) ,"@!"       ,'.T.' , 'CB5', '.T.', 20 , .T. } )
		If !ParamBox(aPar,"INFORMAR IMPRESSORA",@aRetPar)
			Return "INFORMAR IMPRESSORA"
		EndIf
		cLocImp := ALLTRIM(aRetPar[1])
	Endif

	For x := 1 to nChoice

		lUnico := .F.
		ETQ->(dbGoTop())
		Do While ETQ->(!Eof())

			// aTemp := U_QuebraString(SB1->B1_DESC,22)

			If ETQ->G1_XXQTET1 > 0 .And. ETQ->G1_XXQTET2 > 0

				// Monta os dois lados por serial
				// Monta o LADO A

				cPar1 := substring(alltrim(SB1->B1_DESC),1,25)
				cPar2 := substring(alltrim(SB1->B1_DESC),26,len(alltrim(SB1->B1_DESC)))
				cPar3 := "RDT FAN: "+AllTrim(SB1->B1_XFANA)
				cPar4 := "SN:"+nSomaSer
				cPar5 := "L: A"
				cPar6 := "IL:"+cIL1+"dB"
				AADD(aEtqs,{ cPar1, cPar2, cPar3, cPar4, cPar5, cPar6 } )

				// Monta o LADO B
				cPar1 := substring(alltrim(SB1->B1_DESC),1,25)
				cPar2 := substring(alltrim(SB1->B1_DESC),26,len(alltrim(SB1->B1_DESC)))
				cPar3 := "RDT FAN: "+AllTrim(SB1->B1_XFANB)
				cPar4 := "SN:"+nSomaSer
				cPar5 := "L: B"
				cPar6 := "IL:"+cIL2+"dB"
				AADD(aEtqs,{ cPar1, cPar2, cPar3, cPar4, cPar5, cPar6 } )

				nSomaSer := Soma1(nSomaSer)
				ETQ->(dbSkip())
				lUnico := .T.
				Loop

			ElseIf ETQ->G1_XXQTET1 > 0 .And. ETQ->G1_XXQTET2 <= 0

				// Monta somente o LADO A
				cPar1 := substring(alltrim(SB1->B1_DESC),1,25)
				cPar2 := substring(alltrim(SB1->B1_DESC),26,len(alltrim(SB1->B1_DESC)))
				cPar3 := "RDT FAN: "+AllTrim(SB1->B1_XFANA)
				cPar4 := "SN:"+nSomaSer
				cPar5 := "L: A"
				cPar6 := "IL:"+cIL1+"dB"
				AADD(aEtqs,{ cPar1, cPar2, cPar3, cPar4, cPar5, cPar6 } )


			ElseIf ETQ->G1_XXQTET1 <= 0 .And. ETQ->G1_XXQTET2 > 0

				// Monta somente o LADO B
				cPar1 := substring(alltrim(SB1->B1_DESC),1,25)
				cPar2 := substring(alltrim(SB1->B1_DESC),26,len(alltrim(SB1->B1_DESC)))
				cPar3 := "RDT FAN: "+AllTrim(SB1->B1_XFANB)
				cPar4 := "SN:"+nSomaSer
				cPar5 := "L: B"
				cPar6 := "IL:"+cIL2+"dB"
				AADD(aEtqs,{ cPar1, cPar2, cPar3, cPar4, cPar5, cPar6 } )


			EndIf

			ETQ->(dbSkip())

		EndDo

		If !lUnico
			nSomaSer := Soma1(nSomaSer)
		EndIf

	Next x

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
//³Impressão das etiquetas									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
	nCol := 0
	avar:={}
	For nQ := 1 To Len( aEtqs )
		
		nCol := nCol + 1
		If nCol == 1
			AADD(aVar,aEtqs[nQ,1])
			AADD(aVar,aEtqs[nQ,2])
			AADD(aVar,aEtqs[nQ,3])
			AADD(aVar,aEtqs[nQ,4])
			AADD(aVar,aEtqs[nQ,5])
			AADD(aVar,aEtqs[nQ,6])

		ElseIf nCol == 2

			AADD(aVar,aEtqs[nQ,1])
			AADD(aVar,aEtqs[nQ,2])
			AADD(aVar,aEtqs[nQ,3])
			AADD(aVar,aEtqs[nQ,4])
			AADD(aVar,aEtqs[nQ,5])
			AADD(aVar,aEtqs[nQ,6])

		ElseIf nCol == 3

			AADD(aVar,aEtqs[nQ,1])
			AADD(aVar,aEtqs[nQ,2])
			AADD(aVar,aEtqs[nQ,3])
			AADD(aVar,aEtqs[nQ,4])
			AADD(aVar,aEtqs[nQ,5])
			AADD(aVar,aEtqs[nQ,6])
			
		EndIf

		IF nCol == 3 .OR. nQ == Len( aEtqs )
		
			if nCol == 1
				For _y:= 1 to 12   
					AADD(aVar,"")
				Next _y
			Elseif nCol == 2
				For _y:= 1 to 6  
					AADD(aVar,"")
				Next _y
			Endif

			cPrn         := "DOMETQ52.prn"
			aVar         := aVar
			cVetor      := "!aVar"
			lTemperatura := .F.
			U_IMPPRN(cLocImp,cPrn,aVar,cVetor,lTemperatura)
			avar:={}
			nCol := 0
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
		//³Executa IMPRESSÃO NA ZEBRA			         	 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿

	Next nQ


	

// //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
// //³Impressão das última coluna de etiqueta   		 ³
// //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
// lResto := .F.
// If nCol == 1
//    cL71 += "FINAL"
//    cL71 += "FINAL"
//    cL71 += "FINAL"
//    cL71 += "FINAL"
//    cL71 += "FINAL"
//    cL71 += "FINAL"

//    lResto := .T.
// ElseIf nCol == 2 	
//    cL71 += "FINAL"
//    cL71 += "FINAL"
//    cL71 += "FINAL"
//    cL71 += "FINAL"
//    cL71 += "FINAL"
//    cL71 += "FINAL"

//    lResto := .T.
// EndIf

// If lResto


// EndIf

	ETQ->(dbCloseArea())

Return ( .T. )
