//-------------------------------------------------------------------------------------------------------------------------------------------------// 
//Mauricio Lima de Souza - 11/11/18 - OpusVp                                                                                                            //
//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Especifico Domex                                                                                                                                          //
//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Gera��o tabela temporaria MRP2  (Tabela ZHA010,ZHA020)                                                                                           //
//-------------------------------------------------------------------------------------------------------------------------------------------------//
 
#INCLUDE "RWMAKE.CH" 
#INCLUDE "TOPCONN.CH"
#include "tbiconn.ch"
#INCLUDE "PROTHEUS.CH"

/*
[01] - Processamento do MRP ?        	Tipo N
[02] - Geracao de SCs ?              	Tipo N
[03] - Geracao de OPs Prod. Interme ?	Tipo N
[04] - Selecao para Geracao OPs/SCs ?	Tipo N
[05] - Data Inicial PMP / Prev. Ven ?	Tipo D
[06] - Data Final PMP / Prev. Ven ?  	Tipo D
[07] - Incrementa Numeracao de OPs ? 	Tipo N
[08] - De Armazem ?                  	Tipo C
[09] - Ate Armazem ?                 	Tipo C
[10] - Tipo de OPs/SCs para geracao ?	Tipo N
[11] - Apaga OPs/SCs Previstas ?     	Tipo N
[12] - Considera Sabados e Domingos ?	Tipo N
[13] - Considera OPs Suspensas ?     	Tipo N
[14] - Considera OPs Sacramentadas ? 	Tipo N
[15] - Recal. Niveis das Estruturas ?	Tipo N
[16] - Gera OPs Aglutinadas ?        	Tipo N
[17] - Pedidos de Venda colocados ?  	Tipo N
[18] - Considera Saldo em Estoque ?  	Tipo N
[19] - Ao atingir Estoque Maximo ?   	Tipo N
[20] - Qtd. nossa Poder Terc. ?      	Tipo N
[21] - Qtd. Terc. em nosso Poder ?   	Tipo N
[22] - Saldo rejeitado pelo CQ ?     	Tipo N
[23] - De  Documento PV/PMP ?        	Tipo C
[24] - Ate Documento PV/PMP ?        	Tipo C
[25] - Saldo bloqueado por lote ?    	Tipo N
[26] - Considera Est. Seguranca ?    	Tipo N
[27] - Ped. de Venda Bloq. Credito ? 	Tipo N
[28] - Mostra dados resumidos ?      	Tipo N
[29] - Detalha lotes vencidos ?      	Tipo N
[30] - Pedidos de Venda faturados ?  	Tipo N
[31] - Considera Ponto de Pedido ?   	Tipo N
[32] - Gera tabela necessidades ?    	Tipo N
[33] - Data inicial Ped Faturados ?  	Tipo D
[34] - Data final Ped Faturados ?    	Tipo D
[35] - Exibe resultado do calculo ?  	Tipo N
exemplo:
alterar o parametro se considera estoque de seguran�a .
aPerg[26] := 2 //1=Sim,2=Nao

*//*
*----------------------------------------------------------------------------------------------------*
USER FUNCTION M712PERG()
	*----------------------------------------------------------------------------------------------------*

	msgalert('M712PERG')
	aPerg := Paramixb[1]
//[01] - Processamento do MRP ?        	Tipo N    1
	aPerg[01] := 1
//[02] - Geracao de SCs ?              	Tipo N    1
	aPerg[02] := 2
//[03] - Geracao de OPs Prod. Interme ?	Tipo N    1
	aPerg[03] := 2
//[04] - Selecao para Geracao OPs/SCs ?	Tipo N    1
	aPerg[04] := 1
//[05] - Data Inicial PMP / Prev. Ven ?	Tipo D 01/01/2019
	aPerg[05] := ctod('01/01/2019')
//[06] - Data Final PMP / Prev. Ven ?  	Tipo D 31/12/2019
	aPerg[06] := ctod('31/12/2019')
//[07] - Incrementa Numeracao de OPs ? 	Tipo N     1
	aPerg[07] := 1
//[08] - De Armazem ?                  	Tipo C
	aPerg[08] := '  '
//[09] - Ate Armazem ?                 	Tipo C     ZZ
	aPerg[09] := 'ZZ'
//[10] - Tipo de OPs/SCs para geracao ?	Tipo N     2
	aPerg[10] := 2
//[11] - Apaga OPs/SCs Previstas ?     	Tipo N     2
	aPerg[11] := 2
//[12] - Considera Sabados e Domingos ?	Tipo N     1
	aPerg[12] := 1
//[13] - Considera OPs Suspensas ?     	Tipo N     1
	aPerg[13] := 1
//[14] - Considera OPs Sacramentadas ? 	Tipo N     1
	aPerg[14] := 1
//[15] - Recal. Niveis das Estruturas ?	Tipo N     1
	aPerg[15] := 1
//[16] - Gera OPs Aglutinadas ?        	Tipo N     2
	aPerg[16] := 2
//[17] - Pedidos de Venda colocados ?  	Tipo N     2
	aPerg[17] := 2
//[18] - Considera Saldo em Estoque ?  	Tipo N     1
	aPerg[18] := 1
//[19] - Ao atingir Estoque Maximo ?   	Tipo N     1
	aPerg[19] := 2
//[20] - Qtd. nossa Poder Terc. ?      	Tipo N     2
	aPerg[20] := 2
//[21] - Qtd. Terc. em nosso Poder ?   	Tipo N     2
	aPerg[21] := 2
//[22] - Saldo rejeitado pelo CQ ?     	Tipo N     1
	aPerg[22] := 1
//[23] - De  Documento PV/PMP ?        	Tipo C
	aPerg[23] := '      '
//[24] - Ate Documento PV/PMP ?        	Tipo C    ZZZZZ
	aPerg[24] := 'ZZZZZZ'
//[25] - Saldo bloqueado por lote ?    	Tipo N     1
	aPerg[25] := 1
//[26] - Considera Est. Seguranca ?    	Tipo N     2
	aPerg[26] := 2
//[27] - Ped. de Venda Bloq. Credito ? 	Tipo N     1
	aPerg[27] := 1
//[28] - Mostra dados resumidos ?      	Tipo N     2
	aPerg[28] := 2
//[29] - Detalha lotes vencidos ?      	Tipo N     2
	aPerg[29] := 2
//[30] - Pedidos de Venda faturados ?  	Tipo N     2
	aPerg[30] := 2
//[31] - Considera Ponto de Pedido ?   	Tipo N     2
	aPerg[31] := 2
//[32] - Gera tabela necessidades ?    	Tipo N     2
	aPerg[32] := 2
//[33] - Data inicial Ped Faturados ?  	Tipo D 01/01/2019
	aPerg[33] := CTOD('01/01/2019')
//[34] - Data final Ped Faturados ?    	Tipo D 31/21/2019
	aPerg[34] := CTOD('31/21/2019')
//[35] - Exibe resultado do calculo ?  	Tipo N     2
	aPerg[35] := 2

RETURN aPerg

User Function DjoBPAR()

//aemp := {"01","01"}
//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" USER 'MRP' PASSWORD 'Megasenha' Tables "SB1","SB2","SC1","SC2","SC3","SC4","SC5","SC6","SC7","SBM","SHF","CZI","CZJ","CZK",'CV8','CT2','SBM'  Modulo "PCP"

	_sGrupo:='MTA712'
	msgalert('DjoBPAR')

//[01] - Processamento do MRP ?        	Tipo N    1
//aPerg[01] := 1
	GravaSX1 (_sGrupo, '01',1)
//[02] - Geracao de SCs ?              	Tipo N    1
//aPerg[02] := 1  
	GravaSX1 (_sGrupo, '02',2)
//[03] - Geracao de OPs Prod. Interme ?	Tipo N    1
//aPerg[03] := 1
	GravaSX1 (_sGrupo, '03',2)
//[04] - Selecao para Geracao OPs/SCs ?	Tipo N    1
//aPerg[04] := 1
	GravaSX1 (_sGrupo, '04',1)
//[05] - Data Inicial PMP / Prev. Ven ?	Tipo D 01/01/2019
//aPerg[05] := ctod('01/01/2019')
	GravaSX1 (_sGrupo, '05',ctod('01/01/2019'))
//[06] - Data Final PMP / Prev. Ven ?  	Tipo D 31/12/2019
//aPerg[06] := ctod('31/12/2019')
	GravaSX1 (_sGrupo, '06',ctod('31/12/2019'))
//[07] - Incrementa Numeracao de OPs ? 	Tipo N     1
//aPerg[07] := 1
	GravaSX1 (_sGrupo, '07',1)
//[08] - De Armazem ?                  	Tipo C
//aPerg[08] := '  '
	GravaSX1 (_sGrupo, '08','  ')
//[09] - Ate Armazem ?                 	Tipo C     ZZ
//aPerg[09] := 'ZZ'
	GravaSX1 (_sGrupo, '09','ZZ')
//[10] - Tipo de OPs/SCs para geracao ?	Tipo N     2
//aPerg[10] := 2           
	GravaSX1 (_sGrupo, '10',2)
//[11] - Apaga OPs/SCs Previstas ?     	Tipo N     2
//aPerg[11] := 2           
	GravaSX1 (_sGrupo, '11',2)
//[12] - Considera Sabados e Domingos ?	Tipo N     1
//aPerg[12] := 1           
	GravaSX1 (_sGrupo, '12',1)
//[13] - Considera OPs Suspensas ?     	Tipo N     1
//aPerg[13] := 1           
	GravaSX1 (_sGrupo, '13',1)
//[14] - Considera OPs Sacramentadas ? 	Tipo N     1
//aPerg[14] := 1           
	GravaSX1 (_sGrupo, '14',1)
//[15] - Recal. Niveis das Estruturas ?	Tipo N     1
//aPerg[15] := 1           
	GravaSX1 (_sGrupo, '15',1)
//[16] - Gera OPs Aglutinadas ?        	Tipo N     2
//aPerg[16] := 2           
	GravaSX1 (_sGrupo, '16',2)
//[17] - Pedidos de Venda colocados ?  	Tipo N     2
//aPerg[17] := 2           
	GravaSX1 (_sGrupo, '17',2)
//[18] - Considera Saldo em Estoque ?  	Tipo N     1
//aPerg[18] := 1           
	GravaSX1 (_sGrupo, '18',1)
//[19] - Ao atingir Estoque Maximo ?   	Tipo N     1
//aPerg[19] := 2           
	GravaSX1 (_sGrupo, '19',2)
//[20] - Qtd. nossa Poder Terc. ?      	Tipo N     2
//aPerg[20] := 2           
	GravaSX1 (_sGrupo, '20',2)
//[21] - Qtd. Terc. em nosso Poder ?   	Tipo N     2
//aPerg[21] := 2           
	GravaSX1 (_sGrupo, '21',2)
//[22] - Saldo rejeitado pelo CQ ?     	Tipo N     1
//aPerg[22] := 1           
	GravaSX1 (_sGrupo, '22',1)
//[23] - De  Documento PV/PMP ?        	Tipo C
//aPerg[23] := '      '    
	GravaSX1 (_sGrupo, '23','      ')
//[24] - Ate Documento PV/PMP ?        	Tipo C    ZZZZZ
//aPerg[24] := 'ZZZZZZ'    
	GravaSX1 (_sGrupo, '24','ZZZZZZ')
//[25] - Saldo bloqueado por lote ?    	Tipo N     1
//aPerg[25] := 1           
	GravaSX1 (_sGrupo, '25',1)
//[26] - Considera Est. Seguranca ?    	Tipo N     2
//aPerg[26] := 2           
	GravaSX1 (_sGrupo, '26',2)
//[27] - Ped. de Venda Bloq. Credito ? 	Tipo N     1
//aPerg[27] := 1           
	GravaSX1 (_sGrupo, '27',1)
//[28] - Mostra dados resumidos ?      	Tipo N     2
//aPerg[28] := 2           
	GravaSX1 (_sGrupo, '28',2)
//[29] - Detalha lotes vencidos ?      	Tipo N     2
//aPerg[29] := 2           
	GravaSX1 (_sGrupo, '29',2)
//[30] - Pedidos de Venda faturados ?  	Tipo N     2
//aPerg[30] := 2           
	GravaSX1 (_sGrupo, '30',2)
//[31] - Considera Ponto de Pedido ?   	Tipo N     2
//aPerg[31] := 2           
	GravaSX1 (_sGrupo, '31',2)
//[32] - Gera tabela necessidades ?    	Tipo N     2
//aPerg[32] := 2           
	GravaSX1 (_sGrupo, '32',2)
//[33] - Data inicial Ped Faturados ?  	Tipo D 01/01/2019
//aPerg[33] := CTOD('01/01/2019')
	GravaSX1 (_sGrupo, '33',CTOD('01/01/2019'))
//[34] - Data final Ped Faturados ?    	Tipo D 31/21/2019
//aPerg[34] := CTOD('31/21/2019')
	GravaSX1 (_sGrupo, '34',CTOD('31/21/2019'))
//[35] - Exibe resultado do calculo ?  	Tipo N     2
//aPerg[35] := 2           
	GravaSX1 (_sGrupo, '35',2)

//RESET ENVIRONMENT
return

/*
Local _PARAMIXB1 := .T.  //-- .T. se a rotina roda em batch, sen�o .F.
Local _PARAMIXB2 := {}
aAdd(_PARAMIXB2,1)       //-- Tipo de per�odo 1=Di�rio; 2=Semanal; 3=Quinzenal; 4=Mensal; 5=Trimestral; 6=Semestral; 7=Diversos
aAdd(_PARAMIXB2,5)      //-- Quantidade de per�odos
aAdd(_PARAMIXB2,.T.)     //-- Considera Pedidos em Carteira
aAdd(_PARAMIXB2,nil)      //-- Array contendo Tipos de produtos a serem considerados, se Nil, assume padr�o
aAdd(_PARAMIXB2,nil)      //-- Array contendo Grupos de produtos a serem considerados, se Nil, assume padr�o
aAdd(_PARAMIXB2,.F.)     //-- Gera/N�o Gera OPs e SCs depois do c�lculo da necessidade.
aAdd(_PARAMIXB2,.F.)     //-- Indica se monta log do MRPaAdd(PARAMIXB2,"000001")
aAdd(_PARAMIXB2,"000001")  //-- N�mero da Op Inicial
aAdd(_PARAMIXB2,'23/01/2019')  //-- Database para inicio do c�lculo
aAdd(_PARAMIXB2,{})      //-- N�meros dos per�odos para gera��o de OPs
aAdd(_PARAMIXB2,{})      //-- N�meros dos per�odos para gera��o de SCs
aAdd(_PARAMIXB2,.F.)     //-- M�ximo de 99 itens por OP
aAdd(_PARAMIXB2,{'23/01/2019'} )      //-- Datas para tipo de per�odo diversos

*/


