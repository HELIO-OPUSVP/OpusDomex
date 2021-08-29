#INCLUDE "Protheus.ch"
#INCLUDE "RwMake.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "Tbiconn.ch"
#INCLUDE "FwBrowse.ch"
#INCLUDE "fwmvcdef.ch"
#include "MSOle.Ch"
#Include "colors.ch"
#Include "FWPrintSetup.ch"
#Include "RPTDEF.CH"

#DEFINE ENTER CHAR(13) + CHAR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AGPEAFAM   บAutor  ณJackson Santos       บ Data ณ  22/03/20บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Rotina de Gera็ใo de Afastamentos em massa por centro de  บฑฑ
ฑฑบ          ณ  Custos / Fun็ใo / Matricula e informando data especifica. บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAGPE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function AGPEAFAM()
Private oDlg
//LOCAL bCondic 	:= { || } 
//Local cCondic 	:= ""
//Local cNoFields	:= ""
//Local cTabPrinc	:= "SZ1"
Private oLegRed := LoadBitmap(GetResources(),"BR_VERMELHO")
Private oLegGreen := LoadBitmap(GetResources(),"BR_VERDE")
Private oLegBlue := LoadBitmap(GetResources(),"BR_AZUL")
Private oLegYellow := LoadBitmap(GetResources(),"BR_AMARELO")
Private oLegGrey := LoadBitmap(GetResources(),"BR_CINZA")


Private aSize 		:= {}
Private aObjects 	:= {}
Private aInfo 		:= {}
Private aPosObj 	:= {}
Private aPosGet		:= {}
//Private aHeader		:= {}
//Private aCols		:= {}
Private nUsado 		:= 0
Private cFiltro	    := ""
Private aRotina	 := StaticCall(MATA410,MenuDef) 
Private cCadastro:= "Gera็ใo de Afastamentos em Lote"
Private lOkInc   := .F.
Private lOkAlt   := .F.
Private lOkExc   := .F. 
Private VISUAL 	 := 0 
Private INCLUI	 := 0 
Private ALTERA	 	:= 0 
Private EXCLUI	 	:= 0 
Private cTit		:= "Afatamentos em Lote"
Private _aSize	 	:= MsAdvSize(,.F.,430)
Private _cCCusto 	:=Space(09)
Private _cMatDe  	:=Space(06)
Private _cMatAte 	:=Space(06)
Private _cCodFunc	 := Space(05)
Private _oChkLot 	:= NIL
Private _cMark   	:= GetMark()
Private _cSituaca	:= " A*FT" //Space(05)
Private _aOpcapla	:= {"1-Afastamentos","2-Prog.F้ras"}
Private _cTipoImp	:="1-Afatamentos"	
Private _CREFOPC 	:= "1-Lic.Remunerada"
Private _aOpcao	 	:= {"1-Lic.Remunerada","2-Susp.Contrato","3-Reduc.Jorn./Sal"}
Private _cCodForn 	:= Space(3)
Private _cTpPPE		:= SPACE(02)
Private nQDocAimp	:= 0
Private _nQtdDias 	:= 0
Private _dDtInicial := CtoD("  /  /  ")
Private _dDtFinal   := CtoD("  /  /  ")
Private oCbx1
Private oCbx2
Private oGetForn
Private lOkSaida := .F.
Private lOkGrv   := .F.
Private _lAfastados := .F.

Private oWin1
Private oWin2
Private oWin3
Private oWin4
PRIVATE ODDTINICIAL
PRIVATE odDtFinal
PRIVATE onQtdDias

aSize	:= MsAdvSize( .F. )
aInfo 	:= { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }

AAdd( aObjects, { 100	, 050	, .T., .F. })
AAdd( aObjects, { 100	, 100	, .T., .T. })

aPosObj	:= MsObjSize(aInfo,aObjects)
aPosGet	:= MsObjGetPos((aSize[3]-aSize[1]),315,{{004,024,240,270}} )

DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd STYLE nOR( WS_VISIBLE,WS_POPUP ) PIXEL

	oDlg:lEscClose := .F.
	                                                               	
	oFWLayer := FWLayer():New()		
	oFWLayer:Init(oDlg,.F.)
                                        
	oFWLayer:AddLine( "UP", 35, .F. ) 
	oFWLayer:AddLine( "DOWN", 65, .F. ) 
	
	oFWLayer:AddCollumn("Col01",06,.T.,"UP")
	oFWLayer:AddCollumn("Col02",06,.T.,"DOWN")
	oFWLayer:AddCollumn("Col03",94,.T.,"UP")	
	oFWLayer:AddCollumn("Col04",94,.T.,"DOWN")
	
	oFWLayer:AddWindow("Col01","Win01"	,"A็๕es"	,100,.F.,.F.,/*bAction*/,"UP"/*cIDLine*/,/*bGotFocus*/)	
	oFWLayer:AddWindow("Col02","Win02"	,"Sair"		,100,.F.,.F.,/*bAction*/,"DOWN"/*cIDLine*/,/*bGotFocus*/)
	oFWLayer:AddWindow("Col03","Win03"	,"Parโmetros de Pesquisa",100,.F.,.F.,/*bAction*/,"UP"/*cIDLine*/,/*bGotFocus*/)		
	oFWLayer:AddWindow("Col04","Win04"	,"Dados Colaboradores"	,100,.F.,.F.,/*bAction*/,"DOWN"/*cIDLine*/,/*bGotFocus*/) 
	
	oWin1 := oFWLayer:GetWinPanel('Col01','Win01',"UP")
	oWin2 := oFWLayer:GetWinPanel('Col02','Win02',"DOWN")
	oWin3 := oFWLayer:GetWinPanel('Col03','Win03',"UP")
	oWin4 := oFWLayer:GetWinPanel('Col04','Win04',"DOWN")
	

	
	// Bot๕es da tela
	
    @ 000, 000 BTNBMP oBtn0  RESNAME "FINAL"  SIZE 010, 034 OF oWin2 MESSAGE "Sair";
	Action( If(MSGYESNO("Deseja realmente sair do sistema?","Valida็ใo"),lOkSaida:=.T.,),IIF(lOkSaida,oDlg:End(),))
	oBtn0:cCaption := " <F4>"
	oBtn0:Align  := CONTROL_ALIGN_BOTTOM
	SetKey(VK_F4 ,{||If(MSGYESNO("Deseja realmente sair do sistema?","Valida็ใo"),lOkSaida:=.T.,),IIF( lOkSaida,oDlg:End(),)})


    @ 000, 000 BTNBMP oBtn1  RESNAME "BMPVISUAL"  SIZE 010, 034 OF oWin1 MESSAGE "Pesquisar" ;
	Action( Processa( {|| fOkSeek() }, cTit, "Aguarde..." ) )
	oBtn1:cCaption := "<F8>"
	oBtn1:Align  := CONTROL_ALIGN_TOP
	SetKey(VK_F8,{|| Processa( {|| fOkSeek() }, cTit, "Aguarde..." ) })


  	
    @ 000, 000 BTNBMP oBtn2  RESNAME "BR_VERMELHO"  SIZE 010, 034 OF oWin1 MESSAGE "Desmarcar" ;
	Action( Processa( {|| fMarkAll() }, cTit, "Aguarde..." ) )
	oBtn2:cCaption := "<F9>"
	oBtn2:Align  := CONTROL_ALIGN_TOP
	SetKey(VK_F9,{|| Processa( {|| fMarkAll() }, "Desmarcar", "Aguarde..." ) })
  

	@ 000, 000 BTNBMP oBtn3  RESNAME "OK"  SIZE 010, 034 OF oWin1 MESSAGE "Confirmar e Gravar Dados" ;
	Action( Iif(ValidGRV(),lOkGrv := ConfirmGrv(),lOkGrv := .F.),IIF(lokGrv,fOkSelec()/*oDlg:End()*/,/*Else*/))
	oBtn3:cCaption := "<F10>"
	oBtn3:Align  := CONTROL_ALIGN_TOP
	SetKey(VK_F10,{||  Iif(ValidGRV(),lOkGrv := ConfirmGrv(),lOkGrv := .F.),IIF(lokGrv,fOkSelec()/*oDlg:End()*/,/*Else*/)})
	//oBtn3:LVISIBLECONTROL := IIF(INCLUI .or. ALTERA,.T.,.F.) 

	fOkSelec()
		
ACTIVATE MSDIALOG oDlg CENTERED

Return Nil

Static Function fOkSelec()
Local _aCampos   :={}                             


@ 003,001 Say "Centro de Custo ?" PIXEL OF oWin3 
@ 005,060 MsGet _cCCusto Size 70,15 F3 "CTT" Valid If(Empty(_cCCusto),.T.,(Alltrim(_cCCusto)==AllTrim(POSICIONE("CTT", 1, xFilial("CTT") + _cCCusto, "CTT_CUSTO"))) ) Of oWin3 Pixel     
@ 003,140 Say "Situa็ใo ?" PIXEL OF oWin3 
@ 003,200 MsGet _cSituaca Size 70,15  Valid fSituacao() When .T. Of oWin3 Pixel     
@ 030,001 Say "Matrํcula de ?" PIXEL OF oWin3 
@ 033,060 MsGet _cMatDe Size 70,15 F3 "SRA" Valid If(Empty(_cMatDe),.T.,(_cMatDe==AllTrim(POSICIONE("SRA", 1, xFilial("SRA") + _cMatDe, "RA_MAT"))) )  Of oWin3 Pixel     
@ 030,140 Say "Matrํcula ate ?" PIXEL OF oWin3 
@ 033,200 MsGet _cMatAte Size 70,15 F3 "SRA" Valid (("Z" $ Alltrim(_cMatAte) .Or. _cMatAte==AllTrim(POSICIONE("SRA", 1, xFilial("SRA") + _cMatAte, "RA_MAT"))))  Of oWin3 Pixel     

