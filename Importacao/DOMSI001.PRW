#INCLUDE "TOPCONN.CH"
#INCLUDE "FIVEWIN.CH"
#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#Include "COLORS.CH"
#Include "FONT.CH"
#INCLUDE "MSOBJECT.CH"
#include 'parmtype.ch'

User Function DOMSI001()

	Local  aCampos  :={}
	Local _aCampos :={}

	Private cQuery
	Private cQR1
	Private _cMarca
	Private bMark    := {|| Mark()}
	Private cCadastro:= "SI EM ABERTO"
	Private aRotina := {{"Gerar PO", "U_DOMSIG01",0,1}}
	Private lInverte :=.T.
	private cTitle :='SI EM ABERTO'
	private lEXECUTAR :=.F.

	private	 oDlg
	private	 oSay1
	private	 oSay2
	private	 nGet1:=0
	private	_cTXTPRC :=''


	_cMarca:= SC6->(GetMark())

// ATUALIZA B1_UPRC COM PREÇO DO ULTIMO PO
	cQR1:= " UPDATE SB1010  WITH(NOLOCK) SET B1_UPRC=(SELECT TOP 1 W3_PRECO FROM SW3010 (NOLOCK) WHERE W3_FILIAL = '"+xFILIAL('SW3')+"' AND B1_COD=W3_COD_I AND D_E_L_E_T_=''ORDER BY W3_DT_ENTR DESC) "
	cQR1+= " WHERE               EXISTS(SELECT TOP 1 W3_PRECO FROM SW3010 (NOLOCK) WHERE W3_FILIAL = '"+xFILIAL('SW3')+"' AND B1_COD=W3_COD_I AND D_E_L_E_T_=''ORDER BY W3_DT_ENTR DESC) "
	cQR1+= " AND D_E_L_E_T_=''  "
	TCSQLEXEC(cQR1)

	cQR1B:= " UPDATE SC1010 WITH(NOLOCK) SET C1_PEDIDO=''  "
	cQR1B+= " where C1_FILIAL ='"+xFILIAL('SC1')+"'  AND C1_NUM_SI<>'' and C1_PEDIDO<>'' and D_E_L_E_T_=''   "
	cQR1B+= " and            C1_PEDIDO+C1_NUM  +C1_PRODUTO+C1_ITEM "
	cQR1B+= " not in (select C7_NUM   +C7_NUMSC+C7_PRODUTO+C7_ITEMSC from SC7010 with(nolock) WHERE C7_FILIAL = '"+xFILIAL('SC1')+"'  AND D_E_L_E_T_='' and C7_NUM=C1_PEDIDO) "
	TCSQLEXEC(cQR1B)

	cQR1C := " UPDATE SC1010  WITH(NOLOCK) SET C1_QUJE=0 WHERE  C1_FILIAL = '"+xFILIAL('SC1')+"'  AND C1_QUJE <0  and D_E_L_E_T_=''  "
	TCSQLEXEC(cQR1C)

	cQR1D := " UPDATE SW1010  WITH(NOLOCK) SET W1_SALDO_Q=W1_QTDE WHERE W1_FILIAL= '"+xFILIAL('SW1')+"' AND W1_SALDO_Q>W1_QTDE AND D_E_L_E_T_='' AND W1_FORN='' "
	TCSQLEXEC(cQR1D)

	cQR1VIA := " UPDATE ZZ2010 SET ZZ2_NVIA=(SELECT YQ_DESCR FROM SYQ010 WHERE D_E_L_E_T_='' AND YQ_VIA=ZZ2_TIPO_E) "
	TCSQLEXEC(cQR1VIA)

	AADD(aCampos,{"C6_OK"      ,"",""            ,""  } )
	AADD(aCampos,{"ZZ_FORNEC"  ,"","Fornecedor"  ,"@!"  } )
	AADD(aCampos,{"W0__NUM"    ,"","Num. SI"     ,"@!"} )
	AADD(aCampos,{"W0_C1_NUM"  ,"","Num. SC"     ,"@!"} )
	AADD(aCampos,{"W0__DT"     ,"","Data"        ,""  } )
	AADD(aCampos,{"W1_POSICAO" ,"","Item"        ,"@!"} )
	AADD(aCampos,{"W1_COD_I"   ,"","Produto"     ,"@!"} )
	AADD(aCampos,{"C1_DESCRI"  ,"","Descricao"   ,"@!"} )
	AADD(aCampos,{"W1_SALDO_Q" ,"","Saldo"       ,"@E 999,999,999.99"})  // 1.160.000,00
	AADD(aCampos,{"ZZ_UPRC"    ,"","U_PRC"       ,"@E 999,999.99999"})
	AADD(aCampos,{"W1_DTENTR_" ,"","Entrega"     ,""})
	AADD(aCampos,{"C1_OBS"     ,"","obs"         ,"@!"} )
	AADD(aCampos,{"W0_COMPRA"  ,"","Comprador"   ,"@!"} )
	AADD(aCampos,{"W0_SOLIC"   ,"","Solicitante" ,"@!"} )
	AADD(aCampos,{"W0__CC"     ,"","C.Custo"     ,"@!"} )

	AADD(_aCampos,{"C6_OK"      ,"C",Len(CriaVar("C6_OK",.F.))     ,0} )
	AADD(_aCampos,{"ZZ_FORNEC"  ,"C",30                            ,0} )
	AADD(_aCampos,{"W0__NUM"    ,"C",Len(CriaVar("W0__NUM",.F.))   ,0} )
	AADD(_aCampos,{"W0_C1_NUM"  ,"C",Len(CriaVar("W0_C1_NUM",.F.)) ,0} )
	AADD(_aCampos,{"W0__DT"     ,"D",8                             ,0} )
	AADD(_aCampos,{"W1_POSICAO" ,"C",Len(CriaVar("W1_POSICAO",.F.)),0} )
	AADD(_aCampos,{"W1_COD_I"   ,"C",Len(CriaVar("W1_COD_I",.F.))  ,0} )
	AADD(_aCampos,{"C1_DESCRI"  ,"C",Len(CriaVar("C1_DESCRI",.F.)) ,0} )
	AADD(_aCampos,{"W1_SALDO_Q" ,"N",14                            ,2} )
	AADD(_aCampos,{"ZZ_UPRC"    ,"N",14                            ,5} )
	AADD(_aCampos,{"W1_DTENTR_" ,"D",8                             ,0} )
	AADD(_aCampos,{"C1_OBS"     ,"C",Len(CriaVar("C1_OBS",.F.))    ,0} )
	AADD(_aCampos,{"W0_COMPRA"  ,"C",Len(CriaVar("W0_COMPRA",.F.)) ,0} )
	AADD(_aCampos,{"W0_SOLIC"   ,"C",10                            ,0} )
	AADD(_aCampos,{"W0__CC"     ,"C",Len(CriaVar("W0__CC",.F.))    ,0} )

	cNomeArq:=CriaTrab(_aCampos, .t. )
	dbUseArea(.T.,__LocalDriver,cNomeArq,"QRT",.F.,.F.)

	cQuery := " SELECT '   ' AS C6_OK, "
	cQuery += " (SELECT TOP 1 SUBSTRING(W3_FORN+'/'+W3_FORLOJ+' '+A2_NREDUZ,1,30)   "
	cQuery += " FROM SW3010 (NOLOCK),SA2010 (NOLOCK)  "
	cQuery += " WHERE A2_COD+A2_LOJA=W3_FORN+W3_FORLOJ AND W3_COD_I=W1_COD_I AND SW3010.D_E_L_E_T_=' ' AND SA2010.D_E_L_E_T_=' '  "
	cQuery += "  AND W3_FILIAL='"+xFILIAL('SW3')+"' AND A2_FILIAL='"+xFILIAL('SA2')+"'
	cQuery += " ORDER BY W3_DT_EMB DESC) AS ZZ_FORNEC, "
	cQuery += " W0__CC,W0__NUM,W0__DT,W0_COMPRA,W0_C1_NUM, "
	cQuery += " SUBSTRING(W0_SOLIC,1,10)  AS W0_SOLIC, "
	cQuery += " W1_POSICAO,W1_COD_I,C1_DESCRI, "
	cQuery += " W1_SALDO_Q, "
	cQuery += " (SELECT B1_UPRC FROM SB1010 (NOLOCK) WHERE B1_FILIAL ='"+xFILIAL('SB1')+"' AND B1_COD=W1_COD_I AND D_E_L_E_T_='') AS ZZ_UPRC, "
	cQuery += " W1_DTENTR_,C1_OBS   "
	cQuery += " FROM SW0010 (NOLOCK) W0, SW1010 (NOLOCK) W1, SC1010 (NOLOCK) C1  "
	cQuery += " WHERE  W0__NUM=W1_SI_NUM  "
	cQuery += " AND    C1_NUM=W0_C1_NUM AND C1_PRODUTO=W1_COD_I AND W1_POSICAO=C1_ITEM  "
	cQuery += " AND W0_FILIAL='"+xFILIAL('SW0')+"' "
	cQuery += " AND W1_FILIAL='"+xFILIAL('SW1')+"' "
	cQuery += "	AND C1_FILIAL='"+xFILIAL('SC1')+"' "
	cQuery += " AND W0.D_E_L_E_T_=''  "
	cQuery += " AND W1.D_E_L_E_T_=''  "
	cQuery += " AND C1.D_E_L_E_T_=''  "
	cQuery += " AND C1_PEDIDO=''  "
	cQuery += " AND W1_PO_NUM=''  "
	cQuery += " AND C1_RESIDUO='' "
	cQuery += " AND C1_QUJE=0   "
	cQuery += " AND W1_SALDO_Q >0 "
	cQuery += " order by ZZ_FORNEC,W0__NUM,W1_POSICAO "

	TCQUERY cQuery Alias "TMP" New

	while TMP->(!EOF())
		If Reclock("QRT",.T.)

			QRT->C6_OK      := _cMarca
			QRT->ZZ_FORNEC  := TMP->ZZ_FORNEC
			QRT->W0__CC     := TMP->W0__CC
			QRT->W0__NUM    := TMP->W0__NUM
			QRT->W0__DT     := CTOD(SUBSTR(TMP->W0__DT,7,2)+'/'+SUBSTR(TMP->W0__DT,5,2)+'/'+SUBSTR(TMP->W0__DT,1,4))
			QRT->W0_COMPRA  := TMP->W0_COMPRA
			QRT->W0_C1_NUM  := TMP->W0_C1_NUM
			QRT->W0_SOLIC   := TMP->W0_SOLIC
			QRT->W1_POSICAO := TMP->W1_POSICAO
			QRT->W1_COD_I   := TMP->W1_COD_I
			QRT->C1_DESCRI  := TMP->C1_DESCRI
			QRT->W1_SALDO_Q := TMP->W1_SALDO_Q
			QRT->ZZ_UPRC    := TMP->ZZ_UPRC
			QRT->W1_DTENTR_ := CTOD(SUBSTR(TMP->W1_DTENTR_,7,2)+'/'+SUBSTR(TMP->W1_DTENTR_,5,2)+'/'+SUBSTR(TMP->W1_DTENTR_,1,4))
			QRT->C1_OBS     := TMP->C1_OBS
			QRT->(msUnlock())
		endif
		TMP->(dbSkip())
	Enddo

	MarkBrow('QRT','C6_OK',,aCampos,lInverte,_cMarca ,'U_MAllW0()',,,,'U_Markw0()' )

	If Select("QRT") <> 0
		QRT->( dbCloseArea() )
	EndIf

