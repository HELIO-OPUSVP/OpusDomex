#Include "Protheus.ch"
#include "rwmake.ch"
#include "totvs.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FIVEWIN.CH"
#Include "COLORS.CH"
#Include "FONT.CH"
#INCLUDE "MSOBJECT.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  EICFLWUP   ºAutor  ³Mauricio Opus     º Data ³ 28/05/2021    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao FOLLOWUP   º       ³                    º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de FollowUP  dinamico Sigaeic                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex - SIGAFAT                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*----------------------------------------------------------*
User Function EICFLWUP()
	*----------------------------------------------------------*

	Local aArea			:= GetArea()
	Local cGetOpc
	Local cLinhaOk
	Local cTudoOk
	Local cIniCpos
	Local nFreeze
	Local nMax
	Local cCampoOk
	Local cSuperApagar
	Local cApagaOk
	Local aButtons 		:= {}

	Private aHeader		:= {}
	Private aCols		:= {}
	Private aCols1   	:= {}
	Private nUsado		:= 0
	Private dGetDataDe 	:= (Date()-30)
	Private dGetDataAte := Date()
	Private cGetPedido 	:= Space(6)
	Private dGetData 	:= Date()
	Private nGetQuanti 	:= 0
	Private cComboBox1 	:= "Pedido"
	Private cComboBox2 	:= "Não"
	Private cComboBox5 	:= "PO"
	Private cComboBox6 	:= "Todos"
	Private cGetPCli    := Space(20)
	Private cGetNCli    := Space(20)
	Private cGetElabo   := Space(15)

	//-----------------------------------------------------------------------------
	Private dGetPodt1 := (Date()-30)
	Private dGetPodt2 := Date()
	Private cGetPoEIC1:= SPACE(20)
	Private cGetPoEIC2:= 'ZZZZZZZZZZZZZZZ'
	Private cGetPn1   := SPACE(15)
	Private cGetpn2   := 'ZZZZZZZZZZZZZZZ'
	Private cDesc     := SPACE(20)
	Private cfornec   := SPACE(20)
	Private cimp      := SPACE(20)
	Private cagent    := SPACE(20)
	Private cblhouse  := SPACE(20)
	Private cXmodal    := SPACE(20)
	Private cnf       := SPACE(09)
	Private dtconf    := Date()
	Private cEntreg   := 'Encerrado'    //cComboBox2
	Private cOrdem    := 'PO Date'      //cComboBox2

	Private odGetPodt1
	Private odGetPodt2
	Private ocGetPoEIC1
	Private ocGetPoEIC2
	Private ocGetPn1
	Private ocGetpn2
	Private ocDesc
	Private ocfornec
	Private ocimp
	Private ocagent
	Private ocblhouse
	Private ocXmodal
	Private ocnf
	Private odtconf
	//-----------------------------------------------------------------------------


	Private cGetorig := Space(30)
	Private cGetpo   := Space(20)
	Private cGetitpo := Space(03)

	Private cGetSupl := Space(30)
	Private cGetPN   := Space(15)
	Private cGetOBS  := Space(120)

	Private nLINHA :=0
	Private cLINHA :=''
	PRIVATE cPONUM :=''

	PRIVATE ocLinha
	private oFontBRW

	PRIVATE nLT      := 0
	PRIVATE nTRSTIME := 0

	DEFINE FONT oFontBRW3  NAME "Arial" SIZE 0,-15 BOLD

	Static oGetPCli
	Static oGetNCli
	Static oDlg, oGet

	Static oGetDataDe
	Static oGetDataAte
	Static oGetPO1
	Static oGetPO2
	Static oGetData
	Static oGetQuanti
	Static oGetPedido
	Static oGetElabo

	Static oGetorig
	Static oGetPO
	Static oGetitPO

	Static oGetSupl
	Static oGetPN1
	Static oGetPN2
	Static oGetOBS

	Static oGroup1
	Static oSay1
	Static oSay2
	Static oSay3, oSay4, oSay5, oSay6, oSay7, oSay8
	Static oBtnFiltro
	Static oComboBox1
	Static oComboBox2
	Static oComboBox5
	Static oComboBox6

	//X31UPDTABLE("SW7")

	Aadd( aButtons, {"HISTORIC", {|| U_RDMC050Con()}, "Consulta Produto <F4>" , "Consulta Produto <F4>" , {|| .T.}} )
	Aadd( aButtons, {"HISTORIC", {|| U_RDMC050B()}  , "Produto Completo <F5>" , "Produto Completo <F5>"  , {|| .T.}} ) //MATA061 RDMTA061
	Aadd( aButtons, {"HISTORIC", {|| RDEIC175()}    , "Status do P.O.   <F6>" , "Status do P.O.   <F6>"  , {|| .T.}} ) //MATA061 RDMTA061	RDEIC175()
	Aadd( aButtons, {"HISTORIC", {|| FDESENV()}     , "Eliminar Sld  Courier" , "Eliminar Sld  Courier"	, {|| .T.}} )
	Aadd( aButtons, {"HISTORIC", {|| FDESENV()}     , "Dividir Linha/PO"      , "Dividir Linha/PO"	    , {|| .T.}} )
	Aadd( aButtons, {"HISTORIC", {|| U_FLWUPLEG()}  , "Legenda"		          , "Legenda"              	, {|| .T.}} )

	//Legendas
	Static oBmpVerde    := LoadBitmap( GetResources(), "BR_VERDE")
	Static oBmpVermelho := LoadBitmap( GetResources(), "BR_VERMELHO")
	Static oBmpPreto    := LoadBitmap( GetResources(), "BR_PRETO")
	Static oBmpAZUL     := LoadBitmap( GetResources(), "BR_AZUL")
	Static oBmpLARANJA  := LoadBitmap( GetResources(), "BR_LARANJA")
	Static oBmpPINK     := LoadBitmap( GetResources(), "BR_PINK")


	DbSelectArea("SX3")
	SX3->(DbSetOrder(1))
	SX3->(DbSeek("ZZT"))

	SetKey(VK_F4, {|| U_RDMC050Con() } )
	SetKey(VK_F5, {|| U_RDMC050B()   } )//RDMC050B RDMC050Con
	SetKey(VK_F6, {|| RDEIC175()     } )//RDEIC175()
	SetKey(VK_F11, {|| MsgRun("Processando","Atualizando Informações"         ,{|| Atu_aCols()})})
	SetKey(VK_F12, {|| MsgRun("Processando","Atualizando Tabela de Integracao",{|| fGRAVAZZT() })})

	//	  aAdd(aHeader,{	AllTrim(X3Titulo())     ,   SX3->X3_CAMPO   ,	SX3->X3_PICTURE                                ,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,	SX3->X3_USADO,	SX3->X3_TIPO,SX3->X3_ARQUIVO,,,Nil})
	/*01*/aAdd(aHeader,{""                          ,"XX_COR"       ,   "@BMP"               ,       002,         0,".F."  ,  "   "           ,   "C",       "",    "V",     "",      "",        "", "V"})
	/*02*/aAdd(aHeader,{"Linha       "	    		,"ZZT_NLINHA"	,	"@E 99999           ",         5,         0,	""   ,	"€€€€€€€€€€€€€€",	"N",	"",,,Nil,,"V" })
	/*03*/aAdd(aHeader,{"Origin      "		    	,"ZZT_ORIGIN"	,	"@!                 ",        20,         0,	""   ,	"€€€€€€€€€€€€€€",	"C",	"",,,Nil,,"V"})
	/*04*/aAdd(aHeader,{"PO          "			    ,"ZZT_PO_NUM"	,	"@!                 ",        15,         0,	""   ,	"€€€€€€€€€€€€€€",	"C",	"",,,Nil,,"V"})
	/*05*/aAdd(aHeader,{"PO SIGA     "		    	,"ZZT_PO_SIG"	,	"@!                 ",        15,         0,	""   ,	"€€€€€€€€€€€€€€",	"C",	"",,,Nil,,"V"})
	/*06*/aAdd(aHeader,{"PO Date     "		    	,"ZZT_DT_PO "	,	"@D                 ",         8,         0,	""   ,	"€€€€€€€€€€€€€€",	"D",	"",,,Nil,,"V"})
	/*07*/aAdd(aHeader,{"Supplier Cod"	    		,"ZZT_SUPCOD"	,	"@!                 ",        15,         0,	""   ,	"€€€€€€€€€€€€€€",	"C",	"",,,Nil,,"V"})
	/*08*/aAdd(aHeader,{"Supplier Name"		    	,"ZZT_SUPPLI"	,	"@!                 ",        15,         0,	""   ,	"€€€€€€€€€€€€€€",	"C",	"",,,Nil,,"V"})
	/*09*/aAdd(aHeader,{"PN          "    			,"ZZT_COD_I "	,	"@!                 ",        15,         0,	""   ,	"€€€€€€€€€€€€€€",	"C",	"",,,Nil,,"V"})
	/*10*/aAdd(aHeader,{"PN Supplier "	    		,"ZZT_CODFOR"	,	"@!                 ",        40,         0,	""   ,	"€€€€€€€€€€€€€€",	"C",	"",,,Nil,,"V"})
	/*11*/aAdd(aHeader,{"Description "		    	,"ZZT_DESCR "	,	"@!                 ",        50,         0,	""   ,	"€€€€€€€€€€€€€€",	"C",	"",,,Nil,,"V"})
	/*12*/aAdd(aHeader,{"Qty_PO      "		    	,"ZZT_QUANT "	,	"@E 999,999,999.9999",        14,         4,	""   ,	"€€€€€€€€€€€€€€",	"N",	"",,,Nil,,"V"})
	/*13*/aAdd(aHeader,{"UnitPrice   "		    	,"ZZT_VL_UNI"	,	"@E 999,999,999.9999",        14,         4,	""   ,	"€€€€€€€€€€€€€€",	"N",	"",,,Nil,,"V"})
	/*14*/aAdd(aHeader,{"Total Price "		    	,"ZZT_VL_TOT"	,	"@E 999,999,999.9999",        14,         4,	""   ,	"€€€€€€€€€€€€€€",	"N",	"",,,Nil,,"V"})
	/*15*/aAdd(aHeader,{"Requested Date at RDT" 	,"ZZT_DTREQU"	,	"@D 99/99/9999      ",         8,         0,	""   ,	"€€€€€€€€€€€€€€",	"D",	"",,,Nil,,"V"})
	/*16*/aAdd(aHeader,{"Confirmed Date"			,"ZZT_DTCONF"	,	"99/99/9999         ",         8,         0,	""   ,	"€€€€€€€€€€€€€€",	"D",	"",,,Nil,,"A"})
	/*17*/aAdd(aHeader,{"New Date    "			    ,"ZZT_DTNEW "	,	"99/99/9999         ",         8,         0,	""   ,	"€€€€€€€€€€€€€€",	"D",	"",,,Nil,,"A"})
	/*18*/aAdd(aHeader,{"Previsao POxRDT"			,"ZZT_DTPPOR"	,	"99/99/9999         ",         8,         0,	""   ,	"€€€€€€€€€€€€€€",	"D",	"",,,Nil,,"A"})
	/*19*/aAdd(aHeader,{"Prepayment "		    	,"ZZT_PGTANT"	,	"@E 9999            ",         4,         0,	""   ,	"€€€€€€€€€€€€€€",	"N",	"",,,Nil,,"V"})
	///*20*/aAdd(aHeader,{"Modal       "			    ,"ZZT_MODAL "	,	"@!"                 ,     1,         0,	".T.",	"€€€€€€€€€€€€€€",	"C",	"",,"1=Marítimo;2=Aéreo;3=Sea-Air;4=Rodoviário;5=Courier",Nil,,"A"})
	/*20*/aAdd(aHeader,{"Modal       "			    ,"ZZT_MODAL "	,	"@!"                 ,        15,         0,	".T.",	"€€€€€€€€€€€€€€",	"C","FLMO",,,Nil,,"A"})
	/*21*/aAdd(aHeader,{"IMP         "			    ,"ZZT_HAWB  "	,	"@!                 ",        15,         0,	""   ,	"€€€€€€€€€€€€€€",	"C",	"",,,Nil,,"V"})
	/*22*/aAdd(aHeader,{"Coleta      "			    ,"ZZT_DTCOLE"	,	"99/99/9999         ",         8,         0,	""   ,	"€€€€€€€€€€€€€€",	"D",	"",,,Nil,,"A"})
	/*23*/aAdd(aHeader,{"Prvevisao COLETAxRDT "		,"ZZT_DTPCOL"	,	"99/99/9999         ",         8,         0,	""   ,	"€€€€€€€€€€€€€€",	"D",	"",,,Nil,,"A"})
	/*24*/aAdd(aHeader,{"Freight Forward  "		    ,"ZZT_FREIGH"	,	"@!                 ",        20,         0,	""   ,	"€€€€€€€€€€€€€€",	"C",	"",,,Nil,,"A"})
	/*25*/aAdd(aHeader,{"ETD Saida Voo    "		    ,"ZZT_ETD   "	,	"99/99/9999         ",         8,         0,	".T.",  "€€€€€€€€€€€€€€",   "D",    "",,,Nil,,"A"})
	/*26*/aAdd(aHeader,{"ETA Chegada Voo  "	        ,"ZZT_ETA   "	,	"99/99/9999         ",         8,         0,	".T.",  "€€€€€€€€€€€€€€",	"D",	"",,,Nil,,"A"})
	/*27*/aAdd(aHeader,{"Pre Alerta  "			    ,"ZZT_DTALER"	,	"99/99/9999         ",         8,         0,	""   ,	"€€€€€€€€€€€€€€",	"D",	"",,,Nil,,"A"})
	/*28*/aAdd(aHeader,{"Previsao Desenbaraco x Rdt","ZZT_PRVRDT"   ,	"99/99/9999         ",         8,         0,	""   ,	"€€€€€€€€€€€€€€",	"D",	"",,,Nil,,"A"})
	/*29*/aAdd(aHeader,{"House/BL    "			    ,"ZZT_HOUSE"    ,	"@! "                ,        25,         0,	".T.",	"€€€€€€€€€€€€€€",	"C",	"",,,Nil,,"A"})
	/*30*/aAdd(aHeader,{"Obs         "			    ,"ZZT_OBS   "	,	"@!                 ",       120,         0,	"",  "€€€€€€€€€€€€€€",	"C",	"",,,Nil,,"A"})
	/*31*/aAdd(aHeader,{"Entrega     "			    ,"ZZT_ENTREG"	,	"99/99/9999         ",         8,         0,	""   ,	"€€€€€€€€€€€€€€",	"D",	"",,,Nil,,"A"})
	/*32*/aAdd(aHeader,{"Lead Time   "			    ,"ZZT_LT    "	,	"@E 9999            ",         4,         0,	""   ,	"€€€€€€€€€€€€€€",	"N",	"",,,Nil,,"V"})
	/*33*/aAdd(aHeader,{"DI          "			    ,"ZZT_DI    "	,	"@!                 ",        15,         0,	""   ,	"€€€€€€€€€€€€€€",	"C",	"",,,Nil,,"V"})
	/*34*/aAdd(aHeader,{"Invoice     "			    ,"ZZT_INVOIC"	,	"@!                 ",        15,         0,	""   ,	"€€€€€€€€€€€€€€",	"C",	"",,,Nil,,"V"})
	/*35*/aAdd(aHeader,{"Nota Fiscal "			    ,"ZZT_NFISCA"	,	"@!                 ",         9,         0,	""   ,	"€€€€€€€€€€€€€€",	"C",	"",,,Nil,,"V"})
	/*36*/aAdd(aHeader,{"Qtde nfe    "			    ,"ZZT_QTDNFE"	,	"@E 999,999,999.9999",        14,         4,	""   ,	"€€€€€€€€€€€€€€",	"N",	"",,,Nil,,"V"})
	/*37*/aAdd(aHeader,{"Data NF     "			    ,"ZZT_DTNF  "	,	"99/99/9999         ",         8,         0,	""   ,	"€€€€€€€€€€€€€€",	"D",	"",,,Nil,,"V"})
	/*38*/aAdd(aHeader,{"SLD_PO_Qty  "		    	,"ZZT_SLDPO "	,	"@E 999,999,999.9999",        14,         4,	""   ,	"€€€€€€€€€€€€€€",	"N",	"",,,Nil,,"V"})
	/*39*/aAdd(aHeader,{"Qty_IMP     "		    	,"ZZT_QTDIMP "	,	"@E 999,999,999.9999",        14,         4,	""   ,	"€€€€€€€€€€€€€€",	"N",	"",,,Nil,,"V"})
    /*40*/aAdd(aHeader,{"SLD_PO_IMP  "		    	,"ZZT_SLD_PO "	,	"@E 999,999,999.9999",        14,         4,	""   ,	"€€€€€€€€€€€€€€",	"N",	"",,,Nil,,"V"})	

	nUsado	:= len(aHeader)
	aAdd(aCols,Array(nUsado+1))

	DEFINE MSDIALOG oDlg TITLE OemToAnsi("FollowUP - SIGAEIC V2.7")  FROM 000, 000  TO 600, 1300 COLORS 0, 16777215 PIXEL

	@ 032, 003 GROUP oGroup1 TO 092, 649 PROMPT "Filtros" OF oDlg COLOR 0, 16777215 PIXEL

	@ 039, 009 SAY oSay1 PROMPT "PO Date"       SIZE 045, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 047, 009 MSGET odGetPodt1  VAR dGetPodt1  SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 062, 009 MSGET odGetPodt2  VAR dGetPodt2  SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL

	@ 039, 073 SAY oSay2 PROMPT "PO EIC"                    SIZE 045, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 047, 073 MSGET ocGetPoEIC1 VAR cGetPoEIC1    F3 "SW2" SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 062, 073 MSGET ocGetPoEIC2 VAR cGetPoEIC2    F3 "SW2" SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL

	@ 039, 137 SAY oSay3 PROMPT "PN"                     SIZE 045, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 047, 137 MSGET ocGetPn1    VAR cGetPn1    F3 "SB1" SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 062, 137 MSGET ocGetpn2    VAR cGetpn2    F3 "SB1" SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL

	@ 039, 201 SAY oSay4 PROMPT "Descr PN / Fornec"  SIZE 045, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 047, 201 MSGET ocDesc      VAR cDesc           SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 062, 201 MSGET ocfornec    VAR cfornec         SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL

	@ 039, 265 SAY oSay6 PROMPT "N.Imp / Age.Carga" SIZE 110, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 047, 265 MSGET ocimp       VAR cimp    F3"SW6"  SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 062, 265 MSGET ocagent     VAR cagent           SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL

	@ 039, 329 SAY oSay7 PROMPT "Bl House / Modal"           SIZE 045, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 047, 329 MSGET ocblhouse   VAR cblhouse                SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 062, 329 MSGET ocXmodal    VAR cXmodal       F3 "FLMO" SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL

	//@ 039, 393 SAY oSay8 PROMPT "Nota Fiscal / DT Conf"     SIZE 072, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 039, 393 SAY oSay8 PROMPT "Nota Fiscal "     SIZE 072, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 047, 393 MSGET ocnf        VAR cnf           F3 "SF1" SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
	//@ 062, 393 MSGET odtconf     VAR dtconf                 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL

	@ 039, 457 SAY oSay8 PROMPT "Com Embarque"     SIZE 072, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 047, 457 MSCOMBOBOX oComboBox6 VAR cComboBox6 ITEMS {"Sim","Nao","Todos"} SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL

	@ 039, 525 SAY oSay5 PROMPT "Entregue/orderm" SIZE 045, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 047, 525 MSCOMBOBOX oComboBox2 VAR cComboBox2 ITEMS {"Encerrado","Aberto","Todos"} SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 062, 525 MSCOMBOBOX oComboBox5 VAR cComboBox5 ITEMS {"Origem","PO" ,"PO Date","Supplier","PN","IMP","Nota Fiscal"} SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL

	//489

	@ 047, 585 BUTTON oBtnFiltro PROMPT "Aplicar Filtro  (F11)" ACTION {||MsgRun("Processando","Atualizando Informacoes"         ,{|| Atu_aCols()})} SIZE 055, 012 OF oDlg PIXEL
	@ 062, 585 BUTTON oBtnFiltro PROMPT "Grv. Integracao (F12)" ACTION {||MsgRun("Processando","Atualizando Tabela de Integracao",{|| fGRAVAZZT() })} SIZE 055, 012 OF oDlg PIXEL

	//	@ 062, 435 SAY oSay5 PROMPT "Ordem" SIZE 045, 007 OF oDlg COLORS 0, 16777215 PIXEL
	//MsgRun("Processando","Atualizando Tabela de Integracao",{|| fGRAVAZZT()})

	@ 079,008 SAY ocLinha    VAR cLinha   SIZE 150,015  OF oDlg PIXEL COLOR CLR_BLUE FONT oFontBRW3
	@ 077,030 MSGET oGetorig VAR cGetorig SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL FONT oFontBRW3 WHEN(.F.)
	@ 077,102 MSGET oGetPO   VAR cGetpo   SIZE 113, 010 OF oDlg COLORS 0, 16777215 PIXEL FONT oFontBRW3 WHEN(.F.)
	@ 077,215 MSGET oGetSupl VAR cGetSupl SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL FONT oFontBRW3 WHEN(.F.)
	@ 077,287 MSGET oGetPN   VAR cGetPN   SIZE 150, 010 OF oDlg COLORS 0, 16777215 PIXEL FONT oFontBRW3 WHEN(.F.)
	@ 077,437 MSGET oGetOBS  VAR cGetOBS  SIZE 206, 010 OF oDlg COLORS 0, 16777215 PIXEL FONT oFontBRW3 WHEN(.F.)

	cGetOpc        := GD_UPDATE			// GD_INSERT+GD_DELETE+GD_UPDATE
	cLinhaOk       := "AllwaysTrue"		// Funcao executada para validar o contexto da linha atual do aCols
	cTudoOk        := "AllwaysTrue"   	// Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
	cIniCpos       := ""//"+ZY_PEDIDO/ZY_SEQ/ZY_ITEM/ZY_PRODUTO/ZY_DESC/ZY_UM/ZY_PRVFAT/ZY_LOCENTR"         // Nome dos campos do tipo caracter que utilizarao incremento automatico.
	nFreeze        := Nil               // Campos estaticos na GetDados.
	nMax           := 99999             // Numero maximo de linhas permitidas. Valor padrao 99
	cCampoOk       := "" //"U_RFAT04A()"   	// Funcao executada na validacao do campo
	cSuperApagar   := Nil               // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
	cApagaOk       := Nil               // Funcao executada para validar a exclusao de uma linha do aCols

	oGet:= MsNewGetDados():New( 094, 003, 290, 650,GD_UPDATE,cLinhaOk,cTudoOk,,,3,nMax,,cSuperApagar,cApagaOk,oDlg,aHeader,aCols)
	oGet:oBrowse:SetBlkBackColor({|| GETDCLR(oGet:aCols,oGet:nAt,aHeader)})
	oGet:oBrowse:bChange:={||U_FLWUPCHG(oGet)}

	MsgRun("Processando","Atualizando Informacoes",{|| Atu_aCols()})

	ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()},,@aButtons))


	MsgRun("Processando","Atualizando Tabela de Integracao",{|| fGRAVAZZT()})

	RestArea(aArea)

