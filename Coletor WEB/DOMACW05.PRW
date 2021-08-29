//-----------------------------------------------------------------------------------------------------------------------------------------------//
//Wederson Santana -OpusVp - 18/03/13                                                                                                            //
//-----------------------------------------------------------------------------------------------------------------------------------------------//
//Especifico Rosenberger Domex.                                                                                                                  //
//-----------------------------------------------------------------------------------------------------------------------------------------------//
//Pagamento das OP's a ser executado pelo coletor de dados.                                                                                      //
//-----------------------------------------------------------------------------------------------------------------------------------------------//

#include "TbiConn.ch"
#include "TbiCode.ch"
#include "Rwmake.ch"
#include "Topconn.ch"
#include "Protheus.ch"

User Function DOMACW05()
	Private oTxtOP,oGetOP,oTxtEtiq,oGetEtiq,oTxtProd,oGetProd,oTxtQtd,oGetQtd,oMark,oTxtQtdEmp,oMainEti
	Private _nTamEtiq      := 21
	Private _cNumOP        := Space(Len(CriaVar("D3_OP",.F.)))
	Private _cEtiqueta     := Space(_nTamEtiq)//Space(Len(CriaVar("XD1_XXPECA",.F.)))
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
	Private _nQtdEmp       := 0
	Private _aDados        := {}
	Private _aEnd          := {}
	Private _nCont
	Private nSaldoSD4      := 0
	Private cLocProcDom    := GetMV("MV_XXLOCPR")
	Private nFCICalc       := SuperGetMV("MV_FCICALC",.F.,0)
    Private cPush:= "background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 gray);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
		"background-repeat:no-repeat ;border-radius: 6px;}"
	Private cPressed:= "background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 blue);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
		"background-repeat:no-repeat ;border-radius: 6px;}"
	Private cHover:="background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 Black);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
		"background-repeat:no-repeat ;border-radius: 6px;}"

	dDataBase := Date()

	Define MsDialog oTelaOP Title OemToAnsi("Pagamento OP " + DtoC(dDataBase) ) From 0,0 To 450,302 Pixel of oMainWnd PIXEL

	nLin := 005
	@ nLin,005 Say oTxtOP    Var "OP " Pixel Of oTelaOP
	@ nLin-2*nWebPx,045 MsGet oGetOP  Var _cNumOP Valid ValidaOP() Size 70*nWebPx,10*nWebPx Pixel Of oTelaOP
	oTxtOP:oFont := TFont():New('Arial',,17*nWebPx,,.T.,,,,.T.,.F.)
	oGetOP:oFont := TFont():New('Arial',,20*nWebPx,,.T.,,,,.T.,.F.)

	@ 018*nWebPx,001 To 057*nWebPx,115*nWebPx Pixel Of oMainWnd PIXEL

	@ 020*nWebPx,005 Say oTxtLabelOP  Var "Produto sugerido" Pixel Of oTelaOP
	@ 027*nWebPx,005 Say oTxtProdEmp  Var "Código: "+ _cProdEmp Pixel Of oTelaOP
	@ 027*nWebPx,090 Say oTxtQtdEmp   Var "Qtd: "+ TransForm(_nQtdEmp,"@E 999,999.99") Pixel Of oTelaOP
	@ 033*nWebPx,005 Say oTxtDescric  Var "Descrição: "+ _cDescric Size 110*nWebPx,15*nWebPx Pixel Of oTelaOP
	@ 048*nWebPx,005 Say oTxtEnderec  Var "Endereço: "+ _cEnderec Pixel Of oTelaOP

	@ 130*nWebPx,005 Say oSaldoSD4    Var "Saldo: " + Alltrim(Transform(nSaldoSD4,"@E 999,999,999.9999")) Pixel Of oTelaOP
	oSaldoSD4:oFont := TFont():New('Arial',,20*nWebPx,,.T.,,,,.T.,.F.)

	oTxtLabelOP:oFont := TFont():New('Arial',,15*nWebPx,,.T.,,,,.T.,.F.)
	oTxtProdEmp:oFont := TFont():New('Arial',,14*nWebPx,,.T.,,,,.T.,.F.)
	oTxtDescric:oFont := TFont():New('Arial',,14*nWebPx,,.T.,,,,.T.,.F.)
	oTxtEnderec:oFont := TFont():New('Arial',,14*nWebPx,,.T.,,,,.T.,.F.)
	oTxtQtdEmp:oFont  := TFont():New('Arial',,14*nWebPx,,.T.,,,,.T.,.F.)

	nLin+= 60*nWebPx
	@ nLin  ,005 Say oTxtEnd   Var "Endereço "  Pixel Of oTelaOP
	@ nLin-2*nWebPx,045 MsGet oGetEnd Var cGetEnd Valid fValidEnd() Size 70*nWebPx,10*nWebPx  Pixel Of oTelaOP
	oTxtEnd:oFont:= TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
	oGetEnd:oFont:= TFont():New('Arial',,20*nWebPx,,.T.,,,,.T.,.F.)

	nLin+= 20*nWebPx
	@ nLin  ,005 Say oTxtEtiq   Var "Etiqueta " Pixel Of oTelaOP
	@ nLin-2*nWebPx,045 MsGet oGetEtiq Var _cEtiqueta  Size 70*nWebPx,10*nWebPx Valid ValidaEtiq() Pixel Of oTelaOP
	oTxtEtiq:oFont:= TFont():New('Arial',,17*nWebPx,,.T.,,,,.T.,.F.)
	oGetEtiq:oFont:= TFont():New('Arial',,20*nWebPx,,.T.,,,,.T.,.F.)

	nLin+= 20*nWebPx
	@ nLin  ,005 Say oTxtQtd    Var "Quant. " Pixel Of oTelaOP
	@ nLin-2*nWebPx,045 MsGet oGetQtd  Var _nQtd Valid ValidQtd() Picture "@E 9,999,999.9999" Size 70*nWebPx,10*nWebPx  Pixel Of oTelaOP
	oTxtQtd:oFont := TFont():New('Arial',,17*nWebPx,,.T.,,,,.T.,.F.)
	oGetQtd:oFont := TFont():New('Arial',,20*nWebPx,,.T.,,,,.T.,.F.)

	nLin+= 20*nWebPx
	@ nLin,90 Button _oBtn PROMPT "Etiqueta" Size 35*nWebPx,15*nWebPx Action U_EtiqPagam(_cNumOP) Pixel Of oTelaOP
    cCSSBtN1 := "QPushButton{"+cPush+;
	"QPushButton:pressed {"+cPressed+;
	"QPushButton:hover {"+cHover
	_oBtn:setCSS(cCSSBtN1)
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
	If SB1->(dbSeek(xFilial("SB1")+XD1->XD1_COD))
		_cDescEti := SB1->B1_DESC
	EndIf

	SB2->( dbSetOrder(1) )
	If !SB2->( dbSeek( xFilial() + XD1->XD1_COD + XD1->XD1_LOCAL ) )
		U_MsgColetor("SB2 não encontrado.")
	EndIf

	Define MsDialog oTelaEti Title OemToAnsi("Correção Etiqueta") From 0,0 To 450,302 Pixel of oMainEti PIXEL

	nLin := 005
	@ nLin,005 Say oTxtEti     Var "Etiqueta " Pixel Of oTelaEti
	@ nLin-2*nWebPx,045 MsGet oGetEti Var _cNumEti When .F. Size 70*nWebPx,10*nWebPx Pixel Of oTelaEti

	oTxtEti:oFont := TFont():New('Arial',,17*nWebPx,,.T.,,,,.T.,.F.)
	oGetEti:oFont := TFont():New('Arial',,20*nWebPx,,.T.,,,,.T.,.F.)

	@ 018*nWebPx,001 To 057,115 Pixel Of oMainEti PIXEL

	@ 020*nWebPx,005 Say oTxtLabel    Var "Dados da Etiqueta" Pixel Of oTelaEti
	@ 027*nWebPx,005 Say oTxtProdEti  Var "Código: "   + _cProdEti Pixel Of oTelaEti
	@ 027*nWebPx,077 Say oTxtQtdEti   Var "Qtd: "      + TransForm(_nQtdEti,"@E 999,999.99") Pixel Of oTelaEti
	@ 033*nWebPx,005 Say oTxtDescEti  Var "Descrição: "+ _cDescEti Size 110*nWebPx,15*nWebPx Pixel Of oTelaEti
	@ 048*nWebPx,005 Say oTxtEndeEti  Var "Endereço: " + _cEndeEti Pixel Of oTelaEti

	oTxtLabel  :oFont := TFont():New('Arial',,15*nWebPx,,.T.,,,,.T.,.F.)
	oTxtProdEti:oFont := TFont():New('Arial',,14*nWebPx,,.T.,,,,.T.,.F.)
	oTxtDescEti:oFont := TFont():New('Arial',,14*nWebPx,,.T.,,,,.T.,.F.)
	oTxtEndeEti:oFont := TFont():New('Arial',,14*nWebPx,,.T.,,,,.T.,.F.)
	oTxtQtdEti :oFont := TFont():New('Arial',,14*nWebPx,,.T.,,,,.T.,.F.)

	nLin+= 60*nWebPx
	@ nLin  ,005 Say oTxtQtdEti    Var "Quantidade " Pixel Of oTelaEti
	@ nLin-2*nWebPx,045 MsGet oGetQtdEti  Var _nQtdEti Valid fQtdEti() Picture "@E 9,999,999.99" Size 70*nWebPx,10*nWebPx  Pixel Of oTelaEti
	oTxtQtdEti:oFont := TFont():New('Arial',,17*nWebPx,,.T.,,,,.T.,.F.)
	oGetQtdEti:oFont := TFont():New('Arial',,20*nWebPx,,.T.,,,,.T.,.F.)

	nLin+= 20*nWebPx
	@ nLin,070 Button "Cancelar" Size 40*nWebPx,15*nWebPx Action Close(oTelaEti) Pixel Of oTelaEti

	Activate MsDialog oTelaEti

