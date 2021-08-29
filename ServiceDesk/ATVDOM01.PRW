#include "rwmake.ch"
#include "totvs.ch"
#include "topconn.ch"
#include "TbiCode.ch"
#include "protheus.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³   ºAutor  ³Jonas Pereira      º Data ³  26/12/2019   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³CADASTRO DE ATIVOS DE TI                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ATVDOM01()

Private aFixe     := {}
Private aCores    := {}
Private aRotina   := {}
Private cCadastro := ""
Private lGatilha  := .T.  //Para validacao no MATA120 - Para preencher aCols em funcoes chamadas da validacao (X3_VALID)
Private CA120NUM          //Para validacao no MATA120
Private cItem             //Para validacao no MATA120
Private nTipoped   := 1   //Para validacao no MATA120
Private aHead          := {}                                              // Array do aHeader
Private aCols          := {}                                              // Array do aCols
PRIVATE n := 1
Private cTexto       := ''
Private oMemo1
Private nPosAdcao   := Nil
Private nPosNFE     := Nil
Private nPosCnt     := Nil
Private nPosPed     := Nil
Private oGdAdicao1  := Nil
Private oGdAdicao2  := Nil
Private oGdAdicao3  := Nil
Private oGdAdicao4  := Nil
Private nLinha      := 1
Private aIndArq     := {}
Private cQuery      := ""
Private oGdItm01
Private cRevAnt     := ""
Private lRevisa     := .f.
Private cLog        := ""
Private cDados      := ""
Private _CMOTIVO    := SPACE(100)

#DEFINE ENTER CHAR(13) + CHAR(10)

aFixe     := {}
cCadastro := OemtoAnsi("CADZZC() - Cadastro de Ativos de TI")

aRotina  := { ;
{ "Pesquisar"                , "Axpesqui"      , 0 , 1},;
{ "Visualiza"                , "U_RZZCCadF"    , 0 , 2},;
{ "Inclui"                   , "U_RZZCCadF"    , 0 , 3},;
{ "Altera"                   , "U_RZZCCadF"    , 0 , 4},;
{ "Excluir"                  , "U_RZZCCadF"    , 0 , 5},;
{ "Filtro"                   , "U_FILZZC"      , 0 , 6},;
{ "Legenda"                  , 'U_FINMZZCLeg()' , 0 , 8} }

aCores   := { { "ZZC_STATUS == 'A' " , 'BR_VERDE'    },;     // Ativo
			  { "ZZC_STATUS == 'B' " , 'BR_VERMELHO'  } }     // Bloqueado


dbSelectarea("ZZC")
dbSetOrder(1)


//mBrowse(6,1,22,75,"ZZC",aFixe,,,,,aCores,,,,U_ATVMAIL1(),)
mBrowse(6,1,22,75,"ZZC",aFixe,,,,,aCores,,,,,)


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINM06Leg ºAutor  ³ OpusVP           º Data ³  03/29/2011   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RFINM06                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FINMZZCLeg()

BrwLegenda(cCadastro,"legenda",{	{"BR_VERMELHO" ,"Bloqueado"                   } ,;
									{"BR_VERDE"    ,"Ativo"  				      } })

Return(.T.)

User Function RZZCCadF(cAlias,nReg,nOpc)


Local nRecZZC := IIf(nOpc==3,Nil,ZZC->(Recno()))

Private nSaveSx8Len := (cAlias)->(GetSx8Len())

Private oDialg
Private oEnchc
Private oFolder

Private aFolder    := {}
Private aExibe     := {}
Private aGets      := {}
Private aTela      := {}
Private aGets1     := {}
Private aTela1     := {}
Private aButtons   := {}
Private nOpcao     := 0
Private bOk        := { || IIf(nOpc==3.Or.nOpc==4,IIf(Obrigatorio(aGets1,aTela1) .And. U_RFMZZCVld("CABEC",INCLUI) /*.And. oGdAdicao:TudoOk()*/ , (nOpcao:=1,oDialg:End()) , nOpcao := 0),(nOpcao:=1,oDialg:End())) }
Private bCancel    := { || nOpcao:=0 , oDialg:End() }
Private nSuperior  := 0
Private nEsquerda  := 0
Private nInferior  := 0
Private nDireita   := 0
Private aSizeAut   := {}
Private aObjects   := {}
Private aInfo      := {}
Private aPosGet    := {}
Private aPosObj    := {}

