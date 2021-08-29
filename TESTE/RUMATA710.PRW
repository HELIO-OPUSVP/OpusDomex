#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"            

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³UMATA710  ºAutor  ³Helio Ferreira      º Data ³  24/03/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Shedule do MRP                                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RJOBM710()

Local PARAMIXB1    := .T.     //    // .T. se a rotina roda em batch, senão .F.Local
Local nTipoPeriodo := 1       //1   // Tipo de periodo 1=Diario; 2=Semanal; 3=Quinzenal;4=Mensal; 5=Trimestral; 6=Semestral
Local nNumPeriodos := 90      //60  // 2-- Quantidade de periodos
Local lPedidoVenda := .T.     //Local lPedidoVenda := .T.     //.T. // 3-- Considera Pedidos Vendas em Carteira
Local aEstrutura   := {}
Local cSQL

Private PARAMIXB2  := {}



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
*/

aAdd(PARAMIXB2,nTipoPeriodo)  //1-- Tipo de periodo 1=Diario; 2=Semanal; 3=Quinzenal;4=Mensal; 5=Trimestral; 6=Semestral
aAdd(PARAMIXB2,nNumPeriodos)  //2-- Quantidade de periodos
aAdd(PARAMIXB2,lPedidoVenda)  //3-- Considera Pedidos Vendas em Carteira
aAdd(PARAMIXB2,{}          )  //4-- Array contendo Tipos  de produtos a serem considerados (se Nil, assume padrao - todos)
aAdd(PARAMIXB2,{}          )  //5-- Array contendo Grupos de produtos a serem considerados (se Nil, assume padrao - todos)
aAdd(PARAMIXB2,.F.         )  //6-- Gera/Nao Gera OPs e SCs depois do calculo da necessidade.
aAdd(PARAMIXB2,.F.         )  //7-- Indica se monta log do MRP
aAdd(PARAMIXB2,""          )  //8-- Numero da Op Inicial

aemp := {"01","01"}

//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" USER 'Mauricio' PASSWORD 'megasenha' Tables "SB1","SB2","SC1","SC2","SC3","SC4","SC5","SC6","SC7","SBM","SHF" Modulo "PCP"
PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" USER 'MRP'      PASSWORD 'Megasenha' Tables "SB1","SB2","SC1","SC2","SC3","SC4","SC5","SC6","SC7","SBM","SHF"  Modulo "PCP"
//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" USER 'Admin'    PASSWORD 'OpusDomex' Tables "SB1","SB2","SC1","SC2","SC3","SC4","SC5","SC6","SC7","SBM","SHF"  Modulo "PCP"
//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" USER 'JOBMRPI'  PASSWORD 'JOBMRPI'   Tables "SB1","SB2","SC1","SC2","SC3","SC4","SC5","SC6","SC7","SBM","SHF"  Modulo "PCP"

cData     := DtoC(Date())
cAssunto  := "Begin of MRP I Domex - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
cTexto    := "Begin of MPR I Domex - Date " + cData + "  Time: " + Time()
cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br"
cCC       := ""
cArquivo  := ""

U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)

// Query de Coreção do B2_QEMP

//Retirado por Hélio em 13/11/17 
//cSQL := "UPDATE "+RetSqlName("SB2")+" SET "
//cSQL += "B2_QEMP = D4_QUANT FROM "
//cSQL += "( SELECT D4_COD, D4_LOCAL, SUM(D4_QUANT) AS D4_QUANT,(SELECT B2_QEMP FROM SB2010 (NOLOCK) WHERE B2_COD = D4_COD AND B2_LOCAL = D4_LOCAL AND D_E_L_E_T_ = '') AS B2_QEMP "
//cSQL += "FROM "+RetSqlName("SD4")+" (NOLOCK) WHERE "
//cSQL += "D4_QUANT > 0 AND SD4010.D_E_L_E_T_ = '' GROUP BY D4_COD, D4_LOCAL) AS SD4 "
//cSQL += "INNER JOIN "+RetSqlName("SB2")+" AS SB2 on B2_COD=D4_COD and B2_LOCAL=D4_LOCAL AND ROUND(D4_QUANT,4) <> ROUND(SB2.B2_QEMP,4) and SB2.D_E_L_E_T_=''"

