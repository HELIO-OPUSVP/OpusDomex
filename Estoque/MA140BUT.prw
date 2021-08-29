#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA140BUT  �Autor  �Helio Ferreira      � Data �  11/25/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function MA140BUT()

Local aRetorno   := {}
Local cTexto     := ''

AADD(aRetorno, { 'SDUPROP' ,{ || UpedPre() }, "Ped.Compra Pr�-NF" , "Ped.Compra Pr�-NF" } )

SetKey( VK_F7 ,{ || UpedPre() } )

Return aRetorno

Static Function UpedPre()
Local aPedC      := {}
Local lConsMedic := .F.
Local nPD1_QUANT := aScan(aHeader, { |aVet| Alltrim(aVet[2]) == "D1_QUANT" } )
Local nPD1_VUNIT := aScan(aHeader, { |aVet| Alltrim(aVet[2]) == "D1_VUNIT" } )
Local nPD1_TOTAL := aScan(aHeader, { |aVet| Alltrim(aVet[2]) == "D1_TOTAL" } )
Local nPD1_LOCAL := aScan(aHeader, { |aVet| Alltrim(aVet[2]) == "D1_LOCAL" } )

Local nD1_QUANT := aCols[n,nPD1_QUANT]
Local nD1_VUNIT := aCols[n,nPD1_VUNIT]
Local nD1_TOTAL := aCols[n,nPD1_TOTAL]

A103ItemPC(.F.,aPedC,oGetDados, lNfMedic, lConsMedic,,,a140Desp )
Eval(bRefresh)

If nD1_QUANT <> aCols[N,nPD1_QUANT] .or. nD1_VUNIT <> aCols[n,nPD1_VUNIT]
   If !Empty(nD1_QUANT) .or. !Empty(nD1_VUNIT)
      cTexto := "Diverg�ncia entre Pedido de Compras e NF: " + Chr(13)
	   If !Empty(nD1_QUANT)
	      cTexto += "Campo quantidade: item NF: " + Alltrim(Transform(nD1_QUANT,'@E 999,999,999.9999')) + " - Pedido de Compras: " + Alltrim(Transform(aCols[n,nPD1_QUANT],'@E 999,999,999.9999')) + Chr(13)
	   EndIf
	   If !Empty(nD1_VUNIT)
	      cTexto += "Campo vlr. unit.: item NF: " + Alltrim(Transform(nD1_VUNIT,'@E 999,999,999.9999')) + " - Pedido de Compras: " + Alltrim(Transform(aCols[n,nPD1_VUNIT],'@E 999,999,999.9999'))
	   EndIf
   EndIf
EndIf 

If !Empty(nD1_QUANT) .or. !Empty(nD1_VUNIT)
	aCols[N,nPD1_QUANT] := nD1_QUANT
	aCols[N,nPD1_VUNIT] := nD1_VUNIT
	aCols[N,nPD1_TOTAL] := nD1_TOTAL
EndIf

aCols[N,nPD1_LOCAL] := GetMV("MV_CQ")

Return
