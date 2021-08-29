#Include "topconn.ch"
#Include "rwmake.ch"
#Include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M410VRES  �Autor  �Ricardo Roda        � Data �  08/15/19   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada na valida��o da elimina��o de residuo     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Rosenberger                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User function  M410VRES()
Local lRet     := .T.  
Local aArea    := GetArea()
Local aAreaXD1 := XD1->( GetArea() )
Local aAreaSC2 := SC2->( GetArea() )

XD1->( Dbsetorder(6) )
IF  XD1->( DbSeek(xFilial("XD1")+ SC5->C5_NUM) )
   IF XD1->XD1_OCORRE<>'5' 
		If XD1->XD1_ULTNIV = 'S' .And. XD1->XD1_ZYNOTA <> ''
	  		MsgInfo("Estorno Processado com Sucesso.","Estorno Liberado")
	   		lRet:= .T.
		Else
//	   MsgInfo("Existem embalagens separadas para este pedido na expedi��o." + chr(13)+chr(10)+ "Favor verificar com a log�stica antes do estorno." ,"Aten��o")
	   		MsgAlert("Existem embalagens separadas para este pedido na expedi��o." + chr(13)+chr(10)+ "Favor verificar com a log�stica antes do estorno." )
	   		lRet:= .F.	  
		EndIf
	ELSE
//	   MsgInfo("Encontrado Pedido com ocorrencia 5 - Etiqueta Cancelada. " + chr(13)+chr(10)+ "Estorno Liberado ","aviso")
	   MsgInfo("Estorno Processado com Sucesso.","Estorno Liberado")
	   lRet:= .T.
	ENDIF   
Endif

//SC2->( Dbsetorder(12) )
//If SC2->( DbSeek(xFilial("SC2")+ SC5->C5_NUM) )
//	MsgInfo("Existe ordem de produ��o gerada para este pedido." + chr(13)+chr(10)+ "Favor verificar com a produ��o antes do estorno." , "aviso")
//	lRet:= .F.
//Endif

RestArea(aAreaSC2)
RestArea(aAreaXD1)            
RestArea(aArea)

Return lRet    

