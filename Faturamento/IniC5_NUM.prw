#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  IniC5_NUM   บAutor  ณHelio Ferreira     บ Data ณ  20/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa criado e definido como inicializador pradrใo do   บฑฑ
ฑฑบ          ณ campo C5_NUM. Inicializa o numero dos Pedidos de Vendas    บฑฑ
ฑฑบ          ณ com o pr๓ximo numero de Pedido disponํvel para a filial.   บฑฑ
ฑฑบ          ณ Trabalha junto com o Ponto de Entrada MTA410() que, no     บฑฑ
ฑฑบ          ณ momento anterior a grava็ใo do Pedido, verifica se jแ      บฑฑ
ฑฑบ          ณ existe o numeor sugerido por este programa e corrige o     บฑฑ
ฑฑบ          ณ M->C5_NUM caso jแ tenha sido gravado um Pedido com o       บฑฑ
ฑฑบ          ณ numero.                                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex - SigaFat - Faturamento - MATA410()                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function IniC5_NUM()
Local _Retorno := ''

cQuery := "SELECT MAX(C5_NUM) NOVONUM FROM " + RetSqlName("SC5") + " WHERE C5_NUM < '999999' AND C5_FILIAL = '"+xFilial("SC5")+"' AND D_E_L_E_T_ = ' '"

If Select("TEMP") <> 0
	TEMP->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "TEMP"

cNovoC5_NUM := TEMP->NOVONUM

cNovoC5_NUM := StrZero(Val(cNovoC5_NUM)+1,Len(SC5->C5_NUM))

TEMP->( dbCloseArea() )

_Retorno := cNovoC5_NUM

Return _Retorno
