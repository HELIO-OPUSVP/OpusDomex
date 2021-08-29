
User Function MT175TOK()
Local _lRet     := .T.
Local _nPosTipo := aScan(aHeader,{|x| Alltrim(x[2]) == 'D7_TIPO' })
Local _nPosSald := aScan(aHeader,{|x| Alltrim(x[2]) == 'D7_SALDO'})

For nX := (nAcolsIni+1) to Len(aCols)
    Do Case
       Case aCols[nX, _nPosTipo]== 1 .And. aCols[nX, _nPosSald] > 0  // Não aceita liberação parcial    
            _lRet:=.F.
       Case aCols[nX, _nPosTipo]== 2 .And. aCols[nX, _nPosSald] > 0  // Não aceita rejeição parcial
            _lRet:=.F.         
       Case aCols[nX, _nPosTipo]== 6                                 // Não aceita estorno
           //_lRet:=.F.     
       EndCase   
Next       
If! _lRet
   MsgInfo("Processo não permitido"+Chr(10)+"Utilizar Coletor","A T E N Ç Ã O ")
EndIf
Return(_lRet)