#include "TbiConn.ch"
#include "TbiCode.ch"
#include "rwmake.ch"
#include "TOpconn.ch"
#include "protheus.ch"


//*********************************************************
// Pagamento de senf                                      *
//*********************************************************

*----------------------------------------------------------
User Function DOMACW12()
	*----------------------------------------------------------
	Private oTxtEnd,oGetEnd,oTxtEtiq,oGetEtiq,oTxtProd,oGetProd,oTxtQtd,oGetQtd,oMark,oTxtPRODEND,oTxtPREND
	Private _nTamEtiq     := 21
	Private _cNCLIENTE    := ""
	Private _cEndereco    := Space(Len(CriaVar("BE_LOCALIZ",.F.))+1)
	Private _cEtiqueta    := Space(_nTamEtiq+1) // Space(Len(CriaVar("XD1_XXPECA",.F.)))
	Private _cProduto     := CriaVar("B1_COD",.F.)
	Private _cTxtPRODCOD  := CriaVar("B1_COD",.F.)
	Private _nQtd         := CriaVar("XD1_QTDATU",.F.)
	Private _cLoteEti     := CriaVar("BF_LOTECTL",.F.)
	Private _aCols        := {}
	Private _cParametro   := "MV_XXNUMIN"
	Private _cCtrNum      := GetNewPar(_cParametro,"")
	Private _lAuto	       := .T.
	Private _lIndividual  := .F.
	Private _nTamDoc      := Len(CriaVar("B7_DOC",.F.))
	Private _cPedido      := Space(07)
	Private _cItem        := Space(09)
	Private _cTxtCliente  := Space(40)
	Private _cTxtPRODUTO  := Space(15)
	Private _cTxtPRODDES  := Space(40)
	Private _cTxtPRODEND  := Space(40)
	Private _cTxtPREND    := Space(40)
	Private cC6LOCAL      := Space(02)
	Private cLoteVen
	Private _nTotalOF     := 0
	Private _nSALDO       := 0
	Private _nQtdOF       := 0
	Private _cProdAnt     := ""
	Private nContad       := 0
	Private cLocExp       := '13'
	Private cEndExp       := '13EXPEDICAO'
	Private cEndPro       := '13PRODUCAO'
	Private cUltEti1      := '_____________'
	Private cUltEti2      := '_____________'
	Private cUltEti3      := '_____________'
	Private oUltEti1
	Private oUltEti2
	Private oUltEti3
	Private aEtiqProd
	Private _cDocInv
	Private aEmpSB2
	Private _aLog
	Private aPVSep     := {}
	Private cPcExcecao := "'',"
	Private cITExcecao := "'',"
	Private nFCICalc    := SuperGetMV("MV_FCICALC",.F.,0)
	Private cPush:= "background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 gray);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
		"background-repeat:no-repeat ;border-radius: 6px;}"
	Private cPressed:= "background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 blue);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
		"background-repeat:no-repeat ;border-radius: 6px;}"
	Private cHover:="background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 Black);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
		"background-repeat:no-repeat ;border-radius: 6px;}"

	XD1->( dbSetOrder(1) )
	SB1->( dbSetOrder(1) )
	SB2->( dbSetOrder(1) )
	SC5->( dbSetOrder(1) )
	SC6->( dbSetOrder(1) )
	SB8->( dbSetOrder(3) ) //PRODUTO+LOCAL+LOTECTL
	SBF->( dbSetOrder(1) ) //LOCAL+LOCALIZ+PRODUTO+NUMSERI+LOTECTL+NUMLOTE

	If! Empty(_cCtrNum)
		fOkTela()
	Else
		U_MsgColetor("Verifique o parâmetro "+_cParametro)
	EndIf

Return

	*----------------------------------------------------------
