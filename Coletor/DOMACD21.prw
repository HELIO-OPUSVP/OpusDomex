#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DOMACD21 ºAutor  ³ Michel Sander      º Data ³  09.06.2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Apontamento e impressão de etiquetas nivel 2 de DIO   	  º±±
±±º          ³ pelo coletor de dados                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMACD21()

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
Private cGrupoDIO   := ""
Private cEtiqueta   := Space(_nTamEtiq)
Private cEmbAtu     := Space(60)
Private nQEmbAtu    := 0
Private cProxEmb    := SPACE(60)
Private nQProxEmb   := 0
Private nQtdBip     := 0
Private nQtdKit     := 0
Private aQtdBip     := {}
Private aQtdEtiq    := {}
Private oQtdOPBip
Private oSaldoBip
Private cProxNiv    := ""
Private cNumOpBip   := SPACE(11)
Private cProdBip    := SPACE(15)
Private cDescBip    := SPACE(45)
Private cCliBip     := SPACE(06)
Private nQtdOpBip   := 0
Private nSaldoBip   := 0
Private cPedBip     := SPACE(06)
Private nPerdaBip   := 0.00
Private nPesoBip    := 0
Private lRePrint    := .F.
Private bRePrint	  := { || fColar( aCopyTab,.T. ) }
Private oEtiqueta
PRIVATE oDlg2

Public cDomEtDl31_CancEtq := ""
Public cDomEtDl32_CancOP  := ""
Public cDomEtDl33_CancEmb := ""
Public cDomEtDl34_CancKit := ""
Public cDomEtDl35_CancUni := 0
Public cDomEtDl36_CancLay := ""
Public cDomEtDl37_CancImp := .T.
Public cDomEtDl38_CancNiv := ""
Public cDomEtDl39_CancPes := 0
Public aDomEtDl3A_CancFil := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³F7 para Reimpressão de etiquetas								³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetKey( VK_F4 , bRePrint )
SetKey( VK_F8, { || fEnvExped() } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posição inicial da tela principal							³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLin := 15
nCol1 := 05
nCol2 := 95

If cUsuario == 'HELIO'
	_cNumEtqPA := Space(_nTamEtiq)
	cEtiqueta := '00001895031x   '
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cabeçalho da OP													³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlg01 TITLE OemToAnsi("Emissão de Etiquetas") FROM 0,0 TO 293,233 PIXEL of oMainWnd PIXEL //300,400 PIXEL of oMainWnd PIXEL

nLin := 005

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Leitura da Etiqueta												³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ nLin, nCol1	SAY oTexto1 Var 'Etiqueta:'    SIZE 100,10 PIXEL
oTexto1:oFont := TFont():New('Arial',,16,,.T.,,,,.T.,.F.)
@ nLin-2, nCol1+30 MSGET oEtiqueta VAR cEtiqueta  SIZE 75,08 WHEN .T. Valid ValidaEtiq() PIXEL
oEtiqueta:oFont := TFont():New('Courier New',,18,,.T.,,,,.T.,.F.)
nLin += 15

//@ nLin-10,nCol1-05 TO nLin+62,nCol1+387 LABEL " Informações da Ordem de Produção "  OF oDlg01 PIXEL
@ nLin, nCol1	SAY oTexto10 Var 'Número da OP:'    SIZE 100,10 PIXEL
oTexto10:oFont := TFont():New('Arial',,16,,.T.,,,,.T.,.F.)
@ nLin-2, nCol1+45 MSGET oNumOPBip VAR cNumOpBip  SIZE 60,08 WHEN .F. PIXEL
oNumOPBip:oFont := TFont():New('Courier New',,16,,.T.,,,,.T.,.F.)

nLin += 10
@ nLin, nCol1	SAY oTexto10 Var 'Produto:'    SIZE 100,10 PIXEL
oTexto10:oFont := TFont():New('Arial',,16,,.T.,,,,.T.,.F.)
@ nLin-2, nCol2+45 MSGET oProduto VAR cProdBip  SIZE 60,08 WHEN .F. PIXEL
oProduto:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)
@ nLin, nCol2+195	SAY oTexto14 Var 'Pedido:'    SIZE 100,10 PIXEL
oTexto14:oFont := TFont():New('Arial',,16,,.T.,,,,.T.,.F.)
@ nLin-2, nCol2+230 MSGET oPedido VAR cPedBip  SIZE 50,12 WHEN .F. PIXEL
oPedido:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)
@ nLin-2, nCol1+45 MSGET oDescricao VAR cProdBip  SIZE 60,08 WHEN .F. PIXEL
oDescricao:oFont := TFont():New('Courier New',,16,,.T.,,,,.T.,.F.)
nLin += 10

