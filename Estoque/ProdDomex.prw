#include "rwmake.ch"
#include "totvs.ch"
#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO10    ºAutor  ³Hélio Ferreira      º Data ³  27/10/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Apontamento de produção totalmente personalizado para a    º±±
±±º          ³ Domex. Deve ser usado temporariamente, até se resolver     º±±
±±º          ³ a questão de demora do apontamento padrão                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ProdDomex(aVetOP)

	Local aAreaGER
	Local aAreaSC2
	Local cOP
	Local cTM
	Local cLocal
	Local cProduto
	Local nQuant
	Local _Retorno  := {}
	Local lRet      := .T.
	Local cMensagem := ""
	Local aEmpenhos := {}
	Local aOPs      := {}
	Local x, y
	Local aInsuficientes := {}
	Local aNecessidades := {}
	Local cNumSeq
	Local cD3Nivel
	//Local nP05_SOMA := 0
	//Local lSaldo    := .T.
	//Local lAptDl7 := ISINCALLSTACK('U_DOMETDL7') //Se está chamando da Tela de embalagem

	Default aVetOP := {}

	U_RpcSetEnv()

	If Empty(aVetOP)
		//Aadd(aVetOP,{"D3_OP     " , "79033 02001"	        , NIL })
		//Aadd(aVetOP,{"D3_TM     " , "010"	                 , NIL })
		//Aadd(aVetOP,{"D3_LOCAL  " , "13"           		  , NIL })
		//Aadd(aVetOP,{"D3_COD    " , "16484324931500 "      , NIL })
		//Aadd(aVetOP,{"D3_QUANT  " , 1	                    , NIL })
		//Aadd(aVetOP,{"D3_XXPECA"  , ""                     , NIL })

		//Aadd(aVetOP,{"D3_OP     " , "78545 10001"	        , NIL })
		//Aadd(aVetOP,{"D3_TM     " , "010"	                 , NIL })
		//Aadd(aVetOP,{"D3_LOCAL  " , "13"           	     , NIL })
		//Aadd(aVetOP,{"D3_COD    " , "DMXFLMDL0L0400H"      , NIL })
		//Aadd(aVetOP,{"D3_QUANT  " , 5                      , NIL })
		//Aadd(aVetOP,{"D3_XXPECA"  , ""                     , NIL })

		//Aadd(aVetOP,{"D3_OP     " , "79516 01001"          , NIL })
		//Aadd(aVetOP,{"D3_TM     " , "010"	                 , NIL })
		//Aadd(aVetOP,{"D3_LOCAL  " , "13"           		  , NIL })
		//Aadd(aVetOP,{"D3_COD    " , "DMXFLMSL5L5400 "      , NIL })
		//Aadd(aVetOP,{"D3_QUANT  " , 1                      , NIL })
		//Aadd(aVetOP,{"D3_XXPECA"  , ""                     , NIL })

		Aadd(aVetOP,{"D3_OP     " , "99907 03001"          , NIL })
		Aadd(aVetOP,{"D3_TM     " , "010"	               , NIL })
		Aadd(aVetOP,{"D3_LOCAL  " , "13"           		   , NIL })
		Aadd(aVetOP,{"D3_COD    " , "PJ1E600Z5101K56"      , NIL })
		Aadd(aVetOP,{"D3_QUANT  " , 1                      , NIL })
		Aadd(aVetOP,{"D3_XXPECA"  , "000009104635 "        , NIL })

	EndIf

	cOP      := aVetOP[aScan(aVetOP,{|aVet| Alltrim(aVet[1]) == "D3_OP"    }),2]
	cTM      := aVetOP[aScan(aVetOP,{|aVet| Alltrim(aVet[1]) == "D3_TM"    }),2]
	cLocal   := aVetOP[aScan(aVetOP,{|aVet| Alltrim(aVet[1]) == "D3_LOCAL" }),2]
	cProduto := aVetOP[aScan(aVetOP,{|aVet| Alltrim(aVet[1]) == "D3_COD"   }),2]
	nQuant   := aVetOP[aScan(aVetOP,{|aVet| Alltrim(aVet[1]) == "D3_QUANT" }),2]
	cXXPeca  := aVetOP[aScan(aVetOP,{|aVet| Alltrim(aVet[1]) == "D3_XXPECA"}),2]
	cOP      := Subs(cOp,1,11)

	//U_RPCSETENV()

	If U_VALIDACAO("HELIO")
		StartJob("U_FC2_QUJE",getenvserver(), .F. , cOP)
	EndIf

	aAreaGER := GetArea()
	aAreaSC2 := SC2->( GetArea() )

	AADD(aOps,{cOP,nQuant,cLocal})

	SC2->( dbSetOrder(1) )
	SD4->( dbSetOrder(2) )  // Filial + OP + Produto + Local

	nIndice := 0
	lTotal := .F.
	If SC2->( dbSeek( xFilial() + cOP ) )

		nIndice := nQuant/SC2->C2_QUANT
		nQtdOPPai := SC2->C2_QUANT

		If (nQuant + SC2->C2_QUJE) > SC2->C2_QUANT
			lRet := .F.
			cMensagem := "Quantidade superior ao saldo da OP"
		Else
			If (nQuant + SC2->C2_QUJE) == SC2->C2_QUANT
				lTotal := .T.
			EndIf
		EndIf
	Else
		lRet := .F.
		cMensagem := "OP " + aOPs[x] + " inválida"
	EndIf

	If lRet
		x     := 1
		While x <= Len(aOPs)
			//If SC2->( dbSeek( xFilial() + aOPs[x,1] ) )
			If SD4->( dbSeek( xFilial() + aOPs[x,1] ) )
				While !SD4->( EOF() ) .and. Subs(SD4->D4_OP,1,11) == aOPs[x,1]
					If !Empty(SD4->D4_OPORIG)
						If SC2->( dbSeek( xFilial() + Subs(SD4->D4_OPORIG,1,11) ) )
							If SB1->( dbSeek( xFilial() + SC2->C2_PRODUTO ) )
								If aScan(aOPs,{ |aVet| aVet[1] == Subs(SD4->D4_OPORIG,1,11) } ) == 0
									If SB1->B1_XKITPIG <> 'S' .or. !GetMv("MV_XVERKIT")
										If lTotal
											AADD(aOPs,{Subs(SD4->D4_OPORIG,1,11),SD4->D4_QUANT,SD4->D4_LOCAL})
										Else
											If SC2->C2_QUANT == nQtdOPPai
												nQtdPI := nQuant
											Else
												nQtdPI := SD4->D4_QTDEORI * nIndice
											EndIf

											If nQtdPI > (SC2->C2_QUANT - SC2->C2_QUJE)
												nQtdPI := (SC2->C2_QUANT - SC2->C2_QUJE)
											EndIf

											If nQtdPI > 0
												AADD(aOPs,{Subs(SD4->D4_OPORIG,1,11),nQtdPI ,SD4->D4_LOCAL })
											EndIf
										EndIf
										//---------------------------------------------------
										IF Subs(SD4->D4_OP,1,08)=='10696605' //' 10288401001'//'10118720001'//'10151501001' //   '10224404001'
											//
										ELSE
											x := 0 //mls , LINHA RETIRADA EM 02122020 PARA APONATAR OP E DEPOIS VOLTAR
										ENDIF //MLS
										//---------------------------------------------------
										//x := 0 //mls , LINHA RETIRADA EM 02122020 PARA APONATAR OP E DEPOIS VOLTAR
										Exit
									EndIf
								EndIf
							EndIf
						Else
							AADD(_Retorno,.F.)
							AADD(_Retorno,"OP do D4_OPORIG " + SD4->D4_OPORIG + " não encontrada no SC2")
							Return _Retorno
						EndIf
					EndIf
					SD4->( dbSkip() )
				End
			EndIf
			x++
		End

		aSort( aOPs,,, { |x,y| x[1] > y[1] } )

		/*
		For x := 1 to Len(aOPs)
		For y := (x+1) to Len(aOPs)
		If x <> y
		If aOPs[x,1] < aOPs[y,1]
		cTemp1 := aClone(aOPs[y,1]) // Op
		cTemp2 := aClone(aOPs[y,2]) // Quant
		cTemp3 := aClone(aOPs[y,3]) // Local

		aOPs[y,1] := aClone(aOPs[x,1])
		aOPs[y,2] := aClone(aOPs[x,2])
		aOPs[y,3] := aClone(aOPs[x,3])

		aOPs[x,1] := cTemp1
		aOPs[x,2] := cTemp2
		aOPs[x,3] := cTemp3
		EndIf
		EndIf
		Next y
		Next x
		*/
		// Montanto do array dos consumos por empenho
		For x := 1 to Len(aOps)
			If SC2->( dbSeek( xFilial() + aOps[x,1] ) )
				//               TM   Produto          Qtd.       OP         Local
				AADD( aEmpenhos, {cTM, SC2->C2_PRODUTO, aOps[x,2], aOps[x,1], aOps[x,3] } )

				If SD4->( dbSeek( xFilial() + aOps[x,1] ) )
					While !SD4->( EOF() ) .and. Subs(SD4->D4_OP,1,11) == aOps[x,1]
						//If Empty(SD4->D4_OPORIG)
						If lTotal .or. SD4->D4_LOCAL <> '96'
							nQtdEmp := 0
							If lTotal
								nQtdEmp := SD4->D4_QUANT
							Else
								nQtdEmp := (SD4->D4_QTDEORI * nIndice)
							EndIf

							//Se o Apontamento Veio da Tela de Embalagens DOMETDL7 e Possui Mão de obra do Corte
							//não deve apontar a mão-de-obra, apenas o produto, os demais produtos aponta normalmente.
							//If lAptDl7
							If Alltrim(SD4->D4_COD) <> "50010100CORTE"
								//               TM    Produto      Qtd.       OP           Local
								AADD( aEmpenhos,{'999', SD4->D4_COD, nQtdEmp ,  aOps[x,1] , SD4->D4_LOCAL  } )
							EndIf
							//Else
							//               TM    Produto      Qtd.       OP           Local
							//	AADD( aEmpenhos,{'999', SD4->D4_COD, nQtdEmp ,  aOps[x,1] , SD4->D4_LOCAL  } )
							//EndIf
							//EndIf
						EndIf
						SD4->( dbSkip() )
					End
				EndIf
			EndIf
		Next x

		// Calculando o total de necessidades
		For x := 1 to Len(aEmpenhos)
			If aEmpenhos[x,1] == '999'
				//                                        produto                         Local
				nPos := aScan(aNecessidades,{|aVet| aVet[1] == aEmpenhos[x,2] .and. aVet[2] == aEmpenhos[x,5] })
				If nPos == 0
					AADD(aNecessidades, {aEmpenhos[x,2], aEmpenhos[x,5], aEmpenhos[x,3]  })
				Else
					aNecessidades[nPos,3] += aEmpenhos[x,3]
				EndIf
			EndIf
		Next x
		/* jonas desabilitado em 24/08 para passar na vd3_quant
		// Valindando as necessidades com os saldos em estoque
		SB2->( dbSetOrder(1) )
		For x := 1 to Len(aNecessidades)
			//                            Produto              Local
			If SB2->( dbSeek( xFilial() + aNecessidades[x,1] + aNecessidades[x,2] ) ) .and. aNecessidades[x,2]=="99"

				nP05_SOMA := 0

				cQuery := " SELECT SUM(CAST(RIGHT(RTRIM(P05_SOMA), LEN(RTRIM(P05_SOMA))-PATINDEX('%-%',P05_SOMA)) AS DECIMAL(10,5) )) AS SOMA_P05 FROM P05010 (NOLOCK) WHERE P05_FILIAL='01' AND D_E_L_E_T_='' AND  P05_CAMPO='B2_QATU' AND P05_PRODUT='"+aNecessidades[x,1]+"' AND P05_LOCAL='99' "

				If Select("TMPP05") <> 0
					TMPP05->( dbCloseArea() )
				EndIf

				TCQUERY cQuery NEW ALIAS TMPP05

				If TMPP05->(!EOF())
					If TMPP05->SOMA_P05 > 0
						nP05_SOMA := TMPP05->SOMA_P05
					EndIf
				EndIf

				//nP05_SOMA := 0
				//If aNecessidades[x,2] == '99'
				//	If P05->( dbSeek() )
				//		While P05
				//         nP05_SOMA -= P05->SOMA
				//		End
				//	EndIf
				//EndIf

				//Acumular aqui a somatoria do p05

				If (SB2->B2_QATU - nP05_SOMA) < aNecessidades[x,3] //(SB2->B2_QATU ) < aNecessidades[x,3]
					AADD(aInsuficientes,{SB2->B2_COD, SB2->B2_LOCAL, SB2->B2_QATU, aNecessidades[x,3]})
				EndIf

			  //EndIf
			ElseIf aNecessidades[x,2]=="99"
				AADD(aInsuficientes,{aNecessidades[x,1], aNecessidades[x,2], 0, aNecessidades[x,3]})
			EndIf
		Next x
		*/
	EndIf

	If Len(aInsuficientes) <> 0
		lRet := .f.  // Grava de Qualquer jeito
		cMensagem := "MP com saldo insuficiente:" + Chr(13)
		For x := 1 to Len(aInsuficientes)
			cMensagem += "Produto: "  + aInsuficientes[x,1] + " Local " + aInsuficientes[x,2] + " Saldo " + Transform(aInsuficientes[x,3],"@E 999,999.9999") + " Necessidade " + Transform(aInsuficientes[x,4],"@E 999,999.9999") + Chr(13)
		Next x
	EndIf

	// Criando os registros no SD3,SD5,SDB
	//                         TM   Produto          Qtd.       OP         Local
	//			AADD( aEmpenhos, {cTM, SC2->C2_PRODUTO, aOps[x,2], aOps[x,1], aOps[x,3] } )
	If lRet  // Grava de qualquer jeito
		cNumSeq := ProxNum()
		cIdent  := ProxNum()

		SB1->( dbSetOrder(1) )
		SB2->( dbSetOrder(1) )
		SC2->( dbSetOrder(1) )

		For x := 1 to Len(aEmpenhos)
			If SB1->( dbSeek( xFilial() + aEmpenhos[x,2] ) )
				If SC2->( dbSeek( xFilial() + aEmpenhos[x,4] ) )
					If aEmpenhos[x,3] > 0 // Quantidade
						nCusto     := 0
						cPeca      := ""
						cNumIDOper := GetSx8Num('SDB','DB_IDOPERA'); ConfirmSX8()

						//////////////////////////////////////////////////////////////////////////////////////////////
						cChave := ""

						If aEmpenhos[x,1] == '999'
							cChave := "E0"
						Else
							cChave := "R0"
						EndIf

						//////////////////////////////////////////////////////////////////////////////////////////////
						cLocaliz   := ""
						If aEmpenhos[x,5] == "97"
							cLocaliz := "97PROCESSO"
						Else
							If aEmpenhos[x,5] == "13"
								cLocaliz := "13PRODUCAO"
							Else
								If aEmpenhos[x,5] == "99"
									cLocaliz := "99PROCESSO"
								Else
									If aEmpenhos[x,5] == "96"
										cLocaliz := "96PERDA"
									EndIf
								EndIf
							EndIf
						EndIf

						cLocaliz += Space(Len(SBF->BF_LOCALIZ)-Len(cLocaliz))

						//////////////////////////////////////////////////////////////////////////////////////////////
						nCusto := 0
						If SB2->( dbSeek( xFilial() + aEmpenhos[x,2] + aEmpenhos[x,5] ) )
							nCusto := SB2->B2_CM1 * aEmpenhos[x,3]
						EndIf

						//////////////////////////////////////////////////////////////////////////////////////////////
						cD3CF := ""
						cPeca := ""
						If aEmpenhos[x,1] == '999'
							If aEmpenhos[x,5] == '97'  // Local
								cD3CF := "RE1"
							Else
								If aEmpenhos[x,5] == '99'  // Local
									cD3CF := "RE2"
								Else
									If aEmpenhos[x,5] == '08'  // Local
										cD3CF := "RE1"
									EndIf
								EndIf
							EndIf
						Else
							If Alltrim(aEmpenhos[x,4]) == Alltrim(cOP)
								cD3CF := "PR0"
								cPeca := cXXPeca
							Else
								cD3CF := "PR1"
								cPeca := ""
							EndIf

						EndIf

						//////////////////////////////////////////////////////////////////////////////////////////////
						cD3Nivel   := ""
						cD3GARANTI := ""
						If cD3CF == "PR0"
							cD3Nivel := ""
							cD3GARANTI := "N"
						Else
							cD3Nivel := SC2->C2_NIVEL // StrZero(100-Val(Subs(aEmpenhos[x,4],9,3)),2)
						EndIf

						//////////////////////////////////////////////////////////////////////////////////////////////
						cD3PARCTOT := ""
						If cD3CF == "PR0"
							If lTotal
								cD3PARCTOT := "T"
							Else
								cD3PARCTOT := "P"
							EndIf
						EndIf


						//////////////////////////////////////////////////////////////////////////////////////////////
						If aEmpenhos[x,5] <> '99'
							cLoteCtl := U_RetLotC6(aEmpenhos[x,4])
						Else
							cLoteCtl := "LOTE1308  "
						EndIf

						//////////////////////////////////////////////////////////////////////////////////////////////
						If aEmpenhos[x,1] == '999'
							cSD4_D4_OP := aEmpenhos[x,4] + Space(Len(SD4->D4_OP)-Len(aEmpenhos[x,4]))
							//                       OP           Produto          Local
							If SD4->( dbSeek( xFilial() + cSD4_D4_OP + aEmpenhos[x,2] + aEmpenhos[x,5] ) )
								If SD4->D4_QUANT >= aEmpenhos[x,3]
									Reclock("SD4",.F.)
									SD4->D4_QUANT -= aEmpenhos[x,3]
									SD4->( msUnlock() )
								Else
									Reclock("SD4",.F.)
									SD4->D4_QUANT := 0
									SD4->( msUnlock() )
								EndIF
							EndIf
						EndIf

						Reclock("SD3",.T.)
						SD3->D3_FILIAL  := xFilial("SD3")
						SD3->D3_TM      := aEmpenhos[x,1]
						SD3->D3_UM      := SB1->B1_UM
						SD3->D3_QUANT   := aEmpenhos[x,3]
						SD3->D3_COD     := aEmpenhos[x,2]
						SD3->D3_CF      := cD3CF
						SD3->D3_CONTA   := SB1->B1_CONTA
						SD3->D3_OP      := aEmpenhos[x,4]
						SD3->D3_LOCAL   := aEmpenhos[x,5]
						SD3->D3_DOC     := cLoteCtl
						SD3->D3_EMISSAO := dDataBase
						SD3->D3_GRUPO   := SB1->B1_GRUPO
						SD3->D3_CUSTO1  := nCusto
						SD3->D3_PARCTOT := cD3PARCTOT
						SD3->D3_NUMSEQ  := cNumSeq
						SD3->D3_SEGUM   := SB1->B1_SEGUM
						SD3->D3_TIPO    := SB1->B1_TIPO
						SD3->D3_NIVEL   := cD3Nivel
						SD3->D3_USUARIO := Subs(cUsuario,7,15)
						SD3->D3_CHAVE   := cChave
						SD3->D3_IDENT   := cIdent
						SD3->D3_LOTECTL := cLoteCtl
						SD3->D3_DTVALID := StoD("20491231")
						SD3->D3_LOCALIZ := cLocaliz
						SD3->D3_HORA    := Time()
						SD3->D3_XXPECA  := cPeca
						SD3->D3_OBSERVA := "PRODDOMEX"
						SD3->D3_XLOTEOK := "A"
						SD3->D3_GARANTI := cD3GARANTI
						SD3->( msUnlock() )

						//U_CRIAP07(aEmpenhos[x,2],aEmpenhos[x,5])

						If cD3CF == 'PR0' .or. cD3CF == 'PR1'
							U_CRIAP07(aEmpenhos[x,2],aEmpenhos[x,5])
						Else
							Reclock("P05",.T.)
							P05->P05_FILIAL := xFilial("P05")
							P05->P05_ALIAS  := "SB2"
							P05->P05_INDICE := "1"
							P05->P05_CHAVE  := xFilial() + aEmpenhos[x,2] + aEmpenhos[x,5]
							P05->P05_CAMPO  := "B2_QEMP"
							P05->P05_TIPO   := "N"
							P05->P05_SOMA   := Alltrim(Str(aEmpenhos[x,3]*(-1)))
							P05->P05_DTINC  := dDataBase
							P05->P05_HRINC  := Time()
							P05->P05_PRODUT := aEmpenhos[x,2]
							P05->P05_LOCAL  := aEmpenhos[x,5]
							P05->( msUnlock() )

							Reclock("P05",.T.)
							P05->P05_FILIAL := xFilial("P05")
							P05->P05_ALIAS  := "SB2"
							P05->P05_INDICE := "1"
							P05->P05_CHAVE  := xFilial() + aEmpenhos[x,2] + aEmpenhos[x,5]
							P05->P05_CAMPO  := "B2_QATU"
							P05->P05_TIPO   := "N"
							P05->P05_SOMA   := Alltrim(Str(aEmpenhos[x,3]*(-1)))
							P05->P05_DTINC  := dDataBase
							P05->P05_HRINC  := Time()
							P05->P05_PRODUT := aEmpenhos[x,2]
							P05->P05_LOCAL  := aEmpenhos[x,5]
							P05->( msUnlock() )
						EndIf

						If SB1->B1_RASTRO == 'L'

							Reclock("SD5",.T.)
							SD5->D5_FILIAL  := xFilial("SD5")
							SD5->D5_NUMSEQ  := cNumSeq
							SD5->D5_PRODUTO := aEmpenhos[x,2]
							SD5->D5_LOCAL   := aEmpenhos[x,5]
							SD5->D5_DOC     := cLoteCtl
							SD5->D5_OP      := aEmpenhos[x,4]
							SD5->D5_DATA    := dDataBase
							SD5->D5_ORIGLAN := aEmpenhos[x,1]
							SD5->D5_QUANT   := aEmpenhos[x,3]
							SD5->D5_LOTECTL := cLoteCtl
							SD5->D5_DTVALID := StoD("20491231")
							SD5->D5_LOTEPRD := cLoteCtl
							SD5->D5_PRMAIOR := "N"
							SD5->D5_XLOTEOK := "A"
							SD5->( msUnlock() )

							//Reclock("P05",.T.)
							//P05->P05_FILIAL := "01"
							//P05->P05_ALIAS  := "SB8"
							//P05->P05_INDICE := "3"
							//P05->P05_CHAVE  := "01" + aEmpenhos[x,2] + aEmpenhos[x,5] + cLoteCtl
							//P05->P05_CAMPO  := "B8_SALDO"
							//P05->P05_TIPO   := "N"
							//P05->P05_SOMA   := Alltrim(Str(aEmpenhos[x,3]*(-1)))
							//P05->( msUnlock() )
						EndIf

						If SB1->B1_LOCALIZ == 'S'
							Reclock("SDB",.T.)
							SDB->DB_FILIAL  := xFilial("SDB")
							SDB->DB_ITEM    := "0001"
							SDB->DB_PRODUTO := aEmpenhos[x,2]
							SDB->DB_LOCAL   := aEmpenhos[x,5]
							SDB->DB_LOCALIZ := cLocaliz
							SDB->DB_DOC     := cLoteCtl
							SDB->DB_TM      := If(aEmpenhos[x,1] <= '499','499','999')   // TM
							SDB->DB_ORIGEM  := "SD3"
							SDB->DB_QUANT   := aEmpenhos[x,3]
							SDB->DB_DATA    := dDataBase
							SDB->DB_LOTECTL := cLoteCtl
							SDB->DB_NUMSEQ  := cNumSeq
							SDB->DB_TIPO    := "M"
							SDB->DB_SERVIC  := If(aEmpenhos[x,1] <= '499','499','999')   // TM
							SDB->DB_ATIVID  := 'ZZZ'
							SDB->DB_HRINI   := Time()
							SDB->DB_ATUEST  := "S"
							SDB->DB_STATUS  := "M"
							SDB->DB_ORDATIV := "ZZ"
							SDB->DB_IDOPERA := cNumIDOper
							SDB->DB_XLOTEOK := "A"
							SDB->( msUnlock() )

							//Reclock("P05",.T.)
							//P05->P05_FILIAL := xFilial("P05")
							//P05->P05_ALIAS  := "SBF"
							//P05->P05_INDICE := "1"
							//P05->P05_CHAVE  := "01" + aEmpenhos[x,5] + cLocaliz + aEmpenhos[x,2] + Space(Len(SBF->BF_NUMSERI)) + cLoteCtl
							//P05->P05_CAMPO  := "BF_QUANT"
							//P05->P05_TIPO   := "N"
							//P05->P05_SOMA   := Alltrim(Str(aEmpenhos[x,3]*(-1)))
							//P05->( msUnlock() )

							If cD3CF == "PR0" .or. cD3CF == "PR1"
								//If SC2->( dbSeek( "01" + aEmpenhos[x,4] ) )
								Reclock("SC2",.F.)
								SC2->C2_QUJE   += aEmpenhos[x,3]
								//SC2->C2_XXQUJE += aEmpenhos[x,3]    Retirado por Hélio em 25/09/18
								If SC2->C2_QUJE == SC2->C2_QUANT
									SC2->C2_DATRF := dDataBase
								EndIf
								SC2->( msUnlock() )
								//EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		Next x

	EndIf

	If U_VALIDACAO("HELIO")
		StartJob("U_FC2_QUJE",getenvserver(), .F. )
	EndIf

	RestArea(aAreaSC2)
	RestArea(aAreaGER)

	AADD(_Retorno,lRet)
	AADD(_Retorno,cMensagem)

