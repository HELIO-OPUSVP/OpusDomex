#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  IniC5_NUM   �Autor  �Helio Ferreira     � Data �  20/08/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa criado e definido como inicializador pradr�o do   ���
���          � campo C5_NUM. Inicializa o numero dos Pedidos de Vendas    ���
���          � com o pr�ximo numero de Pedido dispon�vel para a filial.   ���
���          � Trabalha junto com o Ponto de Entrada MTA410() que, no     ���
���          � momento anterior a grava��o do Pedido, verifica se j�      ���
���          � existe o numeor sugerido por este programa e corrige o     ���
���          � M->C5_NUM caso j� tenha sido gravado um Pedido com o       ���
���          � numero.                                                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Domex - SigaFat - Faturamento - MATA410()                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
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
