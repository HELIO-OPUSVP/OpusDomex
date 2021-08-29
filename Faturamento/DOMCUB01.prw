#include 'rwmake.ch'
#include 'protheus.ch'
#include 'parmtype.ch'  
#include 'topconn.ch'

/*    

*/

user function DOMCUB01(_C5NUM)

    Public cPedSel := ""

    //msgalert(_C5NUM)

    MsgRun("Selecionando Itens do Pedidos ... Aguarde...","Selecionando Itens do Pedidos",{|| xSelPV(_C5NUM)})

return


Static Function xSelPV(_C5NUM)
    Local cQueryM := ""
    Local _cArqtrb
    Local _cArqtrb2
    Local aPvlNfs := {}
    Local nX :=0
    Local nY :=0
    Private oMark
    Private oMark2

    Private aGRUPOE:={}
    Private aGRUPOE2:={}

    Private aHeadEMB  := {}
    Private aColsEmb  := {}

    Private aHeadPal  := {}
    Private aHeadCX   := {}
    Private aHeadPR   := {}

    Private aColsPal  := {}
    Private aColsCX   := {}
    Private aColsPR   := {}

    Private lSelPorItem :=.F.

    private oModal
    private cModal   :=  '1 - Aereo'
    private aModal   := {'1 - Aereo','2 - Maritmo','3 - Todos'}

    _aEstru := {}
    _aCpos := {}
    _aEstru2 := {}
    _aCpos2 := {}
    aPedidos := {}
    aCores := {}
    nQtdTot := 0
    nVlrTot := 0
    aLogSuc := {}
    cLogErro := ""


    IF SELECT("QRYCT") > 0
        QRYCT->(Dbclosearea())
    Endif

//AADD(_aEstru2,{"STATUS"    ,"C",1,0})
    AADD(_aEstru2,{"C6_OK"         ,"C",2,0})
    AADD(_aEstru2,{"C6_ITEM"       ,"C",2,0})
    AADD(_aEstru2,{"C6_PRODUTO"    ,"C",15,0})
    AADD(_aEstru2,{"B1_GRUPO"      ,"C",4,0})
    AADD(_aEstru2,{"C6_DESCRI"	   ,"C",30,0})
    AADD(_aEstru2,{"C6_UM"	       ,"C",2,0})
    AADD(_aEstru2,{"C6_QTDVEN"	   ,"N",15,3})

    AADD(_aEstru2,{"EMBAL"	   ,"C",15,0})
    AADD(_aEstru2,{"DIMEN"	   ,"C",40,3})
    AADD(_aEstru2,{"QTDEMB"    ,"N",15,4})
    AADD(_aEstru2,{"PESO_REA"  ,"N",15,4})
    //AADD(_aEstru2,{"CUB"	   ,"N",15,4})
    //AADD(_aEstru2,{"PESO_AER"  ,"N",15,4})
    //AADD(_aEstru2,{"PESO_ROD"  ,"N",15,4})
    //AADD(_aEstru2,{"PESO_MAR"  ,"N",15,4})

    AADD(_aCpos2,{"C6_OK"        ,,"Sel"     ,"@!"})
    AADD(_aCpos2,{"C6_ITEM"      ,,"Item" ,"@!"})
    AADD(_aCpos2,{"C6_PRODUTO"   ,,"Produto" ,"@!"})
    AADD(_aCpos2,{"B1_GRUPO"     ,,"Grupo" ,"@!"})
    AADD(_aCpos2,{"C6_DESCRI"    ,,"Descri"  ,"@!"})
    AADD(_aCpos2,{"C6_UM"        ,,"UM"      ,"@!"})
    AADD(_aCpos2,{"C6_QTDVEN"    ,,"Qtde"    ,"@E 999,999,999,999.999"})

    AADD(_aCpos2,{"EMBAL"      ,,"Embalagem"  ,"@!"})
    AADD(_aCpos2,{"DIMEN"      ,,"Dimensao"   ,"@!"})
    AADD(_aCpos2,{"QTDEMB"     ,,"Qtd_Emb"   ,"@E 999,999,999,999.999"})
    AADD(_aCpos2,{"PESO_REA"   ,,"P_Real"    ,"@E 999,999,999,999.999"})
    //AADD(_aCpos2,{"CUB"        ,,"Cubagem"    ,"@E 999,999,999,999.999"})
    //AADD(_aCpos2,{"PESO_AER"   ,,"P_Aereo"   ,"@E 999,999,999,999.999"})
    //AADD(_aCpos2,{"PESO_ROD"   ,,"P_Rodov"   ,"@E 999,999,999,999.999"})
    //AADD(_aCpos2,{"PESO_MAR"   ,,"P_Maritmo"   ,"@E 999,999,999,999.999"})


//aAdd(aCores,{"SELPED->STATUS == 'C'","BR_AZUL"	})
//aAdd(aCores,{"SELPED->STATUS == 'E'","BR_PRETO"	})
//aAdd(aCores,{"SELPED->STATUS == 'L'","BR_AMARELO"	})
//aAdd(aCores,{"SELPED->STATUS == 'N'","BR_VERDE"	})
//---------------------------------------- embalagem final
    AADD(aHeadEMB,   {    "Grupo"     ,   "E_GRUPO"   ,""                         ,04,0,""  ,"","C","","","","",".F."})//01
    AADD(aHeadEMB,   {    "Codigo"    ,   "E_COD"     ,""                         ,15,0,""  ,"","C","","","","",".F"}) //02
    AADD(aHeadEMB,   {    "Dimensao"  ,   "E_DIM"     ,""                         ,30,0,""  ,"","C","","","","",".F."})//03
    AADD(aHeadEMB,   {    "Qtd.Emb"   ,   "E_QTDE"    ,"@E 999,999,999,999.99"    ,12,5,""  ,"","N","","","","",".F."})//04
    //AADD(aHeadEMB,   {    "Cubagem"   ,   "E_CUB"   ,"@E 999,999,999,999.99"    ,12,5,""  ,"","N","","","","",".F."})//04
    AADD(aHeadEMB,   {    "Produto"   ,   "E_PROD"    ,""                         ,15,0,""  ,"","N","","","","",".F."})//05
    AADD(aHeadEMB,   {    "Qtd.Prod"  ,   "E_QTDp"    ,"@E 999,999,999,999.99"    ,12,5,""  ,"","N","","","","",".F."})//06
    AADD(aHeadEMB,   {    "Seq_emb"   ,   "E_SEQE"    ,""                         ,03,0,""  ,"","N","","","","",".F."})//06

    //AADD(aColsEMB,{'',;
        //    '',;
        //    '',;
        //    0,;
        //    0,;
        //    .F.})//.f. POSICAO 8Flag de Delecao]

//---------------------------------------- PALET-----------------------
    AADD(aHeadPal,   {    "Seq"       ,   "P_SEQ"    ,""                         ,03,0,""  ,"","C","","","","",".F"}) //01
    AADD(aHeadPal,   {    "Codigo"    ,   "P_COD"    ,""                         ,15,0,""  ,"","C","","","","",".F"}) //02
    AADD(aHeadPal,   {    "Dimensao"  ,   "P_DIM"    ,""                         ,30,0,""  ,"","C","","","","",".F."})//03
    AADD(aHeadPal,   {    "Base"      ,   "P_BASE"   ,"@E 999,999,999,999.99"    ,12,5,""  ,"","N","","","","",".F."})//04
    AADD(aHeadPal,   {    "Largura"   ,   "P_LAR"    ,"@E 999,999,999,999.99"    ,12,5,""  ,"","N","","","","",".F."})//05
    AADD(aHeadPal,   {    "Alt.Max"   ,   "P_ALT"    ,"@E 999,999,999,999.99"    ,12,5,""  ,"","N","","","","",".F."})//06
    AADD(aHeadPal,   {    "Alt.Var"   ,   "P_VAR"    ,""                         ,1,0 ,""  ,"","C","","","","",".F."})//07
    AADD(aHeadPal,   {    "Duplica"   ,   "P_DUP"    ,""                         ,1,0 ,""  ,"","C","","","","",".F."})//08
