#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#INCLUDE 'DBTREE.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F3SZ4     ºAutor  ³Helio Ferreira      º Data ³  23/04/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*
DBADDTREE oTree PROMPT "Menu 001"          RESOURCE "BMPTABLE" CARGO "#0001"
DBADDITEM oTree PROMPT "Item 001"          RESOURCE "BMPSXG"   CARGO "#0002"
DBENDTREE oTree
DBADDITEM oTree PROMPT "Item 002"          RESOURCE "BMPTRG"   CARGO "#0003"
DBADDITEM oTree PROMPT "Item 003"          RESOURCE "BMPCONS"  CARGO "#0004"
DBADDITEM oTree PROMPT "Item 004"          RESOURCE "BMPPARAM" CARGO "#0005"

//DBADDTREE oTree PROMPT "Menu 002" OPENED RESOURCE "BMPTABLE" CARGO "#0006"
DBADDTREE oTree PROMPT "Menu 002"          RESOURCE "BMPTABLE" CARGO "#0006"
DBADDITEM oTree PROMPT "Item 005"          RESOURCE "BMPSXG"   CARGO "#0007"

//DBADDTREE oTree PROMPT "Menu 003" OPENED RESOURCE "BMPTABLE" CARGO "#0008"
DBADDTREE oTree PROMPT "Menu 003"          RESOURCE "BMPTABLE" CARGO "#0008"
DBADDITEM oTree PROMPT "Item 006"          RESOURCE "BMPSXG"   CARGO "#0009"

DBENDTREE oTree

DBADDTREE oTree PROMPT "Menu 004" OPENED   RESOURCE "BMPTABLE" CARGO "#0010"
DBADDITEM oTree PROMPT "Item 007"          RESOURCE "BMPSXG"   CARGO "#0011"

DBENDTREE oTree

DBADDITEM oTree PROMPT "Item 008"          RESOURCE "BMPSXG"   CARGO "#0012"
DBENDTREE oTree

DBENDTREE oTree

DBADDITEM oTree PROMPT "Item 009"         RESOURCE "BMPSXB"   CARGO "#0013"
*/


User Function F3SZ4New(cCliente,lFiltra,cPosi)

Local aAreaGER  := GetArea()
Local aAreaSZ2  := SZ2->( GetArea() )

Default lFiltra := .T.

//Private oCombo1
//Private cCombo1       := ""
//Private aCombo1       := {"1-Todos","2-Em aberto","3-Somente Consultor","4-Somente Consultor (em aberto)"}
Private cCodCli
Private aVetor        := {}
Private oTree
Private _Retorno      := ""
Private cCodigo
Private cCodConsultor := Space(6)
Private nMax_nX       := 0
Private cPesquisa     := Space(100)
Private cOpcCombo     := '1'

If Type("M->Z2_PROJETO") == "C"
	Default cPosi := M->Z2_PROJETO
Else
	Default cPosi := ""
EndIf

Private cPosiciona := cPosi

If Type("cCliPre") <> 'U'
	Default cCliente   := cCliPre
	cCodCli            := cCliPre                                                                                    
Else
	Default cCliente := M->Z1_CLIENTE
	cCodCli          := cCliente
EndIf

//U_AtuProj()

DEFINE DIALOG F3SZ4oDlg TITLE "Consulta Projetos" FROM 00,00 TO 500,950 COLOR CLR_BLACK,CLR_WHITE PIXEL

MontaOtree()

//U_VERSAOZ4()

@ 06,005	   SAY 'Pesquisa:'    SIZE 50,10 PIXEL
@ 03,005+27	msGet oPesquisa  VAR cPesquisa  Picture "@!"  SIZE 150,10 WHEN .T. VALID MontaOtree()  PIXEL

@ 06,193	   SAY 'Consultor:'    SIZE 50,10 PIXEL
@ 03,193+28	msGet oConsultor  VAR cCodConsultor  Picture "@R 999999"  SIZE 50,10 WHEN .T. F3 "SZ3SX1" VALID MontaOtree()  PIXEL

//@ 06,280	   SAY 'Mostrar Projetos:'    SIZE 50,10 PIXEL
//@ 03,280+45 COMBOBOX oCombo1  VAR cCombo1 ITEMS aCombo1    SIZE 90,13 VALID If(vCombo1(),If(MontaOtree(),.T.,.F.),.F.) PIXEL

cCSSBtN1 := "QPushButton{font: bold 10px Arial;background-repeat: none; }"+;
"QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #dadbde, stop: 1 #f6f7fa); }"


cCSSBtDOWN := "QPushButton{font: bold 12px Arial;background-image: url(rpo:PMSSETADOWN.png);background-repeat: none;}"
cCSSBtDOWN += "QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #dadbde, stop: 1 #f6f7fa); }"

cCSSBtUP := "QPushButton{font: bold 12px Arial;background-image: url(rpo:PMSSETAUP.png);background-repeat: none;}"
cCSSBtUP += "QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #dadbde, stop: 1 #f6f7fa); }"

nCol := 100

If Type("cConsultor") <> "U"
	If cConsultor == "000002" // Hélio
		@ 225,nCol BUTTON oBtn01 PROMPT "Incluir"  Size 40,14 OF F3SZ4oDlg PIXEL ACTION fInclui(cCliente)
		oBtn01:setCSS(cCSSBtN1)
	EndIf
Else
	If Type("cUsuario") <> "U"
		If Subs(cUsuario,7,5) == "HELIO"
			@ 225,nCol BUTTON oBtn01 PROMPT "Incluir"  Size 40,14 OF F3SZ4oDlg PIXEL ACTION fInclui(cCliente)
			oBtn01:setCSS(cCSSBtN1)
		EndIf
	EndIf
EndIf

nCol := 10
@ 225,nCol BUTTON oBtn01 PROMPT "Ok"       Size 50,16 OF F3SZ4oDlg PIXEL ACTION fOK()
oBtn01:setCSS(cCSSBtN1)

//nCol += 55
//@ 225,nCol BUTTON oBtn02 PROMPT "Sobe"     Size 50,16 OF F3SZ4oDlg PIXEL ACTION fSobeNiv()
//oBtn02:setCSS(cCSSBtUP)

//nCol += 55
//@ 225,nCol BUTTON oBtn03 PROMPT "Desce"    Size 50,16 OF F3SZ4oDlg PIXEL ACTION fDesceNiv()
//oBtn03:setCSS(cCSSBtDOWN)

//nCol += 55
//@ 225,nCol BUTTON oBtn04 PROMPT "Encerra"  Size 50,16 OF F3SZ4oDlg PIXEL ACTION fEncerra()
//oBtn04:setCSS(cCSSBtN1)

//nCol += 55
//@ 225,nCol BUTTON oBtn05 PROMPT "Detalhes" Size 50,16 OF F3SZ4oDlg PIXEL ACTION Detalhes()
//oBtn05:setCSS(cCSSBtN1)

