#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 20/07/01
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function MATRPED()        // incluido pelo assistente de conversao do AP5 IDE em 20/07/01

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
SetPrvt("NPERRET,CESTADO,TNORTE,CESTCLI,CINSCRCLI,")

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
li               :=80
limite           :=132
lRodape          :=.F.
cPictQtd         :=""
nTotQtd          := 0
nTotVal			 := 0
nGeral           := 0
aPedCli          := {}
wnrel            := "RELOF"
cString          := "SC6"
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
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,"P")

If nLastKey==27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Return
Endif

// Inserido por Fabr�cio Becherini (22/09/04)
if MV_PAR09 == 1
	limite := limite + 15
endif

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
cDesc1         :="Emiss꼘 da confirmac꼘 dos pedidos de venda, de acordo com"
cDesc2         :="intervalo informado na op뇙o Par긩etros."
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
//dbsetfilter({|| &cFilter}, cFilter)

// Fim da modificacao

//nIndex := RetIndex("SC5")
//DbSelectArea("SC5")
//#IFNDEF AS400
//    DbSetIndex(cIndex)
//#ENDIF
//DbSetOrder(nIndex+1)
dbSetOrder(1)
DbGoTop()

SetRegua(RecCount())		// Total de Elementos da regua

While !Eof() .And. C5_NUM <= mv_par02
	
	If C5_EMISSAO < mv_par03 .OR. C5_EMISSAO > mv_par04
		dbSkip()
		IncRegua()
		Loop
	EndIf
	If C5_CLIENTE < mv_par05 .OR. C5_CLIENTE > mv_par06
		dbSkip()
		IncRegua()
		Loop
	Endif
	If C5_NUM < mv_par01 .OR. C5_NUM > mv_par02
		dbSkip()
		IncRegua()
		Loop
	Endif
	//alterado por Marcos Rezende
	//data: 17/10/2012
	//motivo: Devido a altera豫o da numera豫o dos pedidos de venda
	//foi necess�rio a inclus�o de par�metro para informar o tipo de pedido
	//a ser considerado.
	If SC5->C5_XPVTIPO <> mv_par10
		dbSkip()
		IncRegua()
		Loop
	Endif
	
	
	nTotQtd:=0
	nTotVal:=0
	
	cPedido := C5_NUM
	dbSelectArea("SA4")
	dbSeek(xFilial()+SC5->C5_TRANSP)
	dbSelectArea("SA3")
	dbSeek(xFilial()+SC5->C5_VEND1)
	dbSelectArea("SE4")
	dbSeek(xFilial()+SC5->C5_CONDPAG)
	
	dbSelectArea("SC6")
	dbSeek(xFilial()+cPedido)
	cPictQtd := PESQPICTQT("C6_QTDVEN",10)
	//nRegistro:= RECNO()
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
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Monta tabela de pedidos do cliente p/ o cabe놹lho            �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	aPedCli:= {}
	While !Eof() .And. C6_NUM == SC5->C5_NUM
		IF !Empty(SC6->C6_PEDCLI) .and. Ascan(aPedCli,SC6->C6_PEDCLI) == 0
			AAdd(aPedCli,SC6->C6_PEDCLI)
		ENDIF
		dbSkip()
	Enddo
	aSort(aPedCli)
	
	//dbGoTo( nRegistro )
	dbSelectArea("SC6")
	dbSeek(xFilial()+cPedido)
	
	lImpIt := .F.
	
	If li+6 < 60
		ImpCabec()
		lImpIt := .F.
	Else
		lImpIt := .T.
	EndIf
	
	dbSelectArea("SC6")
	
	While !Eof() .And. SC6->C6_NUM == SC5->C5_NUM
		#IFNDEF WINDOWS
			If LastKey() == 286    //ALT_A
				lEnd := .t.
			End
		#ENDIF
		
		IF LastKey()==27
			@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
			Exit
		Endif
		
		If li > 56 .OR. lImpIt
			If lRodape
				//            ImpRodape()
				@ li,001 PSAY Replicate("-",limite)
				lRodape := .F.
			Endif
			li := 0
			ImpCabec()
		Endif
		
		ImpItem()
		dbSelectArea("SC6")
		dbSkip()
		li:=li+1
		
	Enddo
	
	IF lRodape
		ImpRodape()
		lRodape:=.F.
	Endif
	
	dbSelectArea("SC5")
	dbSkip()
	
	IncRegua()