//TCSQLEXEC(cSQL)  // <---------------------------------------------
cData     := DtoC(Date())
cAssunto  := "MRP I Domex Query de Coreção do B2_QEMP - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
cTexto    := "Retirado do MRP por Hélio dem 13/11/17 - MPR I Domex Query de Coreção do B2_QEMP- Date " + cData + "  Time: " + Time()
cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br"
cCC       := ""
cArquivo  := ""

U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)

//************************************************************************************************************************************
//* Apagando todos os registros da SHF. Tivemos problemas de criação de milhões de registros nela sem sabermos exatamente para que.  *
//************************************************************************************************************************************

dbSelectArea("SHF")
TCSQLEXEC("DELETE "+RetSqlName("SHF"))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄu
//³Selecionando registros para comporem o MRP³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄu

TCSQLEXEC("UPDATE SC4010 SET C4_QUANT = 0 WHERE C4_DATA <'"+DTOS(FIRSTDAY(DDATABASE))+"' AND  D_E_L_E_T_ = '' ")
TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'N'")
TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'S' FROM SB1010, SC7010 WHERE C7_RESIDUO = '' AND C7_QUJE < C7_QUANT AND C7_PRODUTO = B1_COD AND B1_MRP <> 'S' AND SB1010.D_E_L_E_T_ = '' AND SC7010.D_E_L_E_T_ = '' ")
TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'S' FROM SC1010, SB1010 WHERE C1_QUJE < C1_QUANT AND C1_RESIDUO = '' AND C1_PRODUTO = B1_COD AND B1_MRP <> 'S' AND SB1010.D_E_L_E_T_ = '' AND SC1010.D_E_L_E_T_ = '' ")
TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'S' FROM SD4010, SB1010 WHERE D4_QUANT <> 0 AND D4_COD = B1_COD AND B1_MRP <> 'S' AND SB1010.D_E_L_E_T_ = '' AND SD4010.D_E_L_E_T_ = '' ")
TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'S' FROM SC2010, SB1010 WHERE C2_QUANT > C2_QUJE AND C2_DATRF = '' AND C2_PRODUTO = B1_COD AND B1_MRP <> 'S' AND SB1010.D_E_L_E_T_ = '' AND SC2010.D_E_L_E_T_ = '' ")
TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'S' FROM SC4010, SB1010 WHERE C4_QUANT <> 0 AND C4_PRODUTO = B1_COD AND B1_MRP <> 'S' AND SB1010.D_E_L_E_T_ = '' AND SC4010.D_E_L_E_T_ = '' ")
TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'S' FROM SC6010, SB1010 WHERE C6_QTDENT < C6_QTDVEN AND C6_PRODUTO = B1_COD AND B1_MRP <> 'S' AND SB1010.D_E_L_E_T_ = '' AND SC6010.D_E_L_E_T_ = '' ")

//TCSQLEXEC("DROP TABLE    BI..ZHA010_"+DTOC(DATE)+" " )
//TCSQLEXEC("SELECT * INTO BI..ZHA010_"+DTOC(DATE)+" " )

cAssunto  := "MRP I Domex - Limpeza efetuada - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
cTexto    := "MPR I Domex - Limpeza efetuada - Date " + cData + "  Time: " + Time()
cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br"
cCC       := ""
cArquivo  := ""

U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)

TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'S' FROM SB1010  WHERE B1_ALTER IN (SELECT B1_COD FROM SB1010 WHERE B1_MRP = 'S') AND B1_MRP = 'N' AND D_E_L_E_T_ = ''")
TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'S' WHERE B1_COD  IN (SELECT GI_PRODALT FROM SGI010 WHERE D_E_L_E_T_<>'*' )" )
TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'N' WHERE B1_TIPO IN ('SI','AT' ) AND  B1_MRP = 'S' AND D_E_L_E_T_<>'*' " )

cAssunto  := "MRP I Domex - Conf. Alternativo - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
cTexto    := "MPR I Domex - Conf. Alternativo - Date " + cData + "  Time: " + Time()
cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br"
cCC       := ""
cArquivo  := ""

U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)



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

TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'N' WHERE B1_TIPO IN ('SI','AT' ) AND  B1_MRP = 'S' AND D_E_L_E_T_<>'*' " )

