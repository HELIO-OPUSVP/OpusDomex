#INCLUDE "TOTVS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "AP5MAIL.CH"
         
/*          
+---------------------------------------------------------------------+
¦Class  ¦ xBol033    ¦ Autor: Paulo H. Alves        ¦ Data 07/11/2014 ¦
+-------+-------------------------------------------------------------¦
¦ Uso   ¦ Classe para geração de boletos em PDF						  ¦
+---------------------------------------------------------------------+
*/

Class xBol033

	Data cPortador	as String 
	Data cAgencia	as String
	Data cDVAg		as String
	Data cConta		as String
	Data cDVConta	as String
	Data cCarteira	as String
	Data nTamNNum	as Number
	Data cNumMoeda  as String
	Data cMsgBco	as String
	Data cDigito	as String
	
	Data nValor		as Number
	Data cValor		as String
		
	Data aArea		as Array
	Data cAlias		as String
	Data nRegs		as Number
	Data nBol		as Number
	
	Data cDiretorio	as String
	Data cNomeArq	as String
	
	Data cLogoEmp	as String
	Data cLogoBco	as String
	
	Data cNossoNum  as String
	Data pNossoNum  as String
	
	Data cServidor	as String
	Data lAutentic  as Boolean
	Data cContaEm	as String
	Data cPassEm	as String
	
	Data aEmpresa	as Array
	Data aTxt		as Array

	Method New() Constructor
	Method Destroy()
	
	Method SetTitulos(cPref, cNum, cTipo, cPrcDe, cPrcAte, cCliDe, cCliAte, cLjDe, cLjAte)
	Method SetDadosBanco()
	Method SetBanco(nRecSEE)
	Method SetEmpresa()
	Method TransfPortador()
	
	Method Gerar()
	Method GerarBoletos()
	Method ImpressaoBoleto()
	Method ApagarArquivo()
	
	Method SetDadosEmail()
	Method EnviarEmail(cTitulo, cTO, cCC, cBCC)
	Method ConteudoEmail(cTitulo)
	
	Method Modulo10(cLinha)
	Method Modulo11(cLinha)
	Method FatVencto()
	Method FormatData(cData)
	Method CodigoBarras()

	
EndClass
                                                 

Method New() Class xBol033

	::aEmpresa := Array(6)
	::aTxt	   := {}
	
	::aArea := GetArea()
Return Self


Method Destroy() Class xBol033
	DbCloseArea(::cAlias)
	
	RestArea(::aArea)
Return Self


Method SetTitulos(cPref, cNum, cTipo, cPrcDe, cPrcAte, cCliDe, cCliAte, cLjDe, cLjAte) Class xBol033

	Default cPrcDe	:= ''
	Default cPrcAte := 'ZZ'
	Default cCliDe 	:= ''
	Default cCliAte := 'ZZZZZZ'
	Default cLjDe	:= ''
	Default cLjAte  := 'ZZ'
	
	::cAlias  := GetNextAlias()

	cQuery := "SELECT R_E_C_N_O_ REC "
	cQuery += "FROM " +RetSqlName("SE1")+" "
	cQuery += "WHERE D_E_L_E_T_<> '*' "
	cQuery += 	"AND E1_FILIAL = '" + xFilial("SE1") + "' "
	cQuery +=	"AND E1_PREFIXO = '" + cPref + "' "
	cQuery += 	"AND E1_NUM = '" + cNum + "' "
	cQuery += 	"AND E1_PARCELA BETWEEN '" + cPrcDe + "' AND '" + cPrcAte + "' "
	cQuery += 	"AND E1_TIPO = '" + cTipo + "' "
	cQuery += 	"AND E1_CLIENTE BETWEEN '" + cCliDe + "' AND '" + cCliAte + "' "
	cQuery += 	"AND E1_LOJA BETWEEN '" + cLjDe + "' AND '" + cLjAte + "' "
	cQuery += 	"AND E1_SALDO > 0 " 
	cQuery += 	"AND E1_PORTADO = '033' "		// SOMENTE GERA BANCO SANTANDER = 033
	cQuery += "ORDER BY E1_PREFIXO, E1_NUM, E1_PARCELA"

	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),::cAlias, .F., .T.)
	
	DbSelectArea(::cAlias)

	Count To ::nRegs
	
	(::cAlias)->(DbGoTop())

Return Self


Method SetDadosBanco() Class xBol033

	If ::cPortador == "033"				//Tratamento para o banco Santander
		::cMsgBco  := 'no Banco Santander'
		::cDigito  := '7'                // PARA ITAU é 7 .   E para Santander ????
		::nTamNNum := 8
	EndIf
	
Return Self


Method SetBanco(nRecSEE) Class xBol033

	If !Empty(nRecSEE)
		DbSelectArea("SEE")
		DbGoTo(nRecSEE)
