#include "TbiConn.ch"
#include "TbiCode.ch"
#include "Rwmake.ch"
#include "Topconn.ch"
#include "Protheus.ch"

//-----------------------------------------------------------------------------------------------------------------------------------------------//
//JONAS -OpusVp - 25/03/2020                                                                                                                    //
//-----------------------------------------------------------------------------------------------------------------------------------------------//
//Especifico Rosenberger Domex- Correção de Movimentos Desbalanceados                                                                                                                  //
//-----------------------------------------------------------------------------------------------------------------------------------------------//                                                                                                      //

User Function CHKMOV(cProduto, cNumseq, nRec, cTipo) 
//LOCAL cProduto   := '121D009125206L '
//LOCAL nRec       :=  18467031
//LOCAL cTipo      := 'T'
//LOCAL cNUmseq    := 'AICYY2'
Local lReturn    := .t.
PRIVATE aRetSD3  := {}

//PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01'

aArea := GetArea()
//cTipo = T ;Tranferencia


If alltrim(cTipo)<>"T" .or. nRec == Nil
    lReturn := .f.
else
     //transferencias
    //SD3 - VERIFICA INTEGRIDADE DO SD3 E CORRIGE 
    If FCHSD3TR(cProduto, cNumseq, nRec)    
        //SD5 SE EXITE SD5, VERIFICA INTEGRIDADE, SENAO CRIA MOVIMENTO A PARTIR DO SD3
        SD5->(DBSETORDER( 3 ))
        If   SD5->( dbSeek( xFilial() + cNumseq + cProduto ) ) 
            lReturn := FCHSD5TR(cProduto, cNumseq, SD5->( Recno()) )   
        ElseIf SB1->( dbSeek( xFilial() + cProduto ) ) 
            If SB1->B1_RASTRO=="L"
                lReturn := FCREASD5(cProduto, cNumseq)
            EndIf            
        EndIf
        //SDB SE EXITE SDB, VERIFICA INTEGRIDADE, SENAO CRIA MOVIMENTO A PARTIR DO SD3
        SDB->(DBSETORDER( 25 ))
        If   SDB->( dbSeek( xFilial() + cNumseq + cProduto ) )
            lReturn := FCHSDBTR(cProduto, cNumseq, SDB->( Recno()) )    
        ElseIf SB1->( dbSeek( xFilial() + cProduto ) ) 
            If SB1->B1_LOCALIZ=="S"
                lReturn := FCREASDB(cProduto, cNumseq)
            EndIf            
        EndIf
    else
        lReturn := .f.
    EndIf
EndIf

RestArea(aArea)
//RESET ENVIRONMENT
Return lReturn

//CORREÇÃO DE TRANSFERENCIAS SD3
Static Function FCHSD3TR(cTransProd, cTransseq, nTransReq )
Local cD3Numseq   := "" 
Local cD3Produto  := "" 
Local cD3Local    := ""
Local cD3Emissao  := ""
Local cD3Doc      := ""
Local nQTDRE4     := 0
Local nQTDDE4     := 0
Local nCUSRE4     := 0
Local nCUSDE4     := 0
Local nCont       := 0 
Local nRecDE4     := 0
Local nRecRE4     := 0

SD3->(DBSETORDER( 1 ))
SD3->( dbGoTo(nTransReq) )

//Verifica se é transferencia
If SD3->D3_CF <> 'DE4' .and. SD3->D3_CF <> 'RE4'
    Return(.f.) 
EndIf

cD3Numseq   := SD3->D3_NUMSEQ
cD3Produto  := SD3->D3_COD
cD3Emissao  := SD3->D3_EMISSAO
cD3Doc      := SD3->D3_DOC
cD3Local    := SD3->D3_LOCAL

//coleta a quantidade do RE4 E DE4 e conta o numero de movimentos
If cD3Produto == cTransProd .and. cD3Numseq==cTransseq
    SD3->( dbSetOrder(4) )  // D3_FILIAL + D3_NUMSEQ
	If SD3->( dbSeek( xFilial() + cD3Numseq ) )
		While !SD3->( EOF() ) .and. ALLTRIM(SD3->D3_NUMSEQ) == ALLTRIM(cD3Numseq)
			If SD3->D3_COD == cD3Produto
				If SD3->D3_EMISSAO == cD3Emissao
					If SD3->D3_DOC == cD3Doc
                        IF SD3->D3_CF == 'RE4'
                            nQTDRE4   := SD3->D3_QUANT
                            nCUSRE4   := SD3->D3_CUSTO1
                            nRecRE4   := SD3->( Recno() ) 
                            nCont := nCont + 1
                        ElseIF SD3->D3_CF == 'DE4'
                            nQTDDE4   := SD3->D3_QUANT
                            nCUSDE4   := SD3->D3_CUSTO1
                            nRecDE4   := SD3->( Recno() ) 
                            nCont := nCont + 1
                        EndIf							
					EndIf
				EndIf
			EndIf
			SD3->( dbSkip() )
		End
	EndIf