//---------------------------------------- CAIXAS-----------------------
    AADD(aHeadCX,   {    "Seq"         ,   "C_SEQ"    ,""                         ,12,0,""  ,"","C","","","","",".F"}) //01
    AADD(aHeadCX,   {    "Codigo"      ,   "C_COD"    ,""                         ,15,0,""  ,"","C","","","","",".F"}) //01
    AADD(aHeadCX,   {    "Dimensao"    ,   "C_DIM"    ,""                         ,30,0,""  ,"","C","","","","",".F."})//02
    AADD(aHeadCX,   {    "Altura"      ,   "C_ALT"    ,"@E 999,999,999,999.99"    ,12,5,""  ,"","N","","","","",".F."})//03
    AADD(aHeadCX,   {    "Largura"     ,   "C_LAR"    ,"@E 999,999,999,999.99"    ,12,5,""  ,"","N","","","","",".F."})//04
    AADD(aHeadCX,   {    "Comprimento" ,   "C_COM"    ,"@E 999,999,999,999.99"    ,12,5,""  ,"","N","","","","",".F."})//05
    AADD(aHeadCX,   {    "Girar"       ,   "C_GIR"    ,""                         ,1,0 ,""  ,"","N","","","","",".F."})//06
//---------------------------------------- Produto-----------------------
    AADD(aHeadPR,   {    "Seq"         ,   "R_SEQ"    ,""                         ,03,0,""  ,"","C","","","","",".F"}) //01
    AADD(aHeadPR,   {    "Codigo"      ,   "R_COD"    ,""                         ,15,0,""  ,"","C","","","","",".F"}) //01
    AADD(aHeadPR,   {    "Descricao"   ,   "R_DES"    ,""                         ,30,0,""  ,"","C","","","","",".F."})//02
    AADD(aHeadPR,   {    "Qtde"        ,   "R_QTD"    ,"@E 999,999,999,999.99"    ,12,5,""  ,"","N","","","","",".F."})//03
//---------------------------------------------------------------------------------------------------------------------    


    AADD(aColsPal,{'',;
        '',;
        '',;
        0,;
        0,;
        0,;
        '',;
        '',;
        .F.})//.f. POSICAO Flag de Delecao]

    AADD(aColsCx,{'',;
        '',;
        '',;
        0,;
        0,;
        0,;
        '',;
        .F.})//.f. POSICAO Flag de Delecao]

    AADD(aColsPR,{'',;
        '',;
        '',;
        0,;
        .F.})//.f. POSICAO Flag de Delecao]

//---------------------------------------------------------------------------------------------------------------------    
    _cCliente := posicione('SC5',1,xFILIAL('SC5')+_C5NUM,'C5_CLIENTE')
    _cLOJA    := posicione('SC5',1,xFILIAL('SC5')+_C5NUM,'C5_LOJACLI')

    SA1->(dbSeek(xFilial("SA1")+_cCliente+_cLOJA))

    lSelPorItem := If("HUAWEI" $ SA1->A1_NOME, .T., .F.)

    If !lSelPorItem
        If ("ALCATEL" $ SA1->A1_NOME)
            lSelPorItem := .T.
        EndIf
        //--------------------------------
        If ("NOKIA" $ SA1->A1_NOME)
            lSelPorItem := .T.
        EndIf
        //--------------------------------
        If GetMv("MV_XVERTEL")
            If ("TELEFONICA" $ SA1->A1_NREDUZ)
                lSelPorItem := .T.
            EndIf
            If ("ERICSSON" $ SA1->A1_NOME)
                lSelPorItem := .T.
            EndIf
        EndIf
        If GetMv("MV_XVEROI")
            If ("OI S" $ Upper(SA1->A1_NOME)) .Or. ("OI MO" $ Upper(SA1->A1_NOME)) .Or. ("TELEMAR" $ Upper(SA1->A1_NOME)) .Or. ("BRASIL TELECOM COMUNICACAO MUL" $ Upper(SA1->A1_NOME))
                lSelPorItem := .T.
            EndIf
        EndIf

        //Verifica se � clietne CLARO
        If GetMv("MV_XVERCLA")
            If ("CLARO" $ Upper(SA1->A1_NOME)) .Or. ("CLARO" $ Upper(SA1->A1_NREDUZ)) .Or. ("BRASIL TELECOM COMUNICACAO MUL" $ Upper(SA1->A1_NOME))
                lSelPorItem := .T.
            EndIf
        EndIf
    EndIf

    IF lSelPorItem==.T.
        cOBS := 'Sele��o por Item'
    ELSE
        cOBS := 'Sele��o por Pedido'
    ENDIF


    If SELECT("SELPED") > 0
        SELPED->(Dbclosearea())
    Endif

    _cArqtrb2 := CriaTrab(_aEstru2,.F.)

    dbCreate(_cArqtrb2,_aEstru2)
    dbUseArea(.T.,,_cArqtrb2,"SELPED",.F.,.F.)

    xSelCity(_C5NUM)

    lInverte := .F.
    cMark := getmark()
    lInverte2 := .F.
    cMark2 := getmark()

    lExec := .F.
    cTit := "Calculo  de Embalagem"
    DEFINE MSDIALOG oEdZ TITLE cTit FROM -017, 000  TO 530, 1295 COLORS 0, 16777215 PIXEL
    DEFINE FONT oFnt1       NAME "Arial"                    Size 10,12 BOLD

    @ 001,001 GROUP oGroupC TO 23, 207 PROMPT "Pedido de Venda" OF oEdZ COLOR 0, 16777215 PIXEL
///@ 010,005 TO 267,255 BROWSE "SELCITY" FIELDS _aCpos MARK "A1_OK"   
    _cCliente := posicione('SC5',1,xFILIAL('SC5')+_C5NUM,'C5_CLIENTE')               //C5_CLIENTE C5_LOJA
    _cLOJA    := posicione('SC5',1,xFILIAL('SC5')+_C5NUM,'C5_LOJACLI')                  //C5_CLIENTE C5_LOJA
    _CNOME    := posicione('SA1',1,xFILIAL('SA1')+_cCliente+_cLOJA,'A1_NREDUZ')      //C5_CLIENTE C5_LOJA
    _cPEDIDO  :=_C5NUM+'  '+_cCliente+'/'+_cLOJA+'-'+_CNOME
    @ 011.5,10 SAY oTexto1 PROMPT _cPEDIDO Font oFnt1 OF oEdZ COLOR 0, 16777215 PIXEL

//oMark := MsSelect():New("SELCITY","A1_OK","",_aCpos,@lInverte,@cMark,{10,5,267,205})
//oMark:bMark := {|| ProcCity() }
///oMark:oBrowse:lhasMark := .t.

//@ 026,210 GROUP oGroupP TO 270, 642 PROMPT "Selecione Itens" OF oEdZ COLOR 0, 16777215 PIXEL
//    @ 026,1 GROUP oGroupP TO 270, 642 PROMPT "Itens" OF oEdZ COLOR 0, 16777215 PIXEL
//    @ 026,1 GROUP oGroupP TO 270, 407 PROMPT "Itens" OF oEdZ COLOR 0, 16777215 PIXEL
    @ 026,1 GROUP oGroupP TO 197, 407 PROMPT "Itens" OF oEdZ COLOR 0, 16777215 PIXEL
///@ 010,005 TO 267,255 BROWSE "SELCITY" FIELDS _aCpos MARK "A1_OK"   

