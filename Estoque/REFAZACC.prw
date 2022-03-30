#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³REFAZACC  ºAutor  ³Helio Ferreira      º Data ³  12/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Criado inicialmente para acertar o B2_QACLASS a partir do  º±±
±±º          ³ DA_SALDO                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function REFAZACC()

If MsgYesNo("Deseja refazer o campo B2_QACLASS a partir do DA_SALDO?")
	Processa( {|| RunProc() } )
EndIf

MsgInfo("Fim da correção do B2_QACLASS")

Return

Static Function RunProc()

ProcRegua(SB2->( RecCount() ))

SB2->( dbGotop() )
While !SB2->( EOF() )
	// Corrigindo o B2_QACLASS
	cQuery := "SELECT SUM(DA_SALDO) AS DA_SALDO FROM "+RetSqlName("SDA")+" (NOLOCK) WHERE DA_FILIAL = '"+SB2->B2_FILIAL+"' AND DA_PRODUTO = '"+SB2->B2_COD+"' AND DA_LOCAL = '"+SB2->B2_LOCAL+"' AND D_E_L_E_T_ = '' "
	
	If Select("QUERYSDA") <> 0
		QUERYSDA->( dbCloseArea() )
	EndIf
	
	TCQUERY cQuery NEW ALIAS "QUERYSDA"
	
	If SB2->B2_QACLASS <> QUERYSDA->DA_SALDO
		Reclock("SB2",.F.)
		SB2->B2_QACLASS := QUERYSDA->DA_SALDO
		SB2->( msUnlock() )
	EndIf
	
	// Corrigindo o B2_QEMP
	cQuery := "SELECT SUM(D4_QUANT) AS D4_QUANT FROM "+RetSqlName("SD4")+" (NOLOCK) WHERE D4_FILIAL = '"+SB2->B2_FILIAL+"' AND D4_COD = '"+SB2->B2_COD+"' AND D4_LOCAL = '"+SB2->B2_LOCAL+"' AND D_E_L_E_T_ = '' "
	
	If Select("QUERYSD4") <> 0
		QUERYSD4->( dbCloseArea() )
	EndIf
	
	TCQUERY cQuery NEW ALIAS "QUERYSD4"
	
	If SB2->B2_QEMP <> QUERYSD4->D4_QUANT
		Reclock("SB2",.F.)
		SB2->B2_QEMP := QUERYSD4->DA_QUANT
		SB2->( msUnlock() )
	EndIf
	
	
	SB2->( dbSkip() )
	Incproc()
End

Return
