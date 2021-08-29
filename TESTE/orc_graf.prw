#INCLUDE "RWMAKE.CH"
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#include "topconn.ch"
/*
Descri??o ³Impressao do Pedido de Vendas  - TmsPrinter               
*/
User Function ORC_GRAF()
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL oDlg := NIL
//LOCAL cString	:= "SC7"
PRIVATE titulo 	:= ""
PRIVATE nLastKey:= 0
PRIVATE _cPerg	:= "ORCGRAF"
PRIVATE nomeProg:= FunName()
Private nTotal	:= 0
Private nSubTot	:= 0
 
fCriaPerg(_cPerg)

If !Pergunte(_cPerg, .T.)
   Return
EndIf 

 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros					  		³
//³ mv_par01				// Numero da PT                   		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := FunName()            //Nome Default do relatorio em Disco
 
PRIVATE cTitulo := "Impressão do Pedido de Vendas"
PRIVATE oPrn    := NIL
PRIVATE oFont1  := NIL
PRIVATE oFont2  := NIL
PRIVATE oFont3  := NIL
PRIVATE oFont4  := NIL
PRIVATE oFont5  := NIL
PRIVATE oFont6  := NIL
//Private nLastKey := 0
Private nLin := 1650 // Linha de inicio da impressao das clausulas contratuais
 
DEFINE FONT oFont1 NAME "Times New Roman" SIZE 0,20 BOLD  OF oPrn
DEFINE FONT oFont2 NAME "Times New Roman" SIZE 0,14 BOLD OF oPrn
DEFINE FONT oFont3 NAME "Times New Roman" SIZE 0,14 OF oPrn
DEFINE FONT oFont4 NAME "Times New Roman" SIZE 0,14 ITALIC OF oPrn
DEFINE FONT oFont5 NAME "Times New Roman" SIZE 0,14 OF oPrn
DEFINE FONT oFont6 NAME "Courier New" BOLD
 
oFont08	 := TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)
oFont08N := TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)
oFont10	 := TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
oFont11  := TFont():New("Arial",11,11,,.F.,,,,.T.,.F.)
oFont14	 := TFont():New("Arial",14,14,,.F.,,,,.T.,.F.)
oFont16	 := TFont():New("Arial",16,16,,.F.,,,,.T.,.F.)
oFont10N := TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
oFont12  := TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
oFont12N := TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
oFont16N := TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)
oFont14N := TFont():New("Arial",14,14,,.T.,,,,.T.,.F.)
oFont06	 := TFont():New("Arial",06,06,,.F.,,,,.T.,.F.)
oFont06N := TFont():New("Arial",06,06,,.T.,,,,.T.,.F.)
 
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tela de Entrada de Dados - Parametros                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLastKey  := IIf(LastKey() == 27,27,nLastKey)
 
If nLastKey == 27
	Return
Endif
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do lay-out / impressao                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 
oPrn := TMSPrinter():New(cTitulo)
oPrn:Setup()
oPrn:SetLandsCape()//SetPortrait() //SetLansCape()
oPrn:StartPage()
Imprimir()
oPrn:EndPage()
oPrn:End()
 
DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL
 
@ 015,017 SAY "Esta rotina tem por objetivo imprimir"	OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE
@ 030,017 SAY "o impresso customizado:"					OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE
@ 045,017 SAY "Pedido de Venda" 						OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE
 
@ 06,167 BUTTON "&Imprime" 		SIZE 036,012 ACTION oPrn:Print()   	OF oDlg PIXEL
@ 28,167 BUTTON "Pre&view" 		SIZE 036,012 ACTION oPrn:Preview() 	OF oDlg PIXEL
@ 49,167 BUTTON "Sai&r"    		SIZE 036,012 ACTION oDlg:End()     	OF oDlg PIXEL
 
ACTIVATE MSDIALOG oDlg CENTERED
 
