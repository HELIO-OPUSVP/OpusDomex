#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "MSOBJECT.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DOMSLD97  ºAutor  ³Mauricio            º Data ³  08/07/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Relatório de Divergências do WIP (97)                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*------------------------------------------------------
USER FUNCTION DOMSLD97()
    *------------------------------------------------------

    Local oFont1 	   := TFont():New("Arial Narrow",,022,,.F.,,,,,.F.,.F.)
    Local _cPAR01     := FirstDay(DATE())
    Local _cPAR02     := LastDay(DATE())
    Local _cPAR03     := SPACE(15)
    Local _cPAR04     := 'ZZZZZZZZZZZZZZZ' //'1719321VD30'
    Local _cPAR05     :=  SPACE(15)
    Local _cPAR06     := 'ZZZZZZZZZZZZZZZ'
//Local _cPAR07     := 'ZZZZ'


    Local oGet1
    Local oGet2
    Local oGet3
    Local oGet4
    Local oSButton1
    Local oSButton2
    Static oDlgEST

    PRIVATE ccadastro := 'Estoque 97'
    PRIVATE lImport   := .F.
    PRIVATE cTIPO     := SPACE(02)

    PRIVATE aSaldos   := {}
    PRIVATE aSLDNEG   := {}
    PRIVATE nQuant    := 0
    PRIVATE dData1    := CTOD('30/12/2012')
    PRIVATE dData2    := CTOD('30/12/2012')
    PRIVATE nX        := 0
    PRIVATE nDIAS     := 0
    PRIVATE lfirst    := .t.
    Private cComboBox1 := "Divergencias"

//_cPAR01           := date()
//_cPAR02           := date()

    DEFINE MSDIALOG oDlgEST TITLE "Estoque 97 " FROM 000, 000  TO 280, 270 COLORS 0, 16777215 PIXEL

//@ 011, 010 SAY oSay0 PROMPT "Estoque 97  "	          SIZE 136, 014 OF oDlgEST FONT oFont1 COLORS 16711680, 16777215 PIXEL
    @ 017, 010 SAY oSay1 PROMPT "De Data        :" 	          SIZE 045, 007 OF oDlgEST COLORS 0, 16777215 PIXEL
    @ 030, 010 SAY oSay2 PROMPT "Ate Data       :" 	          SIZE 045, 007 OF oDlgEST COLORS 0, 16777215 PIXEL
    @ 043, 010 SAY oSay3 PROMPT "De Produto     :" 	          SIZE 045, 007 OF oDlgEST COLORS 0, 16777215 PIXEL
    @ 056, 010 SAY oSay4 PROMPT "Ate Produto    :" 	          SIZE 045, 007 OF oDlgEST COLORS 0, 16777215 PIXEL
    @ 069, 010 SAY oSay5 PROMPT "Da OP      	:" 	          SIZE 045, 007 OF oDlgEST COLORS 0, 16777215 PIXEL
    @ 082, 010 SAY oSay6 PROMPT "Ate OP    		:" 	          SIZE 045, 007 OF oDlgEST COLORS 0, 16777215 PIXEL
    @ 095, 010 SAY oSay7 PROMPT "Imprime        :" 	          SIZE 045, 007 OF oDlgEST COLORS 0, 16777215 PIXEL


    @ 017, 050 MSGET oGet1 VAR _cPAR01 WHEN(.T.)           	  SIZE 050, 010 OF oDlgEST COLORS 0, 16777215 PIXEL
    @ 030, 050 MSGET oGet2 VAR _cPAR02 WHEN(.T.)           	  SIZE 050, 010 OF oDlgEST COLORS 0, 16777215 PIXEL
    @ 043, 050 MSGET oGet3 VAR _cPAR03 WHEN(.T.) F3("SB1") 	  SIZE 050, 010 OF oDlgEST COLORS 0, 16777215 PIXEL
    @ 056, 050 MSGET oGet4 VAR _cPAR04 WHEN(.T.) F3("SB1") 	  SIZE 050, 010 OF oDlgEST COLORS 0, 16777215 PIXEL
    @ 069, 050 MSGET oGet5 VAR _cPAR05 WHEN(.T.)           	  SIZE 080, 010 OF oDlgEST COLORS 0, 16777215 PIXEL
    @ 082, 050 MSGET oGet6 VAR _cPAR06 WHEN(.T.)           	  SIZE 080, 010 OF oDlgEST COLORS 0, 16777215 PIXEL
//@ 095, 050 MSGET oGet6 VAR _cPAR06 WHEN(.T.)           SIZE 150, 010 OF oDlgEST COLORS 0, 16777215 PIXEL
    @ 095, 050 MSCOMBOBOX oComboBox1 VAR cComboBox1 ITEMS {"Divergencias","Todos"} SIZE 080, 010 OF oDlgEST COLORS 0, 16777215 PIXEL

    DEFINE SBUTTON oSButton1 FROM 115, 041 TYPE 01 OF oDlgEST ENABLE Action (lImport :=.T., oDlgEST:End() )
    DEFINE SBUTTON oSButton2 FROM 115, 077 TYPE 02 OF oDlgEST ENABLE Action (lLOOP   :=.F., oDlgEST:End() )//oDlgEST:End()

    ACTIVATE MSDIALOG oDlgEST CENTERED

    IF lImport ==.T.
        lImport   :=.F.
        dData1    := _cPAR01
        dData2    := _cPAR02
        cCOD1     := _cPAR03
        cCOD2     := _cPAR04
        cOP1      := _cPAR05
        cOP2      := _cPAR06

        If ApMsgYesNo("Deseja corrigir itens com consumo de lote divergente..","Deseja Continuar?")
            //	U_CORLOTE()
            If ApMsgYesNo("Correção de lotes realizada.","Deseja Continuar?")
                U_SLD97A()
            EndIf
        Else
            U_SLD97A()
        Endif

    EndIf

