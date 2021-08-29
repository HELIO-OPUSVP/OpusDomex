#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"

#INCLUDE "MSOBJECT.CH"

//----------------------------------------------------------------------------------------------------
// Ponto de entrada para tratamento de Taxa da moeda no recebimento de importação
// EICDI154 EXP1:=PARAMIXB  = DI154TAXAS
// Mauricio Lima de Souza - OpusVP
//----------------------------------------------------------------------------------------------------

User Function EICDI154()

Local oFont1 	:= TFont():New("Arial Narrow",,022,,.F.,,,,,.F.,.F.)

Local _nPAR02 :=SW9->W9_TX_FOB
Local _cPAR02 :=' '

Local lImport  := .F.
Local lLOOP    := .T.

Local oGet1
Local oGet2

Local oSButton1
Local oSButton2

Static oDlgAJTXE

PRIVATE ccadastro :='Taxa Moeda'

EXP1:=PARAMIXB
/*  retirado taxa moeda fob novo rpo  // tualização 03/2015 mauricio
IF EXP1=='DI154TAXAS' .and. cTipTx == "FOB"
	
	_nPAR02 :=SW9->W9_TX_FOB
	
	DEFINE MSDIALOG oDlgAJTXE TITLE 'Taxa moeda FOB' FROM 000, 000  TO 280, 470 COLORS 0, 16777215 PIXEL
	
	@ 011, 010 SAY oSay1 PROMPT "Ajusta Taxa Moeda FOB "     SIZE 336, 024 OF oDlgAJTXE FONT oFont1 COLORS 16711680, 16777215 PIXEL
	@ 050, 010 SAY oSay3 PROMPT "Taxa Moeda   :" 		      SIZE 045, 007 OF oDlgAJTXE COLORS 0, 16777215 PIXEL
	@ 050, 050 MSGET oGet2 VAR _nPAR02 WHEN(.T.) PICTURE (PesqPict("SW9","W9_TX_FOB")) SIZE 050, 010 OF oDlgAJTXE COLORS 0, 16777215 PIXEL
	
	DEFINE SBUTTON oSButton1 FROM 110, 041 TYPE 01 OF oDlgAJTXE ENABLE Action (lImport :=.T., oDlgAJTXE:End() )
	DEFINE SBUTTON oSButton2 FROM 110, 077 TYPE 02 OF oDlgAJTXE ENABLE Action (lLOOP   :=.F., oDlgAJTXE:End() )
	
	ACTIVATE MSDIALOG oDlgAJTXE CENTERED
	
	IF lImport ==.T.
		lImport :=.F.
		
		NTAXA:=_nPAR02
	ENDIF
	
	NTAXA:=_nPAR02
	
ENDIF
*/

//IF(EXISTBLOCK("EICDI154"),EXECBLOCK("EICDI154",.F.,.F.,"ANTES_GRAVA_SWN"),) //JWJ - 24/10/2005
//IF(ExistBlock("EICDI154"),Execblock("EICDI154",.F.,.F.,'GRAVA_WN'),)
//IF(ExistBlock("EICDI154"),Execblock("EICDI154",.F.,.F.,'DEPOIS_ITEM_ALTERA'),)

//Work1->WKBASEICMS
//Work1->WKICMS_A
//Work1->WKVL_ICM
IF EXP1=='DEPOIS_ITEM_ALTERA'
	_nPAR02:=Work1->WKBASEICMS
	_nPAR03:=Work1->WKICMS_A
	_nPAR04:=Work1->WKVL_ICM
	
	_nVALICMS :=Work1->WKBASEICMS*(Work1->WKICMS_A/100)
	_NDIF:=_nPAR04-_nVALICMS
	
	IF _NDIF>0.01  .OR.  _NDIF<-0.01  //_nVALICMS<>_nPAR04
		
		DEFINE MSDIALOG oDlg2 TITLE 'ICMS ITEM' FROM 000, 000  TO 280, 470 COLORS 0, 16777215 PIXEL
		
		@ 011, 010 SAY oSay1 PROMPT "ICMS ITEM"         SIZE 045, 024 OF oDlg2 FONT oFont1 COLORS 16711680, 16777215 PIXEL
		@ 040, 010 SAY oSay2 PROMPT "Base de Calculo "  SIZE 045, 007 OF oDlg2 COLORS 0, 16777215 PIXEL
		@ 055, 010 SAY oSay3 PROMPT "Aliquota        "  SIZE 045, 007 OF oDlg2 COLORS 0, 16777215 PIXEL
		@ 070, 010 SAY oSay4 PROMPT "Valor Informado "  SIZE 145, 007 OF oDlg2 COLORS 0, 16777215 PIXEL
		@ 085, 010 SAY oSay5 PROMPT "Valor Calculado "  SIZE 145, 007 OF oDlg2 COLORS 0, 16777215 PIXEL
		@ 040, 080 MSGET oGet2 VAR _nPAR02   WHEN(.F.) PICTURE (PesqPict("SD1","D1_VALICM")) SIZE 050, 010 OF oDlg2 COLORS 0, 16777215 PIXEL
		@ 055, 080 MSGET oGet3 VAR _nPAR03   WHEN(.F.) PICTURE (PesqPict("SD1","D1_VALICM")) SIZE 050, 010 OF oDlg2 COLORS 0, 16777215 PIXEL
		@ 070, 080 MSGET oGet4 VAR _nPAR04   WHEN(.F.) PICTURE (PesqPict("SD1","D1_VALICM")) SIZE 050, 010 OF oDlg2 COLORS 0, 16777215 PIXEL
		@ 085, 080 MSGET oGet5 VAR _nVALICMS WHEN(.F.) PICTURE (PesqPict("SD1","D1_VALICM")) SIZE 050, 010 OF oDlg2 COLORS 0, 16777215 PIXEL
		@ 085, 140 MSGET oGet5 VAR _NDIF     WHEN(.F.) PICTURE (PesqPict("SD1","D1_VALICM")) SIZE 050, 010 OF oDlg2 COLORS 0, 16777215 PIXEL		
		
	  //	DEFINE SBUTTON oSButton1 FROM 110, 041 TYPE 01 OF oDlg2 ENABLE Action (lImport :=.T., oDlg2:End() )
	  //  DEFINE SBUTTON oSButton2 FROM 110, 077 TYPE 02 OF oDlg2 ENABLE Action (lLOOP   :=.F., oDlg2:End() )
	      DEFINE SBUTTON oSButton1 FROM 110, 041 TYPE 01 OF oDlg2 ENABLE Action (lImport :=.T., oDlg2:End() )	   
		
		ACTIVATE MSDIALOG oDlg2 CENTERED
	ENDIF
	
ENDIF


RETURN

