#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VC2_NPEDIDO�Autor  �Helio Ferreira     � Data �  04/07/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o do campo C2_NPEDIDO                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function VC2_NPEDIDO()

Local _Retorno := .F.
Local aAreaGER := GetArea()
Local aAreaSC6 := SC6->( GetArea() )

SC6->( dbSetOrder(1) )
If SC6->( dbSeek( xFilial() + M->C2_NPEDIDO ) )
	_Retorno := .T.
Else
	MsgStop("Numero de Pedido inv�lido.")
	_Retorno := .F.
EndIf

RestArea(aAreaSC6)
RestArea(aAreaGER)

Return _Retorno
