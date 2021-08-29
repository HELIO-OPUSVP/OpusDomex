#include "font.ch"
#include "colors.ch"
#include "Protheus.ch"
#include "Topconn.ch"
#include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณR1CTBCUS  บAutor  ณJonas Pereira    บ Data ณ  06/05/2019  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  relat๓rio contabil (lote 8840) x movimentos (producao)    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุอออออออออออ
อออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ DOMEX                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function R1CTBCUS()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	Local   cDesc1      := "Este programa tem como objetivo imprimir relatorio "
	Local   cDesc2      := "de acordo com os parametros informados pelo usuario."
	Local   cDesc3      := ""
	Local   Cabec1      := "DTMOV               PRODUTO-ORI         PRODUTO-DEST        TIPO-ORI            TIPO-DEST           QUANTIDADE          CUSTO                     CREDITO                  DEBITO               VALOR CONTABIL"
	Local   Cabec2      := " "
	Local   imprime     := .T.
	Local   aOrd        := {}

	Private nLin        := 80
	Private titulo      := "Contabilidade x Movimentos - Transferencias de Part Number"
	Private tamanho     := "G"
	Private nomeprog    := "R1CTBCUS"
	Private nTipo       := 18
	Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey    := 0
	Private cPerg       := "R1CTBCUS"
	Private wnrel       := "R1CTBCUS"
	Private cString     := "SD4"
	Private cValDif     := 0
	Private lERROProd   :=.F.
	Private m_pag       := 0
	Private nValorTOT   := 0
	Private lSkipSB1    := .T.
	Private lImpFam		:= .F.
	Private cFilDom		:= "01"



	fCriaPerg()
	pergunte(cPerg,.t.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.T.)

//mv_do_prod := mv_par01
//mv_ate_pro := mv_par02
//mv_da_op   := mv_par03
//mv_ate_op  := mv_par04

	mv_dtinic  := mv_par01
	mv_dtfim   := mv_par02
	mv_transpn := mv_par03
	mv_invent  := mv_par04
	mv_mod     := mv_par05
	mv_totais  := mv_par06
	mv_dif     := mv_par07
	mv_ctbsmov := mv_par08


//If mv_ajuste == 1 .and. Subs(cusuario,7,5) <> 'Jonas'//'HELIO'
//	MsgStop('Usuแrio sem permissใo para rodar o relat๓rio gerando ajustes de estoque.')
//	Return
//EndIf

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)


	Processa({|lEnd| RunReport(Cabec1,Cabec2,Titulo,@nLin,@lEnd) },Titulo)

//If !Empty(nValorTOT)
//	@ nLin, 000 pSay "VALOR TOTAL DOS PRODUTOS EM ESTOQUE: " + Transform(nValorTOT,"@E 999,999,999.9999")
//EndIf

	Roda(0,"","M")

	SET DEVICE TO SCREEN

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

//If MsgYesNO('Deseja rodar o relat๓rio novamente?')
//	U_RESTR03()
//EndIf      

Return



Static Function RunReport(Cabec1,Cabec2,Titulo,nLin,lEnd)
	Local x
	Local nEspacos := 20
	Local nValCred := 0
	Local nValDeb  := 0
	Local nValPR   := 0
	Local nValOU   := 0
	Local nQtdCred := 0
	Local nQtdDeb  := 0
	Local nCT2TOT  := 0
	Local cChaveOri   :=""
	Local cChaveDes   :=""



	aLinha1      := {}
	aLinha2      := {}
	aLinha3      := {}
	aLinha4      := {}


	pergunte(cPerg,.F.)

