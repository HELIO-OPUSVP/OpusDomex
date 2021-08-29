#include "rwmake.ch"
#include "topconn.ch"
#include "totvs.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA416BX  ºAutor  ³Marcos Rezende      º Data ³  06/27/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para Validar se o orçamento esta aprovado º±±
±±º          ³ e liberando portanto a geração do pedido de venda          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION MT415EFT()
LOCAL NOPC := PARAMIXB[1] 
Local cAlias
Local cOrcNum
Local lRet := .t.


// Parametro Logico para Habilitar(.T.)  Validaco de Credito no Orcamento.
if getmv("MV_XCRDORC") 


	cOrcNum := SCJ->CJ_NUM
	cOrcNum := subs(cOrcNum+space(9),1,9)

	SZP->(DBSETORDER(1))
	/* desativa até ser validado

	//só realizar a verificação de aprovação caso existe
	//registro na tabela SZP, devido a esta tabela ser preenchida
	//somente quanto o critério de bloqueio é atendido
	//do contrário o orçamento continua sendo liberado
	if szp->(dbseek(xfilial("SZP")+'O'+cOrcNum+'0001'))
		//caso encontre o registro no cdastro de bloqueios
		//verifica se a data de aprovação esta preenchida
		IF SZP->ZP_DTAPRV>=ddatabase
			lRet := .t.
		else              
			ALERT('Orçamento bloqueado por margem, não poderá ser efetivado.'+chr(13)+'Contate aprovador de Orçamentos')
			lRet := .f.
		endif
	endif
	*/




	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida se a Condiçao de Pagamento e' Cartao de Credito (risco E) e exige ³
	//³preenchimento da Autorizacaoo do Cartao para Liberar Orcamento.          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							

	cCondE := Posicione("SE4",1,xFilial("SE4") + SCJ->CJ_CONDPAG,"E4_XRISCOE")
	if cCondE
		if empty(SCJ->CJ_XAUTCC)
			MsgAlert("Orçamento Bloqueado. Aguardando código de Autorização do Cartão de Crédito.")
			lRet := .f.
		else

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza Flag do campo CJ_STATUS Liberacao do Orcamento - MAS - Marco Aurelio - OPUSVP    ³
			//³ A=Aguardando Liberacao Diretoria                                                                  ³
			//³ B=Aguardando Autorizacao Cartao de Credito                                               ³
			//³ C=Autorizado Cartao de Credito                                                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			cQry := ""
			cQry += " update "+retsqlname('SCJ')+" SET CJ_XSTATUS = 'C' WHERE CJ_NUM='"+cOrcNum+"' "
			tcsqlexec(cQry)

			
		endif

	Endif



	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Avalia Limite de Crédito do Orçamento.        ³
	//³Se não tiver limite, não permite a Efetivação.³
	//³Marco Aurelio - MAS - OPUS                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//    // Parametro Logico para Habilitar(.T.)  Validaco de Credito no Orcamento.
	//    if getmv("MV_XCRDORC") 

													
		cQuery := "SELECT SUM(CK_VALOR) AS TOTORC FROM " + RetSqlName("SCK") + " WHERE CK_NUM = '"+SCJ->CJ_NUM+"' AND D_E_L_E_T_ = '' "
		If Select("TEMP") <> 0
			TEMP->( dbCloseArea() )
		EndIf
		TCQUERY cQuery NEW ALIAS "TEMP"
		_nTotOrc := TEMP->TOTORC

		nValAv	:=	_nTotOrc  	// Valor Total do Item/Orcamento a ser Avaliado
		lCredito := MaAvalCred(SCJ->CJ_CLIENTE,SCJ->CJ_LOJA,nValAv,1,.T.,"")	// Cliente,Loja,Valor,Moeda,.T.													
		

		if !lCredito
			MsgAlert("Cliente Não possui Crédito para Efetivar este Orçamento."+Chr(13)+Chr(10)+"Consulte a Posição do Cliente!")
			lret	:= .F.
		Else
			Alert("lCredito - Possui Credito")
			lret	:= .F.
		endif


Endif



RETURN lret
