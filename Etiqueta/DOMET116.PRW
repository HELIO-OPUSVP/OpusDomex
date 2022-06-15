#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

#DEFINE CRLF Chr(13)+Chr(10)

//--------------------------------------------------------------
/*/{Protheus.doc} DOMET115 (COPIA DOMETI02 PARA IMPRESSÃO NA ROTINA PA2)
Description ETIQUETA DE SERIAL CORTE FIBRA FURUKAWA 
@param xParam Parameter Description
@return xRet Return Description
@author  -
@since 01/09/2021
/*/
//-------------------------------------------------------------
User Function DOMET116(cNumOP,nQtdEtq,nNumSerie)

	Local _aArq		:= {}
	Local aCodEtq 	:= {}
	Local nPrint 	:= 0
	Local _i
	Local nTam  := 0
	Local nP
	Local nY
	Private cCodFuruk:= ""
	Private lFuruk := fFurukawa(cNumOP)
	Private cLocImp:= ""
	Private cUserSis	:= Upper(Alltrim(Substr(cUsuario,7,15)))
	Private _cPrxDoc:= fPrxDoc(cNumOP)
	private aRetPar   := {}
	Private aPar:= {}


	if !lFuruk
		MsgAlert("Ordem de produção não é Furukawa!","Aviso")
		Return .F.
	Endif
	if empty(Alltrim(cLocImp))
		aAdd(aPar,{1,"Escolha a Impressora " ,SPACE(6) ,"@!"       ,'.T.' , 'CB5', '.T.', 20 , .T. } )
	Endif

	If !ParamBox(aPar,"INFORMAR IMPRESSORA",@aRetPar)
		Return
	EndIf

	cLocImp := ALLTRIM(aRetPar[1])

	If !CB5SetImp(cLocImp,.F.)
		MsgAlert("Local de impressao invalido!","Aviso")
		Return .F.
	EndIf

	nPrint:= nQtdEtq
	nNumEt:= 0

	DbSelectArea("SC2")
	SC2->(DbSetOrder(1))
	SC2->(DbSeek(xFilial("SC2")+cNumOP))
	nTam:= Len(cvaltochar(SC2->C2_QUANT))

	for _i := 1 to nPrint

		AADD(_aArq,'CT~~CD,~CC^~CT~'+ CRLF)
		// AADD(_aArq,'^XA'+ CRLF)
		// AADD(_aArq,'~TA000'+ CRLF)
		// AADD(_aArq,'~JSN'+ CRLF)
		// AADD(_aArq,'^LT0'+ CRLF)
		// AADD(_aArq,'^MNW'+ CRLF)
		// AADD(_aArq,'^MTT'+ CRLF)
		// AADD(_aArq,'^PON'+ CRLF)
		// AADD(_aArq,'^PMN'+ CRLF)
		// AADD(_aArq,'^LH0,0'+ CRLF)
		// AADD(_aArq,'^JMA'+ CRLF)
		// AADD(_aArq,'^PR6,6'+ CRLF)
		// AADD(_aArq,'~SD15'+ CRLF)
		// AADD(_aArq,'^JUS'+ CRLF)
		// AADD(_aArq,'^LRN'+ CRLF)
		// AADD(_aArq,'^CI27'+ CRLF)
		// AADD(_aArq,'^PA0,1,1,0'+ CRLF)
		// AADD(_aArq,'^XZ'+ CRLF)
		AADD(_aArq,'^XA'+ CRLF)
		AADD(_aArq,'^MMT'+ CRLF)
		AADD(_aArq,'^PW591'+ CRLF)
		AADD(_aArq,'^LL142'+ CRLF)
		AADD(_aArq,'^LS0'+ CRLF)
		
		_nLin:= 90
		_nCol:= 365

		AADD(_aArq,'^FT'+cValToChar(_nCol+57)+','+cValToChar(_nLin)+'^BXN,4,200,0,0,1,_,1'+ CRLF)
		AADD(_aArq,'^FH\^FD'+cValtoChar(nNumSerie+nNumEt)+'\09'+cValtoChar(cCodFuruk)+'^FS'+ CRLF)
		AADD(_aArq,'^FT'+cValToChar(_nCol+42)+','+cValToChar(_nLin+30)+'^A0N,27,38^FH\^CI28^FD'+strzero((nNumSerie+nNumEt),ntam)+'^FS^CI27'+ CRLF)
		AADD(_aArq,'^FT'+cValToChar(_nCol)+','+cValToChar(_nLin+60)+'^A0N,31,33^FH\^CI28^FD'+cValtoChar(cCodFuruk)+'^FS^CI27'+ CRLF)
		
		AADD(_aArq,'^PQ1,0,1,Y'+ CRLF)
		AADD(_aArq,'^XZ'+ CRLF)
		AaDd(aCodEtq,_aArq)
		_aArq:= {}

		XD4->(dbSetOrder(1))
		Reclock("XD4", .T.)
		XD4->XD4_FILIAL	:= xFilial("XD4")
		XD4->XD4_SERIAL	:= (nNumSerie+nNumEt)
		XD4->XD4_STATUS	:= '6'
		XD4->XD4_OP	   	:= cNumOP
		XD4->XD4_NOMUSR	:= cUserSis
		XD4->XD4_DOC    := _cPrxDoc
		XD4->XD4_KEY 	:= cvaltochar(nNumSerie+nNumEt) + cCodFuruk
		XD4->(MsUnlock())
		nNumEt++

	Next _i

	For nY:=1 To Len(aCodEtq)
		For nP:=1 To Len(aCodEtq[nY])
			MSCBWrite(aCodEtq[nY][nP])
		Next nP
	Next nY

	aCodEtq:= {}

	nQtEti:= 0

	MSCBEND()
	MSCBCLOSEPRINTER()

