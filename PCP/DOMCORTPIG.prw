#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWBROWSE.CH"

/*/______________________{DOMCORTPIG}_____________________
|---------------------------------------------------------|
Corte PIGTAIL processo produtivo de cabos
author: Ricardo Roda
Data: 20/12/2019
|---------------------------------------------------------|
__________________________________________________________
/*/
User Function DOMCORTPIG()

	Private oApont, oBitmap1, oButton1,oButton2,oButton3,oButton4,oButton5,oCFibra, oCodOP, oCodPA, oEtiq, oLoteCtl, oNFibra, oNomePA, oStatus, oQtdOp, oQtdProd, oQtdRest
	Private oGroup1, oGroup2, oSay1, oSay2, oSay3, oSay4, oSay5, oSay6, oSay7, oSay8, oSay9, oSay10, oSay11, oSay12,oSay13,oSay14,oSay15,oSay16
	Private oQtdTOp, oTamCort, oTamRolo, oQtdAProd, oTotMtrs, oPrevCort, oEmCort, oSButton1,oNomePA2, oResMtrs,oQtdSD3
	Private nQtdOp 		:= 0
	Private nResMtrs	:= 0
	Private nQtdProd 	:= 0
	Private nQtdRest 	:= 0
	Private nQtdSd3		:= 0
	Private nTamCort 	:= 0
	Private nTamRolo 	:= 0
	Private nTotMtrs 	:= 0
	Private nApont 		:= 0
	Private nQtdTOp  	:= 0
	Private nQtdAProd	:= 0
	Private nPrevCort	:= 0
	Private nEmCort		:= 0
	Private nEtqFOFS	:= 0
	Private ENTER		:= CHR(13)+CHR(10)
	private oFont14 	:= TFont():New("Arial",,022,,.F.,,,,,.F.,.F.)
	private oFont16 	:= TFont():New("Arial",,024,,.F.,,,,,.F.,.F.)
	private oFont16AZ	:= TFont():New("Arial",,024,,.F.,,,,,.F.,.F.)
	private oFont18 	:= TFont():New("Arial ",,026,,.F.,,,,,.F.,.F.)
	private oFont20B	:= TFont():New("Arial Black",,026,,.T.,,,,,.F.,.F.)
	private oFont36 	:= TFont():New("Arial Black",,044,,.T.,,,,,.F.,.F.)
	private oFont36AZ	:= TFont():New("Arial Black",,044,,.T.,,,,,.F.,.F.)
	private oFont44B	:= TFont():New("Arial Black",,052,,.T.,,,,,.F.,.F.)
	private oFont96B	:= TFont():New("Arial",,110,,.T.,,,,,.F.,.F.)
	private oFont1 		:= TFont():New("MS Sans Serif",,016,,.F.,,,,,.F.,.F.)
	private cCodOP 		:= SPACE(12)
	private cCodPA 		:= CriaVar("B1_COD")
	private cNomePA 	:= CriaVar("B1_DESC")
	private cNomePA2 	:= CriaVar("B1_DESC")
	Private aFibras	 	:= {}
	Private aEtiqOfc 	:= {}
	private cEtiq 		:= SPACE(15)
	Private cEtiqAtu	:= SPACE(15)
	private cCFibra 	:= CriaVar("B1_COD")
	private cNFibra 	:= CriaVar("B1_DESC")
	private cLoteCtl 	:= CriaVar("B8_LOTECTL")
	private cStatus 	:= ""
	Private cEtiqOfc 	:= SPACE(15)
	Private oLbx
	Private cTeste
	private lEtqval		:= .F.
	Private aLbx 		:= {}
	Private cHrIni		:= ""
	Private cPerg		:= "U_DOMCORTE"
	Private cStartPath	:= GetSrvProfString('Startpath','')
	Private aAux 		:= {LoadBitmap( GetResources(), "BR_VERMELHO"),LoadBitmap( GetResources(), "BR_AMARELO"),LoadBitmap( GetResources(), "BR_VERDE"),LoadBitmap( GetResources(), "BR_PRETO")}
	Private oBitmap10
	Private oBitmapSup
	Private cSuperv		:= ""
	Private oQtVias
	Private nQtVias   	:= 0
	Private cSenhaC 	:= SPACE(20)
	Private cGetSup		:= SPACE(20)
	Private cUserSis	:= Upper(Alltrim(Substr(cUsuario,7,15)))
	Private lAjusteOk 	:= .F.
	Private nQtAjusM 	:= criavar("D3_QUANT")
	Private nCelula		:= 0
	Private oQtAjusM
	Private  oImg
	Private cLocImp		:= ""
	Private aOPs		:= {}
	Private c2Leg1      := "1"
	Private n2Leg1      := RGB(176,224,230)
	Private c2Leg2      := "2"
	Private n2Leg2      := RGB(248,248,255)
	Private oOk      	:= LoadBitmap( GetResources(), "CHECKED" )
	Private oNo      	:= LoadBitmap( GetResources(), "UNCHECKED" )
	Private oXX      	:= LoadBitmap( GetResources(), "NOCHECKED" )
	Private cTmEnt    := GetMV('MV_XTMENT')
	Private cTmSai    := GetMV('MV_XTMSAI')

	cFileErro			:= cStartPath + 'errado.png'
	cFileok				:= cStartPath + 'certo.png'
	cFileLogo			:= cStartPath + 'logo.png'
	cFileAten			:= cStartPath + 'Atencao.png'
	cFileInter			:= cStartPath + 'Interroga.png'
	Static oDlg

	nCelula:= fButtCel()
	cLocImp:= fLocImp(nCelula)

	DEFINE MSDIALOG oDlg TITLE "Corte PIGTAIL" FROM 0, 0  TO 800, 1250 COLORS 0, 16777215 PIXEL
	@ 014, 135 GROUP oGroup1 TO 197,540 OF oDlg COLOR 0, 16777215 PIXEL
	@ 014, 009 GROUP oGroup2 TO 270,130 OF oDlg COLOR 0, 16777215 PIXEL

	@ 015, 139 SAY oSay10 		PROMPT "Ordem de produção" 	SIZE 090, 016 OF oDlg FONT oFont16AZ COLORS 16711680, 16777215 PIXEL
	@ 027, 159 MSGET oCodOP 	VAR cCodOP 					SIZE 070, 016 OF oDlg VALID fVldOp(1) PICTURE "@!" COLORS 16711680, 16777215 FONT oFont16AZ PIXEL //WHen .F.
	@ 027, 139 BUTTON oButton2 	PROMPT "OP"  SIZE 020, 018 OF oDlg ACTION (Processa( {||ftelaOp (nCelula),fVldOp(1)})) FONT oFont14 PIXEL

	@ 015, 230 SAY oSay9 		PROMPT "Prod.Acabado - PA" 	SIZE 120, 016 OF oDlg FONT oFont16 COLORS 0, 16777215 PIXEL
	@ 027, 230 MSGET oCodPA 	VAR cCodPA 					SIZE 120, 016 OF oDlg PICTURE "@!" COLORS 0, 16777215 FONT oFont16 PIXEL WHen .F.
	@ 015, 350 SAY oSay13 		PROMPT "Qtd.PA" 			SIZE 090, 016 OF oDlg FONT oFont16 COLORS 0, 16777215 PIXEL
	@ 027, 350 MSGET oQtdAProd 	VAR nQtdOp  				SIZE 090, 016 OF oDlg PICTURE "@E 9,999" COLORS 0, 16777215 FONT oFont16 PIXEL WHen .F.
	@ 015, 440 SAY oSay13 		PROMPT "Qtd.Paga(SD3)" 		SIZE 070, 010 OF oDlg FONT oFont16 COLORS 0, 16777215 PIXEL
	@ 027, 440 MSGET oQtdSD3 	VAR nQtdSD3 				SIZE 092, 016 OF oDlg PICTURE "@E 9,999" COLORS 0, 16777215 FONT oFont16 PIXEL WHen .F.

	@ 045, 139 SAY  oNomePA 	PROMPT alltrim(Substring(cNomePA,1,33))	SIZE 450, 050 OF oDlg FONT oFont36 COLORS 0, 16777215 PIXEL
	@ 060, 139 SAY oNomePA2 	PROMPT alltrim(Substring(cNomePA,34,33))SIZE 450, 050 OF oDlg FONT oFont36 COLORS 0, 16777215 PIXEL

	@ 088, 139 SAY oSay12   	PROMPT "Etiqueta" 			SIZE 117, 012 OF oDlg FONT oFont16AZ COLORS 16711680, 16777215 PIXEL
	@ 100, 139 MSGET oEtiq 		VAR cEtiqOfc 				SIZE 160, 016 OF oDlg PICTURE "@!" VALID (!Empty(@cCodOP),fVldEti(@cEtiqOfc)) COLORS 16711680, 16777215 FONT oFont16AZ F3 "SB1" PIXEL
	@ 088, 299 SAY oSay7 		PROMPT "Código da Fibra" 	SIZE 142, 014 OF oDlg FONT oFont16 COLORS 0, 16777215 PIXEL
	@ 100, 299 MSGET oCFibra  	VAR cCFibra 				SIZE 146, 016 OF oDlg PICTURE "@!" COLORS 0, 16777215 FONT oFont16 PIXEL WHen .F.
	@ 088, 444 SAY oSay13 		PROMPT "Qtd.Rolo" 			SIZE 070, 010 OF oDlg FONT oFont16 COLORS 0, 16777215 PIXEL
	@ 100, 444 MSGET oTamRolo 	VAR nTamRolo 				SIZE 092, 016 OF oDlg PICTURE "@E 999,999.999" COLORS 0, 16777215 FONT oFont16 PIXEL WHen .F.

	@ 115, 139 SAY oNFibra 		PROMPT alltrim(Substring(cNFibra,01,33)) SIZE 450, 050 OF oDlg FONT oFont36 COLORS 0, 16777215 PIXEL
	@ 131, 139 SAY oNFibra 		PROMPT alltrim(Substring(cNFibra,34,33)) SIZE 450, 050 OF oDlg FONT oFont36 COLORS 0, 16777215 PIXEL

	@ 158, 139 SAY oSay11 		PROMPT "Mtrs. Unidade" 		SIZE 090, 016 OF oDlg FONT oFont16 COLORS 0, 16777215 PIXEL
	@ 168, 139 MSGET oTamCort 	VAR nTamCort 				SIZE 090, 016 OF oDlg PICTURE "@E 999,999.9999" COLORS 0, 16777215 FONT oFont16 PIXEL WHen .F.
	@ 158, 230 SAY oSay13 		PROMPT "Restante Mtrs."    	SIZE 090, 016 OF oDlg FONT oFont16 COLORS 0, 16777215 PIXEL
	@ 168, 230 MSGET oResMtrs 	VAR nResMtrs 				SIZE 090, 016 OF oDlg PICTURE "@E 999,999.9999" COLORS 0, 16777215 FONT oFont16 PIXEL WHen .F.
	@ 158, 320 SAY oSay13 		PROMPT "Total em Mtrs." 	SIZE 090, 016 OF oDlg FONT oFont16 COLORS 0, 16777215 PIXEL
	@ 168, 320 MSGET oTotMTrs 	VAR nTotMtrs 				SIZE 090, 016 OF oDlg PICTURE "@E 999,999.9999" COLORS 0, 16777215 FONT oFont16 PIXEL WHen .F.
	@ 158, 410 SAY oSay16 		PROMPT "Numero de Vias" 	SIZE 090, 016 OF oDlg FONT oFont16 COLORS 0, 16777215 PIXEL
	@ 168, 410 MSGET oQtVias 	VAR nQtVias					SIZE 090, 016 OF oDlg PICTURE "@E 999,999.9999" COLORS 0, 16777215 FONT oFont16 PIXEL WHen .F.


	@ 030, 015 SAY oSay2 		PROMPT "Qtd.Total" 			SIZE 110, 012 OF oDlg FONT oFont16 COLORS 0, 16777215 PIXEL
	@ 040, 015 MSGET oQtdOp 	VAR nQtdOp 					SIZE 110, 025 OF oDlg PICTURE "@E 9,999" COLORS 0, 16777215 FONT oFont36 PIXEL WHen .F.
	@ 070, 015 SAY oSay3 		PROMPT "Qtd.Cortada"		SIZE 110, 012 OF oDlg FONT oFont16 COLORS 0, 16777215 PIXEL
	@ 080, 015 MSGET oQtdProd 	VAR nQtdProd 				SIZE 110, 025 OF oDlg PICTURE "@E 9,999" COLORS 0, 16777215 FONT oFont36 PIXEL WHen .F.
	@ 110, 015 SAY oSay4 		PROMPT "Qtd. Restante" 		SIZE 110, 012 OF oDlg FONT oFont16 COLORS 0, 16777215 PIXEL
	@ 120, 015 MSGET oQtdRest 	VAR nQtdRest 				SIZE 110, 025 OF oDlg PICTURE "@E 9,999" COLORS 0, 16777215 FONT oFont36 PIXEL WHen .F.

	@ 150, 015 SAY oSay14 		PROMPT "Previsão Corte" 	SIZE 110, 012 OF oDlg FONT oFont16 COLORS 0, 16777215 PIXEL
	@ 160, 015 MSGET oPrevCort 	VAR nPrevCort 				SIZE 040, 025 OF oDlg PICTURE "@E 9,999" COLORS 0, 16777215 FONT oFont36 PIXEL
	@ 190, 015 SAY oSay15 		PROMPT "Em Corte"		 	SIZE 110, 012 OF oDlg FONT oFont16 COLORS 0, 16777215 PIXEL
	@ 200, 015 MSGET oEmCort 	VAR nEmCort 				SIZE 040, 025 OF oDlg PICTURE "@E 9,999" COLORS 0, 16777215 FONT oFont36 PIXEL WHen .F.
	@ 230, 015 SAY oSay5 		PROMPT "Corte Concluido" 	SIZE 110, 012 OF oDlg FONT oFont16AZ COLORS 16711680, 16777215 PIXEL
	@ 240, 015 MSGET oApont 	VAR nApont 					SIZE 040, 025 OF oDlg PICTURE "@E 9,999" COLORS 16711680, 16777215 FONT oFont36AZ PIXEL VALID oCFibra:SetFocus()

	@ 115, 545 BUTTON oButton5 	PROMPT "Excluir Etiq." 		SIZE 070, 025 OF oDlg ACTION (fExclEti() ) FONT oFont14 PIXEL
	@ 165, 545 BUTTON oButton1 	PROMPT "Sair" 				SIZE 070, 025 OF oDlg ACTION (cEtiqOfc:="",	oEtiq:Refresh(),  oDlg:End()) FONT oFont16 PIXEL
	@ 160, 095 BUTTON oButton2 	PROMPT "Iniciar" 			SIZE 030, 027 OF oDlg ACTION (fCortIni() ) FONT oFont14 PIXEL
	@ 200, 095 BUTTON oButton4 	PROMPT "Zerar" 				SIZE 030, 027 OF oDlg ACTION (fZera() ) FONT oFont14 PIXEL
	@ 240, 095 BUTTON oButton3 	PROMPT "Concluir" 			SIZE 030, 027 OF oDlg ACTION Processa( {|| (fVldApont(cCodOP), nApont:= 0)}, "Transferência de Saldo","Processando...",,.T.) FONT oFont14 PIXEL


	aHeader := {}
	aCols   := {}
	AADD(aHeader,  {    ""            		,"LEGENDA" 		,"@BMP" 			,01,0,""    ,"","C","","","","",".F."})
	AADD(aHeader,  {    ""			  		,"FLAG"   	   	,"@BMP" 			,01,0,""    ,"","C","","","","",".F."})
	AADD(aHeader,  {    "Nome"       		,"NOMEUSR"  	,"@R" 				,15,0,""    ,"","C","","","","",".T."})
	AADD(aHeader,  {    "Fibra"       		,"FIBRA"   		,"@R" 				,15,0,""    ,"","C","","","","",".T."})
	AADD(aHeader,  {    "Etiqueta"       	,"ETIQ"   		,"@R" 				,15,0,""    ,"","C","","","","",".T."})
	AADD(aHeader,  {    "Qtd.Rolo" 			,"QTDROLO" 		,"@E 999,999" 		,07,0,""    ,"","N","","","","",".T."})
	AADD(aHeader,  {    "Descrição"   		,"DESC"    		,"@R" 				,40,0,""    ,"","C","","","","",".T."})
	AADD(aHeader,  {    "Qtd.Cortado" 		,"QTDUSR"  		,"@E 999,999" 		,07,0,""    ,"","N","","","","",".T."})
	AADD(aHeader,  {    "Qtd.Em Corte" 		,"QEMCRT"  		,"@E 999,999" 		,07,0,""    ,"","N","","","","",".T."})
	AADD(aHeader,  {    "Restante"    		,"QTDRES"  		,"@E 999,999" 		,07,0,""    ,"","N","","","","",".T."})
	AADD(aHeader,  {    "Metros P/Unid." 	,"MTRSUN"  		,"@E 999,999.999" 	,12,0,""    ,"","N","","","","",".T."})
	AADD(aHeader,  {    "Restante Mtrs." 	,"MTRSRES"  	,"@E 999,999.999" 	,12,0,""    ,"","N","","","","",".T."})
	AADD(aHeader,  {    "Qtd.Total "  		,"QTDTOP"  		,"@E 999,999" 		,07,0,""    ,"","N","","","","",".T."})
	AADD(aHeader,  {    "Total Mtrs."    	,"MTRSTOT"  	,"@E 999,999.999" 	,12,0,""    ,"","N","","","","",".T."})
	AADD(aHeader,  {    "Qtd.Cortado Tot." 	,"QTDCOR"  		,"@E 999,999" 		,07,0,""    ,"","N","","","","",".T."})
	AADD(aHeader,  {    "Usuario"    	 	,"USERAP"  		,"@R" 			 	,06,0,""    ,"","C","","","","",".T."})
	AADD(aHeader,  {    ""			    	,"COR"   	   	,"@R" 		  	    ,01,0,""    ,"","C","","","","",".F."})

	oGetDados  := (MsNewGetDados():New( 200, 137 , 380 ,620,NIL ,"AlwaysTrue" ,"AlwaysTrue", /*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,"U_Ffieldok()",/*superdel*/,/*delok*/,oDlg,aHeader,aCols))
	oGetDados:oBrowse:lUseDefaultColors := .F.
	oGetDados:oBrowse:SetBlkBackColor({|| CorGd02(oGetDados:nAt)})

	DEFINE TIMER oTimer INTERVAL 30000 ACTION fAtualiza(oTimer,oGetDados) OF oDlg
	oTimer:Activate()
	ACTIVATE MSDIALOG oDlg CENTERED

