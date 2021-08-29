#Include "PROTHEUS.CH"

//--------------------------------------------------------------
/*/{Protheus.doc} DomEStatis
Description Estatistica para Planejamento de Corte
@param xParam Parameter Description
@return xRet Return Description
@author  -
@since 27/12/2019
/*/
//--------------------------------------------------------------
User Function DomEStatis()

Local 	aRotina := {}

Aadd(aRotina,{"Atualizar Estatistica","U_AtuStat()", 0 , 4}) //"Conhecimento"

dbselectarea("P11")
AxCadastro("P11", " Estatística", ".t.", ".t.", aRotina )

return



User Function AtuStat()

Local cPerg   	:= "DOMESTATIS"

AjustaSX1(cPerg)
Pergunte(cPerg,.T.)
Processa({ || fEstatCort(), "Atualizando tabela de estatística"})

Return

//--------------------------------------------------------------
/*/{Protheus.doc} static Function fEstatCort()
Description Estatistica para Planejamento de Corte
@param xParam Parameter Description
@return xRet Return Description
@author  -
@since 27/12/2019
/*/
//--------------------------------------------------------------
static Function fEstatCort()
Private cQuery:= " "
Private cEnter:= chr(13) + chr(10)


if Select("QRY") > 0
	QRY->(dbCloseArea())
EndIf

