#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VFIELDPV  ºAutor  ³Helio Ferreira      º Data ³  04/08/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VFIELDPV()
	Local _Retorno   := .T.
	Local npC6_NUMOP := aScan(aHeader,{ |aVet| Alltrim(aVet[2]) == "C6_NUMOP"})
	local cAdmin    :=''


	//	RETURN .T.

	cCMPValid := ReadVar()   // GATILHO - Retorna o nome do CAMPO disparador do gatilho / FIELD / VARIÁVEL RETORNA CAMPO / FUNÇÃO RETORNA CAMPO

// Administradores
	cAdmin := "000206 - DENIS"
//cAdmin += "000211 - HELIO OPUS"
	cAdmin += "000233 - MICHEL OPUS"
	cAdmin += "000373 - MARCO OPUS"
	cAdmin += "000000 - ADMINISTRADOR"

	If !Empty(&(cCMPValid))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
		//³Grupos de usuários                                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

		// Administradores
		cAdmin := "000206 - DENIS"
		cAdmin += "000211 - HELIO OPUS"
		cAdmin += "000233 - MICHEL OPUS"
		cAdmin += "000373 - MARCO OPUS"
		cAdmin += "000000 - ADMINISTRADOR"
		//cAdmin += "000293 - MAX"

		// PCP
		//	cGrupo1 := "000369 - LEANDRO"
		cGrupo1 := "000194 - VANESSA"
		cGrupo1 += "000165 - WELIGTHON"
		cGrupo1 += "000464 - NILDA"
		cGrupo1 += "000087 - DEBORA"    // mls incluido 18/07/2018 Sol. Denis
		cGrupo1 += "000931 - LIVIA RUFINO"    // Chamado 025036

		//	cGrupo1 += "000312 - KEROLINE"
		//	cGrupo1 += "000192 - rebecca.ungaro" // mls   06/01/2016 Rebecca cobrindo férias Vanessa
		//	cGrupo1 += "000211 - Helio Opus"
		//	cGrupo1 += "000373 - MARCO OPUS"

		// PCM
		cGrupo2 := "000343 - CAMILA MORENO"
		cGrupo2 += "000073 - PAULO CELESTINO"
	//	cGrupo2 := "000123 - PRISCILA SILVA"

		// Faturamento
		cGrupo3 := "000123 - PRISCILA SILVA"
		cGrupo3 += "000908 - DAYANA SERRA"		
		cGrupo3 += "000961 - LUDMILA CAROLINE"  //CHAMADO 025626			
		cGrupo3 += "000399 - BRUNA KAROLINE"
		cGrupo3 += "000283 - MAURICIO OPUS"
		cGrupo3 += "000171 - RENATA ANGELO"
		cGrupo3 += "000342 - CAMILA EUGENIO"
		cGrupo3 += "000431 - JULIANA GOMES"
		cGrupo3 += "000232 - LUCIANO ALGELIS"
		cGrupo3 += "000519 - LUCIANO SILVA"
		cGrupo3 += "000853 - MARIANE MORINI" // MLS CHAMADO 023357
		cGrupo3 += "000957 - ELISANGELA BATISTA" //  CHAMADO 025388

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
		//³Validando grupo de campos que somente o PCP pode preencher                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
		cCMPGrup1 := "M->C6_ENTRE3,"    // Data PCP
		cCMPGrup1 += "M->C6_XXSEPARA,"  // Lib. Separac.
		cCMPGrup1 += "M->C6_XXDTSEP,"   // Dt. Separa.
		cCMPGrup1 += "M->C6_XXQSEPA"    // Qtd. Separa

		//cCMPGrup1 += "M->C5_TRANSP"     // Transportadora

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
		//³Validando grupo de campos que somente o Faturamento pode preencher            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
		//	cCMPGrup2 := "M->C5_TIPOCLI,"  //Tipo cliente
		cCMPGrup2 := "M->C5_XXLIBFI,"  //Liberacao FISCAL4
		cCMPGrup2 += "M->C5_PESOL,  "  //Peso líquido
		cCMPGrup2 += "M->C5_PBRUTO, "  //Peso bruto
		cCMPGrup2 += "M->C5_ESPECI1,"  //Espécie
		cCMPGrup2 += "M->C5_VOLUME1,"  //Volume
		cCMPGrup2 += "M->C5_MENNOTA,"  //Mens p/ Nota
		cCMPGrup2 += "M->C5_MNOTA2, "  //Mens p/ Nota 2
		cCMPGrup2 += "M->C5_MENPAD, "  //Mens Padrão
		//cCMPGrup2 += "M->C5_ESP1, "  //Pedido do Cliente ===>. Chamado 

		cCMPGrup2 += "M->C6_TES,    "  //Tipo de saída
		cCMPGrup2 += "M->C6_QTDLIB, "  //Qtde liberada
		cCMPGrup2 += "M->C6_LOCAL,  "  //Almoxarifado
		cCMPGrup2 += "M->C6_NFORI,  "  //Nota Fiscal original
		cCMPGrup2 += "M->C6_CLASFIS,"  //Sit Tributária
		cCMPGrup2 += "M->C6_FCICOD, "  //Código FCI
		cCMPGrup2 += "M->C6_CF,     "  //CFOP

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
		//³Se for usuário PCP e não for um campo do PCP                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
		If !(__cUserID $ cAdmin)
			If __cUserID $ cGrupo1 .AND. !(cCMPValid $ cCMPGrup1)
				If cCMPValid <> 'M->C5_TRANSP' .OR. __cUserID <> '000165'
					MsgInfo("Usuário sem acesso a preencher este campo. [1]","Atenção")
					Return .F.
				EndIf
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
		//³Se não for usuário PCP/PCM e for um campo do PCP                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
		If !(__cUserID $ cAdmin)
			If !(__cUserID $ cGrupo1) .and. !(__cUserID $ cGrupo2) .AND. (cCMPValid $ cCMPGrup1)
				MsgInfo("Usuário sem acesso a preencher este campo.[2]","Atenção")
				Return .F.
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
		//³(ALTERAÇÃO) Se não for usuário Faturamento+Admin(cGrupo3) e for um campo do Faturamento (cCMPGrup2)³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
		If !(__cUserID $ cAdmin)
			If ALTERA .and. !(__cUserID $ cGrupo3+cAdmin) .and. (cCMPValid $ cCMPGrup2)
				MsgInfo("Usuário sem acesso a preencher este campo.[3]","Atenção")
				Return .F.
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
		//³Se não for usuário do FATURAMENTO e ser campo Nao Permitido para ele          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
		If !(__cUserID $ cAdmin)
			If (__cUserID $ cGrupo3) .and. (cCMPValid $ "M->C5_MOTREVI")
				MsgInfo("Usuário sem acesso a preencher este campo.[4]","Atenção")
				Return .F.
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
		//³Validação de Campos independente do usuário                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
		//³Validação do campo de Liberação Sim ou Não para separação                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
		If cCMPValid == "M->C6_XXSEPAR"  // Lib. Separac.
			If M->C5_FECHADO <> '1' .and. M->C6_XXSEPAR == 'S'
				MsgStop("O campo 'Fechado' do cabeçalho do Pedido está preenchido com 'Não'. Não será possível liberar o Pedido para separação.")
				Return .F.
			EndIf
		EndIf




	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
