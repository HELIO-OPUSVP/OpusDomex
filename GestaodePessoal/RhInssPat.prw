User Function RhInssPatb(cPeriodo,cFilProc,l13Sal,cPeriodo13)

Local cQuery 		:= ""
Local cQueryD1 		:= ""                                                               	
Local cAliasQry 	:= GetNextAlias()
Local cAliasSD1		:= GetNextAlias()
Local nPerIni13		:= IiF (ValType(cPeriodo13)=="C" .And. !Empty(cPeriodo13), AT("/",cPeriodo13),0)
Local cPerIni13		:= IiF (ValType(cPeriodo13)=="C" .And. nPerIni13 > 0, AllTrim(SubStr(cPeriodo13,1,nPerIni13-1)),"")
Local cPerFim13		:= IiF (ValType(cPeriodo13)=="C" .And. nPerIni13 > 0, AllTrim(SubStr(cPeriodo13,nPerIni13+1,(Len(cPeriodo13)))),"") 
Local dPerFim13		:= IiF (!Empty(cPerFim13),CTOD("01"+"/"+SUBSTR(cPerFim13,1,2)+"/"+SUBSTR(cPerFim13,5,6)),CTOD(""))
Local dPerIni		:= IiF (!l13Sal,CTOD("01"+"/"+SUBSTR(cPeriodo,1,2)+"/"+SUBSTR(cPeriodo,5,6)), CTOD("01"+"/"+SUBSTR(cPerIni13,1,2)+"/"+SUBSTR(cPerIni13,5,6)))
Local dPerFim		:= IiF (!l13Sal,CTOD(StrZero(F_ULTDIA(dPerIni),2)+"/"+SUBSTR(cPeriodo,1,2)+"/"+SUBSTR(cPeriodo,5,6)),CTOD(StrZero(F_ULTDIA(dPerFim13),2)+"/"+SUBSTR(cPerFim13,1,2)+"/"+SUBSTR(cPerFim13,5,6)))
Local aArea			:= GetArea()
Local aCFOPs		:= XFUNCFRec()  
Local cArquivo      := ""
Local cChave        := ""
Local cIniDes		:= SuperGetMv("MV_DESFOL",,"201208") //Periodo de inicio do cliente na desoneração Mês+Ano   se for fazer colocar o param no updfat23
Local cCFIND		:= SuperGetMv("MV_CFIND",,"") //CFOP´s das vendas dos produtos industrializados pela empresa
Local nIndex        := 0 
Local nFatBrut		:= 0 
Local nFatRec		:= 0
Local nFatExp		:= 0
Local nPosFis		:= 0
Local nPosDev		:= 0
Local nPosExp       := 0  
Local nX            := 0
Local nTotDev       := 0
Local nImpostos     := 0
Local aTotFis		:= {}
Local aTotFisDev	:= {} 
Local aCampos		:= {}
Local aFatDes		:= {}
Local lB5VerInd		:= .F.   // Indica se o campo B5_VERIND existe, caso exista para ser desonerado devera conter o cfop no parâmetro "MV_CFIND"
Local cIndex2  		:= ""
Local cIndexD1		:= ""

//Private cPeriodo 	:= ""
//Private cPeriodo13	:= ""
//Private cFilProc	:= cFilAnt
//Private l13Sal		:= .F. 

