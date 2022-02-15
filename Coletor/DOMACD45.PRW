#include "TbiConn.ch"
#include "TbiCode.ch"
#include "Rwmake.ch"
#include "Topconn.ch"
#include "Protheus.ch"
#Include "ap5mail.ch"

#DEFINE ENTER CHAR(13) + CHAR(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDOMACD45  บAutor  ณJonas Pereira       บ Data ณ  08/09/2021 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa de inventแrio CICLICO                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*---------------------------------------------------------------------------------------------
User Function DOMACD45(__cFilial)
*---------------------------------------------------------------------------------------------
Private oTxtEnd,oGetEnd,oTxtEtiq,oGetEtiq,oTxtProd,oGetProd,oTxtQtd,oGetQtd,oMark,oTxtQTDETQ
Private _nTamEtiq      := 21
Private _cEndereco     := Space(Len(CriaVar("BE_LOCALIZ",.F.))+3)
Private _cEtiqueta     := Space(_nTamEtiq)
Private _cProduto      := CriaVar("B1_COD",.F.)
Private _nQtd          := CriaVar("XD1_QTDATU",.F.)
Private _cLoteEti      := CriaVar("BF_LOTECTL",.F.)
Private _cParametro    := "MV_XXNUMIN"
Private _cCtrNum       := GetNewPar(_cParametro,"")
Private _lAuto	        := .T.
Private _lIndividual   := .F.
Private _nTamDoc       := Len(CriaVar("B7_DOC",.F.))
Private _aCols         := {}
Private _aLog          := {}
Private _aEnder        := {}
Private nTxtQTDETQ     := 0
Private _lCALC         := .T.
Private _nTotItem      := 0
Private _cDocInv       := ""
Private aEmpSB2
Private lInvOK         :=.F.
Private lRetTelaBE     :=.F.
Private _nVLUNIT       :=0
Private _nQTDATU       :=0
Private _nQTDAJU       :=0
Private _nVALAJU       :=0
Private _nQTDTOT       :=0
Private aLstAlmox      :={}
Private cAlmoxarifado  :=""
Private cPerInv := ""
Private aRecSB7 := {}


Private cTitulo    :=  ""
Private nRecZZR    := 0
Private _pro       := ""
Private _DescPro   := ""
Private _DT        := ""
Private _oCodPro
Private _oDescPro
Private lNext      := .t.
Private cSeq       := ""

Private _aCols:={}

Private FilOri := __cFilial

If! Empty(_cCtrNum)
    fAlmoxinv()
Else
	U_MsgColetor("Verifique o parโmetro "+_cParametro)
EndIf

Return

Static function fAlmoxinv()
Local lRetAlm := .t.


//Seleciona os almoxarifados pendentes de inventแrio...
cQuery := " SELECT ZZR_LOCAL, LEFT(ZZR_DTPLAN,6) AS PERIODO FROM " + RetSqlName("ZZR") + " (NOLOCK) "
cQuery += " WHERE ZZR_FILIAL='"+FilOri+"' AND D_E_L_E_T_='' AND ZZR_DTREAL='' "
cQuery += " AND LEFT(ZZR_DTPLAN,6) = ( "
cQuery += " SELECT (CASE WHEN MAX(ZZR_DTPLAN) IS NULL THEN LEFT(CONVERT(VARCHAR(10), DATEADD(month, -1, GETDATE()), 112),6)  "
cQuery += " ELSE LEFT(MAX(ZZR_DTPLAN),6) END) AS DTULT FROM " + RetSqlName("ZZR") + "  (NOLOCK)  "
cQuery += " WHERE ZZR_FILIAL='"+FilOri+"' AND D_E_L_E_T_=''  "
cQuery += " ) "
cQuery += " GROUP BY ZZR_LOCAL, LEFT(ZZR_DTPLAN,6)  "
cQuery += " ORDER BY ZZR_LOCAL "

If Select("TMP") <> 0
	TMP->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "TMP"

While TMP->(!EOF())
	aadd(aLstAlmox,TMP->ZZR_LOCAL)
    cPerInv := TMP->PERIODO
    TMP->(dbskip())
Enddo

If Select("TMP") <> 0
	TMP->( dbCloseArea() )
EndIf


Define MsDialog oInvSel Title OemToAnsi("Inventแrio Cํclico") From 0,0 To 293,233 Pixel of oMainWnd PIXEL

@ 020,010	SAY oTexto1 Var '   Abaixo lista de almorarifados'    SIZE 100,10 PIXEL
@ 030,010	SAY oTexto1 Var ' pendentes, para realiza็ใo do inventแrio '    SIZE 100,10 PIXEL
@ 040,010	SAY oTexto1 Var ' cํclicono perํodo de '+SUBSTR(cPerInv,5,2)+ '-'+SUBSTR(cPerInv,1,4)+', selecione:'    SIZE 100,10 PIXEL


@ 060, 030	SAY oTexto2 Var 'Almoxarifado'    SIZE 50,10 PIXEL
oTexto2:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)

@ 070, 040 COMBOBOX oCombo2  VAR cAlmoxarifado ITEMS aLstAlmox    SIZE 25,10 PIXEL //VALID VLDCONT() PIXEL
oCombo1:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)

@ 130,005 Button "Confirma" Size 40,15 Action fOkTela() Pixel Of oInvSel

Activate MsDialog oInvSel


Return 


Static function VLDALMOX()
Local lRetAlmox := .t.

If Empty(cAlmoxarifado)
    lRetAlmox := .f. 
    U_MsgColetor("Selecione um almoxarifado para prosseguir.")
EndIf

Return lRetAlmox

*---------------------------------------------------------------------------------------------
Static Function fOkTela()
*---------------------------------------------------------------------------------------------



if cFilAnt == "01"
	cTitulo:= "Inventแrio Cํclico - Armazem "+cAlmoxarifado
ElseIf cFilAnt == '02'
	cTitulo:= "Inventแrio Cํclico MG - Armazem "+cAlmoxarifado
Endif


//Seleciona o ultimo inventario ciclico gerado
cQuery := " SELECT TOP 1 R_E_C_N_O_ AS REC FROM " + RetSqlName("ZZR") + " (NOLOCK) WHERE ZZR_FILIAL='"+FilOri+"' AND D_E_L_E_T_='' AND ZZR_DTREAL='' " 
cQuery += " AND ZZR_LOCAL='"+cAlmoxarifado+"' AND LEFT(ZZR_DTPLAN,6)='"+cPerInv+"' "
cQuery += " ORDER BY R_E_C_N_O_ "

If Select("TMP") <> 0
	TMP->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "TMP"

If  TMP->(!EOF())
	nRecZZR :=TMP->REC
    TMP->(dbskip())
Else
//nใo ha itens a serem inventariados no almoxarifado
    U_MsgColetor("Nใo hแ itens a serem inventแriados.")
    Return
EndIf

If Select("TMP") <> 0
	TMP->( dbCloseArea() )
EndIf

ZZR->(DBSETORDER(1))
ZZR->(DBGOTO(nRecZZR))

If nRecZZR == ZZR->(RECNO())

    _cProduto := ZZR->ZZR_PRODUT
    _pro      := ZZR->ZZR_PRODUT
	_Despro   := substr(ZZR->ZZR_DESCRI,1,32) + ENTER  + substr(ZZR->ZZR_DESCRI,33,32) 
	_DT       := DTOC(ZZR->ZZR_DTPLAN)
	cSeq      := ZZR->ZZR_SEQ
    
    Define MsDialog oInv Title OemToAnsi(cTitulo) From 0,0 To 293,233 Pixel of oMainWnd PIXEL

   // @ 005,005 Say oTxtProd   Var "Produto "  Pixel Of oInv
    //@ 005,045 MsGet oGetProd Var _pro When .F. Size 70,10  Pixel Of oInv
  //  oTxtProd:oFont:= TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
   // oGetProd:oFont:= TFont():New('Arial',,20,,.T.,,,,.T.,.F.)


	@ 000, 005	SAY _oCodPro   VAR "Produto: " + _pro  PIXEL SIZE 160, 13
	_oCodPro:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)

	@ 010, 005	SAY _oDescPro   VAR _Despro  PIXEL SIZE 160, 20
	_oDescPro:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)

	//@ 084*nWebPx, 008	SAY _oDescPro  VAR "Desc.:   " + _cDesPro  PIXEL SIZE 100*nWebPx,20*nWebPx
	//_oDescPro:oFont := TFont():New('Arial',,19*nWebPx,,.T.,,,,.T.,.F.)

	@ 033,005 Say oTxtDt    Var "Dt. Planejada " Pixel Of oInv
    @ 033,045 MsGet oGetDt  Var _DT When .F. Size 70,08 Pixel Of oInv
    oTxtDt:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
    oGetDt:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)


    @ 045,005 Say oTxtEnd    Var "Endere็o " Pixel Of oInv
    @ 045,045 MsGet oGetEnd  Var _cEndereco Valid fValEnd() Size 70,08 Pixel Of oInv
    oTxtEnd:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
    oGetEnd:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)

    @ 057,005 Say oTxtEtiq   Var "Etiqueta " Pixel Of oInv
    @ 057,045 MsGet oGetEtiq Var _cEtiqueta  Size 70,08 Valid fValEtiq() Pixel Of oInv
    oTxtEtiq:oFont:= TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
    oGetEtiq:oFont:= TFont():New('Arial',,17,,.T.,,,,.T.,.F.)


    fGetDados()

    @ 069,005 Say oTxtQtd    Var "Quantidade " Pixel Of oInv
    @ 069,045 MsGet oGetQtd  Var _nQtd Valid fOkQtd() Picture "@E 999,999.9999" Size 70,08  Pixel Of oInv
    oTxtQtd:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
    oGetQtd:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)

    @ 135,095 Say oTxtQTDETQ Var Transform(nTxtQTDETQ,"@E 999,999") Pixel Of oInv
    oTxtQTDETQ:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)

    @ 132,073  BITMAP oBmp1 ResName "LEFT"   Of oInv Size 070,20 WHEN lNext ON CLICK fante() NoBorder  Pixel
	@ 132,087  BITMAP oBmp2 ResName "RIGHT"  Of oInv Size 070,20 ON CLICK fnext() NoBorder  Pixel
    @ 130,003 Button "Confirma" Size 27,15 Action fOkProc() Pixel Of oInv
    @ 130,035 Button "Cancelar" Size 27,15 Action Close(oInv) Pixel Of oInv

    Activate MsDialog oInv

