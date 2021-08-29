#include "rwmake.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "Protheus.ch"


User function TSTCALC()

//-- Executa a rotina de recï¿½lculo do custo mï¿½dio

//Alert(_SetNamedPrvt)

//Alert(cFunname)

//Public cFunname := "MATA331"

	cRpcEmp    := "01"            // Código da empresa.
	cRpcFil    := "01"            // Código da filial.
	cEnvUser   := "Admin"         // Nome do usuário.
	cEnvPass   := "OpusDomex"     // Senha do usuário.
	cEnvMod    := "EST"           // 'FAT'  // Código do módulo.
	cFunName   := "MATA331"       // 'RPC'  // Nome da rotina que será setada para retorno da função FunName().
	aTables    := {}              // {}     // Array contendo as tabelas a serem abertas.
	lShowFinal := .F.             // .F.    // Alimenta a variável publica lMsFinalAuto.
	lAbend     := .T.             // .T.    // Se .T., gera mensagem de erro ao ocorrer erro ao checar a licença para a estação.
	lOpenSX    := .T.             // .T.    // SE .T. pega a primeira filial do arquivo SM0 quando não passar a filial e realiza a abertura dos SXs.
	lConnect   := .T.             // .T.    // Se .T., faz a abertura da conexao com servidor As400, SQL Server etc

//RPCSetType(3)
	RpcSetEnv(cRpcEmp,cRpcFil,cEnvUser,cEnvPass,cEnvMod,cFunName,aTables,lShowFinal,lAbend,lOpenSX,lConnect) //PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"

	cInternBkp := __cInternet
	__cInternet := Nil
	
	MATA331()

//_SetNamedPrvt : owner private environment not found on CTBINILAN(CTBA105.PRW) 

//ConOut("Tï¿½rmino da execuï¿½ï¿½o do JOBM331")        

//Local aSaldoEst := {}

//Prepare Environment Empresa '01' filial '01'


//aSaldoEst :=  CalcEst('DMXFLMD73L5250 ', '13', DDATABASE ) //U_DCalcEst('DMXFLMD73L5250 ', '13', DDATABASE )
//conout(len(aSaldoEst))

//Reset Environment

//MATA331(.f.)

RETURN



User Function DCalcEst(cCod,cLocal,dData,cFilAux,lConsTesTerc,lCusRep)

//Local cxFilial       := ""
//Local cProcNam       := GetSPName("MAT006","14")
//Local lD3Servico     := SuperGetMV('MV_D3SERVI', .F.,'N')=='S'
//Local lMATA103       := IsInCallStack("MATA103")
	Default lConsTesTerc := .F.
	Default dData        := dDataBase
	dData	 := If(Empty(dData),Ctod( "01/01/80","ddmmyy" ),dData)
/*
	If ( TcSrvType() <> "AS/400" ) .And. !lMATA103  //VerIDProc()
	aResult := {}
	aResult := TCSPExec( xProcedures(cProcNam),	cCod,;											// 01. Codigo do Produto	
												cLocal,;										// 02. Codigo do Armazem
												DTOS(dData),;									// 03. Data de Processamento
		If(cFilAux=nil,Subst("-@@-",2,2),cFilAux),;  	// 04. Colocado os tracos antes e depois do @@ para nao ocorrer erro no geracao de ch
												GetMv("MV_LOCPROC"),;							// 05. Armazem de Processo
												cFilAnt,;										// 06. Codigo da Filial
			If(lD3Servico,'1','0'),;						// 07. Considera o parametro MV_D3SERVI
				If(IntDL(cCod),'1','0'),;						// 08. Verifica a integracao com WMS
												SuperGetMv("MV_CQ",.F.,"98"))					// 09. Armazem de CQ
					If aResult == Nil
		//Final(STR0091) //"RE-INSTALAR AS STORED PROCEDURES"
					EndIf
	Return (aResult)
				Elseif ExistProc( cProcNam, VerIDProc()) .and. ( TcSrvType() == "AS/400" ) .And. !lMATA103
	cxFilial := BuildStrFil("SD1,SD2,SD3,SF4,SB9,SF5")	
	aResult  := {}
	aResult  := TCSPExec( xProcedures(cProcNam), cxFilial, cCod, cLocal,;
	DTOS(dData), If(cFilAux=nil,"@@",cFilAux),;
	GetMv("MV_LOCPROC"), cFilAnt,;
	Substr(cUsuario,7,15), DTOS(dDataBase))
	Return (aResult)
				Else */
	Return U_zCalcEst(@cCod,@cLocal,@dData,@cFilAux,lConsTesTerc,lCusRep)
