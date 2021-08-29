#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"

#DEFINE ENTER Chr(13)+Chr(10)

User Function HJACERTA(cProduto)

cRpcEmp    := "01"            // Código da empresa.
cRpcFil    := "01"            // Código da filial.
cEnvUser   := "Admin"         // Nome do usuário.
cEnvPass   := "OpusDomex"     // Senha do usuário.
cEnvMod    := "EST"           // 'FAT'  // Código do módulo.
cFunName   := "U_HJACERTA"    // 'RPC'  // Nome da rotina que será setada para retorno da função FunName().
aTables    := {}              // {}     // Array contendo as tabelas a serem abertas.
lShowFinal := .F.             // .F.    // Alimenta a variável publica lMsFinalAuto.
lAbend     := .T.             // .T.    // Se .T., gera mensagem de erro ao ocorrer erro ao checar a licença para a estação.
lOpenSX    := .T.             // .T.    // SE .T. pega a primeira filial do arquivo SM0 quando não passar a filial e realiza a abertura dos SXs.
lConnect   := .T.             // .T.    // Se .T., faz a abertura da conexao com servidor As400, SQL Server etc

Default cProduto := ""

//RPCSetType(3)
If Type("cEmpAnt") == "U"
	//RpcSetEnv(cRpcEmp,cRpcFil,cEnvUser,cEnvPass,cEnvMod,cFunName,aTables,lShowFinal,lAbend,lOpenSX,lConnect) //PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"
EndIf

dUlmes := GetMV("MV_ULMES")

//MsgRun("Executando fSD5001() " + cProduto,"Aguarde...",{|| fSD5001(cProduto) }) // Acerta D5_LOTECTL e D3_LOTECTL do 97 para D5_LOTECTL em branco

MsgRun("Executando fSD5002() " + cProduto,"Aguarde...",{|| fSD5002(cProduto) }) // Acerta D5_LOTECTL = D5_OP

MsgRun("Executando fSD5003() " + cProduto,"Aguarde...",{|| fSD5003(cProduto) }) //iguala SBF com SB8

Return

Static Function fSD5001(cProduto)
Local aRefazSld := {}
Local x

cQuery := "SELECT * FROM SD5010 (NOLOCK) WHERE D5_FILIAL = '"+xFilial("SD5")+"' AND D5_LOCAL = '97' AND D5_DATA > '"+DtoS(dUlmes)+"' AND D5_LOTECTL = '' AND D5_ESTORNO = '' AND D_E_L_E_T_ = '' "
If !Empty(cProduto)
cQuery += " AND D5_PRODUTO = '"+cProduto+"' "
EndIf

IF Select("QSD5") <> 0
	QSD5->( dbCloseArea() )
EndIF

TCQUERY cQuery NEW ALIAS "QSD5"

If !QSD5->( EOF() )
   If MsgYesNo("Encontrados registros no SD5 com o D5_LOTECTL em branco")
   EndIf
EndIf