cQuery+= " SELECT TAB.PA, " +cEnter
cQuery+= " B1_GRUPO, "
cQuery+= " TAB.PROD,  " +cEnter
cQuery+= " Sum(TAB.QTD_CORTE)  " +cEnter
cQuery+= " AS QTD_MTRS,  " +cEnter
cQuery+= " Sum (TAB.MINUTOS)  " +cEnter
cQuery+= " AS MINUTOS,  " +cEnter
cQuery+= " ISNULL((SELECT G1_QUANT  " +cEnter
cQuery+= "               FROM   "+RetSqlName("SG1")+" SG1 WITH(NOLOCK)  " +cEnter
cQuery+= "               WHERE  G1_FILIAL = '"+Xfilial("SG1")+"'  " +cEnter
cQuery+= "                      AND G1_COD = TAB.PA  " +cEnter
cQuery+= "                      AND G1_COMP = TAB.PROD  " +cEnter
cQuery+= "                      AND SG1.D_E_L_E_T_ = ''), 0)  " +cEnter
cQuery+= "       AS MTRS_UNIT,  " +cEnter
cQuery+= "       ( Sum(TAB.QTD_CORTE) / ( ISNULL((SELECT G1_QUANT  " +cEnter
cQuery+= "                                        FROM   "+RetSqlName("SG1")+" SG1 WITH(NOLOCK)  " +cEnter
cQuery+= "                                        WHERE  G1_FILIAL = '"+Xfilial("SG1")+"'  " +cEnter
cQuery+= "                                               AND G1_COD = TAB.PA  " +cEnter
cQuery+= "                                               AND G1_COMP = TAB.PROD  " +cEnter
cQuery+= "                                               AND SG1.D_E_L_E_T_ = ''), 0) ) )  " +cEnter
cQuery+= "       AS  " +cEnter
cQuery+= "       QTD_UNIT,  " +cEnter
cQuery+= "       Round(Sum (TAB.MINUTOS) / ( Sum(TAB.QTD_CORTE) / (  " +cEnter
cQuery+= "                                   ISNULL((SELECT G1_QUANT  " +cEnter
cQuery+= "                                           FROM  " +cEnter
cQuery+= "                                   "+RetSqlName("SG1")+" SG1 WITH( NOLOCK)  " +cEnter
cQuery+= "                                           WHERE  " +cEnter
cQuery+= "                                   G1_FILIAL = '"+Xfilial("SG1")+"'  " +cEnter
cQuery+= "                                   AND G1_COD = TAB.PA  " +cEnter
cQuery+= "                                   AND  " +cEnter
cQuery+= "                                         G1_COMP = TAB.PROD  " +cEnter
cQuery+= "                                                  AND SG1.D_E_L_E_T_ = ''), 0) ) ), 2)  " +cEnter
cQuery+= "       AS MEDIA  " +cEnter
cQuery+= "FROM   (SELECT CONVERT(CHAR, CONVERT(DATETIME, D3_EMISSAO), 103) AS EMISSAO,  " +cEnter
cQuery+= "               ZZ4_OP                                            AS OP,  " +cEnter
cQuery+= "               ISNULL((SELECT C2_PRODUTO  " +cEnter
cQuery+= "                       FROM   "+RetSqlName("SC2")+" SC2 WITH(NOLOCK)  " +cEnter
cQuery+= "                       WHERE  C2_FILIAL = '"+Xfilial("SC2")+"'  " +cEnter
cQuery+= "                              AND C2_NUM + C2_ITEM + C2_SEQUEN = ZZ4_OP  " +cEnter
cQuery+= "                              AND SC2.D_E_L_E_T_ = ''), '')      AS PA,  " +cEnter
cQuery+= "               ZZ4_PROD                                          AS PROD,  " +cEnter
cQuery+= "               Sum(D3_QUANT)                                     AS QTD_CORTE,  " +cEnter
cQuery+= "               D3_XHRINI                                         HRINI,  " +cEnter
cQuery+= "               D3_HORA                                           HRFIM,  " +cEnter
cQuery+= "               CASE  " +cEnter
cQuery+= "                 WHEN D3_XHRINI < D3_HORA THEN Datediff(MI, D3_XHRINI, D3_HORA)  " +cEnter
cQuery+= "                 ELSE 0  " +cEnter
cQuery+= "               END                                               AS MINUTOS  " +cEnter
cQuery+= "        FROM   "+RetSqlName("ZZ4")+" ZZ4 WITH(NOLOCK)  " +cEnter
cQuery+= "               INNER JOIN "+RetSqlName("SD3")+" SD3 WITH(NOLOCK)  " +cEnter
cQuery+= "                       ON D3_FILIAL = '01 '  " +cEnter
cQuery+= "                          AND D3_XXOP = ZZ4_OP  " +cEnter
cQuery+= "                          AND D3_COD = ZZ4_PROD  " +cEnter
cQuery+= "                          AND D3_GRUPO IN ( 'FO', 'FOFS' )  " +cEnter
cQuery+= "                          AND D3_TM = '999'  " +cEnter
cQuery+= "                          AND SD3.D_E_L_E_T_ = ''  " +cEnter
cQuery+= "                          AND D3_ESTORNO = ''  " +cEnter
cQuery+= "                          AND ( Substring(D3_USERLGI, 11, 1)  " +cEnter
cQuery+= "                                + Substring(D3_USERLGI, 15, 1)  " +cEnter
cQuery+= "                                + Substring(D3_USERLGI, 2, 1)  " +cEnter
cQuery+= "                                + Substring(D3_USERLGI, 6, 1)  " +cEnter
cQuery+= "                                + Substring(D3_USERLGI, 10, 1)  " +cEnter
cQuery+= "                                + Substring(D3_USERLGI, 14, 1)  " +cEnter
cQuery+= "                                + Substring(D3_USERLGI, 1, 1)  " +cEnter
cQuery+= "                                + Substring(D3_USERLGI, 5, 1)  " +cEnter
cQuery+= "                                + Substring(D3_USERLGI, 9, 1)  " +cEnter
cQuery+= "                                + Substring(D3_USERLGI, 13, 1)  " +cEnter
cQuery+= "                                + Substring(D3_USERLGI, 17, 1)  " +cEnter
cQuery+= "                                + Substring(D3_USERLGI, 4, 1)  " +cEnter
cQuery+= "                                + Substring(D3_USERLGI, 8, 1) ) = ZZ4_USER  " +cEnter
cQuery+= "                          AND D3_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'  " +cEnter
cQuery+= "        WHERE  ZZ4_FILIAL = '01 '  " +cEnter
cQuery+= "               AND ZZ4_QTDUSR > 0  " +cEnter
cQuery+= "               AND ZZ4.D_E_L_E_T_ = ''  " +cEnter
cQuery+= "               AND D3_XHRINI <> ''  " +cEnter
cQuery+= "               AND D3_HORA <> ''  " +cEnter
cQuery+= "               AND D3_XHRINI < D3_HORA  " +cEnter
cQuery+= "        GROUP  BY D3_EMISSAO,  " +cEnter
cQuery+= "                  ZZ4_OP,  " +cEnter
cQuery+= "                  ZZ4_PROD,  " +cEnter
cQuery+= "                  ZZ4_QTDMTR,  " +cEnter
cQuery+= "                  D3_XHRINI,  " +cEnter
cQuery+= "                  D3_HORA " +cEnter
cQuery+= "				  ) AS TAB  " +cEnter
cQuery+= "INNER JOIN "+RetSqlname("SB1")+" SB1 ON B1_COD = TAB.PA AND SB1.D_E_L_E_T_ = ''" +cEnter
cQuery+= "WHERE TAB.PA  BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'  " +cEnter
cQuery+= "GROUP  BY TAB.PA,  " +cEnter
cQuery+= "          TAB.PROD,  " +cEnter
cQuery+= "          B1_GRUPO  " +cEnter
cQuery+= "		  HAVING ISNULL((SELECT G1_QUANT  " +cEnter
cQuery+= "               FROM   "+RetSqlName("SG1")+" SG1 WITH(NOLOCK)  " +cEnter
cQuery+= "               WHERE  G1_FILIAL = '"+Xfilial("SG1")+"'  " +cEnter
cQuery+= "                      AND G1_COD = TAB.PA  " +cEnter
cQuery+= "                      AND G1_COMP = TAB.PROD  " +cEnter
cQuery+= "                      AND SG1.D_E_L_E_T_ = ''), 0)  > 0  " +cEnter


