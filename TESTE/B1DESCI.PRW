//------------------------------------------------------------------------------------//
//Empresa...:  
//------------------------------------------------------------------------------------//
//Empresa...: 
//Funcao....: ANALISTA DE SISTEMAS
//Autor.....: MAURICIO LIMA DE SOUZA
//Data......: 
//Uso.......:
//Versao....:  
//------------------------------------------------------------------------------------//

#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"

#INCLUDE "MSOBJECT.CH"

*----------------------------------------------------------------------------------------
USER FUNCTION B1DESCI() //
*----------------------------------------------------------------------------------------
Local oFont1 	:= TFont():New("Arial Narrow",,022,,.F.,,,,,.F.,.F.)

Local 	_cPAR01 :=SPACE(LEN(SB1->B1_COD))
Local 	_cPAR02 :=space(080)

Local lImport	:= .F.
Local lLOOP    := .T.

Local oGet1
Local oGet2
Local oGet3
Local oGet4
Local oGet5


Local oSButton1
Local oSButton2

Static oDlgNFE   

PRIVATE cQUERY :='' 

PRIVATE ccadastro :='Limpeza campo Memo (Cadastro de Produto)'

DO WHILE lLOOP
	_cPAR01 :=SPACE(LEN(SB1->B1_COD))
	_cPAR02 :=space(080)
	
	
	DEFINE MSDIALOG oDlgNFE TITLE 'Limpeza campo Descricao (Cadastro de Produto)' FROM 000, 000  TO 280, 470 COLORS 0, 16777215 PIXEL
	
	@ 011, 010 SAY oSay1 PROMPT "Descricao(EIC)" 	SIZE 136, 014 OF oDlgNFE FONT oFont1 COLORS 16711680, 16777215 PIXEL
	@ 037, 010 SAY oSay2 PROMPT "Produto   :" 	    	SIZE 045, 007 OF oDlgNFE COLORS 0, 16777215 PIXEL
  	@ 050, 010 SAY oSay3 PROMPT "Descricao :" 		   SIZE 045, 007 OF oDlgNFE COLORS 0, 16777215 PIXEL
  
  	@ 063, 010 SAY oSay3 PROMPT "Campos: Descrição em Ingles" 	        SIZE 150, 007 OF oDlgNFE COLORS 0, 16777215 PIXEL
  	@ 076, 010 SAY oSay3 PROMPT "        Descrição da LI    " 		        SIZE 150, 007 OF oDlgNFE COLORS 0, 16777215 PIXEL
  	@ 089, 010 SAY oSay3 PROMPT "        Descrição Portugues" 		     SIZE 150, 007 OF oDlgNFE COLORS 0, 16777215 PIXEL

	@ 037, 050 MSGET oGet1 VAR _cPAR01 WHEN(.T.) F3 "SB1DES"   SIZE 120, 010 OF oDlgNFE COLORS 0, 16777215 PIXEL
  	@ 050, 050 MSGET oGet2 VAR _cPAR02 WHEN(.F.) SIZE 120, 010 OF oDlgNFE COLORS 0, 16777215 PIXEL
  //	@ 063, 050 MSGET oGet3 VAR _cPAR03 WHEN(.T.) F3 "SA2"   SIZE 050, 010 OF oDlgNFE COLORS 0, 16777215 PIXEL
  //	@ 076, 050 MSGET oGet4 VAR _cPAR04 WHEN(.T.) SIZE 030, 010 OF oDlgNFE COLORS 0, 16777215 PIXEL
  //	@ 089, 050 MSGET oGet5 VAR _cPAR05 WHEN(.T.) SIZE 150, 010 OF oDlgNFE COLORS 0, 16777215 PIXEL
	
	DEFINE SBUTTON oSButton1 FROM 110, 041 TYPE 01 OF oDlgNFE ENABLE Action (lImport :=.T., oDlgNFE:End() )
	DEFINE SBUTTON oSButton2 FROM 110, 077 TYPE 02 OF oDlgNFE ENABLE Action (lLOOP   :=.F., oDlgNFE:End() )//oDlgNFE:End()
	
	ACTIVATE MSDIALOG oDlgNFE CENTERED
	
	IF lImport ==.T. .and. !EMPTY(_cPAR01)
		lImport :=.F.
		cQUERY := "UPDATE SB1010 SET  B1_DESC_I='',B1_DESC_GI='',B1_DESC_P='' WHERE B1_COD='"+_cPAR01+"'  "     
		TCSQLEXEC(cQUERY)
		MSGALERT('Limpeza efetuada '+_cPAR01)
		else
			MSGALERT('Limpeza cancelada')
			lLOOP   :=.F.
	ENDIF
	
ENDDO

RETURN


