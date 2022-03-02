#include "font.ch"
#include "colors.ch"
#include "Protheus.ch"
#include "Topconn.ch"
#include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTR03   บAutor  ณHelio Ferreira      บ Data ณ  2013/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ DOMEX                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RESTR03()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	Local   cDesc1      := "Este programa tem como objetivo imprimir relatorio "
	Local   cDesc2      := "de acordo com os parametros informados pelo usuario."
	Local   cDesc3      := "Saldo empenho"
	Local   Cabec1      := "PRODUTO          OP           DT.ENCERR.   QTD. ORI EMP  QTD.ORI PERDA     SALDO EMP   SALDO PERDA     QTD PG OP    CONSUMO SD5   CONSUMO SD3   CONSUMO ER    EST. CALC.  EST.P/ AJUST.     SLD LOTE"
	Local   Cabec2      := " "
//Local   imprime     := .T.
	Local   aOrd        := {}

	Private nLin        := 80
	Private cLocProcDom := GetMV("MV_XXLOCPR")   // Local de Processos Domex
	Private titulo      := "Saldos em Processo " + cLocProcDom
//Private lEnd        := .F.
	Private tamanho     := "G"
	Private nomeprog    := "RESTR03"
	Private nTipo       := 18
	Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey    := 0
	Private cPerg       := "RESTR03"
	Private wnrel       := "RESTR03"
	Private cString     := "SD4"
	Private cValDif     := 0
	Private lERROProd   :=.F.
	Private dUlmes      := GETMV("MV_ULMES",.F.,)
	Private m_pag       := 0
	Private nValorTOT   := 0
	Private lSkipSB1    := .T.

	pergunte(cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.T.)

	mv_do_prod := mv_par01
	mv_ate_pro := mv_par02
	mv_da_op   := mv_par03
	mv_ate_op  := mv_par04
	mv_lin_err := mv_par05
	mv_ajuste  := mv_par06
	mv_1_erro  := mv_par07
	mv_so_erro := mv_par08
	mv_mata300 := mv_par09
	mv_sosaldo := mv_par10
//mv_ate_emp := mv_par11

	If mv_ajuste == 1 //.and. Subs(cusuario,7,5) <> 'Jonas' .and. Subs(cusuario,7,5) <> 'HELIO'
		//MsgStop('Usuแrio sem permissใo para rodar o relat๓rio gerando ajustes de estoque.')
		MsgStop('Nใo ้ possํvel executar o relat๓rio com a op็ใo de gera็ใo de ajustes = Sim.')
		Return
	EndIf

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

//U_HJACERTA()

	Processa({|lEnd| RunReport(Cabec1,Cabec2,Titulo,@nLin,@lEnd) },Titulo)

	If !Empty(nValorTOT)
		@ nLin, 000 pSay "VALOR TOTAL DOS PRODUTOS EM ESTOQUE: " + Transform(nValorTOT,"@E 999,999,999.9999")
	EndIf

	Roda(0,"","M")

	SET DEVICE TO SCREEN

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

	If MsgYesNO('Deseja rodar o relat๓rio novamente?')
		U_RESTR03()
	EndIf
Return



Static Function RunReport(Cabec1,Cabec2,Titulo,nLin,lEnd)
	Local x, naSldLote

	pergunte(cPerg,.F.)

	mv_do_prod := mv_par01
	mv_ate_pro := mv_par02
	mv_da_op   := mv_par03
	mv_ate_op  := mv_par04
	mv_lin_err := mv_par05
	mv_ajuste  := mv_par06
	mv_1_erro  := mv_par07
	mv_so_erro := mv_par08
	mv_mata300 := mv_par09
	mv_sosaldo := mv_par10
