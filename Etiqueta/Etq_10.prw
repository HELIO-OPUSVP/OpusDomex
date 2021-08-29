/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEtq_08     บAutor  ณJuliano F. Silva   บ Data ณ  16/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressใo de etiqueta termica para beneficiamento          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Alguns produtos comercializados pela empresa necessitam de บฑฑ
ฑฑบ            beneficiamento e para este controle precisamos emitir eti- บฑฑ
ฑฑบ            quetas para controle apenas do item na estrutura que sofre บฑฑ 
ฑฑบ            rแ o Beneficiamento                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                                                                        

# Include "RWMAKE.CH"
# Include "TOPCONN.CH"

User Function Etq_10()
/****************************************************************************
/ Declara็ใo das variaveis para sele็ใo dos itens na etiqueta               *
*****************************************************************************/

/*****************************
 Campos da Op para a Etiqueta
******************************/       
Private cOP     := Space(10)     // Numero da OP
Private cSeqOp  := Space(3)      // Sequencia da OP
Private cOperac := ""            // Codigo da Opera็ใo referente ao Recurso
//Private cRecurs := ""            // codigo Recurso
Private cQuant  := ""            // Quantidade do Item
//Private cPesoB  := 0             // Peso Bruto do Produto
//Private cPesoL  := 0             // Peso Liquido do Produto
//Private cLote   := ""            // Numero do lote
//Private cTraSup := ""            // Tratamento superficial no Produto
//Private cTraTer := ""            // Tratamento termico do Produto
//Private cTpTrat1 := ""           // Tipo do Tratamento 1
//Private cTpTrat2 := ""           // Tipo do Tratamento 2

//Private cCamad  := ""            // Camada no produto
//Private cResCor := ""            // Resistencia Corrosivo Produto
Private cCodPro := Space(15)     // Produto
Private cUM     := ""            // Unidade de Medida

/*****************************
 Campos da NF para a Etiqueta
******************************/       
//Private cNF     := ""            // Nota Fiscal
Private cNoF     := ""            // Nota Fof
Private cForn   := ""            // Fornecedor do Servi็o
Private cNomeF  := ""            // Nome do  Fornecedor
Private cLJForn := ""            // Loja do Fornecedor do Servi็o
Private cPedid  := Space(6)            // Pedido no Sistema

/*****************************
 Demais Informa็๔es
******************************/       
//Private cOperac := ""            // Descricao da Opera็ใo
Private cPorta  := "LPT1"        // Porta da Impressora
Private nQImp   := 1             // Quantidade de Etiquetas

/****************************************************************************
*  Dialogo de parametros para impressใo da Etiqueta                         *
*                                                                           *
* 1 - Numero da Ordem de Produ็ใo                                           *
* 2 - Numero de sequencia da Ordem de Produ็ใo                              *
* 3 - Codigo do produto a ser Beneficiado                                   *
* 4 - Numero do Pedido de Venda                                             *
* 5 - Quantida de Eiquetas a Imprimir, Padrใo 1                             *
*****************************************************************************/

@ 090,129 To 350,500 Dialog oDlgEtq Title OemToAnsi("Etiqueta T้rmica Beneficiamento")

@ 010,10 Say OemToAnsi("Ordem Produ็ใo:") Size 50,8
//@ 025,10 Say OemToAnsi("Sequencia da OP:") Size 50,8
//@ 040,10 Say OemToAnsi("Produto:") Size 50,8
//@ 055,10 Say OemToAnsi("Ped.Venda Benef.:") Size 50,8
@ 070,10 Say OemToAnsi("Qtd de Etiquetas:") Size 50,8

@ 010,060 Get cOp Picture "@!" Size 50,10  F3 "SC2_OP" Valid ValOP()
//@ 025,060 Get cSeqOp Picture "@!" Size 30,10 Valid ValOP() 
//@ 040,060 Get cCodPro Picture "@!" Size 80,10 Valid ValOP()
//@ 055,060 Get cPedid Picture "@!" Size 40,10 Valid ValPed()
@ 070,060 Get nQImp Picture "@R 999"  Size 20,10
@ 090,70  BmpButton Type 1 Action Gera_Etq()
@ 090,110 BmpButton Type 2 Action Close(oDlgEtq)

Activate Dialog oDlgEtq centered

Return .T.