Enddo
@ li+2,054 PSAY "TOTAL GERAL -----> "
@ li+2,073 PSAY nGeral Picture PesqPict("SC6","C6_VALOR",14)
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Deleta Arquivo Temporario e Restaura os Indices Nativos.     �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
RetIndex("SC5")
// DBSetFilter()

// Comeco da modificacao - Fabr�cio (11/08/03)

//dbclearfil()
//if Ferase(cIndex+OrdBagExt()) == -1 .and. OrdBagExt() == ".IDX"
//  Ferase(cIndex+".CDX")
//endif

// Fim da modificacao

//Ferase(cIndex+OrdBagExt())

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
굇쿑un뇚o    � ImpCabec � Autor � Claudinei M. Benzi    � Data � 05.11.92 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Emissao da Pr�-Nota                                        낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe e � ImpCabec(void)                                             낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Matr730                                                    낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 20/07/01 ==> Function ImpCabec
Static Function ImpCabec()

lImpIt      := .F.
lRodape     := .T.
cHeader     :=""
nPed        :=""
cMoeda      :=""
cCampo      :=""
cComis      :=""
cHeader     := "It Codigo          Desc. do Material    TES UM    Quant.  Valor Unit. IPI ICM ISS Vl.Tot.C/IPI Entrega Fat. O.M.  Qtd.Fat.     Saldo"
// Inserido por Fabr�cio Becherini (22/09/04)
if MV_PAR09 == 1
	cHeader := cHeader + "   Margem Bruta"
endif
li := li + 1

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Posiciona registro no cliente do pedido                     �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

IF !(SC5->C5_TIPO$"DB")
	dbSelectArea("SA1")
	dbSeek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
Else
	dbSelectArea("SA2")
	dbSeek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
Endif

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Busca na varial public __DRIVER o tipo de impressora escolhida �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
impcomand := "(s15H"
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


@ li,001 PSAY CHR(27) + impcomand

@ li,001 PSAY Replicate("-",limite)
li := li + 1

// Primeiro cabecalho
IF !(SC5->C5_TIPO$"DB")
	@ li,000 PSAY "| "+SA1->A1_COD+"/"+SA1->A1_LOJA+" "+substr(SA1->A1_NOME,1,40)
	@ li,058 PSAY SA1->A1_CGC    Picture "@R 99.999.999/9999-99"
	@ li,077 PSAY "IE: "+alltrim(SA1->A1_INSCR)
	@ li,100 PSAY "| EMISSAO: "
	//BOX(SC5->C5_DMXORC)
	//MSGBOX(SC5->C5_NUM)
	//msgbox(SC5->C5_EMISSAO)
	@ li,111 PSAY SC5->C5_EMISSAO
	@ li,121 PSAY "PED. "+SC5->C5_NUM
	li := li + 1
	@ li,000 PSAY "| "+IF( !Empty(SA1->A1_ENDENT) .And. SA1->A1_ENDENT #SA1->A1_END,;
	SA1->A1_ENDENT, SA1->A1_END )
	@ li,042 PSAY SA1->A1_MUN
	@ li,059 PSAY SA1->A1_EST
	@ li,062 PSAY SA1->A1_CEP
	@ li,074 PSAY "CON.PGT: "+SE4->E4_DESCRI
