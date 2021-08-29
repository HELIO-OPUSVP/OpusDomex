#INCLUDE "PROTHEUS.CH"
#DEFINE MAXGETDAD 4096

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CADP03   ºAutor  ³Michel A. Sander    º Data ³  31.10.2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastro de equipes de inventário		                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User FUNCTION CADP03()

Local aCores := {}

PRIVATE aRotina := MenuDef()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de atualizacoes                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cCadastro := OemToAnsi("Cadastro de Equipes de Inventário")

MBrowse( 6, 1, 22, 75, "P03",,,,,,aCores)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MenuDef   ºAutor  ³Michel A. Sander    º Data ³  31.10.15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta Menu Principal 						                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MenuDef()

Local aRotina := { { 'Pesquisar'  ,"axPesqui",        0 , 1},; //Pesquisar
                   { 'Visualizar' ,"U_MANP03(2)", 0 , 2},;  //Visualizar
                   { 'Incluir'    ,"U_MANP03(3)", 0 , 3},; //Incluir
                   { 'Alterar'    ,"U_MANP03(4)", 0 , 4},;  //Alterar
                   { 'Excluir'    ,"U_MANP03(5)", 0 , 5} }  //Exclusão

Return aRotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MANP03		ºAutor  ³Michel A. Sander    º Data ³  31.10.15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Manutenção no cadastro de equipes de inventário		        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MANP03(nOpcX)

Local aObjects		 := {}
Local aInfo 		 := {}
Local aPosGet		 := {}
Local aPosObj		 := {}
Local aBut110		 := {}
Local aButtonUsr   := {}
Local aBtnBack		 := {}
Local aPosObjPE    := {}
Local nOpcA        := 0

PRIVATE aHeader    := {}
PRIVATE aCols      := {}
PRIVATE nTamEqui 	 := 0
PRIVATE nTamNome   := 0
PRIVATE nOpcWindow := nOpcX
PRIVATE oSayProduto
PRIVATE __CODEQUI  := ""
PRIVATE __NOMEQUI  := ""
PRIVATE __CODCOR   := ""
PRIVATE __NOMCOR   := ""
PRIVATE aCheck     := {}
PRIVATE oDlg
PRIVATE oCord

nTamEqui   := TamSX3("P03_CODIGO")[1]
nTamNome   := TamSX3("P03_NOME")[1]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem do aHeader (1)                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
nUsado :=0 
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("P03")
While ( !Eof() .And. SX3->X3_ARQUIVO == "P03" )
	If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL ) 
	   IF ALLTRIM(SX3->X3_CAMPO) == "P03_FILIAL" .Or. ALLTRIM(SX3->X3_CAMPO) == "P03_NOME" .Or. ALLTRIM(SX3->X3_CAMPO) == "P03_CODIGO" .Or. ;
	   		ALLTRIM(SX3->X3_CAMPO)=="P03_CODCOR" .Or. ALLTRIM(SX3->X3_CAMPO) == "P03_DESCOR"
			SX3->(dbSkip())
			Loop
		EndIf	
		nUsado++
		Aadd(aHeader,{ TRIM(X3Titulo()),;
			TRIM(SX3->X3_CAMPO),;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_F3,;
			SX3->X3_CONTEXT } )
	EndIf	
	dbSelectArea("SX3")
	dbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem do aCols 	                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpcX == 3		// INCLUSAO

	aadd(aCOLS,Array(nUsado+1))
	For nCntFor	:= 1 To nUsado
		aCols[1][nCntFor] := CriaVar(aHeader[nCntFor][2])
	Next nCntFor
	aCOLS[1][1] := StrZero(1,3)
	aCOLS[1][Len(aHeader)+1] := .F.
   __CODEQUI := GetSXENum("P03","P03_CODIGO")
	__NOMEQUI := SPACE(60)
	__CODCOR  := SPACE(06)
	__NOMCOR  := SPACE(60)
	