ELSE

    U_MsgColetor("Registro nใo encontrado na tabela de inventแrio cํclico.")
    RETURN

EndIf

Return


Static function fnext()

_nTamEtiq      := 21
_cEndereco     := Space(Len(CriaVar("BE_LOCALIZ",.F.))+3)
_cEtiqueta     := Space(_nTamEtiq)
_nQtd          := CriaVar("XD1_QTDATU",.F.)
_cLoteEti      := CriaVar("BF_LOTECTL",.F.)
 _aCols         := {}
 _aLog          := {}
 _aEnder        := {}
 nTxtQTDETQ     := 0
 _lCALC         := .T.
 _nTotItem      := 0
 _cDocInv       := ""
 aEmpSB2
 lInvOK         :=.F.
 lRetTelaBE     :=.F.
 _nVLUNIT       :=0
 _nQTDATU       :=0
 _nQTDAJU       :=0
 _nVALAJU       :=0
 _nQTDTOT       :=0

lNext := .t.
_aCols:={}

//Seleciona o ultimo inventario ciclico gerado
cQuery := " SELECT TOP 1 R_E_C_N_O_ AS REC FROM " + RetSqlName("ZZR") + " (NOLOCK) WHERE ZZR_FILIAL='"+FilOri+"' AND D_E_L_E_T_='' AND ZZR_DTREAL='' " 
cQuery += " AND ZZR_LOCAL='"+cAlmoxarifado+"' AND LEFT(ZZR_DTPLAN,6)='"+cPerInv+"' and ZZR_SEQ>"+ZZR->ZZR_SEQ+" "
cQuery += " ORDER BY R_E_C_N_O_ "

If Select("TMP") <> 0
	TMP->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "TMP"

If  TMP->(!EOF())
	nRecZZR :=TMP->REC
    TMP->(dbskip())
Else
//nใo ha itens a serem inventariados no almoxarifado
    U_MsgColetor("Nใo hแ itens a serem inventแriados.")
    Return
EndIf

If Select("TMP") <> 0
	TMP->( dbCloseArea() )
EndIf

ZZR->(DBSETORDER(1))
ZZR->(DBGOTO(nRecZZR))

If nRecZZR == ZZR->(RECNO())

    _cProduto  := ZZR->ZZR_PRODUT
    _pro       := ZZR->ZZR_PRODUT
	_Despro    := substr(ZZR->ZZR_DESCRI,1,32) + ENTER  + substr(ZZR->ZZR_DESCRI,33,32) 
	_DT        := DTOC(ZZR->ZZR_DTPLAN)
	 _cEndereco     := Space(Len(CriaVar("BE_LOCALIZ",.F.))+3)
	_cEtiqueta

	
    _aCols:={}

	fGetDados()
	_oCodPro:Refresh	
	_oDescPro:Refresh
    oGetDt:Refresh
	oGetEnd:Refresh
	oTxtEtiq:Refresh
	oGetEtiq:Refresh
	oTxtProd:Refresh
	oGetProd:Refresh
	oTxtQtd:Refresh
	oGetQtd:Refresh
	oTxtQTDETQ:Refresh

EndIf




Return


Static function fante()

_nTamEtiq      := 21
_cEndereco     := Space(Len(CriaVar("BE_LOCALIZ",.F.))+3)
_cEtiqueta     := Space(_nTamEtiq)
_nQtd          := CriaVar("XD1_QTDATU",.F.)
_cLoteEti      := CriaVar("BF_LOTECTL",.F.)
 _aCols         := {}
 _aLog          := {}
 _aEnder        := {}
 nTxtQTDETQ     := 0
 _lCALC         := .T.
 _nTotItem      := 0
 _cDocInv       := ""
 aEmpSB2
 lInvOK         :=.F.
 lRetTelaBE     :=.F.
 _nVLUNIT       :=0
 _nQTDATU       :=0
 _nQTDAJU       :=0
 _nVALAJU       :=0
 _nQTDTOT       :=0



_aCols:={}


//Seleciona o ultimo inventario ciclico gerado
cQuery := " SELECT TOP 1 R_E_C_N_O_ AS REC FROM " + RetSqlName("ZZR") + " (NOLOCK) WHERE ZZR_FILIAL='"+FilOri+"' AND D_E_L_E_T_='' AND ZZR_DTREAL='' " 
cQuery += " AND ZZR_LOCAL='"+cAlmoxarifado+"' AND LEFT(ZZR_DTPLAN,6)='"+cPerInv+"' and ZZR_SEQ<"+ZZR->ZZR_SEQ+" "
cQuery += " ORDER BY R_E_C_N_O_ DESC "

If Select("TMP") <> 0
	TMP->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "TMP"

If  TMP->(!EOF())
	nRecZZR :=TMP->REC
    TMP->(dbskip())
Else
//nใo ha itens a serem inventariados no almoxarifado
    U_MsgColetor("Primeiro item da lista.")
    Return
EndIf

If Select("TMP") <> 0
	TMP->( dbCloseArea() )
EndIf

ZZR->(DBSETORDER(1))
ZZR->(DBGOTO(nRecZZR))

If nRecZZR == ZZR->(RECNO())

    _cProduto  := ZZR->ZZR_PRODUT
    _pro       := ZZR->ZZR_PRODUT
	_Despro    := substr(ZZR->ZZR_DESCRI,1,32) + ENTER  + substr(ZZR->ZZR_DESCRI,33,32) 
	_DT        := DTOC(ZZR->ZZR_DTPLAN)
	 _cEndereco     := Space(Len(CriaVar("BE_LOCALIZ",.F.))+3)
	_cEtiqueta
	If cSeq == ZZR->ZZR_SEQ
		U_MsgColetor("Primeiro item da lista.")
		lNext := .F.
	EndIf
	
    _aCols:={}

	fGetDados()
	_oCodPro:Refresh	
	_oDescPro:Refresh
    oGetDt:Refresh
	oGetEnd:Refresh
	oTxtEtiq:Refresh
	oGetEtiq:Refresh
	oTxtProd:Refresh
	oGetProd:Refresh
	oTxtQtd:Refresh
	oGetQtd:Refresh
	oTxtQTDETQ:Refresh

EndIf




Return

*---------------------------------------------------------------------------------------------
Static Function fOkProc()
*---------------------------------------------------------------------------------------------
If !Empty(_aCols)	
	MsgRun("Processando","Aguarde...",{|| fOkGrava() })
Else
	U_MsgColetor("Nใo existem informa็๕es para serem processadas.")
	RETURN
EndIf

IF lRetTelaBE == .T.
	RETURN
ELSE
	//If Select("TMP") > 0
	//	TMP->(dbCloseArea())
	//EndIf
	
	TMP->( dbGotop() )
	
	While !TMP->( EOF() )
		Reclock("TMP",.F.)
		TMP->( dbDelete() )
		TMP->( msUnlock() )
		dbGotop()
	End
	
	//Close(oInv)
	//U_DOMACD03()
	
	_nTamEtiq      := 21
	_cEndereco     := Space(Len(CriaVar("BE_LOCALIZ",.F.))+3)
	_cEtiqueta     := Space(_nTamEtiq)
	_cProduto      := CriaVar("B1_COD",.F.)
	_nQtd          := CriaVar("XD1_QTDATU",.F.)
	_cLoteEti      := CriaVar("BF_LOTECTL",.F.)
	_cParametro    := "MV_XXNUMIN"
	_cCtrNum       := GetNewPar(_cParametro,"")
	_lAuto	        := .T.
	_lIndividual   := .F.
	_nTamDoc       := Len(CriaVar("B7_DOC",.F.))
	_aCols         := {}
	_aLog          := {}
	_aEnder        := {}
	nTxtQTDETQ     := 0
	_lCALC         := .T.
	_nTotItem      := 0
	//_cDocInv
	//aEmpSB2
	lInvOK         :=.F.
	lRetTelaBE     :=.F.
	_nVLUNIT       :=0
	_nQTDATU       :=0
	_nQTDAJU       :=0
	_nVALAJU       :=0
	_nQTDTOT       :=0
	
	oGetEnd:SetFocus()
	