Default cAlias    := "ZZC"
Default nReg      := IIf(nOpc==3,Nil,(cAlias)->(Recno()))

/*
AADD(aButtons, { 'SDUPROP' ,{ || ImpProds(1) }, "Imp. Cotação a Fornecedor"             , "Importar Cotação"                      } )
AADD(aButtons, { 'SDUPROP' ,{ || ImpProds(2) }, "Importar Tabela Preços"                , "Importar Tabela Preços"                } )
AADD(aButtons, { 'SDUPROP' ,{ || ImpProds(3) }, "Importar Amarração Prod. x Fornecedor" , "Importar Amarração Prod. x Fornecedor" } )
AADD(aButtons, { 'SDUPROP' ,{ || ImpProds(5) }, "Importar Solicitação de Compras"       , "Importar Solicitação de Compras"       } )
AADD(aButtons, { 'SDUPROP' ,{ || ImpProds(4) }, "Adicionar Produtos"                    , "Adicionar Produtos"                    } )
  */

// Maximizacao da tela em relação a area de trabalho
aSizeAut := MsAdvSize()
aInfo    := {aSizeAut[1],aSizeAut[2],aSizeAut[3],aSizeAut[4],3,3}

aAdd(aObjects,{100,060,.T.,.T.})
aAdd(aObjects,{100,040,.T.,.T.})
aPosObj      := MsObjSize(aInfo,aObjects)
aPosObj[1,3] += 35                          // Linha inferior do cabeçalho
//aPosObj[1,3] := 350  
aPosObj[2,1] -= 55                          // Linha superior das abas
aPosObj1     := MsObjSize(aInfo,aObjects)

nSuperior    := 003                             // Linha de cima do msGet
nEsquerda    := 003                             // Linha esquerda do msGet
nInferior    := aPosObj[2,3]-(aPosObj[2,1]+15)  // Linha de baixo do msGet
nDireita     := aPosObj[2,4]-(aPosObj[2,2])     // Coluna direita do msGet
//nDireita     := nDireita * 0.35

cVarCampo := ""

// Verifica o tipo de chamada e trata a situação
Do Case
	Case nOpc == 2	//Visualização
		nOpEch := 2
		aExibe := fInitVarX3(cAlias ,.F.,"")
		
	Case nOpc == 3	//Inclusão
		nOpEch := 3
		aExibe := fInitVarX3(cAlias ,.T.,"")
		
	Case nOpc == 4	//Alteração
		nOpEch := 3
		aExibe := fInitVarX3(cAlias ,.F.,"")
		
	Case nOpc == 5	//Exclusão
		nOpEch := 5
		aExibe := fInitVarX3(cAlias ,.F.,"")
	
	Case nOpc == 7	//Copia
		nOpEch := 7
		aExibe := fInitVarX3(cAlias ,.T.,"")
		
	Otherwise //Outras situações
		nOpEch := 2
		aExibe := fInitVarX3(cAlias ,.F.,"")
		
EndCase

// Carrega Array com os Folders da tela
aAdd(aFolder	,"Historico do Ativo"    )



nPosOS   := Len(aFolder)

// Montagem da tela que serah apresentada para usuario (lay-out)
Define MsDialog oDialg Title cCadastro From aSizeAut[7],0 To aSizeAut[6],aSizeAut[5] Of oMainWnd Pixel

/*Cabeçalho		*/ oEnchc := Msmget():New(cAlias,nReg  ,nOpEch,,,,aExibe ,aPosObj[1],aExibe,,,,,oDialg,,.T.,,'aTela1')
/*Cabeçalho		*/ aGets1 := aclone(oEnchc:aGets)
/*Cabeçalho		*/ aTela1 := aclone(oEnchc:aTela)
/*Cabeçalho		*/ aGets  := {}
/*Cabeçalho		*/ aTela  := {}

/*Folders		*/ oFolder:= TFolder():New(200,aPosObj[2,2],aFolder,{"HEADER"},oDialg,,,,.T.,.F.,aPosObj[2,4]-aPosObj[2,2],aPosObj[2,3]-aPosObj[2,1])

/*P.compras		*/// aPosObj[2,1]
					 fGOSZZD(nOpc , 1  ,@oGdAdicao1)
  //				


Activate MsDialog oDialg On Init EnchoiceBar(oDialg,bOk,bCancel,,aButtons)