@ nLin, nCol1 SAY oTexto12 Var 'Quantidade:'   SIZE 100,10 PIXEL
oTexto12:oFont := TFont():New('Arial',,16,,.T.,,,,.T.,.F.)
@ nLin-2, nCol1+45 MSGET oQtdOPBip VAR nQtdOpBip  SIZE 60,08 WHEN .F. PIXEL
oQtdOPBip:oFont := TFont():New('Courier New',,16,,.T.,,,,.T.,.F.)
nLin += 10
@ nLin, nCol1 SAY oTexto13 Var 'Saldo:'    SIZE 100,10 PIXEL
oTexto13:oFont := TFont():New('Arial',,16,,.T.,,,,.T.,.F.)
@ nLin-2, nCol1+45 MSGET oSaldoBip VAR nSaldoBip  SIZE 60,08 WHEN .F. PIXEL
oSaldoBip:oFont := TFont():New('Courier New',,16,,.T.,,,,.T.,.F.)
nLin += 10
@ nLin, nCol1 SAY oTexto15 Var 'Perda:'    SIZE 100,10 PIXEL
oTexto15:oFont := TFont():New('Arial',,16,,.T.,,,,.T.,.F.)
@ nLin-2, nCol1+45 MSGET oPerda VAR nPerdaBip PICTURE "9999.99" SIZE 60,08 WHEN .F. PIXEL
oPerda:oFont := TFont():New('Courier New',,16,,.T.,,,,.T.,.F.)
nLin += 50

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Botões de controle												³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ nLin, nCol1 BUTTON oUltima   PROMPT "Entrega para a Expedição" ACTION fEnvExped() SIZE 100,10 PIXEL OF oDlg01
nLin += 12
@ nLin, nCol1 BUTTON oUltima   PROMPT "Cancelar Última Etiqueta" ACTION CanImpBip() SIZE 100,10 PIXEL OF oDlg01
nLin += 12
@ nLin, nCol1 BUTTON oImprime  PROMPT "Imprimir" ACTION Processa( {|| If(VerImpBip(), ImpEtqBip(),;
{ cEtiqueta := Space(_nTamEtiq),;
oEtiqueta:Refresh(), ;
oEtiqueta:SetFocus() } ) } ) SIZE 100,10 PIXEL OF oDlg01

@ nLin, nCol2+200 BUTTON oCancelar PROMPT "Cancelar" ACTION Processa( {|| oDlg01:End() } ) SIZE 100,20 PIXEL OF oDlg01
oUltima:Disable()
oImprime:Disable()

ACTIVATE MSDIALOG oDlg01

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ValidaEtiq ºAutor³ Helio Ferreira     º Data ³    27/05/15 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação da etiqueta bipada                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VerImpBip()

LOCAL __lOkBip := .T.

If !MsgNoYes("Esta embalagem já está separada para o pedido/item "+XD1->XD1_PVSEP)
	cEtiqueta := Space(_nTamEtiq)
	oEtiqueta:Refresh()
	oEtiqueta:SetFocus()
	__lOkBip := .F.
EndIf

Return (__lOkBip)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ValidaEtiq ºAutor³ Helio Ferreira     º Data ³    27/05/15 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação da etiqueta bipada                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValidaEtiq(lTeste)

DEFAULT lTeste := .F.

