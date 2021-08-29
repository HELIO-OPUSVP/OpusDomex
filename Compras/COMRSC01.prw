#include "rwmake.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMRSC01  บAutor  ณMarcos Rezende      บ Data ณ  29/10/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia WorkFlow de Solicitacao de Compras em aberto ao      บฑฑ
ฑฑบ          ณ  solicitante, desde que o prazo da necessidade tenha expiradoบฑฑ
ฑฑบ          ณ  ou irแ expirar nos pr๓ximos 5 dias                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบData      ณAutor             ณAltera็ใo                                บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                    
USER FUNCTION COMRSC01()
Local cUser 	:= ""
RSC01a(RetCodUsr(),10)
RETURN


//schedule para enviar solicita็๕es pendentes a todos os usuแrios
User Function SchRSC01()
Local nDias := 10 //prazo de necessidade a considerar
Local dDTULENV
PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "COM"

//captura ultima data processada
dDTULENV := SuperGetMV("MV_DTSCAB")
if dDTULENV < dDATABASE
	If SX6->(SimpleLock())
		PutMv("MV_DTSCAB",dDATABASE)
	EndIf
	
	cQuery := " SELECT DISTINCT C1_USER "
	cQuery += " FROM " + RetSqlName("SC1")
	cQuery += " WHERE C1_QUANT>C1_QUJE AND C1_DATPRF<='"+dtos(dDATABASE+nDias)+"' AND C1_FILIAL = '"+xFilial("SC1")+"' AND D_E_L_E_T_ = ' ' AND C1_RESIDUO <>'S' "
	cQuery += " ORDER BY C1_USER"
	If Select("SCHEDULE") <> 0
		SCHEDULE->( dbCloseArea() )
	EndIf
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"SCHEDULE", .F., .T.)
	
	while SCHEDULE->(!EOF())
		
		RSC01a(SCHEDULE->C1_USER,nDias)
		schedule->(dbskip())
		
	enddo
endif
RETURN


STATIC Function RSC01a(cUser,nDias)
Local cMvAtt   := GetMv("MV_WFHTML")
//Local cMailSup := UsrRetMail(cAprov)
Private aFilial:={'CACAPAVA'}
Private oHtml


sc1->(msunlock())



//FILTRA AS SOLICITAวีES COM DATA DE ENTREGA EXPIRADOS E A EXPIRAR NOS PRำXIMOS (nDias) DIAS
cQuery := " SELECT C1_FILIAL, C1_NUM, C1_EMISSAO, C1_SOLICIT, C1_USER, C1_ITEM, C1_PRODUTO, C1_DESCRI, C1_UM, C1_QUANT, C1_DATPRF, C1_OBS, ' ' C1_XXOBS, C1_CC, C1_USER, C1_APROV, C1_COTACAO, C1_QUJE"
cQuery += " FROM " + RetSqlName("SC1")
cQuery += " WHERE C1_QUANT>C1_QUJE AND C1_DATPRF >='20131101' AND C1_DATPRF<='"+dtos(dDATABASE+nDias)+"' AND C1_FILIAL = '"+xFilial("SC1")+"' AND D_E_L_E_T_ = ' ' "
cQuery += " AND C1_RESIDUO <>'S' "    //MAURICIO 10/09/2014 FILTRA RESIDUO
cQuery += " AND C1_USER ='"+cUser+"'" //ENVIA AO SOLICITANTE
cQuery += " ORDER BY C1_DATPRF,C1_EMISSAO,C1_NUM,C1_ITEM "
If Select("TRB") <> 0
	TRB->( dbCloseArea() )
EndIf
dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB", .F., .T.)

TcSetField("TRB","C1_EMISSAO","D")
TcSetField("TRB","C1_DATPRF","D")

nRec := 0
conout('query')
conout(cQuery)