/*	
		::cPortador := SEE->EE_CODIGO
		::cAgencia  := Alltrim(SEE->EE_AGENCIA)
		::cDVAg		:= SEE->EE_DVAGE
		::cConta	:= Alltrim(SEE->EE_CONTA)
		::cDVConta	:= SEE->EE_DVCTA
		::cCarteira := Alltrim(SEE->EE_CODCART)
*/
/*
		::cPortador := "341"
		::cAgencia  := "1529"
		::cDVAg		:= ""
		::cConta	:= "01594"
		::cDVConta	:= "1"
		::cCarteira :=  "109" //"112"
*/
		if cFilAnt == "01"  //  Santander - Matriz
			::cPortador := "033"
			::cAgencia  := "3072 "
			::cDVAg		:= ""
			::cConta	:= "01051781  "
			::cDVConta	:= "1"
			::cCarteira := "101"

		ElseIf cFilAnt == '02'  // Santander - Filial
			::cPortador := "033"
			::cAgencia  := "3078 "
			::cDVAg		:= ""
			::cConta	:= "13002050  "
			::cDVConta	:= "1"
			::cCarteira := "101"
		Endif


	Else
		MsgAlert("Erro durante a definição do banco emissor")
	EndIf
	
Return Self


Method SetEmpresa() Class xBol033
	::aEmpresa[1] := SM0->M0_CGC		//CNPJ
	::aEmpresa[2] := SM0->M0_NOMECOM	//Nome
	::aEmpresa[3] := SM0->M0_ENDCOB		//Endereço
	::aEmpresa[4] := SM0->M0_BAIRCOB	//Bairro
	::aEmpresa[5] := SM0->M0_CIDCOB		//Cidade
	::aEmpresa[6] := SM0->M0_ESTCOB		//Estado
Return Self


Method TransfPortador() Class xBol033

If RecLock("SE1", .F.)
		
	Replace E1_PORTADO	With ::cPortador,;
			E1_AGEDEP	With ::cAgencia,;
			E1_CONTA	With ::cConta,;
			E1_SITUACA	With '1'
		
	MsUnLock()
		
EndIf

Return Self


Method Gerar() Class xBol033

	If ::cPortador $ "033"
	
		::SetDadosBanco()
	
		Processa({|| ::GerarBoletos()})
	Else
		MsgAlert("Banco não homologado para emissão de boletos!")
	EndIf
		
Return Self


Method GerarBoletos() Class xBol033

	If ::nRegs == 0
		MsgAlert("Não há títulos a serem impressos!")
		Return Self
	EndIf
	
	//Dados da empresa
	If ::aEmpresa[1] == Nil
		::SetEmpresa()
	EndIf
	
	//Contagem de boleto impresso
	::nBol := 1
	
	//Moeda a ser utilizada na impressão
	::cNumMoeda := "9"

	//Logotipos
	::cLogoBco := 'LOGO'+::cPortador+'.BMP'
//	::cLogoEmp := 'DANFE'+cEmpAnt+'.BMP'

				//Adicionado o tratamento para usar a mesma logo do DANFE	
	If (GetNewPar("MV_LOGOD", "N") == "S")
		::cLogoEmp := 'DANFE' + cEmpAnt + cFilAnt + '.BMP'
		If !File(GetSrvProfString("Startpath","") + ::cLogoEmp)
			::cLogoEmp := 'DANFE' + cEmpAnt + '.BMP'
		EndIf
	EndIf
	
	//Instruções iniciais da geração dos boletos
	lAdjustToLegacy := .T.
	lDisableSetup   := .T.
	::cDiretorio  	:= 'c:\relato\' //'\boletos' 
	//::cNomeArq 		:= "Boleto_" + ::cPortador + cEmpAnt + cFilAnt + DtoS(Date()) + StrTran(Time(),':','') + '.pdf'
	::cNomeArq 		:= "Boleto_" +Alltrim(cNum)+Alltrim(UPPER(cPrcDe))+"_" + ::cPortador + cEmpAnt + cFilAnt + DtoS(Date()) + StrTran(Time(),':','') + '.pdf'

	//Verifica se existe o diretório, caso não existe irá tentar criar, caso negativo irá informar o usuário do problema	
	If !ExistDir(::cDiretorio)
		If MakeDir(::cDiretorio) <> 0
			MsgAlert("O diretório " + Alltrim(::cDiretorio) + " não foi encontrado, contacte o departamento de TI!")
			Return Self
		EndIf
	EndIf

	oPrn := FWMSPrinter():New(::cNomeArq,IMP_PDF,lAdjustToLegacy,::cDiretorio,lDisableSetup)

	oPrn:SetPortrait()
	oPrn:SetPaperSize(9)
	oPrn:cPathPDF := ::cDiretorio
	oPrn:lInJob   := .T.
	oPrn:lViewPDF := .F.
	
	ProcRegua(::nRegs)
		
	DbSelectArea(::cAlias)
	
	While (::cAlias)->(!Eof())
	
		IncProc('Gerando boletos: ' + Alltrim(Str(::nBol)) + '/' + Alltrim(Str(::nRegs)))

		//Posiciona no título	
		DbSelectArea("SE1")
		DbGoTo((::cAlias)->REC)

		//Transfere o portador, caso necessário		
		If Empty(SE1->E1_PORTADO)
			::TransfPortador()
		EndIf

		//Saldo do título a ser recebido, contemplando todos os descontos, acréscimos e dedução de impostos
		::nValor := SaldoTit( SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, SE1->E1_TIPO, SE1->E1_NATUREZ, "R", SE1->E1_CLIENTE, SE1->E1_MOEDA, ;
							dDataBase, dDataBase, SE1->E1_LOJA)
					
		::nValor := Round(::nValor, 2)
		
		::cValor := AllTrim(Transform(::nValor, "@E 999,999,999.99"))
		
		// Realiza o tratamento do nosso número, se não existe, o cria
		If Empty(SE1->E1_NUMBCO)
		                            
			// Atualiza o titulo com o Nosso Número
			DbSelectArea("SE1")

			//Verifica se o IDCNAB está preenchido			
			If Empty(SE1->E1_IDCNAB)
			
			/*
				cIdCnab := StrZero(Val(GetSx8Num("SEE","EE_FAXATU")),::nTamNNum)

			
				SEE->(ConfirmSx8())
				
				Reclock("SEE",.F.)
					Replace EE_FAXATU With cIdCnab
				SEE->(MsUnlock())
			*/
				cIdCnab := U_NOSSO033()
			Else
				cIdCnab := SE1->E1_IDCNAB
			EndIf
							
			RecLock("SE1", .F.)							
				Replace E1_NUMBCO With cIdCnab,;
						E1_IDCNAB With cIdCnab
			SE1->(MsUnlock())
			
		EndIf
		
		cNumBco   	:= Alltrim(SE1->E1_NUMBCO)
		::pNossoNum := ::cCarteira + '/' + cNumBco + '-' + ::Modulo10(::cAgencia + ::cConta + ::cCarteira + cNumBco)
		::cNossoNum := cNumBco + ::Modulo10(::cAgencia + ::cConta + ::cCarteira + cNumBco)
		
		//Posiciona no Cliente		
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA)))
		
		DbSelectArea("SE1")
		
		//Realiza a geração do PDF
		::ImpressaoBoleto()
		
		(::cAlias)->(DbSkip())
		
		::nBol++
		
	End

	//Exibe o relatório gerado
	//oPrn:Preview()
	
	//Gera o arquivo
	oPrn:Print()

	FreeObj(oPrn)