//mv_do_prod := mv_par01
//mv_ate_pro := mv_par02
//mv_da_op   := mv_par03
//mv_ate_op  := mv_par04
	mv_dtinic  := mv_par01
	mv_dtfim   := mv_par02
	mv_transpn := mv_par03
	mv_invent  := mv_par04
	mv_mod     := mv_par05
	mv_totais  := mv_par06
	mv_dif     := mv_par07
	mv_ctbsmov := mv_par08

	if mv_par09 == 1
		_cFilDom:= "01"
	Else 
		_cFilDom:= "02"
	Endif

	If mv_transpn <>1 .AND. mv_invent  <> 1 .AND. mv_mod     <>1 .AND. mv_ctbsmov <>1
		MsgStop("Nใo foi selecionado uma modalidade valida para emissao do relat๓rio")
		Return
	EndIf

	If mv_transpn == 1  //1 - SIM
		//DADOS TRANSFERENCIA DE PN SD3-MOVIMENTOS
		cQuery := " SELECT * FROM "
		cQuery += " (   "
		cQuery += " SELECT 'RES' AS TP, '' AS D3_FILIAL,'' AS ARM, '' AS ARMORI, '' AS EMI, SUBSTRING(SD3A.D3_EMISSAO,5,2)+'-'+LEFT(SD3A.D3_EMISSAO,4) AS DTMOV,'' AS CODORI, '' AS CODDES, '' AS NUMSEQ, '' AS TPORI,'' AS TPDES,  "
		cQuery += " SUM(SD3A.D3_QUANT) AS QTD, SUM(SD3A.D3_CUSTO1) AS CUSTOORI, SUM(SD3B.D3_CUSTO1) AS CUSTODES "
		cQuery += " FROM SD3010 (NOLOCK) AS SD3A INNER JOIN SD3010  (NOLOCK) AS SD3B  "
		cQuery += " ON SD3A.D3_FILIAL=SD3B.D3_FILIAL AND SD3A.D3_COD<>SD3B.D3_COD AND SD3A.D3_NUMSEQ=SD3B.D3_NUMSEQ AND SD3A.D3_TIPO<>SD3B.D3_TIPO "
		cQuery += " AND SD3A.D3_QUANT=SD3B.D3_QUANT  "
		cQuery += " WHERE  SD3A.D3_FILIAL = '"+_cFilDom+"' AND  SD3A.D_E_L_E_T_='' AND SD3B.D_E_L_E_T_='' AND SD3A.D3_ESTORNO=''  AND SD3B.D3_ESTORNO='' AND "
		cQuery += " SD3A.D3_EMISSAO BETWEEN '"+DTOS(mv_dtinic)+"' AND '"+DTOS(mv_dtfim)+"' AND "
		cQuery += " SD3A.D3_TM='499' AND SD3B.D3_TM='999' "
		cQuery += " AND RIGHT(SD3A.D3_CF,2) IN ('E4')   "
		cQuery += " AND RIGHT(SD3B.D3_CF,2) IN ('E4')    "
		cQuery += " GROUP BY SUBSTRING(SD3A.D3_EMISSAO,5,2), LEFT(SD3A.D3_EMISSAO,4)   "
		cQuery += " UNION ALL  "
		cQuery += " SELECT 'DET' AS TP, SD3A.D3_FILIAL,SD3A.D3_LOCAL AS ARM, SD3B.D3_LOCAL AS ARMORI,SD3A.D3_EMISSAO AS EMI, SUBSTRING(SD3A.D3_EMISSAO,7,2)+'/'+SUBSTRING(SD3A.D3_EMISSAO,5,2)+'/'+SUBSTRING(SD3A.D3_EMISSAO,1,4) AS DTMOV, SD3A.D3_COD AS CODORI, SD3B.D3_COD AS CODDES, SD3A.D3_NUMSEQ AS NUMSEQ, SD3A.D3_TIPO AS TPORI,SD3B.D3_TIPO AS TPDES,  "
		cQuery += " (SD3A.D3_QUANT) AS QTD, SD3A.D3_CUSTO1 AS CUSTOORI, SD3B.D3_CUSTO1 AS CUSTODES "
		cQuery += " FROM SD3010 (NOLOCK) AS SD3A INNER JOIN SD3010  (NOLOCK) AS SD3B  "
		cQuery += " ON SD3A.D3_FILIAL=SD3B.D3_FILIAL AND SD3A.D3_COD<>SD3B.D3_COD AND SD3A.D3_NUMSEQ=SD3B.D3_NUMSEQ AND SD3A.D3_TIPO<>SD3B.D3_TIPO "
		cQuery += " AND SD3A.D3_QUANT=SD3B.D3_QUANT   "
		cQuery += " WHERE SD3A.D3_FILIAL = '"+_cFilDom+"' AND SD3A.D_E_L_E_T_='' AND SD3B.D_E_L_E_T_='' AND SD3A.D3_ESTORNO=''  AND SD3B.D3_ESTORNO='' AND "
		cQuery += " SD3A.D3_EMISSAO BETWEEN '"+DTOS(mv_dtinic)+"' AND '"+DTOS(mv_dtfim)+"' AND "
		cQuery += " SD3A.D3_TM='499' AND SD3B.D3_TM='999'  "
		cQuery += " AND RIGHT(SD3A.D3_CF,2) IN ('E4')   "
		cQuery += " AND RIGHT(SD3B.D3_CF,2) IN ('E4')   "
		cQuery += " )  MOVPN "
		cQuery += " ORDER BY TP, DTMOV DESC "


		If Select("QSB1") <> 0
			QSB1->( dbCloseArea() )
		EndIf

		TCQUERY cQuery NEW ALIAS "QSB1"

		nRecno:=0
		QSB1->( dbEval({|| nRecno++}) )

		ProcRegua(nRecno)

		QSB1->( dbGoTop() )

		AADD(aLinha1, space(20)+"******* TRANSFERENCIAS DE PART NUMBER *******")
		AADD(aLinha1, '')
		AADD(aLinha1, '')
		While !QSB1->( EOF() )

			If lEnd
				MsgStop("Processamento cancelado")
				Return
			EndIf

			nValCred := 0
			nValDeb  := 0
			lERROProd   := .F.

			INCPROC("TRANSFERENCIAS DE PART NUMBER - Periodo: " + QSB1->DTMOV )

			cLinha := ""

			If QSB1->TP== "RES"
				cLinha += QSB1->DTMOV     	+ Space(nEspacos-LEN(QSB1->DTMOV))
				AADD(aLinha1, '')
				cLinha += QSB1->CODORI      + Space(nEspacos-LEN(QSB1->CODORI))
				cLinha += QSB1->CODDES      + Space(nEspacos-LEN(QSB1->CODDES))
				cLinha += QSB1->TPORI       + Space(nEspacos-LEN(QSB1->TPORI))
				cLinha += QSB1->TPDES       + Space(nEspacos-LEN(QSB1->TPDES))
				cLinha += Transform(QSB1->QTD,"@E 99,999,999.99")      + Space(nEspacos-LEN(Transform(QSB1->QTD,"@E 99,999,999.99")))
				cLinha += Transform(ROUND(QSB1->CUSTOORI,2),"@E 99,999,999.99") + Space(nEspacos-LEN(Transform(QSB1->CUSTOORI,"@E 99,999,999.99")))

				If nCT2TOT <> ROUND(QSB1->CUSTOORI,2)
					cLinha += Space(52)+Transform(nCT2TOT,"@E 999,999.9999")+Space(2)+"DIF("+Transform(ROUND(QSB1->CUSTOORI,2)-nCT2TOT,"@E 999,999.99")+")"
				Elseif mv_dif <> 1
					cLinha += Space(52)+Transform(nCT2TOT,"@E 999,999.9999")
				Elseif 	mv_dif == 1
					cLinha := ""
				Endif

				AADD(aLinha1, cLinha)
				AADD(aLinha1, "")
				cLinha := "Transf. PR x Outros: "  +Transform(ROUND(nValPR,2),       "@E 99,999,999.99")
				AADD(aLinha1, cLinha)
				cLinha := "Transf. Outros x PR: "  +Transform(ROUND(nValOU,2),       "@E 99,999,999.99")


			Else
				if mv_totais<>1
					cLinha += QSB1->DTMOV     	+ Space(nEspacos-LEN(QSB1->DTMOV))
					cLinha += QSB1->CODORI      + Space(nEspacos-LEN(QSB1->CODORI))
					cLinha += QSB1->CODDES      + Space(nEspacos-LEN(QSB1->CODDES))
					cLinha += QSB1->TPORI       + Space(nEspacos-LEN(QSB1->TPORI))
					cLinha += QSB1->TPDES       + Space(nEspacos-LEN(QSB1->TPDES))
					cLinha += Transform(QSB1->QTD,"@E 999,999.9999")      + Space(nEspacos-LEN(Transform(QSB1->QTD,"@E 999,999.9999")))
					cLinha += Transform(ROUND(QSB1->CUSTOORI,2),"@E 999,999.9999") + Space(nEspacos-LEN(Transform(QSB1->CUSTOORI,"@E 999,999.9999")))
				EndIf
				//DADOS TRANSFERENCIA DE PN CT2-TOTAL ITENS
				DBSelectArea("CT2")
				CT2->(Dbgotop())
				DbSetorder(17)
				//D3_FILIAL+D3_COD+D3_LOCAL+DTOS(D3_EMISSAO)+D3_NUMSEQ
				//cChaveOri := xFilial("CT2")+QSB1->D3_FILIAL+QSB1->CODDES+SPACE(15-LEN(QSB1->CODDES))+QSB1->ARMORI+(QSB1->EMI)+QSB1->NUMSEQ
				cChaveOri := _cFilDom+QSB1->D3_FILIAL+QSB1->CODDES+SPACE(15-LEN(QSB1->CODDES))+QSB1->ARMORI+(QSB1->EMI)+QSB1->NUMSEQ
				If	CT2->(DbSeek(cChaveOri+SPACE(Len(CT2->CT2_KEY)-len(cChaveOri)))) .and. mv_totais<>1
					cLinha += Space(5)+CT2_CREDIT+Space(5)+CT2_DEBITO+Space(2)+Transform(CT2->CT2_VALOR,"@E 999,999.9999")
				Elseif mv_totais<>1
					//	DBSelectArea("CT2")
					//	CT2->(Dbgotop())
					//	DbSetorder(17)
					//	If CT2->(DbSeek(cChaveDes+SPACE(Len(CT2->CT2_KEY)-len(cChaveDes)))) .and. mv_totais<>1
					//		cLinha += Space(5)+CT2_CREDIT+Space(5)+CT2_DEBITO+Space(2)+Transform(CT2->CT2_VALOR,"@E 999,999.9999")
					//	Elseif mv_totais<>1
					cLinha += Space(52)+Transform(0,"@E 999,999.9999")   //+Space(5)+Transform(0,"@E 999,999.9999")
				EndIf
				//	EndIF

				If  CT2->CT2_VALOR<>ROUND(QSB1->CUSTOORI,2) .and. mv_totais<>1
					cLinha += Space(2)+"DIF("+Transform(ROUND(QSB1->CUSTOORI,2)-CT2->CT2_VALOR,"@E 999,999.99")+")"
				Elseif 	mv_dif == 1
					cLinha := ""
				Endif

				If QSB1->TPORI=="PR"
					nValPR  += QSB1->CUSTOORI
				ElseIF	QSB1->TPDES=="PR"
					nValOU  += QSB1->CUSTOORI
				EndIf

				nCT2TOT += CT2_VALOR
			EndIf
			If !Empty(cLinha)
				AADD(aLinha1, cLinha)
			EndIf
			QSB1->( dbSkip() )
		End
		If Select("QSB1") <> 0
			QSB1->( dbCloseArea() )
		EndIf
	EndIf

	If mv_invent == 1 //1 - SIM

		nCT2TOT := 0

		//PARTE2 INVENTARIO MOVIMENTOS-SD3
		cQuery := " SELECT * FROM  "
		cQuery += " ( "
		cQuery += " SELECT  'RES' AS TP, '' AS ARM, '' AS EMI,'' AS D3_FILIAL, '' AS NUMSEQ, SUBSTRING(SD3.D3_EMISSAO,5,2)+' - '+LEFT(SD3.D3_EMISSAO,4) AS DTMOV, '' AS 'PN', '' AS 'TIPO' , '' AS 'REDE'  , MOVRE.QTD+MOVDE.QTD AS 'QTD',MOVDE.CUSTO AS DEVOLUCAO, MOVRE.CUSTO AS REQUISICAO,  MOVDE.CUSTO - MOVRE.CUSTO AS DIF  "
		cQuery += " FROM SD3010 AS SD3 "
		cQuery += " LEFT OUTER JOIN  "
		cQuery += " ( "
		cQuery += " SELECT  LEFT(SD3.D3_EMISSAO,6) AS DTMOV, LEFT(D3_CF,2) AS TP, SUM(D3_CUSTO1) AS CUSTO, SUM(D3_QUANT) AS QTD FROM SD3010 (NOLOCK) AS SD3  "
		cQuery += " WHERE SD3.D3_FILIAL = '"+_cFilDom+"' AND  SD3.D_E_L_E_T_='' AND D3_CUSTO1<>0 AND D3_DOC='INVENT' AND LEFT(D3_CF,2)='DE' AND D3_EMISSAO BETWEEN '"+DTOS(mv_dtinic)+"' AND '"+DTOS(mv_dtfim)+"' "
		cQuery += " GROUP BY LEFT(SD3.D3_EMISSAO,6), LEFT(D3_CF,2) "
		cQuery += " ) AS MOVDE ON LEFT(SD3.D3_EMISSAO,6)=MOVDE.DTMOV  "
		cQuery += " LEFT OUTER JOIN  "
		cQuery += " ( "
		cQuery += " SELECT  LEFT(SD3.D3_EMISSAO,6) AS DTMOV, LEFT(D3_CF,2) AS TP,  SUM(D3_CUSTO1) AS CUSTO, SUM(D3_QUANT) AS QTD FROM SD3010 (NOLOCK) AS SD3   "
		cQuery += " WHERE  SD3.D3_FILIAL = '"+_cFilDom+"' AND SD3.D_E_L_E_T_='' AND D3_CUSTO1<>0 AND D3_DOC='INVENT' AND LEFT(D3_CF,2)='RE' AND D3_EMISSAO BETWEEN '"+DTOS(mv_dtinic)+"' AND '"+DTOS(mv_dtfim)+"' "
		cQuery += " GROUP BY LEFT(SD3.D3_EMISSAO,6), LEFT(D3_CF,2) "
		cQuery += " )  AS MOVRE ON LEFT(SD3.D3_EMISSAO,6)=MOVRE.DTMOV "
		cQuery += " WHERE  SD3.D3_FILIAL = '"+_cFilDom+"' AND SD3.D_E_L_E_T_='' AND D3_DOC='INVENT' AND D3_CUSTO1<>0  AND D3_EMISSAO BETWEEN '"+DTOS(mv_dtinic)+"' AND '"+DTOS(mv_dtfim)+"' "
		cQuery += " GROUP BY SUBSTRING(SD3.D3_EMISSAO,5,2), LEFT(SD3.D3_EMISSAO,4), MOVRE.CUSTO, MOVDE.CUSTO, MOVRE.QTD, MOVDE.QTD "
		cQuery += " UNION ALL  "
		cQuery += " SELECT 'DET' AS TP, SD3.D3_LOCAL AS ARM, SD3.D3_EMISSAO AS EMI, SD3.D3_FILIAL AS D3_FILIAL, D3_NUMSEQ AS NUMSEQ, SUBSTRING(SD3.D3_EMISSAO,7,2)+'/'+SUBSTRING(SD3.D3_EMISSAO,5,2)+'/'+SUBSTRING(SD3.D3_EMISSAO,1,4) AS DTMOV, D3_COD AS 'PN', D3_TIPO AS 'TIPO' , LEFT(D3_CF,2) AS 'REDE'  , D3_QUANT AS 'QTD',  (D3_CUSTO1) AS 'CUSTODEV', 0 AS 'CUSTOREQ', 0 AS 'DIF' FROM SD3010 (NOLOCK) AS SD3 "
		cQuery += " WHERE  SD3.D3_FILIAL = '"+_cFilDom+"' AND SD3.D_E_L_E_T_='' AND D3_DOC='INVENT' AND LEFT(D3_CF,2)='DE' AND D3_EMISSAO BETWEEN '"+DTOS(mv_dtinic)+"' AND '"+DTOS(mv_dtfim)+"'  "
		cQuery += " UNION ALL  "
		cQuery += " SELECT 'DET' AS TP, SD3.D3_LOCAL AS ARM,  SD3.D3_EMISSAO AS EMI, SD3.D3_FILIAL AS D3_FILIAL, D3_NUMSEQ AS NUMSEQ, SUBSTRING(SD3.D3_EMISSAO,7,2)+'/'+SUBSTRING(SD3.D3_EMISSAO,5,2)+'/'+SUBSTRING(SD3.D3_EMISSAO,1,4) AS DTMOV, D3_COD AS 'PN', D3_TIPO AS 'TIPO' , LEFT(D3_CF,2) AS 'REDE'  , D3_QUANT AS 'QTD',  0 AS 'CUSTODEV',(D3_CUSTO1) AS 'CUSTOREQ', 0 AS 'DIF' FROM SD3010 (NOLOCK) AS SD3  "
		cQuery += " WHERE  SD3.D3_FILIAL = '"+_cFilDom+"' AND SD3.D_E_L_E_T_='' AND D3_DOC='INVENT'  AND LEFT(D3_CF,2)='RE' AND D3_EMISSAO BETWEEN '"+DTOS(mv_dtinic)+"' AND '"+DTOS(mv_dtfim)+"' "
		cQuery += " ) AS INVENT "
		cQuery += " ORDER BY TP, DTMOV DESC "

		If Select("QSBB") <> 0
			QSBB->( dbCloseArea() )
		EndIf

		TCQUERY cQuery NEW ALIAS "QSBB"

		nRecno:=0
		QSBB->( dbEval({|| nRecno++}) )

		ProcRegua(nRecno)

		QSBB->( dbGoTop() )

		AADD(aLinha2, space(20)+"******* INVENTARIO DE PRODUTOS *******")
		AADD(aLinha2, '')
		AADD(aLinha2, '')

		While !QSBB->( EOF() )

			If lEnd
				MsgStop("Processamento cancelado")
				Return
			EndIf

			lERROProd   := .F.

			INCPROC("INVENTARIO DE PRODUTOS - Periodo: " + QSBB->DTMOV )
			cLinha := ""

			If QSBB->TP== "RES"
				AADD(aLinha2, '')
				cLinha += "TOTAL "+QSBB->DTMOV     	 + Space(14-LEN(QSBB->DTMOV))
				cLinha += QSBB->REDE        		 + Space(10      -LEN(QSBB->REDE))
				cLinha += QSBB->ARM         		 + Space(nEspacos-LEN(QSBB->ARM))
				cLinha += Space(32)+Transform(ROUND(QSBB->QTD,2),"@E 99,999,999.99")
				cLinha += Space(8)+Transform(ROUND(QSBB->REQUISICAO+QSBB->DEVOLUCAO,2),"@E 99,999,999.99")

				If nCT2TOT <> ROUND(QSBB->REQUISICAO+QSBB->DEVOLUCAO,2)
					cLinha += Space(70)+Transform(nCT2TOT,"@E 99,999,999.99")+Space(2)+"DIF("+Transform(ROUND(QSBB->REQUISICAO+QSBB->DEVOLUCAO,2)-nCT2TOT,"@E 999,999.99")+")"
				Elseif mv_dif <> 1
					cLinha += Space(70)+Transform(nCT2TOT,"@E 99,999,999.9999")
				Elseif 	mv_dif == 1
					cLinha := ""
				Endif

				AADD(aLinha2, cLinha)
				cLinha := ""
				AADD(aLinha2, cLinha)
				cLinha := "  Qtd DE "  +Transform(ROUND(nQtdCred,2),      "@E 99,999,999.99")  +  "  Vlr DE  "   +Transform(ROUND(nValCred,2),      "@E 99,999,999.99")
				AADD(aLinha2, cLinha)
				cLinha := "  Qtd RE "  +Transform(ROUND(nQtdDeb,2),       "@E 99,999,999.99")  +  "  Vlr RE  "   +Transform(ROUND(nValDeb,2),       "@E 99,999,999.99") + "  Ajuste  " +Transform(ROUND(nValCred-nValDeb,2),  "@E 99,999,999.99")

			Else
				If mv_totais<>1
					cLinha += QSBB->DTMOV     	+ Space(nEspacos-LEN(QSBB->DTMOV))
					cLinha += QSBB->PN		    + Space(nEspacos-LEN(QSBB->PN))
					cLinha += QSBB->TIPO        + Space(nEspacos-LEN(QSBB->TIPO))
					cLinha += QSBB->REDE        + Space(13      -LEN(QSBB->REDE))
					cLinha += QSBB->ARM         + Space(09      -LEN(QSBB->ARM))

					If QSBB->QTD > 0
						cLinha += Transform(QSBB->QTD,  "@E 99,999,999.99")  + Space(nEspacos-LEN(Transform(QSBB->QTD,  "@E 99,999,999.99")))
					Else
						cLinha +=  Space(nEspacos)
					EndIf
					cLinha += Transform(ROUND(QSBB->REQUISICAO+QSBB->DEVOLUCAO,2),"@E 99,999,999.99")  + Space(nEspacos-LEN(Transform(QSBB->REQUISICAO+QSBB->DEVOLUCAO,"@E 99,999,999.99")))
					If QSBB->DIF > 0
						cLinha += Transform(QSBB->DIF,  "@E 99,999,999.99")  + Space(nEspacos-LEN(Transform(QSBB->DIF,       "@E 99,999,999.99")))
					Else
						cLinha +=  Space(3)
					EndIf
				EndIF

				DBSelectArea("CT2")
				DbSetorder(17)
				//D3_FILIAL+D3_COD+D3_LOCAL+DTOS(D3_EMISSAO)+D3_NUMSEQ
				//cChaveOri  := xFilial("CT2")+QSBB->D3_FILIAL+QSBB->PN+SPACE(15-LEN(QSBB->PN))+QSBB->ARM+(QSBB->EMI)+QSBB->NUMSEQ
				cChaveOri  := _cFilDom+QSBB->D3_FILIAL+QSBB->PN+SPACE(15-LEN(QSBB->PN))+QSBB->ARM+(QSBB->EMI)+QSBB->NUMSEQ
				If	CT2->(DbSeek(cChaveOri+SPACE(Len(CT2->CT2_KEY)-len(cChaveOri)))) .and. mv_totais<>1
					cLinha += DTOC(CT2_DATA)+Space(5)+CT2_CREDIT+Space(3)+CT2_DEBITO+Space(2)+Transform(CT2->CT2_VALOR,"@E 99,999,999.99")
				Elseif mv_totais<>1
					cLinha += Space(58)+Transform(0,"@E 99,999,999.99")
				EndIf
				If  CT2->CT2_VALOR<>ROUND(QSBB->REQUISICAO+QSBB->DEVOLUCAO,2)// .and. mv_totais<>1
					cLinha += Space(2)+"DIF("+Transform(ROUND(QSBB->REQUISICAO+QSBB->DEVOLUCAO,2)-CT2->CT2_VALOR,"@E 999,999.99")+")"
				Elseif 	mv_dif == 1
					cLinha := ""
				Endif
				nCT2TOT += CT2_VALOR

				If QSBB->REDE=="RE"
					nValDeb  += QSBB->REQUISICAO
					nQtdDeb  += QSBB->QTD
				Else
					nValCred += QSBB->DEVOLUCAO
					nQtdCred += QSBB->QTD
				EndIf

			EndIf
			If !Empty(cLinha)
				AADD(aLinha2, cLinha)
			EndIf

			QSBB->( dbSkip() )

		End

		If Select("QSBB") <> 0
			QSBB->( dbCloseArea() )
		EndIf
	EndIf


	If mv_mod == 1 //1 - SIM

		aTotMod := {}
		nCT2TOT := 0
		//PARTE 3 MOVIMENTOS MOD
		cQuery := " SELECT * FROM ( "
		cQuery += " SELECT 'RES' AS TP, '' AS EMI, '' AS NUMSEQ, '' AS ARM,'' AS D3_FILIAL,'31/'+SUBSTRING(SD3.D3_EMISSAO,5,2)+'/'+LEFT(SD3.D3_EMISSAO,4) AS DTMOV,D3_COD AS PRODUTO, B1_DESC AS DESCR,'' AS OP, SUM(D3_QUANT) AS TEMPO, '' AS VLRUNIT,  SUM(D3_CUSTO1) AS TOTAL "
		cQuery += " FROM SD3010 (NOLOCK) AS SD3 INNER JOIN SB1010 AS SB1 ON B1_COD=D3_COD "
		cQuery += " WHERE SD3.D3_FILIAL = '"+_cFilDom+"' AND  SD3.D_E_L_E_T_=''  AND (D3_TIPO) IN ('MO') AND D3_CF IN ('RE1', 'RE0') AND D3_EMISSAO BETWEEN '"+DTOS(mv_dtinic)+"' AND '"+DTOS(mv_dtfim)+"' AND D3_ESTORNO='' "
		cQuery += " GROUP BY D3_COD, SUBSTRING(SD3.D3_EMISSAO,5,2), LEFT(SD3.D3_EMISSAO,4), B1_DESC "
		cQuery += " UNION ALL "
		cQuery += " SELECT 'DET' AS TP, D3_EMISSAO AS EMI, D3_NUMSEQ AS NUMSEQ, D3_LOCAL AS ARM, D3_FILIAL,SUBSTRING(SD3.D3_EMISSAO,7,2)+'/'+SUBSTRING(SD3.D3_EMISSAO,5,2)+'/'+SUBSTRING(SD3.D3_EMISSAO,1,4) AS DTMOV,D3_COD AS PRODUTO, B1_DESC AS DESCR, D3_OP AS OP, D3_QUANT AS TEMPO,  (CASE WHEN D3_CUSTO1<>0 AND D3_QUANT<>0 THEN D3_CUSTO1/D3_QUANT ELSE 0 END) AS VLRUNIT,  D3_CUSTO1 AS TOTAL "
		cQuery += " FROM SD3010 (NOLOCK) AS SD3  INNER JOIN SB1010 AS SB1 ON B1_COD=D3_COD "
		cQuery += " WHERE SD3.D3_FILIAL = '"+_cFilDom+"' AND  SD3.D_E_L_E_T_=''  AND (D3_TIPO) IN ('MO') AND D3_CF IN ('RE1', 'RE0') AND D3_EMISSAO BETWEEN '"+DTOS(mv_dtinic)+"' AND '"+DTOS(mv_dtfim)+"'  AND D3_ESTORNO='' "
		cQuery += " ) MODMOD "
		cQuery += " ORDER BY DTMOV, PRODUTO, TP DESC "

		If Select("QSBC") <> 0
			QSBC->( dbCloseArea() )
		EndIf

		TCQUERY cQuery NEW ALIAS "QSBC"

		nRecno:=0
		QSBC->( dbEval({|| nRecno++}) )

		ProcRegua(nRecno)

		QSBC->( dbGoTop() )

		AADD(aLinha3, space(20)+"******* MAO - DE - OBRA *******")
		AADD(aLinha3, '')
		AADD(aLinha3, '')



		While !QSBC->( EOF() )

			cLinha := ""

			If lEnd
				MsgStop("Processamento cancelado")
				Return
			EndIf

			lERROProd   := .F.

			INCPROC("MAO  DE  OBRA - Periodo: " + QSBC->DTMOV )

			If QSBC->TP== "RES"
				AADD(aLinha3, '')

				cLinha += "TOTAL "+SUBSTR(QSBC->DTMOV,4,7)  + Space(14-LEN(QSBC->DTMOV))
				cLinha += QSBC->PRODUTO     					  + Space(nEspacos-LEN(QSBC->PRODUTO))
				cLinha += QSBC->DESCR        					  + Space(nEspacos+nEspacos-LEN(QSBC->DESCR))
				cLinha += RTRIM(QSBC->OP)     				  + Space(3)

				If QSBC->TEMPO > 0
					cLinha += Space(14) + Transform(QSBC->TEMPO,   "@E 999,999.99")  	+ Space(11)
				Else
					cLinha +=  Space(12)
				EndIf
				If QSBC->VLRUNIT > 0
					cLinha += Transform(QSBC->VLRUNIT, "@E 999,999.99")  	+ Space(5)
				Else
					cLinha +=  Space(5)
				EndIf
				cLinha += Transform(QSBC->TOTAL,       "@E 999,999.99")    	+ Space(5)

			Else
				If mv_totais<>1
					cLinha += QSBC->DTMOV     	+ Space(nEspacos-LEN(QSBC->DTMOV))
					cLinha += QSBC->PRODUTO     + Space(nEspacos-LEN(QSBC->PRODUTO))
					cLinha += QSBC->DESCR       + Space(nEspacos+nEspacos-LEN(QSBC->DESCR))
					cLinha += RTRIM(QSBC->OP)   + Space(3)

					If QSBC->TEMPO > 0
						cLinha += Transform(QSBC->TEMPO,       "@E 999,999.99")  + Space(3)
					Else
						cLinha +=  Space(12)
					EndIf
					If QSBC->VLRUNIT > 0
						cLinha += Transform(QSBC->VLRUNIT,      "@E 999,999.99") + Space(3)
					Else
						cLinha +=  Space(12)
					EndIf
					cLinha += Transform(QSBC->TOTAL,            "@E 999,999.99") + Space(3)
				    /*
					for nAux := 1 to len(aTotMod)
					nPos := ASCAN(aTotMod, {|x| x[1] == QSBC->PRODUTO})   
						IF ASCAN(aTotMod, {|x| x[1] == QSBC->PRODUTO}) > 0
						cLinha += Transform(aTotMod[nAux][2],            "@E 999,999.99") + Space(3) 		
						Endif
					next nAux
                  */
				Endif

				DBSelectArea("CT2")
				DbSetorder(17)
				//D3_FILIAL+D3_COD+D3_LOCAL+DTOS(D3_EMISSAO)+D3_NUMSEQ
				//cChaveOri := xFilial("CT2")+QSBC->D3_FILIAL+QSBC->PRODUTO+SPACE(15-LEN(QSBC->PRODUTO))+QSBC->ARM+(QSBC->EMI)+QSBC->NUMSEQ
				cChaveOri := cFilDom+QSBC->D3_FILIAL+QSBC->PRODUTO+SPACE(15-LEN(QSBC->PRODUTO))+QSBC->ARM+(QSBC->EMI)+QSBC->NUMSEQ
				If	CT2->(DbSeek(cChaveOri+SPACE(Len(CT2->CT2_KEY)-len(cChaveOri)))) .and. mv_totais<>1
					cLinha += DTOC(CT2_DATA)+Space(5)+RTRIM(CT2_CREDIT)+Space(3)+RTRIM(CT2_DEBITO)+Space(2)+Transform(CT2->CT2_VALOR,"@E 999,999.99")
				Elseif mv_totais<>1
					cLinha += Space(58)+Transform(0,"@E 999,999.99")
				EndIf
				If  CT2->CT2_VALOR<>ROUND(QSBC->TOTAL,2) .and. mv_totais<>1
					cLinha += Space(2)+"DIF("+Transform(ROUND(QSBC->TOTAL,2)-CT2->CT2_VALOR,"@E 999,999.99")+")"
				Elseif 	mv_dif == 1
					cLinha := ""
				Endif
				nCT2TOT += CT2_VALOR
				/*
				If len(aTotMod) >0
					If Empty(AsCan(aTotMod,QSBC->PRODUTO))
					   	AADD(aTotMod, QSBC->PRODUTO, CT2_VALOR )   
					Else
					    	aTotMod[AsCan(aTotMod,QSBC->PRODUTO)][2] := aTotMod[AsCan(aTotMod,QSBC->PRODUTO)][2] + CT2_VALOR					 
					EndIf
				Else
					AADD(aTotMod, QSBC->PRODUTO, CT2_VALOR )
				EndIf
			     
				for nAux := 1 to len(aTotMod)
				
					nPos := ASCAN(aTotMod, {|x| x[1] == QSBC->PRODUTO})   
					IF ASCAN(aTotMod, {|x| x[1] == QSBC->PRODUTO}) > 0
					aTotMod[nAux][2] +=  CT2_VALOR
					else
					AADD(aTotMod, QSBC->PRODUTO, CT2_VALOR )  
					endif
					
				next nAux
              */

			EndIf

			If !Empty(cLinha)
				AADD(aLinha3, cLinha)
			EndIf
			
			
			If  QSBC->TP== "RES" .and. ALLTRIM(QSBC->PRODUTO) == '50010100CORTE' .and. !lImpFam
				aFam:= fFamily(ALLTRIM(QSBC->PRODUTO))
				If Len(aFam)> 0
					AADD(aLinha3, space(17)+Replicate('-',80))
					AADD(aLinha3,  space(17)+"Famํlia  |Descri็ใo          |Tempo          |Total")
					AADD(aLinha3, space(17)+Replicate('-',80))
					for _i:= 1 to len(aFam)
						cLinha :=  space(17)+Padr(aFam[_i,1],9)+"|"
						cLinha += Substring(aFam[_i,2],1,19)+"|"
						cLinha += Transform(aFam[_i,3],       "@E 999,999.99")+ Space(5)+ "|"
						cLinha += Transform(aFam[_i,4],       "@E 999,999.99")+ Space(5)+"|"
						If !Empty(cLinha)
							AADD(aLinha3, cLinha)
						EndIf
					Next _i
					AADD(aLinha3, space(17)+Replicate('-',80))
					cLinha:= ""
					
				lImpFam:= .T.
				Endif
			Endif

			QSBC->( dbSkip() )

		End

		If Select("QSBC") <> 0
			QSBC->( dbCloseArea() )
		EndIf

	EndIf

	If mv_ctbsmov==1

		cQuery := " SELECT CT2_DATA, CT2_CREDIT, CT2_DEBITO, CT2_VALOR, CT2_LP+'/'+CT2_SEQLAN +'   '+ CT2_LOTE +'   '+ CT2_DOC +'   '+ CT2_LINHA AS LANPAD "
		cQuery += " FROM CT2010 (NOLOCK) WHERE CT2_FILIAL = '"+_cFilDom+"' AND  CT2_DATA BETWEEN '"+DTOS(mv_dtinic)+"' AND '"+DTOS(mv_dtfim)+"' AND ( ( CT2_LP = '666' AND CT2_SEQLAN='008' ) OR ( CT2_LP = '666' AND CT2_SEQLAN='009' ) OR ( CT2_LP = '668' AND CT2_SEQLAN='003' ) OR ( CT2_LP = '670' AND CT2_SEQLAN='007' )  ) "
		cQuery += " AND RTRIM(CT2_KEY) NOT IN "
		cQuery += " ( SELECT D3_FILIAL+D3_COD+D3_LOCAL+D3_EMISSAO+D3_NUMSEQ FROM SD3010 (NOLOCK) WHERE D3_FILIAL = '"+_cFilDom+"' AND  D_E_L_E_T_='' AND D3_EMISSAO BETWEEN '"+DTOS(mv_dtinic)+"' AND '"+DTOS(mv_dtfim)+"' AND D3_ESTORNO='' ) "


		If Select("QSBD") <> 0
			QSBD->( dbCloseArea() )
		EndIf

		TCQUERY cQuery NEW ALIAS "QSBD"

		nRecno:=0
		QSBD->( dbEval({|| nRecno++}) )

		ProcRegua(nRecno)

		QSBD->( dbGoTop() )

		AADD(aLinha4, space(20)+"******* CONTABIL SEM MOVIMENTO *******")
		AADD(aLinha4, '')
		AADD(aLinha4, '')

		While !QSBD->( EOF() )

			cLinha := ""
			If lEnd
				MsgStop("Processamento cancelado")
				Return
			EndIf

			lERROProd   := .F.
			INCPROC("CONTABIL SEM MOVIMENTO - Periodo: " + QSBD->CT2_DATA )

			cLinha += QSBD->CT2_DATA  + Space(nEspacos-LEN(QSBD->CT2_DATA))
			cLinha += Transform(QSBD->CT2_VALOR,"@E 999,999.9999")   + Space(nEspacos-LEN(Transform(QSBD->CT2_VALOR,"@E 999,999.9999")))
			cLinha += QSBD->CT2_CREDIT       + Space(nEspacos-LEN(QSBD->CT2_CREDIT))
			cLinha += QSBD->CT2_DEBITO       + Space(nEspacos-LEN(QSBD->CT2_DEBITO))
			cLinha += QSBD->LANPAD           + Space(nEspacos-LEN(QSBD->LANPAD))

			If !Empty(cLinha)
				AADD(aLinha4, cLinha)
			EndIf

			QSBD->(DbSkip())
		End

		If Select("QSBD") <> 0
			QSBD->( dbCloseArea() )
		endIf


	EndIf

	For x := 1 to Len(aLinha1)
		If nLin > 58
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		EndIf
		@ nLin, 000 pSay aLinha1[x]
		nLin++
	Next x
	titulo      := "Contabilidade x Movimentos - Inventแrio"
	Cabec1      := "DTMOV               PRODUTO             TIPO                RE/DE        ARM         QUANTIDADE          CUSTO-MOV        DATA CONTABIL    CTA-CREDITO           CTA-DEBITO          VALOR CONTABIL   "
	nLin := 59

	For x := 1 to Len(aLinha2)
		If nLin > 58
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		EndIf
		@ nLin, 000 pSay aLinha2[x]
		nLin++
	Next x

	titulo      := "Contabilidade x Movimentos - MOD"
	Cabec1      := "DTMOV               PRODUTO             DESCRICAO                                                    OP               TEMPO    VALOR-UNIT      TOTAL     DT-CONTABIL   CTA-CREDITO   CTA-DEBITO  VLR-CONTABIL"
	nLin := 59

	For x := 1 to Len(aLinha3)
		If nLin > 58
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		EndIf
		@ nLin, 000 pSay aLinha3[x]
		nLin++
	Next x

	titulo      := "Contabilidade x Movimentos - Contabil sem Movimento"
	Cabec1      := "DATA                   VALOR           CONTA CREDITO       CONTA DEBITO          LP       LOTE     DOC     LINHA"
	nLin := 59

	For x := 1 to Len(aLinha4)
		If nLin > 58
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		EndIf
		@ nLin, 000 pSay aLinha4[x]
		nLin++
	Next x

