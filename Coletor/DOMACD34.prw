#include "TbiConn.ch"
#include "TbiCode.ch"
#include "Rwmake.ch"
#include "Topconn.ch"
#include "Protheus.ch"
#Include "ap5mail.ch"

//Fonte para montagem de KIT de Obra
User Function DOMACD34()

Private oMainWnd, oMontKit, oTxtOp, oGetOp, oTxtVolume, oGetVolume, oMark
Private cOp	      := Space(11)
Private nVolume   := 0
Private lPrimeiro := .T.
Private nQtdTot   := 0
Private aCols     := {}
Private oGet

DEFINE MSDIALOG oMontKit TITLE OemToAnsi("Montagem de Kit") FROM 0,0 TO 293,233 PIXEL OF oMainWnd PIXEL

@ 001,005 Say oTxtOp	Var "OP:"	Pixel Of oMontKit
@ 001,045 MsGet oGetOP	Var	cOp	When .T. Size 70,10 Valid ValidaOp() Pixel Of oMontKit

oTxtOp:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
oGetOp:oFont := TFont():New("Arial",,20,,.T.,,,,.T.,.F.)

@ 016,005 Say oTxtVolume Var "Volumes:" Pixel Of oMontKit
@ 016,045 MsGet oGetVolume Var nVolume  Size 70,10 Valid ValidaVol() Picture "@E 99" Pixel Of oMontKit
oTxtVolume:oFont:= TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
oGetVolumes:oFont:= TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

fGetDados()

@ 130,005 Button "Sair" Size 40,15 Action oMontKit:End() Pixel Of oMontKit
@ 130,075 Button "Etiqueta" Size 40,15 Action fOkProc() Pixel Of oMontKit

ACTIVATE MSDIALOG oMontKit






Return



Static Function fGetDados()
/*
Local aStru  	:= {}
Local aCampos 	:= {}
Local cArqTrab  := ""

If Select("TMP") > 0
TMP->(dbCloseArea())
EndIf

AADD(aStru, {"ETIQ"   ,"C",15,0} )
AADD(aStru, {"VOL"    ,"C",05,0} )
AADD(aStru, {"PESO"   ,"N",05,2} )

cArqTrab := CriaTrab(aStru,.T.)

dbUseArea(.T.,__LocalDriver,cArqTrab,"TMP",.F.)

IndRegua("TMP",cArqTrab,"ETIQ",,,)

aCampos := {}

AADD(aCampos,{"ETIQ"        ,"" ,"Etiqueta"      ,"@R"              } )
AADD(aCampos,{"VOL"         ,"" ,"Vol."        	 ,"@!"              } )
AADD(aCampos,{"PESO"        ,"" ,"Peso"          ,"@E 999.99"  		} )

oMark:= MsSelect():New("TMP",,,aCampos,Nil,Nil,{46,00,127,117})
oMark:oFont:= TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
oMark:oBrowse:oFont:= TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
oMark:oBrowse:Refresh()

dbSelectArea("TMP")
dbGotop()
*/

cGetOpc        := Nil                        // GD_INSERT+GD_DELETE+GD_UPDATE
cLinhaOk       := "AllwaysTrue"	   			// Funcao executada para validar o contexto da linha atual do aCols
cTudoOk        := "AllwaysTrue"   				// Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
cIniCpos       := Nil                        // Nome dos campos do tipo caracter que utilizarao incremento automatico.
nFreeze        := Nil                        // Campos estaticos na GetDados.
nMax           := 99999                      // Numero maximo de linhas permitidas. Valor padrao 99
cCampoOk       := "AllwaysTrue"   				// Funcao executada na validacao do campo
cSuperApagar   := Nil                        // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
cApagaOk       := Nil                        // Funcao executada para validar a exclusao de uma linha do aCols

aHeader := {}
aCols   := {}

