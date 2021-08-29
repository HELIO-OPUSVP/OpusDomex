#include "rwmake.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO16    ºAutor  ³Microsiga           º Data ³  03/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CADSC6()
  
//	msgAlert("Rotina Desatualizada. Procure o TI.")  
Aviso("Atenção","Esta tela foi descontinuada. Favor acessar a rotina de Previsão de Faturamento.",{"Ok"})	
	
/*	
DbSelectArea("SC6")

aRotina := { { "Pesquisar    ",'AxPesqui'   , 0, 1 },;
{ "Altera Dt OTD",'U_B1CADSC6' , 0, 5 }}

cCadastro := "Alteração de data OTD"

mBrowse( 6, 1,22,75,"SC6",,,,,,,,,,,,,,)
*/
Return


User Function B1CADSC6()

	Aviso("Atenção","Esta tela foi descontinuada. Favor acessar a rotina de Previsão de Faturamento.",{"Ok"})
Return

dDtAtu  := SC6->C6_XXDTDEF
dDtNova := CtoD("")
cMotivo := Space(254)

DEFINE MSDIALOG oDlg1 TITLE OemToAnsi("Alteração de Data OTD") FROM 0,0 TO 225,435 PIXEL of oMainWnd PIXEL

nLin := 15
@ nLin, 010	SAY oTexto1   VAR 'Data atual:' SIZE 180,15 PIXEL
oTexto1:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)

@ nLin-3, 060 MSGET oDtAtu VAR dDtAtu WHEN(.F.) Picture "@D" SIZE 60,12  PIXEL
oDtAtu:oFont := TFont():New('Courier New',,15,,.T.,,,,.T.,.F.)

nLin += 25

@ nLin, 010	SAY oTexto2   VAR OemToAnsi('Nova data:')  PIXEL SIZE 180,15
oTexto2:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)

@ nLin-3, 060 MSGET oDtNova VAR dDtNova  Picture "@D"  SIZE 60,12 Valid dDtNova <> SC6->C6_XXDTDEF PIXEL
oDtNova:oFont := TFont():New('Courier New',,15,,.T.,,,,.T.,.F.)

nLin += 25

@ nLin, 010	SAY oTexto2   VAR OemToAnsi('Motivo:')  PIXEL SIZE 180,15
oTexto2:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)

@ nLin-3, 060 MSGET oMotivo VAR cMotivo  Picture "@R"  SIZE 150,12 PIXEL
oDtAtu:oFont := TFont():New('Courier New',,15,,.T.,,,,.T.,.F.)

nLin += 25

@ nLin,120 BUTTON "Salvar"	SIZE 040,11 ACTION Salvar()  PIXEL
@ nLin,170 BUTTON "Sair"	   SIZE 040,11 ACTION oDlg1:End() PIXEL

ACTIVATE MSDIALOG oDlg1


Static Function Salvar()

If !Empty(dDtNova)
	
	cTexto := "Data de OTD do Pedido " + SC6->C6_NUM + ", item " + SC6->C6_ITEM  +" cliente "+Alltrim(Posicione("SA1",1,xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA,"A1_NOME"))+" alterada de " + DtoC(SC6->C6_XXDTDEF) 
	
	Reclock("SC6",.F.)
	SC6->C6_XXDTDEF := dDtNova
	SC6->( msUnlock() )
	
	If dDtNova == SC6->C6_XXDTDEF
		cTexto   += " para " + DtoC(SC6->C6_XXDTDEF) + " por "+Alltrim(UsrRetName(__cUserID))+"." + "<br>"
		cTexto   += "<br>"
		cTexto   += "Motivo: "  
		cTexto   += cMotivo
		
		cAssunto := "Alteração de data OTD"
		cPara    := UsrRetMail(__cUserID) + ";denis.vieira@rdt.com.br"
		If date() <= StoD('20140320')
		   cPara += ";helio@opusvp.com.br"
		EndIf
		cCC      := ""
		cArquivo := ""
		
		U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
		
		MsgInfo("Alteração realizada com sucesso!")
		oDlg1:End()
	Else
		MsgStop("Não foi possível realizar a alteração.")
	EndIf
Else
	MsgStop("Favor preencher a nova data.")
EndIf

Return
