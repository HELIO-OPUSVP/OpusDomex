#include "rwmake.ch"

#INCLUDE "TOPCONN.CH"
#INCLUDE "FIVEWIN.CH"
#INCLUDE "PROTHEUS.CH"
#Include "COLORS.CH"
#Include "FONT.CH"
#INCLUDE "MSOBJECT.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA700MNU ºAutor  ³Microsiga           º Data ³  08/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MTA700MNU()

//aAdd(aRotina,{OemToAnsi('Replicar Previsões')    , "U_REPPREV()" , 0 , 1, 0, nil} )
aAdd(aRotina,{OemToAnsi('Importar Planilha')             , "U_IMPPRVEN()" , 0 , 1, 0, nil} )    
aAdd(aRotina,{OemToAnsi('Zerar Previsao de Venda Domex') , "U_M700ZERA()" , 0 , 4, 0, nil} )

Return


*---------------------------------------------------------------------------------------------*
USER FUNCTION M700ZERA()
*---------------------------------------------------------------------------------------------*
Local aSaveArea	:= GetArea()
Local cTitulo := "Zerar previsao de Venda Domex"   
Local _cDESCRI :=''

Local oDataPRV 
Local oQTDPRV  
Local oOBSPRV 
Local oCLIEPRV 

Local aBotoes   :={}

Local dDATAPRV  :=date()
Local nQTDPRV   :=0
Local cOBSPRV   :=""
Local cCLIEPRV  :=""

PRIVATE oFontBRW3    

dDATAPRV  :=C4_DATA 
nQTDPRV   :=C4_QUANT
cOBSPRV   :=C4_OBS
cCLIEPRV  :=C4_XXNOMCLI

DEFINE FONT oFontBRW3 NAME "Arial" SIZE 0,-13 BOLD
DEFINE FONT oFnt2     NAME "Arial" Size 10,16 BOLD

_cDESCRI :=POSICIONE('SB1',1,xFILIAL('SB1')+C4_XCODPA,'B1_DESC')

Define MsDialog oDLG1Zerar Title cTitulo  Pixel From 0,0 To 420,650//550,950

@ 32,01 To 74,325 Of oDLG1Zerar Pixel
@ 39,  5  Say   ALLTRIM(SC4->C4_XXCOD)                      Size  200,09 Of oDLG1Zerar Pixel Font oFnt2 Color CLR_BLUE,CLR_WHITE
@ 56,  5  Say   alltrim(SC4->C4_XCODPA) + " - " +_cDESCRI   Size  300,09 Of oDLG1Zerar Pixel Font oFnt2 Color CLR_BLUE,CLR_WHITE

@ 080,010 SAY OemToAnsi("Data " )                     OF oDLG1Zerar PIXEL SIZE 250,010 FONT oFontBRW3 Color CLR_BLUE,CLR_WHITE
@ 080,045 MSGET oDataPRV  VAR dDATAPRV     WHEN(.F.)  OF oDLG1Zerar SIZE 055,005  PIXEL COLOR CLR_HBLUE FONT oFontBRW3

@ 080,185 SAY OemToAnsi("Qtde " )                     OF oDLG1Zerar PIXEL SIZE 250,010 FONT oFontBRW3 Color CLR_BLUE,CLR_WHITE
@ 080,215 MSGET oQTDPRV  VAR nQTDPRV       WHEN(.F.)  OF oDLG1Zerar SIZE 070,005 PICTURE ("@E 999,999,999.99") PIXEL COLOR CLR_HBLUE FONT oFontBRW3

@ 100,010 SAY OemToAnsi("Obs" )                       OF oDLG1Zerar PIXEL SIZE 250,010 FONT oFontBRW3 Color CLR_BLUE,CLR_WHITE
@ 100,045 MSGET oOBSPRV    VAR cOBSPRV     WHEN(.F.)  OF oDLG1Zerar SIZE 240,005 PIXEL COLOR CLR_HBLUE FONT oFontBRW3

@ 120,010 SAY OemToAnsi("Cliente" )                   OF oDLG1Zerar PIXEL SIZE 250,010 FONT oFontBRW3 Color CLR_BLUE,CLR_WHITE
@ 120,045 MSGET oCLIEPRV  VAR cCLIEPRV     WHEN(.F.)  OF oDLG1Zerar SIZE 240,005  PIXEL COLOR CLR_HBLUE FONT oFontBRW3


//@ 192,030 Say "Inverte Seleção"        Size 050,09 Of oDLG1Zerar Pixel
//@ 192,140 Say "Marcar Todos   "        Size 050,09 Of oDLG1Zerar Pixel
@ 192,250 Say "Zerar Previsao " 	        Size 050,09 Of oDLG1Zerar Pixel

//@ 192,010  BITMAP oBmp ResName "SELECT"            Of oDLG1Zerar Size 090,20 ON CLICK (MarcInv2())   NoBorder  Pixel
//@ 192,120  BITMAP oBmp ResName "SELECTALL"         Of oDLG1Zerar Size 090,20 ON CLICK (MarcAll2())   NoBorder  Pixel
@ 192,230  BITMAP oBmp ResName "NOMEDICA"            Of oDLG1Zerar Size 090,20 ON CLICK (PZPRV5())     NoBorder  Pixel

Activate MsDialog oDLG1Zerar Center On Init EnchoiceBar(oDLG1Zerar,{|| oDLG1Zerar:End() },{|| oDLG1Zerar:End() },,aBotoes)

RestArea(aSaveArea)

return()

*---------------------------------------------------------------------------------------------*
STATIC FUNCTION PZPRV5()
*---------------------------------------------------------------------------------------------*

Local  cQUERYZ :=''
cQUERYZ :="UPDATE SC4010 SET C4_QUANT=0 WHERE  C4_XXCOD='"+ALLTRIM(SC4->C4_XXCOD)+"' "

IF MSGYESNO (OemToAnsi('ZERAR Previsão : ')+ALLTRIM(SC4->C4_XXCOD))
   TCSQLEXEC(cQUERYZ)
   MSGALERT(OemToAnsi('Previsão Zerada : ')+ALLTRIM(SC4->C4_XXCOD))
   oDLG1Zerar:End()
ENDIF   

RETURN
