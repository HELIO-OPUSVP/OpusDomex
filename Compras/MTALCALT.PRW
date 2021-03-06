#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTALCALT �Autor  �Jackson Santos       � Data �  07/26/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Adicionar tratamento  e grava��o nos campos da tabela SCR ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MTALCALT()
	Local aAreaAtu := GetArea()
	Local aAreaSY1	:= SY1->(GetArea())

	DbSelectArea("SY1")
	SY1->(DbSetOrder(3))
	RecLock("SCR", .F.) //MLS   20210308 CHAMADO 023103
	If SY1->(DbSeek(xFilial("SY1") + SC7->C7_USER))
		SCR->CR_XCOMPR := UPPER(ALLTRIM(SY1->Y1_NOME))
	Else
		SCR->CR_XCOMPR := ""
	EndIf
	SCR->(MsUnLock()) //MLS   20210308 CHAMADO 023103 


	RestArea(aAreaSY1)
	RestArea(aAreaAtu)
Return

