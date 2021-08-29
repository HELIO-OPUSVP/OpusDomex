#include "topconn.ch"

//-----------------------------------------------------------------------------------------------------------------------------------------------//
//Wederson L. Santana - 01/05/2013                                                                                                               //
//-----------------------------------------------------------------------------------------------------------------------------------------------//
//Específico Rosenberger Domex                                                                                                                   //
//-----------------------------------------------------------------------------------------------------------------------------------------------//
//Ponto de entrada após a confirmação da baixa pelo CQ.                                                                                          //
//Caso a etiqueta tenha sido indicada para endereçar antes da liberação do CQ , o sistema fará o endereçamento no local indicado após a liberação//
//pelo CQ.                                                                                                                                       //
//-----------------------------------------------------------------------------------------------------------------------------------------------//

User Function A175GRV()
Local _aAreaGER   := GetArea()
Local _aAreaSD7   := SD7->( GetArea() )

Local _cItem      := StrZero(1,4)                             
Local _aItensSDB  :={}

Local lEntrou     := .F.

Private lMsHelpAuto := .T.
Private lMsErroAuto := .F.
Private _cProduto   := SD7->D7_PRODUTO
Private _cNumero    := SD7->D7_NUMERO
Private _aCols      := {}
Private _cLocRej    := "11"

