#Include "PROTHEUS.CH"
#INCLUDE "FWBROWSE.CH"

/*/{Protheus.doc} DOMCORT
//TODO Corte de Fibras do processo produtivo de cabos
@author Ricardo Roda
@since 20/09/2018
@version undefined
@example
(examples)
@see (links_or_references)
/*/
User Function DOMCORT()
 
	Private oApont, oBitmap1, oButton1,oButton2,oButton3,oButton4,oButton5,oCFibra, oCodOP, oCodPA, oEtiq, oLoteCtl, oNFibra, oNomePA, oStatus, oQtdOp, oQtdProd, oQtdRest
	Private oGroup1, oGroup2, oSay1, oSay2, oSay3, oSay4, oSay5, oSay6, oSay7, oSay8, oSay9, oSay10, oSay11, oSay12,oSay13,oSay14,oSay15,oSay16
	Private oQtdTOp, oTamCort, oTamRolo, oQtdAProd, oTotMtrs, oPrevCort, oEmCort, oSButton1,oNomePA2,oGroup2, oResMtrs,oQtdSD3
	Private nQtdOp 	:= 0
	Private nResMtrs	:= 0
	Private nQtdProd 	:= 0
	Private nQtdRest 	:= 0
	Private nQtdSd3	:= 0
	Private nTamCort 	:= 0
	Private nTamRolo 	:= 0
	Private nTotMtrs 	:= 0
	Private nApont 	:= 0
	Private nQtdTOp  	:= 0
	Private nQtdAProd	:= 0
	Private nPrevCort	:= 0
	Private nEmCort	:= 0
	Private nEtqFOFS	:= 0
	Private ENTER		:= CHR(13)+CHR(10)
	private oFont14 	:= TFont():New("Arial",,022,,.F.,,,,,.F.,.F.)
	private oFont16 	:= TFont():New("Arial",,024,,.F.,,,,,.F.,.F.)
	private oFont16AZ	:=	TFont():New("Arial",,024,,.F.,,,,,.F.,.F.)
	private oFont18 	:=	TFont():New("Arial ",,026,,.F.,,,,,.F.,.F.)
	private oFont20B	:=	TFont():New("Arial Black",,026,,.T.,,,,,.F.,.F.)
	private oFont36 	:= TFont():New("Arial Black",,044,,.T.,,,,,.F.,.F.)
	private oFont36AZ	:=	TFont():New("Arial Black",,044,,.T.,,,,,.F.,.F.)
	private oFont44B	:= TFont():New("Arial Black",,052,,.T.,,,,,.F.,.F.)
	private oFont96B	:= TFont():New("Arial",,110,,.T.,,,,,.F.,.F.)
	private oFont1 	:= TFont():New("MS Sans Serif",,016,,.F.,,,,,.F.,.F.)
	private cCodOP 	:= SPACE(12)
	private cCodPA 	:= CriaVar("B1_COD")
	private cNomePA 	:= CriaVar("B1_DESC")
	private cNomePA2 	:= CriaVar("B1_DESC")
	private cEtiq 		:= SPACE(15)
	Private cEtiqAtu	:= SPACE(15)
	private cCFibra 	:= CriaVar("B1_COD")
	private cNFibra 	:= CriaVar("B1_DESC")
	private cLoteCtl 	:= CriaVar("B8_LOTECTL")
	private cStatus 	:= ""
	Private cEtiqOfc 	:= SPACE(15)
	Private oLbx, cTeste
	private lEtqval	:= .F.
	Private aLbx 		:={}
	Private cHrIni		:= ""
	Private cPerg		:="U_DOMCORTE"
	Private cStartPath:= GetSrvProfString('Startpath','')
	Private aAux 		:= {LoadBitmap( GetResources(), "BR_VERMELHO"),LoadBitmap( GetResources(), "BR_AMARELO"),LoadBitmap( GetResources(), "BR_VERDE"),LoadBitmap( GetResources(), "BR_PRETO")}
	Private oBitmap10
	Private oBitmapSup
	Private cSuperv	:= ""
	Private oQtVias
	Private nQtVias   	:= 1
	Private nQtViaFS	:= 1
	Private cSenhaC := SPACE(20)
	Private cGetSup:= SPACE(20)
	Private cUserSis	:= Upper(Alltrim(Substr(cUsuario,7,15)))
	Private lAjusteOk := .F.
	Private nQtAjusM := criavar("D3_QUANT")
	Private nCelula	:= 0
	Private oQtAjusM
	Private  oImg
	Private cLocImp:= ""
	Private cArm:= ""
	Private cLocaliz:= ""
	Private lPerda:= ".F."
	Private aOPs:={}
	Private cCodFuruk:= ""
	Private lFurukawa:= .F.
	Private nTamPro  := TamSX3("ZZ4_PROD")[1]
	cFileErro			:= cStartPath + 'errado.PNG'
	cFileok				:= cStartPath + 'certo.png'
	cFileLogo			:= cStartPath + 'logo.png'
	cFileAten			:= cStartPath + 'Atencao.png'
	cFileInter			:= cStartPath + 'Interroga.png'

	Static oDlg

	nCelula:= fButtCel()
	cLocImp:= fLocImp(nCelula)

//TELA
	DEFINE MSDIALOG oDlg TITLE "Corte de Fibra" FROM 0, 0  TO 800, 1250 COLORS 0, 16777215 PIXEL
//@ 002, 006 BITMAP oBitmap1 SIZE 126, 040 OF oDlg FILENAME cFileLogo NOBORDER PIXEL
//@ 000, 256 SAY oSay1 PROMPT "Corte de Fibra" SIZE 251, 041 OF oDlg FONT oFont44B COLORS 0, 16777215 PIXEL
	@ 014, 135 GROUP oGroup1 TO 197,540 OF oDlg COLOR 0, 16777215 PIXEL
	@ 014, 009 GROUP oGroup2 TO 270,130 OF oDlg COLOR 0, 16777215 PIXEL

	@ 015, 139 SAY oSay10 PROMPT "Ordem de produção" 	SIZE 090, 016 OF oDlg FONT oFont16AZ COLORS 16711680, 16777215 PIXEL
	@ 027, 139 BUTTON oButton2 PROMPT "OP"  SIZE 020, 018 OF oDlg ACTION (Processa( {||ftelaOp (nCelula),fVldOp(1)})) FONT oFont14 PIXEL
	@ 027, 159 MSGET oCodOP VAR cCodOP 					SIZE 070, 016 OF oDlg VALID fVldOp(1) PICTURE "@!" COLORS 16711680, 16777215 FONT oFont16AZ PIXEL //WHen .F.


	@ 015, 230 SAY oSay9 PROMPT "Prod.Acabado - PA" 	SIZE 120, 016 OF oDlg FONT oFont16 COLORS 0, 16777215 PIXEL
	@ 027, 230 MSGET oCodPA   VAR cCodPA 				SIZE 120, 016 OF oDlg PICTURE "@!" COLORS 0, 16777215 FONT oFont16 PIXEL WHen .F.
	@ 015, 350 SAY oSay13 PROMPT "Qtd.PA" 			    SIZE 090, 016 OF oDlg FONT oFont16 COLORS 0, 16777215 PIXEL
	@ 027, 350 MSGET oQtdAProd VAR nQtdOp  				SIZE 090, 016 OF oDlg PICTURE "@E 999,999"  COLORS 0, 16777215 FONT oFont16 PIXEL WHen .F.
	@ 015, 440 SAY oSay13 PROMPT "Qtd.Paga(SD3)" 		SIZE 070, 010 OF oDlg FONT oFont16 COLORS 0, 16777215 PIXEL
	@ 027, 440 MSGET oQtdSD3 VAR nQtdSD3 				SIZE 092, 016 OF oDlg PICTURE "@E 999,999"  COLORS 0, 16777215 FONT oFont16 PIXEL WHen .F.


	@ 045, 139 SAY oNomePA PROMPT alltrim(Substring(cNomePA,1,33))	SIZE 450, 050 OF oDlg FONT oFont36 COLORS 0, 16777215 PIXEL
	@ 060, 139 SAY oNomePA2 PROMPT alltrim(Substring(cNomePA,34,33))SIZE 450, 050 OF oDlg FONT oFont36 COLORS 0, 16777215 PIXEL

	@ 088, 139 SAY oSay12 PROMPT "Etiqueta" 			SIZE 117, 012 OF oDlg FONT oFont16AZ COLORS 16711680, 16777215 PIXEL
	@ 100, 139 MSGET oEtiq 	  VAR cEtiqOfc 				SIZE 160, 016 OF oDlg PICTURE "@!" VALID (!Empty(@cCodOP),fVldEti(@cEtiqOfc)) COLORS 16711680, 16777215 FONT oFont16AZ F3 "SB1" PIXEL
	@ 088, 299 SAY oSay7 PROMPT "Código da Fibra" 		SIZE 142, 014 OF oDlg FONT oFont16 COLORS 0, 16777215 PIXEL
	@ 100, 299 MSGET oCFibra  VAR cCFibra 				SIZE 146, 016 OF oDlg PICTURE "@!" COLORS 0, 16777215 FONT oFont16 PIXEL WHen .F.
	@ 088, 444 SAY oSay13 PROMPT "Qtd.Rolo" 			SIZE 070, 010 OF oDlg FONT oFont16 COLORS 0, 16777215 PIXEL
	@ 100, 444 MSGET oTamRolo VAR nTamRolo 				SIZE 092, 016 OF oDlg PICTURE "@E 999,999.999" COLORS 0, 16777215 FONT oFont16 PIXEL WHen .F.

	@ 115, 139 SAY oNFibra PROMPT alltrim(Substring(cNFibra,1,33))	SIZE 450, 050 OF oDlg FONT oFont36 COLORS 0, 16777215 PIXEL
	@ 131, 139 SAY oNFibra PROMPT alltrim(Substring(cNFibra,34,33))	SIZE 450, 050 OF oDlg FONT oFont36 COLORS 0, 16777215 PIXEL

