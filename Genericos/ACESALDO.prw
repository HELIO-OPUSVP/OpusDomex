#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 21/02/01

User Function ACESALDO()        // incluido pelo assistente de conversao do AP5 IDE em 21/02/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NOPCA,LEND,AAC,CSAVSCR3,CSAVEMENUH,NPOSANT")
SetPrvt("NPOSATU,NPOSCNT,CMENS,AAREAANT,ACRIASDB,AGRAVASD5")
SetPrvt("ALOCAIS,ASLOTE,ALOTESLOTE,ASALDO,CFILSB1,CCOD")
SetPrvt("CLOCAL,CLOTECTL,CNUMLOTE,CNUMSERI,CLOCALIZ,CSEEKSB9")
SetPrvt("CSEEKSD1,CSEEKSD2,CSEEKSD3,CSEEKSD5,CSEEKSDA,CSEEKSDB")
SetPrvt("CARQSDA,LRASTRO,LRASTROS,LLOCALIZA,NX,NY")
SetPrvt("NINDSDA,NSALDO,NDIFSALDO,NSALDOSD5,NSALDOSDB,NSALDOSD5T")
SetPrvt("NSALDOSDBT,")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ ACESALDO ³ Autor ³ Fernando Joly Siquini ³ Data ³08/11/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Acerta os Saldos Diferentes entre SB2 x SB8 x SBF          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAEST                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
nOpca := 0
lEnd  := .F.
#IFNDEF WINDOWS
	//-- Salva a Integridade dos dados de Entrada
	aAC        := {'Abandona','Confirma'}
	cSavScr3   := ''
	cSaveMenuh := ''
	nPosAnt    := 6
	nPosAtu    := 6
	nPosCnt    := 0
	//-- Salva a linha que mostrara' o cursor
	#IFDEF TOP
		TCInternal(5,'*OFF') //-- Desliga Refresh no Lock do Top
	#ENDIF
	DispBegin()
	ScreenDraw('SMT999', 3, 0, 0, 0)
	SetColor('W/W,,,,')
	@ 03,01 Say 'Acerto de Saldos B2xB8xBF  ' Color 'B/W'
	SetColor('W/N,,,,')
	@ 06,04,21,04 Box 'Þ'
	@ 06,77,21,77 Box 'Ý'
	@ 21,05 Say 'Ý'
	@ 21,76 Say 'Þ'
	SetColor('B/BG,,,,')
	@ 07,05 Clear To 20,76
	SetColor('N/BG,,,,')
	@ 06,05,06,76 BOX '±'
	SetColor('N/W,,,,')
	@ 21,06,21,75 Box '±'
	SetColor('W/N,,,')
	@6,25 SAY PADC('Acerto de Saldos',27)
	SetColor('B/BG,,,')
	@ 11,07 Say 'Este programa tem o objetivo de Acertar os  Saldos dos arquivos  SB2'
	@ 12,07 Say '(Saldo F¡sico e  Financeiro),  SB8  (Saldo por Lote/Sub-Lote)  e SBF'
	@ 13,07 Say '(Saldo  por Localizacao) com base nos arquivos de  Movimenta‡oes SD1'
	@ 14,07 Say '(NFs de  Entrada),  SD2  (NFs de Saida),  SD3  (Movimentos Internos)'
	@ 15,07 Say 'SD5 (Mov.Lote/Sub-Lote), SDB (Mov.Localiza‡Æo) e SDA(Slds a Distrib)'
	cSavScr3 := SaveScreen(21,0,21,79)
	DispEnd()
	cSaveMenuh := SaveScreen(10,14,19,64)
	Tone(3500,1)
	Set Color to W+/R
	@ 10,16 Clear To 18,64
	@ 11,19 to 17,61
	@ 11,30 Say ' A  T  E  N  C  A  O '
	@ 12,21 Say 'Esta  rotina  exige  que  os   arquivos'
	@ 13,21 Say 'associados a ela n†o estejam em uso por'
	@ 14,21 Say 'outras esta‡”es.'
	@ 15,21 Say 'Fa‡a c/ que os outros usu rios saiam do'
	@ 16,21 Say 'sistema. Deixe este programa Exclusivo.'
	Set Color to W/R
	@ 18,42 Say 'Pressione uma tecla.'
	Set Color to B/N
	@ 11,14 Clear To 19,15
	@ 19,14 Clear To 19,62
	@ 19,42,19,43 Box '°'
	@ 12,14,12,15 Box '°'
	Inkey(0)
	RestScreen(10,14,19,64,cSaveMenuh)
	SetColor('N/W,,,,')
	@ 21,05 Clear to 21,76
	nOpcA := MenuH(aAC,21,6,'B/W,W+/N,R/W','AC','Quanto ao Acerto de Saldos? ',1)
	If nOpca == 2
		_ACESALDO()
	Endif
