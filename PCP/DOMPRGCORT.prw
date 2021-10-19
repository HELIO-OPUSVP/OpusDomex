#Include "PROTHEUS.CH"
//--------------------------------------------------------------
/*/Protheus.doc DOMPRGCORT
Description Planejamento de Corte
param xParam Parameter Description
return xRet Return Description
author  -
since 27/09/2019
/*/
//--------------------------------------------------------------
User Function DOMPRGCORT()

	Private oBitmapc1
	Private oBitmapc2
	Private oBitmapc3
	Private oBitmapc4
	Private oBitmapc5
	Private oBitmapl1
	Private oBitmapl2
	Private oBitmapl3
	Private oBitmapl4
	Private oBitmapl5
	Private oBitmapl6
	Private oBitmapl7

	Private nTmpCort 	:= 0.5 // tempo de corte
	Private nTmpMont    := 0 // tempo de montagem
	Private nYBt1 	:= 162   // Posição coluna botões "Maquina"
	Private nXBt2 	:= 115	// Posição Linha botões de "Linha de produção"
	Private nLrgBt2	:= 94
	Private nAltBt2	:= 025
	Private X1:= 5
	Private X2:= 94
	Private X3:= 05
	Private oFont10 := TFont():New("MS Sans Serif",,018,,.T.,,,,,.F.,.F.)
	Private oFont12 := TFont():New("MS Sans Serif",,020,,.T.,,,,,.F.,.F.)
	Private oFont14 := TFont():New("MS Sans Serif",,022,,.T.,,,,,.F.,.T.)
	Private oFont26 := TFont():New("MS Sans Serif",,026,,.T.,,,,,.F.,.F.)
	Private oFont2 := TFont():New("Arial",,018,,.F.,,,,,.F.,.F.)
	Private oFont3 := TFont():New("Arial",,014,,.T.,,,,,.F.,.F.)
	Private oGet1
	Private oGet2
	Private oGet3
	Private oGet4
	Private oGroup1
	Private oGroup2
	Private oSay1
	Private oSay2
	Private oSay4
	Private oSay5
	Private oSay6
	Private oCort1
	Private oCort2
	Private oCort3
	Private oCort4
	Private oCort5
	Private oLin1
	Private oLin2
	Private oLin3
	Private oLin4
	Private oLin5
	Private oLin6
	Private oLin7

	Private lCheckBo1 := .T.
	Private oCheckBo1
	Private oMsCalen1

	Private nTotCort1 := 0
	Private nTotCort2 := 0
	Private nTotCort3 := 0
	Private nTotCort4 := 0
	Private nTotCort5 := 0
	Private nTotLin1 := 0
	Private nTotLin2 := 0
	Private nTotLin3 := 0
	Private nTotLin4 := 0
	Private nTotLin5 := 0
	Private nTotLin6 := 0
	Private nTotLin7 := 0

	Private dDtIni := CriaVar("D4_DATA")
	Private dDtFim := CriaVar("D4_DATA")
	Private cOpIni := CriaVar("D4_OP")
	Private cOpFim := CriaVar("D4_OP")
	Private oOk      := LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
	Private oNo      := LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO
	Private oLegOk   := LoadBitmap( GetResources(), "BR_VERDE" )
	Private OLegNo   := LoadBitmap( GetResources(), "BR_VERMELHO" )
	Private oLegIni   := LoadBitmap( GetResources(), "BR_AMARELO" )
	Private oLegFim   := LoadBitmap( GetResources(), "BR_PINK" )

	Private oLbx := Nil
	Private aVetor := {}
	Private oButCort1
	Private oButCort2
	Private oButCort3
	Private oButCort4
	Private oButCort5
	Private oButLin1
	Private oButLin2
	Private oButLin3
	Private oButLin4
	Private oButLin5
	Private oButLin6
	Private oButLin7
	Private nTimeProd:= 480
	Private nTimeMont:= 5000


//Private aButtons:= {}
	Private _lok:= .F.
	Private dDtProg:= dDatabase
	Private c2Leg1      := "1"
	Private n2Leg1      := RGB(176,224,230)
	Private c2Leg2      := "2"
	Private n2Leg2      := RGB(248,248,255)
	Private nTpProd	:= fTpProd()
	Private cTpProd	:= ""
	Private cStartPath:= GetSrvProfString('Startpath','')
	cG0	:= cStartPath + 'gauge\gauge3\gauge0.png'
	cG1	:= cStartPath + 'gauge\gauge3\gauge1.png'
	cG2	:= cStartPath + 'gauge\gauge3\gauge2.png'
	cG3	:= cStartPath + 'gauge\gauge3\gauge3.png'
	cG4	:= cStartPath + 'gauge\gauge3\gauge4.png'
	cG5	:= cStartPath + 'gauge\gauge3\gauge5.png'
	cG6	:= cStartPath + 'gauge\gauge3\gauge6.png'
	cG7	:= cStartPath + 'gauge\gauge3\gauge7.png'
	cG8	:= cStartPath + 'gauge\gauge3\gauge8.png'
	cG9	:= cStartPath + 'gauge\gauge3\gauge9.png'
	cG10:= cStartPath + 'gauge\gauge3\gauge10.png'
	cG11:= cStartPath + 'gauge\gauge3\gauge11.png'
	cG12:= cStartPath + 'gauge\gauge3\gauge12.png'
	cG13:= cStartPath + 'gauge\gauge3\gauge13.png'
	cG14:= cStartPath + 'gauge\gauge3\gauge14.png'
	cG15:= cStartPath + 'gauge\gauge3\gauge15.png'
	cG16:= cStartPath + 'gauge\gauge3\gauge16.png'
	cG17:= cStartPath + 'gauge\gauge3\gauge17.png'
	cG18:= cStartPath + 'gauge\gauge3\gauge18.png'
	cG19:= cStartPath + 'gauge\gauge3\gauge19.png'
	cG20:= cStartPath + 'gauge\gauge3\gauge20.png'
	cG21:= cStartPath + 'gauge\gauge3\gauge21.png'
	cG22:= cStartPath + 'gauge\gauge3\gauge22.png'
	cG23:= cStartPath + 'gauge\gauge3\gauge23.png'
	cG24:= cStartPath + 'gauge\gauge3\gauge24.png'
	cG25:= cStartPath + 'gauge\gauge3\gauge25.png'

	cG0B:= cStartPath + 'gauge\gauge4\gauge0B.png'
	cG1B:= cStartPath + 'gauge\gauge4\gauge1B.png'
	cG2B:= cStartPath + 'gauge\gauge4\gauge2B.png'
	cG3B:= cStartPath + 'gauge\gauge4\gauge3B.png'
	cG4B:= cStartPath + 'gauge\gauge4\gauge4B.png'
	cG5B:= cStartPath + 'gauge\gauge4\gauge5B.png'
	cG6B:= cStartPath + 'gauge\gauge4\gauge6B.png'
	cG7B:= cStartPath + 'gauge\gauge4\gauge7B.png'
	cG8B:= cStartPath + 'gauge\gauge4\gauge8B.png'
	cG9B:= cStartPath + 'gauge\gauge4\gauge9B.png'
	cG10B:= cStartPath + 'gauge\gauge4\gauge10B.png'
	cG11B:= cStartPath + 'gauge\gauge4\gauge11B.png'
	cG12B:= cStartPath + 'gauge\gauge4\gauge12B.png'
	cG13B:= cStartPath + 'gauge\gauge4\gauge13B.png'
	cG14B:= cStartPath + 'gauge\gauge4\gauge14B.png'
	cG15B:= cStartPath + 'gauge\gauge4\gauge15B.png'
	cG16B:= cStartPath + 'gauge\gauge4\gauge16B.png'
	cG17B:= cStartPath + 'gauge\gauge4\gauge17B.png'
	cG18B:= cStartPath + 'gauge\gauge4\gauge18B.png'
	cG19B:= cStartPath + 'gauge\gauge4\gauge19B.png'
	cG20B:= cStartPath + 'gauge\gauge4\gauge20B.png'
	cG21B:= cStartPath + 'gauge\gauge4\gauge21B.png'
	cG22B:= cStartPath + 'gauge\gauge4\gauge22B.png'
	cG23B:= cStartPath + 'gauge\gauge4\gauge23B.png'
	cG24B:= cStartPath + 'gauge\gauge4\gauge24B.png'
	cG25B:= cStartPath + 'gauge\gauge4\gauge25B.png'

	Static oDlg

	IF nTpProd == 1
		cTpProd:= "CORD"
	ElseIF nTpProd == 2
		cTpProd:= "TRUNK"
	ElseIF nTpProd == 3
		cTpProd:= "DROP"
	ElseIF nTpProd == 4
		cTpProd:= "JUMPER"
	ElseIF nTpProd == 5
		cTpProd:= "PRECON"
	Endif

	DEFINE MSDIALOG oDlg TITLE "Planejamento de Produção - "+ cTpProd FROM 000, 000  TO 750, 1330 COLORS 0, 16777215 PIXEL
	@ 052, 007 GROUP oGroup2 TO 101, 158 PROMPT "Datas" OF oDlg COLOR 0, 16777215 PIXEL
	@ 004, 007 GROUP oGroup1 TO 052, 158 PROMPT "Ordem de produção" OF oDlg COLOR 0, 16777215 PIXEL

	ncol:= 320
	@ 010, ncol SAY oCort1 PROMPT cValTochar(nTotCort1)+"/"+cValTochar(nTimeProd)+"min "+cValTochar( round( (nTotCort1/nTimeProd)*100,0))+"%"    SIZE 1000, 020 OF oDlg FONT oFont26 COLORS CLR_WHITE, 1776411 PIXEL
	@ 028, ncol SAY oCort2 PROMPT cValTochar(nTotCort2)+"/"+cValTochar(nTimeProd)+"min "+cValTochar( round( (nTotCort2/nTimeProd)*100,0))+"%"    SIZE 1000, 020 OF oDlg FONT oFont26 COLORS CLR_WHITE, 1776411 PIXEL
	@ 046, ncol SAY oCort3 PROMPT cValTochar(nTotCort3)+"/"+cValTochar(nTimeProd)+"min "+cValTochar( round( (nTotCort3/nTimeProd)*100,0))+"%"    SIZE 1000, 020 OF oDlg FONT oFont26 COLORS CLR_WHITE, 1776411 PIXEL
	@ 064, ncol SAY oCort4 PROMPT cValTochar(nTotCort4)+"/"+cValTochar(nTimeProd)+"min "+cValTochar( round( (nTotCort4/nTimeProd)*100,0))+"%"    SIZE 1000, 020 OF oDlg FONT oFont26 COLORS CLR_WHITE, 1776411 PIXEL
	@ 082, ncol SAY oCort5 PROMPT cValTochar(nTotCort5)+"/"+cValTochar(nTimeProd)+"min "+cValTochar( round( (nTotCort5/nTimeProd)*100,0))+"%"    SIZE 1000, 020 OF oDlg FONT oFont26 COLORS CLR_WHITE, 1776411 PIXEL


	@ nXBt2-9,X3    	SAY oLin1 PROMPT cValTochar(nTotLin1)+"/"+cValTochar(nTimeMont)+"min "+cValTochar( round( (nTotLin1/nTimeMont)*100,0))+"%" SIZE nLrgBt2-10, 019 OF oDlg FONT oFont14 COLORS CLR_HMAGENTA, 1776411 PIXEL
	@ nXBt2-9,(X2*1)+X3 SAY oLin2 PROMPT cValTochar(nTotLin2)+"/"+cValTochar(nTimeMont)+"min "+cValTochar( round( (nTotLin2/nTimeMont)*100,0))+"%" SIZE nLrgBt2-10, 019 OF oDlg FONT oFont14 COLORS CLR_HMAGENTA, 1776411 PIXEL
	@ nXBt2-9,(X2*2)+X3 SAY oLin3 PROMPT cValTochar(nTotLin3)+"/"+cValTochar(nTimeMont)+"min "+cValTochar( round( (nTotLin3/nTimeMont)*100,0))+"%" SIZE nLrgBt2-10, 019 OF oDlg FONT oFont14 COLORS CLR_HMAGENTA, 1776411 PIXEL
	@ nXBt2-9,(X2*3)+X3 SAY oLin4 PROMPT cValTochar(nTotLin4)+"/"+cValTochar(nTimeMont)+"min "+cValTochar( round( (nTotLin4/nTimeMont)*100,0))+"%" SIZE nLrgBt2-10, 019 OF oDlg FONT oFont14 COLORS CLR_HMAGENTA, 1776411 PIXEL
	@ nXBt2-9,(X2*4)+X3 SAY oLin5 PROMPT cValTochar(nTotLin5)+"/"+cValTochar(nTimeMont)+"min "+cValTochar( round( (nTotLin5/nTimeMont)*100,0))+"%" SIZE nLrgBt2-10, 019 OF oDlg FONT oFont14 COLORS CLR_HMAGENTA, 1776411 PIXEL
	@ nXBt2-9,(X2*5)+X3 SAY oLin6 PROMPT cValTochar(nTotLin6)+"/"+cValTochar(nTimeMont)+"min "+cValTochar( round( (nTotLin6/nTimeMont)*100,0))+"%" SIZE nLrgBt2-10, 019 OF oDlg FONT oFont14 COLORS CLR_HMAGENTA, 1776411 PIXEL
	@ nXBt2-9,(X2*6)+X3 SAY oLin7 PROMPT cValTochar(nTotLin7)+"/"+cValTochar(nTimeMont)+"min "+cValTochar( round( (nTotLin7/nTimeMont)*100,0))+"%" SIZE nLrgBt2-10, 019 OF oDlg FONT oFont14 COLORS CLR_HMAGENTA, 1776411 PIXEL

	@ 015, 010 SAY oSay1 PROMPT "OP Inicial" SIZE 104, 015 OF oDlg FONT oFont10 COLORS 0, 16777215 PIXEL
	@ 013, 046 MSGET oGet1 VAR cOpIni SIZE 105, 014 OF oDlg COLORS 0, 16777215 FONT oFont12 PIXEL;
		VALID Processa( {|| IIf(!empty(cOpIni),MontaMsGet(),.T.)})

	@ 035, 010 SAY oSay2 PROMPT "OP Final" SIZE 102, 015 OF oDlg FONT oFont10 COLORS 0, 16777215 PIXEL
	@ 032, 046 MSGET oGet2 VAR cOpFim SIZE 105, 014 OF oDlg COLORS 0, 16777215 FONT oFont12 PIXEL;
		VALID Processa( {||IIf(!empty(cOpFim),MontaMsGet(),.T.)})

	@ 063, 013 SAY oSay5 PROMPT "Data Inicial" SIZE 104, 015 OF oDlg FONT oFont10 COLORS 0, 16777215 PIXEL
	@ 059, 056 MSGET oGet3 VAR dDtIni SIZE 095, 014 OF oDlg COLORS 0, 16777215 FONT oFont12 PIXEL;
		VALID Processa( {||IIf(!empty(dDtIni),MontaMsGet(),.T.)})

	@ 082, 014 SAY oSay6 PROMPT "Data Final" SIZE 102, 015 OF oDlg FONT oFont10 COLORS 0, 16777215 PIXEL
	@ 078, 056 MSGET oGet4 VAR dDtFim SIZE 093, 014 OF oDlg COLORS 0, 16777215 FONT oFont12 PIXEL;
		VALID Processa( {||IIf(!empty(dDtFim),MontaMsGet(),.T.)})

	@ 000, 535 SAY oSay4 PROMPT "Programação de corte" SIZE 099, 015 OF oDlg FONT oFont12 COLORS 0, 16777215 PIXEL
	oMsCalen1 := MsCalend():New(015, 510, oDlg, .T.)
	oMsCalen1:dDiaAtu := dDtProg
	oMsCalen1:CanMultSel:= .F.
	oMsCalen1:bChange := {|| dDtProg:= oMsCalen1:dDiaAtu, oMsCalen1:CtrlRefresh(), MontaMsGet() }
//oMsCalen1:bChangeMes := {|| Alert('Mes alterado')}


	@ 085, 510 CHECKBOX oCheckBo1 VAR lCheckBo1 PROMPT "Mostrar OP's já programadas" SIZE 144, 030 OF oDlg COLORS 0, 16777215 FONT oFont12 PIXEL;
		ON CHANGE (Processa( {||MontaMsGet()}))


// Barras de progressão do tempo de corte

	@ 006, 250 BITMAP oBitmapc1 SIZE 250, 030 OF oDlg FILENAME cG0 NOBORDER PIXEL
	@ 024, 250 BITMAP oBitmapc2 SIZE 250, 030 OF oDlg FILENAME cG0 NOBORDER PIXEL
	@ 042, 250 BITMAP oBitmapc3 SIZE 250, 030 OF oDlg FILENAME cG0 NOBORDER PIXEL
	@ 060, 250 BITMAP oBitmapc4 SIZE 250, 030 OF oDlg FILENAME cG0 NOBORDER PIXEL
	@ 078, 250 BITMAP oBitmapc5 SIZE 250, 030 OF oDlg FILENAME cG0 NOBORDER PIXEL

	@ nXBt2+26, X1 BITMAP oBitmapl1 SIZE 250, 030 OF oDlg FILENAME cG0B NOBORDER PIXEL
	@ nXBt2+26,  X1+(X2*1) BITMAP oBitmapl2 SIZE 250, 030 OF oDlg FILENAME cG0B NOBORDER PIXEL
	@ nXBt2+26,  X1+(X2*2) BITMAP oBitmapl3 SIZE 250, 030 OF oDlg FILENAME cG0B NOBORDER PIXEL
	@ nXBt2+26,  X1+(X2*3) BITMAP oBitmapl4 SIZE 250, 030 OF oDlg FILENAME cG0B NOBORDER PIXEL
	@ nXBt2+26,  X1+(X2*4) BITMAP oBitmapl5 SIZE 250, 030 OF oDlg FILENAME cG0B NOBORDER PIXEL
	@ nXBt2+26,  X1+(X2*5) BITMAP oBitmapl6 SIZE 250, 030 OF oDlg FILENAME cG0B NOBORDER PIXEL
	@ nXBt2+26,  X1+(X2*6) BITMAP oBitmapl7 SIZE 250, 030 OF oDlg FILENAME cG0B NOBORDER PIXEL


//Atributos dos botoes
	cCSSBtN1 :=	"QPushButton{background-color: #f6f7fa; color: #707070; font: bold 22px MS Sans Serif }"+;
		"QPushButton:pressed {background-color: #50b4b4; color: white; font: bold 22px MS Sans Serif; }"+;
		"QPushButton:hover {background-color: #878787 ; color: white; font: bold 22px MS Sans Serif; }"

//Botões de corte
	@ 006, nYBt1 BUTTON oButCort1 PROMPT "Corte 1" ACTION Processa( {|| fRefrButt(1,"C",nTpProd) })SIZE 080, 016 OF oDlg FONT oFont14 PIXEL
	oButCort1:setCSS(cCSSBtN1)
	@ 024, nYBt1 BUTTON oButCort2 PROMPT "Corte 2" ACTION Processa( {|| fRefrButt(2,"C",nTpProd) })SIZE 080, 016 OF oDlg FONT oFont14 PIXEL
	oButCort2:setCSS(cCSSBtN1)
	@ 042, nYBt1 BUTTON oButCort3 PROMPT "Corte 3" ACTION Processa( {|| fRefrButt(3,"C",nTpProd) })SIZE 080, 016 OF oDlg FONT oFont14 PIXEL
	oButCort3:setCSS(cCSSBtN1)
	@ 060, nYBt1 BUTTON oButCort4 PROMPT "Corte 4" ACTION Processa( {|| fRefrButt(4,"C",nTpProd) })SIZE 080, 016 OF oDlg FONT oFont14 PIXEL
	oButCort4:setCSS(cCSSBtN1)
	@ 078, nYBt1 BUTTON oButCort5 PROMPT "Corte 5" ACTION Processa( {|| fRefrButt(5,"C",nTpProd) })SIZE 080, 016 OF oDlg FONT oFont14 PIXEL
	oButCort5:setCSS(cCSSBtN1)


