#INCLUDE "PROTHEUS.CH"
//#INCLUDE "GPEM013.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GPEM013	³ Autor ³ Allyson M	                 ³ Data ³ 10/09/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ ROTINA PARA CHAMADA DO CALCULO DA DESONERACAO FOLHA	   	       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ 		ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.		           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data	³ Chamado   ³  Motivo da Alteracao			  	       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Renata      ³11/10/12³TFYFIW     ³Ajuste para gravar na tabela S033 c/tipo  ³±±
±±³            ³        ³           ³faturamento 2, qdo possuir apenas valor   ³±±
±±³            ³        ³           ³de produtos nao desonerados.			   ³±±
±±³Allyson M   ³23/10/12³TFZWSM     ³Ajuste para gravar na tabela S033 c/tipo  ³±±
±±³            ³        ³           ³faturamento 1, qdo nao ter base p/ calculo³±±
±±³Allyson M   ³12/11/12³TGCNK8     ³Ajuste p/ verificar o % da receita nao    ³±±
±±³            ³        ³           ³desonerada em relacao a receita total. O %³±±
±±³            ³        ³           ³nao pode ser menor ou igual a 5% p/ o cal-³±±
±±³            ³        ³           ³culo da contribuicao sobre a folha.	   ³±±
±±³Allyson M   ³26/11/12³TGEEZO     ³Ajuste p/ replicar o tratamento efetuado  ³±±
±±³            ³        ³           ³do calculo da contribuicao previdenciaria ³±±
±±³            ³        ³           ³patronal sobre aa folha (SRC) p/ o calculo³±±
±±³            ³        ³           ³sobre a 2a. parcela do 13o. salario (SRI).³±±
±±³Allyson M   ³23/01/13³TGLEDE     ³Ajuste na situacao que so ha uma nota de  ³±±
±±³            ³        ³           ³devolucao de um produto desonerado e que  ³±±
±±³            ³        ³           ³nao gravava o codigo de atividade.		   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function GPEM013b() 

Local aArea			:= GetArea()
Local aButtons		:= {} 
Local aSays			:= {}
Local bProcesso 	:= { |oSelf| GPMProcessa(oSelf) }
Local cDescricao 	:= ""
Local nOpcao 		:= 0
         
Private aLog		:= {}
Private aTitle		:= {}
Private lAbortPrint := .F.
Private lVersao101 	:= ( GetRpoRelease("R1.1") )

cCadastro := OemToAnsi("Desoneração da Folha de Pagamento") //"Desoneração da Folha de Pagamento"

Begin Sequence
	//Valida atualizacao de perguntas
	If !fValSX1()
		Aviso( "Alerta", "Execute a opção do compatibilizador referente a Criação do Grupo de Perguntas para Cálculo da Desoneração da Folha - 13º Salário. Para maiores informações, verifique respectivo Boletim Técnico.", {"OK"} ) //"Alerta"##"Execute a opção do compatibilizador referente a Criação do Grupo de Perguntas para Cálculo da Desoneração da Folha - 13º Salário. Para maiores informações, verifique respectivo Boletim Técnico."##"Ok"
		Break
	EndIf

	Pergunte("GPM013",.F.)
	cDescricao 	:= OemToAnsi("Este programa atualiza, se configurado, a tabela auxiliar S033 - Faturamento Mensal com as informações da receita obtida no período. Também efetua a apuração da Contribuição Previdenciária Patronal")//"Este programa atualiza, se configurado, a tabela auxiliar S033 - Faturamento Mensal com as informações da receita obtida no período. Também efetua a apuração da Contribuição Previdenciária Patronal"
	
	If lVersao101
		tNewProcess():New( "GPEM013" , cCadastro , bProcesso , cDescricao , "GPM013", , , , ,.T.,.T.  )  
	Else
		aAdd(aButtons, { 5, .T., { || Pergunte( "GPM013", .T. ) } } )
		aAdd(aButtons, { 1, .T., { |o| nOpcao := 1, IF( GPM013Ok(), FechaBatch(), nOpcao := 0 ) } } )
		aAdd(aButtons, { 2, .T., { |o| FechaBatch() } } )
	
		aAdd(aSays, OemToAnsi("Este programa atualiza, se configurado, a tabela auxiliar S033 - Faturamento Mensal") )//"Este programa atualiza, se configurado, a tabela auxiliar S033 - Faturamento Mensal"
		aAdd(aSays, OemToAnsi("com as informações da receita obtida no período.") )//"com as informações da receita obtida no período."
		aAdd(aSays, OemToAnsi("Também efetua a apuração da Contribuição Previdenciária Patronal") )//"Também efetua a apuração da Contribuição Previdenciária Patronal"
		
		FormBatch( cCadastro, aSays, aButtons )
	
		IF nOpcao == 1
			ProcGpe( {|lEnd| GPMProcessa()},,,.T. )
		EndIf
	EndIf
	
	fMakeLog(aLog,aTitle,,,"Desonera","Log de Ocorrências do Cálculo","M","P",,.F.) //"Desonera"##"Log de Ocorrências do Cálculo"
End Sequence

RestArea( aArea )

Return()

/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o	   ³ GPMProcessa ³ Autor ³ Equipe de RH    	  ³ Data ³10/09/2012³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³ Confirmar as Configuracoes dos Parametros                  ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³ GPMProcessa(oSelf)											³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³                                                            ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Uso	   ³ Generico 												    ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Static Function GPMProcessa(oSelf)

