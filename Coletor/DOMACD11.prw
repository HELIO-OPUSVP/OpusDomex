#include "TbiConn.ch"
#include "TbiCode.ch"
#include "rwmake.ch"
#include "TOpconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DOMACD11  ºAutor  ³Helio Ferreira      º Data ³  27/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa de inventário DESATIVADO                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMACD11()
Private cContagem := ""

dbSelectArea("SZC")

Define MsDialog oInv Title OemToAnsi("Contagem: " ) From 0,0 To 293,233 Pixel of oMainWnd PIXEL

cContagem := ""
aContagem := {}
AADD(aContagem,'001')
AADD(aContagem,'002')
AADD(aContagem,'003')

nLin := 30
@ nLin, 020	SAY oTexto1 Var 'Informe a contagem:'    SIZE 100,10 PIXEL
oTexto1:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

nLin += 20
@ nLin, 020	SAY oTexto2 Var 'Usuário:'    SIZE 30,10 PIXEL
oTexto2:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)

@ nLin, 055 COMBOBOX oCombo2  VAR cContagem ITEMS aContagem    SIZE 45,10 VALID .T. PIXEL
oCombo1:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)

nLin += 40
@ nLin, 10 BUTTON "Confirmar" ACTION Processa( {|| oInv:End()} ) SIZE nLargBut,nAltuBut PIXEL OF oInv

Activate MsDialog oInv      

Private oTxtEnd,oGetEnd,oTxtEtiq,oGetEtiq,oTxtProd,oGetProd,oTxtQtd,oGetQtd,oMark

Private _nTamEtiq      := 21
Private _cEndereco     := Space(Len(CriaVar("BE_LOCALIZ",.F.))+3)
Private _cEtiqueta     := Space(_nTamEtiq)//Space(Len(CriaVar("XD1_XXPECA",.F.)))
Private _cProduto      := CriaVar("B1_COD",.F.)
Private _nQtd          := CriaVar("XD1_QTDATU",.F.)
Private _cLoteEti      := CriaVar("BF_LOTECTL",.F.)
Private _aCols         := {}
Private _cParametro    := "MV_XXNUMIN"
Private _cCtrNum       := GetNewPar(_cParametro,"")
Private _lAuto	        := .T.
Private _lIndividual   := .F.
Private _cDocInv
Private _nTamDoc       := Len(CriaVar("B7_DOC",.F.))
Private aEmpSB2
Private _aLog
Private cUltEti1       := '_____________'
Private cUltEti2       := '_____________'
Private cUltEti3       := '_____________'
Private oUltEti1
Private oUltEti2
Private oUltEti3
Private aEtiqProd
Private _cProdAnt := ""
Private nContad   := 0
Private cLocCQ    := GetMV("MV_CQ")

XD1->( dbSetOrder(1) )
SB1->( dbSetOrder(1) )

//MsgRun("Aguarde... Inicializando inventário...","Iniciando...",{|| fB2QACLASS() })

If! Empty(_cCtrNum)
	fOkTela()
Else
	U_MsgColetor("Verifique o parâmetro "+_cParametro)
EndIf

Return

//------------------------------------------------------

Static Function fOkTela()
_aCols:={}

Define MsDialog oInv Title OemToAnsi("Inventário GERAL " + DtoC(dDataBase)) From 0,0 To 293,233 Pixel of oMainWnd PIXEL

@ 005,005 Say oTxtEnd    Var "Endereço " Pixel Of oInv
@ 005,045 MsGet oGetEnd  Var _cEndereco Valid fValEnd() Size 70,10 Pixel Of oInv
oTxtEnd:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
oGetEnd:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

@ 020,005 Say oTxtEtiq   Var "Etiqueta " Pixel Of oInv
@ 020,045 MsGet oGetEtiq Var _cEtiqueta  Size 70,10 Valid fValEtiq() Pixel Of oInv
oTxtEtiq:oFont:= TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
oGetEtiq:oFont:= TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

@ 035,005 Say oTxtProd   Var "Produto "  Pixel Of oInv
@ 035,045 MsGet oGetProd Var _cProduto When .F. Size 70,10  Pixel Of oInv
oTxtProd:oFont:= TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
oGetProd:oFont:= TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

@ 050,005 Say oTxtQtd    Var "Quantidade " Pixel Of oInv
@ 050,045 MsGet oGetQtd  Var _nQtd Valid .T.      Picture "@E 9,999,999.99" Size 70,10  Pixel Of oInv
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

Activate MsDialog oInv                               '

Return

Static Function fValEnd()
Local _lRet := .T.

