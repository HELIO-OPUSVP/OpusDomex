#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ORC001    ºAutor  ³Marco Aurelo-OPUS   º Data ³  11/09/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gatilhos para Orcamento - Analisa Credito                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

Parametros:

"A" - Exibe Mensagem no Campo Cliente
"B" - Valida Condicao de Pagamento pelo Campo E4_XRISCOE  como Logico
"C" - Valida Condicao de Pagamento do cadastro de Clientes (A1_COND) pelo Campo E4_XRISCOE  como Logico


*/


User Function ORC001(_cTP)

Local _Retorno  := .T.
Local _cTipo 	:= _cTP

if _cTipo   $  "A/B"
	cRisco := Alltrim(Posicione("SA1",1,xFilial("SA1") + M->CJ_CLIENTE + M->CJ_LOJA,"A1_RISCO"))
	cCondE := Posicione("SE4",1,xFilial("SE4") + M->CJ_CONDPAG,"E4_XRISCOE")
elseif _cTipo   == "C"
	cRisco := M->A1_RISCO
	cCondE := Posicione("SE4",1,xFilial("SE4") + M->A1_COND,"E4_XRISCOE")
Endif
		

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Mensagem para Cliente - funcao carregada no SX3 do campo CJ_CLIENTE ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if _cTipo $ "A"
	if cRisco $ "E"
		MsgInfo("Cliente com Risco 'E' ")
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida Condicao de Pagamento (CJ_CONDPAG) - funcao carregada no SX3 do campo CJ_CONDPAG   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if _cTipo $ "B"
	if cRisco $ "E"
		if !cCondE	// Se nao for Cond.Pagto permitida para Risco E
			MsgAlert("Condicao de Pagamento Nao Permitida para Este Cliente, pois ele tem Risco 'E'. ")
			_Retorno := .F.
        Endif
		
	Endif
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida Condicao de Pagamento (A1_COND) - funcao carregada no SX3 do campo A1_COND         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if _cTipo $ "C"

	if cRisco $ "E"
		if !cCondE	// Se nao for Cond.Pagto permitida para Risco E
			MsgAlert("Condicao de Pagamento Nao Permitida para Este Cliente, pois ele tem Risco 'E'. ")
			_Retorno := .F.
        Endif
	Endif

Endif

 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza Flag do campo (CJ_XStatus) Liberacao do Orcamento                                ³
//³ A=Aguardando Liberacao    (LARANJA)                                                      ³
//³ B=Aguardando Autorizacao Cartao de Credito (BRANCO)                                      ³
//³ C=Autorizado Cartao de Credito  (VIOLETA)                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

if _cTipo   $  "A/B"	// Chamado pelo Orcamento
	if cRisco $ "E"
		if empty(M->CJ_XAUTCC)
			M->CJ_XSTATUS := "B"
		else
			M->CJ_XSTATUS := "C"
		endif
			
	Endif

Endif

Return _Retorno