Local aArea			:= GetArea()
Local aAreaSM0	 	:= SM0->( GetArea() )
Local aCalcDes		:= {}
Local aCateg		:= {}
Local aCodFol		:= {}
Local aFilProc	 	:= {}
Local aSrcFields	:= SRC->( dbStruct() ) 
Local aSriFields	:= SRI->( dbStruct() ) 
Local aTab13Sal  	:= {}
Local aTabInss	 	:= {}
Local aTabS033	 	:= {}
Local cAliasFat	 	:= ""
Local cAliasTMP 	:= "QNRO"
Local cAliasSRA		:= "SRA"
Local cAliasSRC		:= "SRC"
Local cAliasSRI		:= "SRI"
Local cCatQuery		:= 0
Local cCposQuery	:= ""
Local cCateg	 	:= ""
Local cCodEmp	 	:= SM0->M0_CODIGO
Local cFilialDe  	:= ""
Local cFilialAte 	:= ""
Local cFolMes 	 	:= GetMv( "MV_FOLMES",,Space(08) ) 
Local cLastFil		:= "_cLastFil"
Local cMatDe	 	:= ""
Local cMatAte	 	:= ""
Local cMesAno		:= SubStr( cFolMes, 5, 2 ) + SubStr( cFolMes, 1, 4 )
Local cRecFatEmp 	:= ""
Local cTextoLog		:= ""
Local cTipFat	 	:= ""
Local cTpC			:= ""
Local dDataPg		:= cToD("//")
Local dDataRef	 	:= cToD("//")
Local lLogRec		:= .F.
Local lLogRec13		:= .F.
Local lTemClvl		:= ( SRA->( FieldPos( "RA_CLVL" ) ) != 0 )
Local lTemInssAut	:= ( SRA->( FieldPos( "RA_INSSAUT" ) ) != 0 )
Local lTemItem		:= ( SRA->( FieldPos( "RA_ITEM" ) ) != 0 )
Local nAliq		 	:= 0
Local nAv13Des     	:= 0
Local nAv13Resc   	:= 0
Local nBaseInss     := 0
Local nCalc			:= 0
Local nCont13		:= 0
Local nContInss		:= 0
Local nContr		:= 0
Local nContrib		:= 0
Local nFatBas    	:= 0
Local nFatDExp    	:= 0
Local nFatExc    	:= 0
Local nFatExp    	:= 0
Local nFatRec	 	:= 0
Local nFatTot		:= 0
Local nFatTotDev	:= 0
Local nFatTotExp	:= 0
Local nField		:= 0
Local nFilial	 	:= 0
Local nPer13Sal		:= 0
Local nPerFatEmp	:= 0
Local nRecBruto		:= 0
Local nRecDes		:= 0
Local nRecOut		:= 0
Local nReg			:= 0
Local nRegProc		:= 0
Local nSalCont		:= 0
Local nSalCon13		:= 0
Local nSrcFields 	:= Len( aSrcFields )
Local nSriFields 	:= Len( aSriFields )
Local nTotCont		:= 0
Local nTotDev		:= 0
Local nTotExp		:= 0
Local nTpContr	 	:= 0
Local nValor		:= 0
Local nVerFatFin 	:= 0
Local nVl13Des     	:= 0
Local nVl13Resc   	:= 0

Private lDissidio 	:= .F.

Aadd( aTitle, OemToAnsi( "Log do Cálculo da Contribuição Previdenciária Patronal Rosenberger" ) )//"Log do Cálculo da Contribuição Previdenciária Patronal"
Aadd( aLog	, {} )
Aadd( aTitle, OemToAnsi( "Avisos" ) )//"Avisos"
Aadd( aLog	, {} )
Aadd( aTitle, OemToAnsi( "Log do Cálculo da Contribuição Previdenciária Patronal - 13º Salário" ) )//"Log do Cálculo da Contribuição Previdenciária Patronal - 13º Salário"
Aadd( aLog	, {} )

cFilialDe  	:= mv_par01//	Filial De
cFilialAte 	:= mv_par02//	Filial Ate
cMatDe	 	:= mv_par03//	Matricula De
cMatAte	 	:= mv_par04//	Matricula Ate
cCateg	 	:= mv_par05//  	Categorias a serem calculadas
nVerFatFin 	:= mv_par06// 	Vericar Faturamento-Financeiro (1-Nao; 2-Faturamento; 3-Financeiro; 4-Ambos)
nCalc		   := mv_par07// 	Calcular sobre (1-Folha; 2-13o. Salario)

//Monta variavel dDataRef da data de competencia em aberto p/ busca do fCarrTab
dDataRef := cToD( "01/" + SubStr( cFolMes, 5, 2 ) + "/" + SubStr( cFolMes, 1, 4 ) )
//Chama fCarrTab para carregar tabela auxiliar S033
fCarrTab( @aTabS033, "S033", dDataRef )
//Chama fCarrTab para recarregar tabela auxiliar S033 - 13o. salario
fCarrTab( @aTab13Sal, "S033", , SubStr( cFolMes, 1, 4 ) + "13" )

