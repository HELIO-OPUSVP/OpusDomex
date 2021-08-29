
// Programa para criar OP para as lacucas de numeração que não existam. O sistema está criando 
// OPs com numerações antigas aleatoriamente. Este programa preenche estas lacuas

User Function Temp01()
Local x
RpcSetEnv("01","01",{})

SC2->( dbSetOrder(1) )

For x := 1 to 96398

   If !SC2->( dbSeek( xFilial() + Alltrim(StrZero(x,5)) + ' ' + '01001') )
        Reclock("SC2",.T.)
        SC2->C2_FILIAL := xFilial("SC2")
        SC2->C2_NUM    := Alltrim(StrZero(x,5))
        SC2->C2_ITEM   := '01'
        SC2->C2_SEQUEN := '001'
        SC2->C2_PRODUTO := '11012DH0L1K5   '
        SC2->C2_LOCAL   := '97'
        SC2->C2_QUANT   := 0
        SC2->C2_UM      := 'UN'
        SC2->C2_DATPRI  := StoD('19800101')
        SC2->C2_DATPRF  := StoD('19800101')
        SC2->C2_OBS     := 'OP TESTE - NAO APAGAR'
        SC2->C2_EMISSAO := StoD('19800101')
        SC2->C2_PRIOR   := '500'
        SC2->C2_QUJE    := 0
        SC2->C2_DATRF   := StoD('19800101')
        SC2->C2_DESTINA := 'P'
        SC2->C2_NIVEL   := ''
        SC2->C2_TPOP    := 'F'
        SC2->( msUnlock() )

        //Exit
   EndIf

Next x

Return