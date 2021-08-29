#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTB_LP    ºAutor  ³Marco Aurelio       º Data ³  04/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gatilho para Retornar Item Contabil de Debito              º±±
±±º          ³ Definido por Lancamento Padrao                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

EXEMPLO:  U_CTBLP("530/001","CTDB")

PARAMETROS:
_LP = Numero do LP/Sequencia
_TP = Campo a ser alimentado, onde:
				"CTDB" = Conta de Debito
				"CCDB" = Centro de Custo de Debito
				"ITDB" = Item Contabil de Debito
				"CLDB" = Classe de Valor de Debito
				"ATDB" = Atividade/Outras Informacoes de Debito
				"CTCR" = Conta de Credito
				"CCCR" = Centro de Custo de Credito
				"ITCR" = Item Contabil de Credito
				"CLCR" = Classe de Valor de Credito
				"ATCR" = Atividade/Outras Informacoes de Credito				
*/

User Function CTBLP(_LP,_TP)
											 
Local _Retorno := ""
Local _LpSeq	:= _LP
Local _Tipo		:= _TP

if _LpSeq == "530/001" 

//	_CTDB:= iif(!Alltrim(SE2->E2_NATUREZ)$("20606/INSS/ISS"),iIF(SE5->E5_CLIFOR > "666666" .OR. SE5->E5_PREFIXO == "EIC",SED->ED_CONTA,iIF(SA2->A2_EST == "EX",210301000000,210201000000)),SED->ED_CONTA)
//	_CCDB:= ""
//	_ITDB:= iif(Posicione("CT1",1,xFilial("CT1")+_CTDB,"CT1_ACITEM")	<>"1","", iIf(!Alltrim(SE2->E2_NATUREZ)$("PIS/COFINS/CSLL/IRF/INSS/ISS"),"F"+SA2->A2_COD+SA2->A2_LOJA,"")    )

	_CTDB:= iif(!Alltrim(SE5->E5_NATUREZ)$("20606/INSS/ISS"),iIF(SE5->E5_CLIFOR > "666666" .OR. SE5->E5_PREFIXO == "EIC",SED->ED_CONTA,iIF(SA2->A2_EST == "EX","210301000000","210201000000")),SED->ED_CONTA)
	_CCDB:= ""
	_ITDB:= iif(Posicione("CT1",1,xFilial("CT1")+_CTDB,"CT1_ACITEM")	<>"1","", iIf(!Alltrim(SE5->E5_NATUREZ)$("PIS/COFINS/CSLL/IRF/INSS/ISS"),"F"+SA2->A2_COD+SA2->A2_LOJA,"")    )
	
Endif


// Retorna a Variavel correta
	if 	 _Tipo $ "CTDB"
		_Retorno :=  _CTDB
	elseif _Tipo $ "CCDB"
		_Retorno :=  _CCDB
	elseif _Tipo $ "ITDB"
		_Retorno :=  _ITDB
	elseif _Tipo $ "CLDB"
		_Retorno :=  _CLDB
	elseif _Tipo $ "ATDB"
		_Retorno :=  _ATDB
	elseif _Tipo $ "CTCR"
		_Retorno :=  _CTCR
	elseif _Tipo $ "CCCR"
		_Retorno :=  _CCCR
	elseif _Tipo $ "ITCR"
		_Retorno :=  _ITCR
	elseif _Tipo $ "CLCR"
		_Retorno :=  _CLCR
	elseif _Tipo $ "ATCR"
		_Retorno :=  _ATCR				
	Endif

Return (_Retorno)
