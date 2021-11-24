#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ESTPRODOM ºAutor  ³Michel Sander       º Data ³  23.04.2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para estorno de apontamento de produção             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ESTPRODOM(cVerPeca,lVerSldAtu,lVerEmbala)
	Local x, y
	Local lEstornOK    := .T.
	DEFAULT cVerPeca   := ""
	DEFAULT lVerSldAtu := .F.
	DEFAULT lVerEmbala := .T.

	If !Empty(SD3->D3_ESTORNO)
		MsgInfo("Movimento já estornado.")
		lEstornOK := .F.
	Else
		If Empty(SD3->D3_OP)
			MsgInfo("Posicione em um registro de requisiçao ou apontamento de Produção.")
			lEstornOK := .F.
		Else
			If SD3->D3_CF <> 'PR0'
				MsgInfo("Apontamento de produção não é manual (PR0).")
				lEstornOK := .F.
			Else
				If SD3->D3_EMISSAO <= GetMV("MV_ULMES")
					MsgInfo("Movimento anterior ao ultimo fechamento de estoque.")
					lEstornOK := .F.
				Else
					cNumSeq := SD3->D3_NUMSEQ
					cQuery := "SELECT * FROM " + RetSqlTab("SD3") + " (NOLOCK), " + RetSqlTab("SF5") + " (NOLOCK) WHERE D3_NUMSEQ = '"+cNumSeq+"' AND D3_ESTORNO = '' AND D3_TM = F5_CODIGO AND F5_TIPO = 'P' AND SD3.D_E_L_E_T_ = '' AND SF5.D_E_L_E_T_ = '' AND D3_FILIAL = '"+xFilial("SD3")+"' AND F5_FILIAL = '"+xFilial("SF5")+"' "
					If Select("QUERYSD3") <> 0
						QUERYSD3->( dbCloseArea() )
					EndIf
					TCQUERY cQuery NEW ALIAS "QUERYSD3"
					If QUERYSD3->( EOF() )
						MsgInfo("Este movimento não se refere a um apontamento de produção.")
					Else
						cOP := SD3->D3_OP
						cMensEst := IIf(Empty(cVerPeca),"Deseja estornar o apontamento de produçaõ da OP " + cOP + " sequencial "+cNumSeq+"?",;
							"Deseja estornar o apontamento de produçaõ da OP " + cOP + " Etiqueta No. "+cVerPeca+"?")
						If MsgYesNo(cMensEst)
							lEstornOK     := .T.
							cQuery := "SELECT D3_COD, D3_LOCAL, D3_QUANT FROM " + RetSqlTab("SD3") + " (NOLOCK), " + RetSqlTab("SF5") + " (NOLOCK) "
							cQuery += "WHERE D3_NUMSEQ = '"+cNumSeq+"' AND D3_CF = 'PR0' AND D3_ESTORNO = '' AND D3_TM = F5_CODIGO AND (F5_TIPO = 'P' OR F5_TIPO = 'D') AND SD3.D_E_L_E_T_ = '' AND SF5.D_E_L_E_T_ = '' AND D3_FILIAL = '"+xFilial("SD3")+"' AND F5_FILIAL = '"+xFilial("SF5")+"' "
							If Select("QUERYSD3") <> 0
								QUERYSD3->( dbCloseArea() )
							EndIf
							TCQUERY cQuery NEW ALIAS "QUERYSD3"
							aVetProd := {}
							While !QUERYSD3->( EOF() )
								nTemp := aScan(aVetProd,{|aVet| aVet[1] == QUERYSD3->D3_COD .and. aVet[2] == QUERYSD3->D3_LOCAL})
								If Empty(nTemp)
									AADD(aVetProd,{QUERYSD3->D3_COD, QUERYSD3->D3_LOCAL, QUERYSD3->D3_QUANT})
								Else
									aVetProd[nTemp,3] += QUERYSD3->D3_QUANT
								EndIf
								QUERYSD3->( dbSkip() )
							End

							SB2->( dbSetOrder(1) )
							SB8->( dbSetOrder(3) )
							For x := 1 to Len(aVetProd)
								If SB2->( dbSeek( xFilial() + aVetProd[x,1] + aVetProd[x,2] ) )
									If SB2->B2_QATU < aVetProd[x,3]
										MsgStop("Insuficiência de saldo do produto " + Alltrim(aVetProd[x,1]) + " almoxarifado " + aVetProd[x,2] + " para continuar com este estorno." + Chr(13) + "Saldo atual: "+Alltrim(Transform(SB2->B2_QATU,"@E 999,999,999.9999"))+". Apontamento a ser estornado: " + Transform(aVetProd[x,3],"@E 999,999,999.9999") )
										lEstornOK := .F.
										Return (lEstornOk)
									Else
										// Validando o saldo por lote.
										If Rastro(aVetProd[x,1])
											cQuery := "SELECT D5_PRODUTO, D5_LOCAL, D5_LOTECTL, D5_ORIGLAN, D5_QUANT FROM " + RetSqlName("SD5") + " (NOLOCK) WHERE D5_NUMSEQ = '"+cNumSeq+"' AND D5_ORIGLAN < '500' AND D5_ESTORNO = '' AND D_E_L_E_T_ = '' AND D5_FILIAL = '"+xFilial("SD5")+"' "
											cQuery += " AND D5_PRODUTO='"+aVetProd[x,1]+"' AND D5_LOCAL='"+aVetProd[x,2]+"'"
											If Select("QUERYSD5") <> 0
												QUERYSD5->( dbCloseArea() )
											EndIf
											TCQUERY cQuery NEW ALIAS "QUERYSD5"
											aVetProdLot := {}
											SF5->( dbSetOrder(1) )
											While !QUERYSD5->( EOF() )
												nTemp := aScan(aVetProdLot,{ |aVet| aVet[1] == QUERYSD5->D5_PRODUTO .and. aVet[2] == QUERYSD5->D5_LOCAL .and. aVet[3] == QUERYSD5->D5_LOTECTL})
												If Empty(nTemp)
													AADD(aVetProdLot,{QUERYSD5->D5_PRODUTO, QUERYSD5->D5_LOCAL, QUERYSD5->D5_LOTECTL, QUERYSD5->D5_QUANT})
												Else
													aVetProdLot[nTemp,4] += QUERYSD5->D5_QUANT
												EndIf
												QUERYSD5->( dbSkip() )
											End
											For y := 1 to Len(aVetProdLot)
												If SB8->( dbSeek( xFilial() + aVetProdLot[y,1] + aVetProdLot[y,2] + aVetProdLot[y,3] ) )
													If SB8->B8_SALDO < aVetProdLot[y,4]
														MsgStop("Insuficiência de saldo por lote do produto " + Alltrim(aVetProdLot[y,1]) + " almoxarifado " + aVetProdLot[y,2] + " Lote " + aVetProdLot[y,3] + " para continuar com este estorno." + Chr(13) + "Saldo atual: "+Alltrim(Transform(SB8->B8_SALDO,"@E 999,999,999.9999"))+". Apontamento a ser estornado: " + Transform(aVetProdLot[y,4],"@E 999,999,999.9999") )
														lEstornOK := .F.
														Return (lEstornOK)
													EndIf
												Else
													MsgStop("Insuficiência de saldo por lote do produto " + Alltrim(aVetProdLot[y,1]) + " almoxarifado " + aVetProdLot[y,2] + " Lote " + aVetProdLot[y,3] + " para continuar com este estorno." + Chr(13) + "Saldo atual: "+Alltrim(Transform(0,"@E 999,999,999.9999"))+". Apontamento a ser estornado: " + Transform(aVetProdLot[y,4],"@E 999,999,999.9999") )
													lEstornOK := .F.
													Return (lEstornOK)
												EndIf
											Next y
										EndIf
									EndIf
								Else
									MsgStop("Insuficiência de saldo do produto " + Alltrim(aVetProd[x,1]) + " almoxarifado " + aVetProd[x,2] + " para continuar com este estorno." + Chr(13) + "Saldo atual: 0,000. Apontamento a ser estornado: " + Transform(aVetProd[x,3],"@E 999,999,999.9999") )
									lEstornOK := .F.
									Return (lEstornOK)
								EndIf
							Next x

							If lEstornOK
								cQuery := "SELECT D3_EMISSAO FROM " + RetSqlName("SD3") + " (NOLOCK) WHERE D3_FILIAL = '"+xFilial("SD3")+"' AND D3_EMISSAO <= '"+DtoS(GetMV("MV_ULMES"))+"' AND D3_NUMSEQ = '"+cNumSeq+"' AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' ORDER BY D3_EMISSAO"
								If Select("QUERYSD3") <> 0
									QUERYSD3->( dbCloseArea() )
								EndIf
								TCQUERY cQuery NEW ALIAS "QUERYSD3"
								If !QUERYSD3->(EOF())
									MsgInfo("Não será possível estornar o apontamento pois existe movimento com data de " +DtoC(StoD(QUERYSD3->D3_EMISSAO))+ " anterior ao ultimo fechamento de estoque " + DtoC(GetMV("MV_ULMES")))
									lEstornOK := .F.
								EndIf
								If lEstornOK
									cQuery := "SELECT D5_DATA FROM " + RetSqlName("SD5") + " (NOLOCK) WHERE D5_FILIAL = '"+xFilial("SD5")+"' AND D5_DATA <= '"+DtoS(GetMV("MV_ULMES"))+"' AND D5_NUMSEQ = '"+cNumSeq+"' AND D5_ESTORNO = '' AND D_E_L_E_T_ = '' ORDER BY D5_DATA"
									If Select("QUERYSD5") <> 0
										QUERYSD5->( dbCloseArea() )
									EndIf
									TCQUERY cQuery NEW ALIAS "QUERYSD5"
									If !QUERYSD5->(EOF())
										MsgInfo("Não será possível estornar o apontamento pois existe movimento por lote com data de " +DtoC(StoD(QUERYSD5->D5_DATA))+ " anterior ao ultimo fechamento de estoque " + DtoC(GetMV("MV_ULMES")))
										lEstornOK := .F.
									EndIf
								Endif
								If lEstornOK
									cQuery := "SELECT DB_DATA FROM " + RetSqlName("SDB") + " (NOLOCK) WHERE DB_FILIAL = '"+xFilial("SDB")+"' AND DB_DATA <= '"+DtoS(GetMV("MV_ULMES"))+"' AND DB_NUMSEQ = '"+cNumSeq+"' AND DB_ESTORNO = '' AND D_E_L_E_T_ = '' ORDER BY DB_DATA"
									If Select("QUERYSDB") <> 0
										QUERYSDB->( dbCloseArea() )
									EndIf
									TCQUERY cQuery NEW ALIAS "QUERYSDB"
									If !QUERYSDB->(EOF())
										MsgInfo("Não será possível estornar o apontamento pois existe movimento por endereço com data de " +DtoC(StoD(QUERYSD5->D5_DATA))+ " anterior ao ultimo fechamento de estoque " + DtoC(GetMV("MV_ULMES")))
										lEstornOK := .F.
									EndIf
								EndIf
								If lEstornOK
									cQuery := "SELECT D3_COD, D3_LOCAL, D3_OP, D3_CF, D3_QUANT, D3_NUMSEQ, D3_XXPECA, R_E_C_N_O_ FROM " + RetSqlName("SD3") + " (NOLOCK) WHERE D3_FILIAL = '"+xFilial("SD3")+"' AND D3_NUMSEQ = '"+cNumSeq+"' AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "
									If Select("QUERYSD3") <> 0
										QUERYSD3->( dbCloseArea() )
									EndIf
									TCQUERY cQuery NEW ALIAS "QUERYSD3"
									SD4->( dbSetOrder(2) )
									SC2->( dbSetOrder(1))
									While !QUERYSD3->(EOF())
										If QUERYSD3->D3_CF == 'PR0' .or. QUERYSD3->D3_CF == 'PR1'
											If SC2->( dbSeek( xFilial() + Subs(QUERYSD3->D3_OP,1,11) ) )
												nC2QUJE := SC2->C2_QUJE
												Reclock("SC2",.F.)
												SC2->C2_QUJE  -= QUERYSD3->D3_QUANT
												SC2->C2_DATRF := CtoD('')
												SC2->( msUnlock() )
												If U_VALIDACAO(HELIO,.F.) // HELIO 18/08/21
													// If Colocado para detectar erro na gravação do SC2
													If SC2->C2_QUJE <> (nC2QUJE-QUERYSD3->D3_QUANT) .or. !Empty(SC2->C2_DATRF)
														cTxtMsg  := " Erro na gravação no C2_QUJE no estorno de etiquetas." + Chr(13)
														cTxtMsg  += " OP = " + QUERYSD3->D3_OP + Chr(13)
														cTxtMsg  += " Etiqueta = " + QUERYSD3->D3_XXPECA  + Chr(13)
														cAssunto := "Erro na gravação no C2_QUJE no estorno de etiquetas"
														cTexto   := StrTran(cTxtMsg,Chr(13),"<br>")
														cPara    := 'denis.vieira@rdt.com.br;fulgencio.muniz@rosenbergerdomex.com.br'
														cCC      := 'helio@opusvp.com.br;jackson.santos@opusvp.com.br'
														cArquivo := Nil
														U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
													Else
														cTxtMsg  := " Gravação do C2_QUJE Ok." + Chr(13)
														cTxtMsg  += " OP = " + QUERYSD3->D3_OP + Chr(13)
														cTxtMsg  += " Etiqueta = " + QUERYSD3->D3_XXPECA  + Chr(13)
														cAssunto := "Não houve erro na gravação no C2_QUJE no estorno de etiquetas"
														cTexto   := StrTran(cTxtMsg,Chr(13),"<br>")
														cPara    := 'denis.vieira@rdt.com.br;fulgencio.muniz@rosenbergerdomex.com.br'
														cCC      := 'helio@opusvp.com.br;jackson.santos@opusvp.com.br'
														cArquivo := Nil
														U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
													EndIf
												EndIf
											EndIf
											SDA->(dbSetOrder(6))
											If SDA->(dbSeek( xFilial() + QUERYSD3->D3_NUMSEQ ) )
												Reclock("SDA",.F.)
												SDA->(dbDelete())
												SDA->(MsUnlock())
											EndIf
											If lVerEmbala
												//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
												//³ Cancela etiqueta							               ³
												//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
												If !Empty(QUERYSD3->D3_XXPECA) .And. QUERYSD3->D3_CF == 'PR0'
													XD1->(dbSetOrder(1))
													If XD1->(dbSeek(xFilial()+QUERYSD3->D3_XXPECA))
														Reclock("XD1",.F.)
														XD1->XD1_OCORRE := "5"
														XD1->(MsUnlock())
													EndIf
													//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
													//³Estorna etiquetas das embalagens filhas no XD2			³
													//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
													XD2->(dbSetOrder(1))
													If XD2->(dbSeek(xFilial("XD2")+QUERYSD3->D3_XXPECA))
														Do While XD2->(dbSeek(xFilial("XD2")+QUERYSD3->D3_XXPECA))
															Reclock("XD2",.F.)
															XD2->(dbDelete())
															XD2->(MsUnlock())
														EndDo
													EndIf
												EndIf
											EndIf
										Else
											If SD4->( dbSeek( xFilial() +  QUERYSD3->D3_OP + QUERYSD3->D3_COD + QUERYSD3->D3_LOCAL   ) )
												If QUERYSD3->D3_QUANT > 0
													Reclock("SD4",.F.)
													SD4->D4_QUANT += QUERYSD3->D3_QUANT
													SD4->( msUnlock() )
												EndIf
											EndIf
										EndIf
										SD3->( dbGoTo(QUERYSD3->R_E_C_N_O_))
										If SD3->(Recno()) == QUERYSD3->R_E_C_N_O_
											Reclock("SD3",.F.)
											SD3->D3_ESTORNO := "S"
											SD3->(msUnlock())
										EndIf
										U_CRIAP07(QUERYSD3->D3_COD,QUERYSD3->D3_LOCAL,.T.)
										If lVerSldAtu
											MsgRun("Atualizando Saldo "+QUERYSD3->D3_COD+"...","UMATA300",{|| U_UMATA300(QUERYSD3->D3_COD,QUERYSD3->D3_COD,QUERYSD3->D3_LOCAL,QUERYSD3->D3_LOCAL) })
										EndIf
										QUERYSD3->( dbSkip() )
									EndDo

									cQuery := "SELECT D5_PRODUTO, D5_LOCAL, R_E_C_N_O_ FROM " + RetSqlName("SD5") + " (NOLOCK) WHERE D5_FILIAL = '"+xFilial("SD5")+"' AND D5_NUMSEQ = '"+cNumSeq+"' AND D5_ESTORNO = '' AND D_E_L_E_T_ = '' "
									If Select("QUERYSD5") <> 0
										QUERYSD5->( dbCloseArea() )
									EndIf
									TCQUERY cQuery NEW ALIAS "QUERYSD5"
									While !QUERYSD5->(EOF())
										SD5->(dbGoTo( QUERYSD5->R_E_C_N_O_ ))
										If SD5->( Recno() ) == QUERYSD5->R_E_C_N_O_
											Reclock("SD5",.F.)
											SD5->D5_ESTORNO := "S"
											SD5->(MsUnlock())
										EndIf
										U_CRIAP07(QUERYSD5->D5_PRODUTO,QUERYSD5->D5_LOCAL,.T.)
										QUERYSD5->( dbSkip() )
									End

									cQuery := "SELECT DB_PRODUTO, DB_LOCAL, R_E_C_N_O_ FROM " + RetSqlName("SDB") + " (NOLOCK) WHERE DB_FILIAL = '"+xFilial("SDB")+"' AND DB_NUMSEQ = '"+cNumSeq+"' AND DB_ESTORNO = '' AND D_E_L_E_T_ = '' "
									If Select("QUERYSDB") <> 0
										QUERYSDB->( dbCloseArea() )
									EndIf
									TCQUERY cQuery NEW ALIAS "QUERYSDB"
									While !QUERYSDB->(EOF())
										SDB->( dbGoTo(QUERYSDB->R_E_C_N_O_) )
										If SDB->(Recno()) == QUERYSDB->R_E_C_N_O_
											Reclock("SDB",.F.)
											SDB->DB_ESTORNO := "S"
											SDB->(msUnlock())
										EndIf
										U_CRIAP07(QUERYSDB->DB_PRODUTO,QUERYSDB->DB_LOCAL,.T.)
										QUERYSDB->( dbSkip() )
									End
									MsgInfo("Estorno processado com sucesso.")
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf

Return ( lEstornOK )