Static Function fOkTela()
	*----------------------------------------------------------
	_aCols:={}

	Define MsDialog oSenf Title OemToAnsi("Pagamento de Senf " + DtoC(dDataBase)) From 0,0 To 450,302 Pixel of oMainWnd PIXEL

	@ 005,005 Say   oTxtOF  Var "OF " Pixel Of oSenf
	oTxtOF:oFont := TFont():New('Arial',,17*nWebPx,,.T.,,,,.T.,.F.)


	@ 005,030  BITMAP oBmp1 ResName "RIGHT"  Of oMainWnd Size 090*nWebPx,20*nWebPx ON CLICK BUSCAPVSEP("PC")  NoBorder  Pixel


	@ 005,045 MsGet oGetPC  Var _cPedido Valid fValop() Size 70*nWebPx,10*nWebPx Pixel Of oSenf
	oGetPC:oFont := TFont():New('Arial',,20*nWebPx,,.T.,,,,.T.,.F.)


	@ 020*nWebPx,005 Say oTxtCliente  Var _cTxtCliente      Pixel Of oSenf
	oTxtCliente:oFont:= TFont():New('Arial',,17*nWebPx,,.T.,,,,.T.,.F.)

	@ 035*nWebPx,030  BITMAP oBmp2 ResName "RIGHT"  Of oMainWnd Size 090*nWebPx,20*nWebPx ON CLICK BUSCAPVSEP("IT")  NoBorder  Pixel


	@ 035*nWebPx,005 Say   oTxtITEM Var "Item" Size 014*nWebPx,10*nWebPx Pixel Of oSenf
	oTxtITEM:oFont:= TFont():New('Arial',,17*nWebPx,,.T.,,,,.T.,.F.)



	@ 035*nWebPx,045 MsGet oGetItem Var _cItem  Size 070*nWebPx,10*nWebPx Valid fValITEM() Pixel Of oSenf
	oGetItem:oFont:= TFont():New('Arial',,20*nWebPx,,.T.,,,,.T.,.F.)



	@ 050*nWebPx,005 Say oTxtPRODCOD  Var _cTxtPRODCOD      Pixel Of oSenf
	oTxtPRODCOD:oFont:= TFont():New('Arial',,17*nWebPx,,.T.,,,,.T.,.F.)

	@ 060*nWebPx,005 Say oTxtPRODDES  Var _cTxtPRODDES      Pixel Of oSenf
	oTxtPRODDES:oFont:= TFont():New('Arial',,17*nWebPx,,.T.,,,,.T.,.F.)

	@ 070*nWebPx,005 Say oTxtPRODEND  Var _cTxtPRODEND      Pixel Of oSenf
	oTxtPRODEND:oFont:= TFont():New('Arial',,17*nWebPx,,.T.,,,,.T.,.F.)

	@ 080*nWebPx,005 Say oTxtPREND Var _cTxtPREND     Pixel Of oSenf
	oTxtPREND:oFont:= TFont():New('Arial',,17*nWebPx,,.T.,,,,.T.,.F.)

	@ 095*nWebPx,005 Say   oTxtEndereco Var "Endereço "  Pixel Of oSenf
	@ 095*nWebPx,045 MsGet oGetEndereco Var _cEndereco  Valid fValEnd() Size 70*nWebPx,10*nWebPx  Pixel Of oSenf
	oTxtEndereco:oFont:= TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
	oGetEndereco:oFont:= TFont():New('Arial',,20*nWebPx,,.T.,,,,.T.,.F.)

	@ 110*nWebPx,005 Say   oTxtEtiqueta  Var "Etiqueta "  Pixel Of oSenf
	@ 110*nWebPx,045 MsGet oGetEtiq      Var _cEtiqueta Valid fValEtiq() Size 70*nWebPx,10*nWebPx  Pixel Of oSenf
	oTxtEtiqueta:oFont:= TFont():New('Arial',,17*nWebPx,,.T.,,,,.T.,.F.)
	oGetEtiq:oFont:= TFont():New('Arial',,20*nWebPx,,.T.,,,,.T.,.F.)

	@ 125*nWebPx,005 Say   oTxtQtd  Var "Quant. " Pixel Of oSenf
	@ 125*nWebPx,045 MsGet oGetQtd  Var _nQtd Valid fValQTD()      Picture "@E 9,999,999.9999" Size 70*nWebPx,10*nWebPx  Pixel Of oSenf
	oTxtQtd:oFont := TFont():New('Arial',,17*nWebPx,,.T.,,,,.T.,.F.)
	oGetQtd:oFont := TFont():New('Arial',,20*nWebPx,,.T.,,,,.T.,.F.)

//@ 130,070 Button "Sair" Size 40,15 Action Close(oSenf) Pixel Of oSenf

	Activate MsDialog oSenf

Return

	*----------------------------------------------------------
