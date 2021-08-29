#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ            '
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ LPTGNRE  บAutor  ณMichel Sander       บ Data ณ  15/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime a GNRE diretamente na impressora 		    		     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function LptGnre(cLPTDoc)

LOCAL _lPrint := .T.
Local __cPathPDF  := "\system\GNRE_PDF\"  
Local __cTempPDF  := AllTrim(GetTempPath())
Local lLocalServ := .F. 		// .T. = Chama pelo Servidor / .F. = Chama local

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExecuta Acrobat Reader para imprimir DANFE			ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//cComand := 'C:\Program Files\Adobe\Reader 11.0\Reader\AcroRd32.exe /t z:\'+cLPTDoc+' TIlocal "HP LaserJet P2050 Series PCL6" ""192.168.0.245"'
If lLocalServ 
	CpyS2T(__cPathPDF+cLPTDoc,__cTempPDF)
	If File(__cTempPDF+cLPTDoc)
		nWin := shellExecute("Open", "c:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe", "/n /s /h /t " + __cTempPDF + cLPTDoc + " \\rtws20031\Expedicao", "C:\", 0 )	
	Else
		cAssunto  := "Rotina LptGnre() - Arquivo nใo encontrado"
		cTexto    := "Arquivo nao encontrado: <br> " + __cTempPDF+cLPTDoc
		cPara     := "denis.vieira@rdt.com.br"
		cCC       := ""
		cArquivo  := ""
		U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
	EndIf
Else
	CpyS2T(__cPathPDF+cLPTDoc,__cTempPDF)
	If File(__cTempPDF+cLPTDoc)
		nWin := shellExecute("Open", "c:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe", "/n /s /h /t " + __cTempPDF + cLPTDoc + " \\rtws20031\Expedicao", "C:\", 0 )	
	Else
		cAssunto  := "Rotina LptGnre() - Arquivo nใo encontrado"
		cTexto    := "Arquivo nao encontrado: <br> " + __cTempPDF+cLPTDoc
		cPara     := "denis.vieira@rdt.com.br"
		cCC       := ""
		cArquivo  := ""
		U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
	EndIf
EndIf

//nWin    := WINEXEC(cComand)

If nWin <> 0
	_lPrint := .F.
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEncerra Acrobat Reader 									   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//SLEEP(10000)
//nWin := WINEXEC("taskkill /F /IM AcroRd32.exe")

REturn ( _lPrint )
