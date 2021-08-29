#include "TbiConn.ch"
#include "TbiCode.ch"
#include "Rwmake.ch"
#include "Topconn.ch"
#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DOMACD36  �Autor  �Michel Sander       � Data �  04.06.19   ���
�������������������������������������������������������������������������͹��
���Desc.     � Etiqueta OI S/A para faturamento (EXPEDICAO) 	   		  ���
���          � 														                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function DOMACW36()

	Private oTxtOP,__oGetOP,__oTxtEtiq,oGetEtiq,oTxtProd,oGetProd,oTxtQtd,oGetQtd,oMark,oMainEti,oEtiqueta
	Private oTxtProdCod,oTxtProdEmp,oNumOp
	Private _nTamEtiq      := 21
	Private _cNumEtqPA     := Space(_nTamEtiq)
	Private _cProduto      := CriaVar("B1_COD",.F.)
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
		_cDtaFat   := CtoD("13/10/16")
	EndIf

	Define MsDialog __oTelaOP Title OemToAnsi("Etiqueta OI S/A " + DtoC(dDataBase) ) From 0,0 To 450,302 Pixel of oMainWnd PIXEL

	nLin := 005
	@ nLin,001 Say __oTxtEtiq    Var "Num.Etiqueta" Pixel Of __oTelaOP
	@ nLin-2,045 MsGet __oGetOP  Var _cNumEtqPA Valid VldEtiq() Size 70*nWebPx,10*nWebPx Pixel Of __oTelaOP
	__oTxtEtiq:oFont := TFont():New('Arial',,17*nWebPx,,.T.,,,,.T.,.F.)
	__oGetOP:oFont := TFont():New('Arial',,12*nWebPx,,.T.,,,,.T.,.F.)

	@ 018*nWebPx,001 To 132*nWebPx,150 Pixel Of oMainWnd PIXEL

	nLin += 015*nWebPx
	@ nLin,005 Say oTxtProdEmp  Var "Cliente: "        Pixel Of __oTelaOP
	@ nLin,035 Say oTxtProdCod  Var _cCliEmp           Pixel Of __oTelaOP
	oTxtProdEmp:oFont  := TFont():New('Arial',,12*nWebPx,,.T.,,,,.T.,.F.)
	oTxtProdCod:oFont  := TFont():New('Arial',,14*nWebPx,,.T.,,,,.T.,.F.)
	
	nLin += 10*nWebPx
	@ nLin,005 Say oTxtDes      Var "Descri��o: "      Pixel Of __oTelaOP
	@ nLin,042 say oTxtDescPro  Var _cDescric      Size 075*nWebPx,15*nWebPx Pixel Of __oTelaOP
	oTxtDes:oFont := TFont():New('Arial',,12*nWebPx,,.T.,,,,.T.,.F.)
	oTxtDescPro:oFont := TFont():New('Arial',,14*nWebPx,,.T.,,,,.T.,.F.)
	
	nLin+= 30*nWebPx
	@ nLin,005 Say oTxtPed Var "Pedido: " Pixel Of __oTelaOP
	@ nLin,035 Say oNumPed Var _cNumPed+'-'+_cNomCli Size 120*nWebPx,10*nWebPx Pixel Of __oTelaOP
	oTxtPed:oFont:= TFont():New('Arial',,12*nWebPx,,.T.,,,,.T.,.F.)
	oNumPed:oFont:= TFont():New('Arial',,15*nWebPx,,.T.,,,,.T.,.F.)
	
	nLin+= 75*nWebPx
	@ nLin,077 Button oEtiqueta PROMPT "Sair" Size 35*nWebPx,10*nWebPx  ACTION (__oTelaOP:End())  Pixel Of __oTelaOP
	cCSSBtN1 := "QPushButton{"+cPush+;
	"QPushButton:pressed {"+cPressed+;
	"QPushButton:hover {"+cHover
	oEtiqueta:setCSS(cCSSBtN1)

	Activate MsDialog __oTelaOP

Return

