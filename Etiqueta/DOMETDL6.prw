#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DOMETDL6 บAutor  ณ Michel Sander      บ Data ณ    26/12/17 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela de entrega de produtos a expedi็ใo					     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DOMETDL6()

Local lLoop     := .T.
Local lOk       := .F.
Local aPar      := {}
Local aRet      := {}
Local aLayout   := {}

Private oOk  		:= LoadBitmap(GetResources(), "BR_VERDE")
Private oNOk 		:= LoadBitmap(GetResources(), "BR_VERMELHO")
Private oChecked  := LoadBitMap(GetResources(), "LBTIK")
Private oNChecked := LoadBitMap(GetResources(), "LBNO")

Private _nTamEtiq   := 21
Private __mv_par01  := 1 			      // Pesquisar por OP ou Senf
Private __mv_par02  := Space(11) 		   // Numero OP
Private __mv_par03  := Space(09) 			// Senf + Item
Private __mv_par04  := 0         			// Qtd Embalagem
Private __mv_par05  := 0         			// Qtd Etiquetas
Private __mv_par06  := Space(02) 			// Layout da Etiqueta
Private cEtiqueta   := Space(_nTamEtiq)
Private cEmbAtu     := Space(60)
Private nQEmbAtu    := 0
Private cProxEmb    := SPACE(60)
Private nQProxEmb   := 0
Private nQtdBip     := 0
Private nQtdKit     := 0
Private nSldOp      := 0
Private aQtdBip     := {}
Private aQtdEtiq    := {}
Private cProxNiv    := ""
Private cNumOpBip   := SPACE(11)
Private cProdBip    := SPACE(15)
Private cVerUsoGr	  := ""
Private cDescBip    := SPACE(45)
Private cCliBip     := SPACE(06)
Private nQtdOpBip   := 0
Private nSaldoBip   := 0
Private cPedBip     := SPACE(06)
Private nPerdaBip   := 0.00
Private nPesoBip    := 0
Private nQtdPrev    := 0
Private dDataPrev   := CTOD("")
Private lRePrint    := .F.
Private bRePrint	  := { || fColar( aCopyTab,.T. ) }
Private lTelefonic  := .F.
Private lEricsson   := .F.
Private lComba      := .F.
Private cPedTel     := ""
Private cNumSerie   := ""
Private lUltTelef   := .F.
Private cOPAtu      := ""
Private cOPnSerie   := ""
Private aSerial     := {}
Private lSerial     := .F.
Private aCaixas     := {}
Private oList
Private nTotCaixas  := 0
Private nTotColeta  := 0
Private nResto      := 0
Private oGetCaixa
Private oGetColeta
Private oGetPrev
Private oGetQPrev
Private oGetResto
Private oGetSld
Private oSaldoBip

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPosi็ใo inicial da tela principal							ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nLin := 15
nCol1 := 10
nCol2 := 95
AADD(aCaixas, { .F., " ", Space(13), Space(15), Space(10), Space(10), 0, Space(1) })

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCabe็alho da OP													ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
lSair := .F.

