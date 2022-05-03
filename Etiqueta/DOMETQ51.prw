#include "protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DOMETQ51 ºAutor  ³ Michel A. Sander   º Data ³  08.11.2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³     Etiqueta Cordão Ericsson (Substituta DOMETQ85)         º±±
±±º          ³               Impressora ZEBRA                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P12                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMETQ51(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,lColetor,cNumSerie,cNumPeca,cLocImp)

	Local mv_par02    := 1         //Qtd Embalagem
	Local mv_par03    := 1         //Qtd Etiquetas
	Local x
	Private lAchou    := .T.
	Private aPar:={}
	Private aRetPar:={}
	Default cNumOP    := ""
	Default cNumSenf  := ""
	Default nQtdEmb   := 0
	Default nQtdEtq   := 0
	Default cNumSerie := "1"
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

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida descrição do pedido   									 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	SC6->(DbSetOrder(1))
	If lAchou .And. SC6->(!DbSeek(xFilial("SC6")+SC2->C2_PEDIDO+SC2->C2_ITEMPV))
		Alert("Item P.V. "+AllTrim(SC2->C2_ITEMPV)+" não localizado!")
		lAchou := .F.
	EndIf

	//Caso algum registro não seja localizado, sair da rotina
	If !lAchou
		Return(.T.)
	EndIf

	cGrupo :=SB1->B1_GRUPO

	DO CASE
	CASE ALLTRIM(cGrupo)=='FLEX'
		cTipoETQ:='COAXIAL CABLE'
	CASE ALLTRIM(cGrupo)=='CORD'
		cTipoETQ:='FIBER CABLE'
	CASE ALLTRIM(cGrupo)=='TRUE'
		cTipoETQ:='MULTIFIBER CABLE'
	OTHERWISE
		cTipoETQ:=space(15)
	ENDCASE

	if empty(Alltrim(cLocImp))
		aAdd(aPar,{1,"Escolha a Impressora " ,SPACE(6) ,"@!"       ,'.T.' , 'CB5', '.T.', 20 , .T. } )
		If !ParamBox(aPar,"INFORMAR IMPRESSORA",@aRetPar)
			Return "INFORMAR IMPRESSORA"
		EndIf
		cLocImp := ALLTRIM(aRetPar[1])
	Endif


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
	//³Montagem do código de barras 2D						 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
	cSQL    := "SELECT dbo.SemanaProtheus() AS SEMANA"
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"WEEK",.F.,.T.)
	cSemana := WEEK->SEMANA
	cYYYY   := SUBSTR(cSemana,1,4)
	cWW     := STRZERO(Val(SUBSTR(cSemana,5,2)),2)
	WEEK->(dbCloseArea())

	x := 0

	For x := 1 to mv_par03

		cVar1:= SC6->C6_SEUCOD
		cVar2:= SB1->B1_DESC
		cVar3:= cYYYY+cWW
		cVar4:= SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
		cVar5:= SC6->C6_XXRSTAT


		aVar:={}
		AADD(aVar,cVar1)
		AADD(aVar,cVar2)
		AADD(aVar,cVar3)
		AADD(aVar,cVar4)
		AADD(aVar,cVar5)


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
		//³Executa IMPRESSÃO NA ZEBRA			         	 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿

		cPrn         := "DOMETQ51.prn"
		aVar         := aVar
		cVetor      := "!aVar"
		lTemperatura := .F.
		U_IMPPRN(cLocImp,cPrn,aVar,cVetor,lTemperatura)


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
		//³Executa Crystal Reports para impressão			 	 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿

		Sleep(200)


	Next

Return ( .T. )
