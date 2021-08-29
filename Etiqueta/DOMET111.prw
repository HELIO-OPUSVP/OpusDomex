#include "protheus.ch"
#include "rwmake.ch"

/*/Protheus.doc DOMET111
description Etiqueta claro
function
author Ricardo Roda
since 29/03/2021
/*/ 
User Function DOMET111(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,cVolumeAtu,lColetor,cNumSerie,cNumPeca)

	Local cModelo    := "Z4M"
	Local cPorta     := "LPT1"
	Local lPrinOK    := MSCBModelo("ZPL",cModelo)
	Local aPar       := {}
	Local aRet       := {}
	Local nVar       := 0
	Local aItemXD2  := {}
	Local MVPAR02   := 1         //Qtd Embalagem
	Local MVPAR03   := 1         //Qtd Etiquetas

	Private lAchou   := .T.
	Private aGrpAnat := {}     //Codigos Anatel Agrupados
	Private nColV    := 0
	Private nCol     := 0
	Private nIni     := 0
	Private nLin     := 0
	Private nIniXD2  := 0
	Private cRotacao   := "N"      //(N,R,I,B)
	Private cPaisDest := ""
	Private cFila	  := ""
	Private	_aArq	:= {}
	Private	aCodEtq:= {}
	Private _CodCli:= ""
	Private cDescr:= ""


	Default cNumOP   := ""
	Default cNumSenf := ""
	Default nQtdEmb  := 0
	Default nQtdEtq  := 0
	Default cNivel   := ""
	Default aFilhas  := {}
	Default cNumSerie := ""
	Default cNumPeca  := ""
	Default lColetor:= .T.

	MVPAR02:= nQtdEmb   //Qtd Embalagem
	MVPAR03:= nQtdEtq   //Qtd Etiquetas /*revisar*/

	If !Empty(cNumOP)
		//Localiza SC2
		SC2->(DbSetOrder(1))
		If lAchou .And. SC2->(!DbSeek(xFilial("SC2")+cNumOP))
			Alert("Numero O.P. "+AllTrim(cNumOP)+" não localizada!")
			lAchou := .F.
		EndIf

		//Localiza SC5
		If !Empty(SC2->C2_PEDIDO)
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
	EndIf

	If !Empty(cNumSenf)
		//Localiza SC5
		SC5->(DbSetOrder(1))
		If lAchou .And. SC5->(!DbSeek(xFilial("SC5")+Subs(cNumSenf,1,6) ))
			Alert("Numero de Senf "+Subs(cNumSenf,1,6)+" não localizado!")
			lAchou := .F.
		EndIf

		//Localiza SC6
		SC6->(DbSetOrder(1))
		If lAchou .And. SC6->(!DbSeek(xFilial("SC6")+Subs(cNumSenf,1,8) ))
			Alert("Item Senf "+Subs(cNumSenf,7,2) +" não localizado!")
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

//Caso algum registro não seja localizado, sair da rotina
	If !lAchou
		Return(.F.)
	EndIf

