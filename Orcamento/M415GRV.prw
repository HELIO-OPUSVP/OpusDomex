#Include "rwMake.ch"
#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  M415GRV   ºAutor  ³Osmar Ferreira      º Data ³  02/07/20  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Ponto de entrada após a gravação do Orçamento             º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M415GRV()
	Local _nOper    := PARAMIXB[1]
	// Local cOperacao := ""
	// Local cQry      := ""
	// Local nMargem   := 0
	Local aAreaSCJ  := SCJ->(GetArea())
	Local aAreaSCK  := SCK->(GetArea())
	Local aAreaZZF  := ZZF->(GetArea())

	If _nOper == 1
		U_fCopia()
	EndIf


	If (_nOper == 1)  .Or. (_nOper == 2)    //Inclusão / Alteração

		If U_VldMrgOr(.F.,.T.)  //Margem dentro dos parametros. Liberar caso esteja bloqueado
			SCK->(dbSetOrder(01))
			SCK->(dbSeek(xFilial()+M->CJ_NUM))
			While SCK->CK_NUM == M->CJ_NUM .And. SCK->(!Eof())
				// RecLock("SCK",.F.)
				// SCK->CK_XBLQ := "L"
				// SCK->(msUnLock())
				SCK->(dbSkip())
			EndDo
		Else                    //Margem fora dos parametros. Bloquear caso não esteja liberado pela Adm Vendas
			SCK->(dbSetOrder(01))
			SCK->(dbSeek(xFilial()+M->CJ_NUM))
			If SCK->CK_XBLQ <> "A"  //Não esta aprovada pela ADM Vendas
				While SCK->CK_NUM == M->CJ_NUM .And. SCK->(!Eof())
					// RecLock("SCK",.F.)
					// SCK->CK_XBLQ := "B"
					// SCK->(msUnLock())
					SCK->(dbSkip())
				EndDo
			Else
				If SCK->CK_XBLQ == "A"  //Aprovado pela ADM Vendas
					//Verificar se não há itens novos
					lAprov := .t.

					SA1->(dbSetOrder(01))
					SA1->( dbSeek(xFilial()+M->CJ_CLIENTE+M->CJ_LOJA) )
					If SA1->A1_XMARGEM > 0
						nPerMargem := SA1->A1_XMARGEM
					Else
						nPerMargem := GetMV("MV_XMARGEM")
					Endif

					While SCK->(!Eof()) .And. SCJ->CJ_NUM == SCK->CK_NUM
						If ZZF->( dbSeek(xFilial()+"MGO"+SCK->CK_NUM+SCK->CK_ITEM))
							If SCK->CK_XMARGEM < ZZF->ZZF_MARGEM
								lAprov := .f.
							EndIf
						Else
							//Item novo ver a margem novamente
							If SCK->CK_XMARGEM < nPerMargem
								lAprov := .f.
							EndIf
						EndIf
						SCK->( dbSkip() )
					EndDo
					If !lAprov  //Bloquear tudo
						SCK->( dbSetOrder(1) )
						SCK->(dbSeek(xFilial()+SCJ->CJ_NUM))
						While SCK->(!Eof()) .And. SCJ->CJ_NUM == SCK->CK_NUM
							//RecLock("SCK",.f.)
							//SCK->CK_XBLQ := "B"
							//SCK->( msUnLock() )
							SCK->( dbSkip() )
						EndDo
					Else
						SCK->( dbSetOrder(1) )
						SCK->(dbSeek(xFilial()+SCJ->CJ_NUM))
						While SCK->(!Eof()) .And. SCK->CK_NUM == SCJ->CJ_NUM
							//RecLock("SCK",.f.)
							//SCK->CK_XBLQ := "A"
							//SCK->( msUnLock() )
							SCK->( dbSkip() )
						EndDo
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf

	RestArea(aAreaZZF)
	RestArea(aAreaSCK)
	RestArea(aAreaSCJ)

Return(Nil)


// Osmar Ferreira - 29/06/2022
// Função para atualizar o responsável no caso de cópia do Orçamento
// Ponto de entrada mt415cpy com problemas
User Function fCopia()
	If __cUserID <> SCJ->CJ_SUPORTE
		RecLock("SCJ",.F.)
			SCJ->CJ_SUPORTE := __cUserID
			SCJ->CJ_ELABORA := UsrRetName(__cUserID)
		SCJ->(msUnlock())
	EndIf
Return
