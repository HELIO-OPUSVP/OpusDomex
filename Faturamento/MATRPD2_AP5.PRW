#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 20/07/01
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function MATRPD2()        // incluido pelo assistente de conversao do AP5 IDE em 20/07/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("WNREL,TAMANHO,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("NREGISTRO,CKEY,NINDEX,CINDEX,CCONDICAO,LEND")
SetPrvt("CPERG,ARETURN,NOMEPROG,NLASTKEY,NBEGIN,ALINHA")
SetPrvt("LI,LIMITE,LRODAPE,CPICTQTD,NTOTQTD,NTOTVAL")
SetPrvt("NGERAL,APEDCLI,CSTRING,_CTIPIMP,IMPCOMAND,CFILTER")
SetPrvt("CPEDIDO,LIMPIT,CHEADER,NPED,CMOEDA,CCAMPO")
SetPrvt("CCOMIS,NIPI,NVIPI,NBASEIPI,NVALBASE,LIPIBRUTO")
SetPrvt("NPERRET,CESTADO,TNORTE,CESTCLI,CINSCRCLI,MEUTOTAL")
SetPrvt("SUBCLASSES,SCPOS,SCTOTAL,PRODVALOR,I")
meutotal := 0

#IFNDEF WINDOWS
	// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 20/07/01 ==>     #DEFINE PSAY SAY