EndIF

AADD(aRetSD3,nRecRE4)
AADD(aRetSD3,nRecDE4)

//Movimento correto
If nCont == 2 .and. nQTDRE4==nQTDDE4
    Return(.t.)
//Movimento com RE4 MENOR
ElseIf nCont==2 .and. nQTDRE4<nQTDDE4
    SD3->( dbGoTo(nRecDE4) )
    If cD3Produto == SD3->D3_COD .and. cD3Numseq==SD3->D3_NUMSEQ  .and. cD3doc==SD3->D3_DOC .and. nQTDDE4==SD3->D3_QUANT
        Reclock("SD3",.F.)
        SD3->D3_QUANT  := nQTDRE4
        SD3->D3_CUSTO1 := nCUSRE4
        SD3->(Msunlock())
        U_UMATA300(SD3->D3_COD,SD3->D3_COD,SD3->D3_LOCAL,SD3->D3_LOCAL)
    EndIf
//Movimento com DE4 MENOR
ElseIf nCont==2 .and. nQTDDE4<nQTDRE4
    SD3->(dbGoTo(nRecRE4))
    If cD3Produto == SD3->D3_COD .and. cD3Numseq==SD3->D3_NUMSEQ  .and. cD3doc==SD3->D3_DOC .and. nQTDRE4==SD3->D3_QUANT
        Reclock("SD3",.F.)
        SD3->D3_QUANT  := nQTDDE4
        SD3->D3_CUSTO1 := nCUSDE4
        SD3->(Msunlock())
        U_UMATA300(SD3->D3_COD,SD3->D3_COD,SD3->D3_LOCAL,SD3->D3_LOCAL)
    EndIf
EndIF

nCont         := 0 
nQTDRE4       := 0
nQTDDE4       := 0
nCUSRE4       := 0
nCUSDE4       := 0


Return(.t.)



//CORREÇÃO DE TRANSFERENCIAS SD5
Static Function FCHSD5TR(cTransProd, cTransseq, nTransReq )
Local cD5Numseq   := "" 
Local cD5Produto  := "" 
Local cD5Local    := ""
Local cD5Data     := CTOD('  /  /  ')
Local cD5Doc      := ""
Local nQTDRE4     := 0
Local nQTDDE4     := 0
Local nCont       := 0 

Local tmpD5_QUANT   := 0
Local tmpD5_PRODUTO := ""
Local tmpD5_OP      := ""
Local tmpD5_LOCAL   := ""
Local tmpD5_DOC     := ""
Local tmpD5_DATA    := CTOD('  /  /  ')
Local tmpD5_NUMSEQ  := ""
Local tmpD5_LOTECTL := ""
Local tmpD5_DTVALID := CTOD('  /  /  ')

Local nRecDE4     := 0
Local nRecRE4     := 0


SD5->(DBSETORDER( 1 ))
SD5->( dbGoTo(nTransReq) )

//Verifica se é transferencia
If SD5->D5_ORIGLAN <> '499' .and. SD5->D5_ORIGLAN <> '999'
    Return .f.
EndIf

cD5Numseq   := SD5->D5_NUMSEQ
cD5Produto  := SD5->D5_PRODUTO
cD5Data     := SD5->D5_DATA
cD5Doc      := SD5->D5_DOC
cD5Local    := SD5->D5_LOCAL

//coleta a quantidade do RE4 E DE4 e conta o numero de movimentos
If cD5Produto == cTransProd .and. cD5Numseq==cTransseq
    SD5->( dbSetOrder(3) )  // D5_FILIAL + D5_NUMSEQ
	If SD5->( dbSeek( xFilial() + cD5Numseq ) )
		While !SD5->( EOF() ) .and. ALLTRIM(SD5->D5_NUMSEQ) == ALLTRIM(cD5Numseq)
			If SD5->D5_PRODUTO == cD5Produto
				If SD5->D5_DATA == cD5Data
					If SD5->D5_DOC == cD5Doc
                        IF SD5->D5_ORIGLAN == '999'
                            nQTDRE4   := SD5->D5_QUANT
                            nRecRE4   := SD5->( Recno() ) 
                            nCont := nCont + 1
                        ElseIF SD5->D5_ORIGLAN == '499'
                            nQTDDE4   := SD5->D5_QUANT                    
                            nRecDE4   := SD5->( Recno() ) 
                            nCont := nCont + 1
                        EndIf							
					EndIf
				EndIf
			EndIf
			SD5->( dbSkip() )
		End
	EndIf
