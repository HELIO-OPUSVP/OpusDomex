#Include "PROTHEUS.CH"
#Include "HBUTTON.CH"
#INCLUDE "FWBROWSE.CH"
#DEFINE ENTER CHAR(13) + CHAR(10)

//--------------------------------------------------------------
/*/Protheus.doc DOMROT - ROTEIRO DE PRODU??O DOMEX TRUNK
Description
author: Ricardo Roda
return xRet Return Description
author  -
since
/*/
//--------------------------------------------------------------

User Function DOMROTTRK(cTipo,nMaxLinhas)
	Local oButton1
	Local oSay1
	Local oSay2
	Local oSay3
	Local oSay4
	Local oSay5
	Local oSay6
	Local oLeg1
	Local oLeg2
	Local oLeg3

	Private cUserSis   := Upper(AllTrim(Substr(cUsuario,7,15)))
	Private oSayHuawei
	Private oBitmapH
	Private cCodHuawei := ""
	private oFont1     := TFont():New("Arial Narrow",,022,,.T.,,,,,.F.,.F.)
	private oFont2     := TFont():New("Arial",,020,,.F.,,,,,.F.,.F.)
	private oFont3     := TFont():New("Arial",,022,,.T.,,,,,.F.,.F.)
	private oFont4     := TFont():New("Myriad Arabic",,044,,.T.,,,,,.F.,.F.)
	private oFont5     := TFont():New("Arial",,020,,.T.,,,,,.F.,.F.)
	Private _lok       := .F.
	Private cEtiqOfc   := SPACE(30)
	Private cCliente   := CRIAVAR("A1_NOME")
	Private cCodOp     := CRIAVAR("D4_OP")
	Private cNcomp     := CRIAVAR("B1_DESC")
	Private nQtdOri    := 0
	Private nQtdEnt    := 0
	private cCodPai    :=""
	Private cNomePai   := ""
	Private oEtiq
	Private oNomeCli
	Private oCodPai
	Private oNomePai
	Private oCodOP
	Private oQtdOri
	Private oQtdEnt
	Private cStartPath:= GetSrvProfString('Startpath','')
	Private aAux 		:= {LoadBitmap( GetResources(), "BR_VERMELHO"),LoadBitmap( GetResources(), "BR_AMARELO"),LoadBitmap( GetResources(), "BR_VERDE"),LoadBitmap( GetResources(), "BR_PRETO")}
	Private oOk      	:= LoadBitmap( GetResources(), "VERDE" )
	Private oNo      	:= LoadBitmap( GetResources(), "VERMELHO" )
	Private oIn      	:= LoadBitmap( GetResources(), "AMARELO" )
	private cCodProd	:= ""
	Private c2Leg1      := "1"
	Private n2Leg1      := RGB(176,224,230)
	Private c2Leg2      := "2"
	Private n2Leg2      := RGB(248,248,255)

	Private nPosBut		:= 100
	Private nDistBut	:= 045
	Private nPosBitm	:= 568
	Private nLBitm		:= 030
	Private nRegs		:= 030

	Private cTpProd	    := ""

	Private cComp 		:= CriaVar("B1_COD")
	Private nCelula		:= 0
	Private dDataIni	:= dDataBase
	Private cLocOP 		:= CRIAVAR("D4_OP")
	Private oDtIni
	Private oLocOp
	Private lCheckBo1	:= .F.
	Private cNotTps 		:= ""
	Private _cTitulo
	Private lFibraFs := .F.


	Default nMaxLinhas:= 1
	Static oDlg

	nCelula				:= fButtCel(nMaxLinhas)
	cFileErro			:= cStartPath + 'errado.png'
	cFileok				:= cStartPath + 'certo.png'
	cFileLogo			:= cStartPath + 'logo.png'
	cFileAten			:= cStartPath + 'Atencao.png'
	cFileInter			:= cStartPath + 'Interroga.png'
	cPerc00				:= cStartPath + 'PERC00.png'
	cPerc25				:= cStartPath + 'PERC25.png'
	cPerc50				:= cStartPath + 'PERC50.png'
	cPerc75				:= cStartPath + 'PERC75.png'
	cPerc99			    := cStartPath + 'PERC99.png'
	cLogoHu				:= cStartPath + 'huawei_lg.png'

	IF cTipo == "TRUNK"
		cTpProd  := "'TRUE', 'TRUN'"
		cNotTps  := "'PA','ME'"
		_cTitulo := "ROTEIRO DE PRODU??O TRUNK - LINHA "+cValToChar(nCelula)
		lFibraFs := .T.
	ElseIF cTipo == "DIO"
		cTpProd := "'DIO'"
		cNotTps := "'PA','ME'"
		cNotGrp := "'FO','CON'" // grupo
		_cTitulo := "ROTEIRO DE PRODU??O DIO - LINHA " + cValToChar(nCelula)
	ElseIF cTipo == "CMTP" 
		cTpProd := "'CMTP'"
		cNotTps := "'PA','ME'"
		cNotGrp := "'FO','CON'" // grupo
		lFibraFs := .T.
		_cTitulo := "ROTEIRO DE PRODU??O CMTP - LINHA " + cValToChar(nCelula)
	Endif


	DEFINE MSDIALOG oDlg TITLE "" FROM 000, 000  TO 800, 1366 COLORS 0, 16777215 PIXEL
	oDlg:lMaximized := .T.

	@ 006, 200 SAY oSay1 PROMPT _cTitulo  SIZE 389, 080 OF oDlg FONT oFont4 COLORS 0, 16777215 PIXEL
	@ 027, 019 GROUP oGroup1 TO 121,450 OF oDlg COLOR 0, 16777215 PIXEL
	@ 027, 455 GROUP oGroup2 TO 121,565 OF oDlg COLOR 0, 16777215 PIXEL

	@ 030, 025 SAY oSay2 PROMPT "Etiqueta" SIZE 061, 016 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
	@ 040, 025 MSGET oEtiq VAR cEtiqOfc SIZE 146, 015 OF oDlg PICTURE "@!" VALID (fVldEti(@cEtiqOfc) .OR. empty(@cEtiqOfc)) COLORS 16711680, 16777215 FONT oFont3  F3 "SB1" PIXEL

	@ 030, 175 SAY oSay3 PROMPT "Ordem de produ??o" SIZE 100, 016 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
	@ 040, 175 MSGET oCodOp VAR cCodOP SIZE 100, 015 OF oDlg COLORS 16711680, 16777215 FONT oFont3 PIXEL WHen .F.

	@ 030, 280 SAY oSay4 PROMPT "Qtd.OP" SIZE 080, 016 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
	@ 040, 280 MSGET oQtdOri VAR nQtdOri SIZE 080, 015 OF oDlg PICTURE "@E 999,999.999" COLORS 16711680, 16777215 FONT oFont3 PIXEL WHen .F.

	@ 030, 365 SAY oSay5 PROMPT "Qtd.Produzida" SIZE 080, 016 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
	@ 040, 365 MSGET oQtdEnt VAR nQtdEnt SIZE 080, 015 OF oDlg PICTURE "@E 999,999.999" COLORS 16711680, 16777215 FONT oFont3 PIXEL WHen .F.


	@ 060, 025 SAY oSay6 PROMPT "Produto" SIZE 061, 008 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
	@ 070, 025 MSGET oCodPai VAR cCodPai SIZE 146, 015 OF oDlg COLORS 16711680, 16777215 FONT oFont3 PIXEL WHen .F.

	@ 060, 175 SAY oSay7 PROMPT "Descri??o" SIZE 061, 008 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
	@ 070, 175 MSGET oNomePai VAR cNomePai SIZE 265, 015 OF oDlg COLORS 16711680, 16777215 FONT oFont3 PIXEL WHen .F.

	@ 090, 025 SAY oSay8 PROMPT "Cliente" SIZE 061, 008 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
	@ 100, 025 MSGET oNomeCli VAR cCliente SIZE 298, 015 OF oDlg COLORS 16711680, 16777215 FONT oFont3 PIXEL WHen .F.

	@ 030, 460 SAY oSay10 PROMPT "Data Inicial" SIZE 060, 016 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
	@ 040, 460 MSGET oDtIni VAR dDataIni SIZE 100, 015 OF oDlg COLORS 16711680, 16777215 FONT oFont3 PIXEL

	@ 060, 460 SAY oSay9 PROMPT "Procurar OP" SIZE 060, 016 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
	@ 070, 460 MSGET oLocOp VAR cLocOP SIZE 100, 015 OF oDlg COLORS 16711680, 16777215 FONT oFont3 PIXEL

	//Atributos dos botoes
	cCSSBtN1 :=	"QPushButton{background-color: #f6f7fa; color: #707070; font: bold 20px MS Sans Serif }"+;
		"QPushButton:pressed {background-color: #50b4b4; color: white; font: bold 20px MS Sans Serif; }"+;
		"QPushButton:hover {background-color: #878787 ; color: white; font: bold 20px MS Sans Serif; }"

	nTamBut:= 100
	nPColBt:= 460
	@ 94, nPColBt BUTTON oButton1 PROMPT "Documentos" Action (IIF(!EMPTY(cCodOp),U_RESTC01B(cCodOP),Msginfo("Informe a OP antes de consultar o documento","Aviso"))) SIZE nTamBut, 25 OF oDlg FONT oFont1 PIXEL
	oButton1:setCSS(cCSSBtN1)

	oBtn2 := TBtnBmp2():New( 578,400,26,26,"VERMELHO",,,,,oDlg,,,.T. )
	@ 292, 214 SAY oLeg2 PROMPT "N?o Iniciado" 	SIZE 150, 012 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
	oBtn3 := TBtnBmp2():New( 578,650,26,26,"AMARELO",,,,,oDlg,,,.T. )
	@ 292, 340 SAY oLeg3 PROMPT "Em Andamento" 	SIZE 150, 012 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
	oBtn1 := TBtnBmp2():New( 578,900,26,26,"VERDE",,,,,oDlg,,,.T. )
	@ 292, 468 SAY oLeg1 PROMPT  "Finalizado" 	SIZE 150, 012 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL


	aHeader := {}
	aCols   := {}
	AADD(aHeader,  {    ""					, "FLAG"   	   	,"@BMP" 			,01,0,""    ,"???????????????","C"     ,""     ,"R"         ,""            ,""           ,".F."   ,"V"      , ""               , ""        , ""        })
	AADD(aHeader,  {    "Componente" 		, "COMP"  		,"@R"				,15,0,""    ,"???????????????","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
	AADD(aHeader,  {    "Desc.Componente"	, "DESC2"  		,"@R"				,40,0,""    ,"???????????????","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
	AADD(aHeader,  {    "Qtd.Empenho"	 	, "QTDOP"  		,"@E 999,999.999" 	,07,0,""    ,"???????????????","N"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
	AADD(aHeader,  {    "Qtd.Entregue" 		, "QTDENT" 		,"@E 999,999.999" 	,07,0,""    ,"???????????????","N"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
	AADD(aHeader,  {    "Dt.Program."    	, "DTPROG"  	,"@R"				,08,0,""    ,"???????????????","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
	AADD(aHeader,  {    "Grupo"		       	, "GRUPO"  		,"@R" 				,06,0,""    ,"???????????????","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
	AADD(aHeader,  {    ""	 				, "COR"  		,"@R"				,01,0,""    ,"???????????????","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })

	oGetDados:= (MsNewGetDados():New( 125, 021 , 288 ,450,NIL ,"AlwaysTrue" ,"AlwaysTrue", /*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*VldCpo*/,/*superdel*/,/*delok*/,oDlg,aHeader,aCols))
	//oGetDados:oBrowse:lUseDefaultColors := .F.
	//oGetDados:oBrowse:SetBlkBackColor({|| CorGd02(oGetDados:nAt,8421376)})
	//oGetDados:oBrowse:oFont  := oFont4
	//oGetDados:oBrowse:oFont:NHEIGHT  := 50
	//oGetDados:oBrowse:oFont:Nwidth   := 50
	oGetDados:oBrowse:Refresh()

	aHeader2 := {}
	aCols2   := {}
	AADD(aHeader2,  {    "OP"				, "FLAG2"   	,"@BMP" 			,01,0,""    ,"???????????????","C"     ,""     ,"R"         ,""            ,""           ,".F."   ,"V"      , ""               , ""        , ""        })
	AADD(aHeader2,  {    "PG"				, "FLAG3"   	,"@BMP" 			,01,0,""    ,"???????????????","C"     ,""     ,"R"         ,""            ,""           ,".F."   ,"V"      , ""               , ""        , ""        })
	AADD(aHeader2,  {    "Ordem Prod." 		, "OP"  		,"@R"				,12,0,""    ,"???????????????","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
	AADD(aHeader2,  {    "Qtd.Orig"	 		, "QTDORIG"  	,"@E 9,999,999" 	,07,0,""    ,"???????????????","N"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
	AADD(aHeader2,  {    "Qtd.Apontada" 	, "QTDAPONT" 	,"@E 9,999,999" 	,07,0,""    ,"???????????????","N"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
	AADD(aHeader2,  {    "Dt.Program."    	, "DTPROG2"  	,"@R"				,08,0,""    ,"???????????????","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
	AADD(aHeader2,  {    ""	 				, "COR2"  		,"@R"				,01,0,""    ,"???????????????","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })

	oGetDados2:= (MsNewGetDados():New( 125, 455 , 288 ,660,NIL ,"AlwaysTrue" ,"AlwaysTrue", /*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*VldCpo*/,/*superdel*/,/*delok*/,oDlg,aHeader2,aCols2))
	oGetDados2:oBrowse:lUseDefaultColors := .F.
	oGetDados2:oBrowse:SetBlkBackColor({|| CorGd02(oGetDados2:nAt)})
	oGetDados2:oBrowse:Refresh()
	oGetDados2:oBrowse:bLDblClick := { || cEtiqOfc:= "S"+oGetDados2:aCols[oGetDados2:nAt,3],fVldEti(@cEtiqOfc) }
	MONTATELA2(nMaxLinhas)

	DEFINE TIMER oTimer INTERVAL 30000 ACTION fAtualiza(oTimer,oGetDados2) OF oDlg
	oTimer:Activate()

	ACTIVATE MSDIALOG oDlg CENTERED

Return

//--------------------------------------------------------------
/*/Protheus.doc DOMROT - ROTEIRO DE PRODU??O DOMEX
	Atualiza a tela via refresh tempor?rio
	author: Ricardo Roda
/*/
//--------------------------------------------------------------

Static Function fAtualiza(oTimer,oGetDados2)
	oTimer:DeActivate()
	fAtuPgOp()
	oEtiq:SetFocus()
	oTimer:Activate()
Return
//--------------------------------------------------------------
/*/Protheus.doc DOMROT - ROTEIRO DE PRODU??O DOMEX
	Descri??o da fun??o - altera??o de cor da linha
/*/
//--------------------------------------------------------------

Static Function CorGd02(nLinha)
	Local nRet := 16777215
	Local nPosOp	:= aScan(oGetDados2:aHeader,{|_y| AllTrim(_y[2]) == "OP"  })

	If oGetDados2:aCols[nLinha,nPosOp] == cCodOP
		nRet := n2Leg1
	Else
		nRet := n2Leg2
	Endif

Return nRet


//--------------------------------------------------------------
/*/Protheus.doc DOMROT - ROTEIRO DE PRODU??O DOMEX
	Descri??o da fun??o - Valida??o da etiqueta na XD1
/*/
//--------------------------------------------------------------
Static Function fVldEti(cEtiqOfc)
	Local nPosFlag	:= GdFieldPos( "FLAG" )
	Local nPosComp	:= GdFieldPos( "COMP" )
	Local nPosGpr	:= GdFieldPos( "GRUPO" )
	Local nPQtdent	:= GdFieldPos( "QTDENT" )
	Local nPQtdOp	:= GdFieldPos( "QTDOP" )
	Local lRet:= .F.
	Local lTroca:= .F.
	Local _x

	if Empty(AllTrim(cEtiqOfc))
		Return .F.
	Endif

	if Subs(cEtiqOfc,1,1) == "S" .OR. Substring(cEtiqOfc,LEN(AllTrim(cEtiqOfc)),1) == "X"

		If Empty(cCodOp)
			cCodOp:= Subs(cEtiqOfc,2,8)
			DbSelectArea("SC2")
			SC2->(DbSetOrder(1))
			if !SC2->(dbSeek(xFilial("SC2")+cCodOP))
				MyMsg("Ordem de produ??o inv?lida!" ,1)
				@ nLBitm, nPosBitm BITMAP oBitmap10 SIZE 100, 098 OF oDlg FILENAME cFileErro NOBORDER PIXEL
				cEtiq := SPACE(20)
				cEtiqOfc := SPACE(30)
				cComp := CriaVar("B1_COD")
				oEtiq:Refresh()
				oEtiq:setfocus()
				cCodOp:= Space(11)
				Return .F.
			Endif
			montatela()
			fVldXd4St(cCodOp,cEtiqOfc)
			fStatus()

		ElseIf !empty(cCodOp) .and. AllTrim(Subs(cEtiqOfc,2,8)) <> cCodOp

			if len (AllTrim(cEtiqOfc)) > 12
				MyMsg("Etiqueta pertence a outra ordem de produ??o: N? OP "+AllTrim(Subs(cEtiqOfc,2,8)) ,2)
			Endif

			lTroca:= MyMsg("Deseja trocar de ordem de produ??o?"  ,2)

			If lTroca
				cCodOp:= Subs(cEtiqOfc,2,8)
				DbSelectArea("SC2")
				DbSetOrder(1)
				if !SC2->(dbSeek(xFilial("SC2")+cCodOP))
					MyMsg("Ordem de produ??o inv?lida!" ,1)
					@ nLBitm, nPosBitm BITMAP oBitmap10 SIZE 100, 098 OF oDlg FILENAME cFileErro NOBORDER PIXEL
					cEtiq := SPACE(20)
					cEtiqOfc := SPACE(30)
					cComp := CriaVar("B1_COD")
					oEtiq:Refresh()
					oEtiq:setfocus()
					cCodOp:= Space(11)
					Return .F.
				Endif
				montatela()
				fVldXd4St(cCodOp,cEtiqOfc)
				fStatus()

			Else
				@ nLBitm, nPosBitm BITMAP oBitmap10 SIZE 100, 098 OF oDlg FILENAME cFileErro NOBORDER PIXEL
				cEtiq := SPACE(20)
				cEtiqOfc := SPACE(30)
				cComp := CriaVar("B1_COD")
				oEtiq:Refresh()
				oEtiq:setfocus()
				Return .F.
			Endif

		ElseIf !empty(cCodOp) .and. AllTrim(Subs(cEtiqOfc,2,8)) == cCodOp
			montatela()
			fVldXd4St(cCodOp,cEtiqOfc)
			fStatus()

		Endif

	Else
		cEtiq:= "0"+Subs(cEtiqOfc,1,11)
		if  AllTrim(cEtiq) <> AllTrim(cEtiqOfc)
			cEtiqAtu:= cEtiq
		Endif

		cComp:= ""
		dbSelectArea("XD1")
		XD1->(dbsetorder(1))
		if XD1->(dbseek(xFilial("XD1")+cEtiq))


			If empty(AllTrim(XD1->XD1_OP)) .and. empty(cCodOp)
				MyMsg("1? Etiqueta lida deve pertencer a uma ordem de produ??o!  "+AllTrim(XD1->XD1_OP)  ,1)
				@ nLBitm, nPosBitm BITMAP oBitmap10 SIZE 100, 098 OF oDlg FILENAME cFileErro NOBORDER PIXEL
				cEtiq := SPACE(20)
				cEtiqOfc := SPACE(30)
				cComp := CriaVar("B1_COD")
				oEtiq:Refresh()
				oEtiq:setfocus()
				Return .F.
			ElseIf !empty(cCodOp) .and.   !empty(AllTrim(XD1->XD1_OP)) .and. AllTrim(XD1->XD1_OP) <> cCodOp
				MyMsg("Etiqueta pertence a outra ordem de produ??o: N? OP "+AllTrim(XD1->XD1_OP)  ,1)
				lTroca:= MyMsg("Deseja trocar de ordem de produ??o?"  ,2)

				If lTroca
					cCodOp:=  subs(AllTrim(XD1->XD1_OP),1,8)
					montatela()
					fVldXd1St(cCodOp)
					fStatus()

				Else
					@ nLBitm, nPosBitm BITMAP oBitmap10 SIZE 100, 098 OF oDlg FILENAME cFileErro NOBORDER PIXEL
					cEtiq := SPACE(20)
					cEtiqOfc := SPACE(30)
					cComp := CriaVar("B1_COD")
					oEtiq:Refresh()
					oEtiq:setfocus()
					Return .F.
				Endif
			ElseIf XD1->XD1_QTDATU <= 0
				MyMsg("Etiqueta sem saldo!",1)
				@ nLBitm, nPosBitm BITMAP oBitmap10 SIZE 100, 098 OF oDlg FILENAME cFileErro NOBORDER PIXEL
				cEtiq := SPACE(20)
				cEtiqOfc := SPACE(30)
				cComp := CriaVar("B1_COD")
				oEtiq:Refresh()
				oEtiq:setfocus()
				Return .F.
			ElseIf empty(cCodOp)
				cCodOp:= subs(AllTrim(XD1->XD1_OP),1,8)
				montatela()
				fVldXd1St(cCodOp)
				fStatus()

			Endif

			If XD1->XD1_OCORRE == '7'
				MyMsg("Etiqueta j? lida!" ,1)
				cEtiq := SPACE(20)
				cEtiqOfc := SPACE(30)
				cComp := CriaVar("B1_COD")
				oEtiq:Refresh()
				oEtiq:setfocus()
				Return .F.
			Endif

			cComp  := AllTrim(XD1->XD1_COD)
			nQtdEti:= XD1->XD1_QTDATU
			nPos:= aScan(oGetDados:aCols,{|x| AllTrim(x[nPosComp]) == AllTrim(cComp)})


			IF nPos > 0
				IF (nQtdEti +oGetDados:aCols[nPos,nPQtdent])  > oGetDados:aCols[nPos,nPQtdOp]
					MyMsg("Quantidade da etiqueta excede a solicita??o da ordem de produ??o",1)
					@ nLBitm, nPosBitm BITMAP oBitmap10 SIZE 100, 098 OF oDlg FILENAME cFileErro NOBORDER PIXEL
					cEtiq := criavar("XD1_XXPECA")
					cEtiqOfc := SPACE(30)
					cComp := CriaVar("B1_COD")
					oEtiq:Refresh()
					oEtiq:setfocus()
					Return .F.
				Else

					oGetDados:aCols[nPos,nPQtdent] := oGetDados:aCols[nPos,nPQtdent] + nQtdEti

					XD1->(dbsetorder(1))
					XD1->(dbseek(xFilial("XD1")+cEtiq))
					Reclock("XD1", .F.)
					XD1->XD1_OP	:= cCodOp
					XD1->XD1_OCORRE	:= '7'
					XD1->XD1_USRROT:= cUserSis
					XD1->XD1_DTROT:= dDataBase
					XD1->XD1_HRROT:= time()

					XD1->(MsUnlock())


					if	oGetDados:aCols[nPos,nPQtdent] == oGetDados:aCols[nPos,nPQtdOp]
						oGetDados:aCols[nPos,nPosFlag] := oOk
					Elseif oGetDados:aCols[nPos,nPQtdent] == 0
						oGetDados:aCols[nPos,nPosFlag] := oNo
					Elseif oGetDados:aCols[nPos,nPQtdent] > 0 .and. oGetDados:aCols[nPos,nPQtdent] < oGetDados:aCols[nPos,nPQtdOp]
						oGetDados:aCols[nPos,nPosFlag] := oIn
					Endif

				Endif
			Endif
		Else
			MyMsg("Etiqueta Invalida!",1)
			@ nLBitm, nPosBitm BITMAP oBitmap10 SIZE 100, 098 OF oDlg FILENAME cFileErro NOBORDER PIXEL
		Endif
	Endif

	cEtiq := criavar("XD1_XXPECA")
	cEtiqOfc := SPACE(30)
	cComp := CriaVar("B1_COD")
	oEtiq:Refresh()
	oEtiq:SetFocus()

	oGetDados:Refresh()
	fStatus()
	fAtuPgOp()
Return lRet


//--------------------------------------------------------------
/*/Protheus.doc DOMROT - ROTEIRO DE PRODU??O DOMEX
	Descri??o da fun??o - MENSAGEM PERSONALIZADA
/*/
//--------------------------------------------------------------

static Function MyMsg(cAviso,nOpc, lPerg)
	Local oFont1 := TFont():New("Arial",,044,,.F.,,,,,.F.,.F.)
	Local oFont2 := TFont():New("Arial",,020,,.F.,,,,,.F.,.F.)

	Local oSay1
	Local lRet:= .T.
	Local oCheckBo1

	Static oDlg3

	Default lPerg := .F.

	if nOpc == 1
		DEFINE MSDIALOG oDlg3 TITLE "Aviso" FROM 000, 000  TO 400, 800 COLORS 0, 16777215 PIXEL
		@ 002, 150 BITMAP oBitmap10 SIZE 150, 150 OF oDlg3 FILENAME cFileAten NOBORDER PIXEL

		@ 090, 012 SAY oSay1 PROMPT cAviso SIZE 381, 092 OF oDlg3 FONT oFont1 COLORS 0, 16777215 PIXEL
		@ 151, 149 BUTTON oButton1 PROMPT "OK" SIZE 098, 043 OF oDlg3 ACTION ( oDlg3:End() ) FONT oFont1 PIXEL
	Elseif nOpc == 2
		DEFINE MSDIALOG oDlg3 TITLE "Aviso" FROM 000, 000  TO 400, 800 COLORS 0, 16777215 PIXEL
		@ 002, 150 BITMAP oBitmap10 SIZE 150, 150 OF oDlg3 FILENAME cFileInter NOBORDER PIXEL

		@ 090, 012 SAY oSay1 PROMPT cAviso SIZE 381, 092 OF oDlg3 FONT oFont2 COLORS 0, 16777215 PIXEL
		@ 151, 090 BUTTON oButton1 PROMPT "N?O" SIZE 098, 043 OF oDlg3 ACTION ( oDlg3:End(),lRet:= .F. ) FONT oFont1 PIXEL
		@ 151, 210 BUTTON oButton1 PROMPT "SIM" SIZE 098, 043 OF oDlg3 ACTION ( oDlg3:End() ) FONT oFont1 PIXEL
	Endif

	IF lPerg
		@ 120, 030 CHECKBOX oCheckBo1 VAR lCheckBo1 PROMPT "N?o perguntar novamente " SIZE 150, 150 OF oDlg3  FONT oFont2 COLORS 0, 16777215 PIXEL
	EndIf

	ACTIVATE MSDIALOG oDlg3 CENTERED

	if nOpc == 2
		Return lRet
	Else
		Return
	Endif




//--------------------------------------------------------------
/*/Protheus.doc DOMROT - ROTEIRO DE PRODU??O DOMEX
	Descri??o da fun??o - Monta Tela MsNewGetDados com informa??es de
	Produtos a separar conforme ordem de produ??o escolhida
/*/
//-------------------------------
Static Function MontaTela()
	Local cQuery:= ""
	//Local nPosCor	:= GdFieldPos( "COR" )
	//Local nPosFlag	:= GdFieldPos( "FLAG" )
	Local nQtdOp    := 0
//	Local cCodNot   := "'1PDRKITA2RD24S','1P1RKITBOBINAM2','1PDRKITCM501000'"

	if empty(cCodOp)
		Return
	Endif

	If select("QRY2") > 0
		QRY2->(dbClosearea())
	Endif

	cQuery:= " SELECT D4_PRODUTO, B1_GRUPO, D4_COD,B1_DESC,SUM(D4_QTDEORI) D4_QTDEORI  "+ENTER

	cQuery+= " 	, CASE WHEN (B1_GRUPO = 'FO' OR B1_GRUPO = 'FOFS') THEN ISNULL((SELECT SUM(XD4_QTVIAS) "+ENTER
	cQuery+= "  		 FROM "+RETSQLNAME("XD4")+" XD4 "+ENTER
	cQuery+= "  		 WHERE XD4_OP LIKE  '"+cCodOP+"%' "+ENTER
	cQuery+= "  		  AND XD4_FILIAL = '"+xFilial("XD4")+"' "+ENTER
	cQuery+= " 		  AND XD4_STATUS = '2'"+ENTER
	cQuery+= " 	 	  AND XD4_PRODUT =  D4_COD"+ENTER
	cQuery+= "  		  AND XD4.D_E_L_E_T_ = ''),0) "+ENTER
	cQuery+= " 		  ELSE"+ENTER
	cQuery+= " 		  ISNULL((SELECT SUM(XD1_QTDATU) "+ENTER
	cQuery+= "  		FROM "+RETSQLNAME("XD1")+" XD1 "+ENTER
	cQuery+= "  		 WHERE XD1_OP LIKE  '"+cCodOP+"%' "+ENTER
	cQuery+= "  		  AND XD1_FILIAL = '"+xFilial("XD1")+"' "+ENTER
	cQuery+= " 		  AND XD1_OCORRE = '7'"+ENTER
	cQuery+= " 	 	  AND XD1_COD =  D4_COD"+ENTER
	cQuery+= "  		  AND XD1.D_E_L_E_T_ = ''),0) "+ENTER
	cQuery+= " 		  END"+ENTER
	cQuery+= " 		  AS QTDLID"+ENTER

	cQuery+= " FROM "+RETSQLNAME("SD4")+" SD4 "+ENTER
	cQuery+= " INNER JOIN "+RETSQLNAME("SB1")+" SB1 ON B1_COD = D4_COD  "+ENTER
	cQuery+= " AND SB1.D_E_L_E_T_ = '' AND B1_TIPO NOT IN ("+cNotTps+")  AND B1_APROPRI <> 'I' "+ENTER
	If cTpProd == "'DIO'"
		cQuery+= " AND B1_GRUPO NOT IN ("+cNotGrp+") "+ENTER
	endif
	cQuery+= " WHERE D4_OP LIKE'"+cCodOP+"%' "+ENTER
	cQuery+= " AND D4_QTDEORI > 0 "+ENTER
	cQuery+= " AND D4_OPORIG = '' "+ENTER
	cQuery+= " AND D4_LOCAL = '97'  "+ENTER
	cQuery+= " AND D4_FILIAL = '"+xFilial("SD4")+"'"+ENTER
	cQuery+= " AND SD4.D_E_L_E_T_ = '' "+ENTER
	//cQuery+= " AND SD4.D4_COD NOT IN("+cCodNot+") "
	cQuery+= " GROUP BY D4_PRODUTO, B1_GRUPO, D4_COD,B1_DESC "+ENTER
	cQuery+= " ORDER BY B1_DESC "+ENTER

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY2",.T.,.T.)

	oGetDados:aCols := {}

	If !QRY2->(eof())

		cCodPai:= QRY2->D4_PRODUTO
		cNomePai:= Posicione("SB1",1, xFilial("SB1")+QRY2->D4_PRODUTO,"B1_DESC")

		DbSelectArea("SC2")
		DbSetOrder(1)
		dbSeek(xFilial("SC2")+cCodOP)
		cCLiente:= SC2->C2_CLIENT+" - " +AllTrim(SC2->C2_NCLIENT )
		nQtdOri := SC2->C2_QUANT
		nQtdEnt := SC2->C2_QUJE
		cCodPai := SC2->C2_PRODUTO
		cNomePai :=Posicione("SB1",1, xFilial("SB1")+SC2->C2_PRODUTO ,"B1_DESC")

		SA1->(dbSeek(xFilial("SA1")+SC2->C2_CLIENT))
		lCodHuawei  := If("HUAWEI" $ SA1->A1_NOME, .T., .F.)

		if lCodHuawei
			dbSelectArea("SC6")
			dbSetOrder(1)
			IF dbSeek(xFilial()+SC2->C2_PEDIDO+SC2->C2_ITEM)
				cCodHuawei:= "PN HUAWEI: "+AllTrim(SC6->C6_SEUCOD)
			else
				cCodHuawei:= ""
			ENDIF

			//@ 086, 400 BITMAP oBitmapH SIZE 160, 114 OF oDlg FILENAME cLogoHu NOBORDER PIXEL
			@ 095, 330 SAY oSayHuawei PROMPT cCodHuawei SIZE 110, 015 OF oDlg FONT oFont5 COLORS 0, 16777215 PIXEL
			//oBitmapH:refresh()
			oSayHuawei:refresh()

		Else
			cCodHuawei:= ""
			//@ 000, 000 BITMAP oBitmapH SIZE 000, 000 OF oDlg FILENAME cLogoHu NOBORDER PIXEL
			@ 095, 330 SAY oSayHuawei PROMPT cCodHuawei SIZE 110, 015 OF oDlg FONT oFont5 COLORS 0, 16777215 PIXEL

			//oBitmapH:refresh()
			oSayHuawei:refresh()
		Endif


		While QRY2->(!eof())

			IF U_VALIDACAO("RODA") .OR. .T.

				If AllTrim(QRY2->B1_GRUPO) == 'FO'
					DbSelectArea("SG1")
					SG1->(DbSetOrder(1))
					IF SG1->(DbSeek(xFilial("SG1")+PADR(QRY2->D4_PRODUTO,TamSX3("D4_PRODUTO")[1])+QRY2->D4_COD))
						nQtdOp:= QRY2->D4_QTDEORI / SG1->G1_QUANT
					Else
						nQtdOp:= nQtdOri
					Endif
				ElseIf AllTrim(QRY2->B1_GRUPO) == 'FOFS'
					DbSelectArea("SG1")
					SG1->(DbSetOrder(1))
					IF SG1->(DbSeek(xFilial("SG1")+PADR(QRY2->D4_PRODUTO,TamSX3("D4_PRODUTO")[1])+QRY2->D4_COD))
						IF 	 SG1->G1_XQTDVIA > 1
							nQtdOp:= nQtdOri * SG1->G1_XQTDVIA
						else
							nQtdOp:= nQtdOri
						Endif
					Else
						nQtdOp:= nQtdOri
					Endif
				Else
					nQtdOp:= QRY2->D4_QTDEORI
				Endif

			ELSE
				If AllTrim(QRY2->B1_GRUPO) $ 'FO|FOFS'
					DbSelectArea("SG1")
					SG1->(DbSetOrder(1))
					IF SG1->(DbSeek(xFilial("SG1")+PADR(QRY2->D4_PRODUTO,TamSX3("D4_PRODUTO")[1])+QRY2->D4_COD))
						nQtdOp:= QRY2->D4_QTDEORI / SG1->G1_QUANT
					Else
						nQtdOp:= nQtdOri
					Endif

				Else
					nQtdOp:= QRY2->D4_QTDEORI
				Endif
			ENDIF

			nPos:= aScan(oGetDados:aCols,{|x| AllTrim(x[2]) == AllTrim(QRY2->D4_COD) })

			IF nPos > 0
				oGetDados:aCols[nPos,aScan(oGetDados:aHeader,{|aVet| AllTrim(aVet[2]) == 'QTDOP' })] += nQtdOp
			Else
				AADD(oGetDados:aCols,Array(Len(oGetDados:aHeader)+1))
				oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| AllTrim(aVet[2]) == 'FLAG'  })] := oNo
				oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| AllTrim(aVet[2]) == 'COMP'  })] := AllTrim(QRY2->D4_COD)
				oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| AllTrim(aVet[2]) == 'DESC2' })] := AllTrim(QRY2->B1_DESC)
				oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| AllTrim(aVet[2]) == 'QTDOP' })] := nQtdOp// QRY2->D4_QUANT
				oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| AllTrim(aVet[2]) == 'QTDENT'})] := QRY2->QTDLID
				oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| AllTrim(aVet[2]) == 'DTPROG'})] := DTOC(dDatabase)
				oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| AllTrim(aVet[2]) == 'GRUPO' })] := AllTrim(QRY2->B1_GRUPO)
				oGetDados:aCols[Len(oGetDados:aCols),Len(oGetDados:aHeader)+1 ] := .F.

			Endif
			QRY2->(DbSkip())
		EndDo
	Else
		AADD(oGetDados:aCols,Array(Len(oGetDados:aHeader)+1))
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| AllTrim(aVet[2]) == 'FLAG'  })] := oNo
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| AllTrim(aVet[2]) == 'COMP'  })] := ""
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| AllTrim(aVet[2]) == 'DESC2' })] := ""
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| AllTrim(aVet[2]) == 'QTDOP' })] := 0
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| AllTrim(aVet[2]) == 'QTDENT'})] := 0
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| AllTrim(aVet[2]) == 'DTPROG'})] := DTOC(dDatabase)
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| AllTrim(aVet[2]) == 'GRUPO' })] := ""
		oGetDados:aCols[Len(oGetDados:aCols),Len(oGetDados:aHeader)+1 ] := .T.
	EndIf

	oCodOp:Refresh()
	oQtdOri:Refresh()
	oQtdEnt:Refresh()
	oCodPai:Refresh()
	oNomePai:Refresh()
	oNomeCli:Refresh()
	oQtdEnt:Refresh()

	oGetDados:Refresh()
	QRY2->(dbCloseArea())

	fStatus()

