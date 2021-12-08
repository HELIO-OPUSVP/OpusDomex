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

#include "TbiConn.ch"
#include "TbiCode.ch"


*----------------------------------------------------------------------------*
USER FUNCTION MRPSIMUL() //GERACAO DE SC  MRP SIMULACAO Filial 02 
	*----------------------------------------------------------------------------*
	IF xFilial("SB2")=='01'
		U_MRP002B()  // FILIAL 01
	ENDIF

	IF xFilial("SB2")=='02'
		U_MRP002D()  // FILIAL 02
	ENDIF

	*----------------------------------------------------------------------------*
USER FUNCTION MRP002D() //GERA��O DE SC simu�lacao FILIAL 02
	*----------------------------------------------------------------------------*

	Local aSizeAut    := MsAdvSize(,.F.,400)
	Local aObjects	   := {}
	//local aDialogs    := {"Necessidade"}
	//local aDialogs2   := {"Entrada"}
	//local aDialogs3   := {"Saida"}

	//Local aTitles     := {OemToAnsi("Necessidade")}
	//Local aTitles2    := {OemToAnsi("Entrada")}
	//Local aTitles3    := {OemToAnsi("Saida")}

	//Local aFldCBAtu   := Array(Len(aTitles))
	//Local aPages	   := {"HEADER"}
	LOCAL aButtons    :={}
	//Local dUlFat      := DATE()

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
	Private cALTER   :=SPACE(40)

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

	Private oAlter // alternativo

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

	private cMSG11   :=''
	private cMSG11B  :=''
	private cMSG11C  :=''

	private oMSG11
	private oMSG11B
	private oMSG11C

	private	oMSG21
	private oMSG21b

	private cMSG21   :=''
	private cMSG21B  :=''

	private cMSG31  :=''
	private cMSG31B :=''
	private oMSG31
	private oMSG31B

	private cMSG12   :=''
	private cMSG12B  :=''
	private cMSG12C  :=''

	private oMSG12
	private oMSG12B
	private oMSG12C

	private	oMSG22
	private oMSG22b

	private cMSG22   :=''
	private cMSG22B  :=''

	private cMSG32  :=''
	private cMSG32B :=''
	private oMSG32
	private oMSG32B

	//-------------------------
	private cMSG13   :=''
	private cMSG13B  :=''
	private cMSG13C  :=''

	private oMSG13
	private oMSG13B
	private oMSG13C

	private	oMSG23
	private oMSG23b

	private cMSG23   :=''
	private cMSG23B  :=''

	private cMSG33  :=''
	private cMSG33B :=''
	private oMSG33
	private oMSG33B

	//-------------------------




	Private cEOL    := "CHR(13)+CHR(10)"
	Private nQTDITEM :=0
	Private oQTDITEM

	Private oFUCOM
	Private cFUCOM :=SPACE(06)
	Private nQTDPRV:=0

	Private lprocmrp:=.F.

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

	aAdd( aButtons, {"NOTE" , {||  MsAguarde({||U_MRP004SC()  ,'Aguarde','(F2)Gerar Solicitacao de Compras'  })  },"(F2)Gerar Solicitacao de Compras"}) //
	aAdd( aButtons, {"NOTE" , {||  MsAguarde({||MATA110()     ,'Aguarde','Solicitacao de Compras SC'         })  },'Solicitacao de Compras SC'}) //
	aAdd( aButtons, {"NOTE" , {||  MsAguarde({||MATA121()     ,'Aguarde','Pedido de Compras PC'              })  },'Pedido de Compras PC'}) //
	aAdd( aButtons, {"NOTE" , {||  MsAguarde({||U_MRPSCPC()   ,'Aguarde','(F8)Saldo SCs e PCs'               })  },'(F8)Saldo SCs e PCs'}) //
	aAdd( aButtons, {"NOTE" , {||  MsAguarde({||U_DCADSC4()    ,'Processar','Previsao de Venda(Simulacao) '   })  },'Previsao de Venda(Simulacao)'}) //
	//aAdd( aButtons, {"NOTE" , {||  MsAguarde({||Xjob712()     ,'Processar','Processamento MRP (Simulacao) '  })  },'Processamento MRP (Simulacao)'}) //
	aAdd( aButtons, {"NOTE" , {||  MsAguarde({||Xjob713D()     ,'Processar','Processamento MRP (NOVO) '     })  },'Processamento MRP (NOVO) '}) //
	aAdd( aButtons, {"NOTE" , {||  MsAguarde({||U_MRPALT0D(oGetSAI,cPRODUTO) ,'Aguarde','(F10)Alternativo'                  })  },'(F10)Alternativo'  }) //

	SetKey( VK_F2 , { || U_MRP004SC() } )
	SetKey( VK_F4 , { || U_MRP004EN() } )
	SetKey( VK_F6 , { || U_MRP004SA() } )
	SetKey( VK_F7 , { || U_MRPCHK01(oGetNEC)  } )
	SetKey( VK_F8 , { || U_MRPSCPC()  } )
	SetKey( VK_F9 , { || MRPZPRV(oGetSAI,cPRODUTO)     } )
	SetKey( VK_F10 , { || U_MRPALT0D(oGetSAI,cPRODUTO)  } )

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

	DEFINE MSDIALOG oDlg FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5]  TITLE OemToAnsi("CENTRAL MRP DOMEX Filial 02 (Simulacao) v2.0") OF oMainWnd PIXEL
	oDlg:oFont:=oFontBRW3
//��������������������������������������������������������������Ŀ
//�Define o cabecalho da rotina                                  �
//����������������������������������������������������������������
	nMeio:=INT( ((oMainWnd:nBottom-60) -(oMainWnd:nTop+125) ) / 4 )-10
	@ 32,aPosGet[1,1] TO 65,aPosGet[1,1]+(aPosGet[1,1]*100) LABEL ""               OF oDlg PIXEL
	nLin:=37
	@ nLin,aPosGet[1,1]+(aPosGet[1,1]*01) SAY OemToAnsi("Produto")                                OF oDlg PIXEL SIZE 040,010 FONT oFontBRW3
	@ nLin,aPosGet[1,1]+(aPosGet[1,1]*06) MSGET oProduto VAR cProduto  WHEN(.T.)   F3('ZHD001')   OF oDlg PIXEL SIZE 070,005 FONT oFontBRW3 Valid MRPVAL1('P')
	@ nLin,aPosGet[1,1]+(aPosGet[1,1]*17) MSGET oDESCRI  VAR cDESCRI   WHEN(.F.)                  OF oDlg PIXEL SIZE 180,005 FONT oFontBRW3 //180   070

	@ nLin,aPosGet[1,1]+(aPosGet[1,1]*46) SAY OemToAnsi("Id MRP")                                 OF oDlg PIXEL SIZE 040,010 FONT oFontBRW3
	@ nLin,aPosGet[1,1]+(aPosGet[1,1]*51) MSGET oIDMRP   VAR cIdMRP    WHEN(.T.)   F3('ZHD002')   OF oDlg PIXEL SIZE 060,005 FONT oFontBRW3 Valid MRPVAL1('I')

	@ nLin,aPosGet[1,1]+(aPosGet[1,1]*62) SAY OemToAnsi("Filtro")                                 OF oDlg PIXEL SIZE 040,010 FONT oFontBRW3
	@ nLin,aPosGet[1,1]+(aPosGet[1,1]*66) combobox oFiltro var cFiltro items aFiltro              OF oDlg PIXEL SIZE 070,005 FONT oFontBRW3 Valid MRPVAL1('F')

	@ nLin,aPosGet[1,1]+(aPosGet[1,1]*80) SAY OemToAnsi("Empenho")                                OF oDlg PIXEL SIZE 040,010 FONT oFontBRW3
	@ nLin,aPosGet[1,1]+(aPosGet[1,1]*86) combobox oFilEMP var cFilEmp items aFilEMP              OF oDlg PIXEL SIZE 070,005 FONT oFontBRW3 Valid MRPVAL1('F')

	nLin:=51

	@ nLin,aPosGet[1,1]+(aPosGet[1,1]*01) SAY OemToAnsi("Data")                                   OF oDlg PIXEL SIZE 040,010 FONT oFontBRW3
	@ nLin,aPosGet[1,1]+(aPosGet[1,1]*06) MSGET oData    VAR dData     WHEN(.T.)                  OF oDlg PIXEL SIZE 070,005 FONT oFontBRW3
	// ALTERNATIVO
	@ nLin,aPosGet[1,1]+(aPosGet[1,1]*17) SAY oAlter  VAR cAlter  OF oDlg PIXEL SIZE 180,010 FONT oFontBRW3 COLOR CLR_RED //180   070

	@ nLin,aPosGet[1,1]+(aPosGet[1,1]*46) SAY OemToAnsi("GrpMRP")                                 OF oDlg PIXEL SIZE 040,010 FONT oFontBRW3
	@ nLin,aPosGet[1,1]+(aPosGet[1,1]*51) combobox oFilMRP var cFilMRP items aFilMRP              OF oDlg PIXEL SIZE 060,005 FONT oFontBRW3 Valid MRPVAL1('F')

	@ nLin,aPosGet[1,1]+(aPosGet[1,1]*62) SAY OemToAnsi("Fornec")                                 OF oDlg PIXEL SIZE 040,010 FONT oFontBRW3
	@ nLin,aPosGet[1,1]+(aPosGet[1,1]*66) MSGET oFUCOM   VAR cFUCOM    WHEN(.T.)   F3('SA2')      OF oDlg PIXEL SIZE 070,005 FONT oFontBRW3 Valid MRPVAL1('F')

	@ nLin,aPosGet[1,1]+(aPosGet[1,1]*80) SAY OemToAnsi("Previsao")                               OF oDlg PIXEL SIZE 040,010 FONT oFontBRW3
	@ nLin,aPosGet[1,1]+(aPosGet[1,1]*86) combobox oFilPRV var cFilPRV items aFilPRV              OF oDlg PIXEL SIZE 070,005 FONT oFontBRW3 Valid MRPVAL1('F')

	*----------------------------------------------------------------------------------------------------------------

	oGetNEC   := (MsNewGetDados():New( 074,003,250,200,/*GD_UPDATE*/ ,/*"U_FAT002LOK()"*/  ,/*REQ_OPSD3()*/,/*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*Ffieldok*/,/*superdel*/,/*delok*/,oDlg,aHeadNec,aColsNec))
	oGetNEC:oBrowse:Refresh()
	oGetNEC:oBrowse:bChange:={||U_MRPCHG04(oGetNEC,oGetSAI,oGetENT)}

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

	@ 257,195 BITMAP ResName "EMPILHADEIRA" OF oDlg Size 15,15 ON CLICK (U_MRP002SC(oGetNEC))   NoBorder  Pixel
	@ 277,198 BITMAP ResName "SELECT"       OF oDlg Size 45,45 ON CLICK (U_MRPCHK01(oGetNEC))  NoBorder  Pixel

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
USER FUNCTION MRP004EN()
	*----------------------------------------------------------------------------*
	MSGALERT('TELA CONSULTA ENTRADA - EM DESENVOLVIMENTO')
RETURN

	*----------------------------------------------------------------------------*
USER FUNCTION MRP004SA()
	*----------------------------------------------------------------------------*
	MSGALERT('TELA CONSULTA SAIDA - EM DESENVOLVIMENTO')
RETURN

	*----------------------------------------------------------------------------*
STATIC FUNCTION MRPVAL1(cTIPO)
	*----------------------------------------------------------------------------*
	if lprocmrp==.t.
		lprocmrp:=.f.
		MSGALERT('Fim Processamento  - MRP Simulacao - Filial 02 ')
		oDlg:End()
		//U_MRP002B()
	else
		MsAguarde( { || MRPVAL1B(cTIPO) } ,"Filtro", "Filtro MRP - Aguarde..." )
	endif

RETURN

	*----------------------------------------------------------------------------*