ENDIF

Return

*---------------------------------------------------------------------------------------------
Static Function fOkGrava()
*---------------------------------------------------------------------------------------------
Local _cNumSerie  :=Space(Len(CriaVar("B7_NUMSERI",.F.)))
Local _nTamEtiq   :=Len(CriaVar("XD1_XXPECA",.F.))
Local aDadosINV   :={}
Local aDadosZZR   :={}
Local nPos        :=0


Private lMsHelpAuto := .T.
Private lMsErroAuto := .F.
Private _aEndereco  := {}

aRegSB7 := {}

//Verifica se existe saldo do produto em outro endereco e sugere o bloqueio.

_cEnderX:=''

FOR _nI :=1 TO Len(_aCols)
	IF EMPTY(_cEnderX)
		_cEnderX :=_ACOLS[_nI][3] // + _ACOLS[_nI][5]
	ELSE
		_cEnderX :=_cEnderX+'|' + _ACOLS[_nI][3] // + _ACOLS[_nI][5]
	ENDIF
NEXT
//AADD(_aCols,{_cEtiqueta,_cProduto,_cEndereco,_nQtd,_cLoteEti,Space(_nTamDoc),SB2->B2_QATU,SB2->B2_VATU1})
_nI :=1
While _nI <= Len(_aCols)
	_cEndereco:=_ACOLS[_nI][3]
	_CLote    :=_ACOLS[_nI][5]
	SBF->( dbSetOrder(2) )
	If SBF->( dbSeek(xFilial("SBF")+SB1->B1_COD+SubStr(_cEndereco,1,2)) )
		Do While.Not.Eof() .And. xFilial("SBF")+SB1->B1_COD == SBF->(BF_FILIAL+BF_PRODUTO)
			If SBF->BF_QUANT > 0
				SBE->(dbSetOrder(1))
				If SBE->(dbSeek(xFilial("SBE")+SBF->BF_LOCAL+SBF->BF_LOCALIZ))
					If SBE->BE_MSBLQL <> "1" .And. !(AllTrim(_cEndereco) == AllTrim(SBE->BE_LOCAL+SBE->BE_LOCALIZ))
						IF ALLTRIM(SBE->BE_LOCAL)==SubStr(_cEndereco,1,2)  //ALLTRIM(SBE->BE_LOCAL)<>'97' //PROCESSO //INVENTARIO MESMO LOCAL
							//IF SBE->(BE_LOCAL+BE_LOCALIZ)+_CLote$_cEnderX
							IF SBE->(BE_LOCAL+BE_LOCALIZ) $_cEnderX
								//Aadd(_aEndereco,{SB1->B1_COD,SBE->BE_LOCAL,SBF->BF_LOCALIZ,SBF->BF_QUANT,SBF->BF_LOTECTL})
							ELSE
								Aadd(_aEndereco,{SB1->B1_COD,SBE->BE_LOCAL,SBF->BF_LOCALIZ,SBF->BF_QUANT,SBF->BF_LOTECTL})
							ENDIF
						ENDIF,
					EndIf
				EndIf
			EndIf
			SBF->(dbSkip())
		EndDo
	EndIf
	
	nQtdNaoZero := 0
	
	If !Empty(_aEndereco)
		_aEnder := _aEndereco
		fTelaBE(_aEndereco)
		IF lRetTelaBE == .T.
			RETURN
		ENDIF
	EndIf
	
	//Ordena pelo c๓digo do produto
	ASort (_aCols,,,{|x,y|x[2] < y[2]}  )
	
	//Posi็ใo _aCols
	//1-Etiqueta
	//2-Produto
	//3-Endereco
	//4-Quantidade
	//5-Lote Etiqueta
	//6-Documento Inventแrio
	
	_cDocInv := "INI"+cPerInv//Soma1(GetMV(_cParametro))
	//PUTMV(_cParametro,_cDocInv )
	
	_cChave := _aCols[_nI][2]
	While _cChave == _aCols[_nI][2]
		_aCols[_nI][6]:= _cDocInv
		_nI ++
		If _nI > Len(_aCols)
			Exit
		EndIf
	End
End
   
/*------------------ MV_PAR01 -----------------------------*/
//PutSx1(	"MTA270", 0, 1, DDATABASE )

Dbselectarea("SX1")
DbsetOrder(1)
If Dbseek("MTA270"+"01")
	Reclock("SX1",.F.)
	SX1->X1_CNT01:= 0
	SX1->(MsUnlock())
EndIf
	
