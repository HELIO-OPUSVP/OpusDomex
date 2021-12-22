#include "protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DOMETQ83 ºAutor  ³ Michel A. Sander   º Data ³  08.11.2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Etiqueta Modelo 28 - Junção Trunk 					           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMETQ44(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,lColetor,cNumSerie,cNumPeca)

	Local cModelo    := "Z4M"
	Local lPrinOK    := MSCBModelo("ZPL",cModelo)
	Local mv_par02   := 1         //Qtd Embalagem
	Local mv_par03   := 1         //Qtd Etiquetas
	Local y
	Local x
	Local nP
	Local nY
	Local _i

	Private cCdAnat1   := ""        //Codigo Anatel 1
	Private cCdAnat2   := ""        //Codigo Anatel 2
	Private lAchou     := .T.
	Private aGrpAnat   := {}     //Codigos Anatel Agrupados
	Private _cSerieIni := ""

	Private aCodEtq    := {}
	Private _aArq      :={}
	private aRetPar   := {}
	Private aPar:= {}
	Private cFila:= ""
	Private cMVPAR01a:= ""
	Private cMVPAR01b:= ""
	Private cMVPAR01c:= ""

	Default cNumOP   := ""
	Default cNumSenf := ""
	Default nQtdEmb  := 0
	Default nQtdEtq  := 0
	Default cNumSerie := ""
	Default cNumPeca  := ""

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

