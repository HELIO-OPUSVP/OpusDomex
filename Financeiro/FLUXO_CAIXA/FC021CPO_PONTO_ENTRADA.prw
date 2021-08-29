/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FC021CPO  ºAutor  ³Mauricio L Souza  º Data ³    14/04/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para criar campo arq temporario           º±±
±±º          ³ flxo de caixa, utiliado para gerar log nesse ponto         º±±                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ DOMEX - OPUSVP                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Obs: basta Retornar .T. para validar a linha

*/

User Function FC021CPO()
    Local aCposAna := aClone(PARAMIXB)
    Local aRet := {}
    //AADD(aRet,{"TESTE","C",5,0} )
    // HISTORICO
    CV8->(DBSELECTAREA('CV8'))
    CV8->(DBSETORDER(1))
    RecLock("CV8",.T.)
    CV8->CV8_FILIAL := '01'
    CV8->CV8_DATA   := DATE()
    CV8->CV8_HORA   := Time()
    CV8->CV8_USER   :=  Subs(cUsuario,7,14)
    CV8->CV8_MSG    := "Execucao Fluxo de Caixa FC021CPO " + GetEnvServer()
    //CV8->CV8_DET    :=
    CV8->CV8_PROC   := 'FINC021'
    CV8->CV8_INFO   := '1'
    CV8->CV8_SBPROC :='FC021CPO'
    CV8->CV8_IDMOV  := '0002351519'
    CV8->( msUnlock() )

Return aClone(aRet)