Return


/*/______________________{fAtualiza}_____________________
	|---------------------------------------------------------|
	Atualiza a tela via refresh temporário
	author: Ricardo Roda
	Data: 20/12/2019
	|---------------------------------------------------------|
	__________________________________________________________
/*/
Static Function fAtualiza(oTimer,oGetDados)
	oTimer:DeActivate()
	MontaaLbx()
	oTimer:Activate()
Return


/*/________________________{fVldOp}_______________________
	|---------------------------------------------------------|
	Corte PIGTAIL processo produtivo de cabos
	author: Ricardo Roda
	Data: 20/12/2019
	|---------------------------------------------------------|
	__________________________________________________________
/*/
Static Function fVldOp(nOpc)
	Local cQuery:= ""
	Local lRet:= .F.
	Local nQtTotOP:= 0


	If nOpc == 1

		nQtdOp   := 0
		nResMtrs := 0
		nQtdProd := 0
		nQtdRest := 0
		nQtdSd3  := 0
		nTamCort := 0
		nTamRolo := 0
		nTotMtrs := 0
		nApont 	:= 0
		nQtdTOp  := 0
		nQtdAProd:= 0
		nPrevCort:= 0
		nEmCort	:= 0
		cCodPA   := CriaVar("B1_COD")
		cNomePA  := CriaVar("B1_DESC")
		cNomePA2 := CriaVar("B1_DESC")
		cEtiq    := SPACE(15)
		cEtiqAtu := SPACE(15)
		cCFibra  := CriaVar("B1_COD")
		cNFibra  := CriaVar("B1_DESC")
		cLoteCtl := CriaVar("B8_LOTECTL")
		cStatus  := ""
		cEtiqOfc := SPACE(15)
		lEtqval := .F.

		oApont:Refresh()
		oCFibra:Refresh()
		oCodPA:Refresh()
		oEtiq:Refresh()
		oNFibra:Refresh()
		oNomePA:Refresh()
		oQtdOp:Refresh()
		oQtdProd:Refresh()
		oQtdRest:Refresh()
		oTamCort:Refresh()
		oTamRolo:Refresh()
		oQtdAProd:Refresh()
		oTotMtrs:Refresh()
		oPrevCort:Refresh()
		oEmCort:Refresh()
		oNomePA2:Refresh()
		oResMtrs:Refresh()
		oQtdSD3:Refresh()

		MontaaLbx()
	Endif

	if Empty(Alltrim(cCodOp))
		Return .T.//.F.
	Endif

	If SELECT("QRY") > 0
		QRY->(dbCloseArea())
	Endif

	If SELECT("QRY2") > 0
		QRY2->(dbCloseArea())
	Endif

	dbSelectArea("SC2")
	SC2->(dbSetOrder(1))
	if SC2->(dbSeek(xFilial("SC2")+cCodOp))
		IF !EMPTY(SC2->C2_DATRF)
			MyMsg("Ordem de produção encerrada!" ,1)
			LimpaTudo()
			Return .F.
		Endif

		SB1->(DbSetOrder(1))
		IF SB1->(DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
			IF alltrim(SB1->B1_SUBCLAS) <> 'KIT PIGT'
				MyMsg("Essa ordem de produção pertence a 'CORD'..."+ Chr(13)+Chr(10)+"Entre pela rotina Corte Fibra"  ,1)
				LimpaTudo()
				Return .F.
			Endif

		ENDIF

		IF !fAnaliPg()
			LimpaTudo()
			Return .F.
		Endif
		cCodPA:= SC2->C2_PRODUTO
		nQtdOp:= ROUND(SC2->C2_QUANT,4)

		dbSelectArea("SB1")
		SB1->(dbSetOrder(1))

		if SB1->(dbseek(xFilial("SB1")+alltrim(cCodPA)))
			cNomePA:= SB1->B1_DESC

			cQuery:= " SELECT * FROM "+RETSQLNAME("SD4")+" SD4"
			cQuery+= " INNER JOIN "+RETSQLNAME("SB1")+" SB1 ON B1_COD = D4_COD AND SB1.D_E_L_E_T_ = '' "
			cQuery+= " AND B1_GRUPO IN ('FO','FOFS') "
			cQuery+= " AND B1_FILIAL = '"+xFilial("SB1")+"' "
			cQuery+= " WHERE D4_OP = '"+cCodOP+"' "
			cQuery+= " AND D4_QTDEORI > 0 "
			cQuery+= " AND D4_FILIAL = '"+xFilial("SD4")+"' "
			cQuery+= " AND SD4.D_E_L_E_T_ = '' "

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)

			While QRY->(!eof())

				DbSelectArea("SG1")
				SG1->(DbSetOrder(2))
				SG1->(DbSeek(xFilial("SG1")+QRY->D4_PRODUTO))

				If SG1->G1_XQTDVIA > 0
					nQtVias:= SG1->G1_XQTDVIA
				Else
					nQtVias:=1
				Endif

				dbSelectArea("ZZ4")
				dbSetOrder(2)
				if !ZZ4->(dbSeek(xFilial("ZZ4")+Alltrim(QRY->D4_OP)+QRY->D4_COD+__cUserId))
					ZZ4->(RecLock("ZZ4",.T.))
					ZZ4->ZZ4_FILIAL	 := xFilial("ZZ4")
					ZZ4->ZZ4_OP		 := QRY->D4_OP
					ZZ4->ZZ4_PROD	 := QRY->D4_COD
					ZZ4->ZZ4_QTCORT  := 0

					IF nQtVias == 1
						ZZ4->ZZ4_QTDORI  := nQtdOp
					Else
						ZZ4->ZZ4_QTDORI  := nQtdOp * nQtVias
					Endif

					ZZ4->ZZ4_QTDMTR  := ROUND(QRY->D4_QTDEORI,4)
					ZZ4->ZZ4_STATUS	 := "1"
					ZZ4->ZZ4_USER	 := __cUserId
					ZZ4->ZZ4_QTDUSR  := 0
					ZZ4->(MsUnlock())
				Endif

				dbSelectArea("ZZ4")
				ZZ4->(DbSetOrder(1))
				IF ZZ4->(dbSeek(xFilial("ZZ4")+alltrim(cCodOp)+alltrim(cCFibra)))
					nQtdSD3:= fQtdSD3((ZZ4->ZZ4_QTDMTR/ZZ4->ZZ4_QTDORI),alltrim(cCFibra))
					nQtdOp:= ZZ4->ZZ4_QTDORI
				Endif

				if QRY->D4_QTDEORI > 0
					nQtTotOP+= QRY->D4_QTDEORI
				Endif
				QRY->(DbSkip())

			EndDo
			QRY->(dbCloseArea())

			lRet:= MontaaLbx()

		Else
			MyMsg("Produto não encontrado!",1)
		Endif


	Else
		MyMsg("Ordem de produção "+Alltrim(cCodOP)+" não encontrada!", 1)
		cCodOP:= Space(12)
		LimpaTudo()
		Return .F.
	Endif

Return lRet


/*/______________________{MontaaLbx}_____________________
	|---------------------------------------------------------|
	author: Ricardo Roda
	Data: 20/12/2019
	|---------------------------------------------------------|
	__________________________________________________________
/*/
Static Function MontaaLbx()
	Local cQuery:= ""
	Local lRet:= .F.
	Local nPosCor	:= GdFieldPos( "COR" )
	Local nPosFlag	:= GdFieldPos( "FLAG" )
	Local _i

//nPEtiq  := aScan(aHeader,{|aVet| Alltrim(aVet[2]) == "ETIQ"})
/*IF  aScan(oGetDados:aCols,{|x| Alltrim(x[nPEtiq]) == "" }) > 0
cStatus := "XX"
cEtiq := SPACE(15)
cCFibra := CriaVar("B1_COD")
cNFibra := CriaVar("B1_DESC")
cLoteCtl := CriaVar("B8_LOTECTL")
lEtqval:= .F.
Endif
*/
	cQuery:= " SELECT ZZ4_OP,ZZ4_PROD,ZZ4_QTDORI,ZZ4_QTCORT,ZZ4_QTDMTR,ZZ4_STATUS,ZZ4_QEMCRT, ZZ4_USER , B1_DESC,ZZ4_ETIQ, ZZ4_QTDETI"

	cQuery+= " ,ISNULL((SELECT SUM(ZZ4_QTDUSR) "
	cQuery+= " FROM "+RETSQLNAME("ZZ4")+" ZZ4B"
	cQuery+= " WHERE ZZ4_OP = '"+cCodOP+"' "
	cQuery+= " AND ZZ4_FILIAL = '"+xFilial("ZZ4")+"' "
	cQuery+= " AND ZZ4B.D_E_L_E_T_ = '' "
	cQuery+= " AND ZZ4B.ZZ4_PROD = ZZ4.ZZ4_PROD"

// TRATAMENTO TEMPORÁRIO PARA NÃO ACEITAR APONTAMENTOS DO CORTE NORMAL
	cQuery+= " AND ZZ4B.ZZ4_LOCAL =  '' "
//FIM DO TRATAMENTO

	cQuery+= " AND ZZ4_USER = '"+__cUserId+"'  ),0) AS ZZ4_QTDUSR"

	cQuery+= " FROM "+RETSQLNAME("ZZ4")+" ZZ4"
	cQuery+= " INNER JOIN "+RETSQLNAME("SB1")+" SB1 ON B1_COD = ZZ4_PROD  AND SB1.D_E_L_E_T_ = '' "
	cQuery+= " AND B1_FILIAL = '"+xFilial("SB1")+"' "
	cQuery+= " WHERE ZZ4_OP = '"+cCodOP+"' "
	cQuery+= " AND ZZ4_FILIAL = '"+xFilial("ZZ4")+"' "
	cQuery+= " AND ZZ4.D_E_L_E_T_ = '' "
	cQuery+= " AND ZZ4_USER = '"+__cUserId+"' "

// TRATAMENTO TEMPORÁRIO PARA NÃO ACEITAR APONTAMENTOS DO CORTE NORMAL
	cQuery+= " AND ZZ4.ZZ4_LOCAL =  '' "
