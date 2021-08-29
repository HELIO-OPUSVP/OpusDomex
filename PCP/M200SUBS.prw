#include "rwmake.ch"
//#INCLUDE 'MATA200.CH'
//#INCLUDE 'DBTREE.CH'
#INCLUDE "PROTHEUS.CH"
//#INCLUDE "TBICONN.CH"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M200SUBS  ºAutor  ³Helio Ferreira      º Data ³  11/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M200SUBS()


	Private aArea:=GetArea()
	Private cCodOrig  := Criavar("G1_COMP"  ,.F.), cCodDest  := Criavar("G1_COMP"  ,.F.)
	Private cGrpOrig  := Criavar("G1_GROPC" ,.F.), cGrpDest  := Criavar("G1_GROPC" ,.F.)
	Private cDescOrig := Criavar("B1_DESC"  ,.F.), cDescDest := Criavar("B1_DESC"  ,.F.)
	Private cOpcOrig  := Criavar("G1_OPC"   ,.F.), cOpcDest  := Criavar("G1_OPC"   ,.F.)
	Private nAteQtd   := Criavar("G1_QUANT" ,.F.), nDeQtd    := Criavar("G1_QUANT" ,.F.)
	Private nNewQtd   := Criavar("G1_QUANT" ,.F.), cCodExcl  := Criavar("G1_COMP"  ,.F.)
	Private oSay,oSay2
	Private lOk       :=.F.
	Private aAreaSX3  :=SX3->(GetArea())
	Private nOpc200   := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variavel lPyme utilizada para Tratamento do Siga PyME        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private lPyme:= Iif(Type("__lPyme") <> "U",__lPyme,.F.)

	Private c01POS    := " "
	Private c02POS    := " "
	Private c03POS    := " "
	Private c04POS    := " "
	Private c05POS    := " "
	Private c06POS    := " "
	Private c07POS    := " "
	Private c08POS    := " "
	Private c09POS    := " "
	Private c10POS    := " "
	Private c11POS    := " "
	Private c12POS    := " "
	Private c13POS    := " "
	Private c14POS    := " "
	Private c15POS    := " "
	Private cDoProd   := Criavar("G1_COD"   ,.F.)
	Private cAteProd  := Criavar("G1_COD"   ,.F.), cAteProd  := Repl("Z",15)
	Private cCodInc   := Criavar("G1_COD"   ,.F.)
	Private nQtdInc   := 0

	cUserBlok := '000087/' // Debora Zani
	cUserBlok += '000191/' // Paula Silva
	cUserBlok += '000154/' // Roberta Mariano
//cUserBlok += '000211/' // HELIO

