#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VD4_QUANT �Autor  �Helio Ferreira      � Data �  16/12/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function VD4_QUANT()
Local _Retorno := .T.
Local lPgto    := .F.

If ALTERA
	If FunName() == "MATA381"
		lPgto := U_VerPgtoOp(cOp,ACOLS[N,aScan(aHeader,{|avet| Alltrim(aVet[2]) == "D4_COD"  })])
		
		If !lPgto
			Aviso("Aten��o","Este empenho n�o pode ser alterado pois j� existe pagamento de itens no estoque para esta OP.",{"OK"})
			_Retorno := .F.
		EndIf
	EndIf
	If FunName() == "MATA380"
		lPgto := U_VerPgtoOp(M->D4_OP,M->D4_COD)
		
		If !lPgto
			Aviso("Aten��o","Este empenho n�o pode ser alterado pois j� existe pagamento de itens no estoque para esta OP.",{"OK"})
			_Retorno := .F.
		EndIf
	EndIf
	
EndIf

Return _Retorno
