
/*
Programa        : EECPEM54_RDM.
Objetivo        : Impressao do Packing List (Modelo 2).        
Autor           : Mauricio/Opus
Data/Hora       : 24/05/2020
*/

#INCLUDE "EECRDM.CH"
#INCLUDE "EECPEM54.CH"
#INCLUDE "TOTVS.CH"

#define NUMLINPAG 22
#define TAMDESC 22
#define cPict1 "@E 999,999,999"
#define cPict2 "@E 999,999,999.99"



USER Function EECPEM54() //SIGAEEC RELAT 2
   Local lRet := .f.
   Local nAlias := Select()
   Local aOrd := SaveOrd({"EE9","SA2","SY9","SA1","SYA","SYQ","EEK","EE5"})
   Local cCod
   Local cLoja

   Private cCHAVE  :=''
   Private nTotRacks
   Private nTotCaixa
   Private nTotPesLi
   Private nTotPesBr
   Private nTotQtdVo
   Private nTotVolum
   Private nLin :=0
   Private nPag := 1
   Private nTotPag := 1
   Private nComEmb := 0
   Private nLarEmb := 0
   Private nAltEmb := 0
   Private cUltEmb := ""
   Private nQtdUltEmb := 0
   Begin Sequence

      EE9->(dbSetOrder(3))
      EE5->(dbSetOrder(1))
      EE7->(dbSetOrder(1))
      EEO->(dbSetorder(2))
      EE9->(dbSeek(xFilial()+EEC->EEC_PREEMB))
      EE7->(dbSeek(xFilial()+EE9->EE9_PEDIDO))

      cSeqRel := GetSXENum("SY0","Y0_SEQREL")
      ConfirmSX8()
        // adicionar registro no HEADER_P
      HEADER_P->(DBAPPEND())
      HEADER_P->AVG_FILIAL:=xFilial("SY0")
      HEADER_P->AVG_SEQREL:=cSEQREL
      HEADER_P->AVG_CHAVE :=EE9->EE9_PEDIDO //nr. do processo
      cCHAVE:=EE9->EE9_PEDIDO

      IF !Empty(EEC->EEC_EXPORT)
         cCod := EEC->EEC_EXPORT
         cLoja:= EEC->EEC_EXLOJA
      Else
         cCod := EEC->EEC_FORN
         cLoja:= EEC->EEC_FOLOJA
      Endif

      // Exportador ou Fornecedor
      SA2->(dbSeek(xFilial("SA2")+cCod+cLoja))
      HEADER_P->AVG_C01_60 := SA2->A2_NOME
      cEnd := AllTrim(SA2->A2_END) +;
         If(!Empty(SA2->A2_NR_END)," "+AllTrim(SA2->A2_NR_END),"") +;
            If(!Empty(SA2->A2_BAIRRO)," - "+AllTrim(SA2->A2_BAIRRO),"") +;
               " - " + AllTrim(SA2->A2_MUN) +;
               "/" +  SA2->A2_EST +;
               " " + AllTrim(Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_NOIDIOM"))

            HEADER_P->AVG_C01150 := cEnd
            cEnd := If(!Empty(SA2->A2_CGC),"CNPJ "+AllTrim(SA2->A2_CGC),"")

            HEADER_P->AVG_C03_60 := cEnd
            cEnd := If(!Empty(SA2->A2_TEL),"TEL.: "+AllTrim(SA2->A2_TEL),"")+;
               If(!Empty(SA2->A2_FAX),"  FAX.: "+AllTrim(SA2->A2_FAX),"")

               //HEADER_P->AVG_C04_60 := cEnd

               // Importador
               HEADER_P->AVG_C05_60 := EEC->EEC_IMPODE
               HEADER_P->AVG_C06_60 := EEC->EEC_ENDIMP
               HEADER_P->AVG_C07_60 := EEC->EEC_END2IM

               HEADER_P->AVG_C10_60 := EEC->EEC_REFIMP

             // IMPORTADOR ENDERECO 2
               HEADER_P->AVG_C02_60 := EEC->EEC_XIMPOD
               HEADER_P->AVG_C04_60 := EEC->EEC_XENDIM
               HEADER_P->AVG_C11_60 := EEC->EEC_XEND2I


               //EEC_CLIENT,EEC_CLLOJA
               _cCONTATO:=POSICIONE('SA1',1,xFILIAL('SA1')+EEC->EEC_IMPORT,'A1_CONTATO')
               IF !EMPTY(_cCONTATO)
                  _cCONTATO:="Contact :"+_cCONTATO
               ENDIF
               HEADER_P->AVG_C08_60 := _cCONTATO
               HEADER_P->AVG_C12_60 := EEC->EEC_XCONT2


               HEADER_P->AVG_C03_10 := EEC->EEC_MOEDA
               HEADER_P->AVG_C04_10 := EEC->EEC_INCOTE
               HEADER_P->AVG_C05_30 := EEC->EEC_XXINCO

               IF EEC->EEC_DIASPA >0
                  HEADER_P->AVG_C09_60 := cValtoChar(EEC->EEC_DIASPA)+' days after invoice'
               ENDIF

               _cOF  :=SUBSTR(EEC->EEC_PEDREF,15,6)
               HEADER_P->AVG_C07_10 :=ALLTRIM(_cOF)
               //No do Pedido
               HEADER_P->AVG_C01_30 := EEC->EEC_PEDREF //DFS - 30/05/11 - Inclusão do Pedido de Referência, ao invés da Referência do Importador. //EEC->EEC_REFIMP

               //Data do Pedido
               //select EE7_DTPEDI,EE7_PEDFAT,*  from  EE7010 WHERE D_E_L_E_T_=''
               //SELECT C6_NOTA,* FROM SC6010 WHERE C6_NUM='043519' // ALTERACAO 13/07/2020
               //_cNOTA   :=POSICIONE('SC6',1,XFILIAL(SC6)+EE7->EE7_PEDFAT,'C6_NOTA')
               //_dEMISSAO:=POSICIONE('SF2',1,XFILIAL(SF2)+_cNOTA,'F2_EMISSAO')
               //HEADER_P->AVG_C01_10 := DtoC(_dEMISSAO)
               //SELECT EEC_DTINVO,EEC_PEDREF,* FROM EEC010 WHERE EEC_NRINVO='EXP1319/20'
               //SELECT D2_EMISSAO,* FROM  SD2010 WHERE D2_PEDIDO=(SELECT SUBSTRING(EEC_PEDREF,15,6) FROM EEC010 WHERE EEC_NRINVO='EXP1319/20' AND D_E_L_E_T_='')
               __cPEDFAT :=SUBSTR(EEC->EEC_PEDREF,15,6)

               SD2->(dbSelectArea("SD2"))
					SD2->(DBSETORDER(8)) //SD2	8	D2_FILIAL+D2_PEDIDO+D2_ITEMPV
					SD2->(DbSeek(xFilial("SD2")+__cPEDFAT))
					IF SD2->(FOUND())
                  //HEADER_P->AVG_C01_10 := DtoC(EEC->EEC_DTINVO)  //MLSDATA
                  HEADER_P->AVG_C01_10 := DtoC(SD2->D2_EMISSAO)  
               ENDIF   
               //HEADER_P->AVG_C01_10 := DtoC(EE7->EE7_DTPEDI)

               //No do Packing List
               HEADER_P->AVG_C02_30 := EEC->EEC_NRINVO

               //Data do Packing List
               HEADER_P->AVG_C02_10 := DtoC(EEC->EEC_DTINVO)

               nTotRacks := 0
               nTotCaixa := 0
               nTotPesLi := 0
               nTotPesBr := 0
               nTotQtdVo := 0
               nTotVolum := 0
               nQtdPallet:= 0

               GravaItens()

               // Totais
               cTotRacks := DecPoint(LTrim(Transf(nTotRacks,cPict1)))
               HEADER_P->AVG_C03_30 := cTotRacks

               cTotCaixa := DecPoint(LTrim(Transf(nTotCaixa,cPict1)))
               HEADER_P->AVG_C04_30 := cTotCaixa

               cTotPesLi := DecPoint(LTrim(Transf(EEC->EEC_PESLIQ,cPict2)),2)
               cTotPesLi += If(!Empty(cTotPesLi)," Kg","")
               //HEADER_P->AVG_C05_30 := cTotPesLi

               //RMD - 12/02/15 - Considerar sempre o peso total gravado no embarque, pois pode ter sido digitado (MV_AVG0004).
               If !EasyGParam("MV_AVG0004",, .F.)
                  cTotPesBr := DecPoint(LTrim(Transf(nTotPesBr/*EEC->EEC_PESBRU*/,cPict2)),2)  //LGS-09/12/2014
               Else
                  cTotPesBr := DecPoint(LTrim(Transf(EEC->EEC_PESBRU,cPict2)),2)
               EndIf

               cTotPesBr += If(!Empty(cTotPesBr)," Kg","")
               HEADER_P->AVG_C06_30 := cTotPesBr

               cTotQtdVo := DecPoint(LTrim(Transf(nTotQtdVo,cPict1)))
               HEADER_P->AVG_C07_30 := cTotQtdVo

               If EEC->(FieldPos("EEC_QTDEMB")) # 0 .AND. EEC->EEC_QTDEMB # 0  // GFP - 24/01/2014
                  nTotVolum := nTotVolum * EEC->EEC_QTDEMB
               EndIf
               cTotVolum := DecPoint(LTrim(Transf(nTotVolum,cPict2)),2)
               cTotVolum += If(!Empty(cTotVolum)," m3","")
               HEADER_P->AVG_C08_30 := cTotVolum

               HEADER_P->AVG_C08_10 := AllTrim(Str(nTotPag))

               // Marks
               cMemo := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",AV_TAMANHO))
               HEADER_P->AVG_C04_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),1)
               HEADER_P->AVG_C05_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),2)
               HEADER_P->AVG_C06_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),3)
               HEADER_P->AVG_C07_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),4)
               HEADER_P->AVG_C08_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),5)
               HEADER_P->AVG_C09_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),6)
               HEADER_P->(dbUnlock())

               HEADER_H->(dbAppend())
               AvReplace("HEADER_P","HEADER_H")

               DETAIL_P->(DbGoTop())
               Do While ! DETAIL_P->(Eof())
                  DETAIL_H->(DbAppend())
                  AvReplace("DETAIL_P","DETAIL_H")
                  DETAIL_P->(DbSkip())
               EndDo

               HEADER_P->(DBCOMMIT())
               DETAIL_P->(DBCOMMIT())

               lRet := .t.

            End Sequence

            RestOrd(aOrd)
            Select(nAlias)

            Return lRet

