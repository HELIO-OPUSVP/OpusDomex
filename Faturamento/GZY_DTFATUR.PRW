#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GZY_DTFATUR �Autor  �Marco Aurelio     � Data �  08/04/19   ���
�������������������������������������������������������������������������͹�� 
���Prog.Ori  �GC6_FATUR  �Autor  �Helio Ferreira    � Data �  06/03/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatilho criado para preencher o campo ZY_DTOTD  com a      ���
���          � Data PCP, caso tenha sido preenchido a data de entrega     ���
�������������������������������������������������������������������������͹��
���Uso       � SigaFat                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function GZY_DTFATUR()  // Tratado

Local _Retorno     := M->ZY_DTFATUR  // Tratado
Local nPZY_DTOTD   := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "ZY_DTOTD" } )  		// Data OTD
Local nPZY_DTPCP   := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "ZY_DTPCP"  } )  	// Data PCP     
//Local nPZY_DTFATUR := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "ZY_DTFATUR" } )  	// Data de Entrega
//Local nPC6_ENTRE   := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_ENTREG"  } )  // Tratado   - Data Cliente      

If Empty(aCols[n,nPZY_DTOTD])
	aCols[n,nPZY_DTOTD] := aCols[n,nPZY_DTPCP]              // Data OTD recebe conteudo do campo Data PCP
EndIf


Return _Retorno