//Se impressora não identificada, sair da rotina
	If !lPrinOK
		Alert("Erro de configuração!")
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
		cAssunto := "Etiqueta Layout 083 - Junção Trunk 28"
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
	cOptions := "2;0;1;Trunk"			// Parametro 1 (2= Impressora 1=Visualiza)
	nQ 		:= 1
	nSomaSer := cNumSerie
	nDobra   := If(SUBSTR(SB1->B1_GRUPO,1,4)=="TRUN", 2, 1)
	cIL1     := AllTrim(TransForm(SB1->B1_XXIL1,"9.99"))
	cIL2     := AllTrim(TransForm(SB1->B1_XXIL2,"9.99"))
	nAviso   := Aviso("Atenção","Tipo de impressão",{"Total","Parcial"})
	nChoice  := If(nAviso==1,SC2->C2_QUANT,mv_par03)

	// cFila := cPorta
	// IF !CB5SetImp(cFila,.F.)
	// 	U_MsgColetor("Local de impressao invalido!")
	// 	Return .F.
	// EndIf

	if empty(Alltrim(cFila))
		aAdd(aPar,{1,"Escolha a Impressora " ,SPACE(6) ,"@!"       ,'.T.' , 'CB5', '.T.', 20 , .T. } )
		If !ParamBox(aPar,"INFORMAR IMPRESSORA",@aRetPar)
			Return
		EndIf

		cFila := ALLTRIM(aRetPar[1])
	Endif

	If !CB5SetImp(cFila,.F.)
		MsgAlert("Local de impressao invalido!","Aviso")
		Return .F.
	EndIf

	For x := 1 to nChoice

		ETQ->(dbGoTop())
		Do While ETQ->(!Eof())

			If ETQ->G1_XXQTET1 > 0

				For y := 1 to nDobra


					aTemp := QuebraString(SB1->B1_DESC,23)

					// cMVPAR01a := aTemp[1]

					// if len(aTemp) > 1
					// 	cMVPAR01b := aTemp[2]
					// Endif

					// If len(aTemp) > 2
					// 	cMVPAR01c := aTemp[3]
					// Endif

					cMVPAR02 := "LADO: A"
					cMVPAR03 := "PN:"+SB1->B1_COD
					cMVPAR04 := "SN:"+nSomaSer
					cMVPAR05 := "IL:"+cIL1+"dB"
					cMVPAR06 := SUBSTR(cSemana,5,2)+"/"+SUBSTR(cSemana,3,2)


					cParam   := cMVPAR01a+cMVPAR01b+cMVPAR01c+";"+cMVPAR02+";"+cMVPAR03+";"+cMVPAR04+";"+cMVPAR05+";"+cMVPAR06+";"

					AADD(_aArq,'CT~~CD,~CC^~CT~'+ CRLF)
					AADD(_aArq,'^XA'+ CRLF)
					AADD(_aArq,'~TA000'+ CRLF)
					AADD(_aArq,'~JSN'+ CRLF)
					AADD(_aArq,'^LT0'+ CRLF)
					AADD(_aArq,'^MNW'+ CRLF)
					AADD(_aArq,'^MTT'+ CRLF)
					AADD(_aArq,'^PON'+ CRLF)
					AADD(_aArq,'^PMN'+ CRLF)
					AADD(_aArq,'^LH0,0'+ CRLF)
					AADD(_aArq,'^JMA'+ CRLF)
					AADD(_aArq,'^PR6,6'+ CRLF)
					AADD(_aArq,'^JUS'+ CRLF)
					AADD(_aArq,'^LRN'+ CRLF)
					AADD(_aArq,'^CI27'+ CRLF)
					AADD(_aArq,'^PA0,1,1,0'+ CRLF)
					AADD(_aArq,'^XZ'+ CRLF)
					AADD(_aArq,'^XA'+ CRLF)
					AADD(_aArq,'^MMT'+ CRLF)
					AADD(_aArq,'^PW400'+ CRLF)
					AADD(_aArq,'^LL200'+ CRLF)
					AADD(_aArq,'^LS0'+ CRLF)

					nLin:= 137
					for _i := 1 to len(aTemp)
						AADD(_aArq,'^FT'+cValtoChar(nLin)+',194^A0B,16,15^FH\^CI28^FD'+aTemp[_i]+'^FS^CI27'+ CRLF)
						nLin+= 24
					Next
					// AADD(_aArq,'^FT137,194^A0B,16,15^FH\^CI28^FD'+cMVPAR01a+'^FS^CI27'+ CRLF)
					// AADD(_aArq,'^FT159,194^A0B,16,15^FH\^CI28^FD'+cMVPAR01a+'^FS^CI27'+ CRLF)
					// AADD(_aArq,'^FT182,194^A0B,16,15^FH\^CI28^FD'+cMVPAR01a+'^FS^CI27'+ CRLF)
					AADD(_aArq,'^FT317,194^A0B,17,18^FH\^CI28^FD'+cMVPAR03+'^FS^CI27'+ CRLF)
					AADD(_aArq,'^FT341,194^A0B,17,18^FH\^CI28^FD'+cMVPAR04+'^FS^CI27'+ CRLF)
					AADD(_aArq,'^FT366,194^A0B,18,18^FH\^CI28^FD'+cMVPAR05+'^FS^CI27'+ CRLF)
					AADD(_aArq,'^FT257,190^A0B,28,30^FH\^CI28^FD'+cMVPAR02+'^FS^CI27'+ CRLF)
					AADD(_aArq,'^FT366,71^A0B,18,18^FH\^CI28^FD'+cMVPAR06+'^FS^CI27'+ CRLF)
					AADD(_aArq,'^FO51,25^GFA,497,1304,8,:Z64:eJyN0rFOwzAQBmBbRXRBSUeGyn4FRoaoeRzWjAwV6aNZYq14AoZ0KkPUmK1So5r0/j8RDg3goZ/SnO/suyj1bd3RJV0D3QqLGTQptHkFg6MI52s1O8bP9jxyBU0C728vtSo1+4DzGqaHy1uv7EUdvKHLkZJXvy5SyX/Dupmbi22lPZW41kucrum2sLHeKNaT04Uq7ZX8uYMJ7jPUDy33nWlIKOrs9tCN3DUwNHJOHQ44d3hjPYX3lTKGJrFWCh4ZF7zcv3NOZR6XZ8f+e8y6lDmtXck+BfbnuEJ/pAFdX3wCq8jaw+BlX9cfWDqYbwLnjZVvID+aLl6xz3BHK+qK6NmeEG8ZP+WP1eefEmkHVS8/4sl943oZ77dmgpb3axlf020RW4/ysS+DpYOWdTR94v8N6zQ+9q2IfS/i89D+nOrZxffp59XXH+ZFP3+flz798z7qQX7TPeLTibmaF0SbDC4fr2uyxdX9f34nXF8AEhF6:12FC'+ CRLF)
					//AADD(_aArq,'^FO55,18^GFA,633,1408,8,:Z64:eJyNlDFu20AQRUcUIxJb0YBYS0lF6Awp1gAPoMZlgBzBXcosWBk6xYIVwSI3Sp0gRZAuKQw73Pl/lCwbewoNvmbfzOxfQSL/RSF5OOYD86yfpTyiOnzXXFW/oOcI/cxuP4j9oQZ+rbsvgTx1Edg/RZA6JO1FPiYdpRhFdfUt5UncmOqN7N7qbtG9S7r3JfTkZvb/lM/fPOL80mKJvd3tWOj5Xja636VzP5Vvqt8pDR3W62WH8xN067eqTxF86bfKu0BewC/7gO/Jz4Pqmw34OA7Kew9/wnhR3t9CL3Xc3ydLFn4Man8rmyedP1z9reAX/PSy29I/atSnUKj/N832CX6A763/JA/sp89bLO8rer8D/Tvpvnt5f4B/nYN/9xX8o0HNvc4fu6Pq3kPPcVa+9Z+f4R/6lfLha9K11A9B/sUpIvde6D+yPyPHjprnQ66LCL4k78i3dw11lCzqXIrV1/MtDPcr/Vp+HaeA3Bh/zPmL8Tww8L69nWf9zPPmX0ntQj6vML3a75b+jrY/j104r+T82eaTn6Z8/2M+7jq/tX3Z3694zwbr943Wn1+8dD9bgP3t/d/cnanBl/j3kZrv33B8Z9dlN/tx7lm/8qvf10vxFxXKloc=:9C3A'+ CRLF)
					AADD(_aArq,'^PQ1,0,1,Y'+ CRLF)
					AADD(_aArq,'^XZ'+ CRLF)
					AaDd(aCodEtq,_aArq)
					_aArq:= {}

				Next y

			EndIf

			If ETQ->G1_XXQTET2 > 0

				For y := 1 to nDobra

					aTemp := U_QuebraString(SB1->B1_DESC,23)

					// cMVPAR01a := aTemp[1]

					// if len(aTemp) > 1
					// 	cMVPAR01b := aTemp[2]
					// Endif

					// If len(aTemp) > 2
					// 	cMVPAR01c := aTemp[3]
					// Endif

					cMVPAR02 := "LADO: B"
					cMVPAR03 := "PN:"+SB1->B1_COD
					cMVPAR04 := "SN:"+nSomaSer
					cMVPAR05 := "IL:"+cIL1+"dB"
					cMVPAR06 := SUBSTR(cSemana,5,2)+"/"+SUBSTR(cSemana,3,2)


					cParam   := cMVPAR01a+cMVPAR01b+cMVPAR01c+";"+cMVPAR02+";"+cMVPAR03+";"+cMVPAR04+";"+cMVPAR05+";"+cMVPAR06+";"

					AADD(_aArq,'CT~~CD,~CC^~CT~'+ CRLF)
					AADD(_aArq,'^XA'+ CRLF)
					AADD(_aArq,'~TA000'+ CRLF)
					AADD(_aArq,'~JSN'+ CRLF)
					AADD(_aArq,'^LT0'+ CRLF)
					AADD(_aArq,'^MNW'+ CRLF)
					AADD(_aArq,'^MTT'+ CRLF)
					AADD(_aArq,'^PON'+ CRLF)
					AADD(_aArq,'^PMN'+ CRLF)
					AADD(_aArq,'^LH0,0'+ CRLF)
					AADD(_aArq,'^JMA'+ CRLF)
					AADD(_aArq,'^PR6,6'+ CRLF)
					AADD(_aArq,'^JUS'+ CRLF)
					AADD(_aArq,'^LRN'+ CRLF)
					AADD(_aArq,'^CI27'+ CRLF)
					AADD(_aArq,'^PA0,1,1,0'+ CRLF)
					AADD(_aArq,'^XZ'+ CRLF)
					AADD(_aArq,'^XA'+ CRLF)
					AADD(_aArq,'^MMT'+ CRLF)
					AADD(_aArq,'^PW400'+ CRLF)
					AADD(_aArq,'^LL200'+ CRLF)
					AADD(_aArq,'^LS0'+ CRLF)
					nLin:= 137
					for _i := 1 to len(aTemp)
						AADD(_aArq,'^FT'+cValtoChar(nLin)+',194^A0B,16,15^FH\^CI28^FD'+aTemp[_i]+'^FS^CI27'+ CRLF)
						nLin+=23
					Next
					// AADD(_aArq,'^FT137,194^A0B,16,15^FH\^CI28^FD'+cMVPAR01a+'^FS^CI27'+ CRLF)
					// AADD(_aArq,'^FT159,194^A0B,16,15^FH\^CI28^FD'+cMVPAR01a+'^FS^CI27'+ CRLF)
					// AADD(_aArq,'^FT182,194^A0B,16,15^FH\^CI28^FD'+cMVPAR01a+'^FS^CI27'+ CRLF)
					AADD(_aArq,'^FT317,194^A0B,17,18^FH\^CI28^FD'+cMVPAR03+'^FS^CI27'+ CRLF)
					AADD(_aArq,'^FT341,194^A0B,17,18^FH\^CI28^FD'+cMVPAR04+'^FS^CI27'+ CRLF)
					AADD(_aArq,'^FT366,194^A0B,18,18^FH\^CI28^FD'+cMVPAR05+'^FS^CI27'+ CRLF)
					AADD(_aArq,'^FT257,190^A0B,28,30^FH\^CI28^FD'+cMVPAR02+'^FS^CI27'+ CRLF)
					AADD(_aArq,'^FT366,71^A0B,18,18^FH\^CI28^FD'+cMVPAR06+'^FS^CI27'+ CRLF)
					//AADD(_aArq,'^FO55,18^GFA,633,1408,8,:Z64:eJyNlDFu20AQRUcUIxJb0YBYS0lF6Awp1gAPoMZlgBzBXcosWBk6xYIVwSI3Sp0gRZAuKQw73Pl/lCwbewoNvmbfzOxfQSL/RSF5OOYD86yfpTyiOnzXXFW/oOcI/cxuP4j9oQZ+rbsvgTx1Edg/RZA6JO1FPiYdpRhFdfUt5UncmOqN7N7qbtG9S7r3JfTkZvb/lM/fPOL80mKJvd3tWOj5Xja636VzP5Vvqt8pDR3W62WH8xN067eqTxF86bfKu0BewC/7gO/Jz4Pqmw34OA7Kew9/wnhR3t9CL3Xc3ydLFn4Man8rmyedP1z9reAX/PSy29I/atSnUKj/N832CX6A763/JA/sp89bLO8rer8D/Tvpvnt5f4B/nYN/9xX8o0HNvc4fu6Pq3kPPcVa+9Z+f4R/6lfLha9K11A9B/sUpIvde6D+yPyPHjprnQ66LCL4k78i3dw11lCzqXIrV1/MtDPcr/Vp+HaeA3Bh/zPmL8Tww8L69nWf9zPPmX0ntQj6vML3a75b+jrY/j104r+T82eaTn6Z8/2M+7jq/tX3Z3694zwbr943Wn1+8dD9bgP3t/d/cnanBl/j3kZrv33B8Z9dlN/tx7lm/8qvf10vxFxXKloc=:9C3A'+ CRLF)
					AADD(_aArq,'^FO51,25^GFA,497,1304,8,:Z64:eJyN0rFOwzAQBmBbRXRBSUeGyn4FRoaoeRzWjAwV6aNZYq14AoZ0KkPUmK1So5r0/j8RDg3goZ/SnO/suyj1bd3RJV0D3QqLGTQptHkFg6MI52s1O8bP9jxyBU0C728vtSo1+4DzGqaHy1uv7EUdvKHLkZJXvy5SyX/Dupmbi22lPZW41kucrum2sLHeKNaT04Uq7ZX8uYMJ7jPUDy33nWlIKOrs9tCN3DUwNHJOHQ44d3hjPYX3lTKGJrFWCh4ZF7zcv3NOZR6XZ8f+e8y6lDmtXck+BfbnuEJ/pAFdX3wCq8jaw+BlX9cfWDqYbwLnjZVvID+aLl6xz3BHK+qK6NmeEG8ZP+WP1eefEmkHVS8/4sl943oZ77dmgpb3axlf020RW4/ysS+DpYOWdTR94v8N6zQ+9q2IfS/i89D+nOrZxffp59XXH+ZFP3+flz798z7qQX7TPeLTibmaF0SbDC4fr2uyxdX9f34nXF8AEhF6:12FC'+ CRLF)
					AADD(_aArq,'^PQ1,0,1,Y'+ CRLF)
					AADD(_aArq,'^XZ'+ CRLF)
					AaDd(aCodEtq,_aArq)
						_aArq:= {}

				Next y

			EndIf

			ETQ->(dbSkip())

		EndDo

		nSomaSer := Soma1(nSomaSer)

	Next x

	For nY:=1 To Len(aCodEtq)
		For nP:=1 To Len(aCodEtq[nY])
			MSCBWrite(aCodEtq[nY][nP])
		Next nP
	Next nY

	aCodEtq:={}

	MSCBEND()

	MSCBCLOSEPRINTER()

	ETQ->(dbCloseArea())

Return ( .T. )



Static Function QuebraString(cString,nStep)// Considerando espaços
Local aRetorno := {}
Local d, b

cString := StrTran(cString,Chr(13)," ")

cString += Space(200)

For d := 1 to 500 Step(nStep)
	If !Empty(Subs(cString,d,nStep))
		nStep2 := nStep
		nvar   := 0
		For b := 1 to 30
			If !Subs(cString,d+nStep2-1,1) == ' '
				nStep2  -= 1
				nvar    += 1
			Else
				b := 30
			EndIf
		Next b
		AADD(aRetorno, Subs(cString,d,nStep2) )
		d -= nvar
	EndIf
Next

Return aRetorno