//Se for calculo da folha, verificar faturamento e/ou financeiro
If nCalc == 1 .And. nVerFatFin != 1
	//Monta o array das filiais a processar.
	dbSelectArea("SM0")
	dbSeek( cCodEmp, .T. )

	While !EoF() .And. cCodEmp == SM0->M0_CODIGO
		If FWGETCODFILIAL >= cFilialDe .And. FWGETCODFILIAL <= cFilialAte
			aAdd( aFilProc, { FWGETCODFILIAL } )
		Endif
		SM0->( dbSkip() )
	EndDo	

	//Verifica todas as filiais que foram selecionadas no processamento, 
	//para validar se possuem registro na tabela auxiliar S033
	For nFilial := 1 To Len( aFilProc )
		//Reinicializa variaveis
		nAliq	 	   := 0
		nContr		:= 0
		nFatTot	 	:= 0
		nFatTotDev	:= 0
		nFatTotExp	:= 0
		nFatRec 	   := 0
		nFatExc 	   := 0
		nFatExp 	   := 0
		nFatDExp 	:= 0
		nFatBas		:= 0
		nTotCont 	:= 0 
		nTotDev 	   := 0 
		nTotExp 	   := 0 
		//Busca no parametro 14 se a empresa recolhe contribuicao previdenciaria sobre a receita (X14_RECFAT)
		If fInssEmp( aFilProc[nFilial, 1], @aTabInss, Nil, cFolMes )
			//Verifica os dois tipos de contrato
			For nTpContr := 1 To 2
				cRecFatEmp 	:= aTabInss[27, nTpContr]//X14_RECFAT
				//Se recolher sobre o faturamento ou for recolhimento misto
				If cRecFatEmp $ "S*M"
	            	//Se nao encontrar registros para a filial, verificar as funcoes das integracoes
	            	If ( aScan( aTabS033, {|x| x[2] == aFilProc[nFilial, 1] } ) == 0 )
		            	//Se somente verifica Financeiro
		            	If nVerFatFin == 3
							   //Entra na funcao do Financeiro para buscar os valores dos titulos de acordo
							   //com a filial logada. A funcao nao permite passar a filial como parametro
							   //entao a variavel cFilAnt sera alterada de acordo com a filial em processamento.
							   //A funcao retorna o valor das receitas financeiras.					
							   cSvFilAnt := cFilAnt
							   cFilAnt	  := aFilProc[nFilial, 1]
							   nFatTot   := FTotF100( Val( SubStr( cFolMes, 5, 2 ) ), Val( SubStr( cFolMes, 1, 4 ) ) )
							   cFilAnt	  := cSvFilAnt
			                //Grava o registro da receito de tipo 2
							   If nFatTot > 0
								   fGravaS033( aFilProc[nFilial, 1], cFolMes, Nil, "2", nFatTot, 0.00, 0.00, nFatTot, 0.00, 0.00, aTabS033 )					
							   EndIf	            	
				            cTextoLog := "- Verifique a tabela do Financeiro FINDES" + SubStr( cFolMes, 5, 2 )  +  SubStr( cFolMes, 1, 4 ) + " gravada na pasta system"//"- Verifique a tabela do Financeiro FINDES"##" gravada na pasta system"
							   IF aScan( aLog[2], {|x| x == cTextoLog } ) == 0
								   aAdd( aLog[2], cTextoLog )
							   EndIF		
		            	   //Se verifica Faturamento e/ou Financeiro
		            	Else
							   //Entra na funcao do Faturamento para buscar os valores das notas fiscais de saida
							   //na tabela SD2 para verificar o faturamento da filial na competencia. A funcao
							   //do faturamento retorna os dados gravados em um alias temporario
							   cSvFilAnt := cFilAnt
							   cFilAnt	  := aFilProc[nFilial, 1]
							   cAliasFat := U_RhInssPatb( cMesAno, aFilProc[nFilial, 1] )
							   cFilAnt	  := cSvFilAnt
							   If !Empty( cAliasFat )
								   dbSelectArea( cAliasFat )
								   (cAliasFat)->( dbGoTop() )
								   While (cAliasFat)->( !EoF() )
					                cCodAti		:= (cAliasFat)->CODATV
					                cTipFat 	:= "1"
					                nAliq		:= SpedPCCG1( cCodAti, dDataRef )
					                nFatTot 	:= (cAliasFat)->TOTAL		// Total
					                nFatTotDev 	:= (cAliasFat)->TOTALDEV	// Total devolucao
					                nFatTotExp 	:= (cAliasFat)->TOTALEXP   	// Total exportacao
					                nFatRec		:= (cAliasFat)->TOTCODAT	// Total do codigo de atividade
					                nFatExc		:= (cAliasFat)->TCATVDEV	// Total devolucoes do codigo de atividade
					                nFatExp		:= (cAliasFat)->TCATVEXP	// Total exportacoes do codigo de atividade
					                nFatDExp	:= (cAliasFat)->TCATVDVEX	// Total devolucoes de exportacoes do codigo de atividade
					                nFatBas 	:= (cAliasFat)->TCDEVEXP 	// Total codigo de atividade - devolucoes - exportacoes (base calculo)
                                    //Calcula a contribuicao com base na aliquota encontrada
					                If nAliq > 0
						                nContr	:= ( nFatBas * ( nAliq/100 ) )
						  			    EndIf
					                //Grava a informacao do recolhimento devido na tabela auxiliar S033.
									    If nFatBas > 0
										    fGravaS033( aFilProc[nFilial, 1], cFolMes, cCodAti, cTipFat, nFatBas, nAliq, nContr, nFatRec, nFatExc, nFatExp, aTabS033 )
										    //Chama fCarrTab para recarregar tabela auxiliar S033
										    aTabS033 := {}
										    fCarrTab( @aTabS033, "S033", dDataRef )
									    Else
									       //Senao tiver faturamento com produtos com cod atividade, mas tiver algum faturamento gravar tabela S033, com tipo 2 (produtos nao desonerados)
										    If nFatTot > 0 .Or. nFatTotDev > 0 
											    If Empty(cCodAti) 
												    cTipFat 	:= "2"
											    Else
												    cTipFat 	:= "1"
											    EndIf
											    fGravaS033( aFilProc[nFilial, 1], cFolMes, cCodAti, cTipFat, nFatBas, nAliq, nContr, nFatRec, nFatExc, nFatExp, aTabS033 )
											    //Chama fCarrTab para recarregar tabela auxiliar S033
											    aTabS033 := {}
											    fCarrTab( @aTabS033, "S033", dDataRef )   
										    EndIf
									    EndIf
									    (cAliasFat)->( dbSkip() )
								   End While
								   //Faz a totalizacao da faturamento da filial gravadas na tabela S033
								   aEval(aTabS033, {|aTabS033| If( aTabS033[2] + aTabS033[6] == aFilProc[nFilial, 1] + "1", nTotCont += aTabS033[10], Nil ) } )
								   aEval(aTabS033, {|aTabS033| If( aTabS033[2] + aTabS033[6] == aFilProc[nFilial, 1] + "1", nTotDev += aTabS033[11], Nil ) } )
								   aEval(aTabS033, {|aTabS033| If( aTabS033[2] + aTabS033[6] == aFilProc[nFilial, 1] + "1", nTotExp += aTabS033[12], Nil ) } )
								   //Entra na funcao do Financeiro para buscar os valores dos titulos de acordo
								   //com a filial logada. A funcao nao permite passar a filial como parametro
								   //entao a variavel cFilAnt sera alterada de acordo com a filial em processamento.
								   //A funcao retorna o valor da receita total.						
								   If nVerFatFin == 4
									   cSvFilAnt := cFilAnt
									   cFilAnt	  := aFilProc[nFilial, 1]
									   nFatTot   += FTotF100( Val( SubStr( cFolMes, 5, 2 ) ), Val( SubStr( cFolMes, 1, 4 ) ) )
									   cFilAnt	  := cSvFilAnt
						            cTextoLog := "- Verifique a tabela do Financeiro FINDES" + SubStr( cFolMes, 5, 2 )  +  SubStr( cFolMes, 1, 4 ) + " gravada na pasta system"//"- Verifique a tabela do Financeiro FINDES"##" gravada na pasta system"
									   IF aScan( aLog[2], {|x| x == cTextoLog } ) == 0
										   aAdd( aLog[2], cTextoLog )
									   EndIF
								   EndIf
								   //Se o total de faturamento da filial for maior do que os registros gravados
								   //significa que ha faturamento de atividades que nao estao enquadradas na Lei
								   //Esse registro deve ser gravado na tabela auxiliar com o tipo de receita 2
								   If nFatTot > nTotCont
									   fGravaS033( aFilProc[nFilial, 1], cFolMes, Nil, "2", ( nFatTot - nTotCont - ( nFatTotDev - nTotDev ) - ( nFatTotExp - nTotExp ) ), 0.00, 0.00, ( nFatTot - nTotCont ), ( nFatTotDev - nTotDev ), ( nFatTotExp - nTotExp ), aTabS033 )					
								   EndIf
								   (cAliasFat)->( dbCloseArea() )
					             cTextoLog := "- Verifique a tabela do Faturamento FATDES" + SubStr( cFolMes, 5, 2 )  +  SubStr( cFolMes, 1, 4 ) + " gravada na pasta system" //"- Verifique a tabela do Faturamento FATDES"##" gravada na pasta system"
								   IF aScan( aLog[2], {|x| x == cTextoLog } ) == 0
									   aAdd( aLog[2], cTextoLog )
							 	   EndIF
							   EndIf
						   EndIf			            	
		            	//Sai do For dos tipos de contratos pois ja alimentou a S033 com os valores da competencia
		            	Exit
	            	Else
			            cTextoLog := "- Filial: " + aFilProc[nFilial, 1] + OemToAnsi(" já possui informações na tabela S033. Verifique os registros existentes.")//"- Filial: "##" já possui informações na tabela S033. Verifique os registros existentes."
						   IF aScan( aLog[2], {|x| x == cTextoLog } ) == 0
							   aAdd( aLog[2], cTextoLog )
						   EndIF
	            	EndIf
				EndIf
			Next nTpContr	
		EndIf
	Next nFilial

	//Chama fCarrTab para recarregar tabela auxiliar S033
	aTabS033 := {}
	fCarrTab( @aTabS033, "S033", dDataRef )