SD3->( dbSetOrder(4) )
While !QSD5->( EOF() )
	SD5->( dbGoTo(QSD5->R_E_C_N_O_) )
	If SD5->( Recno() ) == QSD5->R_E_C_N_O_
		If SD3->( dbSeek( xFilial() + QSD5->D5_NUMSEQ ) )
			cLoteOrig := ""
			While !SD3->( EOF() ) .and. SD3->D3_NUMSEQ == QSD5->D5_NUMSEQ
				If SD3->D3_CF == 'RE4'
					cLoteOrig := SD3->D3_LOTECTL
				EndIf
				If SD3->D3_CF == 'DE4'
					If !Empty(SD3->D3_XXOP)
						If SD3->D3_LOTECTL <> Subs(SD3->D3_XXOP,1,8)
							Reclock("SD3",.F.)
							SD3->D3_LOTECTL := Subs(SD3->D3_XXOP,1,8)
							MsgInfo("Corrigindo D3_LOTECTL")
							SD3->( msUnlock() )
						EndIf
						Reclock("SD5",.F.)
						SD5->D5_LOTECTL := Subs(SD3->D3_XXOP,1,8)
						MsgInfo("Corrigindo D5_LOTECTL")
						SD5->( msUnlock() )
						
						N := aScan(aRefazSld,{|aVet| aVet[1] == SD5->D5_PRODUTO .and. aVet[2] == SD5->D5_LOCAL })
						If Empty(n)
							AADD(aRefazSld,{SD5->D5_PRODUTO,SD5->D5_LOCAL})
						EndIf
					Else
						// Para XXOP em branco
						If !Empty(cLoteOrig)
							Reclock("SD3",.F.)
							SD3->D3_LOTECTL := cLoteOrig
							MsgInfo("Corrigindo D3_LOTECTL")
							SD3->( msUnlock() )
							
							Reclock("SD5",.F.)
							SD5->D5_LOTECTL := cLoteOrig
							MsgInfo("Corrigindo D5_LOTECTL")
							SD5->( msUnlock() )
							
							N := aScan(aRefazSld,{|aVet| aVet[1] == SD5->D5_PRODUTO .and. aVet[2] == SD5->D5_LOCAL })
							If Empty(n)
								AADD(aRefazSld,{SD5->D5_PRODUTO,SD5->D5_LOCAL})
							EndIf
						EndIf
					EndIf
				EndIf
				SD3->( dbSkip() )
			End
		Else
			If apMsgYesNo("NUMSEQ não localizado no SD3 " + QSD5->D5_NUMSEQ )
			EndIf
		EndIf
	Else
		If apMsgYesNo("Não foi possível posicionar no SD5 recno " + Str(QSD5->R_E_C_N_O_) )
		EndIf
	EndIf
	QSD5->( dbSkip() )
End

If !Empty(aRefazSld)
	//If apMsgYesNo("fSD5001() - Deseja recalcular o saldo dos "+Alltrim(Str(Len(aRefazSld)))+" produos  alterados 'U_UMATA300()'")
	For x := 1 to Len(aRefazSld)
		U_UMATA300(aRefazSld[x,1],aRefazSld[x,1],aRefazSld[x,2],aRefazSld[x,2])
	Next x
	//EndIf
EndIf

Return

Static Function fSD5002(cProduto)

cQuery := "SELECT D5_PRODUTO, D5_LOCAL FROM SD5010 (NOLOCK) WHERE D5_FILIAL = '"+xFilial("SD5")+"' AND D5_LOCAL = '97' "
cQuery += "AND D5_DATA > '"+DtoS(dUlmes)+"' AND D5_OP <> '' AND D5_LOTECTL <> SUBSTRING(D5_OP,1,8) AND D5_ESTORNO = '' "
cQuery += "AND D_E_L_E_T_ = '' "
If !Empty(cProduto)
   cQuery += " AND D5_PRODUTO = '"+cProduto+"' "
EndIf
cQuery += "GROUP BY D5_PRODUTO, D5_LOCAL "

IF Select("D5PRODUTO") <> 0
	D5PRODUTO->( dbCloseArea() )
EndIF

TCQUERY cQuery NEW ALIAS "D5PRODUTO"

cQuery := "SELECT D5_OP, D5_PRODUTO, D5_LOCAL, D5_NUMSEQ, D5_DATA, R_E_C_N_O_  FROM SD5010 (NOLOCK) WHERE D5_FILIAL = '"+xFilial("SD5")+"' AND D5_LOCAL = '97' AND D5_DATA > '"+DtoS(dUlmes)+"' AND D5_OP <> '' AND D5_LOTECTL <> SUBSTRING(D5_OP,1,8) AND D5_ESTORNO = '' AND D_E_L_E_T_ = '' "
If !Empty(cProduto)
   cQuery += " AND D5_PRODUTO = '"+cProduto+"' "
EndIf
cQuery += "ORDER BY R_E_C_N_O_ "

IF Select("QSD5") <> 0
	QSD5->( dbCloseArea() )
EndIF

TCQUERY cQuery NEW ALIAS "QSD5"

If !QSD5->( EOF() )
   If apMsgYesNo("Foram encontrados consumos (SD5) em lotes diferentes da OP")
   EndIf
EndIf

