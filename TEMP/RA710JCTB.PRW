#INCLUDE "TBICONN.CH"
#INCLUDE "MATA710.CH"
#INCLUDE "PROTHEUS.CH" 
                                                       
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A710JobC1 ³ Autor ³Rodrigo de A Sartorio  ³ Rev. ³24.05.2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Job para processamento de solicitacoes de compra - SC1       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cEmp     - Empresa                                           ³±±
±±³          ³cFil     - Filial                                            ³±±
±±³          ³aParamJob- Array com parametros para JOB                     ³±±
±±³          ³[1]      - Numero do calculo de MRP                          ³±±
±±³          ³[2]      - Tipo de calculo MRP                               ³±±
±±³          ³[3]      - Array com os periodos                             ³±±
±±³          ³[4]      - Array com as perguntas                            ³±±
±±³          ³[5]      - String com tipos a serem processados              ³±±
±±³          ³[6]      - String com grupos a serem processados             ³±±
±±³          ³[7]      - Indica se deve processar query ou nao             ³±±
±±³          ³[8]      - Alias da tabela a ser processada                  ³±±
±±³          ³[9]      - Almoxarifado de (utilizado para filtro)           ³±±
±±³          ³[10]     - Almoxarifado ate(utilizado para filtro)           ³±±            
±±³          ³[11]     - Query para filtragem de produtos no SB1           ³±±            
±±³          ³[12]     - Indica a existencia de P.E. na filtragem (SQL)    ³±±            
±±³          ³[13]     - Indica a existencia de P.E. na filtragem (CDX)    ³±±            
±±³          ³[14]     - Opcional vazio                                    ³±±            
±±³          ³[15]     - Revisao vazio                                     ³±±
±±³          ³[16]     - Indica se gera log                                ³±±
±±³          ³[17]     - Considera pre req. - MV_MRPSCRE 				   ³±±
±±³          ³[18]     - Array com os grupos de produto 				   ³±±
±±³          ³[19]     - Considera grupos na query - MV_MRPCINQ			   ³±±
±±³          ³nTentativa - Numero da tentativa para chamada do JOB         ³±±            
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XA710JobC1(cEmp,cFil,aParamJob,nTentativa,cFileJob)
LOCAL cQuery:="",cA710Fil:=""
LOCAL cTmp  :="",nInd:=0
LOCAL nRecno:=0              
Local nHd:=0
LOCAL c711NumMRP:=aParamJob[1]
LOCAL nTipo     :=aParamJob[2]
LOCAL aPeriodos :=aParamJob[3]
LOCAL aPergs711 :=aParamJob[4]
LOCAL cStrTipo  :=aParamJob[5]
LOCAL cStrGrupo :=aParamJob[6]
LOCAL lQuery    :=aParamJob[7]
LOCAL cAliasTop :=aParamJob[8]
LOCAL cAlmoxd   :=aParamJob[9]
LOCAL cAlmoxa   :=aParamJob[10]
LOCAL cQueryB1  :=aParamJob[11]
LOCAL lA710Sql  :=aParamJob[12]
LOCAL lA710Fil  :=aParamJob[13]
LOCAL cOpc711Vaz:=aParamJob[14]
LOCAL cRev711Vaz:=aParamJob[15]
LOCAL lLogMRP   :=aParamJob[16]
LOCAL lConsPreRe:=aParamJob[17]
LOCAL A711Grupo	:=aParamJob[18]
LOCAL lMRPCINQ	:=aParamJob[19]
LOCAL lAllGrp	:=Ascan(A711Grupo,{|x| x[1] == .F.}) == 0 

PRIVATE nQuantPer := Len(aPeriodos)

nHd := FCreate(cFileJob)

// STATUS 1 - Iniciando execucao do Job
PutGlbValue("A710JobC1","1")
GlbUnLock()
           
// Seta job para nao consumir licensas
RpcSetType(3)

// Seta job para empresa filial desejada
RpcSetEnv( cEmp, cFil,,,'PCP')

// STATUS 2 - Conexao efetuada com sucesso
PutGlbValue("A710JobC1","2")
GlbUnLock()

Conout(STR0090+" A710JobC1 "+StrZero(nTentativa,2,0)) //"Processando thread"

If lQuery
	cQuery := "SELECT SC1.* ,SC1.R_E_C_N_O_ C1REC"
	If !lAllGrp .And. !lMRPCINQ
		cQuery += ",SB1.B1_GRUPO"
	EndIf
	cQuery += " FROM "+RetSqlName("SC1")+" SC1 , "+RetSqlName("SB1")+" SB1 "
	cQuery += "WHERE ((SC1.C1_FILIAL = '"+xFilial("SC1")+"' AND (SC1.C1_FILENT = '"+xFilial("SC1")+"' OR SC1.C1_FILENT = '')) OR "
	cQuery += "(SC1.C1_FILIAL <> '"+xFilial("SC1")+"' AND SC1.C1_FILENT = '"+xFilial("SC1")+"')) AND "
	cQuery += "SC1.C1_LOCAL>='"+cAlmoxd+"' AND "
	cQuery += "SC1.C1_LOCAL<='"+cAlmoxa+"' AND "
	cQuery += "SC1.C1_RESIDUO='" + CriaVar("C1_RESIDUO", .F.) + "' AND "
	cQuery += "SC1.C1_QUANT>SC1.C1_QUJE AND SC1.D_E_L_E_T_=' ' AND SC1.C1_PRODUTO = SB1.B1_COD "
	If !lConsPreRe
		cQuery += "AND SC1.C1_ORIGEM <> 'MATA106' "
	EndIf
	cQuery += cQueryB1
	
	If lA710SQL
		cA710Fil := ExecBlock("A710SQL", .F., .F., {"SC1", cQuery})
		If ValType(cA710Fil) == "C"
			cQuery := cA710Fil
		Endif
	Endif
	
	cQuery += "ORDER BY "+SqlOrder(SC1->(IndexKey(2)))
	cQuery := ChangeQuery(cQuery)
		
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)
	aEval(SC1->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField(cAliasTop,x[1],x[2],x[3],x[4]),Nil)})
EndIf
dbSelectArea(cAliasTop)

If !lQuery
	cTmp:=CriaTrab(,.F.)		
	dbSelectArea("SC1")
	dbSetOrder(1)
	cQuery := "((C1_FILIAL = '"+xFilial("SC1")+"' .And. (C1_FILENT = '"+xFilial("SC1")+"' .Or. Empty(C1_FILENT))) .Or. "
	cQuery += "(C1_FILIAL <> '"+xFilial("SC1")+"' .And. C1_FILENT = '"+xFilial("SC1")+"')) .And. "
	cQuery += "C1_LOCAL>='"+cAlmoxd+"'.And."
	cQuery += "C1_LOCAL<='"+cAlmoxa+"'.And."
	cQuery += "C1_QUANT>C1_QUJE .And."
	cQuery += "C1_RESIDUO=='"+Space(Len(SC1->C1_RESIDUO))+"'"
	If !lConsPreRe
		cQuery += ".And.Alltrim(C1_ORIGEM)<>'MATA106'"
	EndIf
	If lA710Fil
		cA710Fil := ExecBlock("A710FIL", .F., .F., {"SC1", cQuery})
		If ValType(cA710Fil) == "C"
			cQuery := cA710Fil
		Endif
	Endif	
	IndRegua("SC1",cTmp,IndexKey(),,cQuery)
	nInd := RetIndex("SC1")
	dbSetIndex(cTmp+OrdBagExt())
	dbSetOrder(nInd+1)
	dbGotop()
EndIf

If !Eof()
	// Abre tabelas necessarias
	U_XA710OpenFMRP(NIL,NIL,NIL,.T.)
	dbSelectArea(cAliasTop)
	While !Eof()
		If !lQuery
			If !M711AvalProd(C1_PRODUTO,cStrTipo,cStrGrupo) .Or. !A710FilMOP(C1_OP,aPergs711)
				dbSkip()
				Loop
			Else
				nRecno := Recno()
			EndIf
		Else
			If lQuery .And. ( !lAllGrp .And. !lMRPCINQ .And. !(cAliasTop)->B1_GRUPO $ cStrGrupo )
				dbSkip()
				Loop
			Else
				nRecno := C1REC
			EndIf
		Endif
		// Avalia o LOG do MRP para o evento 006 - Documento planejado em atraso
		A710CriaLOG("006",C1_PRODUTO,{C1_DATPRF,C1_NUM,C1_ITEM,"SC1"},lLogMRP,c711NumMRP)
		A711CriSH5(A710NextUtil(C1_DATPRF,aPergs711),C1_PRODUTO,cOpc711Vaz,cRev711Vaz,"SC1",nRecno,C1_NUM,C1_ITEM,C1_OP,Max(0,C1_QUANT-C1_QUJE),"2",.F.,nil,nil,.F.,.T.,aPeriodos,nTipo,c711NumMRP,cStrTipo,cStrGrupo)
		dbSelectArea(cAliasTop)
		dbSkip()
	End
Endif

dbSelectArea(cAliasTop)
If lQuery
	dbCloseArea()
	dbSelectArea("SC1")
Else
	RetIndex("SC1")
	dbClearFilter()
	Ferase(cTmp+OrdBagExt())
EndIf

// STATUS 3 - Processamento efetuado com sucesso
PutGlbValue("A710JobC1","3")
GlbUnLock()

FClose(nHd)
FErase(cFileJob)

RETURN

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A710JobC7 ³ Autor ³Rodrigo de A Sartorio  ³ Rev. ³24.05.2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Job para processamento de pedidos de compra - SC7            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cEmp     - Empresa                                           ³±±
±±³          ³cFil     - Filial                                            ³±±
±±³          ³aParamJob- Array com parametros para JOB                     ³±±
±±³          ³[1]      - Numero do calculo de MRP                          ³±±
±±³          ³[2]      - Tipo de calculo MRP                               ³±±
±±³          ³[3]      - Array com os periodos                             ³±±
±±³          ³[4]      - Array com as perguntas                            ³±±
±±³          ³[5]      - String com tipos a serem processados              ³±±
±±³          ³[6]      - String com grupos a serem processados             ³±±
±±³          ³[7]      - Indica se deve processar query ou nao             ³±±
±±³          ³[8]      - Alias da tabela a ser processada                  ³±±
±±³          ³[9]      - Almoxarifado de (utilizado para filtro)           ³±±
±±³          ³[10]     - Almoxarifado ate(utilizado para filtro)           ³±±            
±±³          ³[11]     - Query para filtragem de produtos no SB1           ³±±            
±±³          ³[12]     - Indica a existencia de P.E. na filtragem (SQL)    ³±±            
±±³          ³[13]     - Indica a existencia de P.E. na filtragem (CDX)    ³±±            
±±³          ³[14]     - Opcional vazio                                    ³±±            
±±³          ³[15]     - Revisao vazio                                     ³±±            
±±³          ³[16]     - Indica se gera log                                ³±±            
±±³          ³[17]     - Array com os grupos de produto 				   ³±±
±±³          ³[18]     - Considera grupos na query - MV_MRPCINQ			   ³±±
±±³          ³nTentativa - Numero da tentativa para chamada do JOB         ³±±            
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XA710JobC7(cEmp,cFil,aParamJob,nTentativa,cFileJob)
LOCAL cQuery:="",cA710Fil:=""
LOCAL cTmp  :="",nInd:=0
LOCAL nRecno:=0
LOCAL nHd:=0
LOCAL c711NumMRP:=aParamJob[1]
LOCAL nTipo     :=aParamJob[2]
LOCAL aPeriodos :=aParamJob[3]
LOCAL aPergs711 :=aParamJob[4]
LOCAL cStrTipo  :=aParamJob[5]
LOCAL cStrGrupo :=aParamJob[6]
LOCAL lQuery    :=aParamJob[7]
LOCAL cAliasTop :=aParamJob[8]
LOCAL cAlmoxd   :=aParamJob[9]
LOCAL cAlmoxa   :=aParamJob[10]
LOCAL cQueryB1  :=aParamJob[11]
LOCAL lA710Sql  :=aParamJob[12]
LOCAL lA710Fil  :=aParamJob[13]
LOCAL cOpc711Vaz:=aParamJob[14]
LOCAL cRev711Vaz:=aParamJob[15]
LOCAL lLogMRP   :=aParamJob[16]
LOCAL A711Grupo	:=aParamJob[17]
LOCAL lMRPCINQ	:=aParamJob[18]
LOCAL lAllGrp	:=Ascan(A711Grupo,{|x| x[1] == .F.}) == 0 

PRIVATE nQuantPer := Len(aPeriodos)

nHd := FCreate(cFileJob)

// STATUS 1 - Iniciando execucao do Job
PutGlbValue("A710JobC7","1")
GlbUnLock()

