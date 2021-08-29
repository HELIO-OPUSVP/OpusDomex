#include "protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DOMETDLG4 ºAutor  ³ Helio Ferreira     º Data ³  05/11/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMETDL4()

Local lLoop    := .T.
Local lOk      := .F.
Local aPar     := {}
Local aRet     := {}
Local aLayout  := {}

Private mv_par01  := 1         //Pesquisar por OP ou Senf
Private mv_par02  := Space(11) //Numero OP
Private mv_par03  := Space(09) //Senf + Item
Private cLayout   := Space(02) //Layout da Etiqueta
Private _PesoAuto := 0
Private nTpProc   := 1
Private cOP       := Space(12)
Private cNumSerie
Private oOP

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

While lLoop
	
	//Chama tela de perguntas
	
	DEFINE MSDIALOG oDlg FROM  000,000 TO 140,330 TITLE OemToAnsi("DOMETDL4 - Etiqueta unitaria por OP") PIXEL
	
	@ 008,010 SAY oTexto1 Var OemtoAnsi("Ordem de Produção")    SIZE 70,12 OF oDlg PIXEL
	oTexto1:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
	
	@ 006,080 MSGET oOP Var cOP   Picture "@R" Valid Imprime() SIZE 68,09 OF oDlg PIXEL	
	oOP:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
	
	@ 017,10  TO 045,065 LABEL " Tipo de Busca "	OF oDlg PIXEL
	@ 024,20  RADIO oTpBusca 		VAR nTpProc ITEMS "Por OP","Por Serial" SIZE 50,10 OF oDlg PIXEL
	@ 50,010  Button oUltima PROMPT "Cancelar Última Etiqueta"  SIZE 70,13 Action CanImpBip()                    Pixel
	@ 50,090  Button                "Sair"                      Size 70,13 Action {|| oDlg:End(), lLoop := .F. } Pixel
	
	ACTIVATE MSDIALOG oDlg CENTER //ON INIT EnchoiceBar(oDlg,{||(lOk:=.T.,oDlg:End())},{||(lOk:=.F.,oDlg:End())})
	
End

Return


Static Function Imprime()
_Retorno := .T.

