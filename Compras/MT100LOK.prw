//------------------------------------------------------------------------------------------------------------------------------------------------//
//Wederson L. Santana - 10/09/12                                                                                                                  //
//Especifico Domex    - Baixa dos pedidos de compras.                                                                                             //
//------------------------------------------------------------------------------------------------------------------------------------------------//
//Ponto de entrada na inclusão da NFE.                                                                                                            //
//Informa o lote específico 1308 para quando for realizada uma baixa de PC.                                                                       //
//------------------------------------------------------------------------------------------------------------------------------------------------//

User Function MT100LOK()
	Local _nPCod    := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_COD"})
	Local _nPTes    := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_TES"})
	Local _nPPc     := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_PEDIDO"})
	Local _nPItem   := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_ITEMPC"})
	Local _nPLote   := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_LOTECTL"})
	Local _nPOP     := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_OP"})
	Local _nPLocal  := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_LOCAL"})
	Local _nPCCust	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_CC"})
	Local _nPquant	:= ascan(aHeader,{|x| AllTrim(x[2]) == "D1_QUANT"})
	Local _nPNFOri  := ascan(aHeader,{|x| Alltrim(x[2]) == "D1_NFORI" } )

	Local _nDel     := Len(aHeader)+1//pegar a coluna de marcacao de exclusao
	Local _lRet     := .T.
	Local _aAreaGER := GetArea()
	Local _aAreaSD4 := SD4->( GetArea() )
	Local _cTES		 := ""

	If Type("nFlagMsg") == 'U'
		Public nFlagMsg := .T.
	EndIf

	If !(aCols[n][_nDel])

		If CA100FOR == '004500' .and. CLOJA == '01' .and. aCols[n][_nPLocal] != '01'
			MsgStop("Para Documentos de Entrada com origem na filial 02 o armazem deve ser 01.")
			_lRet := .F.
		EndIf

		If CA100FOR == '900000' .and. fwFilial()=='01'

		EndIf

		If Rastro(aCols[n][_nPCod])
			SC7->(dbSetOrder(1))
			If SC7->(dbSeek(xFilial("SC7")+Trim(aCols[n][_nPPc])+Trim(aCols[n][_nPItem])))
				SF4->(dbSetOrder(1))
				If SF4->(dbSeek(xFilial("SF4")+Trim(aCols[n][_nPTes])))
					If Trim(SF4->F4_ESTOQUE)$ "S"
						aCols[n][_nPLote]:="LOTE1308"
					EndIf
				EndIf
			Endif
		Endif
	Endif


	If _lRet
		//If Subs(acols[N,_nPCod],1,6) == '500960'
		//	If Empty(acols[N,_nPOP])
		//	   If nFlagMsg
		//		   MsgStop("Para Documentos de Entrada de serviços de Silk, favor informar uma Ordem de Produção.")
		//		   nFlagMsg := .F.
		//		EndIf
		//	EndIf
		//EndIf

		If !(aCols[n][_nDel])
			If U_VALIDACAO("OSMAR")
				SF4->( dbSetOrder(1) )
				SF4->( dbSeek( xFilial() + aCols[N,_nPTes] ) )
				If SF4->F4_XBENEFI == "S"
					If Empty(aCols[N,_nPNFOri])
						MsgStop("Para Documentos de Entrada de Beneficiamento, favor informar a Nota Fiscal Original.")
						_lRet := .F.
					EndIf
				EndIf
			EndIf
		EndIf

		If Empty(acols[N,_nPOP])
			If SF4->( Fieldpos("F4_XOPBENE") ) > 0
				SF4->( dbSetOrder(1) )
				If SF4->( dbSeek( xFilial() + aCols[N,_nPTes] ) )
					If SF4->F4_XOPBENE == 'S'
						MsgStop("Para Documentos de Entrada de serviços e retorno de Silk, favor informar a Ordem de Produção.")
						_lRet := .F.
					EndIf
				EndIf
			Else
				If aCols[N,_nPTes] == '082' .or. aCols[N,_nPTes] == '116'
					If CA100FOR == '000626' .or. CA100FOR == '000391'
						MsgStop("Para Documentos de Entrada de serviços e retorno de Silk, favor informar a Ordem de Produção.")
						_lRet := .F.
					EndIf
				EndIf
			EndIf
		Else
			SD4->( dbSetOrder(2) )
			_cVarOP := aCols[N,_nPOP] + Space(13-Len(aCols[N,_nPOP]))
			If SD4->( dbSeek( xFilial() + _cVarOP + aCols[N,_nPCod] ) )
				If aCols[N,_nPLocal] <> SD4->D4_LOCAL
					MsgStop("Não é permitido informar um Número de OP e informar o Almoxarifado diferente do Empenho ("+SD4->D4_LOCAL+").")
					_lRet := .F.
				Else
					If aCols[N,_nPquant] > SD4->D4_QUANT
						MsgStop("Quantidade superior ao saldo de empenho ("+Alltrim(Transform(SD4->D4_QUANT,"@E 999,999,999.9999"))+") deste produto ("+Alltrim(SD4->D4_COD)+") para esta Ordem de Produção ("+Alltrim(aCols[N,_nPOP])+")") //mauricio 10/10/2016 retirado strtran substituido transform
						_lRet := .F.
					EndIf
				EndIf
			Else
				MsgStop("Empenho do produto " + Alltrim(aCols[N,_nPCod]) + " não encontrado para a OP " + Alltrim(aCols[N,_nPOP]) + ".")
				_lRet := .F.
			EndIf
		EndIf
	EndIf

//------------------------------------------------------------------------------------------------
//³Valida se o CC foi preenchido para as TES que estao configuradas com F4_XCCUSTO=SIM³
//³Marco Aurelio - OpusVP - 23/07/14  - Solicitado pelo Luciano                                  ³
//------------------------------------------------------------------------------------------------

	If GetMV("MV_XXCCUST")		// Parametro Logico para Habilitar/Desabilitar Validação

		SF4->(dbSetOrder(1))
		If SF4->(dbSeek(xFilial("SF4")+Trim(aCols[n][_nPTes])))
			If AllTrim(SF4->F4_XCCUSTO)$ "S"// Trocar para Campo de F4_XCC
				if Empty(aCols[n][_nPCCust])
					MsgStop("Para esta TES é necessário preencher o CENTRO DE CUSTO !")
					_lRet := .F.
				EndIf
			Else
				// Limpa Centro de Custo
				aCols[n][_nPCCust]	:= space(09)
			EndIf
		EndIf

	Endif


//------------------------------------------------------------------------------------------------

	RestArea(_aAreaSD4)
	RestArea(_aAreaGER)

Return(_lRet)