Return




//--------------------------------------------------------------
/*/Protheus.doc DOMROT - ROTEIRO DE PRODU??O DOMEX
	Descri??o da fun??o - Monta Tela do segundo MsNewGetDados com
	informa??es das ordem de produ??o programadas
/*/
//-------------------------------
Static Function MontaTela2(nMaxLinhas)
	Local cQuery:= ""
	//Local nPosCor	:= GdFieldPos( "COR2" )
	//Local nPosFlag	:= GdFieldPos( "FLAG2" )
	//Local nQtdOp    := 0

	If select("QRY") > 0
		QRY->(dbClosearea())
	Endif

	If nMaxLinhas > 1

		cQuery:= "  SELECT DISTINCT P10_OP OP, P10_DTPROG DTPROG, C2_QUANT,C2_QUJE " +ENTER
		cQuery+= " , C2_ORDSEP   " +ENTER
		cQuery+= "  FROM "+RETSQLNAME("P10")+" P10 " +ENTER
		cQuery+= "  INNER JOIN "+RETSQLNAME("SC2")+" SC2 ON C2_FILIAL = '"+xFilial("SC2")+"' " +ENTER
		cQuery+= "  AND C2_NUM+C2_ITEM+C2_SEQUEN = P10_OP AND SC2.D_E_L_E_T_ = '' " +ENTER
		cQuery+= "  AND C2_QUANT > C2_QUJE " +ENTER
		cQuery+= " INNER JOIN "+RETSQLNAME("SB1")+" SB1 ON B1_COD = C2_PRODUTO AND SB1.D_E_L_E_T_ = '' "+ENTER
		cQuery+= " AND B1_GRUPO IN ("+cTpProd+") " +ENTER
		cQuery+= " AND B1_SUBCLAS <>  'KIT PIGT'" +ENTER
		cQuery+= "  WHERE  P10_FILIAL = '"+xFilial("P10")+"'  AND P10.D_E_L_E_T_ = '' " +ENTER
		cQuery+= "  AND P10_LINHA = 'LINHA "+cValToChar(nCelula)+"'  " +ENTER
		cQuery+= "  ORDER BY 2 " +ENTER

	Else
		cQuery:= " SELECT  D4_OP OP,D4_DATA DTPROG, C2_QUANT,C2_QUJE,C2_ORDSEP   "+ENTER
		cQuery+= " FROM "+RETSQLNAME("SD4")+" SD4 WITH(NOLOCK) "   +ENTER
		cQuery+= " INNER JOIN "+RETSQLNAME("SB1")+" SB1 ON B1_COD = D4_PRODUTO AND SB1.D_E_L_E_T_ = ''   "+ENTER
		cQuery+= " AND B1_GRUPO IN ("+cTpProd+") "   +ENTER
		cQuery+= " AND B1_SUBCLAS <>  'KIT PIGT'"   +ENTER
		cQuery+= " INNER JOIN "+RETSQLNAME("SC2")+" SC2 ON   C2_FILIAL = '"+xFilial("SC2")+"' AND C2_NUM+C2_ITEM+C2_SEQUEN  = D4_OP AND SC2.D_E_L_E_T_ = '' AND C2_DATRF = ''   "+ENTER
		cQuery+= " WHERE D4_FILIAL = '"+xFilial("SD4")+"'   "+ENTER
		cQuery+= " AND SD4.D_E_L_E_T_ =''   "+ENTER
		cQuery+= " AND D4_QUANT > 0   "+ENTER
		cQuery+= " GROUP BY D4_DATA,D4_OP,C2_QUANT,C2_QUJE,C2_ORDSEP   "+ENTER
		cQuery+= " ORDER BY D4_DATA, D4_OP   "+ENTER

	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)
	oGetDados2:aCols := {}

	If !QRY->(eof())

		While QRY->(!eof())

			cStatus:= IIF (EMPTY(AllTrim(QRY->C2_ORDSEP)), "1",AllTrim(QRY->C2_ORDSEP))

			AADD(oGetDados2:aCols,Array(Len(oGetDados2:aHeader)+1))
			oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aHeader,{|aVet| AllTrim(aVet[2]) == 'FLAG2'  })] := iif(QRY->C2_QUJE == 0, oNo,IIF(QRY->C2_QUJE > 0 .and. QRY->C2_QUANT<> QRY->C2_QUJE,oIn,oOK ))
			oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aHeader,{|aVet| AllTrim(aVet[2]) == 'FLAG3'  })] := iif(cStatus == '1', oNo,IIF(cStatus == '2',oIn,oOK ))
			oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aHeader,{|aVet| AllTrim(aVet[2]) == 'OP'  })] := AllTrim(QRY->OP)
			oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aHeader,{|aVet| AllTrim(aVet[2]) == 'QTDORIG' })] := QRY->C2_QUANT
			oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aHeader,{|aVet| AllTrim(aVet[2]) == 'QTDAPONT' })] := QRY->C2_QUJE
			oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aHeader,{|aVet| AllTrim(aVet[2]) == 'DTPROG2'})] := DTOC(STOD(QRY->DTPROG))
			oGetDados2:aCols[Len(oGetDados2:aCols),Len(oGetDados2:aHeader)+1 ] := .F.
			QRY->(DbSkip())
		EndDo
	Else
		AADD(oGetDados2:aCols,Array(Len(oGetDados2:aHeader)+1))
		oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aHeader,{|aVet| AllTrim(aVet[2]) == 'FLAG2'  })] := oNo
		oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aHeader,{|aVet| AllTrim(aVet[2]) == 'FLAG3'  })] := oNo
		oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aHeader,{|aVet| AllTrim(aVet[2]) == 'OP'  })] := ""
		oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aHeader,{|aVet| AllTrim(aVet[2]) == 'QTDORIG' })] := 0
		oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aHeader,{|aVet| AllTrim(aVet[2]) == 'QTDAPONT' })] := 0
		oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aHeader,{|aVet| AllTrim(aVet[2]) == 'DTPROG2'})] := DTOC(dDatabase)
		oGetDados2:aCols[Len(oGetDados2:aCols),Len(oGetDados2:aHeader)+1 ] := .T.
	EndIf

	oGetDados2:Refresh()
	QRY->(dbCloseArea())

