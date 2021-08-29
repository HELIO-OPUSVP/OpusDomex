#INCLUDE "TBICONN.CH"
#INCLUDE "MATA710.CH"                              
#INCLUDE "PROTHEUS.CH"                                                   
#INCLUDE "DBTREE.CH"                                                         
#INCLUDE "FILEIO.CH"                                                                                                        
#DEFINE _CRLF CHR(13)+CHR(10)                                                                                  
#DEFINE _NEWLINE chr(13)+chr(13)                                          

Static lA710SINI    := ExistBlock("A710SINI")
Static lA710REV     := ExistBlock("A710REV")
Static lMT710SHA	:= ExistBlock("MT710SHA")
Static lPeMT710EXP  := ExistBlock("MT710EXP")
Static lM710Qtde	:= ExistBlock("M710QTDE")
Static lUsaMOpc		:= If(SuperGetMv('MV_REPGOPC',.F.,"N") == "S",.T.,.F.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ MATA710  ³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 21/05/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ MRP                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³--------> ³ NAO INCLUIR RECLOCK E MSUNLOCK NA MANIPULACAO DOS ARQUIVOS ³±±
±±³--------> ³ SHA ,SHF , SHG E SH5 PARA OTIMIZACAO DE PERFORMANCE.COMO OS³±±
±±³OBSERVACAO³ ARQUIVOS SAO ABERTOS DE FORMA EXCLUSIVA NAO HA NECESSIDADE ³±±
±±³--------> ³  DE TRAVAR OS REGISTROS PARA GRAVACAO !!!                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³  IDENTIFICACAO DOS ARQUIVOS                                ³±±
±±³SH5-----> ³  DETALHE DE CADA MOVIMENTO PROCESSADO PELO MRP             ³±±
±±³SHA-----> ³  CALCULO DO MRP                                            ³±±
±±³SHG-----> ³  LOG DO CALCULO DO MRP                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Para rodar em batch, exemplo:                                          ³±±
±±³Local lBatch    := .T.  -> Identifica MRP rodado em modo Batch         ³±±
±±³Local nTipoPer  :=  1   -> Tipo de periodo 1=Diario;2=Semanal;         ³±±
±±³                           3=Quinzenal;4=Mensal;5=Trimestral;          ³±±
±±³                           6=Semestral                                 ³±±
±±³Local nPeriodos := 20   -> Quantidade de periodos                      ³±±
±±³Local lPedidos  := .F.  -> Considera Pedidos em Carteira               ³±±
±±³Local aTipo     := Nil  -> Array contendo Tipos  de produtos a serem   ³±±
±±³                           considerados (se Nil, assume padrao)        ³±±
±±³Local aGrupo    := Nil  -> Array contendo Grupos de produtos a serem   ³±±
±±³                           considerados (se Nil, assume padrao)        ³±±
±±³Local lGeraOpSc := .T.  -> Gera/Nao Gera OPs e SCs depois do calculo da³±±
±±³                           necessidade.                                ³±±
±±³Local lLogMrp   := .F.  -> Indica se monta log do MRP                  ³±±
±±³Local cNumOpDig := "000001" -> Numero da Op Inicial                    ³±±
±±³                                                                       ³±±
±±³Uso:                                                                   ³±±
±±³MATA710A(lBatch,{nTipoPer,nPeriodos,lPedidos,,,lGeraOpSc,lLogMRP,      ³±±
±±³         cNumOpDig})                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER Function UMATA710(lParBatch, aParAuto)
LOCAL cSavAlias  := Alias()
LOCAL nOk        := 0,nz:=0
LOCAL cVarQ      :="",cVarQ2:="",cCapital:=""
LOCAL lVisualiza :=.F.
LOCAL oUsado,oChk,oChk2,oChk3,oQual,oQual2,oPer
LOCAL oChkQual,lQual,oChkQual2,lQual2
LOCAL lOldHelpAuto
LOCAL i          := 0
LOCAL aRetPar    :={},lOkExec:=.T.,zz
LOCAL cStrTipo   :="",cStrGrupo:=""
LOCAL lMT710TL   := ExistBlock("MT710TL")
LOCAL aTreeProc  := {}
//LOCAL bBlNewProc := {|oCenterPanel|a710MCond(@cStrTipo,@cStrGrupo),MTA711SH5(lPedido,lVisualiza,cStrTipo,cStrGrupo,oCenterPanel)}
LOCAL bBlNewProc := {|oCenterPanel|U_Xa710MCond(@cStrTipo,@cStrGrupo),MTA711SH5(lPedido,lVisualiza,cStrTipo,cStrGrupo,oCenterPanel)}
LOCAL lUsaNewPrc :=  .F. //UsaNewPrc()

PRIVATE nQuantPer:=030,nUsado:=1
PRIVATE oOk       := LoadBitmap( GetResources(), "LBOK")
PRIVATE oNo       := LoadBitmap( GetResources(), "LBNO")
PRIVATE lPedido   := .F.
PRIVATE lLogMRP:=.F.
PRIVATE cCadastro  := 'STR0001'  //"MRP"
PRIVATE aOpcoes[2][7]
PRIVATE aLogMRP710  := {}
PRIVATE A711Tipo    := {},A711Grupo:={}
PRIVATE aPergs711   := {}
PRIVATE nTamTipo711 := TamSX3("B1_TIPO")[1]
PRIVATE nTamGr711   := TamSX3("B1_GRUPO")[1]
PRIVATE lGeraPI     := GETMV("MV_GERAPI")
PRIVATE lDigNumOp   := .F.
PRIVATE lDiasHl 	:= .T.
PRIVATE lDiasHf 	:= .T.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a permissao do programa em relacao aos modulos      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

PRIVATE lBatch := lParBatch # Nil .And. lParBatch
PRIVATE aAuto  := aClone(aParAuto)
PRIVATE aFilAlmox
PRIVATE aAlmoxNNR

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se mostra logs em tela                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
Criado parametro MV_HELPMRP para indicar se mostra helps de validacao
na geracao de OP/SC ou nao. Se o parametro nao existir ou
se estiver preenchido com .F. o sistema NAO mostra os helps
se estiver preenchido com .T. o sistema mostra os helps.
*/
PRIVATE	lMsHelpAuto  :=   !(GetMV("MV_HELPMRP",NIL,.T.))
PRIVATE  lMostraErro  := .F.

PRIVATE cPictB2Local := PesqPict("SB2","B2_LOCAL")
PRIVATE cPictB2Qatu  := PesqPict("SB2","B2_QATU" )
PRIVATE cPictB2QNPT  := PesqPict("SB2","B2_QNPT" )
PRIVATE cPictB2QTNP  := PesqPict("SB2","B2_QTNP" )
PRIVATE cPictD7QTDE  := PesqPict("SD7","D7_QTDE" )
PRIVATE cPictDDSaldo := PesqPict("SDD","DD_SALDO")

If AMIIn(10,44,4)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa o log de processamento   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcLogIni( {},"MATA710")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o log de processamento   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcLogAtu("INICIO")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta a Tabela de Tipos                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX5")
	dbSeek(xFilial("SX5")+"02")
	Do While (X5_FILIAL == xFilial("SX5")) .AND. (X5_TABELA == "02") .and. !Eof()
		cCapital := OemToAnsi(Capital(X5Descri()))
		AADD(A711Tipo,{.T.,SubStr(X5_chave,1,nTamTipo711)+" - "+cCapital})
		dbSkip()
	EndDo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta a Tabela de Grupos                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SBM")
	dbSeek(xFilial("SBM"))
	AADD(A711Grupo,{.T.,Criavar("B1_GRUPO",.F.)+" - "+'STR0060'}) //"Grupo em Branco"
	Do While (BM_FILIAL == xFilial("SBM")) .AND. !Eof()
		cCapital := OemToAnsi(Capital(BM_DESC))
		AADD(A711Grupo,{.T.,SubStr(BM_GRUPO,1,nTamGr711)+" - "+cCapital})
		dbSkip()
	EndDo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ MV_PAR01    ->  tipo de alocacao           1-p/ fim          2-p/inicio           ³
	//³ MV_PAR02    ->  Geracao de SC.             1-p/OPs           2-p/necess.          ³
	//³ MV_PAR03    ->  Geracao de OP PIS          1-p/OPs           2-p/necess.          ³
	//³ MV_PAR04    ->  Periodo p/Gerar OP/SC      1-Junto           2-Separado           ³
	//³ MV_PAR05    ->  PV/PMP De  Data                                                   ³
	//³ MV_PAR06    ->  PV/PMP Ate Data                                                   ³
	//³ MV_PAR07    ->  Inc. Num. OP               1- Item	         2- Numero            ³
	//³ MV_PAR08    ->  De Local                   1- Sim            2- Nao               ³
	//³ MV_PAR09    ->  Ate Local                  1- Sim            2- Nao               ³
	//³ MV_PAR10    ->  Gera OPs / SCs             1- Firme          2- Prevista          ³
	//³ MV_PAR11    ->  Apaga OPs/SCs Previstas    1- Sim            2- Nao               ³
	//³ MV_PAR12    ->  Considera Sab.?Dom.?       1- Sim            2- Nao               ³
	//³ MV_PAR13    ->  Considera OPs Suspensas    1- Sim            2- Nao               ³
	//³ MV_PAR14    ->  Considera OPs Sacrament    1- Sim            2- Nao               ³
	//³ MV_PAR15    ->  Recalcula Niveis   ?       1- Sim            2- Nao               ³
	//³ MV_PAR16    ->  Gera OPs Aglutinadas       1- Sim            2- Nao               ³
	//³ MV_PAR17    ->  Pedidos de Venda Coloca    1- Subtrai        2- Nao Subtrai       ³
	//³ MV_PAR18    ->  Considera Sld Estoque      1- Atual          2- Calcest           ³
	//³ MV_PAR19    ->  Ao atingir Estoque Maximo? 1-Qtde. Original  2- Ajusta Est. Max   ³
	//³ MV_PAR20    ->  Qtd. nossa Poder 3         1- Soma           2- Ignora            ³
	//³ MV_PAR21    ->  Qtd. 3§ nosso Poder        1- Subtrai        2- Ignora            ³
	//³ MV_PAR22    ->  Saldo rejeitado pelo CQ    1-Subtrai         2- Nao Subtrai       ³
	//³ MV_PAR23    ->  PV/PMP De  Documento                                              ³
	//³ MV_PAR24    ->  PV/PMP Ate Documento                                              ³
	//³ MV_PAR25    ->  Saldo bloqueado            1-Subtrai         2- Nao Subtrai       ³
	//³ MV_PAR26    ->  Considera Est. Seguranca   1-Sim     2-Nao   3- So necessidade.   ³
	//³ MV_PAR27    ->  Ped. Venda Bloq. Credito?  1-Sim             2- Nao               ³
	//³ MV_PAR28    ->  Mostra dados resumidos  ?  1-Sim             2- Nao               ³
	//³ MV_PAR29    ->  Detalha lotes vencidos  ?  1-Sim             2- Nao               ³
	//³ MV_PAR30    ->  Pedidos de Venda Fatura    1- Subtrai        2- Nao Subtrai       ³
	//³ MV_PAR31    ->  Considera Ponto de Pedido  1- Sim            2- Nao               ³
	//³ MV_PAR32    ->  Gera tabela necessidades   1- Sim            2- Nao               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	// Ponto de entrada para alterar a parametrizacao inicial do MRP
	If ExistBlock("A710PAR")
		aRetPar:=ExecBlock("A710PAR",.F.,.F.,{nUsado,nQuantPer,a711Tipo,a711Grupo,lPedido})
		If Len(aRetPar[1]) == 5
			For i:=1 to Len(aRetPar[1])
				// Valida os valores numericos
				If i == 1
					If ValType(aRetPar[1][i]) # "N"
						lOkExec:=.F.
						Exit
					Else
						If aRetPar[1][i] < 1 .Or. aRetPar[1][i] > 7
							lOkExec:=.F.
							Exit
						EndIf
					EndIf
				// Valida os valores numericos
				ElseIf i == 2
					If ValType(aRetPar[1][i]) # "N"
						lOkExec:=.F.
						Exit
					EndIf
				// Valida os valores array
				ElseIf i == 3 .Or. i == 4
					// Valida o conteudo dos arrays
					If ValType(aRetPar[1][i]) == "A"
						For zz:=1 to Len(aRetPar[1][i])
							If ValType(aRetPar[1][i,zz,1]) # "L" .Or. ValType(aRetPar[1][i,zz,2]) # "C"
								lOkExec:=.F.
								Exit
							EndIf
						Next zz
					Else
						lOkExec:=.F.
						Exit
					EndIf
				// Valida o valor logico
				ElseIf i == 5 .And. ValType(aRetPar[1][i]) # "L"
					lOkExec:=.F.
					Exit
				EndIf
			Next i
			// Assume valores retornados pelo ponto de entrada
			If lOkExec
				nUsado   :=aRetPar[1][1]
				nQuantPer:=aRetPar[1][2]
				a711Tipo :=aRetPar[1][3]
				a711Grupo:=aRetPar[1][4]
				lPedido  :=aRetPar[1][5]
			EndIf
		EndIf
	EndIf

	If ! lBatch
		If lMT710TL
			ExecBlock("MT710TL",.F.,.F.)
		EndIf

		If lUsaNewPrc
			aAdd(aTreeProc,{OemToAnsi('STR0127'),{|oCenterPanel|A710MontPer(oCenterPanel)},"filtro1"})
			aAdd(aTreeProc,{OemToAnsi('STR0153'),{|oCenterPanel|A710MontVis(oCenterPanel,@lVisualiza)},"watch"})

			tNewProcess():New("MATA710",OemToAnsi('STR0001'),bBlNewProc,OemToAnsi('STR0124')+_NEWLINE+OemToAnsi(STR0125)+_NEWLINE+OemToAnsi(STR0126),"MTA712",aTreeProc)
		Else
			DEFINE MSDIALOG oDlg TITLE cCadastro From 145,0 To 445,628 OF oMainWnd PIXEL
			@ 10,15 TO 129,115 LABEL STR0002 OF oDlg  PIXEL //"Periodicidade do MRP"
			@ 25,20 RADIO oUsado VAR nUsado 3D SIZE 70,10 PROMPT  OemToAnsi(STR0003),;	//"Per¡odo Di rio"
				OemToAnsi(STR0004),;	//"Per¡odo Semanal"
				OemToAnsi(STR0005),;	//"Per¡odo Quinzenal"
				OemToAnsi(STR0006),;	//"Per¡odo Mensal"
				OemToAnsi(STR0007),;	//"Per¡odo Trimestral"
				OemToAnsi(STR0008),;	//"Per¡odo Semestral"
				OemToAnsi(STR0009) OF oDlg PIXEL	//"Per¡odos Diversos"
			@ 102,020 Say OemToAnsi(STR0010) SIZE 60,10 OF oDlg PIXEL	//"Quantidade de Per¡odos:"
			@ 102,085 MSGET nQuantPer Picture "999" Valid Positivo() .And. NaoVazio() SIZE 15,10 OF oDlg PIXEL
			@ 10,130 TO 129,300 LABEL "" OF oDlg PIXEL
			@ 16,135 CHECKBOX oChk  VAR lPedido PROMPT OemToAnsi(STR0011) SIZE 85, 10 OF oDlg PIXEL ;oChk:oFont := oDlg:oFont	//"Considera Pedidos em Carteira"
			@ 26,135 CHECKBOX oChk2 VAR lLogMRP PROMPT OemToAnsi(STR0068) SIZE 85, 10 OF oDlg PIXEL ;oChk2:oFont := oDlg:oFont	//"Log de eventos do MRP"
			@ 36,135 CHECKBOX oChkQual VAR lQual  PROMPT OemToAnsi(STR0061) SIZE 55, 10 OF oDlg PIXEL ON CLICK (AEval(a711Tipo , {|z| z[1] := If(z[1]==.T.,.F.,.T.)}), oQual:Refresh(.F.)) //"Inverter Selecao"
			@ 47,130 LISTBOX oQual VAR cVarQ Fields HEADER "",OemToAnsi(STR0012)  SIZE 78,081 ON DBLCLICK (A711Tipo:=CA711Troca(oQual:nAt,A711Tipo),oQual:Refresh()) ON RIGHT CLICK ListBoxAll(nRow,nCol,@oQual,oOk,oNo,@A711Tipo) NoScroll OF oDlg PIXEL	//"Tipos de Material"
			oQual:SetArray(A711Tipo)
			oQual:bLine := { || {If(A711Tipo[oQual:nAt,1],oOk,oNo),A711Tipo[oQual:nAt,2]}}
			@ 37,226 CHECKBOX oChkQual2 VAR lQual2 PROMPT OemToAnsi(STR0061) SIZE 55, 10 OF oDlg PIXEL ON CLICK (AEval(a711Grupo, {|z| z[1] := If(z[1]==.T.,.F.,.T.)}),oQual2:Refresh(.F.)) //"Inverter Selecao"
			@ 47,221 LISTBOX oQual2 VAR cVarQ2 Fields HEADER "",OemToAnsi(STR0013)  SIZE 78,081 ON DBLCLICK (A711Grupo:=CA711Troca(oQual2:nAt,A711Grupo),oQual2:Refresh()) ON RIGHT CLICK ListBoxAll(nRow,nCol,@oQual2,oOk,oNo,@A711Grupo) NoScroll OF oDlg  PIXEL	//"Grupos de Material"
			oQual2:SetArray(A711Grupo)
			oQual2:bLine := { || {If(A711Grupo[oQual2:nAt,1],oOk,oNo),A711Grupo[oQual2:nAt,2]}}
			DEFINE SBUTTON FROM 134,180 TYPE 5 ACTION (Pergunte("MTA712",.T.),A710FilAlm(.T.)) ENABLE OF oDlg
			DEFINE SBUTTON FROM 134,210 TYPE 15 ACTION (nOk:=1,oDlg:End(),lVisualiza:=.T.) ENABLE OF oDlg
			DEFINE SBUTTON FROM 134,240 TYPE 1 ACTION (MTA711OK(@nOK,A711Tipo,A711Grupo),IIf(nOk=1,oDlg:End(),)) ENABLE OF oDlg
			DEFINE SBUTTON FROM 134,270 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
			ACTIVATE MSDIALOG oDlg CENTERED
		EndIf
	Else
		nUsado    := aAuto[1]
		nQuantPer := aAuto[2]
		If ValType(aAuto[3]) == "L"
			lPedido   := aAuto[3]
		Endif
		If ValType(aAuto[4]) == "A"
			a711Tipo := aAuto[4]
		Endif
		If ValType(aAuto[5]) == "A"
			a711Grupo := aAuto[5]
		Endif
		If ValType(aAuto[7]) == "L"
			lLogMRP := aAuto[7]
		EndIf
		nOk := 1
	Endif

	If nOk = 1
		If !lBatch
			// Atualiza as coordenadas da Janela Principal
			oMainWnd:CoorsUpdate()
		EndIf
		If !lUsaNewPrc
           	U_xa710MCond(@cStrTipo,@cStrGrupo)
   			Processa({|| MTA711SH5(lPedido,lVisualiza,cStrTipo,cStrGrupo) })
		EndIf
	Endif
	DeleteObject(oOk)
	DeleteObject(oNo)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o log de processamento   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcLogAtu("FIM")
EndIf
dbSelectArea(cSavAlias)
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³MTA711OK  ³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 21/05/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Confirmacao antes de executar o MRP                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nOk       Variavel numerica com o retorno                  ³±±
±±³          ³ a711Tipo  Array com os tipos disponiveis para selecao      ³±±
±±³          ³ a711Grupo Array com os grupos disponiveis para selecao     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA710                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MTA711OK(nOK,A711Tipo,A711Grupo)
Local aButtons := {STR0183, STR0184, STR0185} //"Log Ativo","Log Inativo","Cancelar"
LOCAL nAcho1,nAcho2
Local nRet := 0
LOCAL lRet := .T.
nAcho1:=Ascan(A711Tipo,{|x| x[1] == .T.})
nAcho2:=Ascan(A711Grupo,{|x| x[1] == .T.})
If nAcho1 = 0 .Or. nAcho2 = 0
	Help(" ",1,"A711MENU")
	lRet := .F.
EndIf

If ExistBlock( "MTA710AP" )
   lRet := ExecBlock("MTA710AP",.F.,.F.)
   If ValType(lRet) <> "L"
     	lRet:=.T.
   EndIf
Endif

If lRet
	If ExistBlock("A710FIL")
		Aviso(OemToAnsi(STR0015),OemToAnsi(STR0066),{'Ok'}) //"A funcao de usuario A710FIL existe porem nao sera considerada em ambiente SQL. Deve ser utilizada sintaxe SQL atraves da funcao de usuario A710SQL."
	EndIf

	lRet := IIf(MsgYesNo(OemToAnsi(STR0014),OemToAnsi(STR0015)),nOk:=1,nOk:=2)	//"Confirma o MRP ?"###"Aten‡„o"
EndIf

If lLogMrp .And. lRet == 1
	nRet := Aviso(STR0015,STR0186,aButtons) //"O log de eventos está ativo e isto aumentará o tempo de processamento da rotina. Como deseja prosseguir?"
	If nRet == 2
		lLogMrp := .F.
	ElseIf nRet == 3
		nOk := 2
	Endif
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MTA711SH5 ³ Autor ³Rodrigo de A Sartorio  ³ Data ³ 21/05/02   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao que monta os arquivos de trabalho e dispara todo       ³±±
±±³          ³processo de montagem da interface com o usuario.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lPedido    Indica se considera pedidos de venda no MRP       ³±±
±±³          ³ lVisualiza Indica se esta utilizando visualizacao do MRP     ³±±
±±³          ³ cStrTipo  String com tipos a serem processados               ³±±
±±³          ³ cStrGrupo String com grupos a serem processados              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA710                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MTA711SH5(lPedido,lVisualiza,cStrTipo,cStrGrupo,oCenterPanel)
Local aAreaBack		:= {},aTam:={}
Local aStru			:= {},aStru2:={}
Local aOpc			:= {},aDados:={},aSaldos:={}
Local aListaJob 	:= {}
Local aParamJob		:= {}
Local aThreads      := {}
Local aJobAux       := {}
Local aTamQuant  	:= TamSX3("B2_QFIM")
Local lConsSabDom	:= aPergs711[12] == 1
Local lConsSusp  	:= aPergs711[13] == 1
Local lConsSacr  	:= aPergs711[14] == 1
Local lCalcNivelEstr:= aPergs711[15] == 1
Local lPedBloc      := aPergs711[27] == 1
Local lVoltaSaldo	:= .F.
Local cAliasTop  	:= ""
Local cDrvSH5    	:= "",cArquivo:="",cArquivo2:="",cTmp:=""
Local z:=0,nInd:=0,nz:=0,nx:=0
// Variaveis criadas para prever tamanho de campo com erro - NAO MEXER
Local nPosAno, nTamAno, cForAno
LOCAL nSaldo:=0,nEstSeg:=0,nQtdAviso:=0,cMsgAviso:="",nPontoPed:=0,nQtdPontP:=0,cMsgPontP:=""
Local dInicio := dDataBase,dDataPer:=dDataBase
Local oFont,oDlg,oFolder,oBmp,oMenu1,oMenu2
Local cComp1	:= CriaVar("C6_BLQ")
Local cComp2	:= "N"+Space(Len(cComp1)-1)
Local nY2T		:= If(__SetCentury(),2,0)
Local cPath		:= ""
Local aPages	:= {"HEADER","HEADER"}
Local aTitles	:= {STR0017,STR0031} //"Dados"###Legenda
Local nOldEnch	:= 1
Local bChange	:= {|| Nil }
Local aEnch[11]
Local nTop		:= If(lBatch,0,oMainWnd:nTop+23)
Local nLeft		:= If(lBatch,0,oMainWnd:nLeft+5)
Local nBottom	:= If(lBatch,0,oMainWnd:nBottom-60)
Local nRight	:= If(lBatch,0,oMainWnd:nRight-10)
Local cBotFun	:= '',cTopFun   := ''
Local cNumOpDig	:= Criavar("C2_NUM",.F.)
Local lAtvFilTmp:= .F.
Local lFlatMode	:= FlatMode()
Local aButtons	:= {}
Local aADDButtons:={}
Local cSeek		:= ""
Local lA710Fil	:= ExistBlock("A710FIL")
Local lA710SQL	:= ExistBlock("A710SQL")
Local lM710NOPC	:= ExistBlock("M710NOPC")
Local aPedidosAc:= {{}},nAchouPed:=0,nQuantPrev:=0,lFirstGrupo:=.T.
Local nPeriodos	:= aOpcoes[2][1]
Local nPerCalc	:= 0
Local nDias		:= 0, nMes  := 0 , nAno  := 0
Local nTamItem	:= 0 , aCamposIt:={"C1_ITEM","C2_ITEM","C3_ITEM","C6_ITEM","C7_ITEM"}
Local oSay2
Local oSay1
Local i			:= 0
Local nLoop		:= 0
Local cChaveSB6
Local cQuerySB6
Local lExistBB1	:= ExistBlock("A710FILALM")
Local lExistBB2	:= ExistBlock("MT710B2")
Local cRevisao	:= Nil
Local nRecSHA   :={}
Local cNivMRP   :=""
Local cQueryB1  :=""
Local nCountGrupo:=0
Local nRetry_0 := 0
Local nRetry_1 := 0
Local cOpc711Vaz:=CriaVar("C2_OPC",.F.)
Local cRev711Vaz:=CriaVar("B1_REVATU",.F.)
Local nAchouTot:=0
Local lParResu  := .F.
Local lConsPreRe:= SuperGetMV("MV_MRPSCRE",.F.,.T.) == .T.
Local lMRPCINQ	:= SuperGetMV("MV_MRPCINQ",.F.,.F.)
Local lInJob    := SuperGetMv('MV_A710THR',.F.,1) > 1
Local lSelOpc		:= SuperGetMv('MV_SELEOPC',.F.,'N')
Local lMT710EXP:=.T.
//Variaveis para semaforo
Local cFileJob := ""
Local cStartPath := GetSrvProfString("Startpath","")
Local nHandle    := 0
Local lLog008    := .T.
Local lLog009    := .T.
Local aNegEst    := {}
Local lThreads   := .F.                      

Local cTxtEstSeg := RetTitle("B1_ESTSEG")
Local cTxtPontPed :=RetTitle("B1_EMIN")
Local lAllGrp	 := Ascan(A711Grupo,{|x| x[1] == .F.}) == 0
Local lShAlt := If(ExistBlock("M710ShAlt"),execblock('M710SHAlt',.F.,.F.),.F.)
Local nPoLin := 0
Local aSize  	:= MsAdvSize()
Local nCol	    := aSize[5]
Local nLin		:= 0
Local cDadosProd:= Alltrim(SuperGetMV("MV_ARQPROD",.F.,"SB1"))  	// Projeto Implementeacao de campos MRP e FANTASM no SBZ
Local M710Niv	:= .F.
Local cIndexSHA	:= ""
Local mOpc := ""

DEFAULT lVisualiza	:= .F.
PRIVATE cAlmoxd		:= aPergs711[8],cAlmoxa:=aPergs711[9]
PRIVATE c711NumMRP	:= ""
PRIVATE cPictQuant	:= PesqPictQt("B2_QFIM",aTamQuant[1]+2)
PRIVATE aPeriodos	:= {},aDiversos:={}, aDbTree := {}
PRIVATE aTotais		:= {{}}
PRIVATE a711SvAlias	:= {}
PRIVATE oTreeM711,oPanelM711,oScrollM711
PRIVATE cSelPer		:= cSelPerSC:=""
PRIVATE cSelF   	:= cSelFSC  :=""
PRIVATE nTipo		:= 0

PRIVATE cIndSB6,nIndSB6

PRIVATE cMT710B2
PRIVATE cProdDetSld := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis de controle do filtro de tela                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cFilSB1Old	:= SB1->(DbFilter())
PRIVATE cFilNess	:= ""
PRIVATE lAtvFilNes	:= .F.

PRIVATE cPictLOCAL  := PesqPict("SB2","B2_LOCAL")
PRIVATE cPictQATU   := PesqPict("SB2","B2_QATU")
PRIVATE cPictQNPT   := PesqPict("SB2","B2_QNPT")
PRIVATE cPictQTNP   := PesqPict("SB2","B2_QTNP")
PRIVATE cPictQTDE   := PesqPict("SD7","D7_QTDE")
PRIVATE cPictSALDO  := PesqPict("SDD","DD_SALDO")

If ExistBlock( "MTA710CP" )
	lRet := .T.
	lRet := ExecBlock("MTA710CP",.F.,.F.)
	If ValType(lRet) <> "L"
 		lRet:=.T.
	EndIf
   
	if !lRet
		Return Nil
	endif
Endif    

If SuperGetMv('MV_A710THR',.F.,1) > 1
	lThreads := .T.
Endif

u_xA710GrvTm(oCenterPanel,STR0131) //"Inicio do Processamento."

If !lVisualiza .And. aPergs711[32] == 1
	A710ClrSHF()
EndIf

If UsaNewPrc()
	nLin := aSize[6]-55
Else
	nLin := aSize[6]
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao dos botoes da rotina³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aadd(aButtons,{'LOCALIZA'	,{|| (A711Pesq())},STR0033} ) //"Pesquisa Produto"
aadd(aButtons,{'RELATORIO'	,{|| (lAtvFilTmp := lAtvFilNes, If(lAtvFilTmp,M710FilNec(),.T.),MATR880(.T.),If(lAtvFilTmp,M710FilNec(),.T.))},STR0034} ) //"Imprime MRP"
aadd(aButtons,{'BMPTRG'   	,{|| (lAtvFilTmp := lAtvFilNes, If(lAtvFilTmp,M710FilNec(),.T.),A711Gera(@cNumOpDig,cStrTipo,cStrGrupo),If(lAtvFilTmp,M710FilNec(),.T.),Eval(bChange)) },STR0042} ) //"Geracao de OPs / SCs"

//-- Define tipo de consulta de produto
If aPergs711[28]==1 .And. !lBatch
	MENU oMenu2 POPUP
	MENUITEM STR0123 ACTION (A711ExpTree(),Eval(bChange)) //"Expande Detalhes"
	MENUITEM STR0064 ACTION ( A711ShPrd(),Eval(bChange) ) //"Dados do Produto"
	ENDMENU

	aadd(aButtons,{'VERNOTA'  , {|| If(lFlatMode,oMenu2:Activate(500,47,oDlg),oMenu2:Activate(220,30,oDlg)) },STR0064})
Else
	aadd(aButtons,{'VERNOTA'  ,{|| (A711ShPrd(),Eval(bChange)) },STR0064}) //"Dados do Produto"
EndIf
If lShAlt
	aadd(aButtons,{'SDUCOUNT' ,{|| A711ShAlt() },'Alternativos'})
EndIf
aadd(aButtons,{'FILTRO'	,{|| If(lFlatMode,oMenu1:Activate(nCol,nLin,oDlg),oMenu1:Activate(245,30,oDlg)) },STR0088,STR0091}) //"Mostra somente as necessidades" //'Filtro'
aadd(aButtons,{'FORM'	,{|| A710ViewSld(aFilAlmox) },STR0115}) //"Det.Saldo"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa ponto de entrada para montar array com botoes a      ³
//³ serem apresentados na tela                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (ExistBlock( "M710BUT" ) )
	aADDButtons:=ExecBlock("M710BUT",.F.,.F.)
	If ValType(aADDButtons) == "A"
		For i:=1 to Len(aADDButtons)
			AADD(aButtons,aADDButtons[i])
		Next i
	EndIf
Endif

// Caso gere o Log habilita o botao de consulta
If lLogMRP
	AADD(aButtons,{'DESTINOS' ,{|| (A711ShLog(),Eval(bChange))},STR0068,STR0092}) //"Log de eventos do MRP" //"Log"
EndIf


If !lVisualiza
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica os dados para montar/visualizar arquivos do MRP     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For i:= 1 to 7
		If aOpcoes[1][i] = "x"
			nTipo := i
		EndIf
	Next i

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta as datas de acordo com os parametros                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	A710AtuPeriodo(lVisualiza,@nTipo,@dInicio,@aPeriodos,aOpcoes,aStru2)

EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria os arquivos de trabalho do MRP | Aqui faz o lock     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !u_XA710OpenFMRP(lVisualiza,aStru,aStru2)
	Return Nil
EndIf
u_xA710GrvTm(oCenterPanel,STR0132) //"Termino da Abertura\Criacao dos Arquivos SHA/SH5"

If lVisualiza
	// Recupera parametrizacao gravada no ultimo processamento
	// A T E N C A O
	// Quando utilizado o processamento por periodos variaveis o sistema monta o array com
	// os periodos de maneira desordenada, por causa do indice do arquivo SH5
	// O array adiversos é corrigido logo abaixo
	dbSelectArea("SH5")
	dbSetOrder(2)
	dbSeek(xFilial("SH5")+"PAR")
	While SH5->H5_ALIAS == "PAR"
		nTipo       := SH5->H5_RECNO
		dInicio     := SH5->H5_DATAORI
		nPeriodos   := SH5->H5_QUANT
		aOpcoes[2,1]:= SH5->H5_QUANT
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o exibe os dados resumido de acordo com o ultimo calculo³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lParResu	:= AllTrim(SH5->H5_ITEM) == "1"
		If nTipo == 7
			AADD(aDiversos,CTOD(Alltrim(SH5->H5_OPC)))
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ NUMERO DO MRP                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		c711NumMRP:=SH5->H5_NUMMRP
		dbSkip()
	EndDo

	If !lParResu .And. !lInJob
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Adiciona registro em array totalizador utilizado no TREE  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SH5")
		dbSetOrder(1)
		dbGotop()
		While !Eof()
			If SH5->H5_ALIAS <> "PAR"
				If Len(aTotais[Len(aTotais)]) > 4095
					AADD(aTotais,{})
				EndIf
				For i:=1 to Len(aTotais)
					nAchouTot:=ASCAN(aTotais[i],{ |x| x[1] == SH5->(H5_PRODUTO+H5_OPC) .And. x[2] == SH5->H5_PER .And. x[3] == SH5->H5_ALIAS})
					If nAchouTot != 0
						aTotais[i,nAchouTot,4] += SH5->H5_QUANT
						Exit
					EndIf
				Next i
				If nAchouTot ==0
					AADD(aTotais[Len(aTotais)],{SH5->H5_PRODUTO+SH5->H5_OPC+SH5->H5_REVISAO,SH5->H5_PER,SH5->H5_ALIAS,SH5->H5_QUANT})
				EndIf
			EndIf
			dbSkip()
		End
	EndIf
	If nTipo == 7
		// Correcao do array adiversos
		// Ordena o array por ordem de data
		aDiversos:=ASORT(aDiversos)
		// Transforma data em caracter
		For i:=1 to Len(aDiversos)
			aDiversos[i]:=DTOC(aDiversos[i])
		Next i
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta as datas de acordo com os parametros                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	A710AtuPeriodo(lVisualiza,@nTipo,@dInicio,@aPeriodos,aOpcoes,aStru2)
	u_xA710GrvTm(oCenterPanel,STR0133) //"Termino da montagem das datas de acordo com os parametros."

Else
	If (oCenterPanel <> Nil)
		oCenterPanel:SetRegua2(7)//oito processamentos
	EndIf
	// Grava as informacoes do processamento no arquivo SH5 colocando informacoes
	// que garantam que o registro nao ira aparecer
	// Alias PAR                                -> H5_ALIAS
	// Tipo utilizado                           -> H5_RECNO
	// Data inicial                             -> H5_DATAORI
	// Numero de periodos                       -> H5_QUANT
	// Para periodos variaveis data em caracter -> H5_OPC
	// Opca Resumido ("1" Sim / "2" Nao)        -> H5_ITEM
	If nTipo != 7
		u_XA711CriSH5(aPeriodos[1],"","","","PAR",nTipo,"",Alltrim(Str(aPergs711[28])),"",nPeriodos,"1",.F.,nil,nil,.F.,nil,nil,nil,nil,cStrTipo,cStrGrupo)
	Else
		For i:=1 to Len(aDiversos)
			u_XA711CriSH5(dDatabase,"",aDiversos[i],"","PAR",nTipo,"",Alltrim(Str(aPergs711[28])),"",Len(aPeriodos),"1",.F.,aPergs711[28]==1,nil,.F.,nil,nil,nil,nil,cStrTipo,cStrGrupo)
		Next
	EndIf
	u_xA710GrvTm(oCenterPanel,STR0134) //"Termino da Montagem do Arquivo de Trabalho."
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Apaga OPs/SCs/AEs previstas                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aPergs711[11] == 1
		Processa({|lEnd| MTApagaPre(,,,,,oCenterPanel,.T.)})
		u_xA710GrvTm(oCenterPanel,STR0135) //"Termino da delecao das OPs e SCs Previstas."
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza Niveis das Estruturas               ³
	//³ Eh bom lembrar que o parametro MV_NIVALT eh  ³
	//³ usado em outras rotinas do sistema.          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ExistBlock ("M710NIV")
		M710Niv := ExecBlock("M710NIV",.F.,.F.)
		If ValType(M710NIV) != "L"
			M710Niv := .F.
		EndIf
	EndIf	
	
	If M710Niv .Or. (GetMV("MV_NIVALT") == "S"  .and. lCalcNivelEstr)
		MA320Nivel(Nil,.t.,.f.)
		u_xA710GrvTm(oCenterPanel,STR0136) //"Termino do Recalculo dos Niveis das Estruturas."
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  Monta Saldo Inicial por MULT-THREAD         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lThreads

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o log de processamento			    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ProcLogAtu("MENSAGEM","Iniciando Montagem do Saldo Inicial","Iniciando Montagem do Saldo Inicial")

		//-- Calcula Quebra por Threads
		aThreads := A710QtdThread(.F.,@cQueryB1,cStrGrupo)
		ProcRegua(((Len(aThreads)*2) + 8))

		For nX:=1 to Len(aThreads)

			IncProc()

			// Informacoes do semaforo
			cJobFile:= cStartPath + CriaTrab(Nil,.F.)+".job"

			// Adiciona o nome do arquivo de Job no array aJobAux
			aAdd(aJobAux,{StrZero(nX,2),cJobFile})

			// Inicializa variavel global de controle de thread
			cJobAux:="c710P"+cEmpAnt+cFilAnt+StrZero(nX,2)
			PutGlbValue(cJobAux,"0")
			GlbUnLock()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza o log de processamento			    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			ProcLogAtu("MENSAGEM","Iniciando Montagem do Saldo Inicial - Thread:" + StrZero(nX,2),"Iniciando Montagem do Saldo Inicial - Thread:" + StrZero(nX,2))

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Dispara thread para Stored Procedure        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			StartJob("U_XA710JOBINI",GetEnvServer(),.F.,cEmpAnt,cFilAnt,aThreads[nX,1],cJobFile,StrZero(nX,2),cPath,aPeriodos,aPergs711,c711NumMrp,cStrTipo,cStrGrupo,cTxtEstSeg,cRev711Vaz,lExistBB1,lExistBB2,lM710NOPC,lLogMRP,{cPictLOCAL,cPictQATU,cPictQNPT,cPictQTNP,cPictQTDE,cPictSALDO},nTipo,cTxtPontPed,aAlmoxNNR,lSelOpc)
		Next nX

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Controle de Seguranca para MULTI-THREAD                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nX:=1 to Len(aThreads)

			nPos := ASCAN(aJobAux,{|x| x[1] == StrZero(nX,2)})

			// Informacoes do semaforo
			cJobFile:= aJobAux[nPos,2]

			// Inicializa variavel global de controle de thread
			cJobAux:="c710P"+cEmpAnt+cFilAnt+StrZero(nX,2)

			While .T.
				Do Case
					// TRATAMENTO PARA ERRO DE SUBIDA DE THREAD
					Case GetGlbValue(cJobAux) == '0'
						If nRetry_0 > 50
//							Conout(Replicate("-",65))				  												 	//"-----------------------------------------------------"
//							Conout("MATA710: "+ "Não foi possivel realizar a subida da thread" + " " + StrZero(nX,2) )	//"MATA710: Não foi possivel realizar a subida da thread"
  //							Conout(Replicate("-",65))  																	//"-----------------------------------------------------"
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Atualiza o log de processamento			    ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							ProcLogAtu("MENSAGEM","Não foi possivel realizar a subida da thread","Não foi possivel realizar a subida da thread")	//"Não foi possivel realizar a subida da thread"
							Final("Não foi possivel realizar a subida da thread") 						  											//"Não foi possivel realizar a subida da thread"
						Else
							nRetry_0 ++
						EndIf
					// TRATAMENTO PARA ERRO DE CONEXAO
					Case GetGlbValue(cJobAux) == '1'
						If FCreate(cJobFile) # -1
							If nRetry_1 > 5
//								Conout(Replicate("-",65)) 						//"------------------------------------------------"
  //								Conout("MATA710: Erro de conexao na thread") 	//"MATA710: Erro de conexao na thread"
	 //							Conout("Thread numero : " + StrZero(nX,2) )		//"Thread numero : "
//								Conout("Numero de tentativas excedidas")		//"Numero de tentativas excedidas"
  //								Conout(Replicate("-",65))  						//"------------------------------------------------"
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Atualiza o log de processamento			    ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								ProcLogAtu("MENSAGEM","MATA710: Erro de conexao na thread","MATA710: Erro de conexao na thread")	//"MATA710: Erro de conexao na thread"
								Final("MATA710: Erro de conexao na thread")										   					//"MATA710: Erro de conexao na thread"
							Else
				    			// Inicializa variavel global de controle de Job
								PutGlbValue(cJobAux, "0" )
								GlbUnLock()
								// Reiniciar thread
//								Conout(Replicate("-",65))				 				//"------------------------------------------------"
  //								Conout("MATA710: Erro de conexao na thread") 			//"MATA710: Erro de conexao na thread"
	 //							Conout("Tentativa numero: "		+StrZero(nRetry_1,2))	//"Tentativa numero: "
		//						Conout("Reiniciando a thread : "+StrZero(nX,2))			//"Reiniciando a thread : "
		  //						Conout(Replicate("-",65))                 				//"------------------------------------------------"
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Atualiza o log de processamento			    ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								ProcLogAtu("MENSAGEM","Reiniciando a thread : "+StrZero(nX,2),"Reiniciando a thread : "+StrZero(nX,2))	//"Reiniciando a thread : "
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Dispara thread para Stored Procedure        ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								StartJob("U_XA710JOBINI",GetEnvServer(),.F.,cEmpAnt,cFilAnt,aThreads[nX],cJobFile,StrZero(nX,2),cPath,aPeriodos,aPergs711,c711NumMrp,cStrTipo,cStrGrupo,cTxtEstSeg,cRev711Vaz,lExistBB1,lExistBB2,lM710NOPC,lLogMRP,{cPictLOCAL,cPictQATU,cPictQNPT,cPictQTNP,cPictQTDE,cPictSALDO},nTipo,cTxtPontPed,aAlmoxNNR)
							EndIf
							nRetry_1 ++
						EndIf
					// TRATAMENTO PARA ERRO DE APLICACAO
					Case GetGlbValue(cJobAux) == '2'
						If FCreate(cJobFile) # -1
			 //				Conout(Replicate("-",65))										//"-------------------------------------------------"
				//			Conout("MATA710: Erro de aplicacao na thread ")					//"MATA710: Erro de aplicacao na thread"
				  //			Conout("Thread numero : "+StrZero(nX,2))						//"Thread numero : "
					 //		Conout(Replicate("-",65))  										//"--------------------------------------------------"
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Atualiza o log de processamento			    ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							ProcLogAtu("MENSAGEM","MATA710: Erro de aplicacao na thread","MATA710: Erro de aplicacao na thread")	//"MATA710: Erro de aplicacao na thread"
							Final("MATA710: Erro de aplicacao na thread") 						   									//"MATA710: Erro de aplicacao na thread"
						EndIf
					// THREAD PROCESSADA CORRETAMENTE
					Case GetGlbValue(cJobAux) == '3'
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Atualiza o log de processamento			    ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						ProcLogAtu("MENSAGEM","Termino da Montagem do Saldo Inicial - Thread:" + StrZero(nX,2),"Termino da Montagem do Saldo Inicial - Thread:" + StrZero(nX,2))
						IncProc()
						Exit
				EndCase
				Sleep(2500)
			End
		Next nX

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o log de processamento			    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ProcLogAtu("MENSAGEM","Termino Montagem do Saldo Inicial","Termino Montagem do Saldo Inicial")

	Else

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³  Monta Saldo Inicial                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SB1")

	    If (oCenterPanel==Nil)
			ProcRegua(LastRec())
		Else
			oCenterPanel:SetRegua1(SB1->(LastRec()))
		EndIf

		aAreaBack:=GetArea()
		cAliasTop := "SB1"
		
		cAliasTop := GetNextAlias()
		// Projeto Implementeacao de campos MRP e FANTASM no SBZ
		If cDadosProd == "SBZ"
			cQuery := "SELECT B1_FILIAL,B1_COD, "
			cQuery += "       ISNULL(BZ_FANTASM,B1_FANTASM) B1_FANTASM, "
			cQuery += "       ISNULL(BZ_MRP,B1_MRP)         B1_MRP,     "
			cQuery += "       B1_TIPO,B1_GRUPO,B1_REVATU,B1_OPC, SB1.R_E_C_N_O_ B1REC FROM "+RetSqlName("SB1")+" SB1 "
			cQuery += " Left Outer Join "+RetSqlName("SBZ")+" SBZ "
			cQuery += " ON BZ_FILIAL = '"+xFilial("SBZ")+"' AND BZ_COD = B1_COD AND SBZ.D_E_L_E_T_ = ' ' WHERE "

			cQueryX1 := "      SB1.B1_FILIAL='"+xFilial("SB1")+"' "
			cQueryX1 += "  AND ISNULL( BZ_FANTASM, B1_FANTASM ) <>'S' "
			cQueryX1 += "  AND ISNULL( BZ_MRP,     B1_MRP     ) IN (' ','S') "
			cQueryX1 += "  AND SB1.D_E_L_E_T_ = ' ' "

			cQueryB1 := "      SB1.B1_FILIAL='"+xFilial("SB1")+"' "
			cQueryB1 += "  AND SB1.B1_FANTASM <>'S' AND SB1.D_E_L_E_T_=' ' AND SB1.B1_MRP IN (' ','S')"
		Else
			cQuery := "SELECT B1_FILIAL,B1_COD,B1_FANTASM,B1_MRP,B1_TIPO,B1_GRUPO,B1_REVATU,B1_OPC, SB1.R_E_C_N_O_ B1REC "
			cQuery += "  FROM "+RetSqlName("SB1")+" SB1 WHERE "

			cQueryX1:= " SB1.B1_FILIAL='"+xFilial("SB1") +"' AND "
			cQueryX1+= " SB1.B1_FANTASM <>'S' AND SB1.D_E_L_E_T_=' ' AND SB1.B1_MRP IN (' ','S')"

			cQueryB1:= " SB1.B1_FILIAL='"+xFilial("SB1")+"' AND "
			cQueryB1+= " SB1.B1_FANTASM <>'S' AND SB1.D_E_L_E_T_=' ' AND SB1.B1_MRP IN (' ','S')"
		Endif


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Coloca TIPOS selecionados na QUERY           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQueryX1+= " AND SB1.B1_TIPO IN ('"+Criavar("B1_TIPO",.F.)+"'"
		cQueryB1+= " AND SB1.B1_TIPO IN ('"+Criavar("B1_TIPO",.F.)+"'"
		FOR i:=1 TO LEN(A711Tipo)
			If A711Tipo[i,1]
				cQueryX1+= ",'"+SubStr(A711Tipo[i,2],1,nTamTipo711)+"'"
				cQueryB1+= ",'"+SubStr(A711Tipo[i,2],1,nTamTipo711)+"'"
			EndIf
		Next i
		cQueryX1+= ") "
		cQueryB1+= ") "

		// Otimiza query caso selecione todos os grupos ou inclui na query clausula IN com os grupos
		If !lAllGrp .And. lMRPCINQ
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Coloca GRUPOS selecionados na QUERY          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cQueryX1+= "AND (SB1.B1_GRUPO IN ("
			cQueryB1+= "AND (SB1.B1_GRUPO IN ("
			FOR i:=1 TO LEN(A711Grupo)
				If A711Grupo[i,1]
					nCountGrupo++
					// Checagem para inserir na clausula IN somente 1000 grupos por vez
					// ERRO NO BANCO ORACLE caso utilize mais de 1000 argumentos numa clausula IN
					If nCountGrupo <= 1000
						If !lFirstGrupo
							cQueryX1+= ","
							cQueryB1+= ","
						Else
							lFirstGrupo:=.F.
						EndIf
					Else
				 		nCountGrupo:=1
						cQueryX1+= ") OR SB1.B1_GRUPO IN ("
						cQueryB1+= ") OR SB1.B1_GRUPO IN ("
					EndIF
					cQueryX1+= "'"+SubStr(A711Grupo[i,2],1,nTamGr711)+"'"
					cQueryB1+= "'"+SubStr(A711Grupo[i,2],1,nTamGr711)+"'"
				EndIf
			Next i
			cQueryX1+= ")) "
			cQueryB1+= ")) "
		EndIf

		cQuery:= ChangeQuery(cQuery + cQueryX1)

		cQueryB1 := "AND "+cQueryB1

		If lA710SQL
			cA710Fil := ExecBlock("A710SQL", .F., .F., {"SB1", cQuery})
			If ValType(cA710Fil) == "C"
				cQuery := cA710Fil
			Endif
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)
		aEval(SB1->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField(cAliasTop,x[1],x[2],x[3],x[4]),Nil)})

		u_xA710GrvTm(oCenterPanel,STR0137) //"Termino do Filtro no Arquivo SB1."

		dbSelectArea(cAliasTop)
		If !Eof()
			While !Eof() 
				If (oCenterPanel==Nil)
					IncProc()
				Else
					oCenterPanel:IncRegua1(OemToAnsi(STR0128))
				EndIf
				// Avalia se o produto deve ser considerado
				// Projeto Implementeacao de campos MRP e FANTASM no SBZ
				If !lAllGrp .And. !lMRPCINQ .And. !(cAliasTop)->B1_GRUPO $ cStrGrupo
					dbSkip()
					Loop
				EndIf

				aFilAlmox := u_XRetExecBlock("A710FILALM", { (cAliasTop)->B1_COD, cAlmoxd, cAlmoxa }, "A", Nil,NIL,NIL,lExistBB1)
				cMT710B2  := u_XRetExecBlock("MT710B2"   , { (cAliasTop)->B1_COD, cAlmoxd, cAlmoxa }, "C", Nil,NIL,NIL,lExistBB2)

				If ValType(aFilAlmox) == "A" .And. aScan(aFilAlmox, {|z| ValType(z) # "C"}) > 0
					aFilAlmox := Nil
				Endif

				// Inicializa variaveis de saldo, estoque de seguranca e ponto de pedido
				nSaldo:=0
				nEstSeg:= 0

				// Obtem saldo, estoque de seguranca
				A710DSaldo((cAliasTop)->B1_COD,@nSaldo,@aFilAlmox,nil,nil,@nEstSeg)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Ponto de Entrada MA710NOPC para indicar saldo por  ³
				//³ opcional                                           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lM710NOPC
					aOpc := ExecBlock('M710NOPC',.F.,.F.,{(cAliasTop)->B1_COD,nSaldo})
					If ValType(aOpc) == 'A'
						For nz:=1 to Len(aOpc)
							// Avalia o LOG do MRP para o evento 001 - Saldo em estoque inicial menor que zero
							u_XA710CriaLOG("001",(cAliasTop)->B1_COD,{aOPc[nz,2]},lLogMRP,c711NumMrp)
							cRevisao := If(A710TrataRev() .And. Len(aOpc[nz]) >= 3, aOpc[nz, 3], cRev711Vaz)
							A711CriSHA((cAliasTop)->B1_COD,aOPc[nz,1],cRevisao,"","001",aOPc[nz,2],"1",cAliasTop,nil,cStrTipo,cStrGrupo)
						Next nz
					Else
						// Avalia o LOG do MRP para o evento 001 - Saldo em estoque inicial menor que zero
						u_XA710CriaLOG("001",(cAliasTop)->B1_COD,{nSaldo},lLogMRP,c711NumMrp)
						A711CriSHA((cAliasTop)->B1_COD,IIF(lSelOpc == 'S',RetFldProd((cAliasTop)->B1_COD,"B1_OPC",cAliasTop),CriaVar("B1_OPC")),cRev711Vaz,"","001",nSaldo,"1",cAliasTop,nil,cStrTipo,cStrGrupo)
					EndIf
				Else
					// Avalia o LOG do MRP para o evento 001 - Saldo em estoque inicial menor que zero
					u_XA710CriaLOG("001",(cAliasTop)->B1_COD,{nSaldo},lLogMRP,c711NumMrp)
					A711CriSHA((cAliasTop)->B1_COD,IIF(lSelOpc == 'S',RetFldProd((cAliasTop)->B1_COD,"B1_OPC",cAliasTop),CriaVar("B1_OPC")),cRev711Vaz,"","001",nSaldo,"1",cAliasTop,nil,cStrTipo,cStrGrupo)
				EndIf

				If aPergs711[26] == 3
					SB1->(dbGoTo((cAliasTop)->B1REC))

					nEstSeg := CalcEstSeg( RetFldProd(SB1->B1_COD,"B1_ESTFOR") )
				EndIf

				If aPergs711[31] == 1
					SB1->(dbGoTo((cAliasTop)->B1REC))

					nPontoPed := RetFldProd(SB1->B1_COD,"B1_EMIN")
				EndIf

				// Checa informacoes para inclusao no tree
				nQtdAviso:=0
				cMsgAviso:=""
				// Caso o estoque de seguranca esteja preenchido
				If QtdComp(nEstSeg,.T.) > QtdComp(0,.T.)
					nQtdAviso:=nEstSeg
					cMsgAviso:=RetTitle("B1_ESTSEG")
				Else
					// Posiciona na necessidade
					If !lUsaMOpc
						SHA->(dbSeek(xFilial("SHA")+(cAliasTop)->(B1_COD+RetFldProd((cAliasTop)->B1_COD,"B1_OPC",cAliasTop)+B1_REVATU+"6")))
					Else
						MOpcSeek("SHA",1,,(cAliasTop)->(B1_COD),,RetFldProd((cAliasTop)->B1_COD,"B1_OPC",cAliasTop),(cAliasTop)->B1_REVATU,"6")						
					EndIf
					// Caso tenha necessidade
					If QtdComp(SHA->HA_PER001,.T.) > QtdComp(0,.T.)
						nQtdAviso:=SHA->HA_PER001
						cMsgAviso:=STR0085 //"Nec. Ant."
					Endif
				EndIf

				// Checa informacoes para inclusao no tree
				nQtdPontP:=0
				cMsgPontP:=""
				// Caso o ponto de pedido esteja preenchido
				If QtdComp(nPontoPed,.T.) > QtdComp(0,.T.)
					nQtdPontP:=nPontoPed
					cMsgPontP:=RetTitle("B1_EMIN")
				Else
					If !lUsaMOpc
						// Posiciona na necessidade
						SHA->(dbSeek(xFilial("SHA")+((cAliasTop)->B1_COD+RetFldProd((cAliasTop)->B1_COD,"B1_OPC",cAliasTop)+(cAliasTop)->B1_REVATU+"6")))
					Else
						MOpcSeek("SHA",1,,(cAliasTop)->(B1_COD),,RetFldProd((cAliasTop)->B1_COD,"B1_OPC",cAliasTop),(cAliasTop)->B1_REVATU,"6")						
					EndIf
					// Caso tenha necessidade
					If QtdComp(SHA->HA_PER001,.T.) > QtdComp(0,.T.)
						nQtdPontP:=SHA->HA_PER001
						cMsgPontP:=STR0085 //"Nec. Ant."
					Endif
				EndIf

				// 	Monta no tree
				If QtdComp(nQtdAviso,.T.) > QtdComp(0,.T.)
					u_XA711CriSH5(aPeriodos[1],(cAliasTop)->B1_COD,RetFldProd((cAliasTop)->B1_COD,"B1_OPC",cAliasTop),(cAliasTop)->B1_REVATU,"SB1",(cAliasTop)->B1REC,cMsgAviso,"","",nQtdAviso,"",.F.,.F., cAliasTop,.f.,nil,nil,nil,nil,cStrTipo,cStrGrupo)
				EndIf

					// 	Monta no tree
				If QtdComp(nQtdPontP,.T.) > QtdComp(0,.T.)
					u_XA711CriSH5(aPeriodos[1],(cAliasTop)->B1_COD,RetFldProd((cAliasTop)->B1_COD,"B1_OPC",cAliasTop),(cAliasTop)->B1_REVATU,"SB1",(cAliasTop)->B1REC,cMsgPontP,"","",nQtdPontP,"",.F.,.F., cAliasTop,.f.,nil,nil,nil,nil,cStrTipo,cStrGrupo)
				EndIf

				dbSelectArea(cAliasTop)
				dbSkip()
			End
		End
		If (oCenterPanel<>Nil)
			oCenterPanel:IncRegua2()
		EndIf

		dbSelectArea(cAliasTop)
		dbCloseArea()
		dbSelectArea("SB1")
		
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³      Monta Solicitacoes de Compra            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SC1")
	cAliasTop := "SC1"
	cAliasTop := CriaTrab(NIL,.f.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o log de processamento			    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcLogAtu("MENSAGEM","Iniciando Processamento SC1","Iniciando Processamento SC1")
	// Inicializa variavel global de controle de thread
	PutGlbValue("U_XA710JobC1","0")
	GlbUnLock()
	// Parametros para o Job
	aParamJob:={c711NumMRP,nTipo,aPeriodos,aPergs711,cStrTipo,cStrGrupo,.T.,cAliasTop,cAlmoxd,cAlmoxa,cQueryB1,lA710Sql,lA710Fil,cOpc711Vaz,cRev711Vaz,lLogMrp,lConsPreRe,A711Grupo,lMRPCINQ}
	// Array com jobs inicializados
	cFileJob:=cStartPath+CriaTrab(,.F.)+".job"
	FErase(cFileJob) //para seguranca, apaga se existir
	AADD(aListaJob,{"U_XA710JobC1",aParamJob,Seconds(),cFileJob})
	// Processa thread
	StartJob("U_XA710JobC1",GetEnvServer(),.F.,cEmpAnt,cFilAnt,aParamJob,nRetry_1,cFileJob)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³      Monta Pedidos de Compra                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SC7")
	cAliasTop := "SC7"
	cAliasTop := CriaTrab(NIL,.f.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o log de processamento			    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcLogAtu("MENSAGEM","Iniciando Processamento SC7","Iniciando Processamento SC7")
	// Inicializa variavel global de controle de thread
	PutGlbValue("U_XA710JobC7","0")
	GlbUnLock()
	// Parametros para o Job
	aParamJob:={c711NumMRP,nTipo,aPeriodos,aPergs711,cStrTipo,cStrGrupo,.T.,cAliasTop,cAlmoxd,cAlmoxa,cQueryB1,lA710Sql,lA710Fil,cOpc711Vaz,cRev711Vaz,lLogMRP,A711Grupo,lMRPCINQ}
	// Array com jobs inicializados
	cFileJob:=cStartPath+CriaTrab(,.F.)+".job"
	FErase(cFileJob) //para seguranca, apaga se existir
	AADD(aListaJob,{"U_XA710JobC7",aParamJob,Seconds(),cFileJob})
	// Processa thread
	StartJob("U_XA710JobC7",GetEnvServer(),.F.,cEmpAnt,cFilAnt,aParamJob,nRetry_1,cFileJob)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³      Monta Ordens de Producao                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SC2")
	cAliasTop := "SC2"
	cAliasTop := CriaTrab(NIL,.f.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o log de processamento			    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcLogAtu("MENSAGEM","Iniciando Processamento SC2","Iniciando Processamento SC2")
	// Inicializa variavel global de controle de thread
	PutGlbValue("U_XA710JobC2","0")
	GlbUnLock()
	// Parametros para o Job
	aParamJob:={c711NumMRP,nTipo,aPeriodos,cStrTipo,cStrGrupo,.T.,cAliasTop,cAlmoxd,cAlmoxa,cQueryB1,lA710Sql,lA710Fil,lConsSusp,lConsSacr,lLogMRP,aPergs711,A711Grupo,lMRPCINQ}
	// Array com jobs inicializados
	cFileJob:=cStartPath+CriaTrab(,.F.)+".job"
	FErase(cFileJob) //para seguranca, apaga se existir
	AADD(aListaJob,{"U_XA710JobC2",aParamJob,Seconds(),cFileJob})
	// Processa thread
	StartJob("U_XA710JobC2",GetEnvServer(),.F.,cEmpAnt,cFilAnt,aParamJob,nRetry_1,cFileJob,lUsaMOpc)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  Monta Empenhos                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SD4")
	cAliasTop := "SD4"
	cAliasTop := CriaTrab(NIL,.f.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o log de processamento			    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcLogAtu("MENSAGEM","Iniciando Processamento SD4","Iniciando Processamento SD4")
	// Inicializa variavel global de controle de thread
	PutGlbValue("U_XA710JobD4","0")
	GlbUnLock()
	// Parametros para o Job
	aParamJob:={c711NumMRP,nTipo,aPeriodos,aPergs711,cStrTipo,cStrGrupo,.T.,cAliasTop,cAlmoxd,cAlmoxa,cQueryB1,lA710Sql,lA710Fil,cOpc711Vaz,cRev711Vaz,lLogMRP,A711Grupo,lMRPCINQ}
	// Array com jobs inicializados
	cFileJob:=cStartPath+CriaTrab(,.F.)+".job"
	FErase(cFileJob) //para seguranca, apaga se existir
	AADD(aListaJob,{"U_XA710JobD4",aParamJob,Seconds(),cFileJob})
	// Processa thread
	StartJob("U_XA710JobD4",GetEnvServer(),.F.,cEmpAnt,cFilAnt,aParamJob,nRetry_1,cFileJob)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  Monta Pedidos de Venda                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lPedido .Or. aPergs711[30] == 1
		dbSelectArea("SC6")
		cAliasTop := "SC6"
		cAliasTop := CriaTrab(NIL,.f.)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o log de processamento			    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ProcLogAtu("MENSAGEM","Iniciando Processamento SC6","Iniciando Processamento SC6")
		// Inicializa variavel global de controle de thread
		PutGlbValue("U_XA710JobC6","0")
		GlbUnLock()
		// Parametros para o Job
		aParamJob:={c711NumMRP,nTipo,aPeriodos,aPergs711,cStrTipo,cStrGrupo,.T.,cAliasTop,cAlmoxd,cAlmoxa,cQueryB1,lA710Sql,lA710Fil,lPedBloc,cComp1,cComp2,aPergs711[1] == 1 .And. (aPergs711[17] == 1 .Or. aPergs711[30] == 1),cRev711Vaz,lLogMRP,lPedido,A711Grupo,lMRPCINQ}
		// Array com jobs inicializados
		cFileJob:=cStartPath+CriaTrab(,.F.)+".job"
		FErase(cFileJob) //para seguranca, apaga se existir
		AADD(aListaJob,{"U_XA710JobC6",aParamJob,Seconds(),cFileJob})
		// Processa thread
		StartJob("U_XA710JobC6",GetEnvServer(),.F.,cEmpAnt,cFilAnt,aParamJob,nRetry_1,cFileJob,lUsaMOpc)
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³   Monta Empenhos para projetos               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("AFJ")
	cAliasTop := "AFJ"
	cAliasTop := CriaTrab(NIL,.f.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o log de processamento			    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcLogAtu("MENSAGEM","Iniciando Processamento AFJ","Iniciando Processamento AFJ")
	// Inicializa variavel global de controle de thread
	PutGlbValue("U_XA710JobAFJ","0")
	GlbUnLock()
	// Parametros para o Job
	aParamJob:={c711NumMRP,nTipo,aPeriodos,cStrTipo,cStrGrupo,.T.,cAliasTop,cQueryB1,lA710Sql,lA710Fil,cOpc711Vaz,cRev711Vaz,lLogMRP,aPergs711,A711Grupo,lMRPCINQ}
	// Array com jobs inicializados
	cFileJob:=cStartPath+CriaTrab(,.F.)+".job"
	FErase(cFileJob) //para seguranca, apaga se existir
	AADD(aListaJob,{"U_XA710JobAFJ",aParamJob,Seconds(),cFileJob})
	// Processa thread
	StartJob("U_XA710JobAFJ",GetEnvServer(),.F.,cEmpAnt,cFilAnt,aParamJob,nRetry_1,cFileJob)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  Monta Previsoes de Venda                    ³
	//³  So processa caso nao tenha processado junto ³
	//³  dos pedidos de venda.                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aPergs711[1] == 1 .And. aPergs711[30] == 2 .And. !(lPedido .And. aPergs711[17] == 1)
		dbSelectArea("SC4")
		cAliasTop := "SC4"
		cAliasTop := CriaTrab(NIL,.f.)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o log de processamento			    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ProcLogAtu("MENSAGEM","Iniciando Processamento SC4","Iniciando Processamento SC4")
		// Inicializa variavel global de controle de thread
		PutGlbValue("U_XA710JobC4","0")
		GlbUnLock()
		// Parametros para o Job
		aParamJob:={c711NumMRP,nTipo,aPeriodos,cStrTipo,cStrGrupo,.T.,cAliasTop,cAlmoxd,cAlmoxa,cQueryB1,ACLONE(aPergs711),.T.,{{}},cRev711Vaz,A711Grupo,lMRPCINQ,lA710Sql}
		// Array com jobs inicializados
		cFileJob:=cStartPath+CriaTrab(,.F.)+".job"
		FErase(cFileJob) //para seguranca, apaga se existir
		AADD(aListaJob,{"U_XA710JobC4",aParamJob,Seconds(),cFileJob})
		// Processa thread
		StartJob("U_XA710JobC4",GetEnvServer(),.F.,cEmpAnt,cFilAnt,aParamJob,nRetry_1,cFileJob,lUsaMOpc)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³  Monta Plano Mestre de Producao              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ElseIf aPergs711[1] == 2
		dbSelectArea("SHC")
		cAliasTop := "SHC"
		cAliasTop := CriaTrab(NIL,.f.)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o log de processamento			    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ProcLogAtu("MENSAGEM","Iniciando Processamento SHC","Iniciando Processamento SHC")
		// Inicializa variavel global de controle de thread
		PutGlbValue("U_XA710JobHC","0")
		GlbUnLock()
		// Parametros para o Job
		aParamJob:={c711NumMRP,nTipo,aPeriodos,cStrTipo,cStrGrupo,.T.,cAliasTop,cQueryB1,ACLONE(aPergs711),cRev711Vaz,A711Grupo,lMRPCINQ}
		// Array com jobs inicializados
		cFileJob:=cStartPath+CriaTrab(,.F.)+".job"
		FErase(cFileJob) //para seguranca, apaga se existir
		AADD(aListaJob,{"U_XA710JobHC",aParamJob,Seconds(),cFileJob})
		// Processa thread
		StartJob("U_XA710JobHC",GetEnvServer(),.F.,cEmpAnt,cFilAnt,aParamJob,nRetry_1,cFileJob,lUsaMOpc)
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  Monta Lotes Vencidos                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aPergs711[29] == 1
		dbSelectArea("SB8")
		cAliasTop := "SB8"
		cAliasTop := CriaTrab(NIL,.f.)

		// Inicializa variavel global de controle de thread
		PutGlbValue("U_XA710JobB8","0")
		GlbUnLock()
		// Parametros para o Job
		aParamJob:={c711NumMRP,nTipo,aPeriodos,cStrTipo,cStrGrupo,.T.,cAliasTop,cQueryB1,ACLONE(aPergs711),cRev711Vaz,aFilAlmox,cMT710B2,A711Grupo,lMRPCINQ,aAlmoxNNR}
		// Array com jobs inicializados
		cFileJob:=cStartPath+CriaTrab(,.F.)+".job"
		FErase(cFileJob) //para seguranca, apaga se existir
		AADD(aListaJob,{"U_XA710JobB8",aParamJob,Seconds(),cFileJob})
		// Processa thread
		StartJob("U_XA710JobB8",GetEnvServer(),.F.,cEmpAnt,cFilAnt,aParamJob,nRetry_1,cFileJob)
	EndIf

	For i:=1 to Len(aListaJob)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Analise das Threads em Execucao                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nRetry_0 := 0
		nRetry_1 := 1
		While .T.
			Do Case
			Case GetGlbValue(aListaJob[i,1]) == '0'
				If nRetry_0 > 50
//					Conout(Replicate("-",65))
//					Conout(STR0143+aListaJob[i,1]) //"Nao foi possivel realizar a subida da thread "
//					Conout(Replicate("-",65))
					Final(STR0143+aListaJob[i,1]) //"Nao foi possivel realizar a subida da thread "
			    Else
					nRetry_0 ++
				EndIf
			// TRATAMENTO PARA ERRO DE CONEXAO
			Case GetGlbValue(aListaJob[i,1]) == '1'
				nHandle := FCreate(aListaJob[i,4])
				If nHandle # -1
					FClose(nHandle)
					FErase(aListaJob[i,4]) //apaga apos teste
					If nRetry_1 > 10
//						Conout(Replicate("-",65))
						//Conout(STR0144+aListaJob[i,1]) //"Erro de conexao na thread "
					//	Conout(STR0146) // "Numero de tentativas excedido"
					  //	Conout(Replicate("-",65))
						Final(STR0144+aListaJob[i,1]) //"Erro de conexao na thread "
					Else
			    		// Inicializa variavel global de controle de Job
						PutGlbValue(aListaJob[i,1],"0")
						GlbUnLock()
						// Reiniciar thread
						//Conout(Replicate("-",65))
					//	Conout(STR0144+aListaJob[i,1]) //"Erro de conexao na thread "
					  //	Conout(STR0147+aListaJob[i,1])
						//Conout(STR0145+StrZero(nRetry_1,2))	 //"Tentativa numero: "
						//Conout(Replicate("-",65))
						StartJob(aListaJob[i,1],GetEnvServer(),.F.,cEmpAnt,cFilAnt,aListaJob[i,2],nRetry_1,aListaJob[i,4])
					EndIf
					nRetry_1 ++
				EndIf
			Case GetGlbValue(aListaJob[i,1]) == '2'
				If FCreate(aListaJob[i,4]) # -1
//					Conout(Replicate("-",65))
  //					Conout(STR0148+aListaJob[i,1]) 			//"Erro na execucao da thread"
					Conout(Replicate("-",65))
					Final(STR0148+aListaJob[i,1])
				EndIf
			// THREAD PROCESSADA CORRETAMENTE
			Case GetGlbValue(aListaJob[i,1]) == '3'
				IncProc()
			    If aListaJob[i,1]     == "U_XA710JobC1"
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza o log de processamento			    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					ProcLogAtu("MENSAGEM","Termino Processamento SC1","Termino Processamento SC1")
			    ElseIf aListaJob[i,1] == "U_XA710JobC7"
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza o log de processamento			    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					ProcLogAtu("MENSAGEM","Termino Processamento SC7","Termino Processamento SC7")
			    ElseIf aListaJob[i,1] == "U_XA710JobC2"
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza o log de processamento			    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					ProcLogAtu("MENSAGEM","Termino Processamento SC2","Termino Processamento SC2")
			    ElseIf aListaJob[i,1] == "U_XA710JobD4"
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza o log de processamento			    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					ProcLogAtu("MENSAGEM","Termino Processamento SD4","Termino Processamento SD4")
			    ElseIf aListaJob[i,1] == "U_XA710JobC6"
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza o log de processamento			    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					ProcLogAtu("MENSAGEM","Termino Processamento SC6","Termino Processamento SC6")
			    ElseIf aListaJob[i,1] == "U_XA710JobAFJ"
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza o log de processamento			    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					ProcLogAtu("MENSAGEM","Termino Processamento AFJ","Termino Processamento AFJ")
			    ElseIf aListaJob[i,1] == "U_XA710JobC4"
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza o log de processamento			    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					ProcLogAtu("MENSAGEM","Termino Processamento SC4","Termino Processamento SC4")
			    ElseIf aListaJob[i,1] == "U_XA710JobHC"
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza o log de processamento			    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					ProcLogAtu("MENSAGEM","Termino Processamento SHC","Termino Processamento SHC")
				EndIf
				Exit
			EndCase
			Sleep(1000)
		End
	Next i

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  Explode estrutura dos produtos que tiveram  ³
	//³  Plano Mestre de Producao.                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aPergs711[1] == 2
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o log de processamento			    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ProcLogAtu("MENSAGEM","Iniciando Explosao PMP","Iniciando Explosao PMP")

		dbSelectArea("SH5")
		If (oCenterPanel==Nil)
			ProcRegua(LastRec())
		Else
			oCenterPanel:SetRegua1(SH5->(LastRec()))
		EndIf
		dbSetOrder(2)
		dbSeek(xFilial("SH5")+"SHC")
		While !Eof() .And. SH5->H5_ALIAS == "SHC" // Posiciona nos registros de PMP
			If (oCenterPanel==Nil)
				IncProc()
			Else
				oCenterPanel:IncRegua1(OemToAnsi(STR0129))
			EndIf
			mOpc := H5_OPC
			/*If lUsaMOpc
				Do Case
					Case SH5->H5_ALIAS = "SC4"
						dbSelectArea("SC4")
						SC4->(dbGoTo(SH5->H5_RECNO))
						mOpc := SC4->C4_MOPC
						SC4->(DbCloseArea())
			
					Case SH5->H5_ALIAS = "SC6"
						dbSelectArea("SC6")
						SC6->(dbGoTo(SH5->H5_RECNO))
						mOpc := SC6->C6_MOPC
						SC6->(DbCloseArea())
				
					Case SH5->H5_ALIAS = "SC2"
						dbSelectArea("SC2")
						SC2->(dbGoTo(SH5->H5_RECNO))
						mOpc := SC2->C2_MOPC
						SC2->(DbCloseArea())
				EndCase
				dbSelectArea("SH5")
			EndIf*/
			If lPeMT710EXP
				lMT710EXP := ExecBlock("MT710EXP",.F.,.F.,{H5_PRODUTO,mOpc,H5_REVISAO,H5_QUANT})
				If ValType(lMT710EXP) # "L"
					lMT710EXP := .T.
				EndIf
			EndIf
			If lMT710EXP
				A711ExplEs(H5_PRODUTO,mOpc,H5_REVISAO,H5_QUANT,A650DtoPer(H5_DATAORI),cStrTipo,cStrGrupo)
			EndIf
			dbSelectArea("SH5")
			dbSkip()
		End
		u_xA710GrvTm(oCenterPanel,STR0138) //"Termino da Explosao da Estrutura dos Itens relacionados ao Plano Mestre de Producao - SHC."
		If (oCenterPanel<>Nil)
			oCenterPanel:IncRegua2()
		EndIf
	EndIf

	// Chama funcao que recalcula saldo - ANTES DA EXPLOSAO DE ESTRUTURA
	MA711ClNes(oCenterPanel)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  Explode estrutura e calcula necessidade por PRODUTO ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o log de processamento			    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcLogAtu("MENSAGEM","Iniciando Explosao da Estrutura","Iniciando Explosao da Estrutura")

	dbSelectArea("SHA")
	dbSetOrder(2)
	dbGoTop()
	If (oCenterPanel==Nil)
		ProcRegua(LastRec()/6)
	Else
		oCenterPanel:SetRegua1(SHA->(LastRec())/6)
	EndIf
	While !Eof()
		cNivMRP := HA_NIVEL
		// Processa NIVEL A NIVEL
		While !Eof() .And. cNivMRP == HA_NIVEL
			//Explode estrutura somente quando houver estrutura ou caso seja subproduto
			If HA_NIVEL # "99" .Or. IsNegEstr(HA_PRODUTO)[1]
		        cSeek:= xFilial("SHA")+HA_NIVEL+HA_PRODUTO+HA_OPC+HA_REVISAO+"6"
		        If !lUsaMOpc
					MsSeek(cSeek)
				Else
					MOpcSeek("SHA",2,HA_NIVEL,HA_PRODUTO,,HA_OPC,HA_REVISAO,"6")
				EndIf
				nRecSHA   := Recno()
				For nz:=1 to Len(aPeriodos)
					If (oCenterPanel==Nil)
						IncProc()
					Else
						oCenterPanel:IncRegua1(OemToAnsi(STR0130))
					EndIf
					nSaldo:=0
					cCampo  := "HA_PER"+StrZero(nz,3)
					nSaldo  := FieldGet(FieldPos(cCampo))
					If lPeMT710EXP
						lMT710EXP := ExecBlock("MT710EXP",.F.,.F.,{HA_PRODUTO,HA_OPC,HA_REVISAO,nSaldo})
						If ValType(lMT710EXP) # "L"
							lMT710EXP := .T.
						EndIf
					EndIf
					If lMT710EXP .And. QtdComp(nSaldo) > QtdComp(0)
						aNegEst := IsNegEstr(HA_PRODUTO,aPeriodos[nz],nSaldo)
						If aNegEst[1]
							SB1->(MsSeek(xFilial("SB1")+aNegEst[2]))
							For z := 1 To aNegEst[5]
								u_XA711CriSH5(aPeriodos[nz],aNegEst[2],aNegEst[3],SB1->B1_REVATU,"SBP",0,HA_PRODUTO,"","",aNegEst[4],"2",.F., .T.,NIL,.F.,.T.,aPeriodos,nTipo,c711NumMRP,cStrTipo,cStrGrupo)
								A711ExplEs(aNegEst[2],aNegEst[3],SB1->B1_REVATU,aNegEst[4],StrZero(nz,3,0),cStrTipo,cStrGrupo,.F.)
							Next z
						ElseIf HA_NIVEL # "99"
							If lUsaMOpc
								aOpc := Str2Array(HA_MOPC,.F.)
							EndIf
							A711ExplEs(HA_PRODUTO,HA_OPC,HA_REVISAO,nSaldo,StrZero(nz,3,0),cStrTipo,cStrGrupo,aOpc)
						EndIf
					EndIf
				Next nz
				// Caso necessario reposiciona SHA
				If SHA->(Recno()) # nRecSHA
					SHA->(dbGoto(nRecSHA))
				EndIf
			EndIf
			dbSelectArea("SHA")
	        dbSetOrder(2)
	        dbSkip()
		End

		// Chama funcao que recalcula saldo - APOS EXPLOSAO DE ESTRUTURA DE CADA NIVEL
		MA711ClNes(oCenterPanel)
		If (oCenterPanel<>Nil)
			oCenterPanel:IncRegua2()
		EndIf
    End
    u_xA710GrvTm(oCenterPanel,STR0139) //"Termino do Calculo das Necessidade."

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o log de processamento			    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcLogAtu("MENSAGEM","Termino da Explosao da Estrutura","Termino da Explosao da Estrutura")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Avalia eventos do log do MRP                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lLogMRP
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o log de processamento			    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ProcLogAtu("MENSAGEM","Iniciando montagem do Log MRP","Iniciando montagem do Log MRP")
		dbSelectArea("SH5")
		dbSetOrder(1)
		dbSelectArea("SHA") 
		If lUsaMOpc
			dbSetOrder(3)
		Else
			dbSetOrder(1)
		EndIf
		dbGoTop()
		While !Eof()
			// Array com os dados por produto para analise do log
			// [1] saida de material resumidos
			// [2] saldos de material
			aSaldos:={}
			// Posiciona nos registros de saida
			cSeek:= xFilial("SHA")+HA_PRODUTO+HA_OPC+HA_REVISAO+"3"
			If !lUsaMOpc
				dbSeek(cSeek)
			Else
				MOpcSeek("SHA",1,,HA_PRODUTO,,HA_OPC,HA_REVISAO,"3")
			EndIf
			For nz:=1 to Len(aPeriodos)
				cCampo   := "HA_PER"+StrZero(nz,3)
				nSaldo   := FieldGet(FieldPos(cCampo))
				AADD(aSaldos,{nSaldo,0})
			Next nz
			// Posiciona nos registros de saida por estrutura
			cSeek:= xFilial("SHA")+HA_PRODUTO+HA_OPC+HA_REVISAO+"4"
			If !lUsaMOpc
				dbSeek(cSeek)
			Else
				MOpcSeek("SHA",1,,HA_PRODUTO,,HA_OPC,HA_REVISAO,"4")
			EndIf
			For nz:=1 to Len(aPeriodos)
				cCampo        := "HA_PER"+StrZero(nz,3)
				nSaldo        := FieldGet(FieldPos(cCampo))
				aSaldos[nz,1] += nSaldo
			Next nz
			// Posiciona nos registros de saldo e efetua analise dos movimentos
			cSeek:= xFilial("SHA")+HA_PRODUTO+HA_OPC+HA_REVISAO+"5"
			If !lUsaMOpc
				dbSeek(cSeek)
			Else
				MOpcSeek("SHA",1,,HA_PRODUTO,,HA_OPC,HA_REVISAO,"5")
			EndIf
			For nz:=1 to Len(aPeriodos)
				cCampo        := "HA_PER"+StrZero(nz,3)
				nSaldo        := FieldGet(FieldPos(cCampo))
				aSaldos[nz,2] += nSaldo
			Next nz
			lLog008 := .T.
			lLog009 := .T.
			For nz:=1 to Len(aPeriodos)
				nSaldo:=aSaldos[nz,2]
				If QtdComp(nSaldo) > QtdComp(0)
					// Analisa movimentos de maneira analitica caso sobre saldo no periodo
					SB1->(dbSeek(xFilial("SB1")+SHA->HA_PRODUTO))
					If nSaldo > RetFldProd(SHA->HA_PRODUTO,"B1_EMIN")
						// Reativa a exibicao do log pois o saldo voltou
						lLog009 := .T.
					EndIf
					// Verifica se atingiu ponto de pedido
					If lLog009 .And. RetFldProd(SHA->HA_PRODUTO,"B1_EMIN") > 0 .And. QtdComp(nSaldo) <= QtdComp(RetFldProd(SHA->HA_PRODUTO,"B1_EMIN"))
						u_XA710CriaLOG("009",SHA->HA_PRODUTO,{SB1->B1_EMIN,nSaldo,aPeriodos[nz],"SB1"},lLogMRP,c711NumMrp)
						// Desativa a exibicao do log para os periodos seguintes.
						lLog009 := .F.
					EndIf
					If nSaldo <= RetFldProd(SHA->HA_PRODUTO,"B1_EMAX")
						// Reativa a exibicao do log pois o saldo voltou
						lLog008 := .T.
					EndIf
					// Verifica se atingiu estoque maximo
					If lLog008 .And. RetFldProd(SHA->HA_PRODUTO,"B1_EMAX") > 0 .And. QtdComp(nSaldo) > QtdComp(RetFldProd(SHA->HA_PRODUTO,"B1_EMAX"))
						u_XA710CriaLOG("008",SHA->HA_PRODUTO,{SB1->B1_EMAX,nSaldo,aPeriodos[nz],"SB1"},lLogMRP,c711NumMrp)
						lLog008 := .F.
					EndIf
					// Le os movimentos e grava as quantidades de maneira analitica no array aDados
					aDados:={}
					dbSelectArea("SH5")
					If!lUsaMOpc
						If dbSeek( xFilial("SHA")+SHA->HA_PRODUTO+SHA->HA_OPC+SHA->HA_REVISAO+StrZero(nz,3)+"2")
							While !Eof() .AND. xFilial("SHA")+SHA->HA_PRODUTO+SHA->HA_OPC+SHA->HA_REVISAO+StrZero(nz,3)+"2" == xFilial("SH5")+H5_PRODUTO+H5_OPC+H5_REVISAO+H5_PER+H5_TIPO							// ARRAY CONTENDO QUANTIDADE, REGISTRO E IDENTIFICADOR SE JA FOI MARCADO
								// PARA ATRASO
								AADD(aDados,{H5_QUANT,Recno(),.F.})
								dbSkip()
							End
							// Ordena registros pela quantidade
							ASORT(aDados,,,{|x,y| x[1] < y[1]})
						EndIf
					Else
						If MOpcSeek("SH5",1,,SHA->HA_PRODUTO,StrZero(nz,3),SHA->HA_OPC,SHA->HA_REVISAO)
							While !Eof() .AND. xFilial("SHA")+SHA->HA_PRODUTO+MontaOpc(SHA->HA_OPC)+SHA->HA_REVISAO+StrZero(nz,3)+"2" == xFilial("SH5")+H5_PRODUTO+MontaOpc(H5_OPC)+H5_REVISAO+H5_PER+H5_TIPO							// ARRAY CONTENDO QUANTIDADE, REGISTRO E IDENTIFICADOR SE JA FOI MARCADO
								// PARA ATRASO
								AADD(aDados,{H5_QUANT,Recno(),.F.})
								dbSkip()
							End         
							// Ordena registros pela quantidade
							ASORT(aDados,,,{|x,y| x[1] < y[1]})
						EndIf
					EndIf
					dbSelectArea("SHA")
					For z:=nz+1 To Len(aPeriodos)
						// Se tem saida verifica quais movimentos podem ser atrasados
						While (QtdComp(aSaldos[z,1]) > QtdComp(0)) .And. (QtdComp(aSaldos[z,2]) <= QtdComp(0))
							nAcho:=Ascan(aDados,{|x| x[3] == .F. .And. x[1] <= aSaldos[z,1]})
							If nAcho > 0
								SH5->(dbGoto(aDados[nAcho,2]))
								u_XA710CriaLOG("002",SH5->H5_PRODUTO,{SH5->H5_DATAORI,SH5->H5_DOC,SH5->H5_ITEM,SH5->H5_ALIAS,aPeriodos[z]},lLogMRP,c711NumMrp)
								aSaldos[z,1]-=aDados[nAcho,1]
								aDados[nAcho,3]:=.T.
							Else
								Exit
							EndIf
						End
					Next z
					// Verifica todos movimentos que podem ser cancelados pois nao tem saida subsequente
					If QtdComp(nSaldo) > QtdComp(0)
						While .T.
							lVoltaSaldo:=.F.
							nAcho:=Ascan(aDados,{|x| x[3] == .F.})
							If nAcho > 0
								aDados[nAcho,3]:=.T.
								If QtdComp(aDados[nAcho,1]) <= QtdComp(nSaldo)
									SH5->(dbGoto(aDados[nAcho,2]))
									// Verifica se existe necessidade anterior ao periodo
									For z:=nz to 1 Step -1
										If QtdComp(aSaldos[z,2]) < QtdComp(0)
											lVoltaSaldo:=.T.
											u_XA710CriaLOG("003",SH5->H5_PRODUTO,{SH5->H5_DATAORI,SH5->H5_DOC,SH5->H5_ITEM,SH5->H5_ALIAS,aPeriodos[z]},lLogMRP,c711NumMrp)
										EndIf
									Next z
									// Caso nao tenha necessidade anterior ao periodo
									// identifica que evento pode ser cancelado
									If !lVoltaSaldo
										u_XA710CriaLOG("007",SH5->H5_PRODUTO,{SH5->H5_DATAORI,SH5->H5_DOC,SH5->H5_ITEM,SH5->H5_ALIAS},lLogMRP,c711NumMrp)
									EndIf
									// Retira o saldo de todos os periodos subsequentes
									For z:=nz to Len(aSaldos)
										aSaldos[z,2]-=aDados[nAcho,1]
									Next z
									// Retira o saldo
									nSaldo-=aDados[nAcho,1]
								EndIf
							Else
								Exit
							EndIf
						End
					EndIf
				EndIf
			Next nz
			
			dbSelectArea("SHA")
			If lUsaMOpc
				dbSetOrder(3)
			Else
				dbSetOrder(1) 
			EndIf
			
			dbSkip(2)
		End
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o log de processamento			    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ProcLogAtu("MENSAGEM","Termino da montagem do Log MRP","Termino da montagem do Log MRP")
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis com a periodicidade de geracao de  ³
//³ OPs e SCs.                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cSelPer:=cSelPerSC:=Replicate("û",Len(aPeriodos))
If aPergs711[10] == 1
	cSelF  :=cSelFSC  :=Replicate("û",Len(aPeriodos))
Else
	cSelF  :=cSelFSC  :=Replicate(" ",Len(aPeriodos))
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa ponto de entrada                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (ExistBlock("MTA710"))
	ExecBlock("MTA710",.F.,.F.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria variavel "inclui"para nao gerar erro de ³
//³ inicialializador padrao.                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type("Inclui")=="U"
	Private Inclui := .F.
EndIf
If Type("ALTERA")=="U"
	Private ALTERA := .F.
EndIf

u_xA710GrvTm(oCenterPanel,STR0140) //"Inicio da montagem de tela."
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta arquivo com TREE e consulta de DADOS   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ! lBatch
	
	DEFINE FONT oFont NAME "Arial" SIZE 0, -10 	 
	DEFINE MSDIALOG oDlg TITLE cCadastro+" - "+STR0062+" "+c711NumMRP OF oMainWnd PIXEL FROM nTop,nLeft TO nBottom+nTop-12 ,nRight
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria Variaveis PRIVATE nessa funcao          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SB1->(RegToMemory("SB1",.F.))
	SC1->(RegToMemory("SC1",.F.))
	SC7->(RegToMemory("SC7",.F.))
	SC2->(RegToMemory("SC2",.F.))
	SHC->(RegToMemory("SHC",.F.))
	SD4->(RegToMemory("SD4",.F.))
	SC6->(RegToMemory("SC6",.F.))
	SC4->(RegToMemory("SC4",.F.))
	AFJ->(RegToMemory("AFJ",.F.))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao de Menu para o botao de Filtro                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MENU oMenu1 POPUP
	MENUITEM STR0088 ACTION (M710FilNec(),Eval(bChange),oTreeM711:Refresh()) //"Mostra somente as necessidades"
	MENUITEM STR0107 ACTION (M710FilGen(),Eval(bChange),oTreeM711:Refresh()) //"Filtrar Produtos"
	ENDMENU

	// Folder do Tree e dos dados	
	oFolder := TFolder():New(30 /*12*/,0,aTitles,aPages,oDlg,,,, .T., .F.,((nRight-nLeft)/2)+5, nBottom)  //Dados  / Legenda
	oFolder:aDialogs[1]:oFont := oDlg:oFont
	// Definicao do objeto SAY para descricao do produto
	@ 0,3 Say oSay1 Prompt "" Size 125,10 OF oFolder:aDialogs[1] Pixel
	@ 5,3 Say oSay2 Prompt "" Size 125,8 OF oFolder:aDialogs[1] Pixel
	oSay1:SetColor(CLR_HRED,GetSysColor(15))
	oSay2:SetColor(CLR_HRED,GetSysColor(15))
	// Panel com dados
	oPanelM711 := TPanel():New(0,165,'',oFolder:aDialogs[1], oDlg:oFont, .T., .T.,, ,(nRight-nLeft)/2-164,((nBottom-nTop)/2)-26,.T.,.T. )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta array com os campos a serem utilizados no Browse       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCampos:={{"HA_TEXTO","",STR0038,16}} //"Tipo"
	AADD(aCampos,{"HA_PRODSHW","",STR0025,LEN(SHA->HA_PRODSHW)}) //"Produtos"
	AADD(aCampos,{"HA_OPCSHW","",STR0058,LEN(SHA->HA_OPCSHW)}) //"Opcionais"
	If A710TrataRev()
		Aadd(aCampos,{"HA_REVSHW","",STR0081,4})//"Revisao"
	Endif

	For i := 1 to Len(aPeriodos)
		AADD(aCampos,{"HA_PER"+StrZero(i,3),cPictQuant,DtoC(aPeriodos[i]),aTamQuant[1]+5})
	Next i      
	
	dbSelectArea("SHA")  
	If !lUsaMOpc
		dbSetOrder(1)
	Else 
		dbSetOrder(3)
	EndIf

	If UsaNewPrc()
		nBottom := nBottom-32
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta browse de todos os produtos                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nOldEnch:=1
	aEnch[nOldEnch]:=MaMakeBrow(oPanelM711,"SHA",{0,0,(nRight-nLeft)/2-164,((nBottom-nTop)/2)-26},,.F.,aCampos,,cTopFun,cBotFun,NIL,NIL,2)
	// Informacoes da Legenda
	nPoLin:=10
	@ nPoLin,08 BITMAP oBmp RESNAME "PMSEDT4" Of oFolder:aDialogs[2] Size 9,9 Pixel NoBorder
	@ nPoLin,23 SAY STR0025 Of oFolder:aDialogs[2] Size 50,50 Pixel
	If lShAlt
		@ 20,08 BITMAP oBmp RESNAME "PMSEDT2" Of oFolder:aDialogs[2] Size 9,9 Pixel NoBorder
		@ 20,23 SAY 'Produto com Alternativos' Of oFolder:aDialogs[2] Size 100,50 Pixel
		nPoLin:=20
	EndIF
	@ nPoLin+10,08 BITMAP oBmp RESNAME "PMSEDT3" Of oFolder:aDialogs[2] Size 9,9 Pixel NoBorder
	@ nPoLin+10,23 SAY STR0027 Of oFolder:aDialogs[2] Size 50,50 Pixel
	@ nPoLin+20,08 BITMAP oBmp RESNAME "PMSEDT1" Of oFolder:aDialogs[2] Size 9,9 Pixel NoBorder
	@ nPoLin+20,23 SAY STR0028 Of oFolder:aDialogs[2] Size 50,50 Pixel
	@ nPoLin+30,08 BITMAP oBmp RESNAME "PMSDOC" Of oFolder:aDialogs[2] Size 9,9 Pixel NoBorder
	@ nPoLin+30,23 SAY STR0032 Of oFolder:aDialogs[2] Size 50,50 Pixel
	@ nPoLin+40,08 BITMAP oBmp RESNAME "relacionamento_direita" Of oFolder:aDialogs[2] Size 9,9 Pixel NoBorder
	@ nPoLin+40,23 SAY STR0040 Of oFolder:aDialogs[2] Size 150,50 Pixel
	// Definicao do objeto tree
	oTreeM711 := dbTree():New(14,2,((nBottom-nTop)/2)-22,164,oFolder:aDialogs[1],,,.T.)
	oTreeM711:bChange := {|| MT711DlgV(@aEnch,{0,0,((nBottom-nTop)/2)-24,((nRight-nLeft)/2)-164},@nOldEnch,oSay1,oSay2),Eval(bChange)}
	oTreeM711:SetFont(oFont)
	oTreeM711:lShowHint:= .F.
	// Monta Tree
	MT711Tree(aPergs711[28]==1,oCenterPanel,lVisualiza)
	// Posiciona no primeiro registro
	SHA->(dbGotop())
	// Refaz browse com informacoes de todos os produtos
	oPanelM711:Refresh()
	oPanelM711:Show()
	
	SHA->()
	cSHAFilterMacro := "HA_FILIAL == '"+xFilial("SHA")+"'"
	dbSetFilter({|| &cSHAFilterMacro}, cSHAFilterMacro) 
	
	ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()},,aButtons))
	Release Object oTreeM711
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha arquivos utilizados                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lBatch .And. ValType(aAuto[6]) == "L" .And. aAuto[6]
	If Len(aAuto) >= 8 .And. ValType(aAuto[8]) == "C"
		cNumOpDig := aAuto[8]
	Endif
	A711Gera(@cNumOpDig,cStrTipo,cStrGrupo)
Endif

//-- Retira o semaforo de uso exclusivo da operacao
UnLockByName("SH5USO"+cEmpAnt+cFilAnt,.T.,.T.,.T.)

dbSelectArea("SH5")
dbClearFilter()
dbCloseArea()
dbSelectArea("SHA")
dbClearFilter()
dbCloseArea()
If aPergs711[32] == 1
	dbSelectArea("SHF")
	dbCloseArea()
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³M711AvalProd³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 21/05/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Avalia se Produto devera ser Considerado ou Nao no MRP       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cProd     Codigo do produto a ser avaliado                   ³±±
±±³          ³ cStrTipo  String com tipos a serem processados               ³±±
±±³          ³ cStrGrupo String com grupos a serem processados              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA710                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XM711AvalProd(cProd,cStrTipo,cStrGrupo)
Static lMT711B1
Local lRet:=.T.
Local aArea:=GetArea()
Local aAreaSB1:=SB1->(Getarea())
// Reposiciona registro caso necessario
If (xFilial("SB1")+cProd) <> (SB1->B1_FILIAL+SB1->B1_COD)
	SB1->(dbSetOrder(1))
	SB1->(MsSeek(xFilial("SB1")+cProd))
EndIf
lRet:=(SB1->B1_TIPO$cStrTipo) .And. (SB1->B1_GRUPO$cStrGrupo) .And. (RetFldProd(SB1->B1_COD,"B1_MRP")$" S")
lMT711B1:=If(ValType(lMT711B1) == "L",lMT711B1,ExistBlock("MT711B1"))
// Executa P.E. para tratar filtro do SB1
If lRet .And. lMT711B1
	lRet:=ExecBlock("MT711B1",.F.,.F.,SB1->B1_COD)
	If ValType(lRet) # "L"
		lRet:=.T.
	EndIf
EndIf
RestArea(aAreaSB1)
RestArea(aArea)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³xA711CriSH5  ³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 21/05/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Cria registros no arquivo de detalhe do MRP                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA710                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ dDataOri  Data da necessidade do material                    ³±±
±±³          ³ cProduto  Produto                                            ³±±
±±³          ³ cOpc      Opcional                                           ³±±
±±³          ³ cRevisao  Revisao Estrutura                                  ³±±
±±³          ³ cAliasMov Alias do movimento                                 ³±±
±±³          ³ nRecno    Registro                                           ³±±
±±³          ³ cDoc      Documento                                          ³±±
±±³          ³ cDocKey   Documento Chave para ligacao                       ³±±
±±³          ³ cItem     Item do Documento                                  ³±±
±±³          ³ nQuant    Quantidade                                         ³±±
±±³          ³ cTipo711  Indica o tipo de movimento nos arquivo SHA/SH5     ³±±
±±³          ³ lAddTree  Adiciona registro no tree                          ³±±
±±³          ³ lRevisao  Indica se utiliza controle de revisoes             ³±±
±±³          ³ cAliasTop Alias do banco em SQL                              ³±±
±±³          ³ lCalcula  Indica se recalcula apos inclusao                  ³±±
±±³          ³ lInJob    Identifica que foi chamado por JOB                 ³±±
±±³          ³ aParPeriodos Array com periodos (utilizado em job)           ³±±
±±³          ³ nParTipo     Tipo de calculo (utilizado em job)              ³±±
±±³          ³ cPar711Num   Numero do processamento do MRP                  ³±±
±±³          ³ cStrTipo  String com tipos a serem processados               ³±±
±±³          ³ cStrGrupo String com grupos a serem processados              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XA711CriSH5(dDataOri,cProduto,cOpc,cRevisao,cAliasMov,nRecno,cDoc,cItem,cDocKey,nQuant,cTipo711,lAddTree,lRevisao,cAliasTop,lCalcula,lInJob,aParPeriodos,nParTipo,cPar711Num,cStrTipo,cStrGrupo,nPrazoEnt,cProdOri,aOpc)
Static lExeBloH5
Local cAliasOld:= Alias()
Local aAreaSG1 :=SG1->(GetArea())
Local aAreaSC2 := {} 
Local cPeriodo := A650DtoPer(dDataOri,aParPeriodos,nParTipo,cProduto,nQuant)
Local nAchouTot:=0,i
Local cNivelEstr:=""
LOCAL cRev711Vaz:=CriaVar("B1_REVATU",.F.)

// Ao incluir um novo parametro que interfira na geracao de documentos deve ser colocado no array para envio ao ponto de entrada e documentado no dem
Local aBackParam 	:={nQuant,dDataOri}
Local aRetParam  	:={}
Local nCheckParam	:=0
Local lOkRetPE   	:=.T.
Local aAreaSH5 	:=SH5->(GetArea())
Local mOpc			:= ""

Default lRevisao  := .T.
Default lCalcula  := .F.
Default lInJob    := .F.
Default cAliasTop := "SB1"
Default cStrTipo  := ""
Default cStrGrupo := ""
Default nPrazoEnt := 0
Default aOpc := {}
Default cProdOri  := ""

If Empty(cStrTipo) .And. Type('a711Tipo') == "A"
	For i := 1 To Len(a711Tipo)
		If a711Tipo[i,1]
			cStrTipo += SubStr(a711Tipo[i,2],1,nTamTipo711)+"|"
		EndIf
	Next i
EndIf

If Empty(cStrGrupo) .And. Type('a711Grupo') == "A"
	cStrGrupo := Criavar("B1_GRUPO",.f.)+"|"
	For i := 1 To Len(a711Grupo)
		If a711Grupo[i,1]
			cStrGrupo += SubStr(a711Grupo[i,2],1,nTamGr711)+"|"
		EndIf
	Next i
EndIf

// Checa existencia do ponto de entrada
lExeBloH5:=If(lExeBloH5==NIL,ExistBlock("A711CSH5"),lExeBloH5)

// So soma no tree caso nao seja resumido
lAddTree :=lAddTree .And. aPergs711[28]==2

// Considera numero do processamento do MRP passado como parametro
If ValType(cPar711Num) == "C"
	c711NumMRP:=cPar711Num
EndIf

If lExeBloH5
	aRetParam:=ExecBlock("A711CSH5",.F.,.F.,{dDataOri,cProduto,cOpc,cRevisao,cAliasMov,nRecno,cDoc,cItem,cDocKey,nQuant,cTipo711,lAddTree,lRevisao, cAliasTop})
	// Checa retorno do execblock
	If Valtype(aRetParam) == "A" .And. Len(aRetParam) == Len(aBackParam)
		For nCheckParam:=1 to Len(aRetParam)
			If Valtype(aRetParam[nCheckParam]) # Valtype(aBackParam[nCheckParam])
				lOkRetPE:=.F.
				Exit
			EndIf
		Next nCheckParam
		// Se nao achou divergencia
		If lOkRetPe
			// Atribui novos valores
			nQuant  :=aRetParam[1]
			dDataOri:=aRetParam[2]
			cPeriodo:= A650DtoPer(dDataOri,aParPeriodos,nParTipo)
		EndIf
	EndIf
EndIf

If !A710TrataRev()
	cRevisao := Space(Len(SB1->B1_REVATU))
	lRevisao := .F.
ElseIf Empty(cRevisao)
	//Garante que esteja possicionado no produto correto
	If cProduto <> (cAliasTop)->B1_COD
		(cAliasTop)->(dbSeek(xFilial("SB1")+cProduto))
	EndIf
	cRevisao := (cAliasTop)->B1_REVATU
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o movimento esta dentro do periodo    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(cPeriodo)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Descobre nivel do produto                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SG1->(dbSetOrder(1))
	If SG1->(dbSeek(xFilial("SG1")+cProduto))
		cNivelEstr := SG1->G1_NIV
	Else
		cNivelEstr := "99"
		If Empty(A711EstOpc(cProduto,cOpc,Nil,Nil,cStrTipo,cStrGrupo))
			cOpc := Space(Len(cOpc))
		Endif
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adiciona registro no arquivo                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SH5")
	Reclock("SH5",.T.)
	Replace H5_FILIAL  With xFilial("SH5")
	Replace H5_DATAORI With SomaPrazo(dDataOri,-nPrazoEnt)
	Replace H5_PER     With cPeriodo
	Replace H5_PRODUTO With cProduto
	Replace H5_ALIAS   With cAliasMov
	Replace H5_RECNO   With nRecno
	Replace H5_DOC     With cDoc
	Replace H5_DOCKEY  With cDocKey
	Replace H5_ITEM    With cItem
	Replace H5_NIVEL   With cNivelEstr
	Replace H5_QUANT   With nQuant
	Replace H5_TIPO    With cTipo711
	Replace H5_NUMMRP  With c711NumMRP
	Replace H5_PRODORI With	cProdOri
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava somente opcionais utilizados nesse produto  ³
	//³ Verifica de acordo com a estrutura.               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	/*If Len(aOpc) == 0
		//Replace H5_OPCORI With cOpc
		If !Empty(cOpc)	.And. !Empty(cProduto)
			cGrupos:=A711EstOpc(cProduto,MontaOpc(cOpc),Nil,Nil,cStrTipo,cStrGrupo)
			cOpc:=A711AvlOpc(MontaOpc(cOpc),cGrupos)
		EndIf
		Replace H5_OPC     With cOpc
	Else    
		If !Empty(cOpc)	.And. !Empty(cProduto)
			cGrupos:=A711EstOpc(cProduto,MontaOpc(cOpc),Nil,Nil,cStrTipo,cStrGrupo)
			cOpc:=A711AvlOpc(MontaOpc(cOpc),cGrupos)
			Replace H5_OPCORI With Array2Str(aOpc,.F.)
		EndIf
		Replace H5_OPC    With cOpc
	EndIf*/
	
	If !Empty(cOpc) .And. !Empty(cProduto)
		cGrupos := A711EstOpc(cProduto,MontaOpc(cOpc),Nil,Nil,cStrTipo,cStrGrupo)
		cOpc := A711AvlOpc(MontaOpc(cOpc),cGrupos)
	EndIf
	Replace H5_OPC     With cOpc
	
	If lRevisao
		Replace H5_REVISAO With cRevisao
	Else
		Replace H5_DOCREV with cRevisao
	Endif
	MsUnlock()
	If !Empty(cProduto)
		If !lInJob .And. lAddTree .And. !lBatch
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Adiciona registro em array totalizador utilizado no TREE  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Len(aTotais[Len(aTotais)]) > 4095
				AADD(aTotais,{})
			EndIf
			For i:=1 to Len(aTotais)
				nAchouTot:=ASCAN(aTotais[i],{ |x| x[1] == H5_PRODUTO+H5_OPC+H5_REVISAO .And. x[2] == H5_PER .And. x[3] == H5_ALIAS})
				If nAchouTot != 0
					aTotais[i,nAchouTot,4] += H5_QUANT
					Exit
				EndIf
			Next i
			If nAchouTot ==0
				AADD(aTotais[Len(aTotais)],{H5_PRODUTO+H5_OPC+H5_REVISAO,H5_PER,H5_ALIAS,H5_QUANT})
			EndIf
			A711AdTree(.F.,{{SH5->H5_PRODUTO,SH5->H5_OPC,SH5->H5_REVISAO,SH5->H5_ALIAS,SH5->H5_TIPO,SH5->H5_DOC,StrZero(SH5->(Recno()),12),SH5->H5_DOCREV}},aPergs711[28]==1)
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cria registro no arquivo totalizador por PRODUTO+OPCIONAL+REVISAO+PERIODO ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		mOpc := SH5->H5_OPC
		aAreaSC2:= SC2->(GetArea())
		If lUsaMOpc
			Do Case
				Case SH5->H5_ALIAS = "SC4"
					dbSelectArea("SC4")
					SC4->(dbGoTo(SH5->H5_RECNO))
					mOpc := SC4->C4_MOPC
					SC4->(DbCloseArea())
			
				Case SH5->H5_ALIAS = "SC6"
					dbSelectArea("SC6")
					SC6->(dbGoTo(SH5->H5_RECNO))
					mOpc := SC6->C6_MOPC
					SC6->(DbCloseArea())
					
				Case SH5->H5_ALIAS = "SC2"
					dbSelectArea("SC2")
					SC2->(dbGoTo(SH5->H5_RECNO))
					mOpc := SC2->C2_MOPC
					//SC2->(DbCloseArea())
			EndCase
			RestArea(aAreaSC2)
		EndIf	
		A711CriSHA(cProduto,mOpc,If(lRevisao,cRevisao, cRev711Vaz),cNivelEstr,cPeriodo,nQuant,cTipo711,cAliasTop,lCalcula,cStrTipo,cStrGrupo)
	EndIf
	RestArea(aAreaSG1)
	dbSelectArea(cAliasOld)
EndIf
RestArea(aAreaSH5)
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A711CriSHA  ³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 14/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Cria registros no arquivo de totais do MRP                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA710                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cProduto  Produto                                            ³±±
±±³          ³ cOpc      Opcional                                           ³±±
±±³          ³ cRevisao  Revisao Estrutura                                  ³±±
±±³          ³ cNivelEstr    Nivel do produto                               ³±±
±±³          ³ cPeriodo  Periodo                                            ³±±
±±³          ³ nQuant    Quantidade                                         ³±±
±±³          ³ cTipo711  1-Sld Inicial 2-Entrada 3-Saida 5-Saida Relacionada³±±
±±³          ³ cAliasTop Alias do banco em SQL                              ³±±
±±³          ³ lCalcula  Indica se recalcula apos inclusao                  ³±±
±±³          ³ cStrTipo  String com tipos a serem processados               ³±±
±±³          ³ cStrGrupo String com grupos a serem processados              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER  Function ZA711CriSHA(cProduto,cOpc,cRevisao,cNivelEstr,cPeriodo,nQuant,cTipo711,cAliasTop,lCalcula,cStrTipo,cStrGrupo)
LOCAL cAlias      := Alias(),aAreaSHA:=SHA->(GetArea())
LOCAL cCampo      :=""
LOCAL nz          :=0
LOCAL nPosCampo   :=0
LOCAL nEntrada    :=0
LOCAL nSaida      :=0
LOCAL nSaidaEstr  :=0
LOCAL nSaldoAtu   :=0
LOCAL nEstSeg     :=0
LOCAL nPontoPed   :=0
LOCAL nNecessidade:=0
LOCAL lExiste     :=.F.
LOCAL aTexto      := {STR0026,STR0027,STR0028,STR0063,STR0029,STR0030}
LOCAL cGrupos     := ""
LOCAL cOpcOri	  := cOpc
DEFAULT cPeriodo  := "001"
DEFAULT cNivelEstr:= ""
DEFAULT cTipo711  := ""
DEFAULT cAliasTop := "SB1"
DEFAULT lCalcula  := .F.
DEFAULT cStrTipo  := ""
DEFAULT cStrGrupo := ""

If ! A710TrataRev()
	cRevisao := Space(Len(SB1->B1_REVATU))
ElseIf Empty(cRevisao)
	cRevisao := (cAliasTop)->B1_REVATU
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Descobre nivel do produto                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(cNivelEstr)
	SG1->(dbSetOrder(1))
	If SG1->(dbSeek(xFilial("SG1")+cProduto))
		cNivelEstr := SG1->G1_NIV
	Else
		cNivelEstr := "99"
	EndIf
EndIf
// Tipos de Registro
// 1 Saldo Inicial
// 2 Entrada
// 3 Saida
// 4 Saida pela Estrutura
// 5 Saldo
// 6 Necessidade
cCampo := "HA_PER"+cPeriodo
dbSelectArea("SHA")
dbSetOrder(1)
nPosCampo := FieldPos(cCampo)
//Verifica existencia do registro
SB1->(MsSeek(xFilial("SB1") + cProduto))

If Empty(A711EstOpc(cProduto,MontaOpc(cOpc),Nil,Nil,cStrTipo,cStrGrupo))
	cOpc := Space(Len(cOpc))
Endif
If !Empty(cOpc)	.And. !Empty(cProduto)
	cGrupos:=A711EstOpc(cProduto,MontaOpc(cOpc),Nil,Nil,cStrTipo,cStrGrupo)
	cOpc:=A711AvlOpc(MontaOpc(cOpc),cGrupos)
EndIf

If lCalcula
	For nz:=1 to 6
		If !lUsaMOpc
			lExiste:=dbSeek(xFilial("SHA")+cProduto+cOpc+cRevisao+Str(nz,1))
		Else 
			lExiste:= MOpcSeek("SHA",1,,cProduto,,cOpc,cRevisao,Str(nz,1))
		EndIf
		// Inclui registros caso necessario
		If !lExiste
			dbSelectArea("SHA")
			Reclock("SHA",.T.)
			Replace HA_FILIAL  With xFilial("SHA")
			Replace HA_PRODUTO With cProduto
			Replace HA_OPC     With cOpc
			Replace HA_REVISAO With cRevisao
			Replace HA_NIVEL   With cNivelEstr
			Replace HA_TIPO    With Str(nz,1)
			Replace HA_TEXTO   With aTexto[nz]
			Replace	HA_NUMMRP  With c711NumMRP   
			If lUsaMOpc
				Replace HA_MOPC  With cOpcOri
				Replace HA_OPCORD  With cOpc
			EndIf
			If nz == 1
				Replace HA_PRODSHW With cProduto
				Replace HA_OPCSHW  With cOpc
				Replace HA_REVSHW  With cRevisao
			EndIf
		Else
			dbSelectArea("SHA")
			Reclock("SHA",.F.)
		EndIf
		If cTipo711 == Str(nz,1)
			FieldPut(nPosCampo,FieldGet(nPosCampo)+nQuant)
		EndIf
		// Obtem Entradas
		If nz <= 2
			nEntrada+=FieldGet(nPosCampo)
			// Obtem Saidas
		ElseIf nz == 3
			nSaida+=FieldGet(nPosCampo)
			// Obtem Saida pela estrutura
		ElseIf nz == 4
			nSaidaEstr+=FieldGet(nPosCampo)
			// Obtem Saldo
		ElseIf nz == 5
			// Calcula Saldo Atual e Necessidade
			nSaldoAtu:=nEntrada-nSaida-nSaidaEstr
			FieldPut(nPosCampo,nSaldoAtu)
			// Calcula necessidade
		ElseIf nz == 6
			If aPergs711[26] == 3
				nEstSeg := CalcEstSeg( RetFldProd(SB1->B1_COD,"B1_ESTFOR") )
			EndIf
			If aPergs711[31] == 1
				nPontoPed := RetFldProd(SB1->B1_COD,"B1_EMIN")
			EndIf
			If !Empty(nPontoPed)
				nPontoPed++
			EndIf
			If QtdComp(nSaldoAtu - (nEstSeg+nPontoPed)) < QtdComp(0)
				nNecessidade:=u_XA711Lote(ABS( (nEstSeg+nPontoPed) - nSaldoAtu),cProduto)
				nNecessidade:=u_XA711NecMax(cProduto, ABS( (nEstSeg+nPontoPed) - nSaldoAtu), nNecessidade)
				nNovoSalIni:=nNecessidade+nSaldoAtu
			Else
				nNecessidade:=0
				nNovoSalIni :=nSaldoAtu
			EndIf
			FieldPut(nPosCampo,nNecessidade)
		EndIf
	Next nz
	MsUnlock()
	If lMT710SHA
		ExecBlock("MT710SHA",.F.,.F.,{cProduto,cPeriodo,nQuant,cTipo711,nQuantPer})
	EndIf
	// Chama funcao que recalcula saldo
	u_XMA711Recalc(cProduto,cOpc,cRevisao,cPeriodo,nNovoSalIni,.T.)
Else
	For nz:=1 to 6
		If !lUsaMOpc
			lExiste:= dbSeek(xFilial("SHA")+cProduto+cOpc+cRevisao+Str(nz,1))
		Else 
			lExiste:= MOpcSeek("SHA",1,,cProduto,,cOpc,cRevisao,Str(nz,1))
		EndIf
		// Inclui registros caso necessario
		If !lExiste
			dbSelectArea("SHA")
			Reclock("SHA",.T.)
			Replace HA_FILIAL  With xFilial("SHA")
			Replace HA_PRODUTO With cProduto
			Replace HA_OPC     With cOpc
			Replace HA_REVISAO With cRevisao
			Replace HA_NIVEL   With cNivelEstr
			Replace HA_TIPO    With Str(nz,1)
			Replace HA_TEXTO   With aTexto[nz]
			Replace	HA_NUMMRP  With c711NumMRP
			If lUsaMOpc
				Replace HA_MOPC  With cOpcOri
				Replace HA_OPCORD  With cOpc
			EndIf
			If nz == 1
				Replace HA_PRODSHW With cProduto
				Replace HA_OPCSHW  With cOpc
				Replace HA_REVSHW  With cRevisao
			EndIf
		Else
			dbSelectArea("SHA")
			Reclock("SHA",.F.)
		EndIf
		If cTipo711 == Str(nz,1)
			FieldPut(nPosCampo,FieldGet(nPosCampo)+nQuant)
		EndIf
		MsUnlock()
		If lMT710SHA
			ExecBlock("MT710SHA",.F.,.F.,{cProduto,cPeriodo,nQuant,cTipo711,nQuantPer})
		EndIf
	Next nz
EndIf
RestArea(aAreaSHA)
dbSelectArea(cAlias)
RETURN

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³A711ExplEs³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 14/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Explode a estrutura do produto no MRP                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do produto a ser explodido                  ³±±
±±³          ³ ExpC2 = Opcionais utilizados                               ³±±
±±³          ³ ExpC3 = Revisao Estrutura                                  ³±±
±±³          ³ ExpN1 = Quantidade base a ser explodida                    ³±±
±±³          ³ ExpC3 = Periodo da necessidade do produto                  ³±±
±±³          ³ ExpC4 = String com tipos a serem processados               ³±±
±±³          ³ ExpC5 = String com grupos a serem processados              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA710                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function A711ExplEs(cProduto,cOpcionais,cRevisao,nQuant,cPeriodo,cParStrTipo,cParStrGrupo,aOpc)
Local aDados 	 := {}
Local aArea	 	 := GetArea()
Local aAreaSHA	 := SHA->(GetArea())
Local nQuantItem := 0
Local nSaldoMP	 := 0
Local nQuantParc := 0
Local nRegFan	 := 0
Local dDataNes 	 := dDataBase
Local nPrazoEnt	 := CalcPrazo(cProduto,nQuant,,,.F.,aPeriodos[Val(cPeriodo)])
Local cNivelStr	 := "99"
Local cRev711Vaz := CriaVar("B1_REVATU",.F.)
Local lCompNeg	 := .F.
Local lMT710EXP	 := .T.
Default aOpc := {}

If ValType(cParStrTipo) == "C"
	cStrTipo:=cParStrTipo
EndIf

If ValType(cParStrGrupo) == "C"
	cStrGrupo:=cParStrGrupo
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o movimento esta dentro do periodo    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(cPeriodo)
	dDataNes := aPeriodos[Val(cPeriodo)]
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona no produto desejado                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SG1")
	dbSetOrder(1)
	dbSeek(xFilial("SG1")+cProduto)
	While !Eof() .And. G1_FILIAL+G1_COD == xFilial("SG1")+cProduto
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Filtra componentes nao utilizados                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !U_XM711AvalProd(SG1->G1_COMP,cStrTipo,cStrGrupo)
			dbSelectArea("SG1")
			dbSkip()
			Loop
		EndIf
		SB1->(MsSeek(xFilial("SB1")+SG1->G1_COMP))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza necessidade dos componentes da estrutura  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	   	nQuantItem := ExplEstr(nQuant,dDataNes-nPrazoEnt,cOpcionais,cRevisao)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o componente tem quantidade negativa   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lCompNeg:=QtdComp(nQuantItem,.T.)<QtdComp(0,.T.)
		dbSelectArea("SG1")
		If (QtdComp(nQuantItem) == QtdComp(0))
			dbSkip()
			Loop
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica informacoes de maneira diferenciada quando produto  ³
		//³ utiliza controle de potencia identificada na estrutura.      ³
		//³ Converte a quantidade necessaria sempre baseado na POTENCIA  ³
		//³ MAXIMA (100%)                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(SG1->G1_POTENCI) .And. PotencLote(SG1->G1_COMP) .And. QtdComp(nQuantItem) > QtdComp(0)
			nQuantItem:=nQuantItem*(SG1->G1_POTENCI/100)
		EndIf
		nRegFan   := SG1->(Recno())
		If dbSeek(xFilial("SG1")+SG1->G1_COMP)
			cTipo711 := "F"
			cNivelStr:=SG1->G1_NIV
		Else
			cTipo711  := "C"
			cNivelStr :="99"
		EndIf
		SG1->(dbGoTo(nRegFan))
		If RetFldProd(SB1->B1_COD,"B1_FANTASM") == "S" .Or. (cTipo711 == "F" .And. !lGeraPI)
			If lPEMT710EXP
				lMT710EXP := ExecBlock("MT710EXP",.F.,.F.,{SG1->G1_COMP,cOpcionais,cRevisao,nQuantItem})
				If ValType(lMT710EXP) # "L"
					lMT710EXP := .T.
				EndIf
			EndIf
			If lMT710EXP
				A711ExplEs(SG1->G1_COMP,cOpcionais,cRevisao,nQuantItem,A650DtoPer(SomaPrazo(dDataNes,-nPrazoEnt)),cStrTipo,cStrGrupo)
			EndIf
		ElseIf QtdComp(nQuantItem,.T.) # QtdComp(0,.T.)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ponto de Entrada M710QTDE - Necessidade do Produto ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lM710Qtde
				nQtdRet := ExecBlock( "M710QTDE", .F., .F., { cProduto, nQuantItem, dDataNes } )
				If ValType(nQtdRet) == "N"
					nQuantItem := nQtdRet
				EndIf
			EndIf

			//-- Avalia saldo do componente para verificar alternativos
			nSaldoMP := A710SldSHA(SG1->G1_COMP,cPeriodo,Space(Len(SG1->(G1_GROPC+G1_OPC))),SB1->B1_REVATU)
			
			//-- Gera SH5 para uso do saldo (seja parcial ou integral)
			If (lCompNeg .Or. (nQuantItem > 0 .And. nSaldoMP > 0))
				//-- Quantidade a gerar no SH5
				nQuantParc := If(lCompNeg,nQuantItem,Min(nSaldoMP,nQuantItem))
				
				//-- Gera log MRP e SH5
				aDados := {SG1->G1_COD,nQuantParc,SomaPrazo(dDataNes,-nPrazoEnt)}
				u_XA710CriaLOG("004",SG1->G1_COMP,aDados,lLogMRP,c711NumMrp)
				A711CriSH5(SomaPrazo(dDataNes,-nPrazoEnt),SG1->G1_COMP,cOpcionais,cRevisao,If(lCompNeg,"ENG","SHA"),0,SG1->G1_COD,"","",ABS(nQuantParc),If(lCompNeg,"2","4"),.F.,nil,nil,.F.,.T.,nil,nil,nil,cParStrTipo,cParStrGrupo,nPrazoEnt,,aOpc)
			
				//-- Avalia se o produto eh utilizado na tabela SGI como original ou alternativo
				If A710ExSGI(SG1->G1_COMP)
					//-- Avalia se o produto não foi utilizado como alternativo em data futura e troca
					A710AvSldA(SG1->G1_COMP,cPeriodo,cRev711Vaz,cParStrTipo,cParStrGrupo,SomaPrazo(dDataNes,-nPrazoEnt))
				EndIf
			EndIf
			
			//-- Se nao componente negativo e ficou saldo a gerar na SH5, tenta usar componentes
			If !lCompNeg .And. nSaldoMP < nQuantItem
				//-- Quantidade a procurar os alternativos
				nQuantParc := nQuantItem - Max(nSaldoMP,0)
				
				//-- Avalia existencia de saldo e possivel utilizacao de alternativos (SGI)
				nQuantItem := A710VerAlt(SG1->G1_COMP,SG1->G1_COD,cPeriodo,nQuantParc,cParStrTipo,cParStrGrupo,cRev711Vaz,dDataNes,nPrazoEnt,cOpcionais)
				
				//-- Gera Log MRP e SH5 da sobra (o que nao atendeu por alternativo)
				If nQuantItem > 0
					aDados := {SG1->G1_COMP,nQuantItem,SomaPrazo(dDataNes,-nPrazoEnt)}
					u_XA710CriaLOG("004",SG1->G1_COMP,aDados,lLogMRP,c711NumMrp)
					A711CriSH5(SomaPrazo(dDataNes,-nPrazoEnt),SG1->G1_COMP,cOpcionais,cRevisao,"SHA",0,SG1->G1_COD,"","",nQuantItem,"4",.F.,nil,nil,.F.,.T.,nil,nil,nil,cParStrTipo,cParStrGrupo,nPrazoEnt,,aOpc)
				EndIf
			EndIf
		EndIf
		dbSelectArea("SG1")
		dbSkip()
	Enddo
EndIf
RestArea(aAreaSHA)
RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MT711Tree ³ Autor ³Rodrigo de A Sartorio  ³ Data ³ 14/08/02   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao que monta o Tree do MRP                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³lResumido  Monta Array resumido somente com os produtos       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA710                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MT711Tree(lResumido,oCenterPanel,lVisualiza)
Local aArea	     := GetArea()
Local nAchouTot  := 0
Local i          := 0
Local nX         := 0
Local nY         := 0
Local nPos       := 0
Local nRetry_0   := 0
Local nRetry_1   := 0
Local nRetry_2   := 0
Local nHd1       := 0
Local nHd2       := 0
Local lInJob     := SuperGetMv('MV_A710THR',.F.,1) > 1
Local cStartPath := GetSrvProfString("Startpath","")
Local cJobFile   := ""
Local cJobAux    := ""
Local cFileTotal := ""
Local cFileTree  := ""
Local cLinha     := ""
Local aNewTotal  := {}
Local aNewDbTree := {}
Local aThreads   := {}
Local aJobAux    := {}
Local lThrSeq    := SuperGetMV("MV_THRSEQ",.F.,.F.)
Local nTamProd   := TamSX3("B1_COD"		)[1]
Local nTamOpc    := IIf(lUsaMOpc,80,TamSX3("C2_OPC")[1])
Local nTamRev    := TamSX3("B1_REVATU")[1]
Local nTamCod    := nTamProd+IIf(lUsaMOpc,80,nTamOpc)+nTamRev
Local nTamDocRev := Len(SC2->C2_REVISAO)
Local nTamDoc    :=nTamProd
Local nTamRecno  := 12
Local nTamQuant  := 18
Local nTamPer    := 3
Local nTamAlias  := 3
Local nTamTipo   := 1

Default lResumido  := .F.
Default lVisualiza := .F.

aDbTree := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza o log de processamento			    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcLogAtu("MENSAGEM","Iniciando Montagem do Tree do MRP","Iniciando Montagem do Tree do MRP")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Execucao da montagem da Tela em Threads     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lVisualiza .And. lInJob .And. !lResumido

	//-- Calcula Quebra por Threads
	aThreads := A710QtdThread()
	ProcRegua(((Len(aThreads)*2) + 8))

	For nX:=1 to Len(aThreads)

		IncProc()

		// Informacoes do semaforo
		cJobFile:= cStartPath + CriaTrab(Nil,.F.)+".job"

		// Adiciona o nome do arquivo de Job no array aJobAux
		aAdd(aJobAux,{StrZero(nX,2),cJobFile})

		// Arquivo de totalizadores
		cFileTotal := "TO"+cEmpAnt+cFilAnt+StrZero(nX,2)+".job"

		// Arquivo do DbTree
		cFileTree := "TR"+cEmpAnt+cFilAnt+StrZero(nX,2)+".job"

		// Inicializa variavel global de controle de thread
		cJobAux:="c710T"+cEmpAnt+cFilAnt+StrZero(nX,2)
		PutGlbValue(cJobAux,"0")
		GlbUnLock()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o log de processamento			    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ProcLogAtu("MENSAGEM","Iniciando Montagem do Tree do MRP - Thread:" + StrZero(nX,2),"Iniciando Montagem do Tree do MRP - Thread:" + StrZero(nX,2))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Dispara thread para Stored Procedure        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		StartJob("U_XA710JobTree",GetEnvServer(),lThrSeq,cEmpAnt,cFilAnt,{aThreads[nx,1,1],aThreads[nX,1,Len(aThreads[nX,1])]},cJobFile,StrZero(nX,2),cFileTotal,cFileTree,lUsaMOpc)

	Next nX

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Controle de Seguranca para MULTI-THREAD                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX:=1 to Len(aThreads)

		nRetry_0 := 0
		nRetry_1 := 0
		
		nPos := ASCAN(aJobAux,{|x| x[1] == StrZero(nX,2)})

		// Arquivo de totalizadores
		cFileTotal := "TO"+cEmpAnt+cFilAnt+StrZero(nX,2)+".job"

		// Arquivo do DbTree
		cFileTree := "TR"+cEmpAnt+cFilAnt+StrZero(nX,2)+".job"

		// Informacoes do semaforo
		cJobFile:= aJobAux[nPos,2]

		// Inicializa variavel global de controle de thread
		cJobAux:="c710T"+cEmpAnt+cFilAnt+StrZero(nX,2)

		While .T.
			Do Case
				// TRATAMENTO PARA ERRO DE SUBIDA DE THREAD
				Case GetGlbValue(cJobAux) == '0'
					If nRetry_0 > 50
//						Conout(Replicate("-",65))				  												 	//"-----------------------------------------------------"
//						Conout("MATA710: "+ "Não foi possivel realizar a subida da thread" + " " + StrZero(nX,2) )	//"MATA710: Não foi possivel realizar a subida da thread"
//						Conout(Replicate("-",65))  																	//"-----------------------------------------------------"
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Atualiza o log de processamento			    ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						ProcLogAtu("MENSAGEM","Não foi possivel realizar a subida da thread","Não foi possivel realizar a subida da thread")	//"Não foi possivel realizar a subida da thread"
						Final("Não foi possivel realizar a subida da thread") 						  											//"Não foi possivel realizar a subida da thread"
					Else
						nRetry_0 ++
					EndIf
				// TRATAMENTO PARA ERRO DE CONEXAO
				Case GetGlbValue(cJobAux) == '1'
					If FCreate(cJobFile) # -1
						If nRetry_1 > 5
//							Conout(Replicate("-",65)) 						//"------------------------------------------------"
//							Conout("MATA710: Erro de conexao na thread") 	//"MATA710: Erro de conexao na thread"
//							Conout("Thread numero : " + StrZero(nX,2) )		//"Thread numero : "
//							Conout("Numero de tentativas excedidas")		//"Numero de tentativas excedidas"
//							Conout(Replicate("-",65))  						//"------------------------------------------------"
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Atualiza o log de processamento			    ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							ProcLogAtu("MENSAGEM","MATA710: Erro de conexao na thread","MATA710: Erro de conexao na thread")	//"MATA710: Erro de conexao na thread"
							Final("MATA710: Erro de conexao na thread")										   					//"MATA710: Erro de conexao na thread"
						EndIf
						nRetry_1 ++
					EndIf
				// TRATAMENTO PARA ERRO DE APLICACAO
				Case GetGlbValue(cJobAux) == '2'
					If FCreate(cJobFile) # -1
//						Conout(Replicate("-",65))										//"-------------------------------------------------"
  //						Conout("MATA710: Erro de aplicacao na thread ")					//"MATA710: Erro de aplicacao na thread"
	 //					Conout("Thread numero : "+StrZero(nX,2))						//"Thread numero : "
		//				Conout(Replicate("-",65))  										//"--------------------------------------------------"
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Atualiza o log de processamento			    ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						ProcLogAtu("MENSAGEM","MATA710: Erro de aplicacao na thread","MATA710: Erro de aplicacao na thread")	//"MATA710: Erro de aplicacao na thread"
						Final("MATA710: Erro de aplicacao na thread") 						   									//"MATA710: Erro de aplicacao na thread"
					EndIf
				// THREAD PROCESSADA CORRETAMENTE
				Case GetGlbValue(cJobAux) == '3'
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualizacao do Array aTotais                ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If File(cFileTotal) .And. ((nHdl:=FOpen(cFileTotal,FO_READWRITE)) > 0)
						// Fecha o arquivo para utilizacao da função FT_USE						
						fClose(nHd1)
						// Reinicia o array de Totais
						aNewTotal := {}
						// Abertura do arquivo de trabalho
						FT_FUse( cFileTotal )
						// Criacao do array aNewTotal						
						FT_FGOTOP()
						While !FT_FEof()
						   cLinha := FT_FREADLN()
						   AADD( aNewTotal, {	SubStr( cLinha,  1								, nTamCod	)	,;
					   						    SubStr( cLinha, nTamCod+1						, nTamPer 	)	,;
					   						    SubStr( cLinha, nTamCod+nTamPer+1				, nTamAlias ) 	,;
						   			  	   Val( SubStr( cLinha, nTamCod+nTamPer+nTamAlias+1		, 18 ) ) } )
						   FT_FSKIP()
						EndDo
						FT_FUSE()
						// Atualiza o array aTotais com o valores calculados pela Thread					
                        For nY := 1 to Len(aNewTotal)
							aAdd(aTotais[1],{aNewTotal[nY,1],aNewTotal[nY,2],aNewTotal[nY,3],aNewTotal[nY,4]})							
                        Next nY
					Else
						Final("MATA710: Erro de abertura no arquivo de Totais") //"MATA710: Erro de abertura no arquivo de Totais"
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualizacao do Array aDbTree                ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If File(cFileTree) .And. ((nHd2:=FOpen(cFileTree,FO_READWRITE)) > 0)
						// Fecha o arquivo para utilizacao da função FT_USE						
						fClose(nHd2)
						// Reinicia o array de Totais
						aNewDbTree := {}
						// Abertura do arquivo de trabalho
						FT_FUse( cFileTree )
						// Criacao do array aNewDbTree						
						FT_FGOTOP()
						While !FT_FEof()
						   cLinha := FT_FREADLN()

						   AADD( aNewDbTree, {	SubStr( cLinha,  1																, nTamProd		)	,;
					   						    SubStr( cLinha, nTamProd+1														, nTamOpc 		)	,;
					   						    SubStr( cLinha, nTamProd+nTamOpc+1												, nTamRev		) 	,;
					   						    SubStr( cLinha, nTamProd+nTamOpc+nTamRev+1										, nTamAlias 	) 	,;
					   						    SubStr( cLinha, nTamProd+nTamOpc+nTamRev+nTamAlias+1							, nTamTipo 		) 	,;
					   						    SubStr( cLinha, nTamProd+nTamOpc+nTamRev+nTamAlias+nTamTipo+1					, nTamDoc 		) 	,;
					   						    SubStr( cLinha, nTamProd+nTamOpc+nTamRev+nTamAlias+nTamTipo+nTamDoc+1			, nTamRecno 	) 	,;
					   						    SubStr( cLinha, nTamProd+nTamOpc+nTamRev+nTamAlias+nTamTipo+nTamDoc+nTamRecno+1, nTamDocRev 	) } )	

						   FT_FSKIP()
						EndDo
						FT_FUSE()
						// Atualiza o array aDbTree com os dados do aNewDbTree
						If Len(aNewDbTree) > 0
                          For nY := 1 to Len(aNewDbTree)
                          	aAdd(adbTree,aNewDbTree[nY])
                          Next nY
						EndIf
					Else
						Final("MATA710: Erro de abertura no arquivo de Tree") //"MATA710: Erro de abertura no arquivo de Tree"
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza o log de processamento			    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					ProcLogAtu("MENSAGEM","Termino da Montagem do Tree do MRP - Thread:" + StrZero(nX,2),"Termino da Montagem do Tree do MRP - Thread:"+ StrZero(nX,2))
					IncProc()
					Exit
			EndCase
			Sleep(2500)
		End
	Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Execucao da montagem da Tela Padrao         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Else
	// Verifica todos produtos utilizados pelo arquivo de resumo ou de detalhe
	If lResumido
		dbSelectArea("SH5")
		dbSetOrder(1)
		dbSelectArea("SHA")
		If (oCenterPanel==Nil)
			ProcRegua(LastRec())
		Else
			oCenterPanel:SetRegua1(SH5->(LastRec()))
		EndIf
		dbSetOrder(1)
		dbGotop()
		While !Eof()
			If (oCenterPanel==Nil)
				IncProc()
			Else
				oCenterPanel:IncRegua1(OemToAnsi(STR0129))
			EndIf
			If !lUsaMopc
				If SH5->(dbSeek(xFilial("SHA")+SHA->HA_PRODUTO+SHA->HA_OPC+SHA->HA_REVISAO))
					// Estrutura do array
					// Produto
					// Opcional
					// Revisao
					// Alias
					// Tipo
					// Documento
					// Recno
					// DocRev
					//                  01              02          03               04             05         06           07                         08
					AADD(aDbTree,{SH5->H5_PRODUTO,SH5->H5_OPC,SH5->H5_REVISAO,SH5->H5_ALIAS,SH5->H5_TIPO,SH5->H5_DOC,StrZero(SH5->(Recno()),12),SH5->H5_DOCREV})
				EndIf
			Else 
				If MOpcSeek("SH5",1,,SHA->HA_PRODUTO,,SHA->HA_OPC,SHA->HA_REVISAO)
					AADD(aDbTree,{SH5->H5_PRODUTO,SH5->H5_OPC,SH5->H5_REVISAO,SH5->H5_ALIAS,SH5->H5_TIPO,SH5->H5_DOC,StrZero(SH5->(Recno()),12),SH5->H5_DOCREV})
				EndIf
			EndIf
			dbSelectArea("SHA")
			dbSkip(6)
		End
		If (oCenterPanel<>Nil)
			oCenterPanel:IncRegua2()
		EndIf
	Else

		//-- Zera os valores para recalculo do produto posicionado
		aTotais := {{}}
		
		dbSelectArea("SH5")
		If (oCenterPanel==Nil)
			ProcRegua(LastRec())
		Else
			oCenterPanel:SetRegua1(SH5->(LastRec()))
		EndIf
		dbSetOrder(1)
		dbGotop()
		While !Eof()
			If (oCenterPanel==Nil)
				IncProc()
			Else
				oCenterPanel:IncRegua1(OemToAnsi(STR0129))
			EndIf
			If H5_ALIAS # "PAR"
				// Estrutura do array
				// Produto
				// Opcional
				// Revisao
				// Alias
				// Tipo
				// Documento
				// Recno
				// DocRev
				//                  01              02          03               04             05         06           07                         08
				//AADD(aDbTree,{SH5->H5_PRODUTO,SH5->H5_OPC,SH5->H5_REVISAO,SH5->H5_ALIAS,SH5->H5_TIPO,SH5->H5_DOC,StrZero(SH5->(Recno()),12),SH5->H5_DOCREV})
				AADD(aDbTree,{SH5->H5_PRODUTO,IIf(lUsaMOpc,IIf(Len(SH5->H5_OPC)<80,PADR(SH5->H5_OPC,80),SH5->H5_OPC),SH5->H5_OPC),SH5->H5_REVISAO,SH5->H5_ALIAS,SH5->H5_TIPO,SH5->H5_DOC,StrZero(SH5->(Recno()),12),SH5->H5_DOCREV})
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Adiciona registro em array totalizador utilizado no TREE  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Len(aTotais[Len(aTotais)]) > 4095
					AADD(aTotais,{})
				EndIf
				For i:=1 to Len(aTotais)
					nAchouTot:=ASCAN(aTotais[i],{ |x| x[1] == H5_PRODUTO+H5_OPC+H5_REVISAO .And. x[2] == H5_PER .And. x[3] == H5_ALIAS})
					If nAchouTot != 0
						aTotais[i,nAchouTot,4] += H5_QUANT
						Exit
					EndIf
				Next i
				If nAchouTot ==0
					AADD(aTotais[Len(aTotais)],{H5_PRODUTO+IIf(Len(H5_OPC)<80,PADR(H5_OPC,80),H5_OPC)+H5_REVISAO,H5_PER,H5_ALIAS,H5_QUANT})
				EndIf
			EndIf
			dbSkip()
		End
		If (oCenterPanel<>Nil)
			oCenterPanel:IncRegua2()
		EndIf
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza o log de processamento			    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcLogAtu("MENSAGEM","Termino da Montagem Tree do MRP","Termino da Montagem Tree do MRP")

u_xA710GrvTm(oCenterPanel,STR0141) //"Termino da Montagem da Arvore de Produtos (Tree)."
ASORT(aDbTree,,,{|x,y| x[1]+x[2]+x[3]+x[4]+x[5] < y[1]+y[2]+y[3]+y[4]+y[5]})
A711AdTree(.T.,aDbTree,lResumido)
u_xA710GrvTm(oCenterPanel,STR0142) //"FIM - Termino da Montagem da Tela"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza o log de processamento			    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcLogAtu("MENSAGEM","Termino a Montagem da Tela do MRP","Termino a Montagem da Tela do MRP")

RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MT711DlgV ³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 14/08/02   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao que mostra as informacoes detalhadas da consulta       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³aEnch      Array com os objetos a serem apresentados          ³±±
±±³          ³aPos       Array com as coordenadas utilizadas na apresentacao³±±
±±³          ³nOldEnch   Variavel com o objeto anteriormente apresentado    ³±±
±±³          ³oSay       Objeto com a descricao do produto                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA710                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MT711DlgV(aEnch,aPos,nOldEnch,oSay1,oSay2)
Local cTipo711		:= SubStr(oTreeM711:GetCargo(),1,2)
Local nRecno		:= Val(SubStr(oTreeM711:GetCargo(),3,12))
Local cAliasPos		:= ''
Local aTamQuant		:= TamSX3("B2_QFIM")
Local lOneColumn	:= If(aPos[4]-aPos[2]>312,.F.,.T.)
LOCAL aTexto		:= {}
LOCAL aAdPeriodos	:={},aTextoVazio:=Array(Len(aPeriodos))
LOCAL i,z			:= 0
Local nPosAlias		:= 0
Local w				:= 0
Local nPosTree		:= 0
Local nAchouTot     := 0
Local desc1
Local desc2

PRIVATE cProdShow	:= ''
PRIVATE cOpcShow	:= ''
PRIVATE cRevisao	:= ''
PRIVATE cBotFun		:= ''
PRIVATE cTopFun		:= ''
PRIVATE aRotina		:= { {" "," ", 0 , 2}}

//Possiciona array do tree
nPosTree	:= AsCan(aDbTree,{|x| x[7]==SubStr(oTreeM711:GetCargo(),3,12)})

//Inicializa variaveis
If nPosTree > 0
	cAliasPos	:= aDbTree[nPosTree,4]
	cProdShow	:= aDbTree[nPosTree,1]
	cOpcShow	:= aDbTree[nPosTree,2]
	cRevisao	:= aDbTree[nPosTree,3]
	
	// Preenche descricao do produto		
	if Len((Posicione('SB1',1,xFilial('SB1')+cProdShow,"B1_DESC"))) > 30
	   desc1 := SubStr((Posicione('SB1',1,xFilial('SB1')+cProdShow,"B1_DESC")),1,30)	   
	   desc2 := SubStr((Posicione('SB1',1,xFilial('SB1')+cProdShow,"B1_DESC")),31,20)
	   oSay1:SetText(desc1)
	   oSay2:SetText(desc2)	   
	else
	   oSay1:SetText(Posicione('SB1',1,xFilial('SB1')+cProdShow,"B1_DESC"))
	End if		
	
	//Atualiza com o produto posicionado
	cProdDetSld := cProdShow
Else
	cTipo711 := "00"
EndIf

// Monta Numero de Colunas de acordo com numero de periodos
AFILL(aTextoVazio,"")

MsFreeObj(@oPanelM711 , .T.)
MsFreeObj(@oScrollM711, .T.)

// SCROLL BOX com texto vazio ou totalizador por tipo de documento
If cTipo711 == "00"
	//Limpa conteudo de variavel
	cProdDetSld := ""

	oSay1:SetText("")
	oPanelM711:Hide()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta array com os campos a serem utilizados no Browse       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCampos:={{"HA_TEXTO","",STR0038,16}} //"Tipo"
	AADD(aCampos,{"HA_PRODSHW","",STR0025,LEN(SHA->HA_PRODSHW)}) //"Produtos"
	AADD(aCampos,{"HA_OPCSHW","",STR0058,LEN(SHA->HA_OPCSHW)}) //"Opcionais"
	If A710TrataRev()
		Aadd(aCampos,{"HA_REVSHW","",STR0081, 4}) //"Revisao"
	Endif
	For i := 1 to Len(aPeriodos)
		AADD(aCampos,{"HA_PER"+StrZero(i,3),cPictQuant,DtoC(aPeriodos[i]) + " (" + DiaSemana(aPeriodos[i], 3) + ")",aTamQuant[1]+2})
	Next i
	dbSelectArea("SHA")
    If !lUsaMOpc
		dbSetOrder(1)
	Else
		dbSetOrder(3)
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta browse de todos os produtos                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nOldEnch:=1
	aEnch[nOldEnch]:=MaMakeBrow(oPanelM711,"SHA",{aPos[1],aPos[2],aPos[4],aPos[3]-2},,.F.,aCampos,,cTopFun,cBotFun,NIL,NIL,2)
	// Posiciona no primeiro registro
	SHA->(dbGotop())
	// Refaz browse com informacoes de todos os produtos
	oPanelM711:Refresh()
	oPanelM711:Show()
	// Browse com a projecao do produto
ElseIf cTipo711 == "01"
	oPanelM711:Hide()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta array com os campos a serem utilizados no Browse       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cBotFun   := PutAspas(xFilial('SHA')+cProdShow+cOpcShow+cRevisao)
	cTopFun   := PutAspas(xFilial('SHA')+cProdShow+cOpcShow+cRevisao)
	aCampos:={{"HA_TEXTO","",STR0038,16}} //"Tipo"
	For i := 1 to Len(aPeriodos)
		AADD(aCampos,{"HA_PER"+StrZero(i,3),cPictQuant,DtoC(aPeriodos[i]),aTamQuant[1]+2})
	Next i
	dbSelectArea("SHA")
	If !lUsaMOpc
		dbSetOrder(1)
	Else 
		dbSetOrder(3)
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta browse referente a esse produto                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nOldEnch:=1
	aEnch[nOldEnch]:=MaMakeBrow(oPanelM711,"SHA",{aPos[1],aPos[2],aPos[4],aPos[3]-2},,.F.,aCampos,,cTopFun,cBotFun,NIL,NIL,1)

	// Posiciona no primeiro registro desse produto
	If !lUsaMOpc
		SHA->(dbSeek(xFilial("SHA")+cProdShow+cOpcShow+cRevisao))
	Else
		MOpcSeek("SHA",1,,cProdShow,,cOpcShow,cRevisao)		
	EndIf

	// Posiciona no primeiro registro
	SHA->(dbGotop())

	// Refaz browse com informacoes desse produto
	oPanelM711:Refresh()
	oPanelM711:Show()
ElseIf cTipo711 == "02"
	// Procura totalizadores por tipo de documento para esse produto+opcional
	aAdPeriodos:=ACLONE(aTextoVazio)
	// Coloca na primeira coluna texto
	aAdPeriodos[1]:=STR0037 //"Totais"
	AADD(aTexto,aAdPeriodos)
	aAdPeriodos:=ACLONE(aTextoVazio)
	// Coloca data nas colunas
	For w:=1 to Len(aPeriodos)
		aAdPeriodos[w]:=DTOC(aPeriodos[w])
	Next w
	AADD(aTexto,aAdPeriodos)
	aAdPeriodos:=ACLONE(aTextoVazio)
	// Monta os valores de acordo com os periodos
	For z:=1 to Len(aPeriodos)
		For i:=1 to Len(aTotais)
			nAchouTot:=ASCAN(aTotais[i],{ |x| x[1] == cProdShow+cOpcShow+cRevisao .And. x[2] == StrZero(z,3) .And. x[3] == cAliasPos})
			If nAchouTot != 0
				aAdPeriodos[z]:=Transform(aTotais[i,nAchouTot,4],cPictQuant)
				Exit
			Else
				aAdPeriodos[z]:=Transform(0, cPictQuant)
			EndIf
		Next i
	Next z
	AADD(aTexto,aAdPeriodos)
	aAdPeriodos:=ACLONE(aTextoVazio)
	// Coloca na primeira coluna texto
	aAdPeriodos[1]:= STR0065 //"Data Limite para Compra / Producao"
	AADD(aTexto,aAdPeriodos)
	aAdPeriodos:=ACLONE(aTextoVazio)
	// Coloca data limite nas colunas de acordo com as datas especificadas
	For z:=1 to Len(aPeriodos)
		For i:=1 to Len(aTotais)
			nAchouTot:=ASCAN(aTotais[i],{ |x| x[1] == cProdShow+cOpcShow+cRevisao .And. x[2] == StrZero(z,3) .And. x[3] == cAliasPos})
			If nAchouTot != 0
				aAdPeriodos[z]:=DTOC(SomaPrazo(aPeriodos[z], - CalcPrazo(cProdShow,aTotais[i,nAchouTot,4],,,.F.,aPeriodos[z])))
				Exit
			Else
				aAdPeriodos[z]:=""
			EndIf
		Next i
	Next z
	AADD(aTexto,aAdPeriodos)
	MatScrDisp(aTexto,@oScrollM711,@oPanelM711,{aPos[1],aPos[2],Round(aPos[3],0)-3,aPos[4]},NIL,{{2,CLR_RED},{4,CLR_GREEN}})
	nOldEnch:=2
	aEnch[nOldEnch]:=oScrollM711
	// Detalhe dos documentos
ElseIf cTipo711 == "03"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta MSMGET para apresentar dados detalhados                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SH5")
	MsGoto(nRecno)
	cAliasPos:=SH5->H5_ALIAS
	nRecPos:=SH5->H5_RECNO
	// Necessidade relacionada a estrutura
	If cAliasPos == "SHA"
		aTexto:={{STR0040,SH5->H5_DOC}}
		AADD(aTexto,{lTrim(STR0030),Str(SH5->H5_QUANT,aTamQuant[1],aTamQuant[2])})
		AADD(aTexto,{STR0041,DTOC(aPeriodos[Val(SH5->H5_PER)])})
		MatScrDisp(aTexto,@oScrollM711,@oPanelM711,{aPos[1],aPos[2],Round(aPos[3],0)-3,aPos[4]},{{1,CLR_RED}})
		nOldEnch:=3
		aEnch[nOldEnch]:=oScrollM711
	// Quantidade negativa na estrutura
	ElseIf cAliasPos $ "ENG/SBP"
		aTexto:={{STR0084,SH5->H5_DOC}}
		AADD(aTexto,{lTrim(STR0073),Str(SH5->H5_QUANT,aTamQuant[1],aTamQuant[2])})
		AADD(aTexto,{STR0041,DTOC(aPeriodos[Val(SH5->H5_PER)])})
		MatScrDisp(aTexto,@oScrollM711,@oPanelM711,{aPos[1],aPos[2],Round(aPos[3],0)-3,aPos[4]},{{1,CLR_RED}})
		nOldEnch:=3
		aEnch[nOldEnch]:=oScrollM711
	ElseIf cAliasPos == "SB1" .And. SBZ->(DbSeek(xFilial("SBZ")+SB1->B1_COD))
		nRecPos := Recno()
		RegToMemory("SBZ",.F.)
		MsMGet():New("SBZ",nRecPos,1,,,,,{aPos[1],aPos[2],Round(aPos[3],0)-3,aPos[4]},,3,,,,oPanelM711,,,lOneColumn)
	// MSMGET com detalhe do documento
	Else
		dbSelectArea(cAliasPos)
		dbGoto(nRecPos)
		RegToMemory(cAliasPos,.F.)
		MsMGet():New(cAliasPos,nRecPos,1,,,,,{aPos[1],aPos[2],Round(aPos[3],0)-3,aPos[4]},,3,,,,oPanelM711,,,lOneColumn)
	EndIf
EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³ CA711Troca                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Autor     ³ Rodrigo de Almeida Sartorio              ³ Data ³ 21/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Troca marcador entre x e branco                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³nIt        Linha onde o click do mouse ocorreu              ³±±
±±³           ³aArray     Array com as opcoes para selecao                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Uso      ³ MATA710                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CA711Troca(nIt,aArray)
aArray[nIt,1] := !aArray[nIt,1]
Return aArray

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A711Pesq ³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 21/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pesquisa por um determinado produto + opcional             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A711Pesq()
LOCAL cPrd711Vaz:=CriaVar("B1_COD",.F.)
LOCAL cOpc711Vaz:=CriaVar("C2_OPC",.F.)
LOCAL cRev711Vaz:=CriaVar("B1_REVATU",.F.)
Local cPesq := cPrd711Vaz+cOpc711Vaz+cRev711Vaz
Local oDlg,lCancel:=.F.
Local cOldCargo:=oTreeM711:GetCargo()
Local nPos
DEFINE MSDIALOG oDlg TITLE STR0033 From 145,0 To 270,400 OF oMainWnd PIXEL
@ 10,15 TO 40,185 LABEL STR0035 OF oDlg PIXEL	//"Produto + Opcional a Pesquisar "
@ 20,20 MSGET cPesq Picture "@!S25" OF oDlg PIXEL
DEFINE SBUTTON FROM 50,131 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg
DEFINE SBUTTON FROM 50,158 TYPE 2 ACTION (oDlg:End(),lCancel:=.T.) ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg
// PESQUISA NO TREE O CONTEUDO DIGITADO
If !lCancel .And. !Empty(cPesq)
	nPos := AsCan(aDbTree,{|x| x[1]+x[2]+x[3]==cPesq})
	If !Empty(nPos) .And. !oTreeM711:TreeSeek("01"+aDbTree[nPos,7]+StrZero(0,12))
		oTreeM711:TreeSeek(cOldCargo)
	Else
		Eval(oTreeM711:bChange)
	EndIf
EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³ A711Gera                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Autor     ³ Rodrigo de Almeida Sartorio              ³ Data ³ 22.08.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Gera OP/SC de acordo com os Periodos Selecionados          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³cNumOpDig  Numero da Op inicial a ser digitado pelo usuario ³±±
±±³           ³cStrTipo   String com tipos a serem processados             ³±±
±±³           ³cStrGrupo  String com grupos a serem processados            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Uso      ³ MATA710                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static FUNCTION A711Gera(cNumOpDig,cStrTipo,cStrGrupo)
LOCAL aSays:={},aButtons:={},nOpca:=0
LOCAL lOpMax99:=.T.
AADD(aSays,OemToAnsi(STR0044))
AADD(aSays,OemToAnsi(STR0045))
AADD(aSays,OemToAnsi(STR0046))
AADD(aButtons, { 1,.T.,{|o| nOpcA:= 1,If(MsgYesNo(OemToAnsi(STR0047),OemToAnsi(STR0043)),o:oWnd:End(),nOpcA:=2) } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
If aPergs711[4] == 2
	AADD(aButtons, { 5,.T.,{|o| cSelPerSC:=A711SelPer(cSelPerSc,STR0049,"SC",@cNumOpDig,@lOpMax99,@cSelFSC) }} )
	AADD(aButtons, { 5,.T.,{|o| cSelPer:=A711SelPer(cSelPer,STR0050,"OP",@cNumOpDig,@lOpMax99,@cSelF) }} )
Else
	AADD(aButtons, { 5,.T.,{|o| cSelPerSC:=cSelPer:=A711SelPer(cSelPer,STR0049+" / "+STR0050,"SCOP",@cNumOpDig,@lOpMax99,@cSelF) }} )
EndIf
If ! lBatch
	FormBatch(STR0043,aSays,aButtons,,200,450)
Else
	nOpca := 1
Endif

lDigNumOp := !Empty(cNumOpDig)

If nOpca == 1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Emite OP's e SC's                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Processa({|lEnd| u_XA711OPSC(cNumOpDig,lOpMax99,cStrTipo,cStrGrupo)},STR0051,OemToAnsi(STR0052),.F.)	//"Emite OPs e SCs"###"Emitindo OPs e SCs ..."
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ponto de Entrada apos criacao de OPs/SCs       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (ExistBlock("MTA710OPSC"))
		ExecBlock("MTA710OPSC",.F.,.F.,{cNumOpdig})
	EndIf
EndIf
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³ A711SelPer                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Autor     ³ Rodrigo de Almeida Sartorio              ³ Data ³ 22/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Seleciona periodo para geracao de OPs/SCs                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³cPer       Variavel com os periodos marcados/desmarcados    ³±±
±±³           ³cTitulo    Titulo a ser apresentado na DIALOG               ³±±
±±³           ³cTipo711   Tipo da Selecao - OP / SC / OP e SC              ³±±
±±³           ³cNumOpDig  Numero da Op inicial a ser digitado pelo usuario ³±±
±±³           ³lOpMax99   Indica se o maximo de itens por op e 99          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Uso      ³ MATA710                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A711SelPer(cPer,cTitulo,cTipo711,cNumOpDig,lOpMax99,cTpOP)

Local lOp        := "OP" $ cTipo711
Local lOpMaxDig  :=lOpMax99
Local aAlterGDa  := {}
Local aHeaderPER := {}
Local aColsPER   := {}
Local nOpca      := 0
Local nI
Local cNumOpGet  := cNumOpDig
Local cTitle	 :=OemToAnsi(STR0053+cTitulo)	//"Periodos para geracao de "
Local cSelPer
Local nSelec	 := 1
Local dDatDe  	 := dDataBase
Local dDatAte 	 := dDataBase
Local oChkInv
Local oGetPer
Local oDlgPer


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Divide cabeçalho                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSize := FwDefSize():New()
oSize:SetWindowSize({000,000,300,350})
oSize:AddObject( "NUMERO"  ,  100, 80, .T., .T.) // Dimensionavel
oSize:AddObject( "OP"      ,  100, 20, .T., .T.) // Dimensionavel

oSize:lProp 	:= .T. // Proporcional
oSize:aMargins 	:= { 3, 3, 3, 3 } // Espaco ao lado dos objetos 0, entre eles 3

oSize:Process() // Dispara os calculos

Aadd(aHeaderPER,{" "	,; // "OK
             "CHKOK"		,;
             "@BMP"		,;
             1	 		,;
             0	 		,;
             ""  		,;
             ""  		,;
             "" 		,;
             "" 		,;
             ""			,;
             ""			,;
             ""			,;
             ""})

Aadd(aHeaderPER,{"Periodos",; // "OK
			"PERMRP"		,;
            "@!"			,;
            10				,;
            0				,;
            ""  			,;
            ""  			,;
            "D"   			,;
            ""     			,;
            ""				,;
            "" 				,;
            ""				,;
            ""})

Aadd(aHeaderPER,{"Tipo",; // "OK
 			"C2_TPOP"		,;
            "@!"		,;
            1			,;
            0			,;
            "Pertence('12')"  		,;
            ""  		,;
            "C"   		,;
            ""     		,;
            ""			,;
            STR0172     ,; // "1=Firme;2=Previsto"
            ""			,;
            ""})
AADD(aAlterGDa,"C2_TPOP")

AADD(aAlterGDa,"CHKOK")

For nI:=1 to Len(aPeriodos)
	AADD(aColsPER,{If(Substr(cPer,nI,1)=="û",oOk,oNo),DTOC(aPeriodos[nI]),If(Substr(cTpOP,nI,1)=="û","1","2"),.F.})
Next nI

// Verifica se seleciona OP
If lOP .And. Empty(cNumOpGet)
	cNumOpGet := CRIAVAR("C2_NUM",.F.)
EndIf

DEFINE MSDIALOG oDlgPer TITLE cTitle FROM 000,000 TO 420,350 OF oMainWnd PIXEL 

oGetPer:= MsNewGetDados():New(oSize:GetDimension("NUMERO","LININI"),oSize:GetDimension("NUMERO","COLINI"),;
							   oSize:GetDimension("NUMERO","LINEND"),oSize:GetDimension("NUMERO","COLEND"),;
	     				       3,"AllwaysTrue","AllwaysTrue",/*cIniCpos*/,aAlterGDa,/*nFreeze*/,990,/*cFieldOk*/, /*cSuperDel*/,;
  							   "AllwaysFalse", oDlgPer, @aHeaderPER, @aColsPER)
oGetPer:SetEditLine(.F.)
oGetPer:AddAction("CHKOK"  ,{||If(oGetPer:aCols[oGetPer:nAT,1] == oOk,oNo,oOk)})
oGetPer:lInsert:= .F.

oTButMarDe := TButton():New(oSize:GetDimension("NUMERO","LININI")+1,oSize:GetDimension("NUMERO","COLINI")+1,;
					,oDlgPer,{|| AT710IMarc(@oGetPer)},16,10,,,.F.,.T.,.F.,,.F.,,,.F.)

@ oSize:GetDimension("OP","LININI")+2,oSize:GetDimension("OP","COLINI") Say OemtoAnsi(STR0174) SIZE 100,7 OF oDlgPer PIXEL
@ oSize:GetDimension("OP","LININI")  ,oSize:GetDimension("OP","COLINI")+15 MSGET dDatDe PICTURE "99/99/99" SIZE 50,09 OF oDlgPer PIXEL
@ oSize:GetDimension("OP","LININI")+2,oSize:GetDimension("OP","COLINI")+80 Say OemtoAnsi(STR0175) SIZE 100,7 OF oDlgPer PIXEL
@ oSize:GetDimension("OP","LININI")  ,oSize:GetDimension("OP","COLINI")+100 MSGET dDatAte PICTURE "99/99/99" SIZE 50,09 OF oDlgPer PIXEL

@ oSize:GetDimension("OP","LININI")+15,oSize:GetDimension("OP","COLINI") RADIO oRdx VAR nSelec SIZE 70,10 PROMPT  OemToAnsi(STR0176),OemToAnsi(STR0177)
@ oSize:GetDimension("OP","LININI")+35,oSize:GetDimension("OP","COLINI") BUTTON STR0178 SIZE 055,010 ACTION A710Reprog(@oGetPer,nSelec,dDatDe,dDatAte) OF oDlgPer PIXEL

If lOP
	@ oSize:GetDimension("OP","LININI")+55,oSize:GetDimension("OP","COLINI") Say OemtoAnsi(STR0054) SIZE 100,7 OF oDlgPer PIXEL	//"Numero Inicial p/geracao"
	@ oSize:GetDimension("OP","LININI")+53,oSize:GetDimension("OP","COLINI")+100 MSGET cNumOpGet SIZE 50,09 OF oDlgPer PIXEL
	@ oSize:GetDimension("OP","LININI")+70,oSize:GetDimension("OP","COLINI") CHECKBOX oChk VAR lOPMaxDig PROMPT OemToAnsi(STR0083) SIZE 85, 10 OF oDlgPer PIXEL //"Maximo de 99 itens por OP"
	oChk:oFont := oDlgPer:oFont
EndIf

ACTIVATE MSDIALOG oDlgPer ON INIT EnchoiceBar(oDlgPer,{||nOpca:=2,oDlgPer:End()},{||oDlgPer:End()}) CENTERED

If nOpca = 2
	If lOp
		lOpMax99 := lOpMaxDig
		If Empty(cNumOpGet)
			cNumOpDig := GetNumSc2()
		Else
			cNumOpDig := cNumOpGet
		EndIf
	EndIf
	For nI:=1 to Len(oGetPer:aCols)
		If oGetPer:aCols[nI][1] == oOk
			If nI == 1
				cSelPer :="û"
			Else
				cSelPer :=cSelPer+"û"
			EndIf
		Else
			If nI == 1
				cSelPer :=" "
			Else
				cSelPer :=cSelPer+" "
			EndIf
		EndIf

		If oGetPer:aCols[nI][3] == "1"
			If nI == 1
				cTpOP :="û"
			Else
				cTpOP :=cTpOP+"û"
			EndIf
		Else
			If nI == 1
				cTpOP :=" "
			Else
				cTpOP :=cTpOP+" "
			EndIf
		EndIf
	Next nI
	cPer := cSelPer

EndIf

Return cPer

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³FUN‡…O    ³ A711Lote   ³ AUTOR ³Rodrigo de A Sartorio³ DATA ³ 22/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI‡…O ³ Devolve a quantidade considerendo lote econ.,min e toler.  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE   ³ ExpN1 := A711Lote(ExpN2,ExpC3)                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³PARAMETROS³ ExpN1 := Retorna quantidade                                ³±±
±±³          ³ ExpN2 := Quantidade a ser considerada                      ³±±
±±³          ³ ExpC3 := Produto a ser pesquisado                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ USO      ³ MATA710                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XA711Lote(nQtdTotal,cProduto)
Local cAlias := Alias(),aQtdes:={},nx
Local aAreaSG1:= SG1->(GetArea())
dbSelectArea("SG1")
dbSetOrder(1)
If dbSeek(xFilial("SG1")+cProduto)
	aQtdes := CalcLote(cProduto,nQtdTotal,"F")
Else
	aQtdes := CalcLote(cProduto,nQtdTotal,"C")
EndIf
nQtdTotal:=0
For nX := 1 to Len(aQtdes)
	nQtdTotal+= aQtdes[nX]
Next
RestArea(aAreaSG1)
dbSelectArea(cAlias)
Return nQtdTotal

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ u_XA711OPSC ³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 28/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de controle da emissao de OP's e SC's               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cNumOpDig  Numero da Op inicial a ser digitado pelo usuario ³±±
±±³          ³lOpMax99   Indica se o maximo de itens por op e 99          ³±±
±±³          ³ cStrTipo  String com tipos a serem processados             ³±±
±±³          ³ cStrGrupo String com grupos a serem processados            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XA711OPSC(cNumOpDig,lOpMax99,cStrTipo,cStrGrupo)
LOCAL cRev711Vaz:=CriaVar("B1_REVATU",.F.)
Local cNumOP:="",cItemOP:="01",nSequenOP:=1,cNivelStr:="",cProduto:="",cOpcional:="",cRevisao:=cRev711Vaz,i:=0,zxy:=0
Local cFil		:= ""
Local nRecPMP  :=0,nRecOrig:=0,nZ:=0
LOCAL lA650CCF := ExistBlock("A650CCF")
Local aAreaSHA :=SHA->(GetArea())
Local aAreaSH5 :=SH5->(GetArea())
Local aSH5FixR := {}
Local nAglu    := 0
Local nBkpI	   := 0
Local nPrimDt  := 0
Local nAgluMrp := 0
Local cOpcOri  := ""
Local mOpc	:= ""

PRIVATE INCLUI := .F.
PRIVATE ALTERA := .F.
PRIVATE aUsoSH5 := {}      

pergunte("MTA650",.F.)
mv_par03 := aPergs711[08]
mv_par04 := aPergs711[09]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza o log de processamento			    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcLogAtu("MENSAGEM","Iniciando Geração de OPs/SCs","Iniciando Geração de OPs/SCs")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Obtem numero da proxima OP                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC2")
dbSetOrder(1)
dbSeek(xFilial("SC2")+AllTrim(cNumOpDig))
cNumOp    := If(!Empty(cNumOpDig) .And. Eof(),cNumOpDig, GetNumSc2())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Quando utiliza PMP gera Ordens de Producao pelo arquivo de detalhe - SH5 ³
//³ Apos gerar as OPs do PMP deve considerar as demais necessidades.         ³
//³ O PMP tem a particularidade de gerar OPs mesmo que o saldo do produto    ³
//³ exista, por isso sua utilizacao por empresas que produzem para estoque.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aPergs711[1] == 2
	dbSelectArea("SH5")
	dbSetOrder(2)
	dbSeek(xFilial("SH5")+"SHC")
	ProcRegua(LastRec())
	While !Eof() .And. H5_ALIAS == 	"SHC"
		IncProc()
		cFil	 := xFilial("SH5") // Filial
		cProduto := H5_PRODUTO     // Produto do PMP
		cOpcional:= H5_OPC         // Opcionais do PMP
		cRevisao := H5_REVISAO     // Revisao
		nLoteQtd := H5_QUANT       // Quantidade do PMP
		nRecPMP  := H5_RECNO       // Registro do SHC
		nRecOrig := Recno()        // Registro do SH5
		i        := Val(H5_PER)    // Periodo
		SHC->(dbGoto(nRecPMP))
		If Empty(SHC->HC_OP)
			SB1->(MSSeek(xFilial("SB1")+cProduto))
			If QtdComp(nLoteQtd) > QtdComp(0) .And. RetFldProd(SB1->B1_COD,"B1_FANTASM") # "S" .And. !IsProdMod(SB1->B1_COD)
				A711CriSHA(cProduto,cOpcional,cRevisao,"",SH5->H5_PER,-nLoteQtd,"2",nil,nil,cStrTipo,cStrGrupo)
				dbSelectArea("SG1")
				If dbSeek(xFilial("SG1")+cProduto)
					cTipo711 := "F"
				Else
					cTipo711 := "C"
				Endif
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Executa execblock para verificar se     ³
				//³ produto sera fabricado ou comprado      ³
				//³ "COMPONENTE FABRICADO OU COMPRADO"      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lA650CCF
					cOldTipo:=cTipo711
					cTipo711:=ExecBlock("A650CCF",.F.,.F.,{cProduto,cTipo711,aPeriodos[i]})
					If !(ValType(cTipo711) == "C") .Or. !(cTipo711 $ "FCI")
						cTipo711:=cOldtipo
					EndIf
				EndIf
				If cTipo711 == "C"
					If ((aPergs711[04] == 1 .And. Substr(cSelPer,i,1) == "û") .Or. (aPergs711[04] == 2 .And. Substr(cSelPerSC,i,1) == "û")) .AND. A710VerHl(aPeriodos[i],cProduto)
						u_XA711GeraSC(i,nLoteQtd,cProduto)
						// Atualiza o status do plano mestre de produção para executado.
						dbSelectArea("SHC")
						dbGoto(nRecPMP)
						RecLock("SHC",.F.)
						Replace HC_STATUS With "E"
						MsUnlock()
					EndIf
				ElseIf cTipo711 == "F"
					If Substr(cSelPer,i,1) == "û" .AND. A710VerHl(aPeriodos[i],cProduto)
						u_ZA711GeraOP(@cNumOP, cItemOP,nSequenOP,i,nLoteQtd,cProduto,cOpcional, cRevisao,lOpMax99)
						// Atualiza numero da OP no arquivo de PMP
						dbSelectArea("SHC")
						dbGoto(nRecPMP)
						RecLock("SHC",.F.)
						Replace HC_STATUS With "E"
						Replace HC_OP With cNumOp+cItemOP+StrZero(nSequenOP,3,0)
						MsUnlock()
						// Incrementa numeracao da OP
						If aPergs711[07] == 1
							cItemOP:=Soma1(cItemOp)
							If cItemOP > "99" .And. lOpMax99
								If lDigNumOp
									cNumOp := Soma1(cNumOp)
								Else
									cNumOp := GetNumSc2()
								Endif
								cItemOP := "01"
								nSequenOp := 1
							EndIf
						Else
							If lDigNumOp
								cNumOp := Soma1(cNumOp)
							Else
								cNumOp := GetNumSc2()
							Endif
							cItemOP := "01"
							nSequenOp := 1
						EndIf
					EndIf
				EndIf
				dbSelectArea("SH5")
				dbGoto(nRecOrig)
			EndIf
		EndIf
		dbSelectArea("SH5")
		dbSkip()
	End
EndIf

// Gera aglutinado por necessidade e Gera por Op
dbSelectArea("SHA")
ProcRegua(LastRec())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera OP's para todos os periodos da projecao        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSetOrder(2)
dbGoTop()
While !Eof()
	IncProc()
	For i := 1 to Len(aPeriodos)
		nPosCampo:=SHA->(FieldPos("HA_PER"+StrZero(i,3)))
		If (aPergs711[04] == 1 .And. Substr(cSelPer,i,1) == "û") .Or. aPergs711[04] == 2
			cFil	 := xFilial("SHA") // Filial
			cProduto := SHA->HA_PRODUTO
			cOpcional:= SHA->HA_OPC
			cRevisao := SHA->HA_REVISAO
			cNivelStr:= SHA->HA_NIVEL
            If lUsaMOpc
				cOpcOri	 := SHA->HA_MOPC
			EndIf
			aSH5FixR := {}
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Gera SC OPs para todos os periodos da projecao      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !lUsaMOpc
				SHA->(dbSeek(xFilial("SHA")+cNivelStr+cProduto+cOpcional+cRevisao+"6"))
			Else
				MOpcSeek("SHA",2,cNivelStr,cProduto,,cOpcional,cRevisao,"6")				
			EndIf
			nLoteQtd:= SHA->(FieldGet(nPosCampo))
			SB1->(MSSeek(xFilial("SB1")+cProduto))
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Realiza aglutinacao dos periodos 					³
			//³	gerado no MRP conforme definido no campo B5_AGLUMRP ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			nAgluMrp:= Val(Posicione("SB5",1,xFilial("SB5")+cProduto,"B5_AGLUMRP"))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Somente executa se a aglutinacao do MRP for menor que a aglutinacao do produto     ³
	   		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If (nUsado < nAgluMrp) .OR. (nUsado==7)
				If A710Periodo(aPeriodos[i],If(i==Len(aPeriodos),SToD(''),aPeriodos[i+1]),nAgluMrp)
					nAglu := nAglu + nLoteQtd
					If !Empty(nLoteQtd) .And. Empty(nPrimDt)
						nPrimDt := i
					EndIf

					//-- Ajusta datas das saidas dos filhos
					SH5->(dbSetOrder(4))
					If QtdComp(nLoteQtd) > QtdComp(0) .AND. nPrimDt <> i
						aAreaBkp := SHA->(GetArea())
						If !lUsaMOpc
							SH5->(dbSeek(xFilial("SH5")+"SHA"+PadR(cProduto,TamSX3("B1_COD")[1])+DTOS(aPeriodos[i])))
						Else
							
						EndIf
						While !SH5->(EOF()) .AND. "SHA"+PadR(cProduto,TamSX3("B1_COD")[1])+DTOS(aPeriodos[i])== SH5->(H5_ALIAS+H5_DOC+DTOS(H5_DATAORI))
							Reclock("SH5",.F.)
							Replace SH5->H5_DATAORI With aPeriodos[nPrimDt]
							SH5->(MsUnLock()) //Confirma e finaliza a operação

							SHA->(dbSetOrder(1))
							SHA->(dbSeek(xFilial("SH5")+SH5->(H5_PRODUTO+H5_OPC+H5_REVISAO+"4")))

							Reclock("SHA",.F.)
							SHA->&("HA_PER"+StrZero(i,3)) -= SH5->H5_QUANT
							SHA->&("HA_PER"+StrZero(nPrimDt,3)) += SH5->H5_QUANT
							SHA->(MsUnLock()) //Confirma e finaliza a operação

							//-- Recalcula valores do SHA
							u_XMA711Recalc(SH5->H5_PRODUTO,SH5->H5_OPC,SH5->H5_REVISAO,nPrimDt)
							u_XMA711Recalc(SH5->H5_PRODUTO,SH5->H5_OPC,SH5->H5_REVISAO,i)
							SH5->(dbSkip())
						End
						SHA->(RestArea(aAreaBkp))
					EndIf

					If i < Len(aPeriodos)
			    		Loop
			  		Endif
				Else
					nLoteQtd :=	nAglu + nLoteQtd
					nAglu := 0
					nBkpI := i
					If !Empty(nPrimDt)
						i := nPrimDt
					EndIf
				EndIf
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//| Soma ao lote de producao/compra quantidades originadas	|
			//| pelo indicador SBP (Subproduto) quando subproduto for 	|
			//| variavel (fixo deve gerar OP's separadas				|
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SH5")
			dbSetOrder(3)
			dbSeek(xFilial("SH5")+cProduto+"SBP")
			While !EOF() .And. H5_PRODUTO+H5_ALIAS == cProduto+"SBP"
				If AllTrim(H5_PER) == StrZero(i,3) .And. cOpcional == H5_OPC .And. cRevisao == H5_REVISAO
					SG1->(dbSeek(xFilial("SG1")+SH5->(H5_PRODUTO+H5_DOC)))
					If SG1->G1_FIXVAR $ " V"
						nLoteQtd += H5_QUANT
					Else
						aAdd(aSH5FixR,Recno())
					EndIf
					A711CriSHA(cProduto,H5_OPC,H5_REVISAO,"",H5_PER,-H5_QUANT,"2",nil,nil,cStrTipo,cStrGrupo)
				EndIf
				dbSkip()
				SB1->(MSSeek(xFilial("SB1")+cProduto))
			End
			If (QtdComp(nLoteQtd) > QtdComp(0) .Or. !Empty(aSH5FixR)) .And. RetFldProd(SB1->B1_COD,"B1_FANTASM") # "S" .And. !IsProdMod(SB1->B1_COD)
				dbSelectArea("SG1")
				If dbSeek(xFilial("SG1")+cProduto)
					cTipo711 := "F"
				Else
					cTipo711 := "C"
				Endif
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Executa execblock para verificar se     ³
				//³ produto sera fabricado ou comprado      ³
				//³ "COMPONENTE FABRICADO OU COMPRADO"      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lA650CCF
					cOldTipo:=cTipo711
					cTipo711:=ExecBlock("A650CCF",.F.,.F.,{cProduto,cTipo711,aPeriodos[i]})
					If !(ValType(cTipo711) == "C") .Or. !(cTipo711 $ "FCI")
						cTipo711:=cOldtipo
					EndIf
				EndIf
				If cTipo711 == "C"
					If (aPergs711[04] == 1 .And. Substr(cSelPer,i,1) == "û") .Or. (aPergs711[04] == 2 .And. Substr(cSelPerSC,i,1) == "û")
						// Quebras as quantidades das SCs
						aQtdes := CalcLote(cProduto,nLoteQtd,"C")
						aQtdes := A711LotMax(cProduto, nLoteQtd, aQtdes)
						For zxy:=1 to Len(aQtdes)
							u_XA711GeraSC(i,aQtdes[zxy],cProduto)
						Next zxy
					EndIf
				ElseIf cTipo711 == "F"
				If Substr(cSelPer,i,1) == "û"
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//| Gera OP's para necessidade SBP quando subproduto fixo	|
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						For nZ := 1 to Len(aSH5FixR)
							SH5->(dbGoTo(aSH5FixR[nZ]))
							aQtdes := CalcLote(cProduto,SH5->H5_QUANT,"F")
							aQtdes := A711LotMax(cProduto, SH5->H5_QUANT, aQtdes)
							For zxy := 1 To Len(aQtdes)
								If !lUsaMOpc
									u_ZA711GeraOP(@cNumOP, cItemOP,nSequenOP,i,aQtdes[zxy],cProduto,SH5->H5_OPC,SH5->H5_REVISAO,lOpMax99)
								Else
									mOpc := H5_OPC
									u_ZA711GeraOP(@cNumOP, cItemOP,nSequenOP,i,aQtdes[zxy],cProduto,mOpc,SH5->H5_REVISAO,lOpMax99)
								EndIf
								// Incrementa numeracao da OP
								If aPergs711[07] == 1
									cItemOP:=Soma1(cItemOp)
									If cItemOP > "99" .And. lOpMax99
										If lDigNumOp
											cNumOp := Soma1(cNumOp)
										Else
											cNumOp := GetNumSc2()
										Endif
										cItemOP := "01"
										nSequenOp := 1
									EndIf
								Else
									If lDigNumOp
										cNumOp := Soma1(cNumOp)
									Else
										cNumOp := GetNumSc2()
									Endif
									cItemOP := "01"
									nSequenOp := 1
								EndIf
							Next zxy
						Next nZ
						aQtdes := CalcLote(cProduto,nLoteQtd,"F")
						aQtdes := A711LotMax(cProduto, nLoteQtd, aQtdes)
						For zxy:=1 to Len(aQtdes)
							If !lUsaMopc
								u_ZA711GeraOP(@cNumOP, cItemOP,nSequenOP,i,aQtdes[zxy],cProduto,cOpcional, cRevisao,lOpMax99)
							Else
								u_ZA711GeraOP(@cNumOP, cItemOP,nSequenOP,i,aQtdes[zxy],cProduto,cOpcOri, cRevisao,lOpMax99)
							EndIf
							// Incrementa numeracao da OP
							If aPergs711[07] == 1
								cItemOP:=Soma1(cItemOp)
								If cItemOP > "99" .And. lOpMax99
									If lDigNumOp
										cNumOp := Soma1(cNumOp)
									Else
										cNumOp := GetNumSc2()
									Endif
									cItemOP := "01"
									nSequenOp := 1
								EndIf
							Else
								If lDigNumOp
									cNumOp := Soma1(cNumOp)
								Else
									cNumOp := GetNumSc2()
								Endif
								cItemOP := "01"
								nSequenOp := 1
							EndIf
						Next zxy
					EndIf
				EndIf
			EndIf
			dbSelectArea("SHA")
		Endif

		If !Empty(nBkpI)
			i       := nBkpI
			nPrimDt := 0
			nBkpI   := 0
		EndIf
	Next i
	dbSelectArea("SHA")
	If !lUsaMOpc
		dbSeek(xFilial("SHA")+cNivelStr+cProduto+cOpcional+cRevisao+"6")
	Else 
		MOpcSeek("SHA",2,cNivelStr,cProduto,,cOpcional,cRevisao,"6")
	EndIf
	dbSkip()
End                                                                        	

If lMostraErro
	If lBatch
//		Conout(STR0087+NomeAutoLog()) //"Verificar inconsistencia de rotina automatica em MRP - arquivo : "
	Else
		Mostraerro()
	EndIf
EndIf


RestArea(aAreaSH5)
RestArea(aAreaSHA)
Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³u_XA711GeraSC³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 27/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de geracao de SC's                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³nPeriodo   Periodo para geracao de SCs                      ³±±
±±³          ³nQuant     Quantidade a ser gerada na SC                    ³±±
±±³          ³cProduto   Produto a ser gerado na SC                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XA711GeraSC(nPeriodo,nQuant,cProduto)
Local nNewQtdBx   := 0
Local aCampos	  := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o produto tem contrato de parceria             ³
//³ Se nao, gera solic.Compra; Se sim, gera Autor. de Entrega  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SB1->B1_CONTRAT $"N "
	u_XA711GravC1(nPeriodo,nQuant,cProduto,NIL,NIL,NIL)
Else
	If ExistBlock("A710QtdBx")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de Entrada para manipular quantidade a ser entregue  ³
		//³ pelo contrato de parceria                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If ValType(nNewQtdBx := ExecBlock("A710QtdBx",.F.,.F., {nQuant, nPeriodo, aPeriodos[nPeriodo]})) == "N" .And. nNewQtdBx <= nQuant
			nQuant := nNewQtdBx
		Endif
	EndIf

	aAdd(aCampos,{"DATPRF",aPeriodos[nPeriodo]})
	aAdd(aCampos,{"SEQMRP",c711NumMRP})
	aAdd(aCampos,{"TPOP",A710VerHf(aPeriodos[nPeriodo],cProduto)})
	aAdd(aCampos,{"USER",   RetCodUsr( )})

	MatGeraAE(cProduto,nQuant,aCampos,"MATA710")
EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³u_XA711GravC1³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 27/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de gravacao SC's                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³nPeriodo   Periodo para geracao de SCs                      ³±±
±±³          ³nQuant     Quantidade a ser gerada na SC                    ³±±
±±³          ³cProduto   Produto a ser gerado na SC                       ³±±
±±³          ³lAutEnt    Indica se produto gera AUTORIZACAO DE ENTREGA    ³±±
±±³          ³lSemData   Indica se produto tem Contrato de Parceria fora  ³±±
±±³          ³           da data - > Fora da Data do Contrato             ³±±
±±³          ³lSemQuant  Indica se produto tem Contrato de Parceria sem   ³±±
±±³          ³           quantidade - > Quantidade Esgotada               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XA711GravC1(nPeriodo,nQuant,cProduto,lAutEnt,lSemData,lSemQuant)
Static cUser
Static lExeBloC1
Local aCab :={},aItem:={}
Local aArea:=GetArea()
Local cItem:=StrZero(1,Len(SC1->C1_ITEM),0)
Local cTextoObs:=""
Local cLocal  := ""
Local aRetPE  := {}
Local cRevisao:= Space(3)
local aParam := {aPeriodos[nPeriodo],nQuant, cProduto}
DEFAULT lAutEnt  :=.F.
DEFAULT lSemData :=.F.
DEFAULT lSemQuant:=.F.
Private lMsErroAuto := .F.

lExeBloC1:=If(lExeBloC1==NIL,ExistBlock("A711CSC1"),lExeBloC1)

// PE para tratamento se deve ou não incluir a SC. Se retornar F não inclui a SC.
//
If (ExistBlock("MT711VLSC"))
	lRet:= Execblock ("MT711VLSC",.F.,.F.,aParam)
	If !lRet
		RestArea(aArea)
		return
	EndIf
EndIf

cUser:= IF(cUser == NIL,RetCodUsr(),cUser)
dbSelectArea("SB1")
If MSSeek(xFilial("SB1")+cProduto) .AND. !IsProdMod(SB1->B1_COD) .And. (SB1->B1_TIPO != "BN" .Or. (SB1->B1_TIPO == "BN" .And. MatBuyBN())) // nao gera para mao de obra e tipo = "BN" (Beneficiamento)
	If lAutEnt
		If lSemData
			cTextoObs:=STR0055	//"FORA DA DATA CONTR. PARCERIA"
		ElseIf lSemQuant
			cTextoObs:=STR0056	//"QUANT. DO CONTRATO ESGOTADA"
		Else
			cTextoObs:=STR0057	//"SEM CONTRATO DE PARCERIA"
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o produto eh intermediario  ³
	//³ e se deve ou nao considerar o armazem de³
	//³ processo na geracao de SCs.             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SB1->B1_APROPRI == "I" .And. GetMV("MV_GRVLOCP",.F.,.T.)
		cLocal 	:= GETMV("MV_LOCPROC")
	Else
		cLocal	:= RetFldProd(SB1->B1_COD,"B1_LOCPAD")
	EndIf

	aCab:={{"C1_EMISSAO" ,dDataBase  	 		 	,Nil},; 	// Data de Emissao
			{"C1_FORNECE" ,SB1->B1_PROC   			,Nil},;	// Fornecedor
			{"C1_LOJA"    ,SB1->B1_LOJPROC			,Nil},;	// Loja do Fornecedor
			{"C1_SOLICIT" ,CriaVar("C1_SOLICIT")	,Nil}}
			
	aItem:={{{"C1_ITEM"		,cItem											,Nil},; //Numero do Item
			  {"C1_PRODUTO"	,cProduto										,Nil},; //Codigo do Produto
			  {"C1_QUANT"  	,nQuant     									,Nil},; //Quantidade
			  {"C1_LOCAL"  	,cLocal										,Nil},; //Armazem
			  {"C1_DATPRF" 	,aPeriodos[nPeriodo]							,Nil},; //Data
			  {"C1_TPOP"    	,A710VerHf(aPeriodos[nPeriodo],cProduto)	,Nil},; // Tipo SC
			  {"C1_CC"  		,SB1->B1_CC    								,Nil},; //Centro de Custos
			  {"C1_GRUPCOM"  	,MaRetComSC(SB1->B1_COD,UsrRetGrp(),cUser),Nil},; //Grupo de Compras
			  {"C1_SEQMRP"  	,c711NumMRP                     			,Nil},; // Numero da Programacao do MRP
			  {"C1_OBS"  		,cTextoObs			 		   					,Nil},; //Observacao
			  {"C1_FORNECE" 	,SB1->B1_PROC		  							,Nil},; //Fornecedor
			  {"C1_LOJA"    	,SB1->B1_LOJPROC	  							,Nil},; //Loja do Fornecedor
			  {"AUTVLDCONT" 	,"N", Nil}}}

	cRevisao := Posicione("SB5",1,xFilial("SB5")+cProduto,"B5_VERSAO")
	AAdd(aTail(aItem),{"C1_REVISAO",cRevisao,NIL})

	If lExeBloC1
		aRetPE :=ExecBlock("A711CSC1",.f.,.f.,ACLONE(aItem))
		If Valtype(aRetPE) == "A"
			aItem:=ACLONE(aRetPE)
		EndIf
	EndIf

	MSExecAuto({|v,x,y,z| MATA110(v,x,y,z)},aCab,aItem,3,.T.)
	// Mostra Erro na geracao de Rotinas automaticas
	If lMsErroAuto
		lMostraErro:= .t.
	EndIf
EndIf
// Restaura area original
RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A711GeraOP³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 27/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de geracao de OP's                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cNumOP     Numero da Op a ser gerada                        ³±±
±±³          ³cItem      Item da OP a ser gerada                          ³±±
±±³          ³nSequen    Sequencia da OP a ser gerada                     ³±±
±±³          ³nPeriodo   Periodo para a geracao da OP                     ³±±
±±³          ³nQuant     Quantidade da OP a ser gerada                    ³±±
±±³          ³cProduto   Produto da OP a ser gerada                       ³±±
±±³          ³cOpcionais Opcionais da OP a ser gerada                     ³±±
±±³          ³cRevisao   Revisao da estrutura                             ³±±
±±³          ³lOpMax99   indica o numero maximo de itens                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function ZA711GeraOP(cNumOp,cItem,nSequen,nPeriodo,nQuant,cProduto,cOpcionais,cRevisao,lOpMax99)
Static lM711SC2
Local aMata650 :={}
Local aArea    :=GetArea()
Local dPeriodo :=aPeriodos[nPeriodo]
Local nQuant2UM:=ConvUm(cProduto,nQuant,0,2)
Local nPrazo   :=CalcPrazo(cProduto,nQuant,,,.F.,dPeriodo)
Local aRetPE   := {}
Private lMsErroAuto := .F.

lM711SC2:=If(lM711SC2==NIL,ExistBlock("M711SC2"),lM711SC2)

dbSelectArea("SB1")
If MSSeek(xFilial("SB1")+cProduto)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Obtem numero da proxima OP                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SC2")
	dbSetOrder(1)
	While dbSeek(xFilial("SC2")+AllTrim(cNumOp)+cItem)
		// Incrementa numeracao da OP
		If aPergs711[07] == 1
			cItem:=Soma1(cItem)
			If cItem > "99" .And. lOpMax99
				If lDigNumOp
					cNumOp := Soma1(cNumOp)
				Else
					cNumOp := GetNumSc2()
				Endif
				cItem   := "01"
				nSequen := 1
			EndIf
		Else
			If lDigNumOp
				cNumOp := Soma1(cNumOp)
			Else
				cNumOp := GetNumSc2()
			Endif
			cItem := "01"
			nSequen := 1
		EndIf
	End
	//-- Monta array para utilizacao da Rotina Automatica
	aMata650  := {{'C2_NUM',cNumOp,"A710ValNum()"},;
		{'C2_ITEM'     ,cItem,"A710ValNum()"},;
		{'C2_SEQUEN'   ,StrZero(nSequen,Len(SC2->C2_SEQUEN)),"A710ValNum()"},;
		{'C2_PRODUTO'  ,cProduto,NIL},;
		{'C2_LOCAL'    ,RetFldProd(SB1->B1_COD,"B1_LOCPAD"),NIL},;
		{'C2_QUANT'    ,nQuant,NIL},;
		{'C2_QTSEGUM'  ,nQuant2UM,NIL},;
		{'C2_UM'       ,SB1->B1_UM	,NIL},;
		{'C2_CC'       ,SB1->B1_CC	,NIL},;
		{'C2_SEGUM'    ,SB1->B1_SEGUM,NIL},;
		{'C2_DATPRI'   ,SomaPrazo(dPeriodo, - nPrazo),NIL},;
		{'C2_DATPRF'   ,dPeriodo,NIL},;
		{'C2_REVISAO'  ,If(A710TrataRev(),cRevisao,SB1->B1_REVATU),NIL},;
		{'C2_TPOP'     ,A710VerHf(dPeriodo,cProduto),NIL},;
		{'C2_EMISSAO'  ,dDataBase,NIL},;
		{'C2_OPC'      ,cOpcionais,NIL},;
		{'C2_SEQMRP'   ,c711NumMRP,Nil},;
		{'C2_IDENT'   ,"P",Nil},;
		{'MRP'         ,'S',NIL},;
		{'AUTEXPLODE'  ,'S',NIL}}
		
		If !lUsaMOpc 
			AAdd (aMata650, {'C2_OPC',cOpcionais,NIL})
		Else 
			AAdd (aMata650, {'C2_MOPC',cOpcionais,NIL})
		EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³P.E. utilizado para manipular o Array aMata650,³
	//³antes da geracao da Ordem de Producao.         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lM711SC2
		aRetPE :=ExecBlock("M711SC2",.f.,.f.,ACLONE(aMata650))
		If Valtype(aRetPE) == "A"
			aMata650:=ACLONE(aRetPE)
		EndIf
	EndIf
	//-- Chamada da rotina automatica
	msExecAuto({|x,Y| Mata650(x,Y)},aMata650,3)
	// Mostra Erro na geracao de Rotinas automaticas
	If lMsErroAuto
		lMostraErro:= .t.
	EndIf
EndIf
// Restaura area original
RestArea(aArea)
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A711Recalc³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 28/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina para recalcular saldos e necessidades do produto    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cProduto    Produto a ser recalculado                       ³±±
±±³          ³cOpc        Opcional do produto a ser recalculado           ³±±
±±³          ³cRevisao    Revisao do produto relacionada ao movimento     ³±±
±±³          ³cPeriodo    Periodo inicial do recalculo                    ³±±
±±³          ³nNovoSalIni Novo saldo inicial do produto no periodo inicial³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XMA711Recalc(cProduto,cOpc,cRevisao,cPeriodo,nNovoSalIni,lForcaCalc,lInJob)
Local cAlias	  		:= Alias()
Local nEntrada	  		:= 0
Local nSaida	  		:= 0
Local nPosCampo	  	:= 0
Local nSaldoAtu	 	:= 0
Local nNecessidade 	:= 0
Local nSaidaEstr  	:= 0
Local nEstSeg	  		:= 0
Local nPontoPed		:= 0
Local nHFSALDO			:= 0
Local cCampo	  		:= ""
Local nLotVnc			:= 0
Local nTotSaida		:= 0
Local nTamProd   		:= TamSX3("HF_PRODUTO")[1]
Local w,nz

DEFAULT cPeriodo		:= "000"
DEFAULT nNovoSalIni	:= 0
DEFAULT lForcaCalc 	:= .F.
DEFAULT lInJob    		:= .F.

SB1->(MsSeek(xFilial("SB1") + cProduto))

If lForcaCalc
	DbSelectArea("SHA")
	DbSetOrder(1)
	nTotSaida := 0
	//Apos gravar registro recalcula todos periodos posteriores
	For w:=Val(cPeriodo)+1 To Len(aPeriodos)
		nEntrada  	:=0
		nSaida	  	:=0
		nSaidaEstr	:=0
		nLotVnc 	:=A710LotVnc(cProduto,aPeriodos[w]) 
		//Verifica o consumo dos lotes vencidos com o total de saídas do produto.
		If nLotVnc <= nTotSaida
			nTotSaida 	-= nLotVnc
			nLotVnc 	:= 0
		Else
			nLotVnc 	-= nTotSaida
			nTotSaida 	:= 0
		EndIf
		//Se o total do lote vencido foi maior que o saldo incial, zera 
		If nLotVnc <= nNovoSalIni
			nNovoSalIni -= nLotVnc
		Else
			nNovoSalIni := 0
		EndIf
		cCampo := "HA_PER"+StrZero(w,3)
		nPosCampo := FieldPos(cCampo)
		// Varre os 5 registros desse periodo
		For nz:=1 to 6
			If !lUsaMOpc
				dbSeek(xFilial("SHA")+cProduto+cOpc+cRevisao+Str(nz,1))
			Else 
				MOpcSeek("SHA",1,,cProduto,,cOpc,cRevisao,Str(nz,1))
			EndIf
			// Grava Novo Saldo Inicial
			If nz == 1 .And. ValType(nNovoSalIni) == "N"
				Reclock("SHA",.F.,,,lInJob)
				FieldPut(nPosCampo,nNovoSalIni)
				MsUnlock()
			EndIf
			// Obtem Entradas
			If nz <= 2
				nEntrada+=FieldGet(nPosCampo)
				// Obtem Saidas
			ElseIf nz == 3
				nSaida+=FieldGet(nPosCampo)
				// Obtem Saidas pela Estrutura
			ElseIf nz == 4
				nSaidaEstr+=FieldGet(nPosCampo)
				// Obtem Saldo
			ElseIf nz == 5
				// Calcula Saldo Atual e Necessidade
				Reclock("SHA",.F.,,,lInJob)
				nSaldoAtu:=nEntrada-nSaida-nSaidaEstr
				FieldPut(nPosCampo,nSaldoAtu)
				MsUnlock()
				// Calcula necessidade
			ElseIf nz == 6
				nHFSALDO := nNovoSalIni
				// Calcula necessidade e saldo inicial do proximo periodo
				If aPergs711[26] == 3
					nEstSeg   := CalcEstSeg( RetFldProd(SB1->B1_COD,"B1_ESTFOR") )
				EndIf
				// Calcula necessidade e saldo inicial do proximo periodo
				If aPergs711[31] == 1
					nPontoPed := RetFldProd(SB1->B1_COD,"B1_EMIN")
				EndIf
				If !Empty(nPontoPed)
					nPontoPed++
				EndIf
				If QtdComp(nSaldoAtu - (nEstSeg+nPontoPed)) < QtdComp(0)
					nNecessidade:=u_XA711Lote(ABS((nEstSeg+nPontoPed)- nSaldoAtu),cProduto)
					nNecessidade:=u_XA711NecMax(cProduto, ABS( (nEstSeg+nPontoPed) - nSaldoAtu), nNecessidade)
					nNovoSalIni:=nNecessidade+nSaldoAtu
				Else
					nNecessidade:=0
					nNovoSalIni :=nSaldoAtu
				EndIf
				Reclock("SHA",.F.,,,lInJob)
				FieldPut(nPosCampo,nNecessidade)
				MsUnlock()
				If aPergs711[32] == 1
					If SHF->(dbSeek(xFilial("SHF")+cFilAnt+SubStr(cProduto,1,nTamProd)+DToS(aPeriodos[w])))
						RecLock("SHF",.F.,,,lInJob)
					Else
						RecLock("SHF",.T.,,,lInJob)
					EndIf
					SHF->HF_FILNEC	:= cFilAnt
					SHF->HF_PRODUTO	:= cProduto
					SHF->HF_DATA	:= aPeriodos[w]
					SHF->HF_SALDO	:= nHFSALDO
					SHF->HF_ENTRADA	:= nEntrada
					SHF->HF_SAIDAS	:= nSaida + nSaidaEstr
					SHF->HF_NECESSI	:= nNecessidade
					SHF->(MsUnLock())
					dbSelectArea("SHA")
				EndIf
			EndIf
		Next nz
	Next w
Else
	DbSelectArea("SHA")
	DbSetOrder(1)
	nTotSaida := 0
	//Apos gravar registro recalcula todos periodos posteriores
	For w:=1 To Len(aPeriodos)
		nEntrada	:=0
		nSaida		:=0
		nSaidaEstr	:=0
		nLotVnc 	:=A710LotVnc(cProduto,aPeriodos[w]) 
		//Verifica o consumo dos lotes vencidos com o total de saídas do produto.
		If nLotVnc <= nTotSaida
			nTotSaida 	-= nLotVnc
			nLotVnc 	:= 0
		Else
			nLotVnc 	-= nTotSaida
			nTotSaida 	:= 0
		EndIf
		//Se o total do lote vencido foi maior que o saldo incial, zera 
		If nLotVnc <= nNovoSalIni
			nNovoSalIni -= nLotVnc
		Else
			nNovoSalIni := 0
		EndIf
		cCampo := "HA_PER"+StrZero(w,3)
		nPosCampo := FieldPos(cCampo)
		// Varre os 5 registros desse periodo
		For nz:=1 to 6
			If !lUsaMOpc
				dbSeek(xFilial("SHA")+cProduto+cOpc+cRevisao+Str(nz,1))
			Else 
				MOpcSeek("SHA",1,,cProduto,,cOpc,cRevisao,Str(nz,1))
			EndIf
			// Grava Novo Saldo Inicial
			If nz == 1
				If w <> 1
					If Reclock("SHA",.F.,,,lInJob)
						FieldPut(nPosCampo,nNovoSalIni)
						MsUnlock()
					EndIf	
				Else
					nNovoSalIni:=FieldGet(nPosCampo)
				EndIf
			// Obtem Entradas
			ElseIf nz == 2
				nEntrada+=FieldGet(nPosCampo)
				// Obtem Saidas
			ElseIf nz == 3
				nSaida+=FieldGet(nPosCampo)
				nTotSaida += nSaida
				// Obtem Saidas pela Estrutura
			ElseIf nz == 4
				nSaidaEstr+=FieldGet(nPosCampo)
				nTotSaida += nSaidaEstr
				// Obtem Saldo
			ElseIf nz == 5
				// Calcula Saldo Atual e Necessidade
				nSaldoAtu:=nNovoSalIni+nEntrada-nSaida-nSaidaEstr
				If Reclock("SHA",.F.,,,lInJob)
					FieldPut(nPosCampo,nSaldoAtu)
					MsUnlock()
				EndIf	
				// Calcula necessidade
			ElseIf nz == 6
				nHFSALDO := nNovoSalIni

				// Calcula necessidade e saldo inicial do proximo periodo
				If aPergs711[26] == 3
					nEstSeg   := CalcEstSeg( RetFldProd(SB1->B1_COD,"B1_ESTFOR") )
				EndIf
				// Calcula necessidade e saldo inicial do proximo periodo
				If aPergs711[31] == 1
					nPontoPed := RetFldProd(SB1->B1_COD,"B1_EMIN")
				EndIf
				If !Empty(nPontoPed)
					nPontoPed++
				EndIf
				If QtdComp(nSaldoAtu - (nEstSeg+nPontoPed)) < QtdComp(0)
					nNecessidade:=u_XA711Lote(ABS((nEstSeg+nPontoPed)- nSaldoAtu),cProduto)
					nNecessidade:=u_XA711NecMax(cProduto, ABS( (nEstSeg+nPontoPed) - nSaldoAtu), nNecessidade)
					nNovoSalIni:=nNecessidade+nSaldoAtu
				Else
					nNecessidade:=0
					nNovoSalIni :=nSaldoAtu
				EndIf
				If Reclock("SHA",.F.,,,lInJob)
					FieldPut(nPosCampo,nNecessidade)
					MsUnlock()
				EndIf	
				
				If aPergs711[32] == 1
					If SHF->(dbSeek(xFilial("SHF")+cFilAnt+SubStr(cProduto,1,nTamProd)+DToS(aPeriodos[w])))
						RecLock("SHF",.F.,,,lInJob)
					Else
						RecLock("SHF",.T.,,,lInJob)
					EndIf
					SHF->HF_FILNEC	:= cFilAnt
					SHF->HF_PRODUTO	:= cProduto
					SHF->HF_DATA	:= aPeriodos[w]
					SHF->HF_SALDO	:= nHFSALDO
					SHF->HF_ENTRADA	:= nEntrada	
					SHF->HF_SAIDAS	:= nSaida + nSaidaEstr
					SHF->HF_NECESSI	:= nNecessidade
					SHF->(MsUnLock())
					dbSelectArea("SHA")
				EndIf
			EndIf
		Next nz
	Next w
EndIf
dbSelectArea(cAlias)
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A711AdTree³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 28/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina para incluir documento do arquivo SH5 no tree do MRP³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³lTodosDados Indica inclusao de multiplos itens no TREE      ³±±
±±³          ³aDadosTree  Array com dados organizados para inclusao no TREE±±
±±³          ³lResumido  Monta Array resumido somente com os produtos     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A711AdTree(lTodosDados,aDadosTree,lResumido)
Local aTexto   := {}
Local cOldCargo:=oTreeM711:GetCargo(),cOldAlias:=""
Local nz:=0,nPos:=0
Local cProduto:="",cOpc:="",cRevisao:="",cDadosPrd:="",cDadosArq:=""
Local cImg := ""
Local aArea
Local clegen
Local lShAlt := If(ExistBlock("M710ShAlt"),execblock('M710SHAlt',.F.,.F.),.F.)

DEFAULT lTodosDados := .F.
DEFAULT lResumido  := .F.

AADD(aTexto,{"SC1",STR0018}) //"Solicitacao de Compra"
AADD(aTexto,{"SC7",STR0019}) //"Pedido de Compra / Autorizacao de Entrega"
AADD(aTexto,{"SC2",STR0020}) //"Ordem de Producao"
AADD(aTexto,{"SHC",STR0021}) //"Plano Mestre de Producao"
AADD(aTexto,{"SD4",STR0022}) //"Empenho"
AADD(aTexto,{"SC6",STR0023}) //"Pedido de Venda"
AADD(aTexto,{"SC4",STR0024}) //"Previsao de Venda"
AADD(aTexto,{"AFJ",STR0036}) //"Empenhos para Projeto"
#IFDEF ENGLISH
	AADD(aTexto,{"SHA",STR0149}) //"Necessidade Estrutura"
#ELSE
	AADD(aTexto,{"SHA",STR0039}) //"Necessidade Estrutura"
#ENDIF
AADD(aTexto,{"ENG",STR0084}) //"Subproduto Estrutura"
AADD(aTexto,{"SB1",STR0086}) //"Cadastro de Produto"
AADD(aTexto,{"SB8",STR0159}) //"Lotes Vencidos"
AADD(aTexto,{"SBP",STR0167}) //"Nec. Subproduto"

// Incrementa os dados do array no tree - SEMPRE CONTEM DADOS DE UM UNICO PRODUTO
If !lTodosDados

	// Estrutura do array
	// 01 Produto
	// 02 Opcional
	// 03 Revisao
	// 04 Alias
	// 05 Tipo
	// 06 Documento
	// 07 Recno
	// 08 DocRev

	For nz:=1 to Len(aDadosTree)
		// Incluir produto caso necessario
		// Muda a legenda se o produto tiver alternativo, se Tem SGI e PE M710ShAlt = T
   		cLegen := 'PMSEDT4'
	    If lShAlt
			dbSelectArea("SGI")
			dbSetOrder(1)
			If MSSeek(xFilial("SGI")+aDadosTree[nz,1])
				cLegen := 'PMSEDT2'
			EndIf
		endIf
		nPos:=ASCAN(aDbTree,{|x| x[1] == aDadosTree[nz,1]})
		If Empty(nPos)
			oTreeM711:AddItem(AllTrim(aDadosTree[nz,1])+If(Empty(aDadosTree[nz,2]),""," / "+Alltrim(aDadosTree[nz,2])) + A710StrRev(aDadosTree[nz,3]),"01"+aDadosTree[nz,7]+StrZero(0,12),cLegen,cLegen,,,2)
			cDadosPrd:=aDadosTree[nz,7]+StrZero(0,12)
		Else
			cDadosPrd:=aDbTree[nPos,7]+StrZero(0,12)
		EndIf
		If !lResumido
			// Inclui tipo de arquivo caso necessario
			nPos:=ASCAN(aDbTree,{|x| x[1]+x[4] == aDadosTree[nz,1]+aDadosTree[nz,4]})
			If Empty(nPos)
				cDadosArq:=aDadosTree[nz,7]+aDadosTree[nz,4]
			Else
				cDadosArq:=aDbTree[nPos,7]+aDbTree[nPos,4]
			EndIf
			// Pesquisa no TREE tipo de arquivo
            If !oTreeM711:TreeSeek("02"+cDadosArq)
				// Posiciona no TREE produto
				oTreeM711:TreeSeek("01"+cDadosPrd)
				// Coloca tipo de arquivo - TREE
				oTreeM711:AddItem(aTexto[Ascan(aTexto,{ |x| x[1] == aDadosTree[nz,4]}),2],"02"+aDadosTree[nz,7]+aDadosTree[nz,4],If(aDadosTree[nz,5]=="2","PMSEDT3","PMSEDT1"),If(aDadosTree[nz,5]=="2","PMSEDT3","PMSEDT1"),,,2)
        	EndIf
			// Posiciona tipo de arquivo - TREE
			oTreeM711:TreeSeek("02"+cDadosArq)
			SH5->(dbGoTo(Val(aDadosTree[nz,7])))
			If aDadosTree[nz,5]$"23" .And. If(aDadosTree[nz,4]=="ENG",!Empty(SH5->H5_DOCKEY),aDadosTree[nz,4]#"SBP")
				cImg := "PMSDOC"
			Else
				cImg := "relacionamento_direita"
			EndIf
			If !oTreeM711:TreeSeek("03"+aDadosTree[nz,7]+aDadosTree[nz,7])
				// Coloca documento - TREE
				oTreeM711:AddItem(AllTrim(aDadosTree[nz,6])+A710StrRev(aDadosTree[nz,8]),"03"+aDadosTree[nz,7]+aDadosTree[nz,7],cImg,cImg,,,2)
			EndIf
		EndIf

		nPos:=ASCAN(aDbTree,{|x| x[7] == aDadosTree[nz,7]})

		// Adiciona no array do tree
		If Empty(nPos)
			AADD(aDbTree,aDadosTree[nz])
		EndIf
	Next nz

	oTreeM711:TreeSeek(cOldCargo)

// Inclui todos os itens no tree
Else
	// Monta tree na primeira vez
	oTreeM711:BeginUpdate()
	oTreeM711:Reset()
	oTreeM711:EndUpdate()
	// Estrutura do array
	// Produto
	// Opcional
	// Alias
	// Revisao
	// Tipo
	// Documento
	// Recno
	For nz:=1 to Len(aDadosTree)
		// Verifica se mudou o produto ou se é o primeiro produto

		// Muda a legenda se o produto tiver alternativo, se tem SGI e se PE M710ShAlt = T
   		cLegen := 'PMSEDT4'
   		If lShAlt
			dbSelectArea("SGI")
			dbSetOrder(1)
			If MSSeek(xFilial("SGI")+aDadosTree[nz,1])
				cLegen := 'PMSEDT2'
			EndIf
		EndIF

		If cProduto+cOpc+cRevisao # aDadosTree[nz,1]+aDadosTree[nz,2]+aDadosTree[nz,3]
			If Empty(cProduto+cOpc+cRevisao)
				// Coloca titulo no TREE
				oTreeM711:AddTree(STR0025+" / "+STR0058+Space(80),.T.,,,cLegen,cLegen,"00"+aDadosTree[nz,7]+StrZero(0,12))
			Else
				// Encerra tree do produto
				oTreeM711:EndTree()
			EndIf
			cProduto :=aDadosTree[nz,1]
			cOpc     :=aDadosTree[nz,2]
			cRevisao :=aDadosTree[nz,3]
			cOldAlias:=""
			// Coloca Produto no TREE
			oTreeM711:AddTree(AllTrim(cProduto)+If(Empty(cOpc),""," / "+Alltrim(cOpc)) + A710StrRev(cRevisao),.T.,,,cLegen,cLegen,"01"+aDadosTree[nz,7]+StrZero(0,12))
		EndIf
		// Verifica se mudou o tipo de arquivo totalizado
		If !lResumido
			If cOldAlias # aDadosTree[nz,4]
				cOldAlias:=aDadosTree[nz,4]
				oTreeM711:AddTree(aTexto[Ascan(aTexto,{ |x| x[1] == aDadosTree[nz,4]}),2],.T.,,,If(aDadosTree[nz,5]=="2","PMSEDT3","PMSEDT1"),If(aDadosTree[nz,5]=="2","PMSEDT3","PMSEDT1"),"02"+aDadosTree[nz,7]+aDadosTree[nz,4])
			EndIf
			SH5->(dbGoTo(Val(aDadosTree[nz,7])))
			If aDadosTree[nz,5]$"23" .And. If(aDadosTree[nz,4]=="ENG",!Empty(SH5->H5_DOCKEY),aDadosTree[nz,4]#"SBP")
				cImg := "PMSDOC"
			Else
				cImg := "relacionamento_direita"
			EndIf
			oTreeM711:AddTreeItem(AllTrim(aDadosTree[nz,6])+A710StrRev(aDadosTree[nz,8]),cImg,cImg,"03"+aDadosTree[nz,7]+aDadosTree[nz,7])
			If (nz < Len(aDadosTree) .And. ((aDadosTree[nz+1,4] # cOldAlias) .Or. (cProduto+cOpc+cRevisao # aDadosTree[nz+1,1]+aDadosTree[nz+1,2]+aDadosTree[nz+1,3]))) .Or. nz == Len(aDadosTree)
				// Encerra tree do tipo de arquivo qdo muda de tipo de arquivo ou muda de produto
				oTreeM711:EndTree()
			EndIf
		EndIf
	Next nz
	If Len(aDadosTree) > 0
		// Encerra tree do produto
		oTreeM711:EndTree()
		// Encerra tree inteiro
		oTreeM711:EndTree()
	EndIf
EndIf

RETURN

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³A711EstOpc³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 29/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Funcao recursiva para verificar opcionais utilizados       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do produto a ser explodido                  ³±±
±±³          ³ ExpC2 = Opcionais utilizados                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA710                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
USER Function XA711EstOpc(cProduto,cOpcionais,lRecursiva,lRetOpc,cStrTipo,cStrGrupo,lMATA650)
LOCAL aArea		:= GetArea()
LOCAL cRetGr	:= "",i
LOCAL aRegs		:= {}
LOCAL aRegGr	:= {}

Default lRecursiva := .T.
Default lRetOpc    := .F.
Default cStrTipo   := ""
Default cStrGrupo  := ""
Default lMATA650   := .F.

If !Empty(cOpcionais) .And. !Empty(cProduto)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona no produto desejado                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SG1")
	dbSetOrder(1)
	dbSeek(xFilial("SG1")+cProduto)
	While !Eof() .And. G1_FILIAL+G1_COD == xFilial("SG1")+cProduto
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Filtra componentes nao utilizados                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !U_XM711AvalProd(SG1->G1_COMP,cStrTipo,cStrGrupo)
			dbSelectArea("SG1")
			dbSkip()
			Loop
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica quais grupos de opcionais sao utilizados ³
		//³ na estrutura do produto original.                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(SG1->G1_GROPC)
			If Empty(AsCan(aRegGr,{|x| x==SG1->G1_GROPC + If(lRetOpc, SG1->G1_OPC, "")}))
				aadd(aRegGr,SG1->G1_GROPC + If(lRetOpc, SG1->G1_OPC, ""))
			EndIf
		Else
			// Caso nao tenha opcionais neste nivel, guarda o registro para
			// pesquisar em niveis inferiores
			AADD(aRegs,{SG1->(Recno()),SG1->G1_NIV})
		EndIf
		dbSelectArea("SG1")
		dbSkip()
	Enddo

	ASORT(aRegGr,,,{|x,y| x < y})
	For i:=1 To Len(aRegGr)
		cRetGr+=If(lRetOpc .And. !Empty(cRetGr),"/","")+aRegGr[i]
	Next i

	If lRecursiva
		ASORT(aRegs,,,{|x,y| x[2] < y[2]})
		// Varre o array para que sejam selecionados os itens restantes
		For i:=1 to Len(aRegs)
			SG1->(dbGoto(aRegs[i,1]))
			cRetGr+=A711EstOpc(SG1->G1_COMP,cOpcionais,NIL,If(lMATA650,.T.,NIL),cStrTipo,cStrGrupo,lMATA650)
		Next I
	Endif
EndIf
RestArea(aArea)
Return cRetGr

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³A711AvlOpc³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 29/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Funcao para verificar opcionais utilizados                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do produto a ser explodido                  ³±±
±±³          ³ ExpC2 = Grupos de opcionais utilizados                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA710                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function A711AvlOpc(cOpcArq,cGrupos)
LOCAL cOpc711Vaz:=CriaVar("C2_OPC",.F.)
Local cRetOpc  :="",cGrScan:=""
Local nTamGrupo:=Len(SG1->G1_GROPC)
Local nTamItGr :=Len(SG1->G1_OPC)
Local aArea:=GetArea()
cOpcArq:="/"+cOpcArq
While !Empty(cGrupos)
	// Obtem o grupo a ser pesquisado
	cGrScan:=Substr(cGrupos,1,nTamGrupo)
	// Retira grupo a ser pesquisado da lista de grupos originais
	cGrupos:=Substr(cGrupos,nTamGrupo+1)
	// Procura grupo no campo de opcionais do arquivo
	nString:=AT("/"+cGrScan,cOpcArq)
	If nString > 0 .And. !(Substr(cOpcArq,nString+1,nTamGrupo+nTamItGr+1) $ cRetOpc)
		cRetOpc	+= Substr(cOpcArq,nString+1,nTamGrupo+nTamItGr+1)
	EndIf
End
RestArea(aArea)
cRetOpc:=cRetOpc+Space(Len(cOpc711Vaz)-Len(cRetOpc))
Return cRetOpc

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A711Diver  ³ Autor ³Rodrigo A. Sartorio  ³ Data ³ 30/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Seleciona Periodos para opcao de apresentacao diversos     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA710                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A711Diver()
LOCAL nTamArray := Len(aDiversos)
LOCAL dInicio   := dDataBase
Local lConsSabDom:=aPergs711[12] == 1
Local nI         := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se ainda nao foi criado o Array   ³
//³ com as datas, ou se o numero de dias foi   ³
//³ alterado. Se nao foi criado sugere as datas³
//³ com a opcao de diario                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aDiversos) == 0 .Or. aOpcoes[2][1] != Len(aDiversos)
	If aOpcoes[2][1] > Len(aDiversos)
		If Len(aDiversos) == 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ O inicio do array e'a database             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dInicio := STOD(DTOS(dDataBase),"ddmmyy")
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Caso tenha sido aumentado o numero de dias ³
			//³ ele mantem os dados que ja existiam e cria ³
			//³ os novos dias a partir da ultima data do   ³
			//³ array                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dInicio := cTod(aDiversos[Len(aDiversos)],"ddmmyy")
		EndIf
		For nI := 1 to (aOpcoes[2][1] - nTamArray)
			AADD(aDiversos,dToc(dInicio))
			dInicio ++
			While !lConsSabDom .And. ( DOW(dInicio) == 1 .or. DOW(dInicio) == 7 )
				dInicio++
			End
		Next
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Caso tenha sido diminuido o numero de dias ³
		//³ apaga os dias a mais (do fim para o comeco)³
		//³ e mantem os dados digitados                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nI:=Len(aDiversos) to (aOpcoes[2][1]+1) Step -1
			aDel(aDiversos,nI)
			Asize(aDiversos,nTamArray-1)
			nTamArray:=Len(aDiversos)
		Next
	EndIf
EndIf
A711PerDiv()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³ A711PerDiv                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Autor     ³ Rodrigo de Almeida Sartorio              ³ Data ³ 30.08.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Seleciona periodos qdo. projecao por periodos variaveis.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Uso      ³ SigaPCP ú Advanced                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A711PerDiv()
Local oQual,nOpca:=1
Local cVarQ :="  ", oDlg,cTitle:=OemToAnsi(STR0059)	//"Sele‡„o de Per¡odos Vari veis"
Local oGet
Local aBack:=AClone(aDiversos)
DEFINE MSDIALOG oDlg TITLE cTitle From 145,70 To 350,400 OF oMainWnd PIXEL
@ 10,13 TO 80,152 LABEL "" OF oDlg  PIXEL
@ 20,18 LISTBOX oQual VAR cVarQ Fields HEADER OemToAnsi(STR0009) SIZE 65,55 NOSCROLL ON DBLCLICK oGet:SetFocus() OF oDlg PIXEL
@ 30,90 Say OemToAnsi(STR0041) SIZE 25,10 OF oDlg PIXEL
oQual:SetArray(aDiversos)
oQual:bLine := { || {aDiversos[oQual:nAt]} }
@ 40,90 MSGET oGet VAR aDiversos[oQual:nAt] Picture "99/99/99" + If(__SetCentury(),"99","") Valid a711VDiver(oQual:nAT,aDiversos[oQual:nAt],@oQual,@oGet) SIZE 40,10 OF oDlg PIXEL
DEFINE SBUTTON FROM 86,042 TYPE 1 ACTION (nOpca:=2,oDlg:End()) ENABLE OF oDlg PIXEL
DEFINE SBUTTON FROM 86,069 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg PIXEL
ACTIVATE MSDIALOG oDlg
If nOpca = 1
	aDiversos:={}
	aDiversos:=ACLONE(aBack)
EndIf
Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A711VDiver ³ Autor ³Rodrigo A Sartorio   ³ Data ³ 30/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao da digitacao do periodo                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ nOpt      = numero da linha que esta sendo editada         ³±±
±±³          ³ cDiversos = conteudo do array antes do get                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA710                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A711VDiver(nOpt,cDiversos,oQual,oGet)
Local lRet:=.T.
Local lConsSabDom:=aPergs711[12] == 1
Local nI         := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Nao permite que o usuario digite uma data  ³
//³ que seja sabado ou domingo                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lConsSabDom .And. DOW(cTod(aDiversos[nOpt])) == 1 .Or. DOW(cTod(aDiversos[nOpt])) == 7
	aDiversos[nOpt]:=cDiversos
	lRet := .F.
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Nao permite que o usuario digite uma data  ³
//³ menor  ou igual a anterior,enviando um help³
//³ e retornando ao valor anterior.            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpt != 1
	If cTod(aDiversos[nOpt]) <= cTod(aDiversos[nOpt - 1])
		aDiversos[nOpt]:=cDiversos
		lRet := .F.
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se a data alterada e' maior ou    ³
//³ igual a proxima e refaz as datas a partir  ³
//³ da data digitada ate o fim. So nao entra   ³
//³ nesta opcao quando a data alterada for a   ³
//³ ultima                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpt < Len(aDiversos)
	If cTod(aDiversos[nOpt + 1]) <= cTod(aDiversos[nOpt])
		dInicio:= StoD(DtoS(cTod(aDiversos[nOpt])),"ddmmyy")
		For nI:=nOpt+1 to Len(aDiversos)
			dInicio ++
			While !lConsSabDom .And. ( DOW(dInicio) == 1 .or. DOW(dInicio) == 7 )
				dInicio++
			End
			aDiversos[ni] := dToc(dInicio)
		Next
	EndIf
EndIf
If lRet
	oQual:SetArray(aDiversos)
	oQual:Refresh()
	oQual:SetFocus()
Else
	oGet:SetFocus()
	oGet:Refresh()
EndIf
Return lRet

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A711ShPrd  ³ Autor ³Rodrigo A Sartorio   ³ Data ³ 11/12/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Mostra os dados do produto                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA710                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A711ShPrd()
Local nPos	  := AsCan(aDbTree,{|x| x[7]==SubStr(oTreeM711:GetCargo(),3,12)})
Local cProduto:= IIf(Empty(nPos),Space(15),aDbTree[nPos,1])
Local aArea:=GetArea()

dbSelectArea("SB1")
dbSetOrder(1)
If MSSeek(xFilial("SB1")+cProduto)
	cCadastro:=cCadastro+" - "+STR0064
	AxVisual("SB1",SB1->(Recno()),1)
	cCadastro:=STR0001
EndIf
RestArea(aArea)
RETURN

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A711ShAlt  ³ Autor ³Nilton MK            ³ Data ³ 11/06/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Mostra produtos alternativos                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA710                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A711ShAlt()
Local nPos	  := AsCan(aDbTree,{|x| x[7]==SubStr(oTreeM711:GetCargo(),3,12)})
Local cProduto:= IIf(Empty(nPos),Space(15),aDbTree[nPos,1])
Local aArea:=GetArea()

Local oDlg,oBold,oListBox
Local aViewSGI:= {}

dbSelectArea("SGI")
dbSetOrder(1)
If MSSeek(xFilial("SGI")+cProduto)
	While !Eof() .And. GI_FILIAL+GI_PRODORI == xFilial("SGI")+cProduto
	    aadd(aViewSGI,{SGI->GI_PRODORI,GI_PRODALT,GI_FATOR,GI_MRP})
		dbSkip()
	Enddo
EndIf

If Empty(aViewSGI)
	Aviso("Atenção","Produto selecionado no tree não tem alternativos. Selecione um produto identificado com legenda.",{"Voltar"},2)
Else
//	DbSelectArea("SGI")
//	DbSetOrder(1)
//	MsSeek(xFilial("SGI")+cProdDetSld)

	DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
	DEFINE MSDIALOG oDlg FROM 000,000  TO 250,400 TITLE "Lista de produtos alternativos de "+cProduto Of oMainWnd PIXEL
		oListBox := TWBrowse():New( 25,2,200,69,,{RetTitle("GI_PRODORI"),RetTitle("GI_PRODALT"),RetTitle("GI_FATOR"),RetTitle("GI_MRP"),,,},{17,55,55,55,55,55},oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		oListBox:SetArray(aViewSGI)
		oListBox:bLine := { || aViewSGI[oListBox:nAT]}
		@ 110,144  BUTTON STR0109 SIZE 045,010  FONT oDlg:oFont ACTION (oDlg:End())  OF oDlg PIXEL   //"Voltar"
	ACTIVATE MSDIALOG oDlg CENTERED
EndIf
RestArea(aArea)

RETURN

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A710CriaLog ³ Autor ³Rodrigo A Sartorio   ³ Data ³ 27/08/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Avalia as informacoes relacioandas ao evento e caso o log  ³±±
±±³          ³ do MRP esteja ativo alimenta o arquivo de LOG do sistema   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ cEvento   - Codigo do Evento que deve ser avaliado         ³±±
±±³          ³ cProduto  - Codigo do produto que deve ser avaliado        ³±±
±±³          ³ ** A T E N C A O  ** Novos eventos devem ser corretamente  ³±±
±±³          ³ documentados a seguir , incluindo as informacoes dos dados ³±±
±±³          ³ aDados    - Array com os dados utilizados na avaliacao do  ³±±
±±³          ³ evento informado                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ NENHUM                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA710                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Evento 001 - Saldo em estoque inicial menor que zero
aDados[1] - Saldo inicial do Produto
Evento 002 - Atrasar o evento
aDados[1] - Data original
aDados[2] - Numero do Documento
aDados[3] - Item ou outro dado complementar do documento
aDados[4] - Alias do documento
aDados[5] - Data para atrasar
Evento 003 - Adiantar o evento
aDados[1] - Data original
aDados[2] - Numero do Documento
aDados[3] - Item ou outro dado complementar do documento
aDados[4] - Alias do documento
aDados[5] - Data para atrasar
Evento 004 - Data de necessidade invalida - Data anterior a database
aDados[1] - Codigo do produto que gerou a necessidade
aDados[2] - Quantidade da necessidade
aDados[3] - Data calculada
Evento 005 - Data de necessidade invalida - Data posterior ao prazo maximo do MRP
aDados[1] - Codigo do produto que gerou a necessidade
aDados[2] - Quantidade da necessidade
aDados[3] - Data calculada
Evento 006 - Documento planejado em atraso
aDados[1] - Data planejada do evento
aDados[2] - Numero do Documento
aDados[3] - Item ou outro dado complementar do documento
aDados[4] - Alias do documento
Evento 007 - Cancelar o documento
aDados[1] - Data do documento
aDados[2] - Numero do Documento
aDados[3] - Item ou outro dado complementar do documento
aDados[4] - Alias do documento
Evento 008 - Saldo em estoque maior ou igual ao estoque maximo
aDados[1] - Estoque maximo
aDados[2] - Saldo em estoque
aDados[3] - Data do periodo
aDados[4] - Alias do documento
Evento 009 - Saldo em estoque menor ou igual ao ponto de pedido
aDados[1] - Ponto de pedido
aDados[2] - Saldo em estoque
aDados[3] - Data do periodo
aDados[4] - Alias do documento
*/
USER Function XA710CriaLOG(cEvento,cProduto,aDados,lLogMRP,c711NumMrp)
LOCAL aDescEventos:={},aDocs:={}
LOCAL nAcho:=0,nAchoDoc:=0
LOCAL cDocumento:="",cTexto:="",cItem:="",cArquivo:="",cCodOri:=""
LOCAL aTamSB2:= {}

// Array contendo a descricao dos documentos
AADD(aDocs,{"SC1",STR0018})
AADD(aDocs,{"SC7",STR0019})
AADD(aDocs,{"SC2",STR0020})
AADD(aDocs,{"SHC",STR0021})
AADD(aDocs,{"SD4",STR0022})
AADD(aDocs,{"SC6",STR0023})
AADD(aDocs,{"SC4",STR0024})
AADD(aDocs,{"AFJ",STR0036})
AADD(aDocs,{"ENG",STR0084})
AADD(aDocs,{"SB1",STR0160})
AADD(aDocs,{"SBP",STR0167})

// Array contendo o codigo dos eventos e a descricao relacionada
AADD(aDescEventos,{"001",OemToAnsi(STR0069)}) //"Saldo em estoque inicial menor que zero. Saldo "
AADD(aDescEventos,{"002",OemToAnsi(STR0074)}) //"Atrasar o documento "
AADD(aDescEventos,{"003",OemToAnsi(STR0080)}) //"Adiantar o documento "
AADD(aDescEventos,{"004",OemToAnsi(STR0070)}) //"Data de necessidade invalida - Data anterior a database do calculo. Produto origem da necessidade "
AADD(aDescEventos,{"005",OemToAnsi(STR0071)}) //"Data de necessidade invalida - Data posterior a data limite do calculo. Produto origem da necessidade "
AADD(aDescEventos,{"006",OemToAnsi(STR0072)}) //"Documento planejado em atraso. Planejado para "
AADD(aDescEventos,{"007",OemToAnsi(STR0075)}) //"Cancelar o documento "
AADD(aDescEventos,{"008",OemToAnsi(STR0161)}) //"Saldo em estoque maior que o estoque maximo "
AADD(aDescEventos,{"009",OemToAnsi(STR0162)}) //"Saldo em estoque menor ou igual ao ponto de pedido "

// Verifica se o evento esta cadastrado
nAcho:=ASCAN(aDescEventos,{|x| x[1] == cEvento})

// Busca posicao do alias de acordo com o evento
// Eventos sem alias devem ser adicionados nesta condicao
If !(cEvento $ "001*004*005")
	nAchoDoc := aScan(aDocs,{|x| x[1] == aDados[4]})
EndIf
// So avalia eventos se o LOG do MRP estiver ativo
If lLogMRP .And. nAcho > 0
	aTamSB2 := TamSX3("B2_QATU")
	If cEvento == "001" .And. QtdComp(aDados[1]) < QtdComp(0)
		cTexto   := aDescEventos[nAcho,2] +AllTrim(Str(aDados[1],aTamSB2[1],aTamSB2[2]))
	ElseIf cEvento == "002"
		cTexto := aDescEventos[nAcho,2] +AllTrim(aDados[2]) +If(!Empty(aDados[3])," / " +AllTrim(aDados[3]),"") +" - "
		cTexto += aDocs[nAchoDoc,2] +OemToAnsi(STR0079) +DTOC(aDados[1]) +OemToAnsi(STR0077)+DTOC(aDados[5]) //" de "###" para "
		cDocumento := aDados[2]
		cItem := aDados[3]
		cArquivo := aDados[4]
	ElseIf cEvento == "003"
		cTexto := aDescEventos[nAcho,2] +AllTrim(aDados[2]) +If(!Empty(aDados[3])," / " +AllTrim(aDados[3]),"") +" - "
		cTexto +=aDocs[nAchoDoc,2] +OemToAnsi(STR0079)+DTOC(aDados[1])+OemToAnsi(STR0077)+DTOC(aDados[5]) //" de "###" para "
		cDocumento := aDados[2]
		cItem := aDados[3]
		cArquivo := aDados[4]
	ElseIf cEvento == "004"
		cCodOri := aDados[1]
		If aDados[3] < aPeriodos[1]
			cTexto := aDescEventos[nAcho,2] +AllTrim(aDados[1]) +STR0073 +AllTrim(Str(aDados[2],aTamSB2[1],aTamSB2[2])) //" Quantidade "
		ElseIf aDados[3] > aPeriodos[Len(aPeriodos)]
			cEvento := "005"
			nAcho := ASCAN(aDescEventos,{|x| x[1] == cEvento})
			cTexto := aDescEventos[nAcho,2] +AllTrim(aDados[1]) +STR0073 +AllTrim(Str(aDados[2],aTamSB2[1],aTamSB2[2]))	//" Quantidade "
		EndIf
	ElseIf cEvento == "006" .And. aDados[1] < dDataBase
		cTexto := aDescEventos[nAcho,2] +DTOC(aDados[1]) +"." +AllTrim(aDados[2]) +If(!Empty(aDados[3])," / " +AllTrim(aDados[3]),"")
		cTexto += " - " +aDocs[nAchoDoc,2]
		cDocumento := aDados[2]
		cItem := aDados[3]
		cArquivo := aDados[4]
	ElseIf cEvento == "007" .And. aDados[4] # "SBP"
		cTexto := aDescEventos[nAcho,2] +AllTrim(aDados[2]) +If(!Empty(aDados[3])," / " +AllTrim(aDados[3]),"")
		cTexto += " - " +aDocs[nAchoDoc,2] +OemToAnsi(STR0076) +DTOC(aDados[1]) +OemToAnsi(STR0078) //" Data Original "###" pois seu saldo nao sera utilizado em nenhum periodo"
		cDocumento := aDados[2]
		cItem := aDados[3]
		cArquivo := aDados[4]
	ElseIf cEvento == "008"
		cTexto := aDescEventos[nAcho,2] +OemToAnsi(STR0163) +AllTrim(Str(aDados[1],aTamSB2[1],aTamSB2[2])) +OemToAnsi(STR0165)
		cTexto += AllTrim(Str(aDados[2],aTamSB2[1],aTamSB2[2])) +OemToAnsi(STR0166) +DToC(aDados[3]) +" - " +aDocs[nAchoDoc,2]
		cArquivo := aDados[4]
	ElseIf cEvento == "009"
		cTexto := aDescEventos[nAcho,2] +OemToAnsi(STR0164) +AllTrim(Str(aDados[1],aTamSB2[1],aTamSB2[2])) +OemToAnsi(STR0165)
		cTexto += AllTrim(Str(aDados[2],aTamSB2[1],aTamSB2[2])) +OemToAnsi(STR0166) +DToC(aDados[3]) +" - " +aDocs[nAchoDoc,2]
		cArquivo := aDados[4]
	EndIf
	If !Empty(cTexto)
		A710GrvLog(cProduto,cEvento,cTexto,AllTrim(cDocumento),AllTrim(cItem),cArquivo,cCodOri,c711NumMrp)
	EndIf
EndIf
RETURN

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A710GrvLog  ³ Autor ³Rodrigo A Sartorio   ³ Data ³ 02/09/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava as informacoes no arquivo de LOG do MRP para         ³±±
±±³          ³ conferencia do usuario                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ cProduto   - Codigo do produto do Log                      ³±±
±±³          ³ cCodigoLog - Codigo do Log                                 ³±±
±±³          ³ cTextoLog  - Texto do Log                                  ³±±
±±³          ³ cDocumento - Documento envolvido no log                    ³±±
±±³          ³ cItem      - Item do documento envolvido no log            ³±±
±±³          ³ cArquivo   - Arquivo envolvido no LOG                      ³±±
±±³          ³ cCodOri    - Codigo do produto origem da necessidade       ³±±
±±³          ³ c711NumMrp - Numero do MRP                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ NENHUM                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA710                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A710GrvLog(cProduto,cCodigoLog,cTextoLog,cDocumento,cItem,cArquivo,cCodOri,c711NumMrp)
Local aArea:=GetArea()
DEFAULT c711NumMrp := CriaVar("HG_SEQMRP",.F.)
DEFAULT cProduto   := CriaVar("HG_COD",.F.)
DEFAULT cCodigoLog := CriaVar("HG_CODLOG",.F.)
DEFAULT cTextoLog  := CriaVar("HG_LOGMRP",.F.)
DEFAULT cDocumento := CriaVar("HG_DOC",.F.)
DEFAULT cItem      := CriaVar("HG_ITEM",.F.)
DEFAULT cArquivo   := CriaVar("HG_ALIAS",.F.)
DEFAULT cCodOri    := CriaVar("HG_CODORI",.F.)
Reclock("SHG",.T.)
Replace HG_FILIAL With xFilial("SHG")
Replace HG_SEQMRP With c711NumMRP
Replace HG_COD    With cProduto
Replace HG_CODLOG With cCodigoLog
Replace HG_LOGMRP With cTextoLog
Replace HG_DOC    With cDocumento
Replace HG_ITEM   With cItem
Replace HG_ALIAS  With cArquivo
Replace HG_CODORI With cCodOri
MsUnlock()
RestArea(aArea)
RETURN

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A711ShLog  ³ Autor ³Rodrigo A Sartorio   ³ Data ³ 15/09/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Mostra os dados do LOG do MRP para o produto posicionado   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA710                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static function A711ShLog()
Local aArea		:= GetArea()
Local cCargo	:= oTreeM711:GetCargo()
Local nPos		:= AsCan(aDbTree,{|x| x[7]==SubStr(cCargo,3,12)})
Local cProduto	:= Iif(Empty(nPos),Space(15),aDbTree[nPos,1])
Local cCadastro	:= OemToAnsi(STR0068) //"Log de eventos do MRP"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicoes para montagem da getdados                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oDlg
Local oGetd
Local aObjects   := {}
Local aPosObj    := {}
Local aSize      := MsAdvSize()
Local aInfo      := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta aHeader e aCols                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cSeek      := xFilial("SHG")+c711NumMRP
Local bSeekWhile := { || SHG->HG_FILIAL+SHG->HG_SEQMRP } //Condicao While para montar o aCols
Local aNoFields  := {}
Private aHeader  := {}
Private aCols    := {}
Private aRotina  := {	{ "","",0,1},; //"Pesquisar"
						{ "","",0,2}}  //"Visualizar"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se consulta LOG total ou do produto                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(cProduto) .And. (Substr(cCargo,1,2) <> "00")
	aNoFields  := {"HG_COD"}
	cCadastro  += " - "+cProduto
	cSeek      += cProduto
	bSeekWhile := { || SHG->HG_FILIAL+SHG->HG_SEQMRP+SHG->HG_COD }
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Sintaxe da FillGetDados(/*nOpcX*/,/*Alias*/,/*nOrdem*/,/*cSeek*/,/*bSeekWhile*/,/*uSeekFor*/,/*aNoFields*/,/*aYesFields*/,/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/,/*lEmpty*/,/*aHeaderAux*/,/*aColsAux*/,/*bAfterCols*/) |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FillGetDados(1,'SHG',1,cSeek,bSeekWhile,,aNoFields,,,,,,,,,)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso possua informacoes apresenta GETDADOS com as Informaçoes             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aCols) > 0
	// Array com objetos utilizados
	AADD(aObjects,{70,70,.T.,.T.,.F.})
	aPosObj:=MsObjSize(aInfo,aObjects)
	DEFINE MSDIALOG oDlg TITLE cCadastro OF oMainWnd PIXEL FROM aSize[7],0 TO aSize[6],aSize[5]
	oGetd := MsGetDados():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],1)
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()})
EndIf
RestArea(aArea)
RETURN

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AReadSha   ³ Autor ³Marcelo Iuspa        ³ Data ³ 03/12/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna a quantidade no periodo conforme o tipo informado  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA710                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XAReadSha(cProduto, dEntrega, cTipo)
Local cPeriodo := A650DtoPer(dEntrega)
Local aSavAre  := SHA->(GetArea())
Local cCampo   := "SHA->HA_PER" + cPeriodo
Local nNeces   := 0
SHA->(dbSetOrder(1))

If SHA->(dbSeek(xFilial("SHA") + cProduto + Criavar("C2_OPC",.F.) + cTipo))
	nNeces := &cCampo
EndIf
(Alias())->(RestArea(aSavAre))
Return(nNeces)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A711NecMax ³ Autor ³Marcelo Iuspa        ³ Data ³ 27/11/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calcula necessidade baseada no Estoque Maximo (B1_EMAX)    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA710                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XA711NecMax(cProduto, nSaldo, nNecLote)
Local nNecRet := nSaldo + nNecLote
Local nSldMax := A711Sb1EstMax(cProduto)

If aPergs711[19]==2 .And. !Empty(nSldMax) .And. nNecRet > nSldMax
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Caso o saldo para o prox. periodo seja maior que o estoque max.	|
	//| ajusta para o estoque max. (soma nSaldo quando nSaldo < 0 pois	|
	//| essa quantidade nao ficara em estoque).							|
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nNecRet := nSldMax + If(nSaldo < 0,Abs(nSaldo),0)
Else
	nNecRet := nNecLote
Endif

Return(nNecRet)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A711LotMax ³ Autor ³Marcelo Iuspa        ³ Data ³ 27/11/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta retorno da CalcLote tratando Estoque Maximo (B1_EMAX)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA710                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function ZA711LotMax(cProduto, nQuant, aQtdes, lForce)
Local aLotRet := aClone(aQtdes)
Local nSoma   := 0
Local x
Default lForce := .F.

If (lForce .Or. aPergs711[19]==2) .And. nSoma < nQuant
	aLotRet := {}
	For x := 1 to Len(aQtdes)
		If nSoma < nQuant
			Aadd(aLotRet, Min(aQtdes[x], nQuant - nSoma	))
			nSoma += aLotRet[Len(aLotRet)]
		Endif
	Next
Endif

Return(aLotRet)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A711Sb1EstMax ³ Autor ³Marcelo Iuspa     ³ Data ³ 27/11/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna o estoque maximo de um produto                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA710                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XA711Sb1EstMax(cProduto)
Static aEstMax := {}
Local  nSeek   := 0
Local  aSavSb1 := Nil

If Len(aEstMax) > 4000
	aEstMax := {}
Endif

If (nSeek := aScan(aEstMax, {|z| z[1] == cProduto})) == 0
	aSavSb1 := SB1->(GetArea())
	SB1->(dbSetOrder(1))
	SB1->(MsSeek(xFilial("SB1") + cProduto))
	Aadd(aEstMax, {cProduto, RetFldProd(SB1->B1_COD,"B1_EMAX")})
	(Alias())->(RestArea(aSavSb1))
	nSeek := Len(aEstMax)
Endif

Return(aEstMax[nSeek, 2])

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PutAspas   ³ Autor ³Marcelo Iuspa        ³ Data ³ 12/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Adiciona aspas no inicio e fim de uma string fornecida     ³±±
±±³          ³ tratando caso haja aspas no no conteudo da string          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ cStr  - String a ser adicionado aspas                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³       - String fornecida acrescentada de aspas no inicio e ³±±
±±³          ³         no fim                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XPutAspas(cStr)
Local cAspDup := Chr(34)
Local cAspSim := Chr(39)
Local cAbrCol := "["
Local cFecCol := "]"
Local nLenOri := Len(cStr)
Local cRet    := cStr

If cAspDup $ cStr .And. cAspSim $ cStr .And. (cAbrCol $ cStr .Or. cFecCol $ cStr)
	cRet := Pad(StrTran(cRet, cAbrCol, ""), nLenOri)
	cRet := Pad(StrTran(cRet, cFecCol, ""), nLenOri)
	cRet := cAbrCol + cRet + cFecCol
ElseIf ! cAspSim $ cStr
	cRet := cAspSim + cRet + cAspSim
ElseIf ! cAspDup $ cStr
	cRet := cAspDup + cRet + cAspDup
ElseIf ! cAspSim $ cStr
	cRet := cAspSim + cRet + cAspSim
ElseIf ! (cAbrCol $ cStr .Or. cFecCol $ cStr)
	cRet := cAbrCol + cRet + cFecCol
Endif
Return(cRet)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A710NextUtil³ Autor ³Marcelo Iuspa        ³ Data ³ 02/02/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna proxima segunda se data for sab/dom e parametro    ³±±
±±³          ³ de considera sabado/domingo estiver como NAO               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ dData     - Data a ser avaliada                            ³±±
±±³          ³ aPergs711 - Array com as perguntas a serem consideradas    ³±±
±±³          ³ lMontSHA  - Define se a funcao esta sendo chamada na       ³±±
±±³          ³ montagem da tabela SHA                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ dData - Acrescida de 1 ou 2 dias se for sab/dom            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XA710NextUtil(dData,aPergs711,lMontSHA)
Local dDataOld := dData
Local dDataNew := dData
Local lWeekend := aPergs711[12] == 1 //Considera Sab.Dom

Default lMontSHA := .F.

If !lWeekend .And. Dow(dData) == 7
	dData += 2
ElseIf !lWeekend .And. Dow(dData) == 1
	dData += 1
Endif
dDataNew := dData
// Ponto de entrada para alterar a data a ser considerada nos documentos.
If ExistBlock("A710DTUTIL")
	dData := ExecBlock("A710DTUTIL",.F.,.F.,{dData, lWeekend, dDataOld, lMontSHA})
	If ValType(dData) != "D"
		dData := dDataNew
	EndIf
EndIf
Return(dData)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³RetExecBlock³ Autor ³Marcelo Iuspa        ³ Data ³ 14/05/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna o resultado de um execblock ou o seu default       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cNome          - Nome do ExecBlock                         ³±±
±±³          ³ aParam         - Array com parametros                      ³±±
±±³          ³ cTipoRetorno   - Tipo do retorno (C, D, N, L, B, A)        ³±±
±±³          ³ xRetornoPadrao - Retorno padrao                            ³±±
±±³          ³ lSave          - Parametro lSave do ExecBlock (default .F.)³±±
±±³          ³ lSets          - Parametro lSets do ExecBlock (default .F.)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Resultado do ExecBlock   ou                                ³±±
±±³          ³ Retorno padrao (caso nao exista o ExecBlock ou o retorno   ³±±
±±³          ³ nao for do tipo esperado                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XRetExecBlock(cNome,aParam,cTipoRetorno,xRetornoPadrao,lSave,lSets,lBlock)
Local xRetBlock := Nil
Default lSave   := .F.
Default lSets   := .F.

// Verifica a existencia do EXECBLOCK somente uma vez
If Valtype(lBlock) # "L"
	lBlock := ExistBlock(cNome)
EndIf

// Executa EXECBLOCK
If lBlock
	If ValType(xRetBlock := ExecBlock(cNome, lSave, lSets, aParam)) == cTipoRetorno
		xRetornoPadrao := xRetBlock
	Endif
Endif

Return(xRetornoPadrao)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A710StrRev  ³ Autor ³Marcelo Iuspa        ³ Data ³ 28/06/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna STRING com numero da revisao caso esteja em uso    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ cRevisao   - Revisao utilizada                             ³±±
±±³          ³ cStrAntes  - Texto usado antes                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ STRING referente a revisao ou ""                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XA710StrRev(cRevisao, cStrAntes)
Local cRet := ""

If A710TrataRev() .And. ! Empty(cRevisao)
	Default cStrAntes := " "
	cRet := cStrAntes + STR0082 + ": " + cRevisao //"Rev"
Endif

Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A710QtdCQ ³ Autor ³ Marcelo Iuspa         ³ Data ³ 17/02/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Calcula o saldo rejeitado do produto no almoxarifado de CQ. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA710                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XA710QtdCQ(cProduto, cLocal, dData)
Local aArea  := {SD7->(GetArea()), GetArea()}
Local bBloco := {|| D7_LOCDEST == cLocal .And. D7_DATA < dData .And. D7_ESTORNO != "S"}
Local nQtde  := 0

Default dData  := dDataBase
Default cLocal := GetMv("MV_CQ")

/*
SD7 - TRANSFERENCIAS PARA CQ (Modo=E)

1  D7_FILIAL+D7_NUMERO+D7_PRODUTO+D7_LOCAL+D7_SEQ+dtos(D7_DATA)
2  D7_FILIAL+D7_NUMERO+D7_PRODUTO+D7_LOCAL+D7_NUMSEQ+STR(D7_TIPO)
3  D7_FILIAL+D7_PRODUTO+D7_NUMSEQ+D7_NUMERO
*/

dbSelectArea("SD7")
dbSetOrder(3)
dbSeek(xFilial("SD7")+cProduto)
Do While !Eof() .And. D7_FILIAL+D7_PRODUTO == xFilial("SD7")+cProduto
	If ! Eval(bBloco)
		dbSkip()
		Loop
	Endif
	If     D7_TIPO == 1   // Liberada
		//nQtde -= SD7->D7_QTDE
	ElseIf D7_TIPO == 2   // Rejeitada
		If SD7->D7_QTDE > 0
			nQtde += A710AbDev(SD7->D7_FORNECE,SD7->D7_LOJA,SD7->D7_DOC,SD7->D7_SERIE)
		Endif
	ElseIf D7_TIPO == 6   // Estorno da Liberacao
		nQtde += SD7->D7_QTDE
	ElseIf D7_TIPO == 7   // Estorno da Rejeicao
		//nQtde -= SD7->D7_QTDE
	Endif
	dbSkip()
EndDo
RestArea(aArea[1])
RestArea(aArea[2])
Return(nQtde)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A710OpcOp ³ Autor ³ Marcelo Iuspa         ³ Data ³ 17/03/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna os opcionais da OP informada                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA710                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XA710OpcOp(cOp)
Local aSavAre := {GetArea(), SC2->(GetArea())}
Local cOpc    := Space(Len(SC2->C2_OPC))

SC2->(dbSetOrder(1))
If SC2->(dbSeek(cOp))
	cOpc := SC2->C2_OPC
Endif
RestArea(aSavAre[2])
RestArea(aSavAre[1])
Return(cOpc)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³M710FilNec³ Autor ³ Erike Yuri da Silva   ³ Data ³ 04/05/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Ativa Filtro exibindo somente os produtos com necessidade   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA710                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function M710FilNec()
Local nI,nRecSHA := SHA->(RecNo())
Local aLstFiltro := {}
Local lTemNecess := .F.
Local cFilSHA	 := ""
Local cFilSH5	 := ""
Local lRet		 := .T.

If !lAtvFilNes
	If Empty(cFilNess)
		SHA->(DbGotop())
		While SHA->(!Eof())
			If SHA->HA_TIPO!="6"
				SHA->(DbSkip())
				Loop
			EndIf
			lTemNecess := .F.
			//Verifica se tem necessidade para algum periodo
			For nI:=1 to aOpcoes[2][1]
				If SHA->&("HA_PER"+StrZero(nI,3)) # 0
					lTemNecess := .T.
				EndIf
			Next
			If lTemNecess  .and. Empty(AsCan(aLstFiltro,{|x| x==SHA->HA_PRODUTO}))
				Aadd(aLstFiltro,SHA->HA_PRODUTO)
			EndIf
			SHA->(DbSkip())
		EndDo
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Guarda os produtos que serao listados                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nI:=1 to Len(aLstFiltro)
			cFilNess += aLstFiltro[nI]+'|'
		Next

		If Empty(cFilNess)
			SHA->(MsGoto(nRecSHA))
			Alert(STR0089) //"Nao existem itens com necessidade a serem filtrados!"
			lRet := .F.
		EndIf
	EndIf
	If lRet
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Filtra a tabela SHA                                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cFilSHA := 'HA_PRODUTO $ "'+cFilNess+'"'
		SHA->(dbSetFilter({|| &cFilSHA}, cFilSHA))
		SHA->(DbGotop())

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Filtra a tabela SH5                                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cFilSH5 := 'H5_PRODUTO $ "'+cFilNess+'" .OR. Empty(H5_PRODUTO)'
		SH5->(dbSetFilter({|| &cFilSH5}, cFilSH5))
		MT711Tree(aPergs711[28]==1)
		lAtvFilNes := .T.
	EndIf
Else
	SHA->(DBCLEARFILTER())
	SH5->(DBCLEARFILTER())
	MT711Tree(aPergs711[28]==1)
	lAtvFilNes := .F.
EndIf
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³M710FilGen³ Autor ³ Erike Yuri da Silva   ³ Data ³ 02/09/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Ativa Filtro generico utilizando a tabela SB1.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA710                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function M710FilGen(oDlg)
Local nI
Local cFilSB1	 := ""
Local cFilSH5	 := ""
Local cExpFiltro := SB1->(BuildExpr("SB1") )
Local aProdAux	 := {}
Local lContinua	 := .T.

If Empty(cExpFiltro)
	//Restaura situalcao anterior
	If Empty(cFilSB1Old)
		SB1->(DBClearFilter())
	Else
		SB1->(DBClearFilter())
		SB1->(dbSetFilter({|| &cFilSB1Old}, cFilSB1Old))
	EndIf
	SH5->(DBClearFilter())
	MT711Tree(aPergs711[28]==1)
	lAtvFilNes	:= .F.
	lContinua	:= .F.
EndIf

If lContinua
	SB1->(dbSetFilter({|| &cExpFiltro}, cExpFiltro))
	SB1->(DbGotop())
	While SB1->(!Eof())
		If Empty(AsCan(aProdAux,{|x| x == SB1->B1_COD}))
			Aadd(aProdAux,SB1->B1_COD)
			cFilSB1 += SB1->B1_COD+"|"
		EndIf
		SB1->(DbSkip())
	EndDo

	//Restaura situalcao anterior
	If Empty(cFilSB1Old)
		SB1->(DBClearFilter())
	Else
		SB1->(DBClearFilter())
		SB1->(dbSetFilter({|| &cFilSB1Old}, cFilSB1Old))
	EndIf
EndIf

If lContinua .And. Empty(aProdAux)
	lContinua := .F.
EndIf

If lContinua
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra a tabela SH5 com base na tabela SB1.                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cFilSH5 := 'H5_PRODUTO $ "'+cFilSB1+'"'
	SH5->(dbSetFilter({|| &cFilSH5}, cFilSH5))
	MT711Tree(aPergs711[28]==1)
EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³A710DSaldo³ Autor ³Erike Yuri da Silva    ³ Data ³ 20/10/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Detalhamento do Saldo em Estoque do MRP                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cProduto      Codigo do Produto a ser analisado            ³±±
±±³          ³ nSaldo        Variavel que retornara por passagem de       ³±±
±±³          ³               parametro o saldo em estoque do produto      ³±±
±±³          ³               posicionado.                                 ³±±
±±³          ³ aFilAlmox     Variavel de controle para customizacao       ³±±
±±³          ³ lViewDetalhe  Permite visualizar gera detalhamento do saldo³±±
±±³          ³ aViewB2       Array com detalhamento dos saldos por local. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno  ³ Array com os saldos do produto aglutinados por armazem     ³±±
±±³          ³ [1] Saldo Disponivel                                       ³±±
±±³          ³ [2] QTD NOSSO EM TERCEIROS                                 ³±±
±±³          ³ [3] QTD TECEIROS EM NOSSO PODER                            ³±±
±±³          ³ [4] SALDO REJEITADO PELO CQ                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA710                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XA710DSaldo(cProduto,nSaldo,aFilAlmox,lViewDetalhe,aViewB2,nEstSeg)
Local nSldLocPos,nSldNs3,nSld3Ns,nSldRejCQ,nSldSDD,nSldPE
Local cChaveSB6
Local cQuerySB6
Local aRetSldTot  := {0,0,0,0,0}     //Retorno dos saldos totalizados quando eh visualizado os detalhes
Local lEstSeg     := aPergs711[26] == 1
Local aAreaSB1    := SB1->(GetArea())

Default nSaldo 		:= 0
Default aFilAlmox   := Nil
Default lViewDetalhe:= .F.
Default aViewB2		:= {}

SB1->(MsSeek(xFilial("SB1")+cProduto))
If lEstSeg
	nEstSeg := CalcEstSeg( RetFldProd(SB1->B1_COD,"B1_ESTFOR") )
	nSaldo	-= nEstSeg
EndIf
nSldNs3 := 0
nSld3Ns := 0

dbSelectArea("SB2")
dbSetOrder(1)
MsSeek(xFilial("SB2")+cProduto+cAlmoxd,.T.)
While !Eof() .And. B2_FILIAL+B2_COD == xFilial("SB2")+cProduto .And. B2_LOCAL <= cAlmoxa

	If (aFilAlmox # Nil .And. aScan(aFilAlmox, SB2->B2_LOCAL) == 0) .Or.;
			(aAlmoxNNR # Nil .And. aScan(aAlmoxNNR, SB2->B2_LOCAL) == 0)
		dbSkip()
		Loop
	Endif
	
	If cMT710B2 # Nil .And. ! &(cMT710B2)
		dbSkip()
		Loop
	Endif

	nSldLocPos 	:= 0
	nSldLocPos 	:=If(aPergs711[18]==1,SB2->B2_QATU,CalcEst(SB2->B2_COD,SB2->B2_LOCAL,aPeriodos[1]+1)[1]) - A710LotVnc(cProduto,aPeriodos[1],SB2->B2_LOCAL)
	nSaldo		+= nSldLocPos
	If lViewDetalhe
		aAdd(aViewB2,{	TransForm(SB2->B2_LOCAL,cPictB2Local),;				 	//[1] LOCAL
						TransForm(nSldLocPos,cPictB2Qatu),;					    //[2] SALDO ATUAL OU POR MOVIMENTO
						"-",;													//[3] QTD NOSSO EM TERCEIROS
						"-",;													//[4] QTD TECEIROS EM NOSSO PODER
						"-",;                                                   //[5] SALDO REJEITADO PELO CQ
						"-",;                                                   //[6] SALDO BLOQUEADO POR LOTE
						NIL})    											    //[7] SALDO A SER CONSIDERADO
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se usado saldo atual leio poder de 3§ do SB2³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Considera quantidade nossa em poder de 3§   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aPergs711[18] == 1 .And. aPergs711[20] == 1
		nSaldo += SB2->B2_QNPT
		If lViewDetalhe
			nSldLocPos 		+= SB2->B2_QNPT
			aRetSldTot[2] 	+= SB2->B2_QNPT
			aViewB2[Len(aViewB2),3] := TransForm(SB2->B2_QNPT,cPictB2QNPT)
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Considera quantidade de 3§ em nosso poder   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aPergs711[18] == 1 .And. aPergs711[21] == 1
		nSaldo -= SB2->B2_QTNP
		If lViewDetalhe
			nSldLocPos 		-= SB2->B2_QTNP
			aRetSldTot[3] 	+= SB2->B2_QTNP
			aViewB2[Len(aViewB2),4] := TransForm(SB2->B2_QTNP,cPictB2QTNP)
		EndIf
	EndIf

	If aPergs711[22] == 1
		nSldRejCQ	:= A710QtdCQ(SB2->B2_COD, SB2->B2_LOCAL, aPeriodos[1]+1)
		nSaldo	    -= nSldRejCQ
		If lViewDetalhe
			nSldLocPos   	-= nSldRejCQ
			aRetSldTot[4] 	+= nSldRejCQ
			aViewB2[Len(aViewB2),5] := TransForm(nSldRejCQ,cPictD7QTDE)
		EndIf
	Endif

	If aPergs711[25] == 1
		nSldSDD := A710QtdDD(SB2->B2_COD, SB2->B2_LOCAL)
		nSaldo  -= nSldSDD
		If lViewDetalhe
			nSldLocPos   	-= nSldSDD
			aRetSldTot[5] 	+= nSldSDD
			aViewB2[Len(aViewB2),6] := TransForm(nSldSDD,cPictDDSaldo)
		EndIf
	Endif

	If (aFilAlmox # Nil .Or. cMT710B2 # Nil .Or. aAlmoxNNR # Nil) .And. aPergs711[18] == 2
		If Empty(aViewB2)
			aAdd(aViewB2,{"*",TransForm(nSaldo,cPictB2Qatu),"-",TransForm(nSld3Ns,cPictB2QTNP),"-","-",TransForm(nSaldo,cPictB2Qatu)})
		Else
			aViewB2[Len(aViewB2),1] := "*"
		EndIf
		If aPergs711[20] == 1
			nSldNs3 := SaldoTerc(SB2->B2_COD, SB2->B2_LOCAL, "T", aPeriodos[1]+1, SB2->B2_LOCAL)[1]
			nSaldo	+= nSldNs3
			If lViewDetalhe
				nSldLocPos 		+= nSldNs3
				aRetSldTot[2] 	+= nSldNs3
				aViewB2[Len(aViewB2),3] := TransForm(nSldNs3,cPictB2QNPT)
			EndIf
		Endif
		If aPergs711[21] == 1
			nSld3Ns := SaldoTerc(SB2->B2_COD, SB2->B2_LOCAL, "D", aPeriodos[1]+1, SB2->B2_LOCAL)[1]
			nSaldo	-= nSld3Ns
			If lViewDetalhe
				nSldLocPos		-= nSld3Ns
				aRetSldTot[3] 	+= nSld3Ns
				aViewB2[Len(aViewB2),4] := TransForm(nSld3Ns,cPictB2QTNP)
			EndIf
		Endif
	Endif
	If lViewDetalhe
		aRetSldTot[1]		+= nSldLocPos
		aViewB2[Len(aViewB2),7] := TransForm(nSldLocPos,cPictB2Qatu)
	EndIf
	dbSkip()
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MV_PAR18    ->  Considera Sld Estoque      1- Atual         2- Calcest    ³
//³ MV_PAR20    ->  Qtd. nossa Poder 3         1- Soma          2- Ignora     ³
//³ MV_PAR21    ->  Qtd. 3§ nosso Poder        1- Subtrai       2- Ignora     ³
//³ MV_PAR22    ->  Saldo rejeitado pelo CQ    1-Subtrai        2- Nao Subtrai³
//³ MV_PAR23    ->  PV/PMP De  Documento                                      ³
//³ MV_PAR24    ->  PV/PMP Ate Documento                                      ³
//³ MV_PAR25    ->  Saldo bloqueado            1-Subtrai        2- Nao Subtrai³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nSld3Ns := 0
nSldNs3 := 0
If aPergs711[18] == 2 .And. aFilAlmox == Nil .And. cMT710B2 # Nil .And. aAlmoxNNR == Nil
	If aPergs711[20] == 1
		nSldNs3 := SaldoTerc(cProduto, cAlmoxd, "T", aPeriodos[1]+1, cAlmoxa)[1]
		nSaldo	+= nSldNs3
		If lViewDetalhe
			aRetSldTot[2] 	+= nSldNs3
			aRetSldTot[1] 	:= nSaldo
			aAdd(aViewB2,{"*",TransForm(nSaldo,cPictB2Qatu),TransForm(nSldNs3,cPictB2QNPT),"-","-","-",TransForm(nSaldo,cPictB2Qatu)})
		EndIf
	Endif

	If aPergs711[21] == 1
		nSld3Ns := SaldoTerc(cProduto, cAlmoxd, "D", aPeriodos[1]+1, cAlmoxa)[1]
		nSaldo	-= nSld3Ns
		If lViewDetalhe
			aRetSldTot[3] 	+= nSld3Ns
			aRetSldTot[1] 	:= nSaldo
			If Empty(aViewB2)
				aAdd(aViewB2,{"*",TransForm(nSaldo,cPictB2Qatu),"-",TransForm(nSld3Ns,cPictB2QTNP),"-","-",TransForm(nSaldo,cPictB2Qatu)})
			Else
				aViewB2[Len(aViewB2),4] := TransForm(nSld3Ns,cPictB2QTNP)
				aViewB2[Len(aViewB2),7] := TransForm(nSaldo,cPictB2Qatu)
			EndIf
		EndIf
	Endif
Endif

If lA710SINI
	nSldPE := ExecBlock("A710SINI",.F.,.F.,{cProduto,nSaldo})
	If ValType(nSldPE) == "N"
		nSaldo := nSldPE
	EndIf
EndIf

RestArea(aAreaSB1)

Return aClone(aRetSldTot)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³A710ViewSl³ Autor ³Erike Yuri da Silva    ³ Data ³ 20/10/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Visualizador do Detalhamento de saldos em estoque do produ-³±±
±±³          ³ do pocissionado no Tree.                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA710                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A710ViewSld(aFilAlmox)
Local oDlg,oBold,oListBox
Local aViewB2 := {}
Local aSaldos := {}
aSaldos := A710DSaldo(cProdDetSld,Nil,@aFilAlmox,.T.,aViewB2)
If Empty(aViewB2)
	Aviso(STR0043,STR0108,{STR0109},2) //"Atencao"###"Nao exitem informacoes a serem visualizadas. Verifique se o produto foi selecionado no Tree."###"Voltar"
Else
	DbSelectArea("SB1")
	DbSetOrder(1)
	MsSeek(xFilial("SB1")+cProdDetSld)

	DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
	DEFINE MSDIALOG oDlg FROM 000,000  TO 350,600 TITLE STR0110 Of oMainWnd PIXEL  //"Detalhamento do Saldo em Estoque Disponivel no Calculo do MRP"
		@ 023,004 To 24,296 Label "" of oDlg PIXEL
		@ 113,004 To 114,296 Label "" of oDlg PIXEL
		oListBox := TWBrowse():New( 30,2,297,69,,{RetTitle("B2_LOCAL"),RetTitle("B2_QATU"),RetTitle("B2_QNPT"),RetTitle("B2_QTNP"),STR0111,STR0121,STR0112},{17,55,55,55,55,55},oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)  //"Qtd.Rej.CQ"###"Qtd.Bloqueada por Lote"###"Sld.Disponivel"
		oListBox:SetArray(aViewB2)
		oListBox:bLine := { || aViewB2[oListBox:nAT]}
		@ 004,010 SAY SM0->M0_CODIGO+"/"+FWGETCODFILIAL+" - "+SM0->M0_FILIAL+"/"+SM0->M0_NOME  Of oDlg PIXEL SIZE 245,009
		@ 014,010 SAY Alltrim(cProdDetSld)+ " - "+SB1->B1_DESC Of oDlg PIXEL SIZE 245,009 FONT oBold
		@ 104,010 SAY STR0113 Of oDlg PIXEL SIZE 30 ,9 FONT oBold  //"TOTAL "

		@ 120,007 SAY STR0114 of oDlg PIXEL //"Quantidade Disponivel    "
		@ 119,075 MsGet aSaldos[1] Picture PesqPict("SB2","B2_QATU") of oDlg PIXEL SIZE 070,009 When .F.

		@ 120,155 SAY RetTitle("B2_QNPT") of oDlg PIXEL
		@ 119,223 MsGet aSaldos[2] Picture PesqPict("SB2","B2_QEMP") of oDlg PIXEL SIZE 070,009 When .F.

		@ 135,007 SAY RetTitle("B2_QTNP") of oDlg PIXEL
		@ 134,075 MsGet aSaldos[3] Picture PesqPict("SB2","B2_QATU") of oDlg PIXEL SIZE 070,009 When .F.

		@ 135,155 SAY STR0111 of oDlg PIXEL  //"Qtd.Rej.CQ"
		@ 134,223 MsGet aSaldos[4] Picture PesqPict("SB2","B2_SALPEDI") of oDlg PIXEL SIZE 070,009 When .F.

		@ 150,007 SAY STR0121 of oDlg PIXEL
		@ 149,075 MsGet aSaldos[5] Picture PesqPict("SDD","DD_SALDO") of oDlg PIXEL SIZE 070,009 When .F.

		@ 160,244  BUTTON STR0109 SIZE 045,010  FONT oDlg:oFont ACTION (oDlg:End())  OF oDlg PIXEL   //"Voltar"
	ACTIVATE MSDIALOG oDlg CENTERED
EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A710QtdDD ³ Autor ³Rodrigo de A Sartorio  ³ Data ³ 27/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Calcula o saldo bloqueado do produto no arquivo SDD         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA710                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function ZA710QtdDD(cProduto, cLocal)
Local aArea  := {SDD->(GetArea()), GetArea()}
Local nQtde  := 0

dbSelectArea("SDD")
dbSetOrder(2)
dbSeek(xFilial("SDD")+cProduto+cLocal)
Do While !Eof() .And. DD_FILIAL+DD_PRODUTO+DD_LOCAL == xFilial("SDD")+cProduto+cLocal
	If SDD->DD_MOTIVO # "VV"
		nQtde += SDD->DD_SALDO
	EndIf
	dbSkip()
EndDo
RestArea(aArea[1])
RestArea(aArea[2])
Return(nQtde)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A710LotVnc³ Autor ³Andre Anjos		    ³ Data ³ 09/10/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Calcula o saldo de lotes vencidos, conforme MV_LOTVENC      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA710                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XA710LotVnc(cProduto,dData,cLocal)
Local aArea     := GetArea()
Local lConsVenc := SuperGetMV("MV_LOTVENC",.F.,"N")=="S"
Local nQtde     := 0
Local cLocCQ    := Substr(SuperGetMV("MV_CQ",.F.,"98"),1,2)
Local cFiltro   := ""
Local cArqTrb   := ""
Local nPos      := 0

DEFAULT cLocal := ""

If !lConsVenc .And. Rastro(cProduto)
	nPos := aScan(aPeriodos,dData)
	
	cArqTrb := "LOTVNC"
	cFiltro += "SELECT B8_LOCAL, SUM(B8_SALDO) AS B8_SALDO FROM " +RetSQLName("SB8") +" WHERE "
	cFiltro += "B8_FILIAL = '" +xFilial("SB8") +"' AND D_E_L_E_T_ = ' ' AND B8_PRODUTO = '" +cProduto +"' AND "
	cFiltro += "B8_LOCAL >= '" +aPergs711[8] +"' AND B8_LOCAL <= '" +aPergs711[9] +"' AND B8_SALDO > 0 AND "
	If aPergs711[22] == 1 //ja e tratado indiretamente na A710QtdCQ
		cFiltro += "B8_LOCAL <> '" +cLocCQ +"' AND "
	EndIf
	If cLocal <> ""
		cFiltro += "B8_LOCAL = '" +cLocal+ "' AND "
	EndIf
	If nPos == 1
		cFiltro += "B8_DTVALID > '20000101' AND B8_DTVALID < '" +DToS(dData) +"'"
	Else
		cFiltro += "B8_DTVALID >= '" +DToS(aPeriodos[nPos-1]) +"' AND B8_DTVALID < '" +DToS(dData) +"'"
	EndIf
	cFiltro += "GROUP BY B8_LOCAL"
	cFiltro := ChangeQuery(cFiltro)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cFiltro),cArqTrb,.F.,.T.)

	dbSelectArea(cArqTrb)
	dbGoTop()
	While !(cArqTrb)->(EOF())
		//-- Posiciona no B2 para executar regra do PE MT710B2
		dbSelectArea("SB2")
		dbSetOrder(1)
		MsSeek(xFilial("SB2")+cProduto+(cArqTrb)->B8_LOCAL)
		If (aFilAlmox # Nil) .Or. (aAlmoxNNR # Nil)
			If (aScan(aFilAlmox,B2_LOCAL) > 0 .Or. aScan(aAlmoxNNR,B2_LOCAL) > 0)
				nQtde += (cArqTrb)->B8_SALDO
			EndIf
		Else
			nQtde += (cArqTrb)->B8_SALDO
		EndIf
		(cArqTrb)->(dbSkip())
	End

	(cArqTrb)->(dbCloseArea())
	RestArea(aArea)
EndIf
Return(nQtde)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A710ValNum³ Autor ³Felipe Nunes de Toledo ³ Data ³ 20/10/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida o numero da OP na tabela SC2.                        ³±±
±±³          ³Funcao criada devido inconsistencia da funcao ExistChav(),  ³±±
±±³          ³que posiciona no primeiro recno da tabela, quando nao       ³±±
±±³          ³localizado o registro.                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA710                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XA710ValNum()
Local lRet := .T.

If !Empty(M->C2_ITEM).And.!Empty(M->C2_SEQUEN)
	SC2->(dbSetOrder(1))
	If SC2->(MsSeek(M->C2_NUM+M->C2_ITEM+M->C2_SEQUEN))
		lRet := .F.
	EndIf
EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³XA710OpenFMRPºAutor  ³Erike Yuri da Silva º Data ³  03/14/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao responsavel pela criacao e abertura dos arquivos de    º±±
±±º          ³trabalho do MRP (SH5 e SHA). A RDD obrigatoriamente eh em     º±±
±±º          ³CTREE, devido o tamanho dos campos da chave de indice.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ ExpL1 : Indica se o MRP sera executado em modo visualizacao  º±±
±±º          ³ ExpA1 : Array com estrutura da tabela SH5                    º±±
±±º          ³ ExpA2 : Array com estrutura da tabela SHA                    º±±
±±º          ³ ExpL2 : Indica se esta processando atraves de JOB            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObservacao³ A estrutura de abertura de arquivos e checagem de indices foiº±±
±±º          ³ desenvolvida conforme orientacao da tecnologia (devedo as    º±±
±±º          ³ particularidades da RDD CTREECDX).                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA710                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XA710OpenFMRP(lVisualiza,aStruSH5,aStruSHA,lInJob)
Local lRet 		:= .T.
Local cDrive 	:= "CTREECDX"
Local cExt		:= ".cdx"
Local cPath		:= ""
Local cArqSH5	:= ""
Local cArqSHA	:= ""
Local cNameIdx	:= ""
Local aTam		:= {}
LOCAL aTamQuant	:= TamSX3("B2_QFIM")
LOCAL aArea     := GetArea()
Local nI
Local nTamItem	:= 0,aCamposIt:={"C1_ITEM","C2_ITEM","C3_ITEM","C6_ITEM","C7_ITEM"}
Local aCpsUsu 	:= {}
Local cFil		:= ""
Local aFil		:= {}

DEFAULT lInJob   	:= .F.
DEFAULT lVisualiza	:= .F.
DEFAULT aStruSH5	:= {}
DEFAULT aStruSHA	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Na chamada em job nao cria novamente arquivo, simula visualizacao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lInJob
	lVisualiza:=.T.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria semaforo para controle de exclusividade da operacao     ³
//³ Somente na chamada em job nao testa essa exclusividade       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lInJob .Or. (!lInJob .And. LockByName("SH5USO"+cEmpAnt+cFilAnt,.T.,.T.,.T.))

    //-- Para manter legado o path dos arquivos SH5 e SHA sempre sera o mesmo do definido
    //-- na primeira ocorrencia da familia SH. E podera retornar vazio em ambientes Top,
    //-- por este nao preencher o X2_PATH.
	dbSelectArea("SX2")
	dbSeek("SH")

	cPath:=AllTrim(X2_PATH)+ AllTrim(cFilAnt)+'\'
	
	If EXISTDIR(cPath)
		//-- Define o nome do arquivo SH5
		cArqSH5 := REtArq(cDrive,cPath+"SH5"+Substr(cNumEmp,1,2)+"0",.t.)
	
		//-- Define o nome do arquivo SHA
		cArqSHA := REtArq(cDrive,cPath+"SHA"+Substr(cNumEmp,1,2)+"0",.t.)	
	Else
		MakeDir(cPath)
		If EXISTDIR(cPath)
			//-- Define o nome do arquivo SH5
			cArqSH5 := REtArq(cDrive,cPath+"SH5"+Substr(cNumEmp,1,2)+"0",.t.)
		
			//-- Define o nome do arquivo SHA
			cArqSHA := REtArq(cDrive,cPath+"SHA"+Substr(cNumEmp,1,2)+"0",.t.)	
		EndIf
	EndIf	
	
    If lRet
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta arquivos do MRP                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !lVisualiza

			//-- Verifica se o SH5 esta aberto
			If Select("SH5") > 0
				SH5->( DbCloseArea() )
			EndIf

			//-- Apago o SH5 (Tabela e Indice) para que seja criada nova estrutura
			FErase(cArqSH5)
			FErase(FileNoExt(cArqSH5)+cExt)

			//-- Verifica se o SHA esta aberto
			If Select("SHA") > 0
				SH5->( DbCloseArea() )
			EndIf

			//-- Apago o SHA (Tabela e Indice) para que seja criada nova estrutura
			FErase(cArqSHA)
			FErase(FileNoExt(cArqSHA)+cExt)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ NUMERO DO MRP                                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			c711NumMRP:=GetMV("MV_NEXTMRP")
			PutMV("MV_NEXTMRP",Soma1(Substr(c711NumMRP,1,Len(SC2->C2_SEQMRP))))
			// Arquivo de trabalho do MRP
			               
			//H5_FILIAL - FILIAL
			AADD(aStruSH5 ,{"H5_FILIAL"  ,"C",FWSizeFilial(),0})
			AADD(aStruSHA ,{"HA_FILIAL"  ,"C",FWSizeFilial(),0})			
			//H5_DATAORI - DATA ORIGINAL
			AADD(aStruSH5 ,{"H5_DATAORI","D",08,0})
			//H5_PER - PERIODO
			AADD(aStruSH5 ,{"H5_PER","C",03,0})
			//H5_NUMMRP - NUMERO DA PROGRAMACAO
			AADD(aStruSH5 ,{"H5_NUMMRP"  ,"C",Len(SC2->C2_SEQMRP),0})
			AADD(aStruSHA,{"HA_NUMMRP"  ,"C",Len(SC2->C2_SEQMRP),0})
			//H5_NIVEL   - NIVEL
			AADD(aStruSH5 ,{"H5_NIVEL"  ,"C",02,0})
			AADD(aStruSHA,{"HA_NIVEL"  ,"C",02,0})
			//H5_PRODUTO - PRODUTO
			AADD(aStruSH5 ,{"H5_PRODUTO","C",TamSX3("B1_COD")[1],0})
			AADD(aStruSHA,{"HA_PRODUTO","C",TamSX3("B1_COD")[1],0})
			AADD(aStruSHA,{"HA_PRODSHW","C",TamSX3("B1_COD")[1],0})
			//H5_OPC     - OPCIONAL
			If !lUsaMOpc
				aTam:=TAMSX3("C2_OPC")
				AADD(aStruSH5 ,{"H5_OPC"   ,"C",aTam[1],0})
				AADD(aStruSH5 ,{"H5_OPCORI","C",aTam[1],0})
				AADD(aStruSHA,{"HA_OPC"    ,"C",aTam[1],0})
				AADD(aStruSHA,{"HA_OPCSHW" ,"C",aTam[1],0})
			Else 
				aTam:= TamSx3("C2_MOPC")
				AADD(aStruSH5,{"H5_OPC"     ,"M",aTam[1],0})
				AADD(aStruSH5,{"H5_OPCORI"	,"M",aTam[1],0})
				//AADD(aStruSH5 ,{"H5_MOPC"	,"M",aTam[1],0})
				AADD(aStruSHA,{"HA_OPC"    	,"M",aTam[1],0})
				AADD(aStruSHA,{"HA_OPCSHW" 	,"C",200,0})
				AADD(aStruSHA,{"HA_MOPC"    ,"M",aTam[1],0})
				AADD(aStruSHA,{"HA_OPCORD" 	,"C",200,0})
			EndIf
			//H5_ALIAS   - ALIAS DO MOVIMENTO
			//           SC1
			//           SC7
			//           SC2
			//           SHC
			//           SD4
			//           SC6
			//           SC4
			//           AFJ
			aTam:=TamSX3("B1_REVATU")
			AADD(aStruSH5 ,{"H5_REVISAO","C",aTam[1],0})
			AADD(aStruSHA,{"HA_REVISAO","C",aTam[1],0})
			AADD(aStruSHA,{"HA_REVSHW" ,"C",aTam[1],0})
			AADD(aStruSH5 ,{"H5_ALIAS"   ,"C",03,0})
			//H5_RECNO   - REGISTRO
			AADD(aStruSH5 ,{"H5_RECNO"   ,"N",14,0})
			// H5_TIPO - TIPO DO DOCUMENTO
			// 2 - ENTRADA
			// 3 - SAIDA
			// 4 - SAIDA RELACIONADA A ESTRUTURA
			AADD(aStruSH5,{"H5_TIPO"    ,"C",01,0})
			AADD(aStruSHA,{"HA_TIPO"    ,"C",01,0})
			AADD(aStruSHA,{"HA_TEXTO"   ,"C",16,0})
			//H5_DOC     - DOCUMENTO
			AADD(aStruSH5,{"H5_DOC"     ,"C",TamSX3("B1_COD")[1],0})
			//H5_DOCKEY  - DOCUMENTO DE LIGACAO
			AADD(aStruSH5,{"H5_DOCKEY"  ,"C",13,0})
			AADD(aStruSH5,{"H5_DOCREV"  ,"C",Len(SC2->C2_REVISAO),0})
			//H5_ITEM    - ITEM
			// Pesquisa o tamanho dos campos de item
			For nI:=1 to Len(aCamposIt)
				nTamItem:=Max(nTamItem,TamSX3(aCamposIt[nI])[1])
			Next nI
			AADD(aStruSH5 ,{"H5_ITEM"    ,"C",nTamItem,0})
			//H5_QUANT   - QUANTIDADE
			AADD(aStruSH5,{"H5_QUANT","N",aTamQuant[1]+2,aTamQuant[2]})
			// Produto Original (Quando utilizado produto alternativo - SGI)
			AADD(aStruSH5 ,{"H5_PRODORI","C",TamSX3("B1_COD")[1],0})

			If ExistBlock("MA710SH5")
				aCpsUsu := ExecBlock("MA710SH5",.F.,.F.)
				If ValType(aCpsUsu) == "A"
					For nI := 1 to Len(aCpsUsu)
						aAdd(aStruSH5,aCpsUsu[nI])
					Next nI
				EndIf
			EndIf

			//-- Cria Tabela SH5 -----------------------------------------------------------
			DbCreate(cArqSH5,aStruSH5,cDrive)
			dbUseArea( .T.,cDrive, cArqSH5, "SH5", .T., .F. )

	        cNameIdx := FileNoExt(cArqSH5)
	        
	        If !lUsaMOpc
				INDEX ON H5_FILIAL+H5_PRODUTO+H5_OPC+H5_REVISAO+H5_PER 		  		TAG &(cNameIdx+"1") TO &(cNameIdx)
				INDEX ON H5_FILIAL+H5_ALIAS+H5_NIVEL+H5_PRODUTO+H5_OPC+H5_REVISAO	TAG &(cNameIdx+"2") TO &(cNameIdx)
				INDEX ON H5_FILIAL+H5_PRODUTO+H5_ALIAS+DTOS(H5_DATAORI) 			TAG &(cNameIdx+"3") TO &(cNameIdx)
	       		INDEX ON H5_FILIAL+H5_ALIAS+H5_DOC+DTOS(H5_DATAORI) 				TAG &(cNameIdx+"4") TO &(cNameIdx)
				INDEX ON H5_FILIAL+H5_PRODUTO+H5_OPC+H5_REVISAO+H5_PER+H5_TIPO		TAG &(cNameIdx+"5") TO &(cNameIdx)
	   		Else 
	   			INDEX ON H5_FILIAL+H5_PRODUTO+H5_REVISAO+H5_PER 					TAG &(cNameIdx+"1") TO &(cNameIdx)
				INDEX ON H5_FILIAL+H5_ALIAS+H5_NIVEL+H5_PRODUTO+H5_REVISAO			TAG &(cNameIdx+"2") TO &(cNameIdx)
				INDEX ON H5_FILIAL+H5_PRODUTO+H5_ALIAS+DTOS(H5_DATAORI) 			TAG &(cNameIdx+"3") TO &(cNameIdx)
	       		INDEX ON H5_FILIAL+H5_ALIAS+H5_DOC+DTOS(H5_DATAORI) 				TAG &(cNameIdx+"4") TO &(cNameIdx)
			EndIf
			
			dbClearIndex()
			dbSetIndex( cNameIdx+cExt )

	        //-- Cria Tabela SHA ------------------------------------------------------------
			DbCreate(cArqSHA,aStruSHA,cDrive)
			dbUseArea( .T.,cDrive, cArqSHA, "SHA", .T. , .F. )

	        cNameIdx := FileNoExt(cArqSHA)
	        
	        If !lUsaMOpc
				INDEX ON HA_FILIAL+HA_PRODUTO+HA_OPC+HA_REVISAO+HA_TIPO 			TAG &(cNameIdx+"1") TO &(cNameIdx)
				INDEX ON HA_FILIAL+HA_NIVEL+HA_PRODUTO+HA_OPC+HA_REVISAO+HA_TIPO	TAG &(cNameIdx+"2") TO &(cNameIdx)
			Else
				INDEX ON HA_FILIAL+HA_PRODUTO+HA_REVISAO+HA_TIPO 			TAG &(cNameIdx+"1") TO &(cNameIdx)
				INDEX ON HA_FILIAL+HA_NIVEL+HA_PRODUTO+HA_REVISAO+HA_TIPO	TAG &(cNameIdx+"2") TO &(cNameIdx)
				INDEX ON HA_FILIAL+HA_PRODUTO+HA_OPCORD+HA_REVISAO+HA_TIPO 	TAG &(cNameIdx+"3") TO &(cNameIdx)
			EndIf
			dbClearIndex()
			dbSetIndex( cNameIdx+cExt )

		Else

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Na rotina de abertura, se alguem apagou o indice do disco,       ³
			//³qdo abrimos  a tabela, o ctree vai fazer rebuild destes indices, ³
			//³porem se a tabela foi renomeada, ou criada em um diretorio e     ³
			//³copiada para outro, ele nao faz o rebuild.                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			//-- Abre o arquivo SH5
			If MSFile(cArqSH5,,cDrive)
				dbUseArea( .T. ,cDrive,cArqSH5, "SH5", .T. , .F. )

			    cNameIdx := FileNoExt(cArqSH5)

			    //-- Checa a existencia do indice permanente para tabela SH5, e cria se nao existir
				If !File(cNameIdx+cExt)
					If !lUsaMOpc
						INDEX ON H5_FILIAL+H5_PRODUTO+H5_OPC+H5_REVISAO+H5_PER 		 		TAG &(cNameIdx+"1") TO &(cNameIdx)
						INDEX ON H5_FILIAL+H5_ALIAS+H5_NIVEL+H5_PRODUTO+H5_OPC+H5_REVISAO	TAG &(cNameIdx+"2") TO &(cNameIdx)
						INDEX ON H5_FILIAL+H5_PRODUTO+H5_ALIAS+DTOS(H5_DATAORI) 			TAG &(cNameIdx+"3") TO &(cNameIdx)
						INDEX ON H5_FILIAL+H5_ALIAS+H5_DOC+DTOS(H5_DATAORI) 				TAG &(cNameIdx+"4") TO &(cNameIdx) 
						INDEX ON H5_FILIAL+H5_PRODUTO+H5_OPC+H5_REVISAO+H5_PER+H5_TIPO		TAG &(cNameIdx+"5") TO &(cNameIdx)
					Else
						INDEX ON H5_FILIAL+H5_PRODUTO+H5_REVISAO+H5_PER 					TAG &(cNameIdx+"1") TO &(cNameIdx)
						INDEX ON H5_FILIAL+H5_ALIAS+H5_NIVEL+H5_PRODUTO+H5_REVISAO	 		TAG &(cNameIdx+"2") TO &(cNameIdx)
						INDEX ON H5_FILIAL+H5_PRODUTO+H5_ALIAS+DTOS(H5_DATAORI)  			TAG &(cNameIdx+"3") TO &(cNameIdx)
						INDEX ON H5_FILIAL+H5_ALIAS+H5_DOC+DTOS(H5_DATAORI) 	   			TAG &(cNameIdx+"4") TO &(cNameIdx)
					EndIf
				EndIf

				dbClearIndex()
				dbSetIndex( cNameIdx+cExt )


		        //-- Abre tabelas em modo compartilhado
		        If MSFile(cArqSHA,,cDrive)
			        dbUseArea( .T.,cDrive, cArqSHA, "SHA", .T., .F. )

					cNameIdx := FileNoExt(cArqSHA)

				    //-- Checa a existencia do indice permanente para tabela SHA, e cria se nao existir
					If !File(cNameIdx+cExt)
						If !lUsaMOpc
							INDEX ON HA_FILIAL+HA_PRODUTO+HA_OPC+HA_REVISAO+HA_TIPO 			TAG &(cNameIdx+"1") TO &(cNameIdx)
							INDEX ON HA_FILIAL+HA_NIVEL+HA_PRODUTO+HA_OPC+HA_REVISAO+HA_TIPO	TAG &(cNameIdx+"2") TO &(cNameIdx)
						Else
							INDEX ON HA_FILIAL+HA_PRODUTO+HA_OPC+HA_REVISAO+HA_TIPO 			TAG &(cNameIdx+"1") TO &(cNameIdx)
							INDEX ON HA_FILIAL+HA_NIVEL+HA_PRODUTO+HA_OPC+HA_REVISAO+HA_TIPO 	TAG &(cNameIdx+"2") TO &(cNameIdx)
						EndIf
					EndIf

					dbClearIndex()
					dbSetIndex( cNameIdx+cExt )
				Else
					Help(" ",1,"A710SHA")
					lRet := .F.
				Endif
            Else
	            Help(" ",1,"A710SH5")
	            lRet := .F.
            Endif
		EndIf
	EndIf

	If lInJob
		RestArea(aArea)
	EndIf

Else
	Help(" ",1,"SH5EmUso")
	lRet := .F.
EndIf

Return ( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A710AtuPerioºAutor  ³Erike Yuri da Silva º Data ³  03/14/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao responsavel pela atualizacao de periodos, lembrando queº±±
±±º          ³o retorno deve ser por referencia.                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ ExpL1 : Indica se o MRP sera executado em modo visualizacao  º±±
±±º          ³ ExpN1 : Indica o tipo de periodo escolhido pelo operador     º±±
±±º          ³ ExpD1 : Data de inicio dos periodos                          º±±
±±º          ³ ExpA1 : Array com os periodos que serao retornados por refer.º±±
±±º          ³ ExpA2 : Array com parametros (opcoes)                        º±±
±±º          ³ ExpA3 : Array com a estrutura dos periodos para tabela SHA   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA710                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A710AtuPeriodo(lVisualiza,nTipo,dInicio,aPeriodos,aOpcoes,aStruSHA)
Local cForAno
Local nPosAno, nTamAno, i
Local nY2T			:= If(__SetCentury(),2,0)
Local aTamQuant  	:= TamSX3("B2_QFIM")

DEFAULT lVisualiza	:= .F.


If __SetCentury()
	nPosAno := 1
	nTamAno := 4
	cForAno := "ddmmyyyy"
Else
	nPosAno := 3
	nTamAno := 2
	cForAno := "ddmmyy"
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta as datas de acordo com os parametros                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (nTipo == 2)                         // Semanal
	While Dow(dInicio)!=2
		dInicio--
	end
ElseIf (nTipo == 3) .or. (nTipo=4)      // Quinzenal ou Mensal
	dInicio:= CtoD("01/"+Substr(DtoS(dInicio),5,2)+Substr(DtoC(dInicio),6,3+nY2T),cForAno)
ElseIf (nTipo == 5)                     // Trimestral
	If Month(dInicio) < 4
		dInicio := CtoD("01/01/"+Substr(DtoC(dInicio),7+nY2T,2),cForAno)
	ElseIf (Month(dInicio) >= 4) .and. (Month(dInicio) < 7)
		dInicio := CtoD("01/04/"+Substr(DtoC(dInicio),7+nY2T,2),cForAno)
	ElseIf (Month(dInicio) >= 7) .and. (Month(dInicio) < 10)
		dInicio := CtoD("01/07/"+Substr(DtoC(dInicio),7+nY2T,2),cForAno)
	ElseIf (Month(dInicio) >=10)
		dInicio := CtoD("01/10/"+Substr(DtoC(dInicio),7+nY2T,2),cForAno)
	EndIf
ElseIf (nTipo == 6)                     // Semestral
	If Month(dInicio) <= 6
		dInicio := CtoD("01/01/"+Substr(DtoC(dInicio),7+nY2T,2),cForAno)
	Else
		dInicio := CtoD("01/07/"+Substr(DtoC(dInicio),7+nY2T,2),cForAno)
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta as datas de acordo com os parametros                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If nTipo != 7
	For i := 1 to aOpcoes[2][1]
		If !lVisualiza
			AADD(aStruSHA,{"HA_PER"+StrZero(i,3),"N",aTamQuant[1]+2,aTamQuant[2]})
		EndIf
		dInicio := A710NextUtil(dInicio,aPergs711,.T.)
		AADD(aPeriodos,dInicio)
		If nTipo == 1
			dInicio ++
		ElseIf nTipo == 2
			dInicio+=7
		ElseIf nTipo == 3
			dInicio := StoD(If(Substr(DtoS(dInicio),7,2)<"15",Substr(DtoS(dInicio),1,6)+"15",;
				If(Month(dInicio)+1<=12,Str(Year(dInicio),4)+StrZero(Month(dInicio)+1,2)+"01",;
				Str(Year(dInicio)+1,4)+"0101")),cForAno)
		ElseIf nTipo == 4
			dInicio := CtoD("01/"+If(Month(dInicio)+1<=12,StrZero(Month(dInicio)+1,2)+;
				"/"+Substr(Str(Year(dInicio),4),nPosAno,nTamAno),"01/"+Substr(Str(Year(dInicio)+1,4),nPosAno,nTamAno)),cForAno)
		ElseIf nTipo == 5
			dInicio := CtoD("01/"+If(Month(dInicio)+3<=12,StrZero(Month(dInicio)+3,2)+;
				"/"+Substr(Str(Year(dInicio),4),nPosAno,nTamAno),"01/"+Substr(Str(Year(dInicio)+1,4),nPosAno,nTamAno)),cForAno)
		ElseIf nTipo == 6
			dInicio := CtoD("01/"+If(Month(dInicio)+6<=12,StrZero(Month(dInicio)+6,2)+;
				"/"+Substr(Str(Year(dInicio),4),nPosAno,nTamAno),"01/"+Substr(Str(Year(dInicio)+1,4),nPosAno,nTamAno)),cForAno)
		EndIf
	Next i
ElseIf nTipo == 7
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seleciona periodos variaveis se nao for visualizacao         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lVisualiza
		A711Diver()
	EndIf
	For i:=1 to Len(aDiversos)
		AADD(aPeriodos, StoD(DtoS(CtoD(aDiversos[i])),cForAno) )
		If !lVisualiza
			AADD(aStruSHA,{"HA_PER"+StrZero(i,3),"N",aTamQuant[1]+2,aTamQuant[2]})
		EndIf
	Next
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ponto de entrada customizacoes na atualizacoes de periodos    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("A710PERI")
	aPeriodos := ExecBlock("A710PERI", .F., .F., aPeriodos )
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MA711ClNes³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 17/04/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina para recalcular necessidades produto a produto      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XMA711ClNes(oCenterPanel)
Local aArea    	:= GetArea()
Local aAreaSHA 	:= SHA->(GetArea())
Local aAreaSH5 	:= SH5->(GetArea())
Local cJobFile 	:= ""
Local cJobAux  	:= ""
Local cPath    	:= ""
Local aThreads 	:= {}
Local aJobAux  	:= {}
Local nRetry_0 	:= 0
Local nRetry_1 	:= 0
Local nX       	:= 0
Local nPos     	:= 0
Local cStartPath:= ""
Local lThrSeq   := .F.
Local cProduto 	:= Space(Len(SHA->HA_PRODUTO))
Local cOpc     	:= Space(Len(SHA->HA_OPC))
Local cRevisao 	:= Space(Len(SHA->HA_REVISAO))
Local lThreads 	:= .F.

If SuperGetMv('MV_A710THR',.F.,1) > 1
	lThreads := .T.
Endif

If lThreads
	cJobFile := ""
	cJobAux  := ""
	cPath    := ""
	aThreads := {}
	aJobAux  := {}
	nRetry_0 := 0
	nRetry_1 := 0
	nX       := 0
	nPos     := 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Diretorio do servidor protheus                         |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cStartPath := GetSrvProfString("Startpath","")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Habilita processamento de thread em sequencia          |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lThrSeq    := SuperGetMV("MV_THRSEQ",.F.,.F.)
Else
	cProduto := Space(Len(SHA->HA_PRODUTO))
	cOpc     := Space(Len(SHA->HA_OPC))
	cRevisao := Space(Len(SHA->HA_REVISAO))
Endif

If lThreads
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o log de processamento			    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcLogAtu("MENSAGEM","Iniciando Recalculo das Necessidades","Iniciando Recalculo das Necessidades")

	//-- Para manter legado o path dos arquivos SH5 e SHA sempre sera o mesmo do definido
	//-- na primeira ocorrencia da familia SH. E podera retornar vazio em ambientes Top,
	//-- por este nao preencher o X2_PATH.
	dbSelectArea("SX2")
	dbSeek("SH")
	cPath:=AllTrim(X2_PATH)+ AllTrim(cFilAnt)+'\'

	//-- Calcula Quebra por Threads
	aThreads := A710QtdThread()
	ProcRegua(Len(aThreads))

	For nX:=1 to Len(aThreads)
		// Informacoes do semaforo
		cJobFile:= cStartPath + CriaTrab(Nil,.F.)+".job"

		// Adiciona o nome do arquivo de Job no array aJobAux
		aAdd(aJobAux,{StrZero(nX,2),cJobFile})

		// Inicializa variavel global de controle de thread
		cJobAux:="c710P"+cEmpAnt+cFilAnt+StrZero(nX,2)
		PutGlbValue(cJobAux,"0")
		GlbUnLock()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o log de processamento			    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ProcLogAtu("MENSAGEM","Iniciando de Recalculo das Necessidades - Thread:" + StrZero(nX,2),"Iniciando de Recalculo das Necessidades - Thread:" + StrZero(nX,2))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Dispara thread para Stored Procedure        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		StartJob("U_XA710JOBNes",GetEnvServer(),lThrSeq,cEmpAnt,cFilAnt,aThreads[nX,1],cJobFile,StrZero(nX,2),cPath,aPeriodos,aPergs711,,cMT710B2,aFilAlmox,aAlmoxNNR)
	Next nX

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Controle de Seguranca para MULTI-THREAD                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX:=1 to Len(aThreads)

		nPos := ASCAN(aJobAux,{|x| x[1] == StrZero(nX,2)})

		// Informacoes do semaforo
		cJobFile:= aJobAux[nPos,2]

		// Inicializa variavel global de controle de thread
		cJobAux:="c710P"+cEmpAnt+cFilAnt+StrZero(nX,2)

		While .T.
			Do Case
				// TRATAMENTO PARA ERRO DE SUBIDA DE THREAD
				Case GetGlbValue(cJobAux) == '0'
					If nRetry_0 > 50
//						Conout(Replicate("-",65))				  												 	//"-----------------------------------------------------"
//						Conout("MATA710: "+ "Não foi possivel realizar a subida da thread" + " " + StrZero(nX,2) )	//"MATA710: Não foi possivel realizar a subida da thread"
  //						Conout(Replicate("-",65))  																	//"-----------------------------------------------------"
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Atualiza o log de processamento			    ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						ProcLogAtu("MENSAGEM","Não foi possivel realizar a subida da thread","Não foi possivel realizar a subida da thread")	//"Não foi possivel realizar a subida da thread"
						Final("Não foi possivel realizar a subida da thread") 						  											//"Não foi possivel realizar a subida da thread"
					Else
						nRetry_0 ++
					EndIf
				// TRATAMENTO PARA ERRO DE CONEXAO
				Case GetGlbValue(cJobAux) == '1'
					If FCreate(cJobFile) # -1
						If nRetry_1 > 5
//							Conout(Replicate("-",65)) 						//"------------------------------------------------"
  //							Conout("MATA710: Erro de conexao na thread") 	//"MATA710: Erro de conexao na thread"
	 //						Conout("Thread numero : " + StrZero(nX,2) )		//"Thread numero : "
		//					Conout("Numero de tentativas excedidas")		//"Numero de tentativas excedidas"
		  //					Conout(Replicate("-",65))  						//"------------------------------------------------"
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Atualiza o log de processamento			    ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							ProcLogAtu("MENSAGEM","MATA710: Erro de conexao na thread de procedures","MATA710: Erro de conexao na thread")	//"MATA710: Erro de conexao na thread"
							Final("MATA710: Erro de conexao na thread")										   								//"MATA710: Erro de conexao na thread"
						Else
			    			// Inicializa variavel global de controle de Job
							PutGlbValue(cJobAux, "0" )
							GlbUnLock()
							// Reiniciar thread
//							Conout(Replicate("-",65))				 				//"------------------------------------------------"
  //							Conout("MATA710: Erro de conexao na thread") 			//"MATA710: Erro de conexao na thread"
	 //						Conout("Tentativa numero: "		+StrZero(nRetry_1,2))	//"Tentativa numero: "
		//					Conout("Reiniciando a thread : "+StrZero(nX,2))			//"Reiniciando a thread : "
		  //					Conout(Replicate("-",65))                 				//"------------------------------------------------"
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Atualiza o log de processamento			    ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							ProcLogAtu("MENSAGEM","Reiniciando a thread : "+StrZero(nX,2),"Reiniciando a thread : "+StrZero(nX,2))	//"Reiniciando a thread : "
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Dispara thread para Stored Procedure        ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							StartJob("U_XA710JOBNes",GetEnvServer(),lThrSeq,cEmpAnt,cFilAnt,aThreads[nX,1],cJobFile,StrZero(nX,2),cPath,aPeriodos,aPergs711,,cMT710B2,aFilAlmox,aAlmoxNNR)
						EndIf
						nRetry_1 ++
					EndIf
				// TRATAMENTO PARA ERRO DE APLICACAO
				Case GetGlbValue(cJobAux) == '2'
					If FCreate(cJobFile) # -1
//						Conout(Replicate("-",65))										//"-------------------------------------------------"
  //						Conout("MATA710: Erro de aplicacao na thread ")					//"MATA710: Erro de aplicacao na thread"
	 //					Conout("Thread numero : "+StrZero(nX,2))						//"Thread numero : "
		//				Conout(Replicate("-",65))  										//"--------------------------------------------------"
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Atualiza o log de processamento			    ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						ProcLogAtu("MENSAGEM","MATA710: Erro de aplicacao na thread","MATA710: Erro de aplicacao na thread")	//"MATA710: Erro de aplicacao na thread"
						Final("MATA710: Erro de aplicacao na thread") 						   									//"MATA710: Erro de aplicacao na thread"
					EndIf
				// THREAD PROCESSADA CORRETAMENTE
				Case GetGlbValue(cJobAux) == '3'
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza o log de processamento			    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					ProcLogAtu("MENSAGEM","Termino do Recalculo das Necessidades - Thread:" + StrZero(nX,2),"Termino do Recalculo das Necessidades - Thread:" + StrZero(nX,2))
					IncProc()
					Exit
			EndCase
			Sleep(2500)
		End
	Next nX

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o log de processamento			    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcLogAtu("MENSAGEM","Termino do Recalculo das Necessidades","Termino do Recalculo das Necessidades")

Else

	// Verifica todos produtos utilizados
	dbSelectArea("SHA")
	If (oCenterPanel==Nil)
		ProcRegua(LastRec())
	Else
		oCenterPanel:SetRegua1(SHA->(LastRec()))
	EndIf
	dbSetOrder(1)
	dbGotop()
	While !Eof()
		If (oCenterPanel==Nil)
			IncProc()
		Else
			oCenterPanel:IncRegua1(OemToAnsi(STR0130))
		EndIf
		If xFilial("SHA") == SHA->HA_FILIAL
			If xFilial("SHA")+cProduto+cOpc+cRevisao <> SHA->HA_FILIAL+SHA->HA_PRODUTO+SHA->HA_OPC+SHA->HA_REVISAO
				cProduto:=SHA->HA_PRODUTO
				cOpc:=SHA->HA_OPC
				cRevisao:=SHA->HA_REVISAO
				u_XMA711Recalc(cProduto,cOpc,cRevisao,NIL,NIL,NIL)
			EndIf
		EndIf
		dbSkip()
	Enddo

Endif

If (oCenterPanel<>Nil)
	oCenterPanel:IncRegua2()
EndIf

RestArea(aAreaSH5)
RestArea(aAreaSHA)
RestArea(aArea)

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A711ExpTre³ Autor ³Erike Yuri da Silva    ³ Data ³ 24/04/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina que expande o no  do produto corrente no tree       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A711ExpTree()
Local cOldCargo	:=oTreeM711:GetCargo()
Local nRecno    :=Val(SubStr(cOldCargo,3,12))
Local cProdExpl	:=""
Local cOpcExpl	:=""
Local cRevisao	:=""
Local i         := 0
Local aDadosEnvio:={}

//Possiciona array do tree
If nRecno > 0
	//-- Posiciona no registro correto
	DbSelectArea("SH5")
	DbSetOrder(1)
	DbGoto(nRecno)

	cProdExpl	:= H5_PRODUTO
	cOpcExpl	:= H5_OPC
	cRevisao	:= H5_REVISAO

	//-- Zera os valores para recalculo do produto posicionado
	While SH5->( !Eof() .And. H5_PRODUTO+H5_OPC+H5_REVISAO == cProdExpl+cOpcExpl+cRevisao )
		For i:=1 to Len(aTotais)
			nAchouTot := ASCAN(aTotais[i],{ |x| x[1] == H5_PRODUTO+H5_OPC+H5_REVISAO .And. x[2] == H5_PER .And. x[3] == H5_ALIAS})
			If nAchouTot != 0
				aTotais[i,nAchouTot,4] := 0
				Exit
			EndIf
		Next i
		SH5->( DbSkip() )
	Enddo

	DbGoto(nRecno)

	//-- Alimenta Tree somente para o produto posicionado
	While SH5->( !Eof() .And. H5_PRODUTO+H5_OPC+H5_REVISAO == cProdExpl+cOpcExpl+cRevisao )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Adiciona registro em array totalizador utilizado no TREE  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Len(aTotais[Len(aTotais)]) > 4095
			AADD(aTotais,{})
		EndIf
		For i:=1 to Len(aTotais)
			nAchouTot:=ASCAN(aTotais[i],{ |x| x[1] == H5_PRODUTO+H5_OPC+H5_REVISAO .And. x[2] == H5_PER .And. x[3] == H5_ALIAS})
			If nAchouTot != 0
				aTotais[i,nAchouTot,4] += H5_QUANT
				Exit
			EndIf
		Next i
		If nAchouTot ==0
			AADD(aTotais[Len(aTotais)],{H5_PRODUTO+H5_OPC+H5_REVISAO,H5_PER,H5_ALIAS,H5_QUANT})
		EndIf
		// Estrutura do array
		// Produto
		// Opcional
		// Revisao
		// Alias
		// Tipo
		// Documento
		// Recno
		// DocRev
		//                  01              02          03               04             05         06           07                         08
		AADD(aDadosEnvio,{SH5->H5_PRODUTO,SH5->H5_OPC,SH5->H5_REVISAO,SH5->H5_ALIAS,SH5->H5_TIPO,SH5->H5_DOC,StrZero(SH5->(Recno()),12),SH5->H5_DOCREV})
		SH5->( DbSkip() )
	End
EndIf
A711AdTree(.F.,aDadosEnvio,.F.)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³xa710MCond ³ Autor ³Andre Anjos		    ³ Data ³ 14/12/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina que monta condicao default da projecao, strings de  ³±±
±±³			 ³ filtro para tipos e grupos e array aPergs711				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER  Function Xa710MCond(cStrTipo,cStrGrupo)
Local nZ := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta condicao default da projecao                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nz:=1 to 7
	If nUsado = nz
		aOpcoes[1][nz] := "x"
	Else
		aOpcoes[1][nz] := " "
	EndIf
Next nz
aOpcoes[2][1] := nQuantPer  // Numero de Periodos
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Move A711Tipo para aStrTipo                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cStrTipo := Criavar("B1_TIPO",.f.)+"|"
FOR nZ:=1 TO LEN(A711Tipo)
	If A711Tipo[nZ,1]
		cStrTipo += SubStr(A711Tipo[nZ,2],1,nTamTipo711)+"|"
	EndIf
Next nZ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Move A711Grupo para aStrGrupo                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FOR nZ:=1 TO LEN(A711Grupo)
	If A711Grupo[nZ,1]
		cStrGrupo += SubStr(A711Grupo[nZ,2],1,nTamGr711)+"|"
	EndIf
Next nZ

//Alimenta array aPergs711 com os dados do SX1
Pergunte("MTA712",.F.)
aPergs711 := {}
SX1->(dbSeek("MTA712"))
While !SX1->(EOF()) .And. AllTrim(SX1->X1_GRUPO) == "MTA712"
	aAdd(aPergs711,&(AllTrim(SX1->X1_VAR01)))
	SX1->(dbSkip())
End

//-- Filtra armazens conforme MV_MRPFILA e NNR_MRP
If aAlmoxNNR == NIL
	A710FilAlm(.F.)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A710MontPer³ Autor ³Andre Anjos		     ³ Data ³ 12/12/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta o painel para selecao da peridiocidade			       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A710MontPer(oCenterPanel)
Local oUsado,oChk,oChk2,oChkQual,oChkQual2,oQual,oQual2
Local lQual, lQual2

@ 10,10 TO 125,115 LABEL OemToAnsi(STR0002) OF oCenterPanel  PIXEL //"Periodicidade do MRP"
@ 25,20 RADIO oUsado VAR nUsado 3D SIZE 70,10 PROMPT  OemToAnsi(STR0003),;	//"Per¡odo Di rio"
OemToAnsi(STR0004),;	//"Per¡odo Semanal"
OemToAnsi(STR0005),;	//"Per¡odo Quinzenal"
OemToAnsi(STR0006),;	//"Per¡odo Mensal"
OemToAnsi(STR0007),;	//"Per¡odo Trimestral"
OemToAnsi(STR0008),;	//"Per¡odo Semestral"
OemToAnsi(STR0009) OF oCenterPanel PIXEL	//"Per¡odos Diversos"
@ 102,020 Say OemToAnsi(STR0010) SIZE 60,10 OF oCenterPanel PIXEL	//"Quantidade de Per¡odos:"
@ 100,085 MSGET nQuantPer Picture "999" SIZE 15,10 OF oCenterPanel PIXEL

@ 10,130 TO 125,400 LABEL OemToAnsi(STR0091) OF oCenterPanel PIXEL //"Filtro"
//Tipo
@ 25,150 CHECKBOX oChkQual VAR lQual  PROMPT OemToAnsi(STR0061) SIZE 50, 10 OF oCenterPanel PIXEL ON CLICK (AEval(a711Tipo , {|z| z[1] := If(z[1]==.T.,.F.,.T.)}), oQual:Refresh(.F.)) //"Inverter Selecao"
oQual := TCBrowse():New(35,150,100,81,,,,oCenterPanel,,,,,{||A711Tipo:=CA711Troca(oQual:nAt,A711Tipo),oQual:Refresh()},,,,,,,.T.,,.T.,,.F.,,)
oQual:SetArray(a711Tipo)

oQual:AddColumn(TCColumn():New("",{|| If(a711Tipo[oQual:nAt,1],oOk,oNo)},,,,"LEFT",,.T.,.F.,,,,.T.,))
oQual:AddColumn(TCColumn():New(OemToAnsi(STR0012),{|| a711Tipo[oQual:nAt,2]},,,,"LEFT",,.F.,.F.,,,,.F.,))
oQual:Refresh()

//Grupo
@ 25,280 CHECKBOX oChkQual2 VAR lQual2 PROMPT OemToAnsi(STR0061) SIZE 50, 10 OF oCenterPanel PIXEL ON CLICK (AEval(a711Grupo, {|z| z[1] := If(z[1]==.T.,.F.,.T.)}),oQual2:Refresh(.F.)) //"Inverter Selecao"
oQual2 := TCBrowse():New(35,280,100,81,,,,oCenterPanel,,,,,{||a711Grupo:=CA711Troca(oQual2:nAt,A711Grupo),oQual2:Refresh()},,,,,,,.T.,,.T.,,.F.,,)
oQual2:SetArray(a711Grupo)

oQual2:AddColumn(TCColumn():New("",{|| If(a711Grupo[oQual2:nAt,1],oOk,oNo)},,,,"LEFT",,.T.,.F.,,,,.T.,))
oQual2:AddColumn(TCColumn():New(OemToAnsi(STR0013),{|| a711Grupo[oQual2:nAt,2]},,,,"LEFT",,.F.,.F.,,,,.F.,))
oQual2:Refresh()

@ 135,10 TO 180,400 LABEL OemToAnsi(STR0058) OF oCenterPanel PIXEL //"Opcionais"
@ 150,20 CHECKBOX oChk  VAR lPedido PROMPT OemToAnsi(STR0011) SIZE 85, 10 OF oCenterPanel PIXEL ;oChk:oFont := oCenterPanel:oFont	//"Considera Pedidos em Carteira"
@ 160,20 CHECKBOX oChk2 VAR lLogMRP PROMPT OemToAnsi(STR0068) SIZE 85, 10 OF oCenterPanel PIXEL ;oChk2:oFont := oCenterPanel:oFont	//"Log de eventos do MRP"

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A710GrvTm ³ Autor ³Felipe Nunes de Toledo ³ Data ³ 27/12/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Grava um log com os principais processos do MRP             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 : Objeto tNewProcess                                 ³±±
±±³          ³ ExpC2 : Texto a ser gravado no log                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA710                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function xA710GrvTm(oMainPainel, cTexto)

If (oMainPainel <> Nil) .And. !Empty(cTexto)
	oMainPainel:SaveLog(ctexto)
EndIf

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A710MontVis³ Autor ³Andre Anjos		     ³ Data ³ 29/04/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta o painel para visualizacao da ultima exececucao do MRP³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A710MontVis(oCenterPanel,lVisualiza)
Local oSay1, oSay2, oSay3, oCheck
Local cArqSHA := ""
Local cDrive  := "CTREECDX"
Local cProgra := ""
Local aArea   := GetArea()
Local lHabil  := .T.
Local aSize   := MsAdvSize()
Local aInfo   := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
Local aPosObj := {}
Local aObjects := {}

AADD(aObjects,{450,20,.T.,.T.,.F.})
aPosObj:=MsObjSize(aInfo,aObjects)

oSay1:= tSay():New(10,10,{|| OemToAnsi(STR0154+" "+STR0155)},oCenterPanel,,,,,,.T.,,,aPosObj[1,4]-200,aPosObj[1,3])
oSay2:= tSay():New(45,10,{|| OemToAnsi(STR0156)},oCenterPanel,,,,,,.T.,,,aPosObj[1,4]-200,aPosObj[1,3])
oCheck := TCheckBox():New(60,10,OemToAnsi(STR0157),{|| lVisualiza},oCenterPanel,100,210,,;
			{|| lVisualiza:=!lVisualiza},,,,,,.T.,,,) //Ativar visualização

dbSelectArea("SX2")
dbSeek("SH")
cArqSHA := REtArq(cDrive,AllTrim(X2_PATH)+"SHA"+Substr(cNumEmp,1,2)+"0",.t.)
If MSFile(cArqSHA,,cDrive)
	dbUseArea(.T.,cDrive,cArqSHA,"SHA",.T.,.F.)
	dbSelectArea("SHA")
	cProgra := AllTrim(SHA->HA_NUMMRP)
	dbCloseArea()
	oSay2:= tSay():New(45,75,{|| cProgra},oCenterPanel,,,,,,.T.,,,aPosObj[1,4]-200,aPosObj[1,3])
	oCheck:Enable()
Else
	oSay2:= tSay():New(45,75,{|| OemToAnsi(STR0158)},oCenterPanel,,,,,,.T.,CLR_RED,,aPosObj[1,4]-200,aPosObj[1,3])
	oCheck:Disable()
EndIf

RestArea(aArea)

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A710TrataRev³ Autor ³Marcelo Iuspa        ³ Data ³ 22/06/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna se existe campos especificos para tratamento de    ³±±
±±³          ³ revisao na Previsao de Venda e Plano Mestre Producao       ³±±
±±³          ³ Campos: HC_REVISAO e C4_REVISAO                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ True se existem os campos HC_REVISAO e C4_REVISAO          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function A710TrataRev()
Static lTrataRev := Nil

If lTrataRev == Nil
	If lA710REV
		lTrataRev := ExecBlock("A710REV",.F.,.F.)
		If ValType(lTrataRev) # "L"
			lTrataRev := .F.
		EndIf
	Else
		lTrataRev := .F.
	EndIf
Endif

Return(lTrataRev)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³A710AbDev ³ Autor ³ Sergio S. Fuzinaka    ³ Data ³ 18.09.09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Retorna a Quantidade, subtraindo as quantidades das Notas   ³±±
±±³          ³Fiscais de Devolucao de Compras.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³MATA710                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A710AbDev(cFornece,cLoja,cDoc,cSerie)

Local aArea		:= GetArea()
Local nQtde		:= 0
Local nQtDev	:= 0
Local cAlias	:= GetNextAlias()
Local aAreaSD2	:= SD2->( GetArea() )

dbSelectArea("SD2")
dbSetOrder(1)

BeginSql Alias cAlias
	SELECT SUM (D2_QUANT) QTDEV
 	FROM %table:SD2% SD2
	WHERE D2_FILIAL = %xFilial:SD2% AND
		SD2.D2_TIPO = 'D' AND
		SD2.D2_CLIENTE = %Exp:cFornece% AND
		SD2.D2_LOJA = %Exp:cLoja% AND
		SD2.D2_NFORI = %Exp:cDoc% AND
		SD2.D2_SERIORI = %Exp:cSerie% AND
		SD2.%NotDel%
EndSql
nQtDev := (cAlias)->QTDEV

If  SD7->D7_QTDE >= nQtDev
	nQtde := ( SD7->D7_QTDE - nQtDev )
Else
	nQtde := SD7->D7_QTDE
Endif

dbCloseArea()

RestArea( aAreaSD2 )
RestArea( aArea )

Return( nQtde )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³A710QtdThread ³ Autor ³ Microsiga S/A      ³ Data ³29.07.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao utilizada para calcular a quantidade de threads a    ³±±
±±³          ³serem executadas em paralelo.                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³lProcesso = .T. - U_XA710JobNes                                ³±±
±±³          ³            .F. - U_XA710JobIni                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA710                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A710QtdThread(lProcesso,cQueryB1,cStrGrupo)
Local aAreaAnt    := GetArea()
Local aThreads    := {}
Local aItens      := {}
Local aProdutos   := {}
Local nX          := 0
Local nY          := 0
Local nInicio     := 0
Local nRegProc    := 0
Local nCountGrupo := 0
Local i           := 0
Local cProduto    := ""
Local cOpc        := ""
Local cRevisao    := ""
Local cAliasSB1   := ""
Local cQuery      := ""
Local cQueryX1    := ""
Local cA710Fil    := ""
Local lFirstGrupo := .T.
Local lA710SQL    := ExistBlock("A710SQL")
Local lAllGrp     := Ascan(A711Grupo,{|x| x[1] == .F.}) == 0
Local lMRPCINQ    := SuperGetMV("MV_MRPCINQ",.F.,.F.)
Local nThreads    := SuperGetMv('MV_A710THR',.F.,1)
Local cDadosProd  := Alltrim(SuperGetMV("MV_ARQPROD",.F.,"SB1"))

Default lProcesso := .T.

If nThreads <= 0
	nThreads := 1
EndIf

If lProcesso

	//-- Carrega Array aProdutos
	dbSelectArea("SHA")
	If !lUsaMOpc
		dbSetOrder(1)
	Else
		dbSetOrder(3)
	Endif
	dbGotop()
	
	Do While !Eof()
		If cProduto+cOpc+cRevisao <> SHA->HA_PRODUTO+SHA->HA_OPC+SHA->HA_REVISAO
			cProduto := SHA->HA_PRODUTO
			cOpc	  := SHA->HA_OPC
			cRevisao := SHA->HA_REVISAO
			aItens   := {}
			aAdd(aItens,{cProduto,cOpc,cRevisao})
			aAdd(aProdutos,aItens)
		EndIf
		dbSkip()
	EndDo
	
	//-- Verifica Limite Maximo de 30 Threads
	If nThreads > 30
		nThreads := 30
	EndIf

	//-- Analisa a quantidade de Threads X nRegistros
	If Len(aProdutos) == 0
		aThreads := {}
	ElseIf Len(aProdutos) < nThreads
		aThreads := ARRAY(1)			// Processa somente em uma thread
	Else
		aThreads := ARRAY(nThreads)		// Processa com o numero de threads informada
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula o registro original de cada thread e     ³
	//³ aciona thread gerando arquivo de fila.           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX:=1 to Len(aThreads)

		aThreads[nX]:={{},1}

		// Registro inicial para processamento
		nInicio  := IIf( nX == 1 , 1 , aThreads[nX-1,2]+1 )

		// Quantidade de registros a processar
		nRegProc += IIf( nX == Len(aThreads) , Len(aProdutos) - nRegProc, Int(Len(aProdutos)/Len(aThreads)) )

		aThreads[nX,2] := nRegProc
		For nY := nInicio To nRegProc
			aAdd(aThreads[nX,1],aProdutos[nY,1])
		Next nY

	Next nX

Else

	cAliasSB1 := GetNextAlias()

	If cDadosProd == "SBZ"
		cQuery := "SELECT B1_COD, "
		cQuery += "       B1_GRUPO " 
		cQuery += " FROM "+RetSqlName("SB1")+" SB1 "
		cQuery += " Left Outer Join "+RetSqlName("SBZ")+" SBZ "
		cQuery += " ON BZ_FILIAL = '"+xFilial("SBZ")+"' AND BZ_COD = B1_COD AND SBZ.D_E_L_E_T_ = ' ' WHERE "

		cQueryX1 := "      SB1.B1_FILIAL='"+xFilial("SB1")+"' "
		cQueryX1 += "  AND ISNULL( BZ_FANTASM, B1_FANTASM ) <>'S' "
		cQueryX1 += "  AND ISNULL( BZ_MRP,     B1_MRP     ) IN (' ','S') "
		cQueryX1 += "  AND SB1.D_E_L_E_T_ = ' ' "

		cQueryB1 := "      SB1.B1_FILIAL='"+xFilial("SB1")+"' "
		cQueryB1 += "  AND SB1.B1_FANTASM <>'S' AND SB1.D_E_L_E_T_=' ' AND SB1.B1_MRP IN (' ','S')"
	Else
		cQuery := "SELECT B1_COD,B1_GRUPO "
		cQuery += "  FROM "+RetSqlName("SB1")+" SB1 WHERE "

		cQueryX1:= " SB1.B1_FILIAL='"+xFilial("SB1") +"' AND "
		cQueryX1+= " SB1.B1_FANTASM <>'S' AND SB1.D_E_L_E_T_=' ' AND SB1.B1_MRP IN (' ','S')"

		cQueryB1:= " SB1.B1_FILIAL='"+xFilial("SB1")+"' AND "
		cQueryB1+= " SB1.B1_FANTASM <>'S' AND SB1.D_E_L_E_T_=' ' AND SB1.B1_MRP IN (' ','S')"
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Coloca TIPOS selecionados na QUERY           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQueryX1+= " AND SB1.B1_TIPO IN ('"+Criavar("B1_TIPO",.F.)+"'"
	cQueryB1+= " AND SB1.B1_TIPO IN ('"+Criavar("B1_TIPO",.F.)+"'"
	FOR i:=1 TO LEN(A711Tipo)
		If A711Tipo[i,1]
			cQueryX1+= ",'"+SubStr(A711Tipo[i,2],1,nTamTipo711)+"'"
			cQueryB1+= ",'"+SubStr(A711Tipo[i,2],1,nTamTipo711)+"'"
		EndIf
	Next i
	cQueryX1+= ") "
	cQueryB1+= ") "

	// Otimiza query caso selecione todos os grupos ou inclui na query clausula IN com os grupos
	If !lAllGrp .And. lMRPCINQ
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Coloca GRUPOS selecionados na QUERY          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQueryX1+= "AND (SB1.B1_GRUPO IN ("
		cQueryB1+= "AND (SB1.B1_GRUPO IN ("
		FOR i:=1 TO LEN(A711Grupo)
			If A711Grupo[i,1]
				nCountGrupo++
				// Checagem para inserir na clausula IN somente 1000 grupos por vez
				// ERRO NO BANCO ORACLE caso utilize mais de 1000 argumentos numa clausula IN
				If nCountGrupo <= 1000
					If !lFirstGrupo
						cQueryX1+= ","
						cQueryB1+= ","
					Else
						lFirstGrupo:=.F.
					EndIf
				Else
			 		nCountGrupo:=1
					cQueryX1+= ") OR SB1.B1_GRUPO IN ("
					cQueryB1+= ") OR SB1.B1_GRUPO IN ("
				EndIF
				cQueryX1+= "'"+SubStr(A711Grupo[i,2],1,nTamGr711)+"'"
				cQueryB1+= "'"+SubStr(A711Grupo[i,2],1,nTamGr711)+"'"
			EndIf
		Next i
		cQueryX1+= ")) "
		cQueryB1+= ")) "
	EndIf 
	
	If Empty(cStrGrupo)
		For i:=1 To Len(A711Grupo)
			If A711Grupo[i,1]
				cStrGrupo += SubStr(a711Grupo[i,2],1,nTamGr711)+"|"
    		EndIf
    	Next
	EndIf
				
	cQuery:= ChangeQuery(cQuery + cQueryX1)

	cQueryB1 := "AND "+cQueryB1

	If lA710SQL
		cA710Fil := ExecBlock("A710SQL", .F., .F., {"SB1", cQuery})
		If ValType(cA710Fil) == "C"
			cQuery := cA710Fil
		Endif
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB1,.T.,.T.)

	//-- Carrega Array aProdutos
	Do While (cAliasSB1)->(!Eof())
		If lAllGrp .Or. ( lMRPCINQ .And. (cAliasSB1)->B1_GRUPO $ cStrGrupo )
			aAdd(aProdutos,(cAliasSB1)->B1_COD)
		EndIf
		(cAliasSB1)->(dbSkip())
	EndDo

	//-- Verifica Limite Maximo de 30 Threads
	If nThreads > 30
		nThreads := 30
	EndIf

	//-- Analisa a quantidade de Threads X nRegistros
	If Len(aProdutos) == 0
		aThreads := {}
	ElseIf Len(aProdutos) < nThreads
		aThreads := ARRAY(1)			// Processa somente em uma thread
	Else
		aThreads := ARRAY(nThreads)		// Processa com o numero de threads informada
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula o registro original de cada thread e     ³
	//³ aciona thread gerando arquivo de fila.           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX:=1 to Len(aThreads)

		aThreads[nX]:={{},1}

		// Registro inicial para processamento
		nInicio  := IIf( nX == 1 , 1 , aThreads[nX-1,2]+1 )

		// Quantidade de registros a processar
		nRegProc += IIf( nX == Len(aThreads) , Len(aProdutos) - nRegProc, Int(Len(aProdutos)/Len(aThreads)) )

		aThreads[nX,2] := nRegProc
		For nY := nInicio To nRegProc
			aAdd(aThreads[nX,1],aProdutos[nY])
		Next nY

	Next nX

	//-- Encerra cAliasSB1
	dbSelectArea(cAliasSB1)
	dbCloseArea()

EndIf
RestArea(aAreaAnt)
Return aThreads

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A710Periodo³ Autor ³Leonardo Quintania     ³ Data ³ 27/10/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica peridiocidade para aglutinacao.                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA710                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A710Periodo(dDatRef,dData,nTipo)
Local lRet    := .F.
Local nMes
Default nTipo := 1

Do Case
	Case nTipo == 0 .OR. nTipo == 1 // Pelo Programa
	Case nTipo == 2 // Diario

	Case nTipo == 3 // Semanal
		If Dow(dDatRef) != 1
			lRet := .T.
		EndIf
	Case nTipo == 4 // Quinzenal
		If (Day(dDatRef)<=15) == (Day(dData)<=15)
			lRet := .T.
		EndIf
	Case nTipo == 5 // Mensal
		If Month(dDatRef) == Month(dData)
			lRet := .T.
		EndIf
	Case nTipo == 6 // Trimestral
		nRef := Month(dDatRef)
		nMes := Month(dData)
		If nRef >=1 .and. nRef <= 3
			If nMes >= 1 .and. nMes <= 3
				lRet := .T.
			EndIf
		ElseIf nRef >=4 .and. nRef <= 6
			If nMes >=4 .and. nMes <= 6
				lRet := .T.
			EndIf
		ElseIf nRef >=7 .and. nRef <= 9
			If nMes >=7 .and. nMes <= 9
				lRet := .T.
			EndIf
		ElseIf nRef >=10 .and. nRef <= 12
			If nMes >=10 .and. nMes <= 12
				lRet := .T.
			EndIf
		EndIf
	Case nTipo == 7 // Semestral
		If (Month(dDatRef)<=6) == (Month(dData)<=6)
			lRet := .T.
		EndIf
EndCase

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A710VerHf ºAutor  ³Leonardo Quintania  º Data ³  20/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se o produto informado possui Horizonte Firme     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA710 e MATA650                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XA710VerHf(dDatPrf,cProduto)
Local nDiasHf  := Posicione("SB5",1,xFilial("SB5")+AllTrim(cProduto),"B5_DIASHF")
Local cTpOp    := If(aPergs711[10] == 1,"F","P")
Local cTpOpPar := ""
Local i 	   := aScan(aPeriodos,{|x| x == dDatPrf})
Local cFC	   := "C"

SG1->(dbSetOrder(1))
If SG1->(dbSeek(xFilial("SG1")+cProduto))
	cFC := "F"
EndIf
If ExistBlock("A650CCF")
	cFC := ExecBlock("A650CCF",.F.,.F.,{cProduto,cTipo711,dDatPrf})
	If ValType(cFC) # "C"
		cFC := If(SG1->(dbSeek(xFilial("SG1")+cProduto)),"F","C")
	EndIf
EndIf

cTpOpPar := If(aPergs711[04] == 1 .Or. cFC == "F",cSelF,cSelFSC)

If !Empty(nDiasHf)
	If (dDatPrf <= (dDataBase + nDiasHf))
		cTpOp:= "F"
	Else
		cTpOp:= "P"
	EndIf
ElseIf Substr(cTpOpPar,i,1) == "û"
    cTpOp:= "F"
Else
	cTpOp:= "P"
EndIf

Return cTpOp

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A710VerHl ºAutor  ³Leonardo Quintania  º Data ³  20/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se o produto informado possui Horizonte Liberacao º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA710 e MATA650                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function ZA710VerHl(dDatPrf,cProduto)
Local nDiasHf  := Posicione("SB5",1,xFilial("SB5")+AllTrim(cProduto),"B5_DIASHL")
Local lGera	   := .T.
If !Empty(nDiasHf)
	If (dDatPrf <= (dDataBase + nDiasHf))
		lGera:= .T.
	Else
		lGera:= .F.
	EndIf
EndIf

Return lGera

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ AT710IMarc ³ Autor ³Leonardo Quintania	³ Data ³09/05/2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Marca todas as linhas com evento de clique no cabeçalho da ³±±
±±³			 ³ browse.											     	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ AT710IMarc()		                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ NIL														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA710                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER Function XAT710IMarc(oBrowse)
Local aChks         :={}

aEval(oBrowse:aCols, {|x| aAdd(aChks,If(x[1]==oOK,.T.,.F.))})

If aScan(aChks, {|x| !x }) > 0
	aEval(@oBrowse:aCols, {|x| x[1] := oOK})
Else
	aEval(@oBrowse:aCols, {|x| x[1] := oNO})
EndIf

oBrowse:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ A710Reprog   ³ Autor ³ Cleber Maldonado 	³ Data ³25/05/2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Reprograma as opções Firme/Prevista na tela períodos para  ³±±
±±³			 ³ geração de SC's / OP's      						     	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A710Reprog()		                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parâmetros³             		                                          ³±±
±±³Param1    ³ Objeto com os períodos do MRP                              ³±±
±±³Param2    ³ Numero da opção selecionada (Firme/Prevista)               ³±±
±±³Param3    ³ Data de inicio para reprogramar opções                     ³±±
±±³Param4    ³ Data limite para reprogramar opções                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ NIL														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA710                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER Function XA710Reprog(oGetPer,nSelec,dDatDe,dDatAte)
Local nX := 1

For nX := 1 To Len(oGetPer:aCols)
	If CTOD(oGetPer:aCols[nX,2]) >= dDatde .and. CTOD(oGetPer:aCols[nX,2]) <= dDatAte
		oGetPer:aCols[nX,3] := Alltrim(Str(nSelec))
	Endif
Next nX

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A710ClrSHFºAutor  ³ Andre Anjos		 º Data ³  03/07/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Limpa a tabela de necessidades por filial.	              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA710                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A710ClrSHF()
Local aArea := GetArea()

dbSelectArea("SHF")
dbSetOrder(1)
dbSeek(xFilial("SHF")+cFilAnt)
While !EOF() .And. HF_FILIAL+HF_FILNEC == xFilial("SHF")+cFilAnt
	RecLock("SHF",.F.)
	dbDelete()
	MsUnLock()

	dbSkip()
End
dbCloseArea()

//-- Execua pack na tabela SHF para evitar que o arquivo cresça sem necessidade
If MsOpenDBF(.T.,__cRDD,"SHF"+cEmpAnt+"0","SHF",.F.,.F.)
	Pack
	dbCloseArea()
EndIf

RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A710FilAlmºAutor  ³ Andre Anjos		 º Data ³  20/08/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Filtra armazens por range quando MV_MRPFILA ativo.         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ lSeleciona: indica se abre tela de selecao.				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA710													  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A710FilAlm(lSeleciona)
Local aDados  := {}
Local oDlg    := NIL
Local oBrw	  := NIL
Local nX	  := 0
Local cAlmDe  := If(lSeleciona,mv_par08,aPergs711[8])
Local cAlmAte := If(lSeleciona,mv_par09,aPergs711[9])

Default lSeleciona := .F.

If SuperGetMV("MV_MRPFILA",.F.,.F.)
	NNR->(dbSetOrder(1))
	NNR->(dbSeek(xFilial("NNR")))
	While !NNR->(EOF()) .And. NNR->NNR_FILIAL == xFilial("NNR")
		If NNR->NNR_CODIGO >= cAlmDe .And. NNR->NNR_CODIGO <= cAlmAte .And. NNR->NNR_MRP # '2'
			aAdd(aDados,{.T.,NNR->NNR_CODIGO,NNR->NNR_DESCRI})
		EndIf
		NNR->(dbSkip())
	End

	If lSeleciona .And. !Empty(aDados)
		oDlg := MSDialog():New(0,0,280,390,STR0180,,,,,,,,oMainWnd,.T.) //-- Seleção de armazéns
		oDlg:nStyle := DS_MODALFRAME
		oDlg:lEscClose := .F.
		TSay():Create(oDlg,{|| STR0181},05,05,,,,,,.T.,,,200,10) //-- Selecione os armazéns cujos saldos devem ser considerados no cálculo MRP:
		oBrw := TWBrowse():New(20,05,190,100,{|| {If(aDados[oBrw:nAt,1],oOk,oNo),aDados[oBrw:nAt,2],aDados[oBrw:nAt,3]}},{"",RetTitle("NNR_CODIGO"),RetTitle("NNR_DESCRI")},,oDlg,,,,,{|| aDados[oBrw:nAt,1] := !aDados[oBrw:nAt,1],oBrw:Refresh()},,,,,,,,,.T.)
		oBrw:SetArray(aDados)
		oBrw:bLine := {|| {If(aDados[oBrw:nAt,1],oOk,oNo),aDados[oBrw:nAt,2],aDados[oBrw:nAt,3]}}
		TButton():Create(oDlg,125,5,STR0182,{|| oDlg:End()},70,10,,,,.T.) //-- Confirmar
		oDlg:Activate(,,,.T.)
	EndIf

	aAlmoxNNR := {}
	aEval(aDados,{|x| If(x[1],aAdd(aAlmoxNNR,x[2]),NIL)})
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MontaOpc	  ³ Autor ³ Anieli Rodrigues   	³ Data ³02/01/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Monta String com o codigo do opcional (Campo C6_MOPC)      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MontaOpc(cMopc)		                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cMopc	- Conteudo do campo memo a ser transformado           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ cRet - Conteudo em caractere								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA710                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*/
Static Function MontaOpc(cMOpc)
Local cRet := "" 
Local aAux := {} 

If !Empty(aAux := STR2Array(cMOpc,.F.)) 
aEval(aAux,{|x| cRet += x[2]}) 
Endif 

If Len(cRet) == 0
	cRet := AllTrim(cMOpc)
EndIf

Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MOpcSeek	  ³ Autor ³ Anieli Rodrigues   	³ Data ³08/01/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Posiciona o arquivo no registro desejado (quando utilizado ³±±
±±³			 ³ campo Memo para tratamento dos opcionais					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MOpcSeek(cAlias,nOrdem,cProduto,cPeriodo,cOpc,cRevisao)	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias - Alias do arquivo a ser posicionado		          ³±±
±±³			 |nOrdem - Ordem do arquivo a ser utilizado 		          ³±±
±±³			 |cNivel - Codigo do nivel					 		          ³±±
±±³			 |cProduto - Codigo do produto				 		          ³±±
±±³			 |cPeriodo - Periodo do MRP 				 		          ³±±
±±³			 |cOpc - Opcional do produto    		 		              ³±±
±±³			 |cRevisao - Revisao da estrutura 		 		              ³±±
±±³			 |cTipo - Tipo da SHA			 		 		              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ lExiste - Indica se o registro foi localizado			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA710                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*/
USER Function XMOpcSeek(cAlias,nOrdem,cNivel,cProduto,cPeriodo,cOpc,cRevisao,cTipo,lConsPer,lSoftSeek)

Local lExiste    := .F. 

Default cTipo    := "1"
Default cProduto := ""
Default cPeriodo := ""
Default cOpc     := ""
Default cRevisao := ""
Default cTipo    := ""
Default nOrdem   := 1
Default lConsPer := .T.
Default lSoftSeek:= .F.

DbSelectArea(cAlias)
DbSetOrder(nOrdem)

If (cAlias == "SHA") .And. (nOrdem == 1)
	//HA_PRODUTO+HA_REVISAO+HA_TIPO
	MsSeek(xFilial("SHA")+cProduto+cRevisao+cTipo)
	While cProduto+cRevisao+cTipo == HA_PRODUTO+HA_REVISAO+HA_TIPO
		If (MontaOpc(cOpc) == MontaOpc(HA_OPC))
			lExiste := .T.
			Exit
		Else 
			DbSkip()
		EndIf
	End
EndIf

If (cAlias == "SHA") .And. (nOrdem == 2)
	//xFilial("SHA")+HA_NIVEL+HA_PRODUTO+HA_REVISAO+HA_TIPO
	MsSeek(xFilial("SHA")+cNivel+cProduto+cRevisao+cTipo)
	While (cNivel+cProduto+cRevisao+cTipo == HA_NIVEL+HA_PRODUTO+HA_REVISAO+HA_TIPO)
		If MontaOpc(cOpc) != MontaOpc(HA_OPC)
			DbSkip()
		Else	
			lExiste := .T.
			Exit
		EndIf
	End
EndIf

If (cAlias == "SH5") .And. (nOrdem == 1)
	//xFilial("SH5")+H5_PRODUTO+H5_REVISAO+H5_PER
	
    If !lSoftSeek
		MsSeek(xFilial("SH5")+cProduto+cRevisao+IIf(lConsPer,cPeriodo,""))
		While cProduto+cRevisao+IIf(lConsPer,cPeriodo,"") == H5_PRODUTO+H5_REVISAO+IIf(lConsPer,H5_PER,"")
			If (MontaOpc(cOpc) == MontaOpc(H5_OPC))
				lExiste := .T.
				Exit	
			Else
				DbSkip()
			EndIf
		End
	Else 
		MsSeek(xFilial("SH5")+cProduto+cRevisao+IIf(lConsPer,cPeriodo,""))
		While cProduto+cRevisao+IIf(lConsPer,cPeriodo,"") == H5_PRODUTO+H5_REVISAO+IIf(lConsPer,H5_PER,"")
			If (MontaOpc(cOpc) == MontaOpc(H5_OPC))
				lExiste := .T.
				Exit	
			Else
				DbSkip()
			EndIf
		End
		If !lExiste
			MsSeek(xFilial("SH5")+cProduto+cRevisao+IIf(lConsPer,cPeriodo,""),.T.)
	  	EndIf
	EndIf
EndIf

//INDEX ON H5_FILIAL+H5_ALIAS+H5_NIVEL+H5_PRODUTO+H5_REVISAO	TAG &(cNameIdx+"2") TO &(cNameIdx)
//INDEX ON H5_FILIAL+H5_PRODUTO+H5_ALIAS+DTOS(H5_DATAORI) 		TAG &(cNameIdx+"3") TO &(cNameIdx)
//INDEX ON H5_FILIAL+H5_ALIAS+H5_DOC+DTOS(H5_DATAORI) 			TAG &(cNameIdx+"4") TO &(cNameIdx)

Return lExiste

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    |A710AvSldA| Autor ³ Anieli Rodrigues      ³ Data ³09.10.2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao utilizada para avaliar se o saldo do alternativo foi ³±±
±±³          |consumido em data futura, avaliando a existencia de outro	  ³±±
±±³          |alternativo para substituicao. 					          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cProdAlt     - Alternativo a ser avaliado  				  |±±
±±³          ³cPeriodo     - Periodo inicial de avaliacao                 ³±±
±±³          ³nSldPer      - Saldo no periodo inicial de avaliacao        ³±±
±±³          ³nSldPer      - Saldo no periodo inicial de avaliacao        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA710                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/         
Static Function A710AvSldA(cProdAlt,cPeriodo,cRev711Vaz,cParStrTipo,cParStrGrupo,dDataNes)
Local aAreaSHA 	:= SHA->(GetArea())
Local aAreaSH5 	:= SH5->(GetArea()) 
Local aAreaSGI	:= SGI->(GetArea())
Local nSaldo 	:= 0
Local nQuant	:= 0
Local nQuantParc:= 0
Local nQtdConv	:= 0
Local nNewPer	:= 0
Local cProdTroca:= ""
Local dDataTroca:= dDataBase
Local cDocTroca	:= ""

SB1->(dbSetOrder(1))
SGI->(dbSetOrder(1))
SHA->(dbSetOrder(1))
For nNewPer := Val(cPeriodo)+1 To Len(aPeriodos)
	cPeriodo := StrZero(nNewPer,3)

	//-- Posiciona no cadastro do produto
	SB1->(dbSeek(xFilial("SB1")+cProdAlt))

	//-- Verifica saldo do produto alternativo no periodo.
	nSaldo := A710SldSHA(cProdAlt,cPeriodo,Space(Len(SHA->HA_OPC)),SB1->B1_REVATU)

If nSaldo < 0
		SH5->(DbSetOrder(5))
		SH5->(MsSeek(xFilial("SH5")+cProdAlt+Space(Len(SH5->H5_OPC))+If(A710TrataRev(),SB1->B1_REVATU,cRev711Vaz)+cPeriodo+"4"))
		While nSaldo < 0 .And. !SH5->(EOF()) .And. SH5->(H5_PRODUTO+H5_OPC+H5_REVISAO+H5_PER+H5_TIPO) == ;
									cProdAlt+Space(Len(SH5->H5_OPC))+If(A710TrataRev(),SB1->B1_REVATU,cRev711Vaz)+cPeriodo+"4"
			
			nQuantParc := Min(SH5->H5_QUANT,Abs(nSaldo)) //-- Quantidade a trocar
      			
       		If Empty(SH5->H5_PRODORI) //-- Se a saida e do produto principal
       			//-- Procura disponibilidade do saldo utilizado nos produtos alternativos ja fazendo a troca
       			nQuant := A710VerAlt(cProdAlt,SH5->H5_DOC,cPeriodo,nQuantParc,cParStrTipo,cParStrGrupo,cRev711Vaz,SH5->H5_DATAORI,0,Space(Len(SHA->HA_OPC)))
       			       			
       			If nQuant == 0 //-- Trocou saida inteira por alternativos
       				//-- Remove saida da linha de saidas da estrutura
       				SHA->(dbSeek(xFilial("SHA")+cProdAlt+Space(Len(HA_OPC))+If(A710TrataRev(),SB1->B1_REVATU,cRev711Vaz)+"4"))
       				RecLock("SHA",.F.)
       				SHA->&("HA_PER"+cPeriodo) -= SH5->H5_QUANT
       				SHA->(MsUnLock())
       				       				
       				//-- Remove saida
	       			RecLock("SH5",.F.)
	       			SH5->(dbDelete())
	       			SH5->(MsUnlock())
	       			
	       			//-- Recalcula saldo do produto no periodo
	       			u_XMA711Recalc(cProdAlt,Space(Len(SHA->HA_OPC)),If(A710TrataRev(),SB1->B1_REVATU,cRev711Vaz),StrZero(nNewPer-1,3),NIL,NIL)
	       			
				ElseIf nQuant < SH5->H5_QUANT .And. nQuant > 0 .And. nQuant != nQuantParc //-- Trocou parte da saida por alternativos
					//-- Diminui saida da linha de saidas da estrutura
					SHA->(dbSeek(xFILIAL("SHA")+cProdAlt+Space(Len(HA_OPC))+If(A710TrataRev(),SB1->B1_REVATU,cRev711Vaz)+"4"))
					Reclock("SHA",.F.)
					SHA->&("HA_PER"+cPeriodo) -= SH5->H5_QUANT - nQuant
					SHA->(MsUnlock())

					//-- Diminui saida do registro de necessidade
					RecLock("SH5",.F.)
					SH5->H5_QUANT := nQuant
					SH5->(MsUnLock())
					
					//-- Recalcula saldo do produto no periodo
					u_XMA711Recalc(cProdAlt,Space(Len(SHA->HA_OPC)),If(A710TrataRev(),SB1->B1_REVATU,cRev711Vaz),StrZero(nNewPer-1,3),NIL,NIL)					
				EndIf
       		Else //-- Se a saida e de produto alternativo de algum principal
       			//-- Posiciona SB1 no produto origem
       			SB1->(dbSeek(xFilial("SB1")+SH5->H5_PRODORI))
       			
       			//-- Posiciona SGI no registro da mp orinigal para pegar o fator de conversao
	       		SGI->(dbSeek(xFilial("SGI")+SH5->H5_PRODORI))
	       		While !SGI->(EOF()) .And. SGI->(GI_FILIAL+GI_PRODORI) == xFilial("SGI")+SH5->H5_PRODORI
	       			If SGI->GI_PRODALT == cProdAlt
		       			Exit
		       		EndIf
		       		SGI->(dbSkip())
	       		End
	       			       		
	       		If SGI->GI_TIPOCON == "M"
					nQtdConv := nQuantParc / SGI->GI_FATOR
				Else
					nQtdConv := nQuantParc * SGI->GI_FATOR
				EndIf
				
				//-- Procura disponibilidade do saldo utilizado nos produtos alternativos ja fazendo a troca
				nQuant := A710VerAlt(SH5->H5_PRODORI,SH5->H5_DOC,cPeriodo,nQtdConv,cParStrTipo,cParStrGrupo,cRev711Vaz,SH5->H5_DATAORI,0,Space(Len(SHA->HA_OPC)))

       			If nQuantParc == SH5->H5_QUANT //-- Trocou saida inteira por alternativo ou principal
       				//-- Remove saida da linha de saidas da estrutura
					SHA->(dbSeek(xFilial("SHA")+cProdAlt+Space(Len(HA_OPC))+If(A710TrataRev(),SB1->B1_REVATU,cRev711Vaz)+"4"))
       				RecLock("SHA",.F.)
       				SHA->&("HA_PER"+cPeriodo) -= SH5->H5_QUANT
       				SHA->(MsUnLock())
       				
       				cProdTroca 	:= SH5->H5_PRODORI
       				dDataTroca	:= SH5->H5_DATAORI
       				cDocTroca	:= SH5->H5_DOC
       				
	       			//-- Remove saida
	       			RecLock("SH5",.F.)
	       			SH5->(dbDelete())
	       			SH5->(MsUnlock())
	       			
	       			//-- Recalcula saldo do produto no periodo
	       			u_XMA711Recalc(cProdAlt,Space(Len(SHA->HA_OPC)),If(A710TrataRev(),SB1->B1_REVATU,cRev711Vaz),StrZero(nNewPer-1,3),NIL,NIL)
       			ElseIf nQuantParc < SH5->H5_QUANT //-- Trocou parte da saida por alternativos

					//-- Diminui saida da linha de saidas da estrutura
					SHA->(dbSeek(xFilial("SHA")+cProdAlt+Space(Len(HA_OPC))+If(A710TrataRev(),SB1->B1_REVATU,cRev711Vaz)+"4"))
					Reclock("SHA",.F.)
					SHA->&("HA_PER"+cPeriodo) -= nQuantParc
					SHA->(MsUnlock())

					//-- Diminui saida do registro de necessidade
					RecLock("SH5",.F.)
					SH5->H5_QUANT -= nQuantParc
					SH5->(MsUnLock())
					
					//-- Recalcula saldo do produto no periodo
					u_XMA711Recalc(cProdAlt,Space(Len(SHA->HA_OPC)),If(A710TrataRev(),SB1->B1_REVATU,cRev711Vaz),StrZero(nNewPer-1,3),NIL,NIL)
				EndIf
				
				//-- Gera saida do principal, ja que nao encontrou outros alternativos
				If nQuant > 0
					aDados := {SH5->H5_PRODORI,nQuant,SH5->H5_DATAORI}
					A710CriaLOG("004",SH5->H5_PRODORI,aDados,lLogMRP,c711NumMrp)
					A711CriSH5(SH5->H5_DATAORI,SH5->H5_PRODORI,Space(Len(SHA->HA_OPC)),SB1->B1_REVATU,"SHA",0,Padr(SH5->H5_DOC,Len(SG1->G1_COD)),"","",nQuant,"4",.F.,nil,nil,.F.,.T.,nil,nil,nil,cParStrTipo,cParStrGrupo,0)
					
					//-- Recalcula saldo do produto no periodo
					u_XMA711Recalc(cProdTroca,Space(Len(SHA->HA_OPC)),If(A710TrataRev(),SB1->B1_REVATU,cRev711Vaz),StrZero(nNewPer-1,3),NIL,NIL)
					
					//-- Avalia se o produto nao foi utilizado em data futura e troca se necessário
					A710AvSldA(cProdTroca,A650DtoPer(dDataTroca),cRev711Vaz,cParStrTipo,cParStrGrupo,dDataTroca)
				EndIf
			EndIf

			//-- Atualiza saldo do produto
			nSaldo := A710SldSHA(cProdAlt,cPeriodo,Space(Len(SHA->HA_OPC)),SB1->B1_REVATU)

			SH5->(dbSkip())			
		EndDo
	EndIf
Next nNewPer

SHA->(RestArea(aAreaSHA))
SH5->(RestArea(aAreaSH5)) 
SGI->(RestArea(aAreaSGI))  

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³A710VerAlt³ Autor ³ Anieli Rodrigues      ³ Data ³09.10.2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se ha produtos alternativos para substituicao na  ³±±
±±³          ³ geracao de necessidades.									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cProd        - Produto                                      ³±±
±±³          ³cPeriodo     - Periodo de avaliacao do saldo                ³±±
±±³          ³nQuantItem   - Quantidade da necessidade a ser alterado     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³nQuantItem   - Saldo nao atendido por alternativos		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA710                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/  
Static Function A710VerAlt(cProd,cProdPai,cPeriodo,nQuantItem,cParStrTipo,cParStrGrupo,cRev711Vaz,dDataNes,nPrazoEnt,cOpcionais)
Local nSldAlt	:= 0 
Local nSldMp	:= 0
Local nQtdAlter	:= 0
Local aAreaSHA	:= SHA->(GetArea())
Local aAreaSH5	:= SH5->(GetArea())
Local aAreaSGI  := SGI->(GetArea())
Local lVldAlt	:= .T.        

If ValType(cParStrTipo) == "C"
	cStrTipo := cParStrTipo
EndIf

SGI->(dbSetOrder(1))
SGI->(dbSeek(xFilial("SGI")+cProd))
While nQuantItem > 0 .And. !SGI->(EOF()) .And. SGI->(GI_FILIAL+GI_PRODORI) == xFilial("SGI")+cProd
	//-- Verifica se alternativo esta na parametrizacao	inicial do MRP e se entra no calculo.
	If SGI->GI_MRP # "S" .Or. !U_XM711AvalProd(SGI->GI_PRODALT,cStrTipo,cStrGrupo)
		SGI->(dbSkip())
		Loop
	EndIf
	
	//Ponto de Entrada para validação da utilização deste alternativo
	If ExistBlock("A710VLALT")
		lVldAlt := ExecBlock("A710VLALT",.F.,.F.)
		If ValType(lVldAlt) == "L" .And. !lVldAlt
			SGI->(dbSkip())
			Loop
		EndIf
	EndIf
	
	//-- Posiciona SB1 no produto alternativo
	SB1->(MsSeek(xFilial("SB1")+SGI->GI_PRODALT))
	
	//-- Converte a quantidade faltante conforme fator do alternativo
	If SGI->GI_TIPOCON == "M"
		nQtdAlter := (nQuantItem - Max(nSldMp,0)) * SGI->GI_FATOR
	Else
		nQtdAlter := (nQuantItem - Max(nSldMp,0)) / SGI->GI_FATOR
	EndIf
	
	//-- Obtem saldo do produto alternativo no periodo analisado
	nSldAlt := A710SldSHA(SGI->GI_PRODALT,cPeriodo,cOpcionais,SB1->B1_REVATU)
	
	//-- Se tem saldo do alternativo, o utiliza
	If Min(nQtdAlter,nSldAlt) > 0
		//-- Gera Log MRP e SH5 da quantidade utilizada do alternativo
		aDados := {SG1->G1_COD,Min(nQtdAlter,nSldAlt),SomaPrazo(dDataNes,-nPrazoEnt)}
		A710CriaLOG("004",SGI->GI_PRODALT,aDados,lLogMRP,c711NumMrp)
		A711CriSH5(SomaPrazo(dDataNes,-nPrazoEnt),SGI->GI_PRODALT,cOpcionais,SB1->B1_REVATU,"SHA",0,cProdPai,"","",Min(nQtdAlter,nSldAlt),"4",.F.,nil,nil,.F.,.T.,nil,nil,nil,cParStrTipo,cParStrGrupo,,cProd)

		//-- Recalcula saldo do alternativo consumido			
		u_XMA711Recalc(SGI->GI_PRODALT,cOpcionais,If(A710TrataRev(),SB1->B1_REVATU,cRev711Vaz),NIL,NIL,NIL)

		//-- Avalia se o alternativo nao foi utilizado em data futura e troca                    
		A710AvSldA(SGI->GI_PRODALT,cPeriodo,cRev711Vaz,cParStrTipo,cParStrGrupo,dDataNes)

		//-- Volta nQuantItem com o saldo nao atendido
		If SGI->GI_TIPOCON == "M"
			nQuantItem -= Min(nQtdAlter,nSldAlt) / SGI->GI_FATOR
		Else
			nQuantItem -= Min(nQtdAlter,nSldAlt) * SGI->GI_FATOR
		EndIf
	EndIf												
	SGI->(dbSkip())
End

SHA->(RestArea(aAreaSHA))
SH5->(RestArea(aAreaSH5))
SHI->(RestArea(aAreaSGI)) 

Return nQuantItem

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A710SldSHAºAutor  ³ Anieli Rodrigues   º Data ³  17/10/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Retorna o saldo de um produto em determinado periodo pela  º±±
±±º          ³ projecao do MRP (SHA).                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ cProduto: codigo do produto a analisar.					  º±±
±±º			 ³ cPeriodo: Periodo para analise do saldo.					  º±±
±±º			 ³ cOpc: opcional diferenciador de saldo.					  º±±
±±º			 ³ cRevisao: revisao diferenciadora de saldo.				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ nRet: saldo do produto/periodo recebidos.				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA710				                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A710SldSHA(cProduto,cPeriodo,cOpc,cRevisao)
Local aArea  := SHA->(GetArea())
Local nRet   := 0

cRevisao := If(!Empty(cRevisao) .And. A710TrataRev(),cRevisao,CriaVar("B1_REVATU",.F.))
cOpc 	 := PadR(cOpc,Len(SHA->HA_OPC))

//-- Recalcula saldo para garantir integridade
u_XMA711Recalc(cProduto,cOpc,cRevisao,NIL,NIL,NIL)

dbSelectArea("SHA")
dbSetOrder(1)

If !lUsaMOpc
	dbSeek(xFilial("SHA")+cProduto+cOpc+cRevisao+"1")
	dbSeek(xFilial("SHA")+cProduto+cOpc+cRevisao+"1")
	nRet := &("HA_PER"+cPeriodo)
	dbSeek(xFilial("SHA")+cProduto+cOpc+cRevisao+"2")
	nRet += &("HA_PER"+cPeriodo)
	dbSeek(xFilial("SHA")+cProduto+cOpc+cRevisao+"3")
	nRet -= &("HA_PER"+cPeriodo)
	dbSeek(xFilial("SHA")+cProduto+cOpc+cRevisao+"4")
	nRet -= &("HA_PER"+cPeriodo)
Else
	MOpcSeek("SHA",1,,cProduto,,cOpc,cRevisao,"1") 
	nRet := &("HA_PER"+cPeriodo)
	MOpcSeek("SHA",1,,cProduto,,cOpc,cRevisao,"2") 
	nRet += &("HA_PER"+cPeriodo)
	MOpcSeek("SHA",1,,cProduto,,cOpc,cRevisao,"3") 
	nRet -= &("HA_PER"+cPeriodo)
	MOpcSeek("SHA",1,,cProduto,,cOpc,cRevisao,"4") 
	nRet -= &("HA_PER"+cPeriodo)
EndIf

RestArea(aArea)

Return nRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A710ExSGI ºAutor  ³ Anieli Rodrigues   º Data ³  26/10/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Verifica se um produto existe como Produto Original        º±±
±±º          ³ ou como Produto Alternativo na tabela SGI                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ cProduto: codigo do produto a ser buscado na tabela		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ nRet: saldo do produto/periodo recebidos.				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA710				                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A710ExSGI(cProduto)
Local aArea  		:= GetArea()
Local lRet 	 	:= .F.
Local cQuery 		:= ""  
Local cAlias	:= ""

//-- Avalia se o produto eh alternativo ou possui algum alternativo
cAlias := "AVALT"
cQuery := "SELECT COUNT(*) nCount"
cQuery += " FROM "+RetSqlName("SGI")+" SGI"
cQuery += " WHERE (SGI.GI_FILIAL = '"+xFilial("SGI")+"')"
cQuery += " AND (SGI.GI_PRODORI = '"+cProduto+"' OR SGI.GI_PRODALT = '"+cProduto+"')"
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
If (cAlias)->nCount < 1 	
	lRet := .F.
Else
	lRet := .T. 
EndIf 
(cAlias)->(DbCloseArea())

RestArea(aArea)

Return lRet   
