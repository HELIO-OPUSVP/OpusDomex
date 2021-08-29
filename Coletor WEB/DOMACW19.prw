#include "TbiConn.ch"
#include "TbiCode.ch"
#include "Rwmake.ch"
#include "Topconn.ch"
#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DOMACD19  ºAutor  ³Michel Sander       º Data ³  09.02.16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela de montagem da embalagem para faturamento (expedição) º±±
±±º          ³ 											                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMACW19()

	Private oTxtOP,oGetOP,oTxtEtiq,oGetEtiq,oTxtProd,oGetProd,oTxtQtd,oGetQtd,oMark,oTxtQtdEmp,oMainEti
	Private _nTamEtiq      := 21
	Private _cNumEtqPA     := Space(_nTamEtiq)
	Private _cProduto      := CriaVar("B1_COD",.F.)
	Private _nQtd          := CriaVar("XD1_QTDATU",.F.)
	Private _cLoteEti      := CriaVar("BF_LOTECTL",.F.)
	Private _aCols         := {}
	Private _lAuto	        := .T.
	Private _lIndividual   := .T.
	Private _cCodInv
	Private cGetEnd        := Space(2+15+1)
	Private _cProdEmp	     := Space(15)
	Private _cNomCli       := Space(15)
	Private _cDescric	     := Space(27)
	Private _cDescEmb      := Space(27)
	Private _cEmbalag	     := Space(15)
	Private _cNumOp        := SPACE(11)
	Private _cNumPed       := SPACE(06)
	Private _nQtdEmp       := 0
	Private _aDados        := {}
	Private _aEnd          := {}
	Private _nCont
	Private _cDtaFat       := dDataBase
	Private nQtdCaixa      := 0
	Private cTipoSenf      := ""
	Private nSaldoEmb      := 0
	Private cGrupoItem     := ""
	Private cVolumeAtu     := SPACE(17)
	Private nSaldoGrupo    := 0
	Private nTotalGrupo    := 0
	Private nRestaGrupo    := 0
	Private nPesoEmb       := 0
	Private nPesoBruto     := 0
	Private nNovoPeso      := 0
	Private nDesconta      := 0
	Private cLocProcDom    := GetMV("MV_XXLOCPR")
	Private aEmbBip        := {}
	Private aSeqBib        := {}
	Private aEmbPed        := {}
	Private aEmb           := {}
	Private aProdEmb       := {}
	Private lPesoEmb       := .F.
	Private oTelaPeso
	Private cGrupoesp      := "'TRUN'"  //"'TRUN','CORD'"
	Private lBeginSQL      := .F.
	Private cZY_SEQ        := ""
	Private cNivelFat      := ""
	Private cPedTel        := ""
	Private lSelPorItem    := .F.
	Private lPadTec        := .F.
	Private lTelefonic     := .F.
	Private nDisponivel    := 0
	Private nPesoTel       := 0
	Private cOpTelef       := ""
	Private cAliasTEL      := ""
	Private cOPItemPV      := ""
	Private _cNumSite      := ""
	Private lNewL87        := SuperGetMv("MV_XNEWL87",.F., .F.)
	Private nWebPx:= 1.5
	Private cPush:= "background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 gray);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
		"background-repeat:no-repeat ;border-radius: 6px;}"
	Private cPressed:= "background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 blue);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
		"background-repeat:no-repeat ;border-radius: 6px;}"
	Private cHover:="background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 Black);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
		"background-repeat:no-repeat ;border-radius: 6px;}"
	Private lEhClaro  := .F.


	dDataBase := Date()

	If cUsuario == 'HELIO'
		_cNumEtqPA := Space(_nTamEtiq)
		//_cNumEtqPA := '000021017360   '
		//_cDtaFat   := CtoD('17/03/17')
	EndIf

	Define MsDialog oTelaOP Title OemToAnsi("Embalagens " + DtoC(dDataBase) ) From 0,0 To 450,302 Pixel of oMainWnd PIXEL

	nLin := 005
	@ nLin,001 Say oTxtEtiq    Var "Num.Etiq." Pixel Of oTelaOP
	@ nLin-2,046 MsGet oGetOP  Var _cNumEtqPA Valid VldEtiq() Size 70*nWebPx,10*nWebPx Pixel Of oTelaOP
	oTxtEtiq:oFont := TFont():New('Arial',,17*nWebPx,,.T.,,,,.T.,.F.)
	oGetOP:oFont := TFont():New('Arial',,20*nWebPx,,.T.,,,,.T.,.F.)

	@ 025*nWebPx,001 To 065*nWebPx,115*nWebPx Pixel Of oMainWnd PIXEL

	@ 021*nWebPx,005 Say oTxtProdEmp  Var "Produto: "        Pixel Of oTelaOP
	@ 019*nWebPx,035 Say oTxtProdCod  Var _cProdEmp          Pixel Of oTelaOP
	@ 029*nWebPx,005 Say oTxtDes      Var "Descrição: "      Pixel Of oTelaOP
	@ 029*nWebPx,035 say oTxtDescPro  Var _cDescric      Size 075*nWebPx,15*nWebPx Pixel Of oTelaOP
	oTxtDescPro:oFont := TFont():New('Arial',,14*nWebPx,,.T.,,,,.T.,.F.)

	nLin+= 40*nWebPx
	@ nLin,005 Say oTxtOP Var "Num.OP: " Pixel Of oTelaOP
	@ nLin,031 Say oNumOP Var _cNumOP Size 120*nWebPx,10*nWebPx Pixel Of oTelaOP
	@ nLin,090 Say oTxtQtdEmp   Var "Qtd: "+ TransForm(_nQtdEmp,"@E 999,999.99") Pixel Of oTelaOP
	oNumOp:oFont:= TFont():New('Arial',,15*nWebPx,,.T.,,,,.T.,.F.)
	oTxtQtdEmp:oFont  := TFont():New('Arial',,14*nWebPx,,.T.,,,,.T.,.F.)
	oTxtProdCod:oFont  := TFont():New('Arial',,14*nWebPx,,.T.,,,,.T.,.F.)

	nLin+= 10*nWebPx
	@ nLin+4,005 Say oTxtPed Var "Pedido: " Pixel Of oTelaOP
	@ nLin+4,031 Say oNumPed Var _cNumPed+'-'+_cNomCli Size 120*nWebPx,10*nWebPx Pixel Of oTelaOP
	oNumPed:oFont:= TFont():New('Arial',,15*nWebPx,,.T.,,,,.T.,.F.)

	nLin+= 05*nWebPx
	@ 070*nWebPx,001 To 145*nWebPx,115*nWebPx Pixel Of oMainWnd PIXEL
	nLin+= 12*nWebPx
	@ nLin+4,005 Say oTxtEmbalag  Var "Embalagem: " Pixel Of oTelaOp
	@ nLin+2,040 Say oTxtCodEmb   Var _cEmbalag 	 Pixel Of oTelaOP
	nLin+= 14
	@ nLin,005 SAY oTxtDescEmb Var _cDescEmb 		 Pixel Of oTelaOp
	oTxtDescEmb:oFont := TFont():New('Arial',,14*nWebPx,,.T.,,,,.T.,.F.)
	oTxtCodEmb:oFont := TFont():New('Arial',,14*nWebPx,,.T.,,,,.T.,.F.)

	nLin += 10*nWebPx
	@ nLin,005   Say   oTxtDtfat Var "Faturamento:" Pixel Of oTelaOp
	@ nLin-3,060 MSGET oDataFat  Var _cDtaFat When .T. VALID vlddata() Size 50*nWebPx,10*nWebPx Pixel Of oTelaOP
	oDataFat:oFont:= TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
	nLin+= 11*nWebPx

	@ nLin,005   Say oTxtSldGrupo Var "Volumes do Pedido:" Pixel Of oTelaOP
	@ nLin-1,060 MSGET oSldGrupo  Var cVolumeAtu When .F. Size 50*nWebPx,10*nWebPx Pixel Of oTelaOP
	oSldGrupo:oFont:= TFont():New('Arial',,20*nWebPx,,.T.,,,,.T.,.F.)

	nLin += 15*nWebPx
	@ nLin,005 Say oTxtSaldoEmb  Var "Qtde. por Volume: " Pixel Of oTelaOP
	@ nLin-2,060 MsGet oSaldoEmb Var nSaldoEmb When .F. Picture "@E 999,999,999" Size 50*nWebPx,10*nWebPx  Pixel Of oTelaOP
	oSaldoEmb:oFont := TFont():New('Arial',,20*nWebPx,,.T.,,,,.T.,.F.)

	nLin += 14*nWebPx
	@ nLin  ,005 Say oTxtQtd    Var "Qtd.Lida " Pixel Of oTelaOP
	@ nLin-2,060 MsGet oGetQtd  Var _nQtd Valid ValidQtd() When .F. Picture "@E 9,999,999" Size 50*nWebPx,10*nWebPx  Pixel Of oTelaOP
	oTxtQtd:oFont := TFont():New('Arial',,17*nWebPx,,.T.,,,,.T.,.F.)
	oGetQtd:oFont := TFont():New('Arial',,20*nWebPx,,.T.,,,,.T.,.F.)

	nLin+= 16*nWebPx
	@ nLin,077 Button oEtiqueta PROMPT "Etiqueta" Size 35*nWebPx,10*nWebPx //Action oTelaOp:End() //Pixel Of oTelaOP //Processa({ || U_CalPesoEmb(SC2->C2_PEDIDO,SC2->C2_PRODUTO), ImpNivel3()}) Pixel Of oTelaOp
	cCSSBtN1 := "QPushButton{"+cPush+;
		"QPushButton:pressed {"+cPressed+;
		"QPushButton:hover {"+cHover
	oEtiqueta:setCSS(cCSSBtN1)

	Activate MsDialog oTelaOP

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VldEtiq  ºAutor  ³Michel Sander       º Data ³  09.02.16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação da embalagem bipada										  º±±
±±º          ³ 														                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VldEtiq()

	Local cWhereG1 := ''
	Local _lRet    := .T.
	Local _nxy

	_cProdEmp      := ""
	_cDescric      := ""
	_cEmbalag      := ""
	_nQtdEmp       := 0
	_aDados        := {}

	If Empty(_cNumEtqPA)
		Return .T.
	Elseif len (alltrim(_cNumEtqPA)) > 0
		_cNumEtqPA:= alltrim(_cNumEtqPA)
	EndIf



	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Prepara número da etiqueta bipada							³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(AllTrim(_cNumEtqPA))<=12 //EAN 13 s/ dígito verificador.
		_cNumEtqPA := "0"+_cNumEtqPA
		_cNumEtqPA := Subs(_cNumEtqPA,1,12)
	EndIf

	SC2->( dbSetOrder(1) )
	SB1->( dbSetOrder(1) )
	SBF->( dbSetOrder(2) )

	If XD1->(dbSeek(xFilial("XD1")+_cNumEtqPA))

		SB1->(dbSeek(xFilial("SB1")+XD1->XD1_COD))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica separação												³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(XD1->XD1_PVSEP)
			U_MsgColetor("Esta embalagem já está separada para o pedido/item "+XD1->XD1_PVSEP)
			_cNumEtqPA := Space(_nTamEtiq)
			oGetOp:Refresh()
			oGetOp:SetFocus()
			Return(.F.)
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica cancelamento da embalagem							³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If XD1->XD1_OCORRE == "5"
			U_MsgColetor("Esta embalagem está cancelada.")
			_cNumEtqPA := Space(_nTamEtiq)
			oGetOp:Refresh()
			oGetOp:SetFocus()
			Return(.F.)
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica liberação da embalagem								³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If XD1->XD1_OCORRE == "6"
			U_MsgColetor("Esta embalagem ainda não foi liberada para a expedição.")
			_cNumEtqPA := Space(_nTamEtiq)
			oGetOp:Refresh()
			oGetOp:SetFocus()
			Return(.F.)
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Montagem de Volumes 												³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SB1->B1_TIPO <> 'PR'

			XD2->(dbSetOrder(1))
			If XD2->(dbSeek(xFilial("XD2")+XD1->XD1_XXPECA))

				_cNumOp   := XD1->XD1_OP

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Atualiza etiqueta bipada										³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If aScan(aEmbBip,{ |aVet| aVet[1] == _cNumEtqPA }) == 0

					If SC2->(dbSeek(xFilial("SC2")+XD1->XD1_OP)) //.Or. (XD1->XD1_NIVEMB == '1' .and. SB1->B1_TIPO == 'PR')

						SA1->(dbSeek(xFilial("SA1")+SC2->C2_CLIENT))

						SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Verifica se o Cliente é HUAWEI								³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						lSelPorItem := If("HUAWEI" $ SA1->A1_NOME, .T., .F.)

						If !lSelPorItem
							If ("ALCATEL" $ SA1->A1_NOME)
								lSelPorItem := .T.
							EndIf
							If GetMv("MV_XVERTEL")
								If ("TELEFONICA" $ SA1->A1_NREDUZ)
									lSelPorItem := .T.
								EndIf
								If ("ERICSSON" $ SA1->A1_NOME)
									lSelPorItem := .T.
								EndIf
							EndIf
							If GetMv("MV_XVEROI")
								If ("OI S" $ Upper(SA1->A1_NOME)) .Or. ("OI MO" $ Upper(SA1->A1_NOME)) .Or. ("TELEMAR" $ Upper(SA1->A1_NOME)) .Or. ("BRASIL TELECOM COMUNICACAO MUL" $ Upper(SA1->A1_NOME))
									lSelPorItem := .T.
								EndIf
							EndIf

							//Verifica se é clietne CLARO
							//If GetMv("MV_XVERCLA")
							If ("CLARO" $ Upper(SA1->A1_NOME)) .Or. ("CLARO" $ Upper(SA1->A1_NREDUZ)) .Or. ("BRASIL TELECOM COMUNICACAO MUL" $ Upper(SA1->A1_NOME))
								lSelPorItem := .T.
								lEhClaro := .T.
							EndIf
							//EndIf
						EndIf


						lPadTec := If("PADTEC" $ SA1->A1_NOME, .T., .F.)

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Verifica se o Cliente é TELEFONICA							³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						lTelefonic := .F.
						If ("TELEFONICA" $ Upper(SA1->A1_NOME)) .Or. ("TELEFONICA" $ Upper(SA1->A1_NREDUZ))
							lTelefonic := .T.
						EndIf

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Verifica pedido de venda										³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If !Empty(_cNumPed)
							If ( SC2->C2_PEDIDO <> _cNumPed ) .And. !Empty(_cNumPed)
								U_MsgColetor("Pedido diferente da coleta atual.")
								_cNumEtqPA := Space(_nTamEtiq)
								oGetOp:Refresh()
								oGetOp:SetFocus()
								Return(.F.)
							EndIf
						Else
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Verifica se trocou de pedido entre volumes				³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ1ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

							If nTotalGrupo > 0
								cVolumeAtu := SPACE(20)
								nTotalGrupo := 0
								aEmbPed     := {}
								aEmb        := {}
							EndIf

						EndIf

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Verifica se coleta o mesmo produto para calculo peso	³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If aScan(aProdEmb,SC2->C2_PRODUTO) == 0
							AADD(aProdEmb,SC2->C2_PRODUTO)
						EndIf

						_nQtdEmp := SC2->C2_QUANT
						SC6->(dbSetOrder(7))  // C6_FILIAL+C6_NUMOP+C6_ITEMOP
						If !SC6->(dbSeek(xFilial("SC6")+SC2->C2_NUM+SC2->C2_ITEM))
							U_MsgColetor("Não existem pedidos para esse item.")
							_cNumEtqPA := Space(_nTamEtiq)
							oGetOp:Refresh()
							oGetOp:SetFocus()
							Return(.F.)
						Else

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Verifica se coleta pedido por Item							³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If lSelPorItem
								If !Empty(cGrupoItem)
									If ( SC6->C6_NUM+SC6->C6_ITEM <> cGrupoItem ) .And. !Empty(cGrupoItem)
										U_MsgColetor("Item "+SC6->C6_ITEM+" diferente da coleta atual do item "+SubStr(cGrupoItem,7,3))
										_cNumEtqPA := Space(_nTamEtiq)
										oGetOp:Refresh()
										oGetOp:SetFocus()
										Return(.F.)
									EndIf
								EndIf
							EndIf

							If SC6->C6_PRODUTO == SC2->C2_PRODUTO

								If lSelPorItem
									cGrupoItem := SC6->C6_NUM+SC6->C6_ITEM
								Else
									cGrupoItem := SB1->B1_GRUPO
								EndIf

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Verifica site para Padtec						 		  ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								lPadTec := .F.	// Desligado Controle de Separação por Site do cliente por Michel Sander em 13.12.2018
								If lPadTec
									If ( AllTrim(SC6->C6_XXSITE) <> AllTrim(_cNumSite) ) .And. !Empty(_cNumSite)
										U_MsgColetor("Site diferente da coleta atual.")
										_cNumEtqPA := Space(_nTamEtiq)
										oGetOp:Refresh()
										oGetOp:SetFocus()
										Return(.F.)
									Else
										_cNumSite  := SC6->C6_XXSITE
										cGrupoItem := SC6->C6_XXSITE
									EndIf
								EndIf

								cOpPedido  := SC6->C6_NUM
								cOPItemPV  := SC6->C6_ITEM

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Busca Nivel de Embalagem para Faturamento 		  ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								dbSelectArea("SB1")
								If Empty(SB1->B1_XXNIVFT)
									cNivelFat := "3"
								Else
									cNivelFat :=SB1->B1_XXNIVFT
								EndIf

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Acumula o total dos grupos do pedido				  ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If aScan(aEmbPed,{ |x| x[1] == cGrupoItem }) == 0

									nTotCx2PV  := 0
									//aTotCx2PV  := {}
									nCx2SepPv  := 0
									nQtdPed    := 0

									// Inserido por Michel Sander em 19.02.16 para calcular os volumens baseado na previsao de faturamento
									SZY->(dbSetOrder(1))
									If !SZY->(dbSeek(xFilial("SZY")+SC6->C6_NUM))  // arrumar: olhar quais produtos estão nessa caixa e ver se te programação SZY somente para estes produtos
										U_MsgColetor("Não existe programação de faturamento para esse produto.")
										_cNumEtqPA := Space(_nTamEtiq)
										oGetOp:Refresh()
										oGetOp:SetFocus()
										Return(.F.)
									Else
										lDataFat  := .F.
										cPedAuxZY := AllTrim(SZY->ZY_PEDIDO )
										Do While SZY->(!Eof()) .And. SZY->ZY_PEDIDO == SC6->C6_NUM
											If SZY->ZY_PRVFAT == _cDtaFat .and. SZY->ZY_ITEM == SC6->C6_ITEM
												lDataFat := .T.
												Exit
											EndIf
											SZY->(dbSkip())
										EndDo
										If !lDataFat
											U_MsgColetor("Não existe programação de faturamento do Pedido/Item "+cPedAuxZY+" para '"+DtoC(_cDtaFat)+"'.")
											_cNumEtqPA := Space(_nTamEtiq)
											oGetOp:Refresh()
											oGetOp:SetFocus()
											Return(.F.)
										EndIf
									EndIf

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³Verifica inconsistencia de embalagem na estrutura ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									cAliasSG1 := GetNextAlias()
									cWhereG1  := "%G1_COD = '"+SC2->C2_PRODUTO+"'%"
									BeginSQL Alias cAliasSG1

										SELECT G1_COD, COUNT(*) G1_SOMA FROM %table:SG1% SG1 (NOLOCK)
										WHERE SG1.%NotDel%
										AND G1_XXEMBNI = '2'
										AND %Exp:cWhereG1%
										GROUP BY G1_COD HAVING COUNT(*) > 1 ORDER BY G1_COD

									EndSQL

									If (cAliasSG1)->G1_SOMA > 1
										U_MsgColetor("Existe mais de uma embalagem nível 2 na estrutura do produto. Corrija a estrutura.")
										_cNumEtqPA := Space(_nTamEtiq)
										oGetOp:Refresh()
										oGetOp:SetFocus()
										(cAliasSG1)->(dbCloseArea())
										Return(.F.)
									EndIf
									(cAliasSG1)->(dbCloseArea())

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³Se não agrupar por SITE DE ENTREGA, verificar SZY						 ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									lPadtec := .F.  // Desligado Controle de Separação por Site do cliente por Michel Sander em 13.12.2018
									If !lPadTec

										// Inserido por Michel Sander em 19.02.16 para calcular os volumens baseado na previsao de faturamento
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³Calcula a quantidade de volumes pela previsao 	 ³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										cAliasSZY := GetNextAlias()
										If !Empty(cGrupoItem)
											If cNivelFat == '3'
												If lSelPorItem
													cWhere    := "%G1_XXEMBNI = '2' AND "+"ZY_PEDIDO ='"+cOpPedido+"' AND ZY_ITEM='"+cOPItemPV+"'%"
												Else
													cWhere    := "%B1_GRUPO ='"+cGrupoItem+"' AND G1_XXEMBNI = '2' AND "+"ZY_PEDIDO ='"+cOpPedido+"'%"
												EndIf
											Else
												If lSelPorItem
													cWhere    := "%ZY_PEDIDO ='"+cOpPedido+"' AND ZY_ITEM='"+cOPItemPV+"'%"
												Else
													cWhere    := "%B1_GRUPO ='"+cGrupoItem+"' AND "+"ZY_PEDIDO ='"+cOpPedido+"'%"
												EndIf
											EndIf
										Else
											If cNivelFat == '3'
												cWhere    := "%G1_XXEMBNI = '2' AND "+"ZY_PEDIDO ='"+cOpPedido+"'%"
											Else
												cWhere    := "%ZY_PEDIDO ='"+cOpPedido+"'%"
											EndIf
										EndIf
										cWhereSZY   := "%ZY_PRVFAT ='"+Dtos(_cDtaFat)+"' AND ZY_NOTA = ''%"

										If lBeginSQL
											If cNivelFat == "3"
												BeginSQL Alias cAliasSZY
												SELECT ZY_PEDIDO, ZY_ITEM, ZY_SEQ, ZY_PRVFAT, G1_QUANT, (ZY_QUANT-ZY_QUJE) ZY_QUANT, (ZY_QUANT*G1_QUANT) ZY_VOLUMES,
												CASE
												WHEN (ZY_QUANT*G1_QUANT) <> CAST((ZY_QUANT*G1_QUANT) as INT) THEN CAST(((ZY_QUANT*G1_QUANT)+1) as INT) 
												WHEN (ZY_QUANT*G1_QUANT)  = CAST((ZY_QUANT*G1_QUANT) as INT) THEN CAST((ZY_QUANT*G1_QUANT) as INT)  
												END ZY_VOLUME_FINAL
											From %table:SZY% SZY (NOLOCK)
											JOIN %table:SG1% SG1 (NOLOCK)
											ON G1_FILIAL = '' AND G1_COD = ZY_PRODUTO
											JOIN %table:SB1% SB1 (NOLOCK)
											ON B1_FILIAL = '' AND B1_COD = ZY_PRODUTO
											WHERE SG1.%NotDel%
											And SZY.%NotDel%
											And SB1.%NotDel%
											And %Exp:cWhere%
											And %Exp:cWhereSZY%
											ORDER BY G1_COD
											EndSQL
										Else
											BeginSQL Alias cAliasSZY
											SELECT ZY_PEDIDO, ZY_ITEM, ZY_SEQ, ZY_PRVFAT, (ZY_QUANT-ZY_QUJE) ZY_QUANT, (ZY_QUANT-ZY_QUJE) ZY_VOLUMES
											From %table:SZY% SZY (NOLOCK)
											JOIN %table:SB1% SB1 (NOLOCK)
											ON B1_FILIAL = '' AND B1_COD = ZY_PRODUTO
											WHERE SZY.%NotDel%
											And SB1.%NotDel%
											And %Exp:cWhere%
											And %Exp:cWhereSZY%
											ORDER BY ZY_PRODUTO
											EndSQL
										EndIf
									Else
										// Query comentada por Hélio
										If cNivelFat == '3'
											cQuery := "SELECT ZY_PEDIDO, ZY_ITEM, ZY_SEQ, ZY_PRVFAT, G1_QUANT, (ZY_QUANT-ZY_QUJE) ZY_QUANT, (ZY_QUANT*G1_QUANT) ZY_VOLUMES, " + Chr(13)
											cQuery += "CASE "																																			+ Chr(13)
											cQuery += "   WHEN (ZY_QUANT*G1_QUANT) <> CAST((ZY_QUANT*G1_QUANT) as INT) THEN CAST(((ZY_QUANT*G1_QUANT)+1) as INT) " 	+ Chr(13)
											cQuery += "   WHEN (ZY_QUANT*G1_QUANT)  = CAST((ZY_QUANT*G1_QUANT) as INT) THEN CAST((ZY_QUANT*G1_QUANT) as INT)  " 		+ Chr(13)
											cQuery += "END ZY_VOLUME_FINAL " + Chr(13)
											cQuery += "			From SZY010 SZY (NOLOCK) "                                                      + Chr(13)
											cQuery += "			JOIN SG1010 SG1 (NOLOCK) "                                                      + Chr(13)
											cQuery += "			ON G1_FILIAL = '"+xFilial("SG1")+"' AND G1_COD = ZY_PRODUTO   "                 + Chr(13)
											cQuery += "			JOIN SB1010 SB1 (NOLOCK) "                                                      + Chr(13)
											cQuery += "			ON B1_COD = ZY_PRODUTO   "                                                      + Chr(13)
											cQuery += "			WHERE SG1.D_E_L_E_T_ = '' "                                                     + Chr(13)
											cQuery += "					And SZY.D_E_L_E_T_ = '' "                                                 + Chr(13)
											cQuery += "					And SB1.D_E_L_E_T_ = '' "                                                 + Chr(13)
											cQuery += "					And " + StrTran(cWhere    ,'%','')                                        + Chr(13)
											cQuery += "					And " + StrTran(cWhereSZY ,'%','')                                        + Chr(13)
											cQuery += "					ORDER BY G1_COD "                                                         + Chr(13)
										Else
											cQuery := "SELECT ZY_PEDIDO, ZY_ITEM, ZY_SEQ, ZY_PRVFAT, (ZY_QUANT-ZY_QUJE) ZY_QUANT, (ZY_QUANT-ZY_QUJE) ZY_VOLUMES "  + Chr(13)
											cQuery += "			From SZY010 SZY (NOLOCK) "                                                      + Chr(13)
											cQuery += "			JOIN SB1010 SB1 (NOLOCK) "                                                      + Chr(13)
											cQuery += "			ON B1_COD = ZY_PRODUTO   "                                                      + Chr(13)
											cQuery += "			WHERE	SZY.D_E_L_E_T_ = '' "                                                 	  + Chr(13)
											cQuery += "					And SB1.D_E_L_E_T_ = '' "                                                 + Chr(13)
											cQuery += "					And " + StrTran(cWhere    ,'%','')                                        + Chr(13)
											cQuery += "					And " + StrTran(cWhereSZY ,'%','')                                        + Chr(13)
											cQuery += "					ORDER BY ZY_PRODUTO "                                                     + Chr(13)
										EndIf

										TCQUERY cQuery new alias &(cAliasSZY)

									EndIf

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³Validando apenas uma progrmação de fatuamento para cada item de PV
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									aTemp := {}

									Do While (cAliasSZY)->(!Eof())
										If aScan(aTemp, (cAliasSZY)->(ZY_PEDIDO+ZY_ITEM+ZY_PRVFAT) ) == 0
											AADD(aTemp,(cAliasSZY)->(ZY_PEDIDO+ZY_ITEM+ZY_PRVFAT) )
										Else
											U_MsgColetor("Existem duas previsões de faturamento para o mesmo item de Pedido com esta data")
											_cNumEtqPA := Space(_nTamEtiq)
											oGetOp:Refresh()
											oGetOp:SetFocus()
											Return(.F.)
										EndIf
										(cAliasSZY)->(dbSkip())
									EndDo

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³Validação entre Previsão de Faturamento e Pedido de vendas  ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									cQuery   := "SELECT ZY_PEDIDO, ZY_ITEM, SUM(ZY_QUANT) AS ZY_QUANT FROM SZY010 WHERE ZY_PEDIDO ='"+cOpPedido+"' AND D_E_L_E_T_ = '' GROUP BY ZY_PEDIDO, ZY_ITEM ORDER BY ZY_ITEM "
									If Select("QUERYSZY") <> 0
										QUERYSZY->( dbCloseArea() )
									EndIf
									TCQUERY cQuery NEW ALIAS 'QUERYSZY'
									nTemp1 := 0
									nTemp2 := 0
									While !QUERYSZY->( EOF() )
										nTemp1++
										QUERYSZY->(dbSkip())
									End
									SC6->( dbSetOrder(1) )
									If SC6->( dbSeek( xFilial() + cOpPedido ) )
										While !SC6->( EOF() ) .and. SC6->C6_NUM == cOpPedido
											nTemp2++
											SC6->( dbSkip() )
										End
									EndIf
									If nTemp1 <> nTemp2
										U_MsgColetor("Número de Itens do Pedido de Vendas ("+Alltrim(Str(nTemp2))+") diferente da Previsão de Faturamento ("+Alltrim(Str(nTemp1))+").")
										_cNumEtqPA := Space(_nTamEtiq)
										oGetOp:Refresh()
										oGetOp:SetFocus()
										Return(.F.)
									EndIf
									QUERYSZY->( dbGoTop() )
									While !QUERYSZY->( EOF() )
										If SC6->( dbSeek( xFilial() + QUERYSZY->ZY_PEDIDO + QUERYSZY->ZY_ITEM ) )
											If QUERYSZY->ZY_QUANT <> SC6->C6_QTDVEN
												U_MsgColetor("Quantidade do Pedido ("+Alltrim(Str(SC6->C6_QTDVEN))+") diferente da quantidade da Previsão de Faturamento ("+Alltrim(Str(QUERYSZY->ZY_QUANT))+"). Pedido/Item: " + QUERYSZY->ZY_PEDIDO + '/' + QUERYSZY->ZY_ITEM+'.')
												_cNumEtqPA := Space(_nTamEtiq)
												oGetOp:Refresh()
												oGetOp:SetFocus()
												Return(.F.)
											EndIf
										Else
											U_MsgColetor("Não foi encontrada Previsão de Faturamento para o Pedido/Item: " + QUERYSZY->ZY_PEDIDO + '/' + QUERYSZY->ZY_ITEM+'.')
											_cNumEtqPA := Space(_nTamEtiq)
											oGetOp:Refresh()
											oGetOp:SetFocus()
											Return(.F.)
										EndIf
										QUERYSZY->( dbSkip() )
									End

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³Desconta caixas separadas								  ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									SC6->( dbSetOrder(1) )
									(cAliasSZY)->( dbGoTop() )
									//aCx2SepPv := {}
									aVetGeral := {}
									cZY_SEQ   := ""

									Do While (cAliasSZY)->(!Eof())

										If Alltrim((cAliasSZY)->ZY_PEDIDO) == Alltrim(cOpPedido) .AND. Alltrim((cAliasSZY)->ZY_ITEM) == Alltrim(cOPItemPV)
											cZY_SEQ := (cAliasSZY)->ZY_SEQ
										EndIf

										SC6->( dbSeek( xFilial() + (cAliasSZY)->ZY_PEDIDO + (cAliasSZY)->ZY_ITEM ) )
										nDisponiveis := U_Disp2Emb(Alltrim(SC6->C6_NUMOP+SC6->C6_ITEMOP),'2','')
										nSeparadas 	 := U_Separa2Emb((cAliasSZY)->ZY_PEDIDO, (cAliasSZY)->ZY_ITEM,'2')

										// aVetGeral 	1 - Numero do Pedido
										//					2 - Codigo do Item do Pedido
										//					3 - Quantidade do Item do Pedido
										//					4 - Quantidade de Volumes Calculado para Expedicao
										//					5 - Número de caixas separadas
										//					6 - Numero de caixas Disponíveis
										AADD(aVetGeral,{(cAliasSZY)->ZY_PEDIDO,(cAliasSZY)->ZY_ITEM, (cAliasSZY)->ZY_QUANT, (cAliasSZY)->ZY_VOLUMES, nSeparadas , nDisponiveis  })

										(cAliasSZY)->(dbSkip())
									EndDo

									nQtdPed := 0
									For _nxy := 1 to Len(aVetGeral)
										nQtdPed    += aVetGeral[_nxy,3] // ZY_QUANT
									Next _nxy

									nCx2SepPv  := 0
									For _nxy := 1 to Len(aVetGeral)
										nCx2SepPv  += aVetGeral[_nxy,5] // caixas separadas
									Next

									nDisponivel := 0
									For _nxy := 1 to Len(aVetGeral)
										nDisponivel += aVetGeral[_nxy,6] // caixinhas disponíveis
									Next

									nTotCx2PV := 0
									For _nxy := 1 to Len(aVetGeral)
										nInteiro   := Int(aVetGeral[_nxy,4])
										nResto     := aVetGeral[_nxy,4] - Int(aVetGeral[_nxy,4])
										nVolUso    := 0
										If nResto >= 0.0001 .And. nResto <= 0.0009
											nVolUso := nInteiro
										Else
											nVolUso := ( nInteiro + 1)
										EndIf

										nTemp      := If( Int(aVetGeral[_nxy,4]) <> aVetGeral[_nxy,4], nVolUso, aVetGeral[_nxy,4] ) // ZY_VOLUMES
										nTotCx2PV  += nTemp
									Next _nxy

									If Empty(cZY_SEQ)
										U_MsgColetor("Sequencia não localizada. Verifique se o item possui nível de embalagem na estrutura.")
										_cNumEtqPA := Space(_nTamEtiq)
										oGetOp:Refresh()
										oGetOp:SetFocus()
										(cAliasSZY)->(dbCloseArea())
										Return(.F.)
									EndIf

									(cAliasSZY)->(dbCloseArea())

								Else

								   /* Desligado Controle de Separação por Site do cliente por Michel Sander em 13.12.2018
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³																				³
									//³Separacao por site para cliente PADTEC								³
									//³																				³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									cAliasSZY := GetNextAlias()
									cWhere    := "%G1_XXEMBNI = '2' AND C6_NUM ='"+cOpPedido+"' AND "
									cWhere    += "C6_NOTA = '' AND C6_XXSITE = '"+cGrupoItem+"'%"
									//cWhere    += "C6_ENTRE3   = '"+Dtos(_cDtaFat)+"' AND C6_NOTA = '' AND C6_XXSITE = '"+cGrupoItem+"'%"

									BeginSQL Alias cAliasSZY
									SELECT C6_NUM ZY_PEDIDO, C6_ITEM ZY_ITEM, C6_ENTRE3 ZY_PRVFAT, C6_XXSITE, C6_NUMOP, C6_ITEMOP, G1_QUANT,
									SUM(C6_QTDVEN) ZY_QUANT, SUM(C6_QTDVEN*G1_QUANT) ZY_VOLUMES
									From %table:SC6% SC6 (NOLOCK)
									JOIN %table:SG1% SG1 (NOLOCK)
									ON G1_FILIAL = '' AND G1_COD = C6_PRODUTO
									JOIN %table:SB1% SB1 (NOLOCK)
									ON B1_FILIAL = '' AND B1_COD = C6_PRODUTO
									WHERE SG1.%NotDel%
									And SC6.%NotDel%
									And SB1.%NotDel%
									And %Exp:cWhere%
									GROUP BY C6_NUM, C6_ITEM, C6_ENTRE3, C6_XXSITE, C6_NUMOP, C6_ITEMOP, G1_QUANT
									ORDER BY C6_XXSITE
									EndSQL

									If (cAliasSZY)->(Eof())
										U_MsgColetor("Não existe programação de faturamento para esse pedido e site para a data atual.")
										_cNumEtqPA := Space(_nTamEtiq)
										oGetOp:Refresh()
										oGetOp:SetFocus()
										(cAliasSZY)->(dbCloseArea())
										Return(.F.)
									EndIf

									aVetGeral := {}

									Do While (cAliasSZY)->(!Eof())

										SC6->( dbSeek( xFilial() + (cAliasSZY)->ZY_PEDIDO + (cAliasSZY)->ZY_ITEM ) )
										nDisponiveis := U_Disp2Emb(Alltrim((cAliasSZY)->C6_NUMOP+(cAliasSZY)->C6_ITEMOP),'2','')
										nSeparadas 	 := U_Separa2Emb((cAliasSZY)->ZY_PEDIDO, (cAliasSZY)->ZY_ITEM,'2')

										// aVetGeral 	1 - Numero do Pedido
										//					2 - Codigo do Item do Pedido
										//					3 - Quantidade do Item do Pedido
										//					4 - Quantidade de Volumes Calculado para Expedicao
										//					5 - Número de caixas separadas
										//					6 - Numero de caixas Disponíveis
										AADD(aVetGeral,{(cAliasSZY)->ZY_PEDIDO,(cAliasSZY)->ZY_ITEM, (cAliasSZY)->ZY_QUANT, (cAliasSZY)->ZY_VOLUMES, nSeparadas , nDisponiveis  })

										(cAliasSZY)->(dbSkip())
									EndDo

									nQtdPed := 0
									For _nxy := 1 to Len(aVetGeral)
										nQtdPed    += aVetGeral[_nxy,3] // ZY_QUANT
									Next _nxy

									nCx2SepPv  := 0
									For _nxy := 1 to Len(aVetGeral)
										nCx2SepPv  += aVetGeral[_nxy,5] // caixas separadas
									Next

									nDisponivel := 0
									For _nxy := 1 to Len(aVetGeral)
										nDisponivel += aVetGeral[_nxy,6] // caixinhas disponíveis
									Next

									nTotCx2PV := 0
									For _nxy := 1 to Len(aVetGeral)
										nInteiro   := Int(aVetGeral[_nxy,4])
										nResto     := aVetGeral[_nxy,4] - Int(aVetGeral[_nxy,4])
										nVolUso    := 0
										If nResto >= 0.0001 .And. nResto <= 0.0009
											nVolUso := nInteiro
										Else
											nVolUso := ( nInteiro + 1)
										EndIf

										nTemp      := If( Int(aVetGeral[_nxy,4]) <> aVetGeral[_nxy,4], nVolUso, aVetGeral[_nxy,4] ) // ZY_VOLUMES
										nTotCx2PV  += nTemp
									Next _nxy

									(cAliasSZY)->(dbCloseArea())
                           */

								EndIf

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Verifica se embalagem calculada está disponível			³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Verifica se existe apontamento suficiente para montar embalagem nivel 3 ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Verifica embalagem que será usada para o produto		³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								nQtdProx := 0
								If cNivelFat == "3"	// Embalagem fora da estrutura
									If !lSelPorItem
										nUsoEmb := If ( (nTotCx2PV - nCx2SepPv) < 0, nDisponivel, If((nTotCx2PV - nCx2SepPv)==0, 1, (nTotCx2PV - nCx2SepPv)) )
										//aEmb := U_RetEmb2ZW(cGrupoItem, (nTotCx2PV - nCx2SepPv) , cNivelFat , SA1->A1_COD, SA1->A1_LOJA)
										aEmb := U_RetEmb2ZW(If(lPadTec,SB1->B1_GRUPO, cGrupoItem), nUsoEmb , cNivelFat , SA1->A1_COD, SA1->A1_LOJA)
										If Empty(aEmb[1,1])  // Código da embalagem
											U_MsgColetor("Grupo de produtos sem embalagens definida, ou o nivel de embalagem do produto esta vazio.")
											_cNumEtqPA := Space(_nTamEtiq)
											oGetOp:Refresh()
											oGetOp:SetFocus()
											Return(.F.)
										EndIf
										nQtdProx   := aEmb[1,2]
									Else
										For _nXY := 1 to Len(aVetGeral)
											//nAuxSepara := IIf((aVetGeral[_nXY,6] - aVetGeral[_nXY,5]) < 0, aVetGeral[_nXY,6], (aVetGeral[_nXY,6] - aVetGeral[_nXY,5]) )
											nAuxSepara := aVetGeral[_nXY,6]
											aEmb := U_RetEmb2ZW(SB1->B1_GRUPO, nAuxSepara , cNivelFat , SA1->A1_COD, SA1->A1_LOJA)
											If Empty(aEmb[1,1])  // Código da embalagem
												U_MsgColetor("Grupo de produtos sem embalagens definida, ou o nivel de embalagem do produto esta vazio.")
												_cNumEtqPA := Space(_nTamEtiq)
												oGetOp:Refresh()
												oGetOp:SetFocus()
												Return(.F.)
											Else
												nQtdProx   := aEmb[1,2]
											EndIf
										Next
									EndIf
								Else
									aEmb := {}
									AADD(aEmb, { XD1->XD1_EMBALA, XD1->XD1_QTDATU, Posicione("SB1",1,xFilial("SB1")+XD1->XD1_EMBALA,"B1_PESO") } )
								EndIf

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//Valida se é possível montar a próxima caixa                             ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If nDisponivel < nQtdProx
									U_MsgColetor("Não existem caixas suficientes deste pedido para montagem da próxima embalagem. "+Chr(13)+Chr(13)+"Disponíveis: "+Alltrim(Str(nDisponivel))+Chr(13)+" Embalagem: "+Alltrim(Str(nQtdProx)))
									_cNumEtqPA := Space(_nTamEtiq)
									oGetOp:Refresh()
									oGetOp:SetFocus()
									Return(.F.)
								Endif

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//Calcula a quantidade de volumes do pedido										  ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								AADD(aEmbPed,{ cGrupoItem, (nTotCx2PV - nCx2SepPv) })

								nTotalGrupo := 0
								nSaldoGrupo := nTotCx2PV
								While !Empty(nSaldoGrupo)
									If cNivelFat == "3"	// Embalagem fora da estrutura
										If lSelPorItem
											nTemp := U_RetEmb2ZW(SB1->B1_GRUPO, nSaldoGrupo , cNivelFat, SA1->A1_COD, SA1->A1_LOJA)[1][2]
										Else
											nTemp := U_RetEmb2ZW(If(lPadTec,SB1->B1_GRUPO, cGrupoItem) , nSaldoGrupo , cNivelFat, SA1->A1_COD, SA1->A1_LOJA)[1][2]
										EndIf
									Else
										nTemp := XD1->XD1_QTDATU
									EndIf
									nTotalGrupo++
									nSaldoGrupo -= nTemp
									If nSaldoGrupo < 0
										nSaldoGrupo := 0
									EndIf
								End

								nSaldoGrupo := U_Separa2Emb(SC2->C2_PEDIDO,'', cNivelFat ,'6')+1
								cVolumeAtu  := PADL(AllTrim(Str(nSaldoGrupo))+"/"+AllTrim(Str(nTotalGrupo)),18)
								oSldGrupo:Refresh()

							EndIf

						Else

							U_MsgColetor("Produto do Pedido de Venda: "+SC6->C6_NUM+" item: "+ SC6->C6_ITEM + " Produto: " + SC6->C6_PRODUTO + " diferente do produto da OP: "+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+" Produto: " + SC2->C2_PRODUTO)
							_cNumEtqPA := Space(_nTamEtiq)
							oGetOp:Refresh()
							oGetOp:SetFocus()
							Return(.F.)

						EndIf

					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Atualiza dados para o coletor									³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
					nSaldoEmb := aEmb[1,2]
					_cEmbalag := aEmb[1,1]
					nPesoEmb  := aEmb[1,3]
					_cNomCli  := "  "+SUBSTR(SA1->A1_NOME,1,15)
					_cNumPed  := SC2->C2_PEDIDO
					_cProdEmp := SB1->B1_COD
					_cDescric := SB1->B1_DESC
					SB1->(dbSeek(xFilial("SB1")+aEmb[1,1]))
					_cDescEmb := SUBSTR(SB1->B1_DESC,1,27)

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Coleta etiqueta bipada											³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					_nQtd     += 1
					nQtdCaixa += XD1->XD1_QTDATU
					AADD(aEmbBip,{_cNumEtqPA,SC2->C2_PEDIDO,SC2->C2_ITEMPV,SC2->C2_ITEMPV})
					AADD(aSeqBib,cZY_SEQ)

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Novo calculo de peso												³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nNovoPeso := 0
					//lNovoPeso := .T. // Habilita a pesagem para atualizar peso liquido do produto
					lNovoPeso := .F. // DESABILITADO NOVO PESO NA OPÇÃO WEB CONFORME SOLICITAÇÃO DO DENIS
					If lNovoPeso
						SB1->(dbSetOrder(1))
						SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
						If Empty(SB1->B1_XPESOOK)
							aAuxEmb := U_RetEmbala(SC2->C2_PRODUTO,XD1->XD1_NIVEMB)
							nXD1QPESO := XD1->XD1_QTDATU
							If Int(nXD1QPESO) == Int(aAuxEmb[2])
								lDigNovo := .T.
								While lDigNovo
									nXD1QPESO := XD1->XD1_QTDATU

									//nNovoPeso := fTelaPeso(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,nXD1QPESO)
									If nNovoPeso > 0 .And. nNovoPeso < 1000
										nDesconta := fDescEmb(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN, SC2->C2_PRODUTO, nNovoPeso, XD1->XD1_NIVEMB)
										nPesoFinal := ((nNovoPeso-nDesconta) / nXD1QPESO)
										SB1->(dbSetOrder(1))
										SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
										Reclock("SB1",.F.)
										SB1->B1_XPESOOK := "S"			    	   // Flag de peso atualizado
										SB1->B1_XXPESOK := "1"                 // Para assumir o calculo de peso em caso de último nível menor que 3 e não atualizar mais o peso bruto
										If XD1->XD1_ULTNIV == "S"
											SB1->B1_PESBRU  := nNovoPeso/nXD1QPESO // Atualiza peso bruto
										Else
											SB1->B1_PESO    := nPesoFinal		   // Atualiza peso liquido		                               //SB1->B1_XXPESOK = 1 => Não, SB1->B1_XXPESOK = 2 => Validação, SB1->B1_XXPESOK = 3 => Sim
										EndIf
										SB1->(MsUnlock())
										lDigNovo := .F.
									Else
										If !Empty(nNovoPeso)
											U_MsgColetor("Peso digitado invalido.")
										Else
											lDigNovo := .F.
										EndIf
									EndIf
								EndDo
							EndIf
						Else
							// Para habilitar a Repesagem numa próxima Fase após 90 dias
							//Michel Sander em 20.11.2018
							/*
							If SB1->B1_XPESOOK == "S"
								aAuxEmb := U_RetEmbala(SC2->C2_PRODUTO,XD1->XD1_NIVEMB)
								nXD1QPESO := XD1->XD1_QTDATU
								If Int(nXD1QPESO) == Int(aAuxEmb[2])
									lDigNovo := .T.
									While lDigNovo
										nXD1QPESO := XD1->XD1_QTDATU
										nNovoPeso := fTelaPeso(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,nXD1QPESO)
										If nNovoPeso > 0 .And. nNovoPeso < 1000
											nPesoFinal := (nNovoPeso / nXD1QPESO)
											SB1->(dbSetOrder(1))
											SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
											nDiscrepa := (SB1->B1_PESO * 5)/100     // Discrepância de 5% para mais ou para menos
											Reclock("SB1",.F.)
											If ( nPesoFinal > (SB1->B1_PESO+nDiscrepa) ) .Or. ( nPesoFinal < (SB1->B1_PESO-nDiscrepa) )
												SB1->B1_XPESOOK := "D"         // D = Divergencia de Peso
												SB1->B1_PESO    := nPesoFinal
											Else
												SB1->B1_PESO    := nPesoFinal
											EndIf
											SB1->(MsUnlock())
											lDigNovo := .F.
										Else
											If !Empty(nNovoPeso)
												U_MsgColetor("Peso digitado invalido.")
											Else
												lDigNovo := .F.
											EndIf
										EndIf
									EndDo
								EndIf
							EndIf
							*/
						EndIf

					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifica se cliente é TELEFONICA para coletar peso		³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lTelefonic
						If cOpTelef	<> SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN

							nPesoTel := 0
							cOpTelef	 := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
							cAliasTEL := GetNextAlias()
							cWhere    := "%XD1_OP='"+cOpTelef+"' AND XD1_NIVEMB = '"+XD1->XD1_NIVEMB+"' %"

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Verifica se peso do item atual já foi coletado			³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							BeginSQL Alias cAliasTEL
							SELECT XD1_PESOB From %table:XD1% XD1 (NOLOCK)
							WHERE XD1.%NotDel%
							And XD1_PESOB > 0
							And XD1_ULTNIV = 'N'
							And %Exp:cWhere%
							EndSQL

							If (cAliasTEL)->( EOF() )
								// 	If nNovoPeso == 0
								// 		nPesoTel := fTelaPeso(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,0)
								// 	Else
								// 		nPesoTel := nNovoPeso
								// 	EndIf
								// Else
								nPesoTel := (cAliasTEL)->XD1_PESOB
							EndIf

							(cAliasTEL)->(dbCloseArea())

							If !Empty(nPesoTel)
								Reclock("XD1",.F.)
								XD1->XD1_PESOB  := nPesoTel
								XD1->XD1_ULTNIV := "N"
								XD1->(MsUnlock())
							Else
								cOpTelef	 := ""
							EndIf
						Else
							Reclock("XD1",.F.)
							XD1->XD1_PESOB  := nPesoTel
							XD1->XD1_ULTNIV := "N"
							XD1->(MsUnlock())
						EndIf
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Imprime etiqueta nivel 3										³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If _nQtd == nSaldoEmb .Or. (cNivelFat <> "3")

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Abre digitação do peso											³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						oGetQtd:Refresh()
						nPesoBruto := U_CalPEmbW(SC2->C2_PEDIDO,SC2->C2_PRODUTO)

						If lPesoEmb

							If ImpNivel3()

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Atualiza separacao do pedido									³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

								If cNivelFat <> "3"   // NIvel 3 Volume Fora da Estrutura
									Reclock("XD1",.F.)
									XD1->XD1_VOLUME := ALLTRIM(cVolumeAtu)
									XD1->XD1_PVSEP  := SC2->C2_PEDIDO+SC2->C2_ITEMPV
									XD1->XD1_PESOB  := nPesoBruto
									XD1->XD1_ULTNIV := "S"
									XD1->(MsUnlock())
								Else
									If !Empty(XD1->XD1_PESOB)
										Reclock("XD1",.F.)
										XD1->XD1_ULTNIV := "S"
										XD1->(MsUnlock())
									EndIf
								EndIf

								//AtuSepEmb(SC2->C2_PEDIDO,SC2->C2_ITEMPV)
								AtuSepEmb()

								aEmbBip     := {}
								aSeqBib     := {}
								nSaldoEmb   := 0
								nSaldoGrupo += 1
								cVolumeAtu := PADL(AllTrim(Str(nSaldoGrupo))+"/"+Alltrim(Str(nTotalGrupo)),17)
								If nSaldoGrupo == nTotalGrupo
									cVolumeAtu  := SPACE(20)
									nTotalGrupo := 0
									aEmbPed     := {}
									aEmb        := {}
								EndIf
								nPesoBruto  := 0
								//nPesoTel    := 0
								nQtdCaixa   := 0
								_nQtdEmp    := 0
								_cEmbalag   := ""
								_cNomCli    := ""
								_cProdEmp   := SPACE(27)
								_cDescric   := SPACE(27)
								_cDescEmb   := SPACE(27)
								_cNumOp     := SPACE(11)
								cOPItemPV   := ""
								_nQtdEmp    := 0
								_cNumPed    := SPACE(06)
								cGrupoItem  := ""
								_cNumSite   := ""
								lTelefonic  := .T.

							EndIf

						EndIf

						_nQtd       := 0

					EndIf

					oTxtProdCod:Refresh()
					oTxtProdEmp:Refresh()
					oTxtQtdEmp:Refresh()
					oTxtEmbalag:Refresh()
					oTxtDescEmb:Refresh()
					oNumPed:Refresh()
					oSaldoEmb:Refresh()
					oNumOp:Refresh()
					oGetQtd:Refresh()
					cTipoSenf := ""
					_cNumEtqPA := Space(_nTamEtiq)
					oGetOp:SetFocus()

				Else
					U_MsgColetor("Número da OP não encontrada.")
					_cNumEtqPA := Space(_nTamEtiq)
					oGetOp:Refresh()
					oGetOp:SetFocus()
					_lRet:=.F.
				EndIf
			Else
				_cNumEtqPA := Space(_nTamEtiq)
				oGetOp:Refresh()
				oGetOp:SetFocus()
				_lRet:=.F.
				cTipoSenf := ""
			EndIf

		Else
			U_MsgColetor("Embalagem não encontrada. Verifique se etiqueta é manual.")
			_cNumEtqPA := Space(_nTamEtiq)
			oGetOp:Refresh()
			oGetOp:SetFocus()
			cTipoSenf := ""
			_lRet:=.F.
		EndIf

	Else

		U_MsgColetor("Tipo Revenda para SENF não permitido nessa rotina.")
		_cNumEtqPA := Space(_nTamEtiq)
		oGetOp:Refresh()
		oGetOp:SetFocus()
		cTipoSenf := ""
		_lRet:=.F.

	EndIf