//FIM DO TRATAMENTO

	cQuery+= " ORDER BY 8,2 "

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY2",.T.,.T.)

	oGetDados:aCols := {}

	If !QRY2->(eof())
		While QRY2->(!eof())


			AADD(oGetDados:aCols,Array(Len(oGetDados:aHeader)+1))
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'FLAG'    })] := IIf(!EMPTY(ALLTRIM(QRY2->ZZ4_ETIQ)).AND.QRY2->ZZ4_QTDETI > 0,oOk, IIF(!EMPTY(ALLTRIM(QRY2->ZZ4_ETIQ)).AND.QRY2->ZZ4_QTDETI <= 0,oXX,oNo))
			//oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'FLAG'    })] := If(!EMPTY(ALLTRIM(QRY2->ZZ4_ETIQ)),oOk,oNo)
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'LEGENDA' })] := If(QRY2->ZZ4_STATUS == '1' ,"BR_VERMELHO",If(QRY2->ZZ4_STATUS == '2',"BR_AMARELO","BR_VERDE"))
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'NOMEUSR' })] := UsrFullName ( ALLTRIM(QRY2->ZZ4_USER) )
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'FIBRA'   })] := QRY2->ZZ4_PROD
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'ETIQ'    })] := QRY2->ZZ4_ETIQ
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'QTDROLO' })] := QRY2->ZZ4_QTDETI
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'DESC'    })] := QRY2->B1_DESC
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'QTDUSR'  })] := QRY2->ZZ4_QTDUSR
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'QEMCRT'  })] := QRY2->ZZ4_QEMCRT
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'QTDTOP'  })] := QRY2->ZZ4_QTDORI
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'QTDRES'  })] := (QRY2->ZZ4_QTDORI - QRY2->ZZ4_QTCORT)
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'MTRSUN'  })] := (QRY2->ZZ4_QTDMTR/QRY2->ZZ4_QTDORI)
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'MTRSRES' })] := ((QRY2->ZZ4_QTDMTR/QRY2->ZZ4_QTDORI) * (QRY2->ZZ4_QTDORI - QRY2->ZZ4_QTCORT))
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'QTDCOR'  })] := QRY2->ZZ4_QTCORT
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'MTRSTOT' })] := QRY2->ZZ4_QTDMTR
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'USERAP'  })]  := QRY2->ZZ4_USER

			oGetDados:aCols[Len(oGetDados:aCols),Len(oGetDados:aHeader)+1 ] := .F.
			QRY2->(DbSkip())
		EndDo
		lRet:= .T.
	Else
		AADD(oGetDados:aCols,Array(Len(oGetDados:aHeader)+1))
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'FLAG'    })] := oNo
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'LEGENDA' })] := ""
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'NOMEUSR' })] := ""
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'FIBRA'   })] := ""
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'ETIQ'    })] := ""
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'QTDROLO' })] := 0
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'DESC'    })] := ""
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'QTDUSR'  })] := 0
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'QEMCRT'  })] := 0
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'QTDTOP'  })] := 0
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'QTDRES'  })] := 0
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'MTRSUN'  })] := 0
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'MTRSRES' })] := 0
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'QTDCOR'  })] := 0
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'MTRSTOT' })] := 0
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'USERAP'  })]  := ""
		oGetDados:aCols[Len(oGetDados:aCols),Len(oGetDados:aHeader)+1 ] := .F.
		lRet:= .f.
	EndIf


	For _i := 1 To Len(oGetDados:Acols)
		IF oGetDados:aCols[_i,nPosFlag] == oOk
			oGetDados:aCols[_i,nPosCor]:= "1"
		Elseif oGetDados:aCols[_i,nPosFlag]== oNo
			oGetDados:aCols[_i,nPosCor]:= "2"
		Endif
	Next _i

	oGetDados:Refresh()

	QRY2->(dbCloseArea())



Return lRet

/*/________________________{fVldEti}______________________
	|---------------------------------------------------------|
	author: Ricardo Roda
	Data: 20/12/2019
	|---------------------------------------------------------|
	__________________________________________________________
/*/
Static Function fVldEti(cEtiqOfc)
	Local cLocTemp   := "01CORTE"
	Local nPosFlag	:= GdFieldPos( "FLAG" )
//Local nPosFibra	:= GdFieldPos( "FIBRA" )
	Local lRet:= .T.
	Local _i
	if Empty(Alltrim(cEtiqOfc))
		Return .T.
	Endif

	cEtiq:= "0"+Subs(cEtiqOfc,1,11)

	if  Alltrim(cEtiq) <> Alltrim(cEtiqAtu) .AND. lEtqval
		cEtiqAtu:= cEtiq
		lEtqval:= .F.
	Endif


	cCFibra:= ""
	dbSelectArea("XD1")
	XD1->(dbsetorder(1))
	if XD1->(dbseek(xFilial("XD1")+cEtiq))

		If alltrim(XD1->XD1_LOCALI) <> cLocTemp
			MyMsg("Etiqueta não transferida para produção "+ cLocTemp ,1)
			@ 023, 540 BITMAP oBitmap10 SIZE 100, 098 OF oDlg FILENAME cFileErro NOBORDER PIXEL
			cStatus := "XX"
			cEtiq := SPACE(15)
			cEtiqOfc := SPACE(15)
			cCFibra := CriaVar("B1_COD")
			cNFibra := CriaVar("B1_DESC")
			cLoteCtl := CriaVar("B8_LOTECTL")
			lEtqval:= .F.
			oEtiq:Refresh()
			oTamRolo:Refresh()
			Return .F.
		ElseIf XD1->XD1_QTDATU <= 0
			MyMsg("Etiqueta sem saldo!",1)
			@ 023, 540 BITMAP oBitmap10 SIZE 100, 098 OF oDlg FILENAME cFileErro NOBORDER PIXEL
			cStatus := "XX"
			cEtiq := SPACE(15)
			cEtiqOfc := SPACE(15)
			cCFibra := CriaVar("B1_COD")
			cNFibra := CriaVar("B1_DESC")
			cLoteCtl := CriaVar("B8_LOTECTL")
			lEtqval:= .F.
			oEtiq:Refresh()
			oTamRolo:Refresh()
			Return .F.
		Else
			cCFibra  := Alltrim(XD1->XD1_COD)
			nTamRolo := XD1->XD1_QTDATU
			cLoteCtl := Alltrim(XD1->XD1_LOTECT)


			ZZ4->(DbSetOrder(2))
			IF ZZ4->(dbSeek(xFilial("ZZ4")+alltrim(cCodOp)+PADR(alltrim(cCFibra),15)+__cUserId))
				// if !EMPTY(ZZ4->ZZ4_ETIQ)
				// 	If alltrim(ZZ4->ZZ4_ETIQ) <> alltrim(cEtiqOfc)
				// 		If MyMsg("É o final do rolo "+ZZ4->ZZ4_ETIQ,2)
				// 			AjustSup(ZZ4->ZZ4_PROD,cValtoChar(ZZ4->ZZ4_QTDETI),ZZ4->ZZ4_QTDETI,cNFibra,ZZ4->ZZ4_ETIQ,"S" )
				// 			if lAjusteOk
				// 				lFimRolo:= .T.

				// 				dbSelectArea("XD1")
				// 				XD1->(dbsetorder(1))
				// 				if dbseek(xFilial("XD1")+"0"+SUBSTRING(ZZ4->ZZ4_ETIQ,1,11))
				// 					cProduto   := XD1->XD1_COD 					    //-- Codigo do Produto Origem    - Obrigatorio
				// 					cLocOrig   := XD1->XD1_LOCAL			   	    //-- Almox Origem                - Obrigatorio
				// 					cLocDest   := "97"   					   	    //-- Almox Destino               - Obrigatorio
				// 					cDocumento := U_NEXTDOC()      		    		//-- Documento                   - Obrigatorio
				// 					cNumLote   := "" 						       	//-- Sub-Lote                    - Obrigatorio se usa Rastro "S"
				// 					cLoteCtl   := Alltrim(XD1->XD1_LOTECT)		    //-- Lote                        - Obrigatorio se usa Rastro
				// 					nQtde	   := XD1->XD1_QTDATU
				// 					dDtValid   := fBuscaLote(cProduto,cLoteCtl,cLocOrig)
				// 					cEndOrig   := Alltrim(XD1->XD1_LOCALI)		   //-- Localizacao Origem
				// 					cEndDest   := "97PROCESSO     " 						   //-- Endereco Destino            - Obrigatorio p/a Transferencia
				// 					cEtiqueta  := XD1->XD1_XXPECA

				// 					if fAjusSld(cTmSai,cProduto,nQtde, cLocOrig,cEndOrig,cDocumento,cLoteCtl,dDtValid,cEtiqueta)
				// 						//Zera Etiqueta
				// 						Reclock("XD1", .F.)
				// 						XD1->XD1_QTDATU := 0
				// 						XD1->XD1_OCORRE := '5'
				// 						XD1->(MsUnlock())
				// 					else
				// 						MYMSG("O Rolo 0"+SUBSTRING(ZZ4->ZZ4_ETIQ,1,11) +", não foi zerado! Procure o administrador do sistema ",1)
				// 					Endif
				// 				else
				// 					MYMSG("Etiqueta "+"0"+SUBSTRING(ZZ4->ZZ4_ETIQ,1,11) +", não identificada! ",1)
				// 				EndIf
				// 			Else
				// 				MYMSG("A Liberação da Supervisão foi recusada e por isso o ajute do rolo não será realizado!",1)
				// 				lFimRolo:= .F.
				// 			Endif
				// 		endif
				// 	Endif
				// Endif

				//ALTERAÇÃO PARA ACEITAR SOMENTE 6 FIBRAS

				nQtdRols := 0
				For _i := 1 To Len(oGetDados:Acols)
					IF oGetDados:aCols[_i,nPosFlag] == oOK
						nQtdRols += 1
					Endif
				Next _i

				if nQtdRols == 12
					nPrevCort:= Posicione("SB1",1, xFilial("SB1")+cCFibra,"B1_XLOTPAD")

				else
					lRet := .F.
					oEtiq:Setfocus()
				Endif

			/*/if nQtdRols >= 12 .and. oGetDados:aCols[aScan(oGetDados:acols,{|aVet| Alltrim(aVet[nPosFibra]) == alltrim(cCFibra) }),nPosFlag] == oNo
				IF MyMsg ("A Fibra da etiqueta lida e diferente do grupo das 12 fibras em corte!"+Enter+"deseja iniciar o 2º grupo de fibras?",2)
					ZZ4->(dbSetOrder(2))
					ZZ4->(dbSeek(xFilial("ZZ4")+Alltrim(cCodOp)))
					WHILE ZZ4->(!EOF()) .AND. Alltrim(ZZ4->ZZ4_OP) == Alltrim(cCodOp)
						ZZ4->(RecLock("ZZ4",.F.))
						ZZ4->ZZ4_ETIQ:= ""
						ZZ4->ZZ4_QTDETI:= 0
						ZZ4->ZZ4_QEMCRT:= 0
						ZZ4->(MsUnlock())
						ZZ4->(dbSkip())
					END
					ZZ4->(DbSetOrder(2))
					IF ZZ4->(dbSeek(xFilial("ZZ4")+alltrim(cCodOp)+PADR(alltrim(cCFibra),15)+__cUserId))
						nQtdSD3:= fQtdSD3((ZZ4->ZZ4_QTDMTR/ZZ4->ZZ4_QTDORI),alltrim(cCFibra))
						ZZ4->(RecLock("ZZ4",.F.))
						ZZ4->ZZ4_ETIQ:= cEtiqOfc
						ZZ4->ZZ4_QTDETI:= nTamRolo
						ZZ4->(MsUnlock())
					Endif

					lRet := .F.
					oEtiq:Setfocus()
				Else
					lRet := .F.
					oEtiq:Setfocus()
				ENDIF

				// FIM DA ALTERAÇÃO
			Else*/
				ZZ4->(DbSetOrder(2))
				IF ZZ4->(dbSeek(xFilial("ZZ4")+alltrim(cCodOp)+PADR(alltrim(cCFibra),15)+__cUserId))
					nQtdSD3:= fQtdSD3((ZZ4->ZZ4_QTDMTR/ZZ4->ZZ4_QTDORI),alltrim(cCFibra))
					ZZ4->(RecLock("ZZ4",.F.))
					ZZ4->ZZ4_ETIQ:= cEtiqOfc
					ZZ4->ZZ4_QTDETI:= nTamRolo
					ZZ4->(MsUnlock())
				Endif
				//Endif
			Endif
			MontaaLbx()
		Endif
	Else
		MyMsg("Etiqueta Invalida!",1)
		cStatus := "XX"
		@ 023, 540 BITMAP oBitmap10 SIZE 100, 098 OF oDlg FILENAME cFileErro NOBORDER PIXEL
		cStatus := "XX"
		cEtiq := SPACE(15)
		cEtiqOfc := SPACE(15)
		cCFibra := CriaVar("B1_COD")
		cNFibra := CriaVar("B1_DESC")
		cLoteCtl := CriaVar("B8_LOTECTL")
		lEtqval:= .F.
		oEtiq:Refresh()
		oTamRolo:Refresh()
		Return .F.
	Endif

	dbSelectArea("SB1")
	dbsetorder(1)
	if dbseek(xFilial("SB1")+cCFibra)
		cCFibra := SB1->B1_COD
		cNFibra := SB1->B1_DESC

		//AJUSTA O SALDO APONTADO NA SD3
		nPfibra := aScan(aHeader,{|aVet| Alltrim(aVet[2]) == "FIBRA"})
		nPID    := aScan(aHeader,{|aVet| Alltrim(aVet[2]) == "USERAP"})
		nPos := aScan(oGetDados:aCols,{|x| Alltrim(x[nPfibra]) == alltrim(cCFibra) .and. alltrim(x[nPID]) == Alltrim(__cUserId) })

		///  varrer o acols somando as quantidades por usuários
		If nPos > 0
			nQtdOp	:= oGetDados:aCols[nPos,ascan(aHeader,{|x| alltrim(x[2])=="QTDTOP"})]
			nQtdProd:= oGetDados:aCols[nPos,ascan(aHeader,{|x| alltrim(x[2])=="QTDCOR"})]
			nEmCort:= oGetDados:aCols[nPos,ascan(aHeader,{|x| alltrim(x[2])=="QEMCRT"})]
			oGetDados:aCols[nPos,ascan(aHeader,{|x| alltrim(x[2])=="QTDRES"})]:= (nQtdOp - nQtdProd)
			nQtdRest:= oGetDados:aCols[nPos,ascan(aHeader,{|x| alltrim(x[2])=="QTDRES"})]
			nTamCort:= oGetDados:aCols[nPos,ascan(aHeader,{|x| alltrim(x[2])=="MTRSUN"})]
			oGetDados:aCols[nPos,ascan(aHeader,{|x| alltrim(x[2])=="MTRSRES"})]:= ((nQtdOp - nQtdProd)*nTamCort)
			nResMtrs := oGetDados:aCols[nPos,ascan(aHeader,{|x| alltrim(x[2])=="MTRSRES"})]
			nTotMtrs:= oGetDados:aCols[nPos,ascan(aHeader,{|x| alltrim(x[2])=="MTRSTOT"})]

			@ 023, 540 BITMAP oBitmap10 SIZE 100, 098 OF oDlg FILENAME cFileOk NOBORDER PIXEL
			cStatus := "OK"
			cEtiqAtu:= cEtiq
			lEtqval:= .T.

		Else
			MyMsg("Produto não encontrado na ordem de produção. Verifique!",1 )
			@ 023, 540 BITMAP oBitmap10 SIZE 100, 098 OF oDlg FILENAME cFileErro NOBORDER PIXEL
			cStatus := "XX"
			cEtiq := SPACE(15)
			cCFibra := CriaVar("B1_COD")
			cNFibra := CriaVar("B1_DESC")
			cNFibra2 := CriaVar("B1_DESC")
			cLoteCtl := CriaVar("B8_LOTECTL")
			nPrevCort:= 0
			nEmCort:= 0
			nTamRolo:= 0
			lEtqval:= .F.
			Return .F.
		Endif
	Else
		MyMsg("Produto não encontrado no cadastro!",1)
		@ 023, 540 BITMAP oBitmap10 SIZE 100, 098 OF oDlg FILENAME cFileErro NOBORDER PIXEL
		cStatus := "XX"
		cEtiq := SPACE(15)
		cCFibra := CriaVar("B1_COD")
		cNFibra := CriaVar("B1_DESC")
		cLoteCtl := CriaVar("B8_LOTECTL")
		lEtqval:= .F.
		Return .F.
	Endif


	If nQtdRols == 12
		cEtiqOfc:= SPACE(15)
		oEtiq:Refresh()
	Endif

	oQtdOp:Refresh()
	oQtdProd:Refresh()
	oQtdRest:Refresh()
	oTamRolo:Refresh()
	oApont:Refresh()
	oPrevCort:Refresh()
	oEmCort:Refresh()
	oQtdSD3:Refresh()
	oGetDados:Refresh()


