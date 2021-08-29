#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#include "topconn.ch"

// Helio / Osmar
//05/03/2020
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OM010MNU ºAutor  ³ Osmar / Helio       º Data ³  05/03/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Faz a importação da Tabela de Preço (DA0)                  º±±
±±º          ³ Cria um botão no browser                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function OM010MNU()
	/*
	aRotina :=	{{OemToAnsi(STR0001),"AxPesqui"			,0,1,32,.F.},;							      //"Pesquisar"
					{ OemToAnsi(STR0002),"Oms010Vis"			,0,MODEL_OPERATION_VIEW		,32,NIL},;	//"Visualizar"
					{ OemToAnsi(STR0003),"Oms010Inc"			,0,MODEL_OPERATION_INSERT	,32,NIL},;	//"Incluir"
					{ OemToAnsi(STR0004),"Oms010Alt"			,0,MODEL_OPERATION_UPDATE	,32,NIL},;	//"Alterar"
					{ OemToAnsi(STR0005),"VIEWDEF.OMSA010"	,0,MODEL_OPERATION_DELETE	,32,NIL},;	//"Excluir"
					{ OemToAnsi(STR0012),"Oms010Cpy"			,0,9							   ,32,NIL},;  //"Copiar"
					{ OemToAnsi(STR0013),"Oms010Ger"	    	,0,3						   	,32,NIL},;  //"Gerar"
					{ OemToAnsi(STR0007),"Oms010Rej"			,0,5							   ,32,NIL} }  //"Reajuste"


	If ExistBlock("OM010MNU")
	ExecBlock("OM010MNU",.F.,.F.)
	EndIf
	*/

	AADD(aRotina,{ "Importar .csv","U_ImpDA1"   ,0,4 } )	//Importar tabela de preço

	//Osmar 22/02/21
    AADD(aRotina,{ "Exportar .csv","U_ExpDA1"   ,0,4 } )	//Exportar tabela de preço

	AADD(aRotina,{ "Limpar Itens","U_ExcItens"  ,0,4 } )	//"Excluir Itens"
	AADD(aRotina,{ "Refaz  Itens","U_RefazItens"  ,0,4 } )	//"Reorganizar"
	//AADD(aRotina,{ "Aprov. Preço","U_AprRepPrc"  ,0,4 } )	//"Aprov / Reprov do Preço"

Return



//Osmar Ferreira - 03/03/2021
//Exporta tabela de preço (DA0 / DA1) para *.CSV
User Function ExpDA1()
Local cTabela    := DA0->DA0_CODTAB
Local cTabFim    := DA0->DA0_CODTAB
Local cIdLocal   := ""
Local cIdArquivo := ""
Local nHandle    := 0
Local cDados     := ""
Local cQry       := ""


    DEFINE MSDIALOG oDlg1 TITLE "Exportar Tabela de Preço (*.csv)" FROM C(235),C(275) TO C(447),C(735) PIXEL
	@ C(025),C(035) Say "Gerar Arquivo da Tabela de Preço (formato *.csv)" Size C(192),C(050) COLOR CLR_BLACK PIXEL OF oDlg1
	
	@ C(040),C(035) Say "DE:  " Size C(192),C(050) COLOR CLR_BLACK PIXEL OF oDlg1
	@ C(040),C(158) Say "ATÉ: " Size C(192),C(050) COLOR CLR_BLACK PIXEL OF oDlg1

	@ C(040),C(050) Get cTabela  Valid (AllTrim(cTabela) <> "") Size 020,10 
	@ C(040),C(168) Get cTabFim  Valid (AllTrim(cTabFim) <> "") Size 020,10 
		
	@ C(071),C(035) Button "Gerar Arquivo "  Size C(037),C(012) ACTION (cOpc:=1,oDlg1:End()) PIXEL OF oDlg1
	@ C(073),C(158) Button "Cancelar      "  Size C(037),C(012) ACTION (cOpc:=2,oDlg1:End()) PIXEL OF oDlg1

    ACTIVATE MSDIALOG oDlg1 CENTERED

	If cOpc == 1
		cIdLocal := cGetFile( '' , 'Selecionar a Pasta:', 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY ),.T., .T. )		
	Else
		Return(.t.)
	Endif

cIdArquivo := "Tab_"+cTabela+"_"+Alltrim(DTOS(DATE()))+"_"+Replace(Time(),':','')+".CSV"

