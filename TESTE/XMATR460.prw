#INCLUDE "MATR460.CH"                           
#INCLUDE "PROTHEUS.CH"                          
#DEFINE TT	Chr(254)+Chr(254)	// Substituido p/ "TT"   

STATIC lCalcTer := NIL // utilziada na funcao R460Terceiros

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MATR460  ³ Autor ³ Nereu Humberto Junior ³ Data ³ 31.07.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio do Inventario, Registro Modelo P7                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XMATR460()
Local oReport  := NIL
Local lCusUnif := A330CusFil()

Static nDecVal // Retorna o numero de decimais usado no SX3
nDecVal:= IIF(nDecVal  == Nil,TamSX3("B2_CM1")[2],nDecVal)

//-- Interface de impressao
If TRepInUse()
	oReport:= ReportDef()
	oReport:PrintDialog()
Else
	U_XMTR46R3()
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³Nereu Humberto Junior  ³ Data ³31.07.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatorio                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()
Local oReport 	:= NIL
Local oSection1 := NIL

oReport:= TReport():New("MATR460",STR0001,"MTR460", {|oReport| ReportPrint(oReport)},STR0002) //"Registro de Invent rio - Modelo P7"##"Emiss„o do Registro de Invent rio.Os Valores Totais serao impressos conforme Modelo Legal"
oReport:SetTotalInLine(.F.)
oReport:nFontBody	:= 08 // Define o tamanho da fonte.
oReport:nLineHeight := 45 // Define a altura da linha.
oReport:SetEdit(.T.)
oReport:HideHeader()
oReport:HideFooter()
oReport:SetUseGC(.F.) // Remove botão da gestão de empresas pois conflita com a pergunta "Seleciona Filiais"

//-- Secao criada para evitar error log no botao Personalizar
oSection1 := TRSection():New(oReport,STR0042,{"SB1"}) //"Saldos em Estoque"
oSection1:SetReadOnly()

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³Nereu Humberto Junior  ³ Data ³21.06.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatorio                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport)
Static lCalcUni	    := Nil
Static cFilUsrSB1	:= ""

Local cPeLocProc    := ""
Local cArqTemp      := ""
Local cIndTemp1     := ""
Local cIndTemp2     := ""
Local cQuery		:= ""
Local cKeyInd		:= ""
Local cPosIpi		:= ""
Local cSeekUnif     := ""
Local cArqAbert	    := ""
Local cArqEncer	    := ""
Local cIndSB6		:= ""
Local cFilP7		:= ""
Local cKeyQbr		:= ""
Local cAliasTop	    := "SB2"
Local cQuebraCon	:= ""
Local cLocTerc		:= 'ZZ' //SuperGetMV("MV_ALMTERC",.F.,"")
Local cLocProc		:= 'ZZ' //SuperGetMv("MV_LOCPROC",.F.,"99")
Local cFilBack		:= cFilAnt
Local cFilCons		:= cFilAnt
Local cLocIni		:= ""
Local cLocFim		:= ""

Local i				:= 0
Local nPos			:= 0
Local nTotIpi		:= 0
Local nX			:= 0
Local nValTotUnif	:= 0
Local nQtdTotUnif	:= 0
Local nLin			:= 80
Local nPosFilCorr	:= 0
Local nForFilial	:= 0
Local nIndSB6		:= 0
Local nPagina		:= 0
Local nForBkp		:= 0
Local nBarra		:= 0
Local nCLIFOR		:= TamSX3("B6_CLIFOR")[1]
Local nLOJA		    := TamSX3("B6_LOJA")[1]
Local nPRODUTO		:= TamSX3("B6_PRODUTO")[1]
Local nTPCF		    := TamSX3("B6_TPCF")[1]
Local nTamLocal	    := TamSX3("B2_LOCAL")[1]
Local nTamSX1       := Len(SX1->X1_GRUPO)

Local aTerceiros	:= {}
Local aArqTemp		:= {}
Local aTotal		:= {}
Local aSeek		    := {}
Local aSaldo		:= {0,0,0,0}
Local aArqCons		:= Array(3)
Local aAuxTer		:= {}
Local aA460AMZP	    := {}
Local aImp			:= {}
Local aSalAtu		:= {}
Local aSaldoTerD    := {}
Local aSaldoTerT    := {}
Local aL			:= R460LayOut(.T.)
Local aDriver		:= ReadDriver()
Local aFilsCalc     := {}
Local a460LocFil    := {}
Local aAlmoxIni     := {}
Local aAlmoxFim     := {}
Local lSaldTesN3    := .F.
Local lEmBranco	    := .F.
Local lImpResumo    := .F.
Local lImpAliq		:= .F.
Local lTipoBN		:= .F.
Local lFirst		:= .T.
Local lCusConFil	:= .F.
Local lGravaSit3	:= .T.
Local lConsolida	:= .F.
Local lA460AMZP     := ExistBlock("A460AMZP")
Local l460RLoc      := ExistBlock("A460RLOC")
Local lImpSit		:= .T.
Local lImpTipo		:= .T.
Local lCusUnif		:= A330CusFil()
Local lA460TESN3	:= ExistBlock("A460TESN3",,.T.)
Local l460UnProc	:= SuperGetMV("MV_R460UNP",.F.,.T.)
Local cTipCusto 	:= SuperGetMv("MV_R460TPC",.F.,"M")
Local nCusMed		:= 0
Local bQuebraCon	:= {|x| aFilsCalc[x,4]+aFilsCalc[x,5]} //-- Bloco que define a quebra de impressao
Local oSection1		:= oReport:Section(1)

Local cPicB2VFim	:= "@E 999,999,999,999.99"
Local cPicB2CM1		:= PesqPict("SB2", "B2_CM1",18)
Local cPicB2QFim	:= PesqPict("SB2", "B2_QFIM",14)
Local nB2QFim		:= TamSX3("B2_QFIM")[2]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametro MV_SDTESN3 para utilizacao do 8o.parametro da funcao               ³
//³ SALDOTERC (considera saldo Poder3 tambem c/ TES que NAO atualiza estoque)    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nSldTesN3  	:= SuperGetMV("MV_SDTESN3",.F.,0)
Local lUsaPETN3  	:= nSldTesN3 == 0
Local aDadosCF9   	:= {0,0}
Local lTerc			:= .F. //Indica se o Produto tem movimento em Terceiro
Local lMov			:= .F. //Indica se o Produto tem movimento dentro do período
Local cAtmes	:= ""
Local cUlmes	:= ""
Local cSB9UlMes	:= ""

Private nSumQtTer	:= 0   //-- variavel opcional para o PE A460TESN3

If oReport:lXlsTable
	ApMsgAlert("Formato de impressão Tabela não suportado neste relatório") //"Formato de impressão Tabela não suportado neste relatório"
	oReport:CancelPrint()
Endif

cFilUsrSB1 := IIF(cFilUsrSB1  == Nil,"",cFilUsrSB1)
cFilUsrSB1 := oSection1:GetAdvplExp()

//-- Chamada da pergunte e criacao das variaveis de controle
//-- IMPORTANTE: ler mv_par somente apos esta linha
Pergunte("MTR460",.F.)

nPagina	 	:= mv_par10
lConsolida	:= mv_par20 == 1 .And. mv_par24 == 1
aFilsCalc	:= MatFilCalc(mv_par20 == 1,,,lConsolida)

lCusConFil	:= lConsolida .And. SuperGetMv('MV_CUSFIL',.F.,"A") == "F" //-- Impressao consolidada e com custo unificado por filial
cAlmoxIni	:= IIf(mv_par03 == "**",Space(02),mv_par03)
cAlmoxFim	:= IIf(mv_par04 == "**","ZZ",mv_par04)
cNrLivro	:= mv_par11
nQuebraAliq	:= IIf(mv_par21 == 1,1,mv_par18)

//-- A460UNIT - Ponto de Entrada utilizado para regravar os campos:
//--            TOTAL, VALOR_UNIT e QUANTIDADE
lCalcUni := If(lCalcUni == NIL,ExistBlock("A460UNIT"),lCalcUni)

//-- Cria Arquivo Temporario
If mv_par12 != 2
	aArqTemp := A460ArqTmp(1,@cKeyInd,nQuebraAliq)
EndIf

//-- Inicializa e atualiza o log de processamento
ProcLogIni( {},"MATR460" )
ProcLogAtu("INICIO")
ProcLogAtu("MENSAGEM",STR0045,STR0045) //"Iniciando impressão do Registro de Inventario Modelo 7 "