Else
	@ li,000 PSAY "| "+SA2->A2_COD+"/"+SA2->A2_LOJA+" "+SA2->A2_NOME
	@ li,052 PSAY SA2->A2_CGC    Picture "@R 99.999.999/9999-99"
	@ li,071 PSAY "IE: "+SA2->A2_INSCR
	@ li,100 PSAY "| EMISSAO: "
	@ li,111 PSAY SC5->C5_EMISSAO
	@ li,121 PSAY "PED. "+SC5->C5_NUM
	li := li + 1
	@ li,000 PSAY "| "+ SA2->A2_END
	@ li,042 PSAY SA2->A2_MUN
	@ li,059 PSAY SA2->A2_EST
	@ li,062 PSAY SA2->A2_CEP
	@ li,074 PSAY "CON.PGT: "+SE4->E4_DESCRI
Endif
@ li,100 PSAY "| C.N.->" + SC5->C5_DMXORC
li := li + 1
@ li,000 PSAY Replicate("-",limite)
li:=li+1
@ li,000 PSAY cHeader
li:=li+1
@ li,000 PSAY Replicate("-",limite)
li:=li+1
// Substituido pelo assistente de conversao do AP5 IDE em 20/07/01 ==> __Return( .T. )
Return( .T. )        // incluido pelo assistente de conversao do AP5 IDE em 20/07/01

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
nIPI     :=0
nVipi    :=0
nBaseIPI :=100
nValBase := 0
lIpiBruto:=IIF(GETMV("MV_IPIBRUT")=="S",.T.,.F.)

dbSelectArea("SB1")
dbSeek(xFilial()+SC6->C6_PRODUTO)
dbSelectArea("SF4")
dbSeek(xFilial()+SC6->C6_TES)
IF SF4->F4_IPI == "S"
	nBaseIPI    := IIF(SF4->F4_BASEIPI > 0,SF4->F4_BASEIPI,100)
	nIPI 		:= SB1->B1_IPI
	nValBase	:= If(lIPIBruto .And. SC6->C6_PRUNIT > 0,SC6->C6_PRUNIT,SC6->C6_PRCVEN)*SC6->C6_QTDVEN
	nVipi		:= nValBase * (nIPI/100)*(nBaseIPI/100)
Endif

// IMPRESSAO POR SUBCLASSE

IF (SB1->B1_SUBCLAS <= mv_par08) .AND. (SB1->B1_SUBCLAS >= mv_par07)
	
	@li,000 PSAY SC6->C6_ITEM
	@li,003 PSAY SC6->C6_PRODUTO
	@li,019 PSAY SUBS(IIF(Empty(SC6->C6_DESCRI),SB1->B1_DESC,SC6->C6_DESCRI),1,20)
	@li,040 PSAY SC6->C6_TES
	@li,044 PSAY SC6->C6_UM
	@li,047 PSAY SC6->C6_QTDVEN     Picture cPictQtd
	@li,057 PSAY SC6->C6_PRCVEN     Picture PesqPict("SC6","C6_PRCVEN",12)
	@li,071 PSAY SC6->C6_IPI        Picture "99"
	
	a730VerIcm()
	
	@li,074 PSAY nPerRet Picture "99"
	@li,077 PSAY SB1->B1_ALIQISS    Picture "99"
	@li,080 PSAY NoRound(SC6->C6_VALOR*((SC6->C6_IPI/100)+1)) Picture PesqPict("SC6","C6_VALOR",14)
	//If !GetMV("MV_XXINVDT")   
	//   @li,095 PSAY SC6->C6_ENTREG   // Tratado
	//Else
	   @li,095 PSAY SC6->C6_DTFATUR  // Tratado na segunda troca
	//EndIf
	@li,104 PSAY IIF(EMPTY(SC6->C6_NOTA),"N","S")
	dbSelectArea("SC2")
	dbSetOrder(6)
	dbSeek(xFilial()+SC6->C6_NUM+SC6->C6_PRODUTO )
	//dbSelectArea("SC6")
	@li,107 PSAY SC2->C2_NUM
	//@li,109 PSAY SC6->C6_LOCAL
	@li,112 PSAY SC6->C6_QTDEMP + SC6->C6_QTDLIB + SC6->C6_QTDENT Picture PesqPict("SC6","C6_QTDLIB",10)
	@li,122 PSAY SC6->C6_QTDVEN - SC6->C6_QTDEMP + SC6->C6_QTDLIB - SC6->C6_QTDENT Picture PesqPict("SC6","C6_QTDLIB",10)
	// Inserido por Fabr�cio Becherini (22/09/04)
	if MV_PAR09 == 1
		@li,131 PSAY SC6->C6_MARGEM Picture PesqPict("SC6","C6_MARGEM",10)
	endif
	
	nTotQtd := nTotQtd + SC6->C6_QTDVEN
	nTotVal := nTotVal + NoRound(SC6->C6_VALOR*((SC6->C6_IPI/100)+1))
	nGeral  := nGeral + NoRound(SC6->C6_VALOR*((SC6->C6_IPI/100)+1))
	
