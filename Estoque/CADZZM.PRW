/*Importar as bibliotecas*/
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
/*Iniciando sua fun��o*/
User Function CADZZM()
        /*Declarando as vari�veis que ser�o utilizadas*/
    //Local lRet := .T.
    Local aArea := ZZM->(GetArea())
    Private oBrowse
    Private cChaveAux := ""
    //Iniciamos a constru��o b�sica de um Browse.
    oBrowse := FWMBrowse():New()
    //Definimos a tabela que ser� exibida na Browse utilizando o m�todo SetAlias
    oBrowse:SetAlias("ZZM")
    //Definimos o t�tulo que ser� exibido como m�todo SetDescription
    oBrowse:SetDescription("Cadastro de Operador -  Perdas")
    
    //Adiciona um filtro ao browse
    //oBrowse:SetFilterDefault( "X5_TABELA == '21'" )
    
    //Chama o menu
    oBrowse:SetMenuDef( 'CADZZM' )
    
    //Desliga a exibi��o dos detalhes
    //oBrowse:DisableDetails()
    
        //Ativamos a classe
    oBrowse:Activate()
        RestArea(aArea)
Return


//-------------------------------------------------------------------
// Montar o menu Funcional
//-------------------------------------------------------------------
Static Function MenuDef()
    Local aRotina := {}
    ADD OPTION aRotina TITLE "Pesquisar"      ACTION 'PesqBrw'         OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE "Visualizar"     ACTION "VIEWDEF.CADZZM" OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir"        ACTION "VIEWDEF.CADZZM" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar"        ACTION "VIEWDEF.CADZZM" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluir"        ACTION "VIEWDEF.CADZZM" OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE "Imprimir"       ACTION "VIEWDEF.CADZZM" OPERATION 8 ACCESS 0
    ADD OPTION aRotina TITLE "Copiar"         ACTION "VIEWDEF.CADZZM" OPERATION 9 ACCESS 0
Return aRotina


Static Function ViewDef()
    Local oView
    Local oModel := ModelDef()
    Local oStr1:= FWFormStruct(2, 'ZZM')
    
    // Cria o objeto de View
    oView := FWFormView():New()
    
    // Define qual o Modelo de dados ser� utilizado
    oView:SetModel(oModel)
    
    //Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
    oView:AddField('Formulario' , oStr1,'CamposZZM' )
    
    //Remove os campos que n�o ir�o aparecer    
    //oStr1:RemoveField( 'X5_DESCENG' )
    //oStr1:RemoveField( 'X5_DESCSPA' )
    
    // Criar um "box" horizontal para receber algum elemento da view
    oView:CreateHorizontalBox( 'PAI', 100)
    
    // Relaciona o ID da View com o "box" para exibicao
    oView:SetOwnerView('Formulario','PAI')
    oView:EnableTitleView('Formulario' , 'Usuarios' )    
    oView:SetViewProperty('Formulario' , 'SETCOLUMNSEPARATOR', {10})
    
    //For�a o fechamento da janela na confirma��o
    oView:SetCloseOnOk({||.T.})
    
Return oView

Static Function ModelDef()
    Local oModel
    Local oStr1:= FWFormStruct( 1, 'ZZM', /*bAvalCampo*/,/*lViewUsado*/ ) // Constru��o de uma estrutura de dados
    
    //Cria o objeto do Modelo de Dados
        //Irie usar uma fun��o CADZZMV que ser� acionada quando eu clicar no bot�o "Confirmar"
    oModel := MPFormModel():New('Usuarios', /*bPreValidacao*/, { | oModel |( oModel ) } , /*{ | oMdl | CADZZMC( oMdl ) }*/ ,, /*bCancel*/ )
    oModel:SetDescription('Usuarios')
    
    //Abaixo irei iniciar o campo ZZM_CODIGO com o conteudo da sub-tabela
    //oStr1:SetProperty('ZZM_CODIGO', MODEL_FIELD_INIT,{|| ZZM->ZZM_CODIGO} )
    
    //Abaixo irei bloquear/liberar os campos para edi��o
    oStr1:SetProperty('ZZM_CODIGO' , MODEL_FIELD_WHEN,{|| .F. })
    //Podemos usar as fun��es INCLUI ou ALTERA
    //oStr1:SetProperty('X5_CHAVE'  , MODEL_FIELD_WHEN,{|| INCLUI })
    
    //Ou usar a propriedade GetOperation que captura a opera��o que est� sendo executada
    oStr1:SetProperty("ZZM_CODIGO"  , MODEL_FIELD_WHEN,{|oModel| oModel:GetOperation()== 3 })
    
    //oStr1:RemoveField( 'X5_DESCENG' )
    //oStr1:RemoveField( 'X5_DESCSPA' )
    //oStr1:RemoveField( 'X5_FILIAL' )
    
    // Adiciona ao modelo uma estrutura de formul�rio de edi��o por campo
    oModel:addFields('CamposZZM',,oStr1,{|oModel|(oModel)},,)
    
    //Define a chave primaria utilizada pelo modelo
    oModel:SetPrimaryKey({'ZZM_FILIAL', 'ZZM_CODIGO'})
    
    // Adiciona a descricao do Componente do Modelo de Dados
    oModel:getModel('CamposZZM'):SetDescription('TabelaZZM')
    
Return oModel

//Esta fun��o ser� executada no inicio do carregamento da tela, neste exemplo irei
//apenas armazenar numa vari�vel o conteudo de um campo
Static Function CADZZMT( oModel )
    Local lRet      := .T.
    Local oModelZZM := oModel:GetModel( 'CamposZZM' )
    
    cChaveAux := ZZM->ZZM_CODIGO

Return(lRet)


//-------------------------------------------------------------------
// Valida��es ao salvar registro
// Input: Model
// Retorno: Se erros foram gerados ou n�o
//-------------------------------------------------------------------
Static Function CADZZMV( oModel )
    Local lRet      := .T.
    Local oModelZZM := oModel:GetModel( 'CamposZZM' )
    Local nOpc      := oModel:GetOperation()
    Local aArea     := GetArea()
    //Capturar o conteudo dos campos
    Local cChave    := oModelZZM:GetValue('ZZM_CODIGO')    
    Local cNome    := oModelZZM:GetValue('ZZM_NOME')
    
    Begin Transaction
        
        if nOpc == 3 .or. nOpc == 4
           
            dbSelectArea("ZZM")
            ZZM->(dbSetOrder(1))
            ZZM->(dbGoTop())
            If(ZZM->(dbSeek(xFilial("ZZM")+cChave)))
                if cChaveAux != cChave
                    SFCMsgErro("A chave "+Alltrim(cChave)+" ja foi informada!","CADZZM")
                    lRet := .F.
                Endif
            Endif
            if Empty(cChave)
                SFCMsgErro("O campo chave � obrigat�rio!","CADZZM")
                lRet := .F.
            Endif
            
            if Empty(cNome)
                SFCMsgErro("O campo descri��o � obrigat�rio!","CADZZM")
                lRet := .F.
            Endif
            
        Endif
        
        if !lRet
            DisarmTransaction()
        Endif
        
    End Transaction
    
    RestArea(aArea)
    
    FwModelActive( oModel, .T. )
    
Return lRet