Return Self


Method ImpressaoBoleto() Class xBol033
Local oFont9   	 := TFont():New("Arial",,9,,.F.)
Local oFont10  	 := TFont():New("Arial",,10,,.F.)
Local oFont10n 	 := TFont():New("Arial",,10,,.T.)
Local oFont12 	 := TFont():New("Arial",,12,,.F.)
Local oFont12n 	 := TFont():New("Arial",,12,,.T.)
Local oFont14n 	 := TFont():New("Arial",,14,,.T.)
Local oFont16n 	 := TFont():New("Arial",,16,,.T.)
Local oBrush 	 := TBrush():New( ,CLR_HGRAY)
Local cE1Pref	 := Alltrim(SE1->E1_PREFIXO)
Local cE1Num	 := Alltrim(SE1->E1_NUM)
Local cE1Parc	 := Alltrim(SE1->E1_PARCELA)
//Local cNumDoc 	 := IIF(!Empty(cE1Pref),cE1Pref + ' - ','') + cE1Num + IIF(!Empty(cE1Parc),'/'+ cE1Parc,'')
Local cNumDoc 	 :=  cE1Num
Local aCodigos 	 := ::CodigoBarras()		//Realiza a montagem do Código de Barras e da Representação Numérica
Local nMulta 	 := SuperGetMV("MV_MULTA",.F.,0)
Local nJuros 	 := SuperGetMV("MV_TXPER",.F.,0)
Local aMsg		 := {}
Local cCNPJ 	 := Transform(::aEmpresa[1], "@R 99.999.999/9999-99")
Local cDadCli	 := IIF(SA1->A1_PESSOA == 'J', 'CNPJ: ' + Transform(SA1->A1_CGC,"@R 99.999.999/9999-99"), 'CPF: ';
					 + Transform(SA1->A1_CGC,"@R 999.999.999-99"))
Local cMoed1	 := SuperGetMv("MV_SIMB01",.F.,"R$")

oPrn:StartPage()

//** Parte superior do Boleto **//
oPrn:SayBitmap(2,100,::cLogoEmp,354,325)

oPrn:Say(201,2017, "RECIBO DO PAGADOR", oFont10n)

//1ª linha
oPrn:Line(210,100,210,2300)
	oPrn:Say(232,0105, "Beneficiário", oFont10)
	oPrn:Say(267,0105, AllTrim(::aEmpresa[2]), oFont12)
	
	oPrn:Line(210,1300,280,1300)
	oPrn:Say(232,1310, "Número do Documento", oFont10)
	oPrn:Say(267,1310, cNumDoc, oFont12)
    
	oPrn:Line(210,1840,280,1840)
	oPrn:Say(232,1850, "Vencimento", oFont10)
//	oPrn:Say(267,1850, ::FormatData(DtoS(SE1->E1_VENCTO)), oFont12)
	oPrn:Say(267,1850, ::FormatData(DtoS(SE1->E1_VENCREA)), oFont12)	

//2ª linha
oPrn:Line(280,100,280,2300)

	oPrn:Say(302,0105, "Endereço", oFont10)
	oPrn:Say(337,0105, Alltrim(::aEmpresa[3]) + ' ' + Alltrim(::aEmpresa[4]) + ' - ' + Alltrim(::aEmpresa[5]) + '/' + Alltrim(::aEmpresa[6]), oFont12)
    
	oPrn:Line(280,1420,350,1420)
	oPrn:Say(302,1430, "CNPJ", oFont10)
	oPrn:Say(337,1430, cCNPJ, oFont12)

