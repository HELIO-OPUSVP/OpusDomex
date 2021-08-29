#include "rwmake.ch"
#include "topconn.ch"

User Function DOMRFAT()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local   cDesc1      := "Este programa tem como objetivo imprimir relatorio "
Local   cDesc2      := "de acordo com os parametros informados pelo usuario."
Local   cDesc3      := ""
Local   cPict       := ""
Local   titulo      := "ON TIME DELIVERY"
Local   nLin        := 08
Local   Cabec1      := "Pedido  Item  Cliente                         Produto                                                     Fat.Acordado   Emissão NF    NF x Dt.Acordada    Nota Fiscal"
Local   Cabec2      := ""
Local   imprime     := .T.
Local   aOrd        := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "DOMRFAT"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "ONTIME  "
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "DOMRFAT"
Private cString     := "SC6"
Private Cgruporet   :=''
Private cGrupo      :=''
Private nCont       :=1
Private NX          :=0
Private NI          :=0

If MsgYesNo("Deseja executar o NOVO Relatório baseado na tabela SZY ? ","Atenção")
   U_DOMRFAT3()
   Return
EndIf


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



//---------Pedido com NF---------------------------------------------------------------------
//cQuery := " SELECT C6_NUM,C6_CLI,C6_LOJA,C6_PRODUTO,,C6_DATFAT,D2_EMISSAO,C6_NOTA, "
//cQuery += "        DATEDIFF(DD,,)  DTFATURxENTREGA,                                 "
//cQuery += "        DATEDIFF(DD,,D2_EMISSAO) NFxDTFATUR,                                      "
//cQuery += "        DATEDIFF(DD,,D2_EMISSAO)  NFxENTREGA                                       "
//cQuery += " FROM SC6010                                                                                  "
//cQuery += " INNER JOIN SC5010 ON C5_NUM=C6_NUM  AND SC5010.D_E_L_E_T_<>'*'                               "
//cQuery += " INNER JOIN SD2010 ON D2_DOC=C6_NOTA AND D2_CLIENTE=C6_CLI AND D2_LOJA=C6_LOJA AND D2_COD=C6_PRODUTO  AND SD2010.D_E_L_E_T_<>'*'   "
//cQuery += " WHERE    "     //C5_EMISSAO>='20130101'         "
//cQuery += "           C5_NUM      >='"+MV_PAR01+"' AND C5_NUM     <='"+MV_PAR02+"'    "
//cQuery += "       AND C5_CLIENTE  >='"+MV_PAR03+"' AND C5_CLIENTE <='"+MV_PAR04+"'    "
//cQuery += "       AND C6_PRODUTO  >='"+MV_PAR05+"' AND C6_PRODUTO <='"+MV_PAR06+"'    "
//cQuery += "       AND C5_EMISSAO  >='"+DTOS(MV_PAR07)+"' AND C5_EMISSAO <='"+DTOS(MV_PAR08)+"'    "
//cQuery += "       AND C5_TIPO ='N'               "
//cQuery += "       AND SC5010.D_E_L_E_T_<>'*'     "
//cQuery += "       AND SC6010.D_E_L_E_T_<>'*'     "
//cQuery += " union all                            "
//---------Pedido sem NF---------------------------------------------------------------------
//cQuery += " SELECT C6_NUM,C6_CLI,C6_LOJA,C6_PRODUTO,,,C6_DATFAT,'',C6_NOTA,      "
//cQuery += "        DATEDIFF(DD,,)  DTFATURxENTREGA,'',''                         "
//cQuery += " FROM SC6010                                                                             "
//cQuery += " INNER JOIN SC5010 ON C5_NUM=C6_NUM  AND SC5010.D_E_L_E_T_<>'*'                          "
//cQuery += " WHERE "//C5_EMISSAO>='20130101'                                                            "
//cQuery += "           C5_NUM      >='"+MV_PAR01+"' AND C5_NUM     <='"+MV_PAR02+"'    "
//cQuery += "       AND C5_CLIENTE  >='"+MV_PAR03+"' AND C5_CLIENTE <='"+MV_PAR04+"'    "
//cQuery += "       AND C6_PRODUTO  >='"+MV_PAR05+"' AND C6_PRODUTO <='"+MV_PAR06+"'    "
//cQuery += "       AND C5_EMISSAO  >='"+DTOS(MV_PAR07)+"' AND C5_EMISSAO <='"+DTOS(MV_PAR08)+"'    "
//cQuery += "       AND C5_TIPO ='N'                                                                  "
//cQuery += "       AND SC5010.D_E_L_E_T_<>'*'                                                        "
//cQuery += "       AND SC6010.D_E_L_E_T_<>'*'                                                        "
//cQuery += "       AND C6_NOTA=''                                                                    "
//cQuery += " ORDER BY DATEDIFF(DD,,D2_EMISSAO)          DESC                                "
//------------------------------------------------------------------------------