/***************************************************************************
*  STATIC FUNCTION GERA_ETQ()                                              *
****************************************************************************
*  Funcao utilizada para selecionar os dados para a impressao das etiquetas*
*  																								*
****************************************************************************/

Static Function Gera_Etq()

/***************************************************************************
*  Dados da Op                                                             *
*  																								*
****************************************************************************/

cQuery := " SELECT C2_NUM, C2_PRODUTO, C2_QUANT, C2_PEDIDO, C2_SEQUEN, C2_ITEM FROM " + RetSqlName("SC2")+" (NOLOCK) SC2 "
cQuery += " WHERE "
cQuery += " SC2.C2_FILIAL = '" + xFilial("SC2") + "' AND"
cQuery += " SC2.C2_NUM = '" + AllTrim(cOP) + "' AND "
//cQuery += " SC2.C2_SEQUEN = '" + AllTrim(cSeqOp) + "' AND "
//cQuery += " SC2.C2_PRODUTO = '" + AllTrim(cCodPro) + "' AND "
cQuery += " SC2.D_E_L_E_T_ <> '*'"
cQuery += " ORDER BY SC2.C2_NUM "

TCQUERY cQuery Alias QUERY New

DbSelectArea("QUERY")
DbGoTop()

If Eof()
	Alert("Nao foi encontrado numero de OP "+AllTrim(cOP)+" e sequencia "+AllTrim(cSeqOP)+" produto "+AllTrim(cCodPro)+". Solicite auxilio do Administrador!")
	DbSelectArea("QUERY")
	DbCloseArea()
	Return()
EndIf

/***************************************************************************
*  Dados do Pedido                                                         *
*  																								*
****************************************************************************/
/*
cQuery2 := "SELECT C5_CLIENTE, C5_LOJACLI FROM " + RetSqlName("SC5")+" SC5 "
cQuery2 += " WHERE"
cQuery2 += " SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND"
cQuery2 += " SC5.C5_NUM = '" + AllTrim(cPedid) + "' AND "
cQuery2 += " SC5.D_E_L_E_T_ <> '*' "

TCQUERY cQuery2 Alias QUERY2 New

DbSelectArea("QUERY2")
DbGoTop()
If Eof()
	Alert("Nao foi encontrado Pedido de venda "+cPedid+". Solicite auxilio do Administrador!")
	DbSelectArea("QUERY")
	DbCloseArea()
	DbSelectArea("QUERY2")
	DbCloseArea()
	Return()
Else
	cForn    := QUERY2->C5_CLIENTE    // Fornecedor do Servi็o
	cLJForn  := QUERY2->C5_LOJACLI    // Loja do Fornecedor
EndIf
 
*/

/***************************************************************************
*  Dados de Itens do Pedido                                                *
*  																								*
****************************************************************************/
/*
//cQuery3 := " SELECT C5_CLIENTE, C5_LOJACLI, A2_NOME, C5_PESOL, C5_PBRUTO, C6_QTDVEN, "
cQuery3 := " SELECT C5_CLIENTE, C5_LOJACLI, A2_NOME, C6_QTDVEN, "
//cQuery3 += " C6_UM, C5_VOLUME1, C5_ESPECI1 , C6_PESO , C6_PESOB , C6_LOTECTL , C6_NUMLOTE  "
cQuery3 += " C6_UM, "
cQuery3 += " FROM " + RetSqlName("SC5")+" SC5, "  + RetSqlName("SA2")+" SA2, " + RetSqlName("SC6")+" SC6 "
cQuery3 += " WHERE "
cQuery3 += " SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND "
cQuery3 += " SC5.C5_FILIAL = SC6.C6_FILIAL AND "
cQuery3 += " SC5.C5_NUM = SC6.C6_NUM AND "
cQuery3 += " SC5.C5_CLIENTE = SA2.A2_COD AND "
cQuery3 += " SC5.C5_LOJACLI = SA2.A2_LOJA AND "
cQuery3 += " SC5.C5_NUM = '" + AllTrim(cPedid) + "' AND "
cQuery3 += " SC5.D_E_L_E_T_ <> '*' AND "
cQuery3 += " SC6.D_E_L_E_T_ <> '*' AND "
cQuery3 += " SA2.D_E_L_E_T_ <> '*' "

TCQUERY cQuery3 Alias QUERY3 New

DbSelectArea("QUERY3")
DbGoTop()

If Eof()
	Alert("Nao foi encontrado Pedido de venda do fornecedor "+cPedid+". Solicite auxilio do Administrador!")
	DbSelectArea("QUERY")
	DbCloseArea()
	DbSelectArea("QUERY2")
	DbCloseArea()
	Return()
EndIf

//cPesoL   := Str(QUERY3-> C6_PESO)
//cPesoB   := Str(QUERY3-> C6_PESOB)
cQuant   := Str(QUERY3-> C6_QTDVEN)
cNomeF   := SubStr(QUERY3->A2_NOME,1,25)
//cUM      := QUERY3->C6_UM
//cLote    := QUERY3->C6_LOTECTL

/***************************************************************************
*  Tipo do Tratamento do item conforme o recurso.                          *
*  																								*
****************************************************************************/
//cQuery4 := " SELECT G2_CODIGO, G2_PRODUTO, G2_OPERAC, G2_RECURSO, G2_DESCRI "
//cQuery4 += " FROM " + RetSqlName("SG2")+" SG2 "
//cQuery4 += " WHERE G2_PRODUTO = '" + AllTrim(cCodPro) + "' "
//cQuery4 += " AND ( G2_RECURSO = '000931' OR G2_RECURSO = '000930')
///cQuery4 += " AND SG2.D_E_L_E_T_ <> '*' "

