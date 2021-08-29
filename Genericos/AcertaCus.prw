#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "rwmake.ch"
#Include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACERTACUS ºAutor  ³Helio Ferreira      º Data ³  27/06/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa criado para validar e/ou corrigir problemas no    º±±
±±º          ³ custo médio Domex.                                         º±±
±±º          ³                                                            º±±
±±º          ³ Conceito dos campos do SC2                                 º±±
±±º          ³                                                            º±±
±±º          ³ C2_VINI1 - X3_DESC = Vlr.Inicial - Valor requisitado para  º±±
±±º          ³ a OP em períodos anteriores (Quando aponta a produção      º±±
±±º          ³ esse valor é apropriado para o PA).                        º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AcertaCus()

Processa({|lEnd| ProcRun()}, 'Acerto dos Custos...')

Return

Static Function ProcRun()

//If MsgYesNo('Deseja rodar os programas de validação (ANTES) e (do Custo Médio?')
If MsgYesNo('Deseja rodar a versão do programa ANTES do Custo Médio (1º Programa)?')
	U_AcertaVini()
EndIf

If MsgYesNo("Deseja rodar a rotina de Custo Médio (padrão)?")
	MATA330()  // Custo Médio
EndIf

If MsgYesNo('Deseja rodar a validação dos valores das OPs para o próximo período - Depois Custo Médio (2º Programa)? ')
	If Pergunte("ACERTACUS",.T.)
		
		MsgInfo("MV_ULMES = " + DtoC(GetMV("MV_ULMES")))
		
		MsgInfo("Data final do período para fechamento: " + DtoC(mv_par02) )
		
		If MsgYesNo("Deseja continuar?")
			
			cQuery := "SELECT COUNT(*) AS CONTA FROM (SELECT D3_OP AS CONTA FROM " + RetSqlName("SD3") + " (NOLOCK) WHERE D3_EMISSAO >= '"+DtoS(mv_par01)+"' AND D3_EMISSAO <= '"+DtoS(mv_par02)+"' AND D3_ESTORNO = '' AND D3_OP <> '' AND D_E_L_E_T_ = '' GROUP BY D3_OP) TMP  "
			
			If Select("CONTAGEM") <> 0
				CONTAGEM->(dbCloseArea())
			EndIf
			
			TCQUERY cQuery NEW ALIAS "CONTAGEM"
			
			ProcRegua(CONTAGEM->CONTA)
			
			cQuery := "SELECT D3_OP FROM " + RetSqlName("SD3") + " WHERE D3_EMISSAO >= '"+DtoS(mv_par01)+"' AND D3_EMISSAO <= '"+DtoS(mv_par02)+"' AND D3_ESTORNO = '' AND D3_OP <> '' AND D_E_L_E_T_ = '' GROUP BY D3_OP ORDER BY D3_OP "
			If Select("OPS") <> 0
				OPS->(dbCloseArea())
			EndIf
			TCQUERY cQuery NEW ALIAS "OPS"
			SC2->( dbSetOrder(1) )
			While !OPS->( EOF() )
				If SC2->( dbSeek( xFilial() + OPS->D3_OP ) )
					// Valor FINAL PARA apropriação
					C2VFIM1 := SC2->C2_VINI1
					cQuery := "SELECT D3_CUSTO1, D3_CF FROM " + RetSqlName("SD3") + " WHERE D3_EMISSAO >= '"+DtoS(mv_par01)+"' AND D3_EMISSAO <= '"+DtoS(mv_par02)+"' AND D3_CF IN ('RE0','RE1','DE0','DE1','PR0','PR1') AND D3_OP = '"+OPS->D3_OP+"' AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' ORDER BY D3_NUMSEQ, D3_CHAVE "
					If Select("VFIM") <> 0
						VFIM->(dbCloseArea())
					EndIf
					TCQUERY cQuery NEW ALIAS "VFIM"
					While !VFIM->( EOF() )
						If VFIM->D3_CF == 'RE0' .or. VFIM->D3_CF == 'RE1'
							C2VFIM1 += VFIM->D3_CUSTO1
						EndIf
						If VFIM->D3_CF == 'DE0' .or. VFIM->D3_CF == 'DE1'
							C2VFIM1 -= VFIM->D3_CUSTO1
						EndIf
						If VFIM->D3_CF == 'PR0' .or. VFIM->D3_CF == 'PR1'
							C2VFIM1 := 0
						EndIf
						VFIM->( dbSkip() )
					End
					
					If SC2->C2_VFIM1 <> C2VFIM1
						If mv_par03 == 1
							If !msgYesNo('Valor FINAL PARA apropriação errado para a OP: ' + OPS->D3_OP + Chr(13)+'Custo SC2->C2_VFIM1: ' + Transform(SC2->C2_VFIM1,'@E 999,999.99') + ' Custo SD3->D3_CUSTO1: ' + Transform(C2VFIM1,'@E 999,999.99')+chr(13)+'Continuar exibindo?')
								mv_par03 := 2
							EndIf
						EndIf
						If mv_par04 == 1
							Reclock("SC2",.F.)
							SC2->C2_VFIM1 := C2VFIM1
							SC2->( msUnlock() )
						EndIf
					EndIf
					
					/**/
					// Valor de Apropriação atual
					C2APRATU1 := 0
					cQuery := "SELECT SUM(D3_CUSTO1) AS SUM_D3_CUSTO1 FROM " + RetSqlName("SD3") + " WHERE D3_OP = '"+OPS->D3_OP+"' AND D3_TM > '500' AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "
					If Select("CUSOP")<>0;CUSOP->(dbCloseArea());EndIf
					TCQUERY cQuery NEW ALIAS "CUSOP"
					C2APRATU1 += CUSOP->SUM_D3_CUSTO1
					
					cQuery := "SELECT SUM(D3_CUSTO1) AS SUM_D3_CUSTO1 FROM " + RetSqlName("SD3") + " WHERE D3_OP = '"+OPS->D3_OP+"' AND D3_TM < '500' AND D3_CF <> 'PR0' AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "
					If Select("CUSOP")<>0;CUSOP->(dbCloseArea());EndIf
					TCQUERY cQuery NEW ALIAS "CUSOP"
					C2APRATU1 -= CUSOP->SUM_D3_CUSTO1
					
					If SC2->C2_APRATU1 <> C2APRATU1
						If mv_par03 == 1
							If !msgYesNo('Custo de apropriação atual errado para a OP: ' + OPS->D3_OP + Chr(13)+'Custo SC2->C2_APRATU1: ' + Transform(SC2->C2_APRATU1,'@E 999,999.99') + ' Custo SD3->D3_CUSTO1: ' + Transform(C2APRATU1,'@E 999,999.99')+chr(13)+'Continuar exibindo?')
								mv_par03 := 2
							EndIf
						EndIf
						If mv_par04 == 1
							Reclock("SC2",.F.)
							SC2->C2_APRATU1 := C2APRATU1
							SC2->( msUnlock() )
						EndIf
					EndIf
					
					// Valor de Apropriação final
					C2AprFim1 := 0
					cQuery := "SELECT SUM(D3_CUSTO1) AS SUM_D3_CUSTO1 FROM " + RetSqlName("SD3") + " WHERE D3_EMISSAO <= '"+DtoS(mv_par02)+"' AND D3_OP = '"+OPS->D3_OP+"' AND D3_TM > '500' AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "
					If Select("CUSOP")<>0;CUSOP->(dbCloseArea());EndIf
					TCQUERY cQuery NEW ALIAS "CUSOP"
					C2AprFim1 += CUSOP->SUM_D3_CUSTO1
					
					cQuery := "SELECT SUM(D3_CUSTO1) AS SUM_D3_CUSTO1 FROM " + RetSqlName("SD3") + " WHERE D3_EMISSAO <= '"+DtoS(mv_par02)+"' AND D3_OP = '"+OPS->D3_OP+"' AND D3_TM < '500' AND D3_CF <> 'PR0' AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "
					If Select("CUSOP")<>0;CUSOP->(dbCloseArea());EndIf
					TCQUERY cQuery NEW ALIAS "CUSOP"
					C2AprFim1 -= CUSOP->SUM_D3_CUSTO1
					
					If SC2->C2_APRFIM1 <> C2AprFim1
   					If mv_par03 == 1
							If !MsgYesNo('Custo FINAL de apropriação errado para a OP: ' + OPS->D3_OP + Chr(13)+'Custo SC2->C2_APRFIM1: ' + Transform(SC2->C2_APRFIM1,'@E 999,999.99') + ' Custo SD3->D3_CUSTO1: ' + Transform(C2AprFim1,'@E 999,999.99')+chr(13)+'Continuar exibindo?')
								mv_par03 := 2
							EndIf
						EndIf
						If mv_par04 == 1
							Reclock("SC2",.F.)
							SC2->C2_APRFIM1 := C2AprFim1
							SC2->( msUnlock() )
						EndIf
					EndIf
					
					// Valor atual PARA apropriação
					C2VATU1 := 0
					cQuery := "SELECT * FROM " + RetSqlName("SD3") + " WHERE D3_CF IN ('RE0','DE0','PR0') AND D3_OP = '"+OPS->D3_OP+"' AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' ORDER BY D3_NUMSEQ "
					If Select("VATU")<>0;VATU->(dbCloseArea());EndIf
					TCQUERY cQuery NEW ALIAS "VATU"
					While !VATU->( EOF() )
						If VATU->D3_CF == 'RE0'
							C2VATU1 += VATU->D3_CUSTO1
						EndIf
						If VATU->D3_CF == 'DE0'
							C2VATU1 -= VATU->D3_CUSTO1
						EndIf
						If VATU->D3_CF == 'PR0'
							C2VATU1 := 0
						EndIf
						VATU->( dbSkip() )
					End
					
					If SC2->C2_VATU1 <> C2VATU1
						If mv_par03 == 1
							If !msgYesNo('Valor atual PARA apropriação errado para a OP: ' + OPS->D3_OP + Chr(13)+'Custo SC2->C2_VATU1: ' + Transform(SC2->C2_VATU1,'@E 999,999.99') + ' Custo SD3->D3_CUSTO1: ' + Transform(C2VATU1,'@E 999,999.99')+chr(13)+'Continuar exibindo?')
								mv_par03 := 2
							EndIf        
						EndIf
						If mv_par04 == 1
							Reclock("SC2",.F.)
							SC2->C2_VATU1 := C2VATU1
							SC2->( msUnlock() )
						EndIf
					EndIf
					/**/
				Else
					msgStop('Op não encontrada no SC2: ' + OPS->D3_OP)
				EndIf
				IncProc()
				OPS->( dbSkip() )
			End
			
			MsgInfo('Conclusão da validação dos saldos das OPs')
		EndIf
	EndIf
	
	//If MsgYesNo('Deseja Validar os saldos dos produtos para transporte para o próximo período - Depois Custo Médio (3º Programa)?')
	
	cQuery := "SELECT COUNT(*) AS CONTA FROM " + RetSqlName("SB2") + " WHERE D_E_L_E_T_ = '' "
	
	If Select("CONTAGEM") <> 0
		CONTAGEM->(dbCloseArea())
	EndIf
	
	TCQUERY cQuery NEW ALIAS "CONTAGEM"
	
	ProcRegua(CONTAGEM->CONTA)
	
	SB2->( dbGoTop() )
	SB2->( dbSetOrder(1) )
	SB2->( dbSeek( xFilial() ) )
	While !SB2->( EOF() ) .and. SB2->B2_FILIAL == xFilial("SB2")
		aSaldoEst := CalcEst(SB2->B2_COD, SB2->B2_LOCAL, (mv_par02+1) )
		If aSaldoEst[1] <> SB2->B2_QFIM
			If mv_par03 == 1
				If !MsgYesNo('B2_QFIM errada para ' + SB2->B2_COD + ' ALMOX: ' + SB2->B2_LOCAL + Chr(13) + 'SB2->B2_QFIM = ' + Str(SB2->B2_QFIM) + ' CalcEst() = ' + Str(aSaldoEst[1])+Chr(13)+'Continuar exibindo?')
					mv_par03 := 2
				EndIf
			EndIf
			If mv_par04 == 1
				Reclock("SB2",.F.)
				SB2->B2_QFIM := Round(aSaldoEst[1],2)
				SB2->( msUnlock() )
			EndIf
		EndIf
		//cQuery := "SELECT SUM(B8_SALDO) AS SUM_B8_SALDO FROM " + RetSqlName("SB8") + " WHERE B8_PRODUTO = '"+SB2->B2_COD+"' AND B8_LOCAL = '"+SB2->B2_LOCAL+"' AND B8_SALDO <> 0 AND D_E_L_E_T_ = '' "
		//If Select("SALDOB8") <> 0
		//	SALDOB8->( dbCloseArea() )
		//EndIf
		//TCQUERY cQuery NEW ALIAS "SALDOB8"
		//If SALDOB8->SUM_B8_SALDO <> SB2->B2_QFIM
		//	If !MsgYesNo('B2_QFIM <> B8_SALDO para ' + SB2->B2_COD + ' ALMOX: ' + SB2->B2_LOCAL + Chr(13) + 'SB2->B2_QFIM = ' + Str(SB2->B2_QFIM) + ' SUM(B8_SALDO) = ' + Str(SALDOB8->B8_SALDO )+Chr(13)+'Continuar exibindo?')
		//		mv_par03 := 2
		//	EndIf
		//EndIf
		
		//aSaldo    := CalcEstL(cProduto, cLocal, dData,cLoteCtl,cLote,cLocaliza,cNumSerie)
		
		If aSaldoEst[2] <> SB2->B2_VFIM1
			If mv_par03 == 1
				If !MsgYesNo('B2_VFIM1 errada para ' + SB2->B2_COD + ' ALMOX: ' + SB2->B2_LOCAL + Chr(13) + 'SB2->B2_VFIM1 = ' + Str(SB2->B2_VFIM1) + ' CalcEst() = ' + Str(aSaldoEst[2] )+Chr(13)+'Continuar exibindo?')
               mv_par03 := 2
				EndIf
			EndIf
			If mv_par04 == 1
				Reclock("SB2",.F.)
				SB2->B2_VFIM1 := aSaldoEst[2]
				SB2->( msUnlock() )
			EndIf
		EndIf
		SB2->( dbSkip() )
		IncProc()
	End
	//EndIf
EndIf

msgAlert('Fim da execução do 2º programa de acerto do Custo Médio')
//EndIf

Return
