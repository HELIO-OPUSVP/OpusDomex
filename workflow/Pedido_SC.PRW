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
USER FUNCTION WDOMPCSC()
*-----------------------------------------------------------------------------------------

RPCSetType(3)  // Nao utilizar licensa

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" TABLES  "SC1" , "SC7" , "SA2"

SetUserDefault("000000")

SA2->( dbSetOrder(1) )
SC1->( dbSetOrder(1) )
SC7->( dbSetOrder(1) )
SX5->( dbSetOrder(1) )

PRIVATE cQuery0   :=""
PRIVATE cQuery    :=""
PRIVATE cQuery2   :=""
PRIVATE cEMAILTO  :=""
PRIVATE cEMAILCC  :=""
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
PRIVATE _cFORNEC  :=SPACE(10)
PRIVATE nITENS    :=0

ConOut( 'Job PC_SC_EM_ABERTO iniciado.' )

//dDataAtu :=ctod('13/03/2009')

_cData := dtos(dDatabase)

cQuery0 :=" UPDATE SC7010 SET C7_XXIDMRP=(SELECT TOP 1 C1_XXIDMRP FROM SC1010 WHERE C1_PRODUTO=C7_PRODUTO AND C1_NUM=C7_NUMSC AND D_E_L_E_T_='' AND C1_XXIDMRP<>'')  "
cQuery0 +=" WHERE D_E_L_E_T_='' AND C7_XXIDMRP=''  "
cQuery0 +=" AND EXISTS (SELECT TOP 1 C1_XXIDMRP FROM SC1010 WHERE C1_PRODUTO=C7_PRODUTO AND C1_NUM=C7_NUMSC AND D_E_L_E_T_='' AND C1_XXIDMRP<>'')  "

TCSQLEXEC(cQuery0)

cQuery :="  SELECT C1_EMISSAO,C1_DATPRF,C1_NUM,C1_ITEM,C1_PRODUTO,C1_DESCRI,C1_QUANT-C1_QUJE AS C1_SALDO,C1_OBS,C1_IMPORT,C1_NUM_SI,C1_FORNECE,C1_LOJA,C1_SOLICIT,C1_XXIDMRP "
cQuery +="  FROM SC1010              "
cQuery +="  WHERE                    "
cQuery +="  C1_QUANT > C1_QUJE AND   "
cQuery +="  C1_QUJE  >=0       AND   " 
cQuery +="  C1_RESIDUO=''      AND   " 
cQuery +="  D_E_L_E_T_=''      AND   "
cQuery +="  C1_NUM_SI =''            " //INCLUIDO 27/06/2018 SOMENTE SC NACIONAL
cQuery +="  ORDER BY SC1010.C1_DATPRF,C1_NUM,C1_ITEM "

/*
cQuery2 :=" SELECT C7_EMISSAO,C7_DATPRF,C7_NUM,C7_ITEM,C7_PRODUTO,C7_DESCRI,C7_QUANT-C7_QUJE AS C7_SALDO,C7_OBS,C7_IMPORT,C7_PO_EIC,C7_FORNECE,C7_LOJA,C7_XXIDMRP "
cQuery2 +=" FROM SC7010               "
cQuery2 +=" WHERE                     "
cQuery2 +=" C7_QUANT > C7_QUJE AND    "
cQuery2 +=" C7_RESIDUO=''      AND    "
cQuery2 +=" C7_DATPRF<='"+DTOS(DATE())+"' AND  "
cQuery2 +=" D_E_L_E_T_<>'*'           "
cQuery2 +=" ORDER BY SC7010.C7_DATPRF,C7_NUM,C7_ITEM "
*/

cQuery2 :=" SELECT C7_EMISSAO,C7_DATPRF,C7_NUM,C7_ITEM,C7_PRODUTO,C7_DESCRI,C7_QUANT-C7_QUJE AS C7_SALDO,C7_OBS,C7_IMPORT,C7_PO_EIC,C7_FORNECE,C7_LOJA,C7_XXIDMRP "
cQuery2 +=" FROM SC7010              "
cQuery2 +=" WHERE                    " 
cQuery2 +=" C7_QUANT > C7_QUJE AND   "
cQuery2 +=" C7_RESIDUO=''      AND   " 
cQuery2 +=" C7_PO_EIC =''      AND   "
cQuery2 +=" D_E_L_E_T_=''            "
cQuery2 +=" ORDER BY SC7010.C7_DATPRF,SC7010.C7_NUM,SC7010.C7_ITEM "