@ 057,001 Say "Fun็ใo ?" PIXEL OF oWin3 
@ 059,060 MsGet _cCodFunc Size 70,15  F3 "SRJ" Of oWin3 Pixel     

@ 003,280  Say "Tipo Afast." PIXEL OF oWin3   
@ 013,340  MSCOMBOBOX oCbx2 Var _cTipoImp ITEMS _aOpcapla When .F. Size 60,15 Of oWin3  PIXEL

@ 030,280 Say "Afastamento" PIXEL OF oWin3   
@ 040,340 MSCOMBOBOX oCbx1 Var _cRefOpc ITEMS _aOpcao  When .T. Size 60,15 Of oWin3  PIXEL


@ 057,280 Say "Cod. PPE" PIXEL OF oWin3   
@ 059,340 MsGet _cTpPPE  When IIF(Left(_cRefOpc,1) $ "2/3",.T.,.F.) F3 "S61" Size 60,15 Of oWin3  PIXEL

@ 003,420 Say "Data Inicial ?" PIXEL OF oWin3 
@ 005,480 MsGet odDtInicial Var _dDtInicial Size 70,15  Valid VldDtInicial() Of oWin3 Pixel     


@ 030,420 Say "Data Final ?" PIXEL OF oWin3 
@ 033,480 MsGet odDtFinal Var _dDtFinal Size 70,15 Valid VldDtFinal() Of oWin3 Pixel     

@ 057,420 Say "Qtd. Dias ?" PIXEL OF oWin3 
@ 059,480 MsGet onQtdDias Var _nQtdDias  Size 70,15 Picture "@E 999" Valid VldnQtdDias() Of oWin3 Pixel     

@ 057,140 CheckBox _oChkAfast Var _lAfastados Prompt "Filtrar apenas os Afastados?" Message  Size 125,007 Pixel Of oWin3

//Gerar tabela temperแria principal de trabalha
fGeraTRB()
dbSelectArea("TRB")

TRB->(dbGotop())

aadd(_aCampos , {"OK"		   ,""} )
aadd(_aCampos , {"Status"	   ,"Status"})
aadd(_aCampos , {"RA_MAT"      ,"Matricula"} )
aadd(_aCampos , {"RA_NOME"     ,"Nome"})
aadd(_aCampos , {"RA_CC"       ,"C.Custo"} )
aadd(_aCampos , {"RA_SITFOLH"  ,"Sit.Folha"} )
aadd(_aCampos , {"CTT_DESC01"  ,"Descri็ใo"} )
aadd(_aCampos , {"RA_CODFUNC"  ,"Fun็ใo"})
aadd(_aCampos , {"RJ_DESC"     ,"Descri็ใo"})
aadd(_aCampos , {"RA_ADMISSA"  ,"Admissใo"})
aadd(_aCampos , {"R8_DATAINI"  ,"Data Inicio"})
aadd(_aCampos , {"R8_DATAFIM"  ,"Data Fim"})

//Legenda da grade, ้ obrigat๓rio carregar antes de montar as colunas

@ aSize[4]/2.3,aSize[4] /6.5 To aSize[4]+5,aSize[3] Browse "TRB" Fields _aCampos Mark "OK" Object oWin4
 
Return

//-----------------------------------------------------------------

Static Function fMarkAll()
//Local lMarca 	:= Iif( TRB->OK <> _cMark, .T., .F.)
If Select("TRB") > 0 

	TRB->( dbGoTop() )
	IF TRB->(!EOF())
		While TRB->(!EoF())
			RecLock( "TRB", .F. )
			TRB->OK := ThisMark()
			TRB->( MsUnlock() )
			oWin4:oBrowse:Refresh(.T.)
			TRB->(DbSkip())
		End
		TRB->( dbGoTop() )
	EndIf
EndIf
Return

//-----------------------------------------------------------------

Static Function fOkSeek()
Local _lRet:=.T.

If Select("SQL") > 0
	SQL->(dbCloseArea())
EndIf

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

