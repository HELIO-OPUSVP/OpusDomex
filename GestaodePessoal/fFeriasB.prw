#INCLUDE "PROTHEUS.CH"  
User Function fFeriasB(aPd,aCodfol,nMedFerv,nMedFerp,nDFerInd,nMedDobra)

Local nAvosAux	:= 0.00
Local nIdFerAux	:= 0.00
Local nIdMedAux	:= 0.00
Local nFerVep  	:= 0.00
Local nFerVev  	:= 0.00
LocaL nFerInd  	:= 0.00
Local nPerc    	:= 0.00
Local nValTerc 	:= 0.00
Local nFerMedV 	:= 0.00
Local nFerMedP 	:= 0.00
Local nFerMedI 	:= 0.00
Local nFerDev  	:= 0.00	
Local nDFerAvi	:= 0.00
Local nHabilesFunc	:=	0
Local nTotalAno :=	0
Local nFerDobra	:= 0.00
Local nFalPro	:= 0.00
Local lCalDInd	:= ( ( Type( "nDFerIndP" ) == "N" ) .And. nDFerIndP > 0 )
Local lNoPerdPer:= .T.
Local lIdDobro	:= .T.             

Local nFerDAux  := 0
Local nFerSFal	:= 0
Local nFerVAux  := 0
Local nFerMAux  := 0
Local nDobrAux  := 0
Local nDFerAnt  := SRF->RF_DFERANT  
Local nDiasVenc := M->RG_DFERVEN  
Local nCont     := 0
Local nPos		:= 0
Local nPosFal	:= 0
Local nTipFal	:= 0
Local cSeq

