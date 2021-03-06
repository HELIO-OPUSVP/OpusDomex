#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VZE_MOTIVO �Autor  �Helio Ferreira     � Data �  05/08/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o do campo ZE_MOTIVO motivo de perda do Fornecedor ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Domex                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function VZE_MOTIVO()
Local _Retorno := .T.

If !Empty(M->ZE_MOTIVO)
	If !Empty(M->ZE_PRODUTO)
		M->ZE_DESCPER := Tabela("43",M->ZE_MOTIVO)
	Else
		MsgStop("Favor preencher o produto antes do motivo da perda.")
		_Retorno := .F.
	EndIf
Else
	M->ZE_DESCPER := Space(Len(M->ZE_DESCPER))
EndIf

Return _Retorno
