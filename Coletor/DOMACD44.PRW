#include "TbiConn.ch"
#include "TbiCode.ch"
#include "Rwmake.ch"
#include "Topconn.ch"
#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DOMACD44  �Autor  �Ricardo Roda        � Data �  05/29/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Separa��o material Envio Matriz                            ���
���          � Filial 02 - MG                                             ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function DOMACD44()
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

	Define MsDialog oTelaOP Title OemToAnsi("Envio para Matriz") From 0,0 To 293,233 Pixel of oMainWnd PIXEL
	nLin := 005

	@ nLin  ,005 Say oTxtEtiq   Var "Etiqueta " Pixel Of oTelaOP
	@ nLin-2,045 MsGet oGetEtiq Var _cEtiqueta  Size 70,10 Valid ValidaEtiq() Pixel Of oTelaOP
	oTxtEtiq:oFont:= TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
	oGetEtiq:oFont:= TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

	nLin+= 20
	@ nLin,001 To nLin + 39,115 Pixel Of oMainWnd PIXEL

	@ nLin+000,005 Say oTxtLabelOP  Var "Etiqueta: "+ _cEtiqueta                  Pixel Of oTelaOP
	@ nLin+007,005 Say oTxtProdEmp  Var "C�digo: "    + _cProdEti                 Pixel Of oTelaOP
	@ nLin+013,005 Say oTxtDescric  Var "Descri��o: " + _cDescEti     Size 110,15 Pixel Of oTelaOP
	@ nLin+028,005 Say oTxtEndere    Var "Endere�o: "   + _cEndeEti                 Pixel Of oTelaOP

	oTxtLabelOP:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
	oTxtProdEmp:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
	oTxtDescric:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
	oTxtEndere:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)

	nLin+= 108

	@ nLin,010 Button "Enviar" Size 40,15 Action (IIF(fOkQtd(),oTelaOp:end(),.F.))  Pixel Of oTelaOp
	@ nLin,070 Button "Cancelar" Size 40,15 Action (Close(oTelaOp)) Pixel Of oTelaOp


	Activate MsDialog oTelaOP

Return

