#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 20/07/01
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function MATRPD2()        // incluido pelo assistente de conversao do AP5 IDE em 20/07/01

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

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
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � MATRPED  � Autor � Claudinei M. Benzi    � Data � 05.11.92 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Emissao da Pr�-Nota                                        낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe   � MATR730(void)                                              낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Generico                                                   낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� OBS      � Prog.Transf. em RDMAKE por Fabricio C.David em 07/06/97    낢�
굇�          � Adaptacao do lay-out segundo necessidade do cliente DOMEX  낢�
굇�          � para impressao dos pedidos de venda por Adriano em 02/02/00낢�
굇쿝ev. A    � Alter. de perguntas para impressao por SubClasse 14/11/00  낢�
굇�          � Programa p/ imp. de Relatorio de OF`s                      낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Define Variaveis                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
wnrel            :=""
tamanho          :="P"
titulo           :="Emissao de Listagem de Pedido"
cDesc1           :="Emiss꼘 de listagem de pedidos de venda, de acordo com"
cDesc2           :="intervalo informado na op뇙o Par긩etros."
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
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Verifica as perguntas selecionadas                          �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
pergunte("MTRPED",.F.)
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Variaveis utilizadas para parametros                        �
//� mv_par01              Do Pedido                             �
//� mv_par02              Ate o Pedido                          �
//� mv_par03              Da Data                               �
//� mv_par04              Ate Data                              �
//� mv_par05              Do Cliente                            �
//� mv_par06              Ate Cliente                           �
//� mv_par07              Da SubClasse                          �
//� mv_par08              Ate SubClasse                         �
//� mv_par09              Imprimir Margem                       �
//� mv_par10              Tipo de pedido                        �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

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

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Define Variaveis                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
tamanho        :="P"
titulo         :="EMISSAO DA CONFIRMACAO DO PEDIDO"
cDesc1         :="Emiss�o da confirma豫o dos pedidos de venda, de acordo com"
cDesc2         :="intervalo informado na op豫o Par�metros."
cDesc3         :=" "
nRegistro      := 0
cKey           :=""
nIndex         :=""
cIndex         :=""//  && Variaveis para a criacao de Indices Temp.
cCondicao      :=""

pergunte("MTRPED",.F.)


//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Busca na varial public __DRIVER o tipo de impressora escolhida �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Faz manualmente porque nao chama a funcao Cabec()                 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
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

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Ajuste feito por Fabr�cio, em 11/08/03, substituindo o uso de     �
//� IndRegua para DBCREATEIND e DBSETFILTER para ganho de performance �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

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
	//motivo: Devido a altera豫o da numera豫o dos pedidos de venda
	//foi necess�rio a inclus�o de par�metro para informar o tipo de pedido
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
@ li,0 psay "Relat�rio Total RELOF separado por classe de produto - Per�odo: "+dtoc(mv_par03)+" at� "+dtoc(mv_par04)
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

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Deleta Arquivo Temporario e Restaura os Indices Nativos.     �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
RetIndex("SC5")
// DBSetFilter()

// Comeco da modificacao - Fabr�cio (11/08/03)

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
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � ImpItem  � Autor � Claudinei M. Benzi    � Data � 05.11.92 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Emissao da Pr�-Nota                                        낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe e � ImpItem(void)                                              낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Matr730                                                    낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
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
