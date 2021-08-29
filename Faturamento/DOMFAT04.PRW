#INCLUDE "topconn.ch"
#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#Include "COLORS.CH"
#Include "FONT.CH"


/*/{Protheus.doc} DOMFAT04
// TES Inteligente - DOMEX 
@author Marco Aurelio
@since 09/07/2016
@version undefined
@example
(examples)
@see (links_or_references)
/*/

User Function DOMFAT04()

Private cStrCad   := "ZFM" 
Private cTitCad   := "TES Inteligente - SAIDA - DOMEX"
Private cCadastro := cTitCad+" ["+cStrCad+"]"
Private aRotina   := MenuDef()

Private INCLUI := .F.
Private ALTERA := .F.
Private aCores   := { 	{ "ZFM_MSBLQL == '1' " , 'BR_VERMELHO'    },;      // 1 - Bloqueado
						{ "ZFM_MSBLQL == '2' " , 'BR_VERDE' 		}}	   // 2 - Ativo
Private aFixe     := {}

/* Chama rotina browse com os menus */
DbSelectArea(cStrCad)
DbSetOrder(1)
mBrowse(6,1,22,75,cStrCad,aFixe,,,,,aCores,,,,,)

Return

/*/
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДїпїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅMenuDef   пїЅ Autor пїЅ Felipe Aurelio de MeloпїЅ Data пїЅ02/04/2012пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДґпїЅпїЅ
пїЅпїЅпїЅDescriпїЅпїЅo пїЅ Utilizacao de menu Funcional                               пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДґпїЅпїЅ
пїЅпїЅпїЅRetorno   пїЅ Array com opcoes da rotina.                                пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДґпїЅпїЅ
пїЅпїЅпїЅParametrosпїЅParametros do array a Rotina:                               пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ1. Nome a aparecer no cabecalho                             пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ2. Nome da Rotina associada                                 пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ3. Reservado                                                пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ4. Tipo de TransaпїЅпїЅo a ser efetuada:                        пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ		1 - Pesquisa e Posiciona em um Banco de Dados           пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ    2 - Simplesmente Mostra os Campos                       пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ    3 - Inclui registros no Bancos de Dados                 пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ    4 - Altera o registro corrente                          пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ    5 - Remove o registro corrente do Banco de Dados        пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ5. Nivel de acesso                                          пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ6. Habilita Menu Funcional                                  пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДґпїЅпїЅ
пїЅпїЅпїЅ   DATA   пїЅ Programador   пїЅManutencao efetuada                         пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДґпїЅпїЅ
пїЅпїЅпїЅ          пїЅ               пїЅ                                            пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅЩ±пїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
/*/
Static Function MenuDef()

Local aRotina := {;
{ OemToAnsi("Pesquisar"       	),"AxPesqui"   		, 0 , 1},;  //   
{ OemToAnsi("Visualizar"      	),"Axvisual"		, 0 , 2},;  //   
{ OemToAnsi("Incluir"	      	),"Axinclui"		, 0 , 3},;  //   
{ OemToAnsi("Altera"		  	),"Axaltera"   		, 0 , 4},;  //   4                      
{ OemToAnsi("Exclui"			),"AxDeleta"   		, 0 , 5},;  //   
{ OemToAnsi("Legenda" 			),"u_TESLeg()"   	, 0 , 7},;  //  10
{ OemToAnsi("Importa TES"	 	),"u_DOMFT04C()"  	, 0 , 3}}  //   3

Return(aRotina)


User Function TESLeg

Local cCadLeg	:= "TES Inteligente - SAIDA - DOMEX"
Local aLegenda	:= {}

aAdd(aLegenda,{'BR_VERMELHO' ,'Bloqueado' 	        })
aAdd(aLegenda,{'BR_VERDE'    ,'Ativo'   	           })

BrwLegenda(cCadLeg,"Legenda",aLegenda)

Return



/*/{Protheus.doc} DOMFT04B
// Carrega TES Inteligente no PV
@author Marco Aurelio
@since 20/07/2016
@version undefined
@example
(examples)
@see (links_or_references)
/*/

User Function DOMFT04B(_op)

Local _cAlias		:= Alias()
Local _aSaveArea	:= GetArea()
Local _lContrib		:= .T.

