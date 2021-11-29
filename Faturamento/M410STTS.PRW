#Include "rwMake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M410STTS  ºAutor  ³Osmar Ferreira      º Data ³  14/04/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Ponto de entrada após alteração/inclusão/exclusão de PV   º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M410STTS()
	Local _nOper     := PARAMIXB[1]
	Local cOperacao  := ""
	Local cQry      := ""
	Local nMargem   := 0
	Local aAreaGeral := GetArea()
	Local aAreaSC6   := SC6->(GetArea())
	// Local aAreaSCK   := SCK->(GetArea())

	//Grava a data/hora de alteração no campo C6_ENTREG (Dt. Cliente)
	//Osmar Ferreira 13/04/21
	//SC6->( dbSetOrder(1) )
	//SC6->(dbSeek(xFilial()+SC5->C5_NUM))
	//While SC6->(!Eof()) .And. SC6->C6_NUM == SC5->C5_NUM
	//	If !Empty(SC6->C6_ENTREG)
	//		If Empty(SC6->C6_XDTCLI)
	//			RecLock("SC6",.f.)
	//			SC6->C6_XDTCLI := Date()
	//			SC6->C6_XHRCLI := Time()
	//			SC6->( msUnLock() )
	//		Endif
	//	EndIf
	//	SC6->( dbSkip() )
	//EndDo

	//Faz a analise de crédito do cliente e bloqueia o pedido caso seja necessário
	If (_nOper == 3)  .Or. (_nOper == 4)  //Inclusão / Alteração
		If SC5->C5_TIPO == 'N'
			//lLiberado := U_ValidPV(SC5->C5_NUM,.t.)
			If !U_ValidPV(SC5->C5_NUM,.t.)
				SC6->( dbSetOrder(1) )
				SC6->(dbSeek(xFilial()+SC5->C5_NUM))
				While SC6->(!Eof()) .And. SC6->C6_NUM == SC5->C5_NUM
					If (SC6->C6_BLQ <> "R") .And. (Empty(SC6->C6_NUMOP)) // SC6->C6_QTDENT = 0
						RecLock("SC6",.f.)
						SC6->C6_BLQ := "S"
						SC6->C6_XGERAOP := "2"
						SC6->( msUnLock() )
					EndIf
					SC6->( dbSkip() )
				EndDo
			EndIf
		EndIf
	EndIf

	If U_Validacao("OSMAR")
		//Verifica a margem de lucro e bloqueia caso necessário
		If (_nOper == 3) // .Or. (_nOper == 4)  //Inclusão / Alteração
			If SC5->C5_TIPO == 'N'
				If !U_VldMargem(.F.,.T.)
					SC6->( dbSetOrder(1) )
					SC6->(dbSeek(xFilial()+SC5->C5_NUM))
					While SC6->(!Eof()) .And. SC6->C6_NUM == SC5->C5_NUM
						If (SC6->C6_BLQ <> "R") .And. (Empty(SC6->C6_NUMOP)) // SC6->C6_QTDENT = 0
							//	RecLock("SC6",.f.)
							//	SC6->C6_BLQ := "S"
							//	SC6->C6_XGERAOP := "2"
							//	SC6->( msUnLock() )
						EndIf
						SC6->( dbSkip() )
					EndDo
				EndIf
			EndIf
		EndIf
	Endif




	If (_nOper == 3)  .Or. (_nOper == 4)  //Inclusão / Alteração
		If SC5->C5_TIPO == 'N'
			U_GrvPrNet(SC5->C5_NUM)

			If _nOper == 3
				cOperacao := "Inclusao"
			Else
				cOperacao := "Alteracao"
			EndIf

			//Grava log de alteração da margem
			SC6->( dbSetOrder(1) )
			SC6->(dbSeek(xFilial()+SC5->C5_NUM))
			While SC6->(!Eof()) .And. SC6->C6_NUM == SC5->C5_NUM

				//Verifica último lançamento para o item e se esta igual não grava
				cQry := " Select Top 1 ZZF_ORIGEM, ZZF_NUMERO, ZZF_ITEM, ZZF_COD, ZZF_MARGEM As MARGEM "
				cQry += " From "+ RetSQLTab("ZZF") +" With(Nolock) "
				cQry += " Where D_E_L_E_T_ = '' And ZZF_ORIGEM = 'SC6' And ZZF_NUMERO = '"+SC6->C6_NUM+"' And "
				cQry += " 	    ZZF_ITEM = '"+SC6->C6_ITEM+"' And ZZF_COD = '"+SC6->C6_PRODUTO+"' "
				cQry += " Order By ZZF_ORIGEM, ZZF_NUMERO, ZZF_ITEM, ZZF_COD, R_E_C_N_O_ Desc "
				If Select("MAR") <> 0
					MAR->( dbCloseArea() )
				EndIf
				dbusearea(.t.,"TOPCONN",TCGenQRY(,,cQry),"MAR",.f.,.t.)
				nMargem := MAR->MARGEM
				MAR->(dbCloseArea())
				If nMargem <> SC6->C6_XMARGEM
					RecLock("ZZF",.t.)
					ZZF->ZZF_FILIAL   := xFilial("ZZF")
					ZZF->ZZF_ORIGEM	:= "SC6"
					ZZF->ZZF_NUMERO	:= SC6->C6_NUM
					ZZF->ZZF_ITEM 	   := SC6->C6_ITEM
					ZZF->ZZF_COD      := SC6->C6_PRODUTO
					ZZF->ZZF_DATA     := dDataBase
					ZZF->ZZF_PRCVEN	:= SC6->C6_PRCVEN
					ZZF->ZZF_CUSUNI	:= SC6->C6_XCUSUNI
					ZZF->ZZF_STACUS	:= SC6->C6_XSTACUS
					ZZF->ZZF_PRCNET	:= SC6->C6_XPRCNET

					nMaxMargem := Val(Repl("9",TamSx3("ZZF_MARGEM")[1]-(TamSx3("ZZF_MARGEM")[2]+1)) + '.' + Repl("9",TamSx3("ZZF_MARGEM")[2]))
					If SC6->C6_XMARGEM < nMaxMargem
						ZZF->ZZF_MARGEM := SC6->C6_XMARGEM
					Else
						ZZF->ZZF_MARGEM := nMaxMargem
					EndIf

					//ZZF->ZZF_MARGEM	:= SC6->C6_XMARGEM
					ZZF->ZZF_OBS		:= cOperacao
					ZZF->( MsUnLock() )
				EndIf
				SC6->( dbSkip() )
			EndDo
		EndIf
	EndIf

	// RestArea(aAreaSCK)
	RestArea(aAreaSC6)
	RestArea(aAreaGeral)
Return Nil
