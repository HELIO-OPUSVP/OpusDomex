#INCLUDE "TOPCONN.CH"
#INCLUDE "FIVEWIN.CH"
#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#Include "COLORS.CH"
#Include "FONT.CH"
#INCLUDE "MSOBJECT.CH

//------------------------------------------------------------------------------------//
//Empresa...:  DOMEX
//------------------------------------------------------------------------------------//
//Empresa...:
//Funcao....: ANALISTA DE SISTEMAS
//Autor.....: MAURICIO LIMA DE SOUZA
//Data......: 04/2019
//Uso.......:
//Versao....: 12.1.17
//------------------------------------------------------------------------------------//


*----------------------------------------------------------------------------------------
USER FUNCTION DOMTRPN() // TROCA PN NO PROCESSO DE IMPORTAÇÃO  (SIGAEIC)
*----------------------------------------------------------------------------------------
Local oFont1 	:= TFont():New("Arial Narrow",,022,,.F.,,,,,.F.,.F.)

Local 	_cPAR01 :=SPACE(LEN(SW5->W5_HAWB))
Local 	_cPAR02 :=SPACE(LEN(SB1->B1_COD))
Local 	_cPAR03 :=SPACE(LEN(SB1->B1_COD))
//Local 	_cPAR04 :=SPACE(LEN(SF1->F1_LOJA))
//Local 	_cPAR05 :=SPACE(LEN(SF1->F1_CHVNFE))

Local lImport	:= .F.
Local lLOOP     := .T.

Local oGet1
Local oGet2
Local oGet3
//Local oGet4
//Local oGet5

Local oSButton1
Local oSButton2

Static oDlgNFE

PRIVATE cCadastro :='Troca PN Processo em aberto (IMPORTACAO)'
PRIVATE _cPO_NUM := space(06)


DO WHILE lLOOP
	//_cPAR01 :=SPACE(LEN(SW5->W5_HAWB))
	//_cPAR02 :=SPACE(LEN(SB1->B1_COD))
	_cPAR03   :=SPACE(LEN(SB1->B1_COD))
	//	_cPAR04 :=SPACE(LEN(SF1->F1_LOJA))
	//	_cPAR05 :=SPACE(LEN(SF1->F1_CHVNFE))
	
	DEFINE MSDIALOG oDlgNFE TITLE cCadastro FROM 000, 000  TO 280, 470 COLORS 0, 16777215 PIXEL
	
	@ 011, 010 SAY oSay1 PROMPT "Troca PN" 	    SIZE 136, 014 OF oDlgNFE FONT oFont1 COLORS 16711680, 16777215 PIXEL
	@ 037, 010 SAY oSay2 PROMPT "Processo :" 	SIZE 045, 007 OF oDlgNFE COLORS 0, 16777215 PIXEL
	@ 050, 010 SAY oSay3 PROMPT "PN De    :"    SIZE 045, 007 OF oDlgNFE COLORS 0, 16777215 PIXEL
	@ 063, 010 SAY oSay4 PROMPT "PN Para  :"    SIZE 045, 007 OF oDlgNFE COLORS 0, 16777215 PIXEL
	//@ 076, 010 SAY oSay3 PROMPT "" 		    SIZE 045, 007 OF oDlgNFE COLORS 0, 16777215 PIXEL
	//@ 089, 010 SAY oSay3 PROMPT "" 		    SIZE 045, 007 OF oDlgNFE COLORS 0, 16777215 PIXEL
	
	@ 037,   050 MSGET oGet1 VAR _cPAR01 WHEN(.T.) F3 "SW5TPN" SIZE 100, 010 OF oDlgNFE COLORS 0, 16777215 PIXEL
	@ 050,   050 MSGET oGet2 VAR _cPAR02 WHEN(.F.)             SIZE 100, 010 OF oDlgNFE COLORS 0, 16777215 PIXEL
	@ 063,   050 MSGET oGet3 VAR _cPAR03 WHEN(.T.) F3 "SB1"    SIZE 100, 010 OF oDlgNFE COLORS 0, 16777215 PIXEL
	//@ 076, 050 MSGET oGet4 VAR _cPAR04 WHEN(.T.) SIZE 030, 010 OF oDlgNFE COLORS 0, 16777215 PIXEL
	//@ 089, 050 MSGET oGet5 VAR _cPAR05 WHEN(.T.) SIZE 150, 010 OF oDlgNFE COLORS 0, 16777215 PIXEL
	
	DEFINE SBUTTON oSButton1 FROM 110, 041 TYPE 01 OF oDlgNFE ENABLE Action (lImport :=.T., oDlgNFE:End() )
	DEFINE SBUTTON oSButton2 FROM 110, 077 TYPE 02 OF oDlgNFE ENABLE Action (lLOOP   :=.F., oDlgNFE:End() )//oDlgNFE:End()
	
	ACTIVATE MSDIALOG oDlgNFE CENTERED
	
	IF lImport ==.T.
		IF EMPTY(_cPAR01)
			MSGALERT('Numero do processo em branco')
		ENDIF
		DO CASE
			CASE  EMPTY(_cPAR01)
				MSGALERT('Numero do processo em branco')
			CASE  EMPTY(_cPAR02)
				MSGALERT('Campo : "PN de" em branco')
			CASE  EMPTY(_cPAR03)
				MSGALERT('Campo : "PN para" em branco')
			OTHERWISE
				DOMTRPN1(_cPAR01,_cPAR02,_cPAR03)
		ENDCASE
		lImport :=.F.
	ELSE
		MSGALERT('Sair')
	ENDIF
	
