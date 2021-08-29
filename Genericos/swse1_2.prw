#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'APWEBSRV.CH'

// -------------------------------------------------------------------------------
//WSDL Service SwSE1
//-------------------------------------------------------------------------------

User function TSTSE1V12()
LOCAL aRetPsq := {}

/*
 cPrefixo := Subs(cWsTitulo,01                           ,Len(SE1->E1_PREFIXO))
	cNum     := Subs(cWsTitulo,Len(cPrefixo)+1              ,Len(SE1->E1_NUM)    )
	cParcela := Subs(cWsTitulo,Len(cPrefixo+cNum)+1         ,Len(SE1->E1_PARCELA))
	cTipo    := Subs(cWsTitulo,Len(cPrefixo+cNum+cParcela)+1,Len(SE1->E1_TIPO   ))
*/

//Pesquisa clientes
aRetPsq := fPsqSE1('20210302','001000101089 NF')
ConOut("MtPsqSE1: Processou rotina de pesquisa 'fPsqSE1'")

Return()


Static Function fPsqSE1(sData,cWsTitulo)

Local aRet := {}
Local cQry := ""
Local x

//Valide se ALIAS esta aberto e fecha
If Select("SQL") <> 0
	SQL->(dbCloseArea())
EndIf

cQry := ""

cQry += " SELECT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_LOJA "
cQry += " FROM "+RetSqlName("SE1")+" SE1 "
cQry += " WHERE SE1.D_E_L_E_T_ = '' AND SE1.E1_FILIAL = '"+xFilial("SE1")+"' AND E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO = '"+cWsTitulo+"' "
//cQry += " ORDER BY E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO "

TCQuery cQry New Alias "SQL"

//SQL->(DbGoTop())
While SQL->(!Eof())
	aAdd(aRet,{ SQL->E1_FILIAL, SQL->E1_PREFIXO, SQL->E1_NUM, SQL->E1_PARCELA, SQL->E1_TIPO, SQL->E1_CLIENTE, SQL->E1_LOJA, 0 } )
	SQL->(DbSkip())
End

//Valide se ALIAS esta aberto e fecha
If Select("SQL") <> 0
	SQL->(dbCloseArea())
EndIf

/*
Os Parâmetros para SaldoTit são:

Parâmetro 1 (Caractere) => Número do Prefixo
Parâmetro 2 (Caractere) => Número do Titulo
Parâmetro 3 (caractere) => Parcela
Parâmetro 4 (Caractere) => Tipo 
Parâmetro 5 (Caractere) => Natureza
Parâmetro 6 (Caractere)  => Carteira R/P

Parâmetro 7 (Caractere) => Conforme Parâmetro 6 se for = 'R' Código Cliente se não Código Fornecedor.

Parâmetro 8 (Numerico) => Moeda
Parâmetro 9 (Data) =>  Data para Conversão
Parâmetro 10 (Data) => Data Baixa a ser considerada.
Parâmetro 11 (Caractere) => Loja do Tipo
Parâmetro 12 (Caractere) => Filial do Titulo
Parâmetro 13 (Numerico) => Taxa da Moeda
Parâmetro 14 (Numerico) => Tipo de Data para compor saldo(baixa/dispo/digit)
*/

dtConv   := StoD(sData)  // Parâmetro 9  (Data) =>  Data para Conversão
dtBaixa  := StoD(sData)  // Parâmetro 10 (Data) => Data Baixa a ser considerada.
cFiliTit := Nil          // Parâmetro 12 (Caractere) => Filial do Titulo
nTxMoeda := 0            // Parâmetro 13 (Numerico) => Taxa da Moeda
cTipoDt  := Nil          // Parâmetro 14 (Numerico) => Tipo de Data para compor saldo(baixa/dispo/digit)

For x := 1 to Len(aRet)
	SE1->( dbSetOrder(1) )
	If SE1->( dbSeek( aRet[x,1] + aRet[x,2] + aRet[x,3] + aRet[x,4] + aRet[x,5] ) )                
	//                                                                           12       13       14
		nSaldoTit := SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,SE1->E1_MOEDA,dtConv,dtBaixa,SE1->E1_LOJA,cFiliTit,nTxMoeda,cTipoDt)
		aRet[x,Len(aRet[x])] := nSaldoTit
	EndIf
Next x

Return(aRet)
