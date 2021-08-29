#INCLUDE "TOTVS.CH" 
#INCLUDE "TOPCONN.CH"  

#DEFINE HUAWEI "HUAWEI"  
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PE01NFESEFAZ ºAutor  ³Michel Sander    º Data ³  11/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada no NFESEFAZ para calcular o volume        º±±
±±º          ³ ADEQUADO PARA VERSAO 4.00 -  EM 31/07/2018                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PE01NFESEFAZ()

LOCAL cIn 		  := ""
LOCAL nQtCxCord  := 0
LOCAL nTotLiq    := 0
LOCAL nTotBru    := 0
LOCAL aProdHuawe := {}
Local nVolumes   := 0
Local lRevenda   := .F.
Local lCalcVol   := .F.
Local nPesEmbFin := 0
Local cTxtMsg    :=''
LOCAL lExpedicao := GETMV("MV_XXLDANF")	// Parametro que ativa as customizacoes da expedicao na DANFE     
LOCAL lTES999	  := .F.				// Impede Faturamento pela TES 999 (usada na TES Inteligente)


TCSQLEXEC("UPDATE SPED000 SET CONTEUDO = 1 WHERE PARAMETRO = 'MV_NFEDISD' AND CONTEUDO = 0")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Verifica Importação				 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

If ALLTRIM(aParam[4,9]) == "EX" .And. ALLTRIM(aParam[5,4]) == "0" .And. ALLTRIM(aParam[5,5]) == "C" // 0=Entrada 1=Saida   // F1_TIPO = 'C' - Complemento de Preço
	Return(aParam)
EndIf

If ALLTRIM(aParam[4,9]) == "EX" .And. ALLTRIM(aParam[5,4]) == "0"
	Return(aParam)
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Verifica cliente HUAWEI			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If Type("aParam[4,2]") <> "U"
	lHuawei := IF(HUAWEI $ ALLTRIM(aParam[4,2]), .T., .F.)
Else
	lHuawei := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Verifica os itens da nota fiscal³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
SB1->( dbSetOrder(1) )
SG1->( dbSetOrder(1) )
aProNoBru  := {}
aPrNoCxEst := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³HUAWEI								  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If !lHuawei
	For i:= 1 To Len(aParam[1])
		If !Empty(aParam[1][i][2])
			If SB1->( dbSeek( xFilial() + aParam[1][i][2] ) )
				// Peso
				If !Empty(SB1->B1_PESBRU)
					nTotBru   += SB1->B1_PESBRU * aParam[1][i][9]
					If !Empty(SB1->B1_PESO)
						nTotLiq   += SB1->B1_PESO           * aParam[1][i][9]
					Else
						nTotLiq   += (SB1->B1_PESBRU * 0.9) * aParam[1][i][9]
					EndIf
					AADD(aProNoBru,SB1->B1_COD)
				Else
					AADD(aProNoBru,SB1->B1_COD)
				EndIf
				
				//Volume
				If !(SB1->B1_TIPO $ "PI,MP,PR")
					lCalcVol := .T.
					If SB1->B1_GRUPO == 'CORD'
						If SG1->( dbSeek( xFilial() + aParam[1][i][2] + "50007222221080" ) )  // Produto Caixa (primeira embalagem)
							If SG1->G1_QUANT <> 0
								If Int(SG1->G1_QUANT * aParam[1][i][9]) <> (SG1->G1_QUANT * aParam[1][i][9])
									nQtCxCord  := Int(SG1->G1_QUANT * aParam[1][i][9]) + 1
								Else
									nQtCxCord  := SG1->G1_QUANT * aParam[1][i][9]
								EndIf
							Else
								If aScan(aPrNoCxEst,aParam[1][i][2]) == 0
									AADD(aPrNoCxEst,aParam[1][i][2])
								EndIf
							EndIf
						Else
							If SG1->( dbSeek( xFilial() + aParam[1][i][2] + "5000753354510" ) )  // Cabo muito grande, vai em saco plástico.
								nVolumes += aParam[1][i][9]
							Else
								AADD(aPrNoCxEst,aParam[1][i][2])
							EndIf
						EndIf
					Else
						nVolumes += aParam[1][i][9]
					EndIf
				Else
					lRevenda := .T.
				EndIf
			EndIf
		EndIf
	Next
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Calculo do Volume   				³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	// Clientes padrões
	If lCalcVol
		nPesEmbFin := 0
		While nQtCxCord > 0
			If nQtCxCord >= 19                       // 5000723684638     1,34 kg
				nVolumes++
				nQtCxCord  -= 28
				nPesEmbFin += 1.34
				Loop
			EndIf
			If nQtCxCord >= 11 .And. nQtCxCord <= 18 //  5000723474739    1,12 kg
				nVolumes++
				nQtCxCord  -= 18
				nPesEmbFin += 1.12
				Loop
			EndIf
			If nQtCxCord >= 7 .And. nQtCxCord <= 10  //  5000720462539    0,3 kg
				nVolumes++
				nQtCxCord  -= 10
				nPesEmbFin += 0.3
				Loop
			EndIf
			If nQtCxCord >= 4 .And. nQtCxCord <= 6   //  5000720262642    0,74 kg
				nVolumes++
				nQtCxCord  -= 6
				nPesEmbFin += 0.74
				Loop
			EndIf
			If nQtCxCord >= 2 .And. nQtCxCord <= 3   //  5000723292520    0,36 kg
				nVolumes++
				nQtCxCord  -= 3
				nPesEmbFin += 0.36
				Loop
			EndIf
			If nQtCxCord == 1                        //  5000723282512    0,28 kg
				nVolumes++
				nQtCxCord  -= 1
				nPesEmbFin += 0.28
				Loop
			EndIf
		EndDo
		If lRevenda  // Se tem outros tipos de materiais que não revenda, entra aqui. Mas se além desses, tiver revenda, soma 1 no volume (referente a revenda)
			nVolumes++
		EndIf
	Else
		If lRevenda  // Se só tiver revenda, volume igual a 1
			nVolumes := 1
		EndIf
	EndIf
	
