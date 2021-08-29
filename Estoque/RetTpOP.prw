#include "totvs.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RETTPOP   �Autor  �Helio Ferreira      � Data �  23/07/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorno o B1_TIPO do produto da OP passada nos parametros  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Domex                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RetTpOP(_cOP)

Local _Retorno := ""
Local aAreaGER := GetArea()
Local aAreaSC2 := SC2->( GetArea() )
Local aAreaSB1 := SB1->( GetArea() )

SC2->( dbSetOrder(1) )
SB1->( dbSetOrder(1) )

If SC2->( dbSeek( xFilial() + _cOP ) )
   If SB1->( dbSeek( xFilial() + SC2->C2_PRODUTO ) )
      _Retorno := SB1->B1_TIPO
   EndIf
EndIf

RestArea(aAreaSB1)
RestArea(aAreaSC2)
RestArea(aAreaGER)

Return _Retorno