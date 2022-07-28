#include "rwmake.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M410LIOK()�Autor  �Helio Ferreira      � Data �  07/24/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o da Linha de Pedidos de Venda                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Domex                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function M410LIOK() 
	Local _Retorno
	Local aAreaGER
	Local aAreaSC2
	Local aAreaSB1
	Local nPC6_ITEM
	Local nPC6_PRODUTO
	Local nPC6_XXOP
	Local nPC6_TES
	Local nPC6_LOCAL
	Local cTimeIni	
	Local cPC6_XGERAOP
	//Local nMargem  := GetMV("MV_XMARGEM")  //Percentual m�nimo aceito como margem de lucro

	cTimeIni := Time()

	_Retorno  := .T.
	aAreaGER  := GetArea()
	aAreaSC2  := SC2->( GetArea() )
	aAreaSB1  := SB1->( GetArea() )
	aAreaSF4  := SF4->( GetArea() )
	aAreaSD4  := SD4->( GetArea() )
	aAreaSA1  := SA1->( GetArea() )

	//If U_Validacao("OSMAR")
	//	SA1->(dbSetOrder(01))
	//	SA1->( dbSeek(xFilial()+M->C5_CLIENTE+M->C5_LOJACLI) )
	//	If SA1->A1_XMARGEM > 0
	//		nMargem := SA1->A1_XMARGEM
	//	Else
	//		nMargem := GetMV("MV_XMARGEM")
	//	Endif
	//EndIf

	nPC6_ITEM    := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_ITEM"    } )
	nPC6_PRODUTO := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_PRODUTO" } )
	nPC6_XXOP    := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_XXOP"    } )
	nPC6_TES     := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_TES"     } )
	nPC6_LOCAL   := aScan( aHeader, { |aVet| AllTrim(aVet[2]) == "C6_LOCAL"   } )
	nPC6_PRCVEN  := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_PRCVEN"  } )
	nPC6_MARGEM  := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_XMARGEM" } )
	cPC6_XGERAOP := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_XGERAOP" } )

	If _Retorno
		If !aCols[n,Len(aHeader)+1]

			If U_VALIDACAO("OSMAR")      //In�cio da valida��o de remessa para beneficiamento
				SF4->( dbSetOrder(1) )
				If SF4->( dbSeek( xFilial() + aCols[N,nPC6_TES] ) )
					If SF4->F4_XOPBENE == 'S'
						If Empty(aCols[N,nPC6_XXOP])
							MsgStop("Pedido de remessa para beneficiamento. Favor informar o Numero da Ordem de Produ��o no campo OP Beneficia.")
							_Retorno := .F.
						Else
							SC2->( dbSetOrder(1) )
							If SC2->(dbSeek(xFilial()+aCols[N,nPC6_XXOP]))
								If !Empty(SC2->C2_DATRF)
									MsgStop("A Ordem de Produ��o "+aCols[N,nPC6_XXOP]+" esta Encerrada!!! ")
									_Retorno := .F.
								EndIf
								//Verificar se ha empenho
								SD4->( dbSetOrder(2) )
								If !SD4->( dbSeek( xFilial() + Subs(aCols[N,nPC6_XXOP],1,11) + "  " + aCols[N,nPC6_PRODUTO] ) )
									MsgStop("N�o foi encontrado empenho deste produto para esta OP!!!")
									_Retorno := .F.
								EndIf
							Else
								MsgStop("Ordem de Produ��o "+aCols[N,nPC6_XXOP]+" n�o cadastrada!!! ")
								_Retorno := .F.
							EndIf
						EndIf
					EndIf
				EndIf
			Else
				//If SF4->( Fieldpos("F4_XOPBENE")) > 0 .and. U_VALIDACAO("OSMAR")  // H�lio Ferreira 10/11/21
				//	SF4->( dbSetOrder(1) )
				//	//If SF4->( dbSeek( xFilial() + aCols[N,_nPTes] ) )
				//	If SF4->( dbSeek( xFilial() + aCols[N,nPC6_TES] ) )
				//		If SF4->F4_XOPBENE == 'S'
				//			If Empty(aCols[N,nPC6_XXOP])
				//				MsgStop("Pedido de remessa para beneficiamento. Favor informar o Numero da Ordem de Produ��o no campo OP Beneficia.")
				//				_Retorno := .F.
				//			EndIf
				//		EndIf
				//	EndIf
				//Else
				//	If acols[N,nPC6_TES] == '903'
				//		If Empty(aCols[N,nPC6_XXOP])

				//			MsgStop("Pedido de remessa para beneficiamento. Favor informar o Numero da Ordem de Produ��o no campo OP Beneficia.")

				//			If Date() <= StoD("20130731")
				//				MsgStop("At� a data de 31/07/13 o sistema aceitar� envios para beneficiamento sem OP. Posteriormente n�o ser� poss�vel.")
				//			Else
				//				If Date() >= StoD("20130810")
				//					_Retorno := .F.
				//				EndIf
				//			EndIf
				//		Else
				//			SC2->(  dbSetOrder(1) )
				//			// Testar se a OP est� correta

				//		EndIf
				//	EndIf
				//EndIf
			EndIf  //Fim da valida��o de remessa para beneficiamento

		EndIf
	EndIf

// Validando se est�o excluindo o produto para depois incluir com outra data de OTD

