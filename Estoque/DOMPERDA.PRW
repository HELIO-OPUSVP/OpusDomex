#INCLUDE "Protheus.ch"
#INCLUDE "RwMake.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "Tbiconn.ch"
#INCLUDE "FwBrowse.ch"
#INCLUDE "fwmvcdef.ch"

#DEFINE ENTER CHAR(13) + CHAR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DOMPERDA    ºAutor:  Jackson Santos    º Data ³  04/03/22   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastro de apontamento de perdas da produção.             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMPERDA()         

Local oDlg
//LOCAL bCondic 	:= { || } 
//Local cCondic 	:= ""
//Local cNoFields	:= ""
Local cTabPrinc	:= "PZA"

Private aSize 		:= {}
Private aObjects 	:= {}
Private aInfo 		:= {}
Private aPosObj 	:= {}
Private aPosGet		:= {}
//Private aHeader		:= {}
//Private aCols		:= {}
Private nUsado 		:= 0
Private cFiltro	:= ""
Private aRotina	:= StaticCall(MATA410,MenuDef) 
Private cCadastro := "DOMPERDA-Cadastro de Perda Domex"
Private lOkInc := .F.
Private lOkAlt := .F.
Private lOkExc := .F. 
Private lOkReimpr := .F.
Private cUsrLib := SuperGetMv("MV_USPERDA",.f.,"000000")
Private VISUAL 	:= 0 //(nOpcx == 2)
Private INCLUI	:= 0 //(nOpcx == 3)
Private ALTERA	:= 0 //(nOpcx == 4)
Private EXCLUI	:= 0 //(nOpcx == 5)

Static oFWLayer
Static oFWLayer2
Static oWin1
Static oWin2
Static oWin3
Static oWin4
Static oWin5
Static aHeader := {}
Static aCols   := {}       

aSize	:= MsAdvSize( .F. )
aInfo 	:= { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }

AAdd( aObjects, { 100	, 050	, .T., .F. })
AAdd( aObjects, { 100	, 100	, .T., .T. })

aPosObj	:= MsObjSize(aInfo,aObjects)
aPosGet	:= MsObjGetPos((aSize[3]-aSize[1]),315,{{004,024,240,270}} )

//Tabela principal da Rotina
DbSelectArea(cTabPrinc)
(cTabPrinc)->(DbSetOrder(1))


DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd STYLE nOR( WS_VISIBLE,WS_POPUP ) PIXEL

	oDlg:lEscClose := .F.
	                                                               	
	oFWLayer := FWLayer():New()		
	oFWLayer:Init(oDlg,.F.)

	oFWLayer:AddCollumn("Col01",10,.T.)
	oFWLayer:AddCollumn("Col02",90,.T.)

	oFWLayer:AddWindow("Col01","Win01"	,"Ações"	,100,.F.,.F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)
	oFWLayer:AddWindow("Col02","Win02"	,cCadastro	,100,.F.,.F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)
	
	oWin1 := oFWLayer:GetWinPanel('Col01','Win01')
	oWin2 := oFWLayer:GetWinPanel('Col02','Win02')

	// Botões da tela
	oBtn0 := TButton():New(0,0,"Sair",oWin1,{|| oDlg:End() },00,14,,,.F.,.T.,.F.,,.F.,,,.F.) 
	oBtn0:Align  := CONTROL_ALIGN_BOTTOM
	
	oBtn1 := TButton():New(0,0,"Inlcuir",oWin1,{|| APERDAINC("",0,3),oBrowse:Refresh() },00,14,,,.F.,.T.,.F.,,.F.,,,.F.)									 
	oBtn1:Align  := CONTROL_ALIGN_TOP
	
	@ 000, 000 SAY oBtn11 PROMPT Space(100) SIZE 049, 001 OF oWin1 PIXEL
	oBtn11:Align  := CONTROL_ALIGN_TOP
	
	oBtn2 := TButton():New(0,0,"Alterar",oWin1,{|| lOkAlt := APERDAINC("PZA",PZA->(Recno()),4),oBrowse:Refresh() },00,14,,,.F.,.T.,.F.,,.F.,,,.F.) 
	oBtn2:Align  := CONTROL_ALIGN_TOP

	@ 000, 000 SAY oBtn22 PROMPT Space(100) SIZE 049, 001 OF oWin1 PIXEL
	oBtn22:Align  := CONTROL_ALIGN_TOP

	oBtn3 := TButton():New(0,0,"Reimpressão",oWin1,{|| lOkReimpr := U_PZAREIMP() ,oBrowse:Refresh() },00,14,,,.F.,.T.,.F.,,.F.,,,.F.) 
	oBtn3:Align  := CONTROL_ALIGN_TOP
		
	@ 000, 000 SAY oBtn33 PROMPT Space(100) SIZE 049, 001 OF oWin1 PIXEL
	oBtn33:Align  := CONTROL_ALIGN_TOP

	oBtn4 := TButton():New(0,0,"Visualizar",oWin1,{||  APERDAINC('PZA',PZA->(Recno()),2)},00,14,,,.F.,.T.,.F.,,.F.,,,.F.) 
	oBtn4:Align  := CONTROL_ALIGN_TOP
	
	@ 000, 000 SAY oBtn44 PROMPT Space(100) SIZE 049, 001 OF oWin1 PIXEL
	oBtn44:Align  := CONTROL_ALIGN_TOP

	oBtn5 := TButton():New(0,0,"Exclusão",oWin1,{|| lExclui := PZADELETA(),iif(lExclui,MsgAlert("Exclusão Executada com sucesso","Exclusão"),), oBrowse:Refresh(.T.)  },00,14,,,.F.,.T.,.F.,,.F.,,,.F.) 
	oBtn5:Align  := CONTROL_ALIGN_TOP
	
	//@ 000, 000 SAY oBtn55 PROMPT Space(100) SIZE 049, 001 OF oWin1 PIXEL
	//oBtn55:Align  := CONTROL_ALIGN_TOP
	
	//Browse   
	DEFINE FWBROWSE oBrowse DATA TABLE ALIAS "PZA" OF oWin2