STATIC FUNCTION MRPVAL1B(cTIPO)
	*----------------------------------------------------------------------------*

	lFirst   :=.F.
	nQTDITEM :=0

	IF cTIPO=='I' .AND. !EMPTY(cIDMRP) // IDMRP
		aColsNEC  := {}

		cQueryID := " 	SELECT  B1_XFILMRP, "
		cQueryID += " 	ZHD_PERIOD, ZHD_NUMMRP, ZHD_NIVEL, ZHD_PRODUT,ZHD_PRODSH,ZHD_OPC,ZHD_REVISA,ZHD_REVSHW,ZHD_TIPO,ZHD_TEXTO,ZHD_SALDOE, "
		cQueryID += " 	ZHD_ENTRAD, ZHD_SAIDA , ZHD_SESTR, ZHD_SALDO ,ZHD_NEC,ZHD_DESC ,ZHD_TIPOP,ZHD_GRUPO,ZHD_XQTDE,ZHD_TXDT1,ZHD_TXDT2, "
		cQueryID += " 	ZHD_LTIME,ZHD_IDMRP,ZHD_NUMSC,ZHD_HISTSC, ZHD_QTDSC, ZHD_DATASC,ZHD_STATUS,SUBSTRING(ZHD_FORN+' '+ZHD_LOJA+' '+ZHD_NFORN,1,30)  AS ZHD_NFORN,ZHD_UPRC "
		cQueryID += " 	FROM ZHD010 (NOLOCK)  ,SB1010 (NOLOCK) "
		cQueryID += " 	WHERE B1_COD=ZHD_PRODUT AND B1_FILIAL = '"+xFILIAL('SB1')+"' AND ZHD_FILIAL = '"+XFILIAL('ZHD')+"  '"
		cQueryID += " 	AND ZHD_IDMRP='"+cIDMRP+"' AND  SUBSTRING(ZHD_TIPO,1,2)='01' and ZHD_XQTDE>0  "
		IF !EMPTY(cFUCOM)
			cQueryID += " 	AND ZHD_FORN='"+cFUCOM+"'  "
		ENDIF
		cQueryID += " 	AND SB1010.D_E_L_E_T_='' "
		IF SUBSTR(cFILMRP,1,1)=='1'
			cQueryID += " 	AND B1_XFILMRP='1' "
		ENDIF

		IF SUBSTR(cFILPRV,1,1)=='2' // QUERY RETIRAR PRODUTOS COM PREVISAO DE VENDA
			cQueryID += " AND ZHD_PRODUT NOT IN ( "
			cQueryID += " SELECT ZHD_PRODUT  "
			cQueryID += " FROM ZHD010 ZHD (NOLOCK) "
			cQueryID += " WHERE ZHD.ZHD_TIPO IN ('09-Previsao Venda')  "
			cQueryID += " AND ZHD.D_E_L_E_T_='' "
			cQueryID += " AND ZHD.ZHD_FILIAL='"+xFILIAL('ZHD')+"' "
			cQueryID += " AND ZHD.ZHD_SAIDA>0 ) "
		ENDIF

		IF SUBSTR(cFILEMP,1,1)=='2'//com empenho
			cQueryID += " AND ZHD_PRODUT IN( SELECT D4_COD FROM SD4010 (NOLOCK) "
			cQueryID += " WHERE D4_FILIAL='"+xFILIAL('SD4')+"' AND D4_QUANT>0 AND SD4010.D_E_L_E_T_='' "
			cQueryID += " GROUP BY D4_COD ) "
		ENDIF

		IF SUBSTR(cFILEMP,1,1)=='3'//sem empenho
			cQueryID += " AND ZHD_PRODUT NOT IN( SELECT D4_COD FROM SD4010 (NOLOCK) "
			cQueryID += " WHERE D4_FILIAL='"+xFILIAL('SD4')+"' AND D4_QUANT>0 AND SD4010.D_E_L_E_T_='' "
			cQueryID += " GROUP BY D4_COD ) "
		ENDIF

		cQueryID += " 	ORDER BY  ZHD_PRODUT,ZHD_TXDT2 "

		TCQUERY cQueryID NEW ALIAS "TR1"
		TR1->( dbGoTop() )
		DO WHILE .NOT. TR1->(EOF())
			//--------------------------------- filtro
			_nNEC2 :=0
			IF SUBSTR(cFILTRO,1,1)<>'1'
				cQUERYSLD:="	SELECT ZHD_PRODUT , "
				cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QATU),0) FROM SB2010 (NOLOCK) WHERE B2_COD=ZHD_PRODUT  AND D_E_L_E_T_='' AND B2_FILIAL='"+xFILIAL('SB2')+"' ) AS  EST, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C1_QUANT-C1_QUJE),0)  FROM SC1010 (NOLOCK) WHERE C1_FILIAL='"+xFILIAL('SC1')+"' AND C1_PRODUTO=ZHD.ZHD_PRODUT AND D_E_L_E_T_='' AND C1_RESIDUO='' AND  C1_QUANT > C1_QUJE) AS  SOL, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C7_QUANT-C7_QUJE),0)  FROM SC7010 (NOLOCK) WHERE C7_FILIAL='"+xFILIAL('SC7')+"' AND C7_PRODUTO=ZHD.ZHD_PRODUT AND D_E_L_E_T_='' AND C7_RESIDUO='' AND  C7_QUANT > C7_QUJE) AS  PC, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QEMP),0) FROM SB2010 (NOLOCK)  WHERE B2_FILIAL='"+xFILIAL('SB2')+"' AND B2_COD=ZHD_PRODUT  AND D_E_L_E_T_='' ) AS  EMP, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(ZHD_XQTDE),0)  FROM ZHD010 (NOLOCK) WHERE ZHD_FILIAL='"+xFILIAL('ZHD')+"' AND  ZHD_TIPO IN ('06-Ordem Producao') AND ZHD_PRODUT=ZHD.ZHD_PRODUT) AS  OP, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C6_QTDVEN-C6_QTDENT),0)  FROM SC6010 (NOLOCK) WHERE C6_FILIAL='"+xFILIAL('SC6')+"' AND  (C6_QTDVEN-C6_QTDENT)>0 AND D_E_L_E_T_='' AND C6_PRODUTO=ZHD.ZHD_PRODUT AND C6_BLQ<>'R')  AS  PV, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(ZHD_XQTDE),0)  FROM ZHD010 (NOLOCK) WHERE ZHD_FILIAL='"+xFILIAL('ZHD')+"' AND ZHD_TIPO IN ('09-Previsao Venda')  AND ZHD_PRODUT=ZHD.ZHD_PRODUT) AS  PREV, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(ZHD_XQTDE),0)  FROM ZHD010 (NOLOCK) WHERE ZHD_FILIAL='"+xFILIAL('ZHD')+"' AND ZHD_TIPO IN ('08-Saida Estrutura') AND ZHD_PRODUT=ZHD.ZHD_PRODUT) AS  SAES, "

				cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QATU),0) FROM SB2010 (NOLOCK) WHERE B2_FILIAL='"+xFILIAL('SB2')+"' AND B2_COD=ZHD_PRODUT  AND D_E_L_E_T_='') + "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C1_QUANT-C1_QUJE),0)  FROM SC1010 (NOLOCK) WHERE C1_FILIAL='"+xFILIAL('SC1')+"' AND  C1_PRODUTO=ZHD.ZHD_PRODUT AND D_E_L_E_T_='' AND C1_RESIDUO='' AND C1_QUANT > C1_QUJE) + "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C7_QUANT-C7_QUJE),0)  FROM SC7010 (NOLOCK) WHERE C7_FILIAL='"+xFILIAL('SC7')+"' AND  C7_PRODUTO=ZHD.ZHD_PRODUT AND D_E_L_E_T_='' AND C7_RESIDUO='' AND C7_QUANT > C7_QUJE ) - "
				cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QEMP),0) FROM SB2010 (NOLOCK)  WHERE B2_FILIAL='"+xFILIAL('SB2')+"' AND  B2_COD=ZHD_PRODUT  AND D_E_L_E_T_='' ) + "
				cQUERYSLD+="	(SELECT ISNULL(SUM(ZHD_XQTDE),0)  FROM ZHD010 (NOLOCK) WHERE ZHD_FILIAL='"+xFILIAL('ZHD')+"' AND  ZHD_TIPO IN ('06-Ordem Producao') AND ZHD_PRODUT=ZHD.ZHD_PRODUT) - "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C6_QTDVEN-C6_QTDENT),0)  FROM SC6010 (NOLOCK) WHERE C6_FILIAL='"+xFILIAL('SC6')+"' AND  (C6_QTDVEN-C6_QTDENT)>0 AND D_E_L_E_T_='' AND C6_PRODUTO=ZHD.ZHD_PRODUT  AND C6_BLQ<>'R') - "
				cQUERYSLD+="	(SELECT ISNULL(SUM(ZHD_XQTDE),0)  FROM ZHD010 (NOLOCK) WHERE ZHD_FILIAL='"+xFILIAL('ZHD')+"' AND  ZHD_TIPO IN ('09-Previsao Venda')  AND ZHD_PRODUT=ZHD.ZHD_PRODUT) AS FINAL "// -       "

				cQUERYSLD+="	FROM ZHD010 (NOLOCK) ZHD "
				cQUERYSLD+="	WHERE ZHD_PRODUT='"+ALLTRIM(TR1->ZHD_PRODUT)+"'  AND ZHD_FILIAL = '"+xFILIAL('ZHD')+"' AND D_E_L_E_T_='' "
				cQUERYSLD+="	GROUP BY ZHD_PRODUT "
				cQUERYSLD+="	ORDER BY ZHD_PRODUT "

				TCQUERY cQUERYSLD NEW ALIAS "TRS"
				TRS->( dbGoTop() )
				_nNEC2 :=TRS->FINAL
				TRS->(DBCLOSEAREA())
				cALTER:=POSICIONE('SB1',1,xFILIAL('SB1')+ALLTRIM(TR1->ZHD_PRODUT),'B1_ALTER')
				IF !EMPTY(cALTER)
					cALTER :='Alternativo: '+ AllTrim(cALTER)
				ENDIF
			ENDIF
			//---------------------------------

			lSTATUS :=.F.
			IF TR1->ZHD_STATUS=='X' .OR. TR1->ZHD_STATUS=='S'  //SC CHECK
				lSTATUS :=.T.
			ENDIF
			IF TR1->ZHD_XQTDE >0
				IF (SUBSTR(cFILTRO,1,1)=='1') .OR. (SUBSTR(cFILTRO,1,1)=='2' .and. _nNEC2 <0) .OR. (SUBSTR(cFILTRO,1,1)=='3' .and. _nNEC2 >=0)
					AADD(aColsNEC,{TR1->ZHD_PRODUT,;
						TR1->ZHD_TXDT1,;
						TR1->ZHD_XQTDE,;
						TR1->ZHD_XQTDE*TR1->ZHD_UPRC,;
						TR1->ZHD_NFORN,;
						TR1->ZHD_IDMRP,;
						TR1->ZHD_STATUS,;
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
		cQueryID += " 	ZHD_PERIOD, ZHD_NUMMRP, ZHD_NIVEL, ZHD_PRODUT,ZHD_PRODSH,ZHD_OPC,ZHD_REVISA,ZHD_REVSHW,ZHD_TIPO,ZHD_TEXTO,ZHD_SALDOE, "
		cQueryID += " 	ZHD_ENTRAD, ZHD_SAIDA , ZHD_SESTR, ZHD_SALDO ,ZHD_NEC,ZHD_DESC ,ZHD_TIPOP,ZHD_GRUPO,ZHD_XQTDE,ZHD_TXDT1,ZHD_TXDT2, "
		cQueryID += " 	ZHD_LTIME,ZHD_IDMRP,ZHD_NUMSC,ZHD_HISTSC, ZHD_QTDSC, ZHD_DATASC,ZHD_STATUS,SUBSTRING(ZHD_FORN+' '+ZHD_LOJA+' '+ZHD_NFORN,1,30)  AS ZHD_NFORN,ZHD_UPRC "
		cQueryID += " 	FROM ZHD010 (NOLOCK)  ,SB1010 (NOLOCK) "
		cQueryID += " 	WHERE B1_COD=ZHD_PRODUT AND B1_FILIAL = '"+xFILIAL('SB1')+"' AND ZHD_FILIAL = ' "+xFILIAL('ZHD')+"' "
		cQueryID += " 	AND  ZHD_PRODUT='"+cPRODUTO+"' AND SUBSTRING(ZHD_TIPO,1,2)='01' "
		IF !EMPTY(cFUCOM)
			cQueryID += " 	AND ZHD_FORN='"+cFUCOM+"'  "
		ENDIF
		cQueryID += " 	AND SB1010.D_E_L_E_T_='' "
		IF SUBSTR(cFILMRP,1,1)=='1'
			cQueryID += " 	AND B1_XFILMRP='1' "
		ENDIF

		IF SUBSTR(cFILEMP,1,1)=='2'//com empenho
			cQueryID += " AND ZHD_PRODUT IN( SELECT D4_COD FROM SD4010 (NOLOCK) "
			cQueryID += " WHERE D4_FILIAL='"+xFILIAL('SD4')+"' AND D4_QUANT>0 AND SD4010.D_E_L_E_T_='' "
			cQueryID += " GROUP BY D4_COD ) "
		ENDIF

		IF SUBSTR(cFILEMP,1,1)=='3'//sem empenho
			cQueryID += " AND ZHD_PRODUT NOT IN( SELECT D4_COD FROM SD4010 (NOLOCK) "
			cQueryID += " WHERE D4_FILIAL='"+xFILIAL('SD4')+"' AND D4_QUANT>0 AND SD4010.D_E_L_E_T_='' "
			cQueryID += " GROUP BY D4_COD ) "
		ENDIF

		IF SUBSTR(cFILPRV,1,1)=='2' // QUERY RETIRAR PRODUTOS COM PREVISAO DE VENDA
			cQueryID += " AND ZHD_PRODUT NOT IN ( "
			cQueryID += " SELECT ZHD_PRODUT  "
			cQueryID += " FROM ZHD010 ZHD (NOLOCK) "
			cQueryID += " WHERE ZHD.ZHD_TIPO IN ('09-Previsao Venda')  "
			cQueryID += " AND ZHD.D_E_L_E_T_='' "
			cQueryID += " AND ZHD.ZHD_FILIAL='"+xFILIAL('ZHD')+"' "
			cQueryID += " AND ZHD.ZHD_SAIDA>0 ) "
		ENDIF

		cQueryID += " 	ORDER BY  ZHD_PRODUT,ZHD_TXDT2 "

		TCQUERY cQueryID NEW ALIAS "TR1"
		TR1->( dbGoTop() )
		DO WHILE .NOT. TR1->(EOF())
			//--------------------------------- filtro
			_nNEC2 :=0
			IF SUBSTR(cFILTRO,1,1)<>'1'
				cQUERYSLD:="	SELECT ZHD_PRODUT , "
				cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QATU),0) FROM SB2010 (NOLOCK) WHERE B2_FILIAL='"+xFILIAL('SB2')+"' AND  B2_COD=ZHD_PRODUT  AND D_E_L_E_T_='' ) AS  EST, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C1_QUANT-C1_QUJE),0)  FROM SC1010 (NOLOCK)  WHERE C1_FILIAL='"+xFILIAL('SC1')+"' AND  C1_PRODUTO=ZHD.ZHD_PRODUT AND D_E_L_E_T_='' AND C1_RESIDUO='' AND  C1_QUANT > C1_QUJE) AS  SOL, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C7_QUANT-C7_QUJE),0)  FROM SC7010 (NOLOCK)  WHERE C7_FILIAL='"+xFILIAL('SC7')+"' AND  C7_PRODUTO=ZHD.ZHD_PRODUT AND D_E_L_E_T_='' AND C7_RESIDUO='' AND  C7_QUANT > C7_QUJE) AS  PC, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QEMP),0) FROM SB2010 (NOLOCK)  WHERE B2_FILIAL='"+xFILIAL('SB2')+"' AND  B2_COD=ZHD_PRODUT  AND D_E_L_E_T_='' ) AS  EMP, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(ZHD_XQTDE),0)  FROM ZHD010 (NOLOCK) WHERE ZHD_FILIAL='"+xFILIAL('ZHD')+"' AND  ZHD_TIPO IN ('06-Ordem Producao') AND ZHD_PRODUT=ZHD.ZHD_PRODUT) AS  OP, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C6_QTDVEN-C6_QTDENT),0)  FROM SC6010 (NOLOCK) WHERE C6_FILIAL='"+xFILIAL('SC6')+"' AND  (C6_QTDVEN-C6_QTDENT)>0 AND D_E_L_E_T_='' AND C6_PRODUTO=ZHD.ZHD_PRODUT AND C6_BLQ<>'R')  AS  PV, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(ZHD_XQTDE),0)  FROM ZHD010 (NOLOCK) WHERE ZHD_FILIAL='"+xFILIAL('ZHD')+"' AND  ZHD_TIPO IN ('09-Previsao Venda')  AND ZHD_PRODUT=ZHD.ZHD_PRODUT) AS  PREV, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(ZHD_XQTDE),0)  FROM ZHD010 (NOLOCK) WHERE ZHD_FILIAL='"+xFILIAL('ZHD')+"' AND  ZHD_TIPO IN ('08-Saida Estrutura') AND ZHD_PRODUT=ZHD.ZHD_PRODUT) AS  SAES, "

				cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QATU),0) FROM SB2010 (NOLOCK) WHERE B2_FILIAL='"+xFILIAL('SB2')+"' AND  B2_COD=ZHD_PRODUT  AND D_E_L_E_T_='') + "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C1_QUANT-C1_QUJE),0)  FROM SC1010 (NOLOCK) WHERE C1_FILIAL='"+xFILIAL('SC1')+"' AND  C1_PRODUTO=ZHD.ZHD_PRODUT AND D_E_L_E_T_='' AND C1_RESIDUO='' AND C1_QUANT > C1_QUJE) + "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C7_QUANT-C7_QUJE),0)  FROM SC7010 (NOLOCK) WHERE C7_FILIAL='"+xFILIAL('SC7')+"' AND  C7_PRODUTO=ZHD.ZHD_PRODUT AND D_E_L_E_T_='' AND C7_RESIDUO='' AND C7_QUANT > C7_QUJE ) - "
				cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QEMP),0) FROM SB2010 (NOLOCK)  WHERE ZHD_FILIAL='"+xFILIAL('ZHD')+"' AND  B2_COD=ZHD_PRODUT  AND D_E_L_E_T_='' ) + "
				cQUERYSLD+="	(SELECT ISNULL(SUM(ZHD_XQTDE),0)  FROM ZHD010 (NOLOCK) WHERE ZHD_FILIAL='"+xFILIAL('ZHD')+"' AND  ZHD_TIPO IN ('06-Ordem Producao') AND ZHD_PRODUT=ZHD.ZHD_PRODUT) - "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C6_QTDVEN-C6_QTDENT),0)  FROM SC6010 (NOLOCK) WHERE C6_FILIAL='"+xFILIAL('SC6')+"' AND  (C6_QTDVEN-C6_QTDENT)>0 AND D_E_L_E_T_='' AND C6_PRODUTO=ZHD.ZHD_PRODUT  AND C6_BLQ<>'R') - "
				cQUERYSLD+="	(SELECT ISNULL(SUM(ZHD_XQTDE),0)  FROM ZHD010 (NOLOCK) WHERE ZHD_FILIAL='"+xFILIAL('ZHD')+"' AND  ZHD_TIPO IN ('09-Previsao Venda')  AND ZHD_PRODUT=ZHD.ZHD_PRODUT) AS FINAL "// -       "

				cQUERYSLD+="	FROM ZHD010 (NOLOCK) ZHD "
				cQUERYSLD+="	WHERE ZHD_PRODUT='"+ALLTRIM(TR1->ZHD_PRODUT)+"' AND ZHD_FILIAL = '"+xFILIAL('ZHD')+"'  "
				cQUERYSLD+="	GROUP BY ZHD_PRODUT "
				cQUERYSLD+="	ORDER BY ZHD_PRODUT "

				TCQUERY cQUERYSLD NEW ALIAS "TRS"
				TRS->( dbGoTop() )
				_nNEC2 :=TRS->FINAL
				TRS->(DBCLOSEAREA())
			ENDIF
			//---------------------------------

			lSTATUS :=.F.
			IF TR1->ZHD_STATUS=='X' .OR. TR1->ZHD_STATUS=='S'  //SC CHECK
				lSTATUS :=.T.
			ENDIF
			IF TR1->ZHD_XQTDE >0
				IF (SUBSTR(cFILTRO,1,1)=='1') .OR. (SUBSTR(cFILTRO,1,1)=='2' .and. _nNEC2 <0) .OR. (SUBSTR(cFILTRO,1,1)=='3' .and. _nNEC2 >=0)
					AADD(aColsNEC,{TR1->ZHD_PRODUT,;
						TR1->ZHD_TXDT1,;
						TR1->ZHD_XQTDE,;
						TR1->ZHD_XQTDE*TR1->ZHD_UPRC,;
						TR1->ZHD_NFORN,;
						TR1->ZHD_IDMRP,;
						TR1->ZHD_STATUS,;
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
		//U_MRPCHG01(oGetNEC,oGetSAI,oGetENT)
		cIDMRP  :=space(09)
		oIDMRP:refresh()
		oProduto:refresh()
	ENDIF

	IF (EMPTY(cIDMRP) .AND. EMPTY(cPRODUTO) ) .OR.  cTIPO=='F'
		aColsNEC  := {}

		cQueryID := " 	SELECT  B1_XFILMRP, "
		cQueryID += " 	ZHD_PERIOD, ZHD_NUMMRP, ZHD_NIVEL, ZHD_PRODUT,ZHD_PRODSH,ZHD_OPC,ZHD_REVISA,ZHD_REVSHW,ZHD_TIPO,ZHD_TEXTO,ZHD_SALDOE, "
		cQueryID += " 	ZHD_ENTRAD, ZHD_SAIDA , ZHD_SESTR, ZHD_SALDO ,ZHD_NEC,ZHD_DESC ,ZHD_TIPOP,ZHD_GRUPO,ZHD_XQTDE,ZHD_TXDT1,ZHD_TXDT2, "
		cQueryID += " 	ZHD_LTIME,ZHD_IDMRP,ZHD_NUMSC,ZHD_HISTSC, ZHD_QTDSC, ZHD_DATASC,ZHD_STATUS,SUBSTRING(ZHD_FORN+' '+ZHD_LOJA+' '+ZHD_NFORN,1,30)  AS ZHD_NFORN,ZHD_UPRC "
		cQueryID += " 	FROM ZHD010 (NOLOCK)  ,SB1010 (NOLOCK) "
		cQueryID += " 	WHERE B1_COD=ZHD_PRODUT AND B1_FILIAL = '"+xFILIAL('SB1')+"' AND ZHD_FILIAL = '"+xFILIAL('ZHD')+"'  "
		cQueryID += " 	AND   SUBSTRING(ZHD_TIPO,1,2)='01' AND ZHD_IDMRP<>'' "

		IF !EMPTY(cFUCOM)
			cQueryID += " 	AND ZHD_FORN='"+cFUCOM+"'  "
		ENDIF
		cQueryID += " 	AND SB1010.D_E_L_E_T_='' "
		IF SUBSTR(cFILMRP,1,1)=='1'
			cQueryID += " 	AND B1_XFILMRP='1' "
		ENDIF

		IF SUBSTR(cFILEMP,1,1)=='2'//com empenho
			cQueryID += " AND ZHD_PRODUT IN( SELECT D4_COD FROM SD4010 (NOLOCK) "
			cQueryID += " WHERE D4_FILIAL='"+xFILIAL('SD4')+"' AND D4_QUANT>0 AND SD4010.D_E_L_E_T_='' "
			cQueryID += " GROUP BY D4_COD ) "
		ENDIF

		IF SUBSTR(cFILEMP,1,1)=='3'//sem empenho
			cQueryID += " AND ZHD_PRODUT NOT IN( SELECT D4_COD FROM SD4010 (NOLOCK) "
			cQueryID += " WHERE D4_FILIAL='"+xFILIAL('SD4')+"' AND D4_QUANT>0 AND SD4010.D_E_L_E_T_='' "
			cQueryID += " GROUP BY D4_COD ) "
		ENDIF

		IF SUBSTR(cFILPRV,1,1)=='2' // QUERY RETIRAR PRODUTOS COM PREVISAO DE VENDA
			cQueryID += " AND ZHD_PRODUT NOT IN ( "
			cQueryID += " SELECT ZHD_PRODUT  "
			cQueryID += " FROM ZHD010 ZHD (NOLOCK) "
			cQueryID += " WHERE ZHD.ZHD_TIPO IN ('09-Previsao Venda')  "
			cQueryID += " AND ZHD.D_E_L_E_T_='' "
			cQueryID += " AND ZHD.ZHD_FILIAL='"+xFILIAL('ZHD')+"' "
			cQueryID += " AND ZHD.ZHD_SAIDA>0 ) "
		ENDIF

		cQueryID += " 	ORDER BY  ZHD_PRODUT,ZHD_TXDT2 "

		TCQUERY cQueryID NEW ALIAS "TR1"
		TR1->( dbGoTop() )
		DO WHILE .NOT. TR1->(EOF())
			//--------------------------------- filtro
			_nNEC2 :=0
			IF SUBSTR(cFILTRO,1,1)<>'1'
				cQUERYSLD:="	SELECT ZHD_PRODUT , "
				cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QATU),0)              FROM SB2010 (NOLOCK) WHERE B2_FILIAL ='"+xFILIAL('SB2')+"' AND  B2_COD=ZHD_PRODUT  AND D_E_L_E_T_='' ) AS  EST, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C1_QUANT-C1_QUJE),0)     FROM SC1010 (NOLOCK) WHERE C1_FILIAL ='"+xFILIAL('SC1')+"' AND  C1_PRODUTO=ZHD.ZHD_PRODUT AND D_E_L_E_T_='' AND C1_RESIDUO='' AND  C1_QUANT > C1_QUJE) AS  SOL, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C7_QUANT-C7_QUJE),0)     FROM SC7010 (NOLOCK) WHERE C7_FILIAL ='"+xFILIAL('SC7')+"' AND  C7_PRODUTO=ZHD.ZHD_PRODUT AND D_E_L_E_T_='' AND C7_RESIDUO='' AND  C7_QUANT > C7_QUJE) AS  PC, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QEMP),0)              FROM SB2010 (NOLOCK) WHERE B2_FILIAL ='"+xFILIAL('SB2')+"' AND  B2_COD=ZHD_PRODUT  AND D_E_L_E_T_='' ) AS  EMP, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(ZHD_XQTDE),0)            FROM ZHD010 (NOLOCK) WHERE ZHD_FILIAL='"+xFILIAL('ZHD')+"' AND  ZHD_TIPO IN ('06-Ordem Producao') AND ZHD_PRODUT=ZHD.ZHD_PRODUT) AS  OP, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C6_QTDVEN-C6_QTDENT),0)  FROM SC6010 (NOLOCK) WHERE C6_FILIAL ='"+xFILIAL('SC6')+"' AND  (C6_QTDVEN-C6_QTDENT)>0 AND D_E_L_E_T_='' AND C6_PRODUTO=ZHD.ZHD_PRODUT AND C6_BLQ<>'R')  AS  PV, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(ZHD_XQTDE),0)            FROM ZHD010 (NOLOCK) WHERE ZHD_FILIAL='"+xFILIAL('ZHD')+"' AND  ZHD_TIPO IN ('09-Previsao Venda')  AND ZHD_PRODUT=ZHD.ZHD_PRODUT) AS  PREV, "
				cQUERYSLD+="	(SELECT ISNULL(SUM(ZHD_XQTDE),0)            FROM ZHD010 (NOLOCK) WHERE ZHD_FILIAL='"+xFILIAL('ZHD')+"' AND  ZHD_TIPO IN ('08-Saida Estrutura') AND ZHD_PRODUT=ZHD.ZHD_PRODUT) AS  SAES, "

				cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QATU),0)              FROM SB2010 (NOLOCK) WHERE B2_FILIAL ='"+xFILIAL('SB2')+"' AND  B2_COD=ZHD_PRODUT  AND D_E_L_E_T_='') + "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C1_QUANT-C1_QUJE),0)     FROM SC1010 (NOLOCK) WHERE C1_FILIAL ='"+xFILIAL('SC1')+"' AND  C1_PRODUTO=ZHD.ZHD_PRODUT AND D_E_L_E_T_='' AND C1_RESIDUO='' AND C1_QUANT > C1_QUJE) + "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C7_QUANT-C7_QUJE),0)     FROM SC7010 (NOLOCK) WHERE C7_FILIAL ='"+xFILIAL('SC7')+"' AND  C7_PRODUTO=ZHD.ZHD_PRODUT AND D_E_L_E_T_='' AND C7_RESIDUO='' AND C7_QUANT > C7_QUJE ) - "
				cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QEMP),0)              FROM SB2010 (NOLOCK) WHERE B2_FILIAL ='"+xFILIAL('SB2')+"' AND  B2_COD=ZHD_PRODUT  AND D_E_L_E_T_='' ) + "
				cQUERYSLD+="	(SELECT ISNULL(SUM(ZHD_XQTDE),0)            FROM ZHD010 (NOLOCK) WHERE ZHD_FILIAL='"+xFILIAL('ZHD')+"' AND  ZHD_TIPO IN ('06-Ordem Producao') AND ZHD_PRODUT=ZHD.ZHD_PRODUT) - "
				cQUERYSLD+="	(SELECT ISNULL(SUM(C6_QTDVEN-C6_QTDENT),0)  FROM SC6010 (NOLOCK) WHERE C6_FILIAL ='"+xFILIAL('SC6')+"' AND  (C6_QTDVEN-C6_QTDENT)>0 AND D_E_L_E_T_='' AND C6_PRODUTO=ZHD.ZHD_PRODUT  AND C6_BLQ<>'R') - "
				cQUERYSLD+="	(SELECT ISNULL(SUM(ZHD_XQTDE),0)            FROM ZHD010 (NOLOCK) WHERE ZHD_FILIAL='"+xFILIAL('ZHD')+"' AND  ZHD_TIPO IN ('09-Previsao Venda')  AND ZHD_PRODUT=ZHD.ZHD_PRODUT) AS FINAL "// -       "

				cQUERYSLD+="	FROM ZHD010 (NOLOCK) ZHD "
				cQUERYSLD+="	WHERE ZHD_PRODUT='"+ALLTRIM(TR1->ZHD_PRODUT)+"' AND ZHD_FILIAL = '"+xFILIAL('ZHD')+"' AND ZHD.D_E_L_E_T_=''"
				cQUERYSLD+="	GROUP BY ZHD_PRODUT "
				cQUERYSLD+="	ORDER BY ZHD_PRODUT "

				TCQUERY cQUERYSLD NEW ALIAS "TRS"
				TRS->( dbGoTop() )
				_nNEC2 :=TRS->FINAL
				TRS->(DBCLOSEAREA())
			ENDIF
			//---------------------------------
			lSTATUS :=.F.
			IF TR1->ZHD_STATUS=='X' .OR. TR1->ZHD_STATUS=='S'  //SC CHECK
				lSTATUS :=.T.
			ENDIF
			IF TR1->ZHD_XQTDE >0
				IF (SUBSTR(cFILTRO,1,1)=='1') .OR. (SUBSTR(cFILTRO,1,1)=='2' .and. _nNEC2 <0) .OR. (SUBSTR(cFILTRO,1,1)=='3' .and. _nNEC2 >=0)
					AADD(aColsNEC,{TR1->ZHD_PRODUT,;
						TR1->ZHD_TXDT1,;
						TR1->ZHD_XQTDE,;
						TR1->ZHD_XQTDE*TR1->ZHD_UPRC,;
						TR1->ZHD_NFORN,;
						TR1->ZHD_IDMRP,;
						TR1->ZHD_STATUS,;
						lSTATUS})//.f. POSICAO 8Flag de Delecao]
					nQTDITEM++
				ENDIF
			ENDIF
			TR1->(DBSKIP())
		ENDDO
		IF LEN(aColsNEC)==0   //MLS 12/02/2020
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
		oQTDITEM:Refresh()

	ENDIF
	cALTER:=POSICIONE('SB1',1,xFILIAL('SB1')+ALLTRIM(cProduto),'B1_ALTER')
	IF !EMPTY(cALTER)
		cALTER :='Alternativo: '+ AllTrim(cALTER)
	ELSE
		cALTER:=''
	ENDIF
	oAlter:Refresh()

