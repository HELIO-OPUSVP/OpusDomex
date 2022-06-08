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




cQuery  += "  SELECT BF_FILIAL, BF_PRODUTO, BF_QUANT, BF_LOCAL, BF_LOCALIZ, BF_LOTECTL "
cQuery  += " ,(SELECT TOP 1 C2_XOP FROM SC2010 (NOLOCK) WHERE C2_FILIAL + C2_NUM + C2_ITEM = BF_FILIAL + BF_LOTECTL AND D_E_L_E_T_ = '' ORDER BY C2_DATRF DESC) AS C2_XOP "
cQuery  += " ,(SELECT TOP 1 C2_DATRF FROM SC2010 (NOLOCK) WHERE C2_FILIAL + C2_NUM + C2_ITEM = BF_FILIAL + BF_LOTECTL AND D_E_L_E_T_ = '' ORDER BY C2_DATRF DESC) AS C2_DATRF "
cQuery  += " FROM SBF010 (NOLOCK) WHERE BF_QUANT <> 0 AND D_E_L_E_T_ = '' AND BF_LOCAL IN ('96') "
cQuery  += " AND BF_FILIAL + BF_LOTECTL NOT IN "
cQuery  += " ( "
cQuery  += " SELECT C2_FILIAL + C2_NUM + C2_ITEM FROM SC2010 (NOLOCK) WHERE C2_DATRF = '' AND D_E_L_E_T_ = '' "
cQuery  += " ) "


/*
cQuery  += " SELECT  B8_FILIAL, B8_PRODUTO, B8_SALDO, B8_LOCAL, B8_LOTECTL "
cQuery  += " ,(SELECT TOP 1 C2_XOP FROM SC2010 (NOLOCK) WHERE C2_FILIAL + C2_NUM + C2_ITEM = B8_FILIAL + B8_LOTECTL AND D_E_L_E_T_ = '' ORDER BY C2_DATRF DESC) AS C2_XOP "
cQuery  += " ,(SELECT TOP 1 C2_DATRF FROM SC2010 (NOLOCK) WHERE C2_FILIAL + C2_NUM + C2_ITEM = B8_FILIAL + B8_LOTECTL AND D_E_L_E_T_ = '' ORDER BY C2_DATRF DESC) AS C2_DATRF "
cQuery  += " FROM SB8010 (NOLOCK) WHERE B8_SALDO <> 0 AND D_E_L_E_T_ = '' AND B8_LOCAL IN ('96') "
cQuery  += " AND B8_FILIAL + B8_LOTECTL NOT IN "
cQuery  += " ( "
cQuery  += " SELECT C2_FILIAL + C2_NUM + C2_ITEM FROM SC2010 (NOLOCK) WHERE C2_DATRF = '' AND D_E_L_E_T_ = '' "
cQuery  += " ) "
*/

If Select("TMP") <> 0
	TMP->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "TMP"     


While !TMP->(EOF())


If TMP->BF_FILIAL == '02'
    TMP->(dbSKIP())
    loop
EndIf


If TMP->BF_QUANT<0
   UCORSDBD(TMP->BF_FILIAL, TMP->BF_PRODUTO, TMP->BF_LOCAL, (TMP->BF_QUANT*-1), TMP->BF_LOCALIZ, TMP->BF_LOTECTL)		    
	UMATA300(TMP->BF_PRODUTO,TMP->BF_PRODUTO,TMP->BF_LOCAL,TMP->BF_LOCAL)  
Else
	UCORSDBR(TMP->BF_FILIAL, TMP->BF_PRODUTO, TMP->BF_LOCAL, (TMP->BF_QUANT), TMP->BF_LOCALIZ, TMP->BF_LOTECTL)		    
  UMATA300(TMP->BF_PRODUTO,TMP->BF_PRODUTO,TMP->BF_LOCAL,TMP->BF_LOCAL)  
  //  URECSD5(TMP->BF_FILIAL, TMP->BF_PRODUTO, TMP->BF_LOCAL, TMP->BF_QUANT, TMP->BF_LOTECTL)
   // UMATA300(TMP->BF_PRODUTO,TMP->BF_PRODUTO,TMP->BF_LOCAL,TMP->BF_LOCAL)  
EndIf