Return



//--------------------------------------------------------------
/*/Protheus.doc DOMROT - ROTEIRO DE PRODU??O DOMEX
	Descri??o da fun??o - MENSAGEM PERSONALIZADA
/*/
//--------------------------------------------------------------

Static Function fButtCel(_nLinhas)
	Local nCelula := ""
	Local oCelCort1
	Local oCelCort2
	Local oCelCort3
	Local oCelCort4
	Local oCelCort5
	Local oCelCort6
	Local oCelCort7

	Local oFont1 := TFont():New("Arial",,050,,.T.,,,,,.F.,.F.)
	Static oDlgBtC

	Local cCSSBtN1 :="QPushButton{background-color: #f6f7fa; color: #707070; font: bold 22px Arial; }"+;
		"QPushButton:pressed {background-color: #50b4b4; color: white; font: bold 22px  Arial; }"+;
		"QPushButton:hover {background-color: #878787 ; color: white; font: bold 22px  Arial; }"

	If _nLinhas <= 1
		Return 1
	Endif

	DEFINE MSDIALOG oDlgBtC TITLE "Escolha a c?lula de trabalho" FROM 000, 000  TO 430, 915 COLORS 0, 16777215 PIXEL

	If _nLinhas >= 2
		@ 010, 010 BUTTON oCelCort1 PROMPT "LINHA 1" SIZE 140, 053 OF oDlgBtC ACTION (nCelula := 1, oDlgBtc:end() ) FONT oFont1 PIXEL
		oCelCort1:setCSS(cCSSBtN1)

		@ 010, 160 BUTTON oCelCort2 PROMPT "LINHA 2" SIZE 140, 053 OF oDlgBtC ACTION (nCelula := 2, oDlgBtc:end()) FONT oFont1 PIXEL
		oCelCort2:setCSS(cCSSBtN1)
	Endif
	If _nLinhas >= 3
		@ 010, 310 BUTTON oCelCort3 PROMPT "LINHA 3" SIZE 140, 053 OF oDlgBtC ACTION (nCelula := 3, oDlgBtc:end()) FONT oFont1 PIXEL
		oCelCort3:setCSS(cCSSBtN1)
	EndIf
	If _nLinhas >= 4
		@ 080, 010 BUTTON oCelCort4 PROMPT "LINHA 4" SIZE 140, 053 OF oDlgBtC ACTION (nCelula := 4, oDlgBtc:end()) FONT oFont1 PIXEL
		oCelCort4:setCSS(cCSSBtN1)
	EndIf
	If _nLinhas >= 5
		@ 080, 160 BUTTON oCelCort5 PROMPT "LINHA 5" SIZE 140, 053 OF oDlgBtC ACTION (nCelula := 5, oDlgBtc:end()) FONT oFont1 PIXEL
		oCelCort5:setCSS(cCSSBtN1)
	EndIf
	If _nLinhas >= 6
		@ 080, 310 BUTTON oCelCort6 PROMPT "LINHA 6" SIZE 140, 053 OF oDlgBtC ACTION (nCelula := 6, oDlgBtc:end()) FONT oFont1 PIXEL
		oCelCort6:setCSS(cCSSBtN1)
	EndIf
	If _nLinhas >= 7
		@ 150, 010 BUTTON oCelCort7 PROMPT "LINHA 7" SIZE 140, 053 OF oDlgBtC ACTION (nCelula := 7, oDlgBtc:end()) FONT oFont1 PIXEL
		oCelCort7:setCSS(cCSSBtN1)
	EndIf

	ACTIVATE MSDIALOG oDlgBtC CENTERED

