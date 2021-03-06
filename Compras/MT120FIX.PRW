/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT120FIX  �Autor  �Marcos Rezende      � Data �  12/03/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Exibe campos ordenados conforme necessidade do cliente na   ���
���          �tabela de pedidos de compras                                ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"

USER FUNCTION MT120FIX()

LOCAL aCPOS := {}
aADD(aCPOS, { "Numero " ,"C7_NUM" })
aADD(aCPOS, { "Item " ,"C7_ITEM" })
aADD(aCPOS, { "Fornecedor" ,"C7_FORNECE" })
aADD(aCPOS, { "Loja","C7_LOJA   " })
aADD(aCPOS, { "Nome For","C7_NOMEFOR"})
aADD(aCPOS, { "Cod.Produto","C7_PRODUTO" })
aADD(aCPOS, { "Descri��o","C7_DESCRI"})
aADD(aCPOS, { "Quant.","C7_QUANT" })
aADD(aCPOS, { "Pre�o","C7_PRECO" })
aADD(aCPOS, { "Total","C7_TOTAL" })
aADD(aCPOS, { "Necessidade","C7_DOMNECE" })                                           
aADD(aCPOS, { "Dt.Entrega","C7_DATPRF" })                                           
aADD(aCPOS, { "Dt.EntORIG","C7_XXORIGI" })                                           

RETURN aCPOS