Return


Static Function Atu_aCols()
	Processa({ || Atu_aCols2() })
Return

	*----------------------------------------------------------*
Static Function Atu_aCols2()
	*----------------------------------------------------------*

	Local cQuery := ""
	Static oBmpVerde    := LoadBitmap( GetResources(), "BR_VERDE")
	Static oBmpVermelho := LoadBitmap( GetResources(), "BR_VERMELHO")
	Static oBmpPreto    := LoadBitmap( GetResources(), "BR_PRETO")
	Static oBmpAZUL     := LoadBitmap( GetResources(), "BR_AZUL")
	Static oBmpLARANJA  := LoadBitmap( GetResources(), "BR_LARANJA")
	Static oBmpPINK     := LoadBitmap( GetResources(), "BR_PINK")


	aCols1     := {}
	oGet:aCols := {}
	nLINHA :=0
	cQuerySC7 := " UPDATE SC7010 SET C7_XDATPRF=C7_DATPRF WHERE C7_XDATPRF=''  AND C7_DATPRF<>''  AND D_E_L_E_T_='' "
	TCSqlExec(cQuerySC7)

	// COM NF E DA
	/*
	cQuery := "SELECT W2_ORIGEM,W2_PO_SIGA,CCH_PAIS,W2_PO_NUM,W3_POSICAO,W2_PO_DT,A2_NREDUZ,W2_DIAS_PA,"
	cQuery += "       W3_COD_I,B1_DESC,W3_QTDE,W3_PRECO,W3_QTDE*W3_PRECO VL_TOT ,WN_DOC,WN_QUANT,WN_HAWB,WN_INVOICE,WN_SDOC,WN_QUANT,WN_ITEM,A2_COD,A2_LOJA,WN_HAWB, "
	cQuery += "       W3_XXOBS,W3_XCONFDT,W3_XNEWDT,W3_XPRVPO,W3_XCOLETA,W3_XETD,W3_XETA,W3_XPRALER,W3_XPRDSB,W3_XENTREG,W3_XFREIGT, "
	cQuery += "       W3_XMODAL,W3_XDTPCOL,W3_XHOUSE , "
	cQuery += "       W2_TIPO_EM,W2_DEST"
	cQuery += " FROM SW2010 SW2 WITH(NOLOCK),SW3010 SW3 WITH(NOLOCK),SA2010 SA2 WITH(NOLOCK),CCH010 CCH WITH(NOLOCK) ,SB1010 SB1 WITH(NOLOCK) ,"
	cQuery += "      SWN010 SWN WITH(NOLOCK)"
	cQuery += "	WHERE W2_PO_NUM=W3_PO_NUM AND A2_COD+A2_LOJA=W2_FORN+W2_FORLOJ AND   CCH_CODIGO=A2_CODPAIS AND B1_COD=W3_COD_I"
	cQuery += "	AND W2_PO_NUM=WN_PO_EIC AND W3_COD_I=WN_PRODUTO AND WN_ITEM_DA=W3_POSI_DA"
	cQuery += " AND W2_PO_DT  >='"+DTOS(dGetPodt1)+"' AND W2_PO_DT  <='"+DTOS(dGetPodt2)+"' "
	cQuery += " AND W2_PO_NUM >='"+cGetPoEIC1+"'      AND W2_PO_NUM <='"+cGetPoEIC2+"' "
	cQuery += " AND W3_COD_I  >='"+cGetPn1+"'         AND W3_COD_I  <='"+cGetPn2+"' "
	cQuery += " AND W3_SEQ=0"
	cQuery += " AND  SW2.D_E_L_E_T_=''"
	cQuery += " AND  SW3.D_E_L_E_T_=''"
	cQuery += " AND  SA2.D_E_L_E_T_=''"
	cQuery += " AND  CCH.D_E_L_E_T_=''"
	cQuery += " AND  SB1.D_E_L_E_T_=''"
	cQuery += " AND  SWN.D_E_L_E_T_=''"
	cQuery += " AND  W2_FILIAL='"+xFILIAL('SW2')+"' "
	cQuery += " AND  W3_FILIAL='"+xFILIAL('SW3')+"' "
	cQuery += " AND  A2_FILIAL='"+xFILIAL('SA2')+"' "
	cQuery += " AND  CCH_FILIAL='"+xFILIAL('CCH')+"' "
	cQuery += " AND  B1_FILIAL='"+xFILIAL('SB1')+"' "
	cQuery += " AND  WN_FILIAL='"+xFILIAL('SWN')+"' " 
	*/
	cQuery := "SELECT W2_ORIGEM,WN_PO_NUM AS W2_PO_SIGA,CCH_PAIS,TRIM(W3_PO_DA)+' DA' AS W2_PO_NUM,WN_ITEM_DA AS  W3_POSICAO,W2_PO_DT,A2_NREDUZ,W2_DIAS_PA,"
	cQuery += "       W3_COD_I,B1_DESC,W3_QTDE,W3_PRECO,W3_QTDE*W3_PRECO VL_TOT ,WN_DOC,WN_QUANT,WN_HAWB,WN_INVOICE,WN_SDOC,WN_QUANT,WN_ITEM,A2_COD,A2_LOJA,WN_HAWB, "
	cQuery += "       W3_XXOBS,W3_XCONFDT,W3_XNEWDT,W3_XPRVPO,W3_XCOLETA,W3_XETD,W3_XETA,W3_XPRALER,W3_XPRDSB,W3_XENTREG,W3_XFREIGT, "
	cQuery += "       W3_XMODAL,W3_XDTPCOL,W3_XHOUSE , "
	cQuery += "       W2_TIPO_EM,W2_DEST "
	cQuery += " FROM SW2010 SW2 WITH(NOLOCK),SW3010 SW3 WITH(NOLOCK),SA2010 SA2 WITH(NOLOCK),CCH010 CCH WITH(NOLOCK) ,SB1010 SB1 WITH(NOLOCK) ,"
	cQuery += "      SWN010 SWN WITH(NOLOCK)"
	cQuery += " WHERE SUBSTRING(W3_PO_NUM,1,2)='DA' AND SUBSTRING(WN_PO_EIC,1,2)='DA' "
	cQuery += " AND W2_PO_NUM=W3_PO_NUM AND A2_COD+A2_LOJA=W2_FORN+W2_FORLOJ AND   CCH_CODIGO=A2_CODPAIS AND B1_COD=W3_COD_I"
	cQuery += " AND W2_PO_NUM=WN_PO_EIC AND W3_COD_I=WN_PRODUTO AND WN_ITEM_DA=W3_POSI_DA"
	cQuery += " AND W2_PO_DT  >='"+DTOS(dGetPodt1)+"' AND W2_PO_DT  <='"+DTOS(dGetPodt2)+"' "
	cQuery += " AND W3_PO_DA  >='"+cGetPoEIC1+"'      AND W3_PO_DA  <='"+cGetPoEIC2+"' "
	cQuery += " AND W3_COD_I  >='"+cGetPn1+"'         AND W3_COD_I  <='"+cGetPn2+"' "
	cQuery += " AND W3_SEQ=0"
	cQuery += " AND  SW2.D_E_L_E_T_=''"
	cQuery += " AND  SW3.D_E_L_E_T_=''"
	cQuery += " AND  SA2.D_E_L_E_T_=''"
	cQuery += " AND  CCH.D_E_L_E_T_=''"
	cQuery += " AND  SB1.D_E_L_E_T_=''"
	cQuery += " AND  SWN.D_E_L_E_T_=''"
	cQuery += " AND  W2_FILIAL='"+xFILIAL('SW2')+"' "
	cQuery += " AND  W3_FILIAL='"+xFILIAL('SW3')+"' "
	cQuery += " AND  A2_FILIAL='"+xFILIAL('SA2')+"' "
	cQuery += " AND  CCH_FILIAL='"+xFILIAL('CCH')+"' "
	cQuery += " AND  B1_FILIAL='"+xFILIAL('SB1')+"' "
	cQuery += " AND  WN_FILIAL='"+xFILIAL('SWN')+"' "

	IF !EMPTY(cnf)
		cQuery += " AND  WN_DOC LIKE('%"+ALLTRIM(cnf)+"%')  "
	ENDIF

	IF !EMPTY(cblhouse)
		cQuery += " AND  W3_XHOUSE LIKE('%"+ALLTRIM(cblhouse)+"%')  "
	ENDIF

	IF !EMPTY(cagent)
		cQuery += " AND  W3_XFREIGT LIKE('%"+ALLTRIM(cagent)+"%')  "
	ENDIF
	IF !EMPTY(cfornec)
		cQuery += " AND  A2_NREDUZ LIKE('%"+ALLTRIM(cfornec)+"%')  "
	ENDIF

	IF !EMPTY(cDesc)
		cQuery += " AND  B1_DESC LIKE('%"+ALLTRIM(cDesc)+"%')  "
	ENDIF
	//cComboBox2 ITEMS {"Encerrado","Aberto","Todos"}
	DO CASE
	CASE substr(cComboBox2,1,1)=="E"
		cQuery += " AND  W3_XENTREG <> '' "
	CASE substr(cComboBox2,1,1)=="A"
		cQuery += " AND  W3_XENTREG = '' "
	Otherwise
		//substr(cComboBox2,1,1)=="T"
	EndCase

	//COM NF SEM DA
	cQuery += " UNION ALL "
	cQuery += " SELECT W2_ORIGEM,W2_PO_SIGA,CCH_PAIS,W2_PO_NUM,W3_POSICAO,W2_PO_DT,A2_NREDUZ,W2_DIAS_PA,"
	cQuery += "       W3_COD_I,B1_DESC,W3_QTDE,W3_PRECO,W3_QTDE*W3_PRECO VL_TOT ,WN_DOC,WN_QUANT,WN_HAWB,WN_INVOICE,WN_SDOC,WN_QUANT,WN_ITEM,A2_COD,A2_LOJA,WN_HAWB,"
	cQuery += "       W3_XXOBS,W3_XCONFDT,W3_XNEWDT,W3_XPRVPO,W3_XCOLETA,W3_XETD,W3_XETA,W3_XPRALER,W3_XPRDSB,W3_XENTREG,W3_XFREIGT, "
	cQuery += "       W3_XMODAL,W3_XDTPCOL,W3_XHOUSE , "
	cQuery += "       W2_TIPO_EM,W2_DEST "
	cQuery += " FROM SW2010 SW2 WITH(NOLOCK),SW3010 SW3 WITH(NOLOCK),SA2010 SA2 WITH(NOLOCK),CCH010 CCH WITH(NOLOCK) ,SB1010 SB1 WITH(NOLOCK) ,"
	cQuery += "      SWN010 SWN WITH(NOLOCK)"
	cQuery += "	WHERE  SUBSTRING(W3_PO_NUM,1,2)<>'DA' AND SUBSTRING(WN_PO_EIC,1,2)<>'DA' "
	cQuery += "	AND W2_PO_NUM=W3_PO_NUM AND A2_COD+A2_LOJA=W2_FORN+W2_FORLOJ AND   CCH_CODIGO=A2_CODPAIS AND B1_COD=W3_COD_I"
	cQuery += "	AND W2_PO_NUM=WN_PO_EIC AND W3_COD_I=WN_PRODUTO AND W3_POSICAO=WN_ITEM_DA"
	cQuery += " AND W2_PO_DT  >='"+DTOS(dGetPodt1)+"' AND W2_PO_DT  <='"+DTOS(dGetPodt2)+"' "
	cQuery += " AND W2_PO_NUM >='"+cGetPoEIC1+"'      AND W2_PO_NUM <='"+cGetPoEIC2+"' "
	cQuery += " AND W3_COD_I  >='"+cGetPn1+"'         AND W3_COD_I  <='"+cGetPn2+"' "
	cQuery += " AND W3_SEQ=0"
	cQuery += " AND  SW2.D_E_L_E_T_=''"
	cQuery += " AND  SW3.D_E_L_E_T_=''"
	cQuery += " AND  SA2.D_E_L_E_T_=''"
	cQuery += " AND  CCH.D_E_L_E_T_=''"
	cQuery += " AND  SB1.D_E_L_E_T_=''"
	cQuery += " AND  SWN.D_E_L_E_T_=''"
	cQuery += " AND  W2_FILIAL='"+xFILIAL('SW2')+"' "
	cQuery += " AND  W3_FILIAL='"+xFILIAL('SW3')+"' "
	cQuery += " AND  A2_FILIAL='"+xFILIAL('SA2')+"' "
	cQuery += " AND  CCH_FILIAL='"+xFILIAL('CCH')+"' "
	cQuery += " AND  B1_FILIAL='"+xFILIAL('SB1')+"' "
	cQuery += " AND  WN_FILIAL='"+xFILIAL('SWN')+"' "
	IF !EMPTY(cnf)
		cQuery += " AND  WN_DOC LIKE('%"+ALLTRIM(cnf)+"%')  "
	ENDIF

	IF !EMPTY(cblhouse)
		cQuery += " AND  W3_XHOUSE LIKE('%"+ALLTRIM(cblhouse)+"%')  "
	ENDIF

	IF !EMPTY(cagent)
		cQuery += " AND  W3_XFREIGT LIKE('%"+ALLTRIM(cagent)+"%')  "
	ENDIF

	IF !EMPTY(cfornec)
		cQuery += " AND  A2_NREDUZ LIKE('%"+ALLTRIM(cfornec)+"%')  "
	ENDIF

	IF !EMPTY(cDesc)
		cQuery += " AND  B1_DESC LIKE('%"+ALLTRIM(cDesc)+"%')  "
	ENDIF
	DO CASE
	CASE substr(cComboBox2,1,1)=="E"
		cQuery += " AND  W3_XENTREG <> '' "
	CASE substr(cComboBox2,1,1)=="A"
		cQuery += " AND  W3_XENTREG = '' "
	Otherwise
		//substr(cComboBox2,1,1)=="T"
	EndCase

	//SEM NF
	cQuery += " UNION ALL "
	cQuery += " SELECT W2_ORIGEM,W2_PO_SIGA,CCH_PAIS,W2_PO_NUM,W3_POSICAO,W2_PO_DT,A2_NREDUZ,W2_DIAS_PA,"
	cQuery += "       W3_COD_I,B1_DESC,W3_QTDE,W3_PRECO,W3_QTDE*W3_PRECO VL_TOT ,'' WN_DOC,0 WN_QUANT,'' WN_HAWB,'' WN_INVOICE,'' WN_SDOC,0 WN_QUANT,'' WN_ITEM,A2_COD,A2_LOJA,'' WN_HAWB, "
	cQuery += "       W3_XXOBS,W3_XCONFDT,W3_XNEWDT,W3_XPRVPO,W3_XCOLETA,W3_XETD,W3_XETA,W3_XPRALER,W3_XPRDSB,W3_XENTREG,W3_XFREIGT, "
	cQuery += "       W3_XMODAL,W3_XDTPCOL,W3_XHOUSE , "
	cQuery += "       W2_TIPO_EM,W2_DEST "
	//cQuery += " FROM SW2010 SW2 WITH(NOLOCK),SW3010 SW3 WITH(NOLOCK),SA2010 SA2 WITH(NOLOCK),CCH010 CCH WITH(NOLOCK) ,SB1010 SB1 WITH(NOLOCK)"
	//cQuery += " WHERE W2_PO_NUM=W3_PO_NUM AND A2_COD+A2_LOJA=W2_FORN+W2_FORLOJ AND   CCH_CODIGO=A2_CODPAIS AND B1_COD=W3_COD_I"
	cQuery += "  FROM SW2010 SW2 WITH(NOLOCK),SW3010 SW3 WITH(NOLOCK),SA2010 SA2 WITH(NOLOCK),CCH010 CCH WITH(NOLOCK) ,SB1010 SB1 WITH(NOLOCK),
	cQuery += " SW5010 SW5 WITH(NOLOCK)
	cQuery += " WHERE   W5_PO_NUM=W2_PO_NUM AND W5_COD_I=W3_COD_I  AND W5_HAWB='' AND W5_POSICAO=W3_POSICAO
	cQuery += " AND W2_PO_NUM=W3_PO_NUM AND A2_COD+A2_LOJA=W2_FORN+W2_FORLOJ AND   CCH_CODIGO=A2_CODPAIS AND B1_COD=W3_COD_I
	///////////////
	cQuery += " AND W2_PO_DT  >='"+DTOS(dGetPodt1)+"' AND W2_PO_DT  <='"+DTOS(dGetPodt2)+"' "
	cQuery += " AND W2_PO_NUM >='"+cGetPoEIC1+"'      AND W2_PO_NUM <='"+cGetPoEIC2+"' "
	cQuery += " AND W3_COD_I  >='"+cGetPn1+"'         AND W3_COD_I  <='"+cGetPn2+"' "
	cQuery += " AND W3_SEQ=0"
	cQuery += " AND  SW2.D_E_L_E_T_=''"
	cQuery += " AND  SW3.D_E_L_E_T_=''"
	cQuery += " AND  SA2.D_E_L_E_T_=''"
	cQuery += " AND  CCH.D_E_L_E_T_=''"
	cQuery += " AND  SB1.D_E_L_E_T_=''"
	cQuery += " AND  W2_FILIAL='"+xFILIAL('SW2')+"' "
	cQuery += " AND  W3_FILIAL='"+xFILIAL('SW3')+"' "
	cQuery += " AND  A2_FILIAL='"+xFILIAL('SA2')+"' "
	cQuery += " AND  CCH_FILIAL='"+xFILIAL('CCH')+"' "
	cQuery += " AND  B1_FILIAL='"+xFILIAL('SB1')+"' "

