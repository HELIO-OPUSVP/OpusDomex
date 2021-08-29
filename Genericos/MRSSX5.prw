//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MRSSX5    �Autor  �Microsiga           � Data �  12/10/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �   Chamada:   u_MRSSX5("21", "Grupos de tributa��o")        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


//Vari�veis Est�ticas
Static cTitulo := ""
 
 
User Function MRSSX5(cTabela, cTitRot)
    Local aArea   := GetArea()
    Local oBrowse
    Local cFunBkp := FunName()
    Default cTabela := "21"
    Default cTitRot := "Grupos de tributa��o"
    Private cTabX := cTabela
     
    //Sen�o tiver chave, finaliza   
    If Empty(cTabela)
        Return
    EndIf
     
    DbSelectArea('SX5')
    SX5->(DbSetOrder(1)) // X5_FILIAL+X5_TABELA+X5_CHAVE
    SX5->(DbGoTop())
     
    //Se vier t�tulo por par�metro
    If !Empty(cTitRot)
        cTitulo := cTitRot
    EndIf
     
    //Se ainda tiver em branco, pega o da pr�pria tabela
    If Empty(cTitulo)
        //Se conseguir posicionar
        If SX5->(DbSeek(FWxFilial("SX5") + "00" + cTabela))
            cTitulo := SX5->X5_DESCRI
             
        Else
            MsgAlert("Tabela n�o encontrada!", "Aten��o")
            Return
        EndIf
    EndIf
     
    //Inst�nciando FWMBrowse - Somente com dicion�rio de dados
    SetFunName("MRSSX5")
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de cadastro de Autor/Interprete
    oBrowse:SetAlias("SX5")
 
    //Setando a descri��o da rotina
    oBrowse:SetDescription(cTitulo)
     
    //Filtrando
    oBrowse:SetFilterDefault("SX5->X5_TABELA = '"+cTabela+"'")
     
    //Ativa a Browse
    oBrowse:Activate()
     
    SetFunName(cFunBkp)
    RestArea(aArea)
Return
 
/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Fernando Bueno                                                |
 | Data:  05/08/2016                                                   |
 | Desc:  Cria��o do menu MVC                                          |
 *---------------------------------------------------------------------*/
 
Static Function MenuDef()
    Local aRot := {}
     
    //Adicionando op��es
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.MRSSX5' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.MRSSX5' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.MRSSX5' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.MRSSX5' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return aRot
 
/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Fernando Bueno                                                |
 | Data:  05/08/2016                                                   |
 | Desc:  Cria��o do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/
 
Static Function ModelDef()
    //Cria��o do objeto do modelo de dados
    Local oModel := Nil
     
    //Cria��o da estrutura de dados utilizada na interface
    Local oStSX5 := FWFormStruct(1, "SX5")
     
    //Editando caracter�sticas do dicion�rio
    oStSX5:SetProperty('X5_TABELA',   MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))                       //Modo de Edi��o
    oStSX5:SetProperty('X5_TABELA',   MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'cTabX'))                     //Ini Padr�o
    oStSX5:SetProperty('X5_CHAVE',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    'Iif(INCLUI, .T., .F.)'))     //Modo de Edi��o
    // oStSX5:SetProperty('X5_CHAVE',    MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'u_zSX5Chv()'))               //Valida��o de Campo 
    oStSX5:SetProperty('X5_CHAVE',    MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   '.T.'))               //Valida��o de Campo    
    oStSX5:SetProperty('X5_CHAVE',    MODEL_FIELD_OBRIGAT, .T. )                                                                //Campo Obrigat�rio
    oStSX5:SetProperty('X5_DESCRI',   MODEL_FIELD_OBRIGAT, .T. )                                                                //Campo Obrigat�rio
         
    //Instanciando o modelo, n�o � recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("MRSSX5M",/*bPre*/,/*bPos*/,/*bCommit*/,/*bCancel*/) 
     
    //Atribuindo formul�rios para o modelo
    oModel:AddFields("FORMSX5",/*cOwner*/,oStSX5)
     
    //Setando a chave prim�ria da rotina
    oModel:SetPrimaryKey({'X5_FILIAL', 'X5_TABELA', 'X5_CHAVE'})
     
    //Adicionando descri��o ao modelo
    oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)
     
    //Setando a descri��o do formul�rio
    oModel:GetModel("FORMSX5"):SetDescription("Formul�rio do Cadastro "+cTitulo)
Return oModel
 
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Fernando Bueno                                                |
 | Data:  05/08/2016                                                   |
 | Desc:  Cria��o da vis�o MVC                                         |
 *---------------------------------------------------------------------*/
 
Static Function ViewDef()
    //Cria��o do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
    Local oModel := FWLoadModel("MRSSX5")
     
    //Cria��o da estrutura de dados utilizada na interface do cadastro de Autor
    Local oStSX5 := FWFormStruct(2, "SX5")  //pode se usar um terceiro par�metro para filtrar os campos exibidos { |cCampo| cCampo $ 'SX5_NOME|SX5_DTAFAL|'}
     
    //Criando oView como nulo
    Local oView := Nil
 
    //Criando a view que ser� o retorno da fun��o e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formul�rios para interface
    oView:AddField("VIEW_SX5", oStSX5, "FORMSX5")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando t�tulo do formul�rio
    oView:EnableTitleView('VIEW_SX5', 'Dados - '+cTitulo )  
     
    //For�a o fechamento da janela na confirma��o
    oView:SetCloseOnOk({||.T.})
     
    //O formul�rio da interface ser� colocado dentro do container
    oView:SetOwnerView("VIEW_SX5","TELA")
     
    //Retira o campo de tabela da visualiza��o
    oStSX5:RemoveField("X5_TABELA")
Return oView