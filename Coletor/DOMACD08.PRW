#include "TbiConn.ch"
#include "TbiCode.ch"
#include "Rwmake.ch"
#include "Topconn.ch"
#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DOMACD08  �Autor  �Helio Ferreira      � Data �  08/22/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Pagamento de Perdas        d                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function DOMACD08()
Private cSZASZE        := ""

Private oTxtOP,oGetOP,oTxtEtiq,oGetEtiq,oTxtProd,oGetProd,oTxtQtd,oGetQtd,oMark,oTxtQtdEmp,oMainEti
Private _nTamEtiq      := 21
Private _nTamOP        := Len(SD3->D3_OP)+1+Len(SZA->ZA_DOCUMEN)+1
Private _cNumOP        := Space(_nTamOP)
Private _cEtiqueta     := Space(_nTamEtiq)//Space(Len(CriaVar("XD1_XXPECA",.F.)))
Private _cProduto      := CriaVar("B1_COD",.F.)
Private _nQtd          := CriaVar("XD1_QTDATU",.F.)
Private _cLoteEti      := CriaVar("BF_LOTECTL",.F.)
Private _aCols         := {}
Private _lAuto	        := .T.
Private _lIndividual   := .T.
Private _cCodInv
Private cTamGetEnd     := 2+15+1
Private cGetEnd        := Space(cTamGetEnd)
Private _cProdEmp	     := Space(15)
Private _cDescric	     := Space(27)
Private _cEnderec	     := Space(15)
Private _nQtdEmp       := 0
Private _aDados        := {}
Private _aEnd          := {}
Private _nCont
Private nSaldoSZA      := 0
Private cProdEtiq      := "Produto:"+Space(14)
Private _cNumZADOC     := ''

Private cLocProcDom := GetMV("MV_XXLOCPR")   // Local de Processos Domex

Private nFCICalc    := SuperGetMV("MV_FCICALC",.F.,0)

dDataBase := Date()

Define MsDialog oTelaOP Title OemToAnsi("Pagamento de Perdas " + DtoC(dDataBase) ) From 0,0 To 293,233 Pixel of oMainWnd PIXEL

nLin := 005
@ nLin,005   Say oTxtOP    Var "OP (perda)" Pixel Of oTelaOP
@ nLin-2,045 MsGet oGetOP  Var _cNumOP Valid fValidaOP() Size 70,10 Pixel Of oTelaOP
oTxtOP:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
oGetOP:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

@ 018,001 To 057,115 Pixel Of oMainWnd PIXEL

@ 020,005 Say oTxtLabelOP  Var "Produto " Pixel Of oTelaOP
@ 027,005 Say oTxtProdEmp  Var "C�digo: " + _cProdEmp Pixel Of oTelaOP
@ 027,077 Say oTxtQtdEmp   Var "Qtd: " + TransForm(_nQtdEmp,"@E 999,999.99") Pixel Of oTelaOP
@ 033,005 Say oTxtDescric  Var "Descri��o: " + _cDescric Size 110,15 Pixel Of oTelaOP
@ 048,005 Say oTxtEnderec  Var "Endere�o: "+ _cEnderec Pixel Of oTelaOP

@ 130,005 Say oSaldoSZA    Var "Saldo: " + Alltrim(Transform(nSaldoSZA,"@E 999,999,999.9")) Pixel Of oTelaOP
oSaldoSZA:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

oTxtLabelOP:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
oTxtProdEmp:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
oTxtDescric:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
oTxtEnderec:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
oTxtQtdEmp:oFont  := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)

nLin+= 60
@ nLin  ,005 Say oTxtEnd   Var "Endere�o "  Pixel Of oTelaOP
@ nLin-2,045 MsGet oGetEnd Var cGetEnd Valid fValidEnd() Size 70,10  Pixel Of oTelaOP
oTxtEnd:oFont:= TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
oGetEnd:oFont:= TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

nLin+= 18
@ nLin  ,005 Say oTxtEtiq   Var "Etiqueta " Pixel Of oTelaOP
@ nLin-2,045 MsGet oGetEtiq Var _cEtiqueta  Size 70,10 Valid ValidaEtiq() Pixel Of oTelaOP
oTxtEtiq:oFont:= TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
oGetEtiq:oFont:= TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

nLin+= 12
@ nLin  ,005 Say oProdEtiq   Var cProdEtiq Pixel Of oTelaOP

nLin+= 12
@ nLin  ,005 Say oTxtQtd    Var "Quantidade " Pixel Of oTelaOP
@ nLin-2,045 MsGet oGetQtd  Var _nQtd Valid fOkQtd() Picture "@E 9,999,999.99" Size 70,10  Pixel Of oTelaOP
oTxtQtd:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
oGetQtd:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

nLin+= 20
//@ nLin,005 Button "Confirma" Size 40,15 Action fOkQtd() Pixel Of oTelaOP
@ nLin,070 Button "Cancelar" Size 40,15 Action Close(oTelaOp) Pixel Of oTelaOP

Activate MsDialog oTelaOP

Return

//--------------------------------------------------------------------

Static Function fTelaEti()
Private _lReturn:=.T.

_cNumEti  :=XD1->XD1_XXPECA
_cProdEti :=XD1->XD1_COD
_nQtdEti  :=XD1->XD1_QTDATU
_cEndeEti :=XD1->XD1_LOCALI
_cDescEti :=""

SB1->(dbSetOrder(1))
SB1->(dbGotop())
If SB1->( dbSeek(xFilial("SB1")+XD1->XD1_COD))
	_cDescEti := SB1->B1_DESC
EndIf

Define MsDialog oTelaEti Title OemToAnsi("Corre��o Etiqueta") From 0,0 To 293,233 Pixel of oMainEti PIXEL

nLin := 005
@ nLin,005 Say oTxtEti     Var "Etiqueta " Pixel Of oTelaEti
@ nLin-2,045 MsGet oGetEti Var _cNumEti When .F. Size 70,10 Pixel Of oTelaEti

oTxtEti:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
oGetEti:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

@ 018,001 To 057,115 Pixel Of oMainEti PIXEL