#ELSE
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Salva a Integridade dos dados de Entrada                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	#IFDEF TOP
		TCInternal(5,'*OFF') //-- Desliga Refresh no Lock do Top
	#ENDIF
	cMens := OemToAnsi('Esta  rotina  exige  que  os   arquivos')+chr(13)
	cMens := cMens+OemToAnsi('associados a ela nao estejam em uso por')+chr(13)
	cMens := cMens+OemToAnsi('outras estacoes.')+chr(13)
	cMens := cMens+OemToAnsi('Fa‡a c/ que os outros usuarios saiam do')+chr(13)
	cMens := cMens+OemToAnsi('sistema. Deixe este programa Exclusivo.')+chr(13)
	If MsgYesNo(cMens,OemToAnsi('ATENCAO'))
		@ 96, 009 TO 310, 592 DIALOG oDlg TITLE OemToAnsi('Acerto dos Saldos')
		@ 18, 006 TO 066, 287
		@ 29, 015 SAY OemToAnsi('Este programa tem o objetivo de Acertar os Saldos dos arquivos SB2(Sld Fisi/Finan), SB8(Saldo por') SIZE 268, 8
		@ 38, 015 SAY OemToAnsi('Lote/Sub-Lote) e SBF(Saldo p/Localizacao) com base nos arquivos de Movimentacoes SD1(NF Entrada),') SIZE 268, 8
		@ 48, 015 SAY OemToAnsi('SD2(NF Saida), SD3(Mov.Interno), SD5(Mov.Lote/Sub-Lote), SDB(Mov.Localizacao) e SDA(Sld a Distr).') SIZE 268, 8
		@ 80, 224 BMPBUTTON TYPE 1 ACTION _EXEACESAL()// Substituido pelo assistente de conversao do AP5 IDE em 21/02/01 ==> 		@ 80, 224 BMPBUTTON TYPE 1 ACTION Execute(_EXEACESAL)
		@ 80, 252 BMPBUTTON TYPE 2 ACTION Close(oDlg)
		ACTIVATE DIALOG oDlg
		If nOpca == 1
			Processa({|lEnd| _ACESALDO()}, 'Acerto dos Saldos...')// Substituido pelo assistente de conversao do AP5 IDE em 21/02/01 ==> 			Processa({|lEnd| Execute(_ACESALDO)}, 'Acerto dos Saldos...')
		EndIf
	EndIf	
#ENDIF

// Substituido pelo assistente de conversao do AP5 IDE em 21/02/01 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP5 IDE em 21/02/01

// Substituido pelo assistente de conversao do AP5 IDE em 21/02/01 ==> Function _EXEACESAL
Static Function _EXEACESAL()

nOpcA := 1
Close(oDlg)
Return .T.

// Substituido pelo assistente de conversao do AP5 IDE em 21/02/01 ==> Function _ACESALDO
Static Function _ACESALDO()

//-- Variaveis Especificas
aAreaAnt   := {}
aCriaSDB   := {}
aGravaSD5  := {}
aLocais    := {}
aSLote     := {}
aLoteSLote := {}
aSaldo     := {}
cFilSB1    := xFilial('SB1')
cCod       := ''
cLocal     := ''
cLoteCtl   := ''
cNumLote   := ''
cNumSeri   := ''
cLocaliz   := ''
cSeekSB9   := ''
cSeekSD1   := ''
cSeekSD2   := ''
cSeekSD3   := ''
cSeekSD5   := ''
cSeekSDA   := ''
cSeekSDB   := ''
cArqSDA    := ''
lRastro    := .F.
lRastroS   := .F.
lLocaliza  := .F.
nX         := 0
nY         := 0
nIndSDA    := 0
nSaldo     := 0
nDifSaldo  := 0
nSaldoSD5  := 0
nSaldoSDB  := 0
nSaldoSD5t := 0
nSaldoSDBt := 0

//-- Abertura dos Arquivos e Indices utilizados no Programa
dbSelectArea('SDA')
dbSetOrder(1)
If GetMV('MV_RASTRO')=='S'
	cArqSDA := CriaTrab('', .F.)
	IndRegua('SDA', cArqSDA, 'DA_FILIAL+DA_PRODUTO+DA_LOCAL+DA_LOTECTL+DA_NUMLOTE',,, 'Selecionando Registros...')
	nIndSDA := RetIndex('SDA')
	#IFNDEF TOP
		dbSetIndex(cArqSDA+OrdBagExt())
	#ENDIF
	dbSetOrder(nIndSDA+1)	
	dbGoTop()
EndIf	

dbSelectArea('SB9')
dbSetOrder(1)

dbSelectArea('SD5')
dbSetOrder(2)

dbSelectArea('SD3')
dbSetOrder(3)

dbSelectArea('SD2')
dbSetOrder(1)

dbSelectArea('SD1')
dbSetOrder(5)

dbSelectArea('SDB')
dbSetOrder(2)