oPrn:End()
 
 
Return
 
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Descriçào ¦ Impressao Pedido de Vendas   					          ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Pelkote                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
STATIC FUNCTION Imprimir()
 
Orcamento()
Ms_Flush()
Return
 
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Descriçào ¦ Impressao 										          ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Pelkote                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
STATIC FUNCTION Orcamento()
 
cDia := SubStr(DtoS(dDataBase),7,2)
cMes := SubStr(DtoS(dDataBase),5,2)
cAno := SubStr(DtoS(dDataBase),1,4)
cMesExt := MesExtenso(Month(dDataBase))
cDataImpressao := cDia+" de "+cMesExt+" de "+cAno
 
cPercICMS := GetMv("MV_ESTICM")
 
oPrn:StartPage()
cBitMap := "P:Logo1.Bmp"
oPrn:SayBitmap(1200,1200,cBitMap,2400,1700)			// Imprime logo da Empresa: comprimento X altura
 
oPrn:Say(0030,0100,SM0->M0_NOMECOM             ,oFont14N)
 
oPrn:Box(0180,0050,0630,2300)
 
 
dbSelectArea("SC5")
dbSetOrder(01)
dbSeek(xFilial("SC5")+mv_par01)
While !Eof() .And. C5_NUM == mv_par01
	
	dbSelectArea("SA1")
	dbSetOrder(01)
	dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
	
	dbSelectArea("SA4")
	dbSetOrder(01)
	dbSeek(xFilial("SA4")+SC5->C5_TRANSP)
	
	dbSelectArea("SA3")
	dbSetOrder(01)
	dbSeek(xFilial("SA3")+SC5->C5_VEND1)
	
	dbSelectArea("DA0")
	dbSetOrder(01)
	dbSeek(xFilial("DA0")+SC5->C5_TABELA)
	
	dbSelectArea("SF4")
	dbSetOrder(01)
	dbSeek(xFilial("SF4")+SC6->C6_TES)
	
	dbSelectArea("SE4")
	dbSetOrder(01)
	dbSeek(xFilial("SE4")+SC5->C5_CONDPAG)
	
	dbSelectArea("SC6")
	dbSetOrder(01)
	dbSeek(xFilial("SC6")+SC5->C5_NUM)
	
	dbSelectArea("SC9")
	dbSetOrder(01)
	dbSeek(xFilial("SC9")+SC9->C9_PEDIDO)
	
	cEstICM := SA1->A1_EST
	nPosICM := AT(cPercICMS,cEstICM)
	nPercICMS := VAL(SubStr(cPercICMS,(nPosICM+2),2))
	
	oPrn:Box(0030,1770,0130,2350)
	oPrn:Say(0030,1370, "Pedido No",oFont14N)
	oPrn:Say(0040,1890,OemToAnsi(SC5->C5_NUM),oFont14)
	dataHora:=Time()
	oPrn:Say(0030,2800,dataHora,oFont14N)
	
	oPrn:Box(0180,2350,0630,3350)
	
	oPrn:Say(0200,0100,"Cliente:",oFont12N)
	oPrn:Say(0200,0280,OemToAnsi(SA1->A1_COD),oFont12)
	oPrn:Say(0200,0480,OemToAnsi(SA1->A1_NOME),oFont12)
	
	oPrn:Say(0250,0100,"Endereco:",oFont12N)
	oPrn:Say(0250,0280,OemToAnsi(SA1->A1_END),oFont12)
	oPrn:Say(0250,1200,OemToAnsi(SA1->A1_BAIRRO),oFont12)
	oPrn:Say(0250,1600,OemToAnsi(SA1->A1_MUN),oFont12)
	ESTADO:=SA1->A1_EST
	oPrn:Say(0250,2000,OemToAnsi(SA1->A1_EST),oFont12)
	
	oPrn:Say(0480,2500,"Data",oFont14N)
	dData:=Dtoc(SC5->C5_EMISSAO)
	oPrn:Say(0540,2500,OemToAnsi(Ddata),oFont14)
	
	oPrn:Say(0300,0100,"C.G.C:",oFont12N)
	oPrn:Say(0300,0280,Transform(Alltrim(SA1->A1_CGC),"@R 99.999.999/9999-99"),oFont12)
	
	oPrn:Say(0300,0800,"Inscricao Estadual:",oFont12N)
	oPrn:Say(0300,1150,Transform(Alltrim(SA1->A1_INSCR),"@R 999.999.999.999"),oFont12)
	
	oPrn:Say(0350,0100,"CEP:   ",oFont12N)
	oPrn:Say(0350,0280,OemToAnsi(SA1->A1_CEP),oFont12)
	
	oPrn:Say(0350,0940,"Telefone:"	,oFont12N)
	oPrn:Say(0350,1150,OemToAnsi(SA1->A1_DDD),oFont12)
	oPrn:Say(0350,1250,OemToAnsi(SA1->A1_TEL),oFont12)
	
	oPrn:Say(0400,0100,"Transp:",oFont12N)
	oPrn:Say(0400,0280,OemToAnsi(SA4->A4_COD),oFont12)
	oPrn:Say(0400,0460,OemToAnsi(SA4->A4_NOME),oFont12)
	oPrn:Say(0400,1100,OemToAnsi(SA4->A4_BAIRRO),oFont12)
	oPrn:Say(0400,1490,OemToAnsi(SA4->A4_TEL),oFont12)
	
	
	oPrn:Say(0280,2500,"Emitente",oFont14N)
	oPrn:Say(0340,2500,OemToAnsi(SC5->C5_XEMIT),oFont14)
	ncred:=0
	
	
	oPrn:Say(0280,2950,"CREDITO",oFont12N)
	ncred   := Posicione("SC9",1,xFilial("SC9")+SC6->C6_NUM,"C9_BLCRED")
	//
	
	if !Empty(ncred)
		oPrn:Say(0340,2950,"BLOQUEADO",oFont14N)
	else
		oPrn:Say(0340,2950,"LIBERADO",oFont14N)
	end if
	
	
	oPrn:Say(0480,2950,"ESTOQUE",oFont12N)
	nest   := Posicione("SC9",1,xFilial("SC9")+SC6->C6_NUM,"C9_BLEST")
	if !Empty(nest)
		oPrn:Say(0520,2950,"BLOQUEADO",oFont14N)
	ELSE
		oPrn:Say(0520,2950,"LIBERADO",oFont14N)
	ENDIF
	
	oPrn:Say(0450,0100,"Vendedor:"	,oFont12N)
	oPrn:Say(0450,0280,OemToAnsi(SA3->A3_COD),oFont12)
	oPrn:Say(0450,0480,OemToAnsi(SA3->A3_NREDUZ),oFont12)
	
	oPrn:Say(0450,1000,"Tabela:" ,oFont12N)
	oPrn:Say(0450,0280,OemToAnsi(DA0->DA0_CODTAB),oFont12)
	oPrn:Say(0450,0460,OemToAnsi(DA0->DA0_DESCRI),oFont12)
	finalidade:=0
	oPrn:Say(0500,0100,"Natureza:"	,oFont12N)
	finalidade := Posicione("SF4",1,xFilial("SF4")+SC6->C6_TES,"F4_FINALID")
	oPrn:Say(0500,0460,finalidade,oFont12)
	oPrn:Say(0550,0100,"Frete:" ,oFont12N)
	oPrn:Say(0550,0300,OemToAnsi(SC5->C5_TPFRETE),oFont12)
	
	oPrn:Box(0650,0050,0750,3350)
	oPrn:Say(0680,0100,"Codigo"  	            	,oFont12N)
	oPrn:Say(0680,0330,"Descricao"	            	,oFont12N)
	oPrn:Say(0680,1500,"Fabricante"	                ,oFont12N)
	oPrn:Say(0680,1900,"Quantidade"  	            ,oFont12N)
	oPrn:Say(0680,2180,"Pr.Unitario"               	,oFont12N)
	oPrn:Say(0680,2380,"Pr. Total" 	             	,oFont12N)
	oPrn:Say(0680,2570,"%Ipi"   	            	,oFont12N)
	oPrn:Say(0680,2780,"Vlr Ipi"   	            	,oFont12N)
	oPrn:Say(0680,2950,"Peso"    	            	,oFont12N)
	oPrn:Say(0680,3080,"Classificacao"             	,oFont12N)
	
	
	dbSelectArea("SC6")
	dbSetOrder(01)
	dbSeek(xFilial("SC6")+SC5->C5_NUM)
	
	nLin    :=0780
	nSubTot := 	nTotIPI := 	nVlrIPI := 	nICMS := nTotICMS := nTotalGeral := nPesoItem := nTotalItem := nTotalNota := 0
	While !Eof() .And. C6_NUM ==SC5->C5_NUM
		cFabricante:=SC6->C6_XFABRIC
		nIPI      := Posicione("SF4",1,xFilial("SF4")+SC6->C6_TES,"F4_IPI")
		nICMS     := Posicione("SF4",1,xFilial("SF4")+SC6->C6_TES,"F4_ICM")
		nPesoItem := Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_PESO")
		nPercIPI  := Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_IPI")
		cClassific:= Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_POSIPI")
		nPercICMS := Iif(Empty(nPercICMS),Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_PICM"),nPercICMS)
		nVlrIPI   := Iif(nIPI=="S",(SC6->C6_VALOR*nPercIPI)/100,0)
		nTotalItem:= (SC6->C6_QTDVEN*nPesoItem)
		nSubTot   := nSubTot + SC6->C6_VALOR
		nTotIPI   := nTotIPI + nVlrIPI
		nTotalNota:= nTotalNota + nTotalItem
		oPrn:Say(nLin,0050,OemToAnsi(SC6->C6_PRODUTO),		   oFont08)
		oPrn:Say(nLin,0330,OemToAnsi(SC6->C6_DESCRI),		   oFont08)
		cFabric2:=substr(cFabricante,01,08)
		oPrn:Say(nLin,1500,OemToAnsi(cFabric2),                oFont08)
		oPrn:Say(nLin,1750,Transform(SC6->C6_UNSVEN,"@E 9999"),	oFont08)
		oPrn:Say(nLin,1930,Transform(SC6->C6_QTDVEN,"@E 9,999,999.99"),		oFont08)
		oPrn:Say(nLin,2200,Transform(SC6->C6_PRCVEN,"@E 9,999,999.99"),	oFont08)
		oPrn:Say(nLin,2370,Transform(SC6->C6_VALOR,"@E 9,999,999.99"),		oFont08)
		IF nIPI=="S"
			oPrn:Say(nLin,2550,Transform(nPercIpi,"@E 9,999,999.99"),			oFont08)
			oPrn:Say(nLin,2750,Transform(nVlrIPI,"@E 9,999,999.99"),			oFont08)
		else
			nPerIPI:=0
			nVlrIpi:=0
			oPrn:Say(nLin,2550,Transform(nPercIpi,"@E 9,999,999.99"),			oFont08)
			oPrn:Say(nLin,2750,Transform(nVlrIPI,"@E 9,999,999.99"),			oFont08)
		endif
		oPrn:Say(nLin,2900,Transform(nTotalItem,"@E 9,999,999.99"),       oFont10N)
		oPrn:Say(nLin,3170,OemToAnsi(cClassific),                         oFont10)
		
		
		nLin+=0050
		
		DBSKIP()
	ENDDO
	
	oPrn:Say(1400,0680,OemToAnsi(SC5->C5_MENNOTA),oFont12)
	
	oPrn:Box(1600,0050,2300,1500)
	oPrn:Box(1600,1520,2300,3350)
	
	
	oPrn:Say(1650,0660,"Titulos Previsao" ,oFont14N)
	oPrn:Say(1700,0150,"Prazo de Pagamento:",oFont12N)
	oPrn:Say(1800,0150,OemToAnsi(SE4-> E4_DESCRI),oFont14)
	
	cprazo1:=substr(SE4->E4_COND,01,02)
	cPrazo2:=substr(SE4->E4_COND,04,02)
	cPrazo3:=substr(SE4->E4_COND,07,02)
	cPrazo4:=substr(SE4->E4_COND,10,02)
	cPrazo5:=substr(SE4->E4_COND,13,02)
	
	
	prazo1:=date() +VAL(cprazo1)
	prazo2:=date() +VAL(cprazo2)
	prazo3:=date() +VAL(cprazo3)
	prazo4:=date() +VAL(cprazo4)
	prazo5:=date() +VAL(cprazo5)
	
	oPrn:Say(2000,0100,"Titulos:  Vencimentos",oFont12N)
	
	if prazo1==date()
	else
		oPrn:Say(2050,0140,"1",oFont12N)
		oPrn:Say(2050,0250,Transform(prazo1, "@E 99/99/9999"),  oFont12N)
	endif
	if prazo2==date()
	else
		oPrn:Say(2100,0140,"2",oFont12N)
		oPrn:Say(2100,0250,Transform(prazo2, "@E 99/99/9999"),  oFont12N)
	endif
	if prazo3==date()
		
	else
		oPrn:Say(2150,0140,"3",oFont12N)
		oPrn:Say(2150,0250,Transform(prazo3, "@E 99/99/9999"),  oFont12N)
	endif
	if prazo4==date()
		
	else
		oPrn:Say(2200,0140,"4",oFont12N)
		oPrn:Say(2200,0250,Transform(prazo4, "@E 99/99/9999"),  oFont12N)
	endif
	
	if prazo5=date()
		
	else
		oPrn:Say(2250,0140,"5",oFont12N)
		oPrn:Say(2250,0250,Transform(prazo5, "@E 99/99/9999"),  oFont12N)
	endif
	oPrn:Say(1700,1100,"CFOP:",oFont12N)
	oPrn:Say(1800,1100,OemToAnsi(SC6->C6_CF),oFont14)
	oPrn:Say(1630,1600,"Frete"                                  	,oFont12N)
	oPrn:Say(1630,3000,Transform(SC5->C5_FRETE,"@E 9,999,999.99") ,oFont12)
	oPrn:Say(1700,1600,"Sub-Total"           	            	,oFont12N)
	oPrn:Say(1700,3000,Transform(nSubTot,"@E 9,999,999.99"),oFont12)
	oPrn:Say(1770,1600,"Total Geral"         	            	,oFont12N)
	nTotalGeral:=nSubTot+nTotIPI+SC5->C5_FRETE
	oPrn:Say(1770,3000,Transform(nTotalGeral,"@E 9,999,999.99"),oFont12)
	oPrn:Say(1850,1600,"Base do ICMS"         	            	,oFont12N)
	
	
	nPercIcm:=0
	IF ESTADO$("SP,RS") .AND. nICMS=="S"
		oPrn:Say(1850,3100,OemToAnsi("18 %"),oFont12 )
		nPercIcm:=(nTotalGeral/100)*18
	ENDIF
	
	IF ESTADO$("MG,RJ") .AND.  nICMS=="S"
		oPrn:Say(1850,3100,OemToAnsi("12 %"),oFont12 )
		nPercIcm:=(nTotalGeral/100)*12
	ENDIF
	
	IF ESTADO$("AC,AL,AM,AP,BA,CE,DF,ES,GO,MA,MS,MT,PA,PB,PE,PI,PR,RN,RO,RR,SC,SE,TO") .AND. nICMS=="S"
		oPrn:Say(1850,3100,OemToAnsi("17 %"),oFont12 )
		nPercIcm:=(nTotalGeral/100)*17
	ENDIF
	
	
	oPrn:Say(1920,1600,"ICMS"            	                	,oFont12N)
	oPrn:Say(1920,3000,Transform(nPercIcm,"@E 9,999,999.99"),oFont12)
	oPrn:Say(1990,1600,"IPI"                 	            	,oFont12N)
	oPrn:Say(1990,3000,Transform(nTotIPI,"@E 9,999,999.99"),oFont12)
	oPrn:Say(2060,1600,"Peso Liquido"         	            	,oFont12N)
	oPrn:Say(2060,3000,Transform(nTotalNota,"@E 9,999,999.99"),oFont12)
	oPrn:Say(2130,1600,"Peso Bruto"         	            	,oFont12N)
	oPrn:Say(2130,3000,Transform(nTotalNota,"@E 9,999,999.99"),oFont12)
	oPrn:Say(2200,1600,"Volumes"             	            	,oFont12N)
	oPrn:Say(2200,3000,Transform(SC5->C5_VOLUME1,"@E 9,999,999.99"),oFont12)
	//oPrn:Box(2200,0050,3200,0590)
	
	dbSelectArea("SC5")
	dbSkip()
EndDo
oPrn:EndPage()
 
Return
 
/*
Descri??o ³ Ajusta perguntas do SX1      
*/
Static Function AjustaSX1()
 
Local aArea := GetArea()
PutSx1(cPerg,"01","No Pedido Vendas               ?"," "," ","mv_ch1","C",6,0,0,	"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe numero do Pedido Vendas"},{"Informe o numero do Pedido de Vendas de"},{"Informe o Numero do Pedido de Vendas"})
PutSx1(cPerg,"02","Pedido Vendas Ate             ?"," "," ","mv_ch2","C",6,0,0,	"G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o numero do Orcamento"},{"Informe o numero do Pedido de Vendas ate"},{"Informe o Numero do Pedido de Compras ate"})
 
