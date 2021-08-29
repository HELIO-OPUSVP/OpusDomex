#include "rwmake.ch"
#include "totvs.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DOMACD37 ºAutor  ³Helio Ferreira       º Data ³  09/08/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Amarração da etiqueta externa Huawei emitida pelo site     º±±
±±º          ³ Huawei com a etiqueta nivel 3 (cord) Domex                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMACD37()
Local nCol1 := 005
Local nCol2 := 015
Local nLin     := 010
Local oTexto1, oTexto2

Private nTamEtiqD  := 100 // 21
Private nTamEtiqH  := 100 // 21
Private cEtqHuaw := Space(nTamEtiqH)
Private cEtqDom  := Space(nTamEtiqD)

DEFINE MSDIALOG oDlg1 TITLE OemToAnsi("Consulta etiqueta") FROM 0,0 TO 293,233 PIXEL

@ nLin, nCol1	SAY oTexto1   VAR OemToAnsi('Etiqueta Huawei:')  PIXEL SIZE 180,15
oTexto1:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
nLin += 10
@ nLin, nCol2 MSGET oEtqHuaw VAR cEtqHuaw  Picture "@!"  SIZE 85,12 Valid vEtqHuaw() PIXEL
oEtqHuaw:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)

nLin += 40

@ nLin, nCol1	SAY oTexto2   VAR OemToAnsi('Etiqueta Rosenberger:')  PIXEL SIZE 180,15
oTexto2:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
nLin += 10
@ nLin, nCol2 MSGET oEtqDom VAR cEtqDom  Picture "@!"  SIZE 85,12 Valid vEtqDom() PIXEL
oEtqDom:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)

nLin += 30

//@ 131,008 Button "Ok" Size 40,13 Action Close(oDlg1) Pixel
@ nLin,040 Button "Sair" Size 55,13 Action Close(oDlg1) Pixel

/*
@ 055, 008	SAY oTexto3   VAR 'Ultima Etiq.: ' + _cUltEtiq  PIXEL SIZE 160,13
oTexto3:oFont := TFont():New('Arial',,19,,.T.,,,,.T.,.F.)

@ 065, 008	SAY oTexto3   VAR 'Saldo a endereçar: '+Transform(_nSaldo,"@E 9,999,999")  PIXEL SIZE 160,13
oTexto3:oFont := TFont():New('Arial',,19,,.T.,,,,.T.,.F.)

@ 075, 008	SAY _oCodPro   VAR "Código: " + _cCodPro  PIXEL SIZE 160,13
oTexto3:oFont := TFont():New('Arial',,19,,.T.,,,,.T.,.F.)

@ 084, 008	SAY _oDescPro  VAR "Desc.:   " + _cDesPro  PIXEL SIZE 100,20
oTexto3:oFont := TFont():New('Arial',,19,,.T.,,,,.T.,.F.)

@ 101, 008	SAY _oDoc   VAR "NF.: " + _cDoc + "         Série: " + _cSerie  PIXEL SIZE 100,20
oTexto3:oFont := TFont():New('Arial',,19,,.T.,,,,.T.,.F.)

@ 111, 008	SAY _oLote   VAR "Lote.: " + _cLote   PIXEL SIZE 100,20
oTexto3:oFont := TFont():New('Arial',,19,,.T.,,,,.T.,.F.)

@ 121, 008	SAY _oQtd   VAR "Qtd. Orig.: " + Transform(_nQtdOri,"@E 999,999.999")   PIXEL SIZE 100,20
oTexto3:oFont := TFont():New('Arial',,19,,.T.,,,,.T.,.F.)
*/

ACTIVATE MSDIALOG oDlg1

Return


Static Function vEtqHuaw()
Local cEtiqueta := Alltrim(cEtqHuaw) + Space(Len(XD1->XD1_ETQHUA)-Len(Alltrim(cEtqHuaw)))
Local aAreaSIX   := SIX->( GetArea() )
Local lEncontrou := .F.

If Len(Alltrim(cEtqHuaw)) <> 18 .and. Len(Alltrim(cEtqHuaw)) <> 0
	U_MsgColetor("Etiqueta Huawei inválida",1)
	Return .F.
EndIf

If SIX->( dbSeek("XD1") )
	While !SIX->( EOF() ) .and. SIX->INDICE == "XD1"
		If "XD1_ETQHUA" $ SIX->CHAVE
			lEncontrou := .T.
		EndIf
		SIX->( dbSkip() )
	End
EndIf

RestArea(aAreaSIX)

If lEncontrou
	XD1->( dbSetOrder(7) ) // XD1_FILIAL + XD1_ETQHUA
	If XD1->( dbSeek( xFilial() + cEtiqueta ) )
		U_MsgColetor("Etiqueta já coletada anteriormente")
	EndIf