cQry := " Select DA0_CODTAB+';' Tabela, RTrim(DA0_DESCRI)+';' Cliente,"
cQry +=	" RTrim(DA1_CODPRO)+';' Produto, RTrim(B1_DESC)+';' Descricao, LTrim(RTrim(DA1_SEUCOD))+';' Cod_Cliente, "
cQry +=	" Cast(DA1_PRCVEN As Varchar)+';' Preco, Cast(DA1_XTOLER As Varchar)+';' Tolerancia, DA1_XAPROV+';' Aprovado"
cQry +=	" From " + RetSqlName("DA0") +" DA0 With(Nolock)"
cQry +=	" Inner Join " +  RetSqlName("DA1") +" DA1 With(Nolock) On DA1.D_E_L_E_T_ = '' And DA1_CODTAB = DA0_CODTAB"
cQry +=	" Inner Join " + RetSqlName("SB1") + " SB1 With(Nolock) On SB1.D_E_L_E_T_ = '' And B1_COD = DA1_CODPRO"
cQry +=	" Where DA0.D_E_L_E_T_ = '' And DA0_CODTAB Between '"+cTabela+"' And '"+cTabFim+"'"
cQry +=	" Order By DA0_CODTAB "
//cQry +=	" Where DA0.D_E_L_E_T_ = '' And DA0_CODTAB = '"+cTabela+"'"

If Select("DA1CSV") <> 0
	DA1CSV->( dbCloseArea() )
EndIf

TCQUERY cQry NEW ALIAS "DA1CSV"

nHandle := MsfCreate(AllTrim(cIdLocal)+cIdArquivo,0)
//cDados :=  "TABELA;CLIENTE;PRODUTO;DESCRICAO;COD_CLIENTE;PRECO;TOLERENCIA;APROVADO"+Chr(13)

cDados :=  "PRODUTO;PRECO;TOLERENCIA;COD_CLIENTE;CLIENTE;TABELA;DESCRICAO"+Chr(13)


fWrite(nHandle, cDados )

While DA1CSV->(!Eof())
   cDados :=  AllTrim(DA1CSV->Produto) + AllTrim(Replace(DA1CSV->Preco,'.',',')) + AllTrim(DA1CSV->Tolerancia) + AllTrim(DA1CSV->Cod_Cliente) +;
  			  AllTrim(DA1CSV->Cliente) + AllTrim(DA1CSV->Tabela) + AllTrim(DA1CSV->Descricao) + Chr(13)
   
   //DA1CSV->Tabela + DA1CSV->Cliente + DA1CSV->Produto + DA1CSV->Descricao + DA1CSV->Cod_Cliente +; 
   //			  Replace(DA1CSV->Preco,'.',',') + DA1CSV->Tolerancia + DA1CSV->Aprovado + Chr(13)
	
	fWrite(nHandle, cDados )
    
	DA1CSV->(dbSkip())
End

nHandle := MsfCreate(AllTrim(cIdLocal)+cIdArquivo,0)

DA1CSV->( dbCloseArea() )

fClose(nHandle)

MsgInfo("Arquivo gerado: "+ cIdLocal+cIdArquivo)


Return(.t.)




//Osmar Ferreira - 01/12/2020
//Faz a aprovação / reprovação geral de preço na tabela de preço
//é executada somente por usuário cadastrado na tabela de vendedores (SA3)
User Function AprRepPrc()
	Local nOpc     := 3
	Local cResp    := ""
	Local cEscolha := ""
	Local cMsn     := " "+Chr(13)+Chr(10)
	Local aAreaDA0 := DA0->( GetArea() )
	Local aAreaDA1 := DA1->( GetArea() )
	Local aAreaSA3 := SA3->( GetArea() )
	Local cNumTab  := DA0->DA0_CODTAB

