#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"             
#INCLUDE "APWIZARD.CH"
#INCLUDE "FILEIO.CH"    
#INCLUDE "APWEBSRV.CH"         
#INCLUDE "RPTDEF.CH"                                               
#INCLUDE "FWPrintSetup.ch"          
                                        
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFISA95   ºAutor  ³Michel A. Sander    º Data ³  05/04/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Menu de envio da GNRE padrão DOMEX                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFISA95()

local aArea       := GetArea()
local lRetorno    := .T.
local lOk         := .F.
local lRet        := .F.                      
local lRetCFG     := .F.

private aFilBrw   := {}
private cURL      := Padr(GetNewPar("MV_SPEDURL","http://"),250)
private cInscMun  := Alltrim(SM0->M0_INSCM)
private cIdEnt    := FSA095IDEnt()
private cVerTss   := ""
private lBtnFiltro:= .F.
private oWS		   := Nil
private oRetorno  := Nil 
private oXml	   := Nil

//Realiza Conexão com TSS

oWs:= WsSpedCfgNFe():New()
oWs:cUSERTOKEN      := "TOTVS"
oWs:cID_ENT         := cIdEnt
oWS:_URL            := AllTrim(cURL)+"/SPEDCFGNFe.apw"
lOk                 := oWs:CfgTSSVersao()

if lOk
	cVerTss := oWs:cCfgTSSVersaoResult 
else
	Aviso("GNRE",iif(empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"Ok"},3)
	//Realiza a configuração do Wizard TSS
	FISA095CFG()  
	return
endif

while lRetorno
	lBtnFiltro:= .F.
    lRetorno := RFISA95Brw()
    if !lBtnFiltro
    	exit
    endif
enddo
RestArea(aArea)       			

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFISA95   ºAutor  ³Michel A. Sander    º Data ³  05/04/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Browse do SF6							                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static function RFISA95Brw()

local oBrw			:= FWmBrowse():New()

local aArea 		:= GetArea()
local aCores		:= {}
local cFiltro		:= ''
local cFiltroBrw	:= ''
local lRetorno 		:= .T.
local lGnreWS		:= IF( SF6->(FieldPos("F6_GNREWS"))  > 0, .T., .F. )
local lRecibo		:= IF( SF6->(FieldPos("F6_RECIBO"))  > 0, .T., .F. ) //SF6->(ColumnPos("F6_RECIBO"))
local lAmbiente		:= IF( SF6->(FieldPos("F6_AMBIWS"))  > 0, .T., .F. ) //SF6->(ColumnPos("F6_AMBIWS"))
local lIdTSS		:= IF( SF6->(FieldPos("F6_IDTSS"))   > 0, .T., .F. ) //SF6->(ColumnPos("F6_IDTSS" ))
local lNumCtr		:= IF( SF6->(FieldPos("F6_NUMCTRL")) > 0, .T., .F. ) //SF6->(ColumnPos("F6_NUMCTRL"))
local lCodBarras	:= IF( SF6->(FieldPos("F6_CDBARRA")) > 0, .T., .F. ) //SF6->(ColumnPos("F6_CDBARRA"))
local lXMLEnv		:= IF( SF6->(FieldPos("F6_XMLENV"))  > 0, .T., .F. ) //SF6->(ColumnPos("F6_XMLENV"))


private cUF	   	:= ''
private cFilDe  	:= ''
private cFilAte 	:= ''


//Verifico primeiramente se a base de Dados contém o campo F6_GNREWS (Flag da Gnre Via Web Service).
dbSelectArea("SF6")
iF  AliasIndic("SF6") 
	if !(lGnreWS .And. lRecibo .And. lAmbiente .And. lIdTSS .and. lNumCtr .and. lCodBarras .and. lXMLEnv) 
		help("",1,"Help","Help","AliasSF6",1,0)
		return
	endif
else
	help("",1,"Help","Help","AliasSF6",1,0) 
	return
endif
	
