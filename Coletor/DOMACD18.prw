#include "TbiConn.ch"
#include "TbiCode.ch"
#include "rwmake.ch"
#include "TOpconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDOMACD18  บAutor  ณMichel Sander       บ Data ณ  27/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa de inventแrio GERAL ATIVO                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAlterado  ณ ALTERACAO DO PROGRAMA ORIGINAL DOMACD13.PRW                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DOMACD18()

LOCAL   cAliasTMP := GetNextAlias()

PRIVATE cContagem := ""
PRIVATE lAbreEnd  := .F.
PRIVATE dDataInv  := GetMV("MV_XXDTINV")
PRIVATE lContagem := .F.
PRIVATE cContEtq  := SPACE(21)
PRIVATE lValidUsr := .F.
PRIVATE cVldEtiq  := ""
PRIVATE cVldProd  := ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Procura se o usuแrio ้ contador de inventแrio			    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
BEGINSQL Alias cAliasTMP
	
	SELECT P01_CODIGO FROM %table:P01% TMP (NOLOCK)
	WHERE P01_USUCOL = %exp:cUsuario%
	AND   TMP.%NotDel%
	
ENDSQL

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Valida se o usuแrio ้ contador de inventแrio			    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If (cAliasTMP)->(Eof())
	U_MsgColetor('Este usuแrio nใo ้ um contador de inventแrio.')
	(cAliasTMP)->(dbCloseArea())
	Return
EndIf
(cAliasTMP)->(dbCloseArea())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Contagens de inventแrio										    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cContagem := ""
aContagem := {}
AADD(aContagem,'001')
AADD(aContagem,'Etiqueta')

dbSelectArea("SZC")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Tela do Coletor													    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE MSDIALOG oInv TITLE OemToAnsi("Contagem: " ) FROM 0,0 TO 293,233 PIXEL OF oMainWnd PIXEL

nLin := 30
@ nLin, 020	SAY oTexto1 Var 'Informe a contagem:'    SIZE 100,10 PIXEL
oTexto1:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

nLin += 20
@ nLin, 020	SAY oTexto2 Var 'Contagem:'    SIZE 40,10 PIXEL
oTexto2:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)

@ nLin, 060 COMBOBOX oCombo2  VAR cContagem ITEMS aContagem    SIZE 45,10 VALID VLDCONT() PIXEL
oCombo1:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
nLin += 20

@ nLin, 020 SAY oTexto2 Var "Etiqueta" SIZE 100,10 PIXEL
oTexto2:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
nLin += 10

@ nLin,020 MSGET oGetCont Var cContEtq WHEN lContagem VALID VLDSZI() Size 080,10 Pixel
oGetCont:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
nLin += 40

@ nLin, 10 BUTTON "Confirmar" ACTION Processa( {|| oInv:End()} ) SIZE nLargBut,nAltuBut PIXEL OF oInv

ACTIVATE MSDIALOG oInv

If cContagem == '001'
	cContagem := '002'
	lValidUsr := .T.
Endif

If cContagem == 'Etiqueta' .and. !lValidUsr
	U_MsgColetor("Etiqueta invแlida.")
EndIf

If !lValidUsr
	Return
EndIf

PRIVATE oTxtEnd,oGetEnd,oTxtEtiq,oGetEtiq,oTxtProd,oGetProd,oTxtQtd,oGetQtd,oMark
PRIVATE _nTamEtiq      := 21
PRIVATE cEndereco     := Space(Len(CriaVar("BE_LOCALIZ",.F.))+3)
PRIVATE cEtiqueta      := Space(_nTamEtiq)//Space(Len(CriaVar("XD1_XXPECA",.F.)))
PRIVATE _cProduto      := CriaVar("B1_COD",.F.)
PRIVATE _nQtd          := CriaVar("XD1_QTDATU",.F.)
PRIVATE _cLoteEti      := CriaVar("BF_LOTECTL",.F.)
PRIVATE _aCols         := {}
PRIVATE _cParametro    := "MV_XXNUMIN"
PRIVATE _cCtrNum       := GetNewPar(_cParametro,"")
PRIVATE _lAuto	        := .T.
PRIVATE _lIndividual   := .F.
PRIVATE _cDocInv
PRIVATE _nTamDoc       := Len(CriaVar("B7_DOC",.F.))
PRIVATE aEmpSB2
PRIVATE _aLog
PRIVATE cUltEti1       := '_____________'
PRIVATE cUltEti2       := '_____________'
PRIVATE cUltEti3       := '_____________'
PRIVATE oUltEti1
PRIVATE oUltEti2
PRIVATE oUltEti3
PRIVATE aEtiqProd
PRIVATE _cProdAnt      := ""
PRIVATE nContad        := 0
PRIVATE cLocCQ         := GetMV("MV_CQ")

