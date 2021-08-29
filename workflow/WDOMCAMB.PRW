//------------------------------------------------------------------------------------//
//Empresa...:
//Funcao....:
//Autor.....: MAURICIO LIMA DE SOUZA
//Data......: 09/2013
//Uso.......:
//Versao....: 8.11
//------------------------------------------------------------------------------------//

#INCLUDE "PROTHEUS.ch"
#include "ap5mail.ch"
#INCLUDE "TOPCONN.CH"
#Include "TbiConn.ch"
#INCLUDE "RWMAKE.ch"

*-----------------------------------------------------------------------------------------
USER FUNCTION WDOMCAMB() // WORKFLOW CONTROLE DE CAMBIO
*-----------------------------------------------------------------------------------------

RPCSetType(3)  // Nao utilizar licensa

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" TABLES  "SW9" , "SY6" , "SE2" , "SWB"

SetUserDefault("000000")

SW9->( dbSetOrder(1) )
SY6->( dbSetOrder(1) )
SWB->( dbSetOrder(1) )
SE2->( dbSetOrder(1) )
SX5->( dbSetOrder(1) )

PRIVATE cQuery0   :=""
PRIVATE cQuery    :=""
PRIVATE cQuery2   :=""
PRIVATE cEMAILTO  :=""
PRIVATE cEMAILCC  :=""
PRIVATE _cEMAILTO :=""
PRIVATE lSend     :=.F.
PRIVATE nITENS    :=0
PRIVATE _cDINI    :=DATE()

ConOut( 'Job INVOICE X CAMBIO iniciado.' )

_cDINI := dtos(dDatabase-(365*2))
_cDINI := '20190101'

U_WCANBATU(_cDINI)

*----------------------------------------------------------------------------------------------------------------------------------------------------
cQuery0 :=" DROP TABLE INVCANFIN "
*----------------------------------------------------------------------------------------------------------------------------------------------------

cQuery1 :=" SELECT  W9_COND_PA,Y6_TIPOCOB,  "
cQuery1 +=" W9_INVOICE,W9_HAWB,W9_DT_EMIS,W9_NOM_FOR,W9_MOE_FOB,W9_FOB_TOT,  "
cQuery1 +=" ISNULL((SELECT  TOP 1 WB_NUMDUP+'/'+WB_PREFIXO+'/'+WB_PARCELA+'/'+WB_TIPOTIT            FROM SWB010 WITH(NOLOCK)  "
cQuery1 +=" WHERE WB_FILIAL='"+xFILIAL('SWB')+"' AND D_E_L_E_T_='' AND WB_INVOICE+WB_HAWB=W9_INVOICE+W9_HAWB   AND   WB_FORN+WB_LOJA=W9_FORN+W9_FORLOJ),'')   AS CAMBIO_DUPL_PREF_PARC_TIPO, "
cQuery1 +=" ISNULL((SELECT  TOP 1 E2_NUM+'/'+E2_PREFIXO+'/'+E2_PARCELA+'/'+E2_TIPO +STR(E2_SALDO)   FROM SWB010 WITH(NOLOCK) ,SE2010 WITH(NOLOCK)  "
cQuery1 +=" WHERE WB_FILIAL='"+xFILIAL('SWB')+"' AND E2_FILIAL='"+xFILIAL('SE2')+"' AND SWB010.D_E_L_E_T_='' AND SE2010.D_E_L_E_T_='' AND WB_INVOICE+WB_HAWB=W9_INVOICE+W9_HAWB      "
cQuery1 +="         AND E2_NUM+E2_PREFIXO+E2_PARCELA=WB_NUMDUP+WB_PREFIXO+WB_PARCELA AND E2_FORNECE=W9_FORN),'')           AS FINANCEIRO_DUPL_PREF_PARC_TIPO_SALDO , "

cQuery1 +=" ISNULL((SELECT  TOP 1 E2_VALOR   FROM SWB010 WITH(NOLOCK) ,SE2010 WITH(NOLOCK) "
cQuery1 +=" WHERE WB_FILIAL='"+xFILIAL('SWB')+"' AND E2_FILIAL='"+xFILIAL('SE2')+"' AND SWB010.D_E_L_E_T_='' AND SE2010.D_E_L_E_T_='' AND WB_INVOICE+WB_HAWB=W9_INVOICE+W9_HAWB      "
cQuery1 +="         AND E2_NUM+E2_PREFIXO+E2_PARCELA=WB_NUMDUP+WB_PREFIXO+WB_PARCELA  AND E2_FORNECE=W9_FORN),'')           AS FINANCEIRO_VALOR,  "
		
