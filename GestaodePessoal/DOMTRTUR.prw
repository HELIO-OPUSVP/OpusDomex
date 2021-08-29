#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"

#INCLUDE "MSOBJECT.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DOMTRTUR  ºAutor  ³Jackson Santos      º Data ³  08/26/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Função para troca e turnos específico domex               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GPE                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMTRTUR()

Local oFont1 	:= TFont():New("Arial Narrow",,022,,.F.,,,,,.F.,.F.)

Local oSay1
Local oGet1
Local oSButton1

Private _dDataAtu :=DDATABASE
Private _dDataUsr :=DDATABASE


Static oDlgAJDT

PRIVATE ccadastro :='Trocar Data Base'

DEFINE MSDIALOG oDlgAJDT TITLE ccadastro FROM 000, 000  TO 280, 320 COLORS 0, 16777215 PIXEL		
		
	@ 040, 010 SAY oSay1 PROMPT "Data Base do Sistema"  SIZE 080, 020 OF oDlgAJDT COLORS 0, 16777215 PIXEL
	@ 065, 013 MSGET oGet1 VAR _dDataUsr     WHEN(.T.)  SIZE 080, 020 VALID(VldTrcData()) OF oDlgAJDT COLORS 0, 16777215 PIXEL		

  DEFINE SBUTTON oSButton1 FROM 100, 031 TYPE 01 OF oDlgAJDT ENABLE Action (DDATABASE :=_dDataUsr,oMainWnd:Refresh(),oDlgAJDT:End() )	   


ACTIVATE MSDIALOG oDlgAJDT CENTERED

PONA160()

//Volta a Data Base para a anterior
DDATABASE := _dDataAtu 
oMainWnd:Refresh()

RETURN

                                                                                         
Static Function VldTrcData()                                                                                         
Local lRet := .T.

If _dDataUsr > (_dDataAtu + 30 )
	MsgStop("Data informada maior que 30 dias da data base atual.","Erro Trocar data")
	lRet := .F.
ElseIf _dDataUsr < _dDataAtu
	MsgStop("Data informada menor que a data base atual.","Erro Trocar data")
	lRet := .F.
Else 
	lRet := .T.
EndIf

Return lRet


                                                                                         