#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"            
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PDFDANFE �Autor  �Michel A. Sander    � Data �  09/08/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para gera��o da DANFE autom�tica em PDF             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PDFDanfe(cNF,cSerie,lEnvColetor)

Local nDevice
Local oSetup
Local oDanfe
Local aIndArq       := {}
Local nHRes         := 0
Local nVRes         := 0
Local cFilePrint    := ""
Local aDevice       := {}
Local nRet          := 0
Local lGerou        := .T.
Local lLocalServ    := .F.		// Local de Grava��o do PDF da DANFE (.T. = \system\DANFE_PDF\) (.F. = Pasta TEMP do usuario local)

PRIVATE __cPathPDF  := "\system\DANFE_PDF\"
PRIVATE __cTempTEMP := AllTrim(GetTempPath()) //"D:\TOTVS12\01-Oficial\Protheus_Data\temp_anexos\" //"\temp_anexos\"		
PRIVATE cIdEnt      := "000002"     

Private lVerPerg := .F.

DEFAULT lEnvColetor := .F.

cSession    := GetPrinterSession()

AADD(aDevice,"DISCO") // 1
AADD(aDevice,"SPOOL") // 2
AADD(aDevice,"EMAIL") // 3
AADD(aDevice,"EXCEL") // 4
AADD(aDevice,"HTML" ) // 5
AADD(aDevice,"PDF"  ) // 6

//�������������������������������������������Ŀ
//�Configura��o de local de impress�o         �
//���������������������������������������������
cFilePrint     := "DANFE_"+cNF+"_"+cSerie+"_"+Dtos(MSDate())+StrTran(Time(),":","")
nLocal         := If(fwGetProfString(cSession,"LOCAL","SERVER",.T.)=="SERVER",1,2 )
nOrientation   := If(fwGetProfString(cSession,"ORIENTATION","PORTRAIT",.T.)=="PORTRAIT",1,2)
cDevice        := If(Empty(fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.)),"PDF",fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.))
nPrintType     := aScan(aDevice,{|x| x == cDevice })

//�������������������������������������������Ŀ
//�Posiciona na nota fiscal			         �
//���������������������������������������������
dbSelectArea("SF2")
//RetIndex("SF2")
//dbClearFilter()
SF2->( dbSetOrder(1) )
SF2->( dbSeek( xFilial("SF2") + AvKey(cNF,"F2_DOC") + AvKey(cSerie,"F2_SERIE") ) ) 

Pergunte("NFSIGW",.F.)   

	MV_PAR01 := SF2->F2_DOC
	MV_PAR02 := SF2->F2_DOC
	MV_PAR03 := SF2->F2_SERIE
	MV_PAR04 := 2	//[Operacao] NF de Saida
	MV_PAR05 := 1	//[Frente e Verso] Sim
	MV_PAR06 := 2	//[DANFE simplificado] Sim

//�������������������������������������������Ŀ
//�Par�metros de impress�o 				      �
//���������������������������������������������
lAdjustToLegacy := .F. // Inibe legado de resolu��o com a TMSPrinter
lDisableSetup   := .T. // Inibe tela de setup de impress�o
cFileDirect     := cFilePrint+".rel"
//cImpressora   := "IMPEXPEDICAO"
//cImpressora	:= "impexpedicao"
cImpressora	    := ""
lAmbPrint       := .F. // .F. Local .T. Server

nFlags   := PD_ISTOTVSPRINTER + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN
oSetup   := FWPrintSetup():New(nFlags, "DANFE")

If !lEnvColetor
	//�������������������������������������������Ŀ
	//�Configura��o de impress�o para PDF         �
	//���������������������������������������������
  	oDanfe   := FWMSPrinter():New(cFilePrint,6,lAdjustToLegacy,, lDisableSetup)// Para gera��o de PDF
Else
	//�������������������������������������������Ŀ
	//�Configura��o para impress�o direta         �
	//���������������������������������������������
	oDanfe := FWMSPrinter():New(cFileDirect,  2, lAdjustToLegacy, , lDisableSetup, , ,, lAmbPrint, , , ,1) // Para impress�o direta
	//oDanfe:cPrinter := cImpressora
	// ----------------------------------------------
	// Define saida de impress�o
	// ----------------------------------------------
EndIf

//�������������������������������������������Ŀ
//�Margens de impress�o				          �
//���������������������������������������������
oDanfe:SetResolution(78) //Tamanho estipulado para a Danfe
oDanfe:SetPortrait()
oDanfe:SetPaperSize(9)
oDanfe:SetMargin(20,20,20,20)
oDanfe:lServer := oSetup:GetProperty(PD_DESTINATION)==AMB_SERVER

//�������������������������������������������Ŀ
//�path de sa�da para o PDF			          �
//���������������������������������������������
If !lEnvColetor
	oDanfe:cPathPDF := __cTempTEMP
EndIf

//�������������������������������������������Ŀ
//�Impress�o da DANFE			             �
//���������������������������������������������
PUBLIC lAutoDanfe := .T.    

oDanfe:SetViewPDF(.F.)
//lGerou := U_PrtNfeSef(cIdEnt,          ,           , oDanfe, oSetup, cFilePrint  , .F.       , 1      )
lGerou := U_PrtNfeSef(cIdEnt,          ,           , oDanfe, oSetup, cFilePrint  ,,, .F.)

//�������������������������������������������Ŀ
//�Atualiza Flag de impress�o da DANFE		  �
//���������������������������������������������
If lGerou
	Reclock("SF2",.F.)
	SF2->F2_XXAUTNF := "I"
	SF2->(MsUnlock())
EndIf

If !lEnvColetor
//  	oDanfe:SetViewPDF(.F.)
// 	oDanfe:Preview()
Else
    oDanfe:Print()
    CONOUT("DANFE "+SF2->F2_DOC+" enviada � expedi��o na impressora: "+cImpressora)
EndIf

FreeObj(oDanfe)
oSetup := Nil

//�������������������������������������������Ŀ
//�Copia arquivo tempor�rio para destino PDF  �
//���������������������������������������������
If !lEnvColetor

	If File(__cTempTEMP+cFilePrint+".pdf")
		
		//�������������������������������������������Ŀ
		//�Copia DANFE para servidor						 �
		//���������������������������������������������
		__CopyFile(__cTempTEMP+cFilePrint+".pdf",__cPathPDF+cFilePrint+".pdf")
		cLPTDoc := cFilePrint+".pdf"
		
	Else
		
		CONOUT("Nota Fiscal "+cFilePrint+".PDF n�o copiada para o destino")
		
	EndIf

EndIf

Return cLPTDoc                                                                                        
                                                                                                                                                                                            