While !QSD5->( EOF() )
	cUpdate := "UPDATE SD3010 SET D3_LOTECTL = SUBSTRING(D3_OP,1,8) WHERE D3_FILIAL = '"+xFilial("SD3")+"' AND D3_OP = '"+QSD5->D5_OP+"' AND D3_COD = '"+QSD5->D5_PRODUTO+"' "
	cUpdate += "AND D3_LOCAL = '"+QSD5->D5_LOCAL+"' AND D3_NUMSEQ = '"+QSD5->D5_NUMSEQ+"' AND D3_EMISSAO = '"+QSD5->D5_DATA+"' AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "
	TCSQLEXEC(cUpdate)
	
	cUpdate2 := "UPDATE SD5010 SET D5_LOTECTL = SUBSTRING(D5_OP,1,8) WHERE R_E_C_N_O_ = " + Str(QSD5->R_E_C_N_O_)
	TCSQLEXEC(cUpdate2)
	
	QSD5->( dbSkip() )
End

If !D5PRODUTO->( EOF() )
   nRecno := 0
   D5PRODUTO->( dbEval( {|| nRecno++} ) )    
   D5PRODUTO->( dbGoTop() )

   Processa({ || fProcSaldo(nRecno) } )
EndIf

IF Select("D5PRODUTO") <> 0
	D5PRODUTO->( dbCloseArea() )
EndIF
IF Select("QSD5") <> 0
	QSD5->( dbCloseArea() )
EndIF

Return

//Static Function fSD5003(cProduto)

//_Retorno := startjob("U_fSD5003",getenvserver(), .F. , cProduto)

//Return _Retorno

Static Function fSD5003(cProduto)

Local cRpcEmp     := "01"            // Código da empresa.
Local cRpcFil     := "01"            // Código da filial.
Local cEnvUser    := "Admin"         // Nome do usuário.
Local cEnvPass    := "OpusDomex"     // Senha do usuário.
Local cEnvMod     := "EST"           // 'FAT'  // Código do módulo.
Local cFunName    := "U_HJACERTA"    // 'RPC'  // Nome da rotina que será setada para retorno da função FunName().
Local aTables     := {}              // {}     // Array contendo as tabelas a serem abertas.
Local lShowFinal  := .F.             // .F.    // Alimenta a variável publica lMsFinalAuto.
Local lAbend      := .T.             // .T.    // Se .T., gera mensagem de erro ao ocorrer erro ao checar a licença para a estação.
Local lOpenSX     := .T.             // .T.    // SE .T. pega a primeira filial do arquivo SM0 quando não passar a filial e realiza a abertura dos SXs.
Local lConnect    := .T.             // .T.    // Se .T., faz a abertura da conexao com servidor As400, SQL Server etc
Local aRefazSld   := {}
Local cProdRecalc := ""
Local n, cQuery

If Type("cEmpAnt") == "U"
	RpcSetEnv(cRpcEmp,cRpcFil,cEnvUser,cEnvPass,cEnvMod,cFunName,aTables,lShowFinal,lAbend,lOpenSX,lConnect) //PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"
EndIf

//cQuery := "SELECT TMP.*, BF_QUANT, B8_SALDO FROM            " + ENTER
//cQuery += "(                                                " + ENTER
//cQuery += "SELECT B8_PRODUTO AS PRODUTO, B8_LOTECTL AS LOTE FROM SB8010 WHERE B8_LOCAL = '97' AND B8_SALDO <> 0 AND D_E_L_E_T_=''    " + ENTER
//cQuery += "UNION                                                                                                                     " + ENTER
//cQuery += "SELECT BF_PRODUTO AS PRODUTO,  BF_LOTECTL AS LOTE FROM SBF010 WHERE BF_LOCAL = '97' AND BF_QUANT <> 0 AND BF_LOCALIZ = '97PROCESSO' AND D_E_L_E_T_=''   " + ENTER
//cQuery += ") TMP, SBF010, SB8010                                                                                                     " + ENTER
//cQuery += "WHERE BF_PRODUTO = PRODUTO AND B8_PRODUTO = PRODUTO AND BF_LOTECTL = LOTE AND B8_LOTECTL = LOTE                           " + ENTER
//cQuery += "AND SBF010.D_E_L_E_T_='' AND SB8010.D_E_L_E_T_=''                                                                         " + ENTER
//cQuery += "AND Round(BF_QUANT,4) <> Round(B8_SALDO,4)                                                                                " + ENTER
//cQuery += "AND BF_LOCAL = '97' AND B8_LOCAL = '97' AND BF_LOCALIZ = '97PROCESSO'                                                     " + ENTER
//cQuery += "AND B8_SALDO >= 0                                                                                                         " + ENTER
//cQuery += "ORDER BY PRODUTO                                                                                                          " + ENTER

