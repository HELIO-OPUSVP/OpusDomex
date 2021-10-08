#include "protheus.ch"
#include "rwmake.ch"

/*/Protheus.doc DOMET111
description Etiqueta amazon
function
	author Ricardo Roda
	since 29/03/2021
/*/ 
User Function DOMET112(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,cVolumeAtu,lColetor,cNumSerie,cNumPeca)

	Local lAchou := .T.
	Local _aArq:= {}
	Local aCodEtq:= {}
	Local nY
	Local np
	Default cNumOP   := ""
	Default cNumSenf := ""
	Default nQtdEmb  := 0
	Default nQtdEtq  := 0
	Default cNivel   := ""
	Default aFilhas  := {}
	Default cNumSerie := ""
	Default cNumPeca  := ""
	Default lColetor:= .T.
	private aRetPar   := {}
	Private cfila
	Private aPar:= {}
	//MVPAR02:= nQtdEmb   //Qtd Embalagem
	//MVPAR03:= nQtdEtq   //Qtd Etiquetas /*revisar*/

	If Empty(cNumOP)
		msgAlert("Numero da order de produção não informado ","aviso")
		lAchou:=  .F.
	Endif

	SC2->(DbSetOrder(1))
	If lAchou .And. SC2->(!DbSeek(xFilial("SC2")+cNumOP))
		Alert("Numero O.P. "+AllTrim(cNumOP)+" não localizada!")
		lAchou:=  .F.
	EndIf

	//Localiza SC5
	If lAchou .And. !Empty(SC2->C2_PEDIDO)
		SC5->(DbSetOrder(1))
		If lAchou .And. SC5->(!DbSeek(xFilial("SC5")+SC2->C2_PEDIDO))
			Alert("Numero de Senf "+AllTrim(SC2->C2_PEDIDO)+" não localizado!")
			lAchou := .F.
		EndIf

		//Localiza SC6
		SC6->(DbSetOrder(1))
		If lAchou .And. SC6->(!DbSeek(xFilial("SC6")+SC2->C2_PEDIDO+SC2->C2_ITEMPV))
			Alert("Item Senf "+AllTrim(SC2->C2_ITEMPV)+" não localizado!")
			lAchou := .F.
		Else
			_CodCli= SC6->C6_SEUCOD
		EndIf
	EndIf

	//Localiza SA1
	SA1->(DbSetOrder(1))
	If !Empty(SC2->C2_PEDIDO)
		If lAchou .And. SA1->(!DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
			Alert("Cliente "+SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI+" não localizado!")
			lAchou := .F.
		EndIf
		cPaisDest := Posicione("SYA",1,SA1->A1_FILIAL+SA1->A1_PAIS,"YA_DESCR")
	EndIf

//Localiza SB1
	SB1->(DbSetOrder(1))
	If lAchou .And. SB1->(!DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
		Alert("Produto "+AllTrim(SC2->C2_PRODUTO)+" não localizado!")
		lAchou := .F.
	Else
		cDescr:= SB1->B1_DESC
	EndIf

	ZZU->(dbSetOrder(1))//ZZU_FILIAL, ZZU_PEDIDO, ZZU_ITEM
	IF lAchou .and. ZZU->(!DbSeek(xFilial("ZZU")+SC2->C2_PEDIDO+SC2->C2_ITEMPV))
		Alert("Etiquetas não importadas!")
		lAchou := .F.
	Endif

	//Caso algum registro não seja localizado, sair da rotina
	If !lAchou
		Return(.F.)
	EndIf


	if empty(Alltrim(cfila))
		aAdd(aPar,{1,"Escolha a Impressora " ,SPACE(6) ,"@!"       ,'.T.' , 'CB5', '.T.', 20 , .T. } )
	Endif

	If !ParamBox(aPar,"INFORMAR IMPRESSORA",@aRetPar)
		Return
	EndIf

	cFila := ALLTRIM(aRetPar[1])

	//cFila := "000000"
	IF !CB5SetImp(cFila,.F.)
		U_MsgColetor("Local de impressao invalido!")
		Return .F.
	EndIf

	lRetrato:= .T.

	While ZZU->(!eof()) .AND. ZZU->ZZU_PEDIDO == SC2->C2_PEDIDO .AND. ZZU->ZZU_ITEM == SC2->C2_ITEMPV

	/*	IF LEN (alltrim(ZZU->ZZU_LABEL1)) > 21 .OR. LEN (alltrim(ZZU->ZZU_LABEL4)) > 24
			lRetrato:= .F.
		Endif
		AADD(_aArq,'CT~~CD,~CC^~CT~'+ CRLF)
		AADD(_aArq,'^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR2,2~SD20^JUS^LRN^CI0^XZ'+ CRLF)
		AADD(_aArq,'^XA'+ CRLF)
		AADD(_aArq,'^MMT'+ CRLF)
		AADD(_aArq,'^PW406'+ CRLF)
		AADD(_aArq,'^LL0196'+ CRLF)
		AADD(_aArq,'^LS0'+ CRLF)
		iF lRetrato
			nIniLin:= 380
			nLinInc:= 22
			AADD(_aArq,'^FT'+cValToChar(nIniLin-(nLinInc*1)) +',15^A0R,17,16^FH\^FD'+alltrim(ZZU->ZZU_LABEL1)+'^FS'+ CRLF)
			AADD(_aArq,'^FT'+cValToChar(nIniLin-(nLinInc*2)) +',56^A0R,17,16^FH\^FD'+alltrim(ZZU->ZZU_LABEL2)+'^FS'+ CRLF)
			AADD(_aArq,'^FT'+cValToChar(nIniLin-(nLinInc*3)) +',53^A0R,17,16^FH\^FD'+alltrim(ZZU->ZZU_LABEL3)+'^FS'+ CRLF)
			AADD(_aArq,'^FT'+cValToChar(nIniLin-(nLinInc*4)) +',12^A0R,14,14^FH\^FD'+alltrim(ZZU->ZZU_LABEL4)+'^FS'+ CRLF)
			AADD(_aArq,'^FT'+cValToChar(nIniLin-(nLinInc*5)) +',56^A0R,17,16^FH\^FD'+alltrim(ZZU->ZZU_LABEL5)+'^FS'+ CRLF)
			AADD(_aArq,'^FT'+cValToChar(nIniLin-(nLinInc*6)) +',15^A0R,17,16^FH\^FD'+alltrim(ZZU->ZZU_LABEL6)+'^FS'+ CRLF)
		ELSE
			nIniLin:= 10//43
			nLinInc:= 22
			AADD(_aArq,'^FT26,'+cValToChar(nIniLin+(nLinInc*1)) +'^A0N,17,16^FH\^FD'+alltrim(ZZU->ZZU_LABEL1)+'^FS'+ CRLF)
			AADD(_aArq,'^FT26,'+cValToChar(nIniLin+(nLinInc*2)) +'^A0N,17,16^FH\^FD'+alltrim(ZZU->ZZU_LABEL2)+'^FS'+ CRLF)
			AADD(_aArq,'^FT26,'+cValToChar(nIniLin+(nLinInc*3)) +'^A0N,17,16^FH\^FD'+alltrim(ZZU->ZZU_LABEL3)+'^FS'+ CRLF)
			AADD(_aArq,'^FT26,'+cValToChar(nIniLin+(nLinInc*4)) +'^A0N,17,14^FH\^FD'+alltrim(ZZU->ZZU_LABEL4)+'^FS'+ CRLF)
			AADD(_aArq,'^FT26,'+cValToChar(nIniLin+(nLinInc*5)) +'^A0N,17,16^FH\^FD'+alltrim(ZZU->ZZU_LABEL5)+'^FS'+ CRLF)
			AADD(_aArq,'^FT26,'+cValToChar(nIniLin+(nLinInc*6)) +'^A0N,17,16^FH\^FD'+alltrim(ZZU->ZZU_LABEL6)+'^FS'+ CRLF)
		ENDIF	
		AADD(_aArq,'^PQ2,0,1,Y^XZ'+ CRLF)

*/
		//AADD(_aArq,'CT~~CD,~CC^~CT~'+ CRLF)
		AADD(_aArq,'^XA'+ CRLF)
		AADD(_aArq,'~TA000'+ CRLF)
		AADD(_aArq,'~JSN'+ CRLF)
		AADD(_aArq,'^LT0'+ CRLF)
		AADD(_aArq,'^MNW'+ CRLF)
		AADD(_aArq,'^MTT'+ CRLF)
		AADD(_aArq,'^PON'+ CRLF)
		AADD(_aArq,'^PMN'+ CRLF)
		AADD(_aArq,'^LH0,0'+ CRLF)
		AADD(_aArq,'^JMA'+ CRLF)
		AADD(_aArq,'^PR8,8'+ CRLF)
	//	AADD(_aArq,'~SD15'+ CRLF)
		AADD(_aArq,'^JUS'+ CRLF)
		AADD(_aArq,'^LRN'+ CRLF)
		AADD(_aArq,'^CI27'+ CRLF)
		AADD(_aArq,'^PA0,1,1,0'+ CRLF)
		AADD(_aArq,'^XZ'+ CRLF)
	
		AADD(_aArq,'^XA'+ CRLF)
		AADD(_aArq,'^MMT'+ CRLF)
		AADD(_aArq,'^PW400'+ CRLF)
		AADD(_aArq,'^LL400'+ CRLF)
		AADD(_aArq,'^LS0'+ CRLF)
		AADD(_aArq,'^FT15,33^A0N,17,18^FH\^CI28^FD' +alltrim(ZZU->ZZU_LABEL1)+'^FS^CI27'+ CRLF)
		AADD(_aArq,'^FT15,56^A0N,17,18^FH\^CI28^FD' +alltrim(ZZU->ZZU_LABEL2)+'^FS^CI27'+ CRLF)
		AADD(_aArq,'^FT15,79^A0N,17,18^FH\^CI28^FD' +alltrim(ZZU->ZZU_LABEL3)+'^FS^CI27'+ CRLF)
		AADD(_aArq,'^FT15,102^A0N,17,18^FH\^CI28^FD'+alltrim(ZZU->ZZU_LABEL4)+'^FS^CI27'+ CRLF)
		AADD(_aArq,'^FT15,125^A0N,17,18^FH\^CI28^FD'+alltrim(ZZU->ZZU_LABEL5)+'^FS^CI27'+ CRLF)
		AADD(_aArq,'^FT15,149^A0N,17,18^FH\^CI28^FD'+alltrim(ZZU->ZZU_LABEL6)+'^FS^CI27'+ CRLF)
		AADD(_aArq,'^PQ2,0,1,Y'+ CRLF)
		AADD(_aArq,'^XZ'+ CRLF)

		aCodEtq:= {}
		AaDd(aCodEtq,_aArq)
		_aArq:= {}

		For nY:=1 To Len(aCodEtq)
			For nP:=1 To Len(aCodEtq[nY])
				MSCBWrite(aCodEtq[nY][nP])
			Next nP
		Next nY

	

		MSCBEND()
		ZZU->(dbSkip())
	End

	MSCBCLOSEPRINTER()
	//Finaliza impressão da etiqueta


Return(.T.)