EndIF

//Movimento correto
If nCont == 2 .and. nQTDRE4==nQTDDE4
    //corrige D3 X D5, QUANDO INCONSISTENTE
    If FVLDD3D5(nRecDE4, aRetSD3[2], nRecRE4, aRetSD3[1], cD5Numseq, cD5doc, cD5Produto ) 
        U_UMATA300(cD5Produto,cD5Produto,cD5Local,cD5Local)
    EndIf
    Return .t.
//Movimento com RE4 MENOR
ElseIf nCont==2 .and. nQTDRE4<nQTDDE4
    SD5->( dbGoTo(nRecDE4) )
    If cD5Produto == SD5->D5_PRODUTO .and. cD5Numseq==SD5->D5_NUMSEQ  .and. cD5doc==SD5->D5_DOC .and. nQTDDE4==SD5->D5_QUANT
        Reclock("SD5",.F.)
        SD5->D5_QUANT  := nQTDRE4
        SD5->(Msunlock())
        U_UMATA300(SD5->D5_PRODUTO,SD5->D5_PRODUTO,SD5->D5_LOCAL,SD5->D5_LOCAL)
    EndIf
//Movimento com DE4 MENOR
ElseIf nCont==2 .and. nQTDDE4<nQTDRE4
    SD5->(dbGoTo(nRecRE4))
    If cD5Produto == SD5->D5_PRODUTO .and. cD5Numseq==SD5->D5_NUMSEQ  .and. cD5doc==SD5->D5_DOC .and. nQTDRE4==SD5->D5_QUANT
        Reclock("SD5",.F.)
        SD5->D5_QUANT  := nQTDDE4
        SD5->(Msunlock())
        U_UMATA300(SD5->D5_PRODUTO,SD5->D5_PRODUTO,SD5->D5_LOCAL,SD5->D5_LOCAL)
    EndIf

//DE4 inexistente
ElseIf nCont==1 .and. nQTDDE4==0
    SD3->( dbGoTo(aRetSD3[2]) )
    If ALLTRIM(cD5Produto) == ALLTRIM(SD3->D3_COD) .and. cD5Numseq==SD3->D3_NUMSEQ  .and. ALLTRIM(cD5doc)==ALLTRIM(SD3->D3_DOC) .and. nQTDRE4==SD3->D3_QUANT
        
        tmpD5_QUANT    := SD3->D3_QUANT  
        tmpD5_PRODUTO  := SD3->D3_COD
        tmpD5_OP       := SD3->D3_OP      
        tmpD5_LOCAL    := SD3->D3_LOCAL   
        tmpD5_DOC      := SD3->D3_DOC     
        tmpD5_DATA     := SD3->D3_EMISSAO
        tmpD5_NUMSEQ   := SD3->D3_NUMSEQ  
        tmpD5_LOTECTL  := SD3->D3_LOTECTL 
        tmpD5_DTVALID  := SD3->D3_DTVALID 

        Reclock("SD5",.T.)
        SD5->D5_FILIAL  := "01"
        SD5->D5_ORIGLAN := "499"
        SD5->D5_QUANT   :=  tmpD5_QUANT
        SD5->D5_PRODUTO :=  tmpD5_PRODUTO 
        SD5->D5_OP      :=  tmpD5_OP      
        SD5->D5_LOCAL   :=  tmpD5_LOCAL   
        SD5->D5_DOC     :=  tmpD5_DOC     
        SD5->D5_DATA    :=  tmpD5_DATA  
        SD5->D5_NUMSEQ  :=  tmpD5_NUMSEQ  
        SD5->D5_LOTECTL :=  tmpD5_LOTECTL 
        SD5->D5_DTVALID :=  tmpD5_DTVALID 
		SD5->( msUnlock() )
        U_UMATA300(SD5->D5_PRODUTO,SD5->D5_PRODUTO,SD5->D5_LOCAL,SD5->D5_LOCAL)
    EndIf