cQuery:="Select RA_CC,CTT_DESC01,RA_MAT,RA_NOME,RA_CODFUNC,RJ_DESC,RA_ADMISSA,"+Chr(10)+Chr(13)
cQuery+="CASE WHEN RA_SITFOLH='D' THEN 'DEMITIDO' WHEN RA_SITFOLH='F' THEN  'FERIAS' WHEN RA_SITFOLH='A' THEN  'AFASTADO' WHEN RA_SITFOLH='T' THEN  'TRANSFERIDO' ELSE 'ATIVO' END RA_SITFOLH,"+Chr(10)+Chr(13)
cQuery+="RA_SALARIO,RA_DEPSF,RA_DEPIR,R8_DATAINI,R8_DATAFIM "+Chr(10)+Chr(13)
cQuery+="From "
cQuery+=RetSqlName("CTT")+" CTT , "+Chr(10)+Chr(13)
cQuery+=RetSqlName("SRJ")+" SRJ , "+Chr(10)+Chr(13)
cQuery+=RetSqlName("SRA")+" SRA  "+Chr(10)+Chr(13)
If _lAfastados
	cQuery += " join " + RetSqlName("SR8") + " SR8 ON SR8.D_E_L_E_T_ ='' AND SR8.R8_FILIAL = SRA.RA_FILIAL AND SR8.R8_MAT = SRA.RA_MAT " +Chr(10)+Chr(13)
	cQuery += " AND SR8.R8_TIPOAFA = '" + iif(Left(_cRefOpc,1) == "1","015","021") +"' "
	If _dDtInicial <> CTOD("  /  /  ")
		cQuery += " AND SR8.R8_DATAINI = '" + DTOS(_dDtInicial) + "' "  +Chr(10)+Chr(13)
	else
		cQuery += " AND SR8.R8_DATAINI <> '' "  +Chr(10)+Chr(13)
	Endif
Else
	cQuery += " left join " + RetSqlName("SR8") + " SR8 ON SR8.D_E_L_E_T_ ='' AND SR8.R8_FILIAL = SRA.RA_FILIAL AND SR8.R8_MAT = SRA.RA_MAT " +Chr(10)+Chr(13)
	cQuery += " AND SR8.R8_TIPOAFA = '" + iif(Left(_cRefOpc,1) == "1","015","021") +"' "
	If _dDtInicial <> CTOD("  /  /  ")
		cQuery += " AND SR8.R8_DATAINI = '" + DTOS(_dDtInicial) + "' "  +Chr(10)+Chr(13)
	else
		cQuery += " AND SR8.R8_DATAINI <> '' "  +Chr(10)+Chr(13)
	Endif
EndIf
cQuery+="Where SRA.D_E_L_E_T_ = '' "+Chr(10)+Chr(13)
cQuery+="And CTT.D_E_L_E_T_ = '' "+Chr(10)+Chr(13)
cQuery+="And SRJ.D_E_L_E_T_ = '' "+Chr(10)+Chr(13)
cQuery+="And RA_FILIAL = '"+xFilial("SRA")+"' "+Chr(10)+Chr(13)
cQuery+="And CTT_FILIAL = '"+xFilial("CTT")+"' "+Chr(10)+Chr(13)
cQuery+="And RJ_FILIAL = '"+xFilial("SRJ")+"' "+Chr(10)+Chr(13)                                                                                                                          
cQuery+="And RA_CC = CTT_CUSTO "+Chr(10)+Chr(13)                                                                                                                                         
IF Alltrim(_cSituaca) <> "*****"
	cQuery+="And RA_SITFOLH In('"+SubStr(_cSituaca,1,1)+"','"+SubStr(_cSituaca,2,1)+"','"+SubStr(_cSituaca,3,1)+"','"+SubStr(_cSituaca,4,1)+"','"+SubStr(_cSituaca,5,1)+"') "+Chr(10)+Chr(13)
EndIf
If! Empty(Alltrim(_cCCusto))
	cQuery+="And RA_CC = '"+_cCCusto+"' "+Chr(10)+Chr(13)
EndIf
cQuery+="And RA_CODFUNC = RJ_FUNCAO "+Chr(10)+Chr(13)

If! Empty(_cMatDe)
	cQuery+="And RA_MAT >= '"+_cMatDe+"' "+Chr(10)+Chr(13)
EndIf

If! Empty(_cMatAte)
	cQuery+="And RA_MAT <= '"+_cMatAte+"' "+Chr(10)+Chr(13)
EndIf

If !Empty(_cCodFunc)
	cQuery+="And RA_CODFUNC = '" + _cCodFunc + "' "+Chr(10)+Chr(13)
EndIf
cQuery+="Order By RA_MAT"

If Select("SQL") > 0
	SQL->(DbCloseArea())