/*
	Local aCores := {;
{"ZA_SALDO==0 .AND. ZA_TIPO = 'N'" , "DISABLE"     },;
{"ZA_SALDO<>0 .AND. ZA_TIPO = 'N'" , "BR_VERDE"    },;
{"ZA_SALDO==0 .AND. ZA_TIPO = 'S'" , "BR_CINZA"    },;
{"ZA_SALDO<>0 .AND. ZA_TIPO = 'S'" , "BR_AZUL"     }}
BrwLegenda("","Legenda",{;
{"BR_CINZA"   ,"Perda Fibras - Pagas" 		},;  
{"BR_AZUL"    ,"Perda Fibras - à Pagar"		},; 
{"DISABLE"    ,"Perdas Outros - Pagas"		},; 
{"BR_VERDE"   ,"Perdas Outros - à Pagar"	}}) 

*/
	//Adiciona Legenda no Browse
	ADD LEGEND DATA ' Empty(PZA->PZA_STATUS) '	COLOR "BR_VERDE"	TITLE "Perdas a pagar"	OF oBrowse
	ADD LEGEND DATA ' PZA->PZA_STATUS == "1" '	COLOR "BR_VERMELHO"	 TITLE "Perdas Pagas"			 OF oBrowse
	//ADD LEGEND DATA ' ZM_STATFIN == "2" '	COLOR "BR_LARANJA"	 TITLE "Parcialmente Pago"			 OF oBrowse
	//ADD LEGEND DATA ' ZM_STATFIN == "3" '	COLOR "BR_VERMELHO"	 TITLE "Contrato Quitado/Baixado" OF oBrowse
	//ADD LEGEND DATA ' ZM_STATFIN == "1" .And. ZM_LA == "S" '  COLOR "BR_VIOLETA"	 TITLE "Contrato Contabilizado"	 OF oBrowse    
	
	
	//Colunas do Browse Principal
	ADD COLUMN oColumn1 DATA { || PZA_CODIGO  } TITLE Posicione("SX3",2,"PZA_CODIGO" ,"X3_TITULO") SIZE TamSx3("PZA_CODIGO" )[1] OF oBrowse
 	ADD COLUMN oColumn2 DATA { || PZA_OP  	  } TITLE Posicione("SX3",2,"PZA_OP","X3_TITULO") SIZE TamSx3("PZA_OP")[1] OF oBrowse
 	ADD COLUMN oColumn3 DATA { || PZA_PRODOP  } TITLE Posicione("SX3",2,"PZA_PRODOP","X3_TITULO") SIZE TamSx3("PZA_PRODOP")[1] OF oBrowse
 	ADD COLUMN oColumn4 DATA { || PZA_RECURSO } TITLE Posicione("SX3",2,"PZA_RECURSO","X3_TITULO") SIZE TamSx3("PZA_RECURSO")[1] OF oBrowse
 	ADD COLUMN oColumn5 DATA { || PZA_DATA	 } TITLE Posicione("SX3",2,"PZA_DATA","X3_TITULO") SIZE TamSx3("PZA_DATA")[1] OF oBrowse   
 	ADD COLUMN oColumn6 DATA { || PZA_HORA 	 } TITLE Posicione("SX3",2,"PZA_HORA","X3_TITULO") SIZE TamSx3("PZA_HORA")[1] OF oBrowse
 	//ADD COLUMN oColumn7 DATA { || ZM_CODBCO  } TITLE Posicione("SX3",2,"ZM_CODBCO" ,"X3_TITULO") SIZE TamSx3("ZM_CODBCO" )[1] OF oBrowse
 	//ADD COLUMN oColumn8 DATA { || ZM_BCOAGEN } TITLE Posicione("SX3",2,"ZM_BCOAGEN","X3_TITULO") SIZE TamSx3("ZM_BCOAGEN")[1] OF oBrowse
 	//ADD COLUMN oColumn9 DATA { || ZM_BCOCONT } TITLE Posicione("SX3",2,"ZM_BCOCONT","X3_TITULO") SIZE TamSx3("ZM_BCOCONT")[1] OF oBrowse
 	
 	oBrowse:CleanFilter() 
 	oBrowse:SetUseFilter()
	oBrowse:SetFilterDefault ( "PZA->PZA_FILIAL == '"  + xFilial("PZA") +  "' " )	
	//oBrowse:AddFilter( "Contrato em Aberto", ' Empty(ZM_STATFIN) .Or. ZM_STATFIN == "0"  '	, /*[ lNoCheck]*/.F.,/*[ lSelected]*/.F., /*[ cAlias]*/, /*[ lFilterAsk]*/, /*[ aFilParser]*/, /*[ cID]*/ )
	//oBrowse:AddFilter( "Contrato Liberado", ' SZM->ZM_STATFIN == "1" .And. SZM->ZM_LA <> "S" '									, /*[ lNoCheck]*/.F.,/*[ lSelected]*/.F., /*[ cAlias]*/, /*[ lFilterAsk]*/, /*[ aFilParser]*/, /*[ cID]*/ )
	//oBrowse:AddFilter( "Parcialmente Pago", ' SZM->ZM_STATFIN == "2" '									, /*[ lNoCheck]*/.F.,/*[ lSelected]*/.F., /*[ cAlias]*/, /*[ lFilterAsk]*/, /*[ aFilParser]*/, /*[ cID]*/)
	//oBrowse:AddFilter( "Contrato Quitado/Baixado",' SZM->ZM_STATFIN == "3" '							, /*[ lNoCheck]*/.F.,/*[ lSelected]*/.F., /*[ cAlias]*/, /*[ lFilterAsk]*/, /*[ aFilParser]*/, /*[ cID]*/)
	//oBrowse:AddFilter( "Contrato Contabilizado",'SZM->ZM_STATFIN == "1" .And. SZM->ZM_LA == "S" ', /*[ lNoCheck]*/.F.,/*[ lSelected]*/.F., /*[ cAlias]*/, /*[ lFilterAsk]*/, /*[ aFilParser]*/, /*[ cID]*/)	
	//Ativa o Browse
	ACTIVATE FWBROWSE oBrowse
	
