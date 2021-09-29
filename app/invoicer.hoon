::  Pull in my data types from /sur
/-  inb=invoicerbundle
::
::  Import some helpful libraries from /lib
/+  default-agent, dbug
::
::  Welcome to my core, with state and card types defined.  Only the zeroth
::  version to start with while still in pre-release development mode.
|%
+$  versioned-state
  $%  state-0
  ==
::
+$  state-0  [%0 zerostate:inb]
::
+$  card  card:agent:gall
::
--
%-  agent:dbug
=|  state=versioned-state
^-  agent:gall
=<
::  arvo passes in the bowl to our door (if I understand correctly).
|_  =bowl:gall
+*  this  .
    default  ~(. (default-agent this %|) bowl)
    helperc  ~(. +> bowl)
::
::  Now we're into the gall arms.
::
::  Starting for the first time, we've gotta create state ex nihilo and 
::  return it in the quip.  I'm initializing it with a starting invoice
::  counter of 1.000 and a sent and received invoice safely out of the
::  way of that counter.  No cards in the quip of this arm.
++  on-init
  ^-  (quip card _this)
  ~&  >  'invoicer initialization success'
  =.  state  [%0 1.000 (my ~[[999 ~hatsyx-possum "widgets" %issued now.bowl now.bowl .1.25 %usd]]) (my ~[[[999 ~hatsyx-possum] ["gadgets" %overdue now.bowl now.bowl .1.75 %usd]]])]
  `this
::
::  How the vase is obtained for the being-replaced-version of the app code
::  before arvo passes it off to the new version's on-load.
++  on-save
  ^-  vase
  !>(state)
::
::  Unlike on-init, on-load has a prior state context to start from.  This
::  can be tested to help achieve sensible migration paths for existing state
::  data.  Of course, I'm not doing anything sensible here, but am just 
::  completely ignoring the prior state once I confirm it's in the one (and 
::  only) versioned-state that exists (which I don't even have to do because
::  I'm just ignoring it, but will use later) and creating a brand new state 
::  out of nothing.  Eventually this will become something meant for actual
::  long term use.  No cards in this arm's returned quip.
++  on-load
  |=  old-state=vase
  ^-  (quip card _this)
  ~&  >  'invoicer recompilation success'
  =/  prev  !<(versioned-state old-state)
  ?-  -.prev
    %0
  =.  state  [%0 1.000 (my ~[[999 ~hatsyx-possum "fidgets" %issued now.bowl now.bowl .1.35 %usd]]) (my ~[[[999 ~hatsyx-possum] ["zidgets" %overdue now.bowl now.bowl .1.85 %usd]]])]
    `this
  ==
