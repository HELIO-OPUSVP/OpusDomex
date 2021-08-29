#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VC2_ITEM() �Autor  �Helio Ferreira     � Data �  07/04/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o do campo C2_ITEM                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function VC2_ITEM()
Local _Retorno := .F.
Local aAreaGER := GetArea()
Local aAreaSC6 := SC6->( GetArea() )

If !Empty(M->C2_NPEDIDO)
	SC6->( dbSetOrder(1) )
	If SC6->( dbSeek( xFilial() + M->C2_NPEDIDO + M->C2_ITEM) )
		_Retorno := .T.
	Else
		MsgStop("Numero de Pedido + Item inv�lido.")
		_Retorno := .F.
	EndIf
EndIf

RestArea(aAreaSC6)
RestArea(aAreaGER)

Return _Retorno
