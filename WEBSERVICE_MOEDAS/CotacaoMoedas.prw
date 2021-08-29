#Include 'Protheus.ch'
#INCLUDE "RWMAKE.ch"
#Include "TbiConn.ch"                 
#INCLUDE "TOPCONN.CH"      

/* COTACAO MOEDA AUTOMATICO BANCO CENTRAL
//https://www3.bcb.gov.br/sgspub/JSP/sgsgeral/FachadaWSSGS.wsdl
//Mauricio OpusVP    16/04/2018
*/

*--------------------------------------------------------------------------------------------------------------------------*
User Function CotacaoMoedas()
*--------------------------------------------------------------------------------------------------------------------------*
LOCAL  nX              := 0
LOCAL  nVALMOE1        := 1
RPCSetType(3)  // Nao utilizar licensa

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"  USER 'MRP' PASSWORD 'MRP' TABLES  "SM2" , "SYF" , "SYE"

SetUserDefault("000000")

SM2->( dbSetOrder(1) )
SYF->( dbSetOrder(1) )
SYE->( dbSetOrder(1) )
*--------------------------------------------------------------------------------------------------------------------------*
PRIVATE oCotacaoMoedas  := Nil
PRIVATE cRetCotMoeda    := ""
PRIVATE cAvisos         := ""
PRIVATE cErros          := ""
PRIVATE cReplace        := ""
PRIVATE oXMLCotMoeda    := Nil
PRIVATE dDataCotacao    := StoD("")
PRIVATE nCotacaoMoeda   := 0
*-----------------D O L A R  MOEDA 2 US$---------------------------------------------------------------------------------------------------------*
//Instanciacao do WsClient de Moeda
oCotacaoMoedas   := WSFachadaWSSGSService():New()
//Setado o Codigo 10813 respectivo ao Dolar (Compra) MOEDA 2
oCotacaoMoedas:nin0 :=  1  //1 Dólar (venda)
//Verificamos se o metodo getUltimoValorXML do WsClient WSFachadaWSSGSService foi consumido com sucesso
If (oCotacaoMoedas:getUltimoValorXML())
	//Obtem o retorno de cotacao da Moeda no formato XML
	cRetCotMoeda := oCotacaoMoedas:cgetUltimoValorXMLReturn
	//Utiliza a funcao XmlParser para converter o retorno XML do WS para uma variavel do Tipo Objeto
	oXMLCotMoeda :=  XmlParser(cRetCotMoeda, cReplace, @cErros, @cAvisos)
	//Verifica se houve erro ao consumir o WS
	If AllTrim(cErros) == ""
		//Obtem a Data da Ultima Cotacao
		_cANO:=oXMLCotMoeda:_RESPOSTA:_SERIE:_DATA:_ANO:TEXT
		_cMes:=oXMLCotMoeda:_RESPOSTA:_SERIE:_DATA:_MES:TEXT
		If val(_cMes) <=9
			_cMes:='0'+alltrim(_cMes)
		endif
		_cDia:=oXMLCotMoeda:_RESPOSTA:_SERIE:_DATA:_DIA:TEXT
		If val(_cDia) <=9
			_cDia:='0'+alltrim(_cDia)
		endif
		_cDATA := ALLTRIM(_cANO)  +ALLTRIM(_cMes)+ALLTRIM(_cDia)
		dDataCotacao := StoD(_cDATA)
		//Obtem o Valor da Ultima Cotacao
		nCotacaoMoeda := Val(StrTran(oXMLCotMoeda:_RESPOSTA:_SERIE:_VALOR:TEXT, ",", "."))
		
		SM2->(DBSelectArea("SM2"))
		SM2->(DBSetOrder(1))   // SM2 1 M2_DATA
		
		//Verifaca se ja existe ou nao, a Cotacao na Data obtida no consumo do WS
		//----------------------------------------------------------------------------------------------------------------------------------
		IIF(SM2->(DBSeek(DtoS(dDataCotacao))),  SM2->(RecLock("SM2", .F.)), SM2->(RecLock("SM2", .T.))) // TABELA SM2 NAO POSSUI FILIAL
		SM2->M2_DATA    := dDataCotacao
		SM2->M2_MOEDA1  := nVALMOE1
		SM2->M2_MOEDA2  := nCotacaoMoeda
		SM2->M2_TXMOED2 := nCotacaoMoeda
		SM2->M2_INFORM  := "S"
		SM2->(MsUnLock())
		
		SYE->(DBSelectArea("SYE")) // TAXA MOEDA SIGAEIC
		SYE->(DBSetOrder(1))       // YE_FILIAL+DTOS(YE_DATA)+YE_MOEDA
		
		IIF(SYE->(DBSeek(xFILIAL('SYE')+DtoS(dDataCotacao)+'US$')),  SM2->(RecLock("SYE", .F.)), SM2->(RecLock("SYE", .T.)))
		SYE->YE_FILIAL  :=xFILIAL('SYE')
		SYE->YE_DATA    :=dDataCotacao
		SYE->YE_MOEDA   :='US$'
		SYE->YE_MOE_FIN :=' 2'
		SYE->YE_VLCON_C :=nCotacaoMoeda
		SYE->YE_VLFISCA :=nCotacaoMoeda
		SYE->YE_TX_COMP :=nCotacaoMoeda
		SYE->(MsUnLock())
		//---------------------------------------------------------------------------------------------------------------------------------
		FOR nX :=1 TO 180
			IIF(SM2->(DBSeek(DtoS(dDataCotacao+nX))),  SM2->(RecLock("SM2", .F.)), SM2->(RecLock("SM2", .T.))) // TABELA SM2 NAO POSSUI FILIAL
			SM2->M2_DATA    := dDataCotacao+nX
			SM2->M2_MOEDA1  := nVALMOE1
			SM2->M2_MOEDA2  := nCotacaoMoeda
			SM2->M2_TXMOED2 := nCotacaoMoeda
			SM2->M2_INFORM  := "S"
			SM2->(MsUnLock())
			
			SYE->(DBSelectArea("SYE")) // TAXA MOEDA SIGAEIC
			SYE->(DBSetOrder(1))       // YE_FILIAL+DTOS(YE_DATA)+YE_MOEDA
			
			IIF(SYE->(DBSeek(xFILIAL('SYE')+DtoS(dDataCotacao+nX)+'US$')),  SM2->(RecLock("SYE", .F.)), SM2->(RecLock("SYE", .T.)))
			SYE->YE_FILIAL  :=xFILIAL('SYE')
			SYE->YE_DATA    :=dDataCotacao+nX
			SYE->YE_MOEDA   :='US$'
			SYE->YE_MOE_FIN :=' 2'
			SYE->YE_VLCON_C :=nCotacaoMoeda
			SYE->YE_VLFISCA :=nCotacaoMoeda
			SYE->YE_TX_COMP :=nCotacaoMoeda
			SYE->(MsUnLock())
		NEXT nX
		//---------------------------------------------------------------------------------------------------------------------------------
		
		
	EndIf