//CASO TENHA DADOS
If trb->(!eof())
	
	dbSelectArea("TRB")
	dbGoTop()
	
	cNumSc		:= TRB->C1_NUM
	cSolicit	   := UsrRetName(TRB->C1_user)
	cMailTo		:= UsrRetMail(TRB->C1_USER)
	conout('cnumsc '+cnumsc)
	conout('TRB->C1_USER '+TRB->C1_USER)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMuda o parametro para enviar no corpo do e-mailณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	PutMv("MV_WFHTML","T")
	
	oProcess:=TWFProcess():New("000004","WORKFLOW PARA SC EM ABERTO")
	oProcess:NewTask('Inicio',"\WORKFLOW\HTML\COMWF_SOL_ABERTAS.htm")
	oProcess:ClientName(cUser)
	oProcess:cTo    	:= cMailTo 

	oProcess:cSubject  	:= "Rela็ใo de Solicita็๕es pendentes para o Solicitante: " + cSolicit
	oProcess:cBody    	:= ""
	
	oHtml   := oProcess:oHtml
	
	oHtml:ValByName("cNUM"			, TRB->C1_NUM)
	oHtml:ValByName("cEMISSAO"		, DTOC(TRB->C1_EMISSAO))
	oHtml:ValByName("cSOLICIT"		, CRDX050Usr(TRB->C1_USER)) //TRB->C1_SOLICIT)
	oHtml:ValByName("cCODUSR"		, iif(empty(TRB->C1_USER),RetCodUsr(),TRB->C1_USER))
	oHtml:ValByName("nDias"			, alltrim(str(nDias)))
	
	
	//	oHtml:ValByName("cSuper"		, cAprov)
	//	oHtml:ValByName("cAPROV"		, "")
	//	oHtml:ValByName("cMOTIVO"		, "")
	oHtml:ValByName("it.NUM"		, {})
	oHtml:ValByName("it.ITEM"		, {})
	oHtml:ValByName("it.PRODUTO"	, {})
	oHtml:ValByName("it.DESCRI"		, {})
	oHtml:ValByName("it.UM"			, {})
	oHtml:ValByName("it.QUANT"		, {})
	oHtml:ValByName("it.EMISSAO"		, {})
	oHtml:ValByName("it.DATPRF"		, {})
	oHtml:ValByName("it.OBS"		, {})
	oHtml:ValByName("it.CC"			, {})
	
	dbSelectArea("TRB")
	dbGoTop()
	cLegenda :=''
	While !EOF()
		aadd(oHtml:ValByName("it.NUM")        ,TRB->C1_NUM		                           ) //Item Cotacao
		aadd(oHtml:ValByName("it.ITEM")       ,TRB->C1_ITEM		                        ) //Item Cotacao
		aadd(oHtml:ValByName("it.PRODUTO")    ,TRB->C1_PRODUTO		                     ) //Cod Produto
		aadd(oHtml:ValByName("it.DESCRI")     ,TRB->C1_DESCRI                       		) //Descricao Produto
		aadd(oHtml:ValByName("it.UM")         ,TRB->C1_UM			                        ) //Unidade Medida
		aadd(oHtml:ValByName("it.QUANT")      ,TRANSFORM( TRB->C1_QUANT,'@E 999,999.99'  )) //Quantidade Solicitada
		aadd(oHtml:ValByName("it.EMISSAO")    ,DTOC(TRB->C1_EMISSAO)                     ) //Data da Necessidade
		aadd(oHtml:ValByName("it.DATPRF")     ,DTOC(TRB->C1_DATPRF)                      ) //Data da Necessidade
		aadd(oHtml:ValByName("it.OBS")        ,TRB->C1_XXOBS	                           ) //Observacao
		aadd(oHtml:ValByName("it.CC")         ,TRB->C1_CC		                         	) //Centro de Custo
		dbSkip()
	End
	
	//envia o e-mail
	
	/*
	DbSelectArea("WF7")
	DbGoTop()
	//oHtmlDet:savefile(cAttachFile)
	cEmpAnt :='01'
	cmailid       := oProcess:FProcessId
	chtmlfile1    := cmailid + ".htm"
	
	cmailid          := oProcess:Start("\web\compras\" + cEmpAnt + "\")
	cmailto          := "mailto:" + AllTrim(WF7->WF7_ENDERE)
	chtmltexto     := wfloadfile("\web\compras\"+cEmpAnt+"\" + cmailid + ".htm")
	_lTeste          := GetNewPar("MV_WFTST", .T.)
	chtmltexto     := strtran(chtmltexto, cmailto, "WFHTTPRET.APL")
	//	chtmltexto     := strtran(chtmltexto, cVarLink, "")
	wfsavefile("\web\compras\"+cEmpAnt+"\" + chtmlfile1, chtmltexto) // grava novamente com as alteracoes necessarias.
	*/
	//	RastreiaWF( ID do Processo, Codigo do Processo, Codigo do Status, Descricao Especifica, Usuario )
	oProcess:Start()
	//	RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,"000004","1001","ENVIO DE WORKFLOW PARA APROVACAO DE SC",cUsername)
	
	oProcess:Free()
	oProcess:= Nil
	
	PutMv("MV_WFHTML",cMvAtt)
	
	TRB->(dbCloseArea())
	
	//	WFSendMail({"01","01"}) //for็a o envio de todos os e-mails parados na caixa de saida
	
Else
	TRB->(dbCloseArea())
	
EndIf

Return

//retorna nome do ususแrio
Static Function CRDX050Usr(cCodUser)
Local aArea		:= GetArea() 	//Salva a area atual
Local cName    	:= ""			//Nome do usuario

PswOrder(1)
If	!Empty(cCodUser) .And. PswSeek(cCodUser)
	cName := PswRet(1)[1][2]
Else
	cName := SPACE(15)
EndIf

RestArea(aArea)

Return cName
