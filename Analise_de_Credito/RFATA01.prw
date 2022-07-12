#Include "Protheus.ch"
#Include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºAtualiza  ³RFATA01    ºAutor  ³Marco Aurelio-OPUS º Data ³  15/09/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±    
±±ºPrograma  ³RFATA01    ºAutor  ³Marco Aurelio-OPUS º Data ³  09/02/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza Dados de Analise de Crédito no Cadastro de Clientesº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ DOMEX - Analise de Credito ###                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//testejonas

//teste jonas 2

// teste marco
User Function RFATA01()

Private cAlias := "SA1"

DbSelectArea(cAlias)
aRotina := {}

AADD(aRotina,{ "Pesquisar       ",'AxPesqui'     , 0, 1 } )
AADD(aRotina,{ "Visualizar      ",'AxVisual'     , 0, 2 } )
AADD(aRotina,{ "Crédito         ",'U_RDTCRED'  	 , 0, 3 } )

cCadastro := "Analise de Crédito - Manutenção"
mBrowse( 6, 1,22,75,cAlias,,,,,,,,,,,,,,)  

Return



User Function RDTCRED()

Local _Retorno := .T.   

// Valida usuarios que podem acessar a rotina
if __CUSERID $ getmv("MV_XCRDANA")

			// Posicao Anterior
			a_cLimite	:= SA1->A1_LC
			a_dVencLC	:= SA1->A1_VENCLC
			a_cRisco 	:= SA1->A1_RISCO
			a_cBloq 	:= SA1->A1_MSBLQL    
			a_cCondP	:= SA1->A1_COND
			a_cCnab		:= SA1->A1_XCNAB
			a_cEmail  	:= SA1->A1_EMAIL


			cLimite	:= SA1->A1_LC
			dVencLC	:= SA1->A1_VENCLC
			cRisco 	:= SA1->A1_RISCO
			cBloq 	:= SA1->A1_MSBLQL    
			cCondP	:= SA1->A1_COND
			cCnab	:= SA1->A1_XCNAB
			cEmail  := SA1->A1_EMAIL
			
			aBloq	:= {'1=Sim','2=Nao'} 
			aRisco	:= {'A','B','C','D','E'}
			aCnab	:= {'S=Sim','N=Nao'} 			

//	      @ 000,000 TO 200,500 DIALOG oDlgDI TITLE "Análise de Crédito - ["+AllTrim(SA1->A1_COD)+"-"+AllTrim(SA1->A1_LOJA)+ "  "+AllTrim(SA1->A1_NREDUZ)+"]"
	      @ 000,000 TO 230,500 DIALOG oDlgDI TITLE "Análise de Crédito - ["+AllTrim(SA1->A1_COD)+"-"+AllTrim(SA1->A1_LOJA)+ "  "+AllTrim(SA1->A1_NREDUZ)+"]"
	      
	      @ 015, 005 SAY "Limite de Crédito:"
	      @ 015, 060 GET cLimite PICTURE "@E 999,999,999.99" SIZE 080,010
  
	      @ 015, 160 SAY "Risco:"
	      @ 015, 195 COMBOBOX oCombo1 VAR cRisco ITEMS aRISCO SIZE 20,10  VALID .T. PIXEL
	      		      
	      @ 030, 005 SAY "Vencimento Limite:"
	      @ 030, 060 GET dVencLC PICTURE "@!" SIZE 50,10
 
	      @ 030, 160 SAY "Cond.Pag:"
	      @ 030, 195 GET cCondP PICTURE "@!" SIZE 20,10 F3 "SE4"
	      	
	      @ 045, 005 SAY "Bloqueado? " //(1=SIM  / 2=NAO)"
	      @ 045, 060 COMBOBOX oCombo2  VAR cBloq ITEMS aBloq  SIZE 40,10  VALID .T. PIXEL 

	      @ 045, 160 SAY "Gera Cnab? " //(S=SIM  / N=NAO)"
	      @ 045, 195 COMBOBOX oCombo2  VAR cCnab ITEMS aCnab  SIZE 40,10  VALID .T. PIXEL 

     	  @ 060, 005 SAY "Email NFE:"
	      @ 060, 060 GET cEmail PICTURE "@!" SIZE 170,10 //F3 "SE4"


	      @ 090,085 BUTTON "Confirmar" SIZE 040,015 ACTION _Gravar()
	      @ 090,140 BUTTON "Cancelar"  SIZE 040,015 ACTION _Sair()  
		ACTIVATE DIALOG oDlgDI CENTER

