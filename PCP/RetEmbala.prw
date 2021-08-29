#include "rwmake.ch"
#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RETEMBALA ºAutor  ³Helio Ferreira      º Data ³  02/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RetEmbala(cProduto,cNivel)

Local _Retorno := {"",0,"",.T.}
Local aAreaGER := GetArea()
Local aAreaSG1 := SG1->( GetArea() )
Local aAreaSB1 := SB1->( GetArea() )
Local aPIs     := {}
Local lVerZA1  := .F.
Local _nX 

SB1->( dbSetOrder(1) )
If SB1->(dbSeek(xFilial("SB1")+AllTrim(cProduto)))
	/*
	ZA1->( dbSetOrder(1) )
	If ZA1->( dbSeek(xFilial() + cProduto ) )
		Do While ZA1->(!Eof()) .And. ZA1->ZA1_FILIAL+ZA1->ZA1_PRODUT == xFilial("ZA1")+cProduto
			If ZA1->ZA1_NIVEL <> cNivel
				ZA1->(dbSkip())
				Loop
			Else
				_Retorno[1] := ZA1->ZA1_CODEMB
				_Retorno[2] := ZA1->ZA1_QUANT
				_Retorno[3] := ZA1->ZA1_NIVEL
				_Retorno[4] := .T.
			Endif
			ZA1->(dbSkip())
		EndDo
		If Empty(_Retorno[1])
		   lVerZA1 := .T.
		Endif
	Else
		ZA1->( dbSetOrder(2) )
		SB1->( dbSetOrder(1) )
		SB1->( dbSeek( xFilial() + Alltrim(cProduto ) ) )
		If ZA1->( dbSeek(xFilial()+SB1->B1_GRUPO+SB1->B1_SUBCLAS) )
			Do While ZA1->(!Eof()) .And. ZA1->ZA1_FILIAL+ZA1->ZA1_GRUPO+ZA1->ZA1_SUBCLA == xFilial("ZA1")+SB1->B1_GRUPO+SB1->B1_SUBCLAS
				If ZA1->ZA1_NIVEL <> cNivel
					ZA1->(dbSkip())
					Loop
				Else
					_Retorno[1] := ZA1->ZA1_CODEMB
					_Retorno[2] := ZA1->ZA1_QUANT
					_Retorno[3] := ZA1->ZA1_NIVEL
					_Retorno[4] := .T.
				Endif
				ZA1->(dbSkip())
			EndDo
			If Empty(_Retorno[1])
			   lVerZA1 := .T.
			Endif
		EndIf
	EndIf
	*/
	If !lVerZA1

		If SUBSTR(SB1->B1_GRUPO,1,3) <> "DIO"
			
			SG1->( dbSetOrder(1) )
			If SG1->( dbSeek( xFilial() + cProduto ) )
				While !SG1->( EOF() ) .and. SG1->G1_COD == cProduto
					If SG1->G1_XXEMBNIV == cNivel    
							/*
							RICARDO RODA
							ALTERAÇÃO TEMPORÁRIA REALIZADO EM 05/09/2019
							PARA CORREÇÃO DE PROBLEMAS PONTUAL URGENTE
							*/
						If  alltrim(SG1->G1_COD) == "DMSFLMD7373030W" .and.   ALLTRIM(SG1->G1_COMP) == '5000723474739'
							_Retorno[1] := SG1->G1_COMP
							_Retorno[2] := 1/0.001666667   //SG1->G1_QUANT
							_Retorno[3] := SG1->G1_XXEMBNI
							_Retorno[4] := .T.
						Else  
							_Retorno[1] := SG1->G1_COMP
							_Retorno[2] := 1/SG1->G1_QUANT
							_Retorno[3] := SG1->G1_XXEMBNI
							_Retorno[4] := .T. 
							Exit
						Endif
					EndIf                
						
						/* PARTE ORIGINAL COMENTADA 
						_Retorno[1] := SG1->G1_COMP
						_Retorno[2] := 1/SG1->G1_QUANT
						_Retorno[3] := SG1->G1_XXEMBNI
						_Retorno[4] := .T. 
					   */
						//FIM DA ALTERAÇÃO 
					
					AADD(aPIs,SG1->G1_COMP)
					SG1->( dbSkip() )
				End
			EndIf
			
			If Empty(_Retorno[1])
				For _nX := 1 to Len(aPIs)
					If SG1->( dbSeek( xFilial() + aPIs[_nX] ) )
						While !SG1->( EOF() ) .and. SG1->G1_COD == aPIs[_nX]
							If SG1->G1_XXEMBNIV == cNivel
								_Retorno[1] := SG1->G1_COMP
								_Retorno[2] := 1/SG1->G1_QUANT
								_Retorno[3] := SG1->G1_XXEMBNI
								_Retorno[4] := .T.	
								_nX := Len(aPIs)
								Exit
							EndIf
							SG1->( dbSkip() )
						End
					EndIf
				Next _nX
			EndIf
			
			If ALLTRIM(cNivel) <> "3"
				//If !Empty(cNivel)
				If Empty(_Retorno[1])
					cTxtMsg  := "Erro no cadastro da estrutura do produto " + Alltrim(cProduto) + ". Produto sem embalagem nível " + cNivel + "."
					cAssunto := "Produto sem nível de embalagem na estrutura"
					cTexto   := StrTran(cTxtMsg,Chr(13),"<br>")
					cPara    := 'denis.vieira@rdt.com.br;tatiane.alves@rosenbergerdomex.com.br;fabiana.santos@rdt.com.br;monique.garcia@rosenbergerdomex.com.br;daniel.cavalcante@rosenbergerdomex.com.br'
					cCC      := 'natalia.silva@rosenbergerdomex.com.br;keila.gamt@rosenbergerdomex.com.br;leonardo.andrade@rosenbergerdomex.com.br;gabriel.cenato@rosenbergerdomex.com.br;luiz.pavret@rdt.com.br' //chamado monique 015475
					cArquivo := Nil
					U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
					_Retorno[4] := .F.
				EndIf
				//EndIf
			EndIf
			
		Else
			
			// tratar embalagem para classe DIO ADAPTADOR OTICO por Michel Sander em 21.12.2016
			If SUBSTR(SB1->B1_SUBCLAS,1,3) == "AOP" .Or. SUBSTR(SB1->B1_SUBCLAS,1,4) == 'CXDI' .Or. SUBSTR(SB1->B1_SUBCLAS,1,3)=="DIV" .Or. SUBSTR(SB1->B1_SUBCLAS,1,3) == 'MTP' ;
				.Or. SUBSTR(SB1->B1_SUBCLAS,1,3) == 'ASS'
				
				lEntraG1 := .F.
				SG1->( dbSetOrder(1) )
				If SG1->( dbSeek( xFilial() + cProduto ) )
					While !SG1->( EOF() ) .and. SG1->G1_COD == cProduto
						If SG1->G1_XXEMBNIV == cNivel
							lEntraG1    := .T.
							_Retorno[1] := SG1->G1_COMP
							_Retorno[2] := 1/SG1->G1_QUANT
							_Retorno[3] := SG1->G1_XXEMBNI
							_Retorno[4] := .T.
							Exit
						EndIf
						AADD(aPIs,SG1->G1_COMP)
						SG1->( dbSkip() )
					End
				EndIf
				
				If !lEntraG1
					_Retorno[1] := ""
					_Retorno[2] := 1
					_Retorno[3] := cNivel
					_Retorno[4] := .T.
				EndIf
				
			Else
				
				_Retorno[1] := ""
				_Retorno[2] := 1
				_Retorno[3] := cNivel
				_Retorno[4] := .T.
				
			EndIf
		EndIf
	EndIf
EndIf

RestArea(aAreaSG1)
RestArea(aAreaSB1)
RestArea(aAreaGER)

Return _Retorno