User Function Djobm712()
	PRIVATE lCZI    :=.F.
	PRIVATE lCZJ    :=.F.
	PRIVATE lCZK    :=.F.
	PRIVATE lMRPSI  :=.F.
	PRIVATE lMRFl2  :=.F.
	PRIVATE _cCODMRP:=''

/* mm
Local _PARAMIXB1 := .T.  //-- .T. se a rotina roda em batch, sen�o .F.
Local _PARAMIXB2 := {}
aAdd(_PARAMIXB2,1)       //-- Tipo de per�odo 1=Di�rio; 2=Semanal; 3=Quinzenal; 4=Mensal; 5=Trimestral; 6=Semestral; 7=Diversos
aAdd(_PARAMIXB2,180)      //-- Quantidade de per�odos
aAdd(_PARAMIXB2,.T.)     //-- Considera Pedidos em Carteira
aAdd(_PARAMIXB2,nil)      //-- Array contendo Tipos de produtos a serem considerados, se Nil, assume padr�o
aAdd(_PARAMIXB2,nil)      //-- Array contendo Grupos de produtos a serem considerados, se Nil, assume padr�o
aAdd(_PARAMIXB2,.F.)     //-- Gera/N�o Gera OPs e SCs depois do c�lculo da necessidade.
aAdd(_PARAMIXB2,.F.)     //-- Indica se monta log do MRPaAdd(PARAMIXB2,"000001")
aAdd(_PARAMIXB2,"000001")  //-- N�mero da Op Inicial
aAdd(_PARAMIXB2,dtoc(date()))  //-- Database para inicio do c�lculo
aAdd(_PARAMIXB2,{})      //-- N�meros dos per�odos para gera��o de OPs
aAdd(_PARAMIXB2,{})      //-- N�meros dos per�odos para gera��o de SCs
aAdd(_PARAMIXB2,.F.)     //-- M�ximo de 99 itens por OP
aAdd(_PARAMIXB2,{} )      //-- Datas para tipo de per�odo diversos
*/

	U_MRPDELF() // DROP TABLE CZI010, CZJ010, CZK010

	aemp := {"01","01"}
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" USER 'MRP' PASSWORD 'MRP' Tables "SB1","SB2","SC1","SC2","SC3","SC4","SC5","SC6","SC7","SBM","SHF","CZI","CZJ","CZK","CV8","CT2","SBM","CT5","ZZ7"  Modulo "PCP"
//MATA712(.T.,{1,5,.T.,{},{},.F.,.F.,180,DATE(),{},{},.F.,DATE()})  


