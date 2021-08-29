#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "REPORT.CH"


User Function DOMSLOTE()

    Local oReport  := ReportDef()
    PRIVATE cQUERY1:=""

    If oReport == Nil
        MsgInfo("*** CANCELADO PELO OPERADOR. ***")
    Else
        oReport:PrintDialog()
        Return Nil
    Endif

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Descri‡…o ³ Definicao dos Parametros do Relatorio                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³  			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef()
    Local oReport	:= NIL
    Local oSection1	:= NIL
    Local cAliasRep := GetNextAlias()

    Local cAviso	:= "Este programa ira imprimir Relatório Saldo de Estoque por Lote (PA)"
    Local cPar      := ""
    Local cPerg   	:= "DOMSLOTE2"

    AjustaSX1(cPerg)
//Pergunte(cPerg,.T.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    oReport := TReport():New(cPerg,"Saldo de Estoque por Lote (PA)", cPerg, {|oReport| ReportPrint(oReport,@cAliasRep,cPar)}, cAviso)
//oReport:nFontBody := 9
//oReport:SetPortrait
    oReport:SetLandscape()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ



    Pergunte(oReport:uParam,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Sessao 1 (oSection1)                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    oSection1 := TRSection():New(oReport,"Saldo de Estoque por Lote (PA)", {cAliasRep})
    oSection1:SetTotalInLine(.F.)


//TRCell():New(oSection1	,'PEDIDO'			,cAliasRep	,'Pedido'		 	,/*Picture*/	,06,/*lPixel*/,/*{|| code-block de impressao }*/)	//01
//B2_COD B1_DESC B2_LOCAL B2_QATU B8_LOTECTL B8_SALDO XX_OP XX_EMISSAO

    TRCell():New(oSection1, "COD"     , cAliasRep, "Cód.Produto" ,PesqPict("SB2","B2_COD")    , 15,/*lPixel*/,/*{|| code-block de impressao }*/)  //01
    TRCell():New(oSection1, "DESCR"   , cAliasRep, "Descricao"	 ,PesqPict("SB1","B1_DESC")   , 45,/*lPixel*/,/*{|| code-block de impressao }*/)  //02
    TRCell():New(oSection1, "GRUPO"   , cAliasRep, "Grupo"	     ,PesqPict("SB1","B1_GRUPO")  , 10,/*lPixel*/,/*{|| code-block de impressao }*/)  //02
    TRCell():New(oSection1, "ALMOX"   , cAliasRep, "Local"		 ,PesqPict("SB2","B2_LOCAL")  , 02,/*lPixel*/,/*{|| code-block de impressao }*/)  //03
    TRCell():New(oSection1, "UM"      , cAliasRep, "UM"	    	 ,PesqPict("SB1","B1_UM"  )   , 02,/*lPixel*/,/*{|| code-block de impressao }*/)  //03
    TRCell():New(oSection1, "QATU"    , cAliasRep, "Qtd Total"	 ,                            , 18,/*lPixel*/,/*{|| code-block de impressao }*/)  //04
    TRCell():New(oSection1, "VALOR"   , cAliasRep, "Vlr Total"	 ,                            , 18 ,/*lPixel*/,/*{|| code-block de impressao }*/)  //04
    TRCell():New(oSection1, "LOTECTL" , cAliasRep, "Lote"	     ,PesqPict("SB8","B8_LOTECTL"), 15,/*lPixel*/,/*{|| code-block de impressao }*/)  //05
    TRCell():New(oSection1, "SALDO"   , cAliasRep, "Qtd Lote"    ,PesqPict("SB8","B8_SALDO"  ), 08,/*lPixel*/,/*{|| code-block de impressao }*/)  //06
    TRCell():New(oSection1, "VLLOTE"  , cAliasRep, "Vlr Lote"	 ,                            , 18,/*lPixel*/,/*{|| code-block de impressao }*/)  //04
    TRCell():New(oSection1, "OP"	  , cAliasRep, "O.Producao"  ,PesqPict("SD3","D3_OP")     , 11,/*lPixel*/,/*{|| code-block de impressao }*/)  //07
    TRCell():New(oSection1, "EMISSAO" , cAliasRep, "Emissao"	 ,PesqPict("SD3","D3_EMISSAO"), 11,/*lPixel*/,/*{|| code-block de impressao }*/)  //08
    TRCell():New(oSection1, "PRVFAT"  , cAliasRep, "Prv Fat"	 ,PesqPict("SZY","ZY_PRVFAT") , 11,/*lPixel*/,/*{|| code-block de impressao }*/)  //08
    TRCell():New(oSection1, "PV"      , cAliasRep, "PV"	         ,PesqPict("SC6","C6_NUM")    , 10,/*lPixel*/,/*{|| code-block de impressao }*/)  //08
    TRCell():New(oSection1, "CLIENTE" , cAliasRep, "Cliente"     ,"@R"                        , 45,/*lPixel*/,/*{|| code-block de impressao }*/)  //08

    oSection1:SetHeaderPage()

    oSection1:SetHeaderSection(.T.) //Define que imprime cabeçalho das células na quebra de seção
    oSection1:SetHeaderBreak(.T.)

    //oBreak := TRBreak():New(oSection1, {|| (cAliasRep)->COD })
    oReport:SkipLine()
    oReport:ThinLine()

Return oReport
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint ³ Autor ³Marcos V. Ferreira   ³ Data ³08/06/06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportPrint devera ser criada para todos  ³±±
±±³          ³os relatorios que poderao ser agendados pelo usuario.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatorio                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR850			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint(oReport, cAliasRep,cPar)

    Local oSection1	:= oReport:Section(1)
    Local _cALMOX

    //Local oBreak1	:= NIL
    //Local nOrdem	:= oSection1:GetOrder()
    //Local cQry    	:= ""
    //Local oFont1    := TFont():New("Courier New",,020,,.F.,,,,,.F.,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Acerta o titulo do relatorio                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    oReport:SetTitle(oReport:Title())


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Transforma parametros Range em expressao SQL                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    MakeSqlExpr(oReport:uParam)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio do Embedded SQL                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//------------------------------------------------------
    BeginSql Alias cAliasRep
SELECT B2_COD AS COD,
B1_DESC       AS DESCR,
B2_LOCAL      AS ALMOX,
(SELECT SUM(B8_SALDO) FROM %table:SB8% WHERE B8_PRODUTO = B2_COD AND B8_LOCAL = B2_LOCAL AND B8_SALDO > 0 AND D_E_L_E_T_ = '') AS QATU,
B8_LOTECTL    AS LOTECTL,
B8_SALDO      AS SALDO,
B1_GRUPO      AS GRUPO,
B1_UM         AS UM,
B2_VATU1      AS VALOR,
B8_SALDO*(B2_VATU1/B2_QATU) AS VLLOTE,
(SELECT TOP 1 D3_OP 
FROM %table:SD3% SD3 (NOLOCK)
WHERE D3_OP =(SUBSTRING(B8_LOTECTL,1,8)+'001')   AND D_E_L_E_T_='' AND D3_ESTORNO='' 
AND D3_EMISSAO>=%Exp:MV_PAR03% AND D3_EMISSAO<=%Exp:MV_PAR04%
ORDER BY D3_EMISSAO DESC  ) AS OP,
CONVERT(CHAR,CONVERT(DATE,
(SELECT TOP 1 D3_EMISSAO 
FROM SD3010 (NOLOCK)
WHERE D3_OP =(SUBSTRING(B8_LOTECTL,1,8)+'001') AND D_E_L_E_T_='' AND D3_ESTORNO='' 
AND D3_EMISSAO>=%Exp:MV_PAR03% AND D3_EMISSAO<=%Exp:MV_PAR04%
ORDER BY D3_EMISSAO DESC),103)) AS EMISSAO
FROM %table:SB2% SB2 (NOLOCK),%table:SB1% SB1(NOLOCK),%table:SB8% SB8 (NOLOCK)
WHERE B8_PRODUTO=B2_COD
AND B8_LOCAL=B2_LOCAL
AND SB8.D_E_L_E_T_=''
AND B8_SALDO > 0 
AND B1_COD=B2_COD  
AND B1_TIPO='PA'
AND B2_QATU<>0 
AND SB1.D_E_L_E_T_='' AND SB2.D_E_L_E_T_=''
AND B2_COD   >=%Exp:MV_PAR01% AND B2_COD   <=%Exp:MV_PAR02%
AND B2_LOCAL >=%Exp:MV_PAR05% AND B2_LOCAL <=%Exp:MV_PAR06%
ORDER BY B2_COD,B2_LOCAL,EMISSAO DESC
    EndSql

//--------------------------------------------------------------------


    oReport:Section(1):EndQuery()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abertura do arquivo de trabalho                              |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    oReport:StartPage()
    oReport:Skipline()
//oReport:Thinline()

    oSection1:Init()
    oSection1:SetTotalInLine(.F.)

//oReport:PrintText("###    S A L D O   E S T O Q U E  ( P A )    ###",,oSection1:Cell("COD"):ColPos())
//oReport:Skipline()
//oReport:Thinline()

    dbSelectArea(cAliasRep)
    dbGotop()
    oReport:SetMeter(RecCount())


    oSection1:SetLineCondition({|| .T.})
    _cCOD   :=SPACE(15)
    _cALMOX :=SPACE(02)
    lFIRST  := .T.
    nReg    := 0

    (cAliasRep)->( dbEval({||nReg++}) )
    oReport:SetMeter(nReg)

    (cAliasRep)->( dbGoTop() )

    While !oReport:Cancel() .And. (cAliasRep)->(!Eof())

        If oReport:Cancel()
            Exit
        EndIf

        _cEMISSAO :=''
        _cPV      :=''
        _cPRVFAT  :=''

        cQUERY1:=" SELECT C6_NUM,C6_ITEM,C6_LOTECTL,C6_BLQ,D_E_L_E_T_,C6_NOTA,C6_QTDVEN,C6_QTDENT,  "

        cQUERY1+=" (SELECT TOP 1 ISNULL(ZY_PRVFAT,'')  "
        cQUERY1+=" FROM SZY010 WITH(NOLOCK) "
        cQUERY1+=" WHERE ZY_PEDIDO=C6_NUM AND ZY_ITEM=C6_ITEM  AND D_E_L_E_T_='' AND ZY_FILIAL='01' AND ZY_NOTA='' "
        cQUERY1+=" ORDER BY ZY_PRVFAT )  AS ZY_PRVFAT"

        cQUERY1+=" FROM SC6010 WITH(NOLOCK) "
        cQUERY1+=" WHERE C6_LOTECTL =('"+(cAliasRep)->LOTECTL+" ') "
        cQUERY1+=" and C6_FILIAL='01' AND D_E_L_E_T_='' "

        //TCQUERY cQUERY1 NEW ALIAS "TR1"

        /*
        BeginSql Alias TR1
        SELECT C6_NUM,C6_ITEM,C6_LOTECTL,C6_BLQ,D_E_L_E_T_,C6_NOTA,C6_QTDVEN,C6_QTDENT,  
        (SELECT TOP 1 ISNULL(ZY_PRVFAT,'')  
        FROM %table:SZY% SZY WITH(NOLOCK) 
        WHERE ZY_PEDIDO=C6_NUM AND ZY_ITEM=C6_ITEM  AND D_E_L_E_T_='' AND ZY_FILIAL='01' AND ZY_NOTA='' 
        ORDER BY ZY_PRVFAT )  AS ZY_PRVFAT
        FROM %table:SC6% SC6 WITH(NOLOCK) 
        WHERE C6_LOTECTL =%Exp:(cAliasRep)->LOTECTL%
        and C6_FILIAL='01' AND D_E_L_E_T_='' 
        EndSql
        */

        IF !EMPTY((cAliasRep)->EMISSAO)
            dbUseArea(.T., "TOPCONN", TcGenQry(,,cQUERY1), "TR1", .T., .T.)
            //TR1->(dbSelectArea('TR1'))

            DO WHILE !TR1->(EOF())
                IF !EMPTY(_cPV)
                    _cPV :=_cPV+'/'
                ENDIF
                _cPV :=_cPV + TR1->C6_NUM+'-'+TR1->C6_ITEM
                IF ALLTRIM(TR1->C6_BLQ)=='R'
                    _cPV :=_cPV +'(R)'
                ENDIF
                _cPRVFAT:=TR1->ZY_PRVFAT
                TR1->(DbSkip())
            EndDo
            TR1->(DBCLOSEAREA())
            IF !EMPTY(_cPRVFAT)
                _cPRVFAT:=SUBSTRING(_cPRVFAT,7,2)+'/'+SUBSTRING(_cPRVFAT,5,2)+'/'+SUBSTRING(_cPRVFAT,1,4)
            ENDIF
        EndIf

        IF  (((cAliasRep)->COD)<>_cCOD) .OR. (((cAliasRep)->ALMOX)<>_cALMOX)
            _cEMISSAO:=SUBSTRING((cAliasRep)->EMISSAO,9,2)+'/'+SUBSTRING((cAliasRep)->EMISSAO,6,2)+'/'+SUBSTRING((cAliasRep)->EMISSAO,1,4)  //  2020-03-27
            IF !EMPTY((cAliasRep)->EMISSAO)
                oReport:ThinLine()        //linha de Separacao
                oReport:Skipline()
                oSection1:Cell("COD")	:SetValue((cAliasRep)->COD	 )
                oSection1:Cell("DESCR") :SetValue((cAliasRep)->DESCR )
                oSection1:Cell("GRUPO") :SetValue((cAliasRep)->GRUPO )
                oSection1:Cell("ALMOX") :SetValue((cAliasRep)->ALMOX )
                oSection1:Cell("UM")    :SetValue((cAliasRep)->UM    )
                oSection1:Cell("QATU")	:SetValue(transform((cAliasRep)->QATU, "@E 999,999,999.99"))
                oSection1:Cell("VALOR") :SetValue(transform((cAliasRep)->VALOR, "@E 999,999,999.99"))//:SetValue((cAliasRep)->VALOR )

                oSection1:Cell("LOTECTL") :SetValue((cAliasRep)->LOTECTL)
                oSection1:Cell("SALDO")	  :SetValue((cAliasRep)->SALDO	)
                oSection1:Cell("VLLOTE")  :SetValue(transform((cAliasRep)->VLLOTE, "@E 999,999,999.99"))
                oSection1:Cell("OP")	  :SetValue((cAliasRep)->OP	)
                oSection1:Cell("EMISSAO") :SetValue(_cEMISSAO)
                oSection1:Cell("PRVFAT")  :SetValue(_cPRVFAT)
                oSection1:Cell("PV")      :SetValue(_cPV)
                SC2->( dbSetOrder(1) )
                SC2->( dbSeek( xFilial() + (cAliasRep)->OP ) )
                If !Empty(SC2->C2_CLIENT)
                    oSection1:Cell("CLIENTE")  :SetValue(Posicione("SA1",1,xFilial("SA1")+SC2->C2_CLIENT,"A1_NREDUZ"))
                else
                    oSection1:Cell("CLIENTE")  :SetValue("")
                EndIf
                oSection1:PrintLine()
            ENDIF
            lFIRST  := .F.
            _cCOD   :=(cAliasRep)->COD
            _cALMOX :=(cAliasRep)->ALMOX

            //oReport:Skipline()

        ELSE
            IF !EMPTY((cAliasRep)->EMISSAO)
                _cEMISSAO:=SUBSTRING((cAliasRep)->EMISSAO,9,2)+'/'+SUBSTRING((cAliasRep)->EMISSAO,6,2)+'/'+SUBSTRING((cAliasRep)->EMISSAO,1,4)  //  2020-03-27
                oSection1:Cell("COD")	:SetValue(SPACE(15))
                oSection1:Cell("DESCR") :SetValue(SPACE(30))
                oSection1:Cell("GRUPO") :SetValue(SPACE(10))
                oSection1:Cell("ALMOX") :SetValue(SPACE(02))
                oSection1:Cell("UM")    :SetValue(SPACE(02))
                oSection1:Cell("QATU")	:SetValue(SPACE(02))
                oSection1:Cell("VALOR") :SetValue(SPACE(10))

                oSection1:Cell("LOTECTL") :SetValue((cAliasRep)->LOTECTL)
                oSection1:Cell("SALDO")	  :SetValue((cAliasRep)->SALDO	)
                oSection1:Cell("VLLOTE")  :SetValue(transform((cAliasRep)->VLLOTE, "@E 999,999,999.99"))
                oSection1:Cell("OP")	  :SetValue((cAliasRep)->OP	)
                oSection1:Cell("EMISSAO") :SetValue(_cEMISSAO)
                oSection1:Cell("PRVFAT")  :SetValue(_cPRVFAT)
                oSection1:Cell("PV")      :SetValue(_cPV)
                oSection1:PrintLine()
            ENDIF
            lFIRST  :=.T.
            _cCOD   :=(cAliasRep)->COD
            _cALMOX :=(cAliasRep)->ALMOX

            //oReport:Skipline()
        ENDIF
        //  oSection1:PrintLine()

        oReport:IncMeter()
        (cAliasRep)->(dbSkip()	)

    EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Impressao do Relatorio ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//oSection1:Print()
    oSection1:Finish()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Finalida o Relatorio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    oReport:EndPage()
Return Nil


/*/{Protheus.doc} AjustaSX1
@author Ricardo Roda
@since 12/09/2019
@version undefined
/*/
Static Function AjustaSX1(cPerg)

    DbSelectArea("SX1")
    DbSetOrder(1)
    aRegs :={}
    aAdd(aRegs, {cPerg, "01", "Produto De  ?",     "", "", "mv_ch1", "C",15, 0, 0, "G", "", "MV_PAR01", ""     , "" , "" , "" , "", "" , "", "", "", "", ""       , "", "", "", "", ""    , "", "", "", "", "", "", "", "", "SB1", "" , "", "","","",""})
    aAdd(aRegs, {cPerg, "02", "Produto Ate ?",     "", "", "mv_ch2", "C",15, 0, 0, "G", "", "MV_PAR02", ""     , "" , "" , "" , "", "" , "", "", "", "", ""       , "", "", "", "", ""    , "", "", "", "", "", "", "", "", "SB1", "" , "", "","","",""})

    aAdd(aRegs, {cPerg, "03", "Data De  ?",        "", "", "mv_ch3", "D",10, 0, 0, "G", "", "MV_PAR03", ""     , "" , "" , "" , "", "" , "", "", "", "", ""       , "", "", "", "", ""    , "", "", "", "", "", "", "", "", ""   , "" , "", "","","",""})
    aAdd(aRegs, {cPerg, "04", "Data Ate ?",        "", "", "mv_ch4", "D",10, 0, 0, "G", "", "MV_PAR04", ""     , "" , "" , "" , "", "" , "", "", "", "", ""       , "", "", "", "", ""    , "", "", "", "", "", "", "", "", ""   , "" , "", "","","",""})

    aAdd(aRegs, {cPerg, "05", "Armazem De  ?",     "", "", "mv_ch5", "C",02, 0, 0, "G", "", "MV_PAR05", ""     , "" , "" , "" , "", "" , "", "", "", "", ""       , "", "", "", "", ""    , "", "", "", "", "", "", "", "", "NNR", "" , "", "","","",""})
    aAdd(aRegs, {cPerg, "06", "Armazem Ate ?",     "", "", "mv_ch6", "C",02, 0, 0, "G", "", "MV_PAR06", ""     , "" , "" , "" , "", "" , "", "", "", "", ""       , "", "", "", "", ""    , "", "", "", "", "", "", "", "", "NNR", "" , "", "","","",""})


//aAdd(aRegs, {cPerg, "03", "Ordena/Quebra por", "", "", "mv_ch3", "N",03, 0, 0, "C", "", "MV_PAR11","Iguais", "" , "" , "" , "", "Diferente" , "", "", "", "", "Ambos" 		 , "", "", "", "", ""	 , "", "", "", "", "", "", "", "", ""   , "" , "", "","",""})
    fAjuSx1(cPerg,aRegs)

Return

/*/{Protheus.doc} fAjuSx1
@author Ricardo Roda
@since 12/09/2019
@version undefined
/*/
Static Function fAjuSx1(cPerg,aRegs)

    Local _nTamX1, _nTamPe, _nTamDf := 0

    DbSelectArea("SX1")
    DbSetOrder(1)

// Indo ao Primeiro Registro do SX1, apenas para descobrir o tamanho do campo com o nome da PERGUNTA
// Campo chamado X1_GRUPO
    DbGoTop()
    _nTamX1	:= Len(SX1->X1_GRUPO)
    _nTamPe	:= Len(Alltrim(cPerg))
    _nTamDf	:= _nTamX1 - _nTamPe

// Adequando o Tamanho para Efetuar a Pesquisa no SX1
    If _nTamDf > 0
        cPerg := cPerg + Space(_nTamDf)
    ElseIf _nTamDf == 0
        cPerg := cPerg
    Else
        Return()
    EndIf

// Criando Perguntas caso NAO existam no SX1
    For i:=1 to Len(aRegs)

        If !DbSeek(cPerg+aRegs[i,2])

            RecLock("SX1",.T.)
            For j:=1 to FCount()
                FieldPut(j,aRegs[i,j])
            Next
            MsUnlock()

            DbCommit()
        Endif
    Next

Return()