//TCQUERY cQuery4 Alias QUERY4 New

//DbSelectArea("QUERY4")
//DbGoTop()

//If !Eof()
//   cTpTrat1 := QUERY4->G2_OPERAC 	
//   cTpTrat1 += "."+QUERY4->G2_DESCRI
//   cOperac := QUERY4->G2_OPERAC 	  	
//EndIf

/***************************************************************************
*  Dados de Itens do Pedido                                                *
*  																								*
****************************************************************************/
/*
cQuery5 := "SELECT D4_LOTECTL FROM " + RetSqlName("SD4")+" SD4 "
cQuery5 += " WHERE"
cQuery5 += " SD4.D4_FILIAL = '" + xFilial("SD4") + "' AND"
cQuery5 += " SUBSTRING (SD4.D4_OP,9,3) = '001'  AND "
cQuery5 += " SUBSTRING (SD4.D4_OP,1,6) = '" + AllTrim(cOP) + "' AND "
cQuery5 += " SD4.D_E_L_E_T_ <> '*'"
TCQUERY cQuery5 Alias QUERY5 New

DbSelectArea("QUERY5")
DbGoTop()

If !Eof()
	cLote  := QUERY5->D4_LOTECTL //
EndIf
*/
/***************************************************************************
*  Dados referente ao Item                                                 *
*  																								*
****************************************************************************/
 /*
cQuery6 := " SELECT G1_COMP, B1_TRATTER, B1_TRATSUP, B1_DESCTT, B1_DESCTS, B1_DESCED, "
cQuery6 += " B1_DESCCAM, B1_DESCRC, B1_DESC "
cQuery6 += " FROM " + RetSqlName("SG1")+" SG1, " + RetSqlName("SB1")+" SB1 "
cQuery6 += " WHERE"
cQuery6 += " SG1.G1_FILIAL = '" + xFilial("SG1") + "' AND"
cQuery6 += " SG1.G1_FILIAL = SB1.B1_FILIAL AND "
cQuery6 += " SG1.G1_COMP = SB1.B1_COD AND "
cQuery6 += " SG1.G1_COD = '" + AllTrim(cCodPro) + "' AND "
cQuery6 += " SB1.B1_TIPO = 'BN' AND "
cQuery6 += " SG1.D_E_L_E_T_ <> '*' AND "
cQuery6 += " SB1.D_E_L_E_T_ <> '*'"

TCQUERY cQuery6 Alias QUERY6 New

DbSelectArea("QUERY6")
DbGoTop()

If Eof()
	Alert("Nao foi encontrado componente do Grupo Beneficiamento na Estrutura do Produto "+AllTrim(cOP)+" no Cadastro de Produtos. Solicite auxilio do Administrador!")
	DbSelectArea("QUERY")
	DbCloseArea()
	DbSelectArea("QUERY2")
	DbCloseArea()
	DbSelectArea("QUERY3")
	DbCloseArea()
	DbSelectArea("QUERY4")
	DbCloseArea()
	DbSelectArea("QUERY6")
	DbCloseArea()
	Return()
EndIf

cTraSup := QUERY6->B1_DESCTS           // Tratamento superficial no Produto
cTraTer := QUERY6->B1_DESCTT
cCamad  := QUERY6->B1_DESCCAM          // Camada no produto
cResCor := QUERY6->B1_DESCRC           // Resistencia Corrosivo Produto
*/
/***************************************************************************
*  buscar numero da nota fiscal                                            *
*  																								*
****************************************************************************/
/*
dbSelectArea("SD2")
dbSetOrder(08)
if (dbSeek( xFilial("SD2")+Alltrim(cPedid) ))
	cNF := SD2->D2_DOC
else
	Alert("Nota Fiscal nao encontrada!")
endif
 
//////////////// LOTE

cQuery7 := " SELECT D2.D2_LOTECTL "
cQuery7 += " FROM " + RetSqlName("SD2")+ " D2 "
cQuery7 += " WHERE"
cQuery7 += " D2.D2_COD = '"+ Alltrim(cCodPro) + " ' "
cQuery7 += " AND D2.D2_DOC = '"+ Alltrim(cNF) + " ' "
cQuery7 += " AND D2.D_E_L_E_T_ <> '*'"

TCQUERY cQuery7 Alias QUERY7 New

DbSelectArea("QUERY7")
DbGoTop()
/*
If !Eof()
	cLote  := QUERY7->D2_LOTECTL //
EndIf
  */

