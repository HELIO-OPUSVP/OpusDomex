//------------------------------------------------------------------------------------//
//Empresa...:
//Funcao....: 
//Autor.....: 
//Data......: 
//Uso.......:
//Versao....:
//------------------------------------------------------------------------------------//

#INCLUDE "TOPCONN.CH"
#INCLUDE "FIVEWIN.CH"
#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#Include "COLORS.CH"
#Include "FONT.CH"
#INCLUDE "MSOBJECT.CH"

*----------------------------------------------------------------------------*
USER FUNCTION MRP002C() //GERACAO DE SC  MRP OFICIAL Filial 02
	*----------------------------------------------------------------------------*
	Local aSizeAut    := MsAdvSize(,.F.,400)
	Local aObjects	   := {}
	local aDialogs    := {"Necessidade"}
	local aDialogs2   := {"Entrada"}
	local aDialogs3   := {"Saida"}

	Local aTitles     := {OemToAnsi("Necessidade")}
	Local aTitles2    := {OemToAnsi("Entrada")}
	Local aTitles3    := {OemToAnsi("Saida")}

	Local aFldCBAtu   := Array(Len(aTitles))
	Local aPages	   := {"HEADER"}
	LOCAL aButtons    :={}
	Local dUlFat      := DATE()

	Private cPICT     :="@E 9,999,999.999"

	Private aHeadNec  := {}
	Private aHeadEnt  := {}
	Private aHeadSai  := {}
	Private aHeadSC   := {}
	Private aHeadPC   := {}
	Private aHeadMV   := {}

	Private aColsNec  := {}
	Private aColsEnt  := {}
	Private aColsSai  := {}
	Private aColsSC   := {}
	Private aColsPC   := {}
	Private aColsMV   := {}

	Private nOpcA     :=9

	Private cPRODUTO :=SPACE(15)
	Private cDESCRI  :=SPACE(40)
	Private cIDMRP   :=SPACE(09)
	Private dDATA    :=DATE()

	Private nSALDOI  :=0
	Private nSALDOF  :=0
	Private nTSALDOF :=0
	Private nENTRADA :=0
	Private nSAIDA   :=0
	Private nSLDATU  :=0

	Private nWON     :=0
	Private nBEST    :=0
	Private nIN      :=0

	Private oPRODUTO
	Private oDESCRI
	Private oIDMRP
	Private oDATA

	Private onSLDATU
	Private oSALDOI
	Private oSALDOF
	Private oTSALDOF
	Private oENTRADA
	Private oSAIDA

	Private oWON
	Private oBEST
	Private oIN

	Private nSCA :=0
	Private nPCA :=0

	Private oSCA
	Private oPCA

//--------------------------objetos---------------------------
	private oFont                // Objeto Fonte
	private oFontNW
	private oFontGRD             // Objeto Fonte
	private oFontBRW             // Objeto Fonte
	private oFontBRW2
	private oFontBRW3
	private oFontBRW4
	PRIVATE oFontBRW5
//--------------------------cabe�alho
	Private cSEQUEN1   :=SPACE(06)

	private oANOMES
	private cANOMES :=SPACE(06)

	PRIVATE _cOP    :=SPACE(04)
	PRIVATE	dMVULMES := GetMv("MV_ULMES")

	private lFirst :=.T.

	private oGetNEC
	private oGetENT
	private oGetSAI

	private cMSG1   :=''
	private cMSG1B  :=''
	private cMSG1C  :=''
	private oMSG1
	private oMSG1B
	private oMSG1C
	private cMSGDIV :=''
	private oMSGDIV

	private cMSG2  :=''
	private cMSG2B :=''
	private oMSG2  :=''
	private oMSG2B :=''

	private cMSG3  :=''
	private cMSG3B :=''
	private oMSG3  :=''
	private oMSG3B :=''

	private cMSG4  :=''
	private cMSG4B :=''
	private oMSG4  :=''
	private oMSG4B :=''

	Private cEOL    := "CHR(13)+CHR(10)"
	Private nQTDITEM :=0
	Private oQTDITEM

	Private oFUCOM
	Private cFUCOM :=SPACE(06)
	Private nQTDPRV:=0

	*----------------------------------------------------------------------------*
	//IF xFilial("SB2")=='02'
	//	MSGALERT('MRP OFICIAL FILIAL 02 - EM DESENVOLVIMENTO')
	//	RETURN
	//	//U_MRP002D()  // FILIAL 02
	//ENDIF
	*----------------------------------------------------------------------------*

	If Empty(cEOL)
		cEOL := CHR(13)+CHR(10)
	Else
		cEOL := Trim(cEOL)
		cEOL := &cEOL
	Endif

	private lSTATUS :=.F.

	private oFiltro
	private cFiltro   :=  '1 - Todos'
	private aFiltro   := {'1 - Todos','2 - Saldo Menor','3 - Saldo Maior'}

	private oFilEMP
	private cFilEMP   :=  '1 - Todos'
	private aFilEMP   := {'1 - Todos','2 - Com Empenho','3 - Sem Empenho'}

	private oFilPRV
	private cFilPRV   :=  '1 - Com Previsao'
	private aFilPRV   := {'1 - Com Previsao','2 - Sem Previsao'}

	private oFilMRP
	private cFilMRP   :=  '              '
	private aFilMRP   := {'              ','1 - Estamparia' }
	private _cTIPOP   :=SPACE(02)

	aAdd( aButtons, {"NOTE"      , {||  MsAguarde({||U_MRP02SCF()           ,'Aguarde','(F2)Gerar Solicitacao de Compras'  })  },"(F2)Gerar Solicitacao de Compras"  }) //
	aAdd( aButtons, {"NOTE"      , {||  MsAguarde({||MATA110()              ,'Aguarde','Solicitacao de Compras SC'         })  },'Solicitacao de Compras SC'  }) //
	aAdd( aButtons, {"NOTE"      , {||  MsAguarde({||MATA121()              ,'Aguarde','Pedido de Compras PC'              })  },'Pedido de Compras PC'  }) //
	aAdd( aButtons, {"NOTE"      , {||  MsAguarde({||U_MRPSCPC()            ,'Aguarde','(F8)Saldo SCs e PCs'               })  },'(F8)Saldo SCs e PCs'  }) //
	aAdd( aButtons, {"NOTE"      , {||  MsAguarde({||MRPZPRV(oGetSAI,cPRODUTO)       ,'Aguarde','(F9)Zerar Previsao Vendas'         })  },'(F9)Zerar Previsao Vendas'  }) //

	SetKey( VK_F2 , { || U_MRP02SCF() } )
	SetKey( VK_F4 , { || U_MRP002EF() } )
	SetKey( VK_F6 , { || U_MRP002SF() } )
	SetKey( VK_F7 , { || U_MRPCHK0F(oGetNEC)  } )
	SetKey( VK_F8 , { || U_MRPSCPCF()  } )
	SetKey( VK_F9 , { || MRPZPRV(oGetSAI,cPRODUTO)     } )

//----------------------------------------------------------------------------------------------------------------------------
//NECESSIDADE

	AADD(aHeadNEC,   {    "Produto"  ,   "A_PROD"       ,""                         ,15,0,""  ,"","C","","","","",".F."})//01
	AADD(aHeadNEC,   {    "Data"     ,   "A_DATA"       ,""                         ,08,0,""  ,"","C","","","","",".F."})//02
	AADD(aHeadNEC,   {    "Qtde"     ,   "A_QTDE"       ,"@E 9,999,999.99"            ,10,2,""  ,"","N","","","","",".F."})//03
	AADD(aHeadNEC,   {    "UPRC"     ,   "A_VLR"        ,"@E 9,999,999.99"            ,10,2,""  ,"","N","","","","",".F."})//04
	AADD(aHeadNEC,   {    "UFOR"     ,   "A_FOR"        ,""                         ,50,0,""  ,"","C","","","","",".F."})//05
	AADD(aHeadNEC,   {    "ID MRP"   ,   "A_IDMRP"      ,""                         ,09,0,""  ,"","C","","","","",".F."})//06

//ENTRADA
	AADD(aHeadENT,   {    "Tipo"     ,   "B_TIPO"       ,""                         ,20,0,""  ,"","C","","","","",".F."})//01
	AADD(aHeadENT,   {    "Obs"      ,   "B_OBS"        ,""                         ,75,0,""  ,"","C","","","","",".F"}) //02
	AADD(aHeadENT,   {    "Qtde"     ,   "B_QTDE"       ,"@E 999,999,999,999.99"    ,12,5,""  ,"","N","","","","",".F."})//03
//SAIDA
	AADD(aHeadSAI,   {    "Tipo"     ,   "C_TIPO"       ,""                         ,20,0,""  ,"","C","","","","",".F."})//01
	AADD(aHeadSAI,   {    "Obs"      ,   "C_OBS"        ,""                         ,75,0,""  ,"","C","","","","",".F"}) //02
	AADD(aHeadSAI,   {    "Qtde"     ,   "C_QTDE"       ,"@E 999,999,999,999.99"    ,12,5,""  ,"","N","","","","",".F."})//03
//SC
	AADD(aHeadSC,   {    "Numero SC" ,   "D_NUMSC"       ,""                         ,20,0,""  ,"","C","","","","",".F."})//01
	AADD(aHeadSC,   {    "Data"      ,   "D_DATA"        ,""                         ,15,0,""  ,"","C","","","","",".F"}) //02
	AADD(aHeadSC,   {    "Saldo"     ,   "D_SALDO"       ,"@E 999,999,999,999.99"    ,12,5,""  ,"","N","","","","",".F."})//03
//PC
	AADD(aHeadPC,   {    "Numero PC" ,   "D_NUMPC"       ,""                         ,20,0,""  ,"","C","","","","",".F."})//01
	AADD(aHeadPC,   {    "Data"      ,   "D_DATA"        ,""                         ,15,0,""  ,"","C","","","","",".F"}) //02
	AADD(aHeadPC,   {    "Saldo"     ,   "D_SALDO"       ,"@E 999,999,999,999.99"    ,12,5,""  ,"","N","","","","",".F."})//03
//MV MOVIMENTO ENTRADA
	AADD(aHeadMV,   {    "Movimento" ,   "D_NFE"         ,""                         ,20,0,""  ,"","C","","","","",".F."})//01
	AADD(aHeadMV,   {    "Numero PC" ,   "D_NUMPC"       ,""                         ,20,0,""  ,"","C","","","","",".F."})//02
	AADD(aHeadMV,   {    "Data"      ,   "D_DATA"        ,""                         ,15,0,""  ,"","C","","","","",".F"}) //03
	AADD(aHeadMV,   {    "Qtde"      ,   "D_SALDO"       ,"@E 999,999,999,999.99"    ,12,5,""  ,"","N","","","","",".F."})//04

//----------------------------------------------------------------------------------------------------------------------------

	AAdd( aObjects, { 0,    41, .T., .F. } )
	AAdd( aObjects, { 100, 100, .T., .T. } )
	AAdd( aObjects, { 0,    75, .T., .F. } )

	aInfo   := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],305,;
		{{3,40,95,165,217,234,268},;
		{10,40,111,145,223,268,60},;
		{5,70,160,205,295},;
		{6,34,200,215},;
		{6,34,80,113,160,185},;
		{6,34,245,268,260},;
		{10,50,150,190},;
		{273,130,190},;
		{8,45,80,103,139,173,200,235,270},;
		{133,190,144,190,289,293},;
		{142,293,140},;
		{9,47,188,148,9,146} } )

	DEFINE FONT oFont     NAME "Arial" SIZE 0,-25 BOLD
	DEFINE FONT oFontGRD  NAME "Arial" SIZE 0,-40 BOLD
	DEFINE FONT oFontBRW  NAME "Arial" SIZE 0,-15 BOLD
	DEFINE FONT oFontBRW2 NAME "Arial" SIZE 0,-17 BOLD
	DEFINE FONT oFontBRW3 NAME "Arial" SIZE 0,-13 BOLD
	DEFINE FONT oFontBRW4 NAME "Arial" SIZE 0,-19 BOLD
	DEFINE FONT oFontBRW5 NAME "Courier New" SIZE 0,-12 BOLD

	DEFINE MSDIALOG oDlg FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5]  TITLE OemToAnsi("CENTRAL MRP DOMEX V1.0 Filial 02") OF oMainWnd PIXEL
	oDlg:oFont:=oFontBRW3
