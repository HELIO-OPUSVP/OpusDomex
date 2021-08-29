#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DOMACD22 บAutor  ณ Michel Sander      บ Data ณ  21.07.2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Paletiza็ใo via coletor de dados							  บฑฑ
ฑฑบ          ณ 							                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DOMACD22()

	Local lLoop     := .T.
	Local lOk       := .F.
	Local aPar      := {}
	Local aRet      := {}
	Local aLayout   := {}

	Private _nTamEtiq   := 21
	Private __mv_par01  := 1 			      // Pesquisar por OP ou Senf
	Private __mv_par02  := Space(11) 		   // Numero OP
	Private __mv_par03  := Space(09) 			// Senf + Item
	Private __mv_par04  := 0         			// Qtd Embalagem
	Private __mv_par05  := 0         			// Qtd Etiquetas
	Private __mv_par06  := Space(02) 			// Layout da Etiqueta
	Private lBeginSQL   := .T.
	Private lPesoEmb    := .T.
	Private cGrupoDIO   := ""
	Private cEtiqueta   := Space(_nTamEtiq)
	Private cVolumeAtu  := ""
	Private cCliPal     := ""
	Private cNumPed     := SPACE(06)
	Private cItemC6		:= ""
	Private nSaldoVol   := 0
	Private nPesoBruto  := 0
	Private aPalBip     := {}
	Private nPlTotVol   := 0
	Private nPalTot     := 0
	Private nPaletes    := 0
	Private nQtdCaixa   := 0
	Private oEtiqueta
	Private oUltima
	Private oNumPed
	Private oPalTot
	PRIVATE oDlg2
	Private oImprime
	Private lEhFuruka := .F.
	Private lEhClaro  := .F.
	Public cDomEtDl31_CancEtq := ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPosi็ใo inicial da tela principal							ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nLin := 15
	nCol1 := 05
	nCol2 := 95

	If cUsuario == 'HELIO'
		_cNumEtqPA := Space(_nTamEtiq)
		cEtiqueta := Space(_nTamEtiq)
	EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTela de coleta														ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DEFINE MSDIALOG oDlg01 TITLE OemToAnsi("Paletiza็ใo") FROM 0,0 TO 293,233 PIXEL of oMainWnd PIXEL //300,400 PIXEL of oMainWnd PIXEL

	@ 003,001 To 065,115 LABEL "Informa็๕es do Pedido" Pixel Of oMainWnd PIXEL
	nLin := 013

	@ nLin, nCol1	SAY oTexto1 Var 'Etiqueta:'    SIZE 100,10 PIXEL
	oTexto1:oFont := TFont():New('Arial',,16,,.T.,,,,.T.,.F.)
	@ nLin-2, nCol1+30 MSGET oEtiqueta VAR cEtiqueta  SIZE 75,08 WHEN .T. Valid ValidaEtiq() PIXEL
	oEtiqueta:oFont := TFont():New('Courier New',,22,,.T.,,,,.T.,.F.)
	nLin += 12

	@ nLin, nCol1	SAY oTexto10 Var 'Pedido:'    SIZE 100,10 PIXEL
	oTexto10:oFont := TFont():New('Arial',,16,,.T.,,,,.T.,.F.)
	@ nLin-2, nCol1+45 MSGET oNumPed VAR cNumPed  SIZE 60,08 WHEN .F. PIXEL
	oNumPed:oFont := TFont():New('Courier New',,22,,.T.,,,,.T.,.F.)
	nLin += 13

	@ nLin, nCol1	SAY oTexto11 Var 'Volumes:'    SIZE 100,10 PIXEL
	oTexto11:oFont := TFont():New('Arial',,16,,.T.,,,,.T.,.F.)
	@ nLin-2, nCol1+45 MSGET oPlTotVol VAR nPlTotVol  SIZE 60,08 WHEN .F. PIXEL
	oPlTotVol:oFont := TFont():New('Courier New',,22,,.T.,,,,.T.,.F.)
	nLin +=13

	@ nLin, nCol1	SAY oTexto12 Var 'Saldo:'    SIZE 100,10 PIXEL
	oTexto12:oFont := TFont():New('Arial',,16,,.T.,,,,.T.,.F.)
	@ nLin-2, nCol1+45 MSGET oSaldoVol VAR nSaldoVol  SIZE 60,08 WHEN .F. PIXEL
	oSaldoVol:oFont := TFont():New('Courier New',,22,,.T.,,,,.T.,.F.)
	nLin +=13

	@ nLin,001 To nLin+045,115 LABEL "Composi็ใo de Paletes" Pixel Of oMainWnd PIXEL
	nLin += 015
	@ nLin, nCol1	SAY oTexto13 Var 'Concluํdos:'    SIZE 100,10 PIXEL
	oTexto13:oFont := TFont():New('Arial',,16,,.T.,,,,.T.,.F.)
	@ nLin-2, nCol1+45 MSGET oPalTot VAR nPalTot  SIZE 60,08 WHEN .F. PIXEL
	oPalTot:oFont := TFont():New('Courier New',,22,,.T.,,,,.T.,.F.)
	nLin += 33

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณBot๕es de controle												ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nCol1 := 007
	@ nLin, nCol1 BUTTON oSair     PROMPT "Sair							" ACTION oDlg01:End() SIZE 100,10 PIXEL OF oDlg01
	nLin += 12
	@ nLin, nCol1 BUTTON oUltima   PROMPT "Cancelar ฺltima Etiqueta" ACTION CanImpBip() SIZE 100,10 PIXEL OF oDlg01
	nLin += 12
	@ nLin, nCol1 BUTTON oImprime  PROMPT "Fechar PALETE           " ACTION Processa( {|| If(VerImpBip(), ImpNivelP(),{ cEtiqueta := Space(_nTamEtiq),oEtiqueta:Refresh(), oEtiqueta:SetFocus() } ) } ) SIZE 100,10 PIXEL OF oDlg01

	oUltima:Disable()

	ACTIVATE MSDIALOG oDlg01

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

