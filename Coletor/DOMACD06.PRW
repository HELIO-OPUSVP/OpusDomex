#include "TbiConn.ch"
#include "TbiCode.ch"
#include "Rwmake.ch"
#include "Topconn.ch"
#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DOMACD06  ºAutor  ³Helio Ferreira      º Data ³  05/29/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Materiais Apropriação Indireta (Kamban)                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMACD06()
Local cTitulo:=  ""
Private oTxtOP,oGetOP,oTxtEtiq,oGetEtiq,oTxtProd,oGetProd,oTxtQtd,oGetQtd,oMark,oTxtQtdEmp,oMainEti
Private _nTamEtiq      := 21
Private _cNumOP        := Space(Len(CriaVar("D3_OP",.F.)))
Private _cEtiqueta     := Space(_nTamEtiq) // Space(Len(CriaVar("XD1_XXPECA",.F.)))
Private _cProduto      := CriaVar("B1_COD",.F.)
Private _nQtd          := CriaVar("XD1_QTDATU",.F.)
Private _cLoteEti      := CriaVar("BF_LOTECTL",.F.)
Private _aCols         := {}
Private _lAuto	        := .T.
Private _lIndividual   := .T.
Private _cCodInv
Private cGetEnd        := Space(2+15+1)
Private _cProdEmp	     := Space(15)
Private _cDescric	     := Space(27)
Private _cEnderec	     := Space(15)
Private cGetProd       := Space(15)
Private _aDados        := {}
Private _aEnd          := {}
Private _nCont
Private nFCICalc       := SuperGetMV("MV_FCICALC",.F.,0)

Private aEmpSB2      := {}
Private aEMpQTNPB2   := {}
Private aEmpSBF      := {}
Private aEmpSB8      := {}
Private aSD4QUANT    := {}

if cFilAnt == "01"
	cTitulo:= "Materiais Apropriação Indireta"
ElseIf cFilAnt == '02'
	cTitulo:= "Kamban MG"
Endif

Define MsDialog oTelaOP Title OemToAnsi(cTitulo) From 0,0 To 293,233 Pixel of oMainWnd PIXEL

nLin := 005

@ nLin  ,005 Say oTxtEnd   Var "Produto "  Pixel Of oTelaOP
@ nLin-2,045 MsGet oGetProd Var cGetProd Valid fValidProd() Size 70,10  Pixel Of oTelaOP
oTxtEnd:oFont:= TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
oGetProd:oFont:= TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

nLin+= 20
@ nLin  ,005 Say oTxtEnd   Var "Endereço "  Pixel Of oTelaOP
@ nLin-2,045 MsGet oGetEnd Var cGetEnd Valid fValidEnd() Size 70,10  Pixel Of oTelaOP
oTxtEnd:oFont:= TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
oGetEnd:oFont:= TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

nLin+= 20
@ nLin  ,005 Say oTxtEtiq   Var "Etiqueta " Pixel Of oTelaOP
@ nLin-2,045 MsGet oGetEtiq Var _cEtiqueta  Size 70,10 Valid ValidaEtiq() Pixel Of oTelaOP
oTxtEtiq:oFont:= TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
oGetEtiq:oFont:= TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

nLin+= 20
@ nLin  ,005 Say oTxtQtd    Var "Quantidade " Pixel Of oTelaOP
@ nLin-2,045 MsGet oGetQtd  Var _nQtd Valid fOkQtd() Picture "@E 9,999,999.99" Size 70,10  Pixel Of oTelaOP
oTxtQtd:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
oGetQtd:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

nLin+= 20
@ nLin,001 To nLin + 39,115 Pixel Of oMainWnd PIXEL

@ nLin+000,005 Say oTxtLabelOP  Var "Produto selecionado:"                    Pixel Of oTelaOP
@ nLin+007,005 Say oTxtProdEmp  Var "Código: "    + _cProdEmp                 Pixel Of oTelaOP
@ nLin+013,005 Say oTxtDescric  Var "Descrição: " + _cDescric     Size 110,15 Pixel Of oTelaOP
@ nLin+028,005 Say oTxtEndere   Var "Endereço: "   + _cEnderec                 Pixel Of oTelaOP

oTxtLabelOP:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
oTxtProdEmp:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
oTxtDescric:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
oTxtEnderec:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)

nLin+= 40