//��������������������������������������������������������������Ŀ
//�Define o cabecalho da rotina                                  �
//����������������������������������������������������������������
	nMeio:=INT( ((oMainWnd:nBottom-60) -(oMainWnd:nTop+125) ) / 4 )-10
	@ 32,aPosGet[1,1] TO 65,aPosGet[1,1]+(aPosGet[1,1]*100) LABEL ""               OF oDlg PIXEL
	nLin:=37
	@ nLin,aPosGet[1,1]+(aPosGet[1,1]*01) SAY OemToAnsi("Produto")                                OF oDlg PIXEL SIZE 040,010 FONT oFontBRW3
	@ nLin,aPosGet[1,1]+(aPosGet[1,1]*06) MSGET oProduto VAR cProduto  WHEN(.T.)   F3('ZHA001')   OF oDlg PIXEL SIZE 070,005 FONT oFontBRW3 Valid MRPVAL1('P')
	@ nLin,aPosGet[1,1]+(aPosGet[1,1]*17) MSGET oDESCRI  VAR cDESCRI   WHEN(.F.)                  OF oDlg PIXEL SIZE 180,005 FONT oFontBRW3 //180   070

	@ nLin,aPosGet[1,1]+(aPosGet[1,1]*46) SAY OemToAnsi("Id MRP")                                 OF oDlg PIXEL SIZE 040,010 FONT oFontBRW3
	@ nLin,aPosGet[1,1]+(aPosGet[1,1]*51) MSGET oIDMRP   VAR cIdMRP    WHEN(.T.)   F3('ZHA002')   OF oDlg PIXEL SIZE 060,005 FONT oFontBRW3 Valid MRPVAL1('I')

	@ nLin,aPosGet[1,1]+(aPosGet[1,1]*62) SAY OemToAnsi("Filtro")                                 OF oDlg PIXEL SIZE 040,010 FONT oFontBRW3
	@ nLin,aPosGet[1,1]+(aPosGet[1,1]*66) combobox oFiltro var cFiltro items aFiltro              OF oDlg PIXEL SIZE 070,005 FONT oFontBRW3 Valid MRPVAL1('F')

	@ nLin,aPosGet[1,1]+(aPosGet[1,1]*80) SAY OemToAnsi("Empenho")                                OF oDlg PIXEL SIZE 040,010 FONT oFontBRW3
	@ nLin,aPosGet[1,1]+(aPosGet[1,1]*86) combobox oFilEMP var cFilEmp items aFilEMP              OF oDlg PIXEL SIZE 070,005 FONT oFontBRW3 Valid MRPVAL1('F')

	nLin:=51

	@ nLin,aPosGet[1,1]+(aPosGet[1,1]*01) SAY OemToAnsi("Data")                                   OF oDlg PIXEL SIZE 040,010 FONT oFontBRW3
	@ nLin,aPosGet[1,1]+(aPosGet[1,1]*06) MSGET oData    VAR dData     WHEN(.T.)                  OF oDlg PIXEL SIZE 070,005 FONT oFontBRW3

	@ nLin,aPosGet[1,1]+(aPosGet[1,1]*46) SAY OemToAnsi("GrpMRP")                                 OF oDlg PIXEL SIZE 040,010 FONT oFontBRW3
	@ nLin,aPosGet[1,1]+(aPosGet[1,1]*51) combobox oFilMRP var cFilMRP items aFilMRP              OF oDlg PIXEL SIZE 060,005 FONT oFontBRW3 Valid MRPVAL1('F')

	@ nLin,aPosGet[1,1]+(aPosGet[1,1]*62) SAY OemToAnsi("Fornec")                                 OF oDlg PIXEL SIZE 040,010 FONT oFontBRW3
	@ nLin,aPosGet[1,1]+(aPosGet[1,1]*66) MSGET oFUCOM   VAR cFUCOM    WHEN(.T.)   F3('SA2')      OF oDlg PIXEL SIZE 070,005 FONT oFontBRW3 Valid MRPVAL1('F')

	@ nLin,aPosGet[1,1]+(aPosGet[1,1]*80) SAY OemToAnsi("Previsao")                               OF oDlg PIXEL SIZE 040,010 FONT oFontBRW3
	@ nLin,aPosGet[1,1]+(aPosGet[1,1]*86) combobox oFilPRV var cFilPRV items aFilPRV              OF oDlg PIXEL SIZE 070,005 FONT oFontBRW3 Valid MRPVAL1('F')

	*----------------------------------------------------------------------------------------------------------------

	oGetNEC   := (MsNewGetDados():New( 074,003,250,200,/*GD_UPDATE*/ ,/*"U_FAT002LOK()"*/  ,/*REQ_OPSD3()*/,/*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*Ffieldok*/,/*superdel*/,/*delok*/,oDlg,aHeadNec,aColsNec))
	oGetNEC:oBrowse:Refresh()
	oGetNEC:oBrowse:bChange:={||U_MRPCHG0F(oGetNEC,oGetSAI,oGetENT)}

	oGetENT   := (MsNewGetDados():New( 100,210,210,aPosGet[1,1]+(aPosGet[1,1]*100),/*GD_UPDATE */,/*"U_FAT002LOK()"*/  ,/*REQ_OPSD3()*/,/*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*Ffieldok*/,/*superdel*/,/*delok*/,oDlg,aHEADENT,aCOLSENT))
	oGetENT:oBrowse:Refresh()

	oGetSAI   := (MsNewGetDados():New( 180,210,260,aPosGet[1,1]+(aPosGet[1,1]*100),/*GD_UPDATE*/ ,/*"U_FAT002LOK()"*/  ,/*REQ_OPSD3()*/,/*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*Ffieldok*/,/*superdel*/,/*delok*/,oDlg,aHEADSAI,aCOLSSAI))
	oGetSAI:oBrowse:Refresh()

	@ 074,aPosGet[1,1]+(aPosGet[1,1]*32) TO 095,aPosGet[1,1]+(aPosGet[1,1]*100) LABEL ""                    OF oDlg PIXEL //210
	@ 080,aPosGet[1,1]+(aPosGet[1,1]*34) SAY OemToAnsi("Saldo Atual" )            OF oDlg PIXEL SIZE 040,010 FONT oFontBRW3//220
	@ 080,aPosGet[1,1]+(aPosGet[1,1]*43) MSGET onSLDATU VAR nSLDATU  WHEN(.F.)    OF oDlg PIXEL SIZE 070,005 FONT oFontBRW3 PICTURE ("@E 999,999,999.99") //280

	@ 080,aPosGet[1,1]+(aPosGet[1,1]*59) SAY oMSGDIV VAR cMSGDIV  OF oDlg SIZE 150,015  PIXEL COLOR CLR_RED   FONT oFontBRW4

	@ 080,aPosGet[1,1]+(aPosGet[1,1]*76) SAY OemToAnsi("Saldo MRP")               OF oDlg PIXEL SIZE 040,010 FONT oFontBRW3//490
	@ 080,aPosGet[1,1]+(aPosGet[1,1]*86) MSGET oSALDOI VAR nSALDOI  WHEN(.F.)   OF oDlg PIXEL SIZE 070,005 FONT oFontBRW3 PICTURE ("@E 999,999,999.99")
	@ 255,aPosGet[1,1]+(aPosGet[1,1]*32) TO 300,aPosGet[1,1]+(aPosGet[1,1]*100) LABEL ""                    OF oDlg PIXEL//210

	@ 274,aPosGet[1,1]+(aPosGet[1,1]*34) SAY OemToAnsi("Entrada" )              OF oDlg PIXEL SIZE 040,010 FONT oFontBRW3 //235
	@ 274,aPosGet[1,1]+(aPosGet[1,1]*43) MSGET oENTRADA VAR nENTRADA  WHEN(.F.) OF oDlg PIXEL SIZE 070,005 FONT oFontBRW3 PICTURE ("@E 999,999,999.99")
	@ 274,aPosGet[1,1]+(aPosGet[1,1]*55) SAY OemToAnsi("Saida" )                OF oDlg PIXEL SIZE 040,010 FONT oFontBRW3//360
	@ 274,aPosGet[1,1]+(aPosGet[1,1]*63) MSGET oSAIDA   VAR nSAIDA    WHEN(.F.) OF oDlg PIXEL SIZE 070,005 FONT oFontBRW3 PICTURE ("@E 999,999,999.99")//410
	@ 274,aPosGet[1,1]+(aPosGet[1,1]*76) SAY OemToAnsi("Saldo Final " )         OF oDlg PIXEL SIZE 400,010 FONT oFontBRW3
	@ 274,aPosGet[1,1]+(aPosGet[1,1]*86) MSGET oSALDOF  VAR nSALDOF   WHEN(.F.) OF oDlg PIXEL SIZE 070,005 FONT oFontBRW3 PICTURE ("@E 999,999,999.99")

	@ 286,aPosGet[1,1]+(aPosGet[1,1]*34) SAY OemToAnsi("SCs Em Aberto")                 OF oDlg PIXEL SIZE 150,010 FONT oFontBRW3 //255
	@ 286,aPosGet[1,1]+(aPosGet[1,1]*43) MSGET oSCA VAR nSCA  WHEN(.F.) OF oDlg PIXEL SIZE 070,005 FONT oFontBRW3 PICTURE ("@E 999,999,999.99")
	@ 286,aPosGet[1,1]+(aPosGet[1,1]*55) SAY OemToAnsi("PCs Em Aberto" )                OF oDlg PIXEL SIZE 150,010 FONT oFontBRW3
	@ 286,aPosGet[1,1]+(aPosGet[1,1]*63) MSGET oPCA VAR nPCA  WHEN(.F.) OF oDlg PIXEL SIZE 070,005 FONT oFontBRW3 PICTURE ("@E 999,999,999.99")
	@ 286,aPosGet[1,1]+(aPosGet[1,1]*76) SAY OemToAnsi("Necessidade Total" )              OF oDlg PIXEL SIZE 250,010 FONT oFontBRW3
	@ 286,aPosGet[1,1]+(aPosGet[1,1]*86) MSGET oTSALDOF  VAR nTSALDOF   WHEN(.F.) OF oDlg SIZE 070,005 PICTURE ("@E 999,999,999.99") PIXEL COLOR CLR_HBLUE FONT oFontBRW3

	@ 255,aPosGet[1,1] SAY oMSG1  VAR cMSG1   OF oDlg SIZE 200,035  PIXEL COLOR CLR_HBLUE FONT oFontBRW5
	@ 255,aPosGet[1,1] SAY oMSG1B VAR cMSG1B  OF oDlg SIZE 200,035  PIXEL COLOR CLR_RED   FONT oFontBRW5
	@ 255,aPosGet[1,1] SAY oMSG1C VAR cMSG1C  OF oDlg SIZE 200,035  PIXEL COLOR CLR_GREEN FONT oFontBRW5

	@ 290,aPosGet[1,1] SAY oMSG2  VAR cMSG2   OF oDlg SIZE 200,015  PIXEL COLOR CLR_GREEN FONT oFontBRW3
	@ 290,aPosGet[1,1] SAY oMSG2B VAR cMSG2B  OF oDlg SIZE 200,015  PIXEL COLOR CLR_GREEN FONT oFontBRW3

	@ 290,aPosGet[1,1] SAY oMSG3  VAR cMSG3   OF oDlg SIZE 150,015  PIXEL COLOR CLR_GREEN FONT oFontBRW3
	@ 290,aPosGet[1,1] SAY oMSG3B VAR cMSG3B  OF oDlg SIZE 150,015  PIXEL COLOR CLR_GREEN FONT oFontBRW3

	@ 291,aPosGet[1,1]+(aPosGet[1,1]*27.5) SAY oQTDITEM  VAR nQTDITEM  OF oDlg SIZE 150,015  PIXEL COLOR CLR_GREEN FONT oFontBRW3
	Private nQTDITEM :=0

	@ 257,195 BITMAP ResName "EMPILHADEIRA" OF oDlg Size 15,15 ON CLICK (U_MRP02SCF(oGetNEC))   NoBorder  Pixel
	@ 277,198 BITMAP ResName "SELECT"       OF oDlg Size 45,45 ON CLICK (U_MRPCHK0F(oGetNEC))  NoBorder  Pixel

	@ 255,003 TO 300,210 LABEL ""  OF oDlg PIXEL

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||(MRP2FIM(),nOpcA:=9)}    ,{||(MRP2FIM(),nOpcA:=0)},,aButtons) centered

RETURN

	*----------------------------------------------------------------------------*
STATIC FUNCTION MRP2FIM()
	*----------------------------------------------------------------------------*
	local lRet :=.F.
	IF MSGYESNO('Finaliza  ?')
		lRet :=.T.
		oDlg:End()
	ENDIF

RETURN(lRET)

	*----------------------------------------------------------------------------*
USER FUNCTION MRP002EF()
	*----------------------------------------------------------------------------*
	MSGALERT('TELA CONSULTA ENTRADA - EM DESENVOLVIMENTO')
RETURN

	*----------------------------------------------------------------------------*
USER FUNCTION MRP002SF()
	*----------------------------------------------------------------------------*
	MSGALERT('TELA CONSULTA SAIDA - EM DESENVOLVIMENTO')
RETURN

	*----------------------------------------------------------------------------*
STATIC FUNCTION MRPVAL1(cTIPO)
	*----------------------------------------------------------------------------*
	MsAguarde( { || MRPVAL1B(cTIPO) } ,"Filtro", "Filtro MRP - Aguarde..." )
RETURN

	*----------------------------------------------------------------------------*
