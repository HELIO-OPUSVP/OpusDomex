#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A250ITOK  �Autor  �Helio Ferreira      � Data �  29/10/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada no Tudo Ok de apontamento de OP mata250   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function A250ITOK()
Local _Retorno := .T.
/*
Local aAreaGER := GetArea()
Local aAreaSC2 := SC2->( GetArea() )

SC2->( dbSetOrder(1) )
SC2->( dbSeek( xFilial() + M->D3_OP ) )

_Retorno := U_VD3_QUANT()

If !_Retorno
   M->D3_QUANT := 0
EndIf

If _Retorno
   U_AGLUTSD4(M->D3_OP)
EndIf

RestArea(aAreaSC2)
RestArea(aAreaGER)
*/

Return _Retorno
