#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PFATEDI01 º Autor ³ EDVALDO NOBREGA    º Data ³  20/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ GERAÇÃO DE EDI COM A ERICSSON                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FATURAMENTO                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PFATEDI01()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cPerg       := "PFATED2"
Private oGeraTxt

Private cString := ""

ValidPerg()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Geração de Arquivo Texto - Ericsson")
@ 02,10 TO 060,190
@ 10,018 Say " Este programa ira gerar um arquivo texto, conforme os parame- "
@ 18,018 Say " tros definidos  pelo usuario,  com os registros do arquivo de "
@ 26,018 Say "                                                            "

@ 70,098 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
@ 70,128 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 70,158 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraTxt Centered

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ OKGERATXTº Autor ³ AP5 IDE            º Data ³  20/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. Executa a geracao do arquivo texto.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function OkGeraTxt

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o arquivo texto                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
ÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private nHdl    := fCreate(mv_par01)

Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

If nHdl == -1
    MsgAlert("O arquivo de nome "+mv_par01+" nao pode ser executado! Verifique os parametros.","Atencao!")
    Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a regua de processamento                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Processa({|| RunCont() },"Processando...")
Return


Static Function RunCont

Local nTamLin, cLin, cCpo
vCFOP:=''
// BUSCA O CFOP


SF2->(DBSETORDER(1))
SF2->(DBSEEK(xFILIAL("SF2")+ALLTRIM(MV_PAR02)+ALLTRIM(MV_PAR03)))
SF2->(ProcRegua(RecCount())) // Numero de registros a processar
nTamLin := 2
cLin    := '' //Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao
SF4->(DBSETORDER(1))
DO WHILE SF2->(!EOF()) .AND. SF2->F2_DOC >= ALLTRIM(MV_PAR02) .AND. SF2->F2_DOC <=ALLTRIM(MV_PAR04)
	IF SF2->F2_SERIE<>ALLTRIM(MV_PAR03) .AND. SF2->F2_SERIE<>ALLTRIM(MV_PAR05)
		SF2->(DBSKIP())
		LOOP
	ENDIF
	IF SF2->F2_CLIENTE<>ALLTRIM(MV_PAR06)
		SF2->(DBSKIP())
		LOOP
	ENDIF
	IF SD2->(DBSEEK(xFILIAL("SD2")+SF2->F2_DOC+SF2->F2_SERIE))
		IF SF4->(DBSEEK(xFILIAL("SF4")+SD2->D2_TES))
			IF SF4->F4_DUPLIC<>'S'
				SF2->(DBSKIP())
				LOOP
			ENDIF
		ENDIF
	ENDIF
	SD2->(DBSETORDER(3))
	SD2->(DBSEEK(xFILIAL("SD2")+SF2->F2_DOC+SF2->F2_SERIE))
	DO WHILE SD2->(!EOF()) .AND. SD2->D2_FILIAL= SF2->F2_FILIAL  .AND. SD2->D2_DOC= SF2->F2_DOC .AND. SD2->D2_SERIE=SF2->F2_SERIE .AND. SD2->D2_CLIENTE=SF2->F2_CLIENTE	
		IF vCFOP <> SD2->D2_CF
				vCFOP := SD2->D2_CF
		ENDIF
		SD2->(DBSKIP())		
	ENDDO
	cLin+= "1"  																											// TIPO DE REGISTRO = 1 CABECALHO DO ARQUIVO
	cLin+= "0"  																											// NÃO UTILIZADO (COLOCAR 0)
	cLin+= STRZERO(VAL(vCFOP)       ,6)  															// CFOP DA NOTA COM 6 CARACTERES
	cLin+= STRZERO(VAL(SF2->F2_DOC),9)  														//NUMERO DA NOTA FISCAL COM 9 CARACTERES
	cLin+= ALLTRIM(STR(VAL(SF2->F2_SERIE)))+' '																	// NUMERO DE SERIE DA NF   COM 2 CARACTERES
	cLin+= STRZERO((round(SF2->F2_VALMERC,2)*100) ,15)  												// VALOR TOTAL DE MERCADORIAS COM 15 CARACTERES
	cLin+= STRZERO((round(SF2->F2_BASEIPI,2)*100) ,15)  												// VALOR BASE IPI COM 15 CARACTERES  
	cLin+= STRZERO((round(SF2->F2_VALIPI,2)*100) ,15)  												// VALOR TOTAL IPI COM 15 CARACTERES  
	cLin+= STRZERO((round(SF2->F2_BASEICM,2)*100) ,15)  												// VALOR BASE ICM COM 15 CARACTERES 
	cLin+= '18'  												// TAXA ICM COM 2 CARACTERES  
	cLin+= STRZERO((round(SF2->F2_VALICM,2)*100) ,16)  												// VALOR ICM COM 16 CARACTERES 
	cLin+= Substr(DTOC(SF2->F2_EMISSAO),7,2)+Substr(DTOC(SF2->F2_EMISSAO),4,2)+Substr(DTOC(SF2->F2_EMISSAO),1,2) // DATA DE EMISSAO DA NF AA/MM/DD
	cLin+= Substr(DTOC(dDATABASE),7,2)+Substr(DTOC(dDATABASE),4,2)+Substr(DTOC(dDATABASE),1,2)+cEOL // DATA GERACAO DO ARQUIVO AA/MM/DD
	SD2->(DBGOTOP())
	SD2->(DBSEEK(xFILIAL("SD2")+SF2->F2_DOC+SF2->F2_SERIE))
	DO WHILE SD2->(!EOF()) .AND. SD2->D2_FILIAL= SF2->F2_FILIAL   .AND. SD2->D2_DOC= SF2->F2_DOC .AND. SD2->D2_SERIE=SF2->F2_SERIE .AND. SD2->D2_CLIENTE=SF2->F2_CLIENTE
	    IncProc()   // INCREMENTA A REGUA
	    SC6->(DBSETORDER(1))
