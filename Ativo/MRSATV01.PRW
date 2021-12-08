#INCLUDE "Protheus.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MRSATV01 ³ Autor ³  Marco Aurelio        ³ Data ³ 18/05/16  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Importacao de arquivo do ativo fixo 	        	           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// jonas 08122021
User Function MRSATV01()

Local lRet        := .T.
Local cArquivo  	:= ""
Local cCadastro	:= OemToAnsi("Importação de Planilha de Ativo Fixo.")
Local nHandle   	:= 0
Local nOpca			:= 0
Local aButtons		:= {}
Local aSays			:= {}

Aadd(aSays,OemToAnsi( "Esta rotina realiza a importação dos registros do ativo fixo. [.CSV]" ) )
Aadd(aButtons, { 1,.T.,{|| nOpca := 1, FechaBatch()}} )
Aadd(aButtons, { 2,.T.,{|| nOpca := 0, FechaBatch()}} )

FormBatch( cCadastro , aSays , aButtons )
	
IF nOpca == 0
	Return(.T.)
EndIF

cArquivo := Upper(Alltrim(cGetFile("Arquivos *.CSV|*.CSV","Selecione o arquivo para importação.")))

IF !Empty(cArquivo)
	nHandle	 := FT_FUSE(cArquivo)
	Processa( {|lEnd| LeArq() } , "Lendo Arquivo...")
	FClose(nHandle)
EndIF

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ LeArq    ³ Autor ³  Eduardo Patriani     ³ Data ³ 24/04/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Importa dados.                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function LeArq()

Local cBuffer
Local cProduto
Local cNumSerie                   
Local cPlaqueta                   
Local cGrupo
Local aAtivo 		:= {}
Local aAux      	:= {}

Local aItens 		:= {} 
Local aDadosAuto 	:= {} 
Local aParamAuto 	:= {} 
Local aCab 			:= {} 

// Posicão dos Itens
Local nx_CBASE		:= 1
Local nx_ITEM		:= 2
Local nx_DESCRIC	:= 3
Local nx_AQUISIC	:= 5
Local nx_VORIG1	:= 10
Local nx_GRUPO		:= 18
Local nx_CHAPA		:= 19
Local nx_CCONTAB	:= 20
Local nx_CDEPREC	:= 21
Local nx_TXDEPR1	:= 7
Local nx_VRDACM1	:= 16

/*
Local nx_NSERIE	:=
Local nx_NFISCAL	:=
Local nx_FORNEC	:=
Local nx_LOJA		:=
Local nx_CCUSTO	:=
*/

FT_FGOTOP()
ProcRegua(FT_FLASTREC())

While ! FT_FEOF()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Leitura do arquivo texto.                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cBuffer := FT_FREADLN()
	aAux    := U_Str2Array(cBuffer,";")
	AAdd( aAtivo , aAux)
		
	IncProc()
	FT_FSKIP(1)	
EndDo          

IF Len(aAtivo) > 0