nCol += 55
@ 225,nCol BUTTON oBtn06 PROMPT "Cancelar" Size 50,16 OF F3SZ4oDlg PIXEL ACTION F3SZ4oDlg:End()
oBtn06:setCSS(cCSSBtN1)

//nCol += 55
//@ 225,nCol BUTTON oBtn05 PROMPT "Anexos" Size 50,16 OF F3SZ4oDlg PIXEL ACTION {|| dbSelectArea(oTree:cArqTree),nRecno := Recno(),U_SZ4ANEXOS(aVetor[nRecno,2])  }
//oBtn05:setCSS(cCSSBtN1)

ACTIVATE DIALOG F3SZ4oDlg CENTER

RestArea(aAreaSZ2)
RestArea(aAreaGER)

Return _Retorno

//User Function Teste2()

//Return (M->Z2_PROJETO)


Static Function fOK()

dbSelectArea(oTree:cArqTree)
nRecno := Recno()

/*
If nRecno <> 0
	SZ4->( dbGoTo(aVetor[nRecno,2]))
	If SZ4->Z4_NIVEL == '3'
		If Empty(SZ4->Z4_DTFIM)
			//_Retorno := SZ4->Z4_CODIGO
			
			cCodigo  := SZ4->Z4_CODIGO
			cDesc    := SZ4->Z4_DESC
			nHrPrev  := SZ4->Z4_PREVISA
			
			F3SZ4oDlg:End()
			
			//M->Z2_PROJETO := _Retorno
			
			If Type("oGetSZ2") == "O"
				oGetSZ2:aCols[oGetSZ2:oBrowse:nat,aScan(oGetSZ2:aHeader,{|aVet| Alltrim(aVet[2]) == "Z2_PROJETO"})] := SZ4->Z4_CODIGO
				M->Z2_PROJETO := SZ4->Z4_CODIGO
				
				If aScan(oGetSZ2:aHeader,{|aVet| Alltrim(aVet[2]) == "Z2_DESCPRJ"}) <> 0
					oGetSZ2:aCols[oGetSZ2:oBrowse:nat,aScan(oGetSZ2:aHeader,{|aVet| Alltrim(aVet[2]) == "Z2_DESCPRJ"})] := SZ4->Z4_DESC
					M->Z2_DESCPRJ := SZ4->Z4_DESC
				EndIf
				//ExistTrigger("Z2_PROJETO")
				//RunTrigger(2,oGetSZ2:oBrowse:nat,Nil,,"Z2_PROJETO")
			EndIf
			
		Else
			MsgYesNo("Projeto já concluído. Favor entrar em contato com o Coordenador.")
		EndIf
	Else
		MsgYesNo("Este projeto não é analítico, de nível 3.")
	EndIf
EndIf
*/

If nRecno <> 0
	SZ4->( dbGoTo(aVetor[nRecno,2]))
	If SZ4->Z4_NIVEL == '2'
		_Retorno := SZ4->Z4_CODIGO
		
		cCodigo := SZ4->Z4_CODIGO
		cDesc   := SZ4->Z4_DESC
		nHrPrev := SZ4->Z4_PREVISA
		
		F3SZ4oDlg:End()
	Else
	   MsgYesNo("Para seleção, o projeto dever ser do nível 2.")
	EndIf
EndIf

Return

/*
dbSelectArea(oTree:cArqTree)
aAreaTRE := GetArea()
cPai     := T_IDTREE


dbSelectArea(oTree:cArqTree)
RecLock((oTree:cArqTree), .F.)
Replace T_CARGO With (SG1->G1_COD+SG1->G1_TRT+SG1->G1_COMP+StrZero(SG1->(Recno()),9)+StrZero(nIndex ++, 9)+'COMP')
MsUnlock()
*/





Static Function vCombo1()

aAreaSA1 := SA1->( GetArea() )

SA1->( dbSetOrder(1) )

If SA1->( dbSeek( xFilial() + cCodCli ) )
	Reclock("SA1",.F.)
	SA1->A1_XCONCLU := Subs(cCombo1,1,1)
	SA1->( msUnlock() )
Else
	
EndIf

RestArea(aAreaSA1)

Return .T.




Static Function MontaOtree()
//MsgRun("Filtrando projetos/chamados...","Aguarde...",{|| ProcRun() } )

lEnd := .F.

//Processa({|lEnd| ProcRun() },OemToAnsi("teste"),OemToAnsi("teste2"),.F.)
//RptStatus({|| ProcRun() },'Titulo')
oProcess := MsNewProcess():New({|lEnd| ProcRun() },"Filtrando projetos/chamados...","Aguarde... Processando Query...",.f.)
oProcess:Activate()

Return .T.

Static Function ProcRun()

Local lAdiciona
aVetor := {}

/*
SA1->( dbSetOrder(1) )
If SA1->( dbSeek( xFilial() + cCodCli ) )
	// 1=Todos , 2=Todos em aberto, 3=Todos do Consultor, 4=Aberto do Consultor
	cOpcCombo := SA1->A1_XCONCLU
	If cOpcCombo == '1' .or. cOpcCombo == '2' .or. cOpcCombo == '3' .or. cOpcCombo == '4'
		cCombo1   := aCombo1[Val(cOpcCombo)]
	EndIf
Else
	MsgYesNo("Projeto não encontrado para este cliente.")
	Return
EndIf
*/

cCombo1   := '1' // aCombo1[Val(cOpcCombo)]

/*
SZ3->( dbSetOrder(3) ) // Id
If Empty(cCodConsultor)
	If SZ3->( dbSeek( xFilial() + __cUserID ) )
		cCodConsultor := SZ3->Z3_CODIGO
	EndIf
EndIf
*/

cCodConsultor := Space(6)