EndIf

#IFDEF TOP
	If !ExeInAs400()
		cAliasSRA 	:= "QSRA"
		If ( Select( cAliasSRA ) > 0 )
			( cAliasSRA )->( dbCloseArea() )
		EndIf 
		cCposQuery 	:= "SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_NOME, SRA.RA_CC, SRA.RA_CATFUNC, SRA.RA_TPCONTR"
		If lTemInssAut
			cCposQuery += ", SRA.RA_INSSAUT"
		EndIf
		If lTemItem
			cCposQuery += ", SRA.RA_ITEM"				
		EndIf
		If lTemClvl
			cCposQuery += ", SRA.RA_CLVL"		
		EndIf
		cCposQuery := "% " + cCposQuery + " %"
		cCatQuery   := "%"

		For nReg := 1 to Len(cCateg) 
			If Subs(cCateg,nReg,1) # "*" .and. Subs(cCateg,nReg,1) # " "
				aAdd(aCateg,Subs(cCateg,nReg,1))
			Endif
			cCatQuery += "'"+Subs(cCateg,nReg,1)+"'"
			If ( nReg+1 ) <= Len(cCateg)
				cCatQuery += "," 
			Endif
		Next nReg

		cCatQuery += "%"		
		
		BeginSql alias cAliasSRA
			SELECT %exp:cCposQuery%
			FROM %table:SRA% SRA
			WHERE  SRA.RA_FILIAL BETWEEN %exp:cFilialDe% AND %exp:cFilialAte% 
				   AND SRA.RA_MAT BETWEEN %exp:cMatDe% AND %exp:cMatAte%
				   AND SRA.RA_CATFUNC IN (%exp:Upper(cCatQuery)%) 
   				   AND SRA.%notDel%
			ORDER BY SRA.RA_FILIAL, SRA.RA_MAT 
		EndSql

		BeginSql alias cAliasTMP
			SELECT COUNT(*) as NROREG 
			FROM %table:SRA% SRA
			WHERE  SRA.RA_FILIAL BETWEEN %exp:cFilialDe% AND %exp:cFilialAte% 
				   AND SRA.RA_MAT BETWEEN %exp:cMatDe% AND %exp:cMatAte%
				   AND SRA.RA_CATFUNC IN (%exp:Upper(cCatQuery)%) 
   				   AND SRA.%notDel%
		EndSql

		While (cAliasTMP)->( !Eof() )
			nRegProc += (cAliasTMP)->(NROREG)
			(cAliasTMP)->( dbSkip() )
		Enddo        
		( cAliasTMP )->( dbCloseArea() )
	Else
		dbSelectArea( "SRA" )
		nRegProc := (cAliasSRA)->( RecCount() )		
		( cAliasSRA )->( dbGoTop() )
	EndIf
#Else
	dbSelectArea( "SRA" )
	nRegProc := (cAliasSRA)->( RecCount() )		
	( cAliasSRA )->( dbGoTop() )
#ENDIF

//Inicia a regua de processamento
If lVersao101
	oSelf:SaveLog( "Desoneração da Folha de Pagamento" + " - " + "Inicio do processamento" ) //"Desoneração da Folha de Pagamento"##"Inicio do processamento"
	oSelf:SetRegua1(nRegProc) 
Else	
	GPProcRegua(nRegProc)
EndIf