Return(_lReturn)

//--------------------------------------------------------------------

Static Function fQtdEti()
	Close(oTelaEti)
	If _nQtdEti >0
		If _nQtdEti <= SB2->B2_QATU
			DbSelectArea("XD1")
			Reclock("XD1",.F.)
			XD1->XD1_QTDATU := _nQtdEti
			XD1->XD1_OCORRE := "4"
			XD1->( MsUnlock() )
		Else
			U_MsgColetor("Não foi possível realizar o ajuste .Saldo atual :"+TransForm(SB2->B2_QATU,"@E 999,999.99")+".")
			_cEtiqueta := Space(_nTamEtiq)
			oGetEtiq:Refresh()
			_lReturn   :=.F.
		EndIf
	Else
		U_MsgColetor("Informe uma quantidade válida.")
	EndIf

Return

//--------------------------------------------------------------------

Static Function ValidaOP()
	Local _lRet :=.T.
	_cProdEmp   := ""
	_cDescric   := ""
	_cEnderec   := ""
	_nQtdEmp    := 0
	_aDados     := {}

	If Empty(_cNumOP)
		Return .T.
	EndIf

	SC2->( dbSetOrder(1) )
	SB1->( dbSetOrder(1) )
	SBF->( dbSetOrder(2) )

	If SC2->(dbSeek(xFilial("SC2")+_cNumOP))

		//U_MsgColetor("Denis, campo C2_DATRF: " + DtoC(SC2->C2_DATRF))

		If SC2->C2_QUANT <> SC2->C2_QUJE .or. (dDataBase <= CtoD("12/02/2016") .and. Empty(SC2->C2_DATRF))
			If SC2->C2_QUANT == SC2->C2_QUJE
				U_MsgColetor("Denis, campo C2_DATRF: " + DtoC(SC2->C2_DATRF))
			EndIf
			SD4->(dbSetOrder(2))
			If SD4->(dbSeek(xFilial("SD4")+_cNumOP))
				While xFilial("SD4")+_cNumOP == SD4->D4_FILIAL+SD4->D4_OP
					If SD4->D4_LOCAL == cLocProcDom .and. Empty(SD4->D4_OPORIG)
						If SB1->( dbSeek( xFilial() + SD4->D4_COD ) )

							SD3->(DbOrderNickName("USUSD30001"))  // D3_FILIAL + D3_XXOP + D3_COD   tratado
							SUMD3QTD := 0

							If SD3->( dbSeek( xFilial() + SD4->D4_OP + SD4->D4_COD ) )
								While !SD3->( EOF() ) .and. SD4->D4_OP + SD4->D4_COD == SD3->D3_XXOP + SD3->D3_COD  // tratado
									If Empty(SD3->D3_ESTORNO) .and. SD3->D3_LOCAL == cLocProcDom
										If SD3->D3_CF == 'DE4'
											SUMD3QTD += SD3->D3_QUANT
										EndIf
										If SD3->D3_CF == 'RE4'
											SUMD3QTD -= SD3->D3_QUANT
										EndIf
									EndIf
									SD3->( dbSkip() )
								End
							EndIf

							If (SD4->D4_QUANT - SUMD3QTD) > 0
								//If SD4->D4_QUANT > 0
								//If SD4->D4_LOCAL <> '13' .and. SD4->D4_LOCAL <> '99' .and. SB1->B1_TIPO <> 'MO'
								If SBF->(dbSeek(xFilial("SBF")+SD4->D4_COD+SB1->B1_LOCPAD))
									While !SBF->( EOF() ) .and. SD4->D4_COD+SB1->B1_LOCPAD == SBF->BF_PRODUTO+SBF->BF_LOCAL
										If SD4->D4_QUANT > 0
											aadd(_aDados,{SB1->B1_COD,SB1->B1_DESC,SBF->BF_LOCALIZ,SD4->D4_QUANT})
										EndIf
										SBF->( dbSkip() )
									End
								EndIf
								//EndIf
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

	aSort (_aDados,,,{|x, y| x[2] < y[2]} )

	If Empty(_cNumOP)
		_lRet := .T.
	EndIf

	_cProdEmp   := "OP PAGA"
	_cDescric   := "Todos os empenhos foram atendidos."
	_cEnderec   := ""
	_nQtdEmp    := 0

	If Len(_aDados)> 0
		_cProdEmp   := _aDados[1][1]
		_cDescric   := _aDados[1][2]
		_cEnderec   := _aDados[1][3]
		_nQtdEmp    := _aDados[1][4]
	Else
		SZD->( dbSetOrder(1) )  //
		If SZD->( dbSeek( xFilial() + Subs(_cNumOP,1,11) ) )
			nTemp := 0
			While !SZD->( EOF() ) .and. Subs(SZD->ZD_OP,1,11) == Subs(_cNumOP,1,11)
				nTemp += SZD->ZD_QTDPG
				SZD->( dbSkip() )
			End
			U_MsgColetor("Ordem de Produção já atendida. Foi emitida etiqueta de Comprovante de Pagamento para produção de " + Alltrim(Transform(nTemp,"@E 999,999,999.9999"))+".")
		Else
			U_MsgColetor("Ordem de Produção já atendida. Etiqueta de Comprovante de Pagamento NÃO impressa.")
		EndIf
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
	EndIf

	If Len(AllTrim(_cEtiqueta))==20 //CODE 128 c/ dígito verificador.
		_cEtiqueta := Subs(AllTrim(_cEtiqueta),8,12)
	EndIf
	oGetEtiq:Refresh()
	If !Empty(_cEtiqueta)
		//dbSelectArea("XD1")
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
		U_MsgColetor("Utilização proibida. Material bloqueado por inventário.")
		Return .F.
			EndIf
		*/

			If Subs(XD1->XD1_LOCAL+XD1->XD1_LOCALI+Space(17),1,17) <> Subs(cGetEnd+Space(17),1,17)
				//If dDataBase <= Ctod("22/11/13")
				//	cTexto := "Endereço selecionado diferente da Etiqueta ("+Alltrim(XD1->XD1_LOCAL+XD1->XD1_LOCALI)+")."
				//Else
				//EndIf
				U_MsgColetor("Endereço selecionado diferente da Etiqueta.")
				Return .F.
			EndIf

			/*
			fibras
			SB1->( dbSetOrder(1) )
				IF SB1->( dbSeek( xFilial() + XD1->XD1_PRODUTO ) )
					If Subs(SB1->B1_GRUPO,1,2) == 'FO'
				U_MsgColetor("Não é permitido o pagamento de Fibras por esta ferramenta. Utilize a ferramenta específica para envio deste material para o endereço '01CORTE'.")
				Return .F.
					ENDIF
			*/
				//Tratamento para etiqueta avulsa.
				If Empty(XD1->(XD1_DOC+XD1_SERIE+XD1_FORNEC+XD1_LOJA)) .or. .T.
					Do Case
					Case XD1->XD1_OCORRE == '5'
						If U_uMsgYesNo('Etiqueta zerada. Deseja corrigir?')
							fTelaEti()
						Else
							_cEtiqueta  := Space(_nTamEtiq)
							oGetEtiq:Refresh()
							_Retorno := .F.
						EndIf
					Case XD1->XD1_OCORRE == '4'
						_Retorno := .T.
					Case XD1->XD1_QTDATU == 0
						U_MsgColetor('Não existe saldo para esta etiqueta')
						_cEtiqueta  := Space(_nTamEtiq)
						oGetEtiq:Refresh()
						_Retorno    := .F.
					OtherWise
						U_MsgColetor('Status de Etiqueta desconhecido.')
						_cEtiqueta  := Space(_nTamEtiq)
						oGetEtiq:Refresh()
						_Retorno := .F.
					EndCase

					If !Empty(XD1->XD1_LOTECTL)
						If _Retorno
							If SB1->( dbSeek( xFilial() + XD1->XD1_COD ) )
								If SD4->( dbSeek( xFilial() + XD1->XD1_COD + Subs(_cNumOP,1,11) ) )
									lSD4OK := .F.
									If !Empty(SD4->D4_OPORIG)
										While !SD4->( EOF() ) .and. XD1->XD1_COD + Subs(_cNumOP,1,11) == SD4->D4_COD + Subs(SD4->D4_OP,1,11)
											If Empty(SD4->D4_OPORIG)
												lSD4OK := .T.
												Exit
											EndIf
											SD4->( dbSkip() )
										End
									Else
										lSD4OK := .T.
									EndIf

									If lSD4OK
										//cQuery := "SELECT SUM(D3_QUANT) AS D3_QUANT FROM " + RetSqlName("SD3") + " WHERE D3_CF = 'DE4' AND D3_LOCAL = '"+GetMV("MV_XXLOCPR")+"' AND D3_XXOP = '"+SD4->D4_OP+"' AND D3_ESTORNO = '' AND D3_COD = '"+SD4->D4_COD+"' AND D_E_L_E_T_ = '' "
										//If Select("TEMP") <> 0
										//	TEMP->( dbCloseArea() )
										//EndIf
										//TCQUERY cQuery NEW ALIAS "TEMP"

										SD3->(DbOrderNickName("USUSD30001"))  // D3_FILIAL + D3_XXOP + D3_COD   tratado
										SUMD3QTD := 0

										If SD3->( dbSeek( xFilial() + SD4->D4_OP + SD4->D4_COD ) )
											While !SD3->( EOF() ) .and. SD4->D4_OP + SD4->D4_COD == SD3->D3_XXOP + SD3->D3_COD  // tratado
												If Empty(SD3->D3_ESTORNO) .and. SD3->D3_LOCAL == cLocProcDom
													If SD3->D3_CF == 'DE4'
														SUMD3QTD += SD3->D3_QUANT
													EndIf
													If SD3->D3_CF == 'RE4'
														SUMD3QTD -= SD3->D3_QUANT
													EndIf
												EndIf
												SD3->( dbSkip() )
											End
										EndIf

										//	If (SD4->D4_QUANT - SUMD3QTD)  <= 0 //MLS    20/11/2013
										If SUMD3QTD >= SD4->D4_QTDEORI
											If SUMD3QTD == SD4->D4_QTDEORI
												U_MsgColetor('Pagamento total do produto '+Alltrim(SD4->D4_COD)+' já realizado para esta OP.')
												_cEtiqueta := Space(_nTamEtiq)
												oGetEtiq:Refresh()
												_Retorno   := .F.
											Else
												U_MsgColetor('Pagamento do produto '+Alltrim(SD4->D4_COD)+' superior ao empenho desta Op. Isto acarretará em problemas no ampntamento da Produção. Favor realizar a devolução do material excedente.')
												_cEtiqueta := Space(_nTamEtiq)
												oGetEtiq:Refresh()
												_Retorno   := .F.
											EndIf
										Else
											// Verifica se o saldo do SB2 está no endereço bipado
											_lOkProc :=.T.    //Verifica se a quantidade informada na etiqueta é maior que o saldo atual.

											//nSaldoSD4 := SD4->D4_QUANT - SUMD3QTD //mls
											nSaldoSD4 := SD4->D4_QTDEORI - SUMD3QTD //mls

											SB2->( dbSetOrder(1) )
											If SB2->( dbSeek( xFilial() + XD1->XD1_COD + XD1->XD1_LOCAL ) )
												If SB2->B2_QATU < XD1->XD1_QTDATU

													//_lOkProc := fTelaEti()
													U_MsgColetor("Saldo físico menor que o saldo da etiqueta.")
													_lOkProc := .F.

												EndIf
											EndIf

											If _lOkProc

												//Verifica o saldo no endereço+lote.
												_lSaldoEnd:=.F.

												SBF->(dbSetOrder(2))
												SBF->(dbGotop())
												If SBF->(dbSeek(xFilial("SBF")+XD1->XD1_COD+XD1->XD1_LOCAL))
													While xFilial("SBF")+XD1->XD1_COD+XD1->XD1_LOCAL == SBF->(BF_FILIAL+BF_PRODUTO+BF_LOCAL)
														If AllTrim(SBF->BF_LOCALIZ) == AllTrim(SubStr(cGetEnd,3)) .and. Alltrim(SBF->BF_LOTECTL) == Alltrim(XD1->XD1_LOTECT)
															If (SBF->BF_QUANT-SBF->BF_EMPENHO) >= XD1->XD1_QTDATU
																SB8->(dbSetOrder(3))
																SB8->(dbGotop())
																//If SB8->(dbSeek(xFilial("SB8")+XD1->XD1_COD+SB1->B1_LOCPAD+SBF->BF_LOTECTL))   //MLS LOCAL 13/11/2013
																If   SB8->(dbSeek(xFilial("SB8")+XD1->XD1_COD+XD1->XD1_LOCAL+SBF->BF_LOTECTL))   //MLS LOCAL 13/11/2013
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

										/*
										cQuery := "SELECT MAX(ZC_DATA) AS ULTINVENT FROM " + RetSqlName("SZC") + " WHERE ZC_FILIAL = '"+xFilial("SZC")+"' AND ZC_PRODUTO = '"+SD4->D4_COD+"' AND D_E_L_E_T_ = '' "
												If Select("QUERYSZC") <> 0
										QUERYSZC->( dbCloseArea() )
												EndIf
										TCQUERY cQuery NEW ALIAS "QUERYSZC"
										*/
												//If !_lSaldoEnd .and. SB1->B1_LOCPAD <> '02' .and. SB1->B1_LOCPAD <> '04' .and. SB1->B1_LOCPAD <> '17'
												If !_lSaldoEnd //.and. QUERYSZC->ULTINVENT < "20130921"
													U_MsgColetor("Saldo do endereço/lote menor que a quantidade/lote da embalagem.")

													Return .F.
											/*
											_nSaldoEnd:=0
											
											SBF->(dbSetOrder(2))
											SBF->(dbGotop())
													If SBF->(dbSeek(xFilial()+XD1->XD1_COD+XD1->XD1_LOCAL))
														While !SBF->( Eof() ).and. xFilial("SBF")+XD1->XD1_COD+XD1->XD1_LOCAL == SBF->(BF_FILIAL+BF_PRODUTO+BF_LOCAL) .And. _nSaldoEnd < XD1->XD1_QTDATU
															If AllTrim(SBF->BF_LOCALIZ) <> AllTrim(SubStr(cGetEnd,3))
																If (SBF->BF_QUANT-SBF->BF_EMPENHO) >= XD1->XD1_QTDATU
											Aadd(_aEnd,{SBF->BF_PRODUTO,SBF->BF_LOCAL,SBF->BF_LOCALIZ,SBF->BF_LOTECTL,XD1->XD1_QTDATU-_nSaldoEnd})
											_nSaldoEnd := XD1->XD1_QTDATU
																EndIf
											
																If (SBF->BF_QUANT-SBF->BF_EMPENHO) > 0
																	If (SBF->BF_QUANT-SBF->BF_EMPENHO) < XD1->XD1_QTDATU
											Aadd(_aEnd,{SBF->BF_PRODUTO,SBF->BF_LOCAL,SBF->BF_LOCALIZ,SBF->BF_LOTECTL,(SBF->BF_QUANT-SBF->BF_EMPENHO)})
											_nSaldoEnd += (SBF->BF_QUANT-SBF->BF_EMPENHO)
																	EndIf
																EndIf
															EndIf
											SBF->(dbSkip())
														End
													EndIf
											
													For _nCont:= 1 To Len(_aEnd)
											
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
											
											_nQtd:=If(XD1->XD1_QTDATU >= (SD4->D4_QUANT - SUMD3QTD),SD4->D4_QUANT - SUMD3QTD,XD1->XD1_QTDATU)
											*/
												Else
													//If !_lSaldoEnd //.and. QUERYSZC->ULTINVENT >= "20130921"
													//	U_MsgColetor("Para produtos inventariados a partir de 21/09/13, é obrigatório selecionar o endereço de origem do produto.")
													//	_nQtd := If(XD1->XD1_QTDATU >= (SD4->D4_QUANT - SUMD3QTD),SD4->D4_QUANT - SUMD3QTD,XD1->XD1_QTDATU)
													//	_Retorno := .F.
													//Else
													_nQtd := If(XD1->XD1_QTDATU >= (SD4->D4_QTDEORI - SUMD3QTD),SD4->D4_QTDEORI - SUMD3QTD,XD1->XD1_QTDATU)
													//EndIf
												EndIf

											EndIf
										EndIf

										//If !Empty(XD1->XD1_LOCALI)
										//If Alltrim(XD1->XD1_LOCAL+XD1->XD1_LOCALI) <> Alltrim(cGetEnd) .and. _Retorno
										//Endereço da etiqueta diferente da bipada
										//	Reclock("XD1",.F.)
										//	XD1->XD1_LOCAL  := Subs(cGetEnd,1,2)
										//	XD1->XD1_LOCALI := Subs(cGetEnd,3)
										//	XD1->( msUnlock() )
										//EndIf
										//EndIf
									Else
										U_MsgColetor('Este produto só existe como PI para esta OP.')
										_Retorno := .F.
									EndIf
								Else
									U_MsgColetor('Não existe empenho deste produto para esta OP.')
									_Retorno := .F.
								EndIf
							Else
								U_MsgColetor('Cadastro Produto '+XD1->XD1_COD+' não encontrado.')
								_Retorno := .F.
							EndIf
						EndIf
					Else
						U_MsgColetor("Etiqueta inválida por estar sem número de lote.")
						_Retorno := .F.
					EndIf
				Else
					dbSelectArea("SD1")
					SD1->( dbSetOrder(1) )
					If SD1->( dbSeek( xFilial() + XD1->XD1_DOC + XD1->XD1_SERIE + XD1->XD1_FORNEC + XD1->XD1_LOJA + XD1->XD1_COD + XD1->XD1_ITEM ) )
						If !Empty( SD1->D1_TES )
							dbSelectArea("SF4")
							SF4->( dbSetOrder(1) )
							If SF4->( dbSeek( xFilial("SF4") + SD1->D1_TES ) )
								If SF4->F4_ESTOQUE == 'S'
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
												//If Alltrim(XD1->XD1_LOCAL+XD1->XD1_LOCALI) <> Alltrim(cGetEnd)
												//      U_MsgColetor('O Material não está neste Endereço.')
												//      _cEtiqueta  := Space(_nTamEtiq)
												//      oGetEtiq:Refresh()
												//      _Retorno := .F.
												//Else
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
												//EndIf
											EndIf
										EndIf
									EndIf

									If !Empty(XD1->XD1_LOTECTL)
										If _Retorno
											If Rastro(XD1->XD1_COD)//Rastro(SD7->D7_PRODUTO,'S') Sub lote
												_lLote :=.T.
											EndIf

											If Localiza(XD1->XD1_COD)
												_lEnd :=.T.
											EndIf

											If _lLote .and. _lEnd

												If XD1->XD1_QTDATU == 0
													U_MsgColetor('Não existe saldo para esta etiqueta')
													_cEtiqueta  := Space(_nTamEtiq)
													oGetEtiq:Refresh()
													_Retorno    := .F.
												Else
													If SB1->( dbSeek( xFilial() + XD1->XD1_COD ) )
														If SD4->( dbSeek( xFilial() + XD1->XD1_COD + _cNumOP) )

															//cQuery := "SELECT SUM(D3_QUANT) AS D3_QUANT FROM " + RetSqlName("SD3") + " WHERE D3_CF = 'DE4' AND D3_LOCAL = '"+GetMV("MV_XXLOCPR")+"' AND D3_XXOP = '"+SD4->D4_OP+"' AND D3_ESTORNO = '' AND D3_COD = '"+SD4->D4_COD+"' AND D_E_L_E_T_ = '' "
															//If Select("TEMP") <> 0
															//	TEMP->( dbCloseArea() )
															//EndIf
															//TCQUERY cQuery NEW ALIAS "TEMP"

															SD3->(DbOrderNickName("USUSD30001"))  // D3_FILIAL + D3_XXOP + D3_COD   tratado
															SUMD3QTD := 0

															If SD3->( dbSeek( xFilial() + SD4->D4_OP + SD4->D4_COD ) )
																While !SD3->( EOF() ) .and. SD4->D4_OP + SD4->D4_COD == SD3->D3_XXOP + SD3->D3_COD  // tratado
																	If Empty(SD3->D3_ESTORNO) .and. SD3->D3_LOCAL == cLocProcDom
																		If SD3->D3_CF == 'DE4'
																			SUMD3QTD += SD3->D3_QUANT
																		EndIf
																		If SD3->D3_CF == 'RE4'
																			SUMD3QTD -= SD3->D3_QUANT
																		EndIf
																	EndIf
																	SD3->( dbSkip() )
																End
															EndIf


															If (SD4->D4_QUANT - SUMD3QTD) <= 0
																U_MsgColetor('O saldo do empenho deste produto '+Alltrim(SD4->D4_COD)+' está zerado para esta OP.')
																_cEtiqueta := Space(_nTamEtiq)
																oGetEtiq:Refresh()
																_Retorno   := .F.
															Else
																// Verifica se o saldo do SB2 está no endereço bipado
																//nSaldoSD4 := SD4->D4_QUANT - SUMD3QTD mls
																nSaldoSD4 := SD4->D4_QTDEORI - SUMD3QTD //mls

																SD4->(dbSetOrder(2))
																SD4->(dbGotop())
																If SD4->( dbSeek( xFilial() + _cNumOP + XD1->XD1_COD))

																	_lOkProc :=.T.    //Verifica se a quantidade informada na etiqueta é maior que o saldo atual.
																	SB2->( dbSetOrder(1) )
																	If SB2->( dbSeek( xFilial() + XD1->XD1_COD + XD1->XD1_LOCAL ) )
																		If SB2->B2_QATU < XD1->XD1_QTDATU

																			//_lOkProc:=fTelaEti()
																			U_MsgColetor("Saldo físico "+Alltrim(Transform(SB2->B2_QATU,"@E 999,999,999.9999"))+" menor que o saldo da etiqueta.")
																			_lOkProc := .F.

																		EndIf
																	EndIf

																	If _lOkProc

																		//Verifica o saldo no endereço+lote.
																		_lSaldoEnd:=.F.

																		SBF->(dbSetOrder(2))
																		SBF->(dbGotop())
																		If SBF->(dbSeek(xFilial("SBF")+XD1->XD1_COD+XD1->XD1_LOCAL))
																			While xFilial("SBF")+XD1->XD1_COD+XD1->XD1_LOCAL == SBF->(BF_FILIAL+BF_PRODUTO+BF_LOCAL)

																				If AllTrim(SBF->BF_LOCALIZ) == AllTrim(SubStr(cGetEnd,3))
																					If (SBF->BF_QUANT-SBF->BF_EMPENHO) >= XD1->XD1_QTDATU
																						SB8->( dbSetOrder(3) )
																						SB8->( dbGotop() )
																						If SB8->(dbSeek(xFilial()+XD1->XD1_COD+XD1->XD1_LOCAL+SBF->BF_LOTECTL))
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
																			U_MsgColetor("Saldo do endereço insuficiente.")
																			Return .F.
																	/*
																	_nSaldoEnd:=0
																	
																	SBF->(dbSetOrder(2))
																	SBF->(dbGotop())
																			If SBF->(dbSeek(xFilial("SBF")+XD1->XD1_COD+SB1->B1_LOCPAD))
																				Do While !SBF->( Eof() ).And.xFilial("SBF")+XD1->XD1_COD+SB1->B1_LOCPAD == SBF->(BF_FILIAL+BF_PRODUTO+BF_LOCAL).And._nSaldoEnd < XD1->XD1_QTDATU
																	
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
																	*/
																		Else
																			_nQtd:=If(XD1->XD1_QTDATU >= (SD4->D4_QUANT - SUMD3QTD),SD4->D4_QUANT - SUMD3QTD,XD1->XD1_QTDATU)
																		EndIf
																	EndIf
																EndIf

																//If Alltrim(XD1->XD1_LOCAL+XD1->XD1_LOCALI) <> Alltrim(cGetEnd)
																//Endereço da etiqueta diferente da bipada
																//	Reclock("XD1",.F.)
																//	XD1->XD1_LOCAL  := Subs(cGetEnd,1,2)
																//	XD1->XD1_LOCALI := Subs(cGetEnd,3)
																//	XD1->( msUnlock() )
																//EndIf
															EndIf
														Else
															U_MsgColetor('Não existe empenho deste produto para esta OP.')
															_Retorno := .F.
														EndIf
													EndIf
												EndIf
											Else
												U_MsgColetor('Operação não permitida Produto '+XD1->XD1_COD+' não controla Lote / Endereço.')
												_cEtiqueta  := Space(_nTamEtiq)
												oGetEtiq:Refresh()
												_Retorno := .F.
											EndIf
										EndIf
									Else
										U_MsgColetor("Etiqueta inválida por estar sem número de lote.")
										_Retorno := .F.
									EndIf
								Else
									U_MsgColetor('Nota Fiscal nao movimenta o Estoque '+XD1->XD1_DOC+'.')
								EndIf
							EndIf
						Else
							U_MsgColetor('Nota Fiscal nao Classificada '+XD1->XD1_DOC+'.')
						EndIf
					Else
						U_MsgColetor('Numero de Nota Fiscal gravada na etiqueta não encontrada no arquivo de Notas. Não será possível utilizar este material.')
						_cEtiqueta  := Space(_nTamEtiq)
						oGetEtiq:Refresh()
						_Retorno := .F.
					EndIf
				EndIf

			Else
				U_MsgColetor('Códido de Etiqueta inválido.')
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
/*
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
			If GetVersao(.F.,.F.) == "12"
aAdd(_aItem,"")   //D3_IDDCF
aAdd(_aItem,"")   //D3_OBSERVACAO
			EndIf
aadd(_aAuto,_aItem)



//MSExecAuto({|x,y| mata261(x,y)},_aAuto,_nOpcAuto)



			If lMsErroAuto
MostraErro("\UTIL\LOG\Transferencia_Pagamento\")
//DisarmTransaction()
U_MsgColetor("Erro na transferência entre endereços.")
//Else
//_nQtd := If(XD1->XD1_QTDATU >= SD4->D4_QUANT,SD4->D4_QUANT,XD1->XD1_QTDATU)
			EndIf
		Else
U_MsgColetor("Local destino não encontrado ( "+Alltrim((Subs(cGetEnd,3)))+"-"+AllTrim(_aEnd[_nCont][2])+" )")
		EndIf
	EndIf
*/
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

	While !apMsgNoYes( cTemp )
		lRet:=.F.
	End