//	IncProc()

	// Comeca nX com 2 para ignorar Cabecalho
	For nX := 2 To Len(aAtivo)

	//		Importa(aAtivo,nX)
     aCab   := {} 
     aItens := {} 

     aCab := {	{"N1_FILIAL"	,xFilial("SN1")		,".T."},; 
				   {"N1_CBASE"		,aAtivo[nX,nx_CBASE]	,".T."},; 
				   {"N1_ITEM"		,StrZero(Val(aAtivo[nX,nx_ITEM]),4)	,".T."},; 
				   {"N1_GRUPO"   	,StrZero(Val(aAtivo[nX,nx_GRUPO]),4)	,".T."},;       
				 	{"N1_AQUISIC" 	,CTOD(aAtivo[nX,nx_AQUISIC])	,".T."},; 
				   {"N1_QUANTD" 	,1,".T."},; 
				   {"N1_DESCRIC" 	,Substr(aAtivo[nX,nx_DESCRIC],1,100),".T."},; 
				   {"N1_VLAQUIS" 	,Val(StrTran(aAtivo[nX,nx_VORIG1],',','.')) ,".T."},; //Val(aAtivo[nX,nx_VORIG1]) ,".T."},;  //Val(StrTran(aAtivo[nX,nx_VORIG1],',','.')) ,".T."},; 
				   {"N1_NSERIE" 	,"",".T."},; 				   
				   {"N1_NFISCAL" 	,"",".T."},; 
				   {"N1_CHAPA"   	,aAtivo[nX,nx_CHAPA],".T."},; 
				   {"N1_FORNEC" 	,"",".T."},; 
				   {"N1_LOJA"    	,"",".T."}} 
      
     Private lMsHelpAuto := .f. 
     Private lMsErroAuto := .f. 
           
     aAdd(aItens,{ 	{"N3_FILIAL"	,xFilial("SN3"),".T."},; 
					     	{"N3_TIPO"   	,"01",".T."},;                          
					     	{"N3_ITEM" 		,aAtivo[nX,nx_ITEM]	,".T."},; 
					     	{"N3_HISTOR" 	,Substr(aAtivo[nX,nx_DESCRIC],1,100),".T."},; 
					     	{"N3_DINDEPR" 	,CTOD(aAtivo[nX,nx_AQUISIC])	,".T."},; 
					     	{"N3_CCONTAB" 	,aAtivo[nX,nx_CCONTAB]		,".T."},; 				// DEFINIIR
					     	{"N3_CDEPREC" 	,aAtivo[nX,nx_CDEPREC]		,".T."},; 				// DEFINIIR					     	
					     	{"N3_CCDEPR" 	,"",".T."},; 
					     	{"N3_CUSTBEM" 	,"",".T."},; 
					     	{"N3_VORIG1" 	,Val(StrTran(aAtivo[nX,nx_VORIG1],',','.')) ,".T."},;  //Val(aAtivo[nX,nx_VORIG1]) ,".T."},;  //Val(StrTran(aAtivo[nX,nx_VORIG1],',','.')) ,".T."},; 
					     	{"N3_VORIG2" 	,0, ".T."},; 
					     	{"N3_VORIG3" 	,0, ".T."},; 
					     	{"N3_TXDEPR1" 	,Val(StrTran(aAtivo[nX,nx_TXDEPR1],',','.')) ,".T."},;  //Val(aAtivo[nX,nx_TXDEPR1]) ,".T."},;   //Val(StrTran(aAtivo[nX,nx_TXDEPR1],',','.')) ,".T."},;  
					     	{"N3_TXDEPR2" 	,0,".T."},; 
					     	{"N3_TXDEPR3" 	,0,".T."},; 
					     	{"N3_TXDEPR4" 	,0,".T."},; 
					     	{"N3_TXDEPR5" 	,0,".T."},; 
					     	{"N3_CCUSTO" 	,"",".T."},; 
					     	{"N3_AQUISIC" 	,CTOD(aAtivo[nX,nx_AQUISIC])	,".T."},; 
					     	{"N3_VRDACM1" 	,Val(StrTran(aAtivo[nX,nx_VRDACM1],',','.')) ,".T."} 	})  //Val(aAtivo[nX,nx_VRDACM1]) ,".T."} 	})//Val(StrTran(aAtivo[nX,nx_VRDACM1],',','.')) ,".T."} 	})
					
      
     aAdd( aParamAuto, {"MV_PAR01", 2} ) //Pergunta 01 - Mostra Lanc.Contab ? 1 = Sim ; 2 = Não 
     aAdd( aParamAuto, {"MV_PAR02", 1} ) //Pergunta 02 - Repete Chapa ? 1 = Sim ; 2 = Não 
     aAdd( aParamAuto, {"MV_PAR03", 2} ) //Pergunta 03 - Descrição estendida? 1 = Sim ; 2 = Não 
     aAdd( aParamAuto, {"MV_PAR04", 2} ) //Pergunta 04 - Copiar Valores ? 1 = Todos ; 2 = Sem Acumulados 
      
     MSExecAuto( {|X,Y,Z,W| ATFA010(X,Y,Z,W)} ,aCab ,aItens, 3,aParamAuto) 
      
     If lMsErroAuto 
          lRetorno := .F. 
          Alert("Erro no Item: " + aAtivo[nX,nx_CBASE]+" "+aAtivo[nX,nx_ITEM]) 
          MostraErro() 
     Else                                           
        //Alert("PASSOU : "+PE_000001->NFISCAL+" "+PE_000001->PLAQU) 
          lRetorno:=.T. 
     EndIf 
      

	Next nX