Begin Sequence
	//Faz o While dos funcionarios selecionadas na parametrizacao
	While ( cAliasSRA )->( !EoF() .And. ( cAliasSRA )->RA_FILIAL + ( cAliasSRA )->RA_MAT <= cFilialAte + cMatAte )
		//Aborta o Calculo
		If lVersao101
			If oSelf:lEnd 
				Break
			EndIf
		Else
			If lAbortPrint
				Break
			Endif
	  	EndIf

		//Valida categoria do funcionario	
		If !( ( cAliasSRA )->RA_CATFUNC $ cCateg )
			( cAliasSRA )->( dbSkip() )
			Loop
		Endif

	    //Atualiza regua de processamento
		If lVersao101
			oSelf:IncRegua1( OemToAnsi("Verificando o funcionário: ") + ( cAliasSRA )->RA_FILIAL + " - " + ( cAliasSRA )->RA_MAT + " - " + ( cAliasSRA )->RA_NOME )//"Verificando o funcionário: "
	    Else
   			GPIncProc( ( cAliasSRA )->RA_FILIAL + " - " + ( cAliasSRA )->RA_MAT + " - " + ( cAliasSRA )->RA_NOME )
        EndIf

        //Se a filial for diferente da interior, carrega codigo de verbas e parametro 14
		If cLastFil != ( cAliasSRA )->RA_FILIAL
			cLastFil := ( cAliasSRA )->RA_FILIAL
			FP_CODFOL( @aCodFol, ( cAliasSRA )->RA_FILIAL )
			fInssEmp( ( cAliasSRA )->RA_FILIAL, @aTabInss, Nil, cFolMes )
		EndIf

		//Reinicializa variaveis
		cTpC		:= If( ( cAliasSRA )->RA_TPCONTR $ " *1", "1", "2" )
		cRecFatEmp 	:= aTabInss[27, Val( cTpC )]//X14_RECFAT
		nAv13Des 	:= 0
		nAv13Resc	:= 0
		nBaseINSS	:= 0
		nSalCont    := 0
		nSalCon13	:= 0
		nValBasInss	:= 0
		nVl13Des	:= 0
		nVl13Resc	:= 0

        //Somente faz o calculo quando recolher a contribuicao previdenciaria sobre o faturamento
		If cRecFatEmp $ "S*M"
			//Se for calculo sobre folha
			If nCalc == 1
				#IFDEF TOP
					If !ExeInAs400()
						cAliasSRC 	:= "QSRCDES"
						If ( Select( cAliasSRC ) > 0 )
							( cAliasSRC )->( dbCloseArea() )
						EndIf 
						cCposQuery := "% "
				  		For nField := 1 To nSrcFields
							cCposQuery += aSrcFields[ nField , 01 ] + ", "
						Next nField
						cCposQuery += "R_E_C_N_O_ RECNO %"
						cWhere		:=	" ( SRC.RC_FILIAL = '" + ( cAliasSRA )->RA_FILIAL + "' AND SRC.RC_MAT = '" + ( cAliasSRA )->RA_MAT + "' AND " +;
										" SRC.RC_PD IN ('" + aCodFol[013,1] + "', '" + aCodFol[014,1] + "', '" + aCodFol[019,1] + "', '" + aCodFol[020,1] + "', '" +;
														aCodFol[114,1] + "', '" + aCodFol[221,1] + "', '" + aCodFol[225,1] + "', '" + aCodFol[318,1] + "', '" +;
														aCodFol[338,1] + "', '" + aCodFol[350,1] + "', '" + aCodFol[353,1] + "', '" + aCodFol[399,1] + "', '" +;
														aCodFol[991,1] + "' ) ) "
						cWhere		:= "%" + cWhere + "%"
						
						BeginSql alias cAliasSRC
							SELECT %exp:cCposQuery%
							FROM %table:SRC% SRC
							WHERE  %exp:cWhere%
				   				   AND SRC.%notDel%
							ORDER BY SRC.RC_FILIAL, SRC.RC_MAT, SRC.RC_PD 
						EndSql
		
						For nField := 1 To nSrcFields
							IF !( aSrcFields[ nField , 02 ] == "C" )
								TcSetField(cAliasSRC,aSrcFields[nField,01],aSrcFields[nField,02],aSrcFields[nField,03],aSrcFields[nField,04])
							EndIF
						Next nField 
					Else
						dbSelectArea( "SRC" )
						( cAliasSRC )->( dbGoTop() )  
						( cAliasSRC )->( dbSeek( ( cAliasSRA )->RA_FILIAL + ( cAliasSRA )->RA_MAT ) )  
					EndIf
				#Else
					dbSelectArea( "SRC" )
					( cAliasSRC )->( dbGoTop() )
					( cAliasSRC )->( dbSeek( ( cAliasSRA )->RA_FILIAL + ( cAliasSRA )->RA_MAT ) )  
				#ENDIF		
	       
				//Faz o While dos lancamentos mensais do funcionario para encontrar a base de calculo
				//para apuracao da contribuicao previdenciaria
				While ( cAliasSRC )->( !EoF() .And. ( cAliasSRC )->RC_FILIAL + ( cAliasSRC )->RC_MAT == ( cAliasSRA )->RA_FILIAL + ( cAliasSRA )->RA_MAT )
					If ( cAliasSRC )->RC_PD == aCodFol[013,1]//Sal Contr. Ate Limite Base
					    nSalCont +=  ( cAliasSRC )->RC_VALOR
					ElseIf ( cAliasSRC )->RC_PD == aCodFol[014,1]//Sal Contr. Acima Limite Base
						nSalCont +=  ( cAliasSRC )->RC_VALOR
					ElseIf ( cAliasSRC )->RC_PD == aCodFol[019,1]//Base Inss Ate Lim p/ 13o. Sal.
						nSalCon13 +=  ( cAliasSRC )->RC_VALOR
					ElseIf ( cAliasSRC )->RC_PD == aCodFol[020,1]//Base Inss Aci Lim p/ 13o. Sal.
						nSalCon13 +=  ( cAliasSRC )->RC_VALOR
					ElseIf ( cAliasSRC )->RC_PD == aCodFol[114,1]//13§ na Indenizacao Rescisao
						nAv13Resc  :=  Int( ( cAliasSRC )->RC_HORAS )
						nVl13Resc  :=  ( cAliasSRC )->RC_VALOR
					ElseIf ( cAliasSRC )->RC_PD == aCodFol[221,1]//Base Inss Aut./Pro-Labore 15%
						nSalCont +=  ( cAliasSRC )->RC_VALOR
					ElseIf ( cAliasSRC )->RC_PD == aCodFol[225,1]//Base Inss Aut./Pro-Labore 20%
						nSalCont +=  ( cAliasSRC )->RC_VALOR
					ElseIf ( cAliasSRC )->RC_PD == aCodFol[318,1]//Salario do Mes
						dDataPg := ( cAliasSRC )->RC_DATA
					ElseIf ( cAliasSRC )->RC_PD == aCodFol[338,1]//Base de INSS Diferenca de Dissidio
						nSalCont +=  ( cAliasSRC )->RC_VALOR
					ElseIf ( cAliasSRC )->RC_PD == aCodFol[350,1]//Base do INSS P.FISICA
						nSalCont +=  ( cAliasSRC )->RC_VALOR
					ElseIf ( cAliasSRC )->RC_PD == aCodFol[353,1]//Base de INSS P.JURIDICA
						nSalCont +=  ( cAliasSRC )->RC_VALOR
					ElseIf ( cAliasSRC )->RC_PD == aCodFol[399,1]//Base de INSS Diferenca de Dissidio 13o
						nSalCont +=  ( cAliasSRC )->RC_VALOR
					ElseIf ( cAliasSRC )->RC_PD == aCodFol[991,1]//Base Inss Antes Desoneracao p/ 13o. Sal.
						nAv13Des  :=  Int( ( cAliasSRC )->RC_HORAS )
						nVl13Des  :=  ( cAliasSRC )->RC_VALOR
					EndIf
					( cAliasSRC )->( !dbSkip() )
				End While
	
				//Calcula a aliquota reduzida que sera aplicada na base do INSS e os valores das receitas
				aCalcDes    := U_fPerFatEmp( cRecFatEmp, 0, aTabInss[ 1, Val( cTpC ) ], aTabS033 )
	         nPerFatEmp 	:= aCalcDes[1]//Aliquota reduzida
				nRecOut		:= aCalcDes[2]//Receitas de outras atividades
				nRecBruto	:= aCalcDes[3]//Receita bruta
				nRecDes		:= aCalcDes[4]//Receitas de atividades desoneradas
				
				//Cria o resumo das bases de calculo utilizadas para encontrar a aliquota reduzida no calculo misto
				If cRecFatEmp == "M" .And. !lLogRec
					lLogRec := .T.
					//Valida se o percentual reduzido e' maior do que zero e exibe o calculo efetuado para encontrar o %
					If nPerFatEmp > 0
						aAdd( aLog[1], OemToAnsi("Composição do cálculo para apurar a alíquota reduzida: ") )//"Composição do cálculo para apurar a alíquota reduzida: "
						aAdd( aLog[1], OemToAnsi(" - Receitas de outras atividades (Tipo 2): R$ ") + cValToChar( Transform( nRecOut, "@E 99,999,999,999.99" ) ) )//" - Receitas de outras atividades (Tipo 2): R$ "
						aAdd( aLog[1], OemToAnsi(" - Receita bruta total: R$ ") + cValToChar( Transform( nRecBruto, "@E 99,999,999,999.99" ) ) )//" - Receita bruta total: R$ "
						aAdd( aLog[1], OemToAnsi(" - Receitas de outras atividades / Receita bruta total: R$ ") + cValToChar( Transform( nRecOut, "@E 99,999,999,999.99" ) ) + " / R$ " + cValToChar( Transform( nRecBruto, "@E 99,999,999,999.99" ) ) + " = " + cValToChar( nRecOut/nRecBruto ) )//" - Receitas de outras atividades / Receita bruta total: R$ "
						aAdd( aLog[1], OemToAnsi(" - Coeficiente de redução: ") + cValToChar( nRecOut/nRecBruto ) )//" - Coeficiente de redução: "
						aAdd( aLog[1], OemToAnsi(" - Alíquota padrão: ") + cValToChar( aTabInss[ 1, Val( cTpC ) ] * 100 ) + " %" )//" - Alíquota padrão: "
						aAdd( aLog[1], OemToAnsi(" - Coeficiente de redução X Alíquota Padrão: ") + cValToChar( nRecOut/nRecBruto ) + " X " + cValToChar( aTabInss[ 1, Val( cTpC ) ] * 100 ) + " % = " + cValToChar( Round( nPerFatEmp * 100, 6 ) ) + " %" )//" - Coeficiente de redução X Alíquota Padrão: "
						aAdd( aLog[1], OemToAnsi(" - Alíquota reduzida: ") + cValToChar( Round( nPerFatEmp * 100, 6 ) ) + " %" )//" - Alíquota reduzida: "
					//Exibe a mensagem que nao sera efetuado o calculo da contribuicao patronal sobre a folha devido o %
					Else
						aAdd( aLog[1], OemToAnsi("Cálculo sobre a folha de pagamento NÃO será efetuado") + " " + OemToAnsi("pois a receita desonerada ultrapassou o limite de 95%") )//"Cálculo sobre a folha de pagamento NÃO será efetuado"##"pois a receita desonerada ultrapassou o limite de 95%"
						aAdd( aLog[1], OemToAnsi("em relação a receita total:") )//"em relação a receita total:"
						aAdd( aLog[1], OemToAnsi(" - Receitas de atividades desoneradas (Tipo 1): R$ ") + cValToChar( Transform( nRecDes, "@E 99,999,999,999.99" ) ) )//" - Receitas de atividades desoneradas (Tipo 1): R$ "
						aAdd( aLog[1], OemToAnsi(" - Receita bruta total: R$ ") + cValToChar( Transform( nRecBruto, "@E 99,999,999,999.99" ) ) )//" - Receita bruta total: R$ "
						aAdd( aLog[1], OemToAnsi(" - Receitas de atividades desoneradas / Receita bruta total: R$ ") + cValToChar( Transform( nRecDes, "@E 99,999,999,999.99" ) ) + " / R$ " + cValToChar( Transform( nRecBruto, "@E 99,999,999,999.99" ) ) + " = " + cValToChar( nRecDes/nRecBruto ) )//" - Receitas de atividades desoneradas / Receita bruta total: R$ "
						aAdd( aLog[1], OemToAnsi(" - Percentual: ") + cValToChar( ( nRecDes/nRecBruto ) * 100 ) + " %" )//" - Percentual: "
					EndIf
				EndIf
				
		        //Quando a empresa tiver faturamento misto, deve aplicar a aliquota reduzida no salario do mes 
		        //+ os avos de 13 adquiridos apos o inicio da desoneracao da folha
		        If cRecFatEmp == "M"
			        nBaseINSS := Round( nSalCont + ( nSalCon13 - nVl13Des ), 2 )
		        //Quando a empresa tiver faturamento exclusivo sobre o faturamento, nao deve calcular a
		        //contribuicao sobre a folha
		        Else
			        nBaseINSS := 0.00	        
		        EndIf
	
		        //Aplica a base do salario do mes na aliquota reduzida
				nContInss := Round( nBaseINSS * nPerFatEmp, 2)
				//O valor dos avos de 13o. adquiridos antes do inicio da desoneracao tem tributacao antiga
				nCont13  :=  Round( nVl13Des * aTabInss[1, Val( cTpC )], 2 )       
				//A contribuicao previdenciaria sera a soma dos dois calculos        
				nContrib := ( nContInss + nCont13 )
	
		    	//Somente gera o ID 148 se estiver configurado para calcular a contribuicao previdenciaria
		    	If nContrib > 0 .And. ( !lTemInssAut .Or. ( lTemInssAut .And. ( cAliasSRA )->RA_INSSAUT != "N" ) )
	                 If !( SRC->( dbSeek( ( cAliasSRA )->RA_FILIAL + ( cAliasSRA )->RA_MAT + aCodFol[148,1] ) ) )
	                 	If SRC->( Reclock("SRC", .T., .T.) )
	                 		SRC->RC_FILIAL 	:= ( cAliasSRA )->RA_FILIAL
	                 		SRC->RC_MAT		:= ( cAliasSRA )->RA_MAT   
	                 		SRC->RC_PD		:= aCodFol[148,1]
	                 		SRC->RC_TIPO1 	:= "V"
	                 		SRC->RC_VALOR	:= nContrib
	                 		SRC->RC_DATA	:= dDataPg
	                 		SRC->RC_CC		:= ( cAliasSRA )->RA_CC
	                 		SRC->RC_TIPO2	:= "C"
	                 		If lTemItem
	                 			SRC->RC_ITEM	:= ( cAliasSRA )->RA_ITEM
	                 		EndIf
	                 		If lTemClvl
	                 			SRC->RC_CLVL   	:= ( cAliasSRA )->RA_CLVL
	                 		EndIf
	                 		SRC->( MsUnlock() )
	                 	EndIF
	                 Else
	                 	If SRC->( Reclock("SRC", .F., .T.) )
	                 		SRC->RC_VALOR := nContrib
	                 		SRC->( MsUnlock() )
	                 	EndIF                 
	                 EndIf
		    	EndIf		
			//Se for calculo sobre 2a. parcela do 13o. salario
            Else
				#IFDEF TOP
					If !ExeInAs400()
						cAliasSRI 	:= "QSRIDES"
						If ( Select( cAliasSRI ) > 0 )
							( cAliasSRI )->( dbCloseArea() )
						EndIf 
						cCposQuery := "% "
				  		For nField := 1 To nSriFields
							cCposQuery += aSriFields[ nField , 01 ] + ", "
						Next nField
						cCposQuery += "R_E_C_N_O_ RECNO %"
						cWhere		:=	" ( SRI.RI_FILIAL = '" + ( cAliasSRA )->RA_FILIAL + "' AND SRI.RI_MAT = '" + ( cAliasSRA )->RA_MAT + "' AND " +;
										" SRI.RI_PD IN ('" + aCodFol[019,1] + "', '" + aCodFol[020,1] + "', '" + aCodFol[024,1] + "', '" + aCodFol[991,1] + "' ) ) "
						cWhere		:= "%" + cWhere + "%"
						
						BeginSql alias cAliasSRI
							SELECT %exp:cCposQuery%
							FROM %table:SRI% SRI
							WHERE  %exp:cWhere%
				   				   AND SRI.%notDel%
							ORDER BY SRI.RI_FILIAL, SRI.RI_MAT, SRI.RI_PD 
						EndSql
		
						For nField := 1 To nSriFields
							IF !( aSrcFields[ nField , 02 ] == "C" )
								TcSetField(cAliasSRI,aSriFields[nField,01],aSriFields[nField,02],aSriFields[nField,03],aSriFields[nField,04])
							EndIF
						Next nField 
	
						BeginSql alias cAliasTMP
							SELECT COUNT(*) as NROREG 
							FROM %table:SRI% SRI
							WHERE  %exp:cWhere%
				   				   AND SRI.%notDel%
						EndSql
				
						While (cAliasTMP)->( !Eof() )
							(cAliasTMP)->( dbSkip() )
						Enddo        
						( cAliasTMP )->( dbCloseArea() )
	
					Else
						dbSelectArea( "SRI" )
						( cAliasSRI )->( dbGoTop() )  
						( cAliasSRI )->( dbSeek( ( cAliasSRA )->RA_FILIAL + ( cAliasSRA )->RA_MAT ) )  
					EndIf
				#Else
					dbSelectArea( "SRI" )
					( cAliasSRI )->( dbGoTop() )
					( cAliasSRI )->( dbSeek( ( cAliasSRA )->RA_FILIAL + ( cAliasSRA )->RA_MAT ) )  
				#ENDIF	
	
				//Reinicializa variaveis
				nAv13Des 	:= 0
				nBaseINSS	:= 0
				nSalCon13	:= 0
				nVl13Des	:= 0

				//Faz o While dos lancamentos mensais do funcionario para encontrar a base de calculo
				//para apuracao da contribuicao previdenciaria
				While ( cAliasSRI )->( !EoF() .And. ( cAliasSRI )->RI_FILIAL + ( cAliasSRI )->RI_MAT == ( cAliasSRA )->RA_FILIAL + ( cAliasSRA )->RA_MAT )
					If ( cAliasSRI )->RI_PD == aCodFol[019,1]//Base Inss Ate Lim p/ 13o. Sal.
						nSalCon13 +=  ( cAliasSRI )->RI_VALOR
					ElseIf ( cAliasSRI )->RI_PD == aCodFol[020,1]//Base Inss Aci Lim p/ 13o. Sal.
						nSalCon13 +=  ( cAliasSRI )->RI_VALOR
					ElseIf ( cAliasSRI )->RI_PD == aCodFol[024,1]//Parcela Final 13§ Sal
						dDataPg := ( cAliasSRI )->RI_DATA
					ElseIf ( cAliasSRI )->RI_PD == aCodFol[991,1]//Base Inss Antes Desoneracao p/ 13o. Sal.
						nAv13Des  :=  Int( ( cAliasSRI )->RI_HORAS )
						nVl13Des  :=  ( cAliasSRI )->RI_VALOR
					EndIf
					( cAliasSRI )->( dbSkip() )
				End While
	
				//Calcula a aliquota reduzida que sera aplicada na base do INSS e os valores das receitas
				aCalc13 	:= fPerFatEmp( cRecFatEmp, 0, aTabInss[ 1, Val( cTpC ) ], aTab13Sal, Nil, .T. )
	           	nPer13Sal 	:= aCalc13[5]//Aliquota reduzida
				nRecOut13	:= aCalc13[6]//Receitas de outras atividades
				nRecBru13	:= aCalc13[7]//Receita bruta
				nRecDes13	:= aCalc13[8]//Receitas de atividades desoneradas
				
				//Cria o resumo das bases de calculo utilizadas para encontrar a aliquota reduzida no calculo misto
				If cRecFatEmp == "M" .And. !lLogRec13
					lLogRec13 := .T.
					//Valida se o percentual reduzido e' maior do que zero e exibe o calculo efetuado para encontrar o %
					If nPer13Sal > 0
						aAdd( aLog[3], OemToAnsi("Composição do cálculo para apurar a alíquota reduzida: ") )//"Composição do cálculo para apurar a alíquota reduzida: "
						aAdd( aLog[3], OemToAnsi(" - Receitas de outras atividades (Tipo 2): R$ ") + cValToChar( Transform( nRecOut13, "@E 99,999,999,999.99" ) ) )//" - Receitas de outras atividades (Tipo 2): R$ "
						aAdd( aLog[3], OemToAnsi(" - Receita bruta total: R$ ") + cValToChar( Transform( nRecBru13, "@E 99,999,999,999.99" ) ) )//" - Receita bruta total: R$ "
						aAdd( aLog[3], OemToAnsi(" - Receitas de outras atividades / Receita bruta total: R$ ") + cValToChar( Transform( nRecOut13, "@E 99,999,999,999.99" ) ) + " / R$ " + cValToChar( Transform( nRecBru13, "@E 99,999,999,999.99" ) ) + " = " + cValToChar( nRecOut13/nRecBru13 ) )//" - Receitas de outras atividades / Receita bruta total: R$ "
						aAdd( aLog[3], OemToAnsi(" - Coeficiente de redução: ") + cValToChar( nRecOut13/nRecBru13 ) )//" - Coeficiente de redução: "
						aAdd( aLog[3], OemToAnsi(" - Alíquota padrão: ") + cValToChar( aTabInss[ 1, Val( cTpC ) ] * 100 ) + " %" )//" - Alíquota padrão: "
						aAdd( aLog[3], OemToAnsi(" - Coeficiente de redução X Alíquota Padrão: ") + cValToChar( nRecOut13/nRecBru13 ) + " X " + cValToChar( aTabInss[ 1, Val( cTpC ) ] * 100 ) + " % = " + cValToChar( Round( nPer13Sal * 100, 6 ) ) + " %" )//" - Coeficiente de redução X Alíquota Padrão: "
						aAdd( aLog[3], OemToAnsi(" - Alíquota reduzida: ") + cValToChar( Round( nPer13Sal * 100, 6 ) ) + " %" )//" - Alíquota reduzida: "
					//Exibe a mensagem que nao sera efetuado o calculo da contribuicao patronal sobre a folha devido o %
					Else
						aAdd( aLog[3], OemToAnsi("Cálculo sobre a folha de pagamento NÃO será efetuado") + " " + OemToAnsi("pois a receita desonerada ultrapassou o limite de 95%") )//"Cálculo sobre a folha de pagamento NÃO será efetuado"##"pois a receita desonerada ultrapassou o limite de 95%"
						aAdd( aLog[3], OemToAnsi("em relação a receita total:") )//"em relação a receita total:"
						aAdd( aLog[3], OemToAnsi(" - Receitas de atividades desoneradas (Tipo 1): R$ ") + cValToChar( Transform( nRecDes13, "@E 99,999,999,999.99" ) ) )//" - Receitas de atividades desoneradas (Tipo 1): R$ "
						aAdd( aLog[3], OemToAnsi(" - Receita bruta total: R$ ") + cValToChar( Transform( nRecBru13, "@E 99,999,999,999.99" ) ) )//" - Receita bruta total: R$ "
						aAdd( aLog[3], OemToAnsi(" - Receitas de atividades desoneradas / Receita bruta total: R$ ") + cValToChar( Transform( nRecDes13, "@E 99,999,999,999.99" ) ) + " / R$ " + cValToChar( Transform( nRecBru13, "@E 99,999,999,999.99" ) ) + " = " + cValToChar( nRecDes13/nRecBru13 ) )//" - Receitas de atividades desoneradas / Receita bruta total: R$ "
						aAdd( aLog[3], OemToAnsi(" - Percentual: ") + cValToChar( ( nRecDes13/nRecBru13 ) * 100 ) + " %" )//" - Percentual: "
					EndIf
				EndIf
	
		        //Quando a empresa tiver faturamento misto, deve aplicar a aliquota reduzida no salario do mes 
		        //+ os avos de 13 adquiridos apos o inicio da desoneracao da folha
		        If cRecFatEmp == "M"
			        nBaseINSS := Round( nSalCon13 - nVl13Des, 2 )
		        //Quando a empresa tiver faturamento exclusivo sobre o faturamento, nao deve calcular a
		        //contribuicao sobre a folha
		        Else
			        nBaseINSS := 0.00	        
		        EndIf
	
		        //Aplica a base do salario do mes na aliquota reduzida
				nContInss := Round( nBaseINSS * nPer13Sal, 2)
				//O valor dos avos de 13o. adquiridos antes do inicio da desoneracao tem tributacao antiga
				nCont13  :=  Round( nVl13Des * aTabInss[1, Val( cTpC )], 2 )       
				//A contribuicao previdenciaria sera a soma dos dois calculos        
				nContrib := ( nContInss + nCont13 )
	
		    	//Somente gera o ID 148 se estiver configurado para calcular a contribuicao previdenciaria
		    	If nContrib > 0 .And. ( !lTemInssAut .Or. ( lTemInssAut .And. ( cAliasSRA )->RA_INSSAUT != "N" ) )
	                 If !( SRI->( dbSeek( ( cAliasSRA )->RA_FILIAL + ( cAliasSRA )->RA_MAT + aCodFol[148,1] ) ) )
	                 	If SRI->( Reclock("SRI", .T., .T.) )
	                 		SRI->RI_FILIAL 	:= ( cAliasSRA )->RA_FILIAL
	                 		SRI->RI_MAT		:= ( cAliasSRA )->RA_MAT   
	                 		SRI->RI_PD		:= aCodFol[148,1]
	                 		SRI->RI_TIPO1 	:= "V"
	                 		SRI->RI_VALOR	:= nContrib
	                 		SRI->RI_DATA	:= dDataPg
	                 		SRI->RI_CC		:= ( cAliasSRA )->RA_CC
	                 		SRI->RI_TIPO2	:= "S"
	                 		If lTemItem
	                 			SRI->RI_ITEM	:= ( cAliasSRA )->RA_ITEM
	                 		EndIf
	                 		If lTemClvl
	                 			SRI->RI_CLVL   	:= ( cAliasSRA )->RA_CLVL
	                 		EndIf
	                 		SRI->( MsUnlock() )
	                 	EndIF
	                 Else
	                 	If SRI->( Reclock("SRI", .F., .T.) )
	                 		SRI->RI_VALOR := nContrib
	                 		SRI->( MsUnlock() )
	                 	EndIF                 
	                 EndIf
		    	EndIf            
            EndIf
		Else
            cTextoLog := '- Filial: ' + ( cAliasSRA )->RA_FILIAL + " configurada para não recolher contribuição sobre o faturamento." 
			IF aScan( aLog[2], {|x| x == cTextoLog } ) == 0
				aAdd( aLog[2], cTextoLog )
			EndIF		
		EndIf
		( cAliasSRA )->( dbSkip() )	
	End While
