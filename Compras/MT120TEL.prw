#include "rwmake.ch"
#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT120TEL  ºAutor  ³Marcos Rezende      º Data ³  09/24/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria o Campo de tipo de pedido no cabeçalho de PC          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT120TEL()
Local oNewDialog 	:= PARAMIXB[1]
Local aPosGet 		:= PARAMIXB[2]
Local aObj 			:= PARAMIXB[3]                             

Local nOpcx 		:= PARAMIXB[4]   

Public _cTPPC 		:= Space(02)
Public _DOMOpcx 	:= nOpcx    //mantem esta variavel para ser utilizada na validação de linha
_cTPPC := IIf(nOpcX == 4 .OR. nOpcX == 2, sc7->C7_XTPPC, Space(2))

//@ 044,aPosGet[1,6] SAY "Tipo do Pedido: " OF oNewDialog PIXEL SIZE 060,006
//@ 043,aPosGet[1,7] MSGET _cTPPC PICTURE PesqPict("SC7","C7_XTPPC") F3 CpoRetF3('C7_XTPPC','XTPPC') OF oNewDialog PIXEL SIZE 040,003
 
@ 055,aPosGet[1,6] SAY "Tipo do Pedido: " OF oNewDialog PIXEL SIZE 060,006
@ 048,aPosGet[1,7] MSGET _cTPPC PICTURE PesqPict("SC7","C7_XTPPC") F3 CpoRetF3('C7_XTPPC','XTPPC') OF oNewDialog PIXEL SIZE 040,003

Return(.T.)

