#include "totvs.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460MARK  ºAutor  ³Helio Ferreira      º Data ³  19/06/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada                                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//FILIALMG

//If ( ExistTemplate("M460MARK") )
//	lExecuta := ExecTemplate("M460MARK",.F.,.F.,{ThisMark(),ThisInv()})
//EndIf

User Function M460MARK()
Local aSaveArea	:= GetArea()
Local _Retorno := .T.
Local nReg     := 0
Local lMarcado := .F.



If paramixb[2] // Marcação invertida ou não
	If paramixb[1] == SC9->C9_OK
		lMarcado := .F.
	Else
		lMarcado := .T.
	EndIf
Else
	If paramixb[1] == SC9->C9_OK
		lMarcado := .T.
	Else
		lMarcado := .F.
	EndIf
EndIf

If lMarcado
	cQuery := "SELECT * FROM " + RetSqlName("SZY") + " WHERE ZY_FILIAL = '"+xFilial("SZY")+"' AND ZY_PEDIDO = '"+SC9->C9_PEDIDO+"' AND "
	cQuery += "ZY_ITEM = '"+SC9->C9_ITEM+"' AND ZY_PRVFAT = '"+DtoS(Date())+"' AND ZY_NOTA = '' AND D_E_L_E_T_ = '' "
	
	If Select("QUERYSZY") <> 0
		QUERYSZY->( dbCloseArea() )
	EndIf
	
	TCQUERY cQuery NEW ALIAS "QUERYSZY"
	
	If QUERYSZY->( EOF() )
		If !MsgYesNo("Não existe previsão de Vendas do Pedido: "+SC9->C9_PEDIDO+" Item: "+SC9->C9_ITEM+" para a data de hoje: "+DtoC(Date())+"."+Chr(10)+"Deseja prosseguir com o faturamento deste item?")
			_Retorno := .F.
			
			cAssunto  := "Pedido "+""+" item " +""+ " faturado com divergência da Previsão de Faturamento"
			cTexto    := "O Pedido de Vendas " +""+ " foi faturado sem que houvesse Previsão de Faturamento para o mesmo. "
			cPara     := "denis.vieira@rdt.com.br;helio@opusvp.com.br;" //"marco.aurelio@opusvp.com.br"
			cCC       := ""
			cArquivo  := ""
			
			U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
			
		Else
			
			
		EndIf
	Else
		While !QUERYSZY->( EOF() )
			nReg++
			QUERYSZY->( dbSkip() )
		End
		QUERYSZY->( dbGotop() )
		If nReg > 1
			If !MsgYeNo("Erro na previsão de Vendas. Existem duas previsões com a mesma data para o Pedido: "+SC9->C9_PEDIDO+" Item: "+SC9->C9_ITEM+"."+Chr(10)+"Deseja prosseguir com o faturamento deste item?")
				_Retorno := .F.
			EndIf
		Else
			If SC9->C9_QTDLIB <> QUERYSZY->ZY_QUANT - QUERYSZY->ZY_QUJE
				If !MsgYeNo("Existe divergência entre a quantidade da Previsão de Vendas e a quantidade a ser faturada do Pedido: "+SC9->C9_PEDIDO+" Item: "+SC9->C9_ITEM+"."+Chr(10)+"Deseja prosseguir com o faturamento deste item?")
					_Retorno := .F.
				EndIf
			EndIf
		EndIf
	EndIf


	// Jonas Validacao nova filial MG
	If (SC9->C9_CLIENTE == '700000' .AND. SC9->C9_LOJA == '01' .AND.  SC9->C9_LOCAL == '95' .AND. fwfilial() == "01") .OR. (SC9->C9_CLIENTE == '001078' .AND. SC9->C9_LOJA == '01' .AND.  SC9->C9_LOCAL == '95' .AND. fwfilial() == "02") 
		_Retorno := U_fvalXD1(SC9->C9_PRODUTO, SC9->C9_LOCAL, SC9->C9_QTDLIB)
	EndIf

EndIf

If _Retorno .and. lMarcado
	If SuperGetMV("MV_XANACRE")    // Parâmetro geral de liga/desliga análise de Crédito Domex
		_Retorno := U_ValidFat(SC5->C5_NUM)
	EndIf
EndIf

If _Retorno
	//MsgInfo("Retornando .F. forçado. Voltar...")
EndIf

RestArea(aSaveArea)
Return _Retorno // .F. // _Retorno
