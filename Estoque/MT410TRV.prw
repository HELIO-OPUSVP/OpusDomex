//Este ponto de entrada est� implementado na fun��o A410TRAVA para desativar o LOCK 
//de registro das tabelas SA1/SA2/SB2 na altera��o do pedido de venda, efetiva��o do 
//or�amento na rotina aprova��o da venda, rotina retornar do pedido de venda ou libera��o de pedido de venda.


#INCLUDE "PROTHEUS.CH" 

User Function MT410TRV() 
Local cCliForn := ParamIXB[1] // Codigo do cliente/fornecedor 
Local cLoja := ParamIXB[2] // Loja 
Local cTipo := ParamIXB[3] // C=Cliente(SA1) - F=Fornecedor(SA2) 
Local aRet := Array(4) 
Local lTravaSA1 := .F. // Desliga trava da tabela SA1 
Local lTravaSA2 := .F. // Desliga trava da tabela SA2 
Local lTravaSB2 := .F. // Desliga trava da tabela SB2 

Local aRet[1] := lTravaSA1 
Local aRet[2] := lTravaSA2 
Local aRet[3] := lTravaSB2 

//MsgAlert("P.E MT410TRV...","Alerta") 

Return(aRet)