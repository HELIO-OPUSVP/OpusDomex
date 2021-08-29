//------------------------------------------------------------------------------------------------------------------------------------------------//
//Wederson Santana - 10/09/2012                                                                                                                   //
//------------------------------------------------------------------------------------------------------------------------------------------------//
//Especifico Domex - Estoque Custos                                                                                                               //
//Validacao na inclusao de movimentos internos.                                                                                                   //
//------------------------------------------------------------------------------------------------------------------------------------------------//
#Include "rwmake.ch"
User Function MT241TOK()
Local _nPosLot :=aScan(aHeader,{|x| AllTrim(x[2]) == "D3_LOTECTL"})
Local _nPosCod :=aScan(aHeader,{|x| AllTrim(x[2]) == "D3_COD"})
Local _nPosLoc :=aScan(aHeader,{|x| AllTrim(x[2]) == "D3_LOCAL"})
Local _nPosQtd :=aScan(aHeader,{|x| AllTrim(x[2]) == "D3_QUANT"})
Local _nDel    := Len(aHeader)+1//pegar a coluna de marcacao de exclusao
Local _aArea   :=GetArea()
Local _lRet    :=.T.

For _nCont:=1 To Len(aCols)
    If Empty(aCols[_nCont][_nPosLot]).And.! (aCols[n][_nDel]) 
       If Rastro( aCols[_nCont][_nPosCod] ).And.aCols[_nCont][_nPosQtd]>0
          dbSelectArea("SB8")
          dbSetOrder(3)
          If dbSeek(xFilial("SB8")+aCols[_nCont][_nPosCod]+aCols[_nCont][_nPosLoc]+"LOTE1308")
             If SB8->B8_SALDO >= aCols[_nCont][_nPosQtd]
                MsgInfo("O produto "+aCols[_nCont][_nPosCod]+" possui controle por Lote."+Chr(10)+;
                        "Favor selecionar um lote pressionando F4 no campo 'Lote'.","Controle Lote")
                _lRet:=.F.
             EndIf   
          EndIf
       EndIf
   EndIf    
Next 

RestArea(_aArea)
Return(_lRet)