Return nCelula


Static function fVldXd4St(cCodOp,cId)
	Local cQuery:=""
	Local lRet:= .T.
	Local nPosComp	:= GdFieldPos( "COMP" )
	Local nPosGpr	:= GdFieldPos( "GRUPO" )
	Local nPQtdent	:= GdFieldPos( "QTDENT" )
	Local nPQtdOp	:= GdFieldPos( "QTDOP" )


	//Local nPosFlag	:= GdFieldPos( "FLAG" )

	IF nCelula > 7
		Return .F.
	Endif

	If Select("QRY") > 0
		QRY->(DbCloseArea())
	Endif

	If lFibraFs
		cQuery+=" 	SELECT R_E_C_N_O_ REC,XD4_PRODUT,XD4_STATUS, XD4_QTVIAS AS  QTDLID "+ENTER
	Else
		cQuery+=" 	SELECT R_E_C_N_O_ REC,XD4_PRODUT,XD4_STATUS,COUNT(*) QTDLID "+ENTER
	Endif
	cQuery+=" 	FROM "+RETSQLNAME("XD4")+" XD4 (NOLOCK)  "+ENTER
	cQuery+=" 	WHERE XD4_OP LIKE  '"+AllTrim(cCodOp)+"%' "+ENTER
	//cQuery+=" 	AND XD4_STATUS <> '2'   "+ENTER
	cQuery+=" 	AND XD4_FILIAL = '"+xFilial("XD4")+"' "+ENTER
	cQuery+=" 	AND XD4.D_E_L_E_T_ = '' "+ENTER
	cQuery+=" 	AND XD4_KEY =  '"+cId+"' "+ENTER
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)

	if QRY->(!Eof())
		If QRY->XD4_STATUS == '2'
			MyMsg("Etiqueta Serial j? lida!" ,1)
			lRet:= .F.
		Endif

		If lRet
			IF Empty(QRY->XD4_PRODUT)
				MyMsg("Produto n?o informado na etiqueta ID" ,1)
				lRet:= .F.
			Else
				nPos:= aScan(oGetDados:aCols,{|x| AllTrim(x[nPosComp]) == AllTrim(QRY->XD4_PRODUT) })
				IF nPos == 0
					MyMsg("Produto "+AllTrim(QRY->XD4_PRODUT)+" n?o encontrado na lista" ,1)
					lRet:= .F.
				Endif
			Endif
		Endif

		If lRet
			If QRY->QTDLID+oGetDados:aCols[nPos,nPQtdent] > oGetDados:aCols[nPos,nPQtdOp]
				MyMsg("Quantidade Excede o Empenho" ,1)
				lRet:= .F.
			Endif
		Endif

	Else
		MyMsg("Etiqueta Serial inv?lida!" ,1)
		lRet:= .F.
	Endif

	If lRet
		dbSelectArea("XD4")
		dbGoto(QRY->REC)
		Reclock("XD4", .F.)
		XD4->XD4_STATUS	:= '2'
		XD4->XD4_USRROT:= cUserSis
		XD4->XD4_DTROT:= dDataBase
		XD4->XD4_HRROT:= time()
		XD4->(MsUnlock())
	Endif

	QRY->(DbCloseArea())
	Montatela()


