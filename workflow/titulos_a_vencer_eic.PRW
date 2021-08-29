//------------------------------------------------------------------------------------//
//Empresa...:
//Funcao....:
//Autor.....: MAURICIO LIMA DE SOUZA
//Data......: 09/2013
//Uso.......:
//Versao....:
//------------------------------------------------------------------------------------//

#INCLUDE "PROTHEUS.ch"
#include "ap5mail.ch"
#INCLUDE "TOPCONN.CH"
#Include "TbiConn.ch"

*-----------------------------------------------------------------------------------------
USER FUNCTION WDOMTIT2()
*-----------------------------------------------------------------------------------------

RPCSetType(3)  // Nao utilizar licensa

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" TABLES   "SE2" , "SX5" , "SX6"
SE2->( dbSetOrder(1) )
SX5->( dbSetOrder(1) )

PRIVATE cQuery    :=""
PRIVATE cQuery2   :=""
PRIVATE cEMAILTO  :=""
PRIVATE _cEMAILTO :=""
PRIVATE _nX       :=0
PRIVATE _nC       :=0
PRIVATE _nI       :=0
PRIVATE dDataAtu  :=(date()-1)
PRIVATE lSend     :=.F.
PRIVATE cLOCPAD   :=space(02)
PRIVATE nTOTAL1   :=0
PRIVATE nTOTAL2   :=0
PRIVATE _cVENCREA :=SPACE(10)

ConOut( 'Job TITULOS_A_VENCER iniciado.' )

//dDataAtu :=ctod('13/03/2009')

_cData := dtos(dDatabase+31)
cQuery :=" SELECT E2_TIPO,E2_VENCREA,E2_HIST,E2_SALDO,E2_PREFIXO,E2_NUM,E2_PARCELA FROM "+RetSqlName('SE2')+" "
cQuery +=" WHERE E2_VENCREA >'"+dtos(dDatabase)+"' AND E2_VENCREA <='"+_cData+"' AND E2_SALDO>0 AND D_E_L_E_T_<>'*'  "
cQuery +=" AND E2_PREFIXO='EIC' "
cQuery +=" AND E2_TIPO NOT IN ('INV','NF','PA','NCF','DRF') "
cQuery +=" ORDER BY E2_TIPO,E2_VENCREA,E2_NUM "

cQuery2 :=" SELECT E2_TIPO,E2_VENCREA,E2_HIST,E2_SALDO,E2_PREFIXO,E2_NUM,E2_PARCELA FROM "+RetSqlName('SE2')+" "
cQuery2 +=" WHERE E2_VENCREA >'"+dtos(dDatabase)+"' AND E2_VENCREA <='"+_cData+"' AND D_E_L_E_T_<>'*'  "
cQuery2 +=" AND E2_PREFIXO='EIC' "
cQuery2 +=" AND E2_TIPO NOT IN ('PR','PRE') "     
cQuery2 +=" AND E2_SALDO>0 "
cQuery2 +=" ORDER BY E2_TIPO,E2_VENCREA,E2_NUM "

lSend     :=.F.
cEMAILTO  := ''

cEMAILTO  := 'jose.araujo@rosenbergerdomex.com.br, '
cEMAILTO  += 'carlos.sepinho@rdt.com.br, '//camila.eugenio@rosenbergerdomex.com.br, '
cEMAILTO  += 'tatiane.vieira@rosenbergerdomex.com.br, patricia.vieira@rdt.com.br, '
cEMAILTO  += 'lucio.cravo@rosenbergerdomex.com.br, marcelo.souza@rosenbergerdomex.com.br, adriana.ottoboni@rosenbergerdomex.com.br

_cEMAILTO := cEMAILTO

cEMAILCC  := ''
cEMAILCC  += 'denis.vieira@rosenbergerdomex.com.br, mauricio.souza@opusvp.com.br'
_cEMAILCC :=cEMAILCC



