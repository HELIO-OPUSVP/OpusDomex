#INCLUDE "PROTHEUS.CH"
#INCLUDE "DBTREE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A200GRVE  �Autor  �Michel A. Sander    � Data �  05/16/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada ap�s altera��o da estrutura para verificar*��
���          � se existem OPs abertas e avisar o usuario			      ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function A200GRVE()

//������������������������������������������������������������������Ŀ
//� Salva a estrutura antiga								         �
//��������������������������������������������������������������������
Local aAreaGER := GetArea()
Local aAreaSG1 := SG1->( GetArea() )
LOCAL _aAntes  := {}
Local _lMod    := .T.
Local _cSal    := ''
Local _nAviso  := 0

//������������������������������������������������������������������Ŀ
//� Verifica EXCLUSAO									             �
//��������������������������������������������������������������������
If PARAMIXB[1] == 5

	_cSQL := "SELECT * FROM " + RETSQLNAME("SC2") + " (NOLOCK) WHERE "
	_cSQL += "C2_FILIAL = '01' AND C2_PRODUTO = '" + cProduto + "' AND "
	_cSQl += "D_E_L_E_T_ = '' AND C2_DATRF = ''"
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL),"TMP",.F.,.T.)
	If TMP->(!EOf())
	   cCodOP := ""
	   Do While TMP->(!Eof())
	      cCodOP += TMP->C2_NUM+TMP->C2_ITEM+TMP->C2_SEQUEN + CRLF
	      TMP->(dbSkip())
	   EndDo
      
		   If !Empty(cCodOp)                                
		      cMen := "Ordens de Produ��o em Aberto:"+CRLF
		      cMen += cCodOp
		      Aviso("Aten��o",cMen,{"Ok"})
		   Endif   
         
         /*
			_nAviso := Aviso("Aten��o","Existem Ordens de Produ��o em aberto com a estrutura alterada. Deseja visualizar ?",{"Sim","N�o"})
			If _nAviso == 1
				MsgRun("Procurando Ordens em Aberto...",,{|| A200View() } )
			EndIf
        */

	EndIf
	
	TMP->(dbCloseArea())

EndIf

//������������������������������������������������������������������Ŀ
//� Verifica ALTERACAO											                �
//��������������������������������������������������������������������
If PARAMIXB[1] == 4
	
	If Type("_aEstru") <> "U"
		If !Empty(_aEstru)
		   
			_aAntes := ACLONE(_aEstru)
			
			//������������������������������������������������������������������Ŀ
			//� Executa o ponto de entrada que explode estruturas                �
			//��������������������������������������������������������������������
			U_A200BOK()
			
			//������������������������������������������������������������������Ŀ
			//� Compara a estrutura antes e depois da altera��o                  �
			//��������������������������������������������������������������������
			//_lMod := A200VerificaEstru(@_aAntes,@_aEstru)
            _lMod :=.T.
			//������������������������������������������������������������������Ŀ
			//� Verifica Ordens de Producao em aberto	com a estrutura alterada   �
			//��������������������������������������������������������������������
			If _lMod  // _lMod == .T. == houve altera��o
				_cSQL := "SELECT TOP 1 R_E_C_N_O_ FROM " + RETSQLNAME("SC2") + " (NOLOCK) WHERE "
				_cSQL += "C2_FILIAL = '01' AND C2_PRODUTO = '" + CPRODUTO + "' AND "  // Variavel CPRODUTO usada no GET da tela de altera��o de Estruturas
				_cSQl += "D_E_L_E_T_ = '' AND C2_DATRF = ''"
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL),"TMP",.F.,.T.)
				If TMP->(!EOf())
				
				   //cCodOP := ""
				   //Do While TMP->(!Eof())
				   //   cCodOP += TMP->C2_NUM+TMP->C2_ITEM+TMP->C2_SEQUEN + CRLF
				   //   TMP->(dbSkip())
				   //EndDo
				   //If !Empty(cCodOp)                                
				   //   cMen := "Ordens de Produ��o em Aberto:"+CRLF
				   //   cMen += cCodOp
				   //   Aviso("Aten��o",cMen,{"Ok"})
				   //Endif   
				
					_nAviso := Aviso("Aten��o","Existem Ordens de Produ��o em aberto com a estrutura alterada. Deseja visualizar ?",{"Sim","N�o"})
					If _nAviso == 1
						MsgRun("Localizando Ordens de Produ��o em Aberto...",,{|| A200View(@_aAntes,@_aEstru) } )
					EndIf

				EndIf
				TMP->( dbCloseArea() )
							
			EndIf
				
		EndIf
	EndIf
	
