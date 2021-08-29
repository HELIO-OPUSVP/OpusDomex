#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VZA_MOTIVO �Autor  �Helio Ferreira     � Data �  05/08/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o do campo ZA_MOTIVO (motivo de perda)             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Domex                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function VZA_MOTIVO()
Local _Retorno := .T.

If !Empty(M->ZA_MOTIVO)
	If !Empty(M->ZA_PRODUTO)
		M->ZA_DESCPER := Tabela("43",M->ZA_MOTIVO)
		If Empty(Alltrim(M->ZA_DESCPER))
			MsgStop("Motivo de Perda Informado n�o encontrado")
			M->ZA_MOTIVO := SPACE(6)		
			_Retorno := .F.
		EndIf
	Else
		MsgStop("Favor preencher o produto antes do motivo da perda.")
		_Retorno := .F.
	EndIf
Else
	M->ZA_DESCPER := Space(Len(M->ZA_DESCPER))
EndIf

Return _Retorno