Return

	*--------------------------------------------------------*
USER Function Markw0()
	*--------------------------------------------------------*
	Local lDesmarc := IsMark("C6_OK", _cMarca, .t.)

	IF EMPTY(QRT->C6_OK)
		QRT->(RecLock( 'QRT', .F. ))
		QRT->C6_OK:=_cMarca
		QRT->(MsUnLock())
	ELSE
		QRT->(RecLock( 'QRT', .F. ))
		QRT->C6_OK:=Space(3)
		QRT->(MsUnLock())
	ENDIF

Return

/*If !lDesmarc
DbSelectArea("SB1")
SB1->(dbSeek(xFilial("SB1")+TMPB1->B1_COD))
RecLock("SB1",.F.)
Replace B1_OK With Space(2)
SB1->( MsUnlock() )
Else
DbSelectArea("SB1")
SB1->(dbSeek(xFilial("SB1")+TMPB1->B1_COD))
RecLock("SB1",.F.)
Replace B1_OK With cMarca
SB1->( MsUnlock() )
EndIf
*/

Return

	*--------------------------------------------------------*
USER Function MAllW0()
	*--------------------------------------------------------*
	Local nRecno := QRT->(Recno())
	dbSelectArea('QRT')
	QRT->(dbGotop())
	While !QRT->(Eof())
		U_Markw0()
		QRT->(dbSkip())
	End
	QRT->(dbGoto( nRecno ))