STATIC FUNCTION MRPVAL1B(cTIPO)
	*----------------------------------------------------------------------------*

	lFirst   :=.F.
	nQTDITEM :=0

	IF cTIPO=='I' .AND. !EMPTY(cIDMRP) // IDMRP
		aColsNEC  := {}

		cQueryID := " 	SELECT  B1_XFILMRP, "
		cQueryID += " 	ZHC_PERIOD, ZHC_NUMMRP, ZHC_NIVEL, ZHC_PRODUT,ZHC_PRODSH,ZHC_OPC,ZHC_REVISA,ZHC_REVSHW,ZHC_TIPO,ZHC_TEXTO,ZHC_SALDOE, "
		cQueryID += " 	ZHC_ENTRAD, ZHC_SAIDA , ZHC_SESTR, ZHC_SALDO ,ZHC_NEC,ZHC_DESC ,ZHC_TIPOP,ZHC_GRUPO,ZHC_XQTDE,ZHC_TXDT1,ZHC_TXDT2, "
		cQueryID += " 	ZHC_LTIME,ZHC_IDMRP,ZHC_NUMSC,ZHC_HISTSC, ZHC_QTDSC, ZHC_DATASC,ZHC_STATUS,SUBSTRING(ZHC_FORN+' '+ZHC_LOJA+' '+ZHC_NFORN,1,30)  AS ZHC_NFORN,ZHC_UPRC "
		cQueryID += " 	FROM ZHC010 (NOLOCK)  ,SB1010 (NOLOCK) "
		cQueryID += " 	WHERE B1_COD=ZHC_PRODUT AND B1_FILIAL = '"+xFILIAL('SB1')+"' AND ZHC_FILIAL = '"+xFILIAL('ZHC')+"'"
		cQueryID += " 	AND ZHC_IDMRP='"+cIDMRP+"' AND  SUBSTRING(ZHC_TIPO,1,2)='01' and ZHC_XQTDE>0  "
		IF !EMPTY(cFUCOM)
			cQueryID += " 	AND ZHC_FORN='"+cFUCOM+"'  "
		ENDIF
		cQueryID += " 	AND SB1010.D_E_L_E_T_='' "
		IF SUBSTR(cFILMRP,1,1)=='1'
			cQueryID += " 	AND B1_XFILMRP='1' "
		ENDIF

		IF SUBSTR(cFILPRV,1,1)=='2' // QUERY RETIRAR PRODUTOS COM PREVISAO DE VENDA
			cQueryID += " AND ZHC_PRODUT NOT IN ( "
			cQueryID += " SELECT ZHC_PRODUT  "
			cQueryID += " FROM ZHC010 ZHC (NOLOCK) "
			cQueryID += " WHERE ZHC.ZHC_TIPO IN ('09-Previsao Venda')  "
			cQueryID += " AND ZHC.D_E_L_E_T_='' "
			cQueryID += " AND ZHC.ZHC_FILIAL='"+xFILIAL('ZHC')+"' "
			cQueryID += " AND ZHC.ZHC_SAIDA>0 ) "
		ENDIF

		IF SUBSTR(cFILEMP,1,1)=='2'//com empenho
			cQueryID += " AND ZHC_PRODUT IN( SELECT D4_COD FROM SD4010 (NOLOCK) "
			cQueryID += " WHERE D4_FILIAL='"+xFILIAL('SD4')+"' AND D4_QUANT>0 AND SD4010.D_E_L_E_T_='' "
			cQueryID += " GROUP BY D4_COD ) "
		ENDIF

		IF SUBSTR(cFILEMP,1,1)=='3'//sem empenho
			cQueryID += " AND ZHC_PRODUT NOT IN( SELECT D4_COD FROM SD4010 (NOLOCK) "
			cQueryID += " WHERE D4_FILIAL='"+xFILIAL('SD4')+"' AND D4_QUANT>0 AND SD4010.D_E_L_E_T_='' "
			cQueryID += " GROUP BY D4_COD ) "
		ENDIF

		cQueryID += " 	ORDER BY  ZHC_PRODUT,ZHC_TXDT2 "

		TCQUERY cQueryID NEW ALIAS "TR1"
		TR1->( dbGoTop() )
		DO WHILE .NOT. TR1->(EOF())
			//--------------------------------- filtro
			_nNEC2 :=0
			IF SUBSTR(cFILTRO,1,1)<>'1'
				cQUERYSLD:="	SELECT ZHC_PRODUT , "
				cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QATU),0) FROM SB2010 (NOLOCK) WHERE B2_COD=ZHC_PRODUT  AND D_E_L_E_T_='' AND B2_FILIAL='"+xFILIAL('SB2')+"' ) AS  EST, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C1_QUANT-C1_QUJE),0)  FROM SC1010 (NOLOCK) WHERE C1_FILIAL='"+xFILIAL('SC1')+"' AND C1_PRODUTO=ZHC.ZHC_PRODUT AND D_E_L_E_T_='' AND C1_RESIDUO='' AND  C1_QUANT > C1_QUJE) AS  SOL, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C7_QUANT-C7_QUJE),0)  FROM SC7010 (NOLOCK) WHERE C7_FILIAL='"+xFILIAL('SC7')+"' AND C7_PRODUTO=ZHC.ZHC_PRODUT AND D_E_L_E_T_='' AND C7_RESIDUO='' AND  C7_QUANT > C7_QUJE) AS  PC, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QEMP),0) FROM SB2010 (NOLOCK)  WHERE B2_FILIAL='"+xFILIAL('SB2')+"' AND B2_COD=ZHC_PRODUT  AND D_E_L_E_T_='' ) AS  EMP, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(ZHC_XQTDE),0)  FROM ZHC010 (NOLOCK) WHERE ZHC_FILIAL='"+xFILIAL('ZHC')+"' AND  ZHC_TIPO IN ('06-Ordem Producao') AND ZHC_PRODUT=ZHC.ZHC_PRODUT) AS  OP, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C6_QTDVEN-C6_QTDENT),0)  FROM SC6010 (NOLOCK) WHERE C6_FILIAL='"+xFILIAL('SC6')+"' AND  (C6_QTDVEN-C6_QTDENT)>0 AND D_E_L_E_T_='' AND C6_PRODUTO=ZHC.ZHC_PRODUT AND C6_BLQ<>'R')  AS  PV, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(ZHC_XQTDE),0)  FROM ZHC010 (NOLOCK) WHERE ZHC_FILIAL='"+xFILIAL('ZHC')+"' AND ZHC_TIPO IN ('09-Previsao Venda')  AND ZHC_PRODUT=ZHC.ZHC_PRODUT) AS  PREV, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(ZHC_XQTDE),0)  FROM ZHC010 (NOLOCK) WHERE ZHC_FILIAL='"+xFILIAL('ZHC')+"' AND ZHC_TIPO IN ('08-Saida Estrutura') AND ZHC_PRODUT=ZHC.ZHC_PRODUT) AS  SAES, "

				cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QATU),0) FROM SB2010 (NOLOCK) WHERE B2_FILIAL='"+xFILIAL('SB2')+"' AND B2_COD=ZHC_PRODUT  AND D_E_L_E_T_='') + "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C1_QUANT-C1_QUJE),0)  FROM SC1010 (NOLOCK) WHERE C1_FILIAL='"+xFILIAL('SC1')+"' AND  C1_PRODUTO=ZHC.ZHC_PRODUT AND D_E_L_E_T_='' AND C1_RESIDUO='' AND C1_QUANT > C1_QUJE) + "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C7_QUANT-C7_QUJE),0)  FROM SC7010 (NOLOCK) WHERE C7_FILIAL='"+xFILIAL('SC7')+"' AND  C7_PRODUTO=ZHC.ZHC_PRODUT AND D_E_L_E_T_='' AND C7_RESIDUO='' AND C7_QUANT > C7_QUJE ) - "
				cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QEMP),0) FROM SB2010 (NOLOCK)  WHERE B2_FILIAL='"+xFILIAL('SB2')+"' AND  B2_COD=ZHC_PRODUT  AND D_E_L_E_T_='' ) + "
				cQUERYSLD+="	(SELECT ISNULL(SUM(ZHC_XQTDE),0)  FROM ZHC010 (NOLOCK) WHERE ZHC_FILIAL='"+xFILIAL('ZHC')+"' AND  ZHC_TIPO IN ('06-Ordem Producao') AND ZHC_PRODUT=ZHC.ZHC_PRODUT) - "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C6_QTDVEN-C6_QTDENT),0)  FROM SC6010 (NOLOCK) WHERE C6_FILIAL='"+xFILIAL('SC6')+"' AND  (C6_QTDVEN-C6_QTDENT)>0 AND D_E_L_E_T_='' AND C6_PRODUTO=ZHC.ZHC_PRODUT  AND C6_BLQ<>'R') - "
				cQUERYSLD+="	(SELECT ISNULL(SUM(ZHC_XQTDE),0)  FROM ZHC010 (NOLOCK) WHERE ZHC_FILIAL='"+xFILIAL('ZHC')+"' AND  ZHC_TIPO IN ('09-Previsao Venda')  AND ZHC_PRODUT=ZHC.ZHC_PRODUT) AS FINAL "// -       "

				cQUERYSLD+="	FROM ZHC010 (NOLOCK) ZHC "
				cQUERYSLD+="	WHERE ZHC_PRODUT='"+ALLTRIM(TR1->ZHC_PRODUT)+"'  AND ZHC_FILIAL = '"+xFILIAL('ZHC')+"' AND D_E_L_E_T_='' "
				cQUERYSLD+="	GROUP BY ZHC_PRODUT "
				cQUERYSLD+="	ORDER BY ZHC_PRODUT "

				TCQUERY cQUERYSLD NEW ALIAS "TRS"
				TRS->( dbGoTop() )
				_nNEC2 :=TRS->FINAL
				TRS->(DBCLOSEAREA())
			ENDIF
			//---------------------------------

			lSTATUS :=.F.
			IF TR1->ZHC_STATUS=='X' .OR. TR1->ZHC_STATUS=='S'  //SC CHECK
				lSTATUS :=.T.
			ENDIF
			IF TR1->ZHC_XQTDE >0
				IF (SUBSTR(cFILTRO,1,1)=='1') .OR. (SUBSTR(cFILTRO,1,1)=='2' .and. _nNEC2 <0) .OR. (SUBSTR(cFILTRO,1,1)=='3' .and. _nNEC2 >=0)
					AADD(aColsNEC,{TR1->ZHC_PRODUT,;
						TR1->ZHC_TXDT1,;
						TR1->ZHC_XQTDE,;
						TR1->ZHC_XQTDE*TR1->ZHC_UPRC,;
						TR1->ZHC_NFORN,;
						TR1->ZHC_IDMRP,;
						TR1->ZHC_STATUS,;
						lSTATUS})//.f. POSICAO 8Flag de Delecao]
					nQTDITEM++
				ENDIF
			ENDIF
			TR1->(DBSKIP())
		ENDDO
		IF LEN(aColsNEC)==0
			AADD(aColsNEC,{"",;
				"",;
				0,;
				0,;
				"",;
				"",;
				"",;
				.T.})//.f. POSICAO 8Flag de Delecao]
			MSGALERT("Id MRP Nao Encontrado No CUBO MRP")
			cPRODUTO:=space(15)
		ENDIF

		TR1->(DBCLOSEAREA())
		oGetNEC:ACOLS:=aCOLSNEC
		oGetNEC:oBrowse:Refresh()

	ENDIF

	IF cTIPO=='P' .AND. !EMPTY(cProduto)// IDMRP
		aColsNEC  := {}

		cQueryID := " 	SELECT  B1_XFILMRP, "
		cQueryID += " 	ZHC_PERIOD, ZHC_NUMMRP, ZHC_NIVEL, ZHC_PRODUT,ZHC_PRODSH,ZHC_OPC,ZHC_REVISA,ZHC_REVSHW,ZHC_TIPO,ZHC_TEXTO,ZHC_SALDOE, "
		cQueryID += " 	ZHC_ENTRAD, ZHC_SAIDA , ZHC_SESTR, ZHC_SALDO ,ZHC_NEC,ZHC_DESC ,ZHC_TIPOP,ZHC_GRUPO,ZHC_XQTDE,ZHC_TXDT1,ZHC_TXDT2, "
		cQueryID += " 	ZHC_LTIME,ZHC_IDMRP,ZHC_NUMSC,ZHC_HISTSC, ZHC_QTDSC, ZHC_DATASC,ZHC_STATUS,SUBSTRING(ZHC_FORN+' '+ZHC_LOJA+' '+ZHC_NFORN,1,30)  AS ZHC_NFORN,ZHC_UPRC "
		cQueryID += " 	FROM ZHC010 (NOLOCK)  ,SB1010 (NOLOCK) "
		cQueryID += " 	WHERE B1_COD=ZHC_PRODUT AND B1_FILIAL = '"+xFILIAL('SB1')+"' AND ZHC_FILIAL = '"+xFILIAL('ZHC')+"' "
		cQueryID += " 	AND  ZHC_PRODUT='"+cPRODUTO+"' AND SUBSTRING(ZHC_TIPO,1,2)='01' "
		IF !EMPTY(cFUCOM)
			cQueryID += " 	AND ZHC_FORN='"+cFUCOM+"'  "
		ENDIF
		cQueryID += " 	AND SB1010.D_E_L_E_T_='' "
		IF SUBSTR(cFILMRP,1,1)=='1'
			cQueryID += " 	AND B1_XFILMRP='1' "
		ENDIF

		IF SUBSTR(cFILEMP,1,1)=='2'//com empenho
			cQueryID += " AND ZHC_PRODUT IN( SELECT D4_COD FROM SD4010 (NOLOCK) "
			cQueryID += " WHERE D4_FILIAL='"+xFILIAL('SD4')+"' AND D4_QUANT>0 AND SD4010.D_E_L_E_T_='' "
			cQueryID += " GROUP BY D4_COD ) "
		ENDIF

		IF SUBSTR(cFILEMP,1,1)=='3'//sem empenho
			cQueryID += " AND ZHC_PRODUT NOT IN( SELECT D4_COD FROM SD4010 (NOLOCK) "
			cQueryID += " WHERE D4_FILIAL='"+xFILIAL('SD4')+"' AND D4_QUANT>0 AND SD4010.D_E_L_E_T_='' "
			cQueryID += " GROUP BY D4_COD ) "
		ENDIF

		IF SUBSTR(cFILPRV,1,1)=='2' // QUERY RETIRAR PRODUTOS COM PREVISAO DE VENDA
			cQueryID += " AND ZHC_PRODUT NOT IN ( "
			cQueryID += " SELECT ZHC_PRODUT  "
			cQueryID += " FROM ZHC010 ZHC (NOLOCK) "
			cQueryID += " WHERE ZHC.ZHC_TIPO IN ('09-Previsao Venda')  "
			cQueryID += " AND ZHC.D_E_L_E_T_='' "
			cQueryID += " AND ZHC.ZHC_FILIAL='"+xFILIAL('ZHC')+"' "
			cQueryID += " AND ZHC.ZHC_SAIDA>0 ) "
		ENDIF

		cQueryID += " 	ORDER BY  ZHC_PRODUT,ZHC_TXDT2 "

		TCQUERY cQueryID NEW ALIAS "TR1"
		TR1->( dbGoTop() )
		DO WHILE .NOT. TR1->(EOF())
			//--------------------------------- filtro
			_nNEC2 :=0
			IF SUBSTR(cFILTRO,1,1)<>'1'
				cQUERYSLD:="	SELECT ZHC_PRODUT , "
				cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QATU),0) FROM SB2010 (NOLOCK) WHERE B2_FILIAL='"+xFILIAL('SB2')+"' AND  B2_COD=ZHC_PRODUT  AND D_E_L_E_T_='' ) AS  EST, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C1_QUANT-C1_QUJE),0)  FROM SC1010 (NOLOCK)  WHERE C1_FILIAL='"+xFILIAL('SC1')+"' AND  C1_PRODUTO=ZHC.ZHC_PRODUT AND D_E_L_E_T_='' AND C1_RESIDUO='' AND  C1_QUANT > C1_QUJE) AS  SOL, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C7_QUANT-C7_QUJE),0)  FROM SC7010 (NOLOCK)  WHERE C7_FILIAL='"+xFILIAL('SC7')+"' AND  C7_PRODUTO=ZHC.ZHC_PRODUT AND D_E_L_E_T_='' AND C7_RESIDUO='' AND  C7_QUANT > C7_QUJE) AS  PC, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QEMP),0) FROM SB2010 (NOLOCK)  WHERE B2_FILIAL='"+xFILIAL('SB2')+"' AND  B2_COD=ZHC_PRODUT  AND D_E_L_E_T_='' ) AS  EMP, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(ZHC_XQTDE),0)  FROM ZHC010 (NOLOCK) WHERE ZHC_FILIAL='"+xFILIAL('ZHC')+"' AND  ZHC_TIPO IN ('06-Ordem Producao') AND ZHC_PRODUT=ZHC.ZHC_PRODUT) AS  OP, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C6_QTDVEN-C6_QTDENT),0)  FROM SC6010 (NOLOCK) WHERE C6_FILIAL='"+xFILIAL('SC6')+"' AND  (C6_QTDVEN-C6_QTDENT)>0 AND D_E_L_E_T_='' AND C6_PRODUTO=ZHC.ZHC_PRODUT AND C6_BLQ<>'R')  AS  PV, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(ZHC_XQTDE),0)  FROM ZHC010 (NOLOCK) WHERE ZHC_FILIAL='"+xFILIAL('ZHC')+"' AND  ZHC_TIPO IN ('09-Previsao Venda')  AND ZHC_PRODUT=ZHC.ZHC_PRODUT) AS  PREV, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(ZHC_XQTDE),0)  FROM ZHC010 (NOLOCK) WHERE ZHC_FILIAL='"+xFILIAL('ZHC')+"' AND  ZHC_TIPO IN ('08-Saida Estrutura') AND ZHC_PRODUT=ZHC.ZHC_PRODUT) AS  SAES, "

				cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QATU),0) FROM SB2010 (NOLOCK) WHERE B2_FILIAL='"+xFILIAL('SB2')+"' AND  B2_COD=ZHC_PRODUT  AND D_E_L_E_T_='') + "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C1_QUANT-C1_QUJE),0)  FROM SC1010 (NOLOCK) WHERE C1_FILIAL='"+xFILIAL('SC1')+"' AND  C1_PRODUTO=ZHC.ZHC_PRODUT AND D_E_L_E_T_='' AND C1_RESIDUO='' AND C1_QUANT > C1_QUJE) + "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C7_QUANT-C7_QUJE),0)  FROM SC7010 (NOLOCK) WHERE C7_FILIAL='"+xFILIAL('SC7')+"' AND  C7_PRODUTO=ZHC.ZHC_PRODUT AND D_E_L_E_T_='' AND C7_RESIDUO='' AND C7_QUANT > C7_QUJE ) - "
				cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QEMP),0) FROM SB2010 (NOLOCK)  WHERE B2_FILIAL='"+xFILIAL('SB2')+"' AND  B2_COD=ZHC_PRODUT  AND D_E_L_E_T_='' ) + "
				cQUERYSLD+="	(SELECT ISNULL(SUM(ZHC_XQTDE),0)  FROM ZHC010 (NOLOCK) WHERE ZHC_FILIAL='"+xFILIAL('ZHC')+"' AND  ZHC_TIPO IN ('06-Ordem Producao') AND ZHC_PRODUT=ZHC.ZHC_PRODUT) - "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C6_QTDVEN-C6_QTDENT),0)  FROM SC6010 (NOLOCK) WHERE C6_FILIAL='"+xFILIAL('SC6')+"' AND  (C6_QTDVEN-C6_QTDENT)>0 AND D_E_L_E_T_='' AND C6_PRODUTO=ZHC.ZHC_PRODUT  AND C6_BLQ<>'R') - "
				cQUERYSLD+="	(SELECT ISNULL(SUM(ZHC_XQTDE),0)  FROM ZHC010 (NOLOCK) WHERE ZHC_FILIAL='"+xFILIAL('ZHC')+"' AND  ZHC_TIPO IN ('09-Previsao Venda')  AND ZHC_PRODUT=ZHC.ZHC_PRODUT) AS FINAL "// -       "

				cQUERYSLD+="	FROM ZHC010 (NOLOCK) ZHC "
				cQUERYSLD+="	WHERE ZHC_PRODUT='"+ALLTRIM(TR1->ZHC_PRODUT)+"' AND ZHC_FILIAL = '"+xFILIAL('ZHC')+"'  "
				cQUERYSLD+="	GROUP BY ZHC_PRODUT "
				cQUERYSLD+="	ORDER BY ZHC_PRODUT "

				TCQUERY cQUERYSLD NEW ALIAS "TRS"
				TRS->( dbGoTop() )
				_nNEC2 :=TRS->FINAL
				TRS->(DBCLOSEAREA())
			ENDIF
			//---------------------------------

			lSTATUS :=.F.
			IF TR1->ZHC_STATUS=='X' .OR. TR1->ZHC_STATUS=='S'  //SC CHECK
				lSTATUS :=.T.
			ENDIF
			IF TR1->ZHC_XQTDE >0
				IF (SUBSTR(cFILTRO,1,1)=='1') .OR. (SUBSTR(cFILTRO,1,1)=='2' .and. _nNEC2 <0) .OR. (SUBSTR(cFILTRO,1,1)=='3' .and. _nNEC2 >=0)
					AADD(aColsNEC,{TR1->ZHC_PRODUT,;
						TR1->ZHC_TXDT1,;
						TR1->ZHC_XQTDE,;
						TR1->ZHC_XQTDE*TR1->ZHC_UPRC,;
						TR1->ZHC_NFORN,;
						TR1->ZHC_IDMRP,;
						TR1->ZHC_STATUS,;
						lSTATUS})//.f. POSICAO 8Flag de Delecao]
					nQTDITEM++
				ENDIF
			ENDIF
			TR1->(DBSKIP())
		ENDDO
		IF LEN(aColsNEC)==0
			AADD(aColsNEC,{"",;
				"",;
				0,;
				0,;
				"",;
				"",;
				"",;
				.T.})//.f. POSICAO 8Flag de Delecao]
			MSGALERT("Produto Nao Encontrado No CUBO MRP")
			cPRODUTO:=space(15)
		ENDIF
		TR1->(DBCLOSEAREA())
		oGetNEC:ACOLS:=aCOLSNEC
		oGetNEC:oBrowse:Refresh()
		//U_MRPCHG0F(oGetNEC,oGetSAI,oGetENT)
		cIDMRP  :=space(09)
		oIDMRP:refresh()
		oProduto:refresh()
	ENDIF

	IF (EMPTY(cIDMRP) .AND. EMPTY(cPRODUTO) ) .OR.  cTIPO=='F'
		aColsNEC  := {}

		cQueryID := " 	SELECT  B1_XFILMRP, "
		cQueryID += " 	ZHC_PERIOD, ZHC_NUMMRP, ZHC_NIVEL, ZHC_PRODUT,ZHC_PRODSH,ZHC_OPC,ZHC_REVISA,ZHC_REVSHW,ZHC_TIPO,ZHC_TEXTO,ZHC_SALDOE, "
		cQueryID += " 	ZHC_ENTRAD, ZHC_SAIDA , ZHC_SESTR, ZHC_SALDO ,ZHC_NEC,ZHC_DESC ,ZHC_TIPOP,ZHC_GRUPO,ZHC_XQTDE,ZHC_TXDT1,ZHC_TXDT2, "
		cQueryID += " 	ZHC_LTIME,ZHC_IDMRP,ZHC_NUMSC,ZHC_HISTSC, ZHC_QTDSC, ZHC_DATASC,ZHC_STATUS,SUBSTRING(ZHC_FORN+' '+ZHC_LOJA+' '+ZHC_NFORN,1,30)  AS ZHC_NFORN,ZHC_UPRC "
		cQueryID += " 	FROM ZHC010 (NOLOCK)  ,SB1010 (NOLOCK) "
		cQueryID += " 	WHERE B1_COD=ZHC_PRODUT AND B1_FILIAL = '"+xFILIAL('SB1')+"' AND ZHC_FILIAL = '"+xFILIAL('ZHC')+"'  "
		cQueryID += " 	AND   SUBSTRING(ZHC_TIPO,1,2)='01' AND ZHC_IDMRP<>'' "

		IF !EMPTY(cFUCOM)
			cQueryID += " 	AND ZHC_FORN='"+cFUCOM+"'  "
		ENDIF
		cQueryID += " 	AND SB1010.D_E_L_E_T_='' "
		IF SUBSTR(cFILMRP,1,1)=='1'
			cQueryID += " 	AND B1_XFILMRP='1' "
		ENDIF

		IF SUBSTR(cFILEMP,1,1)=='2'//com empenho
			cQueryID += " AND ZHC_PRODUT IN( SELECT D4_COD FROM SD4010 (NOLOCK) "
			cQueryID += " WHERE D4_FILIAL='"+xFILIAL('SD4')+"' AND D4_QUANT>0 AND SD4010.D_E_L_E_T_='' "
			cQueryID += " GROUP BY D4_COD ) "
		ENDIF

		IF SUBSTR(cFILEMP,1,1)=='3'//sem empenho
			cQueryID += " AND ZHC_PRODUT NOT IN( SELECT D4_COD FROM SD4010 (NOLOCK) "
			cQueryID += " WHERE D4_FILIAL='"+xFILIAL('SD4')+"' AND D4_QUANT>0 AND SD4010.D_E_L_E_T_='' "
			cQueryID += " GROUP BY D4_COD ) "
		ENDIF

		IF SUBSTR(cFILPRV,1,1)=='2' // QUERY RETIRAR PRODUTOS COM PREVISAO DE VENDA
			cQueryID += " AND ZHC_PRODUT NOT IN ( "
			cQueryID += " SELECT ZHC_PRODUT  "
			cQueryID += " FROM ZHC010 ZHC (NOLOCK) "
			cQueryID += " WHERE ZHC.ZHC_TIPO IN ('09-Previsao Venda')  "
			cQueryID += " AND ZHC.D_E_L_E_T_='' "
			cQueryID += " AND ZHC.ZHC_FILIAL='"+xFILIAL('ZHC')+"' "
			cQueryID += " AND ZHC.ZHC_SAIDA>0 ) "
		ENDIF

		cQueryID += " 	ORDER BY  ZHC_PRODUT,ZHC_TXDT2 "

		TCQUERY cQueryID NEW ALIAS "TR1"
		TR1->( dbGoTop() )
		DO WHILE .NOT. TR1->(EOF())
			//--------------------------------- filtro
			_nNEC2 :=0
			IF SUBSTR(cFILTRO,1,1)<>'1'
				cQUERYSLD:="	SELECT ZHC_PRODUT , "
				cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QATU),0)              FROM SB2010 (NOLOCK) WHERE B2_FILIAL='"+xFILIAL('SB2')+"' AND  B2_COD=ZHC_PRODUT  AND D_E_L_E_T_='' ) AS  EST, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C1_QUANT-C1_QUJE),0)     FROM SC1010 (NOLOCK) WHERE C1_FILIAL='"+xFILIAL('SC1')+"' AND  C1_PRODUTO=ZHC.ZHC_PRODUT AND D_E_L_E_T_='' AND C1_RESIDUO='' AND  C1_QUANT > C1_QUJE) AS  SOL, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C7_QUANT-C7_QUJE),0)     FROM SC7010 (NOLOCK) WHERE C7_FILIAL='"+xFILIAL('SC7')+"' AND  C7_PRODUTO=ZHC.ZHC_PRODUT AND D_E_L_E_T_='' AND C7_RESIDUO='' AND  C7_QUANT > C7_QUJE) AS  PC, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QEMP),0)              FROM SB2010 (NOLOCK) WHERE B2_FILIAL='"+xFILIAL('SB2')+"' AND  B2_COD=ZHC_PRODUT  AND D_E_L_E_T_='' ) AS  EMP, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(ZHC_XQTDE),0)            FROM ZHC010 (NOLOCK) WHERE ZHC_FILIAL='"+xFILIAL('ZHC')+"'  AND  ZHC_TIPO IN ('06-Ordem Producao') AND ZHC_PRODUT=ZHC.ZHC_PRODUT) AS  OP, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C6_QTDVEN-C6_QTDENT),0)  FROM SC6010 (NOLOCK) WHERE C6_FILIAL='"+xFILIAL('SC6')+"' AND  (C6_QTDVEN-C6_QTDENT)>0 AND D_E_L_E_T_='' AND C6_PRODUTO=ZHC.ZHC_PRODUT AND C6_BLQ<>'R')  AS  PV, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(ZHC_XQTDE),0)            FROM ZHC010 (NOLOCK) WHERE ZHC_FILIAL='"+xFILIAL('ZHC')+"'  AND  ZHC_TIPO IN ('09-Previsao Venda')  AND ZHC_PRODUT=ZHC.ZHC_PRODUT) AS  PREV, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(ZHC_XQTDE),0)            FROM ZHC010 (NOLOCK) WHERE ZHC_FILIAL='"+xFILIAL('ZHC')+"'  AND  ZHC_TIPO IN ('08-Saida Estrutura') AND ZHC_PRODUT=ZHC.ZHC_PRODUT) AS  SAES, "

				cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QATU),0)              FROM SB2010 (NOLOCK) WHERE B2_FILIAL='"+xFILIAL('SB2')+"' AND  B2_COD=ZHC_PRODUT  AND D_E_L_E_T_='') + "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C1_QUANT-C1_QUJE),0)     FROM SC1010 (NOLOCK) WHERE C1_FILIAL='"+xFILIAL('SC1')+"' AND  C1_PRODUTO=ZHC.ZHC_PRODUT AND D_E_L_E_T_='' AND C1_RESIDUO='' AND C1_QUANT > C1_QUJE) + "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C7_QUANT-C7_QUJE),0)     FROM SC7010 (NOLOCK) WHERE C7_FILIAL='"+xFILIAL('SC7')+"' AND  C7_PRODUTO=ZHC.ZHC_PRODUT AND D_E_L_E_T_='' AND C7_RESIDUO='' AND C7_QUANT > C7_QUJE ) - "
				cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QEMP),0)              FROM SB2010 (NOLOCK) WHERE B2_FILIAL='"+xFILIAL('SB2')+"' AND  B2_COD=ZHC_PRODUT  AND D_E_L_E_T_='' ) + "
				cQUERYSLD+="	(SELECT ISNULL(SUM(ZHC_XQTDE),0)            FROM ZHC010 (NOLOCK) WHERE ZHC_FILIAL='"+xFILIAL('ZHC')+"'  AND  ZHC_TIPO IN ('06-Ordem Producao') AND ZHC_PRODUT=ZHC.ZHC_PRODUT) - "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C6_QTDVEN-C6_QTDENT),0)  FROM SC6010 (NOLOCK) WHERE C6_FILIAL='"+xFILIAL('SC6')+"' AND  (C6_QTDVEN-C6_QTDENT)>0 AND D_E_L_E_T_='' AND C6_PRODUTO=ZHC.ZHC_PRODUT  AND C6_BLQ<>'R') - "
				cQUERYSLD+="	(SELECT ISNULL(SUM(ZHC_XQTDE),0)            FROM ZHC010 (NOLOCK) WHERE ZHC_FILIAL='"+xFILIAL('ZHC')+"'  AND  ZHC_TIPO IN ('09-Previsao Venda')  AND ZHC_PRODUT=ZHC.ZHC_PRODUT) AS FINAL "// -       "

				cQUERYSLD+="	FROM ZHC010 (NOLOCK) ZHC "
				cQUERYSLD+="	WHERE ZHC_PRODUT='"+ALLTRIM(TR1->ZHC_PRODUT)+"' AND ZHC_FILIAL = '"+xFILIAL('ZHC')+"' AND ZHC.D_E_L_E_T_=''"
				cQUERYSLD+="	GROUP BY ZHC_PRODUT "
				cQUERYSLD+="	ORDER BY ZHC_PRODUT "

				TCQUERY cQUERYSLD NEW ALIAS "TRS"
				TRS->( dbGoTop() )
				_nNEC2 :=TRS->FINAL
				TRS->(DBCLOSEAREA())
			ENDIF
			//---------------------------------
			lSTATUS :=.F.
			IF TR1->ZHC_STATUS=='X' .OR. TR1->ZHC_STATUS=='S'  //SC CHECK
				lSTATUS :=.T.
			ENDIF
			IF TR1->ZHC_XQTDE >0
				IF (SUBSTR(cFILTRO,1,1)=='1') .OR. (SUBSTR(cFILTRO,1,1)=='2' .and. _nNEC2 <0) .OR. (SUBSTR(cFILTRO,1,1)=='3' .and. _nNEC2 >=0)
					AADD(aColsNEC,{TR1->ZHC_PRODUT,;
						TR1->ZHC_TXDT1,;
						TR1->ZHC_XQTDE,;
						TR1->ZHC_XQTDE*TR1->ZHC_UPRC,;
						TR1->ZHC_NFORN,;
						TR1->ZHC_IDMRP,;
						TR1->ZHC_STATUS,;
						lSTATUS})//.f. POSICAO 8Flag de Delecao]
					nQTDITEM++
				ENDIF
			ENDIF
			TR1->(DBSKIP())
		ENDDO
		TR1->(DBCLOSEAREA())
		oGetNEC:ACOLS:=aCOLSNEC
		oGetNEC:oBrowse:Refresh()
		oQTDITEM:Refresh()
	ENDIF
