#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ            '
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ LPTDANFE บAutor  ณMichel Sander       บ Data ณ  15/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime a DANFE diretamente na impressora 				     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function LptDanfe(cLPTDoc)

LOCAL _lPrint   := .T.
LOCAL lLocalServ := .F.		// .T. = Chama pelo Servidor / .F. = Chama local
PRIVATE __cPathPDF  := "\system\DANFE_PDF\"
PRIVATE __cTempTEMP := AllTrim(GetTempPath())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExecuta Acrobat Reader para imprimir DANFE		  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//cComand := 'C:\Program Files\Adobe\Reader 11.0\Reader\AcroRd32.exe /t z:\'+cLPTDoc+' TIlocal "HP LaserJet P2050 Series PCL6" ""192.168.0.245"'
// __CopyFile(Origem, Destino)
__CopyFile(__cPathPDF+cLPTDoc,__cTempTEMP+cLPTDoc)

//If lLocalServ
//	cComand   := 'C:\Program Files (x86)\Adobe\Reader 11.0\Reader\AcroRd32.exe /t '+__cTempTEMP+cLPTDoc      +' TIlocal "HP LaserJet P2050 Series PCL6" ""192.168.0.245"'
//Else
//	cComand   := 'C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe /t '+__cTempTEMP+cLPTDoc+' Expedicao "HP LaserJet P2050 Series PCL6" ""192.168.0.245"'
//EndIf

	If File("c:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe")   //maquina local expedi็ใo
		CpyS2T(__cPathPDF+cLPTDoc,__cTempTEMP)
		If File(__cTempTEMP+cLPTDoc)
			nWin := shellExecute("Open", "c:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe", "/n /s /h /t " + __cTempTEMP + cLPTDoc + " \\rtws20031\Expedicao", "C:\", 0 )
			//cComand   := 'C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe /t '+__cTempTEMP+cLPTDoc+' Expedicao "HP LaserJet P2050 Series PCL6" ""192.168.0.245"'
		EndIf
	Else
		MsgStop("Programa AcroRd32.exe nใo encontrado: " + 'c:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe", "/n /s /h /t " + __cTempTEMP + cLPTDoc + " \\rtws20031\Expedicao"')
	EndIf


If nWin <> 0
	_lPrint := .F.
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEncerra Acrobat Reader 									   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//SLEEP(10000)
//nWin := WINEXEC("taskkill /F /IM AcroRd32.exe")

REturn ( _lPrint )
