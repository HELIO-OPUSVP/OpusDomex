#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"
                       
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  IniC7_NUM   บAutor  ณMarcos Rezende     บ Data ณ  24/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa criado e definido como inicializador pradrใo do   บฑฑ
ฑฑบ          ณ campo C7_NUM. Inicializa o numero dos Pedidos de Vendas    บฑฑ
ฑฑบ          ณ com o pr๓ximo numero de Pedido disponํvel para a filial.   บฑฑ
ฑฑบ          ณ Trabalha junto com o Ponto de Entrada MTA410() que, no     บฑฑ
ฑฑบ          ณ momento anterior a grava็ใo do Pedido, verifica se jแ      บฑฑ
ฑฑบ          ณ existe o numeor sugerido por este programa e corrige o     บฑฑ
ฑฑบ          ณ M->C7_NUM caso jแ tenha sido gravado um Pedido com o       บฑฑ
ฑฑบ          ณ numero.                                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function IniC7_NUM()
Local _Retorno := ''

//cQuery := "SELECT ISNULL(MAX(C7_NUM),0) NOVONUM FROM " + RetSqlName("SC7") + " WHERE C7_NUM < '999999' AND C7_FILIAL = '"+xFilial("SC7")+"' AND D_E_L_E_T_ = ' '"
cQuery := "SELECT ISNULL(MAX(C7_NUM),0) NOVONUM FROM " + RetSqlName("SC7") + " WHERE C7_NUM < '300000' AND C7_FILIAL = '"+xFilial("SC7")+"' AND D_E_L_E_T_ = ' '"

If Select("TEMP") <> 0
	TEMP->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "TEMP"

cNovoNUM := TEMP->NOVONUM

cNovoNUM := StrZero(Val(cNovoNUM)+1,Len(SC7->C7_NUM))

TEMP->( dbCloseArea() )

_Retorno := cNovoNUM

Return _Retorno