//	cQuery += " AND W2_PO_NUM+W3_COD_I NOT IN (SELECT W5_PO_NUM+W5_COD_I FROM SW5010 WHERE D_E_L_E_T_='')
//	cQuery += " AND W2_PO_NUM+W3_COD_I NOT IN (SELECT WN_PO_EIC+WN_PRODUTO FROM SWN010 WHERE D_E_L_E_T_='' )"

//	cQuery += " AND W2_PO_NUM+W3_COD_I NOT IN "
//    cQuery += " (SELECT W5_PO_NUM+W5_COD_I FROM SW5010 WHERE D_E_L_E_T_='' AND W5_PO_NUM=W2_PO_NUM AND W5_COD_I=W3_COD_I  AND W5_HAWB<>'') "

//	cQuery += " AND W2_PO_NUM+W3_COD_I NOT IN 
//    cQuery += " (SELECT WN_PO_EIC+WN_PRODUTO FROM SWN010 WHERE D_E_L_E_T_='' AND WN_PO_EIC=W2_PO_NUM AND WN_PRODUTO=W3_COD_I  )"

//cQuery += "	 AND W2_PO_NUM+W3_COD_I+W3_POSICAO NOT IN 
//cQuery += "     (SELECT W5_PO_NUM+W5_COD_I+W5_POSICAO FROM SW5010 
//cQuery += "	 WHERE D_E_L_E_T_='' AND W5_PO_NUM=W2_PO_NUM AND W5_COD_I=W3_COD_I  AND W5_HAWB<>'' AND W5_POSICAO=W3_POSICAO) 

	cQuery += "	 AND W2_PO_NUM+W3_COD_I+W3_POSICAO NOT IN
	cQuery += "     (SELECT WN_PO_EIC+WN_PRODUTO+WN_ITEM FROM SWN010 WHERE D_E_L_E_T_='' AND WN_PO_EIC=W2_PO_NUM AND WN_PRODUTO=W3_COD_I
	cQuery += "  AND WN_ITEM=W3_POSICAO )

	cQuery += "	AND   W2_PO_NUM+W3_COD_I+W3_POSICAO NOT IN  "
	cQuery += "  (SELECT W5_PO_NUM+W5_COD_I+W5_POSICAO FROM SW5010 WHERE D_E_L_E_T_=''  "
	cQuery += "  AND W5_PO_NUM=W2_PO_NUM AND W5_COD_I=W3_COD_I AND W5_POSICAO=W3_POSICAO AND W5_HAWB<>'') "

	IF !EMPTY(cnf)
		cQuery += " AND  WN_DOC LIKE('%"+ALLTRIM(cnf)+"%')  "
	ENDIF

	IF !EMPTY(cblhouse)
		cQuery += " AND  W3_XHOUSE LIKE('%"+ALLTRIM(cblhouse)+"%')  "
	ENDIF

	IF !EMPTY(cagent)
		cQuery += " AND  W3_XFREIGT LIKE('%"+ALLTRIM(cagent)+"%')  "
	ENDIF

	IF !EMPTY(cfornec)
		cQuery += " AND  A2_NREDUZ LIKE('%"+ALLTRIM(cfornec)+"%')  "
	ENDIF

	IF !EMPTY(cDesc)
		cQuery += " AND  B1_DESC LIKE('%"+ALLTRIM(cDesc)+"%')  "
	ENDIF
	DO CASE
	CASE substr(cComboBox2,1,1)=="E"
		cQuery += " AND  W3_XENTREG <> '' "
	CASE substr(cComboBox2,1,1)=="A"
		cQuery += " AND  W3_XENTREG = '' "
	Otherwise
		//substr(cComboBox2,1,1)=="T"
	EndCase
	*---------------------------------------------------------------------------------------------
	//SEM NF COM IMP (HAWB)
	cQuery += " UNION ALL "
	cQuery += " SELECT W2_ORIGEM,W2_PO_SIGA,CCH_PAIS,W2_PO_NUM,W3_POSICAO,W2_PO_DT,A2_NREDUZ,W2_DIAS_PA, "
	//cQuery += " W3_COD_I,B1_DESC,W5_QTDE AS W3_QTDE ,W3_PRECO,W5_QTDE*W3_PRECO VL_TOT ,'' WN_DOC,0 WN_QUANT,W5_HAWB WN_HAWB,'' WN_INVOICE,'' WN_SDOC,0 WN_QUANT,'' WN_ITEM,A2_COD,A2_LOJA,W5_HAWB WN_HAWB, "
	cQuery += " W3_COD_I,B1_DESC,W3_QTDE ,W3_PRECO,W3_QTDE*W3_PRECO VL_TOT ,'' WN_DOC,0 WN_QUANT,W5_HAWB WN_HAWB,'' WN_INVOICE,'' WN_SDOC,0 WN_QUANT,'' WN_ITEM,A2_COD,A2_LOJA,W5_HAWB WN_HAWB, "
	cQuery += " W3_XXOBS,W3_XCONFDT,W3_XNEWDT,W3_XPRVPO,W3_XCOLETA,W3_XETD,W3_XETA,W3_XPRALER,W3_XPRDSB,'' AS W3_XENTREG,W3_XFREIGT, "
	cQuery += " W3_XMODAL,W3_XDTPCOL,W3_XHOUSE , "
	cQuery += " W2_TIPO_EM,W2_DEST "
	cQuery += " FROM SW2010 SW2 WITH(NOLOCK),SW3010 SW3 WITH(NOLOCK),SA2010 SA2 WITH(NOLOCK),CCH010 CCH WITH(NOLOCK) ,SB1010 SB1 WITH(NOLOCK), "
	cQuery += " SW5010 SW5 WITH(NOLOCK) "
	cQuery += " WHERE  W5_PO_NUM=W2_PO_NUM AND W5_COD_I=W3_COD_I  AND W5_HAWB<>'' AND W5_POSICAO=W3_POSICAO "
	cQuery += " AND W2_PO_NUM=W3_PO_NUM AND A2_COD+A2_LOJA=W2_FORN+W2_FORLOJ AND   CCH_CODIGO=A2_CODPAIS AND B1_COD=W3_COD_I "
	cQuery += " AND W2_PO_DT  >='"+DTOS(dGetPodt1)+"' AND W2_PO_DT  <='"+DTOS(dGetPodt2)+"' "
	cQuery += " AND W2_PO_NUM >='"+cGetPoEIC1+"'      AND W2_PO_NUM <='"+cGetPoEIC2+"' "
	cQuery += " AND W3_COD_I  >='"+cGetPn1+"'         AND W3_COD_I  <='"+cGetPn2+"' "
	cQuery += " AND W3_SEQ=0 "
	cQuery += " AND  SW2.D_E_L_E_T_=''"
	cQuery += " AND  SW3.D_E_L_E_T_=''"
	cQuery += " AND  SA2.D_E_L_E_T_=''"
	cQuery += " AND  CCH.D_E_L_E_T_=''"
	cQuery += " AND  SB1.D_E_L_E_T_=''"
	cQuery += " AND  SW5.D_E_L_E_T_=''"
	cQuery += " AND  W2_FILIAL ='"+xFILIAL('SW2')+"' "
	cQuery += " AND  W3_FILIAL ='"+xFILIAL('SW3')+"' "
	cQuery += " AND  A2_FILIAL ='"+xFILIAL('SA2')+"' "
	cQuery += " AND  CCH_FILIAL='"+xFILIAL('CCH')+"' "
	cQuery += " AND  B1_FILIAL ='"+xFILIAL('SB1')+"' "
	cQuery += " AND  W5_FILIAL ='"+xFILIAL('SW5')+"' "
	//cQuery += " AND W2_PO_NUM+W3_COD_I+W5_HAWB NOT IN (SELECT WN_PO_EIC+WN_PRODUTO+WN_HAWB FROM SWN010 WHERE D_E_L_E_T_='' ) "
	cQuery += " AND W2_PO_NUM +W3_COD_I+W5_HAWB NOT IN "
	cQuery += " (SELECT WN_PO_EIC+WN_PRODUTO+WN_HAWB FROM SWN010 WHERE D_E_L_E_T_='' AND WN_PO_EIC=W2_PO_NUM AND WN_PRODUTO=W3_COD_I AND WN_HAWB=W5_HAWB ) "
	cQuery += " AND TRIM(W2_PO_SIGA)+TRIM(W3_COD_I)+SUBSTRING(W5_HAWB,1,11) NOT IN "
	cQuery += " (SELECT TRIM(WN_PO_NUM)+TRIM(WN_PRODUTO)+SUBSTRING(WN_HAWB,1,11) "
	cQuery += " FROM SWN010 WHERE D_E_L_E_T_='' AND SUBSTRING(WN_HAWB,1,11)=SUBSTRING(W5_HAWB,1,11) "
	cQuery += " AND TRIM(WN_PO_NUM)=TRIM(W2_PO_SIGA) AND TRIM(WN_PRODUTO)=TRIM(W3_COD_I) ) "


	IF !EMPTY(cnf)
		cQuery += " AND  WN_DOC LIKE('%"+ALLTRIM(cnf)+"%')  "
	ENDIF

	IF !EMPTY(cblhouse)
		cQuery += " AND  W3_XHOUSE LIKE('%"+ALLTRIM(cblhouse)+"%')  "
	ENDIF

	IF !EMPTY(cagent)
		cQuery += " AND  W3_XFREIGT LIKE('%"+ALLTRIM(cagent)+"%')  "
	ENDIF

	IF !EMPTY(cfornec)
		cQuery += " AND  A2_NREDUZ LIKE('%"+ALLTRIM(cfornec)+"%')  "
	ENDIF

	IF !EMPTY(cDesc)
		cQuery += " AND  B1_DESC LIKE('%"+ALLTRIM(cDesc)+"%')  "
	ENDIF
	DO CASE
	CASE substr(cComboBox2,1,1)=="E"
		cQuery += " AND  W3_XENTREG <> '' "
	CASE substr(cComboBox2,1,1)=="A"
		cQuery += " AND  W3_XENTREG = '' "
	Otherwise
		//substr(cComboBox2,1,1)=="T"
	EndCase

	*---------------------------------------------------------------------------------------------
	// PRODUTO ANUENTE
	cQuery += " UNION ALL "
	cQuery += " SELECT W2_ORIGEM,W2_PO_SIGA,CCH_PAIS,W2_PO_NUM,W3_POSICAO,W2_PO_DT,A2_NREDUZ,W2_DIAS_PA,"
	cQuery += "       W3_COD_I,B1_DESC,W3_QTDE,W3_PRECO,W3_QTDE*W3_PRECO VL_TOT ,'' WN_DOC,0 WN_QUANT,'' WN_HAWB,'' WN_INVOICE,'' WN_SDOC,0 WN_QUANT,'' WN_ITEM,A2_COD,A2_LOJA,'' WN_HAWB, "
	cQuery += "       W3_XXOBS,W3_XCONFDT,W3_XNEWDT,W3_XPRVPO,W3_XCOLETA,W3_XETD,W3_XETA,W3_XPRALER,W3_XPRDSB,W3_XENTREG,W3_XFREIGT, "
	cQuery += "       W3_XMODAL,W3_XDTPCOL,W3_XHOUSE , "
	cQuery += "       W2_TIPO_EM,W2_DEST "
	cQuery += "  FROM SW2010 SW2 WITH(NOLOCK),SW3010 SW3 WITH(NOLOCK),SA2010 SA2 WITH(NOLOCK),CCH010 CCH WITH(NOLOCK) ,SB1010 SB1 WITH(NOLOCK)
	cQuery += " WHERE  W2_PO_NUM=W3_PO_NUM AND A2_COD+A2_LOJA=W2_FORN+W2_FORLOJ AND   CCH_CODIGO=A2_CODPAIS AND B1_COD=W3_COD_I
	cQuery += " AND W2_PO_DT  >='"+DTOS(dGetPodt1)+"' AND W2_PO_DT  <='"+DTOS(dGetPodt2)+"' "
	cQuery += " AND W2_PO_NUM >='"+cGetPoEIC1+"'      AND W2_PO_NUM <='"+cGetPoEIC2+"' "
	cQuery += " AND W3_COD_I  >='"+cGetPn1+"'         AND W3_COD_I  <='"+cGetPn2+"' "
	cQuery += " AND W3_SEQ=0"
	cQuery += " AND W3_FLUXO='1' "   //ANUENTE
	cQuery += " AND  SW2.D_E_L_E_T_=''"
	cQuery += " AND  SW3.D_E_L_E_T_=''"
	cQuery += " AND  SA2.D_E_L_E_T_=''"
	cQuery += " AND  CCH.D_E_L_E_T_=''"
	cQuery += " AND  SB1.D_E_L_E_T_=''"
	cQuery += " AND  W2_FILIAL='"+xFILIAL('SW2')+"' "
	cQuery += " AND  W3_FILIAL='"+xFILIAL('SW3')+"' "
	cQuery += " AND  A2_FILIAL='"+xFILIAL('SA2')+"' "
	cQuery += " AND  CCH_FILIAL='"+xFILIAL('CCH')+"' "
	cQuery += " AND  B1_FILIAL='"+xFILIAL('SB1')+"' "
	cQuery += "	 AND W2_PO_NUM+W3_COD_I+W3_POSICAO NOT IN
	cQuery += "     (SELECT WN_PO_EIC+WN_PRODUTO+WN_ITEM FROM SWN010 WHERE D_E_L_E_T_='' AND WN_PO_EIC=W2_PO_NUM AND WN_PRODUTO=W3_COD_I
	cQuery += "  AND WN_ITEM=W3_POSICAO )
	cQuery += "	AND   W2_PO_NUM+W3_COD_I+W3_POSICAO NOT IN  "
	cQuery += "  (SELECT W5_PO_NUM+W5_COD_I+W5_POSICAO FROM SW5010 WHERE D_E_L_E_T_=''  "
	cQuery += "  AND W5_PO_NUM=W2_PO_NUM AND W5_COD_I=W3_COD_I AND W5_POSICAO=W3_POSICAO ) "

	IF !EMPTY(cnf)
		cQuery += " AND  WN_DOC LIKE('%"+ALLTRIM(cnf)+"%')  "
	ENDIF

	IF !EMPTY(cblhouse)
		cQuery += " AND  W3_XHOUSE LIKE('%"+ALLTRIM(cblhouse)+"%')  "
	ENDIF

	IF !EMPTY(cagent)
		cQuery += " AND  W3_XFREIGT LIKE('%"+ALLTRIM(cagent)+"%')  "
	ENDIF

	IF !EMPTY(cfornec)
		cQuery += " AND  A2_NREDUZ LIKE('%"+ALLTRIM(cfornec)+"%')  "
	ENDIF

	IF !EMPTY(cDesc)
		cQuery += " AND  B1_DESC LIKE('%"+ALLTRIM(cDesc)+"%')  "
	ENDIF
	DO CASE
	CASE substr(cComboBox2,1,1)=="E"
		cQuery += " AND  W3_XENTREG <> '' "
	CASE substr(cComboBox2,1,1)=="A"
		cQuery += " AND  W3_XENTREG = '' "
	Otherwise
		//substr(cComboBox2,1,1)=="T"
	EndCase

	*---------------------------------------------------------------------------------------------
	DO Case
	CASE cComboBox5=='Origem'
		cQuery += " ORDER BY CCH.CCH_PAIS,W2_ORIGEM,W2_PO_NUM,W3_POSICAO,WN_DOC DESC"
	CASE cComboBox5=='PO'
		cQuery += " ORDER BY W2_PO_NUM,W3_POSICAO,WN_DOC DESC"
	CASE cComboBox5=='PO Date'
		cQuery +=  " ORDER BY W2_PO_DT,W2_PO_NUM,W3_POSICAO,WN_DOC DESC"
	CASE cComboBox5=='Supplier'
		cQuery +=  " ORDER BY A2_NREDUZ,W2_PO_DT,W2_PO_NUM,W3_POSICAO,WN_DOC DESC"
	CASE cComboBox5=='PN'
		cQuery += " ORDER BY W3_COD_I,W2_PO_NUM,W3_POSICAO,WN_DOC DESC"
	CASE cComboBox5=='IMP'
		cQuery += " ORDER BY WN_HAWB,W2_PO_NUM,W3_POSICAO,WN_DOC DESC"
	CASE cComboBox5=='Nota Fiscal'
		cQuery += " ORDER BY   WN_DOC,WN_SDOC,W2_PO_NUM,W3_POSICAO,WN_DOC DESC"
	Otherwise
		cQuery += " ORDER BY W2_PO_NUM,W3_POSICAO,WN_DOC DESC"
	EndCase

	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf

	dbUseArea( .T.,"TOPCONN", TcGenQry( ,,cQuery ), "TRB", .F., .T. )

	nRecno := 0

	TRB->( dbEval({|| nRecno++}) )

	ProcRegua(nRecno)

	TRB->( DbGoTop() )

	While TRB->(!Eof())

		IncProc()

		//(2) A5_FILIAL+A5_PRODUTO+A5_FORNECE+A5_LOJA
		cCODPRF :=''
		cCODPRF :=ALLTRIM(POSICIONE('SA5',2,xFILIAL('SA5')+TRB->W3_COD_I+TRB->A2_COD+TRB->A2_LOJA,'A5_CODPRF'))

		IF (TRB->W2_PO_NUM+'/'+TRB->W3_POSICAO+' - '+TRB->W2_PO_SIGA) == cPONUM
			nLINHA := nLINHA
		ELSE
			nLINHA := nLINHA+1
			cPONUM := TRB->W2_PO_NUM+'/'+TRB->W3_POSICAO+' - '+TRB->W2_PO_SIGA
		ENDIF


		cHAWB      := ''
		cW6_DI_NUM := ''