//oMark2 := MsSelect():New("SELPED","C6_OK","",_aCpos2,@lInverte2,@cMark2,{36,215,267,639},,,,,aCores)
//    oMark2 := MsSelect():New("SELPED","C6_OK","",_aCpos2,@lInverte2,@cMark2,{36,6,267,639},,,,,aCores)
    oMark2 := MsSelect():New("SELPED","C6_OK","",_aCpos2,@lInverte2,@cMark2,{36,6,187,402},,,,,aCores)
    oMark2:bMark := {|| ProcPed(_C5NUM) }

    @ 026,410 GROUP oGroupP TO 197, 642 PROMPT "Embalagem Final" OF oEdZ COLOR 0, 16777215 PIXEL
    oGetEmbFim   := (MsNewGetDados():New( 36,415,187,637 ,/*GD_UPDATE*/ ,/*"U_FAT002LOK()"*/  ,/*REQ_OPSD3()*/,/*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*Ffieldok*/,/*superdel*/,/*delok*/,oEdZ,aHEADEMB,aCOLSEMB))
    oGetEmbFim:oBrowse:Refresh()

    //@ 001,210 GROUP oGroupR TO 023,407 PROMPT "Total" OF oEdZ COLOR 0, 16777215 PIXEL
    @ 001,210 GROUP oGroupR TO 023,407 PROMPT "Obs" OF oEdZ COLOR 0, 16777215 PIXEL//cOBS
    @ 011.5,215 SAY oTexto1 PROMPT cOBS Font oFnt1  OF oEdZ COLOR 0, 16777215 PIXEL
    // @ nLin,aPosGet[1,1]+(aPosGet[1,1]*62) SAY OemToAnsi("Filtro")                                 OF oDlg PIXEL SIZE 040,010 FONT oFontBRW3
    @ 08.5,330 combobox oModal var cModal items aModal     OF oEdZ PIXEL SIZE 070,005 FONT oFnt1 // Valid MRPVAL1('F')

    // @ 011.5,215 SAY oTexto1 PROMPT "Cubagem: " Font oFnt1 OF oEdZ COLOR 0, 16777215 PIXEL
    // @ 011.5,275 SAY oTexto2 PROMPT Transform(nQtdTot,"@E 99999999") Font oFnt1 OF oEdZ COLOR 0, 16777215 PIXEL

    //  @ 011.5,320 SAY oTexto3 PROMPT "Peso: " Font oFnt1 OF oEdZ COLOR 0, 16777215 PIXEL
    //  @ 011.5,360 SAY oTexto4 PROMPT Transform(nVlrTot,"@E 9,999,999.99") Font oFnt1 OF oEdZ COLOR 0, 16777215 PIXEL

    //@ 001,410 GROUP oGroupA TO 023,642 PROMPT "Acoes" OF oEdZ COLOR 0, 16777215 PIXEL
    @ 001,410 GROUP oGroupA TO 023,642 PROMPT "Acoes"  OF oEdZ COLOR 0, 16777215 PIXEL

    @ 200,001 GROUP oGroupR1 TO 270,207 PROMPT "Palets"         OF oEdZ COLOR 0, 16777215 PIXEL
    @ 200,210 GROUP oGroupR2 TO 270,407 PROMPT "Caixa/Palet"    OF oEdZ COLOR 0, 16777215 PIXEL
    @ 200,410 GROUP oGroupR3 TO 270,642 PROMPT "Produtos/Caixa" OF oEdZ COLOR 0, 16777215 PIXEL

    oGetPalet   := (MsNewGetDados():New( 210,010,260,200 ,/*GD_UPDATE*/ ,/*"U_FAT002LOK()"*/  ,/*REQ_OPSD3()*/,/*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*Ffieldok*/,/*superdel*/,/*delok*/,oEdZ,aHeadPal,aCOLSPAL))
    oGetPalet:oBrowse:Refresh()

    oGetCaixa   := (MsNewGetDados():New( 210,220,260,400 ,/*GD_UPDATE*/ ,/*"U_FAT002LOK()"*/  ,/*REQ_OPSD3()*/,/*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*Ffieldok*/,/*superdel*/,/*delok*/,oEdZ,aHeadCX,aCOLSCX))
    oGetCaixa:oBrowse:Refresh()

    oGetProduto   := (MsNewGetDados():New( 210,420,260,635 ,/*GD_UPDATE*/ ,/*"U_FAT002LOK()"*/  ,/*REQ_OPSD3()*/,/*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*Ffieldok*/,/*superdel*/,/*delok*/,oEdZ,aHeadPR,aCOLSPR))
    oGetProduto:oBrowse:Refresh()



///@ 008,612 BMPBUTTON TYPE 01 ACTION (lExec := .T.,Close(oEdZ))

    @ 0.6,103 BUTTON "Embalagens" SIZE 50,11 Action (lExec := .F.,U_DCUBEE5())
    @ 0.6,116 BUTTON "Regras"     SIZE 50,11 Action (lExec := .F.,U_DCUBSZW())


    @ 008,560 BMPBUTTON TYPE 02 ACTION (lExec := .F.,Close(oEdZ))
    //@ 0.6,103.1 BUTTON "Imprime Pre Carga" SIZE 50,11 Action IMPRIMEC()  /// Mudar a chamada funï¿½ï¿½o...
    //@ 0.6,116.6 BUTTON "Sel Todos Pedidos" SIZE 50,11 Action INVERTEP()
    //@ 0.6,129.8 BUTTON "Libera PV" SIZE 37,11 Action LIBERAPV()
    //@ 0.6,147.5 BUTTON "Gerar Palets" SIZE 50,11 Action (lExec := .T.,Close(oEdZ))
    @ 0.6,147.5 BUTTON "Gerar Palets" SIZE 50,11 Action FGERPALT()

    ACTIVATE MSDIALOG oEdZ CENTERED


    cTexto1 := ""

Return

