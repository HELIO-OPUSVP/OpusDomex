#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT097LBF  บAutor  ณMauricio Opus       บ Data ณ  07/02/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza OBS na Libera็ใo do Pedido de Compras             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MT097LBF()

Local _cQry1 := ""
Local _cQry2 := ""

*----------------------------------------------------------------------------------------------------------
/*
_cQry1 := " UPDATE SCR010 SET CR_OBS=( "
_cQry1 += " SELECT TOP 1 E4_DESCRI  "
_cQry1 += " FROM SC7010,SE4010   "
_cQry1 += " WHERE E4_CODIGO=C7_COND AND  C7_NUM=CR_NUM  AND SE4010.D_E_L_E_T_<>'*' AND SC7010.D_E_L_E_T_<>'*' "
_cQry1 += " AND C7_COND<>'' AND C7_PO_EIC='') "
_cQry1 += " WHERE D_E_L_E_T_<>'*' AND CR_OBS='' "
_cQry1 += " AND EXISTS "
_cQry1 += " (SELECT TOP 1 E4_DESCRI  "
_cQry1 += " FROM SC7010,SE4010   "
_cQry1 += " WHERE E4_CODIGO=C7_COND AND  C7_NUM=CR_NUM  AND SE4010.D_E_L_E_T_<>'*' AND SC7010.D_E_L_E_T_<>'*' "
_cQry1 += " AND C7_COND<>'' AND C7_PO_EIC='') "  
*/

_cQry1 := " UPDATE SCR010 SET CR_OBS=(  "
_cQry1 += " SELECT TOP 1 CAST(LTRIM(STR(W2_DIAS_PA))+' DIAS PA EIC'  AS BINARY(50)) "
_cQry1 += " FROM SC7010,SW2010    "
_cQry1 += " WHERE W2_PO_NUM=C7_PO_EIC AND  C7_NUM=CR_NUM  AND SW2010.D_E_L_E_T_<>'*' AND SC7010.D_E_L_E_T_<>'*'  "
_cQry1 += "  AND C7_COND='' AND C7_PO_EIC<>'')  "
_cQry1 += "  WHERE D_E_L_E_T_<>'*' AND CR_OBS IS NULL "
_cQry1 += "  AND EXISTS  "
_cQry1 += "  (SELECT TOP 1 LTRIM(STR(W2_DIAS_PA))+' DIAS PA EIC'  "
_cQry1 += "  FROM SC7010,SW2010    "
_cQry1 += "  WHERE W2_PO_NUM=C7_PO_EIC AND  C7_NUM=CR_NUM  AND SW2010.D_E_L_E_T_<>'*' AND SC7010.D_E_L_E_T_<>'*'  "
_cQry1 += "  AND C7_COND='' AND C7_PO_EIC<>'')   "

*----------------------------------------------------------------------------------------------------------
/*
_cQry2 := " UPDATE SCR010 SET CR_OBS=( "
_cQry2 += " SELECT TOP 1 LTRIM(STR(W2_DIAS_PA))+' DIAS PA EIC' "
_cQry2 += " FROM SC7010,SW2010   "
_cQry2 += " WHERE W2_PO_NUM=C7_PO_EIC AND  C7_NUM=CR_NUM  AND SW2010.D_E_L_E_T_<>'*' AND SC7010.D_E_L_E_T_<>'*' "
_cQry2 += " AND C7_COND='' AND C7_PO_EIC<>'') "
_cQry2 += " WHERE D_E_L_E_T_<>'*' AND CR_OBS='' "
_cQry2 += " AND EXISTS "
_cQry2 += " (SELECT TOP 1 LTRIM(STR(W2_DIAS_PA))+' DIAS PA EIC' "
_cQry2 += " FROM SC7010,SW2010   "
_cQry2 += " WHERE W2_PO_NUM=C7_PO_EIC AND  C7_NUM=CR_NUM  AND SW2010.D_E_L_E_T_<>'*' AND SC7010.D_E_L_E_T_<>'*' "
_cQry2 += " AND C7_COND='' AND C7_PO_EIC<>'') "   
*/

_cQry2 := "  UPDATE SCR010 SET CR_OBS=(  "
_cQry2 += "  SELECT TOP 1 CAST(E4_DESCRI AS BINARY(50))  "
_cQry2 += "  FROM SC7010,SE4010    "
_cQry2 += "  WHERE E4_CODIGO=C7_COND AND  C7_NUM=CR_NUM  AND SE4010.D_E_L_E_T_<>'*' AND SC7010.D_E_L_E_T_<>'*'  "
_cQry2 += "  AND C7_COND<>'' AND C7_PO_EIC='') "
_cQry2 += "  WHERE D_E_L_E_T_<>'*' AND CR_OBS IS NULL "
_cQry2 += "  AND EXISTS  "
_cQry2 += "  (SELECT TOP 1 E4_DESCRI   "
_cQry2 += "  FROM SC7010,SE4010    "
_cQry2 += "  WHERE E4_CODIGO=C7_COND AND  C7_NUM=CR_NUM  AND SE4010.D_E_L_E_T_<>'*' AND SC7010.D_E_L_E_T_<>'*'  "
_cQry2 += "  AND C7_COND<>'' AND C7_PO_EIC='') "


*----------------------------------------------------------------------------------------------------------

TCSQLEXEC(_cQry1)
TCSQLEXEC(_cQry2)

Return(.T.)

