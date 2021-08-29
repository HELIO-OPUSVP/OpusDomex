#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DOMACD29  ºAutor  ³Michel Sander       º Data ³  23.02.17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Desmontagem de Embalagens								 			  º±±
±±º          ³ 														                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMACW29()

	Private oTxtOP,__oGetOP,__oTxtEtiq,oGetEtiq,oTxtProd,oGetProd,oTxtQtd,oGetQtd,oMark,oMainEti,oEtiqueta,oDesmonta
	Private _nTamEtiq      := 21
	Private _cNumEtqPA     := Space(_nTamEtiq)
	Private _cProduto      := CriaVar("B1_COD",.F.)
	Private _cLoteEti      := CriaVar("BF_LOTECTL",.F.)
	Private cEtqDesmonta   := ""
	Private _aCols         := {}
	Private _lAuto	        := .T.
	Private _lIndividual   := .T.
	Private lFaturado      := .F.
	Private lPrevisaoFat   := .T.
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
	Private cTipoSenf      := ""
	Private nSaldoEmb      := 0
	Private cVolumeAtu     := SPACE(17)
	Private nSaldoGrupo    := 0
	Private nTotalGrupo    := 0
	Private nRestaGrupo    := 0
	Private nPesoEmb       := 0
	Private nPesoBruto     := 0
	Private cLocProcDom    := GetMV("MV_XXLOCPR")
	Private aEmbBip        := {}
	Private aSeqBib        := {}
	Private aEmbPed        := {}
	Private aEmb           := {}
	Private aProdEmb       := {}
	Private lPesoEmb       := .F.
	Private oTelaPeso
	Private __oTelaOP
	Private oTxtQtdEmp
	Private cGrupoesp      := "'TRUN'"  
	Private cZY_SEQ        := ""
	Private cNivelFat      := ""
	Private lHuawei        := .F.
	Private nCx2SepPv      := 0
	Private nTotCx2PV 	  := 0
	Private nSalVol   	  := 0
	Private nSalTot        := 0
	Private lBeginSQL      := .T.
	Private nWebPx:= 1.5
	Private cPush:= "background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 gray);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
		"background-repeat:no-repeat ;border-radius: 6px;}"
	Private cPressed:= "background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 blue);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
		"background-repeat:no-repeat ;border-radius: 6px;}"
	Private cHover:="background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 Black);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
		"background-repeat:no-repeat ;border-radius: 6px;}"

	dDataBase := Date()

	If cUsuario == 'HELIO'
		_cNumEtqPA := Space(_nTamEtiq)
		_cDtaFat   := CtoD("16/02/17")
	EndIf

	Define MsDialog __oTelaOP Title OemToAnsi("Desmontagem " + DtoC(dDataBase) ) From 0,0 To 450,302 Pixel of oMainWnd PIXEL

	nLin := 005
	@ nLin,001 Say __oTxtEtiq    Var "Num.Etiqueta" Pixel Of __oTelaOP
	@ nLin-2,045 MsGet __oGetOP  Var _cNumEtqPA Valid VldEtiq() Size 70*nWebPx,10*nWebPx Pixel Of __oTelaOP
	__oTxtEtiq:oFont := TFont():New('Arial',,17*nWebPx,,.T.,,,,.T.,.F.)
	__oGetOP:oFont := TFont():New('Arial',,20*nWebPx,,.T.,,,,.T.,.F.)

	@ 018*nWebPx,001 To 065*nWebPx,115*nWebPx Pixel Of oMainWnd PIXEL

	nLin += 020*nWebPx
	@ nLin,005 Say __oTxtOP Var "Num.OP: " Pixel Of __oTelaOP
	@ nLin,027 Say oNumOP Var _cNumOP Size 120*nWebPx,10*nWebPx Pixel Of __oTelaOP
	@ nLin,077 Say oTxtQtdEmp   Var "Qtd: "+ TransForm(_nQtdEmp,"@E 999,999.99") Pixel Of __oTelaOP
	oNumOp:oFont:= TFont():New('Arial',,15*nWebPx,,.T.,,,,.T.,.F.)
	oTxtQtdEmp:oFont  := TFont():New('Arial',,14*nWebPx,,.T.,,,,.T.,.F.)
	nLin += 10*nWebPx
	@ nLin,005 Say oTxtProdEmp  Var "Cliente: "        Pixel Of __oTelaOP
	@ nLin,035 Say oTxtProdCod  Var _cCliEmp           Pixel Of __oTelaOP
	oTxtProdCod:oFont  := TFont():New('Arial',,14*nWebPx,,.T.,,,,.T.,.F.)
	nLin += 10*nWebPx
	@ nLin,005 Say oTxtDes      Var "Descrição: "      Pixel Of __oTelaOP
	@ nLin,035 say oTxtDescPro  Var _cDescric      Size 095*nWebPx,15*nWebPx Pixel Of __oTelaOP
	oTxtDescPro:oFont := TFont():New('Arial',,14*nWebPx,,.T.,,,,.T.,.F.)
	nLin+= 30*nWebPx
	@ nLin,005 Say oTxtPed Var "Pedido: " Pixel Of __oTelaOP
	@ nLin-3,028 Say oNumPed Var _cNumPed+'-'+_cNomCli Size 120*nWebPx,10*nWebPx Pixel Of __oTelaOP
	oNumPed:oFont:= TFont():New('Arial',,15*nWebPx,,.T.,,,,.T.,.F.)

	nLin+= 05*nWebPx
	@ 070*nWebPx,001 To 145*nWebPx,115*nWebPx Pixel Of oMainWnd PIXEL
	nLin+= 10*nWebPx

	@ nLin,005 SAY oTxtDescEmb Var _cDescEmb 		 Pixel Of __oTelaOP
	oTxtDescEmb:oFont := TFont():New('Arial',,14*nWebPx,,.T.,,,,.T.,.F.)

	nLin += 10*nWebPx
	@ nLin,005   Say oTxtSldGrupo Var "Volumes do Pedido:" Pixel Of __oTelaOP
	@ nLin-1,060 MSGET oSldGrupo  Var cVolumeAtu When .F. Size 50*nWebPx,10*nWebPx Pixel Of __oTelaOP
	oSldGrupo:oFont:= TFont():New('Arial',,20*nWebPx,,.T.,,,,.T.,.F.)

	nLin += 20*nWebPx
	@ nLin,005 Button oDesmonta PROMPT "Desmonta Embalagem" Size 90,10*nWebPx Action Desmonta() Pixel Of __oTelaOP
	cCSSBtN1 := "QPushButton{"+cPush+;
	"QPushButton:pressed {"+cPressed+;
	"QPushButton:hover {"+cHover
	oDesmonta:SetCSS( cCSSBtN1 )

	@ nLin,097 Button oEtiqueta PROMPT "Sair" Size 50,10*nWebPx ACTION (__oTelaOP:End())  Pixel Of __oTelaOP
	cCSSBtN1 := "QPushButton{"+cPush+;
	"QPushButton:pressed {"+cPressed+;
	"QPushButton:hover {"+cHover
	oEtiqueta:SetCSS( cCSSBtN1 )

	Activate MsDialog __oTelaOP

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ            '
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VldEtq   ºAutor  ³Helio Ferreira      º Data ³  15/06/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação da etiqueta para faturamento						     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VldEtiq()

	Local _lRet := .T.
	_cCliEmp    := ""
	_cDescric   := ""
	_cEmbalag   := ""
	_nQtdEmp    := 0
	_aDados     := {}

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
	XD1->( dbSetOrder(1) )
	XD2->( dbSetOrder(1) )

	If XD1->(dbSeek(xFilial("XD1")+_cNumEtqPA))

		SB1->(dbSeek(xFilial("SB1")+XD1->XD1_COD))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica nivel														³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If XD1->XD1_ULTNIV <> 'S'
			U_MsgColetor("A embalagem não pode ser desmontada, pois não se apresenta como o último nível de embalagem.")
			_cNumEtqPA := Space(_nTamEtiq)
			__oGetOP:Refresh()
			__oGetOP:SetFocus()
			Return(.F.)
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Salva etiqueta bipada											³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cEtqDesmonta := _cNumEtqPA

		If XD2->(dbSeek(xFilial("XD2")+XD1->XD1_XXPECA))

			_cNumOp   := XD1->XD1_OP

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza etiqueta bipada										³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aScan(aEmbBip,{ |aVet| aVet[1] == _cNumEtqPA }) == 0

				If SZY->(dbSeek(xFilial("SZY")+SubStr(XD1->XD1_PVSEP,1,6)))

					If !Empty(XD1->XD1_ZYNOTA)
						U_MsgColetor("Embalagem já faturada.")
						_cNumEtqPA := Space(_nTamEtiq)
						__oGetOP:Refresh()
						__oGetOP:SetFocus()
						Return(.F.)
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Atualiza dados para o coletor									³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					SC5->(dbSeek(xFilial("SC5")+SZY->ZY_PEDIDO))
					_cNumPed  := SC5->C5_NUM
					_cCliEmp  := SC5->C5_CLIENTE
					_cDescric := Posicione("SA1",1,xFilial("SA1")+_cCliEmp,"A1_NOME")

					oTxtProdCod:Refresh()
					oTxtProdEmp:Refresh()
					oTxtQtdEmp:Refresh()
					oNumOp:Refresh()
					oTxtQtdEmp:Refresh()
					__oTelaOP:Refresh()
					lFaturado  := .F.
					cTipoSenf  := ""
					oDesmonta:Enable()
					oDesmonta:SetFocus()

					_cNumEtqPA  := Space(_nTamEtiq)
					__oGetOP:Refresh()
					__oGetOP:SetFocus()


				EndIf


			Else
				_cNumEtqPA := Space(_nTamEtiq)
				__oGetOP:Refresh()
				__oGetOP:SetFocus()
				_lRet:=.F.
				cTipoSenf := ""
				Return(.F.)
			EndIf

		Else
			U_MsgColetor("Próximo nível de Embalagem não encontrada.")
			_cNumEtqPA := Space(_nTamEtiq)
			__oGetOP:Refresh()
			__oGetOP:SetFocus()
			cTipoSenf := ""
			Return(.F.)
		EndIf

	Else

		U_MsgColetor("Etiqueta não encontrada, ou a embalagem foi desmontada.")
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ            '
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Desmonta  ºAutor  ³Michel A. Sander    º Data ³  23.02.17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Desmonta a embalagem e cancela a separação das filhas	     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/    

