#include "rwmake.ch"
#include "topconn.ch"
#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AGLUTSD4  ºAutor  ³Helio Ferreira      º Data ³  02/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AGLUTSD4(__cOP)

Local cQuery1

cQuery1 := "SELECT D4_FILIAL, D4_COD, D4_LOCAL, D4_OP, D4_DATA, SUM(D4_QTDEORI) AS D4_QTDEORI, SUM(D4_QUANT) AS D4_QUANT,D4_LOTECTL, "
cQuery1 += "D4_OPORIG, SUM(D4_QTSEGUM) AS D4_QTSEGUM, MAX(D4_SEQ) AS D4_SEQ "
cQuery1 += "FROM "+RetSqlName("SD4")+" (NOLOCK) WHERE D4_FILIAL = '"+xFilial("SD4")+"' AND D4_OP = '"+__cOP+"' AND D_E_L_E_T_ = '' AND D4_COD+D4_LOCAL IN "
cQuery1 += "(SELECT D4_COD+D4_LOCAL FROM "+RetSqlName("SD4")+" (NOLOCK) WHERE D4_FILIAL = '01' AND D4_OP = '"+__cOP+"' AND D_E_L_E_T_ = '' "
cQuery1 += "GROUP BY D4_FILIAL, D4_COD, D4_LOCAL, D4_OP, D4_DATA, D4_LOTECTL, D4_OPORIG "
cQuery1 += "HAVING COUNT(*) > 1 ) "
cQuery1 += "GROUP BY D4_FILIAL, D4_COD, D4_LOCAL, D4_OP, D4_DATA, D4_LOTECTL, D4_OPORIG "

If Select("TEMP001") <> 0
	TEMP001->( dbCloseArea() )
EndIf

TCQUERY cQuery1 NEW ALIAS "TEMP001"

If !TEMP001->( EOF() )
	cQuery2 := "UPDATE " + RetSqlName("SD4") + " SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ "
	cQuery2 += "WHERE D4_FILIAL = '"+xFilial("SD4")+"' AND D4_OP = '"+__cOP+"' AND D_E_L_E_T_ = '' AND D4_COD+D4_LOCAL IN "
	cQuery2 += "(SELECT D4_COD+D4_LOCAL FROM "+RetSqlName("SD4")+" (NOLOCK) WHERE D4_FILIAL = '01' AND D4_OP = '"+__cOP+"' AND D_E_L_E_T_ = '' "
	cQuery2 += "GROUP BY D4_FILIAL, D4_COD, D4_LOCAL, D4_OP, D4_DATA, D4_LOTECTL, D4_OPORIG "
	cQuery2 += "HAVING COUNT(*) > 1 ) "
	
	TCSQLEXEC(cQuery2)
	While !TEMP001->( EOF() )
		Reclock("SD4",.T.)
		SD4->D4_FILIAL   := TEMP001->D4_FILIAL
		SD4->D4_COD      := TEMP001->D4_COD
		SD4->D4_LOCAL    := TEMP001->D4_LOCAL
		SD4->D4_OP       := TEMP001->D4_OP
		SD4->D4_DATA     := StoD(TEMP001->D4_DATA)
		SD4->D4_QTDEORI  := TEMP001->D4_QTDEORI
		SD4->D4_QUANT    := TEMP001->D4_QUANT
		SD4->D4_LOTECTL  := TEMP001->D4_LOTECTL
		SD4->D4_DTVALID  := StoD('20491231')
		SD4->D4_OPORIG   := TEMP001->D4_OPORIG
		SD4->D4_QTSEGUM  := TEMP001->D4_QTSEGUM
		SD4->D4_SEQ      := StrZero(Val(TEMP001->D4_SEQ)+1,Len(SD4->D4_SEQ))
		SD4->( msUnlock() )
		TEMP001->( dbSkip() )
	End
EndIf

//cQuery3 := "SELECT D4_COD, D4_LOCAL, D4_QUANT FROM "
//cQuery3 += "( SELECT D4_COD, D4_LOCAL, SUM(D4_QUANT) AS D4_QUANT   "
//cQuery3 += ",(SELECT B2_QEMP FROM SB2010 WHERE B2_COD = D4_COD AND B2_LOCAL = D4_LOCAL AND D_E_L_E_T_ = '') AS B2_QEMP  "
//cQuery3 += "FROM SD4010 (NOLOCK)                          "
//cQuery3 += "WHERE D4_QUANT > 0 AND SD4010.D_E_L_E_T_ = ''  "
//cQuery3 += "GROUP BY D4_COD, D4_LOCAL) TMP "
//cQuery3 += "WHERE ROUND(D4_QUANT,4) <> ROUND(B2_QEMP,4) "

If Select("TEMP003") <> 0
	TEMP003->( dbCloseArea() )
EndIf

//
//TCQUERY cQuery3 NEW ALIAS "TEMP003"

/*
BeginSql Alias "TEMP003"
	SELECT D4_COD, D4_LOCAL, D4_QUANT FROM
	( SELECT D4_COD, D4_LOCAL, SUM(D4_QUANT) AS D4_QUANT
	,(SELECT B2_QEMP FROM SB2010 (NOLOCK) WHERE B2_COD = D4_COD AND B2_LOCAL = D4_LOCAL AND D_E_L_E_T_ = '') AS B2_QEMP
	FROM SD4010 (NOLOCK)
	WHERE D4_QUANT > 0 AND SD4010.D_E_L_E_T_ = ''
	GROUP BY D4_COD, D4_LOCAL) TMP
	WHERE ROUND(D4_QUANT,4) <> ROUND(B2_QEMP,4)
EndSql
*/

//SB2->( dbSetOrder(1) )
//While !TEMP003->( EOF() )
//	If SB2->( dbSeek( xFilial() + TEMP003->D4_COD + TEMP003->D4_LOCAL ) )
//		If Reclock("SB2",.F.)
//			SB2->B2_QEMP := TEMP003->D4_QUANT
//			SB2->( msUnlock() )
//		EndIf
//	EndIf
//	TEMP003->( dbSkip() )
//End

// SOLUCAO PROPOSTA POR MICHEL SANDER em 24.01.17 COM UPDATE FROM PARA SUBSTITUIR O CODIGO COM LENTIDÃO ACIMA COMENTADO (ANALISAR HELIO)

/*
cSQL := "UPDATE "+RetSqlName("SB2")+" SET "
cSQL += "B2_QEMP = D4_QUANT FROM "
cSQL += "( SELECT D4_COD, D4_LOCAL, SUM(D4_QUANT) AS D4_QUANT,(SELECT B2_QEMP FROM SB2010 (NOLOCK) WHERE B2_COD = D4_COD AND B2_LOCAL = D4_LOCAL AND D_E_L_E_T_ = '') AS B2_QEMP "
cSQL += "FROM "+RetSqlName("SD4")+" (NOLOCK) WHERE "
cSQL += "D4_QUANT > 0 AND SD4010.D_E_L_E_T_ = '' GROUP BY D4_COD, D4_LOCAL) AS SD4 "
cSQL += "INNER JOIN "+RetSqlName("SB2")+" AS SB2 on B2_COD=D4_COD and B2_LOCAL=D4_LOCAL AND ROUND(D4_QUANT,4) <> ROUND(SB2.B2_QEMP,4) and SB2.D_E_L_E_T_=''"

TCSQLEXEC(cSQL)
*/

If Select("TEMP001") <> 0
	TEMP001->( dbCloseArea() )
EndIf

//If Select("TEMP003") <> 0
//	TEMP003->( dbCloseArea() )
//EndIf

Return