cAssunto  := "MRP I Domex - Cadastro B1_MRP=S - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
cTexto    := "MPR I Domex - Cadastro B1_MRP=S - Date " + cData + "  Time: " + Time()
cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br"
cCC       := ""
cArquivo  := ""

U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)

/*
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

cAssunto  := "MRP I Domex - Monta a Tabela de Tipos - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
cTexto    := "MPR I Domex - Monta a Tabela de Tipos - Date " + cData + "  Time: " + Time()
cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br"
cCC       := ""
cArquivo  := ""

U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)

//****************************
//* Monta a Tabela de Grupos *
//****************************

dbSelectArea("SBM")
dbSeek(xFilial("SBM"))
AADD(PARAMIXB2[5],{.T.,Criavar("B1_GRUPO",.F.)+" "+"Grupo em Branco"})
While (SBM->BM_FILIAL == xFilial("SBM")) .AND. !SBM->( Eof() )
	cCapital := OemToAnsi(Capital(SBM->BM_DESC))
	AADD(PARAMIXB2[5],{.T.,SubStr(SBM->BM_GRUPO,1,4)})
	SBM->( dbSkip() )
End

cAssunto  := "MRP I Domex - Monta a Tabela de Grupos - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
cTexto    := "MPR I Domex - Monta a Tabela de Grupos - Date " + cData + "  Time: " + Time()
cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br"
cCC       := ""
cArquivo  := ""

U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
  */

RESET ENVIRONMENT

Return





User Function RJOBM002()   //<--------------------------------------

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" USER 'MRP'      PASSWORD 'Megasenha' Tables "SB1","SB2","SC1","SC2","SC3","SC4","SC5","SC6","SC7","SBM","SHF"  Modulo "PCP"
cData     := DtoC(Date())


cAssunto  := "MRP I Domex - Inicio MATA710 - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
cTexto    := "MPR I Domex - Inicio MATA710 - Date " + cData + "  Time: " + Time()
cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br"
cCC       := ""
cArquivo  := ""

U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
   
//MATA710(PARAMIXB1,PARAMIXB2) //ANTIGO
//MATA710(.T.,{/*par01*/,/*par02*/,/*par03*/,/*par04*/,/*par05*/,/*par06*/,/*par07*/,/*par08*/}) 
//par01 = periodicidade (1 - diario, 2 - semanal, etc)   PARAMIXB2[1]   // Tipo de periodo1=Diario;2=Semanal;3=Quinzenal;4=Mensal;5=Trimestral;6=Semestral
//par02 = quantidade de periodos                         PARAMIXB2[2]   // Quantidade de periodos

//par03 = array com o filtro de tipos                    PARAMIXB2[3]   // Considera Pedidos em Carteira
//par04 = array com o filtro de grupos                   PARAMIXB2[4]   // Array contendo Tipos  de produtos a serem considerados (se Nil, assume padrao)
//par05 = considera pedidos de vendas (.T. or .F.)       PARAMIXB2[5]   // Array contendo Grupos de produtos a serem considerados (se Nil, assume padrao)

//par06 = nulo                                           PARAMIXB2[6]   // Gera/Nao Gera OPs e SCs depois do calculo da necessidade.
//par07 = liga LOG do mrp (.T. or .F.)                   PARAMIXB2[7]   // Indica se monta log do MRP
//par08 = numero inicial da op                           PARAMIXB2[8]   // Numero da Op Inicial





/*
cAssunto  := "MRP I Domex - Fim MATA710 - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
cTexto    := "MPR I Domex - Fim MATA710 - Date " + cData + "  Time: " + Time()
cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br"
cCC       := ""
cArquivo  := ""

U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
*/

U_IMPMRP01()   //<-----------------------------------------------

cAssunto  := "MRP I Domex - Fim IMPMRP01 -SHA SHR- Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
cTexto    := "MPR I Domex - Fim IMPMRP01 -SHA SHR- Date " + cData + "  Time: " + Time()
cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br"
cCC       := ""
cArquivo  := ""

U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)

U_MRP001()      //<----------------------------------------------------------

cAssunto  := "End of MRP I Domex - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
cTexto    := "End of MRP I Domex - Date " + cData + "  Time: " + Time()
cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br"
cCC       := ""
cArquivo  := ""

U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)

RESET ENVIRONMENT

Return
