#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VFIELDPV  �Autor  �Helio Ferreira      � Data �  04/08/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function VFIELDPV()
	Local _Retorno   := .T.
	Local npC6_NUMOP := aScan(aHeader,{ |aVet| Alltrim(aVet[2]) == "C6_NUMOP"})
	local cAdmin    :=''


	//	RETURN .T.

	cCMPValid := ReadVar()   // GATILHO - Retorna o nome do CAMPO disparador do gatilho / FIELD / VARI�VEL RETORNA CAMPO / FUN��O RETORNA CAMPO

// Administradores
	cAdmin := "000206 - DENIS"
//cAdmin += "000211 - HELIO OPUS"
	cAdmin += "000233 - MICHEL OPUS"
	cAdmin += "000373 - MARCO OPUS"
	cAdmin += "000000 - ADMINISTRADOR"

	If !Empty(&(cCMPValid))

		//�������������������������������������������������������������������������������}
		//�Grupos de usu�rios                                                            �
		//�������������������������������������������������������������������������������}

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
		//	cGrupo1 += "000192 - rebecca.ungaro" // mls   06/01/2016 Rebecca cobrindo f�rias Vanessa
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

		//�������������������������������������������������������������������������������}
		//�Validando grupo de campos que somente o PCP pode preencher                    �
		//�������������������������������������������������������������������������������}
		cCMPGrup1 := "M->C6_ENTRE3,"    // Data PCP
		cCMPGrup1 += "M->C6_XXSEPARA,"  // Lib. Separac.
		cCMPGrup1 += "M->C6_XXDTSEP,"   // Dt. Separa.
		cCMPGrup1 += "M->C6_XXQSEPA"    // Qtd. Separa

		//cCMPGrup1 += "M->C5_TRANSP"     // Transportadora

		//�������������������������������������������������������������������������������}
		//�Validando grupo de campos que somente o Faturamento pode preencher            �
		//�������������������������������������������������������������������������������}
		//	cCMPGrup2 := "M->C5_TIPOCLI,"  //Tipo cliente
		cCMPGrup2 := "M->C5_XXLIBFI,"  //Liberacao FISCAL4
		cCMPGrup2 += "M->C5_PESOL,  "  //Peso l�quido
		cCMPGrup2 += "M->C5_PBRUTO, "  //Peso bruto
		cCMPGrup2 += "M->C5_ESPECI1,"  //Esp�cie
		cCMPGrup2 += "M->C5_VOLUME1,"  //Volume
		cCMPGrup2 += "M->C5_MENNOTA,"  //Mens p/ Nota
		cCMPGrup2 += "M->C5_MNOTA2, "  //Mens p/ Nota 2
		cCMPGrup2 += "M->C5_MENPAD, "  //Mens Padr�o
		//cCMPGrup2 += "M->C5_ESP1, "  //Pedido do Cliente ===>. Chamado 

		cCMPGrup2 += "M->C6_TES,    "  //Tipo de sa�da
		cCMPGrup2 += "M->C6_QTDLIB, "  //Qtde liberada
		cCMPGrup2 += "M->C6_LOCAL,  "  //Almoxarifado
		cCMPGrup2 += "M->C6_NFORI,  "  //Nota Fiscal original
		cCMPGrup2 += "M->C6_CLASFIS,"  //Sit Tribut�ria
		cCMPGrup2 += "M->C6_FCICOD, "  //C�digo FCI
		cCMPGrup2 += "M->C6_CF,     "  //CFOP

		//�������������������������������������������������������������������������������}
		//�Se for usu�rio PCP e n�o for um campo do PCP                                  �
		//�������������������������������������������������������������������������������}
		If !(__cUserID $ cAdmin)
			If __cUserID $ cGrupo1 .AND. !(cCMPValid $ cCMPGrup1)
				If cCMPValid <> 'M->C5_TRANSP' .OR. __cUserID <> '000165'
					MsgInfo("Usu�rio sem acesso a preencher este campo. [1]","Aten��o")
					Return .F.
				EndIf
			EndIf
		EndIf

		//�������������������������������������������������������������������������������}
		//�Se n�o for usu�rio PCP/PCM e for um campo do PCP                              �
		//�������������������������������������������������������������������������������}
		If !(__cUserID $ cAdmin)
			If !(__cUserID $ cGrupo1) .and. !(__cUserID $ cGrupo2) .AND. (cCMPValid $ cCMPGrup1)
				MsgInfo("Usu�rio sem acesso a preencher este campo.[2]","Aten��o")
				Return .F.
			EndIf
		EndIf

		//����������������������������������������������������������������������������������������������}
		//�(ALTERA��O) Se n�o for usu�rio Faturamento+Admin(cGrupo3) e for um campo do Faturamento (cCMPGrup2)�
		//����������������������������������������������������������������������������������������������}
		If !(__cUserID $ cAdmin)
			If ALTERA .and. !(__cUserID $ cGrupo3+cAdmin) .and. (cCMPValid $ cCMPGrup2)
				MsgInfo("Usu�rio sem acesso a preencher este campo.[3]","Aten��o")
				Return .F.
			EndIf
		EndIf

		//�������������������������������������������������������������������������������}
		//�Se n�o for usu�rio do FATURAMENTO e ser campo Nao Permitido para ele          �
		//�������������������������������������������������������������������������������}
		If !(__cUserID $ cAdmin)
			If (__cUserID $ cGrupo3) .and. (cCMPValid $ "M->C5_MOTREVI")
				MsgInfo("Usu�rio sem acesso a preencher este campo.[4]","Aten��o")
				Return .F.
			EndIf
		EndIf

		//�������������������������������������������������������������������������������}
		//�Valida��o de Campos independente do usu�rio                                   �
		//�������������������������������������������������������������������������������}

		//�������������������������������������������������������������������������������}
		//�Valida��o do campo de Libera��o Sim ou N�o para separa��o                     �
		//�������������������������������������������������������������������������������}
		If cCMPValid == "M->C6_XXSEPAR"  // Lib. Separac.
			If M->C5_FECHADO <> '1' .and. M->C6_XXSEPAR == 'S'
				MsgStop("O campo 'Fechado' do cabe�alho do Pedido est� preenchido com 'N�o'. N�o ser� poss�vel liberar o Pedido para separa��o.")
				Return .F.
			EndIf
		EndIf




	EndIf

