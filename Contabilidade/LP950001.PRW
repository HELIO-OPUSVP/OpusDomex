#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LP65004D     ºAutor  ³Jonas Pereira   º Data ³  16/04/2021   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Usado para retorno do CUSTO DE IMPORTACAO LP 950001        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LPSIMP(cTipo)
Local _Retorno  := 0
Local nRecAtu   := 0
Local cF1_HAWB  := ""
Local aRec      := {}
Local cFornece  := ""
Local cLoja     := ""
Local lEntre    := .t.
Local aVldEntr  := {}
Local x

//F1_XDTLAN FLAG DE CONTABILIZACAO DA BAIXA DO CUSTO DE IMPORTACAO
//WD_XDTLAN FLAG DE CONTABILIZACAO DAS DESPESAS 
//W9_XDTLAN FLAG DE CONTABILIZACAO DE PROCESSO SEM COBERTURA CAMBIAL
//W6_XDTSEG FLAG DE CONTABILIZACAO SEGURO
//W6_XDTFRE FLAG DE CONTABILIZACAO QUANDO HÁ PROVISAO DE FRETE INTERNACIONAL
//W6_XDTDIF FLAG DE CONTABILIZACAO QUANDO HÁ CONTABILIZACAO DIFERENCIAL DE FRETE


If cTipo = "980001" // BX CUSTO DE IMPORTACAO
    If !Empty(SF1->F1_HAWB) .AND. Empty(SF1->F1_XDTLAN)
        nRecAtu  := SF1->(RECNO())
        cF1_HAWB := SF1->F1_HAWB
        cFornece := SF1->F1_FORNECE 
        cLoja    := SF1->F1_LOJA
        dDtIni   := FirstDate(SF1->F1_DTDIGIT)
        dDtFim   := LastDate(SF1->F1_DTDIGIT)

        SF1->(dbSetOrder(10))
        If SF1->(dbseek(xFilial("SF1")+cF1_HAWB))
            while SF1->(!EOF()) .AND. SF1->F1_HAWB==cF1_HAWB
                If Empty(SF1->F1_XDTLAN) .AND. cFornece == SF1->F1_FORNECE .AND.  cLoja == SF1->F1_LOJA .and. SF1->F1_DTDIGIT >= dDtIni .AND. SF1->F1_DTDIGIT <= dDtFim
                    _Retorno += SF1->F1_VALBRUT-SF1->F1_FOB_R 
                    AADD(aRec, {SF1->(RECNO())} )
                EndIF
                SF1->(dbskip())    
            end
        EndIf

        SF1->(dbSetOrder(1))

        For x := 1 to len(aRec)
            SF1->(DBGOTO(aRec[x][1]))
            If SF1->(RECNO())==aRec[x][1]
                //gravar flag SF1
                Reclock("SF1",.F.)
                SF1->F1_XDTLAN := DDATABASE
                SF1->(MSUNLOCK())
            EndIf
        Next x 
        SF1->(DBGOTO(nRecAtu))
    EndIf    
EndIf


/*
If !Empty(SF1->F1_HAWB)
	If SW6->(dbseek(xFilial("SW6")+SF1->F1_HAWB))
        If !EMPTY(SW6->W6_XNFLAN) 
            If SW6->W6_XNFLAN != SF1->F1_DOC
                _Retorno := 0
                
                //If cTipo = "980007" // Dif Frete Interna                    
	                    //If SWD->(dbseek(xFilial("SWD")+SF1->F1_HAWB+"718"))    
                          //  If WD_DIFFREINT != VAZIO                                    
                        //        _Retorno :=  (SW6->W6_VLFRECC * SW6->W6_TX_FRET )  - SWD->WD_VALOR_R     
                      //          GRAVAFLAG                       
                    //        eNDIF
                  //      EndIf                    
                //EndIf
                

                Return _Retorno
            EndIf
        Else
            Reclock("SW6",.F.)
            SW6->W6_XNFLAN := SF1->F1_DOC
            SW6->(MSUNLOCK())
        EndIf
    EndIf
EndIf
*/


If cTipo = "980002" // SEGURO DE ESTOCAGEM
    If !Empty(SF1->F1_HAWB)
	    If SW6->(dbseek(xFilial("SW6")+SF1->F1_HAWB))
            If Empty(SW6->W6_XDTSEG)
                _Retorno := SW6->W6_VLSEGMN
                Reclock("SW6",.F.)
                SW6->W6_XDTSEG := DDATABASE 
                SW6->(MSUNLOCK())                
            EndIf
        EndIf
    EndIf
EndIf


