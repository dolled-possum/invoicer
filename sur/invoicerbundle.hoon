|%
+$  zerostate  [nextinvoicenumber=@ud invoices=(map [@ud @p] @ud) sender=@p]
::  +$  zerostate  [nextinvoicenumber=@ud invoices=@ud sender=@p]
+$  invoice  [invoicenumber=@ud total=@ud]
+$  action
  $%  [%set-nextinvoicenumber newnumber=@ud]
      [%send-invoice receiver=ship inv=invoice]
::      [%add-invoice newinvoice=invoice]
      [%add-invoice newkey=[@ud @p] newvalue=@ud]
      [%retrieve-invoice existingkey=[@ud @p]]
  ==
--