Else // Else do If !lHuawei
	
	// Inserido por Michel Sander em 29.01.2015 para não aglutinar mais itens iguais para clientes HUAWUEI
	For i:= 1 To Len(aParam[1])
		If !Empty(aParam[1][i][2])
			AADD( aProdHuawe, { aParam[1][i][2], aParam[1][i][9] } )
		EndIf
	Next i
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Acumula os Volumes para cliente	HUAWUEI  							³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	nPesEmbFin := 0
	For Q := 1 to Len(aProdHuawe)
		If SB1->( dbSeek( xFilial() + aProdHuawe[Q,1] ) )
			// Peso
			If !Empty(SB1->B1_PESBRU)
				//				nTotBru   += SB1->B1_PESBRU * aProdHuawe[Q,2]
				nTotBru   += SF2->F2_PBRUTO //SB1->B1_PESBRU * aProdHuawe[Q,2]				//MAS
				If !Empty(SB1->B1_PESO)
					nTotLiq   += SB1->B1_PESO           * aProdHuawe[Q,2]
				Else
					nTotLiq   += (SB1->B1_PESBRU * 0.9) * aProdHuawe[Q,2]
				EndIf
			Else
				AADD(aProNoBru,SB1->B1_COD)
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Calculo do Volume   				³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			// Cliente Huawei
			If SB1->B1_GRUPO == 'CORD'
				If SG1->( dbSeek( xFilial() + aProdHuawe[Q,1] + "50007222221080" ) )  // Produto Caixa (primeira embalagem)
					If SG1->G1_QUANT <> 0
						If Int(SG1->G1_QUANT * aProdHuawe[Q,2]) <> (SG1->G1_QUANT * aProdHuawe[Q,2])
							nQtCxCord  := Int(SG1->G1_QUANT * aProdHuawe[Q,2]) + 1
						Else
							nQtCxCord  := SG1->G1_QUANT * aProdHuawe[Q,2]
						EndIf
					Else
						If aScan(aPrNoCxEst,aProdHuawe[Q,1]) == 0
							AADD(aPrNoCxEst,aProdHuawe[Q,1])
						EndIf
					EndIf
				Else
					If SG1->( dbSeek( xFilial() + aProdHuawe[Q,1] + "5000753354510" ) )  // Cabo muito grande, vai em saco plástico.
						nVolumes += aProdHuawe[Q,2]
					Else
						AADD(aPrNoCxEst,aProdHuawe[Q,1])
					EndIf
				EndIf
				//nQtCxCord := aProdHuawe[Q,2]
				While nQtCxCord > 0
					If nQtCxCord >= 19                       // 5000723684638     1,34 kg
						nVolumes++
						nQtCxCord  -= 28
						nPesEmbFin += 1.34
						Loop
					EndIf
					If nQtCxCord >= 11 .And. nQtCxCord <= 18 //  5000723474739    1,12 kg
						nVolumes++
						nQtCxCord  -= 18
						nPesEmbFin += 1.12
						Loop
					EndIf
					If nQtCxCord >= 7 .And. nQtCxCord <= 10  //  5000720462539    0,3 kg
						nVolumes++
						nQtCxCord  -= 10
						nPesEmbFin += 0.3
						Loop
					EndIf
					If nQtCxCord >= 4 .And. nQtCxCord <= 6   //  5000720262642    0,74 kg
						nVolumes++
						nQtCxCord  -= 6
						nPesEmbFin += 0.74
						Loop
					EndIf
					If nQtCxCord >= 2 .And. nQtCxCord <= 3   //  5000723292520    0,36 kg
						nVolumes++
						nQtCxCord  -= 3
						nPesEmbFin += 0.36
						Loop
					EndIf
					If nQtCxCord == 1                        //  5000723282512    0,28 kg
						nVolumes++
						nQtCxCord  -= 1
						nPesEmbFin += 0.28
						Loop
					EndIf
				EndDo
				
			Else
				
				//--> Inserido por Michel A. Sander em 29.01.2015 para tratamento de D.O
				If SG1->( dbSeek( xFilial() + aProdHuawe[Q,1] + "5000722281465" ) )  // Produto Caixa (Cx Papelao Semi-KRA DUP 280x140x6)
					If SG1->G1_QUANT <> 0
						If Int(SG1->G1_QUANT * aProdHuawe[Q,2]) <> (SG1->G1_QUANT * aProdHuawe[Q,2])
							nQtCxCord  := Int(SG1->G1_QUANT * aProdHuawe[Q,2]) + 1
						Else
							nQtCxCord  := SG1->G1_QUANT * aProdHuawe[Q,2]
						EndIf
					Else
						If aScan(aPrNoCxEst,aProdHuawe[Q,1]) == 0
							AADD(aPrNoCxEst,aProdHuawe[Q,1])
						EndIf
					EndIf
					
					While nQtCxCord > 0
						If nQtCxCord >= 15                       // 5000723684638     1,34 kg
							nVolumes++
							nQtCxCord  -= 26
							nPesEmbFin += 1.34
							Loop
						EndIf
						If nQtCxCord >= 10 .And. nQtCxCord <= 14 //  5000723474739    1,12 kg
							nVolumes++
							nQtCxCord  -= 14
							nPesEmbFin += 1.12
							Loop
						EndIf
						If nQtCxCord >= 5 .And. nQtCxCord <= 9  //  5000720462539    0,3 kg
							nVolumes++
							nQtCxCord  -= 9
							nPesEmbFin += 0.3
							Loop
						EndIf
						If nQtCxCord == 4							   //  5000720262642    0,74 kg
							nVolumes++
							nQtCxCord  -= 4
							nPesEmbFin += 0.74
							Loop
						EndIf
						If nQtCxCord >= 1 .And. nQtCxCord <= 3   //  5000723292520    0,36 kg
							nVolumes++
							nQtCxCord  -= 3
							nPesEmbFin += 0.36
							Loop
						EndIf
					EndDo
					
				EndIf
				
				If SB1->B1_GRUPO == 'JUMP'
					If SG1->( dbSeek( xFilial() + aProdHuawe[Q,1] + "50007235353345"))
						If (aProdHuawe[Q,2] * SG1->G1_QUANT) == Int(aProdHuawe[Q,2] * SG1->G1_QUANT)
							nVolumes += aProdHuawe[Q,2] * SG1->G1_QUANT
						Else
							nVolumes += Int(aProdHuawe[Q,2] * SG1->G1_QUANT) + 1
						EndIf
					Else
						cTexto := "Produto " + aProdHuawe[Q,1] + " para o cliente Huawei sem embalagem na Estrutura de Produtos."
						MsgStop(cTexto)
						cAssunto := "Falta de embalagem na Estrutura de Produtos - NF: " + aParam[5][2] + Chr(13)
						cTxtMsg  := cAssunto
						cTexto   := StrTran(cTxtMsg,Chr(13),"<br>")
						cPara    := 'fabiana.santos@rosenbergerdomex.com.br;tatiane.alves@rosenbergerdomex.com.br;denis.vieira@rdt.com.br;carlos.sepinho@rosenbergerdomex.com.br;tatiane.alvez@rosenbergerdomex.com.br;luiz.pavret@rdt.com.br;'
						cCC      := ""
						cArquivo := Nil
						U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
						lAborta  := .T.
					EndIf
				Else
					IF SB1->B1_GRUPO == 'DIOE' .AND. SUBSTR(SB1->B1_COD,1,2)=='13'
						If SG1->( dbSeek( xFilial() + aProdHuawe[Q,1] + "50007222221080"))    //CX PAPELAO DUP 220X210X80MM
							If (aProdHuawe[Q,2] * SG1->G1_QUANT) == Int(aProdHuawe[Q,2] * SG1->G1_QUANT)
								nVolumes += aProdHuawe[Q,2] * SG1->G1_QUANT
							Else
								nVolumes += Int(aProdHuawe[Q,2] * SG1->G1_QUANT) + 1
							EndIf
						Else
							cTexto := "Produto " + aProdHuawe[Q,1] + " para o cliente Huawei sem embalagem na Estrutura de Produtos."
							MsgStop(cTexto)
							cAssunto := "Falta de embalagem na Estrutura de Produtos - NF: " + aParam[5][2] + Chr(13)
							cTxtMsg  := cAssunto
							cTexto   := StrTran(cTxtMsg,Chr(13),"<br>")
							cPara    := 'fabiana.santos@rosenbergerdomex.com.br;denis.vieira@rdt.com.br;carlos.sepinho@rosenbergerdomex.com.br;tatiane.alves@rosenbergerdomex.com.br;luiz.pavret@rdt.com.br;'
							cCC      := ''
							cArquivo := Nil
							U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
							lAborta  := .T.
						EndIf
					Else
						//?
					ENDIF
				EndIf
			EndIf
		EndIf
	Next
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Verifica existencia de peso 					  							³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
lAborta  := .F.