SBE->( dbSetOrder(1) )
If SBE->( dbSeek( xFilial() + Subs(_cEndereco,1,17)) )
	If SBE->BE_MSBLQL == '1'
		_lRet := .F.
		U_MsgColetor('Endereço bloqueado para uso.')
	EndIf
Else
	_lRet := .F.
	U_MsgColetor('Endereço não encontrado.')
EndIf

Return(_lRet)


Static Function fValEtiq()
Local _lRet   :=.T.
Local _nSaldoSDA := 0

If dDataBase <> Date()
	dDataBase := Date()
EndIf

If Len(AllTrim(_cEtiqueta))==12 //EAN 13 s/ dígito verificador.
	_cEtiqueta := "0"+_cEtiqueta
	_cEtiqueta := Subs(_cEtiqueta,1,12)
EndIf

If Len(AllTrim(_cEtiqueta))==20 //CODE 128 c/ dígito verificador.
	_cEtiqueta := Subs(AllTrim(_cEtiqueta),8,12)
EndIf

oGetEtiq:Refresh()

If !Empty(_cEndereco)
	If !Empty(_cEtiqueta)
		If XD1->( dbSeek( xFilial() + _cEtiqueta ) )
			
			_cProduto := XD1->XD1_COD
			If SB1->( dbSeek( xFilial() + _cProduto) )
				If SB1->B1_LOCALIZ == 'S'
					
					cQuery := "SELECT SUM(DA_SALDO) AS DA_SALDO FROM SDA010 WHERE DA_FILIAL = '"+xFilial("SDA")+"' AND DA_PRODUTO = '"+_cProduto+"' AND DA_LOCAL = '"+SubStr(_cEndereco,1,2)+"' AND D_E_L_E_T_ = '' "
					
					If Select("TEMP") <> 0
						TEMP->( dbCloseArea() )
					EndIf
					
					TCQUERY cQuery NEW ALIAS "TEMP"
					
					_nSaldo := TEMP->DA_SALDO
					
					//If SB2->( dbSeek( xFilial() + _cProduto + SubStr(_cEndereco,1,2)  ) )
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
							
							If cUltEti1 <> XD1->XD1_XXPECA
								If !Empty(cUltEti1) .and. cUltEti1 <> '_____________'
									
									If _nQtd <= 0
										U_MsgColetor("Quantidade da embalagem não pode ser menor ou igual a zero.")
										Return .T.
									EndIf
									
									If Int(_nQtd) <> _nQtd
										U_MsgColetor("Quantidade digitada com casas decimais!!!")
									EndIf
									
									XD1->( dbSeek( xFilial() + Subs(cUltEti1,1,13) ) )
									If SZC->( dbSeek( xFilial() + DtoS(dDataBase) + Subs(cUltEti1,1,13) + cContagem ) )
										Reclock("SZC",.F.)
										SZC->ZC_CONTADO += 1
										If _nQtd <> SZC->ZC_QUANT
											U_MsgColetor("Embalagem inventariada anteriormente com " + Alltrim(Transform(SZC->ZC_QUANT,"@E 999,999,999.99")) + " e alterada agora para " + Alltrim(Transform(_nQtd,"@E 999,999,999.99")) )
										EndIf
										SZC->ZC_PRODUTO := XD1->XD1_COD
										SZC->ZC_LOCAL   := SubStr(_cEndereco,1,2)
										SZC->ZC_LOCALIZ := SubStr(_cEndereco,3)
										If Rastro(XD1->XD1_COD)
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
										SZC->ZC_XXPECA  := XD1->XD1_XXPECA
										SZC->ZC_PRODUTO := XD1->XD1_COD
										SZC->ZC_LOCAL   := SubStr(_cEndereco,1,2)
										SZC->ZC_LOCALIZ := SubStr(_cEndereco,3)
										If Rastro(XD1->XD1_COD)
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
								
								XD1->( dbSeek( xFilial() + Subs(_cEtiqueta,1,13) ) )
								
								cUltEti3 := Subs(cUltEti2,1,13)
								cUltEti2 := Subs(cUltEti1,1,13)
								cUltEti1 := Subs(XD1->XD1_XXPECA,1,13)
								
								If SZC->( dbSeek( xFilial() + DtoS(dDataBase) + Subs(cUltEti3,1,13) ) )
									If !Empty(cUltEti3)
										cUltEti3 := cUltEti3 + " - Ok - " + SZC->ZC_USUARIO
									EndIf
								EndIf
								
								If SZC->( dbSeek( xFilial() + DtoS(dDataBase) + Subs(cUltEti2,1,13) ) )
									If !Empty(cUltEti2)
										cUltEti2 := cUltEti2 + " - Ok - " + SZC->ZC_USUARIO
									EndIf
								EndIf
								
								If SZC->( dbSeek( xFilial() + DtoS(dDataBase) + Subs(cUltEti1,1,13) ) )
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
								
								If _cProdAnt <> _cProduto
									_cProdAnt := _cProduto
									aEtiqProd := {}
									AADD(aEtiqProd,XD1->XD1_XXPECA)
									nContad := 1
								Else
									If aScan(aEtiqProd,XD1->XD1_XXPECA) == 0
										AADD(aEtiqProd,XD1->XD1_XXPECA)
										nContad++
									EndIf
								EndIf
							EndIf
							
							oContad:Refresh()
							
							_cProduto := SB1->B1_COD
							
							_nQtd     := XD1->XD1_QTDATU
							
							//oGetQtd :SetFocus()
							//oGetEtiq  :SetFocus()
						Else
							_lRet := .F.
							U_MsgColetor("ATENÇÃO existe saldo a endereçar. Não é possível inventariar produtos com pendências de endereçamento.")
						EndIf
					Else
						_lRet := .F.
						U_MsgColetor("ATENÇÃO existe saldo pendente de liberação na Qualidade (CQ). Não é possível inventariar produtos com pendências de liberação no CQ.")
					EndIf
				Else
					_lRet:=.F.
					U_MsgColetor("Produto sem controle por endereço.")
				EndIf
			Else
				_lRet:=.F.
				U_MsgColetor("Produto NÃO encontrado")
			EndIf
		Else
			_lRet:=.F.
			U_MsgColetor("Etiqueta não encontrada.")
		EndIf
	Else
		
	EndIf
