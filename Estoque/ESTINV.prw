#include "tbiconn.ch"
#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
#INCLUDE "TOTVS.CH"   
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO40    บAutor  ณJONAS PEREIRA      บ Data ณ  02/1/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo de CORREวรO DE DIF SALDO								     บฑฑ
ฑฑบ          ณ 		                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ESTINV()
Local cQuery  := "" 

PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01'

cQuery  := " "   

cQuery  += " SELECT * FROM CORDB "



If Select("TMP") <> 0
	TMP->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "TMP"     


While !TMP->(EOF())


If TMP->TIPO=='C'
    UCORSDBC(TMP->B2_FILIAL, TMP->B2_COD, TMP->B2_LOCAL, DIF, LOCALIZ)	 
Else
    UCORSDBD(TMP->B2_FILIAL, TMP->B2_COD, TMP->B2_LOCAL, DIF, LOCALIZ)
EndIf
//UMATA300(TMP->B8_PRODUTO,TMP->B8_PRODUTO,TMP->B8_LOCAL,TMP->B8_LOCAL)  


/*
If TMP->BF_QUANT < 0
    UCORSDBD(TMP->BF_PRODUTO, TMP->BF_LOCAL, TMP->BF_QUANT*(-1),  TMP->BF_LOTECTL, TMP->BF_LOCALIZ)
Else    
    UCORSDBR(TMP->BF_PRODUTO, TMP->BF_LOCAL, TMP->BF_QUANT     ,  TMP->BF_LOTECTL, TMP->BF_LOCALIZ)
EndIF  
UMATA300(TMP->BF_PRODUTO,TMP->BF_PRODUTO,TMP->BF_LOCAL,TMP->BF_LOCAL)   
*/
    

//UMATA300(TMP->B8_PRODUTO,TMP->B8_PRODUTO,TMP->B8_LOCAL,TMP->B8_LOCAL)
//U_CRIAP07(TMP->B8_PRODUTO,'97',.T.)
                              

TMP->(dbSKIP())
Enddo		   


RESET ENVIRONMENT

Return      



//RECLOCK Devolu็ใo de lote do material                        
Static Function UCORSDBD(cFilial, cProduto, cLocal, nSaldo,  cEndere)  
Local dUlmes := GETMV("MV_ULMES",.F.,)     

DBSelectarea("SDB")

Reclock("SDB",.T.)
SDB->DB_FILIAL  := cFilial
SDB->DB_ITEM    := "0001"
SDB->DB_NUMSEQ  := ProxNum()
SDB->DB_PRODUTO := cProduto
SDB->DB_LOCAL   := cLocal
SDB->DB_DOC     := 'ACERTO'
SDB->DB_DATA    := DDATABASE //dUlmes + 1
SDB->DB_ORIGEM := 'ACE'
SDB->DB_QUANT   := nSaldo
SDB->DB_TM 		 := "999"   
SDB->DB_LOCALIZ := cEndere
SDB->DB_TIPO	 := "M"
SDB->DB_ATUEST	 := "S"
SDB->DB_STATUS	 := "M"

SDB->( msUnlock() )
                             
Return .t.


//RECLOCK Devolu็ใo de lote do material                        
Static Function UCORSDBC(cFilial, cProduto, cLocal, nSaldo,  cEndere)  
Local dUlmes := GETMV("MV_ULMES",.F.,)     

DBSelectarea("SDB")

Reclock("SDB",.T.)
SDB->DB_FILIAL  := cFilial
SDB->DB_ITEM    := "0001"
SDB->DB_NUMSEQ  := ProxNum()
SDB->DB_PRODUTO := cProduto
SDB->DB_LOCAL   := cLocal
SDB->DB_DOC     := 'ACERTO'
SDB->DB_DATA    := DDATABASE //dUlmes + 1
SDB->DB_ORIGEM := 'ACE'
SDB->DB_QUANT   := nSaldo
SDB->DB_TM 		 := "499"   
SDB->DB_LOCALIZ := cEndere
SDB->DB_TIPO	 := "M"
SDB->DB_ATUEST	 := "S"
SDB->DB_STATUS	 := "M"

SDB->( msUnlock() )
                             
Return .t.


Static Function UMATA300(cProd1,cProd2,cLoc1,cLoc2)
Default cProd1 := Space(15)
Default cProd2 := Repl("z",15)
Default cLoc1  := Space(2)
Default cLoc2  := "zz"

aBkpPerg := {}

//Chama pergunta ocultamente para alimentar variแveis
Pergunte("MTA300",.F.,,,,,@aBkpPerg)

//Altera conte๚do de alguma pergunta
mv_par01 := cLoc1
mv_par02 := cLoc2
mv_par03 := cProd1
mv_par04 := cProd2
mv_par05 := 2
mv_par06 := 2
mv_par07 := 2
mv_par08 := 2

//Carrega variแvel principal para que os parโmetros
//definido acima sejam salvos na pr๓xima chamada
SaveMVVars(.T.)

__SaveParam("MTA300    ", aBkpPerg)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ mv_par01 - Almoxarifado De   ?                                  ณ
//ณ mv_par02 - Almoxarifado Ate  ?                                  ณ
//ณ mv_par03 - Do produto                                           ณ
//ณ mv_par04 - Ate o produto                                        ณ
//ณ mv_par05 - Zera o Saldo da MOD?  Sim/Nao/Recalcula              ณ
//ณ mv_par06 - Zera o CM da MOD?  Sim/Nao/Recalcula                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//Chama rotina de recalculo do saldo atual

MATA300(.T.)

Return                    

