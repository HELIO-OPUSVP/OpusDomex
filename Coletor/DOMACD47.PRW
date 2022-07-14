#include "TbiConn.ch"
#include "TbiCode.ch"
#include "Rwmake.ch"
#include "Topconn.ch"
#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDOMACD47  บAutor  ณRicardo Roda        บ Data ณ  04.06.19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Etiqueta Global S/A para faturamento              	      บฑฑ
ฑฑบ          ณ 														      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DOMACD47()

	Private oTxtOP,__oGetOP,__oTxtEtiq,oGetEtiq,oTxtProd,oGetProd,oTxtQtd,oGetQtd,oMark,oTxtQtdEmp,oMainEti,oEtiqueta
	Private oTxtProdCod,oTxtProdEmp,oNumOp
	Private _nTamEtiq      := 21
	Private _cNumEtqPA     := Space(_nTamEtiq)
	Private _cProduto      := CriaVar("B1_COD",.F.)
	Private _nQtd          := CriaVar("XD1_QTDATU",.F.)
	Private _cLoteEti      := CriaVar("BF_LOTECTL",.F.)
	Private _aCols         := {}
	Private _cCodInv
	Private cGetEnd        := Space(2+15+1)
	Private _cCliEmp	     := Space(06)
	Private _cNomCli       := Space(15)
	Private _cDescric	     := Space(27)
	Private _cDescEmb      := Space(27)
	Private _cEmbalag	     := Space(15)
	Private _cNumOp        := SPACE(11)
	Private _cNumPed       := SPACE(06)
	Private _nQtdEtiqs       := 0
	Private _nQtd          := 0
	Private _aDados        := {}
	Private _aEnd          := {}
	Private aProds		   := {}
	Private _nCont
	Private _cDtaFat       := dDataBase
	Private nQtdCaixa      := 0
	Private cLocProcDom    := GetMV("MV_XXLOCPR")
	Private __oTelaOP
	Private oTxtQtdEmp
	Private aGlobal     := {}
	Private lGlobal     := .F.


	dDataBase := Date()

	Define MsDialog __oTelaOP Title OemToAnsi("Etiqueta Global " + DtoC(dDataBase) ) From 0,0 To 293,233 Pixel of oMainWnd PIXEL

	nLin := 005
	@ nLin,001 Say __oTxtEtiq    Var "Num.Etiqueta" Pixel Of __oTelaOP
	@ nLin-2,045 MsGet __oGetOP  Var _cNumEtqPA Valid VldEtiq() Size 70,10 Pixel Of __oTelaOP
	__oTxtEtiq:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
	__oGetOP:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

	@ 018,001 To 132,115 Pixel Of oMainWnd PIXEL

	nLin += 015
	@ nLin,005 Say oTxtProdEmp  Var "Cliente: "        Pixel Of __oTelaOP
	@ nLin,035 Say oTxtProdCod  Var _cCliEmp           Pixel Of __oTelaOP
	oTxtProdCod:oFont  := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
	nLin += 10
	@ nLin,005 Say oTxtDes      Var "Descri็ใo: "      Pixel Of __oTelaOP
	@ nLin,035 say oTxtDescPro  Var _cDescric      Size 075,15 Pixel Of __oTelaOP
	oTxtDescPro:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
	nLin+= 30
	@ nLin,005 Say oTxtPed Var "Pedido: " Pixel Of __oTelaOP
	@ nLin,023 Say oNumPed Var _cNumPed+'-'+_cNomCli Size 120,10 Pixel Of __oTelaOP
	oNumPed:oFont:= TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
	nLin+= 75

	@ nLin,077 Button oEtiqueta PROMPT "Imprimir" Size 35,10 Action (fPrint(),__oTelaOP:end()) Pixel Of __oTelaOP

	Activate MsDialog __oTelaOP

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ            '
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VldEtq   บAutor  ณHelio Ferreira      บ Data ณ  15/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida็ใo da etiqueta para faturamento						     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldEtiq()

	Local _lRet := .T.
	

	_cCliEmp    := ""
	_cDescric   := ""
	_cEmbalag   := ""
	_aDados     := {}

	If Empty(_cNumEtqPA)
		Return ( .T. )
	EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPrepara n๚mero da etiqueta bipada							ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Len(AllTrim(_cNumEtqPA))==12 //EAN 13 s/ dํgito verificador.
		_cNumEtqPA := "0"+_cNumEtqPA
		_cNumEtqPA := Subs(_cNumEtqPA,1,12)
	EndIf

	SC2->( dbSetOrder(1) )
	SB1->( dbSetOrder(1) )
	SBF->( dbSetOrder(2) )
	XD1->( dbSetOrder(1) )

	If XD1->( dbSeek(xFilial("XD1") + _cNumEtqPA ) )

		cItemPV := Alltrim(Subs(XD1->XD1_PVSENF,7,2))
		SB1->(dbSeek(xFilial("SB1")+XD1->XD1_COD))

		iF EMPTY(XD1->XD1_PVSENF)
			U_MsgColetor("Pedido nใo informado na Etiqueta (XD1_PVSENF) ")
			_cNumEtqPA := Space(_nTamEtiq)
			__oGetOP:Refresh()
			__oGetOP:SetFocus()
			Return .F.
		Endif

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAtualiza dados para o coletor									ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		SC5->(dbSeek(xFilial("SC5")+Substring(XD1->XD1_PVSENF,1,6)))
		SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE))

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVerifica se o Cliente ้ GLOBO GROUP S/A								ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		lGlobal := .F.
		If ("GLOBO GROUP S.A." $ Upper(Alltrim(SA1->A1_NOME))) .Or. ("GLOBO GROUP S.A." $ Upper(Alltrim(SA1->A1_NREDUZ))) .or.;
				("TELECOM ARGENTINA S.A." $ Upper(Alltrim(SA1->A1_NOME))) .Or. ("TELECOM ARGENTINA S.A." $ Upper(Alltrim(SA1->A1_NREDUZ)))
			lGlobal := .T.
		Else
			U_MsgColetor("Esse volume nใo pertence ao cliente GLOBO GROUP S.A.")
			_cNumEtqPA := Space(_nTamEtiq)
			__oGetOP:Refresh()
			__oGetOP:SetFocus()
			Return(.F.)
		EndIf

		nPos:= aScan(aProds,{ |aVet| alltrim(aVet[1]) == alltrim(XD1->XD1_COD)})
		if len(aProds)> 0 .and. nPos == 0
			U_MsgColetor("Produto diferente dos jแ informados anteriormente nessa embalagem", "Verifique")
			_cNumEtqPA := Space(_nTamEtiq)
			__oGetOP:Refresh()
			__oGetOP:SetFocus()
			Return .F.
		Endif 
		
		_nQtdEtiqs += XD1->XD1_QTDORI
		aadd(aProds,XD1->XD1_COD)
		
		_cNumPed  := SC5->C5_NUM + cItemPV
		_cCliEmp  := SC5->C5_CLIENTE
		_cDescric := SA1->A1_NOME
		cPedTel   := SC5->C5_ESP1
		__oTelaOP:Refresh()

	Else
		U_MsgColetor("Etiqueta nใo encontrada.")
		_cNumEtqPA := Space(_nTamEtiq)
		__oGetOP:Refresh()
		__oGetOP:SetFocus()
		cTipoSenf := ""
		_lRet:=.F.
	EndIf
    