@ nLin,070 Button "Cancelar" Size 40,15 Action Close(oTelaOp) Pixel Of oTelaOP

Activate MsDialog oTelaOP

Return

//--------------------------------------------------------------------

Static Function fValidaOP()
Local _lRet :=.T.
_cProdEmp   := ""
_cDescric   := ""
_cEnderec   := ""

If Empty(_cNumOP)
	Return .T.
EndIf

SC2->( dbSetOrder(1) )
SB1->( dbSetOrder(1) )
SBF->( dbSetOrder(2) )

If SC2->(dbSeek(xFilial("SC2")+_cNumOP))
	If SC2->C2_QUANT <> SC2->C2_QUJE
		SD4->(dbSetOrder(2))
		If SD4->(dbSeek(xFilial("SD4")+_cNumOP))
			While xFilial("SD4")+_cNumOP == SD4->D4_FILIAL+SD4->D4_OP
				If SB1->( dbSeek( xFilial() + SD4->D4_COD ) )
					If SD4->D4_QUANT > 0
						If SD4->D4_LOCAL <> '13' .and. SD4->D4_LOCAL <> '99' .and. SB1->B1_TIPO <> 'MO'
							If SBF->(dbSeek(xFilial("SBF")+SD4->D4_COD+SD4->D4_LOCAL))
								If (SBF->BF_QUANT-SBF->BF_EMPENHO) >0
									aadd(_aDados,{SB1->B1_COD,SB1->B1_DESC,SBF->BF_LOCALIZ,SD4->D4_QUANT})
								Else
									aadd(_aDados,{SB1->B1_COD,SB1->B1_DESC,' Sem Endereço',SD4->D4_QUANT})
								EndIf
							Else
								aadd(_aDados,{SB1->B1_COD,SB1->B1_DESC,' Sem Endereço',SD4->D4_QUANT})
							EndIf
						EndIf
					EndIf
				EndIf
				SD4->(dbSkip())
			End
		EndIf
	Else
		U_MsgColetor("OP já encerrada.")
		_lRet:=.F.
	EndIf
Else
	U_MsgColetor("OP não encontrada.")
	_lRet:=.F.
EndIf
aSort (_aDados,,,{|x, y| x[3]<y[3]})
If Empty(_cNumOP)
	_lRet:=.T.
EndIf

_cProdEmp   := "OP PAGA"
_cDescric   := "Todos os empenhos foram"
_cEnderec   := "atendidos."
_nQtdEmp    := 0

If Len(_aDados)>0
	_cProdEmp   := _aDados[1][1]
	_cDescric   := _aDados[1][2]
	_cEnderec   := _aDados[1][3]
	_nQtdEmp    := _aDados[1][4]
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
SD4->( dbSetOrder(1) )

If Len(AllTrim(_cEtiqueta))==12 //EAN 13 s/ dígito verificador.
	_cEtiqueta := "0"+_cEtiqueta
	_cEtiqueta := Subs(_cEtiqueta,1,12)
	oGetEtiq:Refresh()
EndIf

If Len(AllTrim(_cEtiqueta))==20 //CODE 128 c/ dígito verificador.
	_cEtiqueta := Subs(AllTrim(_cEtiqueta),8,12)
	oGetEtiq:Refresh()
EndIf