EndIf
*-----------------F R A N C O  S U I C O  MOEDA 3 CHF---------------------------------------------------------------------------------------------------------*
oCotacaoMoedas   := WSFachadaWSSGSService():New()
oCotacaoMoedas:nin0 :=21625  //21626 // franco suico (compra) moeda 3
If (oCotacaoMoedas:getUltimoValorXML())
	cRetCotMoeda := oCotacaoMoedas:cgetUltimoValorXMLReturn
	oXMLCotMoeda :=  XmlParser(cRetCotMoeda, cReplace, @cErros, @cAvisos)
	If AllTrim(cErros) == ""
		_cANO:=oXMLCotMoeda:_RESPOSTA:_SERIE:_DATA:_ANO:TEXT
		_cMes:=oXMLCotMoeda:_RESPOSTA:_SERIE:_DATA:_MES:TEXT
		If val(_cMes) <=9
			_cMes:='0'+alltrim(_cMes)
		endif
		_cDia:=oXMLCotMoeda:_RESPOSTA:_SERIE:_DATA:_DIA:TEXT
		If val(_cDia) <=9
			_cDia:='0'+alltrim(_cDia)
		endif
		_cDATA := ALLTRIM(_cANO)  +ALLTRIM(_cMes)+ALLTRIM(_cDia)
		dDataCotacao := StoD(_cDATA)
		nCotacaoMoeda := Val(StrTran(oXMLCotMoeda:_RESPOSTA:_SERIE:_VALOR:TEXT, ",", "."))
		SM2->(DBSelectArea("SM2"))
		SM2->(DBSetOrder(1))   // SM2 1 M2_DATA
		
		//-----------------------------------------------------------------------------------------------------------------------------
		IIF(SM2->(DBSeek(DtoS(dDataCotacao))),  SM2->(RecLock("SM2", .F.)), SM2->(RecLock("SM2", .T.))) // TABELA SM2 NAO POSSUI FILIAL
		SM2->M2_DATA    := dDataCotacao
		SM2->M2_MOEDA3  := nCotacaoMoeda
		SM2->M2_TXMOED3 := nCotacaoMoeda
		SM2->M2_INFORM  := "S"
		SM2->(MsUnLock())
		
		SYE->(DBSelectArea("SYE")) // TAXA MOEDA SIGAEIC                         CHF FRANCO SUICO
		SYE->(DBSetOrder(1))       // YE_FILIAL+DTOS(YE_DATA)+YE_MOEDA
		
		IIF(SYE->(DBSeek(xFILIAL('SYE')+DtoS(dDataCotacao)+'CHF')),  SM2->(RecLock("SYE", .F.)), SM2->(RecLock("SYE", .T.)))
		SYE->YE_FILIAL  :=xFILIAL('SYE')
		SYE->YE_DATA    :=dDataCotacao
		SYE->YE_MOEDA   :='CHF'
		SYE->YE_MOE_FIN :=' 3'
		SYE->YE_VLCON_C :=nCotacaoMoeda
		SYE->YE_VLFISCA :=nCotacaoMoeda
		SYE->YE_TX_COMP :=nCotacaoMoeda
		SYE->(MsUnLock())
		//-----------------------------------------------------------------------------------------------------------------------------
		FOR nX :=1 TO 180
			IIF(SM2->(DBSeek(DtoS(dDataCotacao+nX))),  SM2->(RecLock("SM2", .F.)), SM2->(RecLock("SM2", .T.))) // TABELA SM2 NAO POSSUI FILIAL
			SM2->M2_DATA    := dDataCotacao+nX
			SM2->M2_MOEDA3  := nCotacaoMoeda
			SM2->M2_TXMOED3 := nCotacaoMoeda
			SM2->M2_INFORM  := "S"
			SM2->(MsUnLock())
			
			SYE->(DBSelectArea("SYE")) // TAXA MOEDA SIGAEIC                         CHF FRANCO SUICO
			SYE->(DBSetOrder(1))       // YE_FILIAL+DTOS(YE_DATA)+YE_MOEDA
			
			IIF(SYE->(DBSeek(xFILIAL('SYE')+DtoS(dDataCotacao+nX)+'CHF')),  SM2->(RecLock("SYE", .F.)), SM2->(RecLock("SYE", .T.)))
			SYE->YE_FILIAL  :=xFILIAL('SYE')
			SYE->YE_DATA    :=dDataCotacao+nX
			SYE->YE_MOEDA   :='CHF'
			SYE->YE_MOE_FIN :=' 3'
			SYE->YE_VLCON_C :=nCotacaoMoeda
			SYE->YE_VLFISCA :=nCotacaoMoeda
			SYE->YE_TX_COMP :=nCotacaoMoeda
			SYE->(MsUnLock())
			//-----------------------------------------------------------------------------------------------------------------------------
		NEXT nX
		
	EndIf