//EndIf



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ xCalcEst ³ Autor ³ Wilson Junior         ³ Data ³ 28.03.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna o Saldo inicial por Produto/Local do arquivo SB9 - ³±±
±±³          ³ Saldos Iniciais.                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpA1 := CalcEst(ExpC1,ExpC2,ExpD1)                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array com o Saldo Inicial para o Produto/Local.    ³±±
±±³          ³ ExpC1 = Codigo do Produto                                  ³±±
±±³          ³ ExpC2 = Local (AlmoxarIfado)                               ³±±
±±³          ³ ExpD1 = Data para obter o Saldo Inicial.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGACUS                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function zCalcEst(cCod,cLocal,dData,cFilAux,lConsTesTerc,lCusRep)

#define F_SB9  1
#define F_SD1  2
#define F_SD2  3
#define F_SD3  4
#define F_SF4  5
#define F_SF5  6

Local nReg,nReg1,nOrd,nOrd1,dDtVai
Local lHasRec := .F.
Local aSaldo     := { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
Local cLocProc   := GETMV("MV_LOCPROC")
Local cArq       := Alias()
//Local nCnt01     := 0

Local aFilial  := { xFilial( "SB9" ),;
                    xFilial( "SD1" ),;
                    xFilial( "SD2" ),;
                    xFilial( "SD3" ),;
                    xFilial( "SF4" ),;
                    xFilial( "SF5" ) }

Local lRemInt  := SuperGetMv("MV_REMINT",.F.,.F.)
//Local nSizeFil := 2 
Local lUsaD2DIG  := UsaD2DTDIG()
Local cFiltroSF5 :=	SF5->(DbFilter())

DEFAULT lConsTesTerc := .F.
DEFAULT lCusRep      := .F.
DEFAULT dData        := dDataBase
SF5->(DBClearFilter())

dData	 := If(Empty(dData),Ctod( "01/01/80","ddmmyy" ),dData)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de partida para compor o saldo inicial.        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea( "SB9" )

DbSeek(aFilial[ 1 ]+cCod+cLocal)
lHasRec := .f.
	While !Eof() .and. (aFilial[ 1 ]+cCod+cLocal == B9_FILIAL + B9_COD+B9_Local)
		If B9_DATA >= dData .and. lHasRec
		Exit
		Else
		lHasRec := .t.
		EndIf

	DbSkip()
	End
	If lHasRec
	DbSkip(-1)
	EndIf


	If ((aFilial[ 1 ]+cCod+cLocal == SB9->B9_FILIAL+SB9->B9_COD+SB9->B9_Local) .And. (SB9->B9_DATA < dData))

	aSaldo[01] := SB9->B9_QINI
	aSaldo[02] := SB9->B9_VINI1
	aSaldo[03] := SB9->B9_VINI2
	aSaldo[04] := SB9->B9_VINI3
	aSaldo[05] := SB9->B9_VINI4
	aSaldo[06] := SB9->B9_VINI5
	aSaldo[07] := SB9->B9_QISEGUM
	aSaldo[08] := SB9->B9_CM1
	aSaldo[09] := SB9->B9_CM2
	aSaldo[10] := SB9->B9_CM3
	aSaldo[11] := SB9->B9_CM4
	aSaldo[12] := SB9->B9_CM5

		If lCusRep
		aSaldo[13] := SB9->B9_CMRP1
		aSaldo[14] := SB9->B9_CMRP2
		aSaldo[15] := SB9->B9_CMRP3
		aSaldo[16] := SB9->B9_CMRP4
		aSaldo[17] := SB9->B9_CMRP5
		aSaldo[18] := SB9->B9_VINIRP1
		aSaldo[19] := SB9->B9_VINIRP2
		aSaldo[20] := SB9->B9_VINIRP3
		aSaldo[21] := SB9->B9_VINIRP4
		aSaldo[22] := SB9->B9_VINIRP5
		EndIf
	dDtVai    := SB9->B9_DATA+1
	Else
	dDtVai    := Ctod( "01/01/80","ddmmyy" )
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Correr SD1, SD2 e SD3 para  obter o saldo na Data desejada. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea( "SF4" )
nReg1 := Recno()
nOrd1 := Indexord()

DbSelectArea( "SD1" )
nReg := Recno()
nOrd := IndexOrd()
DbSetOrder( 7 )

DbSeek( aFilial[ F_SD1 ]+cCod+cLocal+Dtos(dDtVai),.T. )

	While (!Eof() .And. ;
	(aFilial[ F_SD1 ]+cCod+cLocal) == (SD1->D1_FILIAL+SD1->D1_COD+SD1->D1_Local) .And.;
	(SD1->D1_DTDIGIT < dData))

			#ifdef SHELL
			If SD1->D1_CANCEL == "S"
			SD1->(DbSkip())
			Loop
			EndIf
		#endif

		If cPaisLoc != "BRA"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Desconsiderar notas de remito e notas geradas pelo EIC       ³
		//| com excecao da nota de FOB.									 |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(SD1->D1_REMITO) .Or. SD1->D1_TIPO_NF $ '6789AB'
			SD1->(DbSkip())
			Loop
			EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Desconsiderar notas de entrada tipo 10 quando o cliente uti_ |
		//| lizar o conceito de remito interno com importacao (SIGAEIC)  |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lRemInt
				If !Empty(SD1->D1_CONHEC) .And. SD1->D1_TIPO_NF $ '5' .And. SD1->D1_TIPODOC $ '10'
				SD1->(DbSkip())
				Loop
				EndIf
			EndIf

		EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Somente Notas Fiscais Nao Lancadas No Modulo do Livro Fiscal ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !(SD1->D1_ORIGLAN == "LF")
		DbSelectArea( "SF4" )
//		If ((SF4->F4_FILIAL+SF4->F4_CODIGO == aFilial[ F_SF4 ]+SD1->D1_TES ) .Or. ;
//			DbSeek( aFilial[ F_SF4 ]+SD1->D1_TES,.F. ))
			If (iif (FWModeAccess("SF4") == "E",(SF4->F4_FILIAL+SF4->F4_CODIGO == aFilial[ F_SF4 ]+SD1->D1_TES ), ;
				(SF4->F4_FILIAL+SF4->F4_CODIGO == substr(aFilial[ 4 ],1,len(SF4->F4_FILIAL)-len(FWFilial("SF4")))+FWFilial("SF4")+SD1->D1_TES)).Or. ;
			DbSeek( aFilial[ F_SF4 ]+SD1->D1_TES,.F. ))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Somente TES Que Movimenta Estoque Deve Ser Considerada ³
			//³ ou TES de poder de terceiros com parametro ligado      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If (SF4->F4_ESTOQUE == "S") .Or. (lConsTesTerc .And. SF4->F4_PODER3 $ "RD")
				aSaldo[1] += SD1->D1_QUANT
				aSaldo[2] += SD1->D1_CUSTO
				aSaldo[3] += SD1->D1_CUSTO2
				aSaldo[4] += SD1->D1_CUSTO3
				aSaldo[5] += SD1->D1_CUSTO4
				aSaldo[6] += SD1->D1_CUSTO5
				aSaldo[7] += SD1->D1_QTSEGUM
					If lCusRep
					aSaldo[18] += SD1->D1_CUSRP1
					aSaldo[19] += SD1->D1_CUSRP2
					aSaldo[20] += SD1->D1_CUSRP3
					aSaldo[21] += SD1->D1_CUSRP4
					aSaldo[22] += SD1->D1_CUSRP5
					EndIf
				EndIf
			EndIf
		DbSelectArea( "SD1" )
		EndIf
	DbSkip(1)
	End

DbSetOrder( nOrd ) ; DbGoTo( nReg )

DbSelectArea( "SD2" )
nReg := Recno()
nOrd := IndexOrd()
// Verifica se usa o campo D2_DTDIGIT ou nao, de acordo com a funcao UsaD2DTDIG
DbSetOrder( IIf(lUsaD2DIG, 11, 6) )

DbSeek( aFilial[ F_SD2 ]+cCod+cLocal+DtoS( dDtVai ),.T. )

	While (!Eof() .And. ;
	(aFilial[ F_SD2 ]+cCod+cLocal == SD2->D2_FILIAL+SD2->D2_COD+SD2->D2_Local) .And. ;
	IIf(lUsaD2DIG, (SD2->D2_DTDIGIT < dData), (SD2->D2_EMISSAO < dData)) )

			#ifdef SHELL
			If SD2->D2_CANCEL == "S"
			SD2->(DbSkip())
			Loop
			EndIf
		#endif

		If !Empty(SD2->D2_REMITO) .And. !(SD2->D2_TPDCENV $ "A1")
		SD2->(DbSkip())
		Loop
		EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Despreza Notas Fiscais Lancadas Pelo Modulo do Livro Fiscal  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !(SD2->D2_ORIGLAN == "LF")
		DbSelectArea("SF4")
			If ((SF4->F4_FILIAL+SF4->F4_CODIGO == aFilial[ F_SF4 ]+SD2->D2_TES ) .Or. ;
			DbSeek( aFilial[ F_SF4 ]+SD2->D2_TES,.F. ))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Somente TES Que Movimenta Estoque Deve Ser Considerada ³
			//³ ou TES de poder de terceiros com parametro ligado      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If (SF4->F4_ESTOQUE == "S") .Or. (lConsTesTerc .And. SF4->F4_PODER3 $ "RD")
				aSaldo[1] -= SD2->D2_QUANT
				aSaldo[2] -= SD2->D2_CUSTO1
				aSaldo[3] -= SD2->D2_CUSTO2
				aSaldo[4] -= SD2->D2_CUSTO3
				aSaldo[5] -= SD2->D2_CUSTO4
				aSaldo[6] -= SD2->D2_CUSTO5
				aSaldo[7] -= SD2->D2_QTSEGUM
					If lCusRep
					aSaldo[18] -= SD2->D2_CUSRP1
					aSaldo[19] -= SD2->D2_CUSRP2
					aSaldo[20] -= SD2->D2_CUSRP3
					aSaldo[21] -= SD2->D2_CUSRP4
					aSaldo[22] -= SD2->D2_CUSRP5
					EndIf
				EndIf
			EndIf
		DbSelectArea( "SD2" )
		EndIf
	DbSkip(1)
	End

DbSetOrder( nOrd ) ; DbGoTo( nReg )


DbSetOrder( nOrd ) ; DbGoTo( nReg )

DbSelectArea( "SF4" )
DbSetOrder( nOrd1 ) ; DbGoTo( nReg1 )

DbSelectArea( "SF5" )
nReg1 := Recno()
nOrd1 := IndexOrd()

DbSelectArea( "SD3" )
nReg := Recno()
nOrd := IndexOrd()
DbSetOrder( 7 )

DbSeek( aFilial[ F_SD3 ]+cCod+cLocal+DtoS( dDtVai ),.T. )

	While (!Eof() .And. ;
	(aFilial[ F_SD3 ]+cCod+cLocal == SD3->D3_FILIAL+SD3->D3_COD+SD3->D3_Local) .And. ;
	(SD3->D3_EMISSAO < dData))
			If !D3Valido()
		DbSkip()
		Loop
		EndIf
	DbSelectArea( "SF5" )
		If ((SF5->F5_FILIAL+SF5->F5_CODIGO == aFilial[ F_SF5 ]+SD3->D3_TM) .Or. ;
		(SD3->D3_TM == "499") .Or. ;
		(SD3->D3_TM == "999") .Or. ;
		DbSeek( aFilial[ F_SF5 ]+SD3->D3_TM,.F. ))
				If SD3->D3_TM >"500"
			aSaldo[1] -= SD3->D3_QUANT
			aSaldo[2] -= SD3->D3_CUSTO1
			aSaldo[3] -= SD3->D3_CUSTO2
			aSaldo[4] -= SD3->D3_CUSTO3
			aSaldo[5] -= SD3->D3_CUSTO4
			aSaldo[6] -= SD3->D3_CUSTO5
			aSaldo[7] -= SD3->D3_QTSEGUM
				If lCusRep
				aSaldo[18] -= SD3->D3_CUSRP1
				aSaldo[19] -= SD3->D3_CUSRP2
				aSaldo[20] -= SD3->D3_CUSRP3
				aSaldo[21] -= SD3->D3_CUSRP4
				aSaldo[22] -= SD3->D3_CUSRP5
				EndIf
			Else
			aSaldo[1] += SD3->D3_QUANT
			aSaldo[2] += SD3->D3_CUSTO1
			aSaldo[3] += SD3->D3_CUSTO2
			aSaldo[4] += SD3->D3_CUSTO3
			aSaldo[5] += SD3->D3_CUSTO4
			aSaldo[6] += SD3->D3_CUSTO5
			aSaldo[7] += SD3->D3_QTSEGUM
				If lCusRep
				aSaldo[18] += SD3->D3_CUSRP1
				aSaldo[19] += SD3->D3_CUSRP2
				aSaldo[20] += SD3->D3_CUSRP3
				aSaldo[21] += SD3->D3_CUSRP4
				aSaldo[22] += SD3->D3_CUSRP5
				EndIf
			EndIf
		EndIf
	DbSelectArea( "SD3" ) ; DbSkip(1)
	End

	If AllTrim(cLocal) == AllTrim(cLocProc)

	DbSetOrder( 7 )

	DbSeek( aFilial[ F_SD3 ]+cCod,.T. )

		While (!Eof() .And. ;
		(aFilial[ F_SD3 ]+cCod == SD3->D3_FILIAL+SD3->D3_COD))
		
				If SD3->D3_EMISSAO >= dData
			SD3->(dbSkip())
			Loop
			EndIf

			While (!Eof() .And. ;
			(aFilial[ F_SD3 ]+cCod == SD3->D3_FILIAL+SD3->D3_COD) .And. ;
			(SD3->D3_EMISSAO < dData))
	
					If ((SD3->D3_EMISSAO <  dData)      .And. ;
				(SD3->D3_EMISSAO >= dDtVai)     .And. ;
				(SubS( SD3->D3_CF,2 ) == "E3")  .And. ;
				!(alltrim(SD3->D3_Local) == alltrim(cLocProc)))
	
						If !D3Valido()
					DbSkip()
					Loop
					EndIf
				
				DbSelectArea( "SF5" )
					If ((SF5->F5_FILIAL+SF5->F5_CODIGO == aFilial[ F_SF5 ]+SD3->D3_TM) .Or. ;
					(SD3->D3_TM == "499") .Or. ;
					(SD3->D3_TM == "999") .Or. ;
					DbSeek( aFilial[ F_SF5 ]+SD3->D3_TM,.F. ))
	
							If SD3->D3_CF = "RE3"
	
						aSaldo[1] += SD3->D3_QUANT
						aSaldo[2] += SD3->D3_CUSTO1
						aSaldo[3] += SD3->D3_CUSTO2
						aSaldo[4] += SD3->D3_CUSTO3
						aSaldo[5] += SD3->D3_CUSTO4
						aSaldo[6] += SD3->D3_CUSTO5
						aSaldo[7] += SD3->D3_QTSEGUM
							If lCusRep
							aSaldo[18] += SD3->D3_CUSRP1
							aSaldo[19] += SD3->D3_CUSRP2
							aSaldo[20] += SD3->D3_CUSRP3
							aSaldo[21] += SD3->D3_CUSRP4
							aSaldo[22] += SD3->D3_CUSRP5
							EndIf
						ElseIf SD3->D3_CF = "DE3"
						aSaldo[1] -= SD3->D3_QUANT
						aSaldo[2] -= SD3->D3_CUSTO1
						aSaldo[3] -= SD3->D3_CUSTO2
						aSaldo[4] -= SD3->D3_CUSTO3
						aSaldo[5] -= SD3->D3_CUSTO4
						aSaldo[6] -= SD3->D3_CUSTO5
						aSaldo[7] -= SD3->D3_QTSEGUM
							If lCusRep
							aSaldo[18] -= SD3->D3_CUSRP1
							aSaldo[19] -= SD3->D3_CUSRP2
							aSaldo[20] -= SD3->D3_CUSRP3
							aSaldo[21] -= SD3->D3_CUSRP4
							aSaldo[22] -= SD3->D3_CUSRP5
							EndIf
						EndIf
					EndIf
				EndIf
	
			DbSelectArea("SD3")
			DbSkip()
			End
		End
	EndIf

DbSetOrder( nOrd ) ; DbGoTo( nReg )


DbSelectArea("SF5")
DbSetOrder( nOrd1 ) ; DbGoTo( nReg1 )  
	If !Empty (cFiltroSF5)
	dbSetFilter({||&cFiltroSF5},cFiltroSF5)
	EndIf

DbSelectArea( cArq )

Return( aSaldo )
