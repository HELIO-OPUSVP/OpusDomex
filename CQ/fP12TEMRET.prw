
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍº±±
±±ºPrograma  ³ FP12TEMRET ºAutor  ³ Osmar Ferreira   º Data ³  10/06/2022 º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºDesc.     º  Preenchimento do campo P12_TEMRET                         º±±
±±º          º  Chamada pelo gatilho no P12_HRRET                         º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºUso       º P11                                                        º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Grava o tempo entre a data de emissão e a data de retorno ao cliente
// no campo P12_TEMRET
// Chamado por gatilho
User Function fP12TemRet()
	Local nHH, nMM := 0
	If (!Empty(M->P12_DTRET)) .And. (!Empty(M->P12_HRRET))
		nHH := ((M->P12_DTRET - M->P12_DATA) * 24) + (Val(SubStr(M->P12_HRRET,1,2)) - Val(SubStr(M->P12_HORA,1,2)))
		nMM := Val(SubStr(M->P12_HRRET,4,2)) - Val(SubStr(M->P12_HORA,4,2))

		If nMM >= 0
			nMM := nMM / 100
			nHH := nHH + nMM
		Else
			nMM := nMM * (-1)
			nHH := nHH - (nMM / 60)
			nMM := nHH - Int(nHH)
			nHH := Int(nHH) + (nMM * 60 / 100)
		EndIf

	EndIf

Return(nHH)