Static Function FGERPALT()

    aColsPal := {}
    aColsCx  := {}
    aColsPR  := {}
    cCODP    := ''

    aEmbFinal := {}
    aProdutos := {}
    aFPalets   := {}
    aEmbFinal := {}
    aPalets:= {}


    //AADD(aHeadEMB,   {    "Grupo"     ,   "E_GRUPO"   ,""                         ,04,0,""  ,"","C","","","","",".F."})//01
    //AADD(aHeadEMB,   {    "Codigo"    ,   "E_COD"     ,""                         ,15,0,""  ,"","C","","","","",".F"}) //02
    //AADD(aHeadEMB,   {    "Dimensao"  ,   "E_DIM"     ,""                         ,30,0,""  ,"","C","","","","",".F."})//03
    //AADD(aHeadEMB,   {    "Qtd.Emb"   ,   "E_QTDE"    ,"@E 999,999,999,999.99"    ,12,5,""  ,"","N","","","","",".F."})//04
    //AADD(aHeadEMB,   {    "Produto"   ,   "E_PROD"    ,""                         ,15,0,""  ,"","N","","","","",".F."})//05
    //AADD(aHeadEMB,   {    "Qtd.Prod"  ,   "E_QTDp"    ,"@E 999,999,999,999.99"    ,12,5,""  ,"","N","","","","",".F."})//06
    //AADD(aHeadEMB,   {    "Seq_emb"   ,   "E_SEQE"    ,""                         ,03,0,""  ,"","N","","","","",".F."})//06


    FOR nX := 1 TO  len(aCOLSEMB)
        IF  EE5->( dbSeek( xFilial() + aCOLSEMB[nX,2]) )
            AADD(aEmbFinal,{aCOLSEMB[nX][07],aCOLSEMB[nX][02],EE5->EE5_CCOM,EE5->EE5_LLARG, EE5->EE5_HALT,'N'})
        ELSE
            MSGALERT('Embalagem n�o cadastrada: '+aCOLSEMB[nX][07])
            AADD(aEmbFinal,{aCOLSEMB[nX][07],aCOLSEMB[nX][03],0,0, 0,'N'})
        ENDIF
    next nX

    nCOUNT :=0

    FOR nX:=1 TO LEN(aGRUPOE)
        nCOUNT :=nCOUNT++
        AADD(aProdutos,{STRZERO(nCOUNT,3),aGRUPOE[nX][3],aGRUPOE[nX][5]})
    NEXT

    FOR nX:=1 TO LEN(aGRUPOE2)
        nCOUNT :=nCOUNT++
        AADD(aProdutos,{STRZERO(nCOUNT,3),aGRUPOE2[nX][3],aGRUPOE2[nX][5]})
    NEXT

    If SUBSTR(cModal,1,1) == '1' // AEREO
        While !EE5->( EOF() )
            If EE5->EE5_XMODAL == 'A' .or. EE5->EE5_XMODAL == 'T'
                AADD(aFPalets,{EE5->EE5_CODEMB,EE5->EE5_CCOM,EE5->EE5_LLARG,EE5->EE5_HALT})
            EndIf
            EE5->( dbSkip() )
        End
        If Empty(aFPalets)
            EE5->( dbSeek( xFilial() + 'PALLET020' ) )
            AADD(aFPalets,{EE5->EE5_CODEMB,EE5->EE5_CCOM,EE5->EE5_LLARG,EE5->EE5_HALT})
        EndIf
    EndIf

    If SUBSTR(cModal,1,1)=='2' // MARITMO
        //cCODP :='PALLET018'
        While !EE5->( EOF() )
            If EE5->EE5_XMODL == 'M' .or. EE5->EE5_XMODAL == 'T'
                AADD(aFPalets,{EE5->EE5_CODEMB,EE5->EE5_CCOM,EE5->EE5_LLARG,EE5->EE5_HALT})
            EndIf
            EE5->( dbSkip() )
        End
        If Empty(aFPalets)
            EE5->( dbSeek( xFilial() + 'PALLET018' ) )
            AADD(aFPalets,{EE5->EE5_CODEMB,EE5->EE5_CCOM,EE5->EE5_LLARG,EE5->EE5_HALT})
        EndIf
    EndIf


   // aRetCalc := U_CalPalet(aEmbFinal,aProdutos,aFPalets)

    //aPalets := aRetCalc[1]
    //aCalCx  := aRetCalc[2]
    //aCalPro := aRetCalc[3]

    aPalets:=aclone(aFPalets)
    //IF EE5->(Dbseek(Xfilial("EE5")+cCODP)) // Cadastro de embalagens (palets)
    _CSEQP1:='000'
    For x := 1 to len(aPalets)
        EE5->( dbSeek( xFilial() + aPalets[x,1] ) )
        _CSEQP1:=SOMA1(_CSEQP1)
        AADD(aColsPal,{_CSEQP1,; 
        EE5->EE5_CODEMB,;
            EE5->EE5_DIMENS,;
            EE5->EE5_CCOM,;
            EE5->EE5_LLARG,;
            EE5->EE5_HALT,;
            '',;
            '',;
            .F.})//.f. POSICAO Flag de Delecao
        oGetPalet:ACOLS:=aColsPal
        oGetPalet:oBrowse:setfocus()
        oGetPalet:oBrowse:Refresh()

        _CSEQP2:='000'
        FOR nX:=1  TO LEN(aCOLSEMB)
             _CSEQP2:=SOMA1(_CSEQP2)
            FOR nY := 1 TO  aCOLSEMB[nX][4] //mlsz Transform(nQtdTot,"@E 99999999")
                AADD(aColsCx,{_CSEQP2+'-'+LTRIM(Transform(nY,"@E 999"))+'/'+LTRIM(Transform(aCOLSEMB[nX][4],"@E 999")),;
                    aCOLSEMB[nX][2],;
                    aCOLSEMB[nX][3],;
                    0,;
                    0,;
                    0,;
                    '',;
                    0,;
                    aCOLSEMB[nX][6],;
                    aCOLSEMB[nX][7],;
                    .F.})//.f. POSICAO Flag de Delecao]


                dbSelectArea("SELPED")
                DbGoTop()
                _xQTDVEN:=0
                _XQTDEMB:=0
                _XQTDUNIT:=0


                IF lSelPorItem==.T.
                    Do While !SELPED->(eof())
                        IF TRIM(SELPED->C6_PRODUTO)==TRIM(aCOLSEMB[nX][5])
                            _xQTDVEN:=_xQTDVEN+SELPED->C6_QTDVEN
                            _XQTDEMB:=_XQTDEMB+SELPED->QTDEMB
                        ENDIF
                        dbskip()
                    EndDo
                    IF _xQTDVEN>0
                        _XQTDUNIT :=_XQTDEMB/_xQTDVEN
                    ENDIF
                    if _XQTDUNIT>0
                        _XQTDUNIT:=(aCOLSEMB[nX][6]/_XQTDUNIT)/aCOLSEMB[nX][4]
                    endif

                    IF _XQTDUNIT>_xQTDVEN
                        _XQTDUNIT:=_xQTDVEN
                    ENDIF
                    IF lSelPorItem==.T.
                        _xPROD :=aCOLSEMB[nX][5]
                    ENDIF

                    AADD(aColsPR,{_CSEQP2+'-'+LTRIM(Transform(nY,"@E 999"))+'/'+LTRIM(Transform(aCOLSEMB[nX][4],"@E 999")),;
                        aCOLSEMB[nX][5],;
                        '',;
                        _XQTDUNIT,;
                        .F.})//.f. POSICAO Flag de Delecao]
                    oGetCaixa:ACOLS:=aColsCX
                    oGetCaixa:oBrowse:setfocus()
                    oGetCaixa:oBrowse:Refresh()

                    oGetProduto:ACOLS:=aColsPR
                    oGetProduto:oBrowse:setfocus()
                    oGetProduto:oBrowse:Refresh()
                ENDIF

                IF lSelPorItem==.F.
                    SELPED->(DbGoTop())
                    Do While !SELPED->(eof())
                        IF TRIM(SELPED->B1_GRUPO)==TRIM(aCOLSEMB[nX][1])
                            _xQTDVEN:=_xQTDVEN+SELPED->C6_QTDVEN
                            _XQTDEMB:=_XQTDEMB+SELPED->QTDEMB
                        ENDIF
                        dbskip()
                    EndDo
                    IF _xQTDVEN>0
                        _XQTDUNIT :=_XQTDEMB/_xQTDVEN
                    ENDIF
                    // if _XQTDUNIT>0
                    //     _XQTDUNIT:=(aCOLSEMB[nX][6]/_XQTDUNIT)/aCOLSEMB[nX][4]
                    // endif

                    IF _XQTDUNIT>_xQTDVEN
                        _XQTDUNIT:=_xQTDVEN
                    ENDIF
                    IF lSelPorItem==.T.
                        _xPROD :=aCOLSEMB[nX][5]
                    ENDIF

                    SELPED->(DbGoTop())
                    Do While !SELPED->(eof())
                        IF TRIM(SELPED->B1_GRUPO)==TRIM(aCOLSEMB[nX][1])
                            _XQTDUNIT:=(aCOLSEMB[nX][6]/_XQTDUNIT)/aCOLSEMB[nX][4]
                            AADD(aColsPR,{_CSEQP2+'-'+LTRIM(Transform(nY,"@E 999"))+'/'+LTRIM(Transform(aCOLSEMB[nX][4],"@E 999")),;
                                SELPED->C6_PRODUTO,;
                                '',;
                                SELPED->C6_QTDVEN,;
                                .F.})//.f. POSICAO Flag de Delecao]
                        ENDIF
                        dbskip()
                    ENDDO
                    oGetCaixa:ACOLS:=aColsCX
                    oGetCaixa:oBrowse:setfocus()
                    oGetCaixa:oBrowse:Refresh()

                    oGetProduto:ACOLS:=aColsPR
                    oGetProduto:oBrowse:setfocus()
                    oGetProduto:oBrowse:Refresh()
                ENDIF
            NEXT
        NEXT
        SELPED->(DbGoTop())
    NEXT

     aRetCalc := U_CalPalet(aColsCx,aColsPR,aColsPal)

    //aPalets := aRetCalc[1]
    //aCalCx  := aRetCalc[2]
    //aCalPro := aRetCalc[3]
    oGetCaixa:ACOLS:=aRetCalc[1]//aColsCX
    oGetCaixa:oBrowse:setfocus()
    oGetCaixa:oBrowse:Refresh()

    oGetProduto:ACOLS:=aRetCalc[2]//aColsPR
    oGetProduto:oBrowse:setfocus()
    oGetProduto:oBrowse:Refresh()

    oGetPalet:ACOLS:=aRetCalc[3]//aColsPal
    oGetPalet:oBrowse:setfocus()
    oGetPalet:oBrowse:Refresh()
return




