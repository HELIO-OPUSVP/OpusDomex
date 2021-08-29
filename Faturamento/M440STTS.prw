#include "totvs.ch"

User Function M440STTS()      // "M410STTS"

If Subs(cUsuario,7,5) == "HELIO"
	MsgInfo("Mensgem teste PE M440STTS: SC9->C9_PEDIDO " + SC9->C9_PEDIDO)
EndIf

Return