/*

If TMP->B8_FILIAL == '02'
    TMP->(dbSKIP())
    loop
EndIf

If TMP->B8_SALDO<0
    UDEVSD5(TMP->B8_FILIAL, TMP->B8_PRODUTO, TMP->B8_LOCAL, (TMP->B8_SALDO*-1), TMP->B8_LOTECTL)	
    UMATA300(TMP->B8_PRODUTO,TMP->B8_PRODUTO,TMP->B8_LOCAL,TMP->B8_LOCAL)   
Else
    URECSD5(TMP->B8_FILIAL, TMP->B8_PRODUTO, TMP->B8_LOCAL, TMP->B8_SALDO, TMP->B8_LOTECTL)
    UMATA300(TMP->B8_PRODUTO,TMP->B8_PRODUTO,TMP->B8_LOCAL,TMP->B8_LOCAL)  
EndIf

               */               

TMP->(dbSKIP())
Enddo		   


RESET ENVIRONMENT

Return      

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

Static Function UCORSDBR(FilCor, cProduto, cLocal, nSaldo,  cEndere, cLote)  

Reclock("SDB",.T.)
SDB->DB_FILIAL  := FilCor
SDB->DB_ITEM    := "0001"
SDB->DB_NUMSEQ  := ProxNum()
SDB->DB_PRODUTO := cProduto
SDB->DB_LOCAL   := cLocal
SDB->DB_DOC     := 'ACERTOR'
SDB->DB_DATA    := DDATABASE //dUlmes + 1
SDB->DB_ORIGEM := 'ACE'
SDB->DB_QUANT   := nSaldo
SDB->DB_TM 		 := "999"   
SDB->DB_LOCALIZ := cEndere
SDB->DB_LOTECTL := cLote
SDB->DB_TIPO	 := "M"
SDB->DB_ATUEST	 := "S"
SDB->DB_STATUS	 := "M"

SDB->( msUnlock() )
                             
Return .t.

                  
Static Function UCORSDBD(FilCor, cProduto, cLocal, nSaldo,  cEndere, cLote)

Reclock("SDB",.T.)
SDB->DB_FILIAL  := FilCor
SDB->DB_ITEM    := "0001"
SDB->DB_NUMSEQ  := ProxNum()
SDB->DB_PRODUTO := cProduto
SDB->DB_LOCAL   := cLocal
SDB->DB_DOC     := 'ACERTOD'
SDB->DB_DATA    := DDATABASE //dUlmes + 1
SDB->DB_ORIGEM := 'ACE'
SDB->DB_QUANT   := nSaldo
SDB->DB_TM 		 := "499"   
SDB->DB_LOCALIZ := cEndere
SDB->DB_LOTECTL := cLote
SDB->DB_TIPO	 := "M"
SDB->DB_ATUEST	 := "S"
SDB->DB_STATUS	 := "M"
SDB->( msUnlock() )
                             
Return .t.



Static Function UDEVSD5(FilCor, cProduto, cLocal, nSaldo, cLote)

	Reclock("SD5",.T.)
	SD5->D5_FILIAL  := FilCor
	SD5->D5_NUMSEQ  := ProxNum()
	SD5->D5_PRODUTO := cProduto
	SD5->D5_LOCAL   := cLocal
	SD5->D5_DOC     := 'ACERTO96D'
	SD5->D5_DATA    := dDataBase
	SD5->D5_ORIGLAN := '499'
	SD5->D5_QUANT   := nSaldo
	SD5->D5_LOTECTL := cLote
	SD5->D5_DTVALID := StoD("20491231")
	SD5->( msUnlock() )

Return .t.

//RECLOCK Retirada de lote do material
Static Function URECSD5( FilCor,cProduto, cLocal, nSaldo, cLote)

	Reclock("SD5",.T.)
	SD5->D5_FILIAL  := FilCor
	SD5->D5_NUMSEQ  := ProxNum()
	SD5->D5_PRODUTO := cProduto
	SD5->D5_LOCAL   := cLocal
	SD5->D5_DOC     := 'ACERTO96R'
	SD5->D5_DATA    := dDataBase
	SD5->D5_ORIGLAN := '999'
	SD5->D5_QUANT   := nSaldo
	SD5->D5_LOTECTL := cLote
	SD5->D5_DTVALID := StoD("20491231")
	SD5->( msUnlock() )

Return .t.
