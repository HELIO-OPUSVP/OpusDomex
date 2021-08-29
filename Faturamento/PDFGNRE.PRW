#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

#DEFINE IMP_SPOOL 2
#DEFINE VBOX       080
#DEFINE HMARGEM    030

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥PDFGNRE   ∫Autor  ≥Michel A. Sander    ∫ Data ≥  04.05.17   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Gera guia GNRE em PDF (mas n„o imprime). Quem imprime È a  ∫±±
±±∫          ≥ funÁ„o LPTGNRE                                             ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User function PDFGNRE(cNumGnre, cNF, cSerie, cCliFor, cLoja)

Local aIndArq     := {}
Local oImpGNRE
Local nHRes       := 0
Local nVRes       := 0
Local nDevice
Local cFilePrint  := ""
Local oSetup
Local aDevice     := {}
Local nRet        := 0
Local cArqGuia    := ""
Local lLocalServ  := .F.		// Local de GravaÁ„o do PDF da DANFE (.T. = \system\DANFE_PDF\) (.F. = Pasta TEMP do usuario local)

PRIVATE __cPathPDF  := "\system\GNRE_PDF\"
PRIVATE __cTempTEMP := "\temp_anexos\" //AllTrim(GetTempPath()) 
PRIVATE cIdEnt    := "000002"

If Type("lMenuGuia") == "U"
	lMenuGuia := .F.
EndIf

cSession    := GetPrinterSession()