Else

	U_MsgColetor("Etiqueta não encontrada.")
	_cNumEtqPA := Space(_nTamEtiq)
	oGetOp:Refresh()
	oGetOp:SetFocus()
	_lRet:=.F.

EndIf

If Empty(_cNumEtqPA)
	_lRet := .T.
Else
EndIf

oTelaOP:Refresh()

Return(_lRet)

Static Function VldData()

	If Empty(_cNumEtqPA)
		Return .T.
		oGetOp:SetFocus()
	Endif	


	// Tratamento para Permitir Faturamento em até 1 dia Util anterior - 30/10/17
	_nDias := 1

	if Dow(dDataBase) == 2  // Se for Segunda, retorna 3 dias
		_nDias := 3
	elseif Dow(dDataBase) == 1  // Se for Domingo, retorna 2 dias
		_nDias := 2
	else  // Qualquer outro dia, retorna 1 dia
		_nDias := 1
	endif


	If _cDtaFat < (dDataBase -_nDias)
		//	U_MsgColetor("Data de faturamento não deve ser menor que a data atual.")
		U_MsgColetor("Data de faturamento não deve ser menor que 1 dia útil Anterior.")
		Return(.f.)
	Else
		return(.t.)
	endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CalPesoEmb ºAutor  ³Michel Sander     º Data ³  09/29/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela para digitação do peso								         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CalPEmbw(cPedPeso,cProdPeso)

	LOCAL nOpcPeso := 0

	Define MsDialog oTelaPeso Title OemToAnsi("Peso do VOLUME") From 20*nWebPx,20*nWebPx To 180*nWebPx,200*nWebPx Pixel of oMainWnd PIXEL
	nLin := 025*nWebPx
	@ nLin,003 Say oTxtPeso     Var "Peso" Pixel Of oTelaPeso
	@ nLin-2,038 MsGet oGetPeso Var nPesoBruto Valid nPesoBruto > 0 When .T. Picture "@E 99,999,999.9" Size 60*nWebPx,10*nWebPx Pixel Of oTelaPeso
	oTxtPeso:oFont := TFont():New('Arial',,17*nWebPx,,.T.,,,,.T.,.F.)
	oGetPeso:oFont := TFont():New('Arial',,20*nWebPx,,.T.,,,,.T.,.F.)
	nLin+= 010*nWebPx
	@ nLin,025 Button oBotPeso PROMPT "Confirma" Size 35*nWebPx,15*nWebPx Action {|| nOpcPeso:=1,oTelaPeso:End()} Pixel Of oTelaPeso
	cCSSBtN1 := "QPushButton{"+cPush+;
		"QPushButton:pressed {"+cPressed+;
		"QPushButton:hover {"+cHover
	oBotPeso:setCSS(cCSSBtN1)

	Activate MsDialog oTelaPeso

	If nOpcPeso == 1
		If Len(aProdEmb) == 1
			If SB1->(dbSeek(xFilial("SB1")+cProdPeso))
				If SB1->B1_XXPESOK == "2" .Or. Empty(SB1->B1_XXPESOK)
					nPesTotal := ( (nPesoBruto - nPesoEmb) / nQtdCaixa )
					Reclock("SB1",.F.)
					SB1->B1_XXPESOK := "3"
					SB1->B1_PESBRU  := nPesTotal
					SB1->(MsUnlock())
				EndIf
				If SB1->B1_XXPESOK == "3"
					nPesTotal := ( (nPesoBruto - nPesoEmb) / nQtdCaixa )
					If (SB1->B1_PESBRU * 0.05) < Abs(SB1->B1_PESBRU - nPesTotal)
						Reclock("SB1",.F.)
						SB1->B1_XXPESOK := "1"
						SB1->B1_PESBRU  := nPesTotal
						SB1->(MsUnlock())
					Else
						Reclock("SB1",.F.)
						SB1->B1_PESBRU  := nPesTotal
						SB1->(MsUnlock())
					EndIf
				EndIf
			EndIf
		EndIf
		lPesoEmb := .T.
	Else
		lPesoEmb := .F.
	EndIf