/*
If Len(aProNoBru) > 0
cTxtMsg := "Foram encontrados produtos sem Peso Bruto - NF: " + aParam[5][2] + Chr(13)
For _nX := 1 to Len(aProNoBru)
cTxtMsg += aProNoBru[_nX] + " - " + Posicione("SB1",1,xFilial("SB1")+aProNoBru[_nX],"B1_DESC") + Chr(13)
Next _nX
cTxtMsg += Chr(13)

cAssunto := "Foram encontrados produtos sem Peso Bruto - NF: " + aParam[5][2] + Chr(13)
cTexto   := StrTran(cTxtMsg,Chr(13),"<br>")
cPara    := 'wellington.silva@rosenbergerdomex.com.br;elaine.ribeiro@rosenbergerdomex.com.br;welton.oliveira@rosenbergerdomex.com.br;denis.vieira@rdt.com.br;carlos.sepinho@rosenbergerdomex.com.br;rodolfo.barroso@rosenbergerdomex.com.br;bruna.macedo@rdt.com.br;joao.paulo@rosenbergerdomex.com.br'
cCC      := ''
cArquivo := Nil
U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)

cTxtMsg  += "Deseja preencher agora?"

If MsgYesNo(cTxtMsg)
For _nX := 1 to Len(aProNoBru)
U_DOMSB1PB(aProNoBru[_nX])
Next _nX
lAborta := .T.
Else
lAborta := .T.
EndIf
EndIf
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Verifica volume na estrutura do produto	  							³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
/*
If Len(aPrNoCxEst) > 0
cTxtMsg := "Existem produtos sem Caixa na estrutura de Produtos: " + Chr(13)
For _nX := 1 to Len(aPrNoCxEst)
cTxtMsg += aPrNoCxEst[_nX] + " - " + Posicione("SB1",1,xFilial("SB1")+aPrNoCxEst[_nX],"B1_DESC") + Chr(13)
Next _nX
cAssunto := "Falta de embalagem na Estrutura de Produtos - NF: " + aParam[5][2] + Chr(13)
cTexto   := StrTran(cTxtMsg,Chr(13),"<br>")
cPara    := 'fabiana.santos@rosenbergerdomex.com.br;elaine.ribeiro@rosenbergerdomex.com.br;welton.oliveira@rosenbergerdomex.com.br;denis.vieira@rdt.com.br;carlos.sepinho@rosenbergerdomex.com.br;bruna.macedo@rdt.com.br;joao.paulo@rosenbergerdomex.com.br'
cCC      := ""
cArquivo := Nil
U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)

cTxtMsg  += Chr(13)
cTxtMsg  += "Um e-mail foi enviado à Engenharia."

MsgStop(cTxtMsg)
lAborta := .T.
EndIf
*/