//-- Processando Relatorio por Filiais
SM0->(dbSetOrder(1))
For nForFilial := 1 To Len( aFilsCalc )
	If aFilsCalc[nForFilial,1]
		//-- Muda Filial para processamento
		SM0->(dbSeek(cEmpAnt+aFilsCalc[nForFilial,2]))
		cFilAnt := aFilsCalc[nForFilial,2]
		
		//-- Se impressao consolidada
		If lConsolida
			//-- Seta dados do cabecalho:
			//-- 1. Quando imprimindo empresa da filial corrente, imprime com dados da filial logada
			//-- 2. Senao, imprime com dados da primeira filial da empresa
			If cFilAnt == cFilBack .Or. cQuebraCon == ""
				nPosFilCorr := nForFilial
			EndIf
			//-- Define quebra do consolidado como CNPJ + IE pois
			//-- Pois esta comecando uma nova empresa
			If Empty(cQuebraCon)
				cQuebraCon := Eval(bQuebraCon,nForFilial)
			EndIf
		EndIf
		
		//-- Zera o Array aTotal para que os totalizadores nao sejam acumulados no processamento de mais de uma filial
		aTotal := {}
		
		//-- Impressao dos Livros
		If mv_par12 != 2
			
			//-- No consolidado, cria o arquivo somente uma vez (na primeira)
			//-- Ou sempre se MV_CUSFIL igual a F, pois tera que somar e unificar por filial
			If Empty(cArqTemp)
				cArqTemp := GetNextAlias()
				DBCreate( cArqTemp, aArqTemp, "SQLITE_TMP" )
				DBUseArea( .T., "SQLITE_TMP", cArqTemp, cArqTemp, .F., .F. )
				DBCreateIndex("idx1", cKeyInd)
				DBCreateIndex("idx2", "PRODUTO+SITUACAO+ARMAZEM")
				
				//-- Guarda nomes dos arquivos do consolidado para restaurar posteriormente
				If lCusConFil .And. (nForFilial == 1 .Or. Eval(bQuebraCon,nForFilial-1) # cQuebraCon)
					aArqCons[1] := cArqTemp
				EndIf
			EndIf
			
			//-- Se empresa impressa for da filial logada, dados do cabeçalho será da filial logada
			If !lConsolida
				cFilCons := cFilAnt
			ElseIf (nPos := aScan(aFilsCalc,{|x| x[2] == cFilBack .And. x[1]})) > 0 .And. Eval(bQuebraCon,nPos) == Eval(bQuebraCon,nForFilial)
				cFilCons := aFilsCalc[nPos,2]
				//-- Se empresa impressa não for da filial logada, dados do cabeçalho será da primeira filial
			Else
				nPos := aScan(aFilsCalc,{|x| x[4]+x[5] == Eval(bQuebraCon,nForFilial)})
				cFilCons := aFilsCalc[nPos,2]
			EndIf
			
			// processa o arquivo temporario para impressao
			MTR460PROC(oReport,nForFilial,aFilsCalc,cArqTemp,lConsolida,cFilCons,aArqCons,bQuebraCon,cQuebraCon,lCusConFil,nQuebraAliq)
			
			//-- Se impressao consolidada por empresa (CNPJ + IE)
			If lConsolida
				//-- Se custo unificado por filial, devera agregar no arquivo consolidado
				//-- o agregado desta filial e deletar o arquivo desta filial
				If lCusConFil .And. cArqTemp # aArqCons[1]
					//-- Apaga arquivos temporarios
					FWCLOSETEMP(cArqTemp)
					
					If Select(cArqTemp) > 0
						(cArqTemp)->(dbCloseArea())
					EndIf
					Ferase(cIndTemp1+OrdBagExt())
					Ferase(cIndTemp2+OrdBagExt())
					
					//-- Restaura variaveis de controle do arquivo temporario
					cArqTemp  := aArqCons[1]
					cIndTemp1 := aArqCons[2]
					cIndTemp2 := aArqCons[3]
				EndIf
				
				//-- Se ainda nao consolidou todas, processara a proxima filial
				//-- zerando as variaveis de controle e realizando loop
				If nForFilial < Len(aFilsCalc) .And. cQuebraCon == Eval(bQuebraCon,nForFilial+1)
					
					If lCusConFil
						cArqTemp := ""
					EndIf
					
					lRetorno := .F.
					//-- Se impressao consolidada, muda filial para imprimir com os dados da filial consolidada
				Else
					SM0->(dbSeek(cEmpAnt+cFilCons))
					cFilAnt 	:= cFilCons
					cQuebraCon	:= "" //-- Limpa variavel de controle da quebra para imprimir proxima empresa
					nForBkp		:= nForFilial //-- Guarda variavel do laco para restaura-la apos impressao
					nForFilial	:= aScan(aFilsCalc,{|x| x[2] == cFilCons}) //-- Seta variavel do laco para a filial dos dados do cabecalho
				EndIf
			EndIf
			
			//
			//-- Imprime Modelo P7
			//
			(cArqTemp)->(dbSetOrder(1))
			(cArqTemp)->(dbGotop())
			
			//-- Flags de Impressao
			cSitAnt	  := "X"
			aSituacao := {STR0015,STR0016,STR0017,STR0018,STR0019,STR0034," EM FABRICAÇÃO "}		//" EM ESTOQUE "###" EM PROCESSO "###" SEM MOVIMENTACAO "###" DE TERCEIROS "###" EM TERCEIROS "
			cTipoAnt  := "XX"
			cQuebra   := ""
			
			While !oReport:Cancel() .And. !(cArqTemp)->(EOF())
				nLin    := 80
				cSitAnt := (cArqTemp)->SITUACAO
				lImpSit := .T.
				
				While !oReport:Cancel() .And. !(cArqTemp)->(Eof()) .And. cSitAnt == (cArqTemp)->SITUACAO
					cTipoAnt := (cArqTemp)->TIPO
					lImpTipo := .T.
					
					While !oReport:Cancel() .And. !(cArqTemp)->(Eof()) .And. cSitAnt+cTipoAnt == (cArqTemp)->(SITUACAO+TIPO)
						cPosIpi := (cArqTemp)->POSIPI
						nTotIpi := 0
						
						If mv_par21 == 1
							cSitTrib := (cArqTemp)->SITTRIB
							lImpST   := .T.
						EndIf
						
						If nQuebraAliq <> 1
							nAliq    := (cArqTemp)->ALIQ
							lImpAliq := .T.
						EndIf
						
						If mv_par21 == 1
							cQuebra := cSitAnt+cTipoAnt+cSitTrib
							cKeyQbr := 'SITUACAO+TIPO+SITTRIB'
						Else
							cQuebra := IIf(nQuebraAliq == 1,cSitAnt+cTipoAnt+cPosIpi,cSitAnt+cTipoAnt+Str(nAliq,5,2))
							cKeyQbr := IIf(nQuebraAliq == 1,'SITUACAO+TIPO+POSIPI','SITUACAO+TIPO+Str(ALIQ,5,2)')
						EndIf
						
						While !oReport:Cancel() .And. !(cArqTemp)->(EOF()) .And. cQuebra == (cArqTemp)->&(cKeyQbr)
							If oReport:Cancel()
								Exit
							EndIf
							
							//-- Controla impressao de Produtos com saldo negativo ou zerado
							If (!mv_par08 == 1 .And. (cArqTemp)->QUANTIDADE < 0) .Or.;
								(!mv_par09 == 1 .And. (cArqTemp)->QUANTIDADE == 0) .Or.;
								(!mv_par15 == 1 .And. (cArqTemp)->TOTAL == 0)
								(cArqTemp)->(dbSkip())
								Loop
							Else
								nTotIpi += (cArqTemp)->TOTAL
								(cArqTemp)->(R460Acumula(aTotal))
							EndIf
							
							//-- Inicializa array com itens de impressao de acordo com mv_par14
							If mv_par14 == 1
								aImp:={	Alltrim((cArqTemp)->POSIPI),;
								(cArqTemp)->DESCRICAO,;
								(cArqTemp)->UM,;
								(cArqTemp)->(Transform(QUANTIDADE,IF(nB2QFim>3,"@E 99,999,999.999",cPicB2QFim))),;
								(cArqTemp)->(Transform(Round(TOTAL/QUANTIDADE,nDecVal),cPicB2CM1)),;
								Transform((cArqTemp)->TOTAL,cPicB2VFim ),;
								Nil}
							Else
								aImp:={	Alltrim((cArqTemp)->POSIPI),;
								(cArqTemp)->(Padr(Alltrim(PRODUTO)+" - "+DESCRICAO,35)),;
								(cArqTemp)->UM,;
								Transform((cArqTemp)->QUANTIDADE,IF(nB2QFim > 3,"@E 99,999,999.999",cPicB2QFim)),;
								(cArqTemp)->(Transform(Round(TOTAL/QUANTIDADE,nDecVal),cPicB2CM1)),;
								Transform((cArqTemp)->TOTAL,cPicB2VFim),;
								Nil}
							EndIf
							
							DbSelectArea(cArqTemp)
							(cArqTemp)->(dbSkip())
							
							//-- Salta registros Zerados ou Negativos Conforme Parametros
							//-- Necessario Ajustar Posicao p/ Totalizacao de Grupos (POSIPI)
							While !oReport:Cancel() .And. !(cArqTemp)->(EOF()) .And. ((!mv_par08 == 1 .And. (cArqTemp)->QUANTIDADE < 0) .Or.;
								(!mv_par09 == 1 .And. (cArqTemp)->QUANTIDADE == 0).Or.;
								(!mv_par15 == 1 .And. (cArqTemp)->TOTAL == 0))
								(cArqTemp)->(dbSkip())
							End
							
							//-- Verifica se imprime total por POSIPI
							If cSitAnt+cTipoAnt+cPosIpi <> (cArqTemp)->(SITUACAO+TIPO+POSIPI) .And. nQuebraAliq == 1
								aImp[07] := Transform(nTotIPI,cPicB2VFim)
							EndIf
							
							//-- Imprime cabecalho
							If nLin > 55
								R460Cabec(@nLin,@nPagina,.T.,oReport,aFilsCalc[nForFilial,3])
							EndIf
							
							If lImpSit
								U_XFmtLinR4(oReport,{"",Padc(aSituacao[Val(cSitAnt)],35,"*"),"","","","",""},aL[15],,,@nLin)
								lImpSit := .F.
							EndIf
							
							If lImpTipo
								SX5->(dbSeek(xFilial("SX5")+"02"+cTipoAnt))
								U_XFmtLinR4(oReport,Array(7),aL[15],,,@nLin)
								U_XFmtLinR4(oReport,{"",Padc(" "+SUBSTR(TRIM(X5Descri()),1,26)+" ",35,"*"),"","","","",""},aL[15],,,@nLin)
								U_XFmtLinR4(oReport,Array(7),aL[15],,,@nLin)
								lImpTipo := .F.
							EndIf
							
							If mv_par21 == 1 .And. lImpST
								U_XFmtLinR4(oReport,{"",Padc(" "+STR0044+" "+cSitTrib+" ",35,"*"),"","","","",""},aL[15],,,@nLin)
								U_XFmtLinR4(oReport,Array(7),aL[15],,,@nLin)
								lImpST := .F.
							EndIf
							
							If nQuebraAliq <> 1 .And. lImpAliq
								U_XFmtLinR4(oReport,{"",Padc(" "+STR0031+Transform(nAliq,"@E 99.99%")+" ",35,"*"),"","","","",""},aL[15],,,@nLin)
								U_XFmtLinR4(oReport,Array(7),aL[15],,,@nLin)
								lImpAliq := .F.
							EndIf
							
							//-- Imprime linhas de detalhe de acordo com parametro (mv_par14)
							U_XFmtLinR4(oReport,aImp,aL[15],,,@nLin)
							
							If nQuebraAliq <> 1 .And. cQuebra <> &(cKeyQbr)
								U_XFmtLinR4(oReport,Array(7),aL[15],,,@nLin)
								nPos := aScan(aTotal,{|x| x[1] == cSitAnt .And. x[2] == cTipoAnt .And. x[6] == nAliq})
								U_XFmtLinR4(oReport,{,STR0021+STR0031+Transform(nAliq,"@E 99.99%")+" ===>",,,,,Transform(aTotal[nPos,5], cPicB2VFim)},aL[15],,,@nLin)			//"TOTAL "
								U_XFmtLinR4(oReport,Array(7),aL[15],,,@nLin)
							EndIf
							
							If mv_par21 == 1 .And. cQuebra <> &(cKeyQbr)
								FmtLin(Array(7),aL[15],,,@nLin)
								nPos := aScan(aTotal,{|x| x[1] == cSitAnt .And. x[2] == cTipoAnt .And. x[6] == cSitTrib})
								U_XFmtLinR4(oReport,{,STR0021+STR0044+" "+cSitTrib+" ===>",,,,,Transform(aTotal[nPos,5], cPicB2VFim)},aL[15],,,@nLin)		//"TOTAL "
								U_XFmtLinR4(oReport,Array(7),aL[15],,,@nLin)
							EndIf
							
							If nLin >= 55
								R460EmBranco(@nLin,.T.,oReport)
							EndIf
						End
					End
					
					//-- Impressao de Totais
					nPos := aScan(aTotal,{|x| x[1] == cSitAnt .And. x[2] == cTipoAnt})
					If nPos # 0
						If nLin > 55
							R460Cabec(@nLin,@nPagina,.T.,oReport,aFilsCalc[nForFilial,3])
						EndIf
						R460Total(@nLin,aTotal,cSitAnt,cTipoAnt,aSituacao,@nPagina,.T.,oReport,aFilsCalc[nForFilial,3])
					EndIf
				End
				
				nPos := aScan(aTotal,{|x| x[1] == cSitAnt .And. x[2] == TT})
				If nPos # 0
					If nLin > 55
						R460Cabec(@nLin,@nPagina,.T.,oReport,aFilsCalc[nForFilial,3])
					EndIf
					R460Total(@nLin,aTotal,cSitAnt,TT,aSituacao,@nPagina,.T.,oReport,aFilsCalc[nForFilial,3])
					If nLin < 57
						R460EmBranco(@nLin,.T.,oReport)
					EndIf
					lImpResumo:=.T.
				EndIf
			EndDo
			
			R460Cabec(@nLin,@nPagina,.T.,oReport,aFilsCalc[nForFilial,3])
			
			If lImpResumo
				R460Total(@nLin,aTotal,"T",TT,aSituacao,@nPagina,.T.,oReport,aFilsCalc[nForFilial,3])
			Else
				R460SemEst(@nLin,@nPagina,.T.,oReport)
			EndIf
			
			R460EmBranco(@nLin,.T.,oReport)
			
			//-- Apaga Arquivos Temporarios
			FWCLOSETEMP(cArqTemp)
			
			If Select(cArqTemp) > 0
				(cArqTemp)->(dbCloseArea())
			EndIf
			
			Ferase(cIndTemp1+OrdBagExt())
			Ferase(cIndTemp2+OrdBagExt())
			
			(cAliasTop)->(dbCloseArea())
			
			aTerceiros := {} //Zera array aTerceiros para evitar duplicidade na impressão do Modelo P7
			
			cArqTemp := ""	//-- Criará novo arquivo temporario para a nova impressao
			If !Empty(nForBkp) //-- Se impressao consolidada, retorna a variavel do laco de filiais
				nForFilial := nForBkp
				nForBkp := 0
			EndIf
			
			//-- Impressao dos Termos
		Else
			//-- Se impressao consolidada, só imprime quando quebrar empresa
			If lConsolida .And. nForFilial < Len(aFilsCalc) .And. Eval(bQuebraCon,nForFilial) == Eval(bQuebraCon,nForFilial+1)
				Loop
			EndIf
			cArqAbert := GetMv("MV_LMOD7AB")
			cArqEncer := GetMv("MV_LMOD7EN")
			
			//-- Posiciona na Empresa/Filial
			If SM0->M0_CODFIL # cFilAnt
				SM0->(dbSeek(cEmpAnt+cFilAnt))
			EndIf
			
			aVariaveis := {}
			
			For nX := 1 To SM0->(FCount())
				If SM0->(FieldName(nX)) == "M0_CGC"
					SM0->(aAdd(aVariaveis,{FieldName(nX),Transform(FieldGet(nX),"@R 99.999.999/9999-99")}))
				Else
					If SM0->(FieldName(nX)) == "M0_NOME"
						Loop
					EndIf
					SM0->(aAdd(aVariaveis,{FieldName(nX),FieldGet(nX)}))
				EndIf
			Next nX
			
			SX1->(dbSeek(PADR("MTR460",nTamSX1)+"01"))
			While SX1->X1_GRUPO == PADR("MTR460",nTamSX1)
				SX1->(aAdd(aVariaveis,{Rtrim(Upper(X1_VAR01)),&(X1_VAR01)}))
				SX1->(dbSkip())
			End
			
			CVB->(dbSeek(xFilial("CVB")))
			For i := 1 To CVB->(FCount())
				If CVB->(FieldName(i)) == "CVB_CGC"
					CVB->(aAdd(aVariaveis,{FieldName(i),Transform(FieldGet(i),"@R 99.999.999/9999-99")}))
				ElseIf CVB->(FieldName(i)) == "CVB_CPF"
					CVB->(aAdd(aVariaveis,{FieldName(i),Transform(FieldGet(i),"@R 999.999.999-99")}))
				Else
					CVB->(aAdd(aVariaveis,{FieldName(i),FieldGet(i)}))
				EndIf
			Next i
			
			aAdd(aVariaveis,{"M_DIA",StrZero(Day(dDataBase),2)})
			aAdd(aVariaveis,{"M_MES",MesExtenso()})
			aAdd(aVariaveis,{"M_ANO",StrZero(Year(dDataBase),4)})
			
			cDriver := aDriver[4]
			oReport:HideHeader()
			If cArqAbert # NIL
				oReport:EndPage()
				ImpTerm(cArqAbert,aVariaveis,&cDriver,,,.T.,oReport)
			EndIf
			
			If cArqEncer # NIL
				oReport:EndPage()
				ImpTerm(cArqEncer,aVariaveis,&cDriver,,,.T.,oReport)
			EndIf
		EndIf
	EndIf
Next nForFilial

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

SM0->(dbSeek(cEmpAnt+cFilBack))
cFilAnt := cFilBack

//-- Atualiza o log de processamento
ProcLogAtu("MENSAGEM",STR0046,STR0046) //"Processamento Encerrado"
ProcLogAtu("FIM")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³U_XMTR46R3 ³ Autor ³ Juan Jose Pereira     ³ Data ³ 07.11.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio do Inventario, Registro Modelo P7                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XMTR46R3()
Local wnrel		    := NIL

Local Titulo		:= STR0001	//"Registro de Invent rio - Modelo P7"
Local cDesc1		:= STR0002	//"Emiss„o do Registro de Invent rio.Os Valores Totais serao impressos conforme Modelo Legal"
Local cDesc2		:= ""
Local cDesc3		:= ""
Local cString		:= "SB1"
Local NomeProg		:= "MATR460"
Local cArqTemp		:= ""
Local cIndTemp1	    := ""
Local cIndTemp2	    := ""
Local cKeyInd		:= ""
Local cFilBack		:= cFilAnt
Local cFilCons		:= cFilAnt
Local Tamanho		:= "M"

Local nForFilial	:= 0
Local nPos			:= 0

Local aSave		    := GetArea()
Local aArqTemp	  	:= {}
Local aFilsCalc	    := {}
Local aArqCons		:= Array(3)

Local lImprime		:= .T.
Local lCusConFil	:= .F.
Local lImpSX1		:= .T.
Local lConsolida	:= .F.

Local bQuebraCon	:= {|x| aFilsCalc[x,4]+aFilsCalc[x,5]} //-- Bloco que define a chave de quebra

Private aReturn	    := {STR0005,1,STR0006,2,2,1,"",1}	//"Zebrado"###"Administra‡„o"
Private nLastKey	:= 0
Private nTipo		:= 0

//-- Chama pergunte e cria variaveis de controle
Pergunte("MTR460",.F.)

//-- Envia controle para a funcao SETPRINT
wnrel := SetPrint(cString,NomeProg,"MTR460",@titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho)

cAlmoxIni	:= IIf(mv_par03 == "**",Space(02),mv_par03)
cAlmoxFim	:= IIf(mv_par04 == "**","ZZ",mv_par04)
cNrLivro	:= mv_par11
nQuebraAliq	:= IIf(mv_par21 == 1,1,mv_par18)
lConsolida	:= mv_par20 == 1 .And. mv_par24 == 1
lCusConFil	:= lConsolida .And. SuperGetMv('MV_CUSFIL',.F.,"A") == "F" //-- Impressao consolidada e com custo unificado por filial

//-- Cria Arquivo Temporario
If mv_par12 == 1
	aArqTemp := A460ArqTmp(1,@cKeyInd,nQuebraAliq)
EndIf

If nLastKey <> 27
	SetDefault(aReturn,cString)
	
	//-- Janela de Selecao de Filiais
	aFilsCalc := MatFilCalc(mv_par20 == 1,,,lConsolida)
	
	//--Processando Relatorio por Filiais
	SM0->(dbSetOrder(1))
	For nForFilial := 1 To Len(aFilsCalc)
		If aFilsCalc[nForFilial,1]
			//-- Muda Filial para processamento
			SM0->(dbSeek(cEmpAnt+aFilsCalc[nForFilial,2]))
			cFilAnt  := aFilsCalc[nForFilial,2]
			
			//-- Impressao dos livros
			If mv_par12 == 1
				//-- Variavel para controlar a aglutinacao do consolidado
				lImprime := !lConsolida .Or.; 											//-- Nao consolidado
				Len(aFilsCalc) == 1 .Or. Len(aFilsCalc) == nForFilial .Or.;	//-- Somente uma filial ou a ultima
				Eval(bQuebraCon,nForFilial) # Eval(bQuebraCon,nForFilial+1)		//-- Quebrou
				
				//-- No consolidado, cria o arquivo somente uma vez (na primeira)
				//-- Ou sempre se MV_CUSFIL igual a F, pois tera que somar e unificar por filial
				If Empty(cArqTemp)
					//-- Cria Indice de Trabalho
					cArqTemp := CriaTrab(,.F.)
					FWOpenTemp(cArqTemp, aArqTemp, cArqTemp)
					cIndTemp1 := Substr(CriaTrab(NIL,.F.),1,7)+"1"
					cIndTemp2 := Substr(CriaTrab(NIL,.F.),1,7)+"2"
					
					//-- Guarda nomes dos arquivos do consolidado para restaurar posteriormente
					If lCusConFil .And. (nForFilial == 1 .Or. Eval(bQuebraCon,nForFilial) # Eval(bQuebraCon,nForFilial-1))
						aArqCons[1] := cArqTemp
						aArqCons[2] := cIndTemp1
						aArqCons[3] := cIndTemp2
					EndIf
					
					//-- Criando Indice Temporario
					IndRegua(cArqTemp,cIndTemp1,cKeyInd,,,STR0014)				//"Indice Tempor rio..."
					IndRegua(cArqTemp,cIndTemp2,"PRODUTO+SITUACAO",,,STR0014)	//"Indice Tempor rio..."
					
					Set Cursor Off
					(cArqTemp)->(dbClearIndex())
					(cArqTemp)->(dbSetIndex(cIndTemp1+OrdBagExt()))
					(cArqTemp)->(dbSetIndex(cIndTemp2+OrdBagExt()))
				EndIf
				
				If !lConsolida
					cFilCons := cFilAnt //-- Impressão não consolidada o cabeçalho será por filial
				ElseIf (nPos := aScan(aFilsCalc,{|x| x[2] == cFilBack .And. x[1]})) > 0 .And. Eval(bQuebraCon,nPos) == Eval(bQuebraCon,nForFilial)
					cFilCons := aFilsCalc[nPos,2]	//-- Se empresa impressa for da filial logada, dados do cabeçalho será da filial logada
				Else
					nPos := aScan(aFilsCalc,{|x| x[4]+x[5] == Eval(bQuebraCon,nForFilial)})
					cFilCons := aFilsCalc[nPos,2] 	//-- Se empresa impressa não for da filial logada, dados do cabeçalho será da primeira filial
				EndIf
				
				RptStatus({|lEnd| R460Imp(@lEnd,wnRel,cString,Tamanho,aFilsCalc,cArqTemp,lImprime,lImpSX1,cFilCons,aArqCons,nForFilial,cIndTemp1,cIndTemp2)},Titulo,STR0041 +aFilsCalc[nForFilial,2] +" - " +aFilsCalc[nForFilial,3])
				
				//-- Se imprimiu
				If lImprime
					lImpSX1 := .F. //-- Para imprimir somente um vez o grupo de perguntas
					
					//-- Se imprimiu empresa, apaga arquivo temporario
					If !lCusConFil .Or. nForFilial == Len(aFilsCalc) .Or.;
						Eval(bQuebraCon,nForFilial) # Eval(bQuebraCon,nForFilial+1)
						FWCLOSETEMP(cArqTemp)
						
						If Select(cArqTemp) > 0
							(cArqTemp)->(dbCloseArea())
						EndIf
						
						Ferase(cIndTemp1+OrdBagExt())
						Ferase(cIndTemp2+OrdBagExt())
					EndIf
				EndIf
				
				If !lConsolida .Or. lCusConFil .Or. nForFilial == Len(aFilsCalc) .Or.; 	//-- Nao consolidada ou custo por filial
					Eval(bQuebraCon,nForFilial) # Eval(bQuebraCon,nForFilial+1) 	//-- Quebrou
					cArqTemp := ""
				EndIf
				//-- Se impressao consolidada, só imprime termos quando quebrar empresa
			ElseIf !lConsolida .Or. nForFilial == Len(aFilsCalc) .Or. Eval(bQuebraCon,nForFilial) # Eval(bQuebraCon,nForFilial+1)
				RptStatus({|lEnd| R460Term(@lEnd,wnRel,cString,Tamanho)},Titulo,STR0041+aFilsCalc[nForFilial,2] +" - " +aFilsCalc[nForFilial,3])
			EndIf
		EndIf
	Next nForFilial
	
	//-- Fecha tabela temporaria TRB
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf
	
	If aReturn[5] == 1
		Set Printer To
		dbCommitAll()
		OurSpool(wnrel)
	EndIf
	
	MS_FLUSH()
	
	SM0->(dbSeek(cEmpAnt+cFilBack))
	cFilAnt := cFilBack //-- Restaura Filial Original
	RestArea(aSave) //-- Restaura ambiente
EndIf

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³R460LayOut³ Autor ³ Juan Jose Pereira     ³ Data ³ 07.11.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Lay-Out do Modelo P7                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno  ³aL - Array com layout do cabecalho do relatorio             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR460                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R460LayOut(lGraph)
Local lImp	:= GetNewPar("MV_IMPCABE",.F.)
Local aL	:= Array(16)

DEFAULT lGraph := .F.

aL[01]:=				  "+----------------------------------------------------------------------------------------------------------------------------------+"
If lImp
	aL[02]:=STR0043 	//"|                                                     REGISTRO DE INVENTÁRIO  - P7                                                 |"
Else
	aL[02]:=STR0007		//"|                                                     REGISTRO DE INVENTÁRIO                                                       |"
EndIf
aL[03]:=				  "|                                                                                                                                  |"
aL[04]:=STR0039			//"| FIRMA:#########################################     FILIAL: ###############                                                      |"
aL[05]:=				  "|                                                                                                                                  |"
If cPaisLoc == "CHI"
	aL[06]:=STR0029		//"|                               RUT :       ################################                                                       |"
Else
	aL[06]:=STR0009		//"| INSC.EST.: ################   C.N.P.J.  : ################################                                                       |"
EndIf
aL[07]:=				  "|                                                                                                                                  |"
aL[08]:=STR0010			//"| FOLHA: #######                ESTOQUES EXISTENTES EM: ##########                                                                 |"
aL[09]:=				  "|                                                                                                                                  |"
aL[10]:=				  "|----------------------------------------------------------------------------------------------------------------------------------|"
If ( cPaisLoc=="BRA" )
	aL[11]:=STR0025		//"|             |                                      |    |              |                        VALORES                          |"
	aL[12]:=STR0011		//"|CLASSIFICAÇãO|                                      |    |              |-------------------------------------+-------------------|"
	aL[13]:=STR0012		//"|    FISCAL   |     D I S C R I M I N A Ç Ã O        |UNID|  QUANTIDADE  |     UNITÁRIO     |     PARCIAL      |      TOTAL        |"
	aL[14]:=			  "|-------------+--------------------------------------+----+--------------+------------------+------------------+-------------------|"
	aL[15]:=			  "|#############| #####################################| ## |##############|##################|##################|###################|"
Else
	aL[11]:=STR0028		//"|                                                    |    |              |                        VALORES                          |"
	aL[12]:=STR0026		//"|                                                    |    |              |-------------------------------------+-------------------|"
	aL[13]:=STR0027		//"|                   DESCRIÇÃO                        |UNID|  QUANTIDADE  |     UNITÁRIO     |     PARCIAL      |      TOTAL        |"
	aL[14]:=			  "|----------------------------------------------------+----+--------------+------------------+------------------+-------------------|"
	aL[15]:=			  "| # ################################################ | ## |##############|##################|##################|###################|"
EndIf
aL[16]:=				  "+----------------------------------------------------------------------------------------------------------------------------------+"
//		 			      0123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x12
//    	                            1         2         3         4         5         6         7         8         9         10        11        12        13
Return (aL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ R460Imp  ³ Autor ³ Juan Jose Pereira     ³ Data ³ 07.11.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Modelo P7                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd    - variavel que indica se processo foi interrompido ³±±
±±³          ³ wnrel   - nome do arquivo a ser impresso                   ³±±
±±³          ³ cString - tabela sobre a qual o filtro do relatorio sera   ³±±
±±³          ³ executado                                                  ³±±
±±³          ³ tamanho - tamanho configurado para o relatorio             ³±±
±±³          ³ aFilsCalc - array com as filiais processadas				  ³±±
±±³          ³ lImpSX1  - Indica se deve imprimir o grupo de perguntas	  ³±±
±±³          ³ lImprime - Indica se deve imprimir ou somente acumular	  ³±±
±±³          ³ cFilCons - Codigo da filial consolidadora 				  ³±±
±±³          ³ aArqCons - Array com os dados do arquivo consolidado		  ³±±
±±³          ³ nForFilial - posicao da filial que esta sendo impressa	  ³±±
±±³          ³ cIndTemp1 - arquivo do indice temporario.				  ³±±
±±³          ³ cIndTemp2 - arquivo do indice temporario.				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno  ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR460                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R460Imp(lEnd,wnRel,cString,tamanho,aFilsCalc,cArqTemp,lImprime,lImpSX1,cFilCons,aArqCons,nForFilial,cIndTemp1,cIndTemp2)
Static lCalcUni	    := Nil
Static cFilUsrSB1	:= ""

Local cPeLocProc	:= ""
Local cPosIpi		:= ""
Local cQuery		:= ""
Local cSeekUnif	    := ""
Local cNomeArq		:= ""
Local cIndSB6		:= ""
Local cKeyQbr		:= ""
Local cAliasTop	    := "SB2"
Local cLocTerc		:= 'ZZ'//SuperGetMV("MV_ALMTERC",.F.,"")
Local cLocProc		:= 'ZZ'//SuperGetMv("MV_LOCPROC",.F.,"99")
Local cTipCusto 	:= SuperGetMv("MV_R460TPC",.F.,"M")
Local cLocIni       := ""
Local cLocFim       := ""
Local aA460AMZP	    := {}
Local aSalAtu		:= {}
Local aTotal		:= {}
Local aImp			:= {}
Local aSeek		    := {}
Local aTerceiros	:= {}
Local aAuxTer		:= {}
Local aSaldoTerD    := {}
Local aSaldoTerT    := {}
Local aSaldo		:= {0,0,0,0}
Local aL			:= R460LayOut(.F.)
Local aDadosCF9     := {0,0}
Local aAlmoxIni     := {}
Local aAlmoxFim     := {}
Local nLin			:= 80
Local nTotIpi		:= 0
Local nPos			:= 0
Local nX			:= 0
Local nValTotUnif	:= 0
Local nQtdTotUnif	:= 0
Local nIndSB6		:= 0
Local nBarra		:= 0
Local nTPCF		    := TamSX3("B6_TPCF")[1]
Local nCLIFOR		:= TamSX3("B6_CLIFOR")[1]
Local nLOJA		    := TamSX3("B6_LOJA")[1]
Local nPRODUTO		:= TamSX3("B6_PRODUTO")[1]
Local nTamLocal	   	:= TamSX3("B2_LOCAL")[1]
Local nPagina		:= mv_par10
Local nTpProcesso	:= SuperGetMV("MV_R460PRC",.F.,1)

Local lConsolida	:= mv_par20 == 1 .And. mv_par24 == 1
Local lEmBranco	    := .F.
Local lImpResumo    := .F.
Local lImpAliq		:= .F.
Local lSaldTesN3    := .F.
Local lTipoBN		:= .F.
Local lFirst		:= .T.
Local lA460AMZP     := ExistBlock("A460AMZP")
Local lA460TESN3    := ExistBlock("A460TESN3",,.T.)
Local l460RLoc      := ExistBlock("A460RLOC")
Local lImpSit		:= .F.
Local lImpTipo		:= .F.
Local lCusUnif		:= A330CusFil() //-- Verifica se utiliza custo unificado por Empresa/Filial
Local lCusConFil	:= lConsolida .And. SuperGetMv('MV_CUSFIL',.F.,"A") == "F" //-- Impressao consolidada e com custo unificado por filial
Local lGravaSit3	:= .T.
Local nCusMed		:= 0
Local bQuebraCon	:= {|x| aFilsCalc[x,4]+aFilsCalc[x,5]} //-- Bloco que define a chave de quebra

Local cPicB2VFim	:= "@E 999,999,999,999.99"
Local cPicB2CM1		:= PesqPict("SB2", "B2_CM1",18)
Local cPicB2QFim	:= PesqPict("SB2", "B2_QFIM",14)
Local nB2QFim		:= TamSX3("B2_QFIM")[2]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametro MV_SDTESN3 para utilizacao do 8o.parametro da funcao               ³
//³ SALDOTERC (considera saldo Poder3 tambem c/ TES que NAO atualiza estoque)    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nSldTesN3	:= SuperGetMV("MV_SDTESN3",.F.,0)

Local lUsaPETN3	:= nSldTesN3 == 0
Local lTerc		:= .F. //Indica se o Produto tem movimento em Terceiro
Local lMov		:= .F. //Indica se o Produto tem movimento dentro do período
Local cAtmes	:= ""
Local cUlmes	:= ""
Local cSB9UlMes	:= ""

Private m_pag		:= 1  // Controla impressao manual do cabecalho
Private nSumQtTer	:= 0  // variavel opcional para o PE A460TESN3

//-- A460AMZP - Ponto de Entrada para considerar um armazen
//--            adicional como armazem de processo
If lA460AMZP
	aA460AMZP := ExecBlock("A460AMZP",.F.,.F.,'')
	If ValType(aA460AMZP)=="A" .And. Len(aA460AMZP) == 1
		cPeLocProc := IIf(Valtype(aA460AMZP[1])=="C",aA460AMZP[1],'')
	EndIf
EndIf

cFilUsrSB1:= IIF(cFilUsrSB1  == Nil,"",cFilUsrSB1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| A460LOCFIL - Filtra relatorio por ranges customizados de armazem ³
//| Ex: 01 a 05, 12 a 19, 21 a 54 etc                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If l460RLoc
	a460LocFil := ExecBlock("A460RLOC",.F.,.F.,'')
	If ValType(a460LocFil) == "A" .And. Len(a460LocFil) == 2
		cLocIni := IIf(Valtype(a460LocFil[1]) == "C",a460LocFil[1],'')
		cLocFim := IIf(Valtype(a460LocFil[2]) == "C",a460LocFil[2],'')
		// Soh executa filtro se o comprimento dos filtros De/Ate forem iguais
		If !Empty(cLocIni) .And. !Empty(cLocFim) .And. Len(cLocIni) == Len(cLocFim)
			For nX := 1 To Len(cLocIni) Step nTamLocal + 1
				AADD(aAlmoxIni, SubStr(cLocIni,nX,nTamLocal))
				AADD(aAlmoxFim, SubStr(cLocFim,nX,nTamLocal))
			Next nX
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Vetor aAlmoxIni vazio indica que a execucao do PE A460LOCFIL     ³
	//| nao foi bem sucedida. Assim, o comportamento padrao do filtro    ³
	//| de armazens nao eh afetado                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	l460RLoc := !Empty(aAlmoxIni)
EndIf

//-- A460UNIT - Ponto de Entrada utilizado para regravar os campos:
//--            TOTAL, VALOR_UNIT e QUANTIDADE
lCalcUni := If(lCalcUni == Nil,ExistBlock("A460UNIT"),lCalcUni)

cFilUsrSB1 := aReturn[7]

cAtmes := Dtos(mv_par13) // data de fechamento informado no pergunte() [maior data]
cSB9UlMes := GetUlMes(cAtmes) // Obtem data do ultimo fechamento anterior a data informada (MV_PAR13)
cUlmes := dtos(stod(cSB9UlMes)+1) // A data inicial para considerar os movimentos [menor data]
// Se as datas forem iguais a data final deve ser igual então é a data do ultimo fechamento na SB9,
// então deve considerar a data fim igual
If cAtmes == cSB9UlMes
	cAtmes := cUlmes
EndIf

//-- Atualiza o log de processamento
ProcLogIni( {},"MATR460" )
ProcLogAtu("INICIO")
ProcLogAtu("MENSAGEM",STR0045,STR0045) //"Iniciando impressão do Registro de Inventario Modelo 7 "

SB1->(dbSetOrder(1))

//-- Cria Indice de Trabalho para Poder de Terceiros

cAliasTop := CriaTrab(Nil,.F.)

// monta a query principal
cQuery := R460Select(cAtmes,cSB9UlMes,cUlmes,aAlmoxIni,aAlmoxFim)

If Select(cAliasTop) > 0
	(cAliasTop)->(DbCloseArea())
Endif

MsAguarde({|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasTop,.F.,.T.)},STR0033)

(cAliasTop)->(dbEval({|| nBarra++}))
SetRegua(nBarra)
(cAliasTop)->(dbGoTop())

//-- Processando Arquivo de Trabalho
While !lEnd .And. !(cAliasTop)->(EOF())
	SB1->(MsSeek(xFilial("SB1")+(cAliasTop)->B1_COD))
	lTerc:= !EMPTY((cAliasTop)->B6_PRODUTO)
	
	IncRegua()
	
	If Interrupcao(@lEnd)
		Exit
	EndIf
	
	lTipoBN := SB1->B1_TIPO == 'BN' .And. !Empty(SB1->B1_TIPOBN)
	
	// Avalia se o Produto nao entrara no processamento
	If !R460AvalProd(SB1->B1_COD)
		(cAliasTop)->(dbSkip())
		Loop
	EndIf
	
	//-- Alimenta Array com Saldo D = De Terceiros/ T = Em Terceiros
	If mv_par02 <> 2 .AND. lTerc
		//-- Ponto de Entrada A460TESN3 criado para utilizacao do 8o.parametro da funcao
		//-- SALDOTERC (considera saldo Poder3 tambem c/ TES que NAO atualiza estoque)
		lSaldTesN3 := .F.
		If lA460TESN3
			lSaldTesN3 := ExecBlock("A460TESN3",.F.,.F.,{SB1->B1_COD,mv_par13})
			If ValType(lSaldTesN3) <> "L"
				lSaldTesN3 := .F.
			EndIf
		EndIf
		If mv_par02 == 1 .Or. mv_par02 == 3
			aSaldoTerD   := SaldoTerc(SB1->B1_COD,cAlmoxIni,"D",mv_par13,cAlmoxFim,,SB1->B1_COD,IIf(lUsaPETN3,lSaldTesN3,nSldTesN3<>0),!mv_par16==1,,.T.,IIF(l460RLoc,{aAlmoxIni,aAlmoxFim},Nil))
		EndIf
		If mv_par02 == 1 .Or. mv_par02 == 4
			aSaldoTerT   := SaldoTerc(SB1->B1_COD,cAlmoxIni,"T",mv_par13,cAlmoxFim,,SB1->B1_COD,IIf(lUsaPETN3,lSaldTesN3,nSldTesN3<>0),!mv_par16==1,,.T.,IIF(l460RLoc,{aAlmoxIni,aAlmoxFim},Nil))
		EndIf
	EndIf
	
	//-- Busca Saldo em Estoque
	lFirst	  := .T.
	aSalAtu	  := {}
	aSaldo    := {0,0,0,0}
	
	If (cAliasTop)->(EOF()) .Or. SB1->B1_COD <> (cAliasTop)->B2_COD
		//-- Lista produtos sem movimentacao de estoque
		If mv_par07 == 1
			//-- So grava no consolidado caso nenhuma das filiais tenha saldo
			If lConsolida
				//-- Ve nas filiais ja processadas
				//-- Se custo unificado por filial, ve no arquivo consolidador
				If lCusConFil
					(aArqCons[1])->(dbSetOrder(2))
					lGravaSit3 := !(aArqCons[1])->(dbSeek(SB1->B1_COD))
					//-- Se nao, olha no arquivo corrente (ja consolidado)
				Else
					(cArqTemp)->(dbSetOrder(2))
					lGravaSit3 := !(cArqTemp)->(dbSeek(SB1->B1_COD))
				EndIf
				
				//-- Ve nas filiais a processar
				If lGravaSit3
					SB2->(dbSetOrder(1))
					For nX := nForFilial+1 To Len(aFilsCalc)
						If !(lGravaSit3 := !SB2->(dbSeek(xFilial("SB2",aFilsCalc[nX,2])+SB1->B1_COD)))
							Exit
						EndIf
					Next nX
				EndIf
			EndIf
			
			//-- TIPO 3 - SEM SALDO
			If lGravaSit3
				RecLock(cArqTemp,.T.)
				
				(cArqTemp)->FILIAL		:= xFilial("SB2",cFilCons)
				(cArqTemp)->SITUACAO	:= "3"
				(cArqTemp)->TIPO		:= IIf(lTipoBN,SB1->B1_TIPOBN,SB1->B1_TIPO)
				(cArqTemp)->PRODUTO		:= SB1->B1_COD
				(cArqTemp)->POSIPI		:= SB1->B1_POSIPI
				(cArqTemp)->DESCRICAO	:= SB1->B1_DESC
				(cArqTemp)->UM		   	:= SB1->B1_UM
				(cArqTemp)->ARMAZEM		:= IIF (empty((cAliasTop)->B2_LOCAL), SB1->B1_LOCPAD, (cAliasTop)->B2_LOCAL)
				If nQuebraAliq == 2
					(cArqTemp)->ALIQ := SB1->B1_PICM
				ElseIf nQuebraAliq == 3
					(cArqTemp)->ALIQ := IIf(SB0->(MsSeek(xFilial("SB0")+SB1->B1_COD)),SB0->B0_ALIQRED,0)
				EndIf
				If mv_par21 == 1
					(cArqTemp)->SITTRIB := R460STrib(SB1->B1_COD)
				EndIf
				(cArqTemp)->(MsUnLock())
			EndIf
		EndIf
		(cAliasTop)->(dbSkip())
		
		//-- Lista produtos com movimentacao de estoque
	Else
		nCusMed := 0
		While !lEnd .And. !(cAliasTop)->(EOF()) .And. (cAliasTop)->B1_COD == SB1->B1_COD
			
			If Interrupcao(@lEnd)
				Exit
			EndIf
			
			//-- Desconsidera almoxarifado de saldo em processo de material
			//-- indireto ou saldo em armazem de terceiros
			If (cAliasTop)->B2_LOCAL==cLocProc  .Or.;
				(cAliasTop)->B2_LOCAL $ cLocTerc .Or.;
				(cAliasTop)->B2_LOCAL $ cPeLocProc
				(cAliasTop)->(dbSkip())
				Loop
			EndIf
			
			// Assume que deve calcular os movimentos, pois não encontrou Saldo Inicial na data
			If Empty((cAliasTop)->B9_COD)
				lMov := .T.
			Else // Verifica se teve momento entre as datas
				lMov := (!EMPTY((cAliasTop)->D1_COD) .OR. (!EMPTY((cAliasTop)->D2_COD) .OR. !EMPTY((cAliasTop)->D3_COD)))
			EndIf
			
			If lMov //Se o produto não possui movimentação ele pega o saldo direto
				If mv_par16 == 1
					aSalAtu := CalcEst(SB1->B1_COD,(cAliasTop)->B2_LOCAL,mv_par13+1,NIL,mv_par02 <> 2 .and. !lUsaPETN3 .and. nSldTesN3==1)
				Else
					aSalAtu := CalcEstFF(SB1->B1_COD,(cAliasTop)->B2_LOCAL,mv_par13+1,Nil)
				EndIf
			Else
				aSalAtu := {(cAliasTop)->B9_QINI, (cAliasTop)->B9_VINI1,0,0}
			Endif
			
			//Verifica se os produtos possuem saldo conforme parâmetros
			//preenchidos pelo usuário.
			If	(!mv_par08 == 1 .And. aSalAtu[1] < 0) .Or.;
				(!mv_par09 == 1 .And. aSalAtu[1] == 0) .Or.;
				(!mv_par16 == 1 .And. aSalAtu[2] == 0)
				(cAliasTop)->(dbSkip())
				Loop
			EndIf
			
			//-- TIPO 1 - EM ESTOQUE
			(cArqTemp)->(dbSetOrder(2))
			If (cArqTemp)->(dbSeek(SB1->B1_COD+"1"))
				RecLock(cArqTemp,.F.)
			Else
				RecLock(cArqTemp,.T.)
				lFirst:=.F.
				
				(cArqTemp)->FILIAL		:= xFilial("SB2",cFilCons)
				(cArqTemp)->SITUACAO	:= "1"
				(cArqTemp)->TIPO		:= IIf(lTipoBN,SB1->B1_TIPOBN,SB1->B1_TIPO)
				(cArqTemp)->POSIPI		:= SB1->B1_POSIPI
				(cArqTemp)->PRODUTO		:= SB1->B1_COD
				(cArqTemp)->DESCRICAO	:= SB1->B1_DESC
				(cArqTemp)->UM			:= SB1->B1_UM
				(cArqTemp)->ARMAZEM		:= IIF (empty((cAliasTop)->B2_LOCAL), SB1->B1_LOCPAD, (cAliasTop)->B2_LOCAL)
				If nQuebraAliq == 2
					(cArqTemp)->ALIQ := SB1->B1_PICM
				ElseIf nQuebraAliq == 3
					(cArqTemp)->ALIQ := IIf(SB0->(MsSeek(xFilial("SB0")+SB1->B1_COD)),SB0->B0_ALIQRED,0)
				EndIf
				If mv_par21 == 1
					(cArqTemp)->SITTRIB := R460STrib(SB1->B1_COD)
				EndIf
			EndIf
			(cArqTemp)->QUANTIDADE	+= aSalAtu[01]
			(cArqTemp)->TOTAL		+= aSalAtu[02]
			If aSalAtu[1] > 0
				(cArqTemp)->VALOR_UNIT := Round((cArqTemp)->TOTAL/(cArqTemp)->QUANTIDADE,nDecVal)
				nCusMed := (cArqTemp)->VALOR_UNIT
			EndIf
			
			//-- Este Ponto de Entrada foi criado para recalcular o Valor Unitario / Total
			If lCalcUni
				ExecBlock("A460UNIT",.F.,.F.,{SB1->B1_COD,(cAliasTop)->B2_LOCAL,mv_par13,cArqTemp,{'aSalAtu',aSalAtu[01],aSalAtu[02]}})
			EndIf
			
			(cArqTemp)->(MsUnLock())
			
			(cAliasTop)->(dbSkip())
		End
		
		//-- Pesquisa valores de materiais de terceiros requisitados para OP / TIPO 6
		aDadosCF9 := {0,0}
		
		If SB1->B1_AGREGCU == "1"
			aDadosCF9 := U_XSaldoD3CF9(SB1->B1_COD,STOD(cUlmes),STOD(cAtmes),cAlmoxIni,cAlmoxFim,IIF(l460RLoc,{aAlmoxIni,aAlmoxFim},Nil))
			If (QtdComp(aDadosCF9[1]) > QtdComp(0)) .Or. (QtdComp(aDadosCF9[2]) > QtdComp(0))
				(cArqTemp)->(dbSetOrder(2))
				If (cArqTemp)->(dbSeek(SB1->B1_COD+"6"))
					RecLock(cArqTemp,.F.)
				Else
					RecLock(cArqTemp,.T.)
					lFirst:=.F.
					
					(cArqTemp)->FILIAL		:= xFilial("SB2",cFilCons)
					(cArqTemp)->SITUACAO	:= "6"
					(cArqTemp)->TIPO		:= IIf(lTipoBN,SB1->B1_TIPOBN,SB1->B1_TIPO)
					(cArqTemp)->POSIPI		:= SB1->B1_POSIPI
					(cArqTemp)->PRODUTO		:= SB1->B1_COD
					(cArqTemp)->DESCRICAO	:= SB1->B1_DESC
					(cArqTemp)->UM			:= SB1->B1_UM
					(cArqTemp)->ARMAZEM		:= IIF (empty((cAliasTop)->B2_LOCAL), SB1->B1_LOCPAD, (cAliasTop)->B2_LOCAL)
					If nQuebraAliq == 2
						(cArqTemp)->ALIQ := RetFldProd(SB1->B1_COD, "B1_PICM")
					ElseIf nQuebraAliq == 3
						(cArqTemp)->ALIQ := IIf(SB0->(MsSeek(xFilial("SB0")+SB1->B1_COD)),SB0->B0_ALIQRED,0)
					EndIf
					If mv_par21 == 1
						(cArqTemp)->SITTRIB := R460STrib(SB1->B1_COD)
					EndIf
				EndIf
				(cArqTemp)->QUANTIDADE 	:= aDadosCF9[1]
				(cArqTemp)->TOTAL		:= aDadosCF9[2]
				//-- Recalcula valor unitario
				If (cArqTemp)->QUANTIDADE > 0
					(cArqTemp)->VALOR_UNIT := (cArqTemp)->(NoRound(TOTAL/QUANTIDADE,nDecVal))
				EndIf
				
				//-- Este Ponto de Entrada foi criado para recalcular o Valor Unitario / Total
				If lCalcUni
					ExecBlock("A460UNIT",.F.,.F.,{SB1->B1_COD,"",mv_par13,cArqTemp,{'aDadosCF9',aDadosCF9[01],aDadosCF9[02]}})
				EndIf
				
				(cArqTemp)->(MsUnLock())
			EndIf
		EndIf
		
		//-- Tratamento de poder de terceiros
		If mv_par02 <> 2 .And. SB1->B1_FILIAL == xFilial("SB1")
			//-- Pesquisa os valores D = De Terceiros na array aSaldoTerD
			nX := aScan(aSaldoTerD,{|x| x[1] == xFilial("SB6")+SB1->B1_COD})
			If !(nX == 0)
				aSaldo[1] := aSaldoTerD[nX][3]
				aSaldo[2] := aSaldoTerD[nX][4]
				aSaldo[3] := aSaldoTerD[nX][5]
				If Len(aSaldoTerD[nX]) > 5
					aSaldo[4] := aSaldoTerD[nX][6]
				EndIf
			EndIf
			
			//-- Manipula arquivo de trabalho subtraindo do saldo em estoque saldo de terceiros
			(cArqTemp)->(dbSetOrder(2))
			If (cArqTemp)->(dbSeek(SB1->B1_COD+"1"))
				RecLock(cArqTemp,.F.)
			Else
				RecLock(cArqTemp,.T.)
				lFirst:=.F.
				
				(cArqTemp)->FILIAL		:= xFilial("SB2",cFilCons)
				(cArqTemp)->SITUACAO	:= "1"
				(cArqTemp)->TIPO		:= IIf(lTipoBN,SB1->B1_TIPOBN,SB1->B1_TIPO)
				(cArqTemp)->POSIPI		:= SB1->B1_POSIPI
				(cArqTemp)->PRODUTO		:= SB1->B1_COD
				(cArqTemp)->DESCRICAO	:= SB1->B1_DESC
				(cArqTemp)->UM			:= SB1->B1_UM
				(cArqTemp)->ARMAZEM		:= IIF (empty((cAliasTop)->B2_LOCAL), SB1->B1_LOCPAD, (cAliasTop)->B2_LOCAL)
				If nQuebraAliq == 2
					(cArqTemp)->ALIQ := RetFldProd(SB1->B1_COD, "B1_PICM")
				ElseIf nQuebraAliq == 3
					(cArqTemp)->ALIQ := IIf(SB0->(MsSeek(xFilial("SB0")+SB1->B1_COD)),SB0->B0_ALIQRED,0)
				EndIf
				If mv_par21 == 1
					(cArqTemp)->SITTRIB := R460STrib(SB1->B1_COD)
				EndIf
			EndIf
			(cArqTemp)->QUANTIDADE 	-= aSaldo[01]
			(cArqTemp)->TOTAL		-= aSaldo[02]
			If IIf(lUsaPETN3,lSaldTesN3 .And. nSumQtTer == 1,nSldTesN3 == 2)  // MV_SDTESN3 = 2 -> Utilizar TES F4_ESTOQUE = N mas NAO subtrair saldo
				(cArqTemp)->QUANTIDADE 	+= aSaldo[03]
				(cArqTemp)->TOTAL		+= If(Len(aSaldo) >3,aSaldo[4],0)
			EndIf
			//-- Pesquisa os valores de material de terceiros requisitados para OP
			If SB1->B1_AGREGCU == "1"
				//-- Desconsidera do calculo do saldo em estoque movimentos RE9 e DE9
				If (QtdComp(aDadosCF9[1]) > QtdComp(0)) .Or. (QtdComp(aDadosCF9[2]) > QtdComp(0))
					(cArqTemp)->QUANTIDADE	+= aDadosCF9[1]
					(cArqTemp)->TOTAL		+= aDadosCF9[2]
				EndIf
			EndIf
			//-- Recalcula valor unitario
			If (cArqTemp)->QUANTIDADE > 0
				(cArqTemp)->VALOR_UNIT := (cArqTemp)->(NoRound(TOTAL/QUANTIDADE,nDecVal))
			EndIf
			
			//-- Este Ponto de Entrada foi criado para recalcular o Valor Unitario / Total
			If lCalcUni
				ExecBlock("A460UNIT",.F.,.F.,{SB1->B1_COD,"",mv_par13,cArqTemp,{'aDadosCF9',aDadosCF9[01],aDadosCF9[02]}})
			EndIf
			
			(cArqTemp)->(MsUnLock())
		EndIf
	EndIf
	If mv_par02 == 1 .Or. mv_par02 == 3
		If mv_par22 == 1 .And. !Empty(mv_par23)
			aAuxTer  := SaldoTerc(SB1->B1_COD,cAlmoxIni,"D",mv_par13,cAlmoxFim,.T.,SB1->B1_COD,IIf(lUsaPETN3,lSaldTesN3,nSldTesN3<>0),!mv_par16==1,,.T.,IIF(l460RLoc,{aAlmoxIni,aAlmoxFim},Nil),.T.)
			For nX := 1 to Len(aAuxTer)
				aAdd(aTerceiros,{"4",SubStr(aAuxTer[nX,1],nTPCF+nCLIFOR+nLOJA+1,nPRODUTO),SubStr(aAuxTer[nX,1],nTPCF+1,nCLIFOR),SubStr(aAuxTer[nX,1],nTPCF+nCLIFOR+1,nLOJA),aAuxTer[nX,2],aAuxTer[nX,3],aAuxTer[nX,4],SubStr(aAuxTer[nX,1],1,1)})
			Next nX
		EndIf
	EndIf
	If mv_par02 == 1 .Or. mv_par02 == 4
		If mv_par22 == 1 .And. !Empty(mv_par23)
			aAuxTer  := SaldoTerc(SB1->B1_COD,cAlmoxIni,"T",mv_par13,cAlmoxFim,.T.,SB1->B1_COD,IIf(lUsaPETN3,lSaldTesN3,nSldTesN3<>0),!mv_par16==1,,.T.,IIF(l460RLoc,{aAlmoxIni,aAlmoxFim},Nil),.T.)
			For nX := 1 to Len(aAuxTer)
				aAdd(aTerceiros,{"5",SubStr(aAuxTer[nX,1],nTPCF+nCLIFOR+nLOJA+1,nPRODUTO),SubStr(aAuxTer[nX,1],nTPCF+1,nCLIFOR),SubStr(aAuxTer[nX,1],nTPCF+nCLIFOR+1,nLOJA),aAuxTer[nX,2],Iif(cTipCusto == 'M' .And. nCusMed > 0,(nCusMed*aAuxTer[nX,2]),aAuxTer[nX,3]),aAuxTer[nX,4],SubStr(aAuxTer[nX,1],1,1)})
			Next nX
		EndIf
	EndIf
	
	//-- Processa Saldo De Terceiro TIPO 4 - SALDO DE TERCEIROS
	R460Terceiros(aSaldoTerD,aSaldoTerT,@lEnd,cArqTemp,"4",aDadosCF9,cAliasTop,lTipoBN,cFilCons,IIF(l460RLoc,{aAlmoxIni,aAlmoxFim},Nil),nCusMed)
	
	//-- Processa Saldo Em Terceiro TIPO 5 - SALDO EM TERCEIROS
	R460Terceiros(aSaldoTerD,aSaldoTerT,@lEnd,cArqTemp,"5",NIL,cAliasTop,lTipoBN,cFilCons,IIF(l460RLoc,{aAlmoxIni,aAlmoxFim},Nil),nCusMed)
	
End

//-- Processa Saldo Em Processo TIPO 2 - SALDO EM PROCESSO
If nTpProcesso == 1
	U_XR460EmProcesso(@lEnd,cArqTemp,.F.,,,lTipoBN,cFilCons,,IIF(l460RLoc,{aAlmoxIni,aAlmoxFim},Nil))
Else
	U_XR460AnProcesso(@lEnd,cArqTemp,.F.,,,lTipoBN,IIF(l460RLoc,{aAlmoxIni,aAlmoxFim},Nil))
EndIf

//-- CUSTO UNIFICADO - Realiza acerto dos valores para todos tipos
If lCusUnif .And. (!lConsolida .Or. lCusConFil .Or. nForFilial == Len(aFilsCalc))
	(cArqTemp)->(dbSetOrder(2))
	(cArqTemp)->(dbGotop())
	
	//-- Percorre arquivo de Trabalho
	While !(cArqTemp)->(EOF())
		cSeekUnif   := (cArqTemp)->PRODUTO
		aSeek       := {}
		nValTotUnif := 0
		nQtdTotUnif := 0
		While !(cArqTemp)->(EOF()) .And. cSeekUnif == (cArqTemp)->PRODUTO
			If (!mv_par08 == 1 .And. (cArqTemp)->QUANTIDADE < 0) .Or.;
				(!mv_par09 == 1 .And. (cArqTemp)->QUANTIDADE == 0) .Or.;
				(!mv_par15 == 1 .And. (cArqTemp)->TOTAL == 0)
				(cArqTemp)->(dbSkip())
				Loop
			EndIf
			
			//-- Nao processar o saldo de/em terceiros aglutinado ao custo medio
			If !((cArqTemp)->SITUACAO $ "2457")
				aAdd(aSeek,(cArqTemp)->(Recno()))
				nValTotUnif += (cArqTemp)->TOTAL
				nQtdTotUnif += (cArqTemp)->QUANTIDADE
			EndIf
			(cArqTemp)->(dbSkip())
		End
		
		If Len(aSeek) > 0
			//-- Calcula novo valor unitario
			For nX := 1 To Len(aSeek)
				If QtdComp(nQtdTotUnif) <> QtdComp(0)
					(cArqTemp)->(dbGoto(aSeek[nX]))
					Reclock(cArqTemp,.F.)
					(cArqTemp)->VALOR_UNIT := NoRound(nValTotUnif/nQtdTotUnif,nDecVal)
					(cArqTemp)->TOTAL      := (cArqTemp)->QUANTIDADE * (nValTotUnif/nQtdTotUnif)
					(cArqTemp)->(MsUnlock())
				EndIf
			Next nX
			(cArqTemp)->(dbSkip())
		EndIf
	End
EndIf

//-- Se consolidado e custo unificado por filial, devera agregar no arquivo consolidado
//-- o agregado desta filial e deletar o arquivo desta filial
If lConsolida .And. lCusConFil .And. cArqTemp # aArqCons[1]
	//-- Agrega filial no arquivo consolidado
	(cArqTemp)->(dbGoTop())
	(aArqCons[1])->(dbSetOrder(1))
	While !(cArqTemp)->(EOF())
		If (aArqCons[1])->(dbSeek((cArqTemp)->&((aArqCons[1])->(IndexKey()))))
			RecLock(aArqCons[1],.F.)
		Else
			RecLock(aArqCons[1],.T.)
			(aArqCons[1])->FILIAL	:= (cArqTemp)->FILIAL
			(aArqCons[1])->SITUACAO	:= (cArqTemp)->SITUACAO
			(aArqCons[1])->TIPO		:= (cArqTemp)->TIPO
			(aArqCons[1])->POSIPI	:= (cArqTemp)->POSIPI
			(aArqCons[1])->PRODUTO	:= (cArqTemp)->PRODUTO
			(aArqCons[1])->DESCRICAO:= (cArqTemp)->DESCRICAO
			(aArqCons[1])->UM		:= (cArqTemp)->UM
			(aArqCons[1])->ALIQ		:= (cArqTemp)->ALIQ
			(aArqCons[1])->SITTRIB	:= (cArqTemp)->SITTRIB
			(aArqCons[1])->ARMAZEM	:= (cArqTemp)->ARMAZEM
		EndIf
		(aArqCons[1])->QUANTIDADE	+= (cArqTemp)->QUANTIDADE
		(aArqCons[1])->TOTAL		+= (cArqTemp)->TOTAL
		(aArqCons[1])->VALOR_UNIT	:= (aArqCons[1])->TOTAL / (aArqCons[1])->QUANTIDADE
		(aArqCons[1])->(MsUnLock())
		
		(cArqTemp)->(dbSkip())
	End
	
	//-- Restaura variaveis de controle do arquivo temporario
	cArqTemp  := aArqCons[1]
EndIf

If lImprime
	//-- Muda filial para impressao do cabeçalho (tratamento para consolidado)
	If (nPos := aScan(aFilsCalc,{|x| x[2] == cFilCons})) > 0
		nFilBkp := nForFilial
		nForFilial := nPos
		SM0->(dbSeek(cEmpAnt+aFilsCalc[nForFilial,2]))
		cFilAnt := aFilsCalc[nForFilial,2]
	EndIf
	
	//-- Imprime Modelo P7
	dbSelectArea(cArqTemp)
	(cArqTemp)->(dbSetOrder(1))
	(cArqTemp)->(dbGotop())
	
	//-- Flags de Impressao
	cSitAnt	  := "X"
	aSituacao := {STR0015,STR0016,STR0017,STR0018,STR0019,STR0034, " EM FABRICAÇÃO "}		//" EM ESTOQUE "###" EM PROCESSO "###" SEM MOVIMENTACAO "###" DE TERCEIROS "###" EM TERCEIROS "
	cTipoAnt  := "XX"
	cQuebra   := ""
	
	If lImpSX1
		U_XImpListSX1(STR0001,"MATR460",Tamanho,,.T.)
	EndIf
	
	While !(cArqTemp)->(EOF())
		nLin    := 80
		cSitAnt := (cArqTemp)->SITUACAO
		lImpSit := .T.
		While !(cArqTemp)->(EOF()) .And. cSitAnt == (cArqTemp)->SITUACAO
			cTipoAnt := (cArqTemp)->TIPO
			lImpTipo := .T.
			While !(cArqTemp)->(EOF()) .And. cSitAnt+cTipoAnt == (cArqTemp)->(SITUACAO+TIPO)
				cPosIpi := (cArqTemp)->POSIPI
				nTotIpi := 0
				
				If mv_par21 == 1
					cSitTrib := (cArqTemp)->SITTRIB
					lImpST   := .T.
				EndIf
				
				If nQuebraAliq <> 1
					nAliq    := (cArqTemp)->ALIQ
					lImpAliq := .T.
				EndIf
				
				If mv_par21 == 1
					cQuebra := cSitAnt+cTipoAnt+cSitTrib
					cKeyQbr := 'SITUACAO+TIPO+SITTRIB'
				Else
					cQuebra := IIf(nQuebraAliq == 1,cSitAnt+cTipoAnt+cPosIpi,cSitAnt+cTipoAnt+Str(nAliq,5,2))
					cKeyQbr := IIf(nQuebraAliq == 1,'SITUACAO+TIPO+POSIPI','SITUACAO+TIPO+Str(ALIQ,5,2)')
				EndIf
				
				While !(cArqTemp)->(EOF()) .And. cQuebra == (cArqTemp)->&(cKeyQbr)
					If Interrupcao(@lEnd)
						Exit
					EndIf
					
					//-- Controla impressao de Produtos com saldo negativo ou zerado
					If (!mv_par08 == 1 .And. (cArqTemp)->QUANTIDADE < 0) .Or.;
						(!mv_par09 == 1 .And. (cArqTemp)->QUANTIDADE == 0) .Or.;
						(!mv_par15 == 1 .And. (cArqTemp)->TOTAL == 0)
						(cArqTemp)->(dbSkip())
						Loop
					Else
						nTotIpi += (cArqTemp)->TOTAL
						(cArqTemp)->(R460Acumula(aTotal))
					EndIf
					
					//-- Inicializa array com itens de impressao de acordo com mv_par14
					If mv_par14 == 1
						aImp:= {Alltrim((cArqTemp)->POSIPI),;
						(cArqTemp)->DESCRICAO,;
						(cArqTemp)->UM,;
						Transform((cArqTemp)->QUANTIDADE,IF(nB2QFim>3,"@E 99,999,999.999",cPicB2QFim)),;
						(cArqTemp)->(Transform(Round(TOTAL/QUANTIDADE,nDecVal),cPicB2CM1)),;
						Transform((cArqTemp)->TOTAL,cPicB2VFim ),;
						Nil}
					Else
						aImp:= {Alltrim((cArqTemp)->POSIPI),;
						(cArqTemp)->(Padr(AllTrim(PRODUTO) +" - " +DESCRICAO,35)),;
						(cArqTemp)->UM,;
						Transform((cArqTemp)->QUANTIDADE,IF(nB2QFim>3,"@E 99,999,999.999",cPicB2QFim)),;
						(cArqTemp)->(Transform(Round(TOTAL/QUANTIDADE,nDecVal),cPicB2CM1)),;
						Transform((cArqTemp)->TOTAL,cPicB2VFim),;
						Nil}
					EndIf
					
					(cArqTemp)->(dbSkip())
					
					//-- Salta registros Zerados ou Negativos Conforme Parametros
					//-- Necessario Ajustar Posicao p/ Totalizacao de Grupos (POSIPI)
					While !(cArqTemp)->(EOF()) .And. (	(!mv_par08 == 1 .And. (cArqTemp)->QUANTIDADE < 0) .Or.;
						(!mv_par09 == 1 .And. (cArqTemp)->QUANTIDADE == 0) .Or.;
						(!mv_par15 == 1 .And. (cArqTemp)->TOTAL == 0))
						(cArqTemp)->(dbSkip())
					End
					
					//-- Verifica se imprime total por POSIPI
					If !(cSitAnt+cTipoAnt+cPosIpi == (cArqTemp)->(SITUACAO+TIPO+POSIPI)) .And. nQuebraAliq == 1
						aImp[07] := Transform(nTotIPI,cPicB2VFim)
					EndIf
					
					//-- Imprime cabecalho
					If nLin>55
						R460Cabec(@nLin,@nPagina,.F.,Nil,aFilsCalc[nForFilial,3])
					EndIf
					
					If lImpSit
						FmtLin({"",Padc(aSituacao[Val(cSitAnt)],35,"*"),"","","","",""},aL[15],,,@nLin)
						lImpSit := .F.
					EndIf
					
					If lImpTipo
						SX5->(dbSeek(xFilial("SX5")+"02"+cTipoAnt))
						FmtLin(Array(7),aL[15],,,@nLin)
						FmtLin({"",Padc(" "+SUBSTR(TRIM(X5Descri()),1,26)+" ",35,"*"),"","","","",""},aL[15],,,@nLin)
						FmtLin(Array(7),aL[15],,,@nLin)
						lImpTipo := .F.
					EndIf
					
					If mv_par21 == 1 .And. lImpST
						FmtLin({"",Padc(" "+STR0044+" "+cSitTrib+" ",35,"*"),"","","","",""},aL[15],,,@nLin)
						FmtLin(Array(7),aL[15],,,@nLin)
						lImpST := .F.
					EndIf
					
					If nQuebraAliq <> 1 .And. lImpAliq
						FmtLin({"",Padc(" "+STR0031+Transform(nAliq,"@E 99.99%")+" ",35,"*"),"","","","",""},aL[15],,,@nLin)
						FmtLin(Array(7),aL[15],,,@nLin)
						lImpAliq := .F.
					EndIf
					
					//-- Imprime linhas de detalhe de acordo com parametro (mv_par14)
					FmtLin(aImp,aL[15],,,@nLin)
					
					If nQuebraAliq <> 1 .And. cQuebra <> &(cKeyQbr)
						FmtLin(Array(7),aL[15],,,@nLin)
						nPos := aScan(aTotal,{|x| x[1] == cSitAnt .And. x[2] == cTipoAnt .And. x[6] == nAliq})
						FmtLin({,STR0021+STR0031+Transform(nAliq,"@E 99.99%")+" ===>",,,,,Transform(aTotal[nPos,5], cPicB2VFim)},aL[15],,,@nLin)			//"TOTAL "
						FmtLin(Array(7),aL[15],,,@nLin)
					EndIf
					
					If mv_par21 == 1 .And. cQuebra <> &(cKeyQbr)
						FmtLin(Array(7),aL[15],,,@nLin)
						nPos := aScan(aTotal,{|x| x[1] == cSitAnt .And. x[2] == cTipoAnt .And. x[6] == cSitTrib})
						FmtLin({,STR0021+STR0044+" "+cSitTrib+" ===>",,,,,Transform(aTotal[nPos,5], cPicB2VFim)},aL[15],,,@nLin)	//"TOTAL "
						FmtLin(Array(7),aL[15],,,@nLin)
					EndIf
					
					If nLin >= 55
						R460EmBranco(@nLin,.F.)
					EndIf
				End
			End
			
			//-- Impressao de Totais
			If !Empty(nPos := aScan(aTotal,{|x| x[1] == cSitAnt .And. x[2] == cTipoAnt}))
				If nLin > 55
					R460Cabec(@nLin,@nPagina,.F.,Nil,aFilsCalc[nForFilial,3])
				EndIf
				R460Total(@nLin,aTotal,cSitAnt,cTipoAnt,aSituacao,@nPagina,.F.,Nil,aFilsCalc[nForFilial,3])
			EndIf
		End
		
		nPos := Ascan(aTotal,{|x|x[1]==cSitAnt .And. x[2]==TT})
		If nPos # 0
			R460Total(@nLin,aTotal,cSitAnt,TT,aSituacao,@nPagina,.F.,Nil,aFilsCalc[nForFilial,3])
			If nLin < 57
				R460EmBranco(@nLin,.F.)
			EndIf
			lImpResumo := .T.
		EndIf
	End
	
	R460Cabec(@nLin,@nPagina,.F.,Nil,aFilsCalc[nForFilial,3])
	
	If lImpResumo
		R460Total(@nLin,aTotal,"T",TT,aSituacao,@nPagina,.F.,Nil,aFilsCalc[nForFilial,3])
	Else
		R460SemEst(@nLin,@nPagina,.F.)
	EndIf
	
	R460EmBranco(@nLin,.F.)
	
	//-- Realiza a gravacao do arquivo de trabalho (SPED FISCAL)
	If mv_par22 == 1 .And. !Empty(mv_par23)
		R460GrvTRB(aTerceiros,cArqTemp,aFilsCalc[nForFilial,2],,nQuebrAliq)
	EndIf
	
	//-- Se mudou filial para imprimir cabecalho, retorna
	If !Empty(nFilBkp)
		nForFilial := nFilBkp
		SM0->(dbSeek(cEmpAnt+aFilsCalc[nForFilial,2]))
		cFilAnt := aFilsCalc[nForFilial,2]
	EndIf
EndIf

(cAliasTop)->(dbCloseArea())

//-- Atualiza o log de processamento
ProcLogAtu("MENSAGEM",STR0046,STR0046) //"Processamento Encerrado"
ProcLogAtu("FIM")

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ R460Term ³ Autor ³ Juan Jose Pereira     ³ Data ³ 07.11.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao dos Termos de Abertura e Encerramento do Modelo P7³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd    - variavel que indica se processo foi interrompido ³±±
±±³          ³ wnrel   - nome do arquivo a ser impresso                   ³±±
±±³          ³ cString - tabela sobre a qual o filtro do relatorio sera   ³±±
±±³          ³ executado                                                  ³±±
±±³          ³ tamanho - tamanho configurado para o relatorio             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno  ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR460                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R460Term(lEnd,wnRel,cString,Tamanho)
Local cArqAbert	:= GetMv("MV_LMOD7AB")
Local cArqEncer	:= GetMv("MV_LMOD7EN")
Local aDriver 	:= ReadDriver()
Local aAreaSM0	:= SM0->(GetArea())

If SM0->M0_CODFIL # cFilAnt
	SM0->(dbSeek(cEmpAnt+cFilAnt))
EndIf

XFIS_IMPTERM(cArqAbert,cArqEncer,"MTR460",IIF(aReturn[4] == 1,aDriver[3],aDriver[4]))

RestArea(aAreaSM0)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³R460Terceiros  ³Autor³Juan Jose Pereira   ³ Data ³ 07.11.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Busca Saldo em poder de Terceiros (T) ou de Terceiros (D)   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aSaldoTerD - array de dados dos saldos de terceiros 		  ³±±
±±³			 ³ aSaldoTerT - array de dados dos saldos em terceiros		  ³±±
±±³			 ³ lEnd    - variavel que indica se processo foi interrompido ³±±
±±³          ³ cArqTemp- nome do arquivo de trabalho criado para impressao³±±
±±³          ³ do relatorio                                               ³±±
±±³          ³ cEmdeTerc-String indicando se esta processando saldo de    ³±±
±±³          ³ terceiros ou saldo em terceiros                            ³±±
±±³          ³ executado                                                  ³±±
±±³          ³ aDadosCF9- Array com informacaoes relacionadas a movimentos³±±
±±³          ³ internos RE9/DE9                                           ³±±
±±³          ³ cAliasTop - Alias da query principal (SB2)                 ³±±
±±³          ³ lTipoBN   - Tratamento para produtos BN (Beneficiamento)   ³±±
±±³          ³ cFilCons - Filial que solicitou impressao do relatorio		 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno  ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR460                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R460Terceiros(aSaldoTerD,aSaldoTerT,lEnd,cArqTemp,cEmDeTerc,aDadosCF9,cAliasTop,lTipoBN,cFilCons,aLocDeAte,nCusMed)
Local aSaldo  	:= {0,0,0,0}
Local nX	  	:= 0
Local cLocTerc	:= 'ZZ'//SuperGetMv("MV_ALMTERC",.F.,"")
Local lConTerc  := SuperGetMv("MV_CONTERC",.F.,.F.)
Local aSalAtu 	:= {}
Local cAlmTerc	:= ""
Local lConsolida:= mv_par20 == 1 .And. mv_par24 == 1
Local lCusLocTer:= .F.
Local cTipCusto := SuperGetMv("MV_R460TPC",.F.,"M")


Default aDadosCF9 := {0,0} // Quantidade e custo na 1a moeda para movimentos do SD3 com D3_CF RE9 ou DE9
Default lTipoBN   := .F.
Default aLocDeAte := {}
//Valido o Custo para gerar novamente o valor valor do Custo no armazem AlMterc
lCusLocTer:= (cTipCusto == 'M' .And. lConTerc .And. cEmDeTerc == "5")
If mv_par02 <> 2 .And. !lEnd .And. SB1->B1_FILIAL == xFilial("SB1")
	//-- Pesquisa os valores D == De Terceiros / T == Em Terceiros
	nX := aScan(If(cEmDeTerc=="4",aSaldoTerD,aSaldoTerT),{|x| x[1] == xFilial("SB6")+SB1->B1_COD})
	If !(nX == 0)
		aSaldo[1] := If(cEmDeTerc=="4",aSaldoTerD[nX,3],aSaldoTerT[nX,3])
		aSaldo[2] := If(cEmDeTerc=="4",aSaldoTerD[nX,4],aSaldoTerT[nX,4])
	EndIf
	
	//-- Considera o saldo do armazem do parametro como saldo em terceiros
	If !Empty(cLocTerc) .And. cEmDeTerc == "5" .And. !lConTerc .or. lCusLocTer
		While !Empty(cLocTerc)
			cAlmTerc := SubStr(cLocTerc,1,At("/",cLocTerc)-1)
			cLocTerc := SubStr(cLocTerc,At("/",cLocTerc)+1)
			If !Empty(cAlmTerc) .And. (IIF(Empty(aLocDeAte),.T., R460Local(cAlmTerc,aLocDeAte)))
				If mv_par16 == 1
					aSalatu := CalcEst(SB1->B1_COD,cAlmTerc,mv_par13+1,Nil)
				Else
					aSalatu := CalcEstFF(SB1->B1_COD,cAlmTerc,mv_par13+1,Nil)
				EndIf
				If ! lCusLocTer
					aSaldo[1] +=aSalAtu[01]
					aSaldo[2] +=aSalAtu[02]
				Else
					aSaldo[1] := aSalAtu[01]
					aSaldo[2] := aSalAtu[02]
				EndIf
				
			Else
				Exit
			EndIf
		End
	EndIf
	
	If aSaldo[1]+aSaldo[2] # 0
		(cArqTemp)->(dbSetOrder(2))
		If (cArqTemp)->(dbSeek(SB1->B1_COD+cEmDeTerc))
			RecLock(cArqTemp,.F.)
		Else
			RecLock(cArqTemp,.T.)
			(cArqTemp)->FILIAL		:= xFilial("SB2",cFilCons)
			(cArqTemp)->SITUACAO 	:= cEmDeTerc
			(cArqTemp)->TIPO		:= IIf(lTipoBN,SB1->B1_TIPOBN,SB1->B1_TIPO)
			(cArqTemp)->POSIPI		:= SB1->B1_POSIPI
			(cArqTemp)->PRODUTO		:= SB1->B1_COD
			(cArqTemp)->DESCRICAO	:= SB1->B1_DESC
			(cArqTemp)->UM			:= SB1->B1_UM
			(cArqTemp)->ARMAZEM		:= SB1->B1_LOCPAD
			If nQuebraAliq == 2
				(cArqTemp)->ALIQ := RetFldProd(SB1->B1_COD, "B1_PICM")
			ElseIf nQuebraAliq == 3
				(cArqTemp)->ALIQ := IIf(SB0->(MsSeek(xFilial("SB0")+SB1->B1_COD)),SB0->B0_ALIQRED,0)
			EndIf
			If mv_par21 == 1
				(cArqTemp)->SITTRIB := R460STrib(SB1->B1_COD)
			EndIf
		EndIf
		If cTipCusto == 'M' .And. cEmDeTerc == "5"
			(cArqTemp)->QUANTIDADE	+= aSaldo[01]
			//Considera o Saldo EM TERCEIROS para calcular o saldo somente em terceiros.
			(cArqTemp)->TOTAL		+= iif(nCusMed>0,nCusMed,aSaldo[2]/aSaldo[1]) * aSaldo[01]
		Else
			(cArqTemp)->QUANTIDADE	+= aSaldo[01]
			(cArqTemp)->TOTAL		+= aSaldo[02]
		EndIf
		
		//-- Desconsidera do calculo do saldo do material de terceiros movimentos RE9 e DE9
		If QtdComp(aDadosCF9[1]) > QtdComp(0) .Or. QtdComp(aDadosCF9[2]) > QtdComp(0)
			(cArqTemp)->QUANTIDADE	-= aDadosCF9[1]
			(cArqTemp)->TOTAL		-= aDadosCF9[2]
		EndIf
		If (cArqTemp)->QUANTIDADE > 0
			(cArqTemp)->VALOR_UNIT := NoRound((cArqTemp)->TOTAL/(cArqTemp)->QUANTIDADE,nDecVal)
		EndIf
		
		If lCalcTer == NIL
			lCalcTer := ExistBlock("A460TUNI")
		EndIf
		//-- Este Ponto de Entrada foi criado para recalcular o Valor Unitario/Total
		If lCalcTer
			ExecBlock("A460TUNI",.F.,.F.,{SB1->B1_COD,SuperGetMv("MV_ALMTERC",.F.,""),mv_par13,cArqTemp})
		EndIf
		
		(cArqTemp)->(MsUnLock())
	EndIf
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³U_XR460EmProcesso ³Autor³Microsiga S/A       ³ Data ³ 19.06.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Busca saldo em Processo                                     ³±±
±±³          ³Atualiza aqruivo de trab. c/ Saldo em Processo dos Produtos.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd      - Var. que indica se proc. foi interrompido      ³±±
±±³          ³ cArqTemp  - Nome do arquivo de trabalho                    ³±±
±±³          ³ lGraph    - Nao atualiza regua de progressao               ³±±
±±³          ³ aProdFis  - Informacoes saldo em processo Sintegra         ³±±
±±³          ³ aNCM      - Aglutinacao por NCM processos (Sintegra)       ³±±
±±³          ³ lTipoBN   - Tratamento para produtos BN (Beneficiamento)   ³±±
±±³          ³ cFilCons - Filial que solicitou impressao do relatorio	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno  ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XR460EmProcesso(lEnd,cArqTemp,lGraph,aProdFis,aNCM,lTipoBN,cFilCons,nTpProcesso,aLocDeAte)
Local aA460AMZP	:= {}
Local aCampos   := {}
Local aEmAnalise:= {}
Local aSalAtu   := {}
Local aProducao := {}

Local lEmProcess:= .F.
Local lFiscal	:= .F.
Local lQuerySB1 := .F.
Local lCusFIFO  := SuperGetMV("MV_CUSFIFO",.F.,.F.)
Local nProdPR0  := SuperGetMv("MV_PRODPR0",.F.,1)
Local lMT460EP  := SuperGetMv("MV_MT460EP",.F.,.F.)
Local lM460PRC  := .T.//SuperGetMv("MV_M460PRC",.F.,.F.)
Local lA460AMZP := ExistBlock("A460AMZP")

Local cAliasSB1 := "SB1"
Local cAliasTop := "SD3"
Local cAliasSD3 := "SD3"
Local cArqTemp2 := ""
Local cPeLocProc:= ""
Local cBkLocProc:= ""
Local cArqTemp3 := CriaTrab(Nil,.F.)
Local cLocProc  := 'ZZ' //SuperGetMv("MV_LOCPROC",.F.,"99")
Local aTamC2Qtd := TamSX3("C2_QUANT")

Local nQtMedia  := 0
Local nQtNeces  := 0
Local nQtde     := 0
Local nCusto    := 0
Local nPos      := 0
Local nPos2		:= 0
Local nX        := 0
Local nQtdOrigem:= 0
Local nQtdProduz:= 0
Local nRecnoD3  := 0
Local cQuery    := ""
Local lTemEmp	:= .F.

Default lGraph 		:= .F.
Default lTipoBN     := .F.
Default aProdFis 	:= {}
Default aNCM		:= {}
Default nTpProcesso := 0
Default aLocDeAte   := {}

lFiscal	:= Len(aProdFis) >= 11

//-- A460AMZP - Ponto de Entrada para considerar um armazen
//--            adicional como armazem de processo.
If lA460AMZP
	aA460AMZP := ExecBlock("A460AMZP",.F.,.F.,'')
	If ValType(aA460AMZP)=="A" .And. Len(aA460AMZP) == 1
		cBkLocProc := IIf(Valtype(aA460AMZP[1])=="C",aA460AMZP[1],'')
	EndIf
EndIf

//-- SALDO EM PROCESSO
If ((FunName()=="MATR460" .And. mv_par01 == 1) .Or. nTpProcesso == 1) .And. !lEnd
	//-- Cria arquivo de Trabalho para armazenar as OPs
	aAdd(aCampos,{"OP"		,"C",TamSX3("D3_OP")[1]			,0}) // 01 - OP
	aAdd(aCampos,{"SEQCALC"	,"C",TamSX3("D3_SEQCALC")[1]	,0}) // 02 - SEQCALC
	aAdd(aCampos,{"DATA1"	,"D",8							,0}) // 03 - DATA1
	aAdd(aCampos,{"QUANT"	,"N",aTamC2Qtd[1]		,aTamC2Qtd[2]}) // 04 - QUANT
	aAdd(aCampos,{"RECD3"	,"N",10		,0}) // 05 - RECD3
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ARQUIVO TEMPORARIO DE MEMORIA (CTREETMP)                            ³
	//³A funcao MSOpenTemp ira substituir as duas linhas de codigo abaixo: ³
	//|--> cNomeTrb := CriaTrab(aStruTRB,.T.)                              |
	//|--> dbUseArea(.T.,__LocalDrive,cNomeTrb,cAliasTRB,.F.,.F.)          |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MSOpenTemp(cArqTemp2,aCampos,@cArqTemp2)
	
	//"Criando Indice..."
	IndRegua(cArqTemp2,cArqTemp2,"OP+SEQCALC+DTOS(DATA1)",,,STR0020)
	
	//-- Busca saldo em processo
	SD3->(dbSetOrder(1)) // D3_FILIAL+D3_OP+D3_COD+D3_LOCAL
	cAliasTop := cArqTemp3
	cQuery := "SELECT D3_FILIAL, D3_OP, D3_COD, D3_LOCAL, D3_CF, D3_EMISSAO, D3_SEQCALC, C2_DATRF, C2_QUANT, SD3.R_E_C_N_O_ RECNOSD3 "
	cQuery += "FROM " +RetSqlName("SD3") +" SD3 "
	cQuery += "JOIN "+RetSqlName("SC2")+" SC2 "
	cQuery += "ON SC2.C2_FILIAL = '"+xFilial("SC2")+"' AND SC2.C2_NUM||SC2.C2_ITEM||SC2.C2_SEQUEN||SC2.C2_ITEMGRD = SD3.D3_OP "
	cQuery += "WHERE SD3.D3_FILIAL='" +xFilial("SD3") +"' "
	cQuery += "AND SD3.D3_OP <> '" +Criavar("D3_OP",.F.) + "' "
	cQuery += "AND (SD3.D3_CF ='PR0' OR SD3.D3_CF = 'PR1') "
	If nTpProcesso == 1
		cQuery += "AND SD3.D3_EMISSAO <= '" +IIf(!lFiscal,DTOS(mv_par15),DTOS(aProdFis[10]))+"' "
	Else
		cQuery += "AND SD3.D3_EMISSAO <= '" +DTOS(mv_par13) +"' "
	EndIf
	cQuery += "AND SD3.D3_ESTORNO = ' ' "
	cQuery += "AND SD3.D_E_L_E_T_ = ' ' "
	cQuery += "AND (SC2.C2_DATRF = '"+DTOS(Criavar("C2_DATRF",.F.))+" ' "
	If nTpProcesso == 1
		cQuery += "OR SC2.C2_DATRF <= '"+IIf(!lFiscal,DTOS(mv_par15),DTOS(aProdFis[10]))+" ')"
	Else
		cQuery += "OR SC2.C2_DATRF > '"+DTOS(mv_par13)+" ')"
	EndIf
	cQuery += "AND SC2.D_E_L_E_T_ = ' ' "
	cQuery += "UNION "
	cQuery += "SELECT D3_FILIAL, D3_OP, D3_COD, D3_LOCAL, D3_CF, D3_EMISSAO, D3_SEQCALC, C2_DATRF, C2_QUANT, SD3.R_E_C_N_O_ RECNOSD3 "
	cQuery += "FROM " +RetSqlName("SD3") +" SD3 "
	cQuery += "JOIN "+RetSqlName("SC2")+" SC2 "
	cQuery += "ON SC2.C2_FILIAL = '"+xFilial("SC2")+"' AND SC2.C2_NUM||SC2.C2_ITEM||SC2.C2_SEQUEN||SC2.C2_ITEMGRD = SD3.D3_OP "
	cQuery += "WHERE SD3.D3_FILIAL='" +xFilial("SD3") +"' "
	cQuery += "AND SD3.D3_OP <> '" +Criavar("D3_OP",.F.) + "' "
	cQuery += "AND SD3.D3_COD >= '" +Iif(!lFiscal,mv_par05,aProdFis[01]) +"' "
	cQuery += "AND SD3.D3_COD <= '" +Iif(!lFiscal,mv_par06,aProdFis[02]) +"' "
	cQuery += "AND SD3.D3_CF <>'PR0' AND SD3.D3_CF <>'PR1' "
	If nTpProcesso == 1
		cQuery += "AND SD3.D3_EMISSAO <= '"+IIf(!lFiscal,DTOS(mv_par15),DTOS(aProdFis[10]))+"' "
	Else
		cQuery += "AND SD3.D3_EMISSAO <= '" +DTOS(mv_par13) +"' "
	EndIf
	cQuery += "AND SD3.D3_ESTORNO = ' ' "
	cQuery += "AND SD3.D_E_L_E_T_ = ' ' "
	cQuery += "AND (SC2.C2_DATRF = '"+DTOS(Criavar("C2_DATRF",.F.))+" ' "
	If nTpProcesso == 1
		cQuery += "OR SC2.C2_DATRF <= '"+IIf(!lFiscal,DTOS(mv_par15),DTOS(aProdFis[10]))+" ') "
	Else
		cQuery += "OR SC2.C2_DATRF > '"+DTOS(mv_par13)+" ') "
	EndIf
	cQuery += "AND SC2.D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY " +SqlOrder(SD3->(IndexKey()))
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArqTemp3,.T.,.T.)
	TcSetField(cAliasTop,"D3_EMISSAO","D",8,0)
	
	//-- Armazena OPs e data de emissao no Arquivo de Trabalho
	While !(cAliasTop)->(EOF()) .And. !lEnd
		If Interrupcao(@lEnd)
			Exit
		EndIf
		
		//-- Verifica se o Produto e Valido
		If !Empty(Iif(!lFiscal,mv_par06,aProdFis[02])) ;
			.And. (cAliasTop)->D3_COD > Iif(!lFiscal,mv_par06,aProdFis[02]) ;
			.And. SubStr((cAliasTop)->D3_CF,1,2) != "PR"
			Exit
		EndIf
		
		//-- Verifica se o Produto e Valido
		If !R460AvalProd((cAliasTop)->D3_COD,Iif(!lFiscal,mv_par19==1,aProdFis[11]==1),aProdFis);
			.And. SubStr((cAliasTop)->D3_CF,1,2) != "PR"
			(cAliasTop)->(dbSkip())
			Loop
		EndIf
		
		//-- Armazena OPs e Data de Emissao
		If (cArqTemp2)->(dbSeek((cAliasTop)->D3_OP))
			RecLock(cArqTemp2,.F.)
		Else
			RecLock(cArqTemp2,.T.)
			(cArqTemp2)->OP := (cAliasTop)->D3_OP
		EndIf
		If SubStr((cAliasTop)->D3_CF,1,2) == "PR"
			(cArqTemp2)->DATA1 := Max((cAliasTop)->D3_EMISSAO,(cArqTemp2)->DATA1)
			If !mv_par17 == 1 .And. ((cAliasTop)->D3_SEQCALC > (cArqTemp2)->SEQCALC)
				(cArqTemp2)->SEQCALC := (cAliasTop)->D3_SEQCALC
			EndIf
		EndIf
		(cArqTemp2)->QUANT := (cAliasTop)->C2_QUANT
		(cArqTemp2)->RECD3 := (cAliasTop)->RECNOSD3
		(cArqTemp2)->(MsUnlock())
		
		(cAliasTop)->(dbSkip())
	End
	
	//-- Restaura ambiente e apaga arquivo temporario
	(cAliasTop)->(dbCloseArea())
	
	//-- Gravacao do Saldo em Processo
	(cArqTemp2)->(dbGotop())
	While !(cArqTemp2)->(Eof()) .And. !lEnd
		If Interrupcao(@lEnd)
			Exit
		EndIf
		
		aProducao := {}
		aEmAnalise:= {}
		
		cAliasSD3 := GetNextAlias()
		cQuery := "SELECT SD3.D3_FILIAL, SD3.D3_OP, SD3.D3_COD, SD3.D3_LOCAL, SD3.D3_CF, SD3.D3_EMISSAO, SD3.D3_RATEIO, "
		cQuery += "SD3.D3_SEQCALC, SD3.D3_CUSTO1, SD3.D3_SEQCALC, SD3.D3_QUANT, SD3.D3_ESTORNO, SD3.D3_PERDA,SD3.D3_TRT, SD3.R_E_C_N_O_ RECNOSD3 "
		cQuery += "FROM " +RetSqlName("SD3") +" SD3 "
		cQuery += "WHERE SD3.D3_FILIAL='" +xFilial("SD3") +"' "
		cQuery += "AND SD3.D3_OP = '" +(cArqTemp2)->OP +"' "
		cQuery += "AND SD3.D3_ESTORNO = ' ' "
		If nTpProcesso == 1
			cQuery += "AND SD3.D3_EMISSAO <= '"+IIf(!lFiscal,DTOS(mv_par15),DTOS(aProdFis[10]))+"' "
		Else
			cQuery += "AND SD3.D3_EMISSAO <= '" +DTOS(mv_par13) +"' "
		Endif
		cQuery += "AND SD3.D_E_L_E_T_ = ' ' "
		cQuery += "ORDER BY " +SqlOrder(SD3->(IndexKey()))
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD3,.T.,.T.)
		TcSetField(cAliasSD3,"D3_EMISSAO"	,"D",8,0)
		TcSetField(cAliasSD3,"D3_QUANT"		,"N",TamSX3("D3_QUANT" )[1]	,TamSX3("D3_QUANT" )[2])
		TcSetField(cAliasSD3,"D3_CUSTO1"	,"N",TamSX3("D3_CUSTO1")[1]	,TamSX3("D3_CUSTO1")[2])
		
		While !(cAliasSD3)->(EOF()) .And. !lEnd
			nRecnoD3 := (cAliasSD3)->RECNOSD3
			
			If Interrupcao(@lEnd)
				Exit
			EndIf
			
			//-- Validacao para nao permitir movimento com a data maior que a data de
			//-- encerramento do relatorio.
			If (cAliasSD3)->D3_EMISSAO > IIf(nTpProcesso == 1,IIf(!lFiscal,mv_par15,aProdFis[10]),mv_par13) .Or. (cAliasSD3)->D3_ESTORNO == "S"
				(cAliasSD3)->(dbSkip())
				Loop
			EndIf
			
			//-- Somatoria de todos os apontamentos de producao para esta OP
			If SubStr((cAliasSD3)->D3_CF,1,2) == "PR"
				nPos := aScan(aProducao,{|x| x[1] == (cAliasSD3)->D3_COD})
				If nPos == 0
					(cAliasSD3)->(aAdd(aProducao,{D3_COD,D3_QUANT,D3_CUSTO1,D3_PERDA,D3_RATEIO,D3_LOCAL, RECNOSD3}))
				Else
					aProducao[nPos,2] += (cAliasSD3)->D3_QUANT
					aProducao[nPos,3] += (cAliasSD3)->D3_CUSTO1
					aProducao[nPos,4] += (cAliasSD3)->D3_PERDA
					aProducao[nPos,5] += (cAliasSD3)->D3_RATEIO
				EndIf
			EndIf
			
			//-- Validacao para o Produto                                             ³
			If !R460Local((cAliasSD3)->D3_LOCAL,aLocDeAte) .Or. !R460AvalProd((cAliasSD3)->D3_COD,Iif(!lFiscal,mv_par19==1,aProdFis[11]==1),aProdFis)
				(cAliasSD3)->(dbSkip())
				Loop
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ 6a posicao do array aEmAnalise nao sera gravada com conteudo, pois    ³
			//³ a logica de soma/subtracao das requisicoes/devolucoes jah atende      ³
			//³ os cenarios. Funcao R460GRAVA() sempre somarah a quantidade passada   ³
			//³ no array aEmAnalise neste caso. A 6a posicao do array eh necessaria   ³
			//³ apenas na funcao antiga U_XR460AnProcesso, em que a funcao R460GRAVA     ³
			//³ eh chamada a cada linha da query de movimentacoes SD3 para a OP.      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			//-- Somatoria das Requisicoes para Ordem de Producao
			If SubStr((cAliasSD3)->D3_CF,1,2) == "RE"
				nPos := aScan(aEmAnalise,{|x| x[1] == (cAliasSD3)->D3_COD})
				nPos2:= aScan(aEmAnalise,{|x| x[1] == (cAliasSD3)->D3_TRT})
				If nPos == 0 .OR.( nPos <> 0 .And. nPos2 == 0 )
					aAdd(aEmAnalise,{	(cAliasSD3)->D3_COD		,;	// 01 - Codigo do produto
					(cAliasSD3)->D3_LOCAL	,;	// 02 - Codigo do Armazem
					(cAliasSD3)->D3_QUANT	,;	// 03 - Quantidade
					(cAliasSD3)->D3_CUSTO1	,;	// 04 - Custo na moeda 1
					nRecnoD3				   ,;	// 05 - Recno da tabela SD3
					"" 					      ,;	// 06 - Tipo de movimento RE/DE - nao necessario
					(cAliasSD3)->D3_TRT		;	// 07 - Sequencia do apontamento para produtos iguais no mesmo nivel de estrutura
					})
				Else
					aEmAnalise[nPos,3] += (cAliasSD3)->D3_QUANT
					aEmAnalise[nPos,4] += (cAliasSD3)->D3_CUSTO1
				EndIf
				//-- Somatoria das Devolucoes para Ordem de Producao
			ElseIf SubStr((cAliasSD3)->D3_CF,1,2) == "DE"
				nPos := aScan(aEmAnalise,{|x| x[1] == (cAliasSD3)->D3_COD})
				nPos2:= aScan(aEmAnalise,{|x| x[1] == (cAliasSD3)->D3_TRT})
				If nPos == 0 .OR.( nPos <> 0 .And. nPos2 == 0 )
					aAdd(aEmAnalise,{	(cAliasSD3)->D3_COD								,;	// 01 - Codigo do produto
					(cAliasSD3)->D3_LOCAL							,;	// 02 - Codigo do Armazem
					(cAliasSD3)->D3_QUANT	* (-1)					,;	// 03 - Quantidade
					(cAliasSD3)->D3_CUSTO1	* (-1)					,;	// 04 - Custo na moeda 1
					nRecnoD3										   ,;	// 05 - Recno da tabela SD3
					"" 											      ,; // 06 - Tipo de movimento RE/DE	 - nao necessario
					(cAliasSD3)->D3_TRT								 ;	// 07 - Sequencia do apontamento para produtos iguais no mesmo nivel de estrutura
					})
				Else
					aEmAnalise[nPos,3] -= (cAliasSD3)->D3_QUANT
					aEmAnalise[nPos,4] -= (cAliasSD3)->D3_CUSTO1
				EndIf
			EndIf
			
			(cAliasSD3)->(dbSkip())
		End
		
		//-- ANALISE DE SALDO EM PROCESSO PARA ORDEM DE PRODUCAO
		SC2->(dbSetOrder(1))
		If SC2->(C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD) # xFilial("SC2")+(cArqTemp2)->OP
			SC2->(MsSeek(xFilial("SC2")+(cArqTemp2)->OP))
		EndIf
		
		//-- Analise se existe Requisicao para Ordem de Producao
		If Len(aEmAnalise) > 0
			//-- ANALISE DO SALDO EM PROCESSO ATRAVES DA QUANTIDADE (PADRAO)
			If Len(aProducao) > 0 .And. Substr((cArqTemp2)->OP,7,2) <> 'OS' // OS não realiza empenho
				For nX := 1 To Len(aEmAnalise)
					lTemEmp := .F.
					SD4->(dbSetOrder(2))
					If SD4->(dbSeek(xFilial("SD4")+(cArqTemp2)->OP+aEmAnalise[nX,1]+aEmAnalise[nX,2]))
						While SD4->(!Eof()) .And. SD4->(D4_FILIAL+D4_OP+D4_COD+D4_LOCAL) == (xFilial("SD4")+(cArqTemp2)->OP+aEmAnalise[nX,1]+aEmAnalise[nX,2])
							If aEmAnalise[nX,7]== SD4->D4_TRT
								lTemEmp := .T.
								Exit
							EndIf
							SD4->(dbSkip())
						End
					EndIF
					//-- nProporcao - Variavel utilizada para realizar a proporcao do saldo
					//-- em processo de acordo com a configuracao do parametro MV_PRODPR0
					If lMT460EP
						//-- Calculo da proporcao a ser utilizada no saldo em processo
						If nProdPR0 == 1
							//-- Neste metodo todo o custo e consumido nos primeiros apontamentos
							//-- de producao, por isso nao existe custo somente quantidade em
							//-- processo.
							nProporcao := 0
						ElseIf nProdPR0 == 2
							nProporcao := 1 - (aProducao[1,5] / 100)
							//-- Neste metodo e utilizado o conceito de proporcionalizacao
						ElseIf nProdPR0 == 3
							//-- Quantidade aAberta para producao menos a perda
							nQtdOrigem := SC2->C2_QUANT - SC2->C2_PERDA
							//-- Quantidade produzida menos a perda
							nQtdProduz := aProducao[Len(aProducao),2] - aProducao[Len(aProducao),4]
							//-- Proporcao para custeio do saldo em processo
							nProporcao := 1 - (nQtdProduz / nQtdOrigem)
						EndIf
					EndIf
					
					//-- Flag utilizado para gravar saldo em processo
					lEmProcess := .F.
					//-- Quantidade Media por Producao
					if lTemEmp
						If Rastro(SD4->D4_COD)
							nQtMedia  := U_XM460MdPrc(SD4->D4_COD,SD4->D4_OP,SD4->D4_LOCAL,SC2->C2_QUANT,SD4->D4_TRT)
						Else
							nQtMedia  := SD4->D4_QTDEORI / SC2->C2_QUANT
						EndIf
					else
						nQtMedia := aEmAnalise[nX,3] / (SC2->C2_QUANT - SC2->C2_PERDA)
					endif
					//-- Quantidade necessaria para producao da quantidade apontada
					nQtNeces  := (aProducao[1,2] + aProducao[1,4]) * nQtMedia
					//-- Avalia quantidade em processo
					If (aEmAnalise[nX,3]) > nQtNeces
						If lMT460EP .And. nProdPR0 == 1
							lEmProcess := .F.
						Else
							lEmProcess := .T.
							//-- Proporciona saldo em processo desta requisicao
							nQtde  := aEmAnalise[nX,3] - nQtNeces
							//-- Custo em processo na moeda 1
							If lMT460EP
								nCusto := aEmAnalise[nX,4] * nProporcao
							Else
								nCusto := (aEmAnalise[nX,4] / aEmAnalise[nX,3]) * nQtde
							EndIf
						EndIf
					ElseIf mv_par25 == 1
						lEmProcess := .T.
						nCusto := (aEmAnalise[nX,4] - aEmAnalise[nX,4]) * SC2->C2_QUJE / SC2->C2_QUANT
						nQtde := 0
						nProporcao := 1
					Endif
					
					If mv_par25 == 1 .And. lEmProcess
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//| Alterado configuracao do array aProducao configurado com posicao           |
						//|	fixa pois havera somente um OP para Varias requisicoes no caso 1 para n    |
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						
						If aProducao[1,1] >= mv_par05 .and. aProducao[1,1] <= mv_par06
							nQtde  := If(nX > 1, 0,(cArqTemp2)->QUANT - aProducao[1,2] - aProducao[1,4])
							R460Grava(	aProducao[1,1]	,;	//-- 01. Codigo do Produto
							aProducao[1,6]	,;	//-- 02. Local
							nQtde ,;	//-- 03. Quantidade
							nCusto,;	//-- 04. Custo na moeda 1
							aProducao[1,7]	,;	//-- 05. Recno da tabela SD3
							''	,;	//-- 06. Tipo de movimento RE/DE
							cArqTemp				,;	//-- 07. Alias do arquivo de trabalho
							cAliasSD3			,;	//-- 08. Alias da Query SD3
							Nil					,;	//-- 09. Indica Processamento Sintegra
							Nil					,;	//-- 10. Aglutina o Resultado por NCM
							lTipoBN				,;	//-- 11. Tratamento para Produtos BN
							cFilCons			,; //--  12. Filial que esta processando o rel
							,; //-- 13. aliasSB1
							aProdFis			,; //-- 14. array aProdFis
							mv_par25 == 1	)	//--  15. Secao EM FABRICACAO
						EndIf
					Else
						//-- Grava o Saldo Em Processo
						If lEmProcess .and. aEmAnalise[nX,1] >= mv_par05 .and. aEmAnalise[nX,1] <= mv_par06
							R460Grava(	aEmAnalise[nX,1]	,;	//-- 01. Codigo do Produto
							aEmAnalise[nX,2]	,;	//-- 02. Local
							nQtde					,;	//-- 03. Quantidade
							nCusto				,;	//-- 04. Custo na moeda 1
							aEmAnalise[nX,5]	,;	//-- 05. Recno da tabela SD3
							aEmAnalise[nX,6]	,;	//-- 06. Tipo de movimento RE/DE
							cArqTemp				,;	//-- 07. Alias do arquivo de trabalho
							cAliasSD3			,;	//-- 08. Alias da Query SD3
							Nil					,;	//-- 09. Indica Processamento Sintegra
							Nil					,;	//-- 10. Aglutina o Resultado por NCM
							lTipoBN				,;	//-- 11. Tratamento para Produtos BN
							cFilCons				)	//-- 12. Filial que esta processando o rel
						EndIf
					EndIf
				Next nX
			Else
				//-- Considera todo o saldo requisitado para OP como saldo em processo
				
				If mv_par25 == 1
					If SC2->C2_PRODUTO >= mv_par05 .and. SC2->C2_PRODUTO <= mv_par06
						R460Grava(	SC2->C2_PRODUTO	,;	//-- 01. Codigo do Produto
						SC2->C2_LOCAL		,;	//-- 02. Local
						(cArqTemp2)->QUANT	,;	//-- 03. Quantidade
						U_XR460Sum(2,aEmAnalise)	,;	//-- 04. Custo na moeda 1
						aEmAnalise[1,5]	,;	//-- 05. Recno da tabela SD3
						''             	,;	//-- 06. Tipo de movimento RE/DE
						cArqTemp				,;	//-- 07. Alias do arquivo de trabalho
						cAliasSD3			,;	//-- 08. Alias da Query SD3
						Nil					,;	//-- 09. Indica Processamento Sintegra
						Nil					,;	//-- 10. Aglutina o Resultado por NCM
						lTipoBN				,;	//-- 11. Tratamento para Produtos BN
						cFilCons			,; 	//-- 12. Filial que esta processando o rel
						,; 	//-- 13. aliasSB1
						aProdFis 			,; 	//-- 14. array aProdFis
						mv_par25 == 1	)		//-- 15. Secao EM FABRICACAO
					EndIf
				Else
					
					//-- Considera todo o saldo requisitado para OP como saldo em processo
					For nX := 1 to Len(aEmAnalise)
						//-- Grava o Saldo Em Processo
						If aEmAnalise[nX,1] >= iif(!lFiscal,mv_par05,aProdFis[01]) .and. aEmAnalise[nX,1] <= iif(!lFiscal,mv_par06,aProdFis[02])
							R460Grava(	aEmAnalise[nX,1]	,;	//-- 01. Codigo do Produto
							aEmAnalise[nX,2]	,;	//-- 02. Local
							aEmAnalise[nX,3]	,;	//-- 03. Quantidade
							aEmAnalise[nX,4]	,;	//-- 04. Custo na moeda 1
							aEmAnalise[nX,5]	,;	//-- 05. Recno da tabela SD3
							aEmAnalise[nX,6]	,;	//-- 06. Tipo de movimento RE/DE
							cArqTemp			,;	//-- 07. Alias do arquivo de trabalho
							cAliasSD3    		,;  //-- 08. Alias da Query SD3
							lFiscal			,;  //-- 09. Indica se o processamento e para o Sintegra e nao para geracao do Livro
							@aNCM				,;  //-- 10. Array para aglutinar por NCM os saldos em processo
							lTipoBN			,;	//-- 11. Tratamento para Produtos BN
							cFilCons			,;	//-- 12. Filial que esta processando o rel
							,; //-- 13. AliasSB1
							aProdFis		,;  //-- 14. array com os parametros fiscais
							mv_par25 == 1  	)	//--  15. Secao EM FABRICACAO
						EndIf
					Next nX
				EndIf
			EndIf
		EndIf
		//-- Finaliza a Query para esta OP
		(cAliasSD3)->(dbCloseArea())
		(cArqTemp2)->(dbSkip())
	End
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ARQUIVO TEMPORARIO DE MEMORIA (CTREETMP)                            ³
	//³A funcao MSCloseTemp ira substituir a linha de codigo abaixo:       ³
	//|--> dbCloseArea()                                                   |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//-- Apaga arquivos temporarios
	MSCloseTemp(cArqTemp2,cArqTemp2)
	
	#IFDEF TOP
		lQuerySB1 := .T.
		cAliasSB1 := GetNextAlias()
		cQuery := "SELECT * "
		cQuery += "FROM " +RetSqlName("SB1") +" SB1 "
		cQuery += "WHERE SB1.B1_FILIAL='" +xFilial("SB1") +"' "
		cQuery +=  " AND SB1.B1_COD >= '" +Iif(!lFiscal,mv_par05,aProdFis[01]) +"' "
		cQuery +=  " AND SB1.B1_COD <= '" +Iif(!lFiscal,mv_par06,aProdFis[02]) +"' "
		cQuery +=  " AND SB1.B1_APROPRI = 'I' "
		cQuery +=  " AND SB1.D_E_L_E_T_ = ' ' "
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB1,.T.,.T.)
	#ELSE
		//-- Busca saldo em processo dos materiais de uso indireto
		SB1->(MsSeek(xFilial("SB1")))
	#ENDIF
	
	While !(cAliasSB1)->(EOF()) .And. !lEnd .And. IIf(lQuerySB1,.T.,xFilial("SB1")==SB1->B1_FILIAL)
		
		If !lGraph .And. Interrupcao(@lEnd)
			Exit
		EndIf
		
		If !R460AvalProd((cAliasSB1)->B1_COD,Iif(!lFiscal,mv_par20==1,aProdFis[11]==1),aProdFis)
			(cAliasSB1)->(dbSkip())
			Loop
		EndIf
		
		if B1_COD=='50004070002BR'
		   MSGALERT('50004070002BR')
		ENDIF   
		
		If !lM460PRC .And. !((cAliasSB1)->B1_APROPRI == "I")
			(cAliasSB1)->(dbSkip())
			Loop
		EndIf
		
		If mv_par16 == 1
			aSalatu := CalcEst((cAliasSB1)->B1_COD,cLocProc,IIf(nTpProcesso == 1,IIf(!lFiscal,mv_par15,aProdFis[10]),mv_par13)+1,nil)
		Else
			aSalatu := CalcEstFF((cAliasSB1)->B1_COD,cLocProc,IIf(nTpProcesso == 1,IIf(!lFiscal,mv_par15,aProdFis[10]),mv_par13)+1,nil)
		EndIf
		
		//-- Grava o Saldo Em Processo
		R460Grava(	(cAliasSB1)->B1_COD	,;	//-- 01. Codigo do Produto
		cLocProc	 			,;	//-- 02. Local
		aSalAtu[1]			,;	//-- 03. Quantidade
		aSalAtu[2]			,;	//-- 04. Custo na moeda 1
		Nil					,;	//-- 05. Recno da tabela SD3
		Nil					,;	//-- 06. Tipo de movimento RE/DE
		cArqTemp	 		  	,;	//-- 07. Alias do arquivo de trabalho
		Nil   				,;	//-- 08. Alias da Query SD3
		lFiscal       	    ,;	//-- 09. Indica se o processamento e para o Sintegra e nao para geracao do Livro
		@aNCM					,;	//-- 10. Array para aglutinar por NCM os saldos em processo
		lTipoBN				,;	//-- 11. Tratamento para Produtos BN
		cFilCons				,;	//-- 12. Filial que esta processando o rel
		cAliasSB1             )	//-- 13. Alias temporario para tabela SB1
		
		//-- A460AMZP - Ponto de entrada utilizado para definir um armazem
		//--            padrao como armazem de processo.
		cPeLocProc := cBkLocProc
		If !Empty(cPeLocProc)
			While !Empty(cPeLocProc)
				cAlmProc   := SubStr(cPeLocProc,1,At("/",cPeLocProc)-1)
				cPeLocProc := SubStr(cPeLocProc,At("/",cPeLocProc)+1)
				If !Empty(cAlmProc)
					If mv_par16 == 1
						aSalatu:=CalcEst((cAliasSB1)->B1_COD,cAlmProc,IIf(nTpProcesso == 1,IIf(!lFiscal,mv_par15,aProdFis[10]),mv_par13)+1,nil)
					Else
						aSalatu:=CalcEstFF((cAliasSB1)->B1_COD,cAlmProc,IIf(nTpProcesso == 1,IIf(!lFiscal,mv_par15,aProdFis[10]),mv_par13)+1,nil)
					EndIf
					
					//-- Grava o Saldo Em Processo
					R460Grava(	(cAliasSB1)->B1_COD	,;	//-- 01. Codigo do Produto
					cAlmProc				,;	//-- 02. Local
					aSalAtu[1]			,;	//-- 03. Quantidade
					aSalAtu[2]			,;	//-- 04. Custo na moeda 1
					Nil					,;	//-- 05. Recno da tabela SD3
					Nil					,;	//-- 06. Tipo de movimento RE/DE
					cArqTemp	 		  	,;	//-- 07. Alias do arquivo de trabalho
					Nil   				,;	//-- 08. Alias da Query SD3
					lFiscal      	    	,;	//-- 09. Indica se o processamento e para o Sintegra e nao para geracao do Livro
					@aNCM					,;	//-- 10. Array para aglutinar por NCM os saldos em processo
					lTipoBN				,;	//-- 11. Tratamento para Produtos BN
					cFilCons				,;	//-- 12. Filial que esta processando o rel
					cAliasSB1             )	//-- 13. Alias temporario para tabela SB1
				Else
					Exit
				EndIf
			End
		EndIf
		
		(cAliasSB1)->(dbSkip())
	End
	
	// Encerra a area de trabalho temporaria
	If lQuerySB1
		(cAliasSB1)->(dbCloseArea())
	EndIf
	
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³R460Cabec()    ³Autor³Juan Jose Pereira   ³ Data ³ 07.11.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cabecalho do Modelo P7                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nLin - Numero da linha corrente                            ³±±
±±³          ³ nPagina - Numero da pagina corrente                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno  ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R460Cabec(nLin,nPagina,lGraph,oReport,cFilNome)
Local aL		:= R460LayOut(lGraph)
Local cPicCgc	:= ""

