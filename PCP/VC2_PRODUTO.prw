#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VC2_PRODUTO�Autor  �Helio Ferreira     � Data �  18/03/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function VC2_PRODUTO()

Local _Retorno := .T.
Local aAreaGER := GetArea()
Local aAreaSC6 := SC6->( GetArea() )

//Return .t.

SC6->( dbSetOrder(1) )
If !Empty(M->C2_PEDIDO)
	If SC6->( dbSeek( xFilial() + M->C2_PEDIDO + M->C2_ITEMPV ) )
		If SC6->C6_PRODUTO <> M->C2_PRODUTO
		   MsgStop("Produto diferente do '"+Alltrim(SC6->C6_PRODUTO)+"' informado no Pedido de Vendas.")
		   _Retorno := .F.
		EndIf
	Else
	   MsgStop("Pedido de Vendas n�o encontrado.")
	EndIf
EndIf

RestArea(aAreaSC6)
RestArea(aAreaGER)

Return _Retorno