// Chamado pelo Pedido de Venda
if _op == "1"
	 _cCliente		:= M->C5_CLIENTE
	 _cLojaCli		:= M->C5_LOJACLI
	_cTipoCli	 	:= M->C5_TIPOCLI 
	 nPos_OPER		:= aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_XOPER" } )
	 nPos_PRODUTO	:= aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_PRODUTO" } )
	 nPos_TES		:= aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_TES" } )
	 nPos_CF		:= aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_CF" } )
	 nPos_CLAS		:= aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_CLASFIS" } )	 	 
	_cUF	 		:= Posicione("SA1", 1, xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI, "A1_EST")
	_lContrib 		:= iif(Alltrim(Posicione("SA1", 1, xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI, "A1_CONTRIB"))<>"2",.T.,.F.)
	_cOper			:= aCols[N,nPos_OPER]
	_cProd			:= aCols[N,nPos_PRODUTO]
	_cTes     		:= aCols[N,nPos_TES] 
	_TESINT			:= _cTes	
		
// Chamado pelo Orзamento de Venda
Else	
	 _cCliente		:= M->CJ_CLIENTE
	 _cLojaCli		:= M->CJ_LOJA
	 _cTipoCli	 	:= M->CJ_TIPOCLI // M->CJ_XTPCLI 
	 nPos_OPER		:= aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "CK_XOPER" } )
	 nPos_PRODUTO	:= aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "CK_PRODUTO" } )
	 nPos_TES		:= aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "CK_TES" } ) 
//	 nPos_CF		:= aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "CK_CF" } )
	 nPos_CLAS		:= aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "CK_CLASFIS" } )	 
	_cUF	 		:= Posicione("SA1", 1, xFilial("SA1")+ M->CJ_CLIENTE + M->CJ_LOJA, "A1_EST")  
	_lContrib 		:= iif(Alltrim(Posicione("SA1", 1, xFilial("SA1")+M->CJ_CLIENTE+M->CJ_LOJA, "A1_CONTRIB"))<>"2",.T.,.F.)
	_cOper			:= TMP1->CK_XOPER //M->CK_XOPER // aCols[N,nPos_OPER]
	_cProd			:= TMP1->CK_PRODUTO //M->CK_PRODUTO // aCols[N,nPos_PRODUTO]
	_cTes     		:= TMP1->CK_TES //M->CK_TES // aCols[N,nPos_TES] 
	_TESINT			:= _cTes	

Endif
 	 

	// Busca TES INTELIGENTE DOMEX
	_TESINT := U_ReTesInt(_cOper,_cCliente,_cLojaCli,_cProd,_cTipoCli)[1]

	// Busca CLASSFIS 
	_CLASSPV := U_ReTClass(_cProd,_TESINT)

	// Atualiza TES no Array
	if _op == "1"
		aCols[N,nPos_TES]		:= _TESINT
		aCols[N,nPos_CF]		:= POSICIONE("SF4",1,xFilial("SF4")+_TESINT,"F4_CF")  
		aCols[N,nPos_CLAS]		:= _CLASSPV     
	else
		TMP1->CK_TES			:= _TESINT
		TMP1->CK_CLASFIS		:= _CLASSPV 	
	Endif


	//  Trata Mensagens e atualiza aCols no PEDIDO DE VENDA
	if _op == "1"	

		if _cUF <> "SP" .and. _cUF <> "EX"
			aCols[N,nPos_CF] := "6"+Substr(aCols[N,nPos_CF],2,3)
		elseif _cUF <> "SP" .and. _cUF == "EX"
			aCols[N,nPos_CF] := "7"+Substr(aCols[N,nPos_CF],2,3)
	   endif
  	
	    //MAURESI - 09/03/2020
		if !(_lContrib) .and. aCols[N,nPos_TES] $ "522"
			aCols[N,nPos_CF] := Substr(aCols[N,nPos_CF],1,1) + "108"
		Endif


		// Carrega Mensagens da TES
		M->C5_XMSGTES	:= ""
		For x := 1 to Len(aCols)
		  	_cMsg := U_ReMsgInt(_cOper,_cCliente,_cLojaCli,_cProd,_cTipoCli)
		  	if !(_cMsg $ M->C5_XMSGTES)
			  	M->C5_XMSGTES	+=_cMsg
		  	endif
		Next x

		// Atualiza Acols do PV
		GETDREFRESH()
		SetFocus(oGetDad:obrowse:hWnd)
		oGetDad:Refresh()
		A410LinOK(oGetDad)
	
 	Else  //Trata Dados, mensgens e atualzia aCols no ORCAMENTO
  	
		// Carrega Mensagens da TES

