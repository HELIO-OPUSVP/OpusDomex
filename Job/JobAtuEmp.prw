#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "TOPCONN.CH"

// Atualiza o B2_QEMP
User Function JobEmp01()
U_JobAtuEmp("01")
Return

User Function JobEmp02()
U_JobAtuEmp("02")
Return

User Function JobAtuEmp(cFil)

	Local cAlias    := ""
	Local cQuery    := ""
	Local aDados    := {}
	Local aRecP05   := {}
	Local cIndice   := ""
	Local cChave    := ""
	Local cCampo	:= ""
	Local cTabela	:= ""
	Local nQuant    := 0
	Local nI		:= 0
	Local nPos		:= 0
	Local aProdutos := {}

	//Default cFil := "01"
	//U_RpcSetEnv()
	RpcSetType(3)
	//RpcSetEnv("01","01")

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL cFil TABLES  "P05" , "P07"  ,"SB2" ,"SBF" ,"SB8"
	P05->(DbSetOrder(1))
	P07->(DbSetOrder(1))
	SB2->(DbSetOrder(1))
	SBF->(DbSetOrder(1))
	SB8->(DbSetOrder(1))


	If ! LockByName("JOBATUEMP"+cFil, .F. , .F. )
		ConOut( "Job em execucao, encerrando rotina - JOBATUEMP.PRW em "+DtoC( Date() )+" "+Time() )
		Return nil
	EndIf

	cAlias := GetNextAlias()

	P05->(DbSetOrder(1))
	P05->(DbGoTop())

	lWhile := .T.
	nWhile := 0

	While lWhile .and. nWhile <= 100    // P05->(!Eof())
		nWhile++

		cQuery := "SELECT TOP 1 P05_ALIAS, P05_FILIAL, P05_INDICE, P05_CHAVE FROM " + RetSqlName("P05") + " (NOLOCK) WHERE P05_FILIAL = '"+xFilial("P05")+"' AND D_E_L_E_T_ = ''  AND P05_DTFIM = '' ORDER BY R_E_C_N_O_ "

		If Select("QUERYP05") <> 0
			QUERYP05->(dbclosearea())
		EndIf

		TCQUERY cQuery NEW ALIAS "QUERYP05"

		If !QUERYP05->( EOF() )
			cQuery := "SELECT * FROM " + RetSqlName("P05") + " (NOLOCK) "
			cQuery += "		WHERE D_E_L_E_T_ <> '*' AND P05_DTFIM = '' "
			cQuery += "			AND P05_ALIAS  = '" + QUERYP05->P05_ALIAS  + "' AND P05_FILIAL = '" + QUERYP05->P05_FILIAL + "' "
			cQuery += "			AND P05_INDICE = '" + QUERYP05->P05_INDICE + "' AND P05_CHAVE = '"  + QUERYP05->P05_CHAVE + "'"

			//cQuery := ChangeQuery(cQuery)
			DbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery),(cAlias),.F.,.T.)

			aDados    := {}
			While (cAlias)->(!Eof())

				cIndice  := (cAlias)->P05_INDICE
				cChave   := (cAlias)->P05_CHAVE
				cCampo   := (cAlias)->P05_CAMPO
				cTabela  := (cAlias)->P05_ALIAS
				nQuant   := Val((cAlias)->P05_SOMA)

				nPos := Ascan(aDados,{|x| x[1] == cIndice .And. x[2] == cChave .And. x[3] == cCampo .And. x[4] == cTabela})

				If nPos == 0
					aAdd(aDados,{cIndice,cChave,cCampo,cTabela,nQuant})
				Else
					aDados[nPos][5] += nQuant
				EndIf

				aAdd(aRecP05,(cAlias)->R_E_C_N_O_)

				(cAlias)->(DbSkip())
			EndDo

			(cAlias)->(DbCloseArea())

			For nI := 1 to Len(aDados)

				DbSelectArea(aDados[nI][4])

				DbSetOrder(Val(aDados[nI][1]))

				If DbSeek(aDados[nI][2])

					If RecLock(aDados[nI][4],.F.)
						&(aDados[nI][4]+"->"+aDados[nI][3]+"+="+AllTrim(Str(aDados[nI][5])))
						MsUnlock()

						//If AllTrim(aDados[nI][4]) == "SB2"
						//	aAdd(aProdutos,{SB2->B2_COD,SB2->B2_LOCAL})
						//ElseIf AllTrim(aDados[nI][4]) == "SBF"
						//	aAdd(aProdutos,{SBF->BF_PRODUTO,SBF->BF_LOCAL})
						//ElseIf AllTrim(aDados[nI][4]) == "SB8"
						//	aAdd(aProdutos,{SB8->B8_PRODUTO,SB8->B8_LOCAL})
						//EndIf
						aAdd(aProdutos,{P05->P05_PRODUT,P05->P05_LOCAL})
					EndIf

				EndIf

			Next nI

			P07->(DbSetOrder(1))

			For nI := 1 To Len(aProdutos)

				If !P07->(dbSeek(xFilial()+aProdutos[nI][1]+aProdutos[nI][2]))
					If RecLock("P07",.T.)
						P07->P07_FILIAL := xFilial("P07")
						P07->P07_PRODUT := aProdutos[nI][1]
						P07->P07_LOCAL	:= aProdutos[nI][2]
						P07->P07_DATA   := Date()
						P07->P07_HORA   := Time()
						P07->(MsUnlock())
					EndIf
				EndIf

			Next nI

			nRecnos := 0
			cRecnos := ''
			For nI := 1 to Len(aRecP05)
				nRecnos++
				cRecnos += Alltrim(Str(aRecP05[nI]))+','
				If nRecnos == 100
					cRecnos := Subs(cRecnos,1,Len(cRecnos)-1)
					cQuery := "UPDATE " + RetSqlName('P05') +" SET P05_DTFIM = '"+DtoS(Date())+"', P05_HRFIM = '"+Time()+"', D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ WHERE R_E_C_N_O_ IN ("+cRecnos+") "
					TCSQLEXEC(cQuery)
					nRecnos := 0
					cRecnos := ''
				EndIf
			Next nI

			If !Empty(cRecnos)
				cRecnos := Subs(cRecnos,1,Len(cRecnos)-1)
				cQuery := "UPDATE " + RetSqlName('P05') +" SET P05_DTFIM = '"+DtoS(Date())+"', P05_HRFIM = '"+Time()+"', D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ WHERE R_E_C_N_O_ IN ("+cRecnos+") "
				TCSQLEXEC(cQuery)
				cRecnos := ''
			EndIf

			/*
			For nI := 1 to Len(aRecP05)
				P05->(DbGoTo(aRecP05[nI]))
				If RecLock("P05",.F.)
					P05->P05_DTFIM := Date()
					P05->P05_HRFIM := Time()
					P05->(MsUnlock())

					RecLock("P05",.F.)
					P05->(DbDelete())
					P05->(MsUnlock())
				EndIf
			Next nI
			*/
			//P05->(dbSkip())
		Else
			lWhile := .F.
		EndIf

		If Select("QUERYP05") <> 0
			QUERYP05->(dbclosearea())
		EndIf

	EndDo

	UnLockByName("JOBATUEMP"+cFil, .F., .F. , .T. )