// Seta job para nao consumir licensas
RpcSetType(3)

// Seta job para empresa filial desejada
RpcSetEnv( cEmp, cFil,,,'PCP')

// STATUS 2 - Conexao efetuada com sucesso
PutGlbValue("A710JobC7","2")
GlbUnLock()

Conout(STR0090+" A710JobC7 "+StrZero(nTentativa,2,0)) //"Processando thread"

If lQuery
	cQuery := "SELECT SC7.* ,SC7.R_E_C_N_O_ C7REC"
	If !lAllGrp .And. !lMRPCINQ
		cQuery += ",SB1.B1_GRUPO"
	EndIf
	cQuery += " FROM "+RetSqlName("SC7")+" SC7 , "+RetSqlName("SB1")+" SB1 "
	cQuery += "WHERE ((SC7.C7_FILIAL = '"+xFilial("SC7")+"' AND (SC7.C7_FILENT = '"+xFilial("SC7")+"' OR SC7.C7_FILENT = '')) OR "
	cQuery += "(SC7.C7_FILIAL <> '"+xFilial("SC7")+"' AND SC7.C7_FILENT = '"+xFilial("SC7")+"')) AND "
	cQuery += "C7_LOCAL>='"+cAlmoxd+"' AND "
	cQuery += "C7_LOCAL<='"+cAlmoxa+"' AND "
	cQuery += "SC7.C7_QUJE < SC7.C7_QUANT AND "
	cQuery += "SC7.C7_RESIDUO  = '" + CriaVar("C7_RESIDUO", .F.) + "' AND "
	cQuery += "SC7.D_E_L_E_T_=' ' AND SC7.C7_PRODUTO = SB1.B1_COD "
	cQuery += cQueryB1
	
	If lA710SQL
		cA710Fil := ExecBlock("A710SQL", .F., .F., {"SC7", cQuery})
		If ValType(cA710Fil) == "C"
			cQuery := cA710Fil
		Endif
	EndIf
	
	cQuery += "ORDER BY "+SqlOrder(SC7->(IndexKey(2)))
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)
	aEval(SC7->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField(cAliasTop,x[1],x[2],x[3],x[4]),Nil)})
EndIf
dbSelectArea(cAliasTop)

If !lQuery
	cTmp:=CriaTrab(,.F.)		
	dbSelectArea("SC7")
	dbSetOrder(2)
	cQuery := "((C7_FILIAL = '"+xFilial("SC7")+"' .And. (C7_FILENT = '"+xFilial("SC7")+"' .Or. Empty(C7_FILENT))) .Or. "
	cQuery += "(C7_FILIAL <> '"+xFilial("SC7")+"' .And. C7_FILENT = '"+xFilial("SC7")+"')) .And. "
	cQuery += "C7_QUANT-C7_QUJE>0.And."
	cQuery += "C7_RESIDUO=='"+Space(Len(SC7->C7_RESIDUO))+"'.And."
	cQuery += "C7_LOCAL>='"+cAlmoxd+"'.And."
	cQuery += "C7_LOCAL<='"+cAlmoxa+"'"
	If lA710Fil
		cA710Fil := ExecBlock("A710FIL", .F., .F., {"SC7", cQuery})
		If ValType(cA710Fil) == "C"
			cQuery := cA710Fil
		Endif
	Endif	
	IndRegua("SC7",cTmp,IndexKey(),,cQuery)
	nInd := RetIndex("SC7")
	dbSetIndex(cTmp+OrdBagExt())
	dbSetOrder(nInd+1)
	dbGotop()
EndIf

If !Eof()
	// Abre tabelas necessarias
	U_XA710OpenFMRP(NIL,NIL,NIL,.T.)
	dbSelectArea(cAliasTop)
	While !Eof()
		If !lQuery
			If !M711AvalProd(C7_PRODUTO,cStrTipo,cStrGrupo) .Or. !A710FilMOP(C7_OP,aPergs711)
				dbSkip()
				Loop
			Else
				nRecno := Recno()
			EndIf
		Else
			If lQuery .And. ( !lAllGrp .And. !lMRPCINQ .And. !(cAliasTop)->B1_GRUPO $ cStrGrupo )
				dbSkip()
				Loop
			Else
				nRecno := C7REC
			EndIf
		Endif
		// Avalia o LOG do MRP para o evento 006 - Documento planejado em atraso
		A710CriaLOG("006",C7_PRODUTO,{C7_DATPRF,C7_NUM,C7_ITEM,"SC7"},lLogMRP,c711NumMRP)
		A711CriSH5(A710NextUtil(C7_DATPRF,aPergs711),C7_PRODUTO,cOpc711Vaz,cRev711Vaz,"SC7",nRecno,C7_NUM,C7_ITEM,C7_OP,Max(0,C7_QUANT-C7_QUJE),"2",.F.,nil,nil,.F.,.T.,aPeriodos,nTipo,c711NumMRP,cStrTipo,cStrGrupo)
		dbSelectArea(cAliasTop)
		dbSkip()
	End
EndIf
dbSelectArea(cAliasTop)
If lQuery
	dbCloseArea()
	dbSelectArea("SC7")
Else
	RetIndex("SC7")
	dbClearFilter()
	Ferase(cTmp+OrdBagExt())
EndIf

// STATUS 3 - Processamento efetuado com sucesso
PutGlbValue("A710JobC7","3")
GlbUnLock()

FClose(nHd)
FErase(cFileJob)

RETURN

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A710JobC2 ³ Autor ³Rodrigo de A Sartorio  ³ Rev. ³24.05.2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Job para processamento de ordens de producao - SC2           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cEmp     - Empresa                                           ³±±
±±³          ³cFil     - Filial                                            ³±±
±±³          ³aParamJob- Array com parametros para JOB                     ³±±
±±³          ³[1]      - Numero do calculo de MRP                          ³±±
±±³          ³[2]      - Tipo de calculo MRP                               ³±±
±±³          ³[3]      - Array com os periodos                             ³±±
±±³          ³[4]      - String com tipos a serem processados              ³±±
±±³          ³[5]      - String com grupos a serem processados             ³±±
±±³          ³[6]      - Indica se deve processar query ou nao             ³±±
±±³          ³[7]      - Alias da tabela a ser processada                  ³±±
±±³          ³[8]      - Almoxarifado de (utilizado para filtro)           ³±±
±±³          ³[9]      - Almoxarifado ate(utilizado para filtro)           ³±±            
±±³          ³[10]     - Query para filtragem de produtos no SB1           ³±±            
±±³          ³[11]     - Indica a existencia de P.E. na filtragem (SQL)    ³±±            
±±³          ³[12]     - Indica a existencia de P.E. na filtragem (CDX)    ³±±            
±±³          ³[13]     - Indica se considera OPs suspensas                 ³±±            
±±³          ³[14]     - Indica se considera OPs sacramentadas             ³±±            
±±³          ³[15]     - Indica se gera log                                ³±±
±±³          ³[16]     - Array com as perguntas                            ³±±
±±³          ³[17]     - Array com os grupos de produto 				   ³±±
±±³          ³[18]     - Considera grupos na query - MV_MRPCINQ			   ³±±
±±³          ³nTentativa - Numero da tentativa para chamada do JOB         ³±±            
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XA710JobC2(cEmp,cFil,aParamJob,nTentativa,cFileJob,lUsaMOpc)
LOCAL cQuery:="",cA710Fil:=""
LOCAL cTmp  :="",nInd:=0
LOCAL nRecno:=0               
LOCAL nHd:=0
LOCAL lPerdInf := .F.
LOCAL c711NumMRP:=aParamJob[1]
LOCAL nTipo    :=aParamJob[2]
LOCAL aPeriodos:=aParamJob[3]
LOCAL cStrTipo :=aParamJob[4]
LOCAL cStrGrupo:=aParamJob[5]
LOCAL lQuery   :=aParamJob[6]
LOCAL cAliasTop:=aParamJob[7]
LOCAL cAlmoxd  :=aParamJob[8]
LOCAL cAlmoxa  :=aParamJob[9]
LOCAL cQueryB1 :=aParamJob[10]
LOCAL lA710Sql :=aParamJob[11]
LOCAL lA710Fil :=aParamJob[12]
LOCAL lConsSusp:=aParamJob[13]
LOCAL lConsSacr:=aParamJob[14]
LOCAL lLogMRP  :=aParamJob[15]
LOCAL aPergs711:=aParamJob[16]
LOCAL A711Grupo:=aParamJob[17]
LOCAL lMRPCINQ :=aParamJob[18]
LOCAL lAllGrp  :=Ascan(A711Grupo,{|x| x[1] == .F.}) == 0 

PRIVATE nQuantPer := Len(aPeriodos)

nHd := FCreate(cFileJob)

// STATUS 1 - Iniciando execucao do Job
PutGlbValue("A710JobC2","1")
GlbUnLock()

// Seta job para nao consumir licensas
RpcSetType(3)

// Seta job para empresa filial desejada
RpcSetEnv( cEmp, cFil,,,'PCP')

// STATUS 2 - Conexao efetuada com sucesso
PutGlbValue("A710JobC2","2")
GlbUnLock()

Conout(STR0090+" A710JobC2 "+StrZero(nTentativa,2,0))  //"Processando thread"

If lQuery
	If !lUsaMOpc
		cQuery := "SELECT C2_FILIAL,C2_DATRF,C2_LOCAL,C2_PRODUTO,C2_STATUS,C2_DATPRF,C2_OPC,C2_NUM,C2_ITEM,C2_SEQUEN,"
	Else 
		cQuery := "SELECT C2_FILIAL,C2_DATRF,C2_LOCAL,C2_PRODUTO,C2_STATUS,C2_DATPRF,C2_NUM,C2_ITEM,C2_SEQUEN,"
	EndIf
	cQuery += "C2_ITEMGRD,C2_PEDIDO,C2_ITEMPV,C2_QUANT,C2_QUJE,C2_PERDA,C2_REVISAO,SC2.R_E_C_N_O_ C2REC"
	If !lAllGrp .And. !lMRPCINQ
		cQuery += ",SB1.B1_GRUPO"
	EndIf
	cQuery += " FROM "+RetSqlName("SC2")+" SC2 , "+RetSqlName("SB1")+" SB1 WHERE SC2.C2_FILIAL='"+xFilial("SC2")+"' AND "
	cQuery += "SC2.C2_DATRF = '" + Space(Len(DTOS(SC2->C2_DATRF))) + "' AND "
	cQuery += "SC2.C2_LOCAL >= '" + cAlmoxd + "' AND "
	cQuery += "SC2.C2_LOCAL <= '" + cAlmoxa + "' AND "
	cQuery += "SC2.D_E_L_E_T_=' ' AND SC2.C2_PRODUTO = SB1.B1_COD "
	// Inclui condicao se nao considera OPs Suspensas
	If !lConsSusp
		cQuery += "AND C2_STATUS <> 'U' "
	EndIf
	// Inclui condicao se nao considera OPs Sacramentadas
	If !lConsSacr
		cQuery += "AND C2_STATUS <> 'S' "
	EndIf
	cQuery += cQueryB1
	
	If lA710SQL
		cA710Fil := ExecBlock("A710SQL", .F., .F., {"SC2", cQuery})
		If ValType(cA710Fil) == "C"
			cQuery := cA710Fil
		Endif
	Endif
	
	cQuery += "ORDER BY "+SqlOrder(SC2->(IndexKey(2)))
	cQuery := ChangeQuery(cQuery)
			
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)
	aEval(SC2->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField(cAliasTop,x[1],x[2],x[3],x[4]),Nil)})
EndIf
dbSelectArea(cAliasTop)

If !lQuery
	cTmp:=CriaTrab(,.F.)		
	dbSelectArea("SC2")
	dbSetOrder(2)
	cQuery := "C2_FILIAL=='"+xFilial("SC2")+"'.And."
	cQuery += "Dtos(C2_DATRF)=='"+Space(8)+"'.And."
	cQuery += "C2_LOCAL>='"+cAlmoxd+"'.And."
	cQuery += "C2_LOCAL<='"+cAlmoxa+"'"
	// Inclui condicao se nao considera OPs Suspensas
	If !lConsSusp
		cQuery += ".And.C2_STATUS!='U'"
	EndIf
	// Inclui condicao se nao considera OPs Sacramentadas
	If !lConsSacr
		cQuery += ".And.C2_STATUS!='S'"
	EndIf
	If lA710Fil
		cA710Fil := ExecBlock("A710FIL", .F., .F., {"SC2", cQuery})
		If ValType(cA710Fil) == "C"
			cQuery := cA710Fil
		Endif
	Endif		
	IndRegua("SC2",cTmp,Indexkey(),,cQuery)
	nInd := RetIndex("SC2")
	dbSetIndex(cTmp+OrdBagExt())
	dbSetOrder(nInd+1)
	dbGotop()