ENDDO

RETURN


STATIC FUNCTION DOMTRPN1(_cPAR01,_cPAR02,_cPAR03)


_cDescde := ALLTRIM(POSICIONE('SB1',1,xFILIAL('SB1')+_cPAR02,'B1_DESC'))
_cDescPa := ALLTRIM(POSICIONE('SB1',1,xFILIAL('SB1')+_cPAR03,'B1_DESC')) 
_cPO_NUM := space(06)

IF MSGYESNO('Alterar Processo:'+alltrim(_cPAR01)+Chr(13)+'PN de   :'+alltrim(_cPAR02)+' '+_cDescde+Chr(13)+'PN Para :'+alltrim(_cPAR03)+' '+_cDescPA)
	
	//SW5 - Itens Preparação Licença Imp
	MsAguarde( { || DOMTRPN2(_cPAR01,_cPAR02,_cPAR03) } , "01/07 SW5 - Itens Preparação Licença Imp..." )
	//--SW7 - Itens Declaração de Importação
	MsAguarde( { || DOMTRPN3(_cPAR01,_cPAR02,_cPAR03) } , "02/07 SW7 - Itens Declaração de Importação..." )
	//--SW8 - Itens de Invoices
	MsAguarde( { || DOMTRPN4(_cPAR01,_cPAR02,_cPAR03) } , "03/07 SW8 - Itens de Invoices..." )
	//--SW3 - Itens de Purchase Order
	MsAguarde( { || DOMTRPN5(_cPAR01,_cPAR02,_cPAR03) } , "04/07 SW3 - Itens de Purchase Order..." )
	//--SW1 - Itens Solicitação Importação
	MsAguarde( { || DOMTRPN6(_cPAR01,_cPAR02,_cPAR03) } , "05/07 SW1 - Itens Solicitação Importação..." )
	//--SC7 - PEDIDO DE COMPRA
	MsAguarde( { || DOMTRPN7(_cPAR01,_cPAR02,_cPAR03) } , "06/07 SC7 - PEDIDO DE COMPRA..." )
	//--SC1 - SOLICITACAO DE COMPRA
	MsAguarde( { || DOMTRPN8(_cPAR01,_cPAR02,_cPAR03) } , "07/07 SC1 - SOLICITACAO DE COMPRA..." )
	
	MSGALERT('Fim processamento')
ELSE
	MSGALERT('Alteração cancelada')
ENDIF

RETURN


STATIC FUNCTION DOMTRPN2(_cPAR01,_cPAR02,_cPAR03) //SW5 - Itens Preparação Licença Imp
Sleep( 2000 )   // Parar o processamento por 2 segundo
cQRY:="UPDATE SW5010 SET W5_COD_I='"+_cPAR03+"'  WHERE W5_HAWB='"+_cPAR01+"' AND D_E_L_E_T_='' AND W5_COD_I='"+_cPAR02+"' "
TCSQLEXEC(cQRY)
U_DOMTREML("01/07 SW5 - Itens Preparacao Licenca Imp",_cPAR01,_cPAR02,_cPAR03)

