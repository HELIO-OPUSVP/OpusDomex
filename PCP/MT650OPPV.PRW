/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT650OPPV ºAutor  ³Helio Ferreira      º Data ³  06/06/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada que roda depois de todas OPs serem        º±±
±±º          ³ abertas no botão de Vendas                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function MT650OPPV()

	Local aAreaGER := GetArea()
	LOCAL aAreaSD4 := SD4->(GetArea())
	Local aAreaSB1 := SB1->( GetArea() )
	Local aAreaSC6 := SC6->( GetArea() )
	Local aAreaSC2 := SC2->( GetArea() )
	Local aAreaSA1 := SA1->( GetArea() )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ponto de Entrada MT650PV, apos a geração da OP's.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//If (ExistBlock("MT650OPPV"))
	//	ExecBlock("MT650OPPV",.F.,.F.,{aPedOP,aPedOP1})
	//Endif

	// RETIRADO Vanessa Faio PE depois de todas OP serem abertas por Vendas
	//MsgInfo("MT650OPPV() - PE depois de todas as OPs serem abertas POR VENDAS")
	//If GetMV("MV_XSEMAOP") == 'S'
	//	U_FNUMSEQ(__XXNumSeq)
	//EndIf

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