//@ 168, 139 SAY oSay8 PROMPT "Lote" 				SIZE 070, 012 OF oDlg FONT oFont16 COLORS 0, 16777215 PIXEL
//@ 178, 139 MSGET oLoteCtl VAR cLoteCtl 			SIZE 070, 016 OF oDlg PICTURE "@!" COLORS 0, 16777215 FONT oFont16 PIXEL WHen .F.
	@ 158, 139 SAY oSay11 PROMPT "Mtrs. Unidade" 		SIZE 090, 016 OF oDlg FONT oFont16 COLORS 0, 16777215 PIXEL
	@ 168, 139 MSGET oTamCort VAR nTamCort 				SIZE 090, 016 OF oDlg PICTURE "@E 999,999.9999" COLORS 0, 16777215 FONT oFont16 PIXEL WHen .F.
	@ 158, 230 SAY oSay13 PROMPT "Restante Mtrs."    	SIZE 090, 016 OF oDlg FONT oFont16 COLORS 0, 16777215 PIXEL
	@ 168, 230 MSGET oResMtrs VAR nResMtrs 				SIZE 090, 016 OF oDlg PICTURE "@E 999,999.9999" COLORS 0, 16777215 FONT oFont16 PIXEL WHen .F.
	@ 158, 320 SAY oSay13 PROMPT "Total em Mtrs." 		SIZE 090, 016 OF oDlg FONT oFont16 COLORS 0, 16777215 PIXEL
	@ 168, 320 MSGET oTotMTrs VAR nTotMtrs 				SIZE 090, 016 OF oDlg PICTURE "@E 999,999.9999" COLORS 0, 16777215 FONT oFont16 PIXEL WHen .F.
	@ 158, 410 SAY oSay16 PROMPT "Numero de Vias" 		SIZE 090, 016 OF oDlg FONT oFont16 COLORS 0, 16777215 PIXEL
	@ 168, 410 MSGET oQtVias VAR nQtViaFS				SIZE 090, 016 OF oDlg PICTURE "@E 999,999.9999" COLORS 0, 16777215 FONT oFont16 PIXEL WHen .F.


	@ 030, 015 SAY oSay2 PROMPT "Qtd.Total" 			SIZE 110, 012 OF oDlg FONT oFont16 COLORS 0, 16777215 PIXEL
	@ 040, 015 MSGET oQtdOp VAR nQtdOp 					SIZE 110, 025 OF oDlg PICTURE "@E 999,999" COLORS 0, 16777215 FONT oFont36 PIXEL WHen .F.
	@ 070, 015 SAY oSay3 PROMPT "Qtd.Cortada"		 	SIZE 110, 012 OF oDlg FONT oFont16 COLORS 0, 16777215 PIXEL
	@ 080, 015 MSGET oQtdProd VAR nQtdProd 				SIZE 110, 025 OF oDlg PICTURE "@E 999,999" COLORS 0, 16777215 FONT oFont36 PIXEL WHen .F.
	@ 110, 015 SAY oSay4 PROMPT "Qtd. Restante" 		SIZE 110, 012 OF oDlg FONT oFont16 COLORS 0, 16777215 PIXEL
	@ 120, 015 MSGET oQtdRest VAR nQtdRest 				SIZE 110, 025 OF oDlg PICTURE "@E 999,999" COLORS 0, 16777215 FONT oFont36 PIXEL WHen .F.

	@ 150, 015 SAY oSay14 PROMPT "Previsão Corte" 		SIZE 110, 012 OF oDlg FONT oFont16 COLORS 0, 16777215 PIXEL
	@ 160, 015 MSGET oPrevCort VAR nPrevCort 			SIZE 080, 025 OF oDlg valid (iif(nPrevCort > nQtdRest, (MyMsg("Previsão maior que quantidade restante",1),nPrevCort:= 0) , nPrevCort)) PICTURE "@E 9,999" COLORS 0, 16777215 FONT oFont36 PIXEL
	@ 190, 015 SAY oSay15 PROMPT "Em Corte"		 		SIZE 110, 012 OF oDlg FONT oFont16 COLORS 0, 16777215 PIXEL
	@ 200, 015 MSGET oEmCort VAR nEmCort 				SIZE 080, 025 OF oDlg  COLORS 0, 16777215 FONT oFont36 PIXEL WHen .F.
	@ 230, 015 SAY oSay5 PROMPT "Corte Concluido" 		SIZE 110, 012 OF oDlg FONT oFont16AZ COLORS 16711680, 16777215 PIXEL
	@ 240, 015 MSGET oApont VAR nApont 					SIZE 080, 025 OF oDlg  COLORS 16711680, 16777215 FONT oFont36AZ PIXEL VALID oEtiq:SetFocus()


//@ 023, 550 MSGET oStatus  VAR cStatus 			SIZE 080, 078 OF oDlg PICTURE "@!" COLORS 16711680, 16777215 FONT oFont96B PIXEL  WHen .F.
	@ 115, 545 BUTTON oButton5 PROMPT "Excluir Etiq." 	SIZE 070, 025 OF oDlg ACTION (fExclEti() ) FONT oFont14 PIXEL
	if nCelula == 7
		@ 140, 545 BUTTON oButton5 PROMPT "Fibra Falsa" 	SIZE 070, 025 OF oDlg ACTION ( fImpEtqFF()) FONT oFont14 PIXEL
	Endif
//@ 140, 545 BUTTON oButton5 PROMPT "Limpa Tudo" 	SIZE 070, 025 OF oDlg ACTION (oDlg:End(), u_DOMCORT()) FONT oFont14 PIXEL
	@ 165, 545 BUTTON oButton1 PROMPT "Sair" 			SIZE 070, 025 OF oDlg ACTION (oDlg:End()) FONT oFont16 PIXEL

	@ 160, 095 BUTTON oButton2 PROMPT "Iniciar" 		SIZE 030, 027 OF oDlg ACTION (fCortIni(),MontaaLbx() ) FONT oFont14 PIXEL
	@ 200, 095 BUTTON oButton4 PROMPT "Zerar" 			SIZE 030, 027 OF oDlg ACTION (fZera() ) FONT oFont14 PIXEL
	@ 240, 095 BUTTON oButton3 PROMPT "Concluir" 		SIZE 030, 027 OF oDlg ACTION (fVldApont(cCodOP,cCFibra,nApont), nApont:= 0 ) FONT oFont14 PIXEL

	aHeader := {}
	aCols   := {}
	AADD(aHeader,  {    ""            ,   "LEGENDA" 	,"@BMP" 					,01,0,""    ,"","C","","","","",".F."})
	AADD(aHeader,  {    "Nome"       ,    "NOMEUSR"   	,"@R" 					,15,0,""    ,"","C","","","","",".T."})
	AADD(aHeader,  {    "Fibra"       ,   "FIBRA"   	,"@R" 					,15,0,""    ,"","C","","","","",".T."})
	AADD(aHeader,  {    "Descrição"   ,   "DESC"    	,"@R" 					,40,0,""    ,"","C","","","","",".T."})
	AADD(aHeader,  {    "Qtd.Cortado" ,   "QTDUSR"  	,"@E 999,999" 			,07,0,""    ,"","N","","","","",".T."})
	AADD(aHeader,  {    "Qtd.Em Corte" ,  "QEMCRT"  	,"@E 999,999" 			,07,0,""    ,"","N","","","","",".T."})
	AADD(aHeader,  {    "Restante"    ,   "QTDRES"  	,"@E 999,999" 			,07,0,""    ,"","N","","","","",".T."})
	AADD(aHeader,  {    "Metros P/Unid." , "MTRSUN"  	,"@E 999,999.999" 	,12,0,""    ,"","N","","","","",".T."})
	AADD(aHeader,  {    "Restante Mtrs." , "MTRSRES"  	,"@E 999,999.999" 	,12,0,""    ,"","N","","","","",".T."})
	AADD(aHeader,  {    "Qtd.Total "       , "QTDTOP"  	,"@E 999,999" 			,07,0,""    ,"","N","","","","",".T."})
	AADD(aHeader,  {    "Total Mtrs."      , "MTRSTOT"  	,"@E 999,999.999" 	,12,0,""    ,"","N","","","","",".T."})
	AADD(aHeader,  {    "Qtd.Cortado Tot." , "QTDCOR"  	,"@E 999,999" 			,07,0,""    ,"","N","","","","",".T."})
	AADD(aHeader,  {    "Usuario"    	   , "USERAP"  	,"@R" 			 		,06,0,""    ,"","C","","","","",".T."})
//AADD(aHeader,  {    "Total Vias" 			   , "VIAS"  	,"@E 999,999" 			,07,0,""    ,"","N","","","","",".T."})

	oGetDados  := (MsNewGetDados():New( 200, 137 , 280 ,630,NIL ,"AlwaysTrue" ,"AlwaysTrue", /*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,"U_Ffieldok()",/*superdel*/,/*delok*/,oDlg,aHeader,aCols))

	DEFINE TIMER oTimer INTERVAL 30000 ACTION fAtualiza(oTimer,oGetDados) OF oDlg
	oTimer:Activate()

	ACTIVATE MSDIALOG oDlg CENTERED

Return


Static Function fAtualiza(oTimer,oGetDados)
	oTimer:DeActivate()
	MontaaLbx()
	oTimer:Activate()
Return


