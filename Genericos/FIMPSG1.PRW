#include "protheus.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±Programa                                      Jonas º Data ³  19/05/20  ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importacao - sg1      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ DOMEX                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FIMPSG1()

local nOrd_SX6  := SX6->( IndexOrd() )

private cNom_Arq := ''

If MSGYESNO('Deseja Importar Planilha com Programação Planejamento ?  ')
	
	cNom_Arq := Upper(Alltrim(cGetFile("Arquivos *.CSV|*.CSV","Selecione o arquivo para importação.",0,'C:\',.F.,GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE,.T.)))
	If !File(cNom_Arq).and. empty(cNom_Arq)
		Aviso('Atenção','Não encontrado o arquivo com a Planilha a ser Importada',{'OK'})
	Else
	    SG1Grava()	
	EndIf
	
Endif


SX6->(DbSetOrder(nOrd_SX6))

return




Static Function SG1Grava()

IF !Empty(cNom_Arq)
	nHandle	 := FT_FUSE(cNom_Arq)
	Processa( {|lEnd| LeArq() } , "Lendo Arquivo...")
	FClose(nHandle)
EndIF

return(.T.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Le e Processa a Planilha ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function LeArq()

Local cBuffer
Local aAux       := {}
Local lContinua  := .T.
Local aArray     := {}

Private aTabSC    := {}
Private lMsErroAuto:= .F.

FT_FGOTOP()
ProcRegua(FT_FLASTREC())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Leitura do arquivo texto.                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While ! FT_FEOF()
	cBuffer := FT_FREADLN()
	If at('"',cBuffer) <> 0
		MsgStop('Existe um caracter aspas (") na linha '+Alltrim(Str(Len(aTabSC)+1))+'. Favor corrigir antes de importar o arquivo. ')
		aTabSC := {}
		Exit
	EndIf
	aAux    := U_Str2Array(cBuffer,";")
	AAdd( aTabSC , aAux)
	
	IncProc()
	FT_FSKIP(1)
EndDo

If Len(aTabSC) == 0
	MsgStop("Arquivo vazio.")
	lContinua := .F.
EndIf

If Len(aTabSC) == 1
	MsgStop("Arquivo contém apenas cabeçalho.")
	lContinua := .F.
EndIf

lContinua := ValidaVetor()


If lContinua
	If Len(aTabSC) > 1
		
		aCabec := {}
		aItens := {}
		
		// Define Itens
		For nX := 2 TO Len(aTabSC)     
			aArray := {}
			
			//item 1
			If SG1->( dbSeek( xFilial("SG1") + ALLTRIM(aTabSC[nx,1])+SPACE(15-LEN(ALLTRIM(aTabSC[nx,1]))) + ALLTRIM(aTabSC[nx,3])+SPACE(15-LEN(ALLTRIM(aTabSC[nx,3]))) ) )      	
                If SG1->G1_INI<DDATABASE .and. SG1->G1_FIM>DDATABASE
				    Reclock("SG1",.F.)
                    SG1->G1_FILIAL      := 'JJ'
				    SG1->G1_QUANT 		:= Val(StrTran(aTabSC[nx,04],",","."))
				    SG1->( msUnlock() )
                else
                    RecLock("SG1",.T.)
			    	SG1->G1_FILIAL 	    := "TT"
				    SG1->G1_COD			:= ALLTRIM(aTabSC[nx,1])+SPACE(15-LEN(ALLTRIM(aTabSC[nx,1])))
				    SG1->G1_COMP 		:= ALLTRIM(aTabSC[nx,3])+SPACE(15-LEN(ALLTRIM(aTabSC[nx,3])))
				    SG1->G1_TRT 		:= ""
				    SG1->G1_QUANT 		:= Val(StrTran(aTabSC[nx,04],",","."))
				    SG1->G1_PERDA 		:= 0
				    SG1->G1_INI 		:= dDatabase
				    SG1->G1_FIM 		:= STOD("20491231")
				    SG1->G1_NIV 		:= "01"
				    SG1->G1_OBSERV 	    := ""
				    SG1->G1_FIXVAR 	    := "V"
				    SG1->G1_NIVINV 	    := "99"
				    SG1->G1_GROPC 		:= ""
				    SG1->G1_REVINI 	    := ""
				    SG1->G1_OPC 		:= ""
				    SG1->G1_REVFIM 	    := "ZZZ"
				    SG1->G1_POTENCI 	:= 0  
				    SG1->( MsUnlock() )   
                EndIf
			Else
                RecLock("SG1",.T.)
				SG1->G1_FILIAL 	    := "TT"
				SG1->G1_COD			:= ALLTRIM(aTabSC[nx,1])+SPACE(15-LEN(ALLTRIM(aTabSC[nx,1])))
				SG1->G1_COMP 		:= ALLTRIM(aTabSC[nx,3])+SPACE(15-LEN(ALLTRIM(aTabSC[nx,3])))
				SG1->G1_TRT 		:= ""
				SG1->G1_QUANT 		:= Val(StrTran(aTabSC[nx,04],",","."))
				SG1->G1_PERDA 		:= 0
				SG1->G1_INI 		:= dDatabase
				SG1->G1_FIM 		:= STOD("20491231")
				SG1->G1_NIV 		:= "01"
				SG1->G1_OBSERV 	    := ""
				SG1->G1_FIXVAR 	    := "V"
				SG1->G1_NIVINV 	    := "99"
				SG1->G1_GROPC 		:= ""
				SG1->G1_REVINI 	    := ""
				SG1->G1_OPC 		:= ""
				SG1->G1_REVFIM 	    := "ZZZ"
				SG1->G1_POTENCI 	:= 0  
				SG1->( MsUnlock() )   				
            EndIf

            //item 2
			If SG1->( dbSeek( xFilial("SG1") + ALLTRIM(aTabSC[nx,1])+SPACE(15-LEN(ALLTRIM(aTabSC[nx,1]))) + ALLTRIM(aTabSC[nx,5])+SPACE(15-LEN(ALLTRIM(aTabSC[nx,5]))) ) )      	
				If SG1->G1_INI<DDATABASE .and. SG1->G1_FIM>DDATABASE
                    Reclock("SG1",.F.)
                    SG1->G1_FILIAL      := 'JJ'
				    SG1->G1_QUANT 		:= Val(StrTran(aTabSC[nx,06],",","."))
				    SG1->( msUnlock() )
                else
                    RecLock("SG1",.T.)
				    SG1->G1_FILIAL 	    := "TT"
				    SG1->G1_COD			:= ALLTRIM(aTabSC[nx,1])+SPACE(15-LEN(ALLTRIM(aTabSC[nx,1])))
				    SG1->G1_COMP 		:= ALLTRIM(aTabSC[nx,5])+SPACE(15-LEN(ALLTRIM(aTabSC[nx,5])))
				    SG1->G1_TRT 		:= ""
				    SG1->G1_QUANT 		:= Val(StrTran(aTabSC[nx,06],",","."))
				    SG1->G1_PERDA 		:= 0
				    SG1->G1_INI 		:= dDatabase
				    SG1->G1_FIM 		:= STOD("20491231")
				    SG1->G1_NIV 		:= "01"
				    SG1->G1_OBSERV 	    := ""
				    SG1->G1_FIXVAR 	    := "V"
				    SG1->G1_NIVINV 	    := "99"
				    SG1->G1_GROPC 		:= ""
				    SG1->G1_REVINI 	    := ""
				    SG1->G1_OPC 		:= ""
				    SG1->G1_REVFIM 	    := "ZZZ"
				    SG1->G1_POTENCI 	:= 0  
				    SG1->( MsUnlock() )  
                EndIf
			Else
				RecLock("SG1",.T.)
				SG1->G1_FILIAL 	    := "TT"
				SG1->G1_COD			:= ALLTRIM(aTabSC[nx,1])+SPACE(15-LEN(ALLTRIM(aTabSC[nx,1])))
				SG1->G1_COMP 		:= ALLTRIM(aTabSC[nx,5])+SPACE(15-LEN(ALLTRIM(aTabSC[nx,5])))
				SG1->G1_TRT 		:= ""
				SG1->G1_QUANT 		:= Val(StrTran(aTabSC[nx,06],",","."))
				SG1->G1_PERDA 		:= 0
				SG1->G1_INI 		:= dDatabase
				SG1->G1_FIM 		:= STOD("20491231")
				SG1->G1_NIV 		:= "01"
				SG1->G1_OBSERV 	    := ""
				SG1->G1_FIXVAR 	    := "V"
				SG1->G1_NIVINV 	    := "99"
				SG1->G1_GROPC 		:= ""
				SG1->G1_REVINI 	    := ""
				SG1->G1_OPC 		:= ""
				SG1->G1_REVFIM 	    := "ZZZ"
				SG1->G1_POTENCI 	:= 0  
				SG1->( MsUnlock() )   
            EndIf

            //item 3
			If SG1->( dbSeek( xFilial("SG1") + ALLTRIM(aTabSC[nx,1])+SPACE(15-LEN(ALLTRIM(aTabSC[nx,1]))) + ALLTRIM(aTabSC[nx,7])+SPACE(15-LEN(ALLTRIM(aTabSC[nx,7]))) ) )      	
                If SG1->G1_INI<DDATABASE .and. SG1->G1_FIM>DDATABASE
				    Reclock("SG1",.F.)
                    SG1->G1_FILIAL      := 'JJ'
				    SG1->G1_QUANT 		:= Val(StrTran(aTabSC[nx,08],",","."))
				    SG1->( msUnlock() )
                Else
                    RecLock("SG1",.T.)
			    	SG1->G1_FILIAL      := "TT"
				    SG1->G1_COD			:= ALLTRIM(aTabSC[nx,1])+SPACE(15-LEN(ALLTRIM(aTabSC[nx,1])))
				    SG1->G1_COMP 		:= ALLTRIM(aTabSC[nx,7])+SPACE(15-LEN(ALLTRIM(aTabSC[nx,7])))
				    SG1->G1_TRT 		:= ""
				    SG1->G1_QUANT 		:= Val(StrTran(aTabSC[nx,08],",","."))
				    SG1->G1_PERDA 		:= 0
				    SG1->G1_INI 		:= dDatabase
				    SG1->G1_FIM 		:= STOD("20491231")
				    SG1->G1_NIV 		:= "01"
				    SG1->G1_OBSERV 	    := ""
				    SG1->G1_FIXVAR 	    := "V"
				    SG1->G1_NIVINV 	    := "99"
				    SG1->G1_GROPC 		:= ""
				    SG1->G1_REVINI 	    := ""
				    SG1->G1_OPC 		:= ""
				    SG1->G1_REVFIM 	    := "ZZZ"
				    SG1->G1_POTENCI 	:= 0  
				    SG1->( MsUnlock() ) 
                EndIf
			Else			
				RecLock("SG1",.T.)
				SG1->G1_FILIAL    	:= "TT"
				SG1->G1_COD			:= ALLTRIM(aTabSC[nx,1])+SPACE(15-LEN(ALLTRIM(aTabSC[nx,1])))
				SG1->G1_COMP 		:= ALLTRIM(aTabSC[nx,7])+SPACE(15-LEN(ALLTRIM(aTabSC[nx,7])))
				SG1->G1_TRT 		:= ""
				SG1->G1_QUANT 		:= Val(StrTran(aTabSC[nx,08],",","."))
				SG1->G1_PERDA 		:= 0
				SG1->G1_INI 		:= dDatabase
				SG1->G1_FIM 		:= STOD("20491231")
				SG1->G1_NIV 		:= "01"
				SG1->G1_OBSERV 	    := ""
				SG1->G1_FIXVAR 	    := "V"
				SG1->G1_NIVINV 	    := "99"
				SG1->G1_GROPC 		:= ""
				SG1->G1_REVINI 	    := ""
				SG1->G1_OPC 		:= ""
				SG1->G1_REVFIM 	    := "ZZZ"
				SG1->G1_POTENCI 	:= 0  
				SG1->( MsUnlock() )   
            EndIf

            //item 4
			If SG1->( dbSeek( xFilial("SG1") + ALLTRIM(aTabSC[nx,1])+SPACE(15-LEN(ALLTRIM(aTabSC[nx,1]))) + ALLTRIM(aTabSC[nx,9])+SPACE(15-LEN(ALLTRIM(aTabSC[nx,9]))) ) )      	
                If SG1->G1_INI<DDATABASE .and. SG1->G1_FIM>DDATABASE
				    Reclock("SG1",.F.)
                    SG1->G1_FILIAL      := 'JJ'
				    SG1->G1_QUANT 		:= Val(StrTran(aTabSC[nx,10],",","."))
				    SG1->( msUnlock() )
                else
                    RecLock("SG1",.T.)
				    SG1->G1_FILIAL   	:= "TT"
				    SG1->G1_COD			:= ALLTRIM(aTabSC[nx,1])+SPACE(15-LEN(ALLTRIM(aTabSC[nx,1])))
				    SG1->G1_COMP 		:= ALLTRIM(aTabSC[nx,9])+SPACE(15-LEN(ALLTRIM(aTabSC[nx,9])))
				    SG1->G1_TRT 		:= ""
				    SG1->G1_QUANT 		:= Val(StrTran(aTabSC[nx,10],",","."))
				    SG1->G1_PERDA 		:= 0
				    SG1->G1_INI 		:= dDatabase
				    SG1->G1_FIM 		:= STOD("20491231")
				    SG1->G1_NIV 		:= "01"
				    SG1->G1_OBSERV 	    := ""
				    SG1->G1_FIXVAR 	    := "V"
				    SG1->G1_NIVINV 	    := "99"
				    SG1->G1_GROPC 		:= ""
				    SG1->G1_REVINI 	    := ""
				    SG1->G1_OPC 		:= ""
				    SG1->G1_REVFIM 	    := "ZZZ"
				    SG1->G1_POTENCI 	:= 0  
    				SG1->( MsUnlock() )   
                EndIf                    
			Else			
				RecLock("SG1",.T.)
				SG1->G1_FILIAL   	:= "TT"
				SG1->G1_COD			:= ALLTRIM(aTabSC[nx,1])+SPACE(15-LEN(ALLTRIM(aTabSC[nx,1])))
				SG1->G1_COMP 		:= ALLTRIM(aTabSC[nx,9])+SPACE(15-LEN(ALLTRIM(aTabSC[nx,9])))
				SG1->G1_TRT 		:= ""
				SG1->G1_QUANT 		:= Val(StrTran(aTabSC[nx,10],",","."))
				SG1->G1_PERDA 		:= 0
				SG1->G1_INI 		:= dDatabase
				SG1->G1_FIM 		:= STOD("20491231")
				SG1->G1_NIV 		:= "01"
				SG1->G1_OBSERV 	    := ""
				SG1->G1_FIXVAR 	    := "V"
				SG1->G1_NIVINV 	    := "99"
				SG1->G1_GROPC 		:= ""
				SG1->G1_REVINI 	    := ""
				SG1->G1_OPC 		:= ""
				SG1->G1_REVFIM 	    := "ZZZ"
				SG1->G1_POTENCI 	:= 0  
				SG1->( MsUnlock() )   
            EndIf
			
		Next nX                 
		
		Aviso("SG1: ","Estrutura importada com sucesso.",{"OK"},1)  
		
	EndIF
Else
	MsgStop("Não foi possível importar o arquivo.")
EndIf

Return(Nil)


Static Function ValidaVetor()
Local _Retorno := .T.

SB1->( dbSetOrder(1) )

//Validacoes Planejamento e Requisicoes
For nX := 2 To Len(aTabSC)             
	SB1->( DBgotop()	 )
	
    //Verifica se o produto
	If !SB1->( dbSeek( xFilial() + ALLTRIM(aTabSC[nx,1])+SPACE(15-LEN(ALLTRIM(aTabSC[nx,1]))))   .and. alltrim(aTabSC[nx,1])<>'')
		MsgStop("Coluna A '" + alltrim(aTabSC[nx,1]) + "' informado na linha " + Alltrim(Str(nx)) + " inválido.")
		_Retorno := .F.
		Exit
	EndIf   

    //Verifica se o produto
	If !SB1->( dbSeek( xFilial() + ALLTRIM(aTabSC[nx,3])+SPACE(15-LEN(ALLTRIM(aTabSC[nx,3]))))   .and. alltrim(aTabSC[nx,3])<>'')
		MsgStop("Coluna C '" + alltrim(aTabSC[nx,3]) + "' informado na linha " + Alltrim(Str(nx)) + " inválido.")
		_Retorno := .F.
		Exit
	EndIf   

    //Verifica se o produto
	If !SB1->( dbSeek( xFilial() + ALLTRIM(aTabSC[nx,5])+SPACE(15-LEN(ALLTRIM(aTabSC[nx,5]))))   .and. alltrim(aTabSC[nx,5])<>'')
		MsgStop("Coluna E '" + alltrim(aTabSC[nx,5]) + "' informado na linha " + Alltrim(Str(nx)) + " inválido.")
		_Retorno := .F.
		Exit
	EndIf   
	    


    //Verifica se o produto
	If !SB1->( dbSeek( xFilial() + ALLTRIM(aTabSC[nx,7])+SPACE(15-LEN(ALLTRIM(aTabSC[nx,7]))))   .and. alltrim(aTabSC[nx,7])<>'')
		MsgStop("Coluna G '" + alltrim(aTabSC[nx,7]) + "' informado na linha " + Alltrim(Str(nx)) + " inválido.")
		_Retorno := .F.
		Exit
	EndIf   

    //Verifica se o produto
	If !SB1->( dbSeek( xFilial() + ALLTRIM(aTabSC[nx,9])+SPACE(15-LEN(ALLTRIM(aTabSC[nx,9]))))   .and. alltrim(aTabSC[nx,9])<>'')
		MsgStop("Coluna I '" + alltrim(aTabSC[nx,9]) + "' informado na linha " + Alltrim(Str(nx)) + " inválido.")
		_Retorno := .F.
		Exit
	EndIf   
	
	//Verifica se é diferente de zero
	If  Val(StrTran(aTabSC[nx,04],",","."))<=0   .OR.  Val(StrTran(aTabSC[nx,06],",","."))<=0   .OR.  Val(StrTran(aTabSC[nx,08],",","."))<=0    .OR.  Val(StrTran(aTabSC[nx,10],",","."))<=0    
		MsgStop("A Linha " + Alltrim(Str(nX)) + " precisa ter QUANTIDADE maior que ZERO. Favor verificar.")
		_Retorno := .F.
		Exit
	EndIf      

Next nX 

Return _Retorno
