#include 'rwmake.ch'
#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'

#include "TbiConn.ch"
#include "TbiCode.ch"
#include "rwmake.ch"

user function DOMMANPO()

	Private oMntPO
	Private oGetOrig
	Private oGetDest

	PRIVATE aHeadOri :={}
	PRIVATE aCOLSOri :={}

	PRIVATE __MXPOS :=''

	PRIVATE oPO
	PRIVATE cPO:=SPACE(20)

	PRIVATE oQTD1
	PRIVATE nQTD1:=0

	PRIVATE oQTD2
	PRIVATE nQTD2:=0

	PRIVATE oQTD3
	PRIVATE nQTD3:=0

	aHeadDest :={}
	aColsDEST :={}

	AADD(aHeadOri,   {    "Filial"   ,   "O_FIL"    ,""                         ,02,0,""  ,"","C","","","","",".F"}) //01
	AADD(aHeadOri,   {    "PO"       ,   "O_NPO"    ,""                         ,20,0,""  ,"","C","","","","",".F"}) //02
	AADD(aHeadOri,   {    "Item PO"  ,   "O_IPO"    ,""                         ,04,0,""  ,"","C","","","","",".F"}) //03
	AADD(aHeadOri,   {    "Produto"  ,   "O_PRD"    ,""                         ,15,0,""  ,"","C","","","","",".F"}) //04
	AADD(aHeadOri,   {    "Descricao",   "O_DSC"    ,""                         ,60,0,""  ,"","C","","","","",".F"}) //04
	AADD(aHeadOri,   {    "Qtde"     ,   "O_QTD"    ,"@E 999,999,999,999.99"    ,12,5,""  ,"","N","","","","",".F."})//06
	//AADD(aHeadOri,   {    "PC"       ,   "O_NPC"    ,""                         ,06,0,""  ,"","C","","","","",".F."})//07
	//AADD(aHeadOri,   {    "Item PC"  ,   "O_IPC"    ,""                         ,04,0,""  ,"","C","","","","",".F."})//08

	AADD(aHeadDest,   {    "Tipo"     ,   "W3_XTPOTR",""                         ,01,0,""  ,"","C","","","","",".F"}) //01
	AADD(aHeadDest,   {    "Filial"   ,   "D_FIL"    ,""                         ,02,0,""  ,"","C","","","","",".F"}) //01
	AADD(aHeadDest,   {    "PO"       ,   "D_NPO"    ,""                         ,20,0,""  ,"","C","","","","",".F"}) //01
	AADD(aHeadDest,   {    "Item PO"  ,   "D_IPO"    ,""                         ,04,0,""  ,"","C","","","","",".F"}) //01
	AADD(aHeadDest,   {    "Produto"  ,   "D_PRD"    ,""                         ,15,0,""  ,"","C","","","","",".F"}) //04
	AADD(aHeadDest,   {    "Descricao",   "D_DSC"    ,""                         ,60,0,""  ,"","C","","","","",".F"}) //04
	AADD(aHeadDest,   {    "Qtde"     ,   "D_QTD"    ,"@E 999,999,999,999.99"    ,12,5,""  ,"","N","","","","",".F."})//03
	//AADD(aHeadDest,   {    "PC"       ,   "D_NPC"    ,""                         ,06,0,""  ,"","C","","","","",".F."})//02
	//AADD(aHeadDest,   {    "Item PC"  ,   "D_IPC"    ,""                         ,04,0,""  ,"","C","","","","",".F."})//02


	//cQryOri:=" select W3_FILIAL,W3_PO_NUM,W3_POSICAO,W3_COD_I,W3_XSLDORI,W3_QTDE, "
	//cQryOri+=" W3_XPOORI,W3_XITORIG,W3_XSLDORI,W3_XDTTR,W3_XUSRTR,W3_XFILORI,W3_XTPOTR "
	//cQryOri+=" from SW3010 WHERE W3_XPOORI<>'' AND W3_SEQ=0 "

	//cQryOri:=" SELECT * FROM SW3010  "
	//cQryOri+=" WHERE TRIM(W3_PO_NUM)+TRIM(W3_POSICAO)+TRIM(W3_FILIAL) IN  "
	//cQryOri+="      (SELECT TRIM(W3_XPOORI)+TRIM(W3_XITORIG)+TRIM(W3_XFILORI) FROM SW3010  "
	//cQryOri+=" 	 WHERE W3_XPOORI<>'' AND W3_SEQ=0 AND D_E_L_E_T_=''  ) "
	//cQryOri+=" AND W3_SEQ=0 AND D_E_L_E_T_='' AND W3_FILIAL='01' "

	cQryOri:=" SELECT B1_DESC,W3_FILIAL,W3_PO_NUM,W3_POSICAO,W3_COD_I, W3_QTDE "
	cQryOri+=" FROM SW3010  WITH(NOLOCK) , SB1010 WITH (NOLOCK) "
	cQryOri+=" WHERE B1_COD=W3_COD_I "
	cQryOri+=" AND TRIM(W3_PO_NUM)+TRIM(W3_POSICAO)+TRIM(W3_FILIAL) IN "
	cQryOri+=" (SELECT TRIM(W3_XPOORI)+TRIM(W3_XITORIG)+TRIM(W3_XFILORI) FROM SW3010 "
	cQryOri+=" WHERE W3_XPOORI<>'' AND W3_SEQ=0 AND D_E_L_E_T_=''  ) "
	cQryOri+=" AND W3_SEQ=0 AND SW3010.D_E_L_E_T_='' AND SB1010.D_E_L_E_T_='' "
	cQryOri+=" AND W3_FILIAL='01' AND SB1010.B1_FILIAL='' "
	cQryOri+=" ORDER BY W3_PO_NUM,W3_POSICAO "

	If Select("TR1") <> 0
		TR1->( dbCloseArea() )                                                                                                               '
	EndIf

	TCQUERY cQryOri NEW ALIAS "TR1"

	While !TR1->( EOF() )
		AADD(aColsORI,{TR1->W3_FILIAL,;
			TR1->W3_PO_NUM,;
			TR1->W3_POSICAO,;
			TR1->W3_COD_I,;
			TR1->B1_DESC,;
			TR1->W3_QTDE,;
			.F.})//.f. POSICAO Flag de Delecao]

		TR1->( dbSkip() )
	End
	/*
	AADD(aColsORI,{'',;
		'',;
		'',;
		'',;
		'',;
		0,;
		0,;
		.F.})//.f. POSICAO Flag de Delecao]
	*/

	AADD(aColsDEST,{'',;
		'',;
		'',;
		'',;
		'',;
		'',;
		0,;
		.F.})//.f. POSICAO Flag de Delecao]

	cTit := "Manutenção PO "

	DEFINE MSDIALOG oMntPO TITLE cTit FROM -017, 000  TO 530, 1295 COLORS 0, 16777215 PIXEL
	DEFINE FONT oFnt1       NAME "Arial"                    Size 10,12 BOLD

	//@ 001,001 GROUP oGroupC TO 270, 207 PROMPT "Grupo 1" OF oMntPO COLOR 0, 16777215 PIXEL
	//	@ 026,001 GROUP oGroupC TO 270, 320 PROMPT "Origem"  OF oMntPO COLOR 0, 16777215 PIXEL
	//	@ 026,322 GROUP oGroupP TO 270, 642 PROMPT "Destino" OF oMntPO COLOR 0, 16777215 PIXEL
	@ 026,001 GROUP oGroupC TO 150, 642 PROMPT "Origem"  OF oMntPO COLOR 0, 16777215 PIXEL
	@ 153,001 GROUP oGroupP TO 270, 642 PROMPT "Destino" OF oMntPO COLOR 0, 16777215 PIXEL

	@ 001,001 GROUP oGroupR TO 023,407  PROMPT "PO"      OF oMntPO COLOR 0, 16777215 PIXEL

	//@ 011.5,215 SAY oTexto1 PROMPT "Quantidade: " Font oFnt1 OF oMntPO COLOR 0, 16777215 PIXEL
	//@ 011.5,275 SAY oTexto2 PROMPT Transform(nQtdTot,"@E 99999999") Font oFnt1 OF oMntPO COLOR 0, 16777215 PIXEL

	//@ 011.5,320 SAY oTexto3 PROMPT "Peso: " Font oFnt1 OF oMntPO COLOR 0, 16777215 PIXEL
	//@ 011.5,360 SAY oTexto4 PROMPT Transform(nVlrTot,"@E 9,999,999.99") Font oFnt1 OF oMntPO COLOR 0, 16777215 PIXEL

	@ 001,410 GROUP oGroupA TO 023,642 PROMPT "Ações" OF oMntPO COLOR 0, 16777215 PIXEL

	//@ 008,560   BMPBUTTON TYPE 02 ACTION (lExec := .F.,Close(oMntPO))
	//@ 0.6,103.1 BUTTON "Pesquisar"        SIZE 50,11 Action PESQPO()
	//@ 0.6,116.6 BUTTON "Dividir Saldo"    SIZE 50,11 Action DVSALDO(oGetOrig,oGetDest)
	//@ 0.6,129.8 BUTTON "Transf. Saldo"    SIZE 50,11 Action TRSALDO(oGetOrig,oGetDest)
	//@ 0.6,147.5 BUTTON "Sair"             SIZE 50,11 Action (lExec := .T.,Close(oMntPO))

	//@ 0.6,103.1 BUTTON "Pesquisar"        SIZE 50,11 Action PESQPO()
	//@ 0.6,01  SAY OemToAnsi("PO")                SIZE 020,010
	@ 0.6,01  MSGET oPO    VAR cPO   WHEN(.F.)   SIZE 080,010

	@ 0.6,13  SAY OemToAnsi("QTD")               SIZE 020,010
	@ 0.6,15  MSGET oQTD1  VAR nQTD1  WHEN(.F.)  SIZE 080,010 Picture "@E 999,999.9999"

	@ 0.6,33  SAY OemToAnsi("Div")               SIZE 020,010
	@ 0.6,25  MSGET oQTD2  VAR nQTD2  WHEN(.F.)  SIZE 080,010 Picture "@E 999,999.9999"

	@ 0.6,53  SAY OemToAnsi("Tot")               SIZE 020,010
	@ 0.6,35  MSGET oQTD3  VAR nQTD3  WHEN(.F.)  SIZE 080,010 Picture "@E 999,999.9999"


	@ 0.6,103.1 BUTTON "Dividir Saldo"    SIZE 50,11 Action DVSALDO(oGetOrig,oGetDest)
	@ 0.6,116.6 BUTTON "Transf. Saldo"    SIZE 50,11 Action TRSALDO(oGetOrig,oGetDest)
	@ 0.6,147.5 BUTTON "Sair"             SIZE 50,11 Action (lExec := .T.,Close(oMntPO))


	//oGetOrig   := (MsNewGetDados():New( 038,010,260,310 ,/*GD_UPDATE*/ ,/*"U_FAT002LOK()"*/  ,/*REQ_OPSD3()*/,/*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*Ffieldok*/,/*superdel*/,/*delok*/,oMntPO,aHeadOri,aCOLSOri))
	oGetOrig   := (MsNewGetDados():New( 038,010,140,630 ,/*GD_UPDATE*/ ,/*"U_FAT002LOK()"*/  ,/*REQ_OPSD3()*/,/*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*Ffieldok*/,/*superdel*/,/*delok*/,oMntPO,aHeadOri,aCOLSOri))
	//oGetOrig:oBrowse:Refresh()
	oGetOrig:oBrowse:bChange:={||U_MPOCHG01(oGetOrig,oGetDest)}

	//oGetDest   := (MsNewGetDados():New( 038,332,260,632 ,/*GD_UPDATE*/ ,/*"U_FAT002LOK()"*/  ,/*REQ_OPSD3()*/,/*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*Ffieldok*/,/*superdel*/,/*delok*/,oMntPO,aHeadDest,aCOLSDest))
	oGetDest   := (MsNewGetDados():New( 165,010,260,630 ,/*GD_UPDATE*/ ,/*"U_FAT002LOK()"*/  ,/*REQ_OPSD3()*/,/*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*Ffieldok*/,/*superdel*/,/*delok*/,oMntPO,aHeadDest,aCOLSDest))
	oGetDest:oBrowse:Refresh()

	ACTIVATE MSDIALOG oMntPO CENTERED