*-------------------------*
Static Function GravaItens
*-------------------------*
   Local i:=0

   Begin Sequence

      EE9->(DBSELECTAREA('EE9'))
      EE9->(DBSETORDER(3))

      EE9->(dbSeek(xFilial()+EEC->EEC_PREEMB))

      While EE9->(!Eof() .And. EE9->EE9_FILIAL == xFilial("EE9")) .And.;
            EE9->EE9_PREEMB == EEC->EEC_PREEMB

         AppendDet()
         DETAIL_P->AVG_C01_60 := POSICIONE('SB1',1,xFILIAL('SB1')+EE9->EE9_COD_I,'B1_DESC')
         DETAIL_P->AVG_C04_10 := POSICIONE('SB1',1,xFILIAL('SB1')+EE9->EE9_COD_I,'B1_UM')
         DETAIL_P->AVG_C01_20 := AllTrim(EE9->EE9_COD_I)
         DETAIL_P->AVG_C05_60 := AllTrim(EE9->EE9_PART_N)
         DETAIL_P->AVG_C06_20 := AllTrim(EE9->EE9_POSIPI)
         DETAIL_P->AVG_C10_20 :='01ITEM'

         UnLockDet()
         EE9->(dbSkip())
      Enddo
      nTotPag := nPag

   End Sequence

   Begin Sequence

      ZEC->(DBSELECTAREA('ZEC'))
      ZEC->(DBSETORDER(1))

      ZEC->(dbSeek(xFilial()+EEC->EEC_PEDREF))

      While ZEC->(!Eof() .And. ZEC->ZEC_FILIAL == xFilial("ZEC")) .And.;
            ZEC->ZEC_PEDREF == EEC->EEC_PEDREF

         AppendDet()
         DETAIL_P->AVG_C01_20 := ZEC->ZEC_TYPE

         DETAIL_P->AVG_N06_15 := ZEC->ZEC_QTDE
         DETAIL_P->AVG_N01_15 := ZEC->ZEC_QTYLEN
         DETAIL_P->AVG_N02_15 := ZEC->ZEC_WIDTH
         DETAIL_P->AVG_N03_15 := ZEC->ZEC_HEIGHT
         DETAIL_P->AVG_N04_15 := ZEC->ZEC_NET
         DETAIL_P->AVG_N05_15 := ZEC->ZEC_GROSS

         DETAIL_P->AVG_C10_20 :='02DETAL'

         UnLockDet()
         ZEC->(dbSkip())
      Enddo

   End Sequence