RETURN

	*----------------------------------------------------------------------------*
USER FUNCTION MRPCHG04(oGetNEC,oGetSAI,oGetENT)
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
		cQuerySI += " FROM  ZHD010 (NOLOCK) "
		cQuerySI += " WHERE ZHD010.D_E_L_E_T_='' AND ZHD_FILIAL = '"+xFILIAL('ZHD')+"' AND SUBSTRING(ZHD_TIPO,1,2)='02' " //AND ZHD_IDMRP<>'' "
		cQuerySI += "            AND ZHD_PRODUT    ='"+ALLTRIM(oGetNEC:ACOLS[nLIN][01])+"' "
		cQuerySI += "            AND ZHD_TXDT1 ='"+ALLTRIM(oGetNEC:ACOLS[nLIN][02])+"' "

		TCQUERY cQuerySI NEW ALIAS "TR2"
		TR2->( dbGoTop() )
		nSALDOI:=TR2->ZHD_XQTDE
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
		cQuerySI += " FROM  ZHD010 (NOLOCK) "
		cQuerySI += " WHERE ZHD010.D_E_L_E_T_='' AND  ZHD_FILIAL = '"+xFILIAL('ZHD')+"' AND SUBSTRING(ZHD_TIPO,1,2) IN('03','04','06') " //AND ZHD_IDMRP<>'' "
		cQuerySI += "            AND ZHD_PRODUT    ='"+ALLTRIM(oGetNEC:ACOLS[nLIN][01])+"' "
		cQuerySI += "            AND ZHD_TXDT1 ='"+ALLTRIM(oGetNEC:ACOLS[nLIN][02])+"' "

		TCQUERY cQuerySI NEW ALIAS "TR2"
		TR2->( dbGoTop() )
		DO WHILE !TR2->(EOF())
			AADD(aColsENT,{TR2->ZHD_TIPO,;
				TR2->ZHD_TEXTO,;
				TR2->ZHD_XQTDE,;
				.F.})//.f. POSICAO 8Flag de Delecao]
			nTotEnt:=nTotEnt+TR2->ZHD_XQTDE
			TR2->(DBSKIP())
		ENDDO

		IF LEN(aColsENT)==0  // mls 12/02/2020
			AADD(aColsENT,{"",;
				"",;
				"",;
				.T.})//.f. POSICAO 8Flag de Delecao]
		ENDIF

		TR2->(DBCLOSEAREA())
		oGetENT:ACOLS:=aCOLSENT
		oGetENT:ForceRefresh( )

		//------------------------------------------05 07 08 09- SAIDA
		cQuerySI := " SELECT  * "
		cQuerySI += " FROM  ZHD010 (NOLOCK)  "
		cQuerySI += " WHERE ZHD010.D_E_L_E_T_='' AND ZHD_FILIAL = '"+xFILIAL('ZHD')+"' AND SUBSTRING(ZHD_TIPO,1,2) IN('05','07','08','09') " //AND ZHD_IDMRP<>'' "
		cQuerySI += "            AND ZHD_PRODUT    ='"+ALLTRIM(oGetNEC:ACOLS[nLIN][01])+"' "
		cQuerySI += "            AND ZHD_TXDT1 ='"+ALLTRIM(oGetNEC:ACOLS[nLIN][02])+"' "

		TCQUERY cQuerySI NEW ALIAS "TR2"
		TR2->( dbGoTop() )

		DO WHILE !TR2->(EOF())
			AADD(aColsSAI,{TR2->ZHD_TIPO,;
				TR2->ZHD_TEXTO,;
				TR2->ZHD_XQTDE,;
				.F.})//.f. POSICAO 8Flag de Delecao]
			nTotSai:=nTotSai+TR2->ZHD_XQTDE
			DO CASE
			CASE ALLTRIM(TR2->ZHD_TIPO)=='09-Previsao Venda' .AND. ALLTRIM(SUBSTR(TR2->ZHD_TEXTO,1,4))=='WON'
				nTWON  :=nTWON +TR2->ZHD_XQTDE
			CASE ALLTRIM(TR2->ZHD_TIPO)=='09-Previsao Venda' .AND. ALLTRIM(SUBSTR(TR2->ZHD_TEXTO,1,4))=='BEST'
				nTBEST :=nTBEST+TR2->ZHD_XQTDE
			CASE ALLTRIM(TR2->ZHD_TIPO)=='09-Previsao Venda' .AND. ALLTRIM(SUBSTR(TR2->ZHD_TEXTO,1,4))=='IN'
				nTIN   :=nTIN  +TR2->ZHD_XQTDE
			ENDCASE
			TR2->(DBSKIP())
		ENDDO

		IF LEN(aColsSAI)==0  // mls 12/02/2020
			AADD(aColsSAI,{"",;
				"",;
				"",;
				.T.})//.f. POSICAO 8Flag de Delecao]
		ENDIF

		TR2->(DBCLOSEAREA())
		oGetSAI:ACOLS:=aCOLSSAI
		oGetSAI:forceRefresh( )

		cALTER:=''
		cPRODUTO:=oGetNEC:ACOLS[nLIN][01]
		cDESCRI:=POSICIONE('SB1',1,xFILIAL('SB1')+oGetNEC:ACOLS[nLIN][01],'B1_DESC')
		cIDMRP:=oGetNEC:ACOLS[nLIN][06] //mls
		dData :=ctod(oGetNEC:ACOLS[nLIN][02] )
		cALTER:=POSICIONE('SB1',1,xFILIAL('SB1')+oGetNEC:ACOLS[nLIN][01],'B1_ALTER')
		IF !EMPTY(cALTER)
			cALTER :='Alternativo: '+ AllTrim(cALTER)
		ENDIF

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

		IF LEN(aColsSC)==0  // mls 12/02/2020
			AADD(aColsSC,{"",;
				"",;
				0,;
				.T.})//.f. POSICAO 8Flag de Delecao]
		ENDIF
		TRSC->(DBCLOSEAREA())

		//------------------------------------------PCs
		nPCA    :=0
		aColsPC :={}

		cQUERYPC := " SELECT C7_NUM,C7_DATPRF,C7_QUANT-C7_QUJE AS C7_SALDO "
		cQUERYPC += " FROM SC7010 (NOLOCK)               "
		cQUERYPC += " WHERE C7_FILIAL = '"+xFILIAL('SC7')+"' AND                      "
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

		IF LEN(aColsPC)==0  // mls 12/02/2020
			AADD(aColsPC,{"",;
				"",;
				0,;
				.T.})//.f. POSICAO 8Flag de Delecao]
		ENDIF
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
		IF LEN(aColsMV)==0  // mls 12/02/2020
			AADD(aColsMV,{"",;
				"",;
				"",;
				0,;
				.T.})//.f. POSICAO 8Flag de Delecao]
		ENDIF

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

		cQUERYSLD:="	SELECT ZHD_PRODUT , "
		//	cQUERYSLD+="	(SELECT TOP 1 ZHD_XQTDE FROM ZHD010 WHERE ZHD_TIPO IN ('02-Saldo Estoque' ) AND ZHD_PRODUT=ZHD.ZHD_PRODUT) AS  EST, "
		cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QATU),0) FROM SB2010 (NOLOCK) WHERE B2_FILIAL='"+xFILIAL('SB2')+"' AND  B2_COD=ZHD_PRODUT  AND D_E_L_E_T_='' AND B2_FILIAL='"+xFILIAL('SB2')+"' ) AS  EST, "
		cQUERYSLD+="	(SELECT ISNULL(SUM(C1_QUANT-C1_QUJE),0)  FROM SC1010 (NOLOCK) WHERE C1_FILIAL='"+xFILIAL('SC1')+"' AND  C1_PRODUTO=ZHD.ZHD_PRODUT AND D_E_L_E_T_='' AND C1_RESIDUO='' AND  C1_QUANT > C1_QUJE) AS  SOL, "
		cQUERYSLD+="	(SELECT ISNULL(SUM(C7_QUANT-C7_QUJE),0)  FROM SC7010 (NOLOCK) WHERE C7_FILIAL='"+xFILIAL('SC7')+"' AND  C7_PRODUTO=ZHD.ZHD_PRODUT AND D_E_L_E_T_='' AND C7_RESIDUO='' AND  C7_QUANT > C7_QUJE) AS  PC, "
		//	cQUERYSLD+="	(SELECT ISNULL(SUM(ZHD_XQTDE),0)  FROM ZHD010 WHERE ZHD_TIPO IN ('05-Empenho       ') AND ZHD_PRODUT=ZHD.ZHD_PRODUT) AS  EMP, "
		cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QEMP),0) FROM SB2010 (NOLOCK)  WHERE B2_FILIAL='"+xFILIAL('SB2')+"' AND  B2_COD=ZHD_PRODUT  AND D_E_L_E_T_='' ) AS  EMP, "
		cQUERYSLD+="	(SELECT ISNULL(SUM(ZHD_XQTDE),0)  FROM ZHD010 (NOLOCK) WHERE ZHD_FILIAL='"+xFILIAL('ZHD')+"' AND   ZHD_TIPO IN ('06-Ordem Producao') AND ZHD_PRODUT=ZHD.ZHD_PRODUT) AS  OP, "
		//	cQUERYSLD+="	(SELECT ISNULL(SUM(ZHD_XQTDE),0)  FROM ZHD010 WHERE ZHD_TIPO IN ('07-Pedido Venda  ') AND ZHD_PRODUT=ZHD.ZHD_PRODUT) AS  PV, "
		cQUERYSLD+="	(SELECT ISNULL(SUM(C6_QTDVEN-C6_QTDENT),0)  FROM SC6010 (NOLOCK) WHERE C6_FILIAL='"+xFILIAL('SC6')+"' AND  (C6_QTDVEN-C6_QTDENT)>0 AND D_E_L_E_T_='' AND C6_PRODUTO=ZHD.ZHD_PRODUT AND C6_BLQ<>'R')  AS  PV, "
		cQUERYSLD+="	(SELECT ISNULL(SUM(ZHD_XQTDE),0)  FROM ZHD010 (NOLOCK) WHERE ZHD_FILIAL='"+xFILIAL('ZHD')+"' AND  ZHD_TIPO IN ('09-Previsao Venda')  AND ZHD_PRODUT=ZHD.ZHD_PRODUT) AS  PREV, "
		cQUERYSLD+="	(SELECT ISNULL(SUM(ZHD_XQTDE),0)  FROM ZHD010 (NOLOCK) WHERE ZHD_FILIAL='"+xFILIAL('ZHD')+"' AND  ZHD_TIPO IN ('08-Saida Estrutura') AND ZHD_PRODUT=ZHD.ZHD_PRODUT) AS  SAES, "

		cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QATU),0) FROM SB2010 (NOLOCK) WHERE B2_FILIAL='"+xFILIAL('SB2')+"' AND  B2_COD=ZHD_PRODUT  AND D_E_L_E_T_='') + "
		cQUERYSLD+="	(SELECT ISNULL(SUM(C1_QUANT-C1_QUJE),0)  FROM SC1010 (NOLOCK) WHERE C1_FILIAL='"+xFILIAL('SC1')+"' AND  C1_PRODUTO=ZHD.ZHD_PRODUT AND D_E_L_E_T_='' AND C1_RESIDUO='' AND C1_QUANT > C1_QUJE) + "
		cQUERYSLD+="	(SELECT ISNULL(SUM(C7_QUANT-C7_QUJE),0)  FROM SC7010 (NOLOCK) WHERE C7_FILIAL='"+xFILIAL('SC7')+"' AND  C7_PRODUTO=ZHD.ZHD_PRODUT AND D_E_L_E_T_='' AND C7_RESIDUO='' AND C7_QUANT > C7_QUJE ) - "
		cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QEMP),0) FROM SB2010 (NOLOCK)  WHERE B2_FILIAL='"+xFILIAL('SB2')+"' AND  B2_COD=ZHD_PRODUT  AND D_E_L_E_T_='' ) + "
		cQUERYSLD+="	(SELECT ISNULL(SUM(ZHD_XQTDE),0)  FROM ZHD010 (NOLOCK) WHERE ZHD_FILIAL='"+xFILIAL('ZHD')+"' AND  ZHD_TIPO IN ('06-Ordem Producao') AND ZHD_PRODUT=ZHD.ZHD_PRODUT) - "
		//	cQUERYSLD+="	(SELECT ISNULL(SUM(ZHD_XQTDE),0)  FROM ZHD010 WHERE ZHD_TIPO IN ('07-Pedido Venda  ') AND ZHD_PRODUT=ZHD.ZHD_PRODUT) - "
		cQUERYSLD+="	(SELECT ISNULL(SUM(C6_QTDVEN-C6_QTDENT),0)  FROM SC6010 (NOLOCK) WHERE C6_FILIAL='"+xFILIAL('SC6')+"' AND  (C6_QTDVEN-C6_QTDENT)>0 AND D_E_L_E_T_='' AND C6_PRODUTO=ZHD.ZHD_PRODUT  AND C6_BLQ<>'R') - "
		cQUERYSLD+="	(SELECT ISNULL(SUM(ZHD_XQTDE),0)  FROM ZHD010 (NOLOCK) WHERE ZHD_FILIAL='"+xFILIAL('ZHD')+"' AND  ZHD_TIPO IN ('09-Previsao Venda')  AND ZHD_PRODUT=ZHD.ZHD_PRODUT) AS FINAL "// -       "
		//	cQUERYSLD+="	(SELECT ISNULL(SUM(ZHD_XQTDE),0)  FROM ZHD010 (NOLOCK) WHERE ZHD_TIPO IN ('08-Saida Estrutura') AND ZHD_PRODUT=ZHD.ZHD_PRODUT) AS FINAL "

		cQUERYSLD+="	FROM ZHD010 (NOLOCK) ZHD "
		cQUERYSLD+="	WHERE ZHD_PRODUT='"+ALLTRIM(oGetNEC:ACOLS[nLIN][01])+"'  AND ZHD.D_E_L_E_T_='' "
		cQUERYSLD+="	GROUP BY ZHD_PRODUT "
		cQUERYSLD+="	ORDER BY ZHD_PRODUT "

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
		oAlter  :REFRESH()
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
		cQuerySI += " FROM ZHD010 (NOLOCK)  "
		cQuerySI += " WHERE ZHD_FILIAL = '"+xFILIAL('ZHD')+"' AND ZHD_IDMRP='"+ALLTRIM(oGetNEC:ACOLS[nLIN][06])+"' AND ZHD010.D_E_L_E_T_='' "

		TCQUERY cQuerySI NEW ALIAS "TR2"
		TR2->( dbGoTop() )
		IF !EMPTY(TR2->ZHD_NUMSC)
			cMSG2 :='SC: '+TR2->ZHD_NUMSC+' Qtde: '+Transform(TR2->ZHD_QTDSC,"@E 9,999,999.99")+" Data: "+SUBSTR(TR2->ZHD_DATASC,7,2)+'/'+SUBSTR(TR2->ZHD_DATASC,5,2)+'/'+SUBSTR(TR2->ZHD_DATASC,1,4)
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
USER FUNCTION MRPSCPC4()
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
USER FUNCTION  MRPCHK04(oGetNEC)
	*----------------------------------------------------------------------------*
	LOCAL nLIN :=oGetNEC:nat
	LOCAL cQ1 := ""
	IF oGetNEC:ACOLS[nLIN][07]<>'X' // COM SC
		IF oGetNEC:ACOLS[nLIN][08]==.T. //DELETADO
			oGetNEC:ACOLS[nLIN][08]:=.F.
			cQ1 := "UPDATE ZHD010 SET ZHD_STATUS='N' WHERE ZHD_IDMRP='"+oGetNEC:ACOLS[nLIN][06]+"'"
		ELSE
			oGetNEC:ACOLS[nLIN][08]:=.T. //DELETADO
			cQ1 := "UPDATE ZHD010 SET ZHD_STATUS='S' WHERE ZHD_IDMRP='"+oGetNEC:ACOLS[nLIN][06]+"'"
		ENDIF
		TCSQLEXEC(cQ1)
	ENDIF
	oGetNEC:oBrowse:Refresh()

