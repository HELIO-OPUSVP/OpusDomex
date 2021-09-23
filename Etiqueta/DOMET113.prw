#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

#DEFINE CRLF Chr(13)+Chr(10)

//--------------------------------------------------------------
/*/{Protheus.doc} 
Description ETIQUETA DE SERIAL CORTE FIBRA 
@param xParam Parameter Description
@return xRet Return Description
@author  - Ricardo Roda
@since 27/09/2019
/*/
//--------------------------------------------------------------
User Function DOMET113(cNumOP,nQtdEtq,nNumSerie)

	Local nEtiq 		:= 0
	Local _aArq		:= {}
	Local aCodEtq 	:= {}
	Local nPrint 	:= 0
	Local cUserSis	:= Upper(Alltrim(Substr(cUsuario,7,15)))
	Local cDescSer  := ""
	Local cLinha    := "SL"
	Local _i
	Local nP
	Local ny

	private aRetPar   := {}
	Private cLocImp
	Private aPar:= {}
	Private cUserSis	:= Upper(Alltrim(Substr(cUsuario,7,15)))
	Private _cPrxDoc:= fPrxDoc(cNumOP)

	If U_VALIDACAO() .or. .T.//Roda 30/07/2021
		If Empty(cNumOP)
			msgAlert("Numero da order de produção não informado ","aviso")
			Return
		Endif

		SC2->(DbSetOrder(1))
		If SC2->(!DbSeek(xFilial("SC2")+cNumOP))
			Alert("Numero O.P. "+AllTrim(cNumOP)+" não localizada!")
			Return
		EndIf

		if empty(Alltrim(cLocImp))
			aAdd(aPar,{1,"Escolha a Impressora " ,SPACE(6) ,"@!"       ,'.T.' , 'CB5', '.T.', 20 , .T. } )
		Endif

		If !ParamBox(aPar,"INFORMAR IMPRESSORA",@aRetPar)
			Return
		EndIf

		cLocImp := ALLTRIM(aRetPar[1])

		IF !CB5SetImp(cLocImp,.F.)
			MsgAlert("Local de impressao invalido!","Aviso")
			Return .F.
		EndIf

		dbSelectArea("P10")
		P10->(DBSetOrder(1))
		If P10->(DbSeek(xFilial("P10")+alltrim(cNumOP)))
			cLinha:= "L"+SUBSTRING(ALLTRIM(P10->P10_LINHA),Len(ALLTRIM(P10->P10_LINHA)),1 )
		Endif

		cNSerie:="S"+Alltrim(cNumOP)
		cDescSer:= Alltrim(cNumOP)

		nPrint:= Ceiling(nQtdEtq/3)
		nNumEt:= 0

		DbSelectArea("SC2")
		SC2->(DbSetOrder(1))
		SC2->(DbSeek(xFilial("SC2")+cNumOP))

		for _i := 1 to nPrint

			nEtiq:= 3
			if _i == nPrint
				nEtiqLin:= round(nQtdEtq/3,1)- int(round(nQtdEtq/3,1))
				If nEtiqLin > 0 .AND. nEtiqLin < 0.6
					nEtiq:= 1
				ElseIf nEtiqLin > 0.6
					nEtiq:= 2
				ElseIf nEtiqLin == 0 .AND. nEtiqLin <= 0.5
					nEtiq:= 3
				Endif
			Endif

			AADD(_aArq,'I8,A,001'+ CRLF)
			AADD(_aArq,'Q80,024'+ CRLF)
			AADD(_aArq,'q831'+ CRLF)
			AADD(_aArq,'rN'+ CRLF)
			AADD(_aArq,'S2'+ CRLF)
			AADD(_aArq,'D10'+ CRLF)
			AADD(_aArq,'ZT'+ CRLF)
			AADD(_aArq,'JF'+ CRLF)
			AADD(_aArq,'O'+ CRLF)
			AADD(_aArq,'R20,0'+ CRLF)
			AADD(_aArq,'f100'+ CRLF)
			AADD(_aArq,'N'+ CRLF)

			If nEtiq >= 1
				AADD(_aArq,'A689,37,2,2,1,1,N,"'+cValtoChar(nNumSerie+nNumEt)+'"'+ CRLF)
				AADD(_aArq,'A707,60,2,1,1,1,N,"'+cDescSer+'"'+ CRLF)
				AADD(_aArq,'A728,10,1,2,1,1,N,"'+SUBSTRING(cNumOP,7,5)+'"'+ CRLF)
				AADD(_aArq,'A750,10,1,2,1,1,N,"'+SUBSTRING(cNumOP,1,6)+'"'+ CRLF)
				AADD(_aArq,'b547,14,D,h2,"'+cNSerie+cValtoChar(nNumSerie+nNumEt)+SPACE(5-LEN(cValtoChar(nNumSerie+nNumEt)))+'"'+ CRLF)
				AADD(_aArq,'A624,5,1,1,2,2,N,"'+cLinha+'"'+ CRLF)

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
				AADD(_aArq,'A429,37,2,2,1,1,N,"'+cValtoChar(nNumSerie+(nNumEt+1))+'"'+ CRLF)
				AADD(_aArq,'A447,60,2,1,1,1,N,"'+cDescSer+'"'+ CRLF)
				AADD(_aArq,'A468,10,1,2,1,1,N,"'+SUBSTRING(cNumOP,7,5)+'"'+ CRLF)
				AADD(_aArq,'A491,10,1,2,1,1,N,"'+SUBSTRING(cNumOP,1,6)+'"'+ CRLF)
				AADD(_aArq,'b287,14,D,h2,"'+cNSerie+cValtoChar(nNumSerie+(nNumEt+1))+SPACE(5-LEN(cValtoChar(nNumSerie+nNumEt+1)))+'"'+ CRLF)
				AADD(_aArq,'A366,5,1,1,2,2,N,"'+cLinha+'"'+ CRLF)

				XD4->(dbSetOrder(1))
				Reclock("XD4", .T.)
				XD4->XD4_FILIAL	:= xFilial("XD4")
				XD4->XD4_SERIAL	:= (nNumSerie+(nNumEt+1))
				XD4->XD4_STATUS	:= '6'
				XD4->XD4_OP	   	:= cNumOP
				XD4->XD4_NOMUSR	:= cUserSis
				XD4->XD4_DOC    := _cPrxDoc
				XD4->XD4_KEY 	:= "S"+Alltrim(cNumOP)+Alltrim(cValtoChar(nNumSerie+(nNumEt+1)))
				XD4->(MsUnlock())

			Endif

			If nEtiq == 3
				AADD(_aArq,'A170,37,2,2,1,1,N,"'+cValtoChar(nNumSerie+(nNumEt+2))+'"'+ CRLF)
				AADD(_aArq,'A182,60,2,1,1,1,N,"'+cDescSer+'"'+ CRLF)
				AADD(_aArq,'A210,10,1,2,1,1,N,"'+SUBSTRING(cNumOP,7,5)+'"'+ CRLF)
				AADD(_aArq,'A232,10,1,2,1,1,N,"'+SUBSTRING(cNumOP,1,6)+'"'+ CRLF)
				AADD(_aArq,'b23,14,D,h2,"'+cNSerie+cValtoChar(nNumSerie+(nNumEt+2))+SPACE(5-LEN(cValtoChar(nNumSerie+nNumEt+2)))+'"'+ CRLF)
				AADD(_aArq,'A107,5,1,1,2,2,N,"'+cLinha+'"'+ CRLF)

				XD4->(dbSetOrder(1))
				Reclock("XD4", .T.)
				XD4->XD4_FILIAL	:= xFilial("XD4")
				XD4->XD4_SERIAL	:= (nNumSerie+(nNumEt+2))
				XD4->XD4_STATUS	:= '6'
				XD4->XD4_OP	   	:= cNumOP
				XD4->XD4_NOMUSR	:= cUserSis
				XD4->XD4_DOC    := _cPrxDoc
				XD4->XD4_KEY 	:= "S"+Alltrim(cNumOP)+Alltrim(cValtoChar(nNumSerie+(nNumEt+2)))
				XD4->(MsUnlock())

			Endif

			AADD(_aArq,'P1'+ CRLF)
			AaDd(aCodEtq,_aArq)
			_aArq:= {}

			nNumEt+= 3

		Next _i

		For nY:=1 To Len(aCodEtq)
			For nP:=1 To Len(aCodEtq[nY])
				MSCBWrite(aCodEtq[nY][nP])
			Next nP
		Next nY

		aCodEtq:= {}

		nQtEti:= 0
		MSCBCLOSEPRINTER()
	Endif
Return ( Nil )



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
