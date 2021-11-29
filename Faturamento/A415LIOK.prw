
#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A415LIOK   �Autor  � Osmar Ferreira  � Data �  16/06/2020   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Valida linha do cadastro de or�amentos  (SCJ / SCK)       ���
���          �  Retorna vari�vel tipo l�gica                              ���
�������������������������������������������������������������������������͹��
���Uso       � Domex                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/
User Function A415LIOK
	Local aAreaSCK := SCK->( GetArea() )
	Local aAreaSCL := SCL->( GetArea() )
	Local aAreaSA1 := SA1->( GetArea() )
	Local lRetorno := .t.
	Local nMargem  := GetMV("MV_XMARGEM") //Percentual m�nimo aceito como margem de lucro

	If U_Validacao("OSMAR")
		SA1->(dbSetOrder(01))
		SA1->( dbSeek(xFilial()+M->CJ_CLIENTE+M->CJ_LOJA) )

		If SA1->A1_XMARGEM > 0
			nPerMargem := SA1->A1_XMARGEM
		Else
			nPerMargem := GetMV("MV_XMARGEM")
		Endif

		If TMP1->CK_XMARGEM > 0 .And. TMP1->CK_PRCVEN = 0 .And. TMP1->CK_XCUSUNI
			TMP1->CK_PRCVEN := TMP1->CK_XCUSUNI * (1 + (TMP1->CK_XMARGEM / 100))
			//Alert(TMP1->CK_PRCVEN)
		EndIf
	EndIf

	If lRetorno
		If TMP1->CK_XMARGEM > 0 .And. TMP1->CK_XMARGEM < nMargem
			MsgInfo("A Margem de Contribui��o deste item esta em "+Alltrim(Str(TMP1->CK_XMARGEM))+"%"+Chr(13)+"e esta abaixo de "+Alltrim(Str(nMargem))+"% ","A T E N � � O")
			lRetorno := .T.
		EndIf
	EndIf

	RestArea(aAreaSA1)
	RestArea(aAreaSCL)
	RestArea(aAreaSCK)
Return(lRetorno)
