#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "ap5mail.ch"
#INCLUDE "tbiconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � PRTDANFE �Autor  � Michel A. Sander   � Data �  21/08/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Impress�o autom�tica de DANFE pelo coletor	              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PRTDANFE()

Local cQuery := ""
Local cKebra := Chr(13)+Chr(10)
Local aAbreTab := {}                                        
Local aWfItens := {}
Local aWfEmpre := {}
Local cChave   := ""
Local lGuiaOk := .F.
Local cWfEmp := "01"
Local cWfFil := "01"
Local lLocalServ  := .F.

Private cVlrTotal := 0
Private cPathGuia := "\SYSTEM\GNRE_PDF\"
Private cTempGuia := "\TEMP_ANEXOS\"

If !lLocalServ 
   cPathGuia := cTempGuia
EndIf

//������������������������������������������������������Ŀ
//�Prepara fun��o para ser executada via JOB/Schedule		�
//��������������������������������������������������������
If Type("cEmpAnt") == "U"
	RPCSetType(3)
	aAbreTab := {}
	RpcSetEnv(cWfEmp,cWfFil,,,,,aAbreTab)
	SetUserDefault("000000")
EndIf

//���������������������������������������������������������������Ŀ
//� Busca as notas com emiss�o pelo coletor de dados 			  �
//�����������������������������������������������������������������
cAliasSF2 := GetNextAlias()

BeginSQL Alias cAliasSF2
	
	SELECT F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_NFICMST, F2_XXGUIA From %table:SF2% SF2 (NOLOCK), SPED050 (NOLOCK)
	WHERE F2_XCOLET = 'S'
	AND F2_XXAUTNF = 'N'
	AND ID_ENT = '000002'
	AND F2_SERIE + F2_DOC = NFE_ID
	AND STATUS = '6' AND F2_EMISSAO >= '20180406' 
	AND SF2.%NotDel%
	
EndSQL

//������������������������������������������������������Ŀ
//�Gera a DANFE para impress�o de NF sem guia	   		�
//��������������������������������������������������������
SF6->(dbSetOrder(3))
Do While (cAliasSF2)->(!Eof())
	
	//�������������������������������������������Ŀ
	//�Imprime comprovante GNRE pago					 �
	//���������������������������������������������
	If (cAliasSF2)->F2_XXGUIA == "S"
		
		SE2->(dbSetOrder(1))
		If SE2->(dbSeek(xFilial()+(cAliasSF2)->F2_NFICMST+Space(1)+PADR("TX",3)+"ESTADO"+"00"))
			If SE2->E2_SALDO > 0
				(cAliasSF2)->(dbSkip())
				Loop
			Else
				cFileGuia  := "GNRE_"+SE2->E2_FILIAL+"_"+SE2->E2_PREFIXO+"_"+SE2->E2_NUM+"_"
				cFileGuia  += SE2->E2_PARCELA+"_"+SE2->E2_TIPO+"_"+SE2->E2_FORNECE+"_"+SE2->E2_LOJA+".pdf"
				cFileGuia  := StrTran(cFileGuia," ","#")
				cFileCompr := "GNRE_"+SE2->E2_FILIAL+"_"+SE2->E2_PREFIXO+"_"+SE2->E2_NUM+"_"
				cFileCompr += SE2->E2_PARCELA+"_"+SE2->E2_TIPO+"_"+SE2->E2_FORNECE+"_"+SE2->E2_LOJA+"_"+"Comprovante.pdf"
				cFileCompr := StrTran(cFileCompr," ","#")
				If File(cPathGuia+cFileGuia)
				   If File("\SYSTEM\GNRE_PDF\"+cFileCompr) .And. !lLocalServ
						__CopyFile("\SYSTEM\GNRE_PDF\"+cFileCompr,cPathGuia+cFileCompr)
					EndIf				   
					If File(cPathGuia+cFileCompr)
						U_LptGnre(cFileGuia)                                               // Impress�o da GNRE
						U_LptCompr(cFileCompr)                                             // Impress�o do Comprovante pago da Guia Anexado
						cDanfeDoc := U_PDFDanfe((cAliasSF2)->F2_DOC,(cAliasSF2)->F2_SERIE) // Gera��o do PDF da Danfe
						U_LptDanfe(cDanfeDoc)                                              // Impress�o do PDF da Danfe
					EndIf
				EndIf
			EndIf
		Else
			(cAliasSF2)->(dbSkip())
			Loop
		EndIf
		
	Else
		
		cDanfeDoc := U_PDFDanfe((cAliasSF2)->F2_DOC,(cAliasSF2)->F2_SERIE, .F.) 
		U_LptDanfe(cDanfeDoc)                                              
		
	EndIf
	
	(cAliasSF2)->(dbSkip())
	
EndDo

(cAliasSF2)->(DbCloseArea())

Return