If cTipo = "980003" // Taxa de Embarque
    If !Empty(SF1->F1_HAWB)
	    If SWD->(dbseek(xFilial("SW6")+SF1->F1_HAWB+"333"))
            If Empty(SWD->WD_XDTLAN)
                _Retorno := SWD->WD_VALOR_R
                Reclock("SWD",.F.)
                SWD->WD_XDTLAN := DDATABASE
                SWD->(MSUNLOCK())
            EndIf
        EndIf
    EndIf
EndIf


If cTipo = "980004" // Armazenagem
    If !Empty(SF1->F1_HAWB)
	    If SWD->(dbseek(xFilial("SW6")+SF1->F1_HAWB+"416"))
            If Empty(SWD->WD_XDTLAN)
                _Retorno := SWD->WD_VALOR_R
                Reclock("SWD",.F.)
                SWD->WD_XDTLAN := DDATABASE
                SWD->(MSUNLOCK())
            EndIf
        EndIf
    EndIf
EndIf



If cTipo = "980005" // Emissao LI
    If !Empty(SF1->F1_HAWB)
	    If SWD->(dbseek(xFilial("SW6")+SF1->F1_HAWB+"721"))
            If Empty(SWD->WD_XDTLAN)
                _Retorno := SWD->WD_VALOR_R            
                Reclock("SWD",.F.)
                SWD->WD_XDTLAN := DDATABASE
                SWD->(MSUNLOCK())
            EndIf
        EndIf
    EndIf
EndIf



If cTipo = "980006" // Valor Transportadora Internacional
    If !Empty(SF1->F1_HAWB)
        If SW6->(dbseek(xFilial("SW6")+SF1->F1_HAWB))  

             //Verifica se é entreposto, caso sim, só gera se for a primeira NF
             aVldEntr := U_fVldEntr(SF1->F1_HAWB)
             If aVldEntr[1][1] 
                lEntre := .f.
                //If aVldEntr[1][2] != SW6->(RECNO())
                //    lEntre := .f.
                //EndIf
             EndIf   

	        If SWD->(dbseek(xFilial("SWD")+SF1->F1_HAWB+"718")) .and. lEntre
                //verifica se ja foi provisionado frete, caso sim nao gera lancamento
                If !Empty(SW6->W6_XDTFRE) .and. Empty(SWD->WD_XDTLAN)
                    _Retorno := 0
                   // If !'JONAS' $ Upper(GetEnvServer())
                        Reclock("SWD",.F.)
                        SWD->WD_XDTLAN := SW6->W6_XDTFRE
                        SWD->(MSUNLOCK())
                    //EndIf
                ElseIf SA2->(dbseek(xFilial("SA2")+SWD->WD_FORN+SWD->WD_LOJA))   
                    If Empty(SWD->WD_XDTLAN)
                        _Retorno := SWD->WD_VALOR_R   
                     // If !'JONAS' $ Upper(GetEnvServer())   
                        Reclock("SWD",.F.)
                        SWD->WD_XDTLAN := DDATABASE
                        SWD->(MSUNLOCK())               
                    //EndIF
                    EndIF
                EndIf       
            Elseif lEntre
                //QUANDO FALTA FRETE INTERNACIONAL FAZ PROVISAO                                        
                     If SY4->(dbseek(xFilial("SY4")+SW6->W6_AGENTE)) 
                        If SA2->(dbseek(xFilial("SA2")+SY4->Y4_FORN+SY4->Y4_LOJA))   
                            If empty(SW6->W6_XDTFRE)
                                _Retorno :=  SW6->W6_VLFRECC * SW6->W6_TX_FRET    
                                //FLAG DE CONTABILIZACAO FALTA FRETE     
                            //If !'JONAS' $ Upper(GetEnvServer())
                                Reclock("SW6",.F.)
                                SW6->W6_XDTFRE := DDATABASE 
                                SW6->(MSUNLOCK())                
                            EndIf
                        EndIf 
                    EndIf            
            EndIf
        EndIF
    EndIf
EndIf

/*
If cTipo = "980012" // Valor Transportadora Internacional
    If !Empty(SF1->F1_HAWB)
	    If SWD->(dbseek(xFilial("SWD")+SF1->F1_HAWB+"731"))
            If SA2->(dbseek(xFilial("SA2")+SWD->WD_FORN+SWD->WD_LOJA))   
                _Retorno := SWD->WD_VALOR_R                   
            EndIf             
        EndIf
    EndIf
EndIf


If cTipo = "980013" // Valor Transportadora Internacional
    If !Empty(SF1->F1_HAWB)
	    If SWD->(dbseek(xFilial("SWD")+SF1->F1_HAWB+"732"))
            If SA2->(dbseek(xFilial("SA2")+SWD->WD_FORN+SWD->WD_LOJA))   
                _Retorno := SWD->WD_VALOR_R                   
            EndIf             
        EndIf
    EndIf
EndIf

*/