RETURN

STATIC FUNCTION DOMTRPN3(_cPAR01,_cPAR02,_cPAR03)//--SW7 - Itens Declaração de Importação
Sleep( 2000 )

cQRY:="UPDATE SW7010 SET W7_COD_I='"+_cPAR03+"'  WHERE W7_HAWB='"+_cPAR01+"' AND D_E_L_E_T_='' AND W7_COD_I='"+_cPAR02+"' "
TCSQLEXEC(cQRY)
U_DOMTREML("02/07 SW7 - Itens Declaracao de Importacao",_cPAR01,_cPAR02,_cPAR03)
RETURN

STATIC FUNCTION DOMTRPN4(_cPAR01,_cPAR02,_cPAR03)//--SW8 - Itens de Invoices
Sleep( 2000 )
cQRY:="UPDATE SW8010 SET W8_COD_I='"+_cPAR03+"'  WHERE W8_HAWB='"+_cPAR01+"' AND D_E_L_E_T_='' AND W8_COD_I='"+_cPAR02+"' "
TCSQLEXEC(cQRY)
U_DOMTREML("03/07 SW8 - Itens de Invoices",_cPAR01,_cPAR02,_cPAR03)
RETURN

STATIC FUNCTION DOMTRPN5(_cPAR01,_cPAR02,_cPAR03)//--SW3 - Itens de Purchase Order
Sleep( 2000 )
_cPO_NUM :=SPACE(06)
_cPO_SIGA:="'"
SW5->(DBSETORDER(2))
IF SW5->(DBSEEK(xFILIAL('SW5')+_cPAR01))
	_cPO_NUM := SW5->W5_PO_NUM
ENDIF
cQRY:="UPDATE SW3010 SET W3_COD_I='"+_cPAR03+"'  "
cQRY+="  WHERE D_E_L_E_T_='' AND W3_CODCOD_I='"+_cPAR02+"' AND W3_PO_NUM IN ( "
cQRY+=" (SELECT W2_PO_NUM  FROM SW2010 WHERE D_E_L_E_T_='' AND W2_PO_SIGA IN  "
cQRY+=" (SELECT W2_PO_SIGA FROM SW2010 WHERE D_E_L_E_T_='' AND W2_PO_NUM='"+_cPO_NUM+"'))) "
TCSQLEXEC(cQRY) 

cQRY:="UPDATE SW3010 SET W3_COD_I='"+_cPAR03+"'  "
cQRY+="  WHERE D_E_L_E_T_='' AND W3_COD_I='"+_cPAR02+"' AND W3_PO_NUM ='"+_cPO_NUM+"' "
TCSQLEXEC(cQRY) 

U_DOMTREML("04/07 SW3 - Itens de Purchase Order",_cPAR01,_cPAR02,_cPAR03)
RETURN

STATIC FUNCTION DOMTRPN6(_cPAR01,_cPAR02,_cPAR03)//--SW1 - Itens Solicitação Importação
Sleep( 2000 )
cQRY:="UPDATE SW1010 SET W1_COD_I='"+_cPAR03+"'  "
cQRY+="  WHERE D_E_L_E_T_='' AND W1_COD_I='"+_cPAR02+"' AND W1_PO_NUM IN ( "
cQRY+=" (SELECT W2_PO_NUM  FROM SW2010 WHERE D_E_L_E_T_='' AND W2_PO_SIGA IN  "
cQRY+=" (SELECT W2_PO_SIGA FROM SW2010 WHERE D_E_L_E_T_='' AND W2_PO_NUM='"+_cPO_NUM+"'))) "
TCSQLEXEC(cQRY)
U_DOMTREML("05/07 SW1 - Itens Solicitacao Importacao",_cPAR01,_cPAR02,_cPAR03)

cQRY:="UPDATE SW1010 SET W1_COD_I='"+_cPAR03+"'  "
cQRY+="  WHERE D_E_L_E_T_='' AND W1_COD_I='"+_cPAR02+"' AND W1_PO_NUM ='"+_cPO_NUM+"' "
TCSQLEXEC(cQRY) 

RETURN