//Botoes de linha
	@ nXBt2, X1 	   BUTTON oButLin1 PROMPT "Linha 1" ACTION Processa( {|| fRefrButt(1,"L","") }) SIZE nLrgBt2, nAltBt2 OF oDlg FONT oFont14 PIXEL
	oButLin1:setCSS(cCSSBtN1)
	@ nXBt2, X1+(X2*1) BUTTON oButLin2 PROMPT "Linha 2" ACTION Processa( {|| fRefrButt(2,"L","") }) SIZE nLrgBt2, nAltBt2 OF oDlg FONT oFont14 PIXEL
	oButLin2:setCSS(cCSSBtN1)
	@ nXBt2, X1+(X2*2) BUTTON oButLin3 PROMPT "Linha 3" ACTION Processa( {|| fRefrButt(3,"L","") })SIZE nLrgBt2, nAltBt2 OF oDlg FONT oFont14 PIXEL
	oButLin3:setCSS(cCSSBtN1)
	@ nXBt2, X1+(X2*3) BUTTON oButLin4 PROMPT "Linha 4" ACTION Processa( {|| fRefrButt(4,"L","") })SIZE nLrgBt2, nAltBt2 OF oDlg FONT oFont14 PIXEL
	oButLin4:setCSS(cCSSBtN1)
	@ nXBt2, X1+(X2*4) BUTTON oButLin5 PROMPT "Linha 5" ACTION Processa( {|| fRefrButt(5,"L","") })SIZE nLrgBt2, nAltBt2 OF oDlg FONT oFont14 PIXEL
	oButLin5:setCSS(cCSSBtN1)
	@ nXBt2, X1+(X2*5) BUTTON oButLin6 PROMPT "Linha 6" ACTION Processa( {|| fRefrButt(6,"L","") })SIZE nLrgBt2, nAltBt2 OF oDlg FONT oFont14 PIXEL
	oButLin6:setCSS(cCSSBtN1)
	@ nXBt2, X1+(X2*6) BUTTON oButLin7 PROMPT "Linha 7" ACTION Processa( {|| fRefrButt(7,"L","") })SIZE nLrgBt2, nAltBt2 OF oDlg FONT oFont14 PIXEL
	oButLin7:setCSS(cCSSBtN1)



	aHeader := {}
	aCols   := {}
	AADD(aHeader,  {    ""					, "FLAG"   	   	,"@BMP" 			,01,0,""    ,"??????????????°","C"     ,""     ,"R"         ,""            ,""           ,".F."      ,"V"      , ""               , ""        , ""        })
	AADD(aHeader,  {    "Corte"				   	, "LEG1"   	   	,"@BMP" 			,01,0,""    ,"??????????????°","C"     ,""     ,"R"         ,""            ,""           ,".F."      ,"V"      , ""               , ""        , ""        })
	AADD(aHeader,  {    "Linha"				   	, "LEG2"   	   	,"@BMP" 			,01,0,""    ,"??????????????°","C"     ,""     ,"R"         ,""            ,""           ,".F."      ,"V"      , ""               , ""        , ""        })
	AADD(aHeader,  {    "Ord.Produção"     	, "OP"   		,"@R" 				,11,0,""    ,"??????????????°","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
	AADD(aHeader,  {    "Cod.Pai"       	, "PAI"   		,"@R" 				,15,0,""    ,"??????????????°","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
	AADD(aHeader,  {    "Descrição"   		, "DESC1"    	,"@R" 				,40,0,""    ,"??????????????°","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
	AADD(aHeader,  {    "Qtd.OP"	 		, "QTD"  		,"@E 999,999" 		,07,0,""    ,"??????????????°","N"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
	AADD(aHeader,  {    "Cod.Fibra" 		, "FIBRA"  		,"@R"				,15,0,""    ,"??????????????°","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
	AADD(aHeader,  {    "Desc.Fibra" 		, "DESC2"  		,"@R"				,40,0,""    ,"??????????????°","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
	AADD(aHeader,  {    "Dt.Program."    	, "DTPROG"  	,"@R"				,08,0,""    ,"??????????????°","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
	AADD(aHeader,  {    "Total Mtrs."    	, "QTD_FIBRA"  	,"@E 999,999.999" 	,12,0,""    ,"??????????????°","N"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
	AADD(aHeader,  {    "Maquinas"    		, "MAQUINA"  	,"@R" 			  	,10,0,""    ,"??????????????°","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
	AADD(aHeader,  {    "Linha Montagem"   	, "LINHA"  		,"@R" 			  	,10,0,""    ,"??????????????°","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
	AADD(aHeader,  {    "Tempo De Corte"   	, "TEMP_PROD"  	,"@E 999,999.999"	,08,0,""    ,"??????????????°","N"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
	AADD(aHeader,  {    "Tempo Montagem"   	, "TEMP_LIN"   	,"@E 999,999.999"	,08,0,""    ,"??????????????°","N"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
	AADD(aHeader,  {    ""	 				, "COR"  		,"@R"				,01,0,""    ,"??????????????°","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })

	oGetDados:= (MsNewGetDados():New( 160, 010 , 360 ,662,NIL ,"AlwaysTrue" ,"AlwaysTrue", /*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*VldCpo*/,/*superdel*/,/*delok*/,oDlg,aHeader,aCols))
	oGetDados:oBrowse:lUseDefaultColors := .F.
	oGetDados:oBrowse:SetBlkBackColor({|| CorGd02(oGetDados:nAt,8421376)})
	oGetDados:oBrowse:bRClicked := { || oGetDados:EditCell(), IIf(oGetDados:aCols[oGetDados:nAt,1]== oNo,fMark(1,"D"),fMark(2,"D")) }
	oGetDados:oBrowse:bLDblClick := { || oGetDados:EditCell(), IIf(oGetDados:aCols[oGetDados:nAt,1]== oNo,fMark(1,"E"),fMark(2,"E")) }

//MontaMsGet()

	Processa( {|| MontaMsGet()}, "Gerando Dados","Processando...",,.T.)

	oBtn1 := TBtnBmp2():New( 722,150,26,26,"BR_VERMELHO",,,,,oDlg,,,.T. )
	@ 363, 090 SAY oLeg2 PROMPT "Não Programado" 	SIZE 150, 012 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
	oBtn2 := TBtnBmp2():New( 722,400,26,26,"BR_VERDE",,,,,oDlg,,,.T. )
	@ 363, 214 SAY oLeg2 PROMPT "Programado" 	SIZE 150, 012 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
	oBtn3 := TBtnBmp2():New( 722,650,26,26,"BR_AMARELO",,,,,oDlg,,,.T. )
	@ 363, 340 SAY oLeg3 PROMPT "Em Andamento" 	SIZE 150, 012 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
	oBtn4 := TBtnBmp2():New( 722,900,26,26,"BR_PINK",,,,,oDlg,,,.T. )
	@ 363, 465 SAY oLeg1 PROMPT  "Finalizado" 	SIZE 150, 012 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL

	oBtn5 := TBtnBmp2():New( 722,1300,26,26,"STOPALL",,,, {|| fRefrButt(0,"X","") , MontaMsGet()},oDlg,,,.T. )
	@ 363, 600 SAY oLeg4 PROMPT  "DESPROGRAMAR" SIZE 150, 012 OF oDlg FONT oFont3 COLORS 0, 16777215 PIXEL


	ACTIVATE MSDIALOG oDlg CENTERED

Return

/*/Protheus.doc MontaMsGet
	description
	type function
	version
	author Ricardo Roda
	since 23/07/2020
return return_type, return_description
/*/
Static Function MontaMsGet()
	Local cQuery:= ""
	Local lRet:= .T.

	nTotCort1 := 0
	nTotCort2 := 0
	nTotCort3 := 0
	nTotCort4 := 0
	nTotCort5 := 0
	nTotLin1 := 0
	nTotLin2 := 0
	nTotLin3 := 0
	nTotLin4 := 0
	nTotLin5 := 0
	nTotLin6 := 0
	nTotLin7 := 0


	IF SELECT ("QRY") > 0
		QRY->(DBCLOSEAREA())
	ENDIF

	cQuery+= " SELECT  * FROM ( "
	cQuery+= " SELECT  D4_OP,"
	cQuery+= "  C2_PRODUTO COD_PAI,"
	cQuery+= "  SB1A.B1_DESC [DESC_PAI],"
	cQuery+= "  C2_QUANT [QTD_PAI],"
	cQuery+= "  D4_COD [COD_FIBRA],"
	cQuery+= "  SB1B.B1_DESC [DESC_FIBRA],"
	cQuery+= " D4_QUANT, "
	cQuery+= " ISNULL(P10_MAQUIN,'') AS CORTE, "
	cQuery+= " ISNULL(P10_LINHA,'') AS LINHA, "
	cQuery+= " ISNULL(P10_DTPROG,'') AS DTPRG, "
//ALTERAÇÃO PARA TRATAMENTO DO PIGTAIL
	cQuery+= " CASE WHEN SB1A.B1_SUBCLAS = 'KIT PIGT' THEN
	cQuery+= " ISNULL(ROUND(P10_TEMPC/12,2),0) ELSE ISNULL(P10_TEMPC,0) END AS TEMPC "

//cQuery+= " ,ISNULL(P10_TEMPL,0) AS TEMPL "

	cQuery+= ",(SELECT ROUND(ISNULL(SUM(CASE WHEN D3_CF='RE4' THEN -D3_QUANT ELSE +D3_QUANT END),0) ,6)AS QTDD3    "
	cQuery+= "FROM "+RETSQLNAME("SD3")+" SD3  "
	cQuery+= "WHERE  D3_XXOP = D4_OP    "
	cQuery+= "AND D3_COD = D4_COD    "
	cQuery+= "AND D3_LOCAL   = '97'    "
	cQuery+= "AND D3_ESTORNO = ''    "
	cQuery+= "AND D3_CF IN ('DE4','RE4')    "
	cQuery+= "AND D3_FILIAL ='"+xFilial("SD3")+"'"
	cQuery+= "AND SD3.D_E_L_E_T_ = '') D3_QUANT     "

//ALTERAÇÃO  PARA CONCIDERAR O TEMPO DA LINHA DE MONTAGEM
	cQuery+= ",CASE WHEN SB1A.B1_SUBCLAS = 'KIT PIGT' THEN
	cQuery+= "		ROUND((SELECT D4_QUANT FROM "+RETSQLNAME("SD4")+" D4LIN  "
	cQuery+= "		WHERE D4LIN.D4_OP = SD4.D4_OP "
	cQuery+= "		AND D4_FILIAL = '"+xFilial("SD4")+"' "
	cQuery+= "		AND D_E_L_E_T_ = ''	"
	cQuery+= "		AND D4_COD = '50010100')/12,2)
	cQuery+= "ELSE
	cQuery+= "	CASE WHEN SB1A.B1_GRUPO = 'CORD' THEN
	cQuery+= "		(SELECT D4_QUANT
	cQuery+= "		FROM   "+RETSQLNAME("SD4")+" D4LIN
	cQuery+= "		WHERE  D4LIN.D4_OP = SD4.D4_OP
	cQuery+= "		AND D4_FILIAL = '"+xFilial("SD4")+"'
	cQuery+= "		AND D_E_L_E_T_ = ''
	cQuery+= "		AND D4_COD = '50010100')
	cQuery+= "		WHEN SB1A.B1_GRUPO IN ('TRUE', 'TRUN') THEN
	cQuery+= "		(SELECT D4_QUANT
	cQuery+= "		FROM   "+RETSQLNAME("SD4")+" D4LIN
	cQuery+= "		WHERE  D4LIN.D4_OP = SD4.D4_OP
	cQuery+= "		AND D4_FILIAL = '"+xFilial("SD4")+"' "
	cQuery+= "		AND D_E_L_E_T_ = ''
	cQuery+= "		AND D4_COD = '50010100T')
	cQuery+= "		WHEN SB1A.B1_GRUPO = 'DROP' THEN
	cQuery+= "		(SELECT D4_QUANT
	cQuery+= "		FROM   "+RETSQLNAME("SD4")+" D4LIN
	cQuery+= "		WHERE  D4LIN.D4_OP = SD4.D4_OP
	cQuery+= "		AND D4_FILIAL = '"+xFilial("SD4")+"' "
	cQuery+= "		AND D_E_L_E_T_ = ''
	cQuery+= "		AND D4_COD = '50010100DR')
	cQuery+= "		WHEN SB1A.B1_GRUPO = 'JUMPER' THEN
	cQuery+= "		(SELECT D4_QUANT
	cQuery+= "		FROM   "+RETSQLNAME("SD4")+" D4LIN
	cQuery+= "		WHERE  D4LIN.D4_OP = SD4.D4_OP
	cQuery+= "		AND D4_FILIAL = '"+xFilial("SD4")+"' "
	cQuery+= "		AND D_E_L_E_T_ = ''
	cQuery+= "		AND D4_COD = '50010100J')
	cQuery+= "		WHEN SB1A.B1_GRUPO = 'PCON' THEN
	cQuery+= "		(SELECT D4_QUANT
	cQuery+= "		FROM   "+RETSQLNAME("SD4")+" D4LIN
	cQuery+= "		WHERE  D4LIN.D4_OP = SD4.D4_OP
	cQuery+= "		AND D4_FILIAL = '"+xFilial("SD4")+"' "
	cQuery+= "		AND D_E_L_E_T_ = ''
	cQuery+= "		AND D4_COD = '50010100PC')
	cQuery+= "		END
	cQuery+= "	END AS TEMPL "

	cQuery+= " FROM "+RETSQLNAME("SC2")+"  SC2 "
	cQuery+= " INNER JOIN "+RETSQLNAME("SD4")+" SD4 "
	cQuery+= " 	ON D4_FILIAL = '"+xFilial("SD4")+"'"
	cQuery+= " 	AND D4_OP = C2_NUM+C2_ITEM+C2_SEQUEN"
	cQuery+= " 	AND D4_QTDEORI > 0"
	cQuery+= " 	AND D4_QUANT > 0"
	cQuery+= " 	AND SD4.D_E_L_E_T_ = ''"

	cQuery+= " INNER JOIN "+RETSQLNAME("SB1")+" SB1A"
	cQuery+= " 	ON SB1A.B1_FILIAL = '"+xFilial("SB1")+"'"
	cQuery+= " 	AND SB1A.B1_COD = C2_PRODUTO"
	//	cQuery+= " 	AND NOT( SB1A.B1_COD LIKE  OR SB1A.B1_COD LIKE 'CO0%') "
	
	IF nTpProd == 1
		cQuery+= " 	AND SB1A.B1_GRUPO = 'CORD'"
	ElseIF nTpProd == 2
		cQuery+= " 	AND SB1A.B1_GRUPO IN ('TRUE', 'TRUN')"
	ElseIF nTpProd == 3
		cQuery+= " 	AND SB1A.B1_GRUPO = 'DROP'"
	ElseIF nTpProd == 4
		cQuery+= " 	AND SB1A.B1_GRUPO = 'JUMP'"
	ElseIF nTpProd == 5
		cQuery+= " 	AND SB1A.B1_GRUPO = 'PCON'"
	Endif

	cQuery+= " 	AND SB1A.D_E_L_E_T_ = ''"
	cQuery+= " INNER JOIN "+RETSQLNAME("SB1")+" SB1B"
	cQuery+= " 	ON SB1B.B1_FILIAL = '"+xFilial("SB1")+"'"
	cQuery+= " 	AND SB1B.B1_COD = D4_COD"
	cQuery+= " 	AND SB1B.B1_GRUPO IN ('FO','FOFS')"
	//	cQuery+= " 	AND NOT( SB1B.B1_COD LIKE 'DMS%' OR SB1B.B1_COD LIKE 'CO0%') "
	cQuery+= " 	AND SB1B.D_E_L_E_T_ = ''"
	cQuery+= "   LEFT JOIN "+RETSQLNAME("P10")+" P10 "
	cQuery+= " 				ON P10_FILIAL = '"+xFilial("P10")+"' "
	cQuery+= " 				AND P10_OP = D4_OP "
	cQuery+= " 				AND P10_FIBRA = D4_COD "
	cQuery+= " 				AND P10.D_E_L_E_T_ =	''	 "

	cQuery+= " WHERE C2_FILIAL = '"+xFilial("SC2")+"'"
	If !empty(cOpIni)
		cQuery+= " AND C2_NUM+C2_ITEM+C2_SEQUEN >= '"+cOpIni+"' "
	Endif
	If !empty(cOpFim)
		cQuery+= " AND C2_NUM+C2_ITEM+C2_SEQUEN <= '"+cOpFim+"' "
	Endif
	If !empty(dDtIni)
		cQuery+= " AND C2_XXDTPRO >= '"+dTos(dDtIni)+"' "
	Endif
	If !empty(dDtFim)
		cQuery+= " AND C2_XXDTPRO <= '"+dTos(dDtFim)+"' "
	EndIf
	cQuery+= " AND C2_DATRF =	''"
	cQuery+= " AND SC2.D_E_L_E_T_ = ''"

	If !lCheckBo1
		cQuery+= "  AND (P10_MAQUIN IS NULL OR P10_LINHA IS NULL)
	Endif

	cQuery+= " ) AS TAB "
	//cQuery+= " WHERE D4_QUANT > D3_QUANT"
	cQuery+= " WHERE (D4_QUANT > D3_QUANT  OR TEMPL > 0)"
	cQuery+= " ORDER BY 5, 1,2"
	MemoWrite("DOMPRGCORT.sql",cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)

	oGetDados:aCols := {}

	@ 006, 250 BITMAP oBitmapc1 SIZE 250, 030 OF oDlg FILENAME cG0 NOBORDER PIXEL
	@ 024, 250 BITMAP oBitmapc2 SIZE 250, 030 OF oDlg FILENAME cG0 NOBORDER PIXEL
	@ 042, 250 BITMAP oBitmapc3 SIZE 250, 030 OF oDlg FILENAME cG0 NOBORDER PIXEL
	@ 060, 250 BITMAP oBitmapc4 SIZE 250, 030 OF oDlg FILENAME cG0 NOBORDER PIXEL
	@ 078, 250 BITMAP oBitmapc5 SIZE 250, 030 OF oDlg FILENAME cG0 NOBORDER PIXEL


	@ nXBt2+26,  X1        BITMAP oBitmapl1 SIZE 250, 030 OF oDlg FILENAME cG0B NOBORDER PIXEL
	@ nXBt2+26,  X1+(X2*1) BITMAP oBitmapl2 SIZE 250, 030 OF oDlg FILENAME cG0B NOBORDER PIXEL
	@ nXBt2+26,  X1+(X2*2) BITMAP oBitmapl3 SIZE 250, 030 OF oDlg FILENAME cG0B NOBORDER PIXEL
	@ nXBt2+26,  X1+(X2*3) BITMAP oBitmapl4 SIZE 250, 030 OF oDlg FILENAME cG0B NOBORDER PIXEL
	@ nXBt2+26,  X1+(X2*4) BITMAP oBitmapl5 SIZE 250, 030 OF oDlg FILENAME cG0B NOBORDER PIXEL
	@ nXBt2+26,  X1+(X2*5) BITMAP oBitmapl6 SIZE 250, 030 OF oDlg FILENAME cG0B NOBORDER PIXEL
	@ nXBt2+26,  X1+(X2*6) BITMAP oBitmapl7 SIZE 250, 030 OF oDlg FILENAME cG0B NOBORDER PIXEL


	If !QRY->(eof())
		While QRY->(!eof())
			AADD(oGetDados:aCols,Array(Len(oGetDados:aHeader)+1))

			If (!EMPTY(QRY->CORTE) .and. EMPTY(QRY->LINHA)).or. (EMPTY(QRY->CORTE) .and. !EMPTY(QRY->LINHA))
				oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'FLAG' 		})] := oOk
			Else
				oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'FLAG' 		})] := oNo
			Endif

			If !EMPTY(QRY->CORTE)
				IF QRY->D3_QUANT == 0
					oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'LEG1' 		})] := oLegOk
				ElseIF QRY->D3_QUANT > 0 .and. QRY->D3_QUANT < QRY->D4_QUANT
					oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'LEG1' 		})] := oLegIni
				ElseIF QRY->D3_QUANT >= QRY->D4_QUANT 
					oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'LEG1' 		})] := oLegFim
				Endif
			Else
				oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'LEG1' 		})] := oLegno
			Endif

			If !EMPTY(QRY->LINHA)
				oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'LEG2' 		})] := oLegOk
			Else
				oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'LEG2' 		})] := oLegno
			Endif

			if(!EMPTY(QRY->CORTE) .and. EMPTY(QRY->LINHA)).or. (EMPTY(QRY->CORTE) .and. !EMPTY(QRY->LINHA))
				oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'COR' 			})] := "1"
			Else
				oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'COR' 			})] := "2"
			Endif
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'OP' 			})] := QRY->D4_OP
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'PAI'   		})] := QRY->COD_PAI
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'DESC1'   	})] := QRY->DESC_PAI
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'QTD'     	})] := QRY->QTD_PAI
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'FIBRA'  		})] := QRY->COD_FIBRA
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'DESC2' 		})] := QRY->DESC_FIBRA
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'DTPROG' 		})] := DTOC(STOD(QRY->DTPRG))
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'QTD_FIBRA'  })] := QRY->D4_QUANT
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'MAQUINA'  	})] := QRY->CORTE
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'LINHA'  		})] := QRY->LINHA

			if !empty(QRY->TEMPC) .AND.  QRY->DTPRG == DtOS(dDtProg)
				if (nTpProd == 1 .and. Alltrim(QRY->CORTE) == "CORTE 1")  .or. (nTpProd == 3 .and.  Alltrim(QRY->CORTE) == "DROP 1" )   .or. (nTpProd == 2 .and.  Alltrim(QRY->CORTE) == "TRUNK 1")	.or. (nTpProd == 4 .and.  Alltrim(QRY->CORTE) == "JUMPER 1")  .or. (nTpProd == 5 .and.  Alltrim(QRY->CORTE) == "PRECON 1")
					nTotCort1+= QRY->TEMPC
					nLin:= 6
					FreeObj(oBitmapC1)
					IF ((nTotCort1/nTimeProd)*100) == 0
						@ nLin, 250 BITMAP oBitmapC1 SIZE 250, 030 OF oDlg FILENAME cG0 NOBORDER PIXEL
					ELSEIF ((nTotCort1/nTimeProd)*100) > 0 .AND. ((nTotCort1/nTimeProd)*100) <= 4
						@ nLin, 250 BITMAP oBitmapC1 SIZE 250, 030 OF oDlg FILENAME cG1 NOBORDER PIXEL
					ELSEIF ((nTotCort1/nTimeProd)*100) > 4 .AND. ((nTotCort1/nTimeProd)*100) <= 8
						@ nLin, 250 BITMAP oBitmapC1 SIZE 250, 030 OF oDlg FILENAME cG2 NOBORDER PIXEL
					ELSEIF ((nTotCort1/nTimeProd)*100) > 8 .AND. ((nTotCort1/nTimeProd)*100) <= 12
						@ nLin, 250 BITMAP oBitmapC1 SIZE 250, 030 OF oDlg FILENAME cG3 NOBORDER PIXEL
					ELSEIF ((nTotCort1/nTimeProd)*100) > 12 .AND. ((nTotCort1/nTimeProd)*100) <= 16
						@ nLin, 250 BITMAP oBitmapC1 SIZE 250, 030 OF oDlg FILENAME cG4 NOBORDER PIXEL
					ELSEIF ((nTotCort1/nTimeProd)*100) > 16 .AND. ((nTotCort1/nTimeProd)*100) <= 20
						@ nLin, 250 BITMAP oBitmapC1 SIZE 250, 030 OF oDlg FILENAME cG5 NOBORDER PIXEL
					ELSEIF ((nTotCort1/nTimeProd)*100) > 20 .AND. ((nTotCort1/nTimeProd)*100) <= 24
						@ nLin, 250 BITMAP oBitmapC1 SIZE 250, 030 OF oDlg FILENAME cG6 NOBORDER PIXEL
					ELSEIF ((nTotCort1/nTimeProd)*100) > 24 .AND. ((nTotCort1/nTimeProd)*100) <= 28
						@ nLin, 250 BITMAP oBitmapC1 SIZE 250, 030 OF oDlg FILENAME cG7 NOBORDER PIXEL
					ELSEIF ((nTotCort1/nTimeProd)*100) > 28 .AND. ((nTotCort1/nTimeProd)*100) <= 32
						@ nLin, 250 BITMAP oBitmapC1 SIZE 250, 030 OF oDlg FILENAME cG8 NOBORDER PIXEL
					ELSEIF ((nTotCort1/nTimeProd)*100) > 32 .AND. ((nTotCort1/nTimeProd)*100) <= 36
						@ nLin, 250 BITMAP oBitmapC1 SIZE 250, 030 OF oDlg FILENAME cG9 NOBORDER PIXEL
					ELSEIF ((nTotCort1/nTimeProd)*100) > 36 .AND. ((nTotCort1/nTimeProd)*100) <= 40
						@ nLin, 250 BITMAP oBitmapC1 SIZE 250, 030 OF oDlg FILENAME cG10 NOBORDER PIXEL
					ELSEIF ((nTotCort1/nTimeProd)*100) > 40 .AND. ((nTotCort1/nTimeProd)*100) <= 44
						@ nLin, 250 BITMAP oBitmapC1 SIZE 250, 030 OF oDlg FILENAME cG11 NOBORDER PIXEL
					ELSEIF ((nTotCort1/nTimeProd)*100) > 44 .AND. ((nTotCort1/nTimeProd)*100) <= 48
						@ nLin, 250 BITMAP oBitmapC1 SIZE 250, 030 OF oDlg FILENAME cG12 NOBORDER PIXEL
					ELSEIF ((nTotCort1/nTimeProd)*100) > 48 .AND. ((nTotCort1/nTimeProd)*100) <= 52
						@ nLin, 250 BITMAP oBitmapC1 SIZE 250, 030 OF oDlg FILENAME cG13 NOBORDER PIXEL
					ELSEIF ((nTotCort1/nTimeProd)*100) > 52 .AND. ((nTotCort1/nTimeProd)*100) <= 56
						@ nLin, 250 BITMAP oBitmapC1 SIZE 250, 030 OF oDlg FILENAME cG14 NOBORDER PIXEL
					ELSEIF ((nTotCort1/nTimeProd)*100) > 56 .AND. ((nTotCort1/nTimeProd)*100) <= 60
						@ nLin, 250 BITMAP oBitmapC1 SIZE 250, 030 OF oDlg FILENAME cG15 NOBORDER PIXEL
					ELSEIF ((nTotCort1/nTimeProd)*100) > 60 .AND. ((nTotCort1/nTimeProd)*100) <= 64
						@ nLin, 250 BITMAP oBitmapC1 SIZE 250, 030 OF oDlg FILENAME cG16 NOBORDER PIXEL
					ELSEIF ((nTotCort1/nTimeProd)*100) > 64 .AND. ((nTotCort1/nTimeProd)*100) <= 68
						@ nLin, 250 BITMAP oBitmapC1 SIZE 250, 030 OF oDlg FILENAME cG17 NOBORDER PIXEL
					ELSEIF ((nTotCort1/nTimeProd)*100) > 68 .AND. ((nTotCort1/nTimeProd)*100) <= 72
						@ nLin, 250 BITMAP oBitmapC1 SIZE 250, 030 OF oDlg FILENAME cG18 NOBORDER PIXEL
					ELSEIF ((nTotCort1/nTimeProd)*100) > 72 .AND. ((nTotCort1/nTimeProd)*100) <= 76
						@ nLin, 250 BITMAP oBitmapC1 SIZE 250, 030 OF oDlg FILENAME cG19 NOBORDER PIXEL
					ELSEIF ((nTotCort1/nTimeProd)*100) > 76 .AND. ((nTotCort1/nTimeProd)*100) <= 80
						@ nLin, 250 BITMAP oBitmapC1 SIZE 250, 030 OF oDlg FILENAME cG20 NOBORDER PIXEL
					ELSEIF ((nTotCort1/nTimeProd)*100) > 80 .AND. ((nTotCort1/nTimeProd)*100) <= 84
						@ nLin, 250 BITMAP oBitmapC1 SIZE 250, 030 OF oDlg FILENAME cG21 NOBORDER PIXEL
					ELSEIF ((nTotCort1/nTimeProd)*100) > 84 .AND. ((nTotCort1/nTimeProd)*100) <= 88
						@ nLin, 250 BITMAP oBitmapC1 SIZE 250, 030 OF oDlg FILENAME cG22 NOBORDER PIXEL
					ELSEIF ((nTotCort1/nTimeProd)*100) > 88 .AND. ((nTotCort1/nTimeProd)*100) <= 92
						@ nLin, 250 BITMAP oBitmapC1 SIZE 250, 030 OF oDlg FILENAME cG23 NOBORDER PIXEL
					ELSEIF ((nTotCort1/nTimeProd)*100) > 92 .AND. ((nTotCort1/nTimeProd)*100) <= 96
						@ nLin, 250 BITMAP oBitmapC1 SIZE 250, 030 OF oDlg FILENAME cG24 NOBORDER PIXEL
					ELSEIF ((nTotCort1/nTimeProd)*100) > 96
						@ nLin, 250 BITMAP oBitmapC1 SIZE 250, 030 OF oDlg FILENAME cG25 NOBORDER PIXEL
					Endif


				Elseif (nTpProd == 1 .and. Alltrim(QRY->CORTE) == "CORTE 2")  .or. (nTpProd == 3 .and.  Alltrim(QRY->CORTE) == "DROP 2" )   .or. (nTpProd == 2 .and.  Alltrim(QRY->CORTE) == "TRUNK 2")	.or. (nTpProd == 4 .and.  Alltrim(QRY->CORTE) == "JUMPER 2") .or. (nTpProd == 5 .and.  Alltrim(QRY->CORTE) == "PRECON 2")
					nTotCort2+= QRY->TEMPC
					nLin:= 24
					FreeObj(oBitmapC2)
					IF ((nTotCort2/nTimeProd)*100) == 0
						@ nLin, 250 BITMAP oBitmapC2 SIZE 250, 030 OF oDlg FILENAME cG0 NOBORDER PIXEL
					ELSEIF ((nTotCort2/nTimeProd)*100) > 0 .AND. ((nTotCort2/nTimeProd)*100) <= 4
						@ nLin, 250 BITMAP oBitmapC2 SIZE 250, 030 OF oDlg FILENAME cG1 NOBORDER PIXEL
					ELSEIF ((nTotCort2/nTimeProd)*100) > 4 .AND. ((nTotCort2/nTimeProd)*100) <= 8
						@ nLin, 250 BITMAP oBitmapC2 SIZE 250, 030 OF oDlg FILENAME cG2 NOBORDER PIXEL
					ELSEIF ((nTotCort2/nTimeProd)*100) > 8 .AND. ((nTotCort2/nTimeProd)*100) <= 12
						@ nLin, 250 BITMAP oBitmapC2 SIZE 250, 030 OF oDlg FILENAME cG3 NOBORDER PIXEL
					ELSEIF ((nTotCort2/nTimeProd)*100) > 12 .AND. ((nTotCort2/nTimeProd)*100) <= 16
						@ nLin, 250 BITMAP oBitmapC2 SIZE 250, 030 OF oDlg FILENAME cG4 NOBORDER PIXEL
					ELSEIF ((nTotCort2/nTimeProd)*100) > 16 .AND. ((nTotCort2/nTimeProd)*100) <= 20
						@ nLin, 250 BITMAP oBitmapC2 SIZE 250, 030 OF oDlg FILENAME cG5 NOBORDER PIXEL
					ELSEIF ((nTotCort2/nTimeProd)*100) > 20 .AND. ((nTotCort2/nTimeProd)*100) <= 24
						@ nLin, 250 BITMAP oBitmapC2 SIZE 250, 030 OF oDlg FILENAME cG6 NOBORDER PIXEL
					ELSEIF ((nTotCort2/nTimeProd)*100) > 24 .AND. ((nTotCort2/nTimeProd)*100) <= 28
						@ nLin, 250 BITMAP oBitmapC2 SIZE 250, 030 OF oDlg FILENAME cG7 NOBORDER PIXEL
					ELSEIF ((nTotCort2/nTimeProd)*100) > 28 .AND. ((nTotCort2/nTimeProd)*100) <= 32
						@ nLin, 250 BITMAP oBitmapC2 SIZE 250, 030 OF oDlg FILENAME cG8 NOBORDER PIXEL
					ELSEIF ((nTotCort2/nTimeProd)*100) > 32 .AND. ((nTotCort2/nTimeProd)*100) <= 36
						@ nLin, 250 BITMAP oBitmapC2 SIZE 250, 030 OF oDlg FILENAME cG9 NOBORDER PIXEL
					ELSEIF ((nTotCort2/nTimeProd)*100) > 36 .AND. ((nTotCort2/nTimeProd)*100) <= 40
						@ nLin, 250 BITMAP oBitmapC2 SIZE 250, 030 OF oDlg FILENAME cG10 NOBORDER PIXEL
					ELSEIF ((nTotCort2/nTimeProd)*100) > 40 .AND. ((nTotCort2/nTimeProd)*100) <= 44
						@ nLin, 250 BITMAP oBitmapC2 SIZE 250, 030 OF oDlg FILENAME cG11 NOBORDER PIXEL
					ELSEIF ((nTotCort2/nTimeProd)*100) > 44 .AND. ((nTotCort2/nTimeProd)*100) <= 48
						@ nLin, 250 BITMAP oBitmapC2 SIZE 250, 030 OF oDlg FILENAME cG12 NOBORDER PIXEL
					ELSEIF ((nTotCort2/nTimeProd)*100) > 48 .AND. ((nTotCort2/nTimeProd)*100) <= 52
						@ nLin, 250 BITMAP oBitmapC2 SIZE 250, 030 OF oDlg FILENAME cG13 NOBORDER PIXEL
					ELSEIF ((nTotCort2/nTimeProd)*100) > 52 .AND. ((nTotCort2/nTimeProd)*100) <= 56
						@ nLin, 250 BITMAP oBitmapC2 SIZE 250, 030 OF oDlg FILENAME cG14 NOBORDER PIXEL
					ELSEIF ((nTotCort2/nTimeProd)*100) > 56 .AND. ((nTotCort2/nTimeProd)*100) <= 60
						@ nLin, 250 BITMAP oBitmapC2 SIZE 250, 030 OF oDlg FILENAME cG15 NOBORDER PIXEL
					ELSEIF ((nTotCort2/nTimeProd)*100) > 60 .AND. ((nTotCort2/nTimeProd)*100) <= 64
						@ nLin, 250 BITMAP oBitmapC2 SIZE 250, 030 OF oDlg FILENAME cG16 NOBORDER PIXEL
					ELSEIF ((nTotCort2/nTimeProd)*100) > 64 .AND. ((nTotCort2/nTimeProd)*100) <= 68
						@ nLin, 250 BITMAP oBitmapC2 SIZE 250, 030 OF oDlg FILENAME cG17 NOBORDER PIXEL
					ELSEIF ((nTotCort2/nTimeProd)*100) > 68 .AND. ((nTotCort2/nTimeProd)*100) <= 72
						@ nLin, 250 BITMAP oBitmapC2 SIZE 250, 030 OF oDlg FILENAME cG18 NOBORDER PIXEL
					ELSEIF ((nTotCort2/nTimeProd)*100) > 72 .AND. ((nTotCort2/nTimeProd)*100) <= 76
						@ nLin, 250 BITMAP oBitmapC2 SIZE 250, 030 OF oDlg FILENAME cG19 NOBORDER PIXEL
					ELSEIF ((nTotCort2/nTimeProd)*100) > 76 .AND. ((nTotCort2/nTimeProd)*100) <= 80
						@ nLin, 250 BITMAP oBitmapC2 SIZE 250, 030 OF oDlg FILENAME cG20 NOBORDER PIXEL
					ELSEIF ((nTotCort2/nTimeProd)*100) > 80 .AND. ((nTotCort2/nTimeProd)*100) <= 84
						@ nLin, 250 BITMAP oBitmapC2 SIZE 250, 030 OF oDlg FILENAME cG21 NOBORDER PIXEL
					ELSEIF ((nTotCort2/nTimeProd)*100) > 84 .AND. ((nTotCort2/nTimeProd)*100) <= 88
						@ nLin, 250 BITMAP oBitmapC2 SIZE 250, 030 OF oDlg FILENAME cG22 NOBORDER PIXEL
					ELSEIF ((nTotCort2/nTimeProd)*100) > 88 .AND. ((nTotCort2/nTimeProd)*100) <= 92
						@ nLin, 250 BITMAP oBitmapC2 SIZE 250, 030 OF oDlg FILENAME cG23 NOBORDER PIXEL
					ELSEIF ((nTotCort2/nTimeProd)*100) > 92 .AND. ((nTotCort2/nTimeProd)*100) <= 96
						@ nLin, 250 BITMAP oBitmapC2 SIZE 250, 030 OF oDlg FILENAME cG24 NOBORDER PIXEL
					ELSEIF ((nTotCort2/nTimeProd)*100) > 96
						@ nLin, 250 BITMAP oBitmapC2 SIZE 250, 030 OF oDlg FILENAME cG25 NOBORDER PIXEL
					Endif

				Elseif (nTpProd == 1 .and. Alltrim(QRY->CORTE) == "CORTE 3")  .or. (nTpProd == 3 .and.  Alltrim(QRY->CORTE) == "DROP 3" )   .or. (nTpProd == 2 .and.  Alltrim(QRY->CORTE) == "TRUNK 3")	.or. (nTpProd == 4 .and.  Alltrim(QRY->CORTE) == "JUMPER 3") .or. (nTpProd == 5 .and.  Alltrim(QRY->CORTE) == "PRECON 3")
					nTotCort3+= QRY->TEMPC
					nLin:=42
					FreeObj(oBitmapC3)
					IF ((nTotCort3/nTimeProd)*100) == 0
						@ nLin, 250 BITMAP oBitmapC3 SIZE 250, 030 OF oDlg FILENAME cG0 NOBORDER PIXEL
					ELSEIF ((nTotCort3/nTimeProd)*100) > 0 .AND. ((nTotCort3/nTimeProd)*100) <= 4
						@ nLin, 250 BITMAP oBitmapC3 SIZE 250, 030 OF oDlg FILENAME cG1 NOBORDER PIXEL
					ELSEIF ((nTotCort3/nTimeProd)*100) > 4 .AND. ((nTotCort3/nTimeProd)*100) <= 8
						@ nLin, 250 BITMAP oBitmapC3 SIZE 250, 030 OF oDlg FILENAME cG2 NOBORDER PIXEL
					ELSEIF ((nTotCort3/nTimeProd)*100) > 8 .AND. ((nTotCort3/nTimeProd)*100) <= 12
						@ nLin, 250 BITMAP oBitmapC3 SIZE 250, 030 OF oDlg FILENAME cG3 NOBORDER PIXEL
					ELSEIF ((nTotCort3/nTimeProd)*100) > 12 .AND. ((nTotCort3/nTimeProd)*100) <= 16
						@ nLin, 250 BITMAP oBitmapC3 SIZE 250, 030 OF oDlg FILENAME cG4 NOBORDER PIXEL
					ELSEIF ((nTotCort3/nTimeProd)*100) > 16 .AND. ((nTotCort3/nTimeProd)*100) <= 20
						@ nLin, 250 BITMAP oBitmapC3 SIZE 250, 030 OF oDlg FILENAME cG5 NOBORDER PIXEL
					ELSEIF ((nTotCort3/nTimeProd)*100) > 20 .AND. ((nTotCort3/nTimeProd)*100) <= 24
						@ nLin, 250 BITMAP oBitmapC3 SIZE 250, 030 OF oDlg FILENAME cG6 NOBORDER PIXEL
					ELSEIF ((nTotCort3/nTimeProd)*100) > 24 .AND. ((nTotCort3/nTimeProd)*100) <= 28
						@ nLin, 250 BITMAP oBitmapC3 SIZE 250, 030 OF oDlg FILENAME cG7 NOBORDER PIXEL
					ELSEIF ((nTotCort3/nTimeProd)*100) > 28 .AND. ((nTotCort3/nTimeProd)*100) <= 32
						@ nLin, 250 BITMAP oBitmapC3 SIZE 250, 030 OF oDlg FILENAME cG8 NOBORDER PIXEL
					ELSEIF ((nTotCort3/nTimeProd)*100) > 32 .AND. ((nTotCort3/nTimeProd)*100) <= 36
						@ nLin, 250 BITMAP oBitmapC3 SIZE 250, 030 OF oDlg FILENAME cG9 NOBORDER PIXEL
					ELSEIF ((nTotCort3/nTimeProd)*100) > 36 .AND. ((nTotCort3/nTimeProd)*100) <= 40
						@ nLin, 250 BITMAP oBitmapC3 SIZE 250, 030 OF oDlg FILENAME cG10 NOBORDER PIXEL
					ELSEIF ((nTotCort3/nTimeProd)*100) > 40 .AND. ((nTotCort3/nTimeProd)*100) <= 44
						@ nLin, 250 BITMAP oBitmapC3 SIZE 250, 030 OF oDlg FILENAME cG11 NOBORDER PIXEL
					ELSEIF ((nTotCort3/nTimeProd)*100) > 44 .AND. ((nTotCort3/nTimeProd)*100) <= 48
						@ nLin, 250 BITMAP oBitmapC3 SIZE 250, 030 OF oDlg FILENAME cG12 NOBORDER PIXEL
					ELSEIF ((nTotCort3/nTimeProd)*100) > 48 .AND. ((nTotCort3/nTimeProd)*100) <= 52
						@ nLin, 250 BITMAP oBitmapC3 SIZE 250, 030 OF oDlg FILENAME cG13 NOBORDER PIXEL
					ELSEIF ((nTotCort3/nTimeProd)*100) > 52 .AND. ((nTotCort3/nTimeProd)*100) <= 56
						@ nLin, 250 BITMAP oBitmapC3 SIZE 250, 030 OF oDlg FILENAME cG14 NOBORDER PIXEL
					ELSEIF ((nTotCort3/nTimeProd)*100) > 56 .AND. ((nTotCort3/nTimeProd)*100) <= 60
						@ nLin, 250 BITMAP oBitmapC3 SIZE 250, 030 OF oDlg FILENAME cG15 NOBORDER PIXEL
					ELSEIF ((nTotCort3/nTimeProd)*100) > 60 .AND. ((nTotCort3/nTimeProd)*100) <= 64
						@ nLin, 250 BITMAP oBitmapC3 SIZE 250, 030 OF oDlg FILENAME cG16 NOBORDER PIXEL
					ELSEIF ((nTotCort3/nTimeProd)*100) > 64 .AND. ((nTotCort3/nTimeProd)*100) <= 68
						@ nLin, 250 BITMAP oBitmapC3 SIZE 250, 030 OF oDlg FILENAME cG17 NOBORDER PIXEL
					ELSEIF ((nTotCort3/nTimeProd)*100) > 68 .AND. ((nTotCort3/nTimeProd)*100) <= 72
						@ nLin, 250 BITMAP oBitmapC3 SIZE 250, 030 OF oDlg FILENAME cG18 NOBORDER PIXEL
					ELSEIF ((nTotCort3/nTimeProd)*100) > 72 .AND. ((nTotCort3/nTimeProd)*100) <= 76
						@ nLin, 250 BITMAP oBitmapC3 SIZE 250, 030 OF oDlg FILENAME cG19 NOBORDER PIXEL
					ELSEIF ((nTotCort3/nTimeProd)*100) > 76 .AND. ((nTotCort3/nTimeProd)*100) <= 80
						@ nLin, 250 BITMAP oBitmapC3 SIZE 250, 030 OF oDlg FILENAME cG20 NOBORDER PIXEL
					ELSEIF ((nTotCort3/nTimeProd)*100) > 80 .AND. ((nTotCort3/nTimeProd)*100) <= 84
						@ nLin, 250 BITMAP oBitmapC3 SIZE 250, 030 OF oDlg FILENAME cG21 NOBORDER PIXEL
					ELSEIF ((nTotCort3/nTimeProd)*100) > 84 .AND. ((nTotCort3/nTimeProd)*100) <= 88
						@ nLin, 250 BITMAP oBitmapC3 SIZE 250, 030 OF oDlg FILENAME cG22 NOBORDER PIXEL
					ELSEIF ((nTotCort3/nTimeProd)*100) > 88 .AND. ((nTotCort3/nTimeProd)*100) <= 92
						@ nLin, 250 BITMAP oBitmapC3 SIZE 250, 030 OF oDlg FILENAME cG23 NOBORDER PIXEL
					ELSEIF ((nTotCort3/nTimeProd)*100) > 92 .AND. ((nTotCort3/nTimeProd)*100) <= 96
						@ nLin, 250 BITMAP oBitmapC3 SIZE 250, 030 OF oDlg FILENAME cG24 NOBORDER PIXEL
					ELSEIF ((nTotCort3/nTimeProd)*100) > 96
						@ nLin, 250 BITMAP oBitmapC3 SIZE 250, 030 OF oDlg FILENAME cG25 NOBORDER PIXEL
					Endif

				Elseif (nTpProd == 1 .and. Alltrim(QRY->CORTE) == "CORTE 4")  .or. (nTpProd == 3 .and.  Alltrim(QRY->CORTE) == "DROP 4" )   .or. (nTpProd == 2 .and.  Alltrim(QRY->CORTE) == "TRUNK 4")	.or. (nTpProd == 4 .and.  Alltrim(QRY->CORTE) == "JUMPER 4") .or. (nTpProd == 5 .and.  Alltrim(QRY->CORTE) == "PRECON 4")
					nTotCort4+= QRY->TEMPC
					nLin:=60
					FreeObj(oBitmapC4)
					IF ((nTotCort4/nTimeProd)*100) == 0
						@ nLin, 250 BITMAP oBitmapC4 SIZE 250, 030 OF oDlg FILENAME cG0 NOBORDER PIXEL
					ELSEIF ((nTotCort4/nTimeProd)*100) > 0 .AND. ((nTotCort4/nTimeProd)*100) <= 4
						@ nLin, 250 BITMAP oBitmapC4 SIZE 250, 030 OF oDlg FILENAME cG1 NOBORDER PIXEL
					ELSEIF ((nTotCort4/nTimeProd)*100) > 4 .AND. ((nTotCort4/nTimeProd)*100) <= 8
						@ nLin, 250 BITMAP oBitmapC4 SIZE 250, 030 OF oDlg FILENAME cG2 NOBORDER PIXEL
					ELSEIF ((nTotCort4/nTimeProd)*100) > 8 .AND. ((nTotCort4/nTimeProd)*100) <= 12
						@ nLin, 250 BITMAP oBitmapC4 SIZE 250, 030 OF oDlg FILENAME cG3 NOBORDER PIXEL
					ELSEIF ((nTotCort4/nTimeProd)*100) > 12 .AND. ((nTotCort4/nTimeProd)*100) <= 16
						@ nLin, 250 BITMAP oBitmapC4 SIZE 250, 030 OF oDlg FILENAME cG4 NOBORDER PIXEL
					ELSEIF ((nTotCort4/nTimeProd)*100) > 16 .AND. ((nTotCort4/nTimeProd)*100) <= 20
						@ nLin, 250 BITMAP oBitmapC4 SIZE 250, 030 OF oDlg FILENAME cG5 NOBORDER PIXEL
					ELSEIF ((nTotCort4/nTimeProd)*100) > 20 .AND. ((nTotCort4/nTimeProd)*100) <= 24
						@ nLin, 250 BITMAP oBitmapC4 SIZE 250, 030 OF oDlg FILENAME cG6 NOBORDER PIXEL
					ELSEIF ((nTotCort4/nTimeProd)*100) > 24 .AND. ((nTotCort4/nTimeProd)*100) <= 28
						@ nLin, 250 BITMAP oBitmapC4 SIZE 250, 030 OF oDlg FILENAME cG7 NOBORDER PIXEL
					ELSEIF ((nTotCort4/nTimeProd)*100) > 28 .AND. ((nTotCort4/nTimeProd)*100) <= 32
						@ nLin, 250 BITMAP oBitmapC4 SIZE 250, 030 OF oDlg FILENAME cG8 NOBORDER PIXEL
					ELSEIF ((nTotCort4/nTimeProd)*100) > 32 .AND. ((nTotCort4/nTimeProd)*100) <= 36
						@ nLin, 250 BITMAP oBitmapC4 SIZE 250, 030 OF oDlg FILENAME cG9 NOBORDER PIXEL
					ELSEIF ((nTotCort4/nTimeProd)*100) > 36 .AND. ((nTotCort4/nTimeProd)*100) <= 40
						@ nLin, 250 BITMAP oBitmapC4 SIZE 250, 030 OF oDlg FILENAME cG10 NOBORDER PIXEL
					ELSEIF ((nTotCort4/nTimeProd)*100) > 40 .AND. ((nTotCort4/nTimeProd)*100) <= 44
						@ nLin, 250 BITMAP oBitmapC4 SIZE 250, 030 OF oDlg FILENAME cG11 NOBORDER PIXEL
					ELSEIF ((nTotCort4/nTimeProd)*100) > 44 .AND. ((nTotCort4/nTimeProd)*100) <= 48
						@ nLin, 250 BITMAP oBitmapC4 SIZE 250, 030 OF oDlg FILENAME cG12 NOBORDER PIXEL
					ELSEIF ((nTotCort4/nTimeProd)*100) > 48 .AND. ((nTotCort4/nTimeProd)*100) <= 52
						@ nLin, 250 BITMAP oBitmapC4 SIZE 250, 030 OF oDlg FILENAME cG13 NOBORDER PIXEL
					ELSEIF ((nTotCort4/nTimeProd)*100) > 52 .AND. ((nTotCort4/nTimeProd)*100) <= 56
						@ nLin, 250 BITMAP oBitmapC4 SIZE 250, 030 OF oDlg FILENAME cG14 NOBORDER PIXEL
					ELSEIF ((nTotCort4/nTimeProd)*100) > 56 .AND. ((nTotCort4/nTimeProd)*100) <= 60
						@ nLin, 250 BITMAP oBitmapC4 SIZE 250, 030 OF oDlg FILENAME cG15 NOBORDER PIXEL
					ELSEIF ((nTotCort4/nTimeProd)*100) > 60 .AND. ((nTotCort4/nTimeProd)*100) <= 64
						@ nLin, 250 BITMAP oBitmapC4 SIZE 250, 030 OF oDlg FILENAME cG16 NOBORDER PIXEL
					ELSEIF ((nTotCort4/nTimeProd)*100) > 64 .AND. ((nTotCort4/nTimeProd)*100) <= 68
						@ nLin, 250 BITMAP oBitmapC4 SIZE 250, 030 OF oDlg FILENAME cG17 NOBORDER PIXEL
					ELSEIF ((nTotCort4/nTimeProd)*100) > 68 .AND. ((nTotCort4/nTimeProd)*100) <= 72
						@ nLin, 250 BITMAP oBitmapC4 SIZE 250, 030 OF oDlg FILENAME cG18 NOBORDER PIXEL
					ELSEIF ((nTotCort4/nTimeProd)*100) > 72 .AND. ((nTotCort4/nTimeProd)*100) <= 76
						@ nLin, 250 BITMAP oBitmapC4 SIZE 250, 030 OF oDlg FILENAME cG19 NOBORDER PIXEL
					ELSEIF ((nTotCort4/nTimeProd)*100) > 76 .AND. ((nTotCort4/nTimeProd)*100) <= 80
						@ nLin, 250 BITMAP oBitmapC4 SIZE 250, 030 OF oDlg FILENAME cG20 NOBORDER PIXEL
					ELSEIF ((nTotCort4/nTimeProd)*100) > 80 .AND. ((nTotCort4/nTimeProd)*100) <= 84
						@ nLin, 250 BITMAP oBitmapC4 SIZE 250, 030 OF oDlg FILENAME cG21 NOBORDER PIXEL
					ELSEIF ((nTotCort4/nTimeProd)*100) > 84 .AND. ((nTotCort4/nTimeProd)*100) <= 88
						@ nLin, 250 BITMAP oBitmapC4 SIZE 250, 030 OF oDlg FILENAME cG22 NOBORDER PIXEL
					ELSEIF ((nTotCort4/nTimeProd)*100) > 88 .AND. ((nTotCort4/nTimeProd)*100) <= 92
						@ nLin, 250 BITMAP oBitmapC4 SIZE 250, 030 OF oDlg FILENAME cG23 NOBORDER PIXEL
					ELSEIF ((nTotCort4/nTimeProd)*100) > 92 .AND. ((nTotCort4/nTimeProd)*100) <= 96
						@ nLin, 250 BITMAP oBitmapC4 SIZE 250, 030 OF oDlg FILENAME cG24 NOBORDER PIXEL
					ELSEIF ((nTotCort4/nTimeProd)*100) > 96
						@ nLin, 250 BITMAP oBitmapC4 SIZE 250, 030 OF oDlg FILENAME cG25 NOBORDER PIXEL
					Endif

				Elseif (nTpProd == 1 .and. Alltrim(QRY->CORTE) == "CORTE 5")  .or. (nTpProd == 3 .and.  Alltrim(QRY->CORTE) == "DROP 5" )   .or. (nTpProd == 2 .and.  Alltrim(QRY->CORTE) == "TRUNK 5")	.or. (nTpProd == 4 .and.  Alltrim(QRY->CORTE) == "JUMPER 5") .or. (nTpProd == 5 .and.  Alltrim(QRY->CORTE) == "PRECON 5")
					nTotCort5+= QRY->TEMPC
					nLin:=78
					FreeObj(oBitmapC5)
					IF ((nTotCort5/nTimeProd)*100) == 0
						@ nLin, 250 BITMAP oBitmapC5 SIZE 250, 030 OF oDlg FILENAME cG0 NOBORDER PIXEL
					ELSEIF ((nTotCort5/nTimeProd)*100) > 0 .AND. ((nTotCort5/nTimeProd)*100) <= 4
						@ nLin, 250 BITMAP oBitmapC5 SIZE 250, 030 OF oDlg FILENAME cG1 NOBORDER PIXEL
					ELSEIF ((nTotCort5/nTimeProd)*100) > 4 .AND. ((nTotCort5/nTimeProd)*100) <= 8
						@ nLin, 250 BITMAP oBitmapC5 SIZE 250, 030 OF oDlg FILENAME cG2 NOBORDER PIXEL
					ELSEIF ((nTotCort5/nTimeProd)*100) > 8 .AND. ((nTotCort5/nTimeProd)*100) <= 12
						@ nLin, 250 BITMAP oBitmapC5 SIZE 250, 030 OF oDlg FILENAME cG3 NOBORDER PIXEL
					ELSEIF ((nTotCort5/nTimeProd)*100) > 12 .AND. ((nTotCort5/nTimeProd)*100) <= 16
						@ nLin, 250 BITMAP oBitmapC5 SIZE 250, 030 OF oDlg FILENAME cG4 NOBORDER PIXEL
					ELSEIF ((nTotCort5/nTimeProd)*100) > 16 .AND. ((nTotCort5/nTimeProd)*100) <= 20
						@ nLin, 250 BITMAP oBitmapC5 SIZE 250, 030 OF oDlg FILENAME cG5 NOBORDER PIXEL
					ELSEIF ((nTotCort5/nTimeProd)*100) > 20 .AND. ((nTotCort5/nTimeProd)*100) <= 24
						@ nLin, 250 BITMAP oBitmapC5 SIZE 250, 030 OF oDlg FILENAME cG6 NOBORDER PIXEL
					ELSEIF ((nTotCort5/nTimeProd)*100) > 24 .AND. ((nTotCort5/nTimeProd)*100) <= 28
						@ nLin, 250 BITMAP oBitmapC5 SIZE 250, 030 OF oDlg FILENAME cG7 NOBORDER PIXEL
					ELSEIF ((nTotCort5/nTimeProd)*100) > 28 .AND. ((nTotCort5/nTimeProd)*100) <= 32
						@ nLin, 250 BITMAP oBitmapC5 SIZE 250, 030 OF oDlg FILENAME cG8 NOBORDER PIXEL
					ELSEIF ((nTotCort5/nTimeProd)*100) > 32 .AND. ((nTotCort5/nTimeProd)*100) <= 36
						@ nLin, 250 BITMAP oBitmapC5 SIZE 250, 030 OF oDlg FILENAME cG9 NOBORDER PIXEL
					ELSEIF ((nTotCort5/nTimeProd)*100) > 36 .AND. ((nTotCort5/nTimeProd)*100) <= 40
						@ nLin, 250 BITMAP oBitmapC5 SIZE 250, 030 OF oDlg FILENAME cG10 NOBORDER PIXEL
					ELSEIF ((nTotCort5/nTimeProd)*100) > 40 .AND. ((nTotCort5/nTimeProd)*100) <= 44
						@ nLin, 250 BITMAP oBitmapC5 SIZE 250, 030 OF oDlg FILENAME cG11 NOBORDER PIXEL
					ELSEIF ((nTotCort5/nTimeProd)*100) > 44 .AND. ((nTotCort5/nTimeProd)*100) <= 48
						@ nLin, 250 BITMAP oBitmapC5 SIZE 250, 030 OF oDlg FILENAME cG12 NOBORDER PIXEL
					ELSEIF ((nTotCort5/nTimeProd)*100) > 48 .AND. ((nTotCort5/nTimeProd)*100) <= 52
						@ nLin, 250 BITMAP oBitmapC5 SIZE 250, 030 OF oDlg FILENAME cG13 NOBORDER PIXEL
					ELSEIF ((nTotCort5/nTimeProd)*100) > 52 .AND. ((nTotCort5/nTimeProd)*100) <= 56
						@ nLin, 250 BITMAP oBitmapC5 SIZE 250, 030 OF oDlg FILENAME cG14 NOBORDER PIXEL
					ELSEIF ((nTotCort5/nTimeProd)*100) > 56 .AND. ((nTotCort5/nTimeProd)*100) <= 60
						@ nLin, 250 BITMAP oBitmapC5 SIZE 250, 030 OF oDlg FILENAME cG15 NOBORDER PIXEL
					ELSEIF ((nTotCort5/nTimeProd)*100) > 60 .AND. ((nTotCort5/nTimeProd)*100) <= 64
						@ nLin, 250 BITMAP oBitmapC5 SIZE 250, 030 OF oDlg FILENAME cG16 NOBORDER PIXEL
					ELSEIF ((nTotCort5/nTimeProd)*100) > 64 .AND. ((nTotCort5/nTimeProd)*100) <= 68
						@ nLin, 250 BITMAP oBitmapC5 SIZE 250, 030 OF oDlg FILENAME cG17 NOBORDER PIXEL
					ELSEIF ((nTotCort5/nTimeProd)*100) > 68 .AND. ((nTotCort5/nTimeProd)*100) <= 72
						@ nLin, 250 BITMAP oBitmapC5 SIZE 250, 030 OF oDlg FILENAME cG18 NOBORDER PIXEL
					ELSEIF ((nTotCort5/nTimeProd)*100) > 72 .AND. ((nTotCort5/nTimeProd)*100) <= 76
						@ nLin, 250 BITMAP oBitmapC5 SIZE 250, 030 OF oDlg FILENAME cG19 NOBORDER PIXEL
					ELSEIF ((nTotCort5/nTimeProd)*100) > 76 .AND. ((nTotCort5/nTimeProd)*100) <= 80
						@ nLin, 250 BITMAP oBitmapC5 SIZE 250, 030 OF oDlg FILENAME cG20 NOBORDER PIXEL
					ELSEIF ((nTotCort5/nTimeProd)*100) > 80 .AND. ((nTotCort5/nTimeProd)*100) <= 84
						@ nLin, 250 BITMAP oBitmapC5 SIZE 250, 030 OF oDlg FILENAME cG21 NOBORDER PIXEL
					ELSEIF ((nTotCort5/nTimeProd)*100) > 84 .AND. ((nTotCort5/nTimeProd)*100) <= 88
						@ nLin, 250 BITMAP oBitmapC5 SIZE 250, 030 OF oDlg FILENAME cG22 NOBORDER PIXEL
					ELSEIF ((nTotCort5/nTimeProd)*100) > 88 .AND. ((nTotCort5/nTimeProd)*100) <= 92
						@ nLin, 250 BITMAP oBitmapC5 SIZE 250, 030 OF oDlg FILENAME cG23 NOBORDER PIXEL
					ELSEIF ((nTotCort5/nTimeProd)*100) > 92 .AND. ((nTotCort5/nTimeProd)*100) <= 96
						@ nLin, 250 BITMAP oBitmapC5 SIZE 250, 030 OF oDlg FILENAME cG24 NOBORDER PIXEL
					ELSEIF ((nTotCort5/nTimeProd)*100) > 96
						@ nLin, 250 BITMAP oBitmapC5 SIZE 250, 030 OF oDlg FILENAME cG25 NOBORDER PIXEL
					Endif

				Endif
			Endif

			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'TEMP_PROD' 	})] := QRY->TEMPC


			if !empty(QRY->TEMPL) .AND.  QRY->DTPRG == DtOS(dDtProg)

				if Alltrim(QRY->LINHA) == "LINHA 1"

					nTotLin1+= QRY->TEMPL
					FreeObj(oBitmapL1)
					IF ((nTotLin1/nTimeMont)*100) == 0
						@ nXBt2+26, X1 BITMAP oBitmapL1 SIZE 250, 030 OF oDlg FILENAME cG0B NOBORDER PIXEL
					ELSEIF ((nTotLin1/nTimeMont)*100) > 0 .AND. ((nTotLin1/nTimeMont)*100) <= 4
						@ nXBt2+26, X1 BITMAP oBitmapL1 SIZE 250, 030 OF oDlg FILENAME cG1B NOBORDER PIXEL
					ELSEIF ((nTotLin1/nTimeMont)*100) > 4 .AND. ((nTotLin1/nTimeMont)*100) <= 8
						@ nXBt2+26, X1 BITMAP oBitmapL1 SIZE 250, 030 OF oDlg FILENAME cG2B NOBORDER PIXEL
					ELSEIF ((nTotLin1/nTimeMont)*100) > 8 .AND. ((nTotLin1/nTimeMont)*100) <= 12
						@ nXBt2+26, X1 BITMAP oBitmapL1 SIZE 250, 030 OF oDlg FILENAME cG3B NOBORDER PIXEL
					ELSEIF ((nTotLin1/nTimeMont)*100) > 12 .AND. ((nTotLin1/nTimeMont)*100) <= 16
						@ nXBt2+26, X1 BITMAP oBitmapL1 SIZE 250, 030 OF oDlg FILENAME cG4B NOBORDER PIXEL
					ELSEIF ((nTotLin1/nTimeMont)*100) > 16 .AND. ((nTotLin1/nTimeMont)*100) <= 20
						@ nXBt2+26, X1 BITMAP oBitmapL1 SIZE 250, 030 OF oDlg FILENAME cG5B NOBORDER PIXEL
					ELSEIF ((nTotLin1/nTimeMont)*100) > 20 .AND. ((nTotLin1/nTimeMont)*100) <= 24
						@ nXBt2+26, X1 BITMAP oBitmapL1 SIZE 250, 030 OF oDlg FILENAME cG6B NOBORDER PIXEL
					ELSEIF ((nTotLin1/nTimeMont)*100) > 24 .AND. ((nTotLin1/nTimeMont)*100) <= 28
						@ nXBt2+26, X1 BITMAP oBitmapL1 SIZE 250, 030 OF oDlg FILENAME cG7B NOBORDER PIXEL
					ELSEIF ((nTotLin1/nTimeMont)*100) > 28 .AND. ((nTotLin1/nTimeMont)*100) <= 32
						@ nXBt2+26, X1 BITMAP oBitmapL1 SIZE 250, 030 OF oDlg FILENAME cG8B NOBORDER PIXEL
					ELSEIF ((nTotLin1/nTimeMont)*100) > 32 .AND. ((nTotLin1/nTimeMont)*100) <= 36
						@ nXBt2+26, X1 BITMAP oBitmapL1 SIZE 250, 030 OF oDlg FILENAME cG9B NOBORDER PIXEL
					ELSEIF ((nTotLin1/nTimeMont)*100) > 36 .AND. ((nTotLin1/nTimeMont)*100) <= 40
						@ nXBt2+26, X1 BITMAP oBitmapL1 SIZE 250, 030 OF oDlg FILENAME cG10B NOBORDER PIXEL
					ELSEIF ((nTotLin1/nTimeMont)*100) > 40 .AND. ((nTotLin1/nTimeMont)*100) <= 44
						@ nXBt2+26, X1 BITMAP oBitmapL1 SIZE 250, 030 OF oDlg FILENAME cG11B NOBORDER PIXEL
					ELSEIF ((nTotLin1/nTimeMont)*100) > 44 .AND. ((nTotLin1/nTimeMont)*100) <= 48
						@ nXBt2+26, X1 BITMAP oBitmapL1 SIZE 250, 030 OF oDlg FILENAME cG12B NOBRORDER PIXEL
					ELSEIF ((nTotLin1/nTimeMont)*100) > 48 .AND. ((nTotLin1/nTimeMont)*100) <= 52
						@ nXBt2+26, X1 BITMAP oBitmapL1 SIZE 250, 030 OF oDlg FILENAME cG13B NOBORDER PIXEL
					ELSEIF ((nTotLin1/nTimeMont)*100) > 52 .AND. ((nTotLin1/nTimeMont)*100) <= 56
						@ nXBt2+26, X1 BITMAP oBitmapL1 SIZE 250, 030 OF oDlg FILENAME cG14B NOBORDER PIXEL
					ELSEIF ((nTotLin1/nTimeMont)*100) > 56 .AND. ((nTotLin1/nTimeMont)*100) <= 60
						@ nXBt2+26, X1 BITMAP oBitmapL1 SIZE 250, 030 OF oDlg FILENAME cG15B NOBORDER PIXEL
					ELSEIF ((nTotLin1/nTimeMont)*100) > 60 .AND. ((nTotLin1/nTimeMont)*100) <= 64
						@ nXBt2+26, X1 BITMAP oBitmapL1 SIZE 250, 030 OF oDlg FILENAME cG16B NOBORDER PIXEL
					ELSEIF ((nTotLin1/nTimeMont)*100) > 64 .AND. ((nTotLin1/nTimeMont)*100) <= 68
						@ nXBt2+26, X1 BITMAP oBitmapL1 SIZE 250, 030 OF oDlg FILENAME cG17B NOBORDER PIXEL
					ELSEIF ((nTotLin1/nTimeMont)*100) > 68 .AND. ((nTotLin1/nTimeMont)*100) <= 72
						@ nXBt2+26, X1 BITMAP oBitmapL1 SIZE 250, 030 OF oDlg FILENAME cG18B NOBORDER PIXEL
					ELSEIF ((nTotLin1/nTimeMont)*100) > 72 .AND. ((nTotLin1/nTimeMont)*100) <= 76
						@ nXBt2+26, X1 BITMAP oBitmapL1 SIZE 250, 030 OF oDlg FILENAME cG19B NOBORDER PIXEL
					ELSEIF ((nTotLin1/nTimeMont)*100) > 76 .AND. ((nTotLin1/nTimeMont)*100) <= 80
						@ nXBt2+26, X1 BITMAP oBitmapL1 SIZE 250, 030 OF oDlg FILENAME cG20B NOBORDER PIXEL
					ELSEIF ((nTotLin1/nTimeMont)*100) > 80 .AND. ((nTotLin1/nTimeMont)*100) <= 84
						@ nXBt2+26, X1 BITMAP oBitmapL1 SIZE 250, 030 OF oDlg FILENAME cG21B NOBORDER PIXEL
					ELSEIF ((nTotLin1/nTimeMont)*100) > 84 .AND. ((nTotLin1/nTimeMont)*100) <= 88
						@ nXBt2+26, X1 BITMAP oBitmapL1 SIZE 250, 030 OF oDlg FILENAME cG22B NOBORDER PIXEL
					ELSEIF ((nTotLin1/nTimeMont)*100) > 88 .AND. ((nTotLin1/nTimeMont)*100) <= 92
						@ nXBt2+26, X1 BITMAP oBitmapL1 SIZE 250, 030 OF oDlg FILENAME cG23B NOBORDER PIXEL
					ELSEIF ((nTotLin1/nTimeMont)*100) > 92 .AND. ((nTotLin1/nTimeMont)*100) <= 96
						@ nXBt2+26, X1 BITMAP oBitmapL1 SIZE 250, 030 OF oDlg FILENAME cG24B NOBORDER PIXEL
					ELSEIF ((nTotLin1/nTimeMont)*100) > 96
						@ nXBt2+26, X1 BITMAP oBitmapL1 SIZE 250, 030 OF oDlg FILENAME cG25B NOBORDER PIXEL
					Endif


				Elseif Alltrim(QRY->LINHA) == "LINHA 2"
					nTotLin2+= QRY->TEMPL
					FreeObj(oBitmapL2)
					IF ((nTotLin2/nTimeMont)*100) == 0
						@ nXBt2+26, X1+(X2*1) BITMAP oBitmapL2 SIZE 250, 030 OF oDlg FILENAME cG0B NOBORDER PIXEL
					ELSEIF ((nTotLin2/nTimeMont)*100) > 0 .AND. ((nTotLin2/nTimeMont)*100) <= 4
						@ nXBt2+26, X1+(X2*1) BITMAP oBitmapL2 SIZE 250, 030 OF oDlg FILENAME cG1B NOBORDER PIXEL
					ELSEIF ((nTotLin2/nTimeMont)*100) > 4 .AND. ((nTotLin2/nTimeMont)*100) <= 8
						@ nXBt2+26, X1+(X2*1) BITMAP oBitmapL2 SIZE 250, 030 OF oDlg FILENAME cG2B NOBORDER PIXEL
					ELSEIF ((nTotLin2/nTimeMont)*100) > 8 .AND. ((nTotLin2/nTimeMont)*100) <= 12
						@ nXBt2+26, X1+(X2*1) BITMAP oBitmapL2 SIZE 250, 030 OF oDlg FILENAME cG3B NOBORDER PIXEL
					ELSEIF ((nTotLin2/nTimeMont)*100) > 12 .AND. ((nTotLin2/nTimeMont)*100) <= 16
						@ nXBt2+26, X1+(X2*1) BITMAP oBitmapL2 SIZE 250, 030 OF oDlg FILENAME cG4B NOBORDER PIXEL
					ELSEIF ((nTotLin2/nTimeMont)*100) > 16 .AND. ((nTotLin2/nTimeMont)*100) <= 20
						@ nXBt2+26, X1+(X2*1) BITMAP oBitmapL2 SIZE 250, 030 OF oDlg FILENAME cG5B NOBORDER PIXEL
					ELSEIF ((nTotLin2/nTimeMont)*100) > 20 .AND. ((nTotLin2/nTimeMont)*100) <= 24
						@ nXBt2+26, X1+(X2*1) BITMAP oBitmapL2 SIZE 250, 030 OF oDlg FILENAME cG6B NOBORDER PIXEL
					ELSEIF ((nTotLin2/nTimeMont)*100) > 24 .AND. ((nTotLin2/nTimeMont)*100) <= 28
						@ nXBt2+26, X1+(X2*1) BITMAP oBitmapL2 SIZE 250, 030 OF oDlg FILENAME cG7B NOBORDER PIXEL
					ELSEIF ((nTotLin2/nTimeMont)*100) > 28 .AND. ((nTotLin2/nTimeMont)*100) <= 32
						@ nXBt2+26, X1+(X2*1) BITMAP oBitmapL2 SIZE 250, 030 OF oDlg FILENAME cG8B NOBORDER PIXEL
					ELSEIF ((nTotLin2/nTimeMont)*100) > 32 .AND. ((nTotLin2/nTimeMont)*100) <= 36
						@ nXBt2+26, X1+(X2*1) BITMAP oBitmapL2 SIZE 250, 030 OF oDlg FILENAME cG9B NOBORDER PIXEL
					ELSEIF ((nTotLin2/nTimeMont)*100) > 36 .AND. ((nTotLin2/nTimeMont)*100) <= 40
						@ nXBt2+26, X1+(X2*1) BITMAP oBitmapL2 SIZE 250, 030 OF oDlg FILENAME cG10B NOBORDER PIXEL
					ELSEIF ((nTotLin2/nTimeMont)*100) > 40 .AND. ((nTotLin2/nTimeMont)*100) <= 44
						@ nXBt2+26, X1+(X2*1) BITMAP oBitmapL2 SIZE 250, 030 OF oDlg FILENAME cG11B NOBORDER PIXEL
					ELSEIF ((nTotLin2/nTimeMont)*100) > 44 .AND. ((nTotLin2/nTimeMont)*100) <= 48
						@ nXBt2+26, X1+(X2*1) BITMAP oBitmapL2 SIZE 250, 030 OF oDlg FILENAME cG12B NOBORDER PIXEL
					ELSEIF ((nTotLin2/nTimeMont)*100) > 48 .AND. ((nTotLin2/nTimeMont)*100) <= 52
						@ nXBt2+26, X1+(X2*1) BITMAP oBitmapL2 SIZE 250, 030 OF oDlg FILENAME cG13B NOBORDER PIXEL
					ELSEIF ((nTotLin2/nTimeMont)*100) > 52 .AND. ((nTotLin2/nTimeMont)*100) <= 56
						@ nXBt2+26, X1+(X2*1) BITMAP oBitmapL2 SIZE 250, 030 OF oDlg FILENAME cG14B NOBORDER PIXEL
					ELSEIF ((nTotLin2/nTimeMont)*100) > 56 .AND. ((nTotLin2/nTimeMont)*100) <= 60
						@ nXBt2+26, X1+(X2*1) BITMAP oBitmapL2 SIZE 250, 030 OF oDlg FILENAME cG15B NOBORDER PIXEL
					ELSEIF ((nTotLin2/nTimeMont)*100) > 60 .AND. ((nTotLin2/nTimeMont)*100) <= 64
						@ nXBt2+26, X1+(X2*1) BITMAP oBitmapL2 SIZE 250, 030 OF oDlg FILENAME cG16B NOBORDER PIXEL
					ELSEIF ((nTotLin2/nTimeMont)*100) > 64 .AND. ((nTotLin2/nTimeMont)*100) <= 68
						@ nXBt2+26, X1+(X2*1) BITMAP oBitmapL2 SIZE 250, 030 OF oDlg FILENAME cG17B NOBORDER PIXEL
					ELSEIF ((nTotLin2/nTimeMont)*100) > 68 .AND. ((nTotLin2/nTimeMont)*100) <= 72
						@ nXBt2+26, X1+(X2*1) BITMAP oBitmapL2 SIZE 250, 030 OF oDlg FILENAME cG18B NOBORDER PIXEL
					ELSEIF ((nTotLin2/nTimeMont)*100) > 72 .AND. ((nTotLin2/nTimeMont)*100) <= 76
						@ nXBt2+26, X1+(X2*1) BITMAP oBitmapL2 SIZE 250, 030 OF oDlg FILENAME cG19B NOBORDER PIXEL
					ELSEIF ((nTotLin2/nTimeMont)*100) > 76 .AND. ((nTotLin2/nTimeMont)*100) <= 80
						@ nXBt2+26, X1+(X2*1) BITMAP oBitmapL2 SIZE 250, 030 OF oDlg FILENAME cG20B NOBORDER PIXEL
					ELSEIF ((nTotLin2/nTimeMont)*100) > 80 .AND. ((nTotLin2/nTimeMont)*100) <= 84
						@ nXBt2+26, X1+(X2*1) BITMAP oBitmapL2 SIZE 250, 030 OF oDlg FILENAME cG21B NOBORDER PIXEL
					ELSEIF ((nTotLin2/nTimeMont)*100) > 84 .AND. ((nTotLin2/nTimeMont)*100) <= 88
						@ nXBt2+26, X1+(X2*1) BITMAP oBitmapL2 SIZE 250, 030 OF oDlg FILENAME cG22B NOBORDER PIXEL
					ELSEIF ((nTotLin2/nTimeMont)*100) > 88 .AND. ((nTotLin2/nTimeMont)*100) <= 92
						@ nXBt2+26, X1+(X2*1) BITMAP oBitmapL2 SIZE 250, 030 OF oDlg FILENAME cG23B NOBORDER PIXEL
					ELSEIF ((nTotLin2/nTimeMont)*100) > 92 .AND. ((nTotLin2/nTimeMont)*100) <= 96
						@ nXBt2+26, X1+(X2*1) BITMAP oBitmapL2 SIZE 250, 030 OF oDlg FILENAME cG24B NOBORDER PIXEL
					ELSEIF ((nTotLin2/nTimeMont)*100) > 96
						@ nXBt2+26, X1+(X2*1) BITMAP oBitmapL2 SIZE 250, 030 OF oDlg FILENAME cG25B NOBORDER PIXEL
					Endif

				Elseif Alltrim(QRY->LINHA) == "LINHA 3"
					nTotLin3+= QRY->TEMPL
					FreeObj(oBitmapL3)
					IF ((nTotLin3/nTimeMont)*100) == 0
						@ nXBt2+26, X1+(X2*2) BITMAP oBitmapL3 SIZE 250, 030 OF oDlg FILENAME cG0B NOBORDER PIXEL
					ELSEIF ((nTotLin3/nTimeMont)*100) > 0 .AND. ((nTotLin3/nTimeMont)*100) <= 4
						@ nXBt2+26, X1+(X2*2) BITMAP oBitmapL3 SIZE 250, 030 OF oDlg FILENAME cG1B NOBORDER PIXEL
					ELSEIF ((nTotLin3/nTimeMont)*100) > 4 .AND. ((nTotLin3/nTimeMont)*100) <= 8
						@ nXBt2+26, X1+(X2*2) BITMAP oBitmapL3 SIZE 250, 030 OF oDlg FILENAME cG2B NOBORDER PIXEL
					ELSEIF ((nTotLin3/nTimeMont)*100) > 8 .AND. ((nTotLin3/nTimeMont)*100) <= 12
						@ nXBt2+26, X1+(X2*2) BITMAP oBitmapL3 SIZE 250, 030 OF oDlg FILENAME cG3B NOBORDER PIXEL
					ELSEIF ((nTotLin3/nTimeMont)*100) > 12 .AND. ((nTotLin3/nTimeMont)*100) <= 16
						@ nXBt2+26, X1+(X2*2) BITMAP oBitmapL3 SIZE 250, 030 OF oDlg FILENAME cG4B NOBORDER PIXEL
					ELSEIF ((nTotLin3/nTimeMont)*100) > 16 .AND. ((nTotLin3/nTimeMont)*100) <= 20
						@ nXBt2+26, X1+(X2*2) BITMAP oBitmapL3 SIZE 250, 030 OF oDlg FILENAME cG5B NOBORDER PIXEL
					ELSEIF ((nTotLin3/nTimeMont)*100) > 20 .AND. ((nTotLin3/nTimeMont)*100) <= 24
						@ nXBt2+26, X1+(X2*2) BITMAP oBitmapL3 SIZE 250, 030 OF oDlg FILENAME cG6B NOBORDER PIXEL
					ELSEIF ((nTotLin3/nTimeMont)*100) > 24 .AND. ((nTotLin3/nTimeMont)*100) <= 28
						@ nXBt2+26, X1+(X2*2) BITMAP oBitmapL3 SIZE 250, 030 OF oDlg FILENAME cG7B NOBORDER PIXEL
					ELSEIF ((nTotLin3/nTimeMont)*100) > 28 .AND. ((nTotLin3/nTimeMont)*100) <= 32
						@ nXBt2+26, X1+(X2*2) BITMAP oBitmapL3 SIZE 250, 030 OF oDlg FILENAME cG8B NOBORDER PIXEL
					ELSEIF ((nTotLin3/nTimeMont)*100) > 32 .AND. ((nTotLin3/nTimeMont)*100) <= 36
						@ nXBt2+26, X1+(X2*2) BITMAP oBitmapL3 SIZE 250, 030 OF oDlg FILENAME cG9B NOBORDER PIXEL
					ELSEIF ((nTotLin3/nTimeMont)*100) > 36 .AND. ((nTotLin3/nTimeMont)*100) <= 40
						@ nXBt2+26, X1+(X2*2) BITMAP oBitmapL3 SIZE 250, 030 OF oDlg FILENAME cG10B NOBORDER PIXEL
					ELSEIF ((nTotLin3/nTimeMont)*100) > 40 .AND. ((nTotLin3/nTimeMont)*100) <= 44
						@ nXBt2+26, X1+(X2*2) BITMAP oBitmapL3 SIZE 250, 030 OF oDlg FILENAME cG11B NOBORDER PIXEL
					ELSEIF ((nTotLin3/nTimeMont)*100) > 44 .AND. ((nTotLin3/nTimeMont)*100) <= 48
						@ nXBt2+26, X1+(X2*2) BITMAP oBitmapL3 SIZE 250, 030 OF oDlg FILENAME cG12B NOBORDER PIXEL
					ELSEIF ((nTotLin3/nTimeMont)*100) > 48 .AND. ((nTotLin3/nTimeMont)*100) <= 52
						@ nXBt2+26, X1+(X2*2) BITMAP oBitmapL3 SIZE 250, 030 OF oDlg FILENAME cG13B NOBORDER PIXEL
					ELSEIF ((nTotLin3/nTimeMont)*100) > 52 .AND. ((nTotLin3/nTimeMont)*100) <= 56
						@ nXBt2+26, X1+(X2*2) BITMAP oBitmapL3 SIZE 250, 030 OF oDlg FILENAME cG14B NOBORDER PIXEL
					ELSEIF ((nTotLin3/nTimeMont)*100) > 56 .AND. ((nTotLin3/nTimeMont)*100) <= 60
						@ nXBt2+26, X1+(X2*2) BITMAP oBitmapL3 SIZE 250, 030 OF oDlg FILENAME cG15B NOBORDER PIXEL
					ELSEIF ((nTotLin3/nTimeMont)*100) > 60 .AND. ((nTotLin3/nTimeMont)*100) <= 64
						@ nXBt2+26, X1+(X2*2) BITMAP oBitmapL3 SIZE 250, 030 OF oDlg FILENAME cG16B NOBORDER PIXEL
					ELSEIF ((nTotLin3/nTimeMont)*100) > 64 .AND. ((nTotLin3/nTimeMont)*100) <= 68
						@ nXBt2+26, X1+(X2*2) BITMAP oBitmapL3 SIZE 250, 030 OF oDlg FILENAME cG17B NOBORDER PIXEL
					ELSEIF ((nTotLin3/nTimeMont)*100) > 68 .AND. ((nTotLin3/nTimeMont)*100) <= 72
						@ nXBt2+26, X1+(X2*2) BITMAP oBitmapL3 SIZE 250, 030 OF oDlg FILENAME cG18B NOBORDER PIXEL
					ELSEIF ((nTotLin3/nTimeMont)*100) > 72 .AND. ((nTotLin3/nTimeMont)*100) <= 76
						@ nXBt2+26, X1+(X2*2) BITMAP oBitmapL3 SIZE 250, 030 OF oDlg FILENAME cG19B NOBORDER PIXEL
					ELSEIF ((nTotLin3/nTimeMont)*100) > 76 .AND. ((nTotLin3/nTimeMont)*100) <= 80
						@ nXBt2+26, X1+(X2*2) BITMAP oBitmapL3 SIZE 250, 030 OF oDlg FILENAME cG20B NOBORDER PIXEL
					ELSEIF ((nTotLin3/nTimeMont)*100) > 80 .AND. ((nTotLin3/nTimeMont)*100) <= 84
						@ nXBt2+26, X1+(X2*2) BITMAP oBitmapL3 SIZE 250, 030 OF oDlg FILENAME cG21B NOBORDER PIXEL
					ELSEIF ((nTotLin3/nTimeMont)*100) > 84 .AND. ((nTotLin3/nTimeMont)*100) <= 88
						@ nXBt2+26, X1+(X2*2) BITMAP oBitmapL3 SIZE 250, 030 OF oDlg FILENAME cG22B NOBORDER PIXEL
					ELSEIF ((nTotLin3/nTimeMont)*100) > 88 .AND. ((nTotLin3/nTimeMont)*100) <= 92
						@ nXBt2+26, X1+(X2*2) BITMAP oBitmapL3 SIZE 250, 030 OF oDlg FILENAME cG23B NOBORDER PIXEL
					ELSEIF ((nTotLin3/nTimeMont)*100) > 92 .AND. ((nTotLin3/nTimeMont)*100) <= 96
						@ nXBt2+26, X1+(X2*2) BITMAP oBitmapL3 SIZE 250, 030 OF oDlg FILENAME cG24B NOBORDER PIXEL
					ELSEIF ((nTotLin3/nTimeMont)*100) > 96
						@ nXBt2+26, X1+(X2*2) BITMAP oBitmapL3 SIZE 250, 030 OF oDlg FILENAME cG25B NOBORDER PIXEL
					Endif

				Elseif Alltrim(QRY->LINHA) == "LINHA 4"
					FreeObj(oBitmapL4)
					nTotLin4+= QRY->TEMPL
					IF ((nTotLin4/nTimeMont)*100) == 0
						@ nXBt2+26, X1+(X2*3) BITMAP oBitmapL4 SIZE 250, 030 OF oDlg FILENAME cG0B NOBORDER PIXEL
					ELSEIF ((nTotLin4/nTimeMont)*100) > 0 .AND. ((nTotLin4/nTimeMont)*100) <= 4
						@ nXBt2+26, X1+(X2*3) BITMAP oBitmapL4 SIZE 250, 030 OF oDlg FILENAME cG1B NOBORDER PIXEL
					ELSEIF ((nTotLin4/nTimeMont)*100) > 4 .AND. ((nTotLin4/nTimeMont)*100) <= 8
						@ nXBt2+26, X1+(X2*3) BITMAP oBitmapL4 SIZE 250, 030 OF oDlg FILENAME cG2B NOBORDER PIXEL
					ELSEIF ((nTotLin4/nTimeMont)*100) > 8 .AND. ((nTotLin4/nTimeMont)*100) <= 12
						@ nXBt2+26, X1+(X2*3) BITMAP oBitmapL4 SIZE 250, 030 OF oDlg FILENAME cG3B NOBORDER PIXEL
					ELSEIF ((nTotLin4/nTimeMont)*100) > 12 .AND. ((nTotLin4/nTimeMont)*100) <= 16
						@ nXBt2+26, X1+(X2*3) BITMAP oBitmapL4 SIZE 250, 030 OF oDlg FILENAME cG4B NOBORDER PIXEL
					ELSEIF ((nTotLin4/nTimeMont)*100) > 16 .AND. ((nTotLin4/nTimeMont)*100) <= 20
						@ nXBt2+26, X1+(X2*3) BITMAP oBitmapL4 SIZE 250, 030 OF oDlg FILENAME cG5B NOBORDER PIXEL
					ELSEIF ((nTotLin4/nTimeMont)*100) > 20 .AND. ((nTotLin4/nTimeMont)*100) <= 24
						@ nXBt2+26, X1+(X2*3) BITMAP oBitmapL4 SIZE 250, 030 OF oDlg FILENAME cG6B NOBORDER PIXEL
					ELSEIF ((nTotLin4/nTimeMont)*100) > 24 .AND. ((nTotLin4/nTimeMont)*100) <= 28
						@ nXBt2+26, X1+(X2*3) BITMAP oBitmapL4 SIZE 250, 030 OF oDlg FILENAME cG7B NOBORDER PIXEL
					ELSEIF ((nTotLin4/nTimeMont)*100) > 28 .AND. ((nTotLin4/nTimeMont)*100) <= 32
						@ nXBt2+26, X1+(X2*3) BITMAP oBitmapL4 SIZE 250, 030 OF oDlg FILENAME cG8B NOBORDER PIXEL
					ELSEIF ((nTotLin4/nTimeMont)*100) > 32 .AND. ((nTotLin4/nTimeMont)*100) <= 36
						@ nXBt2+26, X1+(X2*3) BITMAP oBitmapL4 SIZE 250, 030 OF oDlg FILENAME cG9B NOBORDER PIXEL
					ELSEIF ((nTotLin4/nTimeMont)*100) > 36 .AND. ((nTotLin4/nTimeMont)*100) <= 40
						@ nXBt2+26, X1+(X2*3) BITMAP oBitmapL4 SIZE 250, 030 OF oDlg FILENAME cG10B NOBORDER PIXEL
					ELSEIF ((nTotLin4/nTimeMont)*100) > 40 .AND. ((nTotLin4/nTimeMont)*100) <= 44
						@ nXBt2+26, X1+(X2*3) BITMAP oBitmapL4 SIZE 250, 030 OF oDlg FILENAME cG11B NOBORDER PIXEL
					ELSEIF ((nTotLin4/nTimeMont)*100) > 44 .AND. ((nTotLin4/nTimeMont)*100) <= 48
						@ nXBt2+26, X1+(X2*3) BITMAP oBitmapL4 SIZE 250, 030 OF oDlg FILENAME cG12B NOBORDER PIXEL
					ELSEIF ((nTotLin4/nTimeMont)*100) > 48 .AND. ((nTotLin4/nTimeMont)*100) <= 52
						@ nXBt2+26, X1+(X2*3) BITMAP oBitmapL4 SIZE 250, 030 OF oDlg FILENAME cG13B NOBORDER PIXEL
					ELSEIF ((nTotLin4/nTimeMont)*100) > 52 .AND. ((nTotLin4/nTimeMont)*100) <= 56
						@ nXBt2+26, X1+(X2*3) BITMAP oBitmapL4 SIZE 250, 030 OF oDlg FILENAME cG14B NOBORDER PIXEL
					ELSEIF ((nTotLin4/nTimeMont)*100) > 56 .AND. ((nTotLin4/nTimeMont)*100) <= 60
						@ nXBt2+26, X1+(X2*3) BITMAP oBitmapL4 SIZE 250, 030 OF oDlg FILENAME cG15B NOBORDER PIXEL
					ELSEIF ((nTotLin4/nTimeMont)*100) > 60 .AND. ((nTotLin4/nTimeMont)*100) <= 64
						@ nXBt2+26, X1+(X2*3) BITMAP oBitmapL4 SIZE 250, 030 OF oDlg FILENAME cG16B NOBORDER PIXEL
					ELSEIF ((nTotLin4/nTimeMont)*100) > 64 .AND. ((nTotLin4/nTimeMont)*100) <= 68
						@ nXBt2+26, X1+(X2*3) BITMAP oBitmapL4 SIZE 250, 030 OF oDlg FILENAME cG17B NOBORDER PIXEL
					ELSEIF ((nTotLin4/nTimeMont)*100) > 68 .AND. ((nTotLin4/nTimeMont)*100) <= 72
						@ nXBt2+26, X1+(X2*3) BITMAP oBitmapL4 SIZE 250, 030 OF oDlg FILENAME cG18B NOBORDER PIXEL
					ELSEIF ((nTotLin4/nTimeMont)*100) > 72 .AND. ((nTotLin4/nTimeMont)*100) <= 76
						@ nXBt2+26, X1+(X2*3) BITMAP oBitmapL4 SIZE 250, 030 OF oDlg FILENAME cG19B NOBORDER PIXEL
					ELSEIF ((nTotLin4/nTimeMont)*100) > 76 .AND. ((nTotLin4/nTimeMont)*100) <= 80
						@ nXBt2+26, X1+(X2*3) BITMAP oBitmapL4 SIZE 250, 030 OF oDlg FILENAME cG20B NOBORDER PIXEL
					ELSEIF ((nTotLin4/nTimeMont)*100) > 80 .AND. ((nTotLin4/nTimeMont)*100) <= 84
						@ nXBt2+26, X1+(X2*3) BITMAP oBitmapL4 SIZE 250, 030 OF oDlg FILENAME cG21B NOBORDER PIXEL
					ELSEIF ((nTotLin4/nTimeMont)*100) > 84 .AND. ((nTotLin4/nTimeMont)*100) <= 88
						@ nXBt2+26, X1+(X2*3) BITMAP oBitmapL4 SIZE 250, 030 OF oDlg FILENAME cG22B NOBORDER PIXEL
					ELSEIF ((nTotLin4/nTimeMont)*100) > 88 .AND. ((nTotLin4/nTimeMont)*100) <= 92
						@ nXBt2+26, X1+(X2*3) BITMAP oBitmapL4 SIZE 250, 030 OF oDlg FILENAME cG23B NOBORDER PIXEL
					ELSEIF ((nTotLin4/nTimeMont)*100) > 92 .AND. ((nTotLin4/nTimeMont)*100) <= 96
						@ nXBt2+26, X1+(X2*3) BITMAP oBitmapL4 SIZE 250, 030 OF oDlg FILENAME cG24B NOBORDER PIXEL
					ELSEIF ((nTotLin4/nTimeMont)*100) > 96
						@ nXBt2+26, X1+(X2*3) BITMAP oBitmapL4 SIZE 250, 030 OF oDlg FILENAME cG25B NOBORDER PIXEL
					Endif


				Elseif Alltrim(QRY->LINHA) == "LINHA 5"
					FreeObj(oBitmapL5)
					nTotLin5+= QRY->TEMPL
					IF ((nTotLin5/nTimeMont)*100) == 0
						@ nXBt2+26, X1+(X2*4) BITMAP oBitmapL5 SIZE 250, 030 OF oDlg FILENAME cG0B NOBORDER PIXEL
					ELSEIF ((nTotLin5/nTimeMont)*100) > 0 .AND. ((nTotLin5/nTimeMont)*100) <= 4
						@ nXBt2+26, X1+(X2*4) BITMAP oBitmapL5 SIZE 250, 030 OF oDlg FILENAME cG1B NOBORDER PIXEL
					ELSEIF ((nTotLin5/nTimeMont)*100) > 4 .AND. ((nTotLin5/nTimeMont)*100) <= 8
						@ nXBt2+26, X1+(X2*4) BITMAP oBitmapL5 SIZE 250, 030 OF oDlg FILENAME cG2B NOBORDER PIXEL
					ELSEIF ((nTotLin5/nTimeMont)*100) > 8 .AND. ((nTotLin5/nTimeMont)*100) <= 12
						@ nXBt2+26, X1+(X2*4) BITMAP oBitmapL5 SIZE 250, 030 OF oDlg FILENAME cG3B NOBORDER PIXEL
					ELSEIF ((nTotLin5/nTimeMont)*100) > 12 .AND. ((nTotLin5/nTimeMont)*100) <= 16
						@ nXBt2+26, X1+(X2*4) BITMAP oBitmapL5 SIZE 250, 030 OF oDlg FILENAME cG4B NOBORDER PIXEL
					ELSEIF ((nTotLin5/nTimeMont)*100) > 16 .AND. ((nTotLin5/nTimeMont)*100) <= 20
						@ nXBt2+26, X1+(X2*4) BITMAP oBitmapL5 SIZE 250, 030 OF oDlg FILENAME cG5B NOBORDER PIXEL
					ELSEIF ((nTotLin5/nTimeMont)*100) > 20 .AND. ((nTotLin5/nTimeMont)*100) <= 24
						@ nXBt2+26, X1+(X2*4) BITMAP oBitmapL5 SIZE 250, 030 OF oDlg FILENAME cG6B NOBORDER PIXEL
					ELSEIF ((nTotLin5/nTimeMont)*100) > 24 .AND. ((nTotLin5/nTimeMont)*100) <= 28
						@ nXBt2+26, X1+(X2*4) BITMAP oBitmapL5 SIZE 250, 030 OF oDlg FILENAME cG7B NOBORDER PIXEL
					ELSEIF ((nTotLin5/nTimeMont)*100) > 28 .AND. ((nTotLin5/nTimeMont)*100) <= 32
						@ nXBt2+26, X1+(X2*4) BITMAP oBitmapL5 SIZE 250, 030 OF oDlg FILENAME cG8B NOBORDER PIXEL
					ELSEIF ((nTotLin5/nTimeMont)*100) > 32 .AND. ((nTotLin5/nTimeMont)*100) <= 36
						@ nXBt2+26, X1+(X2*4) BITMAP oBitmapL5 SIZE 250, 030 OF oDlg FILENAME cG9B NOBORDER PIXEL
					ELSEIF ((nTotLin5/nTimeMont)*100) > 36 .AND. ((nTotLin5/nTimeMont)*100) <= 40
						@ nXBt2+26, X1+(X2*4) BITMAP oBitmapL5 SIZE 250, 030 OF oDlg FILENAME cG10B NOBORDER PIXEL
					ELSEIF ((nTotLin5/nTimeMont)*100) > 40 .AND. ((nTotLin5/nTimeMont)*100) <= 44
						@ nXBt2+26, X1+(X2*4) BITMAP oBitmapL5 SIZE 250, 030 OF oDlg FILENAME cG11B NOBORDER PIXEL
					ELSEIF ((nTotLin5/nTimeMont)*100) > 44 .AND. ((nTotLin5/nTimeMont)*100) <= 48
						@ nXBt2+26, X1+(X2*4) BITMAP oBitmapL5 SIZE 250, 030 OF oDlg FILENAME cG12B NOBORDER PIXEL
					ELSEIF ((nTotLin5/nTimeMont)*100) > 48 .AND. ((nTotLin5/nTimeMont)*100) <= 52
						@ nXBt2+26, X1+(X2*4) BITMAP oBitmapL5 SIZE 250, 030 OF oDlg FILENAME cG13B NOBORDER PIXEL
					ELSEIF ((nTotLin5/nTimeMont)*100) > 52 .AND. ((nTotLin5/nTimeMont)*100) <= 56
						@ nXBt2+26, X1+(X2*4) BITMAP oBitmapL5 SIZE 250, 030 OF oDlg FILENAME cG14B NOBORDER PIXEL
					ELSEIF ((nTotLin5/nTimeMont)*100) > 56 .AND. ((nTotLin5/nTimeMont)*100) <= 60
						@ nXBt2+26, X1+(X2*4) BITMAP oBitmapL5 SIZE 250, 030 OF oDlg FILENAME cG15B NOBORDER PIXEL
					ELSEIF ((nTotLin5/nTimeMont)*100) > 60 .AND. ((nTotLin5/nTimeMont)*100) <= 64
						@ nXBt2+26, X1+(X2*4) BITMAP oBitmapL5 SIZE 250, 030 OF oDlg FILENAME cG16B NOBORDER PIXEL
					ELSEIF ((nTotLin5/nTimeMont)*100) > 64 .AND. ((nTotLin5/nTimeMont)*100) <= 68
						@ nXBt2+26, X1+(X2*4) BITMAP oBitmapL5 SIZE 250, 030 OF oDlg FILENAME cG17B NOBORDER PIXEL
					ELSEIF ((nTotLin5/nTimeMont)*100) > 68 .AND. ((nTotLin5/nTimeMont)*100) <= 72
						@ nXBt2+26, X1+(X2*4) BITMAP oBitmapL5 SIZE 250, 030 OF oDlg FILENAME cG18B NOBORDER PIXEL
					ELSEIF ((nTotLin5/nTimeMont)*100) > 72 .AND. ((nTotLin5/nTimeMont)*100) <= 76
						@ nXBt2+26, X1+(X2*4) BITMAP oBitmapL5 SIZE 250, 030 OF oDlg FILENAME cG19B NOBORDER PIXEL
					ELSEIF ((nTotLin5/nTimeMont)*100) > 76 .AND. ((nTotLin5/nTimeMont)*100) <= 80
						@ nXBt2+26, X1+(X2*4) BITMAP oBitmapL5 SIZE 250, 030 OF oDlg FILENAME cG20B NOBORDER PIXEL
					ELSEIF ((nTotLin5/nTimeMont)*100) > 80 .AND. ((nTotLin5/nTimeMont)*100) <= 84
						@ nXBt2+26, X1+(X2*4) BITMAP oBitmapL5 SIZE 250, 030 OF oDlg FILENAME cG21B NOBORDER PIXEL
					ELSEIF ((nTotLin5/nTimeMont)*100) > 84 .AND. ((nTotLin5/nTimeMont)*100) <= 88
						@ nXBt2+26, X1+(X2*4) BITMAP oBitmapL5 SIZE 250, 030 OF oDlg FILENAME cG22B NOBORDER PIXEL
					ELSEIF ((nTotLin5/nTimeMont)*100) > 88 .AND. ((nTotLin5/nTimeMont)*100) <= 92
						@ nXBt2+26, X1+(X2*4) BITMAP oBitmapL5 SIZE 250, 030 OF oDlg FILENAME cG23B NOBORDER PIXEL
					ELSEIF ((nTotLin5/nTimeMont)*100) > 92 .AND. ((nTotLin5/nTimeMont)*100) <= 96
						@ nXBt2+26, X1+(X2*4) BITMAP oBitmapL5 SIZE 250, 030 OF oDlg FILENAME cG24B NOBORDER PIXEL
					ELSEIF ((nTotLin5/nTimeMont)*100) > 96
						@ nXBt2+26, X1+(X2*4) BITMAP oBitmapL5 SIZE 250, 030 OF oDlg FILENAME cG25B NOBORDER PIXEL
					Endif


				Elseif Alltrim(QRY->LINHA) == "LINHA 6"
					nTotLin6+= QRY->TEMPL
					FreeObj(oBitmapL6)
					IF ((nTotLin6/nTimeMont)*100) == 0
						@ nXBt2+26, X1+(X2*5) BITMAP oBitmapL6 SIZE 250, 030 OF oDlg FILENAME cG0B NOBORDER PIXEL
					ELSEIF ((nTotLin6/nTimeMont)*100) > 0 .AND. ((nTotLin6/nTimeMont)*100) <= 4
						@ nXBt2+26, X1+(X2*5) BITMAP oBitmapL6 SIZE 250, 030 OF oDlg FILENAME cG1B NOBORDER PIXEL
					ELSEIF ((nTotLin6/nTimeMont)*100) > 4 .AND. ((nTotLin6/nTimeMont)*100) <= 8
						@ nXBt2+26, X1+(X2*5) BITMAP oBitmapL6 SIZE 250, 030 OF oDlg FILENAME cG2B NOBORDER PIXEL
					ELSEIF ((nTotLin6/nTimeMont)*100) > 8 .AND. ((nTotLin6/nTimeMont)*100) <= 12
						@ nXBt2+26, X1+(X2*5) BITMAP oBitmapL6 SIZE 250, 030 OF oDlg FILENAME cG3B NOBORDER PIXEL
					ELSEIF ((nTotLin6/nTimeMont)*100) > 12 .AND. ((nTotLin6/nTimeMont)*100) <= 16
						@ nXBt2+26, X1+(X2*5) BITMAP oBitmapL6 SIZE 250, 030 OF oDlg FILENAME cG4B NOBORDER PIXEL
					ELSEIF ((nTotLin6/nTimeMont)*100) > 16 .AND. ((nTotLin6/nTimeMont)*100) <= 20
						@ nXBt2+26, X1+(X2*5) BITMAP oBitmapL6 SIZE 250, 030 OF oDlg FILENAME cG5B NOBORDER PIXEL
					ELSEIF ((nTotLin6/nTimeMont)*100) > 20 .AND. ((nTotLin6/nTimeMont)*100) <= 24
						@ nXBt2+26, X1+(X2*5) BITMAP oBitmapL6 SIZE 250, 030 OF oDlg FILENAME cG6B NOBORDER PIXEL
					ELSEIF ((nTotLin6/nTimeMont)*100) > 24 .AND. ((nTotLin6/nTimeMont)*100) <= 28
						@ nXBt2+26, X1+(X2*5) BITMAP oBitmapL6 SIZE 250, 030 OF oDlg FILENAME cG7B NOBORDER PIXEL
					ELSEIF ((nTotLin6/nTimeMont)*100) > 28 .AND. ((nTotLin6/nTimeMont)*100) <= 32
						@ nXBt2+26, X1+(X2*5) BITMAP oBitmapL6 SIZE 250, 030 OF oDlg FILENAME cG8B NOBORDER PIXEL
					ELSEIF ((nTotLin6/nTimeMont)*100) > 32 .AND. ((nTotLin6/nTimeMont)*100) <= 36
						@ nXBt2+26, X1+(X2*5) BITMAP oBitmapL6 SIZE 250, 030 OF oDlg FILENAME cG9B NOBORDER PIXEL
					ELSEIF ((nTotLin6/nTimeMont)*100) > 36 .AND. ((nTotLin6/nTimeMont)*100) <= 40
						@ nXBt2+26, X1+(X2*5) BITMAP oBitmapL6 SIZE 250, 030 OF oDlg FILENAME cG10B NOBORDER PIXEL
					ELSEIF ((nTotLin6/nTimeMont)*100) > 40 .AND. ((nTotLin6/nTimeMont)*100) <= 44
						@ nXBt2+26, X1+(X2*5) BITMAP oBitmapL6 SIZE 250, 030 OF oDlg FILENAME cG11B NOBORDER PIXEL
					ELSEIF ((nTotLin6/nTimeMont)*100) > 44 .AND. ((nTotLin6/nTimeMont)*100) <= 48
						@ nXBt2+26, X1+(X2*5) BITMAP oBitmapL6 SIZE 250, 030 OF oDlg FILENAME cG12B NOBORDER PIXEL
					ELSEIF ((nTotLin6/nTimeMont)*100) > 48 .AND. ((nTotLin6/nTimeMont)*100) <= 52
						@ nXBt2+26, X1+(X2*5) BITMAP oBitmapL6 SIZE 250, 030 OF oDlg FILENAME cG13B NOBORDER PIXEL
					ELSEIF ((nTotLin6/nTimeMont)*100) > 52 .AND. ((nTotLin6/nTimeMont)*100) <= 56
						@ nXBt2+26, X1+(X2*5) BITMAP oBitmapL6 SIZE 250, 030 OF oDlg FILENAME cG14B NOBORDER PIXEL
					ELSEIF ((nTotLin6/nTimeMont)*100) > 56 .AND. ((nTotLin6/nTimeMont)*100) <= 60
						@ nXBt2+26, X1+(X2*5) BITMAP oBitmapL6 SIZE 250, 030 OF oDlg FILENAME cG15B NOBORDER PIXEL
					ELSEIF ((nTotLin6/nTimeMont)*100) > 60 .AND. ((nTotLin6/nTimeMont)*100) <= 64
						@ nXBt2+26, X1+(X2*5) BITMAP oBitmapL6 SIZE 250, 030 OF oDlg FILENAME cG16B NOBORDER PIXEL
					ELSEIF ((nTotLin6/nTimeMont)*100) > 64 .AND. ((nTotLin6/nTimeMont)*100) <= 68
						@ nXBt2+26, X1+(X2*5) BITMAP oBitmapL6 SIZE 250, 030 OF oDlg FILENAME cG17B NOBORDER PIXEL
					ELSEIF ((nTotLin6/nTimeMont)*100) > 68 .AND. ((nTotLin6/nTimeMont)*100) <= 72
						@ nXBt2+26, X1+(X2*5) BITMAP oBitmapL6 SIZE 250, 030 OF oDlg FILENAME cG18B NOBORDER PIXEL
					ELSEIF ((nTotLin6/nTimeMont)*100) > 72 .AND. ((nTotLin6/nTimeMont)*100) <= 76
						@ nXBt2+26, X1+(X2*5) BITMAP oBitmapL6 SIZE 250, 030 OF oDlg FILENAME cG19B NOBORDER PIXEL
					ELSEIF ((nTotLin6/nTimeMont)*100) > 76 .AND. ((nTotLin6/nTimeMont)*100) <= 80
						@ nXBt2+26, X1+(X2*5) BITMAP oBitmapL6 SIZE 250, 030 OF oDlg FILENAME cG20B NOBORDER PIXEL
					ELSEIF ((nTotLin6/nTimeMont)*100) > 80 .AND. ((nTotLin6/nTimeMont)*100) <= 84
						@ nXBt2+26, X1+(X2*5) BITMAP oBitmapL6 SIZE 250, 030 OF oDlg FILENAME cG21B NOBORDER PIXEL
					ELSEIF ((nTotLin6/nTimeMont)*100) > 84 .AND. ((nTotLin6/nTimeMont)*100) <= 88
						@ nXBt2+26, X1+(X2*5) BITMAP oBitmapL6 SIZE 250, 030 OF oDlg FILENAME cG22B NOBORDER PIXEL
					ELSEIF ((nTotLin6/nTimeMont)*100) > 88 .AND. ((nTotLin6/nTimeMont)*100) <= 92
						@ nXBt2+26, X1+(X2*5) BITMAP oBitmapL6 SIZE 250, 030 OF oDlg FILENAME cG23B NOBORDER PIXEL
					ELSEIF ((nTotLin6/nTimeMont)*100) > 92 .AND. ((nTotLin6/nTimeMont)*100) <= 96
						@ nXBt2+26, X1+(X2*5) BITMAP oBitmapL6 SIZE 250, 030 OF oDlg FILENAME cG24B NOBORDER PIXEL
					ELSEIF ((nTotLin6/nTimeMont)*100) > 96
						@ nXBt2+26, X1+(X2*5) BITMAP oBitmapL6 SIZE 250, 030 OF oDlg FILENAME cG25B NOBORDER PIXEL
					Endif
				Elseif Alltrim(QRY->LINHA) == "LINHA 7"
					FreeObj(oBitmapL7)
					nTotLin7+= QRY->TEMPL
					IF ((nTotLin7/nTimeMont)*100) == 0
						@ nXBt2+26, X1+(X2*6) BITMAP oBitmapL7 SIZE 250, 030 OF oDlg FILENAME cG0B NOBORDER PIXEL
					ELSEIF ((nTotLin7/nTimeMont)*100) > 0 .AND. ((nTotLin7/nTimeMont)*100) <= 4
						@ nXBt2+26, X1+(X2*6) BITMAP oBitmapL7 SIZE 250, 030 OF oDlg FILENAME cG1B NOBORDER PIXEL
					ELSEIF ((nTotLin7/nTimeMont)*100) > 4 .AND. ((nTotLin7/nTimeMont)*100) <= 8
						@ nXBt2+26, X1+(X2*6) BITMAP oBitmapL7 SIZE 250, 030 OF oDlg FILENAME cG2B NOBORDER PIXEL
					ELSEIF ((nTotLin7/nTimeMont)*100) > 8 .AND. ((nTotLin7/nTimeMont)*100) <= 12
						@ nXBt2+26, X1+(X2*6) BITMAP oBitmapL7 SIZE 250, 030 OF oDlg FILENAME cG3B NOBORDER PIXEL
					ELSEIF ((nTotLin7/nTimeMont)*100) > 12 .AND. ((nTotLin7/nTimeMont)*100) <= 16
						@ nXBt2+26, X1+(X2*6) BITMAP oBitmapL7 SIZE 250, 030 OF oDlg FILENAME cG4B NOBORDER PIXEL
					ELSEIF ((nTotLin7/nTimeMont)*100) > 16 .AND. ((nTotLin7/nTimeMont)*100) <= 20
						@ nXBt2+26, X1+(X2*6) BITMAP oBitmapL7 SIZE 250, 030 OF oDlg FILENAME cG5B NOBORDER PIXEL
					ELSEIF ((nTotLin7/nTimeMont)*100) > 20 .AND. ((nTotLin7/nTimeMont)*100) <= 24
						@ nXBt2+26, X1+(X2*6) BITMAP oBitmapL7 SIZE 250, 030 OF oDlg FILENAME cG6B NOBORDER PIXEL
					ELSEIF ((nTotLin7/nTimeMont)*100) > 24 .AND. ((nTotLin7/nTimeMont)*100) <= 28
						@ nXBt2+26, X1+(X2*6) BITMAP oBitmapL7 SIZE 250, 030 OF oDlg FILENAME cG7B NOBORDER PIXEL
					ELSEIF ((nTotLin7/nTimeMont)*100) > 28 .AND. ((nTotLin7/nTimeMont)*100) <= 32
						@ nXBt2+26, X1+(X2*6) BITMAP oBitmapL7 SIZE 250, 030 OF oDlg FILENAME cG8B NOBORDER PIXEL
					ELSEIF ((nTotLin7/nTimeMont)*100) > 32 .AND. ((nTotLin7/nTimeMont)*100) <= 36
						@ nXBt2+26, X1+(X2*6) BITMAP oBitmapL7 SIZE 250, 030 OF oDlg FILENAME cG9B NOBORDER PIXEL
					ELSEIF ((nTotLin7/nTimeMont)*100) > 36 .AND. ((nTotLin7/nTimeMont)*100) <= 40
						@ nXBt2+26, X1+(X2*6) BITMAP oBitmapL7 SIZE 250, 030 OF oDlg FILENAME cG10B NOBORDER PIXEL
					ELSEIF ((nTotLin7/nTimeMont)*100) > 40 .AND. ((nTotLin7/nTimeMont)*100) <= 44
						@ nXBt2+26, X1+(X2*6) BITMAP oBitmapL7 SIZE 250, 030 OF oDlg FILENAME cG11B NOBORDER PIXEL
					ELSEIF ((nTotLin7/nTimeMont)*100) > 44 .AND. ((nTotLin7/nTimeMont)*100) <= 48
						@ nXBt2+26, X1+(X2*6) BITMAP oBitmapL7 SIZE 250, 030 OF oDlg FILENAME cG12B NOBORDER PIXEL
					ELSEIF ((nTotLin7/nTimeMont)*100) > 48 .AND. ((nTotLin7/nTimeMont)*100) <= 52
						@ nXBt2+26, X1+(X2*6) BITMAP oBitmapL7 SIZE 250, 030 OF oDlg FILENAME cG13B NOBORDER PIXEL
					ELSEIF ((nTotLin7/nTimeMont)*100) > 52 .AND. ((nTotLin7/nTimeMont)*100) <= 56
						@ nXBt2+26, X1+(X2*6) BITMAP oBitmapL7 SIZE 250, 030 OF oDlg FILENAME cG14B NOBORDER PIXEL
					ELSEIF ((nTotLin7/nTimeMont)*100) > 56 .AND. ((nTotLin7/nTimeMont)*100) <= 60
						@ nXBt2+26, X1+(X2*6) BITMAP oBitmapL7 SIZE 250, 030 OF oDlg FILENAME cG15B NOBORDER PIXEL
					ELSEIF ((nTotLin7/nTimeMont)*100) > 60 .AND. ((nTotLin7/nTimeMont)*100) <= 64
						@ nXBt2+26, X1+(X2*6) BITMAP oBitmapL7 SIZE 250, 030 OF oDlg FILENAME cG16B NOBORDER PIXEL
					ELSEIF ((nTotLin7/nTimeMont)*100) > 64 .AND. ((nTotLin7/nTimeMont)*100) <= 68
						@ nXBt2+26, X1+(X2*6) BITMAP oBitmapL7 SIZE 250, 030 OF oDlg FILENAME cG17B NOBORDER PIXEL
					ELSEIF ((nTotLin7/nTimeMont)*100) > 68 .AND. ((nTotLin7/nTimeMont)*100) <= 72
						@ nXBt2+26, X1+(X2*6) BITMAP oBitmapL7 SIZE 250, 030 OF oDlg FILENAME cG18B NOBORDER PIXEL
					ELSEIF ((nTotLin7/nTimeMont)*100) > 72 .AND. ((nTotLin7/nTimeMont)*100) <= 76
						@ nXBt2+26, X1+(X2*6) BITMAP oBitmapL7 SIZE 250, 030 OF oDlg FILENAME cG19B NOBORDER PIXEL
					ELSEIF ((nTotLin7/nTimeMont)*100) > 76 .AND. ((nTotLin7/nTimeMont)*100) <= 80
						@ nXBt2+26, X1+(X2*6) BITMAP oBitmapL7 SIZE 250, 030 OF oDlg FILENAME cG20B NOBORDER PIXEL
					ELSEIF ((nTotLin7/nTimeMont)*100) > 80 .AND. ((nTotLin7/nTimeMont)*100) <= 84
						@ nXBt2+26, X1+(X2*6) BITMAP oBitmapL7 SIZE 250, 030 OF oDlg FILENAME cG21B NOBORDER PIXEL
					ELSEIF ((nTotLin7/nTimeMont)*100) > 84 .AND. ((nTotLin7/nTimeMont)*100) <= 88
						@ nXBt2+26, X1+(X2*6) BITMAP oBitmapL7 SIZE 250, 030 OF oDlg FILENAME cG22B NOBORDER PIXEL
					ELSEIF ((nTotLin7/nTimeMont)*100) > 88 .AND. ((nTotLin7/nTimeMont)*100) <= 92
						@ nXBt2+26, X1+(X2*6) BITMAP oBitmapL7 SIZE 250, 030 OF oDlg FILENAME cG23B NOBORDER PIXEL
					ELSEIF ((nTotLin7/nTimeMont)*100) > 92 .AND. ((nTotLin7/nTimeMont)*100) <= 96
						@ nXBt2+26, X1+(X2*6) BITMAP oBitmapL7 SIZE 250, 030 OF oDlg FILENAME cG24B NOBORDER PIXEL
					ELSEIF ((nTotLin7/nTimeMont)*100) > 96
						@ nXBt2+26, X1+(X2*6) BITMAP oBitmapL7 SIZE 250, 030 OF oDlg FILENAME cG25B NOBORDER PIXEL
					Endif


				Endif
			Endif

			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'TEMP_LIN'  	})] := QRY->TEMPL
			oGetDados:aCols[Len(oGetDados:aCols),Len(oGetDados:aHeader)+1 ] := .F.
			QRY->(DbSkip())
		EndDo
	Else
		AADD(oGetDados:aCols,Array(Len(oGetDados:aHeader)+1))
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'FLAG' 		})] := oNo
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'LEG1' 		})] := oLegno
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'LEG2' 		})] := oLegno
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'COR' 	 		})] := "2"
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'OP' 			})] := ""
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'PAI'   		})] := ""
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'DESC1'   	})] := ""
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'QTD'     	})] := 0
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'FIBRA'  		})] := ""
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'DESC2' 		})] := ""
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'DTPROG' 	})] := "  /  /   "
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'QTD_FIBRA'  })] := 0
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'MAQUINA'  	})] := ""
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'LINHA'  		})] := ""
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'TEMP_PROD' 	})] := 0
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'TEMP_LIN'  	})] := 0

		oGetDados:aCols[Len(oGetDados:aCols),Len(oGetDados:aHeader)+1 ] := .F.
	EndIf

	oCheckBo1:CtrlRefresh()
	oGetDados:Refresh()
	oMsCalen1:Refresh()
	oCort1:Refresh()
	oCort2:Refresh()
	oCort3:Refresh()
	oCort4:Refresh()
	oCort5:Refresh()
	oLin1:Refresh()
	oLin2:Refresh()
	oLin3:Refresh()
	oLin4:Refresh()
	oLin5:Refresh()
	oLin6:Refresh()
	oDlg:Refresh()

	QRY->(dbCloseArea())
