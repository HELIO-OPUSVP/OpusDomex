#include "totvs.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A415TDOK  �Autor  �Osmar Ferreira     � Data �  12/07/21    ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida o or�amento de vendas                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Domex                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function A415TDOK()
Local cTexto := ''
Local _lRet := .t.

   _lRet := U_ValiOrc(M->CJ_NUM,.T.)
   
   If !_lRet 
      If M->CJ_CONDPAG == "043"
          _lRet := .T.
      Else
        cTexto := "ATEN��O: ANALISE DE CR�DITO"+ Chr(13)+ Chr(13)
        cTexto += "O or�amento n�mero: "+ M->CJ_NUM + Chr(13)
        cTexto += "N�o pode ser inclu�do no sistema por N�O atender as regras de Analise de Cr�dito"+ Chr(13)+ Chr(13)
        cTexto += "Se deseja incluir assim mesmo, deve usar a Condi��o de Pagamento (043 - A COMBINAR) "+ Chr(13)
        apMsgAlert(cTexto)
      EndIf
   EndIf

Return(_lRet)

