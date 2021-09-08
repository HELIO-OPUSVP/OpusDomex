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
@since 27/09/2019
/*/
//-------------------------------------------------------------
User Function DOMET115(cNumOP,nQtdEtq,nNumSerie)


	Local nEtiq 		:= 0
	Local _aArq		:= {}
	Local aCodEtq 	:= {}
	Local nPrint 	:= 0
	Local cDescSer  := ""
	Local nPos1  := 0
	Local nPos2  := 0
	Local _i
	Local nTam  := 0
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

	nPrint:= Ceiling(nQtdEtq/4)
	nNumEt:= 0

	DbSelectArea("SC2")
	SC2->(DbSetOrder(1))
	SC2->(DbSeek(xFilial("SC2")+cNumOP))
	nTam:= Len(cvaltochar(SC2->C2_QUANT))

	for _i := 1 to nPrint

		nEtiq:= 4

		if _i == nPrint
			nEtiqLin:= round(nQtdEtq/4,1) - int(round(nQtdEtq/4,1))
			If nEtiqLin = 0.3
				nEtiq:= 1
			ElseIf nEtiqLin = 0.5
				nEtiq:= 2
			ElseIf nEtiqLin  = 0.8
				nEtiq:= 3
			Else
				nEtiq:= 4
			Endif
		Endif

		AADD(_aArq,'CT~~CD,~CC^~CT~'+ CRLF)
		AADD(_aArq,'^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR3,3~SD28^JUS^LRN^CI0^XZ'+ CRLF)
		AADD(_aArq,'^XA'+ CRLF)
		AADD(_aArq,'^MMT'+ CRLF)
		AADD(_aArq,'^PW750'+ CRLF)
		AADD(_aArq,'^LL0283'+ CRLF)
		AADD(_aArq,'^LS0'+ CRLF)

		nAjLin  := 15
		If LEN(cCodFuruk) == 8
			nPos1  := 20
			nPos2  := 110
		Else
			nPos1  := 0
			nPos2  := 140
		Endif

		If nEtiq >= 1
			AADD(_aArq,'^BY42,42^FT51,'+cValtochar(68-nAjLin)+'^BXN,3,200,0,0,1,~'+ CRLF)
			AADD(_aArq,'^FH\^FD'+cValtoChar(nNumSerie+nNumEt)+'\09'+cValtoChar(cCodFuruk)+'^FS'+ CRLF)
			AADD(_aArq,'^FT22,'+cValtochar(89-nAjLin)+'^A0N,21,24^FB110,1,0,C^FH\^FD'+strzero((nNumSerie+nNumEt),ntam)+'A^FS'+ CRLF)
			AADD(_aArq,'^FT'+cvaltochar(2+nPos1)+','+cValtochar(115-nAjLin)+'^A0N,21,24^FB'+cvaltochar(nPos2)+',1,0,C^FH\^FD'+cValtoChar(cCodFuruk)+'^FS'+ CRLF)

			XD4->(dbSetOrder(1))
			Reclock("XD4", .T.)
			XD4->XD4_FILIAL	:= xFilial("XD4")
			XD4->XD4_SERIAL	:= (nNumSerie+nNumEt)
			XD4->XD4_STATUS	:= '6'
			XD4->XD4_OP	   	:= cNumOP
			XD4->XD4_NOMUSR	:= cUserSis
			XD4->XD4_DOC    := _cPrxDoc
			XD4->XD4_KEY 	:= "S"+Alltrim(cNumOP)+Alltrim(cValtoChar(nNumSerie+nNumEt))
			XD4->(MsUnlock())

		Endif

		If nEtiq >= 2
			AADD(_aArq,'^BY42,42^FT233,'+cValtochar(68-nAjLin)+'^BXN,3,200,0,0,1,~'+ CRLF)
			AADD(_aArq,'^FH\^FD'+cValtoChar(nNumSerie+(nNumEt+1))+'\09'+cValtoChar(cCodFuruk)+'^FS'+ CRLF)
			AADD(_aArq,'^FT204,'+cValtochar(89-nAjLin)+'^A0N,21,24^FB110,1,0,C^FH\^FD'+strzero((nNumSerie+(nNumEt+1)),ntam)+'A^FS'+ CRLF)
			AADD(_aArq,'^FT'+cvaltochar(184+nPos1)+','+cValtochar(115-nAjLin)+'^A0N,21,24^FB'+cvaltochar(nPos2)+',1,0,C^FH\^FD'+cValtoChar(cCodFuruk)+'^FS'+ CRLF)

			XD4->(dbSetOrder(1))
			Reclock("XD4", .T.)
			XD4->XD4_FILIAL	:= xFilial("XD4")
			XD4->XD4_SERIAL	:= (nNumSerie+nNumEt+1)
			XD4->XD4_STATUS	:= '6'
			XD4->XD4_OP	   	:= cNumOP
			XD4->XD4_NOMUSR	:= cUserSis
			XD4->XD4_DOC    := _cPrxDoc
			XD4->XD4_KEY 	:= "S"+Alltrim(cNumOP)+Alltrim(cValtoChar(nNumSerie+nNumEt+1))
			XD4->(MsUnlock())
		Endif

		If nEtiq >= 3
			AADD(_aArq,'^BY42,42^FT415,'+cValtochar(68-nAjLin)+'^BXN,3,200,0,0,1,~'+ CRLF)
			AADD(_aArq,'^FH\^FD'+cValtoChar(nNumSerie+(nNumEt+2))+'\09'+cValtoChar(cCodFuruk)+'^FS'+ CRLF)
			AADD(_aArq,'^FT388,'+cValtochar(89-nAjLin)+'^A0N,21,24^FB110,1,0,C^FH\^FD'+strzero((nNumSerie+(nNumEt+2)),ntam)+'A^FS'+ CRLF)
			AADD(_aArq,'^FT'+cvaltochar(368+nPos1)+','+cValtochar(115-nAjLin)+'^A0N,21,24^FB'+cvaltochar(nPos2)+',1,0,C^FH\^FD'+cValtoChar(cCodFuruk)+'^FS'+ CRLF)

			XD4->(dbSetOrder(1))
			Reclock("XD4", .T.)
			XD4->XD4_FILIAL	:= xFilial("XD4")
			XD4->XD4_SERIAL	:= (nNumSerie+nNumEt+2)
			XD4->XD4_STATUS	:= '6'
			XD4->XD4_OP	   	:= cNumOP
			XD4->XD4_NOMUSR	:= cUserSis
			XD4->XD4_DOC    := _cPrxDoc
			XD4->XD4_KEY 	:= "S"+Alltrim(cNumOP)+Alltrim(cValtoChar(nNumSerie+nNumEt+2))
			XD4->(MsUnlock())
		Endif

		If nEtiq == 4
			AADD(_aArq,'^BY42,42^FT600,'+cValtochar(68-nAjLin)+'^BXN,3,200,0,0,1,~'+ CRLF)
			AADD(_aArq,'^FH\^FD'+cValtoChar(nNumSerie+(nNumEt+3))+'\09'+cValtoChar(cCodFuruk)+'^FS'+ CRLF)
			AADD(_aArq,'^FT570,'+cValtochar(89-nAjLin)+'^A0N,21,24^FB110,1,0,C^FH\^FD'+strzero((nNumSerie+(nNumEt+3)),ntam)+'A^FS'+ CRLF)
			AADD(_aArq,'^FT'+cvaltochar(550+nPos1)+','+cValtochar(115-nAjLin)+'^A0N,21,24^FB'+cvaltochar(nPos2)+',1,0,C^FH\^FD'+cValtoChar(cCodFuruk)+'^FS'+ CRLF)

			XD4->(dbSetOrder(1))
			Reclock("XD4", .T.)
			XD4->XD4_FILIAL	:= xFilial("XD4")
			XD4->XD4_SERIAL	:= (nNumSerie+nNumEt+3)
			XD4->XD4_STATUS	:= '6'
			XD4->XD4_OP	   	:= cNumOP
			XD4->XD4_NOMUSR	:= cUserSis
			XD4->XD4_DOC    := _cPrxDoc
			XD4->XD4_KEY 	:= "S"+Alltrim(cNumOP)+Alltrim(cValtoChar(nNumSerie+nNumEt+3))
			XD4->(MsUnlock())
		Endif

		AADD(_aArq,'^PQ1,0,1,Y^XZ'+ CRLF)
		AaDd(aCodEtq,_aArq)
		_aArq:= {}
		nNumEt+= 4

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