Return

	*--------------------------------------------------------*
USER Function DOMSIG01()
	*--------------------------------------------------------*

	dbSelectArea('QRT')
	QRT->(dbGotop())
	u_DOMPOExecAuto()

Return

	*----------------------------------------------------------------------------------------------------------------------------*
User Function DOMPOExecAuto()
	*----------------------------------------------------------------------------------------------------------------------------*
	Local   aCab        := {}
	Local   aItem       := {}

	Local cFORN    :=''
	Local cCOMPRA  := ''
	Local cIMPORT  := ''
	Local cAGENTE  := ''
	Local cTIPO_EM := ''
	Local cORIGEM  := ''
	Local cDEST    := ''
	Local cINCOTER := ''
	Local cFREPPCC := ''
	Local cCOND_PA := ''
	Local cMOEDA   := ''
	Local nPARID_U := 0
	Local cE_LC    := ''
	Local cFORLOJ  := ''
	Local cFORWARD := ''
	Local nDIAS_PA := 0
	Local cTAB_PC  := ''
	Local cCOD_MSG := ''
	Local cDESP    := ''

	Local cCOD_I    := ''
	Local cCC       := ''
	Local nEG       := 0
	Local nPRECO    := 0
	Local cFABR     := ''
	Local nQTDE     := ''
	Local dDTENTR_  := date()
	Local nSALDO_Q  := 0
	Local cSI_NUM   := ''
	Local cPOSICAO  := ''
	Local cPO_NUM   := ''
	Local cFABLOJ   := ''
	Local lExec     := .F.

	PRIVATE nLT    :=0

	Private lMsErroAuto := .F.
	PRIVATE _cPO_NUM    :=''
	PRIVATE cQUERY1     :=''

	PRIVATE oTelaPO1
	PRIVATE ocPO
	PRIVATE oFORNECEDOR
	PRIVATE oIMPORT2
	PRIVATE oDESP2
	PRIVATE oDESC1
	PRIVATE oDESC2
	PRIVATE oDESC3
	PRIVATE oParametro
	PRIVATE oLOJAPAR
	PRIVATE oVIAPAR
	PRIVATE oVIADES

	PRIVATE cParametro  :=SPACE(06)
	PRIVATE CLOJAPAR    :=SPACE(02)
	PRIVATE CVIAPAR     :=SPACE(02)
	PRIVATE CVIADES     :=SPACE(40)

	PRIVATE cPO          := ''
	PRIVATE cFORNECEDOR  := SPACE(06)
	PRIVATE cIMPORT2     := SPACE(06)
	PRIVATE cDESP2       := SPACE(06)
	PRIVATE cDESC1       := SPACE(40)
	PRIVATE cDESC2       := SPACE(40)
	PRIVATE cDESC3       := SPACE(40)

	PRIVATE oFont1       := TFont():New("Arial Narrow",,018,,.F.,,,,,.F.,.F.)

	PRIVATE 	_cDRBCK     :=SPACE(01)
	PRIVATE 	_cDRBCK2    :=SPACE(01)

	cQUERY1 := " SELECT TOP 1 W2_PO_NUM FROM SW2010 (NOLOCK) "
	cQUERY1 += " WHERE SUBSTRING(W2_PO_NUM,1,1)='I' AND LEN(W2_PO_NUM)=8 AND D_E_L_E_T_='' AND W2_PO_DT>='20170101' "
	cQUERY1 += " AND W2_FILIAL='"+xFILIAL('SW2')+"' "
	cQUERY1 += " order by W2_PO_NUM DESC  "

	TCQUERY cQUERY1 Alias "TR2" New

	_cPO_NUM := TR2->W2_PO_NUM
	_cPO_NUM := Soma1(_cPO_NUM,8)

	cPO :=_cPO_NUM

	If Select("TR2") <> 0
		TR2->( dbCloseArea() )
	EndIf

