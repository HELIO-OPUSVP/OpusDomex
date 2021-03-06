#INCLUDE "PROTHEUS.CH"
#DEFINE MAXGETDAD 4096

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CADSZW   �Autor  �Michel A. Sander    � Data �  17.09.15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro de embalagens nivel 3			                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User FUNCTION CADSZW()

Local aCores := {}

PRIVATE aRotina := MenuDef()

//��������������������������������������������������������������Ŀ
//� Define o cabecalho da tela de atualizacoes                   �
//����������������������������������������������������������������
PRIVATE cCadastro := OemToAnsi("Controle de Embalagens Nivel 3")

MBrowse( 6, 1, 22, 75, "SZW",,,,,,aCores)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MenuDef   �Autor  �Michel A. Sander    � Data �  01/05/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Monta Menu Principal 						                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function MenuDef()

Local aRotina := { { 'Pesquisar'  ,"axPesqui",        0 , 1},; //Pesquisar
                   { 'Visualizar' ,"U_MANSZW(2)", 0 , 2},;  //Visualizar
                   { 'Incluir'    ,"U_MANSZW(3)", 0 , 3},; //Incluir
                   { 'Alterar'    ,"U_MANSZW(4)", 0 , 4},;  //Alterar
                   { 'Excluir'    ,"U_MANSZW(5)", 0 , 5} }  //Exclus�o

Return aRotina

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MANSZW		�Autor  �Michel A. Sander    � Data �  02.09.13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Controle de embalagens nivel 3   						        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MANSZW(nOpcX)

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
PRIVATE __GRUPRO   := ""
PRIVATE __CODCLI   := ""
PRIVATE __LOJCLI   := ""
PRIVATE __DESCLI   := ""
PRIVATE __DESPRO   := ""
PRIVATE nTamPro 	 := 0
PRIVATE nOpcWindow := nOpcX
PRIVATE oSayProduto

nTamPro    := TamSX3("ZW_GRUPO")[1]
nTamCli    := TamSX3("ZW_CLIENTE")[1]
nTamLoj    := TamSX3("ZW_LOJA")[1]
__GRUPRO   := SPACE( nTamPro )
__CODCLI   := SPACE( nTamCli )
__LOJCLI   := SPACE( nTamLoj )

//������������������������������������������������������Ŀ
//�Montagem do aHeader (1)                               �
//��������������������������������������������������������   
nUsado :=0 
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SZW")
While ( !Eof() .And. SX3->X3_ARQUIVO == "SZW" )
	If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL ) 
	   IF ALLTRIM(SX3->X3_CAMPO) == "ZW_FILIAL" .Or. ALLTRIM(SX3->X3_CAMPO) == "ZW_DESC" .Or. ALLTRIM(SX3->X3_CAMPO) == "ZW_GRUPO" .Or. ;
	   		ALLTRIM(SX3->X3_CAMPO) == "ZW_CLIENTE" .Or. ALLTRIM(SX3->X3_CAMPO) == "ZW_LOJA"
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

//������������������������������������������������������Ŀ
//�Montagem do aCols 	                                 �
//��������������������������������������������������������
If nOpcX == 3		// INCLUSAO
	aadd(aCOLS,Array(nUsado+1))
	For nCntFor	:= 1 To nUsado
		aCols[1][nCntFor] := CriaVar(aHeader[nCntFor][2])
	Next nCntFor
	aCOLS[1][1] := StrZero(1,3)
	aCOLS[1][Len(aHeader)+1] := .F.

Else

   __GRUPRO := SZW->ZW_GRUPO
   __CODCLI := SZW->ZW_CLIENTE
   __LOJCLI := SZW->ZW_LOJA
   __DESPRO := Posicione("SBM",1,xFilial("SBM")+__GRUPRO,"BM_DESC")
	bWhile   := {|| xFilial("SZW") == SZW->ZW_FILIAL .And. ;
	                __GRUPRO       == SZW->ZW_GRUPO }
   nRegs := 0
   SZW->(dbSeek(xFilial("SZW")+__GRUPRO))
	While ( SZW->(!Eof()) .And. Eval(bWhile) )
		aadd(aCols,Array(nUsado+1))
		For nCntFor	:= 1 To nUsado
			If ( aHeader[nCntFor][10] != "V" )
				aCols[Len(aCols)][nCntFor] := SZW->(FieldGet(FieldPos(aHeader[nCntFor][2])))
			Else
				aCols[Len(aCols)][nCntFor] := SZW->(CriaVar(aHeader[nCntFor][2]))
			EndIf    
		Next nCntFor
		nRegs++
		aCols[nRegs,3] := Posicione("SB1",1,xFilial("SB1")+aCols[nRegs,2],"B1_DESC")		// Preenche campo virtual do browse com descricao do produto
		aCols[Len(aCols)][nUsado+1] := .F.
		SZW->(dbSkip())
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

