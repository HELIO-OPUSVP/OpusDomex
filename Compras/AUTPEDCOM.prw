#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AUTPEDCOM �Autor  �Michel A. Sander    � Data �  09/08/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para gera��o de pedido de compra em PDF             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AUTPEDCOM(cPedIni,cPedFin)

Local aIndArq     := {}
Local oPedCom
Local nHRes       := 0
Local nVRes       := 0
Local nDevice
Local cFilePrint  := ""
Local oSetup
Local aDevice     := {}
Local nRet        := 0
Local lGerou      := .T.

RPCSetType(3)
aAbreTab := {}
RpcSetEnv("01","01",,,,,aAbreTab)
                                             
cPedIni := "R25543"
cPedFin := "R25543"

PRIVATE __cPathPDF  := "\system\PEDCOM_PDF\"
PRIVATE __cTempTEMP := AllTrim(GetTempPath()) 
     
cSession    := GetPrinterSession()

AADD(aDevice,"DISCO") // 1
AADD(aDevice,"SPOOL") // 2
AADD(aDevice,"EMAIL") // 3
AADD(aDevice,"EXCEL") // 4
AADD(aDevice,"HTML" ) // 5
AADD(aDevice,"PDF"  ) // 6

//�������������������������������������������Ŀ
//�Posiciona no PEDIDO DE COMPRAS	         �
//���������������������������������������������
dbSelectArea("SC7")
RetIndex("SC7")
dbClearFilter()
SC7->( dbSetOrder(1) )
SC7->( dbSeek( xFilial() + cPedIni ) )

cAuxPed := ""
Do While SC7->(!Eof()) .And. SC7->C7_NUM <= cPedFin

   If SC7->C7_NUM <> cAuxPed
   
		//�������������������������������������������Ŀ
		//�Configura��o de local de impress�o         �
		//���������������������������������������������
		cFilePrint     := "PEDCOM_"+cPedIni+"_"+Dtos(MSDate())+StrTran(Time(),":","")
		nLocal       	:= If(fwGetProfString(cSession,"LOCAL","SERVER",.T.)=="SERVER",1,2 )
		nOrientation 	:= If(fwGetProfString(cSession,"ORIENTATION","PORTRAIT",.T.)=="PORTRAIT",1,2)
		cDevice     	:= If(Empty(fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.)),"PDF",fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.))
		nPrintType     := aScan(aDevice,{|x| x == cDevice })
		
		//�������������������������������������������Ŀ
		//�Configura��o de impress�o para PDF         �
		//���������������������������������������������
		lAdjustToLegacy := .F. // Inibe legado de resolu��o com a TMSPrinter
		nFlags   := PD_ISTOTVSPRINTER + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN
		oSetup   := FWPrintSetup():New(nFlags, "PEDCOM")
		oPedCom  := FWMSPrinter():New(cFilePrint,6,.F.,,.T.)
		
		oPedCom:SetResolution(78) //Tamanho estipulado para a PEDCOM
		oPedCom:SetLandScape()
		oPedCom:SetPaperSize(9)
		oPedCom:SetMargin(60,60,60,60)
		oPedCom:cPathPDF := __cTempTEMP   

		//�������������������������������������������Ŀ
		//�Impress�o do PEDIDO DE COMPRA	             �
		//���������������������������������������������
		PUBLIC lAutoPed := .T.
		U_RCOMR01(oPedCom,cPedIni)
		oPedCom:SetViewPDF(.f.)
		oPedCom:Preview()
		FreeObj(oPedCom)
		oSetup := Nil
		
		//�������������������������������������������Ŀ
		//�Copia arquivo tempor�rio para destino PDF  �
		//���������������������������������������������
		If File(__cTempTEMP+cFilePrint+".pdf")
			__CopyFile(__cTempTEMP+cFilePrint+".pdf",__cPathPDF+cFilePrint+".pdf")		// Arquivo Destino = __cPathPDF+cFilePrint+".pdf"
		EndIf
	   cAuxPed := SC7->C7_NUM
   
	EndIf   

	SC7->(dbSkip())
  	cPedIni := SC7->C7_NUM	
  	
EndDo

Return