/*
cQuery := "SELECT * FROM SZ4010 (NOLOCK) WHERE Z4_CLIENTE = '"+cCodCli+"' AND Z4_NIVEL = '1' AND D_E_L_E_T_ = '' ORDER BY Z4_DTAUTOR "

If Select("QUERYSZ4_1") <> 0
QUERYSZ4_1->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QUERYSZ4_1"

If QUERYSZ4_1->( EOF() )
MsgYesNo("Projeto não encontrado para este cliente.")
Return
EndIf

While !QUERYSZ4_1->( EOF() )

nRecN1 := QUERYSZ4_1->R_E_C_N_O_

cQuery := "SELECT * FROM SZ4010 (NOLOCK) WHERE Z4_NIVEL = '2' AND Z4_SUPERIO = '"+QUERYSZ4_1->Z4_CODIGO+"' AND D_E_L_E_T_ = '' ORDER BY Z4_LINHA "

If Select("QUERYSZ4_2") <> 0
QUERYSZ4_2->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QUERYSZ4_2"

While !QUERYSZ4_2->( EOF() )
//AADD(aVetor,{Val(QUERYSZ4_2->Z4_NIVEL),QUERYSZ4_2->R_E_C_N_O_})
nRecN2 := QUERYSZ4_2->R_E_C_N_O_
*/
// 1=Todos , 2=Todos em aberto, 3=Todos do Consultor, 4=Aberto do Consultor
If cOpcCombo == '1'
	cQuery := " SELECT Z4_CODIGO, Z4_SUPERIO, Z4_SUPN1, ISNULL((SELECT R_E_C_N_O_ FROM SZ4010 (NOLOCK) WHERE Z4_CODIGO = SZ4.Z4_SUPN1 AND D_E_L_E_T_ = ''),0) AS RECNO_N1 , "
	cQuery += " ISNULL((SELECT R_E_C_N_O_ FROM SZ4010 (NOLOCK) WHERE Z4_CODIGO = SZ4.Z4_SUPERIO AND D_E_L_E_T_ = ''),0) AS RECNO_N2 ,
	cQuery += " R_E_C_N_O_ AS RECNO_N3 "
	cQuery += " FROM SZ4010 SZ4 WHERE Z4_CLIENTE = '"+cCodCli+"' "
	cQuery += " AND Z4_NIVEL = '3' "
	cQuery += " AND SZ4.D_E_L_E_T_ = '' "
	cQuery += " AND (SZ4.Z4_SUPN1 IN ('000052','004620','006831','006834','007296') OR  SZ4.Z4_SUPN1 IN (SELECT Z4_CODIGO FROM SZ4010 WHERE Z4_CLIENTE = '000012' AND Z4_DESC LIKE '2021%' AND Z4_NIVEL = '1' AND D_E_L_E_T_ = '' ))"
	If !Empty(cPesquisa)
		cQuery += " AND Z4_DESC LIKE '%"+Alltrim(cPesquisa)+"%' "
	EndIf
	If Date() == StoD('20211028')
		//cQuery += " AND Z4_SUPERIO = '008161' "
		//cQuery += " AND Z4_SUPN1 = '006625' "
		cQuery += " AND SZ4.Z4_SUPN1 IN ('006625','000052','004620','006831','006834') "  //'007296'
	EndIf
	cQuery += "ORDER BY Z4_LINHA "
EndIf

If cOpcCombo == '2'
	cQuery := " SELECT Z4_CODIGO, ISNULL((SELECT R_E_C_N_O_ FROM SZ4010 (NOLOCK) WHERE Z4_CODIGO = SZ4.Z4_SUPN1 AND D_E_L_E_T_ = ''),0) AS RECNO_N1 , "
	cQuery += " ISNULL((SELECT R_E_C_N_O_ FROM SZ4010 (NOLOCK) WHERE Z4_CODIGO = SZ4.Z4_SUPERIO AND D_E_L_E_T_ = ''),0) AS RECNO_N2 , "
	cQuery += " R_E_C_N_O_ AS RECNO_N3 "
	cQuery += " FROM SZ4010 SZ4 WHERE "
	cQuery += " Z4_CLIENTE = '"+cCodCli+"' AND Z4_NIVEL = '3' AND (Z4_DTFIM = '' OR Z4_CODIGO = '"+cPosiciona+"') AND D_E_L_E_T_ = '' "
	If !Empty(cPesquisa)
		cQuery += " AND Z4_DESC LIKE '%"+Alltrim(cPesquisa)+"%' "
	EndIf
	cQuery += "ORDER BY Z4_SUPN1, Z4_LINHA "
EndIf

If cOpcCombo == '3'
	cQuery := " SELECT Z4_CODIGO, ISNULL((SELECT R_E_C_N_O_ FROM SZ4010 (NOLOCK) WHERE Z4_CODIGO = SZ4.Z4_SUPN1 AND D_E_L_E_T_ = ''),0) AS RECNO_N1 , "
	cQuery += " ISNULL((SELECT R_E_C_N_O_ FROM SZ4010 (NOLOCK) WHERE Z4_CODIGO = SZ4.Z4_SUPERIO AND D_E_L_E_T_ = ''),0) AS RECNO_N2 ,
	cQuery += " R_E_C_N_O_ AS RECNO_N3 "
	cQuery += " FROM SZ4010 SZ4 WHERE Z4_CLIENTE = '"+cCodCli+"' AND Z4_NIVEL = '3' AND D_E_L_E_T_ = '' "
	cQuery += "AND ( ((Z4_CONCLI = '"+cCodConsultor+"' AND Z4_CONCON = '') OR (Z4_CONCON = '"+cCodConsultor+"')) OR (Z4_CODIGO = '"+cPosiciona+"' ) ) "
	If !Empty(cPesquisa)
		cQuery += " AND Z4_DESC LIKE '%"+Alltrim(cPesquisa)+"%' "
	EndIf
	cQuery += "ORDER BY Z4_SUPN1, Z4_LINHA "
EndIf

If cOpcCombo == '4'
	cQuery := " SELECT Z4_CODIGO, ISNULL((SELECT R_E_C_N_O_ FROM SZ4010 (NOLOCK) WHERE Z4_CODIGO = SZ4.Z4_SUPN1 AND D_E_L_E_T_ = ''),0) AS RECNO_N1 , "
	cQuery += " ISNULL((SELECT R_E_C_N_O_ FROM SZ4010 (NOLOCK) WHERE Z4_CODIGO = SZ4.Z4_SUPERIO AND D_E_L_E_T_ = ''),0) AS RECNO_N2 ,
	cQuery += " R_E_C_N_O_ AS RECNO_N3 "
	cQuery += " FROM SZ4010 SZ4 WHERE Z4_CLIENTE = '"+cCodCli+"' AND Z4_NIVEL = '3' AND (Z4_DTFIM = '' OR Z4_CODIGO = '"+cPosiciona+"') AND D_E_L_E_T_ = '' "
	cQuery += "AND ( ((Z4_CONCLI = '"+cCodConsultor+"' AND Z4_CONCON = '') OR (Z4_CONCON = '"+cCodConsultor+"')) OR (Z4_CODIGO = '"+cPosiciona+"') ) "
	If !Empty(cPesquisa)
		cQuery += " AND Z4_DESC LIKE '%"+Alltrim(cPesquisa)+"%' "
	EndIf
	cQuery += "ORDER BY Z4_SUPN1, Z4_LINHA "
EndIf

If Select("QUERYSZ4_3") <> 0
	QUERYSZ4_3->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QUERYSZ4_3"


While !QUERYSZ4_3->( EOF() )
	
	If  QUERYSZ4_3->Z4_SUPERIO == '008161'
		n := 0
	EndIf
	If QUERYSZ4_3->Z4_SUPN1 == '006625'
        n := 0
	EndIf
	lAdiciona := .F.	
	
	n := aScan(aVetor,{ |aVet| aVet[2] == QUERYSZ4_3->RECNO_N1 } )
	
	If Empty(n)
		AADD(aVetor,{1,QUERYSZ4_3->RECNO_N1})
		lAdiciona := .T.
	EndIf
	
	n := aScan(aVetor,{ |aVet| aVet[2] == QUERYSZ4_3->RECNO_N2 } )
	If Empty(n)
		AADD(aVetor,{2,QUERYSZ4_3->RECNO_N2})
		lAdiciona := .T.
	EndIf
	
	If lAdiciona
		AADD(aVetor,{3,QUERYSZ4_3->RECNO_N3})
	EndIf
	
	QUERYSZ4_3->( dbSkip() )