Return lRet

//--------------------------------------------------------------
/*/Protheus.doc DOMROT - ROTEIRO DE PRODU??O DOMEX
	Atualiza a tela via refresh tempor?rio
	author: Ricardo Roda
/*/
//--------------------------------------------------------------

Static Function fStatus()

	Local nPQtdent	:= GdFieldPos( "QTDENT" )
	Local nPQtdOp	:= GdFieldPos( "QTDOP" )
	Local nPosFlag	:= GdFieldPos( "FLAG" )
	Local nPosOp	:= aScan(oGetDados2:aHeader,{|aVet| AllTrim(avet[2]) == "OP"  })
	Local nLinha 	:= aScan(oGetDados2:acols,{|aVet| AllTrim(aVet[nPosOp]) == AllTrim(cCodOP)  })
	Local nToReg:= len(oGetDados:aCols)
	Local nRegOk:= 0
	//Local nPerc := 0
	Local _x := 0
	Local cStatus:= '1'
	Local nTotProds:= 0
	Local nQtdProds:= 0

	For _x := 1 to len(oGetDados:aCols)
		if	oGetDados:aCols[_x,nPQtdent] == oGetDados:aCols[_x,nPQtdOp]
			nRegOk += 1
		Endif
		nTotProds+= oGetDados:aCols[_x,nPQtdOp]
		nQtdProds+=	oGetDados:aCols[_x,nPQtdent]

		if	oGetDados:aCols[_x,nPQtdent] == oGetDados:aCols[_x,nPQtdOp]
			oGetDados:aCols[_x,nPosFlag] := oOk
		Elseif oGetDados:aCols[_x,nPQtdent] == 0
			oGetDados:aCols[_x,nPosFlag] := oNo
		Elseif oGetDados:aCols[_x,nPQtdent] > 0 .and. oGetDados:aCols[_x,nPQtdent] < oGetDados:aCols[_x,nPQtdOp]
			oGetDados:aCols[_x,nPosFlag] := oIn
		Endif

	Next _x

	if ((nRegOk/nToReg)*100) == 0
		@ nLBitm, nPosBitm+2 BITMAP oBitmap10 SIZE 100, 098 OF oDlg FILENAME cPerc00 NOBORDER PIXEL
	Elseif ((nRegOk/nToReg)*100) > 0 .and.((nRegOk/nToReg)*100) < 25
		@ nLBitm, nPosBitm+2 BITMAP oBitmap10 SIZE 100, 098 OF oDlg FILENAME cPerc25 NOBORDER PIXEL
	Elseif ((nRegOk/nToReg)*100) >= 25 .and.((nRegOk/nToReg)*100) < 50
		@ nLBitm, nPosBitm+2 BITMAP oBitmap10 SIZE 100, 098 OF oDlg FILENAME cPerc50 NOBORDER PIXEL
	Elseif ((nRegOk/nToReg)*100) >= 50 .and.((nRegOk/nToReg)*100) < 75
		@ nLBitm, nPosBitm+2 BITMAP oBitmap10 SIZE 100, 098 OF oDlg FILENAME cPerc75 NOBORDER PIXEL
	Elseif ((nRegOk/nToReg)*100) >= 75 .and.((nRegOk/nToReg)*100) < 100
		@ nLBitm, nPosBitm+2 BITMAP oBitmap10 SIZE 100, 098 OF oDlg FILENAME cPerc99 NOBORDER PIXEL
	Elseif ((nRegOk/nToReg)*100) >= 100
		@ nLBitm, nPosBitm+2 BITMAP oBitmap10 SIZE 100, 098 OF oDlg FILENAME cFileOk NOBORDER PIXEL
	Endif


	If nLinha > 0
		if !empty(cCodOP)
			If nQtdProds == 0
				oGetDados2:aCols[nLinha,aScan(oGetDados2:aHeader,{|aVet| AllTrim(aVet[2]) == 'FLAG3'  })] :=  oNo
				cStatus:= '1'
			ElseIf nQtdProds >= 1 .and. nQtdProds < nTotProds
				oGetDados2:aCols[nLinha,aScan(oGetDados2:aHeader,{|aVet| AllTrim(aVet[2]) == 'FLAG3'  })] :=  oIn
				cStatus:= '2'
			ElseIf nQtdProds == nTotProds
				oGetDados2:aCols[nLinha,aScan(oGetDados2:aHeader,{|aVet| AllTrim(aVet[2]) == 'FLAG3'  })] :=  oOk
				cStatus:= '3'
			Endif

			SC2->(dbSetOrder(1))//P10_FILIAL, P10_OP, P10_FIBRA
			SC2->(dbSeek(xFilial("SC2")+cCodOP) )
			Reclock("SC2", .F.)
			SC2->C2_ORDSEP	:= cStatus
			SC2->(MsUnlock())
		Else
			if !lCheckBo1
				MyMsg("Ordem de produ??o n?o est? na lista!" ,1,.T.)
			Endif
		Endif
	Endif
	oGetDados2:Refresh()
