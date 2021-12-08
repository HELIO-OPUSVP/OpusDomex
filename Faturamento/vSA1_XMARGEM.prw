#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VSA1_XMARGEM �Autor  �Osmar Ferreira    � Data �  29/11/2021 ���
�������������������������������������������������������������������������͹��
���Desc.     �  Valida o usu�rio que pode alterar este campo no cadastro  ���
���          �  do cliente (Margem de Lucro)                              ���
�������������������������������������������������������������������������͹��
���Uso       � Domex                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function VSA1_XMARGEM()
Local lRet := .t.

If  __cUserID <> "000084"  // Somente a Dayse pode dar esta permiss�o
    MsgInfo("Voc� n�o tem permiss�o para alterar o campo 'Margem de Lucro do Cliente'.")  
    lRet := .f.
EndIf        


Return(lRet)
