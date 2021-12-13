
#include "rwmake.ch"
#include "protheus.ch"
#include "parmtype.ch"
#include "tbiconn.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DesBlqPV  ºAutor  ³ Osmar Ferreira     º Data ³  16/12/21   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de liberação do Pedido de Venda quando bloqueado    º±±
±±º          ³ pela margem de contribuição.                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DesBlqPV(cNumPV)

	Local aAreaSC5 := SC5->( GetArea())
	Local aAreaSC6 := SC6->( GetArea())
	Local aAreaZZF := ZZF->( GetArea())
	Local oGetDados
	Local aHeader    := {}
	Local aCols      := {}
	Local nMarAprovada := 0
	Local lAprovado := .t.
	PRIVATE oFontNW

	AADD(aHeader,  {    "Item"        ,   "ITEM"   ,"@R" ,02,0,""            ,"","C","","","","",".F."})//01
	AADD(aHeader,  {    "Produto"     ,   "PROD"   ,"@R" ,15,0,""            ,"","C","","","","",".F."})//02
	AADD(aHeader,  {    "Descrição"   ,   "DESCI"  ,"@R" ,50,0,""            ,"","C","","","","",".F."})//03
	AADD(aHeader,  {    "Preço"       ,   "PRECO"  ,""   ,16,8,""            ,"","N","","","","",".F."})//04
	AADD(aHeader,  {    "Custo"       ,   "CUSTO"  ,""   ,16,8,""            ,"","N","","","","",".F."})//05
	AADD(aHeader,  {    "Preço Net"   ,   "PRNET"  ,""   ,16,8,""            ,"","N","","","","",".F."})//06
	AADD(aHeader,  {    "Margem"      ,   "MARGE"  ,""   ,10,2,""            ,"","N","","","","",".F."})//07
	AADD(aHeader,  {    "Margem Aprov",   "APROV"  ,""   ,10,2,""            ,"","N","","","","",".F."})//08

	If SC6->( dbSeek( xFilial() + cNumPV ) )
		While !SC6->( EOF() ) .and. SC6->C6_NUM == cNumPV	
			//Buscar no ZZF o valor da margem e status de aprovação
			If ZZF->( dbSeek(xFilial()+"BLQ"+SC6->C6_NUM+SC6->C6_ITEM))
				nMarAprovada := ZZF->ZZF_MARGEM
			Else
				nMarAprovada := 0
			EndIf		
			AADD(aCols,{SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->C6_DESCRI,SC6->C6_PRCVEN, SC6->C6_XCUSUNI,SC6->C6_XPRCNET,SC6->C6_XMARGEM,nMarAprovada,.F.})
			If SC6->C6_XANEXO == 'B'
			   lAprovado := .f.
			EndIf
			SC6->( dbSkip() )
		End
	Else
		AADD(aCols,{"","",.F.})
	EndIf

	DEFINE FONT oFontNW  NAME "Arial" SIZE 0,-15 BOLD

	Define MsDialog oDlg01 Title OemToAnsi("DESBLOQUEIO DO PEDIDO DE VENDA POR MARGEM DE LUCRO " + cNumPv) From 0,0 To 305,750 Pixel of oMainWnd PIXEL

	oGetDados  := (MsNewGetDados():New( 10, 09 , 130 ,370,GD_UPDATE+GD_DELETE ,"AlwaysTrue" ,"AlwaysTrue", /*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*"U_fFfieldok()"*/,/*superdel*/,/*delok*/,oDlg01,aHeader,aCols))
	If !lAprovado 
	   @ 135,175 Button "Aprovar"  Size 45,13 Action Aprovar(cNumPV)  Pixel
	Else
		MsgInfo("Pedido de Venda já Liberado", "Atenção")   
	EndIf   
	@ 135,325 Button "Sair"     Size 45,13 Action oDlg01:End()    Pixel

	Activate MsDialog oDlg01

	RestArea(aAreaZZF)
	RestArea(aAreaSC6)
	RestArea(aAreaSC5)

Return

Static Function Aprovar(cNumPV)

	If SC6->( dbSeek( xFilial() + cNumPV ) )
		While !SC6->( EOF() ) .and. SC6->C6_NUM == cNumPV
			RecLock("SC6",.f.)
			SC6->C6_XANEXO := 'A'
			SC6->( MsUnLock() )
			//Gravar para controle de desbloqueio de PV
			If ZZF->( dbSeek(xFilial()+"BLQ"+SC6->C6_NUM+SC6->C6_ITEM))
				RecLock("ZZF",.f.)
			Else
				RecLock("ZZF",.t.)
			EndIf
				ZZF->ZZF_FILIAL := xFilial("ZZF")
				ZZF->ZZF_ORIGEM	:= "BLQ"
				ZZF->ZZF_NUMERO	:= SC6->C6_NUM
				ZZF->ZZF_ITEM 	:= SC6->C6_ITEM
				ZZF->ZZF_COD    := SC6->C6_PRODUTO
				ZZF->ZZF_DATA   := dDataBase
				ZZF->ZZF_PRCVEN	:= SC6->C6_PRCVEN
				ZZF->ZZF_CUSUNI	:= SC6->C6_XCUSUNI
				ZZF->ZZF_STACUS	:= "A"
				ZZF->ZZF_PRCNET	:= SC6->C6_XPRCNET
				ZZF->ZZF_MARGEM := SC6->C6_XMARGEM
				ZZF->ZZF_OBS    := "BLQ - Margem"
				ZZF->ZZF_HORA   := Time()
				ZZF->( msUnLock() )
			SC6->( dbSkip() )
		End
	EndIf

Return




