#include "topconn.ch"
//------------------------------------------------------------------------------------------------------------------------------------------------//
//Wederson L. Santana 22/02/13                                                                                                                    //
//------------------------------------------------------------------------------------------------------------------------------------------------//
//OPusVp                                                                                                                                          //
//------------------------------------------------------------------------------------------------------------------------------------------------//
//Específico Domex                                                                                                                                //
//------------------------------------------------------------------------------------------------------------------------------------------------//
//Ponto de entrada após a classificação da nota fiscal (MATA103)                                                                                  //
//------------------------------------------------------------------------------------------------------------------------------------------------//
//FILIALMG

User Function SD1100I2()

	If DtoS(Date()) == '20210527' // .AND. xFilial("SF1") == '02'
		//PARAMIXB := {}
		RpcSetEnv("01","02")
		dDataBase := StoD('20210526')
		//AADD(PARAMIXB, 3)
		//AADD(PARAMIXB, 1)
		SF1->( dbGoTo(134557) )
		SD1->( dbGoTo(288554) )
		//nConfirma := 1
		//nOpcao := 3
		SD1->( dbSetOrder(1) )
		SD1->( dbSeek( SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA ) )
		While !SD1->( EOF() ) .and. SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA == SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA
			U_SD1100I()
			SD1->( dbSkip() )
		End
	EndIf

Return

User Function SD1100I()
	Local _aAreaGER   := GetArea()
	Local _aAreaSD1   := SD1->( GetArea() )
	Local _aAreaSB1   := SB1->( GetArea() )
	Local _aAreaSF4   := SF4->( GetArea() )
	Local _aAreaSD7   := SD7->( GetArea() )
	Local _aAreaSDA   := SDA->( GetArea() )
	Local _aAreaSBE   := SBE->( GetArea() )
	Local _aAreaSDB   := SDB->( GetArea() )
	Local _aAreaXD1   := XD1->( GetArea() )
	Local _aAreaSC2   := SC2->( GetArea() )
	Local _aAreaSG1   := SG1->( GetArea() )
	Local _aAreaSD3   := SD3->( GetArea() )
	Local _aAreaSD4   := SD4->( GetArea() )
	Local _aCabSDA    := {}
	Local _aItSDB     := {}
	Local _aItensSDB  := {}
	Local _cItem      := StrZero(1,4)

// Rotina automático MATA265 está disposicionando o SD1

	Private lMsHelpAuto := .T.
	Private lMsErroAuto := .F.