ACTIVATE MSDIALOG oDlg CENTERED


Return

Static Function APERDAINC(cAlias,nRecno,nOpcx)
Local lRet := .F.
Local aAlterFields 	:= {}
Local lOkGrv 		:= .F.    
Local cFieldOk      := "U_VLDTBSZA(ReadVar())"
Private cTitulo		:= cCadastro
Private aSize 		:= {}
Private aObjects 	:= {}
Private aInfo 		:= {}
Private aPosObj 	:= {}
Private aPosGet 	:= {}
Private lOkSaida 	:= .F.                         
Private aFieldsPza 	:= {"NOUSER"}
Private aAltAcols 	:={"ZA_MOTIVO","ZA_QTDORI","ZA_OPERADO","ZA_RECURSO"} 
Private nCols		:= 0

Private aColsNew := {"NOUSER"}


Private nPosLin	:= 0

Private _oDlg
Private oGetdados              

VISUAL  := (nOpcx == 2)
INCLUI	:= (nOpcx == 3)
ALTERA	:= (nOpcx == 4)
EXCLUI	:= (nOpcx == 5)

Private oFont1	:= TFont():New("Verdana",,024,,.T.,,,,,.F.,.F.)
Private oFont2	:= TFont():New("Verdana",,044,,.T.,,,,,.F.,.F.)
Private oFont18	:= TFont():New("Verdana",,018,,.T.,,,,,.F.,.F.)

Static oEnchoice
PRIVATE aTELA[0][0]
PRIVATE aGETS[0]
PRIVATE lTemMvBco := .F.
Private nOPCselX	:= 0
Default nRecno := 0

aSize	:= MsAdvSize( .F. )
aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }

AAdd( aObjects, { 100, 100, .T., .T. } )
AAdd( aObjects, { 100, 100, .T., .T. } )
AAdd( aObjects, { 100, 005, .T., .F. } )

aPosObj	:= MsObjSize(aInfo,aObjects)
aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,033,160,200,240,263}} )

DbSelectarea("PZA")

cCamposPza :=  "PZA_CODIGO/PZA_RECURSO/PZA_OP/PZA_PRODOP/PZA_DESCRI/PZA_DATA/PZA_HORA/PZA_OPERAD/PZA_TPPERD/PZA_USUARI/PZA_SERIAL/PZA_STATUS"
cCamposSZA :=  "ZA_DOCUMEN/ZA_DATA/ZA_OP/ZA_RECURSO/ZA_PRODUTO/ZA_DESC/ZA_MOTIVO/ZA_DESCPER/ZA_QTDORI/ZA_SALDO/ZA_OPERADO/ZA_HORA/ZA_USUARIO/ZA_SERIAL/ZA_CODPZA"
//Carrega Variaveis na Memoria
RegToMemory("PZA", .T., .T.,.T.)
aEval(ApBuildHeader("PZA", Nil), {|x| iiF(Alltrim(x[2]) $ cCamposPZA , Aadd(aFieldsPza, x[2]),)})
aAlterFields := aClone(aFieldsPza)         



RegToMemory("SZA", .T., .T.,.T.)
aEval(ApBuildHeader("SZA", Nil), {|x| iiF(Alltrim(x[2]) $ cCamposSZA , Aadd(aHeader, x),)})

//Carrega o Acols 
If ALTERA .OR. VISUAL
	CarregAcols()
Endif