Do Case
	//Se for inclusao e foi cancelado
	Case (nOpc == 3 .or. nOpc == 7 ).And. nOpcao == 0
		While (cAlias)->(GetSx8Len()) > nSaveSx8Len
  			(cAlias)->(RollBackSx8())
		End
		
		//Se for inclusao e foi confirmado
	Case nOpc == 3 .And. nOpcao == 1	  
		//fvalid()  
		fSalvaTudo(nOpc,cAlias)
		
		//Se for alteracao e foi confirmado
	Case nOpc == 4 .And. nOpcao == 1	
		//fvalid()
		fSalvaTudo(nOpc,cAlias)
		ZZC->(DbGoTo(nRecZZC))
		
		//Se for alteracao e foi cancelado
	Case nOpc == 4 .And. nOpcao == 0
		ZZC->(DbGoTo(nRecZZC))
		
		//Se for exclusao e foi confirmado
	Case nOpc == 5 .And. nOpcao == 1
		fExcluiOS()
		
	OtherWise
		ZZC->(DbGoTo(nRecZZC))
		
EndCase

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍº±±
±±ºPrograma  ºfInitVarX3ºAutor  ºFelipe Aurélio de Melo º Data º 29/03/11 º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºDesc.     º                                                            º±±
±±º          º                                                            º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºUso       º RFINM06                                                    º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fInitVarX3(cAlias,lInitVarX3,cExibeCpos,lRelacao,lVerifica)

Local aExibLst := {}
Default lRelacao := .T.
Default lVerifica := .T.

SX3->(DbSetOrder(1))
SX3->(DbSeek(cAlias))
While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == cAlias
	If (X3USO(SX3->X3_USADO) .Or. !lVerifica) .And. cNivel >= SX3->X3_NIVEL
		If Empty(cExibeCpos) .Or. AllTrim(SX3->X3_CAMPO)+"/" $ cExibeCpos
			If lInitVarX3
				If lRelacao
					If !Empty(SX3->X3_RELACAO)
						_SetOwnerPrvt(Trim(SX3->X3_CAMPO),(cAlias)->&(SX3->X3_RELACAO))
					Else
						_SetOwnerPrvt(Trim(SX3->X3_CAMPO),CriaVar(Trim(SX3->X3_CAMPO),.T.))
					EndIf
				Else
					_SetOwnerPrvt(Trim(SX3->X3_CAMPO),CriaVar(Trim(SX3->X3_CAMPO),.F.))
				EndIf
			Else
				If SX3->X3_CONTEXT != "V"
					_SetOwnerPrvt(Trim(SX3->X3_CAMPO),(cAlias)->&(SX3->X3_CAMPO))
				Else
					If lRelacao
						_SetOwnerPrvt(Trim(SX3->X3_CAMPO),(cAlias)->&(SX3->X3_RELACAO))
					Else
						_SetOwnerPrvt(Trim(SX3->X3_CAMPO),CriaVar(Trim(SX3->X3_CAMPO),.F.))
					EndIf
				EndIf
			EndIf
			AADD(aExibLst,SX3->X3_CAMPO)
		EndIf
	EndIf
	SX3->(DbSkip())
End

Return(aExibLst)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍº±±
±±ºPrograma  º faHead º Autor  º Felipe Aurélio de Melo º Data º 29/03/11 º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºDesc.     º                                                            º±±
±±º          º                                                            º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºUso       º RFINM06                                                    º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function faHead(hcAlias,hcCampos,hcNaoCampos)

Local   haHead      := {}
Default hcCampos    := ""
Default hcNaoCampos := ""


// Montagem do aHeader
SX3->(dbSetOrder(1))
SX3->(dbSeek(hcAlias))
While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == hcAlias
	If ((((X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL)) .And. Empty(hcCampos) ) .Or. AllTrim(SX3->X3_CAMPO) $ hcCampos);
		.And. !(AllTrim(SX3->X3_CAMPO) $ hcNaoCampos)
		aAdd(haHead, {	AllTrim(X3Titulo())	,;
		SX3->X3_CAMPO		,;
		SX3->X3_PICTURE		,;
		SX3->X3_TAMANHO		,;
		SX3->X3_DECIMAL		,;
		SX3->X3_VALID		,;
		SX3->X3_USADO		,;
		SX3->X3_TIPO		,;
		SX3->X3_F3			,;
		SX3->X3_CONTEXT		,;
		SX3->X3_CBOX		,;
		SX3->X3_RELACAO		,;
		SX3->X3_WHEN		,;
		SX3->X3_VISUAL		,;
		SX3->X3_VLDUSER		,;
		SX3->X3_PICTVAR		,;
		SX3->X3_OBRIGAT		})
	EndIf
	SX3->(DbSkip())