//RE4 inexistente
ElseIf nCont==1 .and. nQTDRE4==0
    SD3->( dbGoTo(aRetSD3[1]) )
    If ALLTRIM(cD5Produto) == ALLTRIM(SD3->D3_COD) .and. cD5Numseq==SD3->D3_NUMSEQ  .and. ALLTRIM(cD5doc)==ALLTRIM(SD3->D3_DOC) .and. nQTDDE4==SD3->D3_QUANT
        
        tmpD5_QUANT    := SD3->D3_QUANT  
        tmpD5_PRODUTO  := SD3->D3_COD
        tmpD5_OP       := SD3->D3_OP      
        tmpD5_LOCAL    := SD3->D3_LOCAL   
        tmpD5_DOC      := SD3->D3_DOC     
        tmpD5_DATA     := SD3->D3_EMISSAO
        tmpD5_NUMSEQ   := SD3->D3_NUMSEQ  
        tmpD5_LOTECTL  := SD3->D3_LOTECTL 
        tmpD5_DTVALID  := SD3->D3_DTVALID 

        Reclock("SD5",.T.)
        SD5->D5_FILIAL  := "01"
        SD5->D5_ORIGLAN := "999"
        SD5->D5_QUANT   :=  tmpD5_QUANT
        SD5->D5_PRODUTO :=  tmpD5_PRODUTO 
        SD5->D5_OP      :=  tmpD5_OP      
        SD5->D5_LOCAL   :=  tmpD5_LOCAL   
        SD5->D5_DOC     :=  tmpD5_DOC     
        SD5->D5_DATA    :=  tmpD5_DATA  
        SD5->D5_NUMSEQ  :=  tmpD5_NUMSEQ  
        SD5->D5_LOTECTL :=  tmpD5_LOTECTL 
        SD5->D5_DTVALID :=  tmpD5_DTVALID 
		SD5->( msUnlock() )
        U_UMATA300(SD5->D5_PRODUTO,SD5->D5_PRODUTO,SD5->D5_LOCAL,SD5->D5_LOCAL)

    EndIf
EndIF

//corrige D3 X D5, QUANDO INCONSISTENTE
If FVLDD3D5(nRecDE4, aRetSD3[2], nRecRE4, aRetSD3[1], cD5Numseq, cD5doc, cD5Produto ) 
    U_UMATA300(cD5Produto,cD5Produto,cD5Local,cD5Local)
EndIf

nCont          := 0 
nQTDRE4        := 0
nQTDDE4        := 0
tmpD5_QUANT    := 0
tmpD5_PRODUTO  := ""
tmpD5_OP       := ""
tmpD5_LOCAL    := ""
tmpD5_DOC      := ""
tmpD5_DATA     := ""
tmpD5_NUMSEQ   := ""
tmpD5_LOTECTL  := ""
tmpD5_DTVALID  := CTOD('  /  /  ')

Return .t.


//CORREÇÃO DE TRANSFERENCIAS SDB
Static Function FCHSDBTR(cTransProd, cTransseq, nTransReq )
Local cDBNumseq   := "" 
Local cDBProduto  := "" 
Local cDBLocal    := ""
Local cDBData     := CTOD('  /  /  ')
Local cDBDoc      := ""
Local nQTDRE4     := 0
Local nQTDDE4     := 0
Local nCont       := 0 

Local tmpDB_QUANT   := 0
Local tmpDB_PRODUTO := ""
Local tmpDB_LOCAL   := ""
Local tmpDB_DOC     := ""
Local tmpDB_DATA    := CTOD('  /  /  ')
Local tmpDB_NUMSEQ  := ""
Local tmpDB_LOTECTL := ""
Local tmpDB_LOCALIZ := ""
Local nRecDE4     := 0
Local nRecRE4     := 0




SDB->(DBSETORDER( 1 ))
SDB->( dbGoTo(nTransReq) )

//Verifica se é transferencia
If SDB->DB_TM <> '499' .and. SDB->DB_TM <> '999'
    Return .f.
EndIf

cDBNumseq   := SDB->DB_NUMSEQ
cDBProduto  := SDB->DB_PRODUTO
cDBData     := SDB->DB_DATA
cDBDoc      := SDB->DB_DOC
cDBLocal    := SDB->DB_LOCAL

//coleta a quantidade do RE4 E DE4 e conta o numero de movimentos
If cDbProduto == cTransProd .and. cDbNumseq==cTransseq
    SDB->( dbSetOrder(25) )  // D3_FILIAL + D3_NUMSEQ
	If SDB->( dbSeek( xFilial() + cDbNumseq ) )
		While !SDB->( EOF() ) .and. ALLTRIM(SDB->DB_NUMSEQ) == ALLTRIM(cDbNumseq)
			If SDB->DB_PRODUTO == cDBProduto
				If SDB->DB_DATA == cDBData
					If SDB->DB_DOC == cDBDoc
                        IF SDB->DB_TM == '999'
                            nQTDRE4   := SDB->DB_QUANT
                            nRecRE4   := SDB->( Recno() ) 
                            nCont := nCont + 1
                        ElseIF SDB->DB_TM == '499'
                            nQTDDE4   := SDB->DB_QUANT                    
                            nRecDE4   := SDB->( Recno() ) 
                            nCont := nCont + 1
                        EndIf							
					EndIf
				EndIf
			EndIf
			SDB->( dbSkip() )
		End
	EndIf