RETURN


    *------------------------------------------------------
USER FUNCTION SLD97A()
    *------------------------------------------------------

    aMVD1  := {}

    aAdd( aMVD1, { "TIPO"         ,"C"  ,03,0 } )
    aAdd( aMVD1, { "PRODUTO"      ,"C"  ,15,0 } )
    aAdd( aMVD1, { "OP"           ,"C"  ,15,0 } )

    aAdd( aMVD1, { "EMP_OP"       ,"N"  ,15,3 } )
    aAdd( aMVD1, { "PAG_OP"       ,"N"  ,15,3 } )
    aAdd( aMVD1, { "ENT_PROD"     ,"N"  ,15,3 } )
    aAdd( aMVD1, { "DEV_OP"       ,"N"  ,15,3 } )
    aAdd( aMVD1, { "CONSUMO"      ,"N"  ,15,3 } )
    aAdd( aMVD1, { "CONSUMO_DF"   ,"N"  ,15,3 } )
    aAdd( aMVD1, { "PER_DOMEX"    ,"N"  ,15,3 } )
    aAdd( aMVD1, { "PER_FORNEC"   ,"N"  ,15,3 } )
    aAdd( aMVD1, { "SLD_LOTE"     ,"N"  ,15,3 } )
    aAdd( aMVD1, { "DIF_LOTE"     ,"N"  ,15,3 } )
    aAdd( aMVD1, { "DIFERENCA"    ,"N"  ,15,3 } )


    MVD1   := CriaTrab( aMVD1, .t. )
    dbUseArea(.T.,,MVD1,"MVD1",.F.,.F.)
    cKey   := "PRODUTO"
    cCond  := ""
    cIndex := CriaTrab(NIL,.F.)
    IndRegua( "MVD1" ,cIndex ,cKey ,,cCond ,"Indexando Arq.Temporario")

    dbSelectArea("MVD1")

    PROCESSA({||U_SLD97B()})
RETURN

    *------------------------------------------------------
USER FUNCTION SLD97B()
    *------------------------------------------------------

    LOCAL cQuery  	 := ''
    Local aResult 	 := {}
    Local nSaldoLote := 0
    Local nSaldoLTot := 0
    Local nLoop		 := 0
    Local aSaldoLote := {}
    Local _cCOD 	 := ''
    Local _cOP  	 := ''
    Local lTodos     := .f.


    If cComboBox1="Todos"
        lTodos := .T.
    EndIF



//----------------------------------MOVIMENTO------------------------------------------------
    cQuery:=" SELECT * FROM  "
    cQuery+=" (SELECT COD=D3_COD,OP=D3_OP FROM "+RETSQLNAME('SD3')+ " "
    cQuery+=" WHERE D3_EMISSAO >='"+DTOS(dData1)+"' AND D3_EMISSAO <='"+DTOS(dData2)+"' "
    cQuery+=" AND   D3_COD     >='"+cCOD1       +"' AND D3_COD     <='"+cCOD2+"' "
    cQuery+=" AND   D3_OP      >='"+cOP1        +"' AND D3_OP      <='"+cOP2+"' "
    cQuery+=" AND D3_LOCAL='97' "
    cQuery+=" AND D3_OP<>'' "
    cQuery+=" UNION ALL  "
    cQuery+=" SELECT COD=D3_COD,OP=D3_XXOP   FROM SD3010 "
    cQuery+=" WHERE D3_EMISSAO >='"+DTOS(dData1)+"' AND D3_EMISSAO <='"+DTOS(dData2)+"' "
    cQuery+=" AND   D3_COD     >='"+cCOD1       +"' AND D3_COD     <='"+cCOD2+"' "
    cQuery+=" AND   D3_XXOP    >='"+cOP1        +"' AND D3_XXOP    <='"+cOP2+"' "
    cQuery+=" AND D3_LOCAL='97' "
    cQuery+=" AND D3_XXOP<>'') AS QR1 "
    cQuery+=" GROUP BY COD,OP "
    cQuery+=" ORDER BY COD,OP "

