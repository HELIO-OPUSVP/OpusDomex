USER FUNCTION MT150FIX()
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT150FIX  �Autor  �Marcos Rezende      � Data �  11/26/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Exibe campos ordenados conforme necessidade do cliente na   ���
���          �tabela de cota��es                                          ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

LOCAL aCPOS := {}


aADD(aCPOS, { "Numero " ,"C8_NUM" })
aADD(aCPOS, { "Item " ,"C8_ITEM" })
aADD(aCPOS, { "Fornecedor" ,"C8_FORNECE" })
aADD(aCPOS, { "Loja","C8_LOJA   " })
aADD(aCPOS, { "Nome For","C8_NOMEFOR"})
aADD(aCPOS, { "Proposta","C8_NUMPRO" })
aADD(aCPOS, { "Cod.Produto","C8_PRODUTO" })
aADD(aCPOS, { "Descri��o","C8_DESCRI"})
aADD(aCPOS, { "Pre�o","C8_PRECO" })
aADD(aCPOS, { "Validade","C8_VALIDA " })                                           
aADD(aCPOS, { "Pedido","C8_NUMPED" })                                           
aADD(aCPOS, { "It.Pedido","C8_ITEMPED" })                                           
aADD(aCPOS, { "Solicita��o","C8_NUMSC" })                                           
aADD(aCPOS, { "It.Solic","C8_ITEMSC" })                                           




RETURN aCPOS