//3ª linha
oPrn:Line(350,100,350,2300)

	oPrn:Say(372,0105, "Nosso Número", oFont10)
	oPrn:Say(407,0105, ::pNossoNum, oFont12)

	oPrn:Line(350,0445,420,0445)
	oPrn:Say(372,0455, "Carteira", oFont10)
	oPrn:Say(407,0455, ::cCarteira, oFont12)
    
	oPrn:Line(350,795,420,795)
	oPrn:Say(372,0805, "Agência/Código Beneficiário", oFont10)
	//oPrn:Say(407,0805, ::cAgencia + "/" + ::cConta + "-" + ::cDVConta, oFont12)
    oPrn:Say(407,0805, ::cAgencia + "/" + ::cConta , oFont12)

	oPrn:Line(350,1300,420,1300)
	oPrn:Say(372,1310, "Espécie Doc.", oFont10)
	//oPrn:Say(407,1310, SE1->E1_TIPO, oFont12)
	oPrn:Say(407,1310, "DMI", oFont12)	
    
	oPrn:Line(350,1740,420,1740)
	oPrn:Say(372,1750, "Valor do Documento", oFont10)
	oPrn:Say(407,1750, cMoed1 + " " + ::cValor, oFont12)
	
//4ª linha
oPrn:Line(420,100,420,2300)

	oPrn:Say(442,105, "Pagador", oFont10)
	oPrn:Say(477,105, Alltrim(SA1->A1_NOME), oFont12)

//5ª linha
oPrn:Line(490,100,490,2300)

//** Box Superior de Informações do Cliente **//
oPrn:Box(510,100,1500,2297)

	//Mensagem de texto
	nLin := 550
		
	For i := 1 To Len(::aTxt)
			
		If !Empty(::aTxt[i]) .And. i <= 24				//O limite de linhas é 24
			oPrn:Say(nLin,110, ::aTxt[i], oFont12)
			nLin += 40
		EndIf
				
	Next x

//** 1º box de boletos (recibo do sacado em boleto) **//
oPrn:SayBitmap(1545,100,::cLogoBco,180,55)

oPrn:Line(1560,360,1600,360)
oPrn:Say(1589,375, ::cPortador + '-' + ::cDigito, oFont14n)
oPrn:Line(1560,482,1600,481)

oPrn:Say(1591,2017, "RECIBO DO PAGADOR", oFont10n)

//1ª linha
oPrn:Line(1600,100,1600,2300)

	oPrn:Say(1622,105, "Beneficiário", oFont10)
	oPrn:Say(1657,105, AllTrim(::aEmpresa[2]), oFont12)
	
	oPrn:Line(1600,1415,1670,1415)
	oPrn:Say(1622,1425, "Nosso Número", oFont10)
	oPrn:Say(1657,1425, ::pNossoNum, oFont12)
    
	oPrn:Line(1600,1855,1670,1855)
	oPrn:Say(1622,1865, "Vencimento", oFont10)
	//oPrn:Say(1657,1865, ::FormatData(DtoS(SE1->E1_VENCTO)), oFont12)
	oPrn:Say(1657,1865, ::FormatData(DtoS(SE1->E1_VENCREA)), oFont12)

//2ª linha
oPrn:Line(1670,100,1670,2300)

	oPrn:Say(1692,105, "Data do Documento", oFont10)
	oPrn:Say(1727,105, ::FormatData(DtoS(SE1->E1_EMISSAO)), oFont12)
	
	oPrn:Line(1670,535,1740,535)
	oPrn:Say(1692,545, "Número do Documento", oFont10)
	oPrn:Say(1727,545, cNumDoc, oFont12)
    
	oPrn:Line(1670,975,1740,975)
	oPrn:Say(1692,985, "Espécie Doc.", oFont10)
//	oPrn:Say(1727,985, SE1->E1_TIPO, oFont12)
	oPrn:Say(1727,985, "DMI", oFont12)	

	oPrn:Line(1670,1195,1740,1195)
	oPrn:Say(1692,1205, "Aceite", oFont10)
	oPrn:Say(1727,1205, "N", oFont12)

	oPrn:Line(1670,1415,1740,1415)
	oPrn:Say(1692,1425, "Data do Processamento", oFont10)
	oPrn:Say(1727,1425, ::FormatData(DtoS(dDataBase)), oFont12)

	oPrn:Line(1670,1855,1740,1855)
	oPrn:Say(1692,1865, "Agência/Código Beneficiário", oFont10)
//	oPrn:Say(1727,1865, ::cAgencia + "/" + ::cConta + "-" + ::cDVConta, oFont12)
	oPrn:Say(1727,1865, ::cAgencia + "/" + ::cConta , oFont12)

//3ª linha
oPrn:Line(1740,100,1740,2300)

	oPrn:Say(1762,105, "Carteira", oFont10)
	oPrn:Say(1797,105, ::cCarteira, oFont12)
	
	oPrn:Line(1740,535,1810,535)
	oPrn:Say(1762,545, "Moeda Espécie", oFont10)
	oPrn:Say(1797,545, cMoed1, oFont12)
    
	oPrn:Line(1740,975,1810,975)
	oPrn:Say(1762,985, "Quantidade", oFont10)
	oPrn:Say(1797,985, "", oFont12)

	oPrn:Line(1740,1415,1810,1415)
	oPrn:Say(1762,1425, "Valor", oFont10)
	oPrn:Say(1797,1425, "", oFont12)
                     
	oPrn:Line(1740,1855,1810,1855)
	oPrn:Say(1762,1865, "(=) Valor do Documento", oFont10)
	oPrn:Say(1797,1865, cMoed1 + " " + ::cValor, oFont12)