Else
	_lRet:=.F.
	U_MsgColetor("Endereço não preenchido.")
EndIf

If !_lRet
	_cEtiqueta:= Space(_nTamEtiq)
	_cProduto := CriaVar("B1_COD",.F.)
	oGetEtiq  :Refresh()
	oGetEtiq  :SetFocus()
Else
	//oGetEtiq :Refresh()
	If !Empty(_nQtd)
	   If !Empty(_cEtiqueta)
		   _cEtiqueta := Space(_nTamEtiq)
	   	//oGetEtiq   :Refresh()
	   	oGetEtiq   :SetFocus()
	   EndIf
	Else
	   U_MsgColetor("Etiqueta com quantidade zero. Informe a quantidade.")
	   oGetQtd :SetFocus()
	EndIf
	//oGetQtd :Refresh()
EndIf

Return(_lRet)

//---------------------------------------------------------

Static Function AlertC(cTexto)
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

Static Function fGravaUltima()

If !Empty(cUltEti1) .and. cUltEti1 <> '_____________'
	If _nQtd <= 0
		U_MsgColetor("Quantidade da embalagem não pode ser menor ou igual a zero.")
		Return .T.
	EndIf
	
	If Int(_nQtd) <> _nQtd
		U_MsgColetor("Quantidade digitada com casas decimais!!!")
	EndIf
	
	XD1->( dbSeek( xFilial() + Subs(cUltEti1,1,13) ) )
	
	If SZC->( dbSeek( xFilial() + DtoS(dDataBase) + Subs(cUltEti1,1,13) + cContagem ) )
		Reclock("SZC",.F.)
		SZC->ZC_CONTADO += 1
		If _nQtd <> SZC->ZC_QUANT
			U_MsgColetor("Embalagem inventariada anteriormente com " + Alltrim(Transform(SZC->ZC_QUANT,"@E 999,999,999.99")) + " e alterada agora para " + Alltrim(Transform(_nQtd,"@E 999,999,999.99")) )
		EndIf
		SZC->ZC_PRODUTO := XD1->XD1_COD
		SZC->ZC_LOCAL   := SubStr(_cEndereco,1,2)
		SZC->ZC_LOCALIZ := SubStr(_cEndereco,3)
		If Rastro(XD1->XD1_COD)
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
		SZC->ZC_XXPECA  := XD1->XD1_XXPECA
		SZC->ZC_PRODUTO := XD1->XD1_COD
		SZC->ZC_LOCAL   := SubStr(_cEndereco,1,2)
		SZC->ZC_LOCALIZ := SubStr(_cEndereco,3)
		If Rastro(XD1->XD1_COD)
			SZC->ZC_LOTECTL := If(!Empty(XD1->XD1_LOTECTL),XD1->XD1_LOTECTL,'LOTE1308')
		EndIf
		SZC->ZC_HORA    := Time()
		SZC->ZC_QUANT   := _nQtd
		SZC->ZC_CONTADO := 1
		SZC->ZC_USUARIO := cUsuario
		SZC->ZC_CONTAGE := cContagem
		SZC->( msUnlock() )
	EndIf
	
	cUltEti1 := cUltEti1 + " - Ok - " + SZC->ZC_USUARIO
	
EndIf

Return

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