#ENDIF
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATRPED  ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.11.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao da Pr‚-Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MATR730(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ OBS      ³ Prog.Transf. em RDMAKE por Fabricio C.David em 07/06/97    ³±±
±±³          ³ Adaptacao do lay-out segundo necessidade do cliente DOMEX  ³±±
±±³          ³ para impressao dos pedidos de venda por Adriano em 02/02/00³±±
±±³Rev. A    ³ Alter. de perguntas para impressao por SubClasse 14/11/00  ³±±
±±³          ³ Programa p/ imp. de Relatorio de OF`s                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel            :=""
tamanho          :="P"
titulo           :="Emissao de Listagem de Pedido"
cDesc1           :="Emiss„o de listagem de pedidos de venda, de acordo com"
cDesc2           :="intervalo informado na op‡„o Parƒmetros."
cDesc3           :=" "
nRegistro        := 0
cKey             :=""
nIndex           :=""
cIndex           :=""//  && Variaveis para a criacao de Indices Temp.
cCondicao        :=""
lEnd             := .T.
cPerg            :="MTRPED"
aReturn          := { "Zebrado", 1,"Administracao", 1, 2, 1, "",0 }
nomeprog         :="RELPED"
nLastKey         := 0
nBegin           :=0
aLinha           :={ }
li               := 0
limite           :=132
lRodape          :=.F.
cPictQtd         :=""
nTotQtd          := 0
nTotVal			 := 0
nGeral           := 0
aPedCli          := {}
wnrel            := "RELOF"
cString          := "SC6"
scpos            := 0
subclasses       := {}
sctotal          := {}
prodvalor        := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("MTRPED",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01              Do Pedido                             ³
//³ mv_par02              Ate o Pedido                          ³
//³ mv_par03              Da Data                               ³
//³ mv_par04              Ate Data                              ³
//³ mv_par05              Do Cliente                            ³
//³ mv_par06              Ate Cliente                           ³
//³ mv_par07              Da SubClasse                          ³
//³ mv_par08              Ate SubClasse                         ³
//³ mv_par09              Imprimir Margem                       ³
//³ mv_par10              Tipo de pedido                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,"P")

If nLastKey==27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Return
Endif

#IFDEF WINDOWS
	RptStatus({||C730Imp()})// Substituido pelo assistente de conversao do AP5 IDE em 20/07/01 ==>     RptStatus({||Execute(C730Imp)})
	Return
	// Substituido pelo assistente de conversao do AP5 IDE em 20/07/01 ==>     Function C730IMP
	Static Function C730IMP()
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
tamanho        :="P"
titulo         :="EMISSAO DA CONFIRMACAO DO PEDIDO"
cDesc1         :="Emissão da confirmação dos pedidos de venda, de acordo com"
cDesc2         :="intervalo informado na opção Parâmetros."
cDesc3         :=" "
nRegistro      := 0
cKey           :=""
nIndex         :=""
cIndex         :=""//  && Variaveis para a criacao de Indices Temp.
cCondicao      :=""

pergunte("MTRPED",.F.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busca na varial public __DRIVER o tipo de impressora escolhida ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SubStr( __DRIVER, 1, 4) == "HPLJ"
	_cTipImp := "L"
	impcomand := "(s0p17.50h0T"
ElseIf SubStr( __DRIVER, 1, 2) == "HP"
	_cTipImp := "J"
	impcomand := "(s15H"
ElseIf SubStr( __DRIVER, 1, 4) == "EPSO"
	_cTipImp := "M"
Else
	_cTipImp := "J"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz manualmente porque nao chama a funcao Cabec()                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cIndex  := CriaTrab(nil,.f.)
dbSelectArea("SC5")
cKey    := IndexKey()
cFilter := dbFilter()
cFilter := cFilter := If( Empty( cFilter ),""," .And. " )

#IFDEF AS400
	cFilter := cFilter:= 'C5_FILIAL == "'+xFilial("SC5")+'" .And. C5_NUM >= "'+mv_par01+'"'
#ELSE
	cFilter := cFilter:= "C5_FILIAL==xFilial('SC5') .And. C5_NUM >= mv_par01"
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajuste feito por Fabrício, em 11/08/03, substituindo o uso de     ³
//³ IndRegua para DBCREATEIND e DBSETFILTER para ganho de performance ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//IndRegua("SC5",cIndex,cKey,,cFilter,"Selecionando Registros...")

// Comeco da modificacao

//dbcreateind(cIndex, cKey)
//dbsetfilter({|| &cfilter}, cFilter)

// Fim da modificacao

//nIndex := RetIndex("SC5")
//DbSelectArea("SC5")
//#IFNDEF AS400
//    DbSetIndex(cIndex)
//#ENDIF
//DbSetOrder(nIndex+1)
SC5->(dbSetOrder(1))
SC5->(DbGoTop())

SetRegua(SC5->(RecCount()))		// Total de Elementos da regua

While SC5->(!Eof()) .And. SC5->C5_NUM <= mv_par02
	
	If SC5->C5_EMISSAO < mv_par03 .OR. SC5->C5_EMISSAO > mv_par04
		SC5->(dbSkip())
		IncRegua()
		Loop
	EndIf
	If SC5->C5_CLIENTE < mv_par05 .OR. SC5->C5_CLIENTE > mv_par06
		SC5->(dbSkip())
		IncRegua()
		Loop
	Endif
	If SC5->C5_NUM < mv_par01 .OR. SC5->C5_NUM > mv_par02
		SC5->(dbSkip())
		IncRegua()
		Loop
	Endif
	
	//alterado por Marcos Rezende
	//data: 17/10/2012
	//motivo: Devido a alteração da numeração dos pedidos de venda
	//foi necessário a inclusão de parâmetro para informar o tipo de pedido
	//a ser considerado.
	If SC5->C5_XPVTIPO <> mv_par10
		SC5->(dbSkip())
		IncRegua()
		Loop
	Endif
	
	#IFNDEF WINDOWS
		If LastKey() == 286    //ALT_A
			lEnd := .t.
			exit
		End
	#ENDIF
	
	IF LastKey() == 286
		@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	Endif

	cPedido := SC5->C5_NUM
	dbSelectArea("SC6")
	SC6->(dbSeek(xFilial("SC6")+SC5->C5_NUM))
	
	While SC6->(!Eof()) .And. SC6->C6_NUM == SC5->C5_NUM
		#IFNDEF WINDOWS
			If LastKey() == 286    //ALT_A
				lEnd := .t.
			End
		#ENDIF
		
		IF LastKey()==27
			@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
			Exit
		Endif
		
		ImpItem()
		dbSelectArea("SC6")
		dbSkip()
		
	Enddo
	
	dbSelectArea("SC5")
	dbSkip()
	
	IncRegua()
Enddo
@ li,0 psay chr(27) + "E" + chr(27) + "&k4S" + chr(27) + "(19U"
@ li,0 psay "Relatório Total RELOF separado por classe de produto - Período: "+dtoc(mv_par03)+" até "+dtoc(mv_par04)
li := li + 2
@ li,0 psay "Classe"
@ li,50 psay "Valor"
li := li + 3
for i := 1 to len(subclasses)
	@ li,0 psay alltrim(subclasses[i])
	@ li,47 psay sctotal[i] picture PesqPict("SC6","C6_VALOR",14)
	li := li + 1
	@ li,0 psay replicate("-",132)
	li := li + 1
next i
@ li+2,054 PSAY "TOTAL GERAL -----> "
@ li+2,073 PSAY meutotal Picture PesqPict("SC6","C6_VALOR",14)
li := li + 1
//    @ li, 0 psay chr(12)
@li, 0 psay chr(27)+"&l0H"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta Arquivo Temporario e Restaura os Indices Nativos.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("SC5")
// DBSetFilter()

// Comeco da modificacao - Fabrício (11/08/03)

dbclearfil()

//if Ferase(cIndex+OrdBagExt()) == -1 .and. OrdBagExt() == ".IDX"
//  Ferase(cIndex+".CDX")
//endif
// Fim da modificacao

dbSelectArea("SC6")
// DBSetFilter()
dbSetOrder(1)
dbGotop()
Set device to screen

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

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
// Substituido pelo assistente de conversao do AP5 IDE em 20/07/01 ==> Function ImpItem
Static Function ImpItem()

dbSelectArea("SB1")
dbSeek(xFilial("SB1")+SC6->C6_PRODUTO)

// IMPRESSAO POR SUBCLASSE
IF SB1->(!Eof()) .And. (SB1->B1_SUBCLAS <= mv_par08) .AND. (SB1->B1_SUBCLAS >= mv_par07)
	
	prodvalor := NoRound(SC6->C6_VALOR*((SC6->C6_IPI/100)+1))
	//        @li,080 PSAY prodvalor Picture PesqPict("SC6","C6_VALOR",14)
	//        li := li + 1
	meutotal := meutotal + prodvalor
	scpos := ascan(subclasses, sb1->b1_subclas)
	if scpos > 0
		sctotal[scpos] := sctotal[scpos] + prodvalor
	else
		aadd(subclasses, sb1->b1_subclas)
		aadd(sctotal, prodvalor)
	endif
EndIf

dbSelectArea("SC6")

Return(nil)
// incluido pelo assistente de conversao do AP5 IDE em 20/07/01