If cTipo = "980007" // Dif Frete Interna
    If !Empty(SF1->F1_HAWB)
	    If SWD->(dbseek(xFilial("SWD")+SF1->F1_HAWB+"718"))         
            //Verifica se é entreposto, caso sim, só gera se for a primeira NF
             aVldEntr := U_fVldEntr(SF1->F1_HAWB)
             If aVldEntr[1][1] 
                If aVldEntr[1][2] != SW6->(RECNO())
                    lEntre := .f.
                EndIf
             EndIf      
            If SW6->(dbseek(xFilial("SW6")+SF1->F1_HAWB)) .and. lEntre   
                If Empty(SW6->W6_XDTDIF)   //.AND.  !Empty(SW6->W6_XDTFRE)   
                    _Retorno :=  (SW6->W6_VLFRECC * SW6->W6_TX_FRET )  - SWD->WD_VALOR_R
                    iF _Retorno < 0
                        _Retorno := _Retorno * -1
                    end
                   // If !'JONAS' $ Upper(GetEnvServer())
                        Reclock("SW6",.F.)
                        SW6->W6_XDTDIF := DDATABASE
                        SW6->(MSUNLOCK())
                    //EndIf
                EndIf
            EndiF
        EndIf
    EndIf
EndIf




If cTipo = "980008" // Nacionalização
    If !Empty(SF1->F1_HAWB)
	    If SWD->(dbseek(xFilial("SWD")+SF1->F1_HAWB+"ZZZ"))        
            If Empty(SWD->WD_XDTLAN)               
                _Retorno := SWD->WD_VALOR_R  
                Reclock("SWD",.F.)
                SWD->WD_XDTLAN := DDATABASE
                SWD->(MSUNLOCK())
            EndIf
        EndIf
    EndIf
EndIf



If cTipo = "980009" // Despesa do Servico Despachante
    If !Empty(SF1->F1_HAWB)
	    If SWD->(dbseek(xFilial("SWD")+SF1->F1_HAWB+"404"))          
            If Empty(SWD->WD_XDTLAN)             
                _Retorno := SWD->WD_VALOR_R  
                Reclock("SWD",.F.)
                SWD->WD_XDTLAN := DDATABASE
                SWD->(MSUNLOCK())
            EndIF
        EndIf
    EndIf
EndIf



If cTipo = "980010" // IR do Servico
    If !Empty(SF1->F1_HAWB)
	    If SWD->(dbseek(xFilial("SWD")+SF1->F1_HAWB+"626"))      
            If Empty(SWD->WD_XDTLAN)                 
                _Retorno := SWD->WD_VALOR_R  
                Reclock("SWD",.F.)
                SWD->WD_XDTLAN := DDATABASE
                SWD->(MSUNLOCK())
            EndIF
        EndIf
    EndIf
EndIf


If cTipo = "980011" // PCC do Servico
    If !Empty(SF1->F1_HAWB)
	    If SWD->(dbseek(xFilial("SWD")+SF1->F1_HAWB+"623"))        
            If Empty(SWD->WD_XDTLAN)               
                _Retorno := SWD->WD_VALOR_R  
                Reclock("SWD",.F.)
                SWD->WD_XDTLAN := DDATABASE
                SWD->(MSUNLOCK())
            EndIf
        EndIf
    EndIf
EndIf



If cTipo = "980012" // Despachante
    If !Empty(SF1->F1_HAWB)
	    If SWD->(dbseek(xFilial("SW6")+SF1->F1_HAWB+"406"))
            If Empty(SWD->WD_XDTLAN)
                _Retorno := SWD->WD_VALOR_R
                SA2->(dbseek(xFilial("SA2")+SWD->WD_FORN+SWD->WD_LOJA))   
                Reclock("SWD",.F.)
                SWD->WD_XDTLAN := DDATABASE
                SWD->(MSUNLOCK())
            EndIf
        EndIf
    EndIf
EndIf



If cTipo = "980013" // Capatazia
    If !Empty(SF1->F1_HAWB)
	    If SWD->(dbseek(xFilial("SW6")+SF1->F1_HAWB+"431"))
            If Empty(SWD->WD_XDTLAN)
                _Retorno := SWD->WD_VALOR_R
                Reclock("SWD",.F.)
                SWD->WD_XDTLAN := DDATABASE
                SWD->(MSUNLOCK())
            EndIf
        EndIf
    EndIf