/*
�����������������������������������������������������������������������������            '
�������������������������������������������������������������������������ͻ��
���Programa  � VldEtq   �Autor  �Helio Ferreira      � Data �  15/06/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o da etiqueta para faturamento						     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function VldEtiq()
	Local nQ
	Local _lRet := .T.
	_cCliEmp    := ""
	_cDescric   := ""
	_cEmbalag   := ""
	_nQtdEmp    := 0
	_aDados     := {}

	If Empty(_cNumEtqPA)
		Return .F.
	Elseif len (alltrim(_cNumEtqPA)) > 0
		_cNumEtqPA:= alltrim(_cNumEtqPA) 
	EndIf

//������������������������������������������������������Ŀ
//�Prepara n�mero da etiqueta bipada							�
//��������������������������������������������������������
	If Len(AllTrim(_cNumEtqPA))<=12 //EAN 13 s/ d�gito verificador.
		_cNumEtqPA := "0"+_cNumEtqPA
		_cNumEtqPA := Subs(_cNumEtqPA,1,12)
	EndIf

	SC2->( dbSetOrder(1) )
	SB1->( dbSetOrder(1) )
	SBF->( dbSetOrder(2) )
	XD1->( dbSetOrder(1) )

	If XD1->( dbSeek(xFilial("XD1") + _cNumEtqPA ) )

		//������������������������������������������������������Ŀ
		//�Verifica volume													�
		//��������������������������������������������������������
		cNumNF := ""
		If XD1->XD1_ULTNIV <> "S"
			If U_uMsgYesNo("Embalagem n�o � ultimo n�vel. Continuar?")
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
					U_MsgColetor("Embalagem superior a esta n�o encontrada.")
					_cNumEtqPA := Space(_nTamEtiq)
					__oGetOP:Refresh()
					__oGetOP:SetFocus()
					Return(.F.)
				EndIf
			Else
				U_MsgColetor("Esse volume n�o � embalagem final.")
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

		//������������������������������������������������������Ŀ
		//�Verifica faturamento												�
		//��������������������������������������������������������
		If Empty(cNumNF)
			U_MsgColetor("Esse volume ainda n�o foi faturado.")
			_cNumEtqPA := Space(_nTamEtiq)
			__oGetOP:Refresh()
			__oGetOP:SetFocus()
			Return(.F.)
		EndIf

		//������������������������������������������������������Ŀ
		//�Verifica ITEM de pedido faturado												�
		//��������������������������������������������������������
		If Empty(cItemPV)
			U_MsgColetor("Item de Pedido de Venda n�o encontrado para emiss�o da Etiqueta.")
			_cNumEtqPA := Space(_nTamEtiq)
			__oGetOP:Refresh()
			__oGetOP:SetFocus()
			Return(.F.)
		EndIf

		SB1->(dbSeek(xFilial("SB1")+XD1->XD1_COD))

		//������������������������������������������������������Ŀ
		//�Verifica separa��o												�
		//��������������������������������������������������������
		XD2->(dbSetOrder(1))
		If XD2->(dbSeek(xFilial("XD2")+XD1->XD1_XXPECA))

			SZY->(dbSetOrder(1))
			If SZY->(dbSeek(xFilial("SZY")+SUBSTRING(XD1->XD1_PVSEP,1,6)))

				//������������������������������������������������������Ŀ
				//�Atualiza dados para o coletor									�
				//��������������������������������������������������������
				SC5->(dbSeek(xFilial("SC5")+SZY->ZY_PEDIDO))
				SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE))

				//������������������������������������������������������Ŀ
				//�Verifica se o Cliente � OI S/A								�
				//��������������������������������������������������������
				lOi := .F.
				If ("OI S" $ Upper(SA1->A1_NOME)) .Or. ("OI MO" $ Upper(SA1->A1_NOME)) .Or. ("TELEMAR" $ Upper(SA1->A1_NOME)) .Or. ("BRASIL TELECOM COMUNICACAO MUL" $ Upper(SA1->A1_NOME))
					lOi := .T.
				Else
					U_MsgColetor("Esse volume n�o pertence ao cliente OI S/A.")
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
					//������������������������������������������������������Ŀ
					//�Imprime Etiqueta OI S/A											�
					//��������������������������������������������������������
					aDesmonta := DesmontaVol(_cNumEtqPA)
					For nQ := 1 to Len( aDesmonta )
						// 01 - Numero da OP
						// 02 - Codigo do Produto
						// 03 - Pedido de Compra do Cliente
						// 04 - Quantidade da Etiqueta
						// 05 - Data de Produ��o
						// 06 - Muda impressora de etiqueta para EXPEDI��O
						// 07 - N�mero da Nota Fiscal
						// 08 - Peso do Item
						//DOMET105(cEtqOp ,  cEtqProd       , cEtqPed , nEtqQtd        , dDataFab , lControl, cNfDanfe                                       , nPesoDanfe     )
						U_DOMET105(_cOPImp, aDesmonta[nQ,1], _cNumPed, aDesmonta[nQ,3] , dDataBase, .T.     , IIF(!Empty(XD1->XD1_ZYNOTA),XD1->XD1_ZYNOTA,""), XD1->XD1_PESOB )
					Next nQ
				EndIf

			Else
				U_MsgColetor("Pedido n�o encontrado")
				_cNumEtqPA := Space(_nTamEtiq)
				__oGetOP:Refresh()
				__oGetOP:SetFocus()
				Return(.F.)
			EndIf
		Else
			U_MsgColetor("Pr�ximo n�vel de Embalagem n�o encontrada.")
			_cNumEtqPA := Space(_nTamEtiq)
			__oGetOP:Refresh()
			__oGetOP:SetFocus()
			cTipoSenf := ""
			_lRet:=.F.
		EndIf

	Else

		U_MsgColetor("Embalagem final n�o encontrada.")
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DesmontaVol�Autor�Michel Sander       � Data �  09/15/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Desmonta os volumes para verificar as quantidades          ���
���          � contra o pedido de venda que ser� faturado                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function DesmontaVol(cCodVolume)

	LOCAL cAliasXD1  := GetNextAlias()
	LOCAL cPeca      := "%XD1_XXPECA='"+cCodVolume+"'%"
	LOCAl aOi := {}

//������������������������������������������������������Ŀ
//�Verifica as caixas do volume bipado VOLUME 3				�
//��������������������������������������������������������
	BEGINSQL Alias cAliasXD1
 
	SELECT XD1_COD, XD1_PVSEP, XD1_QTDATU, XD1_PESOB 
			 FROM %table:XD1% XD1 (NOLOCK) 
			 WHERE XD1.%NotDel% AND 
			 		 XD1_ULTNIV = 'S' AND 
			 		 XD1_OCORRE <> '5' AND
					 %Exp:cPeca% 
	ENDSQL

//������������������������������������������������������Ŀ
//�Agrupa os Itens													�
//��������������������������������������������������������
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