End
/*
QUERYSZ4_2->( dbSkip() )
End

QUERYSZ4_1->( dbSkip() )
End
*/

// Selecionando os projetos com algum problema cadastral
// 1=Todos , 2=Todos em aberto, 3=Todos do Consultor, 4=Aberto do Consultor
If cOpcCombo == '1' .or. cOpcCombo == '3'
	cQuery := "SELECT * FROM SZ4010 (NOLOCK) WHERE (Z4_NIVEL = '' OR (Z4_SUPERIO = '' AND  Z4_NIVEL <> '1') ) AND Z4_CLIENTE = '"+cCodCli+"' AND D_E_L_E_T_ = '' ORDER BY Z4_DTAUTOR "
Else
	cQuery := "SELECT * FROM SZ4010 (NOLOCK) WHERE (Z4_NIVEL = '' OR (Z4_SUPERIO = '' AND  Z4_NIVEL <> '1') ) AND Z4_CLIENTE = '"+cCodCli+"' AND Z4_DTFIM = '' AND D_E_L_E_T_ = '' ORDER BY Z4_DTAUTOR "
EndIf

If Select("QUERYSZ4_4") <> 0
	QUERYSZ4_4->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QUERYSZ4_4"

While !QUERYSZ4_4->( EOF() )
	AADD(aVetor,{0,QUERYSZ4_4->R_E_C_N_O_})
	QUERYSZ4_4->( dbSkip() )
End

If Type("oTree") == "O"
	//oTree:EndTree()
	//oTree:BeginUpdate()
	oTree:Reset()
	If !Empty(oTree:cArqTree)
	   dbSelectArea(oTree:cArqTree)
	   PACK
	EndIf
	//oTree:Refresh()
	//oTree:EndUpdate()
	
	//For x := nMax_nX to 1 Step(-1)
	//	If oTree:TreeSeek(StrZero(x,4))
	//		oTree:DelItem()
	//	EndIF
	//Next x
	
Else
	//DEFINE DBTREE oTree FROM 00,00 TO 220,440 OF F3SZ4oDlg
	
	oTree := DbTree():New(18,3,220,470,F3SZ4oDlg,,,.T.)
	
	oTree:oFont := TFont():New('Courier',,14,,.T.,,,,.T.,.F.)
	
	//oTree:BLDBLCLICK := {|| Detalhes() }
EndIf
/*
oTree:AddItem("Primeiro nível da DBTree","001", "FOLDER5" ,,,,1)

If oTree:TreeSeek("001")
oTree:AddItem("Segundo nível da DBTree","002", "FOLDER10",,,,2)

If oTree:TreeSeek("002")
oTree:AddItem("Subnível 01","003", "FOLDER6",,,,2)
oTree:AddItem("Subnível 02","004", "FOLDER6",,,,2)
oTree:AddItem("Subnível 03","005", "FOLDER6",,,,2)
endif
endif

oTree:TreeSeek("001")

oTree:AddTreeItem("Novo Item","FOLDER7",,"006")

if oTree:TreeSeek("006")
oTree:AddItem("Sub-nivel 01","007", "FOLDER6",,,,2)
oTree:AddItem("Sub-nivel 02","008", "FOLDER6",,,,2)
endif

*/
nSintetic := 0
nNivel    := 0

lNovo := .t.

cChavePosiciona := ""

//SetRegua(Len(aVetor))
oProcess:SetRegua1(Len(aVetor))

For _nX := 1 to Len(aVetor)
	
	//IncRegua()
   If cOpcCombo == '1'
      oProcess:IncRegua1("Montando objeto...")
   Else
      oProcess:IncRegua1("Aguarde...")
   EndIf

	SZ4->( dbGoTo(aVetor[_nX,2]) )
	
	If cPosiciona == SZ4->Z4_CODIGO
		cChavePosiciona := StrZero(_nX,4)
	EndIf
	
	If aVetor[_nX,1] == 1
		nNivTipo1 := 1
		nNivTipo2 := 0
		nNivTipo3 := 0
		cCodNiv1  := SZ4->Z4_CODIGO
		
		If _nX <> 1
			For nSintetic := nSintetic to 1 Step (-1)
				//DBENDTREE oTree
				oTree:EndTree()
			Next
		EndIf
		
		If Subs(cCombo1,1,1) == "1"
			//fZ4_LINHA1()
		EndIf
		
		// Nivel 1
		cTxt := SZ4->Z4_LINHA + Space(5) + " : " + Subs(SZ4->Z4_DESC,1,83) //+ RetHrPrj1(SZ4->Z4_CODIGO) // 1,11
		//cTxt := "Nivel " + Str(aVetor[_nX,1]) + " Indice " + StrZero(_nX,4)
		
		If !lNovo
			DBADDTREE oTree PROMPT cTxt  RESOURCE "PROJETPMS" CARGO "#"+StrZero(_nX,4)
		Else
			oTree:AddTree(cTxt ,StrZero(_nX,4), "PROJETPMS" ,,,,StrZero(_nX,4))
			nMax_nX := _nX
			n := 1
		EndIf
		
		nSintetic++
		nNivel   := aVetor[_nX,1]
	Else
		For nNivel := nNivel to (aVetor[_nX,1] + 1) Step (-1)
			oTree:EndTree()
			nSintetic--
		Next
		
		If aVetor[_nX,1] == 2
			nNivTipo2++
			nNivTipo3:= 0
			
			If Subs(cCombo1,1,1) == "1"
				//fZ4_LINHA2()
			EndIf
			
			// Nivel 2
			cTxt := SZ4->Z4_LINHA + Space(2) + " : " + Alltrim(Subs(SZ4->Z4_DESC,1,83)) //+ RetHrPrj2(SZ4->Z4_CODIGO)    //1,8
			//cTxt := "Nivel " + Str(aVetor[_nX,1]) + " Indice " + StrZero(_nX,4)
			
			If !lNovo
				DBADDTREE oTree PROMPT cTxt RESOURCE "SDURECALL" CARGO "#"+StrZero(_nX,4)
			Else
				oTree:AddTree(cTxt ,StrZero(_nX,4), "SDURECALL" ,,,,StrZero(_nX,4))
				nMax_nX := _nX
			EndIf
			
			nSintetic++
			nNivel   := aVetor[_nX,1]
		Else
			If aVetor[_nX,1] == 3
				nNivTipo3++
				
				If Subs(cCombo1,1,1) == "1"
					//fZ4_LINHA3()
				EndIf
				
				// Nivel 3
				cImagem := If(Empty(SZ4->Z4_DTFIM),"PMSTASK4","PMSTASK1")
				
				cTxt := SZ4->Z4_LINHA + " : " + Subs(SZ4->Z4_DESC,1,83) //+ RetHrPrj3(SZ4->Z4_CODIGO) // 1,7
				//cTxt := "Nivel " + Str(aVetor[_nX,1]) + " Indice " + StrZero(_nX,4)
				
				If !lNovo
					DBADDITEM oTree PROMPT cTxt  CARGO "#"+StrZero(_nX,4) RESOURCE cImagem
				Else
					oTree:AddTreeItem(cTxt ,cImagem,,StrZero(_nX,4))
					nMax_nX := _nX
				EndIf
				
				nNivel   := aVetor[_nX,1]
			EndIf
		EndIf
	EndIf
	
	
	If aVetor[_nX,1] == 0
		
		For nNivel := nNivel to (aVetor[_nX,1] + 1) Step (-1)
			oTree:EndTree()
			nSintetic--
		Next
		
		//DBADDITEM oTree PROMPT "Tipo: " + SZ4->Z4_NIVEL + " - Superior: " + SZ4->Z4_SUPERIO+"  "+" - " + Subs(SZ4->Z4_DESC,1,70) + RetHrPrj3(SZ4->Z4_CODIGO)  RESOURCE "AMARELO"   CARGO "#"+StrZero(_nX,4)
		DBADDITEM oTree PROMPT "Tipo: " + SZ4->Z4_NIVEL + " - Superior: " + SZ4->Z4_SUPERIO+"  "+" - " + Subs(SZ4->Z4_DESC,1,70) RESOURCE "AMARELO"   CARGO "#"+StrZero(_nX,4)
		
	EndIf
