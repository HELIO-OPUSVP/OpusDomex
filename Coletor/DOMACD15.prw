//-----------------------------------------------------------------------------------------------------------------------------------------------//
//MAURICIO -OpusVp - 20/11/13                                                                                                                    //
//-----------------------------------------------------------------------------------------------------------------------------------------------//
//Especifico Rosenberger Domex.                                                                                                                  //
//-----------------------------------------------------------------------------------------------------------------------------------------------//
//Devolução produto Produção para Estoque (PI e PA)                                                                                              //
//-----------------------------------------------------------------------------------------------------------------------------------------------//
// Adaptado para devolução de PAs e PIs para o Estoque por Hélio
//-----------------------------------------------------------------------------------------------------------------------------------------------//

#include "TbiConn.ch"
#include "TbiCode.ch"
#include "Rwmake.ch"
#include "Topconn.ch"
#include "Protheus.ch"

*---------------------------------------------------------------------------------------------
User Function DOMACD15()
*---------------------------------------------------------------------------------------------
Private oTxtOP,oGetOP,oTxtEtiq,oGetEtiq,oTxtProd,oGetProd,oTxtQtd,oGetQtd,oMark,oTxtQtdEmp,oMainEti
Private oTxtDescric,oTxtProdEmp,oTxtQtdEmp
Private _nTamEtiq      := 21
Private _cNumOP        := Space(Len(CriaVar("D3_OP",.F.)))
Private _cEtiqueta     := Space(_nTamEtiq)
Private _cProduto      := CriaVar("B1_COD",.F.)
Private _nQtd          := CriaVar("XD1_QTDATU",.F.)
Private _cLoteEti      := CriaVar("BF_LOTECTL",.F.)
Private _aCols         := {}
Private _lAuto	        := .T.
Private _lIndividual   := .T.
Private _cCodInv
Private cGetEnd        := Space(2+15+1)
Private _cProd  	     := Space(15)
Private _cDescric	     := Space(27)
Private _cEnderec	     := Space(15)
Private _cStatus	     := Space(15)
Private _nQtd          := 0
Private _aDados        := {}
Private _aEnd          := {}
Private _nCont
Private nSaldoSD4      := 0
Private cLocProcDom    := GetMV("MV_XXLOCPR")
Private _cDescric      := SPACE(40)
Private _nQTD1         := 0
Private _nSALDO97      := 0
Private aEmpSB2        := {}
Private cC2_LOCAL      := ''
Private cLocaliz       := ''
Private aSD4QUANT      := {}
Private aEmpSBF        := {}
Private aEmpSB8        := {}

Private nFCICalc       := SuperGetMV("MV_FCICALC",.F.,0)

dDataBase := Date()

Define MsDialog oTelaDV Title OemToAnsi("Devolução Produção p/ Estoque " + DtoC(dDataBase) ) From 0,0 To 293,233 Pixel of oMainWnd PIXEL

nLin := 005
@ nLin,005   Say   oTxtOP  Var "OP " Pixel Of oTelaDV
@ nLin-2,045 MsGet oGetOP  Var _cNumOP Valid ValidaOP() Size 70,10 Pixel Of oTelaDV
oTxtOP:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
oGetOP:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

@ 018,001 To 045,115 Pixel Of oMainWnd PIXEL

@ 020,005 Say oTxtProdEmp  Var "Código: "   + _cProd  Pixel Of oTelaDV
@ 020,077 Say oTxtQtdEmp   Var "Qtd: "      + TransForm(_nQtd,"@E 999,999.9999") Pixel Of oTelaDV
@ 027,005 Say oTxtDescric  Var "Descrição: "+ _cDescric Size 110,15 Pixel Of oTelaDV
oTxtProdEmp:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
oTxtDescric:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
oTxtQtdEmp:oFont  := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)

fGetDados()

nLin+= 60
nLin+= 20
nLin+= 20
nLin+= 25

@ nLin,002 Button "Nova Etiq. "  Size 37,15 Action Dev001()                       Pixel Of oTelaDV
//@ nLin,040 Button "Aprov.Etiq."  Size 37,15 Action Dev003()                       Pixel Of oTelaDV
@ nLin,078 Button "Cancelar. "   Size 37,15 Action Processa( {|| oTelaDV:End()} ) Pixel Of oTelaDV

Activate MsDialog oTelaDV

Return

*---------------------------------------------------------------------------------------------
Static Function fGetDados()
*---------------------------------------------------------------------------------------------
Local _aStru   := {}
Local _nTamCOD := Len(CriaVar("D4_COD",.F.))

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