Endif

TCQuery cQuery ALIAS "SQL" NEW

TCSetField("SQL","RA_ADMISSA" ,"D",08,0)
TCSetField("SQL","R8_DATAINI" ,"D",08,0)
TCSetField("SQL","R8_DATAFIM" ,"D",08,0)
TCSetField("SQL","RA_SALARIO" ,"N",14,2)


cArqTRB:= CriaTrab(NIL,.F.)
aCampos  := {}

AADD(aCampos,{"OK"	       ,"C",002,0})
AADD(aCampos,{"Status"	   ,"C",10,0})
AADD(aCampos,{"RA_MAT"	   ,"C",TAMSX3("RA_MAT")[1],0})
AADD(aCampos,{"RA_NOME"	   ,"C",TAMSX3("RA_NOME")[1],0})
AADD(aCampos,{"RA_CC"      ,"C",TAMSX3("RA_CC")[1],0})
AADD(aCampos,{"RA_SITFOLH" ,"C",12,0}) 
AADD(aCampos,{"CTT_DESC01" ,"C",TAMSX3("CTT_DESC01")[1],0})
AADD(aCampos,{"RA_CODFUNC" ,"C",TAMSX3("RA_CODFUNC")[1],0})
AADD(aCampos,{"RJ_DESC"    ,"C",TAMSX3("RJ_DESC")[1],0})
AADD(aCampos,{"RA_ADMISSA" ,"D",008,0})
AADD(aCampos,{"R8_DATAINI" ,"D",TAMSX3("R8_DATAINI")[1],TAMSX3("R8_DATAINI")[2]})
AADD(aCampos,{"R8_DATAFIM" ,"D",TAMSX3("R8_DATAFIM")[1],TAMSX3("R8_DATAFIM")[2]})
//AADD(aCampos,{"RA_DEPSF"   ,"C",03,0})
If Select("TRB") > 0
	TRB->(DbCloseAera())
EndIf
dbCreate(cArqTRB,aCampos)
dbUseArea(.T.,, cArqTRB, "TRB",)
Index On RA_MAT TO &cArqTRB

dbSelectArea("SQL")
SQL->(dbGotop())
Do While.Not.Eof()
	dbSelectArea("TRB")
	Reclock("TRB",.T.)
	Replace TRB->OK          With Space(02)
	Replace TRB->STATUS      With IIF( SQL->R8_DATAINI <> CTOD("  /  /  ") ,"Afastado","Ativo")
	Replace TRB->RA_CC       With SQL->RA_CC
	Replace TRB->CTT_DESC01  With SQL->CTT_DESC01
	Replace TRB->RA_MAT      With SQL->RA_MAT
	Replace TRB->RA_NOME     With SQL->RA_NOME
	Replace TRB->RA_CODFUNC  With SQL->RA_CODFUNC
	Replace TRB->RJ_DESC     With SQL->RJ_DESC
	Replace TRB->RA_ADMISSA  With SQL->RA_ADMISSA
	Replace TRB->R8_DATAINI  With SQL->R8_DATAINI                
	Replace TRB->R8_DATAFIM  With SQL->R8_DATAFIM	
	Replace TRB->RA_SITFOLH  With SQL->RA_SITFOLH
	TRB->(MsUnlock())
	dbSelectArea("SQL")
	dbSkip()
EndDo
dbSelectArea("TRB")
TRB->(dbGotop())

_cSituaca:= " A*FT"
_cCodFunc:= SPACE(5)
_cCCusto :=Space(TAMSX3("RA_CC")[1])
_cMatDe  :=Space(TAMSX3("RA_MAT")[1])
_cMatAte :=Space(TAMSX3("RA_MAT")[1])

oWin4:oBrowse:Refresh(.T.)

Return(_lRet)

//------------------------------------------------------------------

Static Function fGeraTRB()

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

cArqTRB:= CriaTrab(NIL,.F.)
aCampos  := {}

AADD(aCampos,{"OK"	       ,"C",002,0})
AADD(aCampos,{"Status"	   ,"C",10,0})
AADD(aCampos,{"RA_MAT"	   ,"C",TAMSX3("RA_MAT")[1],0})
AADD(aCampos,{"RA_NOME"	   ,"C",TAMSX3("RA_NOME")[1],0})
AADD(aCampos,{"RA_CC"      ,"C",TAMSX3("RA_CC")[1],0})
AADD(aCampos,{"RA_SITFOLH" ,"C",12,0}) 
AADD(aCampos,{"CTT_DESC01" ,"C",TAMSX3("CTT_DESC01")[1],0})
AADD(aCampos,{"RA_CODFUNC" ,"C",TAMSX3("RA_CODFUNC")[1],0})
AADD(aCampos,{"RJ_DESC"    ,"C",TAMSX3("RJ_DESC")[1],0})
AADD(aCampos,{"RA_ADMISSA" ,"D",008,0})
AADD(aCampos,{"R8_DATAINI" ,"D",TAMSX3("R8_DATAINI")[1],TAMSX3("R8_DATAINI")[2]})
AADD(aCampos,{"R8_DATAFIM" ,"D",TAMSX3("R8_DATAFIM")[1],TAMSX3("R8_DATAFIM")[2]})

