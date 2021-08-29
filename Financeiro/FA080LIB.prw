#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA080LIB  �Autor  �Michel A. Sander    � Data �  01.06.2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada na baixa do contas a pagar para           ���
���          � anexar comprovante em PDF da Guia GNRE                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FA080LIB()

Local lAnexo := .T.

//���������������������������������������������������������������������Ŀ
//� Verifica se a baixa refere-se a guia gnre paga					         �
//�����������������������������������������������������������������������
If SE2->E2_PREFIXO=="ICM" .And. SE2->E2_FORNECE=="ESTADO" .And. SE2->E2_TIPO == PADR("TX",3) //.And. SE2->E2_XSTATUS == "1" Habilitar apos campo criado
	
	//���������������������������������������������������������������������Ŀ
	//� Busca o caminho para anexar o comprovante da guia gnre paga         �
	//�����������������������������������������������������������������������
	cArquivo := cGetFile( '*.pdf|*.pdf' ,'Informe o comprovante da GNRE em .pdf a ser anexado', 1, 'C:\'   , .T., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY ),.F., .T. )
	
	//���������������������������������������������������������������������Ŀ
	//� Copia o comprovante com o mesmo nome da guia gerada para pagamento  �
	//�����������������������������������������������������������������������
	If !Empty(cArquivo)
		cFilePrint  := "GNRE_"+SE2->E2_FILIAL+"_"+SE2->E2_PREFIXO+"_"+SE2->E2_NUM+"_"
		cFilePrint  += SE2->E2_PARCELA+"_"+SE2->E2_TIPO+"_"+SE2->E2_FORNECE+"_"+SE2->E2_LOJA+"_"+"Comprovante.pdf"
		For nQ := 1 to Len(cFilePrint)
			If AT("\",cFilePrint) > 0
				cFilePrint := SUBSTR(cFilePrint, AT("\",cFilePrint)+1)
			EndIf
		Next
		cFilePrint  := StrTran(cFilePrint," ","#")
		__cPathPDF  := "\system\GNRE_PDF\"
		If File(__cPathPDF+cFilePrint)
		   FErase(__cPathPDF+cFilePrint)
		EndIf   
		__CopyFile(cArquivo,__cPathPDF+cFilePrint)
	Else
		Aviso("Atencao","A guia nao foi anexada baixa permitida temporariamente.",{"Ok"})
	EndIf
	
EndIf

Return ( lAnexo )