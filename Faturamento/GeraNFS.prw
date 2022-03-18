#include "topconn.ch"
#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO40    ºAutor  ³Helio Ferreira      º Data ³  01/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função de Geração de NFS, para ser usada pelo coletor      º±±
±±º          ³ de dados                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GeraNFS(cNumPV, cSerie, dData, lHuawei)

	Local _Retorno := ''

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Seleciona o pedido para faturamento                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQueryTMPNFS := "SELECT * FROM "+RetSqlName("SZY")+" WHERE ZY_PEDIDO = '"+cNumPV+"' AND ZY_PRVFAT = '"+DtoS(dData)+"' AND ZY_NOTA = '' AND D_E_L_E_T_ = '' ORDER BY ZY_PEDIDO, ZY_ITEM, ZY_SEQ "
	If Select("QUERYSZY") <> 0
		QUERYSZY->( dbCloseArea() )
	EndIf

	TCQUERY cQueryTMPNFS NEW ALIAS "QUERYSZY"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Libera o Pedido					                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SC6->( dbSetOrder(1) )
	While !QUERYSZY->( EOF() )
		If SC6->( dbSeek( xFilial() + QUERYSZY->ZY_PEDIDO + QUERYSZY->ZY_ITEM ) )
			If SC6->C6_PRODUTO == QUERYSZY->ZY_PRODUTO
				If QUERYSZY->ZY_QUANT <= (SC6->C6_QTDVEN - SC6->C6_QTDENT)
					SB1->( dbSeek( xFilial() + SC6->C6_PRODUTO ) )
					Reclock("SC9",.T.)
					SC9->C9_FILIAL  := xFilial("SC9")
					SC9->C9_PEDIDO  := SC6->C6_NUM
					SC9->C9_ITEM    := SC6->C6_ITEM
					SC9->C9_CLIENTE := SC6->C6_CLI
					SC9->C9_LOJA    := SC6->C6_LOJA
					SC9->C9_PRODUTO := SC6->C6_PRODUTO
					SC9->C9_QTDLIB  := QUERYSZY->ZY_QUANT
					SC9->C9_DATALIB := Date()
					SC9->C9_SEQUEN  := RetC9SEQUE(SC6->C6_NUM,SC6->C6_ITEM,1)
					SC9->C9_GRUPO   := SB1->B1_GRUPO
					SC9->C9_PRCVEN  := SC6->C6_PRCVEN
					SC9->C9_BLEST   := '10'
					SC9->C9_BLCRED  := '10'
					SC9->C9_LOTECTL := SC6->C6_LOTECTL
					SC9->C9_DTVALID := SC6->C6_DTVALID
					SC9->C9_LOCAL   := SC6->C6_LOCAL
					SC9->C9_TPCARGA := '2'
					SC9->C9_RETOPER := '2'
					SC9->C9_TPOP    := '1'
					//SC9->C9_DATAENT :=
					SC9->( msUnlock() )
				Else
					Return "ERRO - Quantidade do SZY maior que saldo do pedido"
				EndIf
			Else
				Return "ERRO - Produto do SZY diferente do SC6"
			EndIf
		EndIf
		QUERYSZY->( dbSkip() )
	End


	aPvlNfs := {}
	SC6->(dbSetOrder(1))
	QUERYSZY->( dbGoTop() )



	If SC6->( DbSeek(xFilial() + cNumPV, .F.) )
		SC9->( DbSetOrder(1) )
		SC5->( DbSetOrder(1) )
		SC6->( DbSetOrder(1) )
		SE4->( DbSetOrder(1) )
		SB1->( DbSetOrder(1) )
		SB2->( DbSetOrder(1) )
		SF4->( DbSetOrder(1) )
		SA1->( dbSetOrder(1) )

		SC5->( dbSeek(xFilial("SC5")+QUERYSZY->ZY_PEDIDO ) )

		SA1->( dbSeek( xFilial() + SC5->C5_CLIENTE + SC5->C5_LOJACLI ) )

		While !QUERYSZY->( EOF() )
			cNumPV := QUERYSZY->ZY_PEDIDO

			SC6->( dbSeek( xFilial() + QUERYSZY->ZY_PEDIDO + QUERYSZY->ZY_ITEM ) )
			//While SC6->(!Eof()) .And. SC6->C6_NUM == cNumPV

			cSquenC9 := RetC9SEQUE(cNumPV,SC6->C6_ITEM,0)
			If SC9->(DbSeek(xFilial("SC9")+cNumPV+SC6->C6_ITEM+cSquenC9   ))//FILIAL+NUMERO+ITEM
				SC5->(DbSeek(xFilial("SC5")+cNumPV                         ))//FILIAL+NUMERO
				SC6->(DbSeek(xFilial("SC6")+cNumPV+SC6->C6_ITEM            ))//FILIAL+NUMERO+ITEM
				SE4->(DbSeek(xFilial("SE4")+SC5->C5_CONDPAG                ))//CONDICAO DE PGTO
				SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO                ))//FILIAL+PRODUTO
				SB2->(DbSeek(xFilial("SB2")+SC6->C6_PRODUTO+SC6->C6_LOCAL  ))//FILIAL+PRODUTO+LOCAL
				SF4->(DbSeek(xFilial("SF4")+SC6->C6_TES                    ))//FILIAL+CODIGO
				aAdd(aPvlNfs,{;
					cNumPV,         ;    //Numero Pedido
				SC9->C9_ITEM,   ;    //Item
				SC9->C9_SEQUEN, ;    //Sequencia
				SC9->C9_QTDLIB ,;    //Qtd Liberada
				SC6->C6_PRCVEN, ;    //preco de Venda
				SC9->C9_PRODUTO,;    //Produto
				SF4->F4_ISS=="S",;                // .F.        // Alterado por mauresi em 29/03/17
				SC9->(RecNo()),;
					SC5->(RecNo()),;
					SC6->(RecNo()),;
					SE4->(RecNo()),;
					SB1->(RecNo()),;
					SB2->(RecNo()),;
					SF4->(RecNo()),;
					SB2->B2_LOCAL,;
					0,;
					SC9->C9_QTDLIB2})

			Else
				Return "ERRO -  SC9 não encontrado para o pedido "
			EndIf
			QUERYSZY->(DbSkip())

		EndDo

		//--> Adiciona no Array para verificar se todas as notas do lote foram importadas e evitar copia dos arquivos sem total processamento
		//AADD(aNotasOk,{cFile,xFilial("SF2"),cNumPV,cSerie,cCliente,cLoja,cTipo})

	/*/
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Parametros³ExpA1: Array com os itens a serem gerados                   ³±±
		±±³          ³ExpC2: Serie da Nota Fiscal                                 ³±±
		±±³          ³ExpL3: Mostra Lct.Contabil                                  ³±±
		±±³          ³ExpL4: Aglutina Lct.Contabil                                ³±±
		±±³          ³ExpL5: Contabiliza On-Line                                  ³±±
		±±³          ³ExpL6: Contabiliza Custo On-Line                            ³±±
		±±³          ³ExpL7: Reajuste de preco na nota fiscal                     ³±±
		±±³          ³ExpN8: Tipo de Acrescimo Financeiro                         ³±±
		±±³          ³ExpN9: Tipo de Arredondamento                               ³±±
		±±³          ³ExpLA: Atualiza Amarracao Cliente x Produto                 ³±±
		±±³          ³ExplB: Cupom Fiscal                                         ³±±
		±±³          ³ExpCC: Numero do Embarque de Exportacao                     ³±±
		±±³          ³ExpBD: Code block para complemento de atualizacao dos titu- ³±±
		±±³          ³       los financeiros.                                     ³±±
	/*/


		cQueryTMPNFS := "SELECT MAX(F2_DOC) AS MAX_DOC FROM " + RetSqlName("SF2") + " (NOLOCK) WHERE F2_FILIAL = '"+xFilial("SF2")+"' AND F2_SERIE = '"+Alltrim(cSerie)+"' AND F2_FILIAL = '" + xFilial("SF2") + "' AND DATALENGTH(LTRIM(RTRIM(F2_DOC))) = 9 AND D_E_L_E_T_ = ' '"

		If Select("TEMP") <> 0
			TEMP->( dbCloseArea() )
		EndIf

		TCQUERY cQueryTMPNFS NEW ALIAS "TEMP"

		cMaxDoc := TEMP->MAX_DOC

	/*
	If !Empty(cNumNF)
	SX5->( dbSeek( xFilial() + "01" + "1" ) )
	Reclock("SX5",.F.)
	SX5->X5_DESCRI  := cNumNF
	SX5->X5_DESCSPA := cNumNF
	SX5->X5_DESCENG := cNumNF
	SX5->( msUnlock() )
	EndIf
	*/

		//nTempNMODULO := NMODULO // VARIAVEL PUBLICA VINDA DO .XNU

		NMODULO      := 5       // Faturamento

		// Gera Nota Fiscal de Saída utilizando fonte padrão versão 12.1.7 Por Michel Sander em 20.09.16
		//U_RMaPvlNfs(aPvlNfs,cSerie, .F., .F., .F., .F., .F., 0, 0, .T., .F.,,,,,,dDatabase)

		// Gera Nota Fiscal de Saída
		SX1->(dbSetOrder(1))
		If SX1->(dbSeek(PADR("MT460A",10)+"17"))
			Reclock("SX1",.F.)
			SX1->X1_PRESEL := 2
			SX1->(MsUnlock())
		EndIf
		If SX1->(dbSeek(PADR("MT460A",10)+"18"))
			Reclock("SX1",.F.)
			SX1->X1_PRESEL := 2
			SX1->(MsUnlock())
		EndIf

		Pergunte("MT460A",.F.)      // Adicionado por mauresi em 24/10/16 - Evitar erro ao gerar Titulos

		//mv_par01 :=


		//Fonte p12 X	cNota := MaPvlNfs(aPvlNfs,cSerie,lMostraCtb,lAglutCtb,lCtbOnLine,lCtbCusto,lReajusta,nCalAcrs,nArredPrcLis,lAtuSA7,lECF,,,,,,dDataMoe)
		//Y	cNota := MaPvlNfs(aPvlNfs,cSerie, .F.      , .F.     , .F.      , .T.     , .F.     , 0      , 0          , .T.   , .F.)
		//	cNota := MaPvlNfs(aPvlNfs,cSerie, .F., .F., .F., .T., .F., 0, 0, .T., .F.)
		//validacao novo calculo imposto
		If U_VALIDACAO('JONAS')  
			fVALICMPI(SC5->C5_CLIENTE, SC5->C5_LOJACLI, SC5->C5_NUM, .T.) //CLIENTE + LOJA + PEDIDO + PROCESSAMENTO ANTES DA NF
		EndIf

		SetFunName("MATA461") // mauresi 09/08/2019
		cNota := MaPvlNfs(aPvlNfs,cSerie, .F., .F., .F., .T., .F., 0, 0, .T., .F.,,,,,,dDataBase)   // Alterado por Mauresi em 29/03/17

				//validacao novo calculo imposto
		If U_VALIDACAO('JONAS') 
			fVALICMPI(SC5->C5_CLIENTE, SC5->C5_LOJACLI, SC5->C5_NUM, .F.) //CLIENTE + LOJA + PEDIDO + PROCESSAMENTO ANTES DA NF
		EndIf

		If U_VALIDACAO("HELIO")   // Não subir para produção
			// Este trecho estava compilado em produção alterando a alíquota de icms. Retirado e compilado em produção
			nValICM := 0
			SD2->( dbSetOrder(3) )
			If SD2->( dbSeek( xFilial() + cNota + cSerie ) )
				While !SD2->( EOF() ) .and. SD2->D2_DOC == cNota .and. SD2->D2_SERIE == cSerie
					SB1->( dbSeek( xFilial() + SD2->D2_COD ) )
					If SB1->B1_ORIGEM == '1'	// Alterado por Mauresi em 30/05/2017    //If SB1->B1_ORIGEM <> '0' .and. !Empty(SB1->B1_ORIGEM)
						If SA1->A1_EST <> 'SP'
							Reclock("SD2",.F.)
							SD2->D2_PICM   := 4
							SD2->D2_VALICM := Round(SD2->D2_BASEICM * (SD2->D2_PICM/100),2)
							SD2->( msUnlock() )
						EndIf
					EndIf
					nValICM += SD2->D2_VALICM
					SD2->( dbSkip() )
				End
			EndIf

			SF2->( dbSetOrder(1) )
			If SF2->( dbSeek( xFilial() + cNota + cSerie ) )
				Reclock("SF2",.F.)
				SF2->F2_VALICM := nValICM
				SF2->( msUnlock() )
			EndIf
		Else
			SD2->( dbSetOrder(3) )
			If SD2->( dbSeek( xFilial() + cNota + cSerie ) )
				While !SD2->( EOF() ) .and. SD2->D2_DOC == cNota .and. SD2->D2_SERIE == cSerie
					SB1->( dbSeek( xFilial() + SD2->D2_COD ) )
					If SB1->B1_ORIGEM == '1'	// Alterado por Mauresi em 30/05/2017    //If SB1->B1_ORIGEM <> '0' .and. !Empty(SB1->B1_ORIGEM)
						If SA1->A1_EST <> 'SP'
							cAssunto := "NF teste 4% ICMS realizado"
							cTxtMsg  := "NF: " + SD2->D2_DOC + Chr(13)
							cTxtMsg  += "Lembrar de pedir para a Priscila validar o ICMS"

							cTexto   := StrTran(cTxtMsg,Chr(13),"<br>")
							cPara    := 'denis.vieira@rdt.com.br;fulgencio.muniz@rosenbergerdomex.com.br'
							cCC      := 'helio@opusvp.com.br'
							cArquivo := Nil
							//U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
						EndIf
					EndIf
					SD2->( dbSkip() )
				End
			EndIf
		EndIf

		//NMODULO      := nTempNMODULO

		If Select("TEMP") <> 0
			TEMP->( dbCloseArea() )
		EndIf

		TCQUERY cQueryTMPNFS NEW ALIAS "TEMP"

		If cMaxDoc == TEMP->MAX_DOC
			_Retorno := "ERRO - Nota Fiscal não gerada"
		Else
			SF2->( dbSetOrder(1) )
			If SF2->( dbSeek( xFilial() + TEMP->MAX_DOC ) )
				_Retorno := SF2->F2_DOC
				Reclock("SF2",.F.)
				SF2->F2_XCOLET := 'S'
				SF2->( msUnlock() )
				// Carrega Rotina que Atualiza CLASSIFICACAO FISCAL
				fVldClasFis(SF2->F2_DOC, SF2->F2_SERIE, SF2->F2_CLIENTE, SF2->F2_LOJA)
				fLoteEnd(SF2->F2_DOC, SF2->F2_SERIE, SF2->F2_CLIENTE, SF2->F2_LOJA)
			EndIf
		EndIf

	Else
		Return "ERRO - pedido não encontrado no SC6 "
	Endif

