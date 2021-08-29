#Include "domX140.CH"
#INCLUDE "PROTHEUS.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � domr140  � Autor � Alexandre Inacio Lemes� Data �11/07/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emissao das Solicitacoes de Compras                        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � domr140(void)                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
user Function domr140( cAlias, nReg )

Local oReport

PRIVATE lAuto     := (nReg!=Nil) 

//�����������������������������������������������������������������Ŀ
//� Funcao utilizada para verificar a ultima versao dos fontes      �
//� SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |
//| nestes fontes. NAO REMOVER !!!							        �
//�������������������������������������������������������������������
IF !(FindFunction("SIGACUS_V") .and. SIGACUS_V() >= 20050512)
    Final(STR0046) //"Atualizar SIGACUS.PRW !!!"
Endif
IF !(FindFunction("SIGACUSA_V") .and. SIGACUSA_V() >= 20050512)
    Final(STR0047) //"Atualizar SIGACUSA.PRX !!!"
Endif
IF !(FindFunction("SIGACUSB_V") .and. SIGACUSB_V() >= 20050512)
    Final(STR0048) //"Atualizar SIGACUSB.PRX !!!"
Endif

If FindFunction("TRepInUse") .And. TRepInUse()
	//������������������������������������������������������������������������Ŀ
	//�Interface de impressao                                                  �
	//��������������������������������������������������������������������������
	oReport:= ReportDef(nReg)
	oReport:PrintDialog()
Else
	domr140R3( cAlias, nReg )
EndIf
                                               
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � ReportDef�Autor  �Alexandre Inacio Lemes �Data  �11/07/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emissao das Solicitacoes de Compras                        ���
�������������������������������������������������������������������������Ĵ��
���Parametros� nExp01: nReg = Registro posicionado do SC1 apartir Browse  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � oExpO1: Objeto do relatorio                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef(nReg)

Local oReport 
Local oSection1 
Local oCell         
Local oBreak
Local cTitle := STR0002 //"Solicitacao de Compra"

#IFDEF TOP
	Local cAliasSC1 := Iif(lAuto,"SC1",GetNextAlias())
#ELSE
	Local cAliasSC1 := "SC1"
#ENDIF

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01    Do Numero                                        �
//� mv_par02    Ate o Numero                                     �
//� mv_par03    Todas ou em Aberto                               �
//� mv_par04    A Partir da data de emissao                      �
//� mv_par05    Ate a data de emissao                            �
//� mv_par06    Do Item                                          �
//� mv_par07    Ate o Item                                       �
//� mv_par08    Campo Descricao do Produto.                      �
//� mv_par09    Imprime Empenhos ?                               �
//� mv_par10    Utiliza Amarracao ?  Produto   Grupo             �
//� mv_par11    Imprime Qtos Pedido Compra?                      �
//� mv_par12    Imprime Qtos Fornecedores?                       �
//� mv_par13    Impr. SC's Firmes, Previstas ou Ambas            �
//����������������������������������������������������������������
Pergunte("MTR140",.F.)
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
oReport := TReport():New("MTR140",cTitle,If(lAuto,Nil,"MTR140"), {|oReport| ReportPrint(oReport,cAliasSC1,nReg)},STR0001) //"Emissao das solicitacoes de compras cadastradas"
oReport:SetLandscape() 
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
//�                                                                        �
//��������������������������������������������������������������������������
//������������������������������������������������������������������������Ŀ
//�Criacao da celulas da secao do relatorio                                �
//�                                                                        �
//�TRCell():New                                                            �
//�ExpO1 : Objeto TSection que a secao pertence                            �
//�ExpC2 : Nome da celula do relat�rio. O SX3 ser� consultado              �
//�ExpC3 : Nome da tabela de referencia da celula                          �
//�ExpC4 : Titulo da celula                                                �
//�        Default : X3Titulo()                                            �
//�ExpC5 : Picture                                                         �
//�        Default : X3_PICTURE                                            �
//�ExpC6 : Tamanho                                                         �
//�        Default : X3_TAMANHO                                            �
//�ExpL7 : Informe se o tamanho esta em pixel                              �
//�        Default : False                                                 �
//�ExpB8 : Bloco de c�digo para impressao.                                 �
//�        Default : ExpC2                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
oSection1:= TRSection():New(oReport,STR0064,{"SC1","SB1","SB2"},/*aOrdem*/)
oSection1:SetHeaderPage()
// oSection1:SetPageBreak(.T.) // Foi usado o EndPage(.T.) pois o SetPageBreak estava saltando uma pagina em branco no inicio da impressao 

TRCell():New(oSection1,"C1_ITEM"   ,"SC1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"C1_PRODUTO","SC1",/*Titulo*/,/*Picture*/,TamSX3("C1_PRODUTO")[1]+10,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"DESCPROD"  ,"   ",STR0049,/*Picture*/,30,/*lPixel*/, {|| cDescPro })
TRCell():New(oSection1,"B2_QATU"   ,"SB2",/*Titulo*/    ,ict("SB2","B2_QATU" ,12),/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"B1EMIN"    ,"   ",STR0050       ,PesqPict("SB1","B1_EMIN" ,12),/*Tamanho*/,/*lPixel*/,{|| RetFldProd(SB1->B1_COD,"B1_EMIN") })
TRCell():New(oSection1,"SALDOSC1"  ,"   ",STR0051       ,PesqPict("SC1","C1_QUANT",12),/*Tamanho*/,/*lPixel*/,{|| (cAliasSC1)->C1_QUANT-(cAliasSC1)->C1_QUJE })
TRCell():New(oSection1,"C1_UM"     ,"SC1",/*Titulo*/    ,PesqPict("SC1","C1_UM"),/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"C1_LOCAL"  ,"SC1",/*Titulo*/    ,PesqPict("SC1","C1_LOCAL"),/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"B1_QE"     ,"SB1",/*Titulo*/    ,PesqPict("SB1","B1_QE",09),/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"B1_UPRC"   ,"SB1",/*Titulo*/    ,PesqPict("SB1","B1_UPRC",12),/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"LEADTIME"  ,"   ",STR0052,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| CalcPrazo((cAliasSC1)->C1_PRODUTO,(cAliasSC1)->C1_QUANT)})
TRCell():New(oSection1,"DTNECESS"  ,"   ",STR0053,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| If(Empty((cAliasSC1)->C1_DATPRF),(cAliasSC1)->C1_EMISSAO,(cAliasSC1)->C1_DATPRF) })
TRCell():New(oSection1,"DTFORCOMP" ,"   ",STR0054,/*Picture*/,/*Tamanho*/,/*lPixel*/,{||SomaPrazo(If(Empty((cAliasSC1)->C1_DATPRF),(cAliasSC1)->C1_EMISSAO,(cAliasSC1)->C1_DATPRF), -CalcPrazo((cAliasSC1)->C1_PRODUTO,(cAliasSC1)->C1_QUANT)) })
oSection1:Cell("DESCPROD"):SetLineBreak() 

oSection2:= TRSection():New(oSection1,STR0065,{"SD4","SC2"},/*aOrdem*/)

