#include "rwmake.ch"
#include "topconn.ch"
#include "totvs.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFATA06   บAutor  ณMarco Aurelo-OPUS   บ Data ณ  27/03/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบProg.ORI  ณORC002    บAutor  ณMarco Aurelo-OPUS   บ Data ณ  11/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Insere cod de Autorizacao de Cartao Credito/Titulo RA      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

BR_AMARELO / BR_AZUL / BR_BRANCO / BR_CINZA / BR_LARANJA / BR_MARRON / 
BR_VERDE / BR_VERMELHO / BR_PINK / BR_PRETO
*/

User Function RFATA06()

Local cAlias := "SC5"
Local cFiltra := "C5_XSTATUS <> ''"
Local aIndexSC5 := {}
Local bFiltraBrw:= { || FilBrowse(cAlias,@aIndexSC5,@cFiltra) }
  
// Valida usuarios que podem acessar a rotina
if __CUSERID $ getmv("MV_XCRDANA")

		cCadastro := OemtoAnsi("Risco E - Autoriza็ใo de Cartใo de Cr้dito / Dep๓sito Antecipado")
		aFixe     := {  	{"Pedido"		,"C5_NUM"},;
								{"Emissao"		,"C5_EMISSAO"},;
								{"Cliente"		,"C5_CLIENTE"},;
								{"Loja"			,"C5_LOJACLI"},;
								{"CondPagto"	,"C5_CONDPAG"},;
								{"Aut.Cartao"	,"C5_XAUTCC"},;
								{"Aut.Deposi"	,"C5_XAUTRA"}	}
		
		aRotina  := {	{ "Pesquisar"     , "Axpesqui"   , 0 , 1},;
							{ "Visualiza"     , "Axvisual"   , 0 , 2},; 
							{ "Autoriza็ใo"   , "U_Autoriz2" , 0 , 4} ,; 				
							{ "Legenda"       , "U_BLegend2" , 0 , 3} } 												
		
		aCores   := {} 
		AADD(aCores,{"alltrim(C5_XAUTCC) <> '' .or.  alltrim(C5_XAUTRA) <> '' " ,"BR_VIOLETA" })		//C= Cartao Autorizado	//MAS-OPUS
		AADD(aCores,{"alltrim(C5_XAUTCC) == '' .and. alltrim(C5_XAUTRA) == '' " ,"BR_BRANCO"  })		//B= Aguardando Autorizacao CC	//MAS-OPUS
		
		
		dbSelectArea(cAlias)
		dbSetOrder(1)
		Eval(bFiltraBrw)
		dbGoTop()
		
		mBrowse(6,1,22,75,cAlias,aFixe,,,,,aCores,,,,,)
		EndFilBrw(cAlias,aIndexSC5)

Else
	MsgAlert("MV_XCRDANA - Voc๊ nใo tem Acesso para executar esta Rotina. Solicite ao TI.")

Endif

Return

                          

User Function Autoriz2(cAlias, nReg, nOpc)
	Local nOpcao := nOpc
	Local oDlg1

	cAutCC	:= SC5->C5_XAUTCC 
	cAutRA	:= SC5->C5_XAUTRA

    @ 000,000 TO 150,300 DIALOG oDlg1 TITLE "Autoriza็ใo de Cartใo de Cr้dito / Dep๓sito"
    @ 002,001 Say "C๓digo de Autoriza็ใo do Cartใo: "    
    @ 002,013 Get cAutCC  Picture "@!"  Size 40,10  
    @ 005,001 Say "Titulo de Dep๓sito Antecipado: "    
    @ 005,013 Get cAutRA  Picture "@!"  F3 "SE1" Size 40,10 
      
    @ 050,070 BMPBUTTON TYPE 01 ACTION Close(oDlg1)

    ACTIVATE DIALOG oDlg1 CENTERED

	if !empty(cAutCC) .and. msgyesno("Confirma Autorizacao Num. "+alltrim(cAutCC)+" no Pedido "+SC5->C5_NUM+ " ?","Confirma Autoriza็ใo ")
		Dbselectarea("SC5")
		Reclock("SC5",.F.)
			SC5->C5_XAUTCC 	:=	cAutCC
			SC5->C5_XAUTRA 	:=	cAutRA			
		Msunlock()
	endif


Return



//+-------------------------------------------
//|Fun็ใo: BLegenda - Rotina de Legenda
//+-------------------------------------------
User Function BLegend2()
Local aLegenda := {}
Local cCadastro := OemtoAnsi("Autoriza็ใo de Cartใo de Cr้dito / Dep๓sito Antecipado")

AADD(aLegenda,{"BR_VIOLETA" ,"Jแ Autorizado" })
AADD(aLegenda,{"BR_BRANCO"  ,"Aguardando Autoriza็ใo" })

//BrwLegenda(cCadastro, "Legenda", aLegenda)
Return Nil