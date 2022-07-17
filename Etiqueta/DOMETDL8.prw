#include "protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DOMETDL8 ºAutor  ³ Michel A. Sander   º Data ³ 05.07.2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cancelamento de Etiqueta Embalagem nível 1 Serial          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMETDL8(cNumEtq)

Local __lLoop    := .T.
Local __aPar     := {}
Local __aRet     := {}
Local __XD1      := XD1->( GetArea() )
Local __XD2      := XD2->( GetArea() )
Local __SC2      := SC2->( GetArea() )
Local __SB1		  := SB1->( GetArea() )

Private __nTamEtq := 21
Private __mvPar01 := Space(__nTamEtq)

Default cNumEtq := ""

aAdd(__aPar,{1,"Numero da Etiqueta",__mvPar01  ,"@!"      ,/*"NaoVazio()"*/                ,     ,,060 ,.T.})

While __lLoop           

	//Chama tela de perguntas
	If !Empty(Alltrim(cNumEtq))
			__mvPar01 := cNumEtq
   	   If !ValidaEtiq( __mvPar01,cNumEtq )
		      __lLoop := .T.
		      Loop
		   Else
		   	__lLoop := .F.
		   EndIf	
	Else
		If ParamBox(__aPar,"Cancelamento de Embalagem Nível 1",@__aRet)
			__mvPar01 := __aRet[1]
   	   If Empty(__mvPar01)
				MsgAlert("Favor preencher o número da etiqueta.")
				__lLoop := .T.
				Loop
   	   EndIf
		   If !ValidaEtiq( __mvPar01 )
		      __lLoop := .T.
		   EndIf
  		Else
   	   __lLoop := .F.
		EndIf
   EndIf
End

XD1->( RestArea( __XD1) )
XD2->( RestArea( __XD2) )
SC2->( RestArea( __SC2) )
SB1->( RestArea( __SB1) )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ValidaEtiq ºAutor³ Helio Ferreira     º Data ³    27/05/15 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação da etiqueta bipada                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValidaEtiq(cRecEtiq,cNumEtq)

XD1->( dbSetOrder(1) )
XD2->( dbSetOrder(1) )
SC2->( dbSetOrder(1) )
SB1->( dbSetOrder(1) )