Default lGraph	 := .F.
Default cFilNome := ""

If cPaisLoc == "ARG"
	cPicCgc	:= "@R 99-99.999.999-9"
ElseIf cPaisLoc == "CHI"
	cPicCgc	:= "@R XX.999.999-X"
ElseIf cPaisLoc $ "POR|EUA"
	cPicCgc	:= PesqPict("SA2","A2_CGC")
Else
	cPicCgc	:= "@R 99.999.999/9999-99"
EndIf

//-- Posiciona na Empresa/Filial a ser processada
If mv_par20 == 1
	SM0->(dbSeek(cEmpAnt+cFilAnt))
EndIf

nLin:=1
If !lGraph
	@00,00 PSAY AvalImp(132)
	FmtLin(,aL[01],,,@nLin)
	FmtLin(,aL[02],,,@nLin)
	FmtLin(,aL[03],,,@nLin)
	If cFilNome != ""
		FmtLin({SM0->M0_NOMECOM,cFilNome},aL[04],,,@nLin)
	Else
		FmtLin({SM0->M0_NOMECOM},aL[04],,,@nLin)
	EndIf
	FmtLin(,aL[05],,,@nLin)
	If cPaisLoc == "CHI"
		FmtLin({,Transform(SM0->M0_CGC,cPicCgc)},aL[06],,,@nLin)
	Else
		FmtLin({InscrEst(),Transform(SM0->M0_CGC,cPicCgc)},aL[06],,,@nLin)
	EndIf
	
	FmtLin(,aL[07],,,@nLin)
	FmtLin({Transform(StrZero(nPagina,6),"@R 999.999"),DTOC(mv_par13)},aL[08],,,@nLin)
	FmtLin(,aL[09],,,@nLin)
	FmtLin(,aL[10],,,@nLin)
	FmtLin(,aL[11],,,@nLin)
	FmtLin(,aL[12],,,@nLin)
	FmtLin(,aL[13],,,@nLin)
	FmtLin(,aL[14],,,@nLin)