//---------------------------------------------------------------------------------------------
		cW6_DI_NUM :=''
		cHAWB      :=''
		SW7->(DbSetOrder(RetOrder("SW7","W7_FILIAL+W7_PO_NUM+W7_COD_I+W7_POSICAO")))
		//If SW7->( dbSeek( xFilial() + SUBSTR(TRB->W2_PO_NUM,1,15) + TRB->W3_COD_I + TRB->W3_POSICAO ) )
		If SW7->( dbSeek( xFilial() + SUBSTR(TRB->W2_PO_NUM,1,20) + TRB->W3_COD_I + TRB->W3_POSICAO ) )
			SW6->( dbSetOrder(1) )
			IF SW6->( dbSeek( xFilial() + SW7->W7_HAWB ) )
				cW6_DI_NUM := SW6->W6_DI_NUM
			ENDIF
			IF EMPTY(TRB->WN_HAWB)
				cHAWB :=SW7->W7_HAWB
			ELSE
				cHAWB := TRB->WN_HAWB
			EndIf
		ENDIF

/*
		IF EMPTY(TRB->WN_HAWB)
			*-------------------------------------------------------------------------------*
			//cQuery2 := "SELECT W6_DI_NUM,W7_PO_NUM,W7_COD_I,W7_HAWB,W7_POSICAO ,W6_HOUSE"
			//cQuery2 += " FROM SW6010 WITH(NOLOCK),SW7010 WITH(NOLOCK) "
			//cQuery2 += " WHERE W6_HAWB=W7_HAWB "
			//cQuery2 += " AND W6_FILIAL='"+xFilial('SW6')+"' AND W7_FILIAL='"+xFILIAL('SW7')+"'     "
			//cQuery2 += " AND W7_PO_NUM='"+TRB->W2_PO_NUM+"' AND W7_COD_I='"+TRB->W3_COD_I+"' AND W7_POSICAO='"+TRB->W3_POSICAO+"' "

			If RetOrder("SW7","W7_FILIAL+W7_PO_NUM+W7_COD_I+W7_POSICAO") == 1 //.or. .T.

				cQuery2 := "SELECT W7_HAWB "
				cQuery2 += " FROM SW7010 WITH(NOLOCK) "
				cQuery2 += " WHERE W7_FILIAL='"+xFILIAL('SW7')+"' "
				cQuery2 += " AND W7_PO_NUM='"+TRB->W2_PO_NUM+"' AND W7_COD_I='"+TRB->W3_COD_I+"' AND W7_POSICAO='"+TRB->W3_POSICAO+"' "
				cQuery2 += " AND D_E_L_E_T_ = '' "

				If Select("TR2") > 0
					TR2->(dbCloseArea())
				EndIf
				// Criar índice
				dbUseArea( .T.,"TOPCONN", TcGenQry( ,,cQuery2 ), "TR2", .F., .T. )
				*-------------------------------------------------------------------------------*

				If !TR2->( EOF() )
					//apMsgInfo("TR2 retornou conteúdo")
				EndIf

				SW6->( dbSetOrder(1) )
				SW6->( dbSeek( xFilial() + TR2->W7_HAWB ) )

				cW6_DI_NUM := SW6->W6_DI_NUM
				cHAWB :=TR2->W7_HAWB
			Else
				SW7->(DbSetOrder(RetOrder("SW7","W7_FILIAL+W7_PO_NUM+W7_COD_I+W7_POSICAO")))
				If SW7->( dbSeek( xFilial() + SUBSTR(TRB->W2_PO_NUM,1,15) + TRB->W3_COD_I + TRB->W3_POSICAO ) )
					//apMsgInfo("SW7 entrou no seek")
					SW6->( dbSetOrder(1) )
					SW6->( dbSeek( xFilial() + SW7->W7_HAWB ) )
					cW6_DI_NUM := SW6->W6_DI_NUM
					cHAWB :=SW7->W7_HAWB
				EndIf
			EndIf
		ELSE
			cHAWB := TRB->WN_HAWB
		ENDIF
*/
//---------------------------------------------------------------------------------------------		

		dDatanf := posicione('SF1',1,xFILIAL('SF1')+TRB->WN_DOC+TRB->WN_SDOC+TRB->A2_COD+TRB->A2_LOJA+'N','F1_EMISSAO')