cQuery := " SELECT C6_NUM,C6_ITEM,C6_CLI,C6_LOJA,C6_PRODUTO,C6_XXDTDEF, SC6.R_E_C_N_O_, "
cQuery += "(SELECT TOP 1 D2_EMISSAO+D2_DOC FROM SD2010 WHERE D2_PEDIDO = SC6.C6_NUM AND D2_ITEMPV = SC6.C6_ITEM AND D_E_L_E_T_ = '' ORDER BY D2_EMISSAO, D2_DOC) AS EMISSNF "
cQuery += " FROM "+RetSqlName("SC6")+" SC6, "+RetSqlName("SC5")+" SC5 "
cQuery += " WHERE                                                                             "
cQuery += "           SC5.C5_NUM = SC6.C6_NUM AND SC5.C5_TIPO = 'N'                           "
cQuery += "       AND SC6.C6_NUM      >='"+MV_PAR01+"' AND SC6.C6_NUM     <='"+MV_PAR02+"'    "
cQuery += "       AND SC6.C6_CLI      >='"+MV_PAR03+"' AND SC6.C6_CLI     <='"+MV_PAR04+"'    "
cQuery += "       AND SC6.C6_PRODUTO  >='"+MV_PAR05+"' AND SC6.C6_PRODUTO <='"+MV_PAR06+"'    "
cQuery += "       AND SC6.C6_XXDTDEF  >='"+DTOS(MV_PAR07)+"' AND SC6.C6_XXDTDEF <='"+DTOS(MV_PAR08)+"'    "
cQuery += "       AND SC6.D_E_L_E_T_ = ''    "
cQuery += "ORDER BY SC6.C6_XXDTDEF, SC6.C6_NUM, SC6.C6_ITEM "

If Select("TR1") <> 0
	TR1->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "TR1"

TcSetField("TR1","C6_XXDTDEF","D", 8, 0)

TR1->( dbGoTop() )

Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)

nTotal  := 0
nTotal2 := 0
nAtend  := 0
nSEMNF  := 0

