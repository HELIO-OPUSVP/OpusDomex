#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณACEDTLOTE บAutor  ณHelio Ferreira      บ Data ณ  26/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina criada para mudar a data de validade de todos os    บฑฑ
ฑฑบ          ณ lotes para 31/12/2049.                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function ACEDTLOTE()

MsgRun("Aguarde...","Processando...",{|| Processando() })

Return


Static Function Processando()

cQuery := "UPDATE " + RetSqlName("SD5") + " SET D5_DTVALID = '20491231' WHERE D5_DTVALID <> '20491231' "
TCSQLEXEC(cQuery)

cQuery := "UPDATE " + RetSqlName("SB8") + " SET B8_DTVALID = '20491231' WHERE B8_DTVALID <> '20491231' "
TCSQLEXEC(cQuery)

Return
