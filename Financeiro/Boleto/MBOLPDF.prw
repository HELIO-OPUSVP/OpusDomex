#INCLUDE "TOTVS.CH"
#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "rwmake.ch"
#Include "protheus.ch"
#Include "colors.ch"

User Function MBOLPDF()

//Instancia a classe
oBol := xBolPDF():New()	

/* Seleciona os títulos, apenas os 3 primeiros parametros são obrigatórios.
	Não é necessário posicionar nos títulos, basta informar os parametros.
	
	Se necessário realmente passar o título, basta seguir o seguinte procedimento:
		1. Utilizar a variável cAlias (oBol:cAlias);
		2. Criar uma tabela com o cAlias contemplando o campo REC;
		3. Adicionar o RECNO da SE1 na tabela do cAlias;
		4. Informar na variável nRegs a quantidade de registros existentes (oBol:nRegs)
		5. Não utilizar o método SetTitulos;
		
	Os títulos poderão também ser ajustados diretamente na tabela "cAlias" após a seleção.
*/

cPref := SE1->E1_PREFIXO
cNum  := SE1->E1_NUM
cTipo := SE1->E1_TIPO
cPrcDe	:= SE1->E1_PARCELA
cPrcAte	:= SE1->E1_PARCELA

//oBol:SetTitulos(cPref, cNum, cTipo/*, cPrcDe, cPrcAte, cCliDe, cCliAte, cLjDe, cLjAte*/)
oBol:SetTitulos(cPref, cNum, cTipo, cPrcDe, cPrcAte/*, cCliDe, cCliAte, cLjDe, cLjAte*/)


/* Seleciona o banco que emitirá o boleto

	Deverá ser passado como parametro o RECNO da tabela SEE do banco a ser emissor.
	
	Para facilitar poderá ser chamado uma interface para escolha do banco ou deixar definido por parametro.
	
	Os seguintes dados são de preenchimento obrigatório na SEE (Parametros Bancos):
	EE_CODIGO 	-> Código do Banco
	EE_AGENCIA 	-> Agência do Banco
	EE_DVAGE	-> Dígito verificador da agência (se houver)
	EE_CONTA	-> Nº da conta sem o dígito
	EE_DVCTA	-> Dígito verificador da conta (se houver)
	EE_CODCART	-> Código da Carteira contratada para emissão
	EE_DIASPRT	-> Nº de dias para protesto do título (se vazio não irá imprimir a linha de protesto)
	
	Os campos abaixo poderão ser utilizados como fórmula para as mensagens adicionais:
	EE_FORMEN1,EE_FORMEN2,EE_FOREXT1,EE_FOREXT2
	
	Sendo impresso na seguinte ordem:
		1. APÓS O VENCIMENTO COBRAR MORA DE .... (com o calculo baseado no parametro MV_TXPER)
		2. APÓS O VENCIMENTO COBRAR MULTA DE ... (com o calculo baseado no parametro MV_MULTA)
		3. PROTESTAR AUTOMATICAMENTE APÓS (baseado no campo EE_DIASPRT)
		4. Fórmula do campo EE_FORMEN1
		5. Fórmula do campo EE_FORMEN2
		6. Fórmula do campo EE_FOREXT1
		7. Fórmula do campo EE_FOREXT2
*/

nRecSEE := 7  //    CARREGAR O RECNO DO BANCO NA TABELA SEE  *****************
oBol:SetBanco(nRecSEE)

/*
	O boleto utiliza os dados da empresa/filial logada, caso necessite alterar basta ajustar o array aEmpresa, sendo:
	
	oBol:aEmpresa[1] := SM0->M0_CGC			//CNPJ sem pontos e traços
	oBol:aEmpresa[2] := SM0->M0_NOMECOM		//Nome
	oBol:aEmpresa[3] := SM0->M0_ENDCOB		//Endereço
	oBol:aEmpresa[4] := SM0->M0_BAIRCOB		//Bairro
	oBol:aEmpresa[5] := SM0->M0_CIDCOB		//Cidade
	oBol:aEmpresa[6] := SM0->M0_ESTCOB		//Estado

*/

/*
	Mensagem do corpo do boleto:
	Para adicionar mensagens no corpo (parte superior - via do cliente) do boleto basta alimentar a variável aTxt conforme abaixo:
	
	AAdd(oBol:aTxt,"Msg - Linha 1")
	AAdd(oBol:aTxt,"Msg - Linha 2")
	AAdd(oBol:aTxt,"Msg - Linha 3")
*/

//Geração dos boletos bancários em PDF
oBol:Gerar()

/*
	Envia o email com o boleto em anexo.
	
	Parametros:
	cTitulo := Título do e-mail
	cTo		:= E-mail de quem receberá o boleto
	cCC		:= E-mail de quem receberá o boleto em cópia
	cBCC	:= E-mail de quem receberá o boleto em cópia oculta
*/


cTitulo := 'Boleto Bancário - '
cTO 	:= Posicione("SA1",1,xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA ,"A1_EMAIL" )
cTO		+= ';juliane.jordao@rosenbergerdomex.com.br'
cCC		:= ''
cBCC	:= ''

	if !MsgYesNo("Confirma o envio para o cliente no email: " + chr(13) + Alltrim(cTO))
		cTitulo := 'Boleto Bancário - RDT - '
		cTO		:= 'juliane.jordao@rosenbergerdomex.com.br;patricia.vieira@rosenbergerdomex.com.br;adriana.souza@rosenbergerdomex.com.br'  
		cCC		:= ''
		cBCC	:= ''
	Endif

oBol:EnviarEmail(cTitulo, cTO, cCC, cBCC)