//union b8   union d4 com saldo
//parametro so diferenca
//-------------------------------EMPENHO  FORA MOVIMENTO PERIODO------------------------------
    cQuery2:=" SELECT COD=D4_COD,OP=D4_OP  "
    cQuery2+=" FROM "+RETSQLNAME('SD4')+"  WHERE D4_QUANT>0  AND D_E_L_E_T_='' AND D4_FILIAL='01'  "
    cQuery2+=" AND D4_COD >='"+cCOD1       +"' AND D4_COD     <='"+cCOD2+"' "
    cQuery2+=" AND D4_LOCAL <> '" + SuperGetMv("MV_XXLOCPE",,"96") + "' AND D4_OP NOT IN  "
    cQuery2+=" ( "
    cQuery2+=" SELECT OP FROM   "
    cQuery2+=" (SELECT OP=D3_OP  FROM "+RETSQLNAME("SD3")+" WITH(NOLOCK) "
    cQuery2+=" WHERE D3_EMISSAO >='"+DTOS(dData1)+"' AND D3_EMISSAO <='"+DTOS(dData2)+"' "
    cQuery2+=" AND   D3_COD     >='"+cCOD1       +"' AND D3_COD     <='"+cCOD2+"' "
    cQuery2+=" AND   D3_OP      >='"+cOP1        +"' AND D3_OP      <='"+cOP2+"' "
    cQuery2+=" AND D3_LOCAL='97' "
    cQuery2+=" AND D3_OP<>''  "
    cQuery2+=" UNION ALL  "
    cQuery2+=" SELECT OP=D3_XXOP FROM "+RETSQLNAME("SD3")+" WITH(NOLOCK) "
    cQuery2+=" WHERE D3_EMISSAO >='"+DTOS(dData1)+"' AND D3_EMISSAO <='"+DTOS(dData2)+"' "
    cQuery2+=" AND   D3_COD     >='"+cCOD1       +"' AND D3_COD     <='"+cCOD2+"' "
    cQuery2+=" AND   D3_XXOP    >='"+cOP1        +"' AND D3_XXOP    <='"+cOP2+"' "
    cQuery2+=" AND D3_LOCAL='97'  "
    cQuery2+=" AND D3_XXOP<>'') AS QR1 "
    cQuery2+=" GROUP BY OP  "
    cQuery2+=" ) "
//-----------------------------------------------------------------------------------------------