If !Empty(_cEtiqueta)
	XD1->( dbSetOrder(1) )
	SB1->( dbSetOrder(1) )
	If XD1->( dbSeek( xFilial("XD1") + _cEtiqueta ) )
	
		//cQuery := "SELECT MAX(ZC_DATA) AS ULTINVENT FROM " + RetSqlName("SZC") + " WHERE ZC_FILIAL = '"+xFilial("SZC")+"' AND ZC_PRODUTO = '"+XD1->XD1_COD+"' AND D_E_L_E_T_ = '' "
		//If Select("QUERYSZC") <> 0
		//	QUERYSZC->( dbCloseArea() )
		//EndIf
		//TCQUERY cQuery NEW ALIAS "QUERYSZC"
		//If !_lSaldoEnd .and. SB1->B1_LOCPAD <> '02' .and. SB1->B1_LOCPAD <> '04' .and. SB1->B1_LOCPAD <> '17'
		//If QUERYSZC->ULTINVENT >= "20131109"
		//	U_MsgColetor("Utilização proibida. Material bloqueado por inventário.")
		//	Return .F.
		//EndIf

  		If Alltrim(XD1->XD1_LOCAL+XD1->XD1_LOCALI) <> Alltrim(cGetEnd)
			U_MsgColetor("Endereço selecionado diferente da Etiqueta.")
			Return .F.
	   EndIf

		If SB1->( dbSeek( xFilial() + XD1->XD1_COD ) )
			If Rastro(XD1->XD1_COD)
				If Localiza(XD1->XD1_COD)
					If SB1->B1_APROPRI == 'I'
						If XD1->XD1_OCORRE == '1'
							U_MsgColetor('A Nota Fiscal de Entrada deste material não foi classificada.')
							_cEtiqueta  := Space(_nTamEtiq)
							oGetEtiq:Refresh()
							_Retorno := .F.
						Else
							If XD1->XD1_OCORRE == '2'
								U_MsgColetor('Etiqueta de material com pendência de liberação pelo CQ.')
								_cEtiqueta  := Space(_nTamEtiq)
								oGetEtiq:Refresh()
								_Retorno := .F.
							Else
								If XD1->XD1_OCORRE == '3'
									U_MsgColetor('Etiqueta não endereçada.')
									_cEtiqueta  := Space(_nTamEtiq)
									oGetEtiq:Refresh()
									_Retorno := .F.
								Else
									If XD1->XD1_OCORRE == '5'
										U_MsgColetor('Etiqueta de material já utilizado.')
										_cEtiqueta  := Space(_nTamEtiq)
										oGetEtiq:Refresh()
										_Retorno := .F.
									Else
										If XD1->XD1_OCORRE $ ('4')
											_Retorno := .T.
										Else
											U_MsgColetor('Status de Etiqueta desconhecido.')
											_cEtiqueta  := Space(_nTamEtiq)
											oGetEtiq:Refresh()
											_Retorno := .F.
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
						
						If _Retorno
							// Status de etiqueta válido
							
							//If _lLote.And._lEnd
							
							If XD1->XD1_QTDATU == 0
								U_MsgColetor('Não existe saldo para esta etiqueta')
								_cEtiqueta  := Space(_nTamEtiq)
								oGetEtiq:Refresh()
								_Retorno    := .F.
							Else  
							   
							   _lOkProc :=.T.
							   
								SB2->( dbSetOrder(1) )
								If SB2->( dbSeek( xFilial() + XD1->XD1_COD + XD1->XD1_LOCAL ) )
									If SB2->B2_QATU < XD1->XD1_QTDATU
										//U_MsgColetor('Saldo da Etiqueta superior ao saldo atual do produto. Inventarie todo material ' + XD1->XD1_COD)
										//_cEtiqueta  := Space(_nTamEtiq)
										//oGetEtiq:Refresh()
										//_Retorno    := .F.
										
										_lOkProc:=fTelaEti()
										
									EndIf	
										
									If _lOkProc 
										//Verifica o saldo no endereço+lote.
										_lSaldoEnd:=.F.
										
										SBF->( dbSetOrder(2) )
										//SBF->(dbGotop())
										If SBF->(dbSeek(xFilial()+XD1->XD1_COD+XD1->XD1_LOCAL))
											While xFilial("SBF")+XD1->XD1_COD+XD1->XD1_LOCAL == SBF->BF_FILIAL+SBF->BF_PRODUTO+SBF->BF_LOCAL
												If AllTrim(SBF->BF_LOCALIZ) == AllTrim(SubStr(cGetEnd,3))
													If (SBF->BF_QUANT-SBF->BF_EMPENHO) >= XD1->XD1_QTDATU
														SB8->(dbSetOrder(3))
														//SB8->(dbGotop())
														If SB8->(dbSeek(xFilial()+XD1->XD1_COD+XD1->XD1_LOCAL+XD1->XD1_LOTECT))
															If SB8->B8_SALDO >= XD1->XD1_QTDATU
																_lSaldoEnd :=.T.
																Exit
															EndIf
														EndIf
													EndIf
												EndIf
												SBF->( dbSkip() )
											End
										EndIf
										
										If _lSaldoEnd

											_nQtd     := XD1->XD1_QTDATU
											
										Else  
											 _nSaldoEnd:=0
									
									       SBF->(dbSetOrder(2))
									       SBF->(dbGotop())
									       If SBF->(dbSeek(xFilial("SBF")+XD1->XD1_COD+XD1->XD1_LOCAL))
										       Do While.Not.Eof().And.xFilial("SBF")+XD1->XD1_COD+XD1->XD1_LOCAL == SBF->(BF_FILIAL+BF_PRODUTO+BF_LOCAL).And._nSaldoEnd < XD1->XD1_QTDATU

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
										        If SB8->(dbSeek(xFilial("SB8")+_aEnd[_nCont][1]+_aEnd[_nCont][2]+_aEnd[_nCont][4]))
										        
										           If SB8->B8_DTVALID >= dDataBase //Verifica a data do lote.
										             U_ACEDTLOTE()
										             SB8->(dbSeek(xFilial("SB8")+_aEnd[_nCont][1]+_aEnd[_nCont][2]+_aEnd[_nCont][4]))
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
										
											/*U_MsgColetor("Divergência de saldo por lote/endereço. Inventarie todo material " + Alltrim(XD1->XD1_COD)+'.')
											_cEtiqueta := Space(_nTamEtiq)
											oGetEtiq:Refresh()
											_lReturn   :=.F.*/
										EndIf
										
									EndIf
								Else
									U_MsgColetor('SB2 não encontrado para esta etiqueta.')
									_Retorno := .F.
								EndIf
							EndIf
						EndIf
					Else
						U_MsgColetor('Esta rotina só deve ser usada para produtos com apropriação indireta ('+GetMv('MV_LOCPROC')+').')
						_Retorno := .F.
					EndIf
				Else
					U_MsgColetor('Rotina permitida apenas para produtos com controle de Endereçamento.')
					_Retorno := .F.
				EndIf
			Else
				U_MsgColetor('Rotina permitida apenas para produtos com controle de Lote.')
				_Retorno := .F.
			EndIf
		Else
			U_MsgColetor('Produto da etiqueta não inválido.')
			_Retorno := .F.
		EndIf
	Else
		U_MsgColetor('Códido de Etiqueta inválido.')
		_cEtiqueta  := Space(_nTamEtiq)
		oGetEtiq:Refresh()
		_Retorno := .F.
	EndIf
	//oGetEtiq:SetFocus()
	oTelaOP:Refresh()
