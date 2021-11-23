#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"
#include "Tbiconn.ch"

#Define ENTER CHAR(13) + CHAR(10)
#Define VKTAB    Chr(9)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DOMETDLG ºAutor  ³ Michel Sander      º Data ³    27/05/15 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Apontamento de produção e impressão de etiquetas           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMETDL7()

	//Local lLoop     := .T.
	//Local lOk       := .F.
	//Local aPar      := {}
	//Local aRet      := {}
	//Local aLayout   := {}

	Private _nTamEtiq   := 21
	Private __mv_par01  := 1 			         // Pesquisar por OP ou Senf
	Private __mv_par02  := Space(11) 		   // Numero OP
	Private __mv_par03  := Space(09) 			// Senf + Item
	Private __mv_par04  := 0         			// Qtd Embalagem
	Private __mv_par05  := 0         			// Qtd Etiquetas
	Private __mv_par06  := Space(02) 			// Layout da Etiqueta
	Private cEtiqueta   := Space(_nTamEtiq)
	Private cEtiquet2   := Space(_nTamEtiq)
	Private cTagFor		:= "Não"
	Private cEmbAtu     := Space(60)
	Private nQEmbAtu    := 0
	Private cProxEmb    := SPACE(60)
	Private nQProxEmb   := 0
	Private nQtdGer     := 0
	Private nQtdTotger  := 0
	Private nQtdBip     := 0
	Private nQtdKit     := 0
	Private nQtdEmb     := 0
	Private aQtdBip     := {}
	Private aQtdEtiq    := {}
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
	Private lTelefonic  := .F.
	Private lEricsson   := .F.
	Private lComba      := .F.
	Private lOi         := .F.
	Private lSuperv     := .F.
	Private cPedTel     := ""
	Private cNumSerie   := ""
	Private lUltTelef   := .F.
	Private lUltOi      := .F.
	Private cOPAtu      := ""
	Private cOPnSerie   := ""
	Private aSerial     := {}
	Private lSerial     := .F.
	Private _cGrupoUso  := ""
	Private cSerNiv     := ""
	Private nContaN1    := 0
	Private nQtTotN1	:= 0
	Private oQtdGer
	Private _cSenha  := Space(6)
	Private _cSenha1 := Space(6)
	Private _cSenha2 := Space(6)
	Private oQOpBip
	Private oSBip
	Private oPdVen
	Private oPdaOp
	Private oDlgHuawei
	Private lNewDL7  := .F.//SuperGetMv("MV_XNEWDL7",.F., .F.)
	Private oRadio
	Private nRadio   := 1
	Private cSubClasse := ""
	Private cTipoSB1   := ""
	Private cCodHuawei := SPACE(100)//SPACE(Len(XD1->XD1_ETQHUA))
	Private cCdHuawei2 := SPACE(100)
	Private cCodHua2ok := ""
	Private oCodHuawei
	Private oCdHuawei2
	Private cFila:= ""
	Private cCelula:= ""
	Private lOkFlex   := SuperGetMv("MV_XVRFLEX",.F.,.F.)
	Private lOkFuruka := SuperGetMv("MV_XVRFURU",.F.,.T.)
	Private lGlobal  := .F.
	Private lEhFuruka := .F.
	Private lComTravR := IIF(ISINCALLSTACK('U_DL7STRVR'),.T.,.F.)

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
	Public cDomEtDl3B_CancPed := ""
	Public cDomEtDl3C_CancPro := ""

	Public cErictDl31_CancEtq := ""
	Public cErictDl32_CancOP  := ""
	Public cErictDl33_CancEmb := ""
	Public cErictDl34_CancKit := ""
	Public cErictDl35_CancUni := 0
	Public cErictDl36_CancLay := ""
	Public cErictDl37_CancImp := .T.
	Public cErictDl38_CancNiv := ""
	Public cErictDl39_CancPes := 0
	Public aErictDl3A_CancFil := {}
	Public cErictDl3B_CancPed := ""
	Public cErictDl3C_CancPro := ""

	Public cTeletDl32_CancOP  := ""
	Public cTeletDl33_CancPro := ""
	Public cTeletDl34_CancPed := ""
	Public cTeletDl35_CancUni := 0
	Public cTeletDl38_CancDat := CTOD("")

	Public cOiDl32_CancOP     := ""
	Public cOiDl33_CancPro    := ""
	Public cOiDl34_CancPed    := ""
	Public cOiDl35_CancUni    := 0
	Public cOiDl38_CancDat    := CTOD("")
	Public cOiDl39_CancQtd    := 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³F7 para Reimpressão de etiquetas								³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//SetKey( VK_F4 , bRePrint )
	//SetKey( VK_F8, { || fEnvExped() } )
	//SetKey( VK_F6, { || fFinalEmb() } )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posição inicial da tela principal							³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLin := 15
	nCol1 := 10
	nCol2 := 95
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Cabeçalho da OP													³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ HELIO

	cCelula:= fButtCel()
	cFila:= fLocImp(cCelula)


	DEFINE MSDIALOG oDlg01 TITLE OemToAnsi("U_DOMETDL7() - Emissão de Etiquetas (NOVO)") FROM 0,0 TO 510,800 PIXEL of oMainWnd PIXEL //300,400 PIXEL of oMainWnd PIXEL

	@ nLin-10,nCol1-05 TO nLin+62,nCol1+387 LABEL " Informações da Ordem de Produção "  OF oDlg01 PIXEL
	@ nLin, nCol1	SAY oTexto10 Var 'Número da OP:'    SIZE 100,10 PIXEL
	oTexto10:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
	@ nLin-2, nCol2 MSGET oNumOPBip VAR cNumOpBip  SIZE 80,12 WHEN .F. PIXEL
	oNumOPBip:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)
	@ nLin, nCol2+090	SAY oTexto12 Var 'Quantidade:'    SIZE 100,10 PIXEL
	oTexto12:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
	@ nLin-2, nCol2+140 MSGET oQOpBip VAR nQtdOpBip  SIZE 50,12 WHEN .F. PIXEL
	oQOpBip:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)
	@ nLin, nCol2+200	SAY oTexto13 Var 'Saldo:'    SIZE 100,10 PIXEL
	oTexto13:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
	@ nLin-2, nCol2+230 MSGET oSBip VAR nSaldoBip  SIZE 50,12 WHEN .F. PIXEL
	oSBip:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)
	nLin += 15
	@ nLin, nCol1	SAY oTexto10 Var 'Produto:'    SIZE 100,10 PIXEL
	oTexto10:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
	@ nLin-2, nCol2 MSGET oProduto VAR cProdBip  SIZE 100,12 WHEN .F. PIXEL
	oProduto:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)
	@ nLin, nCol2+110 SAY oTexto15 Var 'Perda:'    SIZE 100,10 PIXEL
	oTexto15:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
	@ nLin-2, nCol2+140 MSGET oPdaOp VAR nPerdaBip PICTURE "9999.99" SIZE 50,12 WHEN .F. PIXEL
	oPdaOp:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)
	@ nLin, nCol2+195	SAY oTexto14 Var 'Pedido:'    SIZE 100,10 PIXEL
	oTexto14:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
	@ nLin-2, nCol2+230 MSGET oPdVen VAR cPedBip  SIZE 50,12 WHEN .F. PIXEL
	oPdVen:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)

	nLin += 15
	@ nLin-2, nCol2 MSGET oDescricao VAR cDescBip  SIZE 280,12 WHEN .F. PIXEL
	oDescricao:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)
	nLin += 15
	@ nLin, nCol1	SAY oTexto11 Var 'Cliente:'    SIZE 100,10 PIXEL
	oTexto11:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
	@ nLin-2, nCol2 MSGET oCliente VAR cCliBip  SIZE 280,12 WHEN .F. PIXEL
	oCliente:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³      ######### Leitura da Etiqueta	#############		³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLin += 30
	@ nLin-10,nCol1-05 TO nLin+18,nCol1+387 LABEL " Código de Barras "  OF oDlg01 PIXEL
	@ nLin, nCol1	SAY oTexto1 Var 'Etiqueta:'    SIZE 100,10 PIXEL
	oTexto1:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

	@ nLin-2, nCol2               MSGET oEtiqueta VAR cEtiqueta  SIZE 80,12 WHEN .T. Valid ValidaEtiq() PIXEL
	oEtiqueta:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)

	If GetMv("MV_XVERCHN")
		@ nLin-3, nCol2+090  RADIO oRadio VAR nRadio ITEMS "SEM  Etiqueta do Fornecedor","COM Etiqueta do Fornecedor" SIZE 150,10 OF oDlg01 PIXEL
		oRadio:oFont := TFont():New('Arial',,12,,.T.,,,,.T.,.F.)
	EndIf

	@ nLin, nCol2+190	SAY oTxtTagFor Var 'Tag.For.:'    SIZE 100,10 PIXEL
	oTxtTagFor:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
	@ nLin-2, nCol2+230 MSGET oTagFor VAR cTagFor  SIZE 50,12 WHEN .F. PIXEL
	oTagFor:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Informações da Embalagem										³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLin += 30
	@ nLin-10,nCol1-05 TO nLin+32,nCol1+387 LABEL " Informações de Embalagem "  OF oDlg01 PIXEL
	@ nLin, nCol1	SAY oTexto1 Var 'Embalagem atual:'    SIZE 100,10 PIXEL
	oTexto1:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
	@ nLin-2, nCol2 MSGET oEmbAtu VAR cEmbAtu  SIZE 280,12 WHEN .F. Valid .F. PIXEL
	oEmbAtu:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)
	nLin += 15
	@ nLin, nCol1	SAY oTexto1 Var 'Qtd por embalagem:'    SIZE 100,10 PIXEL
	oTexto1:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
	@ nLin-2, nCol2 MSGET oQEmbAtu VAR nQEmbAtu Picture("@E 999,999") SIZE 80,12 WHEN .F. Valid .F. PIXEL
	oQEmbAtu:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)
	@ nLin, nCol2+130 SAY oTexto1 Var 'Já separados:'    SIZE 100,10 PIXEL
	oTexto1:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
	@ nLin-2, nCol2+200 MSGET oQtdBip VAR nQtdBip   SIZE 80,12 WHEN .F. Valid .F. PIXEL
	oQtdBip:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Próxima Embalagem													³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLin += 30
	@ nLin-10,nCol1-05 TO nLin+55,nCol1+387 LABEL " Próxima Embalagem "  OF oDlg01 PIXEL
	@ nLin, nCol1	SAY oTexto1 Var 'Próxima embalagem:'    SIZE 100,10 PIXEL
	oTexto1:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
	@ nLin-2, nCol2               MSGET oProxEmb VAR cProxEmb SIZE 280,12 WHEN .F. Valid .F. PIXEL
	oProxEmb:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)
	nLin += 15
	@ nLin, nCol1	SAY oTexto1 Var 'Qtd próxima emb:'    SIZE 100,10 PIXEL
	oTexto1:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
	@ nLin-2, nCol2               MSGET oQProxEmb VAR nQProxEmb Picture("@E 999,999") SIZE 80,12 WHEN .F. Valid .F. PIXEL
	oQProxEmb:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)


	@ nLin, nCol2+130	SAY oTexto1 Var 'Emb. disponíveis:'    SIZE 100,10 PIXEL
	oTexto1:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
	@ nLin-2, nCol2+200               MSGET oQtdGer VAR nQtdGer Picture("@E 999,999") SIZE 80,12 WHEN .F. Valid .F. PIXEL
	oQtdGer:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)
	nLin += 15
	/*
@ nLin,    270	SAY oTexto1 Var '<F8> Entrega á Expedição'    SIZE 120,10 PIXEL
oTexto1:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
@ nLin+10, 270	SAY oTexto2 Var '<F6> Finaliza Embalagem'     SIZE 120,10 PIXEL
oTexto2:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
	*/
	nLin += 25

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Botões de controle												³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ nLin,nCol1-05 TO nLin+1,nCol1+387 LABEL "" OF oDlg01 PIXEL 	// Linha horizontal para separar botões
	nLin += 05
	@ nLin, nCol1+05  BUTTON oUltima     PROMPT "Cancelar última Etiqueta" ACTION CanImpBip()							 SIZE 100,20 PIXEL OF oDlg01
	@ nLin, nCol2+30  BUTTON oSupervisor PROMPT "Supervisor" 				  ACTION {|| lSuperv := U_SupervMenu()} SIZE 080,20 PIXEL OF oDlg01
	@ nLin, nCol2+210 BUTTON oCancelar   PROMPT "Cancelar" 					  ACTION Processa( {|| oDlg01:End() } ) SIZE 080,20 PIXEL OF oDlg01
	@ nLin, nCol2+120 BUTTON oImprime    PROMPT "Imprimir" 					  ACTION Processa( {|| If(VerImpBip(), ImpEtqBip(cEtiqueta/*aQtdBip[1]*/),;
		{ cEtiqueta := Space(_nTamEtiq),;
		oEtiqueta:Refresh(), ;
		oEtiqueta:SetFocus() } ) } ) SIZE 080,20 PIXEL OF oDlg01
	oUltima:Disable()
	oImprime:Enable()

	ACTIVATE MSDIALOG oDlg01 CENTER

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VerImpBip ºAutor³ Helio Ferreira     º Data ³    27/05/15 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Finaliza embalagem para impressão                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VerImpBip()

	LOCAL __lOkBip := .T.
	__lOkBip := MsgNoYes("Qtde da Embalagem = "+AllTrim(STR(nQtdBip))+" "+CHR(13)+"Confirma a impressão?")

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
	Local _nX
	Private cEtiqOrig := cEtiqueta

	DEFAULT lTeste := .F.

	lSerial := .F.

	If !Empty(cEtiqueta)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Prepara número da etiqueta bipada							³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Len(AllTrim(cEtiqueta)) == 12  //EAN 13 s/ dígito verificador.
			if lOkFuruka
				//XD4_FILIAL, XD4_KEY, R_E_C_N_O_, D_E_L_E_T_
				XD4->(DbSetOrder(3))
				If XD4->(DbSeek(xFilial("XD4") + UPPER(Alltrim(cEtiqOrig))))
					cOPnSerie := Alltrim(XD4->XD4_OP)
					If U_VALIDACAO()  .Or. .T. // validacao.Helio   26/07/21 - Producao 25/08/21
						lSerial := .T.
					EndIf
				Else
					If UPPER(Subs(cEtiqOrig,1,1)) <> 'S'
						If U_VALIDACAO()  .Or. .T. // validacao.Helio   26/07/21 - Producao 25/08/21
							If XD1->( dbSeek( xFilial() + Alltrim(cEtiqueta) ) )
								cEtiqueta := Alltrim(cEtiqueta)

							Else
								cEtiqueta := "0"+cEtiqueta
								cEtiqueta := Subs(cEtiqueta,1,12)
							EndIf
							lSerial   := .F.
						Else
							cPesqOp := Posicione("SC2",1,xFilial("SC2") + Left(cEtiqOrig,6),"C2_NUM+C2_ITEM+C2_SEQUEN")
							if !Empty(Alltrim(cPesqOp))
								cOPnSerie := cPesqOp
							Else
								nItOP     := StrZero(Val(SubStr(cEtiqOrig,8,1)),3)
								cOPnSerie := PADR(SubsTr(cEtiqOrig,1,5),6)+SubsTr(cEtiqOrig,6,2)+nItOP
							EndIf
						EndIf

					Else
						cOPnSerie := Subs(cEtiqOrig,2,11)
						If U_VALIDACAO() .Or. .T.  // validacao.Helio   26/07/21 - Producao 25/08/21
							lSerial := .T.
						EndIf
					EndIf
				EndIf
			else
				If UPPER(Subs(cEtiqOrig,1,1)) <> 'S'
					XD1->( dbSetOrder(1) )
					If XD1->( dbSeek( xFilial() + Subs("0" + cEtiqueta,1,12) ) )
						cOPnSerie := ""
					Else
						nItOP     := StrZero(Val(SubStr(cEtiqOrig,8,1)),3)
						cOPnSerie := PADR(SubsTr(cEtiqOrig,1,5),6)+SubsTr(cEtiqOrig,6,2)+nItOP
					EndIf
				Else
					cOPnSerie := Subs(cEtiqOrig,2,11)
				EndIf
			EndIf

			If !U_VALIDACAO() .And. .F.   // validacao.Helio   26/07/21   Retirar esse trecho todo - Producao 25/08/21
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
			EndIf

		Else
			if lOkFuruka
				//XD4_FILIAL, XD4_KEY, R_E_C_N_O_, D_E_L_E_T_
				XD4->(DbSetOrder(3))
				If XD4->(DbSeek(xFilial("XD4") + UPPER(Alltrim(cEtiqOrig))))
					cOPnSerie := Alltrim(XD4->XD4_OP)
				Else
					If UPPER(Subs(cEtiqOrig,1,1)) <> 'S'
						XD1->( dbSetOrder(1) )
						If XD1->( dbSeek( xFilial() + Subs("0" + cEtiqueta,1,12) ) )
							cOPnSerie := ""
						Else
							nItOP     := StrZero(Val(SubStr(cEtiqOrig,8,1)),3)
							cOPnSerie := PADR(SubsTr(cEtiqOrig,1,5),6)+SubsTr(cEtiqOrig,6,2)+nItOP
						EndIf
					Else
						cOPnSerie := Subs(cEtiqOrig,2,11)
					EndIf
				EndIf
			else
				If UPPER(Subs(cEtiqOrig,1,1)) <> 'S'
					nItOP     := StrZero(Val(SubStr(cEtiqOrig,8,1)),3)
					cOPnSerie := PADR(SubsTr(cEtiqOrig,1,5),6)+SubsTr(cEtiqOrig,6,2)+nItOP
				Else
					cOPnSerie := Subs(cEtiqOrig,2,11)
				EndIf

			EndIf
			If SC2->(dbSeek(xFilial("SC2")+cOPnSerie))
				lSerial := .T.
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Valida etiqueta bipada											³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				While !MsgNoYes("Etiqueta não encontrada. "+CHR(13)+"Deseja continuar?")
				End
				oImprime:Disable()
				cEtiqueta   := Space(_nTamEtiq)
				oEtiqueta:SetFocus()
				Return (.F.)
			EndIf
		EndIf
		//Inicializa a Tag Fornecedor com "Não"
		cTagFor := "Não"
		oTagFor:Refresh()

		XD1->( dbSetOrder(1) )
		XD2->( dbSetOrder(2) )
		SB1->( dbSetOrder(1) )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona na etiqueta bipada									³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If XD1->( dbSeek( xFilial() + cEtiqueta ) ) .and. !lSerial

			If Len(aSerial) > 0
				While !MsgNoYes("Apontamento de embalagem não permitido nesse momento, pois existe um apontamento de serial já iniciado."+CHR(13)+"Deseja continuar?")
				End
				oImprime:Disable()
				cNumOpBip := SPACE(11)
				oNumOpBip:Refresh()
				cEtiqueta := Space(_nTamEtiq)
				oEtiqueta:Refresh()
				oEtiqueta:SetFocus()
				Return (.f.)
			EndIf


			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica cancelamento											³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If XD1->XD1_NIVEMB == "1" .And. XD1->XD1_OCORRE == "5"
				While !MsgNoYes("Etiqueta cancelada."+CHR(13)+CHR(13)+"Deseja continuar?")
				End
				oImprime:Disable()
				cNumOpBip := SPACE(11)
				oNumOpBip:Refresh()
				cEtiqueta := Space(_nTamEtiq)
				oEtiqueta:Refresh()
				oEtiqueta:SetFocus()
				Return (.f.)
			EndIf

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
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica se Possui TAG Fornecedor na Tabela SC6 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				SC6->(DbSetOrder(1))
				If SC6->(DbSeek(SC2->C2_FILIAL + SC2->C2_PEDIDO + SC2->C2_ITEMPV + SC2->C2_PRODUTO))
					IF SC6->C6_XTAGFOR == "S"
						cTagFor := "Sim"
						oTagFor:Refresh()
					else
						cTagFor := "Não"
						oTagFor:Refresh()
					EndIf
				EndIf

				If (SC2->C2_QUANT - SC2->C2_QUJE) <= 0  // Trocado de C2_XXQUJE para C2_QUJE      por Hélio em 25/09/18
					While !MsgNoYes("Ordem de Produção já encerrada."+CHR(13)+"Deseja continuar?")
					End
					oImprime:Disable()
					cNumOpBip := SPACE(11)
					oNumOpBip:Refresh()
					cEtiqueta := Space(_nTamEtiq)
					oEtiqueta:Refresh()
					oEtiqueta:SetFocus()
					Return (.f.)
				EndIf
				DbSelectArea("SA1")
				SA1->(DbSetOrder(1))
				SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
				SA1->(dbSeek(xFilial("SA1")+SC2->C2_CLIENT))
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica se o Cliente é TELEFONICA							³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lTelefonic := .F.
				If (("TELEFONICA" $ Upper(SA1->A1_NOME)) .Or. ("TELEFONICA" $ Upper(SA1->A1_NREDUZ))) //.And. _cGrupoUso <> "PCON"   PCON retirado em 04/11/21 por Helio/Ricardo
					lTelefonic := .T.
					SC5->(dbSeek(xFilial("SC5")+SC2->C2_PEDIDO))
					cPedTel := SC5->C5_ESP1
				Else
					lUltTelef := .F.
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica se o Cliente é ERICSSON								³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lEricsson := .F.
				If ("ERICSSON" $ Upper(SA1->A1_NOME)) .Or. ("ERICSSON" $ Upper(SA1->A1_NREDUZ))
					lEricsson := .T.
					SC5->(dbSeek(xFilial("SC5")+SC2->C2_PEDIDO))
					cPedTel := SC5->C5_ESP1
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica se o Cliente é COMBA									³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lComba := .F.
				If ("COMBA " $ Upper(SA1->A1_NOME)) .Or. ("COMBA " $ Upper(SA1->A1_NREDUZ))
					lComba := .T.
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica se o Cliente é OI S/A								³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If GetMv("MV_XVEROI")
					lOi := .F.
					If ("OI S" $ Upper(SA1->A1_NOME)) .Or. ("OI MO" $ Upper(SA1->A1_NOME)) .Or. ("OI MOVEL" $ Upper(SA1->A1_NOME)) .Or. ("TELEMAR" $ Upper(SA1->A1_NOME)) .Or. ("BRASIL TELECOM COMUNICACAO MUL" $ Upper(SA1->A1_NOME))
						lOi := .T.
					Else
						lUltOi := .F.
					EndIf
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica se o Cliente é FURUKAWA						³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lEhFuruka := .F.
				If ("FURUKAWA" $ Upper(SA1->A1_NOME)) .Or. ("FURUKAWA" $ Upper(SA1->A1_NREDUZ))
					lEhFuruka := .T.
				EndIf

				cProdBip  := SB1->B1_COD
				cDescBip  := SB1->B1_DESC
				cCliBip   := SA1->A1_NOME
				nQtdOpBip := SC2->C2_QUANT
				cPedBip   := SC2->C2_PEDIDO
				nPerdaBip := U_SomaPerda(cNumOpBip,SC2->C2_PRODUTO)
				nSaldoBip := (SC2->C2_QUANT - SC2->C2_QUJE) - nPerdaBip  // Trocado de C2_XXQUJE para C2_QUJE      por Hélio em 25/09/18
				oCliente:Refresh()
				oProduto:Refresh()
				oDescricao:Refresh()
				oQOpBip:Refresh()
				oSBip:Refresh()
				oPdVen:Refresh()
				oPdaOp:Refresh()

			Else

				If SC2->(dbSeek(xFilial("SC2")+XD1->XD1_OP))
					If (SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN) <> cNumOpBip
						If (SC2->C2_QUANT - SC2->C2_QUJE) <= 0   // Trocado de C2_XXQUJE para C2_QUJE      por Hélio em 25/09/18
							While !MsgNoYes("Ordem de Produção já encerrada."+CHR(13)+"Deseja continuar?")
							End
							SC2->(dbSeek(xFilial("SC2")+cNumOpBip))
							oImprime:Disable()
							cNumOpBip := (SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
							oNumOpBip:Refresh()
							cEtiqueta := Space(_nTamEtiq)
							oEtiqueta:Refresh()
							oEtiqueta:SetFocus()
							Return (.f.)
						EndIf
						lCont := MsgNoYes("Esse produto pertence a outra Ordem de Produção."+CHR(13)+"Deseja continuar?")
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

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Verifica se o Cliente é TELEFONICA							³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							lTelefonic := .F.
							If (("TELEFONICA" $ Upper(SA1->A1_NOME)) .Or. ("TELEFONICA" $ Upper(SA1->A1_NREDUZ))) //.And. _cGrupoUso <> "PCON"  PCON retirado em 04/11/21 por Helio/Ricardo
								lTelefonic := .T.
								SC5->(dbSeek(xFilial("SC5")+SC2->C2_PEDIDO))
								cPedTel := SC5->C5_ESP1
							Else
								lUltTelef := .F.
							EndIf

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Verifica se o Cliente é ERICSSON								³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							lEricsson := .F.
							If ("ERICSSON" $ Upper(SA1->A1_NOME)) .Or. ("ERICSSON" $ Upper(SA1->A1_NREDUZ))
								lEricsson := .T.
								SC5->(dbSeek(xFilial("SC5")+SC2->C2_PEDIDO))
								cPedTel := SC5->C5_ESP1
							EndIf

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Verifica se o Cliente é COMBA									³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							lComba := .F.
							If ("COMBA " $ Upper(SA1->A1_NOME)) .Or. ("COMBA " $ Upper(SA1->A1_NREDUZ))
								lComba := .T.
							EndIf

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Verifica se o Cliente é OI S/A								³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If GetMv("MV_XVEROI")
								lOi := .F.
								If ("OI S" $ Upper(SA1->A1_NOME)) .Or. ("OI MO" $ Upper(SA1->A1_NOME)) .Or. ("OI MOVEL" $ Upper(SA1->A1_NOME)) .Or. ("TELEMAR" $ Upper(SA1->A1_NOME)) .Or. ("BRASIL TELECOM COMUNICACAO MUL" $ Upper(SA1->A1_NOME))
									lOi := .T.
								Else
									lUltOi := .F.
								EndIf
							EndIf


							cProdBip  := SB1->B1_COD
							cDescBip  := SB1->B1_DESC
							cCliBip   := SA1->A1_NOME
							nQtdOpBip := SC2->C2_QUANT
							cPedBip   := SC2->C2_PEDIDO
							nPerdaBip := U_SomaPerda(cNumOpBip,SC2->C2_PRODUTO)
							nSaldoBip := (SC2->C2_QUANT - SC2->C2_QUJE) - nPerdaBip  // Trocado de C2_XXQUJE para C2_QUJE      por Hélio em 25/09/18
							cEtiqueta := Space(_nTamEtiq)
							aQtdBip   := {}
							aQtdEtiq  := {}
							nQtdBip   := 0
							nQtdKit   := 0
							nQProxEmb := 0
							cProxEmb  := SPACE(60)
							cEmbAtu	 := SPACE(60)
							nQEmbAtu  := 0
							nQtdGer   := 0
							oQEmbAtu:Refresh()
							oEmbAtu:Refresh()
							oProxEmb:Refresh()
							oQProxEmb:Refresh()
							oCliente:Refresh()
							oProduto:Refresh()
							oDescricao:Refresh()
							oQOpBip:Refresh()
							oSBip:Refresh()
							oPdVen:Refresh()
							oPdaOp:Refresh()
							oQtdBip:Refresh()
							oEtiqueta:Refresh()
							oEtiqueta:SetFocus()
							oImprime:Disable()
							Return (.F.)
						EndIf
					EndIf
				EndIf
			EndIf

			oUltima:Disable()

			If Empty(XD1->XD1_NIVEMB)
				While !MsgNoYes("Etiqueta sem nível de embalagem."+CHR(13)+"Deseja continuar?")
				End
				oImprime:Disable()
				cEtiqueta := Space(_nTamEtiq)
				oEtiqueta:Refresh()
				oEtiqueta:SetFocus()
				Return(.F.)
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona na etiqueta bipada									³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			XD2->(dbSetOrder(2))
			If XD2->( dbSeek( xFilial("XD2") + cEtiqueta ) )
				//While !MsgNoYes("Etiqueta lida já pertence a outra embalagem:"+XD2->XD2_XXPECA+"."+CHR(13)+"Deseja continuar?")
				//End
				MsgStop("Etiqueta lida já pertence a outra embalagem:"+XD2->XD2_XXPECA+".")
				oImprime:Disable()
				cEtiqueta := Space(_nTamEtiq)
				oEtiqueta:Refresh()
				oEtiqueta:SetFocus()
			Else

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Busca a quantidade da embalagem padrao para o serial	³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica nível de embalagem da etiqueta bipada			³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cEmbAtu    := ""
				If !Empty(XD1->XD1_EMBALA)
					If SB1->( dbSeek( xFilial() + XD1->XD1_EMBALA ) )
						cEmbAtu    := SB1->B1_DESC
					EndIf
				EndIf

				nQEmbAtu   := XD1->XD1_QTDEMB
				cNivEmb    := XD1->XD1_NIVEMB
				cProxNiv   := Soma1(cNivEmb)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica próxima embalagem										³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

				aRetEmbala := U_RetEmbala(XD1->XD1_COD,cProxNiv)

				If !aRetEmbala[4]
					While !MsgNoYes("Próxima embalagem não encontrada na estrutura do produto."+CHR(13)+"Deseja continuar?")
					End
					oImprime:Disable()
					cEtiqueta := Space(_nTamEtiq)
					oEtiqueta:Refresh()
					oEtiqueta:SetFocus()
					Return (.f.)
				EndIf

				SB1->( dbSeek( xFilial() + aRetEmbala[1] ) )
				cProxEmb    := SB1->B1_DESC
				If lOkFlex
					If U_VALIDACAO("HELIO")  // 23/11/21
						If Alltrim(SB1->B1_GRUPO) == "CORD"
							nQProxEmb := Ceiling(aRetEmbala[2]/nQEmbAtu) //Arredondar para cima sempre
						EndIf
						If Alltrim(SB1->B1_GRUPO) =="0007"
							nQProxEmb := Ceiling(aRetEmbala[2]/nQEmbAtu) //Arredondar para cima sempre
						EndIf
						If Alltrim(SB1->B1_GRUPO) == "FLEX"
							nQProxEmb := Ceiling(aRetEmbala[2]/nQEmbAtu) //Arredondar para cima sempre
						EndIf
						If Alltrim(SB1->B1_GRUPO) == "PCON"
							nQProxEmb := Ceiling(aRetEmbala[2]/nQEmbAtu) //Arredondar para cima sempre
						EndIf
						If LEFT(ALLTRIM(SB1->B1_GRUPO),3) == "DIO"
							nQProxEmb := 1 //Sempre 1 para o DIO
							nQEmbAtu  := 1 //Sempre 1 para o DIO
						EndIf
						If !(Alltrim(SB1->B1_GRUPO) $ "CORD/0007/FLEX/PCON") .and. LEFT(ALLTRIM(SB1->B1_GRUPO),3) <> "DIO"  
							nQProxEmb := aRetEmbala[2]
						EndIf
					Else
						If ALLTRIM(SB1->B1_GRUPO) $ "CORD/0007/FLEX"  // PCON retirado em 04/11/21 por Helio/Ricardo
							nQProxEmb := Ceiling(aRetEmbala[2]/nQEmbAtu) //Arredondar para cima sempre
						ElseIf LEFT(ALLTRIM(SB1->B1_GRUPO),3) == "DIO"
							nQProxEmb := 1 //Sempre 1 para o DIO
							nQEmbAtu  := 1 //Sempre 1 para o DIO
						Else
							nQProxEmb := aRetEmbala[2]
						EndIf
					EndIf
				Else
					If ALLTRIM(SB1->B1_GRUPO) $ "CORD/0007"  // PCON retirado em 04/11/21 por Helio/Ricardo
						nQProxEmb := Ceiling(aRetEmbala[2]/nQEmbAtu)//Arredondar para cima sempre
					ElseIf LEFT(ALLTRIM(SB1->B1_GRUPO),3) == "DIO"
						nQProxEmb := 1 //Sempre 1 para o DIO
						nQEmbAtu  := 1 //Sempre 1 para o DIO
					Else
						nQProxEmb := aRetEmbala[2]
					EndIf
				EndIf
				If !SC2->(dbSeek(xFilial("SC2")+XD1->XD1_OP))
					While !MsgNoYes("OP Invalida. Numero = "+XD1->XD1_OP+"."+CHR(13)+"Deseja continuar?")
					End
					oImprime:Disable()
					cEtiqueta   := Space(_nTamEtiq)
					oEtiqueta:Refresh()
					oEtiqueta:SetFocus()
					Return ( .F. )
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica pendências de perda									³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If nQProxEmb >= (SC2->C2_QUANT - SC2->C2_QUJE)   // Trocado de C2_XXQUJE para C2_QUJE      por Hélio em 25/09/18
					If nPerdaBip > 0
						While !MsgNoYes("Ordem de Produção com perda em aberto. Separação não permitida."+CHR(13)+"Deseja continuar?")
						End
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
				If XD1->XD1_QTDATU > (SC2->C2_QUANT - SC2->C2_QUJE)   // Trocado de C2_XXQUJE para C2_QUJE      por Hélio em 25/09/18
					While !MsgNoYes("Quantidade da etiqueta é maior que o saldo da OP."+CHR(13)+"Saldo OP:"+Transform((SC2->C2_QUANT - SC2->C2_QUJE),"@E 999,999,999.9999")+CHR(13)+"Quantidade etiqueta:"+Transform(XD1->XD1_QTDATU,"@E 999,999,999.9999")+Chr(13)+"Deseja continuar?")   // Trocado de C2_XXQUJE para C2_QUJE      por Hélio em 25/09/18
					End
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
					XD1->XD1_OCORRE := "4"		// Etiqueta valida
					XD1->( MsUnlock() )
				EndIf
				cEtiqueta   := Space(_nTamEtiq)
				oEtiqueta:Refresh()
				oEtiqueta:SetFocus()
				oImprime:Enable()

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Imprime etiqueta de PA caso quantidade seja atingida	³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If nQtdBip == Round(nQProxEmb,0)  //.Or. ( lOkFlex .And. (nQtdBip + nQEmbAtu) == (SC2->C2_QUANT - SC2->C2_QUJE))
					oImprime:Disable()

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ImpEtqBip() - Aponta OP e imprime etiqueta de embalagem ³
					//³																		  ³
					//³cPARAM 01 - Numero da Peça										  ³
					//³cPARAM 01 - Numero da OP										  ³
					//³nPARAM 01 - Quantidade lida									  ³
					//³lPARAM 01 - Aponta OP (.T. = Sim | .F. = Não)			  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					ImpEtqBip(aQtdBip[1])

					aQtdBip  := {}
					aQtdEtiq := {}
					nQtdBip := 0
					nQtdKit := 0
					nContaN1:= 0
					nQtdGer := 0
					oQtdBip:Refresh()
					oUltima:Enable()
				Else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Imprime etiqueta de PA caso quantidade seja igual ao saldo da OP   	³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If nQtdBip == (SC2->C2_QUANT - SC2->C2_QUJE)   // Trocado de C2_XXQUJE para C2_QUJE      por Hélio em 25/09/18
						oImprime:Disable()

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ImpEtqBip() - Aponta OP e imprime etiqueta de embalagem ³
						//³																		  ³
						//³cPARAM 01 - Numero da Peça										  ³
						//³cPARAM 01 - Numero da OP										  ³
						//³nPARAM 01 - Quantidade lida									  ³
						//³lPARAM 01 - Aponta OP (.T. = Sim | .F. = Não)			  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						ImpEtqBip(aQtdBip[1])

						aQtdBip  := {}
						aQtdEtiq := {}
						nQtdBip  := 0
						nQtdKit  := 0
						nContaN1 := 0
						nQtdeGer := 0
						oQtdBip:Refresh()
						oUltima:Enable()
					EndIf
				EndIf

			EndIf

		Else

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³																		³
			//³																		³
			//³ LEITURA PARA SERIAL NUMBER									³
			//³																		³
			//³																		³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			If Len(aQtdBip) > 0
				While !MsgNoYes("Apontamento de etiqueta serial não permitido nesse momento, pois existe um apontamento de embalagem já iniciado."+CHR(13)+"Deseja continuar?")
				End
				/*
				If !MsgNoYes("Apontamento de etiqueta serial não permitido nesse momento, pois existe um apontamento de embalagem já iniciado."+CHR(13)+"Deseja continuar apontando etiquetas de embalagem?")
			cEtiqueta := Space(_nTamEtiq)
			aQtdBip   := {}
			aQtdEtiq  := {}
			nQtdBip   := 0
			nQtdKit   := 0
			nQProxEmb := 0
			cProxEmb  := SPACE(60)
			cEmbAtu	 := SPACE(60)
			nQEmbAtu  := 0
			oQEmbAtu:Refresh()
			oEmbAtu:Refresh()
			oProxEmb:Refresh()
			oQProxEmb:Refresh()
			oCliente:Refresh()
			oProduto:Refresh()
			oDescricao:Refresh()
			oQOpBip:Refresh()
			oSBip:Refresh()
			oPdVen:Refresh()
			oPdaOp:Refresh()
			oQtdBip:Refresh()
			oEtiqueta:Refresh()
			oEtiqueta:SetFocus()
			oImprime:Disable()
			Return (.F.)
				End
				*/

				oImprime:Disable()
				cEtiqueta := Space(_nTamEtiq)
				oEtiqueta:Refresh()
				oEtiqueta:SetFocus()
				Return (.F.)
			EndIF

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona na etiqueta bipada									³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			XD2->( dbSetOrder(2) )
			If XD2->( dbSeek( xFilial() + Padr(Alltrim(cEtiqOrig),TamSx3("XD2_PCFILH")[1]) ) )

				//Acrescentado para validar a etiqueta serial, que após a mudança da regra, ficou sem tamanho definido, e o indice estava se perdendo
				//para pesquisar o cpodigo já utilizado, a exemplo da etiqueta S92612 0100130, que estava retornando a S92612 01001300
				//Inio Vaidacao
				/*
			lAchouEtq := .T.
				If Left(AllTrim(cEtiqOrig),1) == "S"
				aAreaSave := GetArea()

				cQryXD2 := " SELECT COUNT(*) QTDETQ FROM XD2010 XD2 WHERE XD2.D_E_L_E_T_ ='' AND XD2.XD2_FILIAL ='' AND XD2.XD2_PCFILH = '" + Alltrim(cEtiqOrig) + "' "

					If Select("TXD2") > 0
					TXD2->(DbCloseArea())
					Endif
				TCQUERY cQryXD2 NEW ALIAS "TXD2"
					If !TXD2->(EOF())
						If TXD2->QTDETQ > 0
						lAchouEtq := .T.
						Else
						lAchouEtq := .F.
						EndIf
					Endif
				TXD2->(DbCloseArea())
				RestArea(aAreaSave)
				EndIf
         //Fim Validação
				If lAchouEtq
				*/
				MsgStop("Etiqueta serial lida já pertence a outra embalagem: "+XD2->XD2_XXPECA+".")
				oImprime:Disable()
				cEtiqueta := Space(_nTamEtiq)
				oEtiqueta:Refresh()
				oEtiqueta:SetFocus()
				Return (.F.)
				//EndIf
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona na OP da etiqueta bipada							³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Empty(cNumOpBip)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica status da OP											³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cNumOpBip := cOPnSerie
				oNumOpBip:Refresh()
				SC2->(dbSeek(xFilial("SC2")+cNumOpBip))

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica se Possui TAG Fornecedor na Tabela SC6 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				SC6->(DbSetOrder(1))
				If SC6->(DbSeek(SC2->C2_FILIAL + SC2->C2_PEDIDO + SC2->C2_ITEMPV + SC2->C2_PRODUTO))
					IF SC6->C6_XTAGFOR == "S"
						cTagFor := "Sim"
						oTagFor:Refresh()
					else
						cTagFor := "Não"
						oTagFor:Refresh()
					EndIf
				EndIf


				If (SC2->C2_QUANT - SC2->C2_QUJE) <= 0   // Trocado de C2_XXQUJE para C2_QUJE      por Hélio em 25/09/18
					While !MsgNoYes("Ordem de Produção já encerrada."+CHR(13)+"Deseja continuar?")
					End
					oImprime:Disable()
					cNumOpBip := SPACE(11)
					oNumOpBip:Refresh()
					cEtiqueta := Space(_nTamEtiq)
					oEtiqueta:Refresh()
					oEtiqueta:SetFocus()
					Return (.f.)
				EndIf

				//Verifica se existem OP's sepradas no picklist que ainda não constam na linha de produção através do roteiro.
				//XD1_OCORR == 8 Gerado Pelo PickList,  7=Lido na produção, foi transferido e está validado pelo tela de roteiro.

				//If (GetMv("MV_XVERROT") .or. (GetEnvServ() == 'VALIDACAO')) .And. AllTrim(Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_GRUPO")) == "DROP"

				// Validação de Roteiro
				lValidaRot := .F.
				If U_VALIDACAO()
					If cFilAnt == '01'
						If AllTrim(Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_GRUPO")) $ "DROP/CORD/PCON" .And. lComTravR  // PCON acrescentado em 04/11/21 por Helio/Ricardo
							lValidaRot := .T.
						EndIf
					EndIf
					If cFilAnt == '02'
						If AllTrim(Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_GRUPO")) $ "DROP" .And. lComTravR
							lValidaRot := .T.
						EndIf
					EndIf
				Else
					If AllTrim(Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_GRUPO")) $ "DROP/CORD/PCON" .And. cFilAnt <> "02" .And. lComTravR  // PCON acrescentado em 04/11/21 por Helio/Ricardo
						lValidaRot := .T.
					EndIf
				EndIf
				If lValidaRot
					nQtdEmbNv1 :=  Int(U_RetEmbala(SC2->C2_PRODUTO,"1")[2])

					nQTotPklOp  := 0
					nQPklOcor7 := 0
					nQPklOcor8 := 0
					nQPklOcor6 := 0
					aPklAreaAtu := GetArea()
					aPklAreaSc2 := SC2->(GetArea())
					cQryPkl := "SELECT XD1_FILIAL FILIAL,XD1_OP OP,COUNT(*) QTDETQ,ISNULL(TMP1.QTD7,0) QTD7,ISNULL(TMP2.QTD8,0) QTD8,ISNULL(TMP3.QTD6,0) QTD6 "
					cQryPkl += ENTER + " FROM " + RetSqlName("XD1") + " XD1 "
					cQryPkl += ENTER + " LEFT JOIN ( "
					cQryPkl += ENTER + " SELECT XD1_FILIAL FIL,XD1_OP OP,COUNT(*) QTD7 FROM " + RetSQlName("XD1") +"  XD11 "
					cQryPkl += ENTER + " JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = '' AND SB1.B1_FILIAL = '' AND SB1.B1_COD = XD11.XD1_COD AND B1_TIPO <> 'ME' AND B1_GRUPO <> 'DIV' "
					cQryPkl += ENTER + " WHERE XD11.D_E_L_E_T_ ='' AND XD11.XD1_FILIAL <> '' AND XD11.XD1_OCORRE = '7' GROUP BY XD11.XD1_FILIAL,XD11.XD1_OP "
					cQryPkl += ENTER + " ) TMP1 ON TMP1.FIL= XD1.XD1_FILIAL AND TMP1.OP = XD1.XD1_OP  "
					cQryPkl += ENTER + " LEFT JOIN ( "
					cQryPkl += ENTER + " SELECT XD1_FILIAL FIL,XD1_OP OP,COUNT(*) QTD8 FROM " + RetSqlName("XD1") + " XD11 "
					cQryPkl += ENTER + " JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = '' AND SB1.B1_FILIAL = '' AND SB1.B1_COD = XD11.XD1_COD AND B1_TIPO <> 'ME' AND B1_GRUPO <> 'DIV' "
					cQryPkl += ENTER + " WHERE XD11.D_E_L_E_T_ ='' AND XD11.XD1_FILIAL <> '' AND XD11.XD1_OCORRE = '8' GROUP BY XD11.XD1_FILIAL,XD11.XD1_OP "
					cQryPkl += ENTER + " ) TMP2 ON TMP2.FIL= XD1.XD1_FILIAL AND TMP2.OP = XD1.XD1_OP  "
					cQryPkl += ENTER + " LEFT JOIN ( "
					cQryPkl += ENTER + " SELECT XD1_FILIAL FIL,XD1_OP OP,COUNT(*) QTD6 FROM " + RetSqlName("XD1") + " XD11 "
					cQryPkl += ENTER + " JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = '' AND SB1.B1_FILIAL = '' AND SB1.B1_COD = XD11.XD1_COD AND B1_TIPO <> 'ME' AND B1_GRUPO <> 'DIV' "
					cQryPkl += ENTER + " WHERE XD11.D_E_L_E_T_ ='' AND XD11.XD1_FILIAL <> '' AND XD11.XD1_OCORRE = '6' GROUP BY XD11.XD1_FILIAL,XD11.XD1_OP "
					cQryPkl += ENTER + " ) TMP3 ON TMP3.FIL= XD1.XD1_FILIAL AND TMP3.OP = XD1.XD1_OP  "
					cQryPkl += ENTER + " WHERE XD1.D_E_L_E_T_ ='' "
					cQryPkl += ENTER + " AND XD1.XD1_OP = '" + SC2->C2_NUM + SC2->C2_ITEM  + SC2->C2_SEQUEN + "' "
					cQryPkl += ENTER + " AND XD1_OCORRE   IN ( '8','7','6') "
					cQryPkl += ENTER + " GROUP BY XD1.XD1_FILIAL,XD1.XD1_OP,TMP1.QTD7,TMP2.QTD8,TMP3.QTD6 "
					If Select("TPKL") > 0
						TPKL->(DBCloseArea())
					EndIf
					TCQUERY cQryPkl NEW ALIAS "TPKL"
					If TPKL->(!EOF())
						nQTotPklOp  := TPKL->QTDETQ
						nQPklOcor7 := TPKL->QTD7
						nQPklOcor8 := TPKL->QTD8
						nQPklOcor6 := TPKL->QTD6
					EndIf
					If Select("TPKL") > 0
						TPKL->(DBCloseArea())
					EndIf

					If nQPklOcor8 > 0 .And. nQPklOcor7 == 0 //.And. nQPklOcor6 == 0 //.Or. nQPklOcor6 > 0)
						While !MsgNoYes("."+CHR(13)+"Existem " +AlltriM(Str(nQPklOcor8)) + " Etiqueta(s) que não foram validadas no roteiro." + ENTER +;
								" Não será possivel iniciar o Processo!")
						End
						oImprime:Disable()
						cNumOpBip := SPACE(11)
						oNumOpBip:Refresh()
						cEtiqueta := Space(_nTamEtiq)
						oEtiqueta:Refresh()
						oEtiqueta:SetFocus()
						Return (.f.)

					EndIf
					//MsgAlert("Verificar quantidade de Fibra")
					/********************************************************************************
						Validar a Quantidade de Fibra Bipada na rotina de roteiro.
					*********************************************************************************/

					nQTotFibra := 0
					//cQryPkl := 	" SELECT COUNT(*) QTDETIQ,  ISNULL(SUM(XD1_QTDORI),0)  QTDFIBRA  FROM  " + RetSqlName("XD1") + "  XD1 "
					//cQryPkl += ENTER + " JOIN  " + RetSqlName("SB1") + " SB1 ON SB1.B1_FILIAL  ='" +  xFilial("SB1") +  "' AND  SB1.D_E_L_E_T_ = '' AND SB1.B1_COD =XD1.XD1_COD AND SB1.B1_TIPO= 'MP' AND SB1.B1_GRUPO IN ('FO','FOFS') "
					//cQryPkl += ENTER + " WHERE XD1.XD1_FILIAL = '" + xFilial("XD1") + "' "
					//cQryPkl += ENTER + " AND XD1.XD1_OP = '" + SC2->C2_NUM + SC2->C2_ITEM  + SC2->C2_SEQUEN + "' "
					//cQryPkl += ENTER + " AND XD1.XD1_OCORRE = '7' "

					cQryPkl := 	" SELECT  COUNT(*) QTDETIQ, COUNT(*)  QTDFIBRA  "
					cQryPkl += ENTER + " FROM " + RetSqlName("XD4") + " XD4 "
					cQryPkl += ENTER + " WHERE XD4.D_E_L_E_T_ ='' "
					cQryPkl += ENTER + " AND XD4_OP= '" + SC2->C2_NUM + SC2->C2_ITEM  + SC2->C2_SEQUEN + "' AND XD4_STATUS ='2'"

					TCQUERY cQryPkl NEW ALIAS "TPKL"
					If TPKL->(!EOF())
						nQTotFibra  := TPKL->QTDFIBRA
					EndIf
					If Select("TPKL") > 0
						TPKL->(DBCloseArea())
					EndIf
					
					nQtTotN1 := 0
					cQryCont := " SELECT SUM(XD1_QTDATU) QTDPECA "
					cQryCont += " FROM " + RetSqlName("XD1") + " WHERE D_E_L_E_T_ ='' AND XD1_FILIAL = '" + xFilial("XD1") + "' "
					cQryCont += " AND XD1_OP ='" +cNumOpBip + "' AND XD1_OCORRE <> '5' "
					cQryCont += " AND XD1_NIVEMB = '1' "
					If Select("TMPN1") > 0 
						TMPN1->(DbCloseArea())
					Endif
					TCQUERY cQryCont NEW ALIAS "TMPN1"
					If TMPN1->(!EOF())									
						nQtTotN1 := TMPN1->QTDPECA								
					EndIf
					TMPN1->(dbCloseArea())


					If  (nQtdEmbNv1 > nQTotFibra) .Or.  ((nQtdEmbNv1 + nQtTotN1)  > nQTotFibra)
						While !MsgNoYes("."+CHR(13)+"A quantidade de Fibra bipada na entrada da linha é insuficiente para " + ENTER +;
								"dar continuidade no Processo!")
						End
						oImprime:Disable()
						cNumOpBip := SPACE(11)
						oNumOpBip:Refresh()
						cEtiqueta := Space(_nTamEtiq)
						oEtiqueta:Refresh()
						oEtiqueta:SetFocus()
						Return (.f.)
					EndIf

					RestArea(aPklAreaSc2)
					RestArea(aPklAreaAtu)
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica se OP é intermediária de KIT Pigtail			³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If (GetMv("MV_XVERKIT") .And. Alltrim(Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_XKITPIG"))=="S")  //.or. (GetEnvServ() == 'VALIDACAO')
					If SC2->(dbSeek(xFilial("SC2")+SubStr(cNumOpBip,1,8)))
						nVerKits := 0
						cOldOpBip := cNumOpBip
						Do While SC2->(!Eof()) .And. SC2->C2_NUM+SC2->C2_ITEM==SubStr(cNumOpBip,1,8)
							If Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_XKITPIG")=="S"
								aRetEmbala := fEmbKitPig(SC2->C2_PRODUTO, "1")
								cNumOpBip  := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
								nVerKits++
								//MSGALERT("QTD ESTRUTURA" + STR(nVerKits))
							EndIf
							SC2->(dbSkip())
						EndDo

						If nVerKits > 1
							While !MsgNoYes("Estrutura do produto possui mais de um kit de pigtail. "+CHR(13)+"Deseja continuar?")
							End
							oImprime:Disable()
							cEtiqueta := Space(_nTamEtiq)
							oEtiqueta:Refresh()
							oEtiqueta:SetFocus()
							Return (.f.)
						EndIf
						If nVerKits == 1
							cProxNiv   := aRetEmbala[3]
							cProxEmb   := Posicione("SB1",1,xFilial("SB1")+aRetEmbala[1],"B1_DESC")
							SC2->(dbSeek(xFilial("SC2")+AllTrim(cNumOpBip)))
							nQProxEmb  := IIF(aRetEmbala[2] < 1,1,aRetEmbala[2])
							//MSGALERT("QTD EMBALAGEM" + STR(nQProxEmb))
							//IF nQProxEmb == 0
							// 	nQProxEmb := 1
							// 	nQEmbAtu  := 1
							//EndIf
							nQtdEmb	  := nQProxEmb
							oQProxEmb:Refresh()
							oProxEmb:Refresh()
							oNumOpBip:Refresh()
						EndIf
						If nVerKits == 0
							SC2->(dbSeek(xFilial("SC2")+AllTrim(cOldOpBip)))
						EndIf
					EndIf
				EndIf

				SB1->( dbSetOrder(1) )
				SB1->( dbSeek( xFilial() + SC2->C2_PRODUTO ) )
				If SB1->B1_XKITPIG <> "S" .or. !GetMv("MV_XVERKIT")

					cVerUsoGr := AllTrim(Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_GRUPO"))

					If lOkFlex
						If Alltrim(cVerUsoGr) $ "CORD/0007/JUMP/FLEX"  // PCON retirado em 04/11/21 por Helio/Ricardo

							cProxNiv   := "2"
							aRetEmbala := U_RetEmbala(SC2->C2_PRODUTO,cProxNiv)
							cProxEmb   := Posicione("SB1",1,xFilial("SB1")+aRetEmbala[1],"B1_DESC")
							nQProxEmb  := Int(aRetEmbala[2])
							oQProxEmb:Refresh()
							oProxEmb:Refresh()

							If Empty(aRetEmbala[1])
								While !MsgNoYes("Embalagem Nível '"+cProxNiv+"' não cadastrada na estrutura do produto desta OP."+CHR(13)+"Deseja continuar?")
								End
								oImprime:Disable()
								cEtiqueta := Space(_nTamEtiq)
								oEtiqueta:Refresh()
								oEtiqueta:SetFocus()
								Return (.f.)
							EndIf

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Contando etiquetas nivel 1 para não permitir impressão acima da qtd.embalagem		³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							cQuery := "SELECT XD1_XXPECA FROM " + RetSqlName("XD1") + " (NOLOCK) WHERE "
							cQuery += "XD1_OP = '"+cNumOpBip+"' AND XD1_NIVEMB = '1' AND XD1_OCORRE <> '5' AND XD1_USERID='"+RetCodUsr()+"' AND D_E_L_E_T_ = ''"

							If Select("CNIVEL1") <> 0
								CNIVEL1->( dbCloseArea() )
							EndIf

							TCQUERY cQuery NEW ALIAS "CNIVEL1"

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Procura as etiquetas de próximo nível de embalagem											³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							nContaN1 := 0

							XD2->( dbSetOrder(2) )	// Filha + Etiqueta Pai
							cXD2_FILIAL := XD2->( xFilial() )
							While !CNIVEL1->( EOF() )
								If !XD2->( dbSeek( cXD2_FILIAL + CNIVEL1->XD1_XXPECA ) )
									nContaN1++
								EndIf
								CNIVEL1->( dbSkip() )
							End
							CNIVEL1->(dbCloseArea())
	

							//Contar Já apontadas
							If lOkFlex								
								nQtTotN1 := 0
								cQryCont := " SELECT SUM(XD1_QTDATU) QTDPECA "
								cQryCont += " FROM " + RetSqlName("XD1") + " WHERE D_E_L_E_T_ ='' AND XD1_FILIAL = '" + xFilial("XD1") + "' "
								cQryCont += " AND XD1_OP ='" +cNumOpBip + "' AND XD1_OCORRE <> '5' AND XD1_COD = '" + SC2->C2_PRODUTO + "' "
								cQryCont += " AND XD1_NIVEMB = '1' "
								If Select("TMPN1") > 0 
									TMPN1->(DbCloseArea())
								Endif
								TCQUERY cQryCont NEW ALIAS "TMPN1"
								If TMPN1->(!EOF())									
									nQtTotN1 := TMPN1->QTDPECA								
								EndIf
								TMPN1->(dbCloseArea())
							EndIf
						
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Verifica se operador dispõe de embalagens nível 1 prontas e não utilizadas			³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If nContaN1 > 0
								If !MsgYesNo("Quantidade da próxima embalagem = "+AllTrim(Str(Round(nQProxEmb,0)))+Chr(13)+Chr(13)+"Quantidade disponíveis          = "+AllTrim(Str(nContaN1))+Chr(13)+Chr(13)+"Deseja iniciar embalagens?")
									oImprime:Disable()
									cEtiqueta := Space(_nTamEtiq)
									oEtiqueta:Refresh()
									oEtiqueta:SetFocus()
									Return (.f.)
								EndIf
								nQtdGer := nContaN1
							EndIf

						EndIf
					Else
						If Alltrim(cVerUsoGr) $ "CORD/0007/JUMP"  // PCON retirado em 04/11/21 por Helio/Ricardo

							cProxNiv   := "2"
							aRetEmbala := U_RetEmbala(SC2->C2_PRODUTO,cProxNiv)
							cProxEmb   := Posicione("SB1",1,xFilial("SB1")+aRetEmbala[1],"B1_DESC")
							nQProxEmb  := aRetEmbala[2]
							oQProxEmb:Refresh()
							oProxEmb:Refresh()

							If Empty(aRetEmbala[1])
								While !MsgNoYes("Embalagem Nível '"+cProxNiv+"' não cadastrada na estrutura do produto desta OP."+CHR(13)+"Deseja continuar?")
								End
								oImprime:Disable()
								cEtiqueta := Space(_nTamEtiq)
								oEtiqueta:Refresh()
								oEtiqueta:SetFocus()
								Return (.f.)
							EndIf

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Contando etiquetas nivel 1 para não permitir impressão acima da qtd.embalagem		³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							cQuery := "SELECT XD1_XXPECA FROM " + RetSqlName("XD1") + " (NOLOCK) WHERE "
							cQuery += "XD1_OP = '"+cNumOpBip+"' AND XD1_NIVEMB = '1' AND XD1_OCORRE <> '5' AND XD1_USERID='"+RetCodUsr()+"' AND D_E_L_E_T_ = ''"

							If Select("CNIVEL1") <> 0
								CNIVEL1->( dbCloseArea() )
							EndIf

							TCQUERY cQuery NEW ALIAS "CNIVEL1"

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Procura as etiquetas de próximo nível de embalagem											³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							nContaN1 := 0
							XD2->( dbSetOrder(2) )	// Filha + Etiqueta Pai
							cXD2_FILIAL := XD2->( xFilial() )
							While !CNIVEL1->( EOF() )								
								If !XD2->( dbSeek( cXD2_FILIAL + CNIVEL1->XD1_XXPECA ) )
									nContaN1++
								EndIf
								CNIVEL1->( dbSkip() )
							End

							CNIVEL1->(dbCloseArea())

							nQtTotN1 := 0
							cQryCont := " SELECT SUM(XD1_QTDATU) QTDPECA "
							cQryCont += " FROM " + RetSqlName("XD1") + " WHERE D_E_L_E_T_ ='' AND XD1_FILIAL = '" + xFilial("XD1") + "' "
							cQryCont += " AND XD1_OP ='" +cNumOpBip + "' AND XD1_OCORRE <> '5' AND XD1_COD = '" + SC2->C2_PRODUTO + "' "
							cQryCont += " AND XD1_NIVEMB = '1' "
							If Select("TMPN1") > 0 
								TMPN1->(DbCloseArea())
							Endif
							TCQUERY cQryCont NEW ALIAS "TMPN1"
							If TMPN1->(!EOF())									
								nQtTotN1 := TMPN1->QTDPECA								
							EndIf
							TMPN1->(dbCloseArea())
						
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Verifica se operador dispõe de embalagens nível 1 prontas e não utilizadas			³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If nContaN1 > 0
								If !MsgYesNo("Quantidade da próxima embalagem = "+AllTrim(Str(Round(nQProxEmb,0)))+Chr(13)+Chr(13)+"Quantidade disponíveis          = "+AllTrim(Str(nContaN1))+Chr(13)+Chr(13)+"Deseja iniciar embalagens?")
									oImprime:Disable()
									cEtiqueta := Space(_nTamEtiq)
									oEtiqueta:Refresh()
									oEtiqueta:SetFocus()
									Return (.f.)
								EndIf
								nQtdGer := nContaN1
							EndIf

						EndIf
					EndIf
				EndIf

				SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
				SA1->(dbSeek(xFilial("SA1")+SC2->C2_CLIENT))

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica se o Cliente é OI S/A								³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If GetMv("MV_XVEROI")
					lOi := .F.
					If ("OI S" $ Upper(SA1->A1_NOME)) .Or. ("OI MO" $ Upper(SA1->A1_NOME)) .Or. ("OI MOVEL" $ Upper(SA1->A1_NOME)) .Or. ("TELEMAR" $ Upper(SA1->A1_NOME)) .Or. ("BRASIL TELECOM COMUNICACAO MUL" $ Upper(SA1->A1_NOME))
						lOi := .T.
					Else
						lUltOi := .F.
					EndIf
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica se o Cliente é ERICSSON								³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lEricsson := .F.
				If ("ERICSSON" $ Upper(SA1->A1_NOME)) .Or. ("ERICSSON" $ Upper(SA1->A1_NREDUZ))
					lEricsson := .T.
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica se o Cliente é FURUKAWA						³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lEhFuruka := .F.
				If ("FURUKAWA" $ Upper(SA1->A1_NOME)) .Or. ("FURUKAWA" $ Upper(SA1->A1_NREDUZ))
					lEhFuruka := .T.
				EndIf


				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica Etique HUAWEI
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

				cProdBip  := SB1->B1_COD
				cDescBip  := SB1->B1_DESC
				cCliBip   := SA1->A1_NOME
				nQtdOpBip := SC2->C2_QUANT
				cPedBip   := SC2->C2_PEDIDO
				nSaldoBip := (SC2->C2_QUANT - SC2->C2_QUJE)   // Trocado de C2_XXQUJE para C2_QUJE      por Hélio em 25/09/18
				oCliente:Refresh()
				oProduto:Refresh()
				oDescricao:Refresh()
				oQOpBip:Refresh()
				oSBip:Refresh()
				oPdVen:Refresh()
				oPdaOp:Refresh()

			Else  // Empty(cNumOpBip)
					
				If SC2->(dbSeek(xFilial("SC2")+cOPnSerie))
					If (SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN) <> cNumOpBip
						If (SC2->C2_QUANT - SC2->C2_QUJE) <= 0   // Trocado de C2_XXQUJE para C2_QUJE      por Hélio em 25/09/18
							While !MsgNoYes("Ordem de Produção já encerrada."+CHR(13)+"Deseja continuar?")
							End
							SC2->(dbSeek(xFilial("SC2")+cOPnSerie))
							oImprime:Disable()
							cNumOpBip := (SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
							oNumOpBip:Refresh()
							cEtiqueta := Space(_nTamEtiq)
							oEtiqueta:Refresh()
							oEtiqueta:SetFocus()
							Return (.f.)
						EndIf
						lCont := MsgNoYes("Esse produto pertence a outra Ordem de Produção."+CHR(13)+"Deseja continuar?")
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
							cNumOpBip := cOPnSerie
							oNumOpBip:Refresh()
							SC2->(dbSeek(xFilial("SC2")+cNumOpBip))
							SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
							SA1->(dbSeek(xFilial("SA1")+SC2->C2_CLIENT))
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Verifica se o Cliente é OI S/A								³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If GetMv("MV_XVEROI")
								lOi := .F.
								If ("OI S" $ Upper(SA1->A1_NOME)) .Or. ("OI MO" $ Upper(SA1->A1_NOME)) .Or. ("OI MOVEL" $ Upper(SA1->A1_NOME)) .Or. ("TELEMAR" $ Upper(SA1->A1_NOME)) .Or. ("BRASIL TELECOM COMUNICACAO MUL" $ Upper(SA1->A1_NOME))
									lOi := .T.
								Else
									lUltOi := .F.
								EndIf
							EndIf

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Verifica se o Cliente é ERICSSON								³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							lEricsson := .F.

							If ("ERICSSON" $ Upper(SA1->A1_NOME)) .Or. ("ERICSSON" $ Upper(SA1->A1_NREDUZ))
								lEricsson := .T.
							EndIf
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Verifica se o Cliente é FURUKAWA						³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							lEhFuruka := .F.
							If ("FURUKAWA" $ Upper(SA1->A1_NOME)) .Or. ("FURUKAWA" $ Upper(SA1->A1_NREDUZ))
								lEhFuruka := .T.
							EndIf
				

							cProdBip  := SB1->B1_COD
							cDescBip  := SB1->B1_DESC
							cCliBip   := SA1->A1_NOME
							nQtdOpBip := SC2->C2_QUANT
							cPedBip   := SC2->C2_PEDIDO
							nSaldoBip := (SC2->C2_QUANT - SC2->C2_QUJE)   // Trocado de C2_XXQUJE para C2_QUJE      por Hélio em 25/09/18
							cEtiqueta := Space(_nTamEtiq)
							aQtdBip   := {}
							aQtdEtiq  := {}
							nQtdBip   := 0
							nQtdKit   := 0
							nQProxEmb := 0
							nContaN1  := 0
							cProxEmb  := SPACE(60)
							cEmbAtu	 := SPACE(60)
							nQEmbAtu  := 0
							oQEmbAtu:Refresh()
							oEmbAtu:Refresh()
							oProxEmb:Refresh()
							oQProxEmb:Refresh()
							oCliente:Refresh()
							oProduto:Refresh()
							oDescricao:Refresh()
							oQOpBip:Refresh()
							oSBip:Refresh()
							oPdVen:Refresh()
							oPdaOp:Refresh()
							oQtdBip:Refresh()
							oEtiqueta:Refresh()
							oEtiqueta:SetFocus()
							oImprime:Disable()
							Return (.F.)
						EndIf
					EndIf
				EndIf
			EndIf
			//Verifica se existem OP's sepradas no picklist que ainda não constam na linha de produção através do roteiro.
			//XD1_OCORR == 8 Gerado Pelo PickList,  7=Lido na produção, foi transferido e está validado pelo tela de roteiro.

			//If (GetMv("MV_XVERROT") .or. (GetEnvServ() == 'VALIDACAO')) .And. AllTrim(Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_GRUPO")) == "DROP"
			//If AllTrim(Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_GRUPO")) $ "DROP/CORD/PCON" .And. cFilAnt <> "02" .And. lComTravR // PCON acrescentado em 04/11/21 por Helio/Ricardo
			// Validação de Roteiro
			lValidaRot := .F.
			If U_VALIDACAO()
				If cFilAnt == '01'
					If AllTrim(Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_GRUPO")) $ "DROP/CORD/PCON" .And. lComTravR  // PCON acrescentado em 04/11/21 por Helio/Ricardo
						lValidaRot := .T.
					EndIf
				EndIf
				If cFilAnt == '02'
					If AllTrim(Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_GRUPO")) $ "DROP" .And. lComTravR
						lValidaRot := .T.
					EndIf
				EndIf
			Else
				If AllTrim(Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_GRUPO")) $ "DROP/CORD/PCON" .And. cFilAnt <> "02" .And. lComTravR  // PCON acrescentado em 04/11/21 por Helio/Ricardo
					lValidaRot := .T.
				EndIf
			EndIf
			If lValidaRot 
				If !Alltrim(SC2->C2_OBS) $ "SEMTRAVAROTEIRO"
					nQtdEmbNv1 :=  Int(U_RetEmbala(SC2->C2_PRODUTO,"1")[2])
					
					nQTotPklOp  := 0
					nQPklOcor7 := 0
					nQPklOcor8 := 0
					nQPklOcor6 := 0
					aPklAreaAtu := GetArea()
					aPklAreaSc2 := SC2->(GetArea())
					cQryPkl := "SELECT XD1_FILIAL FILIAL,XD1_OP OP,COUNT(*) QTDETQ,ISNULL(TMP1.QTD7,0) QTD7,ISNULL(TMP2.QTD8,0) QTD8,ISNULL(TMP3.QTD6,0) QTD6 "
					cQryPkl += ENTER + " FROM " + RetSqlName("XD1") + " XD1 "
					cQryPkl += ENTER + " LEFT JOIN ( "
					cQryPkl += ENTER + " SELECT XD1_FILIAL FIL,XD1_OP OP,COUNT(*) QTD7 FROM " + RetSQlName("XD1") +"  XD11 "
					cQryPkl += ENTER + " JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = '' AND SB1.B1_FILIAL = '' AND SB1.B1_COD = XD11.XD1_COD AND B1_TIPO <> 'ME' AND B1_GRUPO <> 'DIV' "
					cQryPkl += ENTER + " WHERE XD11.D_E_L_E_T_ ='' AND XD11.XD1_FILIAL <> '' AND XD11.XD1_OCORRE = '7' GROUP BY XD11.XD1_FILIAL,XD11.XD1_OP "
					cQryPkl += ENTER + " ) TMP1 ON TMP1.FIL= XD1.XD1_FILIAL AND TMP1.OP = XD1.XD1_OP  "
					cQryPkl += ENTER + " LEFT JOIN ( "
					cQryPkl += ENTER + " SELECT XD1_FILIAL FIL,XD1_OP OP,COUNT(*) QTD8 FROM " + RetSqlName("XD1") + " XD11 "
					cQryPkl += ENTER + " JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = '' AND SB1.B1_FILIAL = '' AND SB1.B1_COD = XD11.XD1_COD AND B1_TIPO <> 'ME' AND B1_GRUPO <> 'DIV' "
					cQryPkl += ENTER + " WHERE XD11.D_E_L_E_T_ ='' AND XD11.XD1_FILIAL <> '' AND XD11.XD1_OCORRE = '8' GROUP BY XD11.XD1_FILIAL,XD11.XD1_OP "
					cQryPkl += ENTER + " ) TMP2 ON TMP2.FIL= XD1.XD1_FILIAL AND TMP2.OP = XD1.XD1_OP  "
					cQryPkl += ENTER + " LEFT JOIN ( "
					cQryPkl += ENTER + " SELECT XD1_FILIAL FIL,XD1_OP OP,COUNT(*) QTD6 FROM " + RetSqlName("XD1") + " XD11 "
					cQryPkl += ENTER + " JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = '' AND SB1.B1_FILIAL = '' AND SB1.B1_COD = XD11.XD1_COD AND B1_TIPO <> 'ME' AND B1_GRUPO <> 'DIV' "
					cQryPkl += ENTER + " WHERE XD11.D_E_L_E_T_ ='' AND XD11.XD1_FILIAL <> '' AND XD11.XD1_OCORRE = '6' GROUP BY XD11.XD1_FILIAL,XD11.XD1_OP "
					cQryPkl += ENTER + " ) TMP3 ON TMP3.FIL= XD1.XD1_FILIAL AND TMP3.OP = XD1.XD1_OP  "
					cQryPkl += ENTER + " WHERE XD1.D_E_L_E_T_ ='' "
					cQryPkl += ENTER + " AND XD1.XD1_OP = '" + SC2->C2_NUM + SC2->C2_ITEM  + SC2->C2_SEQUEN + "' "
					cQryPkl += ENTER + " AND XD1_OCORRE   IN ( '8','7','6') "
					cQryPkl += ENTER + " GROUP BY XD1.XD1_FILIAL,XD1.XD1_OP,TMP1.QTD7,TMP2.QTD8,TMP3.QTD6 "
					If Select("TPKL") > 0
						TPKL->(DBCloseArea())
					EndIf
					TCQUERY cQryPkl NEW ALIAS "TPKL"
					If TPKL->(!EOF())
						nQTotPklOp  := TPKL->QTDETQ
						nQPklOcor7 := TPKL->QTD7
						nQPklOcor8 := TPKL->QTD8
						nQPklOcor6 := TPKL->QTD6
					EndIf
					If Select("TPKL") > 0
						TPKL->(DBCloseArea())
					EndIf

					If nQPklOcor8 > 0   .And. nQPklOcor7 == 0 //.And. nQPklOcor6 == 0 //.Or. nQPklOcor6 > 0)
						While !MsgNoYes("."+CHR(13)+"Existem " +AlltriM(Str(nQPklOcor8)) + " Etiqueta(s) que não foram validadas no roteiro." + ENTER +;
								" Não será possivel iniciar o Processo!")
						End
						oImprime:Disable()
						cNumOpBip := SPACE(11)
						oNumOpBip:Refresh()
						cEtiqueta := Space(_nTamEtiq)
						oEtiqueta:Refresh()
						oEtiqueta:SetFocus()
						Return (.f.)

					EndIf
					//MsgAlert("Verificar quantidade de Fibra")
					/********************************************************************************
						Validar a Quantidade de Fibra Bipada na rotina de roteiro.
					*********************************************************************************/

					nQTotFibra := 0
					//cQryPkl := 	" SELECT COUNT(*) QTDETIQ,  ISNULL(SUM(XD1_QTDORI),0)  QTDFIBRA  FROM  " + RetSqlName("XD1") + "  XD1 "
					//cQryPkl += ENTER + " JOIN  " + RetSqlName("SB1") + " SB1 ON SB1.B1_FILIAL  ='" +  xFilial("SB1") +  "' AND  SB1.D_E_L_E_T_ = '' AND SB1.B1_COD =XD1.XD1_COD AND SB1.B1_TIPO= 'MP' AND SB1.B1_GRUPO IN ('FO','FOFS') "
					//cQryPkl += ENTER + " WHERE XD1.XD1_FILIAL = '" + xFilial("XD1") + "' "
					//cQryPkl += ENTER + " AND XD1.XD1_OP = '" + SC2->C2_NUM + SC2->C2_ITEM  + SC2->C2_SEQUEN + "' "
					//cQryPkl += ENTER + " AND XD1.XD1_OCORRE = '7' "

					cQryPkl := 	" SELECT  COUNT(*) QTDETIQ, COUNT(*)  QTDFIBRA  "
					cQryPkl += ENTER + " FROM " + RetSqlName("XD4") + " XD4 "
					cQryPkl += ENTER + " WHERE XD4.D_E_L_E_T_ ='' "
					cQryPkl += ENTER + " AND XD4_OP= '" + SC2->C2_NUM + SC2->C2_ITEM  + SC2->C2_SEQUEN + "' AND XD4_STATUS ='2'"

					TCQUERY cQryPkl NEW ALIAS "TPKL"
					If TPKL->(!EOF())
						nQTotFibra  := TPKL->QTDFIBRA
					EndIf
					If Select("TPKL") > 0
						TPKL->(DBCloseArea())
					EndIf
					
					nQtTotN1 := 0
					cQryCont := " SELECT SUM(XD1_QTDATU) QTDPECA "
					cQryCont += " FROM " + RetSqlName("XD1") + " WHERE D_E_L_E_T_ ='' AND XD1_FILIAL = '" + xFilial("XD1") + "' "
					cQryCont += " AND XD1_OP ='" +cNumOpBip + "' AND XD1_OCORRE <> '5' "
					cQryCont += " AND XD1_NIVEMB = '1' "
					If Select("TMPN1") > 0 
						TMPN1->(DbCloseArea())
					Endif
					TCQUERY cQryCont NEW ALIAS "TMPN1"
					If TMPN1->(!EOF())									
						nQtTotN1 := TMPN1->QTDPECA								
					EndIf
					TMPN1->(dbCloseArea())


					If  (nQtdEmbNv1 > nQTotFibra) .Or.  ((nQtdEmbNv1 + nQtTotN1)  > nQTotFibra)
						While !MsgNoYes("."+CHR(13)+"A quantidade de Fibra bipada na entrada da linha é insuficiente para " + ENTER +;
								"dar continuidade no Processo!")
						End
						oImprime:Disable()
						cNumOpBip := SPACE(11)
						oNumOpBip:Refresh()
						cEtiqueta := Space(_nTamEtiq)
						oEtiqueta:Refresh()
						oEtiqueta:SetFocus()
						Return (.f.)
					EndIf

					RestArea(aPklAreaSc2)
					RestArea(aPklAreaAtu)
				else
					MsgStop("Essa OP já teve apontamento na rotina sem trava de roteiro, e deve continuar a ser apontado sem a trava!","Apontar na Rotina Sem Trava")
					Return (.f.)
				EndIf
			else
				//Gravar informação que foi utilizado o ambiente sem trava de roteiro para controlar alteração.
				If Empty(Alltrim(SC2->C2_OBS))
					RecLock("SC2",.F.)
						SC2->C2_OBS := "SEMTRAVAROTEIRO"
					SC2->(MsUnlock())
				EndIf
			EndIf

			If GetMv("MV_XVERHUA")
				If "HUAWEI DO BRASIL" $ Upper(SA1->A1_NOME) .And. AllTrim(Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_XKITPIG")) <> "S"
					//If nRadio == 1 // Embalagem SEM Etiqueta de Fornecedor

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifica CodBar Huawei											³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nLin  	 := 03
					nCol1 	 := 03
					nOpcHuaw  := 0
					cCodHuawei := SPACE(100)//SPACE(Len(XD1->XD1_ETQHUA))
					cCdHuawei2 := SPACE(100)
					DEFINE MSDIALOG oDlgHuawei TITLE OemToAnsi("Valida Código de Barras") FROM 0,0 TO 140,350 PIXEL //300,400 PIXEL of oMainWnd PIXEL
						
						
						@ nLin+2, nCol1 SAY oTexto01 Var 'Código PSN' SIZE 100,10 OF oDlgHuawei PIXEL
						oTexto01:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)

						@ nLin, nCol1+35 MSGET oCodHuawei VAR cCodHuawei SIZE 120,10 PICTURE "@!" WHEN .T. VALID VCodHuawei() OF oDlgHuawei PIXEL
						oCodHuawei:oFont := TFont():New('Courier New',,14,,.T.,,,,.T.,.F.)

						nLin += 15


						@ nLin+2, nCol1 SAY oTexto02 Var 'Código SN' SIZE 100,10 OF oDlgHuawei PIXEL
						oTexto02:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
					
						@ nLin, nCol1+35 MSGET oCdHuawei2 VAR cCdHuawei2 SIZE 120,10 PICTURE "@!" WHEN .T. VALID VCdHuawei2() OF oDlgHuawei PIXEL
						oCdHuawei2:oFont := TFont():New('Courier New',,14,,.T.,,,,.T.,.F.)

						nLin += 15
											
						

						
						
						@ nLin, nCol1+070 BUTTON oConfHuaw PROMPT "Ok" ACTION {|| oDlgHuawei:End()} SIZE 30,10 PIXEL OF oDlgHuawei

					ACTIVATE MSDIALOG oDlgHuawei CENTER

					If Empty(cCodHuawei)
						While !MsgNoYes("Código de barras Huawei inválido"+ CHR(13)+Chr(13)+"Deseja continuar?")
						End
						oImprime:Disable()
						cNumOpBip := SPACE(11)
						oNumOpBip:Refresh()
						cEtiqueta := Space(_nTamEtiq)
						oEtiqueta:Refresh()
						oEtiqueta:SetFocus()
						Return (.f.)
					Else

					EndIf
					//EndIf
				EndIf
			EndIf

			If AllTrim(Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_XKITPIG")) <> "S" .or. !GetMv("MV_XVERKIT")


				oUltima:Disable()
				cSerNiv    := "1"
				aRetEmbala := U_RetEmbala(SC2->C2_PRODUTO,"1")
				cEmbAtu    := Posicione("SB1",1,xFilial("SB1")+aRetEmbala[1],"B1_DESC")
				_cGrupoUso := Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_GRUPO")
				nQtdEmb	  := aRetEmbala[2]
				oEmbAtu:Refresh()
				oQEmbAtu:Refresh()

				If Empty(aRetEmbala[1])
					While !MsgNoYes("Embalagem Nível "+cSerNiv+" não cadastrada ou estrutura ou no cadastro de embalagem avulsa."+CHR(13)+"Deseja continuar?")
					End
					oImprime:Disable()
					cEtiqueta := Space(_nTamEtiq)
					oEtiqueta:Refresh()
					oEtiqueta:SetFocus()
					Return (.f.)
				EndIf

			Else

				aRetEmbala := fEmbKitPig(SC2->C2_PRODUTO, "1")
				cEmbAtu    := Posicione("SB1",1,xFilial("SB1")+aRetEmbala[1],"B1_DESC")
				_cGrupoUso := Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_GRUPO")
				nQtdEmb	  := aRetEmbala[2]
				If Empty(aRetEmbala[1])
					While !MsgNoYes("Embalagem Nível "+cSerNiv+" não cadastrada ou estrutura do KIT PIG."+CHR(13)+"Deseja continuar?")
					End
					oImprime:Disable()
					cEtiqueta := Space(_nTamEtiq)
					oEtiqueta:Refresh()
					oEtiqueta:SetFocus()
					Return (.f.)
				EndIf

				oEmbAtu:Refresh()
				oQEmbAtu:Refresh()

			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se serial corresponde a KIT PIGTAIL													³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			SB1->( dbSetOrder(1) )
			SB1->( dbSeek( xFilial() + SC2->C2_PRODUTO ) )
			If SB1->B1_XKITPIG <> "S" .or. !GetMv("MV_XVERKIT")

				If AllTrim(_cGrupoUso) $ "DROP/PCON" .Or. lEhFuruka  // PCON acrescentado em 04/11/21 por Helio/Ricardo
					cProxNiv := "1"
				ElseIf AllTrim(_cGrupoUso) $ "CORD/0007/JUMP" .Or. LEFT(AllTrim(_cGrupoUso),3) == "DIO"  // PCON retirado em 04/11/21 por Helio/Ricardo

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Se a quantidade de etiquetas nivel 1 for maior que a qtd.embalagem obriga encerrar
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

					If LEFT(AllTrim(_cGrupoUso),3) == "DIO"
						aRetEmbala := U_RetEmbala(SC2->C2_PRODUTO,"1")
						nQProxEmb  := aRetEmbala[2]
					EndIF

					If nQtdGer >= Round(nQProxEmb,0)

						While !MsgNoYes("Foram emitidas "+Alltrim(Str(nQtdGer))+" etiquetas de embalagem para serial."+Chr(13)+Chr(13)+" Favor concluir a próxima embalagem (nível 2) antes de emitir novas etiquetas para serial."+CHR(13)+Chr(13)+"Deseja continuar?")
						End
						oImprime:Disable()
						//nQtdBip := 0
						//oQtdBip:Refresh()
						cEtiqueta := Space(_nTamEtiq)
						oEtiqueta:Refresh()
						oEtiqueta:SetFocus()
						Return (.f.)
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Imprimindo etiqueta nível 1 a partir de uma etiqueta serial para CORD³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aUsoSerie := {}
					aadd(aUsoSerie,Alltrim(cEtiqOrig))

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifica se embalagem está COM ou SEM Etiqueta de Fornecedor		   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

					If "HUAWEI DO BRASIL" $ Upper(SA1->A1_NOME)
						U_DOMETQ98(cNumOpBip,NIL,1,1,"1",aUsoSerie,.T.,0,.F., Alltrim(cEtiqOrig),,,cCodHuawei) //Layout 98 - Etiqueta Somente com CODBAR
					Else
						If nRadio == 1 // Embalagem SEM Etiqueta de Fornecedor
							fImpSeri(cNumOpBip,cEtiqOrig,aUsoSerie)
						Else				// Embalagem COM Etiqueta de Fornecedor (Imprime Nossa Etiqueta com Número de Série)
							U_DOMETQ98(cNumOpBip,NIL,1,1,"1",aUsoSerie,.T.,0,.F.,Alltrim(cEtiqOrig),,,cCodHuawei) //Layout 98 - Etiqueta Somente com CODBAR
						EndIf
					EndIf

					cCodHuawei:= SPACE(100)//SPACE(Len(XD1->XD1_ETQHUA))
					aSerial := {}
					nQtdGer += 1
					oQtdGer:Refresh()
					cEtiqueta := Space(_nTamEtiq)
					oEtiqueta:Refresh()
					oEtiqueta:SetFocus()
					oUltima:Enable()

					Return (.f.)

				Else

					If SubStr(AllTrim(_cGrupoUso),1,3) == "TRU"
						cProxNiv := cSerNiv
					Else
						cProxNiv := Soma1(cSerNiv)
					EndIf

					aRetEmbala := U_RetEmbala(SC2->C2_PRODUTO,cProxNIv)
					If Empty(aRetEmbala[1])
						While !MsgNoYes("Embalagem Nível "+cProxNiv+" não cadastrada na estrutura do produto desta OP."+CHR(13)+"Deseja continuar?")
						End
						oImprime:Disable()
						cEtiqueta := Space(_nTamEtiq)
						oEtiqueta:Refresh()
						oEtiqueta:SetFocus()
						Return (.f.)
					EndIf

				EndIf

				cProxEmb   := Posicione("SB1",1,xFilial("SB1")+aRetEmbala[1],"B1_DESC")
				nQProxEmb  := aRetEmbala[2]

			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza etiqueta serial bipada								³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aScan(aSerial,{|aVet| aVet[1] == Alltrim(cEtiqOrig) }) == 0
				aadd(aSerial,{Alltrim(cEtiqOrig)})
				nQtdBip += 1
			EndIf

			cEtiqueta   := Space(_nTamEtiq)
			oEtiqueta:Refresh()
			oEtiqueta:SetFocus()

		If Len(aSerial) == Round(nQtdEmb,0) //.Or. (Len(aSerial) == nSaldoBip .And. cSerNiv == "1")

			nQtdBip  := Len(aSerial)
			nQEmbAtu := Round(nQtdEmb,0)
			oQtdBip:Refresh()
			oQEmbAtu:Refresh()
			lUsaColet := .F.

			If GetMv("MV_XVERKIT") 
				//MsgAlert("apontando produção e imprimindo etiqueta")
				If AllTrim(Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_XKITPIG")) == "S"
					cNumPeca := U_IXD1PECA()
					If U_ETQMTA250("010",SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,SC2->C2_PRODUTO,SC2->C2_LOCAL,nQEmbAtu,"P",cNumPeca)

						lUsaColet := .F.
						If Empty(SC2->C2_PEDIDO)
							If SC2->C2_SEQUEN == '001'
								U_DOMETQ98(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,NIL     ,nQProxEmb,1       ,"1"    ,{Alltrim(cEtiqOrig)},.T.      ,0         , lUsaColet, ""       ,cNumPeca, "Estoque OP:"+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN ,"") //Layout 98 - Etiqueta Somente com CODBAR
								//DOMETQ98(cNumOp                                 ,cNumSenf,nQtdEmb  , nQtdEtq, cNivel, aFilhas            , lImprime, _PesoAuto, lColetor , cNumSerie, cNumPeca, cSetor   ,cEtqHuawei)
							Else
								U_DOMETQ98(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,NIL     ,nQProxEmb,1,"1"   ,{Alltrim(cEtiqOrig)},.T.,0,lUsaColet, "",cNumPeca, 'Produção OP:'+SC2->C2_NUM+SC2->C2_ITEM,"") //Layout 98 - Etiqueta Somente com CODBAR
							EndIf
							oImprime:Disable()
							cNumOpBip := SPACE(11)
							oNumOpBip:Refresh()
							cEtiqueta := Space(_nTamEtiq)
							oEtiqueta:Refresh()
							oEtiqueta:SetFocus()
						Else
							fImpSeri(cNumOpBip,cEtiqOrig,{Alltrim(cEtiqOrig)})
						EndIf

						nSaldoBip := (SC2->C2_QUANT - SC2->C2_QUJE)   // Trocado de C2_XXQUJE para C2_QUJE      por Hélio em 25/09/18
						oSbip:Refresh()
					EndIf

				Else

					If AllTrim(_cGrupoUso) $ "DROP/PCON" .Or. lEhFuruka

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ImpEtqBip() - Aponta OP e imprime etiqueta de embalagem ³
						//³														  				  ³
						//³cPARAM 01 - Numero da Peça										  ³
						//³cPARAM 01 - Numero da OP										  ³
						//³nPARAM 01 - Quantidade lida									  ³
						//³lPARAM 01 - Aponta OP (.T. = Sim | .F. = Não)			  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						//If lEhFuruka
						//	U_DOMETQ98(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,NIL,nQEmbAtu,1,"1",aSerial,.T.,0,lUsaColet, "") //Layout 98 - Etiqueta Somente com CODBAR
						//Else
						ImpEtqBip(Nil,Alltrim(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN),nQtdBip, .T. )
						//EndIf

					Else

						If AllTrim(_cGrupoUso) == "JUMP" .Or. SubStr(AllTrim(_cGrupoUso),1,3)=="TRU" .Or. AllTrim(_cGrupoUso) == "FLEX"
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ImpEtqBip() - Aponta OP e imprime etiqueta de embalagem ³
							//³																		  ³
							//³cPARAM 01 - Numero da Peça										  ³
							//³cPARAM 01 - Numero da OP										  ³
							//³nPARAM 01 - Quantidade lida									  ³
							//³lPARAM 01 - Aponta OP (.T. = Sim | .F. = Não)			  ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If (SubStr(AllTrim(_cGrupoUso),1,3)=="TRU" .Or. AllTrim(_cGrupoUso) == "FLEX" ) .And. lEricsson
								
								if U_VALIDACAO()// ricardo roda 04/11/2021
									U_DOMETQ41(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,NIL,nQEmbAtu,1,"1",aSerial,.T.,0,lUsaColet, "","","000000") //Layout 002 Crystal Ericsson - Por Michel A. Sander
								Else
									U_DOMETQ94(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,NIL,nQEmbAtu,1,"1",aSerial,.T.,0,lUsaColet, "") //Layout 002 Crystal Ericsson - Por Michel A. Sander
									Sleep(3000)		// Delay de 5 segundos para buffer
								Endif

								U_DOMETQ98(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,NIL,nQEmbAtu,1,"1",aSerial,.T.,0,lUsaColet, "") //Layout 98 - Etiqueta Somente com CODBAR
							Else
								ImpEtqBip(Nil,Alltrim(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN),nQtdBip, .F. )
							EndIf
						Else
						if U_VALIDACAO()
							U_DOMETQ41(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,NIL,nQEmbAtu,1,"1",aSerial,.T.,0,lUsaColet, "","","000000") //Layout 002 Crystal Ericsson - Por Michel A. Sander
						Else	
						
							if U_VALIDACAO()// ricardo roda 04/11/2021
								U_DOMETQ41(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,NIL,nQEmbAtu,1,"1",aSerial,.T.,0,lUsaColet, "","","000000") //Layout 002 Crystal Ericsson - Por Michel A. Sander
							Else
								U_DOMETQ94(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,NIL,nQEmbAtu,1,"1",aSerial,.T.,0,lUsaColet, "") //Layout 002 Crystal Ericsson - Por Michel A. Sander
								Sleep(3000)		// Delay de 5 segundos para buffer
							Endif
						
						Endif
							U_DOMETQ98(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,NIL,nQEmbAtu,1,"1",aSerial,.T.,0,lUsaColet, "") //Layout 98 - Etiqueta Somente com CODBAR
						
						EndIf
					
					EndIf

				EndIf

			Else

				If AllTrim(_cGrupoUso) $ "DROP/PCON" .Or. lEhFuruka

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ImpEtqBip() - Aponta OP e imprime etiqueta de embalagem ³
					//³														  				  ³
					//³cPARAM 01 - Numero da Peça										  ³
					//³cPARAM 01 - Numero da OP										  ³
					//³nPARAM 01 - Quantidade lida									  ³
					//³lPARAM 01 - Aponta OP (.T. = Sim | .F. = Não)			  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


					ImpEtqBip(Nil,Alltrim(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN),nQtdBip, .T. )
					if U_Validacao()
						iF AllTrim(_cGrupoUso) == "PCON"

							U_DOMETQ98(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,NIL,nQEmbAtu,1,"1",aSerial,.T.,0,lUsaColet, "")
						EndIf
					Endif

				Else

					If AllTrim(_cGrupoUso) == "JUMP" .Or. SubStr(AllTrim(_cGrupoUso),1,3)=="TRU" .Or. AllTrim(_cGrupoUso) == "FLEX"
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ImpEtqBip() - Aponta OP e imprime etiqueta de embalagem ³
						//³																		  ³
						//³cPARAM 01 - Numero da Peça										  ³
						//³cPARAM 01 - Numero da OP										  ³
						//³nPARAM 01 - Quantidade lida									  ³
						//³lPARAM 01 - Aponta OP (.T. = Sim | .F. = Não)			  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If (SubStr(AllTrim(_cGrupoUso),1,3)=="TRU" .OR. SubStr(AllTrim(_cGrupoUso),1,4)=="FLEX")  .And. lEricsson
							
							if U_VALIDACAO()// ricardo roda 04/11/2021
								U_DOMETQ41(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,NIL,nQEmbAtu,1,"1",aSerial,.T.,0,lUsaColet, "","","000000") //Layout 002 Crystal Ericsson - Por Michel A. Sander
							Else
								U_DOMETQ94(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,NIL,nQEmbAtu,1,"1",aSerial,.T.,0,lUsaColet, "") //Layout 002 Crystal Ericsson - Por Michel A. Sander
								Sleep(3000)		// Delay de 5 segundos para buffer
							Endif

							U_DOMETQ98(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,NIL,nQEmbAtu,1,"1",aSerial,.T.,0,lUsaColet, "") //Layout 98 - Etiqueta Somente com CODBAR
						Else
							ImpEtqBip(Nil,Alltrim(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN),nQtdBip, .F. )
						EndIf
					Else
						U_DOMETQ94(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,NIL,nQEmbAtu,1,"1",aSerial,.T.,0,lUsaColet, "") //Layout 002 Crystal Ericsson - Por Michel A. Sander
						Sleep(3000)		// Delay de 5 segundos para buffer
						U_DOMETQ98(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,NIL,nQEmbAtu,1,"1",aSerial,.T.,0,lUsaColet, "") //Layout 98 - Etiqueta Somente com CODBAR
					EndIf
				EndIf

			EndIf

			aSerial := {}
			aQtdBip  := {}
			aQtdEtiq := {}
			nQtdBip := 0
			nQtdKit := 0
			nQtdEmb := 0
			oQtdBip:Refresh()
			oQEmbAtu:Refresh()
			oQtdBip:Refresh()
			oUltima:Enable()

		Else

			If nQtdBip == (SC2->C2_QUANT - SC2->C2_QUJE) .Or.  (nQtTotN1 == SC2->C2_QUANT) .Or. ((nQtTotN1 + nQtdBip) == SC2->C2_QUANT)  // Trocado de C2_XXQUJE para C2_QUJE      por Hélio em 25/09/18
				nQEmbAtu := Round(nQtdEmb,0)
				oQtdBip:Refresh()
				oQEmbAtu:Refresh()
				lUsaColet := .F.

				If AllTrim(_cGrupoUso) $ "DROP/PCON" .Or. lEhFuruka

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ImpEtqBip() - Aponta OP e imprime etiqueta de embalagem ³
					//³														  				  ³
					//³cPARAM 01 - Numero da Peça										  ³
					//³cPARAM 01 - Numero da OP										  ³
					//³nPARAM 01 - Quantidade lida									  ³
					//³lPARAM 01 - Aponta OP (.T. = Sim | .F. = Não)			  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

					ImpEtqBip(Nil,Alltrim(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN),nQtdBip, .T.,.T. )
					if U_Validacao()
						iF AllTrim(_cGrupoUso) == "PCON"

							U_DOMETQ98(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,NIL,nQEmbAtu,1,"1",aSerial,.T.,0,lUsaColet, "")
						EndIf
					Endif
				Else
					if U_VALIDACAO()// ricardo roda 04/11/2021
						U_DOMETQ41(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,NIL,nQEmbAtu,1,"1",aSerial,.T.,0,lUsaColet, "","","000000") //Layout 002 Crystal Ericsson - Por Michel A. Sander
					Else
						U_DOMETQ94(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,NIL,nQtdBip,1,"1",aSerial,.T.,0,lUsaColet, "") //Layout 002 Crystal Ericsson - Por Michel A. Sander
						Sleep(3000)		// Delay de 5 segundos para buffer
					Endif
				
					
					U_DOMETQ98(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,NIL,nQtdBip,1,"1",aSerial,.T.,0,lUsaColet, "") //Layout 98 - Etiqueta Somente com CODBAR
				EndIf
				aSerial := {}
				aQtdBip  := {}
				aQtdEtiq := {}
				nQtdBip := 0
				nQtdKit := 0
				nQtdEmb := 0
				oQtdBip:Refresh()
				oQEmbAtu:Refresh()
				oQtdBip:Refresh()
				oUltima:Enable()
				Return ( .T. )
			EndIf

			nQtdBip  := Len(aSerial)
			nQEmbAtu := Round(nQtdEmb,0)
			oQtdBip:Refresh()
			oQEmbAtu:Refresh()

		EndIf

	EndIf

	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SomaPerdaºAutor ³ Michel Sander	     º Data ³    27/05/15 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Soma as perdas por OP			                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SomaPerda(cNumOpBip,cProdBip)

	LOCAL nPerdas := 0
	SZA->(dbSetOrder(1))
	SZE->(dbSetOrder(1))

	If SZA->(dbSeek(xFilial("SZA")+cNumOpBip))
		Do While SZA->(!Eof()) .And. SZA->ZA_FILIAL+SubStr(SZA->ZA_OP,1,11) == xFilial("SZA")+cNumOpBip
			nPerdas += SZA->ZA_SALDO
			SZA->(dbSkip())
		EndDo
	EndIf
	If SZE->(dbSeek(xFilial("SZE")+cNumOpBip))
		Do While SZE->(!Eof()) .And. SZE->ZE_FILIAL+SubStr(SZE->ZE_OP,1,11) == xFilial("SZE")+cNumOpBip
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
Static Function ImpEtqBip(cPecaBip,cOP,nQLidaSer,lApontaOP,lFinalOP)
	Local cLayoutEnt := ''

	DEFAULT cPecaBip  := ""
	DEFAULT cOP       := ""
	DEFAULT nQLidaSer := 0
	DEFAULT lApontaOP := .T.
	DEFAULT aSerial   := {}
	DEFAULT lFinalOP := .F.
	If !Empty(cPecaBip)
		If !XD1->( dbSeek( xFilial() + cPecaBip ) )
			MsgStop("Numero de Etiqueta invállida")
			Return
		EndIf

		If SC2->( dbSeek( xFilial() + XD1->XD1_OP ) )
			cGrupo  := Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_GRUPO")
			cCodCli := Posicione("SA1",1,xFilial("SA1")+SC2->C2_CLIENT,"A1_COD")
			cLojCli := Posicione("SA1",1,xFilial("SA1")+SC2->C2_CLIENT,"A1_LOJA")
		EndIf

		If !SZG->(dbSeek(xFilial("SZG")+cCodCli+cLojCli+cGrupo))
			Aviso("Atenção","Não existe layout de etiqueta amarrado para esse Cliente x Grupo de produto.",{"Ok"})
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

		If !U_VALIDACAO()
			__mv_par06 := SZG->ZG_LAYOUT   // TRATADO
		Else
			__mv_par06 := SZG->ZG_LAYVALI
		EndIf

	EndIf

	If !Empty(cOP)

		If SC2->( dbSeek( xFilial() + cOP ) )
			cGrupo  := Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_GRUPO")
			cCodCli := Posicione("SA1",1,xFilial("SA1")+SC2->C2_CLIENT,"A1_COD")
			cLojCli := Posicione("SA1",1,xFilial("SA1")+SC2->C2_CLIENT,"A1_LOJA")
		EndIf

		If !SZG->(dbSeek(xFilial("SZG")+cCodCli+cLojCli+cGrupo))
			Aviso("Atenção","Não existe layout de etiqueta amarrado para esse Cliente x Grupo de produto.",{"Ok"})
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

		__mv_par02 := cOP
		__mv_par03 := Nil
		__mv_par04 := 1
		__mv_par05 := 1
		If !U_VALIDACAO()
			__mv_par06 := SZG->ZG_LAYOUT  // TRATADO
		Else
			__mv_par06 := SZG->ZG_LAYVALI
		EndIf

	EndIf

	nPesoBip   := 0
	lColetor   := .F.
	cNumSerie  := ""

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica Serial para gerar XD2 (Pais e Filhas)						   	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aSerial) > 0
		aQtdBip := aSerial
		If nQLidaSer > 0
			nQtdKit := nQLidaSer
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³LAYOUT 01 - HUAWEI UNIFICADA												   	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cLayoutEnt := ""
	If __mv_par06 == "01"
		cLayoutEnt := "01"
		lRotValid :=  U_DOMETQ04(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.F.,nPesoBip,lColetor,cNumSerie,NIL) 			// Validações de Layout 01
		If !lRotValid
			MsgStop("A OP não será apontada. Verifique os problemas com o layout da etiqueta e repita a operação.")
			Return
		Else
			// Apontamento de OP
			cNumPeca := U_IXD1PECA()
			If lApontaOP
				If !U_ETQMTA250("010",SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,SC2->C2_PRODUTO,SC2->C2_LOCAL,nQtdKit,"P",cNumPeca)
					MsgStop("Erro no apontamento da OP")
					oImprime:Disable()
					Return
				Else
					cDomEtDl36_CancLay := __mv_par06 // Salva a impressao atual	para possível cancelamento
					MsgRun("Imprimindo etiqueta Layout 01","Aguarde...",{|| lRetEtq := U_DOMETQ04(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie,cNumPeca) })  // Impressão de Etiqueta Layout 01
				EndIf
			Else
				cDomEtDl36_CancLay := __mv_par06 // Salva a impressao atual	para possível cancelamento
				MsgRun("Imprimindo etiqueta Layout 01","Aguarde...",{|| lRetEtq := U_DOMETQ04(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie,cNumPeca) })  // Impressão de Etiqueta Layout 01
			EndIf

		EndIf
	EndIf
	If __mv_par06 == "02"
		cLayoutEnt := "02"
		lRotValid :=  U_DOMETQ03(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.F.,nPesoBip,lColetor,cNumSerie,NIL,lFinalOP) 			// Validações de Layout 02
		If !lRotValid
			MsgStop("A OP não será apontada. Verifique os problemas com o layout da etiqueta e repita a operação.")
			Return
		Else
			// Apontamento de OP NOVO MODELO DOMEX
			cNumPeca := U_IXD1PECA()
			If lApontaOP
				If !U_ETQMTA250("010",SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,SC2->C2_PRODUTO,SC2->C2_LOCAL,nQtdKit,"P",cNumPeca)
					MsgAlert("Erro no apontamento da OP")
					oImprime:Disable()
					Return
				Else
					MsgRun("Imprimindo etiqueta Layout 02","Aguarde...",{|| lRetEtq := U_DOMETQ03(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie,cNumPeca,lFinalOP) })  // Impressão de Etiqueta Layout 02
					cDomEtDl36_CancLay := __mv_par06 // Salva a impressao atual	para possível cancelamento
				EndIf
			Else
				MsgRun("Imprimindo etiqueta Layout 02","Aguarde...",{|| lRetEtq := U_DOMETQ03(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie,cNumPeca) })  // Impressão de Etiqueta Layout 02
				cDomEtDl36_CancLay := __mv_par06 // Salva a impressao atual	para possível cancelamento
			EndIf
		EndIf
	EndIf
	If __mv_par06 == "03"
		cLayoutEnt := "03"
		lRotValid := U_DOMETQ05(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.F.,nPesoBip,lColetor,cNumSerie,NIL) //Layout 03
		If !lRotValid
			MsgStop("A OP não será apontada. Verifique os problemas com o layout da etiqueta e repita a operação.")
			Return
		Else
			// Apontamento de OP
			cNumPeca := U_IXD1PECA()
			If lApontaOP
				If !U_ETQMTA250("010",SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,SC2->C2_PRODUTO,SC2->C2_LOCAL,nQtdKit,"P",cNumPeca)
					MsgStop("Erro no apontamento da OP")
					oImprime:Disable()
					Return
				Else
					MsgRun("Imprimindo etiqueta Layout 03","Aguarde...",{|| lRetEtq := U_DOMETQ05(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie,cNumPeca) })  //Layout 03 - Por Michel A. Sander
					cDomEtDl36_CancLay := __mv_par06 // Salva a impressao atual	para possível cancelamento
				EndIf
			Else
				MsgRun("Imprimindo etiqueta Layout 03","Aguarde...",{|| lRetEtq := U_DOMETQ05(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie,cNumPeca) })  //Layout 03 - Por Michel A. Sander
				cDomEtDl36_CancLay := __mv_par06 // Salva a impressao atual	para possível cancelamento
			EndIf
		EndIf
	EndIf
	If __mv_par06 == "04"
		cLayoutEnt := "04"
		lRotValid := U_DOMETQ06(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.F.,nPesoBip,lColetor,cNumSerie,NIL) //Layout 04 - Por Michel A. Sander
		If !lRotValid
			MsgStop("A OP não será apontada. Verifique os problemas com o layout da etiqueta e repita a operação.")
			Return
		Else
			// Apontamento de OP
			cNumPeca := U_IXD1PECA()
			If lApontaOP
				If !U_ETQMTA250("010",SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,SC2->C2_PRODUTO,SC2->C2_LOCAL,nQtdKit,"P",cNumPeca)
					MsgStop("Erro no apontamento da OP")
					oImprime:Disable()
					Return
				Else
					MsgRun("Imprimindo etiqueta Layout 04","Aguarde...",{|| lRetEtq := U_DOMETQ06(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie,cNumPeca) })  //Layout 04 - Por Michel A. Sander
					cDomEtDl36_CancLay := __mv_par06 // Salva a impressao atual	para possível cancelamento
				EndIf
			Else
				MsgRun("Imprimindo etiqueta Layout 04","Aguarde...",{|| lRetEtq := U_DOMETQ06(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie,cNumPeca) })  //Layout 04 - Por Michel A. Sander
				cDomEtDl36_CancLay := __mv_par06 // Salva a impressao atual	para possível cancelamento
			EndIf
		EndIf
	EndIf
	If __mv_par06 == "05"
		cLayoutEnt := "05"
		lRotValid :=  U_DOMETQ07(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.F.,nPesoBip,lColetor,cNumSerie,NIL) 			// Validações de Layout 05
		If !lRotValid
			MsgStop("A OP não será apontada. Verifique os problemas com o layout da etiqueta e repita a operação.")
			Return
		Else
			// Apontamento de OP
			cNumPeca := U_IXD1PECA()
			If lApontaOP
				If !U_ETQMTA250("010",SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,SC2->C2_PRODUTO,SC2->C2_LOCAL,nQtdKit,"P",cNumPeca)
					MsgStop("Erro no apontamento da OP")
					oImprime:Disable()
					Return
				Else
					MsgRun("Imprimindo etiqueta Layout 05","Aguarde...",{|| lRetEtq := U_DOMETQ07(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie,cNumPeca) })  // Impressão de Etiqueta Layout 05
					cDomEtDl36_CancLay := __mv_par06 // Salva a impressao atual	para possível cancelamento
				EndIf
			Else
				MsgRun("Imprimindo etiqueta Layout 05","Aguarde...",{|| lRetEtq := U_DOMETQ07(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie,cNumPeca) })  // Impressão de Etiqueta Layout 05
				cDomEtDl36_CancLay := __mv_par06 // Salva a impressao atual	para possível cancelamento
			EndIf
		EndIf
	EndIf
	If __mv_par06 == "06"
		cLayoutEnt := "06"
		MsgRun("Imprimindo etiqueta Layout 06","Aguarde...",{|| lRetEtq := U_DOMETQ08(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie) }) //Layout 06 - Por Michel A. Sander
	EndIf
	If __mv_par06 == "07"
		cLayoutEnt := "07"
		MsgRun("Imprimindo etiqueta Layout 07","Aguarde...",{|| lRetEtq := U_DOMETQ09(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie) }) //Layout 07 - Por Michel A. Sander
	EndIf
	If __mv_par06 == "10"
		cLayoutEnt := "10"
		MsgRun("Imprimindo etiqueta Layout 10","Aguarde...",{|| lRetEtq := U_DOMETQ10(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie) }) //Layout 10 - Por Michel A. Sander
	EndIf
	If __mv_par06 == "11"
		cLayoutEnt := "11"
		MsgRun("Imprimindo etiqueta Layout 11","Aguarde...",{|| lRetEtq := U_DOMETQ11(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie) }) //Layout 11 - Por Michel A. Sander
	EndIf
	If __mv_par06 == "12"
		cLayoutEnt := "12"
		MsgRun("Imprimindo etiqueta Layout 12","Aguarde...",{|| lRetEtq := U_DOMETQ12(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie) }) //Layout 12 - Por MLS
	EndIf
	If __mv_par06 == "13"
		cLayoutEnt := "13"
		MsgRun("Imprimindo etiqueta Layout 13","Aguarde...",{|| lRetEtq := U_DOMETQ13(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie) }) //Layout 13 - Por Michel A. Sander
	EndIf
	If __mv_par06 == "14"
		cLayoutEnt := "14"
		MsgRun("Imprimindo etiqueta Layout 14","Aguarde...",{|| lRetEtq := U_DOMETQ14(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie) }) //Layout 13 - Por Michel A. Sander
	EndIf
	If __mv_par06 == "31"
		cLayoutEnt := "31"
		MsgRun("Imprimindo etiqueta Layout 31","Aguarde...",{|| lRetEtq := U_DOMETQ31(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie) }) //Layout 31 - Por Michel A. Sander
	EndIf
	If __mv_par06 == "36"
		cLayoutEnt := "36"
		lRotValid := U_DOMETQ36(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.F.,nPesoBip,lColetor,cNumSerie,NIL) //Layout 36 - Por Michel A. Sander
		If !lRotValid
			MsgStop("A OP não será apontada. Verifique os problemas com o layout da etiqueta e repita a operação.")
			Return
		Else
			// Apontamento de OP
			cNumPeca := U_IXD1PECA()
			If lApontaOP
				If !U_ETQMTA250("010",SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,SC2->C2_PRODUTO,SC2->C2_LOCAL,nQtdKit,"P",cNumPeca)
					MsgStop("Erro no apontamento da OP")
					oImprime:Disable()
					Return
				Else
					MsgRun("Imprimindo etiqueta Layout 36","Aguarde...",{|| lRetEtq := U_DOMETQ36(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie,cNumPeca) }) //Layout 36 - Por Michel A. Sander
					cDomEtDl36_CancLay := __mv_par06 // Salva a impressao atual	para possível cancelamento
				EndIf
			Else
				MsgRun("Imprimindo etiqueta Layout 36","Aguarde...",{|| lRetEtq := U_DOMETQ36(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie,cNumPeca) }) //Layout 36 - Por Michel A. Sander
				cDomEtDl36_CancLay := __mv_par06 // Salva a impressao atual	para possível cancelamento
			EndIf
		EndIf
	EndIf
	If __mv_par06 == "39" .and. U_VALIDACAO() // HELIO/RICARDO 03/11/21  // layout criado a partir do 02
		cLayoutEnt := "39"
		lRotValid :=  U_DOMETQ39(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.F.,nPesoBip,lColetor,cNumSerie,NIL,lFinalOP) 			// Validações de Layout 02
		If !lRotValid
			MsgStop("A OP não será apontada. Verifique os problemas com o layout da etiqueta e repita a operação.")
			Return
		Else
			// Apontamento de OP NOVO MODELO DOMEX
			cNumPeca := U_IXD1PECA()
			If lApontaOP
				If !U_ETQMTA250("010",SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,SC2->C2_PRODUTO,SC2->C2_LOCAL,nQtdKit,"P",cNumPeca)
					MsgAlert("Erro no apontamento da OP")
					oImprime:Disable()
					Return
				Else
					MsgRun("Imprimindo etiqueta Layout 39","Aguarde...",{|| lRetEtq := U_DOMETQ39(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie,cNumPeca,lFinalOP) })  // Impressão de Etiqueta Layout 02
					cDomEtDl36_CancLay := __mv_par06 // Salva a impressao atual	para possível cancelamento
				EndIf
			Else
				MsgRun("Imprimindo etiqueta Layout 39","Aguarde...",{|| lRetEtq := U_DOMETQ39(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie,cNumPeca) })  // Impressão de Etiqueta Layout 02
				cDomEtDl36_CancLay := __mv_par06 // Salva a impressao atual	para possível cancelamento
			EndIf
		EndIf
	EndIf

	If __mv_par06 == "40" .and. U_VALIDACAO() // HELIO/RICARDO 03/11/21 // layout criado a partir do 04
		cLayoutEnt := "40"
		lRotValid := U_DOMETQ40(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.F.,nPesoBip,lColetor,cNumSerie,NIL)
		If !lRotValid
			MsgStop("A OP não será apontada. Verifique os problemas com o layout da etiqueta e repita a operação.")
			Return
		Else
			// Apontamento de OP
			cNumPeca := U_IXD1PECA()
			If lApontaOP
				If !U_ETQMTA250("010",SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,SC2->C2_PRODUTO,SC2->C2_LOCAL,nQtdKit,"P",cNumPeca)
					MsgStop("Erro no apontamento da OP")
					oImprime:Disable()
					Return
				Else
					MsgRun("Imprimindo etiqueta Layout 40","Aguarde...",{|| lRetEtq := U_DOMETQ40(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie,cNumPeca) })  //Layout 04 - Por Michel A. Sander
					cDomEtDl36_CancLay := __mv_par06 // Salva a impressao atual	para possível cancelamento
				EndIf
			Else
				MsgRun("Imprimindo etiqueta Layout 40","Aguarde...",{|| lRetEtq := U_DOMETQ40(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie,cNumPeca) })  //Layout 04 - Por Michel A. Sander
				cDomEtDl36_CancLay := __mv_par06 // Salva a impressao atual	para possível cancelamento
			EndIf
		EndIf
	EndIf

	If __mv_par06 == "41" .and. U_VALIDACAO() // Ricardo Roda 04/11/21  // layout criado a partir do 94
		cLayoutEnt := "41"
		lRotValid := U_DOMETQ41(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.F.,nPesoBip,lColetor,cNumSerie,NIL,"","000000") //Layout 002 Crystal Ericsson - Por Michel A. Sander
		If !lRotValid
			MsgStop("A OP não será apontada. Verifique os problemas com o layout da etiqueta e repita a operação.")
			Return
		Else
			// Apontamento de OP
			cNumPeca := U_IXD1PECA()
			If lApontaOP
				If !U_ETQMTA250("010",SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,SC2->C2_PRODUTO,SC2->C2_LOCAL,nQtdKit,"P",cNumPeca)
					MsgStop("Erro no apontamento da OP")
					oImprime:Disable()
					Return
				Else
					MsgRun("Imprimindo etiqueta Layout 97   1/2","Aguarde...",{|| lRetEtq := U_DOMETQ97(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie,cNumPeca) }) // Layout 002 Crystal Ericsson- Por Michel A. Sander
					MsgRun("Imprimindo etiqueta Layout 41   2/2","Aguarde...",{||            U_DOMETQ41(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie,Nil,"","000000"     ) }) // Layout 094 Crystal Ericsson
					Sleep(5000)		// Delay de 5 segundos para buffer
					cDomEtDl36_CancLay := __mv_par06 // Salva a impressao atual	para possível cancelamento
				EndIF
			Else
				MsgRun("Imprimindo etiqueta Layout 97   1/2","Aguarde...",{|| lRetEtq := U_DOMETQ97(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie,cNumPeca) }) // Layout 002 Crystal Ericsson- Por Michel A. Sander
				MsgRun("Imprimindo etiqueta Layout 41   2/2","Aguarde...",{||            U_DOMETQ41(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie,Nil,"","000000"     ) }) // Layout 094 Crystal Ericsson

				cDomEtDl36_CancLay := __mv_par06 // Salva a impressao atual	para possível cancelamento
			EndIf

		EndIf
	EndIf


	if  U_VALIDACAO() .OR. .T. // RODA 16/09/2021  Etiqueta extra
		lGlobal := .F.

		if !empty(SB1->B1_BASE)
			_BaseCod := Subs(SC2->C2_PRODUTO,1,2)
			_UltDig:= Subs(SC2->C2_PRODUTO,LEN(ALLTRIM(SC2->C2_PRODUTO)),1)
			IF _BaseCod+_UltDig  $ "CH9|CM9|CO9|DPB|FXE|MDB|MSB|PB9|TE9"
				//If ("GLOBO GROUP S.A." $ Upper(SA1->A1_NOME)) .Or. ("GLOBO GROUP S.A." $ Upper(SA1->A1_NREDUZ))  //Subs(SC2->C2_PRODUTO,15,1) $ GetMV("MV_XLAY117")  //
				lGlobal := .T.
			EndIf
			If lGlobal
				MsgRun("Imprimindo etiqueta Layout 117","Aguarde...",{|| lRetEtq := U_DOMET117(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie) })
			Endif
		Endif
	Endif


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³LAYOUT 87 - HUAWEI LEIAUTE NOVO 50X100 mm								   	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If __mv_par06 == "87"
		cLayoutEnt := "87"

		//              U_DOMETQ99(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,Nil ,1 ,1 ,cProxNiv,aSerial, .F. ,0        ,.F.     ,cEtiqOrig,NIL)	// Validações de Layout 99
		//lRotValid   :=  U_DOMETQ87(__mv_par02                             ,Nil ,1 ,1 ,"1"     ,{}     , .F. ,nPesoBip ,lColetor,cEtiqOrig,NIL) // Validações de Layout 87
		//dometdl4      U_DOMETQ87(cOP                                    ,Nil, 1, 1 ,'1'     ,{}     , .T. ,_PesoAuto,lColetor,cNumSerie)     // Layout 87 - HUAWEI 50x100 mm Por Michel A. Sander
		lColetor := .F.
		If lNewDL7
			lRotValid :=  U_DOMET87B(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.F.,nPesoBip,lColetor ,cNumSerie,Nil) // ZEBRA DESIGN
		Else
			lRotValid :=  U_DOMETQ87(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.F.,nPesoBip,lColetor ,cNumSerie,Nil) // CRYSTAL REPORTS
		EndIf

		If !lRotValid
			MsgStop("A OP não será apontada. Verifique os problemas com o layout da etiqueta e repita a operação.")
			Return
		Else
			// Apontamento de OP
			cNumPeca := U_IXD1PECA()
			If lApontaOP
				If !U_ETQMTA250("010",SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,SC2->C2_PRODUTO,SC2->C2_LOCAL,__mv_par04,"P",cNumPeca)
					MsgStop("Erro no apontamento da OP")
					oImprime:Disable()
					Return
				Else
					cDomEtDl36_CancLay := __mv_par06 // Salva a impressao atual	para possível cancelamento
					lColetor := .F.
					If lNewDL7
						MsgRun("Imprimindo etiqueta Layout 87","Aguarde...",{|| lRetEtq  := U_DOMET87B(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor ,cNumSerie,cNumPeca) })  // Impressão de Etiqueta Layout 87 ZEBRA DESIGN
					Else
						MsgRun("Imprimindo etiqueta Layout 87","Aguarde...",{|| lRetEtq  := U_DOMETQ87(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor ,cNumSerie,cNumPeca) })  // Impressão de Etiqueta Layout 87 CRYSTAL REPORTS
					EndIf
				EndIf
			Else
				cDomEtDl36_CancLay := __mv_par06 // Salva a impressao atual	para possível cancelamento
				lColetor := .F.
				If lNewDL7
					MsgRun("Imprimindo etiqueta Layout 87","Aguarde...",{|| lRetEtq  := U_DOMET87B(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor ,cNumSerie,cNumPeca) })  // Impressão de Etiqueta Layout 87 ZEBRA DESIGN
				Else
					MsgRun("Imprimindo etiqueta Layout 87","Aguarde...",{|| lRetEtq  := U_DOMETQ87(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor ,cNumSerie,cNumPeca) })  // Impressão de Etiqueta Layout 87 CRYSTAL REPORTS
				EndIf
			EndIf
		EndIf
	EndIf

	If __mv_par06 == "90"
		cLayoutEnt := "90"
		MsgRun("Imprimindo etiqueta Layout 90","Aguarde...",{|| lRetEtq := U_DOMETQ90(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie,Nil,Nil) }) //Layout 90 - Por Michel A. Sander
	EndIf
	If __mv_par06 == "94"
		cLayoutEnt := "94"
		lRotValid := U_DOMETQ97(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.F.,nPesoBip,lColetor,cNumSerie,NIL) //Layout 002 Crystal Ericsson - Por Michel A. Sander
		If !lRotValid
			MsgStop("A OP não será apontada. Verifique os problemas com o layout da etiqueta e repita a operação.")
			Return
		Else
			// Apontamento de OP
			cNumPeca := U_IXD1PECA()
			If lApontaOP
				If !U_ETQMTA250("010",SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,SC2->C2_PRODUTO,SC2->C2_LOCAL,nQtdKit,"P",cNumPeca)
					MsgStop("Erro no apontamento da OP")
					oImprime:Disable()
					Return
				Else
					MsgRun("Imprimindo etiqueta Layout 97   1/2","Aguarde...",{|| lRetEtq := U_DOMETQ97(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie,cNumPeca) }) // Layout 002 Crystal Ericsson- Por Michel A. Sander
					MsgRun("Imprimindo etiqueta Layout 94   2/2","Aguarde...",{||            U_DOMETQ94(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie,Nil     ) }) // Layout 094 Crystal Ericsson
					Sleep(5000)		// Delay de 5 segundos para buffer
					cDomEtDl36_CancLay := __mv_par06 // Salva a impressao atual	para possível cancelamento
				EndIF
			Else
				MsgRun("Imprimindo etiqueta Layout 97   1/2","Aguarde...",{|| lRetEtq := U_DOMETQ97(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie,cNumPeca) }) // Layout 002 Crystal Ericsson- Por Michel A. Sander
				MsgRun("Imprimindo etiqueta Layout 94   2/2","Aguarde...",{||            U_DOMETQ94(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie,Nil     ) }) // Layout 094 Crystal Ericsson
				Sleep(5000)		// Delay de 5 segundos para buffer
				cDomEtDl36_CancLay := __mv_par06 // Salva a impressao atual	para possível cancelamento
			EndIf

		EndIf
	EndIf

	If __mv_par06 == "98"
		cLayoutEnt := "98"
		cNumPeca := U_IXD1PECA()
		If lApontaOP
			If !U_ETQMTA250("010",SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,SC2->C2_PRODUTO,SC2->C2_LOCAL,nQtdKit,"P",cNumPeca)
				MsgStop("Erro no apontamento da OP")
				oImprime:Disable()
				Return
			Else
				MsgRun("Imprimindo etiqueta Layout 98","Aguarde...",{|| lRetEtq := U_DOMETQ98(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,NIL,nQEmbAtu,1,"1",aQtdBip,.T.,0,lUsaColet, "",cNumPeca)  }) //Layout 98 - Etiqueta Somente com CODBAR
				Sleep(5000)		// Delay de 5 segundos para buffer
				cDomEtDl36_CancLay := __mv_par06 // Salva a impressao atual	para possível cancelamento
			EndIF
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³LAYOUT 99 - HUAWEI LEIAUTE NOVO   								   	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If __mv_par06 == "99"
		cLayoutEnt := "99"
		IF U_VALIDACAO() .Or. .T. // RODA 20/08/2021
			lRotValid :=  U_DOMET87B(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.F.,nPesoBip,lColetor,cNumSerie,NIL) 			// Validações de Layout 01
		Else
			lRotValid :=  U_DOMETQ99(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.F.,nPesoBip,lColetor,cNumSerie,NIL) 			// Validações de Layout 01
		Endif

		If !lRotValid
			MsgStop("A OP não será apontada. Verifique os problemas com o layout da etiqueta e repita a operação.")
			Return
		Else
			// Apontamento de OP
			cNumPeca := U_IXD1PECA()
			If lApontaOP
				If !U_ETQMTA250("010",SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,SC2->C2_PRODUTO,SC2->C2_LOCAL,nQtdKit,"P",cNumPeca)
					MsgStop("Erro no apontamento da OP")
					oImprime:Disable()
					Return
				Else
					cDomEtDl36_CancLay := __mv_par06 // Salva a impressao atual	para possível cancelamento

					IF U_VALIDACAO() .Or. .T. // RODA 20/08/2021
						MsgRun("Imprimindo etiqueta Layout 87B","Aguarde...",{|| lRetEtq := U_DOMET87B(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie,cNumPeca) })  // Impressão de Etiqueta Layout 01
					Else
						MsgRun("Imprimindo etiqueta Layout 99","Aguarde...",{|| lRetEtq := U_DOMETQ99(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie,cNumPeca) })  // Impressão de Etiqueta Layout 01
					Endif
				EndIf
			Else
				cDomEtDl36_CancLay := __mv_par06 // Salva a impressao atual	para possível cancelamento
				IF U_VALIDACAO()  .Or. .T.// RODA 20/08/2021
					MsgRun("Imprimindo etiqueta Layout 87B","Aguarde...",{|| lRetEtq := U_DOMET87B(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie,cNumPeca) })  // Impressão de Etiqueta Layout 01
				Else
					MsgRun("Imprimindo etiqueta Layout 99","Aguarde...",{|| lRetEtq := U_DOMETQ99(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aQtdBip,.T.,nPesoBip,lColetor,cNumSerie,cNumPeca) })  // Impressão de Etiqueta Layout 01
				Endif
			EndIf
		EndIf
	EndIf

	If U_VALIDACAO() // HELIO 03/11/21
		If Empty(cLayoutEnt)
			MsgStop("Layout " + __mv_par06 + " não preparado para esta rotina.")
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Executa rotina de impressao									³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Imprime a etiqueta da telefonica								³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lTelefonic
		// Segunda etiqueta, layout Telefonica
		U_DOMETQ93(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN, SC2->C2_PRODUTO, SC2->C2_PEDIDO, __mv_par04, dDataBase, .F., "", 0)
		lUltTelef := .T.
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica cliente novamente caso venha de cancelamento da ult.etiqueta ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SA1->(dbSeek(xFilial("SA1")+SC2->C2_CLIENT))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se o Cliente é TELEFONICA							³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lTelefonic := .F.
		If (("TELEFONICA" $ Upper(SA1->A1_NOME)) .Or. ("TELEFONICA" $ Upper(SA1->A1_NREDUZ))) //.And. _cGrupoUso <> "PCON"
			SC5->(dbSeek(xFilial("SC5")+SC2->C2_PEDIDO))
			cPedTel := SC5->C5_ESP1
			U_DOMETQ93(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN, SC2->C2_PRODUTO, SC2->C2_PEDIDO, __mv_par04, dDataBase, .F., "", 0)
			lUltTelef := .T.
		Else
			lUltTelef := .F.
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se o Cliente é COMBA									³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lComba
			U_DOMETQ95(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,{aQtdBip},.T.,nPesoBip,lColetor,cNumSerie) //mls
		EndIf

	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Imprime a etiqueta da OI S/A											 			³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If GetMv("MV_XVEROI")

		If lOi
			U_DOMET106(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN, SC2->C2_PRODUTO, SC2->C2_PEDIDO, 1, dDataBase, .F., "", 0, __mv_par04,cFila)
			lUltOi := .T.
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica cliente novamente caso venha de cancelamento da ult.etiqueta ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SA1->(dbSeek(xFilial("SA1")+SC2->C2_CLIENT))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se o Cliente é OI
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lOi := .F.
			If ("OI S" $ Upper(SA1->A1_NOME)) .Or. ("OI MO" $ Upper(SA1->A1_NOME)) .Or. ("OI MOVEL" $ Upper(SA1->A1_NOME)) .Or. ("TELEMAR" $ Upper(SA1->A1_NOME)) .Or. ("BRASIL TELECOM COMUNICACAO MUL" $ Upper(SA1->A1_NOME))
				U_DOMET106(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN, SC2->C2_PRODUTO, SC2->C2_PEDIDO, 1, dDataBase, .F., "", 0, __mv_par04,cFila)
				lUltOi := .T.
				lOi    := .T.
			Else
				lUltOi := .F.
			EndIf
		EndIf

	EndIf

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
	lTelefonic := .F.
	lEricsson := .F.
	lComba    := .F.
	cPedTel   := ""
	oQEmbAtu:Refresh()
	oEmbAtu:Refresh()
	oProxEmb:Refresh()
	oQProxEmb:Refresh()
	oQtdBip:Refresh()
	oCliente:Refresh()
	oProduto:Refresh()
	oDescricao:Refresh()
	oQOpBip:Refresh()
	oSBip:Refresh()
	oPdVen:Refresh()
	oNumOpBip:Refresh()
	oPdaOp:Refresh()
	oImprime:Disable()
	cEtiqueta := Space(_nTamEtiq)
	oEtiqueta:Refresh()
	oEtiqueta:SetFocus()

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
		MsgStop("Não existe etiqueta a ser cancelada.")
	Else
		If !MsgNoYes("A última etiqueta No. "+AllTrim(cDomEtDl31_CancEtq)+" será CANCELADA."+CHR(13)+CHR(13)+"Deseja continuar?")
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
			XD1->XD1_OCORRE := "5"  // Etiqueta cancelada
			XD1->( msUnlock() )
		EndIf

		lColetor := .F.

		If cDomEtDl36_CancLay == "01"
			U_DOMETQ04(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor,cNumSerie)		// Impressão de Etiqueta Layout 01
		EndIf
		If cDomEtDl36_CancLay == "02"
			U_DOMETQ03(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor,cNumSerie)  	// Impressão de Etiqueta Layout 02
		EndIf
		If cDomEtDl36_CancLay == "03"
			U_DOMETQ05(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor,cNumSerie)		// Layout 03
		EndIf
		If cDomEtDl36_CancLay == "04"
			U_DOMETQ06(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor,cNumSerie)		// Layout 04 - Por Michel A. Sander
		EndIf
		If cDomEtDl36_CancLay == "05"
			U_DOMETQ07(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor,cNumSerie)	 	// Impressão de Etiqueta Layout 05
		EndIf
		If cDomEtDl36_CancLay == "06"
			U_DOMETQ08(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor,cNumSerie)		// Layout 06 - Por Michel A. Sander
		EndIf
		If cDomEtDl36_CancLay == "07"
			U_DOMETQ09(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor,cNumSerie)		// Layout 07 - Por Michel A. Sander
		EndIf
		If cDomEtDl36_CancLay == "10"
			U_DOMETQ10(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor,cNumSerie)		// Layout 10 - Por Michel A. Sander
		EndIf
		If cDomEtDl36_CancLay == "11"
			U_DOMETQ11(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor,cNumSerie)		// Layout 11 - Por Michel A. Sander
		EndIf
		If cDomEtDl36_CancLay == "12"
			U_DOMETQ12(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor,cNumSerie)		//Layout 12 - Por MLS
		EndIf
		If cDomEtDl36_CancLay == "13"
			U_DOMETQ12(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor,cNumSerie)		//Layout 12 - Por MLS
		EndIf
		If cDomEtDl36_CancLay == "31"
			U_DOMETQ31(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor,cNumSerie)		//Layout 31 - Por Michel A. Sander
		EndIf
		If cDomEtDl36_CancLay == "36"
			U_DOMETQ36(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor,cNumSerie)		//Layout 36 - Por Michel A. Sander
		EndIf

		if  U_VALIDACAO() .OR. .T. // RODA 16/09/2021
			lGlobal := .F.

			//if !empty(SB1->B1_BASE)
			_BaseCod := Subs(SC2->C2_PRODUTO,1,2)
			_UltDig:= Subs(SC2->C2_PRODUTO,LEN(ALLTRIM(SC2->C2_PRODUTO)),1)
			IF _BaseCod+_UltDig  $ "CH9|CM9|CO9|DPB|FXE|MDB|MSB|PB9|TE9"
				//If ("GLOBO GROUP S.A." $ Upper(SA1->A1_NOME)) .Or. ("GLOBO GROUP S.A." $ Upper(SA1->A1_NREDUZ))  //Subs(SC2->C2_PRODUTO,15,1) $ GetMV("MV_XLAY117")  //
				lGlobal := .T.
			EndIf
			If lGlobal
				MsgRun("Imprimindo etiqueta Layout 117","Aguarde...",{|| lRetEtq := U_DOMET117(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor,cNumSerie) })
			Endif
			//Endif
		Endif

		If cDomEtDl36_CancLay == "94"
			If !lSerial
				// Etiqueta Ericsson Crystal
				U_DOMETQ94(cErictDl32_CancOP,cErictDl33_CancEmb,cErictDl34_CancKit,cErictDl35_CancUni,cErictDl38_CancNiv,aErictDl3A_CancFil,.T.,cErictDl39_CancPes,lColetor,cNumSerie)		//Layout 94 - Por Michel A. Sander
				Sleep(3000)
				// Layout 002 Crystal
				U_DOMETQ97(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor,cNumSerie)		//Layout 97 - Por Michel A. Sander
			Else
				// Etiqueta Ericsson Crystal
				// Cancela as Etiquetas do primeiro nivel do serial
				U_DOMETQ94(cErictDl32_CancOP,cErictDl33_CancEmb,cErictDl34_CancKit,cErictDl35_CancUni,cErictDl38_CancNiv,aErictDl3A_CancFil,.T.,cErictDl39_CancPes,lColetor,cNumSerie)		//Layout 94 - Por Michel A. Sander
				Sleep(3000)		// Delay de 3 segundos para buffer
				U_DOMETQ98(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor,cNumSerie) //Layout 98 - Etiqueta Somente com CODBAR
			EndIf
		EndIf
		If cDomEtDl36_CancLay == "87"
			If lNewDL7
				U_DOMET87B(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor,cNumSerie) //Layout 87 - Layout HUAWEI 50x100 MM
			Else
				U_DOMETQ87(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor,cNumSerie) //Layout 87 - Layout HUAWEI 50x100 MM
			EndIf
		EndIf
		If cDomEtDl36_CancLay == "99"
			IF U_VALIDACAO() .Or. .T. // RODA 20/08/2021
				U_DOMET87B(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor,cNumSerie) //Layout 99 - Etiqueta Novo Layout HUAWEI
			Else
				U_DOMETQ99(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor,cNumSerie) //Layout 99 - Etiqueta Novo Layout HUAWEI
			Endif
		EndIf

		If lUltTelef
			SC5->(dbSeek(xFilial("SC5")+cTeletDl34_CancPed))
			cPedTel := SC5->C5_ESP1
			U_DOMETQ93(cTeletDl32_CancOP, cTeletDl33_CancPro, cPedTel, cTeletDl35_CancUni, cTeletDl38_CancDat, .F. , "" , 0)
		EndIf

		If GetMv("MV_XVEROI")
			If lUltOi
				U_DOMET106(cOiDl32_CancOP, cOiDl33_CancPro, cOiDl34_CancPed, cOiDl35_CancUni, cOiDl38_CancDat, .F. , "" , 0, cOiDl39_CancQtd,cFila)
			EndIf
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
/*
Static Function fEnvExped()

	Private _cNumOpBip := Space(12)
	Private _nQtdOpBip := 0

	DEFINE MSDIALOG oDlg02 TITLE OemToAnsi("Envio de material para expedição") FROM 0,0 TO 150,390 PIXEL of oMainWnd PIXEL

	@ 12, 10	SAY _oTexto10 Var 'Número da OP:'    SIZE 100,10 PIXEL
	_oTexto10:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

	@ 10, 75 MSGET _oNumOPBip VAR _cNumOpBip  SIZE 80,12 Valid fValEnvEx() WHEN .T. PIXEL
	_oNumOPBip:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)

	@ 32, 10	SAY _oTexto12 Var 'Quantidade:'    SIZE 100,10 PIXEL
	_oTexto12:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

	@ 30, 75 MSGET _oQOpBip VAR _nQtdOpBip  Picture "999,999" SIZE 50,12 Valid fValQtd() WHEN .T. PIXEL
	_oQOpBip:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)


//@ 50, 050 BUTTON _oImprime  PROMPT "Enviar"   ACTION Processa( {|| fProcEnv() } ) SIZE 60,15 PIXEL OF oDlg02
	@ 50, 125 BUTTON _oCancelar PROMPT "Cancelar" ACTION Processa( {|| oDlg02:End() } ) SIZE 60,15 PIXEL OF oDlg02

	ACTIVATE MSDIALOG oDlg02 CENTER

	oEtiqueta:SetFocus()

Return
*/
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
/*
Static Function fValEnvEx()

	Local _Retorno := .T.

	If !Empty(_cNumOpBip)
		SC2->( dbSetOrder(1) )
		If SC2->( dbSeek( xFilial() + Subs(_cNumOpBip,1,11) ) )
			cQuery := "SELECT COUNT(*) CONTAGEM FROM " + RetSqlName("XD1") + " (NOLOCK) WHERE XD1_OP = '"+Subs(_cNumOpBip,1,11)+"' AND XD1_NIVEMB = '2' AND XD1_OCORRE = '6' AND D_E_L_E_T_ = '' "
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TEMP",.F.,.T.)
			_nQtdOpBip := TEMP->CONTAGEM
			If Empty(_nQtdOpBip)
				MsgStop("Não existe material disponível para ser enviado desta OP.")
				_Retorno := .F.
			EndIf
			TEMP->(dbCloseArea())
		Else
			MsgStop("OP inválida.")
			_Retorno := .F.
		EndIf
	EndIf

Return _Retorno
*/
/*
Static Function fValQtd()
	Local _Retorno := .T.

	If !Empty(_nQtdOpBip)
		cQuery := "SELECT COUNT(*) CONTAGEM FROM " + RetSqlName("XD1") + " (NOLOCK) WHERE XD1_OP = '"+Subs(_cNumOpBip,1,11)+"' AND XD1_NIVEMB = '2' AND XD1_OCORRE = '6' AND D_E_L_E_T_ = '' "
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TEMP",.F.,.T.)
		If _nQtdOpBip > TEMP->CONTAGEM
			MsgStop("Quantidade superior a disponível para ser enviada para expedição.")
			_Retorno := .F.
			TEMP->(dbCloseArea())
		Else
			TEMP->(dbCloseArea())
			If MsgNoYes("Confirma a quantidade de " + Alltrim(Str(_nQtdOpBip)) + " para enviar a expedição?")
				fProcEnv()
			Else
				_Retorno := .F.
			EndIf
		EndIf
	EndIf

Return _Retorno
*/
/*
Static Function fProcEnv()

	If !Empty(_nQtdOpBip)

		cQuery := "SELECT COUNT(*) CONTAGEM FROM " + RetSqlName("XD1") + " (NOLOCK) WHERE XD1_OP = '"+Subs(_cNumOpBip,1,11)+"' AND XD1_NIVEMB = '2' AND XD1_OCORRE = '6' AND D_E_L_E_T_ = '' "
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TEMP",.F.,.T.)

		If _nQtdOpBip <= TEMP->CONTAGEM

			TEMP->(dbCloseArea())
			cQuery := "SELECT TOP " + Alltrim(Str(_nQtdOpBip)) + " R_E_C_N_O_ FROM " + RetSqlName("XD1") + " (NOLOCK) WHERE XD1_OP = '"+Subs(_cNumOpBip,1,11)+"' AND XD1_NIVEMB = '2' AND XD1_OCORRE = '6' AND D_E_L_E_T_ = '' "
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TEMP",.F.,.T.)
			While !TEMP->( EOF() )
				XD1->( dbGoto(TEMP->R_E_C_N_O_) )
				If XD1->( Recno() ) == TEMP->R_E_C_N_O_
					Reclock("XD1",.F.)
					XD1->XD1_OCORRE := "4"
					XD1->( msUnlock() )
				EndIf
				TEMP->( dbSkip() )
			End
			TEMP->(dbCloseArea())

			//If MsgYesNo("Deseja processar o apontamento da OP " + _cNumOpBip + "?")
			//U_SCHEDOP(_cNumOpBip)
			//EndIf

			MsgInfo("Envio Ok")
			oDlg02:End()

		Else

			MsgStop("Quantidade superior a disponível para ser enviada para expedição.")
			TEMP->(dbCloseArea())

		EndIf

	EndIf

Return
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fFinalEmb ºAutor ³ Michel Sander      º Data ³  06.09.2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Finaliza embalagem de seriais nivel 1			              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*
Static Function fFinalEmb()

	If !lSerial
		Aviso("Atenção","Esta opção só pode ser utilizada pela embalagem serial nivel 1 para grupos FLEX e JUMPER.",{"Ok"})
		Return
	EndIf

	If nQtdBip == 0
		Aviso("Atenção","Quantidade bipada igual a zero.",{"Ok"})
		Return
	EndIf

	If MsgYesNo("Deseja encerrar a embalagem com a quantidade " + AllTrim(Str(nQtdBip)) + "?")
		nQEmbAtu := Round(nQtdBip,0)
		oQtdBip:Refresh()
		oQEmbAtu:Refresh()
		lUsaColet := .F.
		U_DOMETQ94(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,NIL,Round(nQtdBip,0),1,"1",aSerial,.T.,0,lUsaColet, "") //Layout 002 Crystal Ericsson - Por Michel A. Sander
		Sleep(3000)		// Delay de 5 segundos para buffer
		U_DOMETQ98(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,NIL,Round(nQtdBip,0),1,"1",aSerial,.T.,0,lUsaColet, "") //Layout 98 - Etiqueta Somente com CODBAR
		aSerial := {}
		aQtdBip  := {}
		aQtdEtiq := {}
		nQtdBip := 0
		nQtdKit := 0
		oQtdBip:Refresh()
		oQEmbAtu:Refresh()
		oQtdBip:Refresh()
		oUltima:Enable()
	EndIf

Return
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fImpSeri  ºAutor ³ Michel Sander      º Data ³  06.09.2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime etiqueta nivel 1 para seriais			              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fImpSeri(cOP,cNumSerie,aFilhas)

	If SC2->(dbSeek(xFilial("SC2")+cOP))

		cGrupo  := Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_GRUPO")
		cCodCli := Posicione("SA1",1,xFilial("SA1")+SC2->C2_CLIENT ,"A1_COD"  )
		cLojCli := Posicione("SA1",1,xFilial("SA1")+SC2->C2_CLIENT ,"A1_LOJA" )
		cNomCli := Posicione("SA1",1,xFilial("SA1")+SC2->C2_CLIENT ,"A1_NOME" )

		If !SZG->(dbSeek(xFilial("SZG")+cCodCli+cLojCli+cGrupo))
			Aviso("Atenção","Não existe layout de etiqueta amarrado para esse Cliente x Grupo de produto.",{"Ok"})
			cTxtMsg  := " Não existe layout de etiqueta amarrado para esse Cliente x Grupo de produto." + Chr(13)
			cTxtMsg  += " Produto = " + SC2->C2_PRODUTO + Chr(13)
			cTxtMsg  += " Cliente = " + SC2->C2_CLIENT  + Chr(13)
			cAssunto := "Amarração Cliente x Grupo de Produto x Layout de Etiqueta"
			cTexto   := StrTran(cTxtMsg,Chr(13),"<br>")
			cPara    := 'denis.vieira@rdt.com.br;fabiana.santos@rdt.com.br;tatiane.alves@rosenbergerdomex.com.br;monique.garcia@rosenbergerdomex.com.br;daniel.cavalcante@rosenbergerdomex.com.br'
			cCC      := 'natalia.silva@rosenbergerdomex.com.br;keila.gamt@rosenbergerdomex.com.br;leonardo.andrade@rosenbergerdomex.com.br;gabriel.cenato@rosenbergerdomex.com.br;luiz.pavret@rdt.com.br' //chamado monique 015475
			cArquivo := Nil
			U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
			cOP := Space(12)
			//oOP:SetFocus()
			Return(.F.)
		EndIf

		If !U_VALIDACAO()
			cLayout := SZG->ZG_LAYOUT   // TRATADO
		Else
			cLayout := SZG->ZG_LAYVALI
		EndIf

		_PesoAuto := 0
		lColetor  := .F.
		cDomEtDl36_CancLay := cLayout

		If cLayout == "01"
			U_DOMETQ04(cOP,Nil,1,1,'1',aFilhas,.T.,_PesoAuto,lColetor, cNumSerie) //Layout 01 - HUAWEI UNIFICADA
		ElseIf cLayout == "02"
			U_DOMETQ03(cOP,Nil,1,1,'1',aFilhas,.T.,_PesoAuto,lColetor, cNumSerie) //Layout 02
		ElseIf cLayout == "03"
			U_DOMETQ05(cOP,Nil,1,1,'1',aFilhas,.T.,_PesoAuto,lColetor, cNumSerie) //Layout 03
		ElseIf cLayout == "04"
			U_DOMETQ06(cOP,Nil,1,1,'1',aFilhas,.T.,_PesoAuto,lColetor, cNumSerie) //Layout 04 - Por Michel A. Sander
		ElseIf cLayout == "05"
			U_DOMETQ07(cOP,Nil,1,1,'1',aFilhas,.T.,_PesoAuto,lColetor, cNumSerie) //Layout 05 - Por Michel A. Sander
		ElseIf cLayout == "06"
			U_DOMETQ08(cOP,Nil,1,1,'1',aFilhas,.T.,_PesoAuto,lColetor, cNumSerie) //Layout 06 - Por Michel A. Sander
		ElseIf cLayout == "07"
			U_DOMETQ09(cOP,Nil,1,1,'1',aFilhas,.T.,_PesoAuto,lColetor, cNumSerie) //Layout 07 - Por Michel A. Sander
		ElseIf cLayout == "10"
			U_DOMETQ10(cOP,Nil,1,1,'1',aFilhas,.T.,_PesoAuto,lColetor, cNumSerie) //Layout 10 - Por Michel A. Sander
		ElseIf cLayout == "11"
			U_DOMETQ11(cOP,Nil,1,1,'1',aFilhas,.T.,_PesoAuto,lColetor, cNumSerie) //Layout 11 - Por Michel A. Sander
		ElseIf cLayout == "12"
			U_DOMETQ12(cOP,Nil,1,1,'1',aFilhas,.T.,_PesoAuto,lColetor, cNumSerie) //Layout 11 - Por MLS
		ElseIf cLayout == "13"
			U_DOMETQ13(cOP,Nil,1,1,'1',aFilhas,.T.,_PesoAuto,lColetor, cNumSerie) //Layout 11 - Por MLS
		ElseIf cLayout == "14"
			U_DOMETQ14(cOP,Nil,1,1,'1',aFilhas,.T.,_PesoAuto,lColetor, cNumSerie) //Layout 11 - Por MLS
		ElseIf cLayout == "15"
			U_DOMETQ15(cOP,Nil,1,1,'1',aFilhas,.T.,_PesoAuto,lColetor, cNumSerie) //Layout 15 - Por Michel A. Sander
		ElseIf cLayout == "16"
			U_DOMETQ16(cOP,Nil,1,1,'1',aFilhas,.T.,_PesoAuto,lColetor, cNumSerie) //Layout 15 - Por Michel A. Sander
		ElseIf cLayout == "31"
			U_DOMETQ31(cOP,Nil,1,1,'1',aFilhas,.T.,_PesoAuto,lColetor, cNumSerie) //Layout 31 - Por Michel A. Sander
		ElseIf cLayout == "36"
			U_DOMETQ36(cOP,Nil,1,1,'1',aFilhas,.T.,_PesoAuto,lColetor, cNumSerie) //Layout 36 - Por Michel A. Sander
		ElseIf cLayout == "41"
			U_DOMETQ98(cOp,Nil,1,1,'1',aFilhas,.T.,_PesoAuto,lColetor, cNumSerie) //Layout 98 - Etiqueta Somente com CODBAR
			U_DOMETQ41(cOP,Nil,1,1,'1',aFilhas,.T.,_PesoAuto,lColetor, cNumSerie ,"","000000") //Layout 41 - Por Ricardo Roda
		ElseIf cLayout == "42"
			U_DOMETQ42(cOP,Nil,1,1,'1',aFilhas,.T.,_PesoAuto,lColetor, cNumSerie,"","000000") //Layout 42 - Cordão Ericsson Por Ricardo Roda
		ElseIf cLayout == "80"
			U_DOMETQ80(cOP,Nil,1,1,'1',aFilhas,.T.,_PesoAuto,lColetor, cNumSerie) //Layout 80 - Serial Datamatrix Por Michel A. Sander
		ElseIf cLayout == "81"
			U_DOMETQ81(cOP,Nil,1,1,'1',aFilhas,.T.,_PesoAuto,lColetor, cNumSerie) //Layout 81 - Serial em T Datamatrix Por Michel A. Sander
		ElseIf cLayout == "82"
			U_DOMETQ82(cOP,Nil,1,1,'1',aFilhas,.T.,_PesoAuto,lColetor, cNumSerie) //Layout 82 - Serial Datamatrix Sem Numeração Por Michel A. Sander
		ElseIf cLayout == "83"
			U_DOMETQ83(cOP,Nil,1,1,'1',aFilhas,.T.,_PesoAuto,lColetor, cNumSerie) //Layout 83 - Junção 28 Trunk Por Michel A. Sander
		ElseIf cLayout == "84"
			U_DOMETQ84(cOP,Nil,1,1,'1',aFilhas,.T.,_PesoAuto,lColetor, cNumSerie) //Layout 84 - Junção 29 Trunk Por Michel A. Sander
		ElseIf cLayout == "85"
			U_DOMETQ85(cOP,Nil,1,1,'1',aFilhas,.T.,_PesoAuto,lColetor, cNumSerie) //Layout 85 - Cordão Ericsson Por Michel A. Sander
		ElseIf cLayout == "86"
			U_DOMETQ86(cOP,Nil,1,1,'1',aFilhas,.T.,_PesoAuto,lColetor, cNumSerie) //Layout 86 - Mini-Harness Serial Trunk Por Michel A. Sander
		ElseIf cLayout == "87"
			If lNewDL7
				U_DOMET87B(cOP,Nil,1,1,'1',aFilhas,.T.,_PesoAuto,lColetor, cNumSerie) //Layout 87 - HUAWEI 50x100 mm Por Michel A. Sander ZEBRA DESIGN
			Else
				U_DOMETQ87(cOP,Nil,1,1,'1',aFilhas,.T.,_PesoAuto,lColetor, cNumSerie) //Layout 87 - HUAWEI 50x100 mm Por Michel A. Sander CRYSTAL REPORTS
			EndIf
		ElseIf cLayout == "94"
			U_DOMETQ98(cOp,Nil,1,1,'1',aFilhas,.T.,_PesoAuto,lColetor, cNumSerie) //Layout 98 - Etiqueta Somente com CODBAR
			U_DOMETQ94(cOP,Nil,1,1,'1',aFilhas,.T.,_PesoAuto,lColetor, cNumSerie) //Layout 36 - Por Michel A. Sander
		ElseIf cLayout == "99"
			IF U_VALIDACAO()  .Or. .T.// RODA 20/08/2021
				U_DOMET87B(cOP,Nil,1,1,'1',aFilhas,.T.,_PesoAuto,lColetor, cNumSerie) //Layout 36 - Por Michel A. Sander
			Else
				U_DOMETQ99(cOP,Nil,1,1,'1',aFilhas,.T.,_PesoAuto,lColetor, cNumSerie) //Layout 36 - Por Michel A. Sander
			endif
		ElseIf cLayout == "116"
			U_DOMET87B(cOP,Nil,1,1,'1',aFilhas,.T.,_PesoAuto,lColetor, cNumSerie) //Layout 36 - Por Michel A. Sander
		ElseIf cLayout == "117"
			U_DOMET87B(cOP,Nil,1,1,'1',aFilhas,.T.,_PesoAuto,lColetor, cNumSerie) //Layout 36 - Por Michel A. Sander
		Else
			MsgInfo("Layout não encontrado para este Cliente/Grupo de Produtos.")
			_Retorno := .F.
		EndIf

		if  U_VALIDACAO() .OR. .T. // RODA 16/09/2021
			lGlobal := .F.

			//if !empty(SB1->B1_BASE)
			_BaseCod := Subs(SC2->C2_PRODUTO,1,2)
			_UltDig:= Subs(SC2->C2_PRODUTO,LEN(ALLTRIM(SC2->C2_PRODUTO)),1)
			IF _BaseCod+_UltDig  $ "CH9|CM9|CO9|DPB|FXE|MDB|MSB|PB9|TE9"
				//If ("GLOBO GROUP S.A." $ Upper(SA1->A1_NOME)) .Or. ("GLOBO GROUP S.A." $ Upper(SA1->A1_NREDUZ))  //Subs(SC2->C2_PRODUTO,15,1) $ GetMV("MV_XLAY117")  //
				lGlobal := .T.
			EndIf
			If lGlobal
				MsgRun("Imprimindo etiqueta Layout 117","Aguarde...",{|| lRetEtq := U_DOMET117(cOP,Nil,1,1,'1',aFilhas,.T.,_PesoAuto,lColetor, cNumSerie) })
			Endif
			//Endif
		Endif


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Imprime a etiqueta da OI S/A											 			³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If GetMv("MV_XVEROI")
			If lOi
				U_DOMET106(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN, SC2->C2_PRODUTO, SC2->C2_PEDIDO, 1, dDataBase, .F., "", 0, 1,cfila)
			EndIf
		EndIf

	Else
		Aviso("Atenção","OP invalida.",{"Ok"})
		cOP := Space(12)
		_Retorno := .F.
		Return _Retorno
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fEmbKitPig ºAutor³ Michel Sander      º Data ³  06.09.2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca Embalagem do Kit PigTail					              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fEmbKitPig(cProdKit, cNivelKit)

	LOCAL _Retorno := {"", 0, "", .F.}

	SG1->( dbSetOrder(1) )
	If SG1->( dbSeek( xFilial() + cProdKit ) )
		While !SG1->( EOF() ) .and. SG1->G1_COD == cProdKit
			If SG1->G1_XXEMBNIV == cNivelKit
				_Retorno[1] := SG1->G1_COMP
				_Retorno[2] := SG1->G1_QUANT
				_Retorno[3] := SG1->G1_XXEMBNI
				_Retorno[4] := .T.
				Exit
			EndIf
			SG1->( dbSkip() )
		End
	EndIf

Return ( _Retorno )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VCodHuawei  ºAutor³ Michel Sander     º Data ³  23.07.2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica PB Huawei no pedido de vendas			              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VCodHuawei()

	LOCAL _Retorno := .T.
	//Alert("Validação ok")

	If Empty(cCodHuawei)
		Return .T.
	EndIf

	If Len(Alltrim(cCodHuawei)) <> 19
		MsgRun("Código inválido","Erro",{||fEspera(1)})
		cCodHuawei := SPACE(100)//SPACE(Len(XD1->XD1_ETQHUA))
		oCodHuawei:Refresh()
		Return .F.
	EndIf


	If Left(Alltrim(cCodHuawei),1) <> "P"
		MsgRun("Código inválido","Erro",{||fEspera(1)})
		cCodHuawei := SPACE(100)//SPACE(Len(XD1->XD1_ETQHUA))
		oCodHuawei:Refresh()
		Return .F.
	EndIf

	XD1->( dbSetOrder(7) ) // XD1_FILIAL + XD1_ETQHUA
	If XD1->( dbSeek( xFilial() + Alltrim(cCodHuawei) ) )
		lOk := .T.
		While !XD1->( EOF() ) .and. Alltrim(XD1->XD1_ETQHUA) == Alltrim(cCodHuawei)
			If XD1->XD1_OCORRE <> '5'   // Cancelada
				lOk := .F.
				Exit
			EndIf
			XD1->( dbSkip() )
		End
		If !lOk
			MsgStop("Etiqueta Huawei já utilizada anteriormente. DESCARTE esta etiqueta e solicite uma nova ao PCP")
			cCodHuawei := SPACE(100)//SPACE(Len(XD1->XD1_ETQHUA))
			oCodHuawei:Refresh()
			Return .F.
		EndIf
	EndIf

	SC6->(dbSetOrder(1))
	If Empty(SC2->C2_PEDIDO)
		While !MsgNoYes("Não é permitido a produção para o cliente Huawei sem amarração da OP com o Pedido de Vendas (OF). Favor contatar o PCP. "+CHR(13)+Chr(13)+"Deseja continuar?")
		End
		Return .F.
	EndIf

	If SC5->(dbSeek(xFilial("SC5") + SC2->C2_PEDIDO))
		SC6->(dbSeek(xFilial()+SC5->C5_NUM+SC2->C2_ITEM+SC2->C2_PRODUTO))
		If AllTrim(SC6->C6_SEUCOD) <> Subs(cCodHuawei,2,8)
			While !MsgNoYes("Código Huawei inválido. O código não corresponde ao PN do item no pedido " + SC6->C6_SEUCOD + CHR(13)+Chr(13)+"Deseja continuar?")
			End
			cCodHuawei := SPACE(100)//SPACE(Len(XD1->XD1_ETQHUA))
			oCodHuawei:Refresh()
			Return .F.
		EndIf
	Else
		While !MsgNoYes("Pedido de Vendas (OF) amarrado à OP inválido " + SC6->C6_SEUCOD + CHR(13)+Chr(13)+"Deseja continuar?")
		End
		cCodHuawei := SPACE(100)//SPACE(Len(XD1->XD1_ETQHUA))
		oCodHuawei:Refresh()
		Return .F.
	EndIf

	If _Retorno
		cCodHua2ok := cCodHuawei
	EndIf


	oEtiqueta:SetFocus()

Return _Retorno

Static Function VCdHuawei2()


	LOCAL _Retorno := .T.
	//Alert("Validação ok")

	//If Empty(cCdHuawei2)
	//	Return .T.
	//EndIf

	If Len(Alltrim(cCdHuawei2)) < 10
		MsgRun("Código inválido","Erro",{||fEspera(1)})
		cCdHuawei2 := SPACE(100)//SPACE(Len(XD1->XD1_ETQHUA))
		oCdHuawei2:Refresh()
		Return .F.
	EndIf

	If left(Alltrim(cCdHuawei2),2) <> "19"
		MsgRun("Código inválido","Erro",{||fEspera(1)})
		cCdHuawei2 := SPACE(100)//SPACE(Len(XD1->XD1_ETQHUA))
		oCdHuawei2:Refresh()
		Return .F.
	EndIf
	If XD1->(FieldPos("XD1_EHUASN")) > 0
		XD1->( dbSetOrder(7) ) // XD1_FILIAL + XD1_ETQHUA
		If XD1->( dbSeek( xFilial() + Alltrim(cCdHuawei2) ) )
			lOk := .T.
			While !XD1->( EOF() ) .and. Alltrim(XD1->XD1_EHUASN) == Alltrim(cCdHuawei2)
				If XD1->XD1_OCORRE <> '5'   // Cancelada
					lOk := .F.
					Exit
				EndIf
				XD1->( dbSkip() )
			End
			If !lOk
				MsgStop("Etiqueta Huawei já utilizada anteriormente. DESCARTE esta etiqueta e solicite uma nova ao PCP")
				cCdHuawei2 := SPACE(100)//SPACE(Len(XD1->XD1_ETQHUA))
				oCdHuawei2:Refresh()
				Return .F.
			EndIf
		EndIf
	Endif

	SC6->(dbSetOrder(1))
	If Empty(SC2->C2_PEDIDO)
		While !MsgNoYes("Não é permitido a produção para o cliente Huawei sem amarração da OP com o Pedido de Vendas (OF). Favor contatar o PCP. "+CHR(13)+Chr(13)+"Deseja continuar?")
		End
		Return .F.
	EndIf

	If SC5->(dbSeek(xFilial("SC5") + SC2->C2_PEDIDO))
		SC6->(dbSeek(xFilial()+SC5->C5_NUM+SC2->C2_ITEM+SC2->C2_PRODUTO))
		If AllTrim(SC6->C6_SEUCOD) <> Subs(cCdHuawei2,3,8)
			While !MsgNoYes("Código Huawei inválido. O código não corresponde ao PN do item no pedido " + SC6->C6_SEUCOD + CHR(13)+Chr(13)+"Deseja continuar?")
			End
			cCdHuawei2 := SPACE(100)//SPACE(Len(XD1->XD1_ETQHUA))
			oCdHuawei2:Refresh()
			Return .F.
		EndIf
	Else
		While !MsgNoYes("Pedido de Vendas (OF) amarrado à OP inválido " + SC6->C6_SEUCOD + CHR(13)+Chr(13)+"Deseja continuar?")
		End
		cCdHuawei2 := SPACE(100)//SPACE(Len(XD1->XD1_ETQHUA))
		oCdHuawei2:Refresh()
		Return .F.
	EndIf


	If !Empty(cCodHua2ok)
		cCodHua2ok := ""
	EndIf
	oDlgHuawei:End()

	oEtiqueta:SetFocus()


Return _Retorno



Static Function fEspera(nSeg)
	Sleep(nSeg*1000)
Return

Static Function fButtCel()

	Local oButton1
	Local oButton2
	Local oButton3
	Local oButton4
	Local oButton5
	Local oButton6
	Local oButton7
	Local oButton8
	Local oButton9
	Local oButton10
	Local oButton11

	Local cCel:= ""
	Local cCSSBtN1 :="QPushButton{background-color: #f6f7fa; color: #707070; font: bold 22px Arial; }"+;
		"QPushButton:pressed {background-color: #50b4b4; color: white; font: bold 22px  Arial; }"+;
		"QPushButton:hover {background-color: #878787 ; color: white; font: bold 22px  Arial; }"

	Static oDlg


	DEFINE MSDIALOG oDlg TITLE "Escolha a sua célula de trabalho" FROM 000, 000  TO 480, 840 COLORS 0, 16777215 PIXEL

	@ 010, 018 BUTTON oButton1 PROMPT "LINHA 1" SIZE 119, 043 OF oDlg ACTION (cCel := "LINHA 1", oDlg:end() ) PIXEL
	oButton1:setCSS(cCSSBtN1)
	@ 010, 151 BUTTON oButton2 PROMPT "LINHA 2" SIZE 119, 043 OF oDlg ACTION (cCel := "LINHA 2", oDlg:end() ) PIXEL
	oButton2:setCSS(cCSSBtN1)
	@ 010, 284 BUTTON oButton3 PROMPT "LINHA 3" SIZE 119, 043 OF oDlg ACTION (cCel := "LINHA 3", oDlg:end() ) PIXEL
	oButton3:setCSS(cCSSBtN1)

	@ 069, 018 BUTTON oButton4 PROMPT "LINHA 4" SIZE 119, 043 OF oDlg ACTION (cCel := "LINHA 4", oDlg:end() ) PIXEL
	oButton4:setCSS(cCSSBtN1)
	@ 069, 151 BUTTON oButton5 PROMPT "LINHA 5" SIZE 119, 043 OF oDlg ACTION (cCel := "LINHA 5", oDlg:end() ) PIXEL
	oButton5:setCSS(cCSSBtN1)
	@ 069, 284 BUTTON oButton6 PROMPT "LINHA 6" SIZE 119, 043 OF oDlg ACTION (cCel := "LINHA 6", oDlg:end() ) PIXEL

	oButton6:setCSS(cCSSBtN1)
	@ 128, 018 BUTTON oButton7 PROMPT "LINHA 7" SIZE 119, 043 OF oDlg ACTION (cCel := "LINHA 7", oDlg:end() ) PIXEL
	oButton7:setCSS(cCSSBtN1)
	@ 128, 151 BUTTON oButton8 PROMPT "DIO 1" SIZE 119, 043 OF oDlg ACTION (cCel := "DIO 1", oDlg:end() ) PIXEL
	oButton8:setCSS(cCSSBtN1)
	@ 128, 284 BUTTON oButton9 PROMPT "DIO 2" SIZE 119, 043 OF oDlg ACTION (cCel := "DIO 2", oDlg:end() ) PIXEL
	oButton9:setCSS(cCSSBtN1)

	@ 187, 018 BUTTON oButton11 PROMPT "DROP" SIZE 119, 043 OF oDlg ACTION (cCel := "DROP", oDlg:end() ) PIXEL
	oButton11:setCSS(cCSSBtN1)
	@ 187, 151 BUTTON oButton10 PROMPT "TRUNK" SIZE 119, 043 OF oDlg ACTION (cCel := "TRUNK 1", oDlg:end() ) PIXEL
	oButton10:setCSS(cCSSBtN1)


	ACTIVATE MSDIALOG oDlg CENTERED

Return cCel


Static Function fLocImp(cCel)
	Local cQuery:= ""
	Local cFila	:= ""

	IF SELECT ("QCB5") > 0
		QCB5->(DBCLOSEAREA())
	ENDIF

	cQuery:= " SELECT TOP 1 CB5_CODIGO FROM CB5010 "
	cQuery+= " WHERE CB5_DESCRI = '"+cCel+"'  "
	cQuery+= " AND D_E_L_E_T_ = '' "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QCB5",.T.,.T.)

	IF QCB5->(!EOF())
		cFila := QCB5->CB5_CODIGO
	else
		Msginfo("Local de impressão "+cCel+" não identificado", "aviso")
	ENDIF

	IF SELECT ("QCB5") > 0
		QCB5->(DBCLOSEAREA())
	ENDIF

Return cFila
//teste/