Else
	//-- Reinicia Paginas
	oReport:EndPage()
	
	U_XFmtLinR4(oReport,,''    ,,,@nLin)
	U_XFmtLinR4(oReport,,aL[01],,,@nLin)
	U_XFmtLinR4(oReport,,aL[02],,,@nLin)
	U_XFmtLinR4(oReport,,aL[03],,,@nLin)
	If cFilNome != ""
		U_XFmtLinR4(oReport,{SM0->M0_NOMECOM,cFilNome},aL[04],,,@nLin)
	Else
		U_XFmtLinR4(oReport,{SM0->M0_NOMECOM},aL[04],,,@nLin)
	EndIf
	U_XFmtLinR4(oReport,,aL[05],,,@nLin)
	If cPaisLoc == "CHI"
		U_XFmtLinR4(oReport,{,Transform(SM0->M0_CGC,cPicCgc)},aL[06],,,@nLin)
	Else
		U_XFmtLinR4(oReport,{InscrEst(),Transform(SM0->M0_CGC,cPicCgc)},aL[06],,,@nLin)
	EndIf
	
	U_XFmtLinR4(oReport,,aL[07],,,@nLin)
	U_XFmtLinR4(oReport,{Transform(StrZero(nPagina,6),"@R 999.999"),DTOC(mv_par13)},aL[08],,,@nLin)
	U_XFmtLinR4(oReport,,aL[09],,,@nLin)
	U_XFmtLinR4(oReport,,aL[10],,,@nLin)
	U_XFmtLinR4(oReport,,aL[11],,,@nLin)
	U_XFmtLinR4(oReport,,aL[12],,,@nLin)
	U_XFmtLinR4(oReport,,aL[13],,,@nLin)
	U_XFmtLinR4(oReport,,aL[14],,,@nLin)
