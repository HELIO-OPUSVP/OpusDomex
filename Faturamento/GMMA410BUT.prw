#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGMMA410BUTบAutor  ณMichel Sander       บ Data ณ  01/26/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de Entrada para adicionar bot๕es na Enchoicebar      บฑฑ
ฑฑบ          ณ do pedido de vendas                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function teste02()
	RpcSetEnv("01","01")
	__cInterNet := 'AUTOMATICO'

	cTipo   :=         "*.CSV           | *.CSV |   "
	Arquivo := cGetFile(cTipo, "Sele็ใo de Arquivo",,"C:\",.T.,,.t.,.t.)
	Arquivo := Alltrim(Arquivo)
	Processa({|| Incitens(Arquivo)},"Processando Arquivo..." + Arquivo) //IncItens()

Return

User Function GMMA410BUT()
//Local nLAutoAdt := 0
	Local nOpc      := Paramixb[1]

	aButCustom := {}
	Aadd(aButCustom , {'AREA_MDI' ,{|| U_RFATA02() }	,"Previsใo de Faturamento"				,"Prev. Fat."    				} )
	Aadd(aButCustom , {'AREA_MDI' ,{|| U_RFATA03("V") }	,"Importa็ใo Planilha"    				,"Importar Itens"				} )
	Aadd(aButCustom , {'AREA_MDI' ,{|| U_IMPZZU() }		,"Importa็ใo Etiqueta Amazon"        	    ,"Importar Etq.Amazon"} )
	Aadd(aButCustom , {'AREA_MDI' ,{|| U_DOMIMPOF() }	,"Impressao de OF"    					,"Impressao de OF"			} )
//Aadd(aButCustom , {'AREA_MDI' ,{|| U_RFATA03("V") },"Importa็ใo Planilha Validacao"         ,"Importar Itens Validacao"} )

//aRecnoSE1 := FPedAdtPed( "R", {M->C5_NUM},,nLAutoAdt )
//If (nOpc == 3 .OR. nOpc == 4 .OR. nOpc == 6 .OR. lBxOrcam) .And. (Empty(M->C5_NOTA))
	If (nOpc == 3 .OR. nOpc == 4 .OR. nOpc == 6 ) .And. (Empty(M->C5_NOTA))
		//aAdd(aButtons,{"FINIMG32",{|| A410Adiant(M->C5_NUM, M->C5_CONDPAG, 0/*nTotalPed*/      , @aRecnoSE1, , M->C5_CLIENTE, M->C5_LOJACLI,,Nil,Nil,@cCondPAdt,,,,M->C5_MOEDA)},STR0123,STR0124}) //"Recebimento antecipado"##"Adiantamento"
//	aAdd(aButCustom,{"FINIMG32",{|| A410Adiant(M->C5_NUM, M->C5_CONDPAG, 2000000/*nTotalPed*/, @aRecnoSE1, , M->C5_CLIENTE, M->C5_LOJACLI,,Nil,Nil,'1'                      )},"Recebimento antecipado NOVO","Adiantamento NOVO"}) //"Recebimento antecipado"##"Adiantamento"

	Else
		//aAdd(aButtons,{"FINIMG32",{|| FPDxADTREL("R", M->C5_NUM, 0, @aRecnoSE1, M->C5_CLIENTE, M->C5_LOJACLI, .T.,,,M->C5_MOEDA)},STR0123,STR0124}) //"Recebimento antecipado"##"Adiantamento"
//	aAdd(aButCustom,{"FINIMG32",{|| FPDxADTREL("R", M->C5_NUM, 3000000, {}, M->C5_CLIENTE, M->C5_LOJACLI, .T.)},"Recebimento antecipado NOVO","Adiantamento NOVO"}) //"Recebimento antecipado"##"Adiantamento"
	EndIf

Return ( aButCustom )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบPrograma  ณIMPZZU	บAutor  ณRicardo Roda        บ Data ณ  11/06/21   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Importa็ใo de planilha para etiqueta da Amazom 		      บฑฑ
ฑฑบ          ณ na rotina de pedido de vendas 				              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function IMPZZU()

	Local nOpc    := 1
	Local cTipo   := "*.TXT           | *.TXT |   "
	Local Arquivo := ""
	Private oCheckBox1
	Private lCheckBox1 := .F.
	Private cMsn    := " Esta rotina faz importa็ใo da planilha de etiquetas Amazon em formato CSV."+Chr(13)+Chr(10)
	cMsn    += " IMPORTANTE: Ap๓s a importa็ใo percorra todos as linhas para evitar problemas ao salvar."+Chr(13)+Chr(10)
	cMsn    += Chr(13)+Chr(10)
	cMsn    += " ESTRUTURA DO ARQUIVO: LABEL1; LABEL2; LABEL3; LABEL4; LABEL5; LABEL6; "
	cMsn    += Chr(13)+Chr(10)
	cMsn    += "CABLING NOTES; ITEM"
	cMsn    += Chr(13)+Chr(10)
	cMsn    += " OBS: As tr๊s(3) primeiras linhas serใo ignoradas por serem consideradas como cabe็alho. "


	cTipo := cTipo + "*.CSV           | *.CSV |   "
	cTipo := cTipo + "Todos os Arquivos *.* | *.* "

	DEFINE MSDIALOG oDlg TITLE "Importa็ใo Etiqueta Amazon" FROM C(235),C(275) TO C(447),C(735) PIXEL
	@ C(004),C(004) TO C(067),C(227) LABEL "Importacao de  Arquivo" PIXEL OF oDlg
	@ C(015),C(018) Say cMsn  Size C(192),C(050) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(071),C(188) Button "Cancelar" Size C(037),C(012) ACTION (nOpc:=1,oDlg:End()) PIXEL OF oDlg
	@ C(072),C(005) Button "Importar" Size C(037),C(012) ACTION (nOpc:=2,oDlg:End()) PIXEL OF oDlg
	@ C(055),C(024) CHECKBOX oCheckBox1 VAR lCheckBox1 PROMPT "Sobrepor planilha jแ importada" SIZE C(150), C(008) OF oDlg COLORS 0, 16777215 PIXEL 	ON CHANGE (Processa( {||fVldOP()},"Verificando..."))

	ACTIVATE MSDIALOG oDlg CENTERED

	If nOpc == 2
		cTipo   :=         "*.CSV           | *.CSV |   "
		Arquivo :=   cGetFile(cTipo, "Sele็ใo de Arquivo",,"C:\",.T.,,.t.,.t.)
		Arquivo := Alltrim(Arquivo)
		Processa({|| Incitens(Arquivo)},"Processando Arquivo..." + Arquivo) //IncItens()
	Endif

Return(.T.)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบPrograma  ณIncItens	บAutor  ณRicardo Roda        บ Data ณ  11/06/21   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 					Valida็ใo dos dados	    	 		      บฑฑ
ฑฑบ          ณ 												              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IncItens(Arquivo)

	Local lCop       := .F.
	Local cNomeArq   := Substr(Arquivo,Rat("\",Arquivo)+1,Len(Arquivo))
	Local nLinhas    := 0
	Local nX		 := 0
	Local oMemo      := NIL
	Local oDlg       := NIL
	Local cFile      := NomeAutoLog()
	Local cTexto     :=""
	Local cTexto2    :=""
	Local aRegs      := {}
	Local aRegItem   := {}
	Local lErro      := .F.
	Local _i
	Local _y
	Local x, y

	if Empty(Arquivo)
		Alert("Caminho ou arquivo invแlido!")
		Return
	Else
		lCop := CpyT2S(Arquivo,"\import")
	endIf

	If !lCop
		Alert("Erro ao copiar arquivo para Servidor, informe TI")
		Return
	EndIf

	// Retorna conte๚do do arquivo TXT
	cArquivo := MemoRead( "\import\"+cNomeArq )
	// Verifica o n๚mero de linhas no texto
	nLinhas := MLCount(cArquivo)

	ProcRegua(nLinhas,"Processando arquivo CVS...")

	aVetor1 := {}

	For x := 1 To nLinhas
		cLinha  := Memoline( cArquivo,250,x)
		aCampos := Separa(cLinha,";",.T.)
		If !Empty(aCampos)
			AADD(aVetor1,aCampos)
		EndIf
		// If x == 3
		// 	For y := 1 to Len(aCampos)
		// 		If !Empty(aCampos[y])
		// 			nMaxCol := y
		// 		EndIf
		// 	Next y
		// EndIf
	Next x

	// aVetor2 := {}
	// For x := 1 to Len(aVetor1)
	// 	AADD(aVetor2,Array(nMaxCol))
	// Next x

	// nColFinal := 0
	// For x := 4 to Len(aVetor1)
	// 	nColAtu   := 0
	// 	For y := 1 to nMaxCol
	// 		If Upper(aVetor1[1,y]) <> 'CABLING NOTES'
	// 			If !Empty(aVetor1[1,y]) .OR. y == nMaxCol //ALLTRIM(aVetor1[1,y]) == "-"
	// 				nColAtu++
	// 				aVetor2[x,nColAtu] := aVetor1[x,y]
	// 				If x == 2
	// 					nColFinal++
	// 				EndIf
	// 			Else
	// 				aVetor1[x,y] := aVetor2[x,nColAtu] + ' ' + aVetor1[x,y]
	// 			EndIf
	// 		EndIf
	// 	Next y
	// Next x

	For nX := 4 To Len(aVetor1)  // For nX := 2 To Len(aVetor1)
		IncProc()

		// For x := 1 to 10
		// 	&("cLabel"+Alltrim(Str(x))) := ''
		// Next x

		// For x := 1 to 10
		// 	If (nColFinal-1) >= x
		// 		&("cLabel"+Alltrim(Str(x))) := Alltrim(aVetor2[nX,x])
		// 	EndIf
		// Next x

		cLabel1 := Alltrim(aVetor1[nx,1])
		cLabel2 := Alltrim(aVetor1[nx,2])
		cLabel3 := Alltrim(aVetor1[nx,3]) + Alltrim(aVetor1[nx,4]) + Alltrim(aVetor1[nx,5])
		cLabel4 := Alltrim(aVetor1[nx,6])
		cLabel5 := Alltrim(aVetor1[nx,7])
		cLabel6 := Alltrim(aVetor1[nx,8]) + Alltrim(aVetor1[nx,9]) + Alltrim(aVetor1[nx,10])

		cPedido:= SC5->C5_NUM
		//cItemDoc:= Alltrim(aVetor2[nX,nColFinal])
		cItemDoc:= StrZero(Val(aVetor1[nx,12]),2)
		//cItemPos:= acols[N,1]

		//aadd(aRegs,{cLabel1,cLabel2,cLabel3,cLabel4,cLabel5,cLabel6,cLabel7,cLabel8,cLabel9,cLabel10,cPedido,cItemDoc,nX})
		aadd(aRegs,{cLabel1,cLabel2,cLabel3,cLabel4,cLabel5,cLabel6,cPedido,cItemDoc,nX})

		nPos:= ascan(aRegItem, {|aVet| aVet[1] == cItemDoc  } )
		nPosQtd:= ascan(Acols, {|aVet| aVet[1] == cItemDoc  } )

		if nPos == 0
			IF nPosQtd == 0
				cTexto += "Erro na importa็ใo do arquivo - Item "+cItemDoc
				cTexto += chr(13)+chr(10)
				cTexto += "Item nฐ"+cItemDoc+" da Planilha nใo encontrado no pedido"
				cTexto += chr(13)+chr(10)
				ctexto += Replicate ("-",75)
				cTexto += chr(13)+chr(10)
				lErro:= .T.
			Else
				aadd(aRegItem,{cItemDoc,1,acols[nPosQtd,aScan( aHeader, { |aVet| Alltrim(aVet[2]) == 'C6_QTDVEN'   } )],cPedido } )
			Endif
		Else
			aRegItem[npos,2]+= 1
		Endif

	Next NX

	If  len(Acols) > len(aRegItem)
		cTexto2 += "Aten็ใo - Existem mais itens no pedido do que hแ na planilha, Verifique!"
		cTexto2 += chr(13)+chr(10)
		ctexto2 += Replicate ("-",75)
		cTexto2 += chr(13)+chr(10)
	Endif

	ProcRegua(Len(aRegItem),"Comparando Quantidade de Etiquetas X Itens")

	For _i:= 1 to len (aRegItem)
		IncProc()

		if fVldOP(SC5->C5_NUM,aRegItem[_i,1])
			if lCheckBox1
				ZZU->(dbSetOrder(1))//ZZU_FILIAL, ZZU_PEDIDO, ZZU_ITEM
				//ZZU->(dbSeek(xFilial("ZZU")+SC5->C5_NUM+aRegItem[_i,1]))
				//while ZZU->(!eof()) .and. ZZU->ZZU_PEDIDO == SC5->C5_NUM .AND. ZZU->ZZU_ITEM == aRegItem[_i,1]
				While ZZU->(dbSeek(xFilial("ZZU")+SC5->C5_NUM+aRegItem[_i,1]))
					Reclock("ZZU",.F.)
					ZZU->(dbDelete())
					ZZU->(MsUnlock())
					//ZZU->(dbSkip())
				End
			Endif
		Else
			cTexto += "Sobreposi็ใo Recusada - Item "+aRegItem[_i,1] +" jแ possui OP"
			cTexto += chr(13)+chr(10)
			ctexto += Replicate ("-",75)
			cTexto += chr(13)+chr(10)
			lErro:= .T.
		Endif


		if aRegItem[_i,2] <> aRegItem[_i,3]
			cTexto += "Erro na importa็ใo do arquivo - Item "+aRegItem[_i,1]
			cTexto += chr(13)+chr(10)
			cTexto += "Quantidade de etiquetas:"+alltrim(str(aRegItem[_i,2]))
			cTexto += chr(13)+chr(10)
			cTexto += "Quantidade do Item:"+alltrim(str(aRegItem[_i,3]))
			cTexto += chr(13)+chr(10)
			ctexto += Replicate ("-",75)
			cTexto += chr(13)+chr(10)
			lErro:= .T.
		Endif

		ZZU->(dbSetOrder(1))//ZZU_FILIAL, ZZU_PEDIDO, ZZU_ITEM
		if ZZU->(DbSeek(xFilial("ZZU")+alltrim(aRegItem[_i,4])+alltrim(aRegItem[_i,1])))
			cTexto += "Erro na importa็ใo do arquivo
			cTexto += chr(13)+chr(10)
			cTexto += "Item "+alltrim(aRegItem[_i,1]) +" jแ importado"
			cTexto += chr(13)+chr(10)
			ctexto += Replicate ("-",75)
			cTexto += chr(13)+chr(10)
			lErro:= .T.
		Endif

		cTexto2 += "Foram Importadas "+ALLTRIM(str(aRegItem[_i,3]))+" Etiquetas para o item "+aRegItem[_i,1]
		cTexto2 += chr(13)+chr(10)
		ctexto2 += Replicate ("-",79)
		cTexto2 += chr(13)+chr(10)
	Next _i

	if !lErro
		cTexto:= cTexto2

		//ASort (aRegs,,,{|x,y| x[10] < y[10]}  )
		nPos := Len(aRegs[1])-1
		ASort (aRegs,,,{|x,y| x[nPos] < y[nPos]}  )
		for _y := 1 to len (aRegs)

			dbSelectArea("ZZU")
			RecLock("ZZU",.T.)
			ZZU->ZZU_FILIAL := xFilial("ZZU")
			ZZU->ZZU_LABEL1 := aRegs[_y,1]
			ZZU->ZZU_LABEL2 := aRegs[_y,2]
			ZZU->ZZU_LABEL3 := aRegs[_y,3]
			ZZU->ZZU_LABEL4 := aRegs[_y,4]
			ZZU->ZZU_LABEL5 := aRegs[_y,5]
			ZZU->ZZU_LABEL6 := aRegs[_y,6]
			// ZZU->ZZU_LABEL7 := aRegs[_y,7]
			// ZZU->ZZU_LABEL8 := aRegs[_y,8]
			// ZZU->ZZU_LABEL9 := aRegs[_y,9]
			// ZZU->ZZU_LABELA := aRegs[_y,10]
			ZZU->ZZU_PEDIDO := aRegs[_y,7]
			ZZU->ZZU_ITEM   := aRegs[_y,8]
			ZZU->(MsUnlock())

			SC6->(DbSetOrder(1))
			if SC6->(dbSeek(XFilial("SC6")+aRegs[_y,7]+aRegs[_y,8]))
				RecLock("SC6",.F.)
				SC6->C6_XAMZETI:= 'S'
				SC6->(MsUnlock())
			Endif


		Next _y
	Endif

	Define Font oFont Name "Mono AS" Size 8, 16
	Define MsDialog oDlg Title "Problema de Importa็ใo" From 0, 0 to 350, 650 Pixel

	@ 3, 3 Get oMemo Var cTexto Memo Size 340, 290 Of oDlg Pixel
	oMemo:bRClicked := { || AllwaysTrue() }
	oMemo:oFont     := oFont

	Define SButton From 153, 230 Type  1 Action oDlg:End() Enable Of oDlg Pixel // Apaga
	Define SButton From 153, 260 Type 13 Action ( cFile := cGetFile( cMask, "" ), If( cFile == "", .T., MemoWrite( cFile, cTexto ) ) ) Enable Of oDlg Pixel

	Activate MsDialog oDlg Center

	if !lErro
		MsgInfo("Importa็ใo realizada com sucesso!", "SUCESSO!!!")
	Else
		Msgstop("Importa็ใo 'NรO' realizada", "VERIFIQUE")
	Endif

Return (.T.)



Static Function C(nTam)

	Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor

	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
		nTam *= 0.8
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
		nTam *= 1
	Else	// Resolucao 1024x768 e acima
		nTam *= 1.28
	EndIf


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTratamento para tema "Flat"ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If "MP8" $ oApp:cVersion
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
			nTam *= 0.90
		EndIf
	EndIf

Return Int(nTam)


Static function fVldOP(cPedido,cItem)
	Local lRet := .T.
	//Local cItemPos:= acols[N,1]
	Local cIgnora := GetMV("MV_XIGOPAM")  // Parametro que indica se irแ ou nใo ignorar 
	                                      // as OPs abertas para o Pedido de

	If cIgnora == "N"
		SC2->(dbSetOrder(12))
		IF SC2->(dbSeek(xFilial("SC2")+cPedido+cItem))
			MSGSTOP("Nใo ้ possivel sobrepor os dados jแ importados, pois o item "+cItem+" jแ possui ordem de Produ็ใo", "Sobreposi็ใo Recusada!")
			lCheckBox1:= .F.
			lRet := .F.
			//oCheckBox1:refresh()
		Endif
	EndIf

Return lRet