AADD(_aStru, {"MARCA"     ,"C",01,0} )
AADD(_aStru, {"PRODUTO"   ,"C",_nTamCOD,0} )
AADD(_aStru, {"QTD"       ,"N",10,4} )
AADD(_aStru, {"DESCR"     ,"C",40,0} )
AADD(_aStru, {"LOTE"      ,"C",10,0} )
//AADD(_aStru, {"LOCALIZ"   ,"C",10,0} )

_cArqTrab := CriaTrab(_aStru,.T.)

dbUseArea(.T.,__LocalDriver,_cArqTrab,"TRB",.F.)

IndRegua("TRB",_cArqTrab,"PRODUTO",,,)

_aCampos := {}

AADD(_aCampos,{"MARCA"       ,"" ,""            ,""                } )
AADD(_aCampos,{"PRODUTO"     ,"" ,"Produto"     ,"@R"              } )
AADD(_aCampos,{"QTD"         ,"" ,"QTD"         ,"@E 99,999.9999"  } )
AADD(_aCampos,{"DESCR"       ,"" ,"Descr."      ,"@R" } )
AADD(_aCampos,{"LOTE"        ,"" ,"LOTE"        ,"@R" } )

oMark:= MsSelect():New("TRB","MARCA",,_aCampos,Nil,Nil,{47,00,130,117})
oMark:oBrowse:oFont:= TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
oMark:oBrowse:Refresh()

dbSelectArea("TRB")
dbGotop()

oMark:oBrowse:Refresh()

Return

*------------------------------------------------------------------------------------------------
Static Function ValidaOP()
*------------------------------------------------------------------------------------------------
Local _lRet := .T.
_cProd      := ""
_cDescric   := ""
_cEnderec   := ""
_nQtd       := 0
_aDados     := {}
cPaPi       := ''

If Empty(_cNumOP)
	Return .T.
EndIf

fGetDados()

SC2->( dbSetOrder(1) )
SB1->( dbSetOrder(1) )
SBF->( dbSetOrder(2) )
SD3->( dbSetOrder(1) )
SB8->( dbSetOrder(3) )
SF5->( dbSetOrder(1) )

If Empty(_cNumOP)
	_lRet := .T.
Else
	
	aLotesPA := {}
	
	If SC2->(dbSeek(xFilial("SC2")+_cNumOP))
		If SC2->C2_QUJE <= 0
			U_MsgColetor("OP não apontada.")
			_lRet:=.F.
		Else
			cPaPi     := Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_TIPO")
			cC2_LOCAL := SC2->C2_LOCAL
			cLotesProd := ''
			
			If SD3->( dbSeek( xFilial() + SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN + Space(3) + SC2->C2_PRODUTO + SC2->C2_LOCAL ) )
				While !SD3->( EOF() ) .AND. SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN + Space(3) + SC2->C2_PRODUTO + SC2->C2_LOCAL  == SD3->D3_OP + SD3->D3_COD + SD3->D3_LOCAL
					If SF5->( dbSeek( xFilial() + SD3->D3_TM ) ) .and. SF5->F5_TIPO == 'P'
						If Empty(SD3->D3_ESTORNO)
							If SB8->( dbSeek( xFilial() + SD3->D3_COD + SD3->D3_LOCAL + SD3->D3_LOTECTL ) )
								If SB8->B8_SALDO > 0
									If SB8->B8_SALDO >= SD3->D3_QUANT
										AADD(aLotesPA,{SD3->D3_COD, SD3->D3_LOCAL, SD3->D3_LOTECTL, SD3->D3_QUANT})
									Else
										AADD(aLotesPA,{SD3->D3_COD, SD3->D3_LOCAL, SD3->D3_LOTECTL, SB8->B8_SALDO})
									EndIf
								Else
									If !(Alltrim(SD3->D3_LOTECTL) $ cLotesProd)
										cLotesProd += Alltrim(SD3->D3_LOTECTL) + '/'
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
					SD3->( dbSkip() )
				End
			EndIf
		EndIf
	Else
		U_MsgColetor("OP não encontrada.")
		_lRet:=.F.
	EndIf
	
	If !(cPAPI $ 'PA/PI')
		U_MsgColetor("Rotina destinada a OPs de PAs e PIs")
		_lRet:=.F.
	Else
		If !Empty(aLotesPA)
			For x := 1 to Len(aLotesPA)
				//AADD(aLotesPA,{SD3->D3_COD, SD3->D3_LOCAL, SD3->D3_LOTECTL, SB8->B8_SALDO})
				
				_cDescric :=POSICIONE('SB1',1,xFILIAL('SB1')+aLotesPA[x,1],'B1_DESC')
				Reclock("TRB",.T.)
				Replace TRB->PRODUTO  With aLotesPA[x,1]
				Replace TRB->QTD      With aLotesPA[x,4]
				Replace TRB->DESCR    With _cDescric
				Replace TRB->LOTE     With aLotesPA[x,3]
				//Replace TRB->LOCALIZ  With aLotesPA[x,5]
				TRB->( MsUnLock() )
			Next x
			TRB->(dbGotop())
			oMark:oBrowse:Refresh()
			TR1->(dbCloseArea())
			oTelaDV:Refresh()
		Else
			U_MsgColetor("Saldo de produtos   não disponível no   almoxarifado "+cC2_LOCAL+".    Lote(s): "+ Subs(cLotesProd,1,Len(cLotesProd)-1) +"." )
			_lRet:=.F.
		EndIf
	EndIf
