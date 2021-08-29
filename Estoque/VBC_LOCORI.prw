#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VBC_LOCORI�Autor  �Helio Ferreira      � Data �  26/06/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa criado para validar o campo BC_LOCORI para obrigar���
���          � o apontamento de perdas de apropria��o indireta no 99      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function VBC_LOCORI()

Local _Retorno       := .T.
Local nPosBC_PRODUTO := aScan(aHeader, { |aVet| Alltrim(aVet[2]) == 'BC_PRODUTO' } )

SB1->( dbSetOrder(1) )
If SB1->( dbSeek( xFilial() + aCols[n,nPosBC_PRODUTO] ) )
	If SB1->B1_APROPRI == 'I'
		If M->BC_LOCORIG <> GetMv("MV_LOCPROC")
			MsgStop('Produtos com apropria��o indidireta devem ter suas perdas apontadas no local ' + GetMv("MV_LOCPROC") + '.')
			_Retorno := .F.
		EndIf
	Else
		If M->BC_LOCORIG == GetMv("MV_LOCPROC")
			MsgStop('Produtos com apropria��o direta n�o devem ter suas perdas apontadas no local ' + GetMv("MV_LOCPROC") + '.')
			_Retorno := .F.
		EndIf
	EndIf
EndIf

Return _Retorno
