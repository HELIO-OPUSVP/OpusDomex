#include "rwmake.ch"
#include "topconn.ch"
#include "totvs.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA650FIL  บAutor  ณHelio Ferreira      บ Data ณ  28/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Filtro na sele็ใo de Pedidos de Venda para gera็ใo de OPs  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MA650FIL()
Local _Retorno    := ""
Local dDataLimite := CtoD("31/03/14")

cQuery := "SELECT * FROM " + RetSqlName("SC2") + " (NOLOCK) WHERE C2_FILIAL = '"+xFilial("SC2")+"' AND C2_DATRF = '' AND D_E_L_E_T_ = '' AND C2_DATPRF < '"+DtoS(Date())+"' ORDER BY C2_DATPRF"

If Select("QUERYSC2") <> 0
	QUERYSC2->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QUERYSC2"

If !QUERYSC2->( EOF() )
	MsgStop("A Ordem de Produ็ใo " + Subs(QUERYSC2->C2_NUM + QUERYSC2->C2_ITEM + QUERYSC2->C2_SEQUEN,1,11) + " estแ com data de previsใo de FIM atrasada. Favor corrigir sua data antes de gerar novas OPs.")
	If Date() <= dDataLimite
		MsgInfo("Ap๓s 31/03/14 estas inclus๕es serใo bloqueadas.")
	Else
		_Retorno := " 1 = 2 "
	EndIf
EndIf

If Empty(_Retorno)
   _Retorno :=  "SC6->C6_XGERAOP <> '2'"
Else
	_Retorno :=  _Retorno + " .And. SC6->C6_XGERAOP <> '2' "
EndIf	

//grvparop()

Return _Retorno

/*Static function grvparop()
Local aArea := Getarea()
Local aBkpPerg := {}
	
	Pergunte("MTA651",.F.,,,,,@aBkpPerg)
	
	//Altera conte๚do de alguma pergunta
	mv_par13 := U_IC2_NUM()

	SaveMVVars(.T.)

	__SaveParam("MTA651    ", aBkpPerg)

RestArea(aArea)
return
*/
