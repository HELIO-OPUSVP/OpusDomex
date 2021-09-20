

#include "protheus.ch"
#include "rwmake.ch"


User Function DOMET117(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,lColetor,cNumSerie,cNumPeca)
//--------------------------------------------------------------
/*/{Protheus.doc} DOMET117 
Description ETIQUETA TELECOM ARGENTINA - EM ESPANHOL
@param xParam Parameter Description
@return xRet Return Description
@author  -
@since 07/09/2021
/*/
//-------------------------------------------------------------

	Local aPar       := {}
	Local aRet       := {}
	Local nVar       := 0

	Local cRotacao   := "N"      //(N,R,I,B)

	Local mv_par02   := 1         //Qtd Embalagem
	Local MVPAR03   := 1         //Qtd Etiquetas

	Local aRetAnat   := {}        //Codigos Anatel, Array
	Local aCodAnat   := {}        //Codigos Anatel, Array
	Local cCdAnat1   := ""        //Codigo Anatel 1
	Local cCdAnat2   := ""        //Codigo Anatel 2
	Local _aArq		:= {}
	Local aCodEtq 	:= {}

	Private lAchou   := .T.
	Private aGrpAnat := {}     //Codigos Anatel Agrupados
	Default cNumOP    := ""
	Default cNumSenf  := ""
	Default nQtdEmb   := 0
	Default nQtdEtq   := 0
	Default cNumSerie := "1"
	Default cNivel    := ""
	Default cNumSerie := ""
	Default cNumPeca  := ""

	MVPAR02:= nQtdEmb   //Qtd Embalagem
	MVPAR03:= nQtdEtq   //Qtd Etiquetas

	cProdFilho := ""
	cProOp:= ""

	if !U_VALIDACAO()
		Alert("Layout em desenvolvimento")
		Return .F.
	Endif

	If !Empty(cNumOP)

		//Localiza SC2
		SC2->(DbSetOrder(1))
		If lAchou .And. SC2->(!DbSeek(xFilial("SC2")+cNumOP))
			Alert("Numero O.P. "+AllTrim(cNumOP)+" não localizada!")
			lAchou := .F.
		EndIf

		cSC2Recno := SC2->(Recno())
		__cPedido := ""
		__cItem   := ""
		If ALLTRIM(SC2->C2_SEQUEN) == "001"
			__cPedido  := SC2->C2_PEDIDO
			__cItem    := SC2->C2_ITEMPV
			cProdFilho := SC2->C2_PRODUTO
			cProdOp 	:= SC2->C2_PRODUTO

		Else
			SC2->(dbSeek(xFilial("SC2")+SUBSTR(cNumOP,1,8)+'001'))
			__cPedido := SC2->C2_PEDIDO
			__cItem   := SC2->C2_ITEMPV
			// Alterado Por Michel A. Sander em 15/05/2014
			// Busca Descrição da OP Filha para impressão na etiqueta
			SC2->(dbSeek(xFilial("SC2")+SUBSTR(cNumOP,1,11)))
			cProdFilho := SC2->C2_PRODUTO
			cProdOp := SC2->C2_PRODUTO

			SC2->(dbGoto(cSC2Recno))
		EndIf

		//Localiza SC5
		If !Empty(SC2->C2_PEDIDO)
			SC5->(DbSetOrder(1))
			If lAchou .And. SC5->(!DbSeek(xFilial("SC5")+__cPedido))
				Alert("Numero de Senf "+AllTrim(__cPedido)+" não localizado!")
				lAchou := .F.
			EndIf

			//Localiza SC6
			SC6->(DbSetOrder(1))
			If lAchou .And. SC6->(!DbSeek(xFilial("SC6")+__cPedido+__cItem))
				Alert("Item Senf "+AllTrim(__cItem)+" não localizado!")
				lAchou := .F.
			EndIf
		EndIf

		//Localiza SA1
		SA1->(DbSetOrder(1))
		If lAchou .And. SA1->(!DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
			Alert("Cliente "+SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI+" não localizado!")
			lAchou := .F.
		EndIf

		//Localiza SB1
		SB1->(DbSetOrder(1))
		If lAchou .And. !SB1->(DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
			Alert("Produto "+AllTrim(SC2->C2_PRODUTO)+" não localizado!")
			lAchou := .F.
		EndIf

	ElseIf !Empty(cNumSenf)

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
		EndIf

		cProdFilho := SC6->C6_PRODUTO
		//Localiza SB1
		SB1->(DbSetOrder(1))
		If lAchou .And. !SB1->(DbSeek(xFilial("SB1")+cProdFilho))
			Alert("Produto "+AllTrim(SC2->C2_PRODUTO)+" não localizado!")
			lAchou := .F.
		EndIf

		//Localiza SA1
		SA1->(DbSetOrder(1))
		If lAchou .And. SA1->(!DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
			Alert("Cliente "+SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI+" não localizado!")
			lAchou := .F.
		EndIf


	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta o número de série										   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	cSerieFim := If( cNumSerie=="1" .Or. Empty(cNumSerie), 1, Val(cNumSerie) )

	Do Case
	Case SC2->C2_QUANT <=9
		cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,1)	// MV_PAR07 Sequencial Serial
	Case  SC2->C2_QUANT >=10 .And.  SC2->C2_QUANT <= 99
		cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,2)	// MV_PAR07 Sequencial Serial
	Case  SC2->C2_QUANT >=100 .And. SC2->C2_QUANT <= 999
		cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,3)	// MV_PAR07 Sequencial Serial
	Case  SC2->C2_QUANT >=1000 .And. SC2->C2_QUANT <= 9999
		cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,4)	// MV_PAR07 Sequencial Serial
	Case  SC2->C2_QUANT >=10000 .And. SC2->C2_QUANT <= 99999
		cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,5)	// MV_PAR07 Sequencial Serial
	EndCase

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
	//³Montagem do código de barras 2D					³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
	cSQL    := "SELECT dbo.SemanaProtheus() AS SEMANA"
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"WEEK",.F.,.T.)
	cSemana := WEEK->SEMANA
	cYY     := SUBSTR(cSemana,3,2)
	cWW     := StrZero(Val(SubStr(cSemana,5,2)),2)

	WEEK->(dbCloseArea())


	If lAchou
		aRetAnat := U_fCodNat(SB1->B1_COD)
		lAchou   := aRetAnat[1]
		aCodAnat := aRetAnat[2]

		If lAchou .And. Empty(SB1->B1_XXNANAT)
			Alert("Não foi preenchido o campo 'Nº Codigo Anatel' para o produto: "+AllTrim(SB1->B1_COD) + Chr(13)+Chr(10)+ "[B1_XXNANAT]")
			lAchou := .F.
		EndIf

	EndIf

	If lAchou
		//Agrupando Codigos Anatel
		For x:=1 To Len(aCodAnat)
			nVar := aScan(aGrpAnat,aCodAnat[x])
			If nVar == 0
				aAdd(aGrpAnat,aCodAnat[x])
			EndIf
		Next x

		Do Case
		Case Val(SB1->B1_XXNANAT) == 0 .And. Len(aGrpAnat) == 0
			cCdAnat1 := ""
			cCdAnat2 := ""

		Case Val(SB1->B1_XXNANAT) == 1 .And. Len(aGrpAnat) == 1
			cCdAnat1 := aGrpAnat[1]
			cCdAnat2 := ""

		Case Val(SB1->B1_XXNANAT) == 2 .And. Len(aGrpAnat) == 1
			cCdAnat1 := aGrpAnat[1]
			cCdAnat2 := aGrpAnat[1]

		Case Val(SB1->B1_XXNANAT) == 3 .And. Len(aGrpAnat) == 2
			cCdAnat1 := aGrpAnat[1]
			cCdAnat2 := aGrpAnat[2]

		OtherWise
			cCdAnat1 := " E R R O "
			cCdAnat2 := " E R R O "
			If !Empty(cNumOP)
				Alert("Erro no tratamento dos codigos ANATEL (DOMETQ06)."+Chr(13)+Chr(10)+"Favor procurar TI e informar dificuldade! "+Chr(13)+Chr(10)+"OP:"+cNumOP)
			ElseIf !Empty(cNumSenf)
				Alert("Erro no tratamento dos codigos ANATEL (DOMETQ06)."+Chr(13)+Chr(10)+"Favor procurar TI e informar dificuldade! "+Chr(13)+Chr(10)+"Senf:"+cNumSenf)
			EndIf
			lAchou   := .F.

		EndCase

	EndIf

	//Valida se Campo Descricao do Produto está preenchido
	If lAchou .And. Empty(SB1->B1_DESC)
		Alert("Campo Descricao do Produto não está preenchido no cadastro do produto! "+Chr(13)+Chr(10)+"[B1_DESC]")
		lAchou := .F.
	EndIf

	//Valida se Campo PN HUAWEI está preenchido
	If !Empty(SC2->C2_PEDIDO)
		If lAchou .And. Empty(SC6->C6_SEUCOD)
			Alert("Campo PN não está preenchido no Item do Pedido de Vendas! "+Chr(13)+Chr(10)+"[C6_SEUCOD]")
			lAchou := .F.
		EndIf
	EndIf

	//Valida se Campo PEDIDO CLIENTE está preenchido
	If !Empty(SC2->C2_PEDIDO)
		If lAchou .And. Empty(SC5->C5_ESP1)
			Alert("Campo PEDIDO CLIENTE não está preenchido no Cabeçalho do Pedido de Vendas! "+Chr(13)+Chr(10)+"[C5_ESP1]")
			lAchou := .F.
		EndIf
	EndIf

	//Caso algum registro não seja localizado, sair da rotina
	If !lAchou
		Return(.f.)
	EndIf


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
	//³Busca último número de série							³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
	If cNivel == "1"
		cSQL := "SELECT MAX(XD1_SERIAL) XD1_SERIAL FROM XD1010 (NOLOCK) WHERE "
		cSQL += "D_E_L_E_T_='' AND XD1_OCORRE <> '5' AND XD1_OP='"+AllTrim(cNumOp)+"' AND XD1_NIVEMB='1'"
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"TMP",.F.,.T.)
		If !TMP->(Eof())
			If !Empty(TMP->XD1_SERIAL)
				cNumSerie := Soma1(TMP->XD1_SERIAL)
			EndIf
		EndIf
		TMP->(dbCloseArea())
	Else
		cNumSerie := ""

	EndIf

	If lImpressao

		//Controla o numero da etiqueta de embalagens
		If Empty(cNumPeca)
			_cProxPeca := U_IXD1PECA()
		Else
			_cProxPeca := cNumPeca
		EndIf

		For _nX := 1 to Len(aFilhas)
			Reclock("XD2",.T.)
			XD2->XD2_FILIAL := xFilial("XD2")
			XD2->XD2_XXPECA := _cProxPeca
			If ValType(aFilhas[_nX])  == "A"
				XD2->XD2_PCFILH := aFilhas[_nX][1]
			Else
				XD2->XD2_PCFILH := aFilhas[_nX]
			EndIf
			XD2->( msUnlock() )
		Next _nX

		For __nEtq := 1 To MVPAR03


			If __nEtq > 1
				_cProxPeca := U_IXD1PECA()
			EndIf

			aRetEmbala       := U_RetEmbala(SB1->B1_COD,cNivel)

			Reclock("XD1",.T.)
			XD1->XD1_FILIAL  := xFilial("XD1")
			XD1->XD1_XXPECA  := _cProxPeca
			XD1->XD1_FORNEC  := Space(06)
			XD1->XD1_LOJA    := Space(02)
			XD1->XD1_DOC     := Space(06)
			XD1->XD1_SERIE   := Space(03)
			XD1->XD1_ITEM    := ""
			XD1->XD1_COD     := SB1->B1_COD
			XD1->XD1_LOCAL   := SB1->B1_LOCPAD
			XD1->XD1_TIPO    := SB1->B1_TIPO
			XD1->XD1_LOTECT  := U_RetLotC6(cNumOP)
			XD1->XD1_DTDIGI  := dDataBase
			XD1->XD1_FORMUL  := ""
			XD1->XD1_LOCALI  := ""
			XD1->XD1_USERID  := __cUserId
			XD1->XD1_OCORRE  := "6"
			XD1->XD1_OP      := cNumOP
			XD1->XD1_PV      := cNumSenf
			XD1->XD1_PESOB   := nPesoVol
			XD1->XD1_QTDORI  := nQtdEmb
			XD1->XD1_QTDATU  := nQtdEmb
			XD1->XD1_EMBALA  := aRetEmbala[1]
			XD1->XD1_QTDEMB  := aRetEmbala[2]
			XD1->XD1_NIVEMB  := If(AllTrim(cNivel)=="3",cNivel,aRetEmbala[3]) // 3 = Nivel 3 (Volumes parar expedição não constam na estrutura)
			If !Empty(SC2->C2_PEDIDO)
				XD1->XD1_PVSEP   := If(AllTrim(cNivel)=="3",SC5->C5_NUM,"")
			EndIf
			XD1->XD1_SERIAL  := cNumSerie
			XD1->( MsUnlock() )

			// Armazenando informacoes para um possivel cancelamento da etiqueta por falha na impressao
			If Type("cDomEtDl31_CancEtq") <> "U"
				cDomEtDl31_CancEtq := XD1->XD1_XXPECA
				cDomEtDl32_CancOP  := cNumOP
				cDomEtDl33_CancEmb := cNumSenf
				cDomEtDl34_CancKit := nQtdEmb
				cDomEtDl35_CancUni := nQtdEtq
				cDomEtDl38_CancNiv := cNivel
				aDomEtDl3A_CancFil := aFilhas
				cDomEtDl39_CancPes := nPesoVol
			EndIf

			cFila := "000000"
			IF !CB5SetImp(cFila,.F.)
				U_MsgColetor("Local de impressao invalido!")
				Return .F.
			EndIf

			SB1->(dbSeek(xFilial("SB1")+cProdOP))


			AADD(_aArq,'CT~~CD,~CC^~CT~'+ CRLF)
			AADD(_aArq,'^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR6,6^JUS^LRN^CI0^XZ'+ CRLF)
			AADD(_aArq,'^XA'+ CRLF)
			AADD(_aArq,'^MMT'+ CRLF)
			AADD(_aArq,'^PW945'+ CRLF)
			AADD(_aArq,'^LL0709'+ CRLF)
			AADD(_aArq,'^LS0'+ CRLF)
			AADD(_aArq,'^FO768,640^GFA,01280,01280,00020,:Z64:'+ CRLF)
			AADD(_aArq,'eJzt0TFuwkAQheFZAt5IQcF0g7RRlBuYziW5ybpKa3cUEUzEJXKc2SOkT2H6FCndwe4sFhbZE0Cmsj49/ZJtgP+75tMJywbPU0B9oIEphndYXxjBj+rgbtjzu2+FYsOd78FIbOK4NorfOrFMbNay3X7QycbSy2tuvhxVBMabib3cVrQPFnb30dC+UsUVi512nXXw0u9QerprHDR9r5DdFIsdLPtdNMT5Dpq+Z8VyXKhzz0qv8EZ+F3sr2ZXlg6KW27hjMbOegeN97Klg+vD8+Qhb2lh5X/91gmnM4AmMrUNPnf/D30sZJqxM2G/COGG3fkeZk0f8:BCE4'+ CRLF)
			AADD(_aArq,'^FO0,640^GFA,03328,03328,00052,:Z64:'+ CRLF)
			AADD(_aArq,'eJzt1D9vEzEYBvDXsoqX4mPM4Ob4CJUYuOFI+QCsXSF8AyMklCEQRwwdkMrKwIdxxJABqYIBiaGDESMSum4Zqprntc+XMhYkBhSr6p/r/fTksd87ot36X5Z69Admc3OzN7u5+dvVjElTS8ILL12MYUKGxrjekXL8pck2VMVVoIBrvalprGLHpr6I8Xv8ZKgm3EWLS1KeFt62bDoK4prR6uOGzVEH86PL5q2fX1HlKfqcA0Nl61o2NGdj71CQ3hq6T6RFsDXdxtWHyNEkOOfrkONgxmwCwbjG0D0YClbRPjpyH5gNzLtiDvxYUQ2z8iSQ0xp6js8mLMyBV8lUJM5FEO+3BjkqG84ZwaTtstKZoKjPOcf/imlNYLMsxhtDz3wyypkpm9Tn7JppkpGDcTBPS85oOuSw0UOOHfem4z5sLjwacJ/GDn3WIqjxkDNDjlgO+4Y+33zaNwkz7NuagtrmzNms+HxSH+w1PqXGnwpZwvd91i4oNeS0xcxTDs4UiRq/aDpscJY554Pj3sWYcW9q7rPqDDfDvNkD3C5e9jO6WoVqa3TJwXQFGb0RLlB1RYsNTUd05JJZ+hD2Ua7vUxWz1/UGzaonftHR1GC081zDGOVKjir7Rmxee4Mq6ONnGDFD0uc+3gYjt6b0oRn6LDsjI/qIzhoRLzHQnJNMHX0x8jSfqaeG943NJp2PpniFrexzmq1pjTgrxuTnRx3P0uxo8eUxRiefjzfhwfGQk4zzwiXjDg1mJplbwms2TW8a8ZtR/OSQ4e8zGJPnTXiVTZWM3Rr6qXARCTTKz6mG0TS1SjqYaZ+jg8Uroe9DLxQudvh3m+ctm9Cb0PdR08Eg55XC3ZjIvG9sdJ5r6eR231SYIrPkTJSY07wWn21+fvilWPFco+eJ8H0fic9mbcmZqDcdTVoRA/VG4/3mrDwheRKdPYpV/AYTyG5KDt6jnupLEX1+H2DI0lzDiDV+ZiPYDDmaX5CC3wGcs28aGIkb5CkffzEUMCh3abd2a7d261+vX2Mriew=:66FE'+ CRLF)
			AADD(_aArq,'^FO32,32^GFA,05376,05376,00056,:Z64:'+ CRLF)
			AADD(_aArq,'eJztVrGO4kgQrQYhnywhzQQjR/4B/wDRSL5oUwKgIyT2DwjQOPWsdMn+w0nWRlZ/BRdMzgYrEdC79wmXXHjSvVc2xp71wizBRhTQlLvb/fz6VZVb5GY3u9nNbvarLciyrK/f9PaeLHTOFX0DLj9739h7f+jD8+fvI567Ao/8+qi8hV/v0m/g57c9eG/hV/w8XmBhaQ+ePXsb8PC9Am/sQWXXg3eRH5a+Ai+ATtlaog0lS3G9YW+Wmux3KoghkdFK1dRxCTp4iaNbsskBhR73gYjoCsuwGOBKBpxXJPmRnyx3hhouPX2Pixe/N/5P0B6ha3xYbmP/cpAYgRx/rnlXeANqqIHjgOA+Hhuom4clQNwnh2fCr6h5B9DJTqHi1FBIODM6CzYziaxdBXObskfQyMTaNr9QYbD4gNnh6qYkRBGWrjj25Mkn1/Az/u8YSWj8vx5E/vOGIWs0L0F5jwj+y+s4NuHxS4cf1nUDbmPosKHuBFokJZ5F8XQ8OSZPkM1tlmabKIOS2TramMwwJQ18NGm0QYa+z1bZk45Pjsla5V9SqkLYuJLqlWGFLdxNzACpEHgcdw0/mCr4B9SDI2CzG/lnv2Ujo69jenl8iKHeLvbSwpMmPpJCo4Vc8jpIQnrACxk6ybEWMf+mYlfGvrOIRbsS+96mQ2vYBAsJFlCY30U0lWg6mbXwyIl4peIxJBRPjnho+K94ZX3fuBJrayjSPxQMznYIajnjFDY+IEzxjSni477NL6+SoFatjQdr8PhkDV5QiZUi5eDwB7XSIbqQb+94GTwxSYOnCP5msm7wEIS6OLUpzuAlHbwxHx2MhLHpdyT0uZffQfnFJ35SL85cOIf3ip9FqYRi0AvZNmUpNZV++Id+mLFo9BOZTE94QgSpqgn0E2nrVz+RaLxA3xY/Sgf9tojO/XLL0omrZzYassqP8Ulqj7suXqF4SQdv0MLLX+Np/VxlqyHzKlqzXppKvzRgSmpFRTJmTyyx0taP0lUVkqWriU90DejpjGpfO/HJpFtCHYgU7+N9zfbZI9fAdPwV/LTY1OMtPKZxwsVRTDTfFQ9drHTlEY/jRVs/1E/UycXQztWxtX5aMud2RhF5EdjMph39Eq2fLJ10Gryqfioe67WOv+KH98Be6+PomI3PcPZMxx344dXw4qv6uevgDbr1usEL9RE460Ndrzv6rVEyV8KDDJx1rV+ELmRnyjei2SALs+ypqx+LJsIldMqkqPE+ogvwOkOqEC1P8TK6F3m4ExRHRCEe/gHx+iDmHp9vGF4iOO903kHPAfd30jVEp/wm31te/wOvd/ysmbkEs8vTvje+J664DYrGfYfUy3inQPkpg7Try7N68H5wCL9ky94z6mUL+8/EFy2wF46jP7CBu2o7oeB1t93sZr/e/gcZY+J3:2C5E'+ CRLF)
			
			AADD(_aArq,'^FT71,222^A0N,37,36^FH\^FDIDENTIFICACI\E3N ID:^FS'+ CRLF)
			AADD(_aArq,'^FT406,262^A0N,42,38^FH\^FD'+alltrim(SC6->C6_SEUCOD)+'^FS'+ CRLF)
			AADD(_aArq,'^BY2,3,48^FT406,217^BCN,,N,N'+ CRLF)
			AADD(_aArq,'^FD>:'+alltrim(SC6->C6_SEUCOD)+'^FS'+ CRLF)

			AADD(_aArq,'^FT71,413^A0N,37,36^FH\^FDN\E9MERO OE/NPA: '+SC2->C2_PEDIDO+'^FS'+ CRLF)
			AADD(_aArq,'^FT71,327^A0N,37,36^FH\^FDMARCA Y MODELO: ROSENBERGER Y '+Alltrim(SB1->B1_COD)+'^FS'+ CRLF)

			AADD(_aArq,'^FT71,531^A0N,37,36^FH\^FDCANTIDAD:^FS'+ CRLF)
			AADD(_aArq,'^FT406,561^A0N,42,38^FH\^FD'+cValtochar(MVPAR02)+'^FS'+ CRLF)
			AADD(_aArq,'^BY2,3,48^FT406,516^BCN,,N,N'+ CRLF)
			AADD(_aArq,'^FD>:'+cValtochar(MVPAR02)+'^FS'+ CRLF)

			AADD(_aArq,'^PQ1,0,1,Y^XZ'+ CRLF)


			// AADD(_aArq,'^FT337,228^A0N,46,48^FH\^FD'+StrZero(MVPAR02,4)+' Unidade(s)^FS'+ CRLF)
			// AADD(_aArq,'^FD'+U_fTratTxt(XD1->XD1_XXPECA)+'^FS'+ CRLF)
			// AADD(_aArq,'^FT40,267^A0N,29,28^FH\^FD'+U_fTratTxt(SB1->B1_DESC)+'^FS'+ CRLF)
			// AADD(_aArq,'^FT40,304^A0N,29,28^FH\^FDPN RDT: '+SB1->B1_COD+'^FS'+ CRLF)
			// AADD(_aArq,'^FT40,341^A0N,29,28^FH\^FD'+U_fTratTxt(SA1->A1_NREDUZ)+" - "+U_fTratTxt(SC6->C6_SEUCOD)+'^FS'+ CRLF)
			// AADD(_aArq,'^FT40,379^A0N,29,28^FH\^FDPED.CLIENTE: '+U_fTratTxt(SC5->C5_ESP1)+'^FS'+ CRLF)
			// AADD(_aArq,'^FT40,416^A0N,29,28^FH\^FDITEM DO PEDIDO: '+U_fTratTxt(SC6->C6_SEUDES)+'^FS'+ CRLF)
			// AADD(_aArq,'^FT715,446^A0N,29,28^FH\^FDSEMANA: '+cWW+'/'+cYY+'^FS'+ CRLF)

			AaDd(aCodEtq,_aArq)

			For nY:=1 To Len(aCodEtq)
				For nP:=1 To Len(aCodEtq[nY])
					MSCBWrite(aCodEtq[nY][nP])
				Next nP
			Next nY

			//Finaliza impressão da etiqueta
			MSCBEND()

			_aArq:= {}
			aCodEtq:= {}
			cNumSerie := Soma1(cNumSerie)

		Next __nEtq

		MSCBCLOSEPRINTER()

	EndIf

Return(.T.)
