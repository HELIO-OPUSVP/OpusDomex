#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VSA1_COND  � Autor  �Osmar Ferreira    � Data �  15/09/2021 ���
�������������������������������������������������������������������������͹��
���Desc.     �  Valida o usu�rio que pode alterar este campo no cadastro  ���
���          �  do cliente  - Condi��o de Pagamento                       ���
�������������������������������������������������������������������������͹��
���Uso       � Domex                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function VSA1_COND()
Local lRet := .t.

If  __cUserID <> "000084"  // Somente a Dayse pode dar esta permiss�o
    MsgInfo("Voc� n�o tem permiss�o para alterar o campo 'Valida o C�digo do Cliente'.")  
    lRet := .f.
EndIf        


Return(lRet)
