#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GC6_ENTREG  ºAutor  ³Helio Ferreira    º Data ³  06/03/13   º±±  // Tratado
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gatilho criado para preencher o campo C6_XXDTDEF caso a dt º±±
±±º          ³ de entrega tenha sido firmada com o Cliente.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaFat                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GC6_ENTR()  // Tratado

Local _Retorno     := M->C6_ENTREG
Local nPC6_XXDTDEF := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_XXDTDEF" } )
Local nPC6_DTFATUR := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_DTFATUR" } )  // Tratado
Local nPC6_ENTREG  := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_ENTREG"  } )

/* eliminado a solicitacao do denis

Local _Retorno     := M->C6_ENTREG  // Tratado
Local nPC6_XXDTDEF := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_XXDTDEF" } )
Local nPC6_DTFATUR := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_DTFATUR" } )  // Tratado
Local nPC6_ENTREG  := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_ENTREG"  } )  // Tratado

If !GetMV("MV_XXINVDT")

Else
	If !Empty(aCols[n,nPC6_DTFATUR])  // Tratado
		If Empty(aCols[N,nPC6_XXDTDEF])
			If MsgYesNo('A data de Faturamento ' + DtoC(aCols[n,nPC6_DTFATUR]) + ' é a acordada com o Cliente?')  // Tratado
				aCols[n,nPC6_XXDTDEF] := aCols[n,nPC6_DTFATUR]  // Tratado
				apMsgInfo('Data de primeira negociação de Faturamento com o Cliente firmada em ' + DtoC(aCols[n,nPC6_XXDTDEF])+'.')
			EndIf
		EndIf
	Else
		apMsgStop('Antes de informar a data de Entrega, favor invormar a data de Faturamento.')
		_Retorno := CtoD('')
	EndIf
EndIf

*/

aCols[n,nPC6_XXDTDEF] := aCols[n,nPC6_DTFATUR] 

Return _Retorno