//4	C7_FILIAL+C7_PRODUTO+C7_NUM+C7_ITEM+C7_SEQUEN
		dDatPC  := posicione('SC7',4,xFILIAL('SC7')+TRB->W3_COD_I+SUBSTR(TRB->W2_PO_SIGA,1,6)+TRB->W3_POSICAO+TRB->W3_POSICAO,'C7_XDATPRF')
//	W8_HAWB W8_FORN W8_FORLOJ W8_COD_I W8_PO_NUM W8_POSICAO

		cW8_INVOICE := ''
		If RetOrder("SW8","W8_FILIAL+W8_FORN+W8_FORLOJ+W8_COD_I+W8_PO_NUM+W8_POSICAO") == 1 //.or. .T.
			cQuery3 := " SELECT W8_INVOICE "
			cQuery3 += " FROM SW8010 WITH(NOLOCK)
			cQuery3 += " WHERE "
			cQuery3 += "     W8_FORN   ='"+TRB->A2_COD    +"' "
			cQuery3 += " AND W8_FORLOJ ='"+TRB->A2_LOJA   +"' "
			cQuery3 += " AND W8_COD_I  ='"+TRB->W3_COD_I  +"' "
			cQuery3 += " AND W8_PO_NUM ='"+TRB->W2_PO_NUM +"' "
			cQuery3 += " AND W8_POSICAO='"+TRB->W3_POSICAO+"' "
			cQuery3 += " AND W8_FILIAL ='"+xFilial('SW8') +"' "
			cQuery3 += " AND D_E_L_E_T_ = '' "
			If Select("TR3") > 0
				TR3->(dbCloseArea())
			EndIf
			dbUseArea( .T.,"TOPCONN", TcGenQry( ,,cQuery3 ), "TR3", .F., .T. )

			If !TR3->( EOF() )
				//apMsgInfo("TR3 retornou conteúdo")
			EndIf

			cW8_INVOICE := TR3->W8_INVOICE
		Else
			SW8->( dbSetOrder(RetOrder("SW8","W8_FILIAL+W8_FORN+W8_FORLOJ+W8_COD_I+W8_PO_NUM+W8_POSICAO")) )
			//If SW8->( dbSeek( xFilial() + TRB->A2_COD + TRB->A2_LOJA + TRB->W3_COD_I + SUBSTR(TRB->W2_PO_NUM,1,15) + TRB->W3_POSICAO ) )
			If SW8->( dbSeek( xFilial() + TRB->A2_COD + TRB->A2_LOJA + TRB->W3_COD_I + SUBSTR(TRB->W2_PO_NUM,1,20) + TRB->W3_POSICAO ) )
				//apMsgInfo("SW8 entrou no seek")
				cW8_INVOICE := SW8->W8_INVOICE
			EndIf
		EndIf

// CALCULO LEAD TIME  LT ENTREGA - COLETA     DateDiffDay (Data1, Data2)
		nLT := 0
		IF !EMPTY(TRB->W3_XENTREG) .AND. !EMPTY(TRB->W3_XCOLETA)
			nLT :=  DateDiffDay((STOD(TRB->W3_XENTREG)),(STOD(TRB->W3_XCOLETA)))
		ENDIF


//TRANSIT TIME---------------------------------------------------------
//SELECT W2_TIPO_EM,W2_ORIGEM,W2_DEST,* FROM SW2010
//SELECT * FROM SIX010 WHERE INDICE='SYR'--(2)   YR_FILIAL+YR_VIA+YR_DESTINO+YR_ORIGEM
		nTRSTIME :=POSICIONE('SYR',2,xFILIAL('SYR')+TRB->W2_TIPO_EM+TRB->W2_DEST+TRB->W2_ORIGEM,'YR_TRANS_T')
//MODAL----------------------------------------------------------------------
//SYQ    1     YQ_FILIAL+YQ_VIA///YQ_COD_DI
		IF EMPTY(TRB->W3_XMODAL)
			cMODAL :=POSICIONE('SYQ',1,xFILIAL('SYQ')+TRB->W2_TIPO_EM,'YQ_COD_DI')
		ELSE
			cMODAL := TRB->W3_XMODAL
		ENDIF
		lGRAVA:=.T.

		IF !EMPTY(cXmodal)
			IF substring(cXmodal,1,1)==substring(cModal,1,1)
				lGRAVA:=.T.
			ELSE
				lGRAVA:=.F.

			ENDIF
		ENDIF

		//------------------
	 /*
	 SELECT TOP 3 * FROM TRANSIT_TIME

     YR_ORIGEM YR_VIA YQ_COD_DI       YR_TRANS_T
     --------- ------ --------------- ----------------------
     BOM       03     1-Maritimo      45
     BUS       03     1-Maritimo      60
     GOT       03     1-Maritimo      45
     */
		cQRYTIME :=" SELECT YR_TRANS_T FROM TRANSIT_TIME "
		cQRYTIME +=" WHERE YR_ORIGEM='"+alltrim(TRB->W2_ORIGEM)+"' AND  SUBSTRING(YQ_COD_DI,1,1)='"+SUBSTR(cMODAL,1,1)+"' "
		If Select("TR8") > 0
			TR8->(dbCloseArea())
		EndIf
		dbUseArea( .T.,"TOPCONN", TcGenQry( ,,cQRYTIME ), "TR8", .F., .T. )
		nTRSTIME:=TR8->YR_TRANS_T
		If Select("TR8") > 0
			TR8->(dbCloseArea())
		EndIf
		//IF cHAWB=='IMP 4690/21'
		//  MSGALERT(TRB->W2_ORIGEM +' '+ cMODAL+ '  '+STR(nTRSTIME))
		//  MSGALERT(cQRYTIME)
		//ENDIF
		//------------------

		IF !EMPTY(cimp) .and. lGRAVA==.T.
			IF ALLTRIM(CIMP)$ALLTRIM(cHAWB)
				lGRAVA:=.T.
			ELSE
				lGRAVA:=.F.
			ENDIF
		ENDIF
		*-------------------------------------------------------------------------------------*
		IF substr(cComboBox6,1,1)=='N' .and. empty(cimp)// .or.substr(cimp,1,3)=='ABE' .or.substr(cimp,1,3)=='abe' )
			IF ALLTRIM(TRB->W3_XMODAL)=='B-COURIER'
				lGRAVA:=.F.
			ELSE
				if  !EMPTY(cHAWB)
					lGRAVA:=.F.
				ELSE
					lGRAVA:=.T.
				endif
			ENDIF
		ENDIF
		*-------------------------------------------------------------------------------------*
		IF substr(cComboBox6,1,1)=='S' .and. empty(cimp) // .or.substr(cimp,1,3)=='EMB' .or.substr(cimp,1,3)=='emb' )
			IF ALLTRIM(TRB->W3_XMODAL)=='B-COURIER'
				lGRAVA:=.T.
			ELSE
				if  EMPTY(cHAWB)
					lGRAVA:=.F.
				ELSE
					lGRAVA:=.T.
				endif
			ENDIF
		ENDIF
		*-------------------------------------------------------------------------------------*
		IF lGRAVA==.F.
			nLINHA=nLINHA-1
		ENDIF

// COR LEGENDA -------------------------------------------
		IF !EMPTY(TRB->W3_XENTREG)
			oBmpAux :=oBmpVermelho
		Endif

//IF EMPTY(TRB->WN_DOC) .AND. dDatPC <DATE()
//	oBmpAux :=oBmpaZUL
//Endif
		IF ALLTRIM(TRB->W3_XMODAL)=='B-COURIER'
			oBmpAux :=oBmpLARANJA
		ENDIF
		if  !EMPTY(cHAWB) .AND. EMPTY(TRB->W3_XENTREG)
			oBmpAux :=oBmpaZUL
		ENDIF
		if  EMPTY(cHAWB) .AND. EMPTY(TRB->W3_XENTREG)
			oBmpAux :=oBmpVerde
		ENDIF
//----------------------------------------------------------------------------------
		nSLDPO :=0
		cOBS   := TRB->W3_XXOBS
		SC7->(DbSelectArea("SC7"))
		SC7->(DbSetOrder(1)) // C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN
		IF SC7->(DbSeek(xFilial("SC7")+SUBSTR(TRB->W2_PO_SIGA,1,6)+TRB->W3_POSICAO))
			IF SC7->C7_RESIDUO<>'S'
				nSLDPO :=SC7->C7_QUANT-SC7->C7_QUJE
			ELSE
				If !('Residuo' $ cOBS)
					cOBS:='Residuo '+cOBS
				ENDIF
			ENDIF
		ENDIF
//----------------------------------------------------------------------------------
		nQTDIMP:=0
		nSLDIMP:=0
		dTEMB  :=STOD(TRB->W3_XCOLETA)   //COLETA
		dDTPCOL:=STOD(TRB->W3_XDTPCOL)
		IF !EMPTY(cHAWB)

			If RetOrder("SW5","W5_FILIAL+W5_HAWB+W5_PO_NUM+W5_COD_I+W5_POSICAO") == 1 //.or. .T.
				cQRYIMP := " SELECT W5_QTDE,W5_SALDO_Q ,W5_DT_EMB FROM SW5010 WITH(NOLOCK)  "
				cQRYIMP += "  WHERE D_E_L_E_T_='' "
				cQRYIMP += "  AND W5_HAWB   ='"+cHAWB+"' "
				cQRYIMP += "  AND W5_PO_NUM ='"+TRB->W2_PO_NUM+"'  "
				cQRYIMP += "	 AND W5_COD_I  ='"+TRB->W3_COD_I+"'  "
				cQRYIMP += "	 AND W5_POSICAO='"+TRB->W3_POSICAO+"'"
				cQRYIMP += "  AND W5_FILIAL ='"+xFilial('SW5') +"' "
				cQRYIMP += "  AND D_E_L_E_T_ = '' "
				If Select("TR5") > 0
					TR5->(dbCloseArea())
				EndIf
				dbUseArea( .T.,"TOPCONN", TcGenQry( ,,cQRYIMP ), "TR5", .F., .T. )

				If !TR5->( EOF() )
					//apMsgInfo("TR5 retornou conteúdo")
				EndIf

				nQTDIMP :=TR5->W5_QTDE
				nSLDIMP :=TR5->W5_SALDO_Q
				dTEMB   :=TR5->W5_DT_EMB

				//*retirado auto*//dDTPCOL :=DaySum(STOD(TR5->W5_DT_EMB), nTRSTIME)
				//*retirado auto*//dDTPCOL := DataValida(dDTPCOL,.T.)

			Else
				SW5->( dbSetOrder(RetOrder("SW5","W5_FILIAL+W5_HAWB+W5_PO_NUM+W5_COD_I+W5_POSICAO")) )
				//If SW5->( dbSeek( xFilial() + cHAWB + SUBSTR(TRB->W2_PO_NUM,1,15) + TRB->W3_COD_I + TRB->W3_POSICAO ) )
				If SW5->( dbSeek( xFilial() + cHAWB + SUBSTR(TRB->W2_PO_NUM,1,20) + TRB->W3_COD_I + TRB->W3_POSICAO ) )
					//apMsgInfo("SW5 entrou no seek")
					nQTDIMP := SW5->W5_QTDE
					nSLDIMP := SW5->W5_SALDO_Q
					dTEMB   := SW5->W5_DT_EMB

					//*retirado auto*//dDTPCOL := DaySum((SW5->W5_DT_EMB), nTRSTIME)
					//*retirado auto*//dDTPCOL := DataValida(dDTPCOL,.T.)

				EndIf
			EndIf
		ENDIF