@ 020,005 Say oTxtLabel    Var "Dados da Etiqueta" Pixel Of oTelaEti
@ 027,005 Say oTxtProdEti  Var "C�digo: "+ _cProdEti Pixel Of oTelaEti
@ 027,077 Say oTxtQtdEti   Var "Qtd: "+ TransForm(_nQtdEti,"@E 999,999.99") Pixel Of oTelaEti
@ 033,005 Say oTxtDescEti  Var "Descri��o: "+ _cDescEti Size 110,15 Pixel Of oTelaEti
@ 048,005 Say oTxtEndeEti  Var "Endere�o: "+ _cEndeEti Pixel Of oTelaEti

oTxtLabel  :oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
oTxtProdEti:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
oTxtDescEti:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
oTxtEndeEti:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
oTxtQtdEti :oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)

nLin+= 60
@ nLin  ,005 Say oTxtQtdEti    Var "Quantidade " Pixel Of oTelaEti
@ nLin-2,045 MsGet oGetQtdEti  Var _nQtdEti Valid fQtdEti() Picture "@E 9,999,999.99" Size 70,10  Pixel Of oTelaEti
oTxtQtdEti:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
oGetQtdEti:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

nLin+= 20
@ nLin,070 Button "Cancelar" Size 40,15 Action Close(oTelaEti) Pixel Of oTelaEti

Activate MsDialog oTelaEti

Return(_lReturn)

//--------------------------------------------------------------------

Static Function fQtdEti()
Close(oTelaEti)
If _nQtdEti >0
	If _nQtdEti <= SB2->B2_QATU
		DbSelectArea("XD1")
		Reclock("XD1",.F.)
		Replace XD1->XD1_QTDATU With _nQtdEti
		MsUnlock()
	Else
		U_MsgColetor("N�o foi poss�vel realizar o ajuste .Inventarie todo o saldo do produto "+AllTrim(XD1->XD1_COD)+" saldo atual :"+TransForm(SB2->B2_QATU,"@E 999,999.99")+".")
		_cEtiqueta := Space(_nTamEtiq)
		oGetEtiq:Refresh()
		_lReturn   :=.F.
	EndIf
Else
	U_MsgColetor("Informe uma quantidade v�lida.")
EndIf

Return

//--------------------------------------------------------------------

Static Function fValidaOP()
Local _lRet :=.T.
_cProdEmp   := ""
_cDescric   := ""
_cEnderec   := ""
_nQtdEmp    := 0
_aDados     := {}

If Empty(_cNumOP)
	Return .T.
EndIf

_cNumZADOC := ""
cSZASZE    := ""
If Len(Alltrim(_cNumOP)) == 6
	Return fValidaDoc()
Else
	U_MsgColetor("N�o � permitido o pagamento pela OP")
	Return .F.
EndIf

SC2->( dbSetOrder(1) )
SB1->( dbSetOrder(1) )
SBF->( dbSetOrder(2) )

If SC2->( dbSeek(xFilial("SC2")+Subs(_cNumOP,1,11)))
	If SC2->C2_QUANT <> SC2->C2_QUJE
		SZA->( dbSetOrder(1) )
		If SZA->( dbSeek(xFilial()+Subs(_cNumOP,1,11)))
			While xFilial("SZA")+Subs(_cNumOP,1,11) == SZA->ZA_FILIAL+SZA->ZA_OP
				If SB1->( dbSeek( xFilial() + SZA->ZA_PRODUTO ) )
					If SZA->ZA_SALDO > 0
						//If SD4->D4_LOCAL <> '13' .and. SD4->D4_LOCAL <> '99' .and. SB1->B1_TIPO <> 'MO'
						cQuery := "SELECT BF_LOCALIZ FROM " + RetSqlName("SBF") + " WHERE BF_FILIAL = '"+xFilial("SBF")+"' AND BF_PRODUTO = '"+SZA->ZA_PRODUTO+"' AND BF_LOCAL = '"+SB1->B1_LOCPAD+"' AND BF_QUANT <> 0 AND D_E_L_E_T_ = '' "
						
						If Select("TEMP") <> 0
							TEMP->( dbCloseArea() )
						EndIf
						
						TCQUERY cQuery NEW ALIAS  "TEMP"
						
						If !Empty(TEMP->BF_LOCALIZ)
							aadd(_aDados,{SB1->B1_COD,SB1->B1_DESC,TEMP->BF_LOCALIZ,SZA->ZA_SALDO})
						Else
							aadd(_aDados,{SB1->B1_COD,SB1->B1_DESC,' Sem Endere�o',SZA->ZA_SALDO})
						EndIf
						//EndIf
					EndIf
				EndIf
				SZA->( dbSkip() )
			End
		Else
			U_MsgColetor("N�o foram encontrados apontamentos de perda para esta OP.")
		EndIf
	Else
		U_MsgColetor("OP j� encerrada.")
		_lRet:=.F.
	EndIf
Else
	U_MsgColetor("OP n�o encontrada.")
	_lRet:=.F.
EndIf

//aSort (_aDados,,,{|x, y| x[3]<y[3]})

If Empty(_cNumOP)
	_lRet:=.T.
EndIf

_cProdEmp   := ""
_cDescric   := ""
_cEnderec   := "   PERDAS J� ATENDIDAS"
_nQtdEmp    := 0

If Len(_aDados) > 0
	_cProdEmp   := _aDados[1][1]
	_cDescric   := _aDados[1][2]
	_cEnderec   := _aDados[1][3]
	_nQtdEmp    := _aDados[1][4]
	
	cGetEnd     := Space(cTamGetEnd)
Else
	oGetOP:SetFocus()
EndIf

oTelaOP:Refresh()

Return(_lRet)

//---------------------------------------------------------

Static Function ValidaEtiq()
Local _Retorno := .F.
Local _lLote   := .F.
Local _lEnd    := .F.
Local _cLote   := ""
Local _aLote   := {}

XD1->( dbSetOrder(1) )
SB1->( dbSetOrder(1) )
SZA->( dbSetOrder(1) )

If Len(AllTrim(_cEtiqueta))==12 //EAN 13 s/ d�gito verificador.
	_cEtiqueta := "0"+_cEtiqueta
	_cEtiqueta := Subs(_cEtiqueta,1,12)
EndIf

