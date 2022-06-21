#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 20/03/00
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "TopCONN.ch"
///desenvolvido por Marcos Rezende
///rotina acionada após a inclusão/alteração de pedido de compras
///sendo responsável pelo envio de workflow aos responsáveis pela aprovação

USER function WFW120P( nOpcao, oProcess )//USER function AprovPC( nOpcao, oProcess )
Private bImport := .F.
//conout('Função acionadora: '+FunName())
If FunName() <> 'MATA160' .and. 	SC7->(FieldPos("C7_XXALTER"))>0 // Na análise de Cotações, não deve abrir a janela para motivo da alteração.

	SC7->( dbSetOrder(1) )
	SC7->( dbSeek( PARAMIXB ) )
	
	If ALTERA
		if SC7->(FieldPos("C7_XXALTER"))>0
			cTxtMotivo := SC7->C7_XXALTER //+ Space(300-Len(Alltrim(SC7->C7_XXALTER)))
		else
			cTXTMotivo := ""
		endif
		
		DEFINE FONT oFont NAME "Courier New" SIZE 5,0   //6,15
		DEFINE MSDIALOG oDlg TITLE 'Alteração de Pedido de Compras' From 3,0 to 370,435 PIXEL
		@ 05,10 SAY "Favor informar o motivo da alteração do Pedido de Compras. O motivo informado será enviado aos aprovadores do Pedido." SIZE 200,20 PIXEL OF oDlg
		@ 25,10 GET oMemo  VAR cTxtMotivo MEMO SIZE 200,145 OF oDlg PIXEL
		oMemo:bRClicked := {||AllwaysTrue()}
		oMemo:oFont:=oFont
		DEFINE SBUTTON  FROM 172,184 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL
		ACTIVATE MSDIALOG oDlg CENTER
		
		if SC7->(FieldPos("C7_XXALTER"))>0
			If Reclock("SC7",.F.)
				SC7->C7_XXALTER := cTxtMotivo
			Else
				apMsgStop('Não foi possível gravar o motivo da alteração!')
			EndIf
		else
//			conout("campo c7_XXALTER não criado, não foi possivel gravar o motivo da alteração")
		endif
	EndIf
EndIf

MsgRun("Enviando Workflow para Aprovador do Pedido de Compra...","",{|| CursorWait(), u_AprovPc(nOpcao, oProcess) ,CursorArrow()})

return

User function AprovPc(nOpcao, oProcess )  //USER function WFW120P( nOpcao, oProcess )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³

//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CPAR,NBARRA,N_ITEM,C_MAT,C_DEST,CGRAP")
SetPrvt("C_NUM,C_MOTIVO,N_TOTPC,CGRAPANT,N_TERMINA,N_DOHTML")
SetPrvt("CRAIZ,NRET,NHLDHTM,NHLDSCP,CIND,C_PCANT")
SetPrvt("N_QTDPC,N_FRTPC,A_ITENS,LCABEC,_AREGISTROS,NLIMITE")
SetPrvt("CAB_NUM,CAB_EMIS,CAB_FORN,CAB_COND,CAB_NOME,_NI")
SetPrvt("ARRAYCAB,ARRAYITENS,C_ITPED,NPRESUP,CAPROV,AINFO")
SetPrvt("CMAILAP,CNOMEAP,CORIGEM,CABEC,NHDLVLR,NCOUNT")
SetPrvt("NRESULT,CHTML,NHDLCONNECT,bHTMnovo,nOpcao")

If ValType(nOpcao) = "A"
	nOpcao := nOpcao[1]
Endif
If nOpcao == NIL
	nOpcao := 0
End

cstatus := 0
bHTMnovo := .T.

If oProcess == NIL
	oProcess := TWFProcess():New( "000001", "Pedido de Compras" )
End


lPrimeira := .F.

Do Case
	Case nOpcao == 0
		SPCIniciar( oProcess,.t. )
	Case nOpcao == 1
		SPCRetorno( oProcess,lPrimeira )
	Case nOpcao == 2
		SPCTimeOut( oProcess )
EndCase

oProcess:Free()
RETURN



STATIC FUNCTION SPCIniciar( oProcess,lPrimeira )
Local aCond:={},nTotal := 0 , nTtlIPI := 0
Local _xnMoeda	:= ""

Local cMoeImp	:= ""

Private _xcCodFili	:= ""
Private _xcCodCota	:= ""

//conout('Localizando aprovador para o pedido: '+sc7->c7_num)

lAchou02 := .f.
lAchou04 := .f.

