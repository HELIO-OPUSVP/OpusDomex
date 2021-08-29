#include 'rwmake.ch'
#include 'protheus.ch'
#include 'topconn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EtiSGP01  ºAutor  ³Osmar Ferreira      º Data ³  29/12/21   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cadastro de etiquetas SGP para validação 					  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function EtiSGP01(vC5_NUM)
	Local cTitulo := "Pedido de Venda - Etiquetas SGP"
	Local aAreaGeral := GetArea()
	Local aAreaSC5   := SC5->( GetArea() )
	Local aAreaSA1   := SA1->( GetArea() )
	Local aAreaSC6   := SC6->( GetArea() )
	Local aAreaZZP   := ZZP->( GetArea() )
	Local aAreaXD5   := XD5->( GetArea() )

	Private nTotalizador := 0
	Private oPedido, oItem, oEtiqueta

	Private oCombobox := TComboBox():New()

	//Private cItem    := Space(2)
	Private cItem    := '01'

	Private cPedido  := Space(6)
	Private cCliente := Space(50)
	Private cEtiqueta := Space(16)


	Private aItens := {}

	Private aHeadPed := {}
	Private aColsPed := {}

	SC5->(dbSetOrder(1))
	SC5->(dbSeek(xFilial()+vC5_NUM))
	cPedido := SC5->C5_NUM
	U_fRetCliente()

	AADD(aHeadPed,   { "Pedido"      ,   "C_PED"    ,""                         ,06,0,""  ,"","C","","","","",".F"}) //01
	AADD(aHeadPed,   { "Item"        ,   "C_ITEM"   ,""                         ,02,0,""  ,"","C","","","","",".F"}) //01
	AADD(aHeadPed,   { "Etiqueta"    ,   "C_ETI"    ,""                         ,13,0,""  ,"","C","","","","",".F."})//02


//DEFINE MSDIALOG oEtq00 TITLE cTitulo FROM -017, 000  TO 530, 1295 COLORS 0, 16777215 PIXEL
	DEFINE MSDIALOG oEtq00 TITLE cTitulo FROM -017, 000  TO 530, 695 COLORS 0, 16777215 PIXEL
	DEFINE FONT oFnt1       NAME "Arial"                    Size 10,12 BOLD

	@ 001  ,010 GROUP oGroupA TO 023,340 PROMPT " PEDIDO DE VENDA  "  OF oEtq00 COLOR 0, 16777215 PIXEL
	@ 025  ,010 GROUP oGroupB TO 048,340 PROMPT " ITEM DO PEDIDO  "   OF oEtq00 COLOR 0, 16777215 PIXEL
	@ 050  ,010 GROUP oGroupB TO 073,340 PROMPT " ETIQUETA  "         OF oEtq00 COLOR 0, 16777215 PIXEL
	@ 076  ,248 GROUP oGroupB TO 098,340 PROMPT " TOTALIZADOR  "      OF oEtq00 COLOR 0, 16777215 PIXEL

	// 15/02/21 @ 008.5,015 MsGet oPedido Var cPedido  F3 "SC5" Valid(U_fRetCliente()) OF oEtq00 PIXEL SIZE 070,005 FONT oFnt1

	@ 008.5,015 Say oTexto1 PROMPT cPedido  Font oFnt1 OF oEtq00 COLOR 0, 16777215 PIXEL
	@ 011.5,103 Say oTexto1 PROMPT cCliente Font oFnt1 OF oEtq00 COLOR 0, 16777215 PIXEL

	// 15/02/21 @ 032.5,015 MsGet oItem   Var cItem Valid(U_fRetItem()) OF oEtq00 PIXEL SIZE 070,005 FONT oFnt1

	@ 032.5,015 MsComboBox oItem  Var  cItem items (@aItens := U_fAItens()) Valid(U_fRetItem()) OF oEtq00 PIXEL SIZE 070,005 FONT oFnt1

	@ 035.5,103 Say oTexto1 PROMPT SC6->C6_PRODUTO+" - "+ SC6->C6_DESCRI Font oFnt1 OF oEtq00 COLOR 0, 16777215 PIXEL

	@ 057.5,015 MsGet oEtiqueta  Var cEtiqueta Valid(U_fValEtiqueta())   OF oEtq00 PIXEL SIZE 070,005 FONT oFnt1

	@ 085.5,258 Say oTexto1 PROMPT StrZero(nTotalizador,4) Font oFnt1 OF oEtq00 COLOR 0, 16777215 PIXEL


	oGetPedido   := (MsNewGetDados():New( 085,020,260,200 ,/*GD_UPDATE*/ ,/*"U_FAT002LOK()"*/  ,/*REQ_OPSD3()*/,/*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*Ffieldok*/,/*superdel*/,/*delok*/,oEtq00,aHeadPed,aColsPed))
	oGetPedido:oBrowse:Refresh()

	@ 18,063 BUTTON "Excluir Etiqueta" 	SIZE 50,11 Action (lExec := .F.,U_fExclEtiq())
	@ 20,063 BUTTON "Excluir Todas" 	SIZE 50,11 Action (lExec := .F.,U_fExclAllEtiq())
	@ 23,063 BUTTON "Sair"   			SIZE 50,11 Action Close(oEtq00)

	ACTIVATE MSDIALOG oEtq00 CENTERED

	RestArea(aAreaXD5)
	RestArea(aAreaZZP)
	RestArea(aAreaSC6)
	RestArea(aAreaSA1)
	RestArea(aAreaSC5)
	RestArea(aAreaGeral)

Return()


