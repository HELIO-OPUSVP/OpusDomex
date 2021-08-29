#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFATA07   บAutor  ณMarco Aurelo-OPUS   บ Data ณ  21/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gatilhos para Orcamento  - Analise Credito                 บฑฑ
ฑฑบ          ณ (baseado no RFATA05)                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

Parametros:

"A" - Somente Exibe Mensagem ao preencher o Campo Cliente
"B" - Valida Condicao de Pagamento pelo Campo E4_XRISCOE  como Logico
"C" - Valida Condicao de Pagamento do cadastro de Clientes (A1_COND) pelo Campo E4_XRISCOE  como Logico

*/


User Function RFATA07()

Local _Retorno := .T.
Local _cCampo := StrTran(ReadVar(),"M->","")

If SuperGetMV("MV_XANACRE")  //.and. M->C5_TIPO $ "N"      // Adicionado Tratamento para So executar em Pedido Tipo N

	If _cCampo $ "CJ_CLIENTE,CJ_LOJA,CJ_CONDPAG"  // _cTipo   $  "A/B" 
		_cCliente:=	M->CJ_CLIENTE
		_cLoja	:=	iif(empty(M->CJ_LOJA),"01",M->CJ_LOJA)
		
	//	cRisco := Alltrim(Posicione("SA1",1,xFilial("SA1") + M->C5_CLIENTE + M->C5_LOJACLI,"A1_RISCO"))
		cRisco := Alltrim(Posicione("SA1",1,xFilial("SA1") + _cCliente + _cLoja,"A1_RISCO"))
		cCondE := Posicione("SE4",1,xFilial("SE4") + M->CJ_CONDPAG,"E4_XRISCOE")
	elseif _cCampo $ "A1_COND" //_cTipo   == "C"
		cRisco := M->A1_RISCO
		cCondE := Posicione("SE4",1,xFilial("SE4") + M->A1_COND,"E4_XRISCOE")
	Endif
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMensagem para Cliente - funcao carregada no SX3 do campo CJ_CLIENTE ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if _cCampo $ "CJ_CLIENTE,CJ_LOJA" //_cTipo $ "A"
		if cRisco $ "E"
			MsgInfo("Cliente com Risco 'E'. ")
		Endif
	Endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณValida Condicao de Pagamento (CJ_CONDPAG) - funcao carregada no SX3 do campo CJ_CONDPAG   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if _cCampo $ "CJ_CONDPAG"  // _cTipo $ "B"
		if cRisco $ "E"
			if !cCondE	// Se nao for Cond.Pagto permitida para Risco E
				MsgAlert("Condicao de Pagamento Nao Permitida para este Or็amento, pois o Cliente tem Risco 'E'. ")
				_Retorno := .F.
			Endif
		Endif
	Endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณValida Condicao de Pagamento (A1_COND) - funcao carregada no SX3 do campo A1_COND         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If _cCampo $ "A1_COND" // _cTipo $ "C"
		If cRisco $ "E"
			If !cCondE	// Se nao for Cond.Pagto permitida para Risco E
				MsgAlert("Condicao de Pagamento Nao Permitida para este Or็amento, pois o Cliente tem Risco 'E'. ")
				_Retorno := .F.
			EndIf
		EndIf
	EndIf
	
EndIf

Return _Retorno