Return ( nPesoBruto )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fTelaPeso ºAutor  ³Michel Sander     º Data ³  09/29/15    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela para digitação do peso 								        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

Static Function fTelaPeso(cOpTelef,nEmb)

	LOCAL nOpcPeso    := 0
	Local PesoRetorno := 0

	Define MsDialog oTelaTel Title OemToAnsi("Coleta de Peso") From 20*nWebPx,20*nWebPx To 260*nWebPx,200*nWebPx Pixel of oMainWnd PIXEL

	@ 003*nWebPx,003 To 098*nWebPx,088*nWebPx LABEL " Embalagem " Pixel Of oMainWnd PIXEL
	@ 020*nWebPx,012 Say oTxt1 Var "Informe o Peso da embalagem" Pixel Of oTelaTel
	@ 025*nWebPx,012 Say oTxt2 Var "  para peso de " + If(nEmb==0,"",Alltrim(Str(nEmb))) + " produtos" Pixel Of oTelaTel
	oTxt1:oFont := TFont():New('Arial',,12*nWebPx,,.T.,,,,.T.,.F.)
	oTxt2:oFont := TFont():New('Arial',,12*nWebPx,,.T.,,,,.T.,.F.)
	nLin := 040*nWebPx
	//00005191406x
	//@ nLin,005 To nLin+25,085 LABEL " Peso Líquido " Pixel Of oMainWnd PIXEL
	@  nLin , 005	GROUP oGroup TO nLin+25*nWebPx,085*nWebPx			LABEL " Peso Líquido " OF oMainWnd COLOR CLR_BLUE PIXEL

	nLin += 9*nWebPx
	@ nLin,010 MsGet oGetPeso Var PesoRetorno Valid PesoRetorno > 0 When .T. Picture "@E 999,999,999.99" Size 72*nWebPx,10*nWebPx Pixel Of oTelaTel
	oGroup:oFont := TFont():New('Arial',,17*nWebPx,,.T.,,,,.T.,.F.)
	oGetPeso:oFont := TFont():New('Arial',,20*nWebPx,,.T.,,,,.T.,.F.)
	nLin+= 050*nWebPx
	@ nLin,028 Button oBotPeso PROMPT "Confirma" Size 35*nWebPx,15*nWebPx Action {|| nOpcPeso:=1,oTelaTel:End()} Pixel Of oTelaTel
	cCSSBtN1 := "QPushButton{"+cPush+;
	"QPushButton:pressed {"+cPressed+;
	"QPushButton:hover {"+cHover
	oBotPeso:setCSS(cCSSBtN1)
	Activate MsDialog oTelaTel