If !Empty(cRecEtiq)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Prepara número da etiqueta bipada							³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If Len(AllTrim(cRecEtiq)) == 12 //EAN 13 s/ dígito verificador.
		
		cRecEtiq := "0"+cRecEtiq
		cRecEtiq := Subs(cRecEtiq,1,12)
		
		//o código da etiqueta já vem tratado.
      If !Empty(cNumEtq)
      	cRecEtiq := cNumEtq
      EndIf
		If XD1->( dbSeek( xFilial() + cRecEtiq ) ) 

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica nível														³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
         
         If XD1->XD1_NIVEMB <> "1"  .And. Empty(cNumEtq)
				While !MsgNoYes("Etiqueta nível "+AllTrim(XD1->XD1_NIVEMB)+" não permite cancelamento por essa rotina."+CHR(13)+"Deseja continuar?")
				End
            Return(.F.)
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica ocorrência												³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
         If XD1->XD1_OCORRE == "5"
				While !MsgNoYes("Etiqueta cancelada pelo usuário."+CHR(13)+CHR(13)+"Deseja continuar?")
				End
            Return(.F.)
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica ocorrência												³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If U_Validacao("JAKCSON",.F.,"30/06/2022","") // Por Jackson em Validação -  30/06/2022
				If XD1->XD1_OCORRE == "7" .Or. XD1->XD1_OCORRE == "4" .Or. XD1->XD1_OCORRE == "6" // Status que já passaram no roteiro.
						While !MsgNoYes("Etiqueta já passou pelo roteiro."+CHR(13)+CHR(13)+"Deseja continuar?")
						End
					Return(.F.)
				EndIf
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Procura o grupo e subclass do produto ordem de produção³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 			
 			
 			If !SB1->(dbSeek(xFilial("SB1")+XD1->XD1_COD))         			         	
				While !MsgNoYes("Produto não encontrado."+CHR(13)+CHR(13)+"Deseja continuar?")
				End
			   Return(.F.)		
			
			Else
				If Alltrim(SB1->B1_GRUPO) == "DROP" .And. Empty(cNumEtq)
					While !MsgNoYes("Estorno apenas pela rotina 'Canc.Emb.Niv.2/Kit/Drop'."+CHR(13)+CHR(13)+"Deseja continuar?")
					End
					Return (.F.)
				EndIf			
				If Alltrim(SB1->B1_SUBCLASS) == "KIT PIGT" .And. Empty(cNumEtq)
					While !MsgNoYes("Estorno apenas pela rotina 'Canc.Emb.Niv.2/Kit/Drop'."+CHR(13)+CHR(13)+"Deseja continuar?")
					End
					Return (.F.)
				EndIf						
			Endif
						
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Procura a ordem de produção									³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !SC2->(dbSeek(xFilial("SC2")+XD1->XD1_OP))
		
				While !MsgNoYes("OP não encontrada."+CHR(13)+CHR(13)+"Deseja continuar?")
				End
			   Return(.F.)
		
			Else	
	
				/*
				If (SC2->C2_QUANT - SC2->C2_QUJE) <= 0  // Trocado de C2_XXQUJE para C2_QUJE      por Hélio em 25/09/18
					While !MsgNoYes("Ordem de Produção já encerrada."+CHR(13)+CHR(13)+"Deseja continuar?")
					End
					Return (.F.)
				EndIf             
				*/
				//Limpar o Campo De Encerramento da OP para não dar erro no execauto
				If !Empty(Alltrim(SC2->C2_DATRF))
					RecLock("SC2",.F.)
						SC2->C2_DATRF := ''
					SC2->(MsUnlock())
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Posiciona na etiqueta filha									³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cEtqPai := XD1->(Recno())
				XD2->( dbSetOrder(2) )  // Etiqueta Filha + Etiqueta Pai
				If XD2->( dbSeek( xFilial() + AllTrim(cRecEtiq) ) )
					While !MsgNoYes("Etiqueta já pertence a próxima embalagem "+AllTrim(XD2->XD2_XXPECA)+CHR(13)+CHR(13)+"Deseja continuar?")
					End
               		Return(.F.)
				Else 
					If XD1->XD1_NIVEMB <> "1"  .And. !Empty(cNumEtq)
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Cancela etiqueta							               ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							XD1->(dbSetOrder(1))
							If XD1->(dbSeek(xFilial()+cRecEtiq))
								Reclock("XD1",.F.)
								XD1->XD1_OCORRE := "5"
								XD1->(MsUnlock())
							EndIf
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Estorna etiquetas das embalagens filhas no XD2			³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							XD2->(dbSetOrder(1))
							If XD2->(dbSeek(xFilial("XD2")+cRecEtiq))
								Do While XD2->(dbSeek(xFilial("XD2")+XD1->XD1_XXPECA))
									Reclock("XD2",.F.)
									XD2->(dbDelete())
									XD2->(MsUnlock())
								EndDo
							EndIf			
					Else					
						XD1->( dbGoto( cEtqPai ) )
						XD2->( dbSetOrder(1) )
						If XD2->( dbSeek( xFilial() + AllTrim(cRecEtiq) ) )
							If MsgNoYes("Cancelamento da etiqueta "+AllTrim(cRecEtiq)+CHR(13)+CHR(13)+"Deseja continuar?")
							   Reclock("XD2",.F.)
							   XD2->(dbDelete())
							   XD2->(MsUnlock())
							   Reclock("XD1",.F.)
							   XD1->XD1_OCORRE := "5"	// Cancela embalagem Nível 1    
							   XD1->(MsUnlock())
							   MsgAlert("Etiqueta cancelada.")
							   Return(.T.)
							EndIf
						Else
							While !MsgNoYes("Etiqueta não encontrada na primeira embalagem."+CHR(13)+CHR(13)+"Deseja continuar?")
							End
		               Return(.F.)
						EndIf
						
					Endif
				EndIf
			
			EndIf		

		Else

			While !MsgNoYes("Etiqueta não encontrada."+CHR(13)+CHR(13)+"Deseja continuar?")
			End
		   Return(.F.)
			
		EndIf
	
	Else
	
		While !MsgNoYes("Etiqueta inválida."+CHR(13)+CHR(13)+"Deseja continuar?")
		End
	   Return(.F.)
   
   EndIf

EndIf

Return( .T. )