End

Return haHead

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍº±±
±±ºPrograma  º faCols º Autor  º Felipe Aurélio de Melo º Data º 29/03/11 º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºDesc.     º                                                            º±±
±±º          º                                                            º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºUso       º RFINM06                                                    º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function faCols(haHead,hcAlias,haCampo,hnQtdLin,hcOpc,hcOrdSeek,hcCndSeek,hcCpoSeek,hcCampos,hcNaoCampos)

Local k := 0
Local x := 0
Local y := 0
Local haCol := {}
Local lFoiTratado := .F.
Default hcCampos  := ""
Default hcNaoCampos := ""


If hcOpc == 3
	// Montagem do aCols em Branco
	For y := 1 To hnQtdLin
		
		AADD(haCol,Array(Len(haHead)+1))
		nLin	:= Len(haCol)
		x	:= 1
		
		SX3->(DbSetOrder(1))
		SX3->(DbSeek(hcAlias))
		While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == hcAlias
			If (((X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL) .And. Empty(hcCampos) ) .Or. AllTrim(SX3->X3_CAMPO) $ hcCampos);
				.And. !(AllTrim(SX3->X3_CAMPO) $ hcNaoCampos)
				lFoiTratado := .F.
				For k := 1 To Len(haCampo)
					If haCampo[k,1] $ SX3->X3_CAMPO .And. !haCampo[k,3]
						haCol[nLin,x] := haCampo[k,2]
						haCampo[k,3]  := .T.
						lFoiTratado   := .T.
						k := Len(haCampo)
					EndIf
				Next k
				If !lFoiTratado
					If Empty(SX3->X3_RELACAO)
						haCol[nLin,x] := CriaVar(SX3->X3_CAMPO)
					Else
						haCol[nLin,x] := &(SX3->X3_RELACAO)
					EndIf
				EndIf
				x += 1
			EndIf
			SX3->(DbSkip())
		End
		
		haCol[nLin,Len(haHead)+1] := .F.
		
	Next y
Else
	// Montagem do aCols com registros caso tenha
	DbSelectArea(hcAlias)
	DbSetOrder(hcOrdSeek)
	If DbSeek(&(hcCndSeek))
		While !EOF() .And. &(hcCndSeek) == &(hcCpoSeek)
			
			AADD(haCol,Array(Len(haHead)+1))
			nLin	:= Len(haCol)
			
			x := 1
			SX3->(DbSetOrder(1))
			SX3->(DbSeek(hcAlias))
			While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == hcAlias
				If (((X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL) .And. Empty(hcCampos) ).Or. AllTrim(SX3->X3_CAMPO) $ hcCampos);
					.And. !(AllTrim(SX3->X3_CAMPO) $ hcNaoCampos)
					If SX3->X3_CONTEXT == "V"
						haCol[nLin,x] := &(SX3->X3_RELACAO)
					Else
						haCol[nLin,x] := &(SX3->X3_CAMPO)
					EndIf
					x += 1
				EndIf
				SX3->(DbSkip())
			End
			
			haCol[nLin,Len(haHead)+1] := .F.
			DbSkip()
		End
	Else
		AADD(haCol,Array(Len(haHead)+1))
		nLin	:= Len(haCol)
		x	:= 1
		
		SX3->(DbSetOrder(1))
		SX3->(DbSeek(hcAlias))
		While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == hcAlias
			If (((X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL) .And. Empty(hcCampos) ) .Or. AllTrim(SX3->X3_CAMPO) $ hcCampos) ;
				.And. !(AllTrim(SX3->X3_CAMPO) $ hcNaoCampos)
				lFoiTratado := .F.
				For k := 1 To Len(haCampo)
					If haCampo[k,1] $ SX3->X3_CAMPO .And. !haCampo[k,3]
						haCol[nLin,x] := haCampo[k,2]
						haCampo[k,3]  := .T.
						lFoiTratado   := .T.
						k := Len(haCampo)
					EndIf
				Next k
				If !lFoiTratado
					If Empty(SX3->X3_RELACAO)
						haCol[nLin,x] := CriaVar(SX3->X3_CAMPO)
					Else
						haCol[nLin,x] := &(SX3->X3_RELACAO)
					EndIf
				EndIf
				x += 1
			EndIf
			SX3->(DbSkip())
		End
		
		haCol[nLin,Len(haHead)+1] := .F.
	EndIf
