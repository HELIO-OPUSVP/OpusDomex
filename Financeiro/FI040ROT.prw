#INCLUDE "PROTHEUS.CH"

User Function FI040ROT() 

Local aRotRet := AClone(PARAMIXB)

//aAdd( aRotRet,{"Bol.Itau Bordero", "u_mBolPDF2()", 0, 7})
//aAdd( aRotRet,{"Bol.Itau Avulso" , "u_mBolPDF()", 0, 7})

aAdd( aRotRet,{"Itau - Bordero", "u_mBolPDF2()", 0, 7})
aAdd( aRotRet,{"Itau - Avulso" , "u_mBolPDF()", 0, 7})

aAdd( aRotRet,{"Santander - Bordero", "u_BOL033B()", 0, 7})
aAdd( aRotRet,{"Santander - Avulso" , "u_BOL033()", 0, 7})


Return aRotRet
