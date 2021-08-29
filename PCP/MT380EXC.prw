#include "rwmake.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT380EXC  �Autor  �Michel A. Sander    � Data �  21.08.14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para valida��o da exclusao do empenho     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � DOMEX                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT380EXC()

LOCAL _Retorno := .T.

//������������������������������������������������������������Ŀ
//�Verifica se houve movimento de material na Ordem de Produ��o�
//��������������������������������������������������������������
lPgto := U_VerPgtoOp(SD4->D4_OP,SD4->D4_COD)   // Acrescentado o produto em 23/02/21 por H�lio

If !lPgto
	Aviso("Aten��o","O empenho desse item n�o pode ser exclu�do, pois j� existe pagamento de itens no estoque para esta OP.",{"OK"})
	_Retorno := .F.
EndIf

Return( _Retorno )




