#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

#DEFINE CRLF Chr(13)+Chr(10)

//--------------------------------------------------------------
/*/{Protheus.doc} DOMETI01
Description ETIQUETA DE GRUPOS
@param xParam Parameter Description
@return xRet Return Description
@author  - Ricardo Roda
/*/
//--------------------------------------------------------------
User Function DOMET109(nQtdEtq)

private cLocImp 	:= "" 
private _aArq		:= {}
private aPar     	:= {}
private aRetPar   := {}     
private aCodEtq 	:= {}  
Private nQtdEti:= nQtdEtq


if empty(Alltrim(cLocImp))
    aAdd(aPar,{1,"Escolha a Impressora " ,SPACE(6) ,"@!"       ,'.T.' , 'CB5', '.T.', 20 , .T. } )
Endif

If !ParamBox(aPar,"INFORMAR IMPRESSORA",@aRetPar)
	Return
EndIf
   cLocImp:= ALLTRIM(aRetPar[1])

If !CB5SetImp(cLocImp,.F.)
	MsgAlert("Local de impressao invalido!","Aviso")
	Return 
EndIf

  MsgRun("Imprimindo...","Favor Aguardar.....",{||  fImp()() })   

Return



Static Function fImp()

//
AADD(_aArq,'I8,A,001'+ CRLF)
AADD(_aArq,'Q400,024'+ CRLF)
AADD(_aArq,'q831'+ CRLF)
AADD(_aArq,'rN'+ CRLF)
AADD(_aArq,'S3'+ CRLF)
AADD(_aArq,'D7'+ CRLF)
AADD(_aArq,'ZT'+ CRLF)
AADD(_aArq,'JF'+ CRLF)
AADD(_aArq,'O'+ CRLF)
AADD(_aArq,'R16,0'+ CRLF)
AADD(_aArq,'f100'+ CRLF)
AADD(_aArq,'N'+ CRLF)
AADD(_aArq,'A755,372,2,2,2,2,N,"GRUPO: A"'+ CRLF)
AADD(_aArq,'A488,377,2,2,2,2,N,"GRUPO: B"'+ CRLF)
AADD(_aArq,'A225,377,2,2,2,2,N,"GRUPO: C"'+ CRLF)
AADD(_aArq,'A753,266,2,2,2,2,N,"GRUPO: D"'+ CRLF)
AADD(_aArq,'A485,271,2,2,2,2,N,"GRUPO: E"'+ CRLF)
AADD(_aArq,'A222,271,2,2,2,2,N,"GRUPO: F"'+ CRLF)
AADD(_aArq,'A753,160,2,2,2,2,N,"GRUPO: G"'+ CRLF)
AADD(_aArq,'A485,165,2,2,2,2,N,"GRUPO: H"'+ CRLF)
AADD(_aArq,'A222,164,2,2,2,2,N,"GRUPO: I"'+ CRLF)
AADD(_aArq,'A750,052,2,2,2,2,N,"GRUPO: J"'+ CRLF)
AADD(_aArq,'A483,057,2,2,2,2,N,"GRUPO: K"'+ CRLF)
AADD(_aArq,'A220,056,2,2,2,2,N,"GRUPO: L"'+ CRLF)
AADD(_aArq,'P'+CVALTOCHAR(nQtdEti)+CRLF)

AaDd(aCodEtq,_aArq)
_aArq:= {}

For nY:=1 To Len(aCodEtq)
	For nP:=1 To Len(aCodEtq[nY])
		MSCBWrite(aCodEtq[nY][nP])
	Next nP
Next nY
            
//MSCBEND()
MSCBCLOSEPRINTER()

MSGINFO("IMPRESSÃO CONCLUIDA!","AVISO")

Return ( Nil )

