#Include "rwMake.ch"
#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  M415GRV   ºAutor  ³Osmar Ferreira      º Data ³  02/07/20  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Ponto de entrada após a gravação do Orçamento             º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M415GRV()
   Local _nOper    := PARAMIXB[1]
   Local cOperacao := ""
   Local cQry      := ""
   Local nMargem   := 0
   Local aAreaSCJ  := SCJ->(GetArea())
   Local aAreaSCK  := SCK->(GetArea())
   Local aAreaZZF  := ZZF->(GetArea())

   If (_nOper == 1)  .Or. (_nOper == 2)    //Inclusão / Alteração

      U_OrcPrNet(M->CJ_NUM)                //Calcula o preço Net para Orçamento

      If _nOper == 1
         cOperacao := "Inclusao"
      Else
         cOperacao := "Alteracao"
      EndIf

      //Grava log de alteração da margem
      SCK->( dbSetOrder(1) )
      SCK->(dbSeek(xFilial()+M->CJ_NUM))
      While SCK->(!Eof()) .And. SCK->CK_NUM == M->CJ_NUM
         //Verifica último lançamento para o item e se esta igual não grava
         cQry := " Select Top 1 ZZF_ORIGEM, ZZF_NUMERO, ZZF_ITEM, ZZF_COD, ZZF_MARGEM As MARGEM "
         cQry += " From "+ RetSQLTab("ZZF") +" With(Nolock) "
         cQry += " Where D_E_L_E_T_ = '' And ZZF_ORIGEM = 'SCK' And ZZF_NUMERO = '"+SCK->CK_NUM+"' And "
         cQry += " 	    ZZF_ITEM = '"+SCK->CK_ITEM+"' And ZZF_COD = '"+SCK->CK_PRODUTO+"' "
         cQry += " Order By ZZF_ORIGEM, ZZF_NUMERO, ZZF_ITEM, ZZF_COD, R_E_C_N_O_ Desc "
         If Select("MAR") <> 0
            MAR->( dbCloseArea() )
         EndIf
         dbusearea(.t.,"TOPCONN",TCGenQRY(,,cQry),"MAR",.f.,.t.)
         nMargem := MAR->MARGEM
         MAR->(dbCloseArea())
         If nMargem <> SCK->CK_XMARGEM
            RecLock("ZZF",.t.)
            ZZF->ZZF_FILIAL   := xFilial("ZZF")
            ZZF->ZZF_ORIGEM	:= "SCK"
            ZZF->ZZF_NUMERO	:= SCK->CK_NUM
            ZZF->ZZF_ITEM 	   := SCK->CK_ITEM
            ZZF->ZZF_COD      := SCK->CK_PRODUTO
            ZZF->ZZF_DATA     := dDataBase
            ZZF->ZZF_PRCVEN	:= SCK->CK_PRCVEN
            ZZF->ZZF_CUSUNI	:= SCK->CK_XCUSUNI
            ZZF->ZZF_STACUS	:= SCK->CK_XSTACUS
            ZZF->ZZF_PRCNET	:= SCK->CK_XPRCNET

		      nMaxMargem := Val(Repl("9",TamSx3("ZZF_MARGEM")[1]-(TamSx3("ZZF_MARGEM")[2]+1)) + '.' + Repl("9",TamSx3("ZZF_MARGEM")[2]))
				If SCK->CK_XMARGEM < nMaxMargem
				   ZZF->ZZF_MARGEM := SCK->CK_XMARGEM
				Else
				   ZZF->ZZF_MARGEM := nMaxMargem
				EndIf

            //ZZF->ZZF_MARGEM	:= SCK->CK_XMARGEM
            ZZF->ZZF_OBS		:= cOperacao
            ZZF->( MsUnLock() )
         EndIf
         SCK->( dbSkip() )
      EndDo
   EndIf

   RestArea(aAreaZZF)
   RestArea(aAreaSCK)
   RestArea(aAreaSCJ)

Return(Nil)