//	    IF !SC6->(DBSEEK(xFILIAL("SB1")+SD2->D2_PEDIDO+SD2->D2_ITEMPV))
	    IF !SC6->(DBSEEK(xFILIAL("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV))		//MAURESI - 2021-05-05
	       ALERT("Pedido Não Localizado - Verifiquei a Nota Fiscal")
	    ENDIF
	    cLin+= "2"  																											   // TIPO DE REGISTRO = 1 CABECALHO DO ARQUIVO
	    cLin+= Transform(SC6->C6_SEUCOD,"@! XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")                    // CODIGO MATERIAL ERICSON COM 36 CARACTERES
	    cLin+= Transform(SD2->D2_UM 		,"@! XX")																		// UNIDADE DE MEDIDA COM 2 CARACTERES
	    cLin+= STRZERO(round(SD2->D2_QUANT,0) ,7)					   								// QUANTIDA DE ITEM COM 7 CARACTERES	  
		 cLin+= STRZERO((round(SD2->D2_PRCVEN,2)*100) ,13)														// VALOR UNITÁRIO COM 13 CARACTERES
		 cLin+= STRZERO((round(SD2->D2_TOTAL,2)*100) ,15)														// VALOR UNITÁRIO COM 15 CARACTERES	    
		 cLin+= STRZERO((round(SD2->D2_BASEIPI,2)*100) ,17)  												 	// VALOR BASE IPI COM 17 CARACTERES  	 
		 cLin+= STRZERO(SD2->D2_IPI ,2)  																	 	// PERCENTUAL IPI COM 2 CARACTERES  	 	 
		 cLin+= STRZERO((round(SD2->D2_VALIPI,2)*100) ,15)														// VALOR IPI COM 15 CARACTERES	
	    cLin+= "0"  																								   // COLOCAR 0(ZERO)			
	    SB1->(DBSETORDER(1))                                                                                                            
	    SB1->(DBSEEK(xFILIAL("SB1")+SD2->D2_COD))
		 cLin+= Transform(SB1->B1_POSIPI  ,"@E 99999999" )																// NCM COM 8 CARACTERES    
		 vITEM:=VAL(SUBSTRING(ALLTRIM(SC6->C6_SEUDES),LEN(ALLTRIM(SC6->C6_SEUDES))-4,5)) 
		 cLin+= STRZERO(vITEM ,4)																	// ITEM DO PV COM 4 CARACTERES	 
	 	 SC5->(DBSETORDER(1))
	 	 SC5->(DBSEEK(xFILIAL("SC5")+ALLTRIM(SD2->D2_PEDIDO)))
	 	 cLin+= REPL("0",10-LEN(ALLTRIM(SC5->C5_ESP1)))+ALLTRIM(SC5->C5_ESP1)+cEOL	 														// NUMERO DO PEDIDO COM 10 CARACTERES 	 
		 
	    SD2->(dbSkip())
	EndDo
	SF2->(DBSKIP())
ENDDO
cARQUI := Space(nTamLin)+cEOL
cARQUI := Stuff(cARQUI,01,02,cLin)
If fWrite(nHdl,cARQUI,Len(cLin)) != Len(cLin)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
    	RETURN .F.
     Endif
Endif

fClose(nHdl)
Close(oGeraTxt)

Return


Static Function ValidPerg()

_cAlias := Alias()

DbSelectArea("SX1")
DbSetOrder(1)
aRegs :={}


Aadd(aRegs,{cPerg,"01","Arquivo - Destino ","Arquivo - Destino ","Arquivo - Destino ","mv_ch1","C" ,50     ,0      ,0     ,"G",""   ,"mv_par01",""     ,""     ,""     ,""    ,""   ,""    ,""     ,""     ,""   ,""   ,""    ,""     ,""     ,""   ,""   ,""   ,""     ,""      ,""  ,""   ,""   ,""     ,""     ,""   ,"","   "  })
Aadd(aRegs,{cPerg,"02","Numero da NF de  ?","Numero da NF de  ?","Numero da NF de  ?","mv_ch2","C" ,06     ,0      ,0     ,"G",""   ,"mv_par02",""     ,""     ,""     ,""    ,""   ,""    ,""     ,""     ,""   ,""   ,""    ,""     ,""     ,""   ,""   ,""   ,""     ,""      ,""  ,""   ,""   ,""     ,""     ,""   ,"SF2",""  })
Aadd(aRegs,{cPerg,"03","Serie NF de      ?","Serie NF de      ?","Serie NF de      ?","mv_ch3","C" ,03     ,0      ,0     ,"G",""   ,"mv_par03",""     ,""     ,""     ,""    ,""   ,""    ,""     ,""     ,""   ,""   ,""    ,""     ,""     ,""   ,""   ,""   ,""     ,""      ,""  ,""   ,""   ,""     ,""     ,""   ,"","   "  })
Aadd(aRegs,{cPerg,"04","Numero NF Ate    ?","Numero NF Ate    ?","Numero NF Ate    ?","mv_ch4","C" ,06     ,0      ,0     ,"G",""   ,"mv_par04",""     ,""     ,""     ,""    ,""   ,""    ,""     ,""     ,""   ,""   ,""    ,""     ,""     ,""   ,""   ,""   ,""     ,""      ,""  ,""   ,""   ,""     ,""     ,""   ,"SF2",""  })
Aadd(aRegs,{cPerg,"05","Serie NF Ate     ?","Serie NF Ate     ?","Serie NF Ate     ?","mv_ch5","C" ,03     ,0      ,0     ,"G",""   ,"mv_par05",""     ,""     ,""     ,""    ,""   ,""    ,""     ,""     ,""   ,""   ,""    ,""     ,""     ,""   ,""   ,""   ,""     ,""      ,""  ,""   ,""   ,""     ,""     ,""   ,"","   "  })
Aadd(aRegs,{cPerg,"06","Código do Cliente?","Código do Cliente?","Código do Cliente?","mv_ch6","C" ,10     ,0      ,0     ,"G",""   ,"mv_par06",""     ,""     ,""     ,""    ,""   ,""    ,""     ,""     ,""   ,""   ,""    ,""     ,""     ,""   ,""   ,""   ,""     ,""      ,""  ,""   ,""   ,""     ,""     ,""   ,"SA1",""  })



For i:=1 to Len(aRegs)
	vPERG := cPerg+SPACE(10-LEN(cPerg))
	If !DbSeek(vPERG+alltrim(aRegs[i,2]))
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			EndIf
		Next
		MsUnlock()
	EndIf
Next

DbSelectArea(_cAlias)

Return
