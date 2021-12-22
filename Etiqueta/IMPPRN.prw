#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ IMPPRN   บAutor  ณHelio Ferreira      บ Data ณ  18/11/21   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fonte padrใo de impressใo de etiquetas                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Starken                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function IMPPRN(cLocImp,cPrn,aVar,cVetor,lTemperatura)

	Local nP
	Local nY, x, y
	Local   _Retorno := ''
	Private lAchou   := .T.
	private aRetPar  := {}
	Private aPar     := {}
	Private aCodEtq  := {}
	Private _aArq    := {}
	Default cLocImp  := ""

	if empty(Alltrim(cLocImp))
		aAdd(aPar,{1,"Escolha a Impressora " ,SPACE(6) ,"@!"       ,'.T.' , 'CB5', '.T.', 20 , .T. } )
		If !ParamBox(aPar,"INFORMAR IMPRESSORA",@aRetPar)
			Return "INFORMAR IMPRESSORA"
		EndIf
		cLocImp := ALLTRIM(aRetPar[1])
	Endif

	If !CB5SetImp(cLocImp,.F.)   // Cรณdigo da impressora no CB5  Estoque/Atualizaรงรตes/ACD/Locais Impressรฃo
		// Se for imprimir vรกrias etiquetas, sรณ precisa desse comando uma vez
		MsgAlert("Local de impressao invalido!","Aviso")
		Return "Local de impressao invalido!"
	EndIf


	If !File("\IMPTER\LAYOUT\"+cPrn)
		Return "Arquivo .prn nใo encontrado"
	EndIf

	nHandle	 := FT_FUSE("\IMPTER\LAYOUT\"+cPrn)

	FT_FGOTOP()

	While ! FT_FEOF()
		cBuffer := FT_FREADLN()
		If lTemperatura
			AAdd( _aArq , cBuffer)
		Else
			If Subs(cBuffer,1,3) <> '~SD' // Caracteres de temperatura
				AAdd( _aArq , cBuffer)
			EndIf
		EndIf
		FT_FSKIP(1)
	EndDo

	FT_FUSE()  // Fecha o arquivo

	For x := 1 to Len(_aArq)
		For y := 1 to Len(aVar)
			cVar := cVetor + '['+Alltrim(StrZero(y,2))+']'
			If cVar $ _aArq[x]
				_aArq[x] := StrTran(_aArq[x],cVar,aVar[y])
			EndIf
		Next Y
		_aArq[x] := Alltrim(_aArq[x]) + CRLF
	Next x

	//AADD(_aArq,'~SD15'+CRLF)  // temperatura
	//AADD(_aArq,'^BY5,3,68^FT428,535^BCN,,Y,N'+CRLF) // Cรณdigo de barras tem que ficar essas duas linhas juntas
	//AADD(_aArq,'^FH\^FD>;123456789012^FS'+CRLF)
	//AADD(_aArq,'^PQ1,0,1,Y'+CRLF)   // PQ + NรMERO DE ETIQUETAS IGUAIS

	AaDd(aCodEtq,_aArq)

	For nY:=1 To Len(aCodEtq)
		For nP:=1 To Len(aCodEtq[nY])
			MSCBWrite(aCodEtq[nY][nP])
		Next nP
	Next nY

	MSCBEND()

	MSCBCLOSEPRINTER()   // Fecha a conexรฃo do CB5SetImp

Return _Retorno