Return

//--------------------------------------------------------------
/*/Protheus.doc DOMROT - ROTEIRO DE PRODU??O DOMEX
	Atualiza a tela via refresh tempor?rio
	author: Ricardo Roda
/*/
//--------------------------------------------------------------

Static Function fAtuPgOp()
	Local nPosOP	:= aScan(oGetDados2:aHeader,{|_y| AllTrim(_y[2]) == "OP"  })
	Local nPosQtApon:= aScan(oGetDados2:aHeader,{|_y| AllTrim(_y[2]) == "QTDAPONT"  })
	Local _y:= 0


	For _y := 1 to len(oGetDados2:aCols)
		SC2->(DbSetOrder(1))
		if SC2->(dbSeek(xFilial("SC2")+oGetDados2:aCols[_y,nPosOP]))
			oGetDados2:aCols[_y,nPosQtApon] := SC2->C2_QUJE
			oGetDados2:aCols[Len(oGetDados2:aCols),aScan(oGetDados2:aHeader,{|_y| AllTrim(_y[2]) == 'FLAG2'  })] := iif(SC2->C2_QUJE == 0, oNo,IIF(SC2->C2_QUJE > 0 .and. SC2->C2_QUANT<> SC2->C2_QUJE,oIn,oOK ))
		Endif

	Next _y
	oGetDados2:Refresh()

