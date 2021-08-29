#include "rwmake.ch"        

User function PLR()

Local cSRASqlName  := RetSqlName("SRA") 
Local nSRAOrder    := RetOrder( "SRA" , "RA_FILIAL+RA_MAT" )
Local cFil         := SRA->RA_FILIAL
Local cMat         := SRA->RA_MAT
Local nVLPLR		 := 0

////////////////////////////////////
//  BUSCA VALOR FEVEREIRO 210     //
////////////////////////////////////                                    

SetPrvt("NANO,NMES,NVAL210,CANOMES,CFILANT,CMATANT")
nAno    := Year( dDataBase )   
nMes    := Month( dDataBase )      
nMes    := If( Month( dDataBase ) == 8 , 2 , 7 )

nVal210 := 0.00
cAnoMes := Str(nAno,4) + StrZero(nMes,2)

dbSelectArea("SRD")
dbSetOrder( 1 )
dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + cAnoMes + "210",.T. )
cFilAnt := SRA->RA_FILIAL
cMatAnt := SRA->RA_MAT

Do While SRD->RD_FILIAL+SRD->RD_MAT == cFilAnt+cMatAnt .And. !Eof()

   If SRD->RD_PD #"210"
	  dbSkip()
	  Loop
   EndIf
   nVal210 := nVal210 + SRD->RD_VALOR
   dbSkip()   
  
EndDo

nVal210 := nVal210


////////////////////////////////////
//  BUSCA VALOR FEVEREIRO 001     //
////////////////////////////////////                                    
    

SetPrvt("NVAL001")
nAno    := Year( dDataBase ) 
nMes    := Month( dDataBase )      
nMes    := If( Month( dDataBase ) == 8 , 2 , 7 )

nVal001 := 0.00
cAnoMes := Str(nAno,4) + StrZero(nMes,2)


dbSelectArea("SRD")
dbSetOrder( 1 )
dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + cAnoMes + "001",.T. )
cFilAnt := SRA->RA_FILIAL
cMatAnt := SRA->RA_MAT

Do While SRD->RD_FILIAL+SRD->RD_MAT == cFilAnt+cMatAnt .And. !Eof()

   If SRD->RD_PD #"001"
	  dbSkip()
	  Loop
   EndIf
   nVal001 := nVal001 + SRD->RD_VALOR
   dbSkip()   

EndDo

nVal001 := nVal001  

////////////////////////////////////
//  BUSCA VALOR FEVEREIRO 510     //
////////////////////////////////////                                    
    

SetPrvt("NVAL510")
nAno    := Year( dDataBase ) 
nMes    := Month( dDataBase )      
nMes    := If( Month( dDataBase ) == 8 , 2 , 7 )

nVal510 := 0.00
cAnoMes := Str(nAno,4) + StrZero(nMes,2)


dbSelectArea("SRD")
dbSetOrder( 1 )
dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + cAnoMes + "510",.T. )
cFilAnt := SRA->RA_FILIAL
cMatAnt := SRA->RA_MAT

Do While SRD->RD_FILIAL+SRD->RD_MAT == cFilAnt+cMatAnt .And. !Eof()

   If SRD->RD_PD #"510"
	  dbSkip()
	  Loop
   EndIf
   nVal510 := nVal510 + SRD->RD_VALOR
   dbSkip()   

EndDo

nVal510 := nVal510  

////////////////////////////////////
// 210 - PLR                      //
////////////////////////////////////

dbSelectArea("RGB")
dbSetOrder(1)
dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + "210" + cAnoMes,.T. )

nVlr210 := 0

Do While RGB->RGB_FILIAL+RGB->RGB_MAT == cFilAnt+cMatAnt .And. !Eof()
    
   If RGB->RGB_PD #"210"
	dbSkip()
	Loop
   EndIf 
   nVlr210   := RGB->RGB_VALOR 
   dbSkip()
   
nVlr210 := nVlr210  
     
EndDo

nVLPLR := (nVal210-nVal001) + nVlr210

////////////////////////////////////
//  COMPOE IMPOSTO DE RENDA       //
////////////////////////////////////                                    

SetPrvt("nISE,nATE1,nATE2,nATE3,nATE4,DE1,nDE2,nDE3,nDE4,nALIQ1,nALIQ2,nALIQ3,nALIQ4")

nISE   := 6677.55  //ISENTO 
nDE1   := 6677.56  //7,5           
nATE1  := 9922.28  //7,5
nDE2   := 9922.29  //15         
nATE2  := 13167.00 //15
nDE3   := 13167.01 //22,5          
nATE3  :=16380.38  //22,5
nDE4   :=16380.39   //27,5      
nATE4  :=99999.99  //27,5  
 
nDed1 :=  500.82  // VALOR 1 
nDed2 :=  1244.99 // VALOR 2  
nDed3 :=  2232.51 // VALOR 3 
nDed4 :=  3051.53 // VALOR4 

nALIQ1  := 07.50
nALIQ2  := 15.00
nALIQ3  := 22.50 
nALIQ4  := 27.50
   
IF nVLPLR <= nISE  
   nVLIR  := 0.00
EndIf

IF nVLPLR <= nATE1
   nVLIR := ((nVLPLR/100)*(nALIQ1)) -nDed1   
EndIf

IF nVLPLR > nATE1  .AND. nVLPLR <= nATE2
   nVLIR := ((nVLPLR/100)*(nALIQ2)) - nDed2
EndIf

IF nVLPLR > nATE2  .AND. nVLPLR <= nATE3
   nVLIR := ((nVLPLR/100)*(nALIQ3))- nDed3 
EndIf

IF nVLPLR > nATE3
   nVLIR := ((nVLPLR/100)*(nALIQ4)) - nDed4
EndIf   

nVlrIR := 0
nVlrIR := nVLIR - nVal510
   
If nVlPLR > 0.00 .and. nVlrIR > 0.00 .and. SRA->RA_MAT <> '001037
'
       fGeraVerba("510",(nVlrIR),,,,,"I",,,DDATA_PGTO,,,,)   
EndIf  

If  nVLIR >= 0.00
    fGeraVerba("725",( nVlPLR ),,,,,"I",,,DDATA_PGTO,,,,)
EndIf        