_cNumEtqPA:= Space(_nTamEtiq)
__oGetOP:refresh()

Return(_lRet)


Static Function fPrint()
	Local aPar       := {}
	Local aRet       := {}
	Local nVar       := 0
	Local _aArq		:= {}
	Local aCodEtq 	:= {}
	Local nP,nY

	if _nQtdEtiqs <> 0
		SC5->(DbSetOrder(1))
		If SC5->(!DbSeek(xFilial("SC5")+Substring(_cNumPed ,1,6)))
			Alert("Pedido "+Substring(_cNumPed ,1,6)+" nใo localizado!")
			Return .F.
		EndIf

		//Localiza SC6
		SC6->(DbSetOrder(1))
		If SC6->(!DbSeek(xFilial("SC6")+_cNumPed))
			Alert("Item Senf "+AllTrim(__cItem)+" nใo localizado!")
			Return .F.
		EndIf

		//Localiza SA1
		SA1->(DbSetOrder(1))
		If SA1->(!DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
			Alert("Cliente "+SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI+" nใo localizado!")
			Return .F.
		EndIf


		//Valida se Campo Descricao do Produto estแ preenchido
		If  Empty(SB1->B1_DESC)
			Alert("Campo Descricao do Produto nใo estแ preenchido no cadastro do produto! "+Chr(13)+Chr(10)+"[B1_DESC]")
			Return .F.
		EndIf

		//Valida se Campo PN estแ preenchido
		If  Empty(SC6->C6_SEUCOD)
			Alert("Campo PN nใo estแ preenchido no Item do Pedido de Vendas! "+Chr(13)+Chr(10)+"[C6_SEUCOD]")
			Return .F.
		EndIf


		cFila := "000005"
		IF !CB5SetImp(cFila,.F.)
			U_MsgColetor("Local de impressao invalido!")
			Return .F.
		EndIf

		AADD(_aArq,'CT~~CD,~CC^~CT~'+ CRLF)
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

		AADD(_aArq,'^FT71,413^A0N,37,36^FH\^FDN\E9MERO OE/NPA: '+AllTrim(SC5->C5_ESP1)+'^FS'+ CRLF)
		AADD(_aArq,'^FT71,327^A0N,37,36^FH\^FDMARCA Y MODELO: ROSENBERGER Y '+Alltrim(SB1->B1_COD)+'^FS'+ CRLF)

		AADD(_aArq,'^FT71,531^A0N,37,36^FH\^FDCANTIDAD:^FS'+ CRLF)
		AADD(_aArq,'^FT406,561^A0N,42,38^FH\^FD'+cValtochar(_nQtdEtiqs)+'^FS'+ CRLF)
		AADD(_aArq,'^BY2,3,48^FT406,516^BCN,,N,N'+ CRLF)
		AADD(_aArq,'^FD>:'+cValtochar(_nQtdEtiqs)+'^FS'+ CRLF)
		AADD(_aArq,'^PQ1,0,1,Y^XZ'+ CRLF)

		AaDd(aCodEtq,_aArq)

		For nY:=1 To Len(aCodEtq)
			For nP:=1 To Len(aCodEtq[nY])
				MSCBWrite(aCodEtq[nY][nP])
			Next nP
		Next nY

		//Finaliza impressใo da etiqueta
		MSCBEND()

		_aArq:= {}
		aCodEtq:= {}

		MSCBCLOSEPRINTER()

	else
		U_MsgColetor("Nenhuma etiqueta foi lida!")
	Endif
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ            '
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAlertC    บAutor  ณHelio Ferreira      บ Data ณ  15/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Mensagem de alerta para o coletor de dados				     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AlertC(cTexto)

	Local aTemp := U_QuebraString(cTexto,20)
	Local cTemp := ''
	Local lRet  := .T.
    local x

	For x := 1 to Len(aTemp)
		cTemp += aTemp[x] + Chr(13)
	Next x

	cTemp += 'Continuar?'

	While !apMsgNoYes( cTemp )
		lRet:=.F.
	End

Return(lRet)
