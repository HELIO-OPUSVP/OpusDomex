#INCLUDE "TOPCONN.CH"
#INCLUDE "FIVEWIN.CH"
#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#Include "COLORS.CH"
#Include "FONT.CH"
#INCLUDE "MSOBJECT.CH

*---------------------------------------------------------*
User Function MRP003() //MINI MRP
*---------------------------------------------------------*

Private _cFiltro
Private cCadastro
Private _cMarca
Private aRotina := {{'Processar MRP', 'U_MRP003A', 0, 1}}

//cPerg:= 'SZ500    '
//Pergunte(cPerg, .T.)

if Select("QRT") >0
	QRT->(dbCloseArea())
EndIf


cCadastro:= 'Pedidos de venda para Mini-MRP V1.0'
aac:= {'Abandona', 'Confirma'}
MsgRun(	"Selecionando registros , Aguarde...", ;
"",{|| CursorWait(), MRP003B(70,80) ,CursorArrow()}	)


Return

*---------------------------------------------------------*
STATIC Function MRP003B()
*---------------------------------------------------------*
PRIVATE aCampos :={}
PRIVATE _aCampos:={}
private cTitle :='Mini MRP'
lInverte:= .F.
_cMarca:= SC6->(GetMark())


aadd(aCampos,{"C6_OK"          ,"C",2,0})
aadd(aCampos,{"C6_NUM"         ,"C",6,0})
aadd(aCampos,{"C6_ITEM"        ,"C",2,0})
aadd(aCampos,{"C6_PRODUTO"     ,"C",15,0})
aadd(aCampos,{"C6_DESCRI"      ,"C",30,0})
aadd(aCampos,{"C6_ENTREG"      ,"C",8,0})
aadd(aCampos,{"C6_CLI"         ,"C",6,0})
aadd(aCampos,{"C6_LOJA"        ,"C",4,0})
aadd(aCampos,{"A1_NOME"        ,"C",50,0})
aadd(aCampos,{"C6_QTDVEN"      ,"N",12,2})
aadd(aCampos,{"C6_QTDENT"      ,"N",12,2})

AADD(_aCampos,{"C6_OK"          ,"" ,""             ,""                    } )
aadd(_aCampos,{"C6_NUM"         ,"" ,"Numero"       ,"@R"                  } )
aadd(_aCampos,{"C6_ITEM"        ,"" ,"It."          ,"@R"                  } )
aadd(_aCampos,{"C6_PRODUTO"     ,"" ,"Produto"      ,"@R"                  } )
aadd(_aCampos,{"C6_DESCRI"      ,"" ,"Descricao"    ,"@R"                  } )
aadd(_aCampos,{"C6_ENTREG"      ,"" ,"Entrega"      ,"@D"                  } )
aadd(_aCampos,{"C6_CLI"         ,"" ,"Cliente"      ,"@R"                  } )
aadd(_aCampos,{"C6_LOJA"        ,"" ,"Loja"         ,"@R"                  } )
aadd(_aCampos,{"A1_NOME"        ,"" ,"Nome"         ,"@R"                  } )
aadd(_aCampos,{"C6_QTDVEN"      ,"" ,"Qtdven"       ,"@E 999,999,999.99"   } )
aadd(_aCampos,{"C6_QTDENT"      ,"" ,"Qtdent"       ,"@E 999,999,999.99"   } )




// Cria arquivo
cNomeArq:=CriaTrab(aCampos, .t. )          // gera o arquivo temporário com o nome 'QRT'
dbUseArea(.T.,__LocalDriver,cNomeArq,"QRT",.F.,.F.)

//Query para preencher o arquivo