DO While TR1->(!EOF())
		
	@ nLin,000      pSay TR1->C6_NUM
	@ nLin,PCOL()+2 pSay TR1->C6_ITEM
	@ nLin,PCOL()+4 pSay TR1->C6_CLI+'/'+TR1->C6_LOJA+' '+SUBSTR(POSICIONE('SA1',1,xFILIAL('SA1')+TR1->C6_CLI+TR1->C6_LOJA,'A1_NREDUZ'),1,20)
	@ nLin,PCOL()+2 pSay TR1->C6_PRODUTO+' '+SUBSTR(POSICIONE('SB1',1,xFILIAL('SB1')+TR1->C6_PRODUTO,'B1_DESC'),1,40)
	//	@ nLin,PCOL()+2 pSay SUBSTR(TR1->,7,2)  +'/'+SUBSTR(TR1->,5,2)  +'/'+SUBSTR(TR1->,1,4)
	//	@ nLin,PCOL()+2 pSay SUBSTR(TR1-> ,7,2)  +'/'+SUBSTR(TR1-> ,5,2)  +'/'+SUBSTR(TR1-> ,1,4)
	//	@ nLin,PCOL()+2 pSay SUBSTR(TR1->C6_DATFAT ,7,2)  +'/'+SUBSTR(TR1->C6_DATFAT ,5,2)  +'/'+SUBSTR(TR1->C6_DATFAT ,1,4)
	
	@ nLin,PCOL()+4 pSay DtoC(TR1->C6_XXDTDEF)
	
	//@ nLin,PCOL()+2 pSay SUBSTR(TR1->D2_EMISSAO,7,2)  +'/'+SUBSTR(TR1->D2_EMISSAO,5,2)  +'/'+SUBSTR(TR1->D2_EMISSAO,1,4)
	@ nLin,PCOL()+7 pSay DtoC(StoD(Subs(TR1->EMISSNF,1,8)))
	
	
	//@ nLin,PCOL()+10 pSay Transform(TR1->DTFATURxENTREGA,"@E 999999")
	IF (StoD(Subs(TR1->EMISSNF,1,8)))<>stod(space(08))
		@ nLin,PCOL()+8 pSay Transform(StoD(Subs(TR1->EMISSNF,1,8)) - TR1->C6_XXDTDEF,"@E 999999")
	ELSE
		IF  TR1->C6_XXDTDEF >= DDATABASE
			@ nLin,PCOL()+8 pSay Transform(TR1->C6_XXDTDEF - TR1->C6_XXDTDEF,"@E 999999")
		ELSE
			@ nLin,PCOL()+8 pSay Transform(DDATABASE       - TR1->C6_XXDTDEF,"@E 999999")
		ENDIF
	ENDIF
	//@ nLin,PCOL()+10 pSay Transform(TR1->NFxENTREGA     ,"@E 999999")
	
	IF (StoD(Subs(TR1->EMISSNF,1,8)))==stod(space(08))   //SEM FATURAMENTO
		IF TR1->C6_XXDTDEF  < DDATABASE                //NÃO ATENDIDO PRAZO
			//nTotal++
			nSEMNF++
		ELSE
			nTotal2++                                   //FORA PRAZO FUTURO
		ENDIF
	ENDIF
	
	If (StoD(Subs(TR1->EMISSNF,1,8)) - TR1->C6_XXDTDEF) <= 0    .AND.  (StoD(Subs(TR1->EMISSNF,1,8)))<>stod(space(08))
		nAtend++
		nTotal++
	ELSE
		nTotal++
	EndIf
	
	If (StoD(Subs(TR1->EMISSNF,1,8)) - TR1->C6_XXDTDEF) > 0 
	 
	ENDIF 
	
	@ nLin,PCOL()+12 pSay Subs(TR1->EMISSNF,9)
	
	//	@ nLin,098 pSay TR1->Z6_CONTATO +'-'+ SUBSTR(POSICIONE('SU5',1,xFILIAL('SU5')+TR1->Z6_VEND,'U5_CONTAT'),1,20)
	//	@ nLin,126 pSay TR1->Z6_TIPO
	//	@ nLin,151 pSay SUBSTR(TR1->Z6_DATA,7,2)  +'/'+SUBSTR(TR1->Z6_DATA,5,2)  +'/'+SUBSTR(TR1->Z6_DATA,1,4)
	//	@ nLin,162 pSay SUBSTR(TR1->Z6_DTREAL,7,2)+'/'+SUBSTR(TR1->Z6_DTREAL,5,2)+'/'+SUBSTR(TR1->Z6_DTREAL,1,4)
	
	nLin:=nLin+1
	IF NLIN > 57
		Roda(0,"","G")
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 08
	ENDIF
	
	
	TR1->(DBSKIP())
ENDDO
TR1->(DBCLOSEAREA())

@nLin, 000 pSay __PrtThinLine()
nLin++
@nLin, 000 pSay "Resumo:  Total de itens pedido   : " + (Transform(nTotal        ,"@E 99,999,999")) + "   Itens a Vencer : " + (Transform(nTotal2,"@E 99,999,999")) + "    Itens Sem Nota Fiscal até a data : " + Alltrim(Transform(nSEMNF,"@E 99,999,999"))
nLin++
@nLin, 000 pSay "         Total itens até a data  : " + (Transform(nTotal-nTotal2,"@E 99,999,999")) + "   Itens atendido : " + (Transform(nAtend ,"@E 99,999,999")) + "    O.T.D.                           : " + Transform((nAtend/(nTotal-nTotal2))*100,"@E 999.99")+"%"
nLin++
@nLin, 000 pSay __PrtThinLine()

Roda(0,"","G")

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

