#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"
                       
/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  IniC7_NUM   �Autor  �Marcos Rezende     � Data �  24/09/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa criado e definido como inicializador pradr�o do   ���
���          � campo C7_NUM. Inicializa o numero dos Pedidos de Vendas    ���
���          � com o pr�ximo numero de Pedido dispon�vel para a filial.   ���
���          � Trabalha junto com o Ponto de Entrada MTA410() que, no     ���
���          � momento anterior a grava��o do Pedido, verifica se j�      ���
���          � existe o numeor sugerido por este programa e corrige o     ���
���          � M->C7_NUM caso j� tenha sido gravado um Pedido com o       ���
���          � numero.                                                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
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