//lAltProd := .T.
//If __cUserID $ cUserBlok
//	cCodOrig := "50010100       "
//	cCodDest := "50010100       "
//	lAltProd := .F.
//EndIf

	cUsrMOD := .F.
	lAltProd := .T.
	If __cUserID $ cUserBlok
		//	cCodOrig := "50010100       "
		//	cCodDest := "50010100       "
		//	lAltProd := .F.
		cUsrMOD := .T.
	EndIf

	dbSelectArea("SX3")
	dbSetOrder(2)
	If dbSeek("G1_OK")
		dbSelectArea("SX3")//manter provisoriamente por causa da mark browse
		dbSetOrder(1) //voltar para indice 1 do sx3
		dbSelectArea("SG1")
		DEFINE MSDIALOG oDlg FROM  140,000 TO 600,600 TITLE OemToAnsi("M200SUBS() - Substituição de Componentes") PIXEL
		DEFINE SBUTTON oBtn FROM 800,800 TYPE 5 ENABLE OF oDlg

		nCol := 09

		@ 005,006 TO 115,290 LABEL OemToAnsi("Filtro da Seleção") OF oDlg PIXEL //"Componente Original"
		@ 016,nCol SAY OemtoAnsi("Componente")   SIZE 35,7  OF oDlg PIXEL
		@ 014,055 MSGET cCodOrig   F3 "SB1" Picture PesqPict("SG1","G1_COMP") WHEN lAltProd Valid (Vazio() .or. ExistCpo("SB1",cCodOrig)) .And. UA200IniDsc(1,oSay,cCodOrig) SIZE 68,09 OF oDlg PIXEL
		@ 016,130 SAY oSay Prompt cDescOrig SIZE 130,6 OF oDlg PIXEL

		nLin := 30
		@ nLin,nCol SAY OemtoAnsi("Da Quantidade")   SIZE 40,7  OF oDlg PIXEL
		@ nLin-2,055 MSGET nDeQtd   Picture PesqPict("SG1","G1_QUANT") Valid .T. SIZE 68,09 OF oDlg PIXEL

		nLin += 15
		@ nLin,nCol SAY OemtoAnsi("Até a Quantidade")   SIZE 70,7  OF oDlg PIXEL
		@ nLin-2,055 MSGET nAteQtd   Picture PesqPict("SG1","G1_QUANT") Valid .T. SIZE 68,09 OF oDlg PIXEL

		nLin += 15
		@ nLin,nCol SAY OemtoAnsi("Do Produto")   SIZE 40,7  OF oDlg PIXEL
		@ nLin-2,055 MSGET cDoProd   Picture "@!" Valid .T. F3 "SB1" SIZE 68,09 OF oDlg PIXEL

		nLin += 15
		@ nLin,nCol SAY OemtoAnsi("Até o Produto")   SIZE 70,7  OF oDlg PIXEL
		@ nLin-2,055 MSGET cAteProd   Picture "@!" Valid .T. F3 "SB1" SIZE 68,09 OF oDlg PIXEL


		nLin += 25
		@ nLin,nCol SAY OemtoAnsi("Código(PI/PA)")   SIZE 40,7  OF oDlg PIXEL
		nCol += 46

		nLin -= 2

		@ nLin-10,nCol+3 SAY "1º"                                SIZE 10,10 OF oDlg PIXEL
		@ nLin,nCol    MSGET c01POS   Picture "@! X" Valid .T. SIZE 1,09 OF oDlg PIXEL
		nCol += 15
		@ nLin-10,nCol+3 SAY "2º"                             SIZE 10,10 OF oDlg PIXEL
		@ nLin,nCol MSGET c02POS   Picture "@! X" Valid .T. SIZE 1,09 OF oDlg PIXEL
		nCol += 15
		@ nLin-10,nCol+3 SAY "3º"                             SIZE 10,10 OF oDlg PIXEL
		@ nLin,nCol MSGET c03POS   Picture "@! X" Valid .T. SIZE 1,09 OF oDlg PIXEL
		nCol += 15
		@ nLin-10,nCol+3 SAY "4º"                             SIZE 10,10 OF oDlg PIXEL
		@ nLin,nCol MSGET c04POS   Picture "@! X" Valid .T. SIZE 1,09 OF oDlg PIXEL
		nCol += 15
		@ nLin-10,nCol+3 SAY "5º"                             SIZE 10,10 OF oDlg PIXEL
		@ nLin,nCol MSGET c05POS   Picture "@! X" Valid .T. SIZE 1,09 OF oDlg PIXEL
		nCol += 15
		@ nLin-10,nCol+3 SAY "6º"                             SIZE 10,10 OF oDlg PIXEL
		@ nLin,nCol MSGET c06POS   Picture "@! X" Valid .T. SIZE 1,09 OF oDlg PIXEL
		nCol += 15
		@ nLin-10,nCol+3 SAY "7º"                             SIZE 10,10 OF oDlg PIXEL
		@ nLin,nCol MSGET c07POS   Picture "@! X" Valid .T. SIZE 1,09 OF oDlg PIXEL
		nCol += 15
		@ nLin-10,nCol+3 SAY "8º"                             SIZE 10,10 OF oDlg PIXEL
		@ nLin,nCol MSGET c08POS   Picture "@! X" Valid .T. SIZE 1,09 OF oDlg PIXEL
		nCol += 15
		@ nLin-10,nCol+3 SAY "9º"                             SIZE 10,10 OF oDlg PIXEL
		@ nLin,nCol MSGET c09POS   Picture "@! X" Valid .T. SIZE 1,09 OF oDlg PIXEL
		nCol += 15
		@ nLin-10,nCol+3 SAY "10º"                             SIZE 10,10 OF oDlg PIXEL
		@ nLin,nCol MSGET c10POS   Picture "@! X" Valid .T. SIZE 1,09 OF oDlg PIXEL
		nCol += 15
		@ nLin-10,nCol+3 SAY "11º"                             SIZE 10,10 OF oDlg PIXEL
		@ nLin,nCol MSGET c11POS   Picture "@! X" Valid .T. SIZE 1,09 OF oDlg PIXEL
		nCol += 15
		@ nLin-10,nCol+3 SAY "12º"                             SIZE 10,10 OF oDlg PIXEL
		@ nLin,nCol MSGET c12POS   Picture "@! X" Valid .T. SIZE 1,09 OF oDlg PIXEL
		nCol += 15
		@ nLin-10,nCol+3 SAY "13º"                             SIZE 10,10 OF oDlg PIXEL
		@ nLin,nCol MSGET c13POS   Picture "@! X" Valid .T. SIZE 1,09 OF oDlg PIXEL
		nCol += 15
		@ nLin-10,nCol+3 SAY "14º"                             SIZE 10,10 OF oDlg PIXEL
		@ nLin,nCol MSGET c14POS   Picture "@! X" Valid .T. SIZE 1,09 OF oDlg PIXEL
		nCol += 15
		@ nLin-10,nCol+3 SAY "15º"                             SIZE 10,10 OF oDlg PIXEL
		@ nLin,nCol MSGET c15POS   Picture "@! X" Valid .T. SIZE 1,09 OF oDlg PIXEL


		nLin := 118
		@ 118,006 TO 156,145 LABEL OemToAnsi("Componente para Substituição") OF oDlg PIXEL
		@ 128,009 SAY OemToAnsi("Produto")   SIZE 24,7  OF oDlg PIXEL //"Produto"
		@ 127,055 MSGET cCodDest   F3 "SB1" Picture PesqPict("SG1","G1_COMP") WHEN lAltProd Valid Vazio() .or. (ExistCpo("SB1",cCodDest) .and. (!cUsrMOD .or. Subs(cCodDest,1,8)=='50010100')) SIZE 68,9 OF oDlg PIXEL
		//@ 127,130 SAY oSay2 Prompt cDescDest SIZE 130,6 OF oDlg PIXEL
		@ 143,009 SAY OemToAnsi("Quantidade")   SIZE 30,7  OF oDlg PIXEL //"Produto"
		@ 141,055 MSGET nNewQtd   Picture PesqPict("SG1","G1_QUANT") Valid nNewQtd >= 0 SIZE 68,9 OF oDlg PIXEL

		@ 118,150 TO 156,290 LABEL OemToAnsi("Componente para Exclusão") OF oDlg PIXEL
		@ 128,154 SAY OemToAnsi("Produto")   SIZE 24,7  OF oDlg PIXEL //"Produto"
		@ 127,200 MSGET cCodExcl   F3 "SB1" Picture PesqPict("SG1","G1_COMP") WHEN lAltProd Valid Vazio() .or. (ExistCpo("SB1",cCodExcl) .and. (!cUsrMOD .or. Subs(cCodExcl,1,8)=='50010100')) SIZE 68,9 OF oDlg PIXEL
		//@ 127,130 SAY oSay2 Prompt cDescDest SIZE 130,6 OF oDlg PIXEL

		nLin  := 160
		nCol1 := 009
		nCol2 := 060
		nCol3 := 120

		nTamInc := 40
		@ nLin,006 TO nLin+nTamInc,290 LABEL OemToAnsi("Componente para Inclusão") OF oDlg PIXEL

		@ nLin+10,nCol1    SAY OemToAnsi("Produto")   SIZE 24,7  OF oDlg PIXEL //"Produto"
		@ nLin+09,nCol1+46 MSGET cCodInc   F3 "SB1" Picture PesqPict("SG1","G1_COMP") WHEN lAltProd Valid Vazio() .or. (ExistCpo("SB1",cCodInc) .and. (!cUsrMOD .or. Subs(cCodInc,1,8)=='50010100')) SIZE 68,9 OF oDlg PIXEL

		@ nLin+25,nCol1    SAY OemToAnsi("Quantidade")   SIZE 30,7  OF oDlg PIXEL //"Produto"
		@ nLin+23,nCol1+46 MSGET nQtdInc   Picture PesqPict("SG1","G1_QUANT") WHEN lAltProd Valid nQtdInc >= 0 SIZE 68,9 OF oDlg PIXEL

		//@ nLin+10,nCol2    SAY OemToAnsi("Qtd. Etiq. 1")   SIZE 24,7  OF oDlg PIXEL //"Produto"
		//@ nLin+09,nCol2+46 MSGET cCodExcl   F3 "SB1" Picture PesqPict("SG1","G1_COMP") WHEN lAltProd Valid NaoVazio(cCodExcl) .And. ExistCpo("SB1",cCodExcl) SIZE 68,9 OF oDlg PIXEL

		//@ nLin+10,nCol2    SAY OemToAnsi("Qtd. Etiq. 2")   SIZE 24,7  OF oDlg PIXEL //"Produto"
		//@ nLin+09,nCol2+46 MSGET cCodExcl   F3 "SB1" Picture PesqPict("SG1","G1_COMP") WHEN lAltProd Valid NaoVazio(cCodExcl) .And. ExistCpo("SB1",cCodExcl) SIZE 68,9 OF oDlg PIXEL

		//@ nLin+10,nCol3    SAY OemToAnsi("Emb. Nivel")   SIZE 24,7  OF oDlg PIXEL //"Produto"
		//@ nLin+09,nCol3+46 MSGET cCodExcl   F3 "SB1" Picture PesqPict("SG1","G1_COMP") WHEN lAltProd Valid NaoVazio(cCodExcl) .And. ExistCpo("SB1",cCodExcl) SIZE 68,9 OF oDlg PIXEL

		nLin += (nTamInc + 08)
		@ nLin,100 Button "Substituir"  Size 40,13 Action {||nOpc200 := 4, UA200PrSubs(cCodOrig,cGrpOrig,cOpcOrig,cCodDest,cGrpDest,cOpcDest,nDeQtd,nAteQtd,nNewQtd)} Pixel
		@ nLin,150 Button "Incluir"     Size 40,13 Action {||nOpc200 := 3, UA200PrSubs(cCodOrig,cGrpOrig,cOpcOrig,cCodDest,cGrpDest,cOpcDest,nDeQtd,nAteQtd,nNewQtd)} WHEN lAltProd Pixel
		@ nLin,200 Button "Excluir"     Size 40,13 Action {||nOpc200 := 5, UA200PrSubs(cCodOrig,cGrpOrig,cOpcOrig,cCodDest,cGrpDest,cOpcDest,nDeQtd,nAteQtd,nNewQtd)} WHEN lAltProd Pixel
		@ nLin,250 Button "Cancelar"    Size 40,13 Action oDlg:End()       Pixel

		ACTIVATE MSDIALOG oDlg CENTER //ON INIT EnchoiceBar(oDlg,{||(lOk:=.T.,oDlg:End())},{||(lOk:=.F.,oDlg:End())})
		// Processa substituicao dos componentes
	Else
		Aviso(OemToAnsi("Atencao"),OemToAnsi("Para utilizacao dessa opcao deve ser criado o campo G1_OK semelhante ao campo C9_OK."),{"Ok"}) //"Atencao"###"Para utilizacao dessa opcao deve ser criado o campo G1_OK semelhante ao campo C9_OK."
	EndIf
	SX3->(RestArea(aAreaSX3))
	RestArea(aArea)