EndIf

Return haCol

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍº±±
±±ºPrograma  º faCols º Autor  º Felipe Aurélio de Melo º Data º 29/03/11 º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºDesc.     º                                                            º±±
±±º          º                                                            º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºUso       º RFINM06                                                    º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RFMZZCVld(x,y)
Local _Retorno := .T.

_Retorno := fZZDTOk()

Return(_Retorno)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍº±±
±±ºPrograma  º fSalvaTudoº Autor ºFelipe Aurélio de Meloº Data º 05/04/11 º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºDesc.     º                                                            º±±
±±º          º                                                            º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºUso       º RFINM06                                                    º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fSalvaTudo(cTpOper,cTpAlias)

Local aAreaZZC := ZZC->(GetArea())

//cTpOper == 3 => Modo Inclusao
//cTpOper == 4 => Modo Alteracao

// Grava Processo
If cTpOper == 3 .OR. cTpOper == 7
	RecLock(cTpAlias,.T.)
	//Trata campos que não são visualizados em tela
	&(cTpAlias+"->"+Subs(cTpAlias,1,3)+"_FILIAL") := xFilial(cTpAlias)
Else
	RecLock(cTpAlias,.F.)
EndIf

//Trata os demais campos
SX3->(DbSetOrder(1))
SX3->(DbSeek(cTpAlias))
While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == cTpAlias
	cWhen := IIf(Empty(SX3->X3_WHEN),".T.",AllTrim(SX3->X3_WHEN))
	If X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. SX3->X3_CONTEXT != "V"
		If &(cWhen)
            If cTpOper == 4 .and. &(cTpAlias+"->"+SX3->X3_CAMPO) <> M->&(SX3->X3_CAMPO)  
                if ValType(&(cTpAlias+"->"+SX3->X3_CAMPO))=="D"
                    cLog += "Alteração Realizada, campo  "+  ALLTRIM(SX3->X3_TITULO) + ", de " + DTOC(&(cTpAlias+"->"+SX3->X3_CAMPO)) + " para " + DTOC(M->&(SX3->X3_CAMPO))  +ENTER     
					fmotivo()
                else
                    cLog += "Alteração Realizada, campo  "+  ALLTRIM(SX3->X3_TITULO) + ", de " + &(cTpAlias+"->"+SX3->X3_CAMPO) + " para " + M->&(SX3->X3_CAMPO)  +ENTER     
					fmotivo()
                EndIf
            EndIf 
			&(cTpAlias+"->"+SX3->X3_CAMPO) := M->&(SX3->X3_CAMPO)            
		Else
			If cWhen == ".F."
				&(cTpAlias+"->"+SX3->X3_CAMPO) := M->&(SX3->X3_CAMPO)
			Else
				If cTpOper == 3 
					&(cTpAlias+"->"+SX3->X3_CAMPO) := CriaVar(AllTrim(SX3->X3_CAMPO))
				ElseIf  cTpOper == 7 .AND. cTpAlias == "ZZC"     
					&(cTpAlias+"->"+SX3->X3_CAMPO) := M->&(SX3->X3_CAMPO)
				Else
                    If cTpOper == 4 .and. &(cTpAlias+"->"+SX3->X3_CAMPO) <> M->&(SX3->X3_CAMPO)  
                        if ValType(&(cTpAlias+"->"+SX3->X3_CAMPO))=="D"
                            cLog += "Alteração Realizada, campo  "+  ALLTRIM(SX3->X3_TITULO) + ", de " + DTOC(&(cTpAlias+"->"+SX3->X3_CAMPO)) + " para " + DTOC(M->&(SX3->X3_CAMPO))  +ENTER     
							fmotivo()
                        else
                            cLog += "Alteração Realizada, campo  "+  ALLTRIM(SX3->X3_TITULO) + ", de " + &(cTpAlias+"->"+SX3->X3_CAMPO) + " para " + M->&(SX3->X3_CAMPO)  +ENTER     
							fmotivo()
                        EndIf
                    EndIf 
					&(cTpAlias+"->"+SX3->X3_CAMPO) := &(cTpAlias+"->"+SX3->X3_CAMPO)
				EndIF
			EndIf
		EndIf
	EndIf
	SX3->(DbSkip())
