#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �C6XXSEPARA �Autor  �Helio Ferreira     � Data �  07/06/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o do campo C6_XXDTSEP (Data de Separa��o de Senf)  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function C6XXDTSEP()
Local _Retorno    := .T.
Local nPC6_ITEM   := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_ITEM"   })
Local nPC6_ENTRE3 := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_ENTRE3" })
 
SZY->( dbSetOrder(1) )
If !SZY->( dbSeek( xFilial() + M->C5_NUM + aCols[N,nPC6_ITEM] ) )
   If M->C6_XXDTSEP == aCols[N,nPC6_ENTRE3]
      // Data Ok
   Else
      MsgStop("Data de Separa��o diferente da Data do PCP.")
      _Retorno := .F.
   EndIf	
Else
	If SZY->ZY_PRVFAT <> M->C6_XXDTSEP
	   MsgStop("Data de Separa��o diferente da Data do PCP.")
      _Retorno := .F.
	EndIf
EndIf

Return _Retorno