/***************************************************************************
*  Chama fun็ใo de impressao conforme o numero de etiquetas solicitadas    *
*  																								*
****************************************************************************/

Imp_Etq()

QUERY->(dbCloseArea())
//QUERY2->(dbCloseArea())
//QUERY3->(dbCloseArea())
//QUERY4->(dbCloseArea())
//QUERY6->(dbCloseArea())
//QUERY7->(dbCloseArea())

Return()
  

/***************************************************************************
*  STATIC FUNCTION IMP_ETQ()                                               *
****************************************************************************
*  Funcao utilizada para Imprimir as etiquetas                             *
*  																								*
****************************************************************************/
  
Static Function Imp_Etq()
Local cOPComp  := AllTrim(cOP)+"01"+AllTrim(cSeqOp)
Local cOpBarra := AllTrim(cOP)+"01"+AllTrim(cSeqOp)+Space(2)+cCodPro+cOperac

MSCBPRINTER("TLP 2844","LPT1",,59,.F.)   //MSCBPRINTER("TLP 2844","LPT1",,221,.F.)

MSCBCHKSTATUS(.F.)

MSCBBEGIN(nQImp,6)

//MSCBBOX(12,01,88,55)     // Inicio BOX Monta BOX (x,y,x,y,espessura)
MSCBBOX(12,17,88,49)     // Inicio BOX Monta BOX (x,y,x,y,espessura)
MSCBSAY    (14,03,"Rosemberger","N","1","2,2")  //MSCBLINEH  (01,16,78,03,"B")                              // LINHA HORIZONTAL//MSCBSAY    (08,06,"OF:","N","2","2,3")             // TITULO FORNECEDOR
MSCBSAY    (28,07,"Domex","N","1","2,2")        //MSCBLINEH  (01,16,78,03,"B")
MSCBSAY    (44,03,"ROSEMBERGER DOMEX TELECOM S/A","N","1","1,2")          // NOME DO FORNECEDOR
MSCBSAY    (44,06,"Av Cabletech,601 Cacapava-SP","N","1","1,1")          // NOME DO FORNECEDOR
MSCBSAY    (44,09,"Telefone: (12)3221-8500","N","1","1,1")          // NOME DO FORNECEDOR
MSCBSAY    (44,11,"www.rdt.com.br","N","1","2,1")           // NOME DO FORNECEDOR
//MSCBLINEH  (13,20,88,03,"1") 
MSCBLINEV  (42,17,49,3,"B")                                 
MSCBSAY    (14,19,"Produto:","N","1","1,2")                 // NOME DO FORNECEDOR     
MSCBLINEH  (13,23,88,03,"1") 
MSCBSAY    (14,24,"Cod. Cliente:","N","1","1,2")            // NOME DO FORNECEDOR     
MSCBLINEH  (13,28,88,03,"1") 
MSCBSAY    (14,29,"Ped.Compra:","N","1","1,2")              // NOME DO FORNECEDOR     
MSCBLINEH  (13,33,88,03,"1") 
MSCBSAY    (14,34,"PN RDT:","N","1","1,2")                  // NOME DO FORNECEDOR     
MSCBLINEH  (13,38,88,03,"1") 
MSCBSAY    (14,39,"NF/Local:","N","1","1,2")                // NOME DO FORNECEDOR     
MSCBLINEH  (13,43,88,03,"1") 
MSCBSAY    (14,44,"Sem/Ano-Quant:","N","1","1,2")           // NOME DO FORNECEDOR 
MSCBSAYBAR (22,50,"1234567890abcd",'N','MB07',4,.F.,.F.,,,3,2) //Codigo produto em Barras    

                                   
//MSCBSAY    (13,08,"ROSEMBERGER DOMEX S/A TELECOM","N","2","2,3")          // NOME DO FORNECEDOR
//MSCBSAY    (16,14,"ROSEMBERGER DOMEX TELECOM","N","1","1,0")          // NOME DO FORNECEDOR
//MSCBSAY    (14,20,"ROSEMBERGER DOMEX","N","1","1,2")          // NOME DO FORNECEDOR
//MSCBLINEH  (01,35,78,03,"B")                                         
//MSCBSAY    (24,06,"Req. Serv.","N","2","2,3")             // NUMERO DO PEDIDO
//MSCBSAY    (32,06,cPedid,"N","2","2,3")                   // NUMERO DO PEDIDO
//MSCBLINEH  (01,42,78,03,"B")           
//MSCBSAY    (40,06,"Num da NF","N","2","2,3")
//MSCBSAY    (45,06,AllTrim(cNoF),"N","2","2,3")//
//MSCBLINEH  (01,49,78,02,"B")
//MSCBLINEV  (50,35,49,3,"B") 

