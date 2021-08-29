#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RETNET    �Autor  �Helio Ferreira      � Data �  24/04/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa criado para calcular o pre�o de venda a partir do ���
���          � pre�o NET (sem impostos)                                   ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function RetNet()

nPis    := GetMV("MV_TXPIS")
nCofins := GetMV("MV_TXCOF")

nPrcNet := TMP1->CK_XXNET
nTotImp := TMP1->CK_ICMS + nPis + nCofins

nPrcVen := nPrcNet / (1-(nTotImp/100))

Return nPrcVen
