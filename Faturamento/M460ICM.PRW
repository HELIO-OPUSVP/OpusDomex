user function M460ICM()
Local aSaveArea	:= GetArea()

If SC5->C5_CLIENT == '003673'
	_ALIQICM    := 12.00
	_VALICM     := Round( ( ( _BASEICM * _ALIQICM ) / 100 ), 2)
Endif

RestArea(aSaveArea)
return