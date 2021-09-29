#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDOMRFAT3  บ       ณMarco Aurelio-OPUS  บ Data ณ  10-05-19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ  
ฑฑบProg.ori  ณDOMRFAT2  บ       ณMicrosiga           บ Data ณ  04-17-19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio de OTD - Baseado no SZY                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DOMRFAT3()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local   cDesc1      := "Este programa tem como objetivo imprimir relatorio "
Local   cDesc2      := "de acordo com os parametros informados pelo usuario."
Local   cDesc3      := "considerando a tabela SZY."
Local   cPict       := ""
Local   titulo      := "ON TIME DELIVERY (SZY)"
Local   nLin        := 08
Local   Cabec1      := "Pedido  Item  Cliente                         Produto                                                     Fat.Acordado   Emissใo NF    NF x Dt.Acordada    Nota Fiscal"
Local   Cabec2      := ""
Local   imprime     := .T.
Local   aOrd        := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "DOMRFAT3"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "ONTIME  "
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "DOMRFAT3"
Private cString     := "SZY"
Private Cgruporet   :=''
Private cGrupo      :=''
Private nCont       :=1
Private NX          :=0
Private NI          :=0

pergunte(cPerg,.F.)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta a interface padrao com o usuario...                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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


cQuery := "  SELECT ZY_PEDIDO,ZY_ITEM,ZY_SEQ,C5_CLIENTE,C5_LOJACLI,ZY_PRODUTO,ZY_DTOTD, SZY.* , "
cQuery += "(SELECT TOP 1 D2_EMISSAO+D2_DOC FROM " + RetSqlName("SD2")+" SD2 WHERE D2_PEDIDO = SZY.ZY_PEDIDO AND D2_ITEMPV = SZY.ZY_ITEM AND SD2.D_E_L_E_T_ = '' ) AS EMISSNF "
cQuery += " FROM " + RetSqlName("SC5")+" SC5 LEFT JOIN  " + RetSqlName("SZY")+" SZY "
cQuery += "                                     ON  SC5.C5_NUM =SZY.ZY_PEDIDO "
cQuery += " WHERE "                                                                            
cQuery += "           SC5.C5_NUM = SZY.ZY_PEDIDO AND SC5.C5_TIPO = 'N'  "                         
cQuery += "       AND SZY.ZY_PEDIDO  BETWEEN  '"+MV_PAR01+"' AND '"+MV_PAR02+"'  "   
cQuery += "       AND SC5.C5_CLIENTE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'  "  
cQuery += "       AND SZY.ZY_PRODUTO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "   
cQuery += "       AND SZY.ZY_DTOTD   BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"'   "  
cQuery += "       AND SZY.ZY_BLQ <> 'R'   "			// Desconsidera Itens com Residuos Eliminados  
cQuery += "       AND SZY.ZY_FILIAL='"+xFILIAL('SZY')+"' AND SC5.C5_FILIAL='"+xFILIAL('SC5')+"'  "
cQuery += "       AND SC5.D_E_L_E_T_ = ''    "  
cQuery += "       AND SZY.D_E_L_E_T_ = ''    "
//cQuery += "	   --AND C6_XXDTDEF <> ZY_DTOTD "
cQuery += "ORDER BY SZY.ZY_DTOTD,SZY.ZY_PEDIDO,SZY.ZY_ITEM "  

If Select("TR1") <> 0
	TR1->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "TR1"

TcSetField("TR1","ZY_DTOTD","D", 8, 0)

TR1->( dbGoTop() )

Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)

nTotal  := 0
nTotal2 := 0
nAtend  := 0
nSEMNF  := 0

DO While TR1->(!EOF())
		
	@ nLin,000      pSay TR1->ZY_PEDIDO
	@ nLin,PCOL()+2 pSay TR1->ZY_ITEM
	@ nLin,PCOL()+4 pSay TR1->C5_CLIENTE+'/'+TR1->C5_LOJACLI+' '+SUBSTR(POSICIONE('SA1',1,xFILIAL('SA1')+TR1->C5_CLIENTE+TR1->C5_LOJACLI,'A1_NREDUZ'),1,20)
	@ nLin,PCOL()+2 pSay TR1->ZY_PRODUTO+' '+SUBSTR(POSICIONE('SB1',1,xFILIAL('SB1')+TR1->ZY_PRODUTO,'B1_DESC'),1,40)
	@ nLin,PCOL()+4 pSay DtoC(TR1->ZY_DTOTD)
	@ nLin,PCOL()+7 pSay DtoC(StoD(Subs(TR1->EMISSNF,1,8)))

	IF (StoD(Subs(TR1->EMISSNF,1,8)))<>stod(space(08))
		@ nLin,PCOL()+8 pSay Transform(StoD(Subs(TR1->EMISSNF,1,8)) - TR1->ZY_DTOTD,"@E 999999")
	ELSE
		IF  TR1->ZY_DTOTD >= DDATABASE
			@ nLin,PCOL()+8 pSay Transform(TR1->ZY_DTOTD - TR1->ZY_DTOTD,"@E 999999")
		ELSE
			@ nLin,PCOL()+8 pSay Transform(DDATABASE     - TR1->ZY_DTOTD,"@E 999999")
		ENDIF
	ENDIF
	//@ nLin,PCOL()+10 pSay Transform(TR1->NFxENTREGA     ,"@E 999999")
	
	IF (StoD(Subs(TR1->EMISSNF,1,8)))==stod(space(08))   //SEM FATURAMENTO
		IF TR1->ZY_DTOTD  < DDATABASE                	//NรO ATENDIDO PRAZO
			//nTotal++
			nSEMNF++
		ELSE
			nTotal2++                                   //FORA PRAZO FUTURO
		ENDIF
	ENDIF
	
	If (StoD(Subs(TR1->EMISSNF,1,8)) - TR1->ZY_DTOTD) <= 0    .AND.  (StoD(Subs(TR1->EMISSNF,1,8)))<>stod(space(08))
		nAtend++
		nTotal++
	ELSE
		nTotal++
	EndIf
	
	If (StoD(Subs(TR1->EMISSNF,1,8)) - TR1->ZY_DTOTD) > 0 
	 
	ENDIF 
	
	@ nLin,PCOL()+12 pSay Subs(TR1->EMISSNF,9)      
	
	// MAURESI - 04/09/2019
	@ nLin,PCOL()+12 pSay TR1->ZY_SEQ
	@ nLin,PCOL()+12 pSay TR1->ZY_BLQ		
	
	
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
@nLin, 000 pSay "Resumo:  Total de itens pedido   : " + (Transform(nTotal        ,"@E 99,999,999")) + "   Itens a Vencer : " + (Transform(nTotal2,"@E 99,999,999")) + "    Itens Sem Nota Fiscal at้ a data : " + Alltrim(Transform(nSEMNF,"@E 99,999,999"))
nLin++
@nLin, 000 pSay "         Total itens at้ a data  : " + (Transform(nTotal-nTotal2,"@E 99,999,999")) + "   Itens atendido : " + (Transform(nAtend ,"@E 99,999,999")) + "    O.T.D.                           : " + Transform((nAtend/(nTotal-nTotal2))*100,"@E 999.99")+"%"
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