//  TELA SELEÇÃO FORNECEDOR / PARAMETROS

	cFORNECEDOR  := SPACE(06)
	cDESC1       := SPACE(40)

	QRT->(dbGotop())
	lFIRST :=.T.
	While !QRT->(Eof())
		IF empty(QRT->C6_OK)
			IF lFIRST ==.T.
				lFIRST :=.F.
				Define MsDialog oTelaPO1 Title OemToAnsi("Purchase Order - PO"  ) FROM 000, 000  TO 310, 900 COLORS 0, 16777215 PIXEL  //350

				@ 002,005 GROUP oGroupA TO 080, 380 PROMPT "Parametros"     OF oTelaPO1 COLOR 0, 16777215 PIXEL
				@ 085,005 GROUP oGroupB TO 130, 380 PROMPT "Conta e Ordem"  OF oTelaPO1 COLOR 0, 16777215 PIXEL
				@ 002,385 GROUP oGroupC TO 130, 445 PROMPT "Ações"          OF oTelaPO1 COLOR 0, 16777215 PIXEL

				@ 15,010 Say "PO  "                Size 050,20     PIXEL OF oTelaPO1 FONT oFont1  PIXEL //COLORS 16711680, 16777215 PIXEL
				@ 12,060 MSGet ocPO Var cPO  F3 "SC2" WHEN(.F.) Size 070,10 COLOR CLR_HBLUE     PIXEL OF oTelaPO1  FONT oFont1 COLORS 16711680, 16777215 PIXEL //VALID (ELFVLDOP(_COP))
				ocPO:oFont := TFont():New("Arial Narrow",,18,,.T.,,,,.T.,.F.)

				@ 30,010 Say "Fornecedor "   Size 050,20                                  PIXEL OF oTelaPO1  FONT oFont1 PIXEL //COLORS 16711680, 16777215 PIXEL
				@ 27,060 MSGet oFORNECEDOR  Var cFORNECEDOR  F3 "SA5PO"  WHEN(.T.)  Size 070,10 COLOR CLR_BLUE     PIXEL OF oTelaPO1

				oFORNECEDOR:oFont := TFont():New("Arial Narrow",,18,,.T.,,,,.T.,.F.)
				@ 27,130 MSGet oDESC1  Var cDESC1     WHEN(.F.) Size 210,10 COLOR CLR_BLUE     PIXEL OF oTelaPO1
				oDESC1:oFont := TFont():New("Arial Narrow",,18,,.T.,,,,.T.,.F.)

				@ 45,010 Say "Parametro "   Size 050,20                                  PIXEL OF oTelaPO1  FONT oFont1 PIXEL //COLORS 16711680, 16777215 PIXEL
				@ 42,060 MSGet oParametro  Var cParametro      F3 "ZZ2PAR"  WHEN(.T.)  Size 070,10 Valid U420VAL2() COLOR CLR_BLUE     PIXEL OF oTelaPO1
				oParametro:oFont := TFont():New("Arial Narrow",,18,,.T.,,,,.T.,.F.)

				@ 42,130 MSGet oLOJAPAR  Var CLOJAPAR     WHEN(.F.) Size 40,10 COLOR CLR_BLUE     PIXEL OF oTelaPO1
				oLOJAPAR:oFont := TFont():New("Arial Narrow",,18,,.T.,,,,.T.,.F.)

				@ 42,170 MSGet oVIAPAR  Var CVIAPAR       WHEN(.F.) Size 40,10 COLOR CLR_BLUE     PIXEL OF oTelaPO1
				oVIAPAR:oFont := TFont():New("Arial Narrow",,18,,.T.,,,,.T.,.F.)

      			@ 42,210 MSGet oVIADES  Var CVIADES       WHEN(.F.) Size 130,10 COLOR CLR_BLUE     PIXEL OF oTelaPO1
				oVIADES:oFont := TFont():New("Arial Narrow",,18,,.T.,,,,.T.,.F.)


				// conta e ordem----------------------------------------------------------------------
				@ 100,010 Say "Importador"    Size 050,20 PIXEL OF oTelaPO1  FONT oFont1  PIXEL //COLORS 16711680, 16777215 PIXEL
				@ 097,060 MSGet oIMPORT2   Var cIMPORT2   F3 "SYT"  WHEN(.T.)  Size 070,10 Valid U420VAL() COLOR CLR_BLUE PIXEL OF oTelaPO1

				oIMPORT2:oFont := TFont():New("Arial Narrow",,18,,.T.,,,,.T.,.F.)
				@ 097,130 MSGet oDESC2  Var cDESC2    WHEN(.F.) Size 210,10 COLOR CLR_BLUE     PIXEL OF oTelaPO1
				oDESC2:oFont := TFont():New("Arial Narrow",,18,,.T.,,,,.T.,.F.)

				@ 115,010 Say "Despachante"    Size 050,20 PIXEL OF oTelaPO1  FONT oFont1 PIXEL //COLORS 16711680, 16777215 PIXEL
				@ 112,060 MSGet oDesp2   Var cDesp2   F3 "DES"  WHEN(.T.)  Size 070,10 Valid U420VAL() COLOR CLR_BLUE PIXEL OF oTelaPO1

				oDESP2:oFont := TFont():New("Arial Narrow",,18,,.T.,,,,.T.,.F.)
				@ 112,130 MSGet oDESC3  Var cDESC3    WHEN(.F.) Size 210,10 COLOR CLR_BLUE     PIXEL OF oTelaPO1
				oDESC3:oFont := TFont():New("Arial Narrow",,18,,.T.,,,,.T.,.F.)

				//-----------------------------------------------------------------------------------

				//@ 015,390 Button "Gerar" Size 50,13 Action fFechar()       Pixel
				@ 015,390 Button "Gerar" Size 50,13 Action (lExec := .t.,fFechar())       Pixel
				@ 030,390 Button "Sair"  SIZE 50,13 Action (lExec := .f.,Close(oTelaPO1))

				Activate MsDialog  oTelaPO1
			ENDIF
		ENDIF
		QRT->(dbSkip())
	EndDO

	IF lExec
		IF ZZ2->(DBSEEK(xFilial('ZZ2')+cFORNECEDOR+CLOJAPAR+CVIAPAR )) .AND. lEXECUTAR
			// parametros ok
			DO WHILE !ZZ2->(EOF()) .AND. ZZ2->ZZ2_FORN==cFORNECEDOR
				IF ZZ2->ZZ2_FORLOJ==CLOJAPAR .AND. ZZ2->ZZ2_TIPO_E==CVIAPAR

					cFORN    :=ZZ2->ZZ2_FORN
					cCOMPRA  :=ZZ2->ZZ2_COMPRA
					cIMPORT  :=ZZ2->ZZ2_IMPORT
					cAGENTE  :=ZZ2->ZZ2_AGENTE
					cTIPO_EM :=ZZ2->ZZ2_TIPO_E
					cORIGEM  :=ZZ2->ZZ2_ORIGEM
					cDEST    :=ZZ2->ZZ2_DEST
					cINCOTER :=ZZ2->ZZ2_INCOTE
					cFREPPCC :=ZZ2->ZZ2_FREPPC
					cCOND_PA :=ZZ2->ZZ2_CONDPA
					cMOEDA   :=ZZ2->ZZ2_MOEDA
					nPARID_U :=1
					cE_LC    :='2'
					cFORLOJ  :=ZZ2->ZZ2_FORLOJ
					cFORWARD :=ZZ2->ZZ2_FORWAR
					nLT      :=ZZ2->ZZ2_LT

					IF SY6->(DBSEEK(xFilial()+cCOND_PA))
						nDIAS_PA :=SY6->Y6_DIAS_PA
					ELSE
						nDIAS_PA :=0
					ENDIF
					cTAB_PC  :=ZZ2->ZZ2_TAB_PC
					cCOD_MSG :=ZZ2->ZZ2_COD_MS
					cDESP    :=ZZ2->ZZ2_DESP

					//  FIM TELA

					AADD(aCab,{"W2_PO_NUM"    ,_cPO_NUM    ,NIL})
					AADD(aCab,{"W2_PO_DT"     ,dDatabase   ,NIL})
					AADD(aCab,{"W2_FORN"      ,cFORN       ,NIL})  //ZZ2_FORN
					AADD(aCab,{"W2_COMPRA"    ,cCOMPRA     ,NIL})  //ZZ2_COMPRA
					AADD(aCab,{"W2_IMPORT"    ,cIMPORT     ,NIL})  //ZZ2_IMPORT
					AADD(aCab,{"W2_AGENTE"    ,cAGENTE     ,NIL})  //ZZ2_AGENTE
					AADD(aCab,{"W2_TIPO_EM"   ,cTIPO_EM    ,NIL})  //ZZ2_TIPO_E
					AADD(aCab,{"W2_ORIGEM"    ,cORIGEM     ,NIL})  //ZZ2_ORIGEM
					AADD(aCab,{"W2_DEST"      ,cDEST       ,NIL})  //ZZ2_DEST
					AADD(aCab,{"W2_INCOTER"   ,cINCOTER    ,NIL})  //ZZ2_INCOTE
					AADD(aCab,{"W2_FREPPCC"   ,cFREPPCC    ,NIL})  //ZZ2_FREPPC
					AADD(aCab,{"W2_COND_PA"   ,cCOND_PA    ,NIL})  //ZZ2_CONDPA
					AADD(aCab,{"W2_MOEDA"     ,cMOEDA      ,NIL})  //ZZ2_MOEDA
					AADD(aCab,{"W2_DT_PAR"    ,dDatabase   ,NIL})
					AADD(aCab,{"W2_PARID_U"   ,nPARID_U    ,NIL})
					AADD(aCab,{"W2_E_LC"      ,"2"         ,NIL})
					AADD(aCab,{"W2_FORLOJ"    ,cFORLOJ     ,NIL})  //ZZ2_FORLOJ
					AADD(aCab,{"W2_FORWARD"   ,cFORWARD    ,NIL})  //ZZ2_FORWAR
					AADD(aCab,{"W2_DIAS_PA"   ,nDIAS_PA    ,NIL})  //ZZ2_DIAS_P
					AADD(aCab,{"W2_TAB_PC"    ,cTAB_PC     ,NIL})  //ZZ2_TAB_PC
					AADD(aCab,{"W2_COD_MSG"   ,cCOD_MSG    ,NIL})  //ZZ2_COD_MS
					AADD(aCab,{"W2_DESP"      ,cDESP       ,NIL})  //ZZ2_DESP
					// CONTA E ORDEM
					IF !EMPTY(cIMPORT2)
						AADD(aCab,{"W2_IMPCO"    ,"1"         ,NIL})
						//AADD(aCab,{"W2_IMPORT"   ,cIMPORT2    ,NIL})
						//AADD(aCab,{"W2_DESP"     ,cDESP2      ,NIL})
					ENDIF

					SW1->(DBSELECTAREA('SW1'))
					SW1->(DBSETORDER(6))  		//(5)  W1_FILIAL+W1_SI_NUM+W1_POSICAO+W1_COD_I  old  //QRT->W0__NUM  QRT->W1_POSICAO  QRT->W1_COD_I
					//(6)  W1_FILIAL+W1_SI_NUM+W1_POSICAO+W1_COD_I
					QRT->(dbGotop())
					While !QRT->(Eof())
						IF empty(QRT->C6_OK)
							_cDRBCK  :=SPACE(01)
							_cDRBCK2 :=SPACE(01)

							IF (SW1->(DBSEEK(XFILIAL('SW1')+QRT->W0__NUM+QRT->W1_POSICAO+QRT->W1_COD_I)))

								cCOD_I    := SW1->W1_COD_I
								cCC       := SW1->W1_CC
								nEG       := SW1->W1_REG
								nPRECO    := QRT->ZZ_UPRC
								cFABR     := cFORN
								cFORN     := cFORN
								nQTDE     := SW1->W1_SALDO_Q
								SY9->(dbSetOrder(2))
								dtEntCalc := dDatabase + SYR->YR_TRANS_TM + IF(SY9->(DBSEEK(xFilial()+cDEST)),(SY9->Y9_LT_DES + SY9->Y9_LT_TRA),GetMv("MV_LT_DESE"))
								dDTENTR_  :=  dtEntCalc
								nSALDO_Q  := SW1->W1_SALDO_Q
								cSI_NUM   := QRT->W0__NUM
								cPOSICAO  := QRT->W1_POSICAO
								cPO_NUM   := SW1->W1_PO_NUM
								cFORLOJ   := cFORLOJ
								cFABLOJ   := cFORLOJ
								_cDRBCK   := POSICIONE('SB1',1,xFILIAL('SB1')+cCOD_I,'B1_XXDRBCK')  //B1_XXDRBCK='S'
								IF ALLTRIM(_cDRBCK)=='S'
									_cDRBCK2 :='1'
								ELSE
									_cDRBCK2 :='7'
								ENDIF
								IF dDTENTR_<QRT->W1_DTENTR_
									dDTENTR_:=QRT->W1_DTENTR_
								ENDIF

								dDTENBA_:=dDTENTR_-(nLT)  //MLS LT ZZ2_LT
								// ANTES DE MONTAR SW3
								_cCodi:='Produto: '+ALLTRIM(cCOD_I)+' '+POSICIONE('SB1',1,xFILIAL('SB1')+cCOD_I,'B1_DESC')
								_cUPRC  :=Transform(nPRECO,"@E 999,999.9999")
								nGet1   :=0
								_nPRTAB :=0
								//2	AIB_FILIAL+AIB_CODFOR+AIB_LOJFOR+AIB_CODTAB+AIB_CODPRO
								_nPRTAB :=POSICIONE('AIB',2,xFILIAL('AIB')+cFORN+cFORLOJ+'001'+cCOD_I,'AIB_PRCCOM')
								_cPRTAB :=Transform(_nPRTAB,"@E 999,999.9999")
								_cPRC   :='UPRC: '+ _cUPRC+' TABELA: '+_cPRTAB

								_cTXTPRC :=''
								IF _nPRTAB<=0
									nGet1:=nPRECO
									_cTXTPRC :='Ultimo PRC'
								ELSE
									nGet1:=_nPRTAB
									_cTXTPRC :='Tabela PRC'
								ENDIF

								_cPRFOR :='0,0000'

								SA5->(DBSELECTAREA('SA5'))
								SA5->(DBSETORDER(2))  		//2	A5_FILIAL+A5_PRODUTO+A5_FORNECE+A5_LOJA
								IF SA5->(DBSEEK(xFilial('SA5')+cCOD_I+cFORN+cFORLOJ))
									IF SA5->A5_VLCOTUS>0
										nGet1:=SA5->A5_VLCOTUS
										_cTXTPRC :='Produto x Fornecedor '+SA5->A5_MOE_US
										_cPRFOR :=Transform(SA5->A5_VLCOTUS,"@E 999,999.9999")
									ENDIF
								ENDIF
								_cPRC   :='UPRC: '+ _cUPRC+' TABELA: '+_cPRTAB+' PRCFOR: '+_cPRFOR

								DEFINE MSDIALOG oDlg TITLE "Preço de Compra "+_cTXTPRC FROM 000, 000  TO 110, 350 COLORS 0, 16777215 PIXEL

								@ 004, 004 SAY oSay1 PROMPT _cCodi SIZE 150, 007 OF oDlg COLORS 0, 16777215 PIXEL
								@ 014, 004 SAY oSay2 PROMPT _cPRC  SIZE 150, 010 OF oDlg COLORS 0, 16777215 PIXEL
								@ 024, 004 MSGET oGet1 VAR nGet1  SIZE 060, 010 Picture "@E 999,999.9999"  OF oDlg COLORS 0, 16777215 PIXEL
								@ 038, 120 BUTTON oButton1 PROMPT "Confirmar"  SIZE 037, 012 Action Close(oDlg) OF oDlg PIXEL

								ACTIVATE MSDIALOG oDlg

								nPRECO :=nGet1

								aAdd(aItem,{  {"W3_COD_I"   ,  cCOD_I    ,NIL},;
									{"W3_CC"      ,  cCC       ,NIL},;
									{"W3_REG"     ,  nEG       ,NIL},;
									{"W3_PRECO"   ,  nPRECO    ,NIL},;
									{"W3_FABR"    ,  cFABR     ,NIL},;
									{"W3_FORN"    ,  cFORN     ,NIL},;
									{"W3_QTDE"    ,  nQTDE     ,NIL},;
									{"W3_DT_EMB"  ,  dDTENBA_  ,NIL},;
									{"W3_DT_ENTR" ,  dDTENTR_  ,NIL},;
									{"W3_SALDO_Q" ,  nSALDO_Q  ,NIL},;
									{"W3_SI_NUM"  ,  cSI_NUM   ,NIL},;
									{"W3_POSICAO" ,  cPOSICAO  ,NIL},;
									{"W3_PO_NUM"  ,  cPO_NUM   ,NIL},;
									{"W3_FLUXO"   ,  _cDRBCK2  ,NIL},;
									{"W3_FORLOJ"  ,  cFORLOJ   ,NIL},;
									{"W3_FABLOJ"  ,  cFABLOJ   ,NIL} })
							ENDIF
						ENDIF
						QRT->(dbSkip())
					End

					MSExecAuto({|a,b,c,d| EICPO400(a,b,c,d)},NIL,aCab,aItem,3)

					If lMsErroAuto
						MOSTRAERRO()
					EndIf

					QRT->(dbGotop())
					while QRT->(!EOF())
						Reclock("QRT",.F.)
						QRT->( dbDelete() )
						QRT->( MsUnlock() )
						QRT->(dbSkip())
					Enddo

					If Select("TMP") <> 0
						TMP->( dbCloseArea() )
					EndIf

					cQuery := " SELECT '   ' AS C6_OK, "
					cQuery += " (SELECT TOP 1 SUBSTRING(W3_FORN+'/'+W3_FORLOJ+' '+A2_NREDUZ,1,30)   "
					cQuery += " FROM SW3010 WITH(NOLOCK),SA2010 WITH(NOLOCK) "
					cQuery += " WHERE A2_COD+A2_LOJA=W3_FORN+W3_FORLOJ AND W3_COD_I=W1_COD_I AND SW3010.D_E_L_E_T_=' ' AND SA2010.D_E_L_E_T_=' '  "
					cQuery += " AND W3_FILIAL='"+xFILIAL('SW3')+"'  AND A2_FILIAL='"+xFILIAL('SA2')+"' "
					cQuery += " ORDER BY W3_DT_EMB DESC) AS ZZ_FORNEC, "
					cQuery += " W0__CC,W0__NUM,W0__DT,W0_COMPRA,W0_C1_NUM, "
					cQuery += " SUBSTRING(W0_SOLIC,1,10)  AS W0_SOLIC, "
					cQuery += " W1_POSICAO,W1_COD_I,C1_DESCRI, "
					cQuery += " W1_SALDO_Q, "
					cQuery += " (SELECT B1_UPRC FROM SB1010 WITH(NOLOCK) WHERE B1_COD=W1_COD_I AND D_E_L_E_T_='' AND B1_FILIAL='"+xFILIAL('SB1')+"' ) AS ZZ_UPRC, "
					cQuery += " W1_DTENTR_,C1_OBS   "
					cQuery += " FROM SW0010 W0  WITH(NOLOCK), SW1010 W1  WITH(NOLOCK), SC1010 C1   WITH(NOLOCK) "
					cQuery += " WHERE  W0__NUM=W1_SI_NUM  "
					cQuery += " AND    C1_NUM=W0_C1_NUM AND C1_PRODUTO=W1_COD_I AND W1_POSICAO=C1_ITEM  "
					cQuery += " AND W0_FILIAL='"+xFILIAL('SW0')+"' "
					cQuery += " AND W1_FILIAL='"+xFILIAL('SW1')+"' "
					cQuery += "	AND C1_FILIAL='"+xFILIAL('SC1')+"' "
					cQuery += " AND W0.D_E_L_E_T_=''  "
					cQuery += " AND W1.D_E_L_E_T_=''  "
					cQuery += " AND C1.D_E_L_E_T_=''  "
					cQuery += " AND C1_PEDIDO=''  "
					cQuery += " AND W1_PO_NUM=''  "
					cQuery += " AND C1_RESIDUO='' "
					cQuery += " AND C1_QUJE=0   "
					cQuery += " AND W1_SALDO_Q >0 "
					cQuery += " order by ZZ_FORNEC,W0__NUM,W1_POSICAO "

					TCQUERY cQuery Alias "TMP" New

					while TMP->(!EOF())
						If Reclock("QRT",.T.)

							QRT->C6_OK      := _cMarca
							QRT->ZZ_FORNEC  := TMP->ZZ_FORNEC
							QRT->W0__CC     := TMP->W0__CC
							QRT->W0__NUM    := TMP->W0__NUM
							QRT->W0__DT     := CTOD(SUBSTR(TMP->W0__DT,7,2)+'/'+SUBSTR(TMP->W0__DT,5,2)+'/'+SUBSTR(TMP->W0__DT,1,4))
							QRT->W0_COMPRA  := TMP->W0_COMPRA
							QRT->W0_C1_NUM  := TMP->W0_C1_NUM
							QRT->W0_SOLIC   := TMP->W0_SOLIC
							QRT->W1_POSICAO := TMP->W1_POSICAO
							QRT->W1_COD_I   := TMP->W1_COD_I
							QRT->C1_DESCRI  := TMP->C1_DESCRI
							QRT->W1_SALDO_Q := TMP->W1_SALDO_Q
							QRT->ZZ_UPRC    := TMP->ZZ_UPRC
							QRT->W1_DTENTR_ := CTOD(SUBSTR(TMP->W1_DTENTR_,7,2)+'/'+SUBSTR(TMP->W1_DTENTR_,5,2)+'/'+SUBSTR(TMP->W1_DTENTR_,1,4))
							QRT->C1_OBS     := TMP->C1_OBS
							QRT->(msUnlock())
						endif
						TMP->(dbSkip())
					Enddo
					*----------------------------------------
				ENDIF
				ZZ2->(DBSKIP())
			ENDDO
		ELSE
			MSGALERT('Fornecedor : '+cFORNECEDOR+' Nao cadastrado na tabela de Parametros do PO' )
			return
		ENDIF
	ENDIF