EndIf

//������������������������������������������������������������������Ŀ
//� Verifica INCLUSAO		Mauricio 09/01/2017                       �
//��������������������������������������������������������������������

If PARAMIXB[1] == 3
	oProcess := TWFProcess():New( "000005", 'Estrutura de Produto (INCLUSAO)  - ' + CPRODUTO )// Variavel CPRODUTO usada no GET da tela de inclus�o de Esturutras
	
	oHTML := oProcess:oHTML
	
	oProcess:ClientName( Subs(cUsuario,7,15) )
	oProcess:track('100200','Estrutura de Produto (INCLUSAO)  - '+CPRODUTO,SUBSTR(cUSUARIO,7,15))
	cHtmlModelo := "\workflow\ESTR01.HTML"
	cAssunto := 'DOMEX - Estrutura de Produto (INCLUSAO)  - ' + CPRODUTO
	
	oProcess:NewTask(cAssunto, cHtmlModelo)
	
	oProcess:cSubject :='DOMEX - Estrutura de Produto (INCLUSAO)  - '+CPRODUTO
	
	cGRUPO  :=ALLTRIM(posicione('SB1',1,xFILIAL('SB1')+CPRODUTO,'B1_GRUPO'))
	IF cGRUPO  $('DIO|DIOE|TRUN|JUMP')
		cMAILTO :="gabriel.cenato@rosenbergerdomex.com.br, "
		cMAILTO +="debora.zani@rosenbergerdomex.com.br, "
		cMAILTO +="tatiane.alves@rosenbergerdomex.com.br, "
		cMAILTO +="monique.garcia@rosenbergerdomex.com.br, "
	 //	cMAILTO +="ulisses.ferraz@rosenbergerdomex.com.br, "
		cMAILTO +="fabiana.santos@rosenbergerdomex.com.br, "
		cMAILTO +="denis.vieira@rosenbergerdomex.com.br, mauricio.souza@opusvp.com.br,luiz.pavret@rdt.com.br, "
		cMAILTO +='natalia.silva@rosenbergerdomex.com.br,keila.gamt@rosenbergerdomex.com.br,leonardo.andrade@rosenbergerdomex.com.br,gabriel.cenato@rosenbergerdomex.com.br' //chamado monique 015475
		
		oProcess:cTo := cMAILTO
		
	ELSE
		oProcess:cTo := "mauricio.souza@opusvp.com.br"
	ENDIF
	oProcess:ohtml:ValByName( "cod"      , CPRODUTO      )
	oProcess:ohtml:ValByName( "desc"     , ALLTRIM(posicione('SB1',1,xFILIAL('SB1')+CPRODUTO,'B1_DESC' )))
	oProcess:ohtml:ValByName( "grupo"    , cGRUPO           )
	oProcess:ohtml:ValByName( "tipo"     , ALLTRIM(posicione('SB1',1,xFILIAL('SB1')+CPRODUTO,'B1_TIPO' )))
	//oProcess:ohtml:ValByName("usuario", Subs(cUsuario,7,15))
	//oProcess:ohtml:ValByName("proc_link","http://192.168.0.253:8011/wf/messenger/emp01/produto/" + cMailID + ".htm")
	cCODPRO:=CPRODUTO
	SG1->(DBSELECTAREA('SG1'))
	SG1->(DBSETORDER(1))
	IF SG1->(DBSEEK(xFILIAL('SG1')+cCODPRO))
		DO WHILE !SG1->(EOF()) .AND. SG1->G1_COD==cCODPRO
			IF SUBSTR(SG1->G1_COMP,1,5)=='50065'
				AAdd( (oProcess:ohtml:ValByName( "it.mod"  )),SG1->G1_COMP )
				AAdd( (oProcess:ohtml:ValByName( "it.dmod" )),ALLTRIM(posicione('SB1',1,xFILIAL('SB1')+SG1->G1_COMP,'B1_DESC' )) )
				AAdd( (oProcess:ohtml:ValByName( "it.qtde" )),SG1->G1_QUANT  )
			ENDIF
			SG1->(dbSkip())
		ENDDO
	ENDIF
	
	oProcess:Start()
	wfSendMail()
	oProcess:Finish()
	
