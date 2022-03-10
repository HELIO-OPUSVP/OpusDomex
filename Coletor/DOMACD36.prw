#include "TbiConn.ch"
#include "TbiCode.ch"
#include "Rwmake.ch"
#include "Topconn.ch"
#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDOMACD36  บAutor  ณMichel Sander       บ Data ณ  04.06.19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Etiqueta OI S/A para faturamento (EXPEDICAO) 	   		  บฑฑ
ฑฑบ          ณ 														                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DOMACD36(nOpcao)

	Private oTxtOP,__oGetOP,__oTxtEtiq,oGetEtiq,oTxtProd,oGetProd,oTxtQtd,oGetQtd,oMark,oTxtQtdEmp,oMainEti,oEtiqueta
	Private oTxtProdCod,oTxtProdEmp,oNumOp
	Private _nTamEtiq      := 21
	Private _cNumEtqPA     := Space(_nTamEtiq)
	Private _cProduto      := CriaVar("B1_COD",.F.)
	Private _nQtd          := CriaVar("XD1_QTDATU",.F.)
	Private _cLoteEti      := CriaVar("BF_LOTECTL",.F.)
	Private _aCols         := {}
	Private _cCodInv
	Private cGetEnd        := Space(2+15+1)
	Private _cCliEmp	     := Space(06)
	Private _cNomCli       := Space(15)
	Private _cDescric	     := Space(27)
	Private _cDescEmb      := Space(27)
	Private _cEmbalag	     := Space(15)
	Private _cNumOp        := SPACE(11)
	Private _cNumPed       := SPACE(06)
	Private _nQtdEmp       := 0
	Private _nQtd          := 0
	Private _aDados        := {}
	Private _aEnd          := {}
	Private _nCont
	Private _cDtaFat       := dDataBase
	Private nQtdCaixa      := 0
	Private cLocProcDom    := GetMV("MV_XXLOCPR")
	Private __oTelaOP
	Private oTxtQtdEmp
	Private aOi     := {}
	Private lOi     := .F.
	Private nOpc:= nOpcao

	dDataBase := Date()

	If cUsuario == 'HELIO'
		_cNumEtqPA := Space(_nTamEtiq)
		//_cNumEtqPA := '00001925766x   '
		_cDtaFat   := CtoD("13/10/16")
	EndIf

	Define MsDialog __oTelaOP Title OemToAnsi("Etiqueta OI S/A " + DtoC(dDataBase) ) From 0,0 To 293,233 Pixel of oMainWnd PIXEL

	nLin := 005
	@ nLin,001 Say __oTxtEtiq    Var "Num.Etiqueta" Pixel Of __oTelaOP
	@ nLin-2,045 MsGet __oGetOP  Var _cNumEtqPA Valid VldEtiq() Size 70,10 Pixel Of __oTelaOP
	__oTxtEtiq:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
	__oGetOP:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

	@ 018,001 To 132,115 Pixel Of oMainWnd PIXEL

	nLin += 015
	@ nLin,005 Say oTxtProdEmp  Var "Cliente: "        Pixel Of __oTelaOP
	@ nLin,035 Say oTxtProdCod  Var _cCliEmp           Pixel Of __oTelaOP
	oTxtProdCod:oFont  := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
	nLin += 10
	@ nLin,005 Say oTxtDes      Var "Descri็ใo: "      Pixel Of __oTelaOP
	@ nLin,035 say oTxtDescPro  Var _cDescric      Size 075,15 Pixel Of __oTelaOP
	oTxtDescPro:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
	nLin+= 30
	@ nLin,005 Say oTxtPed Var "Pedido: " Pixel Of __oTelaOP
	@ nLin,023 Say oNumPed Var _cNumPed+'-'+_cNomCli Size 120,10 Pixel Of __oTelaOP
	oNumPed:oFont:= TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
	nLin+= 75

	@ nLin,077 Button oEtiqueta PROMPT "Sair" Size 35,10 Action Close(__oTelaOP) Pixel Of __oTelaOP

	Activate MsDialog __oTelaOP

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ            '
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VldEtq   บAutor  ณHelio Ferreira      บ Data ณ  15/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida็ใo da etiqueta para faturamento						     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldEtiq()

	Local _lRet := .T.
	_cCliEmp    := ""
	_cDescric   := ""
	_cEmbalag   := ""
	_nQtdEmp    := 0
	_aDados     := {}

	If Empty(_cNumEtqPA)
		Return ( .T. )
	EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPrepara n๚mero da etiqueta bipada							ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Len(AllTrim(_cNumEtqPA))==12 //EAN 13 s/ dํgito verificador.
		_cNumEtqPA := "0"+_cNumEtqPA
		_cNumEtqPA := Subs(_cNumEtqPA,1,12)
	EndIf

	SC2->( dbSetOrder(1) )
	SB1->( dbSetOrder(1) )
	SBF->( dbSetOrder(2) )
	XD1->( dbSetOrder(1) )

	If XD1->( dbSeek(xFilial("XD1") + _cNumEtqPA ) )

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVerifica volume													ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cNumNF := ""
		If XD1->XD1_ULTNIV <> "S"
			If U_uMsgYesNo("Embalagem nใo ้ ultimo nํvel. Continuar?")
				cItemPV := Alltrim(Subs(XD1->XD1_PVSEP,7,2))
				
				XD2->( dbSetOrder(2) )
				If XD2->( dbSeek( xFilial() + _cNumEtqPA ) )
					cEtqPai := XD2->XD2_XXPECA
					aAreaXD1 := XD1->( GetArea() )
					XD1->( dbSetOrder(1) )
					If XD1->( dbSeek( xFilial() + cEtqPai ) )
						cNumNF := XD1->XD1_ZYNOTA
					EndIf
					RestArea(aAreaXD1)
				Else
					U_MsgColetor("Embalagem superior a esta nใo encontrada.")
					_cNumEtqPA := Space(_nTamEtiq)
					__oGetOP:Refresh()
					__oGetOP:SetFocus()
					Return(.F.)
				EndIf
			Else
				U_MsgColetor("Esse volume nใo ้ embalagem final.")
				_cNumEtqPA := Space(_nTamEtiq)
				__oGetOP:Refresh()
				__oGetOP:SetFocus()
				Return(.F.)
			EndIf
		Else
			cItemPV := ""
			If Len(Alltrim(XD1->XD1_PVSEP)) == 8
				cItemPV := Alltrim(Subs(XD1->XD1_PVSEP,7,2))
			Else
				aAreaXD1 := XD1->( GetArea() )
				XD2->( dbSetOrder(1) )
				If XD2->( dbSeek( xFilial() + _cNumEtqPA ) )
					While !XD2->( EOF() ) .and. Alltrim(XD2->XD2_XXPECA) == Alltrim(_cNumEtqPA)
						If XD1->(dbSeek(xFilial() + XD2->XD2_PCFILH))
							If Empty(cItemPV)
								cItemPV := Alltrim(Subs(XD1->XD1_PVSEP,7,2))
							EndIf
						EndIf
						XD2->(dbSkip())
					End
				EndIf				
				RestArea(aAreaXD1)
				If Empty(Alltrim(cItemPV))
					//Buscar o item do Pedido na OP
					cItemPV := Posicione("SC2",1,xFilial("SC2") + Alltrim(XD1_LOTECT) + "001","C2_ITEMPV")
				EndIf				
			EndIf
			cNumNF := XD1->XD1_ZYNOTA
		EndIf

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVerifica faturamento												ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If Empty(cNumNF)
			U_MsgColetor("Esse volume ainda nใo foi faturado.")
			_cNumEtqPA := Space(_nTamEtiq)
			__oGetOP:Refresh()
			__oGetOP:SetFocus()
			Return(.F.)
		EndIf

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVerifica ITEM de pedido faturado												ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If Empty(cItemPV)
			U_MsgColetor("Item de Pedido de Venda nใo encontrado para emissใo da Etiqueta.")
			_cNumEtqPA := Space(_nTamEtiq)
			__oGetOP:Refresh()
			__oGetOP:SetFocus()
			Return(.F.)
		EndIf

		SB1->(dbSeek(xFilial("SB1")+XD1->XD1_COD))

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVerifica separa็ใo												ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		XD2->(dbSetOrder(1))
		If XD2->(dbSeek(xFilial("XD2")+XD1->XD1_XXPECA))

			SZY->(dbSetOrder(1))
			If SZY->(dbSeek(xFilial("SZY")+SUBSTRING(XD1->XD1_PVSEP,1,6)))

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณAtualiza dados para o coletor									ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				SC5->(dbSeek(xFilial("SC5")+SZY->ZY_PEDIDO))
				SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE))

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณVerifica se o Cliente ้ OI S/A								ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				lOi := .F.
				If ("OI S" $ Upper(SA1->A1_NOME)) .Or. ("OI MO" $ Upper(SA1->A1_NOME)) .Or. ("TELEMAR" $ Upper(SA1->A1_NOME)) .Or. ("BRASIL TELECOM COMUNICACAO MUL" $ Upper(SA1->A1_NOME))
					lOi := .T.
				Else
					U_MsgColetor("Esse volume nใo pertence ao cliente OI S/A.")
					_cNumEtqPA := Space(_nTamEtiq)
					__oGetOP:Refresh()
					__oGetOP:SetFocus()
					Return(.F.)
				EndIf

				_cNumPed  := SC5->C5_NUM + cItemPV
				_cCliEmp  := SC5->C5_CLIENTE
				_cDescric := SA1->A1_NOME
				cPedTel   := SC5->C5_ESP1
				_cOPImp   := AllTrim(XD1->XD1_LOTECT)+"001"
				__oTelaOP:Refresh()

				If U_uMsgYesNo("Imprime Etiqueta?")
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณImprime Etiqueta OI S/A											ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					aDesmonta := DesmontaVol(_cNumEtqPA)
					For nQ := 1 to Len( aDesmonta )
						// 01 - Numero da OP
						// 02 - Codigo do Produto
						// 03 - Pedido de Compra do Cliente
						// 04 - Quantidade da Etiqueta
						// 05 - Data de Produ็ใo
						// 06 - Muda impressora de etiqueta para EXPEDIวรO
						// 07 - N๚mero da Nota Fiscal
						// 08 - Peso do Item
						//DOMET105(cEtqOp , cEtqProd       , cEtqPed , nEtqQtd        , dDataFab , lControl, cNfDanfe                                       , nPesoDanfe     )
						if U_VALIDACAO("RODA") .or. .T.
							if nOpc == 1
								U_DOMET105(_cOPImp, aDesmonta[nQ,1], _cNumPed, aDesmonta[nQ,3] , dDataBase, .T.     , IIF(!Empty(XD1->XD1_ZYNOTA),XD1->XD1_ZYNOTA,""), XD1->XD1_PESOB )
							ElseIf nOpc == 2
								U_DOMETQ50(_cOPImp, aDesmonta[nQ,1], _cNumPed, aDesmonta[nQ,3] , dDataBase, .T.     , IIF(!Empty(XD1->XD1_ZYNOTA),XD1->XD1_ZYNOTA,""), XD1->XD1_PESOB )
							Endif
						else
							U_DOMET105(_cOPImp, aDesmonta[nQ,1], _cNumPed, aDesmonta[nQ,3] , dDataBase, .T.     , IIF(!Empty(XD1->XD1_ZYNOTA),XD1->XD1_ZYNOTA,""), XD1->XD1_PESOB )
						Endif
					Next nQ
				EndIf

			Else
				U_MsgColetor("Pedido nใo encontrado")
				_cNumEtqPA := Space(_nTamEtiq)
				__oGetOP:Refresh()
				__oGetOP:SetFocus()
				Return(.F.)
			EndIf
		Else
			U_MsgColetor("Pr๓ximo nํvel de Embalagem nใo encontrada.")
			_cNumEtqPA := Space(_nTamEtiq)
			__oGetOP:Refresh()
			__oGetOP:SetFocus()
			cTipoSenf := ""
			_lRet:=.F.
		EndIf

	Else

		U_MsgColetor("Embalagem final nใo encontrada.")
		_cNumEtqPA := Space(_nTamEtiq)
		__oGetOP:Refresh()
		__oGetOP:SetFocus()
		_lRet:=.F.

	EndIf

	_cNumEtqPA := Space(_nTamEtiq)
	_lRet      := .T.
	cTipoSenf  := ""
	__oGetOP:Refresh()
	__oGetOP:SetFocus()

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DesmontaVolบAutorณMichel Sander       บ Data ณ  09/15/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Desmonta os volumes para verificar as quantidades          บฑฑ
ฑฑบ          ณ contra o pedido de venda que serแ faturado                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function DesmontaVol(cCodVolume)

	LOCAL cAliasXD1  := GetNextAlias()
	LOCAL cPeca      := "%XD1_XXPECA='"+cCodVolume+"'%"
	LOCAl aOi := {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica as caixas do volume bipado VOLUME 3				ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	BEGINSQL Alias cAliasXD1
 
	SELECT XD1_COD, XD1_PVSEP, XD1_QTDATU, XD1_PESOB 
			 FROM %table:XD1% XD1 (NOLOCK) 
			 WHERE XD1.%NotDel% AND 
			 		 XD1_ULTNIV = 'S' AND 
			 		 XD1_OCORRE <> '5' AND
					 %Exp:cPeca% 
	ENDSQL

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAgrupa os Itens													ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Do While (cAliasXD1)->(!EOF())
		// 01 - Codigo do Produto
		// 02 - Pedido + Item
		// 03 - Quantidade
		// 04 - Peso do Item
		AADD(aOi,{ (cAliasXD1)->XD1_COD, (cAliasXD1)->XD1_PVSEP, (cAliasXD1)->XD1_QTDATU, (cAliasXD1)->XD1_PESOB })
		(cAliasXD1)->(dbSkip())
	EndDo
	(cAliasXD1)->(dbCloseArea())

Return ( aOi )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ            '
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VerifChv บAutor  ณMichel Sander       บ Data ณ  15/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica autorizacao da DANFE pelo Sefaz     			     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VerifChv(cCodEnt,cSerDanfe,cNumDanfe)

	LOCAL nVerif := 0
	LOCAL lVerif := .T.
	LOCAL	cWhere    := "%F2_SERIE='"+cSerDanfe+"' AND F2_DOC='"+cNumDanfe+"' AND F2_CHVNFE <> '' AND D_E_L_E_T_=''%"
	LOCAL	cAliasSPD := GetNextAlias()
	LOCAL lFatura   := .T.

	Do While nVerif == 0

		BeginSQL Alias cAliasSPD
		SELECT * FROM %table:SF2% (NOLOCK) WHERE %Exp:cWhere%
		EndSQL

		If (cAliasSPD)->(Eof())
			If U_uMsgYesNo("DANFE aguardando autoriza็ใo do SEFAZ. Deseja aguardar?")
				SLEEP(20000)
				(cAliasSPD)->(dbCloseArea())
				Loop
			Else
				(cAliasSPD)->(dbCloseArea())
				nVerif := 1
				lVerif := .F.
			EndIf
		Else
			(cAliasSPD)->(dbCloseArea())
			nVerif := 1
			lVerif := .T.
		Endif

	EndDo

Return ( lVerif )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ            '
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VldData  บAutor  ณHelio Ferreira      บ Data ณ  15/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida็ใo da data de faturamento								     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldData()

	If _cDtaFat < dDataBase
		U_MsgColetor("Data de faturamento nใo deve ser menor que a data atual.")
		Return(.f.)
	Else
		return(.t.)
	endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ            '
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAlertC    บAutor  ณHelio Ferreira      บ Data ณ  15/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Mensagem de alerta para o coletor de dados				     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

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
