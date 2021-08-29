#include "totvs.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMTA650I   บAutor  ณHelio Ferreira      บ Data ณ  06/06/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de Entrada executado depois da grava็ใo da OP para   บฑฑ
ฑฑบ          ณ Inclusใo MANUAL DE OP/POR VENDAS                           บฑฑ
ฑฑบ          ณ executado antes da grava็ใo dos empenhos                   บฑฑ  
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MTA650I()

// Semแforo Domex para inclusใo manual de OP

/*
	If GetMV("MV_XSEMAOP") == 'S'           // JOAO - COMENTADO
		If !Empty(__XXNumSeq) // JOAO - COMENTADO
		U_FNUMSEQ(__XXNumSeq)
		MsgINfo("MTA650I() - Depois da grava็ใo da OP manual/vendas e libera็ใo do semแforo Domex")
		// RETIRADO Vanessa Faio PE dapois da grava็ใo da abertura de OP manual/vendas
		EndIf   // JOAO - COMENTADO
	EndIf  // JOAO - COMENTADO
*/

Return .T.
