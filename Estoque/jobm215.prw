#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณjobm215  บAutor  ณ                     บ Data ณ  24/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Shedule Refaz Acumulados MATA215                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function jobm215()

Local PARAMIXB := .T.           
Local aemp := {"01","01"}

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"       USER 'Mauricio'      PASSWORD 'megasenha' TABLES "SA1","SB2","SC0","SC6","SC7","SC9","SD1","SD4","SE2","VCB" MODULO "EST"

cData     := DtoC(Date())
cAssunto  := "Begin Refaz Acumulados Homologa็ใo Domex - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
cTexto    := "Begin Refaz Acumulados Homologa็ใo Domex - Date " + cData + "  Time: " + Time()
//cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br"
cPara     := "mauricio.souza@opusvp.com.br"
cCC       := ""
cArquivo  := ""

U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)


//WINEXEC ('C:\TEMP\STOP_HOM.BAT')
//WINEXEC ('runas  "C:\TEMP\STOP_HOM.BAT"')    
/*
Net stop  23_P11_3113_HOM_TI
Net stop  24_P11_3114_HOM_SRV
Net stop  25_P11_3115_HOM_TSS

Net start 23_P11_3113_HOM_TI
*/

MSExecAuto({|x| mata215(x)},PARAMIXB)

//WINEXEC ('C:\TEMP\START_HOM.BAT')

cAssunto  := "End of Refaz Acumulados Homologacao Domex - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
cTexto    := "End of Refaz Acumulados Homologacao Domex - Date " + cData + "  Time: " + Time()
//cPara     :=  "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br"
cPara     :=  "mauricio.souza@opusvp.com.br"
cCC       := ""
cArquivo  := ""

U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)

RESET ENVIRONMENT


Return Nil



