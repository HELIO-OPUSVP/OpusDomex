#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VZA_OP     ºAutor  ³Helio Ferreira     º Data ³  05/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação do campo ZA_OP - Apontamento de perdas           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VZA_OP()
Local _Retorno := .T.

SC2->( dbSetOrder(1) )
If SC2->( dbSeek( xFilial() + M->ZA_OP ) )
   If SC2->C2_QUANT > SC2->C2_QUJE
      If Empty(SC2->C2_DATRF)
         M->ZA_PRODUTO := Space(len(M->ZA_PRODUTO))
         M->ZA_DESC    := Space(len(M->ZA_DESC))
         M->ZA_MOTIVO  := Space(len(M->ZA_MOTIVO))
         M->ZA_DESCPER := Space(len(M->ZA_DESCPER))
         M->ZA_SALDO   := 0
         M->ZA_QTDORI  := 0
      Else
         MsgStop("Ordem de Produção encerrada em " + DtoC(SC2->C2_DATRF) + ".")
         _Retorno := .F.
      EndIf
   Else
      MsgStop("Ordem de Produção encerrada." + Chr(10) + "Só é possível apontar perdas para Ordens de Produção que não foram totalmente produzidas.")
      _Retorno := .F.
   EndIf
Else
   MsgStop("Ordem de Produção inválida.")
   _Retorno := .F.
EndIf

Return _Retorno
