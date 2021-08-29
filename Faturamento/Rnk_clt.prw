#Include "Protheus.ch"
#include "rwmake.ch"   
#Include "Topconn.ch"    

User Function RNK_CLT2()

	Private cPerg 	:= "MTRPED"
	Private wnRel		:= "RELOF"
	Private cString	:= "SC6"
	Private cTitulo	:= "Emissao de Listagem de Pedidos"
	Private cDesc1	:= "Emissao de listagem de pedidos de venda, de acordo com"
	Private cDesc2	:= "intervalo informado na opcao Parametros."
	Private cDesc3	:= " "
	Private aOrdem	:= {"Cliente","Valor"}
	Private nLastKey	:= 0
	Private aReturn	:= {"Zebrado",1,"Administracao",1,2,1,"",2}
	
	Pergunte(cPerg,.F.)
	
	wnRel := SetPrint(cString,wnRel,cPerg,@cTitulo,cDesc1,cDesc2,cDesc3,.F.,aOrdem,.T.,"P")
	
	If nLastKey == 27
		Return
	EndIf
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
		Return
	EndIf

	@Prow(),0 psay CHR(27)
	
	RptStatus({||RNK_IMP2()})
	
	
Return

Static Function RNK_IMP2()

	Local cAlias := GetNextAlias()
	Local cQuery := ""
	Local aDados := {}
	Local nPos	 := 0
	Local nValIcms	:= 0
	Local nValIPI	:= 0
	Local nValSol	:= 0
	Local nValPis	:= 0
	Local nValCof	:= 0
	Local nValCsll	:= 0
	Local nI		:= 0
	Local nTotalBruto	:= 0
	Local nTotalNet	:= 0
	Local cChave	:= ""
	
	cQuery := " SELECT	SC5.C5_CLIENTE AS CLIENTE, "
	cQuery += "		SC5.C5_LOJACLI AS LOJACLI, "
	cQuery += "		SC5.C5_TIPO AS TIPO, "
	cQuery += "		SC5.C5_TIPOCLI AS TIPOCLI, "
	cQuery += "		SC6.C6_PRODUTO AS PRODUTO, "
	cQuery += "		SC6.C6_TES AS TES, "
	cQuery += "		SC6.C6_QTDVEN AS QTDVEN, "
	cQuery += "		SC6.C6_PRCVEN AS PRCVEN, "
	cQuery += "		SC6.C6_VALOR AS VALOR, "
	cQuery += "		SC6.C6_QTDENT AS QTDENT, "
	cQuery += "		SA1.A1_NOME AS NOME,  "
	cQuery += "		SA1.A1_EST AS EST,   "
	cQuery += "		SC6.C6_VALDESC AS VALDESC, "
	cQuery += " 	SC6.C6_NFORI AS NFORI, "
 	cQuery += "    SC6.C6_SERIORI AS SERIORI, "
  	cQuery += "		SB1.R_E_C_N_O_ AS RECSB1, "
  	cQuery += "		SB1.B1_DESC AS DESCPROD "	
	cQuery += "	FROM " + RetSqlName("SC5") + " SC5 "
	cQuery += "		INNER JOIN " + RetSqlName("SC6") + " SC6 ON SC5.C5_FILIAL = SC6.C6_FILIAL AND SC5.C5_NUM = SC6.C6_NUM "
	cQuery += "		INNER JOIN " + RetSqlName("SB1") + " SB1 ON SC6.C6_PRODUTO = SB1.B1_COD "
	cQuery += "		INNER JOIN " + RetSqlName("SA1") + " SA1 ON SC5.C5_CLIENTE = SA1.A1_COD AND SC5.C5_LOJACLI = SA1.A1_LOJA "
	cQuery += "	WHERE "
	cQuery += "		SC5.D_E_L_E_T_ <> '*' "
	cQuery += "		AND SC6.D_E_L_E_T_ <> '*' "
	cQuery += "		AND SB1.D_E_L_E_T_ <> '*' "
	cQuery += "		AND SA1.D_E_L_E_T_ <> '*' "
	cQuery += " 	AND SC5.C5_FILIAL = '" + xFilial("SC5") + "'"
	cQuery += "		AND SC5.C5_NUM BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
	cQuery += "		AND SC5.C5_EMISSAO BETWEEN '" + DtoS(MV_PAR03) + "' AND '" + DtoS(MV_PAR04) + "' "
	cQuery += "		AND SC5.C5_CLIENTE BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	If !Empty(MV_PAR10)
		cQuery += "		AND SC5.C5_XPVTIPO = '" + MV_PAR10 + "' "
	EndIf
	cQuery += "		AND SB1.B1_SUBCLAS BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
	If MV_PAR12 == 1
		cQuery += "		AND SC6.C6_QTDENT = SC6.C6_QTDVEN "
	ElseIf MV_PAR12 == 2
		cQuery += "		AND SC6.C6_QTDENT <> SC6.C6_QTDVEN "
	EndIf 
	//
	