End Sequence

//Atualiza o log com a mensagem do termino do processamento
If lVersao101
	oSelf:SaveLog( "Desoneração da Folha de Pagamento" + " - " + "Termino do processamento" ) //"Desoneração da Folha de Pagamento"##"Termino do processamento"
EndIf	

RestArea(aArea)
RestArea(aAreaSM0)

Return()

/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o	   ³ GPM013Ok ³ Autor ³ Equipe de RH       	  ³ Data ³10/09/2012³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³ Confirmar as Configuracoes dos Parametros                  ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³ GPM013Ok()													³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³                                                            ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Uso	   ³ GPM013 												    ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Static Function GPM013Ok()
Return( MsgYesNo( OemToAnsi("Confirma configura‡„o dos parƒmetros teste?"), OemToAnsi("Aten‡„o") ) ) //"Confirma configura‡„o dos parƒmetros?"###"Aten‡„o"

/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o	   ³ fValSX1  ³ Autor ³ Equipe de RH       	  ³ Data ³26/11/2012³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³ Funcao para validar atualizacao de perguntas p/ desoneracao³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³ fValSX1()													³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³                                                            ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Uso	   ³ GPEM013 												    ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Static Function fValSX1()

Local aArea  := GetArea()
Local cPerg  := "GPM013"
Local lAchou := .F.               

dbSelectArea( "SX1" )
SX1->( dbSetOrder(1) )
If dbSeek( cPerg + Space( 10 - Len(cPerg) ) + "07")
	lAchou := .T. 
EndIf

RestArea(aArea)

Return(lAchou)
