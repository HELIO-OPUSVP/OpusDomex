#include "rwmake.ch"
#include "totvs.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPPRVEN  ºAutor  ³Helio Ferreira      º Data ³  21/12/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importacao de previsao de vendas por planilha              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function IMPPRVEN()

Private lOK := .F.

If MsgYesNo("Deseja importar previsões de vendas no formato .csv?")
	
	cNom_Arq := Upper(Alltrim(cGetFile("Arquivos *.CSV|*.CSV","Selecione o arquivo para importação.",0,'C:\',.F.,GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE,.T.)))
	
	If !File(cNom_Arq).and. empty(cNom_Arq)
		Aviso('Atenção','Não encontrado o arquivo com a Planilha a ser Importada',{'OK'})
	Else
		lOk := .T.
	EndIf
Else
	Msgalert("Imprtação cancelada.")
EndIf

If lOk
	If !Empty(cNom_Arq)
		nHandle	 := FT_FUSE(cNom_Arq)
		Processa( {|lEnd| LeArq() } , "Lendo Arquivo...")
		FClose(nHandle)
	EndIF
EndIf

Return


Static Function LeArq()

Local cBuffer
Local cProduto
Local cNumSerie
Local cPlaqueta
Local cGrupo
Local aItensPV 	:= {}
Local aAux      := {}
Local cDataLim

Private lMsErroAuto:= .F.

FT_FGOTOP()

ProcRegua(FT_FLASTREC())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Leitura do arquivo texto.                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While ! FT_FEOF()
	cBuffer := FT_FREADLN()
	aAux    := U_Str2Array(cBuffer,";")
	AAdd( aItensPV , aAux)
	
	IncProc()
	FT_FSKIP(1)
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Array para ExecAuto                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aItensPV) == 0
	MsgStop("Arquivo vazio.")
EndIf

If Len(aItensPV) == 4
	MsgStop("Arquivo contém apenas cabeçalho.")
EndIf
'
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Validações do arquivo                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lOk := .T.
SB1->( dbSetOrder(1) )
SA1->( dbSetOrder(1) )
SC4->( dbSetOrder(5) )

If Date() >= StoD("20170715")
   If Day(Date()) <= 10
      cDataLim := LastDay(Date())+1
   Else
      cDataLim := LastDay(LastDay(Date())+1)+1
   EndIf
Else
   cDataLim := Date() + 20
EndIf

//If M->C4_DATA < cDataLim  //Date() + 20
//   MsgStop("A data limite para a inclusão de Previsão de Vendas hoje dia " + DtoC(Date()) + " é " + DtoC(cDataLim) +".")


For nX := 5 to Len(aItensPV)
	If aItensPV[nX,1] <> 'Codigo'
		
		If !SB1->( dbSeek( xFilial() + Alltrim(aItensPV[nX,2]) + Space(15-Len(Alltrim(aItensPV[nX,2]))) ) )
			MsgStop("Código de produto '"+Alltrim(aItensPV[nX,2])+"' inválido na linha " + Alltrim(Str(nX))+".")
			lOk := .F.
		EndIf
		
		If SC4->( dbSeek( xFilial() + aItensPV[nX,1] ) ) .and. !Empty(aItensPV[nX,1]) // Se achou, é alteração
			If SC4->C4_DATA <> CtoD(aItensPV[nX,3])       // Data
				MsgStop("Não é permitido alterar data da Previsão de Vendas código '"+aItensPV[nX,1]+"' pela importação de Planilhas, linha " + Alltrim(Str(nX)) + " de '"+DtoC(SC4->C4_DATA)+"' para '"+DtoC(CtoD(aItensPV[nX,3]))+"'.")
				lOk := .F.
			EndIf
		Else
			If aItensPV[nX,4] <> aItensPV[nX,5]
				MsgStop("Quantidade atual diferente da quantidade inicial na linha " + Alltrim(Str(nX)) + ".")
				lOk := .F.
			EndIf
		EndIf
		
		If !SA1->( dbSeek( xFilial( ) + StrZero(Val(aItensPV[nX,6]),6) + StrZero(Val(aItensPV[nX,7]),2) ) )
			MsgStop("Código de Cliente + Loja '"+StrZero(Val(aItensPV[nX,6]),6) + "/" + StrZero(Val(aItensPV[nX,7]),2)+"' inválidos na linha " + Alltrim(Str(nX)) + ".")
			lOk := .F.
		EndIf
		
		If CtoD(aItensPV[nX,3]) < cDataLim // (Date() + 20)
			//MsgStop("É permitido incluir/alterar Previsão de Vendas no período mínimo de 20 dias. Data '"+DtoC(CtoD(aItensPV[nX,3]))+"' com perído de '"+Alltrim(Str(CtoD(aItensPV[nX,3])-Date()))+"' dias na linha " + Alltrim(Str(nX)) + ".")
			MsgStop("A data limite para a inclusão de Previsão de Vendas hoje dia " + DtoC(Date()) + " é " + DtoC(cDataLim) +"." + Chr(13) + "Data "+DtoC(CtoD(aItensPV[nX,3]))+" na linha " + Alltrim(Str(nX)) + ".")
			lOk := .F.
			Exit
		EndIf
		
		If aItensPV[nX,10] <> 'W' .and. aItensPV[nX,10] <> 'B' .and. aItensPV[nX,10] <> 'I'  // B=BEST, I=IN, W=WON
			MsgStop("Prioridade da Previsão de Vendas na colula 'J' diferente W/B/I (WON/BEST/IN) na linha " + Alltrim(Str(nX)) + ".")
			lOk := .F.
			Exit
		EndIf
	EndIf
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processando o arquivo                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lOk
	For nX := 5 to Len(aItensPV)
		SA1->( dbSeek( xFilial() + StrZero(Val(aItensPV[nX,6]),6) + StrZero(Val(aItensPV[nX,7]),2) ) )
		If Empty(aItensPV[nX,1])
			Reclock("SC4",.T.)
			SC4->C4_XXCOD   := U_NEXTPRE()
			SC4->C4_XXDTEMI := Date()
		Else
			If SC4->( dbSeek( xFilial() + aItensPV[nX,1] ) ) // Se achou, é alteração
				Reclock("SC4",.F.)
			Else
				Reclock("SC4",.T.)
				SC4->C4_XXCOD   := U_NEXTPRE()
				SC4->C4_XXDTEMI := Date()
			EndIf
		EndIf
		
		SC4->C4_FILIAL  := xFilial("SC4")
		SC4->C4_PRODUTO := aItensPV[nX,2]
		SC4->C4_LOCAL   := '13'
		SC4->C4_QUANT   := Val(aItensPV[nX,4])
		SC4->C4_XXQTDOR := Val(aItensPV[nX,5])
		SC4->C4_DATA    := CtoD(aItensPV[nX,3])
		
		If ValType(aItensPV[nX,9]) <> 'U'
			SC4->C4_OBS  := aItensPV[nX,9]
		EndIf
		
		SC4->C4_XXCLIEN  := StrZero(Val(aItensPV[nX,6]),6)
		SC4->C4_XXLOJA   := StrZero(Val(aItensPV[nX,7]),2)
		SC4->C4_XXNOMCL  := SA1->A1_NOME
		SC4->C4_XXCNPJ   := Subs(SA1->A1_CGC,1,8)
		SC4->C4_XXPRI    := aItensPV[nX,10] //"W"
		SC4->( msUnlock() )
	Next nx
EndIf

Return(Nil)
