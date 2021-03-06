/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT650OPPV �Autor  �Helio Ferreira      � Data �  06/06/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada que roda depois de todas OPs serem        ���
���          � abertas no bot�o de Vendas                                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/


User Function MT650OPPV()

	Local aAreaGER := GetArea()
	LOCAL aAreaSD4 := SD4->(GetArea())
	Local aAreaSB1 := SB1->( GetArea() )
	Local aAreaSC6 := SC6->( GetArea() )
	Local aAreaSC2 := SC2->( GetArea() )
	Local aAreaSA1 := SA1->( GetArea() )

	//�������������������������������������������������Ŀ
	//�Ponto de Entrada MT650PV, apos a gera��o da OP's.�
	//���������������������������������������������������
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

	//MsgInfo("MA650EMP() - Depois da grava��o dos empenhos (Ok janela empenhos) na abertura manual/vendas - Liberado o Sem�foro Domex")
	RestArea(aAreaSA1)
	RestArea(aAreaSB1)
	RestArea(aAreaSC6)
	RestArea(aAreaSC2)
	RestArea(aAreaSD4)
	RestArea(aAreaGER)

Return