Static Function INVERTEC()

    oMark:oBrowse:setfocus()

    dbSelectArea("SELCITY")
    SELCITY->(DbGoTop())

    Do While !SELCITY->(eof())
        RecLock("SELCITY",.F.)
        If !EMPTY(SELCITY->A1_OK)
            REPLACE A1_OK WITH ""
        ElseIf EMPTY(SELCITY->A1_OK)
            REPLACE A1_OK WITH thismark()
        Else
            REPLACE A1_OK WITH "" ///getmark()
        EndIf
        SELCITY->(MsUnlock())


        oMark:oBrowse:setfocus()
        oMark:oBrowse:Refresh()

        SELCITY->(dbskip())

    EndDo
    DbGoTop()

    oTexto2:Refresh()
    oTexto4:Refresh()
    oMark:oBrowse:setfocus()
    oMark:oBrowse:Refresh()

    oMark2:oBrowse:setfocus()
    oMark2:oBrowse:Refresh()

    ProcCity(_C5NUM)
    ProcPed(_C5NUM)

Return()

Static Function INVERTEP()

    dbSelectArea("SELPED")
    DbGoTop()
    Do While !SELPED->(eof())
        RecLock("SELPED",.F.)
        If marked("C5_OK")
            REPLACE C5_OK WITH ""
        ElseIf EMPTY(SELPED->C5_OK)
            REPLACE C5_OK WITH thismark()
        Else
            REPLACE C5_OK WITH ""  ///getmark()
        EndIf
	/*
        If Empty(SELPED->C5_OK) .or. !marked("C5_OK")
		REPLACE C5_OK WITH thismark()
        Else
		REPLACE C5_OK WITH SPACE(02)  ///getmark()
        EndIf
	*/
        MsUnlock()
        dbskip()
    EndDo
    DbGoTop()

    oTexto2:Refresh()
    oTexto4:Refresh()
    oMark:oBrowse:setfocus()
    oMark:oBrowse:Refresh()
    oMark2:oBrowse:setfocus()
    oMark2:oBrowse:Refresh()


    ProcPed(_C5NUM)

Return()

Static Function ProcCity(_C5NUM)

    MsgRun("Selecionando Pedidos de Venda... Aguarde...","Seleção de Pedidos de Venda em aberto",{|| xSelCity(_C5NUM)})

Return

Static Function ProcPed(_C5NUM)

    MsgRun("Selecionando Pedidos de Venda... Aguarde...","Seleção de Pedidos de Venda em aberto",{|| xSelPed(_c5num)})

Return

//-----------------------------------------------------------------------------------------------------
Static Function xSelCity(_C5NUM)

    Local x, nk      := 0
    PRIVATE aEstruPA := {}

//// Limpando SELPED
    //msgalert('xselcity '+_C5NUM)
    Dbselectarea("SELPED")
    SELPED->(Dbgotop())

    WHILE !SELPED->(EOF())
        RECLOCK("SELPED",.F.)
        SELPED->(Dbdelete())
        SELPED->(MSUNLOCK())
        SELPED->(Dbskip())
    End

//Dbselectarea("SELCITY")
//SELCITY->(Dbgotop())

//While !SELCITY->(EOF())
    //Dbselectarea("SELCITY")
    //If !Empty(SELCITY->A1_OK)

    IF SELECT("QRYPD") > 0
        QRYPD->(Dbclosearea())
    Endif

    cQueryS := " SELECT C6_ITEM,C6_PRODUTO,B1_GRUPO,C6_DESCRI,C6_UM,C6_QTDVEN , "
    cQueryS += " '   ' AS EMBAL, '   ' AS DIMEN, 0 AS QTDEMB  ,0 AS PESO_REA, 0 AS CUB,  "
    cQueryS += " 0 AS PESO_AER, 0 AS  PESO_ROD, 0 AS  PESO_MAR "
    cQueryS += " FROM SC6010,SB1010  "
    cQueryS += " WHERE C6_NUM='"+_C5NUM+"' AND  "
    cQueryS += "       B1_COD=C6_PRODUTO AND   "
    cQueryS += "       SC6010.D_E_L_E_T_='' AND SB1010.D_E_L_E_T_=''  "

    TCQUERY cQueryS NEW ALIAS "QRYPD"

    //TCSETFIELD("QRYPD","C5_EMISSAO","D",8,0)

    Dbselectarea("QRYPD")
    QRYPD->(Dbgotop())

    While !QRYPD->(EOF())
        aEstruPA := {}
        Dbselectarea("SELPED")
        RECLOCK("SELPED",.T.)
        FOR nk := 2 to Len(_aCpos2)
            REPLACE &("SELPED->"+_aCpos2[nk,1]) WITH &("QRYPD->"+_aCpos2[nk,1]) //MLS
        Next nk
        //--------------------------EXPLODE ESTRUTURA---------------
        ExpEstr2(QRYPD->C6_PRODUTO,1)
        //----------------------------------------------------------
        lEMBAL:=.F.
        For x := 1 to Len(aEstruPA)
            _CG1COD := aEstruPA[x,1]
            _nG1QTD := aEstruPA[x,2] ////MLS
            _cEMBNIV:= aEstruPA[x,3]
            IF (SG1->(Dbseek(Xfilial("SG1")+QRYPD->C6_PRODUTO+_CG1COD))) .OR. ( _cEMBNIV=='2')
                IF (SG1->(Dbseek(Xfilial("SG1")+QRYPD->C6_PRODUTO+_CG1COD)))
                    _nG1QTD:=SG1->G1_QUANT
                ELSE
                    _nG1QTD:=aEstruPA[x,2]
                ENDIF
                IF _cEMBNIV=='2'
                    lEMBAL:=.T.
                    REPLACE SELPED->EMBAL WITH  _CG1COD//SG1->G1_COMP
                    //IF EE5->(Dbseek(Xfilial("EE5")+SG1->G1_COMP))
               
                    IF EE5->(Dbseek(Xfilial("EE5")+_CG1COD))
                        REPLACE SELPED->DIMEN        WITH  EE5->EE5_DIMENS
                        REPLACE SELPED->QTDEMB       WITH  SELPED->C6_QTDVEN  *_nG1QTD
                        //REPLACE SELPED->CUB          WITH (SELPED->C6_QTDVEN  * _nG1QTD)*EE5->EE5_XCUB
                        //REPLACE SELPED->PESO_AER     WITH (SELPED->C6_QTDVEN  * _nG1QTD)*EE5->EE5_XPSAER
                        //REPLACE SELPED->PESO_ROD     WITH (SELPED->C6_QTDVEN  * _nG1QTD)*EE5->EE5_XPSROD
                        //REPLACE SELPED->PESO_MAR     WITH (SELPED->C6_QTDVEN  * _nG1QTD)*EE5->EE5_XPSMAR
                        ELSE
                        REPLACE SELPED->DIMEN        WITH  'Nao Cadastrado EE5(1)' // MLS 20201026
                        //REPLACE SELPED->QTDEMB       WITH  SELPED->C6_QTDVEN  *_nG1QTD
                    ENDIF
                    //ENDIF
                ENDIF
            ENDIF
        Next x
        IF lEMBAL==.F.
            For x := 1 to Len(aEstruPA)
                _CG1COD := aEstruPA[x,1]
                _nG1QTD := aEstruPA[x,2] ////MLS
                _cEMBNIV:= aEstruPA[x,3]
                // IF SG1->(Dbseek(Xfilial("SG1")+QRYPD->C6_PRODUTO+_CG1COD))
                //IF (SG1->G1_XXEMBNI=='1' .AND. SG1->G1_XPESEMB=='S') .OR.  _cEMBNIV=='1'
                IF _cEMBNIV=='1'
                    //IF _cEMBNIV=='2'
                    REPLACE SELPED->EMBAL WITH  _CG1COD
                    IF EE5->(Dbseek(Xfilial("EE5")+_CG1COD))
                        REPLACE SELPED->DIMEN        WITH  EE5->EE5_DIMENS
                        REPLACE SELPED->QTDEMB       WITH  SELPED->C6_QTDVEN  * _nG1QTD
                        //REPLACE SELPED->CUB          WITH (SELPED->C6_QTDVEN  * _nG1QTD)*EE5->EE5_XCUB
                        //REPLACE SELPED->PESO_AER     WITH (SELPED->C6_QTDVEN  * _nG1QTD)*EE5->EE5_XPSAER
                        //REPLACE SELPED->PESO_ROD     WITH (SELPED->C6_QTDVEN  * _nG1QTD)*EE5->EE5_XPSROD
                        //REPLACE SELPED->PESO_MAR     WITH (SELPED->C6_QTDVEN  * _nG1QTD)*EE5->EE5_XPSMAR
                        ELSE
                           REPLACE SELPED->DIMEN        WITH  'Nao Cadastrado EE5(2)'
                    ENDIF
                    //ENDIF
                ENDIF
                //ENDIF
            Next x
        ENDIF
        lEMBAL:=.F.
        SELPED->(MSUNLOCK())
        QRYPD->(Dbskip())
    End


