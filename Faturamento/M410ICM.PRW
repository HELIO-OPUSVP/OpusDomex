user function M410ICM()

If M->C5_CLIENT == '003673'
	_ALIQICM    := 12.00
	_VALICM     := Round( ( ( _BASEICM * _ALIQICM ) / 100 ), 2)
Endif

return