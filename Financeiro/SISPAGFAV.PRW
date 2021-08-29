
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     ºAutor  ³MARCOS REZENDE      º Data ³  12/16/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³GERA INFORMACOES DO FAVORECIDO PARA O SISPAG                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION SISPAGFAV
CFAV := ""

///VERSAO DO LAYOUT 080
///CASO BANCO 341 OU 409
//24-24 ZERO
//25-28 AGENCIA
//29-29 BRANCO
//30-35 ZEROS
//36-41 CONTA
//42-42 BRANCO
//43-43 DAC

///CASO BANCO DIFERENTE
//24-28 AGENCIA
//29-29 BRANCO
//30-41 CONTA
//42-42 BRANCO
//43-43 DAC
__cConta := left(alltrim(SA2->A2_NUMCON),len(alltrim(sa2->a2_numcon))-1)
__cDigito:= right(alltrim(sa2->a2_numcon),1)


IF SA2->A2_BANCO $ '341/409'
	CFAV := '0'
//	CFAV += TRANSFORM(VAL(SA2->A2_AGENCIA),"@e 9999")
	CFAV += STRZERO(VAL(SA2->A2_AGENCIA),4)
	CFAV += ' '
	CFAV += '000000'
//	CFAV += TRANSFORM(VAL(__cConta  ),"@e 999999")
	CFAV += STRZERO(VAL(__cConta  ),6)
	CFAV += ' '
	CFAV += __cDigito
ELSE
//	CFAV := TRANSFORM(VAL(SA2->A2_AGENCIA),"@e 99999")
	CFAV += STRZERO(VAL(SA2->A2_AGENCIA),5)
	CFAV += ' '
//	CFAV += TRANSFORM(VAL(__cConta),"@e 999999999999")
	CFAV += STRZERO(VAL(__cConta  ),12)
	CFAV += ' '
	CFAV += __cDigito
ENDIF                       



RETURN CFAV