Else

   __CODEQUI := P03->P03_CODIGO
   __NOMEQUI := P03->P03_NOME
   __CODCOR  := P03->P03_CODCOR
   __NOMCOR  := Posicione("P02",1,xFilial("P02")+P03->P03_CODCOR,"P02_NOME")
	bWhile    := { || xFilial("P03") == P03->P03_FILIAL .And. __CODEQUI == P03->P03_CODIGO }
   nRegs 	 := 0
   P03->(dbSetOrder(1))
   P03->(dbSeek(xFilial("P03")+__CODEQUI))
	While ( P03->(!Eof()) .And. Eval(bWhile) )
		aadd(aCols,Array(nUsado+1))
		For nCntFor	:= 1 To nUsado
			If ( aHeader[nCntFor][10] != "V" )
				aCols[Len(aCols)][nCntFor] := P03->(FieldGet(FieldPos(aHeader[nCntFor][2])))
			Else
				aCols[Len(aCols)][nCntFor] := P03->(CriaVar(aHeader[nCntFor][2]))
			EndIf    
		Next nCntFor
		nRegs++
		aCols[nRegs,3] := Posicione("P01",1,xFilial("P01")+aCols[nRegs,2],"P01_DESC")		// Preenche campo virtual do browse com descricao do contador
		aCols[Len(aCols)][nUsado+1] := .F.
		P03->(dbSkip())
	EndDo

EndIf
                                                    
nGetDados := 0
If nOpcX == 3 .Or. nOpcX == 4
   nGetDados := 3
Else
   nGetDados := 5
EndIf

aSizeAut	:= MsAdvSize(,.F.)
aadd( aObjects, { 0,    30, .T., .F. } )
aadd( aObjects, { 100, 100, .T., .T. } )
aadd( aObjects, { 0,    3, .T., .F. } )
aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 2, 2 }
aPosObj := MsObjSize( aInfo, aObjects )
aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],305,{{10,35,100,135,205,255},{10,45,105,145,225,265,210,255}})

DEFINE MSDIALOG oDlg TITLE OemToAnsi("Cadastro de Equipes de Inventário") From aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL
@ aPosObj[1,1],aPosObj[1,2] TO aPosObj[1,3],aPosObj[1,4] LABEL ""  OF oDlg PIXEL 
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define o cabecalho da rotina                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ aPosObj[1,1]+11,aPosGet[1,1] SAY OemToAnsi("Codigo da Equipe") Of oDlg PIXEL
@ aPosObj[1,1]+10,aPosGet[1,2] MSGET __CODEQUI When .F. SIZE 80,10 Of oDlg PIXEL

@ aPosObj[1,1]+11,aPosGet[1,1]+150 SAY OemToAnsi("Nome da Equipe") Of oDlg PIXEL
@ aPosObj[1,1]+10,aPosGet[1,2]+140 MSGET __NOMEQUI When If(nOpcX==3,.T.,.F.) PICTURE "@!" SIZE 120,10 Of oDlg PIXEL

@ aPosObj[1,1]+11,aPosGet[1,1]+340 SAY OemToAnsi("Codigo da Coordenador") Of oDlg PIXEL
@ aPosObj[1,1]+10,aPosGet[1,2]+350 MSGET oCord VAR __CODCOR When If(nOpcX==3,.T.,.F.) F3 "P02" VALID U_VLDCORD() SIZE 40,10 Of oDlg PIXEL

@ aPosObj[1,1]+11,aPosGet[1,1]+460 SAY OemToAnsi("Nome") Of oDlg PIXEL
@ aPosObj[1,1]+10,aPosGet[1,2]+430 MSGET __NOMCOR When .F. PICTURE "@!" SIZE 150,10 Of oDlg PIXEL

//oSayProduto:oFont := TFont():New('Arial',,24,,.T.,,,,.T.,.F.)
	
oGet := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nGetDados,"U_VLDLINP03()","AllWaysTrue()","+P03_SEQ",,,MAXGETDAD,,,,,aHeader,aCols)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,oDlg:End()},{||nOpcA:=0,oDlg:End()})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza os dados					                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpcA == 1
   aCols := oGet:Acols
   U_P03_GRAVA()
Else
   RollbackSXE()
