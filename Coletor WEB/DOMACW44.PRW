#include "TbiConn.ch"
#include "TbiCode.ch"
#include "Rwmake.ch"
#include "Topconn.ch"
#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DOMACD44  ºAutor  ³Ricardo Roda        º Data ³  05/29/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Separação material Envio Matriz                            º±±
±±º          ³ Filial 02 - MG                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMACW44()
	Private oTxtEtiq,oGetEtiq,oTxtProd,oTxtQtd
	Private _nTamEtiq      := 21
	Private _cNumOP        := Space(Len(CriaVar("D3_OP",.F.)))
	Private _cEtiqueta     := Space(_nTamEtiq) // Space(Len(CriaVar("XD1_XXPECA",.F.)))
	Private _lAuto	       := .T.
	Private cGetEnd        := Space(2+15+1)

	Private _cProdEti := CriaVar("B1_COD",.F.)
	Private _nQtdEti  := CriaVar("B2_QATU",.F.)
	Private _cEndeEti := CriaVar("BF_LOCALIZ",.F.)
	Private _cDescEti := CriaVar("B1_DESC",.F.)

	Private oTelaOP
	Private aLbx:= {}
	Private oLbx

		Private cPush:= "background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 gray);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
		"background-repeat:no-repeat ;border-radius: 6px;}"
	Private cPressed:= "background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 blue);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
		"background-repeat:no-repeat ;border-radius: 6px;}"
	Private cHover:="background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 Black);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
		"background-repeat:no-repeat ;border-radius: 6px;}"


	Define MsDialog oTelaOP Title OemToAnsi("Envio para Matriz") From 0,0 To 450,302 Pixel of oMainWnd PIXEL
	nLin := 005

	@ nLin  ,005 Say oTxtEtiq   Var "Etiqueta " Pixel Of oTelaOP
	@ nLin-3,045 MsGet oGetEtiq Var _cEtiqueta  Size 70*nWebPx,10*nWebPx Valid ValidaEtiq() Pixel Of oTelaOP
	oTxtEtiq:oFont:= TFont():New('Arial',,17*nWebPx,,.T.,,,,.T.,.F.)
	oGetEtiq:oFont:= TFont():New('Arial',,20*nWebPx,,.T.,,,,.T.,.F.)

	nLin+= 20*nWebPx
	@ nLin,001 To nLin + 39*nWebPx,115*nWebPx Pixel Of oMainWnd PIXEL

	@ nLin+000,005 Say oTxtLabelOP  Var "Etiqueta: "+ _cEtiqueta                  Pixel Of oTelaOP
	@ nLin+(007*nWebPx),005 Say oTxtProdEmp  Var "Código: "    + _cProdEti                 Pixel Of oTelaOP
	@ nLin+(013*nWebPx),005 Say oTxtDescric  Var "Descrição: " + _cDescEti     Size 110*nWebPx,15*nWebPx Pixel Of oTelaOP
	@ nLin+(028*nWebPx),005 Say oTxtEndere    Var "Endereço: "   + _cEndeEti                 Pixel Of oTelaOP

	oTxtLabelOP:oFont := TFont():New('Arial',,15*nWebPx,,.T.,,,,.T.,.F.)
	oTxtProdEmp:oFont := TFont():New('Arial',,14*nWebPx,,.T.,,,,.T.,.F.)
	oTxtDescric:oFont := TFont():New('Arial',,14*nWebPx,,.T.,,,,.T.,.F.)
	oTxtEndere:oFont := TFont():New('Arial',,14*nWebPx,,.T.,,,,.T.,.F.)

	nLin+= 108*nWebPx

	@ nLin,010 Button obut1 Prompt "Enviar" Size 40*nWebPx,15*nWebPx Action (IIF(fOkQtd(),oTelaOp:end(),.F.))  Pixel Of oTelaOp
	cCSSBtN1 := "QPushButton{"+cPush+;
		"QPushButton:pressed {"+cPressed+;
		"QPushButton:hover {"+cHover
	obut1:setCSS(cCSSBtN1)
	
	@ nLin,060*nWebPx Button obut2 Prompt "Cancelar" Size 40*nWebPx,15*nWebPx Action (Close(oTelaOp)) Pixel Of oTelaOp
	cCSSBtN1 := "QPushButton{"+cPush+;
		"QPushButton:pressed {"+cPressed+;
		"QPushButton:hover {"+cHover
	obut2:setCSS(cCSSBtN1)

	Activate MsDialog oTelaOP

