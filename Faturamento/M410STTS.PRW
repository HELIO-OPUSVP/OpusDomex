
#Include "rwMake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M410STTS  �Autor  �Osmar Ferreira      � Data �  14/04/20   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada ap�s altera��o, inclus�o, exclus�o de PV  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function M410STTS()
	Local _nOper     := PARAMIXB[1]
	Local cOperacao  := ""
	Local cQry       := ""
	Local nMargem    := 0
	Local lAprov     := .t.
	Local nPerMargem := 0 //Percentual m�nimo aceito como margem de lucro
	Local aAreaGeral := GetArea()
	Local aAreaSC6   := SC6->(GetArea())
	Local aAreaSA1   := SA1->(GetArea())

	//Faz a analise de cr�dito do cliente e bloqueia o pedido caso seja necess�rio
	If (_nOper == 3)  .Or. (_nOper == 4)  //Inclus�o / Altera��o
		If SC5->C5_TIPO == 'N'
			//lLiberado := U_ValidPV(SC5->C5_NUM,.t.)
			If !U_ValidPV(SC5->C5_NUM,.t.) // Bloqueado pela analise de cr�dito do cliente
				SC6->( dbSetOrder(1) )
				SC6->(dbSeek(xFilial()+SC5->C5_NUM))
				While SC6->(!Eof()) .And. SC6->C6_NUM == SC5->C5_NUM
					If (SC6->C6_BLQ <> "R") .And. (Empty(SC6->C6_NUMOP)) // SC6->C6_QTDENT = 0
						RecLock("SC6",.f.)
						SC6->C6_BLQ := "S"
						SC6->C6_XGERAOP := "2"
						SC6->C6_XANEXO  := "C"
						SC6->( msUnLock() )
					EndIf
					SC6->( dbSkip() )
				EndDo
			Else	//Aprovado pela analise de cr�dito do cliente
				If U_Validacao("OSMAR",.T.) //09/02/2022
					SC6->( dbSetOrder(1) )
					SC6->(dbSeek(xFilial()+SC5->C5_NUM))
					While SC6->(!Eof()) .And. SC6->C6_NUM == SC5->C5_NUM
						If (SC6->C6_BLQ <> "R") .And. (Empty(SC6->C6_NUMOP)) // SC6->C6_QTDENT = 0
							RecLock("SC6",.f.)
							If SC6->C6_XANEXO == "C"
								SC6->C6_XANEXO := ""
							EndIf
							SC6->( msUnLock() )
						EndIf
						SC6->( dbSkip() )
					EndDo
				EndIf
			EndIf
		EndIf
	EndIf

	If U_Validacao("OSMAR",.T.) //09/02/2022
		If SC5->C5_EMISSAO >= SToD('20220125')  //Bloqueia os pedidos a partir de 25/01/2022
			If (_nOper == 3) .Or. (_nOper == 4)  //Inclus�o / Altera��o
				If SC5->C5_TIPO == 'N'
					SC6->( dbSetOrder(1) )
					SC6->(dbSeek(xFilial()+SC5->C5_NUM))
					If SC6->C6_XANEXO <> "C"  //N�o esta bloqueado pela analise de cr�dito do cliente
						//Verifica a margem de lucro e bloqueia caso necess�rio
						If U_VldMarge(.F.,.T.)  //Margem dentro dos parametros
							SC6->( dbSetOrder(1) )
							SC6->(dbSeek(xFilial()+SC5->C5_NUM))
							While SC6->(!Eof()) .And. SC6->C6_NUM == SC5->C5_NUM
								If (SC6->C6_BLQ <> "R") .And. (Empty(SC6->C6_NUMOP)) // SC6->C6_QTDENT = 0
									RecLock("SC6",.f.)
									SC6->C6_BLQ := "N"
									SC6->C6_XANEXO := "L"
									SC6->( msUnLock() )
								EndIf
								SC6->( dbSkip() )
							EndDo

						Else  //Margem fora dos parametros
							SC6->( dbSetOrder(1) )
							SC6->(dbSeek(xFilial()+SC5->C5_NUM))
							If SC6->C6_XANEXO <> "A" //N�o esta liberado pela adm vendas
								While SC6->(!Eof()) .And. SC6->C6_NUM == SC5->C5_NUM
									If (SC6->C6_BLQ <> "R") .And. (Empty(SC6->C6_NUMOP)) // SC6->C6_QTDENT = 0
										RecLock("SC6",.f.)
										SC6->C6_BLQ := "S"
										SC6->C6_XGERAOP := "2"
										SC6->C6_XANEXO := "B"
										SC6->( msUnLock() )
									EndIf
									SC6->( dbSkip() )
								EndDo
							Else
								If SC6->C6_XANEXO == "A"
									lAprov := .t.

									SA1->(dbSetOrder(01))
									SA1->( dbSeek(xFilial()+M->C5_CLIENTE+M->C5_LOJACLI) )
									If SA1->A1_XMARGEM > 0
										nPerMargem := SA1->A1_XMARGEM
									Else
										nPerMargem := GetMV("MV_XMARGEM")
									Endif

									While SC6->(!Eof()) .And. SC6->C6_NUM == SC5->C5_NUM
										If ZZF->( dbSeek(xFilial()+"BLQ"+SC6->C6_NUM+SC6->C6_ITEM))
											If SC6->C6_XMARGEM < ZZF->ZZF_MARGEM
												lAprov := .f.
											EndIf
										Else
											//Item novo ver a margem novamente
											If SC6->C6_XMARGEM < nPerMargem
												lAprov := .f.
											EndIf
										EndIf
										SC6->( dbSkip() )
									EndDo
									If !lAprov  //Bloquear tudo
										SC6->( dbSetOrder(1) )
										SC6->(dbSeek(xFilial()+SC5->C5_NUM))
										While SC6->(!Eof()) .And. SC6->C6_NUM == SC5->C5_NUM
											If (SC6->C6_BLQ <> "R") .And. (Empty(SC6->C6_NUMOP)) // SC6->C6_QTDENT = 0
												RecLock("SC6",.f.)
												SC6->C6_BLQ := "S"
												SC6->C6_XGERAOP := "2"
												SC6->C6_XANEXO := "B"
												SC6->( msUnLock() )
											EndIf
											SC6->( dbSkip() )
										EndDo
									Else
										SC6->( dbSetOrder(1) )
										SC6->(dbSeek(xFilial()+SC5->C5_NUM))
										While SC6->(!Eof()) .And. SC6->C6_NUM == SC5->C5_NUM
											If (SC6->C6_BLQ <> "R") .And. (Empty(SC6->C6_NUMOP)) // SC6->C6_QTDENT = 0
												RecLock("SC6",.f.)
												SC6->C6_BLQ := "N"
												//SC6->C6_XGERAOP := "2"
												SC6->C6_XANEXO := "A"
												SC6->( msUnLock() )
											EndIf
											SC6->( dbSkip() )
										EndDo
									EndIf
								EndIf
							EndIf //Bloqueio da margem de lucro
						EndIf //Bloqueio da analise de cr�dito
					EndIf
				EndIf
			Endif
		EndIf
	EndIf

	If (_nOper == 3)  .Or. (_nOper == 4)  //Inclus�o / Altera��o
		If SC5->C5_TIPO == 'N'
			U_GrvPrNet(SC5->C5_NUM)
		EndIf
	EndIf


	//If (_nOper == 3)  .Or. (_nOper == 4)  //Inclus�o / Altera��o
	//	If SC5->C5_TIPO == 'N'
	//		U_GrvPrNet(SC5->C5_NUM)
	//		If _nOper == 3
	//			cOperacao := "Inclusao"
	//		Else
	//			cOperacao := "Alteracao"
	//		EndIf
	//		//Grava log de altera��o da margem
	//		SC6->( dbSetOrder(1) )
	//		SC6->(dbSeek(xFilial()+SC5->C5_NUM))
	//		While SC6->(!Eof()) .And. SC6->C6_NUM == SC5->C5_NUM
	//			//Verifica �ltimo lan�amento para o item e se esta igual n�o grava
	//			cQry := " Select Top 1 ZZF_ORIGEM, ZZF_NUMERO, ZZF_ITEM, ZZF_COD, ZZF_MARGEM As MARGEM "
	//			cQry += " From "+ RetSQLTab("ZZF") +" With(Nolock) "
	//			cQry += " Where D_E_L_E_T_ = '' And ZZF_ORIGEM = 'SC6' And ZZF_NUMERO = '"+SC6->C6_NUM+"' And "
	//			cQry += " 	    ZZF_ITEM = '"+SC6->C6_ITEM+"' And ZZF_COD = '"+SC6->C6_PRODUTO+"' "
	//			cQry += " Order By ZZF_ORIGEM, ZZF_NUMERO, ZZF_ITEM, ZZF_COD, R_E_C_N_O_ Desc "
	//			If Select("MAR") <> 0
	//				MAR->( dbCloseArea() )
	//			EndIf
	//			dbusearea(.t.,"TOPCONN",TCGenQRY(,,cQry),"MAR",.f.,.t.)
	//			nMargem := MAR->MARGEM
	//			MAR->(dbCloseArea())
	//			If nMargem <> SC6->C6_XMARGEM
	//				RecLock("ZZF",.t.)
	//				ZZF->ZZF_FILIAL   := xFilial("ZZF")
	//				ZZF->ZZF_ORIGEM	:= "SC6"
	//				ZZF->ZZF_NUMERO	:= SC6->C6_NUM
	//				ZZF->ZZF_ITEM 	   := SC6->C6_ITEM
	//				ZZF->ZZF_COD      := SC6->C6_PRODUTO
	//				ZZF->ZZF_DATA     := dDataBase
	//				ZZF->ZZF_PRCVEN	:= SC6->C6_PRCVEN
	//				ZZF->ZZF_CUSUNI	:= SC6->C6_XCUSUNI
	//				ZZF->ZZF_STACUS	:= SC6->C6_XSTACUS
	//				ZZF->ZZF_PRCNET	:= SC6->C6_XPRCNET
	//				nMaxMargem := Val(Repl("9",TamSx3("ZZF_MARGEM")[1]-(TamSx3("ZZF_MARGEM")[2]+1)) + '.' + Repl("9",TamSx3("ZZF_MARGEM")[2]))
	//				If SC6->C6_XMARGEM < nMaxMargem
	//					ZZF->ZZF_MARGEM := SC6->C6_XMARGEM
	//				Else
	//					ZZF->ZZF_MARGEM := nMaxMargem
	//				EndIf
	//				//ZZF->ZZF_MARGEM	:= SC6->C6_XMARGEM
	//				ZZF->ZZF_OBS		:= cOperacao
	//				ZZF->( MsUnLock() )
	//			EndIf
	//			SC6->( dbSkip() )
	//		EndDo
	//	EndIf
	//EndIf
	RestArea(aAreaSA1)
	RestArea(aAreaSC6)
	RestArea(aAreaGeral)
Return Nil