If cPaisLoc == "BRA"	

	If lDferAvi .and. aCodFol[230,1] = Space(3)
		MsgAlert("Verba de Ferias s Av Previo Indenizado, id 230,obrigatoria")
	Else  		
		IF aCodFol[230,1] = Space(3) //--Se Nao Existir Verba de Ferias /s Av.Previo Indenizado Zerar Dias Indenizados
			nDFerInd := 0
		EndIF
	EndIf	
	
	//Se houve afastamento R - X - W, altera os periodos no aPerFerias
	If Type("aPerFerias") != "U" .and. !Empty(aPerFerias) .and. ( nPos := aScan(aPerFerias, {|x| x[6] > 0}) ) > 0
		AjPerRXW(nPos)
	Endif
   	
   	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Utiliza a variavel/mnmonico nOldPeric	(Alteracao Conceitual)³
	³ Agora, essa variavel tambem sera utilizada para preservar o ³
	³ valor integral da periculosidade (30 dias) para posterior u-³
	³ so no calculo do aviso previo indenizado (fCalAvi).		  ³	
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/  
	lRecalculo 	:= iif(Type( "lRecalculo" ) <> "U", lRecalculo, .F.)

	IF !lRecalculo
		IF SRA->(RA_PERICUL== 999.99) .and.  ( PosSrv( aCodfol[036,1], SRA->RA_FILIAL, "RV_INCORP" ) <> "S" )
		    nOldPeric:= nPeric
	    Endif 
    Endif
    		
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Proporcionais                                              ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	IF M->RG_DFERPRO > 0 .and. aIncRes[4] = "S" .and. aCodfol[87,1] # space(3)

		nFervep := (((SalMes + nAdtServ + nPeric + nInsal ) / 30) * M->RG_DFERPRO) + nGComisFp+nGTarefFp

		//--Verifica se a media das ferias proporcionais e separada das ferias atraves do Identificador 249
		IF aCodFol[249,1] == Space(03)
		 	
		 	If !lDFerAvi //Nao tinha campo ferias sobre aviso.

				If cMedDir == "S" // Calcular valor da media correspondente ao aviso
					nFerMedI := (nMedFerp / (M->RG_DFERPRO-nDFerInd)) * nDFerInd
				EndIf	

				nFerVep += nMedFerp + nFerMedI   					//--Somar as medias no valor de ferias
				nFerInd := (nFerVep / M->RG_DFERPRO) * nDFerInd 	//--Calcula valor indenizado
				nFerVep -= nFerInd 		   							//--Abate valor indenizado das ferias proporcionais			
			
				If nDFerInd > M->RG_DFERPRO 	//--Para qdo. dias de aviso for maior que dias de ferias prop., garantir o valor das ferias prop. zerado
					nFerVep := Max(nFerVep,0)
				EndIf
			
				IF aScan(aPd,{ |X| X[1] = aCodfol[087,1] .and. X[9] # "D" } ) = 0
					fMatriz(aCodfol[087,1],Round(nFervep,2),IF ( cRefFer="D",nDferave-nDferInd,Int((nDferave-nDFerInd)/aTabFer[4])+0.12), , ,"V","R")
				EndIF
			       
			Else
				//Soma as medias no valor de ferias
			
				nFerVep += (nMedFerp / (M->RG_DFERPRO + M->RG_DFERAVI) ) * M->RG_DFERPRO
			
				IF aScan(aPd,{ |X| X[1] = aCodfol[087,1] .and. X[9] # "D" } ) = 0
					fMatriz(aCodfol[087,1],Round(nFervep,2),IF( cRefFer="D",nDferave,Int(nDferave/aTabFer[4])+0.12), , ,"V","R")
				EndIF

			EndIf
					
		Else //-- Calcula Media separada		

		 	If !lDFerAvi //Nao tinha campo ferias sobre aviso.

				nFerMedP += nMedFerp 

				IF cMedDir == "S" 
					nFerMedI := (nFerMedP / (M->RG_DFERPRO-nDFerInd)) * nDFerInd
				Else
					nFerMedI := (nFerMedP / M->RG_DFERPRO) * nDFerInd
					nFerMedP -= nFerMedI
				Endif
			
				//--Calcula avos Indenizado separado
				nFerInd := (nFerVep / M->RG_DFERPRO) * nDFerInd
				nFerVep -= nFerInd

				//--Para qdo. dias de aviso for maior que dias de ferias prop., garantir o valor das ferias prop. zerado
				If nDFerInd > M->RG_DFERPRO
					nFerVep := Max(nFerVep,0)
				EndIf
			
				IF aScan(aPd,{ |X| X[1] = aCodfol[087,1] .and. X[9] # "D" } ) = 0
					fMatriz(aCodfol[087,1],Round(nFervep,2),IF ( cRefFer="D",nDferave-nDFerInd,Int((nDferave-nDFerInd)/aTabFer[4])+0.12), , ,"V","R")
				EndIF
				
				IF aScan(aPd,{ |X| X[1] = aCodfol[249,1] .and. X[9] # "D" } ) = 0
					fMatriz(aCodfol[249,1],Round(nFerMedP,2),IF ( cRefFer="D",nDferave-nDFerInd,Int((nDferave-nDFerInd)/aTabFer[4])+0.12), , ,"V","R")
				EndIF
			
			Else
				
				nFerMedP := (nMedFerp / (M->RG_DFERPRO + M->RG_DFERAVI) )  * M->RG_DFERPRO
				
				IF aScan(aPd,{ |X| X[1] = aCodfol[087,1] .and. X[9] # "D" } ) = 0
					fMatriz(aCodfol[087,1],Round(nFervep,2),IF ( cRefFer="D",nDferave,Int(nDferave/aTabFer[4])+0.12), , ,"V","R")
				EndIF
				
				IF aScan(aPd,{ |X| X[1] = aCodfol[249,1] .and. X[9] # "D" } ) = 0
					fMatriz(aCodfol[249,1],Round(nFerMedP,2),IF ( cRefFer="D",nDferave,Int(nDferave/aTabFer[4])+0.12), , ,"V","R")
				EndIF

		 	EndIf	
		EndIF
	EndIF

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Vencidas                                                   ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/  
	IF ( M->RG_DFERVEN > 0 .and. aCodfol[86,1] # space(3) ) .Or. lCalDInd

		nFerDev := M->RG_DFERVEN    	//--Variavel de calculo criada para quando recalcular ter o valor original de calculo para abater os avos indenizados

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Soma o Mnemonico nDFerIndP referente ind. do Professor	   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nFerDev += If(lCalDInd, nDFerIndP, 0 )
         
		If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + "2" + "998" + "9698" )
			nFalPro := TRP->RP_HORAS
			lNoPerdPer := If( nFalPro <= 32, .T., .F. )
		EndIF
		
	 	If !lDFerAvi //Nao tinha campo ferias sobre aviso.
			//Gerar (ferias+media) sobre aviso com valores das ferias vencidas nos casos de ferias prop. de direito devido
			//somente ao aviso previo e caso o periodo proporcional nao tenha sido perdido devido a faltas.
			IF ( ( M->RG_DFERPRO == 0 .And. lNoPerdPer ) .Or. ( ( M->RG_DFERPRO == nDFerInd ) .And. nFalPro <= 5 ) ) .And. nDFerInd > 0
				IF M->RG_DFERPRO == 0
					For nCont := Len(aPerFerias) to Len(aPerFerias)
						aPerFerias[nCont,4] -= nDFerInd 
					Next nCont
				Endif	
				IF aCodFol[252,1] == Space(03) //Media Ferias Sobre Aviso Indenizado Rescisao
					nFerInd := (((SalMes + nAdtServ + nPeric + nInsal + nGComisFv + nMedFerv + nGTarefFv) / 30) * nDFerInd)
				Else
					nFerInd  := (((SalMes + nAdtServ + nPeric + nInsal + nGComisFv + nGTarefFv ) / 30) * nDFerInd)
					nFerMedI := ( ( nMedFerv / 30 ) * nDFerInd)
				EndIF
			EndIF                               
		EndIf
		
  
		If Type("aPerFerias") != "U" .and. Len(aPerFerias) > 0   

			nDFerAnt	:= IF(Empty(nDFerAnt), IF(Type("nDiasAnt") <> 'U',nDiasAnt,0), nDFerAnt)

			For nCont := 1 to Len(aPerFerias)
				If !Empty(aPerFerias[nCont,4]) .or. (aPerFerias[nCont,4]) > 0
					cSeq     := If(nCont=1," ",cValtoChar(nCont-1))
					nFerDAux := aPerFerias[nCont,4]
					nFerSFal := nFerDAux //Guarda dias de ferias sem descontar faltas
					If !Empty(aFaltasPer)
						nTipFal := nCont + If(nCont>1,3,0)
						nPosFal := aScan(aFaltasPer,{|x| x[1] = cValToChar(nTipFal)}) 
						If nPosFal > 0
							nFerDAux -= aFaltasPer[nPosFal,2]
						Endif	
					Endif						
					// Dias antecipados
					If nDFerAnt > 0						
						nFerDAux := Max(nFerDAux-nDFerAnt,0)
						nFerSFal := Max(nFerSFal-nDFerAnt,0)
						nDFerAnt := 0
					Endif
					nFerVAux := (((SalMes + nAdtServ + nPeric + nInsal + nGComisFv+nGTarefFv) / 30) * nFerDAux)				
					nFerMAux := 0                                                                       
					nPos := aScan(aPerMedia, {|x| x[2] = MesAno(aPerFerias[nCont,1])}) 
					If nPos > 0       
					// Proporcionalizacao das Medias antes de gravar no FMatriz
						If nFerDAux > 0
							nFerMAux += ((aPerMedia[nPos,4] / 30) * nFerDAux)
						Else
							nFerMAux += aPerMedia[nPos,4]
						EndIf
					else
						If nMedFerv > 0 .and. nFerDAux > 0
							nFerMAux +=  nMedFerv / 30 * nFerDAux
						EndIf	
					Endif
					
				 	If !lDFerAvi //Nao tinha campo ferias sobre aviso.
						// Verifica e define Id de ferias proporcionais ou indenizadas
						// Nao gera ferias indenizadas com 11/12 avos devido ao aviso previo
						If nDFerInd > 0 .and. (aPerFerias[nCont,4] + nDFerInd) >= 30 .and. nFerSFal < 30 .and. aPerFerias[nCont,2] > dDatadem1
							nIdFerAux := 087	//Ferias Proporcionais   
							nIdMedAux := 249	//Media Ferias proporcionais
						Else
							nIdFerAux := 086	//Ferias Indenizadas   
							nIdMedAux := 248	//Media Ferias Indenizadas
						EndIf

					Else
						nIdFerAux := 086 		//Ferias Indenizadas
						nIdMedAux := 248        //Media Ferias Indenizadas
					EndIf     
          			
         			
		   			// Se nao existir verba de media, soma na verba de ferias
					If aCodFol[248,1]  == Space(03)					
						nFerVAux += nFerMAux       
						If aScan(aPd,{ |X| X[1] = aCodfol[nIdFerAux,1] .and. X[9] # "D" .and. X[11] = cSeq } ) = 0
							fMatriz(aCodfol[nIdFerAux,1],Round(nFerVAux,2),IF(cRefFer="D",nFerSFal,Int(nFerSFal/aTabFer[4])+0.12), , ,"V","R", , , , , cSeq, , , , DTOS(aPerFerias[nCont,1]) + " - " + DTOS(aPerFerias[nCont,2]))
						Endif
					Else // Se existir verba de media
						If aScan(aPd,{ |X| X[1] = aCodfol[nIdFerAux,1] .and. X[9] # "D" .and. X[11] = cSeq } ) = 0
							fMatriz(aCodfol[nIdFerAux,1],Round(nFerVAux,2),IF(cRefFer="D",nFerSFal,Int(nFerSFal/aTabFer[4])+0.12), , ,"V","R", , , , , cSeq, , , , DTOS(aPerFerias[nCont,1]) + " - " + DTOS(aPerFerias[nCont,2]))
						Endif
						IF aScan(aPd,{ |X| X[1] = aCodfol[nIdMedAux,1] .and. X[9] # "D" .and. X[11] = cSeq } ) = 0
							fMatriz(aCodfol[nIdMedAux,1],Round(nFerMAux,2),IF(cRefFer="D",nFerSFal,Int(nFerSFal/aTabFer[4])+0.12), , ,"V","R", , , , , cSeq, , , , DTOS(aPerFerias[nCont,1]) + " - " + DTOS(aPerFerias[nCont,2]))
						Endif
					Endif										                                                                             
					nFerVev += nFerVAux
				Endif		
			Next nCont
		Endif	
	EndIF     

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Ferias Sobre Aviso                                         ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	IF ( M->RG_DFERAVI > 0 .and. aCodfol[230,1] # space(3)) 
	
		nDFerAvi := M->RG_DFERAVI //Dias de Ferias sobre aviso previo indenizado

		nFerInd	:= (((SalMes + nAdtServ + nPeric + nInsal + nGComisFv + nGTarefFv) / 30) * nDFerAvi)

		If  nMedFerp > 0
			nFerMedI := (nMedFerp / (M->RG_DFERPRO + M->RG_DFERAVI) ) * nDFerAvi
		Else
			If nMedAviso > 0
				nFerMedI :=  ( (nMedAviso / 30 ) * nDFerAvi )
			EndIf
		EndIf	         

		//Caso nao tenha ID dE Media Ferias Sobre Aviso Indenizado Rescisao, gravar junto com a verba de ferias s/aviso 
		If aCodFol[252,1] == Space(03)      
			nFerInd := nFerInd + nFerMedI

			IF aScan(aPd,{ |X| X[1] = aCodfol[230,1] .and. X[9] # "D" } ) = 0
				fMatriz(aCodfol[230,1],Round(nFerInd,2),IF( cRefFer="D",nDFerAvi,Int(nDFerAvi/aTabFer[4])+0.12), , ,"V","R")
			EndIF
		
		Else
		
			IF aScan(aPd,{ |X| X[1] = aCodfol[230,1] .and. X[9] # "D" } ) = 0
				fMatriz(aCodfol[230,1],Round(nFerInd,2),IF( cRefFer="D",nDFerAvi,Int(nDFerAvi/aTabFer[4])+0.12), , ,"V","R")
			EndIF
		
			IF aScan(aPd,{ |X| X[1] = aCodfol[252,1] .and. X[9] # "D" } ) = 0
				fMatriz(aCodfol[252,1],Round(nFerMedI,2),IF( cRefFer="D",nDFerAvi,Int(nDFerAvi/aTabFer[4])+0.12), , ,"V","R")
			EndIF

		EndIf
    
    Else  //Nao tinha campo ferias sobre aviso.
    
		IF !lDFerAvi  .and. ( nDferInd > 0 .and. ( nFerInd + nFerMedI) > 0 .and. aCodFol[230,1] # Space(3) )
			IF aScan(aPd,{ |X| X[1] = aCodfol[230,1] .and. X[9] # "D" } ) = 0
				fMatriz(aCodfol[230,1],Round(nFerInd,2),IF (cRefFer="D",nDFerInd,Int(nDFerInd/aTabFer[4])+0.12), , ,"V","R")
			EndIF           
			IF aCodFol[252,1] # Space(03) .and. nFerMedI > 0 //Media Ferias Sobre Aviso Indenizado Rescisao
				IF aScan(aPd,{ |X| X[1] = aCodfol[252,1] .and. X[9] # "D" } ) = 0
					fMatriz(aCodfol[252,1],Round(nFerMedI,2),IF (cRefFer="D",nDFerInd,Int(nDFerInd/aTabFer[4])+0.12), , ,"V","R")
				EndIF
			EndIF
		EndIF

	EndIf

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ 1/3 de ferias                                              ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	IF aCodFol[231,1] # Space(3) .and. nDFerInd > 0  //1/3 sobre Ferias na rescisao
		IF ( nFerMedV + nFerMedP ) < 0
			nValTerc := nFerVev+nFerVep
		Else                                             
			nValTerc := nFerVev+nFerVep+fBuscaPd(aCodFol[248,1])+fBuscaPd(aCodFol[249,1])
		EndIF
	Else
		IF ( fBuscaPd(aCodFol[248,1]) + fBuscaPd(aCodFol[249,1]) + fBuscaPd(aCodFol[252,1]) ) < 0
			nValTerc := nFerVev+nFerVep+nFerInd
		Else
			nValTerc := nFerVev+nFerVep+nFerInd+fBuscaPd(aCodFol[248,1])+fBuscaPd(aCodFol[249,1])+fBuscaPd(aCodFol[252,1])
		EndIF
	EndIF
	IF aCodfol[125,1] # Space(3) .and. nValTerc > 0.00
		PosSrv(aCodFol[125,1],SRA->RA_FILIAL)
		nPerc  := SRV->RV_PERC
		IF aScan(aPd,{ |X| X[1] = aCodfol[125,1] .and. X[9] # "D" } ) = 0
			fMatriz(aCodfol[125,1],Round(nValTerc * IF(nPerc=0.00 .or. nPerc=100.00, 1/3 ,nPerc / 100 ) ,2),0.00, , ,"V","R")
		EndIF
	EndIF
	//--Gerar 1/3 sobre Ferias sobre aviso previo
	IF aCodFol[231,1] # Space(3) .and. nDferInd > 0
		PosSrv(aCodFol[231,1],SRA->RA_FILIAL)
		nPerc  := SRV->RV_PERC
		IF aScan(aPd,{ |X| X[1] = aCodfol[231,1] .and. X[9] # "D" } ) = 0
		
			fMatriz(aCodfol[231,1],Round( ( nFerInd + fBuscaPd(aCodFol[252,1]) ) * IF(nPerc=0.00 .or. nPerc=100.00, 1/3 ,nPerc / 100 ) ,2),0.00, , ,"V","R")
		EndIF
	EndIF
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Dobra de Ferias Vencida									 ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	IF Type("aPerDobra") != "U" .and. Len(aPerDobra) > 0 .And. ( aCodfol[224,1] # Space(3) .Or. aCodfol[925,1] # Space(3) )

		For nCont := 1 to Len(aPerDobra)		
			cSeq      := If(nCont=1," ",cValtoChar(nCont-1))
			nDobrAux := (((SalMes + nAdtServ + nPeric + nInsal + nMedDobra) / 30) * aPerDobra[nCont,3])		
			IF aCodfol[224,1] # Space(3)
				//-- Ja tem ferias em dobre do calculo de ferias, logo precisa gerar a diferenca de dias
				//-- de ferias em dobro obrigatoriamente no novo identificador 925
				IF aScan(aPd,{ |X| X[1] = aCodFol[224,1] .and. X[9] # "D" .and. X[7] = "K" .and. X[11] = cSeq } ) > 0
					IF aCodfol[925,1] # Space(3)
						IF aScan(aPd,{ |X| X[1] = aCodFol[925,1] .and. X[9] # "D" .and. X[11] = cSeq } ) = 0
							fMatriz(aCodfol[925,1],Round(nDobrAux,2),aPerDobra[nCont,3], , ,"V","R", , , , , cSeq, , , , DTOS(aPerDobra[nCont,1]) + " - " + DTOS(aPerDobra[nCont,2]))
						EndIF
					Else
						If FunName() == "GPEM040"
							MsgAlert(	"Funcionário tem férias em dobro paga em cálculo de férias e férias em dobro a pagar na rescisão."+;
										CRLF +;
										"Para pagamento das férias em dobro na rescisão é necessário cadastrar os identificadores de cálculo 925 e 926, conforme boletim técnico 'GPE - Identificadores para Férias em Dobro pagas na Rescisão.pdf'."+;
										OemToAnsi( "Aten‡„o" ); //"Aten‡„o"
									)
						EndIf
						lIdDobro := .F.
					EndIF
				Else
					IF aCodfol[925,1] # Space(3)
						IF aScan(aPd,{ |X| X[1] = aCodFol[925,1] .and. X[9] # "D" .and. X[11] = cSeq } ) = 0
							fMatriz(aCodfol[925,1],Round(nDobrAux,2),aPerDobra[nCont,3], , ,"V","R", , , , , cSeq, , , , DTOS(aPerDobra[nCont,1]) + " - " + DTOS(aPerDobra[nCont,2]))
						EndIF
					Else
						IF aScan(aPd,{ |X| X[1] = aCodFol[224,1] .and. X[9] # "D" .and. X[11] = cSeq } ) = 0
							fMatriz(aCodfol[224,1],Round(nDobrAux,2),aPerDobra[nCont,3], , ,"V","R", , , , , cSeq, , , , DTOS(aPerDobra[nCont,1]) + " - " + DTOS(aPerDobra[nCont,2]))
						EndIF
					EndIF
				EndIF
			ElseIF aCodfol[925,1] # Space(3)
				IF aScan(aPd,{ |X| X[1] = aCodFol[925,1] .and. X[9] # "D" .and. X[11] = cSeq } ) = 0
					fMatriz(aCodfol[925,1],Round(nDobrAux,2),aPerDobra[nCont,3], , ,"V","R", , , , , cSeq, , , , DTOS(aPerDobra[nCont,1]) + " - " + DTOS(aPerDobra[nCont,2]))
				EndIF
			EndIF
			nFerDobra += nDobrAux
		Next nCont
	Endif	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ 1/3 sobre a Dobra de Ferias Vencida						 ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	IF nFerDobra > 0 .And. ( aCodFol[226,1] # Space(3) .Or. aCodFol[926,1] # Space(3) )
		
		IF aCodfol[226,1] # Space(3)
			//-- Ja tem ferias em dobre do calculo de ferias, logo precisa gerar a diferenca de dias
			//-- de ferias em dobro obrigatoriamente no novo identificador 925
			IF aScan(aPd,{ |X| X[1] = aCodFol[226,1] .and. X[9] # "D" .and. X[7] = "K" } ) > 0
				IF aCodfol[926,1] # Space(3)
					IF aScan(aPd,{ |X| X[1] = aCodFol[926,1] .and. X[9] # "D" } ) = 0
						nPerc := PosSrv(aCodFol[926,1],SRA->RA_FILIAL,"RV_PERC")
						fMatriz(aCodfol[926,1],Round(  nFerDobra * IF(nPerc=0.00 .or. nPerc=100.00, 1/3 ,nPerc / 100 ) ,2),0.00, , ,"V","R")
					EndIF
				Else
					If lIdDobro .And. FunName() == "GPEM040"
						MsgAlert("Funcionário tem férias em dobro paga em cálculo de férias e férias em dobro a pagar na rescisão."+;
									CRLF +;
									"Para pagamento das férias em dobro na rescisão é necessário cadastrar os identificadores de cálculo 925 e 926, conforme boletim técnico 'GPE - Identificadores para Férias em Dobro pagas na Rescisão.pdf'.",; 
									OemToAnsi("Aten‡„o"); //"Aten‡„o"
								)
					EndIf
				EndIF
			Else
				IF aCodfol[926,1] # Space(3)
					IF aScan(aPd,{ |X| X[1] = aCodFol[926,1] .and. X[9] # "D" } ) = 0
						nPerc := PosSrv(aCodFol[926,1],SRA->RA_FILIAL,"RV_PERC")
						fMatriz(aCodfol[926,1],Round(  nFerDobra * IF(nPerc=0.00 .or. nPerc=100.00, 1/3 ,nPerc / 100 ) ,2),0.00, , ,"V","R")
					EndIF
				Else
					IF aScan(aPd,{ |X| X[1] = aCodFol[226,1] .and. X[9] # "D" } ) = 0
						nPerc := PosSrv(aCodFol[226,1],SRA->RA_FILIAL,"RV_PERC")
						fMatriz(aCodfol[226,1],Round(  nFerDobra * IF(nPerc=0.00 .or. nPerc=100.00, 1/3 ,nPerc / 100 ) ,2),0.00, , ,"V","R")
					EndIF
				EndIF
			EndIF
		ElseIF aCodfol[926,1] # Space(3)
			IF aScan(aPd,{ |X| X[1] = aCodFol[926,1] .and. X[9] # "D" } ) = 0
				nPerc := PosSrv(aCodFol[926,1],SRA->RA_FILIAL,"RV_PERC")
				fMatriz(aCodfol[926,1],Round(  nFerDobra * IF(nPerc=0.00 .or. nPerc=100.00, 1/3 ,nPerc / 100 ) ,2),0.00, , ,"V","R")
			EndIF
		EndIF
	EndIF

ElseIf cPaisLoc == "ARG".And. aIncRes[05] == "S"
	RCE->(DbSetOrder(1))
	If RCE->(MsSeek( If(Empty(xFilial("RCE")), xFilial("RCE"), SRA->RA_FILIAL) + SRA->RA_SINDICA )).And.(RCE->RCE_HABCOR == "1")
		nDiasFerVen		:=	M->RG_DFERVEN //Devem se calcular quantos dias uteis sao a partir da data de demissao
		nDiasFerPro		:=	M->RG_DFERPRO //Devem se calcular quantos dias uteis sao a partir da data de demissao+dias uteis de ferias vencidas
   Else
		nDiasFerVen		:=	M->RG_DFERVEN
		nDiasFerPro		:=	M->RG_DFERPRO
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Vacaciones                                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nAdicVac   := ( ( SALMES    / nPercPro ) * (M->RG_DFERVEN+M->RG_DFERPRO) )-( ( SALMES    / 30 ) * (M->RG_DFERVEN+M->RG_DFERPRO) )

	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Vacaciones vencidas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FGeraVerba(aCodFol[086,1],( SALMES    / 30 ) * (M->RG_DFERVEN),M->RG_DFERVEN)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Vacaciones proporcionales³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FGeraVerba(aCodFol[087,1],( SALMES    / 30 ) * (M->RG_DFERPRO),M->RG_DFERPRO)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Adicional de ferias na rescisao (vencidas+proporcionais) ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FGeraVerba(aCodFol[125,1],nAdicVac,M->RG_DFERVEN+M->RG_DFERPRO)

	If !Empty(aCodFol[328,1])
		cDataIni	:=	MesAno(Posicione("SRF",1,xFilial("SRF")+SRA->RA_MAT,"SRF->RF_DATABAS"))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pegar Promedio                                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea( "SRD" )
		dbSetOrder(1)
		dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + cDataIni , .T. )
		While !Eof() .And. SRD->RD_FILIAL + SRD->RD_MAT == SRA->RA_FILIAL + SRA->RA_MAT 
			If Alltrim(PosSrv(SRD->RD_PD,SRD->RD_FILIAL,"RV_MEDFER")) == "S"
				nTotalAno	+= SRD->RD_VALOR
			Endif
			dbSkip()
		Enddo
		//Calcular os dias uteis do ano para o funcionario
		LocGHabRea(Max(SRA->RA_ADMISSA,Ctod('01/'+Substr(cDataIni,5)+'/'+Substr(cDataIni,1,4))),dDataDem,@nHabilesFunc)
	
		//Tirar as faltas e afastamentos do funcionario
		nHabilesFunc	-=	LocAfast(Max(SRA->RA_ADMISSA,Ctod('01/'+Substr(cDataIni,5)+'/'+Substr(cDataIni,1,4))),dDataDem,SRA->RA_MAT,{aCodFol[054,1],aCodFol[203,1],aCodFol[242,1]},{'X'})
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Rem Var.de ferias na rescisao (vencidas+proporcionais)   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FGeraVerba(aCodFol[328,1],(nTotalAno/nHabilesFunc)*(M->RG_DFERVEN+M->RG_DFERPRO),(M->RG_DFERVEN+M->RG_DFERPRO)) //Vacaciones sobre remuneracion variable
	Endif
Endif


Return( NIL )