//4ª linha
oPrn:Line(1810,100,1810,2300)

//Autenticação Mecanica
oPrn:Line(1820,1460,1860,1460)
oPrn:Line(1820,1460,1820,2260)
oPrn:Line(1820,2260,1860,2260)
oPrn:Say(1842,1710, "Autenticação Mecânica", oFont10n)
  
//Destaque Aqui
oPrn:Say(1900,100, Replicate('- ',129), oFont10n)
oPrn:Say(1900,2120, 'DESTAQUE AQUI', oFont9)

//** Boleto (via do banco) **//
oPrn:SayBitmap(1945,100,::cLogoBco,180,55)

oPrn:Line(1960,360,2000,360)
oPrn:Say(1990,375, ::cPortador + '-' + ::cDigito, oFont14n)
oPrn:Line(1960,482,2000,481)

oPrn:Say(1992, 580, aCodigos[2], oFont16n)			//Linha digitável

//Boxes Cinzas dos totalizadores
oPrn:Fillrect( {2000, 1742, 2101, 2299 }, oBrush, "-2")		//Vencimento
oPrn:Fillrect( {2240, 1742, 2311, 2299 }, oBrush, "-2")		//Valor do Documento
oPrn:Fillrect( {2590, 1742, 2661, 2299 }, oBrush, "-2")		//Valor Cobrado

//1ª linha
oPrn:Line(2000,100,2000,2300)
	oPrn:Say(2022,105, "Local de Pagamento", oFont10)
	//oPrn:Say(2057,105, "Até o vencimento pague preferencialmente " + ::cMsgBco + ".", oFont12)
	//oPrn:Say(2090,105, "Após o vencimento pague somente " + ::cMsgBco + ".", oFont12)
	oPrn:Say(2057,105, "EM QUALQUER BANCO OU CORRESP. NAO BANCARIO " , oFont12)	


	oPrn:Say(2022,1750, "Vencimento", oFont10)
//	oPrn:Say(2090,1750, ::FormatData(DtoS(SE1->E1_VENCTO)), oFont12n)
	oPrn:Say(2090,1750, ::FormatData(DtoS(SE1->E1_VENCREA)), oFont12n)

//2ª linha
oPrn:Line(2100,100,2100,2300)
	oPrn:Say(2122,105, "Beneficiário", oFont10)
	oPrn:Say(2157,105, AllTrim(::aEmpresa[2]), oFont12)

	oPrn:Line(2100,1390,2170,1390)
	oPrn:Say(2122,1400, "CNPJ", oFont10)
	oPrn:Say(2157,1400, cCNPJ, oFont12)
	
	oPrn:Say(2122,1750, "Agência/Código Beneficiário", oFont10)
//	oPrn:Say(2157,1750, ::cAgencia + "/" + ::cConta + "-" + ::cDVConta, oFont12)
	oPrn:Say(2157,1750, ::cAgencia + "/" + ::cConta , oFont12)

//3ª linha
oPrn:Line(2170,100,2170,2300)
	
	oPrn:Say(2192,105, "Data do Documento", oFont10)
	oPrn:Say(2227,105, ::FormatData(DtoS(SE1->E1_EMISSAO)), oFont12)
	
	oPrn:Line(2170,453,2240,453)
	oPrn:Say(2192,463, "Nº do Documento", oFont10)
	oPrn:Say(2227,463, cNumDoc, oFont12)

	oPrn:Line(2170,811,2240,811)
	oPrn:Say(2192,821, "Espécie Doc.", oFont10)
//	oPrn:Say(2227,821, SE1->E1_TIPO, oFont12)
	oPrn:Say(2227,821, "DMI", oFont12)	

	oPrn:Line(2170,1100,2240,1100)	
	oPrn:Say(2192,1110, "Aceite", oFont10)
	oPrn:Say(2227,1110, "N", oFont12)
	
	oPrn:Line(2170,1390,2240,1390)
	oPrn:Say(2192,1400, "Data do Processamento", oFont10)
	oPrn:Say(2227,1400, ::FormatData(DtoS(dDataBase)), oFont12)

	oPrn:Say(2192,1750, "Nosso Número", oFont10)
	oPrn:Say(2227,1750, ::pNossoNum, oFont12)
	
//4ª linha
oPrn:Line(2240,100,2240,2300)

	oPrn:Say(2262,105, "Uso do Banco", oFont10)
	oPrn:Say(2297,105, "", oFont12)
	
	oPrn:Line(2240,453,2310,453)
	oPrn:Say(2262,463, "Carteira", oFont10)
	oPrn:Say(2297,463, ::cCarteira, oFont12)
	
	oPrn:Line(2240,811,2310,811)
	oPrn:Say(2262,821, "Espécie", oFont10)
	oPrn:Say(2297,821, cMoed1, oFont12)

	oPrn:Line(2240,1100,2310,1100)
	oPrn:Say(2262,1110, "Quantidade", oFont10)
	oPrn:Say(2297,1110, "", oFont12)

	oPrn:Line(2240,1390,2310,1390)
	oPrn:Say(2262,1400, "Valor", oFont10)
	oPrn:Say(2297,1400, "", oFont12)

	oPrn:Say(2262,1750, "(=) Valor do Documento", oFont10)
	oPrn:Say(2297,1750, cMoed1 + " " + ::cValor, oFont12n)