Return

//-------------------------------------------------------------------------------
Static Function ValidaEtiq()
	Local _Retorno := .F.
	Local _aEnd	   := {}

	XD1->( dbSetOrder(1) )
	SB1->( dbSetOrder(1) )
	SD4->( dbSetOrder(1) )

	If Len(AllTrim(_cEtiqueta)) == 12 //EAN 13 s/ dígito verificador.
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

			If XD1->XD1_LOCAL <> '97'
				If  XD1->XD1_LOCAL == '95' .and. alltrim(XD1->XD1_LOCALIZ) == '95TRANSFERENCIA'
					U_MsgColetor('Essa etiqueta já foi transferida')
					_cEtiqueta  := Space(_nTamEtiq)
					oGetEtiq:Refresh()
					_Retorno := .F.
				Else
					U_MsgColetor('Essa etiqueta está no local errado!'+ chr(13)+chr(10)+ 'Local:'+XD1->XD1_LOCAL+ chr(13)+chr(10)+ 'Endereço:'+XD1->XD1_LOCALI  )
					_cEtiqueta  := Space(_nTamEtiq)
					oGetEtiq:Refresh()
					_Retorno := .F.
				Endif
			EndIf

			If XD1->XD1_LOCAL == '97'
				If Empty(XD1->XD1_LOCALIZ)
					Reclock("XD1",.F.)
					XD1->XD1_LOCALIZ  := "97PROCESSO"
					XD1->( msUnlock() )
				EndIf
			EndIf


			If SB1->( dbSeek( xFilial() + XD1->XD1_COD ) )
				//If Rastro(XD1->XD1_COD)
				If Localiza(XD1->XD1_COD)
					//If SB1->B1_APROPRI == 'I'
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
									If XD1->XD1_OCORRE $ ('6')
										_Retorno := .T.
									Else
										U_MsgColetor('Status de Etiqueta = 4 (EXPEDIÇÃO)')
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

						If XD1->XD1_QTDATU == 0
							U_MsgColetor('Não existe saldo para esta etiqueta')
							_cEtiqueta  := Space(_nTamEtiq)
							oGetEtiq:Refresh()
							Return .F.
						/*Else
							_lOkProc :=.T.
							SB2->( dbSetOrder(1) )
							If SB2->( dbSeek( xFilial() + XD1->XD1_COD + XD1->XD1_LOCAL ) )
								If SB2->B2_QATU < XD1->XD1_QTDATU
									//_lOkProc:=fTelaEti()
									U_MsgColetor('Não existe saldo suficiente para realizar essa transferência no armazém '+SB2->B2_LOCAL )
									_cEtiqueta  := Space(_nTamEtiq)
									oGetEtiq:Refresh()
									Return .F.
								EndIf

								If _lOkProc
									//Verifica o saldo no endereço+lote.

									//_lSaldoEnd:=.F.

									//SBF->( dbSetOrder(2) )
									//If SBF->(dbSeek(xFilial()+XD1->XD1_COD+XD1->XD1_LOCAL))
									//	While xFilial("SBF")+XD1->XD1_COD+XD1->XD1_LOCAL == SBF->BF_FILIAL+SBF->BF_PRODUTO+SBF->BF_LOCAL
									//		If AllTrim(SBF->BF_LOCALIZ) == Alltrim(XD1->XD1_LOCALI)
									//			If (SBF->BF_QUANT-SBF->BF_EMPENHO) >= XD1->XD1_QTDATU
									//				SB8->(dbSetOrder(3))

									//				If SB8->(dbSeek(xFilial()+XD1->XD1_COD+XD1->XD1_LOCAL+XD1->XD1_LOTECT))
									//					If SB8->B8_SALDO >= XD1->XD1_QTDATU
									//						_lSaldoEnd :=.T.
									//						Exit
									//					EndIf
									//				EndIf
									//			EndIf
									//		EndIf
									//		SBF->( dbSkip() )
									//	End
									//EndIf

									If .T. // _lSaldoEnd

										_nQtd     := XD1->XD1_QTDATU

									Else
										_nSaldoEnd:=0

										SBF->(dbSetOrder(2))
										SBF->(dbGotop())
										If SBF->(dbSeek(xFilial("SBF")+XD1->XD1_COD+XD1->XD1_LOCAL))
											Do While !SBF->( Eof() ) .And. xFilial("SBF")+XD1->XD1_COD+XD1->XD1_LOCAL == SBF->(BF_FILIAL+BF_PRODUTO+BF_LOCAL).And._nSaldoEnd < XD1->XD1_QTDATU

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
									EndIf

								EndIf
							Else
								U_MsgColetor('SB2 não encontrado para esta etiqueta.')
								_Retorno := .F.
							EndIf*/
						EndIf
					EndIf

				Else
					U_MsgColetor('Rotina permitida apenas para produtos com controle de Endereçamento.')
					_Retorno := .F.
				EndIf
				// Else
				// U_MsgColetor('Rotina permitida apenas para produtos com controle de Lote.')
				// _Retorno := .F.
				// EndIf
			Else
				U_MsgColetor('Produto da etiqueta não inválido.')
				_Retorno := .F.
			EndIf
		Else
			U_MsgColetor('Código de Etiqueta inválido')
			_cEtiqueta  := Space(_nTamEtiq)
			oGetEtiq:Refresh()
			_Retorno := .F.
		EndIf
		//oGetEtiq:SetFocus()

		oTelaOP:Refresh()

		If _Retorno
			fTelaEti()
		EndIf


	Else
		_Retorno := .T.
	EndIf




