#INCLUDE "PROTHEUS.CH"

User Function FI040ROT() 

Local aRotRet := AClone(PARAMIXB)
aAdd( aRotRet,{"Bol.Itau Bordero", "u_mBolPDF2()", 0, 7})
aAdd( aRotRet,{"Bol.Itau Avulso" , "u_mBolPDF()", 0, 7})

Return aRotRet