XD1->( dbSetOrder(1) )
SB1->( dbSetOrder(1) )

If! Empty(_cCtrNum)
	fOkTela()
Else
	U_MsgColetor("Verifique o parโmetro "+_cParametro)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVLDCONT   บAutor  ณMichel Sander       บ Data ณ  27/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida็ใo da escolha de contagem                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VldCont()

If cContagem == 'Etiqueta'
	lContagem := .T.
Else
	lContagem := .F.
Endif

oGetCont:SetFocus()

Return ( .T. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVLDSZI    บAutor  ณMichel Sander       บ Data ณ  27/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida็ใo de etiqueta no XD1	                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VLDSZI()
Local _Retorno  := .T.
LOCAL cAliasSZI := GetNextAlias()
LOCAL cUsoCont  := ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Procura se o usuแrio ้ contador de inventแrio			    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If !Empty(cContEtq)
	If Select(cAliasSZI) <> 0
		(cAliasSZI)->(dbCloseArea())
	EndIf
	
	cContEtq2 := "%'%"+Alltrim(cContEtq)+"%'%"
	sDataInv  := DtoS(dDataInv)
	
	BEGINSQL Alias cAliasSZI
		SELECT * FROM %table:SZI% SZI (NOLOCK)
		WHERE ZI_ETIQUET LIKE %exp:cContEtq2%
		AND   ZI_DATA = %exp:sDataInv%
		AND   SZI.%NotDel%
	ENDSQL
	
	//cQuery := "SELECT * FROM SZI010 SZI (NOLOCK) WHERE ZI_ETIQUET LIKE %exp:cContEtq2% AND D_E_L_E_T_ = '' "
	
	If (cAliasSZI)->(Eof())
		U_MsgColetor('Etiqueta invแlida.')
		cContEtq := Space(21)
		oGetCont:Refresh()
		(cAliasSZI)->(dbCloseArea())
		Return ( .F. )
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Valida se o usuแrio ้ contador de inventแrio			    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If (cAliasSZI)->ZI_STATLIN == 'C' .or. (cAliasSZI)->ZI_STATLIN == 'E'
		If (cAliasSZI)->ZI_STATLIN == 'C' //Nova contagem de produto
			
			dbselectarea(cAliasSZI)
			aNaoPode := {}
			For x := 2 to 20
				If Type("ZI_CON"+StrZero(x,3)) <> 'U'
					If !Empty(&("ZI_CON" + StrZero(x,3)))
						AADD(aNaoPode,&("ZI_USU" + StrZero(x,3)))
					EndIf
				EndIf
			Next x
			
			If ASCAN(aNaoPode,cUsuario) > 0
				cUsuCont := aNaoPode[ASCAN(aNaoPode,cUsuario)]
			Else
				cUsuCont := ""
			EndIf
			
			If ALLTRIM(cUsuario) == ALLTRIM(cUsuCont)
				U_MsgColetor("O usuแrio desta nova contagem nใo dever ser " + Alltrim(cUsuCont) + ".")
				cContEtq := Space(21)
			Else
				lValidUsr := .T.
				cVldEtiq  := ""
				cVldProd  := (cAliasSZI)->ZI_PRODUTO
				cContagem := (cAliasSZI)->ZI_CONTAGE
			EndIf
			
		EndIf
		
		If (cAliasSZI)->ZI_STATLIN == 'E' //Nova recontagem de etiqueta
			
			nTemp := At( Alltrim(cContEtq) , (cAliasSZI)->ZI_ETIQUET )
			dbselectarea(cAliasSZI)
			cUsuCont := &("ZI_USU"+Subs(ZI_ETIQUET,nTemp+7,3))
			
			If ALLTRIM(cUsuario) <> ALLTRIM(cUsuCont)
				U_MsgColetor("O usuแrio desta recontagem dever ser " + Alltrim(cUsuCont) + ".")
				cContEtq := Space(21)
			Else
				lValidUsr := .T.
				cVldEtiq  := (cAliasSZI)->ZI_XXPECA
				cVldProd  := ""
				cContagem := (cAliasSZI)->ZI_CONTAGE
			EndIf
			
		EndIf
	Else
		U_MsgColetor("Recontagem/Nova Contagem jแ realizada.")
		cContEtq := Space(21)
	EndIf
	(cAliasSZI)->(dbCloseArea())
	
EndIf

Return ( _Retorno )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  fOkTela    บAutor  ณHelio Ferreira      บ Data ณ  27/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela de contagem do inventแrio por coleta                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fOkTela()

_aCols:={}

DEFINE MSDIALOG oInv TITLE OemToAnsi("Inventแrio GERAL " + DtoC(GetMV("MV_XXDTINV"))) FROM 0,0 TO 293,233 PIXEL OF oMainWnd PIXEL

@ 005,005 Say oTxtEnd    Var "Endere็o " Pixel Of oInv
@ 005,045 MsGet oGetEnd  Var cEndereco Valid ValidEnd() Size 70,10 Pixel Of oInv
oTxtEnd:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
oGetEnd:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

@ 020,005 Say oTxtEtiq   Var "Etiqueta " Pixel Of oInv
@ 020,045 MsGet oGetEtiq Var cEtiqueta  Size 70,10 Valid ValidEtiq() Pixel Of oInv
oTxtEtiq:oFont:= TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
oGetEtiq:oFont:= TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

@ 035,005 Say oTxtProd   Var "Produto "  Pixel Of oInv
@ 035,045 MsGet oGetProd Var _cProduto When .F. Size 70,10  Pixel Of oInv
oTxtProd:oFont:= TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
oGetProd:oFont:= TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

@ 050,005 Say oTxtQtd    Var "Quantidade " Pixel Of oInv
@ 050,045 MsGet oGetQtd  Var _nQtd Valid ValidQtd()      Picture "@E 9,999,999.9999" Size 70,10  Pixel Of oInv
oTxtQtd:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
oGetQtd:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

@ 065,005 Say oTxtEnd    Var "Ultimas Etiquetas" Pixel Of oInv
oTxtEnd:oFont:= TFont():New('Arial',,17,,.T.,,,,.T.,.F.)

@ 075,005 Say oUltEti1   Var cUltEti1         Pixel Of oInv
oUltEti1:oFont:= TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
@ 085,005 Say oUltEti2   Var cUltEti2         Pixel Of oInv
oUltEti2:oFont:= TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
@ 095,005 Say oUltEti3   Var cUltEti3         Pixel Of oInv
oUltEti3:oFont:= TFont():New('Arial',,17,,.T.,,,,.T.,.F.)

@ 110,050 Say oContad   Var Transform(nContad,"@E 999,999")  Size 70,20       Pixel Of oInv
oContad:oFont:= TFont():New('courier',,35,,.T.,,,,.T.,.F.)

@ 130,070 Button "Sair" Size 40,15 Action Close(oInv) Pixel Of oInv

ACTIVATE MSDIALOG oInv                               '

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ValidEnd   บAutor  ณHelio Ferreira      บ Data ณ  27/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida็ใo do Endere็o						                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidEnd()

Local _lRet := .T.

SBE->( dbSetOrder(1) )
If SBE->( dbSeek( xFilial() + Subs(cEndereco,1,17)) )
	If SBE->BE_MSBLQL == '1'
		_lRet := .F.
		U_MsgColetor('Endere็o bloqueado para uso.')
	Else
		aEtiqProd := {}
		lAbreEnd  := .T.
		nContad   := 0
	EndIf
Else
	_lRet := .F.
	U_MsgColetor('Endere็o nใo encontrado.')
	lAbreEnd := .F.
EndIf

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ValidEtiq  บAutor  ณHelio Ferreira      บ Data ณ  27/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida็ใo da Etiqueta						                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidEtiq()

Local _lRet   :=.T.
Local _nSaldoSDA := 0

If dDataBase <> Date()
	dDataBase := Date()
EndIf

If Len(AllTrim(cEtiqueta)) == 12 //EAN 13 s/ dํgito verificador.
	cEtiqueta := Subs(cEtiqueta,1,11) + "X "
EndIf

If Len(AllTrim(cEtiqueta))==20 //CODE 128 c/ dํgito verificador.
	cEtiqueta := Subs(AllTrim(cEtiqueta),8,12)
EndIf

If Subs(cUltEti1,1,12) == "0"+Subs(cEtiqueta,1,11)
	U_MsgColetor("Etiqueta registrada anteriormente.      Informe a quantidade da embalagem       manualmente.")
	lAbreEnd := .F.
	Return _lRet
EndIf

oGetEtiq:Refresh()

If !Empty(cEndereco)
	If !Empty(cEtiqueta)
		If XD1->( dbSeek( xFilial() + Subs("0"+cEtiqueta,1,12) ) )
			
			If !Empty(cVldEtiq)
				If cVldEtiq <> XD1->XD1_XXPECA
					U_MsgColetor("Recontagem de etiqueta nใo autorizada.")
					cEtiqueta:= Space(_nTamEtiq)
					_cProduto := CriaVar("B1_COD",.F.)
					oGetProd:Refresh()
					oGetEtiq  :Refresh()
					oGetEtiq  :SetFocus()
					lAbreEnd  := .F.
					Return .F.
				EndIf
			EndIf
			
			If !Empty(cVldProd)
				If cVldProd <> XD1->XD1_COD
					U_MsgColetor("Recontagem de produto nใo autorizada.")
					cEtiqueta:= Space(_nTamEtiq)
					_cProduto := CriaVar("B1_COD",.F.)
					oGetEtiq  :Refresh()
					oGetEtiq  :SetFocus()
					oGetProd:Refresh()
					lAbreEnd  := .F.
					Return .F.
				EndIf
			EndIf
			
			If _cProduto <> XD1->XD1_COD .And. !Empty(_cProduto)
				U_MsgColetor("Na mudan็a de produtos ้ obrigat๓rio bipar novamente o endere็o. Etiqueta nใo registrada!")
				cEndereco := Space(Len(CriaVar("BE_LOCALIZ",.F.))+3)
				cEtiqueta := SPACE(_nTamEtiq)
				_cProduto := CriaVar("B1_COD",.F.)
				oGetEtiq  :Refresh()
				oGetProd  :Refresh()
				oGetEnd:SetFocus()
				lAbreEnd  := .F.
				Return .T.
			EndIf
			
			// Comentado Por Michel Sander em 08.12.2015 para corrigir falha de coleta na mudan็a de produto
			/*				If !lAbreEnd
			U_MsgColetor("Na mudan็a de produtos ้ obrigat๓rio bipar novamente o endere็o. Etiqueta nใo registrada!")
			cEndereco := Space(Len(CriaVar("BE_LOCALIZ",.F.))+3)
			cEtiqueta := SPACE(_nTamEtiq)
			_cProduto := CriaVar("B1_COD",.F.)
			oGetEtiq  :Refresh()
			oGetProd  :Refresh()
			oGetEtiq  :SetFocus()
			oGetEnd:SetFocus()
			lAbreEnd  := .F.
			Return .T.
			Else
			lAbreEnd := .F.
			EndIf
			*/
			
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Procura se o usuแrio ้ contador de inventแrio			    ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			cAliasUsu := GetNextAlias()
			BEGINSQL Alias cAliasUsu
				SELECT * FROM %table:P01% P01 (NOLOCK)
				WHERE P01_USUCOL = %exp:cUsuario%
				AND   P01.%NotDel%
			ENDSQL
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Busca a equipe do contador de inventแrio					    ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			cAliasEqu := GetNextAlias()
			cEquiCon  := '%'+(cAliasUsu)->P01_CODIGO+'%'
			BEGINSQL Alias cAliasEqu
				SELECT * FROM %table:P03% P03 (NOLOCK)
				WHERE P03_CODCON = %exp:cEquiCon%
				AND   P03.%NotDel%
			ENDSQL
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Verifica se o produto esta associado a equipe de contagemณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			P04->(dbSetOrder(1))
			If !P04->(dbSeek(xFilial("P04")+XD1->XD1_COD))
				U_MsgColetor("Produto nใo possui equipe de inventแrio associada.")
				cEndereco := Space(Len(CriaVar("BE_LOCALIZ",.F.))+3)
				cEtiqueta := SPACE(_nTamEtiq)
				_cProduto := CriaVar("B1_COD",.F.)
				oGetEtiq  :Refresh()
				oGetProd:Refresh()
				oGetEtiq  :SetFocus()
				oGetEnd:SetFocus()
				(cAliasUsu)->(dbCloseArea())
				(cAliasEqu)->(dbCloseArea())
				lAbreEnd := .F.
				Return .T.
			Else
				If P04->P04_CODEQU <> (cAliasEqu)->P03_CODIGO
					P03->(dbSeek(xFilial("P03")+P04->P04_CODEQU))
					U_MsgColetor("Esse produto pertence a equipe de       inventแrio "+P03->P03_NOME)
					cEndereco := Space(Len(CriaVar("BE_LOCALIZ",.F.))+3)
					cEtiqueta := SPACE(_nTamEtiq)
					_cProduto := CriaVar("B1_COD",.F.)
					oGetEtiq  :Refresh()
					oGetProd  :Refresh()
					oGetEtiq  :SetFocus()
					oGetEnd:SetFocus()
					(cAliasUsu)->(dbCloseArea())
					(cAliasEqu)->(dbCloseArea())
					lAbreEnd := .F.
					Return .T.
				EndIf
			EndIf
			
			(cAliasUsu)->(dbCloseArea())
			(cAliasEqu)->(dbCloseArea())
			_cProduto := XD1->XD1_COD
			
			If SB1->( dbSeek( xFilial() + _cProduto) )
				If SB1->B1_LOCALIZ == 'S'
					
					cQuery := "SELECT SUM(DA_SALDO) AS DA_SALDO FROM SDA010 WHERE DA_FILIAL = '"+xFilial("SDA")+"' AND DA_PRODUTO = '"+_cProduto+"' AND DA_LOCAL = '"+SubStr(cEndereco,1,2)+"' AND D_E_L_E_T_ = '' "
					
					If Select("TEMP") <> 0
						TEMP->( dbCloseArea() )
					EndIf
					
					TCQUERY cQuery NEW ALIAS "TEMP"
					
					_nSaldoSDA := TEMP->DA_SALDO
					
					//If SB2->( dbSeek( xFilial() + _cProduto + SubStr(cEndereco,1,2)  ) )
					//	_nSaldoSDA := SB2->B2_QACLASS
					//Else
					//	_nSaldoSDA := 0
					//EndIf
					
					If SB2->( dbSeek( xFilial() + _cProduto + cLocCQ  ) )
						_nSaldoCQ := SB2->B2_QATU
					Else
						_nSaldoCQ := 0
					EndIf
					
					If _nSaldoCQ == 0
						If _nSaldoSDA == 0
							If XD1->XD1_QTDATU <= 0
								_nQtd := 0
							Else
								
								//If cUltEti1 <> XD1->XD1_XXPECA
								//If !Empty(cUltEti1) .and. cUltEti1 <> '_____________'
								
								//If Int(_nQtd) <> _nQtd
								//	U_MsgColetor("Quantidade digitada com casas decimais!!!")
								//EndIf
								
								//XD1->( dbSeek( xFilial() + Subs(cUltEti1,1,13) ) )
								If SZC->( dbSeek( xFilial() + DtoS(dDataInv) + Subs("0"+cEtiqueta,1,12) + ' ' + cContagem ) )
									Reclock("SZC",.F.)
									SZC->ZC_CONTADO += 1
									If XD1->XD1_QTDATU <> SZC->ZC_QUANT
										U_MsgColetor("Embalagem inventariada anteriormente com " + Alltrim(Transform(SZC->ZC_QUANT,"@E 999,999,999.99")) + " e alterada agora para " + Alltrim(Transform(XD1->XD1_QTDATU,"@E 999,999,999.99")) )
									EndIf
									SZC->ZC_PRODUTO := XD1->XD1_COD
									SZC->ZC_LOCAL   := SubStr(cEndereco,1,2)
									SZC->ZC_LOCALIZ := SubStr(cEndereco,3)
									If SB1->B1_RASTRO == 'L'
										SZC->ZC_LOTECTL := If(!Empty(XD1->XD1_LOTECTL),XD1->XD1_LOTECTL,'LOTE1308')
									EndIf
									SZC->ZC_HORA    := Time()
									SZC->ZC_QUANT   := _nQtd
									
									SZC->ZC_QUANT   := XD1->XD1_QTDATU
									SZC->( msUnlock() )
								Else
									Reclock("SZC",.T.)
									SZC->ZC_FILIAL  := xFilial("SZC")
									SZC->ZC_DATA    := dDataBase
									SZC->ZC_DATAINV := dDataInv
									SZC->ZC_XXPECA  := XD1->XD1_XXPECA
									SZC->ZC_PRODUTO := XD1->XD1_COD
									SZC->ZC_LOCAL   := SubStr(cEndereco,1,2)
									SZC->ZC_LOCALIZ := SubStr(cEndereco,3)
									If SB1->B1_RASTRO == 'L'
										SZC->ZC_LOTECTL := If(!Empty(XD1->XD1_LOTECTL),XD1->XD1_LOTECTL,'LOTE1308')
									EndIf
									SZC->ZC_HORA    := Time()
									SZC->ZC_QUANT   := XD1->XD1_QTDATU
									SZC->ZC_CONTADO := 1
									SZC->ZC_USUARIO := cUsuario
									SZC->ZC_CONTAGE := cContagem
									SZC->( msUnlock() )
								EndIf
								
								//EndIf
								
								AtuHist()
								
								//If _cProdAnt <> _cProduto
								//	_cProdAnt := _cProduto
								//	aEtiqProd := {}
								//	AADD(aEtiqProd,XD1->XD1_XXPECA)
								//	nContad := 1
								//Else
								If aScan(aEtiqProd,XD1->XD1_XXPECA) == 0
									AADD(aEtiqProd,XD1->XD1_XXPECA)
									nContad++
								EndIf
								//EndIf
								//EndIf
								
								oContad:Refresh()
								
								_cProduto := SB1->B1_COD
								_nQtd     := XD1->XD1_QTDATU
							EndIf
							
							//oGetQtd :SetFocus()
							//oGetEtiq  :SetFocus()
						Else
							_lRet := .F.
							U_MsgColetor("ATENวรO existe saldo a endere็ar. Nใo ้ possํvel inventariar produtos com pend๊ncias de endere็amento.")
						EndIf
					Else
						_lRet := .F.
						U_MsgColetor("ATENวรO existe saldo pendente de libera็ใo na Qualidade (CQ). Nใo ้ possํvel inventariar produtos com pend๊ncias de libera็ใo no CQ.")
					EndIf
				Else
					_lRet:=.F.
					U_MsgColetor("Produto sem controle por endere็o.")
				EndIf
			Else
				_lRet:=.F.
				U_MsgColetor("Produto NรO encontrado")
			EndIf
		Else
			_lRet:=.F.
			U_MsgColetor("Etiqueta nใo encontrada.")
		EndIf
	Else
		
	EndIf
Else
	_lRet:=.F.
	U_MsgColetor("Endere็o nใo preenchido.")
EndIf

If !_lRet
	cEtiqueta:= Space(_nTamEtiq)
	_cProduto := CriaVar("B1_COD",.F.)
	oGetEtiq  :Refresh()
	oGetEtiq  :SetFocus()
Else
	//oGetEtiq :Refresh()
	If !Empty(_nQtd)
		If !Empty(cEtiqueta)
			//cEtiqueta := Space(_nTamEtiq)
			//oGetEtiq   :Refresh()
			oGetEtiq   :SetFocus()
		EndIf
	Else
		If !Empty(cEtiqueta)
			U_MsgColetor("Etiqueta com quantidade zero. Informe a quantidade.")
			oGetQtd :SetFocus()
		EndIf
	EndIf
	//oGetQtd :Refresh()
EndIf

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  AltertC   บAutor  ณHelio Ferreira      บ Data ณ  27/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo de Alert do coletor  				                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AlertC(cTexto)

Local aTemp := U_QuebraString(cTexto,20)
Local cTemp := ''
Local lRet  := .T.

For x := 1 to Len(aTemp)
	cTemp += aTemp[x] + Chr(13)
Next x

cTemp += 'Continuar?'

While !apMsgNoYes( cTemp )
	//lRet:=.F.
End

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  fGravaUltima  บAutor  ณHelio Ferreira   บ Data ณ  27/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava็ใo de dados do inventแrio			                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGravaUltima()

If !Empty(cUltEti1) .and. cUltEti1 <> '_____________'
	If _nQtd <= 0
		U_MsgColetor("Quantidade da embalagem nใo pode ser menor ou igual a zero.")
		Return .T.
	EndIf
	
	If Int(_nQtd) <> _nQtd
		U_MsgColetor("Quantidade digitada com casas decimais!!!")
	EndIf
	
	XD1->( dbSeek( xFilial() + Subs(cUltEti1,1,13) ) )
	
	If SB1->( dbSeek( xFilial() + XD1->XD1_COD) )
		If SZC->( dbSeek( xFilial() + DtoS(dDataInv) + Subs(cUltEti1,1,13) + cContagem ) )
			Reclock("SZC",.F.)
			SZC->ZC_CONTADO += 1
			If _nQtd <> SZC->ZC_QUANT
				U_MsgColetor("Embalagem inventariada anteriormente com " + Alltrim(Transform(SZC->ZC_QUANT,"@E 999,999,999.99")) + " e alterada agora para " + Alltrim(Transform(_nQtd,"@E 999,999,999.99")) )
			EndIf
			SZC->ZC_PRODUTO := XD1->XD1_COD
			SZC->ZC_LOCAL   := SubStr(cEndereco,1,2)
			SZC->ZC_LOCALIZ := SubStr(cEndereco,3)
			If SB1->B1_RASTRO == 'L'
				SZC->ZC_LOTECTL := If(!Empty(XD1->XD1_LOTECTL),XD1->XD1_LOTECTL,'LOTE1308')
			EndIf
			SZC->ZC_HORA    := Time()
			SZC->ZC_QUANT   := _nQtd
			
			SZC->ZC_QUANT := _nQtd
			SZC->( msUnlock() )
		Else
			Reclock("SZC",.T.)
			SZC->ZC_FILIAL  := xFilial("SZC")
			SZC->ZC_DATA    := dDataBase
			SZC->ZC_DATAINV := dDataInv
			SZC->ZC_XXPECA  := XD1->XD1_XXPECA
			SZC->ZC_PRODUTO := XD1->XD1_COD
			SZC->ZC_LOCAL   := SubStr(cEndereco,1,2)
			SZC->ZC_LOCALIZ := SubStr(cEndereco,3)
			If SB1->B1_RASTRO == 'L'
				SZC->ZC_LOTECTL := If(!Empty(XD1->XD1_LOTECTL),XD1->XD1_LOTECTL,'LOTE1308')
			EndIf
			SZC->ZC_HORA    := Time()
			SZC->ZC_QUANT   := _nQtd
			SZC->ZC_CONTADO := 1
			SZC->ZC_USUARIO := cUsuario
			SZC->ZC_CONTAGE := cContagem
			SZC->( msUnlock() )
		EndIf
	EndIf
	
	cUltEti1 := cUltEti1 + " - Ok - " + SZC->ZC_USUARIO
	
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  fB2QACLASS บAutor  ณHelio Ferreira      บ Data ณ  27/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava็ใo de QACLASS no Sb2  				                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fB2QACLASS()

SB2->( dbGoTop() )

While ! SB2->( EOF() )
	cQuery := "SELECT SUM(DA_SALDO) AS DA_SALDO FROM SDA010 WHERE DA_FILIAL = '"+xFilial("SDA")+"' AND DA_PRODUTO = '"+SB2->B2_COD+"' AND DA_LOCAL = '"+SB2->B2_LOCAL+"' AND D_E_L_E_T_ = '' "
	If Select("TEMP") <> 0
		TEMP->( dbCloseArea() )
	EndIf
	TCQUERY cQuery NEW ALIAS "TEMP"
	If TEMP->DA_SALDO <> SB2->B2_QACLASS
		Reclock("SB2",.F.)
		SB2->B2_QACLASS := TEMP->DA_SALDO
		SB2->( msUnlock() )
	EndIf
	SB2->( dbSkip() )
End

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ValidQtd   บAutor  ณHelio Ferreira      บ Data ณ  27/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida quantidade				  				                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidQtd()

Local _Retorno := .T.

If _nQtd > 0
	//XD1->( dbSeek( xFilial() + Subs(cEtiqueta,1,13) ) )
	
	If SB1->( dbSeek( xFilial() + XD1->XD1_COD ) )
		If SZC->( dbSeek( xFilial() + DtoS(dDataInv) + "0" + Subs(cEtiqueta,1,11) + " " + cContagem ) )
			Reclock("SZC",.F.)
			SZC->ZC_CONTADO += 1
			If _nQtd <> SZC->ZC_QUANT
				U_MsgColetor("Embalagem inventariada anteriormente com " + Alltrim(Transform(SZC->ZC_QUANT,"@E 999,999,999.99")) + " e alterada agora para " + Alltrim(Transform(_nQtd,"@E 999,999,999.99")) )
			EndIf
			SZC->ZC_PRODUTO := XD1->XD1_COD
			SZC->ZC_LOCAL   := SubStr(cEndereco,1,2)
			SZC->ZC_LOCALIZ := SubStr(cEndereco,3)
			If SB1->B1_RASTRO == 'L'
				SZC->ZC_LOTECTL := If(!Empty(XD1->XD1_LOTECTL),XD1->XD1_LOTECTL,'LOTE1308')
			EndIf
			SZC->ZC_HORA    := Time()
			SZC->ZC_QUANT   := _nQtd
			//SZC->ZC_USUARIO := cUsuario
			SZC->ZC_QUANT   := _nQtd
			SZC->( msUnlock() )
		Else
			Reclock("SZC",.T.)
			SZC->ZC_FILIAL  := xFilial("SZC")
			SZC->ZC_DATA    := dDataBase
			SZC->ZC_DATAINV := dDataInv
			SZC->ZC_XXPECA  := XD1->XD1_XXPECA
			SZC->ZC_PRODUTO := XD1->XD1_COD
			SZC->ZC_LOCAL   := SubStr(cEndereco,1,2)
			SZC->ZC_LOCALIZ := SubStr(cEndereco,3)
			If SB1->B1_RASTRO == 'L'
				SZC->ZC_LOTECTL := If(!Empty(XD1->XD1_LOTECTL),XD1->XD1_LOTECTL,'LOTE1308')
			EndIf
			SZC->ZC_HORA    := Time()
			SZC->ZC_QUANT   := _nQtd
			SZC->ZC_CONTADO := 1
			SZC->ZC_USUARIO := cUsuario
			SZC->ZC_CONTAGE := cContagem
			SZC->( msUnlock() )
		EndIf
	EndIf
	
	AtuHist()
	
	If aScan(aEtiqProd,XD1->XD1_XXPECA) == 0
		AADD(aEtiqProd,XD1->XD1_XXPECA)
		nContad++
	EndIf
	
	oContad:Refresh()
	
	//cEtiqueta := Subs(cEtiqueta,2,11)+"X"
	oGetEtiq:SetFocus()
Else
	If !Empty(cEtiqueta)
		U_MsgColetor("Quantidade invแlida.")
		_Retorno := .F.
	EndIf
EndIf

Return _Retorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  AtuHist    บAutor  ณHelio Ferreira      บ Data ณ  27/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo de atualiza็ใo do historico		                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AtuHist()

If Subs(cUltEti1,1,12) == Subs(XD1->XD1_XXPECA,1,12)
	Return
EndIf

XD1->( dbSeek( xFilial() + Subs("0"+cEtiqueta,1,12) ) )

cUltEti3 := Subs(cUltEti2,1,13)
cUltEti2 := Subs(cUltEti1,1,13)
cUltEti1 := Subs(XD1->XD1_XXPECA,1,13)

If SZC->( dbSeek( xFilial() + DtoS(dDataInv) + Subs(cUltEti3,1,13) + cContagem  ) )
	If !Empty(cUltEti3)
		cUltEti3 := cUltEti3 + " - Ok - " + SZC->ZC_USUARIO
	EndIf
EndIf

If SZC->( dbSeek( xFilial() + DtoS(dDataInv) + Subs(cUltEti2,1,13) + cContagem ) )
	If !Empty(cUltEti2)
		cUltEti2 := cUltEti2 + " - Ok - " + SZC->ZC_USUARIO
	EndIf
EndIf

If SZC->( dbSeek( xFilial() + DtoS(dDataInv) + Subs(cUltEti1,1,13)  + cContagem ) )
	If !Empty(cUltEti1) .and. cUltEti1 <> '_____________'
		cUltEti1 := cUltEti1 + " - Ok - " + SZC->ZC_USUARIO
		//oSButton := SButton():Create(oInv, 74, 55, 5, {|| fGravaUltima() }, .T., 'Msg', {||.T.})
		//oSButton:End()
	EndIf
Else
	//@ 074,055 Button "Gravar" Size 30,10 Action fGravaUltima() Pixel Of oInv
	//oSButton := SButton():Create(oInv, 74, 55, 5, {||fGravaUltima() }, .T., 'Msg', {||.T.})
EndIf

oUltEti3:Refresh()
oUltEti2:Refresh()
oUltEti1:Refresh()

Return