Return _Retorno

//------------------------------------------------------------------------------------------

Static Function fTelaEti()
	Private _lReturn:=.T.

	_cEtiqueta := XD1->XD1_XXPECA
	_cProdEti  := XD1->XD1_COD
	_nQtdEti   := XD1->XD1_QTDATU
	_cEndeEti  := XD1->XD1_LOCALI
	_cDescEti  := ""


	SB1->(dbSetOrder(1))
	SB1->(dbGotop())
	If SB1->(dbSeek(xFilial("SB1")+XD1->XD1_COD))
		_cDescEti := SB1->B1_DESC
	EndIf

	nPos:= aScan(aLbx,{ |aVet| ALLTRIM(aVet[1]) == ALLTRIM(_cEtiqueta) })
	if nPos > 0
		U_MsgColetor('Essa etiqueta já foi informada')
		_lReturn:=.F.
	Else
		Aadd(aLbx,{_cEtiqueta,_cProdEti ,_nQtdEti,_cEndeEti})
	Endif

	if len(aLbx) > 0
		@ 063*nWebPx, 002 LISTBOX oLbx Fields HEADER "Etiqueta","Código","Quant.","Local";
			SIZE 112*nWebPx, 069*nWebPx OF oTelaOP COLORS 0, 16777215 PIXEL

		oLbx:SetArray(aLbx)
		oLbx:bLine := {|| { ;
			aLbx[oLbx:nAt,1],;
			aLbx[oLbx:nAt,2],;
			aLbx[oLbx:nAt,3],;
			aLbx[oLbx:nAt,4]}}
		oLbx:Refresh()
	Endif

	_cEtiqueta  := Space(_nTamEtiq)

	oTxtEtiq:Refresh()
	oGetEtiq:Refresh()
	oTxtLabelOP:Refresh()
	oTxtProdEmp:Refresh()
	oTxtDescric:Refresh()
	oTxtEndere:Refresh()
	oTelaOP:Refresh()
	oGetEtiq:SetFocus()

Return(_lReturn)


//----------------------------------------------------------------------------------------------

