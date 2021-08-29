#include "rwmake.ch"
#include "topconn.ch"
#include "totvs.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณORC002    บAutor  ณMarco Aurelio       บ Data ณ  22/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ insere Autorizacao de Cartao de Credito no Or็amento       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
BR_AMARELO / BR_AZUL / BR_BRANCO / BR_CINZA / BR_LARANJA / BR_MARRON / 
BR_VERDE / BR_VERMELHO / BR_PINK / BR_PRETO
*/

User Function ORC002()

Local cAlias := "SCJ"
Local cFiltra := "CJ_XSTATUS <> ''"
Local aIndexSCJ := {}
Local bFiltraBrw:= { || FilBrowse(cAlias,@aIndexSCJ,@cFiltra) }

cCadastro := OemtoAnsi("Manuten็ใo de Autorizacao de Cartใo de Credito - Or็amentos")
aFixe     := {  {"Orcamento","CJ_NUM"},;
				{"Emissao","CJ_EMISSAO"},;
				{"Cliente","CJ_CLIENTE"},;
				{"Loja","CJ_LOJA"},;
				{"Cliente","CJ_CLIENTE"},;
				{"CondPagto","CJ_CONDPAG"},;
				{"Autorizacao","CJ_XAUTCC"}	}

aRotina  := {	{ "Pesquisar"        , "Axpesqui"      , 0 , 1},;
				{ "Visualiza"        , "Axvisual"      , 0 , 2},; 
				{ "Autorizacao"      , "U_Autoriz"   , 0 , 4} ,; 				
				{ "Legenda"          , "U_BLegenda"   , 0 , 3} } 												

aCores   := {} 
AADD(aCores,{"alltrim(CJ_XAUTCC) <> ''" ,"BR_VIOLETA" })	//C= Cartao Autorizado	//MAS-OPUS
AADD(aCores,{"alltrim(CJ_XAUTCC) == ''" ,"BR_BRANCO" })//B= Aguardando Autorizacao CC	//MAS-OPUS


dbSelectArea(cAlias)
dbSetOrder(1)
Eval(bFiltraBrw)
dbGoTop()
//mBrowse(6,1,22,75,cAlias)
//mBrowse( 6, 1,22,75,"SCJ",,,,,,aCores)
mBrowse(6,1,22,75,cAlias,aFixe,,,,,aCores,,,,,)
EndFilBrw(cAlias,aIndexSCJ)

Return

                          

User Function Autoriz(cAlias, nReg, nOpc)
	Local nOpcao := nOpc
	Local oDlg1

	cAutoriz	:= SCJ->CJ_XAUTCC

    @ 000,000 TO 150,300 DIALOG oDlg1 TITLE "Autorizacao de Cartใo de Cr้dito"
    @ 002,001 Say "C๓digo de Autoriza็ใo do Cartใo: "    
    @ 002,013 Get cAutoriz  Picture "@!"  Size 40,10    
    @ 050,070 BMPBUTTON TYPE 01 ACTION Close(oDlg1)

    ACTIVATE DIALOG oDlg1 CENTERED

	if !empty(cAutoriz) .and. msgyesno("Confirma Autorizacao Num. "+alltrim(cAutoriz)+" no Orcamento "+SCJ->CJ_NUM+ " ?","Confirma Autorizacao ")
		Dbselectarea("SCJ")
		Reclock("SCJ",.F.)
			SCJ->CJ_XAUTCC 	:=	cAutoriz
		Msunlock()
	endif


Return



//+-------------------------------------------
//|Fun็ใo: BLegenda - Rotina de Legenda
//+-------------------------------------------
User Function BLegenda()
Local aLegenda := {}
Local cCadastro := OemtoAnsi("Manuten็ใo de Autorizacao de Cartใo de Credito - Or็amentos")

AADD(aLegenda,{"BR_VIOLETA" ,"Cartao Autorizado" })
AADD(aLegenda,{"BR_BRANCO" ,"Aguardando Autoriza็ใo" })

//BrwLegenda(cCadastro, "Legenda", aLegenda)
Return Nil