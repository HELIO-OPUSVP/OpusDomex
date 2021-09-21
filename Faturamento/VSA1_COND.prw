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
Local lRet := .T.

If __CUSERID $ getmv("MV_XALCOND")
    lRet := .T.
Else    
    MsgInfo("Voc� n�o tem permiss�o para alterar o campo 'Condi��o de Pagamento'.")  
    lRet := .F.
EndIf        

Return(lRet)