Return ( PesoRetorno )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fDescEmb ºAutor  ³Michel Sander       º Data ³  04.12.18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica a embalagem na estrutura para desconto do peso    º±±
±±º          ³ 														                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fDescEmb( cVerPesOP, cVerPesPro, nVerPesBru, cVerNivEmb )

	Local nVerEstru  := 0
	Local cVerAreaB1 := SB1->(GetArea())

	SG1->( dbSetOrder(1) )
	SG1->( dbSeek(xFilial() + cVerPesPro ) )
	While SG1->(!Eof()) .And. SG1->G1_FILIAL+SG1->G1_COD == xFilial("SG1") + cVerPesPro
		If SG1->G1_XPESEMB == "S"
			lEntrou  := .T.
			cUsoComp := ""
			SD4->(dbSetOrder(2)) // D4_FILIAL + D4_OP + D4_COD
			If !SD4->( dbSeek( xFilial() + cVerPesOP + SG1->G1_COMP) )
				cUsoComp := SG1->G1_COMP
			Else
				cUsoComp := SD4->D4_COD
			EndIf
			SB1->(dbSetOrder(1))
			If SB1->(dbSeek(xFilial()+cUsoComp))
				If SB1->B1_PESO == 0
					Reclock("SB1",.F.)
					SB1->B1_PESO := (nVerPesBru * 10) / 100
					SB1->(MsUnlock())
					nVerEstru := 0
					Exit
				EndIf
				nVerEstru := SB1->B1_PESO
			EndIf
			SD4->(dbSetOrder(1))
			Exit
		EndIf
		SG1->(dbSkip())
	End

	If nVerEstru == 0
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial()+Alltrim(cVerPesPro)))
		cTxtMsg  := "Embalagem nível " + cVerNivEmb + " do produto " + Alltrim(cVerPesPro) + " não possui peso líquido."
		cAssunto := "Peso da Embalagem"
		cTexto   := StrTran(cTxtMsg,Chr(13),"<br>")
		cPara    := 'denis.vieira@rdt.com.br;tatiane.alves@rosenbergerdomex.com.br;monique.garcia@rosenbergerdomex.com.br'
		cCC      := 'natalia.silva@rosenbergerdomex.com.br;keila.gamt@rosenbergerdomex.com.br;leonardo.andrade@rosenbergerdomex.com.br;gabriel.cenato@rosenbergerdomex.com.br' //chamado monique 015475
		cArquivo := Nil
		U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
		nVerEstru := (nVerPesBru * 10) / 100
	EndIf

	SB1->(RestArea(cVerAreaB1))

