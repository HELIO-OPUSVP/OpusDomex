#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VZA_OP     �Autor  �Helio Ferreira     � Data �  05/08/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o do campo ZA_OP - Apontamento de perdas           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Domex                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function VZA_OP()
Local _Retorno := .T.

SC2->( dbSetOrder(1) )
If SC2->( dbSeek( xFilial() + M->ZA_OP ) )
   If SC2->C2_QUANT > SC2->C2_QUJE
      If Empty(SC2->C2_DATRF)
         M->ZA_PRODUTO := Space(len(M->ZA_PRODUTO))
         M->ZA_DESC    := Space(len(M->ZA_DESC))
         M->ZA_MOTIVO  := Space(len(M->ZA_MOTIVO))
         M->ZA_DESCPER := Space(len(M->ZA_DESCPER))
         M->ZA_SALDO   := 0
         M->ZA_QTDORI  := 0
      Else
         MsgStop("Ordem de Produ��o encerrada em " + DtoC(SC2->C2_DATRF) + ".")
         _Retorno := .F.
      EndIf
   Else
      MsgStop("Ordem de Produ��o encerrada." + Chr(10) + "S� � poss�vel apontar perdas para Ordens de Produ��o que n�o foram totalmente produzidas.")
      _Retorno := .F.
   EndIf
Else
   MsgStop("Ordem de Produ��o inv�lida.")
   _Retorno := .F.
EndIf

Return _Retorno