//5ª linha
oPrn:Line(2310,100,2310,2300)

	oPrn:Say(2332,105, "Instruções de responsabilidade do beneficiário. Qualquer dúvida sobre este boleto, contate o beneficiário.", oFont10)

	//Mensagens dos boletos

	nJuros := 1 //mauresi - alimentar Juros no parametro MV_TXPER
	nMulta := 0  //mauresi - alimentar Juros no parametro MV_TXPER


	If nJuros > 0	
		AAdd(aMsg, "APÓS O VENCIMENTO COBRAR MORA DE  . . . . . . . . . . . . . . .  " + cMoed1 + " " + Alltrim(Transform((::nValor*nJuros)/30,"@E 999,999,999.99")) + " AO DIA")
	EndIf
	
	If nMulta > 0
//		AAdd(aMsg, "APÓS " + ::FormatData(DtoS(SE1->E1_VENCTO)) + " COBRAR MULTA DE  . . . . . . . . . . . . . . . . . . .  " + cMoed1 + " " + Alltrim(Transform(::nValor*(nMulta/100),"@E 999,999,999.99")))
		AAdd(aMsg, "APÓS " + ::FormatData(DtoS(SE1->E1_VENCREA)) + " COBRAR MULTA DE  . . . . . . . . . . . . . . . . . . .  " + cMoed1 + " " + Alltrim(Transform(::nValor*(nMulta/100),"@E 999,999,999.99")))

	EndIf
	
//	AAdd(aMsg, IIF(!Empty(SEE->EE_DIASPRT),"PROTESTAR AUTOMATICAMENTE APÓS " + ::FormatData(DtoS(SE1->E1_VENCTO + Val(SEE->EE_DIASPRT))),""))
	AAdd(aMsg, IIF(!Empty(SEE->EE_DIASPRT),"PROTESTAR AUTOMATICAMENTE APÓS " + ::FormatData(DtoS(SE1->E1_VENCREA + Val(SEE->EE_DIASPRT))),""))
	
	AAdd(aMsg, "COBRANCA ESCRITURAL") // Especifco RDT

	AAdd(aMsg, IIF(!Empty(SEE->EE_FORMEN1),Formula(SEE->EE_FORMEN1),""))
	AAdd(aMsg, IIF(!Empty(SEE->EE_FORMEN2),Formula(SEE->EE_FORMEN2),""))
	AAdd(aMsg, IIF(!Empty(SEE->EE_FOREXT1),Formula(SEE->EE_FOREXT1),""))
	AAdd(aMsg, IIF(!Empty(SEE->EE_FOREXT2),Formula(SEE->EE_FOREXT2),""))
	
	nLin := 2367
	
	For x := 1 To Len(aMsg)
		
		If !Empty(aMsg[x])
			oPrn:Say(nLin,105, aMsg[x], oFont12)
			
			nLin += 40
		EndIf
			
	Next x

	//Totalizadores laterais
	oPrn:Say(2332,1750, "(-) Desconto/Abatimento", oFont10)
	oPrn:Say(2367,1750, "", oFont12)
	
	oPrn:Line(2380,1740,2380,2300)
	oPrn:Say(2402,1750, "(-) Outras Deduções", oFont10)
	oPrn:Say(2437,1750, "", oFont12)
	
	oPrn:Line(2450,1740,2450,2300)
	oPrn:Say(2472,1750, "(+) Mora/Multa", oFont10)
	oPrn:Say(2507,1750, "", oFont12)
	
	oPrn:Line(2520,1740,2520,2300)
	oPrn:Say(2542,1750, "(+) Outros Acréscimos", oFont10)
	oPrn:Say(2577,1750, "", oFont12)
	
	oPrn:Line(2590,1740,2590,2300)
	oPrn:Say(2612,1750, "(=) Valor Cobrado", oFont10)
	oPrn:Say(2647,1750, "", oFont12)
	
//6ª linha
oPrn:Line(2660,100,2660,2300)

	If !Empty(SA1->A1_ENDCOB)
		cEnd  := Alltrim(SA1->A1_ENDCOB) 
		cEnd2 := Alltrim(SA1->A1_BAIRROC)
		cEnd3 := Transform(SA1->A1_CEPC, "@R 99999-999") + ' - ' + Alltrim(SA1->A1_MUNC) + '/' + Alltrim(SA1->A1_ESTC)
	Else
		cEnd  := Alltrim(SA1->A1_END)
		cEnd2 := Alltrim(SA1->A1_BAIRRO)
		cEnd3 := Transform(SA1->A1_CEP, "@R 99999-999") + ' - '  + Alltrim(SA1->A1_MUN) + '/' + Alltrim(SA1->A1_EST)
	EndIf

	oPrn:Say(2690,105, Alltrim(SA1->A1_NOME), oFont12)
	oPrn:Say(2730,105, cEnd, oFont12)
	oPrn:Say(2770,105, cEnd2, oFont12)
	oPrn:Say(2810,105, cEnd3, oFont12)
	
	oPrn:Say(2690,1600, cDadCli, oFont12)
	
	oPrn:Say(2850,105, "Sacador/Avalista:", oFont10)
	oPrn:Say(2850,1750, "Código de Baixa", oFont10)