return


STATIC FUNCTION PESQPO()
	Alert("Pesquisa PO, em desenvolvimento")
RETURN



STATIC FUNCTION TRSALDO()

	Alert("Transferencia saldo filial, em desenvolvimento")

RETURN


//U_MPOCHG01(oGetOrig,oGetDest)

USER FUNCTION MPOCHG01(oGetOrig,oGetDest)
	LOCAL nLIN :=oGetOrig:nat
	Local nTot :=0

	aColsDEST :={}

	//cQueryDEST := " SELECT * FROM SW3010 WITH(NOLOCK) "
	//cQueryDEST += " WHERE W3_FILIAL = '"+xFILIAL('SW3')+"' "
	//cQueryDEST += "       AND W3_XFILORI='"+ALLTRIM(oGetOrig:ACOLS[nLIN][01])+"' "
	//cQueryDEST += "       AND W3_XPOORI ='"+ALLTRIM(oGetOrig:ACOLS[nLIN][02])+"' "
	//cQueryDEST += "       AND W3_XITORIG='"+ALLTRIM(oGetOrig:ACOLS[nLIN][03])+"' "
	//cQueryDEST += "       AND D_E_L_E_T_='' AND W3_SEQ=0  "

	cQueryDEST := " SELECT B1_DESC,W3_FILIAL,W3_XTPOTR,W3_PO_NUM,W3_POSICAO,W3_COD_I,W3_QTDE "
	cQueryDEST += " FROM SW3010 WITH(NOLOCK) ,SB1010 WITH(NOLOCK) "
	cQueryDEST += " WHERE B1_COD=W3_COD_I "
	cQueryDEST += "       AND  W3_FILIAL = '"+xFILIAL('SW3')+"' "
	cQueryDEST += "       AND  B1_FILIAL = '"+xFILIAL('SB1')+"' "
	cQueryDEST += "       AND W3_XFILORI='"+ALLTRIM(oGetOrig:ACOLS[nLIN][01])+"' "
	cQueryDEST += "       AND W3_XPOORI ='"+ALLTRIM(oGetOrig:ACOLS[nLIN][02])+"' "
	cQueryDEST += "       AND W3_XITORIG='"+ALLTRIM(oGetOrig:ACOLS[nLIN][03])+"' "
	cQueryDEST += "       AND W3_SEQ=0  "
	cQueryDEST += "       AND SW3010.D_E_L_E_T_='' AND SB1010.D_E_L_E_T_='' "
	cQueryDEST += " ORDER BY W3_PO_NUM,W3_POSICAO "


	If Select("TR2") <> 0
		TR2->( dbCloseArea() )                                                                                                               '
	EndIf

	TCQUERY cQueryDEST NEW ALIAS "TR2"

	While !TR2->( EOF() )
		AADD(aColsDEST,{TR2->W3_XTPOTR ,;
			TR2->W3_FILIAL,;
			TR2->W3_PO_NUM,;
			TR2->W3_POSICAO,;
			TR2->W3_COD_I,;
			TR2->B1_DESC,;
			TR2->W3_QTDE,;
			.F.})//.f. POSICAO Flag de Delecao]
		//MSGALERT(TR2->W3_POSICAO)
		nTot :=nTot+TR2->W3_QTDE
		TR2->( dbSkip() )
	End
	oGetDest:ACOLS:=aColsDEST
	oGetDest:forceRefresh( )
	TR2->(DBCLOSEAREA())
	If Select("TR2") <> 0
		TR2->( dbCloseArea() )                                                                                                               '
	EndIf

	cPO   := ALLTRIM(oGetOrig:ACOLS[nLIN][02])+' / '+ALLTRIM(oGetOrig:ACOLS[nLIN][03])
	nQTD1 := oGetOrig:ACOLS[nLIN][06]
	nQTD2 := nTot
	nQTD3 := oGetOrig:ACOLS[nLIN][06]+nTot

	oPo:REFRESH()
	oQtd1:REFRESH()
	oQtd2:REFRESH()
	oQtd3:REFRESH()

