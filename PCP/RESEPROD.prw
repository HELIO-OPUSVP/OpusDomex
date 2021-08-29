#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RESEPROD  ºAutor  ³Helio Ferreira      º Data ³  20/01/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função de reserva de materiais (SZF)                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RESEPROD(cOP, cProduto, nQuant)
Local _Retorno
Local aAreaGER  := GetArea()
Local aAreaSB2  := SB2->( GetArea() )
Local nSaldoSB2 := 0
Local nSaldoSZF := 0

cOP := Subs(cOP,1,11)

SB2->( dbSetOrder(1) )
SZF->( dbSetOrder(1) )

If SB2->( dbSeek( xFilial() + cProduto ) )
	While !SB2->( EOF() ) .and. SB2->B2_COD == cProduto
	   If SB2->B2_LOCAL <> GetMV("MV_CQ")
		   nSaldoSB2 += SB2->B2_QATU
		EndIf
		SB2->( dbSkip() )
	End
EndIf

If SZF->( dbSeek( xFilial() + cProduto ) )
	While !SZF->( EOF() ) .and. SZF->ZF_PRODUTO == cProduto
		If SZF->ZF_OP <> cOP
			nSaldoSZF += SZF->ZF_QUANT
		EndIf
		SZF->( dbSkip() )
	End
EndIf

If SZF->( dbSeek( xFilial() + cProduto + cOP ) )
	If nQuant <> SZF->ZF_QUANT
		If nSaldoSB2 >= (nSaldoSZF + nQuant)
			Reclock("SZF",.F.)
			SZF->ZF_QUANT   := nQuant
			SZF->( MsUnlock() )
			_Retorno := .T.
		Else
			_Retorno := .F.
			// Envia e-mail de erro
		EndIf
	EndIf
Else
	If nSaldoSB2 >= (nSaldoSZF + nQuant)
		Reclock("SZF",.T.)
		SZF->ZF_FILIAL  := xFilial("SZF")
		SZF->ZF_OP      := cOP
		SZF->ZF_PRODUTO := cProduto
		SZF->ZF_QUANT   := nQuant
		SZF->( MsUnlock() )
		_Retorno := .T.
	Else
		_Retorno := .F.
	EndIf
EndIf

RestArea(aAreaGER)

Return _Retorno
