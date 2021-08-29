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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AGPEIMP1  ºAutor  ³Jackson Santos      º Data ³  08/30/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Programa para impressão dos documentos admissionais       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function AGPEIMP1()
Local oDlg
LOCAL bCondic 	:= { || } 
Local cCondic 	:= ""
Local cNoFields	:= "SZW"
Local cTabPrinc	:= "SZ1"

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
Private cCadastro := "Gestor de Documentos Admissionais e Demissionais"
Private lOkInc := .F.
Private lOkAlt := .F.
Private lOkExc := .F. 
Private VISUAL 	:= 0 
Private INCLUI	:= 0 
Private ALTERA	:= 0 
Private EXCLUI	:= 0 
Private cTit:= "Documentos Admissionais / Demissionais"
Private _aSize	  := MsAdvSize(,.F.,430)
Private _cCCusto :=Space(06) 
Private _cMatDe  :=Space(06)
Private _cMatAte :=Space(06)
Private _oChkLot := NIL
Private _lDoc01  := .F.
Private _lDoc02  := .F.
Private _lDoc03  := .F.
Private _lDoc04  := .F.
Private _lDoc05  := .F.
Private _lDoc06  := .F.
Private _lDoc07  := .F.
Private _lDoc08  := .F.
Private _lDoc09  := .F.
Private _lDoc10  := .F.
Private _lDoc11  := .F.
Private _lDoc12  := .F.
Private _lDoc13  := .F.
Private _lDoc14  := .F.
Private _lDoc15  := .F.
Private _nTotDoc := 12
Private _cMark   := GetMark()
Private _cSituaca:= "*****" //Space(05)
Private _dDataInf:= dDataBase
Private _dDataAdm:= CTOD("  /  /  ")
Private _CREFOPC := "1-Sim"
Private _aOpcao	 := {"1-Sim","2-Não"}
Private nQDocAimp:= 0

Static oFWLayer

Static oWin1
Static oWin2
Static oWin3
Static oWin4
Static oWin5

Static aHeader := {}
Static aCols   := {}       
Static aColsNew := {}

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
	oFWLayer:AddCollumn("Col03",47,.T.,"UP")
	oFWLayer:AddCollumn("Col04",47,.T.,"UP")	
	oFWLayer:AddCollumn("Col05",94,.T.,"DOWN")
	
	oFWLayer:AddWindow("Col01","Win01"	,"Ações"	,100,.F.,.F.,/*bAction*/,"UP"/*cIDLine*/,/*bGotFocus*/)	
	oFWLayer:AddWindow("Col02","Win02"	,"Sair"		,100,.F.,.F.,/*bAction*/,"DOWN"/*cIDLine*/,/*bGotFocus*/)
	oFWLayer:AddWindow("Col03","Win03"	,"Tipos de Impressão"	,100,.F.,.F.,/*bAction*/,"UP"/*cIDLine*/,/*bGotFocus*/)	
	oFWLayer:AddWindow("Col04","Win04"	,"Parâmetros Pesquisa"	,100,.F.,.F.,/*bAction*/,"UP"/*cIDLine*/,/*bGotFocus*/)		
	oFWLayer:AddWindow("Col05","Win05"	,"Dados da Pesquisa"	,100,.F.,.F.,/*bAction*/,"DOWN"/*cIDLine*/,/*bGotFocus*/) 
	
	oWin1 := oFWLayer:GetWinPanel('Col01','Win01',"UP")
	oWin2 := oFWLayer:GetWinPanel('Col02','Win02',"DOWN")
	oWin3 := oFWLayer:GetWinPanel('Col03','Win03',"UP")
	oWin4 := oFWLayer:GetWinPanel('Col04','Win04',"UP")
	oWin5 := oFWLayer:GetWinPanel('Col05','Win05',"DOWN")

	
	// Botï¿½es da tela
	oBtn0 := TButton():New(0,0,"Sair",oWin2,{|| oDlg:End() },00,14,,,.F.,.T.,.F.,,.F.,,,.F.) 
	oBtn0:Align  := CONTROL_ALIGN_BOTTOM
	
	oBtn1 := TButton():New(0,0,"Pesquisar",oWin1,{|| Processa( {|| fOkSeek() }, cTit, "Aguarde..." )},00,14,,,.F.,.T.,.F.,,.F.,,,.F.)																 
	oBtn1:Align  := CONTROL_ALIGN_TOP	
	@ 000, 000 SAY oBtn11 PROMPT Space(100) SIZE 049, 001 OF oWin1 PIXEL
	oBtn11:Align  := CONTROL_ALIGN_TOP
	
	oBtn2 := TButton():New(0,0,"Desmarcar",oWin1,{|| fMarkAll() },00,14,,,.F.,.T.,.F.,,.F.,,,.F.) 
	oBtn2:Align  := CONTROL_ALIGN_TOP

	@ 000, 000 SAY oBtn22 PROMPT Space(100) SIZE 049, 001 OF oWin1 PIXEL
	oBtn22:Align  := CONTROL_ALIGN_TOP

	oBtn3 := TButton():New(0,0,"Gerar Word",oWin1,{||Processa( {|| fImpWord() }, cTit, "Aguarde...gerando documento(s) em Word." ),oWin5:oBrowse:Refresh() },00,14,,,.F.,.T.,.F.,,.F.,,,.F.) 
	oBtn3:Align  := CONTROL_ALIGN_TOP		
	@ 000, 000 SAY oBtn33 PROMPT Space(100) SIZE 049, 001 OF oWin1 PIXEL
	oBtn33:Align  := CONTROL_ALIGN_TOP
	
	fOkSelec()
		
ACTIVATE MSDIALOG oDlg CENTERED

Return Nil

Static Function fOkSelec()
Local _aCampos   :={}                             

fGeraTRB()

dbSelectArea("TRB")
dbGotop()

aadd(_aCampos , {"OK"		   ,""} )
aadd(_aCampos , {"RA_MAT"      ,"Matricula"} )
aadd(_aCampos , {"RA_NOME"     ,"Nome"})
aadd(_aCampos , {"RA_CC"       ,"C.Custo"} )
aadd(_aCampos , {"RA_SITFOLH"  ,"Sit.Folha"} )
aadd(_aCampos , {"CTT_DESC01"  ,"Descr.CCusto"} )
aadd(_aCampos , {"RA_CODFUNC"  ,"Cod.Função"})
aadd(_aCampos , {"RJ_DESC"     ,"Descr.Função"})
aadd(_aCampos , {"RA_ADMISSA"  ,"Admissão"})
aadd(_aCampos , {"RA_SALARIO"  ,"Salário","@E 999,999.99","10","02"})
aadd(_aCampos , {"RA_DEPIR"    ,"Dep.IR",})
aadd(_aCampos , {"RA_DEPSF"	   ,"Dep.SF" })

@ aSize[4]/2.3,aSize[4] /6.5 To aSize[4]+5,aSize[3] Browse "TRB" Fields _aCampos Mark "OK" Object oWin5 

@ 001,002 CheckBox _oChkLot Var _lDoc08 Prompt "Contrato de Experiência" Message  Size 080, 007 Pixel Of oWin3
@ 010,002 CheckBox _oChkLot Var _lDoc01 Prompt "Contrato Indeterminado" Message  Size 080,007 Pixel Of oWin3
@ 020,002 CheckBox _oChkLot Var _lDoc02 Prompt "Sem Justa Causa" Message  Size 80, 007 Pixel Of oWin3
@ 030,002 CheckBox _oChkLot Var _lDoc03 Prompt "Termino Contrato Antecipado" Message  Size 125, 007 Pixel Of oWin3
@ 040,002 CheckBox _oChkLot Var _lDoc04 Prompt "Termino Contrato a Termo" Message  Size 095, 007 Pixel Of oWin3
@ 050,002 CheckBox _oChkLot Var _lDoc05 Prompt "Pedido de Demissao" Message  Size 100, 007 Pixel Of oWin3
@ 060,002 CheckBox _oChkLot Var _lDoc06 Prompt "Check List Demissional" Message  Size 80, 007 Pixel Of oWin3
@ 001,140 CheckBox _oChkLot Var _lDoc07 Prompt "Check List Admissional" Message  Size 80, 007 Pixel Of oWin3
@ 010,140 CheckBox _oChkLot Var _lDoc09 Prompt "Opção Pão-Declar. Beneficio" Message  Size 80, 007 Pixel Of oWin3
@ 020,140 CheckBox _oChkLot Var _lDoc10 Prompt "Opção Fruta-Declar. Benefício" Message  Size 80, 007 Pixel Of oWin3
@ 030,140 CheckBox _oChkLot Var _lDoc11 Prompt "Autorização de Desc. Benefício" Message  Size 80, 007 Pixel Of oWin3
@ 040,140 CheckBox _oChkLot Var _lDoc12 Prompt "Carta de Referência" Message  Size 80, 007 Pixel Of oWin3


