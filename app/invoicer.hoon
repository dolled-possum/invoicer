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
=.  state  [%0 555 (my ~[[[1 ~hatsyx-possum] 1] [[2 ~hatsyx-possum] 2] [[3 ~hatsyx-possum] 3]]) ~dolled-possum]
::  =.  state  [%0 555 999 ~dolled-possum]
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
  =.  state  [%0 444 (my ~[[[1 ~hatsyx-possum] 11] [[2 ~hatsyx-possum] 22] [[3 ~hatsyx-possum] 33]]) ~dolled-possum]
  ::  =.  state  [%0 444 888 ~dolled-possum]
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
      %send-invoice
    ~&  >  'inside helperc, %send-invoice'
    :_  state
    ::  ~[[%pass /invoice-wire %agent [receiver.action %invoicer] %poke %invoicer-action !>([%add-invoice inv.action])]]
    ~
    ::
      %add-invoice
    ~&  >  'inside helperc, %add-invoice'
    ::  =.  invoices.state  [newinvoice.action invoices.state]
    =.  invoices.state  (~(put by invoices.state) [newkey.action newvalue.action])
    :_  state
    ~
      %retrieve-invoice
    ~&  >  'inside helperc, %retrieve-invoice'
    ~&  >>  (~(got by invoices.state) existingkey.action)
    :_  state
    ~
    ==
--