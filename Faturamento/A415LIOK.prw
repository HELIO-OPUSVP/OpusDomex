
#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A415LIOK   ºAutor  ³ Osmar Ferreira  º Data ³  16/06/2020   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Valida linha do cadastro de orçamentos  (SCJ / SCK)       º±±
±±º          ³  Retorna variável tipo lógica                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A415LIOK
	Local aAreaSCK := SCK->( GetArea() )
	Local aAreaSCL := SCL->( GetArea() )
	Local aAreaSA1 := SA1->( GetArea() )
	Local lRetorno := .t.
	Local nMargem  := GetMV("MV_XMARGEM") //Percentual mínimo aceito como margem de lucro

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
			MsgInfo("A Margem de Contribuição deste item esta em "+Alltrim(Str(TMP1->CK_XMARGEM))+"%"+Chr(13)+"e esta abaixo de "+Alltrim(Str(nMargem))+"% ","A T E N Ç Ã O")
			lRetorno := .T.
		EndIf
	EndIf

	RestArea(aAreaSA1)
	RestArea(aAreaSCL)
	RestArea(aAreaSCK)
Return(lRetorno)