EndIf

/*
_cProd      := "OP PAGA"
_cDescric   := "Todos os empenhos foram atendidos."
_cEnderec   := ""
_nQtd       := 0

If Len(_aDados)> 0
_cProd      := _aDados[1][1]
_cDescric   := _aDados[1][2]
_cEnderec   := _aDados[1][3]
_nQtd       := _aDados[1][4]
Else
SZD->( dbSetOrder(1) )
If SZD->( dbSeek( xFilial() + Subs(_cNumOP,1,11) ) )
nTemp := 0
While !SZD->( EOF() ) .and. Subs(SZD->ZD_OP,1,11) == Subs(_cNumOP,1,11)
nTemp += SZD->ZD_QTDPG
SZD->( dbSkip() )
End
U_MsgColetor("Ordem de Produção já atendida. Foi emitida etiqueta de Comprovante de Pagamento para produção de " + Alltrim(Transform(nTemp,"@E 999,999,999.9999"))+".")
_lRet:=.t.
Else
U_MsgColetor("Ordem de Produção já atendida. Etiqueta de Comprovante de Pagamento NÃO impressa.")
_lRet:=.t.
EndIf
EndIf

IF _lRet==.T.
If SC2->(dbSeek(xFilial("SC2")+_cNumOP))
_cProd :=SC2->C2_PRODUTO
_nQtd  :=SC2->C2_QUANT-SC2->C2_QUJE
_cDescric :=POSICIONE('SB1',1,xFILIAL('SB1')+_cProd,'B1_DESC')
ENDIF
//cQuery:=" 	SELECT D4_OP,D4_COD,D4_QTDEORI,D4_QUANT, D4_LOCAL, D4_OPORIG,                                "
//cQuery+="  (SELECT SUM(D3_QUANT) FROM SD3010 WITH (NOLOCK) WHERE D3_XXOP =D4_OP AND D3_COD=D4_COD AND     "
//cQuery+="                                   D3_LOCAL='97'  and D3_CF='DE4' AND                            "
//cQuery+="                                   D3_ESTORNO<>'S' AND SD3010.D_E_L_E_T_<>'*')   AS D4_TRANSF97, "
//cQuery+="  (SELECT SUM(D3_QUANT) FROM SD3010 WITH (NOLOCK) WHERE D3_XXOP =D4_OP AND D3_COD=D4_COD AND     "
//cQuery+="                                   D3_LOCAL='97'  and D3_CF='RE4' AND                            "
//cQuery+="                                   D3_ESTORNO<>'S' AND SD3010.D_E_L_E_T_<>'*')   AS D4_DEVOL97   "
//cQuery+="   FROM SD4010, SC2010                                                                           "
//cQuery+="   WHERE SD4010.D_E_L_E_T_<>'*' AND SC2010.D_E_L_E_T_<>'*' AND D4_OP='"+ALLTRIM(_cNumOP)+"' AND  "
//cQuery+="         D4_OP = C2_NUM+C2_ITEM+C2_SEQUEN                                                        "
//cQuery+="   ORDER BY D4_OP,D4_COD                                                                         "

cQuery:=" SELECT D3_TM,D3_CF,D3_LOTECTL,D4_COD,D4_LOCAL,D4_OP,                                           "
cQuery+=" SUM(D4_QTDEORI) AS D4_QTDEORI,SUM(D4_QUANT) AS D4_QUANT, SUM(D3_QUANT) AS D3_QUANT             "
cQuery+=" FROM SD4010 D4, SD3010 D3                                                                      "
cQuery+=" WHERE  D4_OP='"+ALLTRIM(_cNumOP)+"' AND                                                        "
cQuery+="       D3_XXOP  = D4_OP         AND                                                             "
cQuery+="       D3_COD   = D4_COD        AND                                                             "
cQuery+="       D3_LOCAL = '97'          AND                                                             "
cQuery+="       D3_CF    IN('RE4','DE4') AND                                                             "
cQuery+="       D3_ESTORNO<>'S'          AND                                                             "
cQuery+="       D4.D_E_L_E_T_<>'*'       AND                                                             "
cQuery+="       D3.D_E_L_E_T_<>'*'                                                                       "
cQuery+=" GROUP BY D3_TM,D3_CF,D3_LOTECTL,D4_COD,D4_LOCAL,D4_OP                                          "
cQuery+=" ORDER BY D4_COD,D3_TM                                                                          "

TcQuery cQuery Alias "TR1" New
TR1->(DbGoTop())

DO WHILE !TR1->(EOF())
_nQTDPROD := 0
_nQTD1    := 0
_nSALDO97 := 0

cLOTECTL :=TR1->D3_LOTECTL
cCOD     :=TR1->D4_COD
nD4QATU  :=TR1->D4_QUANT
DO while !TR1->(EOF()) .AND. TR1->D3_LOTECTL==cLOTECTL  .AND.  TR1->D4_COD==cCOD
DO CASE
CASE TR1->D3_TM='499'
_nSALDO97 :=_nSALDO97+TR1->D3_QUANT
CASE TR1->D3_TM='999'
_nSALDO97 :=_nSALDO97-TR1->D3_QUANT
ENDCASE
IF _nSALDO97 >TR1->D4_QUANT
_nQTD1:=  TR1->D4_QUANT
ELSE
_nQTD1:=_nSALDO97
ENDIF
TR1->(DBSKIP())
ENDDO
IF _nQTD1 >0
_cDescric :=POSICIONE('SB1',1,xFILIAL('SB1')+cCOD,'B1_DESC')
Reclock("TRB",.T.)
Replace TRB->PRODUTO  With cCOD
Replace TRB->QTD      With _nQTD1
Replace TRB->DESCR    With _cDescric
Replace TRB->LOTE     With cLOTECTL
MsUnLock()
ENDIF
ENDDO
TRB->(dbGotop())
oMark:oBrowse:Refresh()
TR1->(dbCloseArea())
ENDIF
oTelaDV:Refresh()
*/

