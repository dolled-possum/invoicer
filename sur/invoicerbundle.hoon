|%
::  I'm not entirely sure what's the best way to deal with versioning of 
::  data structures in /sur that correspond to versioned-states in my 
::  gall app.  Is it a matter of creating multiple options for use here?
::  #TODO Figure this out.
::
::  Anyway, here's the state structure for invoicer: an invoice counter to 
::  increment, and two maps:  one of pairs of a recipient ship and an invoice
::  I've sent, identified by a @ud, and one of invoices I've received 
::  identified by a unique combination of a @ud and a sending ship.  I
::  expect to eventually add archive maps of each as well for soft deletes.
::
::  Note:  The map of sent invoices (with their recipients) is canonical, the
::  source of truth.  The sender can make modifications and will send updates 
::  about those modifications to the receiver.  The map of received invoices is
::  just a bunch of local copies of the sender's canonical source invoices. I
::  had originally considered just keeping a list of the map keys here, 
::  requiring the dynamic fetching of the actual current invoice data from the
::  senders, but ultimately I went for the convenience of having a local copy
::  to sort, filter, etc..  I might add functionality to allow refreshes from
::  the canonical source, as well as a last-updated stamp.  #TODO Think about
::  this in the context of auto-retry and ordering and such.
+$  zerostate  [nextno=@ud invsent=(map @ud shipinv) invrecd=(map [@ud @p] invoice)]
::
::  My invoices I generate are uniquely identified by a number, and are linked 
::  to a recipient ship.
+$  shipinv  [dest=@p inv=invoice]
::
::  Invoices themselves are starting out pretty simple, but will get bulked
::  up with time, with the intent of adding individual line items and taxes.
::  #TODO Add that stuff.
+$  invoice  [description=tape status=invstatus created=@da due=@da amount=@rs curr=@tas]
::  
::  This is as much a placeholder as anything else.  I plan on adding a status
::  workflow and convenience functions for progressing an invoice thru a
::  flow without needing to do full invoice update actions.  #TODO Support 
::  invoice status workflow.
+$  invstatus  $?(%issued %received %payment-sent %paid %overdue %canceled %archived)
::
::  Here's the set of actions supported in the app so far, and these will be
::  detailed in the helper core.  (%del-from-inv flavors will be 
::  replaced with something a little more reversible, probably.)
+$  action
  $%  [%set-nextno new=@ud]
      [%get-from-invsent num=@ud]
      [%get-from-invrecd num=@ud ship=@p]
      [%del-from-invsent num=@ud]
      [%del-from-invrecd num=@ud ship=@p]
      [%create-inv recship=@p newinv=invoice]
      [%update-inv num=@ud newinv=invoice]
      [%update-inv-status num=@ud status=invstatus]
      [%upsert-invrecd num=@ud newinv=invoice]
    ==
--