Do While !lSair

	DEFINE MSDIALOG oDlg01 TITLE OemToAnsi("U_DOMETDL6() - Entrega แ Expedi็ใo") FROM 0,0 TO 600,1350 PIXEL of oMainWnd PIXEL //300,400 PIXEL of oMainWnd PIXEL
	
	@ nLin-13,nCol1-05  TO nLin+100,nCol1+495 LABEL " Informa็๕es da Ordem de Produ็ใo " OF oDlg01 PIXEL
	@ nLin-13,nCol1+500 TO nLin+280,nCol1+662 LABEL " Totalizador "							 OF oDlg01 PIXEL 	// Linha horizontal para separar bot๕es

	@ nLin, nCol1	SAY oTexto10 Var 'N๚mero da OP:'    SIZE 100,20 PIXEL
	oTexto10:oFont := TFont():New('Arial',,29,,.T.,,,,.T.,.F.)
	@ nLin-6, nCol2 MSGET oNumOPBip VAR cNumOpBip  SIZE 150,17 WHEN .F. PIXEL
	oNumOPBip:oFont := TFont():New('Courier New',,50,,.T.,,,,.T.,.F.)
	@ nLin-3, nCol2+155	SAY oTexto12 Var 'Quantidade:'    SIZE 80,20 PIXEL
	oTexto12:oFont := TFont():New('Arial',,30,,.T.,,,,.T.,.F.)
	@ nLin-6, nCol2+225 MSGET oQtdOPBip VAR nQtdOpBip  SIZE 60,17 WHEN .F. PIXEL
	oQtdOPBip:oFont := TFont():New('Courier New',,50,,.T.,,,,.T.,.F.)
	@ nLin-3, nCol2+287	SAY oTexto13 Var 'Prontas:'    SIZE 100,20 PIXEL
	oTexto13:oFont := TFont():New('Arial',,30,,.T.,,,,.T.,.F.)
	@ nLin-6, nCol2+340 MSGET oSaldoBip VAR nSaldoBip  SIZE 60,17 WHEN .F. PIXEL
	oSaldoBip:oFont := TFont():New('Courier New',,50,,.T.,,,,.T.,.F.)
	@ nLin,nCol1+510 SAY oTotCaixa Var "TOTAL DE CAIXAS" SIZE 100,10 PIXEL 
	nLin += 15
	                                 
	@ nLin,nCol1+510 MSGET oGetCaixa VAR nTotCaixas SIZE 140,30 WHEN .F. PIXEL
	oTotCaixa:oFont := TFont():New('Arial',,27,,.T.,,,,.T.,.F.)
	oGetCaixa:oFont := TFont():New('Arial',,70,,.T.,,,,.T.,.F.)

	@ nLin+5, nCol1	SAY oTexto10 Var 'Produto:'    SIZE 100,25 PIXEL
	oTexto10:oFont := TFont():New('Arial',,40,,.T.,,,,.T.,.F.)
	@ nLin, nCol2 MSGET oProduto VAR cProdBip  SIZE 200,23 WHEN .F. PIXEL
	oProduto:oFont := TFont():New('Courier New',,50,,.T.,,,,.T.,.F.)
	@ nLin+5, nCol2+230	SAY oTexto14 Var 'Pedido:'    SIZE 100,25 PIXEL
	oTexto14:oFont := TFont():New('Arial',,40,,.T.,,,,.T.,.F.)
	
	@ nLin, nCol2+300 MSGET oPedido VAR cPedBip  SIZE 100,23 WHEN .F. PIXEL
	oPedido:oFont := TFont():New('Courier New',,50,,.T.,,,,.T.,.F.)
	nLin += 15                                       

	@ nLin+12, nCol2 MSGET oDescricao VAR cDescBip  SIZE 400,22 WHEN .F. PIXEL
	oDescricao:oFont := TFont():New('Courier New',,50,,.T.,,,,.T.,.F.)
	nLin += 15                    
	                                                  
	@ nLin+25, nCol1	SAY oTexto11 Var 'Cliente:'    SIZE 100,25 PIXEL
	oTexto11:oFont := TFont():New('Arial',,40,,.T.,,,,.T.,.F.)
	@ nLin+23, nCol2 MSGET oCliente VAR cCliBip  SIZE 400,25 WHEN .F. PIXEL
	oCliente:oFont := TFont():New('Courier New',,50,,.T.,,,,.T.,.F.)
	
	@ nLin+10, nCol1+510 SAY oTotColeta Var "TOTAL COLETADO" SIZE 100,10 PIXEL
	@ nLin+25, nCol1+510 MSGET oGetColeta VAR nTotColeta SIZE 140,30 WHEN .F. PIXEL
	oTotColeta:oFont := TFont():New('Arial',,27,,.T.,,,,.T.,.F.)
	oGetColeta:oFont := TFont():New('Arial',,70,,.T.,,,,.T.,.F.)

	@ nLin+65, nCol1+510 SAY oTotResto Var "RESTAM" SIZE 100,10 PIXEL
	@ nLin+80, nCol1+510 MSGET oGetResto VAR nResto SIZE 140,30 WHEN .F. COLOR CLR_RED PIXEL
	oTotResto:oFont := TFont():New('Arial',,27,,.T.,,,,.T.,.F.)
	oGetResto:oFont := TFont():New('Arial',,70,,.T.,,,,.T.,.F.)
	
	@ nLin+120, nCol1+510 SAY oTotSld Var "SALDO DA OP" SIZE 100,10 PIXEL
	@ nLin+135, nCol1+510 MSGET oGetSld VAR nSldOp SIZE 140,30 WHEN .F. COLOR CLR_RED PIXEL
	oTotSld:oFont := TFont():New('Arial',,27,,.T.,,,,.T.,.F.)
	oGetSld:oFont := TFont():New('Arial',,70,,.T.,,,,.T.,.F.)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณValidador da coleta												ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	@ nLin+127,nCol1+550 SAY oTotOK  Var "OK" SIZE 100,50 COLOR CLR_RED PIXEL
	oTotOK:oFont := TFont():New('Arial',,100,,.T.,,,,.T.,.F.)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ      ######### Leitura da Etiqueta	#############		ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nLin += 60
	@ nLin-02, nCol1-05 TO  nLin+40,nCol1+495 LABEL " C๓digo de Barras "  OF oDlg01 PIXEL
	@ nLin+15, nCol1	  SAY oTexto1 Var 'Etiqueta:'    SIZE 100,30 PIXEL
	oTexto1:oFont := TFont():New('Arial',,35,,.T.,,,,.T.,.F.)    

	@ nLin+08, nCol2 MSGET oEtiqueta VAR cEtiqueta  SIZE 250,25 WHEN .T. Valid ValidaEtiq() PIXEL
	oEtiqueta:oFont := TFont():New('Courier New',,50,,.T.,,,,.T.,.F.)
	
   nLin -= 10
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ BROWSE para as caixas disponํveis                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
	oList := TWBrowse():New( nLin+55, nCol1-05, nLin+392, nCol1+120,,{ " ", " ", "Etiqueta", "Produto", "Lote", "Dt. Fabrica็ใo", "Quantidade", "Nivel" },,oDlg01,,,,,,,,,,,,.F.,,.T.,,.F.,,,)//##"Empresa"//##"Empresa"
	oList:SetArray(aCaixas)
	oList:bLine      := { || { If( !aCaixas[oList:nAT,1], oOk, oNOK ), oNOK, aCaixas[oList:nAt,3], aCaixas[oList:nAT,4], aCaixas[oList:nAT,5], aCaixas[oList:nAT,6], aCaixas[oList:nAT,7], aCaixas[oList:nAT,8] } }
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณInforma็๕es da Embalagem										ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nLin += 165
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณBot๕es de controle												ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	@ nLin-35, nCol1+510 BUTTON oEntregar PROMPT "Entregar Material" ACTION Processa( {|| If(nTotColeta > 0, fAtuExp(), .T.), oDlg01:End() } ) SIZE 140,25 PIXEL OF oDlg01
	@ nLin-08, nCol1+510 BUTTON oSair     PROMPT "Sair"              ACTION Processa( {|| lSair := .T., oDlg01:End() } ) SIZE 140,25 PIXEL OF oDlg01

	oTotOk:Hide()
	                       
	ACTIVATE MSDIALOG oDlg01 CENTER

	nLin      := 15
	nCol1     := 10
	nCol2     := 95
	aCaixas   := {}
	AADD(aCaixas, { .F., " ", Space(13), Space(15), Space(10), Space(10), 0, Space(1) })
	 
