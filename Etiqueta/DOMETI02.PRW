#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

#DEFINE CRLF Chr(13)+Chr(10)

//--------------------------------------------------------------
/*/{Protheus.doc} DOMETI02
Description ETIQUETA DE SERIAL CORTE FIBRA FURUKAWA
@param xParam Parameter Description
@return xRet Return Description
@author  -
@since 27/09/2019
/*/
//-------------------------------------------------------------
User Function DOMETI02(cNumOP,nQtdEtq,nNumSerie,cLocImp,cCodFuruk,nTam)


Local nEtiq 		:= 0
Local _aArq		:= {}
Local aCodEtq 	:= {}
Local nPrint 	:= 0
Local cUserSis	:= Upper(Alltrim(Substr(cUsuario,7,15)))
Local cDescSer  := ""
Local nPos1  := 0
Local nPos2  := 0 
Local lNewFuruk:= SuperGetMv("MV_NEWFRK",.F.,.T.)
Local _i

IF lNewFuruk
	U_DOMET116(cNumOP,nQtdEtq,nNumSerie,cLocImp,.F.)
	RETURN .T.
ENDIF

if Empty(alltrim(cLocImp)) 
    MsgAlert("Local de impressao não informado!","Aviso")
	Return .F.
Endif

If !CB5SetImp(cLocImp,.F.)
	MsgAlert("Local de impressao invalido!","Aviso")
	Return .F.
EndIf

nPrint:= Ceiling(nQtdEtq/4)
nNumEt:= 0

DbSelectArea("SC2")
SC2->(DbSetOrder(1))
SC2->(DbSeek(xFilial("SC2")+cNumOP))

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
		nPos2  := 150 
	Endif 

	If nEtiq >= 1
        AADD(_aArq,'^BY42,42^FT51,'+cValtochar(68-nAjLin)+'^BXN,3,200,0,0,1,~'+ CRLF)
        AADD(_aArq,'^FH\^FD'+cValtoChar(nNumSerie+nNumEt)+'\09'+cValtoChar(cCodFuruk)+'^FS'+ CRLF)
        AADD(_aArq,'^FT22,'+cValtochar(89-nAjLin)+'^A0N,21,24^FB110,1,0,C^FH\^FD'+strzero((nNumSerie+nNumEt),ntam)+'A^FS'+ CRLF)
        AADD(_aArq,'^FT'+cvaltochar(1+nPos1)+','+cValtochar(115-nAjLin)+'^A0N,21,24^FB'+cvaltochar(nPos2)+',1,0,C^FH\^FD'+cValtoChar(cCodFuruk)+'^FS'+ CRLF)
	Endif

	If nEtiq >= 2
        AADD(_aArq,'^BY42,42^FT233,'+cValtochar(68-nAjLin)+'^BXN,3,200,0,0,1,~'+ CRLF)
        AADD(_aArq,'^FH\^FD'+cValtoChar(nNumSerie+(nNumEt+1))+'\09'+cValtoChar(cCodFuruk)+'^FS'+ CRLF)
        AADD(_aArq,'^FT204,'+cValtochar(89-nAjLin)+'^A0N,21,24^FB110,1,0,C^FH\^FD'+strzero((nNumSerie+(nNumEt+1)),ntam)+'A^FS'+ CRLF)
        AADD(_aArq,'^FT'+cvaltochar(183+nPos1)+','+cValtochar(115-nAjLin)+'^A0N,21,24^FB'+cvaltochar(nPos2)+',1,0,C^FH\^FD'+cValtoChar(cCodFuruk)+'^FS'+ CRLF)
	Endif
	
	If nEtiq >= 3
	    AADD(_aArq,'^BY42,42^FT415,'+cValtochar(68-nAjLin)+'^BXN,3,200,0,0,1,~'+ CRLF)
        AADD(_aArq,'^FH\^FD'+cValtoChar(nNumSerie+(nNumEt+2))+'\09'+cValtoChar(cCodFuruk)+'^FS'+ CRLF)
        AADD(_aArq,'^FT388,'+cValtochar(89-nAjLin)+'^A0N,21,24^FB110,1,0,C^FH\^FD'+strzero((nNumSerie+(nNumEt+2)),ntam)+'A^FS'+ CRLF)
        AADD(_aArq,'^FT'+cvaltochar(367+nPos1)+','+cValtochar(115-nAjLin)+'^A0N,21,24^FB'+cvaltochar(nPos2)+',1,0,C^FH\^FD'+cValtoChar(cCodFuruk)+'^FS'+ CRLF)
	Endif

    If nEtiq == 4
		AADD(_aArq,'^BY42,42^FT600,'+cValtochar(68-nAjLin)+'^BXN,3,200,0,0,1,~'+ CRLF)
        AADD(_aArq,'^FH\^FD'+cValtoChar(nNumSerie+(nNumEt+3))+'\09'+cValtoChar(cCodFuruk)+'^FS'+ CRLF)
        AADD(_aArq,'^FT570,'+cValtochar(89-nAjLin)+'^A0N,21,24^FB110,1,0,C^FH\^FD'+strzero((nNumSerie+(nNumEt+3)),ntam)+'A^FS'+ CRLF)
        AADD(_aArq,'^FT'+cvaltochar(549+nPos1)+','+cValtochar(115-nAjLin)+'^A0N,21,24^FB'+cvaltochar(nPos2)+',1,0,C^FH\^FD'+cValtoChar(cCodFuruk)+'^FS'+ CRLF)
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