EndIf

nPagina := nPagina +1

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³R460EmBranco() ³Autor³Juan Jose Pereira   ³ Data ³ 07.11.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Preenche o resto da pagina em branco                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nLin - Numero da linha corrente                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno  ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R460EmBranco(nLin,lGraph,oReport)
Local aL := R460Layout(lGraph)

Default lGraph := .F.

If !lGraph
	While nLin<=55
		FmtLin(Array(7),aL[15],,,@nLin)
	End
	FmtLin(,aL[16],,,@nLin)
Else
	While nLin <= 55
		U_XFmtLinR4(oReport,Array(7),aL[15],,,@nLin)
	End
	U_XFmtLinR4(oReport,,aL[16],,,@nLin)
	oReport:EndPage()
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³R460AvalProd() ³Autor³Juan Jose Pereira   ³ Data ³ 07.11.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Avalia se produto deve ser listado                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cProduto - Codigo do produto avaliado                      ³±±
±±³          ³ lConsMod - Flag que indica se devem ser considerados       ³±±
±±³          ³ produtos MOD                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno  ³ LOGICO indicando se o produto deve ser listado             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R460AvalProd(cProduto,lConsMod,aProdFis)
Local lRet			:= .T.
Local aAreaAnt	:= GetArea()
Local lFiscal := .F.
Default lConsMod	:= .F.
Default aProdFis := {}

If ValType(aProdFis)=='A'
	lFiscal:=len(aProdFis) >=11
Endif

//Verifica se o(s) produto(s) estão relacionados nos parâmetros De / Ate
lRet := lRet .And. (cProduto >= iif(!lFiscal,mv_par05,aProdFis[01]) .And. cProduto <= iif(!lFiscal,mv_par06,aProdFis[02]))

//Executa filtro do usuario, se houver
If !Empty(cFilUsrSB1)
	dbSelectArea("SB1")
	dbSetOrder(1)
	If MsSeek(xFilial("SB1")+cProduto)
		lRet := &(cFilUsrSB1)
	Else
		lRet := .F.
	EndIf
EndIf

// Verifica se o produto deve ser listado
lRet := lRet .And. IIf(lConsMod,.T.,!IsProdMod(cProduto))

RestArea(aAreaAnt)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³R460Local      ³Autor³Juan Jose Pereira   ³ Data ³ 07.11.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Avalia se Local deve ser listado                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cLocal - Codigo do armazem avaliado                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno  ³ LOGICO indicando se o armazem deve ser listado             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R460Local(cLocal,aLocDeAte)
Local nX   := 0
Local lRet := .F.
Default aLocDeAte := {}

If Empty(aLocDeAte)
	lRet := cLocal >= cAlmoxIni .And. cLocal <= cAlmoxFim
Else
	For nX := 1 To Len(aLocDeAte[1])
		If cLocal >= aLocDeAte[1][nX] .And. cLocal <= aLocDeAte[2][nX]
			lRet := .T.
			Exit
		EndIf
	Next nX
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³R460Acumula()  ³Autor³Juan Jose Pereira   ³ Data ³ 07.11.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Acumulador de totais                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aTotal - Array com totalizadores do relatorio              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno  ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R460Acumula(aTotal)
Local nPos := 0

If mv_par21 == 1
	nPos := aScan(aTotal,{|x| x[1] == SITUACAO .And. x[2] == TIPO .And. x[6] == SITTRIB})
ElseIf nQuebraAliq == 1
	nPos := aScan(aTotal,{|x| x[1] == SITUACAO .And. x[2] == TIPO})
Else
	nPos := aScan(aTotal,{|x| x[1] == SITUACAO .And. x[2] == TIPO .And. x[6] == ALIQ})
EndIf

If nPos == 0
	If mv_par21 == 1
		aAdd(aTotal,{SITUACAO,TIPO,QUANTIDADE,VALOR_UNIT,TOTAL,SITTRIB})
	Else
		If nQuebraAliq == 1
			aAdd(aTotal,{SITUACAO,TIPO,QUANTIDADE,VALOR_UNIT,TOTAL})
		Else
			aAdd(aTotal,{SITUACAO,TIPO,QUANTIDADE,VALOR_UNIT,TOTAL,ALIQ})
		EndIf
	EndIf
Else
	aTotal[nPos,3]+=QUANTIDADE
	aTotal[nPos,4]+=VALOR_UNIT
	aTotal[nPos,5]+=TOTAL
EndIf

If (nPos := aScan(aTotal,{|x| x[1] == SITUACAO .And. x[2] == TT})) == 0
	aAdd(aTotal,{SITUACAO,TT,QUANTIDADE,VALOR_UNIT,TOTAL,IIf(mv_par21 == 1,'',0)})
Else
	aTotal[nPos,3] += QUANTIDADE
	aTotal[nPos,4] += VALOR_UNIT
	aTotal[nPos,5] += TOTAL
EndIf

If (nPos := aScan(aTotal,{|x| x[1] == "T" .And. x[2] == TT})) == 0
	AADD(aTotal,{"T",TT,QUANTIDADE,VALOR_UNIT,TOTAL,IIf(mv_par21 == 1,'',0)})
Else
	aTotal[nPos,3]+=QUANTIDADE
	aTotal[nPos,4]+=VALOR_UNIT
	aTotal[nPos,5]+=TOTAL
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³R460Total()    ³Autor³Juan Jose Pereira   ³ Data ³ 07.11.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Imprime totais                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nLin  - Numero da linha corrente                           ³±±
±±³          ³ aTotal- Array com totalizadores do relatorio               ³±±
±±³          ³ cSituacao- Indica se deve imprimir total geral ou do grupo ³±±
±±³          ³ cTipo - Tipo que esta sendo totalizado                     ³±±
±±³          ³ aSituacao - Array com descricao da situacao totalizada     ³±±
±±³          ³ nPagina - Numero da pagina corrente                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno  ³ LOGICO indicando se o armazem deve ser listado             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R460Total(nLin,aTotal,cSituacao,cTipo,aSituacao,nPagina,lGraph,oReport,cFilNome)
Local aL     	:= R460LayOut(lGraph)
Local nPos   	:= 0
Local i      	:= 0
Local nTotal 	:= 0
Local nStart 	:= 1
Local cSitAnt	:= "X"
Local cTipAnt	:= "X"
Local cSubtitulo:= ""
Local cPicB2VFim	:= "@E 999,999,999,999.99"

Default lGraph := .F.

If !lGraph
	FmtLin(Array(7),aL[15],,,@nLin)
Else
	U_XFmtLinR4(oReport,Array(7),aL[15],,,@nLin)
EndIf

If cSituacao != "T"
	//-- Imprime totais dos grupos                                    ³
	If cTipo != TT
		nPos := aScan(aTotal,{|x| x[1] == cSituacao .And. x[2] == cTipo})
		SX5->(dbSeek(xFilial("SX5")+"02"+cTipo))
		If nQuebraAliq == 1 .And. !mv_par21 == 1
			If !lGraph
				FmtLin({,STR0021+SUBSTR(TRIM(X5Descri()),1,26)+" ===>",,,,,Transform(aTotal[nPos,5], cPicB2VFim)},aL[15],,,@nLin)			//"TOTAL "
			Else
				U_XFmtLinR4(oReport,{,SUBSTR(TRIM(X5Descri()),1,26)+" ===>",,,,,Transform(aTotal[nPos,5], cPicB2VFim)},aL[15],,,@nLin)			//"TOTAL "
			EndIf
		Else
			nTotal := 0
			nStart := aScan(aTotal,{|x| x[1] == cSituacao .And. x[2] == cTipo})
			While (nPos := aScan(aTotal,{|x| x[1] == cSituacao .And. x[2] == cTipo},nStart)) > 0
				If nPos > 0
					nTotal += aTotal[nPos,5]
				EndIf
				If (nStart := ++nPos) > Len(aTotal)
					Exit
				EndIf
			End
			If !lGraph
				FmtLin({,STR0021+SUBSTR(TRIM(X5Descri()),1,26)+" ===>",,,,,Transform(nTotal, cPicB2VFim)},aL[15],,,@nLin)			//"TOTAL "
			Else
				U_XFmtLinR4(oReport,{,STR0021+SUBSTR(TRIM(X5Descri()),1,26)+" ===>",,,,,Transform(nTotal, cPicB2VFim)},aL[15],,,@nLin)	//"TOTAL "
			EndIf
		EndIf
	Else
		nPos := aScan(aTotal,{|x| x[1] == cSituacao .And. x[2] == TT})
		If !lGraph
			FmtLin({,STR0021+aSituacao[Val(cSituacao)]+" ===>",,,,,Transform(aTotal[nPos,5], cPicB2VFim)},aL[15],,,@nLin)	//"TOTAL "
		Else
			U_XFmtLinR4(oReport,{,STR0021+aSituacao[Val(cSituacao)]+" ===>",,,,,Transform(aTotal[nPos,5], cPicB2VFim)},aL[15],,,@nLin)	//"TOTAL "
		EndIf
	EndIf
	If nLin >= 55
		R460EmBranco(@nLin,If(!lGraph,.F.,.T.),If(lGraph,oReport,))
	EndIf
Else
	//-- Imprime resumo final
	If mv_par21 == 1
		aTotal := aSort(aTotal,,,{|x,y|x[1]+x[2]+x[6]<y[1]+y[2]+y[6]})
	Else
		aTotal := aSort(aTotal,,,{|x,y|x[1]+x[2]<y[1]+y[2]})
	EndIf
	If !lGraph
		FmtLin(Array(7),aL[15],,,@nLin)
		FmtLin({,STR0022,,,,,},aL[15],,,@nLin)				//"R E S U M O"
		FmtLin({,"***********",,,,,},aL[15],,,@nLin)
	Else
		U_XFmtLinR4(oReport,Array(7),aL[15],,,@nLin)
		U_XFmtLinR4(oReport,{,STR0022,,,,,},aL[15],,,@nLin)		//"R E S U M O"
		U_XFmtLinR4(oReport,{,"***********",,,,,},aL[15],,,@nLin)
	EndIf
	For i := 1 To Len(aTotal)
		If nLin > 55
			If !lGraph
				R460Cabec(@nLin,@nPagina,.F.,NIL,cFilNome)
				FmtLin(Array(7),aL[15],,,@nLin)
			Else
				R460Cabec(@nLin,@nPagina,.T.,oReport,cFilNome)
				U_XFmtLinR4(oReport,Array(7),aL[15],,,@nLin)
			EndIf
		EndIf
		//-- Nao imprime produtos sem movimentacao
		If aTotal[i,1] == "3"
			Loop
		EndIf
		If cSitAnt != aTotal[i,1]
			cSitAnt := aTotal[i,1]
			If aTotal[i,1] != "T"
				If !lGraph
					FmtLin(Array(7),aL[15],,,@nLin)
					cSubTitulo:=Alltrim(aSituacao[Val(aTotal[i,1])])
					FmtLin({,cSubtitulo,,,,,},aL[15],,,@nLin)
					FmtLin({,Replic("*",Len(cSubtitulo)),,,,,},aL[15],,,@nLin)
				Else
					U_XFmtLinR4(oReport,Array(7),aL[15],,,@nLin)
					cSubTitulo:=Alltrim(aSituacao[Val(aTotal[i,1])])
					U_XFmtLinR4(oReport,{,cSubtitulo,,,,,},aL[15],,,@nLin)
					U_XFmtLinR4(oReport,{,Replic("*",Len(cSubtitulo)),,,,,},aL[15],,,@nLin)
				EndIf
			Else
				If !lGraph
					FmtLin(Array(7),aL[15],,,@nLin)
					FmtLin({,STR0023,,,,,Transform(aTotal[i,5],cPicB2VFim)},aL[15],,,@nLin)		//"TOTAL GERAL ====>"
				Else
					U_XFmtLinR4(oReport,Array(7),aL[15],,,@nLin)
					U_XFmtLinR4(oReport,{,STR0023,,,,,Transform(aTotal[i,5],cPicB2VFim)},aL[15],,,@nLin)		//"TOTAL GERAL ====>"
				EndIf
			EndIf
		EndIf
		If aTotal[i,1] != "T"
			If aTotal[i,2] != TT
				If cTipAnt != aTotal[i,2] .And. cSitAnt == aTotal[i,1]
					cTipAnt := aTotal[i,2]
					SX5->(dbSeek(xFilial("SX5")+"02"+aTotal[i,2]))
					If nQuebraAliq == 1 .And. !mv_par21 == 1
						If !lGraph
							FmtLin({,SUBSTR(TRIM(X5Descri()),1,26),,,,,Transform(aTotal[i,5],cPicB2VFim)},aL[15],,,@nLin)
						Else
							U_XFmtLinR4(oReport,{,SUBSTR(TRIM(X5Descri()),1,26),,,,,Transform(aTotal[i,5],cPicB2VFim)},aL[15],,,@nLin)
						EndIf
					Else
						nTotal := 0
						nStart := aScan(aTotal,{|x| x[1] == cSitAnt .And. x[2] == cTipAnt})
						While (nPos := aScan(aTotal,{|x| x[1]== cSitAnt .And. x[2] == cTipAnt},nStart)) > 0
							If nPos > 0
								nTotal += aTotal[nPos,5]
							EndIf
							If (nStart := ++nPos) > Len(aTotal)
								Exit
							EndIf
						End
						If i <> 1
							If !lGraph
								FmtLin(Array(7),aL[15],,,@nLin)
							Else
								U_XFmtLinR4(oReport,Array(7),aL[15],,,@nLin)
							EndIf
						EndIf
						If !lGraph
							FmtLin({,SUBSTR(TRIM(X5Descri()),1,26),,,,,Transform(nTotal,cPicB2VFim)},aL[15],,,@nLin)
						Else
							U_XFmtLinR4(oReport,{,SUBSTR(TRIM(X5Descri()),1,26),,,,,Transform(nTotal,cPicB2VFim)},aL[15],,,@nLin)
						EndIf
					EndIf
				EndIf
				If nQuebraAliq <> 1
					If !lGraph
						FmtLin({,STR0031+Transform(aTotal[i,6],"@E 99.99%"),,,,,Transform(aTotal[i,5], cPicB2VFim)},aL[15],,,@nLin)
					Else
						U_XFmtLinR4(oReport,{,STR0031+Transform(aTotal[i,6],"@E 99.99%"),,,,,Transform(aTotal[i,5], cPicB2VFim)},aL[15],,,@nLin)
					EndIf
				EndIf
				If mv_par21 == 1
					If !lGraph
						FmtLin({,STR0044+" "+aTotal[i,6],,,,,Transform(aTotal[i,5], cPicB2VFim)},aL[15],,,@nLin)
					Else
						U_XFmtLinR4(oReport,{,STR0044+" "+aTotal[i,6],,,,,Transform(aTotal[i,5], cPicB2VFim)},aL[15],,,@nLin)
					EndIf
				EndIf
			Else
				If !lGraph
					FmtLin({,STR0024,,,,,Transform(aTotal[i,5], cPicB2VFim)},aL[15],,,@nLin)			//"TOTAL ====>"
				Else
					U_XFmtLinR4(oReport,{,STR0024,,,,,Transform(aTotal[i,5], cPicB2VFim)},aL[15],,,@nLin)			//"TOTAL ====>"
				EndIf
				cTipAnt := "X"
			EndIf
		EndIf
		If nLin >= 55
			R460EmBranco(@nLin,If(!lGraph,.F.,.T.),If(lGraph,oReport,))
		EndIf
	Next i
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³R460SemEst()   ³Autor³Rodrigo A Sartorio  ³ Data ³ 31.10.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Imprime informacao sem estoque                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nLin - Numero da linha corrente                            ³±±
±±³          ³ nPagina - Numero da pagina corrente                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R460SemEst(nLin,nPagina,lGraph,oReport)
Local aL := R460LayOut(lGraph)

Default lGraph := .F.

If !lGraph
	FmtLin(Array(7),aL[15],,,@nLin)
	FmtLin({,STR0030,,,,,},aL[15],,,@nLin) //"ESTOQUE INEXISTENTE"
Else
	U_XFmtLinR4(oReport,Array(7),aL[15],,,@nLin)
	U_XFmtLinR4(oReport,{,STR0030,,,,,},aL[15],,,@nLin) //"ESTOQUE INEXISTENTE"
EndIf

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³U_XImpListSX1³ Autor ³ Nereu Humberto Junior ³ Data ³ 01.08.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de impressao da lista de parametros do SX1 sem cabec³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ U_XImpListSX1(titulo,nomeprog,tamanho,char,lFirstPage)        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cTitulo - Titulo                                           ³±±
±±³          ³ cNomPrg - Nome do programa                                 ³±±
±±³          ³ nTamanho- Tamanho                                          ³±±
±±³          ³ nchar   - Codigo de caracter                               ³±±
±±³          ³ lFirstpage - Flag que indica se esta na primeira pagina    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER Function XImpListSX1(cTitulo,cNomPrg,nTamanho,nChar,lFirstPage)
Local cAlias	:= ""
Local cVar		:= ""
Local nCont		:= 0
Local nLargura	:= 0
Local nLin		:= 0
Local nTamSX1 	:= Len(SX1->X1_GRUPO)
Local lWin		:=.F.
Local aDriver 	:= ReadDriver()

lWin := "DEFAULT"$ FWSFUser(PswRecno(),"PROTHEUSPRINTER","USR_DRIVEIMP")

nLargura   := IIf(nTamanho=="P",80,IIf(nTamanho=="G",220,132))
cTitulo    := IIf(TYPE("NewHead")!="U",NewHead,cTitulo)
lFirstPage := IIf(lFirstPage==Nil,.F.,lFirstPage)

If lFirstPage
	If GetMv("MV_SALTPAG",,"S") == "N"
		Setprc(0,0)
	EndIf
	If nChar == NIL
		@0,0 PSAY AvalImp(132)
	Else
		If nChar == 15
			@0,0 PSAY &(if(nTamanho=="P",aDriver[1],if(nTamanho=="G",aDriver[5],aDriver[3])))
		Else
			@0,0 PSAY &(if(nTamanho=="P",aDriver[2],if(nTamanho=="G",aDriver[6],aDriver[4])))
		EndIf
	EndIf
EndIf

cFileLogo := "LGRL"+SM0->M0_CODIGO+SM0->M0_CODFIL+".BMP" // Empresa+Filial
If !File(cFileLogo)
	cFileLogo := "LGRL"+SM0->M0_CODIGO+".BMP" // Empresa
EndIf

__ChkBmpRlt(cFileLogo) // Seta o bitmap, mesmo que seja o padrão da microsiga

If GetMv("MV_IMPSX1") == "S" .And. Substr(cAcesso,101,1) == "S" .And. m_pag == 1  // Imprime pergunta no cabecalho
	nLin   := 0
	nLin   := SendCabec(lWin, nLargura, cNomPrg, RptParam+" - "+Alltrim(cTitulo), "", "", .F.)
	cAlias := Alias()
	dbSelectArea("SX1")
	dbSeek(PADR("MTR460",nTamSX1))
	While !EOF() .And. X1_GRUPO == PADR("MTR460",nTamSX1)
		cVar := "MV_PAR" +StrZero(Val(X1_ORDEM),2,0)
		nLin += 1
		@nLin,5 PSAY RptPerg +" " +X1_ORDEM +" : " +ALLTRIM(X1_PERGUNTA)
		If X1_GSC == "C"
			xStr := StrZero(&(cVar),2)
		EndIf
		@ nLin,Pcol()+3 PSAY IIF(X1_GSC!='C',&(cVar),IIF(&(cVar)>0,X1_DEF&xStr,""))
		dbSkip()
	EndDo
	
	cFiltro := IIF(!Empty(aReturn[7]),MontDescr(cAlias,aReturn[7]),"")
	nCont := 1
	
	If !Empty(cFiltro)
		nLin += 2
		@ nLin,5 PSAY OemToAnsi(STR0032) +Substr(cFiltro,nCont,nLargura-19)  // "Filtro      : "
		While Len(Alltrim(Substr(cFiltro,nCont))) > (nLargura-19)
			nCont += nLargura - 19
			nLin++
			@ nLin,19 PSAY Substr(cFiltro,nCont,nLargura-19)
		End
		nLin++
	EndIf
	nLin++
	@ nLin,00 PSAY REPLI("*",nLargura)
	dbSelectArea(cAlias)
EndIf

m_pag++

If Subs(__cLogSiga,4,1) == "S"
	__LogPages()
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³U_XSaldoD3CF9 ³ Autor ³Rodrigo de A Sartorio  ³ Data ³30/12/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna saldo dos movimentos RE9/DE9 relacionados ao produto³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cProduto - Codigo do produto a ter os movimentos pesquisados³±±
±±³          ³dDataIni - Data inicial para pesquisa dos movimentos        ³±±
±±³          ³dDataFim - Data final para pesquisa dos movimentos          ³±±
±±³          ³cAlmoxIni- Armazem inicial para pesquisa dos movimentos     ³±±
±±³          ³cAlmoxFim- Armazem final para pesquisa dos movimentos       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno  ³aDadosCF9- Array com quantidade e valor requisitado atraves ³±±
±±³          ³de movimentos RE9 / DE9                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR460                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XSaldoD3CF9(cProduto,dDataIni,dDataFim,cAlmoxIni,cAlmoxFim,aLocDeAte)
Local aArea     := GetArea()
Local cIndSD3   := ''
Local cQuery 	:= ''
Local aDadosCF9 := {0,0} // Quantidade e custo na 1a moeda para movimentos do SD3 com D3_CF RE9 ou DE9
Local nX        := 0

Default dDataIni := GETMV("MV_ULMES")+1
Default aLocDeAte := {}

dbSelectArea("SD3")
cIndSD3:= GetNextAlias()
cQuery := "SELECT D3_CF, SUM(D3_QUANT) D3_QUANT, SUM(D3_CUSTO1) D3_CUSTO1 FROM "+RetSqlName("SD3")+" SD3 "
cQuery += "WHERE SD3.D3_FILIAL='"+xFilial("SD3")+"' "
cQuery += "AND SD3.D3_COD = '" +cProduto+ "' "
If !Empty(aLocDeAte)
	cQuery += "AND ( "
	For nX := 1 To Len(aLocDeAte[1]) -1
		cQuery += "( SD3.D3_LOCAL BETWEEN '" +aLocDeAte[1][nX] +"' AND '"+aLocDeAte[2][nX]+"' ) OR "
		//cQuery += "( SD3.D3_LOCAL IN('01','02','04','13','15','16','17','20','21','96','97','99') ) OR "
	Next nX
	cQuery += "( SD3.D3_LOCAL BETWEEN '" + aLocDeAte[1][nX] +"' AND '"+aLocDeAte[2][nX]+"' ) ) "
	//cQuery += "( SD3.D3_LOCAL BETWEEN '" + aLocDeAte[1][nX] +"' AND '"+aLocDeAte[2][nX]+"' ) ) "