RETURN

	*----------------------------------------------------------------------------*
USER FUNCTION MRP004SC()
	*----------------------------------------------------------------------------*

	Local cTitulo        := "ZHD"
	Local oDLG1Marc
	Local oFnt
	Local aBotoes        := {}
	//Local lopc           :=.F.
	//local cvirgula       := ""

	Local oOK	         := LoadBitmap( GetResources(), "LBOK" )
	Local oNO	         := LoadBitmap( GetResources(), "LBNO" )

	Private cStatus:=''

	PRIVATE cTITULOE     :='SOLICITACAO DE COMPRAS - MRP Filial 02'

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

	MsgRun("AGUARDE... Buscando Dados...",,{ || MRPSC004(@aDados) })

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
	@ 174,245 MSGET oQTDSC  VAR nQTDSC     WHEN(.T.)   OF oDLG1Marc SIZE 070,005 PICTURE ("@E 999,999,999.99") PIXEL COLOR CLR_HBLUE FONT oFontBRW3

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
Static Function MRPSC004()
	*-------------------------------------------------------------------------------------------------------------
	LOCAL nLIN    :=oGetNEC:nat
	//Local cPedido := "000000"
	local nCount  := 1
	//local nCount2 := 1
	Local cQuery  := ''
	Local oTMP

	cQuery := " Select * From " + RetSqlName("ZHD") + " (NOLOCK) ZHD "
	cQuery += " Where ZHD_FILIAL = '"+xFILIAL('ZHD')+"' "
	cQuery += " AND ZHD_PRODUT = '"+oGetNEC:ACOLS[nLIN][01]+"' AND ZHD_IDMRP <> '' AND ZHD.D_E_L_E_T_=''  "//AND ZHD_STATUS<>'X' "
	cQuery += " Order BY ZHD_IDMRP "

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
		IF TMP:=ZHD_STATUS<>'X'
			oTMP:=oNor
		ELSE
			oTMP:=oIn
		ENDIF
		AADD(aDados, {  .F. , ;
			oTMP ,;
			TMP->ZHD_IDMRP,;
			TMP->ZHD_TXDT1,;
			TMP->ZHD_XQTDE ,;
			TMP->ZHD_NUMSC})

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
	//Local nCont     :=1
	Local aCab      :={}
	Local aItem     :={}
	//Local aCabItem  :={}
	//Local cScAnt
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
					cQ1 := " UPDATE ZHD010 SET "
					cQ1 += " ZHD_STATUS='X' ,ZHD_NUMSC='"+alltrim(cNumero)+"',ZHD_HISTSC='SC Gerada MRP',ZHD_QTDSC='"+alltrim(STR(_nQTDSC))+"',ZHD_DATASC='"+DTOS(_dDATASC)+"'"
					cQ1 += " WHERE ZHD_IDMRP='"+alltrim(aDados[i,3])+"'"
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
			ZHD->(DBSELECTAREA('ZHD'))
			RecLock("ZHD",.T.)
			ZHD_FILIAL := xFILIAL('ZHD')
			ZHD_PERIOD := _dDATASC
			ZHD_NUMMRP := SUBSTR(_CIDMRP,1,6)
			ZHD_PRODUT := _cPRODUTO
			ZHD_DESC   := POSICIONE('SB1',1,xFILIAL('SB1')+_cPRODUTO,'B1_DESC')
			ZHD_TIPOP  := POSICIONE('SB1',1,xFILIAL('SB1')+_cPRODUTO,'B1_TIPO')
			ZHD_GRUPO  := POSICIONE('SB1',1,xFILIAL('SB1')+_cPRODUTO,'B1_GRUPO')
			ZHD_TIPO   := '03-Sol.Compras'
			ZHD_TEXTO  := cNumero+'/'+cITEM+' '
			ZHD_TXDT1  := DTOC(_dDATASC)
			ZHD_TXDT2  := _dDATASC
			ZHD_XQTDE  := _nQTDSC
			ZHD_ENTRAD := _nQTDSC
			ZHD_NUMSC  := cNumero
			ZHD->( msUnlock() )
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

	ZHD->(DBSELECTAREA('ZHD'))
	ZHD->(DBSETORDER(3)) //ZHD_FILIAL+ZHD_NUMMRP+ZHD_PRODUT+DTOS(ZHD_PERIOD)+ZHD_TIPO
	ZHD->(DBGOTOP())

	cQ1 := " UPDATE ZHD010 SET "
	cQ1 += " ZHD_TIPO = '11-Necessidade' "
	cQ1 += " WHERE ZHD_FILIAL='"+xFILIAL('ZHD')+"' AND ZHD_TIPO='01-Necessidade' AND ZHD_PRODUT='"+_cPRODUTO+"'"
	TCSQLEXEC(cQ1)    //MLS

	ZHD->(DBSEEK(xFILIAL('ZHD')+_cNUMMRP+_cPRODUTO))

	cPRODUT := ZHD->ZHD_PRODUT
	dPERIOD := ZHD->ZHD_PERIOD

	nSALDO  := 0
	nENTRAD := 0
	nSAIDA  := 0
	nSESTR  := 0
	nSALDOF := 0

	DO WHILE  !ZHD->(Eof()) .AND. cPRODUT==ZHD->ZHD_PRODUT  //.AND.  dPERIOD==CTOD(SUBSTR(ZHD->ZHD_PERIOD,7,2)+'/'+SUBSTR(ZHD->ZHD_PERIOD,5,2)+'/'+SUBSTR(ZHD->ZHD_PERIOD,1,4))

		IF ALLTRIM(cPRODUT)==ALLTRIM(ZHD->ZHD_PRODUT) .AND. dPERIOD<>ZHD->ZHD_PERIOD
			IF SUBSTR(ZHD->ZHD_TIPO,1,2)=='02'
				IF nSALDOF<0
					RecLock("ZHD",.F.)
					ZHD_XQTDE  := 0
					ZHD_SALDOE := 0
					ZHD->( msUnlock() )
				ELSE
					RecLock("ZHD",.F.)
					ZHD_XQTDE  := nSALDOF
					ZHD_SALDOE := nSALDOF
					ZHD->( msUnlock() )
				ENDIF
				cPRODUT := ZHD->ZHD_PRODUT
				dPERIOD := ZHD->ZHD_PERIOD
				nSALDO  := 0
				nENTRAD := 0
				nSAIDA  := 0
				nSESTR  := 0
				nSALDOF := 0
			ENDIF
		ELSE
			IF ALLTRIM(cPRODUT)<>ALLTRIM(ZHD->ZHD_PRODUT)
				cPRODUT := ZHD->ZHD_PRODUT
				dPERIOD := ZHD->ZHD_PERIOD
				nSALDO  := 0
				nENTRAD := 0
				nSAIDA  := 0
				nSESTR  := 0
				nSALDOF := 0
			ENDIF
		ENDIF
		DO CASE
		CASE ZHD->ZHD_SALDOE    > 0
			nSALDO :=nSALDO+ZHD->ZHD_SALDOE
		CASE ZHD->ZHD_ENTRAD    > 0
			nENTRAD:=nENTRAD+ZHD->ZHD_ENTRAD
		CASE ZHD->ZHD_SAIDA     > 0
			nSAIDA :=nSAIDA+ZHD->ZHD_SAIDA
		CASE ZHD->ZHD_SESTR     > 0
			nSESTR :=nSESTR+ZHD->ZHD_SESTR
		CASE SUBSTR(ZHD->ZHD_TIPO,1,2)  == '10'//'10-Saldo Final'
			nSALDOF:=(nSALDO+nENTRAD)-(nSAIDA+nSESTR)
			RecLock("ZHD",.F.)
			ZHD_XQTDE  := nSALDOF
			ZHD_SALDO  := nSALDOF
			ZHD->( msUnlock() )
		CASE  SUBSTR(ZHD->ZHD_TIPO,1,2)  == '11'// '11-Necessidade'
			IF nSALDOF<0
				RecLock("ZHD",.F.)
				ZHD_XQTDE  := nSALDOF*(-1)
				ZHD_NEC    := nSALDOF*(-1)
				ZHD->( msUnlock() )
			ELSE
				RecLock("ZHD",.F.)
				ZHD_XQTDE  := 0
				ZHD_NEC    := 0
				ZHD->( msUnlock() )
			ENDIF
		ENDCASE
		ZHD->(DBSKIP())
	ENDDO

	cQ1 := " UPDATE ZHD010 SET "
	cQ1 += " ZHD_TIPO = '01-Necessidade' "
	cQ1 += " WHERE ZHD_TIPO='11-Necessidade' AND ZHD_PRODUT='"+_cPRODUTO+"'"
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
		MSGALERT('Nao existe (09-Previsisao Venda) para esse item '+cPRODUTO)
	ENDIF

RETURN

	*----------------------------------------------------------------------------*
STATIC FUNCTION MRPZPRV2(oGetSAI,cPRODUTO)
	*----------------------------------------------------------------------------*

	Local cTitulo        := "ZHD"
	Local oDLG1Marc
	Local oFnt
	Local aBotoes        := {}
	//Local lopc           :=.F.
	//local cvirgula       := ""

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
		alert("N�o existe dados")
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
	//Local cPedido := "000000"
	local nCount  := 1
	//local nCount2 := 1
	Local cQuery  := ''
	Local oTMP

	cQuery := " Select * From " + RetSqlName("ZHD") + " (NOLOCK) ZHD "
	cQuery += " Where ZHD_FILIAL = '"+xFILIAL('ZHD')+"'  AND ZHD.D_E_L_E_T_=''  "
	cQuery += " AND ZHD_PRODUT   =  '"+cPRODUTO+"' "
	cQuery += " AND ZHD_TIPO     = '09-Previsao Venda' "
	cQuery += " Order BY ZHD_IDMRP  "

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
			TMP->ZHD_SAIDA,;
			TMP->ZHD_TXDT1+' '+TMP->ZHD_TEXTO,;
			TMP->ZHD_SC4REC,;
			TMP->R_E_C_N_O_})
		nQTDPRV:=nQTDPRV+TMP->ZHD_SAIDA
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

	oLbx:Refresh()
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
				nZHDREC :=aDados[i,6]
				nC4REC  :=aDados[i,5]
				cQZ1 := " UPDATE ZHD010 SET ZHD_SAIDA=0 , ZHD_XQTDE=0 WHERE  ZHD_FILIAL='"+xFILIAL('ZHD')+"' AND R_E_C_N_O_="+ALLTRIM(STR(nZHDREC))+"  "
				cQZ2 := " UPDATE SC4010 SET C4_QUANT =0               WHERE   C4_FILIAL='"+xFILIAL('SC4')+"' AND R_E_C_N_O_="+ALLTRIM(STR(nC4REC))+"  "
				TCSQLEXEC(cQZ1)
				TCSQLEXEC(cQZ2)
			Endif
		Next i
	ENDIF
	oLbx:Refresh()

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DCADSC4   �Autor  �  Mauricio Lima de Souza -OPUS            ���
��� Data � 28/12/2019                                                     ���
�������������������������������������������������������������������������͹��
���Desc.     �  AxCadastro.                                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function DCADSC4

	Local cAlias  := "SC4"
	Local cTitulo := "Prev. Venda Simulacao"
