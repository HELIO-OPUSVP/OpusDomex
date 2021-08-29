#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
/*
�����������������������������������������������������������������������������            '
�������������������������������������������������������������������������ͻ��
���Programa  � LPTDANFE �Autor  �Michel Sander       � Data �  15/06/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Imprime a DANFE diretamente na impressora 				     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LptDanfe(cLPTDoc)

LOCAL _lPrint   := .T.
LOCAL lLocalServ := .F.		// .T. = Chama pelo Servidor / .F. = Chama local
PRIVATE __cPathPDF  := "\system\DANFE_PDF\"
PRIVATE __cTempTEMP := AllTrim(GetTempPath())

//���������������������������������������������������Ŀ
//�Executa Acrobat Reader para imprimir DANFE		  �
//�����������������������������������������������������
//cComand := 'C:\Program Files\Adobe\Reader 11.0\Reader\AcroRd32.exe /t z:\'+cLPTDoc+' TIlocal "HP LaserJet P2050 Series PCL6" ""192.168.0.245"'
// __CopyFile(Origem, Destino)
__CopyFile(__cPathPDF+cLPTDoc,__cTempTEMP+cLPTDoc)

//If lLocalServ
//	cComand   := 'C:\Program Files (x86)\Adobe\Reader 11.0\Reader\AcroRd32.exe /t '+__cTempTEMP+cLPTDoc      +' TIlocal "HP LaserJet P2050 Series PCL6" ""192.168.0.245"'
//Else
//	cComand   := 'C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe /t '+__cTempTEMP+cLPTDoc+' Expedicao "HP LaserJet P2050 Series PCL6" ""192.168.0.245"'
//EndIf

	If File("c:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe")   //maquina local expedi��o
		CpyS2T(__cPathPDF+cLPTDoc,__cTempTEMP)
		If File(__cTempTEMP+cLPTDoc)
			nWin := shellExecute("Open", "c:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe", "/n /s /h /t " + __cTempTEMP + cLPTDoc + " \\rtws20031\Expedicao", "C:\", 0 )
			//cComand   := 'C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe /t '+__cTempTEMP+cLPTDoc+' Expedicao "HP LaserJet P2050 Series PCL6" ""192.168.0.245"'
		EndIf
	Else
		MsgStop("Programa AcroRd32.exe n�o encontrado: " + 'c:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe", "/n /s /h /t " + __cTempTEMP + cLPTDoc + " \\rtws20031\Expedicao"')
	EndIf


If nWin <> 0
	_lPrint := .F.
EndIf

//���������������������������������������������������Ŀ
//�Encerra Acrobat Reader 									   �
//�����������������������������������������������������
//SLEEP(10000)
//nWin := WINEXEC("taskkill /F /IM AcroRd32.exe")

REturn ( _lPrint )
