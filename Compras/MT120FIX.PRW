/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT120FIX  บAutor  ณMarcos Rezende      บ Data ณ  12/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExibe campos ordenados conforme necessidade do cliente na   บฑฑ
ฑฑบ          ณtabela de pedidos de compras                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
aADD(aCPOS, { "Descri็ใo","C7_DESCRI"})
aADD(aCPOS, { "Quant.","C7_QUANT" })
aADD(aCPOS, { "Pre็o","C7_PRECO" })
aADD(aCPOS, { "Total","C7_TOTAL" })
aADD(aCPOS, { "Necessidade","C7_DOMNECE" })                                           
aADD(aCPOS, { "Dt.Entrega","C7_DATPRF" })                                           
aADD(aCPOS, { "Dt.EntORIG","C7_XXORIGI" })                                           

RETURN aCPOS