EndIF

//Movimento correto
If nCont == 2 .and. nQTDRE4==nQTDDE4
    //corrige D3 X DB, QUANDO INCONSISTENTE
    If FVLDD3DB(nRecDE4, aRetSD3[2], nRecRE4, aRetSD3[1], cDBNumseq, cDBdoc, cDBProduto) 
         U_UMATA300(cDBProduto,cDBProduto,cDBLocal,cDBLocal)
    EndIf
    Return .t.
//Movimento com RE4 MENOR
ElseIf nCont==2 .and. nQTDRE4<nQTDDE4
    SDB->( dbGoTo(nRecDE4) )
    If cDBProduto == SDB->DB_PRODUTO .and. cDBNumseq==SDB->DB_NUMSEQ  .and. cDBdoc==SDB->DB_DOC .and. nQTDDE4==SDB->DB_QUANT
        Reclock("SDB",.F.)
        SDB->DB_QUANT  := nQTDRE4
        SDB->(Msunlock())
        U_UMATA300(SDB->DB_PRODUTO,SDB->DB_PRODUTO,SDB->DB_LOCAL,SDB->DB_LOCAL)
    EndIf
//Movimento com DE4 MENOR
ElseIf nCont==2 .and. nQTDDE4<nQTDRE4
    SDB->(dbGoTo(nRecRE4))
    If cDBProduto == SDB->DB_PRODUTO .and. cDBNumseq==SDB->DB_NUMSEQ  .and. cDBdoc==SDB->DB_DOC .and. nQTDRE4==SDB->DB_QUANT
        Reclock("SDB",.F.)
        SDB->DB_QUANT  := nQTDDE4
        SDB->(Msunlock())
        U_UMATA300(SDB->DB_PRODUTO,SDB->DB_PRODUTO,SDB->DB_LOCAL,SDB->DB_LOCAL)
    EndIf

//DE4 inexistente
ElseIf nCont==1 .and. nQTDDE4==0
    SD3->( dbGoTo(aRetSD3[2]) )
    If ALLTRIM(cDBProduto) == ALLTRIM(SD3->D3_COD) .and. cDBNumseq==SD3->D3_NUMSEQ  .and. ALLTRIM(cDBdoc)==ALLTRIM(SD3->D3_DOC) .and. nQTDRE4==SD3->D3_QUANT
        
        tmpDB_QUANT    := SD3->D3_QUANT  
        tmpDB_PRODUTO  := SD3->D3_COD
        tmpDB_LOCAL    := SD3->D3_LOCAL   
        tmpDB_DOC      := SD3->D3_DOC     
        tmpDB_DATA     := SD3->D3_EMISSAO
        tmpDB_NUMSEQ   := SD3->D3_NUMSEQ  
        tmpDB_LOTECTL  := SD3->D3_LOTECTL 
        tmpDB_LOCALIZ  := SD3->D3_LOCALIZ

        Reclock("SDB",.T.)
        SDB->DB_FILIAL  := "01"
        SDB->DB_TM      := "499"
        SDB->DB_SERVIC  := "499"
        SDB->DB_ATIVID  := "ZZZ"
        SDB->DB_ITEM    := "0001"
        SDB->DB_ORIGEM  := "SD3"
        SDB->DB_ATUEST  := "S"
        SDB->DB_TIPO    := "M"
        SDB->DB_STATUS  := "M"
        SDB->DB_QUANT   :=  tmpDB_QUANT
        SDB->DB_PRODUTO :=  tmpDB_PRODUTO     
        SDB->DB_LOCAL   :=  tmpDB_LOCAL   
        SDB->DB_DOC     :=  tmpDB_DOC     
        SDB->DB_DATA    :=  tmpDB_DATA  
        SDB->DB_NUMSEQ  :=  tmpDB_NUMSEQ  
        SDB->DB_LOTECTL :=  tmpDB_LOTECTL 
        SDB->DB_LOCALIZ :=  tmpDB_LOCALIZ

		SDB->( msUnlock() )
        U_UMATA300(SDB->DB_PRODUTO,SDB->DB_PRODUTO,SDB->DB_LOCAL,SDB->DB_LOCAL)
    EndIf