lSend     :=.F.

cEMAILTO  := ''
cEMAILCC  := ''

//cEMAILTO  += 'carlos.sepinho@rosenbergerdomex.com.br,'
//cEMAILTO  += 'Paulo.celestino@rosenbergerdomex.com.br,Priscila.santoro@rosenbergerdomex.com.br'


//cEMAILCC  += 'camila.eugenio@rosenbergerdomex.com.br,paulo.ramos@rosenbergerdomex.com.br,'
//cEMAILCC  += 'wellington.silva@rosenbergerdomex.com.br,rebecca.ungaro@rosenbergerdomex.com.br,mauricio.souza@opusvp.com.br,denis.vieira@rosenbergerdomex.com.br'

cEMAILTO  += 'paulo.celestino@rosenbergerdomex.com.br, camila.moreno@rosenbergerdomex.com.br, 
cEMAILTO  += 'dimas.campos@rosenbergerdomex.com.br, alberto.oliveira@rosenbergerdomex.com.br, '  
cEMAILTO  += 'adriana.ottoboni@rosenbergerdomex.com.br, carlos.carvalho@rosenbergerdomex.com.br, '
cEMAILCC  += 'manutencaoeletrica@rosenbergerdomex.com.br, mauricio.souza@opusvp.com.br, denis.vieira@rosenbergerdomex.com.br'


_cEMAILTO := cEMAILTO

