#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA650E   �Autor  �Michel A. Sander    � Data �  21.08.14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada antes da exclusao de OP                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � DOMEX                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MTA650E()

LOCAL _Retorno := .T.
Local aAreaGER := GetArea()
Local aAreaSC5 := SC5->( GetArea() )

//������������������������������������������������������������Ŀ
//�Verifica se houve movimento de material na Ordem de Produ��o�
//��������������������������������������������������������������
lPgto := U_VerPgtoOP(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)

If !lPgto
	Aviso("Aten��o","Esta OP n�o pode ser exclu�da, pois j� existe pagamento de itens no estoque",{"OK"})
	_Retorno := .F.
EndIf

If _Retorno
	SC5->( dbSetOrder(1) )
	
	If !Empty(SC2->C2_PEDIDO)
		If SC5->( dbSeek( xFilial() + SC2->C2_PEDIDO ) )
			If !Reclock("SC5",.F.)
				MsgStop("Pedido de Vendas da OP sendo alterado por outro usu�rio.")
				_Retorno := .F.
			EndIf
			SC5->( msUnlock() )
		EndIf
	EndIf
EndIf

RestArea(aAreaSC5)
RestArea(aAreaGER)

Return( _Retorno )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VerPgtoOP �Autor  �Michel Sander       � Data �  15.08.2014 ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica se OP foi paga antes da alteracao/exclusao        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function VerPgtoOP(cNewCodOp,cProdPG)

Local aAreaGER  := GetArea()
Local aAreaSD3  := SD3->( GetArea() )
Local lVerifica := .T.
Local SUMD3QTD1 := 0

Default cProdPG := ""

SD3->(DbOrderNickName("USUSD30001"))  // D3_FILIAL + D3_XXOP + D3_COD + D3_LOCAL
If !Empty(cNewCodOp)
	If SD3->( dbSeek( xFilial("SD3") + cNewCodOp ) )
		While !SD3->( EOF() ) .and. ALLTRIM(SD3->D3_XXOP) == ALLTRIM(cNewCodOp)
			If Empty(cProdPG) .or. cProdPG == SD3->D3_COD
				If Empty(SD3->D3_ESTORNO) .And. SD3->D3_LOCAL == ALLTRIM(GETMV("MV_XXLOCPR"))
					If SD3->D3_CF == 'DE4'
						SUMD3QTD1 += SD3->D3_QUANT
					EndIf
					If SD3->D3_CF == 'RE4'
						SUMD3QTD1 -= SD3->D3_QUANT
					EndIf
				EndIf
			EndIf
			SD3->( dbSkip() )
		End
	EndIf
EndIf

If SUMD3QTD1 <> 0
	lVerifica := .F.
EndIf

RestArea(aAreaSD3)
RestArea(aAreaGER)

Return(lVerifica)
