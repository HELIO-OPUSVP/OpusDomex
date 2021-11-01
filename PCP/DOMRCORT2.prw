#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"

User Function DOMRCOR2()

Local oReport := ReportDef()
	
	If oReport == Nil
		MsgInfo("*** CANCELADO PELO OPERADOR ***")
	Else
		oReport:PrintDialog()
		Return Nil
	Endif

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Descri��o � Definicao dos Parametros do Relatorio                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �  			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ReportDef()
Local oReport	:= NIL
Local oLinha	:= NIL
Local cAliasRep := GetNextAlias()

Local cAviso	:= "Este programa ira imprimir um Relat�rio de corte por operador"
Local cPar      := ""
Local cPerg   	:= "DOMRCORT02"

AjustaSX1(cPerg)
//Pergunte(cPerg,.T.)


//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//�                                                                        �
//��������������������������������������������������������������������������
oReport := TReport():New(cPerg,"Relat�rio de corte por operador", cPerg, {|oReport| ReportPrint(oReport,@cAliasRep,cPar)}, cAviso)
//oReport:nFontBody := 9
//oReport:SetPortrait
oReport:SetLandscape()
//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������



Pergunte(oReport:uParam,.F.)
//������������������������������������������������������������������������Ŀ
//�Criacao da secao utilizada pelo relatorio                               �
//�                                                                        �
//�TRSection():New                                                         �
//�ExpO1 : Objeto TReport que a secao pertence                             �
//�ExpC2 : Descricao da se�ao                                              �
//�ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   �
//�        sera considerada como principal para a se��o.                   �
//�ExpA4 : Array com as Ordens do relat�rio                                �
//�ExpL5 : Carrega campos do SX3 como celulas                              �
//�        Default : False                                                 �
//�ExpL6 : Carrega ordens do Sindex                                        �
//�        Default : False                                                 �
//��������������������������������������������������������������������������

//��������������������������������������������������������������Ŀ
//� Sessao 1 (oLinha)                                            �
//����������������������������������������������������������������
oLinha := TRSection():New(oReport,"Relat�rio de corte por operador", {cAliasRep})
oLinha:SetTotalInLine(.F.)


//TRCell():New(oLinha	,'PEDIDO'			,cAliasRep	,'Pedido'		 	,/*Picture*/	,06,/*lPixel*/,/*{|| code-block de impressao }*/)	//01

TRCell():New(oLinha, "COD_USER"   , cAliasRep, "C�d.Usuar"		,PesqPict("CB1","CB1_CODOPE"), 10,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha, "COD_USER"   , cAliasRep, "Nome Usuario"	,PesqPict("CB1","CB1_NOME"  ), 30,/*lPixel*/,{|| UsrFullName ( (cAliasRep)->COD_USER ) })
TRCell():New(oLinha, "ETQ"		  	 , cAliasRep, "Etiqueta"		,PesqPict("XD1","XD1_XXPECA"), 15,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha, "EMISSAO"	 , cAliasRep, "Data "			,PesqPict("SD3","D3_EMISSAO"), 12,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha, "OP"		    , cAliasRep, "Ord.Produ��o"	,PesqPict("ZZ4","ZZ4_OP"    ), 15,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha, "PROD"	    , cAliasRep, "Produto"			,PesqPict("ZZ4","ZZ4_PROD"  ), 10,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha, "PROD"	    , cAliasRep, "Descri��o"		,PesqPict("SB1","B1_DESC" 	 ), 30,/*lPixel*/,{|| Posicione ("SB1",1,xFilial("SB1") +(cAliasRep)->PROD ,"B1_DESC" ) })
TRCell():New(oLinha, "QTD_CORTE"  , cAliasRep, "Qtd.Corte"		,PesqPict("SD3","D3_QUANT"  ), 18,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha, "SALDO_ETQ"  , cAliasRep, "Saldo Etiq."	,PesqPict("XD1","XD1_QTDATU"), 18,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha, "HRINI"		 , cAliasRep, "Hr.In�cio"		,PesqPict("SD3","D3_XHRINI"   ), 08,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha, "HRFIM"		 , cAliasRep, "Hr.Fim"			,PesqPict("SD3","D3_HORA"   ), 08,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha, "MINUTOS"	 , cAliasRep, "Segundos"			,/*Picture*/	, 08,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha, "MTRSHR"		 , cAliasRep, "Mtrs./Hora"		,/*Picture*/	, 08,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oLinha, "MTRSMIN"	 , cAliasRep, "Mtrs./Min"		,/*Picture*/	, 08,/*lPixel*/,/*{|| code-block de impressao }*/)


