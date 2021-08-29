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
Os Par�metros para SaldoTit s�o:

Par�metro 1 (Caractere) => N�mero do Prefixo
Par�metro 2 (Caractere) => N�mero do Titulo
Par�metro 3 (caractere) => Parcela
Par�metro 4 (Caractere) => Tipo 
Par�metro 5 (Caractere) => Natureza
Par�metro 6 (Caractere)  => Carteira R/P

Par�metro 7 (Caractere) => Conforme Par�metro 6 se for = 'R' C�digo Cliente se n�o C�digo Fornecedor.

Par�metro 8 (Numerico) => Moeda
Par�metro 9 (Data) =>  Data para Convers�o
Par�metro 10 (Data) => Data Baixa a ser considerada.
Par�metro 11 (Caractere) => Loja do Tipo
Par�metro 12 (Caractere) => Filial do Titulo
Par�metro 13 (Numerico) => Taxa da Moeda
Par�metro 14 (Numerico) => Tipo de Data para compor saldo(baixa/dispo/digit)
*/

dtConv   := StoD(sData)  // Par�metro 9  (Data) =>  Data para Convers�o
dtBaixa  := StoD(sData)  // Par�metro 10 (Data) => Data Baixa a ser considerada.
cFiliTit := Nil          // Par�metro 12 (Caractere) => Filial do Titulo
nTxMoeda := 0            // Par�metro 13 (Numerico) => Taxa da Moeda
cTipoDt  := Nil          // Par�metro 14 (Numerico) => Tipo de Data para compor saldo(baixa/dispo/digit)

For x := 1 to Len(aRet)
	SE1->( dbSetOrder(1) )
	If SE1->( dbSeek( aRet[x,1] + aRet[x,2] + aRet[x,3] + aRet[x,4] + aRet[x,5] ) )                
	//                                                                           12       13       14
		nSaldoTit := SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,SE1->E1_MOEDA,dtConv,dtBaixa,SE1->E1_LOJA,cFiliTit,nTxMoeda,cTipoDt)
		aRet[x,Len(aRet[x])] := nSaldoTit
	EndIf
Next x

Return(aRet)