//MsAguarde( { || U_MRP02INI() } ,"Inicio MRP Domex V2", "Aguarde..." )  
//MATA712(_PARAMIXB1,_PARAMIXB2)

	//IF lCZI==.T. .AND. lCZJ==.T. .AND. lCZK==.T.
	MATA712( .T.,{1,730,.T.,;
		{{.T.,'AT'},{.T.,'BN'},{.T.,'FP'},{.T.,'GG'},{.T.,'MA'},{.T.,'MC'},{.T.,'MD'},{.T.,'ME'},{.T.,'MO'},{.T.,'MP'},{.T.,'MS'},{.T.,'PA'},{.T.,'PI'},{.T.,'PR'},{.T.,'SI'},{.T.,'SV'}},;
		{{.T.,'    '},{.T.,'0   '},{.T.,'0001'},{.T.,'0002'},{.T.,'0003'},{.T.,'0004'},{.T.,'0005'},{.T.,'0006'},{.T.,'ABRC'},{.T.,'ADES'},{.T.,'ADOP'},{.T.,'ANTE'},{.T.,'ATOP'},{.T.,'AUTO'},;
		{.T.,'BAST'},{.T.,'BRID'},{.T.,'CALI'},{.T.,'CBCX'},{.T.,'CCOX'},{.T.,'CE  '},{.T.,'COM '},{.T.,'CON '},{.T.,'CORD'},{.T.,'CXEM'},{.T.,'DIO '},{.T.,'DIOE'},{.T.,'DIV '},{.T.,'DROP'},;
		{.T.,'EBPA'},{.T.,'EBPL'},{.T.,'EPTR'},{.T.,'ESTP'},{.T.,'ETQE'},{.T.,'FERG'},{.T.,'FERR'},{.T.,'FLEX'},{.T.,'FO  '},{.T.,'FOFS'},{.T.,'FTTA'},{.T.,'INFO'},{.T.,'JUMP'},{.T.,'LIXA'},;
		{.T.,'MAGC'},{.T.,'MAIN'},{.T.,'MAOP'},{.T.,'MASE'},{.T.,'MC  '},{.T.,'ME  '},{.T.,'MESC'},{.T.,'MFTX'},{.T.,'MKT '},{.T.,'MLIP'},{.T.,'MMAQ'},{.T.,'MMV '},{.T.,'MPS '},{.T.,'OBRA'},;
		{.T.,'PARF'},{.T.,'PCJO'},{.T.,'PCLH'},{.T.,'PCMP'},{.T.,'PCOP'},{.T.,'PV  '},{.T.,'REOP'},{.T.,'RF  '},{.T.,'RT  '},{.T.,'SEMI'},{.T.,'SENS'},{.T.,'TRSU'},{.T.,'TRUE'},{.T.,'TRUN'},;
		{.T.,'TUBO'},{.T.,'USIN'},{.T.,'UTP '},{.T.,'WRL '}},.F.,.F.,1800})

	U_MRP020()
	//ELSE
	//	cData     := DtoC(Date())
	//	cAssunto  := "MRP V2 não foi proosivel deletar tabelas (CZI,CZJ,CZK) - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
	//	cTexto    := "MRP V2 não foi proosivel deletar tabelas (CZI,CZJ,CZK)- Date " + cData + "  Time: " + Time()
	//	cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br"
	//	cCC       := ""
	//	cArquivo  := ""

	//	U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)

	//ENDIF

	RESET ENVIRONMENT

RETURN Nil

/*
Local lBatch    := .T.  //-> Identifica MRP rodado em modo Batch
Local nTipoPer  :=  1   //-> Tipo de per�odo 1=Di�rio;2=Semanal;3=Quinzenal;4=Mensal;5=Trimestral;6=Semestral;7=Diversos
Local nPeriodos := 180   //-> Quantidade de per�odos
Local lPedidos  := .T.  //-> Considera Pedidos em Carteira
Local aTipo     := Nil  //-> Array contendo Tipos de produtos a serem, se Nil, assume padr�o
Local aGrupo    := Nil  //-> Array contendo Grupos de produtos a serem considerados, se Nil, assume padr�o
Local lGeraOpSc := .F.  //-> Gera/N�o Gera OPs e SCs depois do c�lculo da necessidade.
Local lLogMrp   := .F.  //-> Indica se monta log do MRP
Local cNumOpDig := "000001" //-> N�mero da Op Inicial
Local cDatabase := "12/11/2018"
Local aPerOP := {}
Local aPerSC := {}
Local lMaxItemOp := .F.
Local aDataDiv := {}

MATA712(PARAMIXB1,PARAMIXB2)  // MATA712 MRP
//****************************
//* Monta a Tabela de Tipos  *
//****************************

dbSelectArea("SX5")
dbSeek(xFilial("SX5")+"02")
	Do While (X5_FILIAL == xFilial("SX5")) .AND. (X5_TABELA == "02") .and. !Eof()
cCapital := OemToAnsi(Capital(X5Descri()))
AADD(PARAMIXB2[4],{.T.,SubStr(X5_chave,1,2)+" "+cCapital})
dbSkip()
	EndDo
//****************************
//* Monta a Tabela de Grupos *
//****************************
dbSelectArea("SBM")
dbSeek(xFilial("SBM"))
AADD(PARAMIXB2[5],{.T.,Criavar("B1_GRUPO",.F.)+" "+"Grupo em Branco"})
	Do While (BM_FILIAL == xFilial("SBM")) .AND. !Eof()
cCapital := OemToAnsi(Capital(BM_DESC))
AADD(PARAMIXB2[5],{.T.,SubStr(BM_GRUPO,1,4)+" "+cCapital})
dbSkip()
	EndDo

//------------------------------------------------------------------------------------------------
cData     := DtoC(Date())
cAssunto  := "Inicio MRP V2  - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
cTexto    := "Inicio MRP V2  - Date " + cData + "  Time: " + Time()
cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br"
cCC       := ""
cArquivo  := ""

U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
//------------------------------------------------------------------------------------------------
MRP02INI()                    // AJUSTE INICIAL MRP
//------------------------------------------------------------------------------------------------
cData     := DtoC(Date())
cAssunto  := "MRP V2 Inicio MATA712 - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
cTexto    := "MRP V2 Inicio MATA712 - Date " + cData + "  Time: " + Time()
cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br"
cCC       := ""
cArquivo  := ""

U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
//------------------------------------------------------------------------------------------------
//MATA712(PARAMIXB1,PARAMIXB2)  // MATA712 MRP
MATA712(lBatch,{nTipoPer,nPeriodos,lPedidos,,,lGeraOpSc,lLogMRP,cNumOpDig,cDatabase,aPerOP,aPerSC,lMaxItemOp,aDataDiv})
//------------------------------------------------------------------------------------------------
cData     := DtoC(Date())
cAssunto  := "MRP V2 Cubo MRP - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
cTexto    := "MRP V2 Cubo MRP - Date " + cData + "  Time: " + Time()
cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br"
cCC       := ""
cArquivo  := ""

U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
//------------------------------------------------------------------------------------------------
MRP020()                      // GERACAO CUBO
//------------------------------------------------------------------------------------------------

cData     := DtoC(Date())
cAssunto  := "Fim MRP V2  - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
cTexto    := "Fim MRP V2  - Date " + cData + "  Time: " + Time()
cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br"
cCC       := ""
cArquivo  := ""

U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
//------------------------------------------------------------------------------------------------

RESET ENVIRONMENT
Return Nil

*/
	*----------------------------------------------------------------------------------------------------*
USER FUNCTION MRP02INI()
	*----------------------------------------------------------------------------------------------------*
	PRIVATE nMRPS:=0