If Len(AllTrim(_cEtiqueta))==20 //CODE 128 c/ d�gito verificador.
	_cEtiqueta := Subs(AllTrim(_cEtiqueta),8,12)
EndIf

oGetEtiq:Refresh()

If !Empty(_cEtiqueta)
	dbSelectArea("XD1")
	XD1->( dbSetOrder(1) )
	If XD1->( dbSeek( xFilial("XD1") + _cEtiqueta ) )
		
		/*
		cQuery := "SELECT MAX(ZC_DATA) AS ULTINVENT FROM " + RetSqlName("SZC") + " WHERE ZC_FILIAL = '"+xFilial("SZC")+"' AND ZC_PRODUTO = '"+XD1->XD1_COD+"' AND D_E_L_E_T_ = '' "
		If Select("QUERYSZC") <> 0
		QUERYSZC->( dbCloseArea() )
		EndIf
		TCQUERY cQuery NEW ALIAS "QUERYSZC"
		//If !_lSaldoEnd .and. SB1->B1_LOCPAD <> '02' .and. SB1->B1_LOCPAD <> '04' .and. SB1->B1_LOCPAD <> '17'
		If QUERYSZC->ULTINVENT >= "20131109"
		U_MsgColetor("Utiliza��o proibida. Material bloqueado por invent�rio.")
		Return .F.
		EndIf
		*/
		
		If Alltrim(XD1->XD1_LOCAL+XD1->XD1_LOCALI) <> Alltrim(cGetEnd)
			U_MsgColetor("Endere�o selecionado diferente da Etiqueta.")
			Return .F.
		EndIf
		
		//Tratamento para etiqueta avulsa.
		//If Empty(XD1->(XD1_DOC+XD1_SERIE+XD1_FORNEC+XD1_LOJA))
		Do Case
			Case XD1->XD1_OCORRE == '5'
				U_MsgColetor('Etiqueta de material j� utilizado.')
				_cEtiqueta  := Space(_nTamEtiq)
				oGetEtiq:Refresh()
				_Retorno := .F.
			Case XD1->XD1_OCORRE == '4'
				_Retorno := .T.
			Case XD1->XD1_QTDATU == 0
				U_MsgColetor('N�o existe saldo para esta etiqueta')
				_cEtiqueta  := Space(_nTamEtiq)
				oGetEtiq:Refresh()
				_Retorno    := .F.
			OtherWise
				U_MsgColetor('Status de Etiqueta desconhecido.')
				_cEtiqueta  := Space(_nTamEtiq)
				oGetEtiq:Refresh()
				_Retorno := .F.
		EndCase
		
		If _Retorno
			If SB1->( dbSeek( xFilial() + XD1->XD1_COD ) )
				//If SZA->( dbSeek( xFilial() + Subs(_cNumOP,1,11) + XD1->XD1_COD ) )
				
				bSldSZA := .F.
				If Empty(_cNumZADOC)
					SZA->( dbSetOrder(1) )  // ZA_FILIAL + ZA_OP
					If SZA->( dbSeek( xFilial() + Subs(_cNumOP,1,11) + XD1->XD1_COD ) )
						While !SZA->( EOF() ) .and. SZA->ZA_OP == Subs(_cNumOP,1,11) .and. SZA->ZA_PRODUTO == XD1->XD1_COD
							If SZA->ZA_SALDO > 0
								bSldSZA := .T.
								Exit
							EndIf
							SZA->( dbSkip() )
						End
						If !bSldSZA
							U_MsgColetor('N�o existe saldo de PERDA deste produto para esta OP a ser pago.')
							_cEtiqueta := Space(_nTamEtiq)
							oGetEtiq:Refresh()
							_Retorno   := .F.
						EndIf
					EndIf
				Else
					SZA->( dbSetOrder(2) ) // ZA_FILIAL + ZA_DOCUMEN
					If SZA->( dbSeek( xFilial() + _cNumZADOC ) )
						If SZA->ZA_PRODUTO <> XD1->XD1_COD
							U_MsgColetor('Produto diferente do apontamento da perda.')
							_cEtiqueta := Space(_nTamEtiq)
							oGetEtiq:Refresh()
							_Retorno   := .F.
						Else
							If SZA->ZA_SALDO > 0
								bSldSZA := .T.
							Else
								U_MsgColetor('Perda j� atendida.')
								_cEtiqueta := Space(_nTamEtiq)
								oGetEtiq:Refresh()
								_Retorno   := .F.
							EndIf
						EndIf
					Else
						SZE->( dbSetOrder(2) )
						If SZE->( dbSeek(xFilial() + _cNumZADOC))
							If SZE->ZE_PRODUTO <> XD1->XD1_COD
								U_MsgColetor('Produto diferente do apontamento da perda de Fornecedor.')
								_cEtiqueta := Space(_nTamEtiq)
								oGetEtiq:Refresh()
								_Retorno   := .F.
							Else
								If SZE->ZE_SALDO > 0
									bSldSZA := .T.
								Else
									U_MsgColetor('Perda de Fornecedor j� atendida.')
									_cEtiqueta := Space(_nTamEtiq)
									oGetEtiq:Refresh()
									_Retorno   := .F.
								EndIf
							EndIf
						Else
							SZX->( dbSetOrder(1) )  // ZX_DOCUMEN
							If SZX->( dbSeek( xFilial() + _cNumZADOC ) )
								If SZX->ZX_PRODUTO <> XD1->XD1_COD
									U_MsgColetor('Produto diferente da Solicita��o de MC.')
									_cEtiqueta := Space(_nTamEtiq)
									oGetEtiq:Refresh()
									_Retorno   := .F.
								Else
									If SZX->ZX_SALDO > 0
										bSldSZA := .T.
									Else
										U_MsgColetor('Solicita��o de MC j� atendida.')
										_cEtiqueta := Space(_nTamEtiq)
										oGetEtiq:Refresh()
										_Retorno   := .F.
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
				
				If _Retorno
					// Verifica se o saldo do SB2 est� no endere�o bipado
					_lOkProc := .T.    //Verifica se a quantidade informada na etiqueta � maior que o saldo atual.
					
					//nSaldoSZA := SZA->ZA_SALDO
					
					SB2->( dbSetOrder(1) )
					If SB2->( dbSeek( xFilial() + XD1->XD1_COD + XD1->XD1_LOCAL ) )
						If SB2->B2_QATU < XD1->XD1_QTDATU
							
							//_lOkProc:=fTelaEti()
							U_MsgColetor('Saldo f�sico (sist�mico) menor que o saldo da etiqueta. Inventarie o produto.')
							_lOkProc := .F.
						EndIf
					EndIf
					
					If _lOkProc
						
						//Verifica o saldo no endere�o+lote.
						_lSaldoEnd:=.F.
						
						SBF->(dbSetOrder(2))
						SBF->(dbGotop())
						If SBF->( dbSeek(xFilial("SBF")+XD1->XD1_COD+XD1->XD1_LOCAL))
							While xFilial("SBF")+XD1->XD1_COD+XD1->XD1_LOCAL == SBF->(BF_FILIAL+BF_PRODUTO+BF_LOCAL)
								
								If AllTrim(SBF->BF_LOCALIZ) == AllTrim(SubStr(cGetEnd,3))
									If (SBF->BF_QUANT-SBF->BF_EMPENHO) >= XD1->XD1_QTDATU
										SB8->(dbSetOrder(3))
										SB8->(dbGotop())
										If SB8->( dbSeek(xFilial("SB8")+XD1->XD1_COD+XD1->XD1_LOCAL+SBF->BF_LOTECTL))
											If SB8->B8_SALDO >= XD1->XD1_QTDATU
												_lSaldoEnd :=.T.
												Exit
											EndIf
										EndIf
									EndIf
								EndIf
								
								SBF->(dbSkip())
							End
						EndIf
						
						If! _lSaldoEnd
							_nSaldoEnd:=0
							
							SBF->(dbSetOrder(2))
							SBF->(dbGotop())
							If SBF->( dbSeek(xFilial("SBF")+XD1->XD1_COD+XD1->XD1_LOCAL))
								Do While !SBF->( Eof() ).And. xFilial("SBF")+XD1->XD1_COD+XD1->XD1_LOCAL == SBF->(BF_FILIAL+BF_PRODUTO+BF_LOCAL).And._nSaldoEnd < XD1->XD1_QTDATU
									
									If AllTrim(SBF->BF_LOCALIZ) <> AllTrim(SubStr(cGetEnd,3))
										If (SBF->BF_QUANT-SBF->BF_EMPENHO) >= XD1->XD1_QTDATU
											Aadd(_aEnd,{SBF->BF_PRODUTO,SBF->BF_LOCAL,SBF->BF_LOCALIZ,SBF->BF_LOTECTL,XD1->XD1_QTDATU})
										ElseIf (SBF->BF_QUANT-SBF->BF_EMPENHO) >0.And.(SBF->BF_QUANT-SBF->BF_EMPENHO) < XD1->XD1_QTDATU
											Aadd(_aEnd,{SBF->BF_PRODUTO,SBF->BF_LOCAL,SBF->BF_LOCALIZ,SBF->BF_LOTECTL,(SBF->BF_QUANT-SBF->BF_EMPENHO)})
										EndIf
									EndIf
									
									_nSaldoEnd += (SBF->BF_QUANT-SBF->BF_EMPENHO)
									SBF->(dbSkip())
								EndDo
							EndIf
							
							For _nCont:=1 To Len(_aEnd)
								
								SB8->(dbSetOrder(3))
								SB8->(dbGotop())
								If SB8->( dbSeek(xFilial("SB8")+_aEnd[_nCont][1]+_aEnd[_nCont][2]+_aEnd[_nCont][4]))
									
									If SB8->B8_DTVALID >= dDataBase //Verifica a data do lote.
										U_ACEDTLOTE()
										SB8->( dbSeek(xFilial("SB8")+_aEnd[_nCont][1]+_aEnd[_nCont][2]+_aEnd[_nCont][4]))
									EndIf
									
									If SB8->B8_DTVALID >= dDataBase //Verifica a data do lote.
										
										fOkProc()
										
									Else
										U_MsgColetor("Verifique a data do Lote "+SB8->B8_LOTECTL+" - "+Dtoc(SB8->B8_DTVALID))
										_cEtiqueta := Space(_nTamEtiq)
										oGetEtiq:Refresh()
										_lReturn   :=.F.
									EndIf
								EndIf
								
							Next _nCont
						Else
							_nQtd:=If(XD1->XD1_QTDATU >= SZA->ZA_SALDO,SZA->ZA_SALDO,XD1->XD1_QTDATU)
						EndIf
						
					EndIf
				EndIf
				
				//If !Empty(XD1->XD1_LOCALI)
				If Alltrim(XD1->XD1_LOCAL+XD1->XD1_LOCALI) <> Alltrim(cGetEnd)
					//Endere�o da etiqueta diferente da bipada
					Reclock("XD1",.F.)
					XD1->XD1_LOCAL  := Subs(cGetEnd,1,2)
					XD1->XD1_LOCALI := Subs(cGetEnd,3)
					XD1->( msUnlock() )
				EndIf
				//EndIf
				//Else
				//	U_MsgColetor('N�o existe apontamento de PERDA do produto '+Alltrim(XD1->XD1_COD)+' para esta OP.')
				//	_Retorno := .F.
				//EndIf
			Else
				U_MsgColetor('Cadastro Produto '+XD1->XD1_COD+' n�o encontrado.')
				_Retorno := .F.
			EndIf
		EndIf
	Else
		U_MsgColetor('C�dido de Etiqueta inv�lido.')
		_cEtiqueta  := Space(_nTamEtiq)
		oGetEtiq:Refresh()
		_Retorno := .F.
	EndIf
	//oGetEtiq:SetFocus()