Return lRet

/*/Protheus.doc fRefrButt
	description
	@type function
	@version
	@author Ricardo Roda
	@since 23/07/2020
	@param nOpc, numeric, param_description
	@param cOpc, character, param_description
	@param nTpProd, numeric, param_description
	@return return_type, return_description
/*/
Static Function fRefrButt(nOpc,cOpc,nTpProd)
	Local cCSSBtN1		:= ""
	Local nPosOp	:= GdFieldPos("OP")
	Local nPosPai	:= GdFieldPos("PAI")
	Local nPosFibra	:= GdFieldPos("FIBRA")
	Local nPosMaq	:= GdFieldPos("MAQUINA")
	Local nPosTpPrd	:= GdFieldPos("TEMP_PROD")
	Local nPosFlag	:= GdFieldPos("FLAG")
	Local nPosQFibr	:= GdFieldPos("QTD")
	Local MsgCort:= ""
	Local nGrava:= 3
	Local lContinua := .F.
	Local aBotao := { "Cancelar","Reprogramar","Confirmar"}
	Local Corte_x:= ""
	Local Linha_x:= ""
	Local _i
	cCSSBtN1 :=	"QPushButton{background-color: #f6f7fa; color: #707070; font: bold 22px MS Sans Serif }"+;
		"QPushButton:pressed {background-color: #50b4b4; color: white; font: bold 22px MS Sans Serif; }"+;
		"QPushButton:hover {background-color: #878787 ; color: white; font: bold 22px MS Sans Serif; }"

	cCSSBtN2 :=	"QPushButton{background-color: #4da5c7; color: white; font: bold 22px MS Sans Serif;  background-image: url(rpo:PCOFXOK.png);background-repeat: none;}"+;
		"QPushButton:pressed {background-color: #50b4b4; color: white; font: bold 22px MS Sans Serif; }"+;
		"QPushButton:hover {background-color: #878787 ; color: #white; font: bold 22px MS Sans Serif; }"
	If cOpc = 'C'

		if nTpProd == 1
			If 	nOpc == 1
				Corte_x:= "CORTE 1"
			elseif 	nOpc == 2
				Corte_x:= "CORTE 2"
			elseif 	nOpc == 3
				Corte_x:= "CORTE 3"
			elseif 	nOpc == 4
				Corte_x:= "CORTE 4"
			elseif 	nOpc == 5
				Corte_x:= "CORTE 5"
			Endif
		ElseIf nTpProd == 2
			If 	nOpc == 1
				Corte_x:= "TRUNK 1"
			elseif 	nOpc == 2
				Corte_x:= "TRUNK 2"
			elseif 	nOpc == 3
				Corte_x:= "TRUNK 3"
			elseif 	nOpc == 4
				Corte_x:= "TRUNK 4"
			elseif 	nOpc == 5
				Corte_x:= "TRUNK 5"
			Endif
		ElseIf nTpProd == 3
			If 	nOpc == 1
				Corte_x:= "DROP 1"
			elseif 	nOpc == 2
				Corte_x:= "DROP 2"
			elseif 	nOpc == 3
				Corte_x:= "DROP 3"
			elseif 	nOpc == 4
				Corte_x:= "DROP 4"
			elseif 	nOpc == 5
				Corte_x:= "DROP 5"
			Endif
		ElseIf nTpProd == 4
			If 	nOpc == 1
				Corte_x:= "JUMPER 1"
			elseif 	nOpc == 2
				Corte_x:= "JUMPER 2"
			elseif 	nOpc == 3
				Corte_x:= "JUMPER 3"
			elseif 	nOpc == 4
				Corte_x:= "JUMPER 4"
			elseif 	nOpc == 5
				Corte_x:= "JUMPER 5"
			Endif
		ElseIf nTpProd == 5
			If 	nOpc == 1
				Corte_x:= "PRECON 1"
			elseif 	nOpc == 2
				Corte_x:= "PRECON 2"
			elseif 	nOpc == 3
				Corte_x:= "PRECON 3"
			elseif 	nOpc == 4
				Corte_x:= "PRECON 4"
			elseif 	nOpc == 5
				Corte_x:= "PRECON 5"
			Endif

		Endif


	elseIf cOpc = 'L'
		If 	nOpc == 1
			Linha_x:= "LINHA 1"
		elseif 	nOpc == 2
			Linha_x:= "LINHA 2"
		elseif 	nOpc == 3
			Linha_x:= "LINHA 3"
		elseif 	nOpc == 4
			Linha_x:= "LINHA 4"
		elseif 	nOpc == 5
			Linha_x:= "LINHA 5"
		elseif 	nOpc == 6
			Linha_x:= "LINHA 6"
		elseif 	nOpc == 7
			Linha_x:= "LINHA 7"
		Endif

	Endif

	Begin Transaction
		For _i := 1 To Len(oGetDados:Acols)
			if oGetDados:aCols[_i,nPosFlag] == oOk
				_cFibra	:= padr(oGetDados:aCols[_i,nPosFibra],TAMSX3("P10_FIBRA")[1])
				_cOp := padr(oGetDados:aCols[_i,nPosOp],TAMSX3("P10_OP")[1])

				P10->(DbSetOrder(1))//P10_FILIAL, P10_OP, P10_FIBRA
				IF P10->(!DbSeek(xFilial("P10")+_cOp+_cFibra))
					RecLock("P10",.T.)
					P10->P10_FILIAL	:= xFilial("P10")
					P10->P10_OP       := _cOp
					P10->P10_DTPROG	:= dDtProg
					P10->P10_FIBRA    := _cFibra
					P10->(MsUnLock())
				ELSE
					If cOpc == "X"
						Reclock("P10",.F.)
						P10->( dbDelete() )
						P10->( msUnlock() )
					Endif
				Endif
			Endif
		Next _i

		IF cOpc == "C" //Corte
			For _i := 1 To Len(oGetDados:Acols)
				IF oGetDados:aCols[_i,nPosFlag] == oOk
					_cFibra		:= padr(oGetDados:aCols[_i,nPosFibra],TAMSX3("P10_FIBRA")[1])
					_cOp		:= padr(oGetDados:aCols[_i,nPosOp],TAMSX3("P10_OP")[1])
					_nTmpCGrav	:= fTmp(dDtProg,Corte_x,1)
					_cCodPai	:= padr(oGetDados:aCols[_i,nPosPai],TAMSX3("P11_PA")[1])
					nTmpCort	:= fTmpCort(_cCodPai,nTmpCort,Corte_x,_cFibra )

					If !lContinua
						if  (_nTmpCGrav + (nTmpCort * oGetDados:aCols[_i,nPosQFibr])) > nTimeProd
							MsgCort :="A máquina "+Corte_x+" excedeu a capacidade de "+cValtoChar(nTimeProd)+" minutos diários."
							MsgCort += chr(13)+chr(10)+ "Escolha uma das opções abaixo..."
							nGrava := AVISO("Excesso de Corte", MsgCort, aBotao, 3)
							if nGrava == 3
								lContinua:= .T.
								//oMeter1:Set(nTimeProd)
								//oMeter1:refresh()
								_Grava:= "S"
							else
								DisarmTransaction()
								Exit
							Endif
						Endif
					Endif
					IF P10->(DbSeek(xFilial("P10")+_cOp+_cFibra)) .and. nGrava == 3
						RecLock("P10",.F.)
						P10->P10_MAQUIN:= Corte_x
						P10->P10_TEMPC:= nTmpCort * oGetDados:aCols[_i,nPosQFibr]
						P10->P10_DTPROG	:= dDtProg
						P10->P10_SQCORT	:= fPrxNum(dTos(dDtProg),Corte_x)
						P10->(MsUnLock())
					Endif
				Endif
			Next _i



		ElseIf cOpc == "L" //Linha
			For _i := 1 To Len(oGetDados:Acols)
				IF oGetDados:aCols[_i,nPosFlag] == oOk
					_cFibra	:= padr(oGetDados:aCols[_i,nPosFibra],TAMSX3("P10_FIBRA")[1])
					_cOp	:= padr(oGetDados:aCols[_i,nPosOp],TAMSX3("P10_OP")[1])
					_nTmpCGrav:= fTmp(dDtProg,Linha_x,2)
					If !lContinua
						Corte_x	:= Alltrim(oGetDados:aCols[_i,nPosMaq])
						If Empty(Corte_x)
							MsgCort := "Para calcular corretamente o tempo da linha "+chr(13)+chr(10)
							MsgCort += "é necessário informar primeiramente a máquina de corte"
							nGrava := AVISO("Informe a máquina de corte", MsgCort, aBotao, 3)
							DisarmTransaction()
							Exit
						Else
							_cCodPai:= padr(oGetDados:aCols[_i,nPosPai],TAMSX3("P11_PA")[1])
							nTmpMont:= fTmpMont(_cOp)

							if  (_nTmpCGrav + (nTmpMont * oGetDados:aCols[_i,nPosQFibr])) > nTimeMont
								MsgCort :="A Célula "+Linha_x+" excedeu a capacidade de "+cValtoChar(nTimeMont)+" minutos diários."
								MsgCort += chr(13)+chr(10)+ "Escolha uma das opções abaixo..."
								nGrava := AVISO("Excesso na Linha de Montagem", MsgCort, aBotao, 3)
								if nGrava == 3
									lContinua:= .T.
									//oMeter1:Set(nTimeMont)
									//oMeter1:refresh()
									_Grava:= "S"
								else
									DisarmTransaction()
									Exit
								Endif
							Endif
						Endif
					Endif
					IF P10->(DbSeek(xFilial("P10")+_cOp+_cFibra)) .and. nGrava == 3
						RecLock("P10",.F.)
						P10->P10_LINHA:= Linha_x
						P10->P10_TEMPL:= (nTmpMont * oGetDados:aCols[_i,nPosQFibr]) - oGetDados:aCols[_i,nPosTpPrd]

						P10->(MsUnLock())
					Endif
				Endif
			Next _i
		Endif
	End Transaction

	if nGrava == 3 .or.  nGrava == 1
		Processa( {|| MontaMsGet()}, "Gerando Ajustes","Processando...",,.T.)

	Endif

