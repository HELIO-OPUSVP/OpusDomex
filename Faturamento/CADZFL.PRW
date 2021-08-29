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
±±ºPrograma  ³CADZFL    ºAutor  ³Microsiga           º Data ³  20/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastro de Locais de Entrega.                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

MV_XZFLUSR

*/

User Function CADZFL(cCod,cLoja)                                    

Private aFixe     := {}
Private aCores    := {}
Private aRotina   := {}
Private cCadastro := ""

Private aHead       := {}                                              // Array do aHeader
Private aCols       := {}                                              // Array do aCols
PRIVATE n := 1
Private cTexto      := ''
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
Private cCod			:= SA1->A1_COD
Private cLoja			:= SA1->A1_LOJA

aFixe     := {}
cCadastro := OemtoAnsi("CADZFL - Locais de Entrega")

aRotina  := { ;
{ "Pesquisar"                , "Axpesqui"      , 0 , 1},;
{ "Visualiza"                , "AxVisual"    , 0 , 2},;
{ "Inclui"                   , "U_ZFLInc"    , 0 , 3},;
{ "Altera"                   , "U_ZFLAlt"    , 0 , 4},;
{ "Excluir"                  , "U_ZFLExc"    , 0 , 5},;
{ "Valida/Bloqueia"          , "U_ZFLLib"    , 0 , 6},;
{ "Legenda"                  , 'U_ZFLLeg()' , 0 ,10} }

//{ "Inclui"                   , "AxInclui"    , 0 , 3},;

aCores := 	{ {'ZFL_LIBFI=="1"' , 'BR_VERDE'    },;
              	{'ZFL_LIBFI<>"1"' , 'DISABLE'     } }

dbSelectarea("ZFL")
dbSetOrder(1)

// Usuarios que podem Liberar todos os endereços
if __CUSERID $ getmv("MV_XZFLUSR")
	cFiltro := "  ZFL_MSBLQL <> '1' "
else
	cFiltro := "ZFL_COD == '"+cCod+"' .AND. ZFL_LOJA == '"+cLoja+"' "
endif


Set Filter To &(cFiltro)
mBrowse(6,1,22,75,"ZFL",aFixe,,,,,aCores,,,,,)
Set Filter To

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ZFLLeg    ºAutor  ³ OpusVP           º Data ³  03/29/2011   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ZFLLeg()

	BrwLegenda(cCadastro,"legenda",{{"DISABLE"     ,"Bloqueado"    } ,;
										     {"BR_VERDE"    ,"Liberado"     } })
Return(.T.)



User Function ZFLInc()

	dbselectarea("ZFL")
	_op := AxInclui("ZFL")	
	if _op == 1

		cData     := DtoC(Date())
		cAssunto  := "LOCAL DE ENTREGA CADASTRADO - Cliente: " + ZFL->ZFL_COD +"-" +ZFL->ZFL_LOJA 
		cTexto    := "Cadastro Incluído em " + cData + " as " + Time()   + " por " + Subs(cUsuario,7,14) + chr(13)+chr(13) + "  "
		cTexto    += "End: " + alltrim(ZFL->ZFL_END) + " - "+alltrim(ZFL->ZFL_BAIRRO) +"-"+ ZFL->ZFL_EST		
		cPara     := "priscila.silva@rosenbergerdomex.com.br;ludmila.guimaraes@rosenbergerdomex.com.br;denis.vieira@rosenbergerdomex.com.br;"
		cCC       := ""
		cArquivo  := ""
		
		U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)


	endif
Return(.T.)





User Function ZFLAlt()
	nOK := AxAltera("ZFL",0,4)
	if nOK == 1
		Reclock("ZFL",.F.)
			ZFL->ZFL_LIBFI := "1"
		ZFL->( msUnlock() )
		if ZFL->ZFL_LIBFI == "1"
		  MsgInfo("O Endereço precisa ser Liberado pelo Depto. Fiscal.")
		endif
	endif
Return


User Function ZFLExc()
	msgAlert("Não é Possivel Excluir um endereço.  Favor Bloquear cadastro")
	//AxDeleta("ZFL"  , ZFL->( Recno() )     , 5    )
Return


User Function ZFLLib()

	if __CUSERID $ getmv("MV_XZFLUSR") // Usuarios que podem Liberar todos os endereços

		if ZFL->ZFL_LIBFI == "0" .and. MsgYesNo("Deseja LIBERAR o Endereço para utilização ?")
			Reclock("ZFL",.F.)
				ZFL->ZFL_LIBFI := "1"
			ZFL->( msUnlock() )
		elseif  ZFL->ZFL_LIBFI == "1" .and. MsgYesNo("Deseja BLOQUEAR o Endereço para utilização ?")
			Reclock("ZFL",.F.)
				ZFL->ZFL_LIBFI := "0"
			ZFL->( msUnlock() )		
	   endif
	else
		MsgAlert("Você não tem acesso para Liberar Endereços!   MV_XZFLUSR")
   endif
Return