EndDo
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ValidaEtiq บAutorณ Michel A. Sander     บ Data ณ    27/05/15 บฑฑ
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

Private cEtiqOrig := cEtiqueta

DEFAULT lTeste := .F.

lSerial := .F.

If !Empty(cEtiqueta)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPrepara n๚mero da etiqueta bipada							ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Len(AllTrim(cEtiqueta)) == 12 //EAN 13 s/ dํgito verificador.
		
		If UPPER(Subs(cEtiqOrig,1,1)) <> 'S'
			nItOP     := StrZero(Val(SubStr(cEtiqOrig,8,1)),3)
			cOPnSerie := PADR(SubsTr(cEtiqOrig,1,5),6)+SubsTr(cEtiqOrig,6,2)+nItOP
		Else
			cOPnSerie := Subs(cEtiqOrig,2,11)
		EndIf
		
		If SC2->(dbSeek(xFilial("SC2")+cOPnSerie))
		    If SC2->C2_EMISSAO >= StoD('20170101')
			   lSerial := .T.
			Else
			   cEtiqueta := "0"+cEtiqueta
			   cEtiqueta := Subs(cEtiqueta,1,12)
			   lSerial   := .F.
			EndIf
		Else
			cEtiqueta := "0"+cEtiqueta
			cEtiqueta := Subs(cEtiqueta,1,12)
			lSerial   := .F.
		EndIf
	
	Else

   	MsgAlert("N๚mero de Etiqueta Invแlida.")
		cEtiqueta := Space(_nTamEtiq)
		oEtiqueta:Refresh()
		oEtiqueta:SetFocus()
		Return (.f.)
   	
	EndIf
	
	XD1->( dbSetOrder(1) )
	XD2->( dbSetOrder(2) )
	SB1->( dbSetOrder(1) )
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPosiciona na etiqueta bipada							ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If XD1->( dbSeek( xFilial("XD1") + cEtiqueta ) ) .and. !lSerial 
		
      If XD1->XD1_OCORRE == "5"
         MsgAlert("Etiqueta cancelada.")
			cEtiqueta := Space(_nTamEtiq)
			oEtiqueta:Refresh()
			oEtiqueta:SetFocus()
			Return (.f.)
      ElseIf XD1->XD1_OCORRE == "4"           	
         lEntregues := MsgYesNo("Embalagem jแ entregue a expedi็ใo. Deseja visualizar as entregas dessa OP?")
         If lEntregues
            fColetadas()
		      oGetCaixa:Refresh()
				oSaldoBip:Refresh()
				cEtiqueta := Space(_nTamEtiq)
				oEtiqueta:Refresh()
				oEtiqueta:SetFocus()
				Return (.f.)
			Else            
				cEtiqueta := Space(_nTamEtiq)
				oEtiqueta:Refresh()
				oEtiqueta:SetFocus()
				Return (.f.)
			EndIf
      EndIf
      
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณPosiciona na OP da etiqueta bipada					ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If Empty(cNumOpBip)
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณVerifica status da OP								ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			cNumOpBip := XD1->XD1_OP
			oNumOpBip:Refresh()
			
			SC2->(dbSeek(xFilial("SC2")+cNumOpBip))
			SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
			SA1->(dbSeek(xFilial("SA1")+SC2->C2_CLIENT))

			cProdBip  := SB1->B1_COD
			cDescBip  := SB1->B1_DESC 
			cCliBip   := SA1->A1_NOME
			cVerUsoGr := SB1->B1_GRUPO
			nQtdOpBip := SC2->C2_QUANT
			cPedBip   := SC2->C2_PEDIDO
			nSldOp    := (SC2->C2_QUANT - SC2->C2_QUJE)
			
			oCliente:Refresh()
			oProduto:Refresh()
			oDescricao:Refresh()
			oQtdOpBip:Refresh()
			oPedido:Refresh()
         oGetSld:Refresh()
         
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณBusca as caixas da OP											ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			fMontaExp()      
			nTotCaixas := fValEnvEx()		
			nSaldoBip  := nTotCaixas
	      oGetCaixa:Refresh()
			oSaldoBip:Refresh()
							
		Else
			
			If SC2->(dbSeek(xFilial("SC2")+XD1->XD1_OP))
				If (SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN) <> cNumOpBip
					lCont := MsgNoYes("Esse produto pertence a outra Ordem de Produ็ใo."+CHR(13)+"Deseja continuar?")
					If !lCont
						SC2->(dbSeek(xFilial("SC2")+cNumOpBip))
						cNumOpBip := (SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
						oNumOpBip:Refresh()
						cEtiqueta := Space(_nTamEtiq)
						oEtiqueta:Refresh()
						oEtiqueta:SetFocus()
						Return (.f.)
					Else
						cNumOpBip := XD1->XD1_OP

						SC2->(dbSeek(xFilial("SC2")+cNumOpBip))
						SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
						SA1->(dbSeek(xFilial("SA1")+SC2->C2_CLIENT))
						
						cProdBip  := SB1->B1_COD
						cDescBip  := SB1->B1_DESC
						cVerUsoGr := SB1->B1_GRUPO
						cCliBip   := SA1->A1_NOME
						nQtdOpBip := SC2->C2_QUANT
						cPedBip   := SC2->C2_PEDIDO
						nSldOp    := (SC2->C2_QUANT - SC2->C2_QUJE)
						nResto    := 0
						aQtdBip   := {}
						aQtdEtiq  := {}
						nQtdBip   := 0
						nQtdKit   := 0
						nQProxEmb := 0
						cProxEmb  := SPACE(60)
						cEmbAtu	 := SPACE(60)
						oGetResto:Refresh()
						oCliente:Refresh()
						oProduto:Refresh()
						oDescricao:Refresh()
						oQtdOpBip:Refresh()
						oPedido:Refresh()
						oNumOpBip:Refresh()
						oGetSld:Refresh()
						
						//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
						//ณBusca as caixas da OP											ณ
						//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
						fMontaExp()      
						nTotCaixas := fValEnvEx()		
						nSaldoBip  := nTotCaixas
				      oGetCaixa:Refresh()
						oSaldoBip:Refresh()

					EndIf
				EndIf
			EndIf
		EndIf
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAtualiza etiqueta bipada										ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If aScan(aQtdBip,cEtiqueta) == 0
			AADD(aQtdBip ,cEtiqueta)
			AADD(aQtdEtiq,XD1->XD1_QTDATU)
			nTotColeta += 1
			nResto     := nSaldoBip - 1
			oGetResto:Refresh()
			fAtuColeta( cEtiqueta )
		EndIf

		cEtiqueta   := Space(_nTamEtiq)
		oEtiqueta:Refresh()
		oEtiqueta:SetFocus()
	
      If nTotColeta == nTotCaixas
      
			nResto := 0
			oGetResto:Refresh()

         oTotOk:Show()
         oTotOk:Refresh()
		   
		EndIf
			
	EndIf
	
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fEnvExped บAutor ณ Michel A. Sander     บ Data ณ    27/05/15 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para envio de material para expedicao               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fEnvExped()

Private _cNumOpBip := Space(12)
Private _nQtdOpBip := 0

DEFINE MSDIALOG oDlg02 TITLE OemToAnsi("Envio de material para expedi็ใo") FROM 0,0 TO 150,390 PIXEL of oMainWnd PIXEL

@ 12, 10	SAY _oTexto10 Var 'N๚mero da OP:'    SIZE 100,10 PIXEL
_oTexto10:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

@ 10, 75 MSGET _oNumOPBip VAR _cNumOpBip  SIZE 80,12 Valid fValEnvEx() WHEN .T. PIXEL
_oNumOPBip:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)