IF !EMPTY(cEMAILTO)
	
	oProcess := TWFProcess():New( "TITULOSEIC", 'TITULOS EIC')
	oProcess:NewTask( "TITULOSEIC", "\WORKFLOW\TITULO_A_VENCER2.HTML" )
	oProcess:cSubject := '(PRODUCAO) Titulos futuro EIC '+' '+ dtos(date()) + '  '+ TIME()
	//oProcess:bReturn := "U_SCRETORNO"
	//oProcess:bTimeOut := {{"U_WFW120P(2)", 0 ,0 ,2 }}
	oHTML := oProcess:oHTML
	
	/*** Preenche os dados do cabecalho ***/
	
	oHtml:ValByName( "ddata"       , dtoc(date())+'   '+time() )
	//oHtml:ValByName( "ARMAZEM"     , TRB->B1_LOCPAD +' '+TRB->X5_DESCRI   )
	//oHtml:ValByName( "RESPONSAVEL" , cEMAILTO )
	//oHtml:ValByName( "RESPONSAVEL" , TRANSFORM(nPERCENT, "@E 999,999,999.99") )
	
	/*** Preenche os Itens ***/
	cQuery := ChangeQuery(CQUERY)
	TcQuery cQuery ALIAS "TRB" NEW
	
	DO WHILE !TRB->(EOF()) //.AND. TRB->B1_LOCPAD==cLOCPAD   //TRB->A1_VEND==cVEND
		_cVENCREA := SUBSTR(TRB->E2_VENCREA,7,2)+'/'+SUBSTR(TRB->E2_VENCREA,5,2)+'/'+SUBSTR(TRB->E2_VENCREA,1,4)
		AAdd( (oHtml:ValByName( "it.tipo"    )),TRB->E2_TIPO       )
		AAdd( (oHtml:ValByName( "it.vencto"  )),_cVENCREA    )
		AAdd( (oHtml:ValByName( "it.hist"    )),TRB->E2_HIST       )
		AAdd( (oHtml:ValByName( "it.saldo"   )),TRANSFORM(TRB->E2_SALDO,"@E 999,999,999.99"))
		AAdd( (oHtml:ValByName( "it.prefixo" )),TRB->E2_PREFIXO    )
		AAdd( (oHtml:ValByName( "it.num"     )),TRB->E2_NUM        )
		AAdd( (oHtml:ValByName( "it.parc"    )),TRB->E2_PARCELA    )
		nTOTAL1 :=nTOTAL1+TRB->E2_SALDO
		lsend:=.T.
		
		TRB->(DBSKIP())
	ENDDO
	oHtml:ValByName( "total1" , TRANSFORM(nTOTAL1, "@E 999,999,999.99") )
	
	cQuery2 := ChangeQuery(CQUERY2)
	TcQuery cQuery2 ALIAS "TR2" NEW
	
	DO WHILE !TR2->(EOF())
		_cVENCREA := SUBSTR(TR2->E2_VENCREA,7,2)+'/'+SUBSTR(TR2->E2_VENCREA,5,2)+'/'+SUBSTR(TR2->E2_VENCREA,1,4)
		AAdd( (oHtml:ValByName( "it2.tipo"    )),TR2->E2_TIPO       )
		AAdd( (oHtml:ValByName( "it2.vencto"  )),_cVENCREA          )
		AAdd( (oHtml:ValByName( "it2.hist"    )),TR2->E2_HIST       )
		AAdd( (oHtml:ValByName( "it2.saldo"   )),TRANSFORM(TR2->E2_SALDO,"@E 999,999,999.99"))
		AAdd( (oHtml:ValByName( "it2.prefixo" )),TR2->E2_PREFIXO    )
		AAdd( (oHtml:ValByName( "it2.num"     )),TR2->E2_NUM        )
		AAdd( (oHtml:ValByName( "it2.parc"    )),TR2->E2_PARCELA    )
		nTOTAL2 :=nTOTAL2+TR2->E2_SALDO
		lsend:=.T.
		
		TR2->(DBSKIP())
	ENDDO
	oHtml:ValByName( "total2" , TRANSFORM(nTOTAL2, "@E 999,999,999.99") )
	
	oProcess:ClientName( Subs(cUsuario,7,15) )
	oProcess:cTo := _cEMAILTO 
	oProcess:cCC := _cEMAILCC
	
	oProcess:Start()
	oProcess:Finish()
	WFSendMail({"01","01"})
ENDIF
TRB->(DBCLOSEAREA())
TR2->(DBCLOSEAREA())

ConOut( 'Job TITULOS_A_VENCER finalizado com sucesso.' )

RESET ENVIRONMENT

Return( NIL )


