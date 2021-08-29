#include "rwmake.ch"
#include "totvs.ch"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³MT410ALT  ºAutor  ³Helio Ferreira      º Data ³  16/06/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Roda depois da gravação do Pedido de Vendas                º±±
±±º          ³                                                            º±±
±±º          ³ Alterado para baixar a Previsão de Vendas                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT410ALT()

Local aAreaGER    := GetArea()
Local aAreaSC5    := SC5->( GetArea() )
Local aAreaSC6    := SC6->( GetArea() )
Local aAreaSA1    := SA1->( GetArea() )
Local _cESTADO    :=''
Local _cQR1       :=''
Local _cQR2       :=''

// Previsão de Vendas
SC6->( dbSetOrder(1) )
SC4->( dbSetOrder(3) )  // C4_FILIAL + C4_PRODUTO + C4_CNPJ + C4_DATA
SA1->( dbSetOrder(1) )

U_GRAVASZY()
U_DMX_C6ZY() // Ajusta Itens com C6_PRODUTO # ZY_PRODUTO

If SC5->C5_TIPO == 'N'
	If SC6->( dbSeek( xFilial() + SC5->C5_NUM ) )
		If SA1->( dbSeek( xFilial() + SC5->C5_CLIENTE + SC5->C5_LOJAENT ) )
			While !SC6->( EOF() ) .and. SC6->C6_NUM == SC5->C5_NUM
				If !Empty(SC6->C6_XXPREVI)
					If SC4->( dbSeek( xFilial() + SC6->C6_XXPREVI + Subs(SA1->A1_CGC,1,8) + Space(6) + DtoS(SC6->C6_XXPREDT) ) )
						If Empty(SC6->C6_XXPREQT)
							Reclock("SC4",.F.)
							SC4->C4_QUANT := If((SC4->C4_QUANT-SC6->C6_QTDVEN)>0,SC4->C4_QUANT-SC6->C6_QTDVEN,0)
							SC4->( msUnlock() )
							
							Reclock("SC6",.F.)
							SC6->C6_XXPREQT := SC6->C6_QTDVEN
							SC6->( msUnlock() )
						Else
							Reclock("SC4",.F.)
							SC4->C4_QUANT += SC6->C6_XXPREQT
							SC4->C4_QUANT := If((SC4->C4_QUANT-SC6->C6_QTDVEN)>0,SC4->C4_QUANT-SC6->C6_QTDVEN,0)
							SC4->( msUnlock() )
							
							Reclock("SC6",.F.)
							SC6->C6_XXPREQT := SC6->C6_QTDVEN
							SC6->( msUnlock() )
						EndIf
					Else
						//						MsgStop("Previsão de Vendas não encontrada para o produto " + Alltrim(SC6->C6_XXPREVI) + " na data " + CtoD(SC6->C6_XXPREDT) + ".")
						//MsgStop("Previsão de Vendas não encontrada para o produto item " + SC6->C6_ITEM + " produto " + Alltrim(SC6->C6_XXPREVI) + " na data " + Dtoc(SC6->C6_XXPREDT) + ".")
					EndIf
				EndIf
				SC6->( dbSkip() )
			End
		EndIf
	EndIf
EndIf

_cESTADO := POSICIONE('SA1',1,xFILIAL('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_EST')
//MSGALERT(_cESTADO)

IF _cESTADO=='EX'
	If MsgYesNo("Sincronizar Pedido de Venda SIGAFAT X SIGAEEC ?")
		_cQR1:=" UPDATE EE7010 SET D_E_L_E_T_='*',R_E_C_D_E_L_=R_E_C_N_O_ WHERE EE7_PEDIDO='EXP00000000000"+ALLTRIM(SC5->C5_NUM)+"' "
		_cQR2:=" UPDATE EE8010 SET D_E_L_E_T_='*',R_E_C_D_E_L_=R_E_C_N_O_ WHERE EE8_PEDIDO='EXP00000000000"+ALLTRIM(SC5->C5_NUM)+"' "
		TCSQLEXEC(_cQR1)
		TCSQLEXEC(_cQR2)
		
		U_IMPPVEXP()
	ENDIF
ENDIF



RestArea(aAreaSA1)
RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aAreaGER)

Return