cQuery1 +=" ISNULL((SELECT  TOP 1 E2_SALDO   FROM SWB010 WITH(NOLOCK) ,SE2010 WITH(NOLOCK) "
cQuery1 +=" WHERE WB_FILIAL='"+xFILIAL('SWB')+"' AND E2_FILIAL='"+xFILIAL('SE2')+"' AND SWB010.D_E_L_E_T_='' AND SE2010.D_E_L_E_T_='' AND WB_INVOICE+WB_HAWB=W9_INVOICE+W9_HAWB      "
cQuery1 +="         AND E2_NUM+E2_PREFIXO+E2_PARCELA=WB_NUMDUP+WB_PREFIXO+WB_PARCELA  AND E2_FORNECE=W9_FORN ),'')           AS FINANCEIRO_SALDO   "
cQuery1 +="  INTO INVCANFIN "
cQuery1 +="  FROM SW9010 SW9 with(nolock), SY6010 SY6 WITH(NOLOCK)  "
cQuery1 +="  WHERE  "
cQuery1 +="  W9_COND_PA=Y6_COD  "
cQuery1 +="  AND W9_DT_EMIS >='20190101'  "
cQuery1 +="  AND SW9.D_E_L_E_T_='' "
cQuery1 +="  AND SY6.D_E_L_E_T_='' "
cQuery1 +="  AND W9_FILIAL='"+xFILIAL('SW9')+"'  "
cQuery1 +="  AND Y6_FILIAL='"+xFILIAL('SY6')+"'   "
cQuery1 +="  ORDER BY SW9.W9_DT_EMIS,SW9.W9_HAWB,SW9.W9_INVOICE  "

/*
cQuery1 :=" SELECT  W9_COND_PA,Y6_TIPOCOB, "
cQuery1 +=" W9_INVOICE,W9_HAWB,W9_DT_EMIS,W9_NOM_FOR,W9_MOE_FOB,W9_FOB_TOT, "
cQuery1 +=" ISNULL((SELECT  TOP 1 WB_NUMDUP+'/'+WB_PREFIXO+'/'+WB_PARCELA+'/'+WB_TIPOTIT            FROM SWB010 WITH(NOLOCK)                        "
cQuery1 +="   WHERE WB_FILIAL='' AND D_E_L_E_T_='' AND WB_INVOICE+WB_HAWB=W9_INVOICE+W9_HAWB),'')   AS CAMBIO_DUPL_PREF_PARC_TIPO,                  "
cQuery1 +=" ISNULL((SELECT  TOP 1 E2_NUM+'/'+E2_PREFIXO+'/'+E2_PARCELA+'/'+E2_TIPO +STR(E2_SALDO)   FROM SWB010 WITH(NOLOCK) ,SE2010 WITH(NOLOCK)   "
cQuery1 +="   WHERE WB_FILIAL='' AND E2_FILIAL='01' AND SWB010.D_E_L_E_T_='' AND SE2010.D_E_L_E_T_='' AND WB_INVOICE+WB_HAWB=W9_INVOICE+W9_HAWB     "
cQuery1 +="         AND E2_NUM+E2_PREFIXO+E2_PARCELA=WB_NUMDUP+WB_PREFIXO+WB_PARCELA),'')           AS FINANCEIRO_DUPL_PREF_PARC_TIPO_SALDO         "
cQuery1 +=" INTO INVCANFIN "
cQuery1 +=" FROM SW9010 SW9 with(nolock), SY6010 SY6 WITH(NOLOCK) "
cQuery1 +=" WHERE "
cQuery1 +=" W9_COND_PA=Y6_COD "
cQuery1 +=" AND W9_DT_EMIS >='"+_cDINI+"' "//'20170101' "
cQuery1 +=" AND SW9.D_E_L_E_T_='' "
cQuery1 +=" AND SY6.D_E_L_E_T_='' "
cQuery1 +=" AND W9_FILIAL=''  "
cQuery1 +=" AND Y6_FILIAL=''   "
cQuery1 +=" ORDER BY SW9.W9_DT_EMIS,SW9.W9_HAWB,SW9.W9_INVOICE "
*/
*----------------------------------------------------------------------------------------------------------------------------------------------------