Else
	_Retorno := .T.
EndIf

Return _Retorno

//---------------------------------------------------------

Static Function fOkProc()
Local _aItem	     := {}
Local _nOpcAuto     := 3 // Indica qual tipo de a��o ser� tomada (Inclus�o/Exclus�o)
Private lMsHelpAuto := .T.
Private lMsErroAuto := .F.
Private _cDoc	     := GetSxENum("SD3","D3_DOC",1)

_aAuto := {}
aadd(_aAuto,{_cDoc,dDataBase})

SB1->(dbSetOrder(1))
SB1->(dbGotop())
If SB1->( dbSeek(xFilial("SB1")+_aEnd[_nCont][1]))
	
	SBE->(dbSetOrder(1))
	SBE->(dbGotop())
	If SBE->( dbSeek(xFilial("SBE")+AllTrim(_aEnd[_nCont][2])+Subs(cGetEnd,3)))
		
		aadd(_aItem,SB1->B1_COD)  	         //Produto Origem
		aadd(_aItem,SB1->B1_DESC)           //Descricao Origem
		aadd(_aItem,SB1->B1_UM)  	         //UM Origem
		aadd(_aItem,_aEnd[_nCont][2])       //Local Origem
		aadd(_aItem,_aEnd[_nCont][3])		   //Endereco Origem
		aadd(_aItem,SB1->B1_COD)  	         //Produto Destino
		aadd(_aItem,SB1->B1_DESC)           //Descricao Destino
		aadd(_aItem,SB1->B1_UM)  	         //UM destino
		aadd(_aItem,_aEnd[_nCont][2])       //Local Destino
		aadd(_aItem,Subs(cGetEnd,3))		   //Endereco Destino
		aadd(_aItem,"")                     //Numero Serie
		aadd(_aItem,_aEnd[_nCont][4])	      //Lote Origem
		aadd(_aItem,"")         	         //Sub Lote Origem
		aadd(_aItem,SB8->B8_DTVALID)	      //Validade Lote Origem
		aadd(_aItem,0)		                  //Potencia
		aadd(_aItem,_aEnd[_nCont][5]) 	   //Quantidade
		aadd(_aItem,0)		                  //Quantidade 2a. unidade
		aadd(_aItem,"")   	               //ESTORNO
		aadd(_aItem,"")         	         //NUMSEQ
		aadd(_aItem,_aEnd[_nCont][4])	      //Lote Destino
		aadd(_aItem,SB8->B8_DTVALID)	      //Validade Lote Destino
		aadd(_aItem,"")		               //D3_ITEMGRD
		If nFCICalc == 1
			aadd(_aItem,0)                      //D3_PERIMP
		ENDIF
		If GetVersao(.F.,.F.) == "12"
			//aAdd(_aItem,"")   //D3_IDDCF
			aAdd(_aItem,"")   //D3_OBSERVACAO
		EndIf
		
		aadd(_aAuto,_aItem)
		
		//Begin Transaction
		
		MSExecAuto({|x,y| mata261(x,y)},_aAuto,_nOpcAuto)
		
		//End Transaction
		
		If lMsErroAuto
			MostraErro("\UTIL\LOG\Transferencia_Pagamento\")
			//DisarmTransaction()
			U_MsgColetor("Erro na transfer�ncia entre endere�os.")
		Else
			_nQtd:=If(XD1->XD1_QTDATU >= SZA->ZA_SALDO,SZA->ZA_SALDO,XD1->XD1_QTDATU)
		EndIf
	Else
		U_MsgColetor("Local destino n�o encontrado ( "+Subs(cGetEnd,3)+"-"+AllTrim(_aEnd[_nCont][2])+" )")
	EndIf
EndIf
Return

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

//---------------------------------------------------------

Static Function fValidEnd()
Local _Retorno := .T.

//nSaldoSZA := 0

If !Empty(cGetEnd)
	SBE->( dbSetOrder(1) )
	If SBE->( dbSeek( xFilial() + Subs(cGetEnd,1,17) ) )
		If SBE->BE_STATUS == '3'
			U_MsgColetor('Endere�o bloqueado para uso.')
			_Retorno := .F.
		EndIf
	Else
		U_MsgColetor('Endere�o inv�lido.')
		_Retorno := .F.
	EndIf
EndIf

Return _Retorno

//-----------------------------------------------------------

Static Function fOkQtd()
Local _Retorno      := .T.
Private lMsHelpAuto := .T.
Private lMsErroAuto := .F.

_cLote :=""

If _nQtd > 0
	If U_uMsgYesNo("Quantidade :"+TransForm(_nQtd,"@E 9,999,999.99"),"Confirma o pagamento ?")
		If cSZASZE == "SZA"  // SZA - Pagamento de Perdas Domex    SZE - Perda de Fornecedores
			_cLote:=If(Empty(XD1->XD1_LOTECTL),"LOTE1308",XD1->XD1_LOTECTL)
			
			//SZA->( dbSetOrder(1) )
			//If SZA->( dbSeek( xFilial() + Rtrim(_cNumOP) + XD1->XD1_COD ) )
			//If cSZASZE == "SZA"
			nSalSZASZE := SZA->ZA_SALDO
			//EndIf
			If _nQtd <= XD1->XD1_QTDATU
				If _nQtd <= nSalSZASZE
					cTM      := '570'  // REQ. PAGAMENTO PERDA DOMEX
					
					aVetor      := {}
					nTipo       := 3
					
					AADD(aVetor,{"D3_TM"      , cTM                , NIL })
					AADD(aVetor,{"D3_OP"      , Subs(_cNumOP,1,11) , NIL })
					AADD(aVetor,{"D3_COD"     , XD1->XD1_COD       , NIL })
					AADD(aVetor,{"D3_EMISSAO" , ddatabase          , NIL })
					AADD(aVetor,{"D3_QUANT"   , _nQtd              , NIL })
					AADD(aVetor,{"D3_LOCAL"   , XD1->XD1_LOCAL     , NIL })
					AADD(aVetor,{"D3_LOTECTL" , _cLote             , NIL })
					AADD(aVetor,{"D3_LOCALIZ" , Subs(cGetEnd,3)    , NIL })
					AADD(aVetor,{"D3_XXPECA"  , XD1->XD1_XXPECA    , NIL })
					AADD(aVetor,{"D3_DOC"     , _cNumZADOC         , NIL })
					
					_nTmpQemp := 0
					SB2->( dbSetOrder(1) )
					If SB2->( dbSeek( xFilial() + XD1->XD1_COD + XD1->XD1_LOCAL ) )
						If !Empty(SB2->B2_QEMP)
							_nTmpQemp := SB2->B2_QEMP
							Reclock("SB2",.F.)
							SB2->B2_QEMP := 0
							SB2->( msUnlock() )
						EndIf
					EndIf
					aAreaSB2 := SB2->( GetArea() )
					MSExecAuto({|x,y| mata240(x,y)},aVetor,nTipo)   	 // Movimenta��o Interna
					RestArea(aAreaSB2)
					
					If !Empty(_nTmpQemp)
						Reclock("SB2",.F.)
						SB2->B2_QEMP := _nTmpQemp
						SB2->( msUnlock() )
					EndIf
					
					If lMsErroAuto
						MostraErro("\UTIL\LOG\Pagamento_Perda_Domex\")
						//DisarmTransaction()
						U_MsgColetor("Erro no pagamento de perda para OP.")
					Else
						Reclock("XD1",.F.)
						XD1->XD1_QTDATU -= _nQtd
						
						nSaldoSZA       -= _nQtd
						
						If XD1->XD1_QTDATU <= 0
							XD1->XD1_OCORRE := '5'
						EndIf
						XD1->( msUnlock() )
						
						If cSZASZE == "SZA"
							Reclock("SZA",.F.)
							SZA->ZA_SALDO -= _nQtd
							SZA->( msUnlock() )
						EndIf
						
						_nQtd := 0
						_cEtiqueta     := Space(_nTamEtiq)
						oGetEtiq:Refresh()
						oGetEtiq:SetFocus()
					EndIf
				Else
					U_MsgColetor('Quantidade superior ao saldo da Perda.')
					_Retorno := .F.
				EndIf
			Else
				U_MsgColetor('Quantidade superior a da etiqueta. Se estiver correta, favor inventariar o material.')
				_Retorno := .F.
			EndIf
			//Else
			//	U_MsgColetor('N�o foi encontrado empenho deste produto para esta OP.')
			//	_Retorno := .F.
			//EndIf
		EndIf
		
		If cSZASZE == "SZE"  // SZA - Pagamento de Perdas Domex    SZE - Perda de Fornecedores
			_cLote := If(Empty(XD1->XD1_LOTECTL),"LOTE1308",XD1->XD1_LOTECTL)
			
			nSalSZASZE := SZE->ZE_SALDO
			_nOpcAuto  := 3
			
			If _nQtd <= XD1->XD1_QTDATU
				If _nQtd <= nSalSZASZE
					If SB1->( dbSeek( xFilial() + XD1->XD1_COD ) )
						
						_aAuto := {}
						
						Private _cDoc	        := U_NEXTDOC() //GetSxENum("SD3","D3_DOC",1)
						_cDoc := _cDoc+SPACE(09)               //DOCUMENTO 9 DIGITOS
						
						_cDoc := SUBSTR(_cDoc,1,9)
						
						aadd(_aAuto,{_cDoc,dDataBase})
						
						_aItem := {}
						aadd(_aItem,XD1->XD1_COD)           //Produto Origem
						aadd(_aItem,SB1->B1_DESC)           //Descricao Origem
						aadd(_aItem,SB1->B1_UM)  	         //UM Origem
						aadd(_aItem,XD1->XD1_LOCAL)         //Local Origem
						aadd(_aItem,XD1->XD1_LOCALIZ)		   //Endereco Origem
						aadd(_aItem,XD1->XD1_COD)           //Produto Destino
						aadd(_aItem,SB1->B1_DESC)           //Descricao Destino
						aadd(_aItem,SB1->B1_UM)  	         //UM destino
						aadd(_aItem,cLocProcDom)            //Local Destino
						aadd(_aItem,"97PROCESSO")	   	   //Endereco Destino
						aadd(_aItem,"")                     //Numero Serie
						aadd(_aItem,XD1->XD1_LOTECTL)	      //Lote Origem
						aadd(_aItem,"")         	         //Sub Lote Origem
						aadd(_aItem,CtoD("31/12/49"))	      //Validade Lote Origem
						aadd(_aItem,0)		                  //Potencia
						aadd(_aItem,_nQtd)            	   //Quantidade
						aadd(_aItem,0)		                  //Quantidade 2a. unidade
						aadd(_aItem,"")   	               //ESTORNO
						aadd(_aItem,"")         	         //NUMSEQ
						//aadd(_aItem,XD1->XD1_LOTECTL)	   //Lote Destino
						aadd(_aItem,U_RETLOTC6(_cNumOP))    //Lote Destino
						aadd(_aItem,CtoD("31/12/49"))	      //Validade Lote Destino
						aadd(_aItem,"")		               //D3_ITEMGRD
						If nFCICalc == 1
							aadd(_aItem,0)                      //D3_PERIMP
						ENDIF
						If GetVersao(.F.,.F.) == "12"
							//aAdd(_aItem,"")   //D3_IDDCF
							aAdd(_aItem,"")   //D3_OBSERVACAO
						EndIf
						aadd(_aAuto,_aItem)
						
						lMsErroAuto := .F.
						
						MSExecAuto({|x,y| mata261(x,y)},_aAuto,_nOpcAuto)  // Execauto de transfer�ncia para o 97
						
						If lMsErroAuto
							MostraErro("\UTIL\LOG\Pagamento_perda_fornecedores\")
							//DisarmTransaction()
							U_MsgColetor("Erro no pagamento de perda de Fornecedores.")
							//Else
							//_nQtd := If(XD1->XD1_QTDATU >= SD4->D4_QUANT,SD4->D4_QUANT,XD1->XD1_QTDATU)
						Else
							SD3->( dbSetOrder(2) )  // D3_FILIAL + D3_DOC
							If SD3->( dbSeek( xFilial() + _cDoc ) )
								While !SD3->( EOF() ) .and. ALLTRIM(SD3->D3_DOC) == ALLTRIM(_cDoc)
									
									If SD3->D3_CF == 'RE4' .or. SD3->D3_CF == 'DE4'
										If SD3->D3_COD == XD1->XD1_COD
											If SD3->D3_EMISSAO == dDataBase
												If SD3->D3_QUANT == _nQtd
													If Empty(SD3->D3_XXOP)
														
														Reclock("SD3",.F.)
														SD3->D3_XXPECA  := XD1->XD1_XXPECA
														SD3->D3_XXOP    := Subs(_cNumOP,1,11)
														SD3->D3_USUARIO := cUsuario
														SD3->D3_HORA    := Time()
														SD3->( msUnlock() )
										
													EndIf
												EndIf
											EndIf
										EndIf
									EndIf
									
									SD3->( dbSkip() )
								End
							EndIf
							
							Reclock("XD1",.F.)
							XD1->XD1_QTDATU := XD1->XD1_QTDATU - _nQtd
							If XD1->XD1_QTDATU <= 0
								XD1->XD1_OCORRE := '5'
							EndIf
							XD1->( msUnlock() )
							
							If XD1->XD1_QTDATU <= 0
								U_MsgColetor("Confirma saldo restante de " + Alltrim(Transform(XD1->XD1_QTDATU,"@E 999,999,999.9999")) + " na etiqueta?")
							EndIf
							
							Reclock("SZE",.F.)
							SZE->ZE_SALDO -= _nQtd
							SZE->( msUnlock() )
							
							_nQtd := 0
							_cEtiqueta     := Space(_nTamEtiq)
							oGetEtiq:Refresh()
							oGetEtiq:SetFocus()
						EndIf
					EndIf
				Else
					U_MsgColetor('Quantidade superior ao saldo da Perda.')
					_Retorno := .F.
				EndIf
			Else
				U_MsgColetor('Quantidade superior a da etiqueta. Se estiver correta, favor inventariar o material.')
				_Retorno := .F.
			EndIf
		EndIf
		
		If cSZASZE == "SZX"  // Pagamento Solicita��o de Materiais de Consumo
			_cLote:=If(Empty(XD1->XD1_LOTECTL),"LOTE1308",XD1->XD1_LOTECTL)
			
			nSalSZASZE := SZX->ZX_SALDO
			//EndIf
			If _nQtd <= XD1->XD1_QTDATU
				If _nQtd <= nSalSZASZE
					
					//U_SD4PERDA(XD1->XD1_COD,D1->XD1_LOCAL,_cLote, _nQtd   )
					
					cTM      := '540'  // REQ. PAGAMENTO PERDA DOMEX
					
					aVetor      := {}
					nTipo       := 3
					
					AADD(aVetor,{"D3_TM"      , cTM                , NIL })
					//AADD(aVetor,{"D3_OP"    , Subs(_cNumOP,1,11) , NIL })
					AADD(aVetor,{"D3_COD"     , XD1->XD1_COD       , NIL })
					AADD(aVetor,{"D3_EMISSAO" , ddatabase          , NIL })
					AADD(aVetor,{"D3_QUANT"   , _nQtd              , NIL })
					AADD(aVetor,{"D3_LOCAL"   , XD1->XD1_LOCAL     , NIL })
					AADD(aVetor,{"D3_LOTECTL" , _cLote             , NIL })
					AADD(aVetor,{"D3_LOCALIZ" , Subs(cGetEnd,3)    , NIL })
					AADD(aVetor,{"D3_XXPECA"  , XD1->XD1_XXPECA    , NIL })
					AADD(aVetor,{"D3_DOC"     , _cNumZADOC         , NIL })
					
					_nTmpQemp := 0
					SB2->( dbSetOrder(1) )
					If SB2->( dbSeek( xFilial() + XD1->XD1_COD + XD1->XD1_LOCAL ) )
						If !Empty(SB2->B2_QEMP)
							_nTmpQemp := SB2->B2_QEMP
							Reclock("SB2",.F.)
							SB2->B2_QEMP := 0
							SB2->( msUnlock() )
						EndIf
					EndIf
					aAreaSB2 := SB2->( GetArea() )
					MSExecAuto({|x,y| mata240(x,y)},aVetor,nTipo)   	 // Movimenta��o Interna
					RestArea(aAreaSB2)
					
					If !Empty(_nTmpQemp)
						Reclock("SB2",.F.)
						SB2->B2_QEMP := _nTmpQemp
						SB2->( msUnlock() )
					EndIf
					
					If lMsErroAuto
						MostraErro("\UTIL\LOG\Pagamento_Material_consumo\")
						//DisarmTransaction()
						U_MsgColetor("Erro no pagamento de Material de Consumo.")
					Else
						Reclock("XD1",.F.)
						XD1->XD1_QTDATU -= _nQtd
						
						nSaldoSZA       -= _nQtd
						
						If XD1->XD1_QTDATU <= 0
							XD1->XD1_OCORRE := '5'
						EndIf
						XD1->( msUnlock() )
						
						Reclock("SZX",.F.)
						SZX->ZX_SALDO -= _nQtd
						SZX->( msUnlock() )
						
						_nQtd := 0
						_cEtiqueta     := Space(_nTamEtiq)
						oGetEtiq:Refresh()
						oGetEtiq:SetFocus()
						
					EndIf
				Else
					U_MsgColetor('Quantidade superior a Solicita��o de MC.')
					_Retorno := .F.
				EndIf
			Else
				U_MsgColetor('Quantidade superior a da etiqueta. Se estiver correta, favor inventariar o material.')
				_Retorno := .F.
			EndIf
		EndIf
		
	Else
		_nQtd := 0
		_cEtiqueta     := Space(_nTamEtiq)
		oGetEtiq:Refresh()
		oGetEtiq:SetFocus()
	EndIf
Else
	_nQtd := 0
	_cEtiqueta     := Space(_nTamEtiq)
	oGetEtiq:Refresh()
	oGetEtiq:SetFocus()
EndIf

Return _Retorno

Static Function fValidaDoc()
Local _Retorno := .T.

SC2->( dbSetOrder(1) )
SB1->( dbSetOrder(1) )
SBF->( dbSetOrder(2) )
SZA->( dbSetORder(2) )  // ZA_FILIAL + ZA_DOC

_cNumZADOC := Subs(_cNumOP,1,6)

// SZA - Perda da Produ��o
SZA->( dbSetOrder(2) )
If SZA->( dbSeek(xFilial()+_cNumZADOC))
	
	cSZASZE := "SZA"
	
	If SC2->( dbSeek(xFilial()+SZA->ZA_OP))
		If !Empty(SC2->C2_DATRF)
			U_MsgColetor("Ordem de Produ��o   encerrada em        " + DtoC(SC2->C2_DATRF)+".")
			_Retorno := .F.
		Else
			_cNumOP        := SZA->ZA_OP
			
			If SC2->C2_QUANT <> SC2->C2_QUJE
				If SB1->( dbSeek( xFilial() + SZA->ZA_PRODUTO ) )
					If SZA->ZA_SALDO > 0
						nSaldoSZA := SZA->ZA_SALDO
						
						cQuery := "SELECT BF_LOCALIZ FROM " + RetSqlName("SBF") + " WHERE BF_FILIAL = '"+xFilial("SBF")+"' AND BF_PRODUTO = '"+SZA->ZA_PRODUTO+"' AND BF_LOCAL = '"+SB1->B1_LOCPAD+"' AND BF_QUANT <> 0 AND D_E_L_E_T_ = '' "
						
						If Select("TEMP") <> 0
							TEMP->( dbCloseArea() )
						EndIf
						
						TCQUERY cQuery NEW ALIAS  "TEMP"
						
						If !Empty(TEMP->BF_LOCALIZ)
							aadd(_aDados,{SB1->B1_COD,SB1->B1_DESC,TEMP->BF_LOCALIZ,SZA->ZA_SALDO})
						Else
							aadd(_aDados,{SB1->B1_COD,SB1->B1_DESC,' Sem Endere�o',SZA->ZA_SALDO})
						EndIf
					Else
						U_MsgColetor("Perda j� atendida.")
						_Retorno := .F.
					EndIf
				Else
					U_MsgColetor("Produto do apontamento de perda n�o encontrado.")
					_Retorno := .F.
				EndIf
			Else
				U_MsgColetor("OP j� encerrada.")
				_Retorno := .F.
			EndIf
		EndIf
	Else
		U_MsgColetor("OP n�o encontrada.")
		_Retorno := .F.
	EndIf
Else
	
	// SZE - Perda de Fornecedor
	SZE->( dbSetOrder(2) )
	If SZE->( dbSeek(xFilial() + _cNumZADOC))
		
		cSZASZE := "SZE"
		
		If SC2->( dbSeek(xFilial()+SZE->ZE_OP))
			_cNumOP        := SZE->ZE_OP
			
			If SC2->C2_QUANT <> SC2->C2_QUJE
				If SB1->( dbSeek( xFilial() + SZE->ZE_PRODUTO ) )
					If SZE->ZE_SALDO > 0
						nSaldoSZA := SZE->ZE_SALDO
						
						cQuery := "SELECT BF_LOCALIZ FROM " + RetSqlName("SBF") + " WHERE BF_FILIAL = '"+xFilial("SBF")+"' AND BF_PRODUTO = '"+SZE->ZE_PRODUTO+"' AND BF_LOCAL = '"+SB1->B1_LOCPAD+"' AND BF_QUANT <> 0 AND D_E_L_E_T_ = '' "
						
						If Select("TEMP") <> 0
							TEMP->( dbCloseArea() )
						EndIf
						
						TCQUERY cQuery NEW ALIAS  "TEMP"
						
						If !Empty(TEMP->BF_LOCALIZ)
							aadd(_aDados,{SB1->B1_COD,SB1->B1_DESC,TEMP->BF_LOCALIZ,SZE->ZE_SALDO})
						Else
							aadd(_aDados,{SB1->B1_COD,SB1->B1_DESC,' Sem Endere�o',SZE->ZE_SALDO})
						EndIf
					Else
						U_MsgColetor("Perda de Fornecedor j� atendida.")
						_Retorno := .F.
					EndIf
				Else
					U_MsgColetor("Produto do apontamento de perda n�o encontrado.")
					_Retorno := .F.
				EndIf
			Else
				U_MsgColetor("OP j� encerrada.")
				_Retorno := .F.
			EndIf
		Else
			U_MsgColetor("OP n�o encontrada.")
			_Retorno := .F.
		EndIf
		
	Else
		
		// SZX - Materiais de consumo
		SZX->( dbSetOrder(1) )
		If SZX->( dbSeek(xFilial()+_cNumZADOC))
			If SB1->( dbSeek( xFilial() + SZX->ZX_PRODUTO ) )
				cSZASZE := "SZX"
				
				If SZX->ZX_SALDO > 0
					nSaldoSZA := SZX->ZX_SALDO
					
					cQuery := "SELECT BF_LOCALIZ FROM " + RetSqlName("SBF") + " WHERE BF_FILIAL = '"+xFilial("SBF")+"' AND BF_PRODUTO = '"+SZX->ZX_PRODUTO+"' AND BF_LOCAL = '"+SB1->B1_LOCPAD+"' AND BF_QUANT <> 0 AND D_E_L_E_T_ = '' "
					
					If Select("TEMP") <> 0
						TEMP->( dbCloseArea() )
					EndIf
					
					TCQUERY cQuery NEW ALIAS  "TEMP"
					
					If !Empty(TEMP->BF_LOCALIZ)
						aadd(_aDados,{SB1->B1_COD,SB1->B1_DESC,TEMP->BF_LOCALIZ,SZX->ZX_SALDO})
					Else
						aadd(_aDados,{SB1->B1_COD,SB1->B1_DESC,' Sem Endere�o',SZX->ZX_SALDO})
					EndIf
				Else
					U_MsgColetor("Perda j� atendida.")
					_Retorno := .F.
				EndIf
			Else
				U_MsgColetor("Produto da Solicita��o de MC n�o encontrado.")
				_Retorno := .F.
			EndIf
		Else
			If !Empty(_cNumZADOC)
				U_MsgColetor("Documento " + _cNumZADOC + " de apontamento de peda n�o encontrado.")
				_Retorno := .F.
			Else
				_Retorno := .T.
			EndIf
		EndIf
	EndIf
EndIf

_cProdEmp   := ""
_cDescric   := ""
_cEnderec   := "   PERDAS J� ATENDIDAS"
_nQtdEmp    := 0

If Len(_aDados) > 0
	_cProdEmp   := _aDados[1][1]
	_cDescric   := _aDados[1][2]
	_cEnderec   := _aDados[1][3]
	_nQtdEmp    := _aDados[1][4]
	
	cGetEnd     := Space(cTamGetEnd)
Else
	oGetOP:SetFocus()
EndIf

oTelaOP:Refresh()

Return _Retorno