cQuery := " SELECT A.C6_OK , A.C6_NUM , A.C6_ITEM, A.C6_PRODUTO , A.C6_DESCRI , A.C6_ENTREG , A.C6_CLI , A.C6_LOJA , B.A1_NOME, A.C6_QTDVEN , A.C6_QTDENT , A.C6_ENTREG       "
cQuery += " FROM SC6010 A, SA1010 B"
cQuery += " WHERE A.C6_FILIAL = '" + xFilial("SC6") + "'"
cQuery += " AND A.C6_CLI+A.C6_LOJA=B.A1_COD+B.A1_LOJA "
cQuery += " AND A.C6_QTDVEN > A.C6_QTDENT "
cQuery += " AND A.D_E_L_E_T_=' ' "
cQuery += " AND B.D_E_L_E_T_=' ' "
//cQuery += "  ORDER BY  A.C6_NUM, A.C6_ITEM, A.C6_PRODUTO "
cQuery += "  ORDER BY  A.C6_PRODUTO "

if Select("Result") <> 0
	DBSelectArea("Result")
	DBCloseArea()
endif

cQuery :=ChangeQuery(cQuery)      // otimiza a query

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"Result",.T.,.T.)

while Result->(!EOF())
	If Reclock("QRT",.T.)
		QRT->C6_OK       := Result->C6_OK
		QRT->C6_NUM      := Result->C6_NUM
		QRT->C6_ITEM     := Result->C6_ITEM
		QRT->C6_PRODUTO  := Result->C6_PRODUTO
		QRT->C6_DESCRI   := Result->C6_DESCRI
		QRT->C6_ENTREG   := Result->C6_ENTREG
		QRT->C6_CLI      := Result->C6_CLI
		QRT->C6_LOJA     := Result->C6_LOJA
		QRT->A1_NOME     := Result->A1_NOME
		QRT->C6_QTDVEN   := Result->C6_QTDVEN
		QRT->C6_QTDENT   := Result->C6_QTDENT
		QRT->C6_ENTREG   := Result->C6_ENTREG
		
		QRT->(msUnlock())
	endif
	Result->(dbSkip())
Enddo

dbSelectArea("QRT")
//     dbSetOrder(1)

//       MarkBrowse("QRT","C6_OK","QRT->C6_QTDVEN - QRT->C6_QTDENT > 0 ",_aCampos,lInverte,_cMarca ,              ,,,,'U_MarkZ5()')
//       MarkBrowse("QRT","C6_OK",                                        ,_aCampos,lInverte,_cMarca ,'U_MrkAllZ5()'              ,,,,'U_MarkZ5()')
MarkBrow('QRT','C6_OK',                                      ,_aCampos,lInverte,_cMarca,'U_MrkAllZ5()',,,,'U_MarkZ5()' )


//_cFiltro:= 	" C6_QTDVEN>C6_QTDENT AND D_E_L_E_T_<>'*' "

//SELECT C6_NUM,C6_PRODUTO,C6_DESCRI,C6_QTDVEN-C6_QTDENT AS C6_SALDO,C6_ENTREG,C6_CLI,C6_LOJA
//FROM SC6010
//WHERE C6_QTDVEN>C6_QTDENT AND D_E_L_E_T_<>'*'
//ORDER BY C6_PRODUTO


//lInverte:= .F.
//dbSelectArea("SC6")
//_cMarca:= SZ5->(GetMark())
//MsFilter(_cFiltro)
//MarkBrow( 'SC6', 'C6_OK',,,lInverte, _cMarca,'U_MrkAllZ5()',,,,'U_MarkZ5()' )

if Select("QRT") >0
	QRT->(dbCloseArea())
EndIf


Return

*---------------------------------------------------------*
USER Function MarkZ5()
*---------------------------------------------------------*
If QRT->(IsMark( 'C6_OK', _cMarca ))
	QRT->(RecLock( 'QRT', .F. ))
	QRT->C6_OK:=Space(3)
	QRT->(MsUnLock())
Else
	QRT->(RecLock( 'QRT', .F. ))
	QRT->C6_OK:=_cMarca
	QRT->(MsUnLock())
EndIf
Return