If Localiza(SD7->D7_PRODUTO)  //Possui controle por endereçamento
	SD7->(dbSetOrder(1))
	SD7->(dbGotop())
	If SD7->(dbSeek(xFilial("SD7")+_cNumero+_cProduto ))
		While !SD7->( Eof() ) .And. SD7->(D7_FILIAL+D7_NUMERO+D7_PRODUTO) == xFilial("SD7")+_cNumero+_cProduto
			If SD7->D7_TIPO == 1  .and. SD7->D7_ESTORNO <> 'S'      //Liberado
				nRecnoSD7 := SD7->( Recno() )
				
				lEntrou := .T.
				
				_cD7_NUMERO := SD7->D7_NUMERO
				
				SD7->( dbSetOrder(1) )  // D7_FILIAL+D7_NUMERO+D7_PRODUTO+D7_LOCAL+D7_SEQ+DTOS(D7_DATA)
				SD7->( dbSeek( xFilial() + _cD7_NUMERO ) )
				
				SD1->( dbSetOrder(4) )  // D1_FILIAL + D1_NUMSEQ
				If SD1->( dbSeek( xFilial() + SD7->D7_NUMSEQ ) )
				      SD7->( dbGoTo(nRecnoSD7) )
				      
						XD1->(dbSetOrder(2))  //  XD1_FILIAL+XD1_DOC+XD1_SERIE+XD1_FORNEC+XD1_LOJA+XD1_COD+XD1_ITEM
						If XD1->( dbSeek( xFilial() + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_COD + SD1->D1_ITEM ))
						//While SD7->D7_FILIAL + SD7->D7_DOC + SD7->D7_SERIE + SD7->D7_FORNECE + SD7->D7_LOJA + SD7->D7_PRODUTO +  == XD1->XD1_FILIAL + XD1->XD1_DOC + XD1->XD1_SERIE + XD1->XD1_FORNECE + XD1->XD1_LOJA + XD1->XD1_COD + XD1->XD1_ITEM
							While xFilial("XD1") + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_COD + SD1->D1_ITEM == XD1->XD1_FILIAL + XD1->XD1_DOC + XD1->XD1_SERIE + XD1->XD1_FORNECE + XD1->XD1_LOJA + XD1->XD1_COD + XD1->XD1_ITEM
							   Reclock("XD1",.F.)
								XD1->XD1_OCORRE := "3"
								XD1->XD1_LOCAL  := SD7->D7_LOCDEST
								XD1->XD1_LOCALI := ""
								XD1->( msUnlock() )
								XD1->( dbSkip() )
							End
		            EndIf
		            
		            cQuery := "SELECT XD1_XXPECA FROM " + RetSqlName("XD1") + " (NOLOCK) WHERE XD1_FORNEC = '"+SD1->D1_FORNECE+"' AND XD1_LOJA = '"+SD1->D1_LOJA+"' AND XD1_DOC = '"+SD1->D1_DOC+"' AND XD1_SERIE = '"+SD1->D1_SERIE+"' AND XD1_ITEM = '"+SD1->D1_ITEM+"' AND XD1_COD = '"+SD1->D1_COD+"' AND XD1_TIPO = '"+SD1->D1_TIPO+"' AND XD1_FORMUL = '"+SD1->D1_FORMUL+"' AND XD1_LOCAL <> '"+SD7->D7_LOCDEST+"' AND D_E_L_E_T_ = '' "
		            
		            If Select("TEMP") <> 0
		               TEMP->( dbCloseArea() )
		            EndIf
		            
		            TCQUERY cQuery NEW ALIAS "TEMP"
		            
		            While !TEMP->( EOF() )
		               MsgStop("ERRO!!! Peça " + TEMP->XD1_XXPECA + " não corrigida! Informar o depto de TI!!!")
		               TEMP->( dbSkip() )
		            End
            Else
               MsgStop("ERRO!!! Nota Fiscal não encontrada! Avisar o departamento de TI!!!")
            EndIf
            				
			ElseIf SD7->D7_TIPO == 2  .and. SD7->D7_LOCDEST == _cLocRej .and. SD7->D7_ESTORNO <> 'S' //Rejeitado
			
			lEntrou := .T.
			
				    SBE->(dbSetOrder(1))
				    If SBE->(dbSeek(xFilial("SBE")+_cLocRej))
				       //Busca o próximo item no SDB.
				       SDB->(dbSetOrder(1))
				       If SDB->(dbSeek( xFilial("SDB") + SD7->(D7_PRODUTO + D7_LOCDEST + D7_NUMSEQ)))
					       While xFilial("SDB") + SD7->(D7_PRODUTO + D7_LOCDEST + D7_NUMSEQ) == DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ
						          _cItem:=DB_ITEM
						          SDB->(dbSkip())
					       End
					       _cItem:=StrZero(Val(_cItem)+1,4)
				       EndIf
				    
				       SDA->(dbSetOrder(1))
				       If SDA->(dbSeek( xFilial("SDA") + SD7->(D7_PRODUTO+D7_LOCDEST+D7_NUMSEQ+D7_NUMERO) ))
									_aCabSDA := {{"DA_PRODUTO" ,SDA->DA_PRODUTO ,Nil},;
									             {"DA_NUMSEQ"  ,SDA->DA_NUMSEQ  ,Nil}}
									
									_aItSDB  := {{"DB_ITEM"	   ,_cItem	        ,Nil},;
									             {"DB_ESTORNO" ,Space(01)       ,Nil},;
									             {"DB_LOCALIZ" ,SBE->BE_LOCALIZ ,Nil},;
									             {"DB_DATA"	   ,dDataBase       ,Nil},;
									             {"DB_QUANT"   ,SD7->D7_QTDE ,Nil}}
									
									aadd(_aItensSDB,_aitSDB) //Executa o endereçamento do item
									
									//Begin TRANSACTION
									
									       MATA265( _aCabSDA, _aItensSDB, 3)
									
									       If lMsErroAuto
										       MostraErro("\UTIL\LOG\CQ\")
										       //DisarmTransaction()
										       MsgInfo("Erro no endereçamento automático do CQ.","A T E N Ç Ã O")
										       _lRet:=.F.
								          EndIf
								   //End TRANSACTION
						 EndIf
					 EndIf
			ElseIf SD7->D7_TIPO == 2  .and. SD7->D7_LOCDEST <> _cLocRej .and. SD7->D7_ESTORNO <> 'S' //Rejeitado e o local não for o 11 , atualiza o status da etiqueta e local do CQ.
			
			lEntrou := .T.
			   
			   SD1->(dbSetOrder(4))   // D1_FILIAL + D1_NUMSEQ
				
				XD1->(dbSetOrder(2))
				XD1->( dbGotop() )
				If SD1->( dbSeek( xFilial() + SD7->D7_NUMSEQ ) )
					If XD1->( dbSeek( xFilial()+SD7->D7_DOC+SD7->D7_SERIE+SD7->D7_FORNECE+SD7->D7_LOJA+SD7->D7_PRODUTO+SD1->D1_ITEM ) )
						While SD7->D7_FILIAL+SD7->D7_DOC+SD7->D7_SERIE+SD7->D7_FORNECE+SD7->D7_LOJA+SD7->D7_PRODUTO+SD1->D1_ITEM == XD1->XD1_FILIAL+XD1->XD1_DOC+XD1->XD1_SERIE+XD1->XD1_FORNECE+XD1->XD1_LOJA+XD1->XD1_COD+XD1->D1_ITEM
							Reclock("XD1",.F.)
							XD1->XD1_OCORRE := "2"
							XD1->XD1_LOCAL  := SD7->D7_LOCAL
							XD1->( msUnlock() )
						   XD1->( dbSkip() )
						End
					EndIf
				EndIf
				
			ElseIf SD7->D7_TIPO == 8 //Despesas agregadas
 			     lEntrou := .T.
			EndIf
			SD7->( dbSkip() )
		End
	EndIf
EndIf

If !lEntrou
	SD1->(dbSetOrder(4))   // D1_FILIAL + D1_NUMSEQ
	
	XD1->(dbSetOrder(2))
	XD1->( dbGotop() )
	If SD1->( dbSeek( xFilial() + SD7->D7_NUMSEQ ) )
		If XD1->( dbSeek( xFilial()+SD7->D7_DOC+SD7->D7_SERIE+SD7->D7_FORNECE+SD7->D7_LOJA+SD7->D7_PRODUTO+SD1->D1_ITEM ) )
			While SD7->D7_FILIAL+SD7->D7_DOC+SD7->D7_SERIE+SD7->D7_FORNECE+SD7->D7_LOJA+SD7->D7_PRODUTO+SD1->D1_ITEM == XD1->XD1_FILIAL+XD1->XD1_DOC+XD1->XD1_SERIE+XD1->XD1_FORNECE+XD1->XD1_LOJA+XD1->XD1_COD+XD1->XD1_ITEM
				Reclock("XD1",.F.)
				XD1->XD1_OCORRE := "2"
				Replace XD1->XD1_LOCAL  With SD7->D7_LOCAL
				XD1->( msUnlock() )
				XD1->( dbSkip() )
			End
		EndIf
	EndIf	
EndIf

RestArea(_aAreaSD7)
RestArea(_aAreaGER)

Return(Nil)   