RETURN

	*----------------------------------------------------------------------------*
USER FUNCTION MRPCHG0F(oGetNEC,oGetSAI,oGetENT)
	*----------------------------------------------------------------------------*
	LOCAL nLIN :=oGetNEC:nat
	LOCAL nTotEnt:=0
	LOCAL nTotSai:=0

	LOCAL nTWON  :=0
	LOCAL nTBEST :=0
	LOCAL nTIN   :=0

	local nX

	IF lFIRST ==.F.

		aCOLSENT :={}
		aCOLSSAI :={}

		//------------------------------------------00 - SALDO ATUAL-----------------------------
		cQueryAT := " SELECT SUM(B2_QATU) AS B2_QATUT FROM SB2010 (NOLOCK)  "
		cQueryAT += " WHERE B2_FILIAL = '"+xFILIAL('SB2')+"' AND B2_COD='"+ALLTRIM(oGetNEC:ACOLS[nLIN][01])+"' "
		cQueryAT += "       AND D_E_L_E_T_=''  "

		TCQUERY cQueryAT NEW ALIAS "TR0"
		TR0->( dbGoTop() )
		nSLDATU:=TR0->B2_QATUT
		onSLDATU:REFRESH()
		TR0->(DBCLOSEAREA())
		//------------------------------------------02 - SALDO INICIAL-----------------------------

		nMSGDIV:=0
		cMSGDIV:=''

		cQuerySI := " SELECT  * "
		cQuerySI += " FROM  ZHC010 (NOLOCK) "
		cQuerySI += " WHERE ZHC010.D_E_L_E_T_='' AND ZHC_FILIAL = '"+xFILIAL('ZHC')+"' AND SUBSTRING(ZHC_TIPO,1,2)='02' " //AND ZHC_IDMRP<>'' "
		cQuerySI += "            AND ZHC_PRODUT    ='"+ALLTRIM(oGetNEC:ACOLS[nLIN][01])+"' "
		cQuerySI += "            AND ZHC_TXDT1 ='"+ALLTRIM(oGetNEC:ACOLS[nLIN][02])+"' "

		TCQUERY cQuerySI NEW ALIAS "TR2"
		TR2->( dbGoTop() )
		nSALDOI:=TR2->ZHC_XQTDE
		oSALDOI:REFRESH()
		TR2->(DBCLOSEAREA())

		nMSGDIV :=nSLDATU-nSALDOI
		IF nMSGDIV == 0
			cMSGDIV:=''
		ELSE
			IF 	ctod(oGetNEC:ACOLS[nLIN][02] )==DATE()
				cMSGDIV:=Transform(nMSGDIV,"@E 9,999,999.999")
			ENDIF
		ENDIF
		oMSGDIV:REFRESH()
		//------------------------------------------03 04 - ENTRADA
		cQuerySI := " SELECT  * "
		cQuerySI += " FROM  ZHC010 (NOLOCK) "
		cQuerySI += " WHERE ZHC010.D_E_L_E_T_='' AND  ZHC_FILIAL = '"+xFILIAL('ZHC')+"' AND SUBSTRING(ZHC_TIPO,1,2) IN('03','04','06') " //AND ZHC_IDMRP<>'' "
		cQuerySI += "            AND ZHC_PRODUT    ='"+ALLTRIM(oGetNEC:ACOLS[nLIN][01])+"' "
		cQuerySI += "            AND ZHC_TXDT1 ='"+ALLTRIM(oGetNEC:ACOLS[nLIN][02])+"' "

		TCQUERY cQuerySI NEW ALIAS "TR2"
		TR2->( dbGoTop() )
		DO WHILE !TR2->(EOF())
			AADD(aColsENT,{TR2->ZHC_TIPO,;
				TR2->ZHC_TEXTO,;
				TR2->ZHC_XQTDE,;
				.F.})//.f. POSICAO 8Flag de Delecao]
			nTotEnt:=nTotEnt+TR2->ZHC_XQTDE
			TR2->(DBSKIP())
		ENDDO
		TR2->(DBCLOSEAREA())
		oGetENT:ACOLS:=aCOLSENT
		oGetENT:ForceRefresh( )

		//------------------------------------------05 07 08 09- SAIDA
		cQuerySI := " SELECT  * "
		cQuerySI += " FROM  ZHC010 (NOLOCK)  "
		cQuerySI += " WHERE ZHC010.D_E_L_E_T_='' AND ZHC_FILIAL = '"+xFILIAL('ZHC')+"' AND SUBSTRING(ZHC_TIPO,1,2) IN('05','07','08','09') " //AND ZHC_IDMRP<>'' "
		cQuerySI += "            AND ZHC_PRODUT    ='"+ALLTRIM(oGetNEC:ACOLS[nLIN][01])+"' "
		cQuerySI += "            AND ZHC_TXDT1 ='"+ALLTRIM(oGetNEC:ACOLS[nLIN][02])+"' "

		TCQUERY cQuerySI NEW ALIAS "TR2"
		TR2->( dbGoTop() )

		DO WHILE !TR2->(EOF())
			AADD(aColsSAI,{TR2->ZHC_TIPO,;
				TR2->ZHC_TEXTO,;
				TR2->ZHC_XQTDE,;
				.F.})//.f. POSICAO 8Flag de Delecao]
			nTotSai:=nTotSai+TR2->ZHC_XQTDE
			DO CASE
			CASE ALLTRIM(TR2->ZHC_TIPO)=='09-Previsao Venda' .AND. ALLTRIM(SUBSTR(TR2->ZHC_TEXTO,1,4))=='WON'
				nTWON  :=nTWON +TR2->ZHC_XQTDE
			CASE ALLTRIM(TR2->ZHC_TIPO)=='09-Previsao Venda' .AND. ALLTRIM(SUBSTR(TR2->ZHC_TEXTO,1,4))=='BEST'
				nTBEST :=nTBEST+TR2->ZHC_XQTDE
			CASE ALLTRIM(TR2->ZHC_TIPO)=='09-Previsao Venda' .AND. ALLTRIM(SUBSTR(TR2->ZHC_TEXTO,1,4))=='IN'
				nTIN   :=nTIN  +TR2->ZHC_XQTDE
			ENDCASE
			TR2->(DBSKIP())
		ENDDO
		TR2->(DBCLOSEAREA())
		oGetSAI:ACOLS:=aCOLSSAI
		oGetSAI:forceRefresh( )

		cPRODUTO:=oGetNEC:ACOLS[nLIN][01]
		cDESCRI:=POSICIONE('SB1',1,xFILIAL('SB1')+oGetNEC:ACOLS[nLIN][01],'B1_DESC')
		cIDMRP:=oGetNEC:ACOLS[nLIN][06] //mls
		dData :=ctod(oGetNEC:ACOLS[nLIN][02] )

		//------------------------------------------necessidade total
		nTSALDOF :=0
		FOR nX:=1 TO LEN(oGetNEC:ACOLS)
			IF oGetNEC:ACOLS[nX][01]==oGetNEC:ACOLS[nLIN][01]
				nTSALDOF+=oGetNEC:ACOLS[nX][03]
			ENDIF
		NEXT

		//------------------------------------------SCs
		nSCA    :=0
		aColsSC :={}

		cQUERYSC := " SELECT C1_NUM,C1_DATPRF,C1_QUANT-C1_QUJE AS C1_SALDO  "
		cQUERYSC += " FROM SC1010 (NOLOCK)               "
		cQUERYSC += " WHERE C1_FILIAL = '"+xFILIAL('SC1')+"' AND                     "
		cQUERYSC += " C1_QUANT > C1_QUJE AND     "
		cQUERYSC += " C1_QUJE  >=0       AND     "
		cQUERYSC += " C1_RESIDUO=''      AND     "
		cQUERYSC += " C1_PRODUTO='"+ALLTRIM(oGetNEC:ACOLS[nLIN][01])+"' AND "
		cQUERYSC += " D_E_L_E_T_=''                  "
		cQUERYSC += " ORDER BY C1_DATPRF "

		TCQUERY cQUERYSC NEW ALIAS "TRSC"
		TRSC->( dbGoTop() )

		DO WHILE !TRSC->(EOF())
			AADD(aColsSC,{TRSC->C1_NUM,;
				substr(TRSC->C1_DATPRF,7,2)+'/'+substr(TRSC->C1_DATPRF,5,2)+'/'+substr(TRSC->C1_DATPRF,1,4),;
				TRSC->C1_SALDO,;
				.F.})//.f. POSICAO 8Flag de Delecao]

			nSCA +=TRSC->C1_SALDO
			TRSC->(DBSKIP())
		ENDDO
		TRSC->(DBCLOSEAREA())

		//------------------------------------------PCs
		nPCA    :=0
		aColsPC :={}

		cQUERYPC := " SELECT C7_NUM,C7_DATPRF,C7_QUANT-C7_QUJE AS C7_SALDO "
		cQUERYPC += " FROM SC7010 (NOLOCK)               "
		cQUERYPC += " WHERE C7_FILIAL = '"+xFILIAL('SC1')+"' AND                      "
		cQUERYPC += " C7_QUANT > C7_QUJE AND     "
		cQUERYPC += " C7_QUJE  >=0       AND     "
		cQUERYPC += " C7_RESIDUO=''      AND     "
		cQUERYPC += " C7_PRODUTO='"+ALLTRIM(oGetNEC:ACOLS[nLIN][01])+"' AND  "
		cQUERYPC += " D_E_L_E_T_=''           "
		cQUERYPC += " ORDER BY C7_DATPRF "

		TCQUERY cQUERYPC NEW ALIAS "TRPC"
		TRPC->( dbGoTop() )

		DO WHILE !TRPC->(EOF())
			AADD(aColsPC,{TRPC->C7_NUM,;
				substr(TRPC->C7_DATPRF,7,2)+'/'+substr(TRPC->C7_DATPRF,5,2)+'/'+substr(TRPC->C7_DATPRF,1,4),;
				TRPC->C7_SALDO,;
				.F.})//.f. POSICAO 8Flag de Delecao]

			nPCA +=TRPC->C7_SALDO
			TRPC->(DBSKIP())
		ENDDO
		TRPC->(DBCLOSEAREA())

		//------------------------------------------MV MOVIMENTO ENTRADA
		aColsMV :={}

		cQUERYMV := " SELECT D1_DOC,D1_DTDIGIT,D1_EMISSAO,D1_QUANT ,D1_PEDIDO+'/'+D1_ITEMPC AS D1_PC "
		cQUERYMV += " 	 FROM SD1010 (NOLOCK) D1,SF4010 (NOLOCK) F4 "
		cQUERYMV += " WHERE F4_CODIGO=D1_TES AND F4_FILIAL = '"+xFILIAL('SF4')+"' "
		cQUERYMV += "       AND F4_ESTOQUE='S'  "
		cQUERYMV += "       AND D1_DTDIGIT='"+DTOS(DATE())+"'  "
		cQUERYMV += "       AND D1_COD='"+ALLTRIM(oGetNEC:ACOLS[nLIN][01])+"' "
		cQUERYMV += "       AND F4.D_E_L_E_T_='' "
		cQUERYMV += "       AND D1.D_E_L_E_T_='' "
		cQUERYMV += "       ORDER BY D1_DOC  "

		TCQUERY cQUERYMV NEW ALIAS "TRMV"
		TRMV->( dbGoTop() )

		DO WHILE !TRMV->(EOF())
			AADD(aColsMV,{'NFe '+TRMV->D1_DOC,;
				TRMV->D1_PC,;
				substr(TRMV->D1_DTDIGIT,7,2)+'/'+substr(TRMV->D1_DTDIGIT,5,2)+'/'+substr(TRMV->D1_DTDIGIT,1,4),;
				TRMV->D1_QUANT,;
				.F.})//.f. POSICAO 8Flag de Delecao]

			TRMV->(DBSKIP())
		ENDDO
		TRMV->(DBCLOSEAREA())
		*---------------------------------------------------------------------
		cQUERYMV2 := "	  select * from SD3010 (NOLOCK) "
		cQUERYMV2 += "   where D3_FILIAL = '"+xFILIAL('SD3')+"' AND D3_COD='"+ALLTRIM(oGetNEC:ACOLS[nLIN][01])+"' "
		cQUERYMV2 += "   and D3_EMISSAO='"+DTOS(DATE())+"'  "
		cQUERYMV2 += "   AND D_E_L_E_T_='' "
		cQUERYMV2 += "   AND D3_ESTORNO='' "
		cQUERYMV2 += "   ORDER BY D3_CF "

		TCQUERY cQUERYMV2 NEW ALIAS "TRMV"
		TRMV->( dbGoTop() )
		nQTDMV :=0
		DO WHILE !TRMV->(EOF())
			IF TRMV->D3_TM<='500'
				nQTDMV :=nQTDMV +TRMV->D3_QUANT
			ELSE
				nQTDMV :=nQTDMV -TRMV->D3_QUANT
			ENDIF
			TRMV->(DBSKIP())
		ENDDO
		IF nQTDMV<>0
			AADD(aColsMV,{'Mov.Int',;
				'',;
				substr(TRMV->D3_EMISSAO,7,2)+'/'+substr(TRMV->D3_EMISSAO,5,2)+'/'+substr(TRMV->D3_EMISSAO,1,4),;
				nQTDMV,;
				.F.})//.f. POSICAO 8Flag de Delecao]
		ENDIF
		TRMV->(DBCLOSEAREA())

		//------------------------------------------MLS QUERY
		_nEST  :=0
		_nSC   :=0
		_nPC   :=0
		_nEMP  :=0
		_nOP   :=0
		_nPV   :=0
		_nPREV :=0
		_nSAES :=0
		_nNEC1 :=0

		cQUERYSLD:="	SELECT ZHC_PRODUT , "
		//	cQUERYSLD+="	(SELECT TOP 1 ZHC_XQTDE FROM ZHC010 WHERE ZHC_TIPO IN ('02-Saldo Estoque' ) AND ZHC_PRODUT=ZHC.ZHC_PRODUT) AS  EST, "
		cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QATU),0) FROM SB2010 (NOLOCK) WHERE B2_FILIAL='"+xFILIAL('SB2')+"' AND  B2_COD=ZHC_PRODUT  AND D_E_L_E_T_='' AND B2_FILIAL='"+xFILIAL('SB2')+"' ) AS  EST, "
		cQUERYSLD+="	(SELECT ISNULL(SUM(C1_QUANT-C1_QUJE),0)  FROM SC1010 (NOLOCK) WHERE C1_FILIAL='"+xFILIAL('SC1')+"' AND  C1_PRODUTO=ZHC.ZHC_PRODUT AND D_E_L_E_T_='' AND C1_RESIDUO='' AND  C1_QUANT > C1_QUJE) AS  SOL, "
		cQUERYSLD+="	(SELECT ISNULL(SUM(C7_QUANT-C7_QUJE),0)  FROM SC7010 (NOLOCK) WHERE C7_FILIAL='"+xFILIAL('SC7')+"' AND  C7_PRODUTO=ZHC.ZHC_PRODUT AND D_E_L_E_T_='' AND C7_RESIDUO='' AND  C7_QUANT > C7_QUJE) AS  PC, "
		//	cQUERYSLD+="	(SELECT ISNULL(SUM(ZHC_XQTDE),0)  FROM ZHC010 WHERE ZHC_TIPO IN ('05-Empenho       ') AND ZHC_PRODUT=ZHC.ZHC_PRODUT) AS  EMP, "
		cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QEMP),0) FROM SB2010 (NOLOCK)  WHERE B2_FILIAL='"+xFILIAL('SB2')+"' AND  B2_COD=ZHC_PRODUT  AND D_E_L_E_T_='' ) AS  EMP, "
		cQUERYSLD+="	(SELECT ISNULL(SUM(ZHC_XQTDE),0)  FROM ZHC010 (NOLOCK) WHERE ZHC_FILIAL='"+xFILIAL('ZHC')+"' AND   ZHC_TIPO IN ('06-Ordem Producao') AND ZHC_PRODUT=ZHC.ZHC_PRODUT) AS  OP, "
		//	cQUERYSLD+="	(SELECT ISNULL(SUM(ZHC_XQTDE),0)  FROM ZHC010 WHERE ZHC_TIPO IN ('07-Pedido Venda  ') AND ZHC_PRODUT=ZHC.ZHC_PRODUT) AS  PV, "
		cQUERYSLD+="	(SELECT ISNULL(SUM(C6_QTDVEN-C6_QTDENT),0)  FROM SC6010 (NOLOCK) WHERE C6_FILIAL='"+xFILIAL('SC6')+"' AND  (C6_QTDVEN-C6_QTDENT)>0 AND D_E_L_E_T_='' AND C6_PRODUTO=ZHC.ZHC_PRODUT AND C6_BLQ<>'R')  AS  PV, "
		cQUERYSLD+="	(SELECT ISNULL(SUM(ZHC_XQTDE),0)  FROM ZHC010 (NOLOCK) WHERE ZHC_FILIAL='"+xFILIAL('ZHC')+"' AND  ZHC_TIPO IN ('09-Previsao Venda')  AND ZHC_PRODUT=ZHC.ZHC_PRODUT) AS  PREV, "
		cQUERYSLD+="	(SELECT ISNULL(SUM(ZHC_XQTDE),0)  FROM ZHC010 (NOLOCK) WHERE ZHC_FILIAL='"+xFILIAL('ZHC')+"' AND  ZHC_TIPO IN ('08-Saida Estrutura') AND ZHC_PRODUT=ZHC.ZHC_PRODUT) AS  SAES, "

		cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QATU),0) FROM SB2010 (NOLOCK) WHERE B2_FILIAL='"+xFILIAL('SB2')+"' AND  B2_COD=ZHC_PRODUT  AND D_E_L_E_T_='') + "
		cQUERYSLD+="	(SELECT ISNULL(SUM(C1_QUANT-C1_QUJE),0)  FROM SC1010 (NOLOCK) WHERE C1_FILIAL='"+xFILIAL('SC1')+"' AND  C1_PRODUTO=ZHC.ZHC_PRODUT AND D_E_L_E_T_='' AND C1_RESIDUO='' AND C1_QUANT > C1_QUJE) + "
		cQUERYSLD+="	(SELECT ISNULL(SUM(C7_QUANT-C7_QUJE),0)  FROM SC7010 (NOLOCK) WHERE C7_FILIAL='"+xFILIAL('SC7')+"' AND  C7_PRODUTO=ZHC.ZHC_PRODUT AND D_E_L_E_T_='' AND C7_RESIDUO='' AND C7_QUANT > C7_QUJE ) - "
		cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QEMP),0) FROM SB2010 (NOLOCK)  WHERE B2_FILIAL='"+xFILIAL('SB2')+"' AND  B2_COD=ZHC_PRODUT  AND D_E_L_E_T_='' ) + "
		cQUERYSLD+="	(SELECT ISNULL(SUM(ZHC_XQTDE),0)  FROM ZHC010 (NOLOCK) WHERE ZHC_FILIAL='"+xFILIAL('ZHC')+"' AND  ZHC_TIPO IN ('06-Ordem Producao') AND ZHC_PRODUT=ZHC.ZHC_PRODUT) - "
		//	cQUERYSLD+="	(SELECT ISNULL(SUM(ZHC_XQTDE),0)  FROM ZHC010 WHERE ZHC_TIPO IN ('07-Pedido Venda  ') AND ZHC_PRODUT=ZHC.ZHC_PRODUT) - "
		cQUERYSLD+="	(SELECT ISNULL(SUM(C6_QTDVEN-C6_QTDENT),0)  FROM SC6010 (NOLOCK) WHERE C6_FILIAL='"+xFILIAL('SC6')+"' AND  (C6_QTDVEN-C6_QTDENT)>0 AND D_E_L_E_T_='' AND C6_PRODUTO=ZHC.ZHC_PRODUT  AND C6_BLQ<>'R') - "
		cQUERYSLD+="	(SELECT ISNULL(SUM(ZHC_XQTDE),0)  FROM ZHC010 (NOLOCK) WHERE ZHC_FILIAL='"+xFILIAL('ZHC')+"' AND  ZHC_TIPO IN ('09-Previsao Venda')  AND ZHC_PRODUT=ZHC.ZHC_PRODUT) AS FINAL "// -       "
		//	cQUERYSLD+="	(SELECT ISNULL(SUM(ZHC_XQTDE),0)  FROM ZHC010 (NOLOCK) WHERE ZHC_TIPO IN ('08-Saida Estrutura') AND ZHC_PRODUT=ZHC.ZHC_PRODUT) AS FINAL "

		cQUERYSLD+="	FROM ZHC010 (NOLOCK) ZHC "
		cQUERYSLD+="	WHERE ZHC_PRODUT='"+ALLTRIM(oGetNEC:ACOLS[nLIN][01])+"'  AND ZHC.D_E_L_E_T_='' "
		cQUERYSLD+="	GROUP BY ZHC_PRODUT "
		cQUERYSLD+="	ORDER BY ZHC_PRODUT "

		TCQUERY cQUERYSLD NEW ALIAS "TRS"
		TRS->( dbGoTop() )
		_nEST  :=TRS->EST
		_nSC   :=TRS->SOL
		_nPC   :=TRS->PC
		_nEMP  :=TRS->EMP
		_nOP   :=TRS->OP
		_nPV   :=TRS->PV
		_nPREV :=TRS->PREV
		_nSAES :=TRS->SAES
		_nNEC1 :=TRS->FINAL
		TRS->(DBCLOSEAREA())   //_nEMP-_nSAES

		nENTRADA:=nTotEnt
		nSAIDA  :=nTotSai
		nSALDOF :=(nSALDOI+nTotEnt)-nTotSai

		nWON   :=nTWON
		nBEST  :=nTBEST
		nIN    :=nTIN

		oPRODUTO:REFRESH()
		oDESCRI :REFRESH()
		oIDMRP  :REFRESH()
		oDATA   :REFRESH()
		oENTRADA:REFRESH()
		oSAIDA  :REFRESH()
		oSALDOF :REFRESH()
		oTSALDOF:REFRESH()
		oSCA    :REFRESH()
		oPCA    :REFRESH()

		//oWON    :REFRESH()
		//oBEST   :REFRESH()
		//oIN     :REFRESH()

		IF _nNEC1<0
			cMSG1  :=''
			cMSG1B :='Saldo SC+PC Menor que Necessidade: '+cEOL   //+TRANSFORM(_nNEC1,"@E 999,999.99")
			cMSG1B +='+EST:' +TRANSFORM(_nEST ,"@E 9,999,999.99") +' +SC: '+TRANSFORM(_nSC  ,"@E 9,999,999.99")+' +PC :'+TRANSFORM(_nPC  ,"@E 9,999,999.99")+cEOL
			cMSG1B +='-EMP:' +TRANSFORM(_nEMP ,"@E 9,999,999.99") +' -PV: '+TRANSFORM(_nPV  ,"@E 9,999,999.99")+' -PRV:'+TRANSFORM(_nPREV,"@E 9,999,999.99")+cEOL
			IF _nSAES-_nEMP>0
				cMSG1B +='=SLD:' +TRANSFORM(_nNEC1,"@E 9,999,999.99") +'      Saida Estrutura:' +TRANSFORM(_nSAES-_nEMP,"@E 9,999,999.99")
			ELSE
				cMSG1B +='=SLD:' +TRANSFORM(_nNEC1,"@E 9,999,999.99")
			ENDIF
			cMSG1C :=''
		ELSE
			cMSG1 :='Saldo SC+PC Maior que Necessidade: '+cEOL   //+TRANSFORM(_nNEC1,"@E 999,999.99")
			cMSG1b:=''
			cMSG1C :=''

			cMSG1 +='+EST:' +TRANSFORM(_nEST ,"@E 9,999,999.99") +' +SC: '+TRANSFORM(_nSC,"@E 9,999,999.99")+' +PC :'+TRANSFORM(_nPC  ,"@E 9,999,999.99")+cEOL
			cMSG1 +='-EMP:' +TRANSFORM(_nEMP ,"@E 9,999,999.99") +' -PV: '+TRANSFORM(_nPV,"@E 9,999,999.99")+' -PRV:'+TRANSFORM(_nPREV,"@E 9,999,999.99")+cEOL
			IF _nSAES-_nEMP>0
				cMSG1 +='=SLD:' +TRANSFORM(_nNEC1,"@E 9,999,999.99") +'      Saida Estrutura:' +TRANSFORM(_nSAES-_nEMP,"@E 9,999,999.99")
			ELSE
				cMSG1 +='=SLD:' +TRANSFORM(_nNEC1,"@E 9,999,999.99")
			ENDIF

		ENDIF
		IF nSALDOF>=0
			cMSG1 :=''
			cMSG1b:=''
			cMSG1C:='Item com Saldo'
		ENDIF
		//MLS
		cQuerySI := " SELECT  * "
		cQuerySI += " FROM ZHC010 (NOLOCK)  "
		cQuerySI += " WHERE ZHC_FILIAL = '"+xFILIAL('ZHC')+"' AND ZHC_IDMRP='"+ALLTRIM(oGetNEC:ACOLS[nLIN][06])+"' AND ZHC010.D_E_L_E_T_='' "

		TCQUERY cQuerySI NEW ALIAS "TR2"
		TR2->( dbGoTop() )
		IF !EMPTY(TR2->ZHC_NUMSC)
			cMSG2 :='SC: '+TR2->ZHC_NUMSC+' Qtde: '+Transform(TR2->ZHC_QTDSC,"@E 9,999,999.99")+" Data: "+SUBSTR(TR2->ZHC_DATASC,7,2)+'/'+SUBSTR(TR2->ZHC_DATASC,5,2)+'/'+SUBSTR(TR2->ZHC_DATASC,1,4)
			cMSG2b:=''
		ELSE
			cMSG2 :=''
			cMSG2b:=''
		ENDIF
		TR2->(DBCLOSEAREA())
		oMSG1 :refresh()
		oMSG1b:refresh()
		oMSG1c:refresh()

		oMSG2 :refresh()
		oMSG2b:refresh()

	ENDIF