//MemoWrite("DOMESTATIS.sql",cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)


if QRY->(!eof())
	while QRY->(!eof())
		dbselectArea("P11")
		P11->(dbSetOrder(1)) //P11_FILIAL, P11_PA, P11_MES,
		if P11->(!dbSeek(xFilial("P11")+QRY->PROD+DtOS(dDataBase)))
			If SUBSTRING(Alltrim(QRY->B1_GRUPO), 1,3) == "COR"
				For _i := 1 to 4
					RecLock("P11",.T.)
					P11->P11_FILIAL	:= xFilial("P11")
					P11->P11_PA     := QRY->PA
					P11->P11_FIBRA  := QRY->PROD
					P11->P11_MAQ	:=  "CORTE "+CVALTOCHAR(_i)
					P11->P11_TEMPO 	:= QRY->MEDIA
					P11->P11_DATA   := dDatabase
					P11->P11_DTINI   := MV_PAR03
					P11->P11_DTFIM   := MV_PAR04
					//P11->P11_LINHA 	:= ""
					P11->(MsUnLock())
				Next
			ElseIf SUBSTRING(Alltrim(QRY->B1_GRUPO), 1,3) == "TRU"
				RecLock("P11",.T.)
				P11->P11_FILIAL	:= xFilial("P11")
				P11->P11_PA     := QRY->PA
				P11->P11_FIBRA  := QRY->PROD
				P11->P11_MAQ	:=  "TRUNK 1"
				P11->P11_TEMPO 	:= QRY->MEDIA
				P11->P11_DATA   := dDatabase
				P11->P11_DTINI   := MV_PAR03
				P11->P11_DTFIM   := MV_PAR04
				//P11->P11_LINHA 	:= ""
				P11->(MsUnLock())
			ElseIf SUBSTRING(Alltrim(QRY->B1_GRUPO), 1,3) == "DRO"
				RecLock("P11",.T.)
				P11->P11_FILIAL	:= xFilial("P11")
				P11->P11_PA     := QRY->PA
				P11->P11_FIBRA  := QRY->PROD
				P11->P11_MAQ	:=  "DROP 1"
				P11->P11_TEMPO 	:= QRY->MEDIA
				P11->P11_DATA   := dDatabase
				P11->P11_DTINI   := MV_PAR03
				P11->P11_DTFIM   := MV_PAR04
				//P11->P11_LINHA 	:= ""
				P11->(MsUnLock())
			Endif
		Endif
		QRY->(dbSkip())
	End
	if _i > 0
		msgInfo("Atualização realizada com sucesso", "Successfull")
	Endif