/*/{Protheus.doc} fVldOp
//TODO Valida a Ordem de produção
@author Ricardo Roda
@since 20/09/2018
@version undefined
@example
(examples)
@see (links_or_references)
/*/
Static Function fVldOp(nOpc)

	Local cQuery:= ""
	Local aLbx1:= {}
	Local oButtonA
	Local lRet:= .F.
	Local nQtTotOP:= 0

	nQtViaFS:= 1

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



		cCodPA:= SC2->C2_PRODUTO
		nQtdOp:= ROUND(SC2->C2_QUANT,4)

		lFurukawa:= IIf(nCelula == 6,fFurukawa(cCodOp),.F. )

		dbSelectArea("SB1")
		SB1->(dbSetOrder(1))

		//************ ajuste temporário*****************
		if empty(alltrim(cArm))
			cArm:= "97"
			cLocaliz := "97PROCESSO"
		Endif
		//**********************************************

		if SB1->(dbseek(xFilial("SB1")+alltrim(cCodPA)))
			cNomePA:= SB1->B1_DESC

			cQuery:= " SELECT * FROM "+RETSQLNAME("SD4")+" SD4"
			cQuery+= " INNER JOIN "+RETSQLNAME("SB1")+" SB1 ON B1_COD = D4_COD AND SB1.D_E_L_E_T_ = ''  AND B1_FILIAL = '"+xFilial("SB1")+"' "
			cQuery+= " AND B1_GRUPO IN ('FO','FOFS') "
			cQuery+= " WHERE D4_OP = '"+cCodOP+"' "
			// cQuery+= " AND D4_COD = '"+cCFibra+" ' "
			cQuery+= " AND D4_QTDEORI > 0 "
			cQuery+= " AND D4_LOCAL = '"+cArm+"' "
			cQuery+= " AND D4_FILIAL = '"+xFilial("SD4")+"' "
			cQuery+= " AND SD4.D_E_L_E_T_ = '' "
			//MemoWrite("VLDOP.sql",cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)


			While QRY->(!eof())
				nQtViaFS:= 1
				//Alteração para corte da fibra falsa
				//IF ALLTRIM(QRY->B1_GRUPO) == "FOFS"
				DbSelectArea("SG1")
				SG1->(DbSetOrder(1))
				If SG1->(DbSeek(xFilial("SG1")+PADR(QRY->D4_PRODUTO,TamSX3("D4_PRODUTO")[1])+QRY->D4_COD))
					If SG1->G1_XQTDVIA > 0
						nQtViaFS:= SG1->G1_XQTDVIA
						nQtdOp:= ROUND(SC2->C2_QUANT,4) * nQtViaFS
					ELSE
						nQtViaFS:= 1
						nQtdOp:= ROUND(SC2->C2_QUANT,4)
					ENDIF
					//nQtdOp:= QRY->D4_QTDEORI / SG1->G1_QUANT

				Endif

				If empty (nQtdOp)
					MyMsg("Quantidade da OP x Estrutura inválida! ",1)
					Return
				endif
				//Endif

				dbSelectArea("ZZ4")
				dbSetOrder(2)
				if !ZZ4->(dbSeek(xFilial("ZZ4")+Alltrim(QRY->D4_OP)+PADR(QRY->D4_COD,nTamPro)+PADR(__cUserId,8)+QRY->D4_LOCAL))
					ZZ4->(RecLock("ZZ4",.T.))
					ZZ4->ZZ4_FILIAL	 := xFilial("ZZ4")
					ZZ4->ZZ4_OP		 := QRY->D4_OP
					ZZ4->ZZ4_PROD	 := QRY->D4_COD
					ZZ4->ZZ4_QTCORT  := 0
					ZZ4->ZZ4_LOCAL   := cArm

					//IF ALLTRIM(QRY->B1_GRUPO) <> "FOFS"
					ZZ4->ZZ4_QTDORI  := nQtdOp
					//Else
					//	ZZ4->ZZ4_QTDORI  := nQtdOp * nQtViaFS
					//Endif

					ZZ4->ZZ4_QTDMTR  := ROUND(QRY->D4_QTDEORI,4) //ROUND(QRY->D4_QUANT,4)
					ZZ4->ZZ4_STATUS	 := "1"
					ZZ4->ZZ4_USER	 := __cUserId
					ZZ4->ZZ4_QTDUSR  := 0
					ZZ4->(MsUnlock())
				Endif

				// verificar
				cCFibra:= QRY->D4_COD
				dbSelectArea("ZZ4")
				ZZ4->(DbSetOrder(2))
				if ZZ4->(dbSeek(xFilial("ZZ4")+Alltrim(cCodOp)+PADR(alltrim(cCFibra),nTamPro)+PADR(__cUserId,8)+cArm))
					nQtdSD3:= fQtdSD3((ZZ4->ZZ4_QTDMTR/ZZ4->ZZ4_QTDORI))
				Endif

				if QRY->D4_QTDEORI > 0 //QRY->D4_QUANT > 0
					nQtTotOP+= QRY->D4_QTDEORI //QRY->D4_QUANT
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

	IF !fAnaliPg()
		MyMsg("Ordem de produção totalmente paga!" ,1)
		LimpaTudo()
		Return .F.
	Endif

Return lRet

/*/{Protheus.doc} MontaaLbx
//TODO  Retorna a ListBox com os itens da OP
@author Ricardo Roda
@since 20/09/2018
@version undefined
@example
(examples)
@see (links_or_references)
/*/
Static Function MontaaLbx()
	Local cQuery:= ""
	Local lRet:= .F.

	cQuery:= " SELECT ZZ4_OP,ZZ4_PROD,ZZ4_QTDORI,ZZ4_QTCORT,ZZ4_QTDMTR,ZZ4_STATUS,ZZ4_QEMCRT, ZZ4_USER , B1_DESC,ZZ4_QTDUSR, B1_GRUPO"
	cQuery+= " FROM "+RETSQLNAME("ZZ4")+" ZZ4"
	cQuery+= " INNER JOIN "+RETSQLNAME("SB1")+" SB1 ON B1_COD = ZZ4_PROD  AND SB1.D_E_L_E_T_ = '' "
	cQuery+= " AND B1_FILIAL = '"+xFilial("SB1")+"' "
	cQuery+= " WHERE ZZ4_OP = '"+cCodOP+"' "
	cQuery+= " AND ZZ4_LOCAL = '"+cArm+"' "
	cQuery+= " AND ZZ4_FILIAL = '"+xFilial("ZZ4")+"' "
	cQuery+= " AND ZZ4.D_E_L_E_T_ = '' "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY2",.T.,.T.)

	oGetDados:aCols := {}

	If !QRY2->(eof())
		While QRY2->(!eof())

			AADD(oGetDados:aCols,Array(Len(oGetDados:aHeader)+1))

			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'LEGENDA' })] :=  If(QRY2->ZZ4_QTCORT == 0 ,"BR_VERMELHO",If(QRY2->ZZ4_QTCORT <> QRY2->ZZ4_QTDORI,"BR_AMARELO","BR_VERDE"))
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'NOMEUSR' })] := UsrFullName ( ALLTRIM(QRY2->ZZ4_USER) )
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'FIBRA'   })] := QRY2->ZZ4_PROD
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'DESC'    })] := QRY2->B1_DESC
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'QTDUSR'  })] := QRY2->ZZ4_QTDUSR
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'QEMCRT'  })] := QRY2->ZZ4_QEMCRT
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'QTDTOP'  })] := QRY2->ZZ4_QTDORI
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'QTDRES'  })] := (QRY2->ZZ4_QTDORI - QRY2->ZZ4_QTCORT)
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'MTRSUN'  })]  := (QRY2->ZZ4_QTDMTR/QRY2->ZZ4_QTDORI)
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'MTRSRES'  })] := ((QRY2->ZZ4_QTDMTR/QRY2->ZZ4_QTDORI) * (QRY2->ZZ4_QTDORI - QRY2->ZZ4_QTCORT))
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'QTDCOR'  })] := QRY2->ZZ4_QTCORT
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'MTRSTOT'  })] := QRY2->ZZ4_QTDMTR
			oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'USERAP'  })]  := QRY2->ZZ4_USER
			oGetDados:aCols[Len(oGetDados:aCols),Len(oGetDados:aHeader)+1 ] := .F.
			QRY2->(DbSkip())
		EndDo
		lRet:= .T.
	Else
		AADD(oGetDados:aCols,Array(Len(oGetDados:aHeader)+1))

		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'LEGENDA' })] := ""
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'NOMEUSR' })] := ""
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| Alltrim(aVet[2]) == 'FIBRA'   })] := ""
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

	oGetDados:Refresh()

	QRY2->(dbCloseArea())

Return lRet

