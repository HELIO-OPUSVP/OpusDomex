#include "rwmake.ch"
#define PAD_RIGHT 1
// ORCAMENTO ANTIGO - MODO GRAFICO


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATR41   ºAutor  ³DANIEL LUPOLI       º Data ³  12/06/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ ORCAMENTO DE VENDA                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                        ALTERACOES                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                ³                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATR41()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
SetPrvt("WNREL,TAMANHO,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("NREGISTRO,CKEY,NINDEX,CINDEX,CCONDICAO,LEND")
SetPrvt("CPERG,ARETURN,NOMEPROG,NLASTKEY,NBEGIN,ALINHA")
SetPrvt("LI,LIMITE,LRODAPE,CPICTQTD,NTOTQTD,NTOTVAL")
SetPrvt("APEDCLI,CSTRING,ADRIVER,CFILTER,CPEDIDO,CHEADER")
SetPrvt("NPED,CMOEDA,CCAMPO,CCOMIS,I,NIPI")
SetPrvt("NVIPI,NBASEIPI,NVALBASE,LIPIBRUTO,NPERRET,CESTADO")
SetPrvt("TNORTE,CESTCLI,CINSCRCLI,OPRINT,")

*/


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel            := ""
tamanho          := "G" //"M"  // 
titulo           := "Emissao do Orcamento de Venda"
cDesc1           := "Emissao do Orcamento de Venda, de acordo com"
cDesc2           := "intervalo informado na op‡„o Parƒmetros."
cDesc3           := " "
nRegistro        := 0
cKey             := ""
nIndex           := ""
cIndex           := "" //  && Variaveis para a criacao de Indices Temp.
cCondicao        := ""
lEnd             := .T.
aReturn          := { "Zebrado", 1,"Administracao", 1, 2, 1, "",0 } // ETILUX -> RETRATO
nomeprog         := "RFATR41"
nLastKey         := 0
nBegin           := 0
aLinha           := {}
li               := 3200
limite           := 132
lRodape          := .F.
cPictQtd         := ""
nTotQtd          := nTotVal := 0
nTotValIpi       := 0
nTotIPI          := 0
nTotIcm          := 0
aPedCli          := {}
wnrel            := "RFATR41"
cString          := "SCK"
_aArea    		 := GetArea()
i := 0
_cnPAD 			 := PAD_RIGHT   // COMANDO PARA ALINHAR A IMPRESSAO A DIREITA QUANDO NECESSARIO

_cPerg   := PADR("RFATR41",10)

cRootPath   := AllTrim( GetSrvProfString("RootPath","") )

// Cria Pergunta do relatorio

MV_PAR01 := SCJ->CJ_NUM
fCriaPerg(_cPerg)

If !Pergunte(_cPerg, .T.)
   Return
EndIf 



oPrint:= TMSPrinter():New( "Orçamento de Vendas" )
//oPrint:SetPortrait() // ou SetLandscape()
oPrint:SetLandscape()

//Parâmetros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont2n := TFont():New("Times New Roman",,10,,.T.,,,,,.F. )
oFont6  := TFont():New("Arial",9,6 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont8  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont8n := TFont():New("Arial",9,8 ,.T.,.T.,5,.T.,5,.T.,.F.)
oFont9  := TFont():New("Arial",9,9 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10 := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10n:= TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont11 := TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14 := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n:= TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n:= TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n:= TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont18n:= TFont():New("Arial",9,18,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20n:= TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont22n:= TFont():New("Arial",9,22,.T.,.T.,5,.T.,5,.T.,.F.)
oFont24 := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

#define CLR_HGRAY                12632256          // RGB( 192, 192, 192 )

oBrush := TBrush():New("",CLR_HGRAY)// 4 daniel 05/12/05


/*--------------------------------------------------------------------------------
FillRect Enche um retângulo com um objeto de escova especificado.
--------------------------------------------------------------------------------

Sintaxe:          <oPrn>:FillRect( <aRect>, <oBrush> )

Parâmetros:

<aRect> 	Isto é um arranjo com as dimensões de retângulo:

{ nTop, nLeft, nBottom, nRight }

<oBrush> 	Isto é a escova contesta usar para enchimento a área de retângulo. Para criar o uso de escova:

DEFINA oBrush dE ESCOVA ...

*/
DbSelectArea("SCJ")
Dbsetorder(1)  
dbSeek(xFilial("SCJ")+MV_PAR01)
_cNumORC := SCJ->CJ_NUM
_cCodCli := SCJ->CJ_CLIENTE
_cCodLj  := SCJ->CJ_LOJA

While SCJ->CJ_NUM == _cNumORC  //.and. SCJ->CJ_EMISSAO < "20071009" //eof() == .f.
                                     
		
	nTotQtd    := 0
	nTotVal    := 0
	nTotValIpi := 0
	nTotIPI    := 0
	nTotIcm    := 0
	_nValTTot  := 0  //  TOTAL DO ORCAMENTO MANUAL - ETILUX
	
	cPedido := SCJ->CJ_NUM
	
	dbSelectArea("SE4")
	dbSeek(xFilial("SE4")+SCJ->CJ_CONDPAG)
	dbSelectArea("DA0")
	dbSeek(xFilial("DA0")+SCJ->CJ_TABELA)
	
	
	dbSelectArea("SCK")
	dbSeek(xFilial("SCK")+cPedido)
	cPictQtd := PESQPICTQT("CK_QTDVEN",10)
	nRegistro:= RECNO()
	
	IF LastKey() == 286
		@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta tabela de pedidos do cliente p/ o cabe‡alho            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aPedCli:= {}
	While !Eof() .And. SCK->CK_NUM == SCJ->CJ_NUM
		IF !Empty(SCK->CK_PEDCLI) .and. Ascan(aPedCli,SCK->CK_PEDCLI) == 0
			AAdd(aPedCli,SCK->CK_PEDCLI)
		ENDIF
		dbSkip()
	Enddo
	aSort(aPedCli)
	
	dbGoTo( nRegistro )
	While !Eof() .And. SCK->CK_NUM == SCJ->CJ_NUM
		
		IF LastKey()==27
			@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
			Exit
		Endif
		
		If li > 2500                       // 43   ALTER. P/ ETILUX
			If lRodape
				oPrint:EndPage()     // Finaliza a página
				//                ImpRodape()
				lRodape := .F.
			Endif
			li := 0100
			ImpCabec()
		Endif
		
		ImpItem()
		dbSkip()
		li:=li+0050
	Enddo
	
	IF lRodape
		ImpRodape()
		lRodape:=.F.
	Endif
	
	dbSelectArea("SCJ")
	dbSkip()
	
	//IncRegua()
Enddo

oPrint:EndPage()

IF oPrint:Setup() // para configurar impressora
	//oPrint:Preview()
	oPrint:Print() // descomentar esta linha para imprimir
EndIf
//MS_FLUSH()



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta Arquivo Temporario e Restaura os Indices Nativos.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("SCJ")
//Set Filter TO ()

Ferase(cIndex+OrdBagExt())

DbSelectArea("SCJ")
//RestArea(_aSCJArea)
RestArea(_aArea)

MS_FLUSH()

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCabec ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.11.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao da Pr‚-Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpCabec(void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Matr730                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 20/09/02 ==> Function ImpCabec

Static Function ImpCabec()

oPrint:StartPage()   // Inicia uma nova página
//oPrn:Setup() // para configurar impressora

//oPrn:Print() // descomentar esta linha para imprimir

//MS_FLUSH()



//oPrint:StartPage()   // Inicia uma nova página

lRodape     := .T.
//cHeader     :=""
nPed        :=""
//cMoeda      :=""
//cCampo      :=""
//cComis      :=""

//LINHA  //COL
oPrint:Box(0100,0100,3300,2300)                   //ETIQ 9

aBmp := cRootPath+"ETILUX-PB.BMP"

// LOGOTIPO
If File(aBmp)
	//oPrint:SayBitmap( 0150,1650,aBmp,0200,0150)     // Logo retirado conformo solic. da Sra. Rose em 23/03/06
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona registro no cliente do pedido                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SA1")
dbSetOrder(1)     //
dbSeek(xFilial("SA1")+_cCodCli+_cCodLj)


oPrint:Say  (0110,0110,"CLIENTE"             ,oFont8n)
oPrint:Say  (0110,0280,":"                   ,oFont8)
oPrint:Say  (0105,0300,SA1->A1_COD+" / "+SA1->A1_LOJA           ,oFont10)
//oPrint:Say  (0105,0440,SA1->A1_LOJA           ,oFont10)
oPrint:Say  (0105,0540,SA1->A1_NOME          ,oFont10)
//oPrint:Say  (0105,0430,                    ,oFont10)
oPrint:Say  (0110,1930,"**** ORÇAMENTO ****"   ,oFont10)
oPrint:Say  (0160,0110,"ENDERECO"            ,oFont8n)
oPrint:Say  (0160,0280,":"                   ,oFont8)
oPrint:Say  (0160,0300,ALLTRIM(SA1->A1_END)  ,oFont8)
oPrint:Say  (0210,0110,"CIDADE"              ,oFont8n)
oPrint:Say  (0210,0280,":"                   ,oFont8)
oPrint:Say  (0210,0300,SA1->A1_MUN           ,oFont8)
oPrint:Say  (0310,0110,"CNPJ"                 ,oFont8n)
oPrint:Say  (0310,0280,":"                   ,oFont8)
oPrint:Say  (0310,0300,TRANSFORM(SA1->A1_CGC,"@R 99.999.999/9999-99")           ,oFont8)
oPrint:Say  (0160,1030,"FONE"                ,oFont8n)
oPrint:Say  (0160,1120,":"                   ,oFont8)
oPrint:Say  (0160,1140,ALLTRIM(SA1->A1_DDD)  ,oFont8)
oPrint:Say  (0160,1200,"-"                   ,oFont8)
oPrint:Say  (0160,1220,ALLTRIM(SA1->A1_TEL)  ,oFont8)
oPrint:Say  (0210,1040,"FAX"                 ,oFont8n)
oPrint:Say  (0210,1120,":"                   ,oFont8)
oPrint:Say  (0210,1140,ALLTRIM(SA1->A1_FAX)  ,oFont8)
oPrint:Say  (0260,0960,"CONTATO"              ,oFont8n)
oPrint:Say  (0260,1120,":"                    ,oFont8)
oPrint:Say  (0260,1140,ALLTRIM(SA1->A1_CONTATO) ,oFont8)
oPrint:Say  (0260,0110,"ESTADO"              ,oFont8n)
oPrint:Say  (0260,0280,":"                   ,oFont8)
oPrint:Say  (0260,0300,SA1->A1_EST           ,oFont8)

oPrint:Say  (0310,1060,"IE"                  ,oFont8n)
oPrint:Say  (0310,1120,":"                   ,oFont8)
oPrint:Say  (0310,1140,SA1->A1_INSCR         ,oFont8)

oPrint:Say  (0310,1500,"TIPO"                ,oFont8n)
oPrint:Say  (0310,1580,":"                   ,oFont8)
IF SA1->A1_TIPO = "F"
	oPrint:Say  (0310,1600,"CONS. FINAL"                                          ,oFont8)
Elseif   SA1->A1_TIPO = "L"
	oPrint:Say  (0310,1600,"PRODUTOR RURAL"                                       ,oFont8)
Elseif   SA1->A1_TIPO = "R"
	oPrint:Say  (0310,1600,"REVENDEDOR"                                           ,oFont8)
Elseif   SA1->A1_TIPO = "S"
	oPrint:Say  (0310,1600,"SOLIDARIO"                                            ,oFont8)
Elseif   SA1->A1_TIPO = "X"
	oPrint:Say  (0310,1600,"EXPORTACAO"                                           ,oFont8)
Endif


oPrint:Say  (0180,1925,"IMPRESSAO"           ,oFont8n)
oPrint:Say  (0180,2120,":"                   ,oFont8)
oPrint:Say  (0175,2140,DTOC(DATE())          ,oFont10)
oPrint:Say  (0235,1925,"EMISSAO"             ,oFont8n)
oPrint:Say  (0230,2120,":"                   ,oFont8)
oPrint:Say  (0225,2140,DTOC(SCJ->CJ_EMISSAO),oFont10)
oPrint:Say  (0285,1925,"ORÇAMENTO"           ,oFont8n)
oPrint:Say  (0280,2120,":"                   ,oFont8)
oPrint:Say  (0280,2140,SCJ->CJ_NUM           ,oFont11)
oPrint:Say  (0370,0110,"COND.PGTO"            ,oFont8n)
oPrint:Say  (0370,0280,":"                     ,oFont8)
oPrint:Say  (0370,0300,SCJ->CJ_CONDPAG       ,oFont8)
oPrint:Say  (0370,0370,"-"                    ,oFont8)
oPrint:Say  (0370,0390,SE4->E4_DESCRI        ,oFont8)
oPrint:Say  (0370,0690,"TABELA"              ,oFont8n)
oPrint:Say  (0370,0810,":"                   ,oFont8)
oPrint:Say  (0370,0830,SCJ->CJ_TABELA        ,oFont8)
oPrint:Say  (0370,0890,"-"                   ,oFont8)
oPrint:Say  (0370,0910,DA0->DA0_DESCRI       ,oFont8)

If !Empty(SCJ->CJ_VEND)      // IMPRESSAO DO VENDEDOR - ALTERADO EM 27/01/03
	dbSelectArea("SA3")
	dbSetOrder(1)     //
	dbSeek(xFilial("SA3")+SCJ->CJ_VEND)
	oPrint:Say  (0370,1450,"VENDEDOR"         ,oFont8n)
	oPrint:Say  (0370,1620,":"                ,oFont8)
	oPrint:Say  (0370,1640,SA3->A3_NOME       ,oFont8)
EndIf


dbSelectArea("SA4")
dbSetOrder(1)     //
//dbSeek(xFilial("SA4")+SCJ->CJ_X_TRANS)
oPrint:Say  (0430,0110,"TRANSP"         ,oFont8n)
oPrint:Say  (0430,0280,":"                ,oFont8)
//oPrint:Say  (0430,0300,SCJ->CJ_X_TRANS+" - "+SA4->A4_NOME       ,oFont8)

oPrint:Say  (0430,1410,"ORD. COMPRA"         ,oFont8n)
oPrint:Say  (0430,1620,":"                   ,oFont8)
//oPrint:Say  (0430,1640,SCJ->CJ_X_PEDCL       ,oFont8)



oPrint:Say  (0485,0125,"It"                    ,oFont8n)
oPrint:Say  (0485,0200,"Quantidade"            ,oFont8n)
oPrint:Say  (0485,0415,"UM"                    ,oFont8n)
oPrint:Say  (0485,0540,"Código"                ,oFont8n)
oPrint:Say  (0485,0880,"Descrição do Material" ,oFont8n)
oPrint:Say  (0485,1355,"Preco Bruto"           ,oFont8n)
oPrint:Say  (0485,1560,"Desconto"              ,oFont8n)
oPrint:Say  (0485,1760,"Preco Liquido"         ,oFont8n)
oPrint:Say  (0485,2080,"Valor Total"           ,oFont8n)
oPrint:Line (0350,0100,0350,2300)                // HORIZONTAL 1
oPrint:Line (0410,0100,0410,2300)                // HORIZONTAL 2
oPrint:Line (0470,0100,0470,2300)                // HORIZONTAL 3
oPrint:Line (0530,0100,0530,2300)                // HORIZONTAL 4


oPrint:Line (0350,1900,0100,1900)                // VERTICAL 1  LINHA 1
//oPrint:Line (0350,1910,0100,1910)                // VERTICAL 1 A LINHA 1
oPrint:Line (2525,0160,0470,0160)                // VERTICAL 2  LINHA 1
oPrint:Line (2525,0390,0470,0390)                // VERTICAL 3  LINHA 1
oPrint:Line (2525,0480,0470,0480)                // VERTICAL 4  LINHA 1
oPrint:Line (2525,0730,0470,0730)                // VERTICAL 5  LINHA 1  // ERA 700 ANTES // 2 E 4 PARAMETROS COLUNA
oPrint:Line (2525,1330,0470,1330)                // VERTICAL 6  LINHA 1  // 30 A MAIS EU COLOQUEI
oPrint:Line (2525,1540,0470,1540)                // VERTICAL 7  LINHA 1  // 30 A MAIS EU COLOQUEI
oPrint:Line (2525,1710,0470,1710)                // VERTICAL 8  LINHA 1
oPrint:Line (2525,2000,0470,2000)                // VERTICAL 9  LINHA 1
//oPrint:Line (2500,2080,0370,2080)               // VERTICAL 10  LINHA 1
oPrint:Line (2525,0100,2525,2300)                // HORIZONTAL FINAL


oPrint:Say  (3320,2000,"Impresso por"              ,oFont6)
oPrint:Say  (3320,2150,__cUserID              ,oFont6)

li:= 0550

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpItem  ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.11.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao da Pr‚-Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpItem(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Matr730                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ImpItem()
nIPI       :=0
nVipi      :=0
nBaseIPI   :=100
nValBase   := 0
lIpiBruto  :=IIF(GETMV("MV_IPIBRUT")=="S",.T.,.F.)

dbSelectArea("SB1")
dbSeek(xFilial("SB1")+SCK->CK_PRODUTO)
dbSelectArea("SF4")
dbSeek(xFilial("SF4")+SCK->CK_TES)
IF SF4->F4_IPI == "S"
	nBaseIPI    := IIF(SF4->F4_BASEIPI > 0,SF4->F4_BASEIPI,100)
	nIPI 		:= SB1->B1_IPI
	nValBase	:= If(lIPIBruto .And. SCK->CK_PRUNIT > 0,SCK->CK_PRUNIT,SCK->CK_PRCVEN)*SCK->CK_QTDVEN
	nVipi		:= nValBase * (nIPI/100)*(nBaseIPI/100)
Endif

_nValorCK  := SCK->CK_VALOR
_nQtdVenCK := SCK->CK_QTDVEN
_nPVenCK   := SCK->CK_PRCVEN
_nPUnitCK  := SCK->CK_PRUNIT
_cUmImp    := SCK->CK_UM
//_cPrcMin   := SB1->B1_X_PRMIN
_cPrcMin   := 0 //SB1->B1_X_PRMIN

/*
If !Empty(SCK->CK_SEGUM) .OR. (SCK->CK_UM <> SB1->B1_UM)
	
	_c2UmB1   := SB1->B1_SEGUM
	_c1UmB1   := SB1->B1_UM
	_cUmImp   := _c1UmB1
	_cTpCvB1  := SB1->B1_TIPCONV
	_nConvB1  := SB1->B1_CONV
	_c2UmCK   := SCK->CK_SEGUM
	_lFlagUm  := .T.
	_nMod1    := 0
	
	If 	(SB1->B1_UM == SCK->CK_UM) .AND. (SB1->B1_SEGUM == SCK->CK_SEGUM)
		
		If SB1->B1_CONV > 0
			
			//			If SCK->CK_UNSVEN >= 0 .AND. SCK->CK_UNSVEN < 1 //
			_nMod1 := MOD(SCK->CK_QTDVEN,SB1->B1_CONV)
			If (SCK->CK_UNSVEN >= 0 .AND. SCK->CK_UNSVEN < 1) .OR. (_nMod1>0) //
				_nUnsVEN  := SCK->CK_QTDVEN
				_cUmImp   := SCK->CK_UM
				_lFlagUm  := .F.
			Else
				_nUnsVEN  := SCK->CK_UNSVEN
			EndIf
			
			
			If _cTpCvB1 == "M" .And. _lFlagUm
				_nQtdVenCK := _nUnsVEN
				_nPVenCK   := SCK->CK_PRCVEN / SB1->B1_CONV
				_nPUnitCK  := SCK->CK_PRUNIT / SB1->B1_CONV
				_cUmImp    := _c2UmB1
			ElseIF _cTpCvB1 == "D" .And. _lFlagUm
				_nQtdVenCK := _nUnsVEN
				_nPVenCK   := SCK->CK_PRCVEN * SB1->B1_CONV
				_nPUnitCK  := SCK->CK_PRUNIT * SB1->B1_CONV
				_cUmImp    := _c2UmB1
			EndIf
		Else
			_cUmImp    := _c2UmCK
			
		EndIf
	Else
		_cUmImp    := _c2UmCK
		
		_nQtdVenCK := SCK->CK_UNSVEN
		_nPVenCK   := (SCK->CK_QTDVEN / SCK->CK_UNSVEN) * SCK->CK_PRCVEN
		_nPUnitCK  := (SCK->CK_QTDVEN / SCK->CK_UNSVEN) * SCK->CK_PRUNIT
	EndIf
EndIf
*/

oPrint:Say  (li,0115,SCK->CK_ITEM             ,oFont8)
oPrint:Say  (li,0370,Transform(_nQtdVenCK,"999999999")          ,oFont8,,,,_cnPAD,)
If _cUmImp == "PC"   // SE FOR DIFERENTE DE PC IMPRIME NEGRITO
	oPrint:Say  (li,0420,_cUmImp                  ,oFont8)
Else
	oPrint:Say  (li,0420,_cUmImp                  ,oFont8n)
EndIf
oPrint:Say  (li,0500,SCK->CK_PRODUTO          ,oFont8)
oPrint:Say  (li,0770,SCK->CK_DESCRI           ,oFont8)
oPrint:Say  (li,1510,AllTrim(Transform(_nPUnitCK,"@E 999,999,999.99"))  ,oFont8,,,,_cnPAD,)
oPrint:Say  (li,1690,AllTrim(Transform(SCK->CK_DESCONT,"99.99%"))       ,oFont8,,,,_cnPAD,)

If !Empty(_cPrcMin) .And. _cPrcMin > SCK->CK_PRCVEN //_nPVenCK    DANIEL 20070821
	oPrint:FillRect({li-20,1710,li+55,2000},oBrush)
EndiF

oPrint:Say  (li,1980,AllTrim(Transform(_nPVenCK,"@E 999,999,999.99"))   ,oFont8,,,,_cnPAD,)
oPrint:Say  (li,2280,Transform(_nValorCK,"@E 999,999,999.99")            ,oFont8,,,,_cnPAD,)

// { nTop, nLeft, nBottom, nRight }


// Sintaxe:         <oPrn>:Say( <nRow>, <nCol>, <cText>, <oFont>, <nWidth>, <nClrText>, <nBkMode>, <nPad> )
//<nPad> 	Um valor numérico o texto para imprimir: ( PAD_LEFT é utilizado por default)

//                   #define PAD_LEFT 0 #define PAD_RIGHT 1 #define PAD_CENTER 2




oPrint:Line (li+55,0100,li+55,2300)                // HORIZONTAL PRODUTOS

// CALCULO DO VALOR TOTAL SEM DESCONTO MANUAL - ETILUX
_nValTunit := SCK->CK_QTDVEN * SCK->CK_PRUNIT
_nValTTot  := _nValTTot + _nValTunit
@li,088 PSAY SCK->CK_DESCONT    Picture "99.99%"

@li,097 PSAY SCK->CK_PRCVEN     Picture PesqPict("SCK","CK_PRCVEN",12)  // LIQUIDO

@li,117 PSAY NoRound(SCK->CK_VALOR) Picture PesqPict("SCK","CK_VALOR",14)   //VALOR+nVipi

li := li + 0030


nTotQtd    := nTotQtd + SCK->CK_QTDVEN
nTotVal    := nTotVal + NoRound(SCK->CK_VALOR)// VALOR+nVipi          TOTAL SEM IPI
nTotValIpi := nTotValIpi + NoRound(SCK->CK_VALOR+nVipi)      //   TOTAL COM IPI
nTotIPI    := nTotValIpi - nTotVal                         //  VALOR TOTAL DO IPI

dbSelectArea("SCK")

Return()


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpRodape³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.11.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao da Pr‚-Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpRoadpe(void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Matr730                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ImpRodape()
li:=li+0050



/*

// TRATAMENTO PARA O DESCONTO DO CABECALHO DO ORCAMENTO - ETILUX
If !Empty(SCJ->CJ_DESC1)
@ 66,001 PSAY "  Desconto 1 : "
@ 66,018 PSAY SCJ->CJ_DESC1 Picture "99.99%"
EndIf
If !Empty(SCJ->CJ_DESC2)
@ 66,026 PSAY "  Desconto 2 : "
@ 66,044 PSAY SCJ->CJ_DESC2 Picture "99.99%"
EndIf
If !Empty(SCJ->CJ_DESC3)
@ 67,001 PSAY "  Desconto 3 : "
@ 67,018 PSAY SCJ->CJ_DESC3 Picture "99.99%"
EndIf
If !Empty(SCJ->CJ_DESC4)
@ 67,026 PSAY "  Desconto 4 : "
@ 67,044 PSAY SCJ->CJ_DESC4 Picture "99.99%"
EndIf
*/



oPrint:Line (2600,0100,2600,2300)                // HORIZONTAL INICIO RODAPE
oPrint:Say  (2690,0110,"  TOTAL DO ORÇAMENTO : "        ,oFont8n)
oPrint:Say  (2690,0500,AllTrim(Transform(_nValTTot,"@E 999,999,999.99"))     ,oFont8n)

_nDescTot := _nValTTot - nTOTVAL

oPrint:Say  (2690,1000,"  DESCONTOS : "                 ,oFont8n)

If _nDescTot > 0
	oPrint:Say  (2690,1250,AllTrim(Transform(_nDescTot,"@E 999,999,999.99"))     ,oFont8n)
Else
	oPrint:Say  (2690,1250,"0,00"     ,oFont8n)
EndIf

oPrint:Say  (2685,1600,"          VALOR TOTAL : "       ,oFont10)
oPrint:Say  (2685,2000,AllTrim(Transform(nTOTVAL,"@E 999,999,999.99"))     ,oFont11)
oPrint:Line (2770,0100,2770,2300)                // HORIZONTAL OBSERVACAO
oPrint:Say  (2790,0110,"  OBSERVAÇÕES "        ,oFont10n)




//oPrint:Line (2800,0100,2800,2300)                // HORIZONTAL FINAL


lFlag     := .T.
lConfirma := .F.
dbSelectArea("SE1")
dbSetOrder(2)     // Cliente+loja+prefixo+numero+parcela+tipo
dbGotop()

If dbSeek(xFilial("SE1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA)
	_cOldCli := SE1->E1_CLIENTE
	
	WHILE !Eof() .And. SE1->E1_CLIENTE = _cOldCli .And. lFlag
		
		If SE1->E1_TIPO == "NCC" .Or. SE1->E1_TIPO == "AB-"
			IF SE1->E1_SALDO > 0
				lConfirma := .T.
			Else
				DbSkip()
				LooP
			EndIf
		Else
			DbSkip()
			LooP
		EndIf
		
		If lConfirma   // .And. SE1->E1_SALDO > 0
			oPrint:Say  (2850,0160,"- CLIENTE"        ,oFont8n)
			oPrint:Say  (2900,0210,"A T E N Ç Ã O! Este Cliente possui crédito no Financeiro."   ,oFont8n)
			//			@ 73,002 PSAY "ATENCAO! Este Cliente possui credito no Financeiro."
			lFlag := .F.
		Else
			DbSkip()
			LOOP
		EndIf
		
	EndDo
EndIf

If !Empty(SA1->A1_OBSERV)
	oPrint:Say  (2850,0160,"- CLIENTE"        ,oFont8n)
	oPrint:Say  (2950,0210,SA1->A1_OBSERV        ,oFont8n)
EndIf
//If !Empty(SA1->A1_X_OBS)
//	oPrint:Say  (2850,0160,"- CLIENTE"        ,oFont8n)
//	oPrint:Say  (3000,0210,SA1->A1_X_OBS        ,oFont8n)
//EndIf
If !Empty(SA1->A1_SUFRAMA)
	oPrint:Say  (2850,0160,"- CLIENTE"        ,oFont8n)
	oPrint:Say  (3050,0210,"SUFRAMA - "+SA1->A1_SUFRAMA     ,oFont8n)
EndIf
//If !Empty(SCJ->CJ_X_MENPD)
//	oPrint:Say  (3100,0160,"- PEDIDO"        ,oFont8n)
//	oPrint:Say  (3150,0210,SCJ->CJ_X_MENPD        ,oFont8n)
//EndIf

//If !Empty(SCJ->CJ_MENNOTA)
//	oPrint:Say  (3200,0160,"- NF"        ,oFont8n)
//	oPrint:Say  (3250,0210,SCJ->CJ_MENNOTA        ,oFont8n)
//EndIf



li := 3200


Return()         

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ fCriaPerg³ Autor ³                       ³ Data ³ 22/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fCriaPerg(_cPerg)
aSvAlias:={Alias(),IndexOrd(),Recno()}
i:=j:=0
aRegistros:={}
//                1      2    3               4  5     6      7  8  9  10 11  12 13         14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43
AADD(aRegistros,{_cPerg,"01","Orçamento           ? ","","","mv_ch1","C",06,00,00,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","SCJ","","","","",""})


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