If !Empty(cEtiqueta)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Prepara número da etiqueta bipada							³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(AllTrim(cEtiqueta))==12 
		cEtiqueta := "0"+cEtiqueta
		cEtiqueta := Subs(cEtiqueta,1,12)
	EndIf
	
	XD1->( dbSetOrder(1) )
	XD2->( dbSetOrder(2) )
	SB1->( dbSetOrder(1) )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona na etiqueta bipada									³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If XD1->( dbSeek( xFilial("XD1") + cEtiqueta ) )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona na OP da etiqueta bipada							³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Empty(cNumOpBip)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica status da OP											³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cNumOpBip := XD1->XD1_OP
			oNumOpBip:Refresh()
			SC2->(dbSeek(xFilial("SC2")+cNumOpBip))
			If (SC2->C2_QUANT - SC2->C2_QUJE) <= 0
				U_MsgColetor("Ordem de produção já encerrada.")
				oImprime:Disable()
				cNumOpBip := SPACE(11)
				oNumOpBip:Refresh()
				cEtiqueta := Space(_nTamEtiq)
				oEtiqueta:Refresh()
				oEtiqueta:SetFocus()
				Return (.f.)
			EndIf
			
			SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
			SA1->(dbSeek(xFilial("SA1")+SC2->C2_CLIENT))
			cGrupoDIO := ALLTRIM(SB1->B1_GRUPO)
			cProdBip  := SB1->B1_COD
			cDescBip  := SB1->B1_DESC
			cCliBip   := SA1->A1_NOME
			nQtdOpBip := SC2->C2_QUANT
			cPedBip   := SC2->C2_PEDIDO
			nPerdaBip := U_ColetPerda(cNumOpBip,SC2->C2_PRODUTO)
			nSaldoBip := (SC2->C2_QUANT - SC2->C2_QUJE) - nPerdaBip
			oProduto:Refresh()
			oDescricao:Refresh()
			oQtdOpBip:Refresh()
			oSaldoBip:Refresh()
			oPedido:Refresh()
			oPerda:Refresh()
			
		Else
			
			If SC2->(dbSeek(xFilial("SC2")+XD1->XD1_OP))
				If (SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN) <> cNumOpBip
					If (SC2->C2_QUANT - SC2->C2_QUJE) <= 0
						U_MsgColetor("Ordem de produção já encerrada.")
						SC2->(dbSeek(xFilial("SC2")+cNumOpBip))
						oImprime:Disable()
						cNumOpBip := (SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
						oNumOpBip:Refresh()
						cEtiqueta := Space(_nTamEtiq)
						oEtiqueta:Refresh()
						oEtiqueta:SetFocus()
						Return (.f.)
					EndIf
					lCont := MsgNoYes("Esse produto pertence a outra Ordem de Produção.")
					//Cont := MsgNoYes("Esse produto pertence a outra Ordem de Produção."+CHR(13)+"Deseja continuar?")
					If !lCont
						SC2->(dbSeek(xFilial("SC2")+cNumOpBip))
						oImprime:Disable()
						cNumOpBip := (SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
						oNumOpBip:Refresh()
						cEtiqueta := Space(_nTamEtiq)
						oEtiqueta:Refresh()
						oEtiqueta:SetFocus()
						Return (.f.)
					Else
						cNumOpBip := XD1->XD1_OP
						oNumOpBip:Refresh()
						SC2->(dbSeek(xFilial("SC2")+cNumOpBip))
						SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
						SA1->(dbSeek(xFilial("SA1")+SC2->C2_CLIENT))
						cGrupoDIO := ALLTRIM(SB1->B1_GRUPO)
						cProdBip  := SB1->B1_COD
						cDescBip  := SB1->B1_DESC
						cCliBip   := SA1->A1_NOME
						nQtdOpBip := SC2->C2_QUANT
						cPedBip   := SC2->C2_PEDIDO
						nPerdaBip := U_ColetPerda(cNumOpBip,SC2->C2_PRODUTO)
						nSaldoBip := (SC2->C2_QUANT - SC2->C2_QUJE) - nPerdaBip
						cEtiqueta := Space(_nTamEtiq)
						aQtdBip   := {}
						aQtdEtiq  := {}
						nQtdBip   := 0
						nQtdKit   := 0
						nQProxEmb := 0
						cProxEmb  := SPACE(60)
						cEmbAtu	 := SPACE(60)
						nQEmbAtu  := 0
//						oQEmbAtu:Refresh()
//						oEmbAtu:Refresh()
//						oProxEmb:Refresh()
//						oQProxEmb:Refresh()
						oProduto:Refresh()
						oDescricao:Refresh()
						oQtdOpBip:Refresh()
						oSaldoBip:Refresh()
						oPedido:Refresh()
						oPerda:Refresh()
						oEtiqueta:Refresh()
						oEtiqueta:SetFocus()
						oImprime:Disable()
						Return (.F.)
					EndIf
				EndIf
			EndIf
		EndIf
		
		oUltima:Disable()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona na etiqueta bipada									³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		XD2->(dbSetOrder(2))
		If XD2->( dbSeek( xFilial("XD2") + cEtiqueta ) )
			U_MsgColetor("Etiqueta lida já pertence a outra embalagem: "+XD2->XD2_XXPECA)
			oImprime:Disable()
			cEtiqueta := Space(_nTamEtiq)
			oEtiqueta:Refresh()
			oEtiqueta:SetFocus()
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica nível de embalagem da etiqueta bipada			³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//If !Empty(XD1->XD1_EMBALA)
				
				//If SB1->( dbSeek( xFilial() + XD1->XD1_EMBALA ) )
					cEmbAtu    := ""//SB1->B1_DESC
					nQEmbAtu   := XD1->XD1_QTDEMB
					cNivEmb    := XD1->XD1_NIVEMB
					cProxNiv   := Soma1(cNivEmb)
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifica próxima embalagem										³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If SUBSTR(cGrupoDIO,1,3) <> "DIO" .And. SUBSTR(cGrupoDIO,1,4) <> "DIOE"
						//MsgStop("Rotina exclusiva para apontamento de DIOs")
						U_MsgColetor("Rotina exclusiva para apontamento de DIO.")
						oImprime:Disable()
						cEtiqueta := Space(_nTamEtiq)
						oEtiqueta:Refresh()
						oEtiqueta:SetFocus()
						Return (.f.)
					Else
						// DIO
						//_Retorno[1] := SG1->G1_COMP
						//_Retorno[2] := 1/SG1->G1_QUANT
						//_Retorno[3] := SG1->G1_XXEMBNI
						//_Retorno[4] := .T.     

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Verifica embalagem fora da estrutura						³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						//aRetAvulsa := U_RetAvulsa(XD1->XD1_COD,cProxNiv)        
						//If aRetAvulsa[2] > 0
						//   cProxEmb  := aRetAvulsa[1]
						//   nQProxEmb := aRetAvulsa[2]
						//Else
							aRetEmbala := {'',1,cProxNiv,.T.}
							cProxEmb  := SPACE(60)
							nQProxEmb := 1
						//EndIf
						
					EndIf
					
					
				//EndIf
				
			//Else
			//
			//	U_MsgColetor("Embalagem não encontrada para essa etiqueta.")
			//	oImprime:Disable()
			//	cEtiqueta := Space(_nTamEtiq)
			//	oEtiqueta:Refresh()
			//	oEtiqueta:SetFocus()
			//	Return ( .F. )
			//
			//EndIf
			
			If !SC2->(dbSeek(xFilial("SC2")+XD1->XD1_OP))
				U_MsgColetor("OP Invalida. Numero = "+XD1->XD1_OP)
				oImprime:Disable()
				cEtiqueta := Space(_nTamEtiq)
				oEtiqueta:Refresh()
				oEtiqueta:SetFocus()
				Return ( .F. )
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica pendências de perda									³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nQProxEmb >= (SC2->C2_QUANT - SC2->C2_QUJE)
				If nPerdaBip > 0
					U_MsgColetor("Ordem de Produção com perda em aberto. Separação não permitida.")
					oImprime:Disable()
					cEtiqueta := Space(_nTamEtiq)
					oEtiqueta:Refresh()
					oEtiqueta:SetFocus()
					Return (.f.)
				EndIf
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se quantidade da etiqueta é maior que OP		³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If XD1->XD1_QTDATU > (SC2->C2_QUANT - SC2->C2_QUJE)
				U_MsgColetor("Quantidade da etiqueta é maior que o saldo da OP.")
				oImprime:Disable()
				cEtiqueta := Space(_nTamEtiq)
				oEtiqueta:Refresh()
				oEtiqueta:SetFocus()
				Return (.f.)
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza etiqueta bipada										³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aScan(aQtdBip,cEtiqueta) == 0
				AADD(aQtdBip ,cEtiqueta)
				AADD(aQtdEtiq,XD1->XD1_QTDATU)
				
				nQtdBip := 0 // Len(aQtdBip)
				For _nX := 1 to Len(aQtdEtiq)
					nQtdBip += aQtdEtiq[_nX]
				Next _nX
				
				nQtdKit += XD1->XD1_QTDATU
				Reclock("XD1",.f.)
				XD1->XD1_OCORRE := "6"		// Etiqueta inválida. Precisa enviar para expedição para ir para 4
				XD1->( MsUnlock() )
			EndIf
			cEtiqueta   := Space(_nTamEtiq)
			oEtiqueta:Refresh()
			oEtiqueta:SetFocus()
			oImprime:Enable()
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Imprime etiqueta de PA caso quantidade seja atingida	³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nQtdBip == Round(nQProxEmb,0)
				oImprime:Disable()
				MsgRun("Apontamento de OP","Aguarde...",{|| ImpEtqBip() })
				aQtdBip  := {}
				aQtdEtiq := {}
				nQtdBip := 0
				nQtdKit := 0
				oUltima:Enable()
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Imprime etiqueta de PA caso quantidade seja igual ao saldo da OP   	³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If nQtdBip == (SC2->C2_QUANT - SC2->C2_QUJE)
					oImprime:Disable()
					MsgRun("Apontamento de OP","Aguarde...",{|| ImpEtqBip() })
					aQtdBip  := {}
					aQtdEtiq := {}
					nQtdBip  := 0
					nQtdKit  := 0
					oUltima:Enable()
				EndIf
			EndIf
			
		EndIf
		
	Else
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Valida etiqueta bipada											³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		U_MsgColetor("Etiqueta não encontrada.")
		oImprime:Disable()
		cEtiqueta   := Space(_nTamEtiq)
		oEtiqueta:SetFocus()
		
	EndIf
	
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ColetPerdaºAutor ³ Michel Sander	     º Data ³    27/05/15 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Soma as perdas por OP			                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ColetPerda(cNumOpBip,cProdBip)

LOCAL nPerdas := 0
SZA->(dbSetOrder(1))
SZE->(dbSetOrder(1))

If SZA->(dbSeek(xFilial("SZA")+cNumOpBip))
	Do While SZA->(!Eof()) .And. SZA->ZA_FILIAL+SZA->ZA_OP == xFilial("SZA")+cNumOpBip
		nPerdas += SZA->ZA_SALDO
		SZA->(dbSkip())
	EndDo
EndIf
If SZE->(dbSeek(xFilial("SZE")+cNumOpBip))
	Do While SZE->(!Eof()) .And. SZE->ZE_FILIAL+SZE->ZE_OP == xFilial("SZE")+cNumOpBip
		nPerdas += SZE->ZE_SALDO
		SZE->(dbSkip())
	EndDo
EndIf

Return ( nPerdas )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ IMPETQBIP ºAutor ³ Helio Ferreira     º Data ³    27/05/15 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime etiqueta de embalagem                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpEtqBip(lActionImp)

DEFAULT lActionImp := .F.

If XD1->( dbSeek( xFilial() + aQtdBip[1] ) )
	
	cGrupo  := Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_GRUPO")
	cCodCli := Posicione("SA1",1,xFilial("SA1")+SC2->C2_CLIENT,"A1_COD")
	cLojCli := Posicione("SA1",1,xFilial("SA1")+SC2->C2_CLIENT,"A1_LOJA")
	If !SZG->(dbSeek(xFilial("SZG")+cCodCli+cLojCli+cGrupo))
		//Aviso("Atenção","Não existe layout de etiqueta amarrado para esse Cliente x Grupo de produto.",{"Ok"})
		U_MsgColetor("Não existe layout de etiqueta amarrado para esse cliente x grupo de produto.")
		cTxtMsg  := " Não existe layout de etiqueta amarrado para esse Cliente x Grupo de produto." + Chr(13)
		cTxtMsg  += " Produto = " + SC2->C2_PRODUTO + Chr(13)
		cTxtMsg  += " Cliente = " + SC2->C2_CLIENT  + Chr(13)
		cAssunto := "Amarração Cliente x Grupo de Produto x Layout de Etiqueta"
		cTexto   := StrTran(cTxtMsg,Chr(13),"<br>")
		cPara    := 'denis.vieira@rdt.com.br;fabiana.santos@rdt.com.br;tatiane.alves@rosenbergerdomex.com.br;monique.garcia@rosenbergerdomex.com.br;daniel.cavalcante@rosenbergerdomex.com.br'
		cCC      := 'natalia.silva@rosenbergerdomex.com.br;keila.gamt@rosenbergerdomex.com.br;leonardo.andrade@rosenbergerdomex.com.br;gabriel.cenato@rosenbergerdomex.com.br;luiz.pavret@rdt.com.br' //chamado monique 015475
		cArquivo := Nil
		U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
		Return .T.
	EndIf
	
	__mv_par02 := XD1->XD1_OP
	__mv_par03 := Nil
	__mv_par04 := nQtdKit
	__mv_par05 := 1
	__mv_par06 := SZG->ZG_LAYOUT
	nPesoBip   := 0
	lColetor   := .T.

	Public _lColetor := .T.	
	Do Case
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³LAYOUT 01 - HUAWEI UNIFICADA												   	³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Case __mv_par06 == "01"
			lRotValid :=  U_DOMETQ04(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.F.,nPesoBip,lColetor,NIL,NIL) 			// Validações de Layout 01
			If !lRotValid
				U_MsgColetor("A OP não será apontada. Verifique os problemas com o layout da etiqueta e repita a operação.")
				Return
			Else
				// Apontamento de OP
				cNumPeca := U_IXD1PECA()
				If !U_ETQMTA250("010",SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,SC2->C2_PRODUTO,SC2->C2_LOCAL,nQtdKit,"P",cNumPeca)

					U_MsgColetor("Erro no apontamento da OP.")
					oImprime:Disable()
					Return                      
				Else
					__mv_par02 := XD1->XD1_OP
					__mv_par03 := Nil
					__mv_par04 := nQtdKit
					__mv_par05 := 1
					__mv_par06 := SZG->ZG_LAYOUT
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Salva a impressao atual	para possível cancelamento 						³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cDomEtDl36_CancLay := __mv_par06
				EndIf
				MsgRun("Impressão de Etiqueta Layout 01","Aguarde...",{|| lRetEtq := U_DOMETQ04(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,NIL,cNumPeca)})		// Impressão de Etiqueta Layout 01
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³LAYOUT 02 - 																			 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Case __mv_par06 == "02"
			lRotValid :=  U_DOMETQ03(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.F.,nPesoBip,lColetor,NIL,NIL) 			// Validações de Layout 02
			If !lRotValid
				U_MsgColetor("A OP não será apontada. Verifique os problemas com o layout da etiqueta e repita a operação.")
				Return
			Else
				// Apontamento de OP           
				cNumPeca := U_IXD1PECA()
				If !("010",SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,SC2->C2_PRODUTO,SC2->C2_LOCAL,nQtdKit,"P",cNumPeca)

					U_MsgColetor("Erro de apontamento da OP.")
					oImprime:Disable()
					Return
				Else
					__mv_par02 := XD1->XD1_OP
					__mv_par03 := Nil
					__mv_par04 := nQtdKit
					__mv_par05 := 1
					__mv_par06 := SZG->ZG_LAYOUT
					MsgRun("Impressão de Etiqueta Layout 02","Aguarde...",{|| lRetEtq := U_DOMETQ03(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,NIL,cNumPeca)}) 	// Impressão de Etiqueta Layout 02
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Salva a impressao atual	para possível cancelamento 						³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cDomEtDl36_CancLay := __mv_par06
				EndIf
			EndIf
		Case __mv_par06 == "03"
			//cRotina := "U_DOMETQ05(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor)" //Layout 03
			lRotValid := U_DOMETQ05(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.F.,nPesoBip,lColetor,NIL,NIL) // Validações de Layout 03
			If !lRotValid
				U_MsgColetor("A OP não será apontada. Verifique os problemas com o layout da etiqueta e repita a operação.")
				Return
			Else
				// Apontamento de OP
				cNumPeca := U_IXD1PECA()
				If !U_ETQMTA250("010",SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,SC2->C2_PRODUTO,SC2->C2_LOCAL,nQtdKit,"P",cNumPeca)

					U_MsgColetor("Erro de apontamento da OP.")
					oImprime:Disable()
					Return
				Else
					__mv_par02 := XD1->XD1_OP
					__mv_par03 := Nil
					__mv_par04 := nQtdKit
					__mv_par05 := 1
					__mv_par06 := SZG->ZG_LAYOUT
					MsgRun("Impressão de Etiqueta Layout 03","Aguarde...",{|| lRetEtq := U_DOMETQ05(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,NIL,cNumPeca)}) 	// Impressão de Etiqueta Layout 03
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Salva a impressao atual	para possível cancelamento 						³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cDomEtDl36_CancLay := __mv_par06
				EndIf
			EndIf
		Case __mv_par06 == "04"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³LAYOUT 04 - 																			 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lRotValid := U_DOMETQ06(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.F.,nPesoBip,lColetor,NIL,NIL) //Layout 04 - Por Michel A. Sander
			If !lRotValid
				U_MsgColetor("A OP não será apontada. Verifique os problemas com o layout da etiqueta e repita a operação.")
				Return
			Else
				// Apontamento de OP
				cNumPeca := U_IXD1PECA()
				If !U_ETQMTA250("010",SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,SC2->C2_PRODUTO,SC2->C2_LOCAL,nQtdKit,"P",cNumPeca)
					U_MsgColetor("Erro de apontamento da OP.")
					oImprime:Disable()
					Return
				Else
					__mv_par02 := XD1->XD1_OP
					__mv_par03 := Nil
					__mv_par04 := nQtdKit
					__mv_par05 := 1
					__mv_par06 := SZG->ZG_LAYOUT
					MsgRun("Impressão de Etiqueta Layout 04","Aguarde...",{|| lRetEtq := U_DOMETQ06(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,NIL,cNumPeca)}) //Layout 04 - Por Michel A. Sander
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Salva a impressao atual	para possível cancelamento 						³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cDomEtDl36_CancLay := __mv_par06
				EndIf
			EndIf		
		Case __mv_par06 == "05"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³LAYOUT 05 - 																			 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lRotValid :=  U_DOMETQ07(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.F.,nPesoBip,lColetor,NIL,NIL) 			// Validações de Layout 05
			If !lRotValid
				U_MsgColetor("A OP não será apontada. Verifique os problemas com o layout da etiqueta e repita a operação.")
				Return
			Else
				// Apontamento de OP
				cNumPeca := U_IXD1PECA()
				If !U_ETQMTA250("010",SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,SC2->C2_PRODUTO,SC2->C2_LOCAL,nQtdKit,"P",cNumPeca)
				   U_MsgColetor("Erro no apontamento da OP.")

					oImprime:Disable()
					Return
				Else
					__mv_par02 := XD1->XD1_OP
					__mv_par03 := Nil
					__mv_par04 := nQtdKit
					__mv_par05 := 1
					__mv_par06 := SZG->ZG_LAYOUT
					MsgRun("Impressão de Etiqueta Layout 05","Aguarde...",{|| lRetEtq := U_DOMETQ07(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,NIL,cNumPeca)}) 	// Impressão de Etiqueta Layout 05
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Salva a impressao atual	para possível cancelamento 						³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cDomEtDl36_CancLay := __mv_par06
				EndIf
			EndIf
		Case __mv_par06 == "06"
			MsgRun("Impressão de Etiqueta Layout 06","Aguarde...",{|| lRetEtq := U_DOMETQ08(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,NIL,NIL)}) //Layout 06 - Por Michel A. Sander
		Case __mv_par06 == "07"
			MsgRun("Impressão de Etiqueta Layout 07","Aguarde...",{|| lRetEtq := U_DOMETQ09(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,NIL,NIL)}) //Layout 07 - Por Michel A. Sander
		Case __mv_par06 == "10"
			MsgRun("Impressão de Etiqueta Layout 10","Aguarde...",{|| lRetEtq := U_DOMETQ10(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,NIL,NIL)}) //Layout 10 - Por Michel A. Sander
		Case __mv_par06 == "11"
			MsgRun("Impressão de Etiqueta Layout 11","Aguarde...",{|| lRetEtq := U_DOMETQ11(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,NIL,NIL)}) //Layout 11 - Por Michel A. Sander
		Case __mv_par06 == "12"
			MsgRun("Impressão de Etiqueta Layout 12","Aguarde...",{|| lRetEtq := U_DOMETQ12(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,NIL,NIL)}) //Layout 12 - Por MLS
		Case __mv_par06 == "13"
			MsgRun("Impressão de Etiqueta Layout 13","Aguarde...",{|| lRetEtq := U_DOMETQ13(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,NIL,NIL)}) //Layout 13 - Por Michel A. Sander
		Case __mv_par06 == "14"
			MsgRun("Impressão de Etiqueta Layout 14","Aguarde...",{|| lRetEtq := U_DOMETQ14(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,NIL,NIL)}) //Layout 13 - Por Michel A. Sander
		Case __mv_par06 == "31"
			MsgRun("Impressão de Etiqueta Layout 31","Aguarde...",{|| lRetEtq := U_DOMETQ31(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,NIL,NIL)}) //Layout 31 - Por Michel A. Sander
		Case __mv_par06 == "36"
			lRotValid := U_DOMETQ36(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.F.,nPesoBip,lColetor,NIL,NIL) //Layout 36 - Por Michel A. Sander
			If !lRotValid
				U_MsgColetor("A OP não será apontada. Verifique os problemas com o layout da etiqueta e repita a operação.")
				Return
			Else
				// Apontamento de OP
				cNumPeca := U_IXD1PECA()
				If !U_ETQMTA250("010",SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,SC2->C2_PRODUTO,SC2->C2_LOCAL,nQtdKit,"P",cNumPeca)
					U_MsgColetor("Erro no apontamento da OP.")
					oImprime:Disable()
					Return
				Else
					__mv_par02 := XD1->XD1_OP
					__mv_par03 := Nil
					__mv_par04 := nQtdKit
					__mv_par05 := 1
					__mv_par06 := SZG->ZG_LAYOUT
					MsgRun("Impressão de Etiqueta Layout 36","Aguarde...",{|| lRetEtq := U_DOMETQ36(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,NIL,cNumPeca)}) //Layout 36 - Por Michel A. Sander
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Salva a impressao atual	para possível cancelamento 						³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cDomEtDl36_CancLay := __mv_par06
				EndIf
			EndIf
		Case __mv_par06 == "90"
			MsgRun("Impressão de Etiqueta Layout 90","Aguarde...",{|| lRetEtq := U_DOMETQ90(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie,Nil,Nil)}) //Layout 90 - Por Michel A. Sander (TESTE NIVEL 3)
		Case __mv_par06 == "99"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³LAYOUT 99 - HUAWEI LEIAUTE NOVO   								   			 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lRotValid :=  U_DOMETQ99(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.F.,nPesoBip,lColetor,NIL,NIL) 			// Validações de Layout 01
			If !lRotValid
				U_MsgColetor("A OP não será apontada. Verifique os problemas com o layout da etiqueta e repita a operação.")
				Return
			Else
				cNumPeca := U_IXD1PECA()
				If !U_ETQMTA250("010",SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,SC2->C2_PRODUTO,SC2->C2_LOCAL,nQtdKit,"P",cNumPeca)
				   U_MsgColetor("Erro no apontamento da OP.")
					oImprime:Disable()
					Return
				Else
					__mv_par02 := XD1->XD1_OP
					__mv_par03 := Nil
					__mv_par04 := nQtdKit
					__mv_par05 := 1
					__mv_par06 := SZG->ZG_LAYOUT
					MsgRun("Impressão de Etiqueta Layout 99","Aguarde...",{|| lRetEtq := U_DOMETQ99(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,NIL,cNumPeca)}) 	// Impressão de Etiqueta Layout 99
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Salva a impressao atual	para possível cancelamento 						³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cDomEtDl36_CancLay := __mv_par06
				EndIf
			EndIf      
			
	EndCase
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Executa rotina de impressao									³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_lColetor := .F.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Reinicia variáveis da tela										³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNumOpBip := SPACE(11)
	cProdBip  := SPACE(15)
	cDescBip  := SPACE(45)
	cCliBip   := SPACE(45)
	nQtdOpBip := 0
	nSaldoBip := nSaldoBip - nQtdBip
	cPedBip   := SPACE(06)
	aQtdBip   := {}
	aQtdEtiq  := {}
	nQtdBip   := 0
	nQtdKit   := 0
	nQProxEmb := 0
	cProxEmb  := SPACE(60)
	cEmbAtu	 := SPACE(60)
	nQEmbAtu  := 0
	oProduto:Refresh()
	oDescricao:Refresh()
	oQtdOpBip:Refresh()
	oSaldoBip:Refresh()
	oPedido:Refresh()
	oNumOpBip:Refresh()
	oPerda:Refresh()
	oImprime:Disable()
	cEtiqueta := Space(_nTamEtiq)
	oEtiqueta:Refresh()
	oEtiqueta:SetFocus()
	
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CanImpBip ºAutor ³ Michel Sander      º Data ³    27/05/15 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cancela Ultima etiqueta impressa                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CanImpBip()  // Tratado

MsgInfo("Cancelamento de etiqueta desabilitado. Favor solicitar o estorno para a Lider de Produção.")

Return


If Empty(cDomEtDl31_CancEtq)
	//MsgStop("Não existe etiqueta a ser cancelada.")
	U_MsgColetor("Não existe etiqueta a ser cancelada.")
Else
	//If !MsgNoYes("A última etiqueta impressa será CANCELADA."+CHR(13)+"Deseja continuar?")
	If !MsgNoYes("A última etiqueta impressa será CANCELADA.")
		Return
	End
	
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

	lColetor := .T.
	If cDomEtDl36_CancLay == "01"
		U_DOMETQ04(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor)		// Impressão de Etiqueta Layout 01
	ElseIf cDomEtDl36_CancLay == "02"
		U_DOMETQ03(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor)  	// Impressão de Etiqueta Layout 02
	ElseIf cDomEtDl36_CancLay == "03"
		U_DOMETQ05(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor)		// Layout 03
	ElseIf cDomEtDl36_CancLay == "04"
		U_DOMETQ06(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor)		// Layout 04 - Por Michel A. Sander
	ElseIf cDomEtDl36_CancLay == "05"
		U_DOMETQ07(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor)	 	// Impressão de Etiqueta Layout 05
	ElseIf cDomEtDl36_CancLay == "06"
		U_DOMETQ08(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor)		// Layout 06 - Por Michel A. Sander
	ElseIf cDomEtDl36_CancLay == "07"
		U_DOMETQ09(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor)		// Layout 07 - Por Michel A. Sander
	ElseIf cDomEtDl36_CancLay == "10"
		U_DOMETQ10(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor)		// Layout 10 - Por Michel A. Sander
	ElseIf cDomEtDl36_CancLay == "11"
		U_DOMETQ11(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor)		// Layout 11 - Por Michel A. Sander
	ElseIf cDomEtDl36_CancLay == "12"
		U_DOMETQ12(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor)		//Layout 12 - Por MLS
	ElseIf cDomEtDl36_CancLay == "13"
		U_DOMETQ12(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor)		//Layout 12 - Por MLS
	ElseIf cDomEtDl36_CancLay == "31"
		U_DOMETQ31(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor)		//Layout 31 - Por Michel A. Sander
	ElseIf cDomEtDl36_CancLay == "36"
		U_DOMETQ36(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor)		//Layout 36 - Por Michel A. Sander
	EndIf
	
EndIf

oEtiqueta:SetFocus()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fEnvExped ºAutor ³ Helio Ferreira     º Data ³    27/05/15 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para envio de material para expedicao               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fEnvExped()

LOCAL nOpcOP := 0

PRIVATE _cNumOpBip := Space(11)
PRIVATE _nQtdOpBip := 0

DEFINE MSDIALOG oDlg2 TITLE OemToAnsi("Envio a Expedição") From 20,20 To 210,200 Pixel of oMainWnd PIXEL

nLin := 005
@ nLin,005 Say oTxtOP     Var "Número da OP" Pixel Of oDlg2
nLin += 015

@ nLin-2,005 MsGet oGetOP Var _cNumOpBip  SIZE 80,12 Valid fValEnvEx() WHEN .T. PIXEL
oTxtOP:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
oGetOP:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
nLin += 020

@ nLin,005	SAY _oTexto12 Var 'Quantidade:'    SIZE 100,10 PIXEL OF oDlg2
nLin += 015

_oTexto12:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
@ nLin-2, 005 MSGET _oQtdOPBip VAR _nQtdOpBip  Picture "999,999" SIZE 50,12 Valid fValQtd() WHEN .T. PIXEL
_oQtdOPBip:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)
nLin+= 020

@ nLin,025 Button oBotPeso PROMPT "Confirma" Size 35,15 Action {|| nOpcOP:=1,oDlg2:End()} Pixel Of oDlg2

ACTIVATE MSDIALOG oDlg2 

oEtiqueta:SetFocus()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fValEnvEx ºAutor ³ Helio Ferreira     º Data ³    27/05/15 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para envio de material para expedicao               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fValEnvEx()

Local _Retorno := .T.

If !Empty(_cNumOpBip)
	SC2->( dbSetOrder(1) )
	If SC2->( dbSeek( xFilial() + Subs(_cNumOpBip,1,11) ) )
		cQuery := "SELECT COUNT(*) CONTAGEM FROM " + RetSqlName("XD1") + " (NOLOCK) WHERE XD1_OP = '"+Subs(_cNumOpBip,1,11)+"' AND XD1_NIVEMB = '2' AND XD1_OCORRE = '6' AND D_E_L_E_T_ = '' "
		
		If Select("TEMP") <> 0
			TEMP->( dbCloseArea() )
		EndIf
		
		TCQUERY cQuery NEW ALIAS "TEMP"
		
		_nQtdOpBip := TEMP->CONTAGEM
		
		If Empty(_nQtdOpBip)
			U_MsgColetor("Não existe material disponível para ser enviado desta OP.")
			_Retorno := .F.
		EndIf
	Else
		U_MsgColetor("OP Invalida.")
		_Retorno := .F.
	EndIf
EndIf

Return _Retorno

Static Function fValQtd()
Local _Retorno := .T.

If !Empty(_nQtdOpBip)
	cQuery := "SELECT COUNT(*) CONTAGEM FROM " + RetSqlName("XD1") + " (NOLOCK) WHERE XD1_OP = '"+Subs(_cNumOpBip,1,11)+"' AND XD1_NIVEMB = '2' AND XD1_OCORRE = '6' AND D_E_L_E_T_ = '' "
	
	If Select("TEMP") <> 0
		TEMP->( dbCloseArea() )
	EndIf
	
	TCQUERY cQuery NEW ALIAS "TEMP"
	
	If _nQtdOpBip > TEMP->CONTAGEM
		U_MsgColetor("Quantidade superior a disponível para ser enviada para expedição.")
		_Retorno := .F.
	Else
		If MsgNoYes("Confirma a quantidade de "+Alltrim(Str(_nQtdOpBip)) + " para enviar a expedição?")
			fProcEnv()
		Else
			_Retorno := .F.
		EndIf
	EndIf
EndIf

Return _Retorno

Static Function fProcEnv()

If !Empty(_nQtdOpBip)
	cQuery := "SELECT COUNT(*) CONTAGEM FROM " + RetSqlName("XD1") + " (NOLOCK) WHERE XD1_OP = '"+Subs(_cNumOpBip,1,11)+"' AND XD1_NIVEMB = '2' AND XD1_OCORRE = '6' AND D_E_L_E_T_ = '' "
	
	If Select("TEMP") <> 0
		TEMP->( dbCloseArea() )
	EndIf
	
	TCQUERY cQuery NEW ALIAS "TEMP"
	
	If _nQtdOpBip <= TEMP->CONTAGEM
		cQuery := "SELECT TOP " + Alltrim(Str(_nQtdOpBip)) + " R_E_C_N_O_ FROM " + RetSqlName("XD1") + " (NOLOCK) WHERE XD1_OP = '"+Subs(_cNumOpBip,1,11)+"' AND XD1_NIVEMB = '2' AND XD1_OCORRE = '6' AND D_E_L_E_T_ = '' "
		
		If Select("TEMP") <> 0
			TEMP->( dbCloseArea() )
		EndIf
		
		TCQUERY cQuery NEW ALIAS "TEMP"
		
		While !TEMP->( EOF() )
			XD1->( dbGoto(TEMP->R_E_C_N_O_) )
			If XD1->( Recno() ) == TEMP->R_E_C_N_O_
				Reclock("XD1",.F.)
				XD1->XD1_OCORRE := "4"
				XD1->( msUnlock() )
			EndIf
			TEMP->( dbSkip() )
		End

		//If U_uMsgYesNo("Deseja processar o apontamento da OP " + _cNumOpBip + "?")
		MsgRun("Processando envio...","Aguarde",{||U_SCHEDOP(_cNumOpBip)})
		//EndIf
		
		//MsgInfo("Envio Ok")
		U_MsgColetor("Envio OK.")
		oDlg2:End()
		
	Else
		//MsgStop("Quantidade superior a disponível para ser enviada para expedição.")
		U_MsgColetor("Quantidade superior a disponível para ser enviada para expedição.")
	EndIf
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AlertC    ºAutor ³ Helio Ferreira     º Data ³    27/05/15 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela de Mensagem										              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
