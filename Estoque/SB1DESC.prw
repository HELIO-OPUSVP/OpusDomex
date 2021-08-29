#include "rwmake.ch"
#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SB1DESC   ºAutor  ³Helio Ferreira      º Data ³  20/08/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gatilho do B1_COD                                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SB1DESC()
Local _Retorno := ""
Local aAreaGER := GetArea()
Local aAreaSBP := SBP->( GetArea() )
Local aAreaSBQ := SBQ->( GetArea() )
Local aAreaSBS := SBS->( GetArea() )
Local aVetTam  := {}
Local n, x     := 0

If !Empty(M->B1_BASE)
	cFamilia := M->B1_BASE
	SBP->( dbSetOrder(1) )
	If SBP->( dbSeek( xFilial() + cFamilia ) )
		SBQ->( dbSetOrder(2) )
		If SBQ->( dbSeek( xFilial() + cFamilia ) )
			n := Len(Alltrim(cFamilia))
			n++
			While !SBQ->( EOF() ) .and. SBQ->BQ_BASE == cFamilia .and. SBQ->BQ_FILIAL == xFilial("SBQ")
				AADD(aVetTam,{SBQ->BQ_ID,n,SBQ->BQ_TAMANHO})
				n   += SBQ->BQ_TAMANHO
				
				SBQ->( dbSkip() )
			End
		EndIf
	Else
		MsgStop("Família não encontrada no SBP")
	EndIf
	
	SBS->( dbSetOrder(1) )
	SBR->( dbSetOrder(1) )
	If SBR->( dbSeek( xFilial() + cFamilia ) )
		_Retorno := Alltrim(SBR->BR_DESCPRD)
		If !Empty(_Retorno)
			_Retorno += " "
		EndIf
	EndIf
	
	For x := 1 to Len(aVetTam)
		If SBS->( dbSeek( xFilial() + cFamilia + aVetTam[x,1] + Subs(Subs(M->B1_COD,aVetTam[x,2],aVetTam[x,3]) + Space(14),1,14) ) )
			_Retorno += Alltrim(SBS->BS_XDESC)+" "
		EndIf
	Next x
	
EndIf

RestArea(aAreaSBP)
RestArea(aAreaSBQ)
RestArea(aAreaSBS)
RestArea(aAreaGER)

Return _Retorno