EndIf

//Recalculo o custo do produto no Pedido de Venda em aberto e sem Ordem de Produ��o
//Osmar - Projeto Margem de lucro
U_CalCusto(cProduto)

RestArea(aAreaSG1)
RestArea(aAreaGER)

Return   Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A200VerificaEstru �Autor�Michel A. Sander � Data �05/16/14  ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica divergencias na estrutura antes e depois de uma   *��
���          � possivel altera��o						   					      ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

STATIC Function A200VerificaEstru(_aAntes,_aEstru)

LOCAL _lNovo   := .F.
LOCAL _lReturn := .F.

//������������������������������������������������������Ŀ
//� Verifica se foram inclu�dos novos itens na estrutura �
//��������������������������������������������������������
For x:= 1 to Len(_aEstru)
	_cProd := _aEstru[x,1]	// Produto Alterado
	_cItem := _aEstru[x,2] // Componente Alterado
	_nProcura:=ASCAN(_aAntes,{|x| x[1]==_cProd .And. x[2]==_cItem})
	If _nProcura == 0
		_lNovo := .T. 		// Configura Item Novo na altera��o de Estrutura
	EndIf
Next

//������������������������������������������������������Ŀ
//� Caso exista um novo item retorne para buscar Ops     �
//��������������������������������������������������������
If _lNovo
	Return ( .T. )
EndIf

//������������������������������������������������������Ŀ
//� Verifica se foram alteradas as quantidades			   �
//��������������������������������������������������������
For x:= 1 to Len(_aEstru)
	_cProd  := _aEstru[x,1]	// Produto Alterado
	_cItem  := _aEstru[x,2] 	// Componente Alterado
	_nQt    := _aEstru[x,3]   // Quantidade do Componente
	_nProcura:=ASCAN(_aAntes,{|x| x[1]==_cProd .And. x[2]==_cItem .And. x[3] <> _nQt})
	If _nProcura > 0
		_lReturn := .T.
	EndIf
Next

//������������������������������������������������������Ŀ
//� Verifica se foram exclu�dos itens na estrutura 		�
//��������������������������������������������������������
If Len(_aAntes) > Len(_aEstru)
	_lReturn := .T.
EndIf

Return ( _lReturn )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A200View  �Autor  �Michel A. Sander    � Data �  05/16/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Visualiza Ordens de Produ��o da Estrutura alterada         *��
���          � 												              ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static FUNCTION A200View(_aAntes,_aEstru)

LOCAL _oTree
LOCAL _oDlg
LOCAL _oFont
LOCAL _oPanel
LOCAL _nSaldoIni := 0
LOCAL _aSize     := MsAdvSize()
LOCAL _nTop      := 23
LOCAL _nLeft     := 5
LOCAL _nBottom   := _aSize[6]
LOCAL _nRight    := _aSize[5]
LOCAL _nOldEnch	:= 1
LOCAL _ni     	:= 0
LOCAL _bChange 	:= {|| Nil }
LOCAL _lMTC050PG := ExistBlock("MC050PERG")
LOCAL _aEnch[20]
LOCAL _aSavPerg:=MTC050Per(.T.) // Salva valor das perguntas existentes nesse momento
LOCAL _aMrp:={}
LOCAL _aTotais:={}
LOCAL _aSVAlias:={}
LOCAL _aButtons:={}

PRIVATE cCadastro:= "Visualiza��o de Ordens de Produ��o em Aberto"
PRIVATE _aParc050:=Array(40)

Pergunte("MTC050",.F.)
//MV_PAR06 := ""
//MV_PAR07 := "ZZ"

//������������������������������������������������������Ŀ
//� Salva as perguntas no array aParc050                 �
//��������������������������������������������������������
For _ni := 1 to Len(_aParc050)
	_aParc050[_ni] := &("mv_par"+StrZero(_ni,2))
Next _ni

//������������������������������������������������������Ŀ
//� Posiciona no produto pai da estrutura                �
//��������������������������������������������������������
SB1->(dbSeek(SG1->G1_FILIAL+SG1->G1_COD))

//������������������������������������������������������Ŀ
//� Carrega as variaveis de memoria do SB1               �
//��������������������������������������������������������
AADD(_aSVAlias,"SB1")
RegToMemory("SB1",.F.,.F.)