Else
	//cQuery += " AND SD3.D3_LOCAL BETWEEN '" +cAlmoxIni+ "' AND '" +cAlmoxFim+ "' "
	cQuery += " AND SD3.D3_LOCAL IN('01','02','04','13','15','16','17','20','21','96','97','99') "
	
EndIf
cQuery += "AND SD3.D3_EMISSAO BETWEEN '" + DTOS(dDataIni) + "' AND '" + DTOS(dDataFim) + "' "
cQuery += "AND SD3.D3_CF IN ('RE9','DE9') "
cQuery += "AND SD3.D3_ESTORNO ='"+Space(Len(SD3->D3_ESTORNO))+"' "
cQuery += "AND SD3.D_E_L_E_T_=' ' "
cQuery += "GROUP BY D3_CF "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cIndSD3,.T.,.T.)
aEval(SD3->(dbStruct()), {|x| If(x[2] <> "C", TcSetField(cIndSD3,x[1],x[2],x[3],x[4]),Nil)})

While !Eof()
	If D3_CF == "RE9"
		aDadosCF9[1] += D3_QUANT
		aDadosCF9[2] += D3_CUSTO1
	ElseIf D3_CF == "DE9"
		aDadosCF9[1] -= D3_QUANT
		aDadosCF9[2] -= D3_CUSTO1
	EndIf
	dbSkip()
End

//-- Restaura ambiente e apaga arquivo temporario
dbSelectArea(cIndSD3)
dbCloseArea()
dbSelectArea("SD3")

RestArea(aArea)
Return aDadosCF9


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o  	 ³U_XFmtLinR4()³ Autor ³ Nereu Humberto Junior ³ Data ³ 31.07.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Formata linha para impressao                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XFmtLinR4(oReport,aValores,cFundo,cPictN,cPictC,nLin,lImprime,bCabec,nTamLin)
//-- Variaveis da funcao
Local cConteudo	:= ''
Local cLetra   	:= ''
Local nPos     	:= 0
Local i        	:= 0
Local j        	:= 0
//-- Sets para a Funcao, mudar se necessario
Local cPictNPad := '@E 999,999,999.99'
Local cPictCPad := '@!'
Local cCharOld  := '#'
Local cCharBusca:= '±'
Local cTipoFundo:= ValType(cFundo)
Local nFor      := 1
Local aArea		:= GetArea()

//-- Troca # por cCharBusca pois existem dados com # que devem
//-- ser impressos corretamente.
If cTipoFundo == "C"
	cFundo := StrTran(cFundo,cCharOld,cCharBusca)
ElseIf cTipoFundo == "A"
	For i := 1 To Len(cFundo)
		cFundo[i] := StrTran(cFundo[i],cCharOld,cCharBusca)
	Next i
EndIf

aValores := IIf(Empty(aValores),{},aValores)
aValores := IIf(cTipoFundo == "C",aValores,{})
lImprime := IIf(lImprime == NIL,.T.,lImprime)

//-- Substitue o caracter cCharBusca por "_" nas strings
For nFor := 1 To Len(aValores)
	If ValType(aValores[nFor]) == "C" .And. At(cCharBusca,aValores[nFor]) > 0
		aValores[nFor]:=StrTran(aValores[nFor],cCharBusca,"_")
	EndIf
Next nFor

//-- Efetua quebra de pagina com impressao de cabecalho
If bCabec != NIL .And. nLin > 55
	nTamLin := Iif(nTamLin==NIL,220,nTamLin)
	nLin++
	oReport:PrintText("+"+Replic("-",nTamLin-2)+"+")
	Eval(bCabec)
EndIf

//-- Rotina de substituicao
For i := 1 to Len(aValores)
	If ValType(aValores[i]) == 'A'
		If !Empty(aValores[i,2])
			cConteudo := Transform(aValores[i,1],aValores[i,2])
		Else
			If Type(aValores[i,1]) == 'N'
				cConteudo := Str(aValores[i,1])
			Else
				cConteudo := aValores[i,1]
			EndIf
		EndIf
	Else
		cPictN := Iif(Empty(cPictN),cPictNPad,cPictN)
		cPictC := Iif(Empty(cPictC),cPictCPad,cPictC)
		aValores[i] := Iif(aValores[i] == NIL,"",aValores[i])
		If ValType(aValores[i]) == 'N'
			cConteudo := Transform(aValores[i],cPictN)
		Else
			cConteudo := Transform(aValores[i],cPictC)
		EndIf
	EndIf
	nPos := 0
	cFormato := ""
	nPos := At(cCharBusca,cFundo)
	If nPos > 0
		cLetra := cCharBusca
		j := nPos
		While cLetra == cCharBusca
			cLetra := Substr(cFundo,j,1)
			If cLetra == cCharBusca
				cFormato += cLetra
			EndIf
			j++
		End
		If Len(cFormato) > Len(cConteudo)
			If ValType(aValores[i]) <> 'N'
				cConteudo += Space(Len(cFormato)-Len(cConteudo))
			Else
				cConteudo := Space(Len(cFormato)-Len(cConteudo)) +cConteudo
			EndIf
		EndIf
		cFundo := Stuff(cFundo,nPos,Len(cConteudo),cConteudo)
	EndIf
Next i

//-- Imprime linha formatada
If lImprime
	If cTipoFundo == "C"
		nLin++
		oReport:PrintText(cFundo)
	Else
		For i := 1 to Len(cFundo)
			nLin++
			oReport:PrintText(cFundo[i])
		Next i
	EndIf
EndIf

//-- Devolve array de dados com mesmo tamanho mas vazio
If Len(aValores) > 0
	aValores := Array(Len(aValores))
EndIf

RestArea(aArea)
Return cFundo

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³U_XMTR460VAlm ³ Autor ³Nereu Humberto Junior  ³ Data ³01/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida Almoxarifado do KARDEX com relacao a custo unificado ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR460                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XMTR460VAlm()
Local lRet		:= .T.
Local cConteudo	:= &(ReadVar())
Local nOpc		:= 2

//-- Verifica se utiliza custo unificado por Empresa/Filial
Local lCusUnif := A330CusFil()

If lCusUnif .And. cConteudo != "**"
	nOpc := Aviso(STR0035,STR0036,{STR0037,STR0038})	//"Aten‡„o"###"Ao alterar o almoxarifado o custo medio unificado sera desconsiderado."###"Confirma"###"Abandona"
	If nOpc == 2
		lRet := .F.
	EndIf
EndIf

Return lRet


/*ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³U_XMTR460VNom ³ TOTVS                        ³ Data ³03/03/15  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´*/
USER Function XMTR460VNom()
Local lRet		:= .T.
Local cConteudo	:= &(ReadVar())
Local cCaracter := "!@#$%¨&*()+{}^~´`][;.>,<=/¢¬§ªº'?*"
Local nCont		:= 0

If valtype(cConteudo) == 'C'
	For nCont := 1 to length(cConteudo)
		If substr(cConteudo,nCont,1) $ cCaracter
			lRet := .F.
		EndiF
	next nCont
EndIf
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R460STrib  ³ Autor ³Microsiga S/A          ³ Data ³12/06/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao utilizada para verificar qual a situacao triburia    ³±±
±±³          ³do produto a ser impresso.                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cProduto  - Codigo do Produto                               ³±±
±±³          ³cAliasSB1 - Alias da tabela SB1 (Somente TopConnect)        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno  ³Caracter                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR460                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R460STrib(cProduto,cAliasSB1)
Local aAreaAnt := GetArea()
Local aAreaSB1 := SB1->(GetArea())
Local aAreaSD1 := SD1->(GetArea())
Local aAreaSD2 := SD2->(GetArea())
Local cSitTrib := ''
Local lContinua:= .T.

Default cAliasSB1 := 'SB1'

dbSelectArea('SB1')
dbSetOrder(1)
If IIf(cAliasSB1=='SB1',MsSeek(xFilial('SB1')+cProduto),.T.) .And. !Empty(RetFldProd((cAliasSB1)->B1_COD, 'B1_TE',cAliasSB1))
	cSitTrib := AllTrim(RetFldProd((cAliasSB1)->B1_COD,"B1_ORIGEM",cAliasSB1)) +"-"
	//-- Analisa Situacao Tributaria atraves da TES de Entrada Padrao
	If !Empty(RetFldProd((cAliasSB1)->B1_COD,"B1_TE",cAliasSB1))
		dbSelectArea('SF4')
		dbSetOrder(1)
		If MsSeek(xFilial('SF4')+RetFldProd((cAliasSB1)->B1_COD,"B1_TE",cAliasSB1)) .And. !Empty(SF4->F4_SITTRIB)
			cSitTrib  := cSitTrib +AllTrim(SF4->F4_SITTRIB)
			lContinua := .F.
		EndIf
		//-- Analisa Situacao Tributaria atraves da TES de Saida Padrao
	ElseIf !Empty(RetFldProd((cAliasSB1)->B1_COD,"B1_TS",cAliasSB1))
		dbSelectArea('SF4')
		dbSetOrder(1)
		If MsSeek(xFilial('SF4')+RetFldProd((cAliasSB1)->B1_COD,"B1_TS",cAliasSB1)) .And. !Empty(SF4->F4_SITTRIB)
			cSitTrib  := cSitTrib +AllTrim(SF4->F4_SITTRIB)
			lContinua := .F.
		EndIf
	EndIf
	
	//-- Quando nao for cadastrada a TES padrao analisar os documentos
	//-- de Entrada/Saida.
	If lContinua
		//-- Analisa Situacao Tributaria atraves do Documento de Entrada
		dbSelectArea('SD1')
		dbSetOrder(2)
		dbSeek(xFilial('SD1')+cProduto+Replicate("z",Len(SD1->D1_DOC)),.T.)
		dbSkip(-1)
		While !Bof() .And. cProduto == SD1->D1_COD .And. SD1->D1_TIPO == "C"
			dbSkip(-1)
		End
		dbSelectArea('SF4')
		dbSetOrder(1)
		If MsSeek(xFilial('SF4')+SD1->D1_TES) .And. !Empty(SF4->F4_SITTRIB)
			cSitTrib  := cSitTrib +AllTrim(SF4->F4_SITTRIB)
			lContinua := .F.
		EndIf
	EndIf
	
	//-- Quando nao e localizada a situacao tributaria na TES informa
	//-- o codigo 90 - Outras.
	If lContinua .And. Len(Alltrim(cSitTrib)) == 2
		cSitTrib := cSitTrib +'90'
	EndIf
EndIf

RestArea(aAreaSD1)
RestArea(aAreaSD2)
RestArea(aAreaSB1)
RestArea(aAreaAnt)
Return IIf(Empty(cSitTrib),'0-90',cSitTrib)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R460Grava  ³ Autor ³Microsiga S/A          ³ Data ³19/06/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Funcao utilizada para realizar a gravacao do registro na    ³±±
±±³          ³tabela temporaria referente ao saldo em processo.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cProduto  - Codigo do Produto                               ³±±
±±³          ³cLocal    - Codigo do Armazem                               ³±±
±±³          ³nQtde     - Quantidade                                      ³±±
±±³          ³nCusto    - Custo na Moeda 1                                ³±±
±±³          ³nRecnoSD3 - Numero do Recno da Tabela SD3                   ³±±
±±³          ³cTipo     - Tipo DE/RE                                      ³±±
±±³          ³cArqTemp  - Alias do arquivo de trabalho                    ³±±
±±³          ³cAliasSD3 - Alias da Query SD3                              ³±±
±±³          ³lFiscal   - Indica processamento para o Sintegra            ³±±
±±³          ³aNCM      - Aglutina o resultado por NCM                    ³±±
±±³          ³lTipoBN   - Tratamento para produtos BN (Beneficiamento)    ³±±
±±³          ³cFilCons  - Filial que solicitou impressao do relatorio	  ³±±
±±³          ³cAliasSB1 - Alias da tabela SB1 (Especifico para Querys)    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno  ³Nill                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR460                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R460Grava(cProduto,cLocal,nQtde,nCusto,nRecnoSD3,cTipo,cArqTemp,cAliasSD3,lFiscal,aNCM,lTipoBN,cFilCons,cAliasSB1,aProdFis,lEmFabric)
Local aAreaAnt 	:= GetArea()
Local aAreaSB1 	:= SB1->(GetArea())
Local nPosNCM  	:= 0
Local lConsolida:= .F.

Default nRecnoSD3 := 0
Default cTipo     := ''
Default aNCM	  := {}
Default lFiscal   := .F.
Default aProdFis  := {}
Default lTipoBN   := .F.
Default cAliasSB1 := "SB1"
Default lEmFabric := .F.

lConsolida:= Iif(!lFiscal,mv_par21 == 1 .And. mv_par24 == 1,aProdFis[12] == 1 .And. aProdFis[13] == 1)
//-- Posiciona tabela SB1
If cAliasSB1=="SB1" .And. SB1->B1_COD != cProduto
	SB1->(dbSetOrder(1))
	SB1->(MsSeek(xFilial("SB1")+cProduto))
EndIf

//-- Gravacao do registro no arquivo temporario
If (cAliasSB1)->B1_COD == cProduto
	(cArqTemp)->(dbSetOrder(2))
	If (cArqTemp)->(dbSeek((cAliasSB1)->B1_COD+IIf(lEmFabric,"7","2")))
		RecLock(cArqTemp,.F.)
	Else
		RecLock(cArqTemp,.T.)
		(cArqTemp)->FILIAL		:= xFilial("SB2",cFilCons)
		((cArqTemp)->SITUACAO	:= IIf(lEmFabric,"7","2"))
		(cArqTemp)->TIPO		:= IIf(lTipoBN,(cAliasSB1)->B1_TIPOBN,(cAliasSB1)->B1_TIPO)
		(cArqTemp)->POSIPI		:= (cAliasSB1)->B1_POSIPI
		(cArqTemp)->PRODUTO		:= (cAliasSB1)->B1_COD
		(cArqTemp)->DESCRICAO	:= (cAliasSB1)->B1_DESC
		(cArqTemp)->UM			:= (cAliasSB1)->B1_UM
		If nQuebraAliq == 2
			(cArqTemp)->ALIQ := RetFldProd((cAliasSB1)->B1_COD, "B1_PICM",cAliasSB1)
		ElseIf nQuebraAliq == 3
			(cArqTemp)->ALIQ := IIf(SB0->(MsSeek(xFilial("SB0")+(cAliasSB1)->B1_COD)),SB0->B0_ALIQRED,0)
		EndIf
		if !lFiscal
			If mv_par21 == 1
				(cArqTemp)->SITTRIB := R460STrib((cAliasSB1)->B1_COD,cAliasSB1)
			EndIf
		Endif
	EndIf
	Do Case
		Case cTipo == "RE" .Or. Empty(cTipo)
			(cArqTemp)->QUANTIDADE	+= nQtde
			(cArqTemp)->TOTAL		+= nCusto
		Case cTipo == "DE"
			(cArqTemp)->QUANTIDADE 	-= nQtde
			(cArqTemp)->TOTAL		-= nCusto
	EndCase
	If (cArqTemp)->QUANTIDADE > 0
		(cArqTemp)->VALOR_UNIT := (cArqTemp)->(NoRound(TOTAL/QUANTIDADE,nDecVal))
	EndIf
	
	//-- Este Ponto de Entrada foi criado para recalcular o Valor Unitario/Total
	If lCalcUni
		//-- Posiciona na tabela SD3
		If nRecnoSD3 <> 0
			SD3->(dbGoto(nRecnoSD3))
			//-- Chamada do Ponto de Entrada
			ExecBlock("A460UNIT",.F.,.F.,{cProduto,cLocal,mv_par13,cArqTemp,{'QtCus',nQtde,nCusto}})
		Else
			//-- Chamada do Ponto de Entrada
			ExecBlock("A460UNIT",.F.,.F.,{cProduto,cLocal,mv_par13,cArqTemp,{'QtCus',nQtde,nCusto}})
		EndIf
	EndIf
	
	//-- Aglutina por NCM quando a funcao e chamada pelo fiscal
	//-- para a geracao do Sintegra e nao para a impressao do livro fiscal
	If lFiscal
		nPosNCM := aScan(aNCM,{|x| x[1] == (cArqTemp)->POSIPI})
		If nPosNCM > 0
			aNCM[nPosNCM][02] += (cArqTemp)->QUANTIDADE
			aNCM[nPosNCM][03] += (cArqTemp)->TOTAL
		Else
			(cArqTemp)->(aAdd(aNCM,{POSIPI,QUANTIDADE,TOTAL}))
		Endif
	Endif
	(cArqTemp)->(MsUnLock())
EndIf

RestArea(aAreaSB1)
RestArea(aAreaAnt)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³U_XR460AnProcesso ³Autor³Microsiga S/A       ³ Data ³ 01.07.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³   Esta funcao foi criada somente para manter a compatibili-³±±
±±³          ³dade com cliente que utiliza a funcao antiga de saldo em    ³±±
±±³          ³processo.                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd     - variavel que indica se processo foi interrompido³±±
±±³          ³ cArqTemp - nome arquivo de trabalho criado para impressao  ³±±
±±³          ³ lGraph   - Nao atualiza regua de progressao                ³±±
±±³          ³ aProdFis - Informacoes saldo em processo Sintegra          ³±±
±±³          ³ aNCM     - Aglutinacao por NCM processos (Sintegra)        ³±±
±±³          ³ lTipoBN  - Tratamento para produtos BN (Beneficiamento)    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno  ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XR460AnProcesso(lEnd,cArqTemp,lGraph,aProdFis,aNCM,lTipoBN,aLocDeAte)
Local aA460AMZP 	:= {}
Local aCampos   	:= {}
Local aSalAtu		:= {}
Local cPeLocProc	:= ""
Local cBkLocProc	:= ""
Local cAliasTop 	:= "SD3"
Local cAliasSD3 	:= "SD3"
Local cArqTemp2		:= ""
Local cArqTemp3		:= ""
Local cFiltro		:= ""
Local cLocProc  	:= 'ZZ'//SuperGetMV("MV_LOCPROC",.F.,'99')
Local lM460PRC	:= .T.//SuperGetMv("MV_M460PRC",.F.,.F.)
Local nRecnoD3		:= 0
Local lFiscal		:= .F.
Local lDataProd 	:= .F.
Local lCusFIFO  	:= SuperGetMV("MV_CUSFIFO",.F.,.F.)
Local lA460AMZP 	:= ExistBlock("A460AMZP")
Local cQuery := ""


Default aProdFis 	:= {}
Default aNCM		:= {}
Default lGraph      := .F.
Default lTipoBN     := .F.
Default aLocDeAte   := {}

lFiscal	:= Len(aProdFis) >= 11

//-- A460AMZP - Ponto de Entrada para considerar um armazen
//--            adicional como armazem de processo.
If lA460AMZP
	aA460AMZP := ExecBlock("A460AMZP",.F.,.F.,'')
	If ValType(aA460AMZP)=="A" .And. Len(aA460AMZP) == 1
		cBkLocProc := IIf(Valtype(aA460AMZP[1])=="C",aA460AMZP[1],'')
	EndIf
EndIf

If mv_par01 == 1 .And. !lEnd
	//-- Cria arquivo de Trabalho para armazenar as OPs
	aAdd(aCampos,{"OP","C",TamSX3("D3_OP")[1],0})
	aAdd(aCampos,{"SEQCALC","C",TamSX3("D3_SEQCALC")[1],0})
	aAdd(aCampos,{"DATA1","D",8,0})
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ARQUIVO TEMPORARIO DE MEMORIA (CTREETMP)                            ³
	//³A funcao MSOpenTemp ira substituir as duas linhas de codigo abaixo: ³
	//|--> cNomeTrb := CriaTrab(aStruTRB,.T.)                              |
	//|--> dbUseArea(.T.,__LocalDrive,cNomeTrb,cAliasTRB,.F.,.F.)          |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MSOpenTemp(cArqTemp2,aCampos,@cArqTemp2)
	
	IndRegua(cArqTemp2,cArqTemp2,"OP+SEQCALC+DTOS(DATA1)",,,STR0020)		//"Criando Indice..."
	
	//-- Busca saldo em processo
	SD3->(dbSetOrder(1)) // D3_FILIAL+D3_OP+D3_COD+D3_LOCAL
	cArqTemp3 := CriaTrab(NIL,.F.)
	
	cAliasTop := cArqTemp3
	cQuery := "SELECT D3_FILIAL, D3_OP, D3_COD, D3_LOCAL, D3_CF, D3_EMISSAO, D3_SEQCALC "
	cQuery += "FROM " +RetSQLName("SD3") +" SD3 "
	cQuery += "WHERE SD3.D3_FILIAL='" +xFilial("SD3") +"' "
	cQuery += "AND SD3.D3_OP <> '" +Criavar("D3_OP",.F.) +"' "
	cQuery += "AND (SD3.D3_CF ='PR0' OR SD3.D3_CF = 'PR1') "
	cQuery += "AND SD3.D3_EMISSAO <= '" +DTOS(mv_par13) +"' "
	cQuery += "AND SD3.D3_ESTORNO = ' ' "
	cQuery += "AND SD3.D_E_L_E_T_ = ' ' "
	cQuery += "UNION "
	cQuery += "SELECT D3_FILIAL, D3_OP, D3_COD, D3_LOCAL, D3_CF, D3_EMISSAO, D3_SEQCALC "
	cQuery += "FROM " +RetSQLName("SD3") +" SD3 "
	cQuery += "WHERE SD3.D3_FILIAL='" +xFilial("SD3") +"' "
	cQuery += "AND SD3.D3_OP <> '" +Criavar("D3_OP",.F.) +"' "
	cQuery += "AND SD3.D3_COD >= '" +Iif(!lFiscal,mv_par05,aProdFis[01]) +"' "
	cQuery += "AND SD3.D3_COD <= '" +Iif(!lFiscal,mv_par06,aProdFis[02]) +"' "
	cQuery += "AND SD3.D3_CF <>'PR0' AND SD3.D3_CF <>'PR1' "
	cQuery += "AND SD3.D3_EMISSAO <= '" +DTOS(mv_par13) +"' "
	cQuery += "AND SD3.D3_ESTORNO = ' ' "
	cQuery += "AND SD3.D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY " +SQLOrder(SD3->(IndexKey()))
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArqTemp3,.T.,.T.)
	aEval(SD3->(dbStruct()), {|x| If(x[2] <> "C" ,TcSetField(cArqTemp3,x[1],x[2],x[3],x[4]),Nil)})
	
	//-- Armazena OPs e data de emissao
	While !(cAliasTop)->(EOF()) .And. !lEnd
		lDataProd := SubStr((cAliasTop)->D3_CF,1,2) != "PR"
		If !Empty(Iif(!lFiscal,mv_par06,aProdFis[01])) .And. (cAliasTop)->D3_COD > Iif(!lFiscal,mv_par06,aProdFis[01]) .And. lDataProd
			Exit
		EndIf
		If Interrupcao(@lEnd)
			Exit
		EndIf
		If !R460AvalProd((cAliasTop)->D3_COD,Iif(!lFiscal,mv_par19==1,aProdFis[11]==1),aProdFis) .And. lDataProd
			(cAliasTop)->(dbSkip())
			Loop
		EndIf
		
		If (cArqTemp2)->(dbSeek((cAliasTop)->D3_OP))
			RecLock(cArqTemp2,.F.)
		Else
			RecLock(cArqTemp2,.T.)
			(cArqTemp2)->OP := (cAliasTop)->D3_OP
		EndIf
		If SubStr((cAliasTop)->D3_CF,1,2) == "PR"
			(cArqTemp2)->DATA1 := Max((cAliasTop)->D3_EMISSAO,(cArqTemp2)->DATA1)
			If !mv_par17 == 1 .And. ((cAliasTop)->D3_SEQCALC > (cArqTemp2)->SEQCALC)
				(cArqTemp2)->SEQCALC := (cAliasTop)->D3_SEQCALC
			EndIf
		EndIf
		(cArqTemp2)->(MsUnlock())
		dbSelectArea(cAliasTop)
		(cAliasTop)->(dbSkip())
	End
	
	//-- Restaura ambiente e apaga arquivo temporario
	(cAliasTop)->(dbCloseArea())
	
	
	(cArqTemp2)->(dbGotop())
	While !(cArqTemp2)->(Eof()) .And. !lEnd
		If Interrupcao(@lEnd)
			Exit
		EndIf
		
		cAliasSD3 := GetNextAlias()
		cQuery := "SELECT SD3.D3_FILIAL, SD3.D3_OP, SD3.D3_COD, SD3.D3_LOCAL, SD3.D3_CF, SD3.D3_EMISSAO, "
		cQuery += "SD3.D3_RATEIO, SD3.D3_SEQCALC, SD3.D3_CUSTO1, SD3.D3_SEQCALC, SD3.D3_QUANT, SD3.D3_ESTORNO, "
		cQuery += "SD3.D3_PERDA, SD3.R_E_C_N_O_ RECNOSD3 "
		cQuery += "FROM " +RetSqlName("SD3") +" SD3 "
		cQuery += "WHERE SD3.D3_FILIAL = '" +xFilial("SD3") +"' "
		cQuery += "AND SD3.D3_OP = '" +(cArqTemp2)->OP +"' "
		cQuery += "AND SD3.D3_ESTORNO = ' ' "
		cQuery += "AND SD3.D3_EMISSAO <= '" +DTOS(mv_par13) +"' "
		cQuery += "AND SD3.D_E_L_E_T_ = ' ' "
		cQuery += "ORDER BY " + SQLOrder(SD3->(IndexKey()))
		cQuery := ChangeQuery(cQuery)
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD3,.T.,.T.)
		
		TcSetField(cAliasSD3,"D3_EMISSAO"	,"D",8,0)
		TcSetField(cAliasSD3,"D3_QUANT"		,"N",TamSX3("D3_QUANT" )[1]	,TamSX3("D3_QUANT" )[2])
		TcSetField(cAliasSD3,"D3_CUSTO1"	,"N",TamSX3("D3_CUSTO1")[1]	,TamSX3("D3_CUSTO1")[2])
		While !(cAliasSD3)->(Eof()) .And. !lEnd
			nRecnoD3 := (cAliasSD3)->RECNOSD3
			
			
			If Interrupcao(@lEnd)
				Exit
			EndIf
			
			//-- Validacao para nao permitir movimento com a data maior que a data de
			//-- encerramento do relatorio.
			If (cAliasSD3)->D3_EMISSAO > mv_par13 .Or. (cAliasSD3)->D3_ESTORNO == "S"
				(cAliasSD3)->(dbSkip())
				Loop
			EndIf
			
			If !R460Local((cAliasSD3)->D3_LOCAL,aLocDeAte) .Or. !R460AvalProd((cAliasSD3)->D3_COD,Iif(!lFiscal,mv_par19==1,aProdFis[11]==1),aProdFis) .Or. ;
				(cAliasSD3)->D3_ESTORNO == "S" .Or. If(mv_par17 == 1,(cAliasSD3)->D3_EMISSAO <= (cArqTemp2)->DATA1,(cAliasSD3)->D3_SEQCALC <= (cArqTemp2)->SEQCALC) .Or. ;
				(cAliasSD3)->D3_EMISSAO > mv_par13
				(cAliasSD3)->(dbSkip())
				Loop
			EndIf
			
			//-- Grava o Saldo Em Processo
			(cAliasSD3)->(R460Grava(D3_COD,D3_LOCAL,D3_QUANT,D3_CUSTO1,nRecnoD3,SubStr(D3_CF,1,2),cArqTemp,cAliasSD3,lFiscal,aNCM,lTipoBN))
			
			(cAliasSD3)->(dbSkip())
		End
		//-- Finaliza a Query para esta OP
		(cAliasSD3)->(dbCloseArea())
		(cArqTemp2)->(dbSkip())
	End
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ARQUIVO TEMPORARIO DE MEMORIA (CTREETMP)                            ³
	//³A funcao MSCloseTemp ira substituir a linha de codigo abaixo:       ³
	//|--> dbCloseArea()                                                   |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MSCloseTemp(cArqTemp2,cArqTemp2)
	
	If Select(cArqTemp2) > 0
		dbSelectArea(cArqTemp2)
		dbCloseArea()
	EndIf
	Ferase(cArqTemp2+OrdBagExt())
	
	//-- Busca saldo em processo dos materiais de uso indireto
	SB1->(MsSeek(xFilial("SB1")))
	While !SB1->(EOF()) .And. !lEnd .And. xFilial("SB1") == SB1->B1_FILIAL
		If Interrupcao(@lEnd)
			Exit
		EndIf
		If !R460AvalProd(SB1->B1_COD,Iif(!lFiscal,mv_par19 == 1,aProdFis[11] == 1),aProdFis)
			SB1->(dbSkip())
			Loop
		EndIf
		If !lM460PRC .And. !(SB1->B1_APROPRI == "I")
			SB1->(dbSkip())
			Loop
		EndIf
		
		If mv_par16 == 11 .Or. (!mv_par16 == 11 .And. !lCusfifo)
			aSalAtu := CalcEst(SB1->B1_COD,cLocProc,mv_par13+1,Nil)
		Else
			aSalAtu := CalcEstFF(SB1->B1_COD,cLocProc,mv_par13+1,Nil)
		EndIf
		
		//-- Grava o Saldo Em Processo
		R460Grava(SB1->B1_COD,cLocProc,aSalAtu[1],aSalAtu[2],Nil,Nil,cArqTemp,Nil,lFiscal,aNCM,lTipoBN)
		
		//-- A460AMZP - Ponto de entrada utilizado para definir um armazem
		//              padrao como armazem de processo.
		cPeLocProc := cBkLocProc
		If !Empty(cPeLocProc)
			While !Empty(cPeLocProc)
				cAlmProc   := SubStr(cPeLocProc,1,At("/",cPeLocProc)-1)
				cPeLocProc := SubStr(cPeLocProc,At("/",cPeLocProc)+1)
				If !Empty(cAlmProc)
					If mv_par16 == 11 .Or. (!mv_par16 == 11 .And. !lCusfifo)
						aSalAtu := CalcEst(SB1->B1_COD,cAlmProc,mv_par13+1,Nil)
					Else
						aSalAtu := CalcEstFF(SB1->B1_COD,cAlmProc,mv_par13+1,Nil)
					EndIf
					
					//-- Grava o Saldo Em Processo
					R460Grava(SB1->B1_COD,cAlmProc,aSalAtu[1],aSalAtu[2],Nil,Nil,cArqTemp,Nil,lFiscal,aNCM,lTipoBN)
				Else
					Exit
				EndIf
			End
		EndIf
		
		SB1->(dbSkip())
	End
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³R460GrvTRB     ³Autor³TOTVS S/A           ³ Data ³ 12/03/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Esta funcao e utilizada para gravacao do arquivo de trabalho³±±
±±³          ³para exportacao de dados do SPED FISCAL.                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno  ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R460GrvTRB(aTerceiros,cArqTemp,cFilImp,cFilP7,nQuebrAliq)
Local aAreaAnt		:= GetArea()
Local aAreaSB1		:= SB1->(GetArea())
Local aArqTemp		:= {}
local aRetPe		:= {}
Local cNomeArq		:= AllTrim(mv_par23)+ STRTRAN(AllTrim(FWGrpCompany())+"_"+AllTrim(cFilImp), " ", "_")
Local cNomeIdx		:= CriaTrab(NIL,.F.)
Local cIndice		:= ""
Local nCnt			:= 0
Local lConsolida	:= mv_par20 == 1 .And. mv_par24 == 1