AADD(aDevice,"DISCO") // 1
AADD(aDevice,"SPOOL") // 2
AADD(aDevice,"EMAIL") // 3
AADD(aDevice,"EXCEL") // 4
AADD(aDevice,"HTML" ) // 5
AADD(aDevice,"PDF"  ) // 6

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Posiciona na guia NOTA FISCAL		         ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
dbSelectArea("SF2")
RetIndex("SF2")
dbClearFilter()
SF2->( dbSetOrder(1) )
SF2->( dbSeek( xFilial() + cNF ) )

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Posiciona na guia GNRE				         ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
dbSelectArea("SF6")
RetIndex("SF6")
dbClearFilter()
cTpOper  := "2"		// Nota Fiscal de Saida
cTpDoc   := "N"      // Tipo de Documento (N= Normal)
SF6->(dbSetOrder(3))
If SF6->(dbSeek(SF2->F2_FILIAL+cTpOper+cTpDoc+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
	
	//If Type("lMenuGuia") <> "U"
	If lMenuGuia
		
		nLocal  		:= if(fwGetProfString(cSession,"LOCAL","SERVER",.T.)=="SERVER",1,2 )
		nOrientation 	:= 1 //Retrato
		cDevice     	:= if(empty(fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.)),"PDF",fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.))
		nPrintType    := ascan(aDevice,{|x| x == cDevice })
		
		lAdjustToLegacy := .F. // Inibe legado de resoluÁ„o com a TMSPrinter
		oImpGNRE := FWMSPrinter():New(cFilePrint, IMP_PDF, lAdjustToLegacy, /*cPathInServer*/, .T.)
		
		// ----------------------------------------------
		// Cria e exibe tela de Setup Customizavel
		// OBS: Utilizar include "FWPrintSetup.ch"
		// ----------------------------------------------
		nFlags := PD_ISTOTVSPRINTER + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN + PD_DISABLEORIENTATION
		
		
		if ( !oImpGNRE:lInJob )
			oSetup := FWPrintSetup():New(nFlags, "GNRE")
			// ----------------------------------------------
			// Define saida
			// ----------------------------------------------
			oSetup:SetPropert(PD_PRINTTYPE   , nPrintType)
			oSetup:SetPropert(PD_ORIENTATION , nOrientation)
			oSetup:SetPropert(PD_DESTINATION , nLocal)
			oSetup:SetPropert(PD_MARGIN      , {60,60,60,60})
			oSetup:SetPropert(PD_PAPERSIZE   , 2)
			
		endif
		
		// Pressionado bot„o OK na tela de Setup
		if oSetup:Activate() == PD_OK // PD_OK =1
			
			//Salva os Parametros no Profile
			
			fwWriteProfString( cSession, "LOCAL"      , If(oSetup:GetProperty(PD_DESTINATION)==1 ,"SERVER"    ,"CLIENT"    ), .T. )
			fwWriteProfString( cSession, "PRINTTYPE"  , If(oSetup:GetProperty(PD_PRINTTYPE)==2   ,"SPOOL"     ,"PDF"       ), .T. )
			fwWriteProfString( cSession, "ORIENTATION", If(oSetup:GetProperty(PD_ORIENTATION)==1 ,"PORTRAIT"  ,"LANDSCAPE" ), .T. )
			
			// Configura o objeto de impress„o com o que foi configurado na interface.
			oImpGNRE:setCopies( val( oSetup:cQtdCopia ) )
			
			U_DOMGNRE(cIdEnt, oImpGNRE, oSetup, cFilePrint)
			cArqGuia := ""
		else
			//msginfo("RelatÛrio cancelado pelo usu·rio.")
			cArqGuia := ""
			return ( cArqGuia )
		endif
		
		oImpGNRE:Preview()
		FreeObj(oImpGNRE)
		oSetup := Nil
		
	else
		
		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ConfiguraÁ„o de local de impress„o         ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		SE2->(dbSetOrder(1))
		If SE2->(dbSeek(xFilial()+cNumGnre+SPace(1)+PADR("TX",3)+"ESTADO"+"00"))
			cFilePrint  := "GNRE_"+SE2->E2_FILIAL+"_"+SE2->E2_PREFIXO+"_"+SE2->E2_NUM+"_"
			cFilePrint  += SE2->E2_PARCELA+"_"+SE2->E2_TIPO+"_"+SE2->E2_FORNECE+"_"+SE2->E2_LOJA
			cFilePrint  := StrTran(cFilePrint," ","#")
		Else
			cFilePrint  := "GNRE_"+cNF+"_"+cSerie+"_"+Dtos(MSDate())+StrTran(Time(),":","")
		EndIf
		
		nLocal       	:= If(fwGetProfString(cSession,"LOCAL","SERVER",.T.)=="SERVER",1,2 )
		nOrientation 	:= If(fwGetProfString(cSession,"ORIENTATION","PORTRAIT",.T.)=="PORTRAIT",1,2)
		cDevice     	:= If(Empty(fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.)),"PDF",fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.))
		nPrintType     := aScan(aDevice,{|x| x == cDevice })
		
		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ConfiguraÁ„o de impress„o para PDF         ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		lAdjustToLegacy := .F. // Inibe legado de resoluÁ„o com a TMSPrinter
		nFlags   := PD_ISTOTVSPRINTER + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN
		oSetup   := FWPrintSetup():New(nFlags, "GNRE")
		oImpGNRE := FWMSPrinter():New(cFilePrint,6,.F.,,.T., , , , , , .F.,.F.)
		
		oImpGNRE:SetResolution(78) //Tamanho estipulado para a GNRE
		oImpGNRE:SetPortrait()
		oImpGNRE:SetPaperSize(9)
		oImpGNRE:SetMargin(60,60,60,60)
		oImpGNRE:cPathPDF := __cTempTEMP
		oImpGNRE:cFilePrint := __cTempTEMP + cFilePrint + ".rel"

		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥Verifica se j· existe uma impress„o        ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		If File(__cTempTEMP+cFilePrint+".pdf")
		   FErase(__cTempTEMP+cFilePrint+".pdf")
		EndIf		

		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥Impress„o da GNRE   				             ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		PUBLIC lAutoImpGNRE := .T.
		U_DOMGNRE(cIdEnt, oImpGNRE, oSetup, cFilePrint)
		oImpGNRE:SetViewPDF(.f.)
		oImpGNRE:Preview()
		FreeObj(oImpGNRE)
		oSetup := Nil
		
		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥Copia arquivo tempor·rio para destino PDF  ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

		If File(__cTempTEMP+cFilePrint+".pdf")
			__CopyFile(__cTempTEMP+cFilePrint+".pdf",__cPathPDF+cFilePrint+".pdf")
			If lLocalServ
				cLPTDoc := __cPathPDF+cFilePrint+".pdf"
				If File("D:\TOTVS12\01-Oficial\Protheus_Data\"+cLPTDoc)
					Reclock("SF6",.F.)
					SF6->F6_OBSERV := "GUIA IMPRESSA"
					SF6->(MsUnlock())
					cArqGuia := cFilePrint+".pdf"
				Else
					cArqGuia := cFilePrint+".pdf"
				EndIf
			Else	
				cLPTDoc := __cTempTEMP+cFilePrint+".pdf"
				If File(cLPTDoc)
					Reclock("SF6",.F.)
					SF6->F6_OBSERV := "GUIA IMPRESSA"
					SF6->(MsUnlock())
					cArqGuia := cFilePrint+".pdf"
				Else
					cArqGuia := cFilePrint+".pdf"
				EndIf
			EndIf	
		Else
			CONOUT("Nota Fiscal "+cFilePrint+".PDF n„o copiada para o destino")
			cArqGuia := ""
		EndIf

	endif
	
endif

Return ( cArqGuia )

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥DOMGNRE   ∫Autor  ≥Michel A. Sander    ∫ Data ≥  04.05.17   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Busca as guias autorizadas	                                ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function DOMGNRE(cIdEnt, oImpGNRE, oSetup, cFilePrint)

local lExistGnre := .F.
Local lEnd       := .T.
local aAreaSF6		:= {}
local aPerg   		:= {}
local aGnre			:= {}
local aArea			:= GetArea()
local aParam  		:= {SF6->F6_NUMERO,SF6->F6_NUMERO,SF6->F6_EST}
local cNaoAut		:= ''
local cAliasGNRE	:= GetNextAlias()
local cGnreIni		:= ''
local cGnreFim		:= ''
local cUFGnre		:= ''
local cWhere		:= ''
local cAutoriza  	:= ''
local cCondicao		:= ''
local cIndex	 	:= ''
local cParGnreImp	:= SM0->M0_CODIGO+SM0->M0_CODFIL+"FISA119IMP"
local cTela			:= "Impress„o GNRE "
local cIdGuia		:= ''
local cXmlGnre		:= ''
local lQuery		:= .F.
local lOkParam		:= .F.
local oGnre			:= nil
local nLenNotas
local nIndex	:= 0
local nX			:= 0
local lOkParam := .T.

private nConsNeg := 0.4 // Constante para concertar o c·lculo retornado pelo GetTextWidth para fontes em negrito.
private nConsTex := 0.5 // Constante para concertar o c·lculo retornado pelo GetTextWidth.
private PixelX   := oImpGNRE:nLogPixelX()
private PixelY   := oImpGNRE:nLogPixelY()

MV_PAR01 := aParam[1]
MV_PAR02 := aParam[2]
MV_PAR03 := aParam[3]

cGnreIni	:= alltrim(MV_PAR01)
cGnreFim	:= alltrim(MV_PAR02)
cUFGnre	:= alltrim(MV_PAR03)

dbSelectArea("SF6")
dbSetOrder(1)

lQuery := .T.
cWhere := "%"
cWhere += "SF6.F6_FILIAL = '"+xFilial ("SF6")+"' AND"
cWhere += " SF6.F6_NUMERO>= '"+ cGnreIni +"' AND SF6.F6_NUMERO<= '"+ cGnreFim +"' "
if ! empty(cUFGnre)
	cWhere		+= " AND SF6.F6_EST = '" + cUFGnre + "' "
endif
cWhere		+= " AND SF6.F6_GNREWS = 'S' "  //Somente autorizada
cWhere		+= " AND SF6.D_E_L_E_T_ = ''"
cWhere		+= ' %'

BeginSql Alias cAliasGNRE
	SELECT	* FROM  %Table:SF6% SF6 WHERE %Exp:cWhere% ORDER BY %Order:SF6%
EndSql

while !(cAliasGNRE)->(Eof())
	
	aadd(aGnre,{})
	aadd(atail(aGnre),(cAliasGNRE)->F6_IDTSS)  //id TSS
	aadd(atail(aGnre),(cAliasGNRE)->F6_CDBARRA)//CÛdigo de Barras
	aadd(atail(aGnre),(cAliasGNRE)->F6_NUMCTRL)//CÛdigo de Barras
	
	nRecno	:= (cAliasGNRE)->R_E_C_N_O_
	
	dbselectarea('SF6')
	//Tratamento para campo Memo
	SF6->(dbgoto(nRecno))
	
	aadd(atail(aGnre),SF6->F6_XMLENV) //XML enviado para TSS
	
	dbclosearea('SF6')
	
	(cAliasGNRE)->(dbSkip())
	
enddo

if len(aGnre) > 0
	aAreaSF6 := SF6->(GetArea())
	
	for nX := 1 to len(aGnre)
		
		if ! empty( aGnre[nX][2])  //CÛdigo de Barras
			
			cIdGuia  := alltrim(aGnre[nX][1])
			cAutoriza:= alltrim(aGnre[nX][2])
			cNumCtrl := alltrim(aGnre[nX][3])
			cXmlGnre := alltrim(aGnre[nX][4])   //xml enviado TSS
			
			ImpDetGnre(@oImpGNRE,cAutoriza,cXmlGnre,cNumCtrl)
			lExistGnre := .T.
			
			oGnre      := nil
		else
			
			cNaoAut += aGnre[nX][1]+aGnre[nX][2]+CRLF
			
		endif
		
	next nX
	
	RestArea(aAreaSF6)
	delclassintf()
endif

if !lQuery
	dbclearfilter()
	ferase(cIndex+OrdBagExt())
endif

RestArea(aArea)
return(.T.)

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥IMPDETGNRE∫Autor  ≥Michel A. Sander    ∫ Data ≥  04.05.17   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ GeraÁ„o do PDF da GNRE                                     ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

static function ImpDetGnre(oImpGNRE, cAutoriza, cXmlGnre, cNumCtrl)

local oGnreXml		:= nil
local cCab			:= 'Guia Nacional de Recolhimento de Tributos Estaduais - GNRE'
local cUfFav		:= ''
local cCodRec		:= ''
local cRazEmi		:= ''
local cCnpjCpfEm	:= ''
local cEndEmi		:= ''
local cMunEmi		:= ''
local cUfEmi		:= ''
local cCepEmi		:= ''
local cTelEmi		:= ''
local cDocOrig		:= ''
local cCnpjCpfDs	:= ''
local cMunDest		:= ''
local cPerRef		:= ''
local cParcela		:= ''
local cValPrinc	:= ''
local cConvenio	:= ''
local cProduto		:= ''
local cAtuMon		:= ''
local cInfCompl	:= ''
local cJuros		:= ''
local cMulta		:= ''
local cTotRec		:= ''
local cVia			:= ''
local cDtVenc		:= ''

local nX				:= 0
local nBox1			:= 0
local nBox2			:= 0
local nBox3			:= 0
local nBox4			:= 0
local nSay1			:= 0
local nSay2			:= 0

private oFont07   := TFont():New('Arial',07,07,,.F.,,,,.T.,.F.)	//Fonte Arial 07
private oFont07N  := TFont():New('Arial',07,07,,.T.,,,,.T.,.F.)	//Fonte Arial 07
private oFont08	:= TFont():New('Arial',08,08,,.F.,,,,.T.,.F.)
private oFont08N	:= TFont():New('Arial',08,08,,.T.,,,,.T.,.F.)
private oFont10	:= TFont():New('Arial',10,10,,.F.,,,,.T.,.F.)
private oFont10N	:= TFont():New('Arial',10,10,,.T.,,,,.T.,.F.)
private oFont12N  := TFont():New('Arial',12,12,,.T.,,,,.T.,.F.)	//Fonte Arial 12 Negrito
private oFont14N  := TFont():New('Arial',14,14,,.T.,,,,.T.,.F.)	//Fonte Arial 14 Negrito

//Inicializacao da pagina do objeto grafico
oImpGNRE:StartPage()
nHPage := oImpGNRE:nHorzRes()
nHPage *= (300/PixelX)
nHPage -= HMARGEM
nVPage := oImpGNRE:nVertRes()
nVPage *= (300/PixelY)
nVPage -= VBOX

for nX:= 1 to 2 //Gera via Banco e Contribuinte
	
	//Alimentando as vari·veis
	if ! empty( cXmlGnre )
		oGnreXml := XmlParser(cXmlGnre,'','','')
	else //Tratamento casa haja algum erro no retorno do xml
		Alert('N„o h· dados para imprimir.')
		return
	endif
	
	// ----------------------------------------------
	// Vari·veis de Posicionamento
	// ----------------------------------------------
	nBox1	:= iif(nX==1,0,nBox1 + 50)
	nBox2	:= 000
	nBox3	:= iif(nX==1, 20, nBox3 + 50)
	nBox4	:= 450
	
	nSay1	:= iif(nX==1, 13, nBox1 + 13)
	nSay2	:= iif(nX==1, 80, nBox2 + 80)
	
	
	// ----------------------------------------------
	// BOX: CabeÁalho
	// ----------------------------------------------
	oImpGNRE:Box(nBox1,000,nBox3,450,'-6')
	oImpGNRE:Say(nSay1, nSay2, cCab, oFont12N)
	
	// ----------------------------------------------
	// BOX: UF Favorecida
	// ----------------------------------------------
	cUfFav 	:= alltrim( oGnreXml:_gnre:_identgnre:_uf:text )
	
	nSay1	:= nBox1 + 8
	nSay1A	:= nBox1 + 16
	
	oImpGNRE:Box(nBox1,450,nBox3,520,'-6')
	oImpGNRE:Say(nSay1, 453, 'UF Favorecida', oFont07N)
	oImpGNRE:Say(nSay1A, 453, cUfFav, oFont08)
	
	// ----------------------------------------------
	// BOX: CÛdigo da Receita
	// ----------------------------------------------
	cCodRec	:= alltrim( oGnreXml:_gnre:_identgnre:_receita:text )
	
	oImpGNRE:Box(nBox1,520,nBox3,600,'-6')
	oImpGNRE:Say(nSay1, 523, 'CÛdigo da Receita', oFont07N)
	oImpGNRE:Say(nSay1A, 523, cCodRec, oFont08)
	
	
	// ----------------------------------------------
	// BOX: Dados do Contribuinte Emitente
	// ----------------------------------------------
	cRazEmi	:= alltrim( oGnreXml:_gnre:_emitente:_nome:text )
	
	//cnpj/cpf/ie
	if ! empty( oGnreXml:_gnre:_emitente:_cnpjcpf:text )
		cCnpjCpfEm	:= transform(oGnreXml:_gnre:_emitente:_cnpjcpf:text,iif(len(oGnreXml:_gnre:_emitente:_cnpjcpf:text)<>14,"@r 999.999.999-99","@r 99.999.999/9999-99"))
	else
		cCnpjCpfEm	:= alltrim( oGnreXml:_gnre:_emitente:_ie:text )
	endif
	
	cEndEmi	:= alltrim( oGnreXml:_gnre:_emitente:_endereco:text )
	cMunEmi	:= alltrim( oGnreXml:_gnre:_emitente:_descmun:text )
	cUfEmi		:= alltrim( oGnreXml:_gnre:_emitente:_uf:text )
	cCepEmi	:= alltrim( oGnreXml:_gnre:_emitente:_cep:text )
	
	cTelEmi	:= alltrim( oGnreXml:_gnre:_emitente:_telefone:text )
	cTelEmi	:= transform(cTelEmi, iif(len(cTelEmi) == 11, '@R (99) 99999-9999', '@R (99) 9999-9999' ))
	
	oImpGNRE:Box(nBox1 + 20,000,nBox3 + 060,450,'-6')
	oImpGNRE:Say(nBox1 + 28, 0180, 'Dados do Contribuinte Emitente' , oFont07N)
	oImpGNRE:Say(nBox1 + 36, 0005, 'Raz„o Social:' , oFont07N)
	oImpGNRE:Say(nBox1 + 46, 0005, cRazEmi , oFont08)
	oImpGNRE:Say(nBox1 + 36, 0350, 'CNPJ/CPF/Insc. Est.:' , oFont07N)
	oImpGNRE:Say(nBox1 + 46, 0350, cCnpjCpfEm , oFont08)
	oImpGNRE:Say(nBox1 + 54, 0005, 'EndereÁo:' , oFont07N)
	oImpGNRE:Say(nBox1 + 54, 0045, cEndEmi , oFont08)
	oImpGNRE:Say(nBox1 + 64, 0005, 'MunicÌpio:' , oFont07N)
	oImpGNRE:Say(nBox1 + 64, 0045, cMunEmi , oFont08)
	oImpGNRE:Say(nBox1 + 64, 0350, 'UF:' , oFont07N)
	oImpGNRE:Say(nBox1 + 64, 0365, cUfEmi , oFont08)
	oImpGNRE:Say(nBox1 + 74, 0005, 'CEP:' , oFont07N)
	oImpGNRE:Say(nBox1 + 74, 0025, cCepEmi , oFont08)
	oImpGNRE:Say(nBox1 + 74, 0350, 'Telefone:' , oFont07N)
	oImpGNRE:Say(nBox1 + 74, 0385, cTelEmi , oFont08)
	
	// ----------------------------------------------
	// BOX: N˙mero de Controle
	// ----------------------------------------------
	oImpGNRE:Box(nBox1 + 20,450,nBox3 + 020,600,'-6')
	oImpGNRE:Say(nBox1 + 28, 0453, 'N∫ de Controle', oFont07N)
	oImpGNRE:Say(nBox1 + 36, 0528, cNumCtrl, oFont08)
	
	// ----------------------------------------------
	// BOX: Data de Vencimento
	// ----------------------------------------------
	cDtVenc := substr(oGnreXml:_gnre:_identgnre:_vencimento:text,7,2)+'/'+ substr(oGnreXml:_gnre:_identgnre:_vencimento:text,5,2)+'/'+ substr(oGnreXml:_gnre:_identgnre:_vencimento:text,1,4)
	
	oImpGNRE:Box(nBox1 + 40,450, nBox3 + 040,600,'-6')
	oImpGNRE:Say(nBox1 + 48, 0453, 'Data de Vencimento', oFont07N)
	oImpGNRE:Say(nBox1 + 56, 0558, cDtVenc, oFont08)
	
	// ----------------------------------------------
	// BOX: N∫ Documento de Origem
	// ----------------------------------------------
	cDocOrig := transform(oGnreXml:_gnre:_identgnre:_docorig:text,'@R 999999999')
	
	oImpGNRE:Box(nBox1 + 60,450,nBox3 +  060,600,'-6')
	oImpGNRE:Say(nBox1 + 68, 0453, 'N∫ Documento de Origem', oFont07N)
	oImpGNRE:Say(nBox1 + 76, 0558, cDocOrig, oFont08)
	
	
	// ----------------------------------------------
	// BOX: Dados do Destinat·rio
	// ----------------------------------------------
	//cnpj/cpf/ie
	if ! empty( oGnreXml:_gnre:_destinatario:_cnpjcpf:text )
		cCnpjCpfDs	:= transForm(oGnreXml:_gnre:_destinatario:_cnpjcpf:text,iif(len(oGnreXml:_gnre:_destinatario:_cnpjcpf:text)<>14,"@r 999.999.999-99","@r 99.999.999/9999-99"))
	else
		cCnpjCpfDs	:= alltrim( oGnreXml:_gnre:_destinatario:_ie:text )
	endif
	
	cMunDest := alltrim( oGnreXml:_gnre:_destinatario:_descmun:text )
	
	
	oImpGNRE:Box(nBox1 + 080, 000, nBox3 + 090, 450, '-6')
	oImpGNRE:Say(nBox1 + 088, 0180, 'Dados do Destinat·rio' , oFont07N)
	oImpGNRE:Say(nBox1 + 096, 0005, 'CNPJ/CPF/Insc. Est.:' , oFont07N)
	oImpGNRE:Say(nBox1 + 096, 0080, cCnpjCpfDs , oFont08)
	oImpGNRE:Say(nBox1 + 106, 0005, 'MunicÌpio:' , oFont07N)
	oImpGNRE:Say(nBox1 + 106, 0080, cMunDest , oFont08)
	
	
	// ----------------------------------------------
	// BOX: PerÌodo de ReferÍncia
	// ----------------------------------------------
	cPerRef := alltrim( oGnreXml:_gnre:_referencia:_mes:text ) + '/' + alltrim( oGnreXml:_gnre:_referencia:_ano:text )
	
	oImpGNRE:Box(nBox1 + 080,450,nBox3 + 080,530,'-6')
	oImpGNRE:Say(nBox1 + 088, 0453, 'PerÌodo de ReferÍncia', oFont07N)
	oImpGNRE:Say(nBox1 + 096, 0500, cPerRef, oFont08)
	
	
	// ----------------------------------------------
	// BOX: Parcela
	// ----------------------------------------------
	cParcela := alltrim( oGnreXml:_gnre:_referencia:_parcela:text )
	
	oImpGNRE:Box(nBox1 + 080,530,nBox3 + 080,600,'-6')
	oImpGNRE:Say(nBox1 + 088, 0533, 'Parcela', oFont07N)
	oImpGNRE:Say(nBox1 + 096, 0588, cParcela, oFont08)
	
	
	// ----------------------------------------------
	// BOX: Valor Principal
	// ----------------------------------------------
	cMascara	:= '@e 9,999,999,999,999.99'
	cValPrinc	:= PadL( 'R$ '+ alltrim(transform(val(oGnreXml:_gnre:_valores:_principal:text), cMascara)),len(cMascara))
	
	oImpGNRE:Box(nBox1 + 100,450,nBox3 + 100,600,'-6')
	oImpGNRE:Say(nBox1 + 108, 0453, 'Valor Principal', oFont07N)
	oImpGNRE:SayAlign( nBox1 + 108,0500,cValPrinc,oFont08, 96, 19, , 1)
	
	
	// ----------------------------------------------
	// BOX: Reservado a FiscalizaÁ„o
	// ----------------------------------------------
	cConvenio	:= alltrim( oGnreXml:_gnre:_identgnre:_convenio:text )
	cProduto	:= alltrim( oGnreXml:_gnre:_identgnre:_produto:text )
	
	oImpGNRE:Box(nBox1 + 110, 000, nBox3 + 130, 450, '-6')
	oImpGNRE:Say(nBox1 + 118, 0180, 'Reservado a FiscalizaÁ„o' , oFont07N)
	oImpGNRE:Say(nBox1 + 128, 0005, 'ConvÍnio/Protocolo:' , oFont07N)
	oImpGNRE:Say(nBox1 + 128, 0080, cConvenio , oFont08)
	oImpGNRE:Say(nBox1 + 138, 0005, 'Produto:' , oFont07N)
	oImpGNRE:Say(nBox1 + 138, 0080, cProduto , oFont08)
	
	// ----------------------------------------------
	// BOX: AtualizaÁ„o Monet·ria
	// ----------------------------------------------
	cAtuMon	:= PadL( 'R$ '+ alltrim(transform(val(oGnreXml:_gnre:_valores:_atumonetaria:text), cMascara)),len(cMascara))
	
	oImpGNRE:Box(nBox1 + 120,450,nBox3 + 120,600,'-6')
	oImpGNRE:Say(nBox1 + 128, 0453, 'AtualizaÁ„o Monet·ria', oFont07N)
	oImpGNRE:SayAlign( nBox1 + 128,0500,cAtuMon,oFont08, 96, 19, , 1)
	
	// ----------------------------------------------
	// BOX: InformaÁıes Complementares
	// ----------------------------------------------
	cInfCompl := alltrim( oGnreXml:_gnre:_identgnre:_informacoes:text )
	
	oImpGNRE:Box(nBox1 + 140, 000, nBox3 + 180, 450, '-6')
	oImpGNRE:Say(nBox1 + 148, 0005, 'InformaÁıes Complementares' , oFont07N)
	oImpGNRE:Say(nBox1 + 158, 0005, cInfCompl , oFont08)
	oImpGNRE:Say(nBox1 + 194, 0005, 'Documento V·lido para pagamento atÈ ' , oFont08N)
	oImpGNRE:Say(nBox1 + 194, 0200, cDtVenc , oFont08)
	
	// ----------------------------------------------
	// BOX: Juros
	// ----------------------------------------------
	cJuros:= PadL( 'R$ '+ alltrim(transform(val(oGnreXml:_gnre:_valores:_juros:text), cMascara)),len(cMascara))
	
	oImpGNRE:Box(nBox1 + 140,450,nBox3 + 140,600,'-6')
	oImpGNRE:Say(nBox1 + 148, 0453, 'Juros', oFont07N)
	oImpGNRE:SayAlign( nBox1 + 148,0500,cJuros,oFont08, 96, 19, , 1)
	
	// ----------------------------------------------
	// BOX: Multa
	// ----------------------------------------------
	cMulta:= PadL( 'R$ '+ alltrim(transform(val(oGnreXml:_gnre:_valores:_multa:text), cMascara)),len(cMascara))
	
	oImpGNRE:Box(nBox1 + 160,450,nBox3 + 160,600,'-6')
	oImpGNRE:Say(nBox1 + 168, 0453, 'Multa', oFont07N)
	oImpGNRE:SayAlign( nBox1 + 168,0500,cMulta,oFont08, 96, 19, , 1)
	
	// ----------------------------------------------
	// BOX: Total a Recolher
	// ----------------------------------------------
	cTotRec:= PadL( 'R$ '+ alltrim(transform(val(oGnreXml:_gnre:_valores:_total:text), cMascara)),len(cMascara))
	
	oImpGNRE:Box(nBox1 + 180,450,nBox3 + 180,600,'-6')
	oImpGNRE:Say(nBox1 + 188, 0453, 'Total a Recolher', oFont07N)
	oImpGNRE:SayAlign( nBox1 + 188,0500,cTotRec,oFont08, 96, 19, , 1)
	
	// ----------------------------------------------
	// BOX: CÛdigo de Barras gravado na GUIA
	// ----------------------------------------------
	cCodBar  := alltrim(cAutoriza)
	cCodBar1 := substr(cCodBar,1,11) + ' '+ substr(cCodBar,12,1) + ' ' + substr(cCodBar,13,11) + ' ' + substr(cCodBar,24,1) + ' '+ substr(cCodBar,25,11) + ' ' +substr(cCodBar,36,1) + ' ' + substr(cCodBar,37,11) + ' ' + substr(cCodBar,48,1)
	
	// ----------------------------------------------
	// BOX: Codigo de Barras para impress„o sem digito
	// ----------------------------------------------
	cCodBar2 := substr(cCodBar,1,11)  // Bloco 1
	cCodBar2 += substr(cCodBar,13,11) // Bloco 2
	cCodBar2 += substr(cCodBar,25,11) // Bloco 3
	cCodBar2 += substr(cCodBar,37,11) // Bloco 4
	
	oImpGNRE:say(nBox1 + 212, 0035, cCodBar1 , oFont10N)
	nFontSize := 40
	oImpGNRE:Code128C(nBox1 + 255,0005,Alltrim(cCodBar2), nFontSize )
	
	//Via Boleto
	if nX == 1
		oImpGNRE:say(nBox1 + 215, 0555, '1™ via - Banco' , oFont07)
	else
		oImpGNRE:say(nBox1 + 215, 0540, '2™ via - Contribuinte' , oFont07)
	endif
	
	//Atribuo a ultima posiÁ„o no nBox 1 para a via do contribuinte
	
	if nX == 1
		//linha pontilhada
		oImpGNRE:say(nBox1 + 300, 0000, replicate(' - ',100) , oFont07)
		
		nBox1 := 280
		nBox3 += 280
	endif
	
next

oImpGNRE:EndPage()

return(.T.)
