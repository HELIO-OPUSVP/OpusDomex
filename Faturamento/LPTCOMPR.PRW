#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

/*
�����������������������������������������������������������������������������            '
�������������������������������������������������������������������������ͻ��
���Programa  � LPTCOMPR �Autor  �Michel Sander       � Data �  15/06/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Imprime o comprovante da GNRE diretamente na impressora    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LptCompr(cLPTDoc)

LOCAL _lPrint := .T.
Local __cPathPDF  := "\system\GNRE_PDF\"
Local __cTempPDF  := AllTrim(GetTempPath())
Local lLocalServ := .F.		// .T. = Chama pelo Servidor / .F. = Chama local

//���������������������������������������������������Ŀ
//�Executa Acrobat Reader para imprimir DANFE			�
//�����������������������������������������������������
//cComand := 'C:\Program Files\Adobe\Reader 11.0\Reader\AcroRd32.exe /t z:\'+cLPTDoc+' TIlocal "HP LaserJet P2050 Series PCL6" ""192.168.0.245"'
If lLocalServ
	CpyS2T(__cPathPDF+cLPTDoc,__cTempPDF)//cComand   := 'C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe /t '+__cTempPDF+cLPTDoc+' Expedicao "HP LaserJet P2050 Series PCL6" ""192.168.0.245"'
	If File(__cTempPDF+cLPTDoc)
		//cComand   := 'C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe /t '+__cTempPDF+cLPTDoc+' Expedicao "HP LaserJet P2050 Series PCL6" ""192.168.0.245"'
		nWin := shellExecute("Open", "c:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe", "/n /s /h /t " + __cTempPDF + cLPTDoc + " \\rtws20031\Expedicao", "C:\", 0 )	
	Else
		cAssunto  := "Rotina LPTCOMPR() - Arquivo n�o encontrado"
		cTexto    := "Arquivo nao encontrado: <br> " + __cTempPDF+cLPTDoc
		cPara     := "denis.vieira@rdt.com.br;michel@opusvp.com.br;helio@opusvp.com.br"
		cCC       := ""
		cArquivo  := ""
		U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
	EndIf
Else
	CpyS2T(__cPathPDF+cLPTDoc,__cTempPDF)//cComand   := 'C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe /t '+__cTempPDF+cLPTDoc+' Expedicao "HP LaserJet P2050 Series PCL6" ""192.168.0.245"'
	If File(__cTempPDF+cLPTDoc)
		//cComand   := 'C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe /t '+__cTempPDF+cLPTDoc+' Expedicao "HP LaserJet P2050 Series PCL6" ""192.168.0.245"'
		nWin := shellExecute("Open", "c:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe", "/n /s /h /t " + __cTempPDF + cLPTDoc + " \\rtws20031\Expedicao", "C:\", 0 )	
	Else
		cAssunto  := "Rotina LPTCOMPR() - Arquivo n�o encontrado"
		cTexto    := "Arquivo nao encontrado: <br> " + __cTempPDF+cLPTDoc
		cPara     := "denis.vieira@rdt.com.br;michel@opusvp.com.br;helio@opusvp.com.br"
		cCC       := ""
		cArquivo  := ""
		U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
	EndIf
EndIf

//nWin    := WINEXEC(cComand)

If nWin <> 0
	_lPrint := .F.
EndIf

//���������������������������������������������������Ŀ
//�Encerra Acrobat Reader 									   �
//�����������������������������������������������������
//SLEEP(10000)
//nWin := WINEXEC("taskkill /F /IM AcroRd32.exe")

REturn ( _lPrint )