TCSQLEXEC(cQuery0)
SLEEP(4000)
TCSQLEXEC(cQuery1)

cQuery2 :=" SELECT W9_COND_PA,Y6_TIPOCOB,W9_INVOICE,W9_HAWB,W9_DT_EMIS,W9_NOM_FOR,W9_MOE_FOB,W9_FOB_TOT, "
cQuery2 +="        CAMBIO_DUPL_PREF_PARC_TIPO           AS CAMBIO,  "
cQuery2 +="	       FINANCEIRO_DUPL_PREF_PARC_TIPO_SALDO AS FATURA   "
cQuery2 +=" FROM INVCANFIN where Y6_TIPOCOB<>'4' AND (FINANCEIRO_DUPL_PREF_PARC_TIPO_SALDO='' or CAMBIO_DUPL_PREF_PARC_TIPO='') "
cQuery2 +=" ORDER BY W9_DT_EMIS,W9_HAWB,W9_INVOICE "

lSend     :=.F.

cEMAILTO  := ''
cEMAILCC  := ''

cEMAILTO  := 'adriana.ottoboni@rosenbergerdomex.com.br, '
cEMAILTO  += 'patricia.vieira@rdt.com.br, '
cEMAILTO  += 'tatiane.vieira@rosenbergerdomex.com.br, '
cEMAILTO  += 'lucio.cravo@rosenbergerdomex.com.br '
_cEMAILTO := cEMAILTO

cEMAILCC  := ''
cEMAILCC  += 'denis.vieira@rosenbergerdomex.com.br, mauricio.souza@opusvp.com.br '
_cEMAILCC :=cEMAILCC

IF !EMPTY(cEMAILTO)
	
	oProcess := TWFProcess():New( "SC", 'CONTROLE DE CAMBIO')
	oProcess:NewTask( "SC", "\WORKFLOW\CAMBIO1.HTML" )
	oProcess:cSubject := '(PRODUCAO) INVOICE X CAMBIO X TITULO COM Cobertura Cambial '+' '+ dtoc(date()) + '  '+ TIME()
	//oProcess:bReturn := "U_SCRETORNO"
	//oProcess:bTimeOut := {{"U_WFW120P(2)", 0 ,0 ,2 }}
	oHTML := oProcess:oHTML
	
	/*** Preenche os dados do cabecalho ***/
	
	oHtml:ValByName( "ddata"       , dtoc(date())+'   '+time() )
	//oHtml:ValByName( "ARMAZEM"     , TRB->B1_LOCPAD +' '+TRB->X5_DESCRI   )
	//oHtml:ValByName( "RESPONSAVEL" , cEMAILTO )
	//oHtml:ValByName( "RESPONSAVEL" , TRANSFORM(nPERCENT, "@E 999,999,999.99") )
	
	/*** Preenche os Itens ***/
	cQuery := ChangeQuery(cQuery2)
	TcQuery cQuery2 ALIAS "TRB" NEW
	
	oHtml:ValByName( "dataini" , SUBSTR(_cDINI,7,2)+'/'+SUBSTR(_cDINI,5,2)+'/'+SUBSTR(_cDINI,1,4) )
	
	DO WHILE !TRB->(EOF())  .AND.  nITENS <=300 //.AND. TRB->B1_LOCPAD==cLOCPAD   //TRB->A1_VEND==cVEND
		nITENS:=nITENS+1
		_dEMISS   := SUBSTR(TRB->W9_DT_EMIS,7,2)+'/'+SUBSTR(TRB->W9_DT_EMIS,5,2)+'/'+SUBSTR(TRB->W9_DT_EMIS,1,4)
		
		//W9_COND_PA Y6_TIPOCOB W9_INVOICE W9_HAWB W9_DT_EMIS W9_NOM_FOR W9_MOE_FOB W9_FOB_TOT   CAMBIO_DUPL_PREF_PARC_TIPO FINANCEIRO_DUPL_PREF_PARC_TIPO_SALDO
		AAdd( (oHtml:ValByName( "it.CONDPA"     )),TRB->W9_COND_PA                                )
		AAdd( (oHtml:ValByName( "it.INVOICE"    )),TRB->W9_INVOICE                                )
		AAdd( (oHtml:ValByName( "it.PROCESSO"   )),TRB->W9_HAWB                                   )
		AAdd( (oHtml:ValByName( "it.EMISSAO"    )),_dEMISS                                        )
		AAdd( (oHtml:ValByName( "it.FORNECEDOR" )),TRB->W9_NOM_FOR                                )
		AAdd( (oHtml:ValByName( "it.MOEDA"      )),TRB->W9_MOE_FOB                                )
		AAdd( (oHtml:ValByName( "it.VALOE"      )),TRANSFORM(TRB->W9_FOB_TOT,"@E 999,999,999.99") )
		AAdd( (oHtml:ValByName( "it.CAMBIO"     )),SUBSTR(TRB->CAMBIO  ,1,30)                     )
		AAdd( (oHtml:ValByName( "it.FATURA"     )),SUBSTR(TRB->FATURA  ,1,30)                     )
		
		TRB->(DBSKIP())
	ENDDO
	oHtml:ValByName( "total1" , TRANSFORM(nITENS, "@E 999") )
	
	oProcess:ClientName( Subs(cUsuario,7,15) )
	oProcess:cTo := cEMAILTO
	oProcess:cCC := cEMAILCC
	
	oProcess:Start()
	oProcess:Finish()
	