//�������������������������������������������������������������������������������}
//�Valida��es independentes do usu�rio                                          �
//�������������������������������������������������������������������������������}

//�������������������������������������������������������������������������������}
//�                                 C6_LOCAL                                     �
//�������������������������������������������������������������������������������}
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
						MsgStop("� permitido faturar a partir do almoxarifado " + M->C6_LOCAL + " somente Pedidos de Transfer�ncia entre Filiais.")
						Return .F.
					Else
						If M->C6_LOCAL == '95' .and. M->C5_XPVTIPO == "RT"
							_Retorno := .T.
						Else
							MsgStop("N�o � permitido faturar a partir do almoxarifado " + M->C6_LOCAL + ".")
							Return .F.
						EndIf
					EndIf
				EndIf
			Else
				MsgInfo("Somente opera��o do tipo 'Beneficiamento'"+Chr(13)+"poder� movimentar este almoxarifado "+M->C6_LOCAL+".","A T E N � � O")
			EndIf
		EndIf
	EndIf

//�������������������������������������������������������������������������������}
//�                                 C6_LOCALIZ                                  �
//�������������������������������������������������������������������������������}

	If cCMPValid == "M->C6_LOCALIZ"
		//		If !(__cUserID $ cAdmin)
		If !(__cUserID $ cGrupo3+cAdmin) //MLS
			MsgStop("Este campo n�o pode ser alterado.")
			Return .F.
		EndIf
	EndIf

//�������������������������������������������������������������������������������}
//�                                 C6_LOTECTL                                  �
//�������������������������������������������������������������������������������}
	If cCMPValid == "M->C6_LOTECTL"
		If !(__cUserID $ cAdmin)
			MsgStop("Este campo n�o pode ser alterado.")
			Return .F.
		EndIf
	EndIf

//�������������������������������������������������������������������������������}
//�                                 C6_PRODUTO                                  �
//�������������������������������������������������������������������������������}
	If cCMPValid == "M->C6_PRODUTO"
		If !Empty(aCols[N,npC6_NUMOP])
			MsgStop("N�o � permitido alterar o produto para itens com Ordem de Produ��o gerada.")
			Return .F.
		EndIf
	EndIf

//�������������������������������������������������������������������������������}
//�                                 C6_QTDVEN                                   �
//�������������������������������������������������������������������������������}
	If cCMPValid == "M->C6_QTDVEN"
		If !Empty(aCols[N,npC6_NUMOP])
			MsgStop("N�o � permitido alterar a quantidade para itens com Ordem de Produ��o gerada.")
			Return .F.
		Else
			SZY->( dbSetOrder(1) )
			If SZY->(dbSeek(xFilial()+M->C5_NUM+aCols[N,1]))
			   //Mensagem retirada a pedido da Dayse - Osmar 04/05/21 - Chamado 023875
			   //MsgInfo("J� existe Previs�o de Faturamento para este item. Favor corrigir sua quantidade antes da confirma��o do Pedido.","Aten��o")
			EndIf
		EndIf
	EndIf

//�������������������������������������������������������������������������������}
//�                                 C6_PRODUTO                                  �
//�������������������������������������������������������������������������������}
	If cCMPValid == "M->C6_XTAGFOR"
		If !Empty(aCols[N,npC6_NUMOP])
			MsgStop("N�o � permitido alterar a TAG Fornecedor para itens com Ordem de Produ��o gerada.")
			Return .F.
		EndIf
	EndIf

Return _Retorno