//Verifica se o usuário é um vendedor
SA3->( dbSetOrder(07) )
If SA3->(dbSeek(xFilial() + __cUserID))

	cMsn    += " Esta rotina grava a Aprovação ou Reprovação de todos os preços desta tabela."+Chr(13)+Chr(10)

	DEFINE MSDIALOG oDlg TITLE "Aprovação dos Preços" FROM C(235),C(275) TO C(447),C(735) PIXEL
	@ C(004),C(004) TO C(067),C(227) LABEL "Aprovação / Reprovação de Preços." PIXEL OF oDlg
	@ C(015),C(018) Say cMsn  Size C(192),C(050) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(071),C(005) Button "Aprovar " Size C(037),C(012) ACTION (nOpc:=1,oDlg:End()) PIXEL OF oDlg
	@ C(072),C(094) Button "Reprovar" Size C(037),C(012) ACTION (nOpc:=2,oDlg:End()) PIXEL OF oDlg
	@ C(073),C(188) Button "Cancelar" Size C(037),C(012) ACTION (nOpc:=3,oDlg:End()) PIXEL OF oDlg

	ACTIVATE MSDIALOG oDlg CENTERED

	If nOpc == 1
		cResp := "S"
		cEscolha := "APROVADOS"
	ElseIf nOpc == 2
		cResp := "N"
		cEscolha := "REPROVADOS"
	Endif

	If nOpc <> 3
		If msgYesNo("Todos os itens da tabela ("+cNumTab+") terão seus preços "+cEscolha+"."+CHR(13)+CHR(13)+"Deseja continuar?","")
			DA1->( dbSetOrder(03) )
			If DA1->( dbSeek(xFilial() + cNumTab ) )
				While DA1->DA1_CODTAB == cNumTab .And. DA1->(!Eof())
					RecLock("DA1",.F.)
					DA1->DA1_XAPROV :=  cResp
					If cResp == 'S'  //Preço aprovado faz uma cópia do preço aprovado
						DA1->DA1_XPRCAP := DA1->DA1_PRCVEN 
					EndIf
					If cResp == 'N'  //Preço reprovado 
					   If DA1->DA1_XPRCAP == DA1->DA1_PRCVEN 
						   DA1->DA1_XPRCAP := 0    //Muda para 0 para mantelos diferentes
					   EndIf	
					EndIf
					DA1->( msUnLock() )
					DA1->( dbSkip() )
				EndDo
			EndIf
			MsgInfo("Atualização concluída!!")
		EndIf
	EndIf

Else 
    MsgInfo("Esta rotina só pode ser executado pelo vendedor!!")
EndIf

	RestArea(aAreaSA3)
	RestArea(aAReaDa1)
	RestArea(aAreaDA0)

Return(.t.)
//Fim aprovação / reprovação geral de preço


//Refaz a sequencias dos itens da tabela 
//Osmar Ferreira Nov/20
User Function RefazItens()
	Local aAreaDA0 := DA0->( GetArea() )
	Local aAreaDA1 := DA1->( GetArea() )
	Local cNumTab  := DA0->DA0_CODTAB
	Local nItem    := 0

	If msgYesNo("Esta rotina irá refazer a numeração dos itens da tabela ("+cNumTab+")."+CHR(13)+CHR(13)+"Deseja continuar?","")
		DA1->( dbSetOrder(03) )
		If DA1->( dbSeek(xFilial() + cNumTab ) )
			While DA1->DA1_CODTAB == cNumTab .And. DA1->(!Eof())
				nItem++
				RecLock("DA1",.F.)
				DA1->DA1_ITEM :=  StrZero(nItem,4)
				DA1->( msUnLock() )
				DA1->( dbSkip() )
			EndDo
		EndIf

		MsgInfo("Reorganização concluída!!")

	EndIf

	RestArea(aAReaDa1)
	RestArea(aAreaDA0)
Return


