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
::  arvo passes in the bowl to our door (if I understand correctly).
|_  =bowl:gall
+*  this  .
    default  ~(. (default-agent this %|) bowl)
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
  =.  state  
    :^    %0 
        1.000 
      *(map @ud shipinv.inb) 
    *(map [@ud @p] invoice.inb)
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
  =.  state  
    :^    %0 
        1.000 
      *(map @ud shipinv.inb) 
    *(map [@ud @p] invoice.inb)
  `this
  ==
::
::  Except for a little %noun handling left from the tutorial code from which
::  this was stolen, all pokes are using the app's dedicated mark.  Oh, and
::  I'm not entirely sure how the mark's boilerplate could conceivably add
::  some value, but maybe I'll figure that out eventually.  #TODO Figure that
::  out eventually.  Anyway, everything is delegated to handle-action.
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  |^
  =^  cards  state
  ?+  mark  (on-poke:default mark vase)
      %invoicer-action
        ~&  >>>  !<(action:inb vase)
        (handle-action !<(action:inb vase))
  ==
  [cards this]
  :: 
  ++  handle-action
  |=  =action:inb
  ^-  (quip card _state)
  ?-    -.action
  ::
  ::  Maybe you want your invoice numbering to start at something other than
  ::  1.000 (the current default)?  This is the action for you.
  ::
  ::  dojo example: > :invoicer &invoicer-action [%set-nextno 2.000]
      %set-nextno
    ?>  (team:title our.bowl src.bowl)
    ~&  >  'inside %set-nextno'
    ::  Test to ensure the key doesn't already exist, as you can't create an invoice with a duplicate number.
    ?<  (~(has by invsent.state) new.action)    
    =.  nextno.state  new.action
    :_  state
    ~
  ::
  ::  This action creates an invoice in your own invsent, and also 
  ::  pokes a corresponding one in the target ship's invrecd.  And 
  ::  for good measure, it increments the nextno counter to the next
  ::  available key.
  ::
  ::  dojo example: > :invoicer &invoicer-action [%create-inv ~zod "kerosene" %issued now now .9.35 %usd]
      %create-inv
    ?>  (team:title our.bowl src.bowl)
    ~&  >  'inside %create-inv'
    ::  Test to ensure the key doesn't already exist, don't want to overwrite anything.
    ?<  (~(has by invsent.state) nextno.state)
    =/  orig  nextno.state
    =/  next  +(orig)
    =/  shipknot=@ta  (scot %p recship.action)
    =/  numknot=@ta  (scot %ud orig)
    =/  statusknot=@ta  (scot %tas status.newinv.action)
    =/  mypath=path  
      ~[~.inv-wire numknot shipknot statusknot]
    |-
    ?:  (~(has by invsent.state) next)
      $(next +(next))
    =.  invsent.state  
      (~(put by invsent.state) [orig recship.action newinv.action])
    =.  nextno.state  next
    :_  state
    ~[[%pass mypath %agent [recship.action %invoicer] %poke %invoicer-action !>([%upsert-invrecd orig newinv.action])]]
  ::
  ::  If a ship needs to update an invoice it's already sent, this is the
  ::  action.  By specifying the key and the new version of the invoice, it'll
  ::  update it in your own invsent, and also poke it into the dest
  ::  ship's invrecd.
  ::
  ::  dojo example: > :invoicer &invoicer-action [%update-inv 999 "fudgets" %issued now now .9.35 %usd]
      %update-inv
    ?>  (team:title our.bowl src.bowl)
    ~&  >  'inside %update-inv'
    ::  Test to ensure the key does already exist, don't want to create anything new.
    ?>  (~(has by invsent.state) num.action)
    =/  shipandinv=shipinv.inb  
      (~(got by invsent.state) num.action)
    =/  ship=@p  dest.shipandinv
    =/  shipknot=@ta  (scot %p ship)
    =/  numknot=@ta  (scot %ud num.action)
    =/  statusknot=@ta  (scot %tas status.newinv.action)
    =/  mypath=path  
      ~[~.inv-wire numknot shipknot statusknot]
    =.  invsent.state  
      (~(put by invsent.state) [num.action ship newinv.action])
    :_  state
    ~[[%pass mypath %agent [ship %invoicer] %poke %invoicer-action !>([%upsert-invrecd num.action newinv.action])]]
  ::
  ::  Here's the action that gets remotely poked to make a corresponding entry
  ::  in invrecd when a sending ship creates or updates an
  ::  invoice delivered to this ship.
  ::
  ::  Don't run this from the dojo.  It's meant to be poked remotely via card.
      %upsert-invrecd
    ~&  >  'inside %upsert-invrecd'
    =.  invrecd.state  
      (~(put by invrecd.state) [[num.action src.bowl] newinv.action])
    :_  state
    ~
  ::
  ::  Retrieving an invoice by key from either the map of invoices you've sent
  ::  or the map of invoices you've received.  These really should feed into a
  ::  door that has sort, filter, & pagination capabilities.  #TODO Add them.
  ::
  ::  (technically, _this_ one retrieves an "shipinv", not an invoice)
  ::  dojo example: > :invoicer &invoicer-action [%get-from-invsent 999]
      %get-from-invsent 
    ?>  (team:title our.bowl src.bowl)
    ~&  >  'inside %get-from-invsent'
    ~&  (~(got by invsent.state) num.action)
    :_  state
    ~
  ::  dojo example: > :invoicer &invoicer-action [%get-from-invrecd 999 ~hatsyx-possum]
      %get-from-invrecd 
    ?>  (team:title our.bowl src.bowl)
    ~&  >  'inside %get-from-invrecd'
    ~&  (~(got by invrecd.state) [num.action ship.action])
    :_  state
    ~
  ::
  ::  Deleting an invoice by key from either the map of invoices you've sent
  ::  or the map of invoices you've received.
  ::
  ::  dojo example: > :invoicer &invoicer-action [%del-from-invsent 999]
      %del-from-invsent
    ?>  (team:title our.bowl src.bowl)
    ~&  >  'inside %del-from-invsent'
    =.  invsent.state  
      (~(del by invsent.state) num.action)
    :_  state
    ~
  ::  dojo example: > :invoicer &invoicer-action [%del-from-invrecd 999 ~hatsyx-possum]
      %del-from-invrecd
    ?>  (team:title our.bowl src.bowl)
    ~&  >  'inside %del-from-invrecd'
    =.  invrecd.state  
      (~(del by invrecd.state) [num.action ship.action])
    :_  state
    ~
  ==
  --
::  Handling the acks so we can eventually update status as verified received
::  #TODO Incorporate this into status workflow.
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire  (on-agent:default wire sign)
     [%inv-wire *]
    ?~  +.sign
    =/  numb  `@ud`(slav %ud +<:wire)
    =/  ship  `@p`(slav %p +>-:wire)
    =/  stat  `@tas`(slav %tas +>+<:wire)
    ~&  "{<stat>} {<numb>} {<-.sign>} by {<ship>}"  
    `this
    (on-agent:default wire sign)
  ==
::  Whole bunch of defaultin' goin' on...
++  on-watch  on-watch:default
++  on-leave  on-leave:default
++  on-peek   on-peek:default
++  on-arvo   on-arvo:default
++  on-fail   on-fail:default
--