RETURN

	*----------------------------------------------------------------------------*
USER FUNCTION MRPSCPCF()
	*----------------------------------------------------------------------------*
	Local aSizeAut    := MsAdvSize(,.F.,400)
	DEFINE MSDIALOG oDlg2 FROM aSizeAut[4],aSizeAut[4] TO aSizeAut[3]*3,aSizeAut[3]+aSizeAut[4]  TITLE OemToAnsi("MRP DOMEX SCs PCs EM ABERTO") OF oMainWnd PIXEL

	@ 05,10 SAY ALLTRIM(cPRODUTO)+' - '+ALLTRIM(cDESCRI) OF oDlg2 PIXEL SIZE 300,040 FONT oFontBRW4

	oGetSC:= (MsNewGetDados():New( 025,015,095,300,/*GD_UPDATE */,/*"U_FAT002LOK()"*/  ,/*REQ_OPSD3()*/,/*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*Ffieldok*/,/*superdel*/,/*delok*/,oDlg2,aHEADSC,aCOLSSC))
	oGetSC:oBrowse:Refresh()

	oGetPC:= (MsNewGetDados():New( 105,015,175,300,/*GD_UPDATE*/ ,/*"U_FAT002LOK()"*/  ,/*REQ_OPSD3()*/,/*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*Ffieldok*/,/*superdel*/,/*delok*/,oDlg2,aHEADPC,aCOLSPC))
	oGetPC:oBrowse:Refresh()

	oGetMV:= (MsNewGetDados():New( 185,015,255,300,/*GD_UPDATE*/ ,/*"U_FAT002LOK()"*/  ,/*REQ_OPSD3()*/,/*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*Ffieldok*/,/*superdel*/,/*delok*/,oDlg2,aHEADMV,aCOLSMV))
	oGetMV:oBrowse:Refresh()

	ACTIVATE MSDIALOG oDlg2  CENTERED

