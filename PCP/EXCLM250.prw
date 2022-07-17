#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ EXCLM250 บAutor  ณ Michel Sander      บ Data ณ    27/05/15 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Estorno de apontamento de embalagens						  	  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function EXCLM250()

	LOCAL __SA1 := SA1->( GetArea() )
	LOCAL __SB1 := SB1->( GetArea() )
	LOCAL __SC2 := SC2->( GetArea() )
	LOCAL __SD3 := SD3->( GetArea() )
	LOCAL __SZA := SZA->( GetArea() )
	LOCAL __SZE := SZE->( GetArea() )
	LOCAL __SDA := SDA->( GetArea() )
	LOCAL __SDB := SDB->( GetArea() )
	LOCAL __XD1 := XD1->( GetArea() )
	LOCAL __XD2 := XD2->( GetArea() )

	Private __nTamExcl  := 21
	Private cExclEtBip  := SPACE(__nTamExcl)
	Private cExclProd   := SPACE(15)
	Private cExclDesc   := SPACE(45)
	Private cExclCli    := SPACE(06)
	Private nQtdExclEt  := 0
	Private nExclSald   := 0
	Private cExclPed    := SPACE(06)
	Private nExclBxOp   := 0.00
	Private _cArqExcl   := ""
	Private _aCampos    := {}
	Private __oOk  	  := LoadBitmap(GetResources(), "BR_VERDE")
	Private __oNOk 	  := LoadBitmap(GetResources(), "BR_VERMELHO")
	Private __oOkExcl   := LoadBitmap( GetResources(), "LBOK" )
	Private __oNOkExcl  := LoadBitmap( GetResources(), "LBNO" )
	Private _oList
	Private oDlgExcl
	Private oExclEtBip
	Private oRetExcl
	Private _oCliente
	Private _oProduto
	Private _oDescricao
	Private _oPedido
	Private _oBaixas
	Private _oSlBip
	Private lSemProducao:= .F.
	Private cNivEmb := ""
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPosi็ใo inicial da tela principal							ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_nLin  := 15
	_nCol1 := 10
	_nCol2 := 95

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCabe็alho da OP													ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DEFINE MSDIALOG oDlgExcl TITLE OemToAnsi("EXCLM250 - Estorno de Apontamento de Ordens de Produ็ใo") FROM 0,0 TO 470,800 PIXEL of oMainWnd PIXEL //300,400 PIXEL of oMainWnd PIXEL

	@ _nLin-10,_nCol1-05 TO _nLin+62,_nCol1+387 LABEL " Informa็๕es da Ordem de Produ็ใo "  OF oDlgExcl PIXEL
	@ _nLin, _nCol1	SAY oTexto10 Var 'N๚mero da Etiqueta:'    SIZE 100,10 PIXEL
	oTexto10:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
	@ _nLin-2, _nCol2 MSGET oExclEtBip VAR cExclEtBip SIZE 80,12 WHEN .T. VALID VAlidaOP() PIXEL
	oExclEtBip:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)
	@ _nLin, _nCol2+090	SAY oTexto12 Var 'Quantidade:'    SIZE 100,10 PIXEL
	oTexto12:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
	@ _nLin-2, _nCol2+140 MSGET oQtdOPBip VAR nQtdExclEt  SIZE 50,12 WHEN .F. PIXEL
	oQtdOPBip:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)
	@ _nLin, _nCol2+200	SAY oTexto13 Var 'Saldo:'    SIZE 100,10 PIXEL
	oTexto13:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
	@ _nLin-2, _nCol2+230 MSGET _oSlBip VAR nExclSald  SIZE 50,12 WHEN .F. PIXEL
	_oSlBip:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)
	_nLin += 15
	@ _nLin, _nCol1	SAY oTexto10 Var 'Produto:'    SIZE 100,10 PIXEL
	oTexto10:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
	@ _nLin-2, _nCol2 MSGET _oProduto VAR cExclProd  SIZE 100,12 WHEN .F. PIXEL
	_oProduto:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)
	@ _nLin, _nCol2+110 SAY oTexto15 Var 'Baixas'    SIZE 100,10 PIXEL
	oTexto15:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
	@ _nLin-2, _nCol2+140 MSGET _oBaixas VAR nExclBxOp PICTURE "9999.99" SIZE 50,12 WHEN .F. PIXEL
	_oBaixas:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)
	@ _nLin, _nCol2+195	SAY oTexto14 Var 'Pedido:'    SIZE 100,10 PIXEL
	oTexto14:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
	@ _nLin-2, _nCol2+230 MSGET _oPedido VAR cExclPed  SIZE 50,12 WHEN .F. PIXEL
	_oPedido:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)

	_nLin += 15
	@ _nLin-2, _nCol2 MSGET _oDescricao VAR cExclDesc  SIZE 280,12 WHEN .F. PIXEL
	_oDescricao:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)
	_nLin += 15
	@ _nLin, _nCol1	SAY oTexto11 Var 'Cliente:'    SIZE 100,10 PIXEL
	oTexto11:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
	@ _nLin-2, _nCol2 MSGET _oCliente VAR cExclCli  SIZE 280,12 WHEN .F. PIXEL
	_oCliente:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณLeitura da Etiqueta												ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_nLin += 30
	@ _nLin-10,_nCol1-05 TO _nLin+110,_nCol1+387 LABEL " Apontamentos de Produ็ใo "  OF oDlgExcl PIXEL
	_nLin += 115

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณBot๕es de controle												ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	@ _nLin,_nCol1-05 TO _nLin+1,_nCol1+387 LABEL "" OF oDlgExcl PIXEL 	// Linha horizontal para separar bot๕es
	_nLin += 05

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ BROWSE para as caixas disponํveis                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	AADD(_aCampos, { .F., Space(13), 0, CTOD(""), Space(5), Space(14), Space(06), Space(10) })
	_oList := TWBrowse():New( 90,10,382,100,,{ " ", "Num. Etiqueta", "Quantidade", "Data", "Hora", "N๚mero da OP", "Sequencia", "Usuแrio"  },,oDlgExcl,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	_oList:SetArray(_aCampos)
	_oList:bLine := { || { If(_aCampos[_oList:nAt,1],__oOk,__oNOk), _aCampos[_oList:nAt,2], _aCampos[_oList:nAT,3], _aCampos[_oList:nAT,4], _aCampos[_oList:nAT,5], _aCampos[_oList:nAT,6], _aCampos[_oList:nAT,7], _aCampos[_oList:nAT,8] } }

	@ _nLin, _nCol2+090 BUTTON oExclEst PROMPT "Estornar" ACTION Processa( {|| If(VerEstorno(), oRetExcl := fExclM250(),;
		{ cExclEtBip := Space(__nTamExcl),;
		oExclEtBip:Refresh(), ;
		fLimpa(@oRetExcl),;
		oExclEtBip:SetFocus() } ) } ) SIZE 100,20 PIXEL OF oDlgExcl

	@ _nLin, _nCol2+200 BUTTON oExlCanc PROMPT "Cancelar" ACTION Processa( {|| oDlgExcl:End() } ) SIZE 100,20 PIXEL OF oDlgExcl

	ACTIVATE MSDIALOG oDlgExcl CENTER

	If Select("TRB") <> 0
		dbSelectArea("TRB")
		TRB->(dbCloseArea())
		fErase(_cArqExcl+OrdBagExt())
	EndIf

	SA1->( RestArea(__SA1) )
	SB1->( RestArea(__SB1) )
	SC2->( RestArea(__SC2) )
	SD3->( RestArea(__SD3) )
	SZA->( RestArea(__SZA) )
	SZE->( RestArea(__SZE) )
	SDA->( RestArea(__SDA) )
	SDB->( RestArea(__SDB) )
	XD1->( RestArea(__XD1) )
	XD2->( RestArea(__XD2) )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ValidaEtiq บAutorณ Helio Ferreira     บ Data ณ    27/05/15 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida็ใo da etiqueta bipada                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidaOP(lTeste)

	DEFAULT lTeste   := .F.
	PRIVATE cEtiqAux := cExclEtBip

	If !Empty(cExclEtBip)

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณPrepara n๚mero da etiqueta bipada							ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If Len(AllTrim(cExclEtBip)) == 12
			If UPPER(Subs(cEtiqOrig,1,1)) <> 'S'
				nItOP     := StrZero(Val(SubStr(cEtiqAux,8,1)),3)
				cOPnSerie := PADR(SubsTr(cEtiqAux,1,5),6)+SubsTr(cEtiqAux,6,2)+nItOP

				If SC2->(dbSeek(xFilial()+cOPnSerie))
					If SC2->C2_EMISSAO >= StoD('20170101')
						lSerial := .T.
					Else
						cExclEtBip := "0"+cExclEtBip
						cExclEtBip := Subs(cExclEtBip,1,12)

						lSerial   := .F.
					EndIf
				Else
					cExclEtBip := "0"+cExclEtBip
					cExclEtBip := Subs(cExclEtBip,1,12)

					lSerial   := .F.
				EndIf
			else
				cOPnSerie := Subs(cEtiqAux,2,11)
				lSerial := .T.				
			EndIf
		Else
			If UPPER(Subs(cEtiqOrig,1,1)) <> 'S'			
				nItOP     := StrZero(Val(SubStr(cEtiqAux,8,1)),3)
				cOPnSerie := PADR(SubsTr(cEtiqAux,1,5),6)+SubsTr(cEtiqAux,6,2)+nItOP

				If SC2->(dbSeek(xFilial("SC2")+cOPnSerie))
					lSerial := .T.
				Else
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณValida etiqueta bipada											ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					While !MsgNoYes("Etiqueta nใo encontrada. "+CHR(13)+"Deseja continuar?")
					End
					oImprime:Disable()
					cExclEtBip   := Space(__nTamExcl)
					oExclEtBip:SetFocus()
					Return (.F.)
				EndIf
			else
				cOPnSerie := Subs(cEtiqAux,2,11)
				lSerial := .T.		
			Endif
		EndIf

		XD1->( dbSetOrder(1) )
		XD2->( dbSetOrder(2) )
		SB1->( dbSetOrder(1) )

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณPosiciona na etiqueta bipada									ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If XD1->( dbSeek( xFilial() + cExclEtBip ) ) .and. !lSerial

			If XD1->XD1_OCORRE == "5"
				While !MsgNoYes("Etiqueta cancelada."+CHR(13)+"Deseja continuar?")
				End
				oImprime:Disable()
				cExclEtBip   := Space(__nTamExcl)
				oExclEtBip:SetFocus()
				Return (.F.)
			EndIf

			If XD1->XD1_OCORRE == "4"
				While !MsgNoYes("Embalagem jแ entregue para a expedi็ใo."+CHR(13)+"Deseja continuar?")
				End
				oImprime:Disable()
				cExclEtBip   := Space(__nTamExcl)
				oExclEtBip:SetFocus()
				Return (.F.)
			EndIf

			//Nivel da Embalagem dessa Etiqueta
			cNivEmb := XD1->XD1_NIVEMB

			SC2->(dbSetOrder(1))
			If !SC2->(dbSeek(xFilial("SC2")+XD1->XD1_OP))
				While !MsgNoYes("Ordem de Produ็ใo Invแlida ou nใo encontrada. "+CHR(13)+"Deseja continuar?")
				End
				oImprime:Disable()
				cExclEtBip   := Space(__nTamExcl)
				oExclEtBip:SetFocus()
				Return (.F.)
			EndIf
			//Valida็ใo se jแ passou no roteiro
			If U_VALIDACAO("JACKSON",.F.,'29/06/22','') 
				If XD1->XD1_OCORRE == "7"
					While !MsgNoYes("Etiqueta jแ validada no roteiro de produ็ใo, nใo ้ possํvel cancelar."+CHR(13)+"Deseja continuar?")
					End
					oImprime:Disable()
					cExclEtBip   := Space(__nTamExcl)
					oExclEtBip:SetFocus()
					Return (.F.)
				EndIf
			EndIf
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Cria arquivo temporแrio                           ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			_aStru := {}
			AADD(_aStru, {"MARCA"       ,"C",01,0} )
			AADD(_aStru, {"D3_XXPECA"   ,"C",13,0} )
			AADD(_aStru, {"XD1_NIVEMB"  ,"C",01,0} )
			AADD(_aStru, {"D3_QUANT"    ,"N",10,2} )
			AADD(_aStru, {"D3_EMISSAO"  ,"D",08,0} )
			AADD(_aStru, {"D3_HORA"     ,"C",05,0} )
			AADD(_aStru, {"D3_DOC"      ,"C",09,0} )
			AADD(_aStru, {"D3_NUMSEQ"   ,"C",06,0} )
			AADD(_aStru, {"D3_USUARIO"  ,"C",10,0} )
			AADD(_aStru, {"D3_SCHEDUL"  ,"C",01,0} )
			AADD(_aStru, {"D3_OP"       ,"C",14,0} )
			AADD(_aStru, {"D3_COD"		 ,"C",15,0} )
			AADD(_aStru, {"D3_LOCAL"    ,"C",02,0} )
			AADD(_aStru, {"D3_FILIAL"   ,"C",02,0} )
			AADD(_aStru, {"R_E_C_N_O_"  ,"N",15,0} )

			_cArqExcl := CriaTrab(_aStru,.T.)
			If Select("TRB") <> 0
				TRB->( dbCloseArea() )
			EndIf
			dbUseArea(.T.,__LocalDriver,_cArqExcl,"TRB",.F.)
			IndRegua("TRB",_cArqExcl,"D3_XXPECA",,,)

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Busca apontamentos		                           ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			cAliasSD3 := GetNextAlias()
			cWhereD3 := "%D3_XXPECA='"+cExclEtBip+"' AND D3_TM='010' AND D3_ESTORNO <> 'S'%"
			BEGINSQL Alias cAliasSD3
			
			SELECT D3_FILIAL,
			D3_XXPECA,
			XD1_NIVEMB,
			D3_COD,
			D3_QUANT,
			D3_EMISSAO,
			D3_HORA,
			D3_DOC,
			D3_NUMSEQ,
			D3_USUARIO,
			D3_OP,
			D3_LOCAL,
			SD3.R_E_C_N_O_
			FROM %Table:SD3% SD3 (NOLOCK), %Table:XD1% XD1 (NOLOCK)
			WHERE %Exp:cWhereD3%
			AND D3_XXPECA = XD1_XXPECA
			AND SD3.%NotDel%
			AND XD1.%NotDel%
			ORDER BY D3_XXPECA
			
			ENDSQL

			nExclBxOp := 0
			_aCampos  := {}

			If (cAliasSD3)->(Eof())

				AADD(_aCampos, { .T., XD1->XD1_XXPECA, XD1->XD1_QTDATU, XD1->XD1_DTDIGI, Time(), XD1->XD1_OP, "", UsrRetName(XD1->XD1_USERID) })
				lSemProducao := .T.
				//oImprime:Disable()
				//cExclEtBip   := Space(__nTamExcl)
				//oExclEtBip:SetFocus()
				//(cAliasSD3)->(dbCloseArea())
			EndIf

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Atualiza temporแrio		                           ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			Do While !(cAliasSD3)->(Eof())
				Reclock("TRB",.T.)
				TRB->D3_XXPECA  := (cAliasSD3)->D3_XXPECA
				TRB->XD1_NIVEMB := (cAliasSD3)->XD1_NIVEMB
				TRB->D3_QUANT   := (cAliasSD3)->D3_QUANT
				TRB->D3_EMISSAO := STOD((cAliasSD3)->D3_EMISSAO)
				TRB->D3_HORA    := (cAliasSD3)->D3_HORA
				TRB->D3_DOC     := (cAliasSD3)->D3_DOC
				TRB->D3_NUMSEQ  := (cAliasSD3)->D3_NUMSEQ
				TRB->D3_USUARIO := (cAliasSD3)->D3_USUARIO
				TRB->D3_OP      := (cAliasSD3)->D3_OP
				TRB->D3_COD     := (cAliasSD3)->D3_COD
				TRB->D3_LOCAL   := (cAliasSD3)->D3_LOCAL
				TRB->D3_SCHEDUL := "N"
				TRB->D3_FILIAL  := (cAliasSD3)->D3_FILIAL
				TRB->R_E_C_N_O_ := (cAliasSD3)->R_E_C_N_O_
				TRB->(MsUnlock())
				nExclBxOp += (cAliasSD3)->D3_QUANT
				AADD(_aCampos, { .T., (cAliasSD3)->D3_XXPECA, (cAliasSD3)->D3_QUANT, STOD((cAliasSD3)->D3_EMISSAO), (cAliasSD3)->D3_HORA, (cAliasSD3)->D3_OP, (cAliasSD3)->D3_NUMSEQ, (cAliasSD3)->D3_USUARIO })
				(cAliasSD3)->(dbSkip())
			EndDo
			(cAliasSD3)->(dbCloseArea())

			_oList:SetArray(_aCampos)
			_oList:bLine      := { || { If(_aCampos[_oList:nAt,1],__oOk,__oNOk), _aCampos[_oList:nAt,2], _aCampos[_oList:nAT,3], _aCampos[_oList:nAT,4], _aCampos[_oList:nAT,5], _aCampos[_oList:nAT,6], _aCampos[_oList:nAT,7], _aCampos[_oList:nAT,8] } }
			_oList:Refresh()

			dbSelectArea("TRB")
			dbGotop()

			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial()+SC2->C2_PRODUTO))

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Atualiza janela							               ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			cExclProd  := SB1->B1_COD
			cExclDesc  := SB1->B1_DESC
			cExclCli   := SA1->A1_NOME
			nQtdExclEt := SC2->C2_QUANT
			cExclPed   := SC2->C2_PEDIDO
			nExclSald  := (SC2->C2_QUANT - SC2->C2_QUJE)  // Trocado de C2_XXQUJE para C2_QUJE por H้lio em 25/09/18
		elseIf lSerial
			If U_VALIDACAO("JACKSON",.F.,'07/07/22','') 			
				XD4->(DbSetOrder(3))
				If XD4->(DbSeek(xFilial("XD4") + UPPER(Alltrim(cExclEtBip))))
					If XD4->XD4_STATUS == "2"
						While !MsgNoYes("Etiqueta jแ validada no roteiro de produ็ใo, nใo ้ possํvel cancelar."+CHR(13)+"Deseja continuar?")
						End
						oImprime:Disable()
						cExclEtBip   := Space(__nTamExcl)
						oExclEtBip:SetFocus()
						Return (.F.)
					EndIf
				EndIf
			Endif			
		EndIf

		_oCliente:Refresh()
		_oProduto:Refresh()
		_oDescricao:Refresh()
		_oPedido:Refresh()
		_oBaixas:Refresh()
		_oSlBip:Refresh()

	EndIf