lB5VerInd := SB5->(FieldPos('B5_VERIND')) > 0
If cPaisLoc == "BRA"
	#IFDEF TOP			
		cQuery += " SELECT D2_DOC, D2_SERIE, D2_COD, D2_TIPO, D2_TOTAL, D2_VALIPI, D2_ICMSRET, D2_CF, D2_EMISSAO, D2_NFORI, D2_SERIORI, " 
		cQuery += " D2_VALFRE, D2_SEGURO, D2_DESPESA, D2_VALBRUT " 
		cQuery += " FROM " + RetSqlName( "SD2" ) + " "
		cQuery += " WHERE "
		cQuery += " D2_FILIAL = '" + xFilial("SD2") + "' AND "
		cQuery += " D2_TIPO IN ('N','C')  AND "
	    cQuery += " D2_EMISSAO BETWEEN '"+DTOS(dPerIni)+"' AND '"+DTOS(dPerFim)+"' AND " 
		cQuery += " D_E_L_E_T_ = ' ' "
		cQuery += " ORDER BY D2_DOC, D2_SERIE, D2_COD "
				
		cQuery := ChangeQuery( cQuery )
		dbUseArea( .T., "TOPCONN", TcGenQry( ,,cQuery ), cAliasQry, .F., .T. )
		
		If SB5->(FieldPos('B5_INSPAT')) > 0 .AND. SB5->(FieldPos('B5_CODATIV')) > 0
		
			While !(cAliasQry)->( Eof() )
				If Alltrim((cAliasQry)->D2_CF)$ aCFOPs[1] .And. !Alltrim((cAliasQry)->D2_CF)$ aCFOPs[2]
					nFatBrut+=(cAliasQry)->D2_VALBRUT //Variavel que retornar o valor bruto das notas(considera frete seguro e despesa) 
					aAdd(aFatDes,{(cAliasQry)->D2_DOC,(cAliasQry)->D2_SERIE,(cAliasQry)->D2_TIPO,(cAliasQry)->D2_EMISSAO,(cAliasQry)->D2_TOTAL +; 
								(cAliasQry)->D2_VALFRE + (cAliasQry)->D2_SEGURO + (cAliasQry)->D2_DESPESA, (cAliasQry)->D2_NFORI,(cAliasQry)->D2_SERIORI, (cAliasQry)->D2_CF})
					If SubStr((cAliasQry)->D2_CF,1,1) <> "7" .AND. (Posicione("SB5",1,xFilial("SB5")+(cAliasQry)->D2_COD,"B5_INSPAT") == "1")
					    If lB5VerInd
						    If ((Posicione("SB5",1,xFilial("SB5")+(cAliasQry)->D2_COD,"B5_VERIND") == "1" .And. AllTrim((cAliasQry)->D2_CF) $cCFIND) .OR. Posicione("SB5",1,xFilial("SB5")+(cAliasQry)->D2_COD,"B5_VERIND") <> "1")
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Soma os valores por codigo de atividade no array aTotFis³
								//³[1] Código de atividade                                 ³
								//³[2] Valor Bruto por código atividade                    ³
								//³[3] Valor Bruto Exportação por código de atividade      ³
								//³[4] Valor liq + frete + seguro + despesa                ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								cCodAtiv := Posicione("SB5",1,xFilial("SB5")+(cAliasQry)->D2_COD,"B5_CODATIV")
								If !Empty(cCodAtiv)	
									nPosFis := aScan(aTotFis,{|x| Alltrim(x[1]) == Alltrim(cCodAtiv)})
									If nPosFis == 0
										aAdd(aTotFis,{cCodAtiv,(cAliasQry)->D2_VALBRUT, 0,(cAliasQry)->D2_TOTAL + (cAliasQry)->D2_VALFRE + (cAliasQry)->D2_SEGURO + (cAliasQry)->D2_DESPESA })
									Else
										aTotFis[nPosFis][2]+=(cAliasQry)->D2_VALBRUT
										aTotFis[nPosFis][4]+=(cAliasQry)->D2_TOTAL + (cAliasQry)->D2_VALFRE + (cAliasQry)->D2_SEGURO + (cAliasQry)->D2_DESPESA
									EndIf
								EndIf  
							EndIf
						Else 
							cCodAtiv := Posicione("SB5",1,xFilial("SB5")+(cAliasQry)->D2_COD,"B5_CODATIV")
							If !Empty(cCodAtiv)	
								nPosFis := aScan(aTotFis,{|x| Alltrim(x[1]) == Alltrim(cCodAtiv)})
								If nPosFis == 0
									aAdd(aTotFis,{cCodAtiv,(cAliasQry)->D2_VALBRUT, 0,(cAliasQry)->D2_TOTAL + (cAliasQry)->D2_VALFRE + (cAliasQry)->D2_SEGURO + (cAliasQry)->D2_DESPESA })
								Else
									aTotFis[nPosFis][2]+=(cAliasQry)->D2_VALBRUT
									aTotFis[nPosFis][4]+=(cAliasQry)->D2_TOTAL + (cAliasQry)->D2_VALFRE + (cAliasQry)->D2_SEGURO + (cAliasQry)->D2_DESPESA
								EndIf
							EndIf 
						EndIf	 		
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifico a exportações que possuem codigo de atividade e³
					//³atribuo a posição 3 do array                            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					ElseIf SubStr((cAliasQry)->D2_CF,1,1) == "7"
						nFatExp+= (cAliasQry)->D2_VALBRUT
						If(Posicione("SB5",1,xFilial("SB5")+(cAliasQry)->D2_COD,"B5_INSPAT") == "1")
							If lB5VerInd
								If ((Posicione("SB5",1,xFilial("SB5")+(cAliasQry)->D2_COD,"B5_VERIND") == "1" .And. AllTrim((cAliasQry)->D2_CF) $cCFIND) .OR. Posicione("SB5",1,xFilial("SB5")+(cAliasQry)->D2_COD,"B5_VERIND") <> "1")
									cCodAtiv := Posicione("SB5",1,xFilial("SB5")+(cAliasQry)->D2_COD,"B5_CODATIV")
									If !Empty(cCodAtiv)	
										nPosExp := aScan(aTotFis,{|x| Alltrim(x[1]) == Alltrim(cCodAtiv)})
										If nPosExp == 0
											aAdd(aTotFis,{cCodAtiv,(cAliasQry)->D2_VALBRUT,(cAliasQry)->D2_VALBRUT,(cAliasQry)->D2_TOTAL + (cAliasQry)->D2_VALFRE + (cAliasQry)->D2_SEGURO + (cAliasQry)->D2_DESPESA})
										Else
											aTotFis[nPosExp][2]+= (cAliasQry)->D2_VALBRUT
											aTotFis[nPosExp][3]+=(cAliasQry)->D2_VALBRUT
											aTotFis[nPosExp][4]+=(cAliasQry)->D2_TOTAL + (cAliasQry)->D2_VALFRE + (cAliasQry)->D2_SEGURO + (cAliasQry)->D2_DESPESA
										EndIf
									EndIf 
								EndIf	
							Else
							 	cCodAtiv := Posicione("SB5",1,xFilial("SB5")+(cAliasQry)->D2_COD,"B5_CODATIV")
								If !Empty(cCodAtiv)	
									nPosExp := aScan(aTotFis,{|x| Alltrim(x[1]) == Alltrim(cCodAtiv)})
									If nPosExp == 0
										aAdd(aTotFis,{cCodAtiv,(cAliasQry)->D2_VALBRUT,(cAliasQry)->D2_VALBRUT,(cAliasQry)->D2_TOTAL + (cAliasQry)->D2_VALFRE + (cAliasQry)->D2_SEGURO + (cAliasQry)->D2_DESPESA})
									Else
										aTotFis[nPosExp][2]+= (cAliasQry)->D2_VALBRUT
										aTotFis[nPosExp][3]+=(cAliasQry)->D2_VALBRUT
										aTotFis[nPosExp][4]+=(cAliasQry)->D2_TOTAL + (cAliasQry)->D2_VALFRE + (cAliasQry)->D2_SEGURO + (cAliasQry)->D2_DESPESA
									EndIf
								EndIf 
							EndIf	
						EndIf	
					EndIf
				EndIf							 	
				dbSkip()
			EndDo 
		EndIf
	#ELSE
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Cria o arquivo de trabalho caso o campo B5_INSPAT exista.	³
		//³Para criação do mesmo aplicar o UPDFAT23						³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SB5->(FieldPos('B5_INSPAT')) > 0 .AND. SB5->(FieldPos('B5_CODATIV')) > 0
			cIndex2 := CriaTrab(NIL,.F.)
			cKey	:= 'D2_DOC, D2_SERIE, D2_COD '
			cFilter := 'D2_FILIAL == "'+ xFilial("SD2") +'" .And. (Dtos(D2_EMISSAO) >= "'+Dtos(dPerIni)+'" .And. Dtos(D2_EMISSAO) <= "'+Dtos(dPerFim)+'")'
			cFilter += '.And. D2_TIPO $ ("N|C") '
			
			dbSelectArea("SD2") 	 			 			 
			IndRegua("SD2",cIndex2,cKey,,cFilter,)
			nIndex := RetIndex("SD2")
			 
			dbSetIndex(cIndex2+OrdBagExt())
			dbSetOrder(nIndex+1)
			dbGotop()
		
			While !SD2->( Eof() )
				If Alltrim(SD2->D2_CF)$ aCFOPs[1] .And. !Alltrim(SD2->D2_CF)$ aCFOPs[2]
					nFatBrut+=SD2->D2_VALBRUT
					aAdd(aFatDes,{SD2->D2_DOC,SD2->D2_SERIE,SD2->D2_TIPO,DTOS(SD2->D2_EMISSAO),SD2->D2_TOTAL + SD2->D2_VALFRE + SD2->D2_SEGURO +; 
									SD2->D2_DESPESA, SD2->D2_NFORI,SD2->D2_SERIORI, SD2->D2_CF})
					If SubStr(SD2->D2_CF,1,1) <> "7" .AND. (Posicione("SB5",1,xFilial("SB5")+SD2->D2_COD,"B5_INSPAT") == "1")
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Soma os valores por codigo de atividade no array aTotFis³
						//³[1] Código de atividade                                 ³
						//³[2] Valor Bruto por código atividade                    ³
						//³[3] Valor Bruto Exportação por código de atividade      ³
						//³[4] Valor liq + frete + seguro + despesa                ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ						 	
						If lB5VerInd
							If ((Posicione("SB5",1,xFilial("SB5")+SD2->D2_COD,"B5_VERIND") == "1" .And. AllTrim(SD2->D2_CF) $cCFIND) .OR. Posicione("SB5",1,xFilial("SB5")+SD2->D2_COD,"B5_VERIND") <> "1")						 	
								cCodAtiv := Posicione("SB5",1,xFilial("SB5")+SD2->D2_COD,"B5_CODATIV")
								If !Empty(cCodAtiv)	
									nPosFis := aScan(aTotFis,{|x| Alltrim(x[1]) == Alltrim(cCodAtiv)})
									If nPosFis == 0
										aAdd(aTotFis,{cCodAtiv,SD2->D2_VALBRUT, 0 ,SD2->D2_TOTAL + SD2->D2_VALFRE + SD2->D2_SEGURO + SD2->D2_DESPESA})
									Else
										aTotFis[nPosFis][2]+= SD2->D2_VALBRUT 
										aTotFis[nPosFis][4]+= SD2->D2_TOTAL + SD2->D2_VALFRE + SD2->D2_SEGURO + SD2->D2_DESPESA
									EndIf
								EndIf
							EndIf
						Else
							cCodAtiv := Posicione("SB5",1,xFilial("SB5")+SD2->D2_COD,"B5_CODATIV")
							If !Empty(cCodAtiv)	
								nPosFis := aScan(aTotFis,{|x| Alltrim(x[1]) == Alltrim(cCodAtiv)})
								If nPosFis == 0
									aAdd(aTotFis,{cCodAtiv,SD2->D2_VALBRUT, 0 ,SD2->D2_TOTAL + SD2->D2_VALFRE + SD2->D2_SEGURO + SD2->D2_DESPESA})
								Else
									aTotFis[nPosFis][2]+= SD2->D2_VALBRUT 
									aTotFis[nPosFis][4]+= SD2->D2_TOTAL + SD2->D2_VALFRE + SD2->D2_SEGURO + SD2->D2_DESPESA
								EndIf
							EndIf
						EndIf		
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifico a exportações que possuem codigo de atividade e³
					//³atribuo a posição 3 do array                            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					ElseIf SubStr(SD2->D2_CF,1,1) == "7"
						nFatExp+= SD2->D2_TOTAL + SD2->D2_VALFRE + SD2->D2_SEGURO + SD2->D2_DESPESA // Total geral de exportação
						If(Posicione("SB5",1,xFilial("SB5")+SD2->D2_COD,"B5_INSPAT") == "1")
							If lB5VerInd
								If ((Posicione("SB5",1,xFilial("SB5")+SD2->D2_COD,"B5_VERIND") == "1" .And. AllTrim(SD2->D2_CF) $cCFIND) .OR. Posicione("SB5",1,xFilial("SB5")+SD2->D2_COD,"B5_VERIND") <> "1")						 	
									cCodAtiv := Posicione("SB5",1,xFilial("SB5")+SD2->D2_COD,"B5_CODATIV")
									If !Empty(cCodAtiv)	
										nPosExp := aScan(aTotFis,{|x| Alltrim(x[1]) == Alltrim(cCodAtiv)})
										If nPosExp == 0
											aAdd(aTotFis,{cCodAtiv,SD2->D2_VALBRUT, SD2->D2_VALBRUT, SD2->D2_TOTAL + SD2->D2_VALFRE + SD2->D2_SEGURO + SD2->D2_DESPESA})
										Else
											aTotFis[nPosExp][2]+= SD2->D2_VALBRUT 
											aTotFis[nPosExp][3]+= SD2->D2_VALBRUT 
											aTotFis[nPosExp][4]+=SD2->D2_TOTAL + SD2->D2_VALFRE + SD2->D2_SEGURO + SD2->D2_DESPESA
										EndIf
									EndIf
								EndIf
							Else
								cCodAtiv := Posicione("SB5",1,xFilial("SB5")+SD2->D2_COD,"B5_CODATIV")
								If !Empty(cCodAtiv)	
									nPosExp := aScan(aTotFis,{|x| Alltrim(x[1]) == Alltrim(cCodAtiv)})
									If nPosExp == 0
										aAdd(aTotFis,{cCodAtiv,SD2->D2_VALBRUT, SD2->D2_VALBRUT, SD2->D2_TOTAL + SD2->D2_VALFRE + SD2->D2_SEGURO + SD2->D2_DESPESA})
									Else
										aTotFis[nPosExp][2]+= SD2->D2_VALBRUT 
										aTotFis[nPosExp][3]+= SD2->D2_VALBRUT 
										aTotFis[nPosExp][4]+=SD2->D2_TOTAL + SD2->D2_VALFRE + SD2->D2_SEGURO + SD2->D2_DESPESA
									EndIf
								EndIf
							EndIf		
						EndIf					
					EndIf
				EndIf		
				SD2->(dbSkip())
			EndDo
			Ferase(cIndex2+OrdBagExt())	// Exclui o arquivo de trabalho
		EndIf
		dbSelectArea("SD2")
		RetIndex("SD2")
		dbClearFilter()
	#ENDIF
   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processamento das notas de devolução³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   
	#IFDEF TOP			
		cQueryD1 := " SELECT D1_DOC, D1_SERIE, D1_COD, D1_TIPO, D1_TOTAL, D1_VALDESC, D1_CF, D1_EMISSAO, D1_NFORI, D1_SERIORI, "
		cQueryD1 += " D1_VALDESC, D1_VALFRE, D1_SEGURO, D1_DESPESA, D1_VALIPI, D1_ICMSRET " 
		cQueryD1 += " FROM " + RetSqlName( "SD1" ) + "  "
		cQueryD1 += " WHERE "
		cQueryD1 += " D1_FILIAL = '"  + xFilial("SD1") + "' AND "
		cQueryD1 += " D1_TIPO IN ('D','C') AND "
	    cQueryD1 += " D1_DTDIGIT BETWEEN '"+DTOS(dPerIni)+"' AND '"+DTOS(dPerFim)+"' AND " 
		cQueryD1 += " D_E_L_E_T_ = ' ' "
		cQueryD1 += " ORDER BY D1_DOC, D1_SERIE, D1_COD "	
		cQueryD1 := ChangeQuery( cQueryD1 )
		dbUseArea( .T., "TOPCONN", TcGenQry( ,,cQueryD1 ), cAliasSD1, .F., .T. )		
		cCodAtiv := ""
		If SB5->(FieldPos('B5_INSPAT')) > 0 .AND. SB5->(FieldPos('B5_CODATIV')) > 0
			While !(cAliasSD1)->( EOF() )
				SD2->(dbSetOrder(3))
				If SD2->(dbSeek(xFilial("SD2")+(cAliasSD1)->D1_NFORI + (cAliasSD1)->D1_SERIORI))
					If (Alltrim(SD2->D2_CF)$ aCFOPs[1] .And. !Alltrim(SD2->D2_CF)$ aCFOPs[2]) .And. SD2->D2_EMISSAO >= CTOD("01"+"/"+SUBSTR(cIniDes,5,6)+"/"+SUBSTR(cIniDes,1,4))
					    nTotDev	+= ((cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC) + (cAliasSD1)->D1_VALFRE + (cAliasSD1)->D1_SEGURO + (cAliasSD1)->D1_DESPESA +; 
					    			(cAliasSD1)->D1_VALIPI + (cAliasSD1)->D1_ICMSRET //variavel que ira acumular o valo total de Notas de devolução (considera frete seguro e despesa)  
						aAdd(aFatDes,{(cAliasSD1)->D1_DOC,(cAliasSD1)->D1_SERIE,(cAliasSD1)->D1_TIPO,(cAliasSD1)->D1_EMISSAO,((cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC) + (cAliasSD1)->D1_VALFRE + (cAliasSD1)->D1_SEGURO + (cAliasSD1)->D1_DESPESA,;
									(cAliasSD1)->D1_NFORI,(cAliasSD1)->D1_SERIORI, (cAliasSD1)->D1_CF})	 
						If SubStr(SD2->D2_CF,1,1) <> "7" .AND. (Posicione("SB5",1,xFilial("SB5")+(cAliasSD1)->D1_COD,"B5_INSPAT") == "1")					
					 	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Soma os valores por codigo de atividade no array aTotFisDev ³
						//³[1] Código de atividade                                 	   ³
						//³[2] Valor Bruto devolução por código atividade              ³
						//³[3] Valor Bruto devolução de Exportação por cód de atividade³
						//³[4] Valor devolução liq + frete + seguro + despesa     	   ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If lB5VerInd
								If ((Posicione("SB5",1,xFilial("SB5")+(cAliasSD1)->D1_COD,"B5_VERIND") == "1" .And. AllTrim(SD2->D2_CF) $cCFIND) .OR. Posicione("SB5",1,xFilial("SB5")+(cAliasSD1)->D1_COD,"B5_VERIND") <> "1")						 	
							 		cCodAtiv := Posicione("SB5",1,xFilial("SB5")+(cAliasSD1)->D1_COD,"B5_CODATIV")
									If !Empty(cCodAtiv)	
										nPosFis := aScan(aTotFisDev,{|x| Alltrim(x[1]) == Alltrim(cCodAtiv)})
										If nPosFis == 0
											aAdd(aTotFisDev,{cCodAtiv,((cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_VALFRE +; 
																		(cAliasSD1)->D1_SEGURO + (cAliasSD1)->D1_DESPESA+ (cAliasSD1)->D1_VALIPI +; 
																		(cAliasSD1)->D1_ICMSRET),0,(cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC +; 
																		(cAliasSD1)->D1_VALFRE + (cAliasSD1)->D1_SEGURO + (cAliasSD1)->D1_DESPESA})
										Else
											aTotFisDev[nPosFis][2]+=((cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_VALFRE +; 
																		(cAliasSD1)->D1_SEGURO + (cAliasSD1)->D1_DESPESA + (cAliasSD1)->D1_VALIPI + (cAliasSD1)->D1_ICMSRET)
											aTotFisDev[nPosFis][4]+=((cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_VALFRE +; 
																		(cAliasSD1)->D1_SEGURO + (cAliasSD1)->D1_DESPESA)						 
										EndIf
									EndIf
							  	EndIf
							Else	
								cCodAtiv := Posicione("SB5",1,xFilial("SB5")+(cAliasSD1)->D1_COD,"B5_CODATIV")
								If !Empty(cCodAtiv)	
									nPosFis := aScan(aTotFisDev,{|x| Alltrim(x[1]) == Alltrim(cCodAtiv)})
									If nPosFis == 0
										aAdd(aTotFisDev,{cCodAtiv,((cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_VALFRE +; 
																	(cAliasSD1)->D1_SEGURO + (cAliasSD1)->D1_DESPESA+ (cAliasSD1)->D1_VALIPI +; 
																	(cAliasSD1)->D1_ICMSRET),0,(cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC +; 
																	(cAliasSD1)->D1_VALFRE + (cAliasSD1)->D1_SEGURO + (cAliasSD1)->D1_DESPESA})
									Else
										aTotFisDev[nPosFis][2]+=((cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_VALFRE +; 
																	(cAliasSD1)->D1_SEGURO + (cAliasSD1)->D1_DESPESA + (cAliasSD1)->D1_VALIPI + (cAliasSD1)->D1_ICMSRET)
										aTotFisDev[nPosFis][4]+=((cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_VALFRE +; 
																	(cAliasSD1)->D1_SEGURO + (cAliasSD1)->D1_DESPESA)						 
									EndIf
								EndIf
							EndIf
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Verifico as devoluções de exportações que possuem codigo de atividade e 	  ³
						//³atribuo a posição 3 do array aTotFisDev. Também será tratado itens de      |
						//| export por cod de ativ na posição 2 do aTotFisDev(Soma tot por cod ativ)  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						ElseIf SubStr(SD2->D2_CF,1,1) == "7" 
							//nFatExp+= (cAliasSD1)->D1_TOTAL 
							If(Posicione("SB5",1,xFilial("SB5")+(cAliasSD1)->D1_COD,"B5_INSPAT") == "1") 
								If lB5VerInd
									If ((Posicione("SB5",1,xFilial("SB5")+(cAliasSD1)->D1_COD,"B5_VERIND") == "1" .And. AllTrim(SD2->D2_CF) $cCFIND) .OR. Posicione("SB5",1,xFilial("SB5")+(cAliasSD1)->D1_COD,"B5_VERIND") <> "1")						 	
										cCodAtiv := Posicione("SB5",1,xFilial("SB5")+(cAliasSD1)->D1_COD,"B5_CODATIV")
										If !Empty(cCodAtiv)	
											nPosFis := aScan(aTotFisDev,{|x| Alltrim(x[1]) == Alltrim(cCodAtiv)})
											If nPosFis == 0
												aAdd(aTotFisDev,{cCodAtiv,((cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_VALFRE +;
												 				(cAliasSD1)->D1_SEGURO + (cAliasSD1)->D1_DESPESA + (cAliasSD1)->D1_VALIPI + (cAliasSD1)->D1_ICMSRET),;
												 				((cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_VALFRE + (cAliasSD1)->D1_SEGURO +; 
												 				(cAliasSD1)->D1_DESPESA + (cAliasSD1)->D1_VALIPI + (cAliasSD1)->D1_ICMSRET),;
												 				((cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_VALFRE +; 
																(cAliasSD1)->D1_SEGURO + (cAliasSD1)->D1_DESPESA)})
											Else
												aTotFisDev[nPosFis][2]+=((cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_VALFRE +; 
																		(cAliasSD1)->D1_SEGURO + (cAliasSD1)->D1_DESPESA + (cAliasSD1)->D1_VALIPI + (cAliasSD1)->D1_ICMSRET)
												aTotFisDev[nPosFis][3]+=((cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_VALFRE +; 
																		(cAliasSD1)->D1_SEGURO + (cAliasSD1)->D1_DESPESA + (cAliasSD1)->D1_VALIPI + (cAliasSD1)->D1_ICMSRET)						
												aTotFisDev[nPosFis][4]+=((cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_VALFRE +; 
																		(cAliasSD1)->D1_SEGURO + (cAliasSD1)->D1_DESPESA)						
											EndIf
										EndIf
									EndIf 
								Else
									cCodAtiv := Posicione("SB5",1,xFilial("SB5")+(cAliasSD1)->D1_COD,"B5_CODATIV")
									If !Empty(cCodAtiv)	
										nPosFis := aScan(aTotFisDev,{|x| Alltrim(x[1]) == Alltrim(cCodAtiv)})
										If nPosFis == 0
											aAdd(aTotFisDev,{cCodAtiv,((cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_VALFRE +;
											 				(cAliasSD1)->D1_SEGURO + (cAliasSD1)->D1_DESPESA + (cAliasSD1)->D1_VALIPI + (cAliasSD1)->D1_ICMSRET),;
											 				((cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_VALFRE + (cAliasSD1)->D1_SEGURO +; 
											 				(cAliasSD1)->D1_DESPESA + (cAliasSD1)->D1_VALIPI + (cAliasSD1)->D1_ICMSRET),;
											 				((cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_VALFRE +; 
															(cAliasSD1)->D1_SEGURO + (cAliasSD1)->D1_DESPESA)})
										Else
											aTotFisDev[nPosFis][2]+=((cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_VALFRE +; 
																	(cAliasSD1)->D1_SEGURO + (cAliasSD1)->D1_DESPESA + (cAliasSD1)->D1_VALIPI + (cAliasSD1)->D1_ICMSRET)
											aTotFisDev[nPosFis][3]+=((cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_VALFRE +; 
																	(cAliasSD1)->D1_SEGURO + (cAliasSD1)->D1_DESPESA + (cAliasSD1)->D1_VALIPI + (cAliasSD1)->D1_ICMSRET)						
											aTotFisDev[nPosFis][4]+=((cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_VALFRE +; 
																	(cAliasSD1)->D1_SEGURO + (cAliasSD1)->D1_DESPESA)						
										EndIf
									EndIf
								EndIf			
							EndIf
						EndIf
					EndIf		
				EndIf					
		        (cAliasSD1)->(dbSkip())
			EndDo
		EndIf
		RhInssLogb(aFatDes, cPeriodo, cFilProc, l13Sal)   
	#ELSE
				
	If SB5->(FieldPos('B5_INSPAT')) > 0 .AND. SB5->(FieldPos('B5_CODATIV')) > 0				
		cIndexD1  := CriaTrab(NIL,.F.)
		cKeyD1    := 'D1_DOC, D1_SERIE, D1_COD, D1_NFORI, D1_SERIORI '
		cFilterD1 := 'D1_FILIAL == "'+ xFilial("SD1") +'" .And. (Dtos(D1_DTDIGIT) >= "'+Dtos(dPerIni)+'" .And. Dtos(D1_DTDIGIT) <= "'+Dtos(dPerFim)+'")'
		cFilterD1 += '.And. D1_TIPO  $ ("D|C") '
		
		dbSelectArea("SD1") 	 			 			 
		IndRegua("SD1",cIndexD1,cKeyD1,,cFilterD1,)
		nIndexD1 := RetIndex("SD1")
		dbSetIndex(cIndexD1+OrdBagExt())
		dbSetOrder(nIndexD1+1)
		dbGotop()

		While !SD1->( EOF() )
			SD2->(dbSetOrder(3))
			If SD2->(dbSeek(xFilial("SD2")+SD1->D1_NFORI + SD1->D1_SERIORI))
				If (Alltrim(SD2->D2_CF)$ aCFOPs[1] .And. !Alltrim(SD2->D2_CF)$ aCFOPs[2]) .And. SD2->D2_EMISSAO >= CTOD("01"+"/"+SUBSTR(cIniDes,5,6)+"/"+SUBSTR(cIniDes,1,4)) 
					nTotDev	+= (SD1->D1_TOTAL - SD1->D1_VALDESC + SD1->D1_VALFRE + SD1->D1_SEGURO + SD1->D1_DESPESA +; 
								SD1->D1_VALIPI + SD1->D1_ICMSRET)	//variavel que ira acumular o valo total de Notas de devolução 
					aAdd(aFatDes,{ SD1->D1_DOC, SD1->D1_SERIE, SD1->D1_TIPO,DTOS(SD1->D1_EMISSAO),; 
								(SD1->D1_TOTAL - SD1->D1_VALDESC + SD1->D1_VALFRE + SD1->D1_SEGURO + SD1->D1_DESPESA),; 
								 SD1->D1_NFORI,SD1->D1_SERIORI, SD1->D1_CF})	 
					If SubStr(SD2->D2_CF,1,1) <> "7" .AND. (Posicione("SB5",1,xFilial("SB5")+SD1->D1_COD,"B5_INSPAT") == "1")
						If lB5VerInd
							If ((Posicione("SB5",1,xFilial("SB5")+SD1->D1_COD,"B5_VERIND") == "1" .And. AllTrim(SD2->D2_CF) $cCFIND) .OR. Posicione("SB5",1,xFilial("SB5")+SD1->D1_COD,"B5_VERIND") <> "1")						 							
						  		cCodAtiv := Posicione("SB5",1,xFilial("SB5")+SD1->D1_COD,"B5_CODATIV")
								If !Empty(cCodAtiv)	
									nPosFis := aScan(aTotFisDev,{|x| Alltrim(x[1]) == Alltrim(cCodAtiv)})
									If nPosFis == 0
										aAdd(aTotFisDev,{cCodAtiv,(SD1->D1_TOTAL - SD1->D1_VALDESC + SD1->D1_VALFRE + SD1->D1_SEGURO +; 
																	SD1->D1_DESPESA + SD1->D1_VALIPI + SD1->D1_ICMSRET),0,;
																	(SD1->D1_TOTAL - SD1->D1_VALDESC + SD1->D1_VALFRE + SD1->D1_SEGURO +; 
																	SD1->D1_DESPESA)})
									Else
										aTotFisDev[nPosFis][2]+=(SD1->D1_TOTAL - SD1->D1_VALDESC + SD1->D1_VALFRE +	SD1->D1_SEGURO +; 
																	SD1->D1_DESPESA + SD1->D1_VALIPI + SD1->D1_ICMSRET)
										aTotFisDev[nPosFis][4]+=(SD1->D1_TOTAL - SD1->D1_VALDESC + SD1->D1_VALFRE + SD1->D1_SEGURO +; 
																	SD1->D1_DESPESA)
									EndIf
								EndIf
							EndIf
						Else
							cCodAtiv := Posicione("SB5",1,xFilial("SB5")+SD1->D1_COD,"B5_CODATIV")
							If !Empty(cCodAtiv)	
								nPosFis := aScan(aTotFisDev,{|x| Alltrim(x[1]) == Alltrim(cCodAtiv)})
								If nPosFis == 0
									aAdd(aTotFisDev,{cCodAtiv,(SD1->D1_TOTAL - SD1->D1_VALDESC + SD1->D1_VALFRE + SD1->D1_SEGURO +; 
																SD1->D1_DESPESA + SD1->D1_VALIPI + SD1->D1_ICMSRET),0,;
																(SD1->D1_TOTAL - SD1->D1_VALDESC + SD1->D1_VALFRE + SD1->D1_SEGURO +; 
																SD1->D1_DESPESA)})
								Else
									aTotFisDev[nPosFis][2]+=(SD1->D1_TOTAL - SD1->D1_VALDESC + SD1->D1_VALFRE +	SD1->D1_SEGURO +; 
																SD1->D1_DESPESA + SD1->D1_VALIPI + SD1->D1_ICMSRET)
									aTotFisDev[nPosFis][4]+=(SD1->D1_TOTAL - SD1->D1_VALDESC + SD1->D1_VALFRE + SD1->D1_SEGURO +; 
																SD1->D1_DESPESA)
								EndIf
							EndIf		
						EndIf	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifico as devoluções de exportações que possuem codigo de atividade e 	  ³
					//³atribuo a posição 3 do array aTotFisDev. Também será tratado itens de      |
					//| export por cod de ativ na posição 2 do aTotFisDev(Soma tot por cod ativ)  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					ElseIf SubStr(SD1->D1_CF,1,1) == "7" 
						//nFatExp+= (cAliasSD1)->D1_TOTAL 
						If(Posicione("SB5",1,xFilial("SB5")+SD1->D1_COD,"B5_INSPAT") == "1") 
							If lB5VerInd
								If ((Posicione("SB5",1,xFilial("SB5")+SD1->D1_COD,"B5_VERIND") == "1" .And. AllTrim(SD2->D2_CF) $cCFIND) .OR. Posicione("SB5",1,xFilial("SB5")+SD1->D1_COD,"B5_VERIND") <> "1")						 	
									cCodAtiv := Posicione("SB5",1,xFilial("SB5")+SD1->D1_COD,"B5_CODATIV")
									If !Empty(cCodAtiv)	
										nPosFis := aScan(aTotFisDev,{|x| Alltrim(x[1]) == Alltrim(cCodAtiv)})
										If nPosFis == 0
											aAdd(aTotFisDev,{cCodAtiv, SD1->D1_TOTAL - SD1->D1_VALDESC + SD1->D1_VALFRE +; 
														SD1->D1_SEGURO + SD1->D1_DESPESA+ SD1->D1_VALIPI + SD1->D1_ICMSRET,; 
														SD1->D1_TOTAL - SD1->D1_VALDESC + SD1->D1_VALFRE + SD1->D1_SEGURO +; 
														SD1->D1_DESPESA + SD1->D1_VALIPI + SD1->D1_ICMSRET,;
														SD1->D1_TOTAL - SD1->D1_VALDESC + SD1->D1_VALFRE +	SD1->D1_SEGURO + SD1->D1_DESPESA})
										Else
											aTotFisDev[nPosFis][2]+=(SD1->D1_TOTAL - SD1->D1_VALDESC+ SD1->D1_VALFRE +; 
														SD1->D1_SEGURO + SD1->D1_DESPESA)
											aTotFisDev[nPosFis][3]+=(SD1->D1_TOTAL - SD1->D1_VALDESC+ SD1->D1_VALFRE +; 
														SD1->D1_SEGURO + SD1->D1_DESPESA)
											aTotFisDev[nPosFis][4]+=(SD1->D1_TOTAL - SD1->D1_VALDESC + SD1->D1_VALFRE + SD1->D1_SEGURO +; 
																	SD1->D1_DESPESA)
										EndIf
									EndIf
								EndIf	
							Else
								cCodAtiv := Posicione("SB5",1,xFilial("SB5")+SD1->D1_COD,"B5_CODATIV")
								If !Empty(cCodAtiv)	
									nPosFis := aScan(aTotFisDev,{|x| Alltrim(x[1]) == Alltrim(cCodAtiv)})
									If nPosFis == 0
										aAdd(aTotFisDev,{cCodAtiv, SD1->D1_TOTAL - SD1->D1_VALDESC + SD1->D1_VALFRE +; 
													SD1->D1_SEGURO + SD1->D1_DESPESA+ SD1->D1_VALIPI + SD1->D1_ICMSRET,; 
													SD1->D1_TOTAL - SD1->D1_VALDESC + SD1->D1_VALFRE + SD1->D1_SEGURO +; 
													SD1->D1_DESPESA + SD1->D1_VALIPI + SD1->D1_ICMSRET,;
													SD1->D1_TOTAL - SD1->D1_VALDESC + SD1->D1_VALFRE +	SD1->D1_SEGURO + SD1->D1_DESPESA})
									Else
										aTotFisDev[nPosFis][2]+=(SD1->D1_TOTAL - SD1->D1_VALDESC+ SD1->D1_VALFRE +; 
													SD1->D1_SEGURO + SD1->D1_DESPESA)
										aTotFisDev[nPosFis][3]+=(SD1->D1_TOTAL - SD1->D1_VALDESC+ SD1->D1_VALFRE +; 
													SD1->D1_SEGURO + SD1->D1_DESPESA)
										aTotFisDev[nPosFis][4]+=(SD1->D1_TOTAL - SD1->D1_VALDESC + SD1->D1_VALFRE + SD1->D1_SEGURO +; 
																SD1->D1_DESPESA)
									EndIf
								EndIf
							EndIf		
						EndIf
					EndIf
				EndIf		
			EndIf	    			
	        SD1->(dbSkip())
		EndDo
		FErase(cIndexD1+OrdBagExt())
	EndIf 
	RhInssLog(aFatDes, cPeriodo, cFilProc, l13Sal)        
	dbSelectArea("SD1") 
	RetIndex("SD1")
	
	#ENDIF
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³A estrutura da tabela temporária foi criada de acordo com Registro P100 (Contribuição Previdenciária sobre a Receita Bruta) ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Cria a estrutura do arquivo de trabalho ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAdd(aCampos,{"TOTAL"		,"N",TAMSX3("D2_TOTAL")[1],2})		// TOTAL
	aAdd(aCampos,{"TOTALDEV"	,"N",TAMSX3("D2_TOTAL")[1],2})	    // TOTAL DEVOLUÇÃO
	aAdd(aCampos,{"TOTALEXP"	,"N",TAMSX3("D2_TOTAL")[1],2})	    // TOTAL EXPORTAÇÃO
	aAdd(aCampos,{"CODATV"		,"C",TAMSX3("B5_CODATIV")[1],2})  	// CODIGO ATIVIDADE
	aAdd(aCampos,{"TOTCODAT"	,"N",TAMSX3("D2_TOTAL")[1],2})     // TOTAL CODIGO ATIVIDADE BRUTO
   aAdd(aCampos,{"TCODATLQ"	,"N",TAMSX3("D2_TOTAL")[1],2})     // TOTAL CODIGO ATIVIDADE LIQUIDO
	aAdd(aCampos,{"TCATVDEV"	,"N",TAMSX3("D2_TOTAL")[1],2})     // TOTAL DEV CODIGO ATIVIDADE
	aAdd(aCampos,{"TCATVEXP" 	,"N",TAMSX3("D2_TOTAL")[1],2})     // TOTAL EXPORTAÇÕES POR CODIGO DE ATIVIDADE
	aAdd(aCampos,{"TCATVDVEX" 	,"N",TAMSX3("D2_TOTAL")[1],2})     // TOTAL DE DEVOLUÇÕES DE EXPORTAÇÕES POR CODIGO DE ATIVIDADE
	aAdd(aCampos,{"TCDEVEXP"	,"N",TAMSX3("D2_TOTAL")[1],2})     // TOTAL COD ATIV - DEVOLUÇÃO - EXPÓRTAÇÃO
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Cria o arquivo de trabalho³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	cTrab := CriaTrab(aCampos)
	cIndTemp1:=Substr(cTrab,1,7)+"1"
	dbUseArea(.T.,,cTrab,"TRBFAT",.F.,.F.)
	IndRegua("TRBFAT",cIndTemp1,"CODATV")
	DbSetIndex(cIndTemp1+OrdBagExt())
	TRBFAT->(dbGoTop())
	
	If Len(aTotFis)== 0	.And. Len(aTotFisDev)== 0	 
		RecLock("TRBFAT", .T.)	
		TRBFAT->TOTAL		:= nFatBrut    			// valor total BRUTO geral das notas
	   TRBFAT->TOTALDEV 	:= nTotDev 				// Valor total de devoluções
	   RBFAT->TOTALEXP 	:= nFatExp 				// Valor total de exportações 
	   TRBFAT->(MsUnlock())
    ElseIf Len(aTotFis)> 0	
		For nx:= 1 to Len(aTotFis)
			nImpostos := 0
			RecLock("TRBFAT", .T.)
			TRBFAT->TOTAL		:= nFatBrut    			// valor total BRUTO geral das notas
		   TRBFAT->TOTALDEV 	:= nTotDev 				// Valor total BRUTO de devoluções
		   TRBFAT->TOTALEXP 	:= nFatExp 				// Valor total BRUTO de exportações 
			// Totais por código de atividade
			TRBFAT->CODATV		:= aTotFis[nx][1] 		// Código de atividade
			TRBFAT->TOTCODAT	:= aTotFis[nx][2] 		// Valor total BRUTO do código de atividade
			TRBFAT->TCODATLQ	:= aTotFis[nx][4] 		// Valor total LIQ do código de atividade
			// Verifica se existe alguma nota de devolução para o código de atividade posicionado.
			nPosFis := aScan(aTotFisDev,{|x| Alltrim(x[1]) == Alltrim(aTotFis[nx][1])})
			If nPosFis > 0
				TRBFAT->TCATVDEV:= aTotFisDev[nPosFis][4]// Nota de devolução (tem que ser o valor liq, pois para desoner não inclui impostos quando tem cod atividade)
		    Else
		        TRBFAT->TCATVDEV:= 0
		    EndIf
		    TRBFAT->TCATVEXP		:= aTotFis[nx][3] // Total Exportação por Código de atividade(Saida) 
		    // Verifica se existe alguma nota de devolução de exportação para o código de atividade posicionado.
		    nPosDev := aScan(aTotFisDev,{|x| Alltrim(x[1]) == Alltrim(aTotFis[nx][1])})
			If nPosDev > 0
		    	TRBFAT->TCATVDVEX	:= aTotFisDev[nPosDev][3]// Nota de devolução de exportação 
		    Else 
			   TRBFAT->TCATVDVEX	:= 0
		    EndIf
		    nImpostos := TRBFAT->TOTCODAT - TRBFAT->TCODATLQ	
		    TRBFAT->TCDEVEXP   		:= TRBFAT->TOTCODAT - TRBFAT->TCATVDEV - TRBFAT->TCATVEXP + TRBFAT->TCATVDVEX - nImpostos  // Total por Código de atividade - devolução - exportação
			TRBFAT->(MsUnlock())
		Next(nX)
	ElseIf Len(aTotFisDev)> 0 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tratamento para caso haja apenas devolução no periodo.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nx:= 1 to Len(aTotFisDev) 
			nImpostos := 0
			RecLock("TRBFAT", .T.)
			TRBFAT->TOTAL		:= nFatBrut    			// valor total geral das notas
		    TRBFAT->TOTALDEV 	:= nTotDev 				// Valor total de devoluções
		    TRBFAT->TOTALEXP 	:= nFatExp 				// Valor total de exportações 
			// Totais por código de atividade
			TRBFAT->CODATV		:= aTotFisDev[nx][1] 		// Código de atividade
			TRBFAT->TOTCODAT	:= aTotFisDev[nx][2] 		// Valor total do código de atividade
			TRBFAT->TCODATLQ	:= aTotFisDev[nx][4] 		// Valor total LIQ DEVOLUCAO do código de atividade
			// Verifica se existe alguma nota de devolução para o código de atividade posicionado.
			nPosFis := aScan(aTotFisDev,{|x| Alltrim(x[1]) == Alltrim(aTotFisDev[nx][1])})
			If nPosFis > 0
				TRBFAT->TCATVDEV:= aTotFisDev[nPosFis][4]// Nota de devolução (tem que ser o valor liq, pois para desoner não inclui impostos quando tem cod atividade)
		    Else
		        TRBFAT->TCATVDEV:= 0
		    EndIf
		    TRBFAT->TCATVEXP		:= aTotFisDev[nx][3] // Total Exportação por Código de atividade(Saida) 
		    // Verifica se existe alguma nota de devolução de exportação para o código de atividade posicionado.
		    nPosDev := aScan(aTotFisDev,{|x| Alltrim(x[1]) == Alltrim(aTotFisDev[nx][1])})
			If nPosDev > 0
		    	TRBFAT->TCATVDVEX	:= aTotFisDev[nPosDev][3]// Nota de devolução de exportação 
		    Else 
			   TRBFAT->TCATVDVEX	:= 0
		    EndIf
		    nImpostos := TRBFAT->TOTCODAT - TRBFAT->TCODATLQ	
		    TRBFAT->TCDEVEXP   		:= TRBFAT->TOTCODAT - TRBFAT->TCATVDEV - TRBFAT->TCATVEXP + TRBFAT->TCATVDVEX - nImpostos  // Total por Código de atividade - devolução - exportação
			TRBFAT->(MsUnlock())
		Next(nX)
	EndIf	
EndIf

//dbSelectArea("TRBFAT")
//Copy to TESTE.DBF SDF

RestArea(aArea)
Return("TRBFAT")//Retorna o arquivo de trabalho  

//--------------------------------------------

Static Function RhInssLogb(aFatDes, cPeriodo, cFilProc, l13Sal)

Local cNomeArq	:= "FAT" 
Local cArq13Sal	:= "13Sal" 
Local cArqBkp	:= "" 
Local nx		:= 0 
Local aEstru	:= {} 
Local cExtAux	:= GetDBExtension()

aAdd(aEstru,{"NumNF"		,"C",TAMSX3("D2_DOC")[1],2})	
aAdd(aEstru,{"Serie"		,"C",TAMSX3("D2_SERIE")[1],2})
aAdd(aEstru,{"Tipo"			,"C",TAMSX3("D2_TIPO")[1],2})
aAdd(aEstru,{"DataNF"		,"C",TAMSX3("D2_DTDIGIT")[1],2})
aAdd(aEstru,{"CFOP" 		,"C",TAMSX3("D2_CF")[1],2})
aAdd(aEstru,{"Total"		,"N",TAMSX3("D2_TOTAL")[1],2}) 
aAdd(aEstru,{"NFOri"		,"C",TAMSX3("D2_DOC")[1],2})	
aAdd(aEstru,{"SerieOri"		,"C",TAMSX3("D2_SERIE")[1],2})

//Verifica se o arquivo já existe e deleta o mesmo
cArqBkp:= "FAT"+cExtAux
 	If File(cArqBkp)
	Ferase(cArqBkp)
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria o arquivo de trabalho³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
dbcreate(cNomeArq+cExtAux,aEstru, __LocalDriver)
dbUseArea(.T.,__LocalDriver,cNomeArq,cNomeArq) 	                	
IndRegua(cNomeArq,cNomeArq,"NumNF")

FAT->(dbGoTop())
For nx:= 1 to Len(aFatDes)
	RecLock(cNomeArq, .T.)	
	FAT->NUMNF		:= aFatDes[nX][1]    
	FAT->SERIE		:= aFatDes[nx][2] 	
	FAT->TIPO		:= aFatDes[nx][3] 	
 	FAT->DATANF		:= aFatDes[nx][4] 	 	
	FAT->TOTAL		:= aFatDes[nx][5] 	
	FAT->NFORI		:= aFatDes[nx][6] 	
	FAT->SERIEORI	:= aFatDes[nx][7]
	FAT->CFOP		:= aFatDes[nx][8] 	 	

	FAT->(MsUnlock())
Next(nX)
FAT->(dbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifico se o arquivo a ser gerado é referente ao decimo terceiro salário³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !l13Sal
	If file(cNomeArq+cFilProc+"DES"+CPERIODO+cExtAux) // verifico se já existe um arquivo com o nome a ser gerado
		FErase(cNomeArq+cFilProc+"DES"+CPERIODO+cExtAux) // Deleta o arquivo
		FRename(cNomeArq+cExtAux,cNomeArq+cFilProc+"DES"+CPERIODO+cExtAux) // Renomeia o arquivo	
	Else
		FRename(cNomeArq+cExtAux,cNomeArq+cFilProc+"DES"+CPERIODO+cExtAux)
	EndIf
Else
	If file(cNomeArq+cFilProc+"DES"+cArq13Sal+cExtAux) // verifico se já existe um arquivo com o nome a ser gerado
		FErase(cNomeArq+cFilProc+"DES"+cArq13Sal+cExtAux) // Deleta o arquivo
		FRename(cNomeArq+cExtAux,cNomeArq+cFilProc+"DES"+cArq13Sal+cExtAux) // Renomeia o arquivo	
	Else
		FRename(cNomeArq+cExtAux,cNomeArq+cFilProc+"DES"+cArq13Sal+cExtAux)
	EndIf
EndIf

Return