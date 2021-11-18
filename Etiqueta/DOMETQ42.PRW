#include "protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DOMETQ42 ºAutor  ³ Ricardo Roda       º Data ³  08.11.2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Etiqueta Cordão Ericsson  (Novo Modelo 85)		          º±±
±±º          ³            		 Layout 42                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P12                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DOMETQ42(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,lColetor,cNumSerie,cNumPeca,cLocImp)

	Local mv_par02    := 1         //Qtd Embalagem
	Local mv_par03    := 1         //Qtd Etiquetas
	Local nP
	Local nY

	Private lAchou    := .T.
	private aRetPar   := {}
	Private aPar:= {}
	Private aCodEtq:= {}
	Private _aArq:={}

	Default cNumOP    := ""
	Default cNumSenf  := ""
	Default nQtdEmb   := 0
	Default nQtdEtq   := 0
	Default cNumSerie := "1"
	Default cNumPeca  := ""
	Default cLocImp  := ""


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Busca quantidades para impressão											 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	mv_par02:= nQtdEmb   //Qtd Embalagem
	mv_par03:= nQtdEtq   //Qtd Etiquetas


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

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
	//³Montagem do código de barras 2D						 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
	cSQL    := "SELECT dbo.SemanaProtheus() AS SEMANA"
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"WEEK",.F.,.T.)
	cSemana := WEEK->SEMANA
	cYYYY   := SUBSTR(cSemana,1,4)
	cWW     := STRZERO(Val(SUBSTR(cSemana,5,2)),2)
	WEEK->(dbCloseArea())

	cOptions   := "2;0;1;Ericsson"			// Parametro 1 (2= Impressora 1=Visualiza)
	cNumSerie1 := SPACE(12)
	cNumSerie2 := SPACE(12)

	// Primeira Etiqueta
	cMVPAR01 := SC6->C6_SEUCOD
	//cMVPAR02 := "COAXIAL CABLE"
	cMVPAR02 := SB1->B1_DESC
	cMVPAR03 := cYYYY+cWW
	cMVPAR04 := "MADE IN BRAZIL"
	cMVPAR05 := SC6->C6_XXRSTAT
	cMVPAR06 := "T.A."
	cMVPAR07 := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
	cMVPAR08 := "" //cNumSerie1

	// Segunda Etiqueta
	cMVPAR09 := SC6->C6_SEUCOD
	cMVPAR10 := SB1->B1_DESC
	cMVPAR11 := cYYYY+cWW
	cMVPAR12 := "MADE IN BRAZIL"
	cMVPAR13 := SC6->C6_XXRSTAT
	cMVPAR14 := "T.A."
	cMVPAR15 := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
	cMVPAR16 := ""//cNumSerie2

	cParam := cMVPAR01+";"+cMVPAR02+";"+cMVPAR03+";"+cMVPAR04+";"+cMVPAR05+";"+cMVPAR06+";"+cMVPAR07+";"+cMVPAR08+";"
	cParam += cMVPAR09+";"+cMVPAR10+";"+cMVPAR11+";"+cMVPAR12+";"+cMVPAR13+";"+cMVPAR14+";"+cMVPAR15+";"+cMVPAR16+";"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
	//³Executa Crystal Reports para impressão			 	 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿

	Sleep(200)

	cNumSerie1 := SPACE(12)
	cNumSerie2 := SPACE(12)

	AADD(_aArq,'CT~~CD,~CC^~CT~'+CRLF)
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
	AADD(_aArq,'^JUS'+CRLF)
	AADD(_aArq,'^LRN'+CRLF)
	AADD(_aArq,'^CI27'+CRLF)
	AADD(_aArq,'^PA0,1,1,0'+CRLF)
	AADD(_aArq,'^XZ'+CRLF)
	AADD(_aArq,'^XA'+CRLF)
	AADD(_aArq,'^MMT'+CRLF)
	AADD(_aArq,'^PW945'+CRLF)
	AADD(_aArq,'^LL886'+CRLF)
	AADD(_aArq,'^LS0'+CRLF)

	nlin:= 15
	nCol:= 15
	AADD(_aArq,'^FT'+cValtoChar(nCol+27)+','+cValtoChar(nlin+148)+'^A0N,25,30^FH\^CI28^FD'+cMVPAR01+'^FS^CI27'+CRLF)
	AADD(_aArq,'^FT'+cValtoChar(nCol+319)+','+cValtoChar(nlin+148)+'^A0N,25,30^FH\^CI28^FD'+cMVPAR05+'^FS^CI27'+CRLF)
	AADD(_aArq,'^FT'+cValtoChar(nCol+27)+','+cValtoChar(nlin+169)+'^A0N,17,15^FH\^CI28^FD'+cMVPAR02+'^FS^CI27'+CRLF)
	AADD(_aArq,'^FT'+cValtoChar(nCol+27)+','+cValtoChar(nlin+194)+'^A0N,21,23^FH\^CI28^FD'+cMVPAR03+'^FS^CI27'+CRLF)
	AADD(_aArq,'^FT'+cValtoChar(nCol+179)+','+cValtoChar(nlin+194)+'^A0N,21,23^FH\^CI28^FD'+cMVPAR07+'^FS^CI27'+CRLF)
	AADD(_aArq,'^FO'+cValtoChar(nCol+330)+','+cValtoChar(nlin+173)+'^GFA,85,240,8,:Z64:eJxjYCAN1P9h4G/AQjM3MMgewE5bPEClKz5A6IICVPr/D6w04wEZMF14QKYAmS5u4Csg0fFAAAB0jiFo:6A4A'+CRLF)
	AADD(_aArq,'^FO'+cValtoChar(nCol+27)+','+cValtoChar(nlin+207)+'^GFA,261,720,24,:Z64:eJzV0TEOwjAMBVBXDN2cC5jmGh6QuApHiAQSGRh6rI49io/g0QMDrgMUBiQ2xB+fIvsnAfjv1NrPec4KTAxpTrqR3giby+KDu3xwTXb3iyUhJQDODFiQe4UajkLl1Qvou0+Ah6efpkGpZAn3vZZqJ+F+urlFT+Rudj8/fWtLH0HeNM/a5rsjozftx/C9Nafwkq/hR3bX1Wu+JqCki7f7UoVkyO4WXnere5vdcPdCeXy8pyAxhv/6n7/NDeDzcNQ=:C159'+CRLF)
	AADD(_aArq,'^FO'+cValtoChar(nCol+250)+','+cValtoChar(nlin+207)+'^GFA,397,600,20,:Z64:eJydkLFKxDAYx5OGI6VIMnpCaB3lllt7WHoOPoYPcd1uOEjp5NR7AZGOxVdQJKDg6As4dCwuZnAIWhPb5pzSyW/88fH//74PgH+NN8GOJ5jJHQSNu7acYLxzEDKtw7C5GIXuguo0KOqFVy0CpD3bROUmelIcy4QhGdmIfbc1r8rsdUpQPvpBccQ2EkMRhhEDs9EF5SRdNQQ0IVmXYK3BYS8TGEqG+z3+afNK9d3QVj/Q+/LgN/RmYqY4wydv2J6G3qk6b4BaPtKVRl+BzSNxJgDDNzjukLB+giTb1k/QLYm1V1i/58Hv8gpTNt8BG9j3pjH/GO6I0z8/3u9FL3IH5TyBXI7F9bVfB0Veg+rMR6Zx//fjvh4pl0HhMpBPMDu/TsZufw==:9ED3'+CRLF)

	nCol:= 21
	AADD(_aArq,'^FT'+cValtoChar(nCol+501)+','+cValtoChar(nlin+148)+'^A0N,25,30^FH\^CI28^FD'+cMVPAR01+'^FS^CI27'+CRLF)
	AADD(_aArq,'^FT'+cValtoChar(nCol+789)+','+cValtoChar(nlin+148)+'^A0N,25,30^FH\^CI28^FD'+cMVPAR05+'^FS^CI27'+CRLF)
	AADD(_aArq,'^FT'+cValtoChar(nCol+501)+','+cValtoChar(nlin+169)+'^A0N,17,15^FH\^CI28^FD'+cMVPAR02+'^FS^CI27'+CRLF)
	AADD(_aArq,'^FT'+cValtoChar(nCol+501)+','+cValtoChar(nlin+194)+'^A0N,21,23^FH\^CI28^FD'+cMVPAR03+'^FS^CI27'+CRLF)
	AADD(_aArq,'^FT'+cValtoChar(nCol+654)+','+cValtoChar(nlin+194)+'^A0N,21,23^FH\^CI28^FD'+cMVPAR07+'^FS^CI27'+CRLF)
	AADD(_aArq,'^FO'+cValtoChar(nCol+804)+','+cValtoChar(nlin+173)+'^GFA,85,240,8,:Z64:eJxjYCAN1P9h4G/AQjM3MMgewE5bPEClKz5A6IICVPr/D6w04wEZMF14QKYAmS5u4Csg0fFAAAB0jiFo:6A4A'+CRLF)
	AADD(_aArq,'^FO'+cValtoChar(nCol+717)+','+cValtoChar(nlin+207)+'^GFA,397,600,20,:Z64:eJydkLFKxDAYx5OGI6VIMnpCaB3lllt7WHoOPoYPcd1uOEjp5NR7AZGOxVdQJKDg6As4dCwuZnAIWhPb5pzSyW/88fH//74PgH+NN8GOJ5jJHQSNu7acYLxzEDKtw7C5GIXuguo0KOqFVy0CpD3bROUmelIcy4QhGdmIfbc1r8rsdUpQPvpBccQ2EkMRhhEDs9EF5SRdNQQ0IVmXYK3BYS8TGEqG+z3+afNK9d3QVj/Q+/LgN/RmYqY4wydv2J6G3qk6b4BaPtKVRl+BzSNxJgDDNzjukLB+giTb1k/QLYm1V1i/58Hv8gpTNt8BG9j3pjH/GO6I0z8/3u9FL3IH5TyBXI7F9bVfB0Veg+rMR6Zx//fjvh4pl0HhMpBPMDu/TsZufw==:9ED3'+CRLF)
	AADD(_aArq,'^FO'+cValtoChar(nCol+501)+','+cValtoChar(nlin+207)+'^GFA,261,720,24,:Z64:eJzV0TEOwjAMBVBXDN2cC5jmGh6QuApHiAQSGRh6rI49io/g0QMDrgMUBiQ2xB+fIvsnAfjv1NrPec4KTAxpTrqR3giby+KDu3xwTXb3iyUhJQDODFiQe4UajkLl1Qvou0+Ah6efpkGpZAn3vZZqJ+F+urlFT+Rudj8/fWtLH0HeNM/a5rsjozftx/C9Nafwkq/hR3bX1Wu+JqCki7f7UoVkyO4WXnere5vdcPdCeXy8pyAxhv/6n7/NDeDzcNQ=:C159'+CRLF)

	AADD(_aArq,'^PQ'+cValtoChar(mv_par03)+',0,1,Y'+CRLF)
	AADD(_aArq,'^XZ'+CRLF)
	AaDd(aCodEtq,_aArq)

	For nY:=1 To Len(aCodEtq)
		For nP:=1 To Len(aCodEtq[nY])
			MSCBWrite(aCodEtq[nY][nP])
		Next nP
	Next nY

	MSCBEND()
	MSCBCLOSEPRINTER()

Return ( .T. )