/*
//------------------------------------------------------------------------------------------------
cData     := DtoC(Date())
cAssunto  := "MRP V2  Atualiza empenho - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
cTexto    := "MRP V2  Atualiza empenho - Date " + cData + "  Time: " + Time()
cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br"
cCC       := ""
cArquivo  := ""

U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
//------------------------------------------------------------------------------------------------

*--------------------------------------------------------------------------
cSQ1A := " DROP TABLE SD4TMP "
*--------------------------------------------------------------------------
cSQ2A := " SELECT D4_COD,D4_LOCAL,SUM(D4_QUANT)  D4_QUANT "
cSQ2A += " INTO SD4TMP    "
cSQ2A += " FROM SD4010 WHERE D4_QUANT>0  AND D_E_L_E_T_=''  AND D4_FILIAL='01' "
cSQ2A += " GROUP BY D4_COD,D4_LOCAL "
*--------------------------------------------------------------------------
cSQ3A := " UPDATE SB2010 SET B2_QEMP=0  "
*--------------------------------------------------------------------------
cSQ4A := " UPDATE SB2010 SET B2_QEMP=(SELECT D4_QUANT FROM SD4TMP WHERE D_E_L_E_T_='' AND D4_COD+D4_LOCAL=B2_COD+B2_LOCAL ) "
cSQ4A += " WHERE  B2_FILIAL='01' AND D_E_L_E_T_='' "
cSQ4A += " AND EXISTS (SELECT D4_QUANT FROM SD4TMP WHERE D_E_L_E_T_='' AND D4_COD+D4_LOCAL=B2_COD+B2_LOCAL ) "
*--------------------------------------------------------------------------
TCSQLEXEC(cSQ1A)
TCSQLEXEC(cSQ2A)
TCSQLEXEC(cSQ2A)
TCSQLEXEC(cSQ4A)

*/
	cSQLDOC := " UPDATE SZV010 SET ZV_DESCRI=  (SELECT TOP 1 SUBSTRING(QDH_TITULO,1,60) FROM QDH010 WHERE QDH_DOCTO=ZV_ARQUIVO AND QDH010.D_E_L_E_T_=''  ORDER BY QDH_RV DESC) "
	cSQLDOC += " WHERE D_E_L_E_T_='' AND EXISTS(SELECT TOP 1 SUBSTRING(QDH_TITULO,1,60) FROM QDH010 WHERE QDH_DOCTO=ZV_ARQUIVO AND QDH010.D_E_L_E_T_=''  ORDER BY QDH_RV DESC) "
	cSQLDOC += " AND ZV_DESCRI<>(SELECT TOP 1 SUBSTRING(QDH_TITULO,1,60) FROM QDH010 WHERE QDH_DOCTO=ZV_ARQUIVO AND QDH010.D_E_L_E_T_=''  ORDER BY QDH_RV DESC) "

	TCSQLEXEC(cSQLDOC)


	cSQLSIM := " UPDATE SC4010 SET D_E_L_E_T_='*', R_E_C_D_E_L_=R_E_C_N_O_ WHERE  C4_XXSIMU='S' AND D_E_L_E_T_='' "
	TCSQLEXEC(cSQLSIM)

	cData     := DtoC(Date())
	cAssunto  := "MRP V2  Deletado MRP Simulacao - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
	cTexto    := "MRP VV2  Deletado MRP Simulacao - Date " + cData + "  Time: " + Time()
	cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br;paulo.celestino@rdt.com.br"
	cCC       := ""
	cArquivo  := ""

	U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)

	_cCODMRP:=''
	
	cQUERYCD :="SELECT MAX(ZZ7_COD) AS MXCOD FROM ZZ7010 WHERE D_E_L_E_T_='' "
	TcQuery cQUERYCD Alias "TRCD" New
	If TRCD->(Eof())
		_cCODMRP:='000000'
	ELSE
	 _cCODMRP:=StrZero((VAL(TRCD->MXCOD)+1),6)
    ENDIF

	TRCD->(DbCloseArea())

	//MLS ZZ7 INI
	
	ZZ7->(dbSelectArea("ZZ7"))
	ZZ7->(DBSETORDER(1))
	Reclock("ZZ7",.T.)
	ZZ7->ZZ7_FILIAL	:= xFilial("ZZ7")
	ZZ7->ZZ7_TIPO	:="1"
	ZZ7->ZZ7_COD   	:=_cCODMRP
	ZZ7->ZZ7_NRMRP := ""
	ZZ7->ZZ7_DTINI	:=DATE()
	//ZZ7->ZZ7_DTFIM  :=""
	ZZ7->ZZ7_HRINI	:=TIME()
	//ZZ7->ZZ7_HRFIM	:=""
	ZZ7->ZZ7_HIST   :="INICIO FILIAL 01"
	ZZ7->( msUnlock() )

//SC1 SALDO
//------------------------------------------------------------------------------------------------
	cData     := DtoC(Date())
	cAssunto  := "MRP V2  INICIO - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
	cTexto    := "MRP V2  INICIO - Date " + cData + "  Time: " + Time()
	cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br;paulo.celestino@rdt.com.br"
	cCC       := ""
	cArquivo  := ""

	U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)

//------------------------------------------------------------------------------------------------
	cData     := DtoC(Date())
	cAssunto  := "MRP V2  Saldo SC - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
	cTexto    := "MRP V2  Saldo SC- Date " + cData + "  Time: " + Time()
	cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br"
	cCC       := ""
	cArquivo  := ""

	U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
//------------------------------------------------------------------------------------------------
	cSQL := " UPDATE SC1010 SET C1_QUJE= "
	cSQL += " (SELECT SUM(C7_QUANT)  "
	cSQL += "   FROM SC7010 WITH(NOLOCK)  "
	cSQL += "   WHERE C7_NUMSC=C1_NUM  "
	cSQL += "         AND C7_ITEMSC=C1_ITEM  "
	cSQL += "         AND C7_PRODUTO=C1_PRODUTO  "
	cSQL += "         AND D_E_L_E_T_<>'*' AND C7_FILIAL = '"+xFILIAL('SC7')+"' "
	cSQL += "         GROUP BY C7_NUMSC,C7_ITEMSC) "
	cSQL += " WHERE D_E_L_E_T_='' AND C1_FILIAL='"+xFILIAL('SC1')+"' "
	cSQL += " AND   C1_QUANT>C1_QUJE "
	cSQL += " AND   C1_RESIDUO='' AND C1_FILIAL = '"+xFILIAL('SC1')+"' "
	cSQL += " AND C1_NUM+C1_ITEM+C1_PRODUTO IN  "
	cSQL += " (SELECT C7_NUMSC+C7_ITEMSC+C7_PRODUTO FROM SC7010 WITH(NOLOCK) WHERE D_E_L_E_T_='' AND C7_RESIDUO='' AND C7_FILIAL = '"+xFILIAL('SC7')+"' ) "
	TCSQLEXEC(cSQL)
	/*
	*-----------------------------------------------------------
//empenho
//------------------------------------------------------------------------------------------------
	cData     := DtoC(Date())
	cAssunto  := "MRP V2  Empenho SB2 - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
	cTexto    := "MRP V2  Empenho SB2 - Date " + cData + "  Time: " + Time()
	cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br"
	cCC       := ""
	cArquivo  := ""

	U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
//------------------------------------------------------------------------------------------------
	cSQLEMP := " UPDATE SB2010 SET B2_QEMP=ISNULL((SELECT SUM(D4_QUANT) FROM SD4010 WHERE D_E_L_E_T_='' AND D4_COD=B2_COD AND D4_LOCAL=B2_LOCAL AND D4_QUANT>0  ),0) "
	cSQLEMP += " WHERE              EXISTS (SELECT SUM(D4_QUANT) FROM SD4010 WHERE D_E_L_E_T_='' AND D4_COD=B2_COD AND D4_LOCAL=B2_LOCAL AND D4_QUANT>0  ) "
	TCSQLEXEC(cSQLEMP)
	*-----------------------------------------------------------
*/
//EXPLODE SC4
	cData     := DtoC(Date())
	cAssunto  := "MRP V2  Explode SC4 Prev.Venda - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
	cTexto    := "MRP V2  Explode SC4 Prev.Venda - Date " + cData + "  Time: " + Time()
	cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br"
	cCC       := ""
	cArquivo  := ""

	U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)

	U_ExplSC4()
	*-----------------------------------------------------------
//************************************************************************************************************************************
//* Apagando todos os registros da SHF. Tivemos problemas de cria��o de milh�es de registros nela sem sabermos exatamente para que.  *
//************************************************************************************************************************************

	TCSQLEXEC("DELETE "+RetSqlName("SHF"))