If Select("SQL")  > 0
	SQL->(DbCloseArea())
Endif
If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

dbCreate(cArqTRB,aCampos)
dbUseArea(.T.,, cArqTRB, "TRB",)
Index On RA_CC+RA_MAT TO &cArqTRB

dbSelectArea("SQL")
SQL->(dbGotop())
ProcRegua(RecCount())
Do While.Not.Eof()
	dbSelectArea("TRB")
	Reclock("TRB",.T.)
	Replace TRB->OK          With Space(02)
	Replace TRB->STATUS      With space(10)
	Replace TRB->RA_CC       With ""
	Replace TRB->CTT_DESC01  With ""
	Replace TRB->RA_MAT      With ""
	Replace TRB->RA_NOME     With ""
	Replace TRB->RA_CODFUNC  With ""
	Replace TRB->RJ_DESC     With ""
	Replace TRB->RA_ADMISSA  With Ctod(" / / ")
	Replace TRB->R8_DATAINI  With Ctod(" / / ")
	Replace TRB->R8_DATAFIM	 With Ctod(" / / ")	
	Replace TRB->RA_SITFOLH  With ""
	TRB->(MsUnlock())
	dbSelectArea("SQL")
	SQL->(dbSkip())
EndDo
Return

Static Function VldDtInicial()

If _nQtdDias > 0 
    _dDtFinal  := (_dDtInicial + _nQtdDias) -1
EndIf

Return .T.

Static Function VldDtFinal()
Local lRet := .T.

If _dDtInicial == CTOD("  /  /  ")
	MsgStop("Favor preencher data inicial para informar data final.","Data Final")
	lRet := .F.
	odDtInicial:SetFocus()
EndIf

If _dDtFinal  < _dDtInicial .And. _dDtFinal <> CTOD("  /  /  ")
	MsgStop("Data Final deve ser maior que data inicial.","Data Final")
	lRet := .F.
EndIf

If lRet
	_nQtdDias := (_dDtFinal - _dDtInicial	)
EndIf

Return lRet

Static Function VldnQtdDias()
	Local lRet := .T.
	If _nQtdDias > 0 
		_dDtFinal  := (_dDtInicial + _nQtdDias) - 1
	EndIf
Return lRet

