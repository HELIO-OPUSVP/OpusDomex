#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ETQMTA250 ºAutor ³Michel Sander       º Data ³  08/13/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para apontamento automático de OP na impressao      º±±
±±º          ³ das etiquetas de embalagens de PA                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ DOMETQDL3.prw                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ETQMTA250(__TM, __OP, __PRODUTO, __LOCAL, __NQTDE, __CTOTPARC, __XXPECA)
Local lStartJob := .F.
Local _Retorno, aRetorno 
Local aAreaGER  := GetArea()

If !lStartJob
   MsgRun("U_ETQMTA250()","Apontandontamento de OP...",{|| aRetorno := U_AptoProd(__TM, __OP, __PRODUTO, __LOCAL, __NQTDE, __CTOTPARC, __XXPECA) })
Else
   MsgRun("U_ETQMTA250()","Apontandontamento de OP...",{|| aRetorno := U_SJobM250(__TM, __OP, __PRODUTO, __LOCAL, __NQTDE, __CTOTPARC, __XXPECA) })
EndIf
If Len(aRetorno) > 0
	If !aRetorno[1]
		If Type("_lColetor") == "U"
	      //apMsgInfo(aRetorno[2])
	      U_MsgColetor(aRetorno[2],2)
	   Else
	      If _lColetor 
	         U_MsgColetor(aRetorno[2])
	      Else
	         apMsgInfo(aRetorno[2])
	      EndIf
	   EndIf
	EndIf	
	_Retorno := .T. // aRetorno[1]
else
	_Retorno := .F. // aRetorno[1]
EndIf
RestArea(aAreaGER)

Return _Retorno


User Function SJobM250(__TM, __OP, __PRODUTO, __LOCAL, __NQTDE, __CTOTPARC, __XXPECA)

Local aRetorno

aRetorno := startjob("U_AptoProd",getenvserver(),.T.,__TM, __OP, __PRODUTO, __LOCAL, __NQTDE, __CTOTPARC, __XXPECA )

Return aRetorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AptoProd  ºAutor ³Michel Sander       º Data ³  08/13/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processamento do apontamento de produção					     º±±
±±º          ³ 											                          º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AptoProd(__TM, __OP, __PRODUTO, __LOCAL, __NQTDE, __CTOTPARC, __XXPECA)

Local lOP := .T.
Local aErroProd := {}

If Type("cUsuario") == "U"
   //RPCSetType(3)
   aAbreTab := {}
   RpcSetEnv("01","01",,,,,aAbreTab) //PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"
   SetUserDefault("000000")
EndIf

SB1->( dbSetOrder(1) )
SB1->( dbSeek( xFilial() + __PRODUTO ) )

_aETQ := {}
Aadd(_aETQ,{"D3_OP     " , __OP					   		     , NIL })
Aadd(_aETQ,{"D3_TM     " , __TM	                          , NIL })
Aadd(_aETQ,{"D3_LOCAL  " , __LOCAL        		           , NIL })
Aadd(_aETQ,{"D3_COD    " , __PRODUTO		                 , NIL })
Aadd(_aETQ,{"D3_QUANT  " , __NQTDE	                       , NIL })
Aadd(_aETQ,{"D3_XXPECA " , __XXPECA	                       , NIL })

Private lokVD3_QUANT := U_VD3_QUANT(__OP,__NQTDE,__PRODUTO,__LOCAL)
Private lMsHelpAuto    := .T.
//Private lMsErroAuto    := .F.
If lokVD3_QUANT
	
	If .T. //Subs(SB1->B1_GRUPO,1,3) <> 'DIO' //SB1->B1_GRUPO == 'CORD' .Or. SB1->B1_GRUPO == 'JUMP' .Or. SUBSTR(SB1->B1_GRUPO,1,3)='DIO' .Or. SUBSTR(SB1->B1_GRUPO,1,4)='DIOE' .Or. SB1->B1_GRUPO == 'TRUN' .Or. SB1->B1_GRUPO == 'TRUE'
		
		Public lAutoMt250      := .T.
		Public lProc113        := .F.
		//=> PARA VOLTAR //MSExecAuto({|x,y| mata250(x,y)},_aETQ,3)		  // MATA250 Padrão do Release atual
		//MSExecAuto({|x,y| U_NewMt250(x,y)},_aETQ,3)     // MATA250 da versão 12.1.7 convertido para teste
		
		//Novo apontamento de produção
		aErroProd := U_ProdDomex(_aETQ)
		lAutoMt250 := .F.
		
		//If aErroProd[1] == .F.
		//  apMsgAlert(aErroProd[2])
		//  Return .F.
		//EndIf
		
	Else
		//apMsgYesNo("Somente P06. Não apontou")
		//SC2->( dbSetOrder(1) )
		//If SC2->( dbSeek( xFilial() + __OP ) )
		//	If Reclock("SC2",.F.)
		//		SC2->C2_XXQUJE += __NQTDE    Retirado por Hélio em 25/09/18
		//		SC2->( msUnlock() )
		//	EndIf
		//EndIf
		
	EndIf
	
	Reclock("P06",.T.)
	P06->P06_FILIAL := xFilial("P06")
	P06->P06_OP     := __OP
	P06->P06_DATA   := Date()
	P06->P06_HORA   := Time()
	P06->P06_QUANT  := __NQTDE
	P06->P06_CODUSU := __cUserID
	P06->P06_PECA   := __XXPECA
	P06->P06_SEQ    := "0001" // query para retornar sequencia
	P06->P06_STATUS := If( aErroProd[1] ,"S" , "N") 
	P06->P06_LOG    := aErroProd[2]
	P06->(MsUnlock())
	
	/*
	If lMsErroAuto
		lOP := .F.
		If Type("_lColetor") == "U"
			MostraErro()
			lOP := .F.
		Else
			If !_lColetor
				MostraErro()
				lOP := .F.
			Else
				MostraErro("\UTIL\LOG\Apontamento_producao_DIO\")
			EndIf
		Endif
	EndIf
	*/
Else
	
	lOP := .F.
	
EndIf

Return ( aErroProd )