Static Function ValidaEtiq(lTeste)

	DEFAULT lTeste := .F.

	If !Empty(cEtiqueta)

		cEtiqueta:= alltrim(cEtiqueta)
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณPrepara n๚mero da etiqueta bipada							ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If Len(AllTrim(cEtiqueta))==12 //EAN 13 s/ dํgito verificador.
			cEtiqueta := "0"+cEtiqueta
			cEtiqueta := Subs(cEtiqueta,1,12)
		EndIf

		XD1->( dbSetOrder(1) )
		XD2->( dbSetOrder(2) )
		SB1->( dbSetOrder(1) )

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณPosiciona na etiqueta bipada									ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If !XD1->( dbSeek( xFilial("XD1") + cEtiqueta ) )
			U_MsgColetor("Etiqueta nใo encontrada.")
			cEtiqueta := Space(_nTamEtiq)
			oEtiqueta:Refresh()
			oEtiqueta:SetFocus()
			Return (.f.)
		Else

			If aScan(aPalBip,{ |aVet| aVet[1] == cEtiqueta }) == 0

				oUltima:Disable()
				XD2->(dbSetOrder(2))
				If XD2->(dbSeek(xFilial("XD2")+cEtiqueta))
					aAreaXD1 := XD1->(GetArea())
					If XD1->(dbSeek(xFilial("XD1")+XD2->XD2_XXPECA))
						If XD1->XD1_NIVEMB == 'P'
							U_MsgColetor("Esse volume jแ foi paletizado na etiqueta No. "+XD2->XD2_XXPECA+".")
							RestArea(aAreaXD1)
							cEtiqueta := Space(_nTamEtiq)
							oEtiqueta:Refresh()
							oEtiqueta:SetFocus()
							Return (.f.)
						EndIf
					Else
						U_MsgColetor("Etiqueta do Palete nใo encontrada no XD1.")
						RestArea(aAreaXD1)
						cEtiqueta := Space(_nTamEtiq)
						oEtiqueta:Refresh()
						oEtiqueta:SetFocus()
						Return (.f.)
					EndIf
					RestArea(aAreaXD1)
				EndIf

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณVerifica pedido													ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				cAliasSC6 := GetNextAlias()
				If !Empty(XD1->XD1_PVSENF)
					cWhereSC6 := "%C6_NUMOP='"+SubStr(XD1->XD1_PVSENF,1,6)+"' AND C6_ITEMOP='"+SubStr(XD1->XD1_PVSENF,7,2)+"' AND C6_PRODUTO='"+XD1->XD1_COD+"'%"
				Else
					cWhereSC6 := "%C6_NUMOP='"+SubStr(XD1->XD1_OP,1,6)+"' AND C6_ITEMOP='"+SubStr(XD1->XD1_OP,7,2)+"' AND C6_PRODUTO='"+XD1->XD1_COD+"'%"
				EndIf

				BEGINSQL Alias cAliasSC6
				SELECT C6_NUM, C6_ITEM, C6_PRODUTO FROM %Table:SC6% SC6 (NOLOCK) WHERE %Exp:cWhereSC6% AND SC6.%NotDel%
				ENDSQL

				SC6->(dbSetOrder(1))
				If SC6->(dbSeek(xFilial()+(cAliasSC6)->C6_NUM+(cAliasSC6)->C6_ITEM+(cAliasSC6)->C6_PRODUTO))
					If !Empty(cNumPed)
						If ( (cAliasSC6)->C6_NUM <> cNumPed ) .And. !Empty(cNumPed)
							U_MsgColetor("Pedido diferente da coleta atual.")
							cEtiqueta := Space(_nTamEtiq)
							oEtiqueta:Refresh()
							oEtiqueta:SetFocus()
							(cAliasSC6)->(dbCloseArea())
							Return (.f.)
						EndIf
					EndIf
				Else
					U_MsgColetor("Pedido nใo encontrado.")
					cEtiqueta := Space(_nTamEtiq)
					oEtiqueta:Refresh()
					oEtiqueta:SetFocus()
					(cAliasSC6)->(dbCloseArea())
					Return (.f.)
				EndIf

				SC2->(dbSetOrder(1))
				SC2->(dbSeek(xFilial()+XD1->XD1_OP))
				cNumPed   := (cAliasSC6)->C6_NUM
				cItemC6	  := (cAliasSC6)->C6_ITEM
				(cAliasSC6)->(dbCloseArea())

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณVerifica se o Cliente ้ FURUKAWA						ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				SA1->(DbSetOrder(1))
				SA1->(dbSeek(xFilial("SA1")+SC2->C2_CLIENT))

				If ("FURUKAWA" $ Upper(SA1->A1_NOME)) .Or. ("FURUKAWA" $ Upper(SA1->A1_NREDUZ))
					lEhFuruka := .T.
				EndIf

				If ("CLARO" $ Upper(SA1->A1_NOME)) .Or. ("CLARO" $ Upper(SA1->A1_NREDUZ))
					lEhClaro := .T.
				EndIf

				SZY->(dbSetOrder(1))
				If !SZY->(dbSeek(xFilial("SZY")+cNumPed))
					U_MsgColetor("Pedido nใo encontrado na programa็ใo de faturamento.")
					cEtiqueta := Space(_nTamEtiq)
					oEtiqueta:Refresh()
					oEtiqueta:SetFocus()
					Return (.f.)
				Else
					lAchou := .F.
					Do While SZY->(!Eof()) .And. AllTrim(SZY->ZY_PEDIDO)==cNumPed
						If SZY->ZY_PRODUTO == XD1->XD1_COD
							lAchou := .T.
							Exit
						EndIf
						SZY->(dbSkip())
					EndDo
					If !lAchou
						U_MsgColetor("Produto nใo corresponde ao pedido.")
						cEtiqueta := Space(_nTamEtiq)
						oEtiqueta:Refresh()
						oEtiqueta:SetFocus()
						Return (.f.)
					EndIf
				EndIf

				nPlTotVol++
				nQtdCaixa += XD1->XD1_QTDORI
				oPlTotVol:Refresh()

				AADD(aPalBip, { cEtiqueta, cNumPed, XD1->XD1_QTDORI,cItemC6  } ) 

				oPalTot:Refresh()
				oSaldoVol:Refresh()
				cEtiqueta := Space(_nTamEtiq)
				oEtiqueta:Refresh()
				oEtiqueta:SetFocus()

			Else

				U_MsgColetor("Volume jแ coletado.")
				cEtiqueta := Space(_nTamEtiq)
				oEtiqueta:Refresh()
				oEtiqueta:SetFocus()
				Return (.f.)

			EndIf

		EndIf

	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVerImpBip บAutor  ณ Michel Sander      บ Data ณ    27/05/15 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida็ใo da impressใo da etiqueta                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VerImpBip()

	Local lRetBip := .T.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se o palete foi coletado							ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Len(aPalBip) == 0
		U_MsgColetor("Nใo foram coletadas caixas para impressใo de paletes")
		oUltima:Disable()
		cEtiqueta := Space(_nTamEtiq)
		oEtiqueta:Refresh()
		oEtiqueta:SetFocus()
		lRetBip := .F.
	EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณJanela para digita็ใo de peso									ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lPesoEmb
		CalPesPal(SC2->C2_PEDIDO,SC2->C2_PRODUTO)
		nPalTot++
		oPalTot:Refresh()
		lRetBip := .T.
	Else
		lRetBip := .F.
	EndIf

