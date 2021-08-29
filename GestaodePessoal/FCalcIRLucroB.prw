//Wederson Santana
//24/03/15
//Correção de funcão no roteiro de cálculo da folha.
User Function FCalcIRLucroB(aCodFol,cSem,lDep)
Local nAliq     := 0,nValPePLR := 0
Local aCodBenef := {}
Local nCntP,nPosP,nPosRed
Local nValDepLr	:= 0.00
Local cDataIR	:= If(Type(AnoMes(MV_PAR09))!='U',AnoMes(MV_PAR09),cFolMes)

aTabIrPlr := {}

CarIRPlr(aTabIrPlr,cDataIR)

cSem := If (cSem == Nil ,cSemana,cSem)

If Len(aCodFol) > 0   // Inserido por Michel Sander em 23.05.2017 para não causar erro no calculo de Adto e Folha
	If aCodfol[151,1] # Space(3) .And. aCodFol[152,1] # Space(03) .And. !Empty(aTabIrPlr)
		nPos := Ascan(aPd, { |X| X[1] = aCodfol[151,1] .And. X[3] = cSem .And. X[9] # "D"})
		IF nPos > 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Busca os codigos de pensao definidos no cadastro beneficiario³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			fBusCadBenef(@aCodBenef)
			
			nValPePLR := 0
			For nCntP := 1 To Len(aCodBenef)
				nPosP := Ascan(aPD , { |X| X[1] == aCodBenef[nCntP,8] .And. X[9] # "D" })
				nValPePLR += IF(nPosP > 0 , aPd[nPosP,5] , 0)
			Next nCntP
			
			nIr_b := aPd[nPos,5]
			nIr   := 0.00
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Redutor da base de IR na participacao dos lucros             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nPosRed := Ascan(aPd, { |X| X[1] = aCodfol[411,1] .And. X[3] = cSem .And. X[9] # "D"})
			If nPosRed > 0
				nIr_b := Max( nIr_b - aPd[nPosRed,5], 0 )
			EndIf
			
			Calc_IrPLRB(nIr_B , nValPePLR, @nIr , 0 ,@nValDepLr,, aTabIrPlr,,@nAliq)
			//Guarda o valor da base na variavel referente base IR de adiantamento
			BASE_INI := nIr_B
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Gerar Ir Dist. Lucro										 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			FMatriz(aCodfol[152,1],nIr,nAliq,cSem,,,If(c__ROTEIRO=="ADI","A",NIL))
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Gerar Ded.Dep. Distr. Lucro.								 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aCodFol[300,1] # Space(3)  .and. lDep
				FMatriz(aCodfol[300,1],nValDepLr,Val(Sra->Ra_depir),cSem)
				//Zera o valor da variavel de dependente folha pois o valor do dependente
				//sera pago na verba de PLR.
				VAL_DEDDEP := 0
			Endif
			
		EndIf
	EndIf
	
	IF Empty(aTabIrPlr)
		If aCodfol[151,1] # Space(3) .And. (nPos := Ascan(aPd, { |X| X[1] = aCodfol[151,1] .And. X[3] = cSem .And. X[9] # "D"}) > 0 )
			aHelpPor	:= {}
			AADD(aHelpPor,'Cálculo de IR s/ PLR não foi realizado')
			AADD(aHelpPor,'devido a falta de informação na tabela.')
			PutHelp("PIRPLR",aHelpPor,aHelpPor,aHelpPor,.F.)
			
			aHelpPor	:= {}
			AADD(aHelpPor,'Preencha a tabela S044 de acordo')
			AADD(aHelpPor,'com o Mes/Ano do cálculo.')
			PutHelp("SIRPLR",aHelpPor,aHelpPor,aHelpPor,.F.)
			
			Help("",1,"IRPLR")
		Endif
	Endif
EndIf
Return Nil

//-----

Static Function Calc_IrPLRB(nBaseIni,nPenAl,nIrCalc,nBaseRed,nDedDep,nDepeAl,aTabIr,lIrMin,nAliq)

Local aArea		:= GetArea()
Local lResExt	:= .F.			// Funcionario residente no exterior
Local nOrdRGE	:= 0			// Define ordem da tab. RGE (Hist. contrato) caso o funcionario seja Residente no Exterior
Local nPercIRREx:= 0.00			// Variavel do Percentual do IR do Hist. Contrato do Residente no Exterior

lIrMin	:= If( lIrMin = Nil, .T., lIrMin )

If SRA->( FieldPos( "RA_RESEXT" )) # 0
	lResExt := If( SRA->RA_RESEXT == "1", .T., .F. )
EndIf

If ! lResExt
	nAliq    := 0
	nBaseIni -= nPenAl
	nPenAl   := 0
	nBaseRed := nBaseIni
EndIf

If nBaseIni <= 0
	nDedDep := 0.00
	Return Nil
EndIf

// DEDUCAO POR DEPENDENTES
If nDedDep # Nil .and. !lResExt
	If cModulo = "GPE"
		nDedDep := aTabIr[20] * (IF(VAL(SRA->RA_DEPIR) > aTabIr[21],aTabIr[21],VAL(SRA->RA_DEPIR)))
	Else
		nDedDep := aTabIr[20] * (IF(VAL(SRA->RA_DEPIR) > aTabIr[21],aTabIr[21],nDedDep))
	Endif
Else
	nDedDep := 0.00
EndIf

nBaseRed := nBaseIni - nDedDep

If nBaseRed <=  aTabIr[7]  .and. !lResExt
	nBaseRed := 0
	Return Nil
EndIf

// DEDUCAO POR PENSAO ALIMENTICIA
If !lResExt
	If aTabIr[7] - (nBaseRed - nPenAl) < 0
		nDepeAl := nPenAl
	Else
		nDepeAl := nBaseRed - aTabIr[7]
	EndIf
Else
	nDepeAl := 0
EndIf

nBaseRed -= nDepeAl
If nBaseRed <=  aTabIr[7] .and. !lResExt
	nBaseRed := 0
	Return Nil
EndIf

If !lResExt
	// CALCULO DO IR SOBRE A TABELA
	// SE MENOR OU IGUAL AO VALOR DE ISENCAO VEZES A QUANTIDADE DE MESES, NAO CALCULA NADA
	If nBaseRed <= aTabIr[7]
		nBaseRed := 0
		Return Nil
		// SE MENOR QUE FAIXA 2, UTILIZA FAIXA 1 PARA O CALCULO
	Elseif nBaseRed <= aTabIr[8]
		nIrCalc := (nBaseRed * (aTabIr[9]/100))- aTabIr[10]
		nAliq   := aTabIr[9]
		// SE MENOR QUE FAIXA 3, UTILIZA FAIXA 2 PARA O CALCULO
	Elseif nBaseRed <= aTabIr[11]
		nIrCalc := (nBaseRed * (aTabIr[12]/100))- aTabIr[13]
		nAliq   := aTabIr[12]
		// SE MENOR QUE FAIXA 4, UTILIZA FAIXA 3 PARA O CALCULO
	Elseif nBaseRed <= aTabIr[14]
		nIrCalc := (nBaseRed * (aTabIr[15]/100))- aTabIr[16]
		nAliq   := aTabIr[15]
		// SE MAIOR OU IGUAL FAIXA 4, UTILIZA FAIXA 4 PARA O CALCULO
	Else
		nIrCalc := (nBaseRed * (aTabIr[18]/100))- aTabIr[19]
		nAliq  := aTabIr[18]
	EndIf
Else  //Residentes no exterior
	// Utiliza Percentual de IR padrao com 25% para Residente no Exterior independente de Hist. Contrato
	nPercIRREx := 25.00
	
	// Busca Perc. IR no Hist. Contrato caso o campo Exista na tabela
	If RGE->( FieldPos( "RGE_PERCIR" )) # 0
		
		// Define ordem da tab. RGE (Hist. contrato)
		nOrdRGE	:= RetOrdem( "RGE", "RGE_FILIAL+RGE_MAT+DTOS(RGE_DATAIN)+RGE_TIPOCO" )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pesquisa se ha historico de contrato para o funcionario, verifica a data	³
		//³ inicio e fim do contrato para definir o percentual de IR a ser utilizado.	³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea( "RGE" )
		RGE->( DbSetOrder( nOrdRGE ) )						// RGE_FILIAL+RGE_MAT+DTOS(RGE_DATAIN)+RGE_TIPOCO
		RGE->( DbSeek( xFilial( "RGE" ) + SRA->RA_MAT ) )	// Verifica se ha algum contrato para o funcionario
		While RGE->( ! Eof() ) .and. ( RGE->(RGE_FILIAL + RGE_MAT) == SRA->(RA_FILIAL + RA_MAT) )
			
			// Utiliza o Percentual se o Contrato estiver dentro do MesAno de Calculo
			If ( MesAno( RGE->RGE_DATAIN ) <= MesAno( dDataBase ) ) .and. ;
				( Empty( RGE->RGE_DATAFI ) .or. MesAno( RGE->RGE_DATAFI ) >= MesAno( dDataBase ) )
				
				// Carrega a Var referente ao Percentual de IR do Funcionario com Historico de Contrato
				nPercIRREx := RGE->RGE_PERCIR
			EndIf
			
			RGE->( DbSkip() )
		EndDo
	EndIf
	
	nIrCalc	:= nBaseRed * ( nPercIRREx / 100 )
	nAliq  	:= nPercIRREx
EndIf

nIrCalc = INT( nIrCalc * 100 ) / 100  // DEIXA O VALOR COM 2 CASAS APOS A VIRGULA

// VERIFICA RETENCAO
If nIrCalc < aTabIr[22] .And. lIrMin .and. !lResExt
	nIrCalc  := 0
	nBaseRed := 0
EndIf

RestArea( aArea )

Return Nil
