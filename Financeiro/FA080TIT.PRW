 #include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 01/08/01

User Function FA080TIT()        // incluido pelo assistente de conversao do AP5 IDE em 01/08/01

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

//C�digo do contador inclu�do por Fabr�cio Becherini (15/01/04)

SetPrvt("_NATU","_DBAIXA","calias","_CODCONT")
_DBAIXA := DBAIXA

cAlias := Alias()
/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � FA080DT  � Autor � Marcia Maria Natale   � Data � 11.01.00 낢�
굇쳐컴컴컴컴컫컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿏escri뇚o � Ponto de Entrada - Alteracao de Natureza Financeira        낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Apos validacao da data                                     낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Abertura do arquivo  De Contas a Pagar                                  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
_Natu 	:= SE2->E2_NATUREZ //Space(24)
_CodCont := Space(24)
_cFornec	:= SE2->E2_FORNECE
_cLoja	:= SE2->E2_LOJA

@ 206,382 To 330,650 Dialog oDlg Title OemToAnsi("Natureza de Operacao Financeira")
@ 10,13 Say "Natureza"
@ 10,46 Get _Natu Picture "@!" SIZE 70,10 Valid .T. F3 "SED"    

@ 40,35  BmpButton Type 1 Action LibNAT()// Substituido pelo assistente de conversao do AP5 IDE em 01/08/01 ==> @ 25,16  BmpButton Type 1 Action Execute(Libera)
@ 40,70  BmpButton Type 2 Action Close(oDlg)
Activate Dialog oDlg Centered

Return(.T.)


// Substituido pelo assistente de conversao do AP5 IDE em 01/08/01 ==> Function Libera

Static Function LibNAT()

RecLock("SE2",.F.)
	SE2->E2_NATUREZ := _Natu
MsUnlock()

// Atualiza Fornecedor
_lgrava := .F.
if SA2->(dbSeek(xfilial("SA2")+_cFornec+_cLoja) )	
	if empty(Alltrim(SA2->A2_NATUREZ))  
		_lgrava := .T.
	elseif  Alltrim(SA2->A2_NATUREZ) <> Alltrim(_Natu)  
	    	If MsgYesNo("O Fornecedor est� cadastrado com a Natureza: " + Alltrim(SA2->A2_NATUREZ) + "." + chr(13) + "Deseja Atualizar a Natureza no cadastro ?")
				_lgrava := .T.
			endif
	endif

	if _lgrava
		RecLock("SA2",.F.)
			SA2->A2_NATUREZ := _Natu
		SA2->(MsUnlock())		
	Endif

Endif

Close(oDlg)         

Return(.T.)

