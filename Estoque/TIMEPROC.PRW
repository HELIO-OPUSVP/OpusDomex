#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"

/*
JONAS
*/

User Function  TIMEPROC()

    Local cHoraIni	  :=  ""
    Local cHoraFim 	  :=  ""

    Private nCount   := 1000

    If Type("cEmpAnt") == 'U'
        cRpcEmp    := "01"            // C�digo da empresa.
        cRpcFil    := "01"            // C�digo da filial.
        cEnvUser   := "Admin"         // Nome do usu�rio.
        cEnvPass   := "OpusDomex"     // Senha do usu�rio.
        cEnvMod    := "EST"           // 'FAT'  // C�digo do m�dulo.
        cFunName   := "U_TIMEPROC"  // 'RPC'  // Nome da rotina que ser� setada para retorno da fun��o FunName().
        aTables    := {}              // {}     // Array contendo as tabelas a serem abertas.
        lShowFinal := .F.             // .F.    // Alimenta a vari�vel publica lMsFinalAuto.
        lAbend     := .T.             // .T.    // Se .T., gera mensagem de erro ao ocorrer erro ao checar a licen�a para a esta��o.
        lOpenSX    := .T.             // .T.    // SE .T. pega a primeira filial do arquivo SM0 quando n�o passar a filial e realiza a abertura dos SXs.
        lConnect   := .T.             // .T.    // Se .T., faz a abertura da conexao com servidor As400, SQL Server etc

        //RPCSetType(3)
        RpcSetEnv(cRpcEmp,cRpcFil,cEnvUser,cEnvPass,cEnvMod,cFunName,aTables,lShowFinal,lAbend,lOpenSX,lConnect) //PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"
    EndIf

    If MsgYesNo("Deseja iniciar a medi��o de tempo de leitura","Leitura Movimentos (SD3,SD1,SB2)")
        cHoraIni := Time()
        TIMELAP()
        cHoraFim := Time()
        cDuracao := fTempo(cHoraIni,cHoraFim)
        MsgYesNo('Dura��o total: ' + cDuracao + ' processamento de ' + Alltrim(Str(nCount)) + ' de cada tabela')
    EndIf

Return

Static Function TIMELAP()
    Local cReturn  := ""
    Local cQuery   := ""
    Local aAlias   := {'SD3','SD1','SB2'}

    For x := 1 to Len(aAlias)
        cAlias := aAlias[x]
        cQuery := " SELECT ORDEM, CHAVE FROM SIX010 (NOLOCK) WHERE INDICE='"+cAlias+"' AND ORDEM <> '1' "

        If Select("QSIX") <> 0
            QSIX->( dbCloseArea() )
        EndIf

        TCQUERY cQuery NEW ALIAS "QSIX"

        While !QSIX->( EOF() )

            cQry:= " SELECT TOP "+Alltrim(Str(nCount))+" * FROM " + RetSqlName(cAlias) + " WHERE D_E_L_E_T_='' ORDER BY R_E_C_N_O_ DESC"

            If Select("QTAB") <> 0
                QTAB->( dbCloseArea() )
            EndIf

            TCQUERY cQry NEW ALIAS "QTAB"

            cQrySX3 := "SELECT X3_CAMPO FROM SX3010 WHERE X3_ARQUIVO = '"+cAlias+"' AND X3_TIPO = 'D' "

            If Select("QSX3") <> 0
                QSX3->( dbCloseArea() )
            EndIf

            TCQUERY cQrySX3 NEW ALIAS "QSX3"

            While !QSX3->( EOF() )
                TcSetField("QTAB",QSX3->X3_CAMPO  ,"D",  8, 0)
                QSX3->( dbSkip() )
            End

            While !QTAB->( EOF() )

                (cAlias)->( DbSetOrder( RetOrder(cAlias,QSIX->CHAVE) ) )
                cPesquisa := QTAB->(&(QSIX->CHAVE))

                If (cAlias)->( DBSeek(cPesquisa) )
                    Reclock(cAlias,.F.)

                    (cAlias)->( msUnlock() )
                Else
                    n := 1
                EndIf
                QTAB->(DBSkip())
            Enddo

            QSIX->(dbSkip())
        Enddo

    Next x

Return cReturn

Static Function fTempo(cTime1,cTime2)
    Local nTime1   := 0
    Local nTime2   := 0
    Local nResult  := 0
    Local nHrRet   := 0
    Local nMinRet  := 0
    Local nSegRet  := 0
    Local cRetorno := ''

    nTime1 += (Val(Subs(cTime1,1,2)) * 60) * 60
    nTime1 += (Val(Subs(cTime1,4,2)) * 60)
    nTime1 += Val(Subs(cTime1,7,2))

    nTime2 += (Val(Subs(cTime2,1,2)) * 60) * 60
    nTime2 += (Val(Subs(cTime2,4,2)) * 60)
    nTime2 += Val(Subs(cTime2,7,2))

    nResult := nTime2 - nTime1

    nHrRet := Int(nResult/3600)
    nResult -= (nHrRet * 3600)

    nMinRet := Int(nResult/60)
    nResult -= (nMinRet * 60)

    nSegRet := nResult

    cRetorno := StrZero(nHrRet,2)+ ':' + StrZero(nMinRet,2) + ':' + StrZero(nSegRet,2)

Return cRetorno