//RE4 inexistente
ElseIf nCont==1 .and. nQTDRE4==0
    SD3->( dbGoTo(aRetSD3[1]) )
    If ALLTRIM(cDBProduto) == ALLTRIM(SD3->D3_COD) .and. cDBNumseq==SD3->D3_NUMSEQ  .and. ALLTRIM(cDBdoc)==ALLTRIM(SD3->D3_DOC) .and. nQTDDE4==SD3->D3_QUANT
        
       
        tmpDB_QUANT    := SD3->D3_QUANT  
        tmpDB_PRODUTO  := SD3->D3_COD
        tmpDB_LOCAL    := SD3->D3_LOCAL   
        tmpDB_DOC      := SD3->D3_DOC     
        tmpDB_DATA     := SD3->D3_EMISSAO
        tmpDB_NUMSEQ   := SD3->D3_NUMSEQ  
        tmpDB_LOTECTL  := SD3->D3_LOTECTL 
        tmpDB_LOCALIZ  := SD3->D3_LOCALIZ

        Reclock("SDB",.T.)
        SDB->DB_FILIAL  := "01"
        SDB->DB_TM      := "999"
        SDB->DB_SERVIC  := "999"
        SDB->DB_ATIVID  := "ZZZ"
        SDB->DB_ITEM    := "0001"
        SDB->DB_ORIGEM  := "SD3"
        SDB->DB_ATUEST  := "S"
        SDB->DB_TIPO    := "M"
        SDB->DB_STATUS  := "M"
        SDB->DB_QUANT   :=  tmpDB_QUANT
        SDB->DB_PRODUTO :=  tmpDB_PRODUTO     
        SDB->DB_LOCAL   :=  tmpDB_LOCAL   
        SDB->DB_DOC     :=  tmpDB_DOC     
        SDB->DB_DATA    :=  tmpDB_DATA  
        SDB->DB_NUMSEQ  :=  tmpDB_NUMSEQ  
        SDB->DB_LOTECTL :=  tmpDB_LOTECTL 
        SDB->DB_LOCALIZ :=  tmpDB_LOCALIZ
		SDB->( msUnlock() )
        U_UMATA300(SDB->DB_PRODUTO,SDB->DB_PRODUTO,SDB->DB_LOCAL,SDB->DB_LOCAL)

    EndIf
EndIF

//corrige D3 X DB, QUANDO INCONSISTENTE
If FVLDD3DB(nRecDE4, aRetSD3[2], nRecRE4, aRetSD3[1], cDBNumseq, cDBdoc, cDBProduto) 
     U_UMATA300(cDBProduto,cDBProduto,cDBLocal,cDBLocal)
EndIf

nCont          := 0 
nQTDRE4        := 0
nQTDDE4        := 0
tmpDB_QUANT    := 0
tmpDB_PRODUTO  := ""
tmpDB_LOCAL    := ""
tmpDB_DOC      := ""
tmpDB_DATA     := ""
tmpDB_NUMSEQ   := ""
tmpDB_LOTECTL  := ""
tmpDB_LOCALIZ  := ""

Return .t.

//FUNCAO CORREÇÃO D5 X D3
Static function FVLDD3D5(nDE4SD5, nDE4SD3, nRE4SD5, nRE4SD3, _cSeq, _cdoc, _cProduto) 
Local nQTDD3   := 0
Local lretorno := .f.

//CORRIGE DE4 SD3 X SD5
SD3->( dbGoTo(nDE4SD3) )
If  SD3->D3_TM='499' .AND. ALLTRIM(_cSeq)=ALLTRIM(SD3->D3_NUMSEQ) .AND.  ALLTRIM(_cdoc)=ALLTRIM(SD3->D3_DOC) .AND.  ALLTRIM(_cProduto)=ALLTRIM(SD3->D3_COD)
    nQTDD3 := SD3->D3_QUANT
ENDIF

SD5->( dbGoTo(nDE4SD5) )
If nQTDD3 > 0 .and. nQTDD3 <> SD5->D5_QUANT .AND. SD5->D5_ORIGLAN='499' .AND. ALLTRIM(_cSeq)=ALLTRIM(SD5->D5_NUMSEQ) .AND.  ALLTRIM(_cdoc)=ALLTRIM(SD5->D5_DOC) .AND.  ALLTRIM(_cProduto)=ALLTRIM(SD5->D5_PRODUTO)
    Reclock("SD5",.F.)
    SD5->D5_QUANT := nQTDD3
    SD5->( MSUNLOCK() )
    lretorno := .t.
EndIf

nQTDD3 := 0

//CORRIGE RE4 SD3 X SD5
SD3->( dbGoTo(nRE4SD3) )
If  SD3->D3_TM='999' .AND. ALLTRIM(_cSeq)=ALLTRIM(SD3->D3_NUMSEQ) .AND.  ALLTRIM(_cdoc)=ALLTRIM(SD3->D3_DOC) .AND.  ALLTRIM(_cProduto)=ALLTRIM(SD3->D3_COD)
    nQTDD3 := SD3->D3_QUANT
