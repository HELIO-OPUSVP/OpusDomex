#include "rwmake.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA650POK  �Autor  �Mauricio OPUS      � Data �  22/06/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Tudo Ok da tela de inclus�o de OP por vendas               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Domex                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function MTA650POK()
Local _Retorno    :=.T.
Local aArea       := GetArea()
Local aAreaSB1    := SB1->(GetArea())

//verifica se o produto possui rastro(lote)

If _Retorno
	SB1->(DBSELECTAREA('SB1'))
	SB1->(DBSETORDER(1))
	If SB1->( dbSeek( xFilial() + SC6->C6_PRODUTO ) )
		IF ALLTRIM(SB1->B1_RASTRO)<>'L'
			MSGALERT('Produto :'+alltrim(SC6->C6_PRODUTO)+' Sem controle de Lote (B1_RASTRO)' )
			_Retorno:=.F.
		ENDIF
		IF ALLTRIM(SB1->B1_LOCALIZ)<>'S'
			MSGALERT('Produto :'+alltrim(SC6->C6_PRODUTO)+' Sem controle de Endere�o (B1_LOCALIZ) ' )
			_Retorno:=.F.
		ENDIF
	EndIf
EndIf

/*
//If GetMV("MV_XSEMAOP") == 'S' .and. If( Type("__XXNumSeq") == 'U', .T. , If( Empty(__XXNumSeq) ,.T. , .F. )  )   ///*joao - COMENTADO
//	Public __XXNumSeq := U_INUMSEQ("MTA650POK()-Inclus�o de OP p/vendas PV:" + SC6->C6_NUM + "/" + SC6->C6_ITEM) // JOAO - COMENTADO
//	MsgInfo("MTA650POK() - TudoOK abertura OP p/vendas-Depois da inicializa��o do Sem�foro Domex")
//	//RETIRADO Vanessa Faio PE TudoOK abertura OP por vendas
//EndIf    // JOAO - COMENTADO
*/

RestArea(aAreaSB1)
RestArea(aArea)

Return _Retorno