// Grava marca em todos os registros validos

*---------------------------------------------------------*
USER Function MrkAllZ5()
*---------------------------------------------------------*
Local nRecno := QRT->(Recno())
dbSelectArea('QRT')
QRT->(dbGotop())
While !QRT->(Eof())
	U_MarkZ5()
	QRT->(dbSkip())
End
QRT->(dbGoto( nRecno ))
Return

*---------------------------------------------------------*
USER Function MRP003A()
*---------------------------------------------------------*

PRIVATE cPRODMRP :=''
IF MSGYESNO('Processar MRP 1.0','Atenção')
	
	QRT->(dbSelectArea('QRT'))
	QRT->(dbGoTop())
	
	Do While !QRT->(EOF())
		If QRT->(IsMark( 'C6_OK', _cMarca ))
			//MSGALERT(QRT->C6_PRODUTO)
			cPRODMRP := cPRODMRP+"'"+ALLTRIM(QRT->C6_PRODUTO)+"',"
		EndIf
		QRT->(DbSkip())
	EndDo
	cPRODMRP :=SUBSTR(cPRODMRP,1,LEN(cPRODMRP)-1)
	MRP3M710(cPRODMRP)
ENDIF
Return


*---------------------------------------------------------*
STATIC Function MRP3M710(cPRODMRP)
*---------------------------------------------------------*

Local PARAMIXB1    := .T.     //    // .T. se a rotina roda em batch, senão .F.Local
Local nTipoPeriodo := 1       //1   // Tipo de periodo 1=Diario; 2=Semanal; 3=Quinzenal;4=Mensal; 5=Trimestral; 6=Semestral
Local nNumPeriodos := 60      //60  // 2-- Quantidade de periodos
Local lPedidoVenda := .T.     //.T. // 3-- Considera Pedidos Vendas em Carteira
Local aEstrutura   := {}

Private PARAMIXB2  := {}

aAdd(PARAMIXB2,nTipoPeriodo)  //1-- Tipo de periodo 1=Diario; 2=Semanal; 3=Quinzenal;4=Mensal; 5=Trimestral; 6=Semestral
aAdd(PARAMIXB2,nNumPeriodos)  //2-- Quantidade de periodos
aAdd(PARAMIXB2,lPedidoVenda)  //3-- Considera Pedidos Vendas em Carteira
aAdd(PARAMIXB2,{}          )  //4-- Array contendo Tipos  de produtos a serem considerados (se Nil, assume padrao - todos)
aAdd(PARAMIXB2,{}          )  //5-- Array contendo Grupos de produtos a serem considerados (se Nil, assume padrao - todos)
aAdd(PARAMIXB2,.F.         )  //6-- Gera/Nao Gera OPs e SCs depois do calculo da necessidade.
aAdd(PARAMIXB2,.F.         )  //7-- Indica se monta log do MRP
aAdd(PARAMIXB2,""          )  //8-- Numero da Op Inicial

cData     := DtoC(Date())
cAssunto  := "Begin of MINI MRP I Domex - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
cTexto    := "Begin of MINI MPR I Domex - Date " + cData + "  Time: " + Time()
cPara     :=  "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br"
cCC       := ""
cArquivo  := ""

U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)

//************************************************************************************************************************************
//* Apagando todos os registros da SHF. Tivemos problemas de criação de milhões de registros nela sem sabermos exatamente para que.  *
//************************************************************************************************************************************

dbSelectArea("SHF")
//TCSQLEXEC("DELETE "+RetSqlName("SHF"))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄu
//³Selecionando registros para comporem o MRP³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄu

//TCSQLEXEC("UPDATE SC4010 SET C4_QUANT= 0 WHERE C4_DATA <='"+DTOS(FIRSTDAY(DDATABASE))+"' AND  D_E_L_E_T_ = '' ")

TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'N'")

//TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'S' FROM SB1010, SC7010 WHERE C7_RESIDUO = '' AND C7_QUJE < C7_QUANT AND C7_PRODUTO = B1_COD AND B1_MRP <> 'S' AND SB1010.D_E_L_E_T_ = '' AND SC7010.D_E_L_E_T_ = '' ")
//TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'S' FROM SC1010, SB1010 WHERE C1_QUJE < C1_QUANT AND C1_RESIDUO = '' AND C1_PRODUTO = B1_COD AND B1_MRP <> 'S' AND SB1010.D_E_L_E_T_ = '' AND SC1010.D_E_L_E_T_ = '' ")
//TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'S' FROM SD4010, SB1010 WHERE D4_QUANT <> 0 AND D4_COD = B1_COD AND B1_MRP <> 'S' AND SB1010.D_E_L_E_T_ = '' AND SD4010.D_E_L_E_T_ = '' ")
//TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'S' FROM SC2010, SB1010 WHERE C2_QUANT > C2_QUJE AND C2_DATRF = '' AND C2_PRODUTO = B1_COD AND B1_MRP <> 'S' AND SB1010.D_E_L_E_T_ = '' AND SC2010.D_E_L_E_T_ = '' ")
//TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'S' FROM SC6010, SB1010 WHERE C6_QTDENT < C6_QTDVEN AND C6_PRODUTO = B1_COD AND B1_MRP <> 'S' AND SB1010.D_E_L_E_T_ = '' AND SC6010.D_E_L_E_T_ = '' ")
//TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'S' FROM SB1010 WHERE B1_ALTER IN (SELECT B1_COD FROM SB1010 WHERE B1_MRP = 'S') AND B1_MRP = 'N' AND D_E_L_E_T_ = ''")
//TCSQLEXEC("DROP TABLE    BI..ZHA010_"+DTOC(DATE)+" " )
//TCSQLEXEC("SELECT * INTO BI..ZHA010_"+DTOC(DATE)+" " )

//TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'S' FROM SC4010, SB1010 WHERE C4_QUANT <> 0 AND C4_PRODUTO = B1_COD AND B1_MRP <> 'S' AND SB1010.D_E_L_E_T_ = '' AND SC4010.D_E_L_E_T_ = '' ")
TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'S' WHERE B1_COD IN ("+cPRODMRP+") AND D_E_L_E_T_ = ''  ")

cQuery := "SELECT B1_COD FROM SB1010 WHERE B1_MRP = 'S' AND D_E_L_E_T_ = '' "
TCQUERY cQuery NEW ALIAS "QUERYSB1"

SB1->( dbSetOrder(1) )

While !QUERYSB1->( EOF() )
	U_ExpEstru(QUERYSB1->B1_COD,@aEstrutura)
	For x := 1 to Len(aEstrutura)
		
		If SB1->( dbSeek( xFilial() + aEstrutura[x,1] ) )
			If SB1->B1_MRP <> 'S'
				Reclock("SB1",.F.)
				SB1->B1_MRP := 'S'
				SB1->( msUnlock() )
			EndIf
		EndIf
		
		If SB1->( dbSeek( xFilial() + aEstrutura[x,2] ) )
			If SB1->B1_MRP <> 'S'
				Reclock("SB1",.F.)
				SB1->B1_MRP := 'S'
				SB1->( msUnlock() )
			EndIf
		EndIf
		
	Next x
	
	QUERYSB1->( dbSkip() )
End

//****************************
//* Monta a Tabela de Tipos  *
//****************************
dbSelectArea("SX5")
dbSeek(xFilial("SX5")+"02")
While SX5->X5_FILIAL == xFilial("SX5") .AND. SX5->X5_TABELA == "02" .and. !SX5->( Eof() )
	cCapital := OemToAnsi(Capital(X5Descri()))
	AADD(PARAMIXB2[4],{.T.,SubStr(X5_chave,1,2)+" "+cCapital})
	SX5->( dbSkip() )
End