//TCQUERY cQuery2 Alias "TM2" New
//DBSELECTAREA("TM2")

    TCQUERY cQuery Alias "TMP" New

    DBSELECTAREA("TMP")
    DBGOTOP()
    PROCREGUA(TMP->(RECCOUNT()))
    DO WHILE !TMP->(EOF())

        //Verifica se já foi feita a correção (executa até 5 correções para o mesmo itens antes de emitir o relatorio) evitando loop
        If _cOP  == TMP->OP .and. _cCOD == TMP->COD
            nLoop := nLoop + 1
        Else
            nLoop := 1
        EndIf

        _cCOD := TMP->COD
        _cOP  := TMP->OP

        INCPROC('MOV '+ALLTRIM(_cCOD)+' '+ALLTRIM(_cOP))

        cQuery1 :=" exec SLDDOMEX '"+_cOP+"','"+_cCOD+"'  "
        TCQUERY cQuery1 Alias "TR1" New
        DBSELECTAREA("TR1")


        IF !EMPTY(TR1->PRODUTO)

            aSaldoLote := CalcEstL(TR1->PRODUTO,'97', date()+1, SUBSTR(TR1->OP,1,8))
            nSaldoLote := aSaldoLote[1]
            dbSelectArea("MVD1")
            RecLock('MVD1',.T.)


            // Desconsidera itens sem divergencias
            If ((TR1->PAG_OP-TR1->DEV_OP-TR1->CONSUMO)- nSaldoLote) == 0 .and. !lTodos
                If (TR1->EMP_OP - nSaldoLote ) == 0
                    MVD1->(MsUnlock())
                    TMP->(DBSKIP())
                    TR1->(DBCLOSEAREA())
                    loop
                EndIf
            EndIf

            //Desconsidera itens com só com OP gerada, sem movimento no 97
            If (TR1->PAG_OP==0 .and. TR1->CONSUMO==0 .and. nSaldoLote==0 .and. TR1->CONSUMO_DIF==0 .and. TR1->DEV_OP==0) .and. !lTodos
                If (TR1->EMP_OP <> 0)
                    MVD1->(MsUnlock())
                    TMP->(DBSKIP())
                    TR1->(DBCLOSEAREA())
                    loop
                EndIf
            EndIf

            //Desconsidera itens com pagamento maior que o empenho e SALDO DE LOTE igual ao EMPENHO
            If (TR1->PAG_OP>TR1->EMP_OP .and. nSaldoLote==TR1->EMP_OP .and. TR1->CONSUMO==0  .and. TR1->CONSUMO_DIF==0 .and. TR1->DEV_OP==0) .and. !lTodos
                If (TR1->EMP_OP > 0)
                    MVD1->(MsUnlock())
                    TMP->(DBSKIP())
                    TR1->(DBCLOSEAREA())
                    loop
                EndIf
            EndIf

            //Desconsidera item com Entrada igual ao saldo do empenho, e igual a quantidade devolvida, mas sem saldo do lote
            If (TR1->PAG_OP==TR1->EMP_OP  .and. TR1->DEV_OP==TR1->EMP_OP .and. TR1->CONSUMO==0 .and. nSaldoLote==0 .and. TR1->CONSUMO_DIF==0 ) .and. !lTodos
                If (TR1->EMP_OP > 0)
                    MVD1->(MsUnlock())
                    TMP->(DBSKIP())
                    TR1->(DBCLOSEAREA())
                    loop
                EndIf
            EndIf


            If !lTodos
                //CORRECOES
                //Corrigi itens com lote negativo
                If nSaldoLote<0 .and. nLoop<6
                    //devolução
                    UCORSD5(TR1->PRODUTO,'97',nSaldoLote * (-1),SUBSTR(TR1->OP,1,8))
                    U_CRIAP07(TR1->PRODUTO,'97',.T.)
                    MVD1->(MsUnlock())
                    TR1->(DBCLOSEAREA())
                    LOOP
                EndIf

                //Roda Saldo Atual para saldo B8_SALDO diferente da CALCEST
                IF nSaldoLote <> TR1->SLD_LOTE
                    U_CRIAP07(TR1->PRODUTO,'97',.T.)
                EndIF


                //Item com Entrada igual ao saldo do empenho, mas sem saldo do lote
                If (TR1->PAG_OP==TR1->EMP_OP .and. TR1->CONSUMO==0 .and. nSaldoLote==0 .and. TR1->CONSUMO_DIF==0 .and. TR1->DEV_OP==0) .and. nLoop<6 //.and. !lTodos
                    If (TR1->EMP_OP > 0)
                        //Devolucao
                        UCORSD5(TR1->PRODUTO,'97',TR1->PAG_OP,SUBSTR(TR1->OP,1,8))
                        U_CRIAP07(TR1->PRODUTO,'97',.T.)
                        MVD1->(MsUnlock())
                        TR1->(DBCLOSEAREA())
                        loop
                    EndIf
                EndIf

                //Item com Entrada igual ao saldo do empenho, e igual a quantidade devolvida, mas sem saldo do lote
                //		If (TR1->PAG_OP==TR1->EMP_OP  .and. TR1->DEV_OP==TR1->EMP_OP .and. TR1->CONSUMO==0 .and. nSaldoLote==0 .and. TR1->CONSUMO_DIF==0 ) .and. nLoop<6 .and. nLoop<6 //.and. !lTodos
                //		If (TR1->EMP_OP > 0)
                //			UCORSD5(TR1->PRODUTO,'97',TR1->PAG_OP,SUBSTR(TR1->OP,1,8))
                //			U_CRIAP07(TR1->PRODUTO,'97',.T.)
                //			MVD1->(MsUnlock())
                //			TR1->(DBCLOSEAREA())
                //			loop
                //		EndIf
                //	EndIf


                //Item com Entrada maior que o saldo de empenho e saldo de empenho igual a entrada
                If (TR1->PAG_OP>TR1->EMP_OP .and. nSaldoLote==TR1->PAG_OP .and. TR1->CONSUMO==0  .and. TR1->CONSUMO_DIF==0 .and. TR1->DEV_OP==0) .and. nLoop<6 //.and. !lTodos
                    If (TR1->EMP_OP > 0)
                        //REQUISITA
                        UDORSD5(TR1->PRODUTO,'97',(TR1->PAG_OP-TR1->EMP_OP),SUBSTR(TR1->OP,1,8))
                        U_CRIAP07(TR1->PRODUTO,'97',.T.)
                        MVD1->(MsUnlock())
                        TR1->(DBCLOSEAREA())
                        loop
                    EndIf
                EndIf

                //Item com Entrada maior que o saldo de empenho e saldo de empenho igual a ZERO
                If (TR1->PAG_OP>TR1->EMP_OP .and. nSaldoLote>0 ) .and. nLoop<6
                    If (TR1->EMP_OP = 0)
                        //REQUISITA
                        UDORSD5(TR1->PRODUTO,'97',(nSaldoLote),SUBSTR(TR1->OP,1,8))
                        U_CRIAP07(TR1->PRODUTO,'97',.T.)
                        MVD1->(MsUnlock())
                        TR1->(DBCLOSEAREA())
                        loop
                    EndIf
                EndIf


                //	Item com Entrada igual ao saldo do empenho, mas sem saldo do lote
                If (TR1->PAG_OP==0 .AND. TR1->EMP_OP==0  .and. nSaldoLote>0 ) .and. nLoop<6
                    //REQUISITA
                    UDORSD5(TR1->PRODUTO,'97',( nSaldoLote ),SUBSTR(TR1->OP,1,8))
                    U_CRIAP07(TR1->PRODUTO,'97',.T.)
                    MVD1->(MsUnlock())
                    TR1->(DBCLOSEAREA())
                    loop
                EndIf

                // Item com empenho e saldo lote maior que zero, com pagamento já realizado, e empenho diferente do saldo
                If  TR1->EMP_OP>0 .and. nSaldoLote>0  .and. TR1->PAG_OP<>0 .and.  TR1->EMP_OP<>nSaldoLote .and. nLoop<6
                    If TR1->EMP_OP>nSaldoLote
                        //DEVOLVE
                        UCORSD5(TR1->PRODUTO,'97',( TR1->EMP_OP-nSaldoLote ),SUBSTR(TR1->OP,1,8))
                        U_CRIAP07(TR1->PRODUTO,'97',.T.)
                        MVD1->(MsUnlock())
                        TR1->(DBCLOSEAREA())
                        loop
                    ElseIf nSaldoLote>TR1->EMP_OP  .and. nLoop<6
                        //REQUISITA
                        UDORSD5(TR1->PRODUTO,'97',( nSaldoLote-TR1->EMP_OP ),SUBSTR(TR1->OP,1,8))
                        U_CRIAP07(TR1->PRODUTO,'97',.T.)
                        MVD1->(MsUnlock())
                        TR1->(DBCLOSEAREA())
                        loop
                    EndIf
                EndIf

                // Item com empenho e saldo lote maior que zero, com pagamento IGUAL A ZERO, e empenho diferente do saldo
                If  TR1->EMP_OP>0 .and. nSaldoLote>0  .and. TR1->PAG_OP>0 .and.  TR1->EMP_OP<>nSaldoLote .and. nLoop<6
                    If TR1->EMP_OP>nSaldoLote
                        //DEVOLVE
                        UCORSD5(TR1->PRODUTO,'97',( TR1->EMP_OP-nSaldoLote ),SUBSTR(TR1->OP,1,8))
                        U_CRIAP07(TR1->PRODUTO,'97',.T.)
                        MVD1->(MsUnlock())
                        TR1->(DBCLOSEAREA())
                        loop
                    ElseIf nSaldoLote>TR1->EMP_OP  .and. nLoop<6
                        //REQUISITA
                        UDORSD5(TR1->PRODUTO,'97',( nSaldoLote-TR1->EMP_OP ),SUBSTR(TR1->OP,1,8))
                        U_CRIAP07(TR1->PRODUTO,'97',.T.)
                        MVD1->(MsUnlock())
                        TR1->(DBCLOSEAREA())
                        loop
                    EndIf
                EndIf

                //Sem saldo de lote, com empenho e pagamento, pagamento igual a consumo + empenho
                If nSaldoLote=0 .and. TR1->EMP_OP>0 .and. (TR1->PAG_OP-TR1->DEV_OP)==(TR1->EMP_OP+TR1->CONSUMO)
                    //DEVOLVE
                    UCORSD5(TR1->PRODUTO,'97',( TR1->EMP_OP ),SUBSTR(TR1->OP,1,8))
                    U_CRIAP07(TR1->PRODUTO,'97',.T.)
                    MVD1->(MsUnlock())
                    TR1->(DBCLOSEAREA())
                    loop
                EndIf

            EndIf

        EndIF


        TIPO       := 'MOV'
        PRODUTO    := TR1->PRODUTO
        OP         := TR1->OP
        EMP_OP     := TR1->EMP_OP
        PAG_OP     := TR1->PAG_OP
        ENT_PROD   := TR1->ENT_PROD
        DEV_OP     := TR1->DEV_OP
        CONSUMO    := TR1->CONSUMO
        CONSUMO_DF := TR1->CONSUMO_DIF
        PER_DOMEX  := TR1->PER_DOMEX
        PER_FORNEC := TR1->PER_FORNEC
        SLD_LOTE   := nSaldoLote
        DIF_LOTE   := (TR1->PAG_OP-TR1->DEV_OP-TR1->CONSUMO)- nSaldoLote
        //DIFERENCA:= (TR1->PAG_OP)+(TR1->ENT_PROD)-(TR1->DEV_OP)-(TR1->CONSUMO)
        DIFERENCA  := TR1->EMP_OP - nSaldoLote

        nSaldoLTot := nSaldoLTot + nSaldoLote


        MVD1->(MsUnlock())

        //Deseja parar no primeiro ERRO
        //	If lFirst
        //		If ApMsgYesNo("Foi encontrada divergência em um dos movimentos, imprime a posição atual ou continua.","Deseja Continuar?")
        //	  		lFirst := .f.
        //	Else
        //			TMP->(DBSKIP())
        //			TR1->(DBCLOSEAREA())
        //	  		Exit
        //		EndIf