//mv_ate_emp := mv_par11

	cQuery := "SELECT B1_COD, B1_TIPO FROM SB1010 WHERE B1_COD >= '"+mv_do_prod+"' AND B1_COD <= '"+mv_ate_pro+"' AND D_E_L_E_T_ = '' "
	cQuery += "AND B1_COD IN (SELECT B2_COD FROM SB2010 WHERE B2_LOCAL = '"+cLocProcDom+"' AND D_E_L_E_T_ = '' ) "
	cQuery += "ORDER BY B1_COD "

	If Select("QSB1") <> 0
		QSB1->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS "QSB1"

	nRecno:=0
	QSB1->( dbEval({|| nRecno++}) )

	ProcRegua(nRecno)

	QSB1->( dbGoTop() )

	While !QSB1->( EOF() )

		If lEnd
			MsgStop("Processamento cancelado")
			Return
		EndIf

		lERROProd   := .F.

		fGravaParam()

		INCPROC("Produto: " + QSB1->B1_COD )

		//SB2->( dbSetOrder(1) )
		//SB2->( dbSeek( xFilial() + QSB1->B1_COD + '97' ) )
		//If SB2->B2_QFIM >= 0
		//   QSB1->( dbSkip() )
		//   Loop
		//EndIf

		cQuery := "SELECT D4_COD, D4_OP, D4_QTDEORI, D4_QUANT, "
		cQuery += "ISNULL((SELECT SUM(ZE_QTDORI) FROM SZE010 WHERE ZE_FILIAL = '"+xFilial("SZE")+"' AND ZE_PRODUTO = D4_COD AND ZE_OP = D4_OP AND D_E_L_E_T_ = '' ),0) AS ZE_QTDORI, "
		cQuery += "ISNULL((SELECT SUM(ZE_SALDO)  FROM SZE010 WHERE ZE_FILIAL = '"+xFilial("SZE")+"' AND ZE_PRODUTO = D4_COD AND ZE_OP = D4_OP AND D_E_L_E_T_ = '' ),0) AS ZE_SALDO,  "

		// Quantidade Paga para a OP
		cQuery += " ISNULL((SELECT SUM(CASE WHEN D3_TM > '500' THEN -D3_QUANT ELSE +D3_QUANT END) AS D3PAGOP "
		cQuery += " FROM SD3010 SD3                                                                          "
		cQuery += "	WHERE D3_FILIAL = '"+xFilial("SD3")+"'                                                   "
		cQuery += " AND   D3_XXOP    = D4_OP                                                                 "
		cQuery += "	AND   D3_COD     = D4_COD                                                                "
		cQuery += " AND   D3_LOCAL   = '"+cLocProcDom+"'                                                     "
		cQuery += "	AND   (D3_CF      IN ('DE4','RE4') OR D3_DOC = 'INVENT')                                 "
		cQuery += "	AND   D3_ESTORNO = ''                                                                    "
		cQuery += "	AND   D_E_L_E_T_ = ''),0) AS D3PAGOP,                                                    "
		// Fim da quantidade paga para a OP

		// Material consumido pela OP
		cQuery += " ISNULL((SELECT SUM(CASE WHEN D3_TM='999' THEN +D3_QUANT ELSE -D3_QUANT END) AS D3CONSUMOOP "
		cQuery += " FROM SD3010 SD3                                                                            "
		cQuery += "	WHERE D3_FILIAL = '"+xFilial("SD3")+"'                                                     "
		cQuery += " AND   D3_OP      = D4_OP                                                                   "
		cQuery += "	AND   D3_COD     = D4_COD                                                                  "
		cQuery += " AND   D3_LOCAL   = '"+cLocProcDom+"'                                                       "
		cQuery += "	AND   D3_TM      IN ('499','999')                                                          "
		cQuery += "	AND   D3_CF      IN ('RE1','RE2','DE1','DE2')                                              "
		cQuery += "	AND   D3_ESTORNO = '' AND D_E_L_E_T_ = ''),0) AS D3CONSUMOOP,                              "
		// Fim do material consumido pela OP

		// SD5OK
		cQuery += " ISNULL((SELECT SUM(CASE WHEN D5_ORIGLAN='999' THEN +D5_QUANT ELSE -D5_QUANT END) AS SD5OK "
		cQuery += " FROM SD5010 SD5                                                                           "
		cQuery += "	WHERE D5_FILIAL = '"+xFilial("SD5")+"'                                                    "
		cQuery += " AND   D5_OP      = D4_OP                                                                  "

		If U_VALIDACAO("HELIO")
			If SD4->( FieldPos("D4_XOP") ) = 0
				cQuery += " AND   D5_LOTECTL = SUBSTRING(D4_OP,1,8)                                            "
			Else
				U_ATUD4XOP()
				cQuery += " AND   D5_LOTECTL = D4_XOP                                                          "
			EndIf
		Else
			cQuery += " AND   D5_LOTECTL = SUBSTRING(D4_OP,1,8)                                               "
		EndIf

		cQuery += "	AND   D5_PRODUTO = D4_COD                                                                 "
		cQuery += " AND   D5_LOCAL   = '"+cLocProcDom+"'                                                      "
		cQuery += "	AND   D5_ORIGLAN  IN ('499','999')                                                        "
		cQuery += "	AND   D5_ESTORNO = '' AND   D_E_L_E_T_ = '' ),0) AS SD5OK,                                "
		// Fim SD5OK

		// consumo do SD5 ERRADO
		cQuery += " ISNULL((SELECT SUM(CASE WHEN D5_ORIGLAN='999' THEN +D5_QUANT ELSE -D5_QUANT END) AS SD5ERRO "
		cQuery += " FROM SD5010 SD5                                                                             "
		cQuery += "	WHERE D5_FILIAL = '"+xFilial("SD5")+"'                                                                      "
		cQuery += " AND   D5_OP      = D4_OP                                                                    "
		cQuery += " AND   D5_LOTECTL <> SUBSTRING(D4_OP,1,8)                                                    "
		cQuery += "	AND   D5_PRODUTO = D4_COD                                                                   "
		cQuery += " AND   D5_LOCAL   = '"+cLocProcDom+"'                                                        "
		cQuery += "	AND   D5_ORIGLAN     IN ('499','999')                                                       "
		cQuery += "	AND   D5_ESTORNO = '' AND   D_E_L_E_T_ = ''),0) AS SD5ERRO                                  "
		// Fim do SD5 ERRADO


		cQuery += "FROM SD4010  "

		cQuery += " WHERE D4_FILIAL = '"+xFilial("SD4")+"' AND D4_LOCAL = '"+cLocProcDom+"' AND "

		cQuery += " (D4_QUANT <> 0 OR SUBSTRING(D4_OP,1,8) IN ( SELECT B8_LOTECTL FROM SB8010 WHERE B8_FILIAL = '"+xFilial("SB8")+"' AND B8_PRODUTO = D4_COD AND B8_SALDO <> 0 AND D_E_L_E_T_ = '' ) ) AND "

		cQuery += "D4_COD = '"+QSB1->B1_COD+"' AND D4_OP >= '"+mv_da_op+"' AND D4_OP <= '"+mv_ate_op+"' AND "
		//cQuery += "D4_DATA >= '"+DtoS(mv_ee_Empe)+"' AND D4_DATA <= '"+DtoS(mv_ate_emp)+"' AND "
		cQuery += "D_E_L_E_T_ = '' "

		cQuery += "ORDER BY D4_COD, D4_OP "

		If Select("QUERYSD4") <> 0
			QUERYSD4->( dbCloseArea() )
		EndIf

		TCQUERY cQuery NEW ALIAS "QUERYSD4"

		If !QUERYSD4->( EOF() )

			cTemp := GetMV("XX_RESTR03")
			If Subs(cTemp,1,15) <> QUERYSD4->D4_COD .or. Subs(cTemp,16,2) <> Subs(Time(),1,2)
				If mv_mata300 == 1 .or. mv_ajuste == 1 // mv_mata300=reprocessa saldos inicio relat๓rio     mv_ajuste=Gera ajustes lotes/saldo fํsico
					If DtoS(Date()) <> '20181102'
						MsgRun("Reprocessando saldo antes do relat๓rio","Produto: " + QUERYSD4->D4_COD,{||U_UMATA300(QUERYSD4->D4_COD,QUERYSD4->D4_COD,cLocProcDom,cLocProcDom)})
					EndIf
				Else
					If mv_mata300 == 3 // Somente com P07, ou seja, precisa reprocessar saldo
						P07->( dbSetOrder(1) )
						If P07->( dbSeek( xFilial() + QUERYSD4->D4_COD + cLocProcDom ) )
							If DtoS(Date()) <> '20181102'
								MsgRun("Reprocessando saldo antes do relat๓rio","Produto: " + QUERYSD4->D4_COD,{||U_UMATA300(QUERYSD4->D4_COD,QUERYSD4->D4_COD,cLocProcDom,cLocProcDom)})
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf

			nSomaCalcOP := 0
			aLinha      := {}
			nEspacos    := 2
			aSldLote    := {}

			While !QUERYSD4->( EOF() )
				cLoteAtu    := Subs(QUERYSD4->D4_OP,1,8)

				SC2->( dbSetOrder(1) )
				If !SC2->( dbSeek( xFilial() + QUERYSD4->D4_OP) )
					cLinha := "ERRO! OP NรO ENCONTRADA NO SC2 " + QUERYSD4->D4_OP
				EndIf

				cLinha := QUERYSD4->D4_COD     + Space(nEspacos)
				cLinha += QUERYSD4->D4_OP      + Space(nEspacos)
				cLinha += DtoC(SC2->C2_DATRF)  + Space(nEspacos)
				cLinha += Transform(QUERYSD4->D4_QTDEORI  ,"@E 999,999.9999") + Space(nEspacos)
				cLinha += Transform(QUERYSD4->ZE_QTDORI   ,"@E 999,999.9999") + Space(nEspacos)
				cLinha += Transform(QUERYSD4->D4_QUANT    ,"@E 999,999.9999") + Space(nEspacos)
				cLinha += Transform(QUERYSD4->ZE_SALDO    ,"@E 999,999.9999") + Space(nEspacos)

				cLinha += Transform(QUERYSD4->D3PAGOP     ,"@E 999,999.9999") + Space(nEspacos)

				cLinha += Transform(QUERYSD4->SD5OK       ,"@E 999,999.9999") + Space(nEspacos)

				cLinha += Transform(QUERYSD4->D3CONSUMOOP ,"@E 999,999.9999") + Space(nEspacos)

				cLinha += Transform(QUERYSD4->SD5ERRO     ,"@E 999,999.9999") + Space(nEspacos)

				// Perda de Fornecedor
				//cLinha += Transform(nPagPerFor          ,"@E 999,999.9999") + Space(nEspacos)

				nSldCalcOP := QUERYSD4->D3PAGOP - (QUERYSD4->SD5OK + QUERYSD4->SD5ERRO) - (QUERYSD4->ZE_QTDORI - QUERYSD4->ZE_SALDO)

				//Saldo Calculado da OP
				cLinha += Transform(nSldCalcOP            ,"@E 999,999.9999") + Space(nEspacos)


				//Saldo usado para ajuste da OP
				If nSldCalcOP < 0 .or. !Empty(SC2->C2_DATRF)
					nSldCalcOP := 0
				EndIf

			/**/cLinha += Transform(nSldCalcOP        ,"@E 999,999.9999") + Space(nEspacos)

				nB8_SALDO := 0
				SB8->( dbSetOrder(3) )
				If SB8->( dbSeek( xFilial() + QSB1->B1_COD + cLocProcDom + cLoteAtu  ) )
					nB8_SALDO := SB8->B8_SALDO
				EndIf

			/**/cLinha += Transform(nB8_SALDO             ,"@E 999,999.9999") + Space(nEspacos)

				N := aScan(aSldLote,{|aVet| aVet[1] == QSB1->B1_COD .and. aVet[2] == cLoteAtu })
				If N == 0
					AADD(aSldLote,{QSB1->B1_COD,cLoteAtu,nSldCalcOP,nB8_SALDO})
				Else
					aSldLote[N,3] += nSldCalcOP
				EndIf

				If (nSldCalcOP < 0) .or. (nSldCalcOP > QUERYSD4->D4_QUANT)
				/**/cLinha += "ERRO" + Space(nEspacos)
					lERROProd := .T.
					If mv_1_erro == 1 .and. mv_mata300 == 2
						mv_mata300 := 1
						lSkipSB1 := .F.
						Exit
					EndIf
				Else
					If QUERYSD4->D3CONSUMOOP <> (QUERYSD4->SD5OK+QUERYSD4->SD5ERRO)
					/**/cLinha += "ERRO" + Space(nEspacos)
						lERROProd := .T.
						If mv_1_erro == 1 .and. mv_mata300 == 2
							mv_mata300 := 1
							lSkipSB1 := .F.
							Exit
						EndIf
					EndIf
				EndIf

				If nSldCalcOP > 0
					nSomaCalcOP += nSldCalcOP
				EndIf



				//   ###  SKIP()    ###
				QUERYSD4->( dbSkip() )

				// Depois do Skip, testa se mudou de lote para poder comparar se o saldo do lote estแ correto e se nใo estiver, colocar um "erro" no final da linha (CLINHA)
				If !("ERRO" $ cLinha)
					If Subs(QUERYSD4->D4_OP,1,8) <> cLoteAtu
						N := aScan(aSldLote,{|aVet| aVet[1] == QSB1->B1_COD .and. aVet[2] == cLoteAtu })
						If aSldLote[N,3] <> aSldLote[N,4]
							cLinha += "ERRO" + Space(3)
							If mv_ajuste == 1  // Gera ajustes por lote
								cLinha += "LOTE AJUSTADO"
							EndIf
							lERROProd := .T.
							If mv_1_erro == 1 .and. mv_mata300 == 2
								mv_mata300 := 1
								lSkipSB1 := .F.
								Exit
							EndIf
						EndIf
					EndIf
				EndIf

				If mv_sosaldo == 2   // Somente OPs com saldo
					AADD(aLinha, cLinha)
					AADD(aLinha, '')
				Else
					If !Empty(nB8_SALDO) .or. !Empty(nSldCalcOP)
						AADD(aLinha, cLinha)
						AADD(aLinha, '')
					EndIf
				EndIf
			End   // End do While do !QUERYSD4->( EOF() )


			SB8->( dbSetOrder(3) )
			lRecalcFim := .F.
			If SB8->( dbSeek( xFilial() + QSB1->B1_COD + cLocProcDom  ) )
				While !SB8->( EOF() ) .and. SB8->B8_PRODUTO == QSB1->B1_COD .and. SB8->B8_LOCAL == cLocProcDom
					If SB8->B8_SALDO <> 0
						naScan := aScan(aSldLote,{|aVet| aVet[1] == SB8->B8_PRODUTO .and. Alltrim(aVet[2]) == Alltrim(SB8->B8_LOTECTL) })
						If naScan == 0
							cLinha := "Produto: " + SB8->B8_PRODUTO + " Local: " + SB8->B8_LOCAL + " Lote: " + SB8->B8_LOTECTL + " Saldo: " + Transform(SB8->B8_SALDO,"@E 999,999,999.9999")
							If mv_ajuste == 1 // Gera ajustes por lote e recalcula saldo = sim
								If SB8->B8_SALDO < 0
									UDEVSD5(SB8->B8_PRODUTO, SB8->B8_LOCAL, SB8->B8_SALDO * (-1), SB8->B8_LOTECTL)
									cLinha += " LOTE AJUSTADO PARA ZERO"
									lERROProd  :=.T.
									lRecalcFim := .T.
								Else
									If QSB1->B1_TIPO <> 'PI' .and. QSB1->B1_TIPO <> 'PA'
										URECSD5(SB8->B8_PRODUTO, SB8->B8_LOCAL, SB8->B8_SALDO, SB8->B8_LOTECTL)
										cLinha += " LOTE AJUSTADO PARA ZERO"
										lERROProd  := .T.
										lRecalcFim := .T.
									Else
										cLinha += " LOTE NรO AJUSTADO PARA ZERO POR SE TRATAR DE UM " + QSB1->B1_TIPO
										nSomaCalcOP += SB8->B8_SALDO
									EndIf
								EndIf
							Else
								If SB8->B8_SALDO < 0 .and. mv_mata300 == 1
									UDEVSD5(SB8->B8_PRODUTO, SB8->B8_LOCAL, SB8->B8_SALDO * (-1), SB8->B8_LOTECTL)
									cLinha += " LOTE AJUSTADO PARA ZERO"
									lERROProd  := .T.
									lRecalcFim := .T.
								Else
									If QSB1->B1_TIPO <> 'PI' .and. QSB1->B1_TIPO <> 'PA'
										cLinha += " ERRO "
										lERROProd  := .T.
									Else
										cLinha += " SALDO DE " + QSB1->B1_TIPO
										nSomaCalcOP += SB8->B8_SALDO
									EndIf
								EndIf
							EndIf
							AADD(aLinha, cLinha)
						EndIf
					EndIf
					SB8->( dbSkip() )
				End
				AADD(aLinha, '')
			EndIf

			cLinha := "TOTAIS: "  + Space(92)

			SB2->( dbSeek( xFilial() + QSB1->B1_COD + cLocProcDom ) )

			cLinha += "SB2: " + Transform(SB2->B2_QATU  ,"@E 999,999.9999") + Space(nEspacos+6)

			nValorProd := 0
			If (SB2->B2_VATU1/SB2->B2_QATU) > 0
				nValorProd := (SB2->B2_VATU1/SB2->B2_QATU) * SB2->B2_QATU
			Else
				If SB2->B2_CM1 > 0
					nValorProd := SB2->B2_CM1 * SB2->B2_QATU
				Else

				EndIf
			EndIf

			cLinha += "Vlr: " + Transform(nValorProd,"@E 999,999,999.9999") + Space(nEspacos)
			nValorTOT += nValorProd

			cLinha += "Calc:  " + Transform(nSomaCalcOP  ,"@E 999,999.9999") + Space(nEspacos)

			nLoteTot := 0
			SB8->( dbSetOrder(3) )
			If SB8->( dbSeek( xFilial() + QSB1->B1_COD + cLocProcDom ) )
				While !SB8->( EOF() ) .and. SB8->B8_PRODUTO == QSB1->B1_COD .and. SB8->B8_LOCAL == cLocProcDom
					nLoteTot += SB8->B8_SALDO
					SB8->( dbSkip() )
				End
			EndIf


		/**/cLinha += Transform(nLoteTot  ,"@E 999,999.9999") + Space(nEspacos)

			If nSomaCalcOP <> SB2->B2_QATU .or. nLoteTot <> SB2->B2_QATU
				cLinha  += "Diferen็a (B2<>Calc):" + Transform(SB2->B2_QATU - nSomaCalcOP,"@E 999,999.9999") + "  ERRO"
				If (SB2->B2_QATU - nSomaCalcOP) > 0
					cValDif += (SB2->B2_QATU - nSomaCalcOP) * SB2->B2_CM1
				EndIf
				lERROProd  :=.T.
			EndIf

			If nLoteTot <> SB2->B2_QATU
				cLinha  += "Diferen็a (B2<>B8):" + Transform(SB2->B2_QATU - nLoteTot,"@E 999,999.9999") + "  ERRO"
				If (SB2->B2_QATU - nLoteTot) > 0
					cValDif += (SB2->B2_QATU - nLoteTot) * SB2->B2_CM1
				EndIf
				lERROProd  :=.T.
			EndIf

			If mv_sosaldo == 1
				lVazio := .T.
				For x := 1 to Len(aLinha)
					If !Empty(aLinha[x])
						lVazio := .F.
						Exit
					EndIf
				Next x
			Else
				lVazio := .F.
			EndIf

			If !lVazio
				AADD(aLinha, cLinha)   // Adiciona a linha do total
				AADD(aLinha, '__PrtThinLine()' )
			Endif

			// Ajustes de quantidade
			// PROCESSA OS AJUSTES DE LOTE

			lRecalcB8 := .F.
			lRecalcB2 := .F.

			If mv_ajuste == 1   //  Se gera ajustes por lote

				For naSldLote := 1 to Len(aSldLote)
					nSldCalcOP   := Round(aSldLote[naSldLote,3],4)
					nSaldoLote   := Round(aSldLote[naSldLote,4],4)

					If nSaldoLote <> nSldCalcOP
						If nSaldoLote > nSldCalcOP
							URECSD5(aSldLote[naSldLote,1], cLocProcDom, nSaldoLote - nSldCalcOP, aSldLote[naSldLote,2])
							lRecalcB8 := .T.
						EndIf
						If nSldCalcOP > nSaldoLote
							UDEVSD5(aSldLote[naSldLote,1], cLocProcDom, nSldCalcOP - nSaldoLote, aSldLote[naSldLote,2])
							lRecalcB8 := .T.
						EndIf
					EndIf
				Next naSldLote
				aSldLote    := {}

				If nSomaCalcOP == nLoteTot .and. nLoteTot <> SB2->B2_QATU
					// se o lote bater com a quantidade calculada e for difernte do SB2, ajusta SB2 igual ao lote
					lRecalcB2 := fAjusteB2(QSB1->B1_COD, cLocProcDom, nLoteTot)
				EndIf

			EndIf

			If lRecalcB8 .or. lRecalcB2 .or. lRecalcFim
				MsgRun("Reprocessando saldo depois dos ajustes","Produto: " + QUERYSD4->D4_COD,{||U_UMATA300(QSB1->B1_COD,QSB1->B1_COD,cLocProcDom,cLocProcDom)})
				PutMV("XX_RESTR03",QUERYSD4->D4_COD + Time())
			EndIf

			If lSkipSB1
				If lERROProd .or. mv_so_erro == 2   // Somente produtos com erro
					For x := 1 to Len(aLinha)
						If nLin > 58
							Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
							nLin := 9
						EndIf
						If mv_lin_err == 2 .or. "ERRO" $ aLinha[x]
							If aLinha[x] <> '__PrtThinLine()'
								@ nLin, 000 pSay aLinha[x]
							Else
								@ nLin, 000 pSay __PrtThinLine()
							EndIf
							nLin++
						EndIf
					Next x

					If mv_1_erro == 1 .and. lErroProd  // mv_1_erro = Imprime at้ primeiro erro
						Return
					EndIf
				EndIf
			EndIf

			aLinha := {}

			nSomaCalcOP := 0
		EndIf

		If lSkipSB1
			QSB1->( dbSkip() )
		EndIf

		lSkipSB1 := .T.
	End

	If Select("QSB1") <> 0
		QSB1->( dbCloseArea() )
	EndIf

	If Select("QUERYSD4") <> 0
		QUERYSD4->( dbCloseArea() )
	EndIf

	If Select("TMP") <> 0
		TMP->( dbCloseArea() )
	EndIf

	If Select("TMP2") <> 0
		TMP2->( dbCloseArea() )
	EndIf

	If Select("TMP3") <> 0
		TMP3->( dbCloseArea() )
	EndIf

	If Select("TMP4") <> 0
		TMP4->( dbCloseArea() )
	EndIf

