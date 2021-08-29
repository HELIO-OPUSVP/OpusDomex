#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO4     บAutor  ณHelio Ferreira      บ Data ณ  19/02/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DOMPCP07()
Local nQtdRec := 0

If Pergunte("DOMPCP07",.T.)
	
	cQuery := "SELECT B1_COD FROM " + RetSqlName("SB1") + " WHERE B1_COD LIKE '"+Alltrim(mv_par01)+"%' AND D_E_L_E_T_ = '' "
	
	If Select("QUERYSB1") <> 0
		QUERYSB1->( dbCloseArea() )
	EndIf
	
	TCQUERY cQuery NEW ALIAS "QUERYSB1"
	
	If !QUERYSB1->( EOF() )
		
		QDH->( dbSetOrder(1) )
		SZV->( dbSetOrder(1) )
		
		If QDH->( dbSeek( xFilial() + Subs(mv_par02,1,16) ) )
			While !QUERYSB1->( EOF() )
				If !SZV->( dbSeek( xFilial() + "SB1" + QUERYSB1->B1_COD + Subs(mv_par02,1,16) ) )
					Reclock("SZV",.T.)
				Else
				   Reclock("SZV",.F.)
				EndIf
				SZV->ZV_FILIAL  := xFilial("SZV")
				SZV->ZV_ALIAS   := "SB1"
				SZV->ZV_CHAVE   := QUERYSB1->B1_COD
				SZV->ZV_ARQUIVO := Subs(mv_par02,1,16)
				SZV->ZV_DESCRI  := Upper(mv_par03)
				SZV->( msUnlock() )  
				nQtdRec++
				QUERYSB1->( dbSkip() )
			End
			MsgInfo("Foram amarrados " + Alltrim(Str(nQtdRec)) + " produtos ao documento.")
		Else
			MsgStop("Documento nใo encontrado no Controle de Documentos.")
		EndIf
	Else
		MsgStop("Nใo foram encontrados produtos com a inicial '"+Alltrim(mv_par01)+"'.")
	EndIf
EndIf

Return