@ 32, 10	SAY _oTexto12 Var 'Quantidade:'    SIZE 100,10 PIXEL
_oTexto12:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

@ 30, 75 MSGET _oQtdOPBip VAR _nQtdOpBip  Picture "999,999" SIZE 50,12 Valid fValQtd() WHEN .T. PIXEL
_oQtdOPBip:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)

@ 50, 125 BUTTON _oCancelar PROMPT "Cancelar" ACTION Processa( {|| oDlg02:End() } ) SIZE 60,15 PIXEL OF oDlg02

ACTIVATE MSDIALOG oDlg02 CENTER

oEtiqueta:SetFocus()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fValEnvEx บAutor ณ Michel A. Sander     บ Data ณ    27/05/15 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Contagem do n๚mero de caixas para expedi็ใo                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fValEnvEx()

Local nCxaPronta := 0
Local cNivEmb 	  := IIF(cVerUsoGr $ "DROP/PCON","1","2")
cQuery := "SELECT COUNT(*) CONTAGEM FROM " + RetSqlName("XD1") + " (NOLOCK) WHERE XD1_OP = '"+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+"' AND XD1_NIVEMB = '" + cNivEmb  + "' AND XD1_OCORRE = '6' AND D_E_L_E_T_ = '' "
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TEMP",.F.,.T.)
nCxaPronta := TEMP->CONTAGEM
TEMP->(dbCloseArea())

