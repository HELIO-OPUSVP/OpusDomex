#include "rwmake.ch"
#include "topconn.ch"
#include "totvs.ch"
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA650FIL  �Autor  �Helio Ferreira      � Data �  28/03/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Filtro na sele��o de Pedidos de Venda para gera��o de OPs  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MA650FIL()
Local _Retorno    := ""
Local dDataLimite := CtoD("31/03/14")

cQuery := "SELECT * FROM " + RetSqlName("SC2") + " (NOLOCK) WHERE C2_FILIAL = '"+xFilial("SC2")+"' AND C2_DATRF = '' AND D_E_L_E_T_ = '' AND C2_DATPRF < '"+DtoS(Date())+"' ORDER BY C2_DATPRF"

If Select("QUERYSC2") <> 0
	QUERYSC2->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QUERYSC2"

If !QUERYSC2->( EOF() )
	MsgStop("A Ordem de Produ��o " + Subs(QUERYSC2->C2_NUM + QUERYSC2->C2_ITEM + QUERYSC2->C2_SEQUEN,1,11) + " est� com data de previs�o de FIM atrasada. Favor corrigir sua data antes de gerar novas OPs.")
	If Date() <= dDataLimite
		MsgInfo("Ap�s 31/03/14 estas inclus�es ser�o bloqueadas.")
	Else
		_Retorno := " 1 = 2 "
	EndIf
EndIf

If Empty(_Retorno)
   _Retorno :=  "SC6->C6_XGERAOP <> '2'"
Else
	_Retorno :=  _Retorno + " .And. SC6->C6_XGERAOP <> '2' "
EndIf	

//grvparop()

Return _Retorno

/*Static function grvparop()
Local aArea := Getarea()
Local aBkpPerg := {}
	
	Pergunte("MTA651",.F.,,,,,@aBkpPerg)
	
	//Altera conte�do de alguma pergunta
	mv_par13 := U_IC2_NUM()

	SaveMVVars(.T.)

	__SaveParam("MTA651    ", aBkpPerg)

RestArea(aArea)
return
*/