Return

Static Function UA200PrSubs(cCodOrig,cGrpOrig,cOpcOrig,cCodDest,cGrpDest,cOpcDest,nDeQtd,nAteQtd,nNewQtd)

	Local cFilSG1     := ""
	Local aIndexSG1   := {}
	Local aBackRotina := ACLONE(aRotina)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variavel lPyme utilizada para Tratamento do Siga PyME        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local lPyme:= Iif(Type("__lPyme") <> "U",__lPyme,.F.)

	PRIVATE aDadosDest:= {cCodDest,nNewQtd}
	PRIVATE cMarca200 := ThisMark()
	PRIVATE bFiltraBrw
	PRIVATE cCadastro := OemToAnsi("Substituição de Componentes")
	Private cQrySG1     := ""

	If nOpc200 == 4 // Alterar ou substituir
		If Empty(cCodDest)
			MsgStop("Favor preencher o produto do Componente para Substituição.")
			Return
		Else
			If Empty(nNewQtd)
				If !MsgYesNo("Quantidade do Componente para Substituição não preenchida. Deseja desconsiderar a quantidade e substituir apenas o Produto?")
					Return
				EndIf
			EndIf
		EndIf

		aRotina   := {  {"Substituir","U_U200DoSub", 0 , 1}}
	Else
		If !Empty(cCodDest) .or. !Empty(nNewQtd)
			MsgStop("Favor não preencher os campos destinados a Substituição de Componentes.")
			Return
		EndIf
	EndIf

	If nOpc200 == 3 // Incluir
		If Empty(cCodInc) .or. Empty(nQtdInc)
			MsgStop("Favor preencher os campos destinados a Inclusão de Componentes.")
			Return
		EndIf
		aRotina   := {  {"Incluir","U_U200DoSub", 0 , 2}}
	Else
		If !Empty(cCodInc) .or. !Empty(nQtdInc)
			MsgStop("Favor não preencher os campos destinados a Inclusão de Componentes.")
			Return
		EndIf
	EndIf

	If nOpc200 == 5 // Excluir
		If Empty(cCodExcl)
			MsgStop("Favor preencher o campo destinado a Exclusão de Componentes.")
			Return
		EndIf
		aRotina   := {  {"Excluir","U_U200DoSub", 0 , 3}}
	Else
		If !Empty(cCodExcl)
			MsgStop("Favor não preencher o campo destinado a Exclusão de Componentes.")
			Return
		EndIf
	EndIf

	oDlg:End()

	cFilSG1 := "G1_FILIAL='"+xFilial("SG1")+"'"
	cQrySg1 := "SG1.G1_FILIAL='"+xFilial("SG1")+"'"


	If nOpc200 == 5 // Excluir
		cFilSG1 += ".And.    G1_COMP=='"+cCodExcl+"'"   // Diferente
		cFilSG1 += " .And.  G1_COD >= '"+cDoProd+"' .And.   G1_COD <= '"+cAteProd+"'"

		cQrySg1 += " AND SG1.G1_COMP='"+cCodExcl+"'"
		cQrySg1 += " AND SG1.G1_COD BETWEEN '"+cDoProd+"' AND  '"+cAteProd+"'"
		If !Empty(cCodOrig)
			cQrySg1 += " AND G1_COD IN ( (SELECT G1_COD FROM " + RetSqlName("SG1") + " SG1 "
			cQrySg1 += " WHERE SG1.G1_COMP='"+cCodOrig+"' "
			cQrySg1 += " AND SG1.D_E_L_E_T_ = '' "
			cQrySg1 += " GROUP BY G1_COD ) )"
		EndIf

	EndIf

	If nOpc200 == 3 // Incluir
		cFilSG1 += ".And.    G1_COMP=='"+cCodOrig+"'"
		cQrySg1 += " AND SG1.G1_COMP='"+cCodOrig+"'"
	EndIf

	If nOpc200 == 4 // Alterar / Substituir
		cFilSG1 += ".And.    G1_COMP=='"+cCodOrig+"'"
		cQrySg1 += " AND SG1.G1_COMP='"+cCodOrig+"'"
	EndIf