//------------Data coleta pelo embarque SW6-----------------------------
		cQRYTIME :=" SELECT YR_TRANS_T FROM TRANSIT_TIME "
		cQRYTIME +=" WHERE YR_ORIGEM='"+alltrim(TRB->W2_ORIGEM)+"' AND  SUBSTRING(YQ_COD_DI,1,1)='"+SUBSTR(cMODAL,1,1)+"' "
		If Select("TR8") > 0
			TR8->(dbCloseArea())
		EndIf
		dbUseArea( .T.,"TOPCONN", TcGenQry( ,,cQRYTIME ), "TR8", .F., .T. )
		nTRSTIME:=TR8->YR_TRANS_T
		If Select("TR8") > 0
			TR8->(dbCloseArea())
		EndIf

		IF !EMPTY(cHAWB)
			SW6->( dbSetOrder(RetOrder("SW6","W6_FILIAL+W6_HAWB")) )
			If SW6->( dbSeek( xFilial() + cHAWB ) )
				dTEMB   := SW6->W6_DT_EMB

				//*retirado auto*//dDTPCOL := DaySum((SW6->W6_DT_EMB), nTRSTIME)
				//*retirado auto*//dDTPCOL := DataValida(dDTPCOL,.T.)

				IF nTRSTIME<=0
					MSGALERT('Transit Time Origem '+TRB->W2_ORIGEM+' Modal '+cMODAL+' = '+STR(nTRSTIME))
				endif

			EndIf
		ENDIF


		//IF alltrim(cHAWB)=='IMP 4690/21'
		//  MSGALERT(TRB->W2_ORIGEM +' '+ cMODAL+ '  '+STR(nTRSTIME))
		//  MSGALERT(cQRYTIME)
		//ENDIF
		//-----------------------------------------------------------------------

		nSLDIMP:=0

		cQRYIMP := " SELECT SUM(W5_QTDE) AS XQTDIMP FROM "+RETSQLNAME('SW5')+"  "
		cQRYIMP += " WHERE D_E_L_E_T_='' AND  W5_PO_NUM='"+TRB->W2_PO_NUM+"' "
		cQRYIMP += " AND  W5_POSICAO='"+TRB->W3_POSICAO+"' AND W5_SEQ<>0
		cQRYIMP += " AND  W5_COD_I  ='"+TRB->W3_COD_I+"'  "
		cQRYIMP += " AND W5_FILIAL='"+xFILIAL('SW5')+"' "
		If Select("TR6") > 0
			TR6->(dbCloseArea())
		EndIf
		dbUseArea( .T.,"TOPCONN", TcGenQry( ,,cQRYIMP ), "TR6", .F., .T. )

		If Select("TR6") > 0
			If !('Residuo' $ cOBS)
				nSLDIMP:=TRB->W3_QTDE-TR6->XQTDIMP
			ELSE
				nSLDIMP:=0
			ENDIF
			TR6->(dbCloseArea())
		EndIf


		dPRVRDT:=STOD(TRB->W3_XPRDSB)
		IF !EMPTY(TRB->W3_XETA)
			dPRVRDT := DaySum(STOD(TRB->W3_XETA), 3)
			dPRVRDT := DataValida(dPRVRDT,.T.)
		ENDIF
		IF !EMPTY(TRB->W3_XPRALER)
			dPRVRDT := DaySum(STOD(TRB->W3_XPRALER) , 3)
			dPRVRDT := DataValida(dPRVRDT,.T.)
		ENDIF

//SELECT W5_QTDE,* FROM SW5010  WHERE W5_HAWB='IMP 4612/21' AND W5_PO_NUM='I0011310' AND W5_COD_I='121F0304L' AND W5_POSICAO='0001'
//W5_PO_NUM=W2_PO_NUM AND W5_COD_I=W3_COD_I  AND W5_HAWB<>'' AND W5_POSICAO=W3_POSICAO
//----------------------------------------------------------------------------------
        IF lGRAVA == .T.
			/*    01 @BMP                   */	AADD(aCols1, {oBmpAux   ,  ;
				/*02 Linha       ZZT_NLINHA */	Transform(nLINHA,"@E 99999") ,;
				/*03 Origin      ZZT_ORIGIN */	TRB->W2_ORIGEM+'-'+TRB->CCH_PAIS  ,;
				/*04 PO          ZZT_PO_NUM */	TRB->W2_PO_NUM+'/'+TRB->W3_POSICAO ,;
				/*05 PO SIGA     ZZT_PO_SIG */	TRB->W2_PO_SIGA ,;
				/*06 PO Date     ZZT_DT_PO  */	StoD(TRB->W2_PO_DT) ,;
				/*07 Sup Cod     ZZT_SUPCOD */	TRB->A2_COD+'/'+TRB->A2_LOJA ,;
				/*08 Supplier    ZZT_SUPPLI */	TRB->A2_NREDUZ ,;
				/*09 PN          ZZT_COD_I  */	TRB->W3_COD_I ,;
				/*10 PN Fornec   ZZT_CODFOR */	cCODPRF ,;
				/*11 Description ZZT_DESCR  */	TRB->B1_DESC ,;
				/*12 Qty         ZZT_QUANT  */	TRB->W3_QTDE ,;
				/*13 Unit Price  ZZT_VL_UNI */	TRB->W3_PRECO ,;
				/*14 Total Price ZZT_VL_TOT */	TRB->VL_TOT ,;
				/*15 Requested   ZZT_DTREQU */	dDatPC ,;
				/*16 Confirmed   ZZT_DTCONF */	STOD(TRB->W3_XCONFDT) ,;
				/*17 New Date    ZZT_DTNEW  */	STOD(TRB->W3_XNEWDT) ,;
				/*18 Pre PortXrddZZT_DTPPOR */	STOD(TRB->W3_XPRVPO) ,;
				/*19 Pag Antec.  ZZT_PGTANT */	TRB->W2_DIAS_PA ,;
				/*20 Modal       ZZT_MODAL SUBSTR(TRB->W3_XMODAL,1,1)  */	cMODAL,;
				/*21 IMP         ZZT_HAWB   */	cHAWB ,;
				/*22 Coleta      ZZT_DTCOLE 	STOD(TRB->W3_XCOLETA) */   dTEMB,;
				/*23 Prv ColxRdt ZZT_DTPCOL 	STOD(TRB->W3_XDTPCOL)*/   dDTPCOL,;
				/*24 Freight     ZZT_FREIGH */	TRB->W3_XFREIGT ,;
				/*25 ETD         ZZT_ETD    */	STOD(TRB->W3_XETD) ,;
				/*26 ETA         ZZT_ETA    */	STOD(TRB->W3_XETA) ,;
				/*27 Pre Alerta  ZZT_DTALER */	STOD(TRB->W3_XPRALER) ,;
				/*28 Prev Rdt    ZZT_PRVRDT 	STOD(TRB->W3_XPRDSB) */  dPRVRDT,;
				/*29 Prev Rdt    ZZT_HOUSE  */	TRB->W3_XHOUSE ,;
				/*30 Obs         ZZT_OBS    */	cOBS ,;
				/*31 Entrega     ZZT_ENTREG */	STOD(TRB->W3_XENTREG) ,;
				/*32 Lead Time   ZZT_LT     */	nLT ,;
				/*33 DI          ZZT_DI     */	cW6_DI_NUM ,;
				/*34 Invoice     ZZT_INVOIC */	cW8_INVOICE,;
				/*35 Nota Fiscal ZZT_NFISCA */	IIF(!EMPTY(TRB->WN_DOC),TRB->WN_DOC+' '+TRB->WN_SDOC+'/'+TRB->WN_ITEM,'') ,;
				/*36 Qtde nfe    ZZT_QTDNFE */	TRB->WN_QUANT ,;
				/*37 Data NF     ZZT_DTNF   */	dDatanf ,;
				/*38 Sld_PO_Qty  ZZT_SLDPO  */	nSLDPO ,;				
				/*39 Qty_IMP     ZZT_QTDIMP */	nQTDIMP ,;				
				/*40 SLD_PO_IMP  ZZT_SLD_PO */	nSLDIMP ,;								
				/*41 Transit time           */	nTRSTIME ,;
				/*42 FLAG                   */ .F. })
		ENDIF

		TRB->(DbSkip())
	EndDo

	IF nLINHA == 0
		/*    01 @BMP                   */	AADD(aCols1, {' '   ,  ;
			/*02 Linha       ZZT_NLINHA */	Transform(nLINHA,"@E 99999") ,;
			/*03 Origin      ZZT_ORIGIN */	' ' ,;
			/*04 PO          ZZT_PO_NUM */	' ' ,;
			/*05 PO SIGA     ZZT_PO_SIG */	' ' ,;
			/*06 PO Date     ZZT_DT_PO  */	' ' ,;
			/*07 Sup Cod     ZZT_SUPCOD */	' ' ,;
			/*08 Supplier    ZZT_SUPPLI */	' ' ,;
			/*09 PN          ZZT_COD_I  */	' ' ,;
			/*10 PN Fornec   ZZT_CODFOR */	' ' ,;
			/*11 Description ZZT_DESCR  */	' ' ,;
			/*12 Qty         ZZT_QUANT  */	' ' ,;
			/*13 Unit Price  ZZT_VL_UNI */	' ' ,;
			/*14 Total Price ZZT_VL_TOT */	' ' ,;
			/*15 Requested   ZZT_DTREQU */	' ' ,;
			/*16 Confirmed   ZZT_DTCONF */	' ' ,;
			/*17 New Date    ZZT_DTNEW  */	' ' ,;
			/*18 Pre PortXrddZZT_DTPPOR */	' ' ,;
			/*19 Pag Antec.  ZZT_PGTANT */	' ' ,;
			/*20 Modal       ZZT_MODAL SUBSTR(TRB->W3_XMODAL,1,1)  */	' ',;
			/*21 IMP         ZZT_HAWB   */	' ' ,;
			/*22 Coleta      ZZT_DTCOLE */	' ' ,;
			/*23 Prv ColxRdt ZZT_DTPCOL */	' ' ,;
			/*24 Freight     ZZT_FREIGH */	' ' ,;
			/*25 ETD         ZZT_ETD    */	' ' ,;
			/*26 ETA         ZZT_ETA    */	' ' ,;
			/*27 Pre Alerta  ZZT_DTALER */	' ' ,;
			/*28 Prev Rdt    ZZT_PRVRDT */	' ' ,;
			/*29 Prev Rdt    ZZT_HOUSE  */	' ' ,;
			/*30 Obs         ZZT_OBS    */	' ' ,;
			/*31 Entrega     ZZT_ENTREG */	' ' ,;
			/*32 Lead Time   ZZT_LT     */	' ' ,;
			/*33 DI          ZZT_DI     */	' ' ,;
			/*34 Invoice     ZZT_INVOIC */	' ' ,;
			/*35 Nota Fiscal ZZT_NFISCA */	' ' ,;
			/*36 Qtde nfe    ZZT_QTDNFE */	' ' ,;
			/*37 Data NF     ZZT_DTNF   */	' ' ,;
			/*38 Sld_PO_Qty  ZZT_SLDPO  */	' ' ,;						
            /*39 QTY_IMP     ZZT_QTDIMP */	' ' ,;									
            /*40 SLD_PO_IMP  ZZT_SLD_PO */	' ' ,;												
			/*41 Transit time           */	' ' ,;
			/*42 FLAG                   */ .T. })
	ENDIF

	TRB->(DbCloseArea())
	If Select("TR2") > 0
		TR2->(dbCloseArea())
	EndIf
	If Select("TR3") > 0
		TR3->(dbCloseArea())
	EndIf
	If Select("TR5") > 0
		TR5->(dbCloseArea())
	EndIf

	oGet:aCols:=aCols1
	oGet:oBrowse:Refresh()
	oGet:Refresh()

	cGetorig := ''
	cGetpo   := ''
	cGetSupl := ''
	cGetPN   := ''
	cGetOBS  := ''
	clinha   := ''

	oGetorig:REFRESH()
	oGetPO  :REFRESH()
	oGetSupl:REFRESH()
	oGetPN  :REFRESH()
	oGetOBS :REFRESH()
	ocLinha :REFRESH()

Return Nil

	*----------------------------------------------------------*
Static Function GETDCLR(aLinha,nLinha,aHeader)
	*----------------------------------------------------------*
	Local nCor2 := 16776960 // Ciano - RGB(0,255,255)
	Local nCor3 := 16777215 // Branco - RGB(255,255,255)
	//Local nCor4 := 4227327
	Local nRet := nCor3

	IF Mod(nLinha,2) > 0
		nRet := nCor2
	ENDIF

	IF Mod(nLinha,2) <> 0
		nRet := nCor3
	ENDIF

	//if aLinha[nLinha][4]='I0010998'
	//	nRet := nCor4
	//endif

Return nRet

	*----------------------------------------------------------*
USER FUNCTION FLWUPCHG(oGet)
	*----------------------------------------------------------*
	LOCAL nLIN :=oGet:nat

	Local nPos02 := aScan(aHeader,{|x|AllTrim(x[2])=="ZZT_NLINHA"})
	Local nPos03 := aScan(aHeader,{|x|AllTrim(x[2])=="ZZT_ORIGIN"})
	Local nPos04 := aScan(aHeader,{|x|AllTrim(x[2])=="ZZT_PO_NUM"})
	Local nPos05 := aScan(aHeader,{|x|AllTrim(x[2])=="ZZT_PO_SIG"})
	Local nPos08 := aScan(aHeader,{|x|AllTrim(x[2])=="ZZT_SUPPLI"})
	Local nPos09 := aScan(aHeader,{|x|AllTrim(x[2])=="ZZT_COD_I" })
	//Local nPos11 := aScan(aHeader,{|x|AllTrim(x[2])=="ZZT_DESCR" })
	Local nPos30 := aScan(aHeader,{|x|AllTrim(x[2])=="ZZT_OBS"})

	cGetorig := oGet:aCOLS[nLIN][nPos03]
	cGetpo   := alltrim(oGet:aCOLS[nLIN][nPos04])+' '+alltrim(oGet:aCOLS[nLIN][nPos05])
	cGetSupl := alltrim(oGet:aCOLS[nLIN][nPos08])
	cGetPN   := alltrim(oGet:aCOLS[nLIN][nPos09])//+' - '+alltrim(oGet:aCOLS[nLIN][nPos11])
	cGetOBS  := alltrim(oGet:aCOLS[nLIN][nPos30])

	clinha   := alltrim(oGet:aCOLS[nLIN][nPos02])

	oGetorig:REFRESH()
	oGetPO  :REFRESH()
	oGetSupl:REFRESH()
	oGetPN  :REFRESH()
	oGetOBS :REFRESH()
	ocLinha :REFRESH()

RETURN

	*----------------------------------------------------------*
STATIC FUNCTION FDESENV()
	*----------------------------------------------------------*
	MSGALERT('EM DESENVOLVIMENTO')
RETURN

	*----------------------------------------------------------*
User Function FLWUPLEG()
	*----------------------------------------------------------*
	Local aLegenda := {}
	Local cCadastro := OemtoAnsi("Follow UP - SIGAEIC")

	AADD(aLegenda,{"BR_VERDE"     ,"Sem IMP sem data entrega " })
	AADD(aLegenda,{"BR_VERMELHO"  ,"Com data Entrega " })
	AADD(aLegenda,{"BR_PRETO"  ," " })
	AADD(aLegenda,{"BR_AZUL"      ,"Com IMP sem Entrega " })
	aAdd(aLegenda,{"BR_AMARELO"	  ," " })
	AADD(aLegenda,{"BR_VIOLETA"   ," " })
	AADD(aLegenda,{"BR_LARANJA"    ,"Courie " })

	BrwLegenda(cCadastro,"Legenda" ,aLegenda)

Return Nil

	*----------------------------------------------------------*