Return



/*/Protheus.doc fMark
	description
	@type function
	@version
	@author Ricardo Roda
	@since 23/07/2020
	@param nOpc, numeric, param_description
	@param BtLado, codeblock, param_description
	@return return_type, return_description
// Função para marcar todas as linhas */

Static Function fMark(nOpc,BtLado)
	Local nPosMaq	:= GdFieldPos( "FLAG" )
	Local nPosCor	:= GdFieldPos( "COR" )
	Local nPosFibra:= GdFieldPos( "FIBRA" )
	Local _i

	oGetDados:aCols[oGetDados:nAt,nPosMaq]:= IIF(nOpc == 1,oOk,oNo)
	IF oGetDados:aCols[oGetDados:nAt,nPosMaq] == oOk
		oGetDados:aCols[oGetDados:nAt,nPosCor]:= "1"
	Else
		For _i := 1 To Len(oGetDados:Acols)
			if oGetDados:aCols[_i,nPosMaq]== oNo  .and. oGetDados:aCols[oGetDados:nAt,nPosFibra] == oGetDados:aCols[_i,nPosFibra]
				oGetDados:aCols[oGetDados:nAt,nPosCor]:= "2"
			Endif
		Next _i
	Endif

	If nopc == 1
		For _i := 1 To Len(oGetDados:Acols)
			if oGetDados:aCols[_i,nPosMaq]== oNo  .and. oGetDados:aCols[oGetDados:nAt,nPosFibra] == oGetDados:aCols[_i,nPosFibra]
				if BtLado == "D"
					oGetDados:aCols[_i,nPosMaq]:= oOk
				Endif
				oGetDados:aCols[_i,nPosCor]:= "1"
			Endif
		Next _i
	Else
		For _i := 1 To Len(oGetDados:Acols)
			if oGetDados:aCols[_i,nPosMaq]== oOk  .and. oGetDados:aCols[oGetDados:nAt,nPosFibra] == oGetDados:aCols[_i,nPosFibra]
				if BtLado == "D"
					oGetDados:aCols[_i,nPosMaq]:= oNo
					oGetDados:aCols[_i,nPosCor]:= "2"
				Endif

			Endif
		Next _i
	Endif
	oCheckBo1:Refresh()
	oGetDados:Refresh()
	oMsCalen1:Refresh()
	oDlg:Refresh()