Static Function fValop()
	*----------------------------------------------------------
	If SC5->( dbSeek( xFilial("SC5") + Subs(_cPedido,1,6)) )
		//	_cNCLIENTE   :=POSICIONE('SA1',1,xFILIAL('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_NREDUZ')
		_cNCLIENTE   :=POSICIONE('SA1',1,xFILIAL('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_NOME')
		_cTxtCliente :=SUBSTR(SC5->C5_CLIENTE+'/'+SC5->C5_LOJACLI+'-'+_cNCLIENTE,1,28)
		_lRet        := .T.
	Else
		U_MsgColetor('OF não encontrado.')
		_cTxtCliente :=''
		_lRet        := .F.
	EndIf

	oTxtCliente:REFRESH()

RETURN _lRet

	*----------------------------------------------------------
Static Function fValITEM() //MLS
	*----------------------------------------------------------
	_cTxtPRODEND  := space(40)
	_cTxtPREND    := space(40)
	_lRet         := .T.

	If !Empty(_cItem)
		If SC6->( dbSeek( xFilial("SC6") + Subs(_cItem,1,8)) )
			If SUBSTR(_cItem,1,6) <> SUBSTR(_cPedido,1,6)
				U_MsgColetor("O Item lido pertence a outra Senf.")
				_lRet := .F.
			Else
				IF SUBSTR(_cItem,7,2) == SPACE(02) .or. SUBSTR(_cItem,7,2) <> SC6->C6_ITEM
					U_MsgColetor('Item OF Não digitado.')
					_lRet := .F.
				ELSE
					// Validando se o item já está todo pago
					SD3->(DbOrderNickName("USUSD30002"))  // D3_FILIAL + D3_XXPV + D3_COD + D3_LOCAL
					SUMD3QTD1 := 0
					If SD3->( dbSeek( xFilial() + Subs(_cItem,1,8) + SC6->C6_PRODUTO ) )
						While !SD3->( EOF() ) .and. SD3->D3_XXPV + SD3->D3_COD == Subs(_cItem,1,8) + SC6->C6_PRODUTO
							If Empty(SD3->D3_ESTORNO) .and. SD3->D3_LOCAL == '13'
								If SD3->D3_CF == 'DE4'
									SUMD3QTD1 += SD3->D3_QUANT
								EndIf
								If SD3->D3_CF == 'RE4'
									SUMD3QTD1 -= SD3->D3_QUANT
								EndIf
							EndIf
							SD3->( dbSkip() )
						End
					EndIf
					If (SUMD3QTD1) >= (SC6->C6_QTDENT + SC6->C6_XXQSEPA)
						U_MsgColetor("Item da Senf totalmente pago.")
						_lRet := .F.
					Else

						SZY->( dbSetOrder(2) )
						dDtFatur := CtoD("")
						If SZY->( dbSeek( xFilial() + Subs(_cItem,1,8) ) )
							While !SZY->( EOF() )  .and. SZY->ZY_PEDIDO + SZY->ZY_ITEM == Subs(_cItem,1,8)
								If Empty(SZY->ZY_NOTA) .and. !Empty(SZY->ZY_PRVFAT)
									dDtFatur := SZY->ZY_PRVFAT
									Exit
								EndIf
								SZY->( dbSkip() )
							End
						Else
						EndIf

						If Empty(dDtFatur)
							U_MsgColetor("Data de Faturamento não programada para o item.")
							_lRet := .F.
						Else

							_cProduto    := SC6->C6_PRODUTO
							_cTxtPRODCOD := SC6->C6_PRODUTO
							_cTxtPRODDES := SUBSTR(SC6->C6_DESCRI,1,28)
							_nQtd        := SC6->C6_QTDVEN-SC6->C6_QTDENT
							_nQtdOF      := _nQtd
							_lRet        := .T.
							_nTotalOF    := SC6->C6_QTDVEN//-SC6->C6_QTDENT

							cC6LOCAL		 := SC6->C6_LOCAL
							cLoteVen     := SC6->C6_LOTECTL

							IF Select("TRB") >0
								TRB->(dbCloseArea())
							EndIf

							cQuery := " SELECT * FROM "+retsqlname("SBF")+" (NOLOCK) WHERE BF_PRODUTO='"+SC6->C6_PRODUTO+"' AND D_E_L_E_T_<>'*' AND BF_QUANT >0   ORDER BY BF_QUANT DESC" //AND BF_QUANT >0
							TcQuery cQuery Alias "TRB" New

							TRB->(DbSelectArea("TRB"))

							TRB->(DbGoTop())

							cCOUNT:=0
							DO WHILE !TRB->(EOF())
								cCOUNT :=cCOUNT+1
								DO CASE
								CASE cCOUNT ==1
									_cTxtPRODEND:=TRB->BF_LOCALIZ  //+ Transform(TRB->BF_QUANT,"@E 999,999.99")
								CASE cCOUNT ==2
									_cTxtPRODEND:=_cTxtPRODEND+'/'+TRB->BF_LOCALIZ  //+ Transform(TRB->BF_QUANT,"@E 999,999.99")
								CASE cCOUNT ==3
									_cTxtPREND:=TRB->BF_LOCALIZ  //+ Transform(TRB->BF_QUANT,"@E 999,999.99")
								CASE cCOUNT ==4
									_cTxtPREND:=_cTxtPREND+'/'+TRB->BF_LOCALIZ  //+ Transform(TRB->BF_QUANT,"@E 999,999.99")
								ENDCASE
								TRB->(DBSKIP())
							ENDDO
							TRB->(DBCLOSEAREA())
							IF EMPTY(_cTxtPRODEND)
								U_MsgColetor('Sem saldo por Endereço')
								_lRet := .F.
							ENDIF

							IF Select("TRB") >0
								TRB->(dbCloseArea())
							EndIf

							cQuery := " SELECT SUM(B2_QACLASS) AS B2_QACLSASS FROM "+retsqlname("SB2")+" WHERE B2_COD='"+SC6->C6_PRODUTO+"' AND D_E_L_E_T_<>'*'"
							TcQuery cQuery Alias "TRB" New

							TRB->(DbSelectArea("TRB"))
							TRB->(DbGoTop())
							IF TRB->B2_QACLSASS > 0
								U_MsgColetor('Saldo a endereçar:'+ Transform(TRB->B2_QACLSASS,"@E 999,999.99"))
							ENDIF

							TRB->(DBCLOSEAREA())
						EndIf
					EndIf
				EndIf
			EndIf
		Else
			U_MsgColetor('Item OF não encontrado.')
			_cTxtPRODCOD  := space(15)
			_cTxtPRODDES  := space(40)
			_cTxtPRODEND  := space(40)
			_cTxtPREND    := space(40)
			_nQtd         := 0
			_nQtdOF       := _nQtd
			_lRet         := .F.
		EndIf
	EndIf

	If !_lRet
		_cItem := Space(09)
		oGetPC:SetFocus()
		_lRet := .T.
	EndIf

	oGetQtd:REFRESH()
	oTxtPRODCOD:REFRESH()
	oTxtPRODDES:REFRESH()
	oTxtPRODEND:REFRESH()
	oTxtPREND:REFRESH()

RETURN(_lRet)

	*----------------------------------------------------------
Static Function fValEnd()
	*----------------------------------------------------------
	Local _lRet := .T.

	SBE->( dbSetOrder(1) )  //BE_FILIAL+BE_LOCAL+BE_LOCALIZ
	If SBE->( dbSeek( xFilial("SBE") + Subs(_cEndereco,1,17)) )
		If SBE->BE_MSBLQL == '1'
			_lRet := .T.
			U_MsgColetor('Endereço bloqueado para uso.')
		EndIf
	Else
		_lRet := .T.
		U_MsgColetor('Endereço não encontrado.')
	EndIf

Return(_lRet)

	*----------------------------------------------------------
Static Function fValEtiq()
	*----------------------------------------------------------
	Local _lRet         :=.T.
	Local _nSALDO       := 0

	If Len(AllTrim(_cEtiqueta))==12 //EAN 13 s/ dígito verificador.
		_cEtiqueta := "0"+_cEtiqueta
		_cEtiqueta := Subs(_cEtiqueta,1,12)
	EndIf

	If Len(AllTrim(_cEtiqueta))==20 //CODE 128 c/ dígito verificador.
		_cEtiqueta := Subs(AllTrim(_cEtiqueta),8,12)
	EndIf
	oGetEtiq:Refresh()

	If !Empty(_cEtiqueta)
		If XD1->( dbSeek( xFilial() + _cEtiqueta ) )

			If Alltrim(XD1->XD1_LOCAL+XD1->XD1_LOCALI) <> Alltrim(_cEndereco)
				U_MsgColetor("Endereço selecionado diferente da Etiqueta.")
				Return .F.
			EndIf

			_cProduto := XD1->XD1_COD
			If ALLTRIM(_cProduto) <> ALLTRIM(_cTxtPRODCOD)
				U_MsgColetor("A Etiqueta pertence a outro PN.")
				Return .F.
			EndIf

			If "HUAWEI" $ _cNCLIENTE
				SD3->(DbOrderNickName("USUSD30002"))  // D3_FILIAL + D3_XXPV + D3_COD + D3_LOCAL
				cLoteTrans := ""
				If SD3->( dbSeek( xFilial() + Subs(_cItem,1,8) ) )
					While !SD3->( EOF() ) .and. SD3->D3_FILIAL == xFilial("SD3") .and. SD3->D3_XXPV == Subs(_cItem,1,8)
						If Empty(SD3->D3_ESTORNO)
							If !Empty(SD3->D3_LOTECTL)
								cLoteTrans := SD3->D3_LOTECTL
							EndIf
						EndIf
						SD3->( dbSkip() )
					End
				EndIf
				If Empty(cLoteTrans)

				EndIf
			EndIf

			If SB1->( dbSeek( xFilial() + _cProduto) )
				If SB1->B1_LOCALIZ == 'S'
					If XD1->XD1_QTDATU < _nQtdOF
						//U_MsgColetor('Quantidade da Etiqueta menor que quantidade da OF, quantidade será ajustada.')
						_nQtd :=XD1->XD1_QTDATU
						oGetQtd:REFRESH()
					EndIf
					//VALIDA LOCAL (SBF)
					_CENDER := SUBSTR(_cEndereco,3,LEN(_cEndereco))+SPACE(05)
					_CENDER := SUBSTR(_CENDER,1,15)
					_NSERIE := Space(Len(CriaVar("BF_NUMSERI",.F.)))

					SBF->( dbSetOrder(1) )
					If SBF->( dbSeek( xFilial('SBF') + XD1->XD1_LOCAL + _CENDER+ SB1->B1_COD + _NSERIE + XD1->XD1_LOTECT) )
						If SBF->BF_QUANT < _nQtd
							U_MsgColetor('Saldo endereço menor que quantidade , quantidade será ajustada.')
							_nQtd :=SBF->BF_QUANT
						ENDIF
					ELSE
						U_MsgColetor('Endereço não cadastrado para esse produto/lote.')
						_lRet := .T.
					ENDIF
					oGetQtd:REFRESH()
				ELSE
					U_MsgColetor('Cadastro sem controle por localização')
					_lRet := .T.
				ENDIF
			ELSE
				U_MsgColetor('Produto não encontrado.')
				_lRet := .T.
			ENDIF
		ELSE
			U_MsgColetor('Etiqueta não encontrada.')
			_lRet := .T.
		ENDIF
	ELSE
		U_MsgColetor('Etiqueta em Branco.')
		_lRet := .T.
	EndIf

Return(_lRet)

	*----------------------------------------------------------
Static Function fValQTD()
	*----------------------------------------------------------

	Local _lRet         :=.T.
	Local _nSaldoSDA    := 0
	LOCAL LCHKMOV       := .F.
	Local _nSALDO       := 0
	Local _aItem	     := {}
	Local _nOpcAuto     := 3 // Indica qual tipo de ação será tomada (Inclusão/Exclusão)
	Private lMsHelpAuto := .T.
	Private lMsErroAuto := .F.
	Private _cDoc

	If dDataBase <> Date()
		dDataBase := Date()
	EndIf

	If !Empty(_cEtiqueta)
		If XD1->( dbSeek( xFilial() + _cEtiqueta ) )
			_cProduto := XD1->XD1_COD
			If SB1->( dbSeek( xFilial() + _cProduto) )
				If SB1->B1_LOCALIZ == 'S'
					IF XD1->XD1_QTDATU < _nQtd
						U_MsgColetor('Quantidade da Etiqueta menor que quantidade da OF, quantidade será ajustada.')
						_nQtd :=XD1->XD1_QTDATU
						oGetQtd:REFRESH()
					ENDIF

					//VALIDA LOCAL (SBF)
					_CENDER := SUBSTR(_cEndereco,3,LEN(_cEndereco))+SPACE(05)
					_CENDER := SUBSTR(_CENDER,1,15)
					_NSERIE := Space(Len(CriaVar("BF_NUMSERI",.F.)))

					SBF->( dbSetOrder(1) )

					If SBF->( dbSeek( xFilial('SBF') + XD1->XD1_LOCAL + _CENDER+ SB1->B1_COD + _NSERIE + XD1->XD1_LOTECT) )
						If SBF->BF_QUANT < _nQtd
							U_MsgColetor('Saldo endereço menor que quantidade , quantidade será ajustada.')
							_nQtd :=SBF->BF_QUANT
						ENDIF
					ELSE
						U_MsgColetor('Endereço não cadastrado para esse produto/lote.')
						_lRet := .F.
					ENDIF

					oGetQtd:REFRESH()

					_nSALDO:=XD1->XD1_QTDATU-_nQtd
					// CRIA PRODUTO LOCAL EXPEDIÇÃO SE NÃO EXISTIR
					CriaSB2(XD1->XD1_COD,cLocExp)
				/*
					IF !SB2->( dbSeek( xFilial('SB2') + XD1->XD1_COD + cLocExp  ) )    //B2_FILIAL+B2_COD+B2_LOCAL
				Reclock("SB2",.T.)
				SB2->B2_FILIAL := xFILIAL('SB2')
				SB2->B2_COD    := XD1->XD1_COD
				SB2->B2_LOCAL  := cLocExp
				SB2->(MsUnlock())
					ENDIF
				*/

					// Inserido por Michel Sander em 07.08.2014
					// Verifica pagamentos anteriores para a mesma SENF
					SD3->(DbOrderNickName("USUSD30002"))  // D3_FILIAL + D3_XXPV + D3_COD + D3_LOCAL
					SUMD3QTD1 := 0
					If SD3->( dbSeek( xFilial() + Subs(_cItem,1,8) + _cProduto ) )
						While !SD3->( EOF() ) .and. SD3->D3_XXPV + SD3->D3_COD == Subs(_cItem,1,8) + _cProduto
							If Empty(SD3->D3_ESTORNO) .and. SD3->D3_LOCAL == '13'
								If SD3->D3_CF == 'DE4'
									SUMD3QTD1 += SD3->D3_QUANT
								EndIf
								If SD3->D3_CF == 'RE4'
									SUMD3QTD1 -= SD3->D3_QUANT
								EndIf
							EndIf
							SD3->( dbSkip() )
						End
					EndIf
					If (_nQtd+SUMD3QTD1) > _nTotalOF
						cMess := "A quantidade lida "+TransForm(_nQtd,"@Z 999,999.99")+" é superior ao saldo do item que é de "+TransForm(_nTotalOF-SUMD3QTD1,"@Z 999,999.99")+"."
						AlertC(cMess)
						_lRet := .F.
					EndIF

					// ATUALIZA SALDO XD1 E TRANSFERENCIA PARA EXPEDICAO
					If _lRet
						IF SB8->( dbSeek( xFilial('SB8') + XD1->XD1_COD + XD1->XD1_LOCAL + XD1->XD1_LOTECT ) )


							If U_uMsgYesNo('Confirma a transferência?')

								SB2->( dbSetOrder(1) )
								CriaSB2(XD1->XD1_COD,"13")
							/*
								If !SB2->( dbSeek( xFilial() + XD1->XD1_COD + '13' ) )
							aCampos := {;
							{"B2_COD"                ,XD1->XD1_COD   ,Nil},;
							{"B2_LOCAL"              ,'13'           ,Nil} }
							MSExecAuto({|x,y| MATA225(x,y)},aCampos,3)
								EndIf
							*/

								_CENDER :=SUBSTR(_cEndereco,3,LEN(_cEndereco))

								IF cC6LOCAL =='13' // SE C6_LOCAL==13 TRANSFERE
									_cDoc	:= U_NEXTDOC() //GetSxENum("SD3","D3_DOC",1)
									_cDoc := _cDoc + SPACE(09)
									_cDoc := SUBSTR(_cDoc,1,9)

									Private lMsErroAuto := .F.

									_aAuto := {}
									aadd(_aAuto,{_cDoc,dDataBase})

									aadd(_aItem,SB1->B1_COD   )          //Produto Origem
									aadd(_aItem,SB1->B1_DESC  )          //Descricao Origem
									aadd(_aItem,SB1->B1_UM    )          //UM Origem
									aadd(_aItem,XD1->XD1_LOCAL)          //Local Origem
									aadd(_aItem,_CENDER       )          //Endereco Origem
									aadd(_aItem,SB1->B1_COD   )	         //Produto Destino
									aadd(_aItem,SB1->B1_DESC  )          //Descricao Destino
									aadd(_aItem,SB1->B1_UM    )          //UM destino
									aadd(_aItem,cLocExp       )          //Local Destino       EXPEDICAO

									If Empty(cLoteVen)
										aadd(_aItem,cEndExp)             //Endereco Destino    13EXPEDICAO
									Else
										aadd(_aItem,cEndPro)             //Endereco Destino    13PRODUCAO
									EndIf

									aadd(_aItem,""             )          //Numero Serie
									aadd(_aItem,XD1->XD1_LOTECT)	      //Lote Origem
									aadd(_aItem,""             )          //Sub Lote Origem
									aadd(_aItem,SB8->B8_DTVALID)	      //Validade Lote Origem
									aadd(_aItem,0              )          //Potencia
									aadd(_aItem,_nQtd          )   	      //Quantidade
									aadd(_aItem,0)		                  //Quantidade 2a. unidade
									aadd(_aItem,"")   	                  //ESTORNO
									aadd(_aItem,"")         	          //NUMSEQ
									aadd(_aItem,XD1->XD1_LOTECT)	      //Lote Destino
									aadd(_aItem,SB8->B8_DTVALID)	      //Validade Lote Destino
									aadd(_aItem,"")		                  //D3_ITEMGRD
									If nFCICalc == 1
										aadd(_aItem,0)                    //D3_PERIMP
									ENDIF
									If GetVersao(.F.,.F.) == "12"
										//aAdd(_aItem,"")   //D3_IDDCF
										aAdd(_aItem,"")   //D3_OBSERVACAO
									EndIf
									aadd(_aAuto,_aItem)

									MSExecAuto({|x,y| mata261(x,y)},_aAuto,_nOpcAuto)   // Transferência Mod II

									_nQtdOF :=_nQtdOF-_nQtd

									If lMsErroAuto
										MostraErro("\util\log\Transferencia_SENF\")
										//DisarmTransaction()
										U_MsgColetor("Erro na transferência entre endereços.")
									Else
										SD3->( dbSetOrder(2) )
										If SD3->( dbSeek( xFilial() + _cDoc ) )
											While !SD3->( EOF() ) .and. Alltrim(SD3->D3_DOC) == Alltrim(_cDoc)
												IF SD3->D3_CF == 'DE4' .or. SD3->D3_CF == 'RE4'
													If SD3->D3_COD == SB1->B1_COD
														If SD3->D3_EMISSAO == dDataBase
															If SD3->D3_QUANT == _nQtd
																If Empty(SD3->D3_XXPV)
																	Reclock("SD3",.F.)
																	SD3->D3_XXPECA := XD1->XD1_XXPECA
																	SD3->D3_XXPV   := _cItem
																	SD3->( msUnlock() )
																EndIf
																If !lCHkMov
																	//VERIFICA INTEGRIDADE DOS MOVIMENTOS
																	lCHkMov := U_CHKMOV(SD3->D3_COD, SD3->D3_NUMSEQ, SD3->( Recno()), "T")
																EndIf
															EndIf

														EndIf
													EndIf
												EndIf
												SD3->( dbSkip() )
											End
										EndIf

										// Após impressão verificar Ttansferência de estoque de PA para expedição e explodir embalagens
										// MICHEL SANDER 27.02.2019
										If GetMv("MV_XPAEXP")
											If !SB1->B1_TIPO $ "PA*PI"
												Reclock("XD1",.F.)
												XD1->XD1_QTDATU := _nSALDO
												IF _nSALDO <= 0
													XD1->XD1_OCORRE := '5'
												ENDIF
												XD1->(MsUnlock())
												fEtiqueta()
											Else
												Reclock("SC6",.F.)
												SC6->C6_NUMOP  := SubStr(XD1->XD1_OP,1,6)
												SC6->C6_ITEMOP := SubStr(XD1->XD1_OP,7,2)
												SC6->C6_LOTECT := XD1->XD1_LOTECT
												SC6->(MsUnlock())
												U_MsgColetor("Transferência de PA para expedição com sucesso.")
											EndIf
										Else
											Reclock("XD1",.F.)
											XD1->XD1_QTDATU := _nSALDO
											IF _nSALDO <= 0
												XD1->XD1_OCORRE := '5'
											ENDIF
											XD1->(MsUnlock())
											fEtiqueta()
										EndIf

										U_MsgColetor("Transferência realizada para o almox. 13 com sucesso.")
									EndIf
								Else
									U_MsgColetor("Almoxarifado da OF diferente de 13.")
								EndIf
							Else
								U_MsgColetor("Transferência cancelada.")
							ENDIF
						ELSE
							U_MsgColetor('Divergencia Saldo Lote')
							_lRet := .T.
						ENDIF
					EndIf
				ELSE
					U_MsgColetor('Cadastro sem controle por localização')
					_lRet := .T.
				ENDIF
			ELSE
				U_MsgColetor('Produto não encontrado.')
				_lRet := .T.
			ENDIF
		ELSE
			U_MsgColetor('Etiqueta não encontrada.')
			_lRet := .T.
		ENDIF
	ELSE
		U_MsgColetor('Etiqueta em Branco.')
		_lRet := .T.
	EndIf

	_cEtiqueta    := Space(_nTamEtiq+1)
	_nQtd         :=_nQtdOF

	oGetQtd:REFRESH()
	oTxtEtiqueta:REFRESH()
	IF _nQtd > 0 .AND. _lRet
		oTxtEtiqueta:SetFocus()
	ELSE
		_cItem        := Space(09)
		_cTxtPRODCOD  := Space(15)
		_cTxtPRODDES  := Space(40)
		_cTxtPRODEND  := Space(40)
		_cTxtPREND    := Space(40)
		_cEndereco    := Space(40)
		_nQtd         := 0
		_lRet         := .T.
		oGetItem:REFRESH()
		oTxtPRODCOD:REFRESH()
		oTxtPRODDES:REFRESH()
		oTxtPRODEND:REFRESH()
		oTxtPREND:REFRESH()
		oGetEndereco:REFRESH()
		oGetEtiq:REFRESH()
		oGetQtd:REFRESH()
	ENDIF

Return(_lRet)


	*----------------------------------------------------------
Static Function AlertC(cTexto)
	*----------------------------------------------------------
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

Return

Static Function BUSCAPVSEP(cPCouItem)

	aPVSep := {}

	cQuery := "SELECT C6_NUM, C6_ITEM, C6_PRODUTO, ZY_PRVFAT, ZY_QUANT FROM "+RetSqlName("SC6")+" SC6, "+RetSqlName("SZY")+" SZY WHERE    " + Chr(13)
	cQuery += "ZY_PEDIDO = C6_NUM AND ZY_ITEM = C6_ITEM                                " + Chr(13)
	cQuery += "AND C6_QTDENT < C6_QTDVEN                                               " + Chr(13)
	cQuery += "AND C6_XXSEPAR = 'S'                                                    " + Chr(13)
	cQuery += "AND C6_BLQ <> 'R'                                                       " + Chr(13)
	cQuery += "AND ZY_PRVFAT <> ''                                                     " + Chr(13)
	cQuery += "AND ZY_NOTA = ''                                                        " + Chr(13)
	cQuery += "AND SZY.D_E_L_E_T_ = ''                                              " + Chr(13)
	cQuery += "AND SC6.D_E_L_E_T_ = ''                                              " + Chr(13)
	If cPCouItem == "IT"
		cQuery += "AND C6_NUM 	= '"+Subs(_cPedido,1,6)+"'                                " + Chr(13)
	EndIf
	If cPCouItem == "PC"
		cQuery += "AND C6_NUM  NOT IN ("+Subs(cPcExcecao,1,Len(cPcExcecao)-1)+")           " + Chr(13)
	EndIf
	cQuery += "AND C6_ITEM NOT IN ("+Subs(cITExcecao,1,Len(cITExcecao)-1)+")           " + Chr(13)
	cQuery += "ORDER BY ZY_PRVFAT, C6_NUM, C6_ITEM                                     " + Chr(13)

	If Select("QUERYSC6") <> 0
		QUERYSC6->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS "QUERYSC6"

	While !QUERYSC6->( EOF() )                           //Qtd do zy sem NF  (4)Qtd faturada   (5) Qtd Separada
		AADD(aPVSep,{QUERYSC6->C6_NUM, QUERYSC6->C6_ITEM, QUERYSC6->ZY_QUANT , 0               , 0               })
		cQuery := "SELECT * FROM "+retsqlname("SZY")+" SZY WHERE ZY_PEDIDO = '"+QUERYSC6->C6_NUM+"' AND ZY_ITEM = '"+QUERYSC6->C6_ITEM+"' AND ZY_NOTA <> '' AND D_E_L_E_T_ = '' "

		If Select("QUERYSZY") <> 0
			QUERYSZY->( dbCloseArea() )                                                                                                               '
		EndIf

		TCQUERY cQuery NEW ALIAS "QUERYSZY"

		While !QUERYSZY->( EOF() )
			aPVSep[Len(aPVSep),4] += QUERYSZY->ZY_QUANT
			QUERYSZY->( dbSkip() )
		End

		SD3->(DbOrderNickName("USUSD30002"))  // D3_FILIAL + D3_XXPV + D3_COD + D3_LOCAL
		SUMD3QTD1 := 0
		If SD3->( dbSeek( xFilial() + QUERYSC6->C6_NUM + QUERYSC6->C6_ITEM + QUERYSC6->C6_PRODUTO ) )
			While !SD3->( EOF() ) .and. SD3->D3_FILIAL == xFilial("SD3") .and. SD3->D3_XXPV + SD3->D3_COD == QUERYSC6->C6_NUM + QUERYSC6->C6_ITEM + QUERYSC6->C6_PRODUTO
				If Empty(SD3->D3_ESTORNO) .and. SD3->D3_LOCAL == '13'
					If SD3->D3_CF == 'DE4'
						SUMD3QTD1 += SD3->D3_QUANT
					EndIf
					If SD3->D3_CF == 'RE4'
						SUMD3QTD1 -= SD3->D3_QUANT
					EndIf
				EndIf
				SD3->( dbSkip() )
			End
		EndIf

		aPVSep[Len(aPVSep),5] += SUMD3QTD1

		QUERYSC6->( dbSkip() )
	End

	_cItem := Space(9)

	For x := 1 to Len(aPVSep)
		//                                                  //Qtd do zy sem NF  (4)Qtd faturada   (5) Qtd Separada
		//AADD(aPVSep,{QUERYSC6->C6_NUM, QUERYSC6->C6_ITEM, QUERYSC6->ZY_QUANT , 0               , 0               })
		If aPVSep[x,5] < (aPVSep[x,3] + aPVSep[x,4])
			If cPCouItem == "PC"
				_cPedido   := aPVSep[x,1] + Space(1)
				_cItem := aPVSep[x,1] + aPVSep[x,2] + Space(1)
				cPcExcecao += "'"+aPVSep[x,1]+"',"
				cITExcecao := "'"+aPVSep[x,2]+"',"
				oGetPC:SetFocus()

				If SC5->( dbSeek( xFilial("SC5") + Subs(_cPedido,1,6)) )
					_cNCLIENTE   :=POSICIONE('SA1',1,xFILIAL('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_NOME')
					_cTxtCliente :=SUBSTR(SC5->C5_CLIENTE+'/'+SC5->C5_LOJACLI+'-'+_cNCLIENTE,1,28)
				EndIf

				If SC6->( dbSeek( xFilial("SC6") + Subs(_cItem,1,8)) )
					_cTxtPRODCOD := SC6->C6_PRODUTO
					_cTxtPRODDES := SUBSTR(SC6->C6_DESCRI,1,28)
					oTxtPRODCOD:Refresh()
					oTxtPRODDES:Refresh()
				EndIf

				oTxtCliente:REFRESH()
			EndIf

			If cPCouItem == "IT"
				_cItem := aPVSep[x,1] + aPVSep[x,2] + Space(1)
				cITExcecao += "'"+aPVSep[x,2]+"',"

				If SC6->( dbSeek( xFilial("SC6") + Subs(_cItem,1,8)) )
					_cTxtPRODCOD := SC6->C6_PRODUTO
					_cTxtPRODDES := SUBSTR(SC6->C6_DESCRI,1,28)
					oTxtPRODCOD:Refresh()
					oTxtPRODDES:Refresh()
				EndIf

				oGetItem:SetFocus()
			EndIf

			Exit
		EndIf
	Next x

	If Empty(_cItem)
		U_MsgColetor("Não existem outros itens deste pedido com pendência de separação.")
		oGetPC:SetFocus()
	EndIf

Return

Static Function fEtiqueta()

	//Local _cPorta  := "LPT1"
	//Local cModelo  := "TLP 2844"  // "Z4M"
	Local aAreaGER := GetArea()
	Local aAreaSA2 := SA2->( GetArea() )
	Local aAreaSB1 := SB1->( GetArea() )
	Local _cNome  := CriaVar("A2_NREDUZ")

	cXD1_XXPECA  := XD1->XD1_XXPECA
	cXD1_FORNEC  := XD1->XD1_FORNEC
	cXD1_LOJA    := XD1->XD1_LOJA
	cXD1_DOC     := XD1->XD1_DOC
	cXD1_SERIE   := XD1->XD1_SERIE
	cXD1_ITEM    := XD1->XD1_ITEM
	cXD1_COD     := XD1->XD1_COD
	cXD1_LOCAL   := "13"
	cXD1_TIPO    := XD1->XD1_TIPO
	cXD1_LOTECT  := XD1->XD1_LOTECT
	cXD1_DTDIGI  := XD1->XD1_DTDIGI
	cXD1_FORMUL  := XD1->XD1_FORMUL

	If Empty(cLoteVen)
		cXD1_LOCALI := cEndExp
	Else
		cXD1_LOCALI := cEndPro
	EndIf

	cXD1_USERID  := __cUserId
	cXD1_OCORRE  := "4"
	cXD1_QTDORI  := _nQtd
	cXD1_QTDATU  := _nQtd
	cXD1_NIVEMB  := '1'

	_cProxPeca := U_IXD1PECA()
	Reclock("XD1",.T.)
	XD1->XD1_FILIAL  := xFilial("XD1")
	XD1->XD1_XXPECA  := _cProxPeca
	XD1->XD1_FORNEC  := cXD1_FORNEC
	XD1->XD1_LOJA    := cXD1_LOJA
	XD1->XD1_DOC     := cXD1_DOC
	XD1->XD1_SERIE   := cXD1_SERIE
	XD1->XD1_ITEM    := cXD1_ITEM
	XD1->XD1_COD     := cXD1_COD
	XD1->XD1_LOCAL   := cXD1_LOCAL
	XD1->XD1_TIPO    := cXD1_TIPO
	XD1->XD1_LOTECT  := cXD1_LOTECT
	XD1->XD1_DTDIGI  := cXD1_DTDIGI
	XD1->XD1_FORMUL  := cXD1_FORMUL
	XD1->XD1_LOCALI  := cXD1_LOCALI
	XD1->XD1_USERID  := cXD1_USERID
	XD1->XD1_OCORRE  := cXD1_OCORRE
	XD1->XD1_QTDORI  := cXD1_QTDORI
	XD1->XD1_QTDATU  := cXD1_QTDATU
	XD1->XD1_NIVEMB  := cXD1_NIVEMB
	XD1->XD1_PVSENF := SUBSTR(_cItem,1,8)
	XD1->( MsUnlock() )

	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1")+XD1->XD1_COD))
	_cDescri:= StrTran(SubStr(SB1->B1_DESC,1,33),'"',"")

	SC5->( dbSetOrder(1) )
	If SC5->( dbSeek( xFilial("SC5") + Subs(_cPedido,1,6)) )

	Else
		U_MsgColetor("Erro na localização do Pedido para impressão da etiqueta.")
		Return
	EndIf

	SA1->( dbSetOrder(1) )
	If SA1->( dbSeek( xFilial() + SC5->C5_CLIENTE + SC5->C5_LOJACLI ) )

	Else
		U_MsgColetor("Erro na localização do Cliente para impressão da etiqueta.")
		Return
	EndIf

	SZY->( dbSetOrder(2) )
	dDtFatur := CtoD("")
	If SZY->( dbSeek( xFilial() + Subs(_cItem,1,8) ) )
		While !SZY->( EOF() )  .and. SZY->ZY_PEDIDO + SZY->ZY_ITEM == Subs(_cItem,1,8)
			If Empty(SZY->ZY_NOTA)
				dDtFatur := SZY->ZY_PRVFAT
				Exit
			EndIf
			SZY->( dbSkip() )
		End
	Else
	EndIf

	/*MSCBPrinter(cModelo,_cPorta,,,.F.)
	MSCBChkStatus(.F.)
	MSCBBegin(1,6)
//MSCBBegin(1,2)

//MSCBSay(30,00,"Prod:"+XD1->XD1_COD + "  " + Alltrim(Transform(XD1->XD1_QTDATU,"@E 999,999.9999")),"N","2","1,1")
//MSCBSay(30,03,_cDescri,"N","2","1,1")
//MSCBSay(26,06,"Forn:"+XD1->XD1_FORNEC+"/"+XD1->XD1_LOJA+"-"+_cNome,"N","2","1,1")
*/
	//cFila := "000023"
	cFila := SuperGetMv("MV_XFILEST",.F.,"000023")
	IF !CB5SetImp(cFila,.F.)
		U_MsgColetor("Local de impressao invalido!")
		Return .F.
	EndIf

	MSCBBegin(1,6)
	MSCBSay(30,00,"PEDIDO:" + SZY->ZY_PEDIDO + "/"  + SZY->ZY_ITEM + "-" + SA1->A1_NOME,"N","2","1,1")
	MSCBSay(30,03,"PROD:" + Alltrim(XD1->XD1_COD),"N","2","1,1")
	MSCBSay(30,06,"DESC:" + _cDescri,"N","2","1,1")
	MSCBSay(30,09,"QTD:" + Alltrim(Transform(XD1->XD1_QTDATU,"@E 999,999.9999"))    ,"N","2","1,1")
	MSCBSay(59,09,"DT:" + DtoC(dDtFatur)    ,"N","2","1,1")

	MSCBSayBar(30,12,AllTrim(XD1->XD1_XXPECA),"N","MB04",10,.F.,.T.,.F.,,3,Nil,Nil,Nil,Nil,Nil)
	MSCBEnd()
	Sleep(500)
	MSCBClosePrinter()

	RestArea(aAreaSA2)
	RestArea(aAreaSB1)
	RestArea(aAreaGER)

Return
