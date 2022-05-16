//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"

// MAURESI
//  FUNCAO GEN�RICA PARA CONSULTA ESPECIFICA - PORTAL XML
// https://www.blogadvpl.com/consulta-padrao-personalizada-f3/#page-content
//

User Function FiltroF3(cTitulo,cQuery,nTamCpo,cAlias,cCodigo,cCpoChave,cTitCampo,cMascara,cRetCpo,nColuna)
	/*
	+------------------+------------------------------------------------------------+
	!Modulo            ! Diversos                                                   !
	+------------------+------------------------------------------------------------+
	!Nome              ! FiltroF3                                                   !
	+------------------+------------------------------------------------------------+
	!Descricao         ! Fun��o usada para criar uma Consulta Padr�o  com SQL       !
	!			       !                                                            !
	!			       !                                                            !
	+------------------+------------------------------------------------------------+
	!Autor             ! Rodrigo Lacerda P Araujo                                   !
	+------------------+------------------------------------------------------------+
	!Data de Criacao   ! 03/01/2013                                                 !
	+------------------+-----------+------------------------------------------------+
	!Campo             ! Tipo	   ! Obrigatorio                                    !
	+------------------+-----------+------------------------------------------------+
	!cTitulo           ! Caracter  !                                                !
	!cQuery            ! Caracter  ! X                                              !
	!nTamCpo           ! Numerico  !                                                !
	!cAlias            ! Caracter  ! X                                              !
	!cCodigo           ! Caracter  !                                                !
	!cCpoChave         ! Caracter  ! X                                              !
	!cTitCampo         ! Caracter  ! X                                              !
	!cMascara          ! Caracter  !                                                !
	!cRetCpo           ! Caracter  ! X                                              !
	!nColuna           ! Numerico  !                                                !
	+------------------+-----------+------------------------------------------------+
	!Parametros:                                                                  !
	!==========		                                                        !
	!          																			   !
	!cTitulo = Titulo da janela da consulta                                         !
	!cQuery  = A consulta SQL que vem do parametro cQuery n�o pode retornar um outro!
	!nome para o campo pesquisado, pois a rotina valida o nome do campo real        !
	!          																			   !
	!Exemplo Incorreto                                                              !
	!cQuery := "SELECT A1_NOME 'NOME', A1_CGC 'CGC' FROM SA1010 WHERE D_E_L_E_T_='' !
	!          																			   !
	!Exemplo Certo                                                                  !
	!cQuery := "SELECT A1_NOME, A1_CGC FROM SA1010 WHERE D_E_L_E_T_=''              !
	!          																			   !
	!Deve-se manter o nome do campo apenas.                                         !
	!          																			   !
	!nTamCpo   = Tamanho do campo de pesquisar,se n�o informado assume 30 caracteres!
	!cAlias    = Alias da tabela, ex: SA1                                           !
	!cCodigo   = Conteudo do campo que chama o filtro                               !
	!cCpoChave = Nome do campo que ser� utilizado para pesquisa, ex: A1_CODIGO      ! 
	!cTitCampo = Titulo do label do campo                                           !
	!cMascara  = Mascara do campo, ex: "@!"                                         !
	!cRetCpo   = Campo que receber� o retorno do filtro                             !
	!nColuna   = Coluna que ser� retornada na pesquisa, padr�o coluna 1             !
	+--------------------------------------------------------------------------------
	*/
	Local nLista  
	Local cCampos 	:= ""
	Local bCampo		:= {}
	Local nCont		:= 0
	Local bTitulos	:= {}
	Local aCampos 	:= {}
	Local cTabela 
	Local cCSSGet		:= "QLineEdit{ border: 1px solid gray;border-radius: 3px;background-color: #ffffff;selection-background-color: #3366cc;selection-color: #ffffff;padding-left:1px;}"
	Local cCSSButton 	:= "QPushButton{background-repeat: none; margin: 2px;background-color: #ffffff;border-style: outset;border-width: 2px;border: 1px solid #C0C0C0;border-radius: 5px;border-color: #C0C0C0;font: bold 12px Arial;padding: 6px;QPushButton:pressed {background-color: #ffffff;border-style: inset;}"
	Local cCSSButF3	:= "QPushButton {background-color: #ffffff;margin: 2px;border-style: outset;border-width: 2px;border: 1px solid #C0C0C0;border-radius: 3px; border-color: #C0C0C0;font: Normal 10px Arial;padding: 3px;} QPushButton:pressed {background-color: #e6e6f9;border-style: inset;}"

	Private _oLista	:= nil
	Private _oDlg 	:= nil
	Private _oCodigo
	Private _cCodigo 	
	Private _aDados 	:= {}
	Private _nColuna	:= 0
	
	Default cTitulo 	:= ""
	Default cCodigo 	:= ""
	Default nTamCpo 	:= 30
	Default _nColuna 	:= 1
	Default cTitCampo	:= RetTitle(cCpoChave)
	Default cMascara	:= PesqPict('"'+cAlias+'"',cCpoChave)

	_nColuna	:= nColuna

	If Empty(cAlias) .OR. Empty(cCpoChave) .OR. Empty(cRetCpo) .OR. Empty(cQuery)
		MsgStop("Os parametro cQuery, cCpoChave, cRetCpo e cAlias s�o obrigat�rios!","Erro")
		Return
	Endif

	_cCodigo := Space(nTamCpo)
	_cCodigo := cCodigo

	cTabela:= CriaTrab(Nil,.F.)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cTabela, .F., .T.)
     
	(cTabela)->(DbGoTop())
	If (cTabela)->(Eof())
		MsgStop("N�o h� registros para serem exibidos!","Aten��o")
		Return
	Endif
   
	Do While (cTabela)->(!Eof())
		/*Cria o array conforme a quantidade de campos existentes na consulta SQL*/
		cCampos	:= ""
		aCampos 	:= {}
		For nX := 1 TO FCount()
			bCampo := {|nX| Field(nX) }
			If ValType((cTabela)->&amp;(EVAL(bCampo,nX)) ) == "M" .OR. ValType((cTabela)->&amp;(EVAL(bCampo,nX)) ) == "U"
				if ValType((cTabela)->&amp;(EVAL(bCampo,nX)) )=="C"
					cCampos += "'" + (cTabela)->&amp;(EVAL(bCampo,nX)) + "',"
				ElseIf ValType((cTabela)->&amp;(EVAL(bCampo,nX)) )=="D"
					cCampos +=  DTOC((cTabela)->&amp;(EVAL(bCampo,nX))) + ","
				Else
					cCampos +=  (cTabela)->&amp;(EVAL(bCampo,nX)) + ","
				Endif
					
				aadd(aCampos,{EVAL(bCampo,nX),Alltrim(RetTitle(EVAL(bCampo,nX))),"LEFT",30})
			Endif
		Next
     
     	If !Empty(cCampos) 
     		cCampos 	:= Substr(cCampos,1,len(cCampos)-1)
     		aAdd( _aDados,&amp;("{"+cCampos+"}"))
     	Endif
     	
		(cTabela)->(DbSkip())     
	Enddo
   
	DbCloseArea(cTabela)
	
	If Len(_aDados) == 0
		MsgInfo("N�o h� dados para exibir!","Aviso")
		Return
	Endif
   
	nLista := aScan(_aDados, {|x| alltrim(x[1]) == alltrim(_cCodigo)})
     
	iif(nLista = 0,nLista := 1,nLista)
     
	Define MsDialog _oDlg Title "Consulta Padr�o" + IIF(!Empty(cTitulo)," - " + cTitulo,"") From 0,0 To 280, 500 Of oMainWnd Pixel
	
	oCodigo:= TGet():New( 003, 005,{|u| if(PCount()>0,_cCodigo:=u,_cCodigo)},_oDlg,205, 010,cMascara,{|| /*Processa({|| FiltroF3P(M->_cCodigo)},"Aguarde...")*/ },0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"",_cCodigo,,,,,,,cTitCampo + ": ",1 )
	oCodigo:SetCss(cCSSGet)	
	oButton1 := TButton():New(010, 212," &amp;Pesquisar ",_oDlg,{|| Processa({|| FiltroF3P(M->_cCodigo) },"Aguarde...") },037,013,,,.F.,.T.,.F.,,.F.,,,.F. )
	oButton1:SetCss(cCSSButton)	
	    
	_oLista:= TCBrowse():New(26,05,245,90,,,,_oDlg,,,,,{|| _oLista:Refresh()},,,,,,,.F.,,.T.,,.F.,,,.f.)
	nCont := 1
        //Para ficar din�mico a cria��o das colunas, eu uso macro substitui��o "&amp;"
	For nX := 1 to len(aCampos)
		cColuna := &amp;('_oLista:AddColumn(TCColumn():New("'+aCampos[nX,2]+'", {|| _aDados[_oLista:nAt,'+StrZero(nCont,2)+']},PesqPict("'+cAlias+'","'+aCampos[nX,1]+'"),,,"'+aCampos[nX,3]+'", '+StrZero(aCampos[nX,4],3)+',.F.,.F.,,{|| .F. },,.F., ) )')
		nCont++
	Next
	_oLista:SetArray(_aDados)
	_oLista:bWhen 		 := { || Len(_aDados) > 0 }
	_oLista:bLDblClick  := { || FiltroF3R(_oLista:nAt, _aDados, cRetCpo)  }
	_oLista:Refresh()

	oButton2 := TButton():New(122, 005," OK "			,_oDlg,{|| Processa({|| FiltroF3R(_oLista:nAt, _aDados, cRetCpo) },"Aguarde...") },037,012,,,.F.,.T.,.F.,,.F.,,,.F. )
	oButton2:SetCss(cCSSButton)	
	oButton3 := TButton():New(122, 047," Cancelar "	,_oDlg,{|| _oDlg:End() },037,012,,,.F.,.T.,.F.,,.F.,,,.F. )
	oButton3:SetCss(cCSSButton)	

	Activate MSDialog _oDlg Centered	