Return

/*/Protheus.doc CorGd02
	description
	@type function
	@version
	@author Ricardo Roda
	@since 23/07/2020
	@param nLinha, numeric, param_description
	@return return_type, return_description
/*/
Static Function CorGd02(nLinha)
	Local nRet := 16777215
	Local nPosMaq	:= GdFieldPos( "COR" )
	If oGetDados:aCols[nLinha,nPosMaq] == c2Leg2
		nRet := n2Leg2
	Endif

	If oGetDados:aCols[nLinha,nPosMaq] == c2Leg1
		nRet   := n2Leg1
	Endif

Return nRet


/*/Protheus.doc fPrxNum
	description
	@type function
	@version
	@author Ricardo Roda
	@since 23/07/2020
	@param dDataPrg, date, param_description
	@param cMaq, character, param_description
	@return return_type, return_description
/*/
Static Function fPrxNum(dDataPrg, cMaq)

	Local cQuery :=""
	Local cPrxNum:= "001"

	IF SELECT ("QRY2") > 0
		QRY2->(dbCloseArea())
	Endif

	cQuery +=" SELECT MAX(P10_SQCORT) PRXNUM FROM "+RETSQLNAME("P10")+" P10"
	cQuery +=" WHERE P10_FILIAL = '"+	xFilial("P10")+"' "
	cQuery +=" AND P10_DTPROG = '"+dDataPrg+"' "
	cQuery +=" AND P10_MAQUIN = '"+cMaq+"' "
	cQuery +=" AND D_E_L_E_T_ = '' "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY2",.T.,.T.)

	If QRY2->(!eof())
		cPrxNum:= strzero((val(QRY2->PRXNUM)+1),3)
	Endif

	IF SELECT ("QRY2") > 0
		QRY2->(dbCloseArea())
	Endif

