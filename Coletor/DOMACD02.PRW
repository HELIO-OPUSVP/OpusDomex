#include "TbiConn.ch"
#include "TbiCode.ch"
#include "Rwmake.ch"
#include "Topconn.ch"
#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DOMACD02  ºAutor  ³Microsiga           º Data ³  02/20/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Emissão de etiquetas pelo Coletor de Dados.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMACD02()
Private oCodigo,oQtd,oSaldo 
Private _cCodigo    := CriaVar("B1_COD",.F.)
Private _cDescri    := ""
Private _nQtd       := 1
Private _nSaldo     := 0

Processa({ || ProcRun() })

Return

//------------------------------------------------------

Static Function ProcRun()

DEFINE MSDIALOG oDlg1 TITLE OemToAnsi("Etiquetas estoque inicial") FROM 0,0 TO 293,233 PIXEL of oMainWnd PIXEL

@ 005,005 Say "Código: " Pixel
@ 005,030 MsGet oCodigo Var _cCodigo F3 "SB1" Valid RetDesc() Size 70,15 Pixel Of oDlg1
@ 020,005 Say _cDescri Size 100,15 Pixel

@ 040,005 Say "Quantidade da Embalagem: " Pixel
@ 050,005 MsGet oSaldo Var _nSaldo  Size 50,10 Valid(_nSaldo > 0) Picture "@E 999,999,999.9" Pixel Of oDlg1

@ 070,005 Say "No. Etiquetas: " Pixel
@ 080,005 MsGet oQtd Var _nQtd Size 50,10 Picture "@E 999,999,999" Pixel Of oDlg1

@ 130,010 Button "Imprimir" Size 40,15 Action fEtiqAvu() Pixel
@ 130,065 Button "Cancelar" Size 40,15 Action Close(oDlg1) Pixel

ACTIVATE MSDIALOG oDlg1

Return

//--------------------------------------------------------------------

Static Function RetDesc()
Local _lRet
If! Empty(_cCodigo)
    SB1->( dbSetOrder(1) )
    If SB1->( dbSeek( xFilial("SB1") + _cCodigo ) )
	    _cDescri := SB1->B1_DESC
	    _lRet := .T.
    Else
	    U_MsgColetor('Produto não encontrado.')
	    oCodigo:SetFocus()
	    _cCodigo := "" 
	    _cDescri := ""
	    _lRet    := .F.
	 EndIf   
EndIf

Return(_lRet)

//-----------------------------------------------------------------------

Static Function fEtiqAvu()

SB1->( dbSetOrder(1) )

dbSelectArea("XD1")
For _nX:=1 To _nQtd
	
	If !Empty(_nSaldo)
		If !Empty(_cCodigo)
			_cProxPeca := U_IXD1PECA()
   		
			Reclock("XD1",.T.)
			Replace XD1->XD1_FILIAL  With xFilial("XD1")
			// Substituido por Michel Sander em 28.08.2014 para gravar o documento a partir do programa IXD1PECA()
			Replace XD1->XD1_XXPECA  With _cProxPeca
			Replace XD1->XD1_FORNEC  With Space(06)
			Replace XD1->XD1_LOJA    With Space(02)
			Replace XD1->XD1_DOC     With Space(06)
			Replace XD1->XD1_SERIE   With Space(03)
			Replace XD1->XD1_ITEM    With StrZero(Recno(),4)
			Replace XD1->XD1_COD     With SB1->B1_COD
			Replace XD1->XD1_LOCAL   With SB1->B1_LOCPAD
			Replace XD1->XD1_TIPO    With SB1->B1_TIPO
			Replace XD1->XD1_USERID  With RetCodUsr()
			Replace XD1->XD1_LOTECT  With ""
			Replace XD1->XD1_DTDIGI  With dDataBase
			Replace XD1->XD1_FORMUL  With ""
			Replace XD1->XD1_LOCALI  With ""
			XD1->XD1_OCORRE := "4"
			Replace XD1->XD1_QTDORI  With _nSaldo
			Replace XD1->XD1_QTDATU  With _nSaldo
			XD1->( MsUnlock() )
			
			U_DOMEST06()     
		Else
			U_MsgColetor("Produto não preenchido.")
			oCodigo:SetFocus()
		EndIf
	Else
		U_MsgColetor("Quantidade por embalagem não preenchida.")
		oSaldo:SetFocus()
	EndIf
Next
_cCodigo  := CriaVar("B1_COD",.F.)
_cDescri  := ""
_nQtd     := 1
_nSaldo   := 0
oDlg1     :Refresh()
oCodigo   :SetFocus()
Return

//---------------------------------------------------------

//User Function QuebraString(_cTexto,_nTam) // Sem considerar espaços
//Local _aTexto :={}
//Local _nLinhas:=Round(Len(_cTexto)/_nTam,0)
//Local _nResto :=Round(Len(_cTexto)%_nTam,0)
//Local _nX     :=1
//Local _nCount :=1 
//_nLinhas      := If(_nResto==0,_nLinhas,_nLinhas+1)
//
//While _nCount <= _nLinhas
//     aadd(_aTexto,SubStr(_cTexto,_nX,_nTam))
//     _nX :=(_nCount*_nTam)+1
//     _nCount++
//End
//
//Return(_aTexto)

User Function QuebraString(cString,nStep)// Considerando espaços
Local aRetorno := {}
Local d, b

cString := StrTran(cString,Chr(13)," ")

cString += Space(200)

For d := 1 to 500 Step(nStep)
	If !Empty(Subs(cString,d,nStep))
		nStep2 := nStep
		nvar   := 0
		For b := 1 to 30
			If !Subs(cString,d+nStep2-1,1) == ' '
				nStep2  -= 1
				nvar    += 1
			Else
				b := 30
			EndIf
		Next b
		AADD(aRetorno, Subs(cString,d,nStep2) )
		d -= nvar
	EndIf
Next

Return aRetorno

//---------------------------------------------------------

Static Function AlertC(cTexto)
Local aTemp := U_QuebraString(cTexto,20)
Local cTemp := ''
Local lRet  := .T.
Local x 

For x := 1 to Len(aTemp)
	cTemp += aTemp[x] + Chr(13)
Next x

cTemp += 'Continuar?'

If !apMsgNoYes( cTemp )
   lRet:=.F.
EndIf

Return(lRet)