#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INClUDE "fileio.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

#DEFINE ENTER CHAR(13) + CHAR(10)
#DEFINE TABARQ  Chr(09)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ARTXTHUA  ºAutor  ³Jackson             º Data ³  20/08/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ARTXTHUA()
local nHandle 		:= 0
local cLocalArq	:= ""
Local cPerg			:= Padr("TETHUA",10)
Local cNumNota		:= ""
Local cSerNota		:= ""
Local cQuery  		:= ""
Local cArquivo		:= ""
Local aTotN1hua	:= {}
Local x, y
Local aPrimNiv    := {}
Local aProdutos   := {}
Local lTudoOk 	  := .F.
//Execução da pergunta
If !Pergunte(cPerg,.T.)
	Return
EndIf

cNumNota := MV_PAR01
cSerNota	:= MV_PAR02

SF2->( dbSetOrder(1) )
If !SF2->( dbSeek( xFilial() + cNumNota + cSerNota ) )
	MsgStop("Nota Fiscal não encontrada")
	Return
EndIf

cQuery := "SELECT XD1_ZYNOTA,XD1_ZYSERI,XD1_XXPECA,XD1_ETQHUA "
cQuery += ENTER  + " FROM " + RetSqlName("XD1")  +" XD1 "
cQuery += ENTER  + " WHERE XD1.D_E_L_E_T_ ='' AND XD1.XD1_FILIAL = '" +xFilial("XD1")+ "'  "
cQuery += ENTER  + " AND XD1.XD1_ZYNOTA = '" + cNumNota + "' AND XD1.XD1_ZYSERI = '" + cSerNota + "' "