//�������������������������������������������u
//�Selecionando registros para compor   o MRP�
//�������������������������������������������u

	cData     := DtoC(Date())
	cAssunto  := "MRP V2  Campo B1_MRP - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
	cTexto    := "MRP V2  Campo B1_MRP - Date " + cData + "  Time: " + Time()
	cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br"
	cCC       := ""
	cArquivo  := ""

	U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)

	TCSQLEXEC("UPDATE SC4010 SET C4_QUANT = 0 WHERE C4_FILIAL='"+xFILIAL('SC4')+"' AND  C4_DATA <'"+DTOS(FIRSTDAY(DDATABASE))+"' AND  D_E_L_E_T_ = '' ")

	TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'N'")
	TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'S' FROM SB1010, SC7010 WHERE C7_FILIAL='"+xFILIAL('SC7')+"' AND B1_FILIAL='"+xFILIAL('SB1')+"' AND  C7_RESIDUO = '' AND C7_QUJE < C7_QUANT AND C7_PRODUTO = B1_COD AND B1_MRP <> 'S' AND SB1010.D_E_L_E_T_ = '' AND SC7010.D_E_L_E_T_ = '' ")
	TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'S' FROM SC1010, SB1010 WHERE C1_FILIAL='"+xFILIAL('SC1')+"' AND B1_FILIAL='"+xFILIAL('SB1')+"' AND  C1_QUJE < C1_QUANT AND C1_RESIDUO = '' AND C1_PRODUTO = B1_COD AND B1_MRP <> 'S' AND SB1010.D_E_L_E_T_ = '' AND SC1010.D_E_L_E_T_ = '' ")
	TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'S' FROM SD4010, SB1010 WHERE D4_FILIAL='"+xFILIAL('SD4')+"' AND B1_FILIAL='"+xFILIAL('SB1')+"' AND D4_QUANT <> 0 AND D4_COD = B1_COD AND B1_MRP <> 'S' AND SB1010.D_E_L_E_T_ = '' AND SD4010.D_E_L_E_T_ = '' ")
	TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'S' FROM SC2010, SB1010 WHERE C2_FILIAL='"+xFILIAL('SC2')+"' AND B1_FILIAL='"+xFILIAL('SB1')+"' AND C2_QUANT > C2_QUJE AND C2_DATRF = '' AND C2_PRODUTO = B1_COD AND B1_MRP <> 'S' AND SB1010.D_E_L_E_T_ = '' AND SC2010.D_E_L_E_T_ = '' ")
	TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'S' FROM SC4010, SB1010 WHERE C4_FILIAL='"+xFILIAL('SC4')+"' AND B1_FILIAL='"+xFILIAL('SB1')+"' AND C4_QUANT <> 0 AND C4_PRODUTO = B1_COD AND B1_MRP <> 'S' AND SB1010.D_E_L_E_T_ = '' AND SC4010.D_E_L_E_T_ = '' ")
	TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'S' FROM SC6010, SB1010 WHERE C6_FILIAL='"+xFILIAL('SC6')+"' AND B1_FILIAL='"+xFILIAL('SB1')+"' AND C6_QTDENT < C6_QTDVEN AND C6_PRODUTO = B1_COD AND B1_MRP <> 'S' AND SB1010.D_E_L_E_T_ = '' AND SC6010.D_E_L_E_T_ = '' ")

	TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'S' FROM SB1010  WHERE B1_FILIAL='"+xFILIAL('SB1')+"' AND B1_ALTER IN (SELECT B1_COD FROM SB1010 (NOLOCK) WHERE B1_MRP = 'S' AND B1_FILIAL = '"+xFILIAL('SB1')+"') AND B1_MRP = 'N' AND D_E_L_E_T_ = ''")
	TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'S' WHERE  B1_FILIAL='"+xFILIAL('SB1')+"' AND B1_COD  IN (SELECT GI_PRODALT FROM SGI010 (NOLOCK) WHERE D_E_L_E_T_='' AND GI_FILIAL = '"+xFILIAL('SGI')+"' )" )

	cQueryMRPS := " UPDATE SB1010 SET B1_MRP='S'  "
	cQueryMRPS += " WHERE B1_FILIAL='"+xFILIAL('SB1')+"' AND B1_COD IN "
	cQueryMRPS += " (SELECT G1_COMP "
	cQueryMRPS += " FROM SG1010 (NOLOCK) "
	cQueryMRPS += " WHERE G1_FILIAL='"+xFILIAL('SG1')+"' AND D_E_L_E_T_='' AND  G1_COD IN  "
	cQueryMRPS += " (select B1_COD from SB1010 (NOLOCK) where B1_FILIAL='"+xFILIAL('SB1')+"' AND B1_MRP='S' AND D_E_L_E_T_='')GROUP BY G1_COMP) "
	cQueryMRPS += " AND D_E_L_E_T_='' "
	cQueryMRPS += " AND B1_MRP<>'S' " 

	nMRPS := 0
	For nMRPS := 1 TO  10
		TCSQLEXEC(cQueryMRPS)
		Sleep( 2000 )   // Para o processamento por 2 segundo
	NEXT

	TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'N' WHERE B1_FILIAL='"+xFILIAL('SB1')+"' AND B1_TIPO IN ('SI','AT' ) AND  B1_MRP = 'S' AND D_E_L_E_T_='' " )
	TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'N' WHERE B1_FILIAL='"+xFILIAL('SB1')+"' AND B1_LOCPAD='03'          AND  B1_MRP = 'S' AND D_E_L_E_T_='' " )
	TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'N' WHERE B1_FILIAL='"+xFILIAL('SB1')+"' AND B1_TIPO='GG'            AND  B1_MRP = 'S' AND D_E_L_E_T_='' " )

//MSGALERT('FIM INICIALIZACAO MRP')

	//If Subs(cUsuario,7,5) == "HELIO"
	//	NMODULO = 10
	//	MATA712()
	//	U_MRP020()
	//EndIf

RETURN


	*----------------------------------------------------------------------------------------------------*
USER FUNCTION  MRP020()    //GERACAO CUBO MRP
	*----------------------------------------------------------------------------------------------------*
	U_MRP020B()
RETURN

	*----------------------------------------------------------------------------------------------------*
USER FUNCTION  MRP020B()    //GERACAO CUBO MRP
	*----------------------------------------------------------------------------------------------------*

	Local   cQuery    := ""
	Local   cAlias    :="TRB"
	LOCAL   nPERIODO  :=0
	LOCAL   nX        :=0
	LOCAL   nZ        :=0

	PRIVATE nLTIME    :=0  //LEAD TIME
	PRIVATE nLOTEE    :=0  //LOTE ECONOMICO

	PRIVATE _SC4COD:= ''
	PRIVATE _SC4REC:= 0

	PRIVATE _cTXTSC4:=SPACE(20)
	PRIVATE _cSC4COD:=SPACE(06)

//------------------------------------------------------------------------------------------------------
	cData     := DtoC(Date())
	cAssunto  := "MRP V2  Inicio Cubo MRP - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
	cTexto    := "MRP V2  Inicio Cubo MRP - Date " + cData + "  Time: " + Time()
	cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br;paulo.celestino@rdt.com.br"
	cCC       := ""
	cArquivo  := ""

	U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
