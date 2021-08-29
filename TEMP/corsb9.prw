#include "tbiconn.ch"
#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
#INCLUDE "TOTVS.CH"

User Function CORSB9()
Local cQuery  := "" 

PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01'    

cQuery  := " SELECT D3_COD, D3_LOCAL, ROUND(SUM(D3_CUSTO1)/SUM(D3_QUANT),2) AS CM1 FROM SD3010 "
cQuery  += " WHERE "
cQuery  += " D3_FILIAL='01' AND  D_E_L_E_T_='' AND D3_CUSTO1<>0 AND D3_EMISSAO BETWEEN '20200101' AND '20200131' AND D3_ESTORNO='' "
cQuery  += " AND LEFT(D3_CF,2) NOT IN ('RE') AND D3_QUANT>0  "
cQuery  += " AND D3_COD++D3_LOCAL IN ( "
cQuery  += " select  D3_COD++D3_LOCAL from SD3010 (nolock) "
cQuery  += " WHERE D_E_L_E_T_='' AND D3_CUSTO1=0 AND D3_EMISSAO BETWEEN '20200101' AND '20200131' "
cQuery  += " AND D3_ESTORNO='' "
cQuery  += " GROUP BY D3_COD, D3_LOCAL "
cQuery  += " ) "
cQuery  += " GROUP BY D3_COD, D3_LOCAL "

If Select("TMP") <> 0
	TMP->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "TMP"     

While !TMP->(EOF())
	                            
PROCFUN(TMP->D3_COD, TMP->D3_LOCAL, TMP->CM1)	                                                        

TMP->(dbSKIP())
Enddo		   


RESET ENVIRONMENT

Return                                

Static Function PROCFUN(cCodProd, cLocal, nVal )

If SB9->(DBSEEK(xFilial("SB9")+cCodProd+cLocal) )
    while SB9->(!EOF()) .AND. SB9->B9_LOCAL=cLocal .and. SB9->B9_COD=cCodProd
        If EMPTY(SB9->B9_DATA) .OR. DTOS(SB9->B9_DATA)=='20191231'
            Reclock("SB9",.F.)
            SB9->B9_CM1 := nVal
            msunlock()
            Exit
        EndIf
        SB9->( DBsKIP())    
    end
else
    Reclock("SB9",.T.)
    SB9->B9_FILIAL  := "01"
    SB9->B9_COD     := cCodProd
    SB9->B9_LOCAL   := cLocal
    SB9->B9_MCUSTD  := "1"
    SB9->B9_CM1     := nVal
    msunlock()            
ENDIF

Return 