RETURN


Static Function  DVSALDO(oGetOrig,oGetDest)

	Local oFont1 	:= TFont():New("Arial Narrow",,022,,.F.,,,,,.F.,.F.)
	PRIVATE oDlgDIV

	_cPAR01   :=SPACE(LEN(SW3->W3_PO_NUM)) //N.PO
	_cPAR02   :=SPACE(LEN(SB1->B1_COD)) //PN DE
	_cPAR03   :=SPACE(LEN(SW3->W3_POSICAO)) //SALDO
	_cPAR03B  :=0 //SALDO
	_cPAR04   :=SPACE(LEN(SB1->B1_COD)) // PN PARA
	_cPAR05   :=0  //QTDE
	__MXPOS   :=''
	_cANUENTE :=''

	cCadastro:='Dividir Qtde PO'
	lPROCDIV :=.F.

	DEFINE MSDIALOG oDlgDIV TITLE cCadastro FROM 000, 000  TO 280, 470 COLORS 0, 16777215 PIXEL

	@ 011, 010 SAY oSay1 PROMPT "Divisao PO"    SIZE 136, 014 OF oDlgDIV FONT oFont1 COLORS 16711680, 16777215 PIXEL
	@ 037, 010 SAY oSay2 PROMPT "N. PO    :" 	SIZE 045, 007 OF oDlgDIV COLORS 0, 16777215 PIXEL
	@ 050, 010 SAY oSay3 PROMPT "PN De    :"    SIZE 045, 007 OF oDlgDIV COLORS 0, 16777215 PIXEL
	//@ 050, 090 SAY oSay4 PROMPT "Saldo    :"    SIZE 045, 007 OF oDlgDIV COLORS 0, 16777215 PIXEL
	@ 063, 010 SAY oSay5 PROMPT "PO Para  :"    SIZE 045, 007 OF oDlgDIV COLORS 0, 16777215 PIXEL
	//@ 063, 090 SAY oSay6 PROMPT "Qtde     :"    SIZE 045, 007 OF oDlgDIV COLORS 0, 16777215 PIXEL

	@ 037,   050 MSGET oGet1  VAR _cPAR01  WHEN(.T.) F3 "SW3DIV" SIZE 080, 010 OF oDlgDIV COLORS 0, 16777215 PIXEL
	@ 050,   050 MSGET oGet2  VAR _cPAR02  WHEN(.F.)             SIZE 080, 010 OF oDlgDIV COLORS 0, 16777215 PIXEL
	@ 050,   135 MSGET oGet3  VAR _cPAR03  WHEN(.F.)             SIZE 030, 010 OF oDlgDIV COLORS 0, 16777215 PIXEL
	@ 050,   170 MSGET oGet3B VAR _cPAR03B WHEN(.F.)             SIZE 050, 010 Picture "@E 999,999.9999"  OF oDlgDIV COLORS 0, 16777215 PIXEL
	@ 063,   050 MSGET oGet4  VAR _cPAR04  WHEN(.T.) F3 "SB1"    SIZE 080, 010 OF oDlgDIV COLORS 0, 16777215 PIXEL
	@ 063,   170 MSGET oGet5  VAR _cPAR05  WHEN(.T.)             SIZE 050, 010 Picture "@E 999,999.9999"  OF oDlgDIV COLORS 0, 16777215 PIXEL

	DEFINE SBUTTON oSButton1 FROM 110, 010 TYPE 01 OF oDlgDIV ENABLE Action (lPROCDIV :=.T., oDlgDIV:End() )
	DEFINE SBUTTON oSButton2 FROM 110, 040 TYPE 02 OF oDlgDIV ENABLE Action (lLOOP   :=.F., oDlgDIV:End() )//oDlgNFE:End()

	ACTIVATE MSDIALOG oDlgDIV CENTERED

	IF lPROCDIV
		SW3->(DbSetOrder(8)) //SW3    8     W3_FILIAL+W3_PO_NUM+W3_POSICAO

		If SW3->(dbSeek( xFilial("SW3") + _cPAR01 + _cPAR03))
			DO WHILE !SW3->( EOF() ) .and. SW3->W3_FILIAL==xFILIAL('SW3').and.SW3->W3_PO_NUM==_cPAR01.and.SW3->W3_POSICAO==_cPAR03
				RecLock("SW3",.F.)
				SW3->W3_QTDE      :=SW3->W3_QTDE-_cPAR05
				SW3->( MsUnlock() )
				SW3->(DBSKIP())
			ENDDO

			cAliasSW3 := GetNextAlias()
			cWhereSW3 := "%W3_PO_NUM = '"+ALLTRIM(_cPAR01)+"'%"
			BEGINSQL Alias cAliasSW3
				SELECT
					MAX(W3_POSICAO) MXPOS
				FROM
					%table:SW3% (NOLOCK) SW3
				WHERE
					W3_FILIAL = %Exp:xFilial("SW3")%
					AND SW3.%NotDel%
					AND %Exp:cWhereSW3%
			ENDSQL
			__MXPOS := SOMA1((cAliasSW3)->MXPOS)
			(cAliasSW3)->(dbCloseArea())

			cQueryDV1 := " SELECT * FROM SW3010 WHERE D_E_L_E_T_=''"
			cQueryDV1 += "   AND W3_FILIAL='"+xFILIAL('SW3')+"'  "
			cQueryDV1 += " 	 AND W3_PO_NUM='"+_cPAR01+"' "
			cQueryDV1 += " 	 AND W3_POSICAO='"+_cPAR03+"' "

			TCQUERY cQueryDV1 NEW ALIAS "TR3"

			_cANUENTE :=POSICIONE('SB1',1,xFILIAL('SB1')+_cPAR04,'B1_ANUENTE') //C1  1 = SIM  2 =NAO

			While !TR3->( EOF() )

				RecLock("SW3",.T.)
				SW3->W3_FILIAL   := xFilial("SW3")
				SW3->W3_PO_NUM   :=TR3->W3_PO_NUM
				SW3->W3_POSICAO  :=__MXPOS
				SW3->W3_COD_I    :=_cPAR04
				SW3->W3_QTDE     :=_cPAR05
				SW3->W3_SALDO_Q  :=0

				SW3->W3_CC       :=TR3->W3_CC
				SW3->W3_SI_NUM   :=TR3->W3_SI_NUM

				//UPDATE SW3010 SET W3_PGI_NUM='I0011564',W3_FLUXO='1', W3_NR_CONT='0' ,W3_SLD_ELI=0  WHERE R_E_C_N_O_='97180'
				//UPDATE SW3010 SET W3_PGI_NUM=' '       ,W3_FLUXO='1', W3_NR_CONT='18' ,W3_SLD_ELI=0  WHERE R_E_C_N_O_='97179'

				IF _cANUENTE=='1'
					IF !EMPTY(TR3->W3_PGI_NUM)
						SW3->W3_PGI_NUM  :=TR3->W3_PO_NUM
						SW3->W3_FLUXO    :='1'
						SW3->W3_NR_CONT  :=0
						SW3->W3_SLD_ELI  :=TR3->W3_SLD_ELI
					ELSE
						SW3->W3_PGI_NUM  :=''
						SW3->W3_FLUXO    :='1'
						SW3->W3_NR_CONT  :=VAL(__MXPOS)
						SW3->W3_SLD_ELI  :=TR3->W3_SLD_ELI
					ENDIF
				ELSE
					SW3->W3_PGI_NUM  :=TR3->W3_PGI_NUM
					SW3->W3_FLUXO    :=TR3->W3_FLUXO
					SW3->W3_SLD_ELI  :=TR3->W3_SLD_ELI
					SW3->W3_NR_CONT  :=VAL(__MXPOS)
				ENDIF

				SW3->W3_PART_N   :=TR3->W3_PART_N
				SW3->W3_FABR     :=TR3->W3_FABR
				SW3->W3_FABLOJ   :=TR3->W3_FABLOJ
				SW3->W3_PRECO    :=TR3->W3_PRECO
				SW3->W3_DT_EMB   :=STOD(TR3->W3_DT_EMB)
				SW3->W3_DT_ENTR  :=STOD(TR3->W3_DT_ENTR)
				SW3->W3_PORTARI  :=TR3->W3_PORTARI
				SW3->W3_FABR_01  :=TR3->W3_FABR_01
				SW3->W3_FAB1LOJ  :=TR3->W3_FAB1LOJ
				SW3->W3_FABR_02  :=TR3->W3_FABR_02
				SW3->W3_FAB2LOJ  :=TR3->W3_FAB2LOJ
				SW3->W3_FABR_03  :=TR3->W3_FABR_03
				SW3->W3_FAB3LOJ  :=TR3->W3_FAB3LOJ
				SW3->W3_FABR_04  :=TR3->W3_FABR_04
				SW3->W3_FAB4LOJ  :=TR3->W3_FAB4LOJ
				SW3->W3_FABR_05  :=TR3->W3_FABR_05
				SW3->W3_FAB5LOJ  :=TR3->W3_FAB5LOJ

				SW3->W3_PRECOVE  :=TR3->W3_PRECOVE
				SW3->W3_SEQ      :=TR3->W3_SEQ
				SW3->W3_REG      :=TR3->W3_REG


				SW3->W3_FORN     :=TR3->W3_FORN
				SW3->W3_FORLOJ   :=TR3->W3_FORLOJ
				SW3->W3_FORECAS  :=TR3->W3_FORECAS
				SW3->W3_REG_TRI  :=TR3->W3_REG_TRI
				SW3->W3_TEC      :=TR3->W3_TEC
				SW3->W3_EX_NCM   :=TR3->W3_EX_NCM
				SW3->W3_EX_NBM   :=TR3->W3_EX_NBM
				SW3->W3_PO_DA    :=TR3->W3_PO_DA
				SW3->W3_POSI_DA  :=TR3->W3_POSI_DA
				SW3->W3_PGI_DA   :=TR3->W3_PGI_DA

				SW3->W3_PESOL    :=TR3->W3_PESOL
				SW3->W3_CTCUSTO  :=TR3->W3_CTCUSTO
				SW3->W3_CODOPE   :=TR3->W3_CODOPE
				SW3->W3_PESO_BR  :=TR3->W3_PESO_BR
				SW3->W3_SOFTWAR  :=TR3->W3_SOFTWAR
				SW3->W3_GRUPORT  :=TR3->W3_GRUPORT
				SW3->W3_ALTANU   :=TR3->W3_ALTANU
				SW3->W3_FRETE    :=TR3->W3_FRETE
				SW3->W3_SEGURO   :=TR3->W3_SEGURO
				SW3->W3_INLAND   :=TR3->W3_INLAND
				SW3->W3_DESCONT  :=TR3->W3_DESCONT
				SW3->W3_PACKING  :=TR3->W3_PACKING
				SW3->W3_UM       :=TR3->W3_UM
				SW3->W3_QTSEGUM  :=TR3->W3_QTSEGUM
				SW3->W3_SEGUM    :=TR3->W3_SEGUM
				//W3_XXOBS   W3_XCONFDT W3_XNEWDT W3_XPRVPO W3_XCOLETA W3_XETD  W3_XETA  W3_XPRALER W3_XPRDSB W3_XENTREG W3_XFREIGT           W3_XMODAL                 W3_XDTPCOL W3_XHOUSE
				W3_XPOORI        :=TR3->W3_PO_NUM
				W3_XITORIG       :=TR3->W3_POSICAO
				W3_XSLDORI       :=_cPAR03B
				W3_XDTTR         :=DATE()
				W3_XUSRTR        :=Subs(cUsuario,7,15)
				W3_XFILORI       :=xFILIAL('SW3')
				W3_XTPOTR        :='1'
				SW3->( MsUnlock() )
				TR3->( dbSkip() )
			END
			If Select("TR3") <> 0
				TR3->( dbCloseArea() )                                                                                                               '
			EndIf
		ENDIF
	ENDIF
	ATUSC7()
	ATUSW1()
	ATUSW5()
	ATUORIG(oGetOrig,oGetDest)
	MSGALERT('Fim de processamento')