RETURN

	*----------------------------------------------------------------------------*
USER FUNCTION  MRPCHK0F(oGetNEC)
	*----------------------------------------------------------------------------*
	LOCAL nLIN :=oGetNEC:nat
	LOCAL cQ1 := ""
	IF oGetNEC:ACOLS[nLIN][07]<>'X' // COM SC
		IF oGetNEC:ACOLS[nLIN][08]==.T. //DELETADO
			oGetNEC:ACOLS[nLIN][08]:=.F.
			cQ1 := "UPDATE ZHC010 SET ZHC_STATUS='N' WHERE ZHC_FILIAL='"+xFILIAL('ZHC')+"' AND  ZHC_IDMRP='"+oGetNEC:ACOLS[nLIN][06]+"'"
		ELSE
			oGetNEC:ACOLS[nLIN][08]:=.T. //DELETADO
			cQ1 := "UPDATE ZHC010 SET ZHC_STATUS='S' WHERE ZHC_FILIAL='"+xFILIAL('SB1')+"' AND SZHC_IDMRP='"+oGetNEC:ACOLS[nLIN][06]+"'"
		ENDIF
		TCSQLEXEC(cQ1)
	ENDIF
	oGetNEC:oBrowse:Refresh()

RETURN

	*----------------------------------------------------------------------------*
USER FUNCTION MRP02SCF()
	*----------------------------------------------------------------------------*

	Local cTitulo        := "ZHC"
	Local oDLG1Marc
	Local oFnt
	Local aBotoes        := {}
	Local lopc           :=.F.
	local cvirgula       := ""

	Local oOK	         := LoadBitmap( GetResources(), "LBOK" )
	Local oNO	         := LoadBitmap( GetResources(), "LBNO" )

	Private cStatus:=''

	PRIVATE cTITULOE     :='SOLICITACAO DE COMPRAS - MRP'

	Private oNor         := LoadBitmap( GetResources(), "PMSEDT1" )
	Private oSC	         := LoadBitmap( GetResources(), "PMSEDT2" )
	Private oIn	         := LoadBitmap( GetResources(), "PMSEDT3" )

	Private lNExistDados := .F.

	Private aDados       := {}
	Private aDados2      := {}
	Private aItens       := {}
	Private lJaMarcou    := .F.
	Private aVetTit      := {}

	Private oDataSC
	Private oQTDSC
	Private oQTDPRV
	Private oUnidReq

	Private dDATASC     :=DATE()
	Private nQTDSC      :=0
	Private cUnidReq    :='00013'

	DbSelectArea("SX3")

	MsgRun("Espere... Buscando Dados...",,{ || MRPSC003(@aDados) })

	If lNExistDados
		alert("Nao existe dados")
		Return()
	EndIf

	Define FONT oFnt  NAME "Arial" Size 08,10
	Define FONT oFnt2 NAME "Arial" Size 10,16 BOLD

	AAdd(aBotoes,{"Inverte"       ,  {|| MarcInv() }, "Inverte"      ,"Inverte"    })//
	AAdd(aBotoes,{"Marca todos"   ,  {|| MarcAll() }, "Marc Todos"   ,"Marc Todos" })//

	oTesta := oSC
	cTitulo:= "MRP Geracao de Solicitacao de Compras"

	IF EMPTY(cPRODUTO)
		MSGALERT('Produto em branco')
		RETURN
	ENDIF

	If SB1->(dbSeek(xFilial("SB1")+cPRODUTO))
		IF ALLTRIM(SB1->B1_LIBCOMP)=='2'
			MSGALERT('Produto Bloqueado para Compra (LIBCOMP=2)')
			RETURN
		ENDIF
		IF ALLTRIM(SB1->B1_MSBLQL)=='1'
			MSGALERT('Produto com Bloqueio de cadastro (MSBLQL=1)')
			RETURN
		ENDIF
		IF ALLTRIM(SB1->B1_STATUS)=='2'
			MSGALERT('Produto desativado (STATUS=2)')
			RETURN
		ENDIF
		IF ALLTRIM(SB1->B1_STATUS)=='3'
			MSGALERT('Produto obsoleto (STATUS=3)')
			RETURN
		ENDIF
	ENDIF

	Define MsDialog oDLG1Marc Title cTitulo Of oMainWnd Pixel From 0,0 To 420,650//550,950

	@ 32,01 To 74,325 Of oDLG1Marc Pixel
	@ 39,  5  Say   ALLTRIM(Str(Len(aDados))) + " Itens  MRP" Size  200,09 Of oDLG1Marc Pixel Font oFnt2 Color CLR_BLUE,CLR_WHITE
	@ 56,  5  Say   alltrim(cPRODUTO) + " -  " +cDESCRI   Size  200,09 Of oDLG1Marc Pixel Font oFnt2 Color CLR_BLUE,CLR_WHITE

	@ 39,150 BitMap oBmp ResName "PMSEDT3"   	Size  9,09 Of oDLG1Marc Pixel NoBorder
	@ 39,160 Say "Com SC colocada" 			 	Size 60,09 Of oDLG1Marc Pixel

	@ 39,240 BitMap oBmp ResName "PMSEDT1"  	    Size  9,09 Of oDLG1Marc Pixel NoBorder
	@ 39,250 Say "Sem SC colocada" 			       Size 100,09 Of oDLG1Marc Pixel

	@ 79,01 ListBox oLbx Fields ;
		Colsizes 0,0,10,15,07,15,15,20,40,50,50,15,15,15 Size 325,090 Of oDLG1Marc Pixel On DBlClick ( aDados[oLbx:nAt,1] := !aDados[oLbx:nAt,1] , scresumo(),oLbx:Refresh(.F.) )

	oLbx:aHeaders := {  " "   ,;   //01
	" "                       ,;   //02
	"ID MRP    "              ,;   //03
	"Data      "              ,;   //04
	"Quantidade"              ,;   //05
	"Numero SC "   }               //06

	oLbx:SetArray(aDados)
	oLbx:bLine  := { || {If(aDados[oLbx:nAt,1],oOK,oNO) ,;
		aDados[oLbx:nAt,2],;
		aDados[oLbx:nAt,3],;
		aDados[oLbx:nAt,4],;
		aDados[oLbx:nAt,5],;
		aDados[oLbx:nAt,6] }}

	oLbx:bChange  := { || {SCRESUMO(@aDados2)}}
	oLbx:SetFocus()

	@ 174,010 SAY OemToAnsi("Data SC" )                OF oDLG1Marc PIXEL SIZE 250,010 FONT oFontBRW3 Color CLR_BLUE,CLR_WHITE
	@ 174,045 MSGET oDataSC  VAR dDATASC   WHEN(.T.)   OF oDLG1Marc SIZE 055,005  PIXEL COLOR CLR_HBLUE FONT oFontBRW3

	@ 174,110 SAY OemToAnsi("Unid.Req." )              OF oDLG1Marc PIXEL SIZE 250,010 FONT oFontBRW3 Color CLR_BLUE,CLR_WHITE
	@ 174,145 MSGET oUnidReq VAR cUnidReq  WHEN(.T.)   OF oDLG1Marc SIZE 055,005  F3('SY3')   PIXEL COLOR CLR_HBLUE FONT oFontBRW3

	@ 174,210 SAY OemToAnsi("Qtde SC" )                OF oDLG1Marc PIXEL SIZE 250,010 FONT oFontBRW3 Color CLR_BLUE,CLR_WHITE
	@ 174,245 MSGET oQTDSC  VAR nQTDSC     WHEN(.T.)   OF oDLG1Marc SIZE 070,005 PICTURE ("@E 9,999,999,999.99") PIXEL COLOR CLR_HBLUE FONT oFontBRW3

	@ 192,030 Say "Inverte Selecao" 			       Size 050,09 Of oDLG1Marc Pixel
	@ 192,140 Say "Marcar Todos   " 			       Size 050,09 Of oDLG1Marc Pixel
	@ 192,250 Say "Gerar SC       " 			       Size 050,09 Of oDLG1Marc Pixel

	@ 192,010  BITMAP oBmp ResName "SELECT"        Of oDLG1Marc Size 090,20 ON CLICK (MarcInv())   NoBorder  Pixel
	@ 192,120  BITMAP oBmp ResName "SELECTALL"     Of oDLG1Marc Size 090,20 ON CLICK (MarcAll())   NoBorder  Pixel
	@ 192,230  BITMAP oBmp ResName "EMPILHADEIRA"  Of oDLG1Marc Size 090,20 ON CLICK (MRPGERSC(dDATASC,nQTDSC,cPRODUTO,cIDMRP,cUnidReq))  NoBorder  Pixel

	Activate MsDialog oDLG1Marc Center On Init EnchoiceBar(oDLG1Marc,{|| oDLG1Marc:End() },{|| oDLG1Marc:End() },,aBotoes)
	oGetNEC:oBrowse:Refresh()

	MRPZPRV(oGetSAI,cPRODUTO)