EndIf

If !Eof()
	// Abre tabelas necessarias
	U_XA710OpenFMRP(NIL,NIL,NIL,.T.)
	dbSelectArea(cAliasTop)
	lPerdInf := SuperGetMV("MV_PERDINF",.F.,.F.)
	While !Eof()
		If !lQuery
			If !M711AvalProd(C2_PRODUTO,cStrTipo,cStrGrupo)
				dbSkip()
				Loop
			Else
				nRecno := Recno()
			EndIf
		Else
			If lQuery .And. ( !lAllGrp .And. !lMRPCINQ .And. !(cAliasTop)->B1_GRUPO $ cStrGrupo )
				dbSkip()
				Loop
			Else
				nRecno := C2REC
			EndIf
		Endif
		// Avalia o LOG do MRP para o evento 006 - Documento planejado em atraso
		A710CriaLOG("006",C2_PRODUTO,{C2_DATPRF,C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD,"","SC2"},lLogMRP,c711NumMRP)
		If lUsaMOpc
			SC2->(DbGoTo(nRecno))	
			A711CriSH5(A710NextUtil(C2_DATPRF,aPergs711),C2_PRODUTO,SC2->C2_MOPC, C2_REVISAO,"SC2",nRecno,C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD,"",If(!Empty(C2_PEDIDO),C2_PEDIDO+"/"+C2_ITEMPV,""),Max(0,C2_QUANT-C2_QUJE-If(lPerdInf,0,C2_PERDA)),"2",.F., .T.,NIL,.F.,.T.,aPeriodos,nTipo,c711NumMRP,cStrTipo,cStrGrupo)
		Else 
			A711CriSH5(A710NextUtil(C2_DATPRF,aPergs711),C2_PRODUTO,C2_OPC, C2_REVISAO,"SC2",nRecno,C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD,"",If(!Empty(C2_PEDIDO),C2_PEDIDO+"/"+C2_ITEMPV,""),Max(0,C2_QUANT-C2_QUJE-If(lPerdInf,0,C2_PERDA)),"2",.F., .T.,NIL,.F.,.T.,aPeriodos,nTipo,c711NumMRP,cStrTipo,cStrGrupo)
		EndIf
		dbSelectArea(cAliasTop)
		dbSkip()
	End
Endif
If lQuery
	dbSelectArea(cAliasTop)
	dbCloseArea()
	dbSelectArea("SC2")
Else
	RetIndex("SC2")
	dbClearFilter()
	Ferase(cTmp+OrdBagExt())
EndIf	

// STATUS 3 - Processamento efetuado com sucesso
PutGlbValue("A710JobC2","3")
GlbUnLock()

FClose(nHd)
FErase(cFileJob)

RETURN

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A710JobD4 ³ Autor ³Rodrigo de A Sartorio  ³ Rev. ³24.05.2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Job para processamento de empenhos - SD4                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cEmp     - Empresa                                           ³±±
±±³          ³cFil     - Filial                                            ³±±
±±³          ³aParamJob- Array com parametros para JOB                     ³±±
±±³          ³[1]      - Numero do calculo de MRP                          ³±±
±±³          ³[2]      - Tipo de calculo MRP                               ³±±
±±³          ³[3]      - Array com os periodos                             ³±±
±±³          ³[4]      - Array com as perguntas                            ³±±
±±³          ³[5]      - String com tipos a serem processados              ³±±
±±³          ³[6]      - String com grupos a serem processados             ³±±
±±³          ³[7]      - Indica se deve processar query ou nao             ³±±
±±³          ³[8]      - Alias da tabela a ser processada                  ³±±
±±³          ³[9]      - Almoxarifado de (utilizado para filtro)           ³±±
±±³          ³[10]     - Almoxarifado ate(utilizado para filtro)           ³±±            
±±³          ³[11]     - Query para filtragem de produtos no SB1           ³±±            
±±³          ³[12]     - Indica a existencia de P.E. na filtragem (SQL)    ³±±            
±±³          ³[13]     - Indica a existencia de P.E. na filtragem (CDX)    ³±±            
±±³          ³[14]     - Opcional vazio                                    ³±±            
±±³          ³[15]     - Revisao vazio                                     ³±±            
±±³          ³[16]     - Indica se gera log                                ³±±
±±³          ³[17]     - Array com os grupos de produto 				   ³±±
±±³          ³[18]     - Considera grupos na query - MV_MRPCINQ			   ³±±
±±³          ³nTentativa - Numero da tentativa para chamada do JOB         ³±±            
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XA710JobD4(cEmp,cFil,aParamJob,nTentativa,cFileJob)
LOCAL cQuery:=""
LOCAL cTmp  :="",nInd:=0
LOCAL nRecno:=0              
LOCAl nHd:=0
LOCAL c711NumMRP:=aParamJob[1]
LOCAL nTipo     :=aParamJob[2]
LOCAL aPeriodos :=aParamJob[3]
LOCAL aPergs711 :=aParamJob[4]
LOCAL cStrTipo  :=aParamJob[5]
LOCAL cStrGrupo :=aParamJob[6]
LOCAL lQuery    :=aParamJob[7]
LOCAL cAliasTop :=aParamJob[8]
LOCAL cAlmoxd   :=aParamJob[9]
LOCAL cAlmoxa   :=aParamJob[10]
LOCAL cQueryB1  :=aParamJob[11]
LOCAL lA710Sql  :=aParamJob[12]
LOCAL lA710Fil  :=aParamJob[13]
LOCAL cOpc711Vaz:=aParamJob[14]
LOCAL cRev711Vaz:=aParamJob[15]
LOCAL lLogMRP   :=aParamJob[16]
LOCAL A711Grupo	:=aParamJob[17]
LOCAL lMRPCINQ	:=aParamJob[18]
LOCAL lAllGrp 	:=Ascan(A711Grupo,{|x| x[1] == .F.}) == 0 

PRIVATE nQuantPer := Len(aPeriodos)

nHd := FCreate(cFileJob)

// STATUS 1 - Iniciando execucao do Job
PutGlbValue("A710JobD4","1")
GlbUnLock()

// Seta job para nao consumir licensas
RpcSetType(3)

// Seta job para empresa filial desejada
RpcSetEnv( cEmp, cFil,,,'PCP')

// STATUS 2 - Conexao efetuada com sucesso
PutGlbValue("A710JobD4","2")
GlbUnLock()

Conout(STR0090+" A710JobD4 "+StrZero(nTentativa,2,0))  //"Processando thread"

If lQuery
	cQuery := "SELECT SD4.* ,SD4.R_E_C_N_O_ D4REC"
	If !lAllGrp .And. !lMRPCINQ
		cQuery += ",SB1.B1_GRUPO"
	EndIf
	cQuery += " FROM "+RetSqlName("SD4")+" SD4 , "+RetSqlName("SB1")+" SB1 "
	cQuery += "WHERE SD4.D4_FILIAL='"+xFilial("SD4")+"' AND "
	cQuery += "SD4.D4_QUANT <> 0 AND "
	cQuery += "SD4.D4_LOCAL >= '" + cAlmoxd + "' AND "
	cQuery += "SD4.D4_LOCAL <= '" + cAlmoxa + "' AND "
	If !(aPergs711[13]==1)
		cQuery += "(SD4.D4_QUANT-SD4.D4_QSUSP) <> 0 AND "
	EndIf
	cQuery += "SD4.D_E_L_E_T_=' ' AND SD4.D4_COD = SB1.B1_COD "
	cQuery += cQueryB1
	
	If lA710SQL
		cA710Fil := ExecBlock("A710SQL", .F., .F., {"SD4", cQuery})
		If ValType(cA710Fil) == "C"
			cQuery := cA710Fil
		Endif
	Endif
	
	cQuery += "ORDER BY "+SqlOrder(SD4->(IndexKey(1)))
	cQuery := ChangeQuery(cQuery)
		
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)
	aEval(SD4->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField(cAliasTop,x[1],x[2],x[3],x[4]),Nil)})
EndIf
dbSelectArea(cAliasTop)

If !lQuery
	cTmp:=CriaTrab(,.F.)		
	dbSelectArea("SD4")
	dbSetOrder(1)
	cQuery := "D4_FILIAL=='"+xFilial("SD4")+"'.And."
	cQuery += "D4_QUANT > 0 .And."
	cQuery += "D4_LOCAL>='"+cAlmoxd+"'.And."
	cQuery += "D4_LOCAL<='"+cAlmoxa+"'"
	If !(aPergs711[13]==1)
		cQuery+= ".And.(D4_QUANT-D4_QSUSP)>0"
	EndIf
	IndRegua("SD4",cTmp,Indexkey(),,cQuery)
	nInd := RetIndex("SD4")
	dbSetIndex(cTmp+OrdBagExt())
	dbSetOrder(nInd+1)
	dbGotop()
EndIf

If !Eof()
	// Abre tabelas necessarias
	U_XA710OpenFMRP(NIL,NIL,NIL,.T.)
	dbSelectArea(cAliasTop)
	While !Eof()
		If !lQuery
			If !M711AvalProd(D4_COD,cStrTipo,cStrGrupo) .Or. !A710FilMOP(D4_OP,aPergs711)
				dbSkip()
				Loop
			Else
				nRecno := Recno()
			EndIf
		Else
			If lQuery .And. ( !lAllGrp .And. !lMRPCINQ .And. !(cAliasTop)->B1_GRUPO $ cStrGrupo )
				dbSkip()
				Loop
			Else
				nRecno := D4REC
			EndIf
		Endif
		// Posiciona na OP geradora do EMPENHO
		If !Empty((cAliasTop)->D4_OPORIG)
			SC2->(dbSetOrder(1))
			SC2->(dbSeek(xFilial("SC2")+(cAliasTop)->D4_OPORIG))
		Else
			SC2->(dbSetOrder(1))
			SC2->(dbSeek(xFilial("SC2")+(cAliasTop)->D4_OP))
		EndIf
		dbSelectArea(cAliasTop)
		// Avalia o LOG do MRP para o evento 006 - Documento planejado em atraso em atraso
		A710CriaLOG("006",D4_COD,{D4_DATA,D4_OP,D4_TRT,"SD4"},lLogMRP,c711NumMRP)
		A711CriSH5(A710NextUtil(D4_DATA,aPergs711),D4_COD,SC2->C2_OPC,If(!Empty(D4_OPORIG) .And. !(SC2->(Eof())),SC2->C2_REVISAO,cRev711Vaz),If(D4_QUANT>0,"SD4","ENG"),nRecno,D4_OP,"",D4_OP,Abs(D4_QUANT),If(D4_QUANT>0,"3","2"),.F., .T.,NIL,.F.,.T.,aPeriodos,nTipo,c711NumMRP,cStrTipo,cStrGrupo)
		dbSelectArea(cAliasTop)
		dbSkip()
	End
EndIf
If lQuery
	dbSelectArea(cAliasTop)
	dbCloseArea()
	dbSelectArea("SD4")
Else
	RetIndex("SD4")
	dbClearFilter()
	Ferase(cTmp+OrdBagExt())
EndIf	

// STATUS 3 - Processamento efetuado com sucesso
PutGlbValue("A710JobD4","3")
GlbUnLock()

FClose(nHd)
FErase(cFileJob)

