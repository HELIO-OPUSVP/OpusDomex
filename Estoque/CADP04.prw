#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FILEIO.CH"
#include "rwmake.ch"
#INCLUDE "MSOBJECT.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCADP04    บAutor  ณMichel Sander       บ Data ณ  14/10/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cadastro de produto x equipes de inventario			        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CADP04()

Local aCores := {}

PRIVATE aRotina := MenuDef() 
Private aVetFor  := {}
Private oChecked := LoadBitmap(GetResources(),"LBTIK")
Private oUnCheck := LoadBitmap(GetResources(),"LBNO")
Private oBtNO     := LoadBitmap(GetResources(), "BR_VERMELHO")
Private oBTLivre  := LoadBitmap(GetResources(), "BR_VERDE")
Private aClassBox := {}
PRIVATE aEquipes := {}
PRIVATE cEquipe  := ""
PRIVATE oEquipes
PRIVATE bEquipes 
PRIVATE oCbx1
PRIVATE oDlg1

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define o cabecalho da tela de atualizacoes                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
PRIVATE cCadastro := OemToAnsi("Cadastro de Equipes x Produtos")

MBrowse( 6, 1, 22, 75, "P04",,,,,,aCores)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMenuDef   บAutor  ณMichel A. Sander    บ Data ณ  31.10.15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta Menu Principal 						                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MenuDef()

Local aRotina := { { 'Pesquisar'  ,"axPesqui",        0 , 1},; //Pesquisar
                   { 'Visualizar' ,"U_MANP04(2)", 0 , 2},;  //Visualizar
                   { 'Gera็ใo'    ,"U_SELEP04(3)", 0 , 3},; //Incluir
                   { 'Excluir'    ,"U_MANP03(5)", 0 , 5} }  //Exclusใo

Return aRotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMANP04		บAutor  ณMichel A. Sander    บ Data ณ  31.10.15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Manuten็ใo no cadastro de produto x equipes inventario     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MANP04(nOpcx)

