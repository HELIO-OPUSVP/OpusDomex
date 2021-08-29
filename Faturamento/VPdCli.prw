#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     ºAutor  ³Microsiga           º Data ³  09/28/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VPdCli()
	Local cPedido  := Alltrim(M->C5_ESP1)
	Local cCli     := Alltrim(M->C5_CLIENTE)
	Local cLj      := Alltrim(M->C5_LOJAENT)
	Local cUser    := SubStr(cUsuario,7,15)
	Local cMsg     := ""
	Local lRet     := .T.
	Local aAreaSC5 := SC5->(GetArea())
	Local cQuery   := ""
	Local cAlias   := "WRK"

	If M->C5_XPVTIPO == 'RT'
		Return lRet
	EndIf

	If Select("WRK") > 0
		WRK->(dbCloseArea())
	EndIf

	cQuery := " SELECT C5_NUM, C5_EMISSAO "
	cQuery += " FROM "+ RetSqlName("SC5")+" SC5 "
	cQuery += " WHERE C5_CLIENTE ='"+cCli+"' "
	cQuery += " AND C5_LOJACLI ='"+cLj+"' "
	cQuery += " AND C5_ESP1 ='"+cPedido+"' "
	cQuery += " AND D_E_L_E_T_ <> '*'
	TcQuery cQuery Alias "WRK" New
	TcSetField("WRK","C5_EMISSAO","D")

	DbSelectArea(cAlias)
	("WRK")->(DbGoTop())
	If !Eof()
		cMsg := "Sr (a) " +cUser+chr(13)
		cMsg += "Ja existe OF(S) no Sistema com este Numero de Pedido:"+chr(13)+chr(13)
		Do While !Eof()
			cMsg += "OF numero "+WRK->C5_NUM+" do dia "+DtoC(WRK->C5_EMISSAO)+chr(13)
			WRK->(Dbskip())
		EndDo
		//MsgAlert(cMsg,"Duplicidade de Pedido do Cliente")
		While ! MsgNoYes(cMsg,"Duplicidade de Pedido do Cliente")
		End

	EndIf


	If Select("WRK") > 0
		WRK->(dbCloseArea())
	EndIf

	RestArea(aAreaSC5)

Return lRet