If ALLTRIM(aParam[5,4]) == "0" // NF entrada
	SF1->( dbSetOrder(1) ) //F1_LOJA + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA + F1_TIPO
	
	nTotLiq  := 0
	nTotBru  := 0
	nVolumes := 0   
	
Else  // NF saída
	
	SF2->(dbSetOrder(1))
	SD2->(dbSetOrder(3)) //FILIAL +DOC + SERIE + CLIENTE + LOJA + COD + ITEM
	SC5->(dbSetOrder(1)) //FILIAL + NUMERO
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Calculo antigo                   	   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nTotLiq  := 0
	nTotBru  := 0
	nVolumes := 0
	
	nQtdSD2  := 0
	nQtdXD1  := 0
	cPedXD1  := 0
	
	_cPEDIDO := ''
	If SD2->( dbSeek( xFilial('SD2') + aParam[5][2] + aParam[5][1] ) )  // DOC + SERIE
	
		// Conta Registros com TES 999
					cQry999 := " SELECT COUNT(*) QTDE FROM "+RetSqlName("SD2")+" SD2  WHERE SD2.D_E_L_E_T_ = '' AND D2_DOC = '"+aParam[5][2]+"' AND D2_SERIE = '"+aParam[5][1]+"' AND D2_TES = '999' "
					
					//Fecha Alias caso encontre
					If Select("TMPD2") <> 0 ; TMPD2->(dbCloseArea()) ; EndIf

					//Cria alias temporario
					TcQuery cQry999 New Alias "TMPD2"
					
					//Pega Conteudo
					TMPD2->(DbGoTop())
				
					lTES999 := iif(TMPD2->QTDE > 0,.T.,.F.) 		// Trata TES INTELIGENTE - Mauresi 27/10/17					
      // Fim Contagem TES 999


	
		_cPEDIDO := SD2->D2_PEDIDO
		If SC5->( dbSeek( xFilial('SC5') + _cPEDIDO  ) )                 // PEDIDO DE VENDA
			nVolumes := SC5->C5_VOLUME1
			nTotLiq  := SC5->C5_PESOL
			nTotBru  := SC5->C5_PBRUTO
		EndIf
	ENDIF
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verificar peso vindo da expedicao	   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lExpedicao
		
		If SF2->( dbSeek( xFilial('SF2') + aParam[5][2] + aParam[5][1] ) )  // SERIE + DOC
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verificar peso vindo da expedicao	   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SF2->F2_XXPESOB > 0 .Or. SF2->F2_XXPESOL > 0
//				If Date() <= StoD("20160425")
					cTxtMsg  := "Peso da Expedicao NF: " + aParam[5][2] + Chr(13)
					cTxtMsg  += "Peso Liq: " + Str(SF2->F2_XXPESOL) + Chr(13)
					cTxtMsg  += "Peso Bru: " + Str(SF2->F2_XXPESOB) + Chr(13)
					cTxtMsg  += "Volumes : " + Str(SF2->F2_XXVOLUM) + Chr(13)
					cAssunto := "Domex-Expedicao XD1  " + aParam[5][2] + Chr(13)
					cTexto   := StrTran(cTxtMsg,Chr(13),"<br>")
					cPara    := 'denis.vieira@rdt.com.br'
					cCC      := ''
					cArquivo := Nil
					U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