//RetEmb2ZW(cGrupEmb, nQtEmb, cNivEmb, cCliEmb, cLojEmb)

//AADD(aEMBTmp,{SZW->ZW_CODEMB, nQTEmb, SZW->ZW_PESO})
    //Endif
//	SELCITY->(Dbskip())
//End
//-----------------------------------------------------------------------------------------------------

    SELPED->(Dbgotop())
    aGRUPOE:={}
    aGRUPOE2:={}
    SZW->(dbSetOrder(2))
    lNIV3:=.F.
/*
    _cCliente := posicione('SC5',1,xFILIAL('SC5')+_C5NUM,'C5_CLIENTE')
    _cLOJA    := posicione('SC5',1,xFILIAL('SC5')+_C5NUM,'C5_LOJACLI')

    SA1->(dbSeek(xFilial("SA1")+_cCliente+_cLOJA))

    lSelPorItem := If("HUAWEI" $ SA1->A1_NOME, .T., .F.)

    If !lSelPorItem
        If ("ALCATEL" $ SA1->A1_NOME)
            lSelPorItem := .T.
        EndIf
        If GetMv("MV_XVERTEL")
            If ("TELEFONICA" $ SA1->A1_NREDUZ)
                lSelPorItem := .T.
            EndIf
            If ("ERICSSON" $ SA1->A1_NOME)
                lSelPorItem := .T.
            EndIf
        EndIf
        If GetMv("MV_XVEROI")
            If ("OI S" $ Upper(SA1->A1_NOME)) .Or. ("OI MO" $ Upper(SA1->A1_NOME)) .Or. ("TELEMAR" $ Upper(SA1->A1_NOME)) .Or. ("BRASIL TELECOM COMUNICACAO MUL" $ Upper(SA1->A1_NOME))
                lSelPorItem := .T.
            EndIf
        EndIf

        //Verifica se � clietne CLARO
        If GetMv("MV_XVERCLA")
            If ("CLARO" $ Upper(SA1->A1_NOME)) .Or. ("CLARO" $ Upper(SA1->A1_NREDUZ)) .Or. ("BRASIL TELECOM COMUNICACAO MUL" $ Upper(SA1->A1_NOME))
                lSelPorItem := .T.
            EndIf
        EndIf
    EndIf
*/
    cSEQEMB:='000'
    DO WHILE !SELPED->(EOF())
        lNIV3:=.F.
        //IF  SZW->(dbSeek(xFilial("SZW")+SELPED->B1_GRUPO+SPACE(06)+SPACE(02)+'3'))
        //    Do While SZW->(!Eof()) .And. SZW->ZW_FILIAL+SZW->ZW_GRUPO+SZW->ZW_CLIENTE+SZW->ZW_LOJA+SZW->ZW_NIVEL == xFilial("SZW")+SELPED->B1_GRUPO+space(06)+space(02)+'3'
        //        IF alltrim(SZW->ZW_CODEMB)==alltrim(SELPED->EMBAL)
        //            lNIV3:=.T.
        //            If aScan(aGRUPOE2,{ |x| Upper(AllTrim(x[3])) == Trim(SELPED->EMBAL) }) == 0  //MLSZ
        //                AADD(aGRUPOE2,{SELPED->B1_GRUPO,SELPED->QTDEMB,SELPED->EMBAL,SELPED->C6_PRODUTO })
        //            ELSE
        //                If aScan(aGRUPOE2,{ |x| Upper(AllTrim(x[4])) == Trim(SELPED->C6_PRODUTO) }) == 0  //MLSZ
        //                    AADD(aGRUPOE2,{SELPED->B1_GRUPO,SELPED->QTDEMB,SELPED->EMBAL,SELPED->C6_PRODUTO })
        //                else
        //                    For nX:=1 to len(aGRUPOE2)
        //                        IF aGRUPOE2[nX][3] == SELPED->EMBAL
        //                            IF lSelPorItem==.T.
        //                                IF aGRUPOE2[nX][4]==SELPED->C6_PRODUTO
        //                                    aGRUPOE2[nX][2]:=aGRUPOE2[nX][2]+SELPED->QTDEMB
        //                                ENDIF
        //                            ELSE //NAO E POR ITEM
        //                                aGRUPOE2[nX][2]:=aGRUPOE2[nX][2]+SELPED->QTDEMB
        //                            ENDIF
        //                        ENDIF
        //                    NEXT nX
        //                ENDIF
        //            Endif
        //        ENDIF
        //        SZW->(Dbskip())
        //    ENDDO
        //ENDIF
        //lSelIt2 :=.T.

        nQTDEMB:=SELPED->QTDEMB

        IF INT(nQTDEMB)- nQTDEMB <> 0
            nQTDEMB := INT(nQTDEMB)+1
        ENDIF

        IF nQTDEMB <1
            nQTDEMB:=1
        ENDIF

        IF substr(SELPED->B1_GRUPO,1,4)$('CORD|0007')
            AADD(aGRUPOE,{SELPED->B1_GRUPO,nQTDEMB,SELPED->EMBAL,SELPED->C6_PRODUTO,SELPED->C6_QTDVEN })
        ELSE
            AADD(aGRUPOE2,{SELPED->B1_GRUPO,nQTDEMB,SELPED->EMBAL,SELPED->C6_PRODUTO,SELPED->C6_QTDVEN })
        ENDIF
        //IF lNIV3==.F.
        //    lSelIt2 :=.T.
        //    If aScan(aGRUPOE,{ |x| Upper(AllTrim(x[1])) == Trim(SELPED->B1_GRUPO) }) == 0  //MLSZ
        //        if  lSelIt2 ==.T. //lSelPorItem ==.T.
        //            AADD(aGRUPOE,{SELPED->B1_GRUPO,SELPED->QTDEMB,SELPED->EMBAL,SELPED->C6_PRODUTO  })
        //        else
        //            AADD(aGRUPOE,{SELPED->B1_GRUPO,SELPED->QTDEMB,SELPED->EMBAL,space(15)  })
        //        endif
        //    ELSE
        //        For nX:=1 to len(aGRUPOE)
        //            if  lSelIt2 ==.T. // lSelPorItem ==.T.
        //                If aScan(aGRUPOE,{ |x| Upper(AllTrim(x[4])) == Trim(SELPED->C6_PRODUTO ) }) == 0
        //                    AADD(aGRUPOE,{SELPED->B1_GRUPO,SELPED->QTDEMB,SELPED->EMBAL,SELPED->C6_PRODUTO  })
        //                    //aGRUPOE[nX][2]:=aGRUPOE[nX][2]+SELPED->QTDEMB
        //                ELSE
        //                    aGRUPOE[nX][2]:=aGRUPOE[nX][2]+SELPED->QTDEMB
        //                    //AADD(aGRUPOE,{SELPED->B1_GRUPO,SELPED->QTDEMB,SELPED->EMBAL,SPACE(15) })
        //                    //AADD(aGRUPOE,{SELPED->B1_GRUPO,SELPED->QTDEMB,SELPED->EMBAL,SELPED->C6_PRODUTO  })
        //                ENDIF
        //            ELSE
        //                IF aGRUPOE[nX][1] == SELPED->B1_GRUPO .AND. aGRUPOE[nX][3] == SELPED->EMBAL
        //                    aGRUPOE[nX][2]:=aGRUPOE[nX][2]+SELPED->QTDEMB
        //                ENDIF
        //                IF aGRUPOE[nX][1] == SELPED->B1_GRUPO .AND. aGRUPOE[nX][3] <> SELPED->EMBAL
        //                    If aScan(aGRUPOE,{ |x| Upper(AllTrim(x[1]))+Upper(AllTrim(x[3])) ==  TRIM(SELPED->B1_GRUPO)+TRIM(SELPED->EMBAL) }) == 0
        //                        AADD(aGRUPOE,{SELPED->B1_GRUPO,SELPED->QTDEMB,SELPED->EMBAL,SPACE(15)  })
        //                        //ELSE
        //                        //   aGRUPOE[nX][2]:=aGRUPOE[nX][2]+SELPED->QTDEMB
        //                    ENDIF
        //                ENDIF
        //            ENDIF
        //        NEXT nX
        //    Endif
        //ENDIF
        SELPED->(Dbskip())
    ENDDO
    /*
    IF lSelPorItem ==.F.
        ASort((x[1]+x[4]) , , , {|x,y|(x[1]+x[4]) > (y[1]+y[4]) }) // grupo + produto
        _GRPE1:=aGRUPOE[1][1]
        _GRPE2:=0
        _GRPE3:=aGRUPOE[1][2]
        _GRPE4:=aGRUPOE[1][3]
        For nY:=1 to len(aGRUPOE)

            If aScan(aGRUPOT,{ |x| Upper(AllTrim(x[1])) == Trim(aGRUPOE[nY][1]) }) == 0  //MLSZ
                AADD(aGRUPOT,{aGrupoe[nY][01],aGrupoe[nY][02],aGrupoe[nY][03],SPACE(15)  })
            ELSE
                aGrupoT[x][02]:=aGrupoT[x][02]+c[nY][02]
            endif
        NEXT
        aGrupoe:=aGrupoT
    ENDIF
*/
    IF lSelPorItem==.F. .AND. LEN(aGRUPOE)>0
        ASort(aGRUPOE, , , {|x,y|x > y})
        _nQTDEMB :=0
        aGRUPOT:={}

        _cGRUPO  :=aGRUPOE[1][1]
        _nQTDEMB :=0
        For nX:=1 to len(aGRUPOE)
            IF  aGRUPOE[nX][1]<> _cGRUPO
                AADD(aGRUPOT,{_cGRUPO,_nQTDEMB,'','','' })
                _cGRUPO  :=aGRUPOE[nX][1]
                _nQTDEMB :=aGRUPOE[nX][2]
            ELSE
                _nQTDEMB := _nQTDEMB+aGRUPOE[nX][2]
            ENDIF
        NEXT nx
        //MSGALERT(LEN(aGRUPOE))
        //MSGALERT(NX)
        AADD(aGRUPOT,{_cGRUPO,_nQTDEMB,'','','' })
        //MSGALERT(LEN(aGRUPOT))
        aGRUPOE :={}
        aGRUPOE := AClone(aGRUPOT)
    ENDIF

    For nX:=1 to len(aGRUPOE)

        IF INT(aGRUPOE[nX][2])- aGRUPOE[nX][2] <> 0
            aGRUPOE[nX][2] := INT(aGRUPOE[nX][2])+1
        ENDIF

        IF aGRUPOE[nX][2] <1
            aGRUPOE[nX][2]:=1
        ENDIF
        aEmb := U_RetEmb3ZW(aGRUPOE[nX][1], round(aGRUPOE[nX][2],0) , '3' , space(06), space(02),aGRUPOE[nX][3],aGRUPOE[nX][4],lSelPorItem)

        FOR nY :=1 TO LEN(aEmb)

            _nqtdemb3 := Round( aEmb[nY][2],0)
            IF EE5->(Dbseek(Xfilial("EE5")+aEmb[nY][1]))
                _cDIMENS :=EE5->EE5_DIMENS
                _nCUB    :=_nqtdemb3 * EE5->EE5_XCUB
            ELSE
                _cDIMENS := 'N�o Cadastrado EE5(3)'
                _nCUB    := 0

            ENDIF//mlsy
            /*
            AADD(aColsEMB,{aGRUPOE[nX][1],;
                aEmb[nY][1],;
                _cDIMENS,;
                _nqtdemb3,;
                _nCUB,;
                .F.})//.f. POSICAO 8Flag de Delecao]
              
                */
            IF _nqtdemb3 <1
                _nqtdemb3:=1
            ENDIF
            cSEQEMB:=SOMA1(cSEQEMB,3)
            AADD(aColsEMB,{aGRUPOE[nX][1],;
                aEmb[nY][1],;
                _cDIMENS,;
                _nqtdemb3,;
                aEmb[nY][4],;
                aEmb[nY][5],;
                cSEQEMB,;
                .F.})//.f. POSICAO 8Flag de Delecao]
        Next nY
    Next nX

    For nX:=1 to len(aGRUPOE2)