//Local cFunExc := "U_RERPA02A()"
	Local cFunAlt := "U_DCADSC4AL()"
	Local cFunEXC := "U_DCADSC4EX()"
	cFiltro := "C4_XXSIMU == 'S' "

	dbselectarea("SC4")
	SET FILTER TO &(cFiltro)
	//AxCadastro( <cAlias>, <cTitulo>, <cVldExc>, <cVldAlt>)
	AxCadastro(cAlias, cTitulo,cFunEXC, cFunAlt)
	SET FILTER TO

Return

User Function DCADSC4EX
	local QSC4:=''
	local _lRet:=.F.


	QSC4 := " UPDATE SC4010 SET D_E_L_E_T_='*', R_E_C_D_E_L_=R_E_C_N_O_ "
	QSC4 += " WHERE C4_XXCOD='"+SC4->C4_XXCOD+"'  AND C4_FILIAL='"+xFILIAL('SC4')+"'  "
	//TCSQLEXEC(cQ1)
	IF SC4->C4_XXSIMU=='S'
		IF MSGYESNO( "Excluir Previsao de Venda N."+SC4->C4_XXCOD, "Exclusao" )
			TCSQLEXEC(QSC4)
			_lRet:=.T.
		ELSE
			MSGALERT("Nao foi Excluida  a previsao "+SC4->C4_XXCOD,"Exclusao Cancelada")
			lRet:=.F.

		ENDIF
	ELSE
		MSGALERT("Nao pode ser Excluida "+SC4->C4_XXCOD,"Previsao Nao eh Simulacao")
		_lRet:=.F.
	ENDIF
RETURN _lRet

User Function DCADSC4AL
	local dEdit1 := M->C4_DATA
	Local lRet := .T.
	Private _oDlg

	If INCLUI

		DEFINE MSDIALOG _oDlg TITLE "Data da Previsao de Venda" FROM C(178),C(181) TO C(268),C(427) PIXEL

		@ C(014),C(045) MsGet oEdit1 Var dEdit1 Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
		@ C(015),C(005) Say "Data :" Size C(038),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
		@ C(032),C(067) Button "Confirma" Size C(037),C(012) ACTION (GrvDSaida(dEdit1),_oDlg:End()) PIXEL OF _oDlg

		ACTIVATE MSDIALOG _oDlg CENTERED

	EndIf

	lRet := MsgBox('Incluir item Simulacao MRP Filial02', "Confirmacao", "YESNO")

Return lRet

STATIC FUNCTION GrvDSaida(dEdit1)

	M->C4_XXSIMU :='S'
	M->C4_DATA   := dEdit1

Return Nil

STATIC FUNCTION Xjob712()
	Local aSaveArea	:= GetArea()
	U_Ejobm712()
	RestArea(aSaveArea)
	//MSGALERT('Fim Processamento  - MRP Simulacao')
	lprocmrp :=.t.
	//oDlg:End()
//	U_MRP002B()
RETURN

STATIC FUNCTION Xjob713D() //SIMULACAO
	Local aSaveArea	:= GetArea()
	MSGALERT('MRP SIMULCAO FILIAL 02, Aguarde fim de processamento')

//-------------------------------------------------------------
	cData     := DtoC(Date())
	cAssunto  := "MRP SIMULACAO V2 Filial 02 Explode SC4 Prev.Venda - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
	cTexto    := "MRP SIMULACAO V2 Filial 02 Explode SC4 Prev.Venda - Date " + cData + "  Time: " + Time()
	cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br"
	cCC       := ""
	cArquivo  := ""

	U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)

	U_ExplSC4()
//-------------------------------------------------------------

	U_MRPTST1D()
	RestArea(aSaveArea)
	MSGALERT('Fim Processamento  - Sair e entrar novamente na Rotina')
	//-------------------------------------------------------------
	cData     := DtoC(Date())
	cAssunto  := "FIM MRP SIMULACAO V2 filial 02 Explode SC4 Prev.Venda - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
	cTexto    := "FIM MRP SIMULACAO V2 filial 02 Explode SC4 Prev.Venda - Date " + cData + "  Time: " + Time()
	cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br"
	cCC       := ""
	cArquivo  := ""

	U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)

	lprocmrp :=.t.
//	oDlg:End()
RETURN


	*-----------------------------------------------------------------*
USER FUNCTION MRPTST1D()
	*-----------------------------------------------------------------*

	cQUERY1:=" DELETE FROM ZHD010  "
	TCSQLEXEC(cQUERY1)

	//cQuery := " SELECT B2_TIPO AS ZHD_TIPO,B2_COD AS ZHD_PRODUT,B2_QATU AS ZHD_QTDE,OBS AS ZHD_TEXTO "
	//cQuery += " FROM SIMSB2D    UNION ALL "
	//cQuery += " SELECT * FROM SIMSC4D  UNION ALL "
	//cQuery += " SELECT * FROM SIMSD4D "

        cQuery := " SELECT B2_TIPO AS ZHD_TIPO,B2_COD AS ZHD_PRODUT,B2_QATU AS ZHD_QTDE,OBS AS ZHD_TEXTO "
	cQuery += " FROM SIMSB2D    UNION ALL "
	cQuery += " SELECT * FROM SIMSC4D  UNION ALL "
	cQuery += " SELECT * FROM SIMSD4D UNION ALL "
	cQuery += " SELECT * FROM SIMSC4ALTD "
	cQuery += " ORDER BY B2_COD,B2_TIPO "



	TcQuery cQuery Alias "TRB" New

	TRB->(DbGoTop())

	If TRB->(Eof())
		//	Alert("Nao foi encontrado nenhum item neste Processo !")
		DbSelectArea("TRB")
		TRB->(DbCloseArea())
		Return()
	EndIf

	ZHD->(DBSELECTAREA('ZHD'))
	ZHD->(DBSETORDER(2))

	//cIDMRP :=TRB->ZHD_NUMMRP+'000'// INICIALIZADOR IDMRP
	cIDMRP :='0000000'

	dPERIOD := DATE()
	cNUMMRP := '000000'
	cPRODUT := TRB->ZHD_PRODUT
	cPERMRP := ''//TRB->CZI_PERMRP

	nQTDE:=0
	DO WHILE .NOT. TRB->(EOF())
		cPROD:=TRB->ZHD_PRODUT
		RecLock("ZHD",.T.)
		IF ALLTRIM(TRB->ZHD_TIPO)=='02-Saldo Estoque'
			ZHD->ZHD_FILIAL := xFILIAL('ZHD')
			//ZHD->ZHD_PERIOD := dPERIOD
			//ZHD->ZHD_NUMMRP := TRB->ZHD_NUMMRP
			ZHD->ZHD_PRODUT := TRB->ZHD_PRODUT
			//ZHD->ZHD_DESC   := TRB->ZHD_DESC
			ZHD->ZHD_TIPO   := TRB->ZHD_TIPO
			//ZHD->ZHD_TIPOP  := TRB->ZHD_TIPOP
			//ZHD->ZHD_GRUPO  := TRB->ZHD_GRUPO
			//ZHD->ZHD_NIVEL  := TRB->ZHD_NIVEL
			////ZHD->ZHD_REVISA := TRB->ZHD_REVISA
			////ZHD->ZHD_REVSHW := TRB->ZHD_REVSHW
			ZHD->ZHD_SALDOE := TRB->ZHD_QTDE
			ZHD->ZHD_TEXTO  := TRB->ZHD_TEXTO
			nQTDE:=TRB->ZHD_QTDE
		ENDIF
		IF ALLTRIM(TRB->ZHD_TIPO)=='09-Previsao Venda'
			ZHD->ZHD_FILIAL := xFILIAL('ZHD')
			ZHD->ZHD_TIPO   := TRB->ZHD_TIPO
			ZHD->ZHD_PRODUT := TRB->ZHD_PRODUT
			ZHD->ZHD_TIPO   := TRB->ZHD_TIPO
			ZHD->ZHD_SAIDA  := TRB->ZHD_QTDE
			ZHD->ZHD_TEXTO  := TRB->ZHD_TEXTO
			nQTDE:=nQTDE-TRB->ZHD_QTDE
		ENDIF
		IF ALLTRIM(TRB->ZHD_TIPO)=='05-Empenho'
			ZHD->ZHD_FILIAL := xFILIAL('ZHD')
			ZHD->ZHD_TIPO   := TRB->ZHD_TIPO
			ZHD->ZHD_PRODUT := TRB->ZHD_PRODUT
			ZHD->ZHD_TIPO   := TRB->ZHD_TIPO
			ZHD->ZHD_SAIDA  := TRB->ZHD_QTDE
			ZHD->ZHD_TEXTO  := TRB->ZHD_TEXTO
			nQTDE:=nQTDE-TRB->ZHD_QTDE
		ENDIF
		//ZHD->ZHD_TXDT1  := DTOC(dPERIOD)
		//ZHD->ZHD_TXDT2  := dPERIOD
		ZHD->ZHD_XQTDE  := TRB->ZHD_QTDE
		//ZHD->ZHD_SC4REC := TRB->ZHD_SC4REC
		//DO CASE
		//CASE SUBSTR(TRB->ZHD_TIPO,1,2) $('05|07|09|00')  //05-Empenho   07-Pedido Venda    09-Previsao Venda 00-Seguranca
		//	ZHD->ZHD_SAIDA:=TRB->CZI_QUANT
		//CASE SUBSTR(TRB->ZHD_TIPO,1,2) =='08'            //08-Saida Estrutura
		//	ZHD->ZHD_SESTR:=TRB->CZI_QUANT
		//CASE SUBSTR(TRB->ZHD_TIPO,1,2) $('03|04|06')     //03-Sol.Compras //04-Pedido Compra   06-Ordem Producao
		//	ZHD->ZHD_ENTRAD:=TRB->CZI_QUANT
		//ENDCASE

		//nSLDINI  :=TRB->CZK_QTSLES    //SALDO INICIAL    02-Saldo Estoque
		//CZK_QTENTR                  //ENTRADA
		//CZK_QTSAID                  //SAIDA
		//CZK_QTSEST                  //SAIDA ESTRUTURA
		//nSLDFIN  :=TRB->CZK_QTSALD    //SALDO FINAL      10-Saldo Final
		//nNECE    :=TRB->CZK_QTNECE    //NECESSIDADE      01-Necessidade

		//cDESC    :=TRB->ZHD_DESC
		//cTIPOP   :=TRB->ZHD_TIPOP
		//cGRUPO   :=TRB->ZHD_GRUPO
		//dDATA    :=dPERIOD
		ZHD->ZHD_TXDT1  := DTOC(DATE())
		ZHD->ZHD_TXDT2  := DATE()
		ZHD_NUMMRP :='000000'
		ZHD_IDMRP  :='000000'
		ZHD_PERIOD := DATE()
		ZHD->( msUnlock() )
		TRB->(DBSKIP())
		IF TRB->ZHD_PRODUT<>cPROD
			IF nQTDE<0
				RecLock("ZHD",.T.)
				ZHD->ZHD_FILIAL := xFILIAL('ZHD')
				ZHD->ZHD_PRODUT := cPROD
				ZHD->ZHD_TIPO   := '01-Necessidade'
				ZHD->ZHD_NEC    := nQTDE*(-1)
				ZHD->ZHD_XQTDE  := nQTDE*(-1)
				ZHD->ZHD_TXDT1  := DTOC(DATE())
				ZHD->ZHD_TXDT2  := DATE()
				ZHD_NUMMRP :='000000'
				ZHD_IDMRP :='000000'
				ZHD_PERIOD := DATE()
				ZHD->( msUnlock() )
			ENDIF
			RecLock("ZHD",.T.)
			ZHD->ZHD_FILIAL := xFILIAL('ZHD')
			ZHD->ZHD_PRODUT := cPROD
			ZHD->ZHD_TIPO   := '10-Saldo Final'
			ZHD->ZHD_SALDO  := nQTDE
			ZHD->ZHD_XQTDE  := nQTDE
			ZHD->ZHD_TXDT1  := DTOC(DATE())
			ZHD->ZHD_TXDT2  := DATE()
			ZHD_NUMMRP :='000000'
			cIDMRP     := Soma1(cIDMRP,7,.T.,.T.)
			ZHD->ZHD_IDMRP  := cIDMRP
			ZHD_PERIOD := DATE()
			ZHD->( msUnlock() )
			nQTDE:=0
		ENDIF
	ENDDO
	//MSGALERT('FIM')

RETURN

	*----------------------------------------------------------------------------*
USER FUNCTION MRPALT0D()
	*----------------------------------------------------------------------------*
	Local aSizeAut    := MsAdvSize(,.F.,400)


	IF alltrim(cAlter)<>''
		//DEFINE MSDIALOG oDlg5 FROM aSizeAut[4],aSizeAut[4] TO aSizeAut[3]*3,aSizeAut[3]+aSizeAut[4]  TITLE OemToAnsi("MRP DOMEX ALTERNATIVO") OF oMainWnd PIXEL
		DEFINE MSDIALOG oDlg5 FROM aSizeAut[4],aSizeAut[4] TO aSizeAut[3]*1.2,aSizeAut[3]+aSizeAut[4]  TITLE OemToAnsi("MRP DOMEX ALTERNATIVO") OF oMainWnd PIXEL

		@ 05,10 SAY ALLTRIM(cPRODUTO)+' - '+posicione('SB1',1,xFILIAL('SB1')+cPRODUTO,'B1_DESC')  OF oDlg5 PIXEL SIZE 300,040 FONT oFontBRW4

		//oGetSC:= (MsNewGetDados():New( 025,015,095,300,/*GD_UPDATE */,/*"U_FAT002LOK()"*/  ,/*REQ_OPSD3()*/,/*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*Ffieldok*/,/*superdel*/,/*delok*/,oDlg2,aHEADSC,aCOLSSC))
		//oGetSC:oBrowse:Refresh()

		//oGetPC:= (MsNewGetDados():New( 105,015,175,300,/*GD_UPDATE*/ ,/*"U_FAT002LOK()"*/  ,/*REQ_OPSD3()*/,/*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*Ffieldok*/,/*superdel*/,/*delok*/,oDlg2,aHEADPC,aCOLSPC))
		//oGetPC:oBrowse:Refresh()

		//oGetMV:= (MsNewGetDados():New( 185,015,255,300,/*GD_UPDATE*/ ,/*"U_FAT002LOK()"*/  ,/*REQ_OPSD3()*/,/*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*Ffieldok*/,/*superdel*/,/*delok*/,oDlg2,aHEADMV,aCOLSMV))
		//oGetMV:oBrowse:Refresh()
		nLin:=35
		@ nLin,aPosGet[1,1] SAY oMSG11  VAR cMSG11   OF oDlg5 SIZE 200,035  PIXEL COLOR CLR_HBLUE FONT oFontBRW5
		@ nLin,aPosGet[1,1] SAY oMSG11B VAR cMSG11B  OF oDlg5 SIZE 200,035  PIXEL COLOR CLR_RED   FONT oFontBRW5
		@ nLin,aPosGet[1,1] SAY oMSG11C VAR cMSG11C  OF oDlg5 SIZE 200,035  PIXEL COLOR CLR_GREEN FONT oFontBRW5
		nLin:=60
		@ nLin,aPosGet[1,1] SAY oMSG21  VAR cMSG21   OF oDlg5 SIZE 200,015  PIXEL COLOR CLR_GREEN FONT oFontBRW3
		@ nLin,aPosGet[1,1] SAY oMSG21B VAR cMSG21B  OF oDlg5 SIZE 200,015  PIXEL COLOR CLR_GREEN FONT oFontBRW3

		@ nLin,aPosGet[1,1] SAY oMSG31  VAR cMSG31   OF oDlg5 SIZE 150,015  PIXEL COLOR CLR_GREEN FONT oFontBRW3
		@ nLin,aPosGet[1,1] SAY oMSG31B VAR cMSG31B  OF oDlg5 SIZE 150,015  PIXEL COLOR CLR_GREEN FONT oFontBRW3

		cPRALTER := ALLTRIM(SUBSTR(cAlter+SPACE(15),14,15))
		cPRALTER := cPRALTER+' - '+posicione('SB1',1,xFILIAL('SB1')+cPRALTER,'B1_DESC')
		@ 85,10 SAY cPRALTER OF oDlg5 PIXEL SIZE 300,040 FONT oFontBRW4 //+' - '+ALLTRIM(cDESCRI) OF oDlg5 PIXEL SIZE 300,040 FONT oFontBRW4
		nLin:=110
		@ nLin,aPosGet[1,1] SAY oMSG12  VAR cMSG12   OF oDlg5 SIZE 200,035  PIXEL COLOR CLR_HBLUE FONT oFontBRW5
		@ nLin,aPosGet[1,1] SAY oMSG12B VAR cMSG12B  OF oDlg5 SIZE 200,035  PIXEL COLOR CLR_RED   FONT oFontBRW5
		@ nLin,aPosGet[1,1] SAY oMSG12C VAR cMSG12C  OF oDlg5 SIZE 200,035  PIXEL COLOR CLR_GREEN FONT oFontBRW5
		nLin:=135
		@ nLin,aPosGet[1,1] SAY oMSG22  VAR cMSG22   OF oDlg5 SIZE 200,015  PIXEL COLOR CLR_GREEN FONT oFontBRW3
		@ nLin,aPosGet[1,1] SAY oMSG22B VAR cMSG22B  OF oDlg5 SIZE 200,015  PIXEL COLOR CLR_GREEN FONT oFontBRW3

		@ nLin,aPosGet[1,1] SAY oMSG32  VAR cMSG32   OF oDlg5 SIZE 150,015  PIXEL COLOR CLR_GREEN FONT oFontBRW3
		@ nLin,aPosGet[1,1] SAY oMSG32B VAR cMSG32B  OF oDlg5 SIZE 150,015  PIXEL COLOR CLR_GREEN FONT oFontBRW3

		//-------------------------------------------------
		nLin:=155
		@ nLin,10 SAY 'RESUMO' OF oDlg5 PIXEL SIZE 300,040 FONT oFontBRW4 //+' - '+ALLTRIM(cDESCRI) OF oDlg5 PIXEL SIZE 300,040 FONT oFontBRW4
		nLin:=175
		@ nLin,aPosGet[1,1] SAY oMSG13  VAR cMSG13   OF oDlg5 SIZE 200,035  PIXEL COLOR CLR_HBLUE FONT oFontBRW5
		@ nLin,aPosGet[1,1] SAY oMSG13B VAR cMSG13B  OF oDlg5 SIZE 200,035  PIXEL COLOR CLR_RED   FONT oFontBRW5
		@ nLin,aPosGet[1,1] SAY oMSG13C VAR cMSG13C  OF oDlg5 SIZE 200,035  PIXEL COLOR CLR_GREEN FONT oFontBRW5
		nLin:=135
		@ nLin,aPosGet[1,1] SAY oMSG23  VAR cMSG23   OF oDlg5 SIZE 200,015  PIXEL COLOR CLR_GREEN FONT oFontBRW3
		@ nLin,aPosGet[1,1] SAY oMSG23B VAR cMSG23B  OF oDlg5 SIZE 200,015  PIXEL COLOR CLR_GREEN FONT oFontBRW3

		@ nLin,aPosGet[1,1] SAY oMSG33  VAR cMSG33   OF oDlg5 SIZE 150,015  PIXEL COLOR CLR_GREEN FONT oFontBRW3
		@ nLin,aPosGet[1,1] SAY oMSG33B VAR cMSG33B  OF oDlg5 SIZE 150,015  PIXEL COLOR CLR_GREEN FONT oFontBRW3

		//-------------------------------------------------

		MRPCALC1()

		@ 220,010 BUTTON "Sld. SCs E PCs"   SIZE 040,012  ACTION U_MRPSCPCD() OF oDlg5  Pixel
		@ 220,060 BUTTON "Gerar SC Alter"   SIZE 040,012  ACTION U_MRP2SCADT()    OF oDlg5  Pixel//mlsbut

		//@ 035,220 BUTTON "SC/PC"         SIZE 040,012  ACTION U_MRPSCPCD() OF oDlg5  Pixel
		//@ 060,250 BUTTON "Gerar SC Alt"  SIZE 040,012  ACTION U_MRP2SCADT()    OF oDlg5  Pixel//mlsbut

		

		ACTIVATE MSDIALOG oDlg5  CENTERED
	ELSE
		MSGALERT('Produto: '+alltrim(cPRODUTO)+' não possui alternativo')
	ENDIF