EndIf

SD5->( dbGoTo(nRE4SD5) )
If nQTDD3 > 0 .and. nQTDD3 <> SD5->D5_QUANT .AND. SD5->D5_ORIGLAN='999' .AND. ALLTRIM(_cSeq)=ALLTRIM(SD5->D5_NUMSEQ) .AND.  ALLTRIM(_cdoc)=ALLTRIM(SD5->D5_DOC) .AND.  ALLTRIM(_cProduto)=ALLTRIM(SD5->D5_PRODUTO)
    Reclock("SD5",.F.)
    SD5->D5_QUANT := nQTDD3
    SD5->( MSUNLOCK() )
    lretorno := .t.
EndIf

Return lretorno 


//FUNCAO CORREÇÃO DB X D3
Static function FVLDD3DB(nDE4SDB, nDE4SD3, nRE4SDB, nRE4SD3, _cSeq, _cdoc, _cProduto) 
Local nQTDD3   := 0
Local lretorno := .f.

//CORRIGE DE4 SD3 X SDB
SD3->( dbGoTo(nDE4SD3) )
If  SD3->D3_TM='499' .AND. ALLTRIM(_cSeq)=ALLTRIM(SD3->D3_NUMSEQ) .AND.  ALLTRIM(_cdoc)=ALLTRIM(SD3->D3_DOC) .AND.  ALLTRIM(_cProduto)=ALLTRIM(SD3->D3_COD)
    nQTDD3 := SD3->D3_QUANT
ENDIF

SDB->( dbGoTo(nDE4SDB) )
If nQTDD3 > 0 .and. nQTDD3 <> SDB->DB_QUANT .AND. SDB->DB_TM='499' .AND. ALLTRIM(_cSeq)=ALLTRIM(SDB->DB_NUMSEQ) .AND.  ALLTRIM(_cdoc)=ALLTRIM(SDB->DB_DOC) .AND.  ALLTRIM(_cProduto)=ALLTRIM(SDB->DB_PRODUTO)
    Reclock("SDB",.F.)
    SDB->DB_QUANT := nQTDD3
    SDB->( MSUNLOCK() )
    lretorno := .t.
EndIf

nQTDD3 := 0

//CORRIGE RE4 SD3 X SDB
SD3->( dbGoTo(nRE4SD3) )
If  SD3->D3_TM='999' .AND. ALLTRIM(_cSeq)=ALLTRIM(SD3->D3_NUMSEQ) .AND.  ALLTRIM(_cdoc)=ALLTRIM(SD3->D3_DOC) .AND.  ALLTRIM(_cProduto)=ALLTRIM(SD3->D3_COD)
    nQTDD3 := SD3->D3_QUANT
EndIf

SDB->( dbGoTo(nRE4SDB) )
If nQTDD3 > 0 .and. nQTDD3 <> SDB->DB_QUANT .AND. SDB->DB_TM='999' .AND. ALLTRIM(_cSeq)=ALLTRIM(SDB->DB_NUMSEQ) .AND.  ALLTRIM(_cdoc)=ALLTRIM(SDB->DB_DOC) .AND.  ALLTRIM(_cProduto)=ALLTRIM(SDB->DB_PRODUTO)
    Reclock("SDB",.F.)
    SDB->DB_QUANT := nQTDD3
    SDB->( MSUNLOCK() )
    lretorno := .t.
EndIf

Return lretorno



//cria SDB A PARTIR SD3
Static function FCREASDB(_cProduto, _cNumseq) 
Local lretorno := .t.

SD3->( dbGoTo(aRetSD3[2]) )
If ALLTRIM(_cProduto) == ALLTRIM(SD3->D3_COD) .and. _cNumseq==SD3->D3_NUMSEQ  .and. "DE4"==ALLTRIM(SD3->D3_CF)        
    Reclock("SDB",.T.)
    SDB->DB_FILIAL  := "01"
    SDB->DB_TM      := "499"
    SDB->DB_SERVIC  := "499"
    SDB->DB_ATIVID  := "ZZZ"
    SDB->DB_ITEM    := "0001"
    SDB->DB_ORIGEM  := "SD3"
    SDB->DB_ATUEST  := "S"
    SDB->DB_TIPO    := "M"
    SDB->DB_STATUS  := "M"
    SDB->DB_QUANT   :=  SD3->D3_QUANT 
    SDB->DB_PRODUTO :=  SD3->D3_COD     
    SDB->DB_LOCAL   :=  SD3->D3_LOCAL   
    SDB->DB_DOC     :=  SD3->D3_DOC     
    SDB->DB_DATA    :=  SD3->D3_EMISSAO  
    SDB->DB_NUMSEQ  :=  SD3->D3_NUMSEQ  
    SDB->DB_LOTECTL :=  SD3->D3_LOTECTL 
    SDB->DB_LOCALIZ :=  SD3->D3_LOCALIZ
	SDB->( msUnlock() )
