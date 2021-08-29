#include "print.ch"
#include "font.ch"  
#include "colors.ch"
#include "Protheus.ch"
#include "Topconn.ch" 
#include "Rwmake.ch"                               
#INCLUDE "RPCPR01.CH"

#xcommand @ <nLinha>, <nColuna> PSAY <cTexto>;
=> oprn:say(<nLinha>*50+100, <nColuna>*30/*-<nColuna>/2*/+40, transform(<cTexto>, ''), ofnt,,;
CLR_BLACK)

#xcommand @ <nLinha>, <nColuna> PSAY <cTexto> FONT <oFonte>;
=> oprn:say(<nLinha>*50+100, <nColuna>*25/*-<nColuna>/2*/+40, transform(<cTexto>, ''), <oFonte>,,;
CLR_BLACK)

#xcommand @ <nLinha>, <nColuna> PSAY <cTexto> PICTURE <cPicture>;
=> oprn:say(<nLinha>*50+100, <nColuna>*30/*-<nColuna>/2*/+40, transform(<cTexto>, <cPicture>), ofnt,,;
CLR_BLACK)

#xcommand @ <nLinha>, <nColuna> PSAY <cTexto> PICTURE <cPicture> FONT <oFonte>;
=> oprn:say(<nLinha>*50+100, <nColuna>*25/*-<nColuna>/2*/+40, transform(<cTexto>, <cPicture>), <oFonte>,,;
CLR_BLACK)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR820  ³ Autor ³ Paulo Boschetti       ³ Data ³ 07.07.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ordens de Producao                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ MATR820(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico³                                                  ³±±
±±³ Alteração³ FiveWin ³ Fabrício Becherini (10/05/04)                    ³±±
±±³          ³                                                            ³±±
±±³          ³09/06/11                                                    ³±±
±±³          ³ Alterado por Juliano Ferreira da Silva                     ³±±
±±³          ³ Corrigir o preenchimento dos campos                        ³±±
±±³          ³ Ordem de Fornecimento / Cod Cliente / Nome do Cliente      ³±±
±±³          ³ prazo solicitado expedição                                 ³±±
±±³          ³                                                            ³±±
±±³          ³ 11/08/11                                                   ³±±
±±³          ³ Alterado por Juliano, para tratar impressão                ³±±
±±³          ³ Frente e Verso                                             ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±³          ³ 16/04/19                                                   ³±± 
±±³          ³ Alterado por Michel Sander, para tratar novo leiaute       ³±±
±±³          ³ e cabeçalho de impressão da OP                             ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/

User Function RPCPR01E(lAuto,cImpOP,dDtExped)

	Local titulo  := "Ordens de Producao"
	Local wnrel   := "RPCPR01"
	Local tamanho := "G"
	Local cQry
	Local cOP1
	Local cOP2
	Private cPerg    :="RPCPR01"
	Private lItemNeg := .F.
	Private plinha   := .t.
	Private cContPg  := ""
	Private cOPCabec := ""
   Private nTotPage := 0
	Default lAuto    := .F.
	Default cImpOP   := ""

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lAuto
		If !Pergunte(cPerg,.T.)
			Return
		EndIf
	Else
		mv_par01 := cImpOP
		mv_par02 := cImpOP
		mv_par03 := CtoD("01/01/50")
		mv_par04 := CtoD("31/12/49")
		mv_par05 := 2
		mv_par06 := 1
		mv_par07 := 2
		mv_par08 := 1
		mv_par09 := 2
		mv_par10 := 3
		mv_par11 := 1
		mv_par12 := dDtExped
		mv_par13 := 3
		mv_par14 := 2
		mv_par15 := CtoD("")
		mv_par16 := CtoD("31/12/49")
		mv_par17 := 2
		mv_par18 := "    "
		mv_par19 := "ZZZZ"
		mv_par20 := 2
		mv_par21 := 1
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01            // Da OP                                 ³
	//³ mv_par02            // Ate a OP                              ³
	//³ mv_par03            // Da data                               ³
	//³ mv_par04            // Ate a data                            ³
	//³ mv_par05            // Imprime roteiro de operacoes          ³
	//³ mv_par06            // Imprime codigo de barras              ³
	//³ mv_par07            // Imprime Nome Cientifico               ³
	//³ mv_par08            // Imprime Op Encerrada                  ³
	//³ mv_par09            // Impr. por Ordem de                    ³
	//³ mv_par10            // Impr. OP's Firmes, Previstas ou Ambas ³
	//³ mv_par11            // Impr. Item Negativo na Estrutura      ³
	//³ mv_par12            // Data de Expedicao                     ³
	//³ mv_par13            // Imprime Processos para                ³
	//³ mv_par14            // Utiliza impresora frente e verso?     ³
	//³ mv_par15            // Da data de Programação de Produção    ³
	//³ mv_par16            // Ate data de Programação de Produção   ³
	//³ mv_par17            // Imprime somente OPs não impressas     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	//³ Coloca um flag em um campo criado para poder indicar ao pessoal do Estoque que um OP foi impressa. ³
	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	cContPg:=AllTrim(MV_PAR01)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lItemNeg := GetMv("MV_NEGESTR") .And. mv_par11 == 1

	PRINT oPrn preview
	
	DEFINE FONT ofnt  NAME "Courier New" 		SIZE 0,12 OF oprn
	DEFINE FONT ofnt2 NAME "Courier New" BOLD SIZE 0,10 OF oprn
	DEFINE FONT ofnt3 NAME "Courier New" BOLD SIZE 0,12 OF oprn

	RptStatus({|lEnd| R820Imp(@lEnd,wnRel,titulo,tamanho)},titulo)

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ R820Imp  ³ Autor ³ Waldemiro L. Lustosa  ³ Data ³ 13.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relat¢rio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R820Imp(lEnd,wnRel,titulo,tamanho)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local CbCont,cabec1,cabec2
	Local limite     := 100
	Local nQuant     := 1
	Local nomeprog   := "RPCPR01E"
	Local nTipo      := 18
	Local cProduto   := SPACE(LEN(SC2->C2_PRODUTO))
	Local cQtd
	Local cIndSC2    := CriaTrab(NIL,.F.), nIndSC2

	Local cQuery := ""
	Local cAlias := GetNextAlias()

	Private aArray   := {}
	Private li       := 100
	Private cOpAnt	 := ""

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cbtxt    := SPACE(0)
	cbcont   := 0                                      
	m_pag    := 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta os Cabecalhos                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cabec1 := ""
	cabec2 := ""

	dbSelectArea("SC2")

	cQuery := "SELECT SC2.R_E_C_N_O_ AS RECSC2, SB1.R_E_C_N_O_ AS RECSB1 FROM " + RetSqlName("SC2") + " (NOLOCK) SC2 "
	cQuery += "		INNER JOIN " + RetSqlName("SB1") + " (NOLOCK) SB1 ON SB1.B1_FILIAL = '' AND SB1.B1_COD = SC2.C2_PRODUTO "
	cQuery += "	WHERE SC2.D_E_L_E_T_ <> '*' "
	cQuery += "		AND SC2.C2_FILIAL = '01' "
	cQuery += "		AND SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"
	cQuery += "		AND SC2.C2_DATPRF BETWEEN '" + DtoS(mv_par03) + "' AND '" + DtoS(mv_par04) + "' "
	cQuery += If( mv_par08 <> 1,"	AND SC2.C2_DATRF = '' ", " ")
	cQuery += "		AND SC2.C2_TPOP = 'F' "
	cQuery += "		AND SC2.C2_XXDTPRO BETWEEN '" + DtoS(mv_par15) + "' AND '" + DtoS(mv_par16) + "' "
	cQuery += "		AND SB1.B1_GRUPO BETWEEN '" + mv_par18 + "' AND '" + mv_par19 + "' "
	cQuery += "		AND SB1.D_E_L_E_T_ <> '*' "
	If mv_par17 == 1
		If mv_par20 == 1
			cQuery += " AND SC2.C2_XPRTFF <> 'S' "
		Else
			cQuery += " AND SC2.C2_FLAG <> 'S' "
		EndIf
	EndIf
	If mv_par20 == 1
		cQuery += " AND SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN IN ( "
		cQuery += " 	SELECT DISTINCT D4_OP FROM " + RetSqlName("SD4") + " D4 "
		cQuery += " 	INNER JOIN " + RetSqlName("SB1") + " B1 ON B1_FILIAL = D4_FILIAL AND D4_COD = B1_COD "
		cQuery += " 	WHERE "
		cQuery += " 	D4.D_E_L_E_T_ <> '*' "
		cQuery += " 	AND B1.D_E_L_E_T_ <> '*' "
		cQuery += " 	AND B1_GRUPO IN ('FO','FOFS') "
		cQuery += " 	AND D4_OP BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' )  "
	EndIf
	cQuery += "		ORDER BY SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN ASC"

	dbUseArea( .T.,"TOPCONN", TcGenQry( ,,cQuery ), cAlias, .F., .T. )

	SetRegua(LastRec())

	If mv_par20 == 1

		While (cAlias)->(!Eof())
			IF lEnd
				@ Prow()+1,001 PSay STR0009	//"CANCELADO PELO OPERADOR"
				Exit
			EndIF

			IncRegua()

			DbSelectArea("SC2")
			SC2->(DbGoTo((cAlias)->RECSC2))
			
			RecLock("SC2",.F.)
			SC2->C2_XPRTFF  := "S"
			SC2->( msUnlock() )

			DbSelectArea("SB1")
			SB1->(DbGoTo((cAlias)->RECSB1))

			cProduto  := SC2->C2_PRODUTO
			nQuant    := aSC2Sld()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Adiciona o primeiro elemento da estrutura , ou seja , o Pai  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			AddAr820(nQuant)

			MontStruc(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD,nQuant)

			If mv_par09 == 1
				aSort( aArray,2,, { |x, y| (x[1]+x[8]) < (y[1]+y[8]) } )
			Else
				aSort( aArray,2,, { |x, y| (x[8]+x[1]) < (y[8]+y[1]) } )
			ENDIF

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Imprime cabecalho                                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nTotPage++
			cabecOp(Tamanho)
			
			aArrayBKP := aClone(aArray)
			aArray1	 := {}
			aArray2	 := {}

			AADD(aArray1, {aArray[1,1],aArray[1,2],aArray[1,3],aArray[1,4],aArray[1,5],aArray[1,6],aArray[1,7],aArray[1,8],aArray[1,9] } )

			aArray2 := {}

			For I := 2 TO Len(aArray)
				AADD(aArray2,aClone(aArray[I]))
			Next I

			aSort(aArray2 ,,,{|x, y| x[6]+x[1] < y[6]+y[1]} )

			aArray := {}

			AADD(aArray, {aArray1[1,1],aArray1[1,2],aArray1[1,3],aArray1[1,4],aArray1[1,5],aArray1[1,6],aArray1[1,7],aArray1[1,8],aArray1[1,9] } )

			For I := 1 to Len(aArray2)
				AADD(aArray, {aArray2[I,1],aArray2[I,2],aArray2[I,3],aArray2[I,4],aArray2[I,5],aArray2[I,6],aArray2[I,7],aArray2[I,8],aArray2[I,9] } )
			Next I

			For I := 2 TO Len(aArray)
				If AllTrim(Posicione("SB1",1,xFilial("SB1")+aArray[I][1],"B1_GRUPO")) == "FO" .Or. AllTrim(Posicione("SB1",1,xFilial("SB1")+aArray[I][1],"B1_GRUPO")) == "FOFS"

					If ALLTRIM(aArray[I][6])=="99"
					   Loop
					EndIf
					
					@Li , 02 PSay aArray[I][1]    	 				   	// CODIGO PRODUTO

					For nBegin := 1 To Len(Alltrim(aArray[I][2])) Step 31
						@li,025 PSay Substr(aArray[I][2],nBegin,31)
						li++
					Next nBegin
					li--
					cQtd := Alltrim(Transform(aArray[I][5],PesqPictQt("D4_QUANT",14)))
					@Li , (64-Len(cQtd)) PSay cQtd					// QUANTIDADE
					@Li ,  64 PSay "|"+aArray[I][4]+"|"			  	// UNIDADE DE MEDIDA
					@li ,  67 PSay aArray[I][6]+"|"             	// ALMOXARIFADO
					@li ,  79 PSay "|"+aArray[I][8]             	// SEQUENCIA
					Li++
					@Li,00 Psay /*CHR(27)+"(s-5B"+CHR(27)+'(s10H'+*/REPLICATE(CHR(151),170)
					li := li+1

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Se nao couber, salta para proxima folha                 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					IF li > 64
						Li := 1
						nTotPage++
						CabecOp(Tamanho)		// imprime cabecalho da OP
					EndIF
				EndIf
			Next I

			If mv_par05 == 1
				RotOper()   	// IMPRIME ROTEIRO DAS OPERACOES
			Else
				RotOper2()     // IMPRIME ROTEIRO DAS OPERACOES PERSONALIZADO
			Endif

			//	m_pag++
			Li := 0					// linha inicial - ejeta automatico
			aArray:={}
         nTotPage := 0
			cOpAnt := AllTrim(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)

			dbSelectArea("SC2")
			(cAlias)->(dbSkip())

		EndDO

	Else

		While (cAlias)->(!Eof())

			IF lEnd
				@ Prow()+1,001 PSay STR0009	//"CANCELADO PELO OPERADOR"
				Exit
			EndIF

			IncRegua()
			
			DbSelectArea("SC2")
			SC2->(DbGoTo((cAlias)->RECSC2))
			RecLock("SC2",.F.)
			SC2->C2_FLAG  := "S"
			SC2->( msUnlock() )

			DbSelectArea("SB1")
			SB1->(DbGoTo((cAlias)->RECSB1))

			cProduto  := SC2->C2_PRODUTO
			nQuant    := aSC2Sld()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Adiciona o primeiro elemento da estrutura , ou seja , o Pai  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			AddAr820(nQuant)

			MontStruc(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD,nQuant)

			If mv_par09 == 1
				aSort( aArray,2,, { |x, y| (x[1]+x[8]) < (y[1]+y[8]) } )
			Else
				aSort( aArray,2,, { |x, y| (x[8]+x[1]) < (y[8]+y[1]) } )
			ENDIF

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Imprime cabecalho                                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nTotPage++
			cabecOp(Tamanho)

			aArrayBKP := aClone(aArray)
			aArray1	 := {}
			aArray2	 := {}

			AADD(aArray1, {aArray[1,1],aArray[1,2],aArray[1,3],aArray[1,4],aArray[1,5],aArray[1,6],aArray[1,7],aArray[1,8],aArray[1,9] } )

			aArray2 := {}

			For I := 2 TO Len(aArray)
				AADD(aArray2,aClone(aArray[I]))
			Next I

			aSort(aArray2 ,,,{|x, y| x[6]+x[1] < y[6]+y[1]} )

			aArray := {}

			AADD(aArray, {aArray1[1,1],aArray1[1,2],aArray1[1,3],aArray1[1,4],aArray1[1,5],aArray1[1,6],aArray1[1,7],aArray1[1,8],aArray1[1,9] } )

			For I := 1 to Len(aArray2)
				AADD(aArray, {aArray2[I,1],aArray2[I,2],aArray2[I,3],aArray2[I,4],aArray2[I,5],aArray2[I,6],aArray2[I,7],aArray2[I,8],aArray2[I,9] } )
			Next I

			For I := 2 TO Len(aArray)

				If ALLTRIM(aArray[I][6])=="99"
				   Loop
				EndIf

				If Subs(aArray[I][6],1,2) <> '08' // Mão de Obra MOD

					@Li , 02 PSay aArray[I][1]    	 				   	// CODIGO PRODUTO

					For nBegin := 1 To Len(Alltrim(aArray[I][2])) Step 31
						@li,025 PSay Substr(aArray[I][2],nBegin,31)
						li++
					Next nBegin
					li--
					cQtd := Alltrim(Transform(aArray[I][5],PesqPictQt("D4_QUANT",14)))
					@Li , (64-Len(cQtd)) PSay cQtd					// QUANTIDADE
					@Li ,  64 PSay "|"+aArray[I][4]+"|"			  	// UNIDADE DE MEDIDA
					@li ,  67 PSay aArray[I][6]+"|"             	// ALMOXARIFADO
					//@li ,  69 PSay Substr(aArray[I][7],1,12)    	// LOCALIZACAO
					@li ,  79 PSay "|"+aArray[I][8]             	// SEQUENCIA
					Li++
					@Li,00 Psay /*CHR(27)+"(s-5B"+CHR(27)+'(s10H'+*/REPLICATE(CHR(151),170)
					li := li+1

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Se nao couber, salta para proxima folha                 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					IF li > 64
						Li := 1
						nTotPage++
						CabecOp(Tamanho)		// imprime cabecalho da OP
					EndIF
				EndIf
			Next I

			If mv_par05 == 1
				RotOper()   	// IMPRIME ROTEIRO DAS OPERACOES
			Else
				RotOper2()     // IMPRIME ROTEIRO DAS OPERACOES PERSONALIZADO
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Imprimir Relacao de medidas para Cliente == HUNTER DOUGLAS.  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SX3")
			dbSetOrder(1)
			dbSeek("SMX")
			If Found() .And. SC2->C2_DESTINA == "P"
				//R820Medidas()
			EndIf

			//	m_pag++
			Li := 0					// linha inicial - ejeta automatico
			aArray:={}
			nTotPage:=0
			cOpAnt := AllTrim(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)

			dbSelectArea("SC2")
			(cAlias)->(dbSkip())

		EndDO

	EndIf

	(cAlias)->(DbCloseArea())

	dbSelectArea("SH8")
	dbCloseArea() 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Retira o SH8 da variavel cFopened ref. a abertura no MNU     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ClosFile("SH8")

	dbSelectArea("SC2") 
	Set Filter To
	dbSetOrder(1)

	EndPrint
	ofnt:end()
	ofnt2:end()
	ofnt3:end()

Return NIL    

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ AddAr820 ³ Autor ³ Paulo Boschetti       ³ Data ³ 07/07/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Adiciona um elemento ao Array                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ AddAr820(ExpN1)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Quantidade da estrutura                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function AddAr820(nQuantItem)

	Local cDesc := SB1->B1_DESC
	Local cRoteiro:=""
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se imprime nome cientifico do produto. Se Sim    ³
	//³ verifica se existe registro no SB5 e se nao esta vazio    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par07 == 1
		dbSelectArea("SB5")
		dbSeek(xFilial()+SB1->B1_COD)
		If Found() .and. !Empty(B5_CEME)
			cDesc := B5_CEME
		EndIf
	ElseIf mv_par07 == 2
		cDesc := SB1->B1_DESC
	Else

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se imprime descricao digitada ped.venda, se sim  ³
		//³ verifica se existe registro no SC6 e se nao esta vazio    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SC2->C2_DESTINA == "P"
			dbSelectArea("SC6")
			dbSetOrder(1)
			dbSeek(xFilial()+SC2->C2_PEDIDO+SC2->C2_ITEM)
			If Found() .and. !Empty(C6_DESCRI) .and. C6_PRODUTO==SB1->B1_COD
				cDesc := C6_DESCRI
			ElseIf C6_PRODUTO # SB1->B1_COD
				dbSelectArea("SB5")
				dbSeek(xFilial("SB5")+SB1->B1_COD)
				If Found() .and. !Empty(B5_CEME)
					cDesc := B5_CEME
				EndIf
			EndIf
		EndIf

	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se imprime ROTEIRO da OP ou PADRAO do produto    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(SC2->C2_ROTEIRO)
		cRoteiro:=SC2->C2_ROTEIRO
	Else
		If !Empty(SB1->B1_OPERPAD)
			cRoteiro:=SB1->B1_OPERPAD
		Else
			dbSelectArea("SG2")
			If dbSeek(xFilial()+SC2->C2_PRODUTO+"01")
				RecLock("SB1",.F.)
				Replace B1_OPERPAD With "01"
				SB1->( MsUnLock() )
				cRoteiro:="01"
			EndIf
		EndIf
	EndIf

	dbSelectArea("SB2")
	dbSeek(xFilial()+SB1->B1_COD+SD4->D4_LOCAL)
	dbSelectArea("SD4")
	AADD(aArray, {SB1->B1_COD,cDesc,SB1->B1_TIPO,SB1->B1_UM,nQuantItem,D4_LOCAL,SD4->D4_TRT,D4_TRT,cRoteiro } )

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ MontStruc³ Autor ³ Ary Medeiros          ³ Data ³ 19/10/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Monta um array com a estrutura do produto                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ MontStruc(ExpC1,ExpN1,ExpN2)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do produto a ser explodido                  ³±±
±±³          ³ ExpN1 = Quantidade base a ser explodida                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

Static Function MontStruc(cOp,nQuant)

	dbSelectArea("SD4")
	dbSetOrder(2)
	dbSeek(xFilial()+cOp)

	While !Eof() .And. D4_FILIAL+D4_OP == xFilial()+cOp
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona no produto desejado                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SB1")
		dbSeek(xFilial()+SD4->D4_COD)
		If SD4->D4_QUANT > 0 .Or. (lItemNeg .And. SD4->D4_QUANT < 0)
			AddAr820(SD4->D4_QUANT)
		EndIf
		dbSelectArea("SD4")
		dbSkip()
	Enddo

	dbSetOrder(1)

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ CabecOp  ³ Autor ³ Paulo Boschetti       ³ Data ³ 07/07/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Monta o cabecalho da Ordem de Producao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ CabecOp()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function CabecOp(Tamanho)

	//								           012345678901234567890123456789012345678901234567890123456789012345678901234567890
	//                        			       1         2         3         4         5         6         7         8
	Local nBegin
	Local nPed
	Local cPed
	Local _nTamOK  :=100
	Local _nTamMax :=34

	If li # 5
		li := 0
	Endif  

	If plinha
		plinha := .f.
	Else
		endpage
		page
		If !Empty(cOpAnt) 
			If mv_par14 == 1 .And. SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN <> cOPCabec//Alltrim(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN) <> cOpAnt
			   if  (oprn:npage%2) == 0
			      endpage
			      page
			     
			   endif 
			endiF
		EndIf
	EndIf

	Li++
	@Li,00 Psay /*CHR(27)+"(s-5B"+CHR(27)+'(s10H'+*/REPLICATE(CHR(151),170)
	Li++
	@Li,25 Psay "ROSENBERGER DOMEX TELECOM"
	oPr := oprn
	cCode := (SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD) 
	MSBAR2("CODE128",1.60,12.5,Alltrim(cCode),opr,.F.,,.T.,0.025,0.5,NIL,NIL,NIL,.F.)  

	Li++
	@Li,00 Psay REPLICATE(CHR(151),170)
	Li++   

	DbSelectArea("SB1")
	DbSetOrder(1)
	DBSeek(xFilial("SB1")+SC2->C2_PRODUTO)

	DbSelectArea("SC5")
	DbSetOrder(1)
	DbSeek(xFilial("SC5")+SC2->C2_PEDIDO)

	DbSelectArea("SC6")
	DbSetOrder(1)
	DbSeek(xFilial("SC6")+SC2->C2_PEDIDO+SC2->C2_ITEMPV)

	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1")+SC2->C2_CLIENT)

//   If nTotPage == 1
		If Empty(Alltrim(SC2->C2_NPEDIDO))
			@Li,10 Psay "Ordem de Fornecimento: "+Alltrim(SC2->C2_PEDIDO) Font ofnt2
		Else
			@Li,10 Psay "Ordem de Fornecimento: "+Alltrim(SC2->C2_PEDIDO)+" / "+Alltrim(SC2->C2_NPEDIDO)  Font ofnt2
		EndIf 
		@Li,54 Psay "Ordem de Montagem: "+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN Font ofnt2
//   EndIf
   
	// Imprimindo o cabeçalho apenas para a primeira página da OP
	If SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN <> cOPCabec // oprn:npage == 1
		cOPCabec := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN

		Li++
		@Li,00 Psay REPLICATE(CHR(151),170)
		Li++
		@Li,10 Psay "Plano Produção: "+Dtoc(mv_par12) Font ofnt2
		@Li,35 Psay "OTD: "+DtoC(SC6->C6_XXDTDEF) Font ofnt2
		@Li,49 PSay "Emissão.: " +DTOC(dDatabase) Font ofnt2
		//tratamento TagFornecedor
		If SC6->(FieldPos("C6_XTAGFOR")) > 0
			If SC6->C6_XTAGFOR == 'S'
	  			@Li,67 Psay "TAG Fornecedor: SIM" Font ofnt3
	  		Else
	  			@Li,67 Psay "TAG Fornecedor: NAO" Font ofnt3	  			
			EndIf
		EndIf
		Li++ 
		@Li,10 Psay "CÓDIGO DO CLIENTE: "+SA1->A1_COD+"-"+SA1->A1_LOJA+" "+SA1->A1_NOME Font ofnt2
		Li++
		@Li,00 Psay REPLICATE(CHR(151),170)
		Li++         
		@Li,10 PSay "Produto: "+aArray[1][1]+"  "+aArray[1][2] Font ofnt2
		Li+=1
		If SubStr(SB1->B1_GRUPO,1,3)=="DIO"
			MSBAR2("CODE128",7.0,9.0,SB1->B1_COD,opr,.F.,,.T.,0.025,0.5,NIL,NIL,NIL,.F.)   
		EndIf	
		Li+=1		
		nTamanho := 80

		If Empty(SB1->B1_XDESC)
   		@Li,05 Psay Substr(SB1->B1_DESCR1,1,60)+Substr(SB1->B1_DESCR2,1,20)
   		Li++
   		@Li,05 Psay Substr(SB1->B1_DESCR2,21,40)+Substr(SB1->B1_DESCR3,1,40)
   		Li++
		   @Li,05 Psay Substr(SB1->B1_DESCR3,41,20)+Substr(SB1->B1_DESCR4,1,60)
		   Li++
		   @Li,05 Psay Substr(SB1->B1_DESCR5,1,60)
		   Li++   		   
		Else
		   @Li,05 Psay Substr(SB1->B1_XDESC,(nTamanho*0)+1,nTamanho)
		   Li++
		   @Li,05 Psay Substr(SB1->B1_XDESC,(nTamanho*1)+1,nTamanho)
		   Li++
		   @Li,05 Psay Substr(SB1->B1_XDESC,(nTamanho*2)+1,nTamanho)
		   Li++   
		   @Li,05 Psay Substr(SB1->B1_XDESC,(nTamanho*3)+1,nTamanho)
		   Li++   
		EndIF
		
  			If AT("EXPORTACAO",SC5->C5_ESP1) > 0
				//MSBAR2("CODE128",9.7,8.0,AllTrim(SC5->C5_ESP1),opr,.F.,,.T.,0.025,0.5,NIL,NIL,NIL,.F.)  
				@Li,60 Psay "***EXPORTAÇÃO***"
			EndIf
		
		If ("HUAWEI" $ Upper(SA1->A1_NOME)) .Or. ("HUAWEI" $ Upper(SA1->A1_NREDUZ))
			@Li,00 Psay "PN Huawei: "+AllTrim(SC6->C6_SEUCOD)
			If !Empty(SC6->C6_SEUCOD)
				MSBAR2("CODE128",7.0,5.0,Alltrim(StrTran(SC6->C6_SEUCOD,"–","")),opr,.F.,,.T.,0.025,0.5,NIL,NIL,NIL,.F.)
			EndIf
		EndIf
				
		li++                    
		@Li,00 Psay REPLICATE(CHR(151),170)
		Li++                      

		If mv_par21 == 1

			@li,10 Psay "Requisitos Cliente: " Font oFnt3
			@Li,30 Psay Substr(SC2->C2_REQ1,01,65)
			Li++
			@Li,20 Psay Substr(SC2->C2_REQ2,01,65)
			Li++
			@Li,20 Psay Substr(SC2->C2_REQ3,01,65)
			Li++
			@Li,10 Psay "Pedido do Cliente: "
			@Li,30 Psay SC5->C5_ESP1
	
		
	
			Li++
			Li++
			@Li,10 Psay "Código do Cliente: "
			@Li,30 Psay SC6->C6_SEUCOD
	
			If !Empty(SC6->C6_SEUCOD)
				MSBAR2("CODE128",10.5,8.0,Alltrim(StrTran(SC6->C6_SEUCOD,"–","-")),opr,.F.,,.T.,0.025,0.5,NIL,NIL,NIL,.F.)
			EndIf
	
			Li++
			Li++
			@Li,10 Psay "Item do Pedido/Cliente: "
			@Li,30 Psay SC6->C6_SEUDES + "   Revisao: "+Alltrim(SC6->C6_XXRSTAT)
			If !Empty(SC6->C6_SEUDES)
				MSBAR2("CODE128",11.5,8.0,Alltrim(SC6->C6_SEUDES),opr,.F.,,.T.,0.025,0.5,NIL,NIL,NIL,.F.)
			EndIf
	
			Li+=2
			@Li,10 Psay "Observação: "+MemoLine(SC5->C5_OBSGERA ,100,1,100,.T.)
	
      EndIf
                                                                         
      If mv_par21==1
			Li+=2         
		Else
			Li++
		EndIf
		@Li,10 Psay "Número de Série (Inicial): " Font ofnt3
		  
		_cSerieIni:=""
		IF "294KIT" $ SC2->C2_PRODUTO
			Do Case
				CASE (SC2->C2_QUANT*12)<= 99
				@Li,34 Psay (AllTrim(SC2->C2_NUM))+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"01"
				_cSerieIni:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)  +"01"
				CASE ((SC2->C2_QUANT*12)>= 100 .AND. (SC2->C2_QUANT*12)<= 999)
				@Li,34 Psay (AllTrim(SC2->C2_NUM))+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"001"
				_cSerieIni:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)  +"001"
				CASE ((SC2->C2_QUANT*12)>= 1000 .AND. (SC2->C2_QUANT*12)<= 9999)
				@Li,34 Psay (AllTrim(SC2->C2_NUM))+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"0001"
				_cSerieIni:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)  +"0001"
				CASE ((SC2->C2_QUANT*12)>= 10000 .AND. (SC2->C2_QUANT*12)<= 99999)
				@Li,34 Psay (AllTrim(SC2->C2_NUM))+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"00001"
				_cSerieIni:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)  +"00001"
			EndCase
		ELSE
			Do Case
				Case SC2->C2_QUANT <=9
				@Li,32 Psay (AllTrim(SC2->C2_NUM))+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"1"
				_cSerieIni:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"1"
				//@ l, c Psay 'A'
				Case  SC2->C2_QUANT >=10 .And.  SC2->C2_QUANT <= 99
				@Li,32 Psay (AllTrim(SC2->C2_NUM))+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"01"
				_cSerieIni:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)  +"01"
				//@ l, c Psay 'B'
				Case  SC2->C2_QUANT >=100 .And. SC2->C2_QUANT <= 999
				@Li,32 Psay (AllTrim(SC2->C2_NUM))+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"001"
				_cSerieIni:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)  +"001"
				//@ l, c Psay 'C'
				Case  SC2->C2_QUANT >=1000 .And. SC2->C2_QUANT <= 9999
				@Li,32 Psay (AllTrim(SC2->C2_NUM))+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"0001"
				_cSerieIni:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)  +"0001"  
				Case  SC2->C2_QUANT >=10000 .And. SC2->C2_QUANT <= 99999
				@Li,32 Psay (AllTrim(SC2->C2_NUM))+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"00001"
				_cSerieIni:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)  +"00001"  
			EndCase
		ENDIF
                     
      If mv_par21 == 1
			nPosUso := 13.1
		Else
		   nPosUso := 8.8
		EndIf
		   	
		MSBAR2("CODE128",nPosUso,8.3,_cSerieIni,opr,.F.,,.T.,0.025,0.5,NIL,NIL,NIL,.F.)

		@Li,54 Psay "Número de Série (Final):" Font ofnt3

		IF "294KIT" $ SC2->C2_PRODUTO
			@Li,66 Psay (AllTrim(SC2->C2_NUM))+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+(AllTrim(Str(SC2->C2_QUANT*12)))  //TRANSFORM(SC2->C2_QUANT)
		else
			@Li,66 Psay (AllTrim(SC2->C2_NUM))+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+(AllTrim(Str(SC2->C2_QUANT)))
		Endif
		Li++
		@Li,66 Psay REPLICATE(CHR(151),170)
		Li++
		@Li,00 Psay REPLICATE(CHR(151),170)
		Li++

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime a quantidade original quando a quantidade da    ³
		//³ Op for diferente da quantidade ja entregue              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SC2->C2_QUJE + SC2->C2_PERDA > 0
			@Li,00 PSay STR0017 //"Qtde Prod.:"
			@Li,11 PSay aSC2Sld()		PICTURE PesqPictQt("C2_QUANT",14)
			@Li,26 PSay "Qtde Orig.:"
			@Li,37 PSay TRANSFORM(SC2->C2_QUANT,"@E 99,999,999,999.99") Font ofnt2
		Else
			@Li,10 PSay "Quantidade :" Font ofnt2
			@Li,25 PSay TRANSFORM(SC2->C2_QUANT - SC2->C2_QUJE,"@E 99,999,999,999.99") Font ofnt2
		Endif
		@Li,52 PSay "Unid. Medida : " +aArray[1][4]

	EndIf

	If !(Empty(SC2->C2_OBS))
		@Li,10 PSay STR0029						//"Observacao: "
		For nBegin := 1 To Len(Alltrim(SC2->C2_OBS)) Step 65
			@li,012 PSay Substr(SC2->C2_OBS,nBegin,65)
			li++
		Next nBegin
	EndIf

   Li++
	@Li,00 Psay REPLICATE(CHR(151),170)
	Li++
	@Li,30 PSay  "C O M P O N E N T E S " Font ofnt3
	Li++
	@Li,00 Psay REPLICATE(CHR(151),170)
	Li++

	@Li, 10 PSay  "CÓDIGO             DESCRIÇÃO                       QUANTIDADE |UM|AL|  DESENHO    "
	Li++
	@Li,00 Psay REPLICATE(CHR(151),170)
	Li++