//-- Gera movimenta‡äes de Corre‡Æo no SD5 e SDB para Eliminar Saldos Negativos
dbSelectArea('SB1')
ProcRegua(RecCount(), 21, 05)
dbSetOrder(1)
dbGoTop()
Do While !lEnd .And. !Eof() .And. cFilSB1==SB1->B1_FILIAL
	#IFNDEF WINDOWS
		Inkey()
		If LastKey() == 286 //-- Alt+A
			lEnd := .T.
		EndIf
		IncProc(21,05)
	#ELSE
		IncProc('Corrigindo os Saldos Negativos...')
	#ENDIF
	If lEnd
		Exit
	EndIf	
	cCod      := B1_COD
	lRastro   := Rastro(B1_COD)
	lRastroS  := Rastro(B1_COD, 'S')
	lLocaliza := Localiza(B1_COD)
	If lRastro .Or. lLocaliza
		nSaldoSD5  := 0
		nSaldoSDB  := 0
		If lLocaliza
			dbSelectArea('SDB')
			If dbSeek(cSeekSDB:=xFilial('SDB')+cCod, .F.)
				aCriaSDB := {}
				Do While !Eof() .And. cSeekSDB==DB_FILIAL+DB_PRODUTO
					If !Empty(DB_ESTORNO)
						dbSkip()
						Loop
					EndIf
					cLocal     := DB_LOCAL
					cNumSeri   := DB_NUMSERI
					cLocaliz   := DB_LOCALIZ
					If lRastro
						cLoteCtl  := DB_LOTECTL
						cNumLote  := DB_NUMLOTE
						If Empty(cLoteCtl+cNumLote)
							dbSkip()
							Loop
						EndIf
					Else
						cLoteCtl := CriaVar('DB_LOTECTL')
						cNumLote := CriaVar('DB_NUMLOTE')
					EndIf	
					//-- Compoe o Saldo no SDB por Produto/Local/Lote/Sub-Lote/Num.Serie/Localiza‡Æo
					nSaldoSDB := 0
					Do While !Eof() .And. cSeekSDB+cLocal+cLoteCtl+cNumLote+cNumSeri+cLocaliz==DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_LOTECTL+DB_NUMLOTE+DB_NUMSERI+DB_LOCALIZA
						If !Empty(DB_ESTORNO)
							dbSkip()
							Loop
						EndIf
						If DB_TM <= '500'
							nSaldoSDB := nSaldoSDB+DB_QUANT
						Else
							nSaldoSDB := nSaldoSDB-DB_QUANT
						EndIf
						dbSkip()
					EndDo
					//-- Se o Saldo no SDB for Negativo Gera Movimenta‡Æo de Acerto
					If QtdComp(nSaldoSDB) < QtdComp(0)
						aAdd(aCriaSDB, {cCod,;
							cLocal,;
							Abs(QtdComp(nSaldoSDB)),;
							cLocaliz,;
							cNumSeri,;
							'ACERTO',;
							'UNI',;
							'',;
							'',;
							'',;
							'SDB',;
							dDataBase,;
							cLoteCtl,;
							cNumLote,;
							ProxNum(),;
							'499',;
							'M',;
							StrZero(1,Len(SDB->DB_ITEM)),;
							.F.,;
							0,;							
						0})
					EndIf
					dbSelectArea('SDB')
				EndDo
				For nX := 1 to Len(aCriaSDB)
					CriaSDB(aCriaSDB[nX,01],;
						aCriaSDB[nX,02],;
						aCriaSDB[nX,03],;
						aCriaSDB[nX,04],;
						aCriaSDB[nX,05],;
						aCriaSDB[nX,06],;
						aCriaSDB[nX,07],;
						aCriaSDB[nX,08],;
						aCriaSDB[nX,09],;
						aCriaSDB[nX,10],;
						aCriaSDB[nX,11],;
						aCriaSDB[nX,12],;
						aCriaSDB[nX,13],;
						aCriaSDB[nX,14],;
						aCriaSDB[nX,15],;
						aCriaSDB[nX,16],;
						aCriaSDB[nX,17],;
						aCriaSDB[nX,18],;
						aCriaSDB[nX,19],;
						aCriaSDB[nX,20],;							
					aCriaSDB[nX,21])
				Next nX
			EndIf
		EndIf
		If lRastro
			aGravaSD5 := {}
			dbSelectArea('SD5')
			If dbSeek(cSeekSD5:=xFilial('SD5')+cCod, .F.)
				Do While !Eof() .And. cSeekSD5 == D5_FILIAL+D5_PRODUTO
					If !Empty(D5_ESTORNO)
						dbSkip()
						Loop
					EndIf
					cLocal     := D5_LOCAL
					cLoteCtl   := D5_LOTECTL
					cNumLote   := D5_NUMLOTE
					If Empty(cLoteCtl+cNumLote)
						dbSkip()
						Loop
					EndIf
					//-- Compoe o Saldo no SD5 por Produto/Local/Lote/Sub-Lote
					nSaldoSD5  := 0
					Do While !Eof() .And. cSeekSD5+cLocal+cLoteCtl+cNumLote==D5_FILIAL+D5_PRODUTO+D5_LOCAL+D5_LOTECTL+D5_NUMLOTE
						If !Empty(D5_ESTORNO)
							dbSkip()
							Loop
						EndIf
						If D5_ORIGLAN <= '500' .Or. D5_ORIGLAN $'DEúPRúMAN'
							nSaldoSD5 := nSaldoSD5+D5_QUANT
						Else
							nSaldoSD5 := nSaldoSD5-D5_QUANT
						EndIf
						dbSkip()
					EndDo
					//-- Se o Saldo no SD5 for Negativo, ZERA o Saldo no SD5
					If QtdComp(nSaldoSD5) < QtdComp(0)
						aAdd(aGravaSD5, {'SD5',;
							cCod,;
							cLocal,;
							cLoteCtl,;
							cNumLote,;
							ProxNum(),;
							'ACERTO',;
							'UNI',;
							'',;
							'499',;
							'',;
							'',;
							'',;
							Abs(QtdComp(nSaldoSD5)),;
							ConvUm(cCod,Abs(QtdComp(nSaldoSD5)),0,2),;
							dDataBase,;
							dDataBase+SB1->B1_PRVALID})
					EndIf
					dbSelectArea('SD5')
				EndDo
			EndIf
			aAreaAnt := GetArea()
			For nX := 1 to Len(aGravaSD5)
				GravaSD5(aGravaSD5[nX,01],;
					aGravaSD5[nX,02],;
					aGravaSD5[nX,03],;
					aGravaSD5[nX,04],;
					If(!Empty(aGravaSD5[nX,05]),aGravaSD5[nX,05],NextLote(aGravaSD5[nX,02],"S")),;
					aGravaSD5[nX,06],;
					aGravaSD5[nX,07],;
					aGravaSD5[nX,08],;
					aGravaSD5[nX,09],;
					aGravaSD5[nX,10],;
					aGravaSD5[nX,11],;
					aGravaSD5[nX,12],;
					aGravaSD5[nX,13],;
					aGravaSD5[nX,14],;
					aGravaSD5[nX,15],;
					aGravaSD5[nX,16],;
					aGravaSD5[nX,17])
			Next nX
			RestArea(aAreaAnt)
		EndIf	
	EndIf	
	dbSelectArea('SB1')
	dbSkip()
EndDo