Return



//mv_do_prod := mv_par01
//mv_ate_pro := mv_par02
//mv_da_op   := mv_par03
//mv_ate_op  := mv_par04
//mv_dtinic  := mv_par05
//mv_dtfim   := mv_par06
//mv_transpn := mv_par07
//mv_invent  := mv_par08
//mv_mod     := mv_par09



Static Function fCriaPerg()
	aSvAlias:={Alias(),IndexOrd(),Recno()}
	i:=j:=0
	aRegistros:={}
	cPerg := PADR(cPerg,10)
//                1      2    3                  4  5      6     7  8  9  10  11  12 13     14  15    16 17 18 19 20     21  22 23 24 25   26 27 28 29  30       31 32 33 34 35  36 37 38 39    40 41 42 43 44
//AADD(aRegistros,{_cPerg,"01","Do  Produto   ?","","","mv_ch1","C",15,00,00,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","","",""})
//AADD(aRegistros,{_cPerg,"02","At้ Produto   ?","","","mv_ch2","C",15,00,00,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","","",""})
//AADD(aRegistros,{_cPerg,"01","Do  Requisitante?","","","mv_ch1","C",08,00,00,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//AADD(aRegistros,{_cPerg,"02","At้ Requisitante?","","","mv_ch2","C",08,00,00,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//AADD(aRegistros,{_cPerg,"03","De  Expedi็ใo    ?","","","mv_ch3","D",08,00,00,"G","","mv_par03",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","","","","","",""})
	AADD(aRegistros,{cPerg,"05","De  Data 			 ?","","","mv_ch5","D",08,00,00,"G","","mv_par05",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","","","","","",""})
	AADD(aRegistros,{cPerg,"06","At้ Data 			 ?","","","mv_ch6","D",08,00,00,"G","","mv_par06",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","","","","","",""})
	AADD(aRegistros,{cPerg,"07","Transferencia PN    ?","","","mv_ch7","N",01,00,00,"C","","mv_par07","1 - Sim"    ,"","","","","2 - Nao"   ,"","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegistros,{cPerg,"08","Inventario 		 ?","","","mv_ch8","N",01,00,00,"C","","mv_par08","1 - Sim"    ,"","","","","2 - Nao"   ,"","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegistros,{cPerg,"09","MOD                 ?","","","mv_ch9","N",01,00,00,"C","","mv_par09","1 - Sim"    ,"","","","","2 - Nao"   ,"","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegistros,{cPerg,"10","S๓ Totais 		     ?","","","mv_ch10","N",01,00,00,"C","","mv_par10","1 - Sim"    ,"","","","","2 - Nao"   ,"","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegistros,{cPerg,"11","S๓ com diferenca    ?","","","mv_ch11","N",01,00,00,"C","","mv_par11","1 - Sim"    ,"","","","","2 - Nao"   ,"","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegistros,{cPerg,"12","Contabil s/ Movto   ?","","","mv_ch12","N",01,00,00,"C","","mv_par12","1 - Sim"    ,"","","","","2 - Nao"   ,"","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegistros,{cPerg,"13","Empresa		     ?","","","mv_ch13","N",01,00,00,"C","","mv_par13","1 - Matriz"    ,"","","","","2 - Filial MG"   ,"","","","","","","","","","","","","","","","","","","","","","","",""})



	DbSelectArea("SX1")
	For i := 1 to Len(aRegistros)
		If !dbSeek(aRegistros[i,1]+aRegistros[i,2])
			While !RecLock("SX1",.T.)
			End
			For j:=1 to FCount()
				FieldPut(j,aRegistros[i,j])
			Next
			MsUnlock()
		Endif
	Next i

	dbSelectArea(aSvAlias[1])
	dbSetOrder(aSvAlias[2])
	dbGoto(aSvAlias[3])
Return(Nil)



Static Function fFamily(_Mod)
	Local aDados:={}

	cQuery:= " SELECT B1_GRUPO GRUPO,BM_DESC DESCR, SUM(D3_QUANT) TOTALQ ,  SUM(D3_CUSTO1) TOTALV  FROM SD3010 SD3"
	cQuery+= " INNER JOIN "+RetSqlName("SC2")+" SC2 ON C2_FILIAL = '"+_cFilDom+"' AND C2_NUM+C2_ITEM+C2_SEQUEN = D3_OP AND SC2.D_E_L_E_T_ = ''"
	cQuery+= " INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_COD = C2_PRODUTO AND SB1.D_E_L_E_T_ = ''"
	cQuery+= " INNER JOIN "+RetSqlName("SBM")+" SBM ON BM_FILIAL = '"+_cFilDom+"' AND  BM_GRUPO = B1_GRUPO AND SBM.D_E_L_E_T_ = ''"
	cQuery+= " WHERE SD3.D3_FILIAL = '"+_cFilDom+"' AND D3_COD = '"+Alltrim(_Mod)+"'"
	cQuery+= " AND SD3.D_E_L_E_T_ = ''"
	cQuery+= " AND D3_EMISSAO BETWEEN '"+DTOS(mv_dtinic)+"' AND '"+DTOS(mv_dtfim)+"' "
	cQuery+= " AND D3_TIPO = 'MO'  "
	cQuery+= " AND D3_CF IN ( 'RE1', 'RE0' ) "
	cQuery+= " AND D3_ESTORNO = '' "
	cQuery+= " GROUP BY B1_GRUPO, BM_DESC "

	If Select("QFAM") <> 0
		QFAM->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS "QFAM"

	While QFAM->(!eof())
		Aadd(aDados,{QFAM->GRUPO,QFAM->DESCR,QFAM->TOTALQ, QFAM->TOTALV})
		QFAM->(dbSkip())
	End

Return aDados