DEFINE FONT _oFont NAME "Arial" SIZE 0, -10
DEFINE MSDIALOG _oDlg TITLE cCadastro OF oMainWnd PIXEL FROM _nTop,_nLeft TO _nBottom,_nRight

_oFolder := TFolder():New(12,0,{"Informa��es da Estrutura"},{},_oDlg,,,, .T., .F.,_aSize[3],_nBottom-_nTop-12,)
_oFolder :aDialogs[1]:oFont := _oDlg:oFont
_oPanel := TPanel():New(2,160,'',_oFolder:aDialogs[1], _oDlg:oFont, .T., .T.,, ,(_nRight-_nLeft)/2-160,((_nBottom-_nTop)/2)-25,.T.,.T. )
_lOneColumn := If((_nRight-_nLeft)/2-178>312,.F.,.T.)
_aEnch[1]:= MsMGet():New("SB1",SB1->(RecNo()),2,,,,,{0,0,((_nBottom-_nTop)/2)-25,(_nRight-_nLeft)/2-160},,3,,,,_oPanel,,.T.,_lOneColumn)
_oTree := dbTree():New(2, 2,((_nBottom-_nTop)/2)-24,159,_oFolder:aDialogs[1],,,.T.)
_oTree:bChange := {|| IIF(Val(SubStr(_oTree:GetCargo(),6,12))<>0,Eval({||(SubStr(_oTree:GetCargo(),3,3))->(MsGoto(Val(SubStr(_oTree:GetCargo(),6,12)))),RegToMemory(SubStr(_oTree:GetCargo(),3,3),.F.,aScan(_aSVAlias,SubStr(_oTree:GetCargo(),3,3))==0)}),Nil),MTC050DlgV(@_oTree,_aSValias,@_aEnch,{0,0,((_nBottom-_nTop)/2)-24,(_nRight-_nLeft)/2-160},@_nOldEnch,@_oPanel,_aTotais,_aMrp,_nSaldoIni),Eval(_bChange)}
_oTree:SetFont(_oFont)
_oTree:lShowHint:= .F.

MTC050Tree(@_oTree,_aTotais,"",.F.,_aMrp,@_nSaldoIni)


ACTIVATE MSDIALOG _oDlg ON INIT EnchoiceBar(_oDlg,{||_oDlg:End()},{||_oDlg:End()},,_aButtons)
Release Object _oTree
Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MTC050DlgV� Autor �Rodrigo de A. Sartorio � Data �07-01-2002���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Funcao que mostra as informacoes detalhadas da consulta     ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Mtc050DlgV(ExpO1,ExpA1,ExpA2,ExpA3,ExpN1,ExpO2,ExpA4,   	  ���
���          �            ,ExpA5,ExpN2)                                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpO1 = Obj da Tree					                      ���
���          � ExpA1 = Array dos Alias					                  ���
���          � ExpA2 = Array aEnch 						                  ���
���          � ExpA3 = Array aPos						                  ���
���          � ExpN1 = Numero do aEnch anterior							  ���
���          � ExpO2 = Obj do Painel				                      ���
���          � ExpA4 = Array dos totais 			                      ���
���          � ExpA5 = Array das movimentacoes do MRP                     ���
���          � ExpN2 = Saldo inicial(SB2)    							  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum						                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �MATC050                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Mtc050DlgV(_oTree,_aSVAlias,_aEnch,_aPos,_nOldEnch,_oPanel,_aTotais,_aMrp,_nSaldoIni)

Local _k        := 0
Local _aDados   := {}
Local _cAlias	:= SubStr(_oTree:GetCargo(),3,3)
Local _nRecView	:= Val(SubStr(_oTree:GetCargo(),6,12))
Local _nPosAlias:= aScan(_aSVAlias,_cAlias)
Local _nPostotais:= Ascan(_aTotais,{|x| x[1]== SubStr(_oTree:GetCargo(),3,3)})
Local _lOneColumn:= If(_aPos[4]-_aPos[2]>312,.F.,.T.)
Local _lMTC050CP := ExistBlock("MTC050CP")
Local _oScroll
Local _aAcho := {}
Local _aCampos := { "C1_NUM","C1_ITEM","C1_PRODUTO","C1_UM","C1_QUANT","C1_SEGUM","C1_QTSEGUM","C1_DATPRF",;
"C1_LOCAL","C1_OBS","C1_OP","C1_CC","C1_CONTA","C1_ITEMCTA","C1_DESCRI","C1_FORNECE","C1_LOJA","C1_CLASS",;
"C1_CLVL","C1_SEQMRP","C1_EMISSAO" }