/*/{Protheus.doc} fVldEti
//TODO Valida o Codigo da Etiqueta na tabela XD1
@author Ricardo Roda
@since 20/09/2018
@version undefined
@example
(examples)
@see (links_or_references)
/*/
Static Function fVldEti(cEtiqOfc)
	Local cLocTemp   := "01CORTE"
	LOCAL cAlmoxTemp := "01"

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
	dbsetorder(1)
	if dbseek(xFilial("XD1")+cEtiq)
		lVelho := .F.
		If lVelho
			If XD1->XD1_OCORRE == "5"
				MyMsg("Essa etiqueta foi finalizada!",1 )
				cStatus := "XX"
				@ 023, 538 BITMAP oBitmap10 SIZE 100, 098 OF oDlg FILENAME cFileErro NOBORDER PIXEL

				cEtiq := SPACE(15)
				cEtiqOfc := SPACE(15)
				cCFibra := CriaVar("B1_COD")
				cNFibra := CriaVar("B1_DESC")
				cNFibra2 := CriaVar("B1_DESC")
				//cLoteCtl := CriaVar("B8_LOTECTL")
				nPrevCort := 0
				nEmCort   := 0
				nTamRolo  := 0
				lEtqval   := .F.
				oEtiq:Refresh()


				Return .F.
			ElseIF XD1->XD1_LOCALI <> cLocTemp .or. XD1->XD1_LOCAL <> cAlmoxTemp
				MyMsg("Etiqueta não transferida para produção Almox: " + cAlmoxTemp + " Endereço: "+ cLocTemp ,1)
				@ 023, 538 BITMAP oBitmap10 SIZE 100, 098 OF oDlg FILENAME cFileErro NOBORDER PIXEL
				cStatus := "XX"
				cEtiq := SPACE(15)
				cEtiqOfc := SPACE(15)
				cCFibra  := CriaVar("B1_COD")
				cNFibra  := CriaVar("B1_DESC")
				cLoteCtl := CriaVar("B8_LOTECTL")
				lEtqval:= .F.
				oEtiq:Refresh()
				oTamRolo:Refresh()
				Return .F.
			Else
				cCFibra  := Alltrim(XD1->XD1_COD)
				nTamRolo := XD1->XD1_QTDATU
				cLoteCtl := Alltrim(XD1->XD1_LOTECT)
				//	nPrevCort:= Posicione("SB1",1, xFilial("SB1")+cCFibra,"B1_XLOTPAD")

				dbSelectArea("ZZ4")
				ZZ4->(DbSetOrder(2))
				if ZZ4->(dbSeek(xFilial("ZZ4")+Alltrim(cCodOp)+PADR(alltrim(cCFibra),nTamPro)+PADR(__cUserId,8)+cArm))
					nQtdSD3:= fQtdSD3((ZZ4->ZZ4_QTDMTR/ZZ4->ZZ4_QTDORI))
				Endif

				MontaaLbx()

			Endif

		Else

			If XD1->XD1_LOCALI <> cLocTemp
				MyMsg("Etiqueta não transferida para produção "+ cLocTemp ,1)
				@ 023, 538 BITMAP oBitmap10 SIZE 100, 098 OF oDlg FILENAME cFileErro NOBORDER PIXEL
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
				//If XD1->XD1_OCORRE == "5"
				//   MyMsg("Essa etiqueta foi finalizada mas poderá continuar em uso",1 )
				//EndIf

				cCFibra  := Alltrim(XD1->XD1_COD)
				nTamRolo := XD1->XD1_QTDATU
				cLoteCtl := Alltrim(XD1->XD1_LOTECT)
				nPrevCort:= Posicione("SB1",1, xFilial("SB1")+cCFibra,"B1_XLOTPAD")

				dbSelectArea("ZZ4")
				ZZ4->(DbSetOrder(2))
				if ZZ4->(dbSeek(xFilial("ZZ4")+Alltrim(cCodOp)+PADR(alltrim(cCFibra),nTamPro)+PADR(__cUserId,8)+cArm))
					nQtdSD3:= fQtdSD3((ZZ4->ZZ4_QTDMTR/ZZ4->ZZ4_QTDORI))
				Endif

				MontaaLbx()

			Endif
		EndIf
	Else
		MyMsg("Etiqueta Invalida!",1)
		cStatus := "XX"
		@ 023, 538 BITMAP oBitmap10 SIZE 100, 098 OF oDlg FILENAME cFileErro NOBORDER PIXEL
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

	/************ALTERAÇÃO /nPos := aScan(oGetDados:aCols,{|x| x[2] == cCFibra })************/
		nPfibra := aScan(aHeader,{|aVet| Alltrim(aVet[2]) == "FIBRA"})
		nPID    := aScan(aHeader,{|aVet| Alltrim(aVet[2]) == "USERAP"})

		nPos := aScan(oGetDados:aCols,{|x| Alltrim(x[nPfibra]) == alltrim(cCFibra) .and. alltrim(x[nPID]) == Alltrim(__cUserId) })

		///  varrer o acols somando as quantidades por usuários
		If nPos > 0

			nQtdOp	:= oGetDados:aCols[nPos,ascan(aHeader,{|x| alltrim(x[2])=="QTDTOP"})]
			nQtdProd:= oGetDados:aCols[nPos,ascan(aHeader,{|x| alltrim(x[2])=="QTDCOR"})]
			nEmCort:= oGetDados:aCols[nPos,ascan(aHeader,{|x| alltrim(x[2])=="QEMCRT"})]
			oGetDados:aCols[nPos,ascan(aHeader,{|x| alltrim(x[2])=="QTDRES"})]:= (nQtdOp - nQtdProd)//-nQtdSD3
			nQtdRest:= oGetDados:aCols[nPos,ascan(aHeader,{|x| alltrim(x[2])=="QTDRES"})]

			nTamCort:= oGetDados:aCols[nPos,ascan(aHeader,{|x| alltrim(x[2])=="MTRSUN"})]
			oGetDados:aCols[nPos,ascan(aHeader,{|x| alltrim(x[2])=="MTRSRES"})]:= ((nQtdOp - nQtdProd)*nTamCort)//-(nQtdSD3 * nTamCort)
			nResMtrs := oGetDados:aCols[nPos,ascan(aHeader,{|x| alltrim(x[2])=="MTRSRES"})]
			nTotMtrs:= oGetDados:aCols[nPos,ascan(aHeader,{|x| alltrim(x[2])=="MTRSTOT"})]

			@ 023, 537 BITMAP oBitmap10 SIZE 100, 098 OF oDlg FILENAME cFileOk NOBORDER PIXEL
			cStatus := "OK"
			cEtiqAtu:= cEtiq
			lEtqval:= .T.

		Else
			MyMsg("Produto não encontrado na ordem de produção. Verifique!",1 )
			@ 023, 538 BITMAP oBitmap10 SIZE 100, 098 OF oDlg FILENAME cFileErro NOBORDER PIXEL
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
		@ 023, 538 BITMAP oBitmap10 SIZE 100, 098 OF oDlg FILENAME cFileErro NOBORDER PIXEL
		cStatus := "XX"
		cEtiq := SPACE(15)
		cCFibra := CriaVar("B1_COD")
		cNFibra := CriaVar("B1_DESC")
		cLoteCtl := CriaVar("B8_LOTECTL")
		lEtqval:= .F.
		Return .F.
	Endif


	nQtViaFS:= 1
	//Alteração para corte da fibra falsa
	DbSelectArea("SG1")
	SG1->(DbSetOrder(1))
	If SG1->(DbSeek(xFilial("SG1")+PADR(cCodPA,TamSX3("D4_PRODUTO")[1])+cCFibra))
		If SG1->G1_XQTDVIA > 0
			nQtViaFS:= SG1->G1_XQTDVIA
		ELSE
			nQtViaFS:= 1
		Endif
		nQtdOp:= ROUND(SC2->C2_QUANT,4) * nQtViaFS
	Endif
	nTamCort:= nTotMtrs/nQtdOp

	oTamCort:Refresh()
	oQtdOp:Refresh()
	oQtdProd:Refresh()
	oQtdRest:Refresh()
	oTamRolo:Refresh()
//oLoteCtl:Refresh()
	oApont:Refresh()
	oPrevCort:Refresh()
	oEmCort:Refresh()
	oQtdSD3:Refresh()
	oGetDados:Refresh()
	oQtVias:Refresh()


Return .T.


/*/{Protheus.doc} fCortIni
//TODO Valida lote padrão de corte
@author Ricardo Roda
@since 20/09/2018
@version undefined
@example
(examples)
@see (links_or_references)
/*/
Static Function fCortIni()
	Local lGrvLoteB1:= .T.
	Local nQtdEmCort:= fQtdEmCort()

	If !empty(cCodOp) .and. !empty(cCFibra) //.and. nEmcort = 0


		if (nPrevCort/3) <> Int(nPrevCort/3)
			lGrvLoteB1:= .F.
			iF !(MyMsg("O número "+cValtochar(nPrevCort)+" não é multiplo de 3"+Chr(13)+chr(10)+"Confirma mesmo assim a previsão de corte?" ,2))
				Return
			Endif
		Endif

		if ((Posicione("SB1",1, xFilial("SB1")+cCFibra,"B1_XLOTPAD") == 0 ) .or. (Posicione("SB1",1, xFilial("SB1")+cCFibra,"B1_XLOTPAD") <> nPrevCort) ) .and. nPrevCort > 0 .AND. lGrvLoteB1
			If MyMsg("Lote Padrão de corte diferente ou não cadastrado! "+chr(13)+chr(10)+"Deseja cadastrar "+cValtochar(nPrevCort)+" como lote padrão do produto?" , 2 )
				dbSelectArea("SB1")
				dbSetOrder(1)
				if SB1->(dbSeek(xFilial("SB1")+Alltrim(cCFibra)))
					SB1->(RecLock("SB1",.F.))
					SB1->B1_XLOTPAD := nPrevCort
					SB1->(MsUnlock())
				Endif
			Else
				Return
			Endif
		Endif
		dbSelectArea("ZZ4")
		dbSetOrder(2)
		if ZZ4->(dbSeek(xFilial("ZZ4")+Alltrim(cCodOp)+PADR(alltrim(cCFibra),nTamPro)+PADR(__cUserId,8)+cArm))

			//If nPrevCort > nQtdRest
			If (nPrevCort+nQtdEmCort) > nQtdRest
				MyMsg("Previsão de corte maior que a quantidade restante. Verifique!",1 )
				Return .F.
			Else
				ZZ4->(RecLock("ZZ4",.F.))
				ZZ4->ZZ4_QEMCRT := nPrevCort
				ZZ4->ZZ4_STATUS	:= "2"
				If Type("ZZ4->ZZ4_DTINI") <> 'U'
					ZZ4->ZZ4_DTINI := Date()
				EndIf
				ZZ4->ZZ4_HRINI	:= TIME()
				ZZ4->(MsUnlock())

				cHrIni:= ZZ4->ZZ4_HRINI
			Endif

			dbSelectArea("ZZ4")
			ZZ4->(DbSetOrder(2))
			if ZZ4->(dbSeek(xFilial("ZZ4")+Alltrim(cCodOp)+PADR(alltrim(cCFibra),nTamPro)+PADR(__cUserId,8)+cArm))
				nQtdSD3:= fQtdSD3((ZZ4->ZZ4_QTDMTR/ZZ4->ZZ4_QTDORI))
			Endif

		Endif
	Endif

//fVldOp(2)

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

	nApont:= nPrevCort
	nEmCort:= nPrevCort
	oEmCort:Refresh()
	oApont:Refresh()
	oGetDados:Refresh()

Return