End

(cTpAlias)->(MsUnLock())


If !Empty(cLog)
    Reclock("ZZD",.T.)
    ZZD->ZZD_FILIAL  := M->ZZC_FILIAL
    ZZD->ZZD_CODIGO  := M->ZZC_CODIGO
    ZZD->ZZD_ITEM    := FITEMZZD(M->ZZC_CODIGO)
    ZZD->ZZD_USUARIO := ALLTRIM(USRRETNAME(RETCODUSR()))
	ZZD->ZZD_MOTIVO  := _cMotivo
    ZZD->ZZD_DTALT   := DDATABASE
    ZZD->ZZD_DESCRI  := cLog
    ZZD->(MsUnLock())
EndIf

cLog := ""

// Grava Itens ZZD
aGrvCps := {}
aAdd(aGrvCps,{"ZZD_CODIGO"	,"M->ZZC_CODIGO" })
cOrdSeek := 1
cCpoItem := "ZZD_ITEM"
cCndSeek := "xFilial('ZZD')+M->ZZC_CODIGO
cCpoSeek := "ZZD->ZZD_FILIAL+ZZD->ZZD_CODIGO+ZZD->ZZD_ITEM"
fGravaGD(oGdAdicao1,"ZZD",aGrvCps,cTpOper,cOrdSeek,cCndSeek,cCpoSeek,cCpoItem)


                                             
//Confirma operação quando inclusão
If (cTpOper == 3  )
	While (cTpAlias)->(GetSx8Len()) > nSaveSx8Len
		(cTpAlias)->(ConfirmSX8())
	End
Else
	RestArea(aAreaZZC)
EndIf
                                               
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍº±±
±±ºPrograma  ºfGravaGDº Autor  º Felipe Aurélio de Melo º Data º 05/04/11 º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºDesc.     º                                                            º±±
±±º          º                                                            º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºUso       º RFINM06                                                   º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fGravaGD(hoObj,hcAlias,haCposAdd,hcTpOper,hcOrdSeek,hcCndSeek,hcCpoSeek,hcCpoItm) // salvaitens

Local k        := 01
Local x        := 01
Local y        := 01

//Este variavel não pode
//ser do tipo Local
//cCodItem := "001"

DbSelectArea(hcAlias)

For x:=1 To Len(hoObj:aCols)
	If  !hoObj:aCols[x,Len(hoObj:aHeader)+1]
		
		lTemInfo := .F.
   		For y:=2 To Len(hoObj:aHeader)
			If !Empty(hoObj:aCols[x][aScan(hoObj:aHeader,{|x|Alltrim(x[2])==AllTrim(hoObj:aHeader[y,2])})])
				lTemInfo := .T.
				Exit
			EndIf
		Next y
		
		If lTemInfo
			
			DbSelectArea(hcAlias)
			DbSetOrder(hcOrdSeek)
			
			If hcTpOper == 3 .OR. hcTpOper == 7
				RecLock(hcAlias,.T.)
				&(hcAlias+"->"+Subs(hcAlias,1,3)+"_FILIAL") := xFilial(hcAlias)
			ElseIf DbSeek(&(hcCndSeek)+hoObj:aCols[x][aScan(hoObj:aHeader,{|x|Alltrim(x[2])==hcCpoItm})])
				RecLock(hcAlias,.F.)
			Else
				RecLock(hcAlias,.T.)
				&(hcAlias+"->"+Subs(hcAlias,1,3)+"_FILIAL") := xFilial(hcAlias)
			EndIf
			
			For y:=1 To Len(hoObj:aHeader)
				&(hoObj:aHeader[y,2]) := hoObj:aCols[x][aScan(hoObj:aHeader,{|x|Alltrim(x[2])==AllTrim(hoObj:aHeader[y,2])})]
			Next y
			
			For k:=1 To Len(haCposAdd)
				&(haCposAdd[k,1]) := &(haCposAdd[k,2])
			Next k
			
			//cCodItem := Soma1(cCodItem)
			MsUnLock()
		EndIf
	Else
		DbSelectArea(hcAlias)
		DbSetOrder(hcOrdSeek)
		If hcTpOper != 3 .AND. hcTpOper != 7
			If DbSeek(&(hcCndSeek)+hoObj:aCols[x][aScan(hoObj:aHeader,{|x|Alltrim(x[2])==hcCpoItm})])
				RecLock(hcAlias,.F.)
				dbDelete()
				MsUnLock()
			EndIf
		EndIf
	EndIf
