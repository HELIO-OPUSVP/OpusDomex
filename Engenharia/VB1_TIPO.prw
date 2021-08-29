#include "totvs.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VB1_TIPO  �Autor  � Osmar Ferreira            �  20/10/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o do campo B1_TIPO                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Rosenberger                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function VB1_TIPO()
Local _Retorno := .T.
                              
If Altera
   If M->B1_TIPO == 'PA' 
	  If SubStr(M->B1_SUBCLAS,1,8) $ GetMv("MV_XB1CLAS")
		//Para algumas subclasse n�o ser� feito o controle de c�digo autom�tico
		 _Retorno := .T.
	  Else	
	    If Empty(M->B1_BASE)
		   MsgStop("Para produtos do tipo PA � obrigat�rio utilizar a estrutura de c�digos inteligentes." )
		   _Retorno := .F. 	
	    EndIf
	  EndIf
   EndIf
EndIf                   

Return _Retorno