If !Empty(cOP)
	cNumSerie := ""
	If nTpProc == 1
		If !SC2->(dbSeek(xFilial("SC2")+Subs(cOP,1,11)))
			Aviso("Atenção","OP invalida.",{"Ok"})
			cOP := Space(12)
			oOP:SetFocus()          
			_Retorno := .F.
			Return _Retorno
		EndIf
	Else
		//_cSerieIni:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(mv_par07,1)	// MV_PAR07 Sequencial Serial
		cNumSerie := cOP
		nItOP     := StrZero(Val(SubStr(cOP,8,1)),3)
		cOP       := PADR(SubsTr(cOP,1,5),6)+SubsTr(cOP,6,2)+nItOP
		If !SC2->(dbSeek(xFilial("SC2")+cOP))
			Aviso("Atenção","OP invalida.",{"Ok"})
			cOP := Space(12)
			oOP:SetFocus()
			_Retorno := .F.
			Return _Retorno
		Else
			//cOP := cNumSerie
		EndIf
	EndIf
	
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
		oOP:SetFocus()
		_Retorno := .F.
		Return _Retorno
	EndIf
	
	cLayout   := SZG->ZG_LAYOUT
	_PesoAuto := 0
	lColetor  := .F.
	
	If cLayout == "01"
		U_DOMETQ04(cOP,Nil,1,1,'1',{},.T.,_PesoAuto,lColetor, cNumSerie) //Layout 01 - HUAWEI UNIFICADA
	ElseIf cLayout == "02"
		U_DOMETQ03(cOP,Nil,1,1,'1',{},.T.,_PesoAuto,lColetor, cNumSerie) //Layout 02
	ElseIf cLayout == "03"
		U_DOMETQ05(cOP,Nil,1,1,'1',{},.T.,_PesoAuto,lColetor, cNumSerie) //Layout 03
	ElseIf cLayout == "04"
		U_DOMETQ06(cOP,Nil,1,1,'1',{},.T.,_PesoAuto,lColetor, cNumSerie) //Layout 04 - Por Michel A. Sander
	ElseIf cLayout == "05"
		U_DOMETQ07(cOP,Nil,1,1,'1',{},.T.,_PesoAuto,lColetor, cNumSerie) //Layout 05 - Por Michel A. Sander
	ElseIf cLayout == "06"
		U_DOMETQ08(cOP,Nil,1,1,'1',{},.T.,_PesoAuto,lColetor, cNumSerie) //Layout 06 - Por Michel A. Sander
	ElseIf cLayout == "07"
		U_DOMETQ09(cOP,Nil,1,1,'1',{},.T.,_PesoAuto,lColetor, cNumSerie) //Layout 07 - Por Michel A. Sander
	ElseIf cLayout == "10"
		U_DOMETQ10(cOP,Nil,1,1,'1',{},.T.,_PesoAuto,lColetor, cNumSerie) //Layout 10 - Por Michel A. Sander
	ElseIf cLayout == "11"
		U_DOMETQ11(cOP,Nil,1,1,'1',{},.T.,_PesoAuto,lColetor, cNumSerie) //Layout 11 - Por Michel A. Sander
	ElseIf cLayout == "12"
		U_DOMETQ12(cOP,Nil,1,1,'1',{},.T.,_PesoAuto,lColetor, cNumSerie) //Layout 11 - Por MLS
	ElseIf cLayout == "13"
		U_DOMETQ13(cOP,Nil,1,1,'1',{},.T.,_PesoAuto,lColetor, cNumSerie) //Layout 11 - Por MLS
	ElseIf cLayout == "14"
		U_DOMETQ14(cOP,Nil,1,1,'1',{},.T.,_PesoAuto,lColetor, cNumSerie) //Layout 11 - Por MLS
	ElseIf cLayout == "15"
		U_DOMETQ15(cOP,Nil,1,1,'1',{},.T.,_PesoAuto,lColetor, cNumSerie) //Layout 15 - Por Michel A. Sander
	ElseIf cLayout == "16"
		U_DOMETQ16(cOP,Nil,1,1,'1',{},.T.,_PesoAuto,lColetor, cNumSerie) //Layout 15 - Por Michel A. Sander
	ElseIf cLayout == "31"
		U_DOMETQ31(cOP,Nil,1,1,'1',{},.T.,_PesoAuto,lColetor, cNumSerie) //Layout 31 - Por Michel A. Sander
	ElseIf cLayout == "36"
		U_DOMETQ36(cOP,Nil,1,1,'1',{},.T.,_PesoAuto,lColetor, cNumSerie) //Layout 36 - Por Michel A. Sander
	ElseIf cLayout == "38"
		U_DOMETQ38(cOP,Nil,1,1,'1',{},.T.,_PesoAuto,lColetor, cNumSerie) //Layout 36 - Por Michel A. Sander
	ElseIf cLayout == "71"
		U_DOMETQ71(cOP,Nil,1,1,'1',{},.T.,_PesoAuto,lColetor, cNumSerie) //Layout 71 - Junção 29 (NOVO) Trunk Por Michel A. Sander
	ElseIf cLayout == "80"
		U_DOMETQ80(cOP,Nil,1,1,'1',{},.T.,_PesoAuto,lColetor, cNumSerie) //Layout 80 - Serial Datamatrix Por Michel A. Sander
	ElseIf cLayout == "81"
		U_DOMETQ81(cOP,Nil,1,1,'1',{},.T.,_PesoAuto,lColetor, cNumSerie) //Layout 81 - Serial em T Datamatrix Por Michel A. Sander
	ElseIf cLayout == "82"
		U_DOMETQ82(cOP,Nil,1,1,'1',{},.T.,_PesoAuto,lColetor, cNumSerie) //Layout 82 - Serial Datamatrix Sem Numeração Por Michel A. Sander
	ElseIf cLayout == "83"
		U_DOMETQ83(cOP,Nil,1,1,'1',{},.T.,_PesoAuto,lColetor, cNumSerie) //Layout 83 - Junção 28 Trunk Por Michel A. Sander
	ElseIf cLayout == "84"
		U_DOMETQ84(cOP,Nil,1,1,'1',{},.T.,_PesoAuto,lColetor, cNumSerie) //Layout 84 - Junção 29 Trunk Por Michel A. Sander
	ElseIf cLayout == "85"
		U_DOMETQ85(cOP,Nil,1,1,'1',{},.T.,_PesoAuto,lColetor, cNumSerie) //Layout 85 - Cordão Ericsson Por Michel A. Sander
	ElseIf cLayout == "86"
		U_DOMETQ86(cOP,Nil,1,1,'1',{},.T.,_PesoAuto,lColetor, cNumSerie) //Layout 86 - Mini-Harness Serial Trunk Por Michel A. Sander
	ElseIf cLayout == "87"
		U_DOMETQ87(cOP,Nil,1,1,'1',{},.T.,_PesoAuto,lColetor, cNumSerie) //Layout 87 - HUAWEI 50x100 mm Por Michel A. Sander
	ElseIf cLayout == "94"
		U_DOMETQ98(cOp,Nil,1,1,'1',{},.T.,_PesoAuto,lColetor, cNumSerie) //Layout 98 - Etiqueta Somente com CODBAR
		U_DOMETQ94(cOP,Nil,1,1,'1',{},.T.,_PesoAuto,lColetor, cNumSerie) //Layout 36 - Por Michel A. Sander
	ElseIf cLayout == "99"
		U_DOMETQ99(cOP,Nil,1,1,'1',{},.T.,_PesoAuto,lColetor, cNumSerie) //Layout 36 - Por Michel A. Sander
	ElseIf cLayout == "106"
		U_DOMET106(cOP,Nil,1,1,'1',{},.T.,_PesoAuto,lColetor, cNumSerie) //Layout 106 - Por Michel A. Sander (Oi S/A)
	Else
		MsgInfo("Layout não encontrado para este Cliente/Grupo de Produtos.")
		_Retorno := .F.
	EndIf
	
	cOP := Space(12)
	oOP:SetFocus()