Else
	cQuery := "SELECT XD1_XXPECA FROM " + RetSqlName("XD1") + " (NOLOCK) WHERE XD1_FILIAL = '"+xFilial("XD1")+"' AND XD1_ETQHUA = '"+cEtiqueta+"' AND D_E_L_E_T_ = '' "
	If Select("QXD1") <> 0
		QXD1->( dbCloseArea() )
	EndIf
	TCQUERY cQuery NEW ALIAS "QXD1"
	If !QXD1->( EOF() )
		U_MsgColetor("Etiqueta já coletada anteriormente")
	EndIf
	QXD1->( dbCloseArea() )
EndIf

Return .T.


Static Function vEtqDom()
Local _Retorno  := .F.
Local cEtiqueta := ""
Local lEncontrou := .F.
Local aAreaSIX   := SIX->( GetArea() )

If Len(Alltrim(cEtqDom)) <> 12 .and. Len(Alltrim(cEtqDom)) <> 0
	U_MsgColetor("Etiqueta Rosenberger inválida",1)
	Return .F.
EndIf

If SIX->( dbSeek("XD1") )
	While !SIX->( EOF() ) .and. SIX->INDICE == "XD1"
		If "XD1_ETQHUA" $ SIX->CHAVE
			lEncontrou := .T.
		EndIf
		SIX->( dbSkip() )
	End
EndIf

RestArea(aAreaSIX)

If Len(AllTrim(cEtqDom)) == 12 //EAN 13 s/ dígito verificador.
	cEtqDom := "0"+cEtqDom
	cEtqDom := Subs(cEtqDom,1,12)
EndIf

oEtqHuaw:Refresh()

If !Empty(cEtqDom)
	If !Empty(cEtqHuaw)
		XD1->( dbSetOrder(1) )
		If XD1->( dbSeek( xFilial("XD1") + cEtqDom ) )
			//U_MsgColetor("Etiqueta encontrada!")
			
			cEtiqueta := Alltrim(cEtqHuaw) + Space(Len(XD1->XD1_ETQHUA)-Len(Alltrim(cEtqHuaw)))
			
			If XD1->XD1_ETQHUA == cEtiqueta
				U_MsgColetor("Associação já realizada anteriormente")
			Else
				
				aAreaXD1 := XD1->( GetArea() )
				
				If lEncontrou
					XD1->( dbSetOrder(7) ) // XD1_FILIAL + XD1_ETQHUA
					If XD1->( dbSeek( xFilial() + cEtiqueta ) )
						Reclock("XD1",.F.)
						XD1->XD1_ETQHUA := ""
						XD1->( msUnlock() )
						U_MsgColetor("Etiqueta já coletada anteriormente na etiquera Rosenberger: " + XD1->XD1_XXPECA+". Esta associação indevida foi desfeita.")
					EndIf
				Else
					cQuery := "SELECT XD1_XXPECA FROM " + RetSqlName("XD1") + " (NOLOCK) WHERE XD1_FILIAL = '"+xFilial("XD1")+"' AND XD1_ETQHUA = '"+cEtiqueta+"' AND D_E_L_E_T_ = '' "
					If Select("QXD1") <> 0
						QXD1->( dbCloseArea() )
					EndIf
					TCQUERY cQuery NEW ALIAS "QXD1"
					If !QXD1->( EOF() )
						XD1->( dbSetOrder(1) )
						If XD1->( dbSeek( xFilial() + QXD1->XD1_XXPECA ) )
							Reclock("XD1",.F.)
							XD1->XD1_ETQHUA := ""
							XD1->( msUnlock() )
							U_MsgColetor("Etiqueta já coletada anteriormente na etiquera Rosenberger: " + XD1->XD1_XXPECA+". Esta associação indevida foi desfeita.")
						EndIf
					EndIf
					QXD1->( dbCloseArea() )
				EndIf
				
				RestArea(aAreaXD1)
				
				If !Empty(XD1->XD1_ETQHUA)
					cAntiga := XD1->XD1_ETQHUA
					Reclock("XD1",.F.)
					XD1->XD1_ETQHUA := cEtiqueta
					XD1->( msUnlock() )
					U_MsgColetor("Associação realizada, porém esta etiqueta Rosenberger estava associada a outra etiqueta Huawei ("+Alltrim(cAntiga)+")")
				Else
					Reclock("XD1",.F.)
					XD1->XD1_ETQHUA := cEtiqueta
					XD1->( msUnlock() )
					U_MsgColetor("Associação realizada com sucesso, etiqueta Huawei: " + cEtiqueta,1)
				EndIf
			EndIf
			_Retorno := .T.
		Else
			U_MsgColetor("Número de etiqueta não encontrado")
		EndIf
	Else
		U_MsgColetor("Favor coletar primeiro a etiqueta Huawei")
	EndIf
Else
   _Retorno := .T.
EndIf

If _Retorno
	cEtqDom  := Space(100)
	cEtqHuaw := Space(100)
	oEtqDom:Refresh()
	oEtqHuaw:Refresh()
	oEtqHuaw:SetFocus()
EndIf

Return _Retorno