oLinha:SetHeaderPage()  

oLinha:SetHeaderSection(.T.) //Define que imprime cabe�alho das c�lulas na quebra de se��o
oLinha:SetHeaderBreak(.T.)

oBreak := TRBreak():New(oLinha, {|| (cAliasRep)->COD_USER })
oReport:SkipLine()
oReport:ThinLine()       

Return oReport
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrint � Autor �Marcos V. Ferreira   � Data �08/06/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportPrint devera ser criada para todos  ���
���          �os relatorios que poderao ser agendados pelo usuario.       ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relatorio                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR850			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ReportPrint(oReport, cAliasRep,cPar)

Local oLinha	:= oReport:Section(1)
Local oBreak1	:= NIL
Local nOrdem	:= oLinha:GetOrder()
Local cQry    	:= ""
Local oFont1    := TFont():New("Courier New",,020,,.F.,,,,,.F.,.F.)

//��������������������������������������������������������������Ŀ
//� Acerta o titulo do relatorio                                 �
//����������������������������������������������������������������
oReport:SetTitle(oReport:Title())


//������������������������������������������������������������������������Ŀ
//�Transforma parametros Range em expressao SQL                            �
//��������������������������������������������������������������������������
MakeSqlExpr(oReport:uParam)

//������������������������������������������������������������������������Ŀ
//�Inicio do Embedded SQL                                                  �
//��������������������������������������������������������������������������

//NA TUALIZACAO DE 06/11/2021 ESTAVA FALTA DATEDIFF DA LINHA 173 JONAS
BeginSql Alias cAliasRep

SELECT 
 ZZ4_USER	AS COD_USER,
 D3_XXPECA	AS ETQ,
 CONVERT(CHAR,CONVERT(DATETIME,D3_EMISSAO),103) AS EMISSAO,
 ZZ4_OP		AS OP,
 ZZ4_PROD	AS PROD,
 SUM(D3_QUANT)	AS QTD_CORTE,
 XD1_QTDATU	AS SALDO_ETQ, 
   D3_XHRINI HRINI
 ,D3_HORA HRFIM ,
 
CASE WHEN (SELECT B1_XKITPIG FROM  %table:SC2% SC2
 INNER JOIN  %table:SB1% SB1 ON B1_FILIAL = %Exp:xFilial("SB1")% AND B1_COD = C2_PRODUTO AND SB1.%NotDel% 
 WHERE C2_FILIAL = %Exp:xFilial("SC2")%
 AND C2_NUM+C2_ITEM+C2_SEQUEN = ZZ4_OP
 AND SC2.%NotDel%) <> ''
 THEN
 (CASE WHEN D3_XHRINI < D3_HORA THEN (DATEDIFF(SS, D3_XHRINI,D3_HORA)/12) ELSE 0 END )
ELSE
(CASE WHEN D3_XHRINI < D3_HORA THEN (DATEDIFF(SS, D3_XHRINI,D3_HORA)) ELSE 0 END  )
END AS MINUTOS,

CASE WHEN (SELECT B1_XKITPIG FROM  %table:SC2% SC2
 INNER JOIN  %table:SB1% SB1 ON B1_FILIAL = %Exp:xFilial("SB1")% AND B1_COD = C2_PRODUTO AND SB1.%NotDel% 
 WHERE C2_FILIAL = %Exp:xFilial("SC2")%
 AND C2_NUM+C2_ITEM+C2_SEQUEN = ZZ4_OP
 AND SC2.%NotDel%) <> ''
 THEN
 (CASE WHEN D3_XHRINI < D3_HORA THEN ROUND((SUM(D3_QUANT)/(DATEDIFF(SS, D3_XHRINI,D3_HORA)/12))*60,2) ELSE 0 END)
ELSE
(CASE WHEN D3_XHRINI < D3_HORA THEN ROUND(SUM(D3_QUANT)/(DATEDIFF(MI, D3_XHRINI,D3_HORA)),4 ) ELSE 0 END )
END AS [MTRSMIN],


CASE WHEN (SELECT B1_XKITPIG FROM  %table:SC2% SC2
 INNER JOIN  %table:SB1% SB1 ON B1_FILIAL = %Exp:xFilial("SB1")% AND B1_COD = C2_PRODUTO AND SB1.%NotDel% 
 WHERE C2_FILIAL = %Exp:xFilial("SC2")%
 AND C2_NUM+C2_ITEM+C2_SEQUEN = ZZ4_OP
 AND SC2.%NotDel%) <> ''
 THEN
