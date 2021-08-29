#INCLUDE "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DOMCONF    º Autor ³ Mauricio L.Souza   Data ³  10/09/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Conferencia do Inventário DOMEX                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TOTVS 11                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function DOMCONF()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Conferencia do Inventário DOMEX"
Local cPict          := ""
Local titulo         := "CONF - Conferencia do Inventário"
Local nLin           := 8
//                               10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170        180       190
//                     012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789901234567890123456789012345
Local Cabec1       := "Emissao    Produto         Descricao                       Movimento         Quantidade         Valor    Diferenca        "
Local Cabec2       := "                                                                                                                          "
//Emissao    Produto         Descricao                                         Quantidade  Local        Endereço           "
//                     00/00/0000 XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999-REQUISICAO  9,999,999.99  9,999,999.99  9,999,999.99
Local imprime        := .T.
//Local aOrd := {"Por Codigo","Por Nome"}
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "DOMCONF"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "DOMCONF"
Private cCLI         := Space(08)
//Private cBANCO       :=''

Private _nTOTVALOR   :=0
Private _nTOTSALDO   :=0
Private _nTOTVGER    :=0
Private _nTOTSGER    :=0
Private _cBCO        :=SPACE(10)

Private cString      := "SD3"

pergunte("DOMCONF",.F.)
dbSelectArea("SD3")
dbSetOrder(1)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"DOMCONF",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  24/07/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
nOrdem := aReturn[8]

dbSelectArea(cString)
dbSetOrder(1)

//-----------------------------------------------------------------------------------------------------------------------------
cQuery := " SELECT D3_EMISSAO,D3_COD,B1_DESC,D3_TM,SUM(D3_QUANT) QUANT,SUM(D3_CUSTO1) CUSTO1 "
cQuery += " FROM SD3010 D3 ,SB1010 B1 "
cQuery += " WHERE B1_COD=D3_COD AND "
cQuery += " D3_DOC='INVENT' AND "
cQuery += " D3_EMISSAO >='"+DTOS(MV_PAR01)+"' AND D3_EMISSAO <='"+DTOS(MV_PAR02)+"' AND "
cQuery += " D3_COD     >='"+MV_PAR03+"'       AND D3_COD     <='"+MV_PAR04+"'       AND "
cQuery += " D3.D_E_L_E_T_='' AND B1.D_E_L_E_T_=''  AND D3_ESTORNO=''  "
cQuery += " GROUP BY D3_EMISSAO,D3_COD,B1_DESC,D3_TM "
cQuery += " ORDER BY D3_COD,D3_EMISSAO,D3_TM "
//-----------------------------------------------------------------------------------------------------------------------------

TCQUERY cQuery NEW ALIAS "TRB"

SetRegua(RecCount())