//Montagem das perguntas 
if pergunte("FSA095",.T.)

	cDataDe	:= DtoS( MV_PAR01 )	//Data De:
	cDataAte	:= DtoS( MV_PAR02	)	//Data De:
	cFiltro	:= cValtoChar( MV_PAR03 )	//Filtra?# 1 - Sem Filtro # 2 - Transmitidas# 3 - Não Transmitidas #4-Autorizadas #5-Não Autorizadas
	cUF			:= MV_PAR04
		
	cFiltroBrw :='F6_FILIAL == "' + xFilial('SF6') + '"'
	cFiltroBrw += '.AND. F6_DTARREC >= STOD("'+ cDataDe + '") .AND. F6_DTARREC <= STOD("' + cDataAte + '") '      
   //	cFiltroBrw += '.AND. F6_DTARREC >= CTOD("'+SUBSTR(cDataDe,7,2)+'/'+SUBSTR(cDataDe,5,2)+"/"+SUBSTR(cDataDe,1,4)+'") .AND. F6_DTARREC <= CTOD("'+SUBSTR(cDataAte,7,2)+'/'+SUBSTR(cDataAte,5,2)+"/"+SUBSTR(cDataAte,1,4)+'") '      
	cFiltroBrw += '.AND. F6_TIPOIMP $ "3-B" ' //ICMS ST e DIFAL #FECP DIFAL
	
	//Filtro	
	if cFiltro == "2" 			//"2-Transmitidas"
		cFiltroBrw +=  '.AND. F6_GNREWS $ "T"'
	elseif cFiltro == "3" 		//"3-Não Transmitidas"
		cFiltroBrw += '.AND. F6_GNREWS == " " '
	elseif cFiltro == "4" 		//"4-Autorizadas
		cFiltroBrw += '.AND. F6_GNREWS == "S" '
	elseif cFiltro == "5" 		//"4-Não Autorizadas
		cFiltroBrw += '.AND. F6_GNREWS == "N" '	
	endif	
	
	
	//Uf
	if !empty(cUF)
		cFiltroBrw += '.AND. F6_EST == "' + cUF + '"'
	endif
	
			
	oBrw := FWMBrowse():New()
	oBrw:SetAlias( "SF6" )
	oBrw:SetDescription( "Guia Nacional do Recolhimento - Web Service " + cIdEnt ) 
	oBrw:SetFilterDefault( cFiltroBrw )
	
	oBrw:AddLegend( "F6_GNREWS==' '", "BLUE"	,	"GNRE Não Transmitida" )
	oBrw:AddLegend( "F6_GNREWS=='T'", "YELLOW", 	"GNRE Transmitida"	  )
	oBrw:AddLegend( "F6_GNREWS=='S'", "GREEN"	, 	"GNRE Autorizada"		  )
	oBrw:AddLegend( "F6_GNREWS=='N'", "BLACK"	, 	"GNRE Não Autorizada"  )
	oBrw:SetMenuDef( 'RFISA95' )	
	oBrw:Activate()
endif

RestArea(aArea) 
return

//-------------------------------------------------------------------
/*/{Protheus.doc} MenuDef
Funcao generica MVC com as opcoes de menu

@author Simone Oliveira
@since 24.06.2015
@version 1.0
/*/
//-------------------------------------------------------------------
static function MenuDef()   

local aRotina := {}

	ADD OPTION aRotina TITLE 'Visualizar' 		ACTION 'VIEWDEF.FISA095'	OPERATION 2  ACCESS 0 
	ADD OPTION aRotina TITLE 'Ambiente' 		ACTION 'Fisa095Amb'			OPERATION 7  ACCESS 0  
	ADD OPTION aRotina TITLE 'Transmitir' 		ACTION 'Fisa095Trans'		OPERATION 8  ACCESS 0 
	ADD OPTION aRotina TITLE 'Wiz. Config.' 	ACTION 'Fisa095CFG'	 		OPERATION 9  ACCESS 0 
	ADD OPTION aRotina TITLE 'Monitor' 	   		ACTION 'Fisa095Mnt'	   	OPERATION 10 ACCESS 0
	ADD OPTION aRotina TITLE 'Inf. Extras' 		ACTION 'Fisa095Ext'	   	OPERATION 11 ACCESS 0
	ADD OPTION aRotina TITLE 'Impressao'	 	ACTION 'U_Imp095GNRE'  	   OPERATION 12 ACCESS 0
	
		
return aRotina 

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Funcao generica MVC do model

@return oModel - Objeto do Modelo MVC

@since 24.06.2015
@version 1.0
/*/
//-------------------------------------------------------------------
static function ModelDef()

local oStru	:=	FWFormStruct(1, 'SF6')
local oModel:=	MPFormModel():New('FISA095')


	oModel	:=	MPFormModel():New('FISA095MOD', ,{ |oModel| ValidForm(oModel) }  )
	
	oModel:AddFields( 'FISA095MOD' ,, oStru )	   
	
	oModel:SetPrimaryKey({"F6_FILIAL"},{"F6_EST"},{"F6_NUMERO"},{"R_E_C_N_O_"},{"D_E_L_E_T_"})
	
	oModel:SetDescription("Guia Nacional do Recolhimento - Web Service " + cIdEnt) 

return oModel

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Funcao generica MVC do View

@return oView - Objeto da View MVC

@since 24.06.2015
@version 1.0
/*/
//-------------------------------------------------------------------
static function ViewDef()