//Alterado para testar se !Empty(SD1->D1_TES)
//If l103Class //Somente na classificação.

	If !Empty(SD1->D1_TES)
		SF4->(dbSetOrder(1))
		If SF4->(dbSeek( xFilial("SF4") + SD1->D1_TES))

			If SF4->F4_ESTOQUE == 'S'

				SB1->( dbSetOrder(1))
				SB1->( dbSeek( xFilial() + SD1->D1_COD ))
				If SB1->B1_LOCALIZ == 'S'


					//Tratamento para o CQ.
					If SD1->D1_LOCAL $ AllTrim(GetMv("MV_CQ"))
						//Controle CQ
						SD7->(dbSetOrder(3))
						If SD7->(dbSeek(xFilial()+SD1->D1_COD+SD1->D1_NUMSEQ))

							// Endereçamento Automático
							// Alterado por Helio
							//SDA->(dbSetOrder(1))
							//If SDA->(dbSeek( xFilial("SDA") + SD1->D1_COD + SD1->D1_LOCAL + SD1->D1_NUMSEQ + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA ))
							SDA->(dbSetOrder(RetOrder("SDA","DA_FILIAL+DA_NUMSEQ")))  // DA_FILIAL + DA_NUMSEQ
							If SDA->(dbSeek( xFilial() + SD1->D1_NUMSEQ ))

								//Busca o endereço padrão do CQ.
								SBE->(dbSetOrder(1))
								If SBE->(dbSeek(xFilial()+SD7->D7_LOCAL))

									_cLocaliz := SBE->BE_LOCALIZ

									//Busca o próximo item no SDB.
									_cItem := ''
									SDB->(dbSetOrder(1))
									If SDB->(dbSeek( xFilial("SDB") + SD7->D7_PRODUTO + SD7->D7_LOCDEST + SDA->DA_NUMSEQ))
										While xFilial("SDA") + SDA->DA_PRODUTO + SDA->DA_LOCAL + SDA->DA_NUMSEQ == SDB->DB_FILIAL + SDB->DB_PRODUTO + SDB->DB_LOCAL + SDB->DB_NUMSEQ
											If _cItem < SDB->DB_ITEM
												_cItem := SDB->DB_ITEM
											EndIf
											SDB->( dbSkip() )
										End
										_cItem := StrZero(Val(_cItem)+1,4)
									EndIf

									_aCabSDA := {{"DA_PRODUTO" ,SDA->DA_PRODUTO ,Nil},;
										{"DA_NUMSEQ"  ,SDA->DA_NUMSEQ  ,Nil}}

									_aItSDB  := {{"DB_ITEM"	   ,_cItem	        ,Nil},;
										{"DB_ESTORNO" ,Space(01)       ,Nil},;
										{"DB_LOCALIZ" ,_cLocaliz       ,Nil},;
										{"DB_DATA"	   ,dDataBase       ,Nil},;
										{"DB_QUANT"   ,SDA->DA_SALDO   ,Nil}}

									aadd(_aItensSDB,_aitSDB)



									MATA265( _aCabSDA, _aItensSDB, 3)

									RestArea(_aAreaSD1)

									If lMsErroAuto
										MostraErro("\UTIL\LOG\Classificacao\")

										MsgInfo("Erro no endereçamento automático.","A T E N Ç Ã O")
									Else
										XD1->(dbSetOrder(2))
										If XD1->( dbSeek(xFilial("XD1")+SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD)))
											While XD1->(XD1_FILIAL+XD1_DOC+XD1_SERIE+XD1_FORNECE+XD1_LOJA+XD1_COD) == xFilial("XD1")+SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD)
												Reclock("XD1",.F.)
												XD1->XD1_OCORRE := "2"
												XD1->XD1_LOCALI := _cLocaliz
												XD1->( msUnlock() )
												XD1->( dbSkip() )
											End
										Else
											MsgStop("Não foram encontradas Peças para alteração do Status.")
										EndIf
									EndIf

								Else
									MsgInfo("Endereço do CQ não encontrado.","A T E N Ç Ã O")
								EndIf
							EndIf
						Else
							MsgSop("Não foi encontrada a pendência de Liberação no CQ!")
						EndIf
					
					
					/*Else

						
						//INICIO enderecamento automatico nova filial 01/04/2021S
						If fwfilial() == "02"
							//If SD1->D1_FORNECE=='XXXXXX' .AND. SD1->D1_LOJA='XX'
							SDA->(dbSetOrder(RetOrder("SDA","DA_FILIAL+DA_NUMSEQ")))  // DA_FILIAL + DA_NUMSEQ
							If SDA->(dbSeek( xFilial() + SD1->D1_NUMSEQ ))

								_cLocaliz := "01RECEBIMENTO"

								//Busca o próximo item no SDB.
								_cItem := ''
								SDB->(dbSetOrder(1))
								If SDB->(dbSeek( xFilial("SDB") + SD1->D1_COD + "01" + SD1->D1_NUMSEQ))
									While xFilial("SDA") + SDA->DA_PRODUTO + SDA->DA_LOCAL + SDA->DA_NUMSEQ == SDB->DB_FILIAL + SDB->DB_PRODUTO + SDB->DB_LOCAL + SDB->DB_NUMSEQ
										If _cItem < SDB->DB_ITEM
											_cItem := SDB->DB_ITEM
										EndIf
										SDB->( dbSkip() )
									End
									_cItem := StrZero(Val(_cItem)+1,4)
								EndIf

								_aCabSDA := {{"DA_PRODUTO" ,SDA->DA_PRODUTO ,Nil},;
									{"DA_NUMSEQ"  ,SDA->DA_NUMSEQ  ,Nil}}

								_aItSDB  := {;
									{"DB_ITEM"	  ,_cItem	       ,Nil},;
									{"DB_ESTORNO" ,Space(01)       ,Nil},;
									{"DB_LOCALIZ" ,_cLocaliz       ,Nil},;
									{"DB_DATA"	  ,SDA->DA_DATA    ,Nil},;
									{"DB_QUANT"   ,SDA->DA_SALDO   ,Nil}}

								aadd(_aItensSDB,_aitSDB)



								MATA265( _aCabSDA, _aItensSDB, 3)

								RestArea(_aAreaSD1)

								If lMsErroAuto
									MostraErro("\UTIL\LOG\Classificacao\")
									MsgInfo("Erro no endereçamento automático.","A T E N Ç Ã O")
								EndIf

							EndIf
							//FIM NOVA FILIAL MG

							*/
						/*
						Else
						XD1->(dbSetOrder(2))
							If XD1->( dbSeek(xFilial("XD1")+SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD)))
								While XD1->(XD1_FILIAL+XD1_DOC+XD1_SERIE+XD1_FORNECE+XD1_LOJA+XD1_COD) == xFilial("XD1")+SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD)
								Reclock("XD1",.F.)
								XD1->XD1_OCORRE := "3"
								XD1->( msUnlock() )
								XD1->( dbSkip() )
								End
							EndIf  */
						//EndIf
					EndIf
				EndIf
			EndIf
		Else
		MsgStop("TES não encontrada!!!")
		EndIf
	EndIf

