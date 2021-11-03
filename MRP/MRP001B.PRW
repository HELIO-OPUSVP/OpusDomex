//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Mauricio Lima de Souza - 09/06/14 - OpusVp                                                                                                       //   
//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Especifico Domex                                                                                                                                 //
//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Gera��o tabela temporaria MRP  (Tabela ZHB010)                                                                                                   //
//-------------------------------------------------------------------------------------------------------------------------------------------------//

#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

User Function mrp001B()

Local   cQuery    := ""
Local   cAlias    :="TRB"
LOCAL   nPERIODO  :=0
LOCAL   nX        :=0
LOCAL   nZ        :=0

PRIVATE nLTIME    :=0  //LEAD TIME
PRIVATE nLOTEE    :=0  //LOTE ECONOMICO
PRIVATE _nQTDESTR :=0
PRIVATE _cCOMP    := SPACE(15)
PRIVATE cIDMRP    := SPACE(09)

SC2->( dbSetOrder(1) )

cQUERY1:=" DELETE FROM ZHB010  "
TCSQLEXEC(cQUERY1)

// SHA010 HA_TIPO='6' NECESSIDADE COM HA_PER >0
//cQuery := " SELECT * FROM SHA010 WHERE HA_TIPO='6' "
//cQuery += " AND ( HA_PER001>0 OR HA_PER002>0 OR HA_PER003>0 OR HA_PER004>0 OR HA_PER005>0 OR   "
//cQuery += "       HA_PER006>0 OR HA_PER007>0 OR HA_PER008>0 OR HA_PER009>0 OR HA_PER010>0 OR   "
//cQuery += "       HA_PER011>0 OR HA_PER012>0 OR HA_PER013>0 OR HA_PER014>0 OR HA_PER015>0 OR   "
//cQuery += "       HA_PER016>0 OR HA_PER017>0 OR HA_PER018>0 OR HA_PER019>0 OR HA_PER020>0 OR   "
//cQuery += "       HA_PER021>0 OR HA_PER022>0 OR HA_PER023>0 OR HA_PER024>0 OR HA_PER025>0 OR   "
//cQuery += "       HA_PER026>0 OR HA_PER027>0 OR HA_PER028>0 OR HA_PER029>0 OR HA_PER030>0 OR   "
//cQuery += "       HA_PER031>0 OR HA_PER032>0 OR HA_PER033>0 OR HA_PER034>0 OR HA_PER035>0 OR   "
//cQuery += "       HA_PER036>0 OR HA_PER037>0 OR HA_PER038>0 OR HA_PER039>0 OR HA_PER040>0 OR   "
//cQuery += "       HA_PER041>0 OR HA_PER042>0 OR HA_PER043>0 OR HA_PER044>0 OR HA_PER045>0 OR   "
//cQuery += "       HA_PER046>0 OR HA_PER047>0 OR HA_PER048>0 OR HA_PER049>0 OR HA_PER050>0 OR   "
//cQuery += "       HA_PER051>0 OR HA_PER052>0 OR HA_PER053>0 OR HA_PER054>0 OR HA_PER055>0 OR   "
//cQuery += "       HA_PER056>0 OR HA_PER057>0 OR HA_PER058>0 OR HA_PER059>0 OR HA_PER060>0    ) "

cQuery := " SELECT * FROM SHA010 ,SB1010 "
cQuery += " WHERE HA_PRODUTO=B1_COD "
cQuery += " AND   B1_TIPO NOT IN ('MO')  "
cQuery += " AND  HA_TIPO='6'  "
cQuery += " AND ( HA_PER001>0 OR HA_PER002>0 OR HA_PER003>0 OR HA_PER004>0 OR HA_PER005>0 OR    "
cQuery += "       HA_PER006>0 OR HA_PER007>0 OR HA_PER008>0 OR HA_PER009>0 OR HA_PER010>0 OR    "
cQuery += "       HA_PER011>0 OR HA_PER012>0 OR HA_PER013>0 OR HA_PER014>0 OR HA_PER015>0 OR    "
cQuery += "       HA_PER016>0 OR HA_PER017>0 OR HA_PER018>0 OR HA_PER019>0 OR HA_PER020>0 OR    "
cQuery += "       HA_PER021>0 OR HA_PER022>0 OR HA_PER023>0 OR HA_PER024>0 OR HA_PER025>0 OR    "
cQuery += "       HA_PER026>0 OR HA_PER027>0 OR HA_PER028>0 OR HA_PER029>0 OR HA_PER030>0 OR    "
cQuery += "       HA_PER031>0 OR HA_PER032>0 OR HA_PER033>0 OR HA_PER034>0 OR HA_PER035>0 OR    "
cQuery += "       HA_PER036>0 OR HA_PER037>0 OR HA_PER038>0 OR HA_PER039>0 OR HA_PER040>0 OR    "
cQuery += "       HA_PER041>0 OR HA_PER042>0 OR HA_PER043>0 OR HA_PER044>0 OR HA_PER045>0 OR    "
cQuery += "       HA_PER046>0 OR HA_PER047>0 OR HA_PER048>0 OR HA_PER049>0 OR HA_PER050>0 OR    "
cQuery += "       HA_PER051>0 OR HA_PER052>0 OR HA_PER053>0 OR HA_PER054>0 OR HA_PER055>0 OR    "
cQuery += "       HA_PER056>0 OR HA_PER057>0 OR HA_PER058>0 OR HA_PER059>0 OR HA_PER060>0    )  "
cQuery += " ORDER BY HA_PRODUTO "

TcQuery cQuery Alias "TRB" New

("TRB")->(DbGoTop())

If TRB->(Eof())
	//	Alert("Nao foi encontrado nenhum item neste Processo !")
	DbSelectArea("TRB")
	TRB->(DbCloseArea())
	Return()
EndIf

cIDMRP :=TRB->HA_NUMMRP+'000'// INICIALIZADOR IDMRP

ZHB->(DBSELECTAREA('ZHB'))
ZHB->(DBSETORDER(2))