RETURN

//--------------------------------------------------------------------------------------
STATIC FUNCTION  MRPCALC1()
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

	_nESTX  :=0
	_nSCX   :=0
	_nPCX   :=0
	_nEMPX  :=0
	_nOPX   :=0
	_nPVX   :=0
	_nPREVX :=0
	_nSAESX :=0
	_nNEC1X :=0

	_nSAESTOT :=0


	cQUERYSLD:="	SELECT ZHD_PRODUT , "
	cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QATU),0) FROM SB2010 (NOLOCK) WHERE B2_FILIAL='"+xFILIAL('SB2')+"' AND  B2_COD=ZHD_PRODUT  AND D_E_L_E_T_='' AND B2_FILIAL='"+xFILIAL('SB2')+"' ) AS  EST, "
	cQUERYSLD+="	(SELECT ISNULL(SUM(C1_QUANT-C1_QUJE),0)  FROM SC1010 (NOLOCK) WHERE C1_FILIAL='"+xFILIAL('SC1')+"' AND  C1_PRODUTO=ZHD.ZHD_PRODUT AND D_E_L_E_T_='' AND C1_RESIDUO='' AND  C1_QUANT > C1_QUJE) AS  SOL, "
	cQUERYSLD+="	(SELECT ISNULL(SUM(C7_QUANT-C7_QUJE),0)  FROM SC7010 (NOLOCK) WHERE C7_FILIAL='"+xFILIAL('SC7')+"' AND  C7_PRODUTO=ZHD.ZHD_PRODUT AND D_E_L_E_T_='' AND C7_RESIDUO='' AND  C7_QUANT > C7_QUJE) AS  PC, "
	cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QEMP),0) FROM SB2010 (NOLOCK)  WHERE B2_FILIAL='"+xFILIAL('SB2')+"' AND  B2_COD=ZHD_PRODUT  AND D_E_L_E_T_='' ) AS  EMP, "
	cQUERYSLD+="	(SELECT ISNULL(SUM(ZHD_XQTDE),0)  FROM ZHD010 (NOLOCK) WHERE ZHD_FILIAL='"+xFILIAL('ZHD')+"' AND   ZHD_TIPO IN ('06-Ordem Producao') AND ZHD_PRODUT=ZHD.ZHD_PRODUT) AS  OP, "
	cQUERYSLD+="	(SELECT ISNULL(SUM(C6_QTDVEN-C6_QTDENT),0)  FROM SC6010 (NOLOCK) WHERE C6_FILIAL='"+xFILIAL('SC6')+"' AND  (C6_QTDVEN-C6_QTDENT)>0 AND D_E_L_E_T_='' AND C6_PRODUTO=ZHD.ZHD_PRODUT AND C6_BLQ<>'R')  AS  PV, "
	cQUERYSLD+="	(SELECT ISNULL(SUM(ZHD_XQTDE),0)  FROM ZHD010 (NOLOCK) WHERE ZHD_FILIAL='"+xFILIAL('ZHD')+"' AND  ZHD_TIPO IN ('09-Previsao Venda')  AND ZHD_PRODUT=ZHD.ZHD_PRODUT) AS  PREV, "
	cQUERYSLD+="	(SELECT ISNULL(SUM(ZHD_XQTDE),0)  FROM ZHD010 (NOLOCK) WHERE ZHD_FILIAL='"+xFILIAL('ZHD')+"' AND  ZHD_TIPO IN ('08-Saida Estrutura') AND ZHD_PRODUT=ZHD.ZHD_PRODUT) AS  SAES, "
	cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QATU),0) FROM SB2010 (NOLOCK) WHERE B2_FILIAL='"+xFILIAL('SB2')+"' AND  B2_COD=ZHD_PRODUT  AND D_E_L_E_T_='') + "
	cQUERYSLD+="	(SELECT ISNULL(SUM(C1_QUANT-C1_QUJE),0)  FROM SC1010 (NOLOCK) WHERE C1_FILIAL='"+xFILIAL('SC1')+"' AND  C1_PRODUTO=ZHD.ZHD_PRODUT AND D_E_L_E_T_='' AND C1_RESIDUO='' AND C1_QUANT > C1_QUJE) + "
	cQUERYSLD+="	(SELECT ISNULL(SUM(C7_QUANT-C7_QUJE),0)  FROM SC7010 (NOLOCK) WHERE C7_FILIAL='"+xFILIAL('SC7')+"' AND  C7_PRODUTO=ZHD.ZHD_PRODUT AND D_E_L_E_T_='' AND C7_RESIDUO='' AND C7_QUANT > C7_QUJE ) - "
	cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QEMP),0) FROM SB2010 (NOLOCK)  WHERE B2_FILIAL='"+xFILIAL('SB2')+"' AND  B2_COD=ZHD_PRODUT  AND D_E_L_E_T_='' ) + "
	cQUERYSLD+="	(SELECT ISNULL(SUM(ZHD_XQTDE),0)  FROM ZHD010 (NOLOCK) WHERE ZHD_FILIAL='"+xFILIAL('ZHD')+"' AND  ZHD_TIPO IN ('06-Ordem Producao') AND ZHD_PRODUT=ZHD.ZHD_PRODUT) - "
	cQUERYSLD+="	(SELECT ISNULL(SUM(C6_QTDVEN-C6_QTDENT),0)  FROM SC6010 (NOLOCK) WHERE C6_FILIAL='"+xFILIAL('SC6')+"' AND  (C6_QTDVEN-C6_QTDENT)>0 AND D_E_L_E_T_='' AND C6_PRODUTO=ZHD.ZHD_PRODUT  AND C6_BLQ<>'R') - "
	cQUERYSLD+="	(SELECT ISNULL(SUM(ZHD_XQTDE),0)  FROM ZHD010 (NOLOCK) WHERE ZHD_FILIAL='"+xFILIAL('ZHD')+"' AND  ZHD_TIPO IN ('09-Previsao Venda')  AND ZHD_PRODUT=ZHD.ZHD_PRODUT) AS FINAL "// -       "

	cQUERYSLD+="	FROM ZHD010 (NOLOCK) ZHD "
	cQUERYSLD+="	WHERE ZHD_PRODUT='"+ALLTRIM(cPRODUTO)+"'  AND ZHD.D_E_L_E_T_='' "
	cQUERYSLD+="	GROUP BY ZHD_PRODUT "
	cQUERYSLD+="	ORDER BY ZHD_PRODUT "

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

	_nESTX  :=_nEST
	_nSCX   :=_nSC
	_nPCX   :=_nPC
	_nEMPX  :=_nEMP
	_nOPX   :=_nOP
	_nPVX   :=_nPV
	_nPREVX :=_nPREV
	_nSAESX :=_nSAES
	_nNEC1X :=_nNEC1

	TRS->(DBCLOSEAREA())   //_nEMP-_nSAES

	//nENTRADA:=nTotEnt
	//nSAIDA  :=nTotSai
	//nSALDOF :=(nSALDOI+nTotEnt)-nTotSai

	//nWON   :=nTWON
	//nBEST  :=nTBEST
	//nIN    :=nTIN

	IF _nNEC1<0
		cMSG11  :=''
		cMSG11B :='Saldo SC+PC Menor que Necessidade: '+cEOL   //+TRANSFORM(_nNEC1,"@E 999,999.99")
		cMSG11B +='+EST:' +TRANSFORM(_nEST ,"@E 9,999,999.99") +' +SC: '+TRANSFORM(_nSC  ,"@E 9,999,999.99")+' +PC :'+TRANSFORM(_nPC  ,"@E 9,999,999.99")+cEOL
		cMSG11B +='-EMP:' +TRANSFORM(_nEMP ,"@E 9,999,999.99") +' -PV: '+TRANSFORM(_nPV  ,"@E 9,999,999.99")+' -PRV:'+TRANSFORM(_nPREV,"@E 9,999,999.99")+cEOL
		IF _nSAES-_nEMP>0
			cMSG11B +='=SLD:' +TRANSFORM(_nNEC1,"@E 9,999,999.99") +'      Saida Estrutura:' +TRANSFORM(_nSAES-_nEMP,"@E 9,999,999.99")
		ELSE
			cMSG11B +='=SLD:' +TRANSFORM(_nNEC1,"@E 9,999,999.99")
		ENDIF
		cMSG11C :=''
	ELSE
		cMSG11 :='Saldo SC+PC Maior que Necessidade: '+cEOL   //+TRANSFORM(_nNEC1,"@E 999,999.99")
		cMSG11b:=''
		cMSG11C :=''

		cMSG11 +='+EST:' +TRANSFORM(_nEST ,"@E 9,999,999.99") +' +SC: '+TRANSFORM(_nSC,"@E 9,999,999.99")+' +PC :'+TRANSFORM(_nPC  ,"@E 9,999,999.99")+cEOL
		cMSG11 +='-EMP:' +TRANSFORM(_nEMP ,"@E 9,999,999.99") +' -PV: '+TRANSFORM(_nPV,"@E 9,999,999.99")+' -PRV:'+TRANSFORM(_nPREV,"@E 9,999,999.99")+cEOL
		IF _nSAES-_nEMP>0
			cMSG11 +='=SLD:' +TRANSFORM(_nNEC1,"@E 9,999,999.99") +'      Saida Estrutura:' +TRANSFORM(_nSAES-_nEMP,"@E 9,999,999.99")
			_nSAESTOT:=_nSAESTOT+(_nSAES-_nEMP)
		ELSE
			cMSG11 +='=SLD:' +TRANSFORM(_nNEC1,"@E 9,999,999.99")
		ENDIF

	ENDIF
	//IF nSALDOF>=0
	//	cMSG11 :=''
	//	cMSG11b:=''
	//	cMSG11C:='Item com Saldo'
	//ENDIF
	//MLS
	//cQuerySI := " SELECT  * "
	//cQuerySI += " FROM ZHD010 (NOLOCK)  "
	//cQuerySI += " WHERE ZHD_FILIAL = '"+xFILIAL('ZHD')+"' AND ZHD_IDMRP='"+ALLTRIM(oGetNEC:ACOLS[nLIN][06])+"' AND ZHD010.D_E_L_E_T_='' "

	//TCQUERY cQuerySI NEW ALIAS "TR2"
	//TR2->( dbGoTop() )
	//IF !EMPTY(TR2->ZHD_NUMSC)
	//	cMSG21 :='SC: '+TR2->ZHD_NUMSC+' Qtde: '+Transform(TR2->ZHD_QTDSC,"@E 9,999,999.99")+" Data: "+SUBSTR(TR2->ZHD_DATASC,7,2)+'/'+SUBSTR(TR2->ZHD_DATASC,5,2)+'/'+SUBSTR(TR2->ZHD_DATASC,1,4)
	//	cMSG21b:=''
	//ELSE
	//	cMSG21 :=''
	//	cMSG21b:=''
	//ENDIF
	//TR2->(DBCLOSEAREA())
	oMSG11 :refresh()
	oMSG11b:refresh()
	oMSG11c:refresh()

	oMSG21 :refresh()
	oMSG21b:refresh()

	*-----------------------------------------------------------------------------------------
	//------------------------------------------MLS QUERY alternativo
	_nEST  :=0
	_nSC   :=0
	_nPC   :=0
	_nEMP  :=0
	_nOP   :=0
	_nPV   :=0
	_nPREV :=0
	_nSAES :=0
	_nNEC1 :=0
	//ALTERNATIVO: '
	cAlter :=cAlter+SPACE(15)
	cCODALT :=SUBSTR(cAlter,14,15)

	cQUERYSLD:="	SELECT ZHD_PRODUT , "
	cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QATU),0) FROM SB2010 (NOLOCK) WHERE B2_FILIAL='"+xFILIAL('SB2')+"' AND  B2_COD=ZHD_PRODUT  AND D_E_L_E_T_='' AND B2_FILIAL='"+xFILIAL('SB2')+"' ) AS  EST, "
	cQUERYSLD+="	(SELECT ISNULL(SUM(C1_QUANT-C1_QUJE),0)  FROM SC1010 (NOLOCK) WHERE C1_FILIAL='"+xFILIAL('SC1')+"' AND  C1_PRODUTO=ZHD.ZHD_PRODUT AND D_E_L_E_T_='' AND C1_RESIDUO='' AND  C1_QUANT > C1_QUJE) AS  SOL, "
	cQUERYSLD+="	(SELECT ISNULL(SUM(C7_QUANT-C7_QUJE),0)  FROM SC7010 (NOLOCK) WHERE C7_FILIAL='"+xFILIAL('SC7')+"' AND  C7_PRODUTO=ZHD.ZHD_PRODUT AND D_E_L_E_T_='' AND C7_RESIDUO='' AND  C7_QUANT > C7_QUJE) AS  PC, "
	cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QEMP),0) FROM SB2010 (NOLOCK)  WHERE B2_FILIAL='"+xFILIAL('SB2')+"' AND  B2_COD=ZHD_PRODUT  AND D_E_L_E_T_='' ) AS  EMP, "
	cQUERYSLD+="	(SELECT ISNULL(SUM(ZHD_XQTDE),0)  FROM ZHD010 (NOLOCK) WHERE ZHD_FILIAL='"+xFILIAL('ZHD')+"' AND   ZHD_TIPO IN ('06-Ordem Producao') AND ZHD_PRODUT=ZHD.ZHD_PRODUT) AS  OP, "
	cQUERYSLD+="	(SELECT ISNULL(SUM(C6_QTDVEN-C6_QTDENT),0)  FROM SC6010 (NOLOCK) WHERE C6_FILIAL='"+xFILIAL('SC6')+"' AND  (C6_QTDVEN-C6_QTDENT)>0 AND D_E_L_E_T_='' AND C6_PRODUTO=ZHD.ZHD_PRODUT AND C6_BLQ<>'R')  AS  PV, "
	cQUERYSLD+="	(SELECT ISNULL(SUM(ZHD_XQTDE),0)  FROM ZHD010 (NOLOCK) WHERE ZHD_FILIAL='"+xFILIAL('ZHD')+"' AND  ZHD_TIPO IN ('09-Previsao Venda')  AND ZHD_PRODUT=ZHD.ZHD_PRODUT) AS  PREV, "
	cQUERYSLD+="	(SELECT ISNULL(SUM(ZHD_XQTDE),0)  FROM ZHD010 (NOLOCK) WHERE ZHD_FILIAL='"+xFILIAL('ZHD')+"' AND  ZHD_TIPO IN ('08-Saida Estrutura') AND ZHD_PRODUT=ZHD.ZHD_PRODUT) AS  SAES, "
	cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QATU),0) FROM SB2010 (NOLOCK) WHERE B2_FILIAL='"+xFILIAL('SB2')+"' AND  B2_COD=ZHD_PRODUT  AND D_E_L_E_T_='') + "
	cQUERYSLD+="	(SELECT ISNULL(SUM(C1_QUANT-C1_QUJE),0)  FROM SC1010 (NOLOCK) WHERE C1_FILIAL='"+xFILIAL('SC1')+"' AND  C1_PRODUTO=ZHD.ZHD_PRODUT AND D_E_L_E_T_='' AND C1_RESIDUO='' AND C1_QUANT > C1_QUJE) + "
	cQUERYSLD+="	(SELECT ISNULL(SUM(C7_QUANT-C7_QUJE),0)  FROM SC7010 (NOLOCK) WHERE C7_FILIAL='"+xFILIAL('SC7')+"' AND  C7_PRODUTO=ZHD.ZHD_PRODUT AND D_E_L_E_T_='' AND C7_RESIDUO='' AND C7_QUANT > C7_QUJE ) - "
	cQUERYSLD+="	(SELECT ISNULL(SUM(B2_QEMP),0) FROM SB2010 (NOLOCK)  WHERE B2_FILIAL='"+xFILIAL('SB2')+"' AND  B2_COD=ZHD_PRODUT  AND D_E_L_E_T_='' ) + "
	cQUERYSLD+="	(SELECT ISNULL(SUM(ZHD_XQTDE),0)  FROM ZHD010 (NOLOCK) WHERE ZHD_FILIAL='"+xFILIAL('ZHD')+"' AND  ZHD_TIPO IN ('06-Ordem Producao') AND ZHD_PRODUT=ZHD.ZHD_PRODUT) - "
	cQUERYSLD+="	(SELECT ISNULL(SUM(C6_QTDVEN-C6_QTDENT),0)  FROM SC6010 (NOLOCK) WHERE C6_FILIAL='"+xFILIAL('SC6')+"' AND  (C6_QTDVEN-C6_QTDENT)>0 AND D_E_L_E_T_='' AND C6_PRODUTO=ZHD.ZHD_PRODUT  AND C6_BLQ<>'R') - "
	cQUERYSLD+="	(SELECT ISNULL(SUM(ZHD_XQTDE),0)  FROM ZHD010 (NOLOCK) WHERE ZHD_FILIAL='"+xFILIAL('ZHD')+"' AND  ZHD_TIPO IN ('09-Previsao Venda')  AND ZHD_PRODUT=ZHD.ZHD_PRODUT) AS FINAL "// -       "

	cQUERYSLD+="	FROM ZHD010 (NOLOCK) ZHD "
	cQUERYSLD+="	WHERE ZHD_PRODUT='"+ALLTRIM(cCODALT)+"'  AND ZHD.D_E_L_E_T_='' "
	cQUERYSLD+="	GROUP BY ZHD_PRODUT "
	cQUERYSLD+="	ORDER BY ZHD_PRODUT "

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

	_nESTX  :=_nESTX  + _nEST
	_nSCX   :=_nSCX   + _nSC
	_nPCX   :=_nPCX   + _nPC
	_nEMPX  :=_nEMPX  + _nEMP
	_nOPX   :=_nOPX   + _nOP
	_nPVX   :=_nPVX   + _nPV
	_nPREVX :=_nPREVX + _nPREV
	_nSAESX :=_nSAESX + _nSAES
	_nNEC1X :=_nNEC1X + _nNEC1
	TRS->(DBCLOSEAREA())   //_nEMP-_nSAES

	IF _nNEC1<0
		cMSG12  :=''
		cMSG12B :='Saldo SC+PC Menor que Necessidade: '+cEOL   //+TRANSFORM(_nNEC1,"@E 999,999.99")
		cMSG12B +='+EST:' +TRANSFORM(_nEST ,"@E 9,999,999.99") +' +SC: '+TRANSFORM(_nSC  ,"@E 9,999,999.99")+' +PC :'+TRANSFORM(_nPC  ,"@E 9,999,999.99")+cEOL
		cMSG12B +='-EMP:' +TRANSFORM(_nEMP ,"@E 9,999,999.99") +' -PV: '+TRANSFORM(_nPV  ,"@E 9,999,999.99")+' -PRV:'+TRANSFORM(_nPREV,"@E 9,999,999.99")+cEOL
		IF _nSAES-_nEMP>0
			cMSG12B +='=SLD:' +TRANSFORM(_nNEC1,"@E 9,999,999.99") +'      Saida Estrutura:' +TRANSFORM(_nSAES-_nEMP,"@E 9,999,999.99")
		ELSE
			cMSG12B +='=SLD:' +TRANSFORM(_nNEC1,"@E 9,999,999.99")
		ENDIF
		cMSG12C :=''
	ELSE
		cMSG12 :='Saldo SC+PC Maior que Necessidade: '+cEOL   //+TRANSFORM(_nNEC1,"@E 999,999.99")
		cMSG12b:=''
		cMSG12C :=''

		cMSG12 +='+EST:' +TRANSFORM(_nEST ,"@E 9,999,999.99") +' +SC: '+TRANSFORM(_nSC,"@E 9,999,999.99")+' +PC :'+TRANSFORM(_nPC  ,"@E 9,999,999.99")+cEOL
		cMSG12 +='-EMP:' +TRANSFORM(_nEMP ,"@E 9,999,999.99") +' -PV: '+TRANSFORM(_nPV,"@E 9,999,999.99")+' -PRV:'+TRANSFORM(_nPREV,"@E 9,999,999.99")+cEOL
		IF _nSAES-_nEMP>0
			cMSG12 +='=SLD:' +TRANSFORM(_nNEC1,"@E 9,999,999.99") +'      Saida Estrutura:' +TRANSFORM(_nSAES-_nEMP,"@E 9,999,999.99")
			_nSAESTOT:=_nSAESTOT+(_nSAES-_nEMP)
		ELSE
			cMSG12 +='=SLD:' +TRANSFORM(_nNEC1,"@E 9,999,999.99")
		ENDIF

	ENDIF
	//IF nSALDOF>=0
	//	cMSG11 :=''
	//	cMSG11b:=''
	//	cMSG11C:='Item com Saldo'
	//ENDIF
	//MLS
	//cQuerySI := " SELECT  * "
	//cQuerySI += " FROM ZHD010 (NOLOCK)  "
	//cQuerySI += " WHERE ZHD_FILIAL = '"+xFILIAL('ZHD')+"' AND ZHD_IDMRP='"+ALLTRIM(oGetNEC:ACOLS[nLIN][06])+"' AND ZHD010.D_E_L_E_T_='' "

	//TCQUERY cQuerySI NEW ALIAS "TR2"
	//TR2->( dbGoTop() )
	//IF !EMPTY(TR2->ZHD_NUMSC)
	//	cMSG22 :='SC: '+TR2->ZHD_NUMSC+' Qtde: '+Transform(TR2->ZHD_QTDSC,"@E 9,999,999.99")+" Data: "+SUBSTR(TR2->ZHD_DATASC,7,2)+'/'+SUBSTR(TR2->ZHD_DATASC,5,2)+'/'+SUBSTR(TR2->ZHD_DATASC,1,4)
	//	cMSG22b:=''
	//ELSE
	//	cMSG22 :=''
	//	cMSG22b:=''
	//ENDIF
	//TR2->(DBCLOSEAREA())
	oMSG12 :refresh()
	oMSG12b:refresh()
	oMSG12c:refresh()

	oMSG22 :refresh()
	oMSG22b:refresh()

	//-------------------RESUMO---------------------------------
	IF _nNEC1X<0
		cMSG13  :=''
		cMSG13B :='Saldo SC+PC Menor que Necessidade: '+cEOL   //+TRANSFORM(_nNEC1,"@E 999,999.99")
		cMSG13B +='+EST:' +TRANSFORM(_nESTX ,"@E 9,999,999.99") +' +SC: '+TRANSFORM(_nSCX  ,"@E 9,999,999.99")+' +PC :'+TRANSFORM(_nPCX  ,"@E 9,999,999.99")+cEOL
		cMSG13B +='-EMP:' +TRANSFORM(_nEMPX ,"@E 9,999,999.99") +' -PV: '+TRANSFORM(_nPVX  ,"@E 9,999,999.99")+' -PRV:'+TRANSFORM(_nPREVX,"@E 9,999,999.99")+cEOL
		IF _nSAESX-_nEMPX>0
			cMSG13B +='=SLD:' +TRANSFORM(_nNEC1X,"@E 9,999,999.99") +'      Saida Estrutura:' +TRANSFORM(_nSAESX-_nEMPX,"@E 9,999,999.99")
		ELSE
			cMSG13B +='=SLD:' +TRANSFORM(_nNEC1X,"@E 9,999,999.99")
		ENDIF
		cMSG13C :=''
	ELSE
		cMSG13 :='Saldo SC+PC Maior que Necessidade: '+cEOL   //+TRANSFORM(_nNEC1,"@E 999,999.99")
		cMSG13b:=''
		cMSG13C :=''

		cMSG13 +='+EST:' +TRANSFORM(_nESTX ,"@E 9,999,999.99") +' +SC: '+TRANSFORM(_nSCX,"@E 9,999,999.99")+' +PC :'+TRANSFORM(_nPCX  ,"@E 9,999,999.99")+cEOL
		cMSG13 +='-EMP:' +TRANSFORM(_nEMPX ,"@E 9,999,999.99") +' -PV: '+TRANSFORM(_nPVX,"@E 9,999,999.99")+' -PRV:'+TRANSFORM(_nPREVX,"@E 9,999,999.99")+cEOL
		IF _nSAESX-_nEMPX>0
			cMSG13 +='=SLD:' +TRANSFORM(_nNEC1X,"@E 9,999,999.99") +'      Saida Estrutura:' +TRANSFORM(_nSAESTOT,"@E 9,999,999.99")
		ELSE
			cMSG13 +='=SLD:' +TRANSFORM(_nNEC1X,"@E 9,999,999.99")
		ENDIF

	ENDIF
	//IF nSALDOF>=0
	//	cMSG11 :=''
	//	cMSG11b:=''
	//	cMSG11C:='Item com Saldo'
	//ENDIF
	//MLS
	//cQuerySI := " SELECT  * "
	//cQuerySI += " FROM ZHD010 (NOLOCK)  "
	//cQuerySI += " WHERE ZHD_FILIAL = '"+xFILIAL('ZHD')+"' AND ZHD_IDMRP='"+ALLTRIM(oGetNEC:ACOLS[nLIN][06])+"' AND ZHD010.D_E_L_E_T_='' "

	//TCQUERY cQuerySI NEW ALIAS "TR2"
	//TR2->( dbGoTop() )
	//IF !EMPTY(TR2->ZHD_NUMSC)
	//	cMSG22 :='SC: '+TR2->ZHD_NUMSC+' Qtde: '+Transform(TR2->ZHD_QTDSC,"@E 9,999,999.99")+" Data: "+SUBSTR(TR2->ZHD_DATASC,7,2)+'/'+SUBSTR(TR2->ZHD_DATASC,5,2)+'/'+SUBSTR(TR2->ZHD_DATASC,1,4)
	//	cMSG22b:=''
	//ELSE
	//	cMSG22 :=''
	//	cMSG22b:=''
	//ENDIF
	//TR2->(DBCLOSEAREA())
	oMSG13 :refresh()
	oMSG13b:refresh()
	oMSG13c:refresh()

	oMSG23 :refresh()
	oMSG23b:refresh()

