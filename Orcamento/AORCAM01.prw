#include "rwmake.ch"
#include "totvs.ch
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AORCAM0   ºAutor  ³Osmar Ferreira      º Data ³  06/12/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importação de Itens via CSV no Orçamento de Vendas         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AORCAM01()
	Private lOK := .F.




	SA1->( dbSetOrder(1) )
	DA0->( dbSetOrder(1) )

	//Cliente ok
	If Empty(M->CJ_CLIENTE)
		MsgStop('Favor informar o cliente antes de importar a planilha')
		lOk := .F.
		Return
	Else
		If !SA1->( dbSeek(xFilial()+M->CJ_CLIENTE + M->CJ_LOJA))
			MsgStop('Cliente não cadastrado')
			lOk := .F.
			Return
		EndIf
	EndIf

	//If Empty(M->C5_XPVTIPO)
	//	MsgStop('Favor informar o Tipo do Pedido')
	//	lOk := .F.
	//	Return
	//EndIf

	//Tabela ok
//	If M->C5_XPVTIPO <> 'RT'
	If Empty(M->CJ_TABELA)
		MsgStop('Favor informar a tabela de preços antes de importar a planilha')
		lOk := .F.
		Return
	Else
		If !DA0->(dbSeek(xFilial() + M->CJ_TABELA))
			MsgStop('Tabela de Preço não cadastrada')
			lOk := .F.
			Return
		EndIf
	ENDIF

	//Tabela x Cliente ok
	If (SA1->A1_TABELA <> M->CJ_TABELA) .And. (DA0->DA0_XGENER <> "S")
		MsgStop('Tabela de Preço não cadastrada para este cliente')
		lOk := .F.
		Return
	EndIf
