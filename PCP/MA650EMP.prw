#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA650EMP  ºAutor  ³Michel Sander       º Data ³  06.04.17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada após a gravação dos empenhos              º±±
±±º          ³ para corrigir o lote do empenho a ser usado                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MA650EMP()

	Local aAreaGER := GetArea()
	LOCAL aAreaSD4 := SD4->(GetArea())
	Local aAreaSB1 := SB1->( GetArea() )
	Local aAreaSC6 := SC6->( GetArea() )
	Local aAreaSC2 := SC2->( GetArea() )
	Local aAreaSA1 := SA1->( GetArea() )

	LOCAL cFilOp   := SD4->D4_FILIAL
	LOCAL cEmpOp   := SD4->D4_OP
	//Osmar 05/05/20 -- Para gravar Custo, Margem e Preço Net no C2
	Local aCusto    := {}
	Local nCusMedio := 0
	Local cStatus   := 0
	Local nMargem   := GetMV("MV_XMARGEM")  //Percentual mínimo aceito como margem de lucro
	Local cQry      := ""
	Local nValor    := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona os empenhos para corrigir o número do lote conforme OP³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SDC->(dbSetOrder(2)) //DC_FILIAL, DC_PRODUTO, DC_LOCAL, DC_OP, DC_TRT, DC_LOTECTL, DC_NUMLOTE, DC_LOCALIZ, DC_NUMSERI, R_E_C_N_O_, D_E_L_E_T_
	SD4->(dbSetOrder(2))

	If .F.
		If SD4->(dbSeek(xFilial()+cEmpOp))

			Do While SD4->(!Eof()) .And. SD4->D4_FILIAL+SD4->D4_OP == cFilOp+cEmpOp

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Acerta empenhos apenas no almoxarifado de processo					³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If SD4->D4_LOCAL <> "97"
					SD4->(dbSkip())
					Loop
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Acerta o lote do empenho da OP											³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				Reclock("SD4",.F.)
				SD4->D4_LOTECTL := U_RetLotC6(SD4->D4_OP)
				SD4->D4_DTVALID := StoD("20491231")
				SD4->(MsUnlock())


				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Cria registro no empenho por Lote										³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !SDC->(dbSeek(SD4->D4_FILIAL+SD4->D4_COD+SD4->D4_LOCAL+SD4->D4_OP))
					Reclock("SDC", .T.)
				Else
					Reclock("SDC", .F.)
				EndIf

				SDC->DC_FILIAL  := SD4->D4_FILIAL
				SDC->DC_ORIGEM  := "SC2"
				SDC->DC_PRODUTO := SD4->D4_COD
				SDC->DC_LOCAL   := SD4->D4_LOCAL
				SDC->DC_LOCALIZ := "97PROCESSO"
				SDC->DC_LOTECTL := SD4->D4_LOTECTL
				SDC->DC_NUMLOTE := SD4->D4_NUMLOTE
				SDC->DC_QUANT   := SD4->D4_QUANT
				SDC->DC_QTDORIG := SD4->D4_QTDEORI
				SDC->DC_OP      := SD4->D4_OP
				SDC->DC_TRT     := SD4->D4_TRT
				SDC->DC_SEQ     := SD4->D4_SEQ
				SDC->(MsUnlock())

				SD4->(dbSkip())

			EndDo

		EndIf
	EndIf
// OK Vanessa Faio PE depois da gravação dos empenhos no Ok da janela de manutenção de empenhos abertura OP vedas/manual

	If GetMV("MV_XSEMAOP") == 'S'
		U_FNUMSEQ(__XXNumSeq)
		__XXNumSeq := ""
	EndIf


