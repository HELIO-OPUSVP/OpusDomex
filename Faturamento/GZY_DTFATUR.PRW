#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GZY_DTFATUR ºAutor  ³Marco Aurelio     º Data ³  08/04/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±± 
±±ºProg.Ori  ³GC6_FATUR  ºAutor  ³Helio Ferreira    º Data ³  06/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gatilho criado para preencher o campo ZY_DTOTD  com a      º±±
±±º          ³ Data PCP, caso tenha sido preenchido a data de entrega     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaFat                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GZY_DTFATUR()  // Tratado

Local _Retorno     := M->ZY_DTFATUR  // Tratado
Local nPZY_DTOTD   := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "ZY_DTOTD" } )  		// Data OTD
Local nPZY_DTPCP   := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "ZY_DTPCP"  } )  	// Data PCP     
//Local nPZY_DTFATUR := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "ZY_DTFATUR" } )  	// Data de Entrega
//Local nPC6_ENTRE   := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_ENTREG"  } )  // Tratado   - Data Cliente      

If Empty(aCols[n,nPZY_DTOTD])
	aCols[n,nPZY_DTOTD] := aCols[n,nPZY_DTPCP]              // Data OTD recebe conteudo do campo Data PCP
EndIf


Return _Retorno