Return( .T. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fExclM250บAutor ณ Michel Sander	     บ Data ณ    27/05/15 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Estorna apontamento da OP		                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fExclM250()

    //Local aCabSDA    := {}
    //Local aItSDB     := {}
    //Local _aItensSDB := {}

	Private lMsHelpAuto    := .T.
	Private lMsErroAuto    := .F.

	XD2->(dbSetOrder(1))
	XD1->(dbSetOrder(1))
	If !lSemProducao

		If Select("TRB") <> 0   //mauresi
			TRB->(dbGotop())
			Do While TRB->(!Eof())

				cChaveD3:= TRB->D3_FILIAL + TRB->D3_OP + TRB->D3_COD + TRB->D3_LOCAL
				SD3->(DbSetOrder(1))
				If SD3->(DbSeek(cChaveD3))

					Do While !(SD3->(Eof())) .And. SD3->(D3_FILIAL + D3_OP + D3_COD + D3_LOCAL) == cChaveD3

						If SD3->D3_TM == "010" .And. SD3->D3_ESTORNO == " "

							If SD3->D3_DOC == TRB->D3_DOC .And. SD3->D3_NUMSEQ == TRB->D3_NUMSEQ .And. SD3->D3_XXPECA == TRB->D3_XXPECA

								lAuto := .F.
								MsgRun("Estornando Apontamento...","MATA250",{|| lAuto := U_ESTPRODOM(SD3->D3_XXPECA,.T.,.F.) })

								If lAuto

									//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
									//ณ Verifica se a OP estแ encerrada		               ณ
									//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
									SC2->(dbSetOrder(1))
									If SC2->(dbSeek(xFilial("SC2")+AllTrim(SD3->D3_OP)))
										If !Empty(SC2->C2_DATPRF)
											Reclock("SC2",.F.)
											SC2->C2_DATPRF := CTOD("")
											SC2->(MsUnlock())
										EndIf
									EndIf

									//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
									//ณ Cancela etiqueta							               ณ
									//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
									XD1->(dbSetOrder(1))
									If XD1->(dbSeek(xFilial()+TRB->D3_XXPECA))
										Reclock("XD1",.F.)
										XD1->XD1_OCORRE := "5"
										XD1->(MsUnlock())
									EndIf

									//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
									//ณEstorna etiquetas das embalagens filhas no XD2			ณ
									//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
									XD2->(dbSetOrder(1))
									If XD2->(dbSeek(xFilial("XD2")+XD1->XD1_XXPECA))
										Do While XD2->(dbSeek(xFilial("XD2")+XD1->XD1_XXPECA))
											Reclock("XD2",.F.)
											XD2->(dbDelete())
											XD2->(MsUnlock())
										EndDo
									EndIf

								EndIf

								//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
								//ณ Prepara array de execu็ใo 			               ณ
								//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
							/*					lMsErroAuto := .F.
							aEstorno := {}
							Aadd(aEstorno,{"D3_FILIAL " , SD3->D3_FILIAL                  , NIL })
							Aadd(aEstorno,{"D3_OP     " , SD3->D3_OP   		   		     , NIL })
							Aadd(aEstorno,{"D3_COD    " , SD3->D3_COD      		           , NIL })
							Aadd(aEstorno,{"D3_LOCAL  " , SD3->D3_LOCAL                   , NIL })
							Aadd(aEstorno,{"D3_TM     " , "010"	                          , NIL })
							Aadd(aEstorno,{"D3_QUANT  " , SD3->D3_QUANT                   , NIL })
							Aadd(aEstorno,{"D3_DOC    " , SD3->D3_DOC      		           , NIL })
							Aadd(aEstorno,{"D3_NUMSEQ " , SD3->D3_NUMSEQ	                 , NIL })
							
							If SD3->(Recno()) <> TRB->R_E_C_N_O_
							MsgAlert("Nใo foi possํvel posicionar no SD3 R_E_C_N_O_ " + Str(TRB->R_E_C_N_O_) )
							Exit
							EndIf
							
							//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
							//ณ Processa estorno de apontamento		               ณ
							//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
							lMsErroAuto := .F.
							MsgRun("Estornando Apontamento...","MATA250",{|| MSExecAuto({|x,y| mata250(x,y)},aEstorno,5) })
							
							If lMsErroAuto
							MostraErro()
							Exit
							EndIf
							*/

							EndIf

						EndIf

						SD3->(dbSkip())

					EndDo

				EndIf

				TRB->(dbSkip())

			EndDo
		ENDIF
	Else
		If !Empty(Alltrim(cExclEtBip))
			U_DOMETDL8(cExclEtBip)
		Else
			MsgStop("C๓digo da Etiqueta nใo informada","Erro Cod. Etiqueta")
		EndIf
	EndIf
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Atualiza janela							               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_aCampos := {}
	AADD(_aCampos, { .T., Space(13), 0, CTOD(""), Space(5), Space(14), Space(06), Space(10) })
	_oList:SetArray(_aCampos)
	_oList:bLine      := { || { If(_aCampos[_oList:nAt,1],__oOk,__oNOk), _aCampos[_oList:nAt,2], _aCampos[_oList:nAT,3], _aCampos[_oList:nAT,4], _aCampos[_oList:nAT,5], _aCampos[_oList:nAT,6], _aCampos[_oList:nAT,7], _aCampos[_oList:nAT,8] } }
	_oList:Refresh()
	cExclProd  := ""
	cExclDesc  := ""
	cExclCli   := ""
	nQtdExclEt := ""
	cExclPed   := ""
	nExclSald  := 0
	nExclBxOp  := 0
	_oCliente:Refresh()
	_oProduto:Refresh()
	_oDescricao:Refresh()
	_oPedido:Refresh()
	_oBaixas:Refresh()
	_oSlBip:Refresh()
	cExclEtBip   := Space(__nTamExcl)
	oExclEtBip:SetFocus()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fLimpa   บAutor  ณ Helio Ferreira     บ Data ณ    27/05/15 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Limpa a tela no retorno                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fLimpa(oRetExcl)

	cExclProd  := ""
	cExclDesc  := ""
	cExclCli   := ""
	nQtdExclEt := 0
	cExclPed   := ""
	nExclSald  := 0
	nExclBxOp  := 0

	_oCliente:Refresh()
	_oProduto:Refresh()
	_oDescricao:Refresh()
	_oPedido:Refresh()
	_oBaixas:Refresh()
	_oSlBip:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SomaPerdaบAutor ณ Michel Sander	     บ Data ณ    27/05/15 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Soma as perdas por OP			                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Perdas(cExclEtBip,cExclProd)

	LOCAL nPerdas := 0
	SZA->(dbSetOrder(1))
	SZE->(dbSetOrder(1))

	If SZA->(dbSeek(xFilial("SZA")+cExclEtBip))
		Do While SZA->(!Eof()) .And. SZA->ZA_FILIAL+SZA->ZA_OP == xFilial("SZA")+cExclEtBip
			nPerdas += SZA->ZA_SALDO
			SZA->(dbSkip())
		EndDo
	EndIf
	If SZE->(dbSeek(xFilial("SZE")+cExclEtBip))
		Do While SZE->(!Eof()) .And. SZE->ZE_FILIAL+SZE->ZE_OP == xFilial("SZE")+cExclEtBip
			nPerdas += SZE->ZE_SALDO
			SZE->(dbSkip())
		EndDo
	EndIf

Return ( nPerdas )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VerEstornoบAutor ณ Michel Sander	     บ Data ณ    27/05/15 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Confirma estorno					                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VerEstorno()

	LOCAL __lOkBip := .T.
//__lOkBip := MsgNoYes("Confirma o estorno de apontamento?")

Return (__lOkBip)