//				EndIf  
				nTotLiq  := SF2->F2_XXPESOL
				nTotBru  := SF2->F2_XXPESOB
				nVolumes := SF2->F2_XXVOLUM
			EndIf
		EndIf
	EndIf
	
	If nVolumes == 0
		lAborta := .T.
	EndIf
	
	If Empty(nTotLiq) .or. Empty(nTotBru)
		cTxtMsg := "Foram encontrados produtos sem peso bruto/liquido: " + aParam[5][2] + Chr(13)
		For _nX := 1 to Len(aProNoBru)
			cTxtMsg += aProNoBru[_nX] + " - " + Posicione("SB1",1,xFilial("SB1")+aProNoBru[_nX],"B1_DESC") + Chr(13)
		Next _nX
		cTxtMsg += Chr(13)
		
		cAssunto := "Foram encontrados produtos sem Peso Bruto - NF: " + aParam[5][2] + Chr(13)
		cTexto   := StrTran(cTxtMsg,Chr(13),"<br>")
//		cPara    := 'wellington.silva@rosenbergerdomex.com.br; elaine.ribeiro@rosenbergerdomex.com.br; '
		cPara    := 'alberto.oliveira@rosenbergerdomex.com.br; elaine.ribeiro@rosenbergerdomex.com.br; '
  	    cPara    += 'welton.oliveira@rosenbergerdomex.com.br; denis.vieira@rdt.com.br; '
		cPara    += 'carlos.sepinho@rosenbergerdomex.com.br; rodolfo.barroso@rosenbergerdomex.com.br '
		cCC      := 'joao.paulo@rosenbergerdomex.com.br; adriana.ottoboni@rosenbergerdomex.com.br '
		cArquivo := Nil
		U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
		
		cTxtMsg  += "Deseja preencher agora?"
		
		If MsgYesNo(cTxtMsg)
			For _nX := 1 to Len(aProNoBru)
				U_DOMSB1PB(aProNoBru[_nX])
			Next _nX
			lAborta := .F.
		Else
			lAborta := .T.
		EndIf
	EndIf
		
	if lTES999
			lAborta := .T.
			cTxtMsg  := "TES 999 utilizada na NF: " + aParam[5][2] + Chr(13)
			cTxtMsg  += "Favor corrigir. " + Chr(13)
			cAssunto := "Domex- TES 999 - NF: " + aParam[5][2] + Chr(13)
			cTexto   := StrTran(cTxtMsg,Chr(13),"<br>")
			cPara    := 'denis.vieira@rdt.com.br;' //marco.aurelio@opusvp.com.br'
			cCC      := ''
			cArquivo := Nil
			U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
			
	endif


	If lAborta
		MsgStop("Favor transmitir a NF novamente.")
		aParam := {}
		For x := 1 to 17
			AADD(aParam,{})
		Next x
		Return aParam
	EndIf

	
