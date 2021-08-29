#include "totvs.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CustOpus    ºAutor  ³Helio Ferreira    º Data ³  29/05/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Custo médio 100% personalizado                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CustOpus()

	If Type("cUsuario") == 'U'
		RPCSetType(3)
		RpcSetEnv("01","01",,,"EST") //   PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"
	EndIf

	cUsuario := cUsuario

	If Subs(cUsuario,7,5) <> 'HELIO'
		MsgInfo("Usuário não autorizado para a execução dessa rotina")
		Return
	EndIf

	oProcess := MsNewProcess():New({|lEnd| ProcRun(@oProcess, @lEnd) },"Recalculo do Custo Médio","Preparando início dos cálculos",.T.)

	oProcess:Activate()

Return

Static Function ProcRun()

	Local x, y, z, n, o, lProdOk
	Local cPerg     :="CUSTOPUS"
	Local aBkpPerg  := {}
	Local aPerg     := {}

	//PRIVATE QUERY01 := 0
	//PRIVATE QUERY02 := 0
	//PRIVATE QUERY03 := 0
	//PRIVATE QUERY04 := 0
	//PRIVATE QUERY05 := 0
	//PRIVATE QUERY06 := 0
	//PRIVATE QUERY07 := 0
	//PRIVATE QUERY08 := 0
	//PRIVATE QUERY09 := 0
	//PRIVATE QUERY10 := 0
	//PRIVATE QUERY11 := 0
	//PRIVATE QUERY12 := 0
	//PRIVATE QUERY13 := 0
	//PRIVATE QUERY14 := 0
	//PRIVATE QUERY15 := 0
	//PRIVATE QUERY16 := 0
	//PRIVATE QUERY17 := 0
	//PRIVATE QUERY18 := 0
	//PRIVATE QUERY19 := 0
	//PRIVATE QUERY20 := 0

	Private lAtualizaSD3 := .T.
	Private lCustOPQuery := .T.

	//Chama pergunta ocultamente para alimentar variáveis
	Pergunte(cPerg,.F.,,,,,@aBkpPerg)
	Pergunte(cPerg,.F.,,,,,@aPerg   )

	//Altera conteúdo de alguma pergunta
	mv_par01 := GetMV("MV_ULMES") + 1

	//Carrega variável principal para que os parâmetros
	//definido acima sejam salvos na próxima chamada
	SaveMVVars(.T.)

	__SaveParam(cPerg, aPerg)

	If !Pergunte(cPerg)
		Return
	EndIf

	If mv_par01 <> GetMV("MV_ULMES") + 1
		MsgInfo("Data de início do cálculo inválida.")
		Return
	EndIf

	If mv_par01 > mv_par02
		MsgInfo("Data de início do cálculo superior a data final.")
		Return
	EndIf

	cHoraIni := DtoS(Date())+Time()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Carregando o SD3 todo para o vetor aSD3                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//nPD3FILIAL := 1
	nPD3COD    := 2
	nPD3LOCAL  := 3
	nPD3CF     := 4
	nPD3TM     := 5
	nPD3OP     := 6
	nPD3NUMSEQ := 7
	nPD3QUANT  := 8
	nPD3CUSTO1 := 9
	nPD3RECNO  := 10
	aSD3       := {}

	npD3RECNO := npD3RECNO

	//cQuery := "SELECT D3_FILIAL, D3_COD, D3_LOCAL, D3_CF, D3_TM, D3_OP, D3_NUMSEQ, D3_QUANT, D3_XCUSTO1, R_E_C_N_O_ "
	cQuery += "FROM SD3010 "
	cQuery += "WHERE D3_FILIAL = '"+xFilial("SD3")+"' "
	//cQuery += "AND D3_EMISSAO >= '"+DtoS(mv_par01)+"'  AND D3_EMISSAO <=  '"+DtoS(mv_par02)+"' ""

	If lCustOPQuery   // Se o custo das OPs for por query, não precisa de todos os produtos no array aSD3, portanto pode filtrar somente os produtos mv_par03 e 04 para a QUERY_MONTA_ASD3
		cQuery += "AND D3_COD >= '" + mv_par03 + "' AND D3_COD <= '" + mv_par04 + "' "
	EndIf

	cQuery += "AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "
	cQuery += "ORDER BY D3_COD, D3_LOCAL, R_E_C_N_O_ "

	If Select("QUERY_MONTA_ASD3") <> 0
		QUERY_MONTA_ASD3->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS "QUERY_MONTA_ASD3"

	//                               1                   2                3                  4               5               6               7                   8                  9                   10
	QUERY_MONTA_ASD3->( dbEval({||AADD(aSD3,{QUERY_MONTA_ASD3->D3_FILIAL,QUERY_MONTA_ASD3->D3_COD,QUERY_MONTA_ASD3->D3_LOCAL,QUERY_MONTA_ASD3->D3_CF,QUERY_MONTA_ASD3->D3_TM,QUERY_MONTA_ASD3->D3_OP,QUERY_MONTA_ASD3->D3_NUMSEQ,QUERY_MONTA_ASD3->D3_QUANT,QUERY_MONTA_ASD3->D3_XCUSTO1,QUERY_MONTA_ASD3->R_E_C_N_O_}) }) )

	oProcess:IncRegua1("Etapa 1 concluída em : " + RetTempo(cHoraIni   ,DtoS(Date())+Time()))

	aSD3_op_numseq := aClone(aSD3)
	aSort(aSD3_op_numseq,,, {|x,y| x[npD3OP] < y[npD3OP] .and. x[npD3NUMSEQ] < y[npD3NUMSEQ] } )

	If mv_par05 == 1 // Zera custos no inicio da rotina

		If lAtualizaSD3
			cWhere := "WHERE D3_FILIAL = '"+xFilial("SD3")+"' AND D3_EMISSAO >= '"+DtoS(mv_par01)+"' "
			cWhere += "AND D3_EMISSAO <= '"+DtoS(mv_par02)+"' AND D3_XCUSTO1 <> 0 "
			cWhere += "AND D3_COD >= '" + mv_par03 + "' AND D3_COD <= '" + mv_par04 + "' "
			cWhere += "AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "

			If Empty(mv_par03) .and. Alltrim(Upper(mv_par04)) == Repl("Z",Len(Alltrim(mv_par04)))
				// Se for produto de branco a zzz, zera as requisições e devoluções, senão apenas as requisições
				cWhere += "AND D3_CF IN ('RE4','DE4','PR0','PR1','RE0','RE1','RE2','DE0') "
			Else
				cWhere += "AND D3_CF IN ('RE4',      'PR0','PR1','RE0','RE1','RE2','DE0') "
			EndIf

			cQuery := "SELECT SUBSTRING(D3_COD,1,1) AS INICOD FROM SD3010 " + cWhere + " GROUP BY SUBSTRING(D3_COD,1,1)"

			If Select("TEMP001") <> 0
				TEMP001->( dbCloseArea() )
			EndIf

			TCQUERY cQuery NEW ALIAS "TEMP001"

			nRecno := 0
			While !TEMP001->( EOF())
				nRecno++
				TEMP001->( dbSkip() )
			End

			oProcess:SetRegua2(nRecno/10)

			TEMP001->( dbGoTop() )

			nRecAtu := 1
			While !TEMP001->( EOF() )
				If Mod(nRecAtu,10) == 0
					oProcess:IncRegua2("Etapa 2: Zerando custos " + Alltrim(Str(nRecAtu)) + ' / ' + Alltrim(Str(nRecno)) )
				EndIf
				nRecAtu++

				cQueryUPD := "UPDATE SD3010 SET D3_XCUSTO1 = 0 " + cWhere + " AND D3_COD >= '" + TEMP001->INICOD + "' AND D3_COD <= '"+ TEMP001->INICOD +"ZZZZZZZZZZZZZZ' "
				TCSQLEXEC(cQueryUPD)
				TEMP001->( dbSkip() )
			End
			oProcess:IncRegua1("Etapa 2 concluída em xxx minutos")
		EndIf


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Zerando o aSD3                                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If Empty(mv_par03) .and. Alltrim(Upper(mv_par04)) == Repl("Z",Len(Alltrim(mv_par04)))
			// Se for produto de branco a zzz, zera as requisições e devoluções, senão apenas as requisições
			cCFs := "'RE4','DE4','PR0','PR1','RE0','RE1','RE2','DE0'"
		Else
			cCFs := "'RE4',      'PR0','PR1','RE0','RE1','RE2','DE0'"
		EndIf

		For N := 1 to Len(aSD3)
			If aSD3[N,npD3CF] $ cCFs
				If  aSD3[N,nPD3COD] >= mv_par03 .and. aSD3[N,nPD3COD] <= mv_par04
					aSD3[N,npD3CUSTO1] := 0
				EndIf
			EndIf
		Next naSD3

	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Levantanto todos produtos que tiveram movimento no período            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	mv_par06 := mv_par06

	If mv_par06 == 1 // Recalcula apenas produtos zerados
		cQuery := "SELECT * FROM (
		cQuery += "SELECT D3_COD PRODUTO, D3_LOCAL LOCAL FROM SD3010 (NOLOCK) SD3 WHERE D3_FILIAL = '"+xFilial("SD3")+"' AND D3_EMISSAO >= '"+DtoS(mv_par01)+"' "
		cQuery += "AND D3_EMISSAO <= '"+DtoS(mv_par02)+"' AND D3_COD >= '"+mv_par03+"' AND D3_COD <= '"+mv_par04+"' AND D3_ESTORNO = '' AND SD3.D_E_L_E_T_ = '' "
		cQuery += "AND D3_XCUSTO1 = 0 GROUP BY D3_COD, D3_LOCAL "
		cQuery += "UNION "
		cQuery += "SELECT D1_COD PRODUTO, D1_LOCAL LOCAL FROM SD1010 (NOLOCK) SD1, SF4010 (NOLOCK) SF4 WHERE D1_FILIAL = '"+xFilial("SD1")+"' AND D1_TES = F4_CODIGO "
		cQuery += "AND F4_ESTOQUE = 'S' AND D1_DTDIGIT >= '"+DtoS(mv_par01)+"' AND D1_DTDIGIT <= '"+DtoS(mv_par02)+"' AND D1_COD >= '"+mv_par03+"' AND D1_COD <= '"+mv_par04+"' AND SD1.D_E_L_E_T_ = '' AND SF4.D_E_L_E_T_ = '' GROUP BY D1_COD, D1_LOCAL "
		cQuery += "UNION "
		cQuery += "SELECT D2_COD PRODUTO, D2_LOCAL LOCAL FROM SD2010 (NOLOCK) SD2, SF4010 (NOLOCK) SF4 WHERE D2_FILIAL = '"+xFilial("SD2")+"' AND D2_TES = F4_CODIGO AND F4_ESTOQUE = 'S' AND D2_EMISSAO >= '"+DtoS(mv_par01)+"' AND D2_EMISSAO <= '"+DtoS(mv_par02)+"' AND D2_COD >= '"+mv_par03+"' AND D2_COD <= '"+mv_par04+"' AND D2_XCUSTO1 = 0 AND SD2.D_E_L_E_T_ = '' AND SF4.D_E_L_E_T_ = '' GROUP BY D2_COD, D2_LOCAL "
		cQuery += ") TMP ORDER BY PRODUTO, LOCAL	"

		If Select("PRODUTOS") <> 0
			PRODUTOS->( dbCloseArea() )
		EndIf

		TCQUERY cQuery NEW ALIAS "PRODUTOS"
		//QUERY01++
	Else
		cQuery := "SELECT * FROM (
		cQuery += "SELECT D3_COD PRODUTO, D3_LOCAL LOCAL FROM SD3010 (NOLOCK) SD3 WHERE D3_FILIAL = '"+xFilial("SD3")+"' AND D3_EMISSAO >= '"+DtoS(mv_par01)+"' AND D3_EMISSAO <= '"+DtoS(mv_par02)+"' AND D3_COD >= '"+mv_par03+"' AND D3_COD <= '"+mv_par04+"' AND D3_ESTORNO = '' AND SD3.D_E_L_E_T_ = '' GROUP BY D3_COD, D3_LOCAL "
		cQuery += "UNION "
		cQuery += "SELECT D1_COD PRODUTO, D1_LOCAL LOCAL FROM SD1010 (NOLOCK) SD1, SF4010 (NOLOCK) SF4 WHERE D1_FILIAL = '"+xFilial("SD1")+"' AND D1_TES = F4_CODIGO AND F4_ESTOQUE = 'S' AND D1_DTDIGIT >= '"+DtoS(mv_par01)+"' AND D1_DTDIGIT <= '"+DtoS(mv_par02)+"' AND D1_COD >= '"+mv_par03+"' AND D1_COD <= '"+mv_par04+"' AND SD1.D_E_L_E_T_ = '' AND SF4.D_E_L_E_T_ = '' GROUP BY D1_COD, D1_LOCAL "
		cQuery += "UNION "
		cQuery += "SELECT D2_COD PRODUTO, D2_LOCAL LOCAL FROM SD2010 (NOLOCK) SD2, SF4010 (NOLOCK) SF4 WHERE D2_FILIAL = '"+xFilial("SD2")+"' AND D2_TES = F4_CODIGO AND F4_ESTOQUE = 'S' AND D2_EMISSAO >= '"+DtoS(mv_par01)+"' AND D2_EMISSAO <= '"+DtoS(mv_par02)+"' AND D2_COD >= '"+mv_par03+"' AND D2_COD <= '"+mv_par04+"' AND SD2.D_E_L_E_T_ = '' AND SF4.D_E_L_E_T_ = '' GROUP BY D2_COD, D2_LOCAL "
		cQuery += ") TMP ORDER BY PRODUTO, LOCAL  "

		If Select("PRODUTOS") <> 0
			PRODUTOS->( dbCloseArea() )
		EndIf

		TCQUERY cQuery NEW ALIAS "PRODUTOS"
		//QUERY02++
	EndIf


	aProdutos  := {}

	nPCodigo   := 1
	nPLocal    := 2
	//nPStatus := 3
	nPSaldoIni := 4
	nPVlrIni   := 5

	nPQEntVlr  := 6
	nPVEntVlr  := 7

	nPOPNivel  := 8

	nPQProd    := 9
	nPVProd    := 10

	nPQTran    := 11
	nPVTran    := 12

	nPMedio    := 13

	****************
	nMaxVet    := 13
	****************

	While !PRODUTOS->( EOF() )
		AADD(aProdutos,Array(nMaxVet))
		aProdutos[Len(aProdutos), nPCodigo  ] := PRODUTOS->PRODUTO
		aProdutos[Len(aProdutos), nPLocal   ] := PRODUTOS->LOCAL
		//aProdutos[Len(aProdutos), nPStatus  ] := "0"                // status inicial

		aProdutos[Len(aProdutos), nPSaldoIni] := 0 //aCalcEst[1]
		aProdutos[Len(aProdutos), nPVlrIni  ] := 0 //aCalcEst[2]

		aProdutos[Len(aProdutos), nPQEntVlr ] := 0  // Entradas Valorizadas em quantidade
		aProdutos[Len(aProdutos), nPVEntVlr ] := 0  // Entradas Valorizadas em valor

		aProdutos[Len(aProdutos), nPOPNivel ] := ""

		aProdutos[Len(aProdutos), nPQProd   ] := 0  // Quantidade de Produção
		aProdutos[Len(aProdutos), nPVProd   ] := 0  // Valor de produção

		aProdutos[Len(aProdutos), nPQTran   ] := 0  // Quantidade de Transferências
		aProdutos[Len(aProdutos), nPVTran   ] := 0  // Valor de Transferências


		aProdutos[Len(aProdutos), nPMedio   ] := 0

		PRODUTOS->( dbSkip() )
	End

	SB9->( dbSetOrder(1) )

	nFor := Len(aProdutos)

	aProdZerado := {}
	nRecnoAtu   := 1

	If mv_par05 == 2 // NÃO Zera custos no inicio da rotina

		oProcess:SetRegua2(nFor/10)

		For x := 1 to Len(aProdutos)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Zerando custos a serem recalculados                                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aScan(aProdZerado,aProdutos[x,nPCodigo]) == 0
				cQueryUPD := "UPDATE SD3010 SET D3_XCUSTO1 = 0 WHERE D3_FILIAL = '"+xFilial("SD3")+"' AND D3_EMISSAO >= '"+DtoS(mv_par01)+"' "
				cQueryUPD += "AND D3_EMISSAO <= '"+DtoS(mv_par02)+"' AND D3_COD = '"+aProdutos[x,nPCodigo]+"' AND D3_LOCAL = '"+aProdutos[x,nPLocal]+"' "
				cQueryUPD += "AND D3_XCUSTO1 <> 0 AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "

				If Empty(mv_par03) .and. Alltrim(Upper(mv_par04)) == Repl("Z",Len(Alltrim(mv_par04)))
					cQueryUPD += "AND D3_CF IN ('RE4','DE4','PR0','PR1','RE0','RE1','RE2','DE0') "
					cCFs      := "'RE4','DE4','PR0','PR1','RE0','RE1','RE2','DE0'"
				Else
					cQueryUPD += "AND D3_CF IN ('RE4','PR0','PR1','RE0','RE1','RE2','DE0') "
					cCFs      := "'RE4','PR0','PR1','RE0','RE1','RE2','DE0'"
				EndIf

				TCSQLEXEC(cQueryUPD)
				AADD(aProdZerado,aProdutos[x,nPCodigo])

				For N := 1 to Len(aSD3)
					If aSD3[N,nPD3CF] $ cCFs .and. aSD3[N,nPD3COD] == aProdutos[x,nPCodigo] .and. aSD3[N,nPD3LOCAL] == aProdutos[x,nPLocal]
						aSD3[N,nPD3CUSTO1] := 0
					EndIf
				Next N
			EndIf

			If Mod(nRecnoAtu,10) == 0
				oProcess:IncRegua2("Etapa 2: Zerando Custos de Produtos: "+Alltrim(StrZero(nRecnoAtu,'@E 999,999,999,999'))+" / "+Alltrim(StrZero(nFor,'@E 999,999,999,999'))   )
			EndIf

			nRecnoAtu++

		Next x

		oProcess:IncRegua1("Etapa 2 concluída em xxx minutos")
	EndIf


	oProcess:SetRegua2(nFor/10)

	nRecnoAtu := 1

	For x := 1 to nFor

		If Mod(nRecnoAtu,10) == 0
			oProcess:IncRegua2("Etapa 3: Calculando saldos iniciais: "+Alltrim(Transform(nRecnoAtu,'@E 999,999,999,999'))+" / "+Alltrim(Transform(nFor,'@E 999,999,999,999'))  )
		EndIf
		//If lEnd
		//	IF MsgNoYes("Deseja abandonar o processamento do Custo Médio?")
		//		Return
		//	EndIf
		//EndIf

		nRecnoAtu++

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Calculando o saldo inicial via SB9 ou CalcEst()                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SB9->( dbSeek( xFilial() + aProdutos[x, nPCodigo] + aProdutos[x, nPLocal] + DtoS(mv_par01-1) ) )
			aProdutos[x, nPSaldoIni] := SB9->B9_QINI
			aProdutos[x, nPVlrIni  ] := SB9->B9_VINI1
		Else
			aCalcEst := CalcEst(aProdutos[x, nPCodigo],aProdutos[x, nPLocal],mv_par01)
			aProdutos[x, nPSaldoIni] := aCalcEst[1]
			aProdutos[x, nPVlrIni  ] := aCalcEst[2]
		EndIf

	Next x

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Localizando Movimentações de entrada valorizadas DE6                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	/*
	cQuery := "SELECT ISNULL(SUM(D3_QUANT),0) AS SUMD3_QUANT, ISNULL(SUM(D3_XCUSTO1),0) AS SUMD3_XCUSTO1 FROM SD3010 (NOLOCK) WHERE "
	cQuery += "D3_FILIAL = '"+xFilial("SD3")+"' AND D3_EMISSAO >= '"+DtoS(mv_par01)+"' AND D3_EMISSAO <= '"+DtoS(mv_par02)+"' "
	cQuery += "AND D3_COD = '"+aProdutos[x,nPCodigo]+"' AND D3_LOCAL = '"+aProdutos[x,nPLocal]+"' "
	cQuery += "AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "
	cQuery += "AND D3_CF  = 'DE6' "

	If Select("QSD3_1") <> 0
	QSD3_1->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS "QSD3_1"
	QUERY03++

	If !QSD3_1->( EOF() )
	aProdutos[x, nPQEntVlr ] += QSD3_1->SUMD3_QUANT  // Entradas Valorizadas em quantidade
	aProdutos[x, nPVEntVlr ] += QSD3_1->SUMD3_XCUSTO1 // Entradas Valorizadas em valor
	EndIf

	LOCALIZANDO MOVIMENTOS VALORIZADOS PELO aSD3 ABAIXO
	*/

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Localizando Movimentações de saída valorizadas                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	/*
	cQuery := "SELECT ISNULL(SUM(D3_QUANT),0) AS SUMD3_QUANT, ISNULL(SUM(D3_XCUSTO1),0) AS SUMD3_XCUSTO1 FROM SD3010 (NOLOCK) WHERE D3_FILIAL = '"+xFilial("SD3")+"' AND D3_EMISSAO >= '"+DtoS(mv_par01)+"' AND D3_EMISSAO <= '"+DtoS(mv_par02)+"' "
	cQuery += "AND D3_COD = '"+aProdutos[x,nPCodigo]+"' AND D3_LOCAL = '"+aProdutos[x,nPLocal]+"' "
	cQuery += "AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "

	cQuery += "AND D3_CF  = 'RE6' "

	If Select("QSD3_2") <> 0
	QSD3_2->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS "QSD3_2"
	QUERY04++

	If !QSD3_2->( EOF() )
	aProdutos[x, nPQEntVlr ] -= QSD3_2->SUMD3_QUANT  // Entradas Valorizadas em quantidade
	aProdutos[x, nPVEntVlr ] -= QSD3_2->SUMD3_XCUSTO1 // Entradas Valorizadas em valor
	EndIf
	*/

	oProcess:SetRegua2(Len(aSD3)/10)

	nRecnoAtu := 1
	For n := 1 to Len(aSD3)
		If  aSD3[N,nPD3COD] >= mv_par03 .and. aSD3[N,nPD3COD] <= mv_par04
			If Mod(nRecnoAtu,10) == 0
				oProcess:IncRegua2("Etapa 4: Moviment.valoriz.: "+Alltrim(Transform(nRecnoAtu,'@E 999,999,999,999'))+" / "+Alltrim(Transform(Len(aSD3),'@E 999,999,999,999'))  )
			EndIf
			nRecnoAtu++
			If aSD3[n,nPD3CF] == 'DE6' .or. aSD3[n,nPD3CF] == 'RE6'

				nPLOCAL := nPLOCAL

				nPos := aScan(aProdutos, {|aVet| aVet[nPCodigo] == aSD3[n,nPD3COD] .and. aVet[nPLOCAL] == aSD3[n,nPD3LOCAL]  } )

				If aSD3[n,nPD3CF] == 'DE6' .and. aSD3[n,nPD3COD] == aProdutos[nPos,nPCodigo] .and. aSD3[n,nPD3LOCAL] == aProdutos[nPos,nPLocal]
					aProdutos[nPos, nPQEntVlr ] += aSD3[n,nPD3QUANT]  // Entradas Valorizadas em quantidade
					aProdutos[nPos, nPVEntVlr ] += aSD3[n,nPD3CUSTO1] // Entradas Valorizadas em valor
				EndIf

				If aSD3[n,nPD3CF] == 'RE6' .and. aSD3[n,nPD3COD] == aProdutos[nPos,nPCodigo] .and. aSD3[n,nPD3LOCAL] == aProdutos[nPos,nPLocal]
					aProdutos[nPos, nPQEntVlr ] -= aSD3[n,nPD3QUANT]  // Saídas Valorizadas em quantidade
					aProdutos[nPos, nPVEntVlr ] -= aSD3[n,nPD3CUSTO1] // Saídas Valorizadas em valor
				EndIf
			EndIf
		EndIf
	Next n

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Localizando Notas Fiscais de Entrada                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	oProcess:SetRegua2(nFor/10)

	nRecnoAtu := 1

	For x := 1 to nFor
		If Mod(nRecnoAtu,10) == 0
			oProcess:IncRegua2("Etapa 5: NF Entradas: "+Alltrim(Transform(nRecnoAtu,'@E 999,999,999,999'))+" / "+Alltrim(Transform(nFor,'@E 999,999,999,999'))  )
		EndIf

		nRecnoAtu++

		cQuery := "SELECT SUM(D1_QUANT) AS SUMD1_QUANT, SUM(D1_CUSTO) AS SUMD1_CUSTO FROM SD1010 (NOLOCK) SD1, SF4010 (NOLOCK) SF4 "
		cQuery += "WHERE F4_CODIGO = D1_TES AND D1_FILIAL = '"+xFilial("SD1")+"' "
		cQuery += "AND D1_DTDIGIT >= '"+DtoS(mv_par01)+"' AND D1_DTDIGIT <= '"+DtoS(mv_par02)+"' "
		cQuery += "AND D1_COD = '"+aProdutos[x,nPCodigo]+"' AND D1_LOCAL = '"+aProdutos[x,nPLocal]+"' "
		cQuery += "AND SF4.D_E_L_E_T_ = '' AND SD1.D_E_L_E_T_ = '' "

		cQuery += "AND F4_ESTOQUE  = 'S' "

		If Select("QSD1") <> 0
			QSD1->( dbCloseArea() )
		EndIf

		TCQUERY cQuery NEW ALIAS "QSD1"
		//QUERY05++

		If !QSD1->( EOF() )
			aProdutos[x, nPQEntVlr ] += QSD1->SUMD1_QUANT  // Entradas Valorizadas em quantidade
			aProdutos[x, nPVEntVlr ] += QSD1->SUMD1_CUSTO  // Entradas Valorizadas em valor
		EndIf
	Next x

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Localizando produtos com e sem produção. Com produção Status = '2', sem produção status = '1'              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	/*
	cQuery := "SELECT D3_COD, D3_LOCAL, MIN(D3_NIVEL) AS MIND3_NIVEL FROM SD3010 (NOLOCK) WHERE D3_FILIAL = '"+xFilial("SD3")+"' "
	cQuery += "AND D3_EMISSAO >= '"+DtoS(mv_par01)+"' AND D3_EMISSAO <= '"+DtoS(mv_par02)+"' AND D3_COD = '"+aProdutos[x,nPCodigo]+"' "
	cQuery += "AND D3_LOCAL = '"+aProdutos[x,nPLocal]+"' AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "

	cQuery += "AND SUBSTRING(D3_CF,1,2) = 'PR'"

	cQuery += "GROUP BY D3_COD, D3_LOCAL "

	If Select("QSD3_3") <> 0
	QSD3_3->( dbCloseArea() )
	EndIf
	TCQUERY cQuery NEW ALIAS "QSD3_3"
	QUERY06++

	If QSD3_3->( EOF() )
	aProdutos[x,nPStatus]  := '1' // "MP"
	Else
	aProdutos[x,nPStatus]  := '2' // "PI/PA"
	aProdutos[x,nPOPNivel] := QSD3_3->MIND3_NIVEL
	EndIf
	*/




	/*
	oProcess:SetRegua1(nFor)
	oProcess:SetRegua2(99999)
	oProcess:IncRegua2("")

	nRecnoAtu := 1

	For x := 1 to nFor

	oProcess:IncRegua1("Etapa 6: Nível de OPs: "+Alltrim(Transform(nRecnoAtu,'@E 999,999,999,999'))+" / "+Alltrim(Transform(nFor,'@E 999,999,999,999'))  )
	nRecnoAtu++

	aProdutos[x,nPStatus]  := '1' // "MP"

		For n := 1 to Len(aSD3)
			If Subs(aSD3[n,nPD3CF],1,2) == 'PR' .and. aSD3[n,nPD3COD] == aProdutos[x,nPCodigo] .and. aSD3[n,nPD3LOCAL] == aProdutos[x,nPLocal]
	aProdutos[x,nPStatus]  := '2' // "PI/PA"
	aProdutos[x,nPOPNivel] := QSD3_3->MIND3_NIVEL
	Exit
			EndIf
		Next n

	Next x
	*/

	//EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Calculando o custo médio de Matérias primas                                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nMaxLoop    := 100
	nUltimoLoop := 0


	//oProcess:SetRegua1(nMaxLoop)

	For y := 1 to nMaxLoop
		//oProcess:IncRegua1("Etapa 6: Loop número: "+Alltrim(Transform(y,'@E 999,999,999,999'))+" / "+Alltrim(Transform(nMaxLoop,'@E 999,999,999,999'))  )
		//oProcess:IncRegua2("")

		//oProcess:SetRegua2(nFor/10)
		oProcess:SetRegua2(nFor)
		nRecnoAtu := 1

		aVetProdBkp := aClone(aProdutos)

		For x := 1 to nFor
			//If Mod(nRecnoAtu,10) == 0
			oProcess:IncRegua2("Etapa 6: Loop " + Alltrim(Str(y)) + " Custo Médio: "+Alltrim(Transform(nRecnoAtu,'@E 999,999,999,999'))+" / "+Alltrim(Transform(nFor,'@E 999,999,999,999'))  )
			//EndIf

			nRecnoAtu++

			//If aProdutos[x,nPStatus] == '1' // "MP"
			nUltimoLoop := y

			// Verificando produções para o produto

			// Query que lista todas as produções do produto posicionado com valor OU SEM valor

			If lCustOPQuery    // Se calcula o custo dos PA de OPs com Query. Else é com vetor

				lProdOk := .T.

				cQuery := "SELECT D3_OP, D3_COD, D3_LOCAL, D3_NUMSEQ, R_E_C_N_O_ FROM SD3010 (NOLOCK) SD3 WHERE D3_FILIAL = '"+xFilial("SD3")+"' "
				cQuery += "AND D3_EMISSAO >= '"+DtoS(mv_par01)+"' AND D3_EMISSAO <= '"+DtoS(mv_par02)+"' AND D3_COD = '"+aProdutos[x,nPCodigo]+"' "
				cQuery += "AND D3_LOCAL = '"+aProdutos[x,nPLocal]+"' AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "
				//cQuery += "AND D3_XCUSTO1 = 0 "

				cQuery += "AND SUBSTRING(D3_CF,1,2) = 'PR' "

				If Select("QSD3_4") <> 0
					QSD3_4->( dbCloseArea() )
				EndIf

				TCQUERY cQuery NEW ALIAS "QSD3_4"


				While !QSD3_4->( EOF() )
					// Query que verifica se não tem requisições para a OP sem valor

					cQuery := "SELECT R_E_C_N_O_ FROM SD3010 (NOLOCK) WHERE D3_FILIAL = '"+xFilial("SD3")+"' "
					cQuery += "AND D3_EMISSAO >= '"+DtoS(mv_par01)+"' AND D3_EMISSAO <= '"+DtoS(mv_par02)+"' "
					cQuery += "AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "

					cQuery += "AND D3_OP = '"+QSD3_4->D3_OP+"' AND D3_NUMSEQ = '"+QSD3_4->D3_NUMSEQ+"' AND D3_TM > '500' AND D3_XCUSTO1 = 0 "

					If Select("QSD3_5") <> 0
						QSD3_5->( dbCloseArea() )
					EndIf

					TCQUERY cQuery NEW ALIAS "QSD3_5"

					If QSD3_5->( EOF() )
						// Query que pega o valor das requisições para gravar na produção
						cQuery := "SELECT SUM(D3_XCUSTO1) AS SUMD3_XCUSTO1 FROM SD3010 (NOLOCK) WHERE D3_FILIAL = '"+xFilial("SD3")+"' "
						cQuery += "AND D3_EMISSAO >= '"+DtoS(mv_par01)+"' AND D3_EMISSAO <= '"+DtoS(mv_par02)+"' "
						cQuery += "AND D3_OP = '"+QSD3_4->D3_OP+"' AND D3_NUMSEQ = '"+QSD3_4->D3_NUMSEQ+"' AND D3_TM > '500' "
						cQuery += "AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "

						If Select("QSD3_6") <> 0
							QSD3_6->( dbCloseArea() )
						EndIf

						TCQUERY cQuery NEW ALIAS "QSD3_6"

						cQueryUPD := "UPDATE SD3010 SET D3_XCUSTO1 = '"+Str(QSD3_6->SUMD3_XCUSTO1)+"' WHERE R_E_C_N_O_ = " + Str(QSD3_4->R_E_C_N_O_)

						TCSQLEXEC(cQueryUPD)

						N := aScan(aSD3, {|aVet| aVet[npD3RECNO] == QSD3_4->R_E_C_N_O_ } )
						aSD3[N,nPD3CUSTO1] := QSD3_6->SUMD3_XCUSTO1

					Else
						lProdOk := .F.
					EndIf



					QSD3_4->( dbSkip() )
				End




			Else   // usa array ao invés de query para produções



				lProdOk := .T.

				nIni := aScan(aSD3, {|aVet| aVet[npD3COD] == aProdutos[x,nPCodigo] .and. aVet[npD3LOCAL] == aProdutos[x,nPLocal]  } )

				If !Empty(nIni)
					For n := nIni to Len(aSD3)
						If Subs(aSD3[n,nPD3CF],1,2) == 'PR' .and. aSD3[n,nPD3COD] == aProdutos[x,nPCodigo] .and. aSD3[n,nPD3LOCAL] == aProdutos[x,nPLocal]

							// Melhorar aqui
							lOPok   := .T.
							nValReq := 0

							// aSD3_op_numseq   é um vetor aclone do aSD3 ordenado por OP + Numseq

							//oIni := aScan(aSD3_op_numseq, {|aVet| aVet[npD3OP] == aSD3[n,nPD3OP] .and. aVet[npD3NUMSEQ] == aSD3[n,nPD3NUMSEQ]  } )

							For o := 1 to Len(aSD3_op_numseq)
								If aSD3[n,nPD3OP] == aSD3_op_numseq[o,nPD3OP] .and. aSD3[n,nPD3NUMSEQ] == aSD3_op_numseq[o,nPD3NUMSEQ] .and. aSD3_op_numseq[o,nPD3TM] > '500'

									p := aScan(aSD3, {|aVet| aVet[npD3RECNO] == aSD3_op_numseq[o,nPD3RECNO] } )

									If aSD3[p,nPD3CUSTO1] <= 0
										lOPok   := .F.
										Exit
									Else
										nValReq += aSD3[p,nPD3CUSTO1]
										//Alert('produto ' + aSD3[p,nPD3COD] + ' valor ' + Str(aSD3[p,nPD3CUSTO1]) )
									EndIf
								EndIf

								//If aSD3[n,nPD3OP] <> aSD3_op_numseq[o,nPD3OP] .or. aSD3[n,nPD3NUMSEQ] <> aSD3_op_numseq[o,nPD3NUMSEQ]
								//	Alert('numseq ' + aSD3[n,nPD3NUMSEQ] + ' valor ' + Str(nValReq) )
								//	Return
								//	Exit
								//EndIf

							Next o


							If lOPok
								aSD3[N,nPD3CUSTO1] := nValReq

								If lAtualizaSD3
									cQueryUPD := "UPDATE SD3010 SET D3_XCUSTO1 = " + Str(nValReq) + " WHERE R_E_C_N_O_ = " + Str(aSD3[N,nPD3RECNO])
									TCSQLEXEC(cQueryUPD)
								EndIf
							Else
								lProdOk := .F.
							EndIf

						EndIf
						If aSD3[n,nPD3COD] <> aProdutos[x,nPCodigo] .or. aSD3[n,nPD3LOCAL] <> aProdutos[x,nPLocal]
							Exit
						EndIf
					Next n
				EndIf

			EndIf


			If lProdOk  // Variável indica se todas as produções do produto foram valorizadas
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³se todas as produções do produto foram valorizadas, faz o custo médio do produto para gravar nas requisições do produto para outras OPs ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				/*
				cQuery := "SELECT ISNULL(SUM(D3_QUANT),0) AS SUMD3_QUANT, ISNULL(SUM(D3_XCUSTO1),0) AS SUMD3_XCUSTO1 FROM SD3010 (NOLOCK) "
				cQuery += "WHERE D3_FILIAL = '"+xFilial("SD3")+"' AND D3_EMISSAO >= '"+DtoS(mv_par01)+"' AND D3_EMISSAO <= '"+DtoS(mv_par02)+"' "
				cQuery += "AND D3_COD = '"+aProdutos[x,nPCodigo]+"' AND D3_LOCAL = '"+aProdutos[x,nPLocal]+"' " // "AND D3_XCUSTO1 <> 0 "
				cQuery += "AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "

				cQuery += "AND SUBSTRING(D3_CF,1,2)  = 'PR' "

				If Select("QSD3_7") <> 0
				QSD3_7->( dbCloseArea() )
				EndIf

				TCQUERY cQuery NEW ALIAS "QSD3_7"
				QUERY11++

				If !QSD3_7->( EOF() )
				aProdutos[x, nPQProd ] += QSD3_7->SUMD3_QUANT  // Entradas Valorizadas em quantidade
				aProdutos[x, nPVProd ] += QSD3_7->SUMD3_XCUSTO1 // Entradas Valorizadas em valor
				EndIf
				*/


				nIni := aScan(aSD3, {|aVet| aVet[npD3COD] == aProdutos[x,nPCodigo] .and. aVet[npD3LOCAL] == aProdutos[x,nPLocal]  } )

				If !Empty(nIni)
					For n := nIni to Len(aSD3)

						If Subs(aSD3[n,nPD3CF],1,2) == 'PR' .and. aSD3[n,nPD3COD] == aProdutos[x,nPCodigo] .and. aSD3[n,nPD3LOCAL] == aProdutos[x,nPLocal]
							aProdutos[x, nPQProd ] += aSD3[n,nPD3QUANT]  // Entradas Valorizadas em quantidade
							aProdutos[x, nPVProd ] += aSD3[n,nPD3CUSTO1] // Entradas Valorizadas em valor
						EndIf

						If aSD3[n,nPD3COD] <> aProdutos[x,nPCodigo] .or. aSD3[n,nPD3LOCAL] <> aProdutos[x,nPLocal]
							Exit
						EndIf
					Next n
				EndIf
			EndIf

			// Fim do termino da analise de produções

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Selecionando transferências DE4 do produto                                                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			/*
			cQuery := "SELECT ISNULL(SUM(D3_QUANT),0) AS SUMD3_QUANT, ISNULL(SUM(D3_XCUSTO1),0) AS SUMD3_XCUSTO1 FROM SD3010 (NOLOCK) "
			cQuery += "WHERE D3_FILIAL = '"+xFilial("SD3")+"' AND D3_EMISSAO >= '"+DtoS(mv_par01)+"' AND D3_EMISSAO <= '"+DtoS(mv_par02)+"' "
			cQuery += "AND D3_COD = '"+aProdutos[x,nPCodigo]+"' AND D3_LOCAL = '"+aProdutos[x,nPLocal]+"' "
			cQuery += "AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "
			cQuery += "AND D3_CF  = 'DE4' "

			If Select("QSD3_2") <> 0
			QSD3_2->( dbCloseArea() )
			EndIf

			TCQUERY cQuery NEW ALIAS "QSD3_2"

			aProdutos[x, nPQTran] := QSD3_2->SUMD3_QUANT
			aProdutos[x, nPVTran] := QSD3_2->SUMD3_XCUSTO1
			*/

			nIni := aScan(aSD3, {|aVet| aVet[npD3COD] == aProdutos[x,nPCodigo] .and. aVet[npD3LOCAL] == aProdutos[x,nPLocal]  } )
			If !Empty(nIni)
				For n := nIni to Len(aSD3)

					If aSD3[n,nPD3CF] == 'DE4' .and. aSD3[n,nPD3COD] == aProdutos[x,nPCodigo] .and. aSD3[n,nPD3LOCAL] == aProdutos[x,nPLocal]
						aProdutos[x, nPQTran ] += aSD3[n,nPD3QUANT]  // Entradas Valorizadas em quantidade
						aProdutos[x, nPVTran ] += aSD3[n,nPD3CUSTO1] // Entradas Valorizadas em valor
					EndIf

					If aSD3[n,nPD3COD] <> aProdutos[x,nPCodigo] .or. aSD3[n,nPD3LOCAL] <> aProdutos[x,nPLocal]
						Exit
					EndIf

				Next n
			EndIf

			//           Qtd inicial                Qtd entrada valorizada     Qtd Produção             Qtd entrada por transferência
			nQtdMedio := aProdutos[x, nPSaldoIni] + aProdutos[x, nPQEntVlr ] + aProdutos[x, nPQProd]  + aProdutos[x, nPQTran]
			//           Vlr inicial                Vlr entrada valorizada     Vlr Produção             Vlr entrada por transferência
			nVlrMedio := aProdutos[x, nPVlrIni  ] + aProdutos[x, nPVEntVlr ] + aProdutos[x, nPVProd]  + aProdutos[x, nPVTran]

			nMedio    := nVlrMedio/nQtdMedio // Round(nVlrMedio/nQtdMedio,4)

			If !Empty(nMedio)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³##LUCIANO## Só para de recalcular todos os custos médios se depois do ultimo calculo de todos produtos, nada mudar ³
				//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

				nMedioVLD := fVldSldfin(aProdutos[x,nPCodigo],aProdutos[x,nPLocal],mv_par01,mv_par02,nMedio)

				If nMedio == nMedioVLD
					// Médio Ok
				Else
					nMedio := nMedioVLD
				EndIf

    			nIni := aScan(aSD3, {|aVet| aVet[npD3COD] == aProdutos[x,nPCodigo] .and. aVet[npD3LOCAL] == aProdutos[x,nPLocal]  } )

				If !Empty(nIni)
					For n := nIni to Len(aSD3)
						If aSD3[n,nPD3CF] $ "'RE0','RE1','RE2','DE0'" .and. aSD3[n,nPD3COD] == aProdutos[x,nPCodigo] .and. aSD3[n,nPD3LOCAL] == aProdutos[x,nPLocal]
							aSD3[n,nPD3CUSTO1] := aSD3[n,nPD3QUANT] * nMedio
						EndIf

						If aSD3[n,nPD3COD] <> aProdutos[x,nPCodigo] .or. aSD3[n,nPD3LOCAL] <> aProdutos[x,nPLocal]
							Exit
						EndIf

					Next n
				EndIf





				nIni := aScan(aSD3, {|aVet| aVet[npD3COD] == aProdutos[x,nPCodigo] .and. aVet[npD3LOCAL] == aProdutos[x,nPLocal]  } )

				If !Empty(nIni)
					For n := nIni to Len(aSD3)
						If aSD3[n,nPD3CF] == "RE4" .and. aSD3[n,nPD3COD] == aProdutos[x,nPCodigo] .and. aSD3[n,nPD3LOCAL] == aProdutos[x,nPLocal]
							aSD3[n,nPD3CUSTO1] := aSD3[n,nPD3QUANT] * nMedio
							// melhorar aqui - Já melhorado

							o := aScan(aSD3, {|aVet| aVet[npD3CF] == "DE4" .and. aVet[npD3NUMSEQ] == aSD3[n,nPD3NUMSEQ]  } )

							If aSD3[o,nPD3CF] == "DE4" .and. aSD3[n,nPD3NUMSEQ] == aSD3[o,nPD3NUMSEQ] //.and. aSD3[o,nPD3COD] == aProdutos[x,nPCodigo] .and. aSD3[o,nPD3LOCAL] == aProdutos[x,nPLocal]
								aSD3[n,nPD3CUSTO1] := aSD3[n,nPD3QUANT] * nMedio
							Else
								MsgInfo("Requisição sem devolução para NUMSEQ " + aSD3[n,nPD3NUMSEQ])
							EndIf
						EndIf

						If aSD3[n,nPD3COD] <> aProdutos[x,nPCodigo] .or. aSD3[n,nPD3LOCAL] <> aProdutos[x,nPLocal]
							Exit
						EndIf

					Next n
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verificando se não teve tranferência para uma MP já com Status Ok '3'. Se sim, muda para 1            ³
				//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				/*
				QD3NUMSEQ->( dbGoTop() )
				SD3->( dbSetOrder(4) ) // D3_FILIAL + D3_NUMSEQ + D3_CHAVE + D3_COD
				If !QD3NUMSEQ->( EOF() )
					If SD3->( dbSeek( QD3NUMSEQ->D3_FILIAL + QD3NUMSEQ->D3_NUMSEQ ) )
						While !SD3->( EOF() ) .and. QD3NUMSEQ->D3_FILIAL == SD3->D3_FILIAL .and. QD3NUMSEQ->D3_NUMSEQ == SD3->D3_NUMSEQ
							If SD3->D3_EMISSAO >= mv_par01 .and. SD3->D3_EMISSAO <= mv_par02 .and. SD3->D3_COD <> aProdutos[x,nPCodigo] .and. SD3->D3_ESTORNO == '' .and. SD3->D3_CF  = 'DE4'
				// SD3->D3_LOCAL <> aProdutos[x,nPLocal]
								For z := 1 to Len(aProdutos)
									If aProdutos[z,nPCodigo] == SD3->D3_COD .and. aProdutos[z,nPLocal] == SD3->D3_LOCAL .and. aProdutos[x,nPStatus] == '3' // "MP-OK"
				aProdutos[x,nPStatus] == '1' // "MP"
									EndIf
								Next z
							EndIf
				SD3->( dbSkip() )
						End
					EndIf
				EndIf
				*/
				aProdutos[x,nPMedio] := nMedio

				//EndIf

			EndIf

			//EndIf
		Next x

		lContinua := .F.
		For z := 1 to Len(aVetProdBkp)
			If aVetProdBkp[z,nPMedio] <> aProdutos[z,nPMedio]
				lContinua := .T.
				Exit
			EndIf
		Next z

		If !lContinua
			Exit
		EndIf
	Next Y

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verificando se ficaram MPs sem custo Ok = Status = 3                                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	c_Buffer := ""

	For x := 1 to nFor
		If Empty(aProdutos[x,nPMedio])
			c_Buffer += aProdutos[x,nPCodigo] + aProdutos[x,nPLocal] + Chr(13) + Chr(10)
		EndIf
	Next

	If !Empty(c_Buffer)
		n_h      := fCreate("custopus.txt")
		n_h      := n_h
		fWrite(n_H,c_Buffer,Len(c_Buffer))
		fClose(n_H)
		//MsgInfo("Txt com os produtos MP sem custo OP criado em system")
		//Return
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montando o array aProdutos somente dos produtos que tem produção                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	/*
	aProducao := {}
	For x := 0 to 100
		For y := 1 to Len(aProdutos)
			If aProdutos[y,nPStatus] == '2' .and. Val(aProdutos[y,nPOPNivel]) == x  // 2="PI/PA"
	AADD(aProducao,aProdutos[y])
			EndIf
		Next y
	Next x
	*/

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Varrendo o array de produção para valorizar as produções com consumos valorizados                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	/*
	nFor := Len(aProducao)

	nMaxLoop    := 100

	If nFor > 0

	nLoopsZero := 0

	oProcess:SetRegua1(nMaxLoop)

		For y := 1 to nMaxLoop
	lOkProd := .F.

	oProcess:IncRegua1("Etapa: 4/5 - Calculando PI/PA Loop : "+Alltrim(Transform(y,'@E 999,999,999,999'))+" / "+Alltrim(Transform(nMaxLoop,'@E 999,999,999,999'))  )

	oProcess:SetRegua2(nFor)

	nRecnoAtu := 1

			For x := 1 to nFor

	oProcess:IncRegua2("Etapa: 4/5 - Calculando PI/PA: "+Alltrim(Transform(nRecnoAtu,'@E 999,999,999,999'))+" / "+Alltrim(Transform(nFor,'@E 999,999,999,999'))  )

	//If lEnd
	//	IF MsgNoYes("Deseja abandonar o processamento do Custo Médio?")
	//		Return
	//	EndIf
	//EndIf

	nRecnoAtu++

				If aProducao[x,nPStatus] <> '10' // "ok"
	// Query que lista todas as produções do produto posicionado com valor zero
	cQuery := "SELECT D3_OP, D3_COD, D3_LOCAL, D3_NUMSEQ, R_E_C_N_O_ FROM SD3010 (NOLOCK) WHERE D3_FILIAL = '"+xFilial("SD3")+"' "
	cQuery += "AND D3_EMISSAO >= '"+DtoS(mv_par01)+"' AND D3_EMISSAO <= '"+DtoS(mv_par02)+"' AND D3_COD = '"+aProducao[x,nPCodigo]+"' "
	cQuery += "AND D3_LOCAL = '"+aProducao[x,nPLocal]+"' AND SUBSTRING(D3_CF,1,2) = 'PR' AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "
	cQuery += "AND D3_XCUSTO1 = 0 "

					If Select("QSD3_4") <> 0
	QSD3_4->( dbCloseArea() )
					EndIf

	TCQUERY cQuery NEW ALIAS "QSD3_4"
	//QUERY08++

	lProdOk := .T.

					While !QSD3_4->( EOF() )
	// Query que verifica se não tem requisições para a OP sem valor
	cQuery := "SELECT R_E_C_N_O_ FROM SD3010 (NOLOCK) WHERE D3_FILIAL = '"+xFilial("SD3")+"' "
	cQuery += "AND D3_EMISSAO >= '"+DtoS(mv_par01)+"' AND D3_EMISSAO <= '"+DtoS(mv_par02)+"' "
	cQuery += "AND D3_OP = '"+QSD3_4->D3_OP+"' AND D3_NUMSEQ = '"+QSD3_4->D3_NUMSEQ+"' AND D3_TM > '500' AND D3_XCUSTO1 = 0 "
	cQuery += "AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "

						If Select("QSD3_5") <> 0
	QSD3_5->( dbCloseArea() )
						EndIf

	TCQUERY cQuery NEW ALIAS "QSD3_5"
	QUERY09++

						If QSD3_5->( EOF() )
	// Query que pega o valor das requisições para gravar na produção
	cQuery := "SELECT SUM(D3_XCUSTO1) AS SUMD3_XCUSTO1 FROM SD3010 (NOLOCK) WHERE D3_FILIAL = '"+xFilial("SD3")+"' "
	cQuery += "AND D3_EMISSAO >= '"+DtoS(mv_par01)+"' AND D3_EMISSAO <= '"+DtoS(mv_par02)+"' "
	cQuery += "AND D3_OP = '"+QSD3_4->D3_OP+"' AND D3_NUMSEQ = '"+QSD3_4->D3_NUMSEQ+"' AND D3_TM > '500' "
	cQuery += "AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "

							If Select("QSD3_6") <> 0
	QSD3_6->( dbCloseArea() )
							EndIf

	TCQUERY cQuery NEW ALIAS "QSD3_6"
	QUERY10++

	cQueryUPD := "UPDATE SD3010 SET D3_XCUSTO1 = '"+Str(QSD3_6->SUMD3_XCUSTO1)+"' WHERE R_E_C_N_O_ = " + Str(QSD3_4->R_E_C_N_O_)

	TCSQLEXEC(cQueryUPD)
						Else
	lProdOk := .F.
						EndIf

	QSD3_4->( dbSkip() )
					End

					If lProdOk
	aProducao[x,nPStatus] := '10' // "ok"
	lOkProd := .T.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³se todas as produções do produto foram valorizadas, faz o custo médio do produto para gravar nas requisições do produto para outras OPs ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "SELECT ISNULL(SUM(D3_QUANT),0) AS SUMD3_QUANT, ISNULL(SUM(D3_XCUSTO1),0) AS SUMD3_XCUSTO1 FROM SD3010 (NOLOCK) "
	cQuery += "WHERE D3_FILIAL = '"+xFilial("SD3")+"' AND D3_EMISSAO >= '"+DtoS(mv_par01)+"' AND D3_EMISSAO <= '"+DtoS(mv_par02)+"' "
	cQuery += "AND D3_COD = '"+aProducao[x,nPCodigo]+"' AND D3_LOCAL = '"+aProducao[x,nPLocal]+"' AND D3_XCUSTO1 <> 0 "
	cQuery += "AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "

	cQuery += "AND SUBSTRING(D3_CF,1,2)  = 'PR' "

						If Select("QSD3_7") <> 0
	QSD3_7->( dbCloseArea() )
						EndIf

	TCQUERY cQuery NEW ALIAS "QSD3_7"
	QUERY11++

						If !QSD3_7->( EOF() )
	aProducao[x, nPQEntVlr ] += QSD3_7->SUMD3_QUANT  // Entradas Valorizadas em quantidade
	aProducao[x, nPVEntVlr ] += QSD3_7->SUMD3_XCUSTO1 // Entradas Valorizadas em valor
						EndIf

	nQtdMedio := aProducao[x, nPSaldoIni] + aProducao[x, nPQEntVlr ]
	nVlrMedio := aProducao[x, nPVlrIni  ] + aProducao[x, nPVEntVlr ]
	nMedio    := Round(nVlrMedio/nQtdMedio,4)

						If !Empty(nMedio)
	cQueryUPD := "UPDATE SD3010 SET D3_XCUSTO1 = (D3_QUANT * "+Str(nMedio)+") WHERE D3_FILIAL = '"+xFilial("SD3")+"' "
	cQueryUPD += "AND D3_EMISSAO >= '"+DtoS(mv_par01)+"' AND D3_EMISSAO <= '"+DtoS(mv_par02)+"' AND D3_COD = '"+aProducao[x,nPCodigo]+"' "
	cQueryUPD += "AND D3_LOCAL = '"+aProducao[x,nPLocal]+"' AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "
	cQueryUPD += "AND D3_CF IN ('RE0','RE1','RE2','DE0') "
	TCSQLEXEC(cQueryUPD)

	//fVldSldfin(aProdutos[x,nPCodigo],aProdutos[x,nPLocal],mv_par01,mv_par02)
						Else
	MsgStop("Produto " + aProdutos[x,nPCodigo] + " tipo PI/PA com nMedio igual a zero")
						EndIf
					EndIf
				EndIf
			Next x

			If !lOkProd
	nLoopsZero++
			EndIf

			If nLoopsZero >= 3
	Exit
			EndIf
		Next y
	EndIf
	*/

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valorizando os produtos que ainda ficaram para trás com zero (provavelmente só tem transferências                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	/*
	cQuery := "SELECT * FROM (
	cQuery += "SELECT D3_FILIAL FILIAL, D3_COD PRODUTO, D3_LOCAL LOCAL, MIN(D3_NUMSEQ) NUMSEQ FROM SD3010 (NOLOCK) SD3 WHERE D3_EMISSAO >= '"+DtoS(mv_par01)+"' AND D3_EMISSAO <= '"+DtoS(mv_par02)+"' AND D3_COD >= '"+mv_par03+"' AND D3_COD <= '"+mv_par04+"' AND D3_CF <> 'DE4' AND D3_ESTORNO = '' AND SD3.D_E_L_E_T_ = '' AND D3_XCUSTO1 = 0 GROUP BY D3_FILIAL, D3_COD, D3_LOCAL "
	cQuery += "UNION "
	cQuery += "SELECT D1_FILIAL FILIAL, D1_COD PRODUTO, D1_LOCAL LOCAL, MIN(D1_NUMSEQ) NUMSEQ FROM SD1010 (NOLOCK) SD1, SF4010 (NOLOCK) SF4 WHERE D1_TES = F4_CODIGO AND F4_ESTOQUE = 'S' AND D1_DTDIGIT >= '"+DtoS(mv_par01)+"' AND D1_DTDIGIT <= '"+DtoS(mv_par02)+"' AND D1_COD >= '"+mv_par03+"' AND D1_COD <= '"+mv_par04+"' AND SD1.D_E_L_E_T_ = '' AND SF4.D_E_L_E_T_ = '' GROUP BY D1_FILIAL, D1_COD, D1_LOCAL "
	cQuery += "UNION "
	cQuery += "SELECT D2_FILIAL FILIAL, D2_COD PRODUTO, D2_LOCAL LOCAL, MIN(D2_NUMSEQ) NUMSEQ FROM SD2010 (NOLOCK) SD2, SF4010 (NOLOCK) SF4 WHERE D2_TES = F4_CODIGO AND F4_ESTOQUE = 'S' AND D2_EMISSAO >= '"+DtoS(mv_par01)+"' AND D2_EMISSAO <= '"+DtoS(mv_par02)+"' AND D2_COD >= '"+mv_par03+"' AND D2_COD <= '"+mv_par04+"' AND D2_XCUSTO1 = 0 AND SD2.D_E_L_E_T_ = '' AND SF4.D_E_L_E_T_ = '' GROUP BY D2_FILIAL, D2_COD, D2_LOCAL "
	cQuery += ") TMP ORDER BY NUMSEQ, PRODUTO, LOCAL	"

	If Select("PRODZERO") <> 0
	PRODZERO->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS "PRODZERO"
	QUERY12++

	nRecno := 0
	PRODZERO->( dbEval({||nRecno++}) )
	PRODZERO->( dbGoTop() )


	//ProcRegua(nRecno)
	oProcess:SetRegua1(nRecno)
	oProcess:SetRegua2(nRecno)

	nRecnoAtu := 1
	While !PRODZERO->( EOF() )
	//IncProc("Etapa: 5/5 - Valorizando a partir de transferências: "+Alltrim(Transform(nRecnoAtu,'@E 999,999,999,999'))+"/"+Alltrim(Transform(nRecno,'@E 999,999,999,999'))  )
	oProcess:IncRegua1("Etapa: 5/5 - Valorizando a partir de transferências: "+Alltrim(Transform(nRecnoAtu,'@E 999,999,999,999'))+" / "+Alltrim(Transform(nRecno,'@E 999,999,999,999'))  )
	oProcess:IncRegua2("Etapa: 5/5 - Valorizando a partir de transferências: "+Alltrim(Transform(nRecnoAtu,'@E 999,999,999,999'))+" / "+Alltrim(Transform(nRecno,'@E 999,999,999,999'))  )

		If lEnd
			IF MsgNoYes("Deseja abandonar o processamento do Custo Médio?")
	Return
			EndIf
		EndIf

	cQuery := "SELECT D3_QUANT, D3_XCUSTO1 FROM SD3010 (NOLOCK) WHERE D3_FILIAL = '"+PRODZERO->FILIAL+"' AND D3_EMISSAO >= '"+DtoS(mv_par01)+"' "
	cQuery += "AND D3_EMISSAO <= '"+DtoS(mv_par02)+"' "
	cQuery += "AND D3_COD = '"+PRODZERO->PRODUTO+"' AND D3_LOCAL = '"+PRODZERO->LOCAL+"' "
	cQuery += "AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "
	cQuery += "AND D3_CF  = 'DE4' "
		If Select("QSD3") <> 0
	QSD3->( dbCloseArea() )
		EndIf
	TCQUERY cQuery NEW ALIAS "QSD3"
	QUERY13++

	nQtdMedio := 0
	nVlrMedio := 0
		While !QSD3->( EOF() )
	nQtdMedio += QSD3->D3_QUANT
	nVlrMedio += QSD3->D3_XCUSTO1
	QSD3->( dbSkip() )
		End

	nMedio    := Round(nVlrMedio/nQtdMedio,4)

		IF !Empty(nMedio)
	cQueryUPD := "UPDATE SD3010 SET D3_XCUSTO1 = (D3_QUANT * "+Str(nMedio)+") WHERE D3_FILIAL = '"+PRODZERO->FILIAL+"' AND D3_EMISSAO >= '"+DtoS(mv_par01)+"' "
	cQueryUPD += "AND D3_EMISSAO <= '"+DtoS(mv_par02)+"' AND D3_COD = '"+PRODZERO->PRODUTO+"' AND D3_LOCAL = '"+PRODZERO->LOCAL+"' "
	cQueryUPD += "AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "
	cQueryUPD += "AND D3_CF IN ('RE0','RE1','RE2','DE0') "
	TCSQLEXEC(cQueryUPD)

	// SELECIONANDO TRANSFERENCIAS PARA VALORIZAÇÃO
	cQuery := "SELECT D3_FILIAL, D3_NUMSEQ FROM SD3010 (NOLOCK) WHERE D3_FILIAL = '"+PRODZERO->FILIAL+"' AND D3_EMISSAO >= '"+DtoS(mv_par01)+"' "
	cQuery += "AND D3_EMISSAO <= '"+DtoS(mv_par02)+"' "
	cQuery += "AND D3_COD = '"+PRODZERO->PRODUTO+"' AND D3_LOCAL = '"+PRODZERO->LOCAL+"' "
	cQuery += "AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "
	cQuery += "AND D3_CF  = 'RE4' "
	cQuery += "GROUP BY D3_FILIAL, D3_NUMSEQ "

			If Select("QD3NUMSEQ")
	QD3NUMSEQ->( dbCloseArea() )
			EndIf

	TCQUERY cQuery NEW ALIAS "QD3NUMSEQ"
	QUERY14++

			While !QD3NUMSEQ->( EOF() )
	cQueryUPD := ""
	cQueryUPD := "UPDATE SD3010 SET D3_XCUSTO1 = (D3_QUANT * "+Alltrim(Str(nMedio))+") WHERE D3_FILIAL = '"+xFilial("SD3")+"' "
	cQueryUPD += "AND D3_EMISSAO >= '"+DtoS(mv_par01)+"' AND D3_EMISSAO <= '"+DtoS(mv_par02)+"' AND D3_CF IN ('RE4','DE4') "
	cQueryUPD += "AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "
	cQueryUPD += "AND D3_FILIAL = '"+QD3NUMSEQ->D3_FILIAL+"' AND D3_NUMSEQ = '"+QD3NUMSEQ->D3_NUMSEQ+"' "
	TCSQLEXEC(cQueryUPD)
	QD3NUMSEQ->( dbSkip() )
			End

	//fVldSldfin(PRODZERO->PRODUTO,PRODZERO->LOCAL,mv_par01,mv_par02)
		EndIf

	PRODZERO->( dbSkip() )
	nRecnoAtu++
	End
	*/

	MsgInfo("Processamento concluído. Hora Inicial: " + cHoraIni + " Hora final " + Time())

Return

Static Function fVldSldfin(cProduto,cLocal,dDataIni,dDataFin, nMedio)
	Local aSaldos
	Local _Retorno := nMedio

	//SB2->( dbSetOrder(1) )

	If lAtualizaSD3
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³VALORIZANDO MOVIMENTOAÇÕES ANTES DO CALCEST                                         ³
		//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQueryUPD := "UPDATE SD3010 SET D3_XCUSTO1 = (D3_QUANT * "+Str(nMedio)+") WHERE D3_FILIAL = '"+xFilial("SD3")+"' "
		cQueryUPD += "AND D3_COD = '"+cProduto+"' AND D3_LOCAL = '"+cLocal+"' "
		cQueryUPD += "AND D3_EMISSAO >= '"+DtoS(dDataIni)+"' AND D3_EMISSAO <= '"+DtoS(dDataFin)+"'
		cQueryUPD += "AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "
		cQueryUPD += "AND D3_CF IN ('RE0','RE1','RE2','DE0') "

		TCSQLEXEC(cQueryUPD)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Valorizando as duas movimentações de transferência a partir do D3_NUMSEQ antes do XCALCEST
		//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQueryIN := "SELECT D3_FILIAL + D3_NUMSEQ FROM SD3010 (NOLOCK) WHERE D3_FILIAL = '"+xFilial("SD3")+"' "
		cQueryIN += "AND D3_COD = '"+cProduto+"' AND D3_LOCAL = '"+cLocal+"' "
		cQueryIN += "AND D3_EMISSAO >= '"+DtoS(dDataIni)+"' AND D3_EMISSAO <= '"+DtoS(dDataFin)+"' "
		cQueryIN += "AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "
		cQueryIN += "AND D3_CF  = 'RE4' "
		cQueryIN += "GROUP BY D3_FILIAL, D3_NUMSEQ "

		cQueryUPD := "UPDATE SD3010 SET D3_XCUSTO1 = (D3_QUANT * "+Alltrim(Str(nMedio))+") WHERE D3_FILIAL = '"+xFilial("SD3")+"' "
		cQueryUPD += "AND D3_EMISSAO >= '"+DtoS(dDataIni)+"' AND D3_EMISSAO <= '"+DtoS(dDataFin)+"' AND D3_CF IN ('RE4','DE4') "
		cQueryUPD += "AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "
		cQueryUPD += "AND D3_FILIAL+D3_NUMSEQ IN ("+cQueryIN+")  "
		TCSQLEXEC(cQueryUPD)

		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ATUALIZANDO NOTAS FISCAIS DE SAÍDA ANTES DO XCALCEST
		//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lAtualizaSD3
			cQueryUPD := "UPDATE SD2010 SET D2_XCUSTO1 = (D2_QUANT * "+Str(nMedio)+") WHERE D2_FILIAL = '"+xFilial("SD2")+"' "
			cQueryUPD += "AND D2_COD = '"+cProduto+"' AND D2_LOCAL = '"+cLocal+"' "
			cQueryUPD += "AND D2_EMISSAO >= '"+DtoS(mv_par01)+"' AND D2_EMISSAO <= '"+DtoS(mv_par02)+"'
			cQueryUPD += "AND D_E_L_E_T_ = '' "

			TCSQLEXEC(cQueryUPD)
		EndIf

	EndIf

	If mv_par08 == 2  // Ajusta quantidade zero final com valor? Se nao for ajustar, não precisa rodar o resto da função
		Return _Retorno
	ENDIF
	
    aSaldos := U_XCalcEst(cProduto,cLocal,dDataFin+1)

	If aSaldos[1] == 0
		If aSaldos[2] <> 0
			If aSaldos[2] > 0
				nVlrDis:= aSaldos[2]
				cQuery := "SELECT D3_FILIAL, D3_QUANT, D3_XCUSTO1, D3_CF, D3_NUMSEQ, R_E_C_N_O_ FROM SD3010 (NOLOCK) "
				cQuery += "WHERE D3_FILIAL = '"+xFilial("SD3")+"' AND D3_EMISSAO >= '"+DtoS(mv_par01)+"' "
				cQuery += "AND D3_EMISSAO <= '"+DtoS(dDataFin)+"' AND D3_COD = '"+cProduto+"' AND D3_LOCAL = '"+cLocal+"' "
				cQuery += "AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "
				cQuery += "AND D3_CF IN ('RE0','RE1','RE2','RE4') "
				cQuery += "ORDER BY D3_NUMSEQ DESC "
				If Select("QSD3") <> 0
					QSD3->( dbCloseArea() )
				EndIf
				TCQUERY cQuery NEW ALIAS "QSD3"
				//QUERY15++

				nQtdSD3 := 0
				QSD3->( dbEval({||nQtdSD3 += QSD3->D3_QUANT}) )
				QSD3->( dbGoTop() )

				nAjusteQtd := NoRound(nVlrDis / nQtdSD3,4)

				_Retorno += nAjusteQtd

				While !QSD3->( EOF() ) .and. nVlrDis > 0
					//SD3->( dbGoTo(QSD3->R_E_C_N_O_) )
					//If SD3->( Recno() ) == QSD3->R_E_C_N_O_
					If QSD3->D3_CF <> 'RE4'
						nAjusteSD3 := Round(QSD3->D3_QUANT,4) * nAjusteQtd

						If (nVlrDis - nAjusteSD3) >= 0
							cQueryUPD := "UPDATE SD3010 SET D3_XCUSTO1 = (D3_XCUSTO1 + "+Alltrim(Str(nAjusteSD3))+") "
							cQueryUPD += "WHERE R_E_C_N_O_ = " + Alltrim(Str(QSD3->R_E_C_N_O_))
							TCSQLEXEC(cQueryUPD)
							nVlrDis -= nAjusteSD3
						else
							cQueryUPD := "UPDATE SD3010 SET D3_XCUSTO1 = (D3_XCUSTO1 + "+Alltrim(Str(nVlrDis))+") "
							cQueryUPD += "WHERE R_E_C_N_O_ = " + Alltrim(Str(QSD3->R_E_C_N_O_))
							TCSQLEXEC(cQueryUPD)
							nVlrDis -= nVlrDis
						EndIf
					Else
						//cNumSeq := QSD3->D3_FILIAL+QSD3->D3_NUMSEQ
						nAjusteSD3 := Round(QSD3->D3_QUANT,4) * nAjusteQtd

						If (nVlrDis - nAjusteSD3) >= 0
							cQueryUPD := "UPDATE SD3010 SET D3_XCUSTO1 = (D3_XCUSTO1 + "+Alltrim(Str(nAjusteSD3))+") "
							cQueryUPD += "WHERE D3_FILIAL = '"+SD3->D3_FILIAL+"' "
							cQueryUPD += "AND D3_EMISSAO >= '"+DtoS(mv_par01)+"' AND D3_EMISSAO <= '"+DtoS(mv_par02)+"' "
							cQueryUPD += "AND D3_CF IN ('RE4','DE4') "
							cQueryUPD += "AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "
							cQueryUPD += "AND D3_NUMSEQ = '"+QSD3->D3_NUMSEQ+"' "
							TCSQLEXEC(cQueryUPD)
							nVlrDis -= nAjusteSD3
						else
							cQueryUPD := "UPDATE SD3010 SET D3_XCUSTO1 = (D3_XCUSTO1 + "+Alltrim(Str(nVlrDis))+") "
							cQueryUPD += "WHERE D3_FILIAL = '"+SD3->D3_FILIAL+"' "
							cQueryUPD += "AND D3_EMISSAO >= '"+DtoS(mv_par01)+"' AND D3_EMISSAO <= '"+DtoS(mv_par02)+"' "
							cQueryUPD += "AND D3_CF IN ('RE4','DE4') "
							cQueryUPD += "AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "
							cQueryUPD += "AND D3_NUMSEQ = '"+QSD3->D3_NUMSEQ+"' "
							TCSQLEXEC(cQueryUPD)
							nVlrDis -= nVlrDis
						EndIf
					EndIf
					//EndIf
					QSD3->( dbSkip() )
				End

				QSD3->( dbGoTop() )

				nAjuste := mv_par07
				If !QSD3->( EOF() ) .and. !Empty(nAjuste)

					While nVlrDis > 0
						QSD3->( dbGoTop() )

						While !QSD3->( EOF() ) .and. nVlrDis > 0
							If QSD3->D3_CF <> 'RE4'
								cQueryUPD := ""
								cQueryUPD := "UPDATE SD3010 SET D3_XCUSTO1 = (D3_XCUSTO1 + "+Alltrim(Str(nAjuste))+") WHERE R_E_C_N_O_ = " + Alltrim(Str(QSD3->R_E_C_N_O_))
								TCSQLEXEC(cQueryUPD)
								QSD3->( dbSkip() )
								nVlrDis -= nAjuste
							Else
								cQueryUPD := ""
								cQueryUPD := "UPDATE SD3010 SET D3_XCUSTO1 = (D3_XCUSTO1 + "+Alltrim(Str(nAjuste))+") WHERE D3_NUMSEQ = '" + QSD3->D3_NUMSEQ + "' AND D3_EMISSAO >= '"+DtoS(mv_par01)+"' AND D3_EMISSAO <= '"+DtoS(mv_par02)+"' AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "
								TCSQLEXEC(cQueryUPD)
								QSD3->( dbSkip() )
								nVlrDis -= nAjuste
							EndIf
						End
					End

				EndIf

			Else
				// SE O VALOR FOR MENOR QUE ZERO

				nVlrDis:= aSaldos[2]
				cQuery := "SELECT D3_QUANT, D3_XCUSTO1, D3_CF, D3_NUMSEQ, R_E_C_N_O_ FROM SD3010 (NOLOCK) WHERE D3_FILIAL = '"+xFilial("SD3")+"' "
				cQuery += "AND D3_EMISSAO >= '"+DtoS(mv_par01)+"' "
				cQuery += "AND D3_EMISSAO <= '"+DtoS(dDataFin)+"' AND D3_COD = '"+cProduto+"' AND D3_LOCAL = '"+cLocal+"' "
				cQuery += "AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "
				cQuery += "AND D3_CF IN ('RE0','RE1','RE2','RE4') "
				cQuery += "ORDER BY D3_NUMSEQ DESC "
				If Select("QSD3") <> 0
					QSD3->( dbCloseArea() )
				EndIf
				TCQUERY cQuery NEW ALIAS "QSD3"
				//QUERY16++

				nQtdSD3 := 0
				While !QSD3->( EOF() )
					nQtdSD3 += QSD3->D3_QUANT
					QSD3->( dbSkip() )
				End
				QSD3->( dbGoTop() )

				nAjusteQtd := NoRound((nVlrDis*(-1)) / nQtdSD3,4)

				_Retorno -= nAjusteQtd

				If !Empty(nAjusteQtd)
					While !QSD3->( EOF() )
						SD3->( dbGoTo(QSD3->R_E_C_N_O_) )
						If SD3->( Recno() ) == QSD3->R_E_C_N_O_
							If SD3->D3_CF <> 'RE4'
								nAjusteSD3 := SD3->D3_QUANT * nAjusteQtd
								If (nVlrDis - nAjusteSD3) >= 0
									Reclock("SD3",.F.)
									SD3->D3_XCUSTO1 -= nAjusteSD3
									SD3->( msUnlock() )
									nVlrDis -= nAjusteSD3
								else
									Reclock("SD3",.F.)
									SD3->D3_XCUSTO1 -= nVlrDis
									SD3->( msUnlock() )
									nVlrDis -= nVlrDis
								EndIf
							Else
								cNumSeq := SD3->D3_FILIAL+SD3->D3_NUMSEQ
								SD3->( dbSetOrder(4) )
								nAjusteSD3 := SD3->D3_QUANT * nAjusteQtd
								If (nVlrDis - nAjusteSD3) >= 0
									Reclock("SD3",.F.)
									SD3->D3_XCUSTO1 -= nAjusteSD3
									SD3->( msUnlock() )
									//nVlrDis -= nAjusteSD3 // Só pode dimimuir do valor do nVlrDis em um dos dois movimentos da transferência
								else
									Reclock("SD3",.F.)
									SD3->D3_XCUSTO1 -= nVlrDis
									SD3->( msUnlock() )
									//nVlrDis -= nVlrDis // Só pode dimimuir do valor do nVlrDis em um dos dois movimentos da transferência
								EndIf
								SD3->( dbSkip() )
								If (SD3->D3_FILIAL + SD3->D3_NUMSEQ) == cNumSeq
									If (nVlrDis - nAjusteSD3) >= 0
										Reclock("SD3",.F.)
										SD3->D3_XCUSTO1 -= nAjusteSD3
										SD3->( msUnlock() )
										nVlrDis -= nAjusteSD3
									else
										Reclock("SD3",.F.)
										SD3->D3_XCUSTO1 -= nVlrDis
										SD3->( msUnlock() )
										nVlrDis -= nVlrDis
									EndIf
								Else
									MsgStop("Erro 01. Desposicionou da outra parte da transferência no skip indice 4")
								EndIf
							EndIf
						EndIf
						QSD3->( dbSkip() )
					End
				EndIf
				QSD3->( dbGoTop() )

				nAjuste := mv_par07
				If !QSD3->( EOF() ) .and. !Empty(nAjuste)

					While nVlrDis > 0
						QSD3->( dbGoTop() )

						While !QSD3->( EOF() ) .and. nVlrDis > 0
							If QSD3->D3_CF <> 'RE4'
								cQueryUPD := ""
								cQueryUPD := "UPDATE SD3010 SET D3_XCUSTO1 = (D3_XCUSTO1 - "+Alltrim(Str(nAjuste))+") WHERE R_E_C_N_O_ = " + Alltrim(Str(QSD3->R_E_C_N_O_))
								TCSQLEXEC(cQueryUPD)
								QSD3->( dbSkip() )
								nVlrDis -= nAjuste
							Else
								cQueryUPD := ""
								cQueryUPD := "UPDATE SD3010 SET D3_XCUSTO1 = (D3_XCUSTO1 - "+Alltrim(Str(nAjuste))+") WHERE D3_NUMSEQ = '" + QSD3->D3_NUMSEQ + "' AND D3_EMISSAO >= '"+DtoS(mv_par01)+"' AND D3_EMISSAO <= '"+DtoS(mv_par02)+"' AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "
								TCSQLEXEC(cQueryUPD)
								QSD3->( dbSkip() )
								nVlrDis -= nAjuste
							EndIf
						End
					End

				EndIf

			EndIf

			// Se houve alguma alteração de custos, recalcula o saldo antes de gravar no SB2
			//aSaldos := CalcEst(cProduto,cLocal,dDataFin+1)
			//If SB2->( dbSeek( xFilial() + cProduto + cLocal ) )
			//	Reclock("SB2",.F.)
			//	SB2->B2_QFIM  := aSaldos[1]
			//	SB2->B2_VFIM1 := aSaldos[2]
			//	SB2->( msUnlock() )
			//Else
			//	MsgStop("Produto/Local não encontrados no SB2 para atualizar o QFIM: " + cProduto + '/' + cLocal)
			//EndIf

		Else
			//If SB2->( dbSeek( xFilial() + cProduto + cLocal ) )
			//	Reclock("SB2",.F.)
			//	SB2->B2_QFIM  := aSaldos[1]
			//	SB2->B2_VFIM1 := aSaldos[2]
			//	SB2->( msUnlock() )
			//Else
			//	MsgStop("Produto/Local não encontrados no SB2 para atualizar o QFIM: " + cProduto + '/' + cLocal)
			//EndIf
		EndIf
	Else
		//If SB2->( dbSeek( xFilial() + cProduto + cLocal ) )
		//	Reclock("SB2",.F.)
		//	SB2->B2_QFIM  := aSaldos[1]
		//	SB2->B2_VFIM1 := aSaldos[2]
		//	SB2->( msUnlock() )
		//Else
		//	MsgStop("Produto/Local não encontrados no SB2 para atualizar o QFIM: " + cProduto + '/' + cLocal)
		//EndIf
	EndIf

Return _Retorno

Static Function RetTempo(cIni,cFim)
	Local _Retorno
	Local dData    := StoD('19800212')
	Local dDataIni := StoD(Subs(cIni,1,8))
	Local dDataFim := StoD(Subs(cFim,1,8))
	Local cHoraIni := Subs(cIni,9,8)
	Local cHoraFim := Subs(cFim,9,8)

	Local nDiaIni := dDataIni - dData
	Local nDiaFim := dDataFim - dData

	Local nSegIni := (((nDiaIni * 24) * 60) * 60)    +    ((Val(Subs(cHoraIni,1,2)) * 60) * 60) +  (Val(Subs(cHoraIni,4,2)) * 60) +  Val(Subs(cHoraIni,7,2))  // segundos
	Local nSegFim := (((nDiaFim * 24) * 60) * 60)    +    ((Val(Subs(cHoraFim,1,2)) * 60) * 60) +  (Val(Subs(cHoraFim,4,2)) * 60) +  Val(Subs(cHoraFim,7,2))  // segundos

	Local nSegDif := Int(nSegFim - nSegIni)

	Local nHoras  := 0

	If nSegDif <= 59                                   //   de 0 a 59 segundos
		_Retorno := Alltrim(Str(nSegDif)) + " segundos"
	Else
		If nSegDif >= 60 .and. nSegDif <= ((59*60)+59)           // de 1 minutos a 59 minutos e 59 segundos
			_Retorno := Alltrim(Str(Int(nSegDif/60))) + " minutos e " + Alltrim(Str(nSegDif-(Int(nSegDif/60)*60))) + " segundos"
		Else
			// de 1 horas pra cima
			nHoras     := Int(nSegDif/(60*60))
			nMinutos  := Int((nSegDif - (nHoras*(60*60))) / 60)
			nSegundos := nSegDif - ((nHora*(60*60)) + (nMinutos * 60))
			_Retorno   := Alltrim(Str(nHora)) + " horas " + Alltrim(Str(nMinutos )) + " minutos e " + Alltrim(Str(nSegundos)) + " segundos"
		EndIf
	EndIf

Return _Retorno

User Function XCALCEST(cProduto,cLocal,dData)
	Local aRetorno := {0,0}
	Local dDataSB9, cQuery

	If dData > GetMV("MV_ULMES")
		dDataSB9 := GetMV("MV_ULMES")
	else
		MsgStop("Função XCALCEST não pode ser executada para datas anteriores ao MV_ULMES")
		Return aRetorno
	ENDIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Calculando o saldo inicial via SB9 ou CalcEst()                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SB9->( dbSeek( xFilial() + cProduto + cLocal + DtoS(dDataSb9) ) )
		aRetorno[1] := SB9->B9_QINI
		aRetorno[2] := SB9->B9_VINI1
	Else
		aCalcEst := CalcEst(cProduto,cLocal,dDataSB9+1)
		aRetorno[1] := aCalcEst[1]
		aRetorno[2] := aCalcEst[2]
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Movimentação pelo SD3                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "SELECT SUM_D3QUANT = SUM(CASE WHEN D3_TM > '500' THEN -D3_QUANT ELSE +D3_QUANT END), "
	cQuery += "SUM_D3XCUSTO1 = SUM(CASE WHEN D3_TM > '500' THEN -D3_XCUSTO1 ELSE +D3_XCUSTO1 END) "
	cQuery += "FROM SD3010 (NOLOCK) WHERE D3_COD = '"+cProduto+"' AND D3_LOCAL = '"+cLocal+"' "
	cQuery += "AND D3_EMISSAO >= '"+DtoS(dDataSB9+1)+"' AND D3_EMISSAO <= '"+DtoS(dData-1)+"' "
	cQuery += "AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "

	If Select("QCALCEST") <> 0
		QCALCEST->( dbCloseArea() )
	ENDIF

	TCQUERY cQuery NEW ALIAS "QCALCEST"

	aRetorno[1] += QCALCEST->SUM_D3QUANT
	aRetorno[2] += QCALCEST->SUM_D3XCUSTO1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Movimentação pelo SD2                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "SELECT SUM_D2QUANT = SUM(CASE WHEN D2_TES > '500' THEN -D2_QUANT ELSE +D2_QUANT END), "
	cQuery += "SUM_D2XCUSTO1 = SUM(CASE WHEN D2_TES > '500' THEN -D2_XCUSTO1 ELSE +D2_XCUSTO1 END) "
	cQuery += "FROM SD2010 (NOLOCK), SF4010 (NOLOCK) WHERE D2_COD = '"+cProduto+"' AND D2_LOCAL = '"+cLocal+"' "
	cQuery += "AND D2_EMISSAO >= '"+DtoS(dDataSB9+1)+"' AND D2_EMISSAO <= '"+DtoS(dData-1)+"' "
	cQuery += "AND D2_TES = F4_CODIGO AND F4_ESTOQUE = 'S' AND SD2010.D_E_L_E_T_ = '' AND SF4010.D_E_L_E_T_ = '' "

	If Select("QCALCEST") <> 0
		QCALCEST->( dbCloseArea() )
	ENDIF

	TCQUERY cQuery NEW ALIAS "QCALCEST"

	aRetorno[1] += QCALCEST->SUM_D2QUANT
	aRetorno[2] += QCALCEST->SUM_D2XCUSTO1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Movimentação pelo SD1
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "SELECT SUM_D1QUANT = SUM(CASE WHEN D1_TES > '500' THEN -D1_QUANT ELSE +D1_QUANT END), "
	cQuery += "SUM_D1CUSTO = SUM(CASE WHEN D1_TES > '500' THEN -D1_CUSTO ELSE +D1_CUSTO END) "
	cQuery += "FROM SD1010 (NOLOCK), SF4010 (NOLOCK) WHERE D1_COD = '"+cProduto+"' AND D1_LOCAL = '"+cLocal+"' "
	cQuery += "AND D1_DTDIGIT >= '"+DtoS(dDataSB9+1)+"' AND D1_DTDIGIT <= '"+DtoS(dData-1)+"' "
	cQuery += "AND D1_TES = F4_CODIGO AND F4_ESTOQUE = 'S' AND SD1010.D_E_L_E_T_ = '' AND SF4010.D_E_L_E_T_ = '' "

	If Select("QCALCEST") <> 0
		QCALCEST->( dbCloseArea() )
	ENDIF

	TCQUERY cQuery NEW ALIAS "QCALCEST"

	aRetorno[1] += QCALCEST->SUM_D1QUANT
	aRetorno[2] += QCALCEST->SUM_D1CUSTO

	QCALCEST->( dbCloseArea() )

Return aRetorno