Else
	_Retorno := .T.
EndIf

Return _Retorno

//---------------------------------------------------------

Static Function fTelaEti()
Private _lReturn:=.T.

_cNumEti  :=XD1->XD1_XXPECA
_cProdEti :=XD1->XD1_COD
_nQtdEti  :=XD1->XD1_QTDATU
_cEndeEti :=XD1->XD1_LOCALI
_cDescEti :=""

SB1->(dbSetOrder(1))
SB1->(dbGotop())
If SB1->(dbSeek(xFilial("SB1")+XD1->XD1_COD))
	_cDescEti := SB1->B1_DESC
EndIf

SB2->( dbSetOrder(1) )
If !SB2->( dbSeek( xFilial() + XD1->XD1_COD + XD1->XD1_LOCAL ) )
   U_MsgColetor("SB2 não encontrado.")
EndIf

Define MsDialog oTelaEti Title OemToAnsi("Correção Etiqueta") From 0,0 To 293,233 Pixel of oMainEti PIXEL

nLin := 005
@ nLin,005 Say oTxtEti     Var "Etiqueta " Pixel Of oTelaEti
@ nLin-2,045 MsGet oGetEti Var _cNumEti When .F. Size 70,10 Pixel Of oTelaEti

oTxtEti:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
oGetEti:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

@ 018,001 To 057,115 Pixel Of oMainEti PIXEL

@ 020,005 Say oTxtLabel    Var "Dados da Etiqueta" Pixel Of oTelaEti
@ 027,005 Say oTxtProdEti  Var "Código: "+ _cProdEti Pixel Of oTelaEti
@ 027,077 Say oTxtQtdEti   Var "Qtd: "+ TransForm(_nQtdEti,"@E 999,999.99") Pixel Of oTelaEti
@ 033,005 Say oTxtDescEti  Var "Descrição: "+ _cDescEti Size 110,15 Pixel Of oTelaEti
@ 048,005 Say oTxtEndeEti  Var "Endereço: "+ _cEndeEti Pixel Of oTelaEti

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

//---------------------------------------------------------