Next x

Return


Static Function fGOSZZD(hcOpc,nPosFolder,oGdAdicao)

Local cGetOpc        := IIf(hcOpc==2,Nil, GD_INSERT+GD_DELETE+GD_UPDATE) // GD_INSERT+GD_DELETE+GD_UPDATE
Local cLinhaOk       := "U_fZZDLOk()"                                    // Funcao executada para validar o contexto da linha atual do aCols
Local cTudoOk        := "U_fZZDTOk()"                                    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
Local cIniCpos       := "+ZZD_ITEM"                                     // Nome dos campos do tipo caracter que utilizarao incremento automatico.
Local nFreeze        := Nil                                              // Campos estaticos na GetDados.
Local nMax           := 999                                              // Numero maximo de linhas permitidas. Valor padrao 99
Local cCampoOk       := Nil//"U_JV101CPO"                                // Funcao executada na validacao do campo
Local cSuperApagar   := Nil                                              // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
Local cApagaOk       := Nil                                              // Funcao executada para validar a exclusao de uma linha do aCols
Local aCpoItem       := {}                                               // Array com os campos que deverão ser tratados quando rotina de inclusão
aHead                := {}                                               // Array do aHeader
aCols                := {}                                               // Array do aCols

cVrAlias := "ZZD"
cOpcaoUt := hcOpc
cOrdSeek := 1         
cCndSeek := "xFilial('ZZD')+M->ZZC_CODIGO"
cCpoSeek := "ZZD->ZZD_FILIAL+ZZD->ZZD_CODIGO"
nQtdLnhs := 1
cVCampos := "" //"PAE_STSLEG/PAE_STATUS"
cNaovCpo := ""
//cCodItem := "001"

//Cria varias linhas em branco caso necessario
aAdd(aCpoItem,{"ZZD_ITEM"  ,StrZero(1,3)  ,.F.})
//Next x

aHead := faHead(cVrAlias,cVCampos,cNaoVCpo)   

//nPOSREVISA  := aScan( aHead, { |aVet| Alltrim(aVet[2]) == "ZZD_REVISA"  } )

aCols     := faCols(aHead,cVrAlias,aCpoItem,nQtdLnhs,cOpcaoUt,cOrdSeek,cCndSeek,cCpoSeek,cVCampos,cNaoVCpo)

oGdAdicao := MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita,cGetOpc,cLinhaOk,cTudoOk,cIniCpos,,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oFolder:aDialogs[nPosFolder],aHead,aCols)

//oGdAdicao:oBrowse:bChange := { || fMudaZZD(oGdAdicao,oGdAdicao1:oBrowse:nat) }

oScroll       := Nil
nWidth        := 380
nHeigth       :=  175
oFont := TFont():New( 'Courier New', -13,  -13 ,,,,,,,)

Return

User Function fZZDLOk()

lReturn := .t.


Return lReturn
/*
Static Function fMudaZZD(oObj) 


Return
  */     

Static Function fExcluiOS()

If SimNao("Confirma exclusão do Item '"+ZZC->ZZC_CODIGO+"' ?") == "S"
	
	//Deleta Itens da OS
	ZZD->(DbSetOrder(1))
	ZZD->(DbSeek(ZZC->ZZC_FILIAL + ZZC->ZZC_CODIGO))
	Do While ZZD->(!Eof()) .And. ZZD->ZZD_FILIAL + ZZD->ZZD_CODIGO  == ZZC->ZZC_FILIAL + ZZC->ZZC_CODIGO  
		RecLock("ZZD",.F.)
		ZZD->( dbDelete() )
		ZZD->(MsUnLock())		
		ZZD->(DbSkip())
	EndDo
	
	//Deleta Cabeçalho da OS
	RecLock("ZZC",.F.)
	ZZC->( dbDelete() )
	ZZC->( MsUnLock())
	
EndIf

Return

Static Function fZZDTOk()
Local _Retorno := .t.
Return _Retorno
             
       
User Function FZZD_VLD()
Local _Retorno := .t.
Return _Retorno   


Static Function fitemzzd(cNum)
Local _Retorno := ''

cQuery := "SELECT ISNULL(MAX(ZZD_ITEM),0) NOVONUM FROM " + RetSqlName("ZZD") + " WHERE ZZD_CODIGO = '"+cNum+"'  AND D_E_L_E_T_ = '' "