DEFINE MSDIALOG oDlg TITLE OemToAnsi("Controle de Embalagens Nivel 3") From aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL
@ aPosObj[1,1],aPosObj[1,2] TO aPosObj[1,3],aPosObj[1,4] LABEL ""  OF oDlg PIXEL 
	
//��������������������������������������������������������������Ŀ
//�Define o cabecalho da rotina                                  �
//����������������������������������������������������������������
@ aPosObj[1,1]+11,aPosGet[1,1] SAY OemToAnsi("Codigo do Grupo") Of oDlg PIXEL
@ aPosObj[1,1]+10,aPosGet[1,2] MSGET __GRUPRO When If(Empty(__GRUPRO),.T.,.F.) Picture PesqPict("SZW","ZW_GRUPO") F3 "SBM" Valid VerifPro() SIZE 80,10 Of oDlg PIXEL

@ aPosObj[1,1]+11,aPosGet[1,1]+330 SAY OemToAnsi("Codigo Cliente") Of oDlg PIXEL
@ aPosObj[1,1]+10,aPosGet[1,2]+320 MSGET __CODCLI When If(nOpcX==3,.T.,.F.) Picture PesqPict("SZW","ZW_CLIENTE") F3 "SA1" Valid VerifCli() SIZE 30,10 Of oDlg PIXEL
@ aPosObj[1,1]+10,aPosGet[1,2]+365 MSGET __LOJCLI When .F. Picture PesqPict("SZW","ZW_LOJA") SIZE 20,10 Of oDlg PIXEL
	
@ 12, 170 SAY oSayProduto PROMPT __DESPRO PIXEL SIZE 300, 16 OF oDlg
oSayProduto:oFont := TFont():New('Arial',,24,,.T.,,,,.T.,.F.)
	
oGet := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nGetDados,"U_VLDLINSZW()","AllWaysTrue()","+ZW_SEQ",,,MAXGETDAD,,,,,aHeader,aCols)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,oDlg:End()},{||nOpcA:=0,oDlg:End()})

//��������������������������������������������������������������Ŀ
//�Atualiza os dados					                                  �
//����������������������������������������������������������������
If nOpcA == 1
   aCols := oGet:Acols
   U_SZW_GRAVA()
Else
   RollbackSX8()
EndIf   

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SZW_GRAVA �Autor  �Michel A. Sander    � Data �  01/05/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para atualizar a programa��o de Hora Extra          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function SZW_GRAVA()
               
Local lProcura := .t.      
Local i 	   := 0
      
If nOpcWindow == 5

   nOk := Aviso("Aten��o","Deseja mesmo excluir os dados de embalagem ?",{"Sim","N�o"})
   If nOk == 1
      SZW->(dbSetOrder(2))
      If SZW->(dbSeek(xFilial("SZW")+__GRUPRO+__CODCLI+__LOJCLI))
	  	 	Do While SZW->(!Eof()) .And. SZW->ZW_FILIAL == xFilial("SZW") .And. SZW->ZW_GRUPO == __GRUPRO .And. SZW->ZW_CLIENTE == __CODCLI .And. SZW->ZW_LOJA == __LOJCLI
  		 		If RecLock("SZW",.f.)
  	 				SZW->(dbDelete())
  	 				SZW->(MsUnlock())
  	 			Endif
  	 			SZW->(dbSkip())
	  	 	Enddo
      Endif               
   EndIf   