For _nI := 1 To Len(_aCols)
	_aInvent   := {}
	_aEndereco := {}   
	
	SB1->( dbSetOrder(1) )
	If SB1->( dbSeek(xFilial("SB1")+_aCols[_nI][2]) )
		
		_cLocInv := SubStr(_aCols[_nI][3],1,2)
		_cEndInv := SubStr(_aCols[_nI][3],3,Len(Trim(_aCols[_nI][3])))
		
		Aadd(_aInvent,{"B7_FILIAL"  ,xFilial("SB7")       ,Nil})
		Aadd(_aInvent,{"B7_COD"     ,SB1->B1_COD          ,Nil})
		//IF EMPTY(_cLocInv )
		//	Aadd(_aInvent,{"B7_LOCAL"   ,SB1->B1_LOCPAD    ,Nil})
		//ELSE
			Aadd(_aInvent,{"B7_LOCAL"   ,_cLocInv          ,Nil})
		//ENDIF
		Aadd(_aInvent,{"B7_TIPO"    ,SB1->B1_TIPO         ,Nil})
		Aadd(_aInvent,{"B7_DOC"     ,_aCols[_nI][6]       ,Nil})
		Aadd(_aInvent,{"B7_NUMDOC"  ,_aCols[_nI][6]       ,Nil})
		Aadd(_aInvent,{"B7_QUANT"   ,_aCols[_nI][4]       ,Nil})
		Aadd(_aInvent,{"B7_DATA"    ,dDataBase            ,Nil})
		Aadd(_aInvent,{"B7_LOTECTL" ,_aCols[_nI][5]       ,Nil})
		Aadd(_aInvent,{"B7_DTVALID" ,dDataBase            ,Nil})
		//IF EMPTY(_cEndInv )
		//	Aadd(_aInvent,{"B7_LOCALIZ" ,'END.UNIC'        ,Nil})
		//ELSE
			Aadd(_aInvent,{"B7_LOCALIZ" ,_cEndInv          ,Nil})
		//ENDIF
		Aadd(_aInvent,{"B7_XXPECA"  ,Trim(_aCols[_nI][1]) ,Nil})
		
		If SB1->B1_MSBLQL == '1'
			lBloqueado := .T.
			Reclock("SB1",.F.)
			SB1->B1_MSBLQL := '2'
			SB1->( msUnlock() )
		Else
			lBloqueado := .F.
		EndIf
				
		lMsErroAuto := .F.
		nModulo     := 4
		MSExecAuto({|x,y| Mata270(x,y)},_aInvent,.F.,3) //3-Inclusao //5-Exclusao
		
		If lBloqueado
			Reclock("SB1",.F.)
			SB1->B1_MSBLQL := '1'
			SB1->( msUnlock() )
		EndIf
		
		If lMsErroAuto
			MostraErro("\UTIL\LOG\Inventario\Inclusao\")
			
			U_MsgColetor("Erro na inclusใo do inventแrio.")
			Exit
		Else
			AADD(aRegSB7,SB7->( Recno() ))
			Reclock("SB1",.F.)
			SB1->B1_XXDTINV := Date()
			SB1->( msUnlock() )
		EndIf
		
		
		
	Endif
Next

_lCALC:=.T.
_nTotItem :=0

For _nI :=1 To Len(_aCols)
	_nTotItem:=_nTotItem+_aCols[_nI][4]  //acumula quantidade total do item
Next

_nTotItem -= nQtdNaoZero

lPrimeira := .T.

aRecSB7 := {}

If !lMsErroAuto
	
	_cLocInv := '' //MLS 21/10/2015
	_cEndInv := '' //MLS 21/10/2015
	
	For _nI :=1 To Len(_aCols)
		
		_cLocInv := SubStr(_aCols[_nI][3],1,2)                             //MLS 21/10/2015
		_cEndInv := SubStr(_aCols[_nI][3],3,Len(Trim(_aCols[_nI][3])))    //MLS 21/10/2015
		
		GuardaEmps(_aCols[_nI][2],SubStr(_aCols[_nI][3],1,2))
		
		IF _nTotItem == _aCols[_nI][7]  .or. .T.    // Alterado por H้lio para processar o inventario independente da quantidade inventariada bater com o sistema.
			//MSExecAuto({|x,y,z| U_Mata340R(x,y,z)}, _lAuto, _aCols[_nI][6], _lIndividual)			
			//MSExecAuto({|x,y,z| U_Umata340(x,y,z)}, _lAuto, _aCols[_nI][6], _lIndividual)

			
			__cInterNet := 'AUTOMATICO'

			If SB7->(DBSeek(xFilial("SB7")+DTOS(DDATABASE)+_aCols[_nI][2]+_cLocInv+_cEndInv)) 
				MATA340(.T.,_aCols[_nI][6],.T.)
			EndIf
			
			__cInterNet := Nil

			VoltaEmps()
			
			If SB7->(DBSeek(xFilial("SB7")+DTOS(DDATABASE)+_aCols[_nI][2]+_cLocInv+_cEndInv))  //lMsErroAuto
				//MostraErro("\UTIL\Inventario\Execucao\")				
				If SB7->B7_STATUS=='2'       
					nPos  := aScan(aRecSB7,{|x| x[1]==SB7->(RECNO())})					        
					If Empty(nPos)
                    	aadd(aRecSB7,{SB7->(RECNO())})             
					EndIf
					If lPrimeira
						lPrimeira := .F.
						XD1->( dbSetOrder(4))
						XD1->( dbSeek( xFilial("XD1") + Subs(_cProduto,1,15) ) )
						While !XD1->( EOF() ) .and. XD1->XD1_FILIAL == xFilial("XD1") .and. Alltrim(XD1->XD1_COD) == Alltrim(_cProduto)
							If XD1->XD1_OCORRE <> '5' .AND. XD1->XD1_LOCAL == _cLocInv
								Reclock("XD1",.F.)
								XD1->XD1_OCORRE := '5' //VERIFICAR PARA NAO REPASSAR TODOS COM 5
								XD1->XD1_QTDATU := 0
								XD1->( msUnlock() )
							EndIf
							XD1->( dbSkip() )
						End
					EndIf
				
					XD1->( dbSetOrder(1)) // MLS XD1
					If XD1->( dbSeek( xFilial("XD1") + _aCols[_nI][1] ) )
						//IF _nTotItem == _aCols[_nI][7]
						If XD1->XD1_QTDATU <> _aCols[_nI][4] .or. XD1->XD1_OCORRE <> '4' .or. Alltrim(XD1->XD1_LOCAL) <> Alltrim(_cLocInv) .or. Alltrim(XD1->XD1_LOCALI) <> Alltrim(_cEndInv)
							Reclock("XD1",.F.)
							XD1->XD1_QTDATU := _aCols[_nI][4]
							XD1->XD1_OCORRE := '4'
							XD1->XD1_LOCAL  := _cLocInv
							XD1->XD1_LOCALI := _cEndInv
							XD1->( MsUnlock() )
						EndIf
						//EndIf
					EndIf
				
					SB2->( dbSetOrder(1) )
					If SB2->( dbSeek( xFilial("SB2")+ _aCols[_nI][2]+_cLocInv ) )
						//AADD(_aLog,{_aCols[_nI][1],_aCols[_nI][2],_aCols[_nI][3],_aCols[_nI][4],_aCols[_nI][5],_aCols[_nI][6],_aCols[_nI][7],_aCols[_nI][8],SB2->B2_QATU,SB2->B2_VATU1 })
						AADD(_aLog,{_aCols[_nI][1],_aCols[_nI][2],_cLocInv+_cEndInv,_aCols[_nI][4],_aCols[_nI][5],_aCols[_nI][6],_aCols[_nI][7],_aCols[_nI][8],SB2->B2_QATU,SB2->B2_VATU1 })
					EndIf
				EndIf				
			Else //Atualiza a etiqueta , caso a quantidade inventariada seja diferente.
					U_MsgColetor("Erro no processamento do inventแrio.")
			EndIf
			//U_MsgColetor("Inventแrio EFETUADO.")
			If _nTotItem == _aCols[_nI][7]
				lInvOK :=.T.
			Else
				lInvOK :=.F.
			EndIf
		ELSE
			//U_MsgColetor("Inventแrio com quantidades divergente informar a controladoria.")
			lInvOK :=.F.
			SB2->( dbSetOrder(1) )
			If SB2->( dbSeek( xFilial("SB2")+ _aCols[_nI][2]+_cLocInv ) )
				AADD(_aLog,{_aCols[_nI][1],_aCols[_nI][2],_aCols[_nI][3],_aCols[_nI][4],_aCols[_nI][5],_aCols[_nI][6],_aCols[_nI][7],_aCols[_nI][8],SB2->B2_QATU,SB2->B2_VATU1 })
			ENDIF
		ENDIF
	Next
EndIf



SB7->(DBSETORDER(1))
SD3->(DBSETORDER(2))
For x := 1 to len(aRecSB7)
    SB7->(DBGOTO(aRecSB7[x][1]))
    If aRecSB7[x][1] == SB7->(RECNO())
        If SD3->(DBSeek(xFilial("SD3")+SB7->B7_DOC+SB7->B7_COD))
            While SD3->(!EOF()) .AND. SB7->B7_DOC == SD3->D3_DOC .AND. SB7->B7_COD== SD3->D3_COD
                If SD3->D3_EMISSAO == SB7->B7_DATA .AND. SD3->D3_LOCAL == SB7->B7_LOCAL .AND. SD3->D3_LOCALIZ=SB7->B7_LOCALIZ
                    AADD(aDadosINV, {SD3->D3_COD, SD3->D3_LOCAL, SD3->D3_NUMSEQ, SD3->D3_TM, SD3->D3_QUANT, SD3->D3_CUSTO1} )
                EndIf
            SD3->(DBSKIP())
            Enddo
        Else
            AADD(aDadosINV, {SB7->B7_COD, SB7->B7_LOCAL, '', '', '', ''} )    
        EndIf
    EndIf
Next x


For x := 1 to len(aDadosINV)

    nPos  := aScan(aDadosZZR,{|aVet| Alltrim(aVet[1])==alltrim(aDadosINV[x][1]) .AND. Alltrim(aVet[2])==alltrim(aDadosINV[x][2]) })
 			// aScan( aVetSZY, { |aVet| aVet[1] == SZY->ZY_PRODUTO } )
    If !Empty(nPos)
        If aDadosINV[x][4] == '999'
           aDadosZZR[nPos][3] += "','"+aDadosINV[x][3] 
           aDadosZZR[nPos][4] += aDadosINV[x][5] 
           aDadosZZR[nPos][5] += aDadosINV[x][6] 
        ElseIf aDadosINV[x][4] == '499'
          aDadosZZR[nPos][3] += "','"+aDadosINV[x][3] 
          aDadosZZR[nPos][6] += aDadosINV[x][5] 
          aDadosZZR[nPos][7] += aDadosINV[x][6]         
        EndiF
    Else
        If aDadosINV[x][4] == '999'
            //                Produto         Local           NUMSEQ            QTD REQ          VLR REQ         QTD DEV   VLR DEV
            aadd(aDadosZZR, {aDadosINV[x][1], aDadosINV[x][2], aDadosINV[x][3], aDadosINV[x][5],aDadosINV[x][6], 0, 0 })
        ElseIf aDadosINV[x][4] == '499'
            aadd(aDadosZZR, {aDadosINV[x][1], aDadosINV[x][2], aDadosINV[x][3], 0, 0, aDadosINV[x][5], aDadosINV[x][6] })
        Else
            aadd(aDadosZZR, {aDadosINV[x][1], aDadosINV[x][2], '',0, 0, 0, 0 })
        EndiF
    EndiF

Next x

ZZR->(DbsetOrder(3))
For x := 1 to len(aDadosZZR)
	If ZZR->(Dbseek(xFilial("ZZR") + cPerInv + aDadosZZR[x][1] + aDadosZZR[x][2]))
		Reclock("ZZR",.F.)		
		ZZR->ZZR_DTREAL := DDATABASE		
		ZZR->ZZR_QTDAJU += aDadosZZR[x][6] - aDadosZZR[x][4]
		ZZR->ZZR_VALAJU += aDadosZZR[x][7] - aDadosZZR[x][5]
		ZZR->ZZR_STATUS := "P"
		ZZR->ZZR_QTDREQ +=  aDadosZZR[x][4]
		ZZR->ZZR_VALREQ +=  aDadosZZR[x][5]
		ZZR->ZZR_QTDDEV +=  aDadosZZR[x][6]
		ZZR->ZZR_VALDEV +=  aDadosZZR[x][7]
		ZZR->ZZR_NUMSEQ :=  ZZR->ZZR_NUMSEQ+''+aDadosZZR[x][3]
		ZZR->(MsUnLock())
	EndIF
Next x

IF lInvOK == .T.
	U_MsgColetor("Inventแrio processado SEM altera็ใo da quantidade total em estoque.")
ELSE
	U_MsgColetor("Inventแrio processado COM altera็ใo da quantidade total em estoque.")
	//lRetTelaBE :=.F.
ENDIF


Return

*---------------------------------------------------------------------------------------------
Static Function fTelaBE(_aDadosBE)
*---------------------------------------------------------------------------------------------
Local oTxtBEProd ,oTxtBEMsg ,oGetProdBE
Local _aArea:= GetArea()

Define MsDialog oDlgBE Title OemToAnsi("Zerar Marcados") From 0,0 To 293,233 Pixel of oMainWnd PIXEL

@ 005,001 Say oTxtBEMsg Var "O SALDO do endere็o serแ ZERADO. "  Pixel Of oDlgBE
oTxtBEMsg:oFont:= TFont():New('Arial',,15,,.T.,,,,.T.,.F.)

@ 018,001 Say oTxtBEProd Var "Produto "  Pixel Of oDlgBE
@ 018,040 MsGet oGetProdBE Var SB1->B1_COD When .F. Size 70,10  Pixel Of oDlgBE
oTxtBEProd:oFont:= TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
oGetProdBE:oFont:= TFont():New('Arial',,15,,.T.,,,,.T.,.F.)

fGetDadosBE(_aDadosBE)

@ 130,005 Button "Voltar"    Size 40,15 Action FClosebe() Pixel Of oDlgBE
@ 130,070 Button "Processar" Size 40,15 Action fOkBloq()  Pixel Of oDlgBE

Activate MsDialog oDlgBE
RestArea(_aArea)
Return



*---------------------------------------------------------------------------------------------
Static Function FClosebe()
*---------------------------------------------------------------------------------------------
Close(oDlgBE)
lRetTelaBE :=.T.
RETURN


*---------------------------------------------------------------------------------------------
Static Function fOkBloq()
*---------------------------------------------------------------------------------------------
Local aRecSB7    := {}
Local aDadosINV  := {}
Local aDadosZZR  := {}
Close(oDlgBE)
//nQtdNaoZero := 0
_aEndBlq :={}
lNaoZero := .F.
//lRetTelaBE := .T.  //MLS 28/10/15

dbSelectArea("TRB")
dbGotop()
Do While.Not.Eof()
	
	If Marked("MARCA")
		SB1->(dbSetOrder(1))
		If SB1->(dbSeek(xFilial("SB1")+TRB->PRODUTO))
			_cDocInv := "INZ"+cPerInv//Soma1(GetMV(_cParametro))
			//PUTMV(_cParametro,_cDocInv )
			
			_aInvent:={}
			
			Aadd(_aInvent,{"B7_FILIAL"  ,xFilial("SB7")       ,Nil})
			Aadd(_aInvent,{"B7_COD"     ,SB1->B1_COD          ,Nil})
			Aadd(_aInvent,{"B7_LOCAL"   ,TRB->LOC             ,Nil})
			Aadd(_aInvent,{"B7_TIPO"    ,SB1->B1_TIPO         ,Nil})
			Aadd(_aInvent,{"B7_DOC"     ,_cDocInv             ,Nil})
			Aadd(_aInvent,{"B7_NUMDOC"  ,_cDocInv             ,Nil})
			Aadd(_aInvent,{"B7_QUANT"   ,0                    ,Nil})
			Aadd(_aInvent,{"B7_DATA"    ,dDataBase            ,Nil})
			Aadd(_aInvent,{"B7_LOTECTL" ,TRB->LOTE            ,Nil})
			Aadd(_aInvent,{"B7_DTVALID" ,dDataBase            ,Nil})
			Aadd(_aInvent,{"B7_LOCALIZ" ,TRB->ENDERECO        ,Nil})
			Aadd(_aInvent,{"B7_XXPECA"  ,"BLOQUEADO"          ,Nil})
			
			AADD(_aLog,{"BLOQUEADO",SB1->B1_COD,TRB->ENDERECO,0,TRB->LOTE,_cDocInv,0,0,0,0 })
			
			
			aAreaSB1 := SB1->( GetArea() )
			lMsErroAuto := .F.
			
			If SB1->B1_MSBLQL == '1'
				lBloqueado := .T.
				Reclock("SB1",.F.)
				SB1->B1_MSBLQL := '2'
				SB1->( msUnlock() )
			Else
				lBloqueado := .F.
			EndIf

			
			MSExecAuto({|x,y| Mata270(x,y)},_aInvent,.F.,3) //3-Inclusao //5-Exclusao
			
			RestArea(aAreaSB1)
			
			If lBloqueado
				Reclock("SB1",.F.)
				SB1->B1_MSBLQL := '1'
				SB1->( msUnlock() )
			EndIf
			
			RestArea(aAreaSB1)
			
			If lMsErroAuto
				MostraErro("\UTIL\LOG\Bloqueio\Inclusao\")
				
				U_MsgColetor("Erro ao zerar o endereco.(Inclusใo SB7)")
			EndIf
			
			
			
			If !lMsErroAuto
				
				SB7->(dbSetOrder(1))
				//SB1->(dbSetOrder(1))
				
				//SB1->( dbSeek( xFilial() + SB1->B1_COD ) )
				
				If SB7->(dbSeek(xFilial("SB7")+Dtos(dDataBase)+SB1->B1_COD+TRB->LOC+TRB->ENDERECO))
					
					lMsErroAuto := .F.
					
					GuardaEmps(SB1->B1_COD,TRB->LOC)

					__cInterNet := 'AUTOMATICO'
					
					MATA340(.T.,_cDocInv,.T.)
					
			
					__cInterNet := Nil
			
					//MSExecAuto({|x,y,z| U_Mata340R(x,y,z)}, _lAuto, _cDocInv, _lIndividual)    
					//MSExecAuto({|x,y,z| U_Umata340(x,y,z)}, _lAuto, _cDocInv, _lIndividual)    
					VoltaEmps()
					
					If lMsErroAuto
						MostraErro("\UTIL\Bloqueio\Execucao\")
						
						U_MsgColetor("Erro bloqueio do endereco.(D3)")
					Else
						nPos  := aScan(aRecSB7,{|x| x[1]==SB7->(RECNO())})					        
						If Empty(nPos)
                    		aadd(aRecSB7,{SB7->(RECNO())})             
						EndIf
						aAdd(_aEndBlq,{TRB->LOC,TRB->ENDERECO})
					EndIf
				Else
					U_MsgColetor("Inventแrio nใo encontrado.")
					lMsErroAuto:=.T.
				EndIf
				
			EndIf
			//lRetTelaBE := .F. //MLS 28/10/15
		EndIf
	Else
		nQtdNaoZero += TRB->QTD
		lNaoZero    := .T.
	EndIf
	dbSelectArea("TRB")
	dbSkip()
EndDo
lRetTelaBE := .F.  //MLS 28/10/15
//IF lRetTelaBE := .T.
//	U_MsgColetor("Produto deverแ ser inventariado em todos os enderecos, ou deverแ ser zerado ")
//ENDIF

If lNaoZero
	U_MsgColetor("O produto dever ser inventariado ou zerado em todos os endere็os com saldo.")
EndIf


SB7->(DBSETORDER(1))
SD3->(DBSETORDER(2))
For x := 1 to len(aRecSB7)
    SB7->(DBGOTO(aRecSB7[x][1]))
    If aRecSB7[x][1] == SB7->(RECNO())
        If SD3->(DBSeek(xFilial("SD3")+SB7->B7_DOC+SB7->B7_COD))
            While SD3->(!EOF()) .AND. SB7->B7_DOC == SD3->D3_DOC .AND. SB7->B7_COD== SD3->D3_COD
                If SD3->D3_EMISSAO == SB7->B7_DATA .AND. SD3->D3_LOCAL == SB7->B7_LOCAL
                    AADD(aDadosINV, {SD3->D3_COD, SD3->D3_LOCAL, SD3->D3_NUMSEQ, SD3->D3_TM, SD3->D3_QUANT, SD3->D3_CUSTO1} )
                EndIf
            SD3->(DBSKIP())
            Enddo
        Else
            AADD(aDadosINV, {SB7->B7_COD, SB7->B7_LOCAL, '', '', '', ''} )    
        EndIf
    EndIf
Next x


For x := 1 to len(aDadosINV)

    nPos  := aScan(aDadosZZR,{|x| Alltrim(x[1])==alltrim(aDadosINV[x][1]) .AND. Alltrim(x[2])==alltrim(aDadosINV[x][2]) })

    If !Empty(nPos)
        If aDadosINV[x][4] == '999'
           aDadosZZR[nPos][3] += "','"+aDadosINV[x][3] 
           aDadosZZR[nPos][4] += aDadosINV[x][5] 
           aDadosZZR[nPos][5] += aDadosINV[x][6] 
        ElseIf aDadosINV[x][4] == '499'
          aDadosZZR[nPos][3] += "','"+aDadosINV[x][3] 
          aDadosZZR[nPos][6] += aDadosINV[x][5] 
          aDadosZZR[nPos][7] += aDadosINV[x][6]         
        EndiF
    Else
        If aDadosINV[x][4] == '999'
            //                Produto         Local           NUMSEQ            QTD REQ          VLR REQ         QTD DEV   VLR DEV
            aadd(aDadosZZR, {aDadosINV[x][1], aDadosINV[x][2], aDadosINV[x][3], aDadosINV[x][5],aDadosINV[x][6], 0, 0 })
        ElseIf aDadosINV[x][4] == '499'
            aadd(aDadosZZR, {aDadosINV[x][1], aDadosINV[x][2], aDadosINV[x][3], 0, 0, aDadosINV[x][5], aDadosINV[x][6] })
        Else
            aadd(aDadosZZR, {aDadosINV[x][1], aDadosINV[x][2], '',0, 0, 0, 0 })
        EndiF
    EndiF

Next x

ZZR->(DbsetOrder(3))
For x := 1 to len(aDadosZZR)
	If ZZR->(Dbseek(xFilial("ZZR") + cPerInv + aDadosZZR[x][1] + aDadosZZR[x][2]))
		Reclock("ZZR",.F.)		
		ZZR->ZZR_DTREAL := DDATABASE		
		ZZR->ZZR_QTDAJU += aDadosZZR[x][6] - aDadosZZR[x][4]
		ZZR->ZZR_VALAJU += aDadosZZR[x][7] - aDadosZZR[x][5]
		ZZR->ZZR_STATUS := "P"
		ZZR->ZZR_QTDREQ +=  aDadosZZR[x][4]
		ZZR->ZZR_VALREQ +=  aDadosZZR[x][5]
		ZZR->ZZR_QTDDEV +=  aDadosZZR[x][6]
		ZZR->ZZR_VALDEV +=  aDadosZZR[x][7]
		ZZR->ZZR_NUMSEQ :=  aDadosZZR[x][3]
		ZZR->(MsUnLock())
	EndIF
Next x

Return

*---------------------------------------------------------------------------------------------
Static Function fOkQtd()
*---------------------------------------------------------------------------------------------
Local _lDivB2B8 := .F.
Local _lLotBloq := .F.

If XD1->XD1_QTDATU <> _nQtd
	cTemp := 'Confirma a quantidade '+Chr(13)+'de '+Alltrim(Transform(_nQtd,"@E 999,999,999.9999"))+'?'
	
	lRet := .T.
	While lRet
		If apMsgNoYes( cTemp )
			lRet := .F.
		EndIf
	End
EndIf

//Verifica diverg๊ncia entre o saldo do endere็o com o atual.
SB2->(dbSetOrder(1) )
If SB2->(dbSeek(xFilial("SB2")+_cProduto+SubStr(_cEndereco,1,2)))
	//If QtdComp(SB2->B2_QATU)-QtdComp(SB2->B2_QACLASS) # QtdComp(SaldoSBF(SubStr(_cEndereco,1,2),"",_cProduto))
	//	_lDivB2B8:=.T.
	//EndIf
EndIf

AADD(_aCols,{_cEtiqueta,_cProduto,_cEndereco,_nQtd,_cLoteEti,Space(_nTamDoc),SB2->B2_QATU,SB2->B2_VATU1})

dbSelectArea("TMP")
dbGotop()
If! TMP->( dbSeek(_cEtiqueta) )
	Reclock("TMP",.T.)
	Replace TMP->ETQ With _cEtiqueta // _cProduto
	Replace TMP->QTD With _nQtd
	MsUnLock()
	nTxtQTDETQ:=nTxtQTDETQ+1
	oTxtQTDETQ:Refresh()
Else
	Reclock("TMP",.F.)
	Replace TMP->QTD     With TMP->QTD+_nQtd
	MsUnLock()
EndIf

dbSelectArea("TMP")
dbGotop()

oMark:oBrowse:Refresh()

_cEtiqueta:= Space(_nTamEtiq)
_nQtd     := CriaVar("XD1_QTDATU",.F.)
oInv      :Refresh()
oGetEtiq  :SetFocus()
Return()

*---------------------------------------------------------------------------------------------
Static Function fGetDados()
*---------------------------------------------------------------------------------------------
Local _aStru  := {}

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf

AADD(_aStru, {"ETQ" ,"C",15,0} )
AADD(_aStru, {"QTD"    ,"N",14,2} )

_cArqTrab := CriaTrab(_aStru,.T.)

dbUseArea(.T.,__LocalDriver,_cArqTrab,"TMP",.F.)

IndRegua("TMP",_cArqTrab,"ETQ",,,)

_aCampos := {}

AADD(_aCampos,{"ETQ"     ,"" ,"Etiqueta"    ,"@R"              } )
AADD(_aCampos,{"QTD"     ,"" ,"Quant."      ,"@E 999,999.9999" } )

oMark:= MsSelect():New("TMP",,,_aCampos,Nil,Nil,{82,00,127,117}) //64,00,127,117
oMark:oFont:= TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
oMark:oBrowse:oFont:= TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
oMark:oBrowse:Refresh()

dbSelectArea("TMP")
dbGotop()

Return

*---------------------------------------------------------------------------------------------
Static Function fGetDadosBE(_aDadosBE)
*---------------------------------------------------------------------------------------------
Local _aStru   := {}
Local _nTamEnd := Len(CriaVar("BE_LOCALIZ",.F.))
Local _nTamCod := Len(CriaVar("B1_COD"    ,.F.))
Local _nTamLot := Len(CriaVar("BF_LOTECTL",.F.))

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

AADD(_aStru, {"MARCA"   ,"C",01,0} )
AADD(_aStru, {"ENDERECO","C",_nTamEnd,0} )
AADD(_aStru, {"QTD"     ,"N",11,2} )
AADD(_aStru, {"LOC"     ,"C",02,0} )
AADD(_aStru, {"PRODUTO" ,"C",_nTamCod,0} )
AADD(_aStru, {"LOTE"    ,"C",_nTamLot,0} )

_cArqTrabBE := CriaTrab(_aStru,.T.)

dbUseArea(.T.,__LocalDriver,_cArqTrabBE,"TRB",.F.)

IndRegua("TRB",_cArqTrabBE,"ENDERECO",,,)

_aCamposBE := {}

AADD(_aCamposBE,{"MARCA"       ,"" ,""             ,""                } )
AADD(_aCamposBE,{"ENDERECO"    ,"" ,"Endere็o"     ,"@R"              } )
AADD(_aCamposBE,{"QTD"         ,"" ,"Quant."       ,"@E 999,999.9999"  } )
AADD(_aCamposBE,{"LOC"         ,"" ,"Local"        ,"@R"              } )
AADD(_aCamposBE,{"LOTE "       ,"" ,"Lote"         ,"@R"              } )

oMark2:= MsSelect():New("TRB","MARCA",,_aCamposBE,Nil,Nil,{34,00,127,117})

For j:=1 To Len(_aDadosBE)
	IF ALLTRIM(_aDadosBE[j][2])<>'97'
		Reclock("TRB",.T.)
		Replace TRB->PRODUTO  With _aDadosBE[j][1]
		Replace TRB->LOC      With _aDadosBE[j][2]
		Replace TRB->ENDERECO With _aDadosBE[j][3]
		Replace TRB->QTD      With _aDadosBE[j][4]
		Replace TRB->LOTE     With _aDadosBE[j][5]
		MsUnLock()
	ENDIF
Next

dbSelectArea("TRB")
dbGotop()
oMark2:oBrowse:Refresh()

Return

*---------------------------------------------------------------------------------------------
Static Function fValEnd()
*---------------------------------------------------------------------------------------------
Local _lRet:=.T.

IF EMPTY(_cEndereco)
	If !Empty(_aCols)
		RETURN(.t.)    
	Else
		U_MsgColetor('Endere็o em branco.')
		RETURN(.f.)    
	EndIf
ENDIF

SBE->( dbSetOrder(1) )
If SBE->( dbSeek( xFilial("SBE") + Subs(_cEndereco,1,17) ) )
	If SBE->BE_MSBLQL == '1'
		U_MsgColetor('Endere็o bloqueado para uso.')
		_lRet := .F.		
	EndIf
Else
	U_MsgColetor('Endere็o nใo encontrado.')
	_lRet := .F.	
EndIf

Return(_lRet)

*---------------------------------------------------------------------------------------------
Static Function fValEtiq()
*---------------------------------------------------------------------------------------------
Local _lRet   :=.T.
Local _nSaldo := 0


IF EMPTY(_cEndereco)
	U_MsgColetor('Endere็o em branco.')
	RETURN(.f.)    
ENDIF

If Len(AllTrim(_cEtiqueta))==12 //EAN 13 s/ dํgito verificador.
	_cEtiqueta := "0"+_cEtiqueta
	_cEtiqueta := Subs(_cEtiqueta,1,12)
EndIf

If Len(AllTrim(_cEtiqueta))==20 //CODE 128 c/ dํgito verificador.
	_cEtiqueta := Subs(AllTrim(_cEtiqueta),8,12)
EndIf

oGetEtiq:Refresh()

If Empty(_cEtiqueta)
	_cEndereco:= Space(Len(CriaVar("BE_LOCALIZ",.F.))+3)
	oGetEnd:REFRESH()
	oGetEnd:SetFocus()
	RETURN
ENDIF

If !Empty(_cEtiqueta)
	XD1->( dbSetOrder(1))
	If XD1->( dbSeek( xFilial("XD1") + _cEtiqueta ) )
		SB1->( dbSetOrder(1) )
		If Empty(alltrim(_cProduto))
			_cProduto := XD1->XD1_COD
		EndIF
		IF _cProduto<>XD1->XD1_COD //.AND. !EMPTY(_cProduto)
			U_MsgColetor("Produto Etiqueta diferente do processo")
			RETURN
		ENDIF
		//_cProduto := XD1->XD1_COD
		
		IF alltrim(XD1->XD1_LOCALI) <> alltrim(SUBSTR(_cEndereco,3,LEN(_cEndereco)))
			U_MsgColetor("Endere็o etiqueta diferente Endere็o coletado. ")
			//RETURN
		ENDIF
		
		If SB1->( dbSeek( xFilial("SB1") + _cProduto) )
			If SB1->B1_LOCALIZ == 'S'
				//Verifica se o produto possui saldo a endere็ar.
				//dbSelectArea("SDA")
				SDA->( dbSetOrder(1) )
				SDA->( dbSeek(xFilial("SDA")+_cProduto+SubStr(_cEndereco,1,2)) )
				While xFilial("SDA")+_cProduto+SubStr(_cEndereco,1,2) == SDA->DA_FILIAL+SDA->DA_PRODUTO+SDA->DA_LOCAL
					_nSaldo += SDA->DA_SALDO
					SDA->( dbSkip() )
				End
				
				If _nSaldo == 0
					
					If Len(_aCols)>0
						If aScan(_aCols,{ |x| Upper(AllTrim(x[1])) == Trim(_cEtiqueta) }) == 0   //Se a etiqueta nใo foi utilizada.
							If! aScan(_aCols,{ |x| Upper(AllTrim(x[2])) == Trim(_cProduto) }) == 0 //Produto diferente
								_cProduto  := SB1->B1_COD
								_nQtd      := XD1->XD1_QTDATU
								_cLoteEti  := If(Empty(XD1->XD1_LOTECT),"LOTE1308",XD1->XD1_LOTECT)
							Else
								_lRet:=.F.
								U_MsgColetor("O produto"+Chr(13)+AllTrim(_cProduto)+" nใo estแ sendo inventariado neste  momento.")
							EndIf
						Else
							_lRet:=.F.
							U_MsgColetor("Etiqueta  jแ utilizada !")
						EndIf
					Else
						SB7->( dbSetOrder(1) )
						If SB7->( dbSeek(xFilial("SB7") + DtoS(dDataBase) + SB1->B1_COD + XD1->XD1_LOCAL ) )
							nTemp := 0
							While !SB7->( EOF() ) .and. xFilial("SB7") + DtoS(dDataBase) + SB1->B1_COD + XD1->XD1_LOCAL == SB7->B7_FILIAL + DtoS(SB7->B7_DATA) + SB7->B7_COD + SB7->B7_LOCAL
								nTemp++
								SB7->( dbSkip() )
							End
							U_MsgColetor("Existem " + Alltrim(Str(nTemp)) + " registros de inventแrio lan็ados para este produto nesta data. Entre na rotina de exclusใo de inventแrios para continuar")
							_lRet:=.F.
							U_MsgColetor("Inventแrio abortado.")
						Else
							SB2->(dbSetOrder(1))
							If SB2->(dbSeek(xFilial("SB2")+SB1->B1_COD+SubStr(_cEndereco,1,2)))
								// Validando se o produto tem diverg๊ncia de SB2 para SBF
								If QtdComp(SB2->B2_QATU)-QtdComp(SB2->B2_QACLASS) # QtdComp(SaldoSBF(SubStr(_cEndereco,1,2),"",_cProduto))
									U_MsgColetor("Diverg๊ncia de Saldo Fํsico X Saldo por Endere็o. Nใo serแ possํvel inventariar este produto.")
									_lRet:=.F.
									U_MsgColetor("Inventแrio abortado.")
								Else
									_cProduto := SB1->B1_COD
									_nQtd     := XD1->XD1_QTDATU
									_cLoteEti := ""
									
									_cLoteEti := If(Empty(XD1->XD1_LOTECT),"LOTE1308",XD1->XD1_LOTECT)
									
									oGetQtd :SetFocus()
								EndIf
							EndIf
						EndIf
						
					Endif
				Else
					_lRet := .F.
					U_MsgColetor("ATENวรO existe saldo a endere็ar. Nใo ้ possํvel inventariar produtos com pend๊ncias de endere็amento.")
				EndIf
			Else
				_lRet:=.F.
				U_MsgColetor("Produto nใo controla por endere็o.")
			EndIf
		Else
			_lRet:=.F.
			U_MsgColetor("Produto NรO encontrado")
		EndIf
	Else
		_lRet:=.F.
		U_MsgColetor("Etiqueta nใo encontrada.")
	EndIf
EndIf

If! _lRet
	_cEtiqueta:= Space(_nTamEtiq)
	_cProduto := CriaVar("B1_COD",.F.)
	oGetEtiq  :Refresh()
	oGetEtiq  :SetFocus()
Else
	oGetQtd :SetFocus()
	oGetQtd :Refresh()
EndIf

Return(_lRet)

*---------------------------------------------------------------------------------------------
Static Function fOkEmail()
*---------------------------------------------------------------------------------------------
Local CrLf	     := Chr(13)+Chr(10)
Local cMsg	     := ""
Local lOk        := .F.
Local _cAccount  := AllTrim(GetNewPar("MV_RELACNT",""))
Local _cPassword := AllTrim(GetNewPar("MV_RELPSW"," "))
Local _lAutentica:= GetMv("MV_RELAUTH",,.F.)
Local _cUserAut  := AllTrim(GetMv("MV_RELAUSR",,_cAccount))
Local _cPassAut  := AllTrim(GetMv("MV_RELAPSW",,_cPassword))
Local _cServer   := AllTrim(GetMv('MV_RELSERV'))
PRIVATE _nEND    :=0

//_cPara := "luciano.silva@rdt.com.br,denis.vieira@rosenbergerdomex.com.br,sergio.santos@rosenbergerdomex.com.br"
//_cPara += ",carlos.sepinho@rosenbergerdomex.com.br,eder.augusto@rosenbergerdomex.com.br" //mls 27/08/2015
_cPara := "jonas@opusvp.com.br"

_cSubject:="ERP Protheus - Inventario Coletor "

cMsg := ''
cMsg += '<html>'
cMsg +='<style type="text/css">'
cMsg +='<!--'
cMsg +='  h1 {font-family:Arial Unicode MS;font-size: 11px;font-weight: normal;}'
cMsg +='  h4 {font-family:Arial Unicode MS;font-size: 13px;font-weight: bold;}'
cMsg +='  table.bordasimples {border-collapse: collapse;}'
cMsg +='  table.bordarodape {border-top: 2px solid #000;'
cMsg +='                      border-bottom: 2px solid #000;}'
cMsg +='  --></style>'

cMsg += '<font size="2" face="Arial">Inventแrio.  </font>'+CrLf+CrLf

cMsg += '<table border="0" width="100%" height="20">'
cMsg += '<tr>'
cMsg += '<th width="05%" align="left" bgcolor="#87CEFA">'
cMsg += '<h4>Documento Inventแrio</font></th>'

cMsg += '<th width="12%" align="left" bgcolor="#87CEFA">'
cMsg += '<h4>Produto</font></th>'

cMsg += '<th width="25%" align="left" bgcolor="#87CEFA">'
cMsg += '<h4>Descri็ใo</font></th>'

cMsg += '<th width="08%" align="left" bgcolor="#87CEFA">'
cMsg += '<h4>Armazem</font></th>'

cMsg += '<th width="08%" align="left" bgcolor="#87CEFA">'
cMsg += '<h4>Endere็o</font></th>'

cMsg += '<th width="05%" align="left" bgcolor="#87CEFA">'
cMsg += '<h4>Lote</font></th>'

cMsg += '<th width="05%" align="left" bgcolor="#87CEFA">'
cMsg += '<h4>Etiqueta</font></th>'

cMsg += '<th width="10%" align="left" bgcolor="#87CEFA">'
cMsg += '<h4>Qtd Inventแrio</font></th>'

//cMsg += '<th width="10%" align="left" bgcolor="#87CEFA">'
//cMsg += '<h4>Qtd Anterior (Saldo Atual)</font></th>'

//cMsg += '<th width="05%" align="left" bgcolor="#87CEFA">'
//cMsg += '<h4>Valor Anterior (Saldo Atual)</font></th>'

//cMsg += '<th width="10%" align="left" bgcolor="#87CEFA">'
//cMsg += '<h4>Qtd Atual </font></th>'

//cMsg += '<th width="05%" align="left" bgcolor="#87CEFA">'
//cMsg += '<h4>Valor Atual</font></th>'

cMsg += '</tr>'

_nVrTotAnt:=0
_nVrTotAtu:=0

cDados:=""

_nVLUNIT  :=0
_nQTDATU  :=0
_nQTDAJU  :=0
_nVALAJU  :=0
_nQTDTOT  :=0

For _nX:=1 To Len(_aLog)
	
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1")+_aLog[_nX][2]))
	
	cDados += '<tr>'
	cDados += '<td width="05%" align="left">'
	cDados += '<h1>'+_aLog[_nX][6]+'</font></td>'
	cDados += '<td width="12%" align="left">'
	//cDados += '<h1>'+_aLog[_nX][2]+'   '+_aLog[_nX][1]+'</font></td>'
	cDados += '<h1>'+_aLog[_nX][2]+'</font></td>'
	
	cDados += '<td width="25%" align="left">'
	cDados += '<h1>'+AllTrim(SB1->B1_DESC)+'</font></td>'
	
	cDados += '<td width="08%" align="left">'
	cDados += '<h1>'+SUBSTR(_aLog[_nX][3],1,2)+'</font></td>'
	
	cDados += '<td width="08%" align="left">'
	cDados += '<h1>'+SUBSTR(_aLog[_nX][3],3,LEN(_aLog[_nX][3]))+'</font></td>'
	
	cDados += '<td width="05%" align="left">'
	cDados += '<h1>'+_aLog[_nX][5]+'</font></td>'
	
	cDados += '<td width="05%" align="left">'
	cDados += '<h1>'+_aLog[_nX][1]+'</font></td>'
	
	cDados += '<td width="10%" align="right">'
	cDados += '<h1>'+TransForm(_aLog[_nX][4],"@E 999,999,999.9999")+'</font></td>'
	
	//	cDados += '<td width="10%" align="right">'
	//	cDados += '<h1>'+TransForm(_aLog[_nX][7],"@E 999,999,999.99")+'</font></td>'
	
	//	cDados += '<td width="05%" align="right">'
	//	cDados += '<h1>'+TransForm(_aLog[_nX][8],"@E 999,999,999.99")+'</font></td>'
	
	//	cDados += '<td width="10%" align="right">'
	//	cDados += '<h1>'+TransForm(_aLog[_nX][9],"@E 999,999,999.99")+'</font></td>'
	
	//	cDados += '<td width="05%" align="right">'
	//	cDados += '<h1>'+TransForm(_aLog[_nX][10],"@E 999,999,999.99")+'</font></td>'
	
	cDados += '</tr>'
	
	_nVrTotAnt+=_aLog[_nX][8]
	_nVrTotAtu+=_aLog[_nX][10]
	
	_nQTDTOT:=_nQTDTOT+_aLog[_nX][4]
	
Next
cMsg += cDados + Crlf
cMsg += '</table>'+Crlf+Crlf

_nVLUNIT:=0
IF LEN(_aLog)>0
	_nX:=1
	SB2->( dbSetOrder(1) )
	If SB2->( dbSeek( xFilial("SB2")+ ALLTRIM(_aLog[_nX][2]) ) )
		Do while .NOT. SB2->(EOF()) .AND. ALLTRIM(SB2->B2_COD)==ALLTRIM(_aLog[_nX][2])
			IF SB2->B2_QATU>0
				cMsg += '<font size="2" face="Arial">Armazem '+SB2->B2_LOCAL+' Saldo '+TransForm(SB2->B2_QATU,"@E 999,999,999.9999")+'</font>' +CrLf
			ENDIF
			IF ALLTRIM(SB2->B2_LOCAL)==SUBSTR(_aLog[_nX][3],1,2)
				_nVLUNIT:=SB2->B2_CM1
				_nQTDATU:=SB2->B2_QATU
			ENDIF
			SB2->(DBSKIP())
		Enddo
	EndIf
ENDIF
cMsg += CrLf

IF lInvOK ==.T.
	//U_MsgColetor("Inventแrio EFETUADO.")
	cMsg += '<font size="3" face="Arial">Inventario EFETUADO Quantidades Iguais '+'</font>' +CrLf+CrLf
ELSE
	//U_MsgColetor("Inventแrio com quantidades divergente informar a controladoria.")
	cMsg += '<font size="3" face="Arial">Inventario NรO EFETUADO Quantidades Divergente '+'</font>' +CrLf+CrLf
ENDIF

_nQTDAJU :=(_nQTDATU-_nQTDTOT )*(-1)
_nVALAJU :=_nQTDAJU*_nVLUNIT
cMsg += '<font size="3" face="Arial">Quantidade do ajuste '+TransForm(_nQTDAJU,"@E 9,999,999.9999")+'</font>' +CrLf
cMsg += '<font size="3" face="Arial">Valor do ajuste      '+TransForm(_nVALAJU,"@E 9,999,999.9999")+'</font>' +CrLf
cMsg += '<font size="2" face="Arial">Data/Hora do processamento:'+Dtoc(dDataBase)+' เs '+Time()+' hr.</font>' +CrLf+CrLf

cMsg += '<font size="3" face="Arial">Rosenberger Domex</font>' +CrLf
cMsg += '<font size="3" face="Arial">Favor nใo responder. </font>' +CrLf
cMsg += '</body>'+CrLf
cMsg += '</html>'+CrLf

Connect Smtp Server _cServer Account _cAccount PassWord _cPassAut Result lConectou

If _lAutentica
	If !MailAuth(_cUserAut,_cPassAut)
		U_MsgColetor("Falha na Autentica็ใo do Usuแrio")
		Disconnect Smtp Server
		lConectou :=.F.
	EndIf
EndIf

If lConectou
	Send Mail;
	From _cAccount;
	To _cPara;
	Subject AllTrim(_cSubject);
	Body cMsg;
	Result lEnviado
End
Disconnect Smtp Server

Return

*---------------------------------------------------------------------------------------------
Static Function AlertC(cTexto)
*---------------------------------------------------------------------------------------------
Local aTemp := U_QuebraString(cTexto,20)
Local cTemp := ''
Local lRet  := .T.

For x := 1 to Len(aTemp)
	cTemp += aTemp[x] + Chr(13)
Next x

cTemp += 'Continuar?'

If !apMsgNoYes( cTemp )
	lRet:=.F.
EndIf

Return(lRet)

*---------------------------------------------------------------------------------------------
Static Function GuardaEmps(cProduto,cLocal)
*---------------------------------------------------------------------------------------------
aEmpSB2 := {}
SB2->( dbSetOrder(1) )
If SB2->( dbSeek( xFilial("SB2") + cProduto + cLocal ) )
	If !Empty(SB2->B2_QEMP)
		AADD(aEmpSB2,{SB2->(Recno()),SB2->B2_QEMP})
	EndIf
EndIf

aEmpSBF := {}
SBF->( dbSetOrder(2) )
If SBF->( dbSeek( xFilial("SBF") + cProduto + cLocal ) )
	While !SBF->( EOF() ) .and. SBF->BF_FILIAL + SBF->BF_PRODUTO + SBF->BF_LOCAL == xFilial("SBF") + cProduto + cLocal
		If !Empty(SBF->BF_EMPENHO)
			AADD(aEmpSBF,{SBF->(Recno()),SBF->BF_EMPENHO})
		EndIf
		SBF->( dbSkip() )
	End
EndIf

aEmpSB8 := {}
SB8->( dbSetOrder(1) )
If SB8->( dbSeek( xFilial("SB8") + cProduto + cLocal ) )
	While !SB8->( EOF() ) .and. SB8->B8_FILIAL + SB8->B8_PRODUTO + SB8->B8_LOCAL == xFilial("SB8") + cProduto + cLocal
		If !Empty(SB8->B8_EMPENHO)
			AADD(aEmpSB8,{SB8->(()),SB8->B8_EMPENHO})
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

Return

*---------------------------------------------------------------------------------------------
Static Function VoltaEmps()
*---------------------------------------------------------------------------------------------
For x := 1 to Len(aEmpSB2)
	SB2->( dbGoTo(aEmpSB2[x,1]) )
	Reclock("SB2",.F.)
	SB2->B2_QEMP := aEmpSB2[x,2]
	SB2->( msUnlock() )
Next x

Return
