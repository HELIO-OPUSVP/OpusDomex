#include "rwmake.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVD7_TIPO  บAutor  ณMicrosiga           บ Data ณ  08/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
	   	MsgStop("Nใo ้ possํvel Liberar/Rejeitar o material de uma NF que nใo teve Etiqueta de identifica็ใo de materiais emitida.")
		   _Retorno := .F.
		EndIf
	EndIf
EndIf

RestArea(aAreaGER)

Return _Retorno
