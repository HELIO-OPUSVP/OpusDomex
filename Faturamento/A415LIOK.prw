
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
    Local aAreaSCK := GetArea()
    Local aAreaSCL := GetArea()
    Local lRetorno := .t.
    Local nMargem  := GetMV("MV_XMARGEM")  //Percentual mínimo aceito como margem de lucro
    
    If lRetorno
        If TMP1->CK_XMARGEM > 0 .And. TMP1->CK_XMARGEM < nMargem
            MsgInfo("A Margem de Contribuição deste item esta em "+Alltrim(Str(TMP1->CK_XMARGEM))+"%"+Chr(13)+"e esta abaixo de "+Alltrim(Str(nMargem))+"% ","A T E N Ç Ã O")
            lRetorno := .T.
        EndIf
    EndIf

    RestArea(aAreaSCL)
    RestArea(aAreaSCK)
Return(lRetorno)