dDATA1:=(DATE())-1
dDATA2:=(DATE())-1
DO WHILE .NOT. TRB->(EOF()) //S� COM NECESSIDADE
	cTIPOB1 := POSICIONE('SB1',1,xFILIAL('SB1')+TRB->HA_PRODUTO,'B1_TIPO')
	FOR nX :=1 TO 60 //PERIODO
		nLTIME   :=0  //LEAD TIME
		nLOTEE   :=0  //LOTE ECONOMICO
		cTIPO   :=ALLTRIM('TRB->HA_PER'+ALLTRIM(STRZERO(nX,3)))
		//_cTIPO  :=ALLTRIM('HA_PER'+ALLTRIM(STRZERO(nX,3)))
		IF   ALLTRIM(cTIPOB1)$('PA|PI')    //&cTIPO<>0 //SOMENTE PERIODO COM NECESSIDADE
			//
		ELSE
			cQuery3 := " SELECT * FROM SHA010 WHERE HA_PRODUTO='"+TRB->HA_PRODUTO+"'   " // TODOS MOVIMENTOS PRODUTO COM NECESSIDADE
			TcQuery cQuery3 Alias "TR3" New
			("TR3")->(DbGoTop())
			If TR3->(Eof())
				TR3->(DbCloseArea())
			ELSE
				_cB1DESC  :=POSICIONE('SB1',1,xFILIAL('SB1')+TRB->HA_PRODUTO,'B1_DESC')
				_cB1TIPO  :=POSICIONE('SB1',1,xFILIAL('SB1')+TRB->HA_PRODUTO,'B1_TIPO')
				_cB1GRUPO :=POSICIONE('SB1',1,xFILIAL('SB1')+TRB->HA_PRODUTO,'B1_GRUPO')
				DO WHILE .NOT. TR3->(EOF())
					
					//--------------------------------------------------------------------------------------------------------------------
					cQuery5 := " SELECT * FROM SHA010 WHERE HA_PRODUTO='"+TRB->HA_PRODUTO+"' AND (  HA_PER"+ALLTRIM(STRZERO(nX,3))+" <>0 AND HA_TIPO IN ('2','3','4','6'))  "
					//SOMENTE PERIODO COM MOVIMENTACAO
					TcQuery cQuery5 Alias "TR5" New
					("TR5")->(DbGoTop())
					If TR5->(Eof())
						//TR5->(DbCloseArea())
					ELSE
						//--------------------------------------------------------------------------------------------------------------------
						cTIPO   :=ALLTRIM('TR3->HA_PER'+ALLTRIM(STRZERO(nX,3)))
						dDATA2  :=dDATA1+nX
						//IF  ALLTRIM(TR3->HA_TIPO) $('2|3|4')
						
						IF  ALLTRIM(TR3->HA_TIPO) $('4')
							aSHA :={}
							aSHA2:={}
							aSC4 :={}
							cQuery2 := " SELECT * FROM SH5010 WHERE H5_PRODUTO='"+TRB->HA_PRODUTO+"'  AND H5_PER='"+ALLTRIM(STRZERO(nX,3))+"'   "
							TcQuery cQuery2 Alias "TR2" New
							("TR2")->(DbGoTop())
							If TR2->(Eof())
								TR2->(DbCloseArea())
							ELSE
								DO WHILE .NOT. TR2->(EOF())
									U_MRPSHB(TR2->H5_DOC, TR2->H5_DATAORI, TR2->H5_PRODUTO, TR2->H5_ALIAS, TR2->H5_QUANT, TR2->R_E_C_N_O_, TR2->H5_PER)
									//AADD(aSC4,{TR2->H5_DOC,TR2->H5_DATAORI,TR2->H5_PRODUTO,TR2->H5_ALIAS,TR2->H5_QUANT,TR2->R_E_C_N_O_,TR2->H5_PER})
									TR2->(DBSKIP())
								ENDDO
								TR2->(DbCloseArea())
							ENDIF
							*--------------------------------------------------------------------------------------------------------------------
							IF LEN(ASC4)>0
								FOR nZ:=1 TO LEN(ASC4)
									cQuerySC4 := " SELECT C4_PRODUTO,C4_XXCOD,C4_DATA,C4_OBS,C4_QUANT,C4_XXNOMCL FROM SC4010 WHERE R_E_C_N_O_ IN ("+alltrim(str(ASC4[NZ][06]))+")"
									TcQuery cQuerySC4 Alias "TRSC4" New
									("TRSC4")->(DbGoTop())
									If TRSC4->(Eof())
										TRSC4->(DbCloseArea())
										_CTXT:=''
									ELSE
										//_CTXT:=alltrim(ASC4[NZ][01])+' - '+alltrim(TRSC4->C4_PRODUTO)+' COD: '+alltrim(TRSC4->C4_XXCOD)+ ' OBS: '+alltrim(TRSC4->C4_OBS)+ ' '+alltrim(TRSC4->C4_XXNOMCL)+space(120)//+' QTD:'+STR(TRSC4->C4_QUANT)
										_CTXT:=alltrim(TRSC4->C4_PRODUTO)+' Cod:'+alltrim(TRSC4->C4_XXCOD)+' Qtd:'+ alltrim(Transform(TRSC4->C4_QUANT,"@e 99,999.99"))+' Obs:'+alltrim(TRSC4->C4_OBS)+ ' '+alltrim(TRSC4->C4_XXNOMCL)+space(120)//+' QTD:'+Transform(TRSC4->C4_QUANT,"@e 99,999.99")STR(TRSC4->C4_QUANT)//mls
										_CTXT:=substr(_CTXT,1,119)
										
										SB1->(DBSELECTAREA('SB1'))
										SB1->(DBSETORDER(1))
										
										If SB1->(dbSeek( xFilial('SB1') + TRSC4->C4_PRODUTO ))
											_nQTDESTR := 0
											_cCOMP    := TR3->HA_PRODUTO
											dbSelectArea('SG1')
											MsSeek(xFilial('SG1')+TRSC4->C4_PRODUTO)
											MRExpl2(TRSC4->C4_PRODUTO,TRSC4->C4_QUANT,1,'',IF(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB")),SB1->B1_REVATU)
										ENDIF
										TRSC4->(DbCloseArea())
									ENDIF
									
									SB1->(DBSELECTAREA('SB1'))
									SB1->(DBSETORDER(1))
									
									
									If SB1->(dbSeek( xFilial('SB1') + TR3->HA_PRODUTO ))
										_cB1DESC  :=SB1->B1_DESC
										_cB1TIPO  :=SB1->B1_TIPO
										_cB1GRUPO :=SB1->B1_GRUPO
									ENDIF
									RecLock("ZHB",.T.)
									ZHB_FILIAL := xFILIAL('ZHB')
									ZHB_PERIOD := dDATA2
									ZHB_NUMMRP := TR3->HA_NUMMRP
									ZHB_PRODUT := TR3->HA_PRODUTO//ASC4[NZ][03]
									ZHB_DESC   := _cB1DESC
									ZHB_TIPOP  := _cB1TIPO
									ZHB_GRUPO  := _cB1GRUPO
									ZHB_NIVEL  := TR3->HA_NIVEL
									//ZHB_PRODSH :=TR3->HA_PRODSHW
									ZHB_OPC    := TR3->HA_OPC
									ZHB_REVISA := TR3->HA_REVISAO
									ZHB_REVSHW := TR3->HA_REVSHW
									cTIPOA :='09-Previsao Venda'
									ZHB_TIPO  := cTIPOA
									ZHB_TEXTO := alltrim(_CTXT)//ASC4[NZ][04]+' '+str(ASC4[NZ][06])//If(!Empty(cDocH5),cDocH5,Alltrim(TR2->H5_DOC) +'/'+ Alltrim(TR2->H5_ITEM))
									ZHB_TXDT1 := DTOC(dDATA2)
									ZHB_TXDT2 := dDATA2
									ZHB_TXDT1 := DTOC(dDATA2)
									ZHB_TXDT2 := dDATA2
									ZHB_SESTR := _nQTDESTR
									ZHB_XQTDE := _nQTDESTR
									ZHB->( msUnlock() )
								NEXT
								ASC4:={}
							ENDIF
							*--------------------------------------------------------------------------------------------------------------------
						ENDIF
						
						
						IF  ALLTRIM(TR3->HA_TIPO) $('2|3')
							DO CASE
								CASE ALLTRIM(TR3->HA_TIPO) ='2'
									cQuery2 := " SELECT * FROM SH5010 WHERE H5_PRODUTO='"+TRB->HA_PRODUTO+"'  AND H5_PER='"+ALLTRIM(STRZERO(nX,3))+"'  AND H5_ALIAS IN ('SC1','SC2','SC7')  "
								CASE ALLTRIM(TR3->HA_TIPO) ='3'
									cQuery2 := " SELECT * FROM SH5010 WHERE H5_PRODUTO='"+TRB->HA_PRODUTO+"'  AND H5_PER='"+ALLTRIM(STRZERO(nX,3))+"'  AND H5_ALIAS IN ('SC4','SC6','SD4')  "
								CASE ALLTRIM(TR3->HA_TIPO) ='4'
									cQuery2 := " SELECT * FROM SH5010 WHERE H5_PRODUTO='"+TRB->HA_PRODUTO+"'  AND H5_PER='"+ALLTRIM(STRZERO(nX,3))+"'  AND H5_ALIAS IN ('SHA')  "
							ENDCASE
							
							TcQuery cQuery2 Alias "TR2" New
							("TR2")->(DbGoTop())
							If TR2->(Eof())
								TR2->(DbCloseArea())
							ELSE
								DO WHILE .NOT. TR2->(EOF())
									IF  ALLTRIM(TR3->HA_TIPO) $ ('2|3') .AND. ALLTRIM(TR2->H5_ALIAS)$('SC1|SC2|SC7|SC4|SC6|SD4|SHA') //2=ENTRADA 3=SAIDA 4 SAIDA ESTRUTURA
										SB1->(DBSELECTAREA('SB1'))
										SB1->(DBSETORDER(1))
										If SB1->(dbSeek( xFilial('SB1') + TR3->HA_PRODUTO ))
											_cB1DESC  :=SB1->B1_DESC
											_cB1TIPO  :=SB1->B1_TIPO
											_cB1GRUPO :=SB1->B1_GRUPO
										ENDIF
										RecLock("ZHB",.T.)
										ZHB_FILIAL := xFILIAL('ZHB')
										ZHB_PERIOD := dDATA2
										ZHB_NUMMRP := TR3->HA_NUMMRP
										ZHB_PRODUT := TR3->HA_PRODUTO
										ZHB_DESC   := _cB1DESC
										ZHB_TIPOP  := _cB1TIPO
										ZHB_GRUPO  := _cB1GRUPO
										ZHB_NIVEL  := TR3->HA_NIVEL
										
										IF EMPTY(ZHB_PRODSH)
											ZHB_PRODSH :=TR3->HA_PRODSHW
										ENDIF
										
										ZHB_OPC    := TR3->HA_OPC
										ZHB_REVISA := TR3->HA_REVISAO
										ZHB_REVSHW := TR3->HA_REVSHW
										cTIPOA     := ''
										cDocH5     := ''
										
										DO CASE
											CASE  ALLTRIM(TR2->H5_ALIAS)=='SC1'
												cTIPOA := '03-Sol.Compras'
												cDocH5 := Alltrim(TR2->H5_DOC) +'/'+ Alltrim(TR2->H5_ITEM) //+ ' : ' + Alltrim(Str(TR2->H5_QUANT))
											CASE  ALLTRIM(TR2->H5_ALIAS)=='SC2'
												cTIPOA :='06-Ordem Producao'
												cDocH5 := Alltrim(TR2->H5_DOC) +'/'+ Alltrim(TR2->H5_ITEM)
											CASE  ALLTRIM(TR2->H5_ALIAS)=='SC4'
												cTIPOA :='09-Previsao Venda'
												cDocH5 := Alltrim(TR2->H5_DOC) +'/'+ Alltrim(TR2->H5_ITEM)
											CASE  ALLTRIM(TR2->H5_ALIAS)=='SC6'
												cTIPOA :='07-Pedido Venda'
												cDocH5 := Alltrim(TR2->H5_DOC) +'/'+ Alltrim(TR2->H5_ITEM)
											CASE  ALLTRIM(TR2->H5_ALIAS)=='SC7'
												cTIPOA :='04-Pedido Compra'
												cDocH5 := Alltrim(TR2->H5_DOC) +'/'+ Alltrim(TR2->H5_ITEM) //+' : ' + Alltrim(Str(TR2->H5_QUANT))
											CASE  ALLTRIM(TR2->H5_ALIAS)=='SD4'
												cTIPOA :='05-Empenho'
												cDocH5 := Alltrim(TR2->H5_DOC) +'/'+ Alltrim(TR2->H5_ITEM)
											CASE  ALLTRIM(TR2->H5_ALIAS)=='SHA'
												cTIPOA :='08-Saida Estrutura'
												cDocH5 := Alltrim(TR2->H5_DOC) +'/'+ Alltrim(TR2->H5_ITEM)
											CASE  ALLTRIM(TR2->H5_ALIAS)=='SB1'
												cTIPOA :='00-Seguranca'
												cDocH5 := Alltrim(TR2->H5_DOC) +'/'+ Alltrim(TR2->H5_ITEM)
										ENDCASE
										ZHB_TIPO  := cTIPOA
										ZHB_TEXTO := If(!Empty(cDocH5),cDocH5,Alltrim(TR2->H5_DOC) +'/'+ Alltrim(TR2->H5_ITEM))
										
										//ZHB_TXDT1 := SUBSTR(TR2->H5_DATAORI,7,2)+'/'+SUBSTR(TR2->H5_DATAORI,5,2)+'/'+SUBSTR(TR2->H5_DATAORI,1,4)
										//ZHB_TXDT2 := CTOD(SUBSTR(TR2->H5_DATAORI,7,2)+'/'+SUBSTR(TR2->H5_DATAORI,5,2)+'/'+SUBSTR(TR2->H5_DATAORI,1,4))
										//dDATA2
										ZHB_TXDT1 := DTOC(dDATA2)
										ZHB_TXDT2 := dDATA2
										
										IF ALLTRIM(TR2->H5_ALIAS)=='SHA'
											SC4->(DBSELECTAREA('SC4'))//PREVISAO DE VENDA
											SC4->(DBSETORDER(1))
											If SC4->(dbSeek( xFilial('SC4') + Alltrim(TR2->H5_DOC) + Alltrim(TR2->H5_ITEM) ))
												DO WHILE .NOT. SC4->(EOF()) .AND. alltrim(SC4->C4_PRODUTO)==ALLTRIM(TR2->H5_DOC)
													IF SC4->C4_QUANT > 0
														ZHB_TEXTO := ALLTRIM(ZHB_TEXTO)+' | PRE '+ALLTRIM(SC4->C4_OBS)+' '+ALLTRIM(DTOC(SC4->C4_DATA))+' '+ALLTRIM(STR(SC4->C4_QUANT))
													ENDIF
													SC4->(DBSKIP())
												ENDDO
											ENDIF
											SC6->(DBSELECTAREA('SC6')) // PEDIDO DE VENDA
											SC6->(DBSETORDER(2))
											If SC6->(dbSeek( xFilial('SC6') + Alltrim(TR2->H5_DOC) + Alltrim(TR2->H5_ITEM) ))
												DO WHILE .NOT. SC6->(EOF()) .AND. alltrim(SC6->C6_PRODUTO)==ALLTRIM(TR2->H5_DOC)
													IF (SC6->C6_QTDVEN-SC6->C6_QTDENT)>0 .AND. SC6->C6_OP=''
														ZHB_TEXTO:=ALLTRIM(ZHB_TEXTO)+' | PV '+ALLTRIM(SC6->C6_NUM)+'-'+ALLTRIM(SC6->C6_ITEM)+' '+ALLTRIM(DTOC(SC6->C6_SUGENTR))+' '+ALLTRIM(STR(SC6->C6_QTDVEN-SC6->C6_QTDENT))
													ENDIF
													SC6->(DBSKIP())
												ENDDO
											ENDIF
											_aSaveArea	:= GetArea()
											//H5_PRODUTO='50104125000511 '
											//H5_DOC='DMXFOP1009315D'
											cQuerySHA := " SELECT * FROM SC4010 WHERE C4_PRODUTO IN  "
											cQuerySHA += " (select G1_COD from SG1010 WITH(NOLOCK) WHERE G1_COMP='"+ALLTRIM(TR2->H5_DOC)+"' AND D_E_L_E_T_<>'*')"
											cQuerySHA += " AND D_E_L_E_T_<>'*'  AND C4_QUANT >0    "
											TcQuery cQuerySHA Alias "TRH" New
											TRH->(DbGoTop())
											RestArea(_aSaveArea)
											DO WHILE .NOT. TRH->(EOF())
												IF EMPTY(ALLTRIM(TRH->C4_OBS))
													ZHB_TEXTO := ALLTRIM(ZHB_TEXTO)+' | PRE. '+ALLTRIM(SUBSTR(TRH->C4_XXNOMCL,1,8)) +' '+ALLTRIM((TRH->C4_DATA))+' '+ALLTRIM(STR(TRH->C4_QUANT))
												ELSE
													ZHB_TEXTO := ALLTRIM(ZHB_TEXTO)+' | PRE. '+ALLTRIM(TRH->C4_OBS) +' '+ALLTRIM((TRH->C4_DATA))+' '+ALLTRIM(STR(TRH->C4_QUANT))
												ENDIF
												TRH->(DBSKIP())
											ENDDO
											TRH->(DbCloseArea())
										ENDIF
										
										// Altera��o H�lio
										If ALLTRIM(TR2->H5_ALIAS)=='SD4'
											SC2->( dbSeek( xFilial() + Subs(TR2->H5_DOC,1,11) ) )
											
											ZHB->(DBSELECTAREA('ZHB'))
											//ZHB_TEXTO := Subs(TR2->H5_DOC,1,11) + ' (' + DtoC(SC2->C2_DATPRI)+")"  // Altera��o H�lio
											ZHB_TEXTO   := Subs(TR2->H5_DOC,1,11)
											//ZHB_TXDT1   := DTOC(SC2->C2_DATPRI)
											//ZHB_TXDT2   := SC2->C2_DATPRI
											ZHB_TXDT1 := DTOC(dDATA2)
											ZHB_TXDT2 := dDATA2
										EndIf
										
										DO CASE
											CASE TR3->HA_TIPO =='2' .AND. ALLTRIM(TR2->H5_ALIAS) $ ('SC1|SC2|SC7')
												ZHB_ENTRAD :=TR2->H5_QUANT
											CASE TR3->HA_TIPO =='3' .AND. ALLTRIM(TR2->H5_ALIAS) $ ('SC4|SC6|SD4')
												ZHB_SAIDA :=TR2->H5_QUANT
											CASE TR3->HA_TIPO =='4' .AND. ALLTRIM(TR2->H5_ALIAS) $ ('SHA')
												ZHB_SESTR:=TR2->H5_QUANT
										ENDCASE
										ZHB->( msUnlock() )
									ENDIF
									TR2->(DBSKIP())
								ENDDO
								TR2->(DbCloseArea())
							ENDIF
						ELSE
							IF ALLTRIM(TR3->HA_TIPO) $('1|5|6') .AND. &cTIPO<>0   //1= SALDO ESTOQUE 5= SALDO FINAL 6 NECESSIDADE
								SB1->(DBSELECTAREA('SB1'))
								SB1->(DBSETORDER(1))
								If SB1->(dbSeek( xFilial('SB1') + TR3->HA_PRODUTO ))
									_cB1DESC  :=SB1->B1_DESC
									_cB1TIPO  :=SB1->B1_TIPO
									_cB1GRUPO :=SB1->B1_GRUPO
								ENDIF
								RecLock("ZHB",.T.)
								ZHB_FILIAL :=xFILIAL('ZHB')
								ZHB_PERIOD :=dDATA2
								ZHB_NUMMRP :=TR3->HA_NUMMRP
								ZHB_PRODUT :=TR3->HA_PRODUTO
								ZHB_DESC   :=_cB1DESC
								ZHB_TIPOP  :=_cB1TIPO
								ZHB_GRUPO  :=_cB1GRUPO
								ZHB_NIVEL  :=TR3->HA_NIVEL
								IF EMPTY(ZHB_PRODSH)
									ZHB_PRODSH :=TR3->HA_PRODSHW
								ENDIF
								ZHB_OPC    :=TR3->HA_OPC
								ZHB_REVISA :=TR3->HA_REVISAO
								ZHB_REVSHW :=TR3->HA_REVSHW
								DO CASE
									CASE TR3->HA_TIPO =='1'
										ZHB_SALDOE :=&cTIPO
										ZHB_TIPO   :='02-Saldo Estoque'
										//ZHB_TEXTO  :=Transform(&cTIPO,"@ze 999,999,999.99") + ' ('+DtoC(dDATA2)+')'  // Altera��o H�lio
										ZHB_TEXTO  :=Transform(&cTIPO,"@ze 999,999,999.99")
										IF SB1->B1_EMIN >0
											ZHB_TEXTO  :="E.Minimo: "+Transform(SB1->B1_EMIN,"@ze 999,999,999.99")
										ELSE
											ZHB_TEXTO  :=""
										ENDIF
										ZHB_TXDT1 :=DTOC(dDATA2)
										ZHB_TXDT2 :=dDATA2
									CASE TR3->HA_TIPO =='5'
										ZHB_SALDO  :=&cTIPO
										ZHB_TIPO   :='10-Saldo Final'
										//ZHB_TEXTO  :=Transform(&cTIPO,"@ze 999,999,999.99")  //+ ' ('+DtoC(dDATA2)+')'  // Altera��o H�lio
										ZHB_TEXTO :=''
										ZHB_TXDT1 :=DTOC(dDATA2)
										ZHB_TXDT2 :=dDATA2
										
									CASE TR3->HA_TIPO =='6'
										nLTIME :=POSICIONE('SB1',1,xFILIAL('SB1')+TR3->HA_PRODUTO,'B1_PE')
										nLOTEE :=POSICIONE('SB1',1,xFILIAL('SB1')+TR3->HA_PRODUTO,'B1_LE')
										ZHB_NEC    :=&cTIPO
										ZHB_TIPO   :='11-Necessidade'
										cIDMRP     := Soma1(cIDMRP,7,.T.,.T.)
										ZHB_IDMRP  := cIDMRP
										//ZHB_TEXTO  :=Transform(&cTIPO,"@ze 999,999,999.99") //+ ' ('+DtoC(dDATA2)+')'  // Altera��o H�lio
										ZHB_TEXTO  :=''
										IF nLOTEE>0
											//ZHB_TXDT1  :=DTOC(dDATA2-nLTIME)+' '+Transform(nLTIME,"@ze 999")+'/'+alltrim(Transform(nLOTEE,"@ze 999999"))
											ZHB_TXDT1  :=DTOC(dDATA2)+' '+Transform(nLTIME,"@ze 999")+'/'+alltrim(Transform(nLOTEE,"@ze 999999"))
										ELSE
											//ZHB_TXDT1  :=DTOC(dDATA2-nLTIME)+' '+Transform(nLTIME,"@ze 999")
											ZHB_TXDT1  :=DTOC(dDATA2)+' '+Transform(nLTIME,"@ze 999")
										ENDIF
										//ZHB_TXDT2  :=(dDATA2-nLTIME)
										ZHB_TXDT2  :=(dDATA2)
										ZHB_LTIME  :=nLTIME
								ENDCASE
								ZHB->( msUnlock() )
							ENDIF
						ENDIF
					ENDIF
					TR5->(DbCloseArea())
					TR3->(DBSKIP())
				ENDDO
				TR3->(DbCloseArea())
			ENDIF
		ENDIF
	NEXT
	TRB->(DBSKIP())
ENDDO
TRB->(DbCloseArea())


cQUERY6:=" UPDATE ZHB010 SET ZHB_XQTDE=ZHB_SALDOE WHERE ZHB_SALDOE<>0  "
cQUERY7:=" UPDATE ZHB010 SET ZHB_XQTDE=ZHB_ENTRAD WHERE ZHB_ENTRAD<>0  "
cQUERY8:=" UPDATE ZHB010 SET ZHB_XQTDE=ZHB_SAIDA  WHERE ZHB_SAIDA <>0  "
cQUERY9:=" UPDATE ZHB010 SET ZHB_XQTDE=ZHB_SESTR  WHERE ZHB_SESTR <>0  "
cQUERYA:=" UPDATE ZHB010 SET ZHB_XQTDE=ZHB_SALDO  WHERE ZHB_SALDO <>0  "
cQUERYB:=" UPDATE ZHB010 SET ZHB_XQTDE=ZHB_NEC    WHERE ZHB_NEC   <>0  "

TCSQLEXEC(cQUERY6)
TCSQLEXEC(cQUERY7)
TCSQLEXEC(cQUERY8)
TCSQLEXEC(cQUERY9)
TCSQLEXEC(cQUERYA)
TCSQLEXEC(cQUERYB)
U_MRPSINI2(cIdMRP)

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------
cQUERYX := " UPDATE ZHB010 SET ZHB_TEXTO=  "
cQUERYX += "       (SELECT TOP 1 SUBSTRING(RTRIM(C4_XXCOD)+' '+RTRIM(C4_OBS)+' '+RTRIM(C4_XXNOMCL),1,120) FROM SC4010 WHERE C4_PRODUTO=ZHB_PRODUT AND  ZHB_SAIDA=C4_QUANT AND D_E_L_E_T_<>'*' AND C4_DATA=ZHB_PERIOD ) "
cQUERYX += " WHERE ZHB_TEXTO='/'   AND  "
cQUERYX += " EXISTS(SELECT TOP 1 SUBSTRING(RTRIM(C4_XXCOD)+' '+RTRIM(C4_OBS)+' '+RTRIM(C4_XXNOMCL),1,120) FROM SC4010 WHERE C4_PRODUTO=ZHB_PRODUT AND  ZHB_SAIDA=C4_QUANT AND D_E_L_E_T_<>'*' AND C4_DATA=ZHB_PERIOD ) "
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------
cQUERYY := " UPDATE ZHB010 SET ZHB_TEXTO= "
cQUERYY += "       (SELECT TOP 1 SUBSTRING(RTRIM(C4_XXCOD)+' '+RTRIM(C4_OBS)+' '+RTRIM(C4_XXNOMCL),1,120) FROM SC4010 WHERE C4_PRODUTO=ZHB_PRODUT AND  ZHB_SAIDA=C4_QUANT AND D_E_L_E_T_<>'*' AND C4_DATA<ZHB_PERIOD ) "
cQUERYY += " WHERE ZHB_TEXTO='/'   AND   "
cQUERYY += " EXISTS(SELECT TOP 1 SUBSTRING(RTRIM(C4_XXCOD)+' '+RTRIM(C4_OBS)+' '+RTRIM(C4_XXNOMCL),1,120) FROM SC4010 WHERE C4_PRODUTO=ZHB_PRODUT AND  ZHB_SAIDA=C4_QUANT AND D_E_L_E_T_<>'*' AND C4_DATA<ZHB_PERIOD ) "
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------
cQUERYZ := " DELETE FROM ZHB010  WHERE ZHB_TIPO='01-Necessidade' AND ZHB_XQTDE=0 "
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------

TCSQLEXEC(cQUERYX)
TCSQLEXEC(cQUERYY)
TCSQLEXEC(cQUERYZ)

//MSGALERT('FIM')

RETURN

*------------------------------------------------------------------------------------------------------------------
USER FUNCTION MRPSINI2(_cIdMRP)
*------------------------------------------------------------------------------------------------------------------

cQUERYINI:=" select * from ZHB010 ORDER BY ZHB_FILIAL,ZHB_PRODUT,ZHB_PERIOD, ZHB_TIPO "
TcQuery cQUERYINI Alias "TRINI" New

("TRINI")->(DbGoTop())

If TRINI->(Eof())
	DbSelectArea("TRINI")
	TRINI->(DbCloseArea())
	Return()
EndIf

ZHB->(DBSELECTAREA('ZHB'))

cPRODUT := TRINI->ZHB_PRODUT
dPERIOD := CTOD(SUBSTR(TRINI->ZHB_PERIOD,7,2)+'/'+SUBSTR(TRINI->ZHB_PERIOD,5,2)+'/'+SUBSTR(TRINI->ZHB_PERIOD,1,4))
cTIPO   := TRINI->ZHB_TIPO

cDESC   := ZHB_DESC
cTIPOP  := ZHB_TIPOP
cGRUPO  := ZHB_GRUPO
cNUMMRP := ZHB_NUMMRP

dTXDT1 := SUBSTR(TRINI->ZHB_PERIOD,7,2)+'/'+SUBSTR(TRINI->ZHB_PERIOD,5,2)+'/'+SUBSTR(TRINI->ZHB_PERIOD,1,4)
dTXDT2 := CTOD(SUBSTR(TRINI->ZHB_PERIOD,7,2)+'/'+SUBSTR(TRINI->ZHB_PERIOD,5,2)+'/'+SUBSTR(TRINI->ZHB_PERIOD,1,4))

DO WHILE !TRINI->(Eof())
	IF SUBSTRING(TRINI->ZHB_TIPO,1,2)<>'02'
		SB1->(DBSELECTAREA('SB1'))
		SB1->(DBSETORDER(1))
		If SB1->(dbSeek( xFilial('SB1') + cPRODUT ))
			cDESC  :=SB1->B1_DESC
			cTIPOP  :=SB1->B1_TIPO
			cGRUPO :=SB1->B1_GRUPO
		ENDIF
		RecLock("ZHB",.T.)
		ZHB_FILIAL := xFILIAL('ZHB')
		ZHB_PERIOD := dPERIOD
		ZHB_NUMMRP := cNUMMRP
		ZHB_PRODUT := cPRODUT
		ZHB_DESC   := cDESC
		ZHB_TIPOP  := cTIPOP
		ZHB_GRUPO  := cGRUPO
		ZHB_TIPO   := '02-Saldo Estoque'
		IF SB1->B1_EMIN >0
			ZHB_TEXTO  :="E.Minimo: "+Transform(SB1->B1_EMIN,"@ze 999,999,999.99")
		ELSE
			ZHB_TEXTO  :=""
		ENDIF
		
		ZHB_TXDT1  := dTXDT1
		ZHB_TXDT2  := dTXDT2
		ZHB_XQTDE  := 0
		ZHB_SALDOE := 0
		ZHB->( msUnlock() )
	ENDIF
	
	DO WHILE  !TRINI->(Eof()) .AND. cPRODUT==TRINI->ZHB_PRODUT  .AND.  dPERIOD==CTOD(SUBSTR(TRINI->ZHB_PERIOD,7,2)+'/'+SUBSTR(TRINI->ZHB_PERIOD,5,2)+'/'+SUBSTR(TRINI->ZHB_PERIOD,1,4))
		TRINI->(DBSKIP())
	ENDDO
	cPRODUT := TRINI->ZHB_PRODUT
	dPERIOD := CTOD(SUBSTR(TRINI->ZHB_PERIOD,7,2)+'/'+SUBSTR(TRINI->ZHB_PERIOD,5,2)+'/'+SUBSTR(TRINI->ZHB_PERIOD,1,4))
	cTIPO   := TRINI->ZHB_TIPO
	
	cDESC   := ZHB_DESC
	cTIPOP  := ZHB_TIPOP
	cGRUPO  := ZHB_GRUPO
	cNUMMRP := ZHB_NUMMRP
	
	dTXDT1 := SUBSTR(TRINI->ZHB_PERIOD,7,2)+'/'+SUBSTR(TRINI->ZHB_PERIOD,5,2)+'/'+SUBSTR(TRINI->ZHB_PERIOD,1,4)
	dTXDT2 := CTOD(SUBSTR(TRINI->ZHB_PERIOD,7,2)+'/'+SUBSTR(TRINI->ZHB_PERIOD,5,2)+'/'+SUBSTR(TRINI->ZHB_PERIOD,1,4))
ENDDO
TRINI->(DbCloseArea())

ZHB->(DBSELECTAREA('ZHB'))
ZHB->(DBSETORDER(3))
ZHB->(DBGOTOP())

cPRODUT := ZHB->ZHB_PRODUT
dPERIOD := ZHB->ZHB_PERIOD

nSALDO  := 0
nENTRAD := 0
nSAIDA  := 0
nSESTR  := 0
nSALDOF := 0
DO WHILE  !ZHB->(Eof()) //.AND. cPRODUT==ZHB->ZHB_PRODUT  .AND.  dPERIOD==CTOD(SUBSTR(ZHB->ZHB_PERIOD,7,2)+'/'+SUBSTR(ZHB->ZHB_PERIOD,5,2)+'/'+SUBSTR(ZHB->ZHB_PERIOD,1,4))
	//IF ALLTRIM(ZHB->ZHB_PRODUT)=='10170SM20126AZ'
	//	CTESTE :=1
	//ENDIF
	IF ALLTRIM(cPRODUT)==ALLTRIM(ZHB->ZHB_PRODUT) .AND. dPERIOD<>ZHB->ZHB_PERIOD
		IF SUBSTR(ZHB->ZHB_TIPO,1,2)=='02'
			IF nSALDOF<0
				RecLock("ZHB",.F.)
				ZHB_XQTDE  := 0
				ZHB_SALDOE := 0
				ZHB->( msUnlock() )
			ELSE
				RecLock("ZHB",.F.)
				ZHB_XQTDE  := nSALDOF
				ZHB_SALDOE := nSALDOF
				ZHB->( msUnlock() )
			ENDIF
			cPRODUT := ZHB->ZHB_PRODUT
			dPERIOD := ZHB->ZHB_PERIOD
			nSALDO  := 0
			nENTRAD := 0
			nSAIDA  := 0
			nSESTR  := 0
			nSALDOF := 0
		ENDIF
	ELSE
		IF ALLTRIM(cPRODUT)<>ALLTRIM(ZHB->ZHB_PRODUT)
			cPRODUT := ZHB->ZHB_PRODUT
			dPERIOD := ZHB->ZHB_PERIOD
			nSALDO  := 0
			nENTRAD := 0
			nSAIDA  := 0
			nSESTR  := 0
			nSALDOF := 0
		ENDIF
	ENDIF
	DO CASE
		CASE ZHB->ZHB_SALDOE    > 0
			nSALDO :=nSALDO+ZHB->ZHB_SALDOE
		CASE ZHB->ZHB_ENTRAD    > 0
			nENTRAD:=nENTRAD+ZHB->ZHB_ENTRAD
		CASE ZHB->ZHB_SAIDA     > 0
			nSAIDA :=nSAIDA+ZHB->ZHB_SAIDA
		CASE ZHB->ZHB_SESTR     > 0
			nSESTR :=nSESTR+ZHB->ZHB_SESTR
		CASE SUBSTR(ZHB->ZHB_TIPO,1,2)  == '10'//'10-Saldo Final'
			nSALDOF:=(nSALDO+nENTRAD)-(nSAIDA+nSESTR)
			RecLock("ZHB",.F.)
			ZHB_XQTDE  := nSALDOF
			ZHB_SALDO  := nSALDOF
			ZHB->( msUnlock() )
		CASE  SUBSTR(ZHB->ZHB_TIPO,1,2)  == '11'// '11-Necessidade'
			IF nSALDOF<0
				RecLock("ZHB",.F.)
				ZHB_XQTDE  := nSALDOF*(-1)
				ZHB_NEC    := nSALDOF*(-1)
				ZHB->( msUnlock() )
			ELSE
				RecLock("ZHB",.F.)
				ZHB_XQTDE  := 0
				ZHB_NEC    := 0
				ZHB->( msUnlock() )
			ENDIF
	ENDCASE
	ZHB->(DBSKIP())
ENDDO

cQUERYFIM:=" SELECT * FROM ZHB010 WHERE SUBSTRING(ZHB_TIPO,1,2)='10' AND ZHB_XQTDE <0 "
cQUERYFIM+=" AND ZHB_PERIOD+ZHB_NUMMRP+ZHB_PRODUT NOT IN  "
cQUERYFIM+=" (SELECT ZHB_PERIOD+ZHB_NUMMRP+ZHB_PRODUT FROM ZHB010 WHERE SUBSTRING(ZHB_TIPO,1,2)='11' AND ZHB_XQTDE >0) "
TcQuery cQUERYFIM Alias "TRFIM" New

("TRFIM")->(DbGoTop())

If TRFIM->(Eof())
	DbSelectArea("TRFIM")
	TRFIM->(DbCloseArea())
	cQUERYFIM2:=" UPDATE ZHB010 SET ZHB_TIPO='01-Necessidade' WHERE SUBSTRING(ZHB_TIPO,1,2)='11' "
   TCSQLEXEC(cQUERYFIM2)
	Return()
EndIf

ZHB->(DBSELECTAREA('ZHB'))


DO WHILE !TRFIM->(Eof())
	dPERIOD := CTOD(SUBSTR(TRFIM->ZHB_PERIOD,7,2)+'/'+SUBSTR(TRFIM->ZHB_PERIOD,5,2)+'/'+SUBSTR(TRFIM->ZHB_PERIOD,1,4))
	dTXDT1  := SUBSTR(TRFIM->ZHB_PERIOD,7,2)+'/'+SUBSTR(TRFIM->ZHB_PERIOD,5,2)+'/'+SUBSTR(TRFIM->ZHB_PERIOD,1,4)
	dTXDT2  := CTOD(SUBSTR(TRFIM->ZHB_PERIOD,7,2)+'/'+SUBSTR(TRFIM->ZHB_PERIOD,5,2)+'/'+SUBSTR(TRFIM->ZHB_PERIOD,1,4))
	
	RecLock("ZHB",.T.)
	ZHB_FILIAL  :=xFILIAL('ZHB')
	ZHB_PERIOD  :=dPERIOD
	ZHB_NUMMRP  :=TRFIM->ZHB_NUMMRP
	ZHB_NIVEL   :=TRFIM->ZHB_NIVEL
	ZHB_PRODUT  :=TRFIM->ZHB_PRODUT
	ZHB_OPC     :=TRFIM->ZHB_OPC
	ZHB_TIPO    := '11-Necessidade'
	ZHB_TEXTO   :=TRFIM->ZHB_TEXTO
	ZHB_NEC     :=(TRFIM->ZHB_XQTDE)*(-1)
	ZHB_DESC    :=TRFIM->ZHB_DESC
	ZHB_TIPOP   :=TRFIM->ZHB_TIPOP
	ZHB_GRUPO   :=TRFIM->ZHB_GRUPO
	ZHB_XQTDE   :=(TRFIM->ZHB_XQTDE)*(-1)
	ZHB_TXDT1   :=dTXDT1
	ZHB_TXDT2   :=dTXDT2
	ZHB_LTIME   :=ZHB->ZHB_LTIME
	_cIDMRP     :=Soma1(_cIDMRP,7,.T.,.T.)
	ZHB_IDMRP   :=_cIDMRP
	ZHB->( msUnlock() )
	
	TRFIM->(DBSKIP())
ENDDO
TRFIM->(DbCloseArea())


cQUERYFIM2:=" UPDATE ZHB010 SET ZHB_TIPO='01-Necessidade' WHERE SUBSTRING(ZHB_TIPO,1,2)='11' "
TCSQLEXEC(cQUERYFIM)

RETURN

*------------------------------------------------------------------------------------------------------------------
USER FUNCTION MRPSHB(AH5_DOC,AH5_DATAORI,AH5_PRODUTO,AH5_ALIAS,AH5_QUANT,AR_E_C_N_O_,AH5_PER)
*------------------------------------------------------------------------------------------------------------------
LOCAL NX     :=0
LOCAL NX1    :=0
LOCAL aSC41  :={}
LOCAL aSHA1  :={}
LOCAL aSHA21 :={}

cQuery3 := " SELECT * FROM SH5010 WHERE H5_PRODUTO='"+AH5_DOC+"'  AND H5_PER='"+ALLTRIM(AH5_PER)+"'   "
TcQuery cQuery3 Alias "TRSHA" New
("TRSHA")->(DbGoTop())
If TRSHA->(Eof())
	TRSHA->(DbCloseArea())
ELSE
	DO WHILE .NOT. TRSHA->(EOF())
		IF TRSHA->H5_ALIAS=='SC4'
			AADD(aSC41,{TRSHA->H5_DOC,TRSHA->H5_DATAORI,TRSHA->H5_PRODUTO,TRSHA->H5_ALIAS,TRSHA->H5_QUANT,TRSHA->H5_RECNO,TRSHA->H5_PER})
		ENDIF
		IF TRSHA->H5_ALIAS=='SHA'
			lSHA:=.T.
			FOR nX1:=1 TO LEN(aSHA1)
				IF TRSHA->H5_DOC==aSHA1[nX1][1]
					lSHA:=.F.
				ENDIF
			NEXT
			IF lSHA==.T.
				AADD(aSHA1,{TRSHA->H5_DOC,TRSHA->H5_DATAORI,TRSHA->H5_PRODUTO,TRSHA->H5_ALIAS,TRSHA->H5_QUANT,TRSHA->R_E_C_N_O_,TRSHA->H5_PER})
			ENDIF
		ENDIF
		TRSHA->(DBSKIP())
	ENDDO
	TRSHA->(DBCLOSEAREA())
	aSHA21:=aSHA1
	aSHA1:={}
	NX1:=0
	IF LEN(aSHA21)>0
		FOR nX1:=1 TO LEN(aSHA21)
			U_MRPSHB2(aSHA21[NX1][01],aSHA21[NX1][02],aSHA21[NX1][03],aSHA21[NX1][04],aSHA21[NX1][05],aSHA21[NX1][06],aSHA21[NX1][07])
		NEXT
	ENDIF
ENDIF
FOR nX1:=1 TO LEN(aSHA21)
	lSHA:=.T.
	FOR nX:=1 TO LEN(aSHA)
		IF aSHA[NX][01]==aSHA21[nX1][01]
			lSHA:=.F.
		ENDIF
	NEXT
	IF lSHA==.T.
		AADD(aSHA,{aSHA21[NX1][01],aSHA21[NX1][02],aSHA21[NX1][03],aSHA21[NX1][04],aSHA21[NX1][05],aSHA21[NX1][06],aSHA21[NX1][07]})
	ENDIF
NEXT
FOR nX1:=1 TO LEN(aSC41)
	lSC4:=.T.
	FOR nX:=1 TO LEN(aSC4)
		IF aSC4[NX][01]==aSC41[nX1][01] .AND.;
			aSC4[NX][02]==aSC41[nX1][02] .AND.;
			aSC4[NX][03]==aSC41[nX1][03] .AND.;
			aSC4[NX][04]==aSC41[nX1][04] .AND.;
			aSC4[NX][05]==aSC41[nX1][05] .AND.;
			aSC4[NX][06]==aSC41[nX1][06] .AND.;
			aSC4[NX][07]==aSC41[nX1][07]
			lSC4:=.F.
		ENDIF
	NEXT
	IF lSC4==.T.
		AADD(aSC4,{aSC41[NX1][01],aSC41[NX1][02],aSC41[NX1][03],aSC41[NX1][04],aSC41[NX1][05],aSC41[NX1][06],aSC41[NX1][07]})
	ENDIF
NEXT
aSHA21:={}
RETURN


*------------------------------------------------------------------------------------------------------------------
USER FUNCTION MRPSHB2(AH5_DOC,AH5_DATAORI,AH5_PRODUTO,AH5_ALIAS,AH5_QUANT,AR_E_C_N_O_,AH5_PER)
*------------------------------------------------------------------------------------------------------------------
LOCAL _NX2    :=0
LOCAL NX2    :=0
LOCAL aSC42  :={}
LOCAL aSHA2  :={}
LOCAL aSHA22 :={}

cQuery3 := " SELECT * FROM SH5010 WHERE H5_PRODUTO='"+AH5_DOC+"'  AND H5_PER='"+ALLTRIM(AH5_PER)+"'   "
TcQuery cQuery3 Alias "TRSHA" New
("TRSHA")->(DbGoTop())
If TRSHA->(Eof())
	TRSHA->(DbCloseArea())
ELSE
	DO WHILE .NOT. TRSHA->(EOF())
		IF TRSHA->H5_ALIAS=='SC4'
			AADD(aSC42,{TRSHA->H5_DOC,TRSHA->H5_DATAORI,TRSHA->H5_PRODUTO,TRSHA->H5_ALIAS,TRSHA->H5_QUANT,TRSHA->H5_RECNO,TRSHA->H5_PER})
		ENDIF
		IF TRSHA->H5_ALIAS=='SHA'
			lSHA:=.T.
			FOR nX2:=1 TO LEN(aSHA2)
				IF TRSHA->H5_DOC==aSHA2[nX2][1]
					lSHA:=.F.
				ENDIF
			NEXT
			IF lSHA==.T.
				AADD(aSHA2,{TRSHA->H5_DOC,TRSHA->H5_DATAORI,TRSHA->H5_PRODUTO,TRSHA->H5_ALIAS,TRSHA->H5_QUANT,TRSHA->R_E_C_N_O_,TRSHA->H5_PER})
			ENDIF
		ENDIF
		TRSHA->(DBSKIP())
	ENDDO
	TRSHA->(DBCLOSEAREA())
	aSHA22:=aSHA2
	aSHA2:={}
	NX2:=0
	IF LEN(aSHA22)>0
		FOR nX2:=1 TO LEN(aSHA22)
			U_MRPSHB3(aSHA22[NX2][01],aSHA22[NX2][02],aSHA22[NX2][03],aSHA22[NX2][04],aSHA22[NX2][05],aSHA22[NX2][06],aSHA22[NX2][07])
		NEXT
	ENDIF
ENDIF
FOR nX2:=1 TO LEN(aSHA22)
	lSHA:=.T.
	FOR _nX2:=1 TO LEN(aSHA)
		IF aSHA[_NX2][03]==aSHA22[nX2][03]
			lSHA:=.F.
		ENDIF
	NEXT
	IF lSHA==.T.
		AADD(aSHA,{aSHA22[NX2][01],aSHA22[NX2][02],aSHA22[NX2][03],aSHA22[NX2][04],aSHA22[NX2][05],aSHA22[NX2][06],aSHA22[NX2][07]})
	ENDIF
NEXT
FOR nX2:=1 TO LEN(aSC42)
	lSC4:=.T.
	FOR _nX2:=1 TO LEN(aSC4)
		IF aSC4[_NX2][01]==aSC42[nX2][01] .AND.;
			aSC4[_NX2][02]==aSC42[nX2][02] .AND.;
			aSC4[_NX2][03]==aSC42[nX2][03] .AND.;
			aSC4[_NX2][04]==aSC42[nX2][04] .AND.;
			aSC4[_NX2][05]==aSC42[nX2][05] .AND.;
			aSC4[_NX2][06]==aSC42[nX2][06] .AND.;
			aSC4[_NX2][07]==aSC42[nX2][07]
			lSC4:=.F.
		ENDIF
	NEXT
	IF lSC4==.T.
		AADD(aSC4,{aSC42[NX2][01],aSC42[NX2][02],aSC42[NX2][03],aSC42[NX2][04],aSC42[NX2][05],aSC42[NX2][06],aSC42[NX2][07]})
	ENDIF
NEXT
aSHA22:={}
RETURN



*------------------------------------------------------------------------------------------------------------------
USER FUNCTION MRPSHB3(AH5_DOC,AH5_DATAORI,AH5_PRODUTO,AH5_ALIAS,AH5_QUANT,AR_E_C_N_O_,AH5_PER)
*------------------------------------------------------------------------------------------------------------------
LOCAL NX3    :=0
LOCAL _NX3   :=0
LOCAL aSC43  :={}
LOCAL aSHA3  :={}
LOCAL aSHA23 :={}

cQuery3 := " SELECT * FROM SH5010 WHERE H5_PRODUTO='"+AH5_DOC+"'  AND H5_PER='"+ALLTRIM(AH5_PER)+"'   "
TcQuery cQuery3 Alias "TRSHA" New
("TRSHA")->(DbGoTop())
If TRSHA->(Eof())
	TRSHA->(DbCloseArea())
ELSE
	DO WHILE .NOT. TRSHA->(EOF())
		IF TRSHA->H5_ALIAS=='SC4'
			//AADD(aSC43,{TRSHA->H5_DOC,TRSHA->H5_DATAORI,TRSHA->H5_PRODUTO,TRSHA->H5_ALIAS,TRSHA->H5_QUANT,TRSHA->R_E_C_N_O_,TRSHA->H5_PER})
			AADD(aSC43,{TRSHA->H5_DOC,TRSHA->H5_DATAORI,TRSHA->H5_PRODUTO,TRSHA->H5_ALIAS,TRSHA->H5_QUANT,TRSHA->H5_RECNO,TRSHA->H5_PER})
		ENDIF
		IF TRSHA->H5_ALIAS=='SHA'
			lSHA:=.T.
			FOR nX3:=1 TO LEN(aSHA3)
				IF TRSHA->H5_DOC==aSHA3[nX3][1]
					lSHA:=.F.
				ENDIF
			NEXT
			IF lSHA==.T.
				AADD(aSHA3,{TRSHA->H5_DOC,TRSHA->H5_DATAORI,TRSHA->H5_PRODUTO,TRSHA->H5_ALIAS,TRSHA->H5_QUANT,TRSHA->R_E_C_N_O_,TRSHA->H5_PER})
			ENDIF
		ENDIF
		TRSHA->(DBSKIP())
	ENDDO
	TRSHA->(DBCLOSEAREA())
	aSHA23:=aSHA3
	aSHA3:={}
	NX3:=0
	IF LEN(aSHA23)>0
		FOR nX3:=1 TO LEN(aSHA23)
			U_MRPSHB4(aSHA23[NX3][01],aSHA23[NX3][02],aSHA23[NX3][03],aSHA23[NX3][04],aSHA23[NX3][05],aSHA23[NX3][06],aSHA23[NX3][07])
		NEXT
	ENDIF
ENDIF
FOR nX3:=1 TO LEN(aSHA23)
	lSHA:=.T.
	FOR _nX3:=1 TO LEN(aSHA)
		IF aSHA[_nX3][03]==aSHA23[nX3][03]
			lSHA:=.F.
		ENDIF
	NEXT
	IF lSHA==.T.
		AADD(aSHA,{aSHA23[NX3][01],aSHA23[NX3][02],aSHA23[NX3][03],aSHA23[NX3][04],aSHA23[NX3][05],aSHA23[NX3][06],aSHA23[NX3][07]})
	ENDIF
NEXT
FOR nX3:=1 TO LEN(aSC43)
	lSC4:=.T.
	FOR _nX3:=1 TO LEN(aSC4)
		IF aSC4[_NX3][01]==aSC43[nX3][01] .AND.;
			aSC4[_NX3][02]==aSC43[nX3][02] .AND.;
			aSC4[_NX3][03]==aSC43[nX3][03] .AND.;
			aSC4[_NX3][04]==aSC43[nX3][04] .AND.;
			aSC4[_NX3][05]==aSC43[nX3][05] .AND.;
			aSC4[_NX3][06]==aSC43[nX3][06] .AND.;
			aSC4[_NX3][07]==aSC43[nX3][07]
			lSC4:=.F.
		ENDIF
	NEXT
	IF lSC4==.T.
		AADD(aSC4,{aSC43[NX3][01],aSC43[NX3][02],aSC43[NX3][03],aSC43[NX3][04],aSC43[NX3][05],aSC43[NX3][06],aSC43[NX3][07]})
	ENDIF
NEXT
aSHA23:={}
RETURN


*------------------------------------------------------------------------------------------------------------------
USER FUNCTION MRPSHB4(AH5_DOC,AH5_DATAORI,AH5_PRODUTO,AH5_ALIAS,AH5_QUANT,AR_E_C_N_O_,AH5_PER)
*------------------------------------------------------------------------------------------------------------------
LOCAL NX4    :=0
LOCAL _NX4   :=0
LOCAL aSC44  :={}
LOCAL aSHA4  :={}
LOCAL aSHA24 :={}

cQuery3 := " SELECT * FROM SH5010 WHERE H5_PRODUTO='"+AH5_DOC+"'  AND H5_PER='"+ALLTRIM(AH5_PER)+"'   "
TcQuery cQuery3 Alias "TRSHA" New
("TRSHA")->(DbGoTop())
If TRSHA->(Eof())
	TRSHA->(DbCloseArea())
ELSE
	DO WHILE .NOT. TRSHA->(EOF())
		IF TRSHA->H5_ALIAS=='SC4'
			AADD(aSC44,{TRSHA->H5_DOC,TRSHA->H5_DATAORI,TRSHA->H5_PRODUTO,TRSHA->H5_ALIAS,TRSHA->H5_QUANT,TRSHA->H5_RECNO,TRSHA->H5_PER})
		ENDIF
		IF TRSHA->H5_ALIAS=='SHA'
			lSHA:=.T.
			FOR nX4:=1 TO LEN(aSHA4)
				IF TRSHA->H5_DOC==aSHA4[nX4][1]
					lSHA:=.F.
				ENDIF
			NEXT
			IF lSHA==.T.
				AADD(aSHA4,{TRSHA->H5_DOC,TRSHA->H5_DATAORI,TRSHA->H5_PRODUTO,TRSHA->H5_ALIAS,TRSHA->H5_QUANT,TRSHA->R_E_C_N_O_,TRSHA->H5_PER})
			ENDIF
		ENDIF
		TRSHA->(DBSKIP())
	ENDDO
	TRSHA->(DBCLOSEAREA())
	aSHA24:=aSHA4
	aSHA4:={}
	NX4:=0
	IF LEN(aSHA24)>0
		FOR nX4:=1 TO LEN(aSHA24)
			U_MRPSHB(aSHA24[NX4][01],aSHA24[NX4][02],aSHA24[NX4][03],aSHA24[NX4][04],aSHA24[NX4][05],aSHA24[NX4][06],aSHA24[NX4][07])
		NEXT
	ENDIF
	aSHA24:={}
ENDIF
FOR nX4:=1 TO LEN(aSHA24)
	lSHA:=.T.
	FOR _nX4:=1 TO LEN(aSHA)
		IF aSHA[_nX4][03]==aSHA24[nX4][03]
			lSHA:=.F.
		ENDIF
	NEXT
	IF lSHA==.T.
		AADD(aSHA,{aSHA24[NX4][01],aSHA24[NX4][02],aSHA24[NX4][03],aSHA24[NX4][04],aSHA24[NX4][05],aSHA24[NX4][06],aSHA24[NX4][07]})
	ENDIF
NEXT
FOR nX4:=1 TO LEN(aSC44)
	lSC4:=.T.
	FOR _nX4:=1 TO LEN(aSC4)
		IF aSC4[_NX4][01]==aSC44[nX4][01] .AND.;
			aSC4[_NX4][02]==aSC44[nX4][02] .AND.;
			aSC4[_NX4][03]==aSC44[nX4][03] .AND.;
			aSC4[_NX4][04]==aSC44[nX4][04] .AND.;
			aSC4[_NX4][05]==aSC44[nX4][05] .AND.;
			aSC4[_NX4][06]==aSC44[nX4][06] .AND.;
			aSC4[_NX4][07]==aSC44[nX4][07]
			lSC4:=.F.
		ENDIF
	NEXT
	IF lSC4==.T.
		AADD(aSC4,{aSC44[NX4][01],aSC44[NX4][02],aSC44[NX4][03],aSC44[NX4][04],aSC44[NX4][05],aSC44[NX4][06],aSC44[NX4][07]})
	ENDIF
NEXT

RETURN


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   �MRExpl2 � Autor � Eveli Morasco         � Data � 08/09/92 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Faz a explosao de uma estrutura                            ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � MRExpl2(ExpC1,ExpN1,ExpN2,ExpC2,ExpC3,ExpC4,ExpN3)       ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Codigo do produto a ser explodido                  ���
���          � ExpN1 = Quantidade do pai a ser explodida                  ���
���          � ExpN2 = Nivel a ser impresso                               ���
���          � ExpC2 = Picture da quantidade                              ���
���          � ExpC3 = Picture da perda                                   ���
���          � ExpC4 = Opcionais do produto                               ���
���          � ExpN3 = Quantidade do Produto Nivel Anterior               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function MRExpl2(cProduto,nQuantPai,nNivel,cOpcionais,nQtdBase,cRevisao)
LOCAL nReg,nQuantItem,nCntItens := 0
LOCAL nX        := 0
LOCAL aAreaSB1  := {}
LOCAL cAteNiv   := If(mv_par09=Space(3),"999",mv_par09)

dbSelectArea("SG1")
While !Eof() .And. G1_FILIAL+G1_COD == xFilial("SG1")+cProduto
	nReg       := Recno()
	nQuantItem := ExplEstr(nQuantPai,,cOpcionais,cRevisao)
	dbSelectArea("SG1")
	If nNivel <= Val('9999999') // Verifica ate qual Nivel devera ser gerado
		//		If (lNegEstr .Or. (!lNegEstr .And. QtdComp(nQuantItem,.T.) > QtdComp(0) )) .And. (QtdComp(nQuantItem,.T.) # QtdComp(0,.T.))
		If ((QtdComp(nQuantItem,.T.) > QtdComp(0) )) .And. (QtdComp(nQuantItem,.T.) # QtdComp(0,.T.))
			//dbSeek(xFilial("SB1")+cProduto)
			//@ li,004 PSAY cProduto
			//RestArea(aAreaSB1)
			//dbSelectArea("SG1")
			
			nPrintNivel:=IIF(nNivel>17,17,nNivel-2)
			//@ li,nPrintNivel PSAY StrZero(nNivel,3)
			SB1->(dbSeek(xFilial("SB1")+SG1->G1_COMP))
			//@ li,21  PSay G1_COMP
			//@ li,130 PSay nQuantItem Picture cPictQuant
			//@ li,152 PSay G1_QUANT   Picture cPictQuant
			IF G1_COMP==_cCOMP
				if alltrim(G1_COMP)=='500084710'
					//  msgalert('500084710')
				endif
				_nQTDESTR := _nQTDESTR+(G1_QUANT*nQuantPai)
			ENDIF
			//�������������������������������������������������Ŀ
			//� Verifica se existe sub-estrutura                �
			//���������������������������������������������������
			dbSelectArea("SG1")
			dbSeek(xFilial("SG1")+G1_COMP)
			If Found()
				MRExpl2(G1_COD,nQuantItem ,nNivel+1,cOpcionais,IF(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB")),SB1->B1_REVATU)
			EndIf
			dbGoto(nReg)
		EndIf
	EndIf
	dbSkip()
	nCntItens++
EndDo
nCntItens--
Return nCntItens