_oPanel:Hide()
_oPanel:FreeChildren()

If _nRecView <> 0
	dbSelectArea(_cAlias)
	MsGoto(_nRecView)
	RegtoMemory(_cAlias,.F.)                   
	_oPanel:Hide()
	MsMGet():New(_cAlias,(_cAlias)->(RecNo()),2,,,,,_aPos,,3,,,,_oPanel,,.T.,_lOneColumn)
Else
	If _nPosTotais > 0
		Do Case
			Case _cAlias == "SC2"
				AADD(_aDados,{_aTotais[_nPosTotais,2],""})
				AADD(_aDados,{"",""})
				AADD(_aDados,{"Quantidade",Transform(_aTotais[_nPosTotais,3],PesqPict("SC2","C2_QUANT",14))}) //"Quantidade"
				AADD(_aDados,{"Quantidade J� Entregue",Transform(_aTotais[_nPosTotais,4],PesqPict("SC2","C2_QUANT",14))}) //"Quantidade ja entregue"
				AADD(_aDados,{"Quantidade Perdida",Transform(_aTotais[_nPosTotais,5],PesqPict("SC2","C2_QUANT",14))}) //"Quantidade perdida"
				C040MatScrDisp(_aDados,@_oScroll,@_oPanel,_aPos,{{1,CLR_BLUE}})
		EndCase
		_aEnch[20]:=oScroll
		_aEnch[20]:Show()
		_nOldEnch:=20
	Else
		AADD(_aDados,{"Nao existem totais para essa consulta"}) //"Nao existem totais para essa consulta."
		AADD(_aDados,{""})
		AADD(_aDados,{"Pressione o botao na barra de ferramentas para expandir a consulta."}) //
		C040MatScrDisp(_aDados,@_oScroll,@_oPanel,_aPos,{{1,CLR_RED}})
		_aEnch[20]:=_oScroll
		_aEnch[20]:Show()
		_nOldEnch:=20
	EndIf
EndIf
// Mostra Painel
_oPanel:Show()
Return Nil


/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    �MTC050Tree� Autor �Rodrigo de A Sartorio  � Data � 12-12-2001 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Funcao que monta o Tree da consulta de produto                ���
���          �                                                              ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe   �MTC050Tree(ExpO1,ExpA1,ExpC1,ExpL1,ExpA2,ExpN1)           	���
���������������������������������������������������������������������������Ĵ��
���Parametros� ExpO1 = Obj da Tree					                        ���
���          � ExpA1 = Array dos totais 			                        ���
���          � ExpC1 = Alias					                 			���
���          � ExpL1 = indica se todos				                    	���
���          � ExpA2 = Array das movimentacoes do MRP                     	���
���          � ExpN1 = Saldo inicial(SB2)    							  	���
���������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum						                              	���
���������������������������������������������������������������������������Ĵ��
��� Uso      �MATC050                                                       ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/

Static Function MTC050Tree(_oTree,_aTotais,_cAlias,_lTodos,_aMrp,_nSaldoIni)

Local _aArea		:= GetArea(),_aAreaBack:={}
Local _cAliasTop	:=""
Local _cOldCargo	:=_oTree:GetCargo()
Local _lFirst	:= .T.
Local _lPyme 	:= If( Type( "__lPyme" ) <> "U", __lPyme, .F. )
Local _lTPSldSB2 := (GetMV('MV_TPSALDO')=="S")
Local _cWhile	:=""
Local _cIndTrab 	:= ""
Local _cIndexKey	:= ""
Local _cCond    	:= ""
Local _nIndex   	:= 0
Local _aTam     	:= 0
Local _aRet     	:= {}
Local _lReferencia := .F.
Local _i			:= 1
Local _lRet 		:= .T.
Local _aFornece 	:= {}
Local _lMC050FSC := ExistBlock("MC050FSC")
Local _uFilSC    := Nil
Local _cRetQry 	:= ""
DEFAULT _cAlias 	:= ""
DEFAULT _lTodos 	:= .F.

// Monta tree na primeira vez
If Empty(_cAlias) .And. !_lTodos
	_oTree:BeginUpdate()
	_oTree:Reset()
	_oTree:EndUpdate()