DEFINE MSDIALOG _oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL

	oFWLayer2 := FWLayer():New()		
	oFWLayer2:Init(_oDlg,.F.)

	oFWLayer2:AddCollumn("Col03",06,.T.)
	oFWLayer2:AddCollumn("Col04",94,.T.)

	oFWLayer2:AddWindow("Col03","Win03"	,"Açoes"				,100,.F.,.F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)
	oFWLayer2:AddWindow("Col04","Win04"	,"Cabeçalho Perda"	,035,.F.,.F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)
	oFWLayer2:AddWindow("Col04","Win05"	,"Itens Perda"	,065,.F.,.F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)
	//oFWLayer2:AddWindow("Col04","Win07"	,"Total do Parcelament"	,013,.F.,.F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)

	oWin3 := oFWLayer2:GetWinPanel("Col03","Win03")
	oWin4 := oFWLayer2:GetWinPanel("Col04","Win04")
	oWin5 := oFWLayer2:GetWinPanel("Col04","Win05")                                   
	//oWin7 := oFWLayer2:GetWinPanel("Col04","Win07")

	@ 000, 000 BTNBMP oBitmap1  RESNAME "FINAL"  SIZE 008, 035 OF oWin3 MESSAGE "Sair";
	Action( If(MSGYESNO("Deseja realmente sair do sistema?","Validação"),lOkSaida:=.T.,),IIF(lOkSaida,_oDlg:End(),))
	oBitmap1:cCaption := " <F4>"
	oBitmap1:Align  := CONTROL_ALIGN_BOTTOM
	SetKey(VK_F4 ,{||If(MSGYESNO("Deseja realmente sair do sistema?","Validação"),lOkSaida:=.T.,),IIF( lOkSaida,_oDlg:End(),)})
    
   	@ 000, 000 BTNBMP oBitmap2  RESNAME "OK"  SIZE 008, 035 OF oWin3 MESSAGE "Gravar Perda" ;
	Action( Iif(ValidGRV(nOpcx,{{"PZA"},{"SZA"}}),lOkGrv := GravaPerda(),MsgStop("Erro de Gravação","Erro")),IIF(lokGrv,_oDlg:End(),/*Else*/),IIF(lokGrv,nOPCselX := 1,/*Else*/))
	oBitmap2:cCaption := "<F10>"
	oBitmap2:Align  := CONTROL_ALIGN_TOP
	SetKey(VK_F10,{||  Iif(ValidGRV(nOpcx,{{"PZA"},{"SZA"}}), lOkGrv := GravaPerda(),MsgStop("Erro de Gravação","Erro")),iIf(lOkGrv,_oDlg:End(),/*Else*/),IIF(lokGrv,nOPCselX := 1,/*Else*/),Nil } )
	oBitmap2:LVISIBLECONTROL := IIF(INCLUI .or. ALTERA,.T.,.F.) 
	
	//Enchoice 
	lMemory := .T.     
	        
	oEnchoice := MsMGet():New("PZA",nRecno,nOpcx,,,,aFieldsPza,aPosObj[1],aAlterFields,1,,,,oWin4,.F./*lConF3*/,.T./*lMemory*/,.T./*lColuna*/,/*caTela*/,;
							  /*lNoFolder*/,/*lProperty*/,/*aField*/,/*aFolder*/,/*lCreate afolder*/,/*lNoMDIStretch*/,,.F./*lOrderACho*/)
	                                                                                                  
	oGetDados := MsNewGetDados():New(0,0,0,0,nOpcx,/*lLinOk*//*"U_VLDLACOLS"*/,/*lTudOk*/,/*"+ZA_DOCUMEN"*//*CpoInc*/,aAltAcols,,,cFieldOk,,,oWin5,aHeader,aCols)
	oGetDados:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	//oGetDados:BCHANGE := {|| U_AVLDDGCP(ReadVar())} 
	//oGetDados:BFIELDOK := {|| U_AVLDDGCP(ReadVar())}
	
		
	
ACTIVATE MSDIALOG _oDlg ON INIT({|| If(!obrigatorio(aGets,aTela),nOpcA:=0,_oDlg:End()) }) CENTERED

If lOkSaida .OR. nOPCselX == 0
	//ROLLBACKSXE()
EndIf

If nOpcX == 1
	//CLICOU EM OK

Else
	//CLICOU EM CANCELAR
EndIf

Return lRet
//GATILHO DOMPERDA PZA
User Function VLDTBPZA(cVarDigit)
Local lRetVld := .T.
Local aColsSZA := {}
Local nP 	   :=0
Default cVarDigit := ""    //Variável Digitada