IF !EMPTY(cEMAILTO)
	
	oProcess := TWFProcess():New( "SC", 'SOLICITACAO DE COMPRA')
	oProcess:NewTask( "SC", "\WORKFLOW\SC2.HTML" )
	oProcess:cSubject := 'Solicitacao de compra Nacional Limite(300 itens)'+' '+ dtoc(date()) + '  '+ TIME()
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
	
	DO WHILE !TRB->(EOF())  .AND.  nITENS <=300 //.AND. TRB->B1_LOCPAD==cLOCPAD   //TRB->A1_VEND==cVEND
		nITENS:=nITENS+1
		_dEMISS   := SUBSTR(TRB->C1_EMISSAO,7,2)+'/'+SUBSTR(TRB->C1_EMISSAO,5,2)+'/'+SUBSTR(TRB->C1_EMISSAO,1,4)
		_dATPRF   := SUBSTR(TRB->C1_DATPRF,7,2) +'/'+SUBSTR(TRB->C1_DATPRF,5,2) +'/'+SUBSTR(TRB->C1_DATPRF,1,4)
		
		IF !EMPTY(TRB->C1_FORNECE) .AND. !EMPTY(TRB->C1_LOJA)
			//_cFORNECE :=POSICIONE('SA2',1,xFILIAL('SA2')+TRB->C1_FORNECE+TRB->C1_LOJA,"A2_NREDUZ")
			//_cFORNECE :=TRB->C1_FORNECE+' '+_cFORNECE
			SA2->(DBSEEK(xFILIAL('SA2')+TRB->C1_FORNECE+TRB->C1_LOJA))
			_cFORNEC :=SA2->A2_NREDUZ
		ELSE
			_cFORNEC :=''
		ENDIF
		
		AAdd( (oHtml:ValByName( "it.EMISSAO"   )),_dEMISS                       )
		AAdd( (oHtml:ValByName( "it.DATPRF"    )),_dATPRF                       )
		AAdd( (oHtml:ValByName( "it.NUM"       )),SUBSTR(TRB->C1_NUM,1,6)       )
		AAdd( (oHtml:ValByName( "it.SOLICIT"   )),TRB->C1_SOLICIT               )
		AAdd( (oHtml:ValByName( "it.ITEM"      )),SUBSTR(TRB->C1_ITEM,1,4)      )
		AAdd( (oHtml:ValByName( "it.FORNEC"    )),_cFORNEC                      )
		AAdd( (oHtml:ValByName( "it.PRODUTO"   )),SUBSTR(TRB->C1_PRODUTO,1,15)  )
		AAdd( (oHtml:ValByName( "it.DESCRI"    )),SUBSTR(TRB->C1_DESCRI,1,30)   )
		AAdd( (oHtml:ValByName( "it.SALDO"     )),TRANSFORM(TRB->C1_SALDO,"@E 999,999,999.99")      )
		AAdd( (oHtml:ValByName( "it.OBS"       )),SUBSTR(TRB->C1_OBS,1,30 )     )
		AAdd( (oHtml:ValByName( "it.IMP"       )),SUBSTR(TRB->C1_IMPORT,1,1)    )
		AAdd( (oHtml:ValByName( "it.NUMSI"     )),SUBSTR(TRB->C1_NUM_SI,1,8 )   )
		AAdd( (oHtml:ValByName( "it.IDMRP"     )),ALLTRIM(TRB->C1_XXIDMRP)      )
		
		
		//nTOTAL1 :=nTOTAL1+TRB->E2_SALDO
		lsend:=.T.
		
		TRB->(DBSKIP())
	ENDDO
	//oHtml:ValByName( "total1" , TRANSFORM(nTOTAL1, "@E 999,999,999.99") )
	
	//cQuery2 := ChangeQuery(CQUERY2)
	//TcQuery cQuery2 ALIAS "TR2" NEW
	
	//	DO WHILE !TR2->(EOF())
	//
	//		_dATPRF := SUBSTR(TR2->C7_DATPRF,7,2)+'/'+SUBSTR(TR2->C7_DATPRF,5,2)+'/'+SUBSTR(TR2->C7_DATPRF,1,4)
	//		AAdd( (oHtml:ValByName( "it2.DATPRF"    )),_dATPRF            )
	//		AAdd( (oHtml:ValByName( "it2.NUM"       )),SUBSTR(TR2->C7_NUM,1,6)        )
	//		AAdd( (oHtml:ValByName( "it2.ITEM"      )),SUBSTR(TR2->C7_ITEM,1,4)      )
	//		AAdd( (oHtml:ValByName( "it2.PRODUTO"   )),SUBSTR(TR2->C7_PRODUTO,1,5)    )
	//		AAdd( (oHtml:ValByName( "it2.DESCRI"    )),SUBSTR(TR2->C7_DESCRI,1,1)     )
	//		AAdd( (oHtml:ValByName( "it2.SALDO"     )),TRANSFORM(TR2->C7_SALDO,"@E 999,999,999.99")      )
	//		AAdd( (oHtml:ValByName( "it2.SALDO"     )),TR2->C7_SALDO      )
	//		AAdd( (oHtml:ValByName( "it2.OBS"       )),SUBSTR(TR2->C7_OBS,1,1)        )
	//		AAdd( (oHtml:ValByName( "it2.IMPORT"    )),SUBSTR(TR2->C7_IMPORT,1,1)     )
	//		AAdd( (oHtml:ValByName( "it2.NUMSI"     )),SUBSTR(TR2->C7_PO_EIC,1,1)     )
	//      nTOTAL2 :=nTOTAL2+TR2->E2_SALDO
	
	//		lsend:=.T.
	//
	//		TR2->(DBSKIP())
	//	ENDDO
	//	oHtml:ValByName( "total2" , TRANSFORM(nTOTAL2, "@E 999,999,999.99") )
	
	oProcess:ClientName( Subs(cUsuario,7,15) )
	oProcess:cTo := cEMAILTO
	oProcess:cCC := cEMAILCC
	
	oProcess:Start()
	oProcess:Finish()
	
	//-----------------------------------------------------------------------------------------------------------------
	//-----------------------------------------------------------------------------------------------------------------
	
	
	cEMAILTO  := ''
	cEMAILCC  := ''
	
	//cEMAILTO  += 'carlos.sepinho@rosenbergerdomex.com.br,'
	//cEMAILTO  += 'paulo.celestino@rosenbergerdomex.com.br,camila.moreno@rosenbergerdomex.com.br,dimas.campos@rosenbergerdomex.com.br,wellington.silva@rosenbergerdomex.com.br'
	
	//cEMAILCC  += 'camila.eugenio@rosenbergerdomex.com.br,paulo.ramos@rosenbergerdomex.com.br,'
	
	cEMAILTO  += 'paulo.celestino@rosenbergerdomex.com.br,camila.moreno@rosenbergerdomex.com.br,dimas.campos@rosenbergerdomex.com.br,alberto.oliveira@rosenbergerdomex.com.br, '  //wellington.silva@rosenbergerdomex.com.br, '
   cEMAILTO  += 'adriana.ottoboni@rosenbergerdomex.com.br,carlos.carvalho@rosenbergerdomex.com.br, '
	cEMAILCC  += 'manutencaoeletrica@rosenbergerdomex.com.br,mauricio.souza@opusvp.com.br,denis.vieira@rosenbergerdomex.com.br'
	
	_cEMAILTO := cEMAILTO
	
	oProcess := TWFProcess():New( "PC", 'Pedido de Compra')
	oProcess:NewTask( "PC", "\WORKFLOW\PEDIDO2.HTML" )
	oProcess:cSubject := 'Pedido de Compras Nacional Limite(300 itens) '+' '+ dtoc(date()) + '  '+ TIME()
	//oProcess:bReturn := "U_SCRETORNO"
	//oProcess:bTimeOut := {{"U_WFW120P(2)", 0 ,0 ,2 }}
	oHTML := oProcess:oHTML
	
	/*** Preenche os dados do cabecalho ***/
	
	oHtml:ValByName( "ddata"       , dtoc(date())+'   '+time() )
	//oHtml:ValByName( "ARMAZEM"     , TRB->B1_LOCPAD +' '+TRB->X5_DESCRI   )
	//oHtml:ValByName( "RESPONSAVEL" , cEMAILTO )
	//oHtml:ValByName( "RESPONSAVEL" , TRANSFORM(nPERCENT, "@E 999,999,999.99") )
	
	/*** Preenche os Itens ***/
	//cQuery := ChangeQuery(CQUERY)
	//TcQuery cQuery ALIAS "TRB" NEW
	
	//	DO WHILE !TRB->(EOF()) //.AND. TRB->B1_LOCPAD==cLOCPAD   //TRB->A1_VEND==cVEND
	//		_dATPRF := SUBSTR(TRB->C1_DATPRF,7,2)+'/'+SUBSTR(TRB->C1_DATPRF,5,2)+'/'+SUBSTR(TRB->C1_DATPRF,1,4)
	//		AAdd( (oHtml:ValByName( "it.DATPRF"    )),_dATPRF            )
	//		AAdd( (oHtml:ValByName( "it.NUM"       )),SUBSTR(TRB->C1_NUM,1,6)       )
	//		AAdd( (oHtml:ValByName( "it.ITEM"      )),SUBSTR(TRB->C1_ITEM,1,4)      )
	//		AAdd( (oHtml:ValByName( "it.PRODUTO"   )),SUBSTR(TRB->C1_PRODUTO,1,15)  )
	//		AAdd( (oHtml:ValByName( "it.DESCRI"    )),SUBSTR(TRB->C1_DESCRI,1,30)   )
	//		AAdd( (oHtml:ValByName( "it.SALDO"     )),TRANSFORM(TRB->C1_SALDO,"@E 999,999,999.99")      )
	//		AAdd( (oHtml:ValByName( "it.OBS"       )),SUBSTR(TRB->C1_OBS,1,30 )     )
	//		AAdd( (oHtml:ValByName( "it.IMPORT"    )),SUBSTR(TRB->C1_IMPORT,1,1)    )
	//		AAdd( (oHtml:ValByName( "it.NUMSI"     )),SUBSTR(TRB->C1_NUM_SI,1,8 )   )
	//nTOTAL1 :=nTOTAL1+TRB->E2_SALDO
	//		lsend:=.T.
	//
	//		TRB->(DBSKIP())
	//	ENDDO
	//oHtml:ValByName( "total1" , TRANSFORM(nTOTAL1, "@E 999,999,999.99") )
	
	cQuery2 := ChangeQuery(CQUERY2)
	TcQuery cQuery2 ALIAS "TR2" NEW
	
	nITENS   :=0
	ntotal2  :=0
	DO WHILE !TR2->(EOF()) .AND.  nITENS <=300
		nITENS :=nITENS+1
		_dEMISS := SUBSTR(TR2->C7_EMISSAO,7,2)+'/'+SUBSTR(TR2->C7_EMISSAO,5,2)+'/'+SUBSTR(TR2->C7_EMISSAO,1,4)
		_dATPRF := SUBSTR(TR2->C7_DATPRF,7,2) +'/'+SUBSTR(TR2->C7_DATPRF,5,2) +'/'+SUBSTR(TR2->C7_DATPRF,1,4)
		
		IF !EMPTY(TR2->C7_FORNECE) .AND. !EMPTY(TR2->C7_LOJA)
			// _cFORNECE :=POSICIONE('SA2',1,xFILIAL('SA2')+TR2->C7_FORNECE+TR2->C7_LOJA,"A2_NREDUZ")
			// _cFORNECE :=TR2->C7_FORNECE+' '+_cFORNEC
			SA2->(DBSEEK(xFILIAL('SA2')+TR2->C7_FORNECE+TR2->C7_LOJA))
			_cFORNEC :=SA2->A2_NREDUZ
		ELSE
			_cFORNEC :=''
		ENDIF
		
		AAdd( (oHtml:ValByName( "it2.EMISSAO"   )),_dEMISS            )
		AAdd( (oHtml:ValByName( "it2.DATPRF"    )),_dATPRF            )
		AAdd( (oHtml:ValByName( "it2.NUM"       )),SUBSTR(TR2->C7_NUM,1,6)         )
		AAdd( (oHtml:ValByName( "it2.ITEM"      )),SUBSTR(TR2->C7_ITEM,1,4)        )
		AAdd( (oHtml:ValByName( "it2.FORNECE"   )),_cFORNEC              )
		AAdd( (oHtml:ValByName( "it2.PRODUTO"   )),SUBSTR(TR2->C7_PRODUTO,1,15)    )
		AAdd( (oHtml:ValByName( "it2.DESCRI"    )),SUBSTR(TR2->C7_DESCRI,1,20)     )
		AAdd( (oHtml:ValByName( "it2.SALDO"     )),TRANSFORM(TR2->C7_SALDO,"@E 999,999,999.99")      )
		AAdd( (oHtml:ValByName( "it2.OBS"       )),SUBSTR(TR2->C7_OBS,1,20)        )
		AAdd( (oHtml:ValByName( "it2.IMPORT"    )),SUBSTR(TR2->C7_IMPORT,1,1)      )
		AAdd( (oHtml:ValByName( "it2.NUMSI"     )),SUBSTR(TR2->C7_PO_EIC,1,08)     )
		AAdd( (oHtml:ValByName( "it2.IDMRP"     )),ALLTRIM(TR2->C7_XXIDMRP)      )
		
		ntotal2 := ntotal2+1
		
		//      nTOTAL2 :=nTOTAL2+TR2->E2_SALDO
		
		lsend:=.T.
		
		TR2->(DBSKIP())
	ENDDO
	oHtml:ValByName( "total2" , TRANSFORM(nTOTAL2,"@E 9999")+" Itens" )
	
	oProcess:ClientName( Subs(cUsuario,7,15) )
	oProcess:cTo := cEMAILTO
	oProcess:cCC := cEMAILCC
	
	oProcess:Start()
	oProcess:Finish()
	
	//-----------------------------------------------------------------------------------------------------------------
	
	
	WFSendMail({"01","01"})
ENDIF
TRB->(DBCLOSEAREA())
TR2->(DBCLOSEAREA())

ConOut( 'Job PCSCEMABERTO finalizado.' )

RESET ENVIRONMENT

Return( NIL )



