|%
::  I'm not entirely sure what's the best way to deal with versioning of 
::  data structures in /sur that correspond to versioned-states in my 
::  gall app.  Is it a matter of creating multiple options for use here?
::  #TODO Figure this out.
::
::  Anyway, here's the state structure for invoicer: an invoice counter to 
::  increment, and two maps of invoices identified by a unique combination
::  of a @ud and a ship (either the one the invoice is being sent to, or
::  the one it came from (in the sent and receipt maps respectively)).  I
::  expect to eventually add archive maps of each as well for soft deletes.
+$  zerostate  [nextinvoicenumber=@ud sentinvoices=(map [@ud @p] invoice) receivedinvoicecopies=(map [@ud @p] invoice)]
::
::  Invoices themselves are starting out pretty simple, but will get bulked
::  up with time, with the intent of adding individual line items and taxes.
::  #TODO Add that stuff.
+$  invoice  [description=tape status=invoicestatus created=@da due=@da amount=@rs currency=@tas]
::  
::  This is as much a placeholder as anything else.  I plan on adding a status
::  workflow and convenience functions for progressing an invoice thru a
::  flow without needing to do full invoice update actions.  #TODO Support 
::  invoice status workflow.
+$  invoicestatus  $?(%issued %received %payment-sent %paid %overdue %canceled %archived)
::
::  Here's the set of actions supported in the app so far, and these will be
::  detailed in the helper core.  (%unsafe-delete-invoice will be replaced
::  with something a little more reversible, probably.)
+$  action
  $%  [%set-nextinvoicenumber newnumber=@ud]
      [%retrieve-invoice existingkey=[store=$?(%sent %received) num=@ud ship=@p]]
      [%unsafe-delete-invoice existingkey=[store=$?(%sent %received) num=@ud ship=@p]]
      [%create-invoice recipientkeyship=@p newinvoice=invoice]
      [%update-invoice existingkey=[num=@ud ship=@p] newinvoice=invoice]
      [%upsert-invoice-copy sendingkeynum=@ud newinvoice=invoice]
  ==
--