/*		M->C5_XMSGTES	:= ""
		For x := 1 to Len(aCols)
		  	_cMsg := U_ReMsgInt(_cOper,_cCliente,_cLojaCli,_cProd,_cTipoCli)
		  	if !(_cMsg $ M->C5_XMSGTES)
			  	M->C5_XMSGTES	+=_cMsg
		  	endif
		Next x
*/
		// Atualiza Acols do PV
		GETDREFRESH()
		SetFocus(oGetDad:obrowse:hWnd)
		oGetDad:Refresh()
	  //	A410LinOK(oGetDad)
	
	Endif

	

RestArea(_aSaveArea)
dbSelectArea( _cAlias )

Return(_TESINT)




/*/{Protheus.doc} DOMFT04C
// Importa Planilha de TES INTELIGENTE 
@author Marco Aurelio
@since 20/07/2016
@version undefined
@example
(examples)
@see (links_or_references)
/*/

User Function DOMFT04C()

//Local lRet        := .T.
Local cArquivo  	:= ""
Local cCadastro	:= OemToAnsi("Importaзгo de Planilha de TES INTELIGENTE")
Local nHandle   	:= 0
Local nOpca			:= 0
Local aButtons		:= {}
Local aSays			:= {}

Aadd(aSays,OemToAnsi( "Esta rotina realiza a Importaзгo dos registros de TES INTELIGENTE DOMEX - SAIDA. [.CSV]" ) )
Aadd(aButtons, { 1,.T.,{|| nOpca := 1, FechaBatch()}} )
Aadd(aButtons, { 2,.T.,{|| nOpca := 0, FechaBatch()}} )

FormBatch( cCadastro , aSays , aButtons )
	
IF nOpca == 0
	Return(.T.)
EndIF

cArquivo := Upper(Alltrim(cGetFile("Arquivos *.CSV|*.CSV","Selecione o arquivo para Importaзгo.")))

IF !Empty(cArquivo)
	nHandle	 := FT_FUSE(cArquivo)
	Processa( {|lEnd| LeArq() } , "Lendo Arquivo...")
	FClose(nHandle)
EndIF

Return


/*/{Protheus.doc} LeArq
// Importa Dados 
@author Eduardo Patriani
@since 24/04/2008
@version undefined
@example
(examples)
@see (links_or_references)
/*/
Static Function LeArq()

Local cBuffer
//Local cProduto
//Local cNumSerie                   
//Local cPlaqueta                   
//Local cGrupo
//Local aAtivo 		:= {}
//Local aAux      	:= {}

// PosicпїЅo dos Itens
Private nx_OPER			:= 01   		// OPERACAO
Private nx_CLIENT		:= 02			// CLIENTE
Private nx_LOJA			:= 03			// LOJA
Private nx_TPCLI		:= 04       // TIPO CLIENTE
Private nx_TES1			:= 05       // COM PPB - TES
Private nx_MSG101		:= 06       // COM PPB - MSG 01
Private nx_MSG102		:= 07       // COM PPB - MSG 02
Private nx_TES2			:= 08       // SEM PPB - TES
Private nx_MSG201		:= 09       // SEM PPB - MSG 01
Private nx_MSG202		:= 10       // SEM PPB - MSG 02
Private nx_TES3			:= 11       // PR IMPORTADO - TES
Private nx_MSG301		:= 12       // PR IMPORTADO - MSG01
Private nx_MSG302		:= 13       // PR IMPORTADO - MSG02
Private nx_TES4			:= 14       // PR COM ST
Private nx_MSG401		:= 15       // PR COM ST MSG01
Private nx_MSG402		:= 16       // PR COM ST MSG02
Private nx_NCM4			:= 17       // PR COM ST NCM
Private nx_TES5			:= 18       // PR SEM ST TES
Private nx_MSG501		:= 19       // PR SEM ST MSG01
Private nx_MSG502		:= 20       // PR SEM ST MSG02 
Private nx_NCM5			:= 21       // PR SEM ST NCM
Private nx_TES6			:= 22       // DRAW BACK - TES
Private nx_MSG601		:= 23       // DRAW BACK - MSG01
Private nx_MSG602		:= 24       // DRAW BACK - MSG02
Private nx_TES7			:= 25       // MATERIA PRIMA - TES
Private nx_MSG701		:= 26       // MATERIA PRIMA - MSG01
Private nx_MSG702		:= 27       // MATERIA PRIMA - MSG02