STATIC FUNCTION DOMTRPN7(_cPAR01,_cPAR02,_cPAR03)//--SC7 - PEDIDO DE COMPRA
Sleep( 2000 )
cQRY:=" UPDATE SC7010 SET C7_PRODUTO='"+_cPAR03+"' ,C7_PO_EIC='"+_cPO_NUM+"'  "
cQRY+=" WHERE C7_NUM=(SELECT W2_PO_SIGA  FROM SW2010 WHERE W2_PO_NUM='"+_cPO_NUM+"' AND D_E_L_E_T_='' )  "
cQRY+=" AND C7_PRODUTO='"+_cPAR02+"'  AND D_E_L_E_T_='' "
TCSQLEXEC(cQRY) 

cQRY:=" UPDATE SC7010 SET C7_PRODUTO='"+_cPAR03+"' " // ,C7_PO_EIC='"+_cPO_NUM+"'  " 
cQRY+=" WHERE C7_NUMSC IN "
cQRY+=" (SELECT W0_C1_NUM FROM SW0010 WHERE  D_E_L_E_T_='' AND W0__NUM IN "
cQRY+=" (SELECT W5_SI_NUM FROM SW5010 WHERE W5_HAWB LIKE('"+SUBSTR(_cPAR01,1,8)+"%') AND D_E_L_E_T_=''  "
cQRY+=" AND W5_COD_I IN ('"+_cPAR03+"','"+_cPAR02+"' ))) "
cQRY+=" AND D_E_L_E_T_='' "
TCSQLEXEC(cQRY) 

/*
SW2->(DBSETORDER(1))//W2_FILIAL + W2_PO_NUM
_cPO_SIGA:=SPACE(06)
IF SW2->(DBSEEK(xFILIAL('SW2')+_cPO_NUM))
	//_cPO_SIGA:=_cPO_SIGA+SW2->W2_PO_SIGA+"','"
	_cPO_SIGA:=SW2->W2_PO_SIGA
ENDIF
cQRY:="UPDATE SC7010 SET C7_PRODUTO='"+_cPAR03+"'  "
cQRY+=" WHERE D_E_L_E_T_='' AND C7_NUM='"+_cPO_SIGA+"' AND C7_PRODUTO='"+_cPAR02+"'  "
cQRY+=" AND C7_PO_EIC IN ( "
cQRY+=" (SELECT W2_PO_NUM  FROM SW2010 WHERE D_E_L_E_T_='' AND W2_PO_SIGA IN  "
cQRY+=" (SELECT W2_PO_SIGA FROM SW2010 WHERE D_E_L_E_T_='' AND W2_PO_NUM='"+_cPO_NUM+"'))) "
TCSQLEXEC(cQRY)
*/

U_DOMTREML("06/07 SC7 - PEDIDO DE COMPRA",_cPAR01,_cPAR02,_cPAR03)
RETURN

STATIC FUNCTION DOMTRPN8(_cPAR01,_cPAR02,_cPAR03)//--SC1 - SOLICITACAO DE COMPRA
Sleep( 2000 )
U_DOMTREML("07/07 SC1 - SOLICITACAO DE COMPRA",_cPAR01,_cPAR02,_cPAR03)
RETURN
/*
SELECT C7_PO_EIC,C7_NUMSC,* FROM SC7010 WHERE C7_NUM='014276' AND C7_PRODUTO='20D64S101C08N1'---SC RDJCEU
UPDATE SC1010 SET C1_PRODUTO='20D64S101C08N1'  WHERE C1_NUM='RDJCEU' AND C1_PRODUTO='20464S101C08N1' AND D_E_L_E_T_=''
*/

USER FUNCTION DOMTREML(_cTEXTO,_cPAR01,_cPAR02,_cPAR03)   //TEXTO PROCESSO   DE   PARA
Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

_cData     := DtoC(Date())
_cAssunto  := "Troca PN  Processo "+_cPAR01 +" de "+_cPAR02+" Para"+_cPAR03+" "+_cTEXTO+"  - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
_cTexto    := "Troca PN  Processo "+_cPAR01 +Chr(13)+" de "+_cPAR02+Chr(13)+" Para"+_cPAR03+" "+Chr(13)+_cTEXTO+"  - Data " + _cData + "    " +Time()+Chr(13)+ " User: " + Subs(cUsuario,7,14) +Chr(13)
_cTexto    += "Emissao : "+dtoc(Date()) + cEOL

