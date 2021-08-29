#Include "rwMake.ch"
#Include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA650A   ºAutor  ³Osmar Ferreira      º Data ³  07/04/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Ponto de entrada que roda depois da gravação de todos     º±±
±±º          ³  registros na alteração de Orden de Produção               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MTA650A()
    Local nCusMedio  := 0
    Local cStatus    := ''
    Local aCustos    := {}
    Local aAreaSC2   := SC2->(GetArea())
    Local aAreaSC6   := SC6->(GetArea())
    Local nMargem    := GetMV("MV_XMARGEM")  //Percentual mínimo aceito como margem de lucro
    Local cQry       := ""
    Local nValor     := 0

    aCustos   := U_CustEmp(SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN)

    nCusMedio := aCustos[1]
    cStatus   := aCustos[2]

    If SC2->C2_XCUSUNI <> nCusMedio .OR.  SC2->C2_XSTACUS <> cStatus
        RecLock("SC2",.F.)
        SC2->C2_XCUSUNI := nCusMedio
        SC2->C2_XSTACUS := cStatus
        SC2->(MsUnlock())
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

                //ZZF->ZZF_MARGEM	:= SC2->C2_XMARGEM
                ZZF->ZZF_OBS		:= "Alt - MTA650A"
                ZZF->( MsUnLock() )
            EndIf
            //Chamado 025708 26/07/21 Vanessa Faio
            //If SC2->C2_XMARGEM > 0 .And. SC2->C2_XMARGEM < nMargem
            //    MsgInfo("A Margem de Contribuição deste item esta em "+Alltrim(Str(SC2->C2_XMARGEM))+"%"+Chr(13)+"e esta abaixo de "+AllTrim(Str(nMargem))+"% ","A T E N Ç Ã O")
            //    //_Retorno := .T.
            //EndIf
        EndIf
    EndIf

    RestArea(aAreaSC6)
    RestArea(aAreaSC2)

Return