ElseIf ( nOpcWindow == 3 .Or. nOpcWindow == 4 )

   lGrava := .F.	 
   For I:=1 to len(aCols)

       If !aCols[I][nUsado+1]

	       If nOpcWindow == 3

 	       	 If !SZW->(dbSetOrder(2), dbSeek(xFilial("SZW")+__GRUPRO+__CODCLI+__LOJCLI+aCols[I,4]+aCols[I,1]))
	          	 Reclock("SZW",.T.)
		          SZW->ZW_FILIAL  := xFilial("SZW")
		          SZW->ZW_GRUPO   := __GRUPRO
		          SZW->ZW_CLIENTE := __CODCLI
		          SZW->ZW_LOJA    := __LOJCLI
		          SZW->ZW_SEQ     := aCols[I,1]
		          SZW->ZW_CODEMB  := aCols[I,2]
		          SZW->ZW_NIVEL   := aCols[I,4]
		          SZW->ZW_QTDEDE  := aCols[I,5]
		          SZW->ZW_QTDEATE := aCols[I,6]
		          SZW->ZW_PESO	  := aCols[I,7]
		          SZW->(MsUnlock())
		          lGrava := .T.
		       EndIf   

          ElseIf nOpcWindow == 4

 	       	 If SZW->(dbSetOrder(2), dbSeek(xFilial("SZW")+__GRUPRO+__CODCLI+__LOJCLI+aCols[I,4]+aCols[I,1]))
       	 	 	 Reclock("SZW",.F.)
		          SZW->ZW_CODEMB  := aCols[I,2]
		          SZW->ZW_NIVEL   := aCols[I,4]
		          SZW->ZW_QTDEDE  := aCols[I,5]
		          SZW->ZW_QTDEATE := aCols[I,6]
		          SZW->ZW_PESO	  := aCols[I,7]
		          SZW->(MsUnlock())
       	 	 Else
       	 	 	 Reclock("SZW",.T.)
		          SZW->ZW_FILIAL  := xFilial("SZW")
		          SZW->ZW_GRUPO := __GRUPRO
		          SZW->ZW_SEQ     := aCols[I,1]
		          SZW->ZW_CLIENTE := __CODCLI
		          SZW->ZW_LOJA    := __LOJCLI
		          SZW->ZW_CODEMB  := aCols[I,2]
		          SZW->ZW_NIVEL   := aCols[I,4]
		          SZW->ZW_QTDEDE  := aCols[I,5]
		          SZW->ZW_QTDEATE := aCols[I,6]
		          SZW->ZW_PESO	  := aCols[I,7]
		          SZW->(MsUnlock())
       	 	 EndIf   	 
	          lGrava := .T.
            
          EndIf   
	       
       Else
 	       	 
 	       If SZW->(dbSetOrder(2), dbSeek(xFilial("SZW")+__GRUPRO+__CODCLI+__LOJCLI+aCols[I,4]+aCols[I,1]))
    	 	 	 Reclock("SZW",.F.)
     		    SZW->(dbDelete())
			 	 SZW->(MsUnlock())
			 EndIf
				 	 
       EndIf   

   Next
                       
EndIf
		
Return(.t.)
                                                                          
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VerifPro  �Autor  �Michel A. Sander    � Data �  01/05/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida Grupo de Produto						                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function VerifPro()
      
Local lReturn := .T. 

SBM->(dbSetOrder(1))
If !SBM->(dbSeek(xFilial("SB1")+__GRUPRO))
  	Aviso("Aten��o","Grupo de Produto n�o cadastrado",{"Ok"})
	__DESPRO := SPACE(30)
	oSayProduto:Refresh()
  	lReturn := .F.
Else	
	__DESPRO := SBM->BM_DESC
	oSayProduto:Refresh()
EndIf

Return(lReturn)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VerifCli  �Autor  �Michel A. Sander    � Data �  01/05/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida Grupo de Produto						                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function VerifCli()
      
Local lReturn := .T. 

If !Empty(__CODCLI)
	SA1->(dbSetOrder(1))
	If !SA1->(dbSeek(xFilial("SA1")+__CODCLI))
	  	Aviso("Aten��o","Cliente n�o cadastrado",{"Ok"})
	  	lReturn := .F.
	Else
	  	__LOJCLI := SA1->A1_LOJA
	  	oDlg:Refresh()
	EndIf
EndIf

Return(lReturn)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VLDLINSZW   �Autor  �Michel A. Sander  � Data �  09.09.13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida Linha digitada 						                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
                                    
User Function VLDLINSZW()

LOCAL __RETLIN := .T.

/*
For a := 1 to Len(aCols)
    If SB1->(dbSeek(xFilial("SB1")+aCols[a,2]))
       If SB1->B1_TIPO <> "ME"
          Aviso("Aten��o","O Item "+aCols[a,2]+CHR(13)+"n�o est� classificado com embalagem.",{"OK"})
          __RETLIN := .F.
       Endif
    EndIf
    If a > 1
       If aCols[(a-1),6] > aCols[a,5]
          Aviso("Aten��o","As quantidades est�o inconsistentes",{"Ok"})
          __RETLIN := .F.     
       ElseIf aCols[a,5] > aCols[a,6]   
          Aviso("Aten��o","As quantidades inicial menor que a quantidade final",{"Ok"})
          __RETLIN := .F.     
       Endif
    EndIf
Next
*/
   
Return ( __RETLIN )