(CASE WHEN D3_XHRINI < D3_HORA THEN ROUND(((SUM(D3_QUANT)/(DATEDIFF(SS, D3_XHRINI,D3_HORA)/12))*60)*60,2) ELSE 0 END)
 ELSE
 (CASE WHEN D3_XHRINI < D3_HORA THEN (ROUND(SUM(D3_QUANT)/(DATEDIFF(MI, D3_XHRINI,D3_HORA)),4)*60)ELSE 0 END)
 END AS [MTRSHR]
 

 FROM %table:ZZ4% ZZ4
 INNER JOIN %table:SD3%  SD3
 		 ON D3_FILIAL = %Exp:xFilial("SD3")%
 		AND D3_XXOP = ZZ4_OP
 		AND D3_COD = ZZ4_PROD
 		AND D3_GRUPO IN ('FO','FOFS')
 		AND D3_TM = '999'
 		AND SD3.%NotDel%
 		AND D3_ESTORNO = ''
 		AND (SUBSTRING(D3_USERLGI, 11, 1) + SUBSTRING(D3_USERLGI, 15, 1) +
          SUBSTRING(D3_USERLGI, 2, 1) + SUBSTRING(D3_USERLGI, 6, 1) +
          SUBSTRING(D3_USERLGI, 10, 1) + SUBSTRING(D3_USERLGI, 14, 1) +
          SUBSTRING(D3_USERLGI, 1, 1) + SUBSTRING(D3_USERLGI, 5, 1) +
          SUBSTRING(D3_USERLGI, 9, 1) + SUBSTRING(D3_USERLGI, 13, 1) +
          SUBSTRING(D3_USERLGI, 17, 1) + SUBSTRING(D3_USERLGI, 4, 1) +
          SUBSTRING(D3_USERLGI, 8, 1) )= ZZ4_USER
 		 AND D3_EMISSAO BETWEEN %Exp:DToS(MV_PAR03)% AND %Exp:DToS(MV_PAR04)%
 		 AND D3_XXPECA BETWEEN %Exp:MV_PAR09% AND %Exp:MV_PAR10%
 LEFT JOIN %table:XD1% XD1
 			ON XD1_FILIAL = %Exp:xFilial("XD1")%
 			AND XD1_XXPECA = D3_XXPECA
 			AND XD1.%NotDel%
 WHERE ZZ4_FILIAL = %Exp:xFilial("ZZ4")%
 AND ZZ4_QTDUSR > 0
 AND ZZ4.%NotDel%
 AND ZZ4_PROD BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
 AND ZZ4_OP BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
 AND ZZ4_USER BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
 GROUP BY D3_XXPECA,ZZ4_USER,D3_EMISSAO,ZZ4_OP, ZZ4_PROD	,ZZ4_QTDMTR,XD1_QTDATU,D3_XHRINI,D3_HORA 
 ORDER BY 1,3,4,5
//TcSetField(cAliasPL,"QTD_CORTE","N",TamSx3("D3_QUANT" )[1],TamSx3("D3_QUANT" )[2])
//TcSetField(cAliasPL,"SALDO_ETQ","N",TamSx3("XD1_QTDATU" )[1],TamSx3("XD1_QTDATU" )[2])

EndSql

oReport:Section(1):EndQuery()

//��������������������������������������������������������������Ŀ
//� Abertura do arquivo de trabalho                              |
//����������������������������������������������������������������
dbSelectArea(cAliasRep)

oLinha:SetLineCondition({|| .T.})

//�����������������������Ŀ
//�Impressao do Relatorio �
//�������������������������
oLinha:Print()
Return Nil


/*/{Protheus.doc} AjustaSX1
@author Ricardo Roda
@since 12/09/2019
@version undefined
/*/
Static Function AjustaSX1(cPerg)

DbSelectArea("SX1")
DbSetOrder(1)
aRegs :={}
aAdd(aRegs, {cPerg, "01", "Produto De  ?",     "", "", "mv_ch1", "C",15, 0, 0, "G", "", "MV_PAR01", ""     , "" , "" , "" , "", "" , "", "", "", "", ""       , "", "", "", "", ""    , "", "", "", "", "", "", "", "", "SB1", "" , "", "","","",""})
aAdd(aRegs, {cPerg, "02", "Produto Ate ?",     "", "", "mv_ch2", "C",15, 0, 0, "G", "", "MV_PAR02", ""     , "" , "" , "" , "", "" , "", "", "", "", ""       , "", "", "", "", ""    , "", "", "", "", "", "", "", "", "SB1", "" , "", "","","",""})