//            X3_TITULO    , X3_CAMPO      , X3_PICTURE          ,  X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO        , X3_TIPO , X3_F3   , X3_CONTEXT , X3_CBOX            , X3_RELACAO ,X3_WHEN                       ,X3_VISUAL, X3_VLDUSER                    , X3_PICTVAR, X3_OBRIGAT
aAdd(aHeader,{"Etiqueta"   ,"ETIQ"         ,"@R"                 ,          11,          0, ""      , "€€€€€€€€€€€€€€", "C"     , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHeader,{"Vol."       ,"VOL"          ,"@!"                 ,          02,          0, ""      , "€€€€€€€€€€€€€€", "N"     , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHeader,{"Peso"       ,"PESO"         ,"@E 999.99"          ,          06,          2, ""      , "€€€€€€€€€€€€€€", "N"     , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })

/*
For x:=1 To Len(aHeadCpos)
cX3_Descr := fX3Ret(aHeadCpos[x],"X3_TITULO" )
cX3_Campo := fX3Ret(aHeadCpos[x],"X3_CAMPO"  )
cX3_Tipo  := fX3Ret(aHeadCpos[x],"X3_TIPO"   )
cX3_Pictu := fX3Ret(aHeadCpos[x],"X3_PICTURE")
nX3_Tam01 := fX3Ret(aHeadCpos[x],"X3_TAMANHO")
nX3_Tam02 := fX3Ret(aHeadCpos[x],"X3_DECIMAL")
cX3_CbBox := fX3Ret(aHeadCpos[x],"X3_CBOX"   )
aAdd(aHead,{cX3_Descr,cX3_Campo      ,cX3_Pictu            ,   nX3_Tam01,  nX3_Tam02, ""      , "€€€€€€€€€€€€€€", cX3_Tipo, ""      , "R"        , cX3_CbBox          , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
Next x
*/

oGet := MsNewGetDados():New( 040, 000, 127, 117,cGetOpc,cLinhaOk,cTudoOk,cIniCpos,{"PRVFAT"},nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oMontKit,aHeader,aCols)

fCarGet()

Return

Static Function fOkProc()

//Gera Etiqueta
Private oMainWnd, oEtiqPeso, oTxtPeso, oGetPeso
Private nPeso	:= 0

If nVolume == Len(aCols)
	U_MsgColetor("Processo já finalizado.")
	Return
EndIf

DEFINE MSDIALOG oEtiqPeso TITLE OemToAnsi("Peso") FROM 90,0 TO 180,233 PIXEL OF oMainWnd PIXEL

@ 001,005 Say oTxtPeso	Var "PESO:"	Pixel Of oEtiqPeso

oTxtPeso:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)

@ 012,005 MsGet oGetPeso Var nPeso  Size 110,10 Valid .T. Picture "@R 999,999.99" Pixel Of oEtiqPeso

oGetPeso:oFont:= TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

@ 028,072 Button "Confirmar" Size 40,15 Action fGeraEtiqueta() Pixel Of oEtiqPeso

ACTIVATE MSDIALOG oEtiqPeso

Return

Static Function fGeraEtiqueta()

Local lRetEtq := .F.

If nPeso == 0
	U_MsgColetor("Deve-se informar o peso do volume.")
	oGetPeso:SetFocus()
	Return
EndIf

oEtiqPeso:End()

//Layout 90 - Por Michel A. Sander
/*
RecLock("TMP",.T.)
TMP->PESO := nPeso
TMP->(MsUnlock())

nQtd := 0
If nVolume == TMP->(Recno())
nQtd    := 1 - nQtdTot
Else
nQtd    := Round((1/nVolume),3)
nQtdTot += nQtd
EndIf
*/
nQtdTot := 0
cQuery := "SELECT SUM(XD1_QTDATU) AS QTD FROM " + RetSqlName("XD1") + " WHERE  D_E_L_E_T_ <> '*' AND XD1_PVSEP = '" + SC2->C2_PEDIDO + "' AND XD1_OCORRE <> '5'"
If Select("QXD1") <> 0
	QXD1->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QXD1"

nQtdTot := QXD1->QTD

nQtd := 0
If nVolume == Len(oGet:aCols)+1
	nQtd    := 1 - nQtdTot
Else
	nQtd    := Round((1/nVolume),3)
	nQtdTot += nQtd
EndIf

cVolume := Alltrim(Str(Len(oGet:aCols)+1))+"/"+Alltrim(Str(nVolume))


MsgRun("Imprimindo etiqueta Layout 90","Aguarde...",{|| lRetEtq := U_DOMETQ90(cOp,Nil,nQtd,1,'3',{},.T.,nPeso,cVolume,.T.,NIl,Nil,Nil) })

If !lRetEtq
   U_MsgColetor("Erro no processo de emissão da etiqueta.")
EndIf

fCarGet()

/*
RecLock("TMP",.F.)
TMP->ETIQ := XD1->XD1_XXPECA
TMP->VOL  := AllTrim(Str(TMP->(Recno()))) + "/" + AllTrim(Str(nVolume))
TMP->( msUnlock() )
*/

If nVolume == Len(oGet:aCols)
	U_MsgColetor("Processo finalizado.")
	oMontKit:End()
EndIf

//TMP->(DbGoTop())
//oMark:oBrowse:Refresh()

Return

Static Function ValidaOP()

Local lRet := .T.
Local cQuery := ""

//apontamento de OP
DbSelectArea("SC2")
SC2->(DbSetOrder(1))
If SC2->(DbSeek(xFilial("SC2") + cOp))
	If Empty(SC2->C2_DATRF)
		MsgRun("U_ETQMTA250()","Apontandontamento de OP...",{|| _Retorno := U_ETQMTA250("010", cOp,SC2->C2_PRODUTO,SC2->C2_LOCAL,SC2->C2_QUANT,"T", "") })
	Else
		cQuery := "SELECT COUNT(*) AS QTD FROM " + RetSqlName("XD1") + " WHERE  D_E_L_E_T_ <> '*' AND XD1_PVSEP = '" + SC2->C2_PEDIDO + "'"
		
		U_MsgColetor("Ordem de Produção já apontada.")
		//oGetOp:SetFocus()
		//Return .F.
	EndIf
Else
	U_MsgColetor("Ordem de Produção inexistente.")
	oGetOp:SetFocus()
	Return .F.
EndIf

fCarGet()

Return lRet

Static Function ValidaVol()
Local lRet := .T.

If Len(oGet:aCols) <> 0
	cVol := Subs(oGet:aCols[1,2],3)
	If Val(cVol) <> nVolume
		U_MsgColetor("Número de volumes diferente do informado anteriormente.")
		If U_UMSGYESNO("Deseja cancelar todas a(s) " + Alltrim(Str(Len(oGet:aCols))) + " etiqueas geradas anteriormente?" )

			SC2->( dbSetOrder(1) )
			SC2->( dbSeek( xFilial() + cOP ) )
			cQuery := "UPDATE " + RetSqlName("XD1") + " SET XD1_OCORRE = '5' WHERE XD1_FILIAL = '01' AND XD1_PVSEP = '"+SC2->C2_PEDIDO+"' AND XD1_PVSEP <> '' AND XD1_OCORRE = '6' AND D_E_L_E_T_ = '' AND XD1_ZYNOTA = '' "
			TCSQLEXEC(cQuery)
			
			fCarGet()
		Else
   		lRet := .F.
		EndIf
	EndIf
EndIf

Return lRet

Static Function fCarGet()

SC2->( dbSetOrder(1) )
SC2->( dbSeek( xFilial() + cOP ) )

cQuery := "SELECT XD1_XXPECA, XD1_PESOB, XD1_VOLUME, R_E_C_N_O_ AS RECNO FROM " + RetSqlName("XD1") + " WHERE XD1_FILIAL = '01' AND XD1_PVSEP = '"+SC2->C2_PEDIDO+"' AND XD1_PVSEP <> '' AND XD1_OCORRE = '6' AND D_E_L_E_T_ = '' ORDER BY XD1_VOLUME "

If Select("QXD1") <> 0
	QXD1->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QXD1"

oGet:aCols := {}
While !QXD1->( EOF() )
	
	XD1->(DbGoTo(QXD1->RECNO))
	If XD1->(Recno()) == QXD1->RECNO
		RecLock("XD1",.F.)
		XD1->XD1_ULTNIV := "S"
		XD1->(MsUnlock())
	EndIf                     
	
	AADD(oGet:aCols,Array(4))
	oGet:aCols[Len(oGet:aCols),1] := QXD1->XD1_XXPECA
	oGet:aCols[Len(oGet:aCols),2] := QXD1->XD1_VOLUME
	oGet:aCols[Len(oGet:aCols),3] := QXD1->XD1_PESOB
	oGet:aCols[Len(oGet:aCols),4] := .F.
	QXD1->( dbSkip() )
End

oGet:Refresh()

Return
