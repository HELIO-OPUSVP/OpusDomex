#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VZA_QTDORI ºAutor  ³Helio Ferreira     º Data ³  16/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VZE_QTDORI()
Local _Retorno := .T.
Local aAreaGER := GetArea()
Local aAreaSZE := SZA->( GetArea() )

If !Empty(M->ZE_QTDORI)
	If !Empty(M->ZE_PRODUTO)
		SD4->( dbSetOrder(1) )  // Filial + Produto + OP
		If SD4->( dbSeek( xFilial() + M->ZE_PRODUTO + M->ZE_OP) )
			If SD4->D4_LOCAL <> GetMV("MV_LOCPROC")
				
				nQtdPG := SD4->D4_QTDEORI - SD4->D4_QUANT
				
				cQuery := "SELECT SUM(D3_QUANT) AS SUMD3QTD FROM " + RetSqlName("SD3") + " WHERE D3_COD = '"+SD4->D4_COD+"' AND D3_XXOP = '"+SD4->D4_OP+"' AND D3_ESTORNO = '' AND D3_CF = 'DE4' AND D3_LOCAL = '"+GetMV("MV_XXLOCPR")+"' AND D_E_L_E_T_ = '' "
				
				If Select("TEMP") <> 0
					TEMP->( dbCloseArea() )
				EndIf
				
				TCQUERY cQuery NEW ALIAS "TEMP"
				
				nQtdPG += TEMP->SUMD3QTD
				
				SZE->( dbSetOrder(1) )
				nTotPerda := 0
				If SZE->( dbSeek( xFilial() + M->ZE_OP + M->ZE_PRODUTO ) )
					While !SZE->( EOF() ) .and. SZE->ZE_FILIAL == xFilial("SZE") .and. SZE->ZE_OP + SZE->ZE_PRODUTO == M->ZE_OP + M->ZE_PRODUTO
						nTotPerda += SZE->ZE_QTDORI
						nTotPerda -= (SZE->ZE_QTDORI - SZE->ZE_SALDO)
						SZE->( dbSkip() )
					End
				EndIf
				
				If M->ZE_QTDORI > (nQtdPG - nTotPerda)
					MsgStop("Quantidade maior que o total já entregue para esta OP.")
					_Retorno := .F.
				EndIf
			EndIf
		Else
			MsgStop("Produto não utilizado nesta ordem de Produção.")
			_Retorno := .F.
		EndIf
	Else
		MsgStop("Favor preencher o produto antes da quantidade da perda.")
		_Retorno     := .F.
		M->ZE_QTDORI := 0
	EndIf
EndIf

If _Retorno
	M->ZE_SALDO := M->ZE_QTDORI
Else
	M->ZE_SALDO := 0
EndIf

RestArea(aAreaSZE)
RestArea(aAreaGER)

Return _Retorno
