#include "totvs.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO10    ºAutor  ³Hélio Ferreira      º Data ³  27/10/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Apontamento de produção totalmente personalizado para a    º±±
±±º          ³ Domex. Deve ser usado temporariamente, até se resolver     º±±
±±º          ³ a questão de demora do apontamento padrão                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FC2_QUJE(cOP)

	Default cOP := ""

	RPCSetType(3)
	aAbreTab := {}
	RpcSetEnv("01","01",,,,,aAbreTab)

	cQuery := "SELECT * FROM "
	cQuery += "( "
	cQuery += "SELECT C2_FILIAL, C2_QUANT, C2_QUJE,C2_NUM, C2_ITEM, C2_SEQUEN,C2_NUM+C2_ITEM+C2_SEQUEN AS C2OP, "
	cQuery += "ISNULL((SELECT SUM(D3_QUANT) FROM "+RetSqlName("SD3")+" (NOLOCK) WHERE D3_FILIAL = C2_FILIAL AND D3_OP = C2_NUM+C2_ITEM+C2_SEQUEN "
	cQuery += "AND D3_TM = '010' AND D3_ESTORNO = '' AND D_E_L_E_T_=''),0) AS D3_APTO "
	cQuery += ",(SELECT MAX(D3_EMISSAO) FROM SD3010 (NOLOCK) WHERE D3_FILIAL = C2_FILIAL AND D3_OP = C2_NUM+C2_ITEM+C2_SEQUEN AND D3_TM = '010' AND D3_ESTORNO = '' AND D_E_L_E_T_='' ) AS D3EMISSAO "
	cQuery += "FROM "+RetSqlName("SC2")+" (NOLOCK) WHERE   "
	cQuery += "(C2_DATRF = '' OR C2_EMISSAO > '"+DtoS(Date()-7)+"') AND D_E_L_E_T_ = ''  "
	If !Empty(cOP)
		cQuery += "AND C2_NUM+C2_ITEM+C2_SEQUEN = '"+cOP+"' "
	EndIf
	cQuery += ") TMP "
	cQuery += "WHERE C2_QUJE <> D3_APTO "

	If Select("QC2") <> 0
		QC2->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS "QC2"

	While !QC2->( EOF() )
		
		If QC2->D3_APTO  >= QC2->C2_QUANT
			cUpdate := "UPDATE " + RetSqlName("SC2") + " SET C2_QUJE = " + Alltrim(Str(QC2->D3_APTO)) + ", "
			cUpdate += "C2_DATRF =        '"+QC2->D3EMISSAO+"' "
			cUpdate += "WHERE C2_FILIAL = '"+QC2->C2_FILIAL+"' "
			cUpdate += "AND C2_NUM =      '"+QC2->C2_NUM+"' "
			cUpdate += "AND C2_ITEM =     '"+QC2->C2_ITEM+"' "
			cUpdate += "AND C2_SEQUEN =   '"+QC2->C2_SEQUEN+"' "
			cUpdate += "AND D_E_L_E_T_ = '' "
		Else
			cUpdate := "UPDATE " + RetSqlName("SC2") + " SET C2_QUJE = " + Alltrim(Str(QC2->D3_APTO)) + ", "
			cUpdate += "C2_DATRF =        '' "
			cUpdate += "WHERE C2_FILIAL = '"+QC2->C2_FILIAL+"' "
			cUpdate += "AND C2_NUM =      '"+QC2->C2_NUM+"' "
			cUpdate += "AND C2_ITEM =     '"+QC2->C2_ITEM+"' "
			cUpdate += "AND C2_SEQUEN =   '"+QC2->C2_SEQUEN+"' "
			cUpdate += "AND D_E_L_E_T_ = '' "
		EndIf

		TCSQLEXEC(cUpdate)

		If Alltrim(QC2->C2OP )  <> '10343702008'
			cAssunto := "Domex - Erro na gravacao do C2_QUJE"

			cTxtMsg  := " OP : "          + QC2->C2OP                                      + Chr(13)
			cTxtMsg  += " QTD APTO SD3: " + Transform(QC2->D3_APTO ,"@E 999,999,999.9999") + Chr(13)
			cTxtMsg  += " C2_QUJE: "      + Transform(QC2->C2_QUJE ,"@E 999,999,999.9999") + Chr(13)
			cTxtMsg  += " C2_QUANT: "     + Transform(QC2->C2_QUANT,"@E 999,999,999.9999") + Chr(13)
			cTxtMsg  += Chr(13) + Chr(13)
			cTxtMsg  += "OP CORRIGIDA!"

			cTexto   := StrTran(cTxtMsg,Chr(13),"<br>")
			cPara    := 'denis.vieira@rosenbergerdomex.com.br;fulgencio.muniz@rosenbergerdomex.com.br'
			cCC      := 'helio@opusvp.com.br'
			cArquivo := Nil
            
            U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
		EndIf

		QC2->( dbSkip() )
	End

	If Select("QC2") <> 0
		QC2->( dbCloseArea() )
	EndIf

Return
