#include "totvs.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VALIDPV  ºAutor  ³Helio Ferreira      º Data ³  19/06/19    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida se um pedido de Vendas pode ou não ser faturado     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ValidPV(cPedido,lMsg)
	Local _lRet    	:= .T.
	Local aAreaSC5 	:= SC5->( GetArea() )
	Local	cRisco
	Local	nLC
	Local	lCondE
	Local	cAdiant
	//Local _cDtaFat 	:= dDataBase

	Local cParaTI		:= "osmar@opusvp.com.br;denis.vieira@rosenbergerdomex.com.br;"      ///"denis.vieira@rdt.com.br;"  // "marco.aurelio@opusvp.com.br;"
	Local cParaVEN		:= "dayse.paschoal@rosenbergerdomex.com.br;"      //"dayse.paschoal@rdt.com.br;"   // Chamado 024389
	Local cParaEXP		:= ""     // "sergio.santos@rdt.com.br;thalita.rufino@rdt.com.br;luiz.pavret@rdt.com.br;"
	Local cParaFIN		:= "juliane.jordao@rdt.com.br;patricia.vieira@rdt.com.br;adriana.souza@rosenbergerdomex.com.br;" 				 // "juliane.jordao@rosenbergerdomex.com.br;"     // "patricia.vieira@rdt.com.br;juliane.jordao@rdt.com.br;adriana.souza@rdt.com.br;carlos.sepinho@rdt.com.br;"
	Local cParaFAT		:= ""     // "priscila.silva@rdt.com.br;juliana.gomes@rdt.com.br;"
	Local cParaCred	    := cParaFIN  + cParaVEN + cParaTI + cParaEXP + cParaFAT


	Default cPedido := ""
	Default lMsg := .T.


	SC5->( dbSetOrder(1) )
	If SC5->( dbSeek( xFilial() + cPedido ) )  .and. SC5->C5_TIPO == "N"    // mauresi - Inclui validacao para somente considerar Pedido do Tipo N

		cRisco  := Posicione("SA1",1,xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI,"A1_RISCO")
		nLC     := Posicione("SA1",1,xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI,"A1_LC")
		lCondE  := Posicione("SE4",1,xFilial("SE4") + SC5->C5_CONDPAG,"E4_XRISCOE")
		cAdiant := Posicione("SE4",1,xFilial("SE4") + SC5->C5_CONDPAG,"E4_CTRADT") // 1=Adiantamento  2=Sem Adiantamento
		cBloq	:= Posicione("SA1",1,xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI,"A1_MSBLQL")  // 1=Bloqueado  2=Ativo

		//#################################
		If cBloq == "1"   //MAURESI  25/03/2021   Testa Cliente Bloqueado

			// Envia WorkFlow
			cNomeCli := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NREDUZ")
			cAssunto := "Analise de Credito - CLIENTE BLOQUEADO - OF: " +SC5->C5_NUM+ " - " +  cNomeCli
			cTexto 	 := "Cliente BLOQUEADO no cadastro para a OF "+SC5->C5_NUM+ " - " +  cNomeCli+ " / " +SC5->C5_CLIENTE+"-"+SC5->C5_LOJACLI+ Chr(13)+ Chr(13)
			cTexto   := StrTran(cTexto,Chr(13),"<br>")

			cPara    := cParaCred //+ UsrRetMail(SC5->C5_USER)
			cCC      := ""
			cArquivo := ""
			If lMsg
				U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
			Endif
			//³Envia Mensagem Coletor
			cTexto := "Cliente BLOQUEADO no cadastro." + Chr(13)+ Chr(13)
			cTexto += "Enviado email para:" + Alltrim(cParaFIN) + Chr(13)

			If "COLETOR" $ Funname()
				U_MsgColetor(cTexto)
			Else
				If lMsg
					apMsgAlert(cTexto)
				EndIf
			EndIf

			_lRet:=.F.
			Return _lRet

		EndIf


		//##############################
		If cRisco <> "A"
			//	U_MsgColetor("MAS-Risco <> A  " )

			If cRisco <> "E"    // Analisa apenas o saldo CR x Limite de Crédito
				//		U_MsgColetor("MAS-Risco <> E  " )

				// VALOR DOS TITULOS EM ABERTO DO CLIENTE
				cQuery1 := "SELECT SUM(E1_SALDO) AS E1SALDO FROM "+RetSqlName("SE1")+" WHERE E1_CLIENTE = '"+SC5->C5_CLIENTE+"' AND E1_LOJA = '"+SC5->C5_LOJACLI+"' "
				cQuery1 += "AND E1_TIPO = 'NF'
				cQuery1 += "AND E1_SALDO <> 0
				cQuery1 += "AND D_E_L_E_T_ = ''"

				If Select("QSE1") <> 0
					QSE1->( dbCloseArea() )
				EndIf

				TCQUERY cQuery1 NEW ALIAS "QSE1"
				nValorE1 := QSE1->E1SALDO

				QSE1->( dbCloseArea() )

				// VALOR DO PEDIDO QUE ESTÁ SENDO FATURADO SEM A PREVISÃO DE FATURAMENTO
				//cQuery2 := "SELECT * FROM "+RetSqlName("SZY")+" WHERE ZY_PEDIDO = '"+SC5->C5_NUM+"' AND ZY_PRVFAT = '"+DtoS(_cDtaFat)+"' AND ZY_NOTA = '' AND D_E_L_E_T_ = '' ORDER BY ZY_PEDIDO, ZY_ITEM, ZY_SEQ "
				cQuery2 := "SELECT * FROM "+RetSqlName("SZY")+" WHERE ZY_PEDIDO = '"+SC5->C5_NUM+"' AND ZY_NOTA = '' AND D_E_L_E_T_ = '' ORDER BY ZY_PEDIDO, ZY_ITEM, ZY_SEQ "

				If Select("QUERYSZY") <> 0
					QUERYSZY->( dbCloseArea() )
				EndIf

				TCQUERY cQuery2 NEW ALIAS "QUERYSZY"


				_lTemDupl := .F.   // Verifica de alguma TES da OF gera Duplicata - 21/10/2020
				nValorPVFat := 0
				SC6->( dbSetOrder(1) )
				While !QUERYSZY->( EOF() )
					If SC6->( dbSeek( xFilial() + QUERYSZY->ZY_PEDIDO + QUERYSZY->ZY_ITEM ) )
						If SC6->C6_PRODUTO == QUERYSZY->ZY_PRODUTO

							// Considera Somente Itens que Geram Duplicata - mauresi - 29/07/2019
							if Posicione("SF4",1,xFilial("SF4")+SC6->C6_TES,"F4_DUPLIC") == "S"
								_lTemDupl := .T.
								If QUERYSZY->ZY_QUANT <= (SC6->C6_QTDVEN - SC6->C6_QTDENT)
									nValorPVFat     += (QUERYSZY->ZY_QUANT * SC6->C6_PRCVEN)
								EndIf

							Endif
						EndIf

					EndIf
					QUERYSZY->( dbSkip() )
				End

				QUERYSZY->( dbCloseArea() )

				If (nValorPVFat + nValorE1) > nLC     .AND.   _lTemDupl   //MAURESI  21/10/2020   adicionado _lTemDupl

					// Envia WorkFlow
					cNomeCli := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NREDUZ")
					cAssunto := "Analise de Credito - LIMITE Insuficiente - OF: " +SC5->C5_NUM+ " - " +  cNomeCli
					cTexto 	:= "Limite de Crédito insuficiente para a OF "+SC5->C5_NUM+ Chr(13)
					cTexto 	+= "Cliente: " +  cNomeCli+ " / " +SC5->C5_CLIENTE+"-"+SC5->C5_LOJACLI + "  -  Risco "+cRisco+ Chr(13)+ Chr(13)
					cTexto 	+= "Valor do Pedido: " + Alltrim(Transform(nValorPVFat,"@E 999,999,999.99")) + Chr(13)
					cTexto 	+= "Saldo de Títulos a Receber: " + Alltrim(Transform(nValorE1,"@E 999,999,999.99")) + Chr(13)
					cTexto 	+= "Pedido + Títulos: " + Alltrim(Transform((nValorPVFat + nValorE1),"@E 999,999,999.99")) + Chr(13)
					cTexto 	+= "Limite de Crédito: " + Alltrim(Transform(nLC,"@E 999,999,999.99")) + Chr(13) + Chr(13)
					//cTexto   := StrTran(cTexto,Chr(13),"<br>")

					cPara    := cParaCred //+ UsrRetMail(SC5->C5_USER)
					cCC      := ""
					cArquivo := ""
					If lMsg
						cTexto   := StrTran(cTexto,Chr(13),"<br>")
						U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
					Endif
					//³Envia Mensagem Coletor
					//cTexto := "Limite de Crédito insuficiente." + Chr(13)+ Chr(13)
					//cTexto += "Enviado email com valores para:" + Alltrim(cParaFIN) + Chr(13) + Chr(13)
					cTexto += "Este pedido será bloqueado para Faturamento e Abertura de OP" + Chr(13)

					If "COLETOR" $ Funname()
						U_MsgColetor(cTexto)
					Else
						If lMsg
							apMsgAlert(cTexto)
						EndIf
					EndIf

					_lRet:=.F.
					Return _lRet

				EndIf
			Else

				// RISCO E
				// VALOR DO PEDIDO SEM DATA DE PREVISÃO DE FATURAMENTO
				//cQuery3 := "SELECT * FROM "+RetSqlName("SZY")+" WHERE ZY_PEDIDO = '"+SC5->C5_NUM+"' AND ZY_PRVFAT = '"+DtoS(_cDtaFat)+"' AND ZY_NOTA = '' AND D_E_L_E_T_ = '' ORDER BY ZY_PEDIDO, ZY_ITEM, ZY_SEQ "
				cQuery3 := "SELECT * FROM "+RetSqlName("SZY")+" WHERE ZY_PEDIDO = '"+SC5->C5_NUM+"' AND ZY_NOTA = '' AND D_E_L_E_T_ = '' ORDER BY ZY_PEDIDO, ZY_ITEM, ZY_SEQ "

				If Select("QUERYSZY") <> 0
					QUERYSZY->( dbCloseArea() )
				EndIf

				TCQUERY cQuery3 NEW ALIAS "QUERYSZY"

				_lTemDupl := .F.   // Verifica de alguma TES da OF gera Duplicata - 11/11/2020
				nValorPVFat := 0
				SC6->( dbSetOrder(1) )
				While !QUERYSZY->( EOF() )
					If SC6->( dbSeek( xFilial() + QUERYSZY->ZY_PEDIDO + QUERYSZY->ZY_ITEM ) )
						If SC6->C6_PRODUTO == QUERYSZY->ZY_PRODUTO

							// Considera Somente Itens que Geram Duplicata - mauresi - 29/07/2019
							if Posicione("SF4",1,xFilial("SF4")+SC6->C6_TES,"F4_DUPLIC") == "S"
								_lTemDupl := .T.		// mauresi - 11/11/2020
								If QUERYSZY->ZY_QUANT <= (SC6->C6_QTDVEN - SC6->C6_QTDENT)
									nValorPVFat     += (QUERYSZY->ZY_QUANT * SC6->C6_PRCVEN)
								EndIf
							Endif
						EndIf
					EndIf
					QUERYSZY->( dbSkip() )
				End

				QUERYSZY->( dbCloseArea() )

				// ADIANTAMENTOS
				nAdiant := 0
				If  cAdiant $ "1"

					cQuery4 := "SELECT ISNULL(SUM(FIE_SALDO),0) AS FIESALDO FROM FIE010 WHERE FIE_PEDIDO = '"+SC5->C5_NUM+"' AND D_E_L_E_T_ = ''"
					If Select("QFIE") <> 0
						QFIE->( dbCloseArea() )
					EndIf

					TCQUERY cQuery4 NEW ALIAS "QFIE"

					nAdiant := QFIE->FIESALDO
					QFIE->( dbCloseArea() )
				EndIf

				// CARTÃO CREDITO
				nVlrCartao := 0
				If !Empty(SC5->C5_XAUTCC)
					If SC5->( FieldPos("C5_XVLRAUT") ) <> 0
						nVlrCartao := SC5->C5_XVLRAUT
					Else
						nVlrCartao := nValorPVFat
					EndIf
				EndIf


				if    _lTemDupl   //MAURESI  11/1/2020   adicionado _lTemDupl
					//_____________________________________
					//³Verifica Adiantamento Internacional³
					//_____________________________________
					_lAdtIntl := iif(SC5->C5_CONDPAG $  GetMV("MV_XADTINT")  ,.T.,.F.)  //Condiçao de Adiantamento Internacional
					if _lAdtIntl
						// Se for ADT Internacional, não executa Validacoes

						cNomeCli := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NREDUZ")
						cAssunto := "Analise de Credito - ADIANTAMENTO INTERNACIONAL - OF: " +SC5->C5_NUM+ " - " +  cNomeCli
						cTexto := " ## ATENCAO ##  " + Chr(13)+ Chr(13)
						cTexto += " Condição de Pagamento de Adiantamento INTERNACIONAL utilizada na OF "+SC5->C5_NUM+ " - " +  cNomeCli+ " / " +SC5->C5_CLIENTE+"-"+SC5->C5_LOJACLI+ Chr(13)+ Chr(13)
						cTexto += " * Em função de Diferenças Cambiais, esta Condição não avalia se os valores Adiantados estão corretos."+ Chr(13)
						cTexto   := StrTran(cTexto,Chr(13),"<br>")
						cPara    := cParaFIN + cParaFAT + cParaTI // +UsrRetMail(SC5->C5_USER)
						cCC      := ""
						cArquivo := ""
						If lMsg
							U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
						EndIf
					Else

						// TESTE FINAL
						If nValorPVFat >  (nAdiant + nVlrCartao)
							//³Envia WorkFlow
							cNomeCli := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NREDUZ")
							cAssunto := "Analise de Credito - ADIANTAMENTO Insuficiente - OF: " +SC5->C5_NUM+ " - " +  cNomeCli+ " / " +SC5->C5_CLIENTE+"-"+SC5->C5_LOJACLI+ Chr(13)+ Chr(13)
							cTexto 	:= " Adiantamento insuficiente para Faturamento da OF "+SC5->C5_NUM+Chr(13)
							cTexto 	+= " Cliente: " + cNomeCli+ "  -  Risco " +cRisco + Chr(13)+ Chr(13)
							cTexto 	+= " Valor do Pedido: " + Alltrim(Transform(nValorPVFat,"@E 999,999,999.99")) + Chr(13)
							cTexto 	+= " Adiantamentos (RA): " + Alltrim(Transform(nAdiant,"@E 999,999,999.99"))+ Chr(13)
							cTexto 	+= " Autorização Cartão Crédito: " + Alltrim(Transform(nVlrCartao,"@E 999,999,999.99"))+ Chr(13)
							cTexto 	+= " RA + Cartão Crédito: " + Alltrim(Transform((nAdiant+nVlrCartao),"@E 999,999,999.99")) + Chr(13) + Chr(13)
							//cTexto   := StrTran(cTexto,Chr(13),"<br>")

							cPara    := cParaCred //+ UsrRetMail(SC5->C5_USER)
							cCC      := ""
							cArquivo := ""
							If lMsg
								cTexto   := StrTran(cTexto,Chr(13),"<br>")
								U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
							EndIf
							//³Envia Mensagem Coletor
							//cTexto := "Adiantamento insuficiente para Faturamento. "  + Chr(13) + Chr(13)
							//cTexto += "Enviado email com valores para:" + Alltrim(cParaFIN) + Chr(13) + Chr(13)
							cTexto += "Este pedido será bloqueado para Faturamento e Abertura de OP" + Chr(13)

							If "COLETOR" $ Funname()
								U_MsgColetor(cTexto)
							Else
								If lMsg
									apMsgAlert(cTexto)
								Endif
							EndIf

							_lRet:=.F.

							Return _lRet
						Else
							// Adiantamento OK

						EndIf

					Endif
				Endif //  fim do _lTemDupl

			EndIf

		EndIf
	Endif

	RestArea(aAreaSC5)

Return _lRet