Next _nX

//DBENDTREE oTree

If _nX <> 1
	For nSintetic := nSintetic to 1 Step (-1)
		oTree:EndTree()
	Next
EndIf

//oTree:Refresh()

oTree:SetFocus()

If !Empty(cChavePosiciona)
	oTree:TreeSeek(cChavePosiciona)
EndIf

Return .T.

Static Function fZ4_LINHA1()

//If Alltrim(SZ4->Z4_LINHA) <> Alltrim(Str(nNivTipo1)) .and. (SZ4->Z4_CLIENTE <> '000031' .or. Empty(SZ4->Z4_LINHA))
//	Reclock("SZ4",.F.)
//	SZ4->Z4_LINHA := Alltrim(Str(nNivTipo1))
//	SZ4->( MsUnlock() )
//EndIf

If Alltrim(cCodNiv1) <> Alltrim(SZ4->Z4_SUPN1)
	Reclock("SZ4",.F.)
	SZ4->Z4_SUPN1 := cCodNiv1
	SZ4->( msUnlock() )
EndIf

Return


Static Function fZ4_LINHA2()

//If Alltrim(SZ4->Z4_LINHA) <> Alltrim(Str(nNivTipo1))+'.'+Alltrim(StrZero(nNivTipo2,2)) .and. (SZ4->Z4_CLIENTE <> '000031' .or. Empty(SZ4->Z4_LINHA))
//	Reclock("SZ4",.F.)
//	SZ4->Z4_LINHA := Alltrim(Str(nNivTipo1))+'.'+Alltrim(StrZero(nNivTipo2,2))
//	SZ4->( MsUnlock() )
//EndIf
If Alltrim(cCodNiv1) <> Alltrim(SZ4->Z4_SUPN1)
	Reclock("SZ4",.F.)
	SZ4->Z4_SUPN1 := cCodNiv1
	SZ4->( msUnlock() )
EndIf

Return

Static Function fZ4_LINHA3()

//If Alltrim(SZ4->Z4_LINHA) <> Alltrim(Str(nNivTipo1))+'.'+Alltrim(StrZero(nNivTipo2,2))+'.'+Alltrim(StrZero(nNivTipo3,2)) .and. (SZ4->Z4_CLIENTE <> '000031' .or. Empty(SZ4->Z4_LINHA))
//	Reclock("SZ4",.F.)
//	SZ4->Z4_LINHA := Alltrim(Str(nNivTipo1))+'.'+Alltrim(StrZero(nNivTipo2,2))+'.'+Alltrim(StrZero(nNivTipo3,2))
//	SZ4->( MsUnlock() )
//EndIf
If Alltrim(cCodNiv1) <> Alltrim(SZ4->Z4_SUPN1)
	Reclock("SZ4",.F.)
	SZ4->Z4_SUPN1 := cCodNiv1
	SZ4->( msUnlock() )
EndIf

Return

Static Function fEncerra()

// MsgYesNo("Cargo: "+oTree:GetCargo()+chr(13)+"Texto: "+oTree:GetPrompt(.T.))

dbSelectArea(oTree:cArqTree)
nRecno := Recno()

If nRecno <> 0
	SZ4->( dbGoTo(aVetor[nRecno,2]))
Else
	MsgYesNo("Erro no posicionamento do projeto")
EndIf

lAtuN3 := .F.
If SZ4->Z4_NIVEL <> '3'
	If SZ4->Z4_DTFIM <> Date()
		If MsgYesNo("Deseja atualizar a data de conclusão dos projetos analíticos abaixo deste?")
			lAtuN3 := .T.
		EndIf
	EndIf
Else
	oTree:ChangeBmp("PMSTASK1","PMSTASK1",,,oTree:GetCargo() )
EndIf

Reclock("SZ4",.F.)
SZ4->Z4_DTFIM   := Date()
SZ4->( msUnlock() )

If lAtuN3
	If SZ4->Z4_NIVEL == '1'
		cNIVEL1 := SZ4->Z4_CODIGO
		SZ4->( dbSetOrder(4) ) // Z4_FILIAL + Z4_SUPN1
		If SZ4->( dbSeek( xFilial() + cNIVEL1 ) )
			While !SZ4->( EOF() ) .and. SZ4->Z4_SUPN1 == cNIVEL1
				If Empty(SZ4->Z4_DTFIM)
					Reclock("SZ4",.F.)
					SZ4->Z4_DTFIM   := Date()
					SZ4->( msUnlock() )
					If SZ4->Z4_NIVEL == "3"
						For x := 1 to Len(aVetor)
							If aVetor[x,2] == SZ4->( Recno() )
								oTree:ChangeBmp("PMSTASK1","PMSTASK1",,,StrZero(x,4) )
							EndIf
						Next x
					EndIf
				EndIf
				SZ4->( dbSkip() )
			End
		EndIf
	EndIf
	If SZ4->Z4_NIVEL == '2'
		cNIVEL2 := SZ4->Z4_CODIGO
		SZ4->( dbSetOrder(6) ) // Z4_FILIAL + Z4_SUPERIO
		If SZ4->( dbSeek( xFilial() + cNIVEL2 ) )
			While !SZ4->( EOF() ) .and. SZ4->Z4_SUPERIO == cNIVEL2
				If Empty(SZ4->Z4_DTFIM)
					Reclock("SZ4",.F.)
					SZ4->Z4_DTFIM   := Date()
					SZ4->( msUnlock() )
					If SZ4->Z4_NIVEL == "3"
						For x := 1 to Len(aVetor)
							If aVetor[x,2] == SZ4->( Recno() )
								oTree:ChangeBmp("PMSTASK1","PMSTASK1",,,StrZero(x,4) )
							EndIf
						Next x
					EndIf
				EndIf
				SZ4->( dbSkip() )
			End
		EndIf
	EndIf