//localiza através de query o status do pedido e direciona SCR para o registro
cQuery:=""
cQuery+=CRLF+"SELECT R_E_C_N_O_ FROM "+retsqlname('SCR')+" WHERE D_E_L_E_T_= ' ' and CR_NUM='"+sc7->c7_num+"' AND (CR_STATUS='02')"
if Select("TMPSCR")>0
	TMPSCR->(DBCLOSEAREA())
ENDIF
TCQUERY cQuery NEW ALIAS "TMPSCR"

if tmpscr->(!EOF())
	lAchou02 := .t.
	scr->(dbgoto(tmpscr->(R_E_C_N_O_)))
else
	cQuery:=""
	cQuery+=CRLF+"SELECT R_E_C_N_O_ FROM "+retsqlname('SCR')+" WHERE D_E_L_E_T_= ' ' and CR_NUM='"+sc7->c7_num+"' AND (CR_STATUS='04')"
	if Select("TMPSCR")>0
		TMPSCR->(DBCLOSEAREA())
	ENDIF
	TCQUERY cQuery NEW ALIAS "TMPSCR"
	if tmpscr->(!EOF())
		lAchou04 := .t.
		scr->(dbgoto(tmpscr->(R_E_C_N_O_)))
	endif
endif
if lachou02
//conout('lachou02')
endif
if lachou04
//conout('lachou04')
endif
if lAchou02 .or. lAchou04
//	conout('Preparando e-mail para envio do pedido: '+sc7->c7_num)
	
	oProcess:NewTask( "Solicitação", "\WORKFLOW\HTML\wfw120p1.HTM" )
	oProcess:cSubject := "WorkFlow de aprovação de Pedido de Compra. Pedido nro: PC" + SC7->C7_NUM
//	if lAchou02
//		oProcess:bReturn := "U_AprovPC( 1 )"
//	endif
	//	oProcess:bTimeOut := {{"U_AprovPC(2)", 0 ,0 ,2 }}
	oHTML := oProcess:oHTML
	/*** Preenche os dados do cabecalho ***/
	// Preenchendo dados dos aprovadores
//	conout('Preenchendo dados dos Aprovadores')
	aAreaSCR := SCR->( GetArea() )
	SCR->( dbSetOrder(1) )
	If scr->(dbSeek(SC7->C7_FILIAL + 'PC' + subs(SC7->C7_NUM+space(50),1,50),.T.))