If Select("TMPXD1") > 0
	TMPXD1->(DbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS "TMPXD1"

aPrimNiv := {}
aEtqsN3 := {}
If TMPXD1->(!EOF())
	While TMPXD1->(!EOF())
		AaDd(aEtqsN3,UPPER(Alltrim(TMPXD1->XD1_ETQHUA)))
		
		aPrimNiv := RetEtqHua({{Alltrim(TMPXD1->XD1_XXPECA)}})
		
		For x := 1 to Len(aPrimNiv)
			AADD(aTotN1hua,{Alltrim(TMPXD1->XD1_XXPECA),ALLTRIM(aPrimNiv[x][1]),Alltrim(TMPXD1->XD1_ETQHUA),ALLTRIM(aPrimNiv[x][2])})
		Next x
		
		TMPXD1->(DbSkip())
	EndDo
	// Fecha arquivo
	TMPXD1->(DbCloseArea())
Else
	//Se não há dados da nota fiscal informada, avisa e exclui o arquivo gerado.
	MsgStop("Não há embalagens para a nota fiscal e série informada (XDI_ZYNOTA).","Erro nos dados da nota fiscal")
	Return
EndIf


// Validando se não existe etiqueta Rosenberger interna duplicada
For x := 1 to Len(aTotN1hua)
	For y := 1 to Len(aTotN1hua)
	   If x <> y
	      If aTotN1hua[x,1] == aTotN1hua[y,2]
	         MsgStop("Etiqueta Rosenberger intena duplicada")
	         Return
	      EndIf
	   EndIf
	Next y
Next x


// Validando se o produto da embalagem externa é igual ao produto a embalagem interna

XD1->( dbSetOrder(1) )
For x := 1 to Len(aTotN1hua)
	XD1->( dbSeek( xFilial() + aTotN1hua[x,1]) )
	cProdN3 := XD1->XD1_COD
	XD1->( dbSeek( xFilial() + aTotN1hua[x,2]) )
	cProdN1 := XD1->XD1_COD
	If cProdN3 <> cProdN1
	   MsgStop("Produto "+Alltrim(cProdN3)+" da embalagem externa "+Alltrim(aTotN1hua[x,1])+" Rosenberger diferente do produto " + cProdN1 + " da embalagem interna " + aTotN1hua[x,2] )
	   Return 
	EndIf
Next x

// Validando as quantidades de produtos
/*
aProdutos := {}
XD1->( dbSetOrder(1) )
For x := 1 to Len(aTotN1hua)
	XD1->( dbSeek( xFilial() + aTotN1hua[x,1]) )
	nQtd := XD1->XD1_COD
	XD1->( dbSeek( xFilial() + aTotN1hua[x,2]) )
	cProdN1 := XD1->XD1_COD
	If cProdN3 <> cProdN1
	   MsgStop("Produto "+Alltrim(cProdN3)+" da embalagem externa "+Alltrim(aTotN1hua[x,1])+" Rosenberger diferente do produto " + cProdN1 + " da embalagem interna " + aTotN1hua[x,2] )
	   Return 
	EndIf
Next x
*/
// Validação da quantidade dos produtos com a NF


// Validar se as etiquestas Huawei não estão duplicadas




//Seleciona diretorío para criação do arquivo
cLocalArq := Alltrim(SelDirettorio())
cArqGerado := ""
For nT:=1 To Len(aEtqsN3)
	
	cArquivo := cLocalArq + "arquivohuaweinf"+cNumNota+"serie"+cSerNota+"_"+UPPER(ALLTRIM(aEtqsN3[nT]))+".txt"
	cArqGerado += ENTER + cArquivo 
	//Cria o arquivo para Gravação
	nHandle := FCREATE(cArquivo)
	//nHandle := fopen(cLocalArq + "\arquivohuawei.txt" , FO_READWRITE + FO_SHARED )
	If nHandle == -1
		MsgStop("Erro ao criar arquivo - ferror " + Str(Ferror()))
		lTudoOk := .F.
	Else
		//FSeek(nHandle, 0, FS_END)         // Posiciona no fim do arquivo		
		For nP:=1 To Len(aTotN1hua)
			//FWrite(nHandle, ALLTRIM(TMPXD1->XD1_XXPECA)+TABARQ+aTotN1hua[nP][1]+ENTER) // Insere texto no arquivo
			if ALLTRIM(aEtqsN3[nT]) == ALLTRIM(aTotN1hua[nP][3])
				FWrite(nHandle, ALLTRIM(aTotN1hua[nP][3])+TABARQ+Alltrim(aTotN1hua[nP][4])+ENTER) // Insere texto no arquivo
			EndIf
		Next nP
		
		// Fecha arquivo
		fclose(nHandle)
		lTudoOk := .T.
		//Se não há dados da nota fiscal informada, avisa e exclui o arquivo gerado.
		//		fErase(cArquivo)
		//		MsgStop("Não há dados para a nota fiscal e série informada.","Erro nos dados da nota fiscal")
		
	Endif
Next nT

If lTudoOk
	MsgAlert('Processo concluído com sucesso, ' + STRZERO(Len(aEtqsN3),2) + ' arquivos gerados:' + cArqGerado)
EndIf

return


/*
Funcção para selecionar um diretório existente
*/
Static Function SelDirettorio()
Local cRET	:=	cGetFile(,"Selecione o diretorio",,"C:\",.T.,GETF_LOCALFLOPPY+GETF_LOCALHARD+128,.F.)
//Local cRET	:=	cGetFile(,"Selecione o diretorio",,"",.T.,GETF_LOCALFLOPPY+GETF_LOCALHARD+128)

Return(cRET)

Static Function RetEtqHua(aEtqn3hua)

Local aTemp   := {}
Local x       := 0
Local y       := 0
Local nTotDia := 0
Default aEtqn3hua := {}

XD1->( dbSetOrder(1) )
XD2->( dbSetOrder(1) )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria array para explosão das emmbalagens                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For x := 1 to Len(aEtqn3hua)
	cEtq  := aEtqn3hua[x,1]
	If XD1->( dbSeek( xFilial() + cEtq ) )
		lSeek := (XD2->( dbSeek(xFilial() + cEtq ) ) .and. XD1->XD1_NIVEMB <> '1')
		AADD(aTemp,{aEtqn3hua[x,1],If(lSeek,'1','2')})
	EndIf
Next x

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Explode o conteúdo das embalagens que serão faturadas nesse pedido       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For x := 1 to 10000 //Len(aTemp)
	
	If x > len(aTemp)
		exit
	Endif
	
	If aTemp[x,2] == '1'
		cEtq := ALLTRIM(aTemp[x,1])
		If XD1->( dbSeek( xFilial() + cEtq ) )
			If XD2->( dbSeek(xFilial() + cEtq ) ) .and. XD1->XD1_NIVEMB <> '1'
				While !XD2->( EOF() ) .and. AllTrim(XD2->XD2_XXPECA) == cEtq
					AADD(aTemp,{XD2->XD2_PCFILH,'0'})
					XD2->( dbSkip() )
				End
			Else
				aTemp[x,2] := '2'
			EndIf
		EndIf
	EndIf
	
	If aTemp[x,2] == '0'
		cEtq := ALLTRIM(aTemp[x,1])
		If XD1->( dbSeek( xFilial() + cEtq ) )
			If XD2->( dbSeek(xFilial() + cEtq ) ) .and. XD1->XD1_NIVEMB <> '1'
				aTemp[x,2] := '1'
				While !XD2->( EOF() ) .and. AllTrim(XD2->XD2_XXPECA) == cEtq
					AADD(aTemp,{XD2->XD2_PCFILH,'0'})
					XD2->( dbSkip() )
				End
			Else
				aTemp[x,2] := '2'
			EndIf
		EndIf
	EndIf
Next x

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Pega Numero das Etiquetas Huawei
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAreaXD1 := XD1->( GetArea() )
XD1->( dbSetOrder(1) )
aVetEtqHua := {}
For x := 1 to Len(aTemp)
	If aTemp[x,2] == '2'
		cEtq := aTemp[x,1]
		If XD1->( dbSeek( xFilial() + cEtq ) )
			//nTemp := aScan(aVetEtqHua,{|aVet| aVet[1] == XD1->XD1_COD/*XD1->XD1_ETQHUA*/ })
			//If Empty(nTemp)
			AADD(aVetEtqHua,{XD1->XD1_XXPECA,XD1->XD1_ETQHUA})
			//Else
			//	aVetEtqHua[nTemp,2] += XD1->XD1_QTDATU
			//EndIf
		EndIf
	EndIf
Next x
RestArea(aAreaXD1)

//aSort(aVetEtqHua,,,{|X,Y| X[1] > Y[1] })

Return ( aVetEtqHua )