/*/{Protheus.doc} fVldApont
//TODO Valida Apontamento
@author Ricardo Roda
@since 20/09/2018
@version undefined
@example
(examples)
@see (links_or_references)
/*/
Static Function fVldApont(cCodOp,cCFibra, nApont)

	Local nTransf:= 0
	Local lImpEti:= .F.
	Local nQtLbSup:= SuperGetMv("MV_XQTLSUP",.F.,0)
	Local _i


	If !empty(cCodOp) .and. !empty(cCFibra) .and. nApont > 0
		dbSelectArea("ZZ4")
		dbSetOrder(2)
		if ZZ4->(dbSeek(xFilial("ZZ4")+Alltrim(cCodOp)+PADR(alltrim(cCFibra),nTamPro)+PADR(__cUserId,8)+cArm))

			If (nApont > ZZ4->ZZ4_QEMCRT )
				MyMsg("Quantidade apontada excede a quantidade em Corte.",1)
				nApont:=0
				Return
			Endif

			If ((ZZ4->ZZ4_QTCORT + nApont)>ZZ4->ZZ4_QTDORI )
				MyMsg("Quantidade apontada excede o empenho.",1)
				nApont:=0
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

							if cArm == "96"
								SZA->(DbSetOrder(RetOrder("SZA",ZA_FILIAL+ZA_OP+ZA_PRODUTO)))
								IF SZA->(Dbseek("SZA",xFilial("SZA")+Alltrim(cCodOp)+PADR(alltrim(cCFibra),nTamPro)))
									Reclock("SZA",.F.)
									SZA->ZA_SALDO := (SZA->ZA_SALDO - nApont)
									SZA->( msUnlock() )
								else
									MYMSG("Perda não encontrada para atualização do status!",1)
								endif
							Endif

							dbSelectArea("ZZ4")
							ZZ4->(DbSetOrder(2))
							if ZZ4->(dbSeek(xFilial("ZZ4")+Alltrim(cCodOp)+PADR(alltrim(cCFibra),nTamPro)+PADR(__cUserId,8)+cArm))
								nQtdSD3:= fQtdSD3((ZZ4->ZZ4_QTDMTR/ZZ4->ZZ4_QTDORI))
							Endif


							nTamRolo := nTamRolo - (nApont * nTamCort)

							//*****    Lógica do fim de rolo    ***
							// Acerto = (nApont * nTamCort) - nTamRolo
							//1)Incluir quantidade com movimentação interna

							// Início alteração Hélio

							//If nTamRolo < 0
							//	nTamRolo := 0
							//EndIf

							nTransf  := (nApont * nTamCort)
							//2) Verificar rolo  e transferir quantidade apontada
							lImpEti := fTrfRolo(cCFibra,nTransf,cEtiq)


						/*
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Alteração realizada em 06/09/2019 para tratamento da   ³
						//³impressão da fibra falsa quando o produto pertencer ao ³
						//³grupo FOFS imprimir somente quando atigir 200 fibras   ³
						//³cortadas ou quando for o final da OP                   ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						*/
							If lImpEti
							/*if Posicione("SB1",1, xFilial("SB1")+cCFibra,"B1_GRUPO")== "FOFS"
								If ((nApont+nQtdProd)/200) == nEtqFOFS+1
									nEtqFOFS+= 1
									lImpEti:= .F.
								Endif
							Endif*/
							IF (nApont+nQtdProd) == nQtdOp
								lImpEti:= .T.
							Endif
						Endif
						
						// ALTERAÇÃO PARA IMPRIMIR APENAS QUANDO O APONTAMENTO FOR DA PRIMEIRA LINHA DA GETDADOS
						
						IF aScan(ogetdados:aCols,{ |x| x[GdFieldPos("FIBRA")] == cCFibra}) >= 2 .AND. Posicione("SB1",1, xFilial("SB1")+cCFibra,"B1_GRUPO")<> "FOFS"
							lImpEti:= .F.
						Endif
						
						//) imprimir etiquetas
						if lImpEti
							
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
							
							Len(cvaltochar(nQtdOp))
							
							if lFurukawa
								U_DOMETI02(cCodOP,nApont,_cNumSerie,cLocImp,cCodFuruk,Len(cvaltochar(nQtdOp)))
							Else
								U_DOMETI01(cCodOP,nApont,_cNumSerie,cLocImp)
							Endif
							_cPrxDoc:= fPrxDoc()
							For _i := 1 to nApont
								Reclock("XD4", .T.)
								XD4->XD4_FILIAL	:= xFilial("XD4")
								XD4->XD4_SERIAL	:= _cNumSerie
								XD4->XD4_STATUS	:= '6'
								XD4->XD4_OP	   	:= cCodOP
								XD4->XD4_NOMUSR	:= cUserSis
								XD4->XD4_DOC    := _cPrxDoc
								XD4->XD4_KEY 	:= iIf(lFurukawa,cvaltochar(_cNumSerie) + cCodFuruk,"S"+Alltrim(cCodOP)+Alltrim(cvaltochar(_cNumSerie)))
								XD4->(MsUnlock())
								_cNumSerie += 1
							Next _i
						Endif
						
					Else
						nApont:=0
						Return
					Endif
					
				Else
					nApont:=0
					Return
				Endif
			ElseIf  nTamRolo - (nApont * nTamCort) >= 0
				ZZ4->(RecLock("ZZ4",.F.))
				ZZ4->ZZ4_QTCORT += nApont
				ZZ4->ZZ4_QEMCRT := 0 //-= nApont
				ZZ4->ZZ4_STATUS	:= "2"
				ZZ4->ZZ4_QTDUSR += nApont
				ZZ4->(MsUnlock())

				if cArm == "96"
					SZA->(DbSetOrder(RetOrder("SZA",ZA_FILIAL+ZA_OP+ZA_PRODUTO)))	
					IF SZA->(Dbseek("SZA",xFilial("SZA")+Alltrim(cCodOp)+PADR(alltrim(cCFibra),nTamPro)))
						Reclock("SZA",.F.)
						SZA->ZA_SALDO := (SZA->ZA_SALDO - nApont)
						SZA->( msUnlock() )
					else
						MYMSG("Perda não encontrada para atualização do status!",1)
					endif
				Endif


				dbSelectArea("ZZ4")
				ZZ4->(DbSetOrder(2))
				if ZZ4->(dbSeek(xFilial("ZZ4")+Alltrim(cCodOp)+PADR(alltrim(cCFibra),nTamPro)+PADR(__cUserId,8)+cArm))
					nQtdSD3:= fQtdSD3((ZZ4->ZZ4_QTDMTR/ZZ4->ZZ4_QTDORI))
				Endif
				
				nTamRolo := nTamRolo - (nApont * nTamCort)
				nTransf  := (nApont * nTamCort)
				
				
				//2) Verificar rolo  e transferir quantidade apontada
				lImpEti := fTrfRolo(cCFibra,nTransf,cEtiq)
				
				/*
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Alteração realizada em 06/09/2019 para tratamento da   ³
				//³impressão da fibra falsa quando o produto pertencer ao ³
				//³grupo FOFS imprimir somente quando atigir 200 fibras   ³
				//³cortadas ou quando for o final da OP                   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				*/
								If lImpEti
					/*if Posicione("SB1",1, xFilial("SB1")+cCFibra,"B1_GRUPO")== "FOFS"
					If ((nApont+nQtdProd)/200) == nEtqFOFS+1
							nEtqFOFS+= 1
							lImpEti:= .F.
					Endif
				Endif*/
				IF (nApont+nQtdProd) == nQtdOp
						lImpEti:= .T.
				Endif
			Endif
				
				
				// ALTERAÇÃO PARA IMPRIMIR APENAS QUANDO O APONTAMENTO FOR DA PRIMEIRA LINHA DA GETDADOS
			IF  aScan(ogetdados:aCols,{ |x| x[GdFieldPos("FIBRA")] == cCFibra}) >= 2 .AND. Posicione("SB1",1, xFilial("SB1")+cCFibra,"B1_GRUPO")<> "FOFS"
					lImpEti:= .F.
			Endif
				
				
				//3) imprimir etiquetas
			if lImpEti
					
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
					
				if lFurukawa
						U_DOMETI02(cCodOP,nApont,_cNumSerie,cLocImp,cCodFuruk,Len(cvaltochar(nQtdOp)))
				Else
						U_DOMETI01(cCodOP,nApont,_cNumSerie,cLocImp)
				Endif
					
					_cPrxDoc:= fPrxDoc()
				For _i := 1 to nApont
						Reclock("XD4", .T.)
						XD4->XD4_FILIAL	:= xFilial("XD4")
						XD4->XD4_SERIAL	:= _cNumSerie
						XD4->XD4_STATUS	:= '6'
						XD4->XD4_OP	   	:= cCodOP
						XD4->XD4_NOMUSR	:= cUserSis
						XD4->XD4_DOC      := _cPrxDoc
						XD4->XD4_KEY 	:= iIf(lFurukawa,cvaltochar(_cNumSerie) + cCodFuruk,"S"+Alltrim(cCodOP)+Alltrim(cvaltochar(_cNumSerie)))
						XD4->(MsUnlock())
						_cNumSerie += 1
				Next _i
					
			Endif
		Endif
	Else
			MyMsg("Fibra "+Alltrim(cCFibra)+" não encontrada na OP:"+Alltrim(cCodOp),1)
	Endif
Endif
Endif

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

fVldEti(cEtiqOfc)

Return


/*/{Protheus.doc} MyMsg
//TODO Aviso Personalizado
@author Ricardo Roda
@since 20/09/2018
@version undefined
@example
(examples)
@see (links_or_references)
/*/
Static Function MyMsg(cAviso,nOpc)
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


/*/{Protheus.doc} fTrfRolo
//TODO Tranferencia do rolo para pagamento da produção
@author Ricardo Roda
@since 20/09/2018
@version undefined
@example
(examples)
@see (links_or_references)
/*/

Static Function fTrfRolo(cCFibra,nTransf,cEtiq)

	Local aVetor      := {}
	Local aEmpen      := {}
	Local lFimRolo    := .F.
	Local nFimRolo    := 0
	Local lMsErroAuto := .F.
	local lFofs	:= .T.

	Private cCusMed   := SuperGetMV('MV_CUSMED')
	Private aRegSD3   := {}
	Private dDtValid  := cTod("  /  /  ")
	Private cTmEnt    := GetMV('MV_XTMENT')
	Private cTmSai    := GetMV('MV_XTMSAI')

	PRIVATE cCadastro := "Transferencias"
	PRIVATE nPerImp   := CriaVar("D3_PERIMP")
	Private _cDoC     := U_NEXTDOC()


//Begin Transaction

	dbSelectArea("XD1")
	dbsetorder(1)
	if dbseek(xFilial("XD1")+cEtiq)
		//Dados para Transferencia
		nQtde      := nTransf
		cProduto   := XD1->XD1_COD 					//-- Codigo do Produto Origem    - Obrigatorio
		cLocOrig   := XD1->XD1_LOCAL			   	//-- Almox Origem                - Obrigatorio
		cLocDest   := cArm   					   	//-- Almox Destino               - Obrigatorio
		cDocumento := _cDoC      		    		   //-- Documento                   - Obrigatorio
		cNumLote   := "" 						       	//-- Sub-Lote                    - Obrigatorio se usa Rastro "S"
		cLoteCtl   := Alltrim(XD1->XD1_LOTECT)		//-- Lote                        - Obrigatorio se usa Rastro
		dDtValid   := fBuscaLote(cProduto,cLoteCtl,cLocOrig,nQtde) 	//-- Validade                    - Obrigatorio se usa Rastro
		cEndOrig   := Alltrim(XD1->XD1_LOCALI)		//-- Localizacao Origem
		cEndDest   := cLocaliz 						   //-- Endereco Destino            - Obrigatorio p/a Transferencia
		//lcontinua  :=  fSldLcaliz(cProduto,nQtde,cLocOrig,cEndOrig, cLoteCtl)
		cSerOrig   := ""				 			      //-- Numero de Serie
		cEtiqueta  := XD1->XD1_XXPECA

		//if lContinua
		// Ricardo incluir alteração

		//Alert("Tamanho do rolo depois da transferência: " + Str(nTamRolo) )
		//Alert("Quantidade da transferência: " + Str(nTransf) )

		nFimRolo := nTamRolo //- nTransf

		If nFimRolo > 0  // Se a quantidade do rolo não for suficiente, não precisa perguntar se é fim de rolo
			If MyMsg("É o final do rolo",2)

				AjustSup(cCFibra,cValtoChar(nTamRolo),(nApont * nTamCort),cNFibra,cEtiqOfc,"S" )
				if lAjusteOk
					lFimRolo:= .T.
				Else
					MYMSG("A Liberação da Supervisão foi recusada e por isso o ajute do rolo não será realizado!",1)
					lFimRolo:= .F.
				Endif
			Endif
		EndIf

		if nFimRolo > 0 .and. lFimRolo
			// movimento interno para zerar a quantidade do rolo

			//Alert("Quantidade do ajuste de baixa de saldo (requisição) " + Str(nFimRolo) )
			lContinua:= fAjusSld(cTmSai,cProduto,nFimRolo, cLocOrig,cEndOrig,cDocumento,cLoteCtl,dDtValid,cEtiqueta)

			//Zera Etiqueta
			Reclock("XD1", .F.)
			XD1->XD1_QTDATU := 0
			XD1->XD1_OCORRE := '5'
			XD1->(MsUnlock())

		Elseif nFimRolo <  0 //.and. !lFimRolo
			// movimento interno para ajustar quantidade do apontamento na posição
			// Hélio - Troquei a quantidade para nFimRolo. Estava nQtde, o que gerada ajustes a maior

			//Alert("Quantidade do ajuste de entrada de saldo (devolução) " + Str(nFimRolo*(-1)) )


			lContinua:=  fAjusSld(cTmEnt,cProduto,nFimRolo*(-1), cLocOrig,cEndOrig,cDocumento,cLoteCtl,dDtValid,cEtiqueta)

			//Inclui saldo na etiqueta
			Reclock("XD1", .F.)
			XD1->XD1_QTDATU := 0
			XD1->XD1_OCORRE := '5'
			XD1->(MsUnlock())

			nTamRolo := 0

		Elseif nFimRolo ==  0 //.and. !lFimRolo
			Reclock("XD1", .F.)
			XD1->XD1_QTDATU := 0
			XD1->XD1_OCORRE := '5'
			XD1->(MsUnlock())

		Else
			//Atualiza o saldo da etiqueta
			Reclock("XD1", .F.)
			XD1->XD1_QTDATU := XD1-> XD1_QTDATU -  nTransf
			XD1->(MsUnlock())
		Endif

		//Endif

		lcontinua  :=  fSldLcaliz(cProduto,nQtde,cLocOrig,cEndOrig, cLoteCtl)

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
// 




								Endif
							Endif

							if !lContinua .or. lMsErroAuto
								MyMsg("Erro na Transferência! "+chr(13)+chr(10)+"Procure o administrador do sistema.",1)