Return



User Function JobAtuS1()
	U_JobAtuSld("01")
Return

User Function JobAtuS2()
	U_JobAtuSld("02")
Return

User Function JobAtuSld(cFil)

	Local cQuery := ""
	Local cAlias
	Local cHora
	Local nMinMP := -60

	If Type("cUsuario") == "U"
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA "01" FILIAL cFil TABLES  "P05" , "P07"  ,"SB2" ,"SBF" ,"SB8"
	EndIf

	If ! LockByName("JOBATUSLD"+cFil, .F. , .F. )
		ConOut( "Job em execucao, encerrando rotina - JOBATUSLD em "+DtoC( Date() )+" "+Time() )
		Return nil
	EndIf

	lWhile := .T.

	cAlias := GetNextAlias()

	nProds := 0

	While lWhile .and. nProds <= 10
		nProds++

		cHora  := CalcHora(nMinMP)
		cQuery := "SELECT TOP 1 P07_PRODUT, P07_LOCAL, B1_TIPO, "+RetSqlName("P07")+".R_E_C_N_O_ AS RECNO "
		cQuery += " FROM "+RetSqlName("P07")+" (NOLOCK) "
		cQuery += "	INNER JOIN "+RetSqlName("SB1")+" ON P07_PRODUT = B1_COD "
		cQuery += "	WHERE "+RetSqlName("P07")+".D_E_L_E_T_ = '' AND P07_DATAIN = '' "
		cQuery += " AND B1_TIPO <> 'PA' "
		cQuery += " AND P07_FILIAL = '"+xFilial("P07")+"' "
		cQuery += " AND (P07_DATA <> '"+DtoS(Date())+"' OR P07_HORA < '"+cHora+"' OR P07_HORA = '23:59:59')"
		cQuery += "	ORDER BY P07_DATA, P07_HORA, P07010.R_E_C_N_O_ "

		DbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery),(cAlias),.F.,.T.)

		If !(cAlias)->( Eof() )

			P07->(DbGoTo((cAlias)->RECNO))
			If P07->(Recno()) == (cAlias)->RECNO
				P07->(RecLock("P07",.F.))
				P07->P07_DATAIN := Date()
				P07->P07_HORAIN := Time()
				P07->(MsUnlock())
			EndIf

			If !Empty((cAlias)->P07_PRODUT)
				U_UMATA300((cAlias)->P07_PRODUT,(cAlias)->P07_PRODUT,(cAlias)->P07_LOCAL,(cAlias)->P07_LOCAL)
				Conout("Jobatuemp MP Produto: " + (cAlias)->P07_PRODUT + " " + DtoC(Date()) + " " + Time() )
			EndIf

			P07->(DbGoTo((cAlias)->RECNO))
			If P07->(Recno()) == (cAlias)->RECNO
				P07->( RecLock("P07",.F.))
				P07->P07_DATAFI := Date()
				P07->P07_HORAFI := Time()
				P07->( msUnlock() )

				P07->( RecLock("P07",.F.))
				P07->( dbDelete() )
				P07->( msUnlock() )
			EndIf

		Else
			lWhile := .F.
		EndIf

		(cAlias)->(DbCloseArea())

	End

	U_JobPASld(cFil)