//------------------------------------------------------------------------------------------------------


	cQUERY1:=" DELETE FROM ZHA010  "
	TCSQLEXEC(cQUERY1)

	cQuery := " SELECT  "
	cQuery += " '  '        ZHA_FILIAL, "
	cQuery += " CZK_PERMRP  ZHA_PERIOD, "
	cQuery += " CZI_PERMRP, "
	cQuery += " CZK_NRMRP   ZHA_NUMMRP, "
	cQuery += " CZJ_NRLV    ZHA_NIVEL, "
	cQuery += " CZJ_PROD    ZHA_PRODUT, "
	cQuery += " CZJ_OPCORD  , "
	cQuery += " CZI_ALIAS, "
	cQuery += "  CASE  CZI_ALIAS "

	cQuery += "       WHEN 'SB1' THEN '00-Seguranca'       "
	cQuery += "       WHEN 'SB2' THEN '00-Saldo Negativo'  "
	cQuery += "       WHEN 'SC1' THEN '03-Sol.Compras'     "
	cQuery += "       WHEN 'SC7' THEN '04-Pedido Compra'   "
	cQuery += "       WHEN 'SD4' THEN '05-Empenho'         "
	cQuery += "       WHEN 'SC2' THEN '06-Ordem Producao'  "
	cQuery += "       WHEN 'SC6' THEN '07-Pedido Venda'    "
	cQuery += "       WHEN 'CZJ' THEN '08-Saida Estrutura' "
	cQuery += "       WHEN 'ENG' THEN '08-Saida Estrutura' "
	cQuery += "       WHEN 'SC4' THEN '09-Previsao Venda'  "

	cQuery += " 	  ELSE "
	cQuery += " 	    CZI_ALIAS "
	cQuery += "  END "
	cQuery += " 		AS  ZHA_TIPO, "
	cQuery += " CZI_DOC      AS ZHA_TEXTO, "
	cQuery += " CZI_TPRG, "
	cQuery += " CZI_DOCKEY, "
	cQuery += " CZI_DTOG,   "
	cQuery += " CZI_QUANT,  "
	cQuery += " B1_DESC       AS ZHA_DESC  , "
	cQuery += " B1_TIPO       AS ZHA_TIPOP , "
	cQuery += " B1_GRUPO      AS ZHA_GRUPO , "
	cQuery += " CZK_QTSLES,                  "
	cQuery += " CZK_QTENTR,                  "
	cQuery += " CZK_QTSAID,                  "
	cQuery += " CZK_QTSEST,                  "
	cQuery += " CZK_QTSALD,                  "
	cQuery += " CZK_QTNECE,                  "
	cQuery += " '          '  AS ZHA_TXDT1,  "
	cQuery += " '          '  AS ZHA_TXDT2,  "
	cQuery += " '          '  AS ZHA_IDMRP,  "
	cQuery += " '          '  AS ZHA_NUMSC,  "
	cQuery += " '          '  AS ZHA_HISTSC, "
	cQuery += " 0             AS ZHA_QTDSC,  "
	cQuery += " '          '  AS ZHA_DATASC, "
	cQuery += " '          '  AS ZHA_STATUS, "
	cQuery += " '      '      AS ZHA_FORN,   "
	cQuery += " '  '          AS ZHA_LOJA,   "
	cQuery += " 0             AS ZHA_UPRC,   "
	cQuery += " '          '  AS ZHA_NFORN,  "
	cQuery += "  CASE  CZI_ALIAS "
	cQuery += "  WHEN 'SC4' THEN  CZI_PROD  "
	cQuery += "  ELSE '               ' "
	cQuery += "  END "
	cQuery += "  AS  ZHA_SC4COD, "
	cQuery += "  CASE  CZI_ALIAS "
	cQuery += "  WHEN 'SC4' THEN  CZI_NRRGAL  "
	cQuery += "  ELSE 0 "
	cQuery += "  END "
	cQuery += "  AS  ZHA_SC4REC "
	cQuery += "  FROM CZK010 CZK WITH(NOLOCK),CZJ010 CZJ WITH(NOLOCK)  , CZI010 CZI WITH(NOLOCK), SB1010 SB1 WITH(NOLOCK) "
	cQuery += " WHERE "
	cQuery += "     CZK_RGCZJ= CZJ.R_E_C_N_O_  "
	cQuery += " AND B1_COD=CZJ_PROD and B1_TIPO NOT IN('PA','PI','MO')  AND SB1.D_E_L_E_T_='' "
	cQuery += " AND CZI_PROD=CZJ_PROD AND CZI_PERMRP=CZK_PERMRP AND CZJ_NRLV=CZI_NRLV         "
	cQuery += " AND CZK.CZK_FILIAL='"+xFILIAL('CZK')+"' "
	cQuery += " AND CZI.CZI_FILIAL='"+xFILIAL('CZI')+"' "
	cQuery += " AND CZJ.CZJ_FILIAL='"+xFILIAL('CZJ')+"' "
	cQuery += " AND SB1.B1_FILIAL ='"+xFILIAL('SB1')+"' "
	cQuery += " order by CZI.CZI_PERMRP,CZJ.CZJ_PROD,CZI.CZI_TPRG "

	TcQuery cQuery Alias "TRB" New

	TRB->(DbGoTop())

	If TRB->(Eof())
		//	Alert("Nao foi encontrado nenhum item neste Processo !")
		DbSelectArea("TRB")
		TRB->(DbCloseArea())
		Return()
	EndIf

	ZHA->(DBSELECTAREA('ZHA'))
	ZHA->(DBSETORDER(2))

	cIDMRP :=TRB->ZHA_NUMMRP+'000'// INICIALIZADOR IDMRP


	//ZZ7 NUM MRP TRB->ZHA_NUMMRP
	
	ZZ7->(dbSelectArea("ZZ7"))
	ZZ7->(DBSETORDER(1))
	ZZ7->(DbSeek(xFilial("ZZ7")+_cCODMRP))
	IF ZZ7->(FOUND())
	   Reclock("ZZ7",.F.)
	   ZZ7->ZZ7_NRMRP  :=TRB->ZHA_NUMMRP
	   ZZ7->ZZ7_HIST    :="CUBO FILIAL 01"
	   ZZ7->(MsUnlock())
	ENDIF   
	
	DO WHILE .NOT. TRB->(EOF())
		dPERIOD := STOD(TRB->CZI_DTOG)
		cNUMMRP := TRB->ZHA_NUMMRP
		cPRODUT := TRB->ZHA_PRODUT
		cPERMRP := TRB->CZI_PERMRP
		cQuery   += " order by CZI.CZI_PERMRP,CZJ.CZJ_PROD "
		//DO WHILE .NOT. TRB->(EOF()).AND. TRB->ZHA_FILIAL == xFILIAL('ZHA') .AND. STOD(TRB->CZI_DTOG) == dPERIOD .AND. TRB->ZHA_NUMMRP == cNUMMRP .AND. TRB->ZHA_PRODUT == cPRODUT
		DO WHILE .NOT. TRB->(EOF()).AND. TRB->ZHA_FILIAL == xFILIAL('ZHA') .AND. TRB->CZI_PERMRP == cPERMRP .AND. TRB->ZHA_PRODUT == cPRODUT
			RecLock("ZHA",.T.)
			ZHA->ZHA_FILIAL := xFILIAL('ZHA')
			ZHA->ZHA_PERIOD := dPERIOD
			ZHA->ZHA_NUMMRP := TRB->ZHA_NUMMRP
			ZHA->ZHA_PRODUT := TRB->ZHA_PRODUT
			ZHA->ZHA_DESC   := TRB->ZHA_DESC
			ZHA->ZHA_TIPO   := TRB->ZHA_TIPO
			ZHA->ZHA_TIPOP  := TRB->ZHA_TIPOP
			ZHA->ZHA_GRUPO  := TRB->ZHA_GRUPO
			ZHA->ZHA_NIVEL  := TRB->ZHA_NIVEL
			//ZHA->ZHA_REVISA := TRB->ZHA_REVISA
			//ZHA->ZHA_REVSHW := TRB->ZHA_REVSHW
			IF ALLTRIM(TRB->ZHA_TIPO)=='09-Previsao Venda'
				MRP02SC4(TRB->ZHA_SC4REC)
				ZHA->ZHA_TEXTO  := _cTXTSC4
				ZHA->ZHA_SC4COD := _cSC4COD
			ELSE
				ZHA->ZHA_TEXTO  := TRB->ZHA_TEXTO
			ENDIF
			ZHA->ZHA_TXDT1  := DTOC(dPERIOD)
			ZHA->ZHA_TXDT2  := dPERIOD
			ZHA->ZHA_XQTDE  := TRB->CZI_QUANT
			ZHA->ZHA_SC4REC := TRB->ZHA_SC4REC
			DO CASE
			CASE SUBSTR(TRB->ZHA_TIPO,1,2) $('05|07|09|00')  //05-Empenho   07-Pedido Venda    09-Previsao Venda 00-Seguranca
				ZHA->ZHA_SAIDA:=TRB->CZI_QUANT
			CASE SUBSTR(TRB->ZHA_TIPO,1,2) =='08'            //08-Saida Estrutura
				ZHA->ZHA_SESTR:=TRB->CZI_QUANT
			CASE SUBSTR(TRB->ZHA_TIPO,1,2) $('03|04|06')     //03-Sol.Compras //04-Pedido Compra   06-Ordem Producao
				ZHA->ZHA_ENTRAD:=TRB->CZI_QUANT
			ENDCASE

			nSLDINI  :=TRB->CZK_QTSLES    //SALDO INICIAL    02-Saldo Estoque
			//CZK_QTENTR                  //ENTRADA
			//CZK_QTSAID                  //SAIDA
			//CZK_QTSEST                  //SAIDA ESTRUTURA
			nSLDFIN  :=TRB->CZK_QTSALD    //SALDO FINAL      10-Saldo Final
			nNECE    :=TRB->CZK_QTNECE    //NECESSIDADE      01-Necessidade

			cDESC    :=TRB->ZHA_DESC
			cTIPOP   :=TRB->ZHA_TIPOP
			cGRUPO   :=TRB->ZHA_GRUPO
			dDATA    :=dPERIOD

			ZHA->( msUnlock() )
			TRB->(DBSKIP())
		ENDDO
		*------02-Saldo Estoque--------------------------------------------------------------------------------
		RecLock("ZHA",.T.)
		ZHA->ZHA_FILIAL := xFILIAL('ZHA')
		ZHA->ZHA_PERIOD := dPERIOD
		ZHA->ZHA_NUMMRP := cNUMMRP
		ZHA->ZHA_PRODUT := cPRODUT
		ZHA->ZHA_DESC   := cDESC
		ZHA->ZHA_TIPO   := '02-Saldo Estoque'
		ZHA->ZHA_TIPOP  := cTIPOP
		ZHA->ZHA_GRUPO  := cGRUPO
		ZHA->ZHA_NIVEL  := ''
		ZHA->ZHA_TEXTO  := ' '
		ZHA->ZHA_TXDT1  := DTOC(dDATA)
		ZHA->ZHA_TXDT2  := dDATA
		ZHA->ZHA_XQTDE  := nSLDINI
		ZHA->ZHA_SALDOE := nSLDINI
		ZHA->( msUnlock() )
		*------10-Saldo Final----------------------------------------------------------------------------------
		RecLock("ZHA",.T.)
		ZHA->ZHA_FILIAL := xFILIAL('ZHA')
		ZHA->ZHA_PERIOD := dPERIOD
		ZHA->ZHA_NUMMRP := cNUMMRP
		ZHA->ZHA_PRODUT := cPRODUT
		ZHA->ZHA_DESC   := cDESC
		ZHA->ZHA_TIPO   := '10-Saldo Final'
		ZHA->ZHA_TIPOP  := cTIPOP
		ZHA->ZHA_GRUPO  := cGRUPO
		ZHA->ZHA_NIVEL  := ''
		ZHA->ZHA_TEXTO  := ' '
		ZHA->ZHA_TXDT1  := DTOC(dDATA)
		ZHA->ZHA_TXDT2  := dDATA
		ZHA->ZHA_XQTDE  := nSLDFIN
		ZHA->ZHA_SALDO  := nSLDFIN
		ZHA->( msUnlock() )
		*------01-Necessidade----------------------------------------------------------------------------------
		RecLock("ZHA",.T.)
		ZHA->ZHA_FILIAL := xFILIAL('ZHA')
		ZHA->ZHA_PERIOD := dPERIOD
		ZHA->ZHA_NUMMRP := cNUMMRP
		ZHA->ZHA_PRODUT := cPRODUT
		ZHA->ZHA_DESC   := cDESC
		ZHA->ZHA_TIPO   := '01-Necessidade'
		ZHA->ZHA_TIPOP  := cTIPOP
		ZHA->ZHA_GRUPO  := cGRUPO
		ZHA->ZHA_NIVEL  := ''
		ZHA->ZHA_TEXTO  := ' '
		ZHA->ZHA_TXDT1  := DTOC(dDATA)
		ZHA->ZHA_TXDT2  := dDATA
		ZHA->ZHA_XQTDE  := nNECE
		ZHA->ZHA_NEC    := nNECE
		IF nNECE>0
			cIDMRP     := Soma1(cIDMRP,7,.T.,.T.)
			ZHA->ZHA_IDMRP  := cIDMRP
		ENDIF
		ZHA->( msUnlock() )
		*--------------------------------------------------------------------------------------
		//TRB->(DBSKIP())
	ENDDO

	TRB->(DbCloseArea())

