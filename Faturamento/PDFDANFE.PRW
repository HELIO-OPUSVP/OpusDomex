#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"            
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PDFDANFE ºAutor  ³Michel A. Sander    º Data ³  09/08/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para geração da DANFE automática em PDF             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
Local lLocalServ    := .F.		// Local de Gravação do PDF da DANFE (.T. = \system\DANFE_PDF\) (.F. = Pasta TEMP do usuario local)

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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Configuração de local de impressão         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFilePrint     := "DANFE_"+cNF+"_"+cSerie+"_"+Dtos(MSDate())+StrTran(Time(),":","")
nLocal         := If(fwGetProfString(cSession,"LOCAL","SERVER",.T.)=="SERVER",1,2 )
nOrientation   := If(fwGetProfString(cSession,"ORIENTATION","PORTRAIT",.T.)=="PORTRAIT",1,2)
cDevice        := If(Empty(fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.)),"PDF",fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.))
nPrintType     := aScan(aDevice,{|x| x == cDevice })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona na nota fiscal			         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Parâmetros de impressão 				      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lAdjustToLegacy := .F. // Inibe legado de resolução com a TMSPrinter
lDisableSetup   := .T. // Inibe tela de setup de impressão
cFileDirect     := cFilePrint+".rel"
//cImpressora   := "IMPEXPEDICAO"
//cImpressora	:= "impexpedicao"
cImpressora	    := ""
lAmbPrint       := .F. // .F. Local .T. Server

nFlags   := PD_ISTOTVSPRINTER + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN
oSetup   := FWPrintSetup():New(nFlags, "DANFE")

If !lEnvColetor
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Configuração de impressão para PDF         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  	oDanfe   := FWMSPrinter():New(cFilePrint,6,lAdjustToLegacy,, lDisableSetup)// Para geração de PDF
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Configuração para impressão direta         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oDanfe := FWMSPrinter():New(cFileDirect,  2, lAdjustToLegacy, , lDisableSetup, , ,, lAmbPrint, , , ,1) // Para impressão direta
	//oDanfe:cPrinter := cImpressora
	// ----------------------------------------------
	// Define saida de impressão
	// ----------------------------------------------
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Margens de impressão				          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDanfe:SetResolution(78) //Tamanho estipulado para a Danfe
oDanfe:SetPortrait()
oDanfe:SetPaperSize(9)
oDanfe:SetMargin(20,20,20,20)
oDanfe:lServer := oSetup:GetProperty(PD_DESTINATION)==AMB_SERVER

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³path de saída para o PDF			          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lEnvColetor
	oDanfe:cPathPDF := __cTempTEMP
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Impressão da DANFE			             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PUBLIC lAutoDanfe := .T.    

oDanfe:SetViewPDF(.F.)
//lGerou := U_PrtNfeSef(cIdEnt,          ,           , oDanfe, oSetup, cFilePrint  , .F.       , 1      )
lGerou := U_PrtNfeSef(cIdEnt,          ,           , oDanfe, oSetup, cFilePrint  ,,, .F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza Flag de impressão da DANFE		  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
    CONOUT("DANFE "+SF2->F2_DOC+" enviada á expedição na impressora: "+cImpressora)
EndIf

FreeObj(oDanfe)
oSetup := Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Copia arquivo temporário para destino PDF  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lEnvColetor

	If File(__cTempTEMP+cFilePrint+".pdf")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Copia DANFE para servidor						 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		__CopyFile(__cTempTEMP+cFilePrint+".pdf",__cPathPDF+cFilePrint+".pdf")
		cLPTDoc := cFilePrint+".pdf"
		
	Else
		
		CONOUT("Nota Fiscal "+cFilePrint+".PDF não copiada para o destino")
		
	EndIf

EndIf

Return cLPTDoc                                                                                        
                                                                                                                                                                                            