ENDIF
TRB->(DBCLOSEAREA())

**********************************************************************************************************************
*** sem cobertura cambial ********************************************************************************************
**********************************************************************************************************************

nITENS:= 0

cQuery2 :=" SELECT W9_COND_PA,Y6_TIPOCOB,W9_INVOICE,W9_HAWB,W9_DT_EMIS,W9_NOM_FOR,W9_MOE_FOB,W9_FOB_TOT, "
cQuery2 +="        CAMBIO_DUPL_PREF_PARC_TIPO           AS CAMBIO,  "
cQuery2 +="	       FINANCEIRO_DUPL_PREF_PARC_TIPO_SALDO AS FATURA   "
cQuery2 +=" FROM INVCANFIN where Y6_TIPOCOB='4' AND (FINANCEIRO_DUPL_PREF_PARC_TIPO_SALDO='' or CAMBIO_DUPL_PREF_PARC_TIPO='') "
cQuery2 +=" ORDER BY W9_DT_EMIS,W9_HAWB,W9_INVOICE "

lSend     :=.F.

cEMAILTO  := ''
cEMAILCC  := ''

cEMAILTO  := 'adriana.ottoboni@rosenbergerdomex.com.br, '
cEMAILTO  += 'patricia.vieira@rdt.com.br, '
cEMAILTO  += 'tatiane.vieira@rosenbergerdomex.com.br, '
cEMAILTO  += 'lucio.cravo@rosenbergerdomex.com.br '
_cEMAILTO := cEMAILTO

cEMAILCC  := ''
cEMAILCC  += 'denis.vieira@rosenbergerdomex.com.br, mauricio.souza@opusvp.com.br '
_cEMAILCC :=cEMAILCC