cQuery := "SELECT XD1_XXPECA FROM " + RetSqlName("XD1") + " (NOLOCK) WHERE XD1_FORNEC = '"+SD1->D1_FORNECE+"' AND XD1_LOJA = '"+SD1->D1_LOJA+"' AND XD1_DOC = '"+SD1->D1_DOC+"' AND XD1_SERIE = '"+SD1->D1_SERIE+"' AND XD1_ITEM = '"+SD1->D1_ITEM+"' AND XD1_COD = '"+SD1->D1_COD+"' AND XD1_TIPO = '"+SD1->D1_TIPO+"' AND XD1_FORMUL = '"+SD1->D1_FORMUL+"' AND ((XD1_LOCAL = '"+GetMV("MV_CQ")+"' AND XD1_OCORRE <> '2') OR (XD1_LOCAL <> '"+GetMV("MV_CQ")+"' AND XD1_OCORRE <> '3')) AND D_E_L_E_T_ = '' "

	If Select("TEMP") <> 0
	TEMP->( dbCloseArea() )
	EndIf

TCQUERY cQuery NEW ALIAS "TEMP"

	While !TEMP->( EOF() )
	MsgStop("ERRO!!! Peça " + TEMP->XD1_XXPECA + " não corrigida! Informar o depto de TI!!!")
	TEMP->( dbSkip() )
	End

//Ajusta os empenhos que estão pendentes de classificação no PickList	
_cQR1 :=" UPDATE SD4010 SET D4_XPKLIST = 'S' "
_cQR1 +=" FROM SD4010 WHERE D_E_L_E_T_ ='' AND D4_FILIAL = '" + xFilial("SD4") + "' AND D4_XPKLIST= 'N' AND D4_COD = '" + SD1->D1_COD + "' "
TCSQLEXEC(_cQR1)