Private aAtivo 			:= {}
Private aAux      		:= {}

FT_FGOTOP()
ProcRegua(FT_FLASTREC())

While ! FT_FEOF()
	
	//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
	//пїЅ Leitura do arquivo texto.                                      пїЅ
	//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
	cBuffer := FT_FREADLN()
	aAux    := Str2Array(cBuffer,";")
	AAdd( aAtivo , aAux)
		
	IncProc()
	FT_FSKIP(1)	
EndDo          


// Valida planilha

lContinua :=  ValidaVetor()


IF lContinua .and. Len(aAtivo) > 0 

	// Comeca nX com 2 para ignorar Cabecalho
	For nX := 2 To Len(aAtivo)
		DbSelectArea("ZFM")

		ZFM->( dbSetOrder(1) )
		If !ZFM->( dbSeek(xfilial("ZFM")+aAtivo[nX,nx_OPER]+aAtivo[nX,nx_CLIENT]+aAtivo[nX,nx_LOJA]+aAtivo[nX,nx_TPCLI] ) )
//			RecLock("ZFM",.F.)
//		else
			RecLock("ZFM",.T.)
		
			ZFM->ZFM_FILIAL 		:= xFilial("ZFM")
			ZFM->ZFM_TIPO  			:= PadL(aAtivo[nX,nx_OPER],2,"0")
			ZFM->ZFM_CLIENT  		:= PadL(Alltrim(aAtivo[nX,nx_CLIENT]),6,"0")//aAtivo[nX,nx_CLIENT]        
			ZFM->ZFM_LOJACL			:= PadL(Alltrim(aAtivo[nX,nx_LOJA]),2,"0")//aAtivo[nX,nx_LOJA]         
			ZFM->ZFM_TPCLI			:= aAtivo[nX,nx_TPCLI]         
			ZFM->ZFM_TES1  			:= iif(!empty(Alltrim(aAtivo[nX,nx_TES1])),aAtivo[nX,nx_TES1],"999")     // aAtivo[nX,nx_TES1]
			ZFM->ZFM_VALID1  		:= "2"
			ZFM->ZFM_PV1			:= ""
			ZFM->ZFM_IT1			:= ""
			ZFM->ZFM_ID1			:= ""
			ZFM->ZFM_NOME1			:= ""
			ZFM->ZFM_DT1			:= ctod("  /  /  ")
			ZFM->ZFM_TES2  			:= aAtivo[nX,nx_TES2]
			ZFM->ZFM_VALID2  		:= "2"
			ZFM->ZFM_PV2			:= ""
			ZFM->ZFM_IT2			:= ""
			ZFM->ZFM_ID2			:= ""
			ZFM->ZFM_NOME2			:= ""
			ZFM->ZFM_DT2			:= ctod("  /  /  ")
			ZFM->ZFM_TES3  			:= aAtivo[nX,nx_TES3]
			ZFM->ZFM_VALID3  		:= "2"
			ZFM->ZFM_PV3			:= ""
			ZFM->ZFM_IT3			:= ""
			ZFM->ZFM_ID3			:= ""
			ZFM->ZFM_NOME3			:= ""
			ZFM->ZFM_DT3			:= ctod("  /  /  ")
			ZFM->ZFM_TES4  			:= aAtivo[nX,nx_TES4]
			ZFM->ZFM_VALID4  		:= "2"
			ZFM->ZFM_PV4			:= ""
			ZFM->ZFM_IT4			:= ""
			ZFM->ZFM_ID4			:= ""
			ZFM->ZFM_NOME4			:= ""
			ZFM->ZFM_DT4			:= ctod("  /  /  ")
			ZFM->ZFM_TES5  			:= aAtivo[nX,nx_TES5]
			ZFM->ZFM_VALID5  		:= "2"
			ZFM->ZFM_PV5			:= ""
			ZFM->ZFM_IT5			:= ""
			ZFM->ZFM_ID5			:= ""
			ZFM->ZFM_NOME5			:= ""
			ZFM->ZFM_DT5			:= ctod("  /  /  ")
			ZFM->ZFM_NCM4  			:= aAtivo[nX,nx_NCM4]
			ZFM->ZFM_NCM5  			:= aAtivo[nX,nx_NCM5]
			ZFM->ZFM_TES6  			:= aAtivo[nX,nx_TES6]
			ZFM->ZFM_VALID6  		:= "2"
			ZFM->ZFM_PV6			:= ""
			ZFM->ZFM_IT6			:= ""
			ZFM->ZFM_ID6			:= ""
			ZFM->ZFM_NOME6			:= ""
			ZFM->ZFM_DT6			:= ctod("  /  /  ")			
			ZFM->ZFM_TES7  			:= aAtivo[nX,nx_TES7]
			ZFM->ZFM_VALID7  		:= "2"
			ZFM->ZFM_PV7			:= ""
			ZFM->ZFM_IT7			:= ""
			ZFM->ZFM_ID7			:= ""
			ZFM->ZFM_NOME7			:= ""
			ZFM->ZFM_DT7			:= ctod("  /  /  ")			

			ZFM->ZFM_MSG101  		:= aAtivo[nX,nx_MSG101]
			ZFM->ZFM_MSG102  		:= aAtivo[nX,nx_MSG102]
			ZFM->ZFM_MSG201  		:= aAtivo[nX,nx_MSG201]
			ZFM->ZFM_MSG202  		:= aAtivo[nX,nx_MSG202]
			ZFM->ZFM_MSG301  		:= aAtivo[nX,nx_MSG301]
			ZFM->ZFM_MSG302  		:= aAtivo[nX,nx_MSG302]
			ZFM->ZFM_MSG401  		:= aAtivo[nX,nx_MSG401]
			ZFM->ZFM_MSG402  		:= aAtivo[nX,nx_MSG402]
			ZFM->ZFM_MSG501  		:= aAtivo[nX,nx_MSG501]
			ZFM->ZFM_MSG502  		:= aAtivo[nX,nx_MSG502]
			ZFM->ZFM_MSG601  		:= aAtivo[nX,nx_MSG601]
			ZFM->ZFM_MSG602  		:= aAtivo[nX,nx_MSG602]			
			ZFM->ZFM_MSG701  		:= aAtivo[nX,nx_MSG701]
			ZFM->ZFM_MSG702  		:= aAtivo[nX,nx_MSG702]			

			ZFM->ZFM_MSBLQL  		:= "2"
			ZFM->ZFM_CLIFOR			:= "C"
	
			MsUnlock()      
		endif

	Next nX
	