IF !EMPTY(cEMAILTO)
	
	oProcess := TWFProcess():New( "SC", 'CONTROLE DE CAMBIO')
	oProcess:NewTask( "SC", "\WORKFLOW\CAMBIO2.HTML" )
	oProcess:cSubject := '(PRODUCAO) INVOICE X CAMBIO X TITULO SEM Cobertura Cambial '+' '+ dtoc(date()) + '  '+ TIME()
	oHTML := oProcess:oHTML
	
	/*** Preenche os dados do cabecalho ***/
	
	oHtml:ValByName( "ddata"       , dtoc(date())+'   '+time() )
	
	/*** Preenche os Itens ***/
	cQuery := ChangeQuery(cQuery2)
	TcQuery cQuery2 ALIAS "TRB" NEW
	
	oHtml:ValByName( "dataini" , SUBSTR(_cDINI,7,2)+'/'+SUBSTR(_cDINI,5,2)+'/'+SUBSTR(_cDINI,1,4) )
	
	DO WHILE !TRB->(EOF())  .AND.  nITENS <=300 //.AND. TRB->B1_LOCPAD==cLOCPAD   //TRB->A1_VEND==cVEND
		nITENS:=nITENS+1
		_dEMISS   := SUBSTR(TRB->W9_DT_EMIS,7,2)+'/'+SUBSTR(TRB->W9_DT_EMIS,5,2)+'/'+SUBSTR(TRB->W9_DT_EMIS,1,4)
		
		AAdd( (oHtml:ValByName( "it.CONDPA"     )),TRB->W9_COND_PA                                )
		AAdd( (oHtml:ValByName( "it.INVOICE"    )),TRB->W9_INVOICE                                )
		AAdd( (oHtml:ValByName( "it.PROCESSO"   )),TRB->W9_HAWB                                   )
		AAdd( (oHtml:ValByName( "it.EMISSAO"    )),_dEMISS                                        )
		AAdd( (oHtml:ValByName( "it.FORNECEDOR" )),TRB->W9_NOM_FOR                                )
		AAdd( (oHtml:ValByName( "it.MOEDA"      )),TRB->W9_MOE_FOB                                )
		AAdd( (oHtml:ValByName( "it.VALOE"      )),TRANSFORM(TRB->W9_FOB_TOT,"@E 999,999,999.99") )
		AAdd( (oHtml:ValByName( "it.CAMBIO"     )),SUBSTR(TRB->CAMBIO  ,1,30)                     )
		AAdd( (oHtml:ValByName( "it.FATURA"     )),SUBSTR(TRB->FATURA  ,1,30)                     )
		
		lsend:=.T.
		
		TRB->(DBSKIP())
	ENDDO
	oHtml:ValByName( "total1" , TRANSFORM(nITENS, "@E 999") )
	
	oProcess:ClientName( Subs(cUsuario,7,15) )
	oProcess:cTo := cEMAILTO
	oProcess:cCC := cEMAILCC
	
	oProcess:Start()
	oProcess:Finish()
	
ENDIF
TRB->(DBCLOSEAREA())
WFSendMail({"01","01"})
**********************************************************************************************************************
ConOut( 'Job INVOICE X CAMBIO finalizado.' )

RESET ENVIRONMENT

Return( NIL )



*********************************************************************************************************************

USER FUNCTION WCANBATU(_cDINI)

*----------------------------------------------------------------------------------------------------------------------------------------------------
cQuery0 :=" DROP TABLE INVCANATU "
*----------------------------------------------------------------------------------------------------------------------------------------------------
cQuery1 :=" SELECT  W9_COND_PA,Y6_TIPOCOB, "
cQuery1 +=" W9_INVOICE,W9_HAWB,W9_DT_EMIS,W9_NOM_FOR,W9_MOE_FOB,W9_FOB_TOT, "
cQuery1 +=" ISNULL((SELECT  TOP 1 WB_NUMDUP+'/'+WB_PREFIXO+'/'+WB_PARCELA+'/'+WB_TIPOTIT            FROM SWB010 WITH(NOLOCK)                        "
cQuery1 +="   WHERE WB_FILIAL='"+xFILIAL('SWB')+"' AND D_E_L_E_T_='' AND WB_INVOICE+WB_HAWB=W9_INVOICE+W9_HAWB),'')   AS CAMBIO_DUPL_PREF_PARC_TIPO,                  "
cQuery1 +=" ISNULL((SELECT  TOP 1 E2_NUM+'/'+E2_PREFIXO+'/'+E2_PARCELA+'/'+E2_TIPO +STR(E2_SALDO)   FROM SWB010 WITH(NOLOCK) ,SE2010 WITH(NOLOCK)   "
cQuery1 +="   WHERE WB_FILIAL='"+xFILIAL('SWB')+"' AND E2_FILIAL='"+xFILIAL('SE2')+"' AND SWB010.D_E_L_E_T_='' AND SE2010.D_E_L_E_T_='' AND WB_INVOICE+WB_HAWB=W9_INVOICE+W9_HAWB     "
cQuery1 +="         AND E2_NUM+E2_PREFIXO+E2_PARCELA=WB_NUMDUP+WB_PREFIXO+WB_PARCELA),'')           AS FINANCEIRO_DUPL_PREF_PARC_TIPO_SALDO         "
cQuery1 +=" INTO INVCANATU "
cQuery1 +=" FROM SW9010 SW9 with(nolock), SY6010 SY6 WITH(NOLOCK) "
cQuery1 +=" WHERE "
cQuery1 +=" W9_COND_PA=Y6_COD "
cQuery1 +=" AND W9_DT_EMIS >='"+_cDINI+"' "//'20170101' "
cQuery1 +=" AND SW9.D_E_L_E_T_='' "
cQuery1 +=" AND SY6.D_E_L_E_T_='' "
cQuery1 +=" AND W9_FILIAL='"+xFILIAL('SW9')+"'  "
cQuery1 +=" AND Y6_FILIAL='"+xFILIAL('SY6')+"'   "
cQuery1 +=" ORDER BY SW9.W9_DT_EMIS,SW9.W9_HAWB,SW9.W9_INVOICE "
*----------------------------------------------------------------------------------------------------------------------------------------------------

