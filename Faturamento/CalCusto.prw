#Include "rwMake.ch"
#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CalCusto  ºAutor  ³Osmar Ferreira      º Data ³  05/06/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Recalcula o custo do produto após alteração da Estrutura   *±±
±±º          ³ e atualisa o Pedido de Venda aberto sem Ordem de Pordução  º±±
±±º          ³ Chamado pelo ponto de entrada A200GRVE.prw			      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CalCusto(cProduto)
	Local cQuery    := ""
	Local cQry      := ""
	Local nMargem   := 0
	Local nCusMedio := 0
	Local cStatus   := 0
	Local aCusto    := {}
	Local aAreaSC6  := SC6->( GetArea() )
	Local aAreaSB1  := SB1->( GetArea() )

	//Procurar PV aberto sem OP criada
	cQuery := "Select C6_NUM, C6_ITEM, C6_PRODUTO, C6_QTDVEN, C6_NUMOP, C6_QTDENT, C6_XCUSUNI "
	//cQuery += "		C2_NUM, C2_PRODUTO, C2_QUANT,  "
	cQuery += "From " + RetSqlName("SC6") + " SC6 With(Nolock) "
	//cQuery += "Left Outer Join SC2010 SC2 With(Nolock) On C6_PRODUTO = C2_PRODUTO And "
	//cQuery += "             C6_NUM = C2_PEDIDO And C6_ITEM = C2_ITEMPV And SC2.D_E_L_E_T_ = '' "
	cQuery += "Where C6_BLQ = '' And (C6_QTDENT < C6_QTDVEN) And C6_PRODUTO = '"+cProduto+"' And "
	cQuery += "C6_NUMOP = '' And SC6.D_E_L_E_T_ = '' " // And C2_PRODUTO Is Null "

	If Select("PVA")
		PVA->(dbCloseArea())
	EndIf

	dbusearea(.t.,"TOPCONN",TCGenQRY(,,cQuery),"PVA",.f.,.t.)

	SC6->( dbSetOrder(1) )
	If SC6->(dbSeek(xFilial()+PVA->C6_NUM+PVA->C6_ITEM+cProduto))
		//Recalcular o custo com a estrutura alterada
		aCusto    := U_RetCust(cProduto,'S')
		nCusMedio := aCusto[1]
		cStatus   := aCusto[2]

		//SCK->( dbSetOrder(1) )
		//SC6->( dbSetOrder(1) )
		While !PVA->(Eof())
			//SC6->( dbGoTo(PVA->R_E_C_N_O_) )

			If SC6->(dbSeek(xFilial()+PVA->C6_NUM+PVA->C6_ITEM+cProduto))
				//Tira a margem de lucro para produtos tipo serviço
				If U_Validacao("OSMAR",.T.)  //02/05/2022
					If SC6->C6_XCUSUNI <> nCusMedio .or. SC6->C6_XSTACUS <> cStatus .or. (SC6->C6_XMARGEM <> ((SC6->C6_XPRCNET - SC6->C6_XCUSUNI) / SC6->C6_XPRCNET) * 100)
						SB1->( dbSeek(xFilial()+cProduto) )
						RecLock("SC6",.F.)
						SC6->C6_XCUSUNI := nCusMedio
						SC6->C6_XSTACUS := cStatus
						If (SB1->B1_TIPO == "SI" .Or. SB1->B1_TIPO == "SV")
							SC6->C6_XMARGEM := 0
						Else
							SC6->C6_XMARGEM := ((SC6->C6_XPRCNET - SC6->C6_XCUSUNI) / SC6->C6_XPRCNET) * 100
						EndIf
						SC6->(msUnlock())
					EndIf
				Else
					If SC6->C6_XCUSUNI <> nCusMedio .or. SC6->C6_XSTACUS <> cStatus .or. (SC6->C6_XMARGEM <> ((SC6->C6_XPRCNET - SC6->C6_XCUSUNI) / SC6->C6_XPRCNET) * 100)
						RecLock("SC6",.F.)
						SC6->C6_XCUSUNI := nCusMedio
						SC6->C6_XSTACUS := cStatus
						SC6->C6_XMARGEM := ((SC6->C6_XPRCNET - SC6->C6_XCUSUNI) / SC6->C6_XPRCNET) * 100
						SC6->(msUnlock())
					EndIf
				EndIf

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
					ZZF->ZZF_FILIAL := xFilial("ZZF")
					ZZF->ZZF_ORIGEM	:= "SC6"
					ZZF->ZZF_NUMERO	:= SC6->C6_NUM
					ZZF->ZZF_ITEM 	:= SC6->C6_ITEM
					ZZF->ZZF_COD    := SC6->C6_PRODUTO
					ZZF->ZZF_DATA   := dDataBase
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
					ZZF->ZZF_OBS	:= "Estrutura"
					ZZF->( MsUnLock() )
				EndIf
			EndIf

			PVA->(dbSkip())
		EndDo

	EndIf

	PVA->( dbCloseArea() )
	RestArea(aAreaSB1)
	RestArea(aAreaSC6)
	//RestArea(aAreaSCK)
Return Nil