Return lRet


/*/______________________{}_____________________
	|---------------------------------------------------------|
	author: Ricardo Roda
	Data: 20/12/2019
	|---------------------------------------------------------|
	__________________________________________________________
/*/
Static Function fVldApont(cCodOp)
	Local nTransf:= 0
	Local lImpEti:= .F.
	Local nQtLbSup:= SuperGetMv("MV_XQTLSUP",.F.,0)
	Local nPosFlag	:= GdFieldPos( "FLAG" )
	Local nPosFibra	:= GdFieldPos( "FIBRA" )
	Local nPosQtRes	:= GdFieldPos( "QTDRES" )
	Local nPosEtiq	:= GdFieldPos( "ETIQ" )
	Local nPosQtRol	:= GdFieldPos( "QTDROLO" )
	Local nPosDesc	:= GdFieldPos( "DESC" )
	Local oFont4c := TFont():New("Arial",,028,,.T.,,,,,.F.,.F.)
	Local lEtiq1	:= .T.
	Local aDados:={}
	Local _i
	Local _x
	Local _y
	Local _j
	Local _z
	Local lZera:= .F.

	For _i := 1 To Len(oGetDados:Acols)
		IF oGetDados:aCols[_i,nPosFlag] == oOK
			AADD(aDados,{;
				oGetDados:aCols[_i,nPosFibra],;
				oGetDados:aCols[_i,nPosEtiq],;
				oGetDados:aCols[_i,nPosQtRes],;
				oGetDados:aCols[_i,nPosQtRol],;
				oGetDados:aCols[_i,nPosDesc],;
				"" })
		Endif
	Next _i


	BEGIN TRANSACTION


		For _j := 1 to len(aDados)
			cCFibra	:= aDados[_j,1]
			cEtiq	:= aDados[_j,2]
			cEtiqOfc:= aDados[_j,2]
			nTamRolo:= aDados[_j,4]

			dbSelectArea("ZZ4")
			ZZ4->(dbSetOrder(2))
			if ZZ4->(dbSeek(xFilial("ZZ4")+Alltrim(cCodOp)+PADR(alltrim(cCFibra),15)+__cUserId))

				nTamCort:= ZZ4->ZZ4_QTDMTR/ZZ4->ZZ4_QTDORI
				If (nApont > ZZ4->ZZ4_QEMCRT )
					MyMsg("Quantidade apontada excede a quantidade em Corte.",1)
					nApont:=0
					DisarmTransaction()
					Break
					Return
				Endif

				If ((ZZ4->ZZ4_QTCORT + nApont)>ZZ4->ZZ4_QTDORI )
					MyMsg("Quantidade apontada excede o empenho.",1)
					nApont:=0
					DisarmTransaction()
					Break
					Return
				Endif

				If ((ZZ4->ZZ4_QTCORT + nApont)<= ZZ4->ZZ4_QTDORI )
					If  nTamRolo - (nApont * nTamCort) < 0
						If MyMsg ("Quantidade apontada excede a quantidade do Rolo!"+Enter+"Confirma o apontamento?",2)
							nQtAjusM:= Criavar("D3_QUANT")
							//*****   Tela liberação supervisor   ***
							IF ((nApont * nTamCort) - nTamRolo) <  nQtLbSup
								_lcontinua:= .T.
							Else
								AjustSup(cCFibra,cValtoChar(nTamRolo),(nApont * nTamCort),cNFibra,cEtiqOfc,"G" )
								if lAjusteOk
									_lcontinua:= .T.
								Else
									MYMSG("A Liberação da Gerência foi recusada e por isso o apontamento não será realizado!",1)
									_lcontinua:= .F.
								Endif
							Endif

							If _lContinua
								ZZ4->(RecLock("ZZ4",.F.))
								ZZ4->ZZ4_QTCORT += nApont
								ZZ4->ZZ4_QEMCRT -= nApont
								ZZ4->ZZ4_STATUS := "2"
								ZZ4->ZZ4_QTDUSR += nApont
								ZZ4->( MsUnlock() )

								dbSelectArea("ZZ4")
								ZZ4->(DbSetOrder(1))
								IF ZZ4->(dbSeek(xFilial("ZZ4")+alltrim(cCodOp)+alltrim(cCFibra)))
									nQtdSD3:= fQtdSD3((ZZ4->ZZ4_QTDMTR/ZZ4->ZZ4_QTDORI),alltrim(cCFibra))
								Endif


								nTamRolo := nTamRolo - (nApont * nTamCort)

								//*****    Lógica do fim de rolo    ***
								nTransf  := (nApont * ZZ4->ZZ4_QTDMTR/ZZ4->ZZ4_QTDORI)


								//2) Verificar rolo  e transferir quantidade apontada
								lImpEti := fTrfRolo(cCFibra,nTransf,cEtiq)

								// ALTERAÇÃO PARA IMPRIMIR APENAS QUANDO O APONTAMENTO FOR DA PRIMEIRA LINHA DA GETDADOS
								lEtiq1:= .T.
								IF lImpEti
									IF aScan(ogetdados:aCols,{ |x| x[GdFieldPos("FIBRA")] == cCFibra}) < 12  //.AND. Posicione("SB1",1, xFilial("SB1")+cCFibra,"B1_GRUPO")<> "FOFS"
										lEtiq1:= .F.
									Endif
								else
									DisarmTransaction()
									Break
									Return
								Endif

								//) imprimir etiquetas
								if lEtiq1
									DbSelectArea("SC2")
									DbSetOrder(1)
									dbSeek(xFilial("SC2")+cCodOP)

									//Coleta o ultimo serial e incrementa o apontamento
									_cNumSerie:= VAL(SC2->C2_XXSERIA)+ 1
									Reclock("SC2", .F.)
									//SC2->C2_XSERIAL := C2->C2_XSERIAL + nApont
									SC2->C2_XXSERIA := CVALTOCHAR(VAL(SC2->C2_XXSERIA) + nApont)
									SC2->(MsUnlock())

									_cProxNiv    := '1'
									_aQtdBip     := {}
									_lImpressao  := .T.
									_nPesoBip    := 0
									_lColetor    := .F.


									U_DOMETI01(cCodOP,nApont,_cNumSerie,cLocImp)

									_cPrxDoc:= fPrxDoc()
									For _x := 1 to nApont
										Reclock("XD4", .T.)
										XD4->XD4_FILIAL	:= xFilial("XD4")
										XD4->XD4_SERIAL	:= _cNumSerie
										XD4->XD4_STATUS	:= '6'
										XD4->XD4_OP	   	:= cCodOP
										XD4->XD4_NOMUSR	:= cUserSis
										XD4->XD4_DOC    := _cPrxDoc
										XD4->XD4_KEY 	:= "S"+Alltrim(cCodOP)+Alltrim(cvaltochar(_cNumSerie))
										XD4->(MsUnlock())
										_cNumSerie += 1
									Next _x
								Endif

							Else
								DisarmTransaction()
								Break
								nApont:=0
								Return
							Endif

						Else
							DisarmTransaction()
							Break
							nApont:=0
							Return
						Endif
					ElseIf  nTamRolo - (nApont * nTamCort) >= 0
						ZZ4->(RecLock("ZZ4",.F.))
						ZZ4->ZZ4_QTCORT += nApont
						ZZ4->ZZ4_QEMCRT := 0
						ZZ4->ZZ4_STATUS	:= "2"
						ZZ4->ZZ4_QTDUSR += nApont
						ZZ4->(MsUnlock())

						dbSelectArea("ZZ4")
						ZZ4->(DbSetOrder(1))
						IF ZZ4->(dbSeek(xFilial("ZZ4")+alltrim(cCodOp)+alltrim(cCFibra)))
							nQtdSD3:= fQtdSD3((ZZ4->ZZ4_QTDMTR/ZZ4->ZZ4_QTDORI),alltrim(cCFibra))
						Endif

						nTamRolo := nTamRolo - (nApont * nTamCort)
						nTransf  := (nApont * ZZ4->ZZ4_QTDMTR/ZZ4->ZZ4_QTDORI)


						//2) Verificar rolo  e transferir quantidade apontada
						lImpEti := fTrfRolo(cCFibra,nTransf,cEtiq)


						// ALTERAÇÃO PARA IMPRIMIR APENAS QUANDO O APONTAMENTO FOR DA PRIMEIRA LINHA DA GETDADOS
						lEtiq1:= .T.
						IF lImpEti
							IF aScan(ogetdados:aCols,{ |x| x[GdFieldPos("FIBRA")] == cCFibra}) < 12 //.AND. Posicione("SB1",1, xFilial("SB1")+cCFibra,"B1_GRUPO")<> "FOFS"
								lEtiQ1:= .F.
							Endif
						else
							DisarmTransaction()
							Break
							Return

						Endif


						//3) imprimir etiquetas
						if lEtiQ1

							DbSelectArea("SC2")
							DbSetOrder(1)
							dbSeek(xFilial("SC2")+cCodOP)

							//Coleta o ultimo serial e incrementa o apontamento
							_cNumSerie:= VAL(SC2->C2_XXSERIA)+ 1
							Reclock("SC2", .F.)
							//SC2->C2_XSERIAL := C2->C2_XSERIAL + nApont
							SC2->C2_XXSERIA := CVALTOCHAR(VAL(SC2->C2_XXSERIA) + nApont)
							SC2->(MsUnlock())

							_cProxNiv    := '1'
							_aQtdBip     := {}
							_lImpressao  := .T.
							_nPesoBip    := 0
							_lColetor    := .F.

							U_DOMETI01(cCodOP,nApont,_cNumSerie,cLocImp)

							_cPrxDoc:= fPrxDoc()
							For _y := 1 to nApont
								Reclock("XD4", .T.)
								XD4->XD4_FILIAL	:= xFilial("XD4")
								XD4->XD4_SERIAL	:= _cNumSerie
								XD4->XD4_STATUS	:= '6'
								XD4->XD4_OP	   	:= cCodOP
								XD4->XD4_NOMUSR	:= cUserSis
								XD4->XD4_DOC    := _cPrxDoc
								XD4->XD4_KEY 	:= "S"+Alltrim(cCodOP)+Alltrim(cvaltochar(_cNumSerie))
								XD4->(MsUnlock())
								_cNumSerie += 1
							Next _y


						Endif
					Endif
				Else
					MyMsg("Fibra "+Alltrim(cCFibra)+" não encontrada na OP:"+Alltrim(cCodOp),1)
				Endif
			Endif

		next _j



		DEFINE MSDIALOG oDlgx TITLE "ZERAR O ROLO?" FROM 0,0 TO 570,800 PIXEL

		@ 08,70 SAY oSay5 PROMPT "SELECIONE OS ROLOS QUE DEVEM SER ZERADOS" SIZE 337, 028 OF oDlgx FONT oFont4C COLORS 0, 16777215 PIXEL
		@ 30,05 LISTBOX oLbx VAR cVar FIELDS HEADER;
			"","Fibra","Descrição","Etiqueta","Qtd.no Rolo" ;
			SIZE 375,220 OF oDlgx  FONT oFont4c  PIXEL ;
			ON dblClick( IIF(empty(aDados[oLbx:nAt,6]),aDados[oLbx:nAt,6]:= "X",aDados[oLbx:nAt,6]:= ""))
		oLbx:SetArray(aDados)
		oLbx:bLine := {|| {Iif (empty(aDados[oLbx:nAt,6]), oNo, oOk),;
			aDados[oLbx:nAt,1],alltrim(aDados[oLbx:nAt,5]),aDados[oLbx:nAt,2],aDados[oLbx:nAt,4]}}
		oLbx:Refresh()

		@ 250, 150 BUTTON oButton1 PROMPT "OK" SIZE 083, 035 OF oDlgx action (oDlgx:end()) FONT oFont4c PIXEL

		ACTIVATE MSDIALOG oDlgx CENTERED

		For _z := 1 to len(aDados)
			cCFibra	:= aDados[_z,1]
			cEtiq	:= aDados[_z,2]
			cEtiqOfc:= aDados[_z,2]
			nTamRolo:= aDados[_z,4]
			cNFibra:= aDados[_z,5]

			lZera:= IIF (!EMPTY(aDados[_z,6]),.T.,.F.)

			if lZera
				AjustSup(cCFibra,cValtoChar(nTamRolo),nApont*nTamCort,cNFibra,cEtiq,"S" )
				if lAjusteOk
					lFimRolo:= .T.

					dbSelectArea("XD1")
					XD1->(dbsetorder(1))
					if dbseek(xFilial("XD1")+"0"+SUBSTRING(cEtiq,1,11))
						cProduto   := XD1->XD1_COD 					    //-- Codigo do Produto Origem    - Obrigatorio
						cLocOrig   := XD1->XD1_LOCAL			   	    //-- Almox Origem                - Obrigatorio
						cLocDest   := "97"   					   	    //-- Almox Destino               - Obrigatorio
						cDocumento := U_NEXTDOC()      		    		//-- Documento                   - Obrigatorio
						cNumLote   := "" 						       	//-- Sub-Lote                    - Obrigatorio se usa Rastro "S"
						cLoteCtl   := Alltrim(XD1->XD1_LOTECT)		    //-- Lote                        - Obrigatorio se usa Rastro
						nQtde	   := XD1->XD1_QTDATU
						dDtValid   := fBuscaLote(cProduto,cLoteCtl,cLocOrig)
						cEndOrig   := Alltrim(XD1->XD1_LOCALI)		   //-- Localizacao Origem
						cEndDest   := "97PROCESSO     " 						   //-- Endereco Destino            - Obrigatorio p/a Transferencia
						cEtiqueta  := XD1->XD1_XXPECA

						if fAjusSld(cTmSai,cProduto,nQtde, cLocOrig,cEndOrig,cDocumento,cLoteCtl,dDtValid,cEtiqueta)
							//Zera Etiqueta
							Reclock("XD1", .F.)
							XD1->XD1_QTDATU := 0
							XD1->XD1_OCORRE := '5'
							XD1->(MsUnlock())
						else
							MYMSG("O Rolo 0"+SUBSTRING(ZZ4->ZZ4_ETIQ,1,11) +", não foi zerado! Procure o administrador do sistema ",1)
						Endif
					else
						MYMSG("Etiqueta "+"0"+SUBSTRING(ZZ4->ZZ4_ETIQ,1,11) +", não identificada! ",1)
					EndIf
				Else
					MYMSG("A Liberação da Supervisão foi recusada e por isso o ajute do rolo não será realizado!",1)
					lFimRolo:= .F.
				Endif
			Endif

		Next _z

		ZZ4->(dbSetOrder(1))
		ZZ4->(dbSeek(xFilial("ZZ4")+Alltrim(cCodOp)))
		while Alltrim(cCodOp) == alltrim(ZZ4->ZZ4_OP)
			dbSelectArea("XD1")
			XD1->(dbsetorder(1))
			if dbseek(xFilial("XD1")+"0"+SUBSTRING(ZZ4->ZZ4_ETIQ,1,11))
				RecLock("ZZ4", .F.)
					ZZ4->ZZ4_QTDETI:= XD1->XD1_QTDATU	
				ZZ4->(MsUnlock())
			Endif
			ZZ4->(dbSkip())
		End

	END TRANSACTION


	nApont  :=0
	nEmCort := 0
	fVldOp(2)

	nPfibra := aScan(aHeader,{|aVet| Alltrim(aVet[2]) == "FIBRA"})
	nPID    := aScan(aHeader,{|aVet| Alltrim(aVet[2]) == "USERAP"})

	nPos := aScan(oGetDados:aCols,{|x| Alltrim(x[nPfibra]) == alltrim(cCFibra) .and. alltrim(x[nPID]) == Alltrim(__cUserId) })

	If nPos > 0
		nQtdOp	:= oGetDados:aCols[nPos,ascan(aHeader,{|x| alltrim(x[2])=="QTDTOP"})]
		nQtdProd:= oGetDados:aCols[nPos,ascan(aHeader,{|x| alltrim(x[2])=="QTDCOR"})]
		nEmCort:= oGetDados:aCols[nPos,ascan(aHeader,{|x| alltrim(x[2])=="QEMCRT"})]
		oGetDados:aCols[nPos,ascan(aHeader,{|x| alltrim(x[2])=="QTDRES"})]:= (nQtdOp - nQtdProd)
		nQtdRest:= oGetDados:aCols[nPos,ascan(aHeader,{|x| alltrim(x[2])=="QTDRES"})]
	Endif

	oQtdOp:Refresh()
	oQtdProd:Refresh()
	oQtdRest:Refresh()
	oTamRolo:Refresh()
	oEmCort:Refresh()
	oApont:Refresh()
	oGetDados:Refresh()