local oModel:=	FWLoadModel('RFISA95')
local oStru	:=	FWFormStruct(2, 'SF6')
local oView :=	FWFormView():New()

oView:SetModel(oModel)
oView:AddField('VIEW', oStru, 'FISA095MOD')

oView:EnableTitleView('VIEW', "Guia Nacional do Recolhimento - Web Service" + cIdEnt) //
oView:CreateHorizontalBox('FIELDS', 100)
oView:SetOwnerView('VIEW', 'FIELDS')  

oview:SetCloseOnOk ({||.T.})

return oView

//-------------------------------------------------------------------
/*/{Protheus.doc} Fisa095CFG
Rotina de Configuração do Web Service - GNRE

@author Simone dos Santos de Oliveira
@since 24.06.2015
@version 1.0

/*/
//-------------------------------------------------------------------     
Static function Fisa095CFG()
	
	SpedNFeCFG()
	
return 

USER Function Imp095GNRE()
Local _aSaveArea	:= GetArea()
Local cDocGNRE

PUBLIC  lMenuGuia := .T.

//U_PDFGNRE( SF6->F6_NUMERO, SF6->F6_DOC, SF6->F6_SERIE, SF6->F6_CLIFOR, SF6->F6_LOJA )
XFisa095Imp() //MLS 21/03/2018     CHAMADA IMPRESSAO ROTINA MANUAL

lMenuGuia := .F.
RestArea(_aSaveArea)
Return 


//-------------------------------------------------------------------
/*/{Protheus.doc} Fisa095Imp
Realiza impressão da GNRE

@since 07/03/2016
@version 1.0

/*/
//-------------------------------------------------------------------
STATIC function XFisa095Imp()

local oImpGNRE
local oSetup

local aDevice    := {}

local cFilePrint := "GNRE_"+cIdEnt+Dtos(MSDate())+StrTran(Time(),":","")
local cSession   := GetPrinterSession()

local nDevice
local nRet 		:= 0
local nHRes  		:= 0
local nVRes  		:= 0

AADD(aDevice,"DISCO") // 1
AADD(aDevice,"SPOOL") // 2
AADD(aDevice,"EMAIL") // 3
AADD(aDevice,"EXCEL") // 4
AADD(aDevice,"HTML" ) // 5
AADD(aDevice,"PDF"  ) // 6
                                                                        
nLocal  		:= if(fwGetProfString(cSession,"LOCAL","SERVER",.T.)=="SERVER",1,2 )
nOrientation 	:= 1 //Retrato
cDevice     	:= if(empty(fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.)),"PDF",fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.))
nPrintType    := ascan(aDevice,{|x| x == cDevice })

If 1==1 //IsReadyGNRE( cUrl )
	
	lAdjustToLegacy := .F. // Inibe legado de resolução com a TMSPrinter
	 oImpGNRE := FWMSPrinter():New(cFilePrint, IMP_PDF, lAdjustToLegacy, /*cPathInServer*/, .T.)
	
	// ----------------------------------------------
	// Cria e exibe tela de Setup Customizavel
	// OBS: Utilizar include "FWPrintSetup.ch"
	// ----------------------------------------------
	nFlags := PD_ISTOTVSPRINTER + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN + PD_DISABLEORIENTATION
	
	if findfunction("u_XPrtGNRE")
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
		
		// Pressionado botão OK na tela de Setup
		if oSetup:Activate() == PD_OK // PD_OK =1
			
			//Salva os Parametros no Profile  
				
	        fwWriteProfString( cSession, "LOCAL"      , If(oSetup:GetProperty(PD_DESTINATION)==1 ,"SERVER"    ,"CLIENT"    ), .T. )
	        fwWriteProfString( cSession, "PRINTTYPE"  , If(oSetup:GetProperty(PD_PRINTTYPE)==2   ,"SPOOL"     ,"PDF"       ), .T. )
	        fwWriteProfString( cSession, "ORIENTATION", If(oSetup:GetProperty(PD_ORIENTATION)==1 ,"PORTRAIT"  ,"LANDSCAPE" ), .T. )
	        			
			// Configura o objeto de impressão com o que foi configurado na interface.
	        oImpGNRE:setCopies( val( oSetup:cQtdCopia ) )
							
			 u_XPrtGNRE(cIdEnt, oImpGNRE, oSetup, cFilePrint)		
						
		else
			msginfo("Relatório cancelado pelo usuário.")
			return
		endif
	else
		msginfo("RDMAKE FISA119 não encontrado, relatório não será impresso!")
	endif	
endif

oImpGNRE:= nil
oSetup  := nil

Return()

     