RETURN

STATIC FUNCTION ATUORIG(oGetOrig,oGetDest)
	aColsORI :={}

	cQryOri:=" SELECT B1_DESC,W3_FILIAL,W3_PO_NUM,W3_POSICAO,W3_COD_I, W3_QTDE "
	cQryOri+=" FROM SW3010  WITH(NOLOCK) , SB1010 WITH (NOLOCK) "
	cQryOri+=" WHERE B1_COD=W3_COD_I "
	cQryOri+=" AND TRIM(W3_PO_NUM)+TRIM(W3_POSICAO)+TRIM(W3_FILIAL) IN "
	cQryOri+=" (SELECT TRIM(W3_XPOORI)+TRIM(W3_XITORIG)+TRIM(W3_XFILORI) FROM SW3010 "
	cQryOri+=" WHERE W3_XPOORI<>'' AND W3_SEQ=0 AND D_E_L_E_T_=''  ) "
	cQryOri+=" AND W3_SEQ=0 AND SW3010.D_E_L_E_T_='' AND SB1010.D_E_L_E_T_='' "
	cQryOri+=" AND W3_FILIAL='01' AND SB1010.B1_FILIAL='' "
	cQryOri+=" ORDER BY W3_PO_NUM,W3_POSICAO "

	If Select("TR1") <> 0
		TR1->( dbCloseArea() )                                                                                                               '
	EndIf

	TCQUERY cQryOri NEW ALIAS "TR1"

	While !TR1->( EOF() )
		AADD(aColsORI,{TR1->W3_FILIAL,;
			TR1->W3_PO_NUM,;
			TR1->W3_POSICAO,;
			TR1->W3_COD_I,;
			TR1->B1_DESC,;
			TR1->W3_QTDE,;
			'',;
			'',;
			.F.})//.f. POSICAO Flag de Delecao]

		TR1->( dbSkip() )
	End
	oGetOrig:ACOLS:=aColsORI
	oGetOrig:forceRefresh( )
