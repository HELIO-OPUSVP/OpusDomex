
#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³DCOMA001  ºAutor  ³Marco Aurelio       º Data ³  10-08-16   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³  Importar tabela de preços de Compras                      º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*----------------------------------------*
User Function DCOMA001()
	*----------------------------------------*
	local oDlg
	local bCancel 	:= {|| oDlg:End()}
	local bOK    	:= {|| If(CSB03Grava(), oDlg:End(),)}
	local oRadio
	Private cCodFOR	:= AIA->AIA_CODFOR
	Private cLojFOR	:= AIA->AIA_LOJFOR
	Private cTabela := AIA->AIA_CODTAB
	Private	cItem   := "0000"

	private cNom_Arq := ''
	private nRadio   := 1

	If MsgYesNo('Deseja Atualizar a Tabela ' + cTabela + ' do Fornecedor '+cCodFOR + '-' +cLojFOR+' ?')  // Tratado

		Begin sequence

			cNom_Arq :=Upper(Alltrim(cGetFile("Arquivos *.CSV|*.CSV","Selecione o arquivo para importação.")))

			If !File(cNom_Arq).and. empty(cNom_Arq)
				Aviso('Atenção','Não encontrado o arquivo com a tabela do fornecedor',{'OK'})
				break
			EndIf

			Define MsDialog oDlg title 'Importando tabelas de Preço' from 0,0 to 300,400 pixel

			@ 013,002 to 78,250 label 'Tabela de Preco' of oDlg pixel
			@ 030,010 say '  Tabela a ser Importada: ' size 65,10 of oDlg pixel
			@ 080,010 radio oRadio var nRadio Items ;
			    'Tabela de preco em Real   (R$)'  ,;
				'Tabela de preco em Dolar  (US$)' ,;
				'Tabela de preco em Franco (CHF)' ,;
				'Tabela de preco em Peso   (CLP)' ,;
				'Tabela de preco em Euro   (�)'   3D size 120,10 of oDlg pixel

				/*
				 2   DOLAR
                 3   FRANCO
                 4   PESO CHILENO
                 5   EURO S�mbolo do Euro (�) - Significados
				*/

			Activate MsDialog oDlg Center On Init EnchoiceBar(oDlg,bok,bcancel)

		End Sequence
		Msgalert ('Processado '+  cItem +' Itens')
	endif

return

	*-------------------------------------------*
Static Function CSB03Grava()
	*-------------------------------------------*

	local lRetorno := .t.

	if !CSB01Exist(cTabela)
		lRetorno := .f.
	endIf

	//Limpa tabela de preco para nova importação
	//Processa({|| CSB03LimpaTab(cTabela) } )

	IF !Empty(cNom_Arq)
		nHandle	 := FT_FUSE(cNom_Arq)
		Processa( {|lEnd| LeArq(cTabela) } , "Lendo Arquivo...")
		FClose(nHandle)
	EndIF

Return(.T.)


	*-------------------------------------------*
Static Function CSB01Exist(cTabela)
	*-------------------------------------------*
	local lRetorno := .t.

	AIA->(DbsetOrder(1))

	If AIA->(!DbSeek(xFilial('AIA') + cCodFOR+cLojFOR+cTabela))
		Aviso('Atenção','Codigo de tabela de preços ' + cTabela + 'não encontrado no cadastro de tabelas de preços!',{'Ok'})
		lRetorno := .f.
	EndIf