Return cPrxNum

/*/Protheus.doc fTmp
	description
	@type function
	@version
	@author Ricardo Roda
	@since 23/07/2020
	@param dDataPrg, date, param_description
	@param cOpc, character, param_description
	@param nOpc, numeric, param_description
	@return return_type, return_description
/*/
Static Function fTmp(dDataPrg, cOpc,nOpc)
	Local cQuery :=""
	Local nTmp:= 0
	Local cCampo:= ""

	IF SELECT ("QRY3") > 0
		QRY3->(dbCloseArea())
	Endif

	IF nOpc == 1
		cCampo:= "P10_TEMPC"
	Else
		cCampo:= "P10_TEMPL - P10_TEMPC"
	Endif

	cQuery +=" SELECT SUM("+cCampo+") TMP FROM "+RETSQLNAME("P10")+" P10"
	cQuery +=" WHERE P10_FILIAL = '"+	xFilial("P10")+"' "
	cQuery +=" AND P10_DTPROG = '"+DTOS(dDataPrg)+"' "

	If nOpc == 1
		cQuery +=" AND P10_MAQUIN = '"+cOpc+"' "
	ElseIf nOpc == 2
		cQuery +=" AND P10_LINHA = '"+cOpc+"' "
	Endif

	cQuery +=" AND D_E_L_E_T_ = '' "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY3",.T.,.T.)

	If QRY3->(!eof())
		nTmp:= QRY3->TMP
	Endif

	IF SELECT ("QRY3") > 0
		QRY3->(dbCloseArea())
	Endif