//	Disarmtransaction()
							Else
								dbSelectArea("SD3")
								SD3->( dbSetOrder(2) )  // D3_FILIAL + D3_DOC
								If SD3->( dbSeek( xFilial() + _cDoc ) )
									While !SD3->( EOF() ) .and. ALLTRIM(SD3->D3_DOC) == ALLTRIM(_cDoc)    //MLS ALTERADO MOTIVO DOCUMENTO COM 9 DIGITOS
										If SD3->D3_CF == 'RE4' .or. SD3->D3_CF == 'DE4'
											Reclock("SD3",.F.)
											SD3->D3_XXPECA  := XD1->XD1_XXPECA
											SD3->D3_XXOP    := cCodOP
											SD3->D3_XHRINI	 := cHrIni
											//SD3->D3_USUARIO := cUsuario
											SD3->D3_HORA    := Time()
											SD3->( msUnlock() )

										EndIf
										SD3->( dbSkip() )
									End

		/*/If Type("ZZ4->ZZ4_DTINI") <> 'U'
									nQtdMod:= fSubHr(Date(),cHrIni,ZZ4->ZZ4_DTINI,Time())  //Hrs2Min(ELAPTIME (cHrIni , Time()))
								else
									nQtdMod:= fSubHr(Date(),cHrIni,Date(),Time())
								EndIf
		*/

								//nQtdMod:= (SD4->D4_QTDORI / SC2->C2_QUANT ) * nApont
								nQtdMod:= 0
								//Denis 25/02/2021 - requisitar somente quando não for Fibra falsa
								lFofs := Posicione("SB1",1, xFilial("SB1")+cCFibra,"B1_GRUPO") <> "FOFS"

								if lFofs
									Processa( {|| fReqMOD(cCodOP,nQtdMod,nApont) },"Gravando MOD")
								Endif

							Endif

						Endif

//End transaction

						if Posicione("SB1",1, xFilial("SB1")+cCFibra,"B1_GRUPO") == 'FOFS'
							lContinua:= .F.
						Endif

						Return lContinua

/*/{Protheus.doc} fBuscaLote
//TODO valida se o lote é existente
@author Ricardo Roda
@since 20/09/2018
@version undefined
@example
(examples)
@see (links_or_references)
/*/
Static Function fBuscaLote(cCod,cLote,cLocal)

	Local  cQuery:= ""

	iF !Empty(Alltrim(cLote))

		IF SELECT("QRY") > 0
			QRY->(dbCloseArea())
		Endif

		cQuery:= " SELECT TOP 1 B8_DTVALID FROM "+RetSqlName("SB8")+" SB8"
		cQuery+= " WHERE B8_LOTECTL = '"+cLote+"'
		cQuery+= " AND B8_PRODUTO = '"+cCod+"'
		cQuery+= " AND B8_LOCAL = '"+cLocal+"'
		cQuery+= " AND B8_FILIAL = '"+xFilial("SB8")+"' "
		cQuery+= " AND D_E_L_E_T_ = ''
		//cQuery :=ChangeQuery(cQuery)
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

/*/{Protheus.doc} fSldLcaliz
//TODO Valida saldo no endereço
@author Ricardo Roda
@since 20/09/2018
@version undefined
@example
(examples)
@see (links_or_references)
/*/
Static Function fSldLcaliz(cProduto,nQtde,cLocOrig,cEndOrig, cLoteCtl)

	Local  cQuery:= ""
	Local lRet:= .T.
	IF SELECT("QRY") > 0
		QRY->(dbCloseArea())
	Endif

	cQuery:= " SELECT TOP 1 BF_QUANT FROM "+RetSqlName("SBF")+" SBF"
	cQuery+= " WHERE BF_LOTECTL = '"+cLoteCtl+"' "
	cQuery+= " AND BF_PRODUTO = '"+cProduto+"' "
	cQuery+= " AND BF_LOCAL = '"+cLocOrig+"' "
	cQuery+= " AND BF_LOCALIZ = '"+cEndOrig+"' "
	cQuery+= " AND BF_FILIAL = '"+xFilial("SBF")+"' "
	cQuery+= " AND D_E_L_E_T_ = ''
//cQuery :=ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)

//IF !Empty(QRY->BF_QUANT)
	If BF_QUANT < nQtde
		MyMsg("Quantidade apontada excede o Saldo do endereço",1)
		lRet := .F.

	Endif
//EndIf

	QRY->(dbCloseArea())


Return lRet


/*/{Protheus.doc} fAjusSld
//TODO Ajusta saldo da etiqueta
@author Ricardo Roda
@since 20/09/2018
@version undefined
@example
(examples)
@see (links_or_references)
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

// Alteralção Ricardo para gravar o nome do Supervisor
//nas operações de ajuste acima da quantidade permitida
		aAdd(ExpA1,{"D3_OBSERVA"  ,cSuperv    ,Nil})



		lMsErroAuto := .F.

		MSExecAuto({|x,y| mata240(x,y)},ExpA1,ExpN2)

		If !lMsErroAuto
			ConOut("Incluido com sucesso! " + cTPMovimento)
			lRet := .T.

			If cTPMovimento < '500'

				cNumseq := ""
				SD3->( dbSetOrder(2) )  // D3_FILIAL + D3_DOC
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


				SDA->( dbSetOrder(RetOrder("SDA","DA_FILIAL+DA_NUMSEQ")) )  // DA_FILIAL + DA_NUMSEQ

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
			lRet := .F.
			Disarmtransaction()
		EndIf

		ConOut("Fim ajuste etiqueta - DOMCORT : "+Time())
		ConOut(Repl("-",80))

	End Transaction

//RESET ENVIRONMENT

Return lRet

User function CriaXD4()
	Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
	Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

	AxCadastro("XD4","Etiqueta Serial",cVldAlt,cVldExc)

Return

/*/{Protheus.doc} Return
//TODO Descrição auto-gerada.
@author Ricardo Roda
@since 04/10/2018
@version undefined
@example
(examples)
@see (links_or_references)
/*/
Static function fExclEti()
	Local cQuery:= ""
	Local nEtiqs:= 0
	Local _cPrxDoc:= fPrxDoc()

	if SELECT("QRY") > 0
		QRY->(dbCloseArea())
	Endif

	cQuery:= " SELECT TOP 1 XD4_DOC AS DOC, COUNT(*) ETIQS
	cQuery+= " FROM "+RetSqlName("XD4")+" XD4
	cQuery+= " WHERE XD4_OP = '"+cCodOP+"'
	cQuery+= " AND XD4.D_E_L_E_T_ = ''
	cQuery+= " AND XD4_NOMUSR = '"+cUserSis+"'
	cQuery+= " AND XD4_FILIAL = '"+xFilial("XD4")+"' "
	cQuery+= " AND XD4.D_E_L_E_T_ = ''
	cQuery+= " GROUP BY XD4_DOC
	cQuery+= " ORDER BY XD4_DOC DESC

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)

	if QRY->(!eof())
		nEtiqs:= QRY->ETIQS
		cQuery:= "UPDATE "+retsqlname("XD4")+" SET XD4_STATUS = '5' "
		cQuery+= "WHERE XD4_DOC = '"+QRY->DOC+"'
		cQuery+= "AND XD4_OP = '"+cCodOP+"' "
		cQuery+= " AND XD4_NOMUSR =  '"+cUserSis+"' "
		cQuery+= " AND XD4_FILIAL = '"+xFilial("XD4")+"' "
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

	if lFurukawa
	U_DOMETI02(cCodOP,nApont,_cNumSerie,cLocImp,cCodFuruk,Len(cvaltochar(nQtdOp)))
	Else
	U_DOMETI01(cCodOP,nApont,_cNumSerie,cLocImp)
	Endif

	For _i := 1 to nEtiqs
	Reclock("XD4", .T.)
	XD4->XD4_FILIAL	:= xFilial("XD4")
	XD4->XD4_SERIAL	:= _cNumSerie
	XD4->XD4_STATUS	:= '6'
	XD4->XD4_OP		:= cCodOP
	XD4->XD4_NOMUSR	:= cUserSis
	XD4->XD4_DOC	:= _cPrxDoc
	XD4->XD4_KEY 	:= iIf(lFurukawa,cvaltochar(_cNumSerie) + cCodFuruk,"S"+Alltrim(cCodOP)+Alltrim(cvaltochar(_cNumSerie)))
	XD4->(MsUnlock())
	
	_cNumSerie += 1
	Next _i

Return

/*/{Protheus.doc} FPRXDOC
//TODO Descrição auto-gerada.
@author Ricardo Roda
@since 04/10/2018
@version undefined
@example
(examples)
@see (links_or_references)
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

/*/{Protheus.doc} function_method_class_name
//TODO Descrição auto-gerada.
@author author
@since 04/10/2018
@version version
@example
(examples)
@see (links_or_references)
/*/
Static Function fZera

	nApont:= 0
	nEmCort:= 0

	cQuery:= "UPDATE "+retsqlname("ZZ4")+" SET ZZ4_QEMCRT = 0  "
	cQuery+= "WHERE ZZ4_OP = '"+cCodOP+"' "