Static Function fOkQtd(nopc)
	Local _lOk:= .F.
	Local _i
	Local aSomaProd   := {}

	Private lMsErroAuto := .F.
	Private cCusMed   := SuperGetMV('MV_CUSMED')
	Private aRegSD3   := {}
	Private _cDoC     := U_NEXTDOC()
	Private nTransf	  := 0


	// Aglutinando os totais das etiquetas bipadas por produto/almox
	For _i := 1 to len(aLbx)
		if XD1->( dbSeek( xFilial("XD1") + aLbx[_i,1] ) )
			n := aScan(aSomaProd, { |aVet| aVet[1] == XD1->XD1_COD .and. aVet[2] == XD1->XD1_LOCAL .and. aVet[3] == XD1->XD1_LOCALI .and. aVet[4] == XD1->XD1_LOTECT })
			If n == 0
				AADD(aSomaProd,{XD1->XD1_COD, XD1->XD1_LOCAL,XD1->XD1_LOCALI,XD1->XD1_LOTECT,aLbx[_i,3]})
			Else
				aSomaProd[n,5] += aLbx[_i,3]
			EndIf
		EndIf
	Next i

	For i := 1 to Len(aSomaProd)

		_lSaldoEnd := .F.

		SB2->( dbSetOrder(1) )
		If SB2->( dbSeek( xFilial() +aSomaProd[i,1]+aSomaProd[i,2] ) )
			If SB2->B2_QATU >=  aSomaProd[i,5]
				SBF->( dbSetOrder(2) )
				If SBF->(dbSeek(xFilial()+aSomaProd[i,1]+aSomaProd[i,2]))
					While xFilial("SBF")+aSomaProd[i,1]+aSomaProd[i,2] == SBF->BF_FILIAL+SBF->BF_PRODUTO+SBF->BF_LOCAL
						If AllTrim(SBF->BF_LOCALIZ) == Alltrim(aSomaProd[i,3])
							If (SBF->BF_QUANT-SBF->BF_EMPENHO) >= aSomaProd[i,5]
								SB8->(dbSetOrder(3))
								If SB8->(dbSeek(xFilial()+aSomaProd[i,1]+aSomaProd[i,2]+aSomaProd[i,4]))
									If SB8->B8_SALDO >= aSomaProd[i,5]
										_lSaldoEnd :=.T.
										Exit
									EndIf
								EndIf
							EndIf
						EndIf
						SBF->( dbSkip() )
					End
				EndIf
			Endif
		Endif
			
		
		If !_lSaldoEnd
			P07->( dbSetOrder(1) )
			If P07->( dbSeek( xFilial() + aSomaProd[i,1] + aSomaProd[i,2]) )
				MsgRun("Reprocessando o saldo do Produto","Favor Aguardar.....",{|| U_UMATA300(aSomaProd[i,1],aSomaProd[i,1],aSomaProd[i,2],aSomaProd[i,2],cFilAnt ) })
			EndIf
		EndIf
	Next i


	_lOk := .T.
	For i := 1 to Len(aSomaProd)

		_lSaldoEnd := .F.
		SB2->( dbSetOrder(1) )
		If SB2->( dbSeek( xFilial() +aSomaProd[i,1]+aSomaProd[i,2] ) )
			If SB2->B2_QATU >=  aSomaProd[i,5]
				SBF->( dbSetOrder(2) )
				If SBF->(dbSeek(xFilial()+aSomaProd[i,1]+aSomaProd[i,2]))
					While xFilial("SBF")+aSomaProd[i,1]+aSomaProd[i,2] == SBF->BF_FILIAL+SBF->BF_PRODUTO+SBF->BF_LOCAL
						If AllTrim(SBF->BF_LOCALIZ) == Alltrim(aSomaProd[i,3])
							If (SBF->BF_QUANT-SBF->BF_EMPENHO) >= aSomaProd[i,5]
								SB8->(dbSetOrder(3))
								If SB8->(dbSeek(xFilial()+aSomaProd[i,1]+aSomaProd[i,2]+aSomaProd[i,4]))
									If SB8->B8_SALDO >= aSomaProd[i,5]
										_lSaldoEnd :=.T.
										Exit
									EndIf
								EndIf
							EndIf
						EndIf
						SBF->( dbSkip() )
					End
				EndIf
			EndIf
		EndIf
		

		If !_lSaldoEnd
			U_MsgColetor('Produto '+aSomaProd[i,1]+' sem saldo suficiente')
			_lOk:=.F.
		EndIf
	Next i

	If _lOk
		For _i := 1 to len(aLbx)
			if XD1->( dbSeek( xFilial("XD1") + aLbx[_i,1] ) )

				_nQtdEti := aLbx[_i,3]
				If _nQtdEti > 0
					//If U_uMsgYesNo("Quantidade :"+TransForm(_nQtdEti,"@E 9,999,999.99"),"Confirma a transferência?")

					_aItem	      := {}
					_nOpcAuto     := 3 // Indica qual tipo de ação será tomada (Inclusão/Exclusão)
					lMsHelpAuto   := .T.
					lMsErroAuto   := .F.
					_cDoc	      := GetSxENum("SD3","D3_DOC",1)

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
						Else
							If SB8->B8_SALDO < _nQtdEti
								U_MsgColetor('Lote '+XD1->XD1_LOTECT+' armazém '+XD1->XD1_LOCAL+' com saldo insuficiente')
								_lOk:=.F.
							EndIf
						EndIf

						SBE->(dbSetOrder(1))
						if !empty(XD1->XD1_LOCALI)
							If! SBE->(dbSeek(xFilial("SBE")+XD1->XD1_LOCAL+XD1->XD1_LOCALI))
								U_MsgColetor('Endereço '+XD1->XD1_LOCALI+' armazém '+XD1->XD1_LOCAL+' não encontrado')
								_lOk:=.F.
							EndIf
						Else
							if XD1->XD1_LOCAL == "97"
								_lOk:=.T.
							Else
								U_MsgColetor('Etiqueta sem endereço informado')
								_lOk:=.F.
							Endif

						Endif

						If _lOk
							CriaSB2(SB1->B1_COD,'95' )

							a260Processa(SB1->B1_COD, ; 	//-- Codigo do Produto Origem    - Obrigatorio
							XD1->XD1_LOCAL, ;                      	//-- Almox Origem                - Obrigatorio
							_nQtdEti, ;                           	//-- Quantidade 1a UM            - Obrigatorio
							_cDoC, ;                      	//-- Documento                   - Obrigatorio
							dDataBase, ;                       	//-- Data                        - Obrigatorio
							ConvUm(SB1->B1_COD, _nQtdEti, 0, 2), ;   //-- Quantidade 2a UM
							"", ;                        	//-- Sub-Lote                    - Obrigatorio se usa Rastro "S"
							XD1->XD1_LOTECT, ;                        	//-- Lote                        - Obrigatorio se usa Rastro
							SB8->B8_DTVALID, ;                        	//-- Validade                    - Obrigatorio se usa Rastro
							"", ;                        	//-- Numero de Serie
							XD1->XD1_LOCALI, ;                        	//-- Localizacao Origem
							SB1->B1_COD, ;                        	//-- Codigo do Produto Destino   - Obrigatorio
							"95", ;                        	//-- Almox Destino               - Obrigatorio
							"95TRANSFERENCIA", ;                       	//-- Endereco Destino            - Obrigatorio p/a Transferencia
							.F., ;                             	//-- Indica se movimento e estorno
							Nil, ;                             	//-- Numero do registro origem no SD3  - Obrigatorio se for Estorno
							Nil, ;                             	//-- Numero do registro destino no SD3 - Obrigatorio se for Estorno
							'MATA260', ;                       	//-- Indicacao do programa que originou os lancamentos
							,,,,,,,,,,,,,,,,XD1->XD1_LOTECT,StoD("20491231"))


							If lMsErroAuto
								MostraErro("\UTIL\LOG\Transferencia_Processo\")
								U_MsgColetor("Erro na transferência.")
							Else
								Reclock("XD1",.F.)
								XD1->XD1_LOCAL := "95"
								XD1->XD1_LOCALIZ  := "95TRANSFERENCIA"
								XD1->XD1_OCORRE  := "4"
								XD1->( msUnlock() )
								nTransf += 1

								If SD3->D3_COD == XD1->XD1_COD .and. (SD3->D3_CF == 'RE4' .OR. SD3->D3_CF == 'DE4')
									TCSQLEXEC("UPDATE " + RetSqlName("SD3") + " SET D3_XXPECA = '"+XD1->XD1_XXPECA+"' WHERE D3_FILIAL = '01' AND D3_NUMSEQ = '"+SD3->D3_NUMSEQ+"' ")
								EndIf
							Endif

							_nQtdEti := 0
							_nQtd:= 0
							_cEtiqueta := Space(_nTamEtiq)

						Endif

					EndIf
					//EndIf

				Endif
			Endif
		Next _i
	EndIf

	if nTransf > 0
		if nTransf == 1
			U_MsgColetor(cValtoChar(nTransf)+ "Etiqueta transferida com sucesso.")
		Else
			U_MsgColetor(cValtoChar(nTransf)+ "Etiquetas transferidas com sucesso.")
		Endif

	Endif

	_cEtiqueta     := Space(_nTamEtiq)
	oGetEtiq:Refresh()
	oGetEtiq:SetFocus()

Return _lOk