RETURN


STATIC FUNCTION ATUSC7()

	PRIVATE __POSIGA :=' '
	PRIVATE __PONUM  :=_cPAR01
	PRIVATE __POSICD :=_cPAR03
	PRIVATE __POSICP :=__MXPOS

	cAliasSW2 := GetNextAlias()
	cWhereSW2 := "%W2_PO_NUM = '"+ALLTRIM(__PONUM)+"'%"
	BEGINSQL Alias cAliasSW2
		SELECT
			W2_PO_SIGA
		FROM
			%table:SW2% (NOLOCK) SW2
		WHERE
			W2_FILIAL = %Exp:xFilial("SW2")%
			AND SW2.%NotDel%
			AND %Exp:cWhereSW2%
	ENDSQL
	__POSIGA := (cAliasSW2)->W2_PO_SIGA
	(cAliasSW2)->(dbCloseArea())

	SC7->(DbSetOrder(1)) //C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN

	If SC7->(dbSeek( xFilial("SC7") + __POSIGA + __POSICD))
		DO WHILE !SC7->( EOF() ) .and. SC7->C7_FILIAL==xFILIAL('SC7').and.SC7->C7_NUM==__POSIGA .and.SC7->C7_ITEM==__POSICD
			RecLock("SC7",.F.)
			SC7->C7_QUANT  :=SC7->C7_QUANT-_cPAR05
			SC7->C7_TOTAL  :=(SC7->C7_QUANT-_cPAR05)*SC7->C7_PRECO
			SC7->( MsUnlock() )
			SC7->(DBSKIP())
		ENDDO

		If Select("TR5") <> 0
			TR5->( dbCloseArea() )                                                                                                               '
		EndIf

		cQueryDV5 := " SELECT * FROM SC7010 WHERE D_E_L_E_T_=''"
		cQueryDV5 += "   AND C7_FILIAL='"+xFILIAL('SC7')+"'  "
		cQueryDV5 += " 	 AND C7_NUM='"+__POSIGA+"' "
		cQueryDV5 += " 	 AND C7_ITEM='"+__POSICD+"' "

		TCQUERY cQueryDV5 NEW ALIAS "TR5"

		While !TR5->( EOF() )

			RecLock("SC7",.T.)
			SC7->C7_FILIAL   :=  xFILIAL('SC7')
			SC7->C7_ITEM     :=  __MXPOS
			SC7->C7_PRODUTO  :=  _cPAR04
			SC7->C7_QUANT    :=  _cPAR05
			SC7->C7_PO_EIC   :=  TR5->C7_PO_EIC
			SC7->C7_TIPO     :=  TR5->C7_TIPO
			SC7->C7_UM       :=  TR5->C7_UM
			SC7->C7_QTSEGUM  :=  TR5->C7_QTSEGUM
			SC7->C7_DESCRI   :=  POSICIONE('SB1',1,xFILIAL('SB1')+ _cPAR04,'B1_DESC')
			SC7->C7_XTPPC    :=  TR5->C7_XTPPC
			SC7->C7_PRECO    :=  TR5->C7_PRECO
			SC7->C7_TOTAL    :=  _cPAR05*TR5->C7_PRECO
			SC7->C7_QUJE     :=  TR5->C7_QUJE
			SC7->C7_DOMNECE  :=  STOD(TR5->C7_DOMNECE)
			SC7->C7_DATPRF   :=  STOD(TR5->C7_DATPRF)
			SC7->C7_IPI      :=  TR5->C7_IPI
			SC7->C7_RDTEMB   :=  STOD(TR5->C7_RDTEMB)
			SC7->C7_RDTIMP   :=  TR5->C7_RDTIMP
			SC7->C7_RDTOF    :=  TR5->C7_RDTOF
			SC7->C7_RDTPREV  :=  STOD(TR5->C7_RDTPREV)
			SC7->C7_NUMSC    :=  TR5->C7_NUMSC
			SC7->C7_ITEMSC   :=  TR5->C7_ITEMSC
			SC7->C7_XXORIGI  :=  STOD(TR5->C7_XXORIGI)
			SC7->C7_LOCAL    :=  TR5->C7_LOCAL
			SC7->C7_XOPER    :=  TR5->C7_XOPER
			SC7->C7_TES      :=  TR5->C7_TES
			SC7->C7_COND     :=  TR5->C7_COND
			SC7->C7_CONTATO  :=  TR5->C7_CONTATO
			SC7->C7_SEGUM    :=  TR5->C7_SEGUM
			SC7->C7_OBS      :=  TR5->C7_OBS
			SC7->C7_FORNECE  :=  TR5->C7_FORNECE
			SC7->C7_CC       :=  TR5->C7_CC
			SC7->C7_EMISSAO  :=  STOD(TR5->C7_EMISSAO)
			SC7->C7_NUM      :=  TR5->C7_NUM
			SC7->C7_CONTA    :=  TR5->C7_CONTA
			SC7->C7_ITEMCTA  :=  TR5->C7_ITEMCTA
			SC7->C7_LOJA     :=  TR5->C7_LOJA
			SC7->C7_FILENT   :=  TR5->C7_FILENT
			SC7->C7_DESC1    :=  TR5->C7_DESC1
			SC7->C7_DESC2    :=  TR5->C7_DESC2
			SC7->C7_DESC3    :=  TR5->C7_DESC3
			SC7->C7_REAJUST  :=  TR5->C7_REAJUST
			SC7->C7_FRETE    :=  TR5->C7_FRETE
			SC7->C7_EMITIDO  :=  TR5->C7_EMITIDO
			SC7->C7_TX       :=  TR5->C7_TX
			SC7->C7_TPFRETE  :=  TR5->C7_TPFRETE
			SC7->C7_QTDREEM  :=  TR5->C7_QTDREEM
			SC7->C7_ENCER    :=  TR5->C7_ENCER
			SC7->C7_OP       :=  TR5->C7_OP
			SC7->C7_CODLIB   :=  TR5->C7_CODLIB
			SC7->C7_RESIDUO  :=  TR5->C7_RESIDUO
			SC7->C7_NUMCOT   :=  TR5->C7_NUMCOT
			SC7->C7_MSG      :=  TR5->C7_MSG
			SC7->C7_CONTROL  :=  TR5->C7_CONTROL
			SC7->C7_IPIBRUT  :=  TR5->C7_IPIBRUT
			SC7->C7_SEQUEN   :=  TR5->C7_SEQUEN
			SC7->C7_NUMIMP   :=  TR5->C7_NUMIMP
			SC7->C7_VLDESC   :=  TR5->C7_VLDESC
			SC7->C7_ORIGEM   :=  TR5->C7_ORIGEM
			SC7->C7_QTDACLA  :=  TR5->C7_QTDACLA
			SC7->C7_FLUXO    :=  TR5->C7_FLUXO
			SC7->C7_VALEMB   :=  TR5->C7_VALEMB
			SC7->C7_TPOP     :=  TR5->C7_TPOP
			SC7->C7_CONAPRO  :=  TR5->C7_CONAPRO
			SC7->C7_APROV    :=  TR5->C7_APROV
			SC7->C7_GRUPCOM  :=  TR5->C7_GRUPCOM
			SC7->C7_USER     :=  TR5->C7_USER
			SC7->C7_STATME   :=  TR5->C7_STATME
			SC7->C7_OK       :=  TR5->C7_OK
			SC7->C7_DMXOB1   :=  TR5->C7_DMXOB1
			SC7->C7_DMXOB2   :=  TR5->C7_DMXOB2
			SC7->C7_DMXOB3   :=  TR5->C7_DMXOB3
			SC7->C7_BASEICM  :=  TR5->C7_BASEICM
			SC7->C7_BASEIPI  :=  TR5->C7_BASEIPI
			SC7->C7_DESC     :=  TR5->C7_DESC
			SC7->C7_DESPESA  :=  TR5->C7_DESPESA
			SC7->C7_TXMOEDA  :=  TR5->C7_TXMOEDA
			SC7->C7_MOEDA    :=  TR5->C7_MOEDA
			SC7->C7_PENDEN   :=  TR5->C7_PENDEN
			SC7->C7_PICM     :=  TR5->C7_PICM
			SC7->C7_QTDSOL   :=  TR5->C7_QTDSOL
			SC7->C7_SEGURO   :=  TR5->C7_SEGURO
			SC7->C7_VALFRE   :=  TR5->C7_VALFRE
			SC7->C7_VALICM   :=  TR5->C7_VALICM
			SC7->C7_VALIPI   :=  TR5->C7_VALIPI
			SC7->C7_DMMOEDA  :=  TR5->C7_DMMOEDA
			SC7->C7_CLVL     :=  TR5->C7_CLVL
			SC7->C7_BASEIR   :=  TR5->C7_BASEIR
			SC7->C7_ALIQIR   :=  TR5->C7_ALIQIR
			SC7->C7_SEQMRP   :=  TR5->C7_SEQMRP
			SC7->C7_VALIR    :=  TR5->C7_VALIR
			SC7->C7_ICMCOMP  :=  TR5->C7_ICMCOMP
			SC7->C7_ICMSRET  :=  TR5->C7_ICMSRET
			SC7->C7_VALITEM  :=  STOD(TR5->C7_VALITEM)
			SC7->C7_CODFORN  :=  TR5->C7_CODFORN
			SC7->C7_PRAZOMD  :=  TR5->C7_PRAZOMD
			SC7->C7_CODTAB   :=  TR5->C7_CODTAB
			SC7->C7_CONTRA   :=  TR5->C7_CONTRA
			SC7->C7_CONTREV  :=  TR5->C7_CONTREV
			SC7->C7_PLANILH  :=  TR5->C7_PLANILH
			SC7->C7_MEDICAO  :=  TR5->C7_MEDICAO
			SC7->C7_ITEMED   :=  TR5->C7_ITEMED
			SC7->C7_POLREPR  :=  TR5->C7_POLREPR
			SC7->C7_CODORCA  :=  TR5->C7_CODORCA
			SC7->C7_GRADE    :=  TR5->C7_GRADE
			SC7->C7_ITEMGRD  :=  TR5->C7_ITEMGRD
			SC7->C7_BASESOL  :=  TR5->C7_BASESOL
			SC7->C7_DTLANC   :=  STOD(TR5->C7_DTLANC)
			SC7->C7_CODCRED  :=  TR5->C7_CODCRED
			SC7->C7_NODIA    :=  TR5->C7_NODIA
			SC7->C7_DIACTB   :=  TR5->C7_DIACTB
			SC7->C7_TIPOEMP  :=  TR5->C7_TIPOEMP
			SC7->C7_ESPEMP   :=  TR5->C7_ESPEMP
			SC7->C7_PERREPR  :=  TR5->C7_PERREPR
			SC7->C7_FREPPCC  :=  TR5->C7_FREPPCC
			SC7->C7_DT_IMP   :=  STOD(TR5->C7_DT_IMP)
			SC7->C7_AGENTE   :=  TR5->C7_AGENTE
			SC7->C7_FORWARD  :=  TR5->C7_FORWARD
			SC7->C7_TIPO_EM  :=  TR5->C7_TIPO_EM
			SC7->C7_ORIGIMP  :=  TR5->C7_ORIGIMP
			SC7->C7_DEST     :=  TR5->C7_DEST
			SC7->C7_INCOTER  :=  TR5->C7_INCOTER
			SC7->C7_PESO_B   :=  TR5->C7_PESO_B
			SC7->C7_COMPRA   :=  TR5->C7_COMPRA
			SC7->C7_IMPORT   :=  TR5->C7_IMPORT
			SC7->C7_CONSIG   :=  TR5->C7_CONSIG
			SC7->C7_CONF_PE  :=  STOD(TR5->C7_CONF_PE)
			SC7->C7_DESP     :=  TR5->C7_DESP
			SC7->C7_EXPORTA  :=  TR5->C7_EXPORTA
			SC7->C7_LOJAEXP  :=  TR5->C7_LOJAEXP
			SC7->C7_CONTAIN  :=  TR5->C7_CONTAIN
			SC7->C7_MT3      :=  TR5->C7_MT3
			SC7->C7_CONTA20  :=  TR5->C7_CONTA20
			SC7->C7_CONTA40  :=  TR5->C7_CONTA40
			SC7->C7_CON40HC  :=  TR5->C7_CON40HC
			SC7->C7_ARMAZEM  :=  TR5->C7_ARMAZEM
			SC7->C7_FABRICA  :=  TR5->C7_FABRICA
			SC7->C7_LOJFABR  :=  TR5->C7_LOJFABR
			SC7->C7_DT_EMB   :=  STOD(TR5->C7_DT_EMB)
			SC7->C7_RATEIO   :=  TR5->C7_RATEIO
			SC7->C7_TEC      :=  TR5->C7_TEC
			SC7->C7_ESTOQUE  :=  TR5->C7_ESTOQUE
			SC7->C7_VALSOL   :=  TR5->C7_VALSOL
			SC7->C7_CODED    :=  TR5->C7_CODED
			SC7->C7_NUMPR    :=  TR5->C7_NUMPR
			SC7->C7_EX_NCM   :=  TR5->C7_EX_NCM
			SC7->C7_FILCEN   :=  TR5->C7_FILCEN
			SC7->C7_EX_NBM   :=  TR5->C7_EX_NBM
			SC7->C7_ACCNUM   :=  TR5->C7_ACCNUM
			SC7->C7_ACCPROC  :=  TR5->C7_ACCPROC
			SC7->C7_ACCITEM  :=  TR5->C7_ACCITEM
			SC7->C7_CODNE    :=  TR5->C7_CODNE
			SC7->C7_ITEMNE   :=  TR5->C7_ITEMNE
			SC7->C7_GCPIT    :=  TR5->C7_GCPIT
			SC7->C7_GCPLT    :=  TR5->C7_GCPLT
			SC7->C7_TIPCOM   :=  TR5->C7_TIPCOM
			SC7->C7_PLOPELT  :=  TR5->C7_PLOPELT
			//SC7->C7_OBRIGA   :=  TR5->C7_OBRIGA
			//SC7->C7_DIREITO  :=  TR5->C7_DIREITO
			SC7->C7_VALIMP5  :=  TR5->C7_VALIMP5
			SC7->C7_RETENCA  :=  TR5->C7_RETENCA
			SC7->C7_QUJEFAT  :=  TR5->C7_QUJEFAT
			SC7->C7_QUJERET  :=  TR5->C7_QUJERET
			SC7->C7_DEDUCAO  :=  TR5->C7_DEDUCAO
			SC7->C7_QUJEDED  :=  TR5->C7_QUJEDED
			SC7->C7_FATDIRE  :=  TR5->C7_FATDIRE
			SC7->C7_VALIMP6  :=  TR5->C7_VALIMP6
			SC7->C7_XQEMAIL  :=  TR5->C7_XQEMAIL
			SC7->C7_XUSRENV  :=  TR5->C7_XUSRENV
			SC7->C7_FRETCON  :=  TR5->C7_FRETCON
			SC7->C7_TRANSP   :=  TR5->C7_TRANSP
			SC7->C7_TRANSLJ  :=  TR5->C7_TRANSLJ
			SC7->C7_IDTRIB   :=  TR5->C7_IDTRIB
			SC7->C7_XDATPRF  :=  STOD(TR5->C7_XDATPRF)
			SC7->( MsUnlock() )
			TR5->( dbSkip() )
		END
		If Select("TR5") <> 0
			TR5->( dbCloseArea() )                                                                                                               '
		EndIf
	ENDIF