EndIf

_oTree:BeginUpdate()

If Empty(_cAlias) .And. !_lTodos
	//������������������������������������������������������Ŀ
	//� Verifica dados cadastrais do produto                 �
	//��������������������������������������������������������
	_oTree:TreeSeek("")
	_oTree:AddItem("Estrutura Modificada "+ALLTRIM(SG1->G1_COD)+Space(30),"01SB1"+StrZero(SB1->(Recno()),12),"PMSEDT3","PMSEDT3",,,1) //"Dados Cadastrais"
	dbSelectArea("SC2")
	_oTree:TreeSeek("01SB1"+StrZero(SB1->(Recno()),12))
	
	_aAreaBack:=GetArea()
	_cAliasTop := "SC2"
	_lQuery    := .F.
	#IFDEF TOP
		If TcSrvType()<>"AS/400"
			_lQuery:=.T.
			_cAliasTop := CriaTrab(NIL,.f.)
			_cQuery := "SELECT C2_FILIAL,C2_PRODUTO,C2_DATRF,C2_EMISSAO,C2_LOCAL,C2_NUM,C2_ITEM,C2_SEQUEN,"
			_cQuery += "C2_ITEMGRD,C2_QUANT,C2_QUJE,C2_PERDA,C2_DATPRF,SC2.R_E_C_N_O_ C2REC "
			_cQuery += "FROM "+RetSqlName("SC2")+" SC2 "
			_cQuery += "WHERE SC2.C2_FILIAL='"+xFilial("SC2")+"' AND "
			_cQuery += "SC2.C2_PRODUTO='" + SB1->B1_COD + "' AND "
			_cQuery += "SC2.C2_DATRF = '" + Space(Len(DTOS(SC2->C2_DATRF))) + "' AND "
			_cQuery += "SC2.D_E_L_E_T_=' ' "
			_cQuery += "ORDER BY "+SqlOrder(SC2->(IndexKey(2)))
			_cQuery := ChangeQuery(_cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAliasTop,.T.,.T.)
			TCSetField( _cAliasTop, "C2_DATRF",   "D", 8, 0)
			TCSetField( _cAliasTop, "C2_EMISSAO", "D", 8, 0)
			_aTam := TamSx3("C2_QUANT")
			TCSetField( _cAliasTop, "C2_QUANT",   "N", _aTam[1], _aTam[2])
			_aTam := TamSx3("C2_QUJE")
			TCSetField( _cAliasTop, "C2_QUJE",    "N", _aTam[1], _aTam[2])
			_aTam := TamSx3("C2_PERDA")
			TCSetField( _cAliasTop, "C2_PERDA",   "N", _aTam[1], _aTam[2])
			TCSetField( _cAliasTop, "C2_DATPRF",  "D", 8, 0)
		Endif
	#ENDIF
	dbSelectArea(_cAliasTop)
	If !_lQuery
		dbSetOrder(2)
		dbSeek(xFilial("SC2")+SB1->B1_COD)
	Endif
	If !Eof()
		_oTree:TreeSeek("02SC2"+StrZero(0,12))
		_lFirst:=.T.
		While !Eof() .and. (_lQuery .Or. C2_FILIAL+C2_PRODUTO == xFilial("SC2")+SB1->B1_COD)
			If _lFirst
				AADD(_aTotais,{"SC2","Totais Ordens de Producao",0,0,0}) //"Totais "###"Ordens de Producao"
				_lFirst:=.F.
			Endif
			_oTree:AddItem(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD,"02SC2"+StrZero(If(_lQuery,C2REC,Recno()),12),"PMSDOC","PMSDOC",,,2)
			_aTotais[Len(_aTotais),3]+=C2_QUANT // Quantidade
			_aTotais[Len(_aTotais),4]+=C2_QUJE  // Quantidade ja entregue
			_aTotais[Len(_aTotais),5]+=C2_PERDA // Quantidade perdida
			a050MRP(_aMrp,If(C2_DATPRF < dDatabase,dDataBase,C2_DATPRF),(C2_QUANT - C2_QUJE - C2_PERDA),"E")
			dbSkip()
		End
	Endif
	If _lQuery
		dbSelectArea(_cAliasTop)
		dbCloseArea()
		dbSelectArea("SC2")
	Else
		RestArea(_aAreaBack)
	EndIf