EndIF
MsgInfo("Final de Processamento...")

Return(Nil)



Static Function Str2Array(cString, cDelim, cStr)

Local aReturn := {}
Local cAux    := cString 
Local nPos    := 0
Local nI      := 0

Default cDelim := ";"
Default cStr   := ""

While At(cDelim, cAux) > 0
	nPos := At(cDelim, cAux)
	AAdd(aReturn, SubStr(cAux, 1, nPos-1))
	cAux := SubStr(cAux, nPos+1)
End
AAdd(aReturn, cAux)

If !Empty(cStr)
	For nI := 1 To Len(aReturn)
		aReturn[nI] := StrTran(aReturn[nI], cStr, " ")
		aReturn[nI] := AllTrim(aReturn[nI])
	Next nI
EndIf

Return(aReturn)         
                


Static Function ValidaVetor
Local lRet := .T.

SA1->(dbSetOrder(1))
SF4->(dbSetOrder(1))
  
	// Verifica se o Cliente Existe
	For nX := 2 To Len(aAtivo)
//		If !SA1->( dbSeek(xfilial("SA1")+aAtivo[nX,nx_CLIENT]+aAtivo[nX,nx_LOJA] ) )
		If !SA1->( dbSeek(xfilial("SA1")+PadL(Alltrim(aAtivo[nX,nx_CLIENT]),6,"0")+PadL(Alltrim(aAtivo[nX,nx_LOJA]),2,"0") ) )		
			MsgStop("Cliente "+PadL(Alltrim(aAtivo[nX,nx_CLIENT]),6,"0")+"-"+PadL(Alltrim(aAtivo[nX,nx_LOJA]),2,"0")+" informado na Linha " +Alltrim(Str(nX))+" nпїЅo estпїЅ cadastrado. Verifique!")
			lRet := .F.
		Endif                         
	Next nX

   // Verifica se pelo uma TES estпїЅ preenchida
	For nX := 2 To Len(aAtivo)
		If empty(Alltrim(aAtivo[nX,nx_TES1])) .and. empty(Alltrim(aAtivo[nX,nx_TES2])) .and. empty(Allttrim(aAtivo[nX,nx_TES3])) .and. empty(Alltrim(aAtivo[nX,nx_TES4])) .and. empty(Alltrim(aAtivo[nX,nx_TES5])) .and. empty(Allttrim(aAtivo[nX,nx_TES6])) .and. empty(Allttrim(aAtivo[nX,nx_TES7]))
			MsgStop("Na linha  " +Alltrim(Str(nX))+" precisa ter pelo uma TES informada. Verifique!")
			lRet := .F.
		Endif  								
	Next nX

   // Verifica se a TES existe no Cadastro
	For nX := 2 To Len(aAtivo)
		If !empty(aAtivo[nX,nx_TES1]) .and. !SF4->( dbSeek(xfilial("SF4")+aAtivo[nX,nx_TES1] ) )
			MsgStop("A TES "+aAtivo[nX,nx_TES1]+" informada na Linha " +Alltrim(Str(nX))+" nпїЅo estпїЅ cadastrada. Verifique!")
			lRet := .F.
		Endif  
		If !empty(aAtivo[nX,nx_TES2]) .and. !SF4->( dbSeek(xfilial("SF4")+aAtivo[nX,nx_TES2] ) )
			MsgStop("A TES "+aAtivo[nX,nx_TES2]+" informada na Linha " +Alltrim(Str(nX))+" nпїЅo estпїЅ cadastrada. Verifique!")
			lRet := .F.
		Endif  
		If !empty(aAtivo[nX,nx_TES3]) .and. !SF4->( dbSeek(xfilial("SF4")+aAtivo[nX,nx_TES3] ) )
			MsgStop("A TES "+aAtivo[nX,nx_TES3]+" informada na Linha " +Alltrim(Str(nX))+" nпїЅo estпїЅ cadastrada. Verifique!")
			lRet := .F.
		Endif  
		If !empty(aAtivo[nX,nx_TES4]) .and. !SF4->( dbSeek(xfilial("SF4")+aAtivo[nX,nx_TES4] ) )
			MsgStop("A TES "+aAtivo[nX,nx_TES4]+" informada na Linha " +Alltrim(Str(nX))+" nпїЅo estпїЅ cadastrada. Verifique!")
			lRet := .F.
		Endif  
		If !empty(aAtivo[nX,nx_TES5]) .and. !SF4->( dbSeek(xfilial("SF4")+aAtivo[nX,nx_TES5] ) )
			MsgStop("A TES "+aAtivo[nX,nx_TES5]+" informada na Linha " +Alltrim(Str(nX))+" nпїЅo estпїЅ cadastrada. Verifique!")
			lRet := .F.
		Endif
		If !empty(aAtivo[nX,nx_TES6]) .and. !SF4->( dbSeek(xfilial("SF4")+aAtivo[nX,nx_TES6] ) )
			MsgStop("A TES "+aAtivo[nX,nx_TES6]+" informada na Linha " +Alltrim(Str(nX))+" nпїЅo estпїЅ cadastrada. Verifique!")
			lRet := .F.
		Endif
		If !empty(aAtivo[nX,nx_TES7]) .and. !SF4->( dbSeek(xfilial("SF4")+aAtivo[nX,nx_TES7] ) )
			MsgStop("A TES "+aAtivo[nX,nx_TES7]+" informada na Linha " +Alltrim(Str(nX))+" nпїЅo estпїЅ cadastrada. Verifique!")
			lRet := .F.
		Endif  										
		
	Next nX

Return (lRet)