//³Validações independentes do usuário                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
//³                                 C6_LOCAL                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
	If cCMPValid == "M->C6_LOCAL"
		//Wederson - OpusVp - 19/11/2014 - Solicitado pelo Denis bloqueio do almoxarifado , quando beneficiamento.
		If AllTrim(M->C5_TIPO) == "B" .And. AllTrim(M->C6_LOCAL) $ '03/13'
			_Retorno := .T.
		Else
			If AllTrim(M->C5_TIPO) <> "B" .And. Alltrim(M->C6_LOCAL) <> '03'
				If M->C6_LOCAL == '11' .or. M->C6_LOCAL == '13'
					_Retorno := .T.
				Else
					If M->C6_LOCAL == '95' .and. M->C5_XPVTIPO <> "RT"
						MsgStop("É permitido faturar a partir do almoxarifado " + M->C6_LOCAL + " somente Pedidos de Transferência entre Filiais.")
						Return .F.
					Else
						If M->C6_LOCAL == '95' .and. M->C5_XPVTIPO == "RT"
							_Retorno := .T.
						Else
							MsgStop("Não é permitido faturar a partir do almoxarifado " + M->C6_LOCAL + ".")
							Return .F.
						EndIf
					EndIf
				EndIf
			Else
				MsgInfo("Somente operação do tipo 'Beneficiamento'"+Chr(13)+"poderá movimentar este almoxarifado "+M->C6_LOCAL+".","A T E N Ç Ã O")
			EndIf
		EndIf
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
//³                                 C6_LOCALIZ                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

	If cCMPValid == "M->C6_LOCALIZ"
		//		If !(__cUserID $ cAdmin)
		If !(__cUserID $ cGrupo3+cAdmin) //MLS
			MsgStop("Este campo não pode ser alterado.")
			Return .F.
		EndIf
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
//³                                 C6_LOTECTL                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
	If cCMPValid == "M->C6_LOTECTL"
		If !(__cUserID $ cAdmin)
			MsgStop("Este campo não pode ser alterado.")
			Return .F.
		EndIf
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
//³                                 C6_PRODUTO                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
	If cCMPValid == "M->C6_PRODUTO"
		If !Empty(aCols[N,npC6_NUMOP])
			MsgStop("Não é permitido alterar o produto para itens com Ordem de Produção gerada.")
			Return .F.
		EndIf
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
//³                                 C6_QTDVEN                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
	If cCMPValid == "M->C6_QTDVEN"
		If !Empty(aCols[N,npC6_NUMOP])
			MsgStop("Não é permitido alterar a quantidade para itens com Ordem de Produção gerada.")
			Return .F.
		Else
			SZY->( dbSetOrder(1) )
			If SZY->(dbSeek(xFilial()+M->C5_NUM+aCols[N,1]))
			   //Mensagem retirada a pedido da Dayse - Osmar 04/05/21 - Chamado 023875
			   //MsgInfo("Já existe Previsão de Faturamento para este item. Favor corrigir sua quantidade antes da confirmação do Pedido.","Atenção")
			EndIf
		EndIf
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
//³                                 C6_PRODUTO                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
	If cCMPValid == "M->C6_XTAGFOR"
		If !Empty(aCols[N,npC6_NUMOP])
			MsgStop("Não é permitido alterar a TAG Fornecedor para itens com Ordem de Produção gerada.")
			Return .F.
		EndIf
	EndIf

Return _Retorno