ElseIf Empty(_cAlias) .And. !_lTodos
	
EndIf

_oTree:EndUpdate()
_oTree:Refresh()
If _lTodos
	oTree:TreeSeek(_cOldCargo)
EndIf

RestArea(_aArea)

Return Nil

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    �C040MatScrDisp� Autor �Rodrigo de A. Sartorio� Data � 20-12-01���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Monta scroll box com texto dinamico                           ���
���          �                        			                        ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe   �C040MatScrDisp(ExpA1,ExpO1,ExpO2,ExpA2,ExpA3,ExpA4)          	���
���������������������������������������������������������������������������Ĵ��
���Parametros� ExpA1 = Array das informacoes		                        ���
���          � ExpO1 = Obj scroll		 			                        ���
���          � ExpO2 = Obj do Painel	 			                        ���
���          � ExpA2 = Array do aPos			                 			���
���          � ExpA3 = Array de Cores (Cols) 		        OPC      		���
���          � ExpA4 = Array de Cores (Lines)	            OPC  			���
���������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum						                              	���
���������������������������������������������������������������������������Ĵ��
��� Uso      �Generico                                                      ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function C040MatScrDisp(_aInfo,_oScroll,_oPanel,_aPos,_aCoresCols,_aCoresLines)

Local _nX,_ny,_nAchou
Local _cCor,_cCorDefault:=CLR_BLACK
Local _nCols   :=1,_nSomaCols:=0
Local _nLinAtu := 5
Local _nColAtu := 45
Local _nColIni := 0
Local _uInfo   := Nil
Local _oBmp
DEFAULT _aCoresCols:={}
DEFAULT _aCoresLines:={}
DEFINE FONT _oFont NAME "Arial" SIZE 0,-11 BOLD

If Len(_aInfo) > 0
	_oScroll:= TScrollBox():New(_oPanel,_aPos[1],_aPos[2],_aPos[3],_aPos[4])
	@ 0,0 BITMAP _oBmp RESNAME "LOGIN" oF _oScroll SIZE 45,_aPos[3] ADJUST NOBORDER WHEN .F. PIXEL
	_nCols:=Len(_aInfo[1])
	For _nx := 1 to Len(_aInfo)
		For _ny := 1 to _nCols
			If CalcFieldSize("C",Len(_aInfo[_nx,_ny]),0) > _nSomaCols
				_nSomaCols:=CalcFieldSize("C",Len(_aInfo[_nx,_ny]),0)
			EndIf
		Next _ny
	Next
	_ny := 1
	For _nx := 1 to Len(_aInfo)
		_nAchou  := Ascan(_aCoresLines,{|x| x[1]== _nx})
		If _nAchou > 0
			_cCor:=_aCoresLines[_nAchou,2]
		Else
			_cCor:=_cCorDefault
		EndIf
		_nAchou  := Ascan(_aCoresCols,{|x| x[1]== _ny})
		If _nAchou > 0
			_cCor:=_aCoresCols[_nAchou,2]
		EndIf
		_cTextSay:= "{||' "+STRTRAN(_aInfo[_nx][_ny],"'",'"')+" '}"
		_oSay    := TSay():New(_nLinAtu,_nColAtu,MontaBlock(_cTextSay),_oScroll,,_oFont,,,,.T.,_cCor,,,,,,,,)
		_nLinAtu += 9
	Next
	_nLinAtu := 5
	aEval(_aInfo, {|z| _nColIni := Max(_nColIni, CalcFieldSize("C",Len(z[1]),0))})
	_nColIni := _nColIni * 0.9
	_nColAtu := _nColIni
	For _nx := 1 to Len(_aInfo)
		For _ny := 2 to _nCols
			_nAchou  := Ascan(_aCoresLines,{|x| x[1]== _nx})
			If _nAchou > 0
				_cCor:=_aCoresLines[_nAchou,2]
			Else
				_cCor:=_cCorDefault
			EndIf
			_nAchou  := Ascan(_aCoresCols,{|x| x[1]== _ny})
			If _nAchou > 0
				_cCor:=_aCoresCols[_nAchou,2]
			EndIf
			_cTextSay:= "{||' "+STRTRAN(_aInfo[_nx][_ny],"'",'"')+" '}"
			_oSay    := TSay():New(_nLinAtu,_nColAtu,MontaBlock(_cTextSay),_oScroll,,_oFont,,.T.,,.T.,_cCor,,,,,,,,)
			_nColAtu += _nSomaCols
		Next ny
		_nLinAtu += 9
		_nColAtu := _nColIni
	Next