//7ª linha
oPrn:Line(2860,100,2860,2300)
	oPrn:Say(2882,1755, "Autenticação Mecânica/Ficha de Compensação", oFont10)

	oPrn:FWMsBar("INT25",67,2.2,aCodigos[1],oPrn,.F.,Nil,Nil,0.0166,1.11,Nil,Nil,"A",.F.)
                              
//Linha Vertical separadora da 2ª a 5ª linha (totalizadores)
oPrn:Line(2000,1740,2660,1740)

oPrn:EndPage()

Return Self


Method ApagarArquivo() Class xBol033
Local lRet := .T.

IncProc('Removendo o arquivo ' + ::cNomeArq)


If FErase(::cDiretorio + ::cNomeArq) == -1
	lRet := .F.
Endif


Return lRet
           

Method SetDadosEmail() Class xBol033
	::cServidor := GetMV('MV_RELSERV')		//endereço SMTP
	::lAutentic := GetMV('MV_RELAUTH')		//necessita de autenticação?
	::cContaEm  := GetMV('MV_RELACNT')		//conta
	::cPassEm   := GetMV('MV_RELPSW')		//senha
Return Self


Method EnviarEmail(cTitulo, cTO, cCC, cBCC) Class xBol033

	Local lOk  	 := .T.
	Default cTO	 := ''
	Default cCC  := ''
	Default cBCC := ''
	
 	::SetDadosEmail()
	
	//Adiciona os dados referentes ao email
	If Empty(::cServidor) .And. Empty(::cContaEm) .And. Empty(::cPassEm)
		MsgAlert("Dados do servidor de email não configurados")
		lOk := .F.
	EndIf
	
	//Conteúdo do Email
	If lOk
		cHTML := ::ConteudoEmail(cTitulo)
	EndIf
	
	//Copia o arquivo para o servidor
	CpyT2S(::cDiretorio + ::cNomeArq,'\SPOOL\',.T.)
	cAnexo := '\SPOOL\' + ::cNomeArq

	//Realiza o envio do email
	If lOk

	/*
		//Conecta com o servidor de e-mail
		CONNECT SMTP SERVER ::cServidor ACCOUNT ::cContaEm PASSWORD ::cPassEm RESULT lOk
			        
		//Realiza a autenticação caso necessário
		If lOk .And. ::lAutentic
			lOk := MailAuth(::cContaEm, ::cPassEm)
		EndIf
				
		//Realiza o envio do email
		If lOk
		
			SEND MAIL FROM ::cContaEm TO cTO CC cCC BCC cBCC SUBJECT cTitulo BODY cHTML FORMAT TEXT ATTACHMENT cAnexo RESULT lOk
	
		EndIf

		DISCONNECT SMTP SERVER

	*/
//	cTitulo	:= "Boleto Bancário - " + Alltrim(SA1->A1_NOME) //+ " - Doc:" + cNumDoc
	cTitulo +=  Alltrim(SA1->A1_NOME) 

	cTexto := ""

	cTexto += "Prezado Cliente, " + Alltrim(SA1->A1_NOME) + '<br>' + '<br>' //Chr(13) + Chr(13)
//	cTexto += "Envio em anexo, via e-mail, o(s) boleto(s) para pagamento." + '<br>'//Chr(13)
	cTexto += "Envio em anexo, via e-mail, o(s) boleto(s) referente a nota fiscal n. " + Alltrim(cNum) + " para pagamento." + '<br>'//Chr(13)
	cTexto += "Por gentileza, confirmar o recebimento para:    " + '<br>' //Chr(13)
	cTexto += "financeiro@rosenbergerdomex.com.br" + '<br>' //Chr(13)
	U_EnvMailto(cTitulo,cTexto,cTO,cCC,cAnexo)

	EndIf

	//Apaga o arquivo anexo
	FErase(cAnexo)
	
Return Self


Method ConteudoEmail(cTitulo) Class xBol033

	cRet := '<html lang="pt_br">'
	
	cRet += '<head>'
	cRet += 	'<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>'
	cRet += 	'<meta name="viewport" content="initial-scale=1.0"/>'
	cRet += 	'<meta name="format-detection" content="telephone=no"/>'
	cRet += 	'<title>' + cTitulo + '</title>'
	cRet += '</head>'
		
	cRet += '<body style="margin:0; padding:10px 0;" bgcolor="#ebebeb"><br/>'
		
	//Tabela do Layout do Documento "Cinza"
	cRet += 	'<table border="0" style="width: 100%; height:100%;" cellpadding="0" cellspacing="0" bgcolor="#ebebeb"><tr>'
	cRet += 		'<td align="center" valign="top" bgcolor="#ebebeb" style="background-color: #ebebeb;">'  
		
	//Tabela do Layout Principal "Branco
	cRet += 			'<table border="0" width="70%" cellpadding="0" cellspacing="0" class="container" bgcolor="#ffffff"><tr>'
	cRet += 				'<td class="container-padding" bgcolor="#ffffff" style="background-color: #ffffff; padding-left: 10px; padding-right: 10px; font-size: 14px; line-height: 20px; font-family: Helvetica, sans-serif; color: #333;"><br/>'
	
	//Bloco Superior
	cRet += 					'<div align="right">'+/*<img src="http://.com.br/logo.png" alt=""/> -- Logo da Empresa*/'</div><br/>'
	
	//Texto do Email
	cRet += '<p align="justify" style="font-size: 13px;"><br/>Prezado cliente,<br/><br/>'
	cRet += 'Segue em anexo os boletos bancários referente a <br/><br/>'
	
	cRet += '<br/><br/>'
	cRet += 'Qualquer dúvida estaremos a disposição através de nossa central de atendimento.<br/><br/>'

	//Definir o nome do usuário e telefone		
	cRet += 'Atenciosamente,<br/><br/><b>'+''/*cOperad*/+'</b><br/>'
	cRet += 'Tel: <b>(31) 0000-0000</b><br/></p><br/>'
	
	cRet += '</td></td></table></table></body></html>'

Return cRet
             

Method Modulo10(cLinha) Class xBol033
**************************
** Cálculo do Módulo 10 **
**************************
Local lDobra := .F.
Local nSoma	 := 0
Local cDigRet
Local cValorL
Local nAux
Local nCont
Local nResto
Local nResult

For nCont := Len(cLinha) To 1 Step -1

	lDobra := !lDobra
	
	If lDobra
		cValorL := AllTrim(Str(Val(Substr(cLinha, nCont, 1)) * 2))
	Else
		cValorL := AllTrim(Str(Val(Substr(cLinha, nCont, 1))))
	EndIf
	
	For nAux := 1 To Len(cValorL)
		nSoma += Val(Substr(cValorL, nAux, 1))
	Next n
	
Next nCont

nResto := MOD(nSoma, 10)

nResult := 10 - nResto

If nResult == 10
	cDigRet := "0"
Else
	cDigRet := StrZero(10 - nResto, 1)
EndIf

Return cDigRet


Method Modulo11(cLinha) Class xBol033
**************************
** Cálculo do Módulo 11 **
**************************
Local L := Len(cLinha)
Local D := 0
Local P := 1
	
While L > 0

	P := P + 1
	D := D + (Val(SubStr(cLinha, L, 1)) * P)
	
	If P == 9
		P := 1
	EndIf
		
	L := L - 1
End
	
D := 11 - (mod(D,11))
	
If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
	D := 1
End
	
Return Str(D)


Method FatVencto() Class xBol033
************************************
** Calculo do Fator de Vencimento **
************************************
Local cRet := SE1->E1_VENCREA - CTOD('07/10/1997')

Return Strzero(cRet,4)


Method FormatData(cData) Class xBol033
*************************
** Formatação de datas **
*************************
Local cRet := Substr(cData, 7, 2) + '/' + Substr(cData, 5, 2) + '/' + Substr(cData, 1, 4)

Return cRet


Method CodigoBarras() Class xBol033
**********************************
** Formação do Código de Barras **
**********************************
Local aRet 		 := Array(2)
Local cFatVencto := ::FatVencto()
Local cValor 	 := StrZero( ::nValor * 100, 10)
Local cCampo1	 := ""
Local cCampo2	 := ""
Local cCampo3	 := ""
Local cCampo4	 := ""
Local cCampo5	 := ""
Local cCpoLivre	 := ::cAgencia + ::cConta + ::cCarteira + Substr(::cNossoNum,1,8)

/* Calculo da representacao numerica */
cCampo1	:= ::cPortador + ::cNumMoeda + ::cCarteira + Substr(::cNossoNum,1,2)	  
cCampo2	:= Substr(::cNossoNum,3,6) + ::Modulo10(cCpoLivre) + Substr(::cAgencia,1,3)
cCampo3	:= substr(::cAgencia,4,1) + ::cConta + ::Modulo10(::cAgencia + ::cConta) + "000"
cCampo5	:= cFatVencto + cValor

/* Calculando os DACs dos campos 1, 2 e 3 */
cCampo1	:= cCampo1 + ::Modulo10(cCampo1)
cCampo2	:= cCampo2 + ::Modulo10(cCampo2)
cCampo3	:= cCampo3 + ::Modulo10(cCampo3)
cCampo4	:= Alltrim(::Modulo11(Alltrim(::cPortador + ::cNumMoeda + cFatVencto + cValor + ::cCarteira + Alltrim(Substr(::cNossoNum,1,8)));
			+ ::Modulo10(::cAgencia + ::cConta + ::cCarteira + Alltrim(Substr(::cNossoNum,1,8))) + ::cAgencia + ::cConta;
			+ ::Modulo10(::cAgencia + ::cConta) + "000"))

cCdBarra := Alltrim(::cPortador) + ::cNumMoeda + cCampo4 + cFatVencto + cValor + ::cCarteira + Substr(::cNossoNum,1,8);
			+ ::Modulo10(::cAgencia + ::cConta + ::cCarteira + Alltrim(Substr(::cNossoNum,1,8))) + ::cAgencia + ::cConta;
			+ ::Modulo10(::cAgencia + ::cConta)+ "000"

cRepNum := Substr(cCampo1, 1, 5) + "." + Substr(cCampo1, 6, 5) + "  " + Space(7)
cRepNum += Substr(cCampo2, 1, 5) + "." + Substr(cCampo2, 6, 6) + "  " + Space(7)
cRepNum += Substr(cCampo3, 1, 5) + "." + Substr(cCampo3, 6, 6) + "  " + Space(7)
cRepNum += cCampo4 + "  "  + Space(7)
cRepNum += cCampo5

aRet[1] := cCdBarra
aRet[2] := cRepNum

Return aRet