//	dbUseArea( .T.,"TOPCONN", TcGenQry( ,,cQuery ), cAlias, .F., .T. )
	TCQuery cQuery New Alias (cAlias)

	DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())

	SetRegua((cAlias)->(RecCount()))
	
	While (cAlias)->(!Eof())
	
		If MV_PAR11 == 1
			cChave := SubStr(AllTrim((cAlias)->NOME),1,40) + Space(40-Len( SubStr(AllTrim((cAlias)->NOME),1,50))) + " - " + AllTrim((cAlias)->PRODUTO) + Space(15-Len(AllTrim((cAlias)->PRODUTO))) + " - " + SubStr((cAlias)->DESCPROD,1,40)
		Else
			cChave := AllTrim((cAlias)->NOME)
		EndIf
		
		nPos := aScan(aDados,{|x| x[1] == cChave})
		
		IncRegua() 
		
		MaFisIni(	(cAlias)->CLIENTE,;            
					(cAlias)->LOJACLI,;            
					"C",;                        
					(cAlias)->TIPO,;               
					(cAlias)->TIPOCLI,;               
					MaFisRelImp("MTR700",{"SC5","SC6"}),;
					,;                              
					,;                             
					"SB1")
		

		
		MaFisAdd((cAlias)->PRODUTO, (cAlias)->TES, (cAlias)->QTDVEN-(cAlias)->QTDENT, (cAlias)->PRCVEN, (cAlias)->VALDESC, (cAlias)->NFORI, (cAlias)->SERIORI,0, 0, 0, 0, 0, ((cAlias)->QTDVEN-(cAlias)->QTDENT) * (cAlias)->PRCVEN, 0, (cALias)->RECSB1, 0)
		
		MaFisLoad("IT_VALMERC", (cAlias)->VALOR, 1)
		
		MaFisEndLoad(1,1)
		 
		MafisRecal(,1)
		
		nValPis		:= 0
		nValCof		:= 0
		nValIPI 	:= MaFisRet(1,"IT_VALIPI")
		nValIcms 	:= MaFisRet(1,"IT_VALICM") 
		nValSol 	:= MaFisRet(1,"IT_VALSOL")
		nValCof		:= MaFisRet(1,"IT_VALCOF") + MaFisRet(1,"IT_VALIV6")
		nValCsll	:= 0
		nValPis		:= MaFisRet(1,"IT_VALPIS") + MaFisRet(1,"IT_VALIV5")
		If (cAlias)->EST <> "EX" 
			nValPis := (cAlias)->VALOR * (0.0760)
			nValCof := (cAlias)->VALOR * (0.0165) 
		EndIf
		
		If nPos == 0
			aAdd(aDados,{cChave,(cAlias)->VALOR + nValSol + nValIpi,(cAlias)->VALOR - nValIcms - nValPis - nValCof - nValCsll,nValIPI,nValIcms,nValSol,nValPis,nValCof,nValCsll})
		Else
			
			aDados[nPos][2] += (cAlias)->VALOR + nValSol + nValIpi
			aDados[nPos][3] += (cAlias)->VALOR - nValIcms - nValPis - nValCof - nValCsll
			aDados[nPos][4] += nValIPI 
			aDados[nPos][5] += nValIcms 
			aDados[nPos][6] += nValSol 
			aDados[nPos][7] += nValPis
			aDados[nPos][8] += nValCof
			aDados[nPos][9] += nValCsll
		EndIf
		
		MaFisEnd()
		
		(cAlias)->(DbSkip())
	EndDo   
	    
	If aReturn[8] == 1
		ASort(aDados, , , {|x,y|x[1] < y[1]})	
	ElseIf aReturn[8] == 2
	   ASort(aDados, , , {|x,y|x[2] < y[2]})	                                  
	EndIf
	
	@ Prow()+1, 0 psay "Cliente"
	@ Prow(), 180 psay "Valor Bruto"
	@ Prow(), 200 psay "Valor Net"
	
