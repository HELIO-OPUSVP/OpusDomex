#Include "rwMake.ch"
#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  M415GRV   �Autor  �Osmar Ferreira      � Data �  02/07/20  ���
�������������������������������������������������������������������������͹��
���Desc.     �  Ponto de entrada ap�s a grava��o do Or�amento             ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function M415GRV()
   Local _nOper    := PARAMIXB[1]
  // Local cOperacao := ""
  // Local cQry      := ""
  // Local nMargem   := 0
   Local aAreaSCJ  := SCJ->(GetArea())
   Local aAreaSCK  := SCK->(GetArea())
   Local aAreaZZF  := ZZF->(GetArea())

   If (_nOper == 1)  .Or. (_nOper == 2)    //Inclus�o / Altera��o

      U_OrcPrNet(M->CJ_NUM)                //Calcula o pre�o Net para Or�amento

     // If _nOper == 1
     //    cOperacao := "Inclusao"
     // Else
     //    cOperacao := "Alteracao"
     // EndIf

      
   EndIf

   RestArea(aAreaZZF)
   RestArea(aAreaSCK)
   RestArea(aAreaSCJ)

Return(Nil)

