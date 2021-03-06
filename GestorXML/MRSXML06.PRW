#INCLUDE "topconn.ch"
#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#Include "COLORS.CH"
#Include "FONT.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MRSXML06  �Autor  �Microsiga           � Data �  11/05/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � TES Inteligente - DOMEX - ENTRADA                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������

(cTab1)->(&(cAls1+"_FILIAL"))

*/

User Function MRSXML06()
        
Private cStrCad   := AllTrim(GetMV("MX_MRALS04"))
Private cTitCad   := "TES Inteligente - GestorXML"
Private cCadastro := cTitCad+" ["+cStrCad+"]"      

// Variaveis usadas no Arotina do Menu  para que possa usar Static Function)
Private bLegend :=  {|| TESELeg() } 
Private bImport :=  {|| TESIMP() } 

Private aRotina   := MenuDef()
Private INCLUI 	:= .F.
Private ALTERA 	:= .F.
Private cTab4   	:= AllTrim(GetMV("MX_MRALS04"))
Private cAls4   	:= IIf(SubStr(cTab4,1,1)=="S",SubStr(cTab4,2,2),cTab4)

Private aCores   	:= { 	{ cAls4+"_MSBLQL == '1' " , 'BR_VERMELHO'    },;    // 1 - Bloqueado    
							{ cAls4+"_MSBLQL == '2' " , 'BR_VERDE' 		 }}	    // 2 - Ativo
Private aFixe     := {}

//��������������������������������������������������������������Ŀ
//� Chama rotina browse com os menus                             �
//����������������������������������������������������������������
DbSelectArea(cStrCad)
DbSetOrder(1)
mBrowse(6,1,22,75,cStrCad,aFixe,,,,,aCores,,,,,)

Return

/*/
���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MenuDef   � Autor � Felipe Aurelio de Melo� Data �02/04/2012���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Utilizacao de menu Funcional                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MenuDef()

Private aRotina := {;
	{ OemToAnsi("Pesquisar" 		),"AxPesqui"   		, 0 , 1},;  //   
	{ OemToAnsi("Visualizar" 		),"Axvisual"		, 0 , 2},;  //   
	{ OemToAnsi("Incluir"			),"Axinclui"		, 0 , 3},;  //   
	{ OemToAnsi("Altera"			),"Axaltera"   		, 0 , 4},;  //   4                      
	{ OemToAnsi("Exclui"			),"AxDeleta"   		, 0 , 5},;  //   
	{ OemToAnsi("Legenda" 			),"Eval(bLegend)" 	, 0 , 7},;  //  10
	{ OemToAnsi("Importa TES"	 	),"Eval(bImport)" 	, 0 , 3}}  //   3

Return(aRotina)



Static Function TESELeg

Local cCadLeg	:= cTitCad 	// "TES Inteligente - GestorXML"
Local aLegenda	:= {}
	
	aAdd(aLegenda,{'BR_VERMELHO' ,'Bloqueado' 	        })
	aAdd(aLegenda,{'BR_VERDE'    ,'Ativo'   	        })
	
	BrwLegenda(cCadLeg,"Legenda",aLegenda)

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TESIMP    �Autor  �Microsiga           � Data �  07/20/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �   Importa Planilha de TES INTELIGENTE                      ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
Formato da Planilha .CSV que deve ser importada
   01         02      03      04      05
   A          B       C       D       E
OPERACAO  FORNECEDOR LOJA   PRODUTO  TES

*/

Static Function TESIMP()

Local lRet        := .T.
Local cArquivo  	:= ""
Local cCadastro	:= OemToAnsi("Importa��o de Planilha de TES INTELIGENTE - GestorXML")
Local nHandle   	:= 0
Local nOpca			:= 0
Local aButtons		:= {}
Local aSays			:= {}

Aadd(aSays,OemToAnsi( "Esta rotina realiza a importa��o dos registros de TES INTELIGENTE - GetorXML. [.CSV]" ) )
Aadd(aButtons, { 1,.T.,{|| nOpca := 1, FechaBatch()}} )
Aadd(aButtons, { 2,.T.,{|| nOpca := 0, FechaBatch()}} )

FormBatch( cCadastro , aSays , aButtons )
	
IF nOpca == 0
	Return(.T.)
EndIF

cArquivo := Upper(Alltrim(cGetFile("Arquivos *.CSV|*.CSV","Selecione o arquivo para importa��o.")))

IF !Empty(cArquivo)
	nHandle	 := FT_FUSE(cArquivo)
	Processa( {|lEnd| LeArq() } , "Lendo Arquivo...")
	FClose(nHandle)
EndIF

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � LeArq    � Autor �  Eduardo Patriani     � Data � 24/04/08 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Importa dados.                                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function LeArq()