else
	msgInfo("Não foram encontrados dados para a atualização da tabela de estatística." ,"Aviso")
Endif

Return



/*/{Protheus.doc} AjustaSX1
@author Ricardo Roda
@since 12/09/2019
@version undefined
/*/
Static Function AjustaSX1(cPerg)

DbSelectArea("SX1")
DbSetOrder(1)
aRegs :={}
aAdd(aRegs, {cPerg, "01", "Produto De  ?",     "", "", "mv_ch1", "C",15, 0, 0, "G", "", "MV_PAR01", ""     , "" , "" , "" , "", "" , "", "", "", "", ""       , "", "", "", "", ""    , "", "", "", "", "", "", "", "", "SB1", "" , "", "","","",""})
aAdd(aRegs, {cPerg, "02", "Produto Ate ?",     "", "", "mv_ch2", "C",15, 0, 0, "G", "", "MV_PAR02", ""     , "" , "" , "" , "", "" , "", "", "", "", ""       , "", "", "", "", ""    , "", "", "", "", "", "", "", "", "SB1", "" , "", "","","",""})

aAdd(aRegs, {cPerg, "03", "Data De  ?",        "", "", "mv_ch3", "D",10, 0, 0, "G", "", "MV_PAR03", ""     , "" , "" , "" , "", "" , "", "", "", "", ""       , "", "", "", "", ""    , "", "", "", "", "", "", "", "", ""   , "" , "", "","","",""})
aAdd(aRegs, {cPerg, "04", "Data Ate ?",        "", "", "mv_ch4", "D",10, 0, 0, "G", "", "MV_PAR04", ""     , "" , "" , "" , "", "" , "", "", "", "", ""       , "", "", "", "", ""    , "", "", "", "", "", "", "", "", ""   , "" , "", "","","",""})
fAjuSx1(cPerg,aRegs)

Return

/*/{Protheus.doc} fAjuSx1
@author Ricardo Roda
@since 12/09/2019
@version undefined
/*/
Static Function fAjuSx1(cPerg,aRegs)

Local _nTamX1, _nTamPe, _nTamDf := 0

DbSelectArea("SX1")
DbSetOrder(1)

// Indo ao Primeiro Registro do SX1, apenas para descobrir o tamanho do campo com o nome da PERGUNTA
// Campo chamado X1_GRUPO
DbGoTop()
_nTamX1	:= Len(SX1->X1_GRUPO)
_nTamPe	:= Len(Alltrim(cPerg))
_nTamDf	:= _nTamX1 - _nTamPe

// Adequando o Tamanho para Efetuar a Pesquisa no SX1
If _nTamDf > 0
	cPerg := cPerg + Space(_nTamDf)
ElseIf _nTamDf == 0
	cPerg := cPerg
Else
	Return()
EndIf

// Criando Perguntas caso NAO existam no SX1
For i:=1 to Len(aRegs)
	
	If !DbSeek(cPerg+aRegs[i,2])
		
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
		
		DbCommit()
	Endif
Next

Return()