EndIf

Return

Static Function fInclui(cCliente)

Local cDescSupN1 := Space(Len(SZ4->Z4_DESC))

Private cSupN1     := Space(Len(SZ4->Z4_CODIGO))
Private cSupN2     := Space(Len(SZ4->Z4_CODIGO))

cCodigo    := U_IZ4_CODIGO()
cDesc      := CriaVar("Z4_DESC"    )
nHrPrev    := CriaVar("Z4_PREVISA" )
cNivel     := "1"
dEmissao   := dDataBase
dDtConcl   := CriaVar("Z4_DTFIM"   )
cLinha     := "ZZZZZZZZZZ"
cConsultor := CriaVar("Z4_CONCON"  )
cSupN1     := Space(6)
cSuperior  := Space(6)

DEFINE DIALOG F3SZ4oDlg2 TITLE "Inclusão de Projeto - Ciente: " + cCliente + " " + Posicione("SA1",1,xFilial("SA1") + cCliente + "01","A1_NREDUZ") FROM 0,0 TO 400,700 COLOR CLR_BLACK,CLR_WHITE PIXEL

nLin := 10
nCol := 08
@ nLin, nCol	SAY oTexto1   VAR OemToAnsi('Codigo:')  PIXEL SIZE 180,15
oTexto1:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
@ nLin+10, nCol MSGET oCodigo VAR cCodigo  Picture "@!"  When .T. SIZE 75,12 Valid .T. PIXEL
oCodigo:oFont := TFont():New('Courier New',,15,,.T.,,,,.T.,.F.)


@ nLin, nCol+80	SAY oTexto2   VAR OemToAnsi('Tipo (Nível):')  PIXEL SIZE 180,15
oTexto2:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
@ nLin+10, nCol+80 MSGET oNivel VAR cNivel  Picture "@!"  When .T. VALID cNivel $ '123' SIZE 20,12 Valid .T. PIXEL
oNivel:oFont := TFont():New('Courier New',,15,,.T.,,,,.T.,.F.)

@ nLin, nCol+160	SAY oTexto3   VAR OemToAnsi('Emissão:')  PIXEL SIZE 180,15
oTexto3:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
@ nLin+10, nCol+160 MSGET oEmissao VAR dEmissao  Picture "@D"  When .T. SIZE 70,12 Valid .T. PIXEL
oEmissao:oFont := TFont():New('Courier New',,15,,.T.,,,,.T.,.F.)

nLin += 30
@ nLin, nCol	SAY oTexto3   VAR OemToAnsi('Horas Previstas:')  PIXEL SIZE 180,15
oTexto3:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
@ nLin+10, nCol MSGET oHrPrev VAR nHrPrev  Picture "@E 9,999.9"  SIZE 60,12 Valid .T. PIXEL
oHrPrev:oFont := TFont():New('Courier New',,15,,.T.,,,,.T.,.F.)

@ nLin, nCol+80 SAY oTexto4   VAR OemToAnsi('Data Conclusão:')  PIXEL SIZE 180,15
oTexto4:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
@ nLin+10, nCol+80 MSGET oDtConcl VAR dDtConcl  Picture "@D"       SIZE 60,12 Valid .T. PIXEL
oDtConcl:oFont := TFont():New('Courier New',,15,,.T.,,,,.T.,.F.)

@ nLin, nCol+160 SAY oTexto4   VAR OemToAnsi('Linha:')  PIXEL SIZE 180,15
oTexto4:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
@ nLin+10, nCol+160 MSGET oLinha VAR cLinha  Picture "@D"       SIZE 60,12 Valid .T. PIXEL
oLinha:oFont := TFont():New('Courier New',,15,,.T.,,,,.T.,.F.)

nLin += 30
@ nLin, nCol	SAY oTexto5   VAR OemToAnsi('Descrição:')  PIXEL SIZE 180,15
oTexto5:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
@ nLin+10, nCol MSGET oDesc VAR cDesc  Picture "@!"  SIZE 155,12 Valid .T. PIXEL
oCodigo:oFont := TFont():New('Courier New',,15,,.T.,,,,.T.,.F.)

@ nLin, nCol+160 SAY oTexto4   VAR OemToAnsi('Consultor:')  PIXEL SIZE 180,15
oTexto4:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
@ nLin+10, nCol+160 MSGET oConsultor VAR cConsultor  Picture "@R 999999"  F3 "SZ3" SIZE 60,12 Valid .T. PIXEL
oLinha:oFont := TFont():New('Courier New',,15,,.T.,,,,.T.,.F.)

nLin += 30
@ nLin, nCol	SAY oTexto5   VAR OemToAnsi('Superior N1:')  PIXEL SIZE 180,15
oTexto5:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
@ nLin+10,nCol MSGET oSupN1 VAR cSupN1  Picture "@!" SIZE 60,12 Valid .T. PIXEL // F3 "SZ4SUP"
oCodigo:oFont := TFont():New('Courier New',,15,,.T.,,,,.T.,.F.)

@ nLin, nCol+80	SAY oTexto5   VAR OemToAnsi('Descrição N1:')  PIXEL SIZE 180,15
oTexto5:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
@ nLin+10, nCol+80 MSGET oSupN1 VAR cDescSupN1  Picture "@!"  SIZE 155,12 Valid .T. PIXEL
oCodigo:oFont := TFont():New('Courier New',,15,,.T.,,,,.T.,.F.)

nLin += 30

@ nLin, nCol	SAY oTexto5   VAR OemToAnsi('Superior N2:')  PIXEL SIZE 180,15
oTexto5:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
@ nLin+10, nCol MSGET oSupN1 VAR cSupN2  Picture "@!"  SIZE 60,12 Valid .T. PIXEL  // F3 "SZ4SZ4"
oCodigo:oFont := TFont():New('Courier New',,15,,.T.,,,,.T.,.F.)

@ nLin, nCol+80 SAY oTexto4   VAR OemToAnsi('Descrição N2:')  PIXEL SIZE 180,15
oTexto4:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
@ nLin+10, nCol+80 MSGET oSuperior VAR cDescSupN1  Picture "@!"  SIZE 155,12 Valid .T. PIXEL
oLinha:oFont := TFont():New('Courier New',,15,,.T.,,,,.T.,.F.)

nLin+= 40

@ nLin,130 BUTTON oBtn01 PROMPT "Cancelar"     Size 45,14 OF F3SZ4oDlg2 PIXEL ACTION {||nOpc:=0,F3SZ4oDlg2:End()}
@ nLin,200 BUTTON oBtn02 PROMPT "Salvar"       Size 45,14 OF F3SZ4oDlg2 PIXEL ACTION {||nOpc:=1,F3SZ4oDlg2:End()}

