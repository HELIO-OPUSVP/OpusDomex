#Include 'protheus.ch'
#Include 'rwmake.ch'
#Include 'tbiconn.ch'
#Include 'topconn.ch'
#Include "fwprintsetup.ch"
#Include "rptdef.ch"

#Define PAD_LEFT            0
#Define PAD_RIGHT           1
#Define PAD_CENTER          2

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º cf_PutSx1  ³ Cria pergunta no SX1.                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±º Funcao     ³ cf_PutSx1 ³ Autor ³ Cesar Arneiro (C.A. ERP Consulting) ³ Data ³ 13/03/06 º±±
±±ÇÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ¶±±
±±º Descricao  ³ Cria pergunta no SX1.                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Analista Resp. ³   Data   ³ Manutencao Efetuada                                        º±±
±±ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶±±
±±º                ³   /  /   ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function cf_PutSx1(cPerg, aSx1, lExcl)

Local nLin, nCol, cCampo, _nPos

lExcl := If(lExcl == Nil, .F., lExcl)
cPerg := PadR(cPerg, Len(SX1->X1_GRUPO))

SX1->(dbSetOrder(1))

SX1->(dbSeek(cPerg))
While !SX1->(Eof()) .And. AllTrim(SX1->X1_GRUPO) == AllTrim(cPerg)
	_nPos := aScan(aSx1, {|X| X[2] == SX1->X1_ORDEM})
	
	If _nPos = 0 .Or. lExcl
		SX1->(RecLock("SX1", .F., .F.))
		SX1->(dbDelete())
		SX1->(MsUnLock())
	Else
		For nCol := 2 To Len(aSX1[_nPos])
			If SX1->&("X1_" + aSX1[1, nCol]) <> aSX1[_nPos, nCol]
				If ValType(aSX1[_nPos, nCol]) = "C"
					If AllTrim(SX1->&("X1_" + aSX1[1, nCol])) <> AllTrim(aSX1[_nPos, nCol])
						SX1->(RecLock("SX1", .F., .F.))
						SX1->(dbDelete())
						SX1->(MsUnLock())
						Exit
					EndIf
				Else
					SX1->(RecLock("SX1", .F., .F.))
					SX1->(dbDelete())
					SX1->(MsUnLock())
					Exit
				EndIf
			EndIf
		Next
	EndIf
	
	SX1->(dbSkip())
End
If !lExcl
	For nLin := 2 To Len(aSX1)
		If !SX1->(dbSeek(cPerg + aSX1[nLin, 2]))
			SX1->(RecLock("SX1", .T.))
			For nCol := 1 To Len(aSX1[1])
				cCampo := "X1_" + aSX1[1, nCol]
				SX1->(FieldPut(SX1->(FieldPos(cCampo)), aSx1[nLin,nCol]))
			Next nCol
			SX1->(MsUnLock())
		EndIf
	Next nLin
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±º Funcao    ³ afLPE02/CTBLP001 ³ Autor ³ Cesar Arneiro / Hélio Ferreira³ Data ³ 15/10/18 º±±
±±ºÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ¶±±
±±º Descricao  ³ Retorna informacoes sobre a transferencia.                                º±±
±±ºÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶±±
±±º Parametro  ³ _cNumSeq: Opcional. Numero sequencial do movimento. Se nao informado,     º±±
±±º            ³           considera D3_NUMSEQ.                                            º±±
ÇÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄº±±
º Retorno    ³ Array com as seguintes informacoes:                                         º±±
º            ³ [1]Codigo requisitado                                                     
º            ³ [2]Armazem requisitado                                                    
º            ³ [3]Conta contabil requisitada                                             
º            ³ [4]Tipo produto requisitado                                               
º            ³ [5]Codigo devolvido                                                       
º            ³ [6]Armazem devolvido                                                      
º            ³ [7]Conta contabil devolvida                                               
º            ³ [8]Tipo produto devolvido                                                 
º            ³ [9]Quantidade                                                             
º            ³ [10]Documento                                                            
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CTBLP001(_cNumSeq)

Local _cQuery

Local _aRet := {"", "", "", "", "", "", "", "", 0, ""}

Default _cNumSeq := SD3->D3_NUMSEQ
//                 1                   2                     3                       4                    5                   6                     7                       8                     9             10           
_cQuery := "SELECT REQ.D3_COD COD_REQ, REQ.D3_LOCAL LOC_REQ, REQ.D3_CONTA CONTA_REQ, REQ.D3_TIPO TIPO_REQ,DEV.D3_COD COD_DEV, DEV.D3_LOCAL LOC_DEV, DEV.D3_CONTA CONTA_DEV, DEV.D3_TIPO TIPO_DEV, REQ.D3_QUANT, REQ.D3_DOC "
_cQuery += "FROM " + RetSQLName("SD3") + " REQ WITH(NOLOCK)  "
_cQuery += "	INNER JOIN " + RetSQLName("SD3") + " DEV "
_cQuery += "		 ON DEV.D3_NUMSEQ  = REQ.D3_NUMSEQ "
_cQuery += "		AND DEV.D3_CF      = 'DE4' "
_cQuery += "		AND DEV.D3_ESTORNO = ' ' "
_cQuery += "		AND DEV.D3_FILIAL  ='"+xFILIAL('SD3')+"' "
_cQuery += "		AND DEV.D_E_L_E_T_ = ' ' "
_cQuery += "WHERE   REQ.D3_CF      = 'RE4' "
_cQuery += "	AND REQ.D3_ESTORNO = ' ' "
_cQuery += "	AND REQ.D3_NUMSEQ  = '" + _cNumSeq + "' "
_cQuery += "	AND REQ.D_E_L_E_T_ = ' ' "
_cQuery += "	AND REQ.D3_FILIAL  ='"+xFILIAL('SD3')+"' "

If Select("tTransf") > 0
	tTransf->(dbCloseArea())
EndIf

TCQUERY _cQuery NEW ALIAS "tTransf"

tTransf->(dbGoTop())

If !tTransf->(Eof())
   _aRet[1]  := tTransf->COD_REQ
	_aRet[2]  := tTransf->LOC_REQ
	_aRet[3]  := tTransf->CONTA_REQ // U_afLPE01(tTransf->COD_REQ, tTransf->LOC_REQ)
	_aRet[4]  := tTransf->TIPO_REQ
	_aRet[5]  := tTransf->COD_DEV
	_aRet[6]  := tTransf->LOC_DEV
	_aRet[7]  := tTransf->CONTA_DEV // U_afLPE01(tTransf->COD_DEV, tTransf->LOC_DEV)
	_aRet[8]  := tTransf->TIPO_DEV
	_aRet[9]  := tTransf->D3_QUANT
	_aRet[10] := tTransf->D3_DOC
	tTransf->( dbSkip() )
EndIf

tTransf->(dbCloseArea())

Return _aRet