Return nTmp


/*   FUNÇÃO PARA FILTRAR TIPO DE PRODUTO   */
/*/Protheus.doc FTpProd
	description
	@type function
	@version
	@author Ricardo Roda
	@since 23/07/2020
	@return return_type, return_description
/*/
Static Function FTpProd()
	Local oTpProd1
	Local oTpProd2
	Local oTpProd3
	Local oTpProd4
	Local oTpProd5

	Local nTpProd:= 0
	Local oFont1 := TFont():New("Arial",,050,,.T.,,,,,.F.,.F.)
	Static oDlgFil

	Local cCSSBtN1 :="QPushButton{background-color: #f6f7fa; color: #707070; font: bold 22px Arial; }"+;
		"QPushButton:pressed {background-color: #50b4b4; color: white; font: bold 22px  Arial; }"+;
		"QPushButton:hover {background-color: #878787 ; color: white; font: bold 22px  Arial; }"

	DEFINE MSDIALOG oDlgFil TITLE "Escolha a célula de trabalho" FROM 000, 000  TO 600, 800 COLORS 0, 16777215 PIXEL
	@ 033, 040 BUTTON oTpProd1 PROMPT "CORD"  SIZE 150, 053 OF oDlgFil ACTION (nTpProd := 1,  oDlgFil:end() ) FONT oFont1 PIXEL
	oTpProd1:setCSS(cCSSBtN1)
	@ 033, 212 BUTTON oTpProd2 PROMPT "TRUNK" SIZE 150, 053 OF oDlgFil ACTION (nTpProd := 2, oDlgFil:end()) FONT oFont1 PIXEL
	oTpProd2:setCSS(cCSSBtN1)
	@ 110, 040 BUTTON oTpProd3 PROMPT "DROP"  SIZE 150, 053 OF oDlgFil ACTION (nTpProd := 3,   oDlgFil:end()) FONT oFont1 PIXEL
	oTpProd3:setCSS(cCSSBtN1)
	@ 110, 212 BUTTON oTpProd4 PROMPT "JUMPER" SIZE 150, 053 OF oDlgFil ACTION (nTpProd := 4,  oDlgFil:end()) FONT oFont1 PIXEL
	oTpProd4:setCSS(cCSSBtN1)
	@ 187, 040 BUTTON oTpProd5 PROMPT "PRECON" SIZE 150, 053 OF oDlgFil ACTION (nTpProd := 5,  oDlgFil:end()) FONT oFont1 PIXEL
	oTpProd5:setCSS(cCSSBtN1)


	ACTIVATE MSDIALOG oDlgFil CENTERED