// Valida��o abortada.

/*
	If _Retorno
		If aCols[n,Len(aHeader)+1]
			If !MsgYesNo("A partir de 27/02/14 n�o ser� poss�vel apagar o Produto de uma OF e incluir o mesmo Porduto como outro �tem. Deseja realmente apagar este item?")
_Retorno := .F.
			EndIf
		EndIf
	EndIf

	If _Retorno
		For _nx := 1 to Len(aCols)
			If _nx <> N
				If aCols[_nx,nPC6_PRODUTO] == aCols[N,nPC6_PRODUTO]
MsgStop("Produto j� utilizado no Item " + aCols[_nx,1]+". A partir de 27/02/14 n�o ser� permitida a digita��o de mesmo produto duas vezes na mesma OS.")
_Retorno := .F.
				EndIf
			EndIf
		Next _nx
	EndIf

	If _Retorno
cQuery := "SELECT C6_ITEM FROM " + RetSqlName("SC6") + " WHERE C6_FILIAL = '"+xFilial("SC6")+"' AND C6_NUM = '"+M->C5_NUM+"' AND C6_PRODUTO = '"+aCols[N,nPC6_PRODUTO]+"' AND D_E_L_E_T_ = '*' "

		If Select("QUERYSC6") <> 0
QUERYSC6->( dbCloseArea() )
		EndIf

TCQUERY cQuery NEW ALIAS "QUERYSC6"

		If !Empty(QUERYSC6->C6_ITEM)
MsgStop("Produto j� utilizado e apagado como no Item " + QUERYSC6->C6_ITEM+". A partir de 27/02/14 n�o ser� permitida a utiliza��o do mesmo Produto como dois itens diferentes na mesma OF.")
_Retorno := .F.
		EndIf
	EndIf
*/

// Foi definido que n�o ser� poss�vel apagar um item do Pedido se o mesmo j� estiver amarrado a uma OP.
	If _Retorno
		If aCols[n,Len(aHeader)+1]
			SC2->(DbOrderNickName("USUSC20001"))  // C2_FILIAL + C2_PEDIDO + C2_ITEMPV
			If SC2->( dbSeek( xFilial() + M->C5_NUM + aCols[N,nPC6_ITEM] ) )
				MsgStop("N�o ser� poss�vel excluir este item. A Ordem de Produ��o " + Subs(SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN,1,11) + " j� foi gerada para o mesmo.")
				_Retorno := .F.
			EndIf
		EndIf
	EndIf

//Wederson - OpusVp - 19/11/2014 - Solicitado pelo Denis bloqueio do almoxarifado , quando beneficiamento.
	If _Retorno
		If !AllTrim(aCols[n,nPC6_LOCAL])$ "03/13"
			If AllTrim(M->C5_TIPO) == "B"
				MsgInfo("Para opera��o do tipo 'Beneficiamento"+Chr(13)+"utilize o almoxarifado 03 ou 13.","A T E N � � O")
				_Retorno:=.F.
			EndIf
		EndIf
	EndIf

//Osmar Ferreira - OpusVP - 04/06/2020 - Informa Margem fora do range
	//If _Retorno
	//	If M->C5_TIPO == "N"
	//		If aCols[n,nPC6_MARGEM] > 0 .And. aCols[n,nPC6_MARGEM] < nMargem
	//			MsgInfo("A Margem de Contribui��o deste item esta em "+Alltrim(Str(aCols[n,nPC6_MARGEM]))+"%"+Chr(13)+"e esta abaixo de "+AllTrim(Str(nMargem))+"% ","A T E N � � O")
	//			_Retorno := .T.
	//		EndIf
	//	EndIf
	//EndIf

//Osmar Ferreira - OpusVP - 24/09/2020 - Para n�o abrir OP de produto revenda pela op��o (bot�o de venda)
	If _Retorno
		SB1->( dbSetOrder(1) )
		SB1->( dbSeek(xFilial()+aCols[N,nPC6_PRODUTO]))
		If SB1->B1_TIPO == 'PR' .And. aCols[N,cPC6_XGERAOP] <> '2'
			aCols[N,cPC6_XGERAOP] := '2'
		EndIf
	EndIf

/*
	If _Retorno
	dbSelectArea("DA1")
	dbSetOrder(1)
		If !Empty(M->C5_TABELA)
			If dbSeek(xFilial() + M->C5_TABELA + aCols[n,nPC6_PRODUTO])
				If DA1->DA1_PRCVEN <> aCols[n,nPC6_PRCVEN]
   		     MsgInfo("Pre�o do pedido esta diferente do pre�o de Tabela de Pre�os!!","A T E N � � O")
        	 _Retorno := .t.
				EndIf
			Else
     		MsgInfo("O Produto "+aCols[n,nPC6_PRODUTO]+Chr(13)+ "n�o esta cadastro na Tabela de Pre�o "+M->C5_TABELA+" ","A T E N � � O")
     		_Retorno := .t.
			EndIf
		EndIf
	EndIf
*/
	RestArea(aAreaSA1)
	RestArea(aAreaSD4)
	RestArea(aAreaSF4)
	RestArea(aAreaSB1)
	RestArea(aAreaSC2)
	RestArea(aAreaGER)
//Alert("Inicio: " + cTimeIni + " Fim " + Time())
Return _Retorno