Static Function ConfirmGrv()
Local lRet 		:= .T.
Local cQryAfast := ""
Local cUltSeq 	:= ""
Local cSeqAtu 	:= ""
Local cTipoAfas := ""
Local cCodVerba := ""
Local cTpEfd	:= ""
Local cQrySeq  	:= ""
Local nQtdMarked := 0
Local nQtdRegSel := 0
Local nQtdRegGrv := 0
Local aRegOk	:= {}
Local aRegNok	:= {}

	if Left(_CREFOPC,1) <> "3"					
		cQryAfast	:= " SELECT RCM_TIPO TIPO,RCM_DESCRI DESCRICAO,RCM_PD VERBA,RCM_TPEFD TPEFD "
		cQryAfast	+= " FROM " + RetSqlName("RCM") + " RCM WHERE RCM.D_E_L_E_T_ ='' AND RCM_FILIAL  ='' "
		If Left(_cRefOpc,1) == "1"
			cQryAfast	+= " AND RCM_TPEFD IN ( '16') "
		ElseIf Left(_cRefOpc,1) == "2"
			cQryAfast	+= " AND RCM_TPEFD IN ( '37') "
		EndIf

		If Select("TRBAFA") > 0
			TRBAFA->(DbCloseArea())
		EndIf
		TCQUERY cQryAfast NEW ALIAS "TRBAFA"
		If TRBAFA->(!EOF())
			cTipoAfas := TRBAFA->TIPO 
			cCodVerba := TRBAFA->VERBA
			cTpEfd    := TRBAFA->TPEFD
		EndIf
		TRBAFA->(DbCloseArea())
	else
			cTipoAfas := "RED"
			cCodVerba := "RED"
			cTpEfd    := "RED"
	Endif
	If !Empty(cTipoAfas) .And. !Empty(cCodVerba)
		if _nQtdDias == 0 
			If _dDtFinal == CTOD("  /  /  ")
				_nQtdDias	:= 999			
			Else			
				_nQtdDias	:= (_dDtFinal - _dDtInicial)
			EndIf
		EndIf
		
		dbSelectArea("TRB")
		TRB->(dbGotop())		
		
		DO While.Not.Eof()
			If Marked("OK")
				nQtdMarked ++
			EndIf
			nQtdRegSel ++
			TRB->(DBSkip())
		EndDo

		dbSelectArea("TRB")
		TRB->(dbGotop())
				
		DO While.Not.Eof()
			If Marked("OK")
				if Left(_CREFOPC,1) <> "3"					
					SR8->(DbSetOrder(6)) //R8_FILIAL, R8_MAT, R8_DATAINI, R8_TIPOAFA, R8_DIASEMP, R_E_C_N_O_, D_E_L_E_T_
					If !SR8->(DBSeek(XFILIAL("SRA") + TRB->RA_MAT + DTOS(_dDtInicial) + cTipoAfas ))
						cQrySeq:= " SELECT MAX(R8_SEQ) SEQR8 FROM " + RetSqlName("SR8") + " SR8 WHERE SR8.D_E_L_E_T_ ='' AND R8_MAT = '" + TRB->RA_MAT +  "' "
						If Select("TBR8SEQ") > 0
							TBR8SEQ->(DbCloseArea())
						EndIf
						TCQUERY cQrySeq NEW ALIAS "TBR8SEQ"
						If TBR8SEQ->(!EOF())
							cUltSeq := TBR8SEQ->SEQR8
							cSeqAtu := STRZERO(Val(cUltSeq) + 1,3)
						else
							cSeqAtu := "001"
						EndIf
						TBR8SEQ->(DbCloseArea())
						If RecLock("SR8",.T.)
							SR8->R8_FILIAL 	:= XFILIAL("SRA")
							SR8->R8_MAT 	:= TRB->RA_MAT
							SR8->R8_SEQ 	:= cSeqAtu
							SR8->R8_DATA	:= DDATABASE
							SR8->R8_TIPOAFA := cTipoAfas
							SR8->R8_PD		:= cCodVerba
							SR8->R8_DATAINI := _dDtInicial
							SR8->R8_DATAFIM := _dDtFinal
							SR8->R8_DURACAO := _nQtdDias
							SR8->R8_DIASEMP := 999
							SR8->R8_DPAGAR  := _nQtdDias
							SR8->R8_CONTINU := "2"
							SR8->R8_PER		:= Left(Dtos(_dDtInicial),6)
							SR8->R8_NUMPAGO := "01"
							SR8->R8_NUMID	:= "SR8" + TRB->RA_MAT + cCodVerba + DTOS(_dDtInicial)
							SR8->R8_SDPAGAR := 0
							SR8->R8_DPAGOS	:= 0
							SR8->R8_TPEFD	:= cTpEfd
							SR8->R8_PROCES 	:= "00001"
							SR8->R8_TPEFDAN := cTpEfd						
							If SR8->(FieldPos("R8_XVALEC")) <> 0
								SR8->R8_XVALEC  := "N"
							EndIf
							SR8->(MsUnlock())											
							
							RGE->(DbSetOrder(2))
							If Left(_CREFOPC,1) == "2" 
								iF !RGE->(DbSeek(xFilial("SRA")  + TRB->RA_MAT + DTOS(_dDtInicial)))
									Reclock("RGE",.T.)
										RGE->RGE_FILIAL := xFilial("SRA")
										RGE->RGE_MAT := TRB->RA_MAT
										//RGE->RGE_NOMEMP				
										RGE->RGE_DATAIN := _dDtInicial
										RGE->RGE_DATAFI := _dDtFinal
										RGE->RGE_PERCIR := 0
										RGE->RGE_DESCIR := "1"
										RGE->RGE_DEDINS	:= "2"								
										RGE->RGE_PPE	:= "1"
										RGE->RGE_RESEXT := "2"								
										RGE->RGE_CALENC	:= "123***************"
										RGE->RGE_COD	:= _cTpPPE
									RGE->(MsUnlock())
								else
									If RGE->RGE_DATAFI == CTOD("  /  /  ") .And. RGE->RGE_COD == "01" // Suspensao
										Reclock("RGE",.F.)
											RGE->RGE_DATAFI := _dDtFinal										
										RGE->(MsUnlock())	
									EndIf
									If RGE->RGE_COD	<> _cTpPPE
										Reclock("RGE",.F.)
											RGE->RGE_COD	:= _cTpPPE
										RGE->(MsUnlock())
									EndIf							
								EndIf
							EndIf							
							nQtdRegGrv ++
							Aadd(aRegOk,{XFILIAL("SRA"),"TRB->RB_MAT","TRB->RA_NOME","015 - LICENCA REMUNDERADA - EFD 16"})
						else
							Aadd(aRegNOk,{XFILIAL("SRA"),"TRB->RB_MAT","TRB->RA_NOME","ERRO NA GRAVAวรO DO REGISTRO"})
						EndIf
					Else
						If SR8->R8_DATAFIM == CTOD("  /  /  ")
							If RecLock("SR8",.F.)
								//SR8->R8_DATAINI := _dDtInicial
								SR8->R8_DATAFIM := _dDtFinal			
								SR8->R8_DURACAO := (_dDtFinal - _dDtInicial) 
								SR8->R8_DPAGAR  := (_dDtFinal - _dDtInicial)		
								SR8->(MsUnlock())											
							Endif	
						Endif
						
						RGE->(DbSetOrder(2))
						If Left(_CREFOPC,1) == "2" 
							iF RGE->(DbSeek(xFilial("SRA")  + TRB->RA_MAT + DTOS(_dDtInicial)))
								If RGE->RGE_COD	<> _cTpPPE
									Reclock("RGE",.F.)
										RGE->RGE_COD	:= _cTpPPE
									RGE->(MsUnlock())
								EndIf							
								If RGE->RGE_DATAFI == CTOD("  /  /  ") .And. _dDtFinal <> CTOD("  /  /  ")
									Reclock("RGE",.F.)
										RGE->RGE_DATAFI := _dDtFinal										
									RGE->(MsUnlock())	
								EndIf															
							EndIf
						EndIf							
						nQtdRegGrv ++
						Aadd(aRegOk,{XFILIAL("SRA"),"TRB->RB_MAT","TRB->RA_NOME","015 - LICENCA REMUNDERADA - EFD 16"})									
					EndIf	
				else
					RGE->(DbSetOrder(2))
					iF !RGE->(DbSeek(xFilial("SRA")  + TRB->RA_MAT + DTOS(_dDtInicial)))
						Reclock("RGE",.T.)
							RGE->RGE_FILIAL := xFilial("SRA")
							RGE->RGE_MAT := TRB->RA_MAT
							//RGE->RGE_NOMEMP				
							RGE->RGE_DATAIN := _dDtInicial
							RGE->RGE_DATAFI := _dDtFinal
							RGE->RGE_PERCIR := 0
							RGE->RGE_DESCIR := "1"
							RGE->RGE_DEDINS	:= "2"								
							RGE->RGE_PPE	:= "1"
							RGE->RGE_RESEXT := "2"								
							RGE->RGE_CALENC	:= "123***************"
							RGE->RGE_COD	:= _cTpPPE
						RGE->(MsUnlock())
						nQtdRegGrv ++
						Aadd(aRegOk,{XFILIAL("SRA"),"TRB->RB_MAT","TRB->RA_NOME","015 - LICENCA REMUNDERADA - EFD 16"})
					else
						If RGE->RGE_DATAFI == CTOD("  /  /  ") .And. RGE->RGE_COD == "02" // Suspensao
							Reclock("RGE",.F.)
								RGE->RGE_DATAFI := _dDtFinal	
							RGE->(MsUnlock())	
						EndIf
						If RGE->RGE_COD <>  _cTpPPE  
							Reclock("RGE",.F.)								
								RGE->RGE_COD 	:= _cTpPPE							
							RGE->(MsUnlock())								
						EndIf					
						nQtdRegGrv ++
						Aadd(aRegOk,{XFILIAL("SRA"),"TRB->RB_MAT","TRB->RA_NOME","015 - LICENCA REMUNDERADA - EFD 16"})												
					EndIf														
				EndIf			
			EndIf
			dbSelectArea("TRB")
			TRB->(dbSkip())
		ENDDO				
		MsgAlert("Grava็ใo Finalizada, foram inseridos " + Alltrim(Str(nQtdRegGrv))  + " de " + Alltrim(STR(nQtdMarked)) + " registros selecionados.")
	EndIf
Return lREt

Static Function ValidGRV()
Local lRet := .T.

If _dDtInicial == CTOD("  /  /  ")
	lRet := .F.
	MsgStop("A Data Inicial Deve Ser Informada.","Valida็ใo Grava็ใo")
EndIf

//If lRet .And. _dDtInicial < DDATABASE
//	lRet := .F.
//	MsgStop("A Data Inicial Deve Ser maior ou igual a data atual.","Valida็ใo Grava็ใo")
//EndIf


Return lREt

/* 
Static Function VMarkCheck()
Local lRet := .T.

oCbx2:Refresh()
oGetForn:Refresh()

Return lRet 
*/