EndIf

// Inserido por Michel Sander em 27.07.2018 para tratar a conversão de unidade de medida e peso para exportação
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Verifica se existe fator de conversao por peso para exportacao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If SD2->( dbSeek( xFilial('SD2') + aParam[5][2] + aParam[5][1] ) )  // DOC + SERIE
   aParamPE := aParam[1]
   _xCount  := 0 
	Do While SD2->(!Eof()) .And. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE == xFilial('SD2')+aParam[5][2]+aParam[5][1]
	//_xCount:=_xCount+1
	//_xCount := AScan( aParamPE, { |x| x[1] == _xCount } )
	   If SD2->D2_XXFATEX > 0
		   //nPosPeso := AScan( aParamPE, { |x| x[2] == SD2->D2_COD } )
		   //nPosPeso := AScan( aParamPE, { |x| x[1] == _xCount } )
		   nPosPeso := AScan( aParamPE, { |x| x[50] == SD2->D2_ITEM } )
		   If nPosPeso > 0              
		      aParam[1,nPosPeso,11] := "KG"
		      aParam[1,nPosPeso,12] := SD2->D2_XXFATEX * SD2->D2_QUANT 
		   EndIf
	   EndIf
	   SD2->(dbSkip())
	EndDo
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Soma as quantidades dos produtos que não sao CORD ao volume		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If !Empty(aParam[14])
	If Type("aParam[14,1,1]") <> "U"
		aParam[14,1,1] := "VOLUME"
	EndIf
	If Type("aParam[14,1,2]") <> "U"
		aParam[14,1,2] := nVolumes
	EndIf
	If Type("aParam[14,1,3]") <> "U"
		aParam[14,1,3] := nTotLiq
	EndIf
	If Type("aParam[14,1,4]") <> "U"
		//aParam[14,1,4] := nTotBru + nPesEmbFin
		aParam[14,1,4] := nTotBru
	EndIf
Else
	//AADD( aParam[14], { "VOLUME", nVolumes, nTotLiq, nTotBru + nPesEmbFin} )
	AADD( aParam[14], { "VOLUME", nVolumes, nTotLiq, nTotBru               } )
EndIf

Return(aParam)
