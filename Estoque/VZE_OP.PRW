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

User Function VZE_OP()
Local _Retorno := .T.

SC2->( dbSetOrder(1) )
If SC2->( dbSeek( xFilial() + M->ZE_OP ) )
	If SC2->C2_QUANT > SC2->C2_QUJE
		M->ZE_PRODUTO := Space(len(M->ZE_PRODUTO))
		M->ZE_DESC    := Space(len(M->ZE_DESC))
		M->ZE_MOTIVO  := Space(len(M->ZE_MOTIVO))
		M->ZE_DESCPER := Space(len(M->ZE_DESCPER))
		M->ZE_SALDO   := 0
		M->ZE_QTDORI  := 0
	Else
		MsgStop("Ordem de Produ��o encerrada." + Chr(10) + "S� � poss�vel apontar perdas para Ordens de Produ��o que n�o foram totalmente produzidas.")
		_Retorno := .F.
	EndIf
EndIf

Return _Retorno
