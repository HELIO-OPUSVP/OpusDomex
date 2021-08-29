#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M020INC   �Autor  �Helio Ferreira      � Data �  05/07/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada na inclus�o de Cadastro de Fornecedores   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Domex                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function M020INC()

CTD->(dbSetOrder(1))
If !CTD->(dbSeek(xFilial("CTD")+"F"+SA2->A2_COD+SA2->A2_LOJA))
	If RecLock("CTD",.T.)
		CTD_FILIAL := xFilial("CTD")
		CTD_ITEM   := "F"+SA2->A2_COD+SA2->A2_LOJA
		CTD_CLASSE := "2"
		CTD_DESC01 := SA2->A2_NOME
		CTD_BLOQ   := "2"
		CTD_DTEXIS := CtoD("01/01/80")
		CTD_NORMAL := "1"
		CTD->( MsUnlock() )
	EndIf
EndIf

Return