cQuery := "SELECT * FROM ( " + ENTER
cQuery += "SELECT TMP.*, B8_SALDO, " + ENTER
cQuery += "ISNULL((SELECT BF_QUANT FROM SBF010 (NOLOCK) WHERE BF_FILIAL = '"+xFilial("SBF")+"' AND BF_PRODUTO = PRODUTO AND BF_LOCAL = '97' AND BF_LOTECTL = LOTE AND BF_LOCALIZ = '97PROCESSO' AND D_E_L_E_T_=''),0) AS BF_QUANT " + ENTER
cQuery += " FROM             " + ENTER
cQuery += "(                                                 " + ENTER
cQuery += "SELECT B8_PRODUTO AS PRODUTO, B8_LOTECTL AS LOTE FROM SB8010 WHERE B8_FILIAL = '"+xFilial("SB8")+"' AND B8_LOCAL = '97' AND B8_SALDO <> 0 AND D_E_L_E_T_=''     " + ENTER
If !Empty(cProduto)
   cQuery += "AND B8_PRODUTO = '"+cProduto+"' "
EndIf
cQuery += "UNION                                                                                                                      " + ENTER
cQuery += "SELECT BF_PRODUTO AS PRODUTO,  BF_LOTECTL AS LOTE FROM SBF010 WHERE BF_FILIAL = '"+xFilial("SBF")+"' AND BF_LOCAL = '97' AND BF_QUANT <> 0 AND BF_LOCALIZ = '97PROCESSO' AND D_E_L_E_T_=''    " + ENTER
If !Empty(cProduto)
   cQuery += "AND BF_PRODUTO = '"+cProduto+"' "
EndIf
cQuery += ") TMP, SB8010                                                                                                      " + ENTER
cQuery += "WHERE B8_FILIAL = '"+xFilial("SB8")+"' AND B8_PRODUTO = PRODUTO AND B8_LOTECTL = LOTE                            " + ENTER
cQuery += "AND SB8010.D_E_L_E_T_=''                                                                          " + ENTER
cQuery += "AND B8_LOCAL = '97'  " + ENTER
cQuery += "AND B8_SALDO >= 0              " + ENTER                                                                                            
cQuery += ") TMP2 " + ENTER
cQuery += "WHERE Round(BF_QUANT,4) <> Round(B8_SALDO,4)                                                                                 " + ENTER

If !Empty(cProduto)
   cQuery += "AND PRODUTO = '"+cProduto+"' "
EndIf

cQuery += "ORDER BY PRODUTO " + ENTER

If Select("QSBF") <> 0
	QSBF->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QSBF"

SBF->( dbSetOrder(1) ) // BF_FILIA + BF_LOCAL + BF_LOCALIZ + BF_PRODUTO + BF_NUMSERI + BF_LOTECTL
SB8->( dbSetOrder(3) )

