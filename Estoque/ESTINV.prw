#include "tbiconn.ch"
#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
#INCLUDE "TOTVS.CH"   
/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO40    �Autor  �JONAS PEREIRA      � Data �  02/1/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o de CORRE��O DE DIF SALDO								     ���
���          � 		                                                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ESTINV()
Local cQuery  := "" 

PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01'

cQuery  := " "   

cQuery  += " SELECT * FROM SB8010 (NOLOCK) WHERE B8_SALDO <>0 AND D_E_L_E_T_='' "

cQuery  += " AND B8_PRODUTO+''+B8_LOCAL IN "
cQuery  += " ( "
cQuery  += " SELECT * FROM DIFSLD "
cQuery  += " ) "


If Select("TMP") <> 0
	TMP->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "TMP"     


While !TMP->(EOF())


If TMP->B8_SALDO < 0
UCORSD5D(TMP->B8_PRODUTO, TMP->B8_LOCAL, (TMP->B8_SALDO)*(-1), TMP->B8_LOTECTL)	 
Else
UCORSD5R(TMP->B8_PRODUTO, TMP->B8_LOCAL, (TMP->B8_SALDO), TMP->B8_LOTECTL)
EndIf
UMATA300(TMP->B8_PRODUTO,TMP->B8_PRODUTO,TMP->B8_LOCAL,TMP->B8_LOCAL)  


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



//RECLOCK Devolu��o de lote do material                        
Static Function UCORSD5D(cProduto, cLocal, nSaldo, cLote)  
Local dUlmes := GETMV("MV_ULMES",.F.,)     

DBSelectarea("SD5")

Reclock("SD5",.T.)
SD5->D5_FILIAL  := xFilial("SD5")
SD5->D5_NUMSEQ  := ProxNum()
SD5->D5_PRODUTO := cProduto
SD5->D5_LOCAL   := cLocal
SD5->D5_DOC     := 'ACERTO'
SD5->D5_DATA    :=  DDATABASE //dUlmes + 1
SD5->D5_ORIGLAN := '499'
SD5->D5_QUANT   := nSaldo
SD5->D5_LOTECTL := cLote
SD5->D5_DTVALID := StoD("20491231")
SD5->( msUnlock() )
	
Return .t.           



//RECLOCK Devolu��o de lote do material                        
Static Function UCORSD5R(cProduto, cLocal, nSaldo, cLote)  
Local dUlmes := GETMV("MV_ULMES",.F.,)     

DBSelectarea("SD5")

Reclock("SD5",.T.)
SD5->D5_FILIAL  := xFilial("SD5")
SD5->D5_NUMSEQ  := ProxNum()
SD5->D5_PRODUTO := cProduto
SD5->D5_LOCAL   := cLocal
SD5->D5_DOC     := 'ACERTO'
SD5->D5_DATA    :=  DDATABASE //dUlmes + 1
SD5->D5_ORIGLAN := '999'
SD5->D5_QUANT   := nSaldo
SD5->D5_LOTECTL := cLote
SD5->D5_DTVALID := StoD("20491231")
SD5->( msUnlock() )
	
Return .t.           



//RECLOCK Devolu��o de lote do material                        
Static Function UCORSDBD(cProduto, cLocal, nSaldo, cLote, cEndere)  
Local dUlmes := GETMV("MV_ULMES",.F.,)     

DBSelectarea("SDB")

Reclock("SDB",.T.)
SDB->DB_FILIAL  := xFilial("SDB")
SDB->DB_ITEM    := "0001"
SDB->DB_NUMSEQ  := ProxNum()
SDB->DB_PRODUTO := cProduto
SDB->DB_LOCAL   := cLocal
SDB->DB_DOC     := 'ACERTO'
SDB->DB_DATA    := DDATABASE //dUlmes + 1
SDB->DB_ORIGEM := 'ACE'
SDB->DB_QUANT   := nSaldo
SDB->DB_LOTECTL := cLote
SDB->DB_TM 		 := "499"   
SDB->DB_LOCALIZ := cEndere
SDB->DB_TIPO	 := "M"
SDB->DB_ATUEST	 := "S"
SDB->DB_STATUS	 := "M"

SDB->( msUnlock() )
                             
Return .t.

//RECLOCK RETIRADA de lote do material                        
Static Function UCORSDBR(cProduto, cLocal, nSaldo, cLote, cEndere)  
Local dUlmes := GETMV("MV_ULMES",.F.,)     

DBSelectarea("SDB")

Reclock("SDB",.T.)
SDB->DB_FILIAL  := xFilial("SDB")
SDB->DB_ITEM    := "0001"
SDB->DB_NUMSEQ  := ProxNum()
SDB->DB_PRODUTO := cProduto
SDB->DB_LOCAL   := cLocal
SDB->DB_DOC     := 'ACERTO'
SDB->DB_DATA    := DDATABASE //dUlmes + 1
SDB->DB_ORIGEM := 'ACE'
SDB->DB_QUANT   := nSaldo
SDB->DB_LOTECTL := cLote
SDB->DB_TM 		 := "999"   
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

//Chama pergunta ocultamente para alimentar vari�veis
Pergunte("MTA300",.F.,,,,,@aBkpPerg)

//Altera conte�do de alguma pergunta
mv_par01 := cLoc1
mv_par02 := cLoc2
mv_par03 := cProd1
mv_par04 := cProd2
mv_par05 := 2
mv_par06 := 2
mv_par07 := 2
mv_par08 := 2

//Carrega vari�vel principal para que os par�metros
//definido acima sejam salvos na pr�xima chamada
SaveMVVars(.T.)

__SaveParam("MTA300    ", aBkpPerg)

//�����������������������������������������������������������������Ŀ
//� mv_par01 - Almoxarifado De   ?                                  �
//� mv_par02 - Almoxarifado Ate  ?                                  �
//� mv_par03 - Do produto                                           �
//� mv_par04 - Ate o produto                                        �
//� mv_par05 - Zera o Saldo da MOD?  Sim/Nao/Recalcula              �
//� mv_par06 - Zera o CM da MOD?  Sim/Nao/Recalcula                 �
//�������������������������������������������������������������������

//Chama rotina de recalculo do saldo atual

MATA300(.T.)

Return                    

