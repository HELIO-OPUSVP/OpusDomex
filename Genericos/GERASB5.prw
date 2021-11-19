#include "rwmake.ch"
#include "topconn.ch"
#include "totvs.ch"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "PROTHEUS.CH"


/// Cria Item Contabil a partir de Clientes...

User Function GERASB5()

local nCont := 0
local lGrava := .F.


cQuery := " SELECT B1_COD,B1_DESC,B1_TIPO,B1_UM,YD_UNID,B1_POSIPI,B1_PESO,B1_XXDRBCK,B1_PESO FROM SB1010 SB1 "
cQuery += " LEFT JOIN SYD010 SYD "
cQuery += " ON B1_POSIPI = YD_TEC "
cQuery += "  WHERE SB1.D_E_L_E_T_ = '' AND B1_XXDRBCK = 'S'  AND B1_TIPO = 'PA' AND B1_UM IN ('PC','CJ') "
cQuery += " ORDER BY B1_POSIPI "

cQuery := " SELECT B1_COD,B1_DESC,B1_TIPO,B1_UM,'' YD_UNID,B1_POSIPI,B1_PESO,B1_XXDRBCK,B1_PESO FROM SB1010 SB1 WITH(NOLOCK) "
cQuery += " WHERE  D_E_L_E_T_='' AND B1_POSIPI IN  ('85447010')  "
//cQuery += " WHERE  D_E_L_E_T_='' AND B1_COD IN ('5030720462539','PJ2C15005005000') "

TCQUERY cQuery NEW ALIAS "QUERYSB1"

SB5->( dbSetOrder(1) )


ALERT("inicio da rotina - GERA SB5")

While !QUERYSB1->( EOF() )
	If SB5->( dbSeek( xFilial("SB5") + QUERYSB1->B1_COD ) )
		lGrava :=.F.
	Else
		lGrava :=.T.
	Endif
	
	If RecLock("SB5",lGrava)
		
		SB5->B5_FILIAL	:= "01"
		SB5->B5_COD		:= QUERYSB1->B1_COD
		SB5->B5_CEME	:= QUERYSB1->B1_DESC
		SB5->B5_CONVDIP := QUERYSB1->B1_PESO
		SB5->B5_UMDIPI	:= "KG"
		SB5->B5_UMIND	:= "1"
		SB5->B5_QUAL	:= "IMPORT"
		
		SB5->(MsUnlock())
		nCont++
	endif
	QUERYSB1->( dbSkip() )
	
End


Alert("Foram processados " + Alltrim(str(nCont)) + " Complementos de Produto")
Return



User Function GERASB5R()

local nCont := 0
local lGrava := .F.


//cQuery := " SELECT B1_COD,B1_DESC,B1_TIPO,B1_UM,'' YD_UNID,B1_POSIPI,B1_PESO,B1_XXDRBCK,B1_PESO FROM SB1010 SB1 WITH(NOLOCK) "
//cQuery += " WHERE  D_E_L_E_T_='' AND B1_COD IN ('DMXDGMZ007016K0','DMXDGMZ0070143I','DMXDGMZ00701510','DMXDGMZ007015K0','DMXDGMZ00701516','DMXDGMZ00701295','DMXDGMZ00701510') "

cQuery := " SELECT B1_COD,B1_DESC,B1_TIPO,B1_UM,'' YD_UNID,B1_POSIPI,B1_PESO,B1_XXDRBCK,B1_PESO FROM SB1010 SB1 WITH(NOLOCK)  "
cQuery += " WHERE  D_E_L_E_T_=''  AND B1_POSIPI='85447010' AND B1_TIPO='PA'   "

TCQUERY cQuery NEW ALIAS "QUERYSB1"

SB5->( dbSetOrder(1) )

While !QUERYSB1->( EOF() )
	If SB5->( dbSeek( xFilial("SB5") + QUERYSB1->B1_COD ) )
		lGrava :=.F.
	else
		lGrava :=.T.
		If RecLock("SB5",.T.)
			
			SB5->B5_FILIAL	:= "01"
			SB5->B5_COD		:= QUERYSB1->B1_COD
			SB5->B5_CEME	:= QUERYSB1->B1_DESC
			SB5->B5_CONVDIP := QUERYSB1->B1_PESO
			SB5->B5_UMDIPI	:= "KG"
			SB5->B5_UMIND	:= "1"
			SB5->B5_QUAL	:= "IMPORT"
			
			SB5->(MsUnlock())
			nCont++
		endif
	endif
	QUERYSB1->( dbSkip() )
	
End


Alert("Foram processados " + Alltrim(str(nCont)) + " Complementos de Produto")
Return