Return(_lRet)

*---------------------------------------------------------------------------------------------
Static Function DEV001()
*---------------------------------------------------------------------------------------------
LOCAL nX :=0

dbSelectArea("TRB")
dbGotop()
Do While.Not. TRB->(Eof())
	//If Marked("MARCA")
	IF .NOT. EMPTY(TRB->MARCA)
		DEV002(TRB->PRODUTO,TRB->QTD,TRB->DESCR,TRB->LOTE)
	ENDIF
	TRB->(DBSKIP())
ENDDO
_cNumOP        := Space(Len(CriaVar("D3_OP",.F.)))
fGetDados()
oGetop:REFRESH()
oGetop:SETFOCUS()
RETURN

*---------------------------------------------------------------------------------------------
Static Function DEV002(cProd2,nQTDORI2,cDESC2,cLOTE)
*---------------------------------------------------------------------------------------------

PRIVATE oTxtProd2,oTxtDESC2,oTxtlOTE2,oTxtQTDORI2,oTxtQTDDEV2,oGetQTDDEV2,oFontNW
PRIVATE oTxtNETIQUE
PRIVATE oGetNETIQUE
Private oGetDados
PRIVATE clOTE2     := cLOTE
PRIVATE nQTDDEV2   := nQTDORI2
PRIVATE nQTDETIQ   := 0
Private aHeader    := {}
Private aCols      := {}

AADD(aHeader,  {    "ITEM"   ,   "ITEM"    ,""             ,15,0,""            ,"","C","","","","",".F."})//01
AADD(aHeader,  {    "QTDEP"  ,   "QTDEP"   ,"@E 9,999.9999",04,0,""            ,"","N","","","","",".T."})//02

AADD(aCols,{'',0,.F.})

DEFINE FONT oFontNW  NAME "Arial" SIZE 0,-15 BOLD

Define MsDialog oTelaDV2 Title OemToAnsi("Devolução Produção p/ Estoque OP " + _cNumOP ) From 0,0 To 293,233 Pixel of oMainWnd PIXEL

nLin := 005
@ 005,001 To 040,115 Pixel Of oMainWnd PIXEL