::
::  Except for a little %noun handling left from the tutorial code from which
::  this was stolen, all pokes are using the app's dedicated mark.  Oh, and
::  I'm not entirely sure how the mark's boilerplate could conceivably add
::  some value, but maybe I'll figure that out eventually.  #TODO Figure that
::  out eventually.  Anyway, everything is delegated to handle-action in the 
::  helper core.
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?+    mark  (on-poke:default mark vase)
      %noun
      ?+    q.vase  (on-poke:default mark vase)
        %print-state
        ?>  (team:title our.bowl src.bowl)
        ~&  >>  state
        ~&  >>>  bowl  `this
     ==
      %invoicer-action
      ~&  >>>  !<(action:inb vase)
      =^  cards  state
      (handle-action:helperc !<(action:inb vase))
      [cards this]
  ==
::
::  Whole bunch of defaultin' goin' on...
++  on-watch  on-watch:default
++  on-leave  on-leave:default
++  on-peek   on-peek:default
++  on-agent  on-agent:default
++  on-arvo   on-arvo:default
++  on-fail   on-fail:default
--
::
::  It's our helper core (helperc), handling the various poke actions that
::  might get applied.
|_  bowl=bowl:gall
++  handle-action
  |=  =action:inb
  ^-  (quip card _state)
  ?-    -.action
  ::
  ::  Maybe you want your invoice numbering to start at something other than
  ::  1.000 (the current default)?  This is the action for you.
  ::
  ::  dojo example: > :invoicer &invoicer-action [%set-nextinvoicenumber 2.000]
      %set-nextinvoicenumber
    ?>  (team:title our.bowl src.bowl)
    ~&  >  'inside helperc, %set-nextinvoicenumber'
    ::  Test to ensure the key doesn't already exist, as you can't create an invoice with a duplicate number.
    ?<  (~(has by invoicesivesent.state) newnumber.action)    
    =.  nextinvoicenumber.state  newnumber.action
    :_  state
    ~
  ::
  ::  This action creates an invoice in your own invoicesivesent, and also 
  ::  pokes a corresponding one in the target ship's invoicesivereceived.  And 
  ::  for good measure, it increments the nextinvoicenumber counter to the next
  ::  available key.
  ::
  ::  dojo example: > :invoicer &invoicer-action [%create-invoice ~zod "kerosene" %issued now now .9.35 %usd]
      %create-invoice
    ?>  (team:title our.bowl src.bowl)
    ~&  >  'inside helperc, %create-invoice'
    ::  Test to ensure the key doesn't already exist, don't want to overwrite anything.
    ?<  (~(has by invoicesivesent.state) nextinvoicenumber.state)
    =/  originalcounter  nextinvoicenumber.state
    =/  nextavailable  +(originalcounter)
    |-
    ?:  (~(has by invoicesivesent.state) nextavailable)
      $(nextavailable +(nextavailable))
    =.  invoicesivesent.state  (~(put by invoicesivesent.state) [originalcounter recipientkeyship.action newinvoice.action])
    =.  nextinvoicenumber.state  nextavailable
    :_  state
    ~[[%pass /invoice-wire %agent [recipientkeyship.action %invoicer] %poke %invoicer-action !>([%upsert-invoice-copy originalcounter newinvoice.action])]]
  ::
  ::  If a ship needs to update an invoice it's already sent, this is the
  ::  action.  By specifying the key and the new version of the invoice, it'll
  ::  update it in your own invoicesivesent, and also poke it into the recipient
  ::  ship's invoicesivereceived.
  ::
  ::  dojo example: > :invoicer &invoicer-action [%update-invoice 999 "fudgets" %issued now now .9.35 %usd]
      %update-invoice
    ?>  (team:title our.bowl src.bowl)
    ~&  >  'inside helperc, %update-invoice'
    ::  Test to ensure the key does already exist, don't want to create anything new.
    ?>  (~(has by invoicesivesent.state) existingkeynum.action)
    =/  retrievedinvoiceplusrecipient=invoiceplusrecipient.inb  (~(got by invoicesivesent.state) existingkeynum.action)
    =/  recipientship=@p  recipient.retrievedinvoiceplusrecipient
    =.  invoicesivesent.state  (~(put by invoicesivesent.state) [existingkeynum.action recipientship newinvoice.action])
    :_  state
    ~[[%pass /invoice-wire %agent [recipientship %invoicer] %poke %invoicer-action !>([%upsert-invoice-copy existingkeynum.action newinvoice.action])]]
  ::
  ::  Here's the action that gets remotely poked to make a corresponding entry
  ::  in invoicesivereceived when a sending ship creates or updates an
  ::  invoice delivered to this ship.
  ::
  ::  Don't run this from the dojo.  It's meant to be poked remotely via card.
      %upsert-invoice-copy
    ~&  >  'inside helperc, %upsert-invoice-copy'
    =.  invoicesivereceived.state  (~(put by invoicesivereceived.state) [[sendingkeynum.action src.bowl] newinvoice.action])
    :_  state
    ~[[%pass /upsertack-wire %agent [src.bowl %invoicer] %poke %invoicer-action !>([%upsert-ack sendingkeynum.action])]]
  ::
  ::  This action processes a manual poke acknowledgment that the ship that 
  ::  received the invoice creation or update did in fact receive it.
  ::  Ultimately, this can/will be used to update the status or an ack flag on
  ::  the canonical copy of the invoice held by the sender.
  ::
  ::  Don't run this from the dojo.  It's meant to be poked remotely via card.
      %upsert-ack
    ~&  >  'inside helperc, %upsert-ack'
    ~&  >  "invoice {<invoicenum.action>} acknowledged by {<src.bowl>}"
    :_  state
    ~
  ::
  ::  Retrieving an invoice by key from either the map of invoices you've sent
  ::  or the map of invoices you've received.  These really should feed into a
  ::  door that has sort, filter, & pagination capabilities.  #TODO Add them.
  ::
  ::  (technically, _this_ one retrieves an "invoiceplusrecipient", not an invoice)
  ::  dojo example: > :invoicer &invoicer-action [%retrieve-invoice-from-sent 999]
      %retrieve-invoice-from-sent 
    ?>  (team:title our.bowl src.bowl)
    ~&  >  'inside helperc, %retrieve-invoice-from-sent'
    ~&  >>  (~(got by invoicesivesent.state) existingkeynum.action)
    :_  state
    ~
  ::  dojo example: > :invoicer &invoicer-action [%retrieve-invoice-from-received 999 ~hatsyx-possum]
      %retrieve-invoice-from-received 
    ?>  (team:title our.bowl src.bowl)
    ~&  >  'inside helperc, %retrieve-invoice-from-received'
    ~&  >>  (~(got by invoicesivereceived.state) [existingkeynum.action existingkeyship.action])
    :_  state
    ~
  ::
  ::  Deleting an invoice by key from either the map of invoices you've sent
  ::  or the map of invoices you've received.
  ::
  ::  dojo example: > :invoicer &invoicer-action [%unsafe-delete-invoice-from-sent 999]
      %unsafe-delete-invoice-from-sent
    ?>  (team:title our.bowl src.bowl)
    ~&  >  'inside helperc, %unsafe-delete-invoice-from-sent'
    =.  invoicesivesent.state  (~(del by invoicesivesent.state) existingkeynum.action)
    :_  state
    ~
  ::  dojo example: > :invoicer &invoicer-action [%unsafe-delete-invoice-from-received 999 ~hatsyx-possum]
      %unsafe-delete-invoice-from-received
    ?>  (team:title our.bowl src.bowl)
    ~&  >  'inside helperc, %unsafe-delete-invoice-from-received'
    =.  invoicesivereceived.state  (~(del by invoicesivereceived.state) [existingkeynum.action existingkeyship.action])
    :_  state
    ~
  ==
--