@ 005,001 Say "Centro de Custo ?" PIXEL OF oWin4 
@ 005,060 MsGet _cCCusto Size 70,15 F3 "CTT" Valid If(Empty(_cCCusto),.T.,(Alltrim(_cCCusto)==AllTrim(POSICIONE("CTT", 1, xFilial("CTT") + _cCCusto, "CTT_CUSTO"))) ) Of oWin4 Pixel     
@ 005,140 Say "Situação ?" PIXEL OF oWin4 
@ 005,200 MsGet _cSituaca Size 70,15  Valid fSituacao()  Of oWin4 Pixel     
@ 025,001 Say "Matrícula de ?" PIXEL OF oWin4 
@ 025,060 MsGet _cMatDe Size 70,15 F3 "SRA" Valid If(Empty(_cMatDe),.T.,(_cMatDe==AllTrim(POSICIONE("SRA", 1, xFilial("SRA") + _cMatDe, "RA_MAT"))) )  Of oWin4 Pixel     
@ 025,140 Say "Matrícula ate ?" PIXEL OF oWin4 
@ 025,200 MsGet _cMatAte Size 70,15 F3 "SRA" Valid (_cMatDe $ "Z" .OR. _cMatAte==AllTrim(POSICIONE("SRA", 1, xFilial("SRA") + _cMatAte, "RA_MAT")))  Of oWin4 Pixel     
@ 045,001 Say "Data Admissão ?" PIXEL OF oWin4 
@ 045,060 MsGet _dDataAdm Size 70,15  Of oWin4 Pixel     
@ 045,140 Say "Data Aviso ?" PIXEL OF oWin4 
@ 045,200 MsGet _dDataInf Size 70,15  Of oWin4 Pixel     
@ 065,001 Say "Abre Documento?" PIXEL OF oWin4   
@ 065,060 MSCOMBOBOX oCbx Var _cRefOpc ITEMS _aOpcao Size 60,15 Of oWin4  PIXEL

//Activate Dialog oMov1 Centered

 
Return

//-----------------------------------------------------------------

Static Function fMarkAll()
Local lMarca 	:= Iif( TRB->OK <> _cMark, .T., .F.)
TRB->( dbGoTop() )
While TRB->(!EoF())
	RecLock( "TRB", .F. )
	TRB->OK := ThisMark()
	TRB->( MsUnlock() )
	oWin5:oBrowse:Refresh(.T.)
	TRB->(DbSkip())
End
TRB->( dbGoTop() )
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
cQuery+="RA_SALARIO,RA_DEPSF,RA_DEPIR "+Chr(10)+Chr(13)
cQuery+="From "+RetSqlName("SRA")+" SRA , "+Chr(10)+Chr(13)
cQuery+=RetSqlName("CTT")+" CTT , "+Chr(10)+Chr(13)
cQuery+=RetSqlName("SRJ")+" SRJ "+Chr(10)+Chr(13)
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
If! Empty(_cCCusto)
	cQuery+="And RA_CC = '"+_cCCusto+"' "+Chr(10)+Chr(13)
EndIf
cQuery+="And RA_CODFUNC = RJ_FUNCAO "+Chr(10)+Chr(13)

If! Empty(_cMatDe)
	cQuery+="And RA_MAT >= '"+_cMatDe+"' "+Chr(10)+Chr(13)
EndIf

If! Empty(_cMatAte)
	cQuery+="And RA_MAT <= '"+_cMatAte+"' "+Chr(10)+Chr(13)
EndIf
If _dDataAdm <> CTOD("  /  /  ")
	cQuery+="And RA_ADMISSA = '" + DTOS(_dDataAdm) + "' "+Chr(10)+Chr(13)
EndIf
cQuery+="Order By RA_MAT"

TCQuery cQuery ALIAS "SQL" NEW

TCSetField("SQL","RA_ADMISSA" ,"D",08,0)
TCSetField("SQL","RA_SALARIO" ,"N",14,2)

cArqTRB:= CriaTrab(NIL,.F.)
aCampos  := {}

AADD(aCampos,{"OK"	      ,"C",002,0})
AADD(aCampos,{"RA_MAT"	   ,"C",TAMSX3("RA_MAT")[1],0})
AADD(aCampos,{"RA_NOME"	   ,"C",TAMSX3("RA_NOME")[1],0})
AADD(aCampos,{"RA_CC"      ,"C",TAMSX3("RA_CC")[1],0})
AADD(aCampos,{"RA_SITFOLH" ,"C",12,0}) 
AADD(aCampos,{"CTT_DESC01" ,"C",TAMSX3("CTT_DESC01")[1]-25,0})
AADD(aCampos,{"RA_CODFUNC" ,"C",TAMSX3("RA_CODFUNC")[1],0})
AADD(aCampos,{"RJ_DESC"    ,"C",TAMSX3("RJ_DESC")[1]-15,0})
AADD(aCampos,{"RA_ADMISSA" ,"D",008,0})
AADD(aCampos,{"RA_SALARIO" ,"N",TAMSX3("RA_SALARIO")[1],TAMSX3("RA_SALARIO")[2]})
AADD(aCampos,{"RA_DEPIR"   ,"C",03,0}) 
AADD(aCampos,{"RA_DEPSF"   ,"C",03,0})

dbCreate(cArqTRB,aCampos)
dbUseArea(.T.,, cArqTRB, "TRB",)
Index On RA_MAT TO &cArqTRB

dbSelectArea("SQL")
dbGotop()
Do While.Not.Eof()
	dbSelectArea("TRB")
	Reclock("TRB",.T.)
	Replace TRB->OK          With Space(02)
	Replace TRB->RA_CC       With SQL->RA_CC
	Replace TRB->CTT_DESC01  With SQL->CTT_DESC01
	Replace TRB->RA_MAT      With SQL->RA_MAT
	Replace TRB->RA_NOME     With SQL->RA_NOME
	Replace TRB->RA_CODFUNC  With SQL->RA_CODFUNC
	Replace TRB->RJ_DESC     With SQL->RJ_DESC
	Replace TRB->RA_ADMISSA  With SQL->RA_ADMISSA
	Replace TRB->RA_SALARIO  With SQL->RA_SALARIO                
	Replace TRB->RA_DEPIR	 With SQL->RA_DEPIR
	Replace TRB->RA_DEPSF    With SQL->RA_DEPSF
	Replace TRB->RA_SITFOLH  With SQL->RA_SITFOLH
	TRB->(MsUnlock())
	dbSelectArea("SQL")
	dbSkip()
EndDo
dbSelectArea("TRB")
dbGotop()
_cSituaca:= "*****"
_cCCusto :=Space(TAMSX3("RA_CC")[1])
_cMatDe  :=Space(TAMSX3("RA_MAT")[1])
_cMatAte :=Space(TAMSX3("RA_MAT")[1])
oWin5:oBrowse:Refresh(.T.)
Return(_lRet)

//------------------------------------------------------------------

Static Function fGeraTRB()

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

cArqTRB:= CriaTrab(NIL,.F.)
aCampos  := {}