Static Function fQtdEti()
Close(oTelaEti)
If _nQtdEti >0
	If _nQtdEti <= SB2->B2_QATU
		DbSelectArea("XD1")
		Reclock("XD1",.F.)
		Replace XD1->XD1_QTDATU With _nQtdEti
		XD1->( MsUnlock() )
	Else
		U_MsgColetor("Não foi possível realizar o ajuste . Saldo atual :"+TransForm(SB2->B2_QATU,"@E 999,999.99")+".")
		_cEtiqueta := Space(_nTamEtiq)
		oGetEtiq:Refresh()
		_lReturn   :=.F.
	EndIf
Else
	U_MsgColetor("Informe uma quantidade válida.")
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

If !Empty(cGetEnd)
	SBE->( dbSetOrder(1) )
	If SBE->( dbSeek( xFilial() + Subs(cGetEnd,1,17) ) )
		If SBE->BE_STATUS == '3'
			U_MsgColetor('Endereço bloqueado para uso.')
			_Retorno := .F.
		EndIf
	Else
		U_MsgColetor('Endereço inválido.')
		_Retorno := .F.
	EndIf
EndIf

Return _Retorno

//-----------------------------------------------------------

Static Function fOkQtd()
Local _Retorno := .T.
Private lMsErroAuto := .F.

_cLote :=""