Return ( lRetBip )

Static Function ImpNivelP()

	LOCAL lRetEtq := .T.

	cProxNiv   := "P"
	__mv_par02 := AllTrim(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
	__mv_par03 := Nil
	__mv_par04 := Len(aPalBip)
	__mv_par05 := nQtdCaixa
	__mv_par06 := "92"
	cVolumeAtu := STRZERO(nPalTot,2)

	If lEhFuruka //.OR. lEhClaro
		lColetor   := .F.
	Else
		lColetor   := .T.
	EndIf


	If lEhFuruka
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณLAYOUT 94 - Etiqueta Nivel 3												   	ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		//lRotValid :=  U_DOMETQ92(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aPalBip,.F.,nPesoBruto,cVolumeAtu,lColetor) 			// Valida็๕es de Layout 92 - Palete
		cProxNiv   := "P"
		__mv_par02 := AllTrim(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
		__mv_par03 := Nil
		__mv_par04 := nQtdCaixa//Len(aPalBip)
		__mv_par05 := 1//nQtdCaixa
		__mv_par06 := "98"
		cVolumeAtu := STRZERO(nPalTot,2)
		cNumPedido := SC2->C2_PEDIDO
		//lRetEtq := U_DOMETQ98(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,NIL,nQEmbAtu,1,"1",aQtdBip,.T.,0,lUsaColet, "",cNumPeca)
		cRotina   := "U_DOMETQ98(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aPalBip,.T.,nPesoBruto,lColetor,cEtiqueta,'','PALETIZACAO','',cVolumeAtu,cNumPedido)"		// Impressใo de Etiqueta Layout 98 - Palete

	Else
		If lEhClaro
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณLAYOUT 90 - Etiqueta Nivel 3												   	ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			lRotValid :=  U_DOMET111(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aPalBip,.F.,nPesoBruto,cVolumeAtu,lColetor) 			// Valida็๕es de Layout 92 - Palete
			If !lRotValid
				U_MsgColetor("A etiqueta nใo serแ impressa. Verifique os problemas com o  layout da etiqueta e repita a opera็ใo.")
				Return ( .F. )
			Else
				cProxNiv   := "P"
				__mv_par02 := AllTrim(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
				__mv_par03 := Nil
				__mv_par04 := Len(aPalBip)
				__mv_par05 := nQtdCaixa
				__mv_par06 := "92"
				cVolumeAtu := STRZERO(nPalTot,2)
				cRotina   := "U_DOMET111(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aPalBip,.T.,nPesoBruto,cVolumeAtu,lColetor)"		// Impressใo de Etiqueta Layout 92 - Palete
			EndIf

		Else
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณLAYOUT 90 - Etiqueta Nivel 3												   	ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			lRotValid :=  U_DOMETQ92(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aPalBip,.F.,nPesoBruto,cVolumeAtu,lColetor) 			// Valida็๕es de Layout 92 - Palete
			If !lRotValid
				U_MsgColetor("A etiqueta nใo serแ impressa. Verifique os problemas com o  layout da etiqueta e repita a opera็ใo.")
				Return ( .F. )
			Else
				cProxNiv   := "P"
				__mv_par02 := AllTrim(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
				__mv_par03 := Nil
				__mv_par04 := Len(aPalBip)
				__mv_par05 := nQtdCaixa
				__mv_par06 := "92"
				cVolumeAtu := STRZERO(nPalTot,2)
				cRotina   := "U_DOMETQ92(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aPalBip,.T.,nPesoBruto,cVolumeAtu,lColetor)"		// Impressใo de Etiqueta Layout 92 - Palete
			EndIf
		EndIf
	EndIf
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณExecuta rotina de impressao									ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	lRetEtq := &(cRotina)		// suspensao temporaria da impressao at้ que se defina o layout nivel 3 em 29.10.2015
	lRetEtq := .T.
	aPalBip := {}
	nPlTotVol := 0
	nQtdCaixa := 0
	oPlTotVol:Refresh()
	cEtiqueta := Space(_nTamEtiq)
	oEtiqueta:Refresh()
	oEtiqueta:SetFocus()
	oUltima:Enable()

Return ( lRetEtq )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCanImpBip บAutor  ณ Michel Sander      บ Data ณ    27/05/15 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cancela Ultima etiqueta impressa                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CanImpBip()  // Tratado

	MsgInfo("Cancelamento de etiqueta desabilitado. Favor solicitar o estorno para a Lider de Produ็ใo.")

Return


	If Empty(cDomEtDl31_CancEtq)
		U_MsgColetor("Nใo existe etiqueta a ser cancelada.")
		oUltima:Disable()
	Else
		XD2->(dbSetOrder(1))
		If XD2->( dbSeek( xFilial() + cDomEtDl31_CancEtq ) )
			While !XD2->( EOF() ) .and. XD2->XD2_XXPECA == cDomEtDl31_CancEtq
				Reclock("XD2",.F.)
				XD2->( dbDelete() )
				XD2->( msUnlock() )
				XD2->( dbSeek( xFilial() + cDomEtDl31_CancEtq ) )
			End
		EndIf
		XD1->( dbSetOrder(1) )
		If XD1->( dbSeek( xFilial() + cDomEtDl31_CancEtq ) )
			Reclock("XD1",.F.)
			XD1->XD1_OCORRE := "5"
			XD1->( msUnlock() )
		EndIf
		U_MsgColetor("etiqueta cancelada.")
		oUltima:Disable()
	EndIf

	oEtiqueta:SetFocus()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CalPesPal  บAutor  ณMichel Sander     บ Data ณ  09/29/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela para digita็ใo do peso								        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CalPesPal(cPedPeso,cProdPeso)

	LOCAL nOpcPeso := 0

	Define MsDialog oTelaPeso Title OemToAnsi("Peso da Embalagem") From 20,20 To 180,200 Pixel of oMainWnd PIXEL
	nLin := 025
	@ nLin,005 Say oTxtPeso     Var "Peso" Pixel Of oTelaPeso
	@ nLin-2,025 MsGet oGetPeso Var nPesoBruto Valid nPesoBruto > 0 When .T. Picture "@E 99,999,999.9" Size 60,10 Pixel Of oTelaPeso
	oTxtPeso:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
	oGetPeso:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
	nLin+= 010
	@ nLin,025 Button oBotPeso PROMPT "Confirma" Size 35,15 Action {|| nOpcPeso:=1,oTelaPeso:End()} Pixel Of oTelaPeso
	Activate MsDialog oTelaPeso

	If nOpcPeso == 1
		lPesoEmb := .T.
	Else
		lPesoEmb := .F.
	EndIf

Return ( nPesoBruto )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AlertC    บAutor ณ Helio Ferreira     บ Data ณ    27/05/15 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela de Mensagem										              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
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

	cTemp += " Continuar?"

	While !apMsgNoYes( cTemp )
		lRet:=.F.
	End

Return(lRet)