@ 007,005 Say oTxtProd2     Var "Produto: "   + cProd2               Pixel Of oTelaDV2
@ 014,005 Say oTxtDESC2     Var "Descrição: " + SUBSTR(cDESC2,1,22)  Pixel Of oTelaDV2
@ 021,005 Say oTxtlOTE2     Var "Lote:      " + clOTE2               Pixel COLOR CLR_RED Of oTelaDV2
@ 028,005 Say oTxtQTDORI2   Var "QTD.ORI: "   + TransForm(nQTDORI2,"@E 999,999.9999") Pixel Of oTelaDV2

oTxtProd2  :oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
oTxtDESC2  :oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
oTxtlOTE2  :oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
oTxtQTDORI2:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)

nLin := 044
@ nLin   ,005 Say   oTxtQTDDEV2   Var "QTD.DEV: "   Pixel Of oTelaDV2
@ nLin-2 ,045 MsGet oGetQTDDEV2   Var nQTDDEV2 Valid ValidQTDEV(nQTDORI2)Picture "@E 9,999,999.9999" Size 70,10 Pixel Of oTelaDV2
oTxtQTDDEV2:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
oGetQTDDEV2:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

nLin := 058
@ nLin   ,005 Say   oTxtNETIQUE   Var "No. Etiquetas: "   Pixel Of oTelaDV2
@ nLin-2 ,045 MsGet oGetNETIQUE   Var nQTDETIQ Valid ValidQTDET()Picture "@E 9,999,999.9999" Size 70,10 Pixel Of oTelaDV2
oTxtNETIQUE:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
oGetNETIQUE:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

nLin := 130
@ nLin,002 Button "Devolver" Size 55,15 Action DEV002TR(cProd2,cLOTE2) Pixel Of oTelaDV2

oGetDados  := (MsNewGetDados():New( 70, 00 , 130 ,117,GD_UPDATE+GD_DELETE ,"AlwaysTrue" ,"AlwaysTrue", /*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*Ffieldok*/,/*superdel*/,/*delok*/,oTelaDV2,aHeader,aCols))
oGetDados:oBrowse:Refresh()
oGetDados:oBrowse:oFont  := oFontNW
oGetDados:oBrowse:bChange:={||U_DEV003LOK(oGetDados)}

Activate MsDialog oTelaDV2

Return

*--------------------------------------------------------
USER FUNCTION DEV003LOK(oGetDados)
*--------------------------------------------------------
Local nX      :=0
Local nTOTDEV :=0

FOR nX:=1 TO LEN (oGetDados:aCOLS)
	IF oGetDados:aCOLS[nX][03]==.F.  //NÃO DELETADO
		nTOTDEV :=nTOTDEV+(oGetDados:aCOLS[nX][02])
	ENDIF
NEXT

IF nTOTDEV >0
	IF nTOTDEV >nQTDDEV2
		apMsgNoYes("Soma itens Maior que  "+Chr(13)+Chr(10)+;
		"quantidade a devolver."+Chr(13)+Chr(10)+;
		"Tot.Itens "+Transform(nTOTDEV         ,"@E 999,999.9999")+Chr(13)+Chr(10)+;
		"Qtd dev.  "+Transform(nQTDDEV2        ,"@E 999,999.9999")+Chr(13)+Chr(10)+;
		"Diferença "+Transform(nTOTDEV-nQTDDEV2,"@E 999,999.9999"))
	ENDIF
ENDIF

RETURN

*--------------------------------------------------------
STATIC FUNCTION ValidQTDET()
*--------------------------------------------------------
Local nX       :=0
Local _nqtdetq :=0
Local _nItem   :='000'
Local aCols2   := {}

IF nQTDDEV2 > 0 .AND. nQTDETIQ >0
	_nqtdetq := nQTDDEV2 / nQTDETIQ
	
	FOR nX := 1 TO nQTDETIQ
		_nItem:=SOMA1(_nItem)
		_nQTDEV2 := nQTDDEV2 / _nqtdetq
		AADD(aCols2,{_nItem,_nqtdetq,.F.})
	NEXT
	oGetDados:ACOLS:=aCOLS2
	oGetDados:oBrowse:Refresh()
	
ENDIF
RETURN .T.

*--------------------------------------------------------
STATIC FUNCTION ValidQTDEV(nQTDORI2)
*--------------------------------------------------------
IF nQTDDEV2  > nQTDORI2
	U_MsgColetor("Quantidade devolvida não pode ser maior que saldo a devolver.")
	nQTDDEV2 :=nQTDORI2
	oGetNETIQUE:refresh()
ENDIF

RETURN