IF  cVarDigit $ "M->PZA_OP"	
	If INCLUI
		If Empty(Alltrim(M->PZA_SERIAL))
			SC2->(DbSetOrder(1))
			if SC2->(DbSeek(xFilial("SC2")+M->PZA_OP ))
		
				M->PZA_PRODOP := SC2->C2_PRODUTO
				M->PZA_DESCRI := POSICIONE("SB1",1,XFILIAL("SB1")+SC2->C2_PRODUTO,"B1_DESC")
			
				cQrySZA:= "SELECT D4_FILIAL  ZA_FILIAL "
				cQrySZA+= ENTER + "  ,''  ZA_DOCUMEN " 
				cQrySZA+= ENTER + "  ,D4_DATA  ZA_DATA "
				cQrySZA+= ENTER + "  ,D4_OP  ZA_OP "
				cQrySZA+= ENTER + "  ,'' ZA_RECURSO "
				cQrySZA+= ENTER + "  ,D4_COD ZA_PRODUTO "
				cQrySZA+= ENTER + "  ,B1_DESC ZA_DESC "
				cQrySZA+= ENTER + "  ,'' ZA_MOTIVO "
				cQrySZA+= ENTER + "  ,'' ZA_DESCPER "
				cQrySZA+= ENTER + "  ,0 ZA_QTDORI "
				cQrySZA+= ENTER + "  ,0 ZA_SALDO "
				cQrySZA+= ENTER + "  ,'' ZA_OPERADO "
				cQrySZA+= ENTER + "  ,'' ZA_HORA   "
				cQrySZA+= ENTER + "  ,'P' ZA_TIPO  "
				cQrySZA+= ENTER + "  ,'' ZA_PRODPG "
				cQrySZA+= ENTER + "  ,'' ZA_USUARIO "
				cQrySZA+= ENTER + "  ,'' ZA_FLAG   "
				cQrySZA+= ENTER + "  ,'' ZA_MAQUINA "
				cQrySZA+= ENTER + "  ,'' ZA_SERIAL "
				cQrySZA+= ENTER + "  ,'' ZA_CODPZA "
				cQrySZA+= ENTER + "  FROM " + RetSqlName("SD4") + " SD4 " 
				cQrySZA+= ENTER + "  JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ ='' AND SB1. B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.B1_COD =SD4.D4_COD "
				cQrySZA+= ENTER + "  WHERE SD4.D_E_L_E_T_ ='' AND SD4.D4_FILIAL  ='" + xFilial("SD4") + "' AND LEFT(SD4.D4_OP,8) = '" + SUBSTR(ALLTRIM(M->PZA_OP),1,8) + "' "
				
				If Select("TBSZA") > 0 
					TBSZA->(DbCloseArea())
				EndIf
				TCQUERY cQrySZA NEW ALIAS "TBSZA"

				If TBSZA->(!EOF())
					While TBSZA->(!EOF())
						AaDd(aColsSza,Array(Len(aHeader) + 1))
						For nP:= 1 to Len(aHeader)

							aColsSZA[Len(aColsSza)][nP] := TBSZA->(&(aHeader[nP][2]))

							If aHeader[nP][2] == "ZA_DOCUMEN"
								aColsSZA[Len(aColsSza)][nP] := U_IZAZEDOC()
							elseif Alltrim(aHeader[nP][2]) == "ZA_CODPZA"
								aColsSZA[Len(aColsSza)][nP] := M->PZA_CODIGO	
							eLseIf Alltrim(aHeader[nP][2]) == "ZA_RECURSO"
								aColsSZA[Len(aColsSza)][nP] := M->PZA_RECURS
							eLseIf Alltrim(aHeader[nP][2]) == "ZA_USUARIO"
								aColsSZA[Len(aColsSza)][nP] := M->PZA_USUARI
							eLseIf Alltrim(aHeader[nP][2]) == "ZA_DATA"
								aColsSZA[Len(aColsSza)][nP] := M->PZA_DATA
							eLseIf Alltrim(aHeader[nP][2]) == "ZA_HORA"
								aColsSZA[Len(aColsSza)][nP] := M->PZA_HORA				
							EndIf
								
						Next nP
						//Campo do Deletado
						aColsSZA[Len(aColsSza)][Len(aColsSZA[Len(aColsSza)])] := .F.
						TBSZA->(DbSkip())
					EndDo
					oGetDados:aCols := aClone(aColsSZA)
					TBSZA->(DbCloseArea())
				else
					MsgStop("OP NÃO POSSUI EMPENHO NA SD4")
					lRetVld := .F.
				EndIf
			else
				MsgStop("Ordem de produção não encontrada com o código informado","Ordem de Proudução")
				lRetVld := .F.
			EndIf
		else
			MsgStop("Obrigatório informar o código serial para dar continuidade","Ordem de Producão")
			lRetVld := .F.	
		EndIf
	Endif
ElseIf cVarDigit $ "M->PZA_SERIAL"
	If!Empty(M->PZA_SERIAL)
		XD4->(DbSetOrder(3))
		If XD4->(DbSeek(xFilial("XD4")+M->PZA_SERIAL))
			lRetVld := .T.
		else
			MsgStop("Código Serial Digitado não encontrado na XD4","Erro Codigo Serial")
			lRetVld := .F.	
		Endif
	EndIf
EndIf                                
//teste

oGetDados:Refresh()
_odlg:Refresh()

Return lRetVld 

Static Function ValidGRV(nOpcx,aTabs)
Local lRet := .T.

Return lRet

Static Function CarregAcols()
Local cQryPZA := ""
Local nP := 0
Local aColsSza := {}

cQryPZA := " SELECT * "
cQryPZA += " FROM " + RetSqlName("SZA")  +" SZA "
cQryPZA += " WHERE D_E_L_E_T_ ='' AND SZA.ZA_FILIAL  ='" + xFilial("SZA") + "' AND SZA.ZA_CODPZA = '" + PZA->PZA_CODIGO + "'"

If Select("TMPZA") > 0 
	TMPZA->(DbCloseArea())