EndIf

cOP := Space(12)
oOP:SetFocus()

Return _Retorno

Static Function CanImpBip()  // Tratado

MsgInfo("Cancelamento de etiqueta desabilitado. Favor solicitar o estorno para a Lider de Produção.")

Return

If Empty(cDomEtDl31_CancEtq)
	MsgStop("Não existe etiqueta a ser cancelada.")
Else
	If !MsgNoYes("A última etiqueta impressa será CANCELADA."+CHR(13)+"Deseja continuar?")
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
	
	lColetor := .F.
	If cDomEtDl36_CancLay == "01"
		U_DOMETQ04(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor, cNumSerie)		// Impressão de Etiqueta Layout 01
	ElseIf cDomEtDl36_CancLay == "02"
		U_DOMETQ03(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor, cNumSerie)  	// Impressão de Etiqueta Layout 02
	ElseIf cDomEtDl36_CancLay == "03"
		U_DOMETQ05(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor, cNumSerie)		// Layout 03
	ElseIf cDomEtDl36_CancLay == "04"
		U_DOMETQ06(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor, cNumSerie)		// Layout 04 - Por Michel A. Sander
	ElseIf cDomEtDl36_CancLay == "05"
		U_DOMETQ07(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor, cNumSerie)	 	// Impressão de Etiqueta Layout 05
	ElseIf cDomEtDl36_CancLay == "06"
		U_DOMETQ08(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor, cNumSerie)		// Layout 06 - Por Michel A. Sander
	ElseIf cDomEtDl36_CancLay == "07"
		U_DOMETQ09(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor, cNumSerie)		// Layout 07 - Por Michel A. Sander
	ElseIf cDomEtDl36_CancLay == "10"
		U_DOMETQ10(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor, cNumSerie)		// Layout 10 - Por Michel A. Sander
	ElseIf cDomEtDl36_CancLay == "11"
		U_DOMETQ11(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor, cNumSerie)		// Layout 11 - Por Michel A. Sander
	ElseIf cDomEtDl36_CancLay == "12"
		U_DOMETQ12(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor, cNumSerie)		//Layout 12 - Por MLS
	ElseIf cDomEtDl36_CancLay == "13"
		U_DOMETQ12(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor, cNumSerie)		//Layout 12 - Por MLS
	ElseIf cDomEtDl36_CancLay == "31"
		U_DOMETQ31(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor, cNumSerie)		//Layout 31 - Por Michel A. Sander
	ElseIf cDomEtDl36_CancLay == "36"
		U_DOMETQ36(cDomEtDl32_CancOP,cDomEtDl33_CancEmb,cDomEtDl34_CancKit,cDomEtDl35_CancUni,cDomEtDl38_CancNiv,aDomEtDl3A_CancFil,.T.,cDomEtDl39_CancPes,lColetor, cNumSerie)		//Layout 36 - Por Michel A. Sander
	EndIf
	
EndIf

oOP:SetFocus()

Return