RETURN

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A710JobC6 ³ Autor ³Rodrigo de A Sartorio  ³ Rev. ³24.05.2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Job para processamento de pedidos de venda - SC6             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cEmp     - Empresa                                           ³±±
±±³          ³cFil     - Filial                                            ³±±
±±³          ³aParamJob- Array com parametros para JOB                     ³±±
±±³          ³[1]      - Numero do calculo de MRP                          ³±±
±±³          ³[2]      - Tipo de calculo MRP                               ³±±
±±³          ³[3]      - Array com os periodos                             ³±±
±±³          ³[4]      - Array com as perguntas                            ³±±
±±³          ³[5]      - String com tipos a serem processados              ³±±
±±³          ³[6]      - String com grupos a serem processados             ³±±
±±³          ³[7]      - Indica se deve processar query ou nao             ³±±
±±³          ³[8]      - Alias da tabela a ser processada                  ³±±
±±³          ³[9]      - Almoxarifado de (utilizado para filtro)           ³±±
±±³          ³[10]     - Almoxarifado ate(utilizado para filtro)           ³±±            
±±³          ³[11]     - Query para filtragem de produtos no SB1           ³±±            
±±³          ³[12]     - Indica a existencia de P.E. na filtragem (SQL)    ³±±            
±±³          ³[13]     - Indica a existencia de P.E. na filtragem (CDX)    ³±±            
±±³          ³[14]     - Considera pedido de venda bloqueado credito       ³±±            
±±³          ³[15]     - Dados para bloqueio 1                             ³±±            
±±³          ³[16]     - Dados para bloqueio 2                             ³±±
±±³          ³[17]     - Indica se processa dados do SC4                   ³±±
±±³          ³[18]     - Revisao vazio                                     ³±±            
±±³          ³[19]     - Indica se gera log                                ³±±
±±³          ³[20]     - Indica se considera pedidos de venda no MRP       ³±±
±±³          ³[21]     - Array com os grupos de produto 				   ³±±
±±³          ³[22]     - Considera grupos na query - MV_MRPCINQ			   ³±±
±±³          ³nTentativa - Numero da tentativa para chamada do JOB         ³±±            
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XA710JobC6(cEmp,cFil,aParamJob,nTentativa,cFileJob,lUsaMOpc)
LOCAL cQuery := "", cA710Fil := ""
LOCAL cTmp := "", nInd := 0
LOCAL nRecno := 0
LOCAL i := 0
LOCAL nHd := 0
LOCAL aPedidosAc := {{}}, nAchouPed := 0
LOCAL nQtdPed := 0
LOCAL c711NumMRP := aParamJob[1]
LOCAL nTipo := aParamJob[2]
LOCAL aPeriodos := aParamJob[3]
LOCAL aPergs711 := aParamJob[4]
LOCAL cStrTipo	:= aParamJob[5]
LOCAL cStrGrupo := aParamJob[6]
LOCAL lQuery	:= aParamJob[7]
LOCAL cAliasTop	:= aParamJob[8]
LOCAL cAlmoxd	:= aParamJob[9]
LOCAL cAlmoxa	:= aParamJob[10]
LOCAL cQueryB1	:= aParamJob[11]
LOCAL lA710Sql	:= aParamJob[12]
LOCAL lA710Fil	:= aParamJob[13]
LOCAL lPedBloc	:= aParamJob[14]
LOCAL cComp1	:= aParamJob[15]
LOCAL cComp2	:= aParamJob[16]
LOCAL lProcSC4	:= aParamJob[17]
LOCAL cRev711Vaz:= aParamJob[18]
LOCAL lLogMRP	:= aParamJob[19]
LOCAL lCarteira := aParamJob[20]
LOCAL A711Grupo	:= aParamJob[21]
LOCAL lMRPCINQ	:= aParamJob[22]
LOCAL lAllGrp	:= Ascan(A711Grupo,{|x| x[1] == .F.}) == 0

PRIVATE nQuantPer := Len(aPeriodos)

nHd := FCreate(cFileJob)

// STATUS 1 - Iniciando execucao do Job
PutGlbValue("A710JobC6","1")
GlbUnLock()

// Seta job para nao consumir licensas
RpcSetType(3)

// Seta job para empresa filial desejada
RpcSetEnv( cEmp, cFil,,,'PCP')

// STATUS 2 - Conexao efetuada com sucesso
PutGlbValue("A710JobC6","2")
GlbUnLock()

Conout(STR0090+" A710JobC6 "+StrZero(nTentativa,2,0))  //"Processando thread"

If lQuery
	cAliasTop := GetNextAlias()
	cQuery := "SELECT C6_BLQ, C6_ITEM, C6_FILIAL, C6_QTDVEN, C6_QTDENT, C6_LOCAL, "
	If lUsaMOpc
		cQuery += "C6_PRODUTO, C6_TES, C6_ENTREG, C6_NUM, C6_OP, C6_OPC, C6_REVISAO, SC6.R_E_C_N_O_ C6REC"
	Else
		cQuery += "C6_PRODUTO, C6_TES, C6_ENTREG, C6_NUM, C6_OP, C6_OPC, C6_REVISAO, SC6.R_E_C_N_O_ C6REC"
	EndIf 
	If !lAllGrp .And. !lMRPCINQ
		cQuery += ",SB1.B1_GRUPO"
	EndIf
	cQuery += " FROM "+RetSqlName("SC6")+" SC6 , "+RetSqlName("SB1")+" SB1 ,"+RetSqlName("SF4")+" SF4 "	
	cQuery += "WHERE SC6.C6_FILIAL='"+xFilial("SC6")+"' AND "
	If !lCarteira
		cQuery += "SC6.C6_QTDENT > 0 AND "
	EndIf
	If aPergs711[30] == 2
		cQuery += "SC6.C6_QTDENT < SC6.C6_QTDVEN AND "
	EndIf
	cQuery += "C6_LOCAL >= '"+cAlmoxd+"' AND "
	cQuery += "C6_LOCAL <= '"+cAlmoxa+"' AND "
	If !lPedBloc
		cQuery += "C6_OP <> '02' AND "
	EndIf
	cQuery += "(C6_BLQ ='"+cComp1+"' OR C6_BLQ ='"+cComp2+"') AND SC6.D_E_L_E_T_=' ' AND SC6.C6_PRODUTO = SB1.B1_COD AND "
	cQuery += "SF4.F4_FILIAL='"+xFilial("SF4")+"' AND SF4.F4_CODIGO = SC6.C6_TES  AND SF4.F4_ESTOQUE = 'S' AND "
	cQuery += "SF4.D_E_L_E_T_=' ' "
	cQuery += cQueryB1
	
	If lA710SQL
		cA710Fil := ExecBlock("A710SQL", .F., .F., {"SC6", cQuery})
		If ValType(cA710Fil) == "C"
			cQuery := cA710Fil
		Endif
	Endif
	
	cQuery += "ORDER BY "+SqlOrder(SC6->(IndexKey(2)))
	cQuery := ChangeQuery(cQuery)
		
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)
	aEval(SC6->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField(cAliasTop,x[1],x[2],x[3],x[4]),Nil)})
EndIf
dbSelectArea(cAliasTop)

If !lQuery
	cTmp:=CriaTrab(,.F.)		
	dbSelectArea("SC6")
	dbSetOrder(2)
	cQuery := "C6_FILIAL=='"+xFilial("SC6")+"'.And."
	cQuery += "(C6_BLQ=='"+cComp1+"'.Or.C6_BLQ=='"+cComp2+"').And."
	cQuery += "C6_LOCAL>='"+cAlmoxd+"'.And."
	cQuery += "C6_LOCAL<='"+cAlmoxa+"'.And."
	If !lPedBloc
		cQuery += "C6_OP <> '02' .And."
	EndIf
	cQuery += "((C6_QTDVEN-C6_QTDENT)>0)"
	If lA710Fil
		cA710Fil := ExecBlock("A710FIL", .F., .F., {"SC6", cQuery})
		If ValType(cA710Fil) == "C"
			cQuery := cA710Fil
		Endif
	Endif	
	IndRegua("SC6",cTmp,IndexKey(),,cQuery)
	nInd := RetIndex("SC6")
	dbSetIndex(cTmp+OrdBagExt())
	dbSetOrder(nInd+1)
	dbGotop()
EndIf

If !Eof()
	// Abre tabelas necessarias
	U_XA710OpenFMRP(NIL,NIL,NIL,.T.)
	dbSelectArea(cAliasTop)
	While !Eof()
		SF4->( dbSetOrder(1) )
		SF4->( dbSeek(xFilial("SF4")+(cAliasTop)->C6_TES) )
		dbSelectArea(cAliasTop)
		If !lQuery
			If SF4->F4_ESTOQUE # "S" .Or. !M711AvalProd(C6_PRODUTO,cStrTipo,cStrGrupo)
				dbSkip()
				Loop
			Else
				nRecno := Recno()
			EndIf
		Else
			If lQuery .And. ( !lAllGrp .And. !lMRPCINQ .And. !(cAliasTop)->B1_GRUPO $ cStrGrupo )
				dbSkip()
				Loop
			Else
				nRecno := C6REC
			EndIf
		Endif
		// Avalia o LOG do MRP para o evento 006 - Documento planejado em atraso em atraso
		If C6_QTDENT < C6_QTDVEN
			A710CriaLOG("006",C6_PRODUTO,{C6_ENTREG,C6_NUM,C6_ITEM,"SC6"},lLogMRP,c711NumMRP)
			If lUsaMOpc
				SC6->(DbGoTo(nRecno))
				A711CriSH5(A710NextUtil(C6_ENTREG,aPergs711),C6_PRODUTO,SC6->C6_MOPC,C6_REVISAO,"SC6",nRecno,C6_NUM,C6_ITEM,"",Max(0,C6_QTDVEN-C6_QTDENT),"3",.F.,.T.,NIL,.F.,.T.,aPeriodos,nTipo,c711NumMRP,cStrTipo,cStrGrupo)
			Else
				A711CriSH5(A710NextUtil(C6_ENTREG,aPergs711),C6_PRODUTO,C6_OPC,C6_REVISAO,"SC6",nRecno,C6_NUM,C6_ITEM,"",Max(0,C6_QTDVEN-C6_QTDENT),"3",.F.,.T.,NIL,.F.,.T.,aPeriodos,nTipo,c711NumMRP,cStrTipo,cStrGrupo)
			EndIf
		EndIf
		dbSelectArea(cAliasTop)
		// Array utilizado na integracao com previsao de venda - Subtrai quantidade dos pedidos ja colocados								
		If lProcSC4
			// Incrementa array com totais de pedidos por periodo
			If Len(aPedidosAc[Len(aPedidosAc)]) > 4095
				AADD(aPedidosAc,{})
			EndIf
			Do Case
				Case lCarteira .And. aPergs711[17] == 1 .And. aPergs711[30] == 1
					nQtdPed := Max(C6_QTDVEN,C6_QTDENT)
				Case aPergs711[17] == 1 .And. aPergs711[30] == 2
					nQtdPed := Max(0,C6_QTDVEN-C6_QTDENT)
				Case aPergs711[30] == 1
					nQtdPed := C6_QTDENT
				Otherwise
					nQtdPed := 0				
			EndCase
			For i:=1 to Len(aPedidosAc)
				If lUsaMOpc
					SC6->(DbGoTo(nRecno))
					nAchouPed:=ASCAN(aPedidosAc[i],{ |x| x[1] == C6_PRODUTO+SC6->C6_MOPC .And. x[2] == A650DTOPER(C6_ENTREG,aPeriodos,nTipo)})
				Else
					nAchouPed:=ASCAN(aPedidosAc[i],{ |x| x[1] == C6_PRODUTO+C6_OPC .And. x[2] == A650DTOPER(C6_ENTREG,aPeriodos,nTipo)})
				EndIf
				If nAchouPed != 0
					aPedidosAc[i,nAchouPed,3] += nQtdPed
					Exit
				EndIf
			Next i
			If nAchouPed ==0
				If lUsaMOpc
					AADD(aPedidosAc[Len(aPedidosAc)],{C6_PRODUTO+SC6->C6_MOPC,A650DTOPER(C6_ENTREG,aPeriodos,nTipo),nQtdPed})
				Else
					AADD(aPedidosAc[Len(aPedidosAc)],{C6_PRODUTO+C6_OPC,A650DTOPER(C6_ENTREG,aPeriodos,nTipo),nQtdPed})
				EndIf
			EndIf
		EndIf
		dbSkip()
	End
Endif
If lQuery
	dbSelectArea(cAliasTop)
	dbCloseArea()
	dbSelectArea("SC6")
Else
	dbSelectArea("SC6")
	RetIndex("SC6")
	dbClearFilter()
	Ferase(cTmp+OrdBagExt())
EndIf

// STATUS 3 - Processamento efetuado com sucesso
PutGlbValue("A710JobC6","3")
GlbUnLock()

FClose(nHd)
FErase(cFileJob)

// Processa em conjunto PREVISAO DE VENDAS
If lProcSC4
	lQuery := .T.
	cAliasTop := CriaTrab(NIL,.f.)
	
	A710JobC4(cEmp,cFil,{c711NumMRP,nTipo,aPeriodos,cStrTipo,cStrGrupo,lQuery,cAliasTop,cAlmoxd,cAlmoxa,cQueryB1,ACLONE(aPergs711),.F.,aPedidosAC,cRev711Vaz,A711Grupo,lMRPCINQ,lA710Sql},nTentativa,,lUsaMOpc)
EndIf

