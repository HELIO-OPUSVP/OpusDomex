#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLOTESOP   บAutor  ณHelio Ferreira      บ Data ณ  13/07/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function LotesOP()
Local dData := GetMv("MV_ULMES")
Local cLote := ""

If !MsgYesNo("Deseja processar a Corre็ใo dos lotes a partir de " + DtoC(dData) + "?")
	Return
EndIf

cQuery := "SELECT D3_OP, D3_LOTECTL FROM "+RetSqlName("SD3")+" (NOLOCK) WHERE D3_FILIAL = '01' AND D3_LOCAL = '97' AND D3_OP <> '' AND D3_EMISSAO > '"+DtoS(dData)+"' "
cQuery += "AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "

If SD3->( FieldPos("D3_XLOTEOK") ) > 0
	cQuery += "AND D3_XLOTEOK = ''
EndIf

cQuery += "GROUP BY D3_OP, D3_LOTECTL "

If Select("QUERYSD3") <> 0
	QUERYSD3->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QUERYSD3"

While !QUERYSD3->( EOF() )
	cLote := U_RetLotC6(QUERYSD3->D3_OP)
	If QUERYSD3->D3_LOTECTL <> cLote
		TCSQLEXEC("UPDATE "+RetSqlName("SD3")+" SET D3_LOTECTL = '"+cLote+"' WHERE D3_FILIAL = '01' AND D3_OP = '"+QUERYSD3->D3_OP+"' AND D3_LOTECTL <> '"+cLote+"' AND D3_LOCAL = '97' AND D3_OP <> '' AND D3_EMISSAO > '"+DtoS(dData)+"' AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' " )
	EndIf
	QUERYSD3->( dbSkip() )
End

Return
