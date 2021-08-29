User Function BuscaMedB(nMedFerv,nMedFerp,nMed13o,nMedAviso,nDesc13,nMedDobra)

Local nDsrm_fv := nDsrm_fp := nDsrm_av := nDsrm_13 := 0.00
Local nMedPer  := nMedIns  := nBasePer := nBasIns  := 0.00
Local cTipMed,nPosDsr,k
Local nDiasFer	:= aTabFer[3]
Local nAnos		:=	0
Local cMesAnoRef:= SuperGetMv("MV_FOLMES",,"")
Local nDsrHrsAtiv := 0
Local nPosSemana  := 0
Local nPosValor   := 0
Local nPosMed	  := 0
Local nMedAux	  := 0

If cPaisLoc == "PAR"
	IF Year(dDataBase) - Year(SRA->RA_NASC) <= 17  .Or. ;
		(Year(dDataBase) - Year(SRA->RA_NASC) == 18 .And.;
	 	Substr(Dtos(dDataBase),5,4) <=Substr(Dtos(SRA->RA_NASC),5,4))
		nDiasFer	:=	aTabFer[3]
	Else		
		nAnos	:= (Year(dDataBase) - Year(SRA->RA_ADMISSA)) - If(Substr(Dtos(dDataBase),5,4) <= Substr(Dtos(SRA->RA_ADMISSA),5,4),1,0 )
		Do Case
			Case nAnos > 10
				nDiasFer	:=	aTabFer[3]
			Case nAnos > 5 .And. nAnos <= 10
				nDiasFer	:=	18
			Case nAnos <= 5
				nDiasFer	:=	12
		EndCase					
	Endif
ElseIf cPaisLoc == "CHI"
	nAnos	:= (Year(dDataBase) - Year(SRA->RA_ADMISSA)) - If(Substr(Dtos(dDataBase),5,4) <= Substr(Dtos(SRA->RA_ADMISSA),5,4),1,0 )
	nDiasFer	:=	15
	If nAnos >= 13
		nDiasFer	+=	Int((nAnos-10)/3)
	Endif
ElseIf cPaisLoc == 'URU'
   nAnos	:= (Year(dDataBase) - Year(SRA->RA_ADMISSA)) - If(Substr(Dtos(dDataBase),5,4) <= Substr(Dtos(SRA->RA_ADMISSA),5,4),1,0 )
	nDiasFer	:=	20
	If nAnos >= 5
		nDiasFer	+=	Int((nAnos)/4)
	Endif

Endif	

dbSelectArea("TRP")
IF dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + "3" + "997" + "9598" )
	nDesc13 := TRP->RP_VALATU
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se a rescisao for no mes seguinte ao mes que esta aberto  ³
//³soma o valor da 1a parcela paga nas ferias na variavel de ³
//³desconto da 1a parcela do 13o salario e exclui a verba de ³
//³1a parcela que esta no aPd quando esta verba foi gerada   ³
//³pelo sistema ("V").                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !( cMesAnoRef == MesAno( dDataDem ) ) .And. !lRecRes
	Aeval(aPd,{|x| nDesc13 += If(x[1] == aCodFol[022,1] .And. x[3] == cSemana,x[5],0)})
	Aeval(aPd,{|x| x[9] := If(x[1] == aCodFol[022,1] .And. x[3] == cSemana .And. x[7] == "V","D",x[9])})
ElseIf !( cMesAnoRef == MesAno( dDataDem ) ) .And. lRecRes .And. Type("aCols") == "A" .And. nDesc13 == 0
	nPosSemana	:= GdFieldPos("RR_SEMANA")
	nPosValor 	:= GdFieldPos("RR_VALOR")
	Aeval(aCols,{|x| nDesc13 += If(x[1] == aCodFol[116,1] .And. x[nPosSemana] == cSemana,x[nPosValor],0)})
	Aeval(aCols,{|x| nDesc13 += If(x[1] == aCodFol[183,1] .And. x[nPosSemana] == cSemana,x[nPosValor],0)})
Endif