// Filtro da Quantidade
	cFilSG1 += ".And. G1_QUANT >= "+Str(nDeQtd)+" "
	cFilSG1 += ".And. G1_QUANT <= "+Str(nAteQtd)+" "

	cQrySg1 += " And  SG1.G1_QUANT >= "+Str(nDeQtd)+" "
	cQrySg1 += " And  SG1.G1_QUANT <= "+Str(nAteQtd)+" "

//If !lPyme
//	  cFilSG1 += ".And.G1_GROPC=='"+cGrpOrig+"'"
//	  cFilSG1 += ".And.G1_OPC=='"+cOpcOrig+"'"
//EndIf
//If !lPyme
//	  cQrySg1 += " AND SG1.G1_GROPC='"+cGrpOrig+"'"
//	  cQrySg1 += " AND SG1.G1_OPC='"+cOpcOrig+"'"
//EndIf

// Filtros no Código do PA

	aRet := RetFil()

	cFilSG1 += aRet[1]
	cQrySg1 += aRet[2]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Realiza a Filtragem                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SG1")
	dbSetOrder(1)
	bFiltraBrw := {|x| If(x==Nil,FilBrowse("SG1",@aIndexSG1,@cFilSG1),{cFilSG1,cQrySG1,"","",aIndexSG1}) }
	Eval(bFiltraBrw)

	dbSelectArea("SG1")
	If !MsSeek(xFilial("SG1"))
		HELP(" ",1,"RECNO")
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Monta o browse para a selecao                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		MarkBrow("SG1","G1_OK")
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura condicao original                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SG1")
	RetIndex("SG1")
	dbClearFilter()
	aEval(aIndexSG1,{|x| Ferase(x[1]+OrdBagExt())})
	aRotina:=ACLONE(aBackRotina)

