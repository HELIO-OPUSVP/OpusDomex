#include "TbiConn.ch"
#include "TbiCode.ch"
#include "rwmake.ch"
#include "TOpconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DOMEST06  ºAutor  ³Helio Ferreira     º Data ³              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Não fui eu que desenvolvi. Apenas estou documentando:      º±±
±±º          ³                                                            º±±
±±º          ³ Impressão de etiquetas chamada de vários programas.        º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


//TLP 2844
User Function DOMEST06(lColetor, cFila)

	Local _cPorta  := "LPT1"
	Local cModelo  :=  "TLP 2844"  // "Z4M"
	Local aAreaGER := GetArea()
	Local aAreaSA2 := SA2->( GetArea() )
	Local aAreaSB1 := SB1->( GetArea() )
	Local _cNome  := CriaVar("A2_NREDUZ")

	Default cFila := "000000"
	Default lColetor:= .F.


/*
MSCBPrinter("Z4M","LPT1",,,.F.)
MSCBChkStatus(.F.)
MSCBBegin(1,2)
MSCBSay(05,03,"NF HELIO:"+XD1->XD1_DOC + "  Prod:"+Alltrim(XD1->XD1_COD) + " Qt: " + Alltrim(Transform(XD1->XD1_QTDORI,'@E 999,999,999.9'))  ,"N","0","35,30")
MSCBSay(05,08,SubStr(SB1->B1_DESC,1,33)                       ,"N","0","35,30")
MSCBSay(05,14,"FornHELIO :"+XD1->XD1_FORNEC+"/"+XD1->XD1_LOJA+' - '+ Posicione("SA2",1,xFilial("SA2")+XD1->XD1_FORNEC+XD1->XD1_LOJA,"A2_NOME") ,"N","0","35,30")
MSCBSayBar(13,19,AllTrim(XD1->XD1_XXPECA),"MB07",'E',13,.T.,.T.,.F.,,5  ,2, .F.)
MSCBEnd()
Sleep(500)
MSCBClosePrinter()

Return
*/

	SA2->(dbSetOrder(1))
	If SA2->(dbSeek(xFilial("SA2")+XD1->XD1_FORNEC+XD1->XD1_LOJA))
		_cNome :=SubStr(SA2->A2_NREDUZ,1,18)
	EndIf

	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1")+XD1->XD1_COD))
	_cDescri:= StrTran(SubStr(SB1->B1_DESC,1,33),'"',"")

	IF !lColetor
		MSCBPrinter(cModelo,_cPorta,,,.F.)
		MSCBChkStatus(.F.)
		//MSCBBegin(1,2)
	Else
		IF !CB5SetImp(cFila,.F.)
			U_MsgColetor("Local de impressao invalido!")
			Return .F.
		EndIf

	Endif

	MSCBBegin(1,6)

	If !Empty(XD1->XD1_DOC)
		MSCBSay(26,00,"NF:"+XD1->XD1_DOC,"N","2","1,1")
	EndIf

	MSCBSay(30,00,"Prod:"+XD1->XD1_COD + "  " + Alltrim(Transform(XD1->XD1_QTDATU,"@E 999,999.9999")),"N","2","1,1")
	MSCBSay(30,03,_cDescri,"N","2","1,1")

	If !Empty(_cNome)
		MSCBSay(26,06,"Forn:"+XD1->XD1_FORNEC+"/"+XD1->XD1_LOJA+"-"+_cNome,"N","2","1,1")
	EndIf

	If !Empty(XD1->XD1_OP)
		MSCBSay(30,06,"OP:" + XD1->XD1_OP + " LOTE:" + XD1->XD1_LOTECT,"N","2","1,1")
	EndIf

	MSCBSayBar(30,09,AllTrim(XD1->XD1_XXPECA),"N","MB04",12.36,.F.,.T.,.F.,,3,Nil,Nil,Nil,Nil,Nil)
	MSCBEnd()
	Sleep(500)
	MSCBClosePrinter()

	RestArea(aAreaSA2)
	RestArea(aAreaSB1)
	RestArea(aAreaGER)

Return