If Select("TEMP") <> 0
	TEMP->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "TEMP"

cNovoNUM := TEMP->NOVONUM

cNovoNUM := StrZero(Val(cNovoNUM)+1,2)

TEMP->( dbCloseArea() )

_Retorno := cNovoNUM

Return _Retorno



/*
Envia email
*/

User Function ATVMAIL1()

Local cMsg			:= ""
Local cEmail		:= "jonas@opusvp.com.br"
Local cMsgDados		:= ""
Local cQuery        := ""



cQuery := " SELECT * FROM ZZC010  WHERE ZZC_DTVENC   <= CONVERT(VARCHAR(10), GETDATE()+800, 112) AND D_E_L_E_T_=''  "
	
If Select("QUERY") <> 0
	QUERY->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QUERY"
	

If	!QUERY->( EOF() ) 
	While !QUERY->( EOF() ) 
		cMsgDados += "Código Protheus "+ QUERY->ZZC_CODIGO + ", Serie: " + QUERY->ZZC_SERIAL +  ", Equipamento: " + QUERY->ZZC_DESCRI + ", Contrato: " + QUERY->ZZC_CONTRA + ", Vencimento: " + DTOC(STOD(QUERY->ZZC_DTVENC)) + ENTER 

		QUERY->(DbSkip()) 
	Enddo




	cMsg := ""
	cMsg += "<html>"
	cMsg += "<table border=0 cellpeding=0 cellspace=0>"
	cMsg += "<tr><td><font face=Arial size=2><i>"
	cMsg += "Atençao " + cEmail  + ", <br>"
	cMsg += "<p>Abaixo os ativos da TI com vencimento em até 30 dias , ou já vencidos</p>"
	cMsg += "</i></font></td></tr>"
	cMsg += "<tr><td><font face=Arial size=3 color=Red><b><i>"
	cMsg += "<br>"
	cMsg += "ATIVOS COM CONTRATO ATÉ "+DTOC(daysum(date(),30))
	cMsg += "</b></u></i></font></td></tr>"           
	cMsg += "<tr><td><font face=Arial size=2><i>	 "
	cMsg += "<p>"+cMsgDados+"</p>"
	cMsg += "</i></font></td></tr>"
	cMsg += "<tr><td><font face=Arial size=3 color=Red><b><i>"
	cMsg += "<br>"
	cMsg += ""
	cMsg += "</b></i></font></td></tr>"
	cMsg += "<tr><td><font face=Arial size=2><i>	 "
	cMsg += "<p></p>"
	cMsg += "</i></font></td></tr>"
	cMsg += "<tr><td><font face=Arial size=3 color=Red><b><i>"
	cMsg += "<br>"
	cMsg += ""
	cMsg += "</b></i></font></td></tr> "
	cMsg += "<tr><td><font face=Arial size=2><i>	 "
	cMsg += "<p>Atenciosamente,<br><br>Departamento de TI - Rosenberger Domex Telecomunicações Ltda</p>"
	cMsg += "</i></font></td></tr>"
	cMsg += "<tr><td><font face=Arial size=1><i>"
	cMsg += "<br>	 " 	
	cMsg += "Este e-mail foi enviado para os seguintes destinatarios: " + StrTran(cEmail,";"," - ")  
	cMsg += "</i></font></td></tr>"
	cMsg += "</table>"
	cMsg += "</html>"
	
		
	Sleep(4000)
		
	U_EnvMailto("Vencimento de Contratos de Ativos " ,cMsg,cEmail,"",)

EndIf	
	 
Return

Static function fmotivo()
Private _cresp   := SUBSTRING(cUsuario,7,15)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Interface                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 269,242 To 240,890 Dialog _oDlg1 Title OemToAnsi("Digite o motivo da alteração")
@ 001,001 GET _cMotivo Size 308,10 Picture "@!" VALID(!EMPTY(_CMOTIVO))
@ 024,154 BmpButton Type 1  Action Close(_oDlg1)
Activate Dialog _oDlg1 CENTERED  

Return

Static Function fvalid()

If !Empty(M->ZC_CONTRA) .AND. M->ZC_CONTRA =! NIL
	If empty(M->ZZC_DTVENC) 
		Alert("Atenção, digite a data de vencimento")
	Elseif M->ZZC_DTVENC == NIL
		Alert("Atenção, digite a data de vencimento")
	EndIf
EndIf

Return