//MSCBSAYBAR (50,06,AllTrim(cNoF),'N','MB07',10,.F.,.F.,,,3,2) //Codigo produto em Barras
/*
//segundo box
MSCBBOX    (01,68,99,102)
MSCBSAY    (13,69,"Descricao do Tratamento","N","2","2,3")
MSCBLINEH  (01,76,99,03,"B")
if !Empty(cTraSup).And.!Empty(cTraTer)                              // CAMPO DE TAM 45
   MSCBSAY    (04,77,SUBSTR(AllTrim(cTraSup),1,45),"N","2","1,1.5") // FONTE ANTERIOR "2","2,2")
   MSCBLINEH  (01,83,99,03,"B")
   MSCBSAY    (04,84,SUBSTR(AllTrim(cTraTer),1,45),"N","2","1,1.5")
elseif !Empty(cTraTer).And.Empty(cTraSup)
   MSCBSAY    (04,77,SUBSTR(AllTrim(cTraTer),1,30),"N","2","2,2")
   MSCBLINEH  (01,83,99,03,"B")
   MSCBSAY    (04,84,SUBSTR(AllTrim(cTraTer),31,60),"N","2","2,2")
else
   MSCBSAY    (04,77,SUBSTR(AllTrim(cTraSup),1,30),"N","2","2,2")
   MSCBLINEH  (01,83,99,03,"B")
   MSCBSAY    (04,84,SUBSTR(AllTrim(cTraSup),31,60),"N","2","2,2")
endif      
   
MSCBLINEH  (01,90,99,03,"B")
MSCBSAY    (04,91,"Camada","N","2","2,2")
MSCBSAY    (45,91,"Resit. Corr.","N","2","2,2")
MSCBLINEH  (01,96,99,03,"B")
MSCBSAY    (04,97,AllTrim(cCamad),"N","2","2,2")
MSCBSAY    (50,97,AllTrim(cResCor),"N","2","2,2")
MSCBLINEV  (30,90,102,3,"B") 

//Terceiro Box
MSCBBOX    (01,104,99,214)
MSCBSAY    (08,106,"Produto","N","2","2,4")
MSCBSAY    (52,106,AllTrim(cCodPro),"N","2","2,4")
MSCBLINEV  (50,104,115,3,"B")
 
MSCBLINEH  (01,115,99,03,"B")
MSCBSAY    (03,116,"Quantidade","N","1","1,3")
MSCBSAY    (33,116,"PESO LIQ.","N","2","2,2")
MSCBSAY    (66,116,"PESO BRUTO","N","2","2,2")
MSCBLINEH  (01,121,99,03,"B")                   

MSCBSAY    (03,122,AllTrim(cQuant),"N","2","2,3")
MSCBSAY    (33,122,AllTrim(cPesoL),"N","2","2,3")
MSCBSAY    (66,122,AllTrim(cPesoB),"N","2","2,3")
MSCBLINEH  (01,128,99,03,"B")
MSCBSAY    (03,130,"LOTE R:","N","2","2,3")
MSCBSAY    (45,130,AllTrim(cLote),"N","2","2,3")                   
MSCBLINEH  (01,137,99,03,"B")

MSCBLINEV  (30,115,137,3,"B") 
MSCBLINEV  (63,115,128,3,"B") 

MSCBSAY    (25,138,"Ordem de Producao","N","2","2,2")
MSCBLINEH  (01,143,99,03,"B")
MSCBSAY    (03,144,AllTrim(cTpTrat1),"N","2","1,1.5")
MSCBSAY    (65,144,AllTrim(cOPComp),"N","2","1,1.5")
MSCBLINEH  (01,149,99,03,"B")                                                         

MSCBLINEV  (62,143,149,3,"B") 

MSCBSAYBAR(10,150,AllTrim(cOPBarra),"N","MB07",09,.F.,.F.,,,2,2) //Codigo produto em Barras
MSCBLINEH  (01,160,99,03,"B")                       
MSCBSAY    (26,161,"Laudo  Fornecedor","N","2","2,2")                                  
MSCBLINEH  (01,166,99,03,"B")                       
MSCBLINEH  (01,186,99,03,"B")                       
MSCBSAY    (20,187,"Informacoes de Retorno","N","2","2,2")                                  
MSCBLINEH  (01,192,99,03,"B")                                                               
MSCBSAY    (05,193,"Quantidade","N","2","1,2")                                  
MSCBSAY    (35,193,"Peso","N","2","1,2")                                  
MSCBSAY    (65,193,"Qualidade","N","2","1,2")                                               
MSCBLINEH  (01,198,99,03,"B")
MSCBLINEH  (01,211,99,03,"B")    

MSCBLINEV  (30,192,211,3,"B") 
MSCBLINEV  (63,192,211,3,"B") 

// fim Etiqueta*/
MSCBEND()
MSCBCLOSEPRINTER() 

