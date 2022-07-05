#include "rwmake.ch"
#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GCJCLIENTEºAutor  ³Hélio Ferreira      º Data ³  06/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Adaptação para o Orçamento - Osmar Ferreira 04/07/2022
*/

User Function GCJCLIENTE()
Local x
Local nPC6XOPER   := aScan(aHeader,{ |aVet| Alltrim(aVet[2]) == "C6_XOPER"   })
Local nPC6TES     := aScan(aHeader,{ |aVet| Alltrim(aVet[2]) == "C6_TES"     })
Local nPC6PRODUTO := aScan(aHeader,{ |aVet| Alltrim(aVet[2]) == "C6_PRODUTO" })
Local nPC6CF      := aScan(aHeader,{ |aVet| Alltrim(aVet[2]) == "C6_CF"      })
Local _cUF 		  := Posicione("SA1", 1, xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI, "A1_EST")
Local _lContrib	:= .T.

_lContrib := iif(Alltrim(Posicione("SA1", 1, xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI, "A1_CONTRIB"))<>"2",.T.,.F.)


If !Empty(M->C5_CLIENTE) .AND. !Empty(M->C5_LOJACLI)
	For x := 1 to Len(aCols)
		aCols[x,nPC6TES] := U_ReTesInt(aCols[x,nPC6XOPER],M->C5_CLIENTE,M->C5_LOJACLI,aCols[x,nPC6PRODUTO],M->C5_TIPOCLI)[1]
  
		_xxCF			 := POSICIONE("SF4",1,xFilial("SF4")+aCols[x,nPC6TES],"F4_CF")
		if _cUF <> "SP"
//			aCols[x,nPC6CF] := "6"+Substr(aCols[x,nPC6CF],2,3)
			aCols[x,nPC6CF] := "6"+Substr(_xxCF,2,3)			
      endif

		if !(_lContrib) .and. aCols[x,nPC6TES] $ "522"
			aCols[x,nPC6CF] := Substr(aCols[x,nPC6CF],1,1)+"108"
		ENDIF



	Next x

	// Carrega Mensagens da TES
	M->C5_XMSGTES	:= ""
	For x := 1 to Len(aCols)
	  	_cMsg := U_ReMsgInt(aCols[x,nPC6XOPER],M->C5_CLIENTE,M->C5_LOJACLI,aCols[x,nPC6PRODUTO],M->C5_TIPOCLI)
	  	if !(_cMsg $ M->C5_XMSGTES)
		  	M->C5_XMSGTES	+=_cMsg
	  	endif
	Next x
	

EndIf

// Atualiza Acols do PV
GETDREFRESH()
SetFocus(oGetDad:obrowse:hWnd)
oGetDad:Refresh()
//A410LinOK(oGetDad)

Return M->C5_CLIENTE



User Function GCJLOJACLI()
Local x
Local nPC6XOPER   := aScan(aHeader,{ |aVet| Alltrim(aVet[2]) == "C6_XOPER"   })
Local nPC6TES     := aScan(aHeader,{ |aVet| Alltrim(aVet[2]) == "C6_TES"     })
Local nPC6PRODUTO := aScan(aHeader,{ |aVet| Alltrim(aVet[2]) == "C6_PRODUTO" })
Local nPC6CF      := aScan(aHeader,{ |aVet| Alltrim(aVet[2]) == "C6_CF"      })
Local _cUF 			:= Posicione("SA1", 1, xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI, "A1_EST")
Local _lContrib	:= .T.

_lContrib := iif(Alltrim(Posicione("SA1", 1, xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI, "A1_CONTRIB"))<>"2",.T.,.F.)


If !Empty(M->C5_CLIENTE) .AND. !Empty(M->C5_LOJACLI)
	For x := 1 to Len(aCols)
		aCols[x,nPC6TES] := U_ReTesInt(aCols[x,nPC6XOPER],M->C5_CLIENTE,M->C5_LOJACLI,aCols[x,nPC6PRODUTO],M->C5_TIPOCLI)[1]

		_xxCF			 := POSICIONE("SF4",1,xFilial("SF4")+aCols[x,nPC6TES],"F4_CF")
		if _cUF <> "SP"
//			aCols[x,nPC6CF] := "6"+Substr(aCols[x,nPC6CF],2,3)
			aCols[x,nPC6CF] := "6"+Substr(_xxCF,2,3)			
		ELSE
			aCols[x,nPC6CF] := _xxCF   // MAURESI 18/05/2020
        endif

		if !(_lContrib) .and. aCols[x,nPC6TES] $ "522"
			aCols[x,nPC6CF] := Substr(aCols[x,nPC6CF],1,1)+"108"
		ENDIF

	Next x
EndIf

// Atualiza Acols do PV
GETDREFRESH()
SetFocus(oGetDad:obrowse:hWnd)
oGetDad:Refresh()
//A410LinOK(oGetDad)

Return M->C5_LOJACLI



User Function GCJTIPOCLI()
Local x
Local nPC6XOPER   := aScan(aHeader,{ |aVet| Alltrim(aVet[2]) == "C6_XOPER"   })
Local nPC6TES     := aScan(aHeader,{ |aVet| Alltrim(aVet[2]) == "C6_TES"     })
Local nPC6PRODUTO := aScan(aHeader,{ |aVet| Alltrim(aVet[2]) == "C6_PRODUTO" })
Local nPC6CF      := aScan(aHeader,{ |aVet| Alltrim(aVet[2]) == "C6_CF"      })
Local _cUF 			:= Posicione("SA1", 1, xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI, "A1_EST")
Local _lContrib	:= .T.

_lContrib := iif(Alltrim(Posicione("SA1", 1, xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI, "A1_CONTRIB"))<>"2",.T.,.F.)


If !Empty(M->C5_CLIENTE) .AND. !Empty(M->C5_LOJACLI)
	For x := 1 to Len(aCols)
		aCols[x,nPC6TES] := U_ReTesInt(aCols[x,nPC6XOPER],M->C5_CLIENTE,M->C5_LOJACLI,aCols[x,nPC6PRODUTO],M->C5_TIPOCLI)[1]

		_xxCF			 := POSICIONE("SF4",1,xFilial("SF4")+aCols[x,nPC6TES],"F4_CF")
		if _cUF <> "SP"
			aCols[x,nPC6CF] := "6"+Substr(_xxCF,2,3)
		ELSE
			aCols[x,nPC6CF] := _xxCF   // MAURESI 18/05/2020
        endif

		if !(_lContrib) .and. aCols[x,nPC6TES] $ "522"
			aCols[x,nPC6CF] := Substr(aCols[x,nPC6CF],1,1)+"108"
		ENDIF

	Next x
EndIf

// Atualiza Acols do PV
GETDREFRESH()
SetFocus(oGetDad:obrowse:hWnd)
oGetDad:Refresh()
//A410LinOK(oGetDad)

Return M->C5_TIPOCLI
