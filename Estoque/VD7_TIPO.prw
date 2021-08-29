#include "rwmake.ch"
#include "topconn.ch"
/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VD7_TIPO  �Autor  �Microsiga           � Data �  08/09/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function VD7_TIPO()
Local _Retorno := .T.
Local aAreaGER := GetArea()

cQuery := "SELECT R_E_C_N_O_ FROM " + RetSqlName("SD1") + " WHERE D1_QUANT <> 0 AND D1_NUMCQ = '"+SD7->D7_NUMERO+"' AND D_E_L_E_T_ = '' "

If Select("TEMP") <> 0
	TEMP->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "TEMP"

If !Empty(TEMP->R_E_C_N_O_)
	SD1->( dbGoTo(TEMP->R_E_C_N_O_) )
	XD1->(dbSetOrder(2))
	If !XD1->( dbSeek(xFilial()+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD+SD1->D1_ITEM) )
		If Upper(Subs(cUsuario,7,5)) <> 'DENIS'
	   	MsgStop("N�o � poss�vel Liberar/Rejeitar o material de uma NF que n�o teve Etiqueta de identifica��o de materiais emitida.")
		   _Retorno := .F.
		EndIf
	EndIf
EndIf

RestArea(aAreaGER)

Return _Retorno