//cQuery+= " AND ZZ4_PROD = '"+cCFibra+"' "
	cQuery+= " AND ZZ4_USER = '"+__cUserId+"' "
	cQuery+= " AND ZZ4_FILIAL = '"+xFilial("ZZ4")+"' "
	cQuery+= " AND D_E_L_E_T_ = '' "
	TCSqlExec(cQuery)

	MontaaLbx()

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

	oEmCort:refresh()

Return

/*/{Protheus.doc} fQtdSD3
//TODO Descrição auto-gerada.
@author Ricardo Roda
@since 11/10/2018
@version undefined
@example
(examples)
@see (links_or_references)
/*/
Static function fQtdSD3(TamCorte)
	Local cQuery:= ""
	Local cLocProd:= cArm
	Local nQtdeSD3:= 0

	If SELECT("QRYD3") > 0
		QRYD3->(dbCloseArea())
	Endif

	cQuery:= " SELECT ISNULL(SUM(CASE WHEN D3_CF='RE4' THEN -D3_QUANT ELSE +D3_QUANT END),0) AS QTDD3"
	cQuery+= " FROM "+RetSqlName("SD3")+ " SD3 "
	cQuery+= " WHERE D3_XXOP    ='"+cCodOP+"'  "
	cQuery+= " AND   D3_COD     = '"+cCFibra+"' "
	cQuery+= " AND   D3_LOCAL   = '"+cLocProd+"' "
	cQuery+= " AND   D3_ESTORNO = ''  "
	cQuery+= " AND   D3_CF IN ('DE4','RE4') "
	cQuery+= " AND D3_FILIAL = '"+xFilial("SD3")+"' "
	cQuery+= " AND   SD3.D_E_L_E_T_ = '' "

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRYD3",.T.,.T.)
//MemoWrite("PAGOSD3.sql",cQuery)

	nQtdeSD3:= round((QRYD3->QTDD3/TamCorte),0)

	cQuery:= "UPDATE "+retsqlname("ZZ4")+" SET ZZ4_QTCORT = "+cvaltochar(nQtdeSD3)+"  "
	cQuery+= "WHERE ZZ4_OP = '"+cCodOP+"' "
	cQuery+= " AND ZZ4_PROD = '"+cCFibra+"' "
	cQuery+= " AND ZZ4_FILIAL = '"+xFilial("ZZ4")+"' "
	cQuery+= "AND D_E_L_E_T_ = '' "
	TCSqlExec(cQuery)


	QRYD3->(dbCloseArea())

Return nQtdeSD3

/*/{Protheus.doc} fQtdEmCort
//TODO Descrição auto-gerada.
@author Ricardo Roda
@since 11/10/2018
@version undefined
@example
(examples)
@see (links_or_references)
/*/
Static function fQtdEmCort()
	Local cQuery:= ""
	Local nQtdeZZ4:= 0

	If SELECT("QRYZZ4") > 0
		QRYZZ4->(dbCloseArea())
	Endif

	cQuery:= " SELECT SUM(ZZ4_QEMCRT)  AS QTDZZ4"
	cQuery+= " FROM "+RetSqlName("ZZ4")+"  "
	cQuery+= " WHERE ZZ4_OP = '"+cCodOP+"' "
	cQuery+= " AND ZZ4_PROD = '"+cCFibra+"' "
	cQuery+= " AND ZZ4_FILIAL = '"+xFilial("ZZ4")+"' "
	cQuery+= " AND D_E_L_E_T_ = '' "

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRYZZ4",.T.,.T.)

	If QRYZZ4->(!eof())
		nQtdeZZ4:= QRYZZ4->QTDZZ4
	Endif

	QRYZZ4->(dbCloseArea())

Return nQtdeZZ4

/*/{Protheus.doc} fAnaliPg
//TODO Descrição auto-gerada.
@author Ricardo Roda
@since 18/10/2018
@version undefined
@example
(examples)
@see (links_or_references)
/*/
Static Function fAnaliPg()

	Local cQuery:= ""
	Local cLocProd:= cArm
	Local nQtdeSD3:= 0
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

	Endif

	Qry4->(dbCloseArea())

Return lRet


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


