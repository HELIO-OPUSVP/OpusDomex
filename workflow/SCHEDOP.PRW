#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "ap5mail.ch"
#INCLUDE "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SCHEDOP  ºAutor  ³ Michel A. Sander   º Data ³  27/07/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Agendamento para apontamento de ordens de produção         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SCHEDOP(cOPSchedule)

Local aAbreTab := {}
Local aWfItens := {}
Local aWfEmpre := {}
Local cWfEmp := "01"
Local cWfFil := "01"
Local aSched := {}

Private lMsErroAuto    := .F.

Default cOPSchedule := ""

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Prepara função para ser executada via JOB/Schedule		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type("cEmpAnt") == "U"
	RPCSetType(3)
	aAbreTab := {}
	RpcSetEnv(cWfEmp,cWfFil,,,,,aAbreTab)
	SetUserDefault("000000")
EndIf

cAliasP06 := GetNextAlias()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Seleciona as OPs que serão apontadas			   		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(cOPSchedule)
   BeginSQL Alias cAliasP06
	   SELECT TOP 1 * From %table:P06% P06 (NOLOCK) WHERE P06_STATUS = '' AND P06.%NotDel%
   EndSQL
Else
   _cWhere   := "%P06_OP = '"+cOPSchedule+"'%"

   BeginSQL Alias cAliasP06
	   SELECT * From %table:P06% P06 (NOLOCK) WHERE P06_STATUS = '' AND P06.%NotDel% AND %Exp:_cWhere%
   EndSQL
EndIf

Do While (cAliasP06)->(!Eof())
	
	SC2->( dbSetOrder(1) )
	If SC2->(dbSeek(xFilial()+(cAliasP06)->P06_OP))
		
		aSched := {}
		Aadd(aSched,{"D3_OP     " , SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN , NIL })
		Aadd(aSched,{"D3_TM     " , "010"	            		              , NIL })
		Aadd(aSched,{"D3_LOCAL  " , SC2->C2_LOCAL			     		           , NIL })
		Aadd(aSched,{"D3_COD    " , SC2->C2_PRODUTO			                 , NIL })
		Aadd(aSched,{"D3_QUANT  " , (cAliasP06)->P06_QUANT                  , NIL })
		Aadd(aSched,{"D3_XXPECA " , (cAliasP06)->P06_PECA                   , NIL })
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Aponta OP												   		³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lMsErroAuto := .F.
		MSExecAuto({|x,y| mata250(x,y)},aSched,3)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza Registro										   		³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lMsErroAuto
		   cPasta   := "\UTIL\LOG\SCHEDULE_OP\" 
    		cArqLog  := StrTran((cAliasP06)->P06_OP+".log"," ","")
    		MostraErro(cPasta,cArqLog)
			
			//Mostraerro(cArqLog)
			cMenErro := MEMOREAD(cPasta+cArqLog)
			P06->( dbGoto((cAliasP06)->R_E_C_N_O_) )
			
			If (cAliasP06)->R_E_C_N_O_ == P06->( Recno() )
				Reclock("P06",.F.)
				P06->P06_STATUS := "N"
				P06->P06_LOG    := cMenErro
				P06->(MsUnlock())
			EndIf
			
			CONOUT("APONTAMENTO OP "+(cAliasP06)->P06_OP+" NAO CONCLUIDO!")
		Else
			P06->( dbGoTo( (cAliasP06)->R_E_C_N_O_) )
			
			If (cAliasP06)->R_E_C_N_O_ == P06->( Recno() )
			   Reclock("P06",.F.)
			   P06->P06_STATUS := "S"
			   P06->P06_LOG    := "Apontamento OK"
			   P06->(MsUnlock())
			EndIf
			
			CONOUT("APONTAMENTO OP "+(cAliasP06)->P06_OP+" OK!")
		EndIf
	EndIf
	
	(cAliasP06)->(dbSkip())
	
EndDo

(cAliasP06)->(DbCloseArea())

Return