#include "Totvs.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO7     บAutor  ณMicrosiga           บ Data ณ  01/25/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ATUCHAMA()
	Local cQuery
	Local aAreaGER := GetArea()

//cQuery := "SELECT Z4_CODIGO FROM " + RetSqlName("SZ4") + " WHERE Z4_CHAMADO <> '' AND Z4_DTFIM <> '' AND (Z4_DTRETCH = '' OR Z4_DTRETCH='20190101') AND D_E_L_E_T_ = '' "

//MLS TESTE SINCRONISMO ----------------------
	cQuery := "SELECT  Z4_CODIGO FROM " + RetSqlName("SZ4") + " "
	cQuery += " WHERE   Z4_CHAMADO <> '' AND Z4_DTRETCH='' "
	cQuery += " AND D_E_L_E_T_='' AND   Z4_RETCHAM<>'' " // AND Z4_DTCAD>='20210101'  " ///// AND Z4_LINHA='## RETORNO CONS' AND Z4_CHAMADO='023825' "
	cQuery += " ORDER BY SZ4010.Z4_CHAMADO "
//--------------------------------------------

	If Select("QSZ4") <> 0
		QSZ4->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS "QSZ4"

	SZ4->( dbSetOrder(1) )
	SZJ->( dbSetOrder(1) )

	If !QSZ4->( EOF() )
		While !QSZ4->( EOF() )
			//MsgInfo("Query retorno algum registro")
			If SZ4->( dbSeek( xFilial() + QSZ4->Z4_CODIGO ) )
				//MsgInfo("Achou o projeto no SZ4")
				If SZJ->( dbSeek( xFilial() + SZ4->Z4_CHAMADO ) )
					If SZJ->ZJ_STATUS <> 'F'  //  Se o chamado nใo estiver finalizado
						//MsgInfo("Enctrou o chamado " + SZ4->Z4_CHAMADO )

						Reclock("SZK",.T.)
						SZK->ZK_FILIAL  := xFilial("SZK")
						SZK->ZK_NUMCHAM := SZJ->ZJ_NUMCHAM
						SZK->ZK_NUMINTE := fZKITEM(SZJ->ZJ_NUMCHAM)
						SZK->ZK_DT_INC  := Date()
						SZK->ZK_HR_INC  := Time()
						SZK->ZK_ORIGEM  := "S"
						SZK->ZK_COD_ORI := "000000"  //__cUserID
						SZK->ZK_NOMEORI := UsrRetName("000000")
						SZK->ZK_DESCRIC := SZ4->Z4_RETCHAM
						SZK->( msUnlock() )

						//MsgInfo("Depois da inclusใo do registro no SZK " + SZK->ZK_NUMCHAM + " " + SZK->ZK_NUMINTE)

						Reclock("SZ4",.F.)
						SZ4->Z4_DTRETCH := SZK->ZK_DT_INC
						SZ4->Z4_HRRETCH := SZK->ZK_HR_INC
						SZ4->( msUnlock() )

						//MsgInfo("Z4_DTRETCH " + DtoC(SZ4->Z4_DTRETCH) )

						RecLock("SZJ",.F.)
						//SZJ->ZJ_STATUS := 'F' // P=Chamado Novo;A=Em Atendimento;F=Fechado
						SZJ->ZJ_SITUAC := 'S'   // Situa็ใo (T-Aguardando Tecnico;S=Aguardando Solicitante;R=Resolvido;C=Cancelado)
						SZJ->ZJ_QTDINTE:= SZK->ZK_NUMINTE
						SZJ->( msUnlock() )

					Else
						Reclock("SZ4",.F.)
						SZ4->Z4_DTRETCH := Date()
						SZ4->Z4_HRRETCH := Time()
						SZ4->( msUnlock() )
					EndIf
					U_fEnviaWf(SZJ->ZJ_NUMCHAM)
				EndIf
			EndIf
			QSZ4->( dbSkip() )
		End
	Else
		//MsgInfo("Nใo encontrou nenhum registro no SZ4 para tratar.")
	EndIf

	If Select("QSZ4") <> 0
		QSZ4->( dbCloseArea() )
	EndIf

	RestArea(aAreaGER)

Return

Static Function fZKITEM(cChamado)
	Local _Retorno := "001"

	cQuery := "SELECT MAX(ZK_NUMINTE) AS MAX_ITEM FROM " + RetSqlName("SZK") + " WHERE ZK_NUMCHAM = '"+cChamado+"' AND D_E_L_E_T_ = '' "

	If Select("QUERYSZK") <> 0
		QUERYSZK->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS "QUERYSZK"

	_Retorno := StrZero(Val(QUERYSZK->MAX_ITEM)+1,3)

Return _Retorno