Local cBuffer
Local cProduto
Local cNumSerie                   
Local cPlaqueta                   
Local cGrupo
Local cTab4   := AllTrim(GetMV("MX_MRALS04"))
Local cAls4   := IIf(SubStr(cTab4,1,1)=="S",SubStr(cTab4,2,2),cTab4)

// Posic�o dos Itens
Private nx_OPER		:= 01   		// OPERACAO
Private nx_FORNEC	:= 02			// FORNECEDOR
Private nx_LOJA		:= 03			// LOJA
Private nx_CODPRO	:= 04			// PRODUTO
Private nx_TES1		:= 05       // TES 1

Private aImport 	:= {}
Private aAux      	:= {}

FT_FGOTOP()
ProcRegua(FT_FLASTREC())

While ! FT_FEOF()
	
	//����������������������������������������������������������������Ŀ
	//� Leitura do arquivo texto.                                      �
	//������������������������������������������������������������������
	cBuffer := FT_FREADLN()
	aAux    := Str2Array(cBuffer,";")
	AAdd( aImport , aAux)
		
	IncProc()
	FT_FSKIP(1)	
EndDo          

// Valida planilha
lContinua :=  ValidaVetor()

IF lContinua .and. Len(aImport) > 0 

	// Comeca nX com 2 para ignorar Cabecalho
	For nX := 2 To Len(aImport)
		DbSelectArea(cTab4)

		(cTab4)->( dbSetOrder(1) )
		If !(cTab4)->( dbSeek(xfilial(cTab4)+aImport[nX,nx_CODPRO]+aImport[nX,nx_FORNEC]+aImport[nX,nx_LOJA]+aImport[nX,nx_OPER] ) )

			RecLock(cTab4,.T.)
				(cTab4)->(&(cAls4+"_FILIAL")) 		:= xFilial(cTab4)
				(cTab4)->(&(cAls4+"_CODPRO"))		:= Alltrim(aImport[nX,nx_CODPRO])
				(cTab4)->(&(cAls4+"_FORNEC"))  		:= PadL(Alltrim(aImport[nX,nx_FORNEC]),6,"0")
				(cTab4)->(&(cAls4+"_LOJAFO"))		:= PadL(Alltrim(aImport[nX,nx_LOJA]),2,"0")
				(cTab4)->(&(cAls4+"_TIPO"))   		:= PadL(aImport[nX,nx_OPER],2,"0")
				(cTab4)->(&(cAls4+"_TES1"))  		:= iif(!empty(Alltrim(aImport[nX,nx_TES1])),aImport[nX,nx_TES1],"999")     // aImport[nX,nx_TES1]
				(cTab4)->(&(cAls4+"_VALID1"))  		:= "2"
				(cTab4)->(&(cAls4+"_PV1"))			:= ""
				(cTab4)->(&(cAls4+"_IT1"))		  	:= ""
				(cTab4)->(&(cAls4+"_ID1"))		  	:= ""
				(cTab4)->(&(cAls4+"_NOME1"))		:= ""
				(cTab4)->(&(cAls4+"_DT1"))		 	:= ctod("  /  /  ")  
				(cTab4)->(&(cAls4+"_MSBLQL"))  		:= "2"
			MsUnlock()      
		endif

	Next nX
	
EndIF
MsgInfo("Final de Processamento...")

Return(Nil)



Static Function Str2Array(cString, cDelim, cStr)

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
                


Static Function ValidaVetor
Local lRet := .T.

SA2->(dbSetOrder(1))
SF4->(dbSetOrder(1))
  
	// Verifica se o Fornecedor Existe
	For nX := 2 To Len(aImport)
		If !SA2->( dbSeek(xfilial("SA2")+PadL(Alltrim(aImport[nX,nx_FORNEC]),6,"0")+PadL(Alltrim(aImport[nX,nx_LOJA]),2,"0") ) )		
			MsgStop("Fornecedor "+PadL(Alltrim(aImport[nX,nx_FORNEC]),6,"0")+"-"+PadL(Alltrim(aImport[nX,nx_LOJA]),2,"0")+" informado na Linha " +Alltrim(Str(nX))+" n�o est� cadastrado. Verifique!")
			lRet := .F.
		Endif                         
	Next nX

   // Verifica se a TES est� preenchida
	For nX := 2 To Len(aImport)
		If empty(Alltrim(aImport[nX,nx_TES1]))
			MsgStop("Na linha  " +Alltrim(Str(nX))+" a TES precisa ser informada. Verifique!")
			lRet := .F.
		Endif  								
	Next nX

   // Verifica se a TES existe no Cadastro
	For nX := 2 To Len(aImport)
		If !empty(aImport[nX,nx_TES1]) .and. !SF4->( dbSeek(xfilial("SF4")+aImport[nX,nx_TES1] ) )
			MsgStop("A TES "+aImport[nX,nx_TES1]+" informada na Linha " +Alltrim(Str(nX))+" n�o est� cadastrada. Verifique!")
			lRet := .F.
		Endif  
		
	Next nX

Return (lRet)