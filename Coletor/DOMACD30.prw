#include "rwmake.ch"
#include "totvs.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DOMACD30 ºAutor  ³Helio FErreira       º Data ³  12/09/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Consulta de etiquetas                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMACD30()

Private _nTamEtiq  := 21
Private _cEtiqueta := Space(_nTamEtiq)

DEFINE MSDIALOG oDlg1 TITLE OemToAnsi("Consulta etiqueta") FROM 0,0 TO 293,233 PIXEL of oMainWnd PIXEL

@ 005, 008	SAY oTexto1   VAR OemToAnsi('Etiqueta:')  PIXEL SIZE 180,15
oTexto1:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

@ 015, 008 MSGET _oEtiqueta VAR _cEtiqueta  Picture "@!"  SIZE 85,12 Valid ValidaEtiq() PIXEL
_oEtiqueta:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)

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

//@ 131,008 Button "Ok" Size 40,13 Action Close(oDlg1) Pixel
@ 131,067 Button "Fechar" Size 40,13 Action Close(oDlg1) Pixel

*/
ACTIVATE MSDIALOG oDlg1

Return

Static Function ValidaEtiq()
Local _Retorno := .F.

If Len(AllTrim(_cEtiqueta))==12 //EAN 13 s/ dígito verificador.
	_cEtiqueta := "0"+_cEtiqueta
	_cEtiqueta := Subs(_cEtiqueta,1,12)
EndIf

_oEtiqueta:Refresh()

If !Empty(_cEtiqueta)
	XD1->( dbSetOrder(1) )
	If XD1->( dbSeek( xFilial("XD1") + _cEtiqueta ) )

   Else
      U_MsgColetor(".")
   EndIf
EndIf

Return _Retorno
