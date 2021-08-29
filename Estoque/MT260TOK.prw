#include "rwmake.ch"
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT260TOK  �Autor  �Helio Ferreira      � Data �  15/05/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o da inclus�o de Transfer�ncia de Produtos.        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function MT260TOK()
Local _Retorno := .T.

//If cLocDest == GetMV("MV_LOCPROC") .or. cLocDest == '01'

If Localiza(cCodOrig) //Wederson - 06/05/13 - Possui controle por endere�amento.
   If Empty(cLoclzDest)
	   apMsgStop('� obrigat�rio o preenchimento da Localiza��o destino.')
	   _Retorno := .F.
   EndIf
EndIf   

Return _Retorno