/*
        AADD(aColsEMB,{aGRUPOE2[nX][1],;
            aGRUPOE2[nX][3],;
            '_cDIMENS',;
            aGRUPOE2[nX][2];
            0,;
            .F.})//.f. POSICAO 8Flag de Delecao
*/

// AADD(aGRUPOE2,{SELPED->B1_GRUPO,SELPED->QTDEMB,SELPED->EMBAL })
        IF EE5->(Dbseek(Xfilial("EE5")+aGRUPOE2[nX][3]))
            _cDIMENS :=EE5->EE5_DIMENS
            _nCUB    := Round(aGRUPOE2[nX][2],0) * EE5->EE5_XCUB//
        ELSE
            _cDIMENS := 'Nao Cadastrado EE5(4)'
            _nCUB    := 0
        ENDIF//mlsy

        IF aGRUPOE2[nX][2]<1
            aGRUPOE2[nX][2] :=1
        ENDIF

        cSEQEMB:=SOMA1(cSEQEMB,3)
        AADD(aColsEMB,{aGRUPOE2[nX][1],;
            aGRUPOE2[nX][3],;
            _cDIMENS,;
            Round(aGRUPOE2[nX][2],0),;
            aGRUPOE2[nX][4],;
            Round(aGRUPOE2[nX][2],0),;
            cSEQEMB,;
            .F.})//.f. POSICAO 8Flag de Delecao] //mlsy
/*  _nCUB ,; */

    NEXT NX
    SELPED->(Dbgotop())
//oMark:oBrowse:setfocus()
//oMark:oBrowse:Refresh()
//oMark2:oBrowse:setfocus()
//oMark2:oBrowse:Refresh()
Return

Static Function xSelPed()
    nQtdTot := 0
    nVlrTot := 0
    nRecSP := 0
    nRecSP := SELPED->(RECNO())

    Dbselectarea("SELPED")
    SELPED->(Dbgotop())

    While !SELPED->(EOF())
        Dbselectarea("SELPED")
        If Marked("C6_OK") .AND. !Empty(SELPED->C6_OK)
            // nQtdTot += SELPED->QUANT
            // nVlrTot += SELPED->PESO
        Endif
        SELPED->(Dbskip())
    End
    SELPED->(Dbgoto(nRecSP))

    //oTexto2:Refresh()
    //oTexto4:Refresh()
    //oMark:oBrowse:setfocus()
    //oMark:oBrowse:Refresh()
    //oMark2:oBrowse:setfocus()
    //oMark2:oBrowse:Refresh()
Return










    *--------------------------------------------------------------------------*
Static Function  ExpEstr2(cProduto,nQuantPai)
    *--------------------------------------------------------------------------*

    PRIVATE nQtdBase   :=1
    PRIVATE cCOMP      :=''
    PRIVATE nQTDCOMP   :=0

    SG1->(dbSelectArea("SG1"))
    SG1->(dbSeek(xFilial('SG1')+cProduto))

    EXPLSC4B(cProduto,nQuantPai,nQtdBase)
RETURN

    *--------------------------------------------------------------------------*