Return


Static Function UDEVSD5(cProduto, cLocal, nSaldo, cLote)

	Reclock("SD5",.T.)
	SD5->D5_FILIAL  := xFilial("SD5")
	SD5->D5_NUMSEQ  := ProxNum()
	SD5->D5_PRODUTO := cProduto
	SD5->D5_LOCAL   := cLocal
	SD5->D5_DOC     := '00002'
	SD5->D5_DATA    := If(dDataBase <= LastDay(dUlmes + 1),dDataBase,LastDay(dUlmes + 1))
	SD5->D5_ORIGLAN := '499'
	SD5->D5_QUANT   := nSaldo
	SD5->D5_LOTECTL := cLote
	SD5->D5_DTVALID := StoD("20491231")
	SD5->( msUnlock() )

Return .t.

//RECLOCK Retirada de lote do material
Static Function URECSD5(cProduto, cLocal, nSaldo, cLote)

	Reclock("SD5",.T.)
	SD5->D5_FILIAL  := xFilial("SD5")
	SD5->D5_NUMSEQ  := ProxNum()
	SD5->D5_PRODUTO := cProduto
	SD5->D5_LOCAL   := cLocal
	SD5->D5_DOC     := '00004'
	SD5->D5_DATA    := If(dDataBase <= LastDay(dUlmes + 1),dDataBase,LastDay(dUlmes + 1))
	SD5->D5_ORIGLAN := '999'
	SD5->D5_QUANT   := nSaldo
	SD5->D5_LOTECTL := cLote
	SD5->D5_DTVALID := StoD("20491231")
	SD5->( msUnlock() )