return()

	*-------------------------------------------------------------------------------------------------------------
Static Function MarcInv() //Inverte
	*-------------------------------------------------------------------------------------------------------------
	Local i := 1

	For i := 1 To Len(aDados)
		If aDados[i,1] == .T.
			aDados[i,1] := .F.
		Else
			If aDados[i,2] <> oIn//oNor
				aDados[i,1] := .T.
			EndIf
		EndIF
	Next i

	oLbx:Refresh(.F.)
	SCRESUMO()
Return()

	*-------------------------------------------------------------------------------------------------------------
Static Function MarcAll() //Marca todos
	*-------------------------------------------------------------------------------------------------------------
	Local i := 1

	For i := 1 To Len(aDados)
		If aDados[i,2] <> oIn //oNor
			aDados[i,1] := .T.
		Else
			aDados[i,1] := .F.
		EndIf
	Next i

	oLbx:Refresh(.F.)
	SCRESUMO()
Return()

	*-------------------------------------------------------------------------------------------------------------
Static Function MRPSC003()
	*-------------------------------------------------------------------------------------------------------------
	LOCAL nLIN    :=oGetNEC:nat
	Local cPedido := "000000"
	local nCount  := 1
	local nCount2 := 1
	Local cQuery  := ''
	Local oTMP

	cQuery := " Select * From " + RetSqlName("ZHC") + " (NOLOCK) ZHC "
	cQuery += " Where ZHC_FILIAL = '"+xFILIAL('ZHC')+"' "
	cQuery += " AND ZHC_PRODUT = '"+oGetNEC:ACOLS[nLIN][01]+"' AND ZHC_IDMRP <> '' AND ZHC.D_E_L_E_T_=''  "//AND ZHC_STATUS<>'X' "
	cQuery += " Order BY ZHC_IDMRP "

	cQuery := ChangeQuery( cQuery )

	TCQUERY cQuery NEW ALIAS "TMP"

	DbSelectArea("TMP")
	TMP->(DbGotop())

	If TMP->(EOF())
		lNExistDados := .T.
		DbSelectArea("TMP")
		DbCloseArea()
		Return()
	EndIf

	DbSelectArea("TMP")
	TMP->(DbGotop())

	DO While !TMP->(EOF())
		IF TMP:=ZHC_STATUS<>'X'
			oTMP:=oNor
		ELSE
			oTMP:=oIn
		ENDIF
		AADD(aDados, {  .F. , ;
			oTMP ,;
			TMP->ZHC_IDMRP,;
			TMP->ZHC_TXDT1,;
			TMP->ZHC_XQTDE ,;
			TMP->ZHC_NUMSC})

		TMP->(DbSkip())
		nCount ++
	EndDo

	DbSelectArea("TMP")
	TMP->(DbCloseArea())

Return()

	*--------------------------------------------------------*
STATIC FUNCTION SCRESUMO()
	*--------------------------------------------------------*
	LOCAL nX      :=0
	LOCAL _dDATASC :=DATE()
	LOCAL _nTOTSC  :=0
	LOCAL lFIRST  :=.T.

	FOR nX:=1 TO LEN(aDADOS)
		IF !EMPTY(aDados[nX][6])//	IF aDados[nX][1] ==.T. .AND. !EMPTY(aDados[nX][6])
			aDados[nX][1] :=.F.
		ENDIF
	NEXT


	FOR nX:=1 TO LEN(aDADOS)
		IF aDados[nX][1] ==.T. .AND. EMPTY(aDados[nX][6])
			IF lFIRST
				_dDATASC:=CTOD(aDados[nX][4])
				lFIRST:=.F.
			ENDIF
			_nTOTSC:=_nTOTSC+(aDados[nX][5])
		ENDIF
	NEXT
	dDATASC     :=_dDATASC
	nQTDSC      :=_nTOTSC

	oDATASC:refresh()
	oQTDSC:refresh()
	oLbx:Refresh(.F.)

RETURN

	*------------------------------------------------------------------------------------*
STATIC FUNCTION MRPGERSC(dDATASC,nQTDSC,cPRODUTO,_cIDMRP,_cUnidReq)
	*------------------------------------------------------------------------------------*

	Local cAliasAnt:=GetArea()
	Local nCont     :=1
	Local aCab      :={}
	Local aItem     :={}
	Local aCabItem  :={}
	Local cScAnt
	Local cItem     := StrZero(0,Len(SC1->C1_ITEM))
	Local cNumero
	Local nSaveSX8  := GetSX8Len()
	Local _dDATASC  := dDATASC
	Local _nQTDSC   := nQTDSC
	Local _cPRODUTO := cPRODUTO
	Local I         :=0
	Local nTamUser  :=15
	Local cQ1       :=""

//------------------------------------------------------------------------------------------------------------
	IF MSGYESNO("Gerar Solicitacao de compras SC ?")

		cNumero :=  GetSx8Num("SC1","C1_NUM"); ConfirmSX8()
		//------------------------------------------------------------------------------------------------------------

		aCab := {{"C1_NUM"		, cNumero  ,Nil},;
			{"C1_EMISSAO"	,dDataBase ,Nil},;
			{"C1_SOLICIT"	,Substr(cUsuario,7,nTamUser) }}

		SB1->(DbSetOrder(1))
		SB1->(MsSeek(xFilial("SB1")+_cPRODUTO))

		cItem := Soma1(cItem,Len(SC1->C1_ITEM))

		AADD(aItem,{{"C1_ITEM"   ,cItem ,Nil },;
			{"C1_PRODUTO"            ,_cPRODUTO  ,Nil },;
			{"C1_UM"                 ,SB1->B1_UM ,Nil },;
			{"C1_QUANT"              ,_nQTDSC,Nil },;
			{"C1_DATPRF"             ,_dDATASC,Nil },;
			{"C1_LOCAL"              ,SB1->B1_LOCPAD,Nil },;
			{"C1_OBS"                ,'',Nil },;
			{"C1_EMISSAO"            ,DATE(),Nil },;
			{"C1_DESCRI "            ,SB1->B1_DESC,Nil },;
			{"C1_XXOBS"              ,'SC GERADA MRP'   ,Nil },;
			{"C1_XXIDMRP "           ,_cIDMRP   ,Nil },;
			{"C1_XXHIMRP"            ,'MRP '+DTOC(DATE())   ,Nil }})

		lMsErroAuto := .f.

		//MSExecAuto({|x,y| MATA110(x,y)},aCab,aItem)
		//MSExecAuto( {|v,x,y,z| MATA110(v, x, y, z)}, aCab, aItem, 3, .F. )
		_cTIPOP :=POSICIONE('SB1',1,xFILIAL('SB1')+_cPRODUTO,'B1_TIPO')
		RecLock("SC1",.T.)
		C1_FILIAL    :=xFILIAL('SC1')
		C1_NUM       :=cNumero
		C1_ITEM      :=cItem
		C1_PRODUTO   :=_cPRODUTO
		C1_UM        :=SB1->B1_UM
		C1_QUANT     :=_nQTDSC
		//C1_SEGUM   :=
		//C1_QTSEGUM :=
		C1_DATPRF    :=_dDATASC
		C1_LOCAL     :=SB1->B1_LOCPAD
		C1_OBS       :='MRP MG'
		//C1_OP      :=
		C1_CC        :='411101'
		C1_CONTA     :=SB1->B1_CONTA
		C1_EMISSAO   :=DATE()
		//C1_QUJE2   :=
		//C1_ITEMCTA :=
		C1_DESCRI    :=SB1->B1_DESC
		//C1_FORNECE :=
		//C1_LOJA    :=
		//C1_PEDIDO  :=
		//C1_ITEMPED :=
		C1_SOLICIT   :=Substr(cUsuario,7,nTamUser)
		//C1_IDENT   :=
		//C1_OF      :=
		C1_QUJE      :=  0
		//C1_TX      :=
		//C1_OK      :=
		C1_IMPORT    :=SB1->B1_IMPORT
		IF ALLTRIM(SB1->B1_IMPORT)=='S'
			C1_COTACAO:='IMPORT'
			C1_COMPRAC:='2'
			C1_TIPO   :=1
			C1_CODCOMP:='021' // IMPORTADO  021 TATIANE VIEIRA
		ELSE
			C1_CODCOMP:='001' //            001 Dimas
		ENDIF
		C1_UNIDREQ   :=_cUnidReq
		C1_CLASS     :='1'
		//C1_FABR    :=
		//C1_FABRLOJ :=
		//C1_NUM_SI  :=
		//C1_TPOP    :=
		//C1_GRUPCOM :=
		C1_USER      :=RETCODUSR()
		//C1_ORIGEM  :=
		//C1_OS      :=
		//C1_CN      :=
		//C1_CLVL    :=
		//C1_PROJETO :=
		C1_FILENT    :=xFILIAL('SC1')
		//C1_SEQMRP  :=
		//C1_VUNIT   :=
		//C1_CONDPAG :=
		//C1_CODORCA :=
		//C1_RESIDUO :=
		C1_QTDORIG   :=_nQTDSC
		//C1_TIPOEMP :=
		//C1_ESPEMP  :=
		C1_APROV     :=" "
		//C1_GERACTR :=
		//C1_QTDREEM :=
		//C1_ITEMGRD :=
		//C1_GRADE   :=
		//C1_NOMAPRO :=
		//C1_FLAGGCT :=
		//C1_PRECO   :=
		//C1_TOTAL   :=
		//C1_TIPO    :=
		//C1_MOEDA   :=
		//C1_SIGLA   :=
		//C1_FABRICA :=
		//C1_LOJFABR :=
		//C1_PROGRAM :=
		//C1_TPSC    :=
		//C1_MODAL   :=
		//C1_TPMOD   :=
		//C1_CODED   :=
		//C1_NUMPR   :=
		//C1_ORCAM   :=
		//C1_ACCNUM  :=
		//C1_ACCPROC :=
		//C1_ACCITEM :=
		//C1_USRCODE :=
		//C1_TPPC    :=
		C1_XXOBS     :='OS GERADO MRP '
		C1_XXIDMRP   :=_cIDMRP
		C1_XXHIMRP   :='MRP '+dtoc(date())
		IF ALLTRIM(_cTIPOP)=='PR'
			C1_XOPER     :='02'  //02 PARA REVENDA
		ELSE
			C1_XOPER     :='01'  // 01 OUTROS
		ENDIF
		SC1->(MSUNLOCK())

		IF ! lMSErroAuto
			While ( GetSX8Len() > nSaveSX8 )
				ConfirmSX8()
			EndDo
			_CIDMRP:=''
			For i := 1 To Len(aDados)
				If aDados[i,1] == .T.
					aDados[i,1] := .F.
					aDados[i,2] := oIn
					aDados[i,6] := cNumero
					cQ1 := " UPDATE ZHC010 SET "
					cQ1 += " ZHC_STATUS='X' ,ZHC_NUMSC='"+alltrim(cNumero)+"',ZHC_HISTSC='SC Gerada MRP',ZHC_QTDSC='"+alltrim(STR(_nQTDSC))+"',ZHC_DATASC='"+DTOS(_dDATASC)+"'"
					cQ1 += " WHERE ZHC_FILIAL='"+xFILIAL('ZHC')+"' AND ZHC_IDMRP='"+alltrim(aDados[i,3])+"'"
					TCSQLEXEC(cQ1)    //MLS
					_CIDMRP:=_CIDMRP+alltrim(aDados[i,3])+'|'
				Endif
			Next i
			_CIDMRP:=SUBSTR(_CIDMRP,1,LEN(_CIDMRP)-1)

			FOR I:=1 TO LEN(oGetNEC:ACOLS)
				IF oGetNEC:ACOLS[I][06] $(_CIDMRP)
					oGetNEC:ACOLS[I][08]:=.T.
				ENDIF
			NEXT
			oLbx:Refresh(.F.)
			oGetNEC:oBrowse:Refresh()
			ZHC->(DBSELECTAREA('ZHC'))
			RecLock("ZHC",.T.)
			ZHC_FILIAL := xFILIAL('ZHC')
			ZHC_PERIOD := _dDATASC
			ZHC_NUMMRP := SUBSTR(_CIDMRP,1,6)
			ZHC_PRODUT := _cPRODUTO
			ZHC_DESC   := POSICIONE('SB1',1,xFILIAL('SB1')+_cPRODUTO,'B1_DESC')
			ZHC_TIPOP  := POSICIONE('SB1',1,xFILIAL('SB1')+_cPRODUTO,'B1_TIPO')
			ZHC_GRUPO  := POSICIONE('SB1',1,xFILIAL('SB1')+_cPRODUTO,'B1_GRUPO')
			ZHC_TIPO   := '03-Sol.Compras'
			ZHC_TEXTO  := cNumero+'/'+cITEM+' '
			ZHC_TXDT1  := DTOC(_dDATASC)
			ZHC_TXDT2  := _dDATASC
			ZHC_XQTDE  := _nQTDSC
			ZHC_ENTRAD := _nQTDSC
			ZHC_NUMSC  := cNumero
			ZHC->( msUnlock() )
			MRPRECALC(_cPRODUTO,SUBSTR(_CIDMRP,1,6))
		Else
			Help(" ",1,"MRP")
			While ( GetSX8Len() > nSaveSX8 )
				RollBackSx8()
			EndDo
			//DisarmTransaction()
		EndIF
	ENDIF

	RestArea(cAliasAnt)
Return

	*------------------------------------------------------------------------------------------------------------------