AADD(aCampos,{"OK"	      ,"C",002,0})
AADD(aCampos,{"RA_CC"      ,"C",TAMSX3("RA_CC")[1],0})
AADD(aCampos,{"CTT_DESC01"	,"C",TAMSX3("CTT_DESC01")[1]-25,0})
AADD(aCampos,{"RA_MAT"	   ,"C",TAMSX3("RA_MAT")[1],0})
AADD(aCampos,{"RA_NOME"	   ,"C",TAMSX3("RA_NOME")[1],0})
AADD(aCampos,{"RA_SITFOLH"  ,"C",TAMSX3("RA_CC")[1],0})
AADD(aCampos,{"RA_CODFUNC" ,"C",TAMSX3("RA_CODFUNC")[1],0})
AADD(aCampos,{"RJ_DESC"    ,"C",TAMSX3("RJ_DESC")[1]-15,0})
AADD(aCampos,{"RA_ADMISSA" ,"D",008,0})
AADD(aCampos,{"RA_SALARIO" ,"N",TAMSX3("RA_SALARIO")[1],TAMSX3("RA_SALARIO")[2]})
AADD(aCampos,{"RA_DEPIR"   ,"C",3,0})
AADD(aCampos,{"RA_DEPSF"   ,"C",3,0})

dbCreate(cArqTRB,aCampos)
dbUseArea(.T.,, cArqTRB, "TRB",)
Index On RA_CC+RA_MAT TO &cArqTRB

dbSelectArea("SQL")
dbGotop()
ProcRegua(RecCount())
Do While.Not.Eof()
	dbSelectArea("TRB")
	Reclock("TRB",.T.)
	Replace TRB->OK          With Space(02)
	Replace TRB->RA_CC       With ""
	Replace TRB->CTT_DESC01  With ""
	Replace TRB->RA_MAT      With ""
	Replace TRB->RA_NOME     With ""
	Replace TRB->RA_CODFUNC  With ""
	Replace TRB->RJ_DESC     With ""
	Replace TRB->RA_ADMISSA  With Ctod(" / / ")
	Replace TRB->RA_SALARIO  With 0
	Replace TRB->RA_DEPIR	 With "0"
	Replace TRB->RA_DEPSF    With "0"
	Replace TRB->RA_SITFOLH  With ""
	TRB->(MsUnlock())
	dbSelectArea("SQL")
	dbSkip()
EndDo

Return

//------------------------------------------------------------------ï¿½

Static Function fImpWord()
Local oWord
Local cFileSave := GetTempPath()
Local cPath     :="\word\"   
Local cPathDest :="C:\Gestor_documentos_Gpe\"
Local cArqDot   :=""
Local _lContinua:=.F.
Local lAbreDoc	 := Substr(Alltrim(_cRefOpc),1,1) == "1"
_nTotDoc := 12
For _nI:=1 To _nTotDoc
	_cVar  :="_lDoc"+StrZero(_nI,2)
	If &_cVar
		_lContinua:=.T.
	EndIf
Next

