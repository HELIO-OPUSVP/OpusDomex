#include "print.ch"
#include "font.ch"
#include "colors.ch"
#include "Protheus.ch"
#include "Topconn.ch"
#include "Rwmake.ch"

#INCLUDE "RPCPR01.CH"

#xcommand @ <nLinha>, <nColuna> PSAY <cTexto>;
=> oprn:say(<nLinha>*50+100, <nColuna>*30/*-<nColuna>/2*/+40, transform(<cTexto>, ''), ofnt,,;
CLR_BLACK)

#xcommand @ <nLinha>, <nColuna> PSAY <cTexto> FONT <oFonte>;
=> oprn:say(<nLinha>*50+100, <nColuna>*25/*-<nColuna>/2*/+40, transform(<cTexto>, ''), <oFonte>,,;
CLR_BLACK)

#xcommand @ <nLinha>, <nColuna> PSAY <cTexto> PICTURE <cPicture>;
=> oprn:say(<nLinha>*50+100, <nColuna>*30/*-<nColuna>/2*/+40, transform(<cTexto>, <cPicture>), ofnt,,;
CLR_BLACK)

#xcommand @ <nLinha>, <nColuna> PSAY <cTexto> PICTURE <cPicture> FONT <oFonte>;
=> oprn:say(<nLinha>*50+100, <nColuna>*25/*-<nColuna>/2*/+40, transform(<cTexto>, <cPicture>), <oFonte>,,;
CLR_BLACK)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RESTR05  ³ Autor ³ Michel A. Sander      ³ Data ³ 25.05.17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de separacao de embalagens na expedicao          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ MATR820(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function RESTR05()

Local titulo  := "Separacao de Embalagens" 

Local cString := "XD1"
Local wnrel   := "RESTR05"
Local tamanho := "G"
Local resp
Local cQry
Local cOP1
Local cOP2

Private cPerg    :="MTR820"
Private lItemNeg := .F.
Private plinha   := .t.
Private cContPg  := ""
Private lBeginSQL:= .F.

//RPCSetType(3)
//aAbreTab := {}
//RpcSetEnv("01","01",,,,,aAbreTab)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
resp := pergunte("RESTR05",.T.)

DBSELECTAREA("SC2")
DBGOTOP()
DBSETORDER(1)

print oprn preview
define font ofnt name "Courier New" /*bold*/ size 0,12 of oprn
define font ofnt2 name "Courier New" bold size 0,10 of oprn
define font ofnt3 name "Courier New" bold size 0,12 of oprn

RptStatus({|lEnd| R820Imp(@lEnd,wnRel,titulo,tamanho)},titulo)

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ R820Imp  ³ Autor ³ Waldemiro L. Lustosa  ³ Data ³ 13.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relat¢rio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function R820Imp(lEnd,wnRel,titulo,tamanho)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local CbCont,cabec1,cabec2
Local cQtd
Local limite     := 100
Local nQuant     := 1
Local nomeprog   := "RESTR05"
Local nTipo      := 18
Local cProduto   := SPACE(LEN(SC2->C2_PRODUTO))
Local cIndSC2    := CriaTrab(NIL,.F.), nIndSC2

Private aArray   := {}
Private li       := 00

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(0)
cbcont   := 0
m_pag    := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os Cabecalhos                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cabec1 := ""
cabec2 := ""
aGrupos := {}

dbSelectArea("SB1")
dbSetOrder(1)
dbSelectArea("SA1")
dbSetOrder(1)
dbSelectArea("SC5")
dbSetOrder(1)      
dbSelectArea("SC6")
dbSetOrder(1)
dbSelectArea("SZY")
dbSetOrder(1)

If SC5->(dbSeek(xFilial()+mv_par01))

	SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE))
	
	If SZY->(dbSeek(xFilial()+mv_par01))
		
		While SZY->(!EOF()) .And. SZY->ZY_FILIAL+SZY->ZY_PEDIDO == SC5->C5_FILIAL+SC5->C5_NUM
			
			If SZY->ZY_PRVFAT <> mv_par02
				SZY->(dbSkip())
				Loop
			EndIf
			
			SB1->(dbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
			
			If aScan(aGrupos,SB1->B1_GRUPO) == 0
				AADD(aGrupos,SB1->B1_GRUPO)
			EndIf
			
			SZY->(dbSkip())
			
		EndDo
		
	EndIf
	
EndIf
             
cAux := "("
For x := 1 to Len(aGrupos)
    cAux += "'"+aGrupos[x]+"',"
Next
cIn := SUBSTR(cAux,1,Len(cAux)-1)+")"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calcula a quantidade de Caixas Nivel 2			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cAliasSZY   := GetNextAlias()
cWhere      := "%G1_XXEMBNI = '2' AND "+"ZY_PEDIDO ='"+mv_par01+"'%"
//cWhereSZY   := "%ZY_PRVFAT ='"+Dtos(mv_par02)+"' AND ZY_NOTA = ''%"
cWhereSZY   := "%ZY_PRVFAT ='"+Dtos(mv_par02)+"'%"  // PROVISORIO PARA TESTES

If lBeginSQL
	BeginSQL Alias cAliasSZY
		SELECT ZY_PEDIDO, ZY_ITEM, ZY_PRODUTO, ZY_SEQ, ZY_PRVFAT, G1_QUANT, (ZY_QUANT-ZY_QUJE) ZY_QUANT, (ZY_QUANT*G1_QUANT) ZY_VOLUMES,
				CASE    
			      WHEN (ZY_QUANT*G1_QUANT) <> CAST((ZY_QUANT*G1_QUANT) as INT) THEN CAST(((ZY_QUANT*G1_QUANT)+1) as INT) 
			      WHEN (ZY_QUANT*G1_QUANT)  = CAST((ZY_QUANT*G1_QUANT) as INT) THEN CAST((ZY_QUANT*G1_QUANT) as INT)  
				END ZY_VOLUME_FINAL   
		From %table:SZY% SZY (NOLOCK)
		JOIN %table:SG1% SG1 (NOLOCK)
		ON G1_FILIAL = '' AND G1_COD = ZY_PRODUTO
		JOIN %table:SB1% SB1 (NOLOCK)
		ON B1_FILIAL = '' AND B1_COD = ZY_PRODUTO
		WHERE SG1.%NotDel%
		And SZY.%NotDel%
		And SB1.%NotDel%
		And %Exp:cWhere%
		And %Exp:cWhereSZY%
		ORDER BY G1_COD
	EndSQL
Else
	cQuery := "SELECT ZY_PEDIDO, ZY_ITEM, ZY_PRODUTO, ZY_SEQ, ZY_PRVFAT, G1_QUANT, (ZY_QUANT-ZY_QUJE) ZY_QUANT, (ZY_QUANT*G1_QUANT) ZY_VOLUMES, " + Chr(13)
	cQuery += "CASE "																																			+ Chr(13)    
	cQuery += "   WHEN (ZY_QUANT*G1_QUANT) <> CAST((ZY_QUANT*G1_QUANT) as INT) THEN CAST(((ZY_QUANT*G1_QUANT)+1) as INT) " 	+ Chr(13)
	cQuery += "   WHEN (ZY_QUANT*G1_QUANT)  = CAST((ZY_QUANT*G1_QUANT) as INT) THEN CAST((ZY_QUANT*G1_QUANT) as INT)  " 		+ Chr(13)
	cQuery += "END ZY_VOLUME_FINAL " + Chr(13)  
	cQuery += "			From SZY010 SZY (NOLOCK) "                                                      + Chr(13)
	cQuery += "			JOIN SG1010 SG1 (NOLOCK) "                                                      + Chr(13)
	cQuery += "			ON G1_FILIAL = '"+xFilial("SG1")+"' AND G1_COD = ZY_PRODUTO   "                 + Chr(13)
	cQuery += "			JOIN SB1010 SB1 (NOLOCK) "                                                      + Chr(13)
	cQuery += "			ON B1_COD = ZY_PRODUTO   "                                                      + Chr(13)
	cQuery += "			WHERE SG1.D_E_L_E_T_ = '' "                                                     + Chr(13)
	cQuery += "					And SZY.D_E_L_E_T_ = '' "                                                 + Chr(13)
	cQuery += "					And SB1.D_E_L_E_T_ = '' "                                                 + Chr(13)
	cQuery += "					And " + StrTran(cWhere    ,'%','')                                        + Chr(13)
	cQuery += "					And " + StrTran(cWhereSZY ,'%','')                                        + Chr(13)
	cQuery += "					ORDER BY G1_COD "                                                         + Chr(13)

	TCQUERY cQuery new alias &(cAliasSZY)
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicia pagina de impressao							 	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Page

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime cabecalho principal do relatorio		 	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPag := 1
@Li,00 Psay REPLICATE(CHR(151),170)
Li++
@Li,01 Psay "ROSENBERGER DOMEX TELECOM    SEPARAÇÃO DE MATERIAL PARA EXPEDICAO   " + DTOC(DATE())+ " Pag.: "+ALLTRIM(STR(NPAG)) Font ofnt3
LI++
@Li,00 Psay REPLICATE(CHR(151),170)
Li++
@ LI, 00 PSAY "Numero do Pedido: "+mv_par01+" - "+SA1->A1_NOME
Li++
@ LI, 00 PSAY "Prev.Faturamento: "+DTOC(mv_par02)
li++
@Li,00 Psay REPLICATE(CHR(151),170)
Li++    
@LI, 07 PSAY "I T E N S  D O  P E D I D O" Font oFnt3       
@LI, 50 PSAY "V O L U M E S  C A L C U L A D O S" Font ofnt3
Li++
@ LI, 00 PSAY "Item"
@ LI, 05 PSAY "Produto"
@ LI, 27 PSAY "Quant."
@ LI, 35 PSAY "Calculado"
@ LI, 44 PSAY "Aproximado"
@ LI, 55 PSAY "Disponivel"
@ LI, 65 PSAY "Separado" 
@ LI, 73 PSAY "Diverg."
LI++                      
@Li,00 Psay REPLICATE(CHR(151),170)
Li++    

(cAliasSZY)->( dbGoTop() )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Acumuladores											 	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nSomaVol  := 0
nSomaDisp := 0
nSomaSep  := 0
nSomaFin  := 0
aDiverge  := {}
nVolFin   := 0

Do While (cAliasSZY)->(!Eof())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Imprime calculo de embalagens						 	  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nVolInt    := Int((cAliasSZY)->ZY_VOLUMES)
	nResto     := (cAliasSZY)->ZY_VOLUMES - nVolInt
	If (cAliasSZY)->ZY_VOLUMES <> Int((cAliasSZY)->ZY_VOLUMES)
		If nResto >= 0.0001 .And. nResto <= 0.0009
		   nVolFin := nVolInt
		Else
		   nVolFin := ( nVolInt + 1) 
		EndIf   
	Else
	   nVolFin := nVolInt
	EndIf
	
	@ LI, 00 PSAY (cAliasSZY)->ZY_ITEM
	@ LI, 05 PSAY (cAliasSZY)->ZY_PRODUTO
	@ LI, 25 PSAY TransForm((cAliasSZY)->ZY_QUANT,"@E 99,999.99")
	@ LI, 35 PSAY TransForm((cAliasSZY)->ZY_VOLUMES,"@E 999,999.9999")
	@ LI, 45 PSAY TransForm(nVolFin,"@E 99,999.99")
	
   SC6->(dbSetOrder(1))
	SC6->( dbSeek( xFilial() + (cAliasSZY)->ZY_PEDIDO + (cAliasSZY)->ZY_ITEM ) )
	nDisponiveis := U_Disp2Emb(Alltrim(SC6->C6_NUMOP+SC6->C6_ITEMOP),'2','')
	nSeparadas 	 := U_Separa2Emb((cAliasSZY)->ZY_PEDIDO, (cAliasSZY)->ZY_ITEM,'2')
    If nDisponiveis > 0 .Or. ( ( nDisponiveis + nSeparadas ) <> nVolFin ) //.And. ( nDisponiveis < nSeparadas )
		If aScan(aDiverge,SC6->C6_NUMOP+SC6->C6_ITEMOP) == 0
			AADD(aDiverge,SC6->C6_NUMOP+SC6->C6_ITEMOP)
		EndIf
	Endif                                    

   nSomaDisp    += nDisponiveis
   nSomaSep     += nSeparadas
   nSomaVol 	+= (cAliasSZY)->ZY_VOLUMES
   nSomaFin     += nVolFin

   
	@ LI, 55 PSAY TransForm(nDisponiveis,"@E 999,999.99")
	@ LI, 63 PSAY TransForm(nSeparadas  ,"@E 999,999.99")
	@ LI, 73 PSAY If( ( nDisponiveis + nSeparadas ) <> nVolFin .And. ( nDisponiveis <> 0 .Or. nSeparadas <> 0 ), "*", "")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica salto de pagina							 	  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	LI++
	If Li >= 55
		endpage
	   page
	   LI:=0
	   nPag++
		@Li,00 Psay REPLICATE(CHR(151),170)
		Li++
		@Li,01 Psay "ROSENBERGER DOMEX TELECOM    SEPARAÇÃO DE MATERIAL PARA EXPEDICAO   " + DTOC(DATE())+ " Pag.: "+ALLTRIM(STR(NPAG)) Font ofnt3
		LI++
		@Li,00 Psay REPLICATE(CHR(151),170)
		Li++
		@ LI, 00 PSAY "Numero do Pedido: "+mv_par01+" - "+SA1->A1_NOME
		Li++
		@ LI, 00 PSAY "Prev.Faturamento: "+DTOC(mv_par02)
		li++
		@Li,00 Psay REPLICATE(CHR(151),170)
		Li++    
	EndIf
	
	(cAliasSZY)->(dbSkip())

EndDo
           
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime total de volumes calculados				 	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@Li,00 Psay REPLICATE(CHR(151),170)
Li++    
@ LI, 25 PSAY "T O T A I S" Font oFnt3
@ LI, 46 PSAY TransForm(nSomaFin ,"@E 99,999.99")
@ LI, 56 PSAY TransForm(nSomaDisp,"@E 99,999.99")
@ LI, 66 PSAY TransForm(nSomaSep ,"@E 99,999.99")
LI++
@Li,00 Psay REPLICATE(CHR(151),170)
Li++    
If Li >= 55
	endpage
   page
   LI:=0
   nPag++
	@Li,00 Psay REPLICATE(CHR(151),170)
	Li++
	@Li,01 Psay "ROSENBERGER DOMEX TELECOM    SEPARAÇÃO DE MATERIAL PARA EXPEDICAO   " + DTOC(DATE())+ " Pag.: "+ALLTRIM(STR(NPAG)) Font ofnt3
	LI++
	@Li,00 Psay REPLICATE(CHR(151),170)
	Li++
	@ LI, 00 PSAY "Numero do Pedido: "+mv_par01+" - "+SA1->A1_NOME
	Li++
	@ LI, 00 PSAY "Prev.Faturamento: "+DTOC(mv_par02)
	li++
	@Li,00 Psay REPLICATE(CHR(151),170)
	Li++    
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calcula a quantidade de volumes finais			 	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cAliasXD1   := GetNextAlias()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se utiliza etiquetas canceladas		 	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par03==1
	cWhere      := "%SUBSTRING(XD1_PVSEP,1,6)='"+mv_par01+"' AND XD1_ULTNIV='S'%"
Else
	cWhere      := "%SUBSTRING(XD1_PVSEP,1,6)='"+mv_par01+"' AND XD1_ULTNIV='S' AND XD1_OCORRE <> '5'%"
EndIf

If lBeginSQL
	BeginSQL Alias cAliasXD1
		SELECT * FROM %Table:XD1% (NOLOCK) XD1 WHERE XD1.%NotDel% AND %Exp:cWhere% ORDER BY XD1_VOLUME
	EndSQL
Else
   cSQL := "SELECT * FROM "+RetSqlName("XD1")+" (NOLOCK) XD1 WHERE D_E_L_E_T_ = '' AND "
	cSQL += StrTran(cWhere,'%','') + " ORDER BY XD1_VOLUME" 
	TCQUERY cSQL NEW ALIAS &(cAliasXD1)
EndIf

lCabecXD1 := .T.     
nSomaXD2  := 0
Do While (cAliasXD1)->(!Eof())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica salto de pagina							 	  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Li >= 55
		endpage
	   page
	   LI:=0
	   nPag++
		@Li,00 Psay REPLICATE(CHR(151),170)
		Li++
		@Li,01 Psay "ROSENBERGER DOMEX TELECOM    SEPARAÇÃO DE MATERIAL PARA EXPEDICAO   " + DTOC(DATE())+ " Pag.: "+ALLTRIM(STR(NPAG)) Font ofnt3
		LI++
		@Li,00 Psay REPLICATE(CHR(151),170)
		Li++
		@ LI, 00 PSAY "Numero do Pedido: "+mv_par01+" - "+SA1->A1_NOME
		Li++
		@ LI, 00 PSAY "Prev.Faturamento: "+DTOC(mv_par02)
		li++
		@Li,00 Psay REPLICATE(CHR(151),170)
		Li++       
		lCabecXD1 := .F.		
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Imprime cabecalho										 	  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If lCabecXD1
		@ LI, 30 PSAY "E M B A L A G E M  F I N A L" Font oFnt3
      LI++
      @ LI, 00 PSAY "Numero da Etiqueta"
      @ LI, 22 PSAY "Caixas"
      @ LI, 29 PSAY "Quantidade"
      @ LI, 40 PSAY "Volume"
      @ LI, 49 PSAY "Peso"
      @ LI, 55 PSAY "Nota Fiscal"
      @ LI, 65 PSAY "Serie"
      LI++
		@Li,00 Psay REPLICATE(CHR(151),170)
		Li++    
      lCabecXD1 := .F.
   EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Busca os totais de caixas dentro da embalagem N3  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   nTotVol := 0
   XD2->(dbSetOrder(1))
   If XD2->(dbSeek(xFilial()+(cAliasXD1)->XD1_XXPECA))
      Do While XD2->(!Eof()) .And. XD2->XD2_XXPECA == (cAliasXD1)->XD1_XXPECA
         nTotVol++
         XD2->(dbSkip())
      EndDo
   EndIf
   
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Imprime embalagens finais							 	  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   @ LI, 00 PSAY (cAliasXD1)->XD1_XXPECA
   @ LI, 20 PSAY TransForm(nTotVol,"@E 99,999.99")
   @ LI, 30 PSAY TransForm((cAliasXD1)->XD1_QTDORI,"@E 99,999.99")
   @ LI, 42 PSAY (cAliasXD1)->XD1_VOLUME
   @ LI, 45 PSAY TransForm((cAliasXD1)->XD1_PESOB,"@E 99,999.99")
   @ LI, 55 PSAY (cAliasXD1)->XD1_ZYNOTA
   @ LI, 65 PSAY (cAliasXD1)->XD1_ZYSERI
   LI++
   nSomaXD2 += nTotVol
   (cAliasXD1)->(dbSkip())

EndDo

@ Li,00 PSAY REPLICATE(CHR(151),170)
LI++                 
@ LI,10 PSAY "T O T A L" Font oFnt3
@ LI,20 PSAY TransForm(nSomaXD2,"@E 99,999.99")
LI++
@ Li,00 PSAY REPLICATE(CHR(151),170)
LI++                 

(cAliasXD1)->(dbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calcula a quantidade divergente					 	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aDiverge) > 0

	cAux := "("
	For x := 1 to Len(aDiverge)
	    cAux += "'"+aDiverge[x]+"',"
	Next
	cIn := SUBSTR(cAux,1,Len(cAux)-1)+")"
	
	cAliasXD1   := GetNextAlias()
	cWhere      := "%XD1_ULTNIV <> 'S' AND XD1_NIVEMB > '1' AND XD1_LOTECT IN "+cIn+"%"
	If lBeginSQL
		BeginSQL Alias cAliasXD1
			SELECT * FROM %Table:XD1% (NOLOCK) XD1 WHERE XD1.%NotDel% AND %Exp:cWhere% ORDER BY XD1_LOTECT, XD1_OCORRE, XD1_PVSEP, XD1_XXPECA
		EndSQL
	Else
	   cSQL := "SELECT * FROM "+RetSqlName("XD1")+" (NOLOCK) XD1 WHERE D_E_L_E_T_ = '' AND "
		cSQL += StrTran(cWhere,'%','') + " ORDER BY XD1_LOTECT, XD1_OCORRE, XD1_PVSEP, XD1_XXPECA" 
		TCQUERY cSQL NEW ALIAS &(cAliasXD1)
	EndIf
	
	lCabecXD1  := .T.
	nSomaQtdes := 0
	nGerQtdes  := 0
	nTotCanc   := 0
	nGerCanc   := 0
	nTotSepar  := 0
	nGerSepar  := 0
	nTotProc   := 0
	nGerProc   := 0
	nTotLib    := 0
	nGerLib    := 0
	nTotOrig   := 0
	
	Do While (cAliasXD1)->(!Eof())
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Imprime cabecalho										 	  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	   If lCabecXD1
			@ LI, 20 PSAY "D I S P O N I V E I S  P A R A  S E P A R A C A O" Font oFnt3
	      LI++
	      @ LI, 00 PSAY "Pedido/Item"  
	      @ LI, 10 PSAY "Produto"      
	      @ LI, 29 PSAY "Quantidade"
	      @ LI, 39 PSAY "Ocorrencia"
	      @ LI, 49 PSAY "Numero da Etiqueta"
	      @ LI, 65 PSAY "Lote"
	      LI++
			@Li,00 Psay REPLICATE(CHR(151),170)
			Li++    
	      lCabecXD1 := .F.
	   EndIf
	
	   cLote := SUBSTR((cAliasXD1)->XD1_LOTECT,1,5)
		cItem := SUBSTR((cAliasXD1)->XD1_LOTECT,7,2)
	
		Do While (cAliasXD1)->(!Eof()) .And. SUBSTR((cAliasXD1)->XD1_LOTECT,1,5)+SUBSTR((cAliasXD1)->XD1_LOTECT,7,2) == cLote+cItem
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica salto de pagina							 	  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Li >= 55
				endpage
			   page
			   LI:=0
			   nPag++
				@Li,00 Psay REPLICATE(CHR(151),170)
				Li++
				@Li,01 Psay "ROSENBERGER DOMEX TELECOM    SEPARAÇÃO DE MATERIAL PARA EXPEDICAO   " + DTOC(DATE())+ " Pag.: "+ALLTRIM(STR(NPAG)) Font ofnt3
				LI++
				@Li,00 Psay REPLICATE(CHR(151),170)
				Li++
				@ LI, 00 PSAY "Numero do Pedido: "+mv_par01+" - "+SA1->A1_NOME
				Li++
				@ LI, 00 PSAY "Prev.Faturamento: "+DTOC(mv_par02)
				li++
				@Li,00 Psay REPLICATE(CHR(151),170)
				Li++       
				lCabecXD1 := .F.		
			EndIf
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Imprime embalagens finais							 	  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nSomaQtdes++                               
			nGerQtdes++
		   @ LI, 00 PSAY SubStr((cAliasXD1)->XD1_PVSEP,1,6)+" "+SubStr((cAliasXD1)->XD1_PVSEP,7,2)
		   @ LI, 10 PSAY (cAliasXD1)->XD1_COD
		   @ LI, 30 PSAY TransForm((cAliasXD1)->XD1_QTDORI,"@E 99,999.99")
		   If (cAliasXD1)->XD1_OCORRE == "5"
			   @ LI, 48 PSAY "Cancelada" Font oFnt3
				nTotCanc++       
				nGerCanc++
			ElseIf (cAliasXD1)->XD1_OCORRE == "4" .And. Empty((cAliasXD1)->XD1_PVSEP)
			   @ LI, 40 PSAY "Liberada"
				nTotLib++ 
				nGerLib++
			ElseIf (cAliasXD1)->XD1_OCORRE == "4" .And. !Empty((cAliasXD1)->XD1_PVSEP)
			   @ LI, 40 PSAY "Coletada"
				nTotSepar++
				nGerSepar++
			ElseIf (cAliasXD1)->XD1_OCORRE == "6"  
			   @ LI, 40 PSAY "Em Processo"
				nTotProc++ 
				nGerProc++
			EndIf
		   @ LI, 50 PSAY (cAliasXD1)->XD1_XXPECA
		   @ LI, 65 PSAY (cAliasXD1)->XD1_LOTECT
		   LI++
		   nTotOrig += (cAliasXD1)->XD1_QTDORI
		   (cAliasXD1)->(dbSkip())
		
	   EndDo
	   
	   If ( Li + 7 ) >= 55
			endpage
		   page
		   LI:=0
		   nPag++
			@Li,00 Psay REPLICATE(CHR(151),170)
			Li++
			@Li,01 Psay "ROSENBERGER DOMEX TELECOM    SEPARAÇÃO DE MATERIAL PARA EXPEDICAO   " + DTOC(DATE())+ " Pag.: "+ALLTRIM(STR(NPAG)) Font ofnt3
			LI++
			@Li,00 Psay REPLICATE(CHR(151),170)
			Li++
			@ LI, 00 PSAY "Numero do Pedido: "+mv_par01+" - "+SA1->A1_NOME
			Li++
			@ LI, 00 PSAY "Prev.Faturamento: "+DTOC(mv_par02)
			li++
	   EndIf
	   
		@Li,00 Psay REPLICATE(CHR(151),170)
		Li++    
		@ LI, 15 PSAY "Coletadas" Font oFnt3
		@ LI, 30 PSAY TransForm(nTotSepar ,"@E 99,999.99")
	   LI++
		@ LI, 15 PSAY "Liberadas" Font oFnt3
		@ LI, 30 PSAY TransForm(nTotLib ,"@E 99,999.99")
	   LI++
		@ LI, 15 PSAY "Canceladas" Font oFnt3
		@ LI, 30 PSAY TransForm(nTotCanc ,"@E 99,999.99")
	   LI++
		@ LI, 15 PSAY "Em Processo" Font oFnt3
		@ LI, 30 PSAY TransForm(nTotProc ,"@E 99,999.99")
	   LI++
		@ LI, 15 PSAY "T O T A I S" Font oFnt3
		@ LI, 30 PSAY TransForm(nSomaQtdes ,"@E 99,999.99")
		@ LI, 50 PSAY "QUANTIDADE POR EMBALAGEM" Font oFnt3
		@ LI, 65 PSAY TransForm(nTotOrig ,"@E 99,999.99")
		LI++
		@Li,00 Psay REPLICATE(CHR(151),170)
		Li++    

	   lCabecXD1  := .T.
	   nTotCanc   := 0
	   nTotSepar  := 0
	   nTotLib    := 0
	   nTotProc   := 0
		nSomaQtdes := 0
		nTotOrig   := 0
			   
	EndDo
	
   If ( Li + 7 ) >= 55
		endpage
	   page
	   LI:=0
	   nPag++
		@Li,00 Psay REPLICATE(CHR(151),170)
		Li++
		@Li,01 Psay "ROSENBERGER DOMEX TELECOM    SEPARAÇÃO DE MATERIAL PARA EXPEDICAO   " + DTOC(DATE())+ " Pag.: "+ALLTRIM(STR(NPAG)) Font ofnt3
		LI++
		@Li,00 Psay REPLICATE(CHR(151),170)
		Li++
		@ LI, 00 PSAY "Numero do Pedido: "+mv_par01+" - "+SA1->A1_NOME
		Li++
		@ LI, 00 PSAY "Prev.Faturamento: "+DTOC(mv_par02)
		li++
   EndIf

	@Li,01 Psay "TOTAL GERAL" Font ofnt3
	LI+=2
	@ LI, 15 PSAY "Coletadas" Font oFnt3
	@ LI, 30 PSAY TransForm(nGerSepar ,"@E 99,999.99")
   LI++
	@ LI, 15 PSAY "Liberadas" Font oFnt3
	@ LI, 30 PSAY TransForm(nGerLib ,"@E 99,999.99")
   LI++
	@ LI, 15 PSAY "Canceladas" Font oFnt3
	@ LI, 30 PSAY TransForm(nGerCanc ,"@E 99,999.99")
   LI++
	@ LI, 15 PSAY "Em Processo" Font oFnt3
	@ LI, 30 PSAY TransForm(nGerProc ,"@E 99,999.99")
   LI++
	@ LI, 15 PSAY "T O T A I S" Font oFnt3
	@ LI, 30 PSAY TransForm(nGerQtdes ,"@E 99,999.99")
   LI++
	@Li,00 Psay REPLICATE(CHR(151),170)
	LI++
	
	(cAliasXD1)->(dbCloseArea())

EndIf

(cAliasSZY)->(dbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Finaliza a impressao									 	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
EndPage
EndPrint
ofnt:end()
ofnt2:end()
ofnt3:end()
          
Return NIL