Return NIL

*------------------*
Static Function Add
*------------------*

   Begin Sequence
      dbAppend()

      bAux:=FieldWBlock("AVG_FILIAL",Select())

      IF ValType(bAux) == "B"
         Eval(bAux,xFilial("SY0"))
      Endif

      bAux:=FieldWBlock("AVG_CHAVE",Select())

      IF ValType(bAux) == "B"
         Eval(bAux,EEC->EEC_PREEMB)
      Endif

      bAux:=FieldWBlock("AVG_SEQREL",Select())

      IF ValType(bAux) == "B"
         Eval(bAux,cSeqRel)
      Endif

   End Sequence

Return NIL

*---------------------------------*
Static Function DecPoint(cStr,nDec)
*---------------------------------*
   Local cStrIni, cStrFim

   Begin Sequence

      nDec := If(nDec = Nil,0,nDec)
      cStr := AllTrim(cStr)

      If nDec > 0
         cStrFim := Right(cStr,nDec+1)
         cStrFim := StrTran(cStrFim,".",",")
      Else
         cStrFim := ""
      EndIf

      if nDec > 0
         cStrIni := SubStr(cStr,1,Len(cStr)-(nDec+1))
         cStrIni := StrTran(cStrIni,",",".")
      Else
         cStrIni := cStr
         cStrIni := StrTran(cStrIni,",",".")
      Endif

   End Sequence

Return AllTrim(cStrIni+cStrFim)


*-------------------------*
Static Function AppendDet()
*-------------------------*
   Begin Sequence
      DETAIL_P->(dbAppend())
      DETAIL_P->AVG_FILIAL := xFilial("SY0")
      DETAIL_P->AVG_SEQREL := cSEQREL
      DETAIL_P->AVG_CHAVE  := cCHAVE //nr. do processo
   End Sequence

Return NIL


*-------------------------*
Static Function UnlockDet()
*-------------------------*
   Begin Sequence
      DETAIL_P->(dbUnlock())
   End Sequence

Return NIL

*-----------------------------------------------------------------------------------------------------------------*
*  FIM DO RDMAKE EECPEM54_RDM
*-----------------------------------------------------------------------------------------------------------------*