//		EndIf

        //EndIf


        TMP->(DBSKIP())
        TR1->(DBCLOSEAREA())

    Enddo
    TMP->(DBCLOSEAREA())

    dbSelectArea("MVD1")
    RecLock('MVD1',.T.)

    TIPO       := 'TOTAL'
    SLD_LOTE   := nSaldoLTot

    MVD1->(MsUnlock())

    nSaldoLTot := nSaldoLTot

/*
DBSELECTAREA("TM2")
DBGOTOP()
PROCREGUA(TM2->(RECCOUNT()))
    DO WHILE !TM2->(EOF())
	
	_cCOD := TM2->COD
	_cOP  := TM2->OP
	
	INCPROC('EMP '+ALLTRIM(_cCOD)+' '+ALLTRIM(_cOP))
	
	cQuery1 :=" exec SLDDOMEX '"+_cOP+"','"+_cCOD+"'  "
	TCQUERY cQuery1 Alias "TR1" New
	DBSELECTAREA("TR1")
	
        IF !EMPTY(TR1->PRODUTO)
		dbSelectArea("MVD1")
		RecLock('MVD1',.T.)

		
            If (((TR1->PAG_OP+TR1->ENT_PROD)-TR1->CONSUMO)-TR1->SLD_LOTE) == 0
                If ((TR1->PAG_OP)+(TR1->ENT_PROD)-(TR1->DEV_OP)-(TR1->CONSUMO)) == 0
				MVD1->(MsUnlock())
				TMP->(DBSKIP())
				TR1->(DBCLOSEAREA())					
                EndIf
            EndIf
		
		
		TIPO       := 'EMP'
		PRODUTO    := TR1->PRODUTO
		OP         := TR1->OP
		EMP_OP     := TR1->EMP_OP
		PAG_OP     := TR1->PAG_OP
		ENT_PROD   := TR1->ENT_PROD
		DEV_OP     := TR1->DEV_OP
		CONSUMO    := TR1->CONSUMO
		CONSUMO_DF := TR1->CONSUMO_DIF
		PER_DOMEX  := TR1->PER_DOMEX
		PER_FORNEC := TR1->PER_FORNEC
		SLD_LOTE   := TR1->SLD_LOTE
		DIF_LOTE   := ((TR1->PAG_OP+TR1->ENT_PROD)-TR1->CONSUMO)-TR1->SLD_LOTE
		DIFERENCA  := (TR1->PAG_OP)+(TR1->ENT_PROD)-(TR1->DEV_OP)-(TR1->CONSUMO)  
		
		
            IF DIF_LOTE<0
			U_CRIAP07(TR1->PRODUTO,'97',.T.)
            EndIF
		
		MVD1->(MsUnlock())
        ENDIF
	TM2->(DBSKIP())
	TR1->(DBCLOSEAREA())
    ENDDO
TM2->(DBCLOSEAREA())
  */

    dbSelectArea("MVD1")
    DBGOTOP()

    U_RELSLD97()

    copy to MVD_TEMP.DTC  // Gera o dbf no server a partir da query.
    MSGALERT("FIM")

