#include "rwmake.ch"
#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALIDACAO บAutor  ณH้lio Ferreira      บ Data ณ  15/07/21   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.    ณ Fun็ใo para validar se o environment Atual ้ o de Valida็ใo บฑฑ
ฑฑบ         ณ ou algum ambiente de desenvolvimento                        บฑฑ                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rosenberger                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function VALIDACAO(cConsultor,lRetorno)
	//Local _Retorno := .F.
    Local cEnvironment := Upper(GetEnvserv())
	Local aConsultores := {}
	Default cConsultor := ""
	Default lRetorno := .F.

	AADD(aConsultores,"HELIO")
	AADD(aConsultores,"RODA")
	AADD(aConsultores,"JONAS")
	AADD(aConsultores,"MAURICIO")
	AADD(aConsultores,"OSMAR")
	AADD(aConsultores,"MAURESI")
	AADD(aConsultores,"JACKSON")

	If !Empty(cConsultor)
		If aScan(aConsultores,cConsultor) == 0
			apMsgInfo('Consultor ' + cConsultor + ' nใo cadastrado na fun็ใo U_VALIDACAO()')
		EndIf
	EndIf

	If cEnvironment == "VALIDACAO" .or. cEnvironment =="WEBCOL_VALIDACAO" .or. cEnvironment == "WEBCOLMG_VALIDACAO" .or. ".OPUS" $ cEnvironment .or. cEnvironment == "MAURESI" .or. cEnvironment == "COMPILA_QUENTE_VALIDACAO" .or. cEnvironment =="ricardo.opus" .or. cEnvironment == "HELIO.OPUS"
		lRetorno := .T.
	EndIf

Return lRetorno
