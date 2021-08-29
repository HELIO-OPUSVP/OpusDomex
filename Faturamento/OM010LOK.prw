
#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OM010LOK   ºAutor  ³ Osmar Ferreira  º Data ³  30/06/2020   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Valida linha do cadastro da Tabela de Preço  (DA0 / DA1)  º±±
±±º          ³  Retorna variável tipo lógica                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function OM010LOK()
    Local lRet := .t.
    Local x := 0
    Local nLinhaAtu := 0
    Local cCodigo := ""
    Local nDA1CodPro
    Local nDA1Del

    Local nDA1Tabela
    Local nDA1Preco
    Local nDa1Aprovado
    Local nPreco    := 0
    Local cAprovado := Space(1) 
    Local cTabela   := Space(3)

    Local aAreaDA0 := DA0->( GetArea() )
    Local aAreaDA1 := DA1->( GetArea() )
    Local aAreaSA3 := SA3->( GetArea() )

    nDA1CodPro := aScan( aHeader, {|aVet| AllTrim(aVet[2]) == 'DA1_CODPRO'})
    nDA1Del    := Len(aHeader) + 1
    cCodigo    := AllTrim(aCols[n,nDA1CodPro])
    nLinhaAtu  := n
    
    nDA1Preco    := aScan( aHeader, {|aVet| AllTrim(aVet[2]) == 'DA1_PRCVEN'})
    nDA1Aprovado := aScan( aHeader, {|aVet| AllTrim(aVet[2]) == 'DA1_XAPROV'})
    nDA1Tabela   := aScan( aHeader, {|aVet| AllTrim(aVet[2]) == 'DA1_CODTAB'})
    nPreco       := aCols[n,nDA1Preco]
    cAprovado    := AllTrim(aCols[n,nDA1Aprovado])
    cTabela      := AllTrim(aCols[n,nDA1Tabela])


    For x := 1 to Len(aCols)
        If !aCols[x,Len(aCols[x])] // Testando se a linha não está deletada
            If AllTrim(aCols[x,nDA1CodPro]) == cCodigo .And. x <> nLinhaAtu
                apMsgInfo("O produto "+cCodigo+" já esta cadastrado nesta tabela!"+Chr(13)+"Veja a linha "+Str(x)+".","A T E N Ç Ã O")
                lRet := .f.
                Exit
            EndIf
        EndIf
    Next x

// Em desenvolvimento Osmar 04/03/21
//If lRet
//   //Verifica se o usuário não é um vendedor, neste caso se alterar o preço ficará bloqueado
//   SA3->( dbSetOrder(07) )
//   If !SA3->( dbSeek( xFilial() + __cUserID ))
//       DA1->( dbSetOrder(01) ) 
//       If DA1->(dbSeek(xFIlial()+cTabela+cCodigo))        
//          If (DA1->DA1_XAPROV == 'S') .And. (DA1->DA1_XPRCAP <> nPreco)  //O preço foi alterado 
//             If msgYesNo('A T E N Ç Ã O!!! O preço foi alterado e será bloqueado!!'+Chr(13)+'Confirma a alteração?')
//                aCols[n,nDA1Aprovado] := 'N'   //Bloqueia o uso deste valor
//             Else
//                aCols[n,nDA1Preco] := DA1->DA1_XPRCAP  //Volta o valor correto/aprovado
//             EndIf   
//          EndIf  
//       Else
//          aCols[n,nDA1Aprovado] := 'N' //Preço novo deve nascer bloqueado
//       EndIf     
//   EndIf
//EndIf

    RestArea(aAreaSA3)
    RestArea(aAreaDA1)
    RestArea(aAreaDA0)

Return(lRet)