//fVldEti(cEtiqOfc)

Return


/*/______________________{}_____________________
	|---------------------------------------------------------|
	author: Ricardo Roda
	Data: 20/12/2019
	|---------------------------------------------------------|
	__________________________________________________________
/*/
static Function MyMsg(cAviso,nOpc)
	Local oFont1 := TFont():New("Arial",,044,,.F.,,,,,.F.,.F.)
	Local oFont2 := TFont():New("Arial",,036,,.F.,,,,,.F.,.F.)
	Local oSay1
	Local lRet:= .T.
	Static oDlg3



	if nOpc == 1
		DEFINE MSDIALOG oDlg3 TITLE "Aviso" FROM 000, 000  TO 400, 800 COLORS 0, 16777215 PIXEL
		@ 002, 150 BITMAP oBitmap10 SIZE 150, 150 OF oDlg3 FILENAME cFileAten NOBORDER PIXEL

		@ 090, 012 SAY oSay1 PROMPT cAviso SIZE 381, 092 OF oDlg3 FONT oFont1 COLORS 0, 16777215 PIXEL
		@ 151, 149 BUTTON oButton1 PROMPT "OK" SIZE 098, 043 OF oDlg3 ACTION ( oDlg3:End() ) FONT oFont1 PIXEL
	Elseif nOpc == 2
		DEFINE MSDIALOG oDlg3 TITLE "Aviso" FROM 000, 000  TO 400, 800 COLORS 0, 16777215 PIXEL
		@ 002, 150 BITMAP oBitmap10 SIZE 150, 150 OF oDlg3 FILENAME cFileInter NOBORDER PIXEL

		@ 090, 012 SAY oSay1 PROMPT cAviso SIZE 381, 092 OF oDlg3 FONT oFont2 COLORS 0, 16777215 PIXEL
		@ 151, 090 BUTTON oButton1 PROMPT "NÃO" SIZE 098, 043 OF oDlg3 ACTION ( oDlg3:End(),lRet:= .F. ) FONT oFont1 PIXEL
		@ 151, 210 BUTTON oButton1 PROMPT "SIM" SIZE 098, 043 OF oDlg3 ACTION ( oDlg3:End() ) FONT oFont1 PIXEL
	Endif

	ACTIVATE MSDIALOG oDlg3 CENTERED

	if nOpc == 2
		Return lRet
	Else
		Return
	Endif


/*/______________________{}_____________________
	|---------------------------------------------------------|
	author: Ricardo Roda
	Data: 20/12/2019
	|---------------------------------------------------------|
	__________________________________________________________
/*/
Static Function fTrfRolo(cCFibra,nTransf,cEtiq)
	Local cArm        := "97"
	Local cLocaliz    := "97PROCESSO     "
	Local nFimRolo    := 0
	Local lMsErroAuto := .F.

	Private cCusMed   := SuperGetMV('MV_CUSMED')
	Private aRegSD3   := {}
	Private dDtValid  := cTod("  /  /  ")

	PRIVATE cCadastro := "Transferencias"
	PRIVATE nPerImp   := CriaVar("D3_PERIMP")
	Private _cDoC     := U_NEXTDOC()
	Private lContinua  := .F.


//Begin Transaction

	dbSelectArea("XD1")
	XD1->(dbsetorder(1))
	if dbseek(xFilial("XD1")+"0"+SUBSTRING(cEtiq,1,11))
		//Dados para Transferencia
		nQtde      := nTransf
		cProduto   := XD1->XD1_COD 					//-- Codigo do Produto Origem    - Obrigatorio
		cLocOrig   := XD1->XD1_LOCAL			   	//-- Almox Origem                - Obrigatorio
		cLocDest   := cArm   					   	//-- Almox Destino               - Obrigatorio
		cDocumento := _cDoC      		    		   //-- Documento                   - Obrigatorio
		cNumLote   := "" 						       	//-- Sub-Lote                    - Obrigatorio se usa Rastro "S"
		cLoteCtl   := Alltrim(XD1->XD1_LOTECT)		//-- Lote                        - Obrigatorio se usa Rastro
		dDtValid   :=  fBuscaLote(cProduto,cLoteCtl,cLocOrig) 	//-- Validade                    - Obrigatorio se usa Rastro
		cEndOrig   := Alltrim(XD1->XD1_LOCALI)		//-- Localizacao Origem
		cEndDest   := cLocaliz 						   //-- Endereco Destino            - Obrigatorio p/a Transferencia
		lcontinua  :=  fSldLcaliz(cProduto,nQtde,cLocOrig,cEndOrig, cLoteCtl)
		cSerOrig   := ""				 			      //-- Numero de Serie
		cEtiqueta  := XD1->XD1_XXPECA
		nFimRolo := nTamRolo

		if lContinua
			//TRANSFERE
			a260Processa(cProduto, ; 	//-- Codigo do Produto Origem    - Obrigatorio
			cLocOrig, ;                      	//-- Almox Origem                - Obrigatorio
			nQtde, ;                           	//-- Quantidade 1a UM            - Obrigatorio
			cDocumento, ;                      	//-- Documento                   - Obrigatorio
			dDataBase, ;                       	//-- Data                        - Obrigatorio
			ConvUm(cProduto, nQtde, 0, 2), ;   //-- Quantidade 2a UM
			cNumLote, ;                        	//-- Sub-Lote                    - Obrigatorio se usa Rastro "S"
			cLoteCtl, ;                        	//-- Lote                        - Obrigatorio se usa Rastro
			dDtValid, ;                        	//-- Validade                    - Obrigatorio se usa Rastro
			cSerOrig, ;                        	//-- Numero de Serie
			cEndOrig, ;                        	//-- Localizacao Origem
			cProduto, ;                        	//-- Codigo do Produto Destino   - Obrigatorio
			cLocDest, ;                        	//-- Almox Destino               - Obrigatorio
			cEndDest, ;                       	//-- Endereco Destino            - Obrigatorio p/a Transferencia
			.F., ;                             	//-- Indica se movimento e estorno
			Nil, ;                             	//-- Numero do registro origem no SD3  - Obrigatorio se for Estorno
			Nil, ;                             	//-- Numero do registro destino no SD3 - Obrigatorio se for Estorno
			'MATA260', ;                       	//-- Indicacao do programa que originou os lancamentos
			,,,,,,,,,,,,,,,,U_RETLOTC6(cCodOP),StoD("20491231"))
		/*Nil,;                              	//-- Estrutura Fisica Padrao
		Nil,;                              	//-- Servico
		Nil,;                              	//-- Tarefa
		Nil,;                              	//-- Atividade
		Nil,;                              	//-- Anomalia
		Nil,;                              	//-- Estrutura Fisica Destino
		cEndDest,;                         	//-- Endereco Destino
		Nil,;                              	//-- Hora Inicio
		'S',;                              	//-- Atualiza Estoque
		Nil,;                              	//-- Numero da Carga
		Nil,;                              	//-- Numero do Unitizador
		Nil,;                              	//-- Ordem da Tarefa
		Nil,;                              	//-- Ordem da Atividade
		Nil,;                              	//-- Recurso Humano
		Nil)                               	//-- Recurso Fisico
		*/
		Endif
	Endif

	if !lContinua .or. lMsErroAuto
		MyMsg("Erro na Transferência! "+chr(13)+chr(10)+"Procure o administrador do sistema.",1)
//	Disarmtransaction()
	Else
		//Atualiza o saldo da etiqueta
		Reclock("XD1", .F.)
		XD1->XD1_QTDATU := XD1-> XD1_QTDATU -  nTransf
		XD1->(MsUnlock())

		fVldEti(cEtiq)

		dbSelectArea("SD3")
		SD3->( dbSetOrder(2) )  // D3_FILIAL + D3_DOC
		If SD3->( dbSeek( xFilial() + _cDoc ) )
			While !SD3->( EOF() ) .and. ALLTRIM(SD3->D3_DOC) == ALLTRIM(_cDoc)    //MLS ALTERADO MOTIVO DOCUMENTO COM 9 DIGITOS
				If SD3->D3_CF == 'RE4' .or. SD3->D3_CF == 'DE4'
					Reclock("SD3",.F.)
					SD3->D3_XXPECA  := XD1->XD1_XXPECA
					SD3->D3_XXOP    := cCodOP
					SD3->D3_XHRINI	 := cHrIni
					SD3->D3_HORA    := Time()
					SD3->( msUnlock() )
				EndIf
				SD3->( dbSkip() )
			End
		Endif
	Endif

	//Requisição da Mão de Obra
	nQtdMod:= 0
	lFofs := Posicione("SB1",1, xFilial("SB1")+cCFibra,"B1_GRUPO") <> "FOFS"

	if lFofs
		Processa( {|| fReqMOD(cCodOP,nQtdMod,nApont) },"Gravando MOD")
	Endif


	if Posicione("SB1",1, xFilial("SB1")+cCFibra,"B1_GRUPO") == 'FOFS'
		lContinua:= .F.
	Endif

Return lContinua


/*/______________________{}_____________________
	|---------------------------------------------------------|
	author: Ricardo Roda
	Data: 20/12/2019
	|---------------------------------------------------------|
	__________________________________________________________
/*/
Static Function fBuscaLote(cCod,cLote,cLocal)

	Local  cQuery:= ""

	iF !Empty(Alltrim(cLote))

		IF SELECT("QRY") > 0
			QRY->(dbCloseArea())
		Endif

		cQuery:= " SELECT TOP 1 B8_DTVALID FROM "+RetSqlName("SB8")+" SB8"
		cQuery+= " WHERE B8_LOTECTL = '"+cLote+"'
		cQuery+= " AND B8_FILIAL = '"+xFilial("SB8")+"' "
		cQuery+= " AND B8_PRODUTO = '"+cCod+"'
		cQuery+= " AND B8_LOCAL = '"+cLocal+"'
		cQuery+= " AND D_E_L_E_T_ = ''
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)

		IF !Empty(QRY->B8_DTVALID)
			dDtValid:= cTod(QRY->B8_DTVALID)
		Else
			MyMsg("Lote não encontrado",1)
			lRet:= .F.
		End

		QRY->(dbCloseArea())
	Endif

Return dDtValid

/*/______________________{}_____________________
	|---------------------------------------------------------|
	author: Ricardo Roda
	Data: 20/12/2019
	|---------------------------------------------------------|
	__________________________________________________________
/*/
Static Function fSldLcaliz(cProduto,nQtde,cLocOrig,cEndOrig, cLoteCtl)

	Local  cQuery:= ""
	Local lRet:= .T.
	Local _msg:=""

	IF SELECT("QRY") > 0
		QRY->(dbCloseArea())
	Endif

	cQuery:= " SELECT TOP 1 BF_QUANT FROM "+RetSqlName("SBF")+" SBF"
	cQuery+= " WHERE BF_LOTECTL = '"+cLoteCtl+"' "
	cQuery+= " AND BF_FILIAL = '"+xFilial("SBF")+"' "
	cQuery+= " AND BF_PRODUTO = '"+cProduto+"' "
	cQuery+= " AND BF_LOCAL = '"+cLocOrig+"' "
	cQuery+= " AND BF_LOCALIZ = '"+cEndOrig+"' "
	cQuery+= " AND D_E_L_E_T_ = ''
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)


	If BF_QUANT < nQtde

		_msg+="Produto:"+cProduto+ " |Localiz:"+cLocOrig+"-"+cEndOrig  +chr(13)+chr(10)
		_msg+="Qtd.Apont:"+cvaltochar(nQtde) + " |Saldo:"+cvaltochar(QRY->BF_QUANT)

		MyMsg("Quantidade excede o Saldo no endereço" +chr(13)+chr(10)+_msg ,1)
		lRet := .F.
	Endif

	QRY->(dbCloseArea())


Return lRet