IF dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
	While ! Eof() .and. SRA->RA_FILIAL+SRA->RA_MAT = TRP->RP_FILIAL+TRP->RP_MAT
		IF TRP->RP_PD > "900"
			dbSkip( 1 )
			Loop
		EndIF
		IF PosSrv(TRP->RP_PD,SRA->RA_FILIAL,"RV_DSRHE") = "S"
			IF TRP->RP_TIPO $ "156789" .and. TRP->RP_DATARQ = "99MD"
				nDsrm_fv += TRP->RP_VALATU				
			ElseIF TRP->Rp_TIPO $ "2" .and. TRP->RP_DATARQ = "9999"
				nDsrm_fp += TRP->RP_VALATU
			ElseIF TRP->RP_TIPO $ "3" .and. TRP->RP_DATARQ = "9999"
				nDsrm_13 += TRP->RP_VALATU
			ElseIF TRP->RP_TIPO $ "4" .and. TRP->RP_DATARQ = "9999"
				nDsrm_av += TRP->RP_VALATU
			EndIF
		EndIF
		dbSkip(1)
	End While
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calculo do Dsr s/ Medias                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nDsrm_fv := IF(nDsrm_fv > 0.00 .and. aIncRes[8]  = "S",(nDsrm_fv * Descanso) / Normal,0.00)
	nDsrm_fp := IF(nDsrm_fp > 0.00 .and. aIncRes[8]  = "S",(nDsrm_fp * Descanso) / Normal,0.00)
	nDsrm_13 := IF(nDsrm_13 > 0.00 .and. aIncRes[9]  = "S",(nDsrm_13 * Descanso) / Normal,0.00)
	nDsrm_av := IF(nDsrm_av > 0.00 .and. aIncRes[10] = "S",(nDsrm_av * Descanso) / Normal,0.00)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Media de Ferias Vencidas (Tratamento de Mais de Um Periodo)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For k := 1 To 6
		cTipMed	:= Str( IF(k ==1, 1,k+3), 1)
		IF dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + cTipMed + "999" + "99MD" )
			nMedAux  := TRP->RP_VALATU + IF(k = 1,nDsrm_fv,0) + fDsrHrsAtiv(cTipMed,aCodFol)
			nMedFerv += nMedAux
			If Type("aPerMedia") != "U" .AND. ( nPosMed := aScan(aPerMedia, {|x| x[1] = cTipMed}) ) > 0
				aPerMedia[nPosMed,4] += nMedAux
			Endif			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calcula Peric./Insalub Sobre Verba de Medias  incidencia   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nMedPer := nMedIns := 0.00
			FMedPerIns(@nMedPer,@nMedIns,cTipMed,SalHora,Val_BInsal,aCodFol)
			nMedFerv += (nMedPer+nMedIns)
			//-- Iguala a media do primeiro periodo para pagamento da Dobra se houver
			If K = 1
				nMedDobra := nMedFerv
			Endif	
		EndIF
	Next k
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Media de Ferias Proporcionais                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("TRP")
	IF dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + "2" + "999" + "9999" )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ SalVa Registro da Media                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nRecFerp := Recno()
		nMedPer := nMedIns := 0.00
		IF SRA->RA_PERICUL == 999.99 .or. SRA->RA_INSMIN == 999.99 .or. SRA->RA_INSMED == 999.99 .or. SRA->RA_INSMAX == 999.99
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Soma Para Ferias Verbas Devem Ser Somadas Per. S/ Media    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nBasPer := nBasIns := 0.00
			aEval( aPd ,{ |X| SomaInc(X, 9,@nBasPer,8,"S", , , , ,aCodFol) })
			aEval( aPd ,{ |X| SomaInc(X,10,@nBasIns,8,"S", , , , ,aCodFol) })
			nBasPer  := (nBasePer / 12)
			nBasIns  := (nBasIns /  12 )
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calcula Peric./Insalub Verba de Medias Tem Incidencia      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nMedPer := nMedIns := 0.00
			FMedPerIns(@nMedPer,@nMedIns,"2",SalHora,Val_BInsal,aCodFol,'9999',nBasPer,nBasIns)
			dbGoto(nRecFerp)
		EndIF
		
		nDsrHrsAtiv := fDsrHrsAtiv("2",aCodFol,"9999") //Calculo do DSR / Horas Atividade de professores
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ A rotina de media gera os periodos de acordo com a data de demissao sem   ³
		//³ o aviso previo e o periodo para media pode ser proporcional e com o aviso ³
		//³ as ferias mudou de proporcional para vencidas e a media ficou gravada no  ³
		//³ periodo proporcional, nessa situacao utilizar media proporcional para o   ³
		//³ calculo das ferias vencidas.                                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !lDFerAvi
			If ( (nDFerV == 0 .And. nMedFerv = 0) .Or. (nDFerV > 0 .And. (nDFerA + nDFerInd ) == aTabFer[3]) ) .And. nDFerA > 0 .And. nDFerVen > 0
				nMedFerv := TRP->RP_VALATU + nDsrm_fp + nMedPer + nMedIns + nDsrHrsAtiv
			ElseIF cMedDir == "S"
				nMedFerp := ( TRP->RP_VALATU + nDsrm_fp + nMedIns + nMedPer + nDsrHrsAtiv )
			Else
				nMedFerp := (( (TRP->RP_VALATU + nDsrm_fp + nMedPer + nMedIns + nDsrHrsAtiv) * M->RG_DFERPRO ) / nDiasFer )
			EndIF
		Else
			IF cMedDir == "S"
				nMedFerp := ( TRP->RP_VALATU + nDsrm_fp + nMedIns + nMedPer + nDsrHrsAtiv )
			Else 
				//Para o calculo da media, devemos considerar os dias de aviso, limitando a 30 dias
				nMedFerp := (( (TRP->RP_VALATU + nDsrm_fp + nMedPer + nMedIns + nDsrHrsAtiv) * Min(M->RG_DFERPRO + M->RG_DFERAVI,30) ) / nDiasFer )
			EndIF
		EndIf	
	EndIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Media de 13§ Salario                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("TRP")
	IF dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + "3" + "999" + "9999" )
		nRec13 := Recno()
		nMedPer := nMedIns := 0.00
		IF SRA->RA_PERICUL == 999.99 .or. SRA->RA_INSMIN == 999.99 .or. SRA->RA_INSMED == 999.99 .or. SRA->RA_INSMAX == 999.99
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Soma Para 13§ Verbas Devem Ser Somadas Para Per. S/ Media  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nBasPer := nBasIns := 0.00
			aEval( aPd ,{ |X| SomaInc(X, 9,@nBasPer,7,"S", , , , ,aCodFol) })
			aEval( aPd ,{ |X| SomaInc(X,10,@nBasIns,7,"S", , , , ,aCodFol) })
			nBasPer  := (nBasePer / 12)
			nBasIns := (nBasIns /  12 )
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calcula Peric./Insalub Verba de Medias Que Tem Incidencia  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nMedPer := nMedIns := 0.00
			FMedPerIns(@nMedPer,@nMedIns,"3",SalHora,Val_BInsal,aCodFol,'9999',nBasPer,nBasIns)
			dbGoto(nRec13)
		EndIF
		nMed13o := TRP->RP_VALATU + nDsrm_13 + nMedPer + nMedIns + fDsrHrsAtiv("3",aCodFol,"9999")
	EndIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faltas 13§ Salario                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("TRP")
	IF dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + "3" + "998" + "9998" )
		nAvosFal13  := TRP->RP_HORAS
	EndIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Media Aviso Previo                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("TRP")
	IF dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + "4" + "999" + "9999" )
		nRecAv  := Recno()
		nMedPer := nMedIns := 0.00
		IF SRA->RA_PERICUL == 999.99 .or. SRA->RA_INSMIN == 999.99 .or. SRA->RA_INSMED == 999.99 .or. SRA->RA_INSMAX == 999.99
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Soma Para Aviso Verbas Devem Ser Somadas Para Per. S/ Media³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nBasPer := nBasIns := 0.00
			IF dDataDem - SRA->RA_ADMISSA < 365
				aEval( aPd ,{ |X| SomaInc(X, 9,@nBasPer,23,"S", , , , ,aCodFol) })
				aEval( aPd ,{ |X| SomaInc(X,10,@nBasIns,23,"S", , , , ,aCodFol) })
				nBasPer  := (nBasePer / 12)
				nBasIns  := (nBasIns /  12 )
			EndIF
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calcula Peric./Insalub Verba de Medias Que Tem Incidencia  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nMedPer := nMedIns := 0.00
			FMedPerIns(@nMedPer,@nMedIns,"4",SalHora,Val_BInsal,aCodFol,'9999',nBasPer,nBasIns)
			dbGoto(nRecAv)
		EndIF
		nMedAviso   := TRP->RP_VALATU + nDsrm_av + nMedPer + nMedIns + fDsrHrsAtiv("4",aCodFol,"9999")
	EndIF
EndIF

Return( NIL )