Return

User Function JobPASld(cFil,cProduto)

	Local cQuery := ""
	Local cAlias := GetNextAlias()
	Local cHora
	Local nMinPA := -5


	Default cProduto   := ""

	If Type("cUsuario") == "U"
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA "01" FILIAL cFil TABLES  "P05" , "P07"  ,"SB2" ,"SBF" ,"SB8"
	EndIf

	lWhile := .T.

	While lWhile
		cHora := CalcHora(nMinPA)
		cQuery := "SELECT TOP 1 P07_PRODUT, P07_LOCAL, B1_TIPO, "+RetSqlName("P07")+".R_E_C_N_O_ AS RECNO "
		cQuery += " FROM "+RetSqlName("P07")+" (NOLOCK) "
		cQuery += "	INNER JOIN "+RetSqlName("SB1")+" ON P07_PRODUT = B1_COD "
		cQuery += "	WHERE "+RetSqlName("P07")+".D_E_L_E_T_ = '' AND P07_DATAIN = '' "
		cQuery += " AND P07_FILIAL = '"+xFilial("P07")+"' "
		If Empty(cProduto)
			cQuery += " AND B1_TIPO = 'PA' "
			cQuery += " AND (P07_DATA <> '"+DtoS(Date())+"' OR P07_HORA < '"+cHora+"' OR P07_HORA = '23:59:59')"
		Else
			cQuery += " AND P07_PRODUT='"+ALLTRIM(cProduto)+"' "
		EndIF
		cQuery += "	ORDER BY P07_DATA, P07_HORA, P07010.R_E_C_N_O_ "

		DbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery),(cAlias),.F.,.T.)

		If !(cAlias)->(Eof())

			P07->(DbGoTo((cAlias)->RECNO))
			If P07->(Recno()) == (cAlias)->RECNO
				P07->(RecLock("P07",.F.))
				P07->P07_DATAIN := Date()
				P07->P07_HORAIN := Time()
				P07->(MsUnlock())
			EndIf

			If !Empty((cAlias)->P07_PRODUT)
				U_UMATA300((cAlias)->P07_PRODUT,(cAlias)->P07_PRODUT,(cAlias)->P07_LOCAL,(cAlias)->P07_LOCAL)
				Conout("Jobatuemp PA Produto: " + (cAlias)->P07_PRODUT + " " + DtoC(Date()) + " " + Time() )
			EndIf

			P07->(DbGoTo((cAlias)->RECNO))
			If P07->(Recno()) == (cAlias)->RECNO
				P07->(RecLock("P07",.F.))
				P07->P07_DATAFI := Date()
				P07->P07_HORAFI := Time()
				P07->(MsUnlock())

				P07->(RecLock("P07",.F.))
				P07->(DbDelete())
				P07->(MsUnlock())
			EndIf

		Else
			lWhile := .F.
		EndIf

		(cAlias)->(DbCloseArea())

	End

	UnLockByName("JOBATUSLD"+cFil, .F., .F. , .T. )