Local nRet     := 0
Local aScrRes  := GetScreenRes()
Local aArea    := GetArea()
Local oFont10  := TFont():New("Arial",,-12,.T.,.T.)
Local oFont12  := TFont():New("Arial",,-14,.T.,.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Tela de Equipes por produto								 						  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
opcaoZZ  := 0
DEFINE MSDIALOG oDlg1 TITLE OemToAnsi("Produto x Equipes de Inventแrio") from 5,0 To (aScrRes[2]-95),(aScrRes[1]-15) of oMainwnd COLOR CLR_BLACK,CLR_WHITE Pixel

oDlg1:lMaximized := .t.
oDlg1:lEscClose := .f.

	//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	//ฑฑ  Dados do Funcionario                    ฑฑ
	//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	oPanelCab:=TPanel():New(00,00,,oDlg1,,,,,RGB(255,255,255),12,12,.F.,.F.)
	oPanelCab:Align := CONTROL_ALIGN_TOP
	oPanelCab:nHeight := 80

   @ 19,005 SAY "Escolha a Equipe" SIZE 120,60 of oPanelCab PIXEL
	@ 19,100 COMBOBOX oCbx1 VAR cEquipe ITEMS aClassBox SIZE 120,60 Of oPanelCab WHEN .T. VALID SelEquipes() Pixel //Valid fClaBrwEpi(cOrdemEPI,.t.)

	//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	//ฑฑ  Epis pendentes                          ฑฑ
	//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	aCol800 := {10,40,100,40,40,40,40,20,40}
	aTit800 := {}
	aAdd(aTit800, "")
	aAdd(aTit800, "")
	aAdd(aTit800, Alltrim(NGRETTITULO("P04_CODPRO")) )
	aAdd(aTit800, PADR("Descri็ใo do Produto",150) )
	aAdd(aTit800, Alltrim(NGRETTITULO("P04_CODEQU")) )
	aAdd(aTit800, Alltrim(NGRETTITULO("P04_ENDERE")) )
	aAdd(aTit800, Alltrim(NGRETTITULO("P04_LOCAL")) )
	aAdd(aTit800, "Data do Inventแrio" )
	bEquipes := { || { If(aEquipes[oEquipes:nAt,1],oChecked,oUnCheck),;
						    If(aEquipes[oEquipes:nAt,2],oBTLivre,oBTNO),;
						   aEquipes[oEquipes:nAt,3],;
						   aEquipes[oEquipes:nAt,4],;
						   aEquipes[oEquipes:nAt,5],;
						   aEquipes[oEquipes:nAt,6],;
						   aEquipes[oEquipes:nAt,7],;
						   aEquipes[oEquipes:nAt,8] } }

	oEquipes := TWBrowse():New( 017 , 4, 175, 140,,aTit800,aCol800,oDlg1,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
	oEquipes:Align := CONTROL_ALIGN_ALLCLIENT
	oEquipes:SetArray(aEquipes)
	oEquipes:bLine:= bEquipes
	oEquipes:bLDblClick   := {|| fMarkEpi() , oEquipes:DrawSelect() }
	oEquipes:bHeaderClick := {|x,a| fMarkAll(x,a) }
	oEquipes:nAt := 1

ACTIVATE MSDIALOG oDlg1 ON INIT EnchoiceBar(oDlg1,{||opcaoZZ:=1, oDlg1:End()},{||oDlg1:End()})

If opcaoZZ==1

	For x := 1 to Len(aEquipes)
	
	    If aEquipes[x,1]
	       If !Empty(aEquipes[x,5])
			    P04->(dbSetOrder(1))
			    If P04->(dbSeek(xFilial("P04")+aEquipes[x,3]))
			       Reclock("P04",.F.)
			       P04->P04_CODEQU := aEquipes[x,5]
			       P04->(MsUnlock())
			    Else
			       Reclock("P04",.T.)
			       P04->P04_FILIAL := xFilial("P04")
			       P04->P04_CODPRO := aEquipes[x,3]
			       P04->P04_CODEQU := aEquipes[x,5]
			       P04->P04_ENDERE := aEquipes[x,6]
			       P04->P04_LOCAL  := aEquipes[x,7]
			       P04->P04_DTINV  := aEquipes[x,8]
			       P04->(MsUnlock())
			   EndIf   
			EndIf          
		EndIf
			
	Next
	
endif

Return nRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณSELEP04  ณ Autor ณMichel A. Sander      ณ Data ณ 06.11.2015 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Rotina para sele็ใo dos produtos para equipe				     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Domex                                                      ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function SELEP04()

Local lGravouLog 	:= .F.
Local oOk        	:= LoadBitmap( GetResources(), "LBOK" )
Local oNOk       	:= LoadBitmap( GetResources(), "LBNO" )
Local oList
Local nModelo     := 1
Local cModoContab := ""
Local cValorContab:= ""

Private __cInterNet	:= Nil
Private aModo			:= {}
Private aValores     := {}
Private cTitulo    	:= "Gera็ใo das Equipes por Produto"
Private cAcao      	:= "Selecionar os Endere็os"
Private cApresenta 	:= ''
Private cArqSaida 	:= ''
Private cMesAno      := SPACE(06)
Private cLogUpdate 	:= ''
Private cEmpAtu    	:= ''
Private lConcordo  	:= .F.
Private nTela      	:= 0
Private nHdl
Private oTitulo
Private oAcao
Private oEmpAtu
Private oSelEmp
Private oMemo1
Private oMemo2
Private oMemo3
Private oMemo4
Private oDlgUpd
Private oPanel1
Private oPanel2
Private oPanel3
Private oPanel4
Private oPanel5
Private oItemAju
Private oApresenta
Private oTerAceite               
Private oArqSaida
Private oChkAceite
Private oBtnAvanca
Private oBtnCancelar   
Private oModo
Private oDlgUpd
Private cEndIni   := SPACE(15)
Private cEndFin   := SPACE(15)
Private cAlmoxIni := SPACE(02)
Private cAlmoxFin := SPACE(02)
Private cProdIni  := SPACE(15)
Private cProdFin  := REPL("Z",15)
Private dDataEnv  := GetMV("MV_XXDTINV")

aEquipes   := {}
aClassBox  := {}
cApresenta := "A rotina irแ selecionar os endere็os de contagem do inventแrio, para filtrar os produtos que serใo"+CRLF	
cApresenta += "separados por equipes."+CRLF	

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ DIALOG PRINCIPAL                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE DIALOG oDlgUpd TITLE "Produto x Equipes" FROM 0, 0 TO 22, 75 SIZE 550, 350 PIXEL//"SIGAEST - Update"
@ 000,000 BITMAP oBmp RESNAME 'Login' OF oDlgUpd SIZE 120, oDlgUpd:nBottom NOBORDER WHEN .F. PIXEL
@ 005,070 SAY oTitulo         VAR cTitulo OF oDlgUpd PIXEL FONT (TFont():New('Arial',0,-13,.T.,.T.))
@ 015,070 SAY oAcao           VAR cAcao   OF oDlgUpd PIXEL
@ 155,140 BUTTON oBtnCancelar PROMPT "Cancelar"  SIZE 60, 14 ACTION If(oBtnCancelar:cCaption=='&Cancelar'  , oDlgUpd:End(),oDlgUpd:End())	OF oDlgUpd PIXEL	//"Cancelar"
@ 155,210 BUTTON oBtnAvanca   PROMPT "Avancar >>"  SIZE 60, 14 ACTION If(oBtnAvanca:cCaption  =='&Finalizar' , oDlgUpd:End(), SelePanel(@nTela)) OF oDlgUpd PIXEL		//"Avancar"
oDlgUpd:nStyle := nOR( DS_MODALFRAME, WS_POPUP, WS_CAPTION, WS_VISIBLE )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ PAINEL 1                                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPanel1 := TPanel():New( 028, 072, ,oDlgUpd, , , , , , 200, 120, .F.,.T. )
@ 002,005 SAY oApresenta VAR "Bem-Vindo!" 	OF oPanel1                         	FONT (TFont():New('Arial',0,-13,.T.,.T.))PIXEL//
@ 015,005 GET oMemo1     VAR cApresenta OF oPanel1 MEMO PIXEL SIZE 180,100	FONT (TFont():New('Verdana',,-12,.T.)) NO BORDER
oMemo1:lReadOnly := .T.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ PAINEL 2                                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

oPanel2 := TPanel():New( 028, 072, ,oDlgUpd, , , , , , 200, 120, .F.,.T. )
@ 000,005 SAY oTexto1   		VAR "Endere็o Inicial" 	OF oPanel2 FONT (TFont():New('Verdana',0,-13,.T.,.T.)) PIXEL
@ 010,005 MSGET oGet1         VAR cEndIni   WHEN .T. F3 "USBE" VALID VLDSBE(cEndIni) OF oPanel2 PIXEL SIZE 100,10 FONT (TFont():New('Verdana',,-12,.T.))  
@ 000,115 SAY oTexto3   		VAR "Local Inicial" 	OF oPanel2 FONT (TFont():New('Verdana',0,-13,.T.,.T.)) PIXEL
@ 010,115 MSGET oGet3         VAR cAlmoxIni WHEN .T. VALID VLDEND(cAlmoxIni,cEndIni) OF oPanel2 PIXEL SIZE 10,10 FONT (TFont():New('Verdana',,-12,.T.))  
@ 025,005 SAY oTexto2		   VAR "Endere็o Final  " OF oPanel2 FONT (TFont():New('Verdana',0,-13,.T.,.T.)) PIXEL
@ 035,005 MSGET oGet2		   VAR cEndFin   WHEN .T. F3 "USBE" VALID VLDSBE(cEndFin) OF oPanel2 PIXEL SIZE 100,10 FONT (TFont():New('Verdana',,-12,.T.))  
@ 025,115 SAY oTexto4   		VAR "Local Final" 	OF oPanel2 FONT (TFont():New('Verdana',0,-13,.T.,.T.)) PIXEL
@ 035,115 MSGET oGet4         VAR cAlmoxFin WHEN .T. VALID VLDEND(cAlmoxFin,cEndFin) OF oPanel2 PIXEL SIZE 10,10 FONT (TFont():New('Verdana',,-12,.T.))  

@ 050,005 SAY oTexto6   		VAR "Produto Inicial" OF oPanel2 FONT (TFont():New('Verdana',0,-13,.T.,.T.)) PIXEL
@ 060,005 MSGET oGet6         VAR cProdIni  WHEN .T. F3 "SB1" VALID VLDSB1(cProdIni) OF oPanel2 PIXEL SIZE 100,10 FONT (TFont():New('Verdana',,-12,.T.))  
@ 075,005 SAY oTexto7		   VAR "Produto Final  " OF oPanel2 FONT (TFont():New('Verdana',0,-13,.T.,.T.)) PIXEL
@ 085,005 MSGET oGet7         VAR cProdFin  WHEN .T. F3 "SB1" VALID VLDSB1(cProdFin) OF oPanel2 PIXEL SIZE 100,10 FONT (TFont():New('Verdana',,-12,.T.))  

@ 105,005 SAY oTexto5		   VAR "Data do Inventario" OF oPanel2 FONT (TFont():New('Verdana',0,-13,.T.,.T.)) PIXEL
@ 105,080 MSGET oGet5		   VAR dDataEnv  WHEN .F.  VALID { || oBtnAvanca:SetFocus() } OF oPanel2 PIXEL SIZE 50,10 FONT (TFont():New('Verdana',,-12,.T.))  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ PAINEL 5                                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPanel5 := TPanel():New( 028, 072, ,oDlgUpd, , , , , , 200, 120, .F.,.T. )

ACTIVATE DIALOG oDlgUpd CENTER ON INIT SelePanel(@nTela)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVLDEND       บAutor  ณMichel Sander    บ Data ณ  10/21/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida digitacao de almoxarifados                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static function VLDEND(cVerAlmox,cVerEnd)

LOCAL lEndRet := .T.

SBE->(dbSetOrder(1))
If !SBE->(dbSeek(xFilial("SBE")+cVerAlmox+cVerEnd))
   Aviso("Aten็ใo","Endere็o invแlido ou nใo encontrado para esse almoxarifado.",{"Ok"})
   lEndRet := .F.
EndIf

Return ( lEndRet )
   
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVLDSBE       บAutor  ณMichel Sander    บ Data ณ  10/21/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida digitacao de enderecos		                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static function VLDSBE(cVerEnd)

LOCAL lEndRet := .T.

If cVerEnd <> "ZZZZZZZZZZZZZZZ" .And. !Empty(cVerEnd)
	cSQL := "SELECT BE_LOCALIZ FROM "+RetSQLName("SBE")+" (NOLOCK) WHERE BE_LOCALIZ='"+cVerEnd+"' AND D_E_L_E_T_=''"
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"TMP",.F.,.T.)
	If TMP->(EOf())
	   Aviso("Aten็ใo","Endere็o invแlido.",{"Ok"})
	   lEndRet := .F.
	EndIf   
	TMP->(dbCloseArea())
EndIf

Return ( lEndRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVLDSB1       บAutor  ณMichel Sander    บ Data ณ  10/21/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida digitacao de produtos		                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static function VLDSB1(cVerProd)

LOCAL lProdRet := .T.

If cVerProd <> "ZZZZZZZZZZZZZZZ" .And. !Empty(cVerProd)
	If !SB1->(dbSeek(xFilial("SB1")+cVerProd))
	   Aviso("Aten็ใo","Produto nใo cadastrado.",{"Ok"})
	   lProdRet := .F.
	EndIf   
EndIf

If !Empty(cProdIni) .And. !Empty(cProdFin)
	oBtnAvanca:lActive := .T.
Endif
   
Return ( lProdRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSelEquipes   บAutor  ณMichel Sander    บ Data ณ  10/21/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Preenche a equipe selecionada		                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SelEquipes()

LOCAL _lRetorno := .T.

For nQ := 1 to Len(aEquipes)

    oEquipes:nAT := nQ
	 If aEquipes[oEquipes:nAT,1]
	    aEquipes[oEquipes:nAT,5] := SUBSTR(cEquipe,1,6)
	 EndIf   
   
  	 bEquipes := { || { If(aEquipes[oEquipes:nAt,1],oChecked,oUnCheck),;
	   					  If(aEquipes[oEquipes:nAt,2],oBTLivre,oBTNO),;
						   aEquipes[oEquipes:nAt,3],;
						   aEquipes[oEquipes:nAt,4],;
						   aEquipes[oEquipes:nAt,5],;
						   aEquipes[oEquipes:nAt,6],;
						   aEquipes[oEquipes:nAt,7],;
						   aEquipes[oEquipes:nAt,8] } }

	 oEquipes:SetArray(aEquipes)
	 oEquipes:bLine:= bEquipes
	 oEquipes:Refresh()

Next

oEquipes:nAT := 1
oEquipes:Refresh()

Return ( _lRetorno )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfMarkEpi     บAutor  ณMichel Sander    บ Data ณ  10/21/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Marca o EPI que serแ entregue		                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fMarkEpi()

If aEquipes[oEquipes:nAt,2]

	If aEquipes[oEquipes:nAt,1]
		aEquipes[oEquipes:nAt,1] := .F.
	Else
		aEquipes[oEquipes:nAt,1] := .T.
	EndIf
	
	bEquipes := { || { If(aEquipes[oEquipes:nAt,1],oChecked,oUnCheck),;
	  					    If(aEquipes[oEquipes:nAt,2],oBTLivre,oBTNO),;
					   	aEquipes[oEquipes:nAt,3],;
					   	aEquipes[oEquipes:nAt,4],;
					   	aEquipes[oEquipes:nAt,5],;
					   	aEquipes[oEquipes:nAt,6],;
						   aEquipes[oEquipes:nAt,7],;
						   aEquipes[oEquipes:nAt,8] } }

	oEquipes:SetArray(aEquipes)
	oEquipes:bLine:= bEquipes
	oEquipes:Refresh()

EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfMarkAll     บAutor  ณMichel Sander     บ Data ณ  10/21/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Marca todos os EPIs que serใo entregues                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fMarkAll()

If aEquipes[oEquipes:nAt,2]

	For nX := 1 to Len(aEquipes)
	
	   oEquipes:nAT := nX
		If aEquipes[oEquipes:nAt,1]
			aEquipes[oEquipes:nAt,1] := .F.
		Else
		   If EMPTY(aEquipes[oEquipes:nAt,4])
				aEquipes[oEquipes:nAt,1] := .T.
			EndIf	
		EndIf         
	
	Next
	
	bEquipes := { || { If(aEquipes[oEquipes:nAt,1],oChecked,oUnCheck),;
	   					  If(aEquipes[oEquipes:nAt,2],oBTLivre,oBTNO),;
							   aEquipes[oEquipes:nAt,3],;
							   aEquipes[oEquipes:nAt,4],;
							   aEquipes[oEquipes:nAt,5],;
							   aEquipes[oEquipes:nAt,6],;
							   aEquipes[oEquipes:nAt,7],;
							   aEquipes[oEquipes:nAt,8] } }
	
	oEquipes:SetArray(aEquipes)
	oEquipes:bLine:= bEquipes
	oEquipes:Refresh()

EndIf
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณSelePanel ณ Autor ณMicrosiga S/A          ณ Data ณ 03/03/09 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Funcao utilizada para selecao atraves de painel            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ UPDATE                                                     ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function SelePanel(nTela)

Local lRet := .T.
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Atualiza variaveis da janela principal ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oTitulo:nLeft           := 120; oTitulo:Refresh()
oAcao:nLeft             := 120; oAcao:Refresh()
oBmp:lVisibleControl    := .T.
oPanel1:lVisibleControl := .F.
oPanel2:lVisibleControl := .F.
oPanel5:lVisibleControl := .F.

Do Case
	Case nTela == 0 //-- Apresentacao
		oPanel1:lVisibleControl := .T.
	Case nTela == 1 //-- Parametros
		oPanel2:lVisibleControl := .T.
		oBtnAvanca:lActive      := .T.
	Case nTela == 2 //-- Selecao da empresa
			cAcao                   := "Exporta็ใo de dados"; oAcao:Refresh()
			If cAlmoxIni <> cAlmoxFin
			   Aviso("Aten็ใo","Almoxarifados nใo podem ser diferentes.",{"Ok"})
				oPanel2:lVisibleControl := .T.			   
			   lRet := .F.
			ElseIf Empty(cEndIni) .Or. Empty(cEndIni)
			   Aviso("Aten็ใo","Endere็o Inicial ou Final deve ser preenchido.",{"Ok"})
				oPanel2:lVisibleControl := .T.			   
			   lRet := .F.
			ElseIf cProdIni > cProdFin
			   Aviso("Aten็ใo","Produto Inicial maior que o produto final.",{"Ok"})
				oPanel2:lVisibleControl := .T.			   
			   lRet := .F.
			ElseIf cEndIni > cEndFin
			   Aviso("Aten็ใo","Endere็o Inicial maior que o Endere็o Final.",{"Ok"})
				oPanel2:lVisibleControl := .T.			   
			   lRet := .F.
			Else
				oPanel5:lVisibleControl := .T.
				oBtnCancelar:lActive    := .F. //-- A partir deste ponto nao pode mais ser cancelado
				oBtnAvanca:lActive      := .F.
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Processamento dos produtos			    ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				Processa({||MntProdP04()})
				U_MANP04(1)
				aEquipes := {}
				oDlgUpd:End()
			EndIf	
EndCase

If lRet
	nTela ++
EndIf

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณMntProdP04 ณ Autor ณMichel Sander         ณ Data ณ 03/03/09 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Prepara os produtos para os endere็os selecionados         ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ UPDATE                                                     ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function MntProdP04()

cAliasSBF := GetNextAlias()

BeginSQL Alias cAliasSBF

	SELECT BF_LOCAL, BF_LOCALIZ, BF_PRODUTO FROM %table:SBF% (NOLOCK) SBF 
				WHERE BF_LOCALIZ >= %exp:cEndIni% 
				AND BF_LOCALIZ <= %exp:cEndFin%   
				AND BF_LOCAL >= %exp:cAlmoxIni%
				AND BF_LOCAL <= %exp:cAlmoxFin%
				AND BF_PRODUTO >= %exp:cProdIni%
				AND BF_PRODUTO <= %exp:cProdFin%
				AND SBF.%NotDel%

EndSQL
              
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Preenche o listbox com os produtos     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nRegs := (cAliasSBF)->(Lastrec())
ProcRegua(nRegs)
(cAliasSBF)->(dbGotop())
Do While (cAliasSBF)->(!Eof())
   IncProc("Selecionando endere็os...")
   lAchou := .F.
   lFirst := .T.
   cFirst := fVerifEnds((cAliasSBF)->BF_PRODUTO,(cAliasSBF)->BF_LOCAL)
   If cFirst >= cEndIni .And. cFirst <= cEndFin
      cSQL := "SELECT P04_CODEQU FROM "+RetSQLName("P04")+" WHERE "
      cSQL += "P04_FILIAL = '"+xFilial("P04")+"' AND "
      cSQL += "P04_CODPRO = '"+(cAliasSBF)->BF_PRODUTO+"' AND "
      cSQL += "P04_LOCAL  = '"+(cAliasSBF)->BF_LOCAL  +"' AND "
      cSQL += "P04_DTINV  = '"+DTOS(dDataEnv)+"' AND "
      cSQL += "D_E_L_E_T_ = ''"
      dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"TP04",.F.,.T.)
      cCodEqu := TP04->P04_CODEQU
      If TP04->(Eof())
         lAchou := .T.
      Endif  
      TP04->(dbCloseArea())
	   AADD(aEquipes, { lAchou,;
	   					  lFirst,;
	   					 (cAliasSBF)->BF_PRODUTO,;
	   					 PADR(Posicione("SB1",1,xFilial("SB1")+(cAliasSBF)->BF_PRODUTO,"B1_DESC"),80),;
	   					 cCodEqu,;
	   					 cFirst,;
	   					 (cAliasSBF)->BF_LOCAL,; 
	   					 If(!lAchou,P04->P04_DTINV,dDataEnv) } )
   EndIf
   (cAliasSBF)->(dbSkip())
EndDo
(cAliasSBF)->(dbCloseArea())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta o combo das equipes				    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
AADD(aClassBox,SPACE(06)+SPACE(02)+SPACE(60))                 
P03->(dbGotop())
Do While P03->(!Eof())
   If ASCAN(aClassBox,P03->P03_CODIGO+"  "+P03->P03_NOME)==0
	   AADD(aClassBox,P03->P03_CODIGO+"  "+P03->P03_NOME)
	EndIf   
   P03->(dbSkip())
EndDo

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณVerifEnds  ณ Autor ณMichel Sander         ณ Data ณ 03/03/09 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Busca produtos com mais de um endere็o e seleciona o 1o.   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ UPDATE                                                     ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fVerifEnds(cProdBusca,cLocBusca)

LOCAL cRet := ""
LOCAL cAliasTMP := GetNextAlias()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Procura o mesmo item em mais de um endere็o				    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
BEGINSQL Alias cAliasTMP

	SELECT TOP 1 BF_LOCALIZ FROM %table:SBF% TMP (NOLOCK)
		WHERE BF_PRODUTO = %exp:cProdBusca% 
		AND	BF_LOCAL   = %exp:cLocBusca%
		AND   BF_QUANT   > 0
		AND   TMP.%NotDel%
	   ORDER BY BF_LOCALIZ
	   
ENDSQL

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se existir em mais de um pegar sempre o primeiro		    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cRet := (cAliasTMP)->BF_LOCALIZ
(cAliasTMP)->(dbCloseArea())
      
Return ( cRet )