//Exclui os itens da tabela e mantem o cabeçalho
//Osmar Ferreira Nov/20
User Function ExcItens()
	Local aAreaDA0 := DA0->( GetArea() )
	Local aAreaDA1 := DA1->( GetArea() )
	Local cNumTab  := DA0->DA0_CODTAB
	Local cTexto   := ""

	cTexto := "Esta Rotina excluirá os itens da tabela ("+cNumTab+") deixando apenas um item para manter a numeração. " +CHR(13)+CHR(13)
	cTexto += "Tem certeza que deseja continuar?"

	If msgYesNo(cTexto,'')
		DA1->( dbSetOrder(03) )
		If DA1->( dbSeek(xFilial() + cNumTab ) )
			//Altera o primeiro item para manter o cabeçalho
			RecLock("DA1",.F.)
			DA1->DA1_PRCVEN := 0
			DA1->DA1_XTOLER := 0
			DA1->( msUnLock() )

			DA1->( dbSkip() )
			While DA1->DA1_CODTAB == cNumTab .And. DA1->(!Eof())
				RecLock("DA1",.F.)
				DA1->( dbDelete() )
				DA1->( msUnLock() )
				DA1->( dbSkip() )
			EndDo
		EndIf
	EndIf

	RestArea(aAReaDa1)
	RestArea(aAreaDA0)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OS010BTN_RDMºAutor  ³                  º Data ³  04/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ImpDA1()

	Local nOpc    := 1
	Local cTipo   := "*.TXT           | *.TXT |   "
	Local Arquivo := ""
	Local cMsn    := " Esta rotina faz importação da tabela de preços em formato CSV."+Chr(13)+Chr(10)
	cMsn    += " IMPORTANTE: Após a importação percorra todos as linhas para evitar problemas ao salvar a tabela."+Chr(13)+Chr(10)
	cMsn    += Chr(13)+Chr(10)
	cMsn    += " ESTRUTURA DA TABELA: CÓDIGO DO PRODUTO; PREÇO DE VENDA; TOLERÂNCIA; CÓDIGO PARA O CLIENTE"
	cMsn    += Chr(13)+Chr(10)
	cMsn    += " OBS: A primeira linha será ignorada por ser considerada cabeçalho. "

	cTipo := cTipo + "*.CSV           | *.CSV |   "
	cTipo := cTipo + "Todos os Arquivos *.* | *.* "

	DEFINE MSDIALOG oDlg TITLE "Importa Tabela de Preco" FROM C(235),C(275) TO C(447),C(735) PIXEL
	@ C(004),C(004) TO C(067),C(227) LABEL "Importacao de  Arquivo." PIXEL OF oDlg
	@ C(015),C(018) Say cMsn  Size C(192),C(050) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(071),C(188) Button "Cancelar" Size C(037),C(012) ACTION (nOpc:=1,oDlg:End()) PIXEL OF oDlg
	@ C(072),C(005) Button "Importar" Size C(037),C(012) ACTION (nOpc:=2,oDlg:End()) PIXEL OF oDlg



	ACTIVATE MSDIALOG oDlg CENTERED

	If nOpc == 2
		cTipo   :=         "*.CSV           | *.CSV |   "
		Arquivo :=   cGetFile(cTipo, "Seleção de Arquivo",,"C:\",.T.,,.t.,.t.)
		Arquivo := Alltrim(Arquivo)
		Processa({|| Incitens(Arquivo)},"Processando Arquivo..." + Arquivo) //IncItens()
	Endif

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OS010BTN_RDMºAutor  ³                  º Data ³  04/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IncItens(Arquivo)
	Local cLog       := ""
	Local cErro      := ""
	//Local nItem      := 0
	Local lCop       := .F.
	Local cProd      := ""
	Local cSEUCOD    := ""
	Local nPrcVen    := 0
	Local nToleran   := 0
	Local cNomeArq   := Substr(Arquivo,Rat("\",Arquivo)+1,Len(Arquivo))
	Local nLines     := 0
	Local nX		 := 0

	if Empty(Arquivo)
		Alert("Caminho ou arquivo inválido!")
		Return
	Else
		lCop := CpyT2S(Arquivo,"\import")
	endIf

	If !lCop
		Alert("Erro ao copiar arquivo para Servidor, informe TI")
		Return
	EndIf

	// Retorna conteúdo do arquivo TXT
	cLine := MemoRead( "\import\"+cNomeArq )
	// Verifica o número de linhas no texto
	nLines := MLCount(cLine)

	ProcRegua(nLines,"Processando arquivo...")

	For nX := 2 To nLines
		IncProc()
		cLinha  := ""

		cLinha  := Memoline( cLine,,nX)

		cErro   := "Linha "+Str(nX)+" - "+cLinha+Chr(13)+Chr(10)

		cProd   := AllTrim(Substr(cLinha,1,At(";",cLinha)-1))

		cLinha  := Substr(clinha,At(";",cLinha)+1,30)

		nPrcVen := Val(StrTran(Substr(cLinha,1,At(";",cLinha)-1),",",".",1))

		cLinha  := Substr(clinha,At(";",cLinha)+1,30)

		nToleran := Val(StrTran(Substr(cLinha,1,At(";",cLinha)-1),",",".",1))

		cLinha  := Substr(clinha,At(";",cLinha)+1,30)

		//cSEUCOD := AllTrim(Substr(clinha,1,At(";",cLinha)-1))
		//Ultimo campo sem ";"
		cSEUCOD := AllTrim(Substr(clinha,1,30))

		//Caso tenha ";" será retirado
		cSEUCOD := StrTran(cSEUCOD,";","")

		cSEUCOD := Iif( IsAlpha(cSEUCOD), cSEUCOD, Iif(IsDigit(cSEUCOD),cSEUCOD,""))

		cProd   := Alltrim(cProd) + Space(Len(SB1->B1_COD)-Len(Alltrim(cProd)))

		//valida a Linha e o produto.
		If !Empty(cProd)
			SB1->( DbSetOrder(1) )
			If !SB1-> (dbseek( xFilial() + cprod ) )
					//Verificar no DA1
				//If nItem <> 1
				//Alert("Codigo de produto Inválido ou não cadastrado ")
				cLog += cErro
				//Endif
				//Next nX
				Loop
			EndIf
		Else
			//Next nX
			Loop
		EndIf

		//----------------------------------------
		//Tratamento Felipe Melo - 04/12/2013
		//----------------------------------------

		iF !Empty(cProd)
			DA1->( dbSetOrder(1) )
			If DA1->( dbSeek( xFilial() + DA0->DA0_CODTAB + cProd ) )
				Reclock("DA1",.F.)
				If DA1->DA1_PRCVEN <> nPrcVen 
				   DA1->DA1_XAPROV := "N"   //Mudou o preço e ficará bloqueado				   
				   If DA1->DA1_XPRCAP == nPrcVen
					   DA1->DA1_XPRCAP := 0    //Muda para 0 para mantelos diferentes
				   EndIf	
				EndIf

				DA1->DA1_PRCVEN := nPrcVen
				DA1->DA1_SEUCOD := cSeuCod
				DA1->DA1_ATIVO  := '1'
				DA1->DA1_TPOPER := '4'
				DA1->DA1_QTDLOT := 999999.99
				DA1->DA1_DATVIG := StoD('19500101')
				DA1->DA1_MOEDA  := 1
				DA1->DA1_XTOLER := nToleran
				DA1->( msUnlock() )
			Else
				Reclock("DA1",.T.)
				DA1->DA1_FILIAL := xFilial("DA1")
				DA1->DA1_CODTAB := DA0->DA0_CODTAB
				DA1->DA1_ITEM   := RetMaxItem(DA0->DA0_CODTAB)
				DA1->DA1_CODPRO := cProd
				//DA1->DA1_DESCRI := Posicione("SB1",1,xFilial("SB1")+cProd,"B1_DESC")
				DA1->DA1_PRCVEN := nPrcVen
				DA1->DA1_SEUCOD := cSeuCod
				DA1->DA1_ATIVO  := '1'
				DA1->DA1_TPOPER := '4'
				DA1->DA1_QTDLOT := 999999.99
				DA1->DA1_DATVIG := StoD('19500101')
				DA1->DA1_MOEDA  := 1
				DA1->DA1_XTOLER := nToleran
				DA1->DA1_XAPROV := "N" 
				DA1->( msUnlock() )
			ENDIF

			If !Empty(cLog)
				MsgInfo(cLog,"Ocorreu erro na(s) linha(s):")
			EndIf
		EndIf
	Next NX
	MsgInfo("Importação finalizada!!")

Return (.T.)

Static Function RetMaxItem(cCodTab)
	Local _Retorno
	Local cQuery

	cQuery := "SELECT MAX(DA1_ITEM) AS DA1ITEM FROM " + RetSqlName("DA1") + " WHERE DA1_FILIAL = '"+xFilial("DA1")+"' AND DA1_CODTAB = '"+cCodTab+"' AND D_E_L_E_T_ = '' "

	If Select("TEMP") <> 0
		TEMP->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS "TEMP"

	_Retorno := StrZero(Val(TEMP->DA1ITEM)+1,Len(DA1->DA1_ITEM))

	TEMP->( dbCloseArea() )

Return _Retorno

Static Function C(nTam)

	Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor

	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
		nTam *= 0.8
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
		nTam *= 1
	Else	// Resolucao 1024x768 e acima
		nTam *= 1.28
	EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para tema "Flat"³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If "MP8" $ oApp:cVersion
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
			nTam *= 0.90
		EndIf
	EndIf

Return Int(nTam)