RestArea(aArea)
 
Return
 
//Processo para salvar relatório como imagem
 
aCaminho           := {"\172.30.5.5teste.jpg"}
filepath          := "172.30.5.5"
nwidthpage      := 630
nheightpage     := 870
 
aFiles := Directory(aCaminho[1])
For i:=1 to Len(aFiles)
	fErase("\172.30.5.5"+aFiles[1])
Next i
 
oPrint:SaveAllAsJpeg(filepath,nwidthpage,nheightpage,100)   //Gera arquivos JPEG na Pasta Protheus_dataImages
 
aFiles := {}
aFiles := Directory(aCaminho[1])
 
//Visualizacao e finalizacao do relatorio
 
oPrint:Setup()
oPrint:Preview()
oPrint:EndPage()
MS_FLUSH()
 
 
 
Return





Static Function fCriaPerg()
aSvAlias:={Alias(),IndexOrd(),Recno()}
i:=j:=0
aRegistros:={}
//                1      2    3               4  5     6      7  8  9  10 11  12 13         14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43
AADD(aRegistros,{_cPerg,"01","Orçamento de  ?      ","","","mv_ch1","C",06,00,00,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","SCJ","","","","",""})
AADD(aRegistros,{_cPerg,"02","Orçamento Ate ?      ","","","mv_ch2","C",06,00,00,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","SCJ","","","","",""})

DbSelectArea("SX1")
For i := 1 to Len(aRegistros)
	If !dbSeek(aRegistros[i,1]+aRegistros[i,2])
		While !RecLock("SX1",.T.)
		End
		For j:=1 to FCount()
			FieldPut(j,aRegistros[i,j])
		Next
		MsUnlock()
	Endif
Next i
dbSelectArea(aSvAlias[1])
dbSetOrder(aSvAlias[2])
dbGoto(aSvAlias[3])
Return(Nil)