Default aTerceiros:= {}
Default cFilP7		:= ""
Default cFilImp	:= ""

//-- Verifica se não está na mesma filial, não cria TRB novamente
//-- Realiza a Abertura/Criacao da tabela 'TRB'
If (Empty(cFilP7) .Or. cFilImp == cFilP7) .And. Select("TRB") <= 0
	aArqTemp := A460ArqTmp(2,@cIndice,nQuebrAliq)
	dbCreate( cNomeArq, aArqTemp, "SQLITE_TMP" )
	dbUseArea(.T.,"SQLITE_TMP",cNomeArq,"TRB",.T.,.F.)
	dbCreateIndex(cNomeIdx, cIndice)
	dbCreateIndex("idx2", "PRODUTO+SITUACAO+ARMAZEM")
	
	dbSetOrder(1)
EndIf

//-- A460ALTRB - Ponto de entrada Alterar dados gravados na TRB
If ExistBlock("A460ALTRB") .And. Valtype(aRetPe := ExecBlock("A460ALTRB",.F.,.F.,{aTerceiros})) =="A"
	aTerceiros := aRetPe
EndIf

// Atualiza Saldo De/Em Terceiros
For nCnt := 1 to Len(aTerceiros)
	SB1->(dbSetOrder(1))
	SB1->(MsSeek(xFilial("SB1")+PadR(AllTrim(aTerceiros[nCnt,2]),TamSX3("B1_COD")[1])))
	
	//Se atender esta condição então não deverá gravar no arquvo DBF
	//pois trata de valores negativos e o relatório foi emitido com opção de NÂO exibir valores negativos
	//Desta maneira não irá gerar valor negativo no bloco H do SPED FISCAL.
	If 	(!mv_par08 == 1 .And. aTerceiros[nCnt,5] < 0) .Or.;
		(!mv_par09 == 1 .And. aTerceiros[nCnt,5] == 0) .Or.;
		(!mv_par15 == 1 .And. aTerceiros[nCnt,6] == 0)
		Loop
	EndIf
	
	If lConsolida .And. TRB->(dbSeek(aTerceiros[nCnt,1]+aTerceiros[nCnt,8]+aTerceiros[nCnt,3]+aTerceiros[nCnt,4]+aTerceiros[nCnt,2]))
		RecLock("TRB",.F.)
	Else
		RecLock("TRB",.T.)
	EndIf
	TRB->FILIAL		:= xFilial("SB2")
	TRB->SITUACAO	:= aTerceiros[nCnt,1]
	TRB->PRODUT		:= aTerceiros[nCnt,2]
	TRB->CLIFOR		:= aTerceiros[nCnt,3]
	TRB->LOJA		:= aTerceiros[nCnt,4]
	TRB->UM			:= SB1->B1_UM
	TRB->QUANTIDADE	:= aTerceiros[nCnt,5]
	TRB->VALOR_UNIT	:= ABS(aTerceiros[nCnt,6] / IIf(aTerceiros[nCnt,5]==0,1,aTerceiros[nCnt,5]))
	TRB->TOTAL		:= aTerceiros[nCnt,6]
	TRB->TPCF		:= aTerceiros[nCnt,8]
	TRB->ARMAZEM	:= SB1->B1_LOCPAD
	TRB->(MsUnLock())
Next nCnt

// Atualiza Saldo em Estoque e Processo
(cArqTemp)->(dbSetOrder(1))
(cArqTemp)->(dbGoTop())
While !(cArqTemp)->(EOF())
	//-- Itens sem saldo nao saem no arquivo e poder de terceiros foi gerado acima
	If (cArqTemp)->SITUACAO $ "3|4|5"
		(cArqTemp)->(dbSkip())
		Loop
	EndIf
	//-- Filtra itens da listagem conforme parametrizacao do relatorio (negativos, zerados e/ou sem custo)
	If 	(!mv_par08 == 1 .And. (cArqTemp)->QUANTIDADE < 0) .Or.;
		(!mv_par09 == 1 .And. (cArqTemp)->QUANTIDADE == 0) .Or.;
		(!mv_par15 == 1 .And. (cArqTemp)->TOTAL == 0)
		(cArqTemp)->(dbSkip())
		Loop
	EndIf
	//-- Garante que No bloco H do SPED havera somente itens com saldo (quantidade ou custo)
	If (cArqTemp)->QUANTIDADE <> 0 .Or. (cArqTemp)->VALOR_UNIT <> 0
		RecLock("TRB",.T.)
		TRB->FILIAL		:= (cArqTemp)->FILIAL
		TRB->SITUACAO		:= (cArqTemp)->SITUACAO
		TRB->PRODUTO		:= (cArqTemp)->PRODUTO
		TRB->UM			:= (cArqTemp)->UM
		TRB->QUANTIDADE	:= (cArqTemp)->QUANTIDADE
		TRB->VALOR_UNIT	:= NoRound((cArqTemp)->TOTAL/(cArqTemp)->QUANTIDADE,nDecVal)
		TRB->TOTAL			:= (cArqTemp)->TOTAL
		TRB->ARMAZEM		:= (cArqTemp)->ARMAZEM
		TRB->(MsUnLock())
	EndIf
	(cArqTemp)->(dbSkip())
End

cFilP7 := cFilImp

RestArea(aAreaSB1)
RestArea(aAreaAnt)
Return "TRB"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A460ArqTmpºAutor  ³ Andre Anjos		 º Data ³  19/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Devolve estrutura dos arquivos temporarios usados no rel.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ nTpArq: tipo do arquivo: 1-IMPRESSAO; 2- SPED			  º±±
±±º			 ³ cIndice: indice principal do arquivo (referencia)		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Retorno	 ³ aRet: estrutura de campos do arquivo de trabalho 		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATR460                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A460ArqTmp(nTpArq,cIndice,nQuebrAliq)
Local aRet := {}

//-- Cria Arquivo Temporario:
//-- SITUACAO: 1=ESTOQUE,2=PROCESSO,3=SEM SALDO,4=DE TERCEIROS,5=EM TERCEIROS,
//--           6=DE TERCEIROS USADO EM ORDENS DE PRODUCAO
aAdd(aRet,{"FILIAL"     ,"C",FWSizeFilial(),0})
aAdd(aRet,{"SITUACAO"	,"C",01,0})
aAdd(aRet,{"PRODUTO"	,"C",TamSX3("B1_COD")[1],0})
aAdd(aRet,{"UM"			,"C",02,0})
aAdd(aRet,{"QUANTIDADE"	,"N",14,Min(TamSX3("B2_QFIM")[2],4)})
aAdd(aRet,{"VALOR_UNIT"	,"N",21,nDecVal})
aAdd(aRet,{"TOTAL"		,"N",21,nDecVal})
aAdd(aRet,{"ARMAZEM"	,"C",TamSx3("B1_LOCPAD")[1],0})
If nTpArq == 1
	aAdd(aRet,{"TIPO"		,"C",02,0})
	aAdd(aRet,{"POSIPI"		,"C",10,0})
	aAdd(aRet,{"DESCRICAO"	,"C",35,0})
	aAdd(aRet,{"ALIQ"	    ,"N",5,2})
	aAdd(aRet,{"SITTRIB"	,"C",4,0})
	
	//-- Chave do Arquivo de Trabalho
	If mv_par21 == 1
		cIndice := "SITUACAO+TIPO+SITTRIB+PRODUTO"
	Else
		If nQuebrAliq == 1
			cIndice := "SITUACAO+TIPO+POSIPI+PRODUTO"
		ElseIf nQuebrAliq <> 1
			cIndice := "SITUACAO+TIPO+STR(ALIQ,5,2)+PRODUTO"
		EndIf
	EndIf
ElseIf nTpArq == 2
	aAdd(aRet,{"CLIFOR"	    ,"C",TamSX3("B6_CLIFOR")[1]	,0})
	aAdd(aRet,{"LOJA"		,"C",TamSX3("B6_LOJA")[1]	,0})
	aAdd(aRet,{"TPCF"		,"C",1						,0})
	
	cIndice := "SITUACAO+TPCF+CLIFOR+LOJA+PRODUTO"
EndIf

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³U_XM460MdPrc º Autor ³ Robson Sales       º Data ³  21/03/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Devolve a Quantidade Media por Producao com base no empenhoº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ cProduto = Codigo do produto                               º±±
±±º          ³ cOP      = Numero da OP                                    º±±
±±º          ³ cLocal   = Armazem                                         º±±
±±º          ³ nQtdOp   = Quantidade original da OP                       º±±
±±º          ³ cTrt     = Sequencia do empenho                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Retorno  ³ nRet = Quantidade media por producao                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATR460                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XM460MdPrc(cProduto,cOP,cLocal,nQtdOp,cTrt)
Local nRet     := 0
Local nQtdEmp  := 0
Local aAreaAnt := GetArea()
Local aAreaSD4 := SD4->(GetArea())
Local cAliasTmp	:= GetNextAlias()
Local cQuery     	:= ''

cQuery := "SELECT SUM(SD4.D4_QTDEORI) AS QTDEORI FROM "+ RetSqlName("SD4")+" SD4 "
cQuery += "WHERE D4_FILIAL	= '" + xFilial('SD4') + "' AND "
cQuery += "SD4.D4_OP		= '" + cOP + "' AND SD4.D4_COD = '"+ cProduto +"' AND "
cQuery += "SD4.D4_LOCAL	= '" + cLocal +"' AND SD4.D4_TRT ='"+ cTrt + "'   AND "
cQuery += "SD4.D_E_L_E_T_ = ' ' "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.T.,.T.)

nQtdEmp := (cAliasTmp)->QTDEORI

(cAliasTmp)->(DbCloseArea())

nRet := nQtdEmp / nQtdOp

RestArea(aAreaSD4)
RestArea(aAreaAnt)
Return nRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³U_XR460Sum   ³ Autor ³ TOTVS S.A.            ³ Data ³22/05/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Soma as quantidades ou valores do vetor aEmAnalise          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

USER Function XR460Sum(nTipo, aVetor)
Local nRet := 0
Local nX   := 0

For nX := 1 To Len(aVetor)
	nRet += aVetor[nX, IIf(nTipo == 1, 3,4)]
Next nX

Return nRet


/*/{Protheus.doc} GetUlMes()
//TODO Descrição obtem o ultima data de fechamento gravado na tabela SB9 anterior a data informada.
@author reynaldo
@since 05/10/2017
@version undefined
@param cAtmes, caracter, Data de fechamento informado
@type function
/*/
Static Function GetUlMes(cAtmes)

Local cRet
Local cQuery		:= ""
Local cAliasTRB		:= GetNextAlias()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Query que retorna a 1a data maior de fechamento anterior a data informada ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "SELECT MAX(SB9.B9_DATA) B9_DATA "
cQuery += "FROM "+ RetSqlName("SB9") +" SB9 "
cQuery += "WHERE SB9.B9_FILIAL = '"+ xFilial("SB9") + "' AND SB9.B9_DATA <= '"+ cAtmes+"' AND SB9.D_E_L_E_T_ = ' '"
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTRB,.T.,.T.)

cRet := (cAliasTRB)->B9_DATA

(cAliasTRB)->(dbCloseArea())

Return cRet

/*/{Protheus.doc} R460Select
//Montagem da query principal para selecionar os produtos de acordo com o que foi informado no pergunte.
identificação se existe movimentos nas tabelas SB6, SD1, SD2 e SD3
@author reynaldo
@since 12/12/2017
@version 1.0
@return caracter, Retorno com a query montada
@param cAtmes, characters, Data final para considerar
@param cSB9UlMes, characters, Data do ultimo fechamento menor que a data informanda (mv_par13)
@param cUlmes, characters, Data inicial para considerar
@param aAlmoxIni, array, descricao
@param aAlmoxFim, array, descricao
@type function
/*/
Static Function R460Select(cAtmes,cSB9UlMes,cUlmes,aAlmoxIni,aAlmoxFim)
Local cQuery	:= ""
Local cSB2Join	:= ""
Local cSB2Where	:= ""
Local l460RLoc	:= ExistBlock("A460RLOC")
Local nX		:= 0

DEFAULT aAlmoxIni := {}

cSB2Join := IIf(mv_par07 == 1,"LEFT","")

If l460RLoc .AND. Len(aAlmoxIni)>0
	cSB2Where := "( "
	For nX := 1 To Len(aAlmoxIni) - 1
		cSB2Where += " ( SB2.B2_LOCAL BETWEEN '" +aAlmoxIni[nX] +"' AND '"+aAlmoxFim[nX]+"' ) OR "+Char(13)
		//cSB2Where += " ( SB2.B2_LOCAL IN('01','02','04','13','15','16','17','20','21','96','97','99') ) OR "+Char(13)
	Next nX
	cSB2Where += " ( SB2.B2_LOCAL BETWEEN '" +aAlmoxIni[nX] +"' AND '"+aAlmoxFim[nX]+"' )) "+Char(13)
	//cSB2Where += " ( SB2.B2_LOCAL IN('01','02','04','13','15','16','17','20','21','96','97','99') )) "+Char(13)
Else
	//cSB2Where := " SB2.B2_LOCAL BETWEEN '" + cAlmoxIni + "' AND '" + cAlmoxFim +"' "
	cSB2Where := " SB2.B2_LOCAL IN('01','02','04','13','15','16','17','20','21','96','97','99') "
EndIf

cQuery:= ""
cQuery+= " SELECT "+Char(13)
cQuery+= "		SB1.B1_COD, "+Char(13)
cQuery+= "		SB2.B2_COD, SB2.B2_LOCAL, SB2.B2_CM1, "+Char(13)
cQuery+= "		SB9.B9_COD, SB9.B9_QINI, SB9.B9_VINI1, "+Char(13)
cQuery+= "      (SELECT MAX(B6_PRODUTO) FROM " +RetSqlName("SB6") + " SB6 "+Char(13)
cQuery+= "								WHERE SB6.B6_FILIAL  = '"+xFilial("SB6")+"' "+Char(13)
cQuery+= "		                              AND SB6.B6_PRODUTO = SB1.B1_COD "+Char(13)
cQuery+= "		                              AND SB6.B6_ATEND   <> 'S' "+Char(13)
cQuery+= "		                              AND SB6.D_E_L_E_T_ = ' ') B6_PRODUTO, "+Char(13)
cQuery+= "		(SELECT MAX(D1_COD) FROM " +RetSqlName("SD1") + " SD1 "+Char(13)
cQuery+= "								WHERE SD1.D1_FILIAL  = '"+xFilial("SD1")+"' "+Char(13)
cQuery+= "		                              AND SD1.D1_COD     = SB9.B9_COD "+Char(13)
cQuery+= "		                              AND SD1.D1_LOCAL   = SB9.B9_LOCAL "+Char(13)
cQuery+= "		                              AND SD1.D1_DTDIGIT BETWEEN '"+cUlmes+"' AND '"+cAtMes+"' "+Char(13)
cQuery+= "		                              AND SD1.D_E_L_E_T_ = ' ' ) D1_COD, "+Char(13)
cQuery+= "		(SELECT MAX(D2_COD) FROM " +RetSqlName("SD2") + " SD2 "+Char(13)
cQuery+= "								WHERE SD2.D2_FILIAL  = '"+xFilial("SD2")+"' "+Char(13)
cQuery+= "		                              AND SD2.D2_COD     = SB9.B9_COD "+Char(13)
cQuery+= "		                              AND SD2.D2_LOCAL   = SB9.B9_LOCAL "+Char(13)
cQuery+= "		                              AND SD2.D2_EMISSAO BETWEEN '"+cUlmes+"' AND '"+cAtMes+"' "+Char(13)
cQuery+= "		                              AND SD2.D_E_L_E_T_ = ' ' ) D2_COD, "+Char(13)
cQuery+= "		(SELECT MAX(D3_COD) FROM " +RetSqlName("SD3") + " SD3 "+Char(13)
cQuery+= "								WHERE SD3.D3_FILIAL  = '"+xFilial("SD3")+"' "+Char(13)
cQuery+= "		                              AND SD3.D3_COD     = SB9.B9_COD "+Char(13)
cQuery+= "		                              AND SD3.D3_LOCAL   = SB9.B9_LOCAL "+Char(13)
cQuery+= "		                              AND SD3.D3_EMISSAO BETWEEN '"+cUlmes+"' AND '"+cAtMes+"' "+Char(13)
cQuery+= "		                              AND SD3.D_E_L_E_T_ = ' ' ) D3_COD "+Char(13)
cQuery+= " FROM " + RetSqlName("SB1") +" SB1 "+Char(13)

cQuery+= cSB2Join+" JOIN " +RetSqlName("SB2") + " SB2 ON SB2.B2_FILIAL  = '"+xFilial("SB2")+"' "+Char(13)
cQuery+= "		                                        AND SB2.B2_COD = SB1.B1_COD "+Char(13)
cQuery+= "		                                        AND " + cSB2Where + Char(13)
cQuery+= "		                                        AND SB2.D_E_L_E_T_ = ' ' "+Char(13)

cQuery+= " LEFT OUTER JOIN " +RetSqlName("SB9") + " SB9 ON SB9.B9_FILIAL = '"+xFilial("SB9")+"' "+Char(13)
cQuery+= "		                                        AND SB9.B9_COD = SB2.B2_COD "+Char(13)
cQuery+= "		                                        AND SB9.B9_LOCAL = SB2.B2_LOCAL "+Char(13)
cQuery+= "												AND SB9.B9_DATA	= '"+cSB9UlMes+"' "+Char(13)
cQuery+= "		                                        AND SB9.D_E_L_E_T_	= ' ' "+Char(13)

cQuery+= " WHERE SB1.B1_FILIAL	= '"+xFilial("SB1")+"' "+Char(13)
cQuery+= "		AND SB1.B1_COD BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' "+Char(13)
cQuery+= "		AND SB1.D_E_L_E_T_ = ' ' "+Char(13)
cQuery+= " ORDER BY SB1.B1_COD, SB2.B2_LOCAL "+Char(13)

// 13.12.2017 - Se faz necessario devido ao POSTGRES
cQuery := ChangeQuery(cQuery)

Return cQuery

/*/{Protheus.doc}u_ MTR460BlcH
//TODO Componente de chamada para o Sped para geração do bloco H010.
@author reynaldo
@since 05/01/2018
@version 1.0
@return ${return}, ${return_description}
@param dDataAte, date, descricao
@type function
/*/
user function XMTR460BlcH(dDataAte)
Local lConsolida:= .F.
Local aFilsCalc	:= {}
Local nForFilial:= 0
Local bQuebraCon:= {}
Local cQuebraCon:= ""
Local lCusConFil:= .F.
Local cArqTemp	:= ""
Local cKeyInd	:= ""
Local nQuebrAliq:= 0
Local aArqCons	:= {}

Static nDecVal // Retorna o numero de decimais usado no SX3
nDecVal:= IIF(nDecVal  == Nil,TamSX3("B2_CM1")[2],nDecVal)

Private cAlmoxIni	:= ""
Private cAlmoxFim	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                          ³
//³ mv_par01	// Saldo em Processo ?				Sim/ Não
//³ mv_par02	// Saldo em Poder 3° ?				Sim/ Não/ De Terceiros/ Em Terceiros
//³ mv_par03	// Armazem Inicial ?				<em branco>
//³ mv_par04	// Armazem Final ?					ZZ
//³ mv_par05	// Produto Inicial ?				<em branco>
//³ mv_par06	// Produto Final ?					ZZZZZZZZZZZZZZZ
//³ mv_par07	// Produtos Sem Movim. ?			Sim/ Não
//³ mv_par08	// Prods.c/Saldo Neg. ?				Sim/ Não
//³ mv_par09	// Prods.c/Saldo Zera. ?			Sim/ Não
//³ mv_par10	// Pßgina Inicial ?					1
//³ mv_par11	// N·mero do Livro ?				01
//³ mv_par12	// Imprime ?						Livro/ Termos
//³ mv_par13	// Data de Fechamento ?				01/01/2004
//³ mv_par14	// Quanto a Descricao ?				Normal/ Inclui C¾digo
//³ mv_par15	// Lista Custo Zerado ?				Sim/ Não
//³ mv_par16	// Lista Custo ?					Medio/ "FIFO/PEPS"
//³ mv_par17	// Verif Sld Processo ?				Data de Emissao/ Seq Calculo/ CM
//³ mv_par18	// Quanto a quebra por aliquota ?	Nao quebrar/ Icms produto/ Icms reducao
//³ mv_par19	// Lista MOD em Processo ?			Sim/ Não
//³ mv_par20	// Seleciona Filiais ?				Sim/ Não
//³ mv_par21	// Quebrar por Sit. Tributßria ?	Sim/ Não
//³ mv_par22	// Gerar Arq. ExportaşÒo ?			Sim/ Não
//³ mv_par23	// Arquivo Exp. Sped Fiscal ?		<em branco>
//³ mv_par24	// Aglutina por CNPJ+IE ?			Sim/ Não
//³ mv_par25	// Saldo em FabricaşÒo ?			Sim/ Não
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
Pergunte("MTR460",.F.)

mv_par01 := 1										// Saldo em Processo ?
mv_par02 := 1										// Saldo em Poder 3° ?
mv_par03 := REPLICATE(" ", TamSx3("B1_LOCPAD")[1])	// Armazem Inicial ?
mv_par04 := REPLICATE("Z", TamSx3("B1_LOCPAD")[1])	// Armazem Final ?
mv_par05 := REPLICATE(" ", TamSx3("B1_COD")[1])		// Produto Inicial ?
mv_par06 := REPLICATE("Z", TamSx3("B1_COD")[1])		// Produto Final ?
mv_par07 := 1										// Produtos Sem Movim. ?
mv_par08 := 1										// Prods.c/Saldo Neg. ?
mv_par09 := 1										// Prods.c/Saldo Zera. ?
mv_par10 := 1										// Pßgina Inicial ?
mv_par11 := "01"									// N·mero do Livro ?
mv_par12 := 1										// Imprime ?
mv_par13 := dDataAte								// Data de Fechamento ?
mv_par14 := 1										// Quanto a Descricao ?
mv_par15 := 1										// Lista Custo Zerado ?
mv_par16 := 1										// Lista Custo ?
mv_par17 := 1										// Verif Sld Processo ?
mv_par18 := 1										// Quanto a quebra por aliquota ?
mv_par19 := 2										// Lista MOD em Processo ?
mv_par20 := 2										// Seleciona Filiais ?
mv_par21 := 2										// Quebrar por Sit. Tributßria ?
mv_par22 := 1										// Gerar Arq. ExportaşÒo ?
mv_par23 := "M460SPED"								// Arquivo Exp. Sped Fiscal ?
mv_par24 := 2										// Aglutina por CNPJ+IE ?
mv_par25 := 2										// Saldo em FabricaşÒo ?

cAlmoxIni	:= IIf(mv_par03 == "**",Space(02),mv_par03)
cAlmoxFim	:= IIf(mv_par04 == "**","ZZ",mv_par04)

nQuebrAliq:=IIf(mv_par21 == 1,1,mv_par18)
lConsolida:= mv_par20 == 1 .And. mv_par24 == 1
aFilsCalc	:= MatFilCalc(mv_par20 == 1,,,lConsolida)
nForFilial:= 1
bQuebraCon:= {|x| aFilsCalc[x,4]+aFilsCalc[x,5]} //-- Bloco que define a chave de quebra
cQuebraCon:= ""
lCusConFil:= lConsolida .And. SuperGetMv('MV_CUSFIL',.F.,"A") == "F" //-- Impressao consolidada e com custo unificado por filial

// define a estrutura da tabela e seu indice
If mv_par12 == 1
	aArqTemp := A460ArqTmp(1,@cKeyInd,nQuebrAliq)
EndIf

//-- No consolidado, cria o arquivo somente uma vez (na primeira)
//-- Ou sempre se MV_CUSFIL igual a F, pois tera que somar e unificar por filial
If Empty(cArqTemp)
	cArqTemp := GetNextAlias()
	DBCreate( cArqTemp, aArqTemp, "SQLITE_TMP" )
	DBUseArea( .T., "SQLITE_TMP", cArqTemp, cArqTemp, .F., .F. )
	DBCreateIndex("idx1", cKeyInd)
	DBCreateIndex("idx2", "PRODUTO+SITUACAO+ARMAZEM")
	
	//-- Guarda nomes dos arquivos do consolidado para restaurar posteriormente
	If lCusConFil .And. (nForFilial == 1 .Or. Eval(bQuebraCon,nForFilial-1) # cQuebraCon)
		aArqCons[1] := cArqTemp
	EndIf
EndIf

//-- Se empresa impressa for da filial logada, dados do cabeçalho será da filial logada
If !lConsolida
	cFilCons := cFilAnt
ElseIf (nPos := aScan(aFilsCalc,{|x| x[2] == cFilBack .And. x[1]})) > 0 .And. Eval(bQuebraCon,nPos) == Eval(bQuebraCon,nForFilial)
	cFilCons := aFilsCalc[nPos,2]
	//-- Se empresa impressa não for da filial logada, dados do cabeçalho será da primeira filial
Else
	nPos := aScan(aFilsCalc,{|x| x[4]+x[5] == Eval(bQuebraCon,nForFilial)})
	cFilCons := aFilsCalc[nPos,2]
EndIf

// processa as informações para gerar o arquivo temporario
cTblSped := MTR460PROC(,nForFilial,aFilsCalc,cArqTemp,lConsolida,cFilCons,aArqCons,bQuebraCon,cQuebraCon,lCusConFil,nQuebrAliq)

//-- Se impressao consolidada por empresa (CNPJ + IE)
If lConsolida
	//-- Se custo unificado por filial, devera agregar no arquivo consolidado
	//-- o agregado desta filial e deletar o arquivo desta filial
	If lCusConFil .And. cArqTemp # aArqCons[1]
		If Select(cArqTemp) > 0
			(cArqTemp)->(dbCloseArea())
		EndIf
		
		//-- Restaura variaveis de controle do arquivo temporario
		cArqTemp  := aArqCons[1]
		cIndTemp1 := aArqCons[2]
		cIndTemp2 := aArqCons[3]
	EndIf
	
	//-- Se ainda nao consolidou todas, processara a proxima filial
	//-- zerando as variaveis de controle e realizando loop
	If nForFilial < Len(aFilsCalc) .And. cQuebraCon == Eval(bQuebraCon,nForFilial+1)
		
		If lCusConFil
			cArqTemp := ""
		EndIf
		
		lRetorno := .F.
		//-- Se impressao consolidada, muda filial para imprimir com os dados da filial consolidada
	Else
		SM0->(dbSeek(cEmpAnt+cFilCons))
		cFilAnt 	:= cFilCons
		cQuebraCon	:= "" //-- Limpa variavel de controle da quebra para imprimir proxima empresa
		nForBkp		:= nForFilial //-- Guarda variavel do laco para restaura-la apos impressao
		nForFilial	:= aScan(aFilsCalc,{|x| x[2] == cFilCons}) //-- Seta variavel do laco para a filial dos dados do cabecalho
	EndIf
EndIf

If Select(cArqTemp) > 0
	(cArqTemp)->(dbCloseArea())
EndIf

Return cTblSped

/*/{Protheus.doc} MTR460PROC
//TODO Componente que processa selecionando as informaçoes para impressão ou para o bloco H(Sped)
@author reynaldo
@since 05/01/2018
@version 1.0
@return ${return}, ${return_description}
@param oReport, object, descricao
@param nForFilial, numeric, descricao
@param aFilsCalc, array, descricao
@param cArqTemp, characters, descricao
@param lConsolida, logical, descricao
@param cFilCons, characters, descricao
@param aArqCons, array, descricao
@param bQuebraCon, block, descricao
@param cQuebraCon, characters, descricao
@param lCusConFil, logical, descricao
@param nQuebrAliq, numeric, descricao
@type function
/*/
Static Function MTR460PROC(oReport,nForFilial,aFilsCalc,cArqTemp,lConsolida,cFilCons,aArqCons,bQuebraCon,cQuebraCon,lCusConFil,nQuebrAliq)
Local cAtmes
Local cSB9UlMes
Local cUlmes

Local cQuery
Local cAliasTop
Local lTerc
Local lMov		:= .T.
Local lTipoBN
Local cFilP7	:= ""
Local cArqSPED := ""

Local lUsaPETN3
Local nX
Local lEnd		:= .F.
Local lRetorno	:= .F.
Local nBarra
Local a460LocFil
Local l460RLoc
Local cLocIni	:= ""
Local cLocFim	:= ""
Local aAlmoxIni := {}
Local aAlmoxFim := {}
Local cPeLocProc:= ""
Local lCusUnif	:= A330CusFil()

Local lSaldTesN3:= .F.
Local aSaldoTerD:= {}
Local aSaldoTerT:= {}
Local aA460AMZP	:= {}
Local aTerceiros:= {}

Local lGravaSit3

// parametros de sistema
Local cLocTerc		:= 'ZZ'//SuperGetMV("MV_ALMTERC",.F.,"")
Local cLocProc		:= 'ZZ'//SuperGetMv("MV_LOCPROC",.F.,"99")
Local l460UnProc	:= SuperGetMV("MV_R460UNP",.F.,.T.)
Local cTipCusto 	:= SuperGetMv("MV_R460TPC",.F.,"M")
Local nSldTesN3  	:= SuperGetMV("MV_SDTESN3",.F.,0)

// Pontos de entrada
Local lA460TESN3	:= ExistBlock("A460TESN3",,.T.)
Local lA460AMZP     := ExistBlock("A460AMZP")
Local l460RLoc      := ExistBlock("A460RLOC")

DEFAULT oReport := NIL

lUsaPETN3 := nSldTesN3 == 0

//-- A460AMZP - Ponto de Entrada para considerar um armazen
//--            adicional como armazem de processo
If lA460AMZP
	aA460AMZP := ExecBlock("A460AMZP",.F.,.F.,'')
	If ValType(aA460AMZP) == "A" .And. Len(aA460AMZP) == 1
		cPeLocProc := IIf(Valtype(aA460AMZP[1]) == "C",aA460AMZP[1],'')
	EndIf
EndIf

//-- A460RLOC - Ponto de Entrada para considerar os armzens de/ate
//--
If l460RLoc
	a460LocFil := ExecBlock("A460RLOC",.F.,.F.,'')
	If ValType(a460LocFil) == "A" .And. Len(a460LocFil) == 2
		cLocIni := IIf(Valtype(a460LocFil[1]) == "C",a460LocFil[1],'')
		cLocFim := IIf(Valtype(a460LocFil[2]) == "C",a460LocFil[2],'')
		If !Empty(cLocIni) .And. !Empty(cLocFim) .And. Len(cLocIni) == Len(cLocFim)
			For nX := 1 To Len(cLocIni) Step nTamLocal + 1
				AADD(aAlmoxIni, SubStr(cLocIni,nX,nTamLocal))
				AADD(aAlmoxFim, SubStr(cLocFim,nX,nTamLocal))
			Next nX
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Vetor aAlmoxIni vazio indica que a execucao do PE A460LOCFIL     ³
	//| nao foi bem sucedida. Assim, o comportamento padrao do filtro    ³
	//| de armazens nao eh afetado                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	l460RLoc := !Empty(aAlmoxIni)
EndIf

cAtmes := Dtos(mv_par13) // data de fechamento informado no pergunte() [maior data]
cSB9UlMes := GetUlMes(cAtmes) // Obtem data do ultimo fechamento anterior a data informada (MV_PAR13)
cUlmes := dtos(stod(cSB9UlMes)+1) // A data inicial para considerar os movimentos [menor data]
// Se as datas forem iguais a data final deve ser igual então é a data do ultimo fechamento na SB9,
// então deve considerar a data fim igual
If cAtmes == cSB9UlMes
	cAtmes := cUlmes
EndIf

//-- Cria Indice de Trabalho para Poder de Terceiros

If oReport <> NIL
	//-- Filtragem do relatorio
	MakeSqlExpr(oReport:uParam)
EndIf

cAliasTop := GetNextAlias()

If oReport <> NIL
	//-- Query do relatorio da secao 1
	oReport:Section(1):BeginQuery()
EndIf

// monta a query principal
cQuery := R460Select(cAtmes,cSB9UlMes,cUlmes,aAlmoxIni,aAlmoxFim)

If Select(cAliasTop) > 0
	(cAliasTop)->(DbCloseArea())
Endif

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery) , cAliasTop, .T., .F. )
If oReport <> NIL
	oReport:Section(1):EndQuery()
