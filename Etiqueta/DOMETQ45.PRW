#include "protheus.ch"
#include "rwmake.ch"

User Function DOMETQ45(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,lColetor,cNumSerie,cNumPeca)

	Local aVar := {}
	Local x
	Local _i
	Local aPar       := {}

	Local aRet       := {}
	Local nVar       := 0
	Local cRotacao   := "N"      //(N,R,I,B)
	Local mv_par02   := 1         //Qtd Embalagem
	Local mv_par03   := 1         //Qtd Etiquetas
	Local aRetAnat   := {}        //Codigos Anatel, Array
	Local aCodAnat   := {}        //Codigos Anatel, Array
	Local cCdAnat1   := ""        //Codigo Anatel 1
	Local cCdAnat2   := ""        //Codigo Anatel 2

	Private lAchou   := .T.
	Private aGrpAnat := {}     //Codigos Anatel Agrupados
	Private _cSerieIni:=""
	Default cNumOP   := ""
	Default cNumSenf := ""
	Default nQtdEmb  := 0
	Default nQtdEtq  := 0
	Default cNumSerie := ""
	Default cNumPeca  := ""

	mv_par02:= nQtdEmb   //Qtd Embalagem
	mv_par03:= nQtdEtq   //Qtd Etiquetas

	If !Empty(cNumOP)
		SC2->(DbSetOrder(1))
		If lAchou .And. SC2->(!DbSeek(xFilial("SC2")+cNumOP))
			Alert("Numero O.P. "+AllTrim(cNumOP)+" não localizada!")
			lAchou := .F.
		EndIf
	EndIf

	//Localiza SA1
	If !Empty(SC2->C2_PEDIDO)
		SA1->(DbSetOrder(1))
		If lAchou .And. SA1->(!DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
			Alert("Cliente "+SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI+" não localizado!")
			lAchou := .F.
		EndIf
	EndIf

	//Localiza SB1
	SB1->(DbSetOrder(1))
	If lAchou .And. SB1->(!DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
		Alert("Produto "+AllTrim(SC2->C2_PRODUTO)+" não localizado!")
		lAchou := .F.
	EndIf

	If lAchou
		aRetAnat := U_fCodNat(SB1->B1_COD)
		lAchou   := aRetAnat[1]
		aCodAnat := aRetAnat[2]
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

		Case Val(SB1->B1_XXNANAT) == 1 .And. Len(aGrpAnat) == 1
			cCdAnat1 := aGrpAnat[1]
			cCdAnat2 := ""

		Case Val(SB1->B1_XXNANAT) == 2 .And. Len(aGrpAnat) == 1
			cCdAnat1 := aGrpAnat[1]
			cCdAnat2 := aGrpAnat[1]

		Case Val(SB1->B1_XXNANAT) == 3 .And. Len(aGrpAnat) == 2
			cCdAnat1 := aGrpAnat[1]
			cCdAnat2 := aGrpAnat[2]
		EndCase

	EndIf

	If !Empty(cNumOP)
		//Localiza SC2
		SC2->(DbSetOrder(1))
		If lAchou .And. SC2->(!DbSeek(xFilial("SC2")+cNumOP))
			Alert("Numero O.P. "+AllTrim(cNumOP)+" não localizada!")
			lAchou := .F.
		EndIf
	EndIf

	//Valida se Campo Descricao do Produto está preenchido
	If lAchou .And. Empty(SB1->B1_DESC)
		Alert("Campo Descricao do Produto não está preenchido no cadastro do produto! "+Chr(13)+Chr(10)+"[B1_DESC]")
		lAchou := .F.
	EndIf

	//Caso algum registro não seja localizado, sair da rotina
	If !lAchou
		Return(.T.)
	EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta o número de série														 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	cSerieFim := If( cNumSerie == 1, 1, cNumSerie )
	If Len(Alltrim(SC2->C2_NUM)) <=5
		If SC2->C2_QUANT <=9
			cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,1)	// MV_PAR07 Sequencial Serial
		ElseIf SC2->C2_QUANT >=10 .And.  SC2->C2_QUANT <= 99
			cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,2)	// MV_PAR07 Sequencial Serial
		ElseIf SC2->C2_QUANT >=100 .And. SC2->C2_QUANT <= 999
			cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,3)	// MV_PAR07 Sequencial Serial
		ElseIf SC2->C2_QUANT >=1000 .And. SC2->C2_QUANT <= 9999
			cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,4)	// MV_PAR07 Sequencial Serial
		ElseIf SC2->C2_QUANT >=10000 .And. SC2->C2_QUANT <= 99999
			cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,5)	// MV_PAR07 Sequencial Serial
		EndIf
	Else
		Do Case
		Case SC2->C2_QUANT <=9
			cNumSerie:="S" + AllTrim(SC2->C2_NUM)+SC2->C2_ITEM+SC2->C2_SEQUEN+STRZERO(cSerieFim,1)	// MV_PAR07 Sequencial Serial
		Case  SC2->C2_QUANT >=10 .And.  SC2->C2_QUANT <= 99
			cNumSerie:="S" + AllTrim(SC2->C2_NUM)+SC2->C2_ITEM+SC2->C2_SEQUEN+STRZERO(cSerieFim,2)	// MV_PAR07 Sequencial Serial
		Case  SC2->C2_QUANT >=100 .And. SC2->C2_QUANT <= 999
			cNumSerie:="S" + AllTrim(SC2->C2_NUM)+SC2->C2_ITEM+SC2->C2_SEQUEN+STRZERO(cSerieFim,3)	// MV_PAR07 Sequencial Serial
		Case  SC2->C2_QUANT >=1000 .And. SC2->C2_QUANT <= 9999
			cNumSerie:="S" + AllTrim(SC2->C2_NUM)+SC2->C2_ITEM+SC2->C2_SEQUEN+STRZERO(cSerieFim,4)	// MV_PAR07 Sequencial Serial
		Case  SC2->C2_QUANT >=10000 .And. SC2->C2_QUANT <= 99999
			cNumSerie:="S" + AllTrim(SC2->C2_NUM)+SC2->C2_ITEM+SC2->C2_SEQUEN+STRZERO(cSerieFim,5)	// MV_PAR07 Sequencial Serial
		EndCase
	EndIf

	lImprime := .F.
	nCol := 05
	nIni := 07
	nLin := 04

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
//³Montagem do código de barras 2D					³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
	cSQL    := "SELECT dbo.SemanaProtheus() AS SEMANA"
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"WEEK",.F.,.T.)
	cSemana := WEEK->SEMANA
	cWW     := StrZero(Val(SubsTr(cSemana,5,2)),2)
	cYY     := Substr(cSemana,3,2)

	WEEK->(dbCloseArea())

	a    := 0
	cSerial1 := ""
	cSerial2 := ""
	cSerial3 := ""
	cVar1 := SC2->C2_PRODUTO
	cVar2 := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN +"  "+cWW+cYY
	nPrint:= Ceiling(mv_par03/3)

	For _i := 1 to nPrint

		nEtiq:= 3
		if _i == nPrint
			nEtiqLin:= round(mv_par03/3,1)- int(round(mv_par03/3,1))
			If nEtiqLin > 0 .AND. nEtiqLin < 0.6
				nEtiq:= 1
			ElseIf nEtiqLin > 0.6
				nEtiq:= 2
			ElseIf nEtiqLin == 0 .AND. nEtiqLin <= 0.5
				nEtiq:= 3
			Endif
		Endif

		aVar := {}

		If nEtiq >= 1
			cSerial1   := cNumSerie
			AADD(aVar,cVar1)              //1
			AADD(aVar,cVar2)              //2
			AADD(aVar,cSerial1)           //3
			cNumSerie := Soma1(cNumSerie)
		Endif

		If nEtiq >= 2
			cSerial2   := cNumSerie
			AADD(aVar,cVar1)              //1
			AADD(aVar,cVar2)              //2
			AADD(aVar,cSerial2)           //3
			cNumSerie := Soma1(cNumSerie)
		Endif

		If nEtiq == 3
			cSerial3   := cNumSerie
			AADD(aVar,cVar1)              //1
			AADD(aVar,cVar2)              //2
			AADD(aVar,cSerial3)           //3
			cNumSerie := Soma1(cNumSerie)
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
		//³Executa IMPRESSÃO NA ZEBRA			         	 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿

		cLocImp      := "LPT1"
		cPrn         := "DOMETQ45.prn"
		aVar         := aVar
		cVetor      := "!aVar"
		lTemperatura := .F.
		U_IMPPRN(cLocImp,cPrn,aVar,cVetor,lTemperatura)

	Next _i

Return(.T.)