RETURN





STATIC FUNCTION ATUSW1()

	PRIVATE __SISIGA :=' '
	PRIVATE __PONUM  :=_cPAR01
	PRIVATE __POSICD :=_cPAR03
	PRIVATE __POSICP :=__MXPOS

	cAliasSW1 := GetNextAlias()
	cWhereSW1 := "%W1_PO_NUM = '"+ALLTRIM(__PONUM)+"'%"
	cWhereSWP := "%W1_POSICAO= '"+ALLTRIM(__POSICD)+"'%"
	BEGINSQL Alias cAliasSW1
		SELECT
			W1_SI_NUM
		FROM
			%table:SW1% (NOLOCK) SW1
		WHERE
			W1_FILIAL = %Exp:xFilial("SW1")%
			AND SW1.%NotDel%
			AND %Exp:cWhereSW1%
			AND %Exp:cWhereSWP%
	ENDSQL
	__SISIGA := (cAliasSW1)->W1_SI_NUM
	(cAliasSW1)->(dbCloseArea())

	SW1->(DbSetOrder(6)) //6	W1_FILIAL+W1_SI_NUM+W1_POSICAO+W1_COD_I

	If SW1->(dbSeek( xFilial("SW1") + __SISIGA + __POSICD))
		DO WHILE !SW1->( EOF() ) .and. SW1->W1_FILIAL==xFILIAL('SW1').and.SW1->W1_SI_NUM==__SISIGA .and.SW1->W1_POSICAO==__POSICD
			RecLock("SW1",.F.)
			SW1->W1_QTDE  :=SW1->W1_QTDE-_cPAR05
			SW1->( MsUnlock() )
			SW1->(DBSKIP())
		ENDDO

		If Select("TR5") <> 0
			TR5->( dbCloseArea() )                                                                                                               '
		EndIf

		cQueryDV5 := " SELECT * FROM SW1010 WHERE D_E_L_E_T_=''"
		cQueryDV5 += "   AND W1_FILIAL='"+xFILIAL('SW1')+"'  "
		cQueryDV5 += " 	 AND W1_SI_NUM='"+__SISIGA+"' "
		cQueryDV5 += " 	 AND W1_POSICAO='"+__POSICD+"' "

		TCQUERY cQueryDV5 NEW ALIAS "TR5"

		While !TR5->( EOF() )

			RecLock("SW1",.T.)
			SW1->W1_FILIAL   :=  xFILIAL('SW1')
			SW1->W1_COD_I       := _cPAR04
			SW1->W1_POSICAO 	:= __MXPOS
			SW1->W1_QTDE        := _cPAR05
			SW1->W1_SALDO_Q     := TR5->W1_SALDO_Q
			SW1->W1_FABR 		:= TR5->W1_FABR
			SW1->W1_FABLOJ 		:= TR5->W1_FABLOJ
			SW1->W1_FORN 		:= TR5->W1_FORN
			SW1->W1_FORLOJ 		:= TR5->W1_FORLOJ
			SW1->W1_CLASS 		:= TR5->W1_CLASS
			SW1->W1_PRECO       := TR5->W1_PRECO
			SW1->W1_DT_EMB 		:= STOD(TR5->W1_DT_EMB)
			SW1->W1_PO_NUM      := TR5->W1_PO_NUM
			SW1->W1_FLUXO 		:= TR5->W1_FLUXO
			SW1->W1_DTENTR_ 	:= STOD(TR5->W1_DTENTR_)
			SW1->W1_SEQ         := TR5->W1_SEQ
			SW1->W1_REG        	:= TR5->W1_REG
			SW1->W1_CC 		    := TR5->W1_CC
			SW1->W1_SI_NUM 		:= TR5->W1_SI_NUM
			SW1->W1_FORECAS 	:= TR5->W1_FORECAS
			SW1->W1_QTSEGUM     := TR5->W1_QTSEGUM
			SW1->W1_SEGUM 		:= TR5->W1_SEGUM
			SW1->W1_POSIT 		:= TR5->W1_POSIT
			SW1->W1_CTCUSTO 	:= TR5->W1_CTCUSTO
			SW1->W1_CODMAT  	:= TR5->W1_CODMAT
			SW1->W1_UM 		    := TR5->W1_UM
			SW1->W1_STATUS 		:= TR5->W1_STATUS
			SW1->W1_NR_CONC 	:= TR5->W1_NR_CONC
			SW1->W1_DT_CANC 	:= STOD(TR5->W1_DT_CANC)
			SW1->W1_MOTCANC   	:= TR5->W1_MOTCANC
			SW1->W1_COMPLEM   	:= TR5->W1_COMPLEM
			SW1->W1_C3_NUM 		:= TR5->W1_C3_NUM
			SW1->W1_CONDPG		:= TR5->W1_CONDPG
			SW1->( MsUnlock() )
			TR5->( dbSkip() )
		END
		If Select("TR5") <> 0
			TR5->( dbCloseArea() )                                                                                                               '
		EndIf
	ENDIF