EndIf

dbSelectArea("SC6")

Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 20/07/01

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � ImpRodape� Autor � Claudinei M. Benzi    � Data � 05.11.92 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Emissao da Pr�-Nota                                        낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe e � ImpRoadpe(void)                                            낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Matr730                                                    낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/

// Substituido pelo assistente de conversao do AP5 IDE em 20/07/01 ==> Function ImpRodape
Static Function ImpRodape()
@ li,001 PSAY Replicate("-",limite)
li := li + 1
@ li,001 PSAY " T O T A I S "
@ li,047 PSAY nTotQtd    Picture cPictQtd
@ li,077 PSAY nTotVal    Picture PesqPict("SC6","C6_VALOR",17)
//nGeral := nGeral + nTotval
li := li + 1

// Substituido pelo assistente de conversao do AP5 IDE em 20/07/01 ==> __Return( NIL )
Return( NIL )        // incluido pelo assistente de conversao do AP5 IDE em 20/07/01

/*/
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    쿌730verIcm� Autor � Claudinei M. Benzi    � Data � 11.02.92 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Rotina para verificar qual e o ICM do Estado               낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � MATA460                                                    낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 20/07/01 ==> Function A730VerIcm
Static Function A730VerIcm()

nPerRet:=0                // Percentual de retorno
cEstado:=GetMV("mv_estado")
tNorte:=GetMV("MV_NORTE")
cEstCli:=IIF(SC5->C5_TIPO$"DB",SA2->A2_EST,SA1->A1_EST)
cInscrCli:=IIF(SC5->C5_TIPO$"DB",SA2->A2_INSCR,SA1->A1_INSCR)

If SF4->F4_ICM == "S"
	IF !(SC5->C5_TIPO $ "D")
		If SC5->C5_TIPOCLI == "F" .and. Empty(cInscrCli)
			nPerRet := iif(SB1->B1_PICM>0,SB1->B1_PICM,GetMV("MV_ICMPAD"))
		Elseif SB1->B1_PICM > 0 .And. cEstCli == cEstado
			nPerRet := SB1->B1_PICM
		Elseif cEstCli == cEstado
			nPerRet := GetMV("MV_ICMPAD")
		Elseif cEstCli $ tNorte .And. At(cEstado,tNorte) == 0
			nPerRet := 7
		Elseif SC5->C5_TIPOCLI == "X"
			nPerRet := 13
		Else
			nPerRet := 12
		Endif
	Else
		If cEstCLI == GetMV("MV_ESTADO")
			nPerRet := GetMV("MV_ICMPAD")
		Elseif !(cEstCli $ GetMV("MV_NORTE")) .And. ;
			GetMv("mv_estado") $ GetMV("MV_NORTE")
			nPerRet := 7
		Else
			nPerRet := 12
		Endif
		If SB1->B1_PICM != 0 .And. (cEstCli==GetMv("MV_ESTADO"))
			nPerRet := SB1->B1_PICM
		Endif
	Endif
Endif
// Substituido pelo assistente de conversao do AP5 IDE em 20/07/01 ==> __Return(nPerRet)
Return(nPerRet)        // incluido pelo assistente de conversao do AP5 IDE em 20/07/01