STATIC FUNCTION MRPRECALC(_cPRODUTO,_cNUMMRP)
	*------------------------------------------------------------------------------------------------------------------

	ZHC->(DBSELECTAREA('ZHC'))
	ZHC->(DBSETORDER(3)) //ZHC_FILIAL+ZHC_NUMMRP+ZHC_PRODUT+DTOS(ZHC_PERIOD)+ZHC_TIPO
	ZHC->(DBGOTOP())

	cQ1 := " UPDATE ZHC010 SET "
	cQ1 += " ZHC_TIPO = '11-Necessidade' "
	cQ1 += " WHERE ZHC_FILIAL='"+xFILIAL('ZHC')+"' AND ZHC_TIPO='01-Necessidade' AND ZHC_PRODUT='"+_cPRODUTO+"'"
	TCSQLEXEC(cQ1)    //MLS

	ZHC->(DBSEEK(xFILIAL('ZHC')+_cNUMMRP+_cPRODUTO))

	cPRODUT := ZHC->ZHC_PRODUT
	dPERIOD := ZHC->ZHC_PERIOD

	nSALDO  := 0
	nENTRAD := 0
	nSAIDA  := 0
	nSESTR  := 0
	nSALDOF := 0

	DO WHILE  !ZHC->(Eof()) .AND. cPRODUT==ZHC->ZHC_PRODUT  //.AND.  dPERIOD==CTOD(SUBSTR(ZHC->ZHC_PERIOD,7,2)+'/'+SUBSTR(ZHC->ZHC_PERIOD,5,2)+'/'+SUBSTR(ZHC->ZHC_PERIOD,1,4))

		IF ALLTRIM(cPRODUT)==ALLTRIM(ZHC->ZHC_PRODUT) .AND. dPERIOD<>ZHC->ZHC_PERIOD
			IF SUBSTR(ZHC->ZHC_TIPO,1,2)=='02'
				IF nSALDOF<0
					RecLock("ZHC",.F.)
					ZHC_XQTDE  := 0
					ZHC_SALDOE := 0
					ZHC->( msUnlock() )
				ELSE
					RecLock("ZHC",.F.)
					ZHC_XQTDE  := nSALDOF
					ZHC_SALDOE := nSALDOF
					ZHC->( msUnlock() )
				ENDIF
				cPRODUT := ZHC->ZHC_PRODUT
				dPERIOD := ZHC->ZHC_PERIOD
				nSALDO  := 0
				nENTRAD := 0
				nSAIDA  := 0
				nSESTR  := 0
				nSALDOF := 0
			ENDIF
		ELSE
			IF ALLTRIM(cPRODUT)<>ALLTRIM(ZHC->ZHC_PRODUT)
				cPRODUT := ZHC->ZHC_PRODUT
				dPERIOD := ZHC->ZHC_PERIOD
				nSALDO  := 0
				nENTRAD := 0
				nSAIDA  := 0
				nSESTR  := 0
				nSALDOF := 0
			ENDIF
		ENDIF
		DO CASE
		CASE ZHC->ZHC_SALDOE    > 0
			nSALDO :=nSALDO+ZHC->ZHC_SALDOE
		CASE ZHC->ZHC_ENTRAD    > 0
			nENTRAD:=nENTRAD+ZHC->ZHC_ENTRAD
		CASE ZHC->ZHC_SAIDA     > 0
			nSAIDA :=nSAIDA+ZHC->ZHC_SAIDA
		CASE ZHC->ZHC_SESTR     > 0
			nSESTR :=nSESTR+ZHC->ZHC_SESTR
		CASE SUBSTR(ZHC->ZHC_TIPO,1,2)  == '10'//'10-Saldo Final'
			nSALDOF:=(nSALDO+nENTRAD)-(nSAIDA+nSESTR)
			RecLock("ZHC",.F.)
			ZHC_XQTDE  := nSALDOF
			ZHC_SALDO  := nSALDOF
			ZHC->( msUnlock() )
		CASE  SUBSTR(ZHC->ZHC_TIPO,1,2)  == '11'// '11-Necessidade'
			IF nSALDOF<0
				RecLock("ZHC",.F.)
				ZHC_XQTDE  := nSALDOF*(-1)
				ZHC_NEC    := nSALDOF*(-1)
				ZHC->( msUnlock() )
			ELSE
				RecLock("ZHC",.F.)
				ZHC_XQTDE  := 0
				ZHC_NEC    := 0
				ZHC->( msUnlock() )
			ENDIF
		ENDCASE
		ZHC->(DBSKIP())
	ENDDO

	cQ1 := " UPDATE ZHC010 SET "
	cQ1 += " ZHC_TIPO = '01-Necessidade' "
	cQ1 += " WHERE ZHC_FILIAL='"+xFILIAL('ZHC')+"' AND ZHC_TIPO='11-Necessidade' AND ZHC_PRODUT='"+_cPRODUTO+"'"
	TCSQLEXEC(cQ1)    //MLS

RETURN

	*----------------------------------------------------------------------------*
STATIC FUNCTION MRPZPRV(oGetSAI,cPRODUTO)
	*----------------------------------------------------------------------------*
	Local x:=0
	Local lPREV :=.T.

	FOR x := 1 TO LEN(oGetSAI:ACOLS)
		IF  ALLTRIM(oGetSAI:ACOLS[x][1])=='09-Previsao Venda'
			lPREV :=.T.
		ENDIF
	NEXT
	IF lPREV==.T.
		lPREV :=.F.
		MRPZPRV2(oGetSAI,cPRODUTO)
	ELSE
		MSGALERT('Nao existe (09-Previsao Venda) para esse item '+cPRODUTO)
	ENDIF

RETURN

	*----------------------------------------------------------------------------*
STATIC FUNCTION MRPZPRV2(oGetSAI,cPRODUTO)
	*----------------------------------------------------------------------------*

	Local cTitulo        := "ZHC"
	Local oDLG1Marc
	Local oFnt
	Local aBotoes        := {}
	Local lopc           :=.F.
	local cvirgula       := ""

	Local oOK	         := LoadBitmap( GetResources(), "LBOK" )
	Local oNO	         := LoadBitmap( GetResources(), "LBNO" )

	Private cStatus:=''

	PRIVATE cTITULOE     :='Zerar Previsao de Venda - MRP'

	Private oNor         := LoadBitmap( GetResources(), "PMSEDT1" )
	Private oSC	         := LoadBitmap( GetResources(), "PMSEDT2" )
	Private oIn	         := LoadBitmap( GetResources(), "PMSEDT3" )

	Private lNExistDados := .F.

	Private aDados       := {}
	Private aDados2      := {}
	Private aItens       := {}
	Private lJaMarcou    := .F.
	Private aVetTit      := {}

	Private oDataSC
	Private oQTDSC
	Private oUnidReq

	Private dDATAPRV    :=CTOD(oGetNEC:ACOLS[oGetNEC:nat][02])
	Private nQTDSC      :=0
	Private cUnidReq    :='00013'

	DbSelectArea("SX3")

	MsgRun("Espere... Buscando Dados...",,{ || MRPZPRV3(@aDados) })

	If lNExistDados
		alert("Nao existe dados")
		Return()
	EndIf

	Define FONT oFnt  NAME "Arial" Size 08,10
	Define FONT oFnt2 NAME "Arial" Size 10,16 BOLD

	AAdd(aBotoes,{"Inverte"       ,  {|| MarcInv2() }, "Inverte"      ,"Inverte"    })//
	AAdd(aBotoes,{"Marca todos"   ,  {|| MarcAll2() }, "Marc Todos"   ,"Marc Todos" })//

	oTesta := oSC
	cTitulo:= "MRP Zerar Previsao de Venda (Item)"

	IF EMPTY(cPRODUTO)
		MSGALERT('Produto em branco')
		RETURN
	ENDIF

	If SB1->(dbSeek(xFilial("SB1")+cPRODUTO))
		IF ALLTRIM(SB1->B1_LIBCOMP)=='2'
			MSGALERT('Produto Bloqueado para Compra (LIBCOMP=2)')
			RETURN
		ENDIF
		IF ALLTRIM(SB1->B1_MSBLQL)=='1'
			MSGALERT('Produto com Bloqueio de cadastro (MSBLQL=1)')
			RETURN
		ENDIF
		IF ALLTRIM(SB1->B1_STATUS)=='2'
			MSGALERT('Produto desativado (STATUS=2)')
			RETURN
		ENDIF
		IF ALLTRIM(SB1->B1_STATUS)=='3'
			MSGALERT('Produto obsoleto (STATUS=3)')
			RETURN
		ENDIF
	ENDIF

	Define MsDialog oDLG1Marc Title cTitulo Of oMainWnd Pixel From 0,0 To 420,650//550,950

	@ 32,01 To 74,325 Of oDLG1Marc Pixel
	@ 39,  5  Say   ALLTRIM(Str(Len(aDados))) + " Itens " Size  200,09 Of oDLG1Marc Pixel Font oFnt2 Color CLR_BLUE,CLR_WHITE
	@ 56,  5  Say   alltrim(cPRODUTO) + " -  " +cDESCRI   Size  200,09 Of oDLG1Marc Pixel Font oFnt2 Color CLR_BLUE,CLR_WHITE

	@ 39,150 BitMap oBmp ResName "PMSEDT3"   	Size  9,09 Of oDLG1Marc Pixel NoBorder
	@ 39,160 Say "Liberado" 			 	Size 60,09 Of oDLG1Marc Pixel

	@ 39,240 BitMap oBmp ResName "PMSEDT1"  	    Size  9,09 Of oDLG1Marc Pixel NoBorder
	@ 39,250 Say "Nao Liberado" 			       Size 100,09 Of oDLG1Marc Pixel

	@ 79,01 ListBox oLbx Fields ;
		Colsizes 0,0,10,15,07,15,15,20,40,50,50,15,15,15 Size 325,090 Of oDLG1Marc Pixel On DBlClick ( aDados[oLbx:nAt,1] := !aDados[oLbx:nAt,1] , /*scresumo()*/,oLbx:Refresh(.F.) )

	oLbx:aHeaders := {  " "   ,;   //01
	" "                       ,;   //02
	"Quantidade"              ,;   //03
	"Previsao  "   }               //04

	oLbx:SetArray(aDados)
	oLbx:bLine  := { || {If(aDados[oLbx:nAt,1],oOK,oNO) ,;
		aDados[oLbx:nAt,2],;
		aDados[oLbx:nAt,3],;
		aDados[oLbx:nAt,4] }}

	oLbx:SetFocus()

	@ 174,010 SAY OemToAnsi("Data " )                OF oDLG1Marc PIXEL SIZE 250,010 FONT oFontBRW3 Color CLR_BLUE,CLR_WHITE
	@ 174,045 MSGET oDataSC  VAR dDATAPRV   WHEN(.F.)   OF oDLG1Marc SIZE 055,005  PIXEL COLOR CLR_HBLUE FONT oFontBRW3

	@ 174,110 SAY OemToAnsi("Qtde " )              OF oDLG1Marc PIXEL SIZE 250,010 FONT oFontBRW3 Color CLR_BLUE,CLR_WHITE
	@ 174,145 MSGET oQTDPRV  VAR nQTDPRV     WHEN(.F.)   OF oDLG1Marc SIZE 070,005 PICTURE ("@E 9,999,999,999.99") PIXEL COLOR CLR_HBLUE FONT oFontBRW3

	@ 192,030 Say "Inverte Selecao" 			       Size 050,09 Of oDLG1Marc Pixel
	@ 192,140 Say "Marcar Todos   " 			       Size 050,09 Of oDLG1Marc Pixel
	@ 192,250 Say "Zerar Previsao " 			       Size 050,09 Of oDLG1Marc Pixel

	@ 192,010  BITMAP oBmp ResName "SELECT"        Of oDLG1Marc Size 090,20 ON CLICK (MarcInv2())   NoBorder  Pixel
	@ 192,120  BITMAP oBmp ResName "SELECTALL"     Of oDLG1Marc Size 090,20 ON CLICK (MarcAll2())   NoBorder  Pixel
	@ 192,230  BITMAP oBmp ResName "NOMEDICA"      Of oDLG1Marc Size 090,20 ON CLICK (MRPZPRV5())   NoBorder  Pixel

	Activate MsDialog oDLG1Marc Center On Init EnchoiceBar(oDLG1Marc,{|| oDLG1Marc:End() },{|| oDLG1Marc:End() },,aBotoes)
	oGetNEC:oBrowse:Refresh()

return()

	*-------------------------------------------------------------------------------------------------------------
Static Function MRPZPRV3(oGetSAI)
	*-------------------------------------------------------------------------------------------------------------
	LOCAL nLIN    :=oGetNEC:nat
	Local cPedido := "000000"
	local nCount  := 1
	local nCount2 := 1
	Local cQuery  := ''
	Local oTMP

	cQuery := " Select * From " + RetSqlName("ZHC") + " (NOLOCK) ZHC "
	cQuery += " Where ZHC_FILIAL = '"+xFILIAL('ZHC')+"'  AND ZHC.D_E_L_E_T_=''  "
	cQuery += " AND ZHC_PRODUT   =  '"+cPRODUTO+"' "
	cQuery += " AND ZHC_TIPO     = '09-Previsao Venda' "
	cQuery += " Order BY ZHC_IDMRP  "

	cQuery := ChangeQuery( cQuery )

	TCQUERY cQuery NEW ALIAS "TMP"

	DbSelectArea("TMP")
	TMP->(DbGotop())

	If TMP->(EOF())
		lNExistDados := .T.
		DbSelectArea("TMP")
		DbCloseArea()
		Return()
	EndIf

	DbSelectArea("TMP")
	TMP->(DbGotop())

	nQTDPRV  := 0
	DO While !TMP->(EOF())
		oTMP:=oIn
		AADD(aDados, {.T., ;
			oTMP ,;
			TMP->ZHC_SAIDA,;
			TMP->ZHC_TXDT1+' '+TMP->ZHC_TEXTO,;
			TMP->ZHC_SC4REC,;
			TMP->R_E_C_N_O_})
		nQTDPRV:=nQTDPRV+TMP->ZHC_SAIDA
		TMP->(DbSkip())
		nCount ++
	EndDo

	DbSelectArea("TMP")
	TMP->(DbCloseArea())

Return()

	*-------------------------------------------------------------------------------------------------------------
Static Function MarcInv2() //Inverte
	*-------------------------------------------------------------------------------------------------------------
	Local i := 1

	For i := 1 To Len(aDados)
		If aDados[i,1] == .T.
			aDados[i,1] := .F.
		Else
			IF aDados[i,2] == oIn
				aDados[i,1] := .T.
			ENDIF
		EndIF
	Next i

	oLbx:Refresh(.F.)
Return()

	*-------------------------------------------------------------------------------------------------------------
Static Function MarcAll2() //Marca todos
	*-------------------------------------------------------------------------------------------------------------
	Local i := 1

	For i := 1 To Len(aDados)
		If aDados[i,2] == oIn //oNor    aDados[i,2] == oIn
			aDados[i,1] := .T.
		Else
			aDados[i,1] := .F.
		EndIf
	Next i

	oLbx:Refresh
Return()

	*-------------------------------------------------------------------------------------------------------------
Static Function MRPZPRV5() // PROCESSAMENTO ZERAR PREVISAO DE VENDAS
	*-------------------------------------------------------------------------------------------------------------
	Local i:=0

	IF MSGYESNO('Zerar previsao dos itens marcado ?')
		For i := 1 To Len(aDados)
 
			If aDados[i,1] == .T.    .AND.   aDados[i,2] == oIn
				aDados[i,1] := .F.
				aDados[i,2] := oNor
				aDados[i,3] := 0
				nZHCREC :=aDados[i,6]
				nC4REC  :=aDados[i,5]
				cQZ1 := " UPDATE ZHC010 SET ZHC_SAIDA=0 , ZHC_XQTDE=0 WHERE  ZHC_FILIAL='"+xFILIAL('ZHC')+"' AND R_E_C_N_O_="+ALLTRIM(STR(nZHCREC))+"  "
				cQZ2 := " UPDATE SC4010 SET C4_QUANT =0               WHERE   C4_FILIAL='"+xFILIAL('SC4')+"' AND R_E_C_N_O_="+ALLTRIM(STR(nC4REC))+"  "
				TCSQLEXEC(cQZ1)
				TCSQLEXEC(cQZ2)
			Endif
		Next i
	ENDIF
	oLbx:Refresh

Return