//UPDATE ZHA010 SET ZHA_PERIOD ='20181113'  WHERE ZHA_PERIOD <'20181113'
//?update ZHA010 SET ZHA_TXDT1='13/11/2018', ZHA_TXDT2='20181113'  WHERE  ZHA_PERIOD ='20181113'
//UPDATE ZHA010 SET ZHA_PERIOD ='20181126',ZHA_TXDT1='26/11/2018', ZHA_TXDT2='20181126'  WHERE ZHA_PERIOD <'20181126'
//------------------------------------------------------------------------------------------------------
	cData     := DtoC(Date())
	cAssunto  := "MRP V2  Fim MRP - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
	cTexto    := "MRP V2  Fim MRP - Date " + cData + "  Time: " + Time()
	cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br;paulo.celestino@rdt.com.br"
	cCC       := ""
	cArquivo  := ""

	U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
//------------------------------------------------------------------------------------------------------
	//ZZ7 FIM

	ZZ7->(dbSelectArea("ZZ7"))
	ZZ7->(DBSETORDER(1))
	ZZ7->(DbSeek(xFilial("ZZ7")+_cCODMRP))
	IF ZZ7->(FOUND())
	   _cHRINI:=ZZ7->ZZ7_HRINI
	   Reclock("ZZ7",.F.)
	   ZZ7->ZZ7_DTFIM  	:=DATE()
	   ZZ7->ZZ7_HRFIM	:=TIME()
	   ZZ7->ZZ7_HORAS   :=cValtoChar(SubHoras(time(),_cHRINI)) //SubHoras(time(),"13:59:45")
	   ZZ7->ZZ7_HIST    :='FIM FILIAL 01'
	   ZZ7->(MsUnlock())
	ENDIF   

    _cdata1 :=dtos(dDatabase)
	_cdata2 :=SUBSTR(_cdata1,7,2)+'/'+SUBSTR(_cdata1,5,2)+'/'+SUBSTR(_cdata1,1,4)
//UPDATE ZHA010 SET ZHA_PERIOD ='20181217',ZHA_TXDT1='17/12/2018', ZHA_TXDT2='20181217'  WHERE ZHA_PERIOD <'20181217'
	cQRYFIM :="UPDATE ZHA010 SET ZHA_PERIOD ='"+_cdata1+"',ZHA_TXDT1='"+_cdata2+"', ZHA_TXDT2='"+_cdata1+"'  WHERE ZHA_PERIOD <'"+_cdata1+"' "
	TCSQLEXEC(cQRYFIM)
	MSGALERT('FIM')

RETURN

	*----------------------------------------------------------------------------------------------------*
STATIC FUNCTION MRP02SC4(_nC4REC)  // PESQUISA PREVISAO DE VENDA SC4
	*----------------------------------------------------------------------------------------------------*


	_cTXTSC4:=SPACE(20)
	_cSC4COD:=SPACE(06)

	cQRSC4 := " SELECT C4_XXPRI,C4_PRODUTO,C4_XXCOD,C4_DATA,C4_OBS,C4_QUANT,C4_XXNOMCL FROM SC4010 WHERE C4_FILIAL='"+xFILIAL('SC4')+"' AND  D_E_L_E_T_='' AND R_E_C_N_O_ ="+alltrim(str(_nC4REC))+" "
	TcQuery cQRSC4 Alias "TRSC4" New
//("TRSC4")->(DbGoTop())
	If TRSC4->(Eof())
		_cTXTSC4:=''
		_cSC4COD:=''
	ELSE
		_cPRI:=''
		DO CASE
		CASE alltrim(TRSC4->C4_XXPRI)=='W'
			_cPRI:='WON '
		CASE alltrim(TRSC4->C4_XXPRI)=='B'
			_cPRI:='BEST'
		CASE alltrim(TRSC4->C4_XXPRI)=='I'
			_cPRI:='IN  '
		ENDCASE

		_cTXTSC4:=_cPRI+' '+alltrim(TRSC4->C4_PRODUTO)+' Cod:'+alltrim(TRSC4->C4_XXCOD)+' Qtd:'+ alltrim(Transform(TRSC4->C4_QUANT,"@e 99,999.99"))+' Obs:'+alltrim(TRSC4->C4_OBS)+ ' '+alltrim(TRSC4->C4_XXNOMCL)+space(120)//+' QTD:'+Transform(TRSC4->C4_QUANT,"@e 99,999.99")STR(TRSC4->C4_QUANT)//mls
		_cTXTSC4:=substr(_cTXTSC4,1,119)
		_cSC4COD:=TRSC4->C4_XXCOD
	ENDIF

	TRSC4->(DbCloseArea())

RETURN



// Programa...: GravaSX1
// Autor......: Robert Koch
// Data.......: 13/02/2002
// Cliente....: Generico
// Descricao..: Atualiza respostas das perguntas no SX1
//
// Historico de alteracoes:
// 01/09/2005 - Robert - Ajustes para trabalhar com profile de usuario (versao 8.11)
// 16/02/2006 - Robert - Melhorias gerais
// 12/12/2006 - Robert - Sempre grava numerico no X1_PRESEL
// 11/09/2007 - Robert - Parametros tipo 'combo' podem receber informacao numerica ou caracter.
//                     - Testa existencia da variavel __cUserId
// 02/04/2008 - Robert - Mostra mensagem quando tipo de dados for incompativel.
//                     - Melhoria geral nas mensagens.
// 03/06/2009 - Robert - Tratamento para aumento de tamanho do X1_GRUPO no Protheus10
// 26/01/2010 - Robert - Chamadas da msgalert trocadas por msgalert.
// 29/07/2010 - Robert - Soh trabalhava com profile de usuario na versao 8.
//

