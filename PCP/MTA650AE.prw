#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMTA650AE  บAutor  ณHelio Ferreira      บ Data ณ  13/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de Entrada executado ap๓s a exclusใo da OP           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MTA650AE()
	Local cOP   := PARAMIXB[1]
	Local cItem := PARAMIXB[2]
	Local cSeq  := PARAMIXB[3]
	Local cLoteCTL
	Local aAreaGER := GetArea()
	Local aAreaSC6 := SC6->( GetArea() )
//	Local _CQUERY1 := ''

/*  Peda็o do fonte MATA650
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Ponto de entrada apos a exclusao - MTA650AE 	    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lMTA650AE
ExecBlock("MTA650AE",.F.,.F.,{cNum,cItem,cSeq})
	EndIf
*/

// Criar valida็ใo para nใo deixar alterar o produto/Quantidade quando jแ houver OP gerada para o Item do PV

	If cSeq == '001'  // Apagar somente quando for a OP pai
		cLoteCTL := U_RetLotC6(cOP+cItem+cSeq)

		cQuery := "SELECT R_E_C_N_O_ FROM " + RetSqlName("SC6") + " (NOLOCK) WHERE C6_FILIAL='"+xfilial("SC6")+"' AND C6_LOTECTL = '"+cLoteCTL+"' AND D_E_L_E_T_ = '' "

		If Select("QUERYSC6") <> 0
			QUERYSC6->( dbCloseArea() )
		EndIf

		TCQUERY cQuery NEW ALIAS "QUERYSC6"

		While !QUERYSC6->( EOF() )
			SC6->( dbGoTo(QUERYSC6->R_E_C_N_O_) )
			If SC6->( Recno() ) == QUERYSC6->R_E_C_N_O_
				Reclock("SC6",.F.)
				SC6->C6_OP      := ''
				SC6->C6_LOTECTL := ''
				SC6->C6_LOCALIZ := '13EXPEDICAO'
				SC6->C6_NUMOP   := ''
				SC6->C6_ITEMOP  := ''
				SC6->( msUnlock() )
				//Else
				//	MsgStop("Nใo foi possํvel limpar o lote da OP do Pedido de Vendas. Favor informar TI.")
				//EndIf
			EndIf
			QUERYSC6->( dbSkip() )
		End

		cQuery := "SELECT C6_NUM, C6_ITEM FROM SC6010 (NOLOCK) WHERE C6_FILIAL='"+xfilial("SC6")+"' AND C6_NUMOP <> '' AND D_E_L_E_T_ = '' "
		cQuery += "AND C6_NUMOP + C6_ITEMOP NOT IN (SELECT C2_NUM + C2_ITEM FROM SC2010 (NOLOCK) WHERE C2_FILIAL='"+xfilial("SC2")+"' AND D_E_L_E_T_ = '') "

		If Select("QUERYSC6") <> 0
			QUERYSC6->( dbCloseArea() )
		EndIf

		TCQUERY cQuery NEW ALIAS "QUERYSC6"

		If !QUERYSC6->( EOF() )
			While !QUERYSC6->( EOF() )
				MsgStop("Pedido de Vendas: " + QUERYSC6->C6_NUM + ", item: " + QUERYSC6->C6_ITEM + " nใo teve seu numero de OP limpo. Favor informar TI. " )
				QUERYSC6->( dbSkip() )
			End
		EndIf
	EndIf

	// Limpaza do D4_OPORIG
	nTentativas := 0
	SD4->( dbSetOrder(4) )  // D4_FILIAL, D4_OPORIG, D4_LOTECTL, D4_NUMLOTE, R_E_C_N_O_, D_E_L_E_T_
	While SD4->( dbSeek( xFilial() + cOP+cItem+cSeq ) ) .and. nTentativas <= 1000
		nTentativas++
		Reclock("SD4",.F.)
		SD4->D4_OPORIG := ''
		SD4->( msUnlock() )
	End

	RestArea(aAreaSC6)
	RestArea(aAreaGER)

Return
