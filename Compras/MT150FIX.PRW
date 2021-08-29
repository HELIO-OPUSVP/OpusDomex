USER FUNCTION MT150FIX()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT150FIX  บAutor  ณMarcos Rezende      บ Data ณ  11/26/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExibe campos ordenados conforme necessidade do cliente na   บฑฑ
ฑฑบ          ณtabela de cota็๕es                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

LOCAL aCPOS := {}


aADD(aCPOS, { "Numero " ,"C8_NUM" })
aADD(aCPOS, { "Item " ,"C8_ITEM" })
aADD(aCPOS, { "Fornecedor" ,"C8_FORNECE" })
aADD(aCPOS, { "Loja","C8_LOJA   " })
aADD(aCPOS, { "Nome For","C8_NOMEFOR"})
aADD(aCPOS, { "Proposta","C8_NUMPRO" })
aADD(aCPOS, { "Cod.Produto","C8_PRODUTO" })
aADD(aCPOS, { "Descri็ใo","C8_DESCRI"})
aADD(aCPOS, { "Pre็o","C8_PRECO" })
aADD(aCPOS, { "Validade","C8_VALIDA " })                                           
aADD(aCPOS, { "Pedido","C8_NUMPED" })                                           
aADD(aCPOS, { "It.Pedido","C8_ITEMPED" })                                           
aADD(aCPOS, { "Solicita็ใo","C8_NUMSC" })                                           
aADD(aCPOS, { "It.Solic","C8_ITEMSC" })                                           




RETURN aCPOS