Return nTpProd


/*/Protheus.doc fTmpMont
	description
	@type function
	@version
	@author Ricardo Roda
	@since 23/07/2020
	@param cOp, character, param_description
	@return return_type, return_description
/*/
Static Function fTmpMont(cOp)
	Local  cQuery:= ""
	Local nQtd:= 0
	Local nQtdFib:= 0
	IF SELECT("QRY4") > 0
		QRY4->(DBCLOSEAREA())
	ENDIF
/*
cQuery +="  SELECT TOP 1 G1_QUANT QTESTRUT FROM "+RETSQLNAME("SG1")+" SG1   "
cQuery +="  WHERE G1_FILIAL = '"+xFilial("SG1")+"'    "
cQuery +="  AND G1_COD = ISNULL( (  "
cQuery +="  SELECT C2_PRODUTO FROM "+RETSQLNAME("SC2")+" SC2   "
cQuery +="  WHERE C2_FILIAL = '"+xFilial("SC2")+"'   "
cQuery +="  AND C2_NUM+C2_ITEM+C2_SEQUEN = '"+cOp+"'   "
cQuery +="  AND SC2.D_E_L_E_T_ = ''  "
cQuery +="  ),'')  "
	if nTpProd == 1
cQuery +="  AND G1_COMP = '50010100'   "
	Elseif nTpProd == 2
cQuery +="  AND G1_COMP = '50010100T'   "
	Elseif nTpProd == 3
cQuery +="  AND G1_COMP = '50010100DR'   "
	Elseif nTpProd == 4
cQuery +="  AND G1_COMP = '50010100J'   "
	Endif

cQuery +="  AND SG1.D_E_L_E_T_=''  "
*/

	cQuery +=" SELECT  G1_QUANT QTESTRUT, B1_GRUPO, B1_TIPO "
	cQuery +=" FROM "+RETSQLNAME("SG1")+"  SG1  WITH(NOLOCK)  "
	cQuery +=" INNER JOIN "+RETSQLNAME("SB1")+"  SB1 WITH(NOLOCK) ON  B1_COD = G1_COMP AND SB1.D_E_L_E_T_ = ''  "
	cQuery +=" AND (B1_GRUPO IN ('FO','FOFS','RF') AND B1_TIPO = 'MP' OR B1_GRUPO = 'DIV' AND B1_TIPO = 'MO'
	//	cQuery+= " AND NOT( SB1.B1_COD LIKE 'DMS%' OR SB1.B1_COD LIKE 'CO0%') "
	cQuery+= " )  "
	cQuery +=" WHERE G1_FILIAL = '"+xFilial("SG1")+"'    "
	cQuery +=" AND G1_COD = ISNULL( (   "
	cQuery +=" SELECT C2_PRODUTO FROM "+RETSQLNAME("SC2")+"  SC2  WITH(NOLOCK)   "
	cQuery +=" WHERE C2_FILIAL = '"+xFilial("SC2")+"'   "
	cQuery +=" AND C2_NUM+C2_ITEM+C2_SEQUEN = '"+cOp+"'   "
	cQuery +=" AND SC2.D_E_L_E_T_ = '' ),'')   "
	cQuery +=" ORDER BY 3   "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY4",.T.,.T.)

	IF QRY4->(!EOF())
		WHILE QRY4->(!EOF())
			IF QRY4->B1_TIPO == 'MO'
				nQtd += QRY4->QTESTRUT
			ElseIf QRY4->B1_TIPO == 'MP'
				nQtdFib += 1
			Endif
			QRY4->(DBSKIP())
		ENDDO
	Endif

	nQtd:= nQtd/nQtdFib

Return nQtd

Static Function fTmpCort(cPA,nTmpCort,cMaq,cFibra)
	Local  cQuery:= ""
	Local nTempo:= nTmpCort

	IF SELECT("QRY5") > 0
		QRY5->(DBCLOSEAREA())
	ENDIF

	cQuery +=" SELECT ISNULL(MAX(P11_TEMPO),0) TEMPO "
	cQuery +=" FROM "+RETSQLNAME("P11") + " P11 "
	cQuery +=" WHERE P11_PA = '"+cPA+"'
	cQuery +=" AND P11_MAQ = '"+cMaq+"'
	cQuery +=" AND P11_FIBRA = '"+cFibra+"'
	cQuery +=" AND P11.D_E_L_E_T_ = ''
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY5",.T.,.T.)

	IF QRY5->(!EOF())
		IF QRY5->TEMPO > 0
			nTempo:= QRY5->TEMPO
		ENDIF
	Endif

Return nTempo