//Osmar 05/05/2020 -- Para gravar Custo, Margem e Preço Net no C2
	aCusto    := U_CustEmp(cEmpOp)
	nCusMedio := aCusto[1]
	cStatus   := aCusto[2]

	SC2->(dbSetOrder(1))
	If SC2->(dbSeek(xFilial()+cEmpOp))

		If SC2->C2_XCUSUNI <> nCusMedio .OR.  SC2->C2_XSTACUS <> cStatus
			RecLock("SC2",.F.)
			SC2->C2_XCUSUNI := nCusMedio
			SC2->C2_XSTACUS := cStatus
			SC2->( MsUnlock() )
		EndIf

		SC6->( dbSetOrder(1) )
		If SC6->( dbSeek( xFilial() + SC2->C2_PEDIDO + SC2->C2_ITEMPV ) )
			If !Empty(SC6->C6_XPRCNET)

				If SC2->C2_XPRCNET <> SC6->C6_XPRCNET .OR. (SC2->C2_XMARGEM <> ((SC6->C6_XPRCNET - SC2->C2_XCUSUNI) / SC2->C2_XCUSUNI) * 100)
					Reclock("SC2",.F.)
					SC2->C2_XPRCNET := SC6->C6_XPRCNET
					SC2->C2_XMARGEM := ((SC6->C6_XPRCNET - SC2->C2_XCUSUNI) / SC2->C2_XCUSUNI) * 100
					SC2->(msUnlock() )
				EndIf

				//Verifica último lançamento para o item e se esta igual não grava
				cQry := " Select Top 1 ZZF_ORIGEM, ZZF_NUMERO, ZZF_ITEM, ZZF_COD, ZZF_MARGEM As MARGEM "
				cQry += " From "+ RetSQLTab("ZZF") +" With(Nolock) "
				cQry += " Where D_E_L_E_T_ = '' And ZZF_ORIGEM = 'SC2' And ZZF_NUMERO = '"+SC2->C2_NUM+"' And "
				cQry += " 	    ZZF_ITEM = '"+SC2->C2_ITEM+"' And ZZF_COD = '"+SC2->C2_PRODUTO+"' "
				cQry += " Order By ZZF_ORIGEM, ZZF_NUMERO, ZZF_ITEM, ZZF_COD, R_E_C_N_O_ Desc "
				If Select("MAR") <> 0
					MAR->( dbCloseArea() )
				EndIf
				dbusearea(.t.,"TOPCONN",TCGenQRY(,,cQry),"MAR",.f.,.t.)
				nValor := MAR->MARGEM
				MAR->(dbCloseArea())
				If nValor <> SC2->C2_XMARGEM
					//Grava log de alteração da margem
					RecLock("ZZF",.t.)
					ZZF->ZZF_FILIAL := xFilial("ZZF")
					ZZF->ZZF_ORIGEM	:= "SC2"
					ZZF->ZZF_NUMERO	:= SC2->C2_NUM
					ZZF->ZZF_ITEM 	:= SC2->C2_ITEM
					ZZF->ZZF_COD    := SC2->C2_PRODUTO
					ZZF->ZZF_DATA   := dDataBase
					ZZF->ZZF_PRCVEN	:= SC6->C6_PRCVEN
					ZZF->ZZF_CUSUNI	:= SC2->C2_XCUSUNI
					ZZF->ZZF_STACUS	:= SC2->C2_XSTACUS
					ZZF->ZZF_PRCNET	:= SC2->C2_XPRCNET
					nMaxMargem := Val(Repl("9",TamSx3("ZZF_MARGEM")[1]-(TamSx3("ZZF_MARGEM")[2]+1)) + '.' + Repl("9",TamSx3("ZZF_MARGEM")[2]))
					If SC2->C2_XMARGEM < nMaxMargem
						ZZF->ZZF_MARGEM	:= SC2->C2_XMARGEM
					Else
						ZZF->ZZF_MARGEM	:= nMaxMargem
					EndIf
					ZZF->ZZF_OBS	:= "Inc - MA650EMP"
					ZZF->( MsUnLock() )
				EndIf
				//Chamado 025708 26/07/21 Vanessa Faio
				//If SC2->C2_XMARGEM > 0 .And. SC2->C2_XMARGEM < nMargem			
					//MsgInfo("A Margem de Contribuição deste item esta em "+Alltrim(Str(SC2->C2_XMARGEM))+"%"+Chr(13)+"e esta abaixo de "+AllTrim(Str(nMargem))+"% ","A T E N Ç Ã O")
					////_Retorno := .T.
				//EndIf
			EndIf
		EndIf
	EndIf


	// Processo de bloqueio de Ordens de Produção pelo CQ
	SB1->( dbSetOrder(1) )
	SD4->( dbSetOrder(2) )
	SA1->( dbSetOrder(1) )

	If SD4->( dbSeek( xFilial() + SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN ) )
		While !SD4->( EOF() ) .and. Alltrim(SD4->D4_OP) == Alltrim(SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN)
			If SB1->( dbSeek( xFilial() + SD4->D4_COD ) )
				If SB1->B1_XBLQOP == 'S'
					Reclock("SD4",.F.)
					SD4->D4_XBLQCQ := 'S'
					SD4->( msUnlock() )
					If SC2->C2_XBLQCQ <> 'S'
						Reclock("SC2",.F.)
						SC2->C2_XBLQCQ := 'S'
						SC2->C2_XTPBLQ := 'P'
						SC2->( msUnlock() )
					EndIf
				Else
					If !Empty(SC2->C2_CLIENT)
						If SA1->( dbSeek( xFilial() + SC2->C2_CLIENT ) )
							If SA1->A1_XBLQOP == 'S'
								Reclock("SD4",.F.)
								SD4->D4_XBLQCQ := 'S'
								SD4->( msUnlock() )
								If SC2->C2_XBLQCQ <> 'S'
									Reclock("SC2",.F.)
									SC2->C2_XBLQCQ := 'S'
									SC2->C2_XTPBLQ := 'C'
									SC2->( msUnlock() )
								EndIf
							Else
								If Empty(SC2->C2_XBLQCQ)
									Reclock("SC2",.F.)
									SC2->C2_XBLQCQ := 'N'
									SC2->( msUnlock() )
								EndIf
							EndIf
						EndIf
					Else
						If Empty(SC2->C2_XBLQCQ)
							Reclock("SC2",.F.)
							SC2->C2_XBLQCQ := 'N'
							SC2->( msUnlock() )
						EndIf
					EndIf
				EndIf
			EndIf
			SD4->( dbSkip() )
		End
	EndIf

	//MsgInfo("MA650EMP() - Depois da gravação dos empenhos (Ok janela empenhos) na abertura manual/vendas - Liberado o Semáforo Domex")
	RestArea(aAreaSA1)
	RestArea(aAreaSB1)
	RestArea(aAreaSC6)
	RestArea(aAreaSC2)
	RestArea(aAreaSD4)
	RestArea(aAreaGER)
Return