EndIf

/*
*-----------------F R A N C O  S U I C O  MOEDA 3 CHF---------------------------------------------------------------------------------------------------------*
oCotacaoMoedas   := WSFachadaWSSGSService():New()
oCotacaoMoedas:nin0 :=21625  //21626 // franco suico (compra) moeda 3
If (oCotacaoMoedas:getUltimoValorXML())
	cRetCotMoeda := oCotacaoMoedas:cgetUltimoValorXMLReturn
	oXMLCotMoeda :=  XmlParser(cRetCotMoeda, cReplace, @cErros, @cAvisos)
	If AllTrim(cErros) == ""
		_cANO:=oXMLCotMoeda:_RESPOSTA:_SERIE:_DATA:_ANO:TEXT
		_cMes:=oXMLCotMoeda:_RESPOSTA:_SERIE:_DATA:_MES:TEXT
		If val(_cMes) <=9
			_cMes:='0'+alltrim(_cMes)
		endif
		_cDia:=oXMLCotMoeda:_RESPOSTA:_SERIE:_DATA:_DIA:TEXT
		If val(_cDia) <=9
			_cDia:='0'+alltrim(_cDia)
		endif
		_cDATA := ALLTRIM(_cANO)  +ALLTRIM(_cMes)+ALLTRIM(_cDia)
		dDataCotacao := StoD(_cDATA)
		nCotacaoMoeda := Val(StrTran(oXMLCotMoeda:_RESPOSTA:_SERIE:_VALOR:TEXT, ",", "."))
		SM2->(DBSelectArea("SM2"))
		SM2->(DBSetOrder(1))   // SM2 1 M2_DATA
		
		//-----------------------------------------------------------------------------------------------------------------------------
		IIF(SM2->(DBSeek(DtoS(dDataCotacao))),  SM2->(RecLock("SM2", .F.)), SM2->(RecLock("SM2", .T.))) // TABELA SM2 NAO POSSUI FILIAL
		SM2->M2_DATA    := dDataCotacao
		SM2->M2_MOEDA3  := nCotacaoMoeda
		SM2->M2_TXMOED3 := nCotacaoMoeda
		SM2->M2_INFORM  := "S"
		SM2->(MsUnLock())
		
		SYE->(DBSelectArea("SYE")) // TAXA MOEDA SIGAEIC                         CHF FRANCO SUICO
		SYE->(DBSetOrder(1))       // YE_FILIAL+DTOS(YE_DATA)+YE_MOEDA
		
		IIF(SYE->(DBSeek(xFILIAL('SYE')+DtoS(dDataCotacao)+'CHF')),  SM2->(RecLock("SYE", .F.)), SM2->(RecLock("SYE", .T.)))
		SYE->YE_FILIAL  :=xFILIAL('SYE')
		SYE->YE_DATA    :=dDataCotacao
		SYE->YE_MOEDA   :='CHF'
		SYE->YE_MOE_FIN :=' 3'
		SYE->YE_VLCON_C :=nCotacaoMoeda
		SYE->YE_VLFISCA :=nCotacaoMoeda
		SYE->YE_TX_COMP :=nCotacaoMoeda
		SYE->(MsUnLock())
		//-----------------------------------------------------------------------------------------------------------------------------
		FOR nX :=1 TO 180
			IIF(SM2->(DBSeek(DtoS(dDataCotacao+nX))),  SM2->(RecLock("SM2", .F.)), SM2->(RecLock("SM2", .T.))) // TABELA SM2 NAO POSSUI FILIAL
			SM2->M2_DATA    := dDataCotacao+nX
			SM2->M2_MOEDA3  := nCotacaoMoeda
			SM2->M2_TXMOED3 := nCotacaoMoeda
			SM2->M2_INFORM  := "S"
			SM2->(MsUnLock())
			
			SYE->(DBSelectArea("SYE")) // TAXA MOEDA SIGAEIC                         CHF FRANCO SUICO
			SYE->(DBSetOrder(1))       // YE_FILIAL+DTOS(YE_DATA)+YE_MOEDA
			
			IIF(SYE->(DBSeek(xFILIAL('SYE')+DtoS(dDataCotacao+nX)+'CHF')),  SM2->(RecLock("SYE", .F.)), SM2->(RecLock("SYE", .T.)))
			SYE->YE_FILIAL  :=xFILIAL('SYE')
			SYE->YE_DATA    :=dDataCotacao+nX
			SYE->YE_MOEDA   :='CHF'
			SYE->YE_MOE_FIN :=' 3'
			SYE->YE_VLCON_C :=nCotacaoMoeda
			SYE->YE_VLFISCA :=nCotacaoMoeda
			SYE->YE_TX_COMP :=nCotacaoMoeda
			SYE->(MsUnLock())
			//-----------------------------------------------------------------------------------------------------------------------------
		NEXT nX
		
	EndIf
EndIf

*/
*-----------------E U R O  MOEDA 5 EUR ---------------------------------------------------------------------------------------------------------*
oCotacaoMoedas   := WSFachadaWSSGSService():New()
oCotacaoMoedas:nin0 :=21619  //21620 // EURO (compra) moeda 5
If (oCotacaoMoedas:getUltimoValorXML())
	cRetCotMoeda := oCotacaoMoedas:cgetUltimoValorXMLReturn
	oXMLCotMoeda :=  XmlParser(cRetCotMoeda, cReplace, @cErros, @cAvisos)
	If AllTrim(cErros) == ""
		_cANO:=oXMLCotMoeda:_RESPOSTA:_SERIE:_DATA:_ANO:TEXT
		_cMes:=oXMLCotMoeda:_RESPOSTA:_SERIE:_DATA:_MES:TEXT
		If val(_cMes) <=9
			_cMes:='0'+alltrim(_cMes)
		endif
		_cDia:=oXMLCotMoeda:_RESPOSTA:_SERIE:_DATA:_DIA:TEXT
		If val(_cDia) <=9
			_cDia:='0'+alltrim(_cDia)
		endif
		_cDATA := ALLTRIM(_cANO)  +ALLTRIM(_cMes)+ALLTRIM(_cDia)
		dDataCotacao := StoD(_cDATA)
		nCotacaoMoeda := Val(StrTran(oXMLCotMoeda:_RESPOSTA:_SERIE:_VALOR:TEXT, ",", "."))
		SM2->(DBSelectArea("SM2"))
		SM2->(DBSetOrder(1))   // SM2 1 M2_DATA
		//-----------------------------------------------------------------------------------------------------------------------------
		IIF(SM2->(DBSeek(DtoS(dDataCotacao))),  SM2->(RecLock("SM2", .F.)), SM2->(RecLock("SM2", .T.))) // TABELA SM2 NAO POSSUI FILIAL
		SM2->M2_DATA    := dDataCotacao
		SM2->M2_MOEDA5  := nCotacaoMoeda
		SM2->M2_TXMOED5 := nCotacaoMoeda
		SM2->M2_INFORM  := "S"
		SM2->(MsUnLock())
		
		SYE->(DBSelectArea("SYE")) // TAXA MOEDA SIGAEIC                         EUR  EURO
		SYE->(DBSetOrder(1))       // YE_FILIAL+DTOS(YE_DATA)+YE_MOEDA
		
		IIF(SYE->(DBSeek(xFILIAL('SYE')+DtoS(dDataCotacao)+'EUR')),  SM2->(RecLock("SYE", .F.)), SM2->(RecLock("SYE", .T.)))
		SYE->YE_FILIAL  :=xFILIAL('SYE')
		SYE->YE_DATA    :=dDataCotacao
		SYE->YE_MOEDA   :='EUR'
		SYE->YE_MOE_FIN :=' 5'
		SYE->YE_VLCON_C :=nCotacaoMoeda
		SYE->YE_VLFISCA :=nCotacaoMoeda
		SYE->YE_TX_COMP :=nCotacaoMoeda
		SYE->(MsUnLock())
		//-----------------------------------------------------------------------------------------------------------------------------
		FOR nX :=1 TO 180
			IIF(SM2->(DBSeek(DtoS(dDataCotacao+nX))),  SM2->(RecLock("SM2", .F.)), SM2->(RecLock("SM2", .T.))) // TABELA SM2 NAO POSSUI FILIAL
			SM2->M2_DATA    := dDataCotacao+nX
			SM2->M2_MOEDA5  := nCotacaoMoeda
			SM2->M2_TXMOED5 := nCotacaoMoeda
			SM2->M2_INFORM  := "S"
			SM2->(MsUnLock())
			
			SYE->(DBSelectArea("SYE")) // TAXA MOEDA SIGAEIC                         EUR  EURO
			SYE->(DBSetOrder(1))       // YE_FILIAL+DTOS(YE_DATA)+YE_MOEDA
			
			IIF(SYE->(DBSeek(xFILIAL('SYE')+DtoS(dDataCotacao+nX)+'EUR')),  SM2->(RecLock("SYE", .F.)), SM2->(RecLock("SYE", .T.)))
			SYE->YE_FILIAL  :=xFILIAL('SYE')
			SYE->YE_DATA    :=dDataCotacao+nX
			SYE->YE_MOEDA   :='EUR'
			SYE->YE_MOE_FIN :=' 5'
			SYE->YE_VLCON_C :=nCotacaoMoeda
			SYE->YE_VLFISCA :=nCotacaoMoeda
			SYE->YE_TX_COMP :=nCotacaoMoeda
			SYE->(MsUnLock())
			//-----------------------------------------------------------------------------------------------------------------------------
		NEXT NX
		
		
	EndIf
