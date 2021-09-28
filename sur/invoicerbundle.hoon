|%
+$  zerostate  [nextinvoicenumber=@ud sentinvoices=(map [@ud @p] invoice) receivedinvoicecopies=(map [@ud @p] invoice)]
+$  invoice  [description=tape status=invoicestatus created=@da due=@da amount=@rs currency=@tas]
+$  invoicestatus  $?(%issued %received %payment-sent %paid %overdue %canceled %archived)
+$  action
  $%  [%set-nextinvoicenumber newnumber=@ud]
      [%retrieve-invoice existingkey=[store=$?(%sent %received) num=@ud ship=@p]]
      [%unsafe-delete-invoice existingkey=[store=$?(%sent %received) num=@ud ship=@p]]
      [%create-invoice existingkeyship=@p newinvoice=invoice]
      [%update-invoice existingkey=[num=@ud ship=@p] newinvoice=invoice]
  ==
--