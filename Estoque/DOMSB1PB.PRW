//------------------------------------------------------------------------------------//
//Empresa...:  DOMEX
//------------------------------------------------------------------------------------//
//Empresa...: 
//Funcao....: ANALISTA DE SISTEMAS
//Autor.....: MAURICIO LIMA DE SOUZA
//Data......: 11/2014
//Uso.......:
//Versao....: 11.8
//------------------------------------------------------------------------------------//

#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"

#INCLUDE "MSOBJECT.CH"

*----------------------------------------------------------------------------------------
USER FUNCTION DOMSB1PB(cPar01) // ALTERA PESO BRUTO DO CADASTRO
*----------------------------------------------------------------------------------------
Local oFont1     := TFont():New("Arial Narrow",,022,,.F.,,,,,.F.,.F.)

Default cPar01   := SPACE(LEN(SB1->B1_COD))

Private	_cPAR01 := SPACE(LEN(SB1->B1_COD))
PRIVATE	_cPAR02 :=0
PRIVATE	_cPAR03 :=0
PRIVATE	_cPAR04 :=SPACE(LEN(SB1->B1_DESC))
PRIVATE	_cPAR05 :=0

PRIVATE lImport	:= .F.
PRIVATE lLOOP     := .T.

PRIVATE oGet1
PRIVATE oGet2
PRIVATE oGet3
PRIVATE oGet4
PRIVATE oGet5

PRIVATE oSButton1
PRIVATE oSButton2

PRIVATE oDlgPesoB

PRIVATE ccadastro :='Calculo Peso Bruto (SB1)'

DO WHILE lLOOP
   If !Empty(cPar01)
	   _cPAR01 := cPar01
	Else
	   _cPAR01 :=SPACE(LEN(SB1->B1_COD))
	EndIf
	_cPAR02 :=0
	_cPAR03 :=0
	_cPAR04 :=SPACE(LEN(SB1->B1_DESC))
	_cPAR05 :=0
	
	
	DEFINE MSDIALOG oDlgPesoB TITLE 'Calculo Peso Bruto (SB1)' FROM 000, 000  TO 280, 470 COLORS 0, 16777215 PIXEL
	
	@ 011, 010 SAY oSay1 PROMPT "Alterar Peso Bruto  " 	SIZE 136, 014 OF oDlgPesoB FONT oFont1 COLORS 16711680, 16777215 PIXEL
	@ 037, 010 SAY oSay2 PROMPT "Produto    :" 		SIZE 045, 007 OF oDlgPesoB COLORS 0, 16777215 PIXEL
	@ 050, 010 SAY oSay3 PROMPT "Quantidade :" 	   SIZE 045, 007 OF oDlgPesoB COLORS 0, 16777215 PIXEL
	@ 063, 010 SAY oSay3 PROMPT "Peso Bruto:"       SIZE 045, 007 OF oDlgPesoB COLORS 0, 16777215 PIXEL
//	@ 076, 010 SAY oSay3 PROMPT "Loja :" 		      SIZE 045, 007 OF oDlgPesoB COLORS 0, 16777215 PIXEL
//	@ 089, 010 SAY oSay3 PROMPT "Chave NFe :"       SIZE 045, 007 OF oDlgPesoB COLORS 0, 16777215 PIXEL

	@ 037, 050 MSGET oGet1 VAR _cPAR01 WHEN(.T.)  F3 "SB1"      VALID(VLDPROD(_cPAR01)) SIZE 070, 010 OF oDlgPesoB COLORS 0, 16777215 PIXEL
	@ 050, 050 MSGET oGet2 VAR _cPAR02 WHEN(.T.)  PICTURE "@E 999,999,999.9999"  SIZE 050, 010 OF oDlgPesoB COLORS 0, 16777215 PIXEL
	@ 063, 050 MSGET oGet3 VAR _cPAR03 WHEN(.T.)  PICTURE "@E 999,999,999.9999" SIZE 050, 010 VALID(VLDPESO(_cPAR02,_cPAR03))OF oDlgPesoB COLORS 0, 16777215 PIXEL

	@ 037, 120 MSGET oGet4 VAR _cPAR04 WHEN(.F.) SIZE 100, 010 OF oDlgPesoB COLORS 0, 16777215 PIXEL
	@ 063, 120 MSGET oGet5 VAR _cPAR05 WHEN(.F.)  PICTURE "@E 999,999,999.9999" SIZE 050, 010 OF oDlgPesoB COLORS 0, 16777215 PIXEL
	
	DEFINE SBUTTON oSButton1 FROM 110, 041 TYPE 01 OF oDlgPesoB ENABLE Action (lImport :=.T., oDlgPesoB:End() )
	DEFINE SBUTTON oSButton2 FROM 110, 077 TYPE 02 OF oDlgPesoB ENABLE Action (lLOOP   :=.F., oDlgPesoB:End() )//oDlgPesoB:End()
	
	ACTIVATE MSDIALOG oDlgPesoB CENTERED
	
	IF lImport ==.T.
		lImport :=.F.
		SB1->(DBSELECTAREA('SB1'))
		SB1->(DBSETORDER(1))
		SB1->(DBSEEK(xFILIAL('SB1')+_cPAR01))
		IF SB1->(FOUND())
			SB1->(RECLOCK("SB1",.F.))
			SB1->B1_PESBRU    :=  _cPAR05
			SB1->(MSUNLOCK())
			MSGALERT('Peso Bruto Alterado')
		ELSE
			MSGALERT('Produto não encontrado')
		ENDIF
	ENDIF
	
	If !Empty(cPar01)
	   Exit
	EndIf
ENDDO

Return

STATIC FUNCTION VLDPROD(cPAR01)
_cPAR04 := POSICIONE ('SB1',1,xFILIAL('SB1')+cPAR01,'B1_DESC')
_cPAR05 := POSICIONE ('SB1',1,xFILIAL('SB1')+cPAR01,'B1_PESBRU')
oGet4:REFRESH()
oGet5:REFRESH()
RETURN

STATIC FUNCTION VLDPESO(cPAR02,cPAR03)
_cPAR05 :=cPAR03/cPAR02
oGet5:REFRESH()
RETURN