*--------------------------------------------------------
STATIC FUNCTION DEV002TR(cProd2,cLOTE2) //TRANSFERIR
*--------------------------------------------------------
Local     nX          := 0
Local     _nOpcAuto   := 3
Local     dVLDSB8     := CTOD("31/12/49")
lOCAL    lChkMov      := .f.
PRIVATE   _nSB2QEMP   := 0
PRIVATE   _lSB2QEMP   := .F.
PRIVATE	 lTRANSF     := .F.
PRIVATE	 _cLOCDES    :=SPACE(02)
cLOTE2  := SUBSTR(cLOTE2,1,10)

FOR nX := 1 TO LEN(oGetDados:aCOLS)
	IF oGetDados:aCOLS[nX][02] > 0
		//TRANSFERENCIA
		_aAuto      :={}
		_aItem      :={}
		cLocaliz    := ''
		
		If cC2_LOCAL == '13'
			cLocaliz := '13PRODUCAO     '
		Else
			If cC2_LOCAL == '97'
				cLocaliz := '97PROCESSO     '
			EndIf
		EndIf
		
		If Empty(cLocaliz)
			U_MsgColetor("Endereço de origem não definido.")
			Exit
		EndIf
		
		SBF->( dbSetOrder(1) )
		
		cLoteOP := cLOTE2
		DbSelectArea("SB8")
		DBSetOrder(3)                                                                                                            
		If SB8->( dbSeek( xFilial() + SB1->B1_COD + cC2_LOCAL  + cLoteOP) )
			dVLDSB8 := SB8->B8_DTVALID                                                             
		EndIf
		If SBF->( dbSeek( xFilial() + cC2_LOCAL + cLocaliz +  SB1->B1_COD + Space(Len(SBF->BF_NUMSERI)) + cLoteOP) )
			If SBF->BF_QUANT >= oGetDados:aCOLS[nX][02]
				
				
		        CriaSB2(SB1->B1_COD,'01')
				_cDoc:= U_NEXTDOC()
				_cDoc:=_cDoc+SPACE(09)
				_cDoc:=SUBSTR(_cDoc,1,9)  