RETURN                                                       

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A710JobAFJ³ Autor ³Rodrigo de A Sartorio  ³ Rev. ³24.05.2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Job para processamento de empenhos para projeto - AFJ        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cEmp     - Empresa                                           ³±±
±±³          ³cFil     - Filial                                            ³±±
±±³          ³aParamJob- Array com parametros para JOB                     ³±±
±±³          ³[1]      - Numero do calculo de MRP                          ³±±
±±³          ³[2]      - Tipo de calculo MRP                               ³±±
±±³          ³[3]      - Array com os periodos                             ³±±
±±³          ³[4]      - String com tipos a serem processados              ³±±
±±³          ³[5]      - String com grupos a serem processados             ³±±
±±³          ³[6]      - Indica se deve processar query ou nao             ³±±
±±³          ³[7]      - Alias da tabela a ser processada                  ³±±
±±³          ³[8]      - Query para filtragem de produtos no SB1           ³±±            
±±³          ³[9]      - Indica a existencia de P.E. na filtragem (SQL)    ³±±            
±±³          ³[10]     - Indica a existencia de P.E. na filtragem (CDX)    ³±±            
±±³          ³[11]     - Opcional vazio                                    ³±±            
±±³          ³[12]     - Revisao vazio                                     ³±±            
±±³          ³[13]     - Indica se gera log                                ³±±
±±³          ³[14]     - Array com as perguntas                            ³±±
±±³          ³[15]     - Array com os grupos de produto 				   ³±±
±±³          ³[16]     - Considera grupos na query - MV_MRPCINQ			   ³±±
±±³          ³nTentativa - Numero da tentativa para chamada do JOB         ³±±            
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XA710JobAFJ(cEmp,cFil,aParamJob,nTentativa,cFileJob)
LOCAL nRecno:=0              
LOCAl nHd:=0
LOCAL c711NumMRP:=aParamJob[1]
LOCAL nTipo     :=aParamJob[2]
LOCAL aPeriodos :=aParamJob[3]
LOCAL cStrTipo  :=aParamJob[4]
LOCAL cStrGrupo :=aParamJob[5]
LOCAL lQuery    :=aParamJob[6]
LOCAL cAliasTop :=aParamJob[7]
LOCAL cQueryB1  :=aParamJob[8]
LOCAL lA710Sql  :=aParamJob[9] 
LOCAL lA710Fil  :=aParamJob[10]
LOCAL cOpc711Vaz:=aParamJob[11]
LOCAL cRev711Vaz:=aParamJob[12]
LOCAL lLogMRP   :=aParamJob[13]
LOCAL aPergs711 :=aParamJob[14]
LOCAL A711Grupo	:=aParamJob[15]
LOCAL lMRPCINQ	:=aParamJob[16]
LOCAL lAllGrp	:=.T.  //Ascan(A711Grupo,{|x| x[1] == .F.}) == 0 

PRIVATE nQuantPer := Len(aPeriodos)

nHd := FCreate(cFileJob)

// STATUS 1 - Iniciando execucao do Job
PutGlbValue("A710JobAFJ","1")
GlbUnLock()
                      
// Seta job para nao consumir licensas
RpcSetType(3)

// Seta job para empresa filial desejada
RpcSetEnv( cEmp, cFil,,,'PCP')

// STATUS 2 - Conexao efetuada com sucesso
PutGlbValue("A710JobAFJ","2")
GlbUnLock()

Conout(STR0090+" A710JobAFJ "+StrZero(nTentativa,2,0))  //"Processando thread"

If lQuery
	cQuery := "SELECT AFJ.* ,AFJ.R_E_C_N_O_ AFJREC"
	If !lAllGrp .And. !lMRPCINQ
		cQuery += ",SB1.B1_GRUPO"
	EndIf
	cQuery += " FROM "+RetSqlName("AFJ")+" AFJ, "+RetSqlName("SB1")+" SB1 "
	cQuery += "WHERE AFJ.AFJ_FILIAL='"+xFilial("AFJ")+"' AND "
	cQuery += "AFJ.AFJ_QATU < AFJ.AFJ_QEMP AND "
	cQuery += "AFJ.D_E_L_E_T_=' ' AND AFJ.AFJ_COD = SB1.B1_COD "
	cQuery += cQueryB1
	
	If lA710SQL
		cA710Fil := ExecBlock("A710SQL", .F., .F., {"AFJ", cQuery})
		If ValType(cA710Fil) == "C"
			cQuery := cA710Fil
		Endif
	Endif
	
	cQuery += "ORDER BY "+SqlOrder(AFJ->(IndexKey(2)))
	cQuery := ChangeQuery(cQuery)
		
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)
	aEval(AFJ->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField(cAliasTop,x[1],x[2],x[3],x[4]),Nil)})
EndIf
dbSelectArea(cAliasTop)

If !lQuery
	dbSelectArea("AFJ")
	dbSetOrder(2)
	dbSeek(xFilial("AFJ"))
Endif

If !Eof()
	// Abre tabelas necessarias
	U_XA710OpenFMRP(NIL,NIL,NIL,.T.)
	dbSelectArea(cAliasTop)
	While !Eof() .and. (lQuery .Or. AFJ_FILIAL+AFJ_COD == xFilial("AFJ")+SB1->B1_COD)
		If !lQuery
			If AFJ_QATU >= AFJ_QEMP .Or. !M711AvalProd(AFJ_COD,cStrTipo,cStrGrupo)
				dbSkip()
				Loop
			Endif
			nRecno := Recno()
		Else
			If lQuery .And. ( !lAllGrp .And. !lMRPCINQ .And. !(cAliasTop)->B1_GRUPO $ cStrGrupo )
				dbSkip()
				Loop
			EndIf
			nRecno := AFJREC
		Endif
		// Avalia o LOG do MRP para o evento 006 - Documento planejado em atraso
		A710CriaLOG("006",AFJ_COD,{AFJ_DATA,AFJ_PROJETO,"","AFJ"},lLogMRP,c711NumMRP)
		A711CriSH5(A710NextUtil(AFJ_DATA,aPergs711),AFJ_COD,cOpc711Vaz,cRev711Vaz,"AFJ",nRecno,AFJ_PROJETO,"","",AFJ_QEMP-AFJ_QATU,"3",.F.,NIL,NIL,.F.,.T.,aPeriodos,nTipo,c711NumMRP,cStrTipo,cStrGrupo)
		dbSelectArea(cAliasTop)	
		dbSkip()
	End
EndIf
If lQuery
	dbSelectArea(cAliasTop)
	dbCloseArea()
	dbSelectArea("AFJ")
EndIf 

// STATUS 3 - Processamento efetuado com sucesso
PutGlbValue("A710JobAFJ","3")
GlbUnLock()

FClose(nHd)
FErase(cFileJob)

RETURN

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A710JobC4 ³ Autor ³Rodrigo de A Sartorio  ³ Rev. ³24.05.2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Job para processamento de previsoes de venda - SC4           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cEmp     - Empresa                                           ³±±
±±³          ³cFil     - Filial                                            ³±±
±±³          ³aParamJob- Array com parametros para JOB                     ³±±
±±³          ³[1]      - Numero do calculo de MRP                          ³±±
±±³          ³[2]      - Tipo de calculo MRP                               ³±±
±±³          ³[3]      - Array com os periodos                             ³±±
±±³          ³[4]      - String com tipos a serem processados              ³±±
±±³          ³[5]      - String com grupos a serem processados             ³±±
±±³          ³[6]      - Indica se deve processar query ou nao             ³±±
±±³          ³[7]      - Alias da tabela a ser processada                  ³±±
±±³          ³[8]      - Almoxarifado de (utilizado para filtro)           ³±±
±±³          ³[9]      - Almoxarifado ate(utilizado para filtro)           ³±±            
±±³          ³[10]     - Query para filtragem de produtos no SB1           ³±±            
±±³          ³[11]     - Array com perguntas utilizadas                    ³±±            
±±³          ³[12]     - Indica se a chamada ocorreu atraves de JOB        ³±±            
±±³          ³[13]     - Array com dados dos pedidos existentes            ³±±            
±±³          ³[14]     - Revisao vazio                                     ³±±            
±±³          ³[15]     - Array com os grupos de produto 				   ³±±
±±³          ³[16]     - Considera grupos na query - MV_MRPCINQ			   ³±±
±±³          ³nTentativa - Numero da tentativa para chamada do JOB         ³±±            
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XA710JobC4(cEmp,cFil,aParamJob,nTentativa,cFileJob,lUsaMOpc)
LOCAL cQuery:="",cA710Fil:=""
LOCAL cTmp  :="",nInd:=0
LOCAL nRecno:=0
LOCAL nHd:=0
LOCAL i:=0,nAchouPed:=0,nQuantPrev:=0
LOCAL c711NumMRP:=aParamJob[1]
LOCAL nTipo     :=aParamJob[2]
LOCAL aPeriodos :=aParamJob[3]
LOCAL cStrTipo  :=aParamJob[4]
LOCAL cStrGrupo :=aParamJob[5]
LOCAL lQuery    :=aParamJob[6]
LOCAL cAliasTop :=aParamJob[7]
LOCAL cAlmoxd   :=aParamJob[8]
LOCAL cAlmoxa   :=aParamJob[9]
LOCAL cQueryB1  :=aParamJob[10]
LOCAL aPergs711 :=aParamJob[11]
LOCAL lInJob    :=aParamJob[12]
LOCAL aPedidosAC:=aParamJob[13]
LOCAL cRev711Vaz:=aParamJob[14]
LOCAL A711Grupo	:=aParamJob[15]
LOCAL lMRPCINQ	:=aParamJob[16]
LOCAL lAllGrp	:=Ascan(A711Grupo,{|x| x[1] == .F.}) == 0
LOCAL lA710SQL 	:=aParamJob[17] 


PRIVATE nQuantPer := Len(aPeriodos)

// So inicializa ambiente se foi acionado por job
// So atualiza status de variavel global se foi acionado por job
If lInJob
	nHd := FCreate(cFileJob)
	// STATUS 1 - Iniciando execucao do Job
	PutGlbValue("A710JobC4","1")
	GlbUnLock()
	
	// Seta job para nao consumir licensas
	RpcSetType(3)
	
	// Seta job para empresa filial desejada
	RpcSetEnv( cEmp, cFil,,,'PCP')
	
	// STATUS 2 - Conexao efetuada com sucesso
	PutGlbValue("A710JobC4","2")
	GlbUnLock()
EndIf
	
Conout(STR0090+" A710JobC4 "+StrZero(nTentativa,2,0)) //"Processando thread"

If lQuery
	cQuery := "SELECT SC4.* ,SC4.R_E_C_N_O_ C4REC"
	If !lAllGrp .And. !lMRPCINQ
		cQuery += ",SB1.B1_GRUPO"
	EndIf
	cQuery += " FROM "+RetSqlName("SC4")+" SC4 , "+RetSqlName("SB1")+" SB1 "
	cQuery += "WHERE SC4.C4_FILIAL='"+xFilial("SC4")+"' AND "
	cQuery += "SC4.C4_DATA >= '" + DTOS(aPergs711[05]) + "' AND "
	cQuery += "SC4.C4_DATA <= '" + DTOS(aPergs711[06]) + "' AND "
	cQuery += "SC4.C4_LOCAL >= '"+cAlmoxd+"' AND "
	cQuery += "SC4.C4_LOCAL <= '"+cAlmoxa+"' AND "
	cQuery += "SC4.C4_DOC >= '" + aPergs711[23] + "' AND "
	cQuery += "SC4.C4_DOC <= '" + aPergs711[24] + "' AND "				
	cQuery += "SC4.D_E_L_E_T_=' ' AND SC4.C4_PRODUTO = SB1.B1_COD "
	cQuery += cQueryB1
	
	If lA710SQL
		cA710Fil := ExecBlock("A710SQL", .F., .F., {"SC4", cQuery})
		If ValType(cA710Fil) == "C"
			cQuery := cA710Fil
		Endif
	Endif
	
	cQuery += "ORDER BY "+SqlOrder(SC4->(IndexKey(1)))
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)
	aEval(SC4->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField(cAliasTop,x[1],x[2],x[3],x[4]),Nil)})
EndIf     
dbSelectArea(cAliasTop)

If !lQuery
	dbSelectArea("SC4")
	dbSetOrder(1)
	dbSeek(xFilial("SC4"))
Endif