RETURN .T.


/***************************************************************************
*  STATIC FUNCTION VALOP()                                                 *
****************************************************************************
*  Funcao utilizada para validar a OP na tabela de OPดs SC2                *
*  Caso nao encontra a op retorna  Falso                                   *
****************************************************************************/

Static Function ValOp()

Local cItem := "01"
lRet := .T.

dbSelectArea("SC2")
dbSetOrder(06)

if !Empty (cOP)
   if !Empty(cSeqOp)
      if !Empty(cCodPro)
         If dbSeek(xFilial("SC2")+AllTrim(cOp)+cItem+AllTrim(cSeqOp)+AllTrim(cCodPro))
            return(lRet)
         Else
	         Aviso('Aten็ใo!','Ordem de Produ็ใo, Sequencia ou Produto Invalido!',{'Ok'})
	         return(.F.)
	      endif
	   elseif dbSeek(xFilial("SC2")+AllTrim(cOp)+cItem+AllTrim(cSeqOp))
	      return(lRet)
      Else
         Aviso('Aten็ใo!','Ordem de Produ็ใo  ou Sequencia Invalida!',{'Ok'})
	      return(.F.)
	   endif
	elseif dbSeek(xFilial("SC2")+AllTrim(cOp))
	   return(lRet)
   Else
      Aviso('Aten็ใo!','Ordem de Produ็ใo Invalida!',{'Ok'})
	   return(.F.)
	endif
endif  
/*
if dbSeek(xFilial("SC2")+AllTrim(cOp))
   return(lRet)//cCodPro := SC2->C2_PRODUTO
Else
   Aviso('Aten็ใo!','Ordem de Produ็ใo Invalida!',{'Ok'})
   return(.F.)
endif
*/

Return(lRet)

/***************************************************************************
*  STATIC FUNCTION VALPED()                                                *
****************************************************************************
*  Funcao utilizada para validar o Pedido na Tabela SC5                    *
*  caso nao encontra retorna Falso                                         *
****************************************************************************/
Static Function ValPed()

lRet := .T.

dbSelectArea("SC5")
dbSetOrder(01)
If dbSeek(xFilial("SC5")+cPedid)
	cPedid := SC5->C5_NUM
Else
	Aviso('Aten็ใo!','Pedido nใo encontrado !',{'Ok'})
	return(.F.)
Endif

Return(lRet)

// Fim do programa