Return(lRet)

//---------------------------------------------------------

Static Function fValidEnd()
	Local _Retorno := .T.

	nSaldoSD4 := 0

	If !Empty(cGetEnd)
		/*
	    IF SUBSTR(cGetEnd,1,7)=='01CORTE'
			U_MsgColetor("Não é permitido o pagamento através do edereço '01CORTE' por esta ferramenta. Utilize a ferramenta específica para este tipo de produto.")
			Return .F.
		ENDIF
		*/
		
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

Static Function ValidQtd()
	Local _Retorno      := .T.
	Local _nOpcAuto     := 3
	Private lMsHelpAuto := .T.
	Private lMsErroAuto := .F.

	_cLote :=""
	ConOut("Inicio do ValidaOp DOMACD05 " + Time())
	If _nQtd > 0
		If U_uMsgYesNo("Quantidade :"+TransForm(_nQtd,"@E 9,999,999.99"),"Confirma o pagamento ?")

			If Rastro(XD1->XD1_COD)   //Rastro(SD7->D7_PRODUTO,'S') Sub lote
				_cLote := If(Empty(XD1->XD1_LOTECTL),"LOTE1308",XD1->XD1_LOTECTL)
			Else
				U_MsgColetor("Erro. Produto sem controle de lote!")
				Return .F.
			EndIf

			SD4->( dbSetOrder(1) )
			If SD4->(  dbSeek( xFilial() + XD1->XD1_COD +_cNumOP ) )
				lSD4_OK := .F.
				While xFilial("SD4") + Subs(_cNumOP,1,11) == SD4->D4_FILIAL + Subs(SD4->D4_OP,1,11)
					If SD4->D4_LOCAL == cLocProcDom .and. Empty(SD4->D4_OPORIG)
						lSD4_OK := .T.
						Exit
					EndIf
					SD4->(dbSkip())
				End

				If !lSD4_OK
					U_MsgColetor('Erro na localização do empenho.')
				EndIf

				If _nQtd <= XD1->XD1_QTDATU

					//cQuery := "SELECT SUM(D3_QUANT) AS D3_QUANT FROM " + RetSqlName("SD3") + " WHERE
					//D3_CF      = 'DE4' AND
					//D3_LOCAL   = '"+GetMV("MV_XXLOCPR")+"' AND
					//D3_XXOP    = '"+SD4->D4_OP+"' AND
					//D3_ESTORNO = '' AND D3_COD = '"+SD4->D4_COD+"' AND D_E_L_E_T_ = '' "

					//If Select("TEMP") <> 0
					//	TEMP->( dbCloseArea() )
					//EndIf
					//TCQUERY cQuery NEW ALIAS "TEMP"

					SD3->(DbOrderNickName("USUSD30001"))  // D3_FILIAL + D3_XXOP + D3_COD
					SUMD3QTD := 0

					If SD3->( dbSeek( xFilial() + SD4->D4_OP + SD4->D4_COD ) )
						While !SD3->( EOF() ) .and. SD4->D4_OP + SD4->D4_COD == SD3->D3_XXOP + SD3->D3_COD  // tratado
							If Empty(SD3->D3_ESTORNO) .and. SD3->D3_LOCAL == cLocProcDom
								If SD3->D3_CF == 'DE4'
									SUMD3QTD += SD3->D3_QUANT
								EndIf
								If SD3->D3_CF == 'RE4'
									SUMD3QTD -= SD3->D3_QUANT
								EndIf
							EndIf
							SD3->( dbSkip() )
						End
					EndIf

					//If _nQtd <= (SD4->D4_QUANT - SUMD3QTD)  //MLS
					If _nQtd <= (SD4->D4_QTDEORI - SUMD3QTD)  //MLS
						If SD4->D4_LOCAL <> cLocProcDom
							U_MsgColetor("Não é possível pagar produtos empenhados em almoxarifado diferente de 97")
						/*
							If .F.
						cTM         := '540'
						aVetor      := {}
						nTipo       := 3
						
						AADD(aVetor,{"D3_TM"      , cTM                , NIL })
						AADD(aVetor,{"D3_OP"      , _cNumOP            , NIL })
						AADD(aVetor,{"D3_COD"     , XD1->XD1_COD       , NIL })
						AADD(aVetor,{"D3_EMISSAO" , ddatabase          , NIL })
						AADD(aVetor,{"D3_QUANT"   , _nQtd              , NIL })
						AADD(aVetor,{"D3_LOCAL"   , SD4->D4_LOCAL      , NIL })
						AADD(aVetor,{"D3_LOTECTL" , _cLote             , NIL })
						AADD(aVetor,{"D3_LOCALIZ" , Subs(cGetEnd,3)    , NIL })
						AADD(aVetor,{"D3_XXPECA"  , XD1->XD1_XXPECA    , NIL })
						
						aAreaSB2 := SB2->( GetArea() )
						MSExecAuto({|x,y| mata240(x,y)},aVetor,nTipo)   	 // Movimentação Interna
						RestArea(aAreaSB2)
						
								If lMsErroAuto
						MostraErro("\UTIL\LOG\Pagamento\")
						//DisarmTransaction()
						U_MsgColetor("Erro no pagamento da OP. Consultar o Log")
								Else
						Reclock("XD1",.F.)
						XD1->XD1_QTDATU := XD1->XD1_QTDATU - _nQtd
						
						nSaldoSD4       := nSaldoSD4 - _nQtd
						
									If XD1->XD1_QTDATU <= 0
						XD1->XD1_OCORRE := '5'
									EndIf
						XD1->( msUnlock() )
						
									If XD1->XD1_QTDATU <= 0
						U_MsgColetor("Confirma saldo restante de " + Alltrim(Transform(XD1->XD1_QTDATU,"@E 999,999,999.9999")) + " na etiqueta?")
									EndIf
						
						_nQtd := 0
						_cEtiqueta     := Space(_nTamEtiq)
						oGetEtiq:Refresh()
						oGetEtiq:SetFocus()
								EndIf
							EndIf
						*/
						Else
							If SB1->( dbSeek( xFilial() + XD1->XD1_COD ) )

								_aAuto := {}

								SD3->( dbSetOrder(2))

								For ___x := 1 to 100
									Private _cDoc	        := U_NEXTDOC() //GetSxENum("SD3","D3_DOC",1)
									If !SD3->( dbSeek(xFilial() + _cDoc) )
										Exit
									EndIf
								Next ___x

								_cDoc :=_cDoc+SPACE(09)     //DOCUMENTO 9 DIGITOS
								_cDoc :=SUBSTR(_cDoc,1,9)


								aadd(_aAuto,{_cDoc,dDataBase})

							/*
							Prod.Orig. D3_COD      C        15       0
							Desc.Orig. D3_DESCRI   C        30       0
							UM Orig.   D3_UM       C         2       0
							Armazem Or D3_LOCAL    C         2       0
							Endereco O D3_LOCALIZ  C        15       0
							Prod.Desti D3_COD      C        15       0
							Desc.Desti D3_DESCRI   C        30       0
							UM Destino D3_UM       C         2       0
							Armazem De D3_LOCAL    C         2       0
						Endereco D D3_LOCALIZ  C        15       0
							Numero Ser D3_NUMSERI  C        20       0
							Lote       D3_LOTECTL  C        10       0
							Sub-Lote   D3_NUMLOTE  C         6       0
							Validade   D3_DTVALID  D         8       0
							Potencia   D3_POTENCI  N         6       2
							Quantidade D3_QUANT    N        11       4
							Qt 2aUM    D3_QTSEGUM  N        12       2
							Estornado  D3_ESTORNO  C         1       0
							Sequencia  D3_NUMSEQ   C         6       0
							Lote Desti D3_LOTECTL  C        10       0
							Validade D D3_DTVALID  D         8       0
							Item Grade D3_ITEMGRD  C         3       0
							Per. Imp.  D3_PERIMP   N         8       4
							*/

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
						aadd(_aItem,"")                     //Numero Serie Destino
						aadd(_aItem,XD1->XD1_LOTECTL)	      //Lote Origem
						aadd(_aItem,"")         	         //Sub Lote Origem
						aadd(_aItem,StoD("20491231"))	      //Validade Lote Origem
						aadd(_aItem,0)		                  //Potencia
						aadd(_aItem,_nQtd)            	   //Quantidade
						aadd(_aItem,0)		                  //Quantidade 2a. unidade
						aadd(_aItem,"")   	               //ESTORNO
						aadd(_aItem,"")         	         //NUMSEQ
						aadd(_aItem,U_RETLOTC6(SD4->D4_OP)) //Lote Destino
						aadd(_aItem,StoD("20491231"))	      //Validade Lote Destino
						aadd(_aItem,"")		               //D3_ITEMGRD
						If nFCICalc == 1
							aadd(_aItem,0)                      //D3_PERIMP
						ENDIF
						If GetVersao(.F.,.F.) == "12"
							//aAdd(_aItem,"")   //D3_IDDCF
							aAdd(_aItem,"")   //D3_OBSERVACAO                                                                     l
						EndIf
						aadd(_aAuto,_aItem)

						lMsErroAuto := .F.

						//MSExecAuto({|x,y| mata261(x,y)},_aAuto,_nOpcAuto)  // Execauto de transferência para o 97

							/*
							±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
							±±/ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
							±±=FunáÖo    =A260Processa  = Eveli Morasco             = Data = 16/01/92 =±±
							±±vƒƒƒƒƒƒƒƒƒƒ˜ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
							±±=DescriáÖo = Processamento da inclusao                                  =±±
							±±vƒƒƒƒƒƒƒƒƒƒ˜ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
							±±=Parametros=ExpC01: Codigo do Produto Origem - Obrigatorio              =±±
							±±=          =ExpC02: Almox Origem             - Obrigatorio              =±±
							±±=          =ExpN01: Quantidade 1a UM         - Obrigatorio              =±±
							±±=          =ExpC03: Documento                - Obrigatorio              =±±
							±±=          =ExpD01: Data                     - Obrigatorio              =±±
							±±=          =ExpN02: Quantidade 2a UM                                    =±±
							±±=          =ExpC04: Sub-Lote                 - Obrigatorio se Rastro "S"=±±
							±±=          =ExpC05: Lote                     - Obrigatorio se usa Rastro=±±
							±±=          =ExpD02: Validade                 - Obrigatorio se usa Rastro=±±
							±±=          =ExpC06: Numero de Serie                                     =±±
							±±=          =ExpC07: Localizacao Origem                                  =±±
							±±=          =ExpC08: Codigo do Produto Destino- Obrigatorio              =±±
							±±=          =ExpC09: Almox Destino            - Obrigatorio              =±±
							±±=          =ExpC10: Localizacao Destino                                 =±±
							±±=          =ExpL01: Indica se movimento e estorno                       =±±
							±±=          =ExpN03: Numero do registro original (utilizado estorno)     =±±
							±±=          =ExpN04: Numero do registro destino (utilizado estorno)      =±±
							±±=          =ExpC11: Indicacao do programa que originou os lancamentos   =±±
							±±=          =ExpC12: cEstFis    - Estrutura Fisica         1 (APDL)       =±±
							±±=          =ExpC13: cServico   - Servico                  2 (APDL)       =±±
							±±=          =ExpC14: cTarefa    - Tarefa                   3 (APDL)       =±±
							±±=          =ExpC15: cAtividade - Atividade                4 (APDL)       =±±
							±±=          =ExpC16: cAnomalia  - Houve Anomalia? (S/N)    5 (APDL)       =±±
							±±=          =ExpC17: cEstDest   - Estrututa Fisica Destino 6 (APDL)       =±±
							±±=          =ExpC18: cEndDest   - Endereco Destino         7 (APDL)       =±±
							±±=          =ExpC19: cHrInicio  - Hora Inicio              8 (APDL)       =±±
							±±=          =ExpC20: cAtuEst    - Atualiza Estoque? (S/N)  9 (APDL)       =±±
							±±=          =ExpC21: cCarga     - Numero da Carga          0 (APDL)       =±±
							±±=          =ExpC22: cUnitiza   - Numero do Unitizador     1 (APDL)       =±±
							±±=          =ExpC23: cOrdTar    - Ordem da Tarefa          2 (APDL)       =±±
							±±=          =ExpC24: cOrdAti    - Ordem da Atividade       3 (APDL)       =±±
							±±=          =ExpC25: cRHumano   - Recurso Humano           4 (APDL)       =±±
							±±=          =ExpC26: cRFisico   - Recurso Fisico           5 (APDL)       =±±
							±±=          =ExpN05: nPotencia  - Potencia do Lote                       =±±
							±±=          =ExpC27: cLoteDest  - Lote Destino da Transferencia          =±±
							±±=          =ExpD03: dDtVldDest - Validade Lote Destino da Trasnferencia =±±
							±±=          =ExpC28: cCAT83O    - Cod.Cat83 Produto Origem                   =±±
							±±=          =ExpC29: cCAT83D    - Cod.Cat83 Produto Destino              =±±
							±±vƒƒƒƒƒƒƒƒƒƒ˜ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
							±±= Uso      = Transferencia                                              =±±
							±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
							±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
							?????????????????????????????????????????????????????????????????????????????
							*/
						//Exemplo do João Opus
						//
						//CriaSB2(aDados[nI][3],"21")
						//a260Processa(aDados[nI][3],"20",aDados[nI][2],cNumDoc,dDataBase,0,,,,,,aDados[nI][3],"21",,.F.,Nil,Nil,"MATA260")
						//
						//a260Processa(produto,local origem,quantidade,cNumDoc,dDataBase,qtd segunda,sub lote ,lote,validade,numero serie ,endereço origem,produto destino,local destino,endereço destino,lEstorno,Nil,Nil,"MATA260",1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,nPotenciaLote,LoteDestino,Validade lote destino)

						PRIVATE cCusMed   := GetMv("MV_CUSMED")
						PRIVATE cCadastro := "Transferencias"
						PRIVATE aRegSD3	:= {}
						PRIVATE nPerImp   := CriaVar("D3_PERIMP")
						ConOut("Antes do a260Processa" + Time())
						a260Processa(XD1->XD1_COD,XD1->XD1_LOCAL,_nQtd,_cDoc,dDataBase,0,,XD1->XD1_LOTECTL,StoD("20491231"),,XD1->XD1_LOCALIZ,XD1->XD1_COD,cLocProcDom,"97PROCESSO",.F.,Nil,Nil,"MATA260",,,,,,,,,,,,,,,,,U_RETLOTC6(SD4->D4_OP),StoD("20491231"))
						ConOut("Depois do a260Processa" + Time())

						If lMsErroAuto .and. .F.
							//MostraErro("\UTIL\LOG\Transferencia_Pagamento\error_log_pagamento_op_data_"+DtoS(Date())+"_hora_"+ Time()+ "_op_" + SD4->D4_OP +".TXT")
							//DisarmTransaction()
							If U_uMsgYesNo("Erro no pagamento (tranferência) para o 97. Deseja mostrar o erro?")
								MostraErro()
							Else
								MostraErro("\UTIL\LOG\Transferencia_Pagamento\")
							EndIf
							//Else
							//_nQtd := If(XD1->XD1_QTDATU >= SD4->D4_QUANT,SD4->D4_QUANT,XD1->XD1_QTDATU)
						Else
							SD3->( dbSetOrder(2) )  // D3_FILIAL + D3_DOC
							If SD3->( dbSeek( xFilial() + _cDoc ) )
								While !SD3->( EOF() ) .and. ALLTRIM(SD3->D3_DOC) == ALLTRIM(_cDoc)    //MLS ALTERADO MOTIVO DOCUMENTO COM 9 DIGITOS
									If SD3->D3_CF == 'RE4' .or. SD3->D3_CF == 'DE4'
										If SD3->D3_COD == XD1->XD1_COD
											If SD3->D3_EMISSAO == dDataBase
												If SD3->D3_QUANT == _nQtd
													If Empty(SD3->D3_XXOP)
														Reclock("SD3",.F.)
														SD3->D3_XXPECA  := XD1->XD1_XXPECA
														SD3->D3_XXOP    := SD4->D4_OP
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

								Reclock("XD1",.F.)
								XD1->XD1_QTDATU := XD1->XD1_QTDATU - _nQtd

								nSaldoSD4       := nSaldoSD4 - _nQtd

								If XD1->XD1_QTDATU <= 0
									XD1->XD1_OCORRE := '5'
								EndIf

								XD1->( msUnlock() )

								U_MsgColetor("Transferência realizada com sucesso, Documento: " + _cDoc)

								If XD1->XD1_QTDATU <= 0
									U_MsgColetor("Confirma saldo restante de " + Alltrim(Transform(XD1->XD1_QTDATU,"@E 999,999,999.9999")) + " na etiqueta?")
								EndIf

								_nQtd := 0
								_cEtiqueta     := Space(_nTamEtiq)
								oGetEtiq:Refresh()
								oGetEtiq:SetFocus()
							Else

								If lMsErroAuto
									//MostraErro("\UTIL\LOG\Transferencia_Pagamento\error_log_pagamento_op_data_"+DtoS(Date())+"_hora_"+ Time()+ "_op_" + SD4->D4_OP +".TXT")
									//DisarmTransaction()
									If U_uMsgYesNo("Erro no pagamento (tranferência) para o 97. Deseja mostrar o erro?")
										MostraErro()
									Else
										MostraErro("\UTIL\LOG\Transferencia_Pagamento\")
									EndIf
								Else
									U_MsgColetor("Erro no pagamento (tranferência) para o 97. Deseja mostrar o erro?")
								EndIf

								_nQtd := 0
								_cEtiqueta     := Space(_nTamEtiq)
								oGetEtiq:Refresh()
								oGetEtiq:SetFocus()

							EndIf
						EndIf
					EndIf
				EndIf
			Else
				U_MsgColetor('Quantidade superior ao saldo do empenho.')
				_Retorno := .F.
			EndIf
		Else
			U_MsgColetor('Quantidade superior a da etiqueta. Se estiver correta, favor inventariar o material.')
			_Retorno := .F.
		EndIf
	Else
		U_MsgColetor('Não foi encontrado empenho deste produto para esta OP.')
		_Retorno := .F.
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
ConOut("Fim do ValidaOp DOMACD05 " + Time())
Return _Retorno