RETURN


USER FUNCTION MRPSCPCD()
	Local aSizeAut    := MsAdvSize(,.F.,400)

	Private aColsSC1   := {}
	Private aColsPC1   := {}
	Private aColsMV1   := {}

	Private aColsSC2   := {}
	Private aColsPC2   := {}
	Private aColsMV2   := {}

	Private aHeadSC1  := {}
	Private aHeadPC1  := {}
	Private aHeadMV1  := {}

	Private aHeadSC2  := {}
	Private aHeadPC2  := {}
	Private aHeadMV2  := {}

	nSCA1    :=0
	nPCA1    :=0
	nQTDMV1  :=0

	nSCA2    :=0
	nPCA2    :=0
	nQTDMV2  :=0
//cPRODUTO
	cPRALTER := ALLTRIM(SUBSTR(cAlter+SPACE(15),14,15))

//SC1
	AADD(aHeadSC1,   {    "Numero SC" ,   "D_NUMSC"       ,""                         ,20,0,""  ,"","C","","","","",".F."})//01
	AADD(aHeadSC1,   {    "Data"      ,   "D_DATA"        ,""                         ,15,0,""  ,"","C","","","","",".F"}) //02
	AADD(aHeadSC1,   {    "Saldo"     ,   "D_SALDO"       ,"@E 999,999,999,999.99"    ,12,5,""  ,"","N","","","","",".F."})//03
//PC1
	AADD(aHeadPC1,   {    "Numero PC" ,   "D_NUMPC"       ,""                         ,20,0,""  ,"","C","","","","",".F."})//01
	AADD(aHeadPC1,   {    "Data"      ,   "D_DATA"        ,""                         ,15,0,""  ,"","C","","","","",".F"}) //02
	AADD(aHeadPC1,   {    "Saldo"     ,   "D_SALDO"       ,"@E 999,999,999,999.99"    ,12,5,""  ,"","N","","","","",".F."})//03
//MV MOVIMENTO ENTRADA1
	AADD(aHeadMV1,   {    "Movimento" ,   "D_NFE"         ,""                         ,20,0,""  ,"","C","","","","",".F."})//01
	AADD(aHeadMV1,   {    "Numero PC" ,   "D_NUMPC"       ,""                         ,20,0,""  ,"","C","","","","",".F."})//02
	AADD(aHeadMV1,   {    "Data"      ,   "D_DATA"        ,""                         ,15,0,""  ,"","C","","","","",".F"}) //03
	AADD(aHeadMV1,   {    "Qtde"      ,   "D_SALDO"       ,"@E 999,999,999,999.99"    ,12,5,""  ,"","N","","","","",".F."})//04

//SC2
	AADD(aHeadSC2,   {    "Numero SC" ,   "D_NUMSC"       ,""                         ,20,0,""  ,"","C","","","","",".F."})//01
	AADD(aHeadSC2,   {    "Data"      ,   "D_DATA"        ,""                         ,15,0,""  ,"","C","","","","",".F"}) //02
	AADD(aHeadSC2,   {    "Saldo"     ,   "D_SALDO"       ,"@E 999,999,999,999.99"    ,12,5,""  ,"","N","","","","",".F."})//03
//PC2
	AADD(aHeadPC2,   {    "Numero PC" ,   "D_NUMPC"       ,""                         ,20,0,""  ,"","C","","","","",".F."})//01
	AADD(aHeadPC2,   {    "Data"      ,   "D_DATA"        ,""                         ,15,0,""  ,"","C","","","","",".F"}) //02
	AADD(aHeadPC2,   {    "Saldo"     ,   "D_SALDO"       ,"@E 999,999,999,999.99"    ,12,5,""  ,"","N","","","","",".F."})//03
//MV MOVIMENTO ENTRADA2
	AADD(aHeadMV2,   {    "Movimento" ,   "D_NFE"         ,""                         ,20,0,""  ,"","C","","","","",".F."})//01
	AADD(aHeadMV2,   {    "Numero PC" ,   "D_NUMPC"       ,""                         ,20,0,""  ,"","C","","","","",".F."})//02
	AADD(aHeadMV2,   {    "Data"      ,   "D_DATA"        ,""                         ,15,0,""  ,"","C","","","","",".F"}) //03
	AADD(aHeadMV2,   {    "Qtde"      ,   "D_SALDO"       ,"@E 999,999,999,999.99"    ,12,5,""  ,"","N","","","","",".F."})//04