Return
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ RotOper  ³ Autor ³ Paulo Boschetti       ³ Data ³ 18/07/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Imprime Roteiro de Operacoes                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ RotOper()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function RotOper()

	Local nBegin, lSH8

	dbSelectArea("SG2")
	If dbSeek(xFilial()+aArray[1][1]+aArray[1][9],.F.)

		cRotOper()

		While !Eof() .And. G2_FILIAL+G2_PRODUTO+G2_CODIGO = xFilial()+aArray[1][1]+aArray[1][9]

			dbSelectArea("SH4")
			dbSeek(xFilial()+SG2->G2_FERRAM)

			dbSelectArea("SH8")
			dbSetOrder(1)
			dbSeek(xFilial()+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD+SG2->G2_OPERAC)
			lSH8 := IIf(Found(),.T.,.F.)

			If lSH8
				While !Eof() .And. SH8->H8_FILIAL+SH8->H8_OP+SH8->H8_OPER == xFilial()+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD+SG2->G2_OPERAC
					ImpRot(lSH8)
					dbSelectArea("SH8")
					dbSkip()
				End
			Else
				ImpRot(lSH8)
			Endif

			dbSelectArea("SG2")
			dbSkip()

		EndDo

	Endif

Return Li

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ RotOper2  ³ Autor ³Paulo Boschetti       ³ Data ³ 18/07/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Imprime Roteiro de Operacoes Personalizado - DOMEX         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ RotOper2()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DOMEX                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³ CASSANDRA JACINTO DA SILVA - 15/08/2003                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function RotOper2()

	Local aTitulo := {}

	//Optico
	aadd(aTitulo, {"CORTE |1|______ |2|______ |3|______"} )  
	aadd(aTitulo, {"CONFERÊNCIA                        "} )
	aadd(aTitulo, {"OPERACOES                          "} )
	Li++

	@Li,00 Psay REPLICATE(CHR(151),170)

	Li++
	@Li,22 Psay "R O T E I R O  D E  O P E R A Ç Õ E S" Font ofnt3
	Li++
	@Li,00 Psay REPLICATE(CHR(151),170)
	Li++
	Li++

	dbSelectArea("SH8")
	dbSetOrder(1)
	dbSeek(xFilial()+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD+SG2->G2_OPERAC)
	lSH8 := IIf(Found(),.T.,.F.)

	For nCont:=1 to Len(aTitulo)
		IF Li > 59	
			Li := 0
			Li++
			endpage
			page
			//page
			Li++
			@Li,22 Psay "R O T E I R O  D E  O P E R A Ç Õ E S" Font ofnt3
			Li++
			@Li,00 Psay REPLICATE(CHR(151),170)
			Li++
			Li++
		Endif                   

		@Li,07 PSay aTitulo[nCont,1]
		@Li,40 PSay "Ass.______________________"
		@Li,66 PSay "Data __/__/__ "
		Li++
		@Li,80 PSay ""
		Li++
	Next

	If mv_par14 == 1.And.Alltrim(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN) <> cContPg
		if  (oprn:npage%2) <> 0
			endpage
			page
			cContPg :=Alltrim(SC2->C2_NUM+" "+SC2->C2_ITEM+SC2->C2_SEQUEN)
		endif 
	endif

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ ImpRot   ³ Autor ³ Marcos Bregantim      ³ Data ³ 10/07/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Imprime Roteiro de Operacoes                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ ImpRot()                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function ImpRot(lSH8)

	Local nBegin

	dbSelectArea("SH1")
	dbSeek(xFilial()+IIf(lSH8,SH8->H8_RECURSO,SG2->G2_RECURSO))

	@Li,00 PSay IIF(lSH8,SH8->H8_RECURSO,SG2->G2_RECURSO)+" "+SUBS(SH1->H1_DESCRI,1,25)
	@Li,33 PSay SG2->G2_FERRAM+" "+SUBS(SH4->H4_DESCRI,1,20)
	@Li,61 PSay SG2->G2_OPERAC

	For nBegin := 1 To Len(Alltrim(SG2->G2_DESCRI)) Step 16
		@li,064 PSay Substr(SG2->G2_DESCRI,nBegin,16)
		li++
	Next nBegin

	Li+=1
	@Li,00 PSay STR0032+IIF(lSH8,DTOC(SH8->H8_DTINI),Space(8))+" "+IIF(lSH8,SH8->H8_HRINI,Space(5))+" "+STR0033+" ____/ ____/____ ___:___"	//"INICIO  ALOC.: "###" INICIO  REAL :"
	Li++
	@Li,00 PSay STR0034+IIF(lSH8,DTOC(SH8->H8_DTFIM),Space(8))+" "+IIF(lSH8,SH8->H8_HRFIM,Space(5))+" "+STR0035+" ____/ ____/____ ___:___"	//"TERMINO ALOC.: "###" TERMINO REAL :"
	Li++
	@Li,00 PSay STR0019	//"Quantidade :"
	@Li,13 PSay IIF(lSH8,SH8->H8_QUANT,aSC2Sld()) PICTURE PesqPictQt("H8_QUANT",14)
	@Li,28 PSay STR0036	//"Quantidade Produzida :               Perdas :"
	Li++                                                                 
	@Li,00 PSay "Data __/__/__ASS. __________________________________"
	Li++                                                                 
	@Li,00 PSay __PrtThinLine()
	Li++

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ RotOper  ³ Autor ³ Paulo Boschetti       ³ Data ³ 18/07/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Imprime Roteiro de Operacoes                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ RotOper()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function cRotOper()

	Li++
	@Li,00 Psay REPLICATE(CHR(151),170)
	Li++
	@Li,24 Psay "O R D E M   D E   M O N T A G E M"     
	@Li,65 Psay "OM: "+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SPACE(05)+CHR(27) Font ofnt2
	Li++
	@Li,00 Psay REPLICATE(CHR(151),170)
	Li++  
	@Li,00 PSay "Produto: "+aArray[1][1] //"Produto: "
	ImpDescr(aArray[1][2]) 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime a quantidade original quando a quantidade da    ³
	//³ Op for diferente da quantidade ja entregue              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SC2->C2_QUJE + SC2->C2_PERDA > 0
		@Li,00 PSay STR0017			//"Qtde Prod.:"
		@Li,11 PSay aSC2Sld()		PICTURE PesqPictQt("C2_QUANT",14)
		@Li,26 PSay STR0018			//"Qtde Orig.:"
		@Li,37 PSay SC2->C2_QUANT	PICTURE PesqPictQt("C2_QUANT",14)
	Else
		@Li,00 PSay STR0019		//"Quantidade :"
		@Li,15 PSay aSC2Sld()	PICTURE PesqPictQt("C2_QUANT",14)
	Endif

	Li++
	@Li,00 PSay STR0023+SC2->C2_CC	//"C.Custo: "
	Li++
	@Li,00 Psay REPLICATE(CHR(151),170)
	Li++
	@Li,00 Psay "RECURSO                       FERRAMENTA               OPERAÇÃO"
	Li++
	@Li,00 Psay REPLICATE(CHR(151),170)
	Li++

	***

Return Li      

Static Function ImpDescr(cDescri)

	For nBegin := 1 To Len(Alltrim(cDescri)) Step 50
		@li,025 PSay Substr(cDescri,nBegin,50)
		li++
	Next nBegin

Return