/*/______________________{}_____________________
	|---------------------------------------------------------|
	author: Ricardo Roda
	Data: 20/12/2019
	|---------------------------------------------------------|
	__________________________________________________________
/*/
Static Function fCortIni()
	Local lGrvLoteB1:= .T.
	Local nPosFlag	:= GdFieldPos( "FLAG" )
	Local nPosFibra	:= GdFieldPos( "FIBRA" )
	Local nPosQtRes	:= GdFieldPos( "QTDRES" )
	Local nPosEtiq	:= GdFieldPos( "ETIQ" )
	Local nPosQtRol	:= GdFieldPos( "QTDROLO" )
	Local nQtdEmCort:= 0
	Local aDados2:={}
	Local _z
	Local _n

	For _z := 1 To Len(oGetDados:Acols)
		IF oGetDados:aCols[_z,nPosFlag] == oOK
			AADD(aDados2,{;
				oGetDados:aCols[_z,nPosFibra],;
				oGetDados:aCols[_z,nPosEtiq],;
				oGetDados:aCols[_z,nPosQtRes],;
				oGetDados:aCols[_z,nPosQtRol];
				})
		Endif
	Next _z

	If len(aDados2) <> 12
		MyMsg(" Atenção!"+Chr(13)+chr(10)+"Informe 12 fibras antes de iniciar o corte.",1 )
		Return .F.
	Endif

	If !empty(cCodOp)

		BEGIN TRANSACTION

			For _n := 1 to len(aDados2)

				cCFibra	:= aDados2[_n,1]
				cEtiq	:= aDados2[_n,2]
				cEtiqOfc:= aDados2[_n,2]
				nTamRolo:= aDados2[_n,4]

				if (nPrevCort/3) <> Int(nPrevCort/3) .AND. lGrvLoteB1
					lGrvLoteB1:= .F.
					iF !(MyMsg("O número "+cValtochar(nPrevCort)+" não é multiplo de 3"+Chr(13)+chr(10)+"Confirma mesmo assim a previsão de corte?" ,2))
						Return
					Endif
				Endif

				if ((Posicione("SB1",1, xFilial("SB1")+cCFibra,"B1_XLOTPAD") == 0 ) .or. (Posicione("SB1",1, xFilial("SB1")+cCFibra,"B1_XLOTPAD") <> nPrevCort) ) .and. nPrevCort > 0 .AND. lGrvLoteB1
					If MyMsg("Lote Padrão de corte para fibra "+alltrim(cCFibra)+" diferente ou não cadastrado! "+chr(13)+chr(10)+"Deseja cadastrar "+cValtochar(nPrevCort)+" como lote padrão do produto?" ,2 )
						dbSelectArea("SB1")
						dbSetOrder(1)
						if SB1->(dbSeek(xFilial("SB1")+Alltrim(cCFibra)))
							SB1->(RecLock("SB1",.F.))
							SB1->B1_XLOTPAD := nPrevCort
							SB1->(MsUnlock())
						Endif
					Endif
				Endif

				nQtdEmCort:= fQtdEmCort(cCFibra)

				dbSelectArea("ZZ4")
				dbSetOrder(2)
				if ZZ4->(dbSeek(xFilial("ZZ4")+Alltrim(cCodOp)+PADR(alltrim(cCFibra),15)+__cUserId))
					If (nPrevCort+nQtdEmCort) > nQtdOp
						MyMsg("Previsão de corte da fibra "+alltrim(cCFibra)+" é maior que a quantidade restante. Verifique!",1 )
						Return .F.
					Else
						ZZ4->(RecLock("ZZ4",.F.))
						ZZ4->ZZ4_QEMCRT := nPrevCort
						ZZ4->ZZ4_STATUS	:= "2"
						ZZ4->ZZ4_HRINI	:= TIME()
						ZZ4->(MsUnlock())

						cHrIni:= ZZ4->ZZ4_HRINI
					Endif

					dbSelectArea("ZZ4")
					ZZ4->(DbSetOrder(1))
					IF ZZ4->(dbSeek(xFilial("ZZ4")+alltrim(cCodOp)+alltrim(cCFibra)))
						nQtdSD3:= fQtdSD3((ZZ4->ZZ4_QTDMTR/ZZ4->ZZ4_QTDORI),alltrim(cCFibra))
					Endif

				Endif
			next _n

		End Transaction
	Endif

	fVldOp(2)

	nApont:= nPrevCort
	nEmCort:= nPrevCort
	oEmCort:Refresh()
	oApont:Refresh()
	oGetDados:Refresh()


Return

/*/______________________{}_____________________
	|---------------------------------------------------------|
	author: Ricardo Roda
	Data: 20/12/2019
	|---------------------------------------------------------|
	__________________________________________________________
/*/
Static Function fAjusSld(cTm,cProduto,nQtde, cLocOrig,cEndOrig,cDocumento,cLoteCtl,dDtValid,cEtiqueta)
	Local ExpA1        := {}
	Local ExpN2        := 3
	Local cTPMovimento := cTM
	Local nQtd	 	    := nQtde
	Local cProd	   	 := cProduto
	Local cUnidade     := Posicione("SB1",1,xFilial("SB1")+cProd,"B1_UM")
	Local cArmazem     := cLocOrig
	Local cLocaliz	    := cEndOrig
	Local dEmissao     := dDatabase
	Local lRet         := .T.

	Private lMsErroAuto:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Abertura do ambiente                                         |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "EST" TABLES "SD3","SB1"

	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+cProd)
	cProd := SB1->B1_COD
	cUnidade := Posicione("SB1",1,xFilial("SB1")+cProd,"B1_UM")

	ConOut(Repl("-",80))
	ConOut(PadC("Movimentacoes Internas - DOMCORT",80))
	ConOut("Inicio: "+Time())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Movimentação                                            |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/* Alteração para ajuste da gerencia */
	If nQtAjusM > 0
		nQtd += nQtAjusM
	Endif
	Begin Transaction

		ExpA1 := {}
		aadd(ExpA1,{"D3_TM"      ,cTPMovimento	,Nil})
		aadd(ExpA1,{"D3_COD"     ,cProd			,Nil})
		aadd(ExpA1,{"D3_UM"      ,cUnidade		,Nil})
		aadd(ExpA1,{"D3_LOCAL"   ,cArmazem		,Nil})
		aadd(ExpA1,{"D3_QUANT"   ,nQtd			,Nil})
		aadd(ExpA1,{"D3_EMISSAO" ,dEmissao	   ,Nil})
		aAdd(ExpA1,{"D3_LOTECTL" ,cLoteCtl	   ,Nil})
		aAdd(ExpA1,{"D3_NUMLOTE" ,""			   ,Nil})
		aAdd(ExpA1,{"D3_LOCALIZ" ,cLocaliz	   ,Nil})
		aAdd(ExpA1,{"D3_XXPECA"  ,cEtiqueta    ,Nil})
		aAdd(ExpA1,{"D3_XXOP"  	 ,cCodOp    	,Nil})
		aAdd(ExpA1,{"D3_DOC"     ,cDocumento   ,Nil})
		aAdd(ExpA1,{"D3_OBSERVA"  ,cSuperv    ,Nil})


		lMsErroAuto := .F.

		MSExecAuto({|x,y| mata240(x,y)},ExpA1,ExpN2)

		If !lMsErroAuto
			ConOut("Incluido com sucesso! " + cTPMovimento)
			lRet := .T.

			If cTPMovimento < '500'

				cNumseq := ""
				SD3->( dbSetOrder(2) ) // D3_FILIAL + D3_DOC
				If SD3->( dbSeek( xFilial() + cDocumento ) )
					While !SD3->( EOF() ) .and. ALLTRIM(SD3->D3_DOC) == ALLTRIM(cDocumento)
						If SD3->D3_COD == cProd
							If SD3->D3_LOCAL == cArmazem
								If SD3->D3_EMISSAO == dEmissao
									If SD3->D3_QUANT == nQtd
										cNumseq := SD3->D3_NUMSEQ
										Exit
									EndIf
								EndIf
							EndIf
						EndIf
						SD3->( dbSkip() )
					End
				EndIf


				SDA->( dbSetOrder(RetOrder("SDA","DA_FILIAL+DA_NUMSEQ")) ) // DA_FILIAL + DA_NUMSEQ

				If SDA->( dbSeek( xFilial() + cNumSeq ) ) .and. !Empty(cNumseq)

					While !SDA->( EOF() ) .and. SDA->DA_NUMSEQ == cNumSeq

						If SDA->DA_SALDO >= 0 .and. Alltrim(SDA->DA_DOC) == ALLTRIM(cDocumento) .and. SDA->DA_PRODUTO == cProd .and. SDA->DA_LOCAL == cArmazem

							_cItem := '0000'

							SDB->( dbSetOrder(1) )  //DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA+DB_ITEM
							If SDB->(dbSeek( xFilial() + SDA->DA_PRODUTO + SDA->DA_LOCAL + SDA->DA_NUMSEQ))
								While xFilial("SDB") + SDA->DA_PRODUTO + SDA->DA_LOCAL + SDA->DA_NUMSEQ == SDB->DB_FILIAL + SDB->DB_PRODUTO + SDB->DB_LOCAL + SDB->DB_NUMSEQ
									_cItem:=SDB->DB_ITEM
									SDB->( dbSkip() )
								End
							EndIf

							_cItem     := StrZero(Val(_cItem)+1,4)
							_aItensSDB := {}

							_aCabSDA := {;
								{"DA_PRODUTO" ,SDA->DA_PRODUTO ,Nil},;
								{"DA_NUMSEQ"  ,SDA->DA_NUMSEQ  ,Nil}}

							_aItSDB  := {;
								{"DB_ITEM"	  ,_cItem	       ,Nil},;
								{"DB_ESTORNO" ,Space(01)       ,Nil},;
								{"DB_LOCALIZ" ,'01CORTE'       ,Nil},;
								{"DB_DATA"	  ,dDataBase       ,Nil},;
								{"DB_QUANT"   ,SDA->DA_SALDO   ,Nil}}

							aadd(_aItensSDB,_aitSDB)

							lMsErroAuto := .F.

							MATA265( _aCabSDA, _aItensSDB, 3)

							If lMsErroAuto
								MostraErro("\UTIL\LOG\")
								MyMsg("Erro no endereçamento automático no 01CORTE" ,1)
							EndIf

						EndIf

						SDA->( dbSkip() )
					End

				EndIf
			EndIf
		Else
			ConOut("Erro na inclusao!")
			MostraErro("\UTIL\LOG\")
			lRet := .F.
			Disarmtransaction()
		EndIf

		ConOut("Fim ajuste etiqueta - DOMCORTPIG : "+Time())
		ConOut(Repl("-",80))

	End Transaction

//RESET ENVIRONMENT

Return lRet

/*/______________________{}_____________________
	|---------------------------------------------------------|
	author: Ricardo Roda
	Data: 20/12/2019
	|---------------------------------------------------------|
	__________________________________________________________
/*/
Static function fExclEti()
	Local cQuery:= ""
	Local nEtiqs:= 0
	Local _cPrxDoc:= fPrxDoc()
	Local _k

	if SELECT("QRY") > 0
		QRY->(dbCloseArea())
	Endif

	cQuery:= " SELECT TOP 1 XD4_DOC AS DOC, COUNT(*) ETIQS "
	cQuery+= " FROM "+RETSQLNAME("XD4")+" (NOLOCK) XD4  "
	cQuery+= " WHERE XD4_OP = '"+cCodOP+"' "
	cQuery+= " AND XD4_FILIAL = '"+xFilial("XD4")+"'  "
	cQuery+= " AND XD4.D_E_L_E_T_ = '' "
	cQuery+= " AND XD4_NOMUSR = '"+cUserSis+"' "
	cQuery+= " AND XD4.D_E_L_E_T_ = '' "
	cQuery+= " GROUP BY XD4_DOC "
	cQuery+= " ORDER BY XD4_DOC DESC "

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)

	if QRY->(!eof())
		nEtiqs:= QRY->ETIQS
		cQuery:= "UPDATE "+retsqlname("XD4")+" SET XD4_STATUS = '5' "
		cQuery+= "WHERE XD4_DOC = '"+QRY->DOC+"'
		cQuery+= "AND XD4_OP = '"+cCodOP+"' "
		cQuery+= " AND XD4_NOMUSR =  '"+cUserSis+"'
		cQuery+= "AND D_E_L_E_T_ = ''"
		TCSqlExec(cQuery)

		MyMsg(cValToChar(nEtiqs)+" Etiquetas excluidas !",1)
	Else
		MyMsg("Não há etiquetas para excluir !",1)
	Endif

	QRY->(dbCloseArea())

	DbSelectArea("SC2")
	DbSetOrder(1)
	dbSeek(xFilial("SC2")+cCodOP)

//Coleta o ultimo serial e incrementa o apontamento
	_cNumSerie:= VAL(SC2->C2_XXSERIA) + 1
	Reclock("SC2", .F.)
//SC2->C2_XSERIAL := C2->C2_XSERIAL + nApont
	SC2->C2_XXSERIA := CVALTOCHAR(VAL(SC2->C2_XXSERIA) + nEtiqs)
	SC2->(MsUnlock())

	_cProxNiv    := '1'
	_aQtdBip     := {}
	_lImpressao  := .T.
	_nPesoBip    := 0
	_lColetor    := .F.


/*U_DOMETQ80(cCodOP,;// Numero da OP
NIL,;// Numero da SENF
1,;// Quantidade de Embalagem
_nQtdExcl,;// Quantidade de Etiquetas
_cProxNiv,;// Nivel de Embalagem
_aQtdBip,; //Array informações da embalagem
_lImpressao,;// Imprime Etiqueta .T. (Sim) .F. (Não)
_nPesoBip,;
_lColetor,; // enviado pelo coletor?
_cNumSerie,; //numero de serie
NIL)*/

U_DOMETI01(cCodOP,nEtiqs,_cNumSerie,cLocImp)


For _k := 1 to nEtiqs
	Reclock("XD4", .T.)
	XD4->XD4_FILIAL	:= xFilial("XD4")
	XD4->XD4_SERIAL	:= _cNumSerie
	XD4->XD4_STATUS	:= '6'
	XD4->XD4_OP		:= cCodOP
	XD4->XD4_NOMUSR	:= cUserSis
	XD4->XD4_DOC	:= _cPrxDoc
	XD4->XD4_KEY 	:= "S"+Alltrim(cCodOP)+Alltrim(cvaltochar(_cNumSerie))
	XD4->(MsUnlock())
	
	_cNumSerie += 1
Next _k

Return

/*/______________________{}_____________________
|---------------------------------------------------------|
author: Ricardo Roda
Data: 20/12/2019
|---------------------------------------------------------|
__________________________________________________________
/*/
Static function fPrxDoc()
Local cPrxDoc:= ""

if SELECT("QRYB") > 0
	QRYB->(dbCloseArea())
Endif

cQuery:= " SELECT MAX(XD4_DOC)AS PRXDOC FROM "+RetSqlName("XD4")+" XD4 "
cQuery+= " WHERE XD4_OP = '"+cCodOP+"' "
cQuery+= " AND XD4_FILIAL = '"+xFilial("XD4")+"' "
cQuery+= " AND D_E_L_E_T_ = '' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRYB",.T.,.T.)

if QRYB->(!Eof())
	cPrxDoc:= STRZERO((val(QRYB->PRXDOC)+1),6)
Endif

Return cPrxDoc

/*/______________________{}_____________________
|---------------------------------------------------------|
author: Ricardo Roda
Data: 20/12/2019
|---------------------------------------------------------|
__________________________________________________________
/*/
Static Function fZera

nApont:= 0
nEmCort:= 0

cQuery:= "UPDATE "+retsqlname("ZZ4")+" SET ZZ4_QEMCRT = 0  "
cQuery+= "WHERE ZZ4_OP = '"+cCodOP+"' "
//cQuery+= " AND ZZ4_PROD = '"+cCFibra+"' "
cQuery+= " AND ZZ4_USER = '"+__cUserId+"' "
cQuery+= " AND D_E_L_E_T_ = '' "
TCSqlExec(cQuery)

fVldOp(2)