//	EndIf

	If MsgYesNo("Deseja importar itens de um arquivo no formato .csv?")
		//aTemp := aClone(aCols[1])

		cNom_Arq := cGetFile("*.CSV|*.CSV","Selecione o arquivo para importação.",1,'C:\',.F.,nOR(GETF_LOCALHARD,GETF_NETWORKDRIVE),.T.,.T.)
		cNom_Arq := Upper(Alltrim(cNom_Arq))

		If !File(cNom_Arq).and. empty(cNom_Arq)
			Aviso('Atenção','Não encontrado o arquivo com a Planilha a ser Importada',{'OK'})
		Else
			lOk := .T.
		EndIf
	Else
		Msgalert("Importação cancelada.")
	EndIf

	If lOk
		If !Empty(cNom_Arq)
			nHandle	 := FT_FUSE(cNom_Arq)
			Processa( {|lEnd| LeArq() } , "Lendo Arquivo...")
			FClose(nHandle)
		EndIF
	EndIf

Return


Static Function LeArq()

		Local nItem      := 0
        Local aStrutTMP1 := {}



	Local cBuffer
	///Local cProduto
	///Local cNumSerie
	///Local cPlaqueta
	///Local cGrupo
	Local aItensPV	 := {}
	Local aAux       := {}
	///Local cOper		 := ""
	///Local cProdAcols := ""
	Local i 		 := 0
	Local nX 		 := 0
	Local _cMsg 	 := ""
	Local aDadosCfo  := {}
	Local cUser := UsrFullName(RetCodUsr())

	Local nPrMaximo  := 0	//Preço máximo
	Local nPrMinimo  := 0	//Preço mínimo

	Private lMsErroAuto:= .F.

	FT_FGOTOP()

	ProcRegua(FT_FLASTREC())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Leitura do arquivo texto.                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While ! FT_FEOF()
		cBuffer := FT_FREADLN()
		aAux    := U_Str2Array(cBuffer,";")
		AAdd( aItensPV , aAux)

		IncProc()
		FT_FSKIP(1)
	EndDo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta Array para ExecAuto                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aItensPV) == 0
		MsgStop("Arquivo vazio.")
	EndIf

	If Len(aItensPV) == 1
		MsgStop("Arquivo contém apenas cabeçalho.")
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Validações do arquivo                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	DbSelectArea("SX5")
	SX5->(DbSetOrder(1))

	If Len(aItensPV[1]) <> 8
		MsgStop("Versao do arquivo incorreto, utilizar planilha com coluna de tipo de operacao.")
		Return
	EndIf

	//M->C5_XXLIBFI := iif(empty(M->C5_XXLIBFI),"0",M->C5_XXLIBFI)                  // mauresi em 26/06/2019

	//If M->C5_XPVTIPO <> 'RT'
	//	// Validando se não existe outro PV com o mesmo numero de pedido do cliente
	//	cQuery := " SELECT C5_NUM, C5_EMISSAO "
	//	cQuery += " FROM "+ RetSqlName("SC5")+" SC5 "
	//	cQuery += " WHERE C5_CLIENTE ='"+M->C5_CLIENTE+"' "
	//	cQuery += " AND C5_LOJACLI ='"+M->C5_LOJACLI+"' "
	//	cQuery += " AND C5_ESP1 ='"+aItensPV[1][8]+"' "
	//	cQuery += " AND D_E_L_E_T_ <> '*'

	//	If Select("WRK") <> 0
	//		WRK->( dbCloseArea() )
	//	EndIf

	//	TcQuery cQuery Alias "WRK" New

	//	TcSetField("WRK","C5_EMISSAO","D")

	//	If !WRK->( Eof() )
	//		cMsg := "Sr (a) " +cUser+chr(13)
	//		cMsg += "Ja existe OF(S) no Sistema com este Numero de Pedido:"+chr(13)+chr(13)
	//		Do While !Eof()
	//			cMsg += "OF numero "+WRK->C5_NUM+" do dia "+DtoC(WRK->C5_EMISSAO)+chr(13)
	//			WRK->(Dbskip())
	//		EndDo
	//		While ! MsgNoYes(cMsg,"Duplicidade de Pedido do Cliente")
	//		End
	//		WRK->( DbCloseArea() )
	//		Return
	//	EndIf
	//EndIf

	//M->C5_ESP1 := aItensPV[1][8]

	//If lValid
	//	U_VPdCli()
	//Endif
	//M->C5_MENNOTA := aItensPV[1][8]

	// Validando os códigos de Produtos
	SB1->( dbSetOrder(1) )
	For nX := 3 To Len(aItensPV)

		aItensPv[nX,8] := StrZero(Val(aItensPv[nX,8]),2)

		If !Empty(aItensPV[nX,1])
			If !SB1->( dbSeek( xFilial() + aItensPV[nX,1] ) )
				MsgStop("Código de Produto inválido na linha "+Alltrim(Str(nX))+" do arquivo.")
				Return
			EndIf
		Else
			//Busca pelo código do cliente		-		Osmar Ferreira 15/06/21
			If !Empty(AllTrim(aItensPV[nX,4]))
				cQry := " Select Top 1 DA1_CODPRO, DA1_SEUCOD, DA1_PRCVEN "
				cQry += " From "+ RetSqlName("DA1") + " DA1  With(Nolock) "
				cQry += " Where DA1_FILIAL = '"+xFilial("DA1")+"' And D_E_L_E_T_ = '' And DA1_CODTAB = '"+M->CJ_TABELA+"' And DA1_SEUCOD = '"+AllTrim(aItensPV[nX,4])+"'"
				cQry += " Order by DA1_ITEM Desc "

				If Select("xDA1") <> 0
					XDA1->( dbCloseArea() )
				EndIf
				TcQuery cQry Alias "xDA1" New

				If !Empty(xDA1->DA1_CODPRO)
					aItensPv[nX,1] := xDA1->DA1_CODPRO
					XDA1->( dbCloseArea() )
				Else
					MsgStop("Código do Produto do Cliente inválido na linha "+Alltrim(Str(nX))+" do arquivo.")
					XDA1->( dbCloseArea() )
					Return
				EndIf

			EndIf
		EndIf
		/*
		If !Empty(AllTrim(aItensPv[nX,8]))
			If !SX5->(DbSeek(xFilial()+"ZC"+AllTrim(aItensPv[nX,8] )))
				MsgStop("Codigo da Operacao invalido na linha "+Alltrim(Str(nX))+" do arquivo.")
				Return
			EndIf
		EndIf
		*/
	Next nX

	// Validando tabela de preço
	DA0->( dbSetOrder(1) )
	DA0->( dbSeek(xFilial() + M->CJ_TABELA ))
	If DA0->DA0_XGENER == "S"
		lGenerica := .T.
	else
		lGenerica := .F.
	EndIf

	//If M->C5_XPVTIPO <> 'RT'
	DA1->( dbSetOrder(1) )
	For nX := 3 To Len(aItensPV)

		aItensPv[nX,8] := StrZero(Val(aItensPv[nX,8]),2)

		If !DA1->(dbSeek(xFilial() + M->CJ_TABELA + aItensPv[nX,1] ))
			MsgStop("Produto "+aItensPv[nX,1]+" não cadastrado na tabela "+AllTrim(M->CJ_TABELA)+". Erro na linha "+Alltrim(Str(nX))+" do arquivo.")
			/////lOk := .F.
			/////Return
		EndIf

		aItensPV[nX,3]  := StrTran(aItensPV[nX,3],"R$","") // Preço unitário
		aItensPV[nX,3]  := StrTran(aItensPV[nX,3],"." ,"")
		aItensPV[nX,3]  := StrTran(aItensPV[nX,3],",",".")
		aItensPV[nX,3]  := Val(aItensPV[nX,3])

		nPrMaximo := DA1->DA1_PRCVEN + ( DA1->DA1_PRCVEN * ( DA1->DA1_XTOLER / 100 ) )
		nPrMinimo := DA1->DA1_PRCVEN - ( DA1->DA1_PRCVEN * ( DA1->DA1_XTOLER / 100 ) )

		If lGenerica .And. aItensPV[nX,3] < DA1->DA1_PRCVEN
			MsgStop("Preço inferior a Tabela de Preços na linha "+Alltrim(Str(nX))+" do arquivo.")
			/////////lOk := .F.
			/////////Return
		EndIf

		//If !lGenerica .And. aItensPV[nX,3] <> DA1->DA1_PRCVEN
		If !lGenerica .And. (( aItensPV[nX,3] < nPrMinimo ) .Or. ( aItensPV[nX,3] > nPrMaximo ))
			MsgStop("Preço diferente da Tabela de Preços na linha "+Alltrim(Str(nX))+" do arquivo.")
		//////	lOk := .F.
		/////	Return
		EndIf

	Next nX
	//Else
	//	For nX := 3 To Len(aItensPV)

	//	    aItensPv[nX,8] := StrZero(Val(aItensPv[nX,8]),2)

	//		aItensPV[nX,3]  := StrTran(aItensPV[nX,3],"R$","") // Preço unitário
	//		aItensPV[nX,3]  := StrTran(aItensPV[nX,3],"." ,"")
	//		aItensPV[nX,3]  := StrTran(aItensPV[nX,3],",",".")
	//		aItensPV[nX,3]  := Val(aItensPV[nX,3])
	//	Next nX
	//EndIf



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processando o arquivo                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If Len(aItensPV) >= 3

	aAreaTMP1 := GetArea()
	TMP1-&gt;(Dbgotop())
 
        //A ideia é saber quantas linhas temos no grid, em caso de uma alteração
	While TMP1-&gt;(!EOF())
		nItem++
		TMP1-&gt;(dbskip())
	End
 
	aStrutTMP1 := dbStruct()
	
	//Preenche a grid com os dados
	If nItem==1
		cItem := "00"
	else
		cItem := TMP1-&gt;CK_ITEM
	endif
 
        //Supondo que você preencheu o array aLinhas com o conteudo do arquivo
        //sendo CODIGO;QUANTIDADE //aLinha[n,1];aLinha[n,2]
        //Percorremos todo o array
	For nI := 1 TO LEN(aItensPV)	
		If nI == 1 
			If nItem==1 //se tiver algum registro adiciono mais um
				TMP1-&gt;(DBGOTO(nITEM+1)) 
			Else
				TMP1-&gt;(DBGOTO(nITEM))  
				lAux:=.T.
			Endif                    
			cItem := TMP1-&gt;CK_ITEM
                        //Quando estamos no modo de inclusão, a rotina de orçamento não deixa os 
                        //campos do grid em memoria, para isso é preciso pular uma linha e começar a partir da segunda
			oGetDad:AddLine()
		EndIf
		
		nItem++
		cItem := soma1(cItem)
		
		dbSelectArea("TMP1")
       	RecLock("TMP1",.F.)
				
		TMP1-&gt;CK_ITEM    := cItem
		TMP1-&gt;CK_PRODUTO := aItensPV[nI][1]
		TMP1-&gt;CK_QTDVEN  := aItensPV[nI][2]
		TMP1-&gt;CK_PRCVEN  := aItensPV[nI,3]       // Preço
		TMP1-&gt;CK_VALOR   := TMP1-&gt;CK_QTDVEN * TMP1-&gt;CK_PRCVEN
 
 		SB1->( dbSeek( xFilial() +  aItensPV[nI,1]) )
		TMP1-&gt;CK_DESCRI := SB1->B1_DESC
		TMP1-&gt;CK_UM			 := SB1->B1_UM           // UM
		TMP1-&gt;CK_IPI		 := SB1->B1_IPI          // IPI
		TMP1-&gt;CK_TES		:= SB1->B1_TS			//TES
		TMP1-&gt;CK_LOCAL      :=  SB1->B1_LOCPAD 
		TMP1-&gt;CK_SEUCOD     :=  aItensPV[nI,4]       // Cod. Cliente
		TMP1-&gt;CK_XOPER		 := StrZero(Val(aItensPV[nI,8]),2)

		
		//aAreaTMP1 := GetArea()
		A093Prod(.T.,TMP1-&gt;CK_PRODUTO,TMP1-&gt;CK_PRODUTO,.T.)
		
		//Valida o código do produto
		If !A415Prod(TMP1-&gt;CK_PRODUTO)
			aadd(aItensErro,{TMP1-&gt;CK_ITEM,TMP1-&gt;CK_PRODUTO})
		EndIf		
 
		If ExistTrigger("CK_PRODUTO")
			RunTrigger(2,nItem,Nil,,"CK_PRODUTO")
		Endif                                               
		
		M-&gt;CK_PRCVEN	:= TMP1-&gt;CK_PRCVEN	
		M-&gt;CK_QTDVEN 	:= aLinhas[nI][2]
		TMP1-&gt;CK_QTDVEN := M-&gt;CK_QTDVEN  		
		M-&gt;CK_VALOR  	:= M-&gt;CK_QTDVEN * M-&gt;CK_PRCVEN
		TMP1-&gt;CK_VALOR  := TMP1-&gt;CK_QTDVEN * TMP1-&gt;CK_PRCVEN				                    
		M-&gt;CK_ENTREG  	:= dDataBase() //dEntrega
		//Inicializa as Variaveis
		For nA := 1 to Len(aStrutTMP1)
			cVariavel := 'M-&gt;'+astrutTMP1[nA][1]
			xConteudo := FieldGet(nA)
			Private &amp;cVariavel:= xConteudo
		Next
		
		DbSelectArea('TMP1')
                //reforço as informações nas variaveis de memoria
		For nA := 1 to Len(aStrutTMP1)
			cVariavel := 'M-&gt;'+astrutTMP1[nA][1]
			xConteudo := &amp;cVariavel
			FieldPut(nA,xConteudo)
		Next                            
		
		M-&gt;CK_VALOR  	:= M-&gt;CK_QTDVEN * M-&gt;CK_PRCVEN
		TMP1-&gt;CK_VALOR  := TMP1-&gt;CK_QTDVEN * TMP1-&gt;CK_PRCVEN
	    
      	        TMP1-&gt;(MsUnLock())
        
	        if nI&lt;LEN(aLinhas) 
			oGetDad:AddLine()  //adiciono uma linha, com esta linha eu coloco o grid na memoria 
		endif
		oGetDad:Refresh()  //atualizo o grid
	Next nI
 
	IF lAux    
		oGetDad:AddLine()   
		oGetDad:Refresh() 
	ENDIF
	
	nBrLin := nItem + 1
	oGetDad:nCount := nItem + 1
	oGetDad:ForceRefresh()
	
	IF lAux==.F.
	    TMP1-&gt;(DBGOTOP())
		//TMP1-&gt;(DBGOBOTTOM())
		//oGetDad:Refresh()
		//oGetDad:ForceRefresh()
	ENDIF	

	Restore(aAreaTMP1)