//Se impressora não identificada, sair da rotina
	If !lPrinOK
		Alert("Erro de configuração!")
		Return(.F.)
	EndIf

	If lImpressao
		//Controla o numero da etiqueta de embalagens
		If Empty(cNumPeca)
			_cProxPeca := U_IXD1PECA()
		Else
			_cProxPeca := cNumPeca
		EndIf

		XD1->(dbSetOrder(1))
		aItemXD2 := {}

		For _nX := 1 to Len(aFilhas)
			Reclock("XD2",.T.)
			XD2->XD2_FILIAL := xFilial("XD2")
			XD2->XD2_XXPECA := _cProxPeca
			XD2->XD2_PCFILH := aFilhas[_nX,1]
			XD2->( msUnlock() )

			If XD1->(dbSeek(xFilial()+XD2->XD2_PCFILH))
				AADD( aItemXD2, { aFilhas[_NX,1], aFilhas[_NX,4], XD1->XD1_COD, XD1->XD1_QTDATU } )
			Else
				U_MsgColetor("Registro do XD2 não encontrado no XD1") 
			EndIf

		Next _nX

		ASORT(aItemXD2,2,,{ |x, y| x[1] < y[1] })

		Reclock("XD1",.T.)
		XD1->XD1_FILIAL    := xFilial("XD1")
		XD1->XD1_XXPECA    := _cProxPeca
		XD1->XD1_FORNEC    := Space(06)
		XD1->XD1_LOJA      := Space(02)
		XD1->XD1_DOC       := Space(06)
		XD1->XD1_SERIE     := Space(03)
		XD1->XD1_ITEM      := ""
		XD1->XD1_COD       := SB1->B1_COD
		XD1->XD1_LOCAL     := SB1->B1_LOCPAD
		XD1->XD1_TIPO      := SB1->B1_TIPO
		XD1->XD1_LOTECT    := U_RetLotC6(cNumOP)
		XD1->XD1_DTDIGI    := dDataBase
		XD1->XD1_FORMUL    := ""
		XD1->XD1_LOCALI    := ""
		XD1->XD1_USERID    := __cUserId
		XD1->XD1_OCORRE    := "6"
		XD1->XD1_PV        := cNumSenf
		XD1->XD1_QTDORI    := nQtdEtq
		XD1->XD1_QTDATU    := nQtdEtq
		XD1->XD1_EMBALA    := ""
		XD1->XD1_QTDEMB    := nQtdEtq
		XD1->XD1_NIVEMB    := "P"
		XD1->XD1_ULTNIV    := "S"
		If !Empty(SC2->C2_PEDIDO)
			XD1->XD1_PVSEP     := SC5->C5_NUM
		EndIf
		XD1->XD1_PESOB    := nPesoVol
		XD1->XD1_VOLUME   := cVolumeAtu
		XD1->XD1_SERIAL   := cNumSerie
		XD1->( MsUnlock() )

		/* iF !lColetor

		if empty(Alltrim(cLocImp))
				aAdd(aPar,{1,"Escolha a Impressora " ,SPACE(6) ,"@!"       ,'.T.' , 'CB5', '.T.', 20 , .T. } )
		Endif

		If !ParamBox(aPar,"INFORMAR IMPRESSORA",@aRetPar)
				Return
		EndIf
			cFila:= ALLTRIM(aRetPar[1])

	Endif */
		
		cFila := SuperGetMv("MV_XFILEXP",.F.,"000005")
		IF !CB5SetImp(cFila,.F.)
				U_MsgColetor("Local de impressao invalido!")
				Return .F.
		EndIf


		// MSCBPRINTER(cModelo,cPorta,,,.F.)
		// MSCBChkStatus(.F.)
		// MSCBBEGIN(1,5)

		x:= 0
		lCabec:= .T.

	For y := 1 to Len(aItemXD2)
	
		if lCabec
				AADD(_aArq,'CT~~CD,~CC^~CT~'+ CRLF)
				AADD(_aArq,'^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR2,2~SD21^JUS^LRN^CI0^XZ'+ CRLF)
				AADD(_aArq,'^XA'+ CRLF)
				AADD(_aArq,'^MMT'+ CRLF)
				AADD(_aArq,'^PW1181'+ CRLF)
				AADD(_aArq,'^LL0827'+ CRLF)
				AADD(_aArq,'^LS0'+ CRLF)
				AADD(_aArq,'^FO32,128^GFA,98560,98560,00140,:Z64:'+ CRLF)
				AADD(_aArq,'eJzs0rERgkAAAMGfISCkA22V0ijJCtRISC505gl2K7jgxgAAAAD4k89dvMYyO+H0HuvshMu+zS64HNs+e9if9XjOTjgtx2N2wklL09K0NC1NS9PStDQtTUvT0rQ0LU1L09K0NC1NS9PStDQtTUvT0rQ0LU1L09K0NC1NS9PStDQtTUvT0rQ0LU1L09K0NC1NS9PStDQtTUvT0rQ0LU1L09K0NC1NS9PStDQtTUvT0rQ0LU1L09K0NC1NS9PStDQtTUvT0rQ0LU1L09K0NC1NS9PStDQtTUvT0rQ0LU1L09K0NC1NS9PStDQtTUvT0rQ0LU1L09Lu2fIFAAD//+zOMREAAAyEMP+uayB7f4BDQP7P4rK4LC6Ly+KyuCwui8visrgsLovL4rK4LC6Ly+KyuCwui8visrgsLovL4rK4LC6Ly+KyuCwui8visrgsLovL4rK4LC6Ly+KyuCwui8visrgsLovL4rK4LC6Ly+KyuCwui8visrgsLovL4rK4LC6Ly+KyuCwui8visrgsLovL4rK4LC6Ly+KyuCwui8visrgsLovL4rK4LC6Ly+KyuCwui8visrgsLovL4rK4LC6Ly+KyuCwui8visrgsLovL4rK4LC6Ly+KyuCwui9u2HAAAAP//7NKhEcNAEARB8MBMTlmhKTLJ7E2Gn0B3bQADdm5ampampWlpWpqWpqVpaVqalqalaWlampampWlpWpqWpqVpaVqalqalaWlampampWlpWpqWpqVpaVqalqalaWlampampWlpWpqWpqVpaVqalqalaWlampampWlpWpqWpqVpaVqalqalaWlampampWlpWpqWpqVpaVqalqalaWlampampWlpWpqWpqVpaVqalqalaWlampampWlpWpqWpqVpaVqalqalaWlampampWlpWpqWpqVpaes6phO2dX2f13hTy/mZLvg713TBdk8fFgAARvwAAAD//xvpCAA8DYWl:1FB7'+CRLF)
				
				// AADD(_aArq,'^FO0,32^GFA,118400,118400,00148,:Z64:'+CRLF)
				// AADD(_aArq,'eJzs0rENwkAABEEQgUNKoBFEbZTmkqgAkB3xAdJmj9BMcPEGdzgAAAB8Or5+yWNvWmZnDJ5703l2xui+NV1mV4zWvWnOjb9Y1m1vkytGp3Xb6+SKkaZGU6Op0dRoajQ1mhpNjaZGU6Op0dRoajQ1mhpNjaZGU6Op0dRoajQ1mhpNjaZGU6Op0dRoajQ1mhpNjaZGU6Op0dRoajQ1mhpNjaZGU6Op0dRoajQ1mhpNjaZGU6Op0dRoajQ1mhpNjaZGU6Op0dRoajQ1mhpNjaZGU6Op0dRoajQ1mhpNjaZGU6Op0dRoajQ1mhpNjaZGU6Op0dRoajQ1mhpNjaZGU6Op0dRoajQ1mhpNzT82vQEAAP//7M4xDQAADMMw/qxHwc/UJ1EA+ONMViYrk5XJymRlsjJZmaxMViYrk5XJymRlsjJZmaxMViYrk5XJymRlsjJZmaxMViYrk5XJymRlsjJZmaxMViYrk5XJymRlsjJZmaxMViYrk5XJymRlsjJZmaxMViYrk5XJymRlsjJZmaxMViYrk5XJymRlsjJZmaxMViYrk5XJymRlsjJZmaxMViYrk5XJymRlsjJZmaxMViYrk5XJymRlsjJZmaxMViYrk5XJymRlsjJZmaxMViYrk5XJymRlsjJZmaxMViYrk5XJymRlspamAwAA///szkEJAAAMxDD/rqdg0O9BSgXkm6nF1GJqMbWYWkwtphZTi6nF1GJqMbWYWkwtphZTi6nF1GJqMbWYWkwtphZTi6nF1GJqMbWYWkwtphZTi6nF1GJqMbWYWkwtphZTi6nF1GJqMbWYWkwtphZTi6nF1GJqMbWYWkwtphZTi6nF1GJqMbWYWkwtphZTi6nF1GJqMbWYWkwtphZTi6nF1GJqMbWYWkwtphZTi6nF1GJqMbWYWkwtphZTi6nF1GJqMbWYWkwtphZTi6nF1GJqMbWYWkwtphZTi6nF1GJqMbWYWkytVdMBAAD//+3OMQ0AAAjAMP+uOTCwi4O0mYBd56nx1HhqPDWeGk+Np8ZT46nx1HhqPDWeGk+Np8ZT46nx1HhqPDWeGk+Np8ZT46nx1HhqPDWeGk+Np8ZT46nx1HhqPDWeGk+Np8ZT46nx1HhqPDWeGk+Np8ZT46nx1HhqPDWeGk+Np8ZT46nx1HhqPDWeGk+Np8ZT46nZJ/htABT3NmE=:052C'+CRLF)
			
				AADD(_aArq,'^FO0,32^GFA,118400,118400,00148,:Z64:'+CRLF)
				AADD(_aArq,'eJzs0rENwkAABEEQgUNKoBFEbZTmkqgAkJ19gLTZI5gJLt7gDgcAAPgXx9c3eexNy+yMwXNvOs/OGN23psvsitG6N8258QfLuu1tcsXotG57nVwx0tRoajQ1mhpNjaZGU6Op0dRoajQ1mhpNjaZGU6Op0dRoajQ1mhpNjaZGU6Op0dRoajQ1mhpNjaZGU6Op0dRoajQ1mhpNjaZGU6Op0dRoajQ1mhpNjaZGU6Op0dRoajQ1mhpNjaZGU6Op0dRoajQ1mhpNjaZGU6Op0dRoajQ1mhpNjaZGU6Op0dRoajQ1mhpNjaZGU6Op0dRoajQ1mhpNjaZGU6Op0dRoajQ1mhpNjaZGU6Op0dT8YtMbAAD//+zOMQ0AAAzDMP6sR8HP1CdRAPjjTFYmK5OVycpkZbIyWZmsTFYmK5OVycpkZbIyWZmsTFYmK5OVycpkZbIyWZmsTFYmK5OVycpkZbIyWZmsTFYmK5OVycpkZbIyWZmsTFYmK5OVycpkZbIyWZmsTFYmK5OVycpkZbIyWZmsTFYmK5OVycpkZbIyWZmsTFYmK5OVycpkZbIyWZmsTFYmK5OVycpkZbIyWZmsTFYmK5OVycpkZbIyWZmsTFYmK5OVycpkZbIyWZmsTFYmK5OVycpkZbIyWZmsTFYmK5OVycpkZbKWpgMAAP//7M5BCQAADMQw/66nYNDvQUoF5JupxdRiajG1mFpMLaYWU4upxdRiajG1mFpMLaYWU4upxdRiajG1mFpMLaYWU4upxdRiajG1mFpMLaYWU4upxdRiajG1mFpMLaYWU4upxdRiajG1mFpMLaYWU4upxdRiajG1mFpMLaYWU4upxdRiajG1mFpMLaYWU4upxdRiajG1mFpMLaYWU4upxdRiajG1mFpMLaYWU4upxdRiajG1mFpMLaYWU4upxdRiajG1mFpMLaYWU4upxdRiajG1mFpMLaYWU4upxdRiajG1mFpMrVXTAQAA///t0rENAjEABMGQkAaQaJXK4fU4craR7WBGV8AGt3qaGk2NpkZTo6nR1GhqNDWaGk2NpkZTo6nR1GhqNDWaGk2NpkZTo6nR1GhqNDWaGk2NpkZTo6nR1GhqNDWaGk2NpkZTo6nR1GhqNDWaGk2NpkZTo6nR1GhqNDWaGk2NpkZTo6nR1GhqNDWaGk2NpmY0vTZXzEbT+3eUE5s+d9Nzd8Xs3/TYXTH57rkxACx3AQfVZUM=:77A0'+CRLF)


				AADD(_aArq,'^FO32,64^GFA,03840,03840,00040,:Z64:'+CRLF)
				AADD(_aArq,'eJztlUGO4jAQRcuRkZBXttTs0Sx9Ci9ygOZGFivEKSxWlk85/5dj1J0BTUbTyxQJ/ilB5fFdFUT22ONfIqW05WNTa22VivnF50wIp1UqvCyIeqvvv6wn8zyn7xn7jq9s4vuD5w2fuLqJT+w2PtSbgBgbdImPdsapstRYI/MxFjEfcvACC0+erAZ0wUCeIL3xXgIOs/C5hpItY3H49RE7pLJCZRyRxOSzsHCGmJNNOG2XPGbN287HCkuhZckqWe+qCfDh9glExisYtltCWOTnxXBNgY62WyuguBeXsbh6r5HXwnqodq2uaAckvEBBE3XhSxLlPBJsAN1fWNSq/KJT9IwuQqKm4D4TEtp/Xj66Z178YYDSPMO8MCG9//Dte7tN9UjMGrN7VPBVqbIkRPuPHuJ88sHRTkzrAGul85HmqlZ1HNSDdGXS+7QW2X/wT3iGYMJlwTFD0svLwof9wPewuY/v9e5F+RpsVD6hW0CYOcgdxy7y6avur7pVuJzPUe0asp1bLFDkY/99ciYOwJGDDP8gyY13OY35gO8ZmJgT1/3LKgUWgLIPzDzcei5d0jl4Sz475gM/FYUebaJpFXRXlaL9hxt0/0AUuK3ahnrV+0/onvbf4OuNnPsmLFNRRz308+D7Oh/ynI+kzpJ68EWdN8xBjb2eqBT0Ymae9/Vqk3BOjYJ47cUwnjXIe6obD9oHy1o+ZrkdKSslM7g4vnqQrJ8+W4ITsiUuHe3v9e7b6tn1o/tNcKq3hFn/tbwJt/5r+d+YfrbcHnvssccePx2/AWFsErU=:9126'+CRLF)
				AADD(_aArq,'^FT434,150^A0N,28,24^FH\^FDPESO: '+cValToChar(nPesoVol)+' KG^FS'+ CRLF)
				AADD(_aArq,'^FT435,113^A0N,26,24^FH\^FDVOLUME: '+Alltrim(cVolumeAtu)+'^FS'+ CRLF)
				AADD(_aArq,'^FT434,82^A0N,26,24^FH\^FDPEDIDO:'+Subs(XD1->XD1_PVSEP,1,6)+'^FS'+ CRLF)
				
				AADD(_aArq,'^BY3,2,41^FT769,127^BUN,,Y,N'+CRLF)
				//AADD(_aArq,'^BY2,3,58^FT721,125^BCN,,Y,N'+CRLF)
				AADD(_aArq,'^FD>:'+U_fTratTxt(XD1->XD1_XXPECA)+'^FS'+ CRLF)
				
				AADD(_aArq,'^FO39,213^GB1106,0,2^FS'+ CRLF)
				AADD(_aArq,'^FT461,208^A0N,21,24^FB83,1,0,C^FH\^FDCLIENTE^FS'+ CRLF)
				AADD(_aArq,'^FT480,184^A0N,20,24^FB49,1,0,C^FH\^FDC\E3D.^FS'+ CRLF)
				AADD(_aArq,'^FT50,196^A0N,25,24^FH\^FDITEM    PRODUTO                       QTDE                    DESCRI\80\C7O DO MATERIAL                                 ^FS'+ CRLF)
				AADD(_aArq,'^FO547,162^GB0,644,3^FS'+ CRLF)
				AADD(_aArq,'^FO452,162^GB0,644,2^FS'+ CRLF)
				AADD(_aArq,'^FO372,161^GB0,644,3^FS'+ CRLF)
				AADD(_aArq,'^FO109,162^GB0,643,4^FS'+ CRLF)
				lCabec:= .F.
		Endif

			cItemProd:= StrZero(val(aItemXD2[Y,2]),3) //StrZero(Y,3)
			cCodProd:= aItemXD2[Y,3]
			_QtdProd := TransForm(aItemXD2[Y,4],"@E 99,999")


			AADD(_aArq,'^FT45,'+cValtochar(259+nLin)+'^A0N,30,28^FH\^FD'+cItemProd+'^FS'+ CRLF)
			AADD(_aArq,'^FT122,'+cValtochar(259+nLin)+'^A0N,30,28^FH\^FD'+cCodProd+'^FS'+ CRLF)
			AADD(_aArq,'^FT386,'+cValtochar(259+nLin)+'^A0N,30,28^FB56,1,0,C^FH\^FD'+_QtdProd+'^FS'+ CRLF)
			//AADD(_aArq,'^FT460,'+cValtochar(259+nLin)+'^A0N,30,28^FB84,1,0,C^FH\^FD'+Alltrim(substring(_CodCli,1,8))+'^FS'+ CRLF)
			AADD(_aArq,'^FT460,'+cValtochar(259+nLin)+'^A0N,30,21^FB80,1,0,C^FH\^FD'+Alltrim(substring(_CodCli,1,8))+'^FS'+ CRLF)
			AADD(_aArq,'^FT559,'+cValtochar(259+nLin)+'^A0N,30,28^FH\^FD'+Alltrim(Substring(cDescr,1,40))+'^FS'+ CRLF)
			x+= 1
			nLin+= 37

		if x == 15 .or. y == Len(aItemXD2)
				lCabec:= .T.
				nLin:= 0
				x:= 0
				AADD(_aArq,'^PQ1,0,1,Y^XZ'+ CRLF)
				AaDd(aCodEtq,_aArq)


			For nY:=1 To Len(aCodEtq)
				For nP:=1 To Len(aCodEtq[nY])
						MSCBWrite(aCodEtq[nY][nP])
				Next nP
			Next nY

				_aArq:= {}
				aCodEtq:= {}

				MSCBEND()

		EndIf


	Next y
		MSCBCLOSEPRINTER()
		//Finaliza impressão da etiqueta

	If Type("cDomEtDl31_CancEtq") <> "U"
			cDomEtDl31_CancEtq := XD1->XD1_XXPECA
	EndIf


EndIf

Return(.T.)