EndIf   

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³P03_GRAVA ºAutor  ³Michel A. Sander    º Data ³  31.10.2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gravação dos dados										           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function P03_GRAVA()
               
Local lProcura := .t.      
Local i 	   := 0
      
If nOpcWindow == 5

   nOk := Aviso("Atenção","Deseja mesmo excluir os dados da equipe ?",{"Sim","Não"})
   If nOk == 1
      P03->(dbSetOrder(1))
      If P03->(dbSeek(xFilial("P03")+__CODEQUI))
	  	 	Do While P03->(!Eof()) .And. P03->P03_FILIAL == xFilial("P03") .And. P03->P03_CODIGO == __CODEQUI
  		 		If RecLock("P03",.f.)
  	 				P03->(dbDelete())
  	 				P03->(MsUnlock())
  	 			Endif
  	 			P03->(dbSkip())
	  	 	Enddo
      Endif               
   EndIf   

ElseIf ( nOpcWindow == 3 .Or. nOpcWindow == 4 )

   lGrava := .F.	 
   For I:=1 to len(aCols)

       If !aCols[I][nUsado+1]

	       If nOpcWindow == 3

 	       	 If !P03->(dbSetOrder(3), dbSeek(xFilial("P03")+__CODEQUI+__CODCOR+aCols[i,2]))
	          	 Reclock("P03",.T.)
		          P03->P03_FILIAL  := xFilial("P03")
		          P03->P03_CODIGO  := __CODEQUI
		          P03->P03_NOME    := __NOMEQUI
		          P03->P03_SEQ     := aCols[I,1]
					 P03->P03_CODCOR  := __CODCOR
		          P03->P03_CODCON  := aCols[I,2]
		          P03->(MsUnlock())
		          lGrava := .T.
		       EndIf   

          ElseIf nOpcWindow == 4

 	       	 If P03->(dbSetOrder(3), dbSeek(xFilial("P03")+__CODEQUI+__CODCOR+aCols[i,2]))
	          	 Reclock("P03",.F.)
					 P03->P03_CODCOR  := __CODCOR
		          P03->P03_CODCON  := aCols[I,2]
		          P03->(MsUnlock())
       	 	 Else
	          	 Reclock("P03",.T.)
		          P03->P03_FILIAL  := xFilial("P03")
		          P03->P03_CODIGO  := __CODEQUI
		          P03->P03_NOME    := __NOMEQUI
					 P03->P03_CODCOR  := __CODCOR
		          P03->P03_CODCON  := aCols[I,2]
		          P03->(MsUnlock())
       	 	 EndIf   	 

	          lGrava := .T.
            
          EndIf   
	       
       Else
 	       	 
 	       If P03->(dbSetOrder(3), dbSeek(xFilial("P03")+__CODEQUI+__CODCOR+aCols[i,2]))
          	 Reclock("P03",.F.)
          	 P03->(dbdelete())
	          P03->(MsUnlock())
			 EndIf
				 	 
       EndIf   

   Next
                       
EndIf
		
Return(.t.)
                                                                          
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VLDLINP03   ºAutor  ³Michel A. Sander  º Data ³  31.10.15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida Linha digitada 						                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
                                    
User Function VLDLINP03()

LOCAL __RETLIN := .T.

nPosEquipe := ASCAN(aCheck, { |x| x[1] == aCols[n,2] } )
If nPosEquipe == 0
   AADD( aCheck, {aCols[n,2]} )
Else
   Aviso("Atenção","Já existe esse contador na mesma equipe",{"Ok"})
   __RETLIN := .F.
EndIf
   
Return ( __RETLIN )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VLDLINP03   ºAutor  ³Michel A. Sander  º Data ³  31.10.15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida Linha digitada 						                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VLDCORD()

LOCAL __lOk := .T.
P02->(dbSetOrder(1))
If !P02->(dbSeek(xFilial("P02")+__CODCOR))
	Aviso("Atenção","Coordenador não cadastrado.",{"Ok"})
	__lOk := .F.
	__CODCOR := SPACE(06)
	oCord:Refresh()
EndIf	

REturn(__lOk)