Return Nil


Static Function UA200IniDsc(nOpcao,oSay,cProduto)
	SB1->(MsSeek(xFilial("SB1")+cProduto))
	If nOpcao == 1
		cDescOrig:=SB1->B1_DESC
		// Preenche descricao do produto
		oSay:SetText(cDescOrig)
	ElseIf nOpcao == 2
		//cDescDest:=SB1->B1_DESC
		// Preenche descricao do produto
		//oSay:SetText(cDescDest)
	EndIf
// Troca a cor do texto para vermelho
	oSay:SetColor(CLR_HRED,GetSysColor(15))

RETURN .T.


User Function U200DoSub(cAlias,nRecno,nOpc,cMarca200,lInverte)

	MsgRun("Processando alterações...","Favor Aguardar.....",{|| ProcRun(cAlias,nRecno,nOpc,cMarca200,lInverte) })

Return

Static Function ProcRun(cAlias,nRecno,nOpc,cMarca200,lInverte)
	Local aRecnosSG1:={}
	Local nz:=0
   //cQuery := "SELECT R_E_C_N_O_ FROM " + RetSqlName("SG1") + " WHERE G1_OK = '"+cMarca200+"' AND G1_FILIAL = '" + xFilial("SG1") + "' AND D_E_L_E_T_ = '' "
	cQuery   := "SELECT G1_OK, R_E_C_N_O_ FROM " + RetSqlName("SG1") + " SG1 WHERE " + cQrySG1 + " ORDER BY G1_OK DESC "

	If Select("QUERYSG1") <> 0
		QUERYSG1->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS "QUERYSG1"

	dbSelectArea("SG1")
	dbSeek(xFilial("SG1"))

	While !QUERYSG1->( Eof() )
		// Verifica os registros marcados para substituicao
		SG1->( dbGoTo(QUERYSG1->R_E_C_N_O_) )
		If SG1->( Recno() ) == QUERYSG1->R_E_C_N_O_
			If lInverte
				If SG1->G1_OK <> cMarca200
					AADD(aRecnosSG1,QUERYSG1->R_E_C_N_O_)
				EndIf
			Else
				If SG1->G1_OK == cMarca200
					AADD(aRecnosSG1,QUERYSG1->R_E_C_N_O_)
				EndIf
			EndIf
			//If IsMark("SG1->G1_OK",cMarca200,lInverte)
			//	AADD(aRecnosSG1,QUERYSG1->R_E_C_N_O_)
			//EndIf
		EndIf
		QUERYSG1->( dbSkip() )
	End
// Grava a substituicao de componentes