//------------------------------------------------------------------------------
//------------------------------------------SCs1
	nSCA1     :=0
	aColsSC1 :={}

	cQUERYSC := " SELECT C1_NUM,C1_DATPRF,C1_QUANT-C1_QUJE AS C1_SALDO  "
	cQUERYSC += " FROM SC1010 (NOLOCK)               "
	cQUERYSC += " WHERE C1_FILIAL = '"+xFILIAL('SC1')+"' AND                     "
	cQUERYSC += " C1_QUANT > C1_QUJE AND     "
	cQUERYSC += " C1_QUJE  >=0       AND     "
	cQUERYSC += " C1_RESIDUO=''      AND     "
	cQUERYSC += " C1_PRODUTO='"+cPRODUTO+"' AND "
	cQUERYSC += " D_E_L_E_T_=''                  "
	cQUERYSC += " ORDER BY C1_DATPRF "

	TCQUERY cQUERYSC NEW ALIAS "TRSC"
	TRSC->( dbGoTop() )

	DO WHILE !TRSC->(EOF())
		AADD(aColsSC1,{TRSC->C1_NUM,;
			substr(TRSC->C1_DATPRF,7,2)+'/'+substr(TRSC->C1_DATPRF,5,2)+'/'+substr(TRSC->C1_DATPRF,1,4),;
			TRSC->C1_SALDO,;
			.F.})//.f. POSICAO 8Flag de Delecao]

		nSCA1 +=TRSC->C1_SALDO
		TRSC->(DBSKIP())
	ENDDO
	TRSC->(DBCLOSEAREA())

	//------------------------------------------PCs1
	nPCA1    :=0
	aColsPC1 :={}

	cQUERYPC := " SELECT C7_NUM,C7_DATPRF,C7_QUANT-C7_QUJE AS C7_SALDO "
	cQUERYPC += " FROM SC7010 (NOLOCK)               "
	cQUERYPC += " WHERE C7_FILIAL = '"+xFILIAL('SC1')+"' AND                      "
	cQUERYPC += " C7_QUANT > C7_QUJE AND     "
	cQUERYPC += " C7_QUJE  >=0       AND     "
	cQUERYPC += " C7_RESIDUO=''      AND     "
	cQUERYPC += " C7_PRODUTO='"+cPRODUTO+"' AND  "
	cQUERYPC += " D_E_L_E_T_=''           "
	cQUERYPC += " ORDER BY C7_DATPRF "

	TCQUERY cQUERYPC NEW ALIAS "TRPC"
	TRPC->( dbGoTop() )

	DO WHILE !TRPC->(EOF())
		AADD(aColsPC1,{TRPC->C7_NUM,;
			substr(TRPC->C7_DATPRF,7,2)+'/'+substr(TRPC->C7_DATPRF,5,2)+'/'+substr(TRPC->C7_DATPRF,1,4),;
			TRPC->C7_SALDO,;
			.F.})//.f. POSICAO 8Flag de Delecao]

		nPCA1 +=TRPC->C7_SALDO
		TRPC->(DBSKIP())
	ENDDO
	TRPC->(DBCLOSEAREA())

	//------------------------------------------MV MOVIMENTO ENTRADA 1
	aColsMV1 :={}

	cQUERYMV := " SELECT D1_DOC,D1_DTDIGIT,D1_EMISSAO,D1_QUANT ,D1_PEDIDO+'/'+D1_ITEMPC AS D1_PC "
	cQUERYMV += " 	 FROM SD1010 (NOLOCK) D1,SF4010 (NOLOCK) F4 "
	cQUERYMV += " WHERE F4_CODIGO=D1_TES AND F4_FILIAL = '"+xFILIAL('SF4')+"' "
	cQUERYMV += "       AND F4_ESTOQUE='S'  "
	cQUERYMV += "       AND D1_DTDIGIT='"+DTOS(DATE())+"'  "
	cQUERYMV += "       AND D1_COD='"+cPRODUTO+"' "
	cQUERYMV += "       AND F4.D_E_L_E_T_='' "
	cQUERYMV += "       AND D1.D_E_L_E_T_='' "
	cQUERYMV += "       ORDER BY D1_DOC  "

	TCQUERY cQUERYMV NEW ALIAS "TRMV"
	TRMV->( dbGoTop() )

	DO WHILE !TRMV->(EOF())
		AADD(aColsMV1,{'NFe '+TRMV->D1_DOC,;
			TRMV->D1_PC,;
			substr(TRMV->D1_DTDIGIT,7,2)+'/'+substr(TRMV->D1_DTDIGIT,5,2)+'/'+substr(TRMV->D1_DTDIGIT,1,4),;
			TRMV->D1_QUANT,;
			.F.})//.f. POSICAO 8Flag de Delecao]

		TRMV->(DBSKIP())
	ENDDO
	TRMV->(DBCLOSEAREA())
	*---------------------------------------------------------------------
	cQUERYMV2 := "	  select * from SD3010 (NOLOCK) "
	cQUERYMV2 += "   where D3_FILIAL = '"+xFILIAL('SD3')+"' AND D3_COD='"+cPRODUTO+"' "
	cQUERYMV2 += "   and D3_EMISSAO='"+DTOS(DATE())+"'  "
	cQUERYMV2 += "   AND D_E_L_E_T_='' "
	cQUERYMV2 += "   AND D3_ESTORNO='' "
	cQUERYMV2 += "   ORDER BY D3_CF "

	TCQUERY cQUERYMV2 NEW ALIAS "TRMV"
	TRMV->( dbGoTop() )
	nQTDMV1 :=0
	DO WHILE !TRMV->(EOF())
		IF TRMV->D3_TM<='500'
			nQTDMV1 :=nQTDMV1 +TRMV->D3_QUANT
		ELSE
			nQTDMV1 :=nQTDMV1 -TRMV->D3_QUANT
		ENDIF
		TRMV->(DBSKIP())
	ENDDO
	IF nQTDMV1<>0
		AADD(aColsMV1,{'Mov.Int',;
			'',;
			substr(TRMV->D3_EMISSAO,7,2)+'/'+substr(TRMV->D3_EMISSAO,5,2)+'/'+substr(TRMV->D3_EMISSAO,1,4),;
			nQTDMV1,;
			.F.})//.f. POSICAO 8Flag de Delecao]
	ENDIF
	TRMV->(DBCLOSEAREA())

//------------------------------------------------------------------------------
//------------------------------------------SCs2
	nSCA2     :=0
	aColsSC2 :={}

	cQUERYSC := " SELECT C1_NUM,C1_DATPRF,C1_QUANT-C1_QUJE AS C1_SALDO  "
	cQUERYSC += " FROM SC1010 (NOLOCK)               "
	cQUERYSC += " WHERE C1_FILIAL = '"+xFILIAL('SC1')+"' AND                     "
	cQUERYSC += " C1_QUANT > C1_QUJE AND     "
	cQUERYSC += " C1_QUJE  >=0       AND     "
	cQUERYSC += " C1_RESIDUO=''      AND     "
	cQUERYSC += " C1_PRODUTO='"+cPRALTER+"' AND "
	cQUERYSC += " D_E_L_E_T_=''                  "
	cQUERYSC += " ORDER BY C1_DATPRF "

	TCQUERY cQUERYSC NEW ALIAS "TRSC"
	TRSC->( dbGoTop() )

	DO WHILE !TRSC->(EOF())
		AADD(aColsSC2,{TRSC->C1_NUM,;
			substr(TRSC->C1_DATPRF,7,2)+'/'+substr(TRSC->C1_DATPRF,5,2)+'/'+substr(TRSC->C1_DATPRF,1,4),;
			TRSC->C1_SALDO,;
			.F.})//.f. POSICAO 8Flag de Delecao]

		nSCA2 +=TRSC->C1_SALDO
		TRSC->(DBSKIP())
	ENDDO
	TRSC->(DBCLOSEAREA())

	//------------------------------------------PCs2
	nPCA2    :=0
	aColsPC2 :={}

	cQUERYPC := " SELECT C7_NUM,C7_DATPRF,C7_QUANT-C7_QUJE AS C7_SALDO "
	cQUERYPC += " FROM SC7010 (NOLOCK)               "
	cQUERYPC += " WHERE C7_FILIAL = '"+xFILIAL('SC1')+"' AND                      "
	cQUERYPC += " C7_QUANT > C7_QUJE AND     "
	cQUERYPC += " C7_QUJE  >=0       AND     "
	cQUERYPC += " C7_RESIDUO=''      AND     "
	cQUERYPC += " C7_PRODUTO='"+cPRALTER+"' AND  "
	cQUERYPC += " D_E_L_E_T_=''           "
	cQUERYPC += " ORDER BY C7_DATPRF "

	TCQUERY cQUERYPC NEW ALIAS "TRPC"
	TRPC->( dbGoTop() )

	DO WHILE !TRPC->(EOF())
		AADD(aColsPC2,{TRPC->C7_NUM,;
			substr(TRPC->C7_DATPRF,7,2)+'/'+substr(TRPC->C7_DATPRF,5,2)+'/'+substr(TRPC->C7_DATPRF,1,4),;
			TRPC->C7_SALDO,;
			.F.})//.f. POSICAO 8Flag de Delecao]

		nPCA2 +=TRPC->C7_SALDO
		TRPC->(DBSKIP())
	ENDDO
	TRPC->(DBCLOSEAREA())

	//------------------------------------------MV MOVIMENTO ENTRADA 2
	aColsMV2 :={}

	cQUERYMV := " SELECT D1_DOC,D1_DTDIGIT,D1_EMISSAO,D1_QUANT ,D1_PEDIDO+'/'+D1_ITEMPC AS D1_PC "
	cQUERYMV += " 	 FROM SD1010 (NOLOCK) D1,SF4010 (NOLOCK) F4 "
	cQUERYMV += " WHERE F4_CODIGO=D1_TES AND F4_FILIAL = '"+xFILIAL('SF4')+"' "
	cQUERYMV += "       AND F4_ESTOQUE='S'  "
	cQUERYMV += "       AND D1_DTDIGIT='"+DTOS(DATE())+"'  "
	cQUERYMV += "       AND D1_COD='"+cPRALTER+"' "
	cQUERYMV += "       AND F4.D_E_L_E_T_='' "
	cQUERYMV += "       AND D1.D_E_L_E_T_='' "
	cQUERYMV += "       ORDER BY D1_DOC  "

	TCQUERY cQUERYMV NEW ALIAS "TRMV"
	TRMV->( dbGoTop() )

	DO WHILE !TRMV->(EOF())
		AADD(aColsMV2,{'NFe '+TRMV->D1_DOC,;
			TRMV->D1_PC,;
			substr(TRMV->D1_DTDIGIT,7,2)+'/'+substr(TRMV->D1_DTDIGIT,5,2)+'/'+substr(TRMV->D1_DTDIGIT,1,4),;
			TRMV->D1_QUANT,;
			.F.})//.f. POSICAO 8Flag de Delecao]

		TRMV->(DBSKIP())
	ENDDO
	TRMV->(DBCLOSEAREA())
	*---------------------------------------------------------------------
	cQUERYMV2 := "	 select * from SD3010 (NOLOCK) "
	cQUERYMV2 += "   where D3_FILIAL = '"+xFILIAL('SD3')+"' AND D3_COD='"+cPRALTER+"' "
	cQUERYMV2 += "   and D3_EMISSAO='"+DTOS(DATE())+"'  "
	cQUERYMV2 += "   AND D_E_L_E_T_='' "
	cQUERYMV2 += "   AND D3_ESTORNO='' "
	cQUERYMV2 += "   ORDER BY D3_CF "

	TCQUERY cQUERYMV2 NEW ALIAS "TRMV"
	TRMV->( dbGoTop() )
	nQTDMV2 :=0
	DO WHILE !TRMV->(EOF())
		IF TRMV->D3_TM<='500'
			nQTDMV2 :=nQTDMV2 +TRMV->D3_QUANT
		ELSE
			nQTDMV2 :=nQTDMV2 -TRMV->D3_QUANT
		ENDIF
		TRMV->(DBSKIP())
	ENDDO
	IF nQTDMV2<>0
		AADD(aColsMV2,{'Mov.Int',;
			'',;
			substr(TRMV->D3_EMISSAO,7,2)+'/'+substr(TRMV->D3_EMISSAO,5,2)+'/'+substr(TRMV->D3_EMISSAO,1,4),;
			nQTDMV2,;
			.F.})//.f. POSICAO 8Flag de Delecao]
	ENDIF
	TRMV->(DBCLOSEAREA())

//------------------------------------------------------------------------------

	//Local aSizeAut    := MsAdvSize(,.F.,400)
	DEFINE MSDIALOG oDlg2 FROM aSizeAut[4],aSizeAut[4] TO aSizeAut[3]*3,(aSizeAut[3]*2)+aSizeAut[4]  TITLE OemToAnsi("MRP DOMEX SCs PCs EM ABERTO") OF oMainWnd PIXEL

	@ 005,10 SAY ALLTRIM(cPRODUTO)+' - '+ALLTRIM(SUBSTR(cDESCRI,1,35)) OF oDlg2 PIXEL SIZE 300,040 FONT oFontBRW4
	cDESCALTER :=POSICIONE('SB1',1,xFILIAL('SB1')+cPRALTER,'B1_DESC')
	@ 005,325 SAY ALLTRIM(cPRALTER)+' - '+ALLTRIM(SUBSTR(cDESCALTER,1,35)) OF oDlg2 PIXEL SIZE 300,040 FONT oFontBRW4

	oGetSC1:= (MsNewGetDados():New( 025,015,095,315,/*GD_UPDATE */,/*"U_FAT002LOK()"*/  ,/*REQ_OPSD3()*/,/*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*Ffieldok*/,/*superdel*/,/*delok*/,oDlg2,aHEADSC1,aCOLSSC1))
	oGetSC1:oBrowse:Refresh()

	oGetSC2:= (MsNewGetDados():New( 025,325,095,625,/*GD_UPDATE */,/*"U_FAT002LOK()"*/  ,/*REQ_OPSD3()*/,/*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*Ffieldok*/,/*superdel*/,/*delok*/,oDlg2,aHEADSC2,aCOLSSC2))
	oGetSC2:oBrowse:Refresh()
//   150   295
//---------------
	oGetPC1:= (MsNewGetDados():New( 105,015,175,315,/*GD_UPDATE*/ ,/*"U_FAT002LOK()"*/  ,/*REQ_OPSD3()*/,/*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*Ffieldok*/,/*superdel*/,/*delok*/,oDlg2,aHEADPC1,aCOLSPC1))
	oGetPC1:oBrowse:Refresh()

	oGetPC2:= (MsNewGetDados():New( 105,325,175,625,/*GD_UPDATE*/ ,/*"U_FAT002LOK()"*/  ,/*REQ_OPSD3()*/,/*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*Ffieldok*/,/*superdel*/,/*delok*/,oDlg2,aHEADPC2,aCOLSPC2))
	oGetPC2:oBrowse:Refresh()
//------------------

	oGetMV1:= (MsNewGetDados():New( 185,015,255,315,/*GD_UPDATE*/ ,/*"U_FAT002LOK()"*/  ,/*REQ_OPSD3()*/,/*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*Ffieldok*/,/*superdel*/,/*delok*/,oDlg2,aHEADMV1,aCOLSMV1))
	oGetMV1:oBrowse:Refresh()

	oGetMV2:= (MsNewGetDados():New( 185,325,255,625,/*GD_UPDATE*/ ,/*"U_FAT002LOK()"*/  ,/*REQ_OPSD3()*/,/*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*Ffieldok*/,/*superdel*/,/*delok*/,oDlg2,aHEADMV2,aCOLSMV2))
	oGetMV2:oBrowse:Refresh()

	//@ 080,055 BUTTON "Confirmar" SIZE 040,012 OF oDlg2 Size 45,ACTION _Gravar()
	//@ 080,110 BUTTON "Cancelar"  SIZE 040,012 OF oDlg2 Size 45,ACTION _Sair()


	ACTIVATE MSDIALOG oDlg2  CENTERED

RETURN



//USER FUNCTION MRP2SCADT()//SC ALTERNATIVO

//MSGALERT('EM DESENVOLVIMENTO')

//RETURN


	*----------------------------------------------------------------------------*
USER FUNCTION MRP2SCADT()//SC ALTERNATIVO
	*----------------------------------------------------------------------------*

	Local cTitulo        := "ZHD"
	Local oDLG1Marc
	Local oFnt
	Local aBotoes        := {}
	Local lopc           :=.F.
	local cvirgula       := ""

	Local oOK	         := LoadBitmap( GetResources(), "LBOK" )
	Local oNO	         := LoadBitmap( GetResources(), "LBNO" )

	Private cStatus:=''

	PRIVATE cTITULOE     :='SOLICITACAO DE COMPRAS ALTERBATIVO - MRP'

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
        cPRALTER   := ALLTRIM(SUBSTR(cAlter+SPACE(15),14,15))
        cDESCALTER := POSICIONE('SB1',1,xFILIAL('SB1')+cPRALTER,'B1_DESC')

	MsgRun("Espere... Buscando Dados...",,{ || MRPSCAL3(@aDados) })

	If lNExistDados
		alert("Nao existe dados")
		Return()
	EndIf

	Define FONT oFnt  NAME "Arial" Size 08,10
	Define FONT oFnt2 NAME "Arial" Size 10,16 BOLD

	AAdd(aBotoes,{"Inverte"       ,  {|| MarcInv3() }, "Inverte"      ,"Inverte"    })//
	AAdd(aBotoes,{"Marca todos"   ,  {|| MarcAll3() }, "Marc Todos"   ,"Marc Todos" })//

	oTesta := oSC
	cTitulo:= "MRP Geracao de Solicitacao de Compras Alternativo"

	IF EMPTY(cPRALTER)
		MSGALERT('Produto em branco')
		RETURN
	ENDIF

	If SB1->(dbSeek(xFilial("SB1")+cPRALTER))
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
	@ 56,  5  Say   alltrim(cPRALTER) + " -  " +cDESCALTER    Size  200,09 Of oDLG1Marc Pixel Font oFnt2 Color CLR_BLUE,CLR_WHITE

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


	@ 192,010  BITMAP oBmp ResName "SELECT"        Of oDLG1Marc Size 090,20 ON CLICK (MarcInv3())   NoBorder  Pixel
	@ 192,120  BITMAP oBmp ResName "SELECTALL"     Of oDLG1Marc Size 090,20 ON CLICK (MarcAll3())   NoBorder  Pixel
	@ 192,230  BITMAP oBmp ResName "EMPILHADEIRA"  Of oDLG1Marc Size 090,20 ON CLICK (MRPGERSC(dDATASC,nQTDSC,cPRALTER,cIDMRP,cUnidReq))  NoBorder  Pixel

	Activate MsDialog oDLG1Marc Center On Init EnchoiceBar(oDLG1Marc,{|| oDLG1Marc:End() },{|| oDLG1Marc:End() },,aBotoes)
	oGetNEC:oBrowse:Refresh()

	MRPZPRV(oGetSAI,cPRODUTO)

return()

	*-------------------------------------------------------------------------------------------------------------
Static Function MarcInv3() //Inverte
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
Static Function MarcAll3() //Marca todos
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
Static Function MRPSCAL3()
	*-------------------------------------------------------------------------------------------------------------
	LOCAL nLIN    :=oGetNEC:nat
	Local cPedido := "000000"
	local nCount  := 1
	local nCount2 := 1
	Local cQuery  := ''
	Local oTMP

	cQuery := " Select * From " + RetSqlName("ZHD") + " (NOLOCK) ZHD "
	cQuery += " Where ZHD_FILIAL = '"+xFILIAL('ZHD')+"' "
	cQuery += " AND ZHD_PRODUT = '"+oGetNEC:ACOLS[nLIN][01]+"' AND ZHD_IDMRP <> '' AND ZHD.D_E_L_E_T_=''  "//AND ZHD_STATUS<>'X' "
	cQuery += " Order BY ZHD_IDMRP "

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
		IF TMP:=ZHD_STATUS<>'X'
			oTMP:=oNor
		ELSE
			oTMP:=oIn
		ENDIF
		AADD(aDados, {  .F. , ;
			oTMP ,;
			TMP->ZHD_IDMRP,;
			TMP->ZHD_TXDT1,;
			TMP->ZHD_XQTDE ,;
			TMP->ZHD_NUMSC})

		TMP->(DbSkip())
		nCount ++
	EndDo

	DbSelectArea("TMP")
	TMP->(DbCloseArea())

Return()