RETURN

    *----------------------------------------------------------------------------*
USER Function RELSLD97()
    *----------------------------------------------------------------------------*

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    Local   cDesc1      := "Este programa tem como objetivo imprimir relatorio "
    Local   cDesc2      := "Movimentacao Armazem 97 "
    Local   cDesc3      := ""
    Local   cPict       := ""
    Local   titulo      := "Movimentacao Armazem 97 "
    Local   nLin        := 08


    Local   Cabec1      := "TP  Produto         OP                  EMP_OP       PAG_OP   ENT_PROD     DEV_OP    CONSUMO CONSUMO_DF  PER_DOMEX PER_FORNEC   SLD_LOTE   DIF_LOTE  DIFERENCA"
//                      EMP 10118SM20125PR  81960 02              4,00         4,00       0,00       0,00       0,00       0,00       0,00       0,00       0,00       4,00       4,00
/*
TP  Produto         OP                  EMP_OP       PAG_OP   ENT_PROD     DEV_OP    CONSUMO CONSUMO_DF  PER_DOMEX PER_FORNEC   SLD_LOTE   DIF_LOTE  DIFERENCA
****************************************************************************************************************************************************************************************************************************

EMP 10118SM20125PR  81960 02              4,00         4,00       0,00       0,00       0,00       0,00       0,00       0,00       0,00       4,00       4,00
EMP 10130SM20125PR  82110 02            200,00       200,00       0,00       0,00       0,00       0,00       2,00       0,00       0,00     200,00     200,00
EMP 10130SM20125PR  82095 08            200,00       200,00       0,00       0,00       0,00       0,00       0,00       0,00       0,00     200,00     200,00
*/

    Local   Cabec2      := ""
    Local   imprime     := .T.
    Local   aOrd        := {}
    Private lEnd        := .F.
    Private lAbortPrint := .F.
    Private CbTxt       := ""
    Private limite      := 220
    Private tamanho     := "G"
    Private nomeprog    := "RELSLD97"
    Private nTipo       := 18
    Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
    Private nLastKey    := 0
    Private cPerg       := ""
    Private cbtxt       := Space(10)
    Private cbcont      := 00
    Private CONTFL      := 01
    Private m_pag       := 01
    Private wnrel       := "RELSLD97"
    Private cString     := "SB1"
    Private Cgruporet   :=''
    Private cGrupo      :=''
    Private nCont       :=1
    Private NX          :=0
    Private NI          :=0


    pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.T.)

    If nLastKey == 27
        Return
    Endif

    SetDefault(aReturn,cString)

    If nLastKey == 27
        Return
    Endif

    nTipo := If(aReturn[4]==1,15,18)

    RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

    dbSelectArea("MVD1")
    DBGOTOP()


    Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)

    SetRegua(MVD1->(RecCount()))


    DO While MVD1->(!EOF())
        IF (MVD1->SLD_LOTE)>0 .OR.  (MVD1->DIFERENCA)>0
            @ nLin,000      pSay MVD1->TIPO
            @ nLin,PCOL()+1 pSay MVD1->PRODUTO
            @ nLin,PCOL()+1 pSay MVD1->OP
            @ nLin,PCOL()+1 pSay Transform(MVD1->EMP_OP    ,"@E 999,999.99")
            @ nLin,PCOL()+3 pSay Transform(MVD1->PAG_OP    ,"@E 999,999.99")
            @ nLin,PCOL()+1 pSay Transform(MVD1->ENT_PROD  ,"@E 999,999.99")
            @ nLin,PCOL()+1 pSay Transform(MVD1->DEV_OP    ,"@E 999,999.99")
            @ nLin,PCOL()+1 pSay Transform(MVD1->CONSUMO   ,"@E 999,999.99")
            @ nLin,PCOL()+1 pSay Transform(MVD1->CONSUMO_DF,"@E 999,999.99")
            @ nLin,PCOL()+1 pSay Transform(MVD1->PER_DOMEX ,"@E 999,999.99")
            @ nLin,PCOL()+1 pSay Transform(MVD1->PER_FORNEC,"@E 999,999.99")
            @ nLin,PCOL()+1 pSay Transform(MVD1->SLD_LOTE  ,"@E 999,999.99")
            @ nLin,PCOL()+1 pSay Transform(MVD1->DIF_LOTE  ,"@E 999,999.99")
            @ nLin,PCOL()+1 pSay Transform(MVD1->DIFERENCA ,"@E 999,999.99")
            nLin++

            IF NLIN >= 55
                Roda(0,"","G")
                Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
                nLin := 008
            ENDIF

        ENDIF
        MVD1->(DBSKIP())
        IncRegua(MVD1->PRODUTO)
    ENDDO
    MVD1->(DBCLOSEAREA())


    Roda(0,"","G")

    SET DEVICE TO SCREEN

    If aReturn[5]==1
        dbCommitAll()
        SET PRINTER TO
        OurSpool(wnrel)
    Endif

    MS_FLUSH()