Return _Retorno


Static Function RetC9SEQUE(cC9PEDIDO,cC9ITEM,nInc)
	Local _Retorno

	Local cQueryTMPNFS := "SELECT MAX(C9_SEQUEN) AS MAX_C9_SEQUEN FROM " + RetSqlName("SC9") + " (NOLOCK) WHERE C9_FILIAL = '"+XFilial("SC9")+"' AND  C9_PEDIDO = '"+cC9PEDIDO+"' AND C9_ITEM = '"+cC9ITEM+"' AND D_E_L_E_T_ = '' "

	If Select("QUERYSC9") <> 0
		QUERYSC9->( dbCloseArea() )
	EndIf

	TCQUERY cQueryTMPNFS NEW ALIAS "QUERYSC9"

	_Retorno := StrZero(Val(QUERYSC9->MAX_C9_SEQUEN)+nInc,Len(SC9->C9_SEQUEN))

Return _Retorno


Static Function fVldClasFis(__cNota, __cSerie, __cCliente, __cLoja)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica diferencas de classe fiscal									³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQueryTMPNFS := "SELECT D2_FILIAL, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, D2_CLASFIS, C6_CLASFIS, SD2010.R_E_C_N_O_ AS RECNOSD2 "
	cQueryTMPNFS += "FROM SD2010 (NOLOCK), SC6010 (NOLOCK)                                           "
	cQueryTMPNFS += "WHERE D2_FILIAL = '"+xFilial("SD2")+"' AND C6_FILIAL = '"+xFilial("SC6")+"' AND D2_DOC = '"+__cNota+"' AND D2_SERIE = '"+__cSerie+"'                      "
	cQueryTMPNFS += "AND D2_CLIENTE = '"+__cCliente+"' AND D2_LOJA = '"+__cLoja+"'                   "
	cQueryTMPNFS += "AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM                                  "
	cQueryTMPNFS += "AND SUBSTRING(D2_CLASFIS,1,1) <> SUBSTRING(C6_CLASFIS,1,1)                      "
	cQueryTMPNFS += "AND SC6010.D_E_L_E_T_ = '' AND SD2010.D_E_L_E_T_ = ''                           "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryTMPNFS),"TEMP001",.F.,.T.)
	If TEMP001->(Eof())
		TEMP001->(dbCloseArea())
		Return
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Correcao da classe fiscal no arquivo de itens de nota fiscal	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !TEMP001->( EOF() )
		SD2->( dbGoTo(TEMP001->RECNOSD2))
		If SD2->( Recno() ) == TEMP001->RECNOSD2
			Reclock("SD2",.F.)
			SD2->D2_CLASFIS := TEMP001->C6_CLASFIS
			SD2->( msUnlock() )
		EndIf
		TEMP001->( dbSkip() )
	End

