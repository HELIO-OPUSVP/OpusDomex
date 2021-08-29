//------------------------------------------------------------------------------------//
//Empresa...:  OPUS
//------------------------------------------------------------------------------------//
//Empresa...:
//Funcao....: ANALISTA DE SISTEMAS
//Autor.....: MAURICIO LIMA DE SOUZA
//Data......: 01/2015
//Uso.......:
//Versao....: 11
//------------------------------------------------------------------------------------//

#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"

#INCLUDE "MSOBJECT.CH"

*----------------------------------------------------------------------------------------
USER FUNCTION DOMFCI() // AJUSTA GERAÇÃO FCI
*----------------------------------------------------------------------------------------
Local oFont1 	:= TFont():New("Arial Narrow",,022,,.F.,,,,,.F.,.F.)

Local lLOOP     := .T.

Local oSButton1
Local oSButton2

Local cQUERY  := " "

Static oDlgFCI

PRIVATE ccadastro :='Limpeza Geração FCI'
PRIVATE lImport   :=.F.


DEFINE MSDIALOG oDlgFCI TITLE "Limpeza Tabela FCI"    FROM 000, 000  TO 280, 470 COLORS 0, 16777215 PIXEL

@ 011, 010 SAY oSay1 PROMPT "Limpeza Tabela FCI     "  SIZE 140, 014 OF oDlgFCI FONT oFont1 COLORS 16711680, 16777215 PIXEL
@ 037, 010 SAY oSay2 PROMPT "Produtos iniciado por :"  SIZE 140, 007 OF oDlgFCI COLORS 0, 16777215 PIXEL
@ 050, 010 SAY oSay3 PROMPT "1P4 164 1H7 DMX'       "  SIZE 140, 007 OF oDlgFCI COLORS 0, 16777215 PIXEL
@ 063, 010 SAY oSay3 PROMPT "                       "  SIZE 140, 007 OF oDlgFCI COLORS 0, 16777215 PIXEL
@ 076, 010 SAY oSay3 PROMPT "produto incentivado    "	 SIZE 140, 007 OF oDlgFCI COLORS 0, 16777215 PIXEL
@ 089, 010 SAY oSay3 PROMPT "B1_XXPROIN='S'         "  SIZE 140, 007 OF oDlgFCI COLORS 0, 16777215 PIXEL

DEFINE SBUTTON oSButton1 FROM 110, 041 TYPE 01 OF oDlgFCI ENABLE Action (lImport :=.T., oDlgFCI:End() )
DEFINE SBUTTON oSButton2 FROM 110, 077 TYPE 02 OF oDlgFCI ENABLE Action (lImport :=.F., oDlgFCI:End() )

ACTIVATE MSDIALOG oDlgFCI CENTERED

IF lImport ==.T.
	lImport :=.F.
	cQUERY  += " UPDATE CFD010 SET D_E_L_E_T_='*', R_E_C_D_E_L_=R_E_C_N_O_ "
	cQUERY  += " WHERE CFD_COD IN "
	cQUERY  += " (SELECT CFD_COD  "
	cQUERY  += " FROM CFD010 CFD, SB1010 SB1 "
	cQUERY  += " WHERE  "
	cQUERY  += "  SB1.B1_COD=CFD.CFD_COD "
	cQUERY  += " AND SUBSTRING(CFD.CFD_COD,1,3) IN ('1P4','164','1H7','DMX') "
	cQUERY  += " AND CFD.D_E_L_E_T_<>'*'  "
	cQUERY  += " AND SB1.D_E_L_E_T_<>'*'  "
	cQUERY  += " AND SB1.B1_XXPROIN='S'  "
	cQUERY  += " ) "
	TCSQLEXEC(cQUERY)
	
	MSGALERT('Fim de processamento')
ELSE
	MSGALERT('Processamento cancelado')
ENDIF


Return