Return

User Function JobStop()

	Local cQuery := ""
	Local cAlias := ""

	RpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" TABLES  "P05" , "P07"  ,"SB2" ,"SBF" ,"SB8"

	cAlias := GetNextAlias()

	cQuery := " SELECT TOP 1 RIGHT('00' + DateDiff(Minute,CONVERT(time,P07_HORAIN), Convert(time,CURRENT_TIMESTAMP)) % 60, 2) AS MINUTOS FROM " + RetSqlName("P07")
	cQuery += "	WHERE D_E_L_E_T_ = '' AND P07_HORAFI = '' AND P07_HORAIN <> '' "
	cQuery += " ORDER BY P07_DATAIN, P07_HORAIN ASC "

	DbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery),(cAlias),.F.,.T.)

	(cAlias)->(DbGoTop())

	ConOut("Minutos:" + (cAlias)->MINUTOS)
	If !Empty((cALias)->MINUTOS)
		If Val((cAlias)->MINUTOS) >= 10
			WinExec("cmd.exe /c sc stop .:13-Protheus12-Schedulle-2115")
			ConOut("SC STOP")
			WinExec('TaskKill /f /FI "SERVICES eq .:13-Protheus12-Schedulle-2115"')
			ConOut("TASKKILL")
			Sleep(5000)
			TcSqlExec(" UPDATE P07010 SET P07_DATAIN = '' , P07_HORAIN = '' WHERE  D_E_L_E_T_ <> '*'")
			ConOut("UPDATE")
			WinExec("cmd.exe /c sc start .:13-Protheus12-Schedulle-2115")
			ConOut("SC START")
		EndIf
	EndIf

	(cALias)->(DbCloseArea())

Return Nil

Static Function CalcHora(nParam)
	Local cHoraAtu := Time()

	nHoraAtu := Val(Subs(cHoraAtu,1,2))
	nMinAtu  := Val(Subs(cHoraAtu,4,2))
	cSegAtu  := Subs(cHoraAtu,7,2)

	nMinTot := (nHoraAtu * 60) + nMinAtu

	nMinRetorno := nMinTot + nParam

	If nMinRetorno < 0
		nMinRetorno := 0
	EndIf

	nHoraRet := Int(nMinRetorno/60)
	nMinRet  := nMinRetorno - (nHoraRet*60)

	_Retorno := StrZero(nHoraRet,2)+':'+StrZero(nMinRet,2)+':'+cSegAtu

Return _Retorno
