User Function fPerFatEmp( cRecFat, nPerEmp, nPerX14, aTabS033, dDatabase, lCalc13Sal )
Local nAliqPad		:= 0

//private aTabS033	:= {}
//private	cRecFat	:= "S"
//private lCalc13Sal:= .F.
//private nPerEmp 	:= 0
//private nPerX14	:= 0.2

Static cDesFol		:= SuperGetMv("MV_DESFOL",,"")
Static dDataDes 	:= cToD( "01/" + SubStr( cDesFol, 5, 2 ) + "/" + SubStr( cDesFol, 1, 4 ) )
Static lCalc	  	:= .F.
Static lCalc13	  	:= .F.
Static nAliq		:= 0
Static nAliq13		:= 0
Static nFatDes		:= 0
Static nFatDes13	:= 0
Static nFatFol 		:= 0
Static nFatFol13	:= 0
Static nFatTot 		:= 0
Static nFatTot13	:= 0
Static nPercEmp     := 0

//Se a filial processada for diferente da ultima, apura os valores do faturamento e aliquota novamente
//Para o dissidio, sempre ira verificar a aliquota pois deve ser apurada em cada competencia de calculo
If lDissidio .Or. !lCalc .Or. !lCalc13 .Or. nPerX14 != nPercEmp
	nAliq 		:= 0
	nAliq13 	:= 0
	nFatDes		:= 0
	nFatDes13	:= 0
	nFatFol 	:= 0
	nFatFol13 	:= 0
	nFatTot		:= 0	
	nFatTot13	:= 0	
	
	//Se for o calculo da 2a. parcela do 13o. salario
	If lCalc13Sal
		lCalc13 := .T.
		//Apura a receita bruta total da empresa
		aEval(aTabS033, {|aTabS033| nFatTot13 += aTabS033[07] } )
		//Apura a receita bruta que e' sobre as atividades beneficiadas da Lei no. 12.546/2011
		aEval(aTabS033, {|aTabS033| If( aTabS033[6] == "1", nFatDes13 += aTabS033[07], ) } )
		//Apura a receita bruta que nao e' sobre as atividades beneficiadas da Lei no. 12.546/2011
		aEval(aTabS033, {|aTabS033| If( aTabS033[6] == "2", nFatFol13 += aTabS033[07], ) } )
	//Se for o calculo da folha
	Else
		lCalc := .T.
		//Apura a receita bruta total da empresa
		aEval(aTabS033, {|aTabS033| nFatTot += aTabS033[07] } )
		//Apura a receita bruta que e' sobre as atividades beneficiadas da Lei no. 12.546/2011
		aEval(aTabS033, {|aTabS033| If( aTabS033[6] == "1", nFatDes += aTabS033[07], ) } ) //aTabS033[10]
		//Apura a receita bruta que nao e' sobre as atividades beneficiadas da Lei no. 12.546/2011
		aEval(aTabS033, {|aTabS033| If( aTabS033[6] == "2", nFatFol += aTabS033[07], ) } )	
	EndIf

	//Verifica o percentual de recolhimento da contribuicao previdenciaria parametro X14_PEREMP
	If !Empty(nPerEmp)
		nAliqPad 	:= nPerEmp
	Else 
		nAliqPad := nPerX14
	EndIf

	//Verifica se houve faturamento de atividades nao beneficiadas na Lei 12.546/2011.
	//Se houver, calcula o novo percentual de desconta, caso contrario, retorna aliquota conforme validacao
	If nFatFol > 0 .Or. nFatFol13 > 0
		//Se for o calculo da 2a. parcela do 13o. salario
		If lCalc13Sal
			//Calcula a razao entre o faturamento de atividades diversas sobre o faturamento total
			nAliq13 := ( nFatFol13 / nFatTot13 )
			//Calcula o novo percentual de acordo com a razao encontrada e o percentual de recolhimento antigo
			//se a receita nao desonerada corresponder a mais que 5% do total, caso contratio a aliquota sera
			//zerada e nao sera recolhido contribuicao patronal sobre a 2a. parcela do 13o. salario
			If nAliq13 > 0.05 
				nAliq13 := ( ( nAliq13 * nAliqPad ) )
			Else
				nAliq13 := 0
			EndIf
		Else
			//Calcula a razao entre o faturamento de atividades diversas sobre o faturamento total
			nAliq 	:= ( nFatFol / nFatTot )		
			//Calcula o novo percentual de acordo com a razao encontrada e o percentual de recolhimento antigo
			//se a receita nao desonerada corresponder a mais que 5% do total, caso contratio a aliquota sera
			//zerada e nao sera recolhido contribuicao patronal sobre a folha de pagamento
			If nAliq > 0.05 
				nAliq := ( ( nAliq * nAliqPad ) )
			Else
				nAliq := 0
			EndIf
		EndIf
	Else
        //Quando for dissidio e a database for anterior ao inicio da desoneracao, calcular sobre os 20%
		If lDissidio .And. dDatabase < dDataDes
			nAliq := nAliqPad
		//Quando for dissidio e a database for superior ao inicio da desoneracao e a empresa for mista
		//deve calcular sobre os 20%
		ElseIf lDissidio .And. dDatabase > dDataDes .And. cRecFat == "M"
			nAliq := nAliqPad
		//Quando for dissidio e a database for superior ao inicio da desoneracao e a empresa for somente
		//sobre o faturamento, nao deve calcular imposto
		ElseIf lDissidio .And. dDatabase > dDataDes .And. cRecFat == "S"
			nAliq := 0
		//Quando somente houver receita desonerada e a empresa for mista, deve calcular os 20% sobre a folha
		ElseIf cRecFat == "M" .And. nFatDes > 0
			nAliq   := 0
			nAliq13 := 0
		//Quando nao houver faturamento e a empresa for mista, nao deve calcular imposto
		ElseIf cRecFat == "M"
			nAliq   := nAliqPad
			nAliq13 := nAliqPad
		//Quando nao houver faturamento e a empresa for exclusiva sobre faturamento, nao deve calcular imposto
		ElseIf cRecFat == "S"
			nAliq   := 0
			nAliq13 := 0
		EndIf
	EndIf
EndIf

nPercEmp 	:= nPerX14

Return( { nAliq, nFatFol, nFatTot, nFatDes, nAliq13, nFatFol13, nFatTot13, nFatDes13 } )