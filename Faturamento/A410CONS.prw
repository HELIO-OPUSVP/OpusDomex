#include "rwmake.ch"
#include "totvs.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A410CONS  �Autor  �Helio Ferreira      � Data �  24/02/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para adicionar bot�es na enchoice de      ���
���          � Pedidos de Vedas                                           ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function A410CONS()
Local _Retorno := {}

If ALTERA
   Aadd(_Retorno,{"UP_MDI",{|| U_FDEPARA()},"Inf.Etiquetas","Inf.Etiquetas"})
EndIf

Return _Retorno