Return ( nCxaPronta )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fMontaExp บAutor ณ Michel A. Sander     บ Data ณ    27/05/15 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Preenche o browse com as caixas que serใo enviadas         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fMontaExp()

aCaixas := {}
cNivEmb 	  := IIF(cVerUsoGr $ "DROP/PCON","1","2")
cQuery := "SELECT * FROM " + RetSqlName("XD1") + " (NOLOCK) WHERE XD1_OP = '"+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+"' AND XD1_NIVEMB = '"  + cNivEmb + "' AND XD1_OCORRE = '6' AND D_E_L_E_T_ = '' "
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TEMP",.F.,.T.)
Do While TEMP->(!Eof())
   Aadd(aCaixas, { .T., oNChecked, TEMP->XD1_XXPECA, TEMP->XD1_COD, TEMP->XD1_LOTECT, TEMP->XD1_DTDIGI, TEMP->XD1_QTDATU, TEMP->XD1_NIVEMB } )
   TEMP->(dbSkip())
EndDo                
If Len(aCaixas) == 0
   MsgAlert("Nใo foi encontradas embalagens disponํveis para expedi็ใo.")
   TEMP->(dbCloseArea())
   REturn
Endif
TEMP->(dbCloseArea())
oList:SetArray(aCaixas)
oList:bLine := { || { If( aCaixas[oList:nAT,1], oOk, oNOK ), aCaixas[oList:nAt,2], aCaixas[oList:nAt,3], aCaixas[oList:nAT,4], aCaixas[oList:nAT,5], aCaixas[oList:nAT,6], aCaixas[oList:nAT,7], aCaixas[oList:nAT,8] } }
oList:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfColetadasบAutor ณ Michel A. Sander    บ Data ณ    27/05/15 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Preenche o browse com as caixas que jแ foram coletadas     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fColetadas()