else
    lretorno := .f.
Endif

SD3->( dbGoTo(aRetSD3[1]) )
If ALLTRIM(_cProduto) == ALLTRIM(SD3->D3_COD) .and. _cNumseq==SD3->D3_NUMSEQ  .and. "RE4"==ALLTRIM(SD3->D3_CF)        
    Reclock("SDB",.T.)
    SDB->DB_FILIAL  := "01"
    SDB->DB_TM      := "999"
    SDB->DB_SERVIC  := "999"
    SDB->DB_ATIVID  := "ZZZ"
    SDB->DB_ITEM    := "0001"
    SDB->DB_ORIGEM  := "SD3"
    SDB->DB_ATUEST  := "S"
    SDB->DB_TIPO    := "M"
    SDB->DB_STATUS  := "M"
    SDB->DB_QUANT   :=  SD3->D3_QUANT 
    SDB->DB_PRODUTO :=  SD3->D3_COD     
    SDB->DB_LOCAL   :=  SD3->D3_LOCAL   
    SDB->DB_DOC     :=  SD3->D3_DOC     
    SDB->DB_DATA    :=  SD3->D3_EMISSAO  
    SDB->DB_NUMSEQ  :=  SD3->D3_NUMSEQ  
    SDB->DB_LOTECTL :=  SD3->D3_LOTECTL 
    SDB->DB_LOCALIZ :=  SD3->D3_LOCALIZ
	SDB->( msUnlock() )
else
    lretorno := .f.
Endif

If lretorno
    U_UMATA300(SD3->D3_COD, SD3->D3_COD, SD3->D3_LOCAL, SD3->D3_LOCAL )
EndIf

Return lretorno




//cria SD5 A PARTIR SD3
Static function FCREASD5(_cProduto, _cNumseq) 
Local lretorno := .t.

SD3->( dbGoTo(aRetSD3[2]) )
If ALLTRIM(_cProduto) == ALLTRIM(SD3->D3_COD) .and. _cNumseq==SD3->D3_NUMSEQ  .and. "DE4"==ALLTRIM(SD3->D3_CF)        
    Reclock("SD5",.T.)
    SD5->D5_FILIAL  := "01"
    SD5->D5_ORIGLAN := "499"
    SD5->D5_QUANT   :=  SD3->D3_QUANT
    SD5->D5_PRODUTO :=  SD3->D3_COD
    SD5->D5_OP      :=  SD3->D3_OP      
    SD5->D5_LOCAL   :=  SD3->D3_LOCAL   
    SD5->D5_DOC     :=  SD3->D3_DOC     
    SD5->D5_DATA    :=  SD3->D3_EMISSAO
    SD5->D5_NUMSEQ  :=  SD3->D3_NUMSEQ  
    SD5->D5_LOTECTL :=  SD3->D3_LOTECTL 
    SD5->D5_DTVALID :=  SD3->D3_DTVALID 
	SD5->( msUnlock() )
else
    lretorno := .f.
Endif

SD3->( dbGoTo(aRetSD3[1]) )
If ALLTRIM(_cProduto) == ALLTRIM(SD3->D3_COD) .and. _cNumseq==SD3->D3_NUMSEQ  .and. "RE4"==ALLTRIM(SD3->D3_CF)        
    Reclock("SD5",.T.)
    SD5->D5_FILIAL  := "01"
    SD5->D5_ORIGLAN := "999"
    SD5->D5_QUANT   :=  SD3->D3_QUANT
    SD5->D5_PRODUTO :=  SD3->D3_COD
    SD5->D5_OP      :=  SD3->D3_OP      
    SD5->D5_LOCAL   :=  SD3->D3_LOCAL   
    SD5->D5_DOC     :=  SD3->D3_DOC     
    SD5->D5_DATA    :=  SD3->D3_EMISSAO
    SD5->D5_NUMSEQ  :=  SD3->D3_NUMSEQ  
    SD5->D5_LOTECTL :=  SD3->D3_LOTECTL 
    SD5->D5_DTVALID :=  SD3->D3_DTVALID 
	SD5->( msUnlock() )
else
    lretorno := .f.
Endif

If lretorno
    U_UMATA300(SD3->D3_COD, SD3->D3_COD, SD3->D3_LOCAL, SD3->D3_LOCAL )
EndIf

Return lretorno