|%
+$  zerostate  [nextinvoicenumber=@ud sentinvoices=(map [@ud @p] invoice) receivedinvoicecopies=(map [@ud @p] invoice)]
+$  invoice  [description=tape status=invoicestatus created=@da due=@da amount=@rs currency=@tas]
+$  invoicestatus  $?(%issued %received %payment-sent %paid %overdue %canceled)
+$  action
  $%  [%set-nextinvoicenumber newnumber=@ud]
      [%send-invoice receiver=ship inv=invoice]
      [%add-invoice newkey=[@ud @p] newvalue=invoice]
      [%retrieve-invoice existingkey=[@ud @p]]
  ==
--