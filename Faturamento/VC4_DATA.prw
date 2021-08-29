#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VC4_DATA  �Autor  �Helio Ferreira      � Data �  07/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o do campo C4_DATA - Data de Previs�o de Vendas    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Domex                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function VC4_DATA()
Local _Retorno := .T.
dDataAtu := Date()

If Date() >= StoD("20170715")
   If Day(Date()) <= 10
      cDataLim := LastDay(Date())+1
   Else
      cDataLim := LastDay(LastDay(Date())+1)+1
   EndIf
Else
   cDataLim := Date() + 20
EndIf

If M->C4_DATA < cDataLim  //Date() + 20
   MsgStop("A data limite para a inclus�o de Previs�o de Vendas hoje dia " + DtoC(Date()) + " � " + DtoC(cDataLim) +".")
   _Retorno := .F.
EndIf

Return _Retorno



User Function VC4_DAT2()
Local _Retorno := DATE()
dDataAtu := Date()

If Day(Date()) <= 10
      cDataLim := LastDay(Date())+1
Else
      cDataLim := LastDay(LastDay(Date())+1)+1
EndIf

_Retorno:=cDataLim

Return _Retorno