RETURN

//----------------------------------------------------

STATIC FUNCTION ATUSW5()

	PRIVATE __SISIGA :=' '
	PRIVATE __PONUM  :=_cPAR01
	PRIVATE __POSICD :=_cPAR03
	PRIVATE __POSICP :=__MXPOS
	_cANUENTE :=''

	cAliasSW3 := GetNextAlias()
	cWhereSW3 := "%W3_PO_NUM = '"+ALLTRIM(_cPAR01)+"'%"
	cWhereSWP := "%W3_POSICAO= '"+ALLTRIM(__POSICD)+"'%"
	cWherePGI := "%W3_PGI_NUM<>' '%"
	BEGINSQL Alias cAliasSW3
		SELECT
			W3_PGI_NUM
		FROM
			%table:SW3% (NOLOCK) SW3
		WHERE
			W3_FILIAL = %Exp:xFilial("SW3")%
			AND SW3.%NotDel%
			AND %Exp:cWhereSW3%
			AND %Exp:cWhereSWP%
			AND %Exp:cWherePGI%
	ENDSQL
	__PGINUM := (cAliasSW3)->W3_PGI_NUM
	(cAliasSW3)->(dbCloseArea())

	SW5->(DbSetOrder(8)) //SW5	8	W5_FILIAL+W5_PGI_NUM+W5_PO_NUM+W5_POSICAO

	If SW5->(dbSeek( xFilial("SW5") + __PGINUM + __PONUM + __POSICD))
		DO WHILE !SW5->( EOF() ) .and. SW5->W5_FILIAL==xFILIAL('SW5').and.SW5->W5_PGI_NUM==__PGINUM.and.SW5->W5_PO_NUM==__PONUM .and.SW5->W5_POSICAO==__POSICD
			RecLock("SW5",.F.)
			SW5->W5_QTDE    :=SW5->W5_QTDE-_cPAR05
			SW5->W5_SALDO_Q :=SW5->W5_QTDE-_cPAR05
			SW5->( MsUnlock() )
			SW5->(DBSKIP())
		ENDDO

		If Select("TR5") <> 0
			TR5->( dbCloseArea() )                                                                                                               '
		EndIf

		cQueryDV5 := " SELECT * FROM SW5010 WHERE D_E_L_E_T_=''"
		cQueryDV5 += "   AND W5_FILIAL='"+xFILIAL('SW5')+"'  "
		cQueryDV5 += " 	 AND W5_PGI_NUM='"+__PGINUM+"' "
		cQueryDV5 += " 	 AND W5_PO_NUM='"+__PONUM+"' "
		cQueryDV5 += " 	 AND W5_POSICAO='"+__POSICD+"' "

		TCQUERY cQueryDV5 NEW ALIAS "TR5"

		While !TR5->( EOF() )

		//UPDATE SW5010 SET W5_SEQ_LI='000',W5_PGI_NUM='I0011564',W5_FLUXO='1' WHERE R_E_C_N_O_=98926
		_cANUENTE :=POSICIONE('SB1',1,xFILIAL('SB1')+_cPAR04,'B1_ANUENTE') //C1  1 = SIM  2 =NAO

			RecLock("SW5",.T.)
			SW5->W5_FILIAL  :=  xFILIAL('SW5')
			SW5->W5_COD_I   := _cPAR04
			SW5->W5_POSICAO := __MXPOS
			SW5->W5_QTDE    := _cPAR05
			SW5->W5_SALDO_Q := _cPAR05
       
	        IF _cANUENTE=='1'
			    SW5->W5_SEQ_LI 	:= '000'
			    SW5->W5_PGI_NUM := TR5->W5_PO_NUM
			    SW5->W5_FLUXO 	:= '1'			
			ELSE	
			    SW5->W5_SEQ_LI 	:= TR5->W5_SEQ_LI
  			    SW5->W5_PGI_NUM := TR5->W5_PGI_NUM
			    SW5->W5_FLUXO 	:= TR5->W5_FLUXO			
			ENDIF	

			SW5->W5_PO_NUM  := TR5->W5_PO_NUM
			SW5->W5_PESO    := TR5->W5_PESO
			SW5->W5_PRECO   := TR5->W5_PRECO
			SW5->W5_CC 	    := TR5->W5_CC
			SW5->W5_SI_NUM 	:= TR5->W5_SI_NUM
			SW5->W5_TEC     := TR5->W5_TEC
			SW5->W5_FABR 	:= TR5->W5_FABR
			SW5->W5_FABLOJ 	:= TR5->W5_FABLOJ
			SW5->W5_FORN 	:= TR5->W5_FORN
			SW5->W5_FORLOJ 	:= TR5->W5_FORLOJ
			SW5->W5_DT_EMB 	:= STOD(TR5->W5_DT_EMB)
			SW5->W5_DT_ENTR := STOD(TR5->W5_DT_ENTR)
			SW5->W5_HAWB    := TR5->W5_HAWB
			SW5->W5_FABR_01 := TR5->W5_FABR_01
			SW5->W5_FAB1LOJ := TR5->W5_FAB1LOJ
			SW5->W5_FABR_02 := TR5->W5_FABR_02
			SW5->W5_FAB2LOJ := TR5->W5_FAB2LOJ
			SW5->W5_FABR_03 := TR5->W5_FABR_03
			SW5->W5_FAB3LOJ := TR5->W5_FAB3LOJ
			SW5->W5_FABR_04 := TR5->W5_FABR_04
			SW5->W5_FAB4LOJ := TR5->W5_FAB4LOJ
			SW5->W5_FABR_05 := TR5->W5_FABR_05
			SW5->W5_FAB5LOJ := TR5->W5_FAB5LOJ
			SW5->W5_DOCTO_F := TR5->W5_DOCTO_F
			SW5->W5_DEF_REQ := TR5->W5_DEF_REQ
			SW5->W5_PARCIAL := TR5->W5_PARCIAL
		

			SW5->W5_SEQ     := TR5->W5_SEQ
			SW5->W5_REG     := TR5->W5_REG
			SW5->W5_NBM     := TR5->W5_NBM
			SW5->W5_DT_SHIP := STOD(TR5->W5_DT_SHIP)
			SW5->W5_EX_NBM 	:= TR5->W5_EX_NBM
			SW5->W5_EX_NCM 	:= TR5->W5_EX_NCM
			SW5->W5_AC      := TR5->W5_AC
			SW5->W5_SEQSIS 	:= TR5->W5_SEQSIS
			SW5->W5_QT_AC   := TR5->W5_QT_AC
			SW5->W5_VL_AC   := TR5->W5_VL_AC
			SW5->W5_QT_AC2  := TR5->W5_QT_AC2
			SW5->W5_OPERACA := TR5->W5_OPERACA
			SW5->W5_PESO_BR := TR5->W5_PESO_BR
			SW5->W5_INVANT  := TR5->W5_INVANT
			SW5->W5_CODOPE 	:= TR5->W5_CODOPE
			SW5->W5_NVE 	:= TR5->W5_NVE
			SW5->W5_FRETE   := TR5->W5_FRETE
			SW5->W5_SEGURO  := TR5->W5_SEGURO
			SW5->W5_INLAND  := TR5->W5_INLAND
			SW5->W5_DESCONT := TR5->W5_DESCONT
			SW5->W5_PACKING	:= TR5->W5_PACKING
			SW5->( MsUnlock() )
			TR5->( dbSkip() )
		END
		If Select("TR5") <> 0
			TR5->( dbCloseArea() )                                                                                                               '
		EndIf
	ENDIF

RETURN





