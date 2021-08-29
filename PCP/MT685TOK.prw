#include "rwmake.ch"
#include "totvs.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT685TOK  �Autor  �Helio Ferreira      � Data �  16/07/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada criado para impedir o apontamento de      ���
���          � perda para uma OP encerrada => !Empty(SC2->C2_DATRF)       ���
�������������������������������������������������������������������������͹��
���Uso       � Domex - SigaPCP/SigaEST                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function MT685TOK()

Local _Retorno := .T.
Local aAreaGER := GetArea()
Local aAreaSC2 := SC2->( GetArea() )

SC2->( dbSetorder(1) )
If SC2->( dbSeek(xFilial("SC2") + cOP) )
	If !Empty(SC2->C2_DATRF)
		MsgStop("A OP informada foi encerrada na data "+DtoC(SC2->C2_DATRF)+"."+Chr(13)+"N�o � poss�vel apontar perda ap�s o encerramento da OP.")
		_Retorno := .F.
	EndIf
EndIf

RestArea(aAreaSC2)
RestArea(aAreaGER)

Return _Retorno