//		conout('Localizando aprovador na SCR com a chave(indice 1): '+SC7->C7_FILIAL + 'PC' + subs(SC7->C7_NUM+space(50),1,50))
		While !SCR->(EOF()) .and. SCR->CR_FILIAL == SC7->C7_FILIAL .and. SC7->C7_NUM == Subs(SCR->CR_NUM,1,Len(SC7->C7_NUM))
			If SCR->CR_TIPO == 'PC'
				cStatCr := "A Definir"
				Do Case
					Case SCR->CR_STATUS == "01"
						cStatCr := "Aprovação pendente"
					Case SCR->CR_STATUS == "02"
						cStatCr := "Aprovação pendente"
					Case SCR->CR_STATUS == "03"
						cStatCr := DtoC(SCR->CR_DATALIB)
					Case SCR->CR_STATUS == "04"
						cStatCr := "Reprovado"
				endcase
				AAdd( (oHtml:ValByName( "e.SequAprov" )), SCR->CR_NIVEL                                                      )
				AAdd( (oHtml:ValByName( "e.DataAprov" )), cStatCr )
				AAdd( (oHtml:ValByName( "e.NomeAprov" )), UsrFullName(SCR->CR_USER)                                          )
				//				AAdd( (oHtml:ValByName( "e.DataAprov" )), If(!Empty(SCR->CR_DATALIB),DtoC(SCR->CR_DATALIB),'Aprovação Pendente') )

			EndIf
			SCR->( dbSkip() )
		EndDo
	EndIf
	RestArea(aAreaSCR)
		// Cabeçalho SC7
		cComprador := UsrFullName(SC7->C7_USER)
		
      IF !EMPTY(SC7->C7_PO_EIC) // CONDPAG EIC
         //SW2
         //SY6
		   cCondPag   := Alltrim(Posicione("SE4",1,xFilial("SE4") + SC7->C7_COND,"E4_DESCRI"))
		   ELSE       //CONDPAG COMPRAS
		   cCondPag   := Alltrim(Posicione("SE4",1,xFilial("SE4") + SC7->C7_COND,"E4_DESCRI"))
		ENDIF   
		cNomeForn  := Alltrim(Posicione("SA2",1,xFilial("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA,"A2_NOME"))
		cTelForn   := Alltrim(Posicione("SA2",1,xFilial("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA,"A2_TEL"))
		cDTEntrega := DtoC(SC7->C7_DATPRF)
		cFrete     := If(SC7->C7_TPFRETE='C','CIF',If(SC7->C7_TPFRETE='F','FOB','Não informado'))
		
		oHtml:ValByName( "PEDIDO"       , SC7->C7_NUM      )
		oHtml:ValByName( "EMISSAO"      , DTOC(SC7->C7_EMISSAO)  ) //INCLUIDO DTOC MLS
		oHtml:ValByName( "cComprador"   , cComprador       )
		oHtml:ValByName( "cCondPgto"    , cCondPag         )
		oHtml:ValByName( "cFornecedor"  , cNomeForn        )
		oHtml:ValByName( "cTelefone"    , cTelForn         )
		oHtml:ValByName( "cDtEntrega"   , cDTEntrega       )
		oHtml:ValByName( "cFrete"       , cFrete           )
		//oHtml:ValByName( "cMotAlteracao", SC7->C7_XXALTERA )
	
	dbSelectArea('SA2')
	dbSetOrder(1)
	dbSeek(xFilial('SA2')+SC7->C7_FORNECE + SC7->C7_LOJA  )
	
	If !bHTMnovo
		oHtml:ValByName( "lb_nome", SA2->A2_NREDUZ )
	EndIf
	
	cAprov   := SCR->CR_USER
	
	oHtml:ValByName('CAPROV',cAprov)
	
//	conout('Aprovador: '+cAprov )
	
	PswOrder(1)
	IF PswSeek(cAprov,.t.) // .and. cAprov <> "000000"
		aInfo    := PswRet(1)
		cMailAp  := alltrim(aInfo[1,14])
		cNomeAP  := aInfo[1,2]
		cNomeInt := aInfo[1,4]
	ENDIF
	
	//Pego as condicoes de Pagamento
	dbSelectArea('SE4')
	DBSETORDER(1)
	dbSeek(xFilial('SE4') + SC7->C7_COND)
	//While !Eof() .and. xFilial('SE4')==E4_FILIAL
	//  aadd(aCond,"'"+E4_DESCRI+"'")
	//  dbSkip()
	//end
	ccond := SE4->E4_DESCRI
	
	If !bHTMnovo
		oHtml:ValByName( "lb_cond", CCOND )
	EndIf
	
	sc8->(dbsetorder(3))
	sc1->(dbsetorder(1))
	sa2->(dbsetorder(1))
	
	lAchou := sc8->(dbseek(xfilial("SC8")+sc7->c7_numcot))
	if !lAchou
		If bHTMnovo
			AAdd( (oHtml:ValByName( "b.NCotacao"       )),'COTAÇÃO INEXISTENTE')
			AAdd( (oHtml:ValByName( "b.Item"           )),'  ')
			AAdd( (oHtml:ValByName( "b.Quantidade"     )),'  ')
			AAdd( (oHtml:ValByName( "b.Unidade"        )),'  ')
			AAdd( (oHtml:ValByName( "b.VlrTotal"       )),'  ')
			AAdd( (oHtml:ValByName( "b.Fornec"         )),'  ')
			AAdd( (oHtml:ValByName( "b.DtCotacao"      )),'  ')
			AAdd( (oHtml:ValByName( "b.Observ"         )),'  ')
		Else
			AAdd( (oHtml:ValByName( "itc.Cot_codigo"   )),'COTAÇÃO INEXISTENTE')
			AAdd( (oHtml:ValByName( "itc.Cot_descricao")),'  ' )
			AAdd( (oHtml:ValByName( "itc.Cot_CodForn"  )),'  ' )
			AAdd( (oHtml:ValByName( "itc.Cot_NomeForn" )),'  ' )
			AAdd( (oHtml:ValByName( "itc.Cot_quant"    )),'  ' )
			AAdd( (oHtml:ValByName( "itc.Cot_Unid"     )),'  ' )
			AAdd( (oHtml:ValByName( "itc.Cot_preco"    )),'  ' )
			AAdd( (oHtml:ValByName( "itc.Cot_total"    )),'  ' )
		EndIf
	endif
	
	While sc8->(!eof())  .and. sc8->c8_num == sc7->c7_numcot
		sc1->(dbseek(xfilial("SC1")+sc8->c8_numsc+sc8->c8_itemsc))
		sa2->(dbseek(xfilial("SA2")+sc8->c8_fornece))
		
		_xcCodCota	:= SC8->C8_NUM
		_xcCodFili	:= SC8->C8_FILIAL
		
		If bHTMnovo
			AAdd( (oHtml:ValByName( "b.NCotacao"       )),SC8->C8_NUM+'/'+SC8->C8_ITEM)
			AAdd( (oHtml:ValByName( "b.Item"           )),SC8->C8_ITEMSC              )
			AAdd( (oHtml:ValByName( "b.Quantidade"     )),Transform(SC8->C8_QUANT,'@E 999,999,999.99') )
			AAdd( (oHtml:ValByName( "b.Unidade"        )),SC8->C8_UM                  )
			AAdd( (oHtml:ValByName( "b.VlrTotal"       )),Transform(SC8->C8_TOTAL,'@E 999,999,999.99') )
			AAdd( (oHtml:ValByName( "b.Fornec"         )),Alltrim(SA2->A2_NOME)       )
			AAdd( (oHtml:ValByName( "b.DtCotacao"      )),DtoC(SC8->C8_EMISSAO)       )
			if SC8->(FieldPos("C8_XXOBSC"))>0
				AAdd( (oHtml:ValByName( "b.Observ"         )),Alltrim(SC8->C8_XXOBSC)        )
			else
				AAdd( (oHtml:ValByName( "b.Observ"         )),"  "        )
//				conout('campo C8_XXOBSC não criado')
			endif
		Else
			AAdd( (oHtml:ValByName( "itc.Cot_codigo"   )),sc8->c8_produto)
			AAdd( (oHtml:ValByName( "itc.Cot_descricao")),sc1->descri + " - OBS: " + SC8->C8_OBS )
			AAdd( (oHtml:ValByName( "itc.Cot_CodForn"  )),sc8->c8_fornece )
			AAdd( (oHtml:ValByName( "itc.Cot_NomeForn" )),sa2->a2_nreduz )
			AAdd( (oHtml:ValByName( "itc.Cot_quant"    )),TRANSFORM( sc8->C8_QUANT,'@E 999,999.99' ) )
			AAdd( (oHtml:ValByName( "itc.Cot_Unid"     )),sc8->c8_um )
			AAdd( (oHtml:ValByName( "itc.Cot_preco"    )),TRANSFORM( sc8->C8_preco,'@E 999,999.99' ) )
			AAdd( (oHtml:ValByName( "itc.Cot_total"    )),TRANSFORM( sc8->C8_total,'@E 999,999.99' ) )
		EndIf
		
		sc8->(dbskip())
	enddo
	
	dbSelectArea('SC7')
	dbSetOrder(1)
	
	cNum := SC7->C7_NUM
	dbSeek(xFilial('SC7') + cNum)
	
		if SC7->(FieldPos("C7_XXALTER"))>0
			If !Empty(SC7->C7_XXALTER)
				cTxtAltera := '<br>'+StrTran(SC7->C7_XXALTER,Chr(13),'<br>')
			Else
				cTxtAltera := 'Pedido não sofreu alteração.'
			EndIf
			oHtml:ValByName( "cMotAlteracao", cTxtAltera )
		ELSE
			oHtml:ValByName( "cMotAlteracao", "" )
			
		EndIf
	While SC7->(!Eof()) .and. SC7->C7_NUM = cNum
		nTotal := nTotal + SC7->C7_TOTAL
		nTtlIPI += SC7->C7_TOTAL + SC7->C7_VALIPI    //IPI
		
		_xnMoeda	:= SC7->C7_MOEDA
		
//			conout('Linha: 433')
			cDescCC  := Alltrim( Posicione("CTT",1,xFilial("CTT")+SC7->C7_CC,'CTT_DESC01') )
			
			AAdd( (oHtml:ValByName( "c.Item"        )) , SC7->C7_ITEM                                 )
			AAdd( (oHtml:ValByName( "c.DescrProd"   )) , SC7->C7_DESCRI                               )
			AAdd( (oHtml:ValByName( "c.Quantidade"  )) , Transform(SC7->C7_QUANT ,'@E 999,999,999.99'))
			AAdd( (oHtml:ValByName( "c.Unidade"     )) , SC7->C7_UM                                   )
			AAdd( (oHtml:ValByName( "c.VlrUnit"     )) , Transform(SC7->C7_PRECO ,'@E 999,999,999.99'))
			AAdd( (oHtml:ValByName( "c.VlrIPI"      )) , Transform(SC7->C7_VALIPI,'@E 999,999,999.99'))
			AAdd( (oHtml:ValByName( "c.VlrTotal"    )) , Transform(SC7->C7_TOTAL ,'@E 999,999,999.99'))
			AAdd( (oHtml:ValByName( "c.CCusto"      )) , cDescCC                                      )
			AAdd( (oHtml:ValByName( "c.Observ"      )) , SC7->C7_OBS                                  )
			
			// Atualizando dados da Solicitação de Compras:
			SC1->( dbSetOrder(1) )
			If !Empty(SC7->C7_NUMSC) .and. SC1->( dbSeek( SC7->C7_FILIAL + SC7->C7_NUMSC + SC7->C7_ITEMSC ) )
				cDescCC   := Alltrim( Posicione("CTT",1,xFilial("CTT")+SC1->C1_CC,'CTT_DESC01'      ) )
				cDesFil   := Posicione("SM0",1,'01'+SC1->C1_FILIAL,"M0_FILIAL")
				cNomeSoli := UsrFullName(SC1->C1_USER)
				
				oHtml:ValByName( "cNumSolic"       , SC1->C1_NUM                                   )
				oHtml:ValByName( "cFilial"         , SC1->C1_FILIAL+"-"+cDesFil                    )
				oHtml:ValByName( "cDataEmissao"    , DtoC(SC1->C1_EMISSAO)                         )
				oHtml:ValByName( "cRequisitante"   , cNomeSoli                                     )
				
				AAdd( (oHtml:ValByName( "a.Item"        )) , SC1->C1_ITEM                            )
				AAdd( (oHtml:ValByName( "a.Codigo"      )) , SC1->C1_PRODUTO                         )
				AAdd( (oHtml:ValByName( "a.DescrProd"   )) , SC1->C1_DESCRI                          )
				AAdd( (oHtml:ValByName( "a.Quantidade"  )) , Transform(SC1->C1_QUANT,'@E 999,999,999.99') )
				AAdd( (oHtml:ValByName( "a.Unidade"     )) , SC1->C1_UM                              )
				AAdd( (oHtml:ValByName( "a.Entrega"     )) , DtoC(SC1->C1_DATPRF)                    )
				AAdd( (oHtml:ValByName( "a.DescrCC"     )) , cDescCC                                 )
				if SC1->(FieldPos("C1_XXOBS"))>0
					
					AAdd( (oHtml:ValByName( "a.Observ"      )) , SC1->C1_XXOBS                           )
				else
//					conout("campo C1_XXOBS não criado")
				endif
			Else
				// Pedido incluído diretamente, sem solicitação
				oHtml:ValByName( "cNumSolic"       , '  '                                            )
				oHtml:ValByName( "cFilial"         , '  '                                            )
				oHtml:ValByName( "cDataEmissao"    , '  '                                            )
				oHtml:ValByName( "cRequisitante"   , '  '                                            )
				
				AAdd( (oHtml:ValByName( "a.Item"        )) , '  '                                    )
				AAdd( (oHtml:ValByName( "a.Codigo"      )) , '  '                                    )
				AAdd( (oHtml:ValByName( "a.DescrProd"   )) , 'SOLICITAÇÃO INEXISTENTE'               )
				AAdd( (oHtml:ValByName( "a.Quantidade"  )) , '  '                                    )
				AAdd( (oHtml:ValByName( "a.Unidade"     )) , '  '                                    )
				AAdd( (oHtml:ValByName( "a.Entrega"     )) , '  '                                    )
				AAdd( (oHtml:ValByName( "a.DescrCC"     )) , '  '                                    )
				AAdd( (oHtml:ValByName( "a.Observ"      )) , '  '                                    )
			EndIf
		
//		conout('Linha: 471'+' Reclock:'+cNomeInt+GetEnvServer())
		RecLock("SC7")
		//      C7_WFID := oProcess:fProcessID
		C7_FILENT       := C7_FILIAL
		
		if SC7->(FieldPos("C7_XXAPROV"))>0
			SC7->C7_XXAPROV := cNomeInt
		endif
		SC7->( MsUnlock() )
		dbSkip()
	Enddo
	
	Do Case
		Case _xnMoeda = 0
			cMoeImp	:= "R$     "
		Case _xnMoeda = 1
			cMoeImp	:= "R$     "
		Case _xnMoeda = 2
			cMoeImp	:= "US$    "
		Case _xnMoeda = 3
			cMoeImp	:= "UFIR   "
		Case _xnMoeda = 4
			cMoeImp	:= "EURO   "
		Case _xnMoeda = 5
			cMoeImp	:= "USGAAP "
		Case _xnMoeda = 6
			cMoeImp	:= "LIBRA  "
		Case _xnMoeda = 7
			cMoeImp	:= "IENE   "
		Case _xnMoeda = 8
			cMoeImp	:= "USF    "
	EndCase
	
	If !bHTMnovo
		oHtml:ValByName( "lbValor" ,TRANSFORM( nTotal,'@E 999,999.99' ) )
		oHtml:ValByName( "lbFrete" ,TRANSFORM( 0,'@E 999,999.99' ) )
		oHtml:ValByName( "lbTotal" ,TRANSFORM( nTotal,'@E 999,999.99' ) )
		oHtml:ValByName( "cTxtAltera" ,cTxtAltera )
		oHtml:ValByName( "cMoeImp" ,cMoeImp ) //MOEDA
	Else
		oHtml:ValByName( "cTotalComIPI" ,TRANSFORM( nTtlIPI,'@E 99,999,999.99' ) )      //IPI
//		oHtml:ValByName( "cMoeImp" ,cMoeImp ) //MOEDA
		//		oHtml:ValByName( "cTotalComIPI" ,TRANSFORM( nTotal,'@E 99,999,999.99' ) )      //IPI
	EndIf
	
	oProcess:ClientName( Subs(cUsuario,7,15) )
	
	if lAchou02
		oProcess:cTo := usrretmail(cAprov)
	else
		oProcess:cTo := usrretmail(SC7->C7_USER) 
	endif
	
	SC8->(Dbseek(_xcCodFili + _xcCodCota))
//adiciona arquivo da cotação.
//ao e-mail
//	While SC8->(!EOF()) .And. SC8->C8_FILIAL = _xcCodFili .And. SC8->C8_NUM = _xcCodCota
//		_xcEndCota	:= SC8->C8_ENDCOTA
//		oProcess:AttachFile(_xcEndCota)
//		SC8->(DbSkip())
//	Enddo
	
//	conout('email aprovador: ' + usrretmail(cAprov))
	
	DbSelectArea("WF7")
	DbGoTop()
	
	cEmpAnt       :='01'
	cmailid       := oProcess:FProcessId
	chtmlfile1    := cmailid + ".htm"
	IF lAchou02
		cVarLink	     := 'PARA APROVAÇÃO DESTE PEDIDO, CLIQUE AQUI (<a href=' + GetNewPar("MV_WFHTTP",     "http://10.229.19.50:80/wf/01/") + cHtmlFile1 + '>Acesso Escritorio</a><a href=' + GetNewPar("MV_WFHTTP2","http://10.229.19.50:80/wf/01/"+cEmpAnt+"/") + cHtmlFile1 + '></a>).<p>'
	ELSE
		cVarLink	     := ''
	ENDIF
	
	//uso futuro para aprovação remota
	//	oHtml:ValByName("Link",  cVarLink   )
	cmailid       := oProcess:Start("\web\compras\" + cEmpAnt + "\")
	cmailto       := "mailto:" + AllTrim(WF7->WF7_ENDERE)
	chtmltexto    := wfloadfile("\web\compras\"+cEmpAnt+"\" + cmailid + ".htm")
	_lTeste       := GetNewPar("MV_WFTST", .T.)
	chtmltexto    := strtran(chtmltexto, cmailto, "WFHTTPRET.APL")
	chtmltexto    := strtran(chtmltexto, cVarLink, "")
	wfsavefile("\web\compras\"+cEmpAnt+"\" + chtmlfile1, chtmltexto) // grava novamente com as alteracoes necessarias.
	
	//oProcess:UserSiga := "000004"
	//	oHtml:valByName('botoes', '<input type=submit name=B1 value=Enviar> <input type=reset name=B2 value=Limpar>')
	
	//oProcess:Start()
	RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,"000001",'1005')
	//    wfSendMail()
	//RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10001','Processo do Pedido '+cNum+' iniciado!' )
	//	oProcess:Free()
	//	oProcess:= Nil
endif

Return

STATIC FUNCTION SPCTimeOut( oProcess )
//ConOut("Funcao de TIMEOUT executada")
oProcess:NewTask('Time Out',"\workflow\htm\timeout.htm")
oHtml:=oProcess:oHtml
oHtml:RetByName("Titulo","Usuario não respondeu e-mail")
oHtml:RetByName("numPed",_cPedido)
oHtml:RetByName("cliente",_ccliente)
_cUser = Subs(cUsuario,7,15)
oHtml:RetByName("usuario",_cUser)
subj := "Pedido"+ _cPedido + " por " + _ccliente
oProcess:Start()
WFSendMail()
Return


//ponto de entrada no final da rotina de aprovação de pedidos 
//para validar se foi liberado ou bloqueado o documento
//ParamIXB = {cDocto,cTipo,nOpc, cFilDoc} :
//ParamIXB = {cDocto,cTipo,nOpc,cFilDoc} onde :
/*
cDocto == Numero do Documento
cTipo == Tipo do Documento "PC" "AE" "CP"
Quando o ponto é acionado pela rotina de Liberação e Superior:
nOpc == 1 --> Cancela 
nOpc == 2 --> Libera 
nOpc == 3 --> Bloqueia
Quando o ponto é acionado pela rotina de Transf. Superior
nOpc == 1 --> TransferenOpc == 2 --> CancelaObs.: 
Para esta rotina, caso não exista o superior cadastrado, a variável seráenviada como Nil. Deve ser tratado no ponto de entrada.
cFilDoc == Filial do Documento
*/

user function MT097END()
Local cDocto := ParamIXB[1]
Local cTipo  := ParamIXB[2]
Local nOpc   := ParamIXB[3]
//conout('MT097END')
IF cTipo ='PC'
	if nOpc ==2
//		conout('MT097END-NOPC=2')
		u_PCLib(cDocto)
	elseif nOpc ==3
//		conout('MT097END-NOPC=3')
		u_PCBlq(cDocto,cTipo)
	endif
endif

return


//quando o pedido liberado
user function PCLib(cDocto)
		dbSelectArea('SC7')
		SC7->(dbSetOrder(1))
		SC7->(dbSeek(xFilial('SC7')+ALLTRIM(cDocto)))
//		conout("dbSelectArea('SC7')")
		cAprov := RetCodUsr()                                
		cObsRet:=""                        
		cObsRet:=SCR->CR_OBS            
		cNum :=SC7->C7_NUM 
//		conout('Aviso ao comprador e usuário do pedido:'+cDocto)
//		conout('LIBERACAO DE PEDIDO')
//		CONOUT('motivo')          
//		conout(cObsRet)
		_oProc := TWFProcess():New( "000006", "Pedido para o Fornecedor" )
		_oProc:NewTask( "Solicitação de Pedido", "\WORKFLOW\html\wfw120p2.HTM" )
		_oProc:cSubject := "Pedido de Compra 'APROVADO' " + SC7->C7_NUM
//		conout("Pedido de Compra 'APROVADO' " + SC7->C7_NUM)
		_oProcHTM := _oProc:oHTML
		
		/*** Preenche os dados do cabecalho ***/
		_oProcHTM:ValByName( "PEDIDO", cNum )
		_oProcHTM:ValByName( "EMISSAO", dtoc(SC7->C7_EMISSAO) )
		_oProcHTM:ValByName( 'CAPROV', UsrFullName(cAprov) )
		_oProcHTM:ValByName( 'COBS', cObsRet )
		
		_oProc:cTo	:= usrretmail(SC7->C7_USER)
//		CONOUT('ENVIO DE EMAIL PARA:')
//		CONOUT(_oProc:cTo)
		
		_oProc:Start()
		//			RastreiaWF(_oProc:fProcessID+'.'+_oProc:fTaskID,"000006",'1007',"Pedido de Compras "+cNum+" Aprovado e enviado ao Comprador")
//		conout('finaliza processo')
		_oProc:Finish()
		
return

//quando o pedido bloqueado
user function PCBlq(cDocto,cTipo)
Local aAreaGER := GetArea()
Local aAreaSCR := SCR->( GetArea() )

      SCR->( dbSetOrder(1) )
      SCR->( dbSeek( xFilial() + cTipo + cDocto ) )
      
		dbSelectArea('SC7')
		SC7->(dbSetOrder(1))
		SC7->(dbSeek(xFilial('SC7')+ALLTRIM(cDocto)))
//		conout("dbSelectArea('SC7')")
		cAprov := RetCodUsr()                                
		cObsRet:=""                        
		cObsRet:=SCR->CR_OBS
		cNum   :=SC7->C7_NUM 
//		conout('Aviso ao comprador e usuário do pedido:'+cDocto)
//		CONOUT('PEDIDO BLOQUEADO')
//		CONOUT('motivo')          
//		conout(cObsRet)
		_oProc := TWFProcess():New( "000006", "Pedido para o Fornecedor" )
		_oProc:NewTask( "Solicitação de Pedido", "\WORKFLOW\html\wfw120p3.HTM" )
		_oProc:cSubject := "Pedido de Compra 'REPROVADO' " + SC7->C7_NUM
//		conout("Pedido de Compra 'REPROVADO' " + SC7->C7_NUM)
		_oProcHTM := _oProc:oHTML
		
		If Empty(cObsRet) .and. dDataBase <= StoD("20140805")
		   cQuery := "SELECT CR_OBS FROM SCR010 WHERE CR_OBS <> '' AND CR_NUM = '"+SC7->C7_NUM+"' AND CR_TIPO = 'PC' AND D_E_L_E_T_ = '' "
		   If Select("QUERYSCR") <> 0
		      QUERYSCR->( dbCloseArea() )
		   EndIf
		   TCQUERY cQuery NEW ALIAS "QUERYSCR"
		   While !QUERYSCR->( EOF() )
		      cObsRet += Alltrim(QUERYSCR->CR_OBS)+'/'
		      QUERYSCR->( dbSkip() )
		   End
		   cObsRet := Subs(cObsRet,1,Len(cObsRet)-1)
		   If Empty(cObsRet)
		      cObsRet := "Observações não encontradas"
		   EndIf
		EndIf
		
		/*** Preenche os dados do cabecalho ***/
		_oProcHTM:ValByName( "PEDIDO" , cNum                )
		_oProcHTM:ValByName( "EMISSAO", DTOC(SC7->C7_EMISSAO) ) // INCLUIDO DTOC MLS
		_oProcHTM:ValByName( 'CAPROV' , UsrFullName(cAprov) )
		_oProcHTM:ValByName( 'COBS'   , cObsRet             )
		
		If dDataBase <= StoD("20140805")
		   _oProc:cTo	:= usrretmail(SC7->C7_USER)+';helio@opusvp.com.br'
		Else
		   _oProc:cTo	:= usrretmail(SC7->C7_USER)
		EndIf
		
//		CONOUT('ENVIO DE EMAIL PARA:')
//		CONOUT(_oProc:cTo)
		_oProc:Start()
		//			RastreiaWF(_oProc:fProcessID+'.'+_oProc:fTaskID,"000006",'1007',"Pedido de Compras "+cNum+" Aprovado e enviado ao Comprador")
//		conout('finaliza processo')
		_oProc:Finish()

   RestArea(aAreaSCR)
   RestArea(aAreaGER)
   
return


user function FlwUP()
if SC7->(FieldPos("C7_XXALTER"))>0
	cTxtMotivo := SC7->C7_XXALTER //+ Space(300-Len(Alltrim(SC7->C7_XXALTER)))
else
	cTXTMotivo := ""
endif  
aRetFLW :={}
aRetFLW := u_DlgFLWPC1(sc7->c7_DMXOB1,sc7->c7_DMXOB2,sc7->c7_DMXOB3,SC7->C7_DATPRF)
if !empty(aRetFLW)
	//verifica se algum campo foi alterado
	if 	aRetFLW[1] <> sc7->c7_DMXOB1;
		.or.  aRetFLW[2] <> sc7->c7_DMXOB1;
		.or.  aRetFLW[3] <> sc7->c7_DMXOB1;
		.or.  aRetFLW[4] <> C7_DATPRF
		lFLWALT := .t.
	else
		lFLWALT := .f.
	endif
	if lFLWALT
		reclock("SC7",.f.)
		sc7->c7_DMXOB1 := aRetFLW[1]
		sc7->c7_DMXOB2 := aRetFLW[2]
		sc7->c7_DMXOB3 := aRetFLW[3]
		SC7->C7_DATPRF := aRetFLW[4]
		
		sc7->(msunlock())
	endif
endif


//return
/*
DEFINE FONT oFont NAME "Courier New" SIZE 5,0   //6,15
DEFINE MSDIALOG oDlg TITLE 'Pedido de Compras' From 3,0 to 370,435 PIXEL
@ 05,10 SAY "Follow Up de pedido de compras" SIZE 200,20 PIXEL OF oDlg

@ 25,10 GET oMemo  VAR cTxtMotivo MEMO SIZE 200,145 OF oDlg PIXEL
oMemo:bRClicked := {||AllwaysTrue()}
oMemo:oFont:=oFont
DEFINE SBUTTON  FROM 172,184 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL
ACTIVATE MSDIALOG oDlg CENTER

if SC7->(FieldPos("C7_XXALTER"))>0
	If Reclock("SC7",.F.)
		SC7->C7_XXALTER := cTxtMotivo
	Else
		apMsgStop('Não foi possível gravar o motivo da alteração!')
	EndIf
else
	conout("campo c7_XXALTER não criado, não foi possivel gravar o motivo da alteração")
endif
*/
return