If _nQtd > 0
	If U_uMsgYesNo("Quantidade :"+TransForm(_nQtd,"@E 9,999,999.99"),"Confirma a transferência?")
		//_cLote :=
		//_cDocumento   := U_PELNEXT() //  Nextnumero("SD3",2,"D3_DOC",.T.)
		
		_aItem	     := {}
		_nOpcAuto     := 3 // Indica qual tipo de ação será tomada (Inclusão/Exclusão)
		lMsHelpAuto   := .T.
		lMsErroAuto   := .F.
		_cDoc	        := GetSxENum("SD3","D3_DOC",1)
		
		_aAuto := {}
		aadd(_aAuto,{_cDoc,dDataBase})
		
		SB1->(dbSetOrder(1))
		SB1->(dbGotop())
		If SB1->( dbSeek(xFilial() + XD1->XD1_COD) )
			
			_lOk:=.T.
			
			SB8->(dbSetOrder(3))
			If! SB8->(dbSeek(xFilial("SB8")+XD1->XD1_COD+XD1->XD1_LOCAL+XD1->XD1_LOTECT))
				U_MsgColetor('Lote '+XD1->XD1_LOTECT+' armazém '+XD1->XD1_LOCAL+' não encontrado')
				_lOk:=.F.
			EndIf
			
			SBE->(dbSetOrder(1))
			If! SBE->(dbSeek(xFilial("SBE")+XD1->XD1_LOCAL+XD1->XD1_LOCALI))
				U_MsgColetor('Endereço '+XD1->XD1_LOCALI+' armazém '+XD1->XD1_LOCAL+' não encontrado')
				_lOk:=.F.
			EndIf
			
			If _lOk
				
				aadd(_aItem,SB1->B1_COD)  	         //Produto Origem
				aadd(_aItem,SB1->B1_DESC)           //Descricao Origem
				aadd(_aItem,SB1->B1_UM)  	         //UM Origem
				aadd(_aItem,XD1->XD1_LOCAL)         //Local Origem
				aadd(_aItem,XD1->XD1_LOCALI)		   //Endereco Origem
				aadd(_aItem,SB1->B1_COD)  	         //Produto Destino
				aadd(_aItem,SB1->B1_DESC)           //Descricao Destino
				aadd(_aItem,SB1->B1_UM)  	         //UM destino
				aadd(_aItem,GetMV("MV_LOCPROC"))    //Local Destino
				aadd(_aItem,'99PROCESSO')	         //Endereco Destino  // ALTERAOD PARA 99PROCESSO
				aadd(_aItem,"")                     //Numero Serie
				aadd(_aItem,XD1->XD1_LOTECT)	      //Lote Origem
				aadd(_aItem,"")         	         //Sub Lote Origem
				aadd(_aItem,SB8->B8_DTVALID)	      //Validade Lote Origem
				aadd(_aItem,0)		                  //Potencia
				aadd(_aItem,_nQtd)         	      //Quantidade
				aadd(_aItem,0)		                  //Quantidade 2a. unidade
				aadd(_aItem,"")   	               //ESTORNO
				aadd(_aItem,"")         	         //NUMSEQ
				aadd(_aItem,"LOTE1308")     	      //Lote Destino
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
				GuardaEmps(SB1->B1_COD, XD1->XD1_LOCAL)
	   
				
				MSExecAuto({|x,y| mata261(x,y)},_aAuto,_nOpcAuto)

	   
	   			//End Transaction
				VoltaEmps()

				

				
				If lMsErroAuto
					MostraErro("\UTIL\LOG\Transferencia_Processo\")
					//DisarmTransaction()
					U_MsgColetor("Erro na transferência.")
				Else
					U_MsgColetor("Tranferência realizada com sucesso.")
					Reclock("XD1",.F.)
					XD1->XD1_QTDATU -= _nQtd
					If XD1->XD1_QTDATU <= 0
						XD1->XD1_OCORRE := '5'
					EndIf
					XD1->( msUnlock() )
					
					If SD3->D3_COD == XD1->XD1_COD .and. (SD3->D3_CF == 'RE4' .OR. SD3->D3_CF == 'DE4')
					   TCSQLEXEC("UPDATE " + RetSqlName("SD3") + " SET D3_XXPECA = '"+XD1->XD1_XXPECA+"' WHERE D3_FILIAL = '01' AND D3_NUMSEQ = '"+SD3->D3_NUMSEQ+"' ")
					EndIf

					_nQtd := 0
					
					//cGetProd       := Space(15)
					//cGetEnd        := Space(2+15+1)
					_cEtiqueta     := Space(_nTamEtiq)
					
					oGetProd :Refresh()
					oGetEnd  :Refresh()
					oGetEtiq :Refresh()
					
					oGetEtiq :SetFocus()
					
					_Retorno := .T.
				EndIf
			EndIf
		EndIf
	EndIf
EndIf

Return _Retorno

//-------------------------------------

Static Function fOkProc()
Local _aItem	     := {}
Local _nOpcAuto     := 3 // Indica qual tipo de ação será tomada (Inclusão/Exclusão)
Private lMsHelpAuto := .T.
Private lMsErroAuto := .F.
Private _cDoc	     := GetSxENum("SD3","D3_DOC",1)

_aAuto := {}
aadd(_aAuto,{_cDoc,dDataBase})

SB1->(dbSetOrder(1))
SB1->(dbGotop())
If SB1->(dbSeek(xFilial("SB1")+_aEnd[_nCont][1]))
	
	SBE->(dbSetOrder(1))
	SBE->(dbGotop())
	If SBE->(dbSeek(xFilial("SBE")+AllTrim(_aEnd[_nCont][2])+Subs(cGetEnd,3)))
	
	   aadd(_aItem,SB1->B1_COD)  	         //Produto Origem
	   aadd(_aItem,SB1->B1_DESC)           //Descricao Origem
	   aadd(_aItem,SB1->B1_UM)  	         //UM Origem
	   aadd(_aItem,_aEnd[_nCont][2])       //Local Origem
	   aadd(_aItem,_aEnd[_nCont][3])		   //Endereco Origem
	   aadd(_aItem,SB1->B1_COD)  	         //Produto Destino
	   aadd(_aItem,SB1->B1_DESC)           //Descricao Destino
	   aadd(_aItem,SB1->B1_UM)  	         //UM destino
	   aadd(_aItem,_aEnd[_nCont][2])       //Local Destino
	   //aadd(_aItem,Subs(cGetEnd,3))	   //Endereco Destino
	   aadd(_aItem,"99PROCESSO")		      //Endereco Destino    // ALTERADO PARA 99PROCESSO PARA UNIFICAÇÃO DE ENDEREÇOS NO 99
	   aadd(_aItem,"")                     //Numero Serie
	   aadd(_aItem,_aEnd[_nCont][4])	      //Lote Origem
	   aadd(_aItem,"")         	         //Sub Lote Origem
	   aadd(_aItem,SB8->B8_DTVALID)	      //Validade Lote Origem
	   aadd(_aItem,0)		                  //Potencia
	   aadd(_aItem,_aEnd[_nCont][5]) 	   //Quantidade
	   aadd(_aItem,0)		                  //Quantidade 2a. unidade
	   aadd(_aItem,"")   	               //ESTORNO
	   aadd(_aItem,"")         	         //NUMSEQ
	   //aadd(_aItem,_aEnd[_nCont][4])	   //Lote Destino
	   aadd(_aItem,"LOTE1308")	            //Lote Destino  ALTERADO EM 11/08/18 POR HELIO PARA QUE SÓ HAJA LOTE 1308 NO 99
	   aadd(_aItem,SB8->B8_DTVALID)	      //Validade Lote Destino
	   aadd(_aItem,"")		               //D3_ITEMGRD
	   If nFCICalc == 1
	      aadd(_aItem,0)                   //D3_PERIMP
	   ENDIF   
		If GetVersao(.F.,.F.) == "12"
			//aAdd(_aItem,"")   //D3_IDDCF                             
			aAdd(_aItem,"")   //D3_OBSERVACAO
		EndIf
	
	   aadd(_aAuto,_aItem)
	
	
		//Begin Transaction
		GuardaEmps(SB1->B1_COD, _aEnd[_nCont][2])
	   //Begin Transaction

	
	     MSExecAuto({|x,y| mata261(x,y)},_aAuto,_nOpcAuto)
	
	   //End Transaction
		VoltaEmps()

	   

	   
	   If lMsErroAuto
			MostraErro("\UTIL\LOG\Transferencia_Processo\")
			//DisarmTransaction()
			U_MsgColetor("Erro na transferência entre endereços.")
		Else
		   _nQtd := XD1->XD1_QTDATU	
	   EndIf
	Else
	    U_MsgColetor("Local destino não encontrado ( "+Subs(cGetEnd,3)+"-"+AllTrim(_aEnd[_nCont][2])+" )")
	EndIf
EndIf
Return

//-------------------------------------

Static Function fValidProd()
Local _Retorno  := .T.

If !Empty(cGetProd)
	If SB1->( dbSeek( xFilial() + cGetProd ) )
		If SB1->B1_APROPRI == 'I'
			_cProdEmp   := SB1->B1_COD
			_cDescric   := SB1->B1_DESC
			_cEnderec   := 'Procurar endereço'
		Else
			U_MsgColetor('Esta rotina só deve ser utilizada para produtos com apropriação indireta.')
			_Retorno := .F.
		EndIf
	Else
		U_MsgColetor('Produto inválido.')
		_Retorno := .F.
	EndIf
EndIf

Return _Retorno




*-------------------------------------------------------------------------------------
Static Function GuardaEmps(cProduto,cLocal)
*-------------------------------------------------------------------------------------
Local x

aEmpSB2      := {}
aEMpQTNPB2   := {}
aEmpSBF      := {}
aEmpSB8      := {}
aSD4QUANT    := {}

SB2->( dbSetOrder(1) )
If SB2->( dbSeek( xFilial() + cProduto + cLocal ) )
	If !Empty(SB2->B2_QEMP)
		AADD(aEmpSB2,{SB2->(Recno()),SB2->B2_QEMP})
	EndIf
EndIf

SB2->( dbSetOrder(1) )
If SB2->( dbSeek( xFilial() + cProduto + cLocal ) )
	If !Empty(SB2->B2_QTNP)
		AADD(aEmpQTNPB2,{SB2->(Recno()),SB2->B2_QTNP})
	EndIf
EndIf

SBF->( dbSetOrder(2) )
If SBF->( dbSeek( xFilial() + cProduto + cLocal ) )
	While !SBF->( EOF() ) .and. SBF->BF_FILIAL + SBF->BF_PRODUTO + SBF->BF_LOCAL == xFilial("SBF") + cProduto + cLocal
		If !Empty(SBF->BF_EMPENHO)
			AADD(aEmpSBF,{SBF->(Recno()),SBF->BF_EMPENHO})
		EndIf
		SBF->( dbSkip() )
	End
EndIf

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


For x := 1 to Len(aEMpQTNPB2)
	SB2->( dbGoTo(aEMpQTNPB2[x,1]) )
	Reclock("SB2",.F.)
	SB2->B2_QTNP := 0
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

*-------------------------------------------------------------------------------------
Static Function VoltaEmps()
*-------------------------------------------------------------------------------------
Local x

For x := 1 to Len(aEmpSB2)
	SB2->( dbGoTo(aEmpSB2[x,1]) )
	Reclock("SB2",.F.)
	SB2->B2_QEMP := aEmpSB2[x,2]
	SB2->( msUnlock() )
Next x

For x := 1 to Len(aEMpQTNPB2)
	SB2->( dbGoTo(aEMpQTNPB2[x,1]) )
	Reclock("SB2",.F.)
	SB2->B2_QTNP := aEMpQTNPB2[x,2]
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


Return
