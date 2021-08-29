#Include "Protheus.ch"
#Include "rwmake.ch"

/*/{Protheus.doc} User Function GESTOR341
    (Processa Arquivo de Retorno do Banco Itau e envia Boleto .PDF para Clientes)
    @type  Function
    @author Marco Aurelio (OPUSVP)
    @since 07/05/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/

User Function GESTOR341()

Local aCores := {{ "E1_PORTADO == '341' .and. E1_NUMBCO <> '' ", "BR_VERDE"    },;  // Enviado
                 { "F2_XABC == ' '", "BR_VERMELHO"   },;  // Não enviado
                 { "F2_XABC == 'N'", "BR_VERMELHO"   },;  // Não Enviado                   
				 { "E1_PORTADO <> '341' ", "BR_PRETO"     }}   // Não é Itau
Private cAlias := "SE1"

DbSelectArea(cAlias)
aRotina := {}

if !(__CUSERID $  getmv("MV_XCRDANA") ) .or. !(__CUSERID $ "000000" )
    MsgAlert("Usuário sem permissao para acessar esta rotina. Solicite acesso ao TI.")
    return
Endif

AADD(aRotina,{ "Pesquisar       ",'AxPesqui'     , 0, 1 } )
AADD(aRotina,{ "Visualizar      ",'AxVisual'     , 0, 2 } )
AADD(aRotina,{ "Importa Itau    ",'U_FLAGABC'  	 , 0, 3 } )
AADD(aRotina,{ "Envia Boleto    ",'U_LOGFINABC'	 , 0, 3 } )
AADD(aRotina,{ "Boleto Avulso   ",'U_LOGFINABC'	 , 0, 3 } )
AADD(aRotina,{ "Legenda         ",'U_LegABC'	 , 0, 3 } )   // 10

cCadastro := "Gerenciador Boletos - Banco ITAU"

set Filter to SF2->F2_XABC $ ' /S/N'
mBrowse( 6, 1,22,75,cAlias,,,,,,aCores,,,,,,,,)  
Set Filter To

Return



User Function FLAGABC()

Local _Retorno := .T.   

// Valida quais NFs podem ser processadas
if !(SF2->F2_XABC $ "P")  //__CUSERID $ getmv("MV_XCRDANA")

		cNota	:= SF2->F2_DOC
		dEmiss	:= SF2->F2_EMISSAO
        nVAlor  := SF2->F2_VALBRUT
        cStatus	:= SF2->F2_XABC
        aStatus	:= {'N=Não Enviar','S=Enviar'} 
        cCliente:= SF2->F2_CLIENTE+"/"+SF2->F2_LOJA+" - "+Alltrim( Posicione('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_NREDUZ'))

	    @ 000,000 TO 200,500 DIALOG oDlgDI TITLE  "Envia Nota Fiscal para Banco ABC" 
	      
	    @ 015, 005 SAY "Nota Fiscal:"
	    @ 015, 055 SAY cNota PICTURE "@!" SIZE 050,010
  
	    @ 015, 140 SAY "Cliente:"
        @ 015, 160 SAY cCliente PICTURE "@!" SIZE 100,010 
	      		      
	    @ 030, 005 SAY "Emissão da NF:"
	    @ 030, 055 SAY dEmiss PICTURE "@D" SIZE 50,10
 
	    @ 030, 140 SAY "Valor:"
	    @ 030, 160 SAY nVAlor PICTURE "999,999,999.99" SIZE 50,10  //F3 "SE4"

	    @ 045, 005 SAY "Status ABC: " //(N=Não Enviar / S=Enviar / P=Processado)"
	    @ 045, 055 COMBOBOX oCombo2  VAR cStatus ITEMS aStatus  SIZE 60,10  VALID .T. PIXEL 


	    //  @ 030, 160 SAY "Cond.Pag:"
	    // @ 030, 190 GET cCondP PICTURE "@!" SIZE 20,10 F3 "SE4"
	      	
	    @ 080,055 BUTTON "Confirmar" SIZE 040,012 ACTION _Gravar()
	    @ 080,110 BUTTON "Cancelar"  SIZE 040,012 ACTION _Sair()  
		ACTIVATE DIALOG oDlgDI CENTER

Else
	MsgAlert("NF já foi processa anteriormente. Favor verificar.")
Endif

Return _Retorno



Static Function _Gravar()

	if MsgYesNo("Confirma Gravação dos Dados ?")
		RecLock("SF2", .F.)
			SF2->F2_XABC	:= cStatus           
		   Close(oDlgDI)
		MsUnLock()
	Endif
                                                                                                
Return


Static Function _Sair()

	Close(oDlgDI)

Return


User Function LegABC()
Local cCadastro := "Legenda"

Local aCores := {	{ 'BR_VERDE'	, "Enviar ao Banco" 		},;
				 	{ 'BR_VERMELHO'	, "Não Enviar"				},;
				 	{ 'BR_PRETO' 	, "Não é Itaú" 				}}     
	                
BrwLegenda(cCadastro,"Cores",aCores)

Return( Nil)