aAdd(aRegs, {cPerg, "03", "Data De  ?",        "", "", "mv_ch3", "D",10, 0, 0, "G", "", "MV_PAR03", ""     , "" , "" , "" , "", "" , "", "", "", "", ""       , "", "", "", "", ""    , "", "", "", "", "", "", "", "", ""   , "" , "", "","","",""})
aAdd(aRegs, {cPerg, "04", "Data Ate ?",        "", "", "mv_ch4", "D",10, 0, 0, "G", "", "MV_PAR04", ""     , "" , "" , "" , "", "" , "", "", "", "", ""       , "", "", "", "", ""    , "", "", "", "", "", "", "", "", ""   , "" , "", "","","",""})

aAdd(aRegs, {cPerg, "05", "OP De  ?",          "", "", "mv_ch5", "C",11, 0, 0, "G", "", "MV_PAR05", ""     , "" , "" , "" , "", "" , "", "", "", "", ""       , "", "", "", "", ""    , "", "", "", "", "", "", "", "", "SC2", "" , "", "","","",""})
aAdd(aRegs, {cPerg, "06", "OP Ate ?",          "", "", "mv_ch6", "C",11, 0, 0, "G", "", "MV_PAR06", ""     , "" , "" , "" , "", "" , "", "", "", "", ""       , "", "", "", "", ""    , "", "", "", "", "", "", "", "", "SC2", "" , "", "","","",""})

aAdd(aRegs, {cPerg, "07", "Operador De  ?",    "", "", "mv_ch7", "C",06, 0, 0, "G", "", "MV_PAR07", ""     , "" , "" , "" , "", "" , "", "", "", "", ""       , "", "", "", "", ""    , "", "", "", "", "", "", "", "", ""   , "" , "", "","","",""})
aAdd(aRegs, {cPerg, "08", "Operador Ate ?",    "", "", "mv_ch8", "C",06, 0, 0, "G", "", "MV_PAR08", ""     , "" , "" , "" , "", "" , "", "", "", "", ""       , "", "", "", "", ""    , "", "", "", "", "", "", "", "", ""   , "" , "", "","","",""})

aAdd(aRegs, {cPerg, "09", "Etiqueta De  ?",    "", "", "mv_ch9", "C",13, 0, 0, "G", "", "MV_PAR09", ""     , "" , "" , "" , "", "" , "", "", "", "", ""       , "", "", "", "", ""    , "", "", "", "", "", "", "", "", ""   , "" , "", "","","",""})
aAdd(aRegs, {cPerg, "10", "Etiqueta Ate ?",    "", "", "mv_chA", "C",13, 0, 0, "G", "", "MV_PAR10", ""     , "" , "" , "" , "", "" , "", "", "", "", ""       , "", "", "", "", ""    , "", "", "", "", "", "", "", "", ""   , "" , "", "","","",""})

//aAdd(aRegs, {cPerg, "03", "Ordena/Quebra por", "", "", "mv_ch3", "N",03, 0, 0, "C", "", "MV_PAR11","Iguais", "" , "" , "" , "", "Diferente" , "", "", "", "", "Ambos" 		 , "", "", "", "", ""	 , "", "", "", "", "", "", "", "", ""   , "" , "", "","",""})
fAjuSx1(cPerg,aRegs)

Return

/*/{Protheus.doc} fAjuSx1
@author Ricardo Roda
@since 12/09/2019
@version undefined
/*/
Static Function fAjuSx1(cPerg,aRegs)

Local _nTamX1, _nTamPe, _nTamDf := 0

DbSelectArea("SX1")
DbSetOrder(1)

// Indo ao Primeiro Registro do SX1, apenas para descobrir o tamanho do campo com o nome da PERGUNTA
// Campo chamado X1_GRUPO
DbGoTop()
_nTamX1	:= Len(SX1->X1_GRUPO)
_nTamPe	:= Len(Alltrim(cPerg))
_nTamDf	:= _nTamX1 - _nTamPe

// Adequando o Tamanho para Efetuar a Pesquisa no SX1
If _nTamDf > 0
	cPerg := cPerg + Space(_nTamDf)
ElseIf _nTamDf == 0
	cPerg := cPerg
Else
	Return()
EndIf

// Criando Perguntas caso NAO existam no SX1
For i:=1 to Len(aRegs)
	
	If !DbSeek(cPerg+aRegs[i,2])
		
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
		
		DbCommit()
	Endif
Next

Return()