return(lRetorno)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³CSB03LimpaTab  ºAutor  ³Eduardo Patriani    º Data ³  10/04/08   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³ Limpa Tabela de Preco                                      	    º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ Control Service                                           	    º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CSB03LimpaTab(cTabela)


	DbSelectArea("AIB")
	DbSetOrder(1)
	ProcRegua( Reccount() )
	DbSeek(xFilial("AIB") + cCodFOR+cLojFOR+cTabela , .T. )
	Do While !Eof() .And. ( AIB->(AIB_FILIAL+AIB_CODFOR+AIB_LOJFOR+AIB_CODTAB) == xFilial("AIB")+cCodFOR+cLojFOR+cTabela     )
		IncProc()
		RecLock("AIB",.F.)
		DbDelete()
		MsUnlock()
		DbSelectArea("AIB")
		Dbskip()
	Enddo

Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ LeArq    ³ Autor ³  Eduardo Patriani     ³ Data ³ 24/04/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Importa dados.                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function LeArq(cTabela)

	Local nX :=0
	Local cBuffer
	Local aAux      := {}
	Local lContinua := .T.
	Private aTabP 	 := {}

	FT_FGOTOP()
	ProcRegua(FT_FLASTREC())

	While ! FT_FEOF()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Leitura do arquivo texto.                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cBuffer := FT_FREADLN()
		aAux    := U_Str2Array(cBuffer,";")
		AAdd( aTabP , aAux)

		IncProc()
		FT_FSKIP(1)
	EndDo

	lContinua := ValidaVetor()


	IF Len(aTabP) > 0 .and. lContinua


		//Limpa tabela de preco para nova importação
		Processa({|| CSB03LimpaTab(cTabela) } )

		cItem := "0000"
		For nX := 2 To Len(aTabP)	// Comeca com 2 para ignorar primeira linha com cabecalho.
			IF SUBSTR(aTabP[nX,1],1,6)==cCodFOR .AND.  SUBSTR(aTabP[nX,1],8,2)== cLojFOR//000000/00

				DbSelectArea("AIB")
				DbSetOrder(1)
				RecLock("AIB",.T.)

				cItem := Soma1(cItem,Len(AIB->AIB_ITEM))
				AIB->AIB_FILIAL := xFilial("AIB")
				AIB->AIB_CODFOR := cCodFOR
				AIB->AIB_LOJFOR := cLojFOR
				AIB->AIB_CODTAB := cTabela
				AIB->AIB_ITEM   := cItem //strzero(cItem,4) //MAX_DA1(cTabela)
				AIB->AIB_CODPRO := aTabP[nX,2]
				AIB->AIB_PRCCOM := val(StrTran(aTabP[nX,6],",",".")) //val(aTabP[nX,6])    //	StrTran(_cPAR02, ",", ".", 1, 1)
				AIB->AIB_QTDLOT := 999999.99
				AIB->AIB_INDLOT := "000000000999999.99"
				AIB->AIB_MOEDA  := nRadio //1
				AIB->AIB_DATVIG := dDataBase
				AIB->AIB_FRETE  := 0

				Msunlock()
			ENDIF

		Next nX


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza Amarracao  Produto x Fornecedor³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		For nX := 2 To Len(aTabP)	// Comeca com 2 para ignorar primeira linha com cabecalho.
			IF SUBSTR(aTabP[nX,1],1,6)==cCodFOR .AND.  SUBSTR(aTabP[nX,1],8,2)== cLojFOR//000000/00

				DbSelectArea("SA5")
				SA5->(dbSetOrder(1))
				If SA5->(!dbSeek(xFilial("SA5") + cCodFOR + cLojFOR + aTabP[nX,2]))

					RecLock("SA5",.T.)

					SA5->A5_FILIAL		:= xFilial("SA5")
					SA5->A5_FORNECE	:=	cCodFOR
					SA5->A5_LOJA		:=	cLojFOR
					SA5->A5_FABR		:=	cCodFOR
					SA5->A5_NOMEFOR	:= Alltrim(Posicione("SA2",1,xFilial("SA2") + cCodFOR + cLojFOR,"A2_NOME"))
					SA5->A5_PRODUTO	:=	aTabP[nX,2]
					SA5->A5_NOMPROD	:= Posicione("SB1",1,xFilial("SB1")+aTabP[nX,2],"B1_DESC")
					SA5->A5_DESCPRF	:=	Posicione("SB1",1,xFilial("SB1")+aTabP[nX,2],"B1_DESC")
					SA5->A5_CODTAB		:=	cTabela

					Msunlock()
				else
					//	     	if  SA5->A5_CODTAB <> cTabela
					RecLock("SA5",.F.)
					//					SA5->A5_FILIAL		:= xFilial("SA5")
					SA5->A5_FORNECE	:=	cCodFOR
					SA5->A5_LOJA		:=	cLojFOR
					SA5->A5_FABR		:=	cCodFOR
					SA5->A5_NOMEFOR	:= Alltrim(Posicione("SA2",1,xFilial("SA2") + cCodFOR + cLojFOR,"A2_NOME"))
					SA5->A5_PRODUTO	:=	aTabP[nX,2]
					SA5->A5_NOMPROD	:= Posicione("SB1",1,xFilial("SB1")+aTabP[nX,2],"B1_DESC")
					SA5->A5_DESCPRF	:=	Posicione("SB1",1,xFilial("SB1")+aTabP[nX,2],"B1_DESC")
					SA5->A5_CODTAB		:=	cTabela
					Msunlock()
					//	   	endif
				Endif
			ENDIF
		Next nX

	EndIF

Return(Nil)




Static Function ValidaVetor()
	local  nX:=0
	Local _Retorno := .T.

	SB1->( dbSetOrder(1) )

	For nX := 2 To Len(aTabP)

		IF SUBSTR(aTabP[nX,1],1,6)==cCodFOR .AND.  SUBSTR(aTabP[nX,1],8,2)== cLojFOR//000000/00

			If ! (SB1->( dbSeek( xFilial() + aTabP[nx,2] ) ))
				MsgStop("Produto informado da linha " + Alltrim(Str(nX)) + " não localizado no Cadastro de Produtos. " + Chr(13) + "A importação não será realizada. " )
				_Retorno := .F.
			endif
		ENDIF

	Next nX

Return _Retorno