EndIf
TCQUERY cQryPZA NEW ALIAS "TMPZA"
If TMPZA->(!EOF())
	While TMPZA->(!EOF())
		AaDd(aColsSza,Array(Len(aHeader) + 1))
						For nP:= 1 to Len(aHeader)
							aColsSZA[Len(aColsSza)][nP] := TMPZA->(&(aHeader[nP][2]))						
						Next nP
						//Campo do Deletado
						aColsSZA[Len(aColsSza)][Len(aColsSZA[Len(aColsSza)])] := .F.
		TMPZA->(DbSkip())
	EndDo
	//oGetDados:aCols := aClone(aColsSZA)
	aCols := aClone(aColsSZA)
EndIf
//oGetDados:Refresh()
//_odlg:Refresh()

Return

Static Function GravaPerda()
Local lRet := .T.
Local lOkPza := .F.
Local lOkSza := .F.
Local nK := 0
Local nH := 0
Local nPosQtd := aScan( aHeader, {|x| Alltrim(x[2]) == "ZA_QTDORI" } )
Local nPosDoc := aScan( aHeader, {|x| Alltrim(x[2]) == "ZA_DOCUMEN" } )
Private cArm:= '96'

IF INCLUI
	Begin Transaction
	If Reclock("PZA",.T.)
		For nK:= 1 To Len(aFieldsPza)
			PZA->(&(aFieldsPza[nK])) := M->(&(FieldsPza[nK]))
		Next nK	
		PZA->(MsUnlock())	
		lOkPza := .T.	
	Endif

	If lOkPza
		aGrvsOk := {}
		For nK := 1 to len(oGetdados:Acols)
			If !oGetdados:Acols[nK][Len(oGetdados:Acols[nK])]
				//So gravar se a quantidade infromada de perda for maior que zero
				If oGetDados:aCols[nK][nPosQtd] > 0 
					If Reclock("SZA",.T.)
						For nH:=1 To Len(aHeader)						
							SZA->(&(aHeader[nH][2])) := oGetDados:aCols[nK][nH]
						Next nH
						SZA->(MsUnlock())
						lOkSza := .T.
					EndIf
					SB1->(DbSetOrder(1))
					SB1->(DbSeek(xFilial("SB1")+SZA->ZA_PRODUTO))
					If SB1->B1_APROPRI == 'I' .or. Subs(SB1->B1_COD,1,8) == '50010100'
						_nQtdTot    := SZA->ZA_SALDO

						Reclock("SZA",.F.)
						SZA->ZA_SALDO := 0
						SZA->( msUnlock() )
					
					Else    
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ GERA EMPENHO NA CRIACAO DA PERDA³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						SD4PERDA(SZA->ZA_PRODUTO, cArm, SZA->ZA_OP, SZA->ZA_QTDORI,.F. ) 
						U_CRIAP07(SZA->ZA_PRODUTO, cArm)	
						//FIM						
					EndIf 
					aaDd(aGrvsOk,{SZA->ZA_DOCUMEN,SZA->ZA_PRODUTO,SZA->ZA_OP})
				EndIf
			EndIf
		Next nK
	EndIf	
	
	If !lOkSza .Or. !lOkPza
		DisarmTransaction()
		MsgStop("Erro na gravação dos dados")
		lRet := .F.
	Endif
	End Transaction 
	
	//Se deu Tudo certo imprime etiquetas
	if lRet 
		If MsgYesNo("Deseja imprimir a(s) etiqueta(s)?")
			If len(aGrvsOk) > 0	
				//Pesquisar pelo código do documento que é unico					
				SZA->(DbSetOrder(2))
				For nK := 1 to len(aGrvsOk)
					IF SZA->(DbSeek(xfilial("SZA") + aGrvsOk[nk][1]))
						if !(Posicione("SB1",1,xFilial("SB1")+SZA->ZA_PRODUTO,"B1_GRUPO") $ "FO|FOFS")
							Etiqueta()
						EndIf
					Endif
				Next nK
			ENdif
		EndIf
	EndIf		
elseIf ALTERA
	If PZA->PZA_STATUS <> "1" //Encerrado
		MsgStop("Não é possivel alterar registro de perdas finalizado.","Exclusão Perda")
		Return .F.
	Endif
	SZA->(DbSetOrder(2))
	For nK := 1 to len(oGetdados:Acols)
		If !oGetdados:Acols[nK][Len(oGetdados:Acols[nK])]
			//So gravar se a quantidade infromada de perda for maior que zero
			If SZA->(DbSeek(xFilial("SZA")+  oGetDados:aCols[nK][nPosDoc] ))

				If Reclock("SZA",.F.)
					
					For nH:=1 To Len(aHeader)						
						If SZA->(&(aHeader[nH][2]))  <> oGetDados:aCols[nK][nH]
							SZA->(&(aHeader[nH][2])) := oGetDados:aCols[nK][nH]
						EndIf
					Next nH
					SZA->(MsUnlock())
					lOkSza := .T.
				EndIf
				SB1->(DbSetOrder(1))
				SB1->(DbSeek(xFilial("SB1")+SZA->ZA_PRODUTO))
				If SB1->B1_APROPRI == 'I' .or. Subs(SB1->B1_COD,1,8) == '50010100'
					_nQtdTot    := SZA->ZA_SALDO

					Reclock("SZA",.F.)
					SZA->ZA_SALDO := 0
					SZA->( msUnlock() )
				
				Else    
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ GERA EMPENHO NA CRIACAO DA PERDA³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					SD4PERDA(SZA->ZA_PRODUTO, cArm, SZA->ZA_OP, SZA->ZA_QTDORI,.F. ) 
					U_CRIAP07(SZA->ZA_PRODUTO, cArm)	
					//FIM						
				EndIf 
				aaDd(aGrvsOk,{SZA->ZA_DOCUMEN,SZA->ZA_PRODUTO,SZA->ZA_OP})
			
			EndIf
		EndIf
	Next nK
	
	lRet := .T.