//	@ Prow()+1, 80 psay "IPI"
//	@ Prow(), 100 psay "ICMS"
//	@ Prow(), 120 psay "ICMS SOL"
//	@ Prow(), 140 psay "PIS"
//	@ Prow(), 160 psay "COFINS"
//	@ Prow(), 180 psay "CSLL"


	For nI := 1 to Len(aDados)
	
		@ Prow()+1, 0 psay aDados[nI][1]
		@ Prow(), 180 psay aDados[nI][2] picture PesqPict("SC6","C6_VALOR",14)
		@ Prow(), 200 psay aDados[nI][3] picture PesqPict("SC6","C6_VALOR",14)

	//	@ Prow()+1, 80 psay aDados[nI][4] picture PesqPict("SC6","C6_VALOR",14)
	//	@ Prow(), 100 psay aDados[nI][5] picture PesqPict("SC6","C6_VALOR",14)
	//	@ Prow(), 120 psay aDados[nI][6] picture PesqPict("SC6","C6_VALOR",14)
	//	@ Prow(), 140 psay aDados[nI][7] picture PesqPict("SC6","C6_VALOR",14)
	//	@ Prow(), 160 psay aDados[nI][8] picture PesqPict("SC6","C6_VALOR",14)
	//	@ Prow(), 180 psay aDados[nI][9] picture PesqPict("SC6","C6_VALOR",14)
			              
		nTotalBruto += aDados[nI][2]
		nTotalNet 	+= aDados[nI][3]
	
	Next nI
	
	@ Prow()+2,050 PSAY "TOTAL GERAL -----> "
 	@ Prow(),070 PSAY nTotalBruto Picture PesqPict("SC6","C6_VALOR",14)
 	@ Prow(),100 PSAY nTotalNet	Picture PesqPict("SC6","C6_VALOR",14)
    
    Set device to screen

	If aReturn[5] == 1
		Set Printer To
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	
	MS_FLUSH()

Return

			


#IFNDEF WINDOWS
#DEFINE PSAY SAY
#ENDIF

User Function RNK_CLT()   // incluido pelo assistente de conversao do AP5 IDE em 20/07/01

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
SetPrvt("SUBCLASSES,SCPOS,SCTOTAL,PRODVALOR,I,TOTALOF")
SetPrvt("CLTAT,ATCAMPOS")
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
aReturn          := { "Zebrado", 1,"Administracao", 1, 2, 1, "",2 }
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
aOrdem           := { "Cliente", "Valor" }
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
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrdem,.T.,"P")

If nLastKey==27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Return
Endif

dbselectarea("SC6")
dbsetorder(1)

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
cDesc1         :="Emiss„o da confirmac„o dos pedidos de venda, de acordo com"
cDesc2         :="intervalo informado na op‡„o Parƒmetros."
cDesc3         :=" "
nRegistro      := 0
//cKey           :=""
//nIndex         :=""
//cIndex         :=""//  && Variaveis para a criacao de Indices Temp.
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

@Prow(),0 psay CHR(27)//+impcomand

// Organiza por cliente

atCampos := {}
aadd(atcampos, { "TB_NOME",  "C", 60, 0 })
aadd(atcampos, { "TB_TOTAL", "N", 12, 2 })
CLTAT := criatrab(atcampos, .t.)
dbusearea(.t.,,CLTAT,CLTAT,.t.,.f.)

indregua(CLTAT,CLTAT,"TB_NOME",,,"Selecionando registros ...")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz manualmente porque nao chama a funcao Cabec()                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//cIndex  := CriaTrab(nil,.f.)
//dbSelectArea("SC5")
//cKey    := IndexKey()
//cFilter := dbFilter()
//cFilter := cFilter := If( Empty( cFilter ),""," .And. " )

