
User Function MT175TOK()
Local _lRet     := .T.
Local _nPosTipo := aScan(aHeader,{|x| Alltrim(x[2]) == 'D7_TIPO' })
Local _nPosSald := aScan(aHeader,{|x| Alltrim(x[2]) == 'D7_SALDO'})

For nX := (nAcolsIni+1) to Len(aCols)
    Do Case
       Case aCols[nX, _nPosTipo]== 1 .And. aCols[nX, _nPosSald] > 0  // N�o aceita libera��o parcial    
            _lRet:=.F.
       Case aCols[nX, _nPosTipo]== 2 .And. aCols[nX, _nPosSald] > 0  // N�o aceita rejei��o parcial
            _lRet:=.F.         
       Case aCols[nX, _nPosTipo]== 6                                 // N�o aceita estorno
           //_lRet:=.F.     
       EndCase   
Next       
If! _lRet
   MsgInfo("Processo n�o permitido"+Chr(10)+"Utilizar Coletor","A T E N � � O ")
EndIf
Return(_lRet)