// --------------------------------------------------------------------------
// Parametros:
// 1 - Grupo de perguntas a atualizar
// 2 - Codigo (ordem) da pergunta
// 3 - Dado a ser gravado
user function GravaSX1 (_sGrupo, _sPerg, _xValor)
	local _aAreaAnt := getarea ()
	local _sUserName := ""
	local _sMemoProf := ""
	local _nTamanho := 0
	local _nLinha    := 0
	local _aLinhas   := {}
	local _lContinua := .T.

	// Na versao Protheus10 o tamanho das perguntas aumentou.
	_sGrupo = padr (_sGrupo, len (sx1 -> x1_grupo), " ")

	if _lContinua
		if ! sx1 -> (dbseek (_sGrupo + _sPerg, .F.))
			msgalert ("Programa " + procname () + ": grupo/pergunta '" + _sGrupo + "/" + _sPerg + "' nao encontrado no arquivo SX1." + _PCham ())
			_lContinua = .F.
		endif
	endif

	if _lContinua
		// Atualizarei sempre no SX1. Depois vou ver se tem profile de usuario.
		do case
		case sx1 -> x1_gsc == "C"
			reclock ("SX1", .F.)
			sx1 -> x1_presel = val (cvaltochar (_xValor))
			sx1 -> x1_cnt01 = ""
			sx1 -> (msunlock ())
		case sx1 -> x1_gsc == "G"
			if valtype (_xValor) != sx1 -> x1_tipo
				msgalert ("Programa " + procname () + ": incompatibilidade de tipos: o parametro '" + _sPerg + "' do grupo de perguntas '" + _sGrupo + "' eh do tipo '" + sx1 -> x1_tipo + "', mas o valor recebido eh do tipo '" + valtype (_xValor) + "'." + _PCham ())
				_lContinua = .F.
			else
				reclock ("SX1", .F.)
				sx1 -> x1_presel = 0
				if sx1 -> x1_tipo == "D"
					sx1 -> x1_cnt01 = "'" + dtoc (_xValor) + "'"
				elseif sx1 -> x1_tipo == "N"
					sx1 -> x1_cnt01 = str (_xValor, sx1 -> x1_tamanho, sx1 -> x1_decimal)
				elseif sx1 -> x1_tipo == "C"
					sx1 -> x1_cnt01 = _xValor
				endif
				sx1 -> (msunlock ())
			endif
		otherwise
			msgalert ("Programa " + procname () + ": tratamento para X1_GSC = '" + sx1 -> x1_gsc + "' ainda nao implementado." + _PCham ())
			_lContinua = .F.
		endcase
	endif

	if _lContinua

		// Antes da versao 8.11 nao havia profile de usuario (para o P10 ainda nao testei).
		//if "MP8.11" $ cVersao .and. type ("__cUserId") == "C" .and. ! empty (__cUserId)
		if type ("__cUserId") == "C" .and. ! empty (__cUserId)
			psworder (1) // Ordena arquivo de senhas por ID do usuario
			PswSeek(__cUserID) // Pesquisa usuario corrente
			_sUserName := PswRet(1) [1, 2]

			// Encontra e atualiza profile deste usuario para a rotina / pergunta atual.
			// Enquanto o usuario nao alterar nenhuma pergunta, ficarah usando do SX1 e
			// seu profile nao serah criado.
			If FindProfDef (_sUserName, _sGrupo, "PERGUNTE", "MV_PAR")

				// Carrega memo com o profile do usuario (o profile fica gravado
				// em um campo memo)
				_sMemoProf := RetProfDef (_sUserName, _sGrupo, "PERGUNTE", "MV_PAR")

				// Monta array com as linhas do memo (tem uma pergunta por linha)
				_aLinhas = {}
				for _nLinha = 1 to MLCount (_sMemoProf)
					aadd (_aLinhas, alltrim (MemoLine (_sMemoProf,, _nLinha)) + chr (13) + chr (10))
				next

				// Monta uma linha com o novo conteudo do parametro atual.
				// Pos 1 = tipo (numerico/data/caracter...)
				// Pos 2 = '#'
				// Pos 3 = GSC
				// Pos 4 = '#'
				// Pos 5 em diante = conteudo.
				_sLinha = sx1 -> x1_tipo + "#" + sx1 -> x1_gsc + "#" + iif (sx1 -> x1_gsc == "C", cValToChar (sx1 -> x1_presel), sx1 -> x1_cnt01) + chr (13) + chr (10)

				// Se foi passada uma pergunta que nao consta no profile, deve tratar-se
				// de uma pergunta nova, pois jah encontrei-a no SX1. Entao vou criar uma
				// linha para ela na array. Senao, basta regravar na array.
				if val(_sPerg) > len (_aLinhas)
					aadd (_aLinhas, _sLinha)
				else
					// Grava a linha de volta na array de linhas
					_aLinhas [val (_sPerg)] = _sLinha
				endif

				// Remonta memo para gravar no profile
				_sMemoProf = ""
				for _nLinha = 1 to len (_aLinhas)
					_sMemoProf += _aLinhas [_nLinha]
				next

				// Grava o memo no profile
				WriteProfDef(_sUserName, _sGrupo, "PERGUNTE", "MV_PAR", ; // Chave antiga
				_sUserName, _sGrupo, "PERGUNTE", "MV_PAR", ; // Chave nova
				_sMemoProf) // Novo conteudo do memo.
			endif
		endif
	endif

	restarea (_aAreaAnt)
return .T.



// --------------------------------------------------------------------------
static Function _PCham ()
	local _i      := 0
	local _sPilha := chr (13) + chr (10) + chr (13) + chr (10) + "Pilha de chamadas:"
	do while procname (_i) != ""
		_sPilha += chr (13) + chr (10) + procname (_i)
		_i++
	enddo
return _sPilha


	*-----------------------------------*
User Function A710PAR() 
	*-----------------------------------*
	Local _nTipPer  := paramixb[1]
	Local _nQuantPer:= paramixb[2]
	Local _a711Tipo := paramixb[3]
	Local _a711Grupo:= paramixb[4]
	Local _lPedido  := paramixb[5]
	Local aRet      := {}


	IF lMRPSI ==.T. // SE MRP SIMULACAO
		U_MRP02IN3()    // MLS  ?? SIMULACAO
	ELSE
	    IF lMRFl2==.T.
		   U_MRP02INF() //FILIAL 02
		   ELSE
		   U_MRP02INI() //FILIAL 01
		ENDIF 
	ENDIF

	_nTipPer   := 1      //TIPO PERIODO
	_nQuantPer := 365    //QUANTIDADE PERIODO     365 DIAS
	_lPedido   :=.T.     //CONSIDERA PEDIDO EM CARTEIRA

	aadd(aRet,{_nTipPer ,_nQuantPer,_a711Tipo,_a711Grupo,_lPedido})
Return aRet

	*----------------------------------------------------------------------------------------------------*
User Function MRP02RDM()
	*----------------------------------------------------------------------------------------------------*
//MsAguarde( { || DjoBPAR()    } ,"MRP Domex V2 Acerto Parametros", "Aguarde..." )  
//MsAguarde( { || U_MRP02INI() } ,"Inicio MRP Domex V2", "Aguarde..." )  
	PRIVATE lMRPSI :=.F.
	MATA712()
	U_MRP020()

return

	*----------------------------------------------------------------------------------------------------*
User Function MTA710()     // PERIODOS EM BRANCO NAO GERAR OP E SC
	*----------------------------------------------------------------------------------------------------*
//MSGALERT('MTA710')
	cSelF   := cSelFSC  :=Replicate(" ",Len(aPeriodos))
	cSelPer := cSelPerSC:=Replicate(" ",Len(aPeriodos))
RETURN

	*----------------------------------------------------------------------------------------------------*
User Function MT711VLSC()//<------------------RETORNA .F. NAO GERAR SC
	*----------------------------------------------------------------------------------------------------*
//MSGALERT('MT711VLSC') 
RETURN(.F.)




/*
Local _PARAMIXB1 := .T.  //-- .T. se a rotina roda em batch, sen�o .F.
Local _PARAMIXB2 := {}

1 aAdd(_PARAMIXB2,1)       //-- Tipo de per�odo 1=Di�rio; 2=Semanal; 3=Quinzenal; 4=Mensal; 5=Trimestral; 6=Semestral; 7=Diversos
2 aAdd(_PARAMIXB2,5)      //-- Quantidade de per�odos
3 aAdd(_PARAMIXB2,.T.)     //-- Considera Pedidos em Carteira4
4 aAdd(_PARAMIXB2,nil)      //-- Array contendo Tipos de produtos a serem considerados, se Nil, assume padr�o
5 aAdd(_PARAMIXB2,nil)      //-- Array contendo Grupos de produtos a serem considerados, se Nil, assume padr�o
6 aAdd(_PARAMIXB2,.F.)     //-- Gera/N�o Gera OPs e SCs depois do c�lculo da necessidade.
7 aAdd(_PARAMIXB2,.F.)     //-- Indica se monta log do MRPaAdd(PARAMIXB2,"000001")
8 Add(_PARAMIXB2,"000001")  //-- N�mero da Op Inicial
9  aAdd(_PARAMIXB2,'23/01/2019')  //-- Database para inicio do c�lculo
10 aAdd(_PARAMIXB2,{})      //-- N�meros dos per�odos para gera��o de OPs
11 aAdd(_PARAMIXB2,{})      //-- N�meros dos per�odos para gera��o de SCs
12 aAdd(_PARAMIXB2,.F.)     //-- M�ximo de 99 itens por OP
13 aAdd(_PARAMIXB2,{'23/01/2019'} )      //-- Datas para tipo de per�odo diversos

*/
USER FUNCTION MRPDELF()
	PRIVATE _lCZI :=.F.
	PRIVATE _lCZJ :=.F.
	PRIVATE _lCZK :=.F.

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" USER 'MRP' PASSWORD 'MRP' Tables "SB1" Modulo "PCP"

	TCLink()
	IF TCDelFile( "CZI010" ) == .T.
		_lCZI:=.T.
	ENDIF
	IF TCDelFile( "CZJ010" ) == .T.
		_lCZJ:=.T.
	ENDIF
	IF TCDelFile( "CZK010" ) == .T.
		_lCZK:=.T.
	ENDIF
	TCUnlink()
	cData     := DtoC(Date())
	cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br"
	cCC       := ""
	cArquivo  := ""
	IF _lCZI==.T. .AND. _lCZJ==.T. .AND.  _lCZK==.T.
		cAssunto  := "MRP V2 Deletado Tabelas (CZI,CZJ,CZK) - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
		cTexto    := "MRP V2 Deletado Tabelas  (CZI,CZJ,CZK)- Date " + cData + "  Time: " + Time()
	ELSE
		cAssunto  := "MRP V2 não foi proosivel deletar tabelas (CZI,CZJ,CZK) - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
		cTexto    := "MRP V2 não foi proosivel deletar tabelas (CZI,CZJ,CZK)- Date " + cData + "  Time: " + Time()
	ENDIF
	U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)

	RESET ENVIRONMENT
RETURN