TCSQLEXEC(cQuery0)
SLEEP(4000)
TCSQLEXEC(cQuery1)

cQuery2 :=" SELECT W9_COND_PA,Y6_TIPOCOB,W9_INVOICE,W9_HAWB,W9_DT_EMIS,W9_NOM_FOR,W9_MOE_FOB,W9_FOB_TOT, "
cQuery2 +="        CAMBIO_DUPL_PREF_PARC_TIPO           AS CAMBIO,  "
cQuery2 +="	       FINANCEIRO_DUPL_PREF_PARC_TIPO_SALDO AS FATURA   "
cQuery2 +=" FROM INVCANATU where Y6_TIPOCOB<>'4' AND (FINANCEIRO_DUPL_PREF_PARC_TIPO_SALDO='' or CAMBIO_DUPL_PREF_PARC_TIPO='') "
cQuery2 +=" ORDER BY W9_DT_EMIS,W9_HAWB,W9_INVOICE "

TcQuery cQuery2 ALIAS "TRB" NEW

DO WHILE !TRB->(EOF())
	
	cQuery3 :=" UPDATE SWB010 SET D_E_L_E_T_=''  "
	cQuery3 +=" WHERE WB_INVOICE='"+TRB->W9_INVOICE+"' AND WB_HAWB='"+TRB->W9_HAWB+"'  AND D_E_L_E_T_='*' AND "
	cQuery3 +=" NOT EXISTS(SELECT R_E_C_N_O_ FROM SWB010 WHERE WB_INVOICE='"+TRB->W9_INVOICE+"' AND WB_HAWB='"+TRB->W9_HAWB+"' AND D_E_L_E_T_='') "
	TCSQLEXEC(cQuery3)
	
	cQuery4 :=" SELECT D_E_L_E_T_,WB_NUMDUP,WB_PREFIXO,WB_PARCELA,WB_FORN,WB_LOJA
	cQuery4 +=" FROM SWB010 WHERE WB_INVOICE='"+TRB->W9_INVOICE+"' AND WB_HAWB='"+TRB->W9_HAWB+"' AND D_E_L_E_T_='' "
	
	TcQuery cQuery4 ALIAS "TR4" NEW
	
	If Select("TR4") <> 0
		
		cNUMDUP  :=TR4->WB_NUMDUP
		cPREFIXO :=TR4->WB_PREFIXO
		cPARCELA :=TR4->WB_PARCELA
		cFORN    :=TR4->WB_FORN
		cLOJA    :=TR4->WB_LOJA
		
		cQuery5 :=" UPDATE SE2010  SET D_E_L_E_T_='', R_E_C_D_E_L_=0  "
		cQuery5 +=" WHERE E2_NUM='"+cNUMDUP+"' AND E2_PREFIXO='"+cPREFIXO+"' AND E2_PARCELA='"+cPARCELA+"' AND E2_FORNECE='"+cFORN+"' AND E2_LOJA='"+cLOJA+"' AND D_E_L_E_T_='*' AND "
		cQuery5 +=" NOT EXISTS(SELECT D_E_L_E_T_,R_E_C_D_E_L_  FROM SE2010 WHERE E2_NUM='"+cNUMDUP+"' AND E2_PREFIXO='"+cPREFIXO+"' AND E2_PARCELA='"+cPARCELA+"' AND E2_FORNECE='"+cFORN+"' AND E2_LOJA='"+cLOJA+"' AND D_E_L_E_T_='' ) "
		TCSQLEXEC(cQuery5)
		TR4->(DBCLOSEAREA())
	ENDIF
	TRB->(DBSKIP())
ENDDO
TRB->(DBCLOSEAREA())

RETURN




