/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT120GRV  �Autor  �Marcos Rezende      � Data �  09/24/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada respons�vel por validar a numera��o do    ���
���          � pedido de compras                                          ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"

user function MT120GRV
Local lInclui
Local lRet := .t.

lInclui := PARAMIXB[2]

//verifica a rotina que esta sendo chamada para realizar a valida��o do campo C7_XTPPC	
if FunName()="MATA121"
	IF EMPTY(_cTPPC )
	_cTPPC := "NR "
	//	ALERT("O tipo de pedido n�o foi preenchido, por favor informe conforme tipos existentes"  )
	endif
endif
if linclui .and. lRet
	cQuery := "SELECT ISNULL(MAX(C7_NUM),0) NOVONUM FROM " + RetSqlName("SC7") + " WHERE C7_NUM < '999999' AND C7_FILIAL = '"+xFilial("SC7")+"' AND D_E_L_E_T_ = ' '"
	
	If Select("TEMP") <> 0
		TEMP->( dbCloseArea() )
	EndIf
	
	TCQUERY cQuery NEW ALIAS "TEMP"
	cNovoNUM := TEMP->NOVONUM
	cNovoNUM := StrZero(Val(cNovoNUM)+1,Len(SC7->C7_NUM))
	
	m->c7_num := cNovoNum
	
	TEMP->( dbCloseArea() )
	lret := .t.

	
endif            
/*                                        
   IF ISINCALLSTACK('MATA121')
   	IF empty(_cTPPC)
   		msalert('O tipo do pedido deve ser preenchido')
   		lret := .f.
   	else
   		lret := .t.
   	endif
   endif
*/
/*
If !Acols[n][len(aHeader)+1] //nao pega quando a linha esta deletada
	//Grava campos criados no cabe�alho do pedido
	RecLock("SC7",.F.)
	SC7->C7_XTPPC := _cTPPC
	MsUnlock("SC7")
endif
*/

if linclui 
	IF _cTPPC <> 'RP'
		alert('Pedidos de compras devem ser gerados a partir de cota��o'+chr(13)+'Todas os dados foram desconsiderados')
		lret := .f.
	endif
endif
return lret