Return .t.

Static Function fAjusteB2(cProduto, cLocal, nQuant)
	Local _Retorno := .F.

	SB2->( dbSetOrder(1) )
	SB1->( dbSetOrder(1) )
	SB1->( dbSeek(xFilial() + cProduto) )
	If SB2->( dbSeek( xFilial() + cProduto + cLocal ) )
		If SB2->B2_QATU <> nQuant
			If SB2->B2_QATU > nQuant
				cNumSeq := ProxNum()

				Reclock("SD3",.T.)
				SD3->D3_FILIAL  := "01"
				SD3->D3_TM      := "509"
				SD3->D3_UM      := SB1->B1_UM
				SD3->D3_QUANT   := SB2->B2_QATU - nQuant
				SD3->D3_COD     := cProduto
				SD3->D3_CUSTO1  := SD3->D3_QUANT * SB2->B2_CM1
				SD3->D3_CF      := "RE0"
				SD3->D3_CONTA   := SB1->B1_CONTA
				SD3->D3_LOCAL   := cLocal
				SD3->D3_DOC     := "00006"
				SD3->D3_EMISSAO := If(dDataBase <= LastDay(dUlmes + 1),dDataBase,LastDay(dUlmes + 1))
				SD3->D3_GRUPO   := SB1->B1_GRUPO
				SD3->D3_NUMSEQ  := cNumSeq
				SD3->D3_SEGUM   := SB1->B1_SEGUM
				SD3->D3_TIPO    := SB1->B1_TIPO
				SD3->D3_USUARIO := Subs(cUsuario,7,15)
				SD3->D3_HORA    := Time()
				SD3->( msUnlock() )

				_Retorno := .T.
			EndIf
			If SB2->B2_QATU < nQuant
				cNumSeq := ProxNum()

				Reclock("SD3",.T.)
				SD3->D3_FILIAL  := "01"
				SD3->D3_TM      := "009"
				SD3->D3_UM      := SB1->B1_UM
				SD3->D3_QUANT   := nQuant - SB2->B2_QATU
				SD3->D3_COD     := cProduto
				SD3->D3_CUSTO1  := SD3->D3_QUANT * SB2->B2_CM1
				SD3->D3_CF      := "DE0"
				SD3->D3_CONTA   := SB1->B1_CONTA
				SD3->D3_LOCAL   := cLocal
				SD3->D3_DOC     := "00007"
				SD3->D3_EMISSAO := If(dDataBase <= LastDay(dUlmes + 1),dDataBase,LastDay(dUlmes + 1))
				SD3->D3_GRUPO   := SB1->B1_GRUPO
				SD3->D3_NUMSEQ  := cNumSeq
				SD3->D3_SEGUM   := SB1->B1_SEGUM
				SD3->D3_TIPO    := SB1->B1_TIPO
				SD3->D3_USUARIO := Subs(cUsuario,7,15)
				SD3->D3_HORA    := Time()
				SD3->( msUnlock() )

				_Retorno := .T.
			EndIf
		EndIf
	EndIf

Return _Retorno

Static Function fGravaParam()
	If mv_ate_pro == Repl('Z',15) .or. mv_ate_pro == Repl('z',15)
		aBkpPerg := {}

		//Chama pergunta ocultamente para alimentar variแveis
		Pergunte(cPerg,.F.,,,,,@aBkpPerg)

		//Altera conte๚do de alguma pergunta
		mv_par01 := QSB1->B1_COD

		//Carrega variแvel principal para que os parโmetros
		//definido acima sejam salvos na pr๓xima chamada
		SaveMVVars(.T.)

		__SaveParam(cPerg, aBkpPerg)
	EndIf

Return