If !Eof()
	If Select("SH5") <= 0
		// Abre tabelas necessarias
		U_XA710OpenFMRP(NIL,NIL,NIL,.T.)
		dbSelectArea(cAliasTop)
	EndIf
	While !Eof() .and. (lQuery .Or. C4_FILIAL == xFilial("SC4"))
		If !lQuery
			If (C4_DATA < aPergs711[05] .Or. C4_DATA > aPergs711[06] .Or. ;
				C4_DOC  < aPergs711[23] .Or. C4_DOC  > aPergs711[24] .Or. ;
				SC4->C4_LOCAL < cAlmoxd .Or. SC4->C4_LOCAL > cAlmoxa) .Or. !M711AvalProd(C4_PRODUTO,cStrTipo,cStrGrupo)
				dbSkip()
				Loop
			Else
				nRecno := Recno()
			EndIf
		Else
			If lQuery .And. ( !lAllGrp .And. !lMRPCINQ .And. !(cAliasTop)->B1_GRUPO $ cStrGrupo )
				dbSkip()
				Loop
			Else
				nRecno := C4REC
			EndIf
		EndIf
		// Quantidade Original da previsao de vendas
		nQuantPrev:=C4_QUANT				
		// Subtrai quantidade dos pedidos ja colocados ou faturados
		If aPergs711[17] == 1 .Or. aPergs711[30] == 1
			nAchouPed:=0
			For i:=1 to Len(aPedidosAc)
				If lUsaMOpc
					SC4->(dbGoto(nRecno))
					nAchouPed:=ASCAN(aPedidosAc[i],{ |x| x[1] == C4_PRODUTO+SC4->C4_MOPC .And. x[2] == A650DTOPER(C4_DATA,aPeriodos,nTipo)})
				Else
					nAchouPed:=ASCAN(aPedidosAc[i],{ |x| x[1] == C4_PRODUTO+C4_OPC .And. x[2] == A650DTOPER(C4_DATA,aPeriodos,nTipo)})
				EndIf
				If nAchouPed != 0
					Exit
				EndIf
			Next i
			If nAchouPed > 0
				If aPedidosAc[i,nAchouPed,3] > nQuantPrev
					aPedidosAc[i,nAchouPed,3]-=nQuantPrev
					nQuantPrev:=0
				Else
					nQuantPrev:=nQuantPrev - aPedidosAc[i,nAchouPed,3]
					aPedidosAc[i,nAchouPed,3]:=0
				EndIf	
			EndIf
		EndIf
		If nQuantPrev > 0
			If lUsaMOpc
				SC4->(dbGoto(nRecno))
				A711CriSH5(A710NextUtil(C4_DATA,aPergs711),C4_PRODUTO,SC4->C4_MOPC,If(A710TrataRev(),C4_REVISAO,cRev711Vaz),"SC4",nRecno,C4_DOC,"","",nQuantPrev,"3",.F., .T.,NIL,.F.,.T.,aPeriodos,nTipo,c711NumMRP,cStrTipo,cStrGrupo)
			Else
				A711CriSH5(A710NextUtil(C4_DATA,aPergs711),C4_PRODUTO,C4_OPC,If(A710TrataRev(),C4_REVISAO,cRev711Vaz),"SC4",nRecno,C4_DOC,"","",nQuantPrev,"3",.F., .T.,NIL,.F.,.T.,aPeriodos,nTipo,c711NumMRP,cStrTipo,cStrGrupo)
			EndIf
		EndIf
		dbSelectArea(cAliasTop)
		dbSkip()
	End
EndIf

If lQuery
	dbSelectArea(cAliasTop)
	dbCloseArea()
	dbSelectArea("SC4")
EndIf

// So atualiza status de variavel global se foi acionado por job
If lInJob
	// STATUS 3 - Processamento efetuado com sucesso
	PutGlbValue("A710JobC4","3")
	GlbUnLock()
	
	FClose(nHd)
	FErase(cFileJob)
EndIf

RETURN

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A710JobHC ³ Autor ³Rodrigo de A Sartorio  ³ Rev. ³24.05.2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Job para processamento de plano mestre de producao - SHC     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cEmp     - Empresa                                           ³±±
±±³          ³cFil     - Filial                                            ³±±
±±³          ³aParamJob- Array com parametros para JOB                     ³±±
±±³          ³[1]      - Numero do calculo de MRP                          ³±±
±±³          ³[2]      - Tipo de calculo MRP                               ³±±
±±³          ³[3]      - Array com os periodos                             ³±±
±±³          ³[4]      - String com tipos a serem processados              ³±±
±±³          ³[5]      - String com grupos a serem processados             ³±±
±±³          ³[6]      - Indica se deve processar query ou nao             ³±±
±±³          ³[7]      - Alias da tabela a ser processada                  ³±±
±±³          ³[8]      - Query para filtragem de produtos no SB1           ³±±            
±±³          ³[9]      - Array com perguntas utilizadas                    ³±±            
±±³          ³[10]     - Revisao vazio                                     ³±±            
±±³          ³[11]     - Array com os grupos de produto 				   ³±±
±±³          ³[12]     - Considera grupos na query - MV_MRPCINQ			   ³±±
±±³          ³nTentativa - Numero da tentativa para chamada do JOB         ³±±            
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XA710JobHC(cEmp,cFil,aParamJob,nTentativa,cFileJob,lUsaMOpc)
LOCAL nRecno:=0               
LOCAl nHd:=0
LOCAL c711NumMRP:=aParamJob[1]
LOCAL nTipo     :=aParamJob[2]
LOCAL aPeriodos :=aParamJob[3]
LOCAL cStrTipo  :=aParamJob[4]
LOCAL cStrGrupo :=aParamJob[5]
LOCAL lQuery    :=aParamJob[6]
LOCAL cAliasTop :=aParamJob[7]
LOCAL cQueryB1  :=aParamJob[8]
LOCAL aPergs711 :=aParamJob[9]
LOCAL cRev711Vaz:=aParamJob[10]
LOCAL A711Grupo	:=aParamJob[11]
LOCAL lMRPCINQ	:=aParamJob[12]
LOCAL lAllGrp	:=Ascan(A711Grupo,{|x| x[1] == .F.}) == 0 

PRIVATE nQuantPer := Len(aPeriodos)

nHd := FCreate(cFileJob)

// STATUS 1 - Iniciando execucao do Job
PutGlbValue("A710JobHC","1")
GlbUnLock()

// Seta job para nao consumir licensas
RpcSetType(3)

// Seta job para empresa filial desejada
RpcSetEnv( cEmp, cFil,,,'PCP')

// STATUS 2 - Conexao efetuada com sucesso
PutGlbValue("A710JobHC","2")
GlbUnLock()

Conout(STR0090+" A710JobHC "+StrZero(nTentativa,2,0))  //"Processando thread"

If lQuery
	cQuery := "SELECT SHC.* ,SHC.R_E_C_N_O_ HCREC"
	If !lAllGrp .And. !lMRPCINQ
		cQuery += ",SB1.B1_GRUPO"
	EndIf
	cQuery += " FROM "+RetSqlName("SHC")+" SHC , "+RetSqlName("SB1")+" SB1 "
	cQuery += "WHERE SHC.HC_FILIAL='"+xFilial("SHC")+"' AND "
	cQuery += "HC_STATUS = '"+Space(LEN(SHC->HC_STATUS))+"' AND "
	cQuery += "HC_OP = '"+Space(Len(SHC->HC_OP))+"' AND "
	cQuery += "HC_DATA >= '"+DTOS(aPergs711[05])+"' AND "
	cQuery += "HC_DATA <= '"+DTOS(aPergs711[06])+"' AND "
	cQuery += "HC_DOC  >= '"+aPergs711[23]+"' AND "
	cQuery += "HC_DOC  <= '"+aPergs711[24]+"' AND "				
	cQuery += "SHC.D_E_L_E_T_=' ' AND SHC.HC_PRODUTO = SB1.B1_COD "
	cQuery += cQueryB1
	cQuery += "ORDER BY "+SqlOrder(SHC->(IndexKey(1)))
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)
	aEval(SHC->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField(cAliasTop,x[1],x[2],x[3],x[4]),Nil)})
EndIf
dbSelectArea(cAliasTop)

If !lQuery
	dbSelectArea("SHC")
	dbSetOrder(1)
	dbSeek(xFilial("SHC"))
Endif

If !Eof()
	// Abre tabelas necessarias
	U_XA710OpenFMRP(NIL,NIL,NIL,.T.)
	dbSelectArea(cAliasTop)
	While !Eof() .and. (lQuery .Or. HC_FILIAL == xFilial("SHC"))
		If !lQuery
			If (!Empty(HC_STATUS) .Or. !Empty(HC_OP) .Or. ;
					DTOS(HC_DATA) < DTOS(aPergs711[05]) .Or. DTOS(HC_DATA) > DTOS(aPergs711[06]) .Or.;
					HC_DOC < aPergs711[23] .Or. HC_DOC > aPergs711[24]) .Or. !M711AvalProd(HC_PRODUTO,cStrTipo,cStrGrupo)
				dbSkip()
				Loop
			Else
				nRecno := Recno()
			EndIf
		Else
			If lQuery .And. ( !lAllGrp .And. !lMRPCINQ .And. !(cAliasTop)->B1_GRUPO $ cStrGrupo )
				dbSkip()
				Loop
			Else
				nRecno := HCREC
			EndIf
		Endif
		If lUsaMOpc
			SHC->(dbGoTo(nRecno))
			A711CriSH5(A710NextUtil(HC_DATA,aPergs711),HC_PRODUTO,SHC->HC_MOPC,If(A710TrataRev(), HC_REVISAO, cRev711Vaz),"SHC",nRecno,HC_DOC,"","",HC_QUANT,"2",.F., .T.,NIL,.F.,.T.,aPeriodos,nTipo,c711NumMRP,cStrTipo,cStrGrupo)
		Else
			A711CriSH5(A710NextUtil(HC_DATA,aPergs711),HC_PRODUTO,HC_OPC,If(A710TrataRev(), HC_REVISAO, cRev711Vaz),"SHC",nRecno,HC_DOC,"","",HC_QUANT,"2",.F., .T.,NIL,.F.,.T.,aPeriodos,nTipo,c711NumMRP,cStrTipo,cStrGrupo)
		EndIf
		dbSelectArea(cAliasTop)
		dbSkip()
	End
EndIf

If lQuery
	dbSelectArea(cAliasTop)
	dbCloseArea()
	dbSelectArea("SHC")
EndIf                 

// STATUS 3 - Processamento efetuado com sucesso
PutGlbValue("A710JobHC","3")
GlbUnLock()

FClose(nHd)
FErase(cFileJob)

RETURN

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A710JobB8 ³ Autor ³Andre Anjos			³ Rev. ³09.10.2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Job para processamento de lotes vencidos					   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cEmp     - Empresa                                           ³±±
±±³          ³cFil     - Filial                                            ³±±
±±³          ³aParamJob- Array com parametros para JOB                     ³±±
±±³          ³[1]      - Numero do calculo de MRP                          ³±±
±±³          ³[2]      - Tipo de calculo MRP                               ³±±
±±³          ³[3]      - Array com os periodos                             ³±±
±±³          ³[4]      - String com tipos a serem processados              ³±±
±±³          ³[5]      - String com grupos a serem processados             ³±±
±±³          ³[6]      - Indica se deve processar query ou nao             ³±±
±±³          ³[7]      - Alias da tabela a ser processada                  ³±±
±±³          ³[8]      - Query para filtragem de produtos no SB1           ³±±            
±±³          ³[9]      - Array com perguntas utilizadas                    ³±±            
±±³          ³[10]     - Revisao vazio                                     ³±±            
±±³          ³[11]     - aFilAlmox - Variavel de controle para customizacao³±±
±±³          ³[12]     - cMT710B2  - Variavel de controle para customizacao³±±
±±³          ³[13]     - Array com os grupos de produto 				   ³±±
±±³          ³[14]     - Considera grupos na query - MV_MRPCINQ			   ³±±
±±³          ³nTentativa - Numero da tentativa para chamada do JOB         ³±±            
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XA710JobB8(cEmp,cFil,aParamJob,nTentativa,cFileJob)
LOCAL nRecno	:=0               
LOCAl nHd		:=0
LOCAL c711NumMRP:= aParamJob[1]
LOCAL nTipo     := aParamJob[2]
LOCAL aPeriodos := aParamJob[3]
LOCAL cStrTipo  := aParamJob[4]
LOCAL cStrGrupo := aParamJob[5]
LOCAL lQuery    := aParamJob[6]
LOCAL cAliasTop := aParamJob[7]
LOCAL cQueryB1  := aParamJob[8]
LOCAL aPergs711 := aParamJob[9]
LOCAL cRev711Vaz:= aParamJob[10]
LOCAL aFilAlmox := aParamJob[11]
LOCAL cMT710B2  := If(Empty(aParamJob[12]),".T.",aParamJob[12])
LOCAL A711Grupo	:= aParamJob[13]
LOCAL lMRPCINQ	:= aParamJob[14]
LOCAL lAllGrp	:= Ascan(A711Grupo,{|x| x[1] == .F.}) == 0 
LOCAL aAlmoxNNR := If(Len(aParamJob) > 14,aParamJob[15],{})

PRIVATE nQuantPer := Len(aPeriodos)

nHd := FCreate(cFileJob)

// STATUS 1 - Iniciando execucao do Job
PutGlbValue("A710JobB8","1")
GlbUnLock()

// Seta job para nao consumir licensas
RpcSetType(3)

// Seta job para empresa filial desejada
RpcSetEnv( cEmp, cFil,,,'PCP')

// STATUS 2 - Conexao efetuada com sucesso
PutGlbValue("A710JobB8","2")
GlbUnLock()

Conout(STR0090+" A710JobB8 "+StrZero(nTentativa,2,0))  //"Processando thread"