cCSSBtN1 := "QPushButton{font: bold 10px Arial;background-repeat: none; }"+;
"QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #dadbde, stop: 1 #f6f7fa); }"

oBtn01:setCSS(cCSSBtN1)
oBtn02:setCSS(cCSSBtN1)

ACTIVATE DIALOG F3SZ4oDlg2 CENTER

If nOpc == 1
	lAtuN3 := .F.
	If SZ4->Z4_NIVEL <> '3'
		If SZ4->Z4_DTFIM <> dDtConcl
			If MsgYesNo("Deseja atualizar a data de conclusão dos projetos analíticos abaixo deste?")
				lAtuN3 := .T.
			EndIf
		EndIf
	EndIf
	Reclock("SZ4",.F.)
	SZ4->Z4_DESC    := cDesc
	SZ4->Z4_PREVISA := nHrPrev
	SZ4->Z4_DTFIM   := dDtConcl
	SZ4->Z4_LINHA   := cLinha
	SZ4->Z4_DTCAD   := dEmissao
	SZ4->Z4_CONCON  := cConsultor
	SZ4->( msUnlock() )
	
	If lAtuN3
		If SZ4->Z4_NIVEL == '1'
			cNIVEL1 := SZ4->Z4_CODIGO
			SZ4->( dbSetOrder(4) ) // Z4_FILIAL + Z4_SUPN1
			If SZ4->( dbSeek( xFilial() + cNIVEL1 ) )
				While !SZ4->( EOF() ) .and. SZ4->Z4_SUPN1 == cNIVEL1
					If Empty(SZ4->Z4_DTFIM)
						Reclock("SZ4",.F.)
						SZ4->Z4_DTFIM   := dDtConcl
						SZ4->( msUnlock() )
					EndIf
					SZ4->( dbSkip() )
				End
			EndIf
		EndIf
		If SZ4->Z4_NIVEL == '2'
			cNIVEL2 := SZ4->Z4_CODIGO
			SZ4->( dbSetOrder(6) ) // Z4_FILIAL + Z4_SUPERIO
			If SZ4->( dbSeek( xFilial() + cNIVEL2 ) )
				While !SZ4->( EOF() ) .and. SZ4->Z4_SUPERIO == cNIVEL2
					If Empty(SZ4->Z4_DTFIM)
						Reclock("SZ4",.F.)
						SZ4->Z4_DTFIM   := dDtConcl
						SZ4->( msUnlock() )
					EndIf
					SZ4->( dbSkip() )
				End
			EndIf
		EndIf
	EndIf
EndIf

Return


Static Function fDtPrevisao()

If Empty(nHrPrev)
	MsgYesNo("Favor preencher o número de horas")