If !QSBF->( EOF() )
	//MsgInfo("fSD5003() - Query retornou registros")
	While !QSBF->( EOF() )
		
		If cProdRecalc <> QSBF->PRODUTO
			U_UMATA300( QSBF->PRODUTO, QSBF->PRODUTO, "97","97" )
			U_UMATA300( cProdRecalc  , cProdRecalc  , "97","97" )
			cProdRecalc := QSBF->PRODUTO
		EndIf
		
		nSaldoSBF := 0
		nSaldoSB8 := 0
		
		If SBF->( dbSeek( xFilial() + '97' + '97PROCESSO     ' + QSBF->PRODUTO + Space(Len(SBF->BF_NUMSERI)) + QSBF->LOTE ) )
			nSaldoSBF := Round(SBF->BF_QUANT,4)
		EndIf
		
		If SB8->( dbSeek( xFilial() + QSBF->PRODUTO + "97" + QSBF->LOTE ) )
			nSaldoSB8 := Round(SB8->B8_SALDO,4)
		EndIf
		
		If nSaldoSBF <> nSaldoSB8
			If nSaldoSBF < nSaldoSB8
				
				cNumIDOper := GetSx8Num('SDB','DB_IDOPERA'); ConfirmSX8()
				
				Reclock("SDB",.T.)
				SDB->DB_FILIAL  := xFilial("SDB")
				SDB->DB_ITEM    := '0001'
				SDB->DB_PRODUTO := QSBF->PRODUTO
				SDB->DB_LOCAL   := "97"
				SDB->DB_LOCALIZ := "97PROCESSO"
				SDB->DB_DOC     := '00003'
				SDB->DB_TM      := "009"
				SDB->DB_ORIGEM  := 'SD3'
				SDB->DB_QUANT   := nSaldoSB8 - nSaldoSBF
				SDB->DB_DATA    := dUlmes+1
				SDB->DB_LOTECTL := QSBF->LOTE
				SDB->DB_NUMSEQ  := ProxNum()
				SDB->DB_TIPO    := 'D'
				SDB->DB_SERVIC  := '499'
				SDB->DB_ATIVID  := 'ZZZ'
				SDB->DB_HRINI   := Time()
				SDB->DB_ATUEST  := 'S'
				SDB->DB_STATUS  := 'M'
				SDB->DB_ORDATIV := 'ZZ'
				SDB->DB_IDOPERA := cNumIDOper
				MsgInfo("Incluindo registro no SDB")
				SDB->( msUnlock() )
				
			EndIf
			If nSaldoSBF > nSaldoSB8
				
				cNumIDOper := GetSx8Num('SDB','DB_IDOPERA'); ConfirmSX8()
				
				Reclock("SDB",.T.)
				SDB->DB_FILIAL  := xFilial("SDB")
				SDB->DB_ITEM    := '0001'
				SDB->DB_PRODUTO := QSBF->PRODUTO
				SDB->DB_LOCAL   := "97"
				SDB->DB_LOCALIZ := "97PROCESSO"
				SDB->DB_DOC     := '00004'
				SDB->DB_TM      := "509"
				SDB->DB_ORIGEM  := 'SD3'
				SDB->DB_QUANT   := nSaldoSBF - nSaldoSB8
				SDB->DB_DATA    := dUlmes+1
				SDB->DB_LOTECTL := QSBF->LOTE
				SDB->DB_NUMSEQ  := ProxNum()
				SDB->DB_TIPO    := 'R'
				SDB->DB_SERVIC  := '999'
				SDB->DB_ATIVID  := 'ZZZ'
				SDB->DB_HRINI   := Time()
				SDB->DB_ATUEST  := 'S'
				SDB->DB_STATUS  := 'M'
				SDB->DB_ORDATIV := 'ZZ'
				SDB->DB_IDOPERA := cNumIDOper
				MsgInfo("Incluindo registro no SDB")
				SDB->( msUnlock() )
				
			EndIf
			
			N := aScan(aRefazSld,{|aVet| aVet[1] == QSBF->PRODUTO .and. aVet[2] == "97" })
			
			If Empty(n)
				AADD(aRefazSld,{QSBF->PRODUTO,"97"})
			EndIf
			
		EndIf
		
		QSBF->( dbSkip() )
	End
EndIf

//For n := 1 to len(aRefazSld)
//U_UMATA300( aRefazSld[n,1], aRefazSld[n,1], aRefazSld[n,2], aRefazSld[n,2] )
//Next n

Return

Static Function fProcSaldo(nRegua)

ProcRegua(nRegua)

While !D5PRODUTO->( EOF() )
   IncProc()
	U_UMATA300(D5PRODUTO->D5_PRODUTO,D5PRODUTO->D5_PRODUTO,D5PRODUTO->D5_LOCAL,D5PRODUTO->D5_LOCAL)
	D5PRODUTO->( dbSkip() )
End         

Return