Return

/*/Protheus.doc fVldXd1St
	description
type function
	version
	author Ricardo Roda
	since 06/08/2020
	param cCodOp, character, param_description
	param cCodPro, character, param_description
return return_type, return_description
/*/
Static function fVldXd1St(cCodOp)
	Local cQuery:=""
	Local lRet:= .T.
	Local nPosComp	:= GdFieldPos( "COMP" )
	//Local nPosGpr	:= GdFieldPos( "GRUPO" )
	Local nPQtdent	:= GdFieldPos( "QTDENT" )
	Local nPQtdOp	:= GdFieldPos( "QTDOP" )
	Local nPosFlag	:= GdFieldPos( "FLAG" )

	If Select("QRY") > 0
		QRY->(DbCloseArea())
	Endif

	cQuery+=" 	SELECT XD1_COD,SUM(XD1_QTDATU) QTDLID "
	cQuery+=" 	FROM "+RETSQLNAME("XD1")+" XD1 "
	cQuery+=" 	WHERE XD1_OP LIKE  '"+AllTrim(cCodOp)+"%' "
	cQuery+=" 	AND XD1_OCORRE = '7'   "
	cQuery+=" 	AND XD1_FILIAL = '"+xFilial("XD1")+"' "
	cQuery+=" 	AND XD1.D_E_L_E_T_ = '' "
	cQuery+=" 	GROUP BY XD1_COD  "

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)

	if QRY->(!Eof())
		WHILE QRY->(!EOF())
			nPos:= aScan(oGetDados:aCols,{|x| AllTrim(x[nPosComp]) == AllTrim(XD1_COD) })

			IF nPos > 0
				oGetDados:aCols[nPos,nPQtdent] := QRY->QTDLID

				if	oGetDados:aCols[nPos,nPQtdent] == oGetDados:aCols[nPos,nPQtdOp]
					oGetDados:aCols[nPos,nPosFlag] := oOk
				Elseif oGetDados:aCols[nPos,nPQtdent] == 0
					oGetDados:aCols[nPos,nPosFlag] := oNo
				Elseif oGetDados:aCols[nPos,nPQtdent] > 0 .and. oGetDados:aCols[nPos,nPQtdent] < oGetDados:aCols[nPos,nPQtdOp]
					oGetDados:aCols[nPos,nPosFlag] := oIn
				Endif
			Endif

			QRY->(DbSkip())
		End
	Endif
	QRY->(DbCloseArea())

	oGetDados:refresh()

Return lRet

