#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VC6_XXOP  �Autor  �Helio Ferreira      � Data �  08/19/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

// Validar se a OP est� encerrada
// Validar se a TES atualiza estoque e se est� com controle terceiros = Remessa

User Function VC6_XXOP()
Local _Retorno     := .T.
Local aAreaGER     := GetArea()
Local aAreaSC2     := SC2->( GetArea() )
Local nPC6_PRODUTO := aScan( aHeader, {|aVet| Alltrim(aVet[2]) == "C6_PRODUTO" } )
Local nPC6_QTDVEN  := aScan( aHeader, {|aVet| Alltrim(aVet[2]) == "C6_QTDVEN"  } )

If !Empty(aCols[N,nPC6_PRODUTO])
	SC2->( dbSetOrder(1) )
	If !SC2->( dbSeek( xFilial() + M->C6_XXOP ) )
		MsgStop("OP inv�lida.")
		_Retorno := .F.
	Else
	   SD4->( dbSetOrder(1) )
		If SD4->( dbSeek( xFilial() + aCols[N,nPC6_PRODUTO] + M->C6_XXOP ) )
			If !Empty(aCols[n,nPC6_QTDVEN])
			   If aCols[n,nPC6_QTDVEN] > SD4->D4_QUANT
			      MsgStop("Quantidade do produto enviado superior ao empenho do mesmo para a OP de Beneficiamento.")
			      _Retorno := .F.
			   EndIf
			Else
			   MsgStop("Favor preencher a quantidade antes da OP de Beneficiamento.")
			   _Retorno := .F.
			EndIf
		Else
			MsgStop("Produto " + Alltrim(aCols[N,nPC6_PRODUTO]) + " n�o encontrado empenhado para esta OP.")
			_Retorno := .F.
		EndIf
	EndIf
Else
	MsgStop("Favor preencher o produto antes da OP de Beneficiamento.")
	_Retorno := .F.
EndIf

RestArea(aAreaSC2)
RestArea(aAreaGER)

Return _Retorno