Dbselectarea("TRB")
dbGoTop()
cCOD  := TRB->D3_COD
nDIV  := 0
nTOT  := 0
cPERIODO :=' De '+DTOC(MV_PAR01) +'Ate '+ DTOC(MV_PAR02)
Cabec(Titulo+cPERIODO,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
nLin := 8

lDif := .F.
IF MV_PAR05==2
	If MsgYesNo("SINTETICO, Só com Diferença ?")
		lDif := .T.
	endif
endif


While !TRB->(EOF())
	
	IF MV_PAR05==1
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		If nLin > 55
			roda(0,"",TAMANHO)
			Cabec(Titulo+cPERIODO,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		@ nLin,000 psay SUBSTR(TRB->D3_EMISSAO,7,2)+'/'+SUBSTR(TRB->D3_EMISSAO,5,2)+'/'+SUBSTR(TRB->D3_EMISSAO,1,4)
		@ nLin,011 psay TRB->D3_COD
		@ nLin,027 psay substr(TRB->B1_DESC,1,30)
		IF ALLTRIM(TRB->D3_TM)=='499'
			cTM:='-Devolucao'
		else
			cTM:='-Requisicao'
		ENDIF
		@ nLin,059 psay TRB->D3_TM+cTM
		@ nLin,075 psay TRANSFORM(TRB->QUANT  ,"@E 9,999,999.99")
		@ nLin,089 psay TRANSFORM(TRB->CUSTO1 ,"@E 9,999,999.99")
		IF ALLTRIM(TRB->D3_TM)=='499'
			nDIV := nDIV+TRB->CUSTO1
			nTOT := nTOT+TRB->CUSTO1
		ENDIF
		IF ALLTRIM(TRB->D3_TM)=='999'
			nDIV := nDIV-TRB->CUSTO1
			nTOT := nTOT-TRB->CUSTO1
		ENDIF
		TRB->(dbSkip())
		IF (TRB->D3_COD)<>cCOD
			@ nLin,103 psay TRANSFORM(nDIV   ,"@E 9,999,999.99")
			nDIV  :=0
			cCOD  := TRB->D3_COD
			If nLin > 55
				roda(0,"",Tamanho)
				Cabec(Titulo+cPERIODO,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
		End
		nLin++
	ENDIF
	
	
	
	
	IF MV_PAR05==2
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		If nLin > 55
			roda(0,"",TAMANHO)
			Cabec(Titulo+cPERIODO,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		//@ nLin,000 psay SUBSTR(TRB->D3_EMISSAO,7,2)+'/'+SUBSTR(TRB->D3_EMISSAO,5,2)+'/'+SUBSTR(TRB->D3_EMISSAO,1,4)
		//@ nLin,011 psay TRB->D3_COD
		//@ nLin,027 psay substr(TRB->B1_DESC,1,30)
		//IF ALLTRIM(TRB->D3_TM)=='499'
		//	cTM:='-Devolucao'
		//else
		//	cTM:='-Requisicao'
		//ENDIF
		//@ nLin,059 psay TRB->D3_TM+cTM
		//@ nLin,075 psay TRANSFORM(TRB->QUANT  ,"@E 9,999,999.99")
		//@ nLin,089 psay TRANSFORM(TRB->CUSTO1 ,"@E 9,999,999.99")
		IF ALLTRIM(TRB->D3_TM)=='499'
			nDIV := nDIV+TRB->CUSTO1
			nTOT := nTOT+TRB->CUSTO1
		ENDIF
		IF ALLTRIM(TRB->D3_TM)=='999'
			nDIV := nDIV-TRB->CUSTO1
			nTOT := nTOT-TRB->CUSTO1
		ENDIF
		CDESC:=TRB->B1_DESC
		TRB->(dbSkip())
		IF (TRB->D3_COD)<>cCOD
			IF lDif==.F. .OR. nDIV<>0
				@ nLin,000 psay ''
				@ nLin,011 psay cCOD
				@ nLin,027 psay substr(CDESC,1,30)
				@ nLin,103 psay TRANSFORM(nDIV   ,"@E 9,999,999.99")
				nLin++
			ENDIF
			nDIV  :=0
			cCOD  := TRB->D3_COD
			If nLin > 55
				roda(0,"",Tamanho)
				Cabec(Titulo+cPERIODO,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
		End
	ENDIF
	
End

nLin++
@ nLin,000 psay __prtthinline()
nLin++
@ nLin,000 psay 'Total Geral '
@ nLin,103 psay TRANSFORM(nTOT   ,"@E 9,999,999.99")
nLin++
@ nLin,000 psay __prtthinline()
nLin++

cQuery2 := " select B7_COD,B7_LOCAL,B7_DATA,B7_DOC,SUM(B7_QUANT) B7_QUANT,B7_LOCALIZ "
cQuery2 += " FROM SB7010 WHERE  D_E_L_E_T_<>'*' AND"
cQuery2 += " B7_DATA >='"+DTOS(MV_PAR01)+"' AND B7_DATA <='"+DTOS(MV_PAR02)+"' AND "
cQuery2 += " B7_COD  >='"+MV_PAR03+"'       AND B7_COD  <='"+MV_PAR04+"'       AND "
cQuery2 += " B7_COD NOT IN  "
cQuery2 += " (SELECT D3_COD FROM SD3010 WHERE D3_COD=B7_COD AND D3_EMISSAO=B7_DATA AND D3_LOCALIZ=B7_LOCALIZ "
cQuery2 += " AND D3_DOC ='INVENT' AND D_E_L_E_T_=''   AND D3_ESTORNO=''  ) "
cQuery2 += " GROUP BY B7_COD,B7_LOCAL,B7_DATA,B7_DOC,B7_LOCALIZ "
cQuery2 += " ORDER BY B7_COD,B7_LOCAL,B7_DATA,B7_DOC,B7_LOCALIZ "

TCQUERY cQuery2 NEW ALIAS "TR2"

TR2->(Dbselectarea("TR2"))
TR2->(dbGoTop())

//---------------------------------------------------------------------------------------------------------
roda(0,"",Tamanho)
Cabec(Titulo+cPERIODO,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
nLin := 8
@ nLin,000 psay "SEM MOVIMENTO"
nLin++

While !TR2->(EOF())
	nLin++
	@ nLin,000 psay SUBSTR(TR2->B7_DATA,7,2)+'/'+SUBSTR(TR2->B7_DATA,5,2)+'/'+SUBSTR(TR2->B7_DATA,1,4)
	@ nLin,011 psay TR2->B7_COD
	@ nLin,027 psay substr(POSICIONE('SB1',1,xFILIAL('SB1')+TR2->B7_COD,'B1_DESC'),1,30)
	@ nLin,059 psay ' '
	@ nLin,075 psay TRANSFORM(TR2->B7_QUANT  ,"@E 9,999,999.99")
	@ nLin,089 psay TR2->B7_LOCAL     //TRANSFORM(TRB->CUSTO1 ,"@E 9,999,999.99")
	@ nLin,103 psay TR2->B7_LOCALIZ   //TRANSFORM(nDIV   ,"@E 9,999,999.99")
	If nLin > 55
		roda(0,"",Tamanho)
		Cabec(Titulo+cPERIODO,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	TR2->(dbSkip())
END
//---------------------------------------------------------------------------------------------------------
roda(0,"",Tamanho)

SET DEVICE TO SCREEN


If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

TRB->(Dbclosearea())
TR2->(Dbclosearea())

Return