Return(bRet)




Static Function FiltroF3R(nLinha,aDados,cRetCpo)
	cCodigo := aDados[nLinha,_nColuna]
	&amp;(cRetCpo) := cCodigo //Uso desta forma para campos como tGet por exemplo.
	bRet := .T.
	_oDlg:End()    
Return


/*
User Function ZZLF3()
	Local cTitulo		:= "Projetos"
	Local cQuery		:= "" 								//obrigatorio
	Local cAlias		:= "ZZL"							//obrigatorio
	Local cCpoChave	:= "ZZL_PROJET" 					//obrigatorio
	Local cTitCampo	:= RetTitle(cCpoChave)			//obrigatorio
	Local cMascara	:= PesqPict(cAlias,cCpoChave)	//obrigatorio
	Local nTamCpo		:= TamSx3(cCpoChave)[1]		
	Local cRetCpo		:= "M->cProjeto"					//obrigatorio
	Local nColuna		:= 1	
	Local cCodigo		:= M->cProjeto		//pego o conteudo e levo para minha consulta padr�o			
 	Private bRet 		:= .F.

   	//Monto minha consulta, neste caso quero retornar apenas uma coluna, mas poderia inserir outros campos para compor outras colunas no grid, lembrando que n�o posso utilizar um alias para o nome do campo, deixar o nome real.
   	//Posso fazer qualquer tipo de consulta, usando INNER, GROUPY BY, UNION's etc..., desde que mantenha o nome dos campos no SELECT.
   	cQuery := " SELECT DISTINCT ZZL_PROJET "
	cQuery += " FROM "+RetSQLName("ZZL") + " AS ZZL " //WITH (NOLOCK)
	cQuery += " WHERE ZZL_FILIAL  = '" + xFilial("ZZL") + "' "
	cQuery += " AND ZZL.D_E_L_E_T_= ' ' "
	cQuery += " ORDER BY ZZL_PROJET "

 	bRet := U_FiltroF3(cTitulo,cQuery,nTamCpo,cAlias,cCodigo,cCpoChave,cTitCampo,cMascara,cRetCpo,nColuna)
Return(bRet)
*/