If Empty(XD1->XD1_OP)
   MsgAlert("N๚mero de OP nใo encontrada nessa etiqueta.")
   REturn( .F. )
EndIf

SC2->(dbSeek(xFilial("SC2")+XD1->XD1_OP))
SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
SA1->(dbSeek(xFilial("SA1")+SC2->C2_CLIENT))

nSldOp     := (SC2->C2_QUANT - SC2->C2_QUJE)
cProdBip   := SB1->B1_COD
cDescBip   := SB1->B1_DESC
cCliBip    := SA1->A1_NOME
nQtdOpBip  := SC2->C2_QUANT
cPedBip    := SC2->C2_PEDIDO       
cVerUsoGr  := SB1->B1_GRUPO
cNivEmb 	:= IIF(cVerUsoGr $ "DROP/PCON","1","2")
nTotColeta := 0
nResto     := 0
nTotCaixas := 0
aCaixas    := {}
cQuery := "SELECT * FROM " + RetSqlName("XD1") + " (NOLOCK) WHERE XD1_OP = '"+XD1->XD1_OP+"' AND XD1_NIVEMB = '" + cNivEmb + "' AND XD1_OCORRE <> '5' AND D_E_L_E_T_ = '' "
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TEMP",.F.,.T.)
TEMP->(dbEval({||nTotCaixas++}))
TEMP->(dbGotop())
nSaldoBip := nTotCaixas

Do While TEMP->(!Eof())

   Aadd(aCaixas, { If(TEMP->XD1_OCORRE=='4',.T.,.F.),;
   					 If(TEMP->XD1_OCORRE=='4',oChecked,oNChecked),;
   					 TEMP->XD1_XXPECA,;
   					 TEMP->XD1_COD,;
   					 TEMP->XD1_LOTECT,;
   					 TEMP->XD1_DTDIGI,;
   					 TEMP->XD1_QTDATU,;
   					 TEMP->XD1_NIVEMB } )          

   If TEMP->XD1_OCORRE=='6'
		nResto += 1 
   ElseIf TEMP->XD1_OCORRE=='4'
      nTotColeta += 1
	EndIf

   TEMP->(dbSkip())                        