User Function fRetCliente()
	Local lRet
	If !Empty(cPedido)
		SC5->(dbSetOrder(1))
		If SC5->(dbSeek(xFilial()+cPedido))
			SA1->(dbSetOrder(1))
			SA1->(dbSeek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
			cCliente := SA1->A1_NREDUZ

			@aItens := U_fAItens()

			lRet := .t.
		Else
			msgAlert("Pedido não cadastrado!")
			lRet := .f.
		EndIf
	Else
		lRet := .t. //Para não impedir de sair do formulário
	EndIf
Return(lRet)

User Function fRetItem()
	Local lRet

	If !Empty(cPedido) .And. !Empty(cItem)
		SC6->(dbSetOrder(1))
		If SC6->(dbSeek(xFilial()+cPedido+cItem))
			cItem := SC6->C6_ITEM
			lRet := .t.
			U_fDadosTab()
		Else
			msgAlert("Pedido / Item não cadastrados!")
			lRet := .f.
		EndIf
	Else
		lRet := .t. //Para não impedir de sair do formulário
	EndIf

Return(lRet)


User Function fDadosTab()
	nTotalizador := 0
	aColsPed := {}
	If !Empty(cPedido) .And. !Empty(cItem)
		nTotalizador := 0
		aColsPed := {}
		ZZP->(dbSetOrder(1))
		If ZZP->(dbSeek(xFilial()+cPedido+cItem))
			While ZZP->ZZP_PEDIDO == cPedido .And. ZZP->ZZP_ITEM == cItem  .And. ZZP->(!EOF())
				nTotalizador++
				AADD(aColsPed,{ZZP->ZZP_PEDIDO,ZZP->ZZP_ITEM,ZZP->ZZP_ETIQUE,.F.})
				ZZP->(dbSkip())
			EndDo
		EndIf
		oGetPedido:ACOLS:=aColsPed
		//oGetPedido:oBrowse:setfocus()
		oGetPedido:oBrowse:Refresh()
	EndIf
Return(.t.)

User Function fValEtiqueta()
	Local lRet := .t.
	//Verica se a etiqueta já foi impressa (existe no XD5)
	If !Empty(cEtiqueta)
		XD5->(dbSetOrder(1))
		If XD5->(dbSeek(xFilial()+AllTrim(cEtiqueta)))
			msgAlert("A etiqueta SGP número "+cEtiqueta+" já foi impressa!!!" +CHR(13)+CHR(13)+;
			 "Ordem de Produção..: "+XD5->XD5_NUMOP+CHR(13)+CHR(13)+;
			 "Nota Fiscal........: "+XD5->XD5_NOTA)
			cEtiqueta := Space(16)
			oEtiqueta:Refresh()
			lRet := .F.
		EndIf
	EndIf
	If lRet
		ZZP->(dbSetOrder(1))
		If ZZP->(dbSeek(xFilial()+cPedido+cItem+cEtiqueta))
			msgAlert("A Etiqueta "+cEtiqueta+ " já esta cadastrada para este Pedido / Item")
			cEtiqueta := Space(16)
			oEtiqueta:Refresh()
			lRet := .F.
		Else
			If !Empty(cEtiqueta)
				RecLock("ZZP",.T.)
				ZZP->ZZP_FILIAL := xFilial("ZZP")
				ZZP->ZZP_PEDIDO := cPedido
				ZZP->ZZP_ITEM   := cItem
				ZZP->ZZP_ETIQUE := cEtiqueta
				ZZP->ZZP_DATA   := dDataBase
				ZZP->(MsUnlock())
				U_fDadosTab()
			EndIf
			lRet := .T.
		EndIf
	EndIf

	If !Empty(cEtiqueta)
		oEtiqueta:setfocus()
	EndIf
	cEtiqueta := Space(16)
	//oEtiqueta:Refresh()
Return(lRet)

User Function fExclEtiq()
	Local nLin := oGetPedido:oBrowse:nAt

	If Len(aColsPed) > 0
		If MsgNoYes("Confirma a exclusão da Etiqueta "+AllTrim(aColsPed[nLin,3])+" ?")
			If ZZP->(dbSeek(xFilial()+aColsPed[nLin,1]+aColsPed[nLin,2]+aColsPed[nLin,3]))
				RecLock("ZZP",.F.)
				ZZP->(dbDelete())
				ZZP->(MsUnlock())
				U_fDadosTab()
			EndIf
		EndIf
	Else
		MsgAlert('Não ha etiqueta para este pedido!')
	EndIf

Return(.t.)

User Function fExclAllEtiq()
	Local nLin  := oGetPedido:oBrowse:nAt
	Local vPed
	Local vItem
	Local x

	If Len(aColsPed) > 0
		vPed  := aColsPed[nLin,1]
		vItem := +aColsPed[nLin,2]
		If MsgNoYes("Confirma a exclusão de todas as Etiqueta deste item: "+vPed+"/"+vItem+" ?")
			ZZP->(dbSetOrder(1))
			For x := 1 To Len(aColsPed)
				If ZZP->(dbSeek(xFilial()+aColsPed[x,1]+aColsPed[x,2]+aColsPed[x,3]))
					RecLock("ZZP",.F.)
					ZZP->(dbDelete())
					ZZP->(MsUnlock())
				EndIf
			Next
			U_fDadosTab()
		EndIf
	Else
		MsgAlert('Não ha etiqueta para este pedido!!')
	EndIf

Return(.t.)


//Carrega os itens 
User Function fAItens()
	SC6->(dbSetOrder(1))
	If SC6->(dbSeek(xFilial()+cPedido))
		@aItens := {}
		cItem := ''
		While SC6->C6_NUM == cPedido .And. SC6->(!Eof())
			aAdd(@aItens,SC6->C6_ITEM)
			SC6->(dbSkip())
		EndDo
	Else
		@aItens := {'01'}
	EndIf

Return(@aItens)