STATIC Function EXPLSC4B(cProduto,nQuantPai,nQtdBase)
    *--------------------------------------------------------------------------*
    LOCAL nReg,nQuantItem := 0

    dbSelectArea("SG1")
    While !Eof() .And. G1_FILIAL+G1_COD == xFilial()+cProduto
        IF G1_FIM >=DATE()
            nReg       := Recno()
            nQuantItem := ExplEstr(nQuantPai,,,)
            //dbSelectArea("SG1")

            //SB1->(dbSelectArea("SG1"))
            //SB1->(dbSeek(xFilial("SB1")+SG1->G1_COMP))
            //AADD(aEstruPA,{SG1->G1_COMP,nQuantItem})
            cCOMP   :=SG1->G1_COMP
            nQTDCOMP:=nQuantItem
            __XXEMBNI:=SG1->G1_XXEMBNI

            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Verifica se existe sub-estrutura                ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            //dbSelectArea("SG1")
            dbSeek(xFilial()+G1_COMP)
            IF Found()
                EXPLSC4B(G1_COD,nQuantItem,nQtdBase)
            ELSE
                AADD(aEstruPA,{cCOMP,nQTDCOMP,__XXEMBNI})
            EndIf
            dbGoto(nReg)
        ENDIF
        SG1->(dbSkip())
    EndDo

Return




USER FUNCTION RetEmb3ZW(cGrupEmb,nQtEmb,cNivEmb,cCliEmb,cLojEmb,cCODEMB,_cPRODUTO,lSELIT) // RECURSIVO


    LOCAL __CODEMB  := ""
    LOCAL __QTDEATE := 0
    LOCAL __PESO    := 0
    LOCAL aEMBTmp   := {}
    LOCAL aEMBTmp2  := {}
    LOCAL nSALDO    := nQtEmb

    LOCAL nQTDDE   :=0
    LOCAL nQTDATE  :=0
    LOCAL _nQTDEMB :=0
    LOCAL nZ       :=0

    SZW->(dbSetOrder(2))// ZW_FILIAL+ZW_GRUPO+ZW_CLIENTE+ZW_LOJA+ZW_NIVEL+ZW_SEQ

    If SZW->(dbSeek(xFilial("SZW")+cGrupEmb+SPACE(06)+SPACE(02)+cNivEmb))
        //Do While SZW->(!Eof()) .AND. SZW->ZW_GRUPO== cGrupEmb
        Do While SZW->(!Eof()) .And. SZW->ZW_FILIAL+SZW->ZW_GRUPO+SZW->ZW_CLIENTE+SZW->ZW_LOJA+SZW->ZW_NIVEL == xFilial("SZW")+cGrupEmb+cCLiEmb+cLojEmb+cNivEmb
            IF  (nSALDO >=SZW->ZW_QTDEDE .AND. nSALDO>=SZW->ZW_QTDEATE) .OR. ( (nSALDO >=SZW->ZW_QTDEDE .AND. nSALDO<=SZW->ZW_QTDEATE) )
                IF SZW->ZW_QTDEATE > nQTDATE
                    nQTDDE   :=SZW->ZW_QTDEDE
                    nQTDATE  :=SZW->ZW_QTDEATE
                    __CODEMB :=SZW->ZW_CODEMB
                    __PESO   :=SZW->ZW_PESO
                ENDIF
            ENDIF
            SZW->(DBSKIP())
        ENDDO

        _nQTDEMB :=nSALDO  / nQTDATE
        _nQTDEMB :=Int( _nQTDEMB )
        IF  _nQTDEMB <=0
            _nQTDEMB :=1
        ENDIF
        IF nSALDO>nQTDATE
            nSALDOP:=nQTDATE
        ELSE
            nSALDOP:=nSALDO
        ENDIF
        AADD(aEMBTmp,{__CODEMB, _nQTDEMB ,__PESO,_cPRODUTO,nSALDOP})
        nSALDO   :=nSALDO  - (_nQTDEMB * nQTDATE )//nSALDO   :=nSALDO  -  nQTDATE
        IF nSALDO<=0
            nSALDO :=0
        ENDIF
        //nSALDO   :=nSALDO  - (_nQTDEMB * nQTDATE )
    ELSE
        AADD(aEMBTmp,{cCODEMB, nQtEmb ,__PESO,_cPRODUTO,nSALDO})
        nSALDO:=0
    ENDIF

    IF  nSALDO>=1
        // MSGALERT (nSALDO)
        aEMBTmp2 := U_RetEmb3ZW(cGrupEmb, nSALDO , cNivEmb, cCliEmb, cLojEmb,cCODEMB,_cPRODUTO,lSELIT)
        FOR nZ:= 1 TO LEN(aEMBTmp2)
            AADD(aEMBTmp,{aEMBTmp2[nZ][1] , aEMBTmp2[nZ][2] ,aEMBTmp2[nZ][3],aEMBTmp2[nZ][4],aEMBTmp2[nZ][5] })
        NEXT
        // msgalert('aEMBTmp'+str(len(aEMBTmp2)))
    ELSE
        nSALDO := 0
    ENDIF
    //msgalert('aEMBTmp'+str(len(aEMBTmp)))
Return ( aEMBTmp )


User Function DCUBSZW
    Local cAlias  := "SZW"
    Local cTitulo := "Controle de Embalagens"
    //Local cFunAlt := "U_CADSC4AL()"
    //Local cFunEXC := "U_CADSC4EX()"
    //cFiltro := "C4_XXSIMU == 'S' "

    dbselectarea("SZW")
    //SET FILTER TO &(cFiltro)
    //AxCadastro( <cAlias>, <cTitulo>, <cVldExc>, <cVldAlt>)
    //AxCadastro(cAlias, cTitulo,cFunEXC, cFunAlt)
    //SET FILTER TO
    AxCadastro(cAlias, cTitulo)
Return

User Function DCUBEE5 ///// DCUBEE5 DCUBSZW
    Local cAlias  := "EE5"
    Local cTitulo := "Cadastro Embalagens"
    //Local cFunAlt := "U_CADSC4AL()"
    //Local cFunEXC := "U_CADSC4EX()"
    //cFiltro := "C4_XXSIMU == 'S' "

    dbselectarea("EE5")
    //SET FILTER TO &(cFiltro)
    //AxCadastro( <cAlias>, <cTitulo>, <cVldExc>, <cVldAlt>)
    //AxCadastro(cAlias, cTitulo,cFunEXC, cFunAlt)
    //SET FILTER TO
    AxCadastro(cAlias, cTitulo)
Return


/*

EE5_XMODAL   
EE5_DIM
------- ITEM --------------
ZZG_PEDIDO     C 6
ZZG_ITEM       C 2
ZZG_PRODUT     C 15 
ZZG_GRUPO      C 4 
ZZG_DESCRI     C 30
ZZG_UM	       C 2 
ZZG_QTDVEN     N 15,3
ZZG_EMBAL      C 15
ZZG_DIMEN      C 40
ZZG_QTDEMB     N 15,4
ZZG_PSREA      N 15,4
------- EMBALAGEM----------
ZZH_PEDIDO     C 6
ZZH_GRUPO      C 4
ZZH_COD        C 15
ZZH_DIM        C 30
ZZH_QTDE       N 12,5
ZZH_CUB        N 12,5
ZZH_PROD       C 15
-------- PALET------------
ZZI_PEDIDO     C 6
ZZI_SEQ        C 3
ZZI_COD        C 15   
ZZI_DIM        C 30 
ZZI_BASE       N 12,5 
ZZI_LAR        N 12,5 
ZZI_ALT        N 12,5 
ZZI_VAR        C 1    
ZZI_DUP        C 1    
--------- CAIXAS----------
ZZJ_PEDIDO     C 6   
ZZJ_SEQ        C 3
ZZJ_COD        C 15    
ZZJ_DIM        C 30  
ZZJ_ALT        N 12,5  
ZZJ_LAR        N 12,5  
ZZJ_COM        N 12,5  
ZZJ_GIR        C 1     
-------- Produto--------
ZZK_PEDIDO     C 6   
ZZK_SEQ        C 3
ZZK_COD        C 15 
ZZK_DES        C 30 
ZZK_QTD        N 12,5
-----------------------    

*/
