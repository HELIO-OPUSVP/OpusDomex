#include "rwmake.ch"
#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA410I  ºAutor  ³Michel Sander        º Data ³  02.06.2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada chamado na inclusão do pedido de venda    º±±
±±º          ³                                                            º±±
±±º          ³ durante a cópia de pedidos 									     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MTA410I()

Local aSaveArea   := GetArea()
Local x, cTesRet
Local nPC6XOPER   := aScan(aHeader,{ |aVet| Alltrim(aVet[2]) == "C6_XOPER"   })
Local nPC6TES     := aScan(aHeader,{ |aVet| Alltrim(aVet[2]) == "C6_TES"     })
Local nPC6PRODUTO := aScan(aHeader,{ |aVet| Alltrim(aVet[2]) == "C6_PRODUTO" })
Local nPC6ITEM    := aScan(aHeader,{ |aVet| Alltrim(aVet[2]) == "C6_ITEM"    })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inclui a previsão de faturamento na copia do PV     ³
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
SZY->( dbSetOrder(1) )
If !SZY->(dbSeek(xFilial("SZY")+M->C5_NUM))
   U_GRAVASZY()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Valida Tes Inteligente DOMEX³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

// TESTA SE OPERACAO E "99"
	lIgnora:=.F.
	For x := 1 to Len(aCols)
		If !aCols[x,Len(aHeader)+1]
			If empty(aCols[x,nPC6XOPER]) .or. aCols[x,nPC6XOPER] == "99"
				lIgnora := .T.
				Exit
			EndIf
		EndIf
	Next x

if !lIgnora

   If SC5->C5_XXLIBFI == '0'  // Não liberado pelo Fiscal
      lTudoOk := .T.
      For x := 1 to Len(aCols)
         If !aCols[x,Len(aHeader)+1]
            cTesRet := U_ReTesInt(aCols[x,nPC6XOPER],M->C5_CLIENTE,M->C5_LOJACLI,aCols[x,nPC6PRODUTO],M->C5_TIPOCLI)
            If cTesRet[1] <> aCols[x,nPC6TES] .or. cTesRet[1] == "999" .or. !cTesRet[2] .or. cTesRet[3] == SC5->C5_NUM
               lTudoOk := .F.
               Exit
            EndIf
         EndIf
      Next x
      If lTudoOk
         Reclock("SC5",.F.)
         SC5->C5_XXLIBFI := "2"
         SC5->( msUnlock() )
      EndIf
   EndIf


   If SC5->C5_XXLIBFI == '1'  // Liberado Manualmente
      For x := 1 to Len(aCols)
         If !aCols[x,Len(aHeader)+1]
            cTesRet := U_ReTesInt(aCols[x,nPC6XOPER],M->C5_CLIENTE,M->C5_LOJACLI,aCols[x,nPC6PRODUTO],M->C5_TIPOCLI)
            If cTesRet[1] == aCols[x,nPC6TES] .and. !cTesRet[2]
               ZFM->( dbSetOrder(1) )
               If ZFM->( dbSeek(xfilial("ZFM")+aCols[x,nPC6XOPER]+M->C5_CLIENTE+M->C5_LOJACLI+M->C5_TIPOCLI) )
                  
                  If cTesRet[5] == 1
                     Reclock("ZFM",.F.)
                     ZFM->ZFM_VALID1 := '1'
                     ZFM->ZFM_PV1    := SC5->C5_NUM
                     ZFM->ZFM_IT1    := aCols[x,nPC6ITEM]
                     ZFM->ZFM_ID1    := __cUserID
                     ZFM->ZFM_NOME1  := UsrRetName(__cUserID)
                     ZFM->ZFM_DT1	 := Date()
                     ZFM->( msUnlock() )
                  EndIf
                  
                  If cTesRet[5] == 2
                     Reclock("ZFM",.F.)
                     ZFM->ZFM_VALID2 := '1'
                     ZFM->ZFM_PV2    := SC5->C5_NUM
                     ZFM->ZFM_IT2    := aCols[x,nPC6ITEM]
                     ZFM->ZFM_ID2    := __cUserID
                     ZFM->ZFM_NOME2  := UsrRetName(__cUserID)
                     ZFM->ZFM_DT2  := Date()
                     ZFM->( msUnlock() )
                  EndIf

                  If cTesRet[5] == 3
                     Reclock("ZFM",.F.)
                     ZFM->ZFM_VALID3 := '1'
                     ZFM->ZFM_PV3    := SC5->C5_NUM
                     ZFM->ZFM_IT3    := aCols[x,nPC6ITEM]
                     ZFM->ZFM_ID3    := __cUserID
                     ZFM->ZFM_NOME3  := UsrRetName(__cUserID)
                     ZFM->ZFM_DT3  	 := Date()
                     ZFM->( msUnlock() )
                  EndIf
                  
                  If cTesRet[5] == 4
                     Reclock("ZFM",.F.)
                     ZFM->ZFM_VALID4 := '1'
                     ZFM->ZFM_PV4    := SC5->C5_NUM
                     ZFM->ZFM_IT4    := aCols[x,nPC6ITEM]
                     ZFM->ZFM_ID4    := __cUserID
                     ZFM->ZFM_NOME4  := UsrRetName(__cUserID)
                     ZFM->ZFM_DT4  	 := Date()
                     ZFM->( msUnlock() )
                  EndIf


                  If cTesRet[5] == 5
                     Reclock("ZFM",.F.)
                     ZFM->ZFM_VALID5 := '1'
                     ZFM->ZFM_PV5    := SC5->C5_NUM
                     ZFM->ZFM_IT5    := aCols[x,nPC6ITEM]
                     ZFM->ZFM_ID5    := __cUserID
                     ZFM->ZFM_NOME5  := UsrRetName(__cUserID)
                     ZFM->ZFM_DT5	 := Date()
                     ZFM->( msUnlock() )
                  EndIf
                  
               EndIf
            EndIf
         EndIf
      Next x	
   EndIf

   If SC5->C5_XXLIBFI == '2'  // Liberado Automaticamente
      lTudoOk := .T.
      For x := 1 to Len(aCols)
         If !aCols[x,Len(aHeader)+1]
            cTesRet := U_ReTesInt(aCols[x,nPC6XOPER],M->C5_CLIENTE,M->C5_LOJACLI,aCols[x,nPC6PRODUTO],M->C5_TIPOCLI)
            If cTesRet[1] <> aCols[x,nPC6TES] .or. cTesRet[1] == "999" .or. !cTesRet[2] .or. cTesRet[3] == SC5->C5_NUM
               lTudoOk := .F.
               Exit
            EndIf
         EndIf
      Next x
      If !lTudoOk
         Reclock("SC5",.F.)
         SC5->C5_XXLIBFI := "0"
         SC5->( msUnlock() )
      EndIf
   EndIf


Endif  // Fim do IGNORA - MARCO AURELIO

RestArea( aSaveArea )


Return ( .T. )