EndIf

nBarra := 0
(cAliasTop)->(dbEval({|| nBarra++}))

If oReport <> NIL
	oReport:SetMeter(nBarra)
EndIf
(cAliasTop)->(dbGoTop())

//-- Posiciona produto
SB1->(dbSetOrder(1))

If oReport <> NIL
	oReport:SetMsgPrint(STR0041 +aFilsCalc[nForFilial,2] +" - " +aFilsCalc[nForFilial,3])
EndIf

While !(cAliasTop)->(EOF())
	If oReport <> NIL .AND. oReport:Cancel()
		oReport:IncMeter()
		lEnd := .T.
	EndIf
	
	lTerc:= !EMPTY((cAliasTop)->B6_PRODUTO) // Se existe terceiros
	
	SB1->(MsSeek(xFilial("SB1")+(cAliasTop)->B1_COD))
	
	lTipoBN := SB1->B1_TIPO == 'BN' .And. !Empty(SB1->B1_TIPOBN) // se for produto de Beneficiamento
	
	// Avalia se o Produto nao entrara no processamento
	If !R460AvalProd(SB1->B1_COD)
		(cAliasTop)->(dbSkip())
		Loop
	EndIf
	
	//-- Alimenta Array com Saldo D = De Terceiros/ T = Em Terceiros
	If lTerc .AND. mv_par02 <> 2
		//-- Ponto de Entrada A460TESN3 criado para utilizacao do 8o.parametro da funcao
		//-- SALDOTERC (considera saldo Poder3 tambem c/ TES que NAO atualiza estoque)
		lSaldTesN3 := .F.
		If lUsaPETN3 .And. lA460TESN3
			lSaldTesN3 := ExecBlock("A460TESN3",.F.,.F.,{SB1->B1_COD,mv_par13})
			If ValType(lSaldTesN3) <> "L"
				lSaldTesN3 := .F.
			EndIf
		EndIf
		
		If mv_par02 == 1 .Or. mv_par02 == 3
			aSaldoTerD := SaldoTerc(SB1->B1_COD,cAlmoxIni,"D",mv_par13,cAlmoxFim,,SB1->B1_COD,IIf(lUsaPETN3,lSaldTesN3,nSldTesN3<>0),!mv_par16==1,,.T.,IIF(l460RLoc,{aAlmoxIni,aAlmoxFim},Nil))
		EndIf
		If mv_par02 == 1 .Or. mv_par02 == 4
			aSaldoTerT := SaldoTerc(SB1->B1_COD,cAlmoxIni,"T",mv_par13,cAlmoxFim,,SB1->B1_COD,IIf(lUsaPETN3,lSaldTesN3,nSldTesN3<>0),!mv_par16==1,,.T.,IIF(l460RLoc,{aAlmoxIni,aAlmoxFim},Nil))
		EndIf
	EndIf
	
	//-- Busca Saldo em Estoque
	aSalAtu	  := {}
	aSaldo    := {0,0,0,0}
	
	If (cAliasTop)->(EOF()) .Or. SB1->B1_COD <> (cAliasTop)->B2_COD
		//-- Lista produtos sem movimentacao de estoque
		If mv_par07 == 1
			lGravaSit3 := .T.
			//-- So grava no consolidado caso nenhuma das filiais tenha saldo
			If lConsolida
				//-- Ve nas filiais ja processadas
				//-- Se custo unificado por filial, ve no arquivo consolidador
				If lCusConFil
					(aArqCons[1])->(dbSetOrder(2))
					lGravaSit3 := !(aArqCons[1])->(dbSeek(SB1->B1_COD))
					//-- Se nao, olha no arquivo corrente (ja consolidado)
				Else
					(cArqTemp)->(dbSetOrder(2))
					lGravaSit3 := !(cArqTemp)->(dbSeek(SB1->B1_COD))
				EndIf
				
				//-- Ve nas filiais a processar
				If lGravaSit3
					SB2->(dbSetOrder(1))
					For nX := nForFilial+1 To Len(aFilsCalc)
						If !(lGravaSit3 := !SB2->(dbSeek(xFilial("SB2",aFilsCalc[nX,2])+SB1->B1_COD)))
							Exit
						EndIf
					Next nX
				EndIf
			EndIf
			
			If lGravaSit3
				//-- TIPO 3 - PRODUTOS SEM SALDO
				RecLock(cArqTemp,.T.)
				(cArqTemp)->FILIAL		:= xFilial("SB2",cFilCons)
				(cArqTemp)->SITUACAO	:= "3"
				(cArqTemp)->TIPO		:= If(lTipoBN,SB1->B1_TIPOBN,SB1->B1_TIPO)
				(cArqTemp)->PRODUTO		:= SB1->B1_COD
				(cArqTemp)->POSIPI		:= SB1->B1_POSIPI
				(cArqTemp)->DESCRICAO	:= SB1->B1_DESC
				(cArqTemp)->UM		   	:= SB1->B1_UM
				(cArqTemp)->ARMAZEM 	:= IIF (empty((cAliasTop)->B2_LOCAL), SB1->B1_LOCPAD, (cAliasTop)->B2_LOCAL)
				If nQuebrAliq == 2
					(cArqTemp)->ALIQ := RetFldProd(SB1->B1_COD, "B1_PICM")
				ElseIf nQuebrAliq == 3
					(cArqTemp)->ALIQ := If(SB0->(MsSeek(xFilial("SB0")+SB1->B1_COD)),SB0->B0_ALIQRED,0)
				EndIf
				If mv_par21 == 1
					(cArqTemp)->SITTRIB := R460STrib(SB1->B1_COD)
				EndIf
				(cArqTemp)->(MsUnLock())
			EndIf
		EndIf
		
		(cAliasTop)->(dbSkip())
	Else
		nCusMed := 0
		//-- Lista produtos com movimentacao de estoque
		While !lEnd .AND. !(cAliasTop)->(EOF()) .And. (cAliasTop)->B1_COD == SB1->B1_COD
			If oReport <> NIL .AND. oReport:Cancel()
				lEnd := .T.
			EndIf
			
			//-- Desconsidera almoxarifado de saldo em processo de mat.indiret
			//-- ou saldo em armazem de terceiros
			If (cAliasTop)->B2_LOCAL == cLocProc ;
				.Or. (cAliasTop)->B2_LOCAL $ cLocTerc ;
				.Or. (cAliasTop)->B2_LOCAL $ cPeLocProc
				(cAliasTop)->(dbSkip())
				Loop
			EndIf
			
			// Assume que deve calcular os movimentos, pois não encontrou Saldo Inicial na data
			If Empty((cAliasTop)->B9_COD)
				lMov := .T.
			Else
				lMov := (!EMPTY((cAliasTop)->D1_COD) .OR. (!EMPTY((cAliasTop)->D2_COD) .OR. !EMPTY((cAliasTop)->D3_COD)))
			EndIf
			
			//-- Retorna o Saldo Atual
			If lMov //Se o produto não possui movimentação ele pega o saldo direto da SB9
				If mv_par16 == 1
					aSalAtu := CalcEst(SB1->B1_COD,(cAliasTop)->B2_LOCAL,mv_par13+1,NIL,mv_par02 <> 2 .and. !lUsaPETN3 .and. nSldTesN3==1)
				Else
					aSalAtu := CalcEstFF(SB1->B1_COD,(cAliasTop)->B2_LOCAL,mv_par13+1,NIL)
				EndIf
			Else
				aSalAtu := {(cAliasTop)->B9_QINI, (cAliasTop)->B9_VINI1,0,0}
			Endif
			
			//Verifica se os produtos possuem saldo conforme parâmetros
			//preenchidos pelo usuário.
			If	(!mv_par08 == 1 .And. aSalAtu[1] < 0) ;
				.Or. (!mv_par09 == 1 .And. aSalAtu[1] == 0) ;
				.Or.(!mv_par16 == 1 .And. aSalAtu[2] == 0)
				(cAliasTop)->(dbSkip())
				Loop
			EndIf
			
			//-- TIPO 1 - EM ESTOQUE
			//(cArqTemp)->(dbSetOrder(2))
			If (cArqTemp)->(dbSeek(SB1->B1_COD+"1"))
				RecLock(cArqTemp,.F.)
			Else
				RecLock(cArqTemp,.T.)
				
				(cArqTemp)->FILIAL		:= xFilial("SB2",cFilCons)
				(cArqTemp)->SITUACAO	:= "1"
				(cArqTemp)->TIPO		:= If(lTipoBN,SB1->B1_TIPOBN,SB1->B1_TIPO)
				(cArqTemp)->POSIPI		:= SB1->B1_POSIPI
				(cArqTemp)->PRODUTO		:= SB1->B1_COD
				(cArqTemp)->DESCRICAO	:= SB1->B1_DESC
				(cArqTemp)->UM			:= SB1->B1_UM
				(cArqTemp)->ARMAZEM     := IIF (empty((cAliasTop)->B2_LOCAL), SB1->B1_LOCPAD, (cAliasTop)->B2_LOCAL)
				If nQuebrAliq == 2
					(cArqTemp)->ALIQ := RetFldProd(SB1->B1_COD, "B1_PICM")
				ElseIf nQuebrAliq == 3
					(cArqTemp)->ALIQ := If(SB0->(MsSeek(xFilial("SB0")+SB1->B1_COD)),SB0->B0_ALIQRED,0)
				EndIf
				If mv_par21 == 1
					(cArqTemp)->SITTRIB := R460STrib(SB1->B1_COD)
				EndIf
			EndIf
			(cArqTemp)->QUANTIDADE 	+= aSalAtu[01]
			(cArqTemp)->TOTAL		+= aSalAtu[02]
			If (cArqTemp)->QUANTIDADE > 0
				(cArqTemp)->VALOR_UNIT := (cArqTemp)->(Round(TOTAL/QUANTIDADE,nDecVal))
				nCusMed := (cArqTemp)->VALOR_UNIT
			EndIf
			
			//-- Este Ponto de Entrada foi criado para recalcular o Valor Unitario/Total
			If lCalcUni
				ExecBlock("A460UNIT",.F.,.F.,{SB1->B1_COD,(cAliasTop)->B2_LOCAL,mv_par13,cArqTemp,{'aSalAtu',aSalAtu[01],aSalAtu[02]}})
			EndIf
			
			(cArqTemp)->(MsUnLock())
			(cAliasTop)->(dbSkip())
		End
		
		//-- Pesquisa os valores de material de terceiros requisitados para OP
		aDadosCF9 := {0,0} // Quantidade e custo na 1a moeda para movimentos do SD3 com D3_CF RE9 ou DE9
		If SB1->B1_AGREGCU == "1"
			aDadosCF9 := U_XSaldoD3CF9(SB1->B1_COD,STOD(cUlmes),STOD(cAtmes),cAlmoxIni,cAlmoxFim,IIF(l460RLoc,{aAlmoxIni,aAlmoxFim},Nil))
			If QtdComp(aDadosCF9[1]) > QtdComp(0) .Or. QtdComp(aDadosCF9[2]) > QtdComp(0)
				(cArqTemp)->(dbSetOrder(2))
				If (cArqTemp)->(dbSeek(SB1->B1_COD+"6"))
					RecLock(cArqTemp,.F.)
				Else
					RecLock(cArqTemp,.T.)
					
					(cArqTemp)->FILIAL		:= xFilial("SB2",cFilCons)
					(cArqTemp)->SITUACAO	:= "6"
					(cArqTemp)->TIPO		:= If(lTipoBN,SB1->B1_TIPOBN,SB1->B1_TIPO)
					(cArqTemp)->POSIPI		:= SB1->B1_POSIPI
					(cArqTemp)->PRODUTO		:= SB1->B1_COD
					(cArqTemp)->DESCRICAO	:= SB1->B1_DESC
					(cArqTemp)->UM			:= SB1->B1_UM
					(cArqTemp)->ARMAZEM 	:= IIF (empty((cAliasTop)->B2_LOCAL), SB1->B1_LOCPAD, (cAliasTop)->B2_LOCAL)
					If nQuebrAliq == 2
						(cArqTemp)->ALIQ := RetFldProd(SB1->B1_COD, "B1_PICM")
					ElseIf nQuebrAliq == 3
						(cArqTemp)->ALIQ := If(SB0->(MsSeek(xFilial("SB0")+SB1->B1_COD)),SB0->B0_ALIQRED,0)
					EndIf
					If mv_par21 == 1
						(cArqTemp)->SITTRIB := R460STrib(SB1->B1_COD)
					EndIf
				EndIf
				(cArqTemp)->QUANTIDADE 	:= aDadosCF9[1]
				(cArqTemp)->TOTAL		:= aDadosCF9[2]
				//-- Recalcula valor unitario
				If (cArqTemp)->QUANTIDADE > 0
					(cArqTemp)->VALOR_UNIT := (cArqTemp)->(NoRound(TOTAL/QUANTIDADE,nDecVal))
				EndIf
				
				//-- Este Ponto de Entrada foi criado para recalcular o Valor Unitario/Total
				If lCalcUni
					ExecBlock("A460UNIT",.F.,.F.,{SB1->B1_COD,"",mv_par13,cArqTemp,{'aDadosCF9',aDadosCF9[01],aDadosCF9[02]}})
				EndIf
				
				(cArqTemp)->(MsUnLock())
			EndIf
		EndIf
		
		//-- Tratamento de poder de terceiros
		If mv_par02 <> 2 .And. SB1->B1_FILIAL == xFilial("SB1")
			//-- Pesquisa os valores D = De Terceiros na array aSaldoTerD
			nX := aScan(aSaldoTerD,{|x| x[1] == xFilial("SB6")+SB1->B1_COD})
			If !(nX == 0)
				aSaldo[1] := aSaldoTerD[nX][3]
				aSaldo[2] := aSaldoTerD[nX][4]
				aSaldo[3] := aSaldoTerD[nX][5]
				If Len(aSaldoTerD[nX]) > 5
					aSaldo[4] := aSaldoTerD[nX][6]
				EndIf
			EndIf
			
			//-- Manipula arquivo de trabalho subtraindo do saldo em estoque saldo de terceiros
			(cArqTemp)->(dbSetOrder(2))
			If (cArqTemp)->(dbSeek(SB1->B1_COD+"1"))
				RecLock(cArqTemp,.F.)
			Else
				RecLock(cArqTemp,.T.)
				
				(cArqTemp)->FILIAL		:= xFilial("SB2",cFilCons)
				(cArqTemp)->SITUACAO	:= "1"
				(cArqTemp)->TIPO		:= If(lTipoBN,SB1->B1_TIPOBN,SB1->B1_TIPO)
				(cArqTemp)->POSIPI		:= SB1->B1_POSIPI
				(cArqTemp)->PRODUTO		:= SB1->B1_COD
				(cArqTemp)->DESCRICAO	:= SB1->B1_DESC
				(cArqTemp)->UM			:= SB1->B1_UM
				(cArqTemp)->ARMAZEM 	:= IIF (empty((cAliasTop)->B2_LOCAL), SB1->B1_LOCPAD, (cAliasTop)->B2_LOCAL)
				If nQuebrAliq == 2
					(cArqTemp)->ALIQ := RetFldProd(SB1->B1_COD, "B1_PICM")
				ElseIf nQuebrAliq == 3
					(cArqTemp)->ALIQ := If(SB0->(MsSeek(xFilial("SB0")+SB1->B1_COD)),SB0->B0_ALIQRED,0)
				EndIf
				If mv_par21 == 1
					(cArqTemp)->SITTRIB := R460STrib(SB1->B1_COD)
				EndIf
			EndIf
			(cArqTemp)->QUANTIDADE 	-= aSaldo[01]
			(cArqTemp)->TOTAL		-= aSaldo[02]
			If IIf(lUsaPETN3,lSaldTesN3 .And. nSumQtTer == 1,nSldTesN3 == 2)  // MV_SDTESN3 = 2 -> Utilizar TES F4_ESTOQUE = N mas NAO subtrair saldo
				(cArqTemp)->QUANTIDADE 	+= aSaldo[03]
				(cArqTemp)->TOTAL		+= If(Len(aSaldo) >3,aSaldo[4],0)
			EndIf
			
			//-- Pesquisa os valores de material de terceiros requisitados para OP
			If SB1->B1_AGREGCU == "1"
				//-- Desconsidera do calculo do saldo em estoque movimentos RE9 e DE9
				If QtdComp(aDadosCF9[1]) > QtdComp(0) .Or. QtdComp(aDadosCF9[2]) > QtdComp(0)
					(cArqTemp)->QUANTIDADE 	+= aDadosCF9[1]
					(cArqTemp)->TOTAL		+= aDadosCF9[2]
				EndIf
			EndIf
			
			//-- Recalcula valor unitario
			If (cArqTemp)->QUANTIDADE > 0
				(cArqTemp)->VALOR_UNIT := (cArqTemp)->(NoRound(TOTAL/QUANTIDADE,nDecVal))
			EndIf
			
			//-- Este Ponto de Entrada foi criado para recalcular o Valor Unitario/Total
			If lCalcUni
				ExecBlock("A460UNIT",.F.,.F.,{SB1->B1_COD,"",mv_par13,cArqTemp,{'aDadosCF9',aDadosCF9[01],aDadosCF9[02]}})
			EndIf
			(cArqTemp)->(MsUnLock())
		EndIf
	EndIf
	
	If mv_par22 == 1 .And. !Empty(mv_par23) // Gerar arquivo de exportacao e nome do arquivo a ser exportado
		If lTerc // se tem produto em/de terceiros
			If mv_par02 == 1 .Or. mv_par02 == 3
				aAuxTer := SaldoTerc(SB1->B1_COD,cAlmoxIni,"D",mv_par13,cAlmoxFim,.T.,SB1->B1_COD,IIf(lUsaPETN3,lSaldTesN3,nSldTesN3<>0),!mv_par16==1,,.T.,IIF(l460RLoc,{aAlmoxIni,aAlmoxFim},Nil),.T.)
				For nX := 1 To Len(aAuxTer)
					aAdd(aTerceiros,{"4",SubStr(aAuxTer[nX,1],nTPCF+nCLIFOR+nLOJA+1,nPRODUTO),SubStr(aAuxTer[nX,1],nTPCF+1,nCLIFOR),SubStr(aAuxTer[nX,1],nTPCF+nCLIFOR+1,nLOJA),aAuxTer[nX,2],aAuxTer[nX,3],aAuxTer[nX,4],SubStr(aAuxTer[nX,1],1,1)})
				Next nX
			EndIf
			If mv_par02 == 1 .Or. mv_par02 == 4
				aAuxTer := SaldoTerc(SB1->B1_COD,cAlmoxIni,"T",mv_par13,cAlmoxFim,.T.,SB1->B1_COD,IIf(lUsaPETN3,lSaldTesN3,nSldTesN3<>0),!mv_par16==1,,.T.,IIF(l460RLoc,{aAlmoxIni,aAlmoxFim},Nil),.T.)
				For nX := 1 to Len(aAuxTer)
					aAdd(aTerceiros,{"5",SubStr(aAuxTer[nX,1],nTPCF+nCLIFOR+nLOJA+1,nPRODUTO),SubStr(aAuxTer[nX,1],nTPCF+1,nCLIFOR),SubStr(aAuxTer[nX,1],nTPCF+nCLIFOR+1,nLOJA),aAuxTer[nX,2],Iif(cTipCusto == 'M' .And. nCusMed > 0,(nCusMed*aAuxTer[nX,2]),aAuxTer[nX,3]),aAuxTer[nX,4],SubStr(aAuxTer[nX,1],1,1)})
				Next nX
			EndIf
		EndIf
	EndIf
	
	If lTerc // se tem produto em/de terceiros
		//-- Processa Saldo De Terceiro TIPO 4 - SALDO DE TERCEIROS
		R460Terceiros(aSaldoTerD,aSaldoTerT,@lEnd,cArqTemp,"4",aDadosCF9,cAliasTop,lTipoBN,cFilCons,IIF(l460RLoc,{aAlmoxIni,aAlmoxFim},Nil),nCusMed)
		
		//-- Processa Saldo Em Terceiro TIPO 5 - SALDO EM TERCEIROS
		R460Terceiros(aSaldoTerD,aSaldoTerT,@lEnd,cArqTemp,"5",NIL,cAliasTop,lTipoBN,cFilCons,IIF(l460RLoc,{aAlmoxIni,aAlmoxFim},Nil),nCusMed)
	EndIf
	
End // while cAliasTop

If oReport <> NIL .AND. oReport:Cancel()
	lEnd := .T.
EndIf

//-- Processa Saldo Em Processo TIPO 2 - SALDO EM PROCESSO
If SuperGetMV("MV_R460PRC",.F.,1) == 1
	U_XR460EmProcesso(@lEnd,cArqTemp,.T.,,,lTipoBN,cFilCons,,IIF(l460RLoc,{aAlmoxIni,aAlmoxFim},Nil))
Else
	U_XR460AnProcesso(@lEnd,cArqTemp,.T.,,,lTipoBN,IIF(l460RLoc,{aAlmoxIni,aAlmoxFim},Nil))
EndIf

//-- CUSTO UNIFICADO - Realiza acerto dos valores para todos tipos
If lCusUnif .And. (!lConsolida .Or. lCusConFil .Or. nForFilial == Len(aFilsCalc))
	(cArqTemp)->(dbSetOrder(2))
	(cArqTemp)->(dbGotop())
	//-- Percorre arquivo
	While !lEnd .AND. !(cArqTemp)->(EOF())
		cSeekUnif   := (cArqTemp)->PRODUTO
		aSeek       := {}
		nValTotUnif := 0
		nQtdTotUnif := 0
		While !(cArqTemp)->(EOF()) .And. cSeekUnif == (cArqTemp)->PRODUTO
			If oReport <> NIL .AND. oReport:Cancel()
				lEnd := .T.
			EndIf
			
			If (!mv_par08 == 1 .And. (cArqTemp)->QUANTIDADE < 0) .Or.;
				(!mv_par09 == 1 .And. (cArqTemp)->QUANTIDADE == 0) .Or.;
				(!mv_par15 == 1 .And. (cArqTemp)->TOTAL == 0)
				(cArqTemp)->(dbSkip())
				Loop
			EndIf
			
			//-- Nao processar o saldo de/em terceiros aglutinado ao custo medio
			If !((cArqTemp)->SITUACAO $ "2457")
				If l460UnProc
					aAdd(aSeek,(cArqTemp)->(Recno()))
					nValTotUnif += (cArqTemp)->TOTAL
					nQtdTotUnif += (cArqTemp)->QUANTIDADE
				ElseIf !((cArqTemp)->SITUACAO == "2")
					aAdd(aSeek,(cArqTemp)->(Recno()))
					nValTotUnif += (cArqTemp)->TOTAL
					nQtdTotUnif += (cArqTemp)->QUANTIDADE
				EndIf
			EndIf
			
			(cArqTemp)->(dbSkip())
		End
		
		If Len(aSeek) > 0
			// Calcula novo valor unitario
			For nx := 1 to Len(aSeek)
				If QtdComp(nQtdTotUnif) <> QtdComp(0)
					(cArqTemp)->(dbGoto(aSeek[nx]))
					If !(cArqTemp)->(Eof())
						RecLock(cArqTemp,.f.)
						(cArqTemp)->VALOR_UNIT := NoRound(nValTotUnif/nQtdTotUnif,nDecVal)
						(cArqTemp)->TOTAL      := (cArqTemp)->QUANTIDADE * (nValTotUnif/nQtdTotUnif)
						(cArqTemp)->(MsUnlock())
					EndIf
				EndIf
			Next nx
			
			(cArqTemp)->(dbSkip())
		EndIf
	End
EndIf

//-- Se impressao consolidada por empresa (CNPJ + IE)
If lConsolida
	//-- Se custo unificado por filial, devera agregar no arquivo consolidado
	//-- o agregado desta filial e deletar o arquivo desta filial
	If lCusConFil .And. cArqTemp # aArqCons[1]
		//-- Agrega filial no arquivo consolidado
		(cArqTemp)->(dbGoTop())
		(aArqCons[1])->(dbSetOrder(1))
		While !(cArqTemp)->(EOF())
			If (aArqCons[1])->(dbSeek((cArqTemp)->&((aArqCons[1])->(IndexKey()))))
				RecLock(aArqCons[1],.F.)
			Else
				RecLock(aArqCons[1],.T.)
				(aArqCons[1])->FILIAL 	:= (cArqTemp)->FILIAL
				(aArqCons[1])->SITUACAO	:= (cArqTemp)->SITUACAO
				(aArqCons[1])->TIPO 	:= (cArqTemp)->TIPO
				(aArqCons[1])->POSIPI 	:= (cArqTemp)->POSIPI
				(aArqCons[1])->PRODUTO 	:= (cArqTemp)->PRODUTO
				(aArqCons[1])->DESCRICAO:= (cArqTemp)->DESCRICAO
				(aArqCons[1])->UM 		:= (cArqTemp)->UM
				(aArqCons[1])->ALIQ 	:= (cArqTemp)->ALIQ
				(aArqCons[1])->SITTRIB 	:= (cArqTemp)->SITTRIB
				(aArqCons[1])->ARMAZEM 	:= (cArqTemp)->ARMAZEM
			EndIf
			(aArqCons[1])->QUANTIDADE 	+= (cArqTemp)->QUANTIDADE
			(aArqCons[1])->TOTAL 		+= (cArqTemp)->TOTAL
			(aArqCons[1])->VALOR_UNIT 	:= (aArqCons[1])->TOTAL / (aArqCons[1])->QUANTIDADE
			(aArqCons[1])->(MsUnLock())
			
			(cArqTemp)->(dbSkip())
		End
		
	EndIf
	
EndIf

//-- Geracao do registro para Exportacao de dados (Sped Fiscal)
If mv_par22 == 1 .And. !Empty(mv_par23)
	cArqSPED := R460GrvTRB(aTerceiros,cArqTemp,aFilsCalc[nForFilial,2],@cFilP7,nQuebrAliq)
EndIf

If Select(cAliasTop) > 0
	(cAliasTop)->(dbCloseArea())
EndIf

Return cArqSPED