Static Function Desmonta()
	Local nX
	LOCAL aDesmonta := {}

	If U_uMsgYesNo("Confirma a DESMONTAGEM da embalagem ?")

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Estorna etiquetas das embalagens filhas no XD2			³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cEtqOrigem := XD1->XD1_XXPECA
		If XD2->(dbSeek(xFilial("XD2")+XD1->XD1_XXPECA))
			Do While XD2->(dbSeek(xFilial("XD2")+XD1->XD1_XXPECA))
				AADD(aDesmonta,{XD2->XD2_PCFILH})
				Reclock("XD2",.F.)
				XD2->(dbDelete())
				XD2->(MsUnlock())
			EndDo
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Cancela a separação das filhas								³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nX := 1 to Len(aDesmonta)
			If XD1->(dbSeek(xFilial("XD1")+aDesmonta[nX,1]))
				Reclock("XD1",.F.)
				XD1->XD1_PVSEP := ""
				XD1->XD1_ZYSEQ := ""
				XD1->(MsUnlock())
			EndIf
		Next nX

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Deleta a etiqueta da embalagem final						³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If XD1->(dbSeek(xFilial("XD1")+cEtqOrigem))
			Reclock("XD1",.F.)
			XD1->XD1_OCORRE := "5"
			XD1->(MsUnLock())
		EndIf

		oDesmonta:Disable()
		_cNumEtqPA   := Space(_nTamEtiq)
		cEtqDesmonta := ""

		__oGetOP:Refresh()
		__oGetOP:SetFocus()

	EndIf

Return ( .T. )