Return ( nVerEstru )



//-----------------------------------------------------------

Static Function ValidQtd()

	Local _Retorno      := .T.

Return _Retorno

//-----------------------------------------------------------

Static Function ImpNivel3()

	LOCAL lRetEtq := .T.

	If cNivelFat == "3" .Or. cTipoSenf == "PR" 	// Embalagem fora da estrutura

		cNumSerie := ""
		// Inserido por Michel Sander em 03.02.17 para tratamento do cliente PADTEC separação por item como HUAWEI, mas impressão de etiqueta não utilizada padrão HUAWEI
		If "PADTEC" $ AllTrim(_cNomCli)
			lSelPorItem := .F.
		EndIf
		If "ALCATEL" $ AllTrim(_cNomCli)
			lSelPorItem := .F.
		EndIf
		If "TELEFONICA" $ AllTrim(_cNomCli)
			lSelPorItem := .F.
		EndIf
		If "ERICSSON" $ AllTrim(_cNomCli)
			lSelPorItem := .F.
		EndIf
		If "OI S" $ AllTrim(_cNomCli)
			lSelPorItem := .F.
		EndIf
		If "OI MO" $ AllTrim(_cNomCli)
			lSelPorItem := .F.
		EndIf
		If "TELEMAR" $ AllTrim(_cNomCli)
			lSelPorItem := .F.
		EndIf
		If "CLARO" $ AllTrim(_cNomCli)
			lSelPorItem := .F.
		EndIf
		If  ("BRASIL TELECOM COMUNICACAO MUL" $ Upper(SA1->A1_NOME))
			lSelPorItem := .F.
		EndIf

		If  !lEhClaro
			If lSelPorItem
				cProxNiv   := cNivelFat
				__mv_par02 := XD1->XD1_OP
				If Empty(Alltrim(__mv_par02)) .And. !Empty(Alltrim(_cNumOp))
					__mv_par02 :=	_cNumOp
				EndIf
				__mv_par03 := Nil
				__mv_par04 := nQtdCaixa
				__mv_par05 := 1
				__mv_par06 := "01"
				lColetor   := .T.

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³LAYOUT 01 - HUAWEI UNIFICADA												   	³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			/*
			lRotValid :=  U_DOMETQ04(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aEmbBip,.F.,nPesoBruto,lColetor) 			// Validações de Layout 01
				If !lRotValid
			U_MsgColetor("A etiqueta não será impressa. Verifique os problemas com o  layout da etiqueta e repita a operação.")
			Return ( .F. )
				Else
			cRotina   := "U_DOMETQ04(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aEmbBip,.T.,nPesoBruto,lColetor)"		// Impressão de Etiqueta Layout 01
				EndIf
			*/

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³LAYOUT 99 - HUAWEI LEIAUTE NOVO   								   	³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				//alterado para layout 87
			/*
			lRotValid := U_DOMETQ99(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aEmbBip,.F.,nPesoBruto,lColetor,cNumSerie,NIL)
				If !lRotValid
			U_MsgColetor("A etiqueta não será impressa. Verifique os problemas com o  layout da etiqueta e repita a operação.")
			Return ( .F. )
				Else
			cRotina := "U_DOMETQ99(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aEmbBip,.T.,nPesoBruto,lColetor,cNumSerie,NIL)"
				EndIf
			*/ 
				If lNewL87
					lRotValid := U_DOMET87B(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aEmbBip,.F.,nPesoBruto,lColetor,cNumSerie,NIL)  //HUAWEI ZEBRADESIGN
				EndIf
				If !lRotValid
					U_MsgColetor("A etiqueta não será impressa. Verifique os problemas com o  layout da etiqueta e repita a operação.")
					Return ( .F. )
				Else
					cRotina := "U_DOMET87B(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aEmbBip,.T.,nPesoBruto,lColetor,cNumSerie,NIL)" //HUAWEI ZEBRADEGIN
				EndIf


				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Executa rotina de impressao									³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lRetEtq := &(cRotina)		// suspensao temporaria da impressao até que se defina o layout nivel 3 em 29.10.2015
				lRetEtq := .T.

			Else

				If cTipoSenf == "PR"
					cProxNiv := "2"
				Else
					cProxNiv := cNivelFat
				EndIf

				__mv_par02 := XD1->XD1_OP
				If Empty(Alltrim(__mv_par02)) .And. !Empty(Alltrim(_cNumOp))
					__mv_par02 :=	_cNumOp
				EndIf
				__mv_par03 := Nil
				__mv_par04 := nQtdCaixa
				__mv_par05 := 1
				__mv_par06 := "90"
				cVolumeAtu := Alltrim(cVolumeAtu)
				lColetor   := .T.

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³LAYOUT 90 - Etiqueta Nivel 3												   	³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				// Inserido por Michel Sander em 03.02.17 para tratamento do cliente PADTEC separação por item como HUAWEI
				If "PADTEC" $ AllTrim(_cNomCli)
					lRotValid :=  U_DOMETQ96(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aEmbBip,.F.,nPesoBruto,cVolumeAtu,lColetor,cNumSerie,Nil,cOPItemPV) 			// Validações de Layout 90 - Nivel 3
				Else
					lRotValid :=  U_DOMETQ90(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aEmbBip,.F.,nPesoBruto,cVolumeAtu,lColetor,cNumSerie,Nil,cOPItemPV) 			// Validações de Layout 90 - Nivel 3
				EndIf

				If !lRotValid
					U_MsgColetor("A etiqueta não será impressa. Verifique os problemas com o  layout da etiqueta e repita a operação.")
					Return ( .F. )
				Else
					__mv_par02 := XD1->XD1_OP
					If Empty(Alltrim(__mv_par02)) .And. !Empty(Alltrim(_cNumOp))
						__mv_par02 :=	_cNumOp
					EndIf
					__mv_par03 := Nil
					__mv_par04 := nQtdCaixa
					__mv_par05 := 1
					__mv_par06 := "90"
					If "PADTEC" $ AllTrim(_cNomCli)
						cRotina   := "U_DOMETQ96(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aEmbBip,.T.,nPesoBruto,cVolumeAtu,lColetor,cNumSerie,Nil,cOPItemPV)"		// Impressão de Etiqueta Layout 90 - Nivel 3
					Else
						cRotina   := "U_DOMETQ90(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aEmbBip,.T.,nPesoBruto,cVolumeAtu,lColetor,cNumSerie,Nil,cOPItemPV)"		// Impressão de Etiqueta Layout 90 - Nivel 3
					EndIf
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Executa rotina de impressao									³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lRetEtq := &(cRotina)		// suspensao temporaria da impressao até que se defina o layout nivel 3 em 29.10.2015
				lRetEtq := .T.

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Reinicia variáveis da tela										³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			EndIf
		ElseIf lEhClaro
				cProxNiv   := cNivelFat
				__mv_par02 := XD1->XD1_OP
				If Empty(Alltrim(__mv_par02)) .And. !Empty(Alltrim(_cNumOp))
					__mv_par02 :=	_cNumOp
				EndIf
				__mv_par03 := Nil
				__mv_par04 := nQtdCaixa
				__mv_par05 := 1
				
				/*__mv_par02 := AllTrim(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
				__mv_par03 := Nil
				__mv_par04 := Len(aEmbBip)
				__mv_par05 := nQtdCaixa*/
				cVolumeAtu := Alltrim(cVolumeAtu)
				lColetor   := .T.

		
			lRotValid :=  U_DOMET111(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aEmbBip,.F.,nPesoBruto,cVolumeAtu,lColetor,cNumSerie)
			If !lRotValid
				U_MsgColetor("A etiqueta não será impressa. Verifique os problemas com o  layout da etiqueta e repita a operação.")
				Return ( .F. )
			Else
				cRotina   := "U_DOMET111(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aEmbBip,.T.,nPesoBruto,cVolumeAtu,lColetor,cNumSerie)"
				lRetEtq := &(cRotina)		// suspensao temporaria da impressao até que se defina o layout nivel 3 em 29.10.2015
				lRetEtq := .T.

			EndIf
		Endif
	EndIf


Return ( lRetEtq )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AtuSepEmb ºAutor  ³Michel Sander     º Data ³  09/29/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualiza a separação para o pedido de venda  		         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AtuSepEmb()
	Local nQ
	For nQ := 1 to Len(aEmbBip)

		If XD1->(dbSeek(xFilial("XD1")+aEmbBip[nQ,1]))

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza Separação												³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Reclock("XD1",.F.)
			XD1->XD1_PVSEP  := aEmbBip[nQ,2]+aEmbBip[nQ,3]
			XD1->XD1_ZYSEQ  := aSeqBib[nQ]
			XD1->(MsUnlock())

		EndIf

	Next

Return