Return _Retorno


User Function CRIAP07(___cProduto, ___cLocal,___lPrioridade)
	Local dData
	Loca cTime

	Default ___lPrioridade := .F.

	If ___lPrioridade
		dData := StoD('20170101')
		cTime := '00:00:00'
	Else
		dData := dDataBase
		cTime := Time()
	EndIf

	P07->( dbSetOrder(1) )
	If !P07->(dbSeek(xFilial("P07")+___cProduto+___cLocal))
		RecLock("P07",.T.)
		P07->P07_FILIAL := xFilial("P07")
		P07->P07_PRODUT := ___cProduto
		P07->P07_LOCAL	:= ___cLocal
		P07->P07_DATA   := dData
		P07->P07_HORA   := cTime
		P07->(MsUnlock())
	Else
		If P07->P07_DATA > Date() .or. P07->P07_HORA > Time() .or. ___lPrioridade
			RecLock("P07",.F.)
			P07->P07_DATA   := dData
			P07->P07_HORA   := cTime
			If !Empty(P07->P07_DATAIN)
				//If P07->P07_DATAIN <> CtoD('')
				P07->P07_DATAIN := CtoD('')
				P07->P07_HORAIN := ''
				//EndIf
			EndIf
			P07->(MsUnlock())
		EndIf
	EndIf

Return