USER FUNCTION fGRVZZT(NLIN,lFST)
	*----------------------------------------------------------*
	/*16*/       Local nPos16 := aScan(aHeader,{|x|AllTrim(x[2])=="ZZT_DTCONF"})
	/*17*/       Local nPos17 := aScan(aHeader,{|x|AllTrim(x[2])=="ZZT_DTNEW"})
	/*18*/       Local nPos18 := aScan(aHeader,{|x|AllTrim(x[2])=="ZZT_DTPPOR"})
	/*20*/       Local nPos20 := aScan(aHeader,{|x|AllTrim(x[2])=="ZZT_MODAL"})
	/*22*/       Local nPos22 := aScan(aHeader,{|x|AllTrim(x[2])=="ZZT_DTCOLE"})
	/*23*/       Local nPos23 := aScan(aHeader,{|x|AllTrim(x[2])=="ZZT_DTPCOL"})
	/*24*/       Local nPos24 := aScan(aHeader,{|x|AllTrim(x[2])=="ZZT_FREIGH"})
	/*25*/       Local nPos25 := aScan(aHeader,{|x|AllTrim(x[2])=="ZZT_ETD"})
	/*26*/       Local nPos26 := aScan(aHeader,{|x|AllTrim(x[2])=="ZZT_ETA"})
	/*27*/       Local nPos27 := aScan(aHeader,{|x|AllTrim(x[2])=="ZZT_DTALER"})
	/*28*/       Local nPos28 := aScan(aHeader,{|x|AllTrim(x[2])=="ZZT_PRVRDT"})
	/*29*/       Local nPos29 := aScan(aHeader,{|x|AllTrim(x[2])=="ZZT_HOUSE"})
	/*30*/       Local nPos30 := aScan(aHeader,{|x|AllTrim(x[2])=="ZZT_OBS"})
	/*31*/       Local nPos31 := aScan(aHeader,{|x|AllTrim(x[2])=="ZZT_ENTREG"})
	/*32*/       Local nPos32 := aScan(aHeader,{|x|AllTrim(x[2])=="ZZT_LT"})

	/*02*/       Local nPos02 := aScan(aHeader,{|x|AllTrim(x[2])=="ZZT_PO_NUM"})
	/*03*/       Local nPos03 := aScan(aHeader,{|x|AllTrim(x[2])=="ZZT_PO_SIG"})

	//cPEDIDO  :=SUBSTR(aCols[N][nPos02],01,15) //I0011387          /0001
	//cPOSICAO :=SUBSTR(aCols[N][nPos02],20,04) // PRODUCAO    "I0011387          /0001"
	cPEDIDO  :=SUBSTR(aCols[N][nPos02],01,20)
	cPOSICAO :=SUBSTR(aCols[N][nPos02],25,04)   // HOMOLOGACAO "I0011575               /0001"
	cPOSIGA  :=aCols[N][nPos03]

	DbSelectArea("SW3")
	SW3->(DbSetOrder(8)) // 8     W3_FILIAL+W3_PO_NUM+W3_POSICAO
	SW3->(DbSeek(xFilial("SW3")+cPEDIDO+cPOSICAO))
	While SW3->(!Eof()) .And. SW3->W3_PO_NUM == cPEDIDO .And. SW3->W3_POSICAO == cPOSICAO
		nLT :=0
		IF !EMPTY(aCols[N][nPos31]) .AND. !EMPTY(aCols[N][nPos22])
			nLT :=  DateDiffDay(aCols[N][nPos31],aCols[N][nPos22])
		ENDIF
		M->ZZT_LT        :=  nLT
		aCols[N][nPos32] :=  nLT
		dDTFUP1 :=DATE()
		dDTFUP2 :=DATE()
		dDTFUP3 :=DATE()
		dDTFUP  :=DATE()
		lDTFUP  :=.F.

		//-------------------transit time
		IF !EMPTY(aCols[N][nPos16]) //ZZT_DTCONF
			dPRV := DaySum(aCols[N][nPos16], aCols[N][41]) //DaySum(Data, nDias)
			dPRV := DataValida(dPRV,.T.)
			M->ZZT_DTPPOR    := dPRV
			aCols[N][nPos18] := dPRV
		ENDIF
		IF !EMPTY(aCols[N][nPos17]) //ZZT_DNEW
			dPRV := DaySum(aCols[N][nPos17], aCols[N][41]) //DaySum(Data, nDias)
			dPRV := DataValida(dPRV,.T.)
			M->ZZT_DTPPOR    := dPRV
			aCols[N][nPos18] := dPRV
		ENDIF

		IF !EMPTY(aCols[N][nPos22]) //ZZT_DTCOLE
		//*retirado auto*//
		//	dPRV := DaySum(aCols[N][nPos22], aCols[N][41]) //DaySum(Data, nDias)
		//	dPRV := DataValida(dPRV,.T.)
		//	M->ZZT_DTPCOL    := dPRV
		//	aCols[N][nPos23] := dPRV
		ENDIF

		IF !EMPTY(aCols[N][nPos26]) //ZZT_ETA
			dPRV := DaySum(aCols[N][nPos26], 3) //DaySum(Data, nDias)
			dPRV := DataValida(dPRV,.T.)
			M->ZZT_PRVRDT   := dPRV
			aCols[N][nPos28] := dPRV
		ENDIF

		IF !EMPTY(aCols[N][nPos27]) //ZZT_DTALER
			dPRV := DaySum(aCols[N][nPos27], 3) //DaySum(Data, nDias)
			dPRV := DataValida(dPRV,.T.)
			M->ZZT_PRVRDT   := dPRV
			aCols[N][nPos28] := dPRV
		ENDIF

		//-----fup--------------------------------
		IF !EMPTY(aCols[N][nPos18]) //FUP1 previsao poxrdt
			dDTFUP  :=aCols[N][nPos18]
			lDTFUP  :=.T.
		ENDIF
		dDTFUP1 :=aCols[N][nPos18]

		IF !EMPTY(aCols[N][nPos23]) //FUP2 previsao coletaxrdt
			dDTFUP  :=aCols[N][nPos23]
			lDTFUP  :=.T.
		ENDIF
		dDTFUP2 :=aCols[N][nPos23]

		IF !EMPTY(aCols[N][nPos28]) //FUP3 desembaraco rdt
			dDTFUP  :=aCols[N][nPos28]
			lDTFUP  :=.T.
		ENDIF
		dDTFUP3 :=aCols[N][nPos28]
		//------------------------------------------

		RecLock("SW3",.F.)
		/*16*/   SW3->W3_XCONFDT :=   aCols[N][nPos16]
		/*17*/   SW3->W3_XNEWDT  :=   aCols[N][nPos17]
		/*18*/   SW3->W3_XPRVPO  :=   aCols[N][nPos18]
		/*20*/   SW3->W3_XMODAL  :=   aCols[N][nPos20]
		/*22*/   SW3->W3_XCOLETA :=   aCols[N][nPos22]
		/*23*/   SW3->W3_XDTPCOL :=   aCols[N][nPos23]
		/*24*/   SW3->W3_XFREIGT :=   aCols[N][nPos24]
		/*25*/   SW3->W3_XETD    :=   aCols[N][nPos25]
		/*26*/   SW3->W3_XETA    :=   aCols[N][nPos26]
		/*27*/   SW3->W3_XPRALER :=   aCols[N][nPos27]
		/*28*/   SW3->W3_XPRDSB  :=   aCols[N][nPos28]
		/*29*/   SW3->W3_XHOUSE  :=   aCols[N][nPos29]
		/*30*/   SW3->W3_XXOBS   :=   aCols[N][nPos30]
		/*31*/   SW3->W3_XENTREG :=   aCols[N][nPos31]
		IF lDTFUP ==.T.
			SW3->W3_DT_ENTR :=dDTFUP
		ENDIF
		SW3->(MsUnlock())

		SC7->(DbSelectArea("SC7"))
		SC7->(DbSetOrder(1)) // C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN
		IF SC7->(DbSeek(xFilial("SC7")+cPOSIGA+cPOSICAO))
			RecLock("SC7",.F.)
			IF !EMPTY(dDTFUP1)
				SC7->C7_DMXOB1 :=DTOC(dDTFUP1)
			ELSE
				SC7->C7_DMXOB1 :=SPACE(08)
			ENDIF
			IF !EMPTY(dDTFUP2)
				SC7->C7_DMXOB2 :=DTOC(dDTFUP2)
			ELSE
				SC7->C7_DMXOB2 :=SPACE(08)
			ENDIF
			IF !EMPTY(dDTFUP3)
				SC7->C7_DMXOB3 :=DTOC(dDTFUP3)
			ELSE
				SC7->C7_DMXOB3 :=SPACE(08)
			ENDIF
			IF lDTFUP ==.F.
				SC7->C7_DATPRF :=SC7->C7_XDATPRF
			ELSE
				SC7->C7_DATPRF :=dDTFUP
			ENDIF
			SC7->(MsUnlock())
		ENDIF
		lDTFUP :=.F.
		SW3->(DbSkip())
	Enddo
RETURN(cPOSIGA)

	*----------------------------------------------------------------------------------------*
USER FUNCTION RDMC050Con()
	//Local lRet		:= .T.
	/*09*/       //Local nPos09 := aScan(aHeader,{|x|AllTrim(x[2])=="ZZT_COD_I"})

	//PRIVATE aRotina := MenuDef()
	PRIVATE inclui:=.F.
	PRIVATE cCadastro:= "Consulta Geral ao Produto" //"Consulta Geral ao Produto"
	PRIVATE cXPROD:=''

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ativa tecla F12 para acessar os parametros                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//If !( lRetPE )
	//	pergunte( "MTC050", .F. )
	//Else
	////	lRet := pergunte( "MTC050", .T. )
	//EndIf

	////If ( lRet )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01        // Data inicial                              ³
	//³ mv_par02        // Data final                                ³
	//³ mv_par03        // Apresenta Movimentos                      ³
	//³ mv_par04        // Lista as Amarracoes ?                     ³
	//³ mv_par05        // Cons Saldo Em/De 3o.?                     ³
	//³ mv_par06        // De  Armazem         ?                     ³
	//³ mv_par07        // Ate Armazem         ?                     ³
	//³ mv_par08        //                                           ³
	//³ mv_par09        // Considera reservas  ?                     ³
	//³ mv_par10        // Exibir OP's encerradas ?                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//	SetKey( VK_F12, { || pergunte("MTC050",.T.) } )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Endereca a funcao de BROWSE                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//	mBrowse( 6, 1,22,75,"SB1")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Desativa tecla F12                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//	Set Key VK_F12	To
	//EndIf



	nCLN:=VAL(cLINHA)
	//MSGALERT(oGet:aCols[nCLN][nPos09])
	dbSelectArea("SB1")
	dbSetOrder(1)
	//DbSeek(xFilial("SB1")+ot:aCoGels[nCLN][nPos09])
	DbSeek(xFilial("SB1")+cGetPN)
	//cGetPN
	cXPROD :=SB1->B1_COD
	//MsgRun("Consulta Produto "+oGet:aCols[nCLN][nPos09],"Aguarde...",{|| U_FLWCONPRD() })
	MsgRun("Consulta Produto "+cGetPN,"Aguarde...",{|| U_FLWCONPRD() })
Return Nil

USER FUNCTION FLWCONPRD()

	PRIVATE inclui:=.F.

	//{"S4WB005N",	{|| MaComView(SB1->B1_COD) }, STR0075, STR0080 }} // "Consulta Historico do Produto"

	MaComView(cGetPN) // "Consulta Historico do Produto"
	//MC050Con()

RETURN
	*----------------------------------------------------------------------------------------*
	*----------------------------------------------------------------------------------------*
USER FUNCTION RDMC050B()
	//Local   lRet	  := .T.

	/*09*/       //Local nPos09 := aScan(aHeader,{|x|AllTrim(x[2])=="ZZT_COD_I"})

	PRIVATE aRotina := MenuDef()
	PRIVATE inclui:=.F.
	PRIVATE lfalse:=.F.
	PRIVATE cCadastro:= "Consulta Geral ao Produto" //"Consulta Geral ao Produto"
	PRIVATE cXPROD:=''

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ativa tecla F12 para acessar os parametros                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	pergunte( "MTC050", .F. )
	//If !( lRet )
	//	pergunte( "MTC050", .F. )
	//Else
	//	lRet := pergunte( "MTC050", .T. )
	//EndIf

	////If ( lRet )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01        // Data inicial                              ³
	//³ mv_par02        // Data final                                ³
	//³ mv_par03        // Apresenta Movimentos                      ³
	//³ mv_par04        // Lista as Amarracoes ?                     ³
	//³ mv_par05        // Cons Saldo Em/De 3o.?                     ³
	//³ mv_par06        // De  Armazem         ?                     ³
	//³ mv_par07        // Ate Armazem         ?                     ³
	//³ mv_par08        //                                           ³
	//³ mv_par09        // Considera reservas  ?                     ³
	//³ mv_par10        // Exibir OP's encerradas ?                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//	SetKey( VK_F12, { || pergunte("MTC050",.T.) } )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Endereca a funcao de BROWSE                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//	mBrowse( 6, 1,22,75,"SB1")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Desativa tecla F12                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//	Set Key VK_F12	To
	//EndIf

	nCLN:=VAL(cLINHA)
	//MSGALERT(oGet:aCols[nCLN][nPos09])
	dbSelectArea("SB1")
	dbSetOrder(1)
	//DbSeek(xFilial("SB1")+ot:aCoGels[nCLN][nPos09])
	DbSeek(xFilial("SB1")+cGetPN)
	cXPROD :=SB1->B1_COD
	//MsgRun("Consulta Produto "+oGet:aCols[nCLN][nPos09],"Aguarde...",{|| U_FLWCONPRD() })
	MsgRun("Consulta Produto "+cGetPN,"Aguarde...",{|| U_FLWCONP2() })
Return Nil

USER FUNCTION FLWCONP2()

	PRIVATE inclui:=.F.
	PRIVATE lfalse:=.F.

	//{"S4WB005N",	{|| MaComView(SB1->B1_COD) }, STR0075, STR0080 }} // "Consulta Historico do Produto"

	//MaComView(cGetPN) // "Consulta Historico do Produto"
	MC050Con()

RETURN
	*----------------------------------------------------------------------------------------*


USER FUNCTION RDMTA061()
	MsgRun("Consulta Produto x Fornecedor ","Aguarde...",{|| MATA061() })
RETURN nil





//STATIC FUNCTION fGRAVAZZT()

	//startjob("U_GRAVAZZT",getenvserver(), .F. , cEmpAnt, cFilAnt, aCols1)

//Return

//User Function GRAVAZZT(_cEmpresa, _cFilial, aCols1)
STATIC FUNCTION fGRAVAZZT()
	Local nX:=0
	Local cQRDEL1:=''