/*/{Protheus.doc} AjustSup
//TODO Descrição auto-gerada.
@author Ricardo Roda
@since 11/10/2019
@version undefined
@example
(examples)
@see (links_or_references)
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

	Private cCerto:= cStartPath + 'Certo2.jpg'
	Private cErro := cStartPath + 'Errado2.jpg'
	Private cStatus:= cStartPath + 'Interroga2.png'
	Private oSenhaSup
	Private oDlgSup
	Private cNivel:= cNv

	cSenhaC := SPACE(20)

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


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fOK(nOpc)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Local lRet:= .F.
	Local lUsrRet := .T.
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
				MyMsg("Usuário não encontrado",1)
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
					If cNivel ==  "S" .AND. (Upper(AllTrim(aUsrRet[1,13])) <> Upper("Supervisor de Producao")) .or. cNivel ==  "G" .AND.  (Upper(AllTrim(aUsrRet[1,13])) <> Upper("Gerente de Producao"))
						MyMsg("Usuario não é SUPERVISOR",1)
					ElseIf cNivel ==  "G" .AND.  (Upper(AllTrim(aUsrRet[1,13])) <> Upper("Gerente de Producao"))
						MyMsg("Usuario não é GERENTE",1)
					Else
						cSuperv:= cGetSup
						lAjusteOk := .T.
					EndIf
				EndIf
			Else
				MyMsg("Usuário não encontrado",1)
				Return .F.
			EndIf
		Endif
	Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Usuario ou senha em branco			   						³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Return .T.

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


static Function fButtCel()
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

	DEFINE MSDIALOG oDlgBtC TITLE "Escolha a célula de trabalho" FROM 000, 000  TO 580, 800 COLORS 0, 16777215 PIXEL
	@ 015, 040 BUTTON oCelCort1 PROMPT "CORTE 1" SIZE 150, 053 OF oDlgBtC ACTION (nCelula := 1, oDlgBtc:end() ) FONT oFont1 PIXEL
	oCelCort1:setCSS(cCSSBtN1)
	@ 015, 212 BUTTON oCelCort2 PROMPT "CORTE 2" SIZE 150, 053 OF oDlgBtC ACTION (nCelula := 2, oDlgBtc:end()) FONT oFont1 PIXEL
	oCelCort2:setCSS(cCSSBtN1)
	@ 080, 040 BUTTON oCelCort3 PROMPT "CORTE 3" SIZE 150, 053 OF oDlgBtC ACTION (nCelula := 3, oDlgBtc:end()) FONT oFont1 PIXEL
	oCelCort3:setCSS(cCSSBtN1)
	@ 080, 212 BUTTON oCelCort4 PROMPT "CORTE 4" SIZE 150, 053 OF oDlgBtC ACTION (nCelula := 4, oDlgBtc:end()) FONT oFont1 PIXEL
	oCelCort4:setCSS(cCSSBtN1)
	@ 145, 040 BUTTON oCelCort5 PROMPT "CORTE 5" SIZE 150, 053 OF oDlgBtC ACTION (nCelula := 5, oDlgBtc:end() ) FONT oFont1 PIXEL
	oCelCort5:setCSS(cCSSBtN1)
	@ 145, 212 BUTTON oCelCort6 PROMPT "DROP 1" SIZE 150, 053 OF oDlgBtC ACTION (nCelula := 6, oDlgBtc:end() ) FONT oFont1 PIXEL
	oCelCort6:setCSS(cCSSBtN1)
	@ 210, 040 BUTTON oCelCort7 PROMPT "TRUNK 1" SIZE 150, 053 OF oDlgBtC ACTION (nCelula := 7, oDlgBtc:end() ) FONT oFont1 PIXEL
	oCelCort7:setCSS(cCSSBtN1)
	@ 210, 212 BUTTON oCelCort7 PROMPT "PRECON" SIZE 150, 053 OF oDlgBtC ACTION (nCelula := 8, oDlgBtc:end() ) FONT oFont1 PIXEL
	oCelCort7:setCSS(cCSSBtN1)


	ACTIVATE MSDIALOG oDlgBtC CENTERED

Return nCelula

Static function  ftelaOp (nCelTrab)
 
	Local cQuery := ""
	Local oButton1
	Local oButton2
	Local oFont1 := TFont():New("Arial Black",,030,,.T.,,,,,.F.,.F.)
	Local oFont2 := TFont():New("Arial",,020,,.F.,,,,,.F.,.F.)
	Local oFont4 := TFont():New("Arial",,028,,.T.,,,,,.F.,.F.)
	Local oOPn    := LoadBitmap( GetResources(), "DBG05" )
	Local oOPp    := LoadBitmap( GetResources(), "DBG06" )


	Local cCabec   := ""
	Local _cVarTemp:= ""
	Local cVar     := Nil
	Static oDlg2
	Private aVetor
	Private oLbx := {}

	aVetor:= fMSNewG2(nCelTrab)

//+-----------------------------------------------+
//| Monta a tela para usuario visualizar consulta |
//+-----------------------------------------------+
	If Len(aVetor ) == 0
		IF nCelTrab <= 5
			mymsg( "Não há programações para 'CORTE "+cValToChar(nCelula)+"' ",1 )
		ElseIF nCelTrab == 7
			mymsg( "Não há programações para 'TRUNK 1' ",1 )
		ElseIF nCelTrab == 6
			mymsg( "Não há programações para 'DROP 1' ",1 )
		ElseIF nCelTrab == 8
			mymsg( "Não há programações para 'PRECON' ",1 )
		Endif
		Return .T.
	Endif

	DEFINE MSDIALOG oDlg2 TITLE "Sequênciamento de Produção" FROM 0,0 TO 600,800 PIXEL

	@ 05,05 LISTBOX oLbx VAR cVar FIELDS HEADER;
		"","Ordens de Produção","Código do Produto","Quantidade OP","Quantidade Cortada" ;
		SIZE 395,294 OF oDlg2  FONT oFont4  PIXEL ColSizes 02,20,120,50,50;
		ON dblClick(cCodOP:= aVetor[oLbx:nAt,2],Odlg2:end())
	oLbx:SetArray( aVetor )
	oLbx:bLine := {|| {Iif (aVetor[oLbx:nAt,1] == 1,oOPp,oOPn) ,aVetor[oLbx:nAt,2],aVetor[oLbx:nAt,3],aVetor[oLbx:nAt,4],aVetor[oLbx:nAt,5]}}

	cCodOP:= aVetor[1,2]
	cArm:= Iif(aVetor[1,1] == 1, "96","97")
	cLocaliz := Iif(aVetor[1,1] == 1,"96PERDA","97PROCESSO")
	lPerda:= Iif(aVetor[1,1] == 1,.T.,.F.)

	oCodOP:Refresh()
	oCFibra:SetFocus()

	ACTIVATE MSDIALOG oDlg2 CENTERED

Return


Static Function fMSNewG2(nCelTrab)
	Local aDados:={}


	IF SELECT ("QRYZ") > 0
		QRYZ->(DBCLOSEAREA( ))
	endif

	cQuery:= " SELECT D4_OP ,D4_COD ,QTDD4 ,QTDD3,P10_DTPROG DT_PROG, P10_SQCORT SEQUENCIA,
	cQuery+= "  CASE WHEN P10_SQCORT = '000' THEN 1 ELSE 2  END AS PERDA
	cQuery+= " FROM ( "
	cQuery+= " SELECT P10_DTPROG, P10_SQCORT, D4_OP, D4_COD, "
	cQuery+= " ROUND(ISNULL(SUM(CASE WHEN D3_CF='RE4' THEN -D3_QUANT ELSE +D3_QUANT END),0) ,6)AS QTDD3,  "
	cQuery+= " ROUND(D4_QTDEORI,6) QTDD4  "
	cQuery+= " FROM "+RetSqlName("SD4")+" SD4  "
	cQuery+= " LEFT JOIN "+RetSqlName("SD3")+" SD3 ON D3_XXOP = D4_OP  "
	cQuery+= " AND D3_COD = D4_COD  "
	cQuery+= " AND D3_LOCAL  = D4_LOCAL  "
	cQuery+= " AND D3_ESTORNO = ''   "
	cQuery+= " AND D3_CF IN ('DE4','RE4')  "
	cQuery+= " AND D3_FILIAL ='"+xFilial("SD3")+"' "
	cQuery+= " AND SD3.D_E_L_E_T_ = ''   "
	cQuery+= " INNER JOIN "+RetSqlName("P10")+" P10  ON P10_FILIAL = '"+xFilial("P10")+"' "
	cQuery+= " AND P10_OP = D4_OP  "

	If nCelTrab <= 5
		cQuery+= " AND P10_MAQUIN = 'CORTE "+cValToChar(nCelTrab)+"' "
	ElseIf nCelTrab == 7
		cQuery+= " AND P10_MAQUIN = 'TRUNK 1' "
	ElseIf nCelTrab == 6
		cQuery+= " AND P10_MAQUIN = 'DROP 1' "
	ElseIf nCelTrab == 8

		If U_VALIDACAO() .or. .T.//Roda 30/07/2021
			cQuery+= " AND P10_MAQUIN = 'PRECON 1' "		
		Else	
			cQuery+= " AND P10_MAQUIN = 'PRECON' "
		Endif
	Endif

	cQuery+= " AND P10_FIBRA = D4_COD "
	cQuery+= " INNER JOIN "+RetSqlName("SC2")+"  SC2 (NOLOCK) "
	cQuery+= " ON C2_FILIAL = '"+xFilial("SC2")+"' "
	cQuery+= " AND C2_NUM+C2_ITEM+C2_SEQUEN = D4_OP  "
	cQuery+= " AND SC2.D_E_L_E_T_ = '' "
	cQuery+= " AND C2_QUANT <> C2_QUJE "

	cQuery+= " WHERE D4_FILIAL = '"+xFilial("SD4")+"' "
	cQuery+= " AND SD4.D_E_L_E_T_ = ''  "
	cQuery+= " GROUP BY D4_OP,D4_COD, D3_XXOP,D4_QTDEORI,P10_SQCORT,P10_DTPROG)  "
	cQuery+= " AS TAB  "
	cQuery+= " WHERE  QTDD3 < QTDD4 "
	cQuery+= " ORDER BY 7,5,6 "
	//MemoWrite("VLDOPS.sql",cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRYZ",.T.,.T.)

	If !QRYZ->(eof())
		While QRYZ->(!eof())
			aAdd( aDados,{QRYZ->PERDA,QRYZ->D4_OP,QRYZ->D4_COD ,QRYZ->QTDD4 ,QRYZ->QTDD3 })
			QRYZ->(dbSkip())
		Enddo
	Endif

Return (aDados)


Static Function fLocImp(nCel)
	Local cQuery:= ""
	Local cFila:= ""
	Local cMaq:= ""

	IF SELECT ("QCB5") > 0
		QCB5->(DBCLOSEAREA())
	ENDIF

	If nCel <= 5
		cMaq:= "'CORTE "+cValTochar(nCel)+"' "
	Elseif nCel == 7
		cMaq:= "'TRUNK 1'"
	Elseif nCel == 6
		cMaq:= "'DROP 1'"
	Elseif nCel == 8 
		cMaq:= "'PRECON'"	
	Endif


	cQuery:= " SELECT TOP 1 CB5_CODIGO FROM "+RetSqlName("CB5")+" "
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
		// IF nQtdMod <=  QRY->D4_QUANT
		// 	If !fAnaliPg()
		// 		nQtd:= QRY->D4_QUANT
		// 	else
		// 		nQtd:= nQtdMod
		// 	Endif

		cProd := QRY->D4_COD
		cUnidade := Posicione("SB1",1,xFilial("SB1")+cProd,"B1_UM")
		cArmazem := QRY->D4_LOCAL
		dEmissao := dDataBase
		nQtd:= (QRY->D4_QTDEORI/nQtdOp) * nApont

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

Static Function fSubHr(dDtIni,cHrIni,dDtFim,cHrfim)
	Local _Retorno
	Local nSegIni := 0
	Local nSegFim := 0

	nSegIni += (dDtIni - StoD('20200101')) * 24 * 60 * 60
	nSegIni += Val(Subs(cHrIni,1,2)) * 60 * 60
	nSegIni += Val(Subs(cHrIni,4,2)) * 60
	nSegIni += Val(Subs(cHrIni,7,2))


	nSegFim += (dDtFim - StoD('20200101')) * 24 * 60 * 60
	nSegFim += Val(Subs(cHrfim,1,2)) * 60 * 60
	nSegFim += Val(Subs(cHrfim,4,2)) * 60
	nSegFim += Val(Subs(cHrfim,7,2))

	nDifSeg := nSegFim - nSegIni

	_Retorno := nDifSeg / 60

//nhora := Int(nDifSeg / 3600)

//nDifSeg -=  (nhora * 3600)

//nMinutos := Int(nDifSeg / 60)

//nDifSeg -= (nMinutos * 60)

//Retorno := Strzero(nhora,2)+':'+Strzero(nMinutos,2)+':'+StrZero(nDifSeg,2)

Return _Retorno


Static function fImpEtqFF()

	if Posicione("SB1",1, xFilial("SB1")+cCFibra,"B1_GRUPO") <> "FOFS"
		myMsg("Informe a fibra falsa para imprimir as etiquetas", 1)
		Return
	Endif

	DbSelectArea("SC2")
	DbSetOrder(1)
	dbSeek(xFilial("SC2")+cCodOP)

	//Coleta o ultimo serial e incrementa o apontamento
	_cNumSerie:= VAL(SC2->C2_XXSERIA)+ 1
	Reclock("SC2", .F.)

	SC2->C2_XXSERIA := CVALTOCHAR(VAL(SC2->C2_XXSERIA) + SC2->C2_QUANT)
	SC2->(MsUnlock())

	_cProxNiv    := '1'
	_aQtdBip     := {}
	_lImpressao  := .T.
	_nPesoBip    := 0
	_lColetor    := .F.

	if lFurukawa
		U_DOMETI02(cCodOP,nApont,_cNumSerie,cLocImp,cCodFuruk,Len(cvaltochar(nQtdOp)))
	Else
		U_DOMETI01(cCodOP,nApont,_cNumSerie,cLocImp)
	Endif

	_cPrxDoc:= fPrxDoc()
	For _i := 1 to SC2->C2_QUANT
		Reclock("XD4", .T.)
		XD4->XD4_FILIAL	:= xFilial("XD4")
		XD4->XD4_SERIAL	:= _cNumSerie
		XD4->XD4_STATUS	:= '6'
		XD4->XD4_OP	   	:= cCodOP
		XD4->XD4_NOMUSR	:= cUserSis
		XD4->XD4_DOC    := _cPrxDoc
		XD4->XD4_KEY 	:= iIf(lFurukawa,cvaltochar(_cNumSerie) + cCodFuruk,"S"+Alltrim(cCodOP)+Alltrim(cvaltochar(_cNumSerie)))
		XD4->(MsUnlock())
		_cNumSerie += 1
	Next _i
Return


/*/{Protheus.doc} fFurukawa(cCodOp)
	(long_description)
	@type  Static Function
	@author user
	@since 19/11/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function fFurukawa(cCodOp)
	local lRet:= .F.
	Local cQuery:= ""

	if select ("QRYFRK") > 0
		QRYFRK->(dbCloseArea())
	Endif
	cQuery+= " SELECT C2_PEDIDO, C6_SEUCOD , C6_CLI,C6_LOJA "
	cQuery+= " FROM "+RETSQLNAME("SC2")+" SC2
	cQuery+= " INNER JOIN "+RETSQLNAME("SC6")+" SC6 ON C6_NUM = C2_PEDIDO AND SC6.D_E_L_E_T_ = ''
	cQuery+= " AND C6_LOTECTL = C2_NUM+C2_ITEM
	cQuery+= " AND C6_FILIAL = '"+xFilial("SC6")+"' "
	cQuery+= " AND C6_CLI+C6_LOJA IN (	SELECT A1_COD+A1_LOJA FROM "+RETSQLNAME("SA1")+" "
	cQuery+= " 					WHERE A1_NOME LIKE '%FURUKAWA%'
	cQuery+= " 					AND A1_FILIAL = '"+xFilial("SA1")+"' "
	cQuery+= " 					AND D_E_L_E_T_= '')
	cQuery+= " AND C6_SEUCOD <> ''
	cQuery+= " WHERE SC2.D_E_L_E_T_= ''
	cQuery+= " AND C2_FILIAL = '"+xFilial("SC2")+"' "
	cQuery+= " AND C2_NUM+C2_ITEM+C2_SEQUEN = '"+alltrim(cCodOp)+"'
	cQuery+= " GROUP BY C2_PEDIDO, C6_SEUCOD , C6_CLI,C6_LOJA
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRYFRK",.T.,.T.)

	If QRYFRK->(!EOF())
		cCodFuruk:= alltrim(QRYFRK->C6_SEUCOD)
		cLocImp:= '000013'
		lRet:= .T.
	Endif

Return lRet
