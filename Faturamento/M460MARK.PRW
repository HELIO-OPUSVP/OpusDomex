#include "totvs.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M460MARK  �Autor  �Helio Ferreira      � Data �  19/06/19   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada                                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Domex                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
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



If paramixb[2] // Marca��o invertida ou n�o
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
		If !MsgYesNo("N�o existe previs�o de Vendas do Pedido: "+SC9->C9_PEDIDO+" Item: "+SC9->C9_ITEM+" para a data de hoje: "+DtoC(Date())+"."+Chr(10)+"Deseja prosseguir com o faturamento deste item?")
			_Retorno := .F.
			
			cAssunto  := "Pedido "+""+" item " +""+ " faturado com diverg�ncia da Previs�o de Faturamento"
			cTexto    := "O Pedido de Vendas " +""+ " foi faturado sem que houvesse Previs�o de Faturamento para o mesmo. "
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
			If !MsgYeNo("Erro na previs�o de Vendas. Existem duas previs�es com a mesma data para o Pedido: "+SC9->C9_PEDIDO+" Item: "+SC9->C9_ITEM+"."+Chr(10)+"Deseja prosseguir com o faturamento deste item?")
				_Retorno := .F.
			EndIf
		Else
			If SC9->C9_QTDLIB <> QUERYSZY->ZY_QUANT - QUERYSZY->ZY_QUJE
				If !MsgYeNo("Existe diverg�ncia entre a quantidade da Previs�o de Vendas e a quantidade a ser faturada do Pedido: "+SC9->C9_PEDIDO+" Item: "+SC9->C9_ITEM+"."+Chr(10)+"Deseja prosseguir com o faturamento deste item?")
					_Retorno := .F.
				EndIf
			EndIf
		EndIf
	EndIf

	
	//validacao novo calculo imposto
	If U_VALIDACAO('JONAS') 
		U_FVALICMPI(SC9->C9_CLIENTE, SC9->C9_LOJA, SC9->C9_PEDIDO,.T.) //CLIENTE + LOJA + PROCESSAMENTO ANTES DA NF
	EndIf

	
Return


	// Jonas Validacao nova filial MG
	If (SC9->C9_CLIENTE == '700000' .AND. SC9->C9_LOJA == '01' .AND.  SC9->C9_LOCAL == '95' .AND. fwfilial() == "01") .OR. (SC9->C9_CLIENTE == '001078' .AND. SC9->C9_LOJA == '01' .AND.  SC9->C9_LOCAL == '95' .AND. fwfilial() == "02") 
		_Retorno := U_fvalXD1(SC9->C9_PRODUTO, SC9->C9_LOCAL, SC9->C9_QTDLIB)
	EndIf

EndIf

If _Retorno .and. lMarcado
	If SuperGetMV("MV_XANACRE")    // Par�metro geral de liga/desliga an�lise de Cr�dito Domex
		_Retorno := U_ValidFat(SC5->C5_NUM)
	EndIf
EndIf

If _Retorno
	//MsgInfo("Retornando .F. for�ado. Voltar...")
EndIf

RestArea(aSaveArea)
Return _Retorno // .F. // _Retorno