nPfibra := aScan(aHeader,{|aVet| Alltrim(aVet[2]) == "FIBRA"})
nPID    := aScan(aHeader,{|aVet| Alltrim(aVet[2]) == "USERAP"})

nPos := aScan(oGetDados:aCols,{|x| Alltrim(x[nPfibra]) == alltrim(cCFibra) .and. alltrim(x[nPID]) == Alltrim(__cUserId) })

If nPos > 0
	
	nQtdOp	:= oGetDados:aCols[nPos,ascan(aHeader,{|x| alltrim(x[2])=="QTDTOP"})]
	nQtdProd:= oGetDados:aCols[nPos,ascan(aHeader,{|x| alltrim(x[2])=="QTDCOR"})]
	nEmCort:= oGetDados:aCols[nPos,ascan(aHeader,{|x| alltrim(x[2])=="QEMCRT"})]
	oGetDados:aCols[nPos,ascan(aHeader,{|x| alltrim(x[2])=="QTDRES"})]:= (nQtdOp - nQtdProd)
	nQtdRest:= oGetDados:aCols[nPos,ascan(aHeader,{|x| alltrim(x[2])=="QTDRES"})]
Endif

Return
/*/______________________{}_____________________
|---------------------------------------------------------|
author: Ricardo Roda
Data: 20/12/2019
|---------------------------------------------------------|
__________________________________________________________
/*/
Static function fQtdSD3(TamCorte,cCFibra)
Local cQuery:= ""
Local cLocProd:= "97"//SuperGetMv("MV_XLOCPROC",.F.,"97")
Local nQtdeSD3:= 0

If SELECT("QRYD3") > 0
	QRYD3->(dbCloseArea())
Endif

cQuery:= " SELECT D3_COD, ISNULL(SUM(CASE WHEN D3_CF='RE4' THEN -D3_QUANT ELSE +D3_QUANT END),0) AS QTDD3"
cQuery+= " FROM "+RetSqlName("SD3")+ " SD3 "
cQuery+= " WHERE D3_XXOP    ='"+cCodOP+"'  "
cQuery+= " AND D3_FILIAL = '"+xFilial("SD3")+"' "
//cQuery+= " AND   D3_COD     = '"+cCFibra+"' "
//ALTERAÇÃO PARA MULTIPLAS FIBRAS
cQuery+= "AND   D3_COD IN (select  ZZ4_PROD from "+RETSQLNAME("ZZ4")+" ZZ4 "
cQuery+= " WHERE ZZ4_OP = '"+cCodOP+"' AND ZZ4_FILIAL = '"+xFilial("ZZ4")+"' )   "

cQuery+= " AND   D3_LOCAL   = '"+cLocProd+"' "
cQuery+= " AND   D3_ESTORNO = ''  "
cQuery+= " AND   D3_CF IN ('DE4','RE4') "
cQuery+= " AND   SD3.D_E_L_E_T_ = '' "
cQuery+= " GROUP BY D3_COD"

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRYD3",.T.,.T.)
//MemoWrite("PAGOSD3.sql",cQuery)

WHILE QRYD3->(!EOF())
	nQtdeSD3:= round((QRYD3->QTDD3/TamCorte),0)

	cQuery:= "UPDATE "+retsqlname("ZZ4")+" SET ZZ4_QTCORT = "+cvaltochar(nQtdeSD3)+"  "
	cQuery+= "WHERE ZZ4_OP = '"+cCodOP+"' "
	cQuery+= " AND ZZ4_FILIAL = '"+xFilial("ZZ4")+"' "
	cQuery+= " AND ZZ4_PROD = '"+QRYD3->D3_COD+"' "
	cQuery+= "AND D_E_L_E_T_ = '' "
	TCSqlExec(cQuery)
	QRYD3->(DBSkip())
ENDDO

QRYD3->(dbCloseArea())

Return nQtdeSD3

/*/______________________{}_____________________
|---------------------------------------------------------|
author: Ricardo Roda
Data: 20/12/2019
|---------------------------------------------------------|
__________________________________________________________
/*/
Static function fQtdEmCort(cCFibra)
Local cQuery:= ""
Local nQtdeZZ4:= 0

If SELECT("QRYZZ4") > 0
	QRYZZ4->(dbCloseArea())
Endif

cQuery:= " SELECT SUM(ZZ4_QEMCRT)  AS QTDZZ4"
cQuery+= " FROM "+RetSqlName("ZZ4")+"  "
cQuery+= " WHERE ZZ4_OP = '"+cCodOP+"' "
cQuery+= " AND ZZ4_FILIAL = '"+xFilial("ZZ4")+"' "
cQuery+= " AND ZZ4_PROD = '"+cCFibra+"' "

// TRATAMENTO TEMPORÁRIO PARA NÃO ACEITAR APONTAMENTOS DO CORTE NORMAL
cQuery+= " AND ZZ4_LOCAL =  '' "
//FIM DO TRATAMENTO

cQuery+= " AND D_E_L_E_T_ = '' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRYZZ4",.T.,.T.)

If QRYZZ4->(!eof())
	nQtdeZZ4:= QRYZZ4->QTDZZ4
Endif

QRYZZ4->(dbCloseArea())

Return nQtdeZZ4
/*/______________________{}_____________________
|---------------------------------------------------------|
author: Ricardo Roda
Data: 20/12/2019
|---------------------------------------------------------|
__________________________________________________________
/*/

Static Function fAnaliPg()

Local cQuery:= ""
Local cLocProd:= "97"//SuperGetMv("MV_XLOCPROC",.F.,"97")
Local lRet:= .T.

If SELECT("Qry4") > 0
	Qry4->(dbCloseArea())
Endif

cQuery:= " SELECT D4_COD, "
cQuery+= " ISNULL(SUM(CASE WHEN D3_CF='RE4' THEN -D3_QUANT ELSE +D3_QUANT END),0) AS QTDD3, "
cQuery+= " D4_QTDEORI QTDD4 "
cQuery+= " FROM "+RETSQLNAME("SD4")+" SD4 "
cQuery+= " LEFT JOIN "+RETSQLNAME("SD3")+" SD3  ON D3_XXOP = D4_OP "
cQuery+= " AND D3_COD = D4_COD "
cQuery+= " AND D3_LOCAL   = '"+cLocProd+"' "
cQuery+= " AND D3_ESTORNO = ''  "
cQuery+= " AND D3_CF IN ('DE4','RE4') "
cQuery+= " AND D3_FILIAL ='"+xFilial("SD3")+"'"
cQuery+= " AND SD3.D_E_L_E_T_ = ''  "
cQuery+= " INNER JOIN "+RETSQLNAME("SB1")+" SB1 ON B1_COD = D4_COD AND SB1.D_E_L_E_T_ = '' AND B1_GRUPO IN ('FO','FOFS') "
cQuery+= " AND B1_FILIAL = '"+xFilial("SB1")+"' "
cQuery+= " WHERE D4_OP ='"+cCodOP+"' "
cQuery+= " AND D4_FILIAL = '"+xFilial("SD4")+"'"
cQuery+= " AND SD4.D_E_L_E_T_ = '' "
cQuery+= " GROUP BY D4_COD, D3_XXOP,D4_QTDEORI  "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"Qry4",.T.,.T.)
//MemoWrite("PAGTOCORTE.sql",cQuery)


If Qry4->(!eof())
	
	While  Qry4->(!eof())
		// ALTERAÇÃO REALIZADA EM 10/05/2019
		iF Qry4->QTDD3 < Qry4->QTDD4
			lRet:= .T.
			Exit
			//FIM DA ALTERAÇÃO
		ElseiF Qry4->QTDD3 >= Qry4->QTDD4
			lRet:= .F.
		Endif
		Qry4->(DBSkip())
	Enddo
	
	if !lRet
		MyMsg("Ordem de produção totalmente paga!" ,1)
	Endif
Endif


Qry4->(dbCloseArea())

Return lRet

/*/______________________{}_____________________
|---------------------------------------------------------|
author: Ricardo Roda
Data: 20/12/2019
|---------------------------------------------------------|
__________________________________________________________
/*/
Static Function LimpaTudo()

nQtdOp   := 0
nResMtrs := 0
nQtdProd := 0
nQtdRest := 0
nQtdSd3  := 0
nTamCort := 0
nTamRolo := 0
nTotMtrs := 0
nApont 	:= 0
nQtdTOp  := 0
nQtdAProd:= 0
nPrevCort:= 0
nEmCort	:= 0
cCodOP   :=  SPACE(12)
cCodPA   := CriaVar("B1_COD")
cNomePA  := CriaVar("B1_DESC")
cNomePA2 := CriaVar("B1_DESC")
cEtiq    := SPACE(15)
cEtiqAtu := SPACE(15)
cCFibra  := CriaVar("B1_COD")
cNFibra  := CriaVar("B1_DESC")
cLoteCtl := CriaVar("B8_LOTECTL")
cStatus  := ""
cEtiqOfc := SPACE(15)
lEtqval := .F.

oApont:Refresh()
oCFibra:Refresh()
oCodOP:Refresh()
oCodPA:Refresh()
oEtiq:Refresh()
oNFibra:Refresh()
oNomePA:Refresh()
oQtdOp:Refresh()
oQtdProd:Refresh()
oQtdRest:Refresh()
oTamCort:Refresh()
oTamRolo:Refresh()
oQtdAProd:Refresh()
oTotMtrs:Refresh()
oPrevCort:Refresh()
oEmCort:Refresh()
oNomePA2:Refresh()
oResMtrs:Refresh()
oQtdSD3:Refresh()

MontaaLbx()

Return

/*/______________________{}_____________________
|---------------------------------------------------------|
author: Ricardo Roda
Data: 20/12/2019
|---------------------------------------------------------|
__________________________________________________________
/*/
Static Function AjustSup( cFibAj, cQRoloAj, cApontAj, cDescAj, cEtiAj,cNV )
Local oFont1 := TFont():New("Arial",,030,,.F.,,,,,.F.,.F.)
Local oFont2 := TFont():New("Arial",,032,,.T.,,,,,.F.,.F.)
Local oFont3 := TFont():New("Arial",,032,,.T.,,,,,.F.,.F.)
Local oFont4 := TFont():New("Arial",,044,,.T.,,,,,.F.,.F.)
Local oFont5 := TFont():New("Arial",,060,,.T.,,,,,.F.,.F.)
Local oButton1
Local oButton2

Local oFibAj
Local oApontAj
Local oDescAj
Local oQRoloAj
Local oEtiAj
Local oConfEtiAj
Local cConfEtiAj := space(12)

Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local oSay5
Local oSay6
Local oSay7
Local oSay8
Local oSay9

Private cCerto:= cStartPath + 'Certo2.png'
Private cErro := cStartPath + 'Errado2.png'
Private cStatus:= cStartPath + 'Interroga2.png'
Private oSenhaSup
Private oDlgSup
Private cNivel:= cNv

DEFINE MSDIALOG oDlgSup TITLE "Ajuste da Bobina" FROM 000, 000  TO 500, 1000 COLORS 0, 16777215 PIXEL  Style DS_MODALFRAME
oDlgSup:lEscClose     := .F.

@ 059, 420 BITMAP oBitmapSup SIZE 100, 098 OF oDlgSup FILENAME cStatus NOBORDER PIXEL

@ 008, 082 SAY oSay5 PROMPT "AJUSTE QUANTIDADE DA BOBINA" SIZE 337, 028 OF oDlgSup FONT oFont4 COLORS 0, 16777215 PIXEL
if cNivel == "G"
	@ 037, 118 SAY oSay1 PROMPT "*** LIBERAÇÃO DO GERENTE ***" SIZE 236, 019 OF oDlgSup FONT oFont3 COLORS 0, 16777215 PIXEL
else
	@ 037, 118 SAY oSay1 PROMPT "*** LIBERAÇÃO DO SUPERVISOR ***" SIZE 236, 019 OF oDlgSup FONT oFont3 COLORS 0, 16777215 PIXEL
Endif

@ 058, 008 SAY oSay2 PROMPT "Fibra em corte:" SIZE 086, 019 OF oDlgSup FONT oFont1 COLORS 0, 16777215 PIXEL
@ 057, 091 MSGET oFibAj VAR cFibAj SIZE 143, 020 OF oDlgSup WHEN .F. COLORS 0, 16777215 FONT oFont1 PIXEL
@ 084, 008 MSGET oDescAj VAR cDescAj SIZE 408, 020 OF oDlgSup WHEN .F. COLORS 0, 16777215 FONT oFont1 PIXEL
@ 058, 238 SAY oSay4 PROMPT "Etiqueta" SIZE 102, 019 OF oDlgSup FONT oFont1 COLORS 0, 16777215 PIXEL
@ 058, 285 MSGET oEtiAj VAR cEtiAj SIZE 132, 020 OF oDlgSup WHEN .F. COLORS 0, 16777215 FONT oFont1 PIXEL

@ 112, 010 SAY oSay6 PROMPT "Qtd.Rolo" SIZE 053, 019 OF oDlgSup FONT oFont1 COLORS 0, 16777215 PIXEL
@ 110, 061 MSGET oQRoloAj VAR cQRoloAj SIZE 132, 020 OF oDlgSup WHEN .F.  COLORS 0, 16777215 FONT oFont1 PIXEL

@ 111, 236 SAY oSay7 PROMPT "Qtd.Apontada" SIZE 081, 020 OF oDlgSup FONT oFont1 COLORS 0, 16777215 PIXEL
@ 111, 318 MSGET oApontAj VAR cApontAj SIZE 098, 020 OF oDlgSup WHEN .F. COLORS 0, 16777215 FONT oFont1 PIXEL


if cNivel == "G"
	@ 141, 008 SAY oSay9 PROMPT "Gerente" SIZE 074, 020 OF oDlgSup FONT oFont2 COLORS 16711680, 16777215 PIXEL
	@ 141, 084 MSGET oGetSup VAR cGetSup SIZE 180, 022 OF oDlgSup valid(fOK(1)) COLORS 16711680, 16777215 FONT oFont2 PIXEL
Else
	@ 141, 008 SAY oSay9 PROMPT "Supervisor" SIZE 074, 020 OF oDlgSup FONT oFont2 COLORS 16711680, 16777215 PIXEL
	@ 141, 084 MSGET oGetSup VAR cGetSup SIZE 180, 022 OF oDlgSup valid(fOK(1)) COLORS 16711680, 16777215 FONT oFont2 PIXEL
Endif
@ 141, 274 SAY oSay8 PROMPT "Senha" SIZE 053, 020 OF oDlgSup FONT oFont2 COLORS 16711680, 16777215 PIXEL
@ 141, 318 MSGET oSenhaSup VAR cSenhaC SIZE 097, 022  Password OF oDlgSup valid(fOK(2)) COLORS 16711680, 16777215 FONT oFont5 PIXEL

@ 172, 014 SAY oSay3 PROMPT "Etiqueta" SIZE 124, 019 OF oDlgSup FONT oFont2 COLORS 16711680, 16777215 PIXEL
@ 168, 084 MSGET oConfEtiAj VAR cConfEtiAj SIZE 119, 022 OF oDlgSup  valid(fVldEtqSup(cEtiAj,cConfEtiAj)) COLORS 16711680, 16777215 FONT oFont2 PIXEL

