#include "tbiconn.ch"
#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
#INCLUDE "TOTVS.CH"   
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO40    ºAutor  ³JONAS PEREIRA      º Data ³  02/10/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função de CORREÇÃO DE NUMSEQ							     º±±
±±º          ³ 		                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CORSEQ()
Local cQuery  := "" 
Private aVet := {}                     

PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01'

cQuery  := " SELECT * FROM SD1010 WHERE  D1_NUMSEQ='AHHNZM' AND D_E_L_E_T_='' " 
/*
cQuery  += " SELECT D3_DOC FROM SD3010 WHERE D3_EMISSAO >='20191001' AND D3_NUMSEQ='AHHNZM' AND D_E_L_E_T_='' AND D3_CF IN ('RE4','DE4')  "//and D3_DOC  IN ('92288343','92288344') "
cQuery  += " GROUP BY D3_DOC   "
cQuery  += " HAVING COUNT(*)=2  "
  */
  
If Select("TMP") <> 0
	TMP->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "TMP"     
              /*
If TMP->D3_TM=='010'
	AADD(aVet, TMP->R_E_C_N_O_)
	TMP->(dbSKIP())
EndIf     
                */
While !TMP->(EOF())


UCORSD1(TMP->R_E_C_N_O_)

/*
	If TMP->D3_TM=='010'
		UCORSD3()                                    
	EndIf		                     
AADD(aVet, TMP->R_E_C_N_O_)                   */

TMP->(dbSKIP())                               
Enddo  
                  
/*
If TMP->(EOF()) .and. len(aVet)>0  
	UCORSD3()
Endif
  */

RESET ENVIRONMENT

Return 



Static Function UCORSD1(nRecno)  
Local cNewSeq    
                                      
cNewSeq := ProxNum()   
SD1->(dbgoto(nRecno)) 
	If SD1->D1_NUMSEQ='AHHNZM' 
		Reclock("SD1",.F.)
		SD1->D1_NUMSEQ  := cNewSeq
		SD1->( msUnlock() )    
	EndIf  

Return .t.           
                


Static Function UCORSD3()  
Local cNewSeq    
                                      
cNewSeq := ProxNum()     

For x := 1 to len(aVet)
	SD3->(dbgoto(aVet[x])) 
	If SD3->D3_NUMSEQ='AHHNZM' .and. SD3->D3_OP<>'' 
		Reclock("SD3",.F.)
		SD3->D3_NUMSEQ  := cNewSeq
		SD3->( msUnlock() )    
	EndIf  
Next x              

aVet := {}

Return .t.           


Static Function UCORREC(nRecno)  
Local cNewSeq    
                                      
cNewSeq := ProxNum()   
SD3->(dbgoto(nRecno)) 
	If SD3->D3_NUMSEQ='AHHNZM' .and. (SD3->D3_DOC='INVENT' .OR. SD3->D3_DOC='000000000')
		Reclock("SD3",.F.)
		SD3->D3_NUMSEQ  := cNewSeq
		SD3->( msUnlock() )    
	EndIf  

Return .t.           



//RECLOCK Devolução de lote do material                        
Static Function UCORSEQ(cDoc)  
Local cNewSeq    
                                      
cNewSeq := ProxNum()
SD3->(DbSetorder(2))      
If SD3->(dbSeek(xFilial("SD3")+cDoc)) 
	While SD3->(!EOF())   .AND. SD3->D3_NUMSEQ='AHHNZM' .and. SD3->D3_DOC=cDoc
		Reclock("SD3",.F.)
		SD3->D3_NUMSEQ  := cNewSeq
		SD3->( msUnlock() )    
	SD3->(DbSkip())
	EndDO  
EndIF
                       
SDB->(DbSetorder(6))
If	SDB->(dbSeek(xFilial("SDB")+cDoc))  
	While SDB->(!EOF()) .AND. 	SDB->DB_NUMSEQ='AHHNZM'  .and. SDB->DB_DOC=cDoc
		Reclock("SDB",.F.)
		SDB->DB_NUMSEQ  := cNewSeq
		SDB->( msUnlock() )
		SDB->(DbSkip())
	EndDo
EndIf

SD5->(DbSetorder(5))
If SD5->(dbSeek(xFilial("SD5")+cDoc))   
	While SD5->(!EOF())  .AND. SD5->D5_NUMSEQ='AHHNZM' .and. SD5->D5_DOC=cDoc
		Reclock("SD5",.F.)
		SD5->D5_NUMSEQ  := cNewSeq
		SD5->( msUnlock() )     
		SD5->(DbSkip())
	EndDO
EndIF

Return .t.           