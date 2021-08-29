#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT381LOK  ºAutor  ³Helio Ferreira       º Data ³  12/16/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT381LOK()
Local _Retorno := .T.
Local nPD4_COD     := aScan(aHeader, { |aVet| Alltrim(aVet[2]) == "D4_COD" } )
Local nPD4_QTDEORI := aScan(aHeader, { |aVet| Alltrim(aVet[2]) == "D4_QTDEORI"} )

If ALTERA
	If aCols[N,Len(aHeader)+1]
		If !Empty(aCols[n,nPD4_COD])
//			lPgto := U_VerPgtoOp(SD4->D4_OP,aCols[n,nPD4_COD])		// Pegava o número de Op desposicionada
			lPgto := U_VerPgtoOp(cOP       ,aCols[n,nPD4_COD])    // Inserido por Michel Sander em 08.01.2015 para buscar a variável de memória padrão com o número da OP 
			If !lPgto
				Aviso("Atenção","Este empenho não pode ser excluído pois já existe pagamento deste Produto do estoque para esta OP.",{"OK"} )
				_Retorno := .F.
			EndIf
		EndIf
	EndIf
EndIf

If ALTERA
	If aCols[n,nPD4_QTDEORI] == 0 
	    Aviso("Atenção","A quantidade empenhada original não pode ser zerada.",{"OK"} )
		_Retorno := .F.
	EndIf	
EndIf

Return _Retorno