//Inserido por Michel A Sander em 16.03.2017 para reprocessamento do livro fiscal de saida
	SF2->(dbSetOrder(1))
	If SF2->(dbSeek(xFilial()+__cNota+__cSerie+__cCliente+__cLoja))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Parametros para reprocessar LIVRO FISCAL DE SAIDA					³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aPergA930 := {}
		AADD(aPergA930,DTOC(SF2->F2_EMISSAO))     // Data de Emissao De
		AADD(aPergA930,DTOC(SF2->F2_EMISSAO))     // Data de Emissao Ate
		AADD(aPergA930,2)                         // 1=Entrada, 2=Saida, 3=Ambos
		AADD(aPergA930,SF2->F2_DOC)               // Nota Fiscal De
		AADD(aPergA930,SF2->F2_DOC)               // Nota Fiscal Ate
		AADD(aPergA930,SF2->F2_SERIE)             // Serie De
		AADD(aPergA930,SF2->F2_SERIE)             // Serie Ate
		AADD(aPergA930,SF2->F2_CLIENTE)           // Cliente De
		AADD(aPergA930,SF2->F2_CLIENTE)           // Cliente Ate
		AADD(aPergA930,SF2->F2_LOJA)              // Loja De
		AADD(aPergA930,SF2->F2_LOJA)              // Loja Ate

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Reprocessamento do LIVRO FISCAL DE SAIDA								³
		//³ 																					³
		//³ Param 1 = .T. ou .F. - Processamento via ExecAuto					³
		//³ Param 2 = Array com os parametros de processamento				³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		MsgRun("Reprocessando Livro Fiscal","Aguarde...",{|| MATA930(.T.,aPergA930) })

	EndIf

	TEMP001->(dbCloseArea())