else
	lRet := .T.
EndIf
Return lRet

Static Function Etiqueta()
Local _cPorta    := "LPT1"
Local _aAreaGER  := GetArea()

Reclock("SZA",.F.)
SZA->ZA_DATA := DATE()
SZA->ZA_HORA := Time()
SZA->( msUnlock() )

MSCBPrinter("TLP 2844",_cPorta,,,.F.)
MSCBBegin(1,6)
MSCBSay(28,01,"PAGAMENTO: PERDA PRODUÇÃO","N","3","1,1")


n := 3
// 01
MSCBSay(28,01+n,"DATA:"+DtoC(SZA->ZA_DATA)+" HORA:"+SZA->ZA_HORA+Space(10)+Transform(SZA->ZA_SALDO,"@E 999,999.99"),"N","2","1,1")
//03
MSCBSay(28,03+n,"OPERA.:"+SZA->ZA_OPERADO+" QTD:"+Transform(SZA->ZA_SALDO,"@E 999,999.99"),"N","2","1,1")
//05
MSCBSay(28,05+n,"PRODUTO: "+Alltrim(SZA->ZA_PRODUTO)+" "+Alltrim(SZA->ZA_DESC),"N","2","1,1")

//MSCBSayBar - Imprime código de barras ( nXmm nYmm cConteudo cRotação cTypePrt [ nAltura ] [ *lDigver ] [ lLinha ] [ *lLinBaixo ] [ cSubSetIni ]      [ nLargura ] [ nRelacao ] [ lCompacta ] [ lSerial ] [ cIncr ] [ lZerosL ] )
//07
MSCBSayBar(31,07+n,SZA->ZA_DOCUMEN,"N","MB07",10 ,.F.,.T.,.F.,,3,1  ,Nil,Nil,Nil,Nil)
//18
MSCBSay(46,18+n,"OP: "+SZA->ZA_OP,"N","2","1,1")

MSCBEnd()

MSCBClosePrinter()

RestArea(_aAreaGER)

Return

Static Function SD4PERDA(cProduto, cLocal, cOP, nQtd, lExclui )                 

Local lReturn  := .t.
Local aArea    := GetArea()
//Local lFibra   := Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_GRUPO") $ "FO|FOFS"

//cLocal := IIF(lFibra,'97','96')
cLocal:= "96"

//Verifica se tem armazem criado para o produto


dbSelectArea("SB2")
MsSeek(xFilial("SB2")+cProduto+cLocal)
If EOF()
	CriaSB2(cProduto,cLocal)
EndIf
                       

//Verifica se a OP continua em aberto
DBSelectArea("SC2")                       
If SC2->(DBSeek(xFilial()+cOP))
	If !Empty(SC2->C2_DATRF)    
		U_MSGCOLETOR("OP JÁ FOI ENCERRADA")
		lReturn := .f.
	EndIf
Else
	U_MSGCOLETOR("OP NAO ENCONTRADA")
	lReturn := .f.
EndIf


If lReturn .and. !lExclui      
	DBSelectArea("SD4")
	DBSetOrder(2)
	If SD4->(DBSeek(xFilial()+cOP+(SPACE(14-LEN(cOP)))+cProduto+(SPACE(15-LEN(cProduto)))+cLocal))
		RecLock("SD4",.F.)
		SD4->D4_QUANT	  := SD4->D4_QUANT+nQTD
		SD4->D4_QTDEORI  := SD4->D4_QTDEORI+nQTD
		SD4->( msUnlock() ) 
	Else
		Reclock("SD4",.T.)
		SD4->D4_FILIAL   := xFilial()
		SD4->D4_COD      := cProduto
		SD4->D4_LOCAL    := cLocal
		SD4->D4_OP       := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
		SD4->D4_DATA     := DATE()
		SD4->D4_QTDEORI  := nQTD
		SD4->D4_QUANT    := nQTD
		SD4->D4_LOTECTL  := ''
		SD4->D4_DTVALID  := StoD('20491231')
		SD4->D4_PRODUTO := SC2->C2_PRODUTO
		SD4->( msUnlock() ) 
	EndIF
	//Ajusta B2_QEMP
   //	cEMPSB2(cProduto, cLocal, nQTD, lExclui)
EndIf             
           
//Exclui empenho
If lExclui
	DBSelectArea("SD4")
	DBSetOrder(2)
	If SD4->(DBSeek(xFilial()+cOP+(SPACE(14-LEN(cOP)))+cProduto+(SPACE(15-LEN(cProduto)))+cLocal))	       
			If SD4->D4_QUANT==nQTD
				RecLock("SD4",.F.)
				SD4->(DbDelete())
				SD4->(MsUnLock())
				//Ajusta B2_QEMP
	  			//	cEMPSB2(cProduto, cLocal, nQTD, lExclui) 		  	
	  	    ElseIF SD4->D4_QUANT>nQTD
	  	    	RecLock("SD4",.F.)  
	  	    	SD4->D4_QTDEORI := SD4->D4_QTDEORI - nQTD 
				SD4->D4_QUANT   := SD4->D4_QUANT   - nQTD 
				SD4->(MsUnLock())				
		  	EndIf
	EndIf           
