#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO10    ºAutor  ³Microsiga           º Data ³  08/05/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VZE_PROD()
Local _Retorno      := .T.
Private cLocProcDom := GetMV("MV_XXLOCPR")

//If M->ZE_TIPO == 'P'
If !Empty(M->ZE_PRODUTO)
	If Empty(M->ZE_OP)
		Msgstop("Favor preencher a Ordem de Produção antes do produto.")
		_Retorno := .F.
		M->ZE_PRODUTO := Space(Len(M->ZE_PRODUTO))
	Else
		SD4->( dbSetOrder(2) )
		If SD4->( dbSeek( xFilial() + M->ZE_OP ) )
			lTemp := .F.
			While !SD4->( EOF() ) .and. Rtrim(SD4->D4_OP) == Rtrim(M->ZE_OP)
				If SD4->D4_COD == M->ZE_PRODUTO
					lTemp := .T.
					If SD4->D4_QTDEORI == SD4->D4_QUANT .and. SD4->D4_LOCAL <> GetMV("MV_LOCPROC")
						
						//cQuery := "SELECT SUM(D3_QUANT) AS SUMD3QTD FROM " + RetSqlName("SD3") + " WHERE D3_COD = '"+SD4->D4_COD+"' AND D3_XXOP = '"+SD4->D4_OP+"' AND D3_ESTORNO = '' AND D3_CF = 'DE4' AND D3_LOCAL = '"+GetMV("MV_XXLOCPR")+"' AND D_E_L_E_T_ = '' " // tratado
						//If Select("TEMP") <> 0
						//   TEMP->( dbCloseArea() )
						//EndIf
						//TCQUERY cQuery NEW ALIAS "TEMP"
						
						SD3->(DbOrderNickName("USUSD30001"))  // D3_FILIAL + D3_XXOP + D3_COD   tratado
						SUMD3QTD := 0
						
						If SD3->( dbSeek( xFilial() + SD4->D4_OP + SD4->D4_COD ) )
							While !SD3->( EOF() ) .and. SD4->D4_OP + SD4->D4_COD == SD3->D3_XXOP + SD3->D3_COD  // tratado
								If Empty(SD3->D3_ESTORNO) .and. SD3->D3_LOCAL == cLocProcDom
									If SD3->D3_CF == 'DE4'
										SUMD3QTD += SD3->D3_QUANT
									EndIf
									If SD3->D3_CF == 'RE4'
										SUMD3QTD -= SD3->D3_QUANT
									EndIf
								EndIf
								SD3->( dbSkip() )
							End
						EndIf
						
						If Empty(SUMD3QTD)
							MsgStop("Este produto ainda não foi pago para esta Ordem de Produção."+Chr(10)+"Não será possível apontar perda para este produto.")
							_Retorno := .F.
							M->ZE_PRODUTO := Space(Len(M->ZE_PRODUTO))
						EndIf
					EndIf
				EndIf
				SD4->( dbSkip() )
			End
			If !lTemp
				MsgStop("Produto não utlizado nesta Ordem de Produção.")
				_Retorno := .F.
				M->ZE_PRODUTO := Space(Len(M->ZE_PRODUTO))
			EndIf
		Else
			MsgStop("Produto não utilizado nesta Ordem de Produção.")
			_Retorno := .F.
			M->ZE_PRODUTO := Space(Len(M->ZE_PRODUTO))
		EndIf
	EndIf
EndIf

If _Retorno
	M->ZE_DESC := Posicione("SB1",1,xFilial("SB1")+M->ZE_PRODUTO,"B1_DESC")
Else
	M->ZE_DESC := Space(Len(M->ZE_DESC))
EndIf
//EndIf

Return _Retorno