If lQuery
	cQuery := "SELECT SB8.* ,SB8.R_E_C_N_O_ B8REC"
	If !lAllGrp .And. !lMRPCINQ
		cQuery += ",SB1.B1_GRUPO"
	EndIf
	cQuery += " FROM "+RetSqlName("SB8")+" SB8 , "+RetSqlName("SB1")+" SB1 "
	cQuery += "WHERE SB8.B8_FILIAL='"+xFilial("SB8")+"' AND B8_SALDO > 0 AND "
	cQuery += "B8_LOCAL >= '" +aPergs711[8] +"' AND B8_LOCAL <= '" +aPergs711[9] +"' AND "
	If aPergs711[22] == 1 //ja e tratado indiretamente na A710QtdCQ
		cQuery += "B8_LOCAL <> '" +AlmoxCQ()+"' AND "
	EndIf
	cQuery += "B8_DTVALID < '"+DTOS(aPeriodos[Len(aPeriodos)])+"' AND "
	cQuery += "SB8.D_E_L_E_T_=' ' AND SB8.B8_PRODUTO = SB1.B1_COD "
	cQuery += cQueryB1
	cQuery += "ORDER BY "+SqlOrder(SB8->(IndexKey(1)))
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)
	aEval(SB8->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField(cAliasTop,x[1],x[2],x[3],x[4]),Nil)})
EndIf
dbSelectArea(cAliasTop)

If !lQuery
	dbSelectArea("SB8")
	dbSetOrder(1)
	cQuery := "B8_FILIAL == '" +xFilial("SB8") +"' .And. B8_SALDO > 0 .And. "
	cQuery += "DToS(B8_DTVALID) < '" +DTOS(aPeriodos[Len(aPeriodos)]) +"' .And. "
	If aPergs711[22] == 1 //ja e tratado indiretamente na A710QtdCQ
		cQuery += "B8_LOCAL <> '" +AlmoxCQ()+"' .And. "
	EndIf
	cQuery += "B8_LOCAL >= '" +aPergs711[8] +"' .And. B8_LOCAL <= '" +aPergs711[9] +"'"
	dbSetFilter({|| &cQuery}, cQuery)
	dbGoTop()
Endif

If !Eof()
	// Abre tabelas necessarias
	U_XA710OpenFMRP(NIL,NIL,NIL,.T.)
	dbSelectArea(cAliasTop)
	While !Eof() .and. (lQuery .Or. B8_FILIAL == xFilial("SB8"))
		If !lQuery
			//-- Posiciona B2 para verificacao do PE MT710B2
			dbSelectArea("SB2")
			dbSetOrder(1)
			dbSeek(xFilial("SB2")+SB8->B8_PRODUTO+SB8->B8_LOCAL)
			dbSelectArea("SB8")
			If B8_SALDO <= 0 .Or. B8_DTVALID > aPeriodos[Len(aPeriodos)] .Or. !M711AvalProd(B8_PRODUTO,cStrTipo,cStrGrupo) .Or.;
			   !&(cMT710B2) .Or. aScan(aFilAlmox,B8_LOCAL) == 0 .Or. aScan(aAlmoxNNR,B8_LOCAL) == 0
				dbSkip()
				Loop
			Else
				nRecno := Recno()
			EndIf
		Else
			If lQuery .And. ( !lAllGrp .And. !lMRPCINQ .And. !(cAliasTop)->B1_GRUPO $ cStrGrupo )
				dbSkip()
				Loop
			Else
				nRecno := B8REC
			EndIf
		Endif
		A711CriSH5(A710NextUtil(B8_DTVALID+1,aPergs711),B8_PRODUTO,"",cRev711Vaz,"SB8",nRecno,If(Rastro(B8_PRODUTO,"L"),;
					AllTrim(B8_LOTECTL),AllTrim(B8_LOTECTL)+"/"+AllTrim(B8_NUMLOTE)),"","",B8_SALDO,"",.F., .T.,NIL,.F.,.T.,;
					aPeriodos,nTipo,c711NumMRP,cStrTipo,cStrGrupo)
		dbSelectArea(cAliasTop)
		dbSkip()
	End
EndIf

If lQuery
	dbSelectArea(cAliasTop)
	dbCloseArea()
	dbSelectArea("SB8")
Else
    dbClearFilter()
EndIf                 

// STATUS 3 - Processamento efetuado com sucesso
PutGlbValue("A710JobB8","3")
GlbUnLock()

FClose(nHd)
FErase(cFileJob)

RETURN

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A710FilMOP  ³ Autor ³Rodrigo de A Sartorio³ Data ³ 29/06/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna se o registro ligado a OP e' valido ou nao         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cOP       - Ordem de producao                              ³±±
±±³          ³ aPergs711 - Array com as perguntas do programa             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ LOGICO .T. - REGISTRO VALIDO .F. - REGISTRO INVALIDO       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function A710FilMOP(cOP,aPergs711)
Local lRet:=.T.
Local cAlias:=Alias()
Local aAreaSC2:={}
Local lConsSusp  :=aPergs711[13] == 1
Local lConsSacr  :=aPergs711[14] == 1
// Verifica SC2 se nao considera OPs Suspensas ou se nao considera
// OPs Sacramentadas
If !lConsSusp .Or. !lConsSacr .And. !Empty(cOP)
	aAreaSC2:=SC2->(GetArea())
	dbSelectArea("SC2")
	dbSetOrder(1)
	If dbSeek(xFilial("SC2")+cOP)
		// Verifica se considera OPs suspensas
		If !lConsSusp .And. C2_STATUS == "U"
			lRet:=.F.
		EndIf
		// Verifica se considera OPs sacramentadas
		If !lConsSacr .And. C2_STATUS == "S"
			lRet:=.F.
		EndIf
	EndIf
	SC2->(RestArea(aAreaSC2))
EndIf
dbSelectArea(cAlias)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ A710JobTree³ Autor ³ TOTVS S/A        	³ Data ³26/11/2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Job para montagem da Tela do MRP                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A710JTree()		                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cEmp       - Codigo da Empresa                              ³±±
±±³          ³cFil       - Codigo da Filial                               ³±±
±±³          ³aThreads   - Array que contem o range a ser processado      ³±±
±±³          ³cJobFile   - Nome do arquivo de semaforo                    ³±±
±±³          ³cThread    - Codigo da Thread em execucao                   ³±±
±±³          ³aTotais    - Array com os totais do MRP                     ³±±
±±³          ³cFileTotal - Nome do arquivo de Total                       ³±±
±±³          ³cFileTree  - Nome do arquivo da DbTree                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ NIL														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA710                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER Function XA710JobTree(cEmp,cFil,aThreads,cJobFile,cThread,cFileTotal,cFileTree,lUsaMOpc)
Local nHd1	    := 0
Local nHd2	    := 0
Local nHd3	    := 0
Local nX        := 0
Local i         := 0
Local nAchouTot := 0
Local cLin      := ""
Local aDbTree   := {}
Local aTotais   := {{}}

Default lUsaMOpc:= .F.

// Apaga arquivo de Job ja existente
If File(cJobFile)
	fErase(cJobFile)
EndIf

// Apaga arquivo Total ja existente
If File(cFileTotal)
	fErase(cFileTotal)
EndIf

// Apaga arquivo da DbTree ja existente
If File(cFileTree)
	fErase(cFileTree)
EndIf

// Criacao do arquivo de controle de jobs
nHd1 := MSFCreate(cJobFile)

// STATUS 1 - Iniciando execucao do Job
PutGlbValue("c710T"+cEmp+cFil+cThread, "1" )
GlbUnLock()

// Seta job para nao consumir licensas
RpcSetType(3)

// Seta job para empresa filial desejada
RpcSetEnv( cEmp, cFil,,,'EST')

// STATUS 2 - Conexao efetuada com sucesso
PutGlbValue("c710T"+cEmp+cFil+cThread, "2" )
GlbUnLock()

ConOut(dtoc(Date())+" "+Time()+" "+"MATA710: Iniciando Montagem do Tree do MRP "+" - "+cJobFile)

// Abre tabelas necessarias
U_XA710OpenFMRP(NIL,NIL,NIL,.T.)

//-- Processamento da tabela SH5
dbSelectArea("SH5")
dbSetOrder(1)
If lUsaMOpc
	MOpcSeek("SH5",1,,aThreads[1,1],,aThreads[1,2],aThreads[1,3],,.F.,.T.)
Else
	dbSeek(xFilial("SH5")+aThreads[1,1]+aThreads[1,2]+aThreads[1,3],.T.)
EndIf	

While !KillApp() .And. !Eof() .And. SH5->H5_PRODUTO <= aThreads[2,1]

	If H5_ALIAS # "PAR"

		If SH5->(H5_PRODUTO+H5_OPC+H5_REVISAO) < aThreads[1,1]+aThreads[1,2]+aThreads[1,3] .Or. ;
		   SH5->(H5_PRODUTO+H5_OPC+H5_REVISAO) > aThreads[2,1]+aThreads[2,2]+aThreads[2,3]
		   dbSkip()
		   Loop
		EndIf  
		 
		// Estrutura do array
		// Produto
		// Opcional
		// Revisao
		// Alias
		// Tipo
		// Documento
		// Recno
		// DocRev
		//                  01              02          03               04             05         06           07                         08
		AADD(aDbTree,{SH5->H5_PRODUTO,IIf(lUsaMOpc,IIf(Len(SH5->H5_OPC)<80,PADR(SH5->H5_OPC,80),SH5->H5_OPC),SH5->H5_OPC),SH5->H5_REVISAO,SH5->H5_ALIAS,SH5->H5_TIPO,SH5->H5_DOC,StrZero(SH5->(Recno()),12),SH5->H5_DOCREV})
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Adiciona registro em array totalizador utilizado no TREE  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If Len(aTotais[Len(aTotais)]) > 4095
			AADD(aTotais,{})
		EndIf
		For i:=1 to Len(aTotais)
			nAchouTot:=ASCAN(aTotais[i],{ |x| x[1] == H5_PRODUTO+H5_OPC+H5_REVISAO .And. x[2] == H5_PER .And. x[3] == H5_ALIAS})
			If nAchouTot != 0
				aTotais[i,nAchouTot,4] += H5_QUANT
				Exit
			EndIf
		Next i
		If nAchouTot ==0
			AADD(aTotais[Len(aTotais)],{H5_PRODUTO+IIf(Len(H5_OPC)<80,PADR(H5_OPC,80),H5_OPC)+H5_REVISAO,H5_PER,H5_ALIAS,H5_QUANT})
		EndIf
	EndIf
	dbSkip()	
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza arquivo com dados do Array aDbTree ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nHd2 :=	MSFCreate(cFileTree)
For nX := 1 to Len(aDbTree)

	fWrite(nHd2,aDbTree[nX][1]) //SH5->H5_PRODUTO
	If lUsaMOpc
		fWrite(nHd2,Substr(aDbTree[nX][2],1,80)) //SH5->H5_OPC
	Else
		fWrite(nHd2,aDbTree[nX][2]) //SH5->H5_OPC
	EndIf	
	fWrite(nHd2,aDbTree[nX][3]) //SH5->H5_REVISAO
	fWrite(nHd2,aDbTree[nX][4]) //SH5->H5_ALIAS
	fWrite(nHd2,aDbTree[nX][5]) //SH5->H5_TIPO
	fWrite(nHd2,aDbTree[nX][6]) //SH5->H5_DOC
	fWrite(nHd2,aDbTree[nX][7]) //StrZero(SH5->(Recno()),12)
	fWrite(nHd2,aDbTree[nX][8]) //SH5->H5_DOCREV
	fWrite(nHd2,CRLF)


Next nX	
fClose(nHd2)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza arquivo com dados do Array aTotais ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nHd3 :=	MSFCreate(cFileTotal)
For nX := 1 to Len(aTotais[1])
	fWrite(nHd3,aTotais[1][nX][1])			//SH5->H5_PRODUTO+SH5->H5_OPC+SH5->H5_REVISAO
	fWrite(nHd3,aTotais[1][nX][2])			//SH5->H5_PER
	fWrite(nHd3,aTotais[1][nX][3]) 		//SH5->H5_ALIAS
	fWrite(nHd3,STR(aTotais[1][nX][4],18))	//SH5->H5_QUANT
	fWrite(nHd3,CRLF)
Next nX	
fClose(nHd3)

ConOut(dtoc(Date())+" "+Time()+" "+"MATA710: Termino da Montagem do Tree do MRP "+" - "+cJobFile)

// STATUS 3 - Processamento efetuado com sucesso
PutGlbValue("c710T"+cEmp+cFil+cThread,"3")
GlbUnLock()

// Fecha arquivo de controle de semaforo
fClose(nHd1)

