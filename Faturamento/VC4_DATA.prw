#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VC4_DATA  ºAutor  ³Helio Ferreira      º Data ³  07/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação do campo C4_DATA - Data de Previsão de Vendas    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VC4_DATA()
Local _Retorno := .T.
dDataAtu := Date()

If Date() >= StoD("20170715")
   If Day(Date()) <= 10
      cDataLim := LastDay(Date())+1
   Else
      cDataLim := LastDay(LastDay(Date())+1)+1
   EndIf
Else
   cDataLim := Date() + 20
EndIf

If M->C4_DATA < cDataLim  //Date() + 20
   MsgStop("A data limite para a inclusão de Previsão de Vendas hoje dia " + DtoC(Date()) + " é " + DtoC(cDataLim) +".")
   _Retorno := .F.
EndIf

Return _Retorno



User Function VC4_DAT2()
Local _Retorno := DATE()
dDataAtu := Date()

If Day(Date()) <= 10
      cDataLim := LastDay(Date())+1
Else
      cDataLim := LastDay(LastDay(Date())+1)+1
EndIf

_Retorno:=cDataLim

Return _Retorno