EndIf
Return Nil

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    �MatScrDisp � Autor �Rodrigo de A. Sartorio� Data � 20-12-2001 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Monta scroll box com texto dinamico                           ���
���          �                       			                            ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe   � MatScrDisp(ExpA1,ExpO1,ExpO2,ExpA2,ExpA3,ExpA4)          	���
���������������������������������������������������������������������������Ĵ��
���Parametros� ExpA1 = Array das informacoes		                        ���
���          � ExpO1 = Obj scroll		 			                        ���
���          � ExpO2 = Obj do Painel	 			                        ���
���          � ExpA2 = Array do aPos			                 			���
���          � ExpA3 = Array de Cores (Cols) 		        OPC      		���
���          � ExpA4 = Array de Cores (Lines)	            OPC  			���
���������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum						                              	���
���������������������������������������������������������������������������Ĵ��
��� Uso      �Generico                                                      ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function MatScrDisp(_aInfo,_oScroll,_oPanel,_aPos,_aCoresCols,_aCoresLines)

Local _nX,_ny,_nAchou
Local _cCor,_cCorDefault:=CLR_BLACK
Local _nCols   :=1,_nSomaCols:=0
Local _nLinAtu := 5
Local _nColAtu := 45
Local _oBmp
DEFAULT _aCoresCols:={}
DEFAULT _aCoresLines:={}
DEFINE FONT _oFont NAME "Arial" SIZE 0,-11 BOLD
If Len(_aInfo) > 0
	_oScroll:= TScrollBox():New(_oPanel,_aPos[1],_aPos[2],_aPos[3],_aPos[4])
	@ 0,0 BITMAP _oBmp RESNAME "LOGIN" oF _oScroll SIZE 45,_aPos[3] ADJUST NOBORDER WHEN .F. PIXEL
	_nCols:=Len(_aInfo[1])
	For _nx := 1 to Len(_aInfo)
		For _ny := 1 to _nCols
			If CalcFieldSize("C",Len(_aInfo[_nx,_ny]),0) > _nSomaCols
				_nSomaCols:=CalcFieldSize("C",Len(_aInfo[_nx,_ny]),0)
			EndIf
		Next _ny
	Next
	For _nx := 1 to Len(_aInfo)
		For _ny := 1 to _nCols
			_nAchou  := Ascan(_aCoresLines,{|x| x[1]== _nx})
			If _nAchou > 0
				_cCor:=aCoresLines[_nAchou,2]
			Else
				_cCor:=_cCorDefault
			EndIf
			_nAchou  := Ascan(_aCoresCols,{|x| x[1]== _ny})
			If _nAchou > 0
				_cCor:=aCoresCols[_nAchou,2]
			EndIf
			_cTextSay:= "{||' "+STRTRAN(_aInfo[_nx][_ny],"'",'"')+" '}"
			_oSay    := TSay():New(_nLinAtu,_nColAtu,MontaBlock(_cTextSay),_oScroll,,_oFont,,,,.T.,_cCor,,,,,,,,)
			_nColAtu += _nSomaCols
		Next ny
		_nLinAtu += 9
		_nColAtu := 45
	Next
EndIf
Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MCTC050Per� Autor � Rodrigo de A. Sartorio� Data � 06/05/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Salva / Restaura as perguntas existentes                   ���
���          �                       			                          ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpA1 := MTC050Per(ExpL1,ExpA1)                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpL1 = Se .T. salva as perguntas, se .F. restaura   (OPC) ���
���          � ExpA1 = Array das perguntas 							(OPC) ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � ExpA1 = Array das perguntas	                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATC050                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MTC050Per(_lSalvaPerg,_aPerguntas)

Local _ni
DEFAULT _lSalvaPerg:=.F.
DEFAULT _aPerguntas:=Array(40)
For _ni := 1 to Len(_aPerguntas)
	If _lSalvaPerg
		_aPerguntas[_ni] := &("mv_par"+StrZero(_ni,2))
	Else
		&("mv_par"+StrZero(_ni,2)) :=	_aPerguntas[_ni]
	EndIf
Next _ni
Return(_aPerguntas)