EndIF
MsgInfo("Final de Processamento...")

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Importa  ³ Autor ³  Eduardo Patriani     ³ Data ³ 24/04/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza tabela SN1 / SN3.                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Importa(aAtivo,nX)

Local nSaveSx8	:= GetSX8Len()          
Local cNumSN1	:= GetSXENum("SN1","N1_CBASE")

While (GetSx8Len() > nSaveSx8)
	ConfirmSX8()
End

Begin Transaction
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava cabecalho do ativo fixo			     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SN1")
RecLock("SN1",.T.)
SN1->N1_FILIAL 		:= xFilial("SN1")
SN1->N1_CBASE  		:= cNumSN1
SN1->N1_ITEM		:= "0001"
SN1->N1_AQUISIC		:= dDatabase
SN1->N1_CODPROD 	:= aAtivo[nX,3] 
SN1->N1_DESCRIC		:= Posicione("SB1",1,xFilial("SB1")+aAtivo[nX,3],"B1_DESC")
SN1->N1_QUANTD		:= 1
SN1->N1_PATRIM		:= "N"
SN1->N1_CALCPIS 	:= "1"
SN1->N1_PENHORA 	:= "0"
SN1->N1_CHAPA		:= Strzero(Val(aAtivo[nX,1]),6)
SN1->N1_NUMSER 		:= aAtivo[nX,2]          
SN1->N1_GRUPO 		:= aAtivo[nX,4]          
MsUnlock()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava itens do ativo fixo				     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SN3")
RecLock("SN3",.T.)
SN3->N3_FILIAL 	:= xFilial("SN3")
SN3->N3_CBASE  	:= cNumSN1
SN3->N3_ITEM	:= "0001"
SN3->N3_TIPO	:= "01"
SN3->N3_CCONTAB := "13211000005"
SN3->N3_CUSTBEM := "2"
SN3->N3_CCUSTO  := "2"
SN3->N3_DINDEPR	:= dDatabase
SN3->N3_AQUISIC	:= dDatabase
SN3->N3_NOVO	:= "S"
MsUnlock()
End Transaction

Return(Nil)


User Function CSATVM01(cCampo)

Local aArea 	:= GetArea()
Local lRet  	:= .T.
Local aCombos	:= {"A=Ativo","V=Vendido","E=Extraviado","D=Danificado"}
                      
DbSelectArea("SN1")
DbSetOrder(2)
IF DbSeek(xFilial("SN1") + cCampo )
	IF SN1->N1_SITUACA <> "A"
		MsgInfo("Patrimônio "+Substr(acombos[aScan( aCombos, SN1->N1_SITUACA)],3))
		lRet := .F.
	EndIF		
EndIF           

RestArea(aArea)

Return(lRet)


//
User Function Str2Array(cString, cDelim, cStr)

Local aReturn := {}
Local cAux    := cString 
Local nPos    := 0
Local nI      := 0

Default cDelim := ";"
Default cStr   := ""

While At(cDelim, cAux) > 0
	nPos := At(cDelim, cAux)
	AAdd(aReturn, SubStr(cAux, 1, nPos-1))
	cAux := SubStr(cAux, nPos+1)
End
AAdd(aReturn, cAux)

If !Empty(cStr)
	For nI := 1 To Len(aReturn)
		aReturn[nI] := StrTran(aReturn[nI], cStr, " ")
		aReturn[nI] := AllTrim(aReturn[nI])
	Next nI
EndIf

Return(aReturn)         
