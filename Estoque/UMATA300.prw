#include "rwmake.ch"
#include "totvs.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �UMATA300  �Autor  �Helio Ferreira      � Data �  11/09/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Saldo Atual (MATA300) Gen�rico                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function UMATA300(cProd1,cProd2,cLoc1,cLoc2,cFilDOM)
	Local _Retorno := .T.
	Local x

	Default cProd1 := Space(15)
	Default cProd2 := Repl("z",15)
	Default cLoc1  := Space(2)
	Default cLoc2  := "zz"
	Default cFilDOM:= xFILIAL("SB2")//cFilAnt

	For x := 1 to 10
		_Retorno := startjob("U_JobMT300",getenvserver(),.T.,cProd1,cProd2,cLoc1,cLoc2,cFilDOM)
		If _Retorno == 'OK'
			Exit
		EndIf
	Next x

	If _Retorno == "DEFAULTERRORPROC"
		MsgInfo("Erro no Reprocessamento de Saldo 'U_MATA300()'")
	EndIf

Return _Retorno 


User Function JobMT300(cProd1,cProd2,cLoc1,cLoc2,cXFilAtu) 

    cRpcEmp    := "01"            // C�digo da empresa.
	cRpcFil    := cXFilAtu 		  //"01"            // C�digo da filial.
	cEnvUser   := "Admin"         // Nome do usu�rio.
	cEnvPass   := "OpusDomex"     // Senha do usu�rio.
	cEnvMod    := "EST"           // 'FAT'  // C�digo do m�dulo.
	cFunName   := "U_JobMT300"    // 'RPC'  // Nome da rotina que ser� setada para retorno da fun��o FunName().
	aTables    := {}              // {}     // Array contendo as tabelas a serem abertas.
	lShowFinal := .F.             // .F.    // Alimenta a vari�vel publica lMsFinalAuto.
	lAbend     := .T.             // .T.    // Se .T., gera mensagem de erro ao ocorrer erro ao checar a licen�a para a esta��o.
	lOpenSX    := .T.             // .T.    // SE .T. pega a primeira filial do arquivo SM0 quando n�o passar a filial e realiza a abertura dos SXs.
	lConnect   := .T.             // .T.    // Se .T., faz a abertura da conexao com servidor As400, SQL Server etc
	
	RPCSetType(3)
	RpcSetEnv(cRpcEmp,cRpcFil,cEnvUser,cEnvPass,cEnvMod,cFunName,aTables,lShowFinal,lAbend,lOpenSX,lConnect) //PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"
    
	aBkpPerg := {}

	//Chama pergunta ocultamente para alimentar vari�veis
	Pergunte("MTA300",.F.,,,,,@aBkpPerg)

	//Altera conte�do de alguma pergunta
	mv_par01 := cLoc1
	mv_par02 := cLoc2
	mv_par03 := cProd1
	mv_par04 := cProd2
	mv_par05 := 2
	mv_par06 := 2
	mv_par07 := 2
	mv_par08 := 2

	//Carrega vari�vel principal para que os par�metros
	//definido acima sejam salvos na pr�xima chamada
	SaveMVVars(.T.)

	__SaveParam("MTA300    ", aBkpPerg)

	/*
	SX1->( dbSetOrder(1) )

	If SX1->( dbSeek( "MTA300    " + "01" ) )
	Reclock("SX1",.F.)
	SX1->X1_CNT01 := mv_par01
	SX1->( msUnlock() )
	EndIf

	If SX1->( dbSeek( "MTA300    " + "02" ) )
	Reclock("SX1",.F.)
	SX1->X1_CNT01 := mv_par02
	SX1->( msUnlock() )
	EndIf

	If SX1->( dbSeek( "MTA300    " + "03" ) )
	Reclock("SX1",.F.)
	SX1->X1_CNT01 := mv_par03
	SX1->( msUnlock() )
	EndIf

	If SX1->( dbSeek( "MTA300    " + "04" ) )
	Reclock("SX1",.F.)
	SX1->X1_CNT01 := mv_par04
	SX1->( msUnlock() )
	EndIf

	If SX1->( dbSeek( "MTA300    " + "05" ) )
	Reclock("SX1",.F.)
	SX1->X1_PRESEL := mv_par05
	SX1->( msUnlock() )
	EndIf

	If SX1->( dbSeek( "MTA300    " + "06" ) )
	Reclock("SX1",.F.)
	SX1->X1_PRESEL := mv_par06
	SX1->( msUnlock() )
	EndIf

	If SX1->( dbSeek( "MTA300    " + "07" ) )
	Reclock("SX1",.F.)
	SX1->X1_PRESEL := mv_par07
	SX1->( msUnlock() )
	EndIf

	If SX1->( dbSeek( "MTA300    " + "08" ) )
	Reclock("SX1",.F.)
	SX1->X1_PRESEL := mv_par08
	SX1->( msUnlock() )
	EndIf
	*/

	//�����������������������������������������������������������������Ŀ
	//� mv_par01 - Almoxarifado De   ?                                  �
	//� mv_par02 - Almoxarifado Ate  ?                                  �
	//� mv_par03 - Do produto                                           �
	//� mv_par04 - Ate o produto                                        �
	//� mv_par05 - Zera o Saldo da MOD?  Sim/Nao/Recalcula              �
	//� mv_par06 - Zera o CM da MOD?  Sim/Nao/Recalcula                 �
	//�������������������������������������������������������������������

	//Chama rotina de recalculo do saldo atual

	MATA300(.T.)

Return "OK"