Return Nil

	*---------------------------------------------------------------*
Static Function fFechar()
	*---------------------------------------------------------------*
	Close(oTelaPO1)
	lEXECUTAR :=.T.
Return

	*---------------------------------------------------------------*
Static Function  U420VAL()
	*---------------------------------------------------------------*
	LOCAL lRET :=.T.

	IF !EMPTY(cIMPORT2)
		SYT->(DbSelectArea("SYT"))
		SYT->(DBSETORDER(1)) //SYT	1	YT_FILIAL+YT_COD_IMP
		IF SYT->(dbSeek(xFilial("SYT")+cIMPORT2))
			cDESC2 := SYT->YT_NOME
			oDESC2:REFRESH()
			IF SYT->YT_IMP_CON == "2"
				Help("Informação", 1, "Código informado é de consignatário")//"Código informado não é de consignatário"###"Informação"
				lRET :=.F.
			ENDIF
		ELSE
			Help("Informação", 1, "Código de importador não encontrado")
			lRET :=.F.
		ENDIF
	ELSE
		cDESC2 := SPACE(040)
		oDESC2:REFRESH()
	ENDIF

	IF !EMPTY(cDESP2)
		SY5->(DbSelectArea("SY5"))
		SY5->(DBSETORDER(1)) //SYT	1	YT_FILIAL+YT_COD_IMP
		IF SY5->(dbSeek(xFilial("SY5")+cDESP2))
			cDESC3 := SY5->Y5_NOME
			oDESC3:REFRESH()
			IF SYT->YT_IMP_CON == "2"
				Help("Informação", 1, "Código informado é de consignatário")//"Código informado não é de consignatário"###"Informação"
				lRET :=.F.
			ENDIF
		ELSE
			Help("Informação", 1, "Código de importador não encontrado")
			lRET :=.F.
		ENDIF
	ELSE
		cDESC3 := SPACE(040)
		oDESC3:REFRESH()
	ENDIF
	oDESC2:REFRESH()
	oDESC3:REFRESH()
	oVIADES:REFRESH()
RETURN lRET



	*---------------------------------------------------------------*
Static Function  U420VAL2()
	*---------------------------------------------------------------*
	LOCAL lRET :=.T.

	IF ZZ2->(DBSEEK(xFilial('ZZ2')+cFORNECEDOR+CLOJAPAR+CVIAPAR ))
	    cVIADES  :=ZZ2->ZZ2_NVIA
		IF ZZ2->ZZ2_IMPCO=='1'
			cIMPORT2 :=ZZ2->ZZ2_IMPORT
			cDESP2   :=ZZ2->ZZ2_DESP
		ELSE
			cIMPORT2 :=''
			cDESP2   :=''
		ENDIF
	ELSE
		cIMPORT2 :=''
		cDESP2   :=''
		cVIADES  :=''
	ENDIF
	U420VAL()
RETURN