//-------------------------------------------------------------------------------
Static Function ValidaEtiq()
	Local _Retorno := .F.
	Local _aEnd	   := {}

	XD1->( dbSetOrder(1) )
	SB1->( dbSetOrder(1) )
	SD4->( dbSetOrder(1) )

	If Len(AllTrim(_cEtiqueta)) == 12 //EAN 13 s/ d�gito verificador.
		_cEtiqueta := "0"+_cEtiqueta
		_cEtiqueta := Subs(_cEtiqueta,1,12)
		oGetEtiq:Refresh()
	EndIf

	If Len(AllTrim(_cEtiqueta))==20 //CODE 128 c/ d�gito verificador.
		_cEtiqueta := Subs(AllTrim(_cEtiqueta),8,12)
		oGetEtiq:Refresh()
	EndIf

	If !Empty(_cEtiqueta)

		XD1->( dbSetOrder(1) )
		SB1->( dbSetOrder(1) )
		If XD1->( dbSeek( xFilial("XD1") + _cEtiqueta ) )

			If XD1->XD1_LOCAL <> '97'
				If  XD1->XD1_LOCAL == '95' .and. alltrim(XD1->XD1_LOCALIZ) == '95TRANSFERENCIA'
					U_MsgColetor('Essa etiqueta j� foi transferida')
					_cEtiqueta  := Space(_nTamEtiq)
					oGetEtiq:Refresh()
					_Retorno := .F.
				Else
					U_MsgColetor('Essa etiqueta est� no local errado!'+ chr(13)+chr(10)+ 'Local:'+XD1->XD1_LOCAL+ chr(13)+chr(10)+ 'Endere�o:'+XD1->XD1_LOCALI  )
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
						U_MsgColetor('A Nota Fiscal de Entrada deste material n�o foi classificada.')
						_cEtiqueta  := Space(_nTamEtiq)
						oGetEtiq:Refresh()
						_Retorno := .F.
					Else
						If XD1->XD1_OCORRE == '2'
							U_MsgColetor('Etiqueta de material com pend�ncia de libera��o pelo CQ.')
							_cEtiqueta  := Space(_nTamEtiq)
							oGetEtiq:Refresh()
							_Retorno := .F.
						Else
							If XD1->XD1_OCORRE == '3'
								U_MsgColetor('Etiqueta n�o endere�ada.')
								_cEtiqueta  := Space(_nTamEtiq)
								oGetEtiq:Refresh()
								_Retorno := .F.
							Else
								If XD1->XD1_OCORRE == '5'
									U_MsgColetor('Etiqueta de material j� utilizado.')
									_cEtiqueta  := Space(_nTamEtiq)
									oGetEtiq:Refresh()
									_Retorno := .F.
								Else
									If XD1->XD1_OCORRE $ ('6')
										_Retorno := .T.
									Else
										U_MsgColetor('Status de Etiqueta = 4 (EXPEDI��O)')
										_cEtiqueta  := Space(_nTamEtiq)
										oGetEtiq:Refresh()
										_Retorno := .F.
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf

					If _Retorno
						// Status de etiqueta v�lido

						If XD1->XD1_QTDATU == 0
							U_MsgColetor('N�o existe saldo para esta etiqueta')
							_cEtiqueta  := Space(_nTamEtiq)
							oGetEtiq:Refresh()
							Return .F.
						/*Else
							_lOkProc :=.T.
							SB2->( dbSetOrder(1) )
							If SB2->( dbSeek( xFilial() + XD1->XD1_COD + XD1->XD1_LOCAL ) )
								If SB2->B2_QATU < XD1->XD1_QTDATU
									//_lOkProc:=fTelaEti()
									U_MsgColetor('N�o existe saldo suficiente para realizar essa transfer�ncia no armaz�m '+SB2->B2_LOCAL )
									_cEtiqueta  := Space(_nTamEtiq)
									oGetEtiq:Refresh()
									Return .F.
								EndIf

								If _lOkProc
									//Verifica o saldo no endere�o+lote.

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
								U_MsgColetor('SB2 n�o encontrado para esta etiqueta.')
								_Retorno := .F.
							EndIf*/
						EndIf
					EndIf

				Else
					U_MsgColetor('Rotina permitida apenas para produtos com controle de Endere�amento.')
					_Retorno := .F.
				EndIf
				// Else
				// U_MsgColetor('Rotina permitida apenas para produtos com controle de Lote.')
				// _Retorno := .F.
				// EndIf
			Else
				U_MsgColetor('Produto da etiqueta n�o inv�lido.')
				_Retorno := .F.
			EndIf
		Else
			U_MsgColetor('C�digo de Etiqueta inv�lido')
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
		U_MsgColetor('Essa etiqueta j� foi informada')
		_lReturn:=.F.
	Else
		Aadd(aLbx,{_cEtiqueta,_cProdEti ,_nQtdEti,_cEndeEti})
	Endif

	if len(aLbx) > 0
		@ 063, 002 LISTBOX oLbx Fields HEADER "Etiqueta","C�digo","Quant.","Local";
			SIZE 112, 069 OF oTelaOP COLORS 0, 16777215 PIXEL

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
					//If U_uMsgYesNo("Quantidade :"+TransForm(_nQtdEti,"@E 9,999,999.99"),"Confirma a transfer�ncia?")

					_aItem	      := {}
					_nOpcAuto     := 3 // Indica qual tipo de a��o ser� tomada (Inclus�o/Exclus�o)
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
							U_MsgColetor('Lote '+XD1->XD1_LOTECT+' armaz�m '+XD1->XD1_LOCAL+' n�o encontrado')
							_lOk:=.F.
						Else
							If SB8->B8_SALDO < _nQtdEti
								U_MsgColetor('Lote '+XD1->XD1_LOTECT+' armaz�m '+XD1->XD1_LOCAL+' com saldo insuficiente')
								_lOk:=.F.
							EndIf
						EndIf

						SBE->(dbSetOrder(1))
						if !empty(XD1->XD1_LOCALI)
							If! SBE->(dbSeek(xFilial("SBE")+XD1->XD1_LOCAL+XD1->XD1_LOCALI))
								U_MsgColetor('Endere�o '+XD1->XD1_LOCALI+' armaz�m '+XD1->XD1_LOCAL+' n�o encontrado')
								_lOk:=.F.
							EndIf
						Else
							if XD1->XD1_LOCAL == "97"
								_lOk:=.T.
							Else
								U_MsgColetor('Etiqueta sem endere�o informado')
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
								U_MsgColetor("Erro na transfer�ncia.")
							Else
								Reclock("XD1",.F.)
								XD1->XD1_LOCAL := "95"
								XD1->XD1_LOCALIZ  := "95TRANSFERENCIA"
								XD1->XD1_OCORRE := "4"
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