User Function SC7PRT()
	Local cTitulo		:= "Portal XML"
	Local cQuery		:= "" 								//obrigatorio
	Local cAlias		:= "SC7"							//obrigatorio
	Local cCpoChave	    := "SC7_NUM"     					//obrigatorio
	Local cTitCampo	    := RetTitle(cCpoChave)			//obrigatorio
	Local cMascara	    := PesqPict(cAlias,cCpoChave)	//obrigatorio
	Local nTamCpo		:= TamSx3(cCpoChave)[1]		
	Local cRetCpo		:= "M->cProjeto"					//obrigatorio
	Local nColuna		:= 1	
	Local cCodigo		:= M->cProjeto		//pego o conteudo e levo para minha consulta padr�o			
 	Private bRet 		:= .F.

   	//Monto minha consulta, neste caso quero retornar apenas uma coluna, mas poderia inserir outros campos para compor outras colunas no grid, lembrando que n�o posso utilizar um alias para o nome do campo, deixar o nome real.
   	//Posso fazer qualquer tipo de consulta, usando INNER, GROUPY BY, UNION's etc..., desde que mantenha o nome dos campos no SELECT.
   	cQuery := " SELECT DISTINCT C7_NUM,C7_ITEM "
	cQuery += " FROM "+RetSQLName("SC7") + " AS SC7 " //WITH (NOLOCK)
	cQuery += " WHERE C7_FILIAL  = '" + xFilial("SC7") + "' "
	cQuery += " AND SC7.D_E_L_E_T_= ' ' "
	cQuery += " ORDER BY C7_NUM,C7_ITEM "

 	bRet := U_FiltroF3(cTitulo,cQuery,nTamCpo,cAlias,cCodigo,cCpoChave,cTitCampo,cMascara,cRetCpo,nColuna)
Return(bRet)