if cNivel == "G"
	@ 172, 220 SAY oSay8 PROMPT "Qtd.Aferida" SIZE 073, 020 OF oDlgSup FONT oFont2 COLORS 16711680, 16777215 PIXEL
	@ 168, 318 MSGET oQtAjusM VAR nQtAjusM  PICTURE "@E 999,999" SIZE 097, 022  OF oDlgSup  COLORS 16711680, 16777215 FONT oFont2 PIXEL
Endif

@ 200, 122 BUTTON oButton1 PROMPT "AJUSTAR" SIZE 131, 045 OF oDlgSup action(oDlgSup:end()) FONT oFont3 PIXEL
@ 200, 257 BUTTON oButton2 PROMPT "RECUSAR" SIZE 131, 045 OF oDlgSup action(lAjusteOk:= .F., MYMSG("Ajuste Recusado!",1), oDlgSup:end()) FONT oFont3 PIXEL


ACTIVATE MSDIALOG oDlgSup CENTERED

Return

/*/______________________{}_____________________
|---------------------------------------------------------|
author: Ricardo Roda
Data: 20/12/2019
|---------------------------------------------------------|
__________________________________________________________
/*/
Static Function fOK(nOpc)
Local aUsrRet := {}

lAjusteOk := .F.
cSuperv:= ""


If nopc == 1
	If Empty(Alltrim(cGetSup))
		MyMsg("Usuario em branco.",1)
		Return .F.
	Else
		PswOrder(2)
		If PswSeek( AllTrim(cGetSup), .T. )
			aUsrRet := PswRet()
		EndIf
		
		If Len(aUsrRet) <= 0
			MyMsg("Usuario nao encontrado",1)
			Return .F.
		Endif
	Endif
Endif

if nopc == 2
	If Empty(alltrim(cSenhaC))
		MyMsg("Senha em branco.",1)
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Busca o usuario digitado			   						³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		PswOrder(2)
		If PswSeek( AllTrim(cGetSup), .T. )
			aUsrRet := PswRet()
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Valida a senha do usuario digitado   						³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If Len(aUsrRet) > 0
			PswSeek( AllTrim(cGetSup), .T. )
			lFound := PswName( AllTrim(cSenhaC) )
			If !lFound
				MyMsg("Senha Inválida!",1)
				Return .F.
			Else
				If cNivel ==  "S" .AND. (Upper(AllTrim(aUsrRet[1,13])) <> Upper("Supervisor de Producao"))
					MyMsg("Usuario não é SUPERVISOR",1)
				ElseIf cNivel ==  "G" .AND.  (Upper(AllTrim(aUsrRet[1,13])) <> Upper("Gerente de Producao"))
					MyMsg("Usuario não é GERENTE",1)
				Else
					cSuperv:= cGetSup
					lAjusteOk := .T.
				EndIf
			EndIf
		Else
			MyMsg("Usuario nao encontrado",1)
			Return .F.
		EndIf
	Endif
Endif


Return .T.

/*/______________________{}_____________________
|---------------------------------------------------------|
author: Ricardo Roda
Data: 20/12/2019
|---------------------------------------------------------|
__________________________________________________________
/*/
Static Function fVldEtqSup(cEtiAj,cConfEtiAj)

Local lRet:= .F.

iF Empty(alltrim(cConfEtiAj))
	MyMsg("informe o codigo da etiqueta",1)
Else
	If alltrim(cEtiAj) == alltrim(cConfEtiAj)
		@ 059, 420 BITMAP oBitmapSup SIZE 100, 098 OF oDlgSup FILENAME cCerto NOBORDER PIXEL
		lRet:= .T.
	Else
		MyMsg("código da etiqueta informada é diferente da etiqueta em uso",1)
		@ 059, 420 BITMAP oBitmapSup SIZE 100, 098 OF oDlgSup FILENAME cErro NOBORDER PIXEL
	Endif
Endif

oBitmapSup:Refresh()
Return lRet

/*/______________________{}_____________________
|---------------------------------------------------------|
author: Ricardo Roda
Data: 20/12/2019
|---------------------------------------------------------|
__________________________________________________________
/*/
static Function fButtCel()
/*
Local oCelCort1
Local oCelCort2
Local oCelCort3
Local oCelCort4
Local oCelCort5
Local oCelCort6

Local oFont1 := TFont():New("Arial",,050,,.T.,,,,,.F.,.F.)
Static oDlgBtC

Local cCSSBtN1 :="QPushButton{background-color: #f6f7fa; color: #707070; font: bold 22px Arial; }"+;
"QPushButton:pressed {background-color: #50b4b4; color: white; font: bold 22px  Arial; }"+;
"QPushButton:hover {background-color: #878787 ; color: white; font: bold 22px  Arial; }"

DEFINE MSDIALOG oDlgBtC TITLE "Escolha a célula de trabalho" FROM 000, 000  TO 350, 800 COLORS 0, 16777215 PIXEL
@ 033, 040 BUTTON oCelCort1 PROMPT "CORTE 1" SIZE 150, 053 OF oDlgBtC ACTION (nCelula := 1, oDlgBtc:end() ) FONT oFont1 PIXEL
oCelCort1:setCSS(cCSSBtN1)
@ 033, 212 BUTTON oCelCort2 PROMPT "CORTE 2" SIZE 150, 053 OF oDlgBtC ACTION (nCelula := 2, oDlgBtc:end()) FONT oFont1 PIXEL
oCelCort2:setCSS(cCSSBtN1)
@ 110, 040 BUTTON oCelCort3 PROMPT "CORTE 3" SIZE 150, 053 OF oDlgBtC ACTION (nCelula := 3, oDlgBtc:end()) FONT oFont1 PIXEL
oCelCort3:setCSS(cCSSBtN1)
@ 110, 212 BUTTON oCelCort4 PROMPT "CORTE 4" SIZE 150, 053 OF oDlgBtC ACTION (nCelula := 4, oDlgBtc:end()) FONT oFont1 PIXEL
oCelCort4:setCSS(cCSSBtN1)

ACTIVATE MSDIALOG oDlgBtC CENTERED
*/
	nCelula := 4
Return nCelula
/*/______________________{}_____________________
	|---------------------------------------------------------|
	author: Ricardo Roda
	Data: 20/12/2019
	|---------------------------------------------------------|
	__________________________________________________________
/*/
Static function  ftelaOp (nCelTrab)
	Local oFont4c := TFont():New("Arial",,028,,.T.,,,,,.F.,.F.)
	Local cVar     := Nil

	Static oDlg2
	Private aVetor
	Private oLbx := {}

	aVetor:= fMSNewG2(nCelTrab)

//+-----------------------------------------------+
//| Monta a tela para usuario visualizar consulta |
//+-----------------------------------------------+
	If Len(aVetor ) == 0
		mymsg( "Nao há programações para 'CORTE "+cValToChar(nCelula)+"' ",1 )
		Return .T.
	Endif

	DEFINE MSDIALOG oDlg2 TITLE "Sequênciamento de Produção" FROM 0,0 TO 600,800 PIXEL

	@ 05,05 LISTBOX oLbx VAR cVar FIELDS HEADER;
		"","Ordens de Produção","Código do Produto","Quantidade OP","Quantidade Cortada" ;
		SIZE 395,294 OF oDlg2  FONT oFont4c  PIXEL ColSizes 02,20,120,50,50;
		ON dblClick(cCodOP:=  aVetor[oLbx:nAt,2],Odlg2:end())
	oLbx:SetArray( aVetor )
	oLbx:bLine := {|| {oOk,aVetor[oLbx:nAt,2],aVetor[oLbx:nAt,3],aVetor[oLbx:nAt,4],aVetor[oLbx:nAt,5]}}

	cCodOP:= aVetor[1,2]
	oCodOP:Refresh()
	oCFibra:SetFocus()

//@ 205, 050 BUTTON oButton1 PROMPT "OK" SIZE 083, 035 OF oDlg2 action (oDlg2:end()) FONT oFont1 PIXEL

	ACTIVATE MSDIALOG oDlg2 CENTERED

Return

/*/______________________{}_____________________
	|---------------------------------------------------------|
	author: Ricardo Roda
	Data: 20/12/2019
	|---------------------------------------------------------|
	__________________________________________________________
/*/
Static Function fMSNewG2(nCelTrab)
	Local aDados3:={}


	IF SELECT ("QRYZ") > 0
		QRYZ->(DBCLOSEAREA( ))
	endif

	cQuery:= " SELECT D4_OP ,D4_COD ,QTDD4 ,QTDD3,P10_DTPROG DT_PROG, P10_SQCORT SEQUENCIA    FROM ( "
	cQuery+= " SELECT P10_DTPROG, P10_SQCORT, D4_OP, D4_COD, "
	cQuery+= " ROUND(ISNULL(SUM(CASE WHEN D3_CF='RE4' THEN -D3_QUANT ELSE +D3_QUANT END),0) ,6)AS QTDD3,  "
	cQuery+= " ROUND(D4_QTDEORI,6) QTDD4  "
	cQuery+= " FROM "+RetSqlName("SD4")+" SD4  "
	cQuery+= " LEFT JOIN "+RetSqlName("SD3")+" SD3 ON D3_XXOP = D4_OP  "
	cQuery+= " AND D3_COD = D4_COD  "
	cQuery+= " AND D3_LOCAL   = '97'  "
	cQuery+= " AND D3_ESTORNO = ''   "
	cQuery+= " AND D3_CF IN ('DE4','RE4')  "
	cQuery+= " AND D3_FILIAL ='"+xFilial("SD3")+"' "
	cQuery+= " AND SD3.D_E_L_E_T_ = ''   "
	cQuery+= " INNER JOIN "+RetSqlName("P10")+" P10  ON P10_FILIAL = '"+xFilial("P10")+"' "
	cQuery+= " AND P10_OP = D4_OP  "
	cQuery+= " AND P10_MAQUIN = 'CORTE "+cValToChar(nCelTrab)+"' "
	cQuery+= " AND P10_FIBRA = D4_COD "
	cQuery+= " AND P10.D_E_L_E_T_ = ''  "
	cQuery+= " WHERE D4_FILIAL = '"+xFilial("SD4")+"' "
	cQuery+= " AND SD4.D_E_L_E_T_ = ''  "
	cQuery+= " GROUP BY D4_OP,D4_COD, D3_XXOP,D4_QTDEORI,P10_SQCORT,P10_DTPROG)  "
	cQuery+= " AS TAB  "
	cQuery+= " WHERE  QTDD3 < QTDD4 "
	cQuery+= " ORDER BY 5,6 "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRYZ",.T.,.T.)

	If !QRYZ->(eof())
		While QRYZ->(!eof())
			dbSelectArea("SC2")
			SC2->(dbSetOrder(1))
			if SC2->(dbSeek(xFilial("SC2")+QRYZ->D4_OP))
				IF EMPTY(SC2->C2_DATRF)
					aAdd( aDados3,{.T.,QRYZ->D4_OP,QRYZ->D4_COD ,QRYZ->QTDD4 ,QRYZ->QTDD3 })
				Endif
			Endif
			QRYZ->(dbSkip())
		Enddo
	Endif

Return (aDados3)

/*/______________________{}_____________________
	|---------------------------------------------------------|
	author: Ricardo Roda
	Data: 20/12/2019
	|---------------------------------------------------------|
	__________________________________________________________
/*/
Static Function fLocImp(nCel)
	Local cQuery:= ""
	Local cFila:= ""
	Local cMaq:= ""

	IF SELECT ("QCB5") > 0
		QCB5->(DBCLOSEAREA())
	ENDIF

	If nCel <= 4
		cMaq:= "'CORTE "+cValTochar(nCel)+"' "
	Elseif nCel == 5
		cMaq:= "'TRUNK 1'"
	Elseif nCel == 6
		cMaq:= "'DROP 1'"
	Endif

	cQuery:= " SELECT TOP 1 CB5_CODIGO FROM "+RETSQLNAME("CB5")+" "
	cQuery+= " WHERE CB5_DESCRI = "+cMaq+"  "
	cQuery+= " AND CB5_FILIAL = '"+xFilial("CB5")+"' "
	cQuery+= " AND D_E_L_E_T_ = '' "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QCB5",.T.,.T.)

	IF QCB5->(!EOF())
		cFila := QCB5->CB5_CODIGO
	else
		MyMsg("Local de impressão "+cMaq+" não identificado", 1)
	ENDIF

	IF SELECT ("QCB5") > 0
		QCB5->(DBCLOSEAREA())
	ENDIF

Return cFila


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



Static Function fReqMOD(cCodOP,nQtdMod,nApont)
	Local cQuery:= ""
	Local cTPMovimento:= "580"
	Local ExpA1 := {}
	Local ExpN2 := 3
	Local nQtd 	   := 0
	Local cProd	   := ""
	Local cUnidade     := ""
	Local cArmazem     := ""
	Local dEmissao     := ""
	Local _cDoC2     := U_NEXTDOC()
	Local lMsErroAuto := .F.


	cQuery:= " SELECT D4_COD, D4_QTDEORI, D4_QUANT, D4_LOCAL FROM "+RETSQLNAME("SD4")+" SD4"
	cQuery+= " WHERE D4_OP = '"+cCodOP+"' "
	cQuery+= " AND D4_COD = '50010100CORTE' "// MOD de corte chumbada
	cQuery+= " AND D4_QTDEORI > 0 "
	cQuery+= " AND D4_FILIAL = '"+xFilial("SD4")+"' "
	cQuery+= " AND SD4.D_E_L_E_T_ = '' "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)

	if QRY->(!eof())
		cProd := QRY->D4_COD
		cUnidade := Posicione("SB1",1,xFilial("SB1")+cProd,"B1_UM")
		cArmazem := QRY->D4_LOCAL
		dEmissao := dDataBase
		nQtd:= ((QRY->D4_QTDEORI/nQtdOp) * nApont)/ (Len(oGetDados:Acols))

		ExpA1 := {}

		aadd(ExpA1,{"D3_COD"     ,cProd		   ,Nil})
		aAdd(ExpA1,{"D3_OP"  	 ,cCodOp       ,Nil})
		aadd(ExpA1,{"D3_TM"      ,cTPMovimento ,Nil})
		aadd(ExpA1,{"D3_LOCAL"   ,cArmazem	   ,Nil})
		aadd(ExpA1,{"D3_QUANT"   ,nQtd		   ,Nil})
		aadd(ExpA1,{"D3_EMISSAO" ,dEmissao	   ,Nil})
		aAdd(ExpA1,{"D3_DOC"     ,_cDoc2   	   ,Nil})
		aAdd(ExpA1,{"D3_XXOP"     ,cCodOp   	   ,Nil})


		MSExecAuto({|x,y| mata240(x,y)},ExpA1,ExpN2)

		If !lMsErroAuto
			ConOut("Incluido com sucesso! "+cTPMovimento)
		Else
			MostraErro("\UTIL\LOG\")
		EndIf

	ELSE
		MyMsg("Código da MOD não encontrado para essa OP " ,1)
	Endif

Return