/*
// Apontamento automático de OP de silk
aEmpenhos := {}
SC2->( dbSetOrder(1) )
SD4->( dbSetOrder(2) )
	If !Empty(SD1->D1_TES)
		If !Empty(SD1->D1_OP)
			If SC2->( dbSeek( xFilial() + Subs(SD1->D1_OP,1,11) ) )
				If SB1->( dbSeek( xFilial() + SC2->C2_PRODUTO ) )
					If SD4->( dbSeek( xFilial() + Subs(SD1->D1_OP,1,11) ) )
					lTotal := .T.
						While !SD4->( EOF() ) .and. Subs(SD4->D4_OP,1,11) == Subs(SD1->D1_OP,1,11)
						AADD(aEmpenhos,{SD4->D4_COD, SD4->D4_QTDEORI, SD4->D4_QUANT})
							If !Empty(SD4->D4_QUANT)
							lTotal := .F.
							EndIf
						SD4->( dbSkip() )
						End
					
						If !Empty(aEmpenhos)
						nPercent := 100
						
							If !lTotal
								For x := 1 to Len(aEmpenhos)
									If (((aEmpenhos[x,2] - aEmpenhos[x,3]) / aEmpenhos[x,2]) * 100) < nPercent
									nPercent := ((aEmpenhos[x,2] - aEmpenhos[x,3]) / aEmpenhos[x,2]) * 100
									EndIf
								Next x
							EndIf
						
						nPerApont := nPercent - ((SC2->C2_QUJE / SC2->C2_QUANT) * 100)
						nQtdApont := (nPerApont / 100) * SC2->C2_QUANT
						
							If !Empty(nQtdApont)
							cTM         := "010"
							_cDocumento := U_NEXTDOC()
							_aCampos    := {}
							
							Aadd(_aCampos,{"D3_DOC    " , _cDocumento                     , NIL })
							Aadd(_aCampos,{"D3_TM     " , cTM                             , NIL })
							Aadd(_aCampos,{"D3_COD    " , SC2->C2_PRODUTO                 , NIL })
							//Aadd(_aCampos,{"D3_UM     " , _UM                           , NIL })
							Aadd(_aCampos,{"D3_OP     " , Subs(SD1->D1_OP,1,11)           , NIL })
							Aadd(_aCampos,{"D3_QUANT  " , nQtdApont                       , NIL })
							Aadd(_aCampos,{"D3_LOCAL  " , SC2->C2_LOCAL                   , NIL })
							Aadd(_aCampos,{"D3_EMISSAO" , DDATABASE                       , NIL })
							Aadd(_aCampos,{"D3_PARCTOT" , 'P'                             , NIL })
							
							Private lMsHelpAuto    := .T.
							Private lMsErroAuto    := .F.
							
								If SB1->B1_NUMCQPR == 0
								Reclock("SB1",.F.)
								SB1->B1_NUMCQPR := 1
								SB1->( msUnlock() )
								EndIf
							
							nBkpModulo := nModulo
							nModulo    := 4
							
							dbCommitall()
							
							//MSExecAuto({|x,y| mata250(x,y)},_ACAMPOS,3)  // 3-Inclusao   // MATA250() - Apontamento de Produção
							
								If lMsErroAuto
								//MsgStop("Erro no apontamento de produção automático.")
								//Mostraerro()
								cAssunto := 'Erro no apontamento automático de OP: ' + Subs(SD1->D1_OP,1,11)
								cTexto   := 'Erro no apontamento automático da OP: ' + Subs(SD1->D1_OP,1,11) + '<br>' + 'Quantidade: ' + Transform(nQtdApont,'@E 999,999,999.9999')
								cPara    := 'helio@opusvp.com.br;vanessa.faio@rdt.com.br'
								cCC      := ''
								cArquivo := Nil
								U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
								Else
								//MsgStop("Apontamento automático de produção realizado com sucesso.")
								cAssunto := 'Apontamento automático de OP: ' + Subs(SD1->D1_OP,1,11)
								cTexto   := 'Apontamento automático da OP: ' + Subs(SD1->D1_OP,1,11) + '<br>' + 'Quantidade: ' + Transform(nQtdApont,'@E 999,999,999.9999')
								cPara    := 'helio@opusvp.com.br;vanessa.faio@rdt.com.br'
								cCC      := ''
								cArquivo := Nil
								U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
								EndIf
							
							nModulo := nBkpModulo
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
*/

	RestArea(_aAreaSG1)
	RestArea(_aAreaSC2)
	RestArea(_aAreaSD1)
	RestArea(_aAreaSD3)
	RestArea(_aAreaSD4)
	RestArea(_aAreaSB1)
	RestArea(_aAreaSF4)
	RestArea(_aAreaSD7)
	RestArea(_aAreaSDA)
	RestArea(_aAreaSBE)
	RestArea(_aAreaSDB)
	RestArea(_aAreaXD1)
	RestArea(_aAreaGER)

Return