Return

Static Function fLoteEnd(cNF, cSerie, cCliente, cLoja)

	SB1->( dbSetOrder(1) )
	SD2->( dbSetOrder(3) )
	SD5->( dbSetOrder(3) ) //D5_FILIAL+D5_NUMSEQ+D5_PRODUTO+D5_LOCAL+D5_LOTECTL+D5_NUMLOTE
	SDB->( dbSetOrder(1) ) //DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA+DB_ITEM
	SC6->( dbSetOrder(1) )

	If SD2->( dbSeek( xFilial() + cNF + cSerie + cCliente + cLoja ) )
		While !SD2->( EOF() ) .and. SD2->D2_FILIAL == xFilial("SD2") .and. SD2->D2_DOC == cNF .and.  SD2->D2_SERIE == cSerie .and. SD2->D2_CLIENTE == cCliente .and. SD2->D2_LOJA == cLoja
			If SB1->( dbSeek( xFilial() + SD2->D2_COD ) )
				If SC6->( dbSeek( xFilial() + SD2->D2_PEDIDO + SD2->D2_ITEMPV ) )
					If SB1->B1_RASTRO == 'L' //.and. !Empty(SD2->D2_LOTECTL)
						SD5->( dbSeek( xFilial() + SD2->D2_NUMSEQ+SD2->D2_COD+SD2->D2_LOCAL ) )
						lAchou := .F.
						While !SD5->( EOF() ) .and. SD2->D2_NUMSEQ == SD5->D5_NUMSEQ .and. SD2->D2_COD == SD5->D5_PRODUTO .and. SD2->D2_LOCAL == SD5->D5_LOCAL
							If SD5->D5_DOC == SD2->D2_DOC .and. SD5->D5_SERIE == SD2->D2_SERIE .and. SD5->D5_DATA == SD2->D2_EMISSAO .and. SD5->D5_ORIGLAN == SD2->D2_TES .and. SD5->D5_CLIFOR == SD2->D2_CLIENTE .and. SD5->D5_LOJA == SD2->D2_LOJA
								If	SD5->D5_QUANT <> SD2->D2_QUANT
									RecLock("SD5",.F.)
									SD5->D5_QUANT := SD2->D2_QUANT
									SD5->(msUnlock())
									U_CRIAP07(SD2->D2_COD, SD2->D2_LOCAL)
								EndIf
								lAchou := .T.
							EndIf
							SD5->( dbSkip() )
						End
						If !lAchou
							Reclock("SD5",.T.)
							SD5->D5_FILIAL  := xFilial("SD5")
							SD5->D5_NUMSEQ  := SD2->D2_NUMSEQ
							SD5->D5_PRODUTO := SD2->D2_COD
							SD5->D5_LOCAL   := SD2->D2_LOCAL
							SD5->D5_DOC     := SD2->D2_DOC
							SD5->D5_SERIE   := SD2->D2_SERIE
							SD5->D5_DATA    := SD2->D2_EMISSAO
							SD5->D5_ORIGLAN := SD2->D2_TES
							SD5->D5_CLIFOR  := SD2->D2_CLIENTE
							SD5->D5_LOJA    := SD2->D2_LOJA
							SD5->D5_QUANT   := SD2->D2_QUANT
							SD5->D5_XLOTEOK := "S"


							If !Empty(SD2->D2_LOTECTL)
								SD5->D5_LOTECTL := SD2->D2_LOTECTL
							Else
								SD5->D5_LOTECTL := SC6->C6_LOTECTL
							EndIf
							SD5->D5_DTVALID := StoD("20491231")
							SD5->(msUnlock())

							U_CRIAP07(SD2->D2_COD, SD2->D2_LOCAL)
						EndIf
					EndIf
					If SB1->B1_LOCALIZ == 'S'
						If !SDB->( dbSeek( xFilial() + SD2->D2_COD + SD2->D2_LOCAL + SD2->D2_NUMSEQ + SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA ) )
							cNumIDOper := GetSx8Num('SDB','DB_IDOPERA'); ConfirmSX8()

							Reclock("SDB",.T.)
							SDB->DB_FILIAL  := xFilial("SDB")
							SDB->DB_ITEM    := "001"
							SDB->DB_PRODUTO := SD2->D2_COD
							SDB->DB_LOCAL   := SD2->D2_LOCAL
							SDB->DB_LOCALIZ := SC6->C6_LOCALIZ
							SDB->DB_DOC     := SD2->D2_DOC
							SDB->DB_SERIE   := SD2->D2_SERIE
							SDB->DB_CLIFOR  := SD2->D2_CLIENTE
							SDB->DB_LOJA    := SD2->D2_LOJA
							SDB->DB_TIPONF  := SD2->D2_TIPO
							SDB->DB_TM      := SD2->D2_TES
							SDB->DB_ORIGEM  := "SC6"
							SDB->DB_QUANT   := SD2->D2_QUANT
							SDB->DB_DATA    := SD2->D2_EMISSAO
							SDB->DB_XLOTEOK := "S"
							If SB1->B1_RASTRO == 'L'
								If !Empty(SD2->D2_LOTECTL)
									SDB->DB_LOTECTL := SD2->D2_LOTECTL
								Else
									SDB->DB_LOTECTL := SC6->C6_LOTECTL
								EndIf
							EndIf
							SDB->DB_NUMSEQ  := SD2->D2_NUMSEQ
							SDB->DB_TIPO    := "M"
							SDB->DB_SERVIC  := "999"
							SDB->DB_ATIVID  := "ZZZ"
							SDB->DB_HRINI   := Time()
							SDB->DB_ATUEST  := "S"
							SDB->DB_STATUS  := "M"
							SDB->DB_ORDATIV := "ZZ"
							SDB->DB_IDOPERA := cNumIDOper
							SDB->( msUnlock() )

							U_CRIAP07(SD2->D2_COD, SD2->D2_LOCAL)
						Else
							If	SDB->DB_QUANT <> SD2->D2_QUANT
								RecLock("SDB",.F.)
								SDB->DB_QUANT := SD2->D2_QUANT
								SDB->(msUnlock())
								U_CRIAP07(SD2->D2_COD, SD2->D2_LOCAL)
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
			SD2->( dbSkip() )
		End
	EndIf

Return


Static Function fValicmpi(cCliente, cLOJA, cPedido,lAntes)
aAreaSC5 := GetArea()


SA1->(dbsetorder(1))
SC5->(dbsetorder(1))
If SC5->( dbSeek( xFilial("SC5") + cPedido))
	If SA1->( FieldPos("A1_XICMPIS") )  > 0
		If SA1->( dbSeek( xFilial("SA1") + cCliente + cLOJA))
			If !EMPTY(SA1->A1_XICMPIS)
				If SC5->C5_EMISSAO >= SA1->A1_XICMPIS
					If lAntes
						PutMv("MV_DEDBPIS",	'I')
						PutMv("MV_DEDBCOF", 'I')
					Else
						PutMv("MV_DEDBPIS",	'N')
						PutMv("MV_DEDBCOF", 'N')
					EndIf
				Endif
			EndIf
		EndIf
	EndIf
EndIf

RestArea(aAreaSC5)
Return