//Apaga o arquivo PDF da pasta do usuário (caso não queira mante-los no computador do usuário)
oBol:ApagarArquivo()

//Fecha as areas de trabalho abertas pela classe
oBol:Destroy()

Return




//==================================================================

 /*/{Protheus.doc} MBOLPDF2
	(Imprime Boleto ITAU em LOTE)
	@type  Function
	@author user
	@since 24/05/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/



User Function MBOLPDF2()

Private _cPerg  := Padr("MBOLPDF2",10)
fCriaPerg(_cPerg)


	If Pergunte(_cPerg,.T.)

		// Seleciona os Titulos do Bordero

		if Select("TRB") >0
			TRB->(dbCloseArea(5))
		EndIf
		cQuery := ""
		cQuery += " SELECT EA_NUMBOR,EA_PREFIXO,EA_NUM,EA_PARCELA,E1_NUMBOR,E1_PREFIXO,E1_NUM,E1_TIPO,E1_PARCELA,E1_EMISSAO,E1_VENCTO,E1_VENCREA,E1_VALOR,E1_SALDO,SE1.R_E_C_N_O_ ,A1_EMAIL"
		cQuery += " FROM "+ RetSqlName("SEA") + " SEA "
		cQuery += " LEFT JOIN "+ RetSqlName("SE1") + " SE1 ON EA_FILIAL+EA_PREFIXO+EA_NUM+EA_PARCELA = E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA "
		cQuery += " LEFT JOIN "+ RetSqlName("SA1") + " SA1 ON E1_CLIENTE+E1_LOJA = A1_COD+A1_LOJA "	
		cQuery += " WHERE EA_NUMBOR = '"+alltrim(MV_PAR01)+"' " 
		cQuery += " AND EA_CART = 'R' AND EA_PORTADO='341' AND EA_AGEDEP='1529' AND EA_NUMCON='01594-1' AND SEA.D_E_L_E_T_ = '' "
		cQuery += " AND E1_SALDO > 0"
		TcQuery cQuery Alias "TRB" New

		TRB->(DbSelectArea("TRB"))
		TRB->(DbGoTop())

		Do While  !TRB->(Eof())

			// PROCESSA O ENVIO DOS EMAILS

				//Instancia a classe
					oBol := xBolPDF():New()	

					cPref := TRB->E1_PREFIXO
					cNum  := TRB->E1_NUM
					cTipo := TRB->E1_TIPO
					cPrcDe  := TRB->E1_PARCELA
					cPrcAte := TRB->E1_PARCELA					

//					oBol:SetTitulos(cPref, cNum, cTipo/*, cPrcDe, cPrcAte, cCliDe, cCliAte, cLjDe, cLjAte*/)
					oBol:SetTitulos(cPref, cNum, cTipo, cPrcDe, cPrcAte/*, cCliDe, cCliAte, cLjDe, cLjAte*/)

					nRecSEE := 7  //    CARREGAR O RECNO DO BANCO NA TABELA SEE  *****************
					oBol:SetBanco(nRecSEE)

					//Geração dos boletos bancários em PDF
					oBol:Gerar()

					/*
						Envia o email com o boleto em anexo.
						
						Parametros:
						cTitulo := Título do e-mail
						cTo		:= E-mail de quem receberá o boleto
						cCC		:= E-mail de quem receberá o boleto em cópia
						cBCC	:= E-mail de quem receberá o boleto em cópia oculta
					*/

					if MV_PAR02 == 1	// ENVIA PARA CLIENTE
						cTitulo := 'Boleto Bancário - '
						cTO		:=  Alltrim(TRB->A1_EMAIL)
						cTO		+=  ';juliane.jordao@rosenbergerdomex.com.br;'
						cCC		:= ''
						cBCC	:= '' 
				
					else			// ENVIA PARA FINANCEIRO
						cTitulo := 'Boleto Bancário - RDT - '
						cTO		:= 'juliane.jordao@rosenbergerdomex.com.br;patricia.vieira@rosenbergerdomex.com.br;adriana.souza@rosenbergerdomex.com.br' 
						cCC		:= ''
						cBCC	:= ''
					Endif

					oBol:EnviarEmail(cTitulo, cTO, cCC, cBCC)

					//Apaga o arquivo PDF da pasta do usuário (caso não queira mante-los no computador do usuário)
					//oBol:ApagarArquivo()

					//Fecha as areas de trabalho abertas pela classe
					oBol:Destroy()

			TRB->(DbSelectArea("TRB"))
			TRB->(DbSkip())
		Enddo
		TRB->(DbCloseArea())

	EndIf

Return


Static Function fCriaPerg()
aSvAlias:={Alias(),IndexOrd(),Recno()}
i:=j:=0
aRegistros:={}
//                1      2    3               4  5     6      7  8  9  10 11  12 13         14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43
AADD(aRegistros,{_cPerg,"01","Bordero             ?  ","","","mv_ch1","C",06,00,00,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"02","Email para          ?  ","","","mv_ch2","N",01,00,00,"C","","MV_PAR02","1-Cliente","1-Cliente","1-Cliente","","","2-Financeiro","2-Financeiro","2-Financeiro","","","","","","","","","","","","","","","","","","","","","",""})

DbSelectArea("SX1")
For i := 1 to Len(aRegistros)
	If !dbSeek(aRegistros[i,1]+aRegistros[i,2])
		While !RecLock("SX1",.T.)
		End
		For j:=1 to FCount()
			FieldPut(j,aRegistros[i,j])
		Next
		MsUnlock()
	Endif
Next i
dbSelectArea(aSvAlias[1])
dbSetOrder(aSvAlias[2])
dbGoto(aSvAlias[3])
Return(Nil)



