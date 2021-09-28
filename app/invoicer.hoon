/-  inb=invoicerbundle
/+  default-agent, dbug
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
|_  =bowl:gall
+*  this  .
    default  ~(. (default-agent this %|) bowl)
    helperc  ~(. +> bowl)
::
++  on-init
  ^-  (quip card _this)
  ~&  >  'invoicer initialization success'
::  =.  state  [%0 555 (my ~[[[1 ~hatsyx-possum] ["widgets" %unpaid]] [[2 ~hatsyx-possum] ["gadgets" %prepaid]] [[3 ~hatsyx-possum] ["fidgets" %paid]]]) ~dolled-possum]
=.  state  [%0 555 (my ~[[[1 ~hatsyx-possum] ["widgets" %issued now.bowl now.bowl .1.25 %usd]]]) (my ~[[[1 ~hatsyx-possum] ["gadgets" %overdue now.bowl now.bowl .1.75 %usd]]])]
  `this
++  on-save
  ^-  vase
  !>(state)
++  on-load
  |=  old-state=vase
  ^-  (quip card _this)
  ~&  >  'invoicer recompilation success'
::  =/  prev  !<(versioned-state old-state)
  =/  prev  [%0 old-state]
  ?-  -.prev
    %0
::  =.  state  [%0 444 (my ~[[[1 ~hatsyx-possum] ["wudgets" %unpaid]] [[2 ~hatsyx-possum] ["gudgets" %prepaid]] [[3 ~hatsyx-possum] ["fudgets" %paid]]]) ~dolled-possum]
  =.  state  [%0 555 (my ~[[[1 ~hatsyx-possum] ["fidgets" %issued now.bowl now.bowl .1.35 %usd]]]) (my ~[[[1 ~hatsyx-possum] ["bridgets" %overdue now.bowl now.bowl .1.85 %usd]]])]
    `this
  ==
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?+    mark  (on-poke:default mark vase)
      %noun
      ?+    q.vase  (on-poke:default mark vase)
        %print-state
        ~&  >>  state
        ~&  >>>  bowl  `this
     ==
      %invoicer-action
      ~&  >>>  !<(action:inb vase)
      =^  cards  state
      (handle-action:helperc !<(action:inb vase))
      [cards this]
  ==
++  on-watch  on-watch:default
++  on-leave  on-leave:default
++  on-peek   on-peek:default
++  on-agent  on-agent:default
++  on-arvo   on-arvo:default
++  on-fail   on-fail:default
--
::  helper core (helperc)
|_  bowl=bowl:gall
++  handle-action
  |=  =action:inb
  ^-  (quip card _state)
  ?-    -.action
      %set-nextinvoicenumber
    ~&  >  'inside helperc, %set-nextinvoicenumber'
    =.  nextinvoicenumber.state  newnumber.action
    :_  state
    ~
    ::
    ::  %send-invoice
    :: ~&  >  'inside helperc, %send-invoice'
    :: :_  state
    ::  ~[[%pass /invoice-wire %agent [receiver.action %invoicer] %poke %invoicer-action !>([%add-invoice inv.action])]]
    :: ~
    ::
    ::  %add-invoice
    ::~&  >  'inside helperc, %add-invoice'
    ::  =.  invoices.state  [newinvoice.action invoices.state]
    ::=.  sentinvoices.state  (~(put by sentinvoices.state) [newkey.action newvalue.action])
    :::_  state
    ::~
      %create-invoice
    ~&  >  'inside helperc, %create-invoice'
    =/  originalcounter  nextinvoicenumber.state
    ~&  >  originalcounter
    ~&  >  existingkeyship.action
    ?<  (~(has by sentinvoices.state) [originalcounter existingkeyship.action])
    =.  sentinvoices.state  (~(put by sentinvoices.state) [[originalcounter existingkeyship.action] newinvoice.action])
    =.  nextinvoicenumber.state  +(originalcounter)
    :_  state
    ~
    ::
      %update-invoice
    ~&  >  'inside helperc, %update-invoice'
    ?>  (~(has by sentinvoices.state) [num.existingkey.action ship.existingkey.action])
    =.  sentinvoices.state  (~(put by sentinvoices.state) [[num.existingkey.action ship.existingkey.action] newinvoice.action])
    :_  state
    ~
    ::
      %retrieve-invoice
    ~&  >  'inside helperc, %retrieve-invoice'
    =/  searchinvoices  
      ?-  store.existingkey.action
        %sent  sentinvoices.state
        %received  receivedinvoicecopies.state
      ==
    ~&  >>  (~(got by searchinvoices) [num.existingkey.action ship.existingkey.action])
    :_  state
    ~
    ::
      %unsafe-delete-invoice
    ~&  >  'inside helperc, %unsafe-delete-invoice'
    ::  this will be replaced with an archive command I expect
    ?-  store.existingkey.action
      %sent  
        =/  newmap  (~(del by sentinvoices.state) [num.existingkey.action ship.existingkey.action])
        =.  sentinvoices.state  newmap
        :_  state
        ~
      %received  
        =/  newmap  (~(del by receivedinvoicecopies.state) [num.existingkey.action ship.existingkey.action])
        =.  receivedinvoicecopies.state  newmap
        :_  state
        ~
       ==
    ==
--