//				_cDoc:="TST001"
				
				aadd(_aAuto,{_cDoc,dDataBase})
				
				_aItem   := {}
				
				aadd(_aItem,SB1->B1_COD)                       //Produto Origem
				aadd(_aItem,SB1->B1_DESC)                      //Descricao Origem
				aadd(_aItem,SB1->B1_UM)  	                    //UM Origem
				aadd(_aItem,cC2_LOCAL)                         //Local Origem
				aadd(_aItem,cLocaliz)                  	     //Endereco Origem
				aadd(_aItem,SB1->B1_COD)                       //Produto Destino
				aadd(_aItem,SB1->B1_DESC)                      //Descricao Destino
				aadd(_aItem,SB1->B1_UM)  	                    //UM destino
				aadd(_aItem,'01')                              //Local Destino
				aadd(_aItem,'01DEVOLUCAO    ')                 //Endereco Destino
				aadd(_aItem,"")                                //Numero Serie
				aadd(_aItem,cLOTE2)	                          //Lote Origem
				aadd(_aItem,"")         	                    //Sub Lote Origem
				aadd(_aItem,dVLDSB8  )								  //Validade Lote Origem
				aadd(_aItem,0)		                             //Potencia
				aadd(_aItem,oGetDados:aCOLS[nX][02])           //Quantidade
				aadd(_aItem,0)		                             //Quantidade 2a. unidade
				aadd(_aItem,"")   	                          //ESTORNO
				aadd(_aItem,"")         	                    //NUMSEQ
				aadd(_aItem,cLOTE2)                            //Lote Destino
				aadd(_aItem,dVLDSB8) 								  //Validade Lote Destino
				aadd(_aItem,"")		                          //D3_ITEMGRD
				If nFCICalc == 1
					aadd(_aItem,0)                              //D3_PERIMP
				ENDIF
				If GetVersao(.F.,.F.) == "12"
					//aAdd(_aItem,"")   //D3_IDDCF
					aAdd(_aItem,"")   //D3_OBSERVACAO
				EndIf
				aadd(_aAuto,_aItem)
				
				lMsErroAuto := .F.
				
				GuardaEmps(SB1->B1_COD,cC2_LOCAL)
				
				MSExecAuto({|x,y| mata261(x,y)},_aAuto,_nOpcAuto)  // Execauto de transferência
				
				VoltaEmps()
				
				If lMsErroAuto
					MostraErro("\UTIL\LOG\Devolucao_Producao_PA_PI\")
					//DisarmTransaction()
					U_MsgColetor("Erro na Devolução (PA/PI)")
				Else
					XD1->( dbSetOrder(1))
					SB1->( dbSetOrder(1) )
					SB1->( dbSeek( xFilial() + cProd2 ) )
					
					_cProxPeca := U_IXD1PECA()
					Reclock("XD1",.T.)
					Replace XD1->XD1_FILIAL  With xFilial("XD1")
					Replace XD1->XD1_XXPECA  With _cProxPeca
					Replace XD1->XD1_FORNEC  With Space(06)
					Replace XD1->XD1_LOJA    With Space(02)
					Replace XD1->XD1_DOC     With Space(06)
					Replace XD1->XD1_SERIE   With Space(03)
					Replace XD1->XD1_COD     With SB1->B1_COD
					Replace XD1->XD1_LOCAL   With '01'
					Replace XD1->XD1_TIPO    With SB1->B1_TIPO
					Replace XD1->XD1_LOTECT  With SUBSTR(cLOTE2,1,10)
					Replace XD1->XD1_DTDIGI  With dDataBase
					Replace XD1->XD1_FORMUL  With ""
					Replace XD1->XD1_LOCALI  With '01DEVOLUCAO    '
					Replace XD1->XD1_USERID  With __cUserId
					XD1->XD1_OCORRE := "4"
					Replace XD1->XD1_QTDORI  With oGetDados:aCOLS[nX][02]
					Replace XD1->XD1_QTDATU  With oGetDados:aCOLS[nX][02]
					Replace XD1->XD1_OP      With _cNumOP
					XD1->( MsUnlock() )
					
		 			U_DOMEST06()
					
					SD3->( dbSetOrder(2) )  // D3_FILIAL + D3_DOC
					If SD3->( dbSeek( xFilial() + _cDoc ) )
						While !SD3->( EOF() ) .and. ALLTRIM(SD3->D3_DOC) == ALLTRIM(_cDoc)
							If SD3->D3_CF == 'RE4' .or. SD3->D3_CF == 'DE4'
								
								If SD3->D3_COD == SB1->B1_COD
									If SD3->D3_EMISSAO == dDataBase
										If SD3->D3_QUANT == oGetDados:aCOLS[nX][02]
											If Empty(SD3->D3_XXOP)
												
												Reclock("SD3",.F.)
												SD3->D3_XXPECA  := XD1->XD1_XXPECA
												SD3->D3_XXOP    := _cNumOP
												SD3->D3_USUARIO := cUsuario
												SD3->D3_HORA    := Time()
												SD3->( msUnlock() )
												
											EndIf
											If !lCHkMov
												//VERIFICA INTEGRIDADE DOS MOVIMENTOS 
												lCHkMov := U_CHKMOV(SD3->D3_COD, SD3->D3_NUMSEQ, SD3->( Recno()), "T")
											EndIf
										EndIf
									EndIf
								EndIf
							EndIf
							SD3->( dbSkip() )
						End
					EndIf
					lTRANSF:=.T.
				ENDIF
			Else
				U_MsgColetor("Não existe saldo suficiente do produto " + Alltrim(SB1->B1_COD) +" para devolução." + Chr(13) + "Saldo: "+Alltrim(Str(SBF->BF_QUANT))+ Chr(13) +"Necessidade: " + Alltrim(Str(oGetDados:aCOLS[nX][02])))
			EndIf
		Else
			U_MsgColetor("Não existe saldo do produto " + Alltrim(SB1->B1_COD) +" para devolução (saldo zero).")
		EndIf
	ENDIF
	lchkmov := .f.
NEXT
IF lTRANSF   .AND. lMsErroAuto == .F.
	U_MsgColetor("Devolução efetuada  Produto: "+Chr(13)+SB1->B1_COD+".")
	lTRANSF:=.F.
ENDIF
Close(oTelaDV2)

Return


*-------------------------------------------------------------------------------------
Static Function GuardaEmps(cProduto,cLocal)
*-------------------------------------------------------------------------------------
aEmpSB2 := {}
SB2->( dbSetOrder(1) )
If SB2->( dbSeek( xFilial() + cProduto + cLocal ) )
	If !Empty(SB2->B2_QEMP)
		AADD(aEmpSB2,{SB2->(Recno()),SB2->B2_QEMP})
	EndIf
EndIf

aEmpSBF := {}
SBF->( dbSetOrder(2) )
If SBF->( dbSeek( xFilial() + cProduto + cLocal ) )
	While !SBF->( EOF() ) .and. SBF->BF_FILIAL + SBF->BF_PRODUTO + SBF->BF_LOCAL == xFilial("SBF") + cProduto + cLocal
		If !Empty(SBF->BF_EMPENHO)
			AADD(aEmpSBF,{SBF->(Recno()),SBF->BF_EMPENHO})
		EndIf
		SBF->( dbSkip() )
	End
EndIf

aEmpSB8 := {}
SB8->( dbSetOrder(1) )
If SB8->( dbSeek( xFilial() + cProduto + cLocal ) )
	While !SB8->( EOF() ) .and. SB8->B8_FILIAL + SB8->B8_PRODUTO + SB8->B8_LOCAL == xFilial("SB8") + cProduto + cLocal
		If !Empty(SB8->B8_EMPENHO)
			AADD(aEmpSB8,{SB8->(Recno()),SB8->B8_EMPENHO})
		EndIf
		SB8->( dbSkip() )
	End
EndIf

For x := 1 to Len(aEmpSB2)
	SB2->( dbGoTo(aEmpSB2[x,1]) )
	Reclock("SB2",.F.)
	SB2->B2_QEMP := 0
	SB2->( msUnlock() )
Next x

For x := 1 to Len(aEmpSBF)
	SBF->( dbGoTo(aEmpSBF[x,1]) )
	Reclock("SBF",.F.)
	SBF->BF_EMPENHO := 0
	SBF->( msUnlock() )
Next x

For x := 1 to Len(aEmpSB8)
	SB8->( dbGoTo(aEmpSB8[x,1]) )
	Reclock("SB8",.F.)
	SB8->B8_EMPENHO := 0
	SB8->( msUnlock() )
Next x


cQuery := "SELECT R_E_C_N_O_, D4_QUANT FROM " + RetSqlName("SD4") + " WHERE D4_COD = '"+cProduto+"' AND D4_LOCAL = '"+cLocal+"' AND D4_QUANT <> 0 "

If Select("QUERYSD4") <> 0
	QUERYSD4->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QUERYSD4"

aSD4QUANT := {}
While !QUERYSD4->( EOF() )
	AADD(aSD4QUANT,{QUERYSD4->R_E_C_N_O_,QUERYSD4->D4_QUANT})
	SD4->( dbGoTo(QUERYSD4->R_E_C_N_O_) )
	If SD4->( Recno() ) == QUERYSD4->R_E_C_N_O_
		
		// SD4->D4_XQUANT
		
		Reclock("SD4",.F.)
		SD4->D4_QUANT := 0
		SD4->( msUnlock() )
	EndIf
	QUERYSD4->( dbSkip() )
End

Return

*-------------------------------------------------------------------------------------
Static Function VoltaEmps()
*-------------------------------------------------------------------------------------
For x := 1 to Len(aEmpSB2)
	SB2->( dbGoTo(aEmpSB2[x,1]) )
	Reclock("SB2",.F.)
	SB2->B2_QEMP := aEmpSB2[x,2]
	SB2->( msUnlock() )
Next x

For x := 1 to Len(aEmpSBF)
	SBF->( dbGoTo(aEmpSBF[x,1]) )
	Reclock("SBF",.F.)
	SBF->BF_EMPENHO := aEmpSBF[x,2]
	SBF->( msUnlock() )
Next x

For x := 1 to Len(aEmpSB8)
	SB8->( dbGoTo(aEmpSB8[x,1]) )
	Reclock("SB8",.F.)
	SB8->B8_EMPENHO := aEmpSB8[x,2]
	SB8->( msUnlock() )
Next x

For x := 1 to Len(aSD4QUANT)
	SD4->( dbGoTo(aSD4QUANT[x,1]) )
	If SD4->( Recno() ) == aSD4QUANT[x,1]
		Reclock("SD4",.F.)
		SD4->D4_QUANT := aSD4QUANT[x,2]
		SD4->( msUnlock() )
	EndIf
Next x

Return

*-------------------------------------------------------------------------------------
Static Function Dev003()
*-------------------------------------------------------------------------------------
LOCAL nX :=0

dbSelectArea("TRB")
dbGotop()
Do While.Not. TRB->(Eof())
	IF .NOT. EMPTY(TRB->MARCA)
		//DEV003(TRB->PRODUTO,TRB->QTD,TRB->DESCR)
	ENDIF
	TRB->(DBSKIP())
ENDDO
_cNumOP        := Space(Len(CriaVar("D3_OP",.F.)))
fGetDados()
oGetop:REFRESH()
oGetop:SETFOCUS()
U_MsgColetor("DEVOLUÇÃO - APROVEITAR ETIQUETA, NÃO DISPONIVEL.")
RETURN