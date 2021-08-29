#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

#DEFINE CRLF Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DOMET107 ºAutor  ³ Ricardo Roda       º Data ³  02.07.2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Etiqueta Modelo 110  - Etiqueta IBM           		      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMET110(cNumOP,nQtdEtq,cNumSerie)

Local cCodCli:= ""
Local cCodProd:= ""
Local cTamProd:= ""

private cLocImp 	:= "" 
private _aArq		:= {}
private aPar     	:= {}
private aRetPar   := {}     
private aCodEtq 	:= {}  


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

  MsgRun("Imprimindo...","Favor Aguardar.....",{||  fImp(cNumOP,cNumSerie,nQtdEtq) })   

Return .T.



Static Function fImp(cNumOP,cNumSerie,nQtdEtq)

If !Empty(cNumOP)

	SC2->(DbSetOrder(1))
	If SC2->(!DbSeek(xFilial("SC2")+cNumOP))
		Alert("Numero O.P. "+AllTrim(cNumOP)+" não localizada!")
		Return 
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta o número de série										   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	cSerieFim := If( cNumSerie == 1, 1, cNumSerie )


	Do Case
			Case SC2->C2_QUANT <=9
				 nTamSerie:= 1	
			Case  SC2->C2_QUANT >=10 .And.  SC2->C2_QUANT <= 99
				 nTamSerie:= 2	
			Case  SC2->C2_QUANT >=100 .And. SC2->C2_QUANT <= 999
				 nTamSerie:= 3	
			Case  SC2->C2_QUANT >=1000 .And. SC2->C2_QUANT <= 9999
				 nTamSerie:= 4	
			Case  SC2->C2_QUANT >=10000 .And. SC2->C2_QUANT <= 99999
				 nTamSerie:= 5	
	EndCase
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona no PA																 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
SB1->(DbSetOrder(1))
If SB1->(!DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
	Alert("Produto "+AllTrim(SC2->C2_PRODUTO)+" não localizado!")
	Return 
else
	cCodProd:= SB1->B1_COD
	cTamProd:= cvalToChar(SB1->B1_XXMETIQ)
EndIf
	cCodCli:= fCodPrdCli(cNumOP,cCodProd )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
//³Montagem do código de barras 2D						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
cSQL    := "SELECT dbo.SemanaProtheus() AS SEMANA"
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"WEEK",.F.,.T.)
cSemana := WEEK->SEMANA
cWW     := StrZero(Val(SubsTr(cSemana,5,2)),2)
cYYYY     := Substr(cSemana,1,4)
WEEK->(dbCloseArea())

cSerie:= STRZERO(cNumSerie,nTamSerie)

For x := 1 To nQtdEtq

	AADD(_aArq,'CT~~CD,~CC^~CT~'+ CRLF)
	AADD(_aArq,'^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR2,2~SD21^JUS^LRN^CI0^XZ'+ CRLF)
	AADD(_aArq,'^XA'+ CRLF)
	AADD(_aArq,'^MMT'+ CRLF)
	AADD(_aArq,'^PW591'+ CRLF)
	AADD(_aArq,'^LL0295'+ CRLF)
	AADD(_aArq,'^LS0'+ CRLF)
	AADD(_aArq,'^FO448,0^GFA,02560,02560,00016,:Z64:'+ CRLF)
	AADD(_aArq,'eJztlEGOwjAMRV0qyAYpF6jUK7BkRXsUjsAB0CRHy1F6hC67qAjOzv8XFSEGaUbCUhavv7Z/XSsi3/j/kfRUhqOe2nBPenl/Y/isxxnOGjfDoTx4Q+f63J/9sf9E/ImoiNf6M5/l0/NzUH+QHcwvkZ5UrVf0R/k16Bv6PsxnvsgW+CD76EFvUmv4KM14MtzINdjv9XHqgPPczYZdHv1kuM6jGw1LTgIR5FcjynIfeH9t9KQPgvv/6n6UfKv3ZQTY31tWf2FGPcO8ND0B+xsgpheHA6DLcT19Ql6ko9xSt4Bmn/7eFt2Io3whO4sC/tUC3ZMCFRRQ8Wo5qWXS3WC41wJ2JEX7Mfzu/fJov/h+tvseSVf/i/3n+/QbfzHuEEKmPA==:0576'+ CRLF)
	AADD(_aArq,'^FT306,26^A0R,29,28^FH\^FDEC:^FS'+ CRLF)
	AADD(_aArq,'^FT266,26^A0R,29,28^FH\^FDDC:'+cYYYY+'/'+cWW+'^FS'+ CRLF)
	AADD(_aArq,'^FT384,26^A0R,29,28^FH\^FDSN: S'+alltrim(cNumOP)+cSerie+'^FS'+ CRLF)
	AADD(_aArq,'^FT226,26^A0R,29,28^FH\^FDVendor: RDT^FS'+ CRLF)
	AADD(_aArq,'^FT183,26^A0R,29,28^FH\^FDMade in Brazil^FS'+ CRLF)
	AADD(_aArq,'^FT345,26^A0R,29,28^FH\^FDLength:  '+alltrim(cTamProd)+'m^FS'+ CRLF)
	AADD(_aArq,'^FT143,26^A0R,29,28^FH\^FDRoHS Compliant^FS'+ CRLF)
	AADD(_aArq,'^FT424,26^A0R,29,28^FH\^FD'+cCodCli+'^FS'+ CRLF)
	AADD(_aArq,'^PQ1,0,1,Y^XZ'+ CRLF)

	cNumSerie := cNumSerie+1	
	cSerie:= STRZERO(cNumSerie,nTamSerie)
Next x           

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

Return 



Static Function fCodPrdCli(cNumOP,cCodProd )
Local cQuery:= ""
Local _CodCli:= ""

		If Select("QRY") > 0
			QRY->(dbCloseArea())
		Endif

	cQuery:= " SELECT DISTINCT C6_NUMOP, C6_ITEMOP, C6_PRODUTO, C6_SEUCOD  "
	cQuery+= " FROM "+RetSqlName("SC6")+" SC6  "
	cQuery+= " WHERE C6_NUMOP  = '"+substring(cNumOP,1,6)+"' "
	cQuery+= " AND C6_ITEMOP = '"+substring(cNumOP,7,2)+"' "
	cQuery+= " AND C6_PRODUTO = '"+cCodProd+"' "
	cQuery+= " AND SC6.D_E_L_E_T_ = '' "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)

		If !QRY->(eof())
			_CodCli:= QRY->C6_SEUCOD		
		Endif	

Return _CodCli