Else
	MsgAlert("MV_XCRDANA - Você não tem Acesso para executar esta Rotina. Solicite ao TI.")

Endif

Return _Retorno



Static Function _Gravar()

	if MsgYesNo("Confirma Gravação dos Dados ?")
		RecLock("SA1", .F.)
			SA1->A1_LC 		:= cLimite
			SA1->A1_VENCLC	:= dVencLC
			SA1->A1_RISCO	:= cRisco
			SA1->A1_MSBLQL	:= cBloq	 
			SA1->A1_COND	:= cCondP		

		   Close(oDlgDI)
		MsUnLock()

		//Verifica se teve alteração

			if cLimite	<> a_cLimite .or.;
				dVencLC	<> a_dVencLC .or.;
				cRisco 	<> a_cRisco .or.;
				cBloq 	<> a_cBloq  .or.;
				cCondP	<> a_cCondP .or.;
				cCnab	<> a_cCnab .or.;
				cEmail  <> a_cEmail


				cNomeCli := AllTrim(SA1->A1_NREDUZ)
				cAssunto := "Analise de Crédito - Alteração de Cadastro - " +  cNomeCli 
				cTexto 	 := "Alteração no Cliente: " + SA1->A1_COD+"/"+SA1->A1_LOJA+" - " +cNomeCli+ Chr(13)+ Chr(13)
				
				cTexto 	+= "Limite de Crédito: " + Alltrim(Transform(cLimite,"@E 999,999,999.99")) + Chr(13)
				cTexto 	+= "Risco: " + cRisco + Chr(13)
				cTexto 	+= "Vencimento do Limite: " + dtoc(dVencLC) + Chr(13)
				cTexto 	+= "Cond.Pagamento:  " + cCondP + Chr(13)  		
				cTexto 	+= "Gera CNAB: " + IIF(cCnab =="S","SIM","NAO") + Chr(13)
				cTexto 	+= "Email: " + Alltrim(cEmail) + Chr(13)
		
		
				cTexto   := StrTran(cTexto,Chr(13),"<br>")

	 			cPara    := "marco.aurelio@opusvp.com.br;"
				cCC      := ""
 				cArquivo := ""

				U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)

			ENDIF


	Endif
                                                                                                
Return


Static Function _Sair()

	Close(oDlgDI)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³XRISCOE1ºAutor  ³ Marco Aurelio-OPUS	 º Data ³  15/05/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao de validacao dos campos do cliente e loja.		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATX415                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XRISCOE1()

Local aArea := GetArea()
Local lRet	:= .T.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Preenche a condição de pagamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SA1")
dbSetOrder(1)
If ReadVar() == "M->CJ_CLIENTE"

	If !Empty(M->CJ_LOJA)
		If dbSeek(xFilial("SA1") + M->CJ_CLIENTE + M->CJ_LOJA,.T.)
			M->CJ_LOJA	  := SA1->A1_LOJA
		ElseIf dbSeek(xFilial("SA1") + M->CJ_CLIENTE,.T.)
	 		M->CJ_LOJA 	  := SA1->A1_LOJA
		EndIf
	ElseIf dbSeek(xFilial("SA1") + M->CJ_CLIENTE,.T.)
		M->CJ_LOJA	  := SA1->A1_LOJA
	EndIf
ElseIf ReadVar() == "M->CJ_LOJA"
	dbSeek(xFilial("SA1") + M->CJ_CLIENTE + M->CJ_LOJA,.T.)
	if SA1->A1_MSBLQL == "1"
		MsgAlert("Cliente Bloqueado. Consulte Depto Financeiro.")
		lRet	:= .F.
	endif
EndIf

RestArea(aArea)

Return(lRet)