EndIf



/*
If cTipo = "980008" // Nacionalização
    If !Empty(SF1->F1_HAWB)
	    If SWD->(dbseek(xFilial("SWD")+SF1->F1_HAWB+"ZZZ"))                       
            _Retorno := SWD->WD_VALOR_R  
        EndIf
    EndIf
EndIf
*/

If cTipo = "981001" // valor inicial do Estoque em Transito
    _Retorno := nVLPROCE        
EndIf

If cTipo = "981002" // Valor da baixa do Estoque em Transito
    _Retorno := nVLBAIXA       
EndIf

If cTipo = "981003" // variacao cambial do Estoque em Transito
    _Retorno := IF(cTPVAR=='POS',nVAR_CAMB,nVAR_CAMB*-1)        
EndIf

If cTipo = "982001" // SEM COBERTURA CAMBIAL
    If !Empty(cHAWB)
        aVldEntr := U_fVldEntr(cHAWB)
        //entreposto nao gera cobertura cambial
        If !aVldEntr[1][1] 
            _Retorno := nValor           
        EndIf
    EndIf
EndIf




Return _Retorno


//Conta crediro ou debito da diferenca de frete
User Function ConDifFr(cCreDeb)

cConta := ""

If !Empty(SF1->F1_HAWB)
	If SWD->(dbseek(xFilial("SWD")+SF1->F1_HAWB+"718"))            
        If SW6->(dbseek(xFilial("SW6")+SF1->F1_HAWB))                        
                _Retorno :=  (SW6->W6_VLFRECC * SW6->W6_TX_FRET )  - SWD->WD_VALOR_R                    
                    iF _Retorno < 0
                        If cCreDeb == "D" 
                            cConta := U_fConEIC(SF1->F1_HAWB)                                   
                        ElseIf cCreDeb == "C" 
                            If MONTH(SWD->WD_DES_ADI) == MONTH(SW6->W6_DT_NF) .AND. YEAR(SWD->WD_DES_ADI) == YEAR(SW6->W6_DT_NF)
                                cConta := "110277005300" 
                            Else                            
                                cConta := "210201000000"      //210201000000   110277005300                                                                                                                                                                          
                            EndIf
                        EndIf                                                                                                                                                                                        
                    Else
                        If cCreDeb == "D" 
                            If MONTH(SWD->WD_DES_ADI) == MONTH(SW6->W6_DT_NF) .AND. YEAR(SWD->WD_DES_ADI) == YEAR(SW6->W6_DT_NF)
                                cConta := "110277005300" 
                            Else                            
                                cConta := "210201000000"      //210201000000   110277005300                                                                                                                                                                          
                            EndIf                            
                        ElseiF cCreDeb == "C" 
                            cConta := U_fConEIC(SF1->F1_HAWB)                                                                                                                                                                                           
                        EndIf   
                    endIf                    
                EndIf        
    EndIf
EndIf


Return cConta



User Function fItemAge()
Local cItem := ""

If !Empty(SF1->F1_HAWB)
    If SW6->(dbseek(xFilial("SW6")+SF1->F1_HAWB))  
        If SWD->(dbseek(xFilial("SWD")+SF1->F1_HAWB+"718"))
            If SA2->(dbseek(xFilial("SA2")+SWD->WD_FORN+SWD->WD_LOJA))                       
               cItem := "F" + SA2->A2_COD + SA2->A2_lOJA                     
            EndIf       
        Else
            //QUANDO FALTA FRETE INTERNACIONAL FAZ PROVISAO                                        
            If SY4->(dbseek(xFilial("SY4")+SW6->W6_AGENTE)) 
                If SA2->(dbseek(xFilial("SA2")+SY4->Y4_FORN+SY4->Y4_LOJA))   
                    cItem := "F" + SA2->A2_COD + SA2->A2_lOJA  
                EndIf 
            EndIf            
        EndIf
    EndIF
EndIf

//If CT5->CT5_LANPAD=''

Return cItem


//ITEM CONTABIL DESPESA
//REGRA DE CONTA CONTABIL DO FRETE --CREDITO E DEBITO
//FLAG CONTAZILIZACAO FALTA DE FRETE INTERNACIONAL
//CAPATAZIA
//conta CREDITO COBERTURA CAMBIAL
//ITEM CONTABIL COBERTURA CAMBIAL
//HISTORICO DOS LANCAMENTOS


//item contabil debito e credito estoque em transito
//separacao baixa custo por fornecedor