//	aAbreTab := {}
//	RPCSetType(3)
//	RpcSetEnv(_cEmpresa, _cFilial,,,,,aAbreTab)
    For nX := 1 to len (aCols1)
		cQRDEL1:=" DELETE FROM ZZT010 WHERE ZZT_PO_NUM ='"+acols1[nX][04]+"' "
		TCSqlExec(cQRDEL1)
	next nx
   // HOMOLOGACAO "I0011575               /0001"
	//--------------------------------------------------------------------------------------------------------------------------------------
	cQRDEL2 := " DELETE FROM ZZT010 WHERE SUBSTRING(ZZT_PO_SIG,1,6)+SUBSTRING(ZZT_PO_NUM,25,4) NOT IN  "
	cQRDEL2 += " (SELECT C7_NUM+C7_ITEM FROM SC7010  WHERE C7_NUM=SUBSTRING(ZZT_PO_SIG,1,6) AND C7_ITEM=SUBSTRING(ZZT_PO_NUM,25,4) AND D_E_L_E_T_='') "
	cQRDEL2 += " AND SUBSTRING(ZZT_PO_NUM,1,2)<>'DA' AND ZZT_NFISCA='' "
	TCSqlExec(cQRDEL2)
	//---------------------------------------------------------------------------------------------------

	dbSelectArea("ZZT")
	ZZT->(dbSetOrder(1)) //ZZT_FILIAL+ZZT_PO_NUM

	For nX := 1 to len (aCols1)
		IF !EMPTY(aCols1[nX][04])
			RECLOCK('ZZT',.T.)
			ZZT_FILIAL :=xFILIAL('ZZT')
			/*    01 @BMP                        AADD(aCols1, {' '   ,  ; */
			/*02 Linha       ZZT_NLINHA 	Transform(nLINHA,"@E 99999") ,; */
			/*03 Origin       */ ZZT_ORIGIN :=aCols1[nX][03]
			/*04 PO           */ ZZT_PO_NUM :=aCols1[nX][04]
			/*05 PO SIGA      */ ZZT_PO_SIG :=aCols1[nX][05]
			/*06 PO Date      */ ZZT_DT_PO  :=aCols1[nX][06]
			/*07 Sup Cod      */ ZZT_SUPCOD :=aCols1[nX][07]
			/*08 Supplier     */ ZZT_SUPPLI :=aCols1[nX][08]
			/*09 PN           */ ZZT_COD_I  :=aCols1[nX][09]
			/*10 PN Fornec    */ ZZT_CODFOR :=aCols1[nX][10]
			/*11 Description  */ ZZT_DESCR  :=aCols1[nX][11]
			/*12 Qty          */ ZZT_QUANT  :=aCols1[nX][12]
			/*13 Unit Price   */ ZZT_VL_UNI :=aCols1[nX][13]
			/*14 Total Price  */ ZZT_VL_TOT :=aCols1[nX][14]
			/*15 Requested    */ ZZT_DTREQU :=aCols1[nX][15]
			/*16 Confirmed    */ ZZT_DTCONF :=aCols1[nX][16]
			/*17 New Date     */ ZZT_DTNEW  :=aCols1[nX][17]
			/*18 Pre PortXrdd */ ZZT_DTPPOR :=aCols1[nX][18]
			/*19 Pag Antec.   */ ZZT_PGTANT :=aCols1[nX][19]
			/*20 Modal        */ ZZT_MODAL  :=aCols1[nX][20]
			/*21 IMP          */ ZZT_HAWB   :=aCols1[nX][21]
			/*22 Coleta       */ ZZT_DTCOLE :=aCols1[nX][22]
			/*23 Prv ColxRdt  */ ZZT_DTPCOL :=aCols1[nX][23]
			/*24 Freight      */ ZZT_FREIGH :=aCols1[nX][24]
			/*25 ETD          */ ZZT_ETD    :=aCols1[nX][25]
			/*26 ETA          */ ZZT_ETA    :=aCols1[nX][26]
			/*27 Pre Alerta   */ ZZT_DTALER :=aCols1[nX][27]
			/*28 Prev Rdt     */ ZZT_PRVRDT :=aCols1[nX][28]
			/*29 Prev Rdt     */ ZZT_HOUSE  :=aCols1[nX][29]
			/*30 Obs          */ ZZT_OBS    :=aCols1[nX][30]
			/*31 Entrega      */ ZZT_ENTREG :=aCols1[nX][31]
			/*32 Lead Time    */ ZZT_LT     :=aCols1[nX][32]
			/*33 DI           */ ZZT_DI     :=aCols1[nX][33]
			/*34 Invoice      */ ZZT_INVOIC :=aCols1[nX][34]
			/*35 Nota Fiscal  */ ZZT_NFISCA :=aCols1[nX][35]
			/*36 Qtde nfe     */ ZZT_QTDNFE :=aCols1[nX][36]
			/*37 Data NF      */ ZZT_DTNF   :=aCols1[nX][37]
			/*38 Sld_PO_Qty   */ ZZT_SLDPO  :=aCols1[nX][38] 
            /*39 QTY_IMP      */ ZZT_QTDIMP  :=aCols1[nX][39] 			
            /*40 QTY_IMP      */ ZZT_SLD_PO  :=aCols1[nX][40] 						
			/*41 Transit time            	' ' ,; */
			/*42 FLAG                    .T. }) */
			ZZT->(MsUnlock())
		ENDIF
	Next nX

return

Static Function RDEIC175()

	//Local aRotina := {}

	//Private cAvStaticCall := "EICIP175"

	//Return StaticCall(EICIP170, MenuDef)
	EICIP175()
Return



/*
dbSelectArea("ZZT")
dbSetOrder(1) //ZZT_PO_NUM+ZZT_HAWB
DbSeek(xFilial("ZZT")+cGetPN)




X3_CAMPO
----------
ZZT_CODFOR
ZZT_COD_I
ZZT_DESCR
ZZT_DI
ZZT_DTALER
ZZT_DTCOLE
ZZT_DTCONF
ZZT_DTNEW
ZZT_DTNF
ZZT_DTPCOL
ZZT_DTPPOR
ZZT_DTREQU
ZZT_DT_PO
ZZT_ENTREG
ZZT_ETA
ZZT_ETD
ZZT_FILIAL
ZZT_FREIGH
ZZT_HAWB
ZZT_HOUSE
ZZT_INVOIC
ZZT_LT
ZZT_MODAL
ZZT_NFISCA
ZZT_OBS
ZZT_ORIGIN
ZZT_PGTANT
ZZT_PO_NUM
ZZT_PO_SIG
ZZT_PRVRDT
ZZT_QTDNFE
ZZT_QUANT
ZZT_SUPCOD
ZZT_SUPPLI
ZZT_VL_TOT
ZZT_VL_UNI




/*
 X3_ORDEM X3_CAMPO
-------- ----------
01       ZZT_FILIAL   XXXXX
02       ZZT_ORIGIN   XXXXX
03       ZZT_PO_NUM   XXXXX
04       ZZT_PO_SIG   XXXXX
05       ZZT_DT_PO    XXXXX
06       ZZT_SUPCOD   XXXXX
07       ZZT_SUPPLI   XXXXX
08       ZZT_COD_I    XXXXX
09       ZZT_CODFOR   XXXXX
10       ZZT_DESCR    XXXXX
11       ZZT_QUANT    XXXXX
12       ZZT_VL_UNI   XXXXX
13       ZZT_VL_TOT   XXXXX
14       ZZT_DTREQU   XXXXX
15       ZZT_DTCONF  W3_XCONFDT
16       ZZT_DTNEW   W3_XNEWDT
17       ZZT_DTPPOR  W3_XPRVPO
18       ZZT_PGTANT   XXXXX
19       ZZT_MODAL  <--------  W3_XMODAL
20       ZZT_HAWB     XXXXX
21       ZZT_DTCOLE  W3_XCOLETA
22       ZZT_DTPCOL <---------- W3_DTPCOL
23       ZZT_FREIGH  W3_XFREIGT
24       ZZT_ETD     W3_XETD
25       ZZT_ETA     W3_XETA
26       ZZT_DTALER  W3_XPRALER
27       ZZT_PRVRDT  W3_XPRDSB
28       ZZT_HOUSE    XXXXX
29       ZZT_OBS     W3_XXOBS
30       ZZT_ENTREG  W3_XENTREG
31       ZZT_LT       XXXXX
32       ZZT_DI       XXXXX
33       ZZT_INVOIC   XXXXX
34       ZZT_NFISCA   XXXXX
35       ZZT_QTDNFE   XXXXX
36       ZZT_DTNF     XXXXX
*/

/*


quebrar linhas aglutinada po pn

requested -> data do pedido pedido por materiais não alterar solicitacao SC
confirmed -> preenchido data fornecedor.
new date  ->
pre opxrdt ->preenchido formula tela parametro data confirmed ou nova + data lead time fornecedor
pag antec -> pedido condicao 15 5   -> 901
ok modal -> preenchimento manual (aereo ou maritmo)

freight -> agente de carga dhl etc
ok etd eta -> preenchido manual
ok pre alert-> preenchido
ok pre rdt  -> preenchido

ok falta coluna awb antes da obs

ok entrega , por enqto manual
lead time-> entrega - coleta

pedido cancelado

codigo do fornecedor +nome no suplier

selecção de colunas para aparecer.

tratamento para courier, botão de encerrar

descrição ingles

realizado 40 horas
falta     40 horas
----Terminar gravar campos 10h
----Programar filtro        5h
----Gerar legendas          5h
----gravar tabela ZZT       5h
----zerar courier           5h
----dividir linha po       10h 40h

----gerar planillha Excel dinamica 10h

----configurar colunas     20h


House
   desenbaraço ou embarque -  preencher
courier ?


tela consulta:
1-) EIC / Cadastros / Produtos;
2-) EIC / Cadastros / ProdutoxFornecedor;
3-) EIC / Acompanhamentos / Status do Item

-------------------------------------------------------------------

---definir ------------
filtros
legenda
---------------------
verificar campos


documentar.
processo courir -> inicio até fim
Entrada Nota ?
Criação titulo financeiro ?
Amarraçoes-> Historico
xxxxxxx



-consultas
1-) EIC / Cadastros / Produtos;
2-) EIC / Cadastros / ProdutoxFornecedor;
3-) EIC / Acompanhamentos / Status do Item


--regra datas
--- awb - house/bL

1a previsao poxrdt fup 1
2a coleta  previsao coletaxrdt fup 2
3a previsao desembaraco rdt  fup 3

imp sim/nao


SELECT W2_TIPO_EM,W2_ORIGEM,W2_DEST,* FROM SW2010
SELECT * FROM SIX010 WHERE INDICE='SYR'--(2)   YR_FILIAL+YR_VIA+YR_DESTINO+YR_ORIGEM


	/*16*       Local nPos16 := aScan(aHeader,{|x|AllTrim(x[2])=="ZZT_DTCONF"})
	/*17*       Local nPos17 := aScan(aHeader,{|x|AllTrim(x[2])=="ZZT_DTNEW"})

nTRSTIME :=POSICIONE('2',xFILIAL('SYR')+)

IF !EMPTY(aCols[N][16]) //ZZT_DTCONF
    dPRV := DaySum(aCols[N][nPos16], aCols[N][40]) //DaySum(Data, nDias)
	dPRV := DataValida(dPRV,.T.)
	M->ZZT_DTPPOR    := dPRV
    aCols[N][nPos18] := dPRV
ENDIF
IF !EMPTY(aCols[N][17]) //ZZT_DNEW
    dPRV := DaySum(aCols[N][nPos17], aCols[N][40 //DaySum(Data, nDias)
	dPRV := DataValida(dPRV,.T.)
	M->ZZT_DTPPOR    := dPRV
    aCols[N][nPos18] := dPRV
ENDIF



MaComView



EXCEL   VIEW: FollowUpEIC
SELECT ZZT010.ZZT_ORIGIN AS 'Origin',
ZZT010.ZZT_PO_NUM AS 'PO_Num',
ZZT010.ZZT_PO_SIG AS 'PO_Siga',
CASE WHEN ZZT010.ZZT_DT_PO='' THEN  '' ELSE (CONVERT(CHAR(10),CONVERT(datetime,ZZT010.ZZT_DT_PO,103),103)) END AS 'PO_Date',
ZZT010.ZZT_SUPCOD AS 'Supplier_Cod',
ZZT010.ZZT_SUPPLI AS 'Supplier_Name',
ZZT010.ZZT_COD_I  AS 'PN',
ZZT010.ZZT_CODFOR AS 'PN_Supplier',
ZZT010.ZZT_DESCR  AS 'Description',
ZZT010.ZZT_QUANT  AS 'Qty',
ZZT010.ZZT_VL_UNI AS 'UnitPrice',
ZZT010.ZZT_VL_TOT AS 'Total_Price',
CASE WHEN ZZT010.ZZT_DTREQU='' THEN  '' ELSE (CONVERT(CHAR(10),CONVERT(datetime,ZZT010.ZZT_DTREQU,103),103)) END AS 'Requested_Date_at_RDT',
CASE WHEN ZZT010.ZZT_DTCONF='' THEN  '' ELSE (CONVERT(CHAR(10),CONVERT(datetime,ZZT010.ZZT_DTCONF,103),103)) END AS 'Confirmed_Date',
CASE WHEN ZZT010.ZZT_DTNEW ='' THEN  '' ELSE (CONVERT(CHAR(10),CONVERT(datetime,ZZT010.ZZT_DTNEW ,103),103)) END AS 'New_Date',
CASE WHEN ZZT010.ZZT_DTPPOR='' THEN  '' ELSE (CONVERT(CHAR(10),CONVERT(datetime,ZZT010.ZZT_DTPPOR,103),103)) END AS 'Previsao_POxRDT',
ZZT010.ZZT_PGTANT AS 'Prepayment',
ZZT010.ZZT_MODAL  AS 'Modal',
ZZT010.ZZT_HAWB   AS 'IMP',
CASE WHEN ZZT010.ZZT_DTCOLE='' THEN  '' ELSE (CONVERT(CHAR(10),CONVERT(datetime,ZZT010.ZZT_DTCOLE,103),103)) END AS 'Coleta',
CASE WHEN ZZT010.ZZT_DTPCOL='' THEN  '' ELSE (CONVERT(CHAR(10),CONVERT(datetime,ZZT010.ZZT_DTPCOL,103),103)) END AS 'Prvevisao_COLETAxRDT',
ZZT010.ZZT_FREIGH AS 'Freight_Forward',
CASE WHEN ZZT010.ZZT_ETD   ='' THEN  '' ELSE (CONVERT(CHAR(10),CONVERT(datetime,ZZT010.ZZT_ETD   ,103),103)) END AS 'ETD_Saida_Voo',
CASE WHEN ZZT010.ZZT_ETA   ='' THEN  '' ELSE (CONVERT(CHAR(10),CONVERT(datetime,ZZT010.ZZT_ETA   ,103),103)) END AS 'ETA_Chegada_Voo',
CASE WHEN ZZT010.ZZT_DTALER='' THEN  '' ELSE (CONVERT(CHAR(10),CONVERT(datetime,ZZT010.ZZT_DTALER,103),103)) END AS 'Pre_Alerta',
CASE WHEN ZZT010.ZZT_PRVRDT='' THEN  '' ELSE (CONVERT(CHAR(10),CONVERT(datetime,ZZT010.ZZT_PRVRDT,103),103)) END AS 'Previsao_Desenbaraco_x_Rdt',
ZZT010.ZZT_HOUSE AS 'House_BL',
ZZT010.ZZT_OBS AS 'Obs',
CASE WHEN ZZT010.ZZT_ENTREG='' THEN  '' ELSE (CONVERT(CHAR(10),CONVERT(datetime,ZZT010.ZZT_ENTREG,103),103)) END AS 'Entrega',
ZZT010.ZZT_LT AS 'Lead_Time', ZZT010.ZZT_DI AS 'DI', ZZT010.ZZT_INVOIC AS 'Invoice',
ZZT010.ZZT_NFISCA AS 'Nota_Fiscal',
ZZT010.ZZT_QTDNFE AS 'Qtde_nfe',
CASE WHEN ZZT010.ZZT_DTNF='' THEN  '' ELSE (CONVERT(CHAR(10),CONVERT(datetime,ZZT010.ZZT_DTNF,103),103)) END AS 'Data_NF'
FROM Protheus12.dbo.ZZT010 ZZT010
WHERE (ZZT010.D_E_L_E_T_='')-- AND ZZT010.ZZT_DT_PO>=? And ZZT010.ZZT_DT_PO<=?
ORDER BY ZZT010.ZZT_PO_NUM
*/