//aRecnosSG1 := {}

	For nz:=1 to Len(aRecnosSG1)
		SG1->( dbGoto(aRecnosSG1[NZ]) )    //450911
		If SG1->( Recno() ) == aRecnosSG1[NZ]
			If nOpc200 == 4   // Alterar / Substituir
				Reclock("SG1",.F.)
				SG1->G1_COMP  := aDadosDest[1]
				If !Empty(aDadosDest[2])
					SG1->G1_QUANT := aDadosDest[2]
				EndIf
				SG1->( MsUnlock() )
			EndIf
			If nOpc200 == 5  // Excluir
				Reclock("SG1",.F.)
				//SG1->G1_FIM := StoD("19501231")
				SG1->G1_OBSERV := ".."
				SG1->( dbDelete() )
				SG1->( MsUnlock() )
			EndIf
			If nOpc200 == 3  // Incluir
				cG1COD := SG1->G1_COD
				cQuery := "SELECT R_E_C_N_O_ FROM " + RetSqlName("SG1") + " WHERE G1_COD = '"+SG1->G1_COD+"' AND G1_COMP = '"+cCodInc+"' AND D_E_L_E_T_ = '' "
				If Select("QUERYSG1") <> 0
					QUERYSG1->( dbCloseArea() )
				EndIf
				TCQUERY cQuery NEW ALIAS "QUERYSG1"
				If Empty(QUERYSG1->R_E_C_N_O_)
					Reclock("SG1",.T.)
					SG1->G1_FILIAL  := xFilial("SG1")
					SG1->G1_COD     := cG1COD
					SG1->G1_COMP    := cCodInc
					SG1->G1_QUANT   := nQtdInc
					SG1->G1_INI     := StoD("20071231")
					SG1->G1_FIM     := StoD("20491231")
					SG1->G1_FIXVAR  := "V"
					SG1->G1_REVFIM  := "ZZZ"
					SG1->G1_VLCOMPE := "N"
					SG1->( MsUnlock() )
				EndIf
			EndIf
		EndIf
	Next nz

// Altera conteudo do parametro de niveis
	If Len(aRecnosSG1) > 0
		a200NivAlt()
	EndIf

Return