//-- Gera Movimenta‡äes no SD3 e SD5 para Corrigir Saldos Divergentes
dbSelectArea('SB1')
ProcRegua(RecCount(), 21, 05)
dbSetOrder(1)
dbGoTop()
Do While !lEnd .And. !Eof() .And. cFilSB1==SB1->B1_FILIAL
	#IFNDEF WINDOWS
		Inkey()
		If LastKey() == 286 //-- Alt+A
			lEnd := .T.
		EndIf
		IncProc(21,05)
	#ELSE
		IncProc('Corrigindo os Saldos Divergentes...')
	#ENDIF
	If lEnd
		Exit
	EndIf	
	cCod      := B1_COD
	lRastro   := Rastro(B1_COD)
	lRastroS  := Rastro(B1_COD, 'S')
	lLocaliza := Localiza(B1_COD)
	If lRastro .Or. lLocaliza
		//-- Verifica em quais Locais o Produto foi Movimentado
		aLocais := {}
		If SB1->B1_APROPRI=='I'
			aAdd(aLocais, GetMV('MV_LOCPROC'))
		EndIf
		dbSelectArea('SB9')
		If dbSeek(cSeekSB9:=xFilial('SB9')+cCod, .F.)
			Do While !Eof() .And. cSeekSB9==B9_FILIAL+B9_COD
				If aScan(aLocais, B9_LOCAL)==0
					aAdd(aLocais, B9_LOCAL)
				EndIf
				dbSkip()
			EndDo
		EndIf	
		dbSelectArea('SD1')
		If dbSeek(cSeekSD1:=xFilial('SD1')+cCod, .F.)
			Do While !Eof() .And. cSeekSD1==D1_FILIAL+D1_COD
				If aScan(aLocais, D1_LOCAL)==0
					aAdd(aLocais, D1_LOCAL)
				EndIf
				dbSkip()
			EndDo
		EndIf	
		dbSelectArea('SD2')
		If dbSeek(cSeekSD2:=xFilial('SD2')+cCod, .F.)
			Do While !Eof() .And. cSeekSD2==D2_FILIAL+D2_COD
				If aScan(aLocais, D2_LOCAL)==0
					aAdd(aLocais, D2_LOCAL)
				EndIf
				dbSkip()
			EndDo
		EndIf
		dbSelectArea('SD3')
		If dbSeek(cSeekSD3:=xFilial('SD3')+cCod, .F.)
			Do While !Eof() .And. cSeekSD3==D3_FILIAL+D3_COD
				If !Empty(D3_ESTORNO)
					dbSkip()
					Loop
				EndIf
				If aScan(aLocais, D3_LOCAL)==0
					aAdd(aLocais, D3_LOCAL)
				EndIf
				dbSkip()
			EndDo
		EndIf
		If lLocaliza
			dbSelectArea('SDA')
			If dbSeek(cSeekSDA:=xFilial('SDA')+cCod, .F.)
				Do While !Eof() .And. cSeekSDA==DA_FILIAL+DA_PRODUTO
					If aScan(aLocais, DA_LOCAL)==0
						aAdd(aLocais, DA_LOCAL)
					EndIf
					dbSkip()
				EndDo
			EndIf
			dbSelectArea('SDB')
			If dbSeek(cSeekSDB:=xFilial('SDB')+cCod, .F.)
				Do While !Eof() .And. cSeekSDB==DB_FILIAL+DB_PRODUTO
					If aScan(aLocais, DB_LOCAL)==0
						aAdd(aLocais, DB_LOCAL)
					EndIf
					dbSkip()
				EndDo
			EndIf
		EndIf	
		If lRastro
			dbSelectArea('SD5')
			If dbSeek(cSeekSD5:=xFilial('SD5')+cCod, .F.)
				Do While !Eof() .And. cSeekSD5 == D5_FILIAL+D5_PRODUTO
					If !Empty(D5_ESTORNO)
						dbSkip()
						Loop
					EndIf
					If aScan(aLocais, D5_LOCAL) == 0
						aAdd(aLocais, D5_LOCAL)
					EndIf
					dbSkip()
				EndDo
			EndIf			
		EndIf
		aSort(aLocais,,, {|x, y| x < y})
		
		For nX := 1 to Len(aLocais)
			cLocal     := aLocais[nX]
			aSaldo     := CalcEst(cCod, cLocal, CtoD('31/12/49'))
			nSaldo     := aSaldo[1]
			nSaldoSDBt := 0
			nSaldoSD5t := 0
			If lLocaliza
				dbSelectArea('SDB')
				If dbSeek(cSeekSDB:=xFilial('SDB')+cCod+cLocal, .F.)
					//-- Produto com Localiza‡Æo e Movimento no SDB
					aGravaSD5  := {}
					aLoteSLote := {}
					Do While !Eof() .And. cSeekSDB==DB_FILIAL+DB_PRODUTO+DB_LOCAL
						If !Empty(DB_ESTORNO)
							dbSkip()
							Loop
						EndIf
						If lRastro
							cLoteCtl  := DB_LOTECTL
							cNumLote  := DB_NUMLOTE
							If Empty(cLoteCtl+cNumLote)
								dbSkip()
								Loop
							EndIf
							If (aScan(aLoteSLote, {|x| x[1]==cLoteCtl.And.If(lRastroS,x[2]==cNumLote,.T.)}))==0
								aAdd(aLoteSLote, {cLoteCtl,cNumLote})
							EndIf
							//-- Compoe o Saldo no SDB por Produto/Local/Lote/Sub-Lote
							nSaldoSDB := 0
							Do While !Eof() .And. cSeekSDB+cLoteCtl+If(lRastroS,cNumLote,'')==DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_LOTECTL+If(lRastroS,DB_NUMLOTE,'')
								If !Empty(DB_ESTORNO)
									dbSkip()
									Loop
								EndIf
								If DB_TM <= '500'
									nSaldoSDB := nSaldoSDB+DB_QUANT
								Else
									nSaldoSDB := nSaldoSDB-DB_QUANT
								EndIf
								dbSkip()
							EndDo
							//-- Acrescenta ao Saldo no SDB o Saldo do SDA por Produto/Local/Lote/Sub-Lote
							dbSelectArea('SDA')
							If dbSeek(cSeekSDA:=xFilial('SDA')+cCod+cLocal+cLoteCtl+If(lRastroS,cNumLote,''), .F.)
								Do While !Eof() .And. cSeekSDA==DA_FILIAL+DA_PRODUTO+DA_LOCAL+DA_LOTECTL+If(lRastroS,DA_NUMLOTE,'')
									nSaldoSDB := nSaldoSDB+DA_SALDO							
									dbSkip()
								EndDo	
							EndIf
							nSaldoSDBt := nSaldoSDBt+nSaldoSDB
							//-- Compoe o Saldo no SD5 por Produto/Local/Lote/Sub-Lote
							aSLote    := {}
							nSaldoSD5 := 0
							dbSelectArea('SD5')
							If dbSeek(cSeekSD5:=xFilial('SD5')+cCod+cLocal+cLoteCtl+If(lRastroS,cNumLote,''), .F.)
								Do While !Eof() .And. cSeekSD5==D5_FILIAL+D5_PRODUTO+D5_LOCAl+D5_LOTECTL+If(lRastroS,D5_NUMLOTE,'')
									If !Empty(D5_ESTORNO)
										dbSkip()
										Loop
									EndIf
									If D5_ORIGLAN <= '500' .Or. D5_ORIGLAN $'DEúPRúMAN'
										nSaldoSD5 := nSaldoSD5+D5_QUANT
									Else
										nSaldoSD5 := nSaldoSD5-D5_QUANT
									EndIf
									If !lRastroS	
										aAdd(aSLote, {D5_NUMLOTE, If(D5_ORIGLAN<='500'.Or.D5_ORIGLAN $'DEúPRúMAN',D5_QUANT,0)})
									EndIf	
									dbSkip()
								EndDo							
							Endif
							//-- Corrige Divergˆncias no SD5 com base no SDB
							nDifSaldo := nSaldoSDB-nSaldoSD5
							If !QtdComp(nDifSaldo)==QtdComp(0)
								If QtdComp(nDifSaldo)<QtdComp(0) .And. Len(aSLote)>0
									//-- Escolhe um Sub-Lote para as Devolu‡äes
									nDifSaldo := Abs(nDifSaldo)
									For nY := 1 to Len(aSLote)
										If QtdComp(aSLote[nY, 2])>QtdComp(0)
											aAdd(aGravaSD5, {'SDB',;
												cCod,;
												cLocal,;
												cLoteCtl,;
												aSLote[nY, 1],;
												ProxNum(),;
												'ACERTO',;
												'UNI',;
												'',;
												'999',;
												'',;
												'',;
												'',;
												QtdComp(Min(nDifSaldo,aSLote[nY, 2])),;
												ConvUm(cCod,QtdComp(Min(nDifSaldo,aSLote[nY, 2])),0,2),;
												dDataBase,;
												dDataBase+SB1->B1_PRVALID})											
											nDifSaldo := nDifSaldo-aSLote[nY, 2]
											If QtdComp(nDifSaldo)<QtdComp(0)
												Exit
											EndIf
										EndIf										
									Next nY
									If QtdComp(nDifSaldo)>QtdComp(0)
										aAdd(aGravaSD5, {'SDB',;
											cCod,;
											cLocal,;
											cLoteCtl,;
											cNumLote,;
											ProxNum(),;
											'ACERTO',;
											'UNI',;
											'',;
											'999',;
											'',;
											'',;
											'',;
											QtdComp(nDifSaldo),;
											ConvUm(cCod,QtdComp(nDifSaldo),0,2),;
											dDataBase,;
											dDataBase+SB1->B1_PRVALID})											
									EndIf
								Else
									aAdd(aGravaSD5, {'SDB',;
										cCod,;
										cLocal,;
										cLoteCtl,;
										If(Len(aSLote)>0.And.Empty(cNumLote),aSLote[1,1],cNumLote),;
										ProxNum(),;
										'ACERTO',;
										'UNI',;
										'',;
										If(QtdComp(nDifSaldo)<QtdComp(0),'999','499'),;
										'',;
										'',;
										'',;
										Abs(QtdComp(nDifSaldo)),;
										ConvUm(cCod,Abs(QtdComp(nDifSaldo)),0,2),;
										dDataBase,;
										dDataBase+SB1->B1_PRVALID})
								EndIf										
							EndIf
						Else
							//-- Compoe o Saldo no SDB por Produto/Local
							nSaldoSDB := 0
							Do While !Eof() .And. cSeekSDB==DB_FILIAL+DB_PRODUTO+DB_LOCAL
								If !Empty(DB_ESTORNO)
									dbSkip()
									Loop
								EndIf
								If DB_TM <= '500'
									nSaldoSDBt := nSaldoSDBt+DB_QUANT
								Else
									nSaldoSDBt := nSaldoSDBt-DB_QUANT
								EndIf
								dbSkip()
							EndDo
							//-- Acrescenta ao Saldo no SDB o Saldo do SDA por Produto/Local
							dbSelectArea('SDA')
							If dbSeek(cSeekSDA:=xFilial('SDA')+cCod+cLocal, .F.)
								Do While !Eof() .And. cSeekSDA==DA_FILIAL+DA_PRODUTO+DA_LOCAL
									nSaldoSDBt := nSaldoSDBt+DA_SALDO							
									dbSkip()
								EndDo	
							EndIf
						EndIf	
						dbSelectArea('SDB')
					EndDo	
					aAreaAnt := GetArea()
					For nY := 1 to Len(aGravaSD5)
						GravaSD5(aGravaSD5[nY,01],;
							aGravaSD5[nY,02],;
							aGravaSD5[nY,03],;
							aGravaSD5[nY,04],;
							If(!Empty(aGravaSD5[ny,05]),aGravaSD5[ny,05],NextLote(aGravaSD5[ny,02],"S")),;
							aGravaSD5[nY,06],;
							aGravaSD5[nY,07],;
							aGravaSD5[nY,08],;
							aGravaSD5[nY,09],;
							aGravaSD5[nY,10],;
							aGravaSD5[nY,11],;
							aGravaSD5[nY,12],;
							aGravaSD5[nY,13],;
							aGravaSD5[nY,14],;
							aGravaSD5[nY,15],;
							aGravaSD5[nY,16],;
							aGravaSD5[nY,17])
					Next nY
					RestArea(aAreaAnt)
					//-- Procura por Lotes/SubLotes no SD5 nÆo registrados no SDB
					If lRastro .And. SD5->(dbSeek(cSeekSD5:=xFilial('SD5')+cCod+cLocal, .F.))
						aGravaSD5 := {}
						dbSelectArea('SD5')
						Do While !Eof() .And. cSeekSD5==D5_FILIAL+D5_PRODUTO+D5_LOCAL
							If !Empty(D5_ESTORNO)
								dbSkip()
								Loop
							EndIf
							cLoteCtl  := D5_LOTECTL
							cNumLote  := D5_NUMLOTE
							If Empty(cLoteCtl+cNumLote)
								dbSkip()
								Loop
							EndIf
							If !(aScan(aLoteSLote, {|x| x[1]==cLoteCtl.And.If(lRastroS,x[2]==cNumLote,.T.)}))==0
								dbSkip()
								Loop
							EndIf
							aSLote    := {}
							nSaldoSD5 := 0
							Do While !Eof() .And. cSeekSD5+cLoteCtl+If(lRastroS,cNumLote,'')==D5_FILIAL+D5_PRODUTO+D5_LOCAl+D5_LOTECTL+If(lRastroS,D5_NUMLOTE,'')
								If !Empty(D5_ESTORNO)
									dbSkip()
									Loop
								EndIf
								If D5_ORIGLAN <= '500' .Or. D5_ORIGLAN $'DEúPRúMAN'
									nSaldoSD5 := nSaldoSD5+D5_QUANT
								Else
									nSaldoSD5 := nSaldoSD5-D5_QUANT
								EndIf	
								If !lRastroS
									aAdd(aSLote, {D5_NUMLOTE, If(D5_ORIGLAN<='500'.Or.D5_ORIGLAN $'DEúPRúMAN',D5_QUANT,0)})
								EndIf	
								dbSkip()
							EndDo							
							//-- Acrescenta ao Saldo no SDB o Saldo do SDA por Produto/Local/Lote/SubLote
							nSaldoSDB := 0
							dbSelectArea('SDA')
							If dbSeek(cSeekSDA:=xFilial('SDA')+cCod+cLocal+cLoteCtl+If(lRastroS,cNumLote,''), .F.)
								Do While !Eof() .And. cSeekSDA==DA_FILIAL+DA_PRODUTO+DA_LOCAL+DA_LOTECTL+If(lRastroS,DA_NUMLOTE,'')
									nSaldoSDB := nSaldoSDB+DA_SALDO							
									dbSkip()
								EndDo	
							EndIf
							nSaldoSDBt := nSaldoSDBt+nSaldoSDB
							//-- Corrige Divergˆncias no SD5 com base no SDB
							nDifSaldo := nSaldoSDB-nSaldoSD5
							If !QtdComp(nDifSaldo)==QtdComp(0)
								If QtdComp(nDifSaldo)<QtdComp(0) .And. Len(aSLote)>0
									//-- Escolhe um Sub-Lote para as Devolu‡äes
									nDifSaldo := Abs(nDifSaldo)
									For nY := 1 to Len(aSLote)
										If QtdComp(aSLote[nY, 2])>QtdComp(0)
											aAdd(aGravaSD5, {'SDB',;
												cCod,;
												cLocal,;
												cLoteCtl,;
												aSLote[nY, 1],;
												ProxNum(),;
												'ACERTO',;
												'UNI',;
												'',;
												'999',;
												'',;
												'',;
												'',;
												QtdComp(Min(nDifSaldo,aSLote[nY, 2])),;
												ConvUm(cCod,QtdComp(Min(nDifSaldo,aSLote[nY, 2])),0,2),;
												dDataBase,;
												dDataBase+SB1->B1_PRVALID})											
											nDifSaldo := nDifSaldo-aSLote[nY, 2]
											If QtdComp(nDifSaldo)<QtdComp(0)
												Exit
											EndIf
										EndIf										
									Next nY
									If QtdComp(nDifSaldo)>QtdComp(0)
										aAdd(aGravaSD5, {'SDB',;
											cCod,;
											cLocal,;
											cLoteCtl,;
											cNumLote,;
											ProxNum(),;
											'ACERTO',;
											'UNI',;
											'',;
											'999',;
											'',;
											'',;
											'',;
											QtdComp(nDifSaldo),;
											ConvUm(cCod,QtdComp(nDifSaldo),0,2),;
											dDataBase,;
											dDataBase+SB1->B1_PRVALID})											
									EndIf
								Else
									aAdd(aGravaSD5, {'SDB',;
										cCod,;
										cLocal,;
										cLoteCtl,;
										If(Len(aSLote)>0.And.Empty(cNumLote),aSLote[1,1],cNumLote),;
										ProxNum(),;
										'ACERTO',;
										'UNI',;
										'',;
										If(QtdComp(nDifSaldo)<QtdComp(0),'999','499'),;
										'',;
										'',;
										'',;
										Abs(QtdComp(nDifSaldo)),;
										ConvUm(cCod,Abs(QtdComp(nDifSaldo)),0,2),;
										dDataBase,;
										dDataBase+SB1->B1_PRVALID})
								EndIf										
							EndIf
							dbSelectArea('SD5')
						EndDo
						aAreaAnt := GetArea()
						For nY := 1 to Len(aGravaSD5)
							GravaSD5(aGravaSD5[nY,01],;
								aGravaSD5[nY,02],;
								aGravaSD5[nY,03],;
								aGravaSD5[nY,04],;
								If(!Empty(aGravaSD5[ny,05]),aGravaSD5[ny,05],NextLote(aGravaSD5[ny,02],"S")),;
								aGravaSD5[nY,06],;
								aGravaSD5[nY,07],;
								aGravaSD5[nY,08],;
								aGravaSD5[nY,09],;
								aGravaSD5[nY,10],;
								aGravaSD5[nY,11],;
								aGravaSD5[nY,12],;
								aGravaSD5[nY,13],;
								aGravaSD5[nY,14],;
								aGravaSD5[nY,15],;
								aGravaSD5[nY,16],;
								aGravaSD5[nY,17])
						Next nY
						RestArea(aAreaAnt)
					EndIf
				ElseIf lRastro .And. SD5->(dbSeek(cSeekSD5:=xFilial('SD5')+cCod+cLocal, .F.))	
					//-- Produto com Localiza‡Æo e Sem Movimento no SDB
					aGravaSD5 := {}
					dbSelectArea('SD5')
					Do While !Eof() .And. cSeekSD5==D5_FILIAL+D5_PRODUTO+D5_LOCAL
						If !Empty(D5_ESTORNO)
							dbSkip()
							Loop
						EndIf
						cLoteCtl  := D5_LOTECTL
						cNumLote  := D5_NUMLOTE
						If Empty(cLoteCtl+cNumLote)
							dbSkip()
							Loop
						EndIf
						//-- Compoe o Saldo no SD5 por Produto/Local/Lote/Sub-Lote
						aSLote    := {}
						nSaldoSD5 := 0
						Do While !Eof() .And. cSeekSD5+cLoteCtl+If(lRastroS,cNumLote,'')==D5_FILIAL+D5_PRODUTO+D5_LOCAl+D5_LOTECTL+If(lRastroS,D5_NUMLOTE,'')
							If !Empty(D5_ESTORNO)
								dbSkip()
								Loop
							EndIf
							If D5_ORIGLAN <= '500' .Or. D5_ORIGLAN $'DEúPRúMAN'
								nSaldoSD5 := nSaldoSD5+D5_QUANT
							Else
								nSaldoSD5 := nSaldoSD5-D5_QUANT
							EndIf	
							If !lRastro	
								aAdd(aSLote, {D5_NUMLOTE, If(D5_ORIGLAN<='500'.Or.D5_ORIGLAN $'DEúPRúMAN',D5_QUANT,0)})
							EndIf	
							dbSkip()
						EndDo							
						//-- Acrescenta ao Saldo no SDB o Saldo do SDA por Produto/Local/Lote/SubLote
						nSaldoSDB := 0
						dbSelectArea('SDA')
						If dbSeek(cSeekSDA:=xFilial('SDA')+cCod+cLocal+cLoteCtl+If(lRastroS,cNumLote,''), .F.)
							Do While !Eof() .And. cSeekSDA==DA_FILIAL+DA_PRODUTO+DA_LOCAL+DA_LOTECTL+If(lRastroS,DA_NUMLOTE,'')
								nSaldoSDB := nSaldoSDB+DA_SALDO							
								dbSkip()
							EndDo	
						EndIf
						nSaldoSDBt := nSaldoSDBt+nSaldoSDB
						//-- Corrige Divergˆncias no SD5 com base no SDB
						nDifSaldo := nSaldoSDB-nSaldoSD5
						If !QtdComp(nDifSaldo)==QtdComp(0)
							If QtdComp(nDifSaldo)<QtdComp(0) .And. Len(aSLote)>0
								//-- Escolhe um Sub-Lote para as Devolu‡äes
								nDifSaldo := Abs(nDifSaldo)
								For nY := 1 to Len(aSLote)
									If QtdComp(aSLote[nY, 2])>QtdComp(0)
										nDifSaldo := nDifSaldo-aSLote[nY, 2]
										aAdd(aGravaSD5, {'SDB',;
											cCod,;
											cLocal,;
											cLoteCtl,;
											aSLote[nY, 1],;
											ProxNum(),;
											'ACERTO',;
											'UNI',;
											'',;
											'999',;
											'',;
											'',;
											'',;
											QtdComp(Min(nDifSaldo,aSLote[nY, 2])),;
											ConvUm(cCod,QtdComp(Min(nDifSaldo,aSLote[nY, 2])),0,2),;
											dDataBase,;
											dDataBase+SB1->B1_PRVALID})											
										nDifSaldo := nDifSaldo-aSLote[nY, 2]
										If QtdComp(nDifSaldo)<QtdComp(0)
											Exit
										EndIf
									EndIf										
								Next nY
								If QtdComp(nDifSaldo)>QtdComp(0)
									aAdd(aGravaSD5, {'SDB',;
										cCod,;
										cLocal,;
										cLoteCtl,;
										cNumLote,;
										ProxNum(),;
										'ACERTO',;
										'UNI',;
										'',;
										'999',;
										'',;
										'',;
										'',;
										QtdComp(nDifSaldo),;
										ConvUm(cCod,QtdComp(nDifSaldo),0,2),;
										dDataBase,;
										dDataBase+SB1->B1_PRVALID})											
								EndIf
							Else
								aAdd(aGravaSD5, {'SDB',;
									cCod,;
									cLocal,;
									cLoteCtl,;
									If(Len(aSLote)>0.And.Empty(cNumLote),aSLote[1,1],cNumLote),;
									ProxNum(),;
									'ACERTO',;
									'UNI',;
									'',;
									If(QtdComp(nDifSaldo)<QtdComp(0),'999','499'),;
									'',;
									'',;
									'',;
									Abs(QtdComp(nDifSaldo)),;
									ConvUm(cCod,Abs(QtdComp(nDifSaldo)),0,2),;
									dDataBase,;
									dDataBase+SB1->B1_PRVALID})
							EndIf										
						EndIf
						dbSelectArea('SD5')
					EndDo
					aAreaAnt := GetArea()
					For nY := 1 to Len(aGravaSD5)
						GravaSD5(aGravaSD5[nY,01],;
							aGravaSD5[nY,02],;
							aGravaSD5[nY,03],;
							aGravaSD5[nY,04],;
							If(!Empty(aGravaSD5[ny,05]),aGravaSD5[ny,05],NextLote(aGravaSD5[ny,02],"S")),;
							aGravaSD5[nY,06],;
							aGravaSD5[nY,07],;
							aGravaSD5[nY,08],;
							aGravaSD5[nY,09],;
							aGravaSD5[nY,10],;
							aGravaSD5[nY,11],;
							aGravaSD5[nY,12],;
							aGravaSD5[nY,13],;
							aGravaSD5[nY,14],;
							aGravaSD5[nY,15],;
							aGravaSD5[nY,16],;
							aGravaSD5[nY,17])
					Next nY
					RestArea(aAreaAnt)
				Else
					//-- Produto com Localiza‡Æo e Sem Movimento nos SDB e SD5
					dbSelectArea('SDA')
					If dbSeek(cSeekSDA:=xFilial('SDA')+cCod+cLocal, .F.)
						Do While !Eof() .And. cSeekSDA==DA_FILIAL+DA_PRODUTO+DA_LOCAL
							nSaldoSDBt := nSaldoSDBt+DA_SALDO							
							dbSkip()
						EndDo
					EndIf	
				EndIf
				//-- Casos onde Existam Movimentacoes no SD5 ou SDB, mas estao todas Estornadas
				If QtdComp(nSaldoSDBt)==QtdComp(0)
					dbSelectArea('SDA')
					If dbSeek(cSeekSDA:=xFilial('SDA')+cCod+cLocal, .F.)
						Do While !Eof() .And. cSeekSDA==DA_FILIAL+DA_PRODUTO+DA_LOCAL
							nSaldoSDBt := nSaldoSDBt+DA_SALDO							
							dbSkip()
						EndDo
					EndIf	
				EndIf
			Else
				//-- Compoe o Saldo no SD5 por Produto/Local
				dbSelectArea('SD5')
				If dbSeek(cSeekSD5:=xFilial('SD5')+cCod+cLocal, .F.)
					Do While !Eof() .And. cSeekSD5 == D5_FILIAL+D5_PRODUTO+D5_LOCAL
						If !Empty(D5_ESTORNO)
							dbSkip()
							Loop
						EndIf
						If D5_ORIGLAN <= '500' .Or. D5_ORIGLAN $'DEúPRúMAN'
							nSaldoSD5t := nSaldoSD5t+D5_QUANT
						Else
							nSaldoSD5t := nSaldoSD5t-D5_QUANT
						EndIf
						dbSkip()
					EndDo	
				EndIf
			EndIf	
			//-- Corrige Divergˆncias no SD3 com base no SDB ou SD5
			nDifSaldo := If(lLocaliza,nSaldoSDBt,nSaldoSD5t)-nSaldo
			If !QtdComp(nDifSaldo)==QtdComp(0)
				RecLock('SD3',.T.)
				Replace D3_FILIAL  With xFilial('SD3')
				Replace D3_COD     With cCod
				Replace D3_QUANT   With Abs(QtdComp(nDifSaldo))
				Replace D3_CF      With If(QtdComp(nDifSaldo)<QtdComp(0),'RE0','DE0')
				Replace D3_CHAVE   With If(QtdComp(nDifSaldo)<QtdComp(0),'E0','E9')
				Replace D3_LOCAL   With cLocal
				Replace D3_DOC     With 'ACERTO'
				Replace D3_EMISSAO With dDataBase
				Replace D3_UM      With SB1->B1_UM
				Replace D3_GRUPO   With SB1->B1_GRUPO
				Replace D3_NUMSEQ  With ProxNum()
				Replace D3_QTSEGUM With ConvUm(cCod,Abs(QtdComp(nDifSaldo)),0,2)
				Replace D3_SEGUM   With SB1->B1_SEGUM
				Replace D3_TM      With If(QtdComp(nDifSaldo)<QtdComp(0),'999','499')
				Replace D3_TIPO    With SB1->B1_TIPO
				Replace D3_CONTA   With SB1->B1_CONTA
				Replace D3_USUARIO With SubStr(cUsuario,7,15)
				Replace D3_NUMLOTE With ''
				Replace D3_LOTECTL With ''
				Replace D3_LOCALIZ With ''
				Replace D3_IDENT   With ''
				Replace D3_DTVALID With CtoD('  /  /  ')
				MsUnLock()
			EndIf
		Next nX
	EndIf	
	dbSelectArea('SB1')	
	dbSkip()
EndDo		

If lEnd
	Aviso('ACESALDO','A Rotina de Acerto das Diferencas nos Saldos foi Interrompida!',{'Ok'})
Else
	Aviso('ACESALDO','Rotina de Acerto das Diferencas nos Saldos Concluida',{'Ok'})
	If Aviso('ACESALDO','Sera NECESSARIO executar as Rotinas de "Acerto de Saldos" e "Refaz Acumulados" . Deseja executa-las agora?',{'Sim','Nao'})==1
		MATA300()
		MATA215()
	EndIf
EndIf	

fErase(cArqSDA+OrdBagExt())

Return Nil