Else
	If Empty(dDtPrIni)
		MsgYesNo("Favor preencher a data de início")
	Else
		If Empty(cHrPrIni)
			MsgYesNo("Favor preencher o horário de início")
		Else
			
			
			
			
			nOpc4 := 0
			
			DEFINE DIALOG F3SZ4oDlg4 TITLE "Pergundas para cálculo" FROM 0,0 TO 560,250 COLOR CLR_BLACK,CLR_WHITE PIXEL
			
			Pergunte("DTSZ4PREVI",.F.)
			
			cConsultor := mv_par01
			nVisitas   := mv_par02
			nHorasDia  := mv_par03
			cSegunda   := mv_par04
			cTerca     := mv_par05
			cQuarta    := mv_par06
			cQuinta    := mv_par07
			cSexta     := mv_par08
			cSabado    := mv_par09
			cDomingo   := mv_par10
			
			nLin := 05
			nCol := 05
			@ nLin, nCol	SAY oTexto1   VAR OemToAnsi('Consultor')  PIXEL SIZE 180,15
			@ nLin+08, nCol MSGET oConsultor VAR cConsultor  Picture "@R 999999" F3 "SZ3" When .T. SIZE 60,12 Valid .T. PIXEL COLOR CLR_BLUE
			
			nLin += 25
			@ nLin, nCol	SAY oTexto1   VAR OemToAnsi('Visitas Semanais')  PIXEL SIZE 180,15
			@ nLin+08, nCol MSGET oVisitas VAR nVisitas  Picture "@E 9"  SIZE 60,12 Valid .T. PIXEL COLOR CLR_BLUE
			
			nLin += 25
			@ nLin, nCol	SAY oTexto1   VAR OemToAnsi('Horas diárias')  PIXEL SIZE 180,15
			@ nLin+08, nCol MSGET oHorasDia VAR nHorasDia  Picture "@E 99"  SIZE 60,12 Valid .T. PIXEL COLOR CLR_BLUE
			
			nLin += 25
			@ nLin, nCol	SAY oTexto1   VAR OemToAnsi('Segunda')  PIXEL SIZE 180,15
			@ nLin+08, nCol MSGET oSegunda VAR cSegunda  Picture "@!"  SIZE 60,12 Valid cSegunda $ "SN" PIXEL COLOR CLR_BLUE
			
			nLin += 25
			@ nLin, nCol	SAY oTexto1   VAR OemToAnsi('Terça')  PIXEL SIZE 180,15
			@ nLin+08, nCol MSGET oTerca VAR cTerca  Picture "@!"  SIZE 60,12 Valid cTerca $ "SN" PIXEL COLOR CLR_BLUE
			
			nLin += 25
			@ nLin, nCol	SAY oTexto1   VAR OemToAnsi('Quarta')  PIXEL SIZE 180,15
			@ nLin+08, nCol MSGET oQuarta VAR cQuarta  Picture "@!"  SIZE 60,12 Valid cQuarta $ "SN" PIXEL COLOR CLR_BLUE
			
			nLin += 25
			@ nLin, nCol	SAY oTexto1   VAR OemToAnsi('Quinta')  PIXEL SIZE 180,15
			@ nLin+08, nCol MSGET oQuinta VAR cQuinta  Picture "@!"  SIZE 60,12 Valid cQuinta $ "SN" PIXEL COLOR CLR_BLUE
			
			nLin += 25
			@ nLin, nCol	SAY oTexto1   VAR OemToAnsi('Sexta')  PIXEL SIZE 180,15
			@ nLin+08, nCol MSGET oSexta VAR cSexta  Picture "@!"  SIZE 60,12 Valid cSexta $ "SN" PIXEL COLOR CLR_BLUE
			
			nLin += 25
			@ nLin, nCol	SAY oTexto1   VAR OemToAnsi('Sábado')  PIXEL SIZE 180,15
			@ nLin+08, nCol MSGET oSabado VAR cSabado  Picture "@!"  SIZE 60,12 Valid cSabado $ "SN" PIXEL COLOR CLR_BLUE
			
			nLin += 25
			@ nLin, nCol	SAY oTexto1   VAR OemToAnsi('Domingo')  PIXEL SIZE 180,15
			@ nLin+08, nCol MSGET oDomingo VAR cDomingo  Picture "@!"  SIZE 60,12 Valid cDomingo $ "SN" PIXEL COLOR CLR_BLUE
			
			nLin += 30
			@ nLin,nCol BUTTON oBtn01 PROMPT "Processa"    Size 50,14 OF F3SZ4oDlg4 PIXEL ACTION {||nOpc4:=1,F3SZ4oDlg4:End() }
			nCol += 60
			@ nLin,nCol BUTTON oBtn02 PROMPT "Cancelar"    Size 50,14 OF F3SZ4oDlg4 PIXEL ACTION {||nOpc4:=0,F3SZ4oDlg4:End() }
			
			cCSSBtN1 := "QPushButton{font: bold 10px Arial;background-repeat: none; } QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #dadbde, stop: 1 #f6f7fa); }"
			
			oBtn01:setCSS(cCSSBtN1)
			oBtn02:setCSS(cCSSBtN1)
			
			ACTIVATE DIALOG F3SZ4oDlg4 CENTER
			
			If nOpc4 == 1
				aBkpPerg := {}
				
				//Chama pergunta ocultamente para alimentar variáveis
				Pergunte("DTSZ4PREVI",.F.,,,,,@aBkpPerg)
				
				//Altera conteúdo de alguma pergunta
				
				mv_par01 := cConsultor
				mv_par02 := nVisitas
				mv_par03 := nHorasDia
				mv_par04 := cSegunda
				mv_par05 := cTerca
				mv_par06 := cQuarta
				mv_par07 := cQuinta
				mv_par08 := cSexta
				mv_par09 := cSabado
				mv_par10 := cDomingo
				
				//Carrega variável principal para que os parâmetros
				//definido acima sejam salvos na próxima chamada
				SaveMVVars(.T.)
				
				__SaveParam("DTSZ4PREVI", aBkpPerg)
				
				If DOW(dDtPrIni)==1
					//_Retorno := 'Domingo'
					_nTmpVisitas++
					If	cDomingo <> 'S'
						MsgYesNo("Data inicial é um Domingo e este dia não é um dia de agenda. Favor alterar a data de inídio ou os dias de agenda.")
						Return
					EndIf
				EndIf
				If DOW(dDtPrIni)==2
					//_Retorno := 'Segunda'
					If cSegunda <> 'S'
						MsgYesNo("Data inicial é uma Segunda-feira e este dia não é um dia de agenda. Favor alterar a data de inídio ou os dias de agenda.")
						Return
					EndIf
				EndIf
				If DOW(dDtPrIni)==3
					//_Retorno := 'Terça'
					If cTerca <> 'S'
						MsgYesNo("Data inicial é uma Terça-feira e este dia não é um dia de agenda. Favor alterar a data de inídio ou os dias de agenda.")
						Return
					EndIf
				EndIf
				If DOW(dDtPrIni)==4
					//_Retorno := 'Quarta'
					If cQuarta <> 'S'
						MsgYesNo("Data inicial é uma Quarta-feira e este dia não é um dia de agenda. Favor alterar a data de inídio ou os dias de agenda.")
						Return
					EndIf
				EndIf
				If DOW(dDtPrIni)==5
					//_Retorno := 'Quinta'
					If	cQuinta  <> 'S'
						MsgYesNo("Data inicial é uma Quinta-feira e este dia não é um dia de agenda. Favor alterar a data de inídio ou os dias de agenda.")
						Return
					EndIf
				EndIf
				If DOW(dDtPrIni)==6
					//_Retorno := 'Sexta'
					If	cSexta <> 'S'
						MsgYesNo("Data inicial é uma Sexta-feira e este dia não é um dia de agenda. Favor alterar a data de inídio ou os dias de agenda.")
						Return
					EndIf
				EndIf
				If DOW(dDtPrIni)==7
					//_Retorno := 'Sabado'
					If cSabado <> 'S'
						MsgYesNo("Data inicial é um Sábado e este dia não é um dia de agenda. Favor alterar a data de inídio ou os dias de agenda.")
						Return
					EndIf
				EndIf
				
				_nTmpVisitas := 0
				
				If cSegunda == 'S'
					_nTmpVisitas++
				EndIf
				If cTerca == 'S'
					_nTmpVisitas++
				EndIf
				If cQuarta == 'S'
					_nTmpVisitas++
				EndIf
				If cQuinta == 'S'
					_nTmpVisitas++
				EndIf
				If cSexta == 'S'
					_nTmpVisitas++
				EndIf
				If cSabado == 'S'
					_nTmpVisitas++
				EndIf
				If cDomingo == 'S'
					_nTmpVisitas++
				EndIf
				
				If _nTmpVisitas <> nVisitas
					MsgYesNo("Número de visitas ("+Alltrim(Str(nVisitas))+") diferente das agendas("+Alltrim(Str(_nTmpVisitas))+"). Favor corrigir.")
					Return
				EndIf
				
				// Início dos cálculos
				_nVisitas  :=  nHrPrev / nHorasDia
				_nHrUltDia := nHorasDia
				
				If Int(_nVisitas) <> _nVisitas
					_nHrUltDia := nHrPrev - (Int(_nVisitas)*nHorasDia)
					_nVisitas  := Int(_nVisitas) + 1
				EndIf
				
				dDataFim := dDtPrIni
				_nTmpVisitas := 0
				
				For x := 1 to 100000
					If Dow(dDataFim) == 1 .and. cDomingo == 'S'
						_nTmpVisitas++
					EndIf
					If Dow(dDataFim) == 2 .and. cSegunda == 'S'
						_nTmpVisitas++
					EndIf
					If Dow(dDataFim) == 3 .and. cTerca == 'S'
						_nTmpVisitas++
					EndIf
					If Dow(dDataFim) == 4 .and. cQuarta == 'S'
						_nTmpVisitas++
					EndIf
					If Dow(dDataFim) == 5 .and. cQuinta == 'S'
						_nTmpVisitas++
					EndIf
					If Dow(dDataFim) == 6 .and. cSexta == 'S'
						_nTmpVisitas++
					EndIf
					If Dow(dDataFim) == 7 .and. cSabado == 'S'
						_nTmpVisitas++
					EndIf
					
					If _nVisitas == _nTmpVisitas
						Exit
					EndIf
					dDataFim := dDataFim + 1
				Next x
				
				dDtPrFim   := dDataFim
				cHrPrFim   := fSoma(cHrPrIni,_nHrUltDia)
				cCombo2    := aCombo2[1]
				
				oDtPrFim:Refresh()
				oHrPrFim:Refresh()
				oCombo2:Refresh()
			EndIf
		EndIf
	EndIf
EndIf

Return

Static Function fSoma(cHrPrIni,_nHrUltDia)
Local _Retorno
Local Temp

Temp := Val(Subs(cHrPrIni,1,2))*60 + Val(Subs(cHrPrIni,3,2))
Temp += _nHrUltDia * 60

TempH := Int(Temp/60)
TempM := Temp - (TempH * 60)

_Retorno := StrZero(TempH,2) + StrZero(TempM,2)

Return _Retorno