//-----------------------------------------------
/*
		SB1->( dbSetOrder(1) )
	
		_cSequenc:= "00"
	//	oGetDad:AddLine()
		For nX := 3 to Len(aItensPV)
			If nX = 3
			   RecLock("TMP1",.f.)
			Else
			   RecLock("TMP1",.t.)
			EndIf

			_cSequenc := soma1(_cSequenc)    // Gera Sequencia Alfanumerica para Comportar mais de 99 Itens // mauresi em 25/01/17
			TMP1->CK_ITEM    := _cSequenc
			TMP1->CK_PRODUTO := aItensPV[nX,1]       // Produto
			//RunTrigger(2,Len(aCols),Nil,,'TMP1->CK_PRODUTO')
			//RunTrigger(2, Val(_cSequenc) ,Nil,,'CK_PRODUTO')

			SB1->( dbSeek( xFilial() +  aItensPV[nX,1]) )

			TMP1->CK_DESCRI     := SB1->B1_DESC         // Descrição
			TMP1->CK_SEUCOD     :=  aItensPV[nX,4]       // Cod. Cliente
			TMP1->CK_UM			 := SB1->B1_UM           // Descrição
			TMP1->CK_IPI		 := SB1->B1_IPI          // IPI
			TMP1->CK_TES		:= SB1->B1_TS			//TES
			TMP1->CK_LOCAL      :=  SB1->B1_LOCPAD       // Almoxarifado
			TMP1->CK_QTDVEN      := Val(aItensPV[nX,2])  // Quantidade
		//	RunTrigger(2,Len(aCols),Nil,,'TMP1->CK_QTDVEN')
			TMP1->CK_PRCVEN      := aItensPV[nX,3]       // Preço
			TMP1->CK_VALOR       := TMP1->CK_QTDVEN * TMP1->CK_PRCVEN
			TMP1->CK_XOPER		 := StrZero(Val(aItensPV[nX,8]),2)
			//TMP1->CK_MARGEM	     := 10
			//TMP1->CK_PRAZO := "XX DIAS"
			TMP1->CK_ALI_WT :=  "SCK"
			TMP1->CK_REC_WT := TMP1->(Recno())

		//	RunTrigger(2,Len(aCols),Nil,,'TMP1->CK_PRCVEN')

			//TMP1->CK_PRAZO := CtoD(aItensPV[nX,7]) // Entrega

			//	aCols[Len(aCols),nPC6_IPI    ] := SB1->B1_IPI          // IPI
			//	aCols[Len(aCols),nPC6_QTDVEN ] := Val(aItensPV[nX,2])  // Quantidade
			//	RunTrigger(2,Len(aCols),Nil,,'C6_QTDVEN')
			//	aCols[Len(aCols),nPC6_PRCVEN ] := aItensPV[nX,3]       // Preço

			//	RunTrigger(2,Len(aCols),Nil,,'C6_PRCVEN')

			TMP1->(MsUnLock())
		 
			oGetDad:Refresh()
				
		Next nx
			
*/			

		/*	
		aCols := {}

		For nX := 3 to Len(aItensPV)
			SB1->( dbSeek( xFilial() +  aItensPV[nX,1]) )
		
			AADD(aCols,Array(LEN(aHeader)+1))
			aCols[LEN(aCols),LEN(aHeader)+1] := .F.

			n := Len(aCols)

			For i := 1 to LEN(aHeader)
				If !aHeader[i,2] $ 'C6_ALI_WT/C6_REC_WT'
					aCols[LEN(aCols),i]:=CriaVar(aHeader[i,2])
				ElseIf aHeader[i,2] == "C6_ALI_WT"
					aCols[LEN(aCols),i]:= "SC6"
				ElseIf aHeader[i,2] == "C6_REC_WT"
					aCols[LEN(aCols),i]:= 0
				EndIf
			Next i
		
			aItensPV[nX,1]                 += Space(15-Len(aItensPV[nX,1]))
			_cSequenc:= soma1(_cSequenc)    // Gera Sequencia Alfanumerica para Comportar mais de 99 Itens // mauresi em 25/01/17
			aCols[Len(aCols),1]            := _cSequenc
			aCols[Len(aCols),nPC6_PRODUTO] := aItensPV[nX,1]       // Produto
			RunTrigger(2,Len(aCols),Nil,,'C6_PRODUTO')

			SB1->( dbSeek( xFilial() +  aItensPV[nX,1]) )	

			aCols[Len(aCols),nPC6_DESCRI ] := SB1->B1_DESC         // Descrição
			aCols[Len(aCols),nPC6_UM     ] := SB1->B1_UM           // Descrição
			aCols[Len(aCols),nPC6_IPI    ] := SB1->B1_IPI          // IPI
			aCols[Len(aCols),nPC6_QTDVEN ] := Val(aItensPV[nX,2])  // Quantidade

			RunTrigger(2,Len(aCols),Nil,,'C6_QTDVEN')
			aCols[Len(aCols),nPC6_PRCVEN ] := aItensPV[nX,3]       // Preço

			RunTrigger(2,Len(aCols),Nil,,'C6_PRCVEN')
			aCols[Len(aCols),nPC6_VALOR  ] := NoRound((aCols[Len(aCols),nPC6_QTDVEN ] * aCols[Len(aCols),nPC6_PRCVEN ]),2)
			If !Empty(AllTrim(aItensPv[nX,8]))
				aCols[Len(aCols),nPC6_XOPER	 ] := aItensPv[nX,8]
			Else
				aCols[Len(aCols),nPC6_XOPER	 ] := Space(2)
			EndIf

			RunTrigger(2,Len(aCols),Nil,,'C6_XOPER')
			aCols[Len(aCols),nPC6_SEUCOD ] := aItensPV[nX,4]       // Cod. Cliente
			aCols[Len(aCols),nPC6_SEUDES ] := aItensPV[nX,5]       // Pedido Cliente
			aCols[Len(aCols),nPC6_XXSHIPM] := aItensPV[nX,6]       // Shipment
			aCols[Len(aCols),nPC6_ENTREG ] := CtoD(aItensPV[nX,7]) // Entrega
			aCols[Len(aCols),nPC6_LOCAL  ] := If(M->C5_XPVTIPO=="RT",GetMV("MV_XLOCTRA"),"13")
			aCols[Len(aCols),nPC6_GRUPO  ] := SB1->B1_GRUPO
			RunTrigger(2,Len(aCols),Nil,,'C6_TES')

			SA1->(DbSetOrder(1))
			SA1->(DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI))

			aDadosCfo := {}
			AAdd(aDadosCfo,{"OPERNF","S"})
			AAdd(aDadosCfo,{"TPCLIFOR","C" })
			AAdd(aDadosCfo,{"UFDEST"  ,SA1->A1_EST})
			AAdd(aDadosCfo,{"INSCR"   ,SA1->A1_INSCR})
			AAdd(aDadosCfo,{"CONTR"   ,SA1->A1_CONTRIB})
			Aadd(aDadosCfo,{"FRETE"   ,M->C5_TPFRETE})

			aCols[Len(aCols),nPC6CF  ]	   :=	MaFisCfo( ,POSICIONE("SF4",1,xFilial("SF4")+aCols[Len(aCols),nPC6TES],"F4_CF"),aDadosCfo )
//			If lValid
			aCols[Len(aCols),nPC6_CLASFIS] := Posicione("SB1",1,xFilial("SB1")+aItensPV[nX,1],"B1_ORIGEM") + POSICIONE("SF4",1,xFilial("SF4")+aCols[Len(aCols),nPC6TES],"F4_SITTRIB")
//			EndIf

			aPrevisoes := {}
			If SA1->( dbSeek( xFilial() + M->C5_CLIENTE + M->C5_LOJAENT ) )
				SC4->( dbSetOrder(3) )   // C4_PRODUTO + C4_CNPJ + C4_DATA
				If SC4->( dbSeek( xFilial() + aItensPV[nX,1] + Subs(SA1->A1_CGC,1,8) ) )
					While !SC4->( EOF() ) .and. SC4->C4_PRODUTO == aItensPV[nX,1] .and. Subs(SC4->C4_XXCNPJ,1,8) == Subs(SA1->A1_CGC,1,8)
						If SC4->C4_DATA >= FirstDay(dDataBase)
							AADD(aPrevisoes, SC4->(Recno()) )
							Exit
						EndIf
						SC4->( dbSkip() )
					End
				EndIf

				// Novo campo de Produto geral para Previsões de Vendas
				If Empty(aPrevisoes)
					If SB1->( dbSeek( xFilial() + aItensPV[nX,1] + Space(15-Len(aItensPV[nX,1]))) )
						If !Empty(SB1->B1_XPRVEND)
							If SC4->( dbSeek( xFilial() + SB1->B1_XPRVEND + Subs(SA1->A1_CGC,1,8) ) )
								While !SC4->( EOF() ) .and. SC4->C4_PRODUTO == SB1->B1_XPRVEND .and. Subs(SC4->C4_XXCNPJ,1,8) == Subs(SA1->A1_CGC,1,8)
									If SC4->C4_DATA >= FirstDay(dDataBase)
										AADD(aPrevisoes, SC4->(Recno()) )
										Exit
									EndIf
									SC4->( dbSkip() )
								End
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf

			If !Empty(aPrevisoes)
				SC4->( dbGoTo(aPrevisoes[1]) )
				If SC4->( Recno() ) == aPrevisoes[1]
					aCols[N,nPC6_PREVI] := SC4->C4_PRODUTO
					aCols[N,nPC6_PREDT] := SC4->C4_DATA
				EndIf
			EndIf

		Next nx
		*/
	//	M->C5_XMSGTES	:= ""
	//	For nX := 1 to Len(aCols)
	//		_cMsg := U_ReMsgInt(aCols[nX,nPC6_XOPER	 ],M->C5_CLIENTE,M->C5_LOJACLI,aCols[nX,nPC6_PRODUTO],M->C5_TIPOCLI )
	//		if !(_cMsg $ M->C5_XMSGTES)
	//			M->C5_XMSGTES	+=_cMsg
	//		endif
	//	Next x

	EndIf

Return(Nil)