If _lContinua
	dbSelectArea("TRB")
	dbGotop()
	Do While.Not.Eof()
		If Marked("OK")

			BeginMsOle()
			oWord := OLE_CreateLink()     
			
		   For _nI:=1 To _nTotDoc
				_cVar  :="_lDoc"+StrZero(_nI,2)
				cArqDot:="DOC"+StrZero(_nI,4)
				cExtensao := iif(_nI==12,".dotm",".dot")
				If &_cVar
					
					If !File( cPath+cArqDot+cExtensao ) // Verifica a existencia do DOT no ROOTPATH Protheus / Servidor
						MsgStop( "Arquivo " + cPath +cArqDot+cExtensao+" não encontrado!"+Chr(13)+Chr(10)+'Utilize a opção " Gerar PDF ".', ProcName())
						Return
					Else
						MontaDir("C:\")					  	
						
						If File( Alltrim( cFileSave + cArqDot+cExtensao ) )
							Ferase( Alltrim( cFileSave + cArqDot+cExtensao ) )
						EndIf
						//Apagar o .doc caso encontre
						If File( Alltrim( cFileSave + cArqDot+".doc" ) )
							Ferase( Alltrim( cFileSave + cArqDot+".doc" ) )
						EndIf

						CpyS2T( cPath+cArqDot+cExtensao,cFileSave, .T. )

						OLE_NewFile( oWord , Alltrim(cFileSave+cArqDot+cExtensao) )

						OLE_SetProperty( oWord, oleWdVisible, .T. )

						OLE_SetProperty( oWord, oleWdPrintBack, .F. )

						// Exibe ou oculta a aplicacao Word.
						OLE_SetProperty( oWord, oleWdWindowState, .F. )

						Do Case
							
							Case _nI == 1                        
								dbSelectArea("SRA")
								dbSetOrder(1)
								If dbSeek(xFilial("SRA")+TRB->RA_MAT)
									OLE_SetDocumentVar( oWord, 'GPE_NOME'        , SRA->RA_NOMECMP )
								   	OLE_SetDocumentVar( oWord, 'GPE_CTPS'        , SRA->RA_NUMCP )
								   	OLE_SetDocumentVar( oWord, 'GPE_CTPS_SERIE'  , SRA->RA_SERCP )
								   	OLE_SetDocumentVar( oWord, 'GPE_UF_CTPS'     , SRA->RA_UFCP )   								   
								   	OLE_SetDocumentVar( oWord, 'GPE_CPF'         , SRA->RA_CIC)
								   
								   	dbSelectArea("SRJ")
									dbSetOrder(1)
									dbSeek(xFilial("SRJ")+SRA->RA_CODFUNC)
									OLE_SetDocumentVar( oWord, 'GPE_FUNCAO_NOME', SRJ->RJ_DESC )
								
									dbSelectArea("SR6")
									dbSetOrder(1)
									dbSeek(xFilial("SR6")+SRA->RA_TNOTRAB)
									OLE_SetDocumentVar( oWord, 'GPE_TURNO_DESCRICAO', Alltrim(SR6->R6_DESC) )
								  	
								  	CTT->(dbSetOrder(1))
									CTT->(dbSeek(xFilial("CTT")+SRA->RA_CC))
	 								OLE_SetDocumentVar( oWord, 'GPE_DESCRICAO_CCUSTO', Alltrim(TRB->CTT_DESC01))
								  							  
									OLE_SetDocumentVar( oWord, 'GPE_SALARIO'     , TransForm(SRA->RA_SALARIO,"@E 999,999,999.99"))
								   	OLE_SetDocumentVar( oWord, 'GPE_SAL_EXTENSO' , ALLTRIM(Extenso(SRA->RA_SALARIO)))
									OLE_SetDocumentVar( oWord, 'GPE_DT_ADMISSAO' , Dtoc(SRA->RA_ADMISSA) )
								  	OLE_SetDocumentVar( oWord, 'GPE_DIA_DO_MES'  , AllTrim(Str(Day(SRA->RA_ADMISSA))) )
								   	OLE_SetDocumentVar( oWord, 'GPE_MES_EXTENSO' , MesExtenso( Month(SRA->RA_ADMISSA)) )
								   	OLE_SetDocumentVar( oWord, 'GPE_ANO'         , AllTrim(Str(Year(SRA->RA_ADMISSA))) )
															
								   
								   	OLE_UpDateFields( oWord )
								
								 	OLE_SaveAsFile( oWord, Alltrim(cFileSave+cArqDot+".doc"),'','',.F.,oleWdFormatDocument )
									Sleep(1000)
									//Fechar A conexão com o documento para poder renomear e mover.
									OLE_CloseLink( oWord)
									
									MontaDir(cPathDest)
									cNovoNomeD:= Alltrim(cArqDot+"_" + Alltrim(SRA->RA_MAT)+"_"+Alltrim(SRA->RA_NOME)+".doc")								
									if File(Alltrim(cPathDest+cNovoNomeD) ) 
										Ferase( Alltrim( cPathDest+cNovoNomeD ) )	
									EndIf
									FRename( alltrim(cFileSave+cArqDot+".doc"), Alltrim(cPathDest+cNovoNomeD),Nil,)          
									
									//cFileSave+cArqDot+"_" + Alltrim(SRA->RA_MAT)+"_"+Alltrim(SRA->RA_NOME)								
									IF lAbreDoc							
										if File(Alltrim(cPathDest+cNovoNomeD) ) 
											ShellExecute('open',Alltrim(cPathDest+cNovoNomeD),"","",5)
										Endif
									EndIf
									
								EndIf
							Case _nI == 2						
								
								dbSelectArea("SRA")
								dbSetOrder(1)
								If dbSeek(xFilial("SRA")+TRB->RA_MAT)
									OLE_SetDocumentVar( oWord, 'GPE_NOME'        , SRA->RA_NOMECMP )
									OLE_SetDocumentVar( oWord, 'GPE_DEMISSAO'    , Dtoc(_dDataInf))
									OLE_SetDocumentVar( oWord,'GPE_DIA_DO_MES' 	, AllTrim(Str(Day(_dDataInf))))
								   	OLE_SetDocumentVar( oWord, 'GPE_MES_EXTENSO'	, MesExtenso( Month(_dDataInf)))
								   	OLE_SetDocumentVar( oWord, 'GPE_ANO'        	, AllTrim(Str(Year(_dDataInf))))
								
									OLE_SetDocumentVar( oWord, 'GPE_CTPS_SERIE'  , SRA->RA_SERCP )
									OLE_SetDocumentVar( oWord, 'GPE_UF_CTPS'     , SRA->RA_UFCP )
									OLE_SetDocumentVar( oWord, 'GPE_CTPS'        , SRA->RA_NUMCP )
								
									dbSelectArea("SRJ")
								   	dbSetOrder(1)
								   	dbSeek(xFilial("SRJ")+SRA->RA_CODFUNC)
								   	OLE_SetDocumentVar( oWord, 'GPE_FUNCAO_NOME', SRJ->RJ_DESC)
									
									OLE_UpDateFields( oWord )
								
								 	OLE_SaveAsFile( oWord, Alltrim(cFileSave+cArqDot+".doc"),'','',.F.,oleWdFormatDocument )
									Sleep(1000)
									//Fechar A conexï¿½o com o documento para poder renomear e mover.
									OLE_CloseLink( oWord)
									
									Sleep(1000)

									MontaDir(cPathDest)
									cNovoNomeD:= Alltrim(cArqDot+"_" + Alltrim(SRA->RA_MAT)+"_"+Alltrim(SRA->RA_NOME)+".doc")								
									if File(Alltrim(cPathDest+cNovoNomeD) ) 
										Ferase( Alltrim( cPathDest+cNovoNomeD ) )	
									EndIf
									FRename( alltrim(cFileSave+cArqDot+".doc"), Alltrim(cPathDest+cNovoNomeD),Nil,)          									
							
									IF lAbreDoc																	
										if File(Alltrim(cPathDest+cNovoNomeD) ) 
											ShellExecute('open',Alltrim(cPathDest+cNovoNomeD),"","",5)
										Endif
									EndIf								
								EndIf
																
							Case _nI == 3								
																					
								dbSelectArea("SRA")
								dbSetOrder(1)
								If dbSeek(xFilial("SRA")+TRB->RA_MAT)
									OLE_SetDocumentVar( oWord, 'GPE_NOME'           , SRA->RA_NOMECMP )
								   	OLE_SetDocumentVar( oWord, 'GPE_MATRICULA'   	, SRA->RA_MAT )			
									OLE_SetDocumentVar( oWord, 'GPE_CTPS_SERIE'     , SRA->RA_SERCP )
									OLE_SetDocumentVar( oWord, 'GPE_CTPS'           , SRA->RA_NUMCP )
									OLE_SetDocumentVar( oWord, 'GPE_UF_CTPS'        , SRA->RA_UFCP )
	    							OLE_SetDocumentVar( oWord, 'GPE_ADMISSAO'       , Dtoc(SRA->RA_ADMISSA) )
									//OLE_SetDocumentVar( oWord, 'GPE_DEMISSAO'     	, Dtoc(SRA->RA_DEMISSA))
									OLE_SetDocumentVar( oWord, 'GPE_DEMISSAO'     	, DTOC(_dDataInf))
	   								OLE_SetDocumentVar( oWord, 'GPE_EXPERIENCIA_DT'	, If( Empty(SRA->RA_VCTEXP2), Dtoc(SRA->RA_VCTOEXP) ,IIF( DDATABASE < SRA->RA_VCTOEXP  , Dtoc(SRA->RA_VCTOEXP) , Dtoc(SRA->RA_VCTEXP2))))
									OLE_SetDocumentVar( oWord, 'GPE_DATA_INFORMADA'	, DTOC(_dDataInf) )
																
									OLE_SetDocumentVar( oWord, 'GPE_DIA_DO_MES'   , AllTrim(Str(Day(_dDataInf))) )
									OLE_SetDocumentVar( oWord, 'GPE_MES_EXTENSO'  , MesExtenso( Month(_dDataInf)) )
									OLE_SetDocumentVar( oWord, 'GPE_ANO'          , AllTrim(Str(Year(_dDataInf))) )
									
									dbSelectArea("SRJ")
									dbSetOrder(1)
									dbSeek(xFilial("SRJ")+SRA->RA_CODFUNC)
									OLE_SetDocumentVar( oWord, 'GPE_FUNCAO_NOME', SRJ->RJ_DESC)
									   
									OLE_UpDateFields( oWord )
								
								 	OLE_SaveAsFile( oWord, Alltrim(cFileSave+cArqDot+".doc"),'','',.F.,oleWdFormatDocument )
									Sleep(1000)
									//Fechar A conexï¿½o com o documento para poder renomear e mover.
									OLE_CloseLink( oWord)
									
									MontaDir(cPathDest)
									cNovoNomeD:= Alltrim(cArqDot+"_" + Alltrim(SRA->RA_MAT)+"_"+Alltrim(SRA->RA_NOME)+".doc")								
									if File(Alltrim(cPathDest+cNovoNomeD) ) 
										Ferase( Alltrim( cPathDest+cNovoNomeD ) )	
									EndIf
									FRename( alltrim(cFileSave+cArqDot+".doc"), Alltrim(cPathDest+cNovoNomeD),Nil,)          									
									
									IF lAbreDoc							
										if File(Alltrim(cPathDest+cNovoNomeD) ) 
											ShellExecute('open',Alltrim(cPathDest+cNovoNomeD),"","",5)
										Endif
									EndIf
									
								 EndIf
							Case _nI == 4

								dbSelectArea("SRA")
								dbSetOrder(1)
								If dbSeek(xFilial("SRA")+TRB->RA_MAT)
									OLE_SetDocumentVar( oWord,'GPE_MATRICULA' 		, SRA->RA_MAT)
									OLE_SetDocumentVar( oWord, 'GPE_NOME'         , SRA->RA_NOMECMP)
									OLE_SetDocumentVar( oWord, 'GPE_CTPS_SERIE'   , SRA->RA_SERCP)
									OLE_SetDocumentVar( oWord, 'GPE_CTPS'         , SRA->RA_NUMCP)
									//OLE_SetDocumentVar( oWord, 'GPE_SALARIO'      , TransForm(SRA->RA_SALARIO,"@E 999,999,999.99"))
								   
								   	OLE_SetDocumentVar( oWord, 'GPE_CTPS_UF'        , SRA->RA_UFCP )
	    							OLE_SetDocumentVar( oWord, 'GPE_DT_ADMISSAO'       , Dtoc(SRA->RA_ADMISSA) )
									//OLE_SetDocumentVar( oWord, 'GPE_DT_DEMISSAO'     	, Dtoc(SRA->RA_DEMISSA))
									OLE_SetDocumentVar( oWord, 'GPE_DT_DEMISSAO'     	, Dtoc(_dDataInf))
									   
									OLE_SetDocumentVar( oWord, 'GPE_EXPERIENCIA_DT_2'	, If( Empty(SRA->RA_VCTEXP2), Dtoc(SRA->RA_VCTOEXP) ,IIF( DDATABASE < SRA->RA_VCTOEXP  , Dtoc(SRA->RA_VCTOEXP) , Dtoc(SRA->RA_VCTEXP2))))
									//OLE_SetDocumentVar( oWord, 'GPE_DATA_INFORMADA' 	, _dDataInf )
									
									OLE_SetDocumentVar( oWord, 'GPE_DIA_DO_MES'   , AllTrim(Str(Day(_dDataInf))) )
									OLE_SetDocumentVar( oWord, 'GPE_MES_EXTENSO'  , MesExtenso( Month(_dDataInf)) )
									OLE_SetDocumentVar( oWord, 'GPE_ANO'          , AllTrim(Str(Year(_dDataInf))) )
									OLE_UpDateFields( oWord )
								
									dbSelectArea("SRJ")
									dbSetOrder(1)
									dbSeek(xFilial("SRJ")+SRA->RA_CODFUNC)
									OLE_SetDocumentVar( oWord, 'GPE_FUNCAO_NOME', SRJ->RJ_DESC)
									   
									OLE_UpDateFields( oWord )
								
								 	OLE_SaveAsFile( oWord, Alltrim(cFileSave+cArqDot+".doc"),'','',.F.,oleWdFormatDocument )
									Sleep(1000)
									//Fechar A conexï¿½o com o documento para poder renomear e mover.
									OLE_CloseLink( oWord)
									
									MontaDir(cPathDest)
									cNovoNomeD:= Alltrim(cArqDot+"_" + Alltrim(SRA->RA_MAT)+"_"+Alltrim(SRA->RA_NOME)+".doc")								
									if File(Alltrim(cPathDest+cNovoNomeD) ) 
										Ferase( Alltrim( cPathDest+cNovoNomeD ) )	
									EndIf
									FRename( alltrim(cFileSave+cArqDot+".doc"), Alltrim(cPathDest+cNovoNomeD),Nil,)          									
									
									IF lAbreDoc							
										if File(Alltrim(cPathDest+cNovoNomeD) ) 
											ShellExecute('open',Alltrim(cPathDest+cNovoNomeD),"","",5)
										Endif
									EndIf
								EndIf								

							Case _nI == 5
								
								dbSelectArea("SRA")
								dbSetOrder(1)
								If dbSeek(xFilial("SRA")+TRB->RA_MAT)
									OLE_SetDocumentVar( oWord,'GPE_MATRICULA' 		, SRA->RA_MAT)
									OLE_SetDocumentVar( oWord, 'GPE_NOME'         	, SRA->RA_NOMECMP)
									OLE_SetDocumentVar( oWord, 'GPE_CTPS_SERIE'   	, SRA->RA_SERCP)
									OLE_SetDocumentVar( oWord, 'GPE_CTPS'         	, SRA->RA_NUMCP)								  
								   	OLE_SetDocumentVar( oWord, 'GPE_CTPS_UF'        , SRA->RA_UFCP )
	    							OLE_SetDocumentVar( oWord, 'GPE_DT_ADMISSAO'    , Dtoc(SRA->RA_ADMISSA) )
	    							OLE_SetDocumentVar( oWord, 'GPE_DT_DEMISSAO'    , Dtoc(_dDataInf))
									OLE_SetDocumentVar( oWord, 'GPE_DATA_INFORMADA' , DTOC(_dDataInf) )									
									OLE_SetDocumentVar( oWord, 'GPE_DIA_DO_MES'   	, AllTrim(Str(Day(_dDataInf))) )
									OLE_SetDocumentVar( oWord, 'GPE_MES_EXTENSO'  	, MesExtenso( Month(_dDataInf)) )
									OLE_SetDocumentVar( oWord, 'GPE_ANO'          	, AllTrim(Str(Year(_dDataInf))) )
									OLE_UpDateFields( oWord )
								
									dbSelectArea("SRJ")
									dbSetOrder(1)
									dbSeek(xFilial("SRJ")+SRA->RA_CODFUNC)
									OLE_SetDocumentVar( oWord, 'GPE_FUNCAO_NOME', SRJ->RJ_DESC)
									   
									OLE_UpDateFields( oWord )
								
								 	OLE_SaveAsFile( oWord, Alltrim(cFileSave+cArqDot+".doc"),'','',.F.,oleWdFormatDocument )
									Sleep(1000)
									//Fechar A conexï¿½o com o documento para poder renomear e mover.
									OLE_CloseLink( oWord)
									
									MontaDir(cPathDest)
									cNovoNomeD:= Alltrim(cArqDot+"_" + Alltrim(SRA->RA_MAT)+"_"+Alltrim(SRA->RA_NOME)+".doc")								
									if File(Alltrim(cPathDest+cNovoNomeD) ) 
										Ferase( Alltrim( cPathDest+cNovoNomeD ) )	
									EndIf
									FRename( alltrim(cFileSave+cArqDot+".doc"), Alltrim(cPathDest+cNovoNomeD),Nil,)          									
									
									IF lAbreDoc							
										if File(Alltrim(cPathDest+cNovoNomeD) ) 
											ShellExecute('open',Alltrim(cPathDest+cNovoNomeD),"","",5)
										Endif
									EndIf
								EndIf								

							Case _nI == 6
								 
								dbSelectArea("SRA")
								dbSetOrder(1)
								If dbSeek(xFilial("SRA")+TRB->RA_MAT)
									OLE_SetDocumentVar( oWord,'GPE_MATRICULA' 		, SRA->RA_MAT)
									OLE_SetDocumentVar( oWord, 'GPE_NOME'         	, SRA->RA_NOMECMP)
									OLE_SetDocumentVar( oWord, 'GPE_CTPS_SERIE'   	, SRA->RA_SERCP)
									OLE_SetDocumentVar( oWord, 'GPE_CTPS'         	, SRA->RA_NUMCP)									
								   OLE_SetDocumentVar( oWord, 'GPE_CTPS_UF'        , SRA->RA_UFCP )
								   OLE_SetDocumentVar( oWord, 'GPE_CPF'          	, SRA->RA_CIC)
									OLE_SetDocumentVar( oWord, 'GPE_PIS'          	, SRA->RA_PIS)								   
	    							OLE_SetDocumentVar( oWord, 'GPE_DT_ADMISSAO'    , Dtoc(SRA->RA_ADMISSA) )
									//OLE_SetDocumentVar( oWord, 'GPE_DT_DEMISSAO'    , Dtoc(SRA->RA_DEMISSA))	   							
									OLE_SetDocumentVar( oWord, 'GPE_DT_DEMISSAO'    , Dtoc(_dDataInf))
									OLE_SetDocumentVar( oWord, 'GPE_DATA_INFORMADA'	, DTOC(_dDataInf))   
									
									
									OLE_SetDocumentVar( oWord, 'GPE_DIA_DO_MES'   	, AllTrim(Str(Day(_dDataInf))) )
									OLE_SetDocumentVar( oWord, 'GPE_MES_EXTENSO'  	, MesExtenso( Month(_dDataInf)) )
									OLE_SetDocumentVar( oWord, 'GPE_ANO'          	, AllTrim(Str(Year(_dDataInf))) )
									OLE_UpDateFields( oWord )
								
									dbSelectArea("SRJ")
									dbSetOrder(1)
									dbSeek(xFilial("SRJ")+SRA->RA_CODFUNC)
									OLE_SetDocumentVar( oWord, 'GPE_FUNCAO_NOME'		, SRJ->RJ_DESC)
									   
									OLE_UpDateFields( oWord )
								
								 	OLE_SaveAsFile( oWord, Alltrim(cFileSave+cArqDot+".doc"),'','',.F.,oleWdFormatDocument )
									Sleep(1000)
									//Fechar A conexï¿½o com o documento para poder renomear e mover.
									OLE_CloseLink( oWord)
									
									MontaDir(cPathDest)
									cNovoNomeD:= Alltrim(cArqDot+"_" + Alltrim(SRA->RA_MAT)+"_"+Alltrim(SRA->RA_NOME)+".doc")								
									if File(Alltrim(cPathDest+cNovoNomeD) ) 
										Ferase( Alltrim( cPathDest+cNovoNomeD ) )	
									EndIf
									FRename( alltrim(cFileSave+cArqDot+".doc"), Alltrim(cPathDest+cNovoNomeD),Nil,)          									
									
									IF lAbreDoc							
										if File(Alltrim(cPathDest+cNovoNomeD) ) 
											ShellExecute('open',Alltrim(cPathDest+cNovoNomeD),"","",5)
										Endif
									EndIf
								EndIf								
							Case _nI == 7
								
								dbSelectArea("SRA")
								dbSetOrder(1)
								if dbSeek(xFilial("SRA")+TRB->RA_MAT)
									OLE_SetDocumentVar( oWord, 'GPE_NOME' , SRA->RA_NOMECMP)							
									OLE_SetDocumentVar( oWord, 'GPE_DT_ADMISSAO' , Dtoc(SRA->RA_ADMISSA) )
								
								
									OLE_UpDateFields( oWord )
								
								 	OLE_SaveAsFile( oWord, Alltrim(cFileSave+cArqDot+".doc"),'','',.F.,oleWdFormatDocument )
									Sleep(1000)
									//Fechar A conexï¿½o com o documento para poder renomear e mover.
									OLE_CloseLink( oWord)
									
									MontaDir(cPathDest)
									cNovoNomeD:= Alltrim(cArqDot+"_" + Alltrim(SRA->RA_MAT)+"_"+Alltrim(SRA->RA_NOME)+".doc")								
									if File(Alltrim(cPathDest+cNovoNomeD) ) 
										Ferase( Alltrim( cPathDest+cNovoNomeD ) )	
									EndIf
									FRename( alltrim(cFileSave+cArqDot+".doc"), Alltrim(cPathDest+cNovoNomeD),Nil,)          									
									
									IF lAbreDoc							
										if File(Alltrim(cPathDest+cNovoNomeD) ) 
											ShellExecute('open',Alltrim(cPathDest+cNovoNomeD),"","",5)
										Endif
									EndIf
								EndIf
							Case _nI == 8
															
								dbSelectArea("SM0")
								
								OLE_SetDocumentVar( oWord, 'GPE_RAZAO_SOCIAL', SM0->M0_NOMECOM)
								OLE_SetDocumentVar( oWord, 'GPE_CNPJ'     , SubStr(SM0->M0_CGC,1,2)+"."+SubStr(SM0->M0_CGC,3,3)+"."+SubStr(SM0->M0_CGC,6,3)+"/"+SubStr(SM0->M0_CGC,9,4)+"-"+SubStr(SM0->M0_CGC,13,2))
								OLE_SetDocumentVar( oWord, 'GPE_ENDERECO' , Alltrim(SM0->M0_ENDCOB))
								OLE_SetDocumentVar( oWord, 'GPE_NUMERO'   , "")
								OLE_SetDocumentVar( oWord, 'GPE_BAIRRO'   , Alltrim(SM0->M0_BAIRCOB))
								OLE_SetDocumentVar( oWord, 'GPE_CIDADE'   , Alltrim(SM0->M0_CIDCOB))
								//OLE_SetDocumentVar( oWord, 'GPE_CEP'      , Alltrim(SM0->M0_CEPCOB))
								//OLE_SetDocumentVar( oWord, 'GPE_UF'       , SM0->M0_ESTCOBï¿½)
								
								dbSelectArea("SRA")
								dbSetOrder(1)
								dbSeek(xFilial("SRA")+TRB->RA_MAT)
								OLE_SetDocumentVar( oWord,'GPE_MATRICULA' 		, SRA->RA_MAT)
								OLE_SetDocumentVar( oWord, 'GPE_NOME'        	, SRA->RA_NOMECMP)
								OLE_SetDocumentVar( oWord, 'GPE_CTPS_SERIE'		, SRA->RA_SERCP)
								OLE_SetDocumentVar( oWord, 'GPE_CTPS'        	, SRA->RA_NUMCP)
								OLE_SetDocumentVar( oWord, 'GPE_CTPS_UF'			, SRA->RA_UFCP )
								OLE_SetDocumentVar( oWord, 'GPE_SALARIO'			, TransForm(SRA->RA_SALARIO,"@E 999,999,999.99"))
								OLE_SetDocumentVar( oWord, 'GPE_DT_ADMISSAO'		, Dtoc(SRA->RA_ADMISSA))
								OLE_SetDocumentVar( oWord, 'GPE_DT_EXPERIENCIA'	, Dtoc(SRA->RA_VCTOEXP))
								OLE_SetDocumentVar( oWord, 'GPE_EXPERIENCIA_DT_2', Dtoc(SRA->RA_VCTEXP2))
								OLE_SetDocumentVar( oWord, 'GPE_CPF'             , SRA->RA_CIC)
								OLE_SetDocumentVar( oWord, 'GPE_DESCRICAO_CCUSTO', Alltrim(TRB->CTT_DESC01))
								dbSelectArea("SRJ")
								dbSetOrder(1)
								dbSeek(xFilial("SRJ")+SRA->RA_CODFUNC)
								OLE_SetDocumentVar( oWord, 'GPE_FUNCAO_NOME', SRJ->RJ_DESC)
								
								dbSelectArea("SR6")
								dbSetOrder(1)
								dbSeek(xFilial("SRJ")+SRA->RA_TNOTRAB)
								OLE_SetDocumentVar( oWord, 'GPE_TURNO_DESCRICAO', Alltrim(SR6->R6_DESC))

								
								OLE_SetDocumentVar( oWord, 'GPE_DIA_DO_MES' , AllTrim(Str(Day(SRA->RA_ADMISSA))))
								OLE_SetDocumentVar( oWord, 'GPE_MES_EXTENSO', MesExtenso( Month(SRA->RA_ADMISSA)))
								OLE_SetDocumentVar( oWord, 'GPE_ANO'        , AllTrim(Str(Year(SRA->RA_ADMISSA))))
								
								OLE_UpDateFields( oWord )
								
								OLE_SaveAsFile( oWord, Alltrim(cFileSave+cArqDot+".doc"),'','',.F.,oleWdFormatDocument )
								Sleep(1000)
								
								//Fechar A conexï¿½o com o documento para poder renomear e mover.
								OLE_CloseLink( oWord)
								
								MontaDir(cPathDest)
								cNovoNomeD:= Alltrim(cArqDot+"_" + Alltrim(SRA->RA_MAT)+"_"+Alltrim(SRA->RA_NOME)+".doc")								
								if File(Alltrim(cPathDest+cNovoNomeD) ) 
										Ferase( Alltrim( cPathDest+cNovoNomeD ) )	
								EndIf
								FRename( alltrim(cFileSave+cArqDot+".doc"), Alltrim(cPathDest+cNovoNomeD),Nil,)          
								
								//cFileSave+cArqDot+"_" + Alltrim(SRA->RA_MAT)+"_"+Alltrim(SRA->RA_NOME)								
								IF lAbreDoc							
									if File(Alltrim(cPathDest+cNovoNomeD) ) 
										ShellExecute('open',Alltrim(cPathDest+cNovoNomeD),"","",5)
									Endif
								EndIf
								
							/*Case _nI == 9
								
								dbSelectArea("SRA")
								dbSetOrder(1)
								If dbSeek(xFilial("SRA")+TRB->RA_MAT)
									OLE_SetDocumentVar( oWord, 'GPE_NOME'    	, SRA->RA_NOMECMP)
									OLE_SetDocumentVar( oWord, 'GPE_ADMISSAO'	, Dtoc(SRA->RA_ADMISSA))
									OLE_SetDocumentVar( oWord, 'GPE_EXPERIENCIA_DT_2', Dtoc(SRA->RA_VCTEXP2))
									OLE_SetDocumentVar( oWord, 'GPE_CCUSTO_DESCRICAO', Alltrim(TRB->CTT_DESC01))
									OLE_SetDocumentVar( oWord, 'GPE_MATRICULA'   , SRA->RA_MAT)
									OLE_SetDocumentVar( oWord, 'GPE_CPF'             , SRA->RA_CIC)

									dbSelectArea("SRJ")
									dbSetOrder(1)
									dbSeek(xFilial("SRJ")+SRA->RA_CODFUNC)
									OLE_SetDocumentVar( oWord, 'GPE_FUNCAO_NOME', SRJ->RJ_DESC)
																
									OLE_UpDateFields( oWord )
								
									OLE_SaveAsFile( oWord, Alltrim(cFileSave+cArqDot+".doc"),'','',.F.,oleWdFormatDocument )
									Sleep(1000)
									
									//Fechar A conexï¿½o com o documento para poder renomear e mover.
									OLE_CloseLink( oWord)
									
									MontaDir(cPathDest)
									cNovoNomeD:= Alltrim(cArqDot+"_" + Alltrim(SRA->RA_MAT)+"_"+Alltrim(SRA->RA_NOME)+".doc")								
									FRename( alltrim(cFileSave+cArqDot+".doc"), Alltrim(cPathDest+cNovoNomeD),Nil,)          
									
									//cFileSave+cArqDot+"_" + Alltrim(SRA->RA_MAT)+"_"+Alltrim(SRA->RA_NOME)								
									IF lAbreDoc							
										ShellExecute('open',Alltrim(cPathDest+cNovoNomeD),"","",5)
									EndIf									
								EndIf
								//OLE_PrintFile( oWord, "ALL" ,,, 1 )
							*/
							Case _nI == 09
								
								dbSelectArea("SRA")
								dbSetOrder(1)
								If dbSeek(xFilial("SRA")+TRB->RA_MAT)
									OLE_SetDocumentVar( oWord, 'GPE_NOME'       , SRA->RA_NOMECMP)									
									OLE_SetDocumentVar( oWord, 'GPE_MATRICULA'  , SRA->RA_MAT)
									OLE_SetDocumentVar( oWord, 'GPE_CTPS_SERIE'	, SRA->RA_SERCP)
									OLE_SetDocumentVar( oWord, 'GPE_CTPS'       , SRA->RA_NUMCP)
									OLE_SetDocumentVar( oWord, 'GPE_CPF'        , SRA->RA_CIC)
									
									OLE_UpDateFields( oWord )
								
									OLE_SaveAsFile( oWord, Alltrim(cFileSave+cArqDot+".doc"),'','',.F.,oleWdFormatDocument )
									Sleep(1000)
									
									//Fechar A conexï¿½o com o documento para poder renomear e mover.
									OLE_CloseLink( oWord)
									
									MontaDir(cPathDest)
									cNovoNomeD:= Alltrim(cArqDot+"_" + Alltrim(SRA->RA_MAT)+"_"+Alltrim(SRA->RA_NOME)+".doc")								
									if File(Alltrim(cPathDest+cNovoNomeD) ) 
										Ferase( Alltrim( cPathDest+cNovoNomeD ) )	
									EndIf
									FRename( alltrim(cFileSave+cArqDot+".doc"), Alltrim(cPathDest+cNovoNomeD),Nil,)          
									
									//cFileSave+cArqDot+"_" + Alltrim(SRA->RA_MAT)+"_"+Alltrim(SRA->RA_NOME)								
									IF lAbreDoc							
										if File(Alltrim(cPathDest+cNovoNomeD) ) 
											ShellExecute('open',Alltrim(cPathDest+cNovoNomeD),"","",5)
										Endif
									EndIf									
								EndIf	

							Case _nI == 10
							
								dbSelectArea("SRA")
								dbSetOrder(1)
								If dbSeek(xFilial("SRA")+TRB->RA_MAT)
									OLE_SetDocumentVar( oWord, 'GPE_NOME'       , SRA->RA_NOMECMP)									
									OLE_SetDocumentVar( oWord, 'GPE_MATRICULA'  , SRA->RA_MAT)
									OLE_SetDocumentVar( oWord, 'GPE_CTPS_SERIE'	, SRA->RA_SERCP)
									OLE_SetDocumentVar( oWord, 'GPE_CTPS'       , SRA->RA_NUMCP)
									OLE_SetDocumentVar( oWord, 'GPE_CPF'        , SRA->RA_CIC)
									
									OLE_UpDateFields( oWord )
								
									OLE_SaveAsFile( oWord, Alltrim(cFileSave+cArqDot+".doc"),'','',.F.,oleWdFormatDocument )
									Sleep(1000)
									
									//Fechar A conexï¿½o com o documento para poder renomear e mover.
									OLE_CloseLink( oWord)
									
									MontaDir(cPathDest)
									cNovoNomeD:= Alltrim(cArqDot+"_" + Alltrim(SRA->RA_MAT)+"_"+Alltrim(SRA->RA_NOME)+".doc")								
									if File(Alltrim(cPathDest+cNovoNomeD) ) 
										Ferase( Alltrim( cPathDest+cNovoNomeD ) )	
									EndIf
									FRename( alltrim(cFileSave+cArqDot+".doc"), Alltrim(cPathDest+cNovoNomeD),Nil,)          
									
									//cFileSave+cArqDot+"_" + Alltrim(SRA->RA_MAT)+"_"+Alltrim(SRA->RA_NOME)								
									IF lAbreDoc							
										if File(Alltrim(cPathDest+cNovoNomeD) ) 
											ShellExecute('open',Alltrim(cPathDest+cNovoNomeD),"","",5)
										Endif
									EndIf									
								EndIf									
							Case _nI == 11																	

								dbSelectArea("SRA")
								dbSetOrder(1)
								If dbSeek(xFilial("SRA")+TRB->RA_MAT)
									OLE_SetDocumentVar( oWord, 'GPE_NOME'       , SRA->RA_NOMECMP)									
									OLE_SetDocumentVar( oWord, 'GPE_CPF'        , SRA->RA_CIC)
									
									OLE_UpDateFields( oWord )
								
									OLE_SaveAsFile( oWord, Alltrim(cFileSave+cArqDot+".doc"),'','',.F.,oleWdFormatDocument )
									Sleep(1000)
									
									//Fechar A conexï¿½o com o documento para poder renomear e mover.
									OLE_CloseLink( oWord)
									
									MontaDir(cPathDest)
									cNovoNomeD:= Alltrim(cArqDot+"_" + Alltrim(SRA->RA_MAT)+"_"+Alltrim(SRA->RA_NOME)+".doc")								
									if File(Alltrim(cPathDest+cNovoNomeD) ) 
										Ferase( Alltrim( cPathDest+cNovoNomeD ) )	
									EndIf
									FRename( alltrim(cFileSave+cArqDot+".doc"), Alltrim(cPathDest+cNovoNomeD),Nil,)          
									
									//cFileSave+cArqDot+"_" + Alltrim(SRA->RA_MAT)+"_"+Alltrim(SRA->RA_NOME)								
									IF lAbreDoc							
										if File(Alltrim(cPathDest+cNovoNomeD) ) 
											ShellExecute('open',Alltrim(cPathDest+cNovoNomeD),"","",5)
										Endif
									EndIf									
								EndIf	  
							/*Case _nI == 11									
								
								dbSelectArea("SRA")
								dbSetOrder(1)
								If dbSeek(xFilial("SRA")+TRB->RA_MAT)
									OLE_SetDocumentVar( oWord, 'GPE_NOME'       , SRA->RA_NOMECMP)									
									OLE_SetDocumentVar( oWord, 'GPE_CPF'        , SRA->RA_CIC)
									
									OLE_UpDateFields( oWord )
								
									OLE_SaveAsFile( oWord, Alltrim(cFileSave+cArqDot+".doc"),'','',.F.,oleWdFormatDocument )
									Sleep(1000)
									
									//Fechar A conexï¿½o com o documento para poder renomear e mover.
									OLE_CloseLink( oWord)
									
									MontaDir(cPathDest)
									cNovoNomeD:= Alltrim(cArqDot+"_" + Alltrim(SRA->RA_MAT)+"_"+Alltrim(SRA->RA_NOME)+".doc")								
									FRename( alltrim(cFileSave+cArqDot+".doc"), Alltrim(cPathDest+cNovoNomeD),Nil,)          
									
									//cFileSave+cArqDot+"_" + Alltrim(SRA->RA_MAT)+"_"+Alltrim(SRA->RA_NOME)								
									IF lAbreDoc							
										if File(Alltrim(cPathDest+cNovoNomeD) ) 
											ShellExecute('open',Alltrim(cPathDest+cNovoNomeD),"","",5)
										Endif
									EndIf									
								EndIf	          						     
							*/        						     
							Case _ni == 12
								dbSelectArea("SRA")
								dbSetOrder(1)
								If dbSeek(xFilial("SRA")+TRB->RA_MAT)
									OLE_SetDocumentVar( oWord, 'GPE_NOME'        , SRA->RA_NOMECMP )
								   	OLE_SetDocumentVar( oWord, 'GPE_CTPS'        , SRA->RA_NUMCP )
								   	OLE_SetDocumentVar( oWord, 'GPE_CTPS_SERIE'  , SRA->RA_SERCP )
								   	OLE_SetDocumentVar( oWord, 'GPE_UF_CTPS'     , SRA->RA_UFCP )   								   
								   	//OLE_SetDocumentVar( oWord, 'GPE_CPF'         , SRA->RA_CIC)
									OLE_SetDocumentVar( oWord, 'GPE_ADMISSAO'	, DTOC(SRA->RA_ADMISSA))
									OLE_SetDocumentVar( oWord, 'GPE_DEMISSAO' 	, DTOC(SRA->RA_DEMISSA))
									OLE_SetDocumentVar( oWord, 'GPE_DIA_DO_MES' , AllTrim(Str(Day(SRA->RA_DEMISSA))) )
									OLE_SetDocumentVar( oWord, 'GPE_MES_EXTENSO', MesExtenso( Month(SRA->RA_DEMISSA)) )
									OLE_SetDocumentVar( oWord, 'GPE_ANO'        , AllTrim(Str(Year(SRA->RA_DEMISSA))) )
									   
									aAreaTRB := TRB->(GetArea())
									nQtdFunc := 0							
									aFuncoes  := {}

									dbSelectArea("SRJ")
									SRJ->(dbSetOrder(1))
											
									cQryFun := " SELECT R7_FUNCAO,R7_DATA DTINICIAL "
									cQryFun += " FROM " + RetSQlName("SR7") + " SR7 "
									cQryFun += " WHERE D_E_L_E_T_ ='' AND SR7.R7_FILIAL  ='" +xFilial("SR7") + "' AND SR7.R7_MAT = '" + SRA->RA_MAT + "' AND R7_TIPO NOT IN ('003','002','007') "
									cQryFun += " ORDER BY R_E_C_N_O_"
									if Select("TMPFUN")	 > 0
										TMPFUN->(DbCloseArea())
									EndIf
									TCQUERY cQryFun NEW ALIAS "TMPFUN"
									If TMPFUN->(!EOF())
										
										While TMPFUN->(!EOF())
											nQtdFunc ++	
											AaDd(aFuncoes,{TMPFUN->R7_FUNCAO,STOD(TMPFUN->DTINICIAL)})
											TMPFUN->(DbSkip())											
										EndDo
										TMPFUN->(DbCloseArea())										
										
										OLE_SetDocumentVar( oWord, 'GPE_NUM_FUNCOES',ALLTRIM(STR(nQtdFunc)))	

										If nQtdFunc > 1
											For nK:= 1 To  Len(aFuncoes)												
												SRJ->(dbSeek(xFilial("SRJ")+aFuncoes[nK][1]))												
												_cVarNome := 'GPE_FUN_NOME_'+STRZERO(nK,1)
												_cVarDIni := 'GPE_FUN_DTINI_'+STRZERO(nK,1)
												_cVarDFim := 'GPE_FUN_DTFIM_'+STRZERO(nK,1)
												
												OLE_SetDocumentVar( oWord,_cVarNome, Alltrim(SRJ->RJ_DESC) )
												OLE_SetDocumentVar( oWord,_cVarDIni, DTOC(aFuncoes[nK][2]) )
												OLE_SetDocumentVar( oWord,_cVarDFim, IIF( nK == nQtdFunc,DTOC(SRA->RA_DEMISSA),DTOC(aFuncoes[nK + 1][2]-1) ) )												
											Next nK											
										else
											SRJ->(dbSeek(xFilial("SRJ")+SRA->RA_CODFUNC))												
											_cVarNome := 'GPE_FUN_NOME_'+Alltrim(STR(1))
											_cVarDIni := 'GPE_FUN_DTINI_'+Alltrim(STR(1))
											_cVarDFim := 'GPE_FUN_DTFIM_'+Alltrim(STR(1))
										
											OLE_SetDocumentVar( oWord, _cVarNome, Alltrim(SRJ->RJ_DESC))
											OLE_SetDocumentVar( oWord, _cVarDIni, DTOC(SRA->RA_ADMISSA) )
											OLE_SetDocumentVar( oWord, _cVarDFim, DTOC(SRA->RA_DEMISSA) )											
										Endif
									else
										OLE_SetDocumentVar( oWord, 'GPE_NUM_FUNCOES',ALLTRIM(STR(1)))	
										SRJ->(dbSeek(xFilial("SRJ")+SRA->RA_CODFUNC))												
										_cVarNome := 'GPE_FUN_NOME_'+Alltrim(STR(1))
										_cVarDIni := 'GPE_FUN_DTINI_'+Alltrim(STR(1))
										_cVarDFim := 'GPE_FUN_DTFIM_'+Alltrim(STR(1))
										OLE_SetDocumentVar( oWord, _cVarNome, Alltrim(SRJ->RJ_DESC))
										OLE_SetDocumentVar( oWord, _cVarDIni, DTOC(SRA->RA_ADMISSA) )
										OLE_SetDocumentVar( oWord, _cVarDFim, DTOC(SRA->RA_DEMISSA) )												
									EndIf	
								  									   
															
									OLE_ExecuteMacro( oWord, 'Funcao' )
								   	OLE_UpDateFields( oWord )
								
								 	OLE_SaveAsFile( oWord, Alltrim(cFileSave+cArqDot+".doc"),'','',.F.,oleWdFormatDocument )
									Sleep(1000)
									//Fechar A conexão com o documento para poder renomear e mover.
									OLE_CloseLink( oWord)
									
									MontaDir(cPathDest)
									cNovoNomeD:= Alltrim(cArqDot+"_" + Alltrim(SRA->RA_MAT)+"_"+Alltrim(SRA->RA_NOME)+".doc")								
									if File(Alltrim(cPathDest+cNovoNomeD) ) 
										Ferase( Alltrim( cPathDest+cNovoNomeD ) )	
									EndIf
									FRename( alltrim(cFileSave+cArqDot+".doc"), Alltrim(cPathDest+cNovoNomeD),Nil,)          
									
									//cFileSave+cArqDot+"_" + Alltrim(SRA->RA_MAT)+"_"+Alltrim(SRA->RA_NOME)								
									IF lAbreDoc							
										if File(Alltrim(cPathDest+cNovoNomeD) ) 
											ShellExecute('open',Alltrim(cPathDest+cNovoNomeD),"","",5)
										Endif
									EndIf
									RestArea(aAreaTRB)
								EndIf
						EndCase						
					EndIf
				EndIf
			Next
		EndIf
		dbSelectArea("TRB")
		TRB->(dbSkip())
	EndDo
	dbSelectArea("TRB")
	TRB->(dbGotop())
	
	//MsgInfo("Salve o documento , o Microsoft Word será fechado.","A t e n ç ã o")
	OLE_CloseFile( oWord )
	
	// Fechar o link com a aplicação
	OLE_CloseLink( oWord, .F. )
	
	EndMsOle()
		
Else
	MsgInfo("Selecione um documento.","A t e n ç ã o")
EndIf

Return