//#IFDEF AS400
//    cFilter := cFilter:= 'C5_FILIAL == "'+xFilial("SC5")+'" .And. C5_NUM >= "'+mv_par01+'"'
//#ELSE
//    cFilter := cFilter:= "C5_FILIAL==xFilial('SC5') .And. C5_NUM >= mv_par01"
//#ENDIF

//IndRegua("SC5",cIndex,cKey,,cFilter,"Selecionando Registros...")

//nIndex := RetIndex("SC5")
DbSelectArea("SC5")
//#IFNDEF AS400
//    DbSetIndex(cIndex)
//#ENDIF
//DbSetOrder(nIndex+1)
dbSetOrder(1)
DbGoTop()

SetRegua(RecCount())		// Total de Elementos da regua

meutotal := 0

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
//motivo: Devido a alteração da numeração dos pedidos de venda 
//foi necessário a inclusão de parâmetro para informar o tipo de pedido 
//a ser considerado.
   If SC5->C5_XPVTIPO <> mv_par10 
      dbSkip()
      Loop
   Endif 
	
	cPedido := C5_NUM   
	
	dbSelectArea("SC6")
	dbSeek(xFilial()+cPedido)
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
	
    dbselectarea("SA1")
    dbseek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
//    @Prow()+1,0 psay A1_NOME
/*dbselectarea(CLTAT)
if !dbseek(SA1->A1_NOME,.f.)
  reclock(CLTAT,.t.)
  TB_NOME := SA1->A1_NOME
  TB_TOTAL := 0
  msunlock()
endif  */

   totalof := 0

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
		
		ImpItem()
		dbSelectArea("SC6")
		dbSkip()

	Enddo
			
//    @Prow(), 65 psay SC5->C5_NUM
//    @Prow(), 76 psay totalof Picture PesqPict("SC6","C6_VALOR",14)
dbselectarea(CLTAT)
if !dbseek(SA1->A1_NOME,.f.)
  reclock(CLTAT,.t.)
  TB_NOME := SA1->A1_NOME
  TB_TOTAL := totalof
else
  reclock(CLTAT)
  TB_TOTAL := TB_TOTAL + totalof  
endif
  msunlock() 

    meutotal := meutotal + totalof

	dbSelectArea("SC5")
	dbSkip()
	
	IncRegua()
Enddo

dbselectarea(CLTAT)
dbclearind()
indregua(CLTAT,CLTAT,atCampos[aReturn[8]][1])
dbgobottom()
while !bof()
  @Prow()+1, 0 psay TB_NOME
  @Prow(), 70 psay TB_TOTAL picture PesqPict("SC6","C6_VALOR",14)
  dbskip(-1)
enddo
/*    @ li,0 psay "Relatorio Total RELOF separado por classe de produto - Periodo: "+dtoc(mv_par03)+" ate "+dtoc(mv_par04)
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
    next*/
//    @ li+2,054 PSAY "TOTAL GERAL -----> "
//    @ li+2,073 PSAY meutotal Picture PesqPict("SC6","C6_VALOR",14)
    @ Prow()+2,054 PSAY "TOTAL GERAL -----> "
    @ Prow()+2,073 PSAY meutotal Picture PesqPict("SC6","C6_VALOR",14)
    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta Arquivo Temporario e Restaura os Indices Nativos.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("SC5")
// DBSetFilter()

//Ferase(cIndex+OrdBagExt())

// apaga arq. de trabalhos clientes

dbselectarea(CLTAT)
dbclosearea()
ferase(CLTAT+ordbagext())

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
dbSeek(xFilial()+SC6->C6_PRODUTO)

// IMPRESSAO POR SUBCLASSE

   IF (SB1->B1_SUBCLAS <= mv_par08) .AND. (SB1->B1_SUBCLAS >= mv_par07)

        prodvalor := NoRound(SC6->C6_VALOR*((SC6->C6_IPI/100)+1))
//        @li,080 PSAY prodvalor Picture PesqPict("SC6","C6_VALOR",14)
//        li := li + 1
        totalof := totalof + prodvalor
//        scpos := ascan(subclasses, sb1->b1_subclass)
//        if scpos > 0
//          sctotal[scpos] := sctotal[scpos] + prodvalor
//        else
//          aadd(subclasses, sb1->b1_subclass)
//          aadd(sctotal, prodvalor)
//        endif
EndIf       

dbSelectArea("SC6")

Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 20/07/01