TRCell():New(oSection2,"D4_OP"     ,"SD4",STR0055,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"C2_PRODUTO","SC2",STR0056,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"D4_DATA"   ,"SD4",STR0057,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"D4_QUANT"  ,"SD4",STR0058,PesqPict("SD4","D4_QUANT",12),/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

oSection3:= TRSection():New(oSection2,STR0066,{"SB3"},/*aOrdem*/)

TRCell():New(oSection3,"MES01"		,"   ",/*Titulo*/,PesqPict("SB3","B3_Q01",11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"MES02"		,"   ",/*Titulo*/,PesqPict("SB3","B3_Q02",11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"MES03"		,"   ",/*Titulo*/,PesqPict("SB3","B3_Q03",11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"MES04"		,"   ",/*Titulo*/,PesqPict("SB3","B3_Q04",11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"MES05"		,"   ",/*Titulo*/,PesqPict("SB3","B3_Q05",11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"MES06"		,"   ",/*Titulo*/,PesqPict("SB3","B3_Q06",11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"MES07"		,"   ",/*Titulo*/,PesqPict("SB3","B3_Q07",11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"MES08"		,"   ",/*Titulo*/,PesqPict("SB3","B3_Q08",11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"MES09"		,"   ",/*Titulo*/,PesqPict("SB3","B3_Q09",11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"MES10"		,"   ",/*Titulo*/,PesqPict("SB3","B3_Q10",11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"MES11"		,"   ",/*Titulo*/,PesqPict("SB3","B3_Q11",11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"MES12"		,"   ",/*Titulo*/,PesqPict("SB3","B3_Q12",11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"B3_MEDIA"	,"SB3", ,PesqPict("SB3","B3_MEDIA",8),/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"B3_CLASSE"	,"SB3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

oSection4:= TRSection():New(oSection3,STR0067,{"SC7","SA2"},/*aOrdem*/)
TRCell():New(oSection4,"C7_NUM"    ,"SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection4,"C7_ITEM"   ,"SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection4,"C7_FORNECE","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection4,"C7_LOJA"   ,"SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection4,"A2_NOME"   ,"SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection4,"C7_QUANT"  ,"SC7",/*Titulo*/,PesqPict("SC7","C7_QUANT",14),/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection4,"C7_UM"     ,"SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection4,"C7_PRECO"  ,"SC7",/*Titulo*/,PesqPict("SC7","C7_PRECO",14),/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection4,"C7_TOTAL"  ,"SC7",/*Titulo*/,PesqPict("SC7","C7_TOTAL",14),/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection4,"C7_EMISSAO","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection4,"C7_DATPRF" ,"SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection4,"PRAZO"     ,"   ",STR0059,"999",/*Tamanho*/,/*lPixel*/,{|| SC7->C7_DATPRF - SC7->C7_EMISSAO })
TRCell():New(oSection4,"C7_COND"   ,"SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection4,"C7_QUJE"   ,"SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection4,"SALDORES"  ,"   ",STR0060,PesqPict("SC7","C7_QUJE",14),/*Tamanho*/,/*lPixel*/,{|| If(Empty(SC7->C7_RESIDUO),SC7->C7_QUANT - SC7->C7_QUJE,0) })
TRCell():New(oSection4,"RESIDUO"   ,"   ",STR0061,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| If(Empty(SC7->C7_RESIDUO),STR0062,STR0063) })

If mv_par10 == 1	
	oSection5:= TRSection():New(oSection4,STR0068,{"SA5","SA2","SC1"},/*aOrdem*/)
	TRCell():New(oSection5,"A5_FORNECE","SA5",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection5,"A5_LOJA"   ,"SA5",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection5,"A2_NOME"   ,"SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection5,"A2_TEL"    ,"SA2",/*Titulo*/,/*Picture*/,41,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection5,"A2_CONTATO","SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection5,"A2_FAX"    ,"SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection5,"A2_ULTCOM" ,"SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection5,"A2_MUN"    ,"SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection5,"A2_EST"    ,"SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection5,"A2_RISCO"  ,"SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection5,"A5_CODPRF" ,"SA5",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)	
Else	
	oSection5:= TRSection():New(oSection4,STR0069,{"SAD","SA2","SC1"},/*aOrdem*/)
	TRCell():New(oSection5,"AD_FORNECE","SAD",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection5,"AD_LOJA"   ,"SAD",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection5,"A2_NOME"   ,"SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection5,"A2_TEL"    ,"SA2",/*Titulo*/,/*Picture*/,41,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection5,"A2_CONTATO","SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection5,"A2_FAX"    ,"SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection5,"A2_ULTCOM" ,"SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection5,"A2_MUN"    ,"SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection5,"A2_EST"    ,"SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection5,"A2_RISCO"  ,"SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)	
EndIf

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor �Alexandre Inacio Lemes �Data  �11/07/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emissao das Solicitacoes de Compras                        ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relat�rio                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport,cAliasSC1,nReg)

Local oSection1 := oReport:Section(1) 
Local oSection2 := oReport:Section(1):Section(1) 
Local oSection3 := oReport:Section(1):Section(1):Section(1) 
Local oSection4 := oReport:Section(1):Section(1):Section(1):Section(1) 
Local oSection5 := oReport:Section(1):Section(1):Section(1):Section(1):Section(1) 
Local aMeses	:= {STR0005,STR0006,STR0007,STR0008,STR0009,STR0010,STR0011,STR0012,STR0013,STR0014,STR0015,STR0016}		//"Jan"###"Fev"###"Mar"###"Abr"###"Mai"###"Jun"###"Jul"###"Ago"###"Set"###"Out"###"Nov"###"Dez"
Local aOrdem    := {}
Local aSavRec   := {}
Local cMes      := ""
Local cCampos   := ""
Local cEmissao  := ""
Local cGrupo    := ""
Local nX        := 0
Local nY        := 0
Local nRecnoSD4 := 0
Local nAno      := Year(dDataBase)
Local nMes      := Month(dDataBase)
Local nPrinted  := 0
Local nVlrMax   := 0
Local cLmtSol   := ""

#IFDEF TOP
	Local cQuery := ""
    Local cWhere := ""
    Local lQuery := .T. 
#ELSE
	Local cCondicao := ""
    Local lQuery    := .F. 
#ENDIF

If SC1->( FieldPos( "C1_QTDREEM" ) ) > 0
	nVlrMax := val(Replicate('9',TamSX3("C1_QTDREEM")[1]))//Valor maximo para reemissao
EndIf

Private cDescPro := ""

dbSelectArea("SC1")
dbSetOrder(1)

If lAuto
	dbGoto(nReg)
	mv_par01  := SC1->C1_NUM
	mv_par02  := SC1->C1_NUM
	mv_par03  := 1
	mv_par04  := SC1->C1_EMISSAO
	mv_par05  := SC1->C1_EMISSAO
	mv_par06  := "  "
	mv_par07  := "ZZ"
	mv_par09  := 1
	mv_par13  := 3
Else

	#IFDEF TOP
		
	 	MakeSqlExpr(oReport:uParam)
	    
	 	oReport:Section(1):BeginQuery()	
	
		cWhere := "%" 
		If mv_par03 == 2
			cWhere += " C1_QUANT <> C1_QUJE AND "
	    EndIf
		cWhere += "%" 
	
		BeginSql Alias cAliasSC1
		 
			SELECT SC1.*, SC1.R_E_C_N_O_ SC1RECNO
	   		  FROM %table:SC1% SC1
			 WHERE C1_FILIAL  = %xFilial:SC1% AND 
	   			   C1_NUM      >= %Exp:mv_par01% AND 
	 		       C1_NUM      <= %Exp:mv_par02% AND      
		           C1_EMISSAO  >= %Exp:Dtos(mv_par04)% AND 
		           C1_EMISSAO  <= %Exp:Dtos(mv_par05)% AND 
		           C1_ITEM     >= %Exp:mv_par06% AND 
		           C1_ITEM     <= %Exp:mv_par07% AND          
		           %Exp:cWhere%	    
		           SC1.%NotDel% 
			ORDER BY %Order:SC1% 
		EndSql
		
		oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
	
	#ELSE

		MakeAdvplExpr(oReport:uParam)
	
		cCondicao := 'C1_FILIAL=="'       + xFilial("SC1") + '".And.'
		cCondicao += 'C1_NUM>="'          + mv_par01       + '".And.C1_NUM<="'          + mv_par02 + '".And.'
		cCondicao += 'C1_ITEM>="'         + mv_par06       + '".And.C1_ITEM<="'         + mv_par07 + '".And.'
		cCondicao += 'DTOS(C1_EMISSAO)>="'+ Dtos(mv_par04) +'".And.DTOS(C1_EMISSAO)<="' + Dtos(mv_par05) + '"'
		
		If mv_par03 == 2
			cCondicao += '.And. C1_QUANT <> C1_QUJE ' 
	    EndIf
					
		oReport:Section(1):SetFilter(cCondicao,IndexKey())
	
	#ENDIF		
	
EndIf
	
TRPosition():New(oSection1,"SB1",1,{ || xFilial("SB1") + (cAliasSC1)->C1_PRODUTO })
TRPosition():New(oSection1,"SB2",1,{ || xFilial("SB2") + (cAliasSC1)->C1_PRODUTO + (cAliasSC1)->C1_LOCAL })
TRPosition():New(oSection1,"SB3",1,{ || xFilial("SB3") + (cAliasSC1)->C1_PRODUTO })
TRPosition():New(oSection3,"SB3",1,{ || xFilial("SB3") + (cAliasSC1)->C1_PRODUTO })
TRPosition():New(oSection1,"SD4",1,{ || xFilial("SD4") + (cAliasSC1)->C1_PRODUTO })
TRPosition():New(oSection1,"SC7",1,{ || xFilial("SC7") + (cAliasSC1)->C1_NUM + (cAliasSC1)->C1_ITEM })
TRPosition():New(oSection2,"SC2",1,{ || xFilial("SC2") + SD4->D4_OP })
TRPosition():New(oSection4,"SA2",1,{ || xFilial("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA })
 
//�����������������������������������������������������������������������������������������Ŀ
//� Executa o CodeBlock com o PrintLine da Sessao 1 toda vez que rodar o oSection1:Init()   �
//�������������������������������������������������������������������������������������������
oReport:onPageBreak( { || oReport:SkipLine(), oSection1:PrintLine(), oReport:SkipLine(), oReport:ThinLine() })
		
oReport:SetMeter(SC1->(LastRec()))
dbSelectArea(cAliasSC1)               

While !oReport:Cancel() .And. !(cAliasSC1)->(Eof()) .And. (cAliasSC1)->C1_FILIAL == xFilial("SC1") .And. ;
								(cAliasSC1)->C1_NUM >= mv_par01 .And. (cAliasSC1)->C1_NUM <= mv_par02

	oReport:IncMeter()

	If oReport:Cancel()
		Exit
	EndIf

	//������������������������������������������������������������Ŀ
	//� Filtra Tipo de OPs Firmes ou Previstas                     �
	//��������������������������������������������������������������
	If !MtrAValOP(mv_par13,"SC1",cAliasSC1 )
		dbSkip()
		Loop
	EndIf

	//������������������������������������������������������������Ŀ
	//� Obtem a string do titulo conforme a SC impressa.           �
	//� "Solicitacao de Compra  C.Custo :   a.Emissao"	           �
	//��������������������������������������������������������������
    cEmissao := IIf((cAliasSC1)->C1_QTDREEM > 0 , Str(If((cAliasSC1)->C1_QTDREEM < nVlrMax,(cAliasSC1)->C1_QTDREEM + 1,(cAliasSC1)->C1_QTDREEM) ,2) + STR0045 , " " )//"a.Emissao 
	oReport:SetTitle(STR0002+"     "+STR0043+" "+Substr((cAliasSC1)->C1_NUM,1,6)+" "+STR0018+" "+(cAliasSC1)->C1_CC+Space(20)+cEmissao )

	//������������������������������������������������������������Ŀ
	//� Inicializa o descricao do Produto conf. parametro digitado.�
	//��������������������������������������������������������������
	SB1->(dbSetOrder(1))
	SB1->(dbSeek( xFilial("SB1") + (cAliasSC1)->C1_PRODUTO ))
	cDescPro := SB1->B1_DESC
	cGrupo   := SB1->B1_GRUPO

	If AllTrim(mv_par08) == "C1_DESCRI"    // Impressao da Descricao do produto do arquivo de Solicitacao SC1.
		cDescPro := (cAliasSC1)->C1_DESCRI           
	ElseIf AllTrim(mv_par08) == "B5_CEME"  // Descricao cientifica do Produto.
		SB5->(dbSetOrder(1))
		If SB5->(dbSeek( xFilial("SB5") + (cAliasSC1)->C1_PRODUTO ))
			cDescPro := SB5->B5_CEME
		EndIf
	EndIf

	//��������������������������������������������������������������Ŀ
	//� Dispara o codeBrock do OnPageBreak com o PrintLine           �
	//����������������������������������������������������������������
	oSection1:Init()

	//��������������������������������������������������������������Ŀ
	//� Impressao das observacoes da solicitacao (caso exista)       �
	//����������������������������������������������������������������
	If !Empty((cAliasSC1)->C1_OBS)
		oReport:PrintText(STR0019,,oSection1:Cell("C1_ITEM"):ColPos()) // "OBSERVACOES:"

		For nX := 1 To 258 Step 129
			oReport:PrintText(Substr((cAliasSC1)->C1_OBS,nX,129),,oSection1:Cell("C1_ITEM"):ColPos()) // "OBSERVACOES:"
			If Empty(Substr((cAliasSC1)->C1_OBS,nX+129,129))
				Exit
			Endif
		Next nX

		oReport:ThinLine()

	Endif
    
	//��������������������������������������������������������������Ŀ
	//� Impressao da requisicoes empenhadas                          �
	//����������������������������������������������������������������
	If mv_par09 == 1
	    oReport:SkipLine() 
		oReport:PrintText(STR0020,,oSection1:Cell("C1_ITEM"):ColPos()) //"REQUISICOES EMPENHADAS:"

		dbSelectArea("SD4")
		If !Eof()

			oSection2:Init()

			While !Eof() .And. SD4->D4_FILIAL + SD4->D4_COD == (cAliasSC1)->C1_FILIAL + (cAliasSC1)->C1_PRODUTO

				nRecnoSD4 := SD4->(Recno())
				If SD4->D4_QUANT <> 0
					oSection2:PrintLine()		    
                EndIf   
				SD4->(dbGoTo(nRecnoSD4))
				SD4->(dbSkip())

			EndDo

			oSection2:Finish()				

        Else
        	oReport:PrintText(STR0021,,oSection1:Cell("C1_ITEM"):ColPos())//"Nao existem requisicoes empenhadas deste item."
		EndIf

		oReport:SkipLine() 
		oReport:ThinLine()

	EndIf

	//��������������������������������������������������������������Ŀ
	//� Impressao dos Consumos nos ultimos 12 meses                  �
	//����������������������������������������������������������������
	oReport:SkipLine() 
	oReport:PrintText(STR0024,,oSection1:Cell("C1_ITEM"):ColPos())	//"CONSUMO DOS ULTIMOS 12 MESES:"

	dbSelectArea("SB3")
	If !Eof()

		oSection3:Init()

		nAno   := Year(dDataBase)
		nMes   := Month(dDataBase)
		aOrdem := {}
	    nY     := 1

		For nX := nMes To 1 Step -1    
			oSection3:Cell("MES"+StrZero(nY,2)):SetTitle("|  "+aMeses[nX]+"/"+StrZero(nAno,4))
			AADD(aOrdem,nX)
            nY++
		Next nX

		nAno--                                 

		For nX := 12 To nMes+1 Step -1
			oSection3:Cell("MES"+StrZero(nY,2)):SetTitle("|  "+aMeses[nX]+"/"+StrZero(nAno,4))
			AADD(aOrdem,nX)
            nY++
		Next nX

		For nX := 1 To Len(aOrdem)
			cMes    := StrZero(aOrdem[nX],2)
			cCampos := "SB3->B3_Q"+cMes
			oSection3:Cell("MES"+StrZero(nX,2)):SetValue(&cCampos)
		Next nX

		oSection3:PrintLine()		    
		oSection3:Finish()				

    Else 
		oReport:PrintText(STR0025,,oSection1:Cell("C1_ITEM"):ColPos())	//"Nao existe registro de consumo anterior deste item."
	EndIf
	
	//��������������������������������������������������������������Ŀ
	//�Impressao dos ultimos pedidos                                 �
	//����������������������������������������������������������������
	oReport:SkipLine() 
	oReport:ThinLine()
	oReport:SkipLine() 
	oReport:PrintText(STR0027,,oSection1:Cell("C1_ITEM"):ColPos()) //"ULTIMOS PEDIDOS:"

	dbSelectArea("SC7")
	dbSetOrder(7)
	Set SoftSeek On
	dbSeek(xFilial("SC7")+(cAliasSC1)->C1_PRODUTO+"z")
	Set SoftSeek Off
	dbSkip(-1)
	If (cAliasSC1)->C1_FILIAL + (cAliasSC1)->C1_PRODUTO == SC7->C7_FILIAL + SC7->C7_PRODUTO
		nPrinted := 0

		oSection4:Init()

		While !Bof() .And. (cAliasSC1)->C1_FILIAL + (cAliasSC1)->C1_PRODUTO == SC7->C7_FILIAL + SC7->C7_PRODUTO			
			nPrinted++
			If nPrinted > mv_par11
				Exit
			EndIf

			oSection4:PrintLine()
			
			dbSkip(-1)
		EndDo
		
		oSection4:Finish()

	Else
		oReport:PrintText(STR0028,,oSection1:Cell("C1_ITEM"):ColPos())	//"Nao existem pedidos cadastrados para este item."
	EndIf

	//��������������������������������������������������������������Ŀ
	//� Imprime os fornecedores indicados para este produto          �
	//����������������������������������������������������������������
	oReport:SkipLine() 
	oReport:ThinLine()
	oReport:SkipLine() 
	oReport:PrintText(STR0030,,oSection1:Cell("C1_ITEM"):ColPos()) //"FORNECEDORES:"
	
	If mv_par10 == 1                                                  
		
		dbSelectArea("SA5")
		dbSetOrder(2)
		dbSeek(xFilial("SA5")+(cAliasSC1)->C1_PRODUTO)

		If !Eof()
			nPrinted := 0
			oSection5:Init()

			While !Eof() .And. xFilial("SA5") + (cAliasSC1)->C1_PRODUTO == SA5->A5_FILIAL + SA5->A5_PRODUTO
				If SA2->(dbSeek(xFilial("SA2")+SA5->A5_FORNECE+SA5->A5_LOJA))
					nPrinted++
					If nPrinted > mv_par12
						Exit
					EndIf
					oSection5:PrintLine()
                EndIf    
                
				dbSkip()
			EndDo
			oSection5:Finish()
		Else
			oReport:PrintText(STR0031,,oSection1:Cell("C1_ITEM"):ColPos())	//"Nao existem fornecedores cadastrados para este item."
		EndIf
	Else                                                                            
		dbSelectArea("SAD")
		dbSetOrder(2)
		dbSeek(xFilial()+cGrupo)

		If !Eof()
			nPrinted := 0
			oSection5:Init()
			While !Eof() .And. SAD->AD_FILIAL + SAD->AD_GRUPO == xFilial("SAD") + cGrupo
				If SA2->(dbSeek(xFilial("SA2")+SAD->AD_FORNECE+SAD->AD_LOJA))
					nPrinted++
					If nPrinted > mv_par12
						Exit
					EndIf
					oSection5:PrintLine()
                EndIf    
				dbSkip()
			EndDo
        Else 
			oReport:PrintText(STR0031,,oSection1:Cell("C1_ITEM"):ColPos())	//"Nao existem fornecedores cadastrados para este item."
		EndIf
		oSection5:Finish()
	EndIf

	//��������������������������������������������������������������Ŀ
	//� Impressao do codigo alternativo                              �
	//����������������������������������������������������������������
	oReport:SkipLine() 
	oReport:ThinLine()
	oReport:SkipLine() 

	If !Empty(SB1->B1_ALTER)
		SB2->(dbSeek(xFilial("SB2") + SB1->B1_ALTER + (cAliasSC1)->C1_LOCAL ))
		oReport:PrintText(STR0034+" "+SB1->B1_ALTER+" "+STR0035+" "+Transform(SB2->B2_QATU,PesqPict("SB2","B2_QATU",12)+" "+SC1->C1_UM ),,oSection1:Cell("C1_ITEM"):ColPos()) //"Codigo Alternativo : " "Saldo do Alternativo :"
	Else
		oReport:PrintText(STR0034 + " " + STR0036,,oSection1:Cell("C1_ITEM"):ColPos()) //"Codigo Alternativo : " ### "Nao ha'"
	EndIf
	
	//��������������������������������������������������������������Ŀ
	//� Impressao do quadro de concorrencias                         �
	//����������������������������������������������������������������
	dbSelectArea(cAliasSC1)

	oReport:SkipLine() 
	oReport:ThinLine()
	oReport:SkipLine() 
	
	oReport:SkipLine() 
	oReport:ThinLine()
	oReport:SkipLine() 

	oReport:PrintText(STR0037,,oSection1:Cell("C1_ITEM"):ColPos()) //"|  C O N C O R R E N C I A S                  | ENTREGA         | OBSERVACOES                        | COND.PGTO        |  CONTATO         |QUANTIDADE      |  PRECO UNITARIO             | IPI     |     VALOR            |"
	oReport:PrintText("|---------------------------------------------|-----------------|------------------------------------|------------------|------------------|----------------|-----------------------------|---------|----------------------|",,oSection1:Cell("C1_ITEM"):ColPos())
	For nX :=1 To 4
	oReport:PrintText("|                                             |                 |                                    |                  |                  |                |                             |         |                      |",,oSection1:Cell("C1_ITEM"):ColPos())
	oReport:PrintText("|---------------------------------------------|-----------------|------------------------------------|------------------|------------------|----------------|-----------------------------|---------|----------------------|",,oSection1:Cell("C1_ITEM"):ColPos())
	Next nX
	oReport:SkipLine() 
	oReport:PrintText("---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------",,oSection1:Cell("C1_ITEM"):ColPos())
	oReport:PrintText(STR0038,,oSection1:Cell("C1_ITEM"):ColPos())
	oReport:PrintText("|                                                                                                            |                                                                                                             |",,oSection1:Cell("C1_ITEM"):ColPos())
	oReport:PrintText("|   ------------------------------------------------------------------------------------------------------   |   -------------------------------------------------------------------------------------------------------   |",,oSection1:Cell("C1_ITEM"):ColPos())
	oReport:PrintText("|                "+PADC(AllTrim((cAliasSC1)->C1_SOLICIT),15)+"                                                                             |                    "+Iif((cAliasSC1)->(FieldPos("C1_NOMAPRO")) > 0,Padc(AllTrim((cAliasSC1)->C1_NOMAPRO),15),Space(15))+"                                                                          |",,oSection1:Cell("C1_ITEM"):ColPos())
	oReport:PrintText("|                                                                                                            |                                                                                                             |",,oSection1:Cell("C1_ITEM"):ColPos())
	oReport:PrintText("---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------",,oSection1:Cell("C1_ITEM"):ColPos())

	//�����������������������������������������������������������Ŀ
	//�Guarda o Recno para a gravacao do numero de reemissao da SC�
	//�������������������������������������������������������������	
	If Ascan(aSavRec,IIf(lQuery .And. !lAuto ,(cAliasSC1)->SC1RECNO,Recno())) == 0	
		AADD(aSavRec,IIf(lQuery .And. !lAuto ,(cAliasSC1)->SC1RECNO,Recno()))
	Endif

	dbSelectArea(cAliasSC1)
	dbSkip()
	oSection1:Finish()
    oReport:EndPage() 
EndDo
	
//���������������������������������������������������������������Ŀ
//�Grava o numero de reemissao da SC.                             |
//�����������������������������������������������������������������
dbSelectArea("SC1")
If Len(aSavRec) > 0 
	For nX:=1 to Len(aSavRec)
		dbGoto(aSavRec[nX])
		If C1_QTDREEM < nVlrMax
			RecLock("SC1",.F.)  //Atualizacao do flag de Impressao
			Replace C1_QTDREEM With (C1_QTDREEM+1)
			MsUnLock()
		Else
			cLmtSol += SC1->C1_NUM + ","
		EndIf
	Next nX
EndIf

If !Empty(cLmtSol)
	Aviso(STR0073,STR0070 + "'" + Alltrim(str(nVlrMax)) + "'" + STR0071 + SubStr(cLmtSol,1,len(cLmtSol)-1) + STR0072,{"OK"})
EndIf

Return Nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � domr140R3� Autor � Claudinei M. Benzi    � Data � 05.12.91 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emissao das Solicitacoes de Compras                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   ���
�������������������������������������������������������������������������Ĵ��
���              �        �      �                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
static Function domr140R3(cAlias,nReg,nOpcx)
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������

LOCAL wnrel		:= "domr140"
LOCAL nCol		:= 0
LOCAL cDesc1	:= STR0001	//"Emissao das solicitacoes de compras cadastradas"
LOCAL cDesc2	:= ""
LOCAL cDesc3	:= ""
STATIC aTamSXG,aTamSXG2, nPosLoja, nPosNome, nTamNome

PRIVATE lAuto	:= (nReg!=Nil)
PRIVATE Titulo	:= STR0002 //"Solicitacao de Compra"
PRIVATE aReturn := {STR0003,10,STR0004,2,2,1,"",0}		//"Zebrado"###"Administracao"
PRIVATE aLinha	:= {}
PRIVATE Tamanho	:= "G"
PRIVATE Limite  := 220
PRIVATE nomeprog:= "domr140"
PRIVATE nLastKey:= 0
PRIVATE cString	:= "SC1"
PRIVATE M_PAG	:= 1
PRIVATE li      := 99
If !lAuto
	cPerg := "MTR140"
EndIf
//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
pergunte("MTR140",.F.)
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01    Do Numero                                        �
//� mv_par02    Ate o Numero                                     �
//� mv_par03    Todas ou em Aberto                               �
//� mv_par04    A Partir da data de emissao                      �
//� mv_par05    Ate a data de emissao                            �
//� mv_par06    Do Item                                          �
//� mv_par07    Ate o Item                                       �
//� mv_par08    Campo Descricao do Produto.                      �
//� mv_par09    Imprime Empenhos ?                               �
//� mv_par10    Utiliza Amarracao ?  Produto   Grupo             �
//� mv_par11    Imprime Qtos Pedido Compra?                      �
//� mv_par12    Imprime Qtos Fornecedores?                       �
//� mv_par13    Impr. SC's Firmes, Previstas ou Ambas            �
//����������������������������������������������������������������

//��������������������������������������������������������������Ŀ
//� Verif. conteudo das variaveis Grupo Forn. (001) e Loja (002) �
//����������������������������������������������������������������
aTamSXG  := If(aTamSXG  == NIL, TamSXG("001"), aTamSXG)
aTamSXG2 := If(aTamSXG2 == NIL, TamSXG("002"), aTamSXG2)

wnrel:=SetPrint(cString,wnrel,If(!lAuto,cPerg,Nil),@Titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho,,!lAuto)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| R140Imp(@lEnd,wnrel,cString,nReg)},Titulo)

Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C140IMP  � Autor � Cristina M. Ogura     � Data � 09.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � domr140                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function R140Imp(lEnd,wnrel,cString,nReg)

LOCAL cGrupo
LOCAL nContador
LOCAL j
LOCAL Cabec1	:= ""
LOCAL Cabec2	:= ""
LOCAL Cabec3	:= ""
LOCAL cbCont	:= 0
LOCAL aMeses	:= {STR0005,STR0006,STR0007,STR0008,STR0009,STR0010,STR0011,STR0012,STR0013,STR0014,STR0015,STR0016}		//"Jan"###"Fev"###"Mar"###"Abr"###"Mai"###"Jun"###"Jul"###"Ago"###"Set"###"Out"###"Nov"###"Dez"
LOCAL aOrdem 	:= {},cMeses,nAno,nMes,cMes,cCampos,cDescri,i
LOCAL aSavRec   := {}
LOCAL cAliasSC1	:= "SC1"
LOCAL cArqInd	:= ""
LOCAL cEmissao  := ""
LOCAL nX        := 0
LOCAL lQuery    := .F.
Local nVlrMax   := 0
Local cLmtSol   := ""

If SC1->( FieldPos( "C1_QTDREEM" ) ) > 0
	nVlrMax := val(Replicate('9',TamSX3("C1_QTDREEM")[1]))//Valor maximo para reemissao
EndIf

dbSelectArea("SC1")
dbSetOrder(1)
If lAuto
	dbGoto(nReg)
	mv_par01 := SC1->C1_NUM
	mv_par02 := SC1->C1_NUM
	mv_par03 := 1
	mv_par04 := SC1->C1_EMISSAO
	mv_par05 := SC1->C1_EMISSAO
	mv_par06 := "  "
	mv_par07 := "ZZ"
	mv_par09 := 1
	mv_par13 := 3
Else
#IFDEF TOP
	If (TcSrvType()#'AS/400')
		//��������������������������������Ŀ
		//� Query para SQL                 �
		//����������������������������������
		lQuery := .T.
		cQuery := "SELECT * "
		cQuery += "   FROM "	    + RetSqlName( 'SC1' ) +" SC1 "
		cQuery += "  WHERE "
		cQuery += "   C1_FILIAL   ='" + xFilial( 'SC1' ) + "' AND "
		cQuery += "   C1_NUM     >='" + MV_PAR01         + "' AND "
		cQuery += "   C1_NUM     <='" + MV_PAR02         + "' AND "
		cQuery += "   C1_EMISSAO >='" + DTOS(MV_PAR04)   + "' AND "
		cQuery += "   C1_EMISSAO <='" + DTOS(MV_PAR05)   + "' AND "
		cQuery += "   C1_ITEM    >='" + MV_PAR06         + "' AND "
		cQuery += "   C1_ITEM    <='" + MV_PAR07         + "' AND "
		If mv_par03 == 2
			cQuery += "C1_QUANT<>C1_QUJE  AND "
		EndIf
		cQuery += "SC1.D_E_L_E_T_<>'*' "
		cQuery += "ORDER BY " + SqlOrder(SC1->(IndexKey()))
		cQuery := ChangeQuery(cQuery)
		
		cAliasSC1 := "QRYSC1"
		dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), 'QRYSC1', .F., .T.)
		aEval(SC1->(dbStruct()),{|x| If(x[2]!="C",TcSetField("QRYSC1",AllTrim(x[1]),x[2],x[3],x[4]),Nil)})
	Else
#ENDIF
		If !Empty(mv_par01)
			SC1->(dbSeek(xFilial("SC1")+MV_PAR01,.T.))
		Else
			cArqInd   := CriaTrab( , .F. )
			cQuery := "C1_FILIAL=='" +xFilial("SC1")+"'.AND."
			cQuery += "C1_NUM>='"+MV_PAR01+"'.AND."
			cQuery += "C1_NUM<='"+MV_PAR02+"'.AND."
			cQuery += "DTOS(C1_EMISSAO)>='"+DTOS(MV_PAR04)+"'.AND."
			cQuery += "DTOS(C1_EMISSAO)<='"+DTOS(MV_PAR05)+"'.AND."
			cQuery += "C1_ITEM >= '"  +MV_PAR06+"'.AND."
			cQuery += "C1_ITEM <= '"  +MV_PAR07+"'"
			
			IndRegua( "SC1", cArqInd, IndexKey(), , cQuery )
		EndIf
#IFDEF TOP
	EndIf
#ENDIF
EndIf
//��������������������������������������������������������������Ŀ
//� Inicia a Impressao                                           �
//����������������������������������������������������������������

dbSelectArea(cAliasSC1)
SetRegua(LastRec())
While !EOF()	.And. (cAliasSC1)->C1_FILIAL==xFilial("SC1");
	.And. (cAliasSC1)->C1_NUM >= mv_par01 ;
	.And. (cAliasSC1)->C1_NUM <= mv_par02
	If lEnd
		@PROW()+1,001 PSAY STR0017	//"CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	IncRegua()
	
	If !Empty(aReturn[7]) .And. !&(aReturn[7])
		dbSkip()
		Loop
	EndIf
	
	//��������������������������������������������������������������Ŀ
	//� Filtra as que ja' tem pedido cadastrado                      �
	//����������������������������������������������������������������
	If mv_par03 == 2
		If ((cAliasSC1)->C1_QUANT - (cAliasSC1)->C1_QUJE) == 0
			dbSkip()
			Loop
		EndIf
	EndIf
	//��������������������������������������������������������������Ŀ
	//� Filtra a data de emissao e os itens a serem impressos        �
	//����������������������������������������������������������������
	If (cAliasSC1)->C1_EMISSAO < mv_par04 .Or. (cAliasSC1)->C1_EMISSAO > mv_par05
		dbSkip()
		Loop
	EndIf
	//��������������������������������������������������������������Ŀ
	//� Filtra Tipo de OPs Firmes ou Previstas                       �
	//����������������������������������������������������������������
	If !MtrAValOP(mv_par13, 'SC1')
		dbSkip()
		Loop
	EndIf
	
	If (cAliasSC1)->C1_ITEM < mv_par06 .Or. (cAliasSC1)->C1_ITEM > mv_par07
		dbSkip()
		Loop
	EndIf

	If (cAliasSC1)->(FieldPos("C1_QTDREEM")) > 0
    	cEmissao := IIf((cAliasSC1)->C1_QTDREEM>0,Str(If((cAliasSC1)->C1_QTDREEM < nVlrMax,(cAliasSC1)->C1_QTDREEM + 1,(cAliasSC1)->C1_QTDREEM),2)+STR0045," ")		//"a.Emissao 
    EndIf
    
	Titulo := STR0002+"     "+STR0043+" "+Substr((cAliasSC1)->C1_NUM,1,6)+" "+STR0018+" "+(cAliasSC1)->C1_CC+SPACE(20)+cEmissao //"Solicitacao de Compra  C.Custo :   a.Emissao"	
	Cabec1 := STR0039
	Cabec2 := STR0040

	If li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
	EndIf
	
	//��������������������������������������������������������������Ŀ
	//� Posiciona os arquivos no registro a ser impresso             �
	//����������������������������������������������������������������
	dbSelectArea("SB1")
	dbSeek(xFilial()+(cAliasSC1)->C1_PRODUTO)
	cGrupo := SB1->B1_GRUPO
	
	If mv_par10 == 1
		dbSelectArea("SA5")
		dbSetOrder(2)
		dbSeek(xFilial()+(cAliasSC1)->C1_PRODUTO)
	Else
		dbSelectArea("SAD")
		dbSetOrder(2)
		dbSeek(xFilial()+cGrupo)
	EndIf
	
	dbSelectArea("SB2")
	dbSeek(xFilial()+(cAliasSC1)->C1_PRODUTO+(cAliasSC1)->C1_LOCAL)
	
	dbSelectArea("SB3")
	dbSeek(xFilial()+(cAliasSC1)->C1_PRODUTO)
	
	dbSelectArea("SD4")
	dbSeek(xFilial()+(cAliasSC1)->C1_PRODUTO)
	
	dbSelectArea("SC7")
	dbSetOrder(1)
	dbSeek(xFilial()+(cAliasSC1)->C1_NUM+(cAliasSC1)->C1_ITEM)
	
	//��������������������������������������������������������������Ŀ
	//� Inicializa o descricao do Produto conf. parametro digitado.  �
	//����������������������������������������������������������������
	cDescri := " "
	If Empty(mv_par08)
		mv_par08 := "B1_DESC"
	EndIf
	If AllTrim(mv_par08) == "C1_DESCRI"    // Impressao da Descricao do produto
		cDescri := (cAliasSC1)->C1_DESCRI           // do arquivo de Solicitacao.
	EndIf
	If AllTrim(mv_par08) == "B5_CEME"      // Descricao cientifica do Produto.
		dbSelectArea("SB5")
		dbSetOrder(1)
		dbSeek( xFilial()+(cAliasSC1)->C1_PRODUTO )
		If Found()
			cDescri := B5_CEME
		EndIf
	EndIf
	If Empty(cDescri)                      // Impressao da descricao do Produto SB1.
		dbSelectArea("SB1")
		dbSeek( xFilial()+(cAliasSC1)->C1_PRODUTO )
		cDescri := SB1->B1_DESC
	EndIf
	
	A140Solic(cDescri,cAliasSC1)
	
	//��������������������������������������������������������������Ŀ
	//� Impressao das observacoes da solicitacao (caso exista)       �
	//����������������������������������������������������������������
	If !Empty((cAliasSC1)->C1_OBS)
		li++
		@ li,000 PSAY __PrtThinLine()
		li++
		@ li,000 PSAY STR0019	//"OBSERVACOES:"
		li++
		For i:= 1 To 258 Step 129
			@ li,003 PSAY Subs((cAliasSC1)->C1_OBS,i,129)   Picture "@!"
			li++
			If Empty(Subs((cAliasSC1)->C1_OBS,i+129,129))
				Exit
			Endif
		Next i
	Endif
	
	//��������������������������������������������������������������Ŀ
	//� Impressao da requisicoes empenhadas                          �
	//����������������������������������������������������������������
	li++
	If mv_par09 == 1
		@ li,000 PSAY __PrtThinLine()
		li++
		@ li,000 PSAY STR0020	//"REQUISICOES EMPENHADAS:"
		@ li,069 PSAY '|'
		@ li,144 PSAY '|'
		@ li,219 PSAY '|'
		
		li++
		dbSelectArea("SD4")
		If EOF()
			@ li,002 PSAY STR0021	//"Nao existem requisicoes empenhadas deste item."
			li++
		Else
			
			@ li,000 PSAY STR0022	//"Ordem de        Produto a ser           inicio        quantidade |Ordem de        Produto a ser           inicio        quantidade |"
			li++
			@ li,000 PSAY STR0023	//"Producao        produzido              previsto       necessaria |Producao        produzido              previsto       necessaria |"
			li++
			nCol := 0
			While !EOF() .And. D4_FILIAL+D4_COD == xFilial()+(cAliasSC1)->C1_PRODUTO
				If D4_QUANT = 0
					dbSkip()
					Loop
				Endif
				If li > 55
					cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
					A140Solic(cDescri,cAliasSC1)
				EndIf
				dbSelectArea("SC2")
				dbSeek(xFilial()+SD4->D4_OP)
				dbSelectArea("SD4")
				
				@ li,nCol    PSAY D4_OP
				@ li,nCol+16 PSAY SubStr(SC2->C2_PRODUTO,1,15)
				@ li,nCol+38 PSAY D4_DATA
				@ li,nCol+53 PSAY D4_QUANT       Picture PesqPict("SD4","D4_QUANT",12)
				@ li,nCol+69 PSAY '|'
				nCol+=75
				If nCol > 210
					li++
					nCol := 0
				EndIf
				
				dbSkip()
			End
			
			If nCol = 75
				@ li,144 PSAY '|'
				@ li,219 PSAY '|'
				li++
			Elseif nCol = 150
				@ li,219 PSAY '|'
				li++
			Endif
			
		EndIf
	EndIf
	
	If li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
		A140Solic(cDescri,cAliasSC1)		
	EndIf
	
	//��������������������������������������������������������������Ŀ
	//� Impressao dos Consumos nos ultimos 12 meses                  �
	//����������������������������������������������������������������
	@ li,000 PSAY __PrtThinLine()
	li++
	@ li,000 PSAY STR0024	//"CONSUMO DOS ULTIMOS 12 MESES:"
	li++
	dbSelectArea("SB3")
	If EOF()
		@ li,002 PSAY STR0025	//"Nao existe registro de consumo anterior deste item."
		li++
	Else
		cMeses := "   "
		nAno := YEAR(dDataBase)
		nMes := MONTH(dDataBase)
		aOrdem := {}
		For j := nMes To 1 Step -1
			cMeses += aMeses[j]+"/"+Substr(Str(nAno,4),3,2)+Space(4)
			AADD(aOrdem,j)
		Next j
		nAno--
		For j := 12 To nMes+1 Step -1
			cMeses += aMeses[j]+"/"+Substr(Str(nAno,4),3,2)+Space(4)
			AADD(aOrdem,j)
		Next j
		@ li,000 PSAY Trim(cMeses)+STR0026	//"    Media C"
		li++
		nCol := 0
		For j := 1 To Len(aOrdem)
			cMes    := StrZero(aOrdem[j],2)
			cCampos := "B3_Q"+cMes
			@ li,nCol PSAY  &cCampos   PicTure  PesqPict("SB3","B3_Q01",9) //"@E 99,999,99"
			nCol += 10
		Next j
		@ li,120 PSAY B3_MEDIA         PicTure  PesqPict("SB3","B3_MEDIA",8) //"@E 9,999,99"
		@ li,129 PSAY B3_CLASSE
		li++
	EndIf
	
	//��������������������������������������������������������������Ŀ
	//� Rotina para imprimir dados dos ultimos pedidos               �
	//����������������������������������������������������������������
	@ li,000 PSAY __PrtThinLine()
	li++
	@ li,000 PSAY STR0027	//"ULTIMOS PEDIDOS:"
	@ li,219 PSAY '|'
	li++
	dbSelectArea("SC7")
	dbSetOrder(7)
	Set SoftSeek On
	dbSeek(xFilial()+(cAliasSC1)->C1_PRODUTO+"z")
	Set SoftSeek Off
	dbSkip(-1)
	If xFilial()+(cAliasSC1)->C1_PRODUTO != C7_FILIAL+C7_PRODUTO
		@ li,002 PSAY STR0028	//"Nao existem pedidos cadastrados para este item."
		li++
	Else
		nPosLoja := 17
		If cPaisLoc <> "BRA" // STR Usado por Localizacoes - Sergio Camurca
			@ li,00 PSAY STR0044   // "Numero It Codigo do Fornecedor
		Else
			@ li,00 PSAY STR0029   // "Numero It Codigo do Fornecedor
		Endif
		li++
		nContador := 0
		While !BOF() .And. xFilial()+(cAliasSC1)->C1_PRODUTO == C7_FILIAL+C7_PRODUTO
			
			dbSelectArea("SA2")
			dbSeek(xFilial()+SC7->C7_FORNECE+SC7->C7_LOJA)
			dbSelectArea("SC7")
			
			nContador++
			If nContador > mv_par11
				Exit
			EndIf
			
			If li > 55
				cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
				A140Solic(cDescri,cAliasSC1)
			EndIf
			
			@ li,000 PSAY C7_NUM
			@ li,007 PSAY C7_ITEM
			@ li,012 PSAY SubStr(C7_FORNECE,1,20)
			@ li,033 PSAY SubStr(C7_LOJA,1,5)
			@ li,039 PSAY SubStr(SA2->A2_NOME,1,34)
			@ li,074 PSAY C7_QUANT   Picture PesqPict("SC7","C7_QUANT",14)
			@ li,091 PSAY C7_UM

			// Se for diferente de Brasil nao utiliza a funcao Right - Sergio Camurca
			
			If cPaisLoc <> "BRA"
				@ li,104 PSAY C7_PRECO  Picture PesqPict("SC7","c7_preco",14)
				@ li,119 PSAY C7_TOTAL  Picture PesqPict("SC7","c7_total",14)
			Else
				@ li,104 PSAY C7_PRECO  Picture Right(PesqPict("SC7","c7_preco"),14)
				@ li,119 PSAY C7_TOTAL  Picture Right(PesqPict("SC7","c7_total"),14)
			Endif
			
			@ li,135 PSAY C7_EMISSAO
			@ li,149 PSAY C7_DATPRF
			@ li,165 PSAY C7_DATPRF-C7_EMISSAO  Picture "999"
			@ li,168 PSAY "D"
			@ li,171 PSAY C7_COND
			@ li,182 PSAY C7_QUJE Picture PesqPict("SC7","C7_QUJE",14)
			@ li,198 PSAY If(Empty(C7_RESIDUO),C7_QUANT-C7_QUJE,0)  Picture PesqPict("SC7","C7_QUJE",14)
			@ li,213 PSAY If(Empty(C7_RESIDUO),'Nao','Sim')+"   |"
			li++
			dbSkip(-1)
		End
	EndIf
	
	//��������������������������������������������������������������Ŀ
	//� Imprime os fornecedores indicados para este produto          �
	//����������������������������������������������������������������
	@ li,000 PSAY __PrtThinLine()
	li++
	@ li,000 PSAY STR0030	//"FORNECEDORES:"
	li++
	
	If mv_par10 == 1                                                   // Amarracao por Produto
		nPosLoja := 07
		nTamNome := 28
		nPosNome := 10
		If aTamSXG[1] != aTamSXG[3]
			nPosLoja += aTamSXG[4] - aTamSXG[3]
			nPosNome += ((aTamSXG[4] - aTamSXG[3]) + (aTamSXG2[4] - aTamSXG2[3]))
			nTamNome -= ((aTamSXG[4] - aTamSXG[3]) + (aTamSXG2[4] - aTamSXG2[3]))
		Endif
		
		dbSelectArea("SA5")
		If EOF()
			@ li,002 PSAY STR0031	//"Nao existem fornecedores cadastrados para este item."
			li++
		Else
			// Verif. se utilizara tamanho maximo (Fornec. com 20 pos. e Loja com 4 pos.)
			If aTamSXG[1] != aTamSXG[3]
				@ li,000 PSAY STR0041	//"Codigo               Lj.  RAZAO SOCIAL Telefone        Contato    Fax             Ult.Compr.  Municipio      UF Ris Cod. no Fornec."
				//				                              12345678901234567890 1234 123456789012 123456789012345 1234567890 123456789012345 11/11/1199 123456789012345 12   1 123456789012345
				//    		    		            	      0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
				//          	        			            0         1         2         3         4         5         6         7         8         9         0         1         2         3
			Else
				@ li,000 PSAY STR0032	//"Codigo Lj Nome                         Telefone        Contato    Fax             Ult.Compr.  Municipio      UF Ris Cod. no Fornec."
				//				                              123456 12 1234567890123456789012345678 123456789012345 1234567890 123456789012345 11/11/1199 123456789012345 12   1 123456789012345
				//    		    		            	      0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
				//          	        			            0         1         2         3         4         5         6         7         8         9         0         1         2         3
			Endif
			li++
			nContador := 0
			While !EOF() .And. xFilial()+(cAliasSC1)->C1_PRODUTO == A5_FILIAL+A5_PRODUTO
				dbSelectArea("SA2")
				dbSeek(xFilial()+SA5->A5_FORNECE+SA5->A5_LOJA)
				If EOF()
					dbSelectArea("SA5")
					dbSkip()
					Loop
				EndIf
				dbSelectArea("SA5")
				nContador++
				If nContador > mv_par12
					Exit
				EndIf
				If li > 55
					cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
					A140Solic(cDescri,cAliasSC1)
				EndIf
				@ li,000 PSAY A5_FORNECE
				@ li,nPosLoja PSAY A5_LOJA
				@ li,nPosNome PSAY SubStr(SA2->A2_NOME,1,nTamNome)
				@ li,039 PSAY Substr(SA2->A2_TEL,1,15)
				@ li,055 PSAY Substr(SA2->A2_CONTATO,1,10)
				@ li,066 PSAY SA2->A2_FAX
				@ li,082 PSAY SA2->A2_ULTCOM
				@ li,093 PSAY Left( SA2->A2_MUN, 15 ) 
				@ li,109 PSAY SA2->A2_EST
				@ li,112 PSAY SA2->A2_RISCO
				@ li,116 PSAY SubStr(A5_CODPRF,1,15)
				li++
				dbSkip()
			End
		EndIf
		dbSelectArea("SA5")
		dbSetOrder(1)
	Else                                                                            // Amarracao por Grupo
		dbSelectArea("SAD")
		If EOF()
			@ li,002 PSAY STR0031	//"Nao existem fornecedores cadastrados para este item."
			li++
		Else
			
			nPosLoja := 07
			nTamNome := 30
			nPosNome := 10
			If aTamSXG[1] != aTamSXG[3]
				nPosLoja += aTamSXG[4] - aTamSXG[3]
				nPosNome += ((aTamSXG[4] - aTamSXG[3]) + (aTamSXG2[4] - aTamSXG2[3]))
				nTamNome -= (aTamSXG[4] - aTamSXG[3])
			Endif
			
			// Verif. se utilizara tamanho maximo (Fornec. com 20 pos. e Loja com 5 pos.)
			If aTamSXG[1] != aTamSXG[3]
				
				@ li,000 PSAY STR0042	//"Codigo Lj Nome       Loja Razao Social   Telefone        Contato    Fax             Ul.Compr Municipio       UF Ris Cod. no Fornec."
				//				                           12345678901234567890 1234 12345678901234 123456789012345 1234567890 123456789012345 11/11/11 123456789012345 12 123 123456789012345
				//              	                       0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
				//                  	                   0         1         2         3         4         5         6         7         8         9         0         1         2         3
				
				
				@ li,000 PSAY STR0033	//"Codigo Lj Nome                           Telefone        Contato    Fax             Ul.Compr Municipio       UF Ris Cod. no Fornec."
				//  	                                   111111 11 123456789012345678901234567890 123456789012345 1234567890 123456789012345 11/11/11 123456789012345 12 123 123456789012345
				//      	                               0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
				//          	                           0         1         2         3         4         5         6         7         8         9         0         1         2         3
			Endif
			li++
			nContador := 0
			While !EOF() .And. SAD->AD_FILIAL+SAD->AD_GRUPO == xFilial()+cGrupo
				dbSelectArea("SA2")
				dbSeek(xFilial()+SAD->AD_FORNECE+SAD->AD_LOJA)
				If EOF()
					dbSelectArea("SAD")
					dbSkip()
					Loop
				EndIf
				dbSelectArea("SAD")
				nContador++
				If nContador > mv_par12
					Exit
				EndIf
				If li > 55
					cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
					
					A140Solic(cDescri,cAliasSC1)
					
				EndIf
				@ li,000 PSAY AD_FORNECE
				@ li,nPosLoja PSAY AD_LOJA
				@ li,nPosNome PSAY SubStr(SA2->A2_NOME,1,nTamNome)
				@ li,041 PSAY Substr(SA2->A2_TEL,1,15)
				@ li,057 PSAY Substr(SA2->A2_CONTATO,1,10)
				@ li,068 PSAY SA2->A2_FAX
				@ li,084 PSAY SA2->A2_ULTCOM
				@ li,095 PSAY Left( SA2->A2_MUN, 15 ) 
				@ li,111 PSAY SA2->A2_EST              
				@ li,114 PSAY SA2->A2_RISCO
				li++
				dbSkip()
			End
		EndIf
		dbSelectArea("SAD")
		dbSetOrder(2)
	EndIf
	
	If li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
		A140Solic(cDescri,cAliasSC1)
	EndIf
	
	//��������������������������������������������������������������Ŀ
	//� Imprime o codigo alternativo                                 �
	//����������������������������������������������������������������
	li++
	@ li,000 PSAY __PrtThinLine()
	li++
	
	@ li,002 PSAY STR0034	//"Codigo Alternativo : "
	If !Empty(SB1->B1_ALTER)
		@ li,023 PSAY SB1->B1_ALTER
		@ li,060 PSAY STR0035	//"Saldo do Alternativo :"
		dbSelectArea("SB2")
		dbSeek(xFilial()+SB1->B1_ALTER+(cAliasSC1)->C1_LOCAL)
		@ li,083 PSAY B2_QATU  Picture PesqPict("SB2","B2_QATU",12)
		@ li,096 PSAY SC1->C1_UM
	Else
		@ li,023 PSAY STR0036	//"Nao ha'"
	EndIf
	
	li++
	@ li,000 PSAY __PrtThinLine()
	li++
	
	If li > 40
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
		A140Solic(cDescri,cAliasSC1)
	EndIf
	
	//��������������������������������������������������������������Ŀ
	//� Imprime o quadro de concorrencias                            �
	//����������������������������������������������������������������
	li++
	@ li,000 PSAY __PrtThinLine()
	li++
	
	@ li,00 PSAY STR0037 //"|  C O N C O R R E N C I A S                  | ENTREGA         | OBSERVACOES                        | COND.PGTO        |  CONTATO         |QUANTIDADE      |  PRECO UNITARIO             | IPI     |     VALOR            |"
	li++
	@ li,000 PSAY     "|---------------------------------------------|-----------------|------------------------------------|------------------|------------------|----------------|-----------------------------|---------|----------------------|"
	For j :=1 To 4
		li++
		@ li,000 PSAY "|                                             |                 |                                    |                  |                  |                |                             |         |                      |"
		li++
		@ li,000 PSAY "|---------------------------------------------|-----------------|------------------------------------|------------------|------------------|----------------|-----------------------------|---------|----------------------|"
	Next j
	dbSelectArea(cAliasSC1)
	li++
	@ ++li,000 PSAY   "---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
	@ ++li,000 PSAY STR0038 // "|                 REQUISITANTE                                             |                  AUTORIZANTE                                             |"
	@ ++li,000 PSAY   "|                                                                                                            |                                                                                                             |"
	@ ++li,000 PSAY   "|   ------------------------------------------------------------------------------------------------------   |   -------------------------------------------------------------------------------------------------------   |"
	@ ++li,000 PSAY   "|                "+PADC(ALLTRIM(C1_SOLICIT),15)+"                                                                             |                    "+IIF(SC1->(FieldPos("C1_NOMAPRO")) > 0,PADC(ALLTRIM(C1_NOMAPRO),15),SPACE(15))+"                                                                          |"
	@ ++li,000 PSAY   "|                                                                                                            |                                                                                                             |"
	@ ++li,000 PSAY   "---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
	li:=80

	//�����������������������������������������������������������Ŀ
	//�Guarda o Recno para a gravacao do numero de reemissao da SC�
	//�������������������������������������������������������������	
	If (cAliasSC1)->(FieldPos("C1_QTDREEM")) > 0
		If Ascan(aSavRec,IIf(lQuery,(cAliasSC1)->R_E_C_N_O_,Recno())) == 0	
			AADD(aSavRec,IIf(lQuery,(cAliasSC1)->R_E_C_N_O_,Recno()))
		Endif
	EndIf
			
	dbSkip()
	
EndDo

//��������������������������������������������������������������������Ŀ
//�Na existencia do campo C1_QTDREEM grava o numero de reemissao da SC |
//����������������������������������������������������������������������
dbSelectArea("SC1")
If Len(aSavRec) > 0 .And. (cAliasSC1)->(FieldPos("C1_QTDREEM")) > 0
	For nX:=1 to Len(aSavRec)
		dbGoto(aSavRec[nX])
		If C1_QTDREEM < nVlrMax
			RecLock("SC1",.F.)  //Atualizacao do flag de Impressao
			Replace C1_QTDREEM With (C1_QTDREEM+1)
			MsUnLock()
		Else
			cLmtSol += SC1->C1_NUM + ","
		EndIf
	Next nX
EndIf

RetIndex("SC1")
If File(cArqInd+ OrdBagExt())
	FErase(cArqInd+ OrdBagExt() )
EndIf

#IFDEF TOP
	If !lAuto
		If Select("QRYSC1")<>0
			dbSelectArea("QRYSC1")
			dbCloseArea()
		EndIf
	EndIf
#ENDIF

If !Empty(cLmtSol)
	Aviso(STR0073,STR0070 + "'" + Alltrim(str(nVlrMax)) + "'" + STR0071 + SubStr(cLmtSol,1,len(cLmtSol)-1) + STR0072,{"OK"})
EndIf

If aReturn[5] = 1
	Set Printer TO
	Commit
	OurSpool(wnrel)
EndIf

MS_FLUSH()

Return  .T.


static Function A140Solic(cDescri,cAliasSC1)

//��������������������������������������������������������������Ŀ
//� Impressao da Linha do Produto Solicitado                     �
//����������������������������������������������������������������
// 1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
// 0        1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2
//"IT  CODIGO PRODUTO   D  E  S  C  R  I  C  A  O                  SALDO          PONTO DE          SALDO DA      UNIDADE       ALMOXARIFADO       QUANT.POR        ULTIMO PRECO        LEAD        DATA DA          DATA PARA "
//"                                                                ATUAL            PEDIDO       SOLICITACAO      MEDIDA                           EMBALAGEM           DE COMPRA        TIME        NECESSIDADE      COMPRAR   "
//123  123456           123456789012345678901234567890      123456789012      123456789012      123456789012      12            12                 123              123456789012         123        12/45/7890       12/45/7890
Local j           

//�����������������������������������������������������������������Ŀ
//� Funcao utilizada para verificar a ultima versao dos fontes      �
//� SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |
//| nestes fontes. NAO REMOVER !!!							        �
//�������������������������������������������������������������������
IF !(FindFunction("SIGACUS_V") .and. SIGACUS_V() >= 20050512)
    Final(STR0046) //"Atualizar SIGACUS.PRW !!!"
Endif
IF !(FindFunction("SIGACUSA_V") .and. SIGACUSA_V() >= 20050512)
    Final(STR0047) //"Atualizar SIGACUSA.PRX !!!"
Endif
IF !(FindFunction("SIGACUSB_V") .and. SIGACUSB_V() >= 20050512)
    Final(STR0048) //"Atualizar SIGACUSB.PRX !!!"
Endif

@ li,000 PSAY (cAliasSC1)->C1_ITEM                          Picture PesqPict("SC1","C1_ITEM")
@ li,005 PSAY (cAliasSC1)->C1_PRODUTO
@ li,037 PSAY SubStr(cDescri,1,30)
@ li,071 PSAY SB2->B2_QATU                                  Picture PesqPict("SB2","B2_QATU" ,12)
@ li,086 PSAY RetFldProd(SB1->B1_COD,"B1_EMIN")             Picture PesqPict("SB1","B1_EMIN" ,12)
@ li,101 PSAY (cAliasSC1)->C1_QUANT-(cAliasSC1)->C1_QUJE   Picture PesqPict("SC1","C1_QUANT",12)
@ li,121 PSAY (cAliasSC1)->C1_UM                            Picture PesqPict("SC1","C1_UM")
@ li,131 PSAY (cAliasSC1)->C1_LOCAL                         Picture PesqPict("SC1","C1_LOCAL")
@ li,140 PSAY RetFldProd(SB1->B1_COD,"B1_QE")               Picture PesqPict("SB1","B1_QE"   ,09)
@ li,162 PSAY RetFldProd(SB1->B1_COD,"B1_UPRC")             Picture PesqPict("SB1","B1_UPRC",12)
@ li,183 PSAY CalcPrazo((cAliasSC1)->C1_PRODUTO,(cAliasSC1)->C1_QUANT) 	Picture "999"
@ li,194 PSAY If(Empty((cAliasSC1)->C1_DATPRF),(cAliasSC1)->C1_EMISSAO,(cAliasSC1)->C1_DATPRF)
@ li,210 PSAY SomaPrazo(If(Empty((cAliasSC1)->C1_DATPRF),(cAliasSC1)->C1_EMISSAO,(cAliasSC1)->C1_DATPRF), -CalcPrazo((cAliasSC1)->C1_PRODUTO,(cAliasSC1)->C1_QUANT))
li++
//��������������������������������������������������������������Ŀ
//� Impressao da Descricao Adicional do Produto (se houver)      �
//����������������������������������������������������������������
For j:=31 TO Len(Trim(cDescri)) Step 30
	@ li, 21 PSAY SubStr(cDescri,j,30)
	li++
Next j

Return .T.