//****************************
//* Monta a Tabela de Grupos *
//****************************

dbSelectArea("SBM")
dbSeek(xFilial("SBM"))
AADD(PARAMIXB2[5],{.T.,Criavar("B1_GRUPO",.F.)+" "+"Grupo em Branco"})
While (SBM->BM_FILIAL == xFilial("SBM")) .AND. !SBM->( Eof() )
	cCapital := OemToAnsi(Capital(SBM->BM_DESC))
	//AADD(PARAMIXB2[5],{.T.,SubStr(SBM->BM_GRUPO,1,4)+" "+cCapital})
	AADD(PARAMIXB2[5],{.T.,SubStr(SBM->BM_GRUPO,1,4)})
	SBM->( dbSkip() )
End


MATA710(PARAMIXB1,PARAMIXB2)
U_IMPMRP01()
U_MRP001B()

cQUERYFIM2:=" UPDATE ZHB010 SET ZHB_TIPO='01-Necessidade' WHERE SUBSTRING(ZHB_TIPO,1,2)='11' "
TCSQLEXEC(cQUERYFIM2)


if Select("QUERYSB1") >0
	QUERYSB1->(dbCloseArea())
EndIf


*-----------------------------------------------------------------
TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'N'")
TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'S' WHERE B1_COD IN ("+cPRODMRP+") AND D_E_L_E_T_ = ''  ")

cQuery := "SELECT B1_COD FROM SB1010 WHERE B1_MRP = 'S' AND D_E_L_E_T_ = '' "
TCQUERY cQuery NEW ALIAS "QUERYSB1"

SB1->( dbSetOrder(1) )

While !QUERYSB1->( EOF() )
	U_ExpEstru(QUERYSB1->B1_COD,@aEstrutura)
	For x := 1 to Len(aEstrutura)
		
		If SB1->( dbSeek( xFilial() + aEstrutura[x,1] ) )
			If SB1->B1_MRP <> 'S'
				Reclock("SB1",.F.)
				SB1->B1_MRP := 'S'
				SB1->( msUnlock() )
			EndIf
		EndIf
		
		If SB1->( dbSeek( xFilial() + aEstrutura[x,2] ) )
			If SB1->B1_MRP <> 'S'
				Reclock("SB1",.F.)
				SB1->B1_MRP := 'S'
				SB1->( msUnlock() )
			EndIf
		EndIf
		
	Next x
	
	QUERYSB1->( dbSkip() )
End

if Select("QUERYSB1") >0
	QUERYSB1->(dbCloseArea())
EndIf



cAssunto  := "End of MINI MRP I Domex - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
cTexto    := "End of MINI MRP I Domex - Date " + cData + "  Time: " + Time()
cPara     :=  "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br"
cCC       := ""
cArquivo  := ""

U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)

Msgalert('FIM - MRP')


Return










/*
MATA710.PRX
Sintaxe: MATA710 - Ordens de Produção ( PARAMIXB1, PARAMIXB2 ) --> Nil

Retorno:
Nil(nulo)
Nil
Observações
Parâmetros:

O vetor PARAMIXB2 é composto pela estrutura abaixo:

PARAMIXB2[1]   // Tipo de periodo
1=Diario;2=Semanal;3=Quinzenal;4=Mensal;5=Trimestral;6=Semestral
PARAMIXB2[2]   // Quantidade de periodos
PARAMIXB2[3]   // Considera Pedidos em Carteira
PARAMIXB2[4]   // Array contendo Tipos  de produtos a serem
considerados (se Nil, assume padrao)
PARAMIXB2[5]   // Array contendo Grupos de produtos a serem
considerados (se Nil, assume padrao)
PARAMIXB2[6]   // Gera/Nao Gera OPs e SCs depois do calculo da
necessidade.
PARAMIXB2[7]   // Indica se monta log do MRP
PARAMIXB2[8]   // Numero da Op Inicial


Exemplos
*/