Return ( Nil )


Static Function fFurukawa(cCodOp)
	local lRet:= .F.
	Local cQuery:= ""

	if select ("QRYFRK") > 0
		QRYFRK->(dbCloseArea())
	Endif
	cQuery+= " SELECT C2_PEDIDO, C6_SEUCOD , C6_CLI,C6_LOJA "
	cQuery+= " FROM "+RETSQLNAME("SC2")+" SC2
	cQuery+= " INNER JOIN "+RETSQLNAME("SC6")+" SC6 ON C6_NUM = C2_PEDIDO AND SC6.D_E_L_E_T_ = ''
	cQuery+= " AND C6_LOTECTL = C2_NUM+C2_ITEM
	cQuery+= " AND C6_FILIAL = '"+xFilial("SC6")+"' "
	cQuery+= " AND C6_CLI+C6_LOJA IN (	SELECT A1_COD+A1_LOJA FROM "+RETSQLNAME("SA1")+" "
	cQuery+= " 					WHERE A1_NOME LIKE '%FURUKAWA%'
	cQuery+= " 					AND A1_FILIAL = '"+xFilial("SA1")+"' "
	cQuery+= " 					AND D_E_L_E_T_= '')
	cQuery+= " AND C6_SEUCOD <> ''
	cQuery+= " WHERE SC2.D_E_L_E_T_= ''
	cQuery+= " AND C2_FILIAL = '"+xFilial("SC2")+"' "
	cQuery+= " AND C2_NUM+C2_ITEM+C2_SEQUEN = '"+alltrim(cCodOp)+"'
	cQuery+= " GROUP BY C2_PEDIDO, C6_SEUCOD , C6_CLI,C6_LOJA
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRYFRK",.T.,.T.)

	If QRYFRK->(!EOF())
		cCodFuruk:= alltrim(QRYFRK->C6_SEUCOD)
		lRet:= .T.
	Endif

Return lRet


Static function fPrxDoc(cNumOP)
	Local cPrxDoc:= ""

	if SELECT("QRYB") > 0
		QRYB->(dbCloseArea())
	Endif

	cQuery:= " SELECT MAX(XD4_DOC)AS PRXDOC FROM "+RetSqlName("XD4")+" XD4 "
	cQuery+= " WHERE XD4_OP = '"+cNumOP+"' "
	cQuery+= " AND XD4_FILIAL = '"+xFilial("XD4")+"' "
	cQuery+= " AND D_E_L_E_T_ = '' "

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRYB",.T.,.T.)

	if QRYB->(!Eof())
		cPrxDoc:= STRZERO((val(QRYB->PRXDOC)+1),6)
	Endif

Return cPrxDoc
