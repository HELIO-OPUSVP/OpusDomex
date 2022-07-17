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
Local aAreaTMP1 
Local cRet := M->CJ_CLIENTE

//Local x
//Local nPC6XOPER   := aScan(aHeader,{ |aVet| Alltrim(aVet[2]) == "C6_XOPER"   })
//Local nPC6TES     := aScan(aHeader,{ |aVet| Alltrim(aVet[2]) == "C6_TES"     })
//Local nPC6PRODUTO := aScan(aHeader,{ |aVet| Alltrim(aVet[2]) == "C6_PRODUTO" })
//Local nPC6CF      := aScan(aHeader,{ |aVet| Alltrim(aVet[2]) == "C6_CF"      })

	Local _cUF 		  := Posicione("SA1", 1, xFilial("SA1")+M->CJ_CLIENTE+M->CJ_LOJA, "A1_EST")
	Local _lContrib	:= .T.

	oGetDad:oBrowse:GoBottom()
	aAreaTMP1 := TMP1->( GetArea() )

	_lContrib := iif(Alltrim(Posicione("SA1", 1, xFilial("SA1")+M->CJ_CLIENTE+M->CJ_LOJA, "A1_CONTRIB"))<>"2",.T.,.F.)


	If !Empty(M->CJ_CLIENTE) .AND. !Empty(M->CJ_LOJA)
		TMP1->( dbGoTop() )
		While TMP1->( !Eof() )
			RecLock("TMP1",.F.)
			TMP1->CK_TES := U_ReTesInt(TMP1->CK_XOPER,M->CJ_CLIENTE,M->CJ_LOJA,TMP1->CK_PRODUTO,M->CJ_TIPOCLI)[1]

			_xxCF			 := POSICIONE("SF4",1,xFilial("SF4")+TMP1->CK_TES,"F4_CF")
			If _cUF <> "SP"
				TMP1->CK_CLASFIS := "6"+Substr(_xxCF,2,3)
			EndIf

			if !(_lContrib) .and. TMP1->CK_TES $ "522"
				TMP1->CK_CLASFIS := Substr(TMP1->CK_CLASFIS,1,1)+"108"
			ENDIF
			TMP1->( MsUnlock() )
			oGetDad:Refresh()  
			TMP1->( dbSkip() )

		EndDo
		oGetDad:ForceRefresh()

		// Carrega Mensagens da TES
		//M->C5_XMSGTES	:= ""
		//For x := 1 to Len(aCols)
		//  	_cMsg := U_ReMsgInt(aCols[x,nPC6XOPER],M->C5_CLIENTE,M->C5_LOJACLI,aCols[x,nPC6PRODUTO],M->C5_TIPOCLI)
		//  	if !(_cMsg $ M->C5_XMSGTES)
		//	  	M->C5_XMSGTES	+=_cMsg
		//  	endif
		//Next x

	EndIf

RestArea(aAreaTMP1)
oGetDad:oBrowse:GoTop()
Return(cRet)


User Function GCJLOJACLI()
Local aAreaTMP1 
Local cRet := M->CJ_LOJA
Local _cUF 			:= Posicione("SA1", 1, xFilial("SA1")+M->CJ_CLIENTE+M->CJ_LOJA, "A1_EST")
Local _lContrib	:= .T.

	oGetDad:oBrowse:GoBottom()
	aAreaTMP1 := TMP1->( GetArea() )


	_lContrib := iif(Alltrim(Posicione("SA1", 1, xFilial("SA1")+M->CJ_CLIENTE+M->CJ_LOJA, "A1_CONTRIB"))<>"2",.T.,.F.)


	If !Empty(M->CJ_CLIENTE) .AND. !Empty(M->CJ_LOJA)
		TMP1->( dbGoTop() )
		While TMP1->( !Eof() )
			RecLock("TMP1",.F.)
			TMP1->CK_TES := U_ReTesInt(TMP1->CK_XOPER,M->CJ_CLIENTE,M->CJ_LOJA,TMP1->CK_PRODUTO,M->CJ_TIPOCLI)[1]
			_xxCF		 := POSICIONE("SF4",1,xFilial("SF4")+TMP1->CK_TES,"F4_CF")
			If _cUF <> "SP"
				TMP1->CK_CLASFIS := "6"+Substr(_xxCF,2,3)
			Else
				TMP1->CK_CLASFIS := _xxCF   // MAURESI 18/05/2020
			EndIf

			If !(_lContrib) .and. TMP1->CK_TES $ "522"
				TMP1->CK_CLASFIS := Substr(TMP1->CK_CLASFIS,1,1)+"108"
			EndIf
			TMP1->( MsUnlock() )
			oGetDad:Refresh()  
			TMP1->( dbSkip() )
		EndDo
		oGetDad:ForceRefresh()
		
	EndIf

RestArea(aAreaTMP1)
oGetDad:oBrowse:GoTop()
Return(cRet)




User Function GCJTIPOCLI()
Local aAreaTMP1 
Local cRet := M->CJ_TIPOCLI
Local _cUF 			:= Posicione("SA1", 1, xFilial("SA1")+M->CJ_CLIENTE+M->CJ_LOJA, "A1_EST")
Local _lContrib	:= .T.

	oGetDad:oBrowse:GoBottom()

	aAreaTMP1 := TMP1->( GetArea() )

	_lContrib := iif(Alltrim(Posicione("SA1", 1, xFilial("SA1")+M->CJ_CLIENTE+M->CJ_LOJA, "A1_CONTRIB"))<>"2",.T.,.F.)

	If !Empty(M->CJ_CLIENTE) .AND. !Empty(M->CJ_LOJA)	
		DbSelectArea("TMP1")
		TMP1->( dbGoTop() )
		While TMP1->( !Eof() )
			RecLock("TMP1",.F.)
			
			TMP1->CK_TES := U_ReTesInt(TMP1->CK_XOPER,M->CJ_CLIENTE,M->CJ_LOJA,TMP1->CK_PRODUTO,M->CJ_TIPOCLI)[1]
			
			_xxCF			 := POSICIONE("SF4",1,xFilial("SF4")+TMP1->CK_TES,"F4_CF")
			If _cUF <> "SP"
				TMP1->CK_CLASFIS := "6"+Substr(_xxCF,2,3)
			Else
				TMP1->CK_CLASFIS := _xxCF   // MAURESI 18/05/2020
			EndIf

			If !(_lContrib) .and. TMP1->CK_TES $ "522"
				TMP1->CK_CLASFIS := Substr(TMP1->CK_CLASFIS,1,1)+"108"
			EndIf
			TMP1->( MsUnlock())
			oGetDad:Refresh()  
			TMP1->( dbSkip() )
			
		EndDo
		oGetDad:ForceRefresh()
	EndIf

RestArea(aAreaTMP1)
oGetDad:oBrowse:GoTop()
Return(cRet)