EndDo                

If Len(aCaixas) == 0
   MsgAlert("Nใo foi encontradas embalagens disponํveis para expedi็ใo.")
   TEMP->(dbCloseArea())
   REturn
Endif

oCliente:Refresh()
oProduto:Refresh()
oDescricao:Refresh()
oQtdOpBip:Refresh()
oSaldoBip:Refresh()
oPedido:Refresh()
oGetColeta:Refresh()
oGetResto:Refresh()
oGetCaixa:Refresh()
oGetSld:Refresh()
TEMP->(dbCloseArea())
oList:SetArray(aCaixas)
oList:bLine := { || { If( aCaixas[oList:nAT,1], oOk, oNOK ), aCaixas[oList:nAt,2], aCaixas[oList:nAt,3], aCaixas[oList:nAT,4], aCaixas[oList:nAT,5], aCaixas[oList:nAT,6], aCaixas[oList:nAT,7], aCaixas[oList:nAT,8] } }
oList:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fAtuColetaบAutor ณ Michel A. Sander     บ Data ณ    27/05/15 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza a caixa coletada no browse					           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fAtuColeta ( cEtqColeta )

Local _nPosEtq := aScan(aCaixas,{|x| AllTrim(x[3]) == cEtqColeta})

If _nPosEtq > 0
   oList:nAt := _nPosEtq
   aCaixas[oList:nAt,2] := oChecked
   aCaixas[oList:nAt,1] := .F.
	oList:SetArray(aCaixas)
	oList:bLine := { || { If( aCaixas[oList:nAT,1], oOk, oNOK ), aCaixas[oList:nAt,2], aCaixas[oList:nAt,3], aCaixas[oList:nAT,4], aCaixas[oList:nAT,5], aCaixas[oList:nAT,6], aCaixas[oList:nAT,7], aCaixas[oList:nAT,8] } }
   oList:nRowPos := _nPosEtq
	oList:Refresh()
EndIf
   
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fAtuExp  บAutor ณ Michel A. Sander     บ Data ณ    27/05/15 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia os materiais para a expedi็ใo					           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fAtuExp()

nAviso := Aviso("Aten็ใo","Deseja enviar "+Transform(nTotColeta,"@E999999")+" caixas para expedi็ใo?",{"Sim","Nใo"})

If nAviso == 1

   XD1->(dbSetOrder(1))
   
   For nQ := 1 To Len(aCaixas)
       
       If aCaixas[nQ,1]
    		 Loop
   	 EndIf
       
       If XD1->(dbSeek(xFilial()+aCaixas[nQ,3]))
			 Reclock("XD1",.F.)
			 XD1->XD1_OCORRE := "4"
			 XD1->( msUnlock() )
		 End

	Next
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณLimpa a tela														ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cProdBip   := SPACE(15)
	cDescBip   := SPACE(45)
	cCliBip    := SPACE(45)
	cProxEmb   := SPACE(60)
	cEmbAtu	  := SPACE(60)
	cPedBip    := SPACE(06)
	cEtiqueta  := Space(_nTamEtiq)
	aQtdBip    := {}
	aQtdEtiq   := {}
	nQtdBip    := 0
	nQtdKit    := 0
	nQProxEmb  := 0
	nTotCaixas := 0
	nTotColeta := 0
	nSaldoBip  := 0
	nQtdOpBip  := 0
	nResto     := 0
	oGetResto:Refresh()
	oCliente:Refresh()
	oProduto:Refresh()
	oDescricao:Refresh()
	oQtdOpBip:Refresh()
	oPedido:Refresh()
   oGetCaixa:Refresh()
	oSaldoBip:Refresh()
	oEtiqueta:Refresh()
	oEtiqueta:SetFocus()
	
EndIf

Return