_cPara  := 'adriana.ottoboni@rosenbergerdomex.com.br, '
//_cPara  += 'patricia.vieira@rdt.com.br, '
//_cPara  += 'tatiane.vieira@rosenbergerdomex.com.br, '
_cPara  += 'lucio.cravo@rosenbergerdomex.com.br, '
//_cPara  += 'denis.vieira@rosenbergerdomex.com.br,mauricio.souza@opusvp.com.br '
_cPara    += 'mauricio.souza@opusvp.com.br,denis.vieira@rosenbergerdomex.com.br '
_cCC      := ""
_cArquivo := ""

U_EnvMailto(_cAssunto,_cTexto,_cPara,_cCC,_cArquivo)
Return


/*
--SW5 - Itens Preparação Licença Imp
--SW7 - Itens Declaração de Importação
--SW8 - Itens de Invoices
--SW3 - Itens de Purchase Order
--SW1 - Itens Solicitação Importação
--SC7 - PEDIDO DE COMPRA
--SC1 - SOLICITACAO DE COMPRA

--SW3 - Itens de Purchase Order
SELECT W2_PO_SIGA,W2_PO_NUM,* FROM SW2010 WHERE W2_PO_NUM='DA1805204981/01'-- W2_PO_SIGA 014276  -- IMP 3500/18
SELECT W2_PO_SIGA,W2_PO_NUM,* FROM SW2010 WHERE  W2_PO_SIGA='014276'  -- IMP 3500/18      DA1805204981/01    I0008001    <------------------w2_po_siga w2_po_num
SELECT * FROM SW3010 WHERE  W3_SI_NUM='SIAEMD'
SELECT W3_PO_NUM,* FROM SW3010 WHERE W3_PO_NUM IN ('DA1805204981/01','I0008001') AND D_E_L_E_T_='' AND W3_COD_I='20D64S101C08N1' --SIAEMD SIADTN
UPDATE SW3010 SET W3_COD_I='20D64S101C08N1'   WHERE W3_PO_NUM IN ('DA1805204981/01','I0008001')    AND W3_COD_I='20464S101C08N1' AND D_E_L_E_T_=''

--SW1 - Itens Solicitação Importação
SELECT * FROM SW1010  WHERE W1_PO_NUM IN ('DA1805204981/01','I0008001') AND W1_COD_I='20D64S101C08N1' -- W1_SI_NUM= SIADTN SIAEMD
UPDATE SW1010 SET W1_COD_I='20D64S101C08N1' WHERE  W1_PO_NUM IN ('DA1805204981/01','I0008001') AND W1_COD_I='20464S101C08N1'  AND D_E_L_E_T_=''
-- ALTERAR SW1 PELO NUMERO DA SI:
UPDATE SW1010 SET W1_COD_I='20D60S238C08N1P' WHERE W1_SI_NUM='SIAFOE' AND D_E_L_E_T_='' AND W1_PO_NUM='DA1806855153/01' AND W1_COD_I='20460S238C08N1P'  AND D_E_L_E_T_=''

--SC7 - PEDIDO DE COMPRA
--SC1 - SOLICITACAO DE COMPRA

--W2_PO_SIGA 014276
--W1_SI_NUM= SIADTN SIAEMD
SELECT C7_PO_EIC,C7_NUMSC,* FROM SC7010 WHERE C7_NUM='014276' AND C7_PRODUTO='20D64S101C08N1'---SC RDJCEU
SELECT * FROM SC1010 WHERE C1_NUM='RDJCEU' AND C1_PRODUTO='20464S101C08N1'
UPDATE SC1010 SET C1_PRODUTO='20D64S101C08N1'  WHERE C1_NUM='RDJCEU' AND C1_PRODUTO='20464S101C08N1' AND D_E_L_E_T_=''
UPDATE SC7010 SET C7_PRODUTO='20D64S101C08N1'  WHERE C7_NUM='014276' AND C7_PRODUTO='20464S101C08N1' AND  C7_PO_EIC IN ('DA1805204981/01','I0008001') AND D_E_L_E_T_=''


SW2->(DBSETORDER(1))//W2_FILIAL + W2_PO_NUM
IF SW2->(DBSEEK(xFILIAL('SW2')+_cPO_NUM))
_cPO_SIGA:=_cPO_SIGA+SW2->W2_PO_SIGA+"','"
ENDIF