Endif

RestArea(aArea)                                     

Return lReturn

User Function PZAREIMP()
Local cQryPZA := ""

cQryPZA := " SELECT * "
cQryPZA += " FROM " + RetSqlName("SZA")  +" SZA "
cQryPZA += " WHERE D_E_L_E_T_ ='' AND SZA.ZA_FILIAL  ='" + xFilial("SZA") + "' AND SZA.ZA_CODPZA = '" + PZA->PZA_CODIGO + "'"

If Select("TMPZA") > 0 
	TMPZA->(DbCloseArea())
EndIf
TCQUERY cQryPZA NEW ALIAS "TMPZA"
If TMPZA->(!EOF())
	If MsgYesNo("Deseja imprimir a etiqueta?")
		SZA->(DbSetOrder(2))
		While TMPZA->(!EOF())
			iF SZA->(DbSeek(xFilial("SZA") + TMPZA->ZA_DOCUMEN))
				if !(Posicione("SB1",1,xFilial("SB1")+SZA->ZA_PRODUTO,"B1_GRUPO") $ "FO|FOFS")
					If SZA->ZA_QTDORI == SZA->ZA_SALDO				
						Etiqueta()						
					Else
						MsgStop("Reimpressão não permitida. Perda já atendida. produto:" + SZA->ZA_PRODUTO + " OP: " + SZA->ZA_OP)
					EndIf				
				EndIf
			Endif
			TMPZA->(DbSkip())	
		Enddo
	Endif
Endif
TMPZA->(DbCloseArea())
Return


User Function PZADELETA()
Local cQryPZA := ""
Local lOkParaExc := .T.
Local cMensErro := ""
If PZA->PZA_STATUS <> "1" //Encerrado
	MsgStop("Não é possivel excluir registro de perdas finalizado.","Exclusão Perda")
	Return .F.
Endif
cQryPZA := " SELECT R_E_C_N_O_ RECNOSZA "
cQryPZA += " FROM " + RetSqlName("SZA")  +" SZA "
cQryPZA += " WHERE D_E_L_E_T_ ='' AND SZA.ZA_FILIAL  ='" + xFilial("SZA") + "' AND SZA.ZA_CODPZA = '" + PZA->PZA_CODIGO + "'"

If Select("TMPZA") > 0 
	TMPZA->(DbCloseArea())
EndIf
TCQUERY cQryPZA NEW ALIAS "TMPZA"
SZA->(DbSetOrder(2))
If TMPZA->(!EOF())
	While TMPZA->(!EOF())		
		SZA->(DbGoTo(TMPZA->RECNOSZA))
		If SZA->ZA_DOCUMEN == TMPZA->ZA_DOCUMEN
			If SZA->ZA_QTDORI <> SZA->ZA_SALDO 		
				lOkParaExc := .F.
				cMensErro += "Com Pagamento Parcial - Doc: " + SZA->ZA_DOCUMEN + " Prod: " + SZA->ZA_PRODUTO + " OP: " + SZA->ZA_OP + ENTER
			ElseIf SZA->ZA_SALDO == 0
				lOkParaExc := .F.
				cMensErro += "Com Pagamento Total - Doc: " + SZA->ZA_DOCUMEN + " Prod: " + SZA->ZA_PRODUTO + " OP: " + SZA->ZA_OP + ENTER
			EndIf
		EndIf		
		TMPZA->(DbSkip())
	EndDo
	If !lOkParaExc
		MsgStop("Perda com pagamento já efetuado. Não será possível excluir este apontamento." + ENTER + cMensErro)
	Else
		SZA->(DbSetOrder(2))
		TMPZA->(DbGoTop())
		Begin Transaction
		While TMPZA->(!EOF())
			SZA->(DbGoTo(TMPZA->RECNOSZA))			
			If SZA->ZA_DOCUMEN == TMPZA->ZA_DOCUMEN				       
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ EXCLUI EMPENHO³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				SD4PERDA(SZA->ZA_PRODUTO, '96', SZA->ZA_OP, SZA->ZA_QTDORI, .T. ) 
				//FIM  	
				//RegToMemory("SZA",.F.)
				//AxDeleta("SZA"  , SZA->( Recno() )     , 5    )
				Reclock("SZA",.f.)
					SZA->(DbDelete())
				SZA->(MsUnlock())
				lOkParaExc := .T.
			EndIF
			TMPZA->(DbSkip())
		EndDo
		If lOkParaExc
			Reclock("PZA",.F.)
				PZA->(DbDelete())
			PZA->(MsUnlock())
		else
			DisarmTransaction()	
			MsgStop("Não Foi Possível Deletar o registro")
		EndIf
		End Transaction
	EndIf
Endif
TMPZA->(DbCloseArea())
Return lOkParaExc

User Function VLDTBSZA()
Local lRet := .T.

Return lRet