Static Function RetFil()
	Local aRetorno := {}
	Local cFil := ""
	Local cQry := ""

	cFil += " .and. G1_COD >= '" + cDoProd + "' .and. G1_COD <= '"+cAteProd+"'"
	cQry += " AND SG1.G1_COD >= '" + cDoProd + "' AND SG1.G1_COD <= '"+cAteProd+"'""

	If !Empty(c01POS) .and. Empty(c02POS+c03POS+c04POS+c05POS+c06POS+c07POS+c08POS+c09POS+c10POS+c11POS+c12POS+c13POS+c14POS+c15POS)
		cFil += " .and. Substring(G1_COD,1,1) = '" + c01POS + "'"
		cQry += " AND Substring(SG1.G1_COD,1,1) = '" + c01POS + "'"
	Else
		If !Empty(c01POS+c02POS) .and. Empty(c03POS+c04POS+c05POS+c06POS+c07POS+c08POS+c09POS+c10POS+c11POS+c12POS+c13POS+c14POS+c15POS)
			cFil += " .and. Substring(G1_COD,1,2) = '" + c01POS + c02POS + "'"
			cQry += " AND Substring(SG1.G1_COD,1,2) = '" + c01POS + c02POS + "'"
		Else
			If !Empty(c01POS+c02POS+c03POS) .and. Empty(c04POS+c05POS+c06POS+c07POS+c08POS+c09POS+c10POS+c11POS+c12POS+c13POS+c14POS+c15POS)
				cFil += " .and. Substring(G1_COD,1,3) = '" + c01POS + c02POS + c03POS + "'"
				cQry += " AND Substring(SG1.G1_COD,1,3) = '" + c01POS + c02POS + c03POS + "'"
			Else
				If !Empty(c01POS+c02POS+c03POS+c04POS) .and. Empty(c05POS+c06POS+c07POS+c08POS+c09POS+c10POS+c11POS+c12POS+c13POS+c14POS+c15POS)
					cFil += " .and. Substring(G1_COD,1,4) = '" + c01POS + c02POS + c03POS + c04POS + "'"
					cQry += " AND Substring(SG1.G1_COD,1,4) = '" + c01POS + c02POS + c03POS + c04POS + "'"
				Else
					If !Empty(c01POS+c02POS+c03POS+c04POS+c05POS) .and. Empty(c06POS+c07POS+c08POS+c09POS+c10POS+c11POS+c12POS+c13POS+c14POS+c15POS)
						cFil += " .and. Substring(G1_COD,1,5) = '" + c01POS + c02POS + c03POS + c04POS + c05POS + "'"
						cQry += " AND Substring(SG1.G1_COD,1,5) = '" + c01POS + c02POS + c03POS + c04POS + c05POS + "'"
					Else
						If !Empty(c01POS+c02POS+c03POS+c04POS+c05POS+c06POS) .and. Empty(c07POS+c08POS+c09POS+c10POS+c11POS+c12POS+c13POS+c14POS+c15POS)
							cFil += " .and. Substring(G1_COD,1,6) = '" + c01POS + c02POS + c03POS + c04POS + c05POS + c06POS + "'"
							cQry += " AND Substring(SG1.G1_COD,1,6) = '" + c01POS + c02POS + c03POS + c04POS + c05POS + c06POS + "'"
						Else
							If !Empty(c01POS+c02POS+c03POS+c04POS+c05POS+c06POS+c07POS) .and. Empty(c08POS+c09POS+c10POS+c11POS+c12POS+c13POS+c14POS+c15POS)
								cFil += " .and. Substring(G1_COD,1,7) = '" + c01POS + c02POS + c03POS + c04POS + c05POS + c06POS + c07POS + "'"
								cQry += " AND Substring(SG1.G1_COD,1,7) = '" + c01POS + c02POS + c03POS + c04POS + c05POS + c06POS + c07POS + "'"
							Else
								If !Empty(c01POS+c02POS+c03POS+c04POS+c05POS+c06POS+c07POS+c08POS) .and. Empty(c09POS+c10POS+c11POS+c12POS+c13POS+c14POS+c15POS)
									cFil += " .and. Substring(G1_COD,1,8) = '" + c01POS + c02POS + c03POS + c04POS + c05POS + c06POS + c07POS + c08POS + "'"
									cQry += " AND Substring(SG1.G1_COD,1,8) = '" + c01POS + c02POS + c03POS + c04POS + c05POS + c06POS + c07POS + c08POS + "'"
								Else
									If !Empty(c01POS+c02POS+c03POS+c04POS+c05POS+c06POS+c07POS+c08POS+c09POS) .and. Empty(c10POS+c11POS+c12POS+c13POS+c14POS+c15POS)
										cFil += " .and. Substring(G1_COD,1,9) = '" + c01POS + c02POS + c03POS + c04POS + c05POS + c06POS + c07POS + c08POS + c09POS + "'"
										cQry += " AND Substring(SG1.G1_COD,1,9) = '" + c01POS + c02POS + c03POS + c04POS + c05POS + c06POS + c07POS + c08POS + c09POS + "'"
									Else
										If !Empty(c01POS+c02POS+c03POS+c04POS+c05POS+c06POS+c07POS+c08POS+c09POS+c10POS) .and. Empty(c11POS+c12POS+c13POS+c14POS+c15POS)
											cFil += " .and. Substring(G1_COD,1,10) = '" + c01POS + c02POS + c03POS + c04POS + c05POS + c06POS + c07POS + c08POS + c09POS + c10POS + "'"
											cQry += " AND Substring(SG1.G1_COD,1,10) = '" + c01POS + c02POS + c03POS + c04POS + c05POS + c06POS + c07POS + c08POS + c09POS + c10POS + "'"
										Else
											If !Empty(c01POS+c02POS+c03POS+c04POS+c05POS+c06POS+c07POS+c08POS+c09POS+c10POS+c11POS) .and. Empty(c12POS+c13POS+c14POS+c15POS)
												cFil += " .and. Substring(G1_COD,1,11) = '" + c01POS + c02POS + c03POS + c04POS + c05POS + c06POS + c07POS + c08POS + c09POS + c10POS + c11POS + "'"
												cQry += " AND Substring(SG1.G1_COD,1,11) = '" + c01POS + c02POS + c03POS + c04POS + c05POS + c06POS + c07POS + c08POS + c09POS + c10POS + c11POS + "'"
											Else
												If !Empty(c01POS+c02POS+c03POS+c04POS+c05POS+c06POS+c07POS+c08POS+c09POS+c10POS+c11POS+c12POS) .and. Empty(c13POS+c14POS+c15POS)
													cFil += " .and. Substring(G1_COD,1,12) = '" + c01POS + c02POS + c03POS + c04POS + c05POS + c06POS + c07POS + c08POS + c09POS + c10POS + c11POS + c12POS + "'"
													cQry += " AND Substring(SG1.G1_COD,1,12) = '" + c01POS + c02POS + c03POS + c04POS + c05POS + c06POS + c07POS + c08POS + c09POS + c10POS + c11POS + c12POS + "'"
												Else
													If !Empty(c01POS+c02POS+c03POS+c04POS+c05POS+c06POS+c07POS+c08POS+c09POS+c10POS+c11POS+c12POS+c13POS) .and. Empty(c14POS+c15POS)
														cFil += " .and. Substring(G1_COD,1,13) = '" + c01POS + c02POS + c03POS + c04POS + c05POS + c06POS + c07POS + c08POS + c09POS + c10POS + c11POS + c12POS + c13POS + "'"
														cQry += " AND Substring(SG1.G1_COD,1,13) = '" + c01POS + c02POS + c03POS + c04POS + c05POS + c06POS + c07POS + c08POS + c09POS + c10POS + c11POS + c12POS + c13POS + "'"
													Else
														If !Empty(c01POS+c02POS+c03POS+c04POS+c05POS+c06POS+c07POS+c08POS+c09POS+c10POS+c11POS+c12POS+c13POS+c14POS) .and. Empty(c15POS)
															cFil += " .and. Substring(G1_COD,1,14) = '" + c01POS + c02POS + c03POS + c04POS + c05POS + c06POS + c07POS + c08POS + c09POS + c10POS + c11POS + c12POS + c13POS + c14POS + "'"
															cQry += " AND Substring(SG1.G1_COD,1,14) = '" + c01POS + c02POS + c03POS + c04POS + c05POS + c06POS + c07POS + c08POS + c09POS + c10POS + c11POS + c12POS + c13POS + c14POS + "'"
														Else
															If !Empty(c01POS) .and. !Empty(c02POS) .and. !Empty(c03POS) .and. !Empty(c04POS) .and. !Empty(c05POS) .and. !Empty(c06POS) .and. !Empty(c07POS) .and. !Empty(c08POS) .and. !Empty(c09POS) .and. !Empty(c10POS) .and. !Empty(c11POS) .and. !Empty(c12POS) .and. !Empty(c13POS) .and. !Empty(c14POS) .and. !Empty(c15POS)
																cFil += " .and. G1_COD = '" + c01POS + c02POS + c03POS + c04POS + c05POS + c06POS + c07POS + c08POS + c09POS + c10POS + c11POS + c12POS + c13POS + c14POS + c15POS + "'"
																cQry += " AND SG1.G1_COD = '" + c01POS + c02POS + c03POS + c04POS + c05POS + c06POS + c07POS + c08POS + c09POS + c10POS + c11POS + c12POS + c13POS + c14POS + c15POS + "'"
															Else
																If !Empty(c01POS)
																	cFil += " .and. Substring(G1_COD,1,1) = '" + c01POS + "'"
																	cQry += " AND Substring(SG1.G1_COD,1,1) = '" + c01POS + "'"
																EndIf

																If !Empty(c02POS)
																	cFil += " .and. Substring(G1_COD,2,1) = '" + c02POS + "'"
																	cQry += " AND Substring(SG1.G1_COD,2,1) = '" + c02POS + "'"
																EndIf

																If !Empty(c03POS)
																	cFil += " .and. Substring(G1_COD,3,1) = '" + c03POS + "'"
																	cQry += " AND Substring(SG1.G1_COD,3,1) = '" + c03POS + "'"
																EndIf

																If !Empty(c04POS)
																	cFil += " .and. Substring(G1_COD,4,1) = '" + c04POS + "'"
																	cQry += " AND Substring(SG1.G1_COD,4,1) = '" + c04POS + "'"
																EndIf

																If !Empty(c05POS)
																	cFil += " .and. Substring(G1_COD,5,1) = '" + c05POS + "'"
																	cQry += " AND Substring(SG1.G1_COD,5,1) = '" + c05POS + "'"
																EndIf

																If !Empty(c06POS)
																	cFil += " .and. Substring(G1_COD,6,1) = '" + c06POS + "'"
																	cQry += " AND Substring(SG1.G1_COD,6,1) = '" + c06POS + "'"
																EndIf

																If !Empty(c07POS)
																	cFil += " .and. Substring(G1_COD,7,1) = '" + c07POS + "'"
																	cQry += " AND Substring(SG1.G1_COD,7,1) = '" + c07POS + "'"
																EndIf

																If !Empty(c08POS)
																	cFil += " .and. Substring(G1_COD,8,1) = '" + c08POS + "'"
																	cQry += " AND Substring(SG1.G1_COD,8,1) = '" + c08POS + "'"
																EndIf

																If !Empty(c09POS)
																	cFil += " .and. Substring(G1_COD,9,1) = '" + c09POS + "'"
																	cQry += " AND Substring(SG1.G1_COD,9,1) = '" + c09POS + "'"
																EndIf

																If !Empty(c10POS)
																	cFil += " .and. Substring(G1_COD,10,1) = '" + c10POS + "'"
																	cQry += " AND Substring(SG1.G1_COD,10,1) = '" + c10POS + "'"
																EndIf

																If !Empty(c11POS)
																	cFil += " .and. Substring(G1_COD,11,1) = '" + c11POS + "'"
																	cQry += " AND Substring(SG1.G1_COD,11,1) = '" + c11POS + "'"
																EndIf

																If !Empty(c12POS)
																	cFil += " .and. Substring(G1_COD,12,1) = '" + c12POS + "'"
																	cQry += " AND Substring(SG1.G1_COD,12,1) = '" + c12POS + "'"
																EndIf

																If !Empty(c13POS)
																	cFil += " .and. Substring(G1_COD,13,1) = '" + c13POS + "'"
																	cQry += " AND Substring(SG1.G1_COD,13,1) = '" + c13POS + "'"
																EndIf

																If !Empty(c14POS)
																	cFil += " .and. Substring(G1_COD,14,1) = '" + c14POS + "'"
																	cQry += " AND Substring(SG1.G1_COD,14,1) = '" + c14POS + "'"
																EndIf

																If !Empty(c15POS)
																	cFil += " .and. Substring(G1_COD,15,1) = '" + c15POS + "'"
																	cQry += " AND Substring(SG1.G1_COD,15,1) = '" + c15POS + "'"
																EndIf
															EndIf
														EndIf
													EndIf
												EndIf
											EndIf
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf

	AADD(aRetorno,cFil)
	AADD(aRetorno,cQry)

Return aRetorno