EndIf

cQUERY1 := "UPDATE FK5010 SET FK5_TXMOED=FK5_VALOR/FK5_VLMOE2 "
cQUERY1 += "WHERE FK5_VLMOE2<>0  AND FK5_VALOR<>FK5_VLMOE2 AND D_E_L_E_T_<>'*' "
cQUERY1 += "AND FK5_TXMOED=0   AND FK5_VALOR>0 "

cQUERY2 := "UPDATE SE5010 SET E5_TXMOEDA=E5_VALOR/E5_VLMOED2 "
cQUERY2 += "WHERE E5_VLMOED2<>0  AND E5_VALOR<>E5_VLMOED2 AND D_E_L_E_T_<>'*' "
cQUERY2 += "AND E5_TXMOEDA=0   AND E5_VALOR>0 "

TCSQLEXEC(cQUERY1)
TCSQLEXEC(cQUERY2)

*--------------------------------------------------------------------------------------------------------------------------*
RESET ENVIRONMENT
*--------------------------------------------------------------------------------------------------------------------------*
Return


/*
Código da Moeda	Moeda (Operação)
1	Dólar (venda)
10813	Dólar (compra)
21619	Euro (venda)
21620	Euro (compra)
21621	Iene (venda)
21622	Iene (compra)
21623	Libra esterlina (venda)
21624	Libra esterlina (compra)
21625	Franco Suiço (venda)
21626	Franco Suiço (compra)
21627	Coroa Dinamarquesa (venda)
21628	Coroa Dinamarquesa (compra)
21629	Coroa Norueguesa (venda)
21630	Coroa Norueguesa (compra)
21631	Coroa Sueca (venda)
21632	Coroa Sueca (compra)
21633	Dólar Australiano (venda)
21634	Dólar Australiano (compra)
21635	Dólar Canadense (venda)
21636	Dólar Canadense (compra)