// Apaga arquivo de semaforo
If File(cJobFile)
	fErase(cJobFile)
EndIf

Return
                
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³A710JobIni³ Autor ³ Microsiga S/A         ³ Data ³29.07.2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao utilizada para carregar os registros de saldo inicial³±±
±±³          ³para as tabelas SHA/SH5 em mult-thread.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cEmp         - Empresa                                      ³±±
±±³          ³cFil         - Filial                                       ³±±
±±³          ³aThreads     - Array com os itens a serem calculados        ³±±
±±³          ³cJobFile     - Nome do arquivo para controle do JOB         ³±±
±±³          ³cThread      - Numero da Thread em execucao                 ³±±
±±³          ³cPath        - Caminho onde esta localizada a tabela SHA    ³±±
±±³          ³aBkPeriodos  - Array contendo os periodos a processar       ³±±
±±³          ³aBkPergs711  - Array contendo as perguntas selecionadas     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA710                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER Function XA710JobIni(cEmp,cFil,aProdutos,cJobFile,cThread,cPath,aBkPeriodos,aBkPergs711,c711BkNumMrp,cStrTipo,cStrGrupo,cTxtEstSeg,cRev711Vaz,lExistBB1,lExistBB2,lM710NOPC,lLogMRP,aPicture,nBkTipo,cTxtPontPed,aAlmoxNNRl,lSelOpc)
Local nHd1	  	:= 0
Local nX      		:= 0
Local nz        	:= 0
Local nSaldo   	:= 0
Local nEstSeg   	:= 0
Local nQtdAviso 	:= 0
Local cMsgAviso 	:= ""
Local nPontoPed 	:= 0
Local nQtdPontP 	:= 0
Local cMsgPontP 	:= ""
Local cArqSHA		:= ""
Local cQuery   	:= ""
Local cRevisao  	:= ""
Local aOpc		:= {}

Default cPath 	:= ""

//-- Carrega Variaveis Private
Private aPeriodos := aBkPeriodos
Private aPergs711 := aBkPergs711
Private cAlmoxd	  := aPergs711[8]
Private cAlmoxa	  := aPergs711[9]
Private c711NumMrp:= c711BkNumMrp
Private cPictLOCAL:= aPicture[1]
Private cPictQATU := aPicture[2]
Private cPictQNPT := aPicture[3]
Private cPictQTNP := aPicture[4]
Private cPictQTDE := aPicture[5]
Private cPictSALDO:= aPicture[6]
Private nTipo     := nBkTipo
Private aFilAlmox := Nil
Private cMT710B2  := Nil
Private aAlmoxNNR := aAlmoxNNRl


// Apaga arquivo ja existente
If File(cJobFile)
	fErase(cJobFile)
EndIf

// Criacao do arquivo de controle de jobs
nHd1 := MSFCreate(cJobFile)

// STATUS 1 - Iniciando execucao do Job
PutGlbValue("c710P"+cEmp+cFil+cThread, "1" )
GlbUnLock()

// Seta job para nao consumir licensas
RpcSetType(3)

// Seta job para empresa filial desejada
RpcSetEnv( cEmp, cFil,,,'EST')

Private lUsaMOpc := If(SuperGetMv('MV_REPGOPC',.F.,"N") == "S",.T.,.F.)

// STATUS 2 - Conexao efetuada com sucesso
PutGlbValue("c710P"+cEmp+cFil+cThread, "2" )
GlbUnLock()

ConOut(dtoc(Date())+" "+Time()+" "+"MATA710: Iniciando job Saldo Inicial "+" - "+cJobFile)

// Abre tabelas necessarias
U_XA710OpenFMRP(Nil,Nil,Nil,.T.)


//-- Processamento
For nX :=1 To Len(aProdutos)

	dbSelectArea("SB1")
	dbSetOrder()
	If MsSeek(xFilial("SB1")+aProdutos[nX])

		If lExistBB1
			aFilAlmox := RetExecBlock("A710FILALM", { SB1->B1_COD, cAlmoxd, cAlmoxa }, "A", Nil,Nil,Nil,lExistBB1)
		EndIf
		If lExistBB2
			cMT710B2  := RetExecBlock("MT710B2"   , { SB1->B1_COD, cAlmoxd, cAlmoxa }, "C", Nil,Nil,Nil,lExistBB2)
		EndIf

		If ValType(aFilAlmox) == "A" .And. aScan(aFilAlmox, {|z| ValType(z) # "C"}) > 0
			aFilAlmox := Nil
		EndIf

		// Inicializa variaveis de saldo
		nSaldo	:= 0
		nEstSeg	:= 0
		// Obtem saldo e estoque de seguranca
		A710DSaldo(SB1->B1_COD,@nSaldo,@aFilAlmox,Nil,Nil,@nEstSeg)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de Entrada MA710NOPC para indicar saldo por  ³
		//³ opcional                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lM710NOPC
			aOpc := ExecBlock('M710NOPC',.F.,.F.,{SB1->B1_COD,nSaldo})
			If ValType(aOpc) == 'A'
				For nz:=1 to Len(aOpc)
					// Avalia o LOG do MRP para o evento 001 - Saldo em estoque inicial menor que zero
					A710CriaLOG("001",SB1->B1_COD,{aOPc[nz,2]},lLogMRP,c711NumMrp)
					cRevisao := If(A710TrataRev() .And. Len(aOpc[nz]) >= 3, aOpc[nz, 3], cRev711Vaz)
					A711CriSHA(SB1->B1_COD,aOPc[nz,1],cRevisao,"","001",aOPc[nz,2],"1",Nil,Nil,cStrTipo,cStrGrupo)
				Next nz
			Else
				// Avalia o LOG do MRP para o evento 001 - Saldo em estoque inicial menor que zero
				A710CriaLOG("001",SB1->B1_COD,{nSaldo},lLogMRP,c711NumMrp)
				A711CriSHA(SB1->B1_COD,IIF(lSelOpc == 'S',SB1->B1_OPC,CriaVar("B1_OPC")),cRev711Vaz,"","001",nSaldo,"1",Nil,Nil,cStrTipo,cStrGrupo)
			EndIf
		Else
			// Avalia o LOG do MRP para o evento 001 - Saldo em estoque inicial menor que zero
			A710CriaLOG("001",SB1->B1_COD,{nSaldo},lLogMRP,c711NumMrp)
			A711CriSHA(SB1->B1_COD,IIF(lSelOpc == 'S',SB1->B1_OPC,CriaVar("B1_OPC")),cRev711Vaz,"","001",nSaldo,"1",Nil,Nil,cStrTipo,cStrGrupo)
		EndIf

		If aPergs711[26] == 3
			nEstSeg := CalcEstSeg( RetFldProd(SB1->B1_COD,"B1_ESTFOR") )
		EndIf

		If aPergs711[31] == 1
			nPontoPed := RetFldProd(SB1->B1_COD,"B1_EMIN")
		EndIf

		// Checa informacoes para inclusao no tree
		nQtdAviso := 0
		cMsgAviso := ""
		// Caso o estoque de seguranca esteja preenchido
		If QtdComp(nEstSeg,.T.) > QtdComp(0,.T.)
			nQtdAviso:= nEstSeg
			cMsgAviso:= cTxtEstSeg
		Else
			// Posiciona na necessidade
			If !lUsaMOpc
				SHA->(MsSeek(xFilial("SHA")+SB1->(B1_COD+B1_OPC+B1_REVATU+"6")))
			Else 
				MOpcSeek("SHA",1,,SB1->(B1_COD),,SB1->(B1_OPC),SB1->(B1_REVATU),"6")
			EndIf
			// Caso tenha necessidade
			If QtdComp(SHA->HA_PER001,.T.) > QtdComp(0,.T.)
				nQtdAviso:=SHA->HA_PER001
				cMsgAviso:="Nec. Ant." //STR0085 //"Nec. Ant."
			EndIf
		EndIf

		// Checa informacoes para inclusao no tree
		nQtdPontP := 0
		cMsgPontP := ""
		// Caso o estoque de seguranca esteja preenchido
		If QtdComp(nPontoPed,.T.) > QtdComp(0,.T.)
			nQtdPontP:= nPontoPed
			cMsgPontP:= cTxtPontPed
		Else
			// Posiciona na necessidade
			If !lUsaMOpc
				SHA->(dbSeek(xFilial("SHA")+SB1->(B1_COD+B1_OPC+B1_REVATU+"6")))
			Else
				MOpcSeek("SHA",1,,SB1->(B1_COD),,SB1->(B1_OPC),SB1->(B1_REVATU),"6")
			EndIf
			// Caso tenha necessidade
			If QtdComp(SHA->HA_PER001,.T.) > QtdComp(0,.T.)
				nQtdPontP:=SHA->HA_PER001
				cMsgPontP:="Nec. Ant."//STR0085 //"Nec. Ant."
			EndIf
		EndIf

		// 	Monta no tree
		If QtdComp(nQtdAviso,.T.) > QtdComp(0,.T.)
			A711CriSH5(aPeriodos[1],SB1->B1_COD,SB1->B1_OPC,SB1->B1_REVATU,"SB1",SB1->(Recno()),cMsgAviso,"","",nQtdAviso,"",.F.,.F., Nil,.F.,Nil,Nil,Nil,Nil,cStrTipo,cStrGrupo)
		EndIf

		// 	Monta no tree
		If QtdComp(nQtdPontP,.T.) > QtdComp(0,.T.)
			A711CriSH5(aPeriodos[1],SB1->B1_COD,SB1->B1_OPC,SB1->B1_REVATU,"SB1",SB1->(Recno()),cMsgPontP,"","",nQtdPontP,"",.F.,.F., Nil,.F.,Nil,Nil,Nil,Nil,cStrTipo,cStrGrupo)
		EndIf

	EndIf

Next nX

ConOut(dtoc(Date())+" "+Time()+" "+"MATA710: Termino job Saldo Inicial "+" - "+cJobFile)

// STATUS 3 - Processamento efetuado com sucesso
PutGlbValue("c710P"+cEmp+cFil+cThread,"3")
GlbUnLock()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³A710JobNes³ Autor ³ Microsiga S/A         ³ Data ³29.07.2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao utilizada para executar o calculo da necessidade em  ³±±
±±³          ³mult-thread.                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cEmp         - Empresa                                      ³±±
±±³          ³cFil         - Filial                                       ³±±
±±³          ³aThreads     - Array com os itens a serem calculados        ³±±
±±³          ³cJobFile     - Nome do arquivo para controle do JOB         ³±±
±±³          ³cThread      - Numero da Thread em execucao                 ³±±
±±³          ³cPath        - Caminho onde esta localizada a tabela SHA    ³±±
±±³          ³aBkPeriodos  - Array contendo os periodos a processar       ³±±
±±³          ³aBkPergs711  - Array contendo as perguntas selecionadas     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA710                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER Function XA710JobNes(cEmp,cFil,aThreads,cJobFile,cThread,cPath,aBkPeriodos,aBkPergs711,lParcial,cMT710B2lc,aFilAlmoxl,aAlmoxNNRl)
Local nHd1	  := 0
Local nX      := 0

Default cPath     := ""
Default lParcial  := .T.

Private aPeriodos := aBkPeriodos
Private aPergs711 := aBkPergs711
Private cMT710B2  := cMT710B2lc
Private aFilAlmox := aFilAlmoxl
Private aAlmoxNNR := aAlmoxNNRl

// Apaga arquivo ja existente
If File(cJobFile)
	fErase(cJobFile)
EndIf

// Criacao do arquivo de controle de jobs
nHd1 := MSFCreate(cJobFile)

// STATUS 1 - Iniciando execucao do Job
PutGlbValue("c710P"+cEmp+cFil+cThread, "1" )
GlbUnLock()

// Seta job para nao consumir licensas
RpcSetType(3)

// Seta job para empresa filial desejada
RpcSetEnv( cEmp, cFil,,,'EST')

// STATUS 2 - Conexao efetuada com sucesso
PutGlbValue("c710P"+cEmp+cFil+cThread, "2" )
GlbUnLock()

ConOut(dtoc(Date())+" "+Time()+" "+"MATA710: Iniciando job Calculo Necessidade "+" - "+cJobFile)

// Abre tabelas necessarias
U_XA710OpenFMRP(NIL,NIL,NIL,.T.)

//-- Processamento
For nX :=1 To Len(aThreads)
	MA711Recalc(aThreads[nX,1],aThreads[nX,2],aThreads[nX,3],Nil,Nil,Nil,.T.)
Next nX

ConOut(dtoc(Date())+" "+Time()+" "+"MATA710: Termino job Calculo Necessidade "+" - "+cJobFile)

// STATUS 3 - Processamento efetuado com sucesso
PutGlbValue("c710P"+cEmp+cFil+cThread,"3")
GlbUnLock()
Return