Return

//Corrige Lote armazem 97
User Function CORLOTE()
    Local cQuery := ''
    Local dUlmes := GETMV("MV_ULMES",.F.,)
    Local aLoteSaldos := {}
    Local aProd		  := {}
    Local aLote       := {}

//cQuery1 := " SELECT TOP 1000 D3_COD, D3_LOCAL FROM "+RETSQLTAB('SD3')+ " (NOLOCK), " + RETSQLTAB('SB1') + " (NOLOCK) "
    cQuery1 := " SELECT D3_COD, D3_LOCAL FROM "+RETSQLTAB('SD3')+ " (NOLOCK), " + RETSQLTAB('SB1') + " (NOLOCK) "
    cQuery1 += " WHERE D3_FILIAL = '01' "
    cQuery1 += " AND D3_OP <> '' "
    cQuery1 += " AND D3_EMISSAO >'"+DTOS(dUlmes)+"' "
    cQuery1 += " AND D3_COD = B1_COD AND B1_RASTRO = 'L' "
    cQuery1 += " AND D3_OBSERVA = ''  "
    cQuery1 += " AND D3_LOTECTL <> SUBSTRING(D3_OP,1,8) "
    cQuery1 += " AND D3_TM IN ('499','999') "
    cQuery1 += " AND D3_LOCAL = '97' "
    cQuery1 += " AND SD3.D_E_L_E_T_='' AND SB1.D_E_L_E_T_ = '' "
    cQuery1 += " GROUP BY D3_COD, D3_LOCAL ORDER BY D3_COD, D3_LOCAL "

    If Select("TMP1") <> 0
        TMP1->( dbCloseArea() )
    EndIf

    TCQUERY cQuery1 Alias "TMP1" New

    Do While !TMP1->(EOF())

        cQuery2 := " SELECT D3_COD, D3_LOTECTL, SD3.R_E_C_N_O_ AS D3RECNO , D3_NUMSEQ, D3_LOCAL, D3_OP FROM "+RETSQLTAB('SD3')+" (NOLOCK), " + RETSQLTAB('SB1') + " (NOLOCK) "
        cQuery2 += " WHERE D3_FILIAL = '01' "
        cQuery2 += " AND D3_COD = '"+TMP1->D3_COD+"' AND D3_LOCAL = '"+TMP1->D3_LOCAL+"' "
        cQuery2 += " AND D3_EMISSAO >'"+DTOS(dUlmes)+"' "
        cQuery2 += " AND D3_COD = B1_COD AND B1_RASTRO = 'L' "
        cQuery2 += " AND D3_OBSERVA = ''  "
        cQuery2 += " AND D3_LOTECTL <> SUBSTRING(D3_OP,1,8) "
        cQuery2 += " AND D3_TM IN ('499','999') "
        cQuery2 += " AND D3_LOCAL = '97' "
        cQuery2 += " AND D3_OP <> '' "
        cQuery2 += " AND SD3.D_E_L_E_T_ = '' AND SB1.D_E_L_E_T_ = '' "

        If Select("TMP2") <> 0
            TMP2->( dbCloseArea() )
        EndIf

        TCQUERY cQuery2 Alias "TMP2" New

        //Corrige Lote
        lRotaSaldoAtu := .F.
        While !TMP2->( EOF() )
            If UALTLOTE(TMP2->D3_COD,SUBSTR(TMP2->D3_OP,1,8), TMP2->D3RECNO, TMP2->D3_NUMSEQ, TMP2->D3_LOCAL )
                //Roda saldo atual
                lRotaSaldoAtu := .T.
                AADD(aProd		,TMP1->D3_COD										  )
                AADD(aLote		,TMP2->D3_LOTECTL									  )
                AADD(aLoteSaldos,CalcEstL(TMP1->D3_COD,'97', dData2+1, TMP2->D3_LOTECTL))
            EndIf
            TMP2->( dbSkip() )
        End

        IF lRotaSaldoAtu

            //	For nx:= 1 to Len(aLoteSaldos)
            //	   	If aLoteSaldos[nx,1]<0
            //			UCORSD5(aProd[nx],'97',aLoteSaldos[nx,1] * (-1),aLote[nx])
            //		Endif
            //		U_CRIAP07(aProd[nx],'97',.T.)
            //	Next nx


            //	U_UMATA300(TMP1->D3_COD,TMP1->D3_COD,TMP1->D3_LOCAL,TMP1->D3_LOCAL)
            //cQuery3 := "SELECT B8_LOTECTL, B8_SALDO FROM SB8010 WHERE B8_FILIAL = '01' AND B8_PRODUTO = '"+TMP1->D3_COD+"' AND B8_LOCAL = '"+TMP1->D3_LOCAL+"' AND B8_SALDO < 0 AND D_E_L_E_T_ = '' "
            //If Select("QSB8") <> 0
            //	QSB8->( dbCloseArea() )
            //EndIf
            //TCQUERY cQuery3 NEW ALIAS "QSB8"

            //If !QSB8->( EOF() )
            //	While !QSB8->( EOF() )
            //		UCORSD5(TMP1->D3_COD,TMP1->D3_LOCAL,QSB8->B8_SALDO * (-1),QSB8->B8_LOTECTL)
            //		QSB8->( dbSkip() )
            //	End
            //	U_UMATA300(TMP1->D3_COD,TMP1->D3_COD,TMP1->D3_LOCAL,TMP1->D3_LOCAL)
            //EndIf
        EndIf

        TMP1->(DBSkip())

    Enddo

Return

Static Function UALTLOTE(cProduto, cLote, nD3Rec, cNumSeq, cLocal)
    local lOK 	  := .f.
    local nD5Rec  :=  0
    Local lReturn := .F.

//Verifica se o produto é valido
    SD5->( Dbsetorder(3) )
//Verifica se tem D5
    If SD5->(dbSeek( xFilial() + cNumSeq + cProduto + cLocal ))

        //Corrigi D3
        SD3->(DbGoTo(nD3Rec))
        If SD3->D3_LOTECTL <> cLote
            Reclock('SD3', .F.)
            SD3->D3_LOTECTL := cLote
            SD3->( MsUnlock() )
        Endif

        //Corrigi D5
        If SD5->D5_LOTECTL <> cLote
            Reclock('SD5', .F.)
            SD5->D5_LOTECTL := cLote
            SD5->( MsUnlock() )
            lReturn := .T.
        EndIf

    EndIf

Return lReturn

//RECLOCK Devolução de lote do material                        
Static Function UCORSD5(cProduto, cLocal, nSaldo, cLote)
    Local dUlmes := GETMV("MV_ULMES",.F.,)

    Reclock("SD5",.T.)
    SD5->D5_FILIAL  := xFilial("SD5")
    SD5->D5_NUMSEQ  := ProxNum()
    SD5->D5_PRODUTO := cProduto
    SD5->D5_LOCAL   := cLocal
    SD5->D5_DOC     := '00002'
    SD5->D5_DATA    := dUlmes + 1
    SD5->D5_ORIGLAN := '499'
    SD5->D5_QUANT   := nSaldo
    SD5->D5_LOTECTL := cLote
    SD5->D5_DTVALID := StoD("20491231")
    SD5->( msUnlock() )

Return .t.

//RECLOCK Retirada de lote do material
Static Function UDORSD5(cProduto, cLocal, nSaldo, cLote)
    Local dUlmes := GETMV("MV_ULMES",.F.,)

    Reclock("SD5",.T.)
    SD5->D5_FILIAL  := xFilial("SD5")
    SD5->D5_NUMSEQ  := ProxNum()
    SD5->D5_PRODUTO := cProduto
    SD5->D5_LOCAL   := cLocal
    SD5->D5_DOC     := '00004'
    SD5->D5_DATA    := dUlmes + 1
    SD5->D5_ORIGLAN := '999'
    SD5->D5_QUANT   := nSaldo
    SD5->D5_LOTECTL := cLote
    SD5->D5_DTVALID := StoD("20491231")
    SD5->( msUnlock() )

Return .t.


Static Function TMATA241(cCodProd, cLocal, nQTD, dDT )

    Local _aCab1    := {}
    Local _aItem    := {}
    Local _atotitem := {}
    Local nTipo     := 0
    Local cReturn   := ""


    Local cCodigoTM := SPACE(3)

    Private lMsHelpAuto := .t. // se .t. direciona as mensagens de help
    Private lMsErroAuto := .f. //necessario a criacao

//Private _acod:={"1","MP1"}     


    nQTD		:= (nQTD)
    cCodigoTM   := "002"


    dbSelectArea("SB1")
    dbSetOrder(1)
    SB1->(dbSeek(xFilial("SB1")+cCodProd))

    dbSelectArea("SD3")
    dbSetOrder(1)
    nTipo := 3
    _aCab1 := { {"D3_TM" ,cCodigoTM      , NIL},;
        {"D3_EMISSAO" ,dDT       , NIL}}

    _aItem := { ;
        {"D3_COD"     ,cCodProd   ,NIL},;
        {"D3_UM"      ,SB1->B1_UM ,NIL},;
        {"D3_QUANT"   ,(nQTD)     ,NIL},;
        {"D3_LOCAL"   ,'97'      ,NIL}}



    aadd(_atotitem,_aitem)
    MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab1,_atotitem,nTipo)


    If lMsErroAuto
        MOSTRAERRO()
    EndIf

Return