#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IC4_DATA  �Autor  �Helio Ferreira      � Data �  04/07/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Inicialicador campo C4_DATA - Data de Previs�o de Vendas   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Domex                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function IC4_DATA()
Local _Retorno
Local dDataAtu := Date()

If Day(dDataAtu) <= 10
   _Retorno := LastDay(dDataAtu)+1
Else
   _Retorno := LastDay(LastDay(dDataAtu)+1)+1
EndIf

Return _Retorno
