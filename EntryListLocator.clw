! Entry Incremental locator class
  ! Uses a Clarion control ID and Queue field       

                    member('')

                    MAP
                    end 

    include('EntryListLocator.inc')

EntryListLocator.Construct   procedure
    Code
    self.locatorvaluesize = 255    
    self.ControllocatorSearch  &= new(string(self.locatorvaluesize))
    self.Controllocatorvalue  &= new(string(self.locatorvaluesize))
          
EntryListLocator.Destruct   procedure
    Code            
   self.UnregistereventsLocator     
    
EntryListLocator.RegistereventsLocator     procedure   ! register object with accept loop
    Code     
    if self.ControlLocatorId > FALSE    
       REGISTER(EVENT:NewSelection,address(self.Newselectionevent),address(SELF),,self.ControlLocatorId) ! locator control new selection or keyboard event   
       REGISTER(EVENT:GainFocus,address(self.Gainfocusevent),address(SELF),,self.ControlLocatorId) ! locator control gained focus    
       REGISTER(event:displaycontrolist,address(self.DisplayListevent),address(SELF))  ! display the list control
       REGISTER(event:displaypreviouscontrol,address(self.SelectLocatorevent),address(SELF)) ! Select the previous control after the list box is sslected on located value
    END
    
EntryListLocator.UnregistereventsLocator    procedure   ! unregister object
  ! unregister object
    Code            
    if self.ControlLocatorId > FALSE    
       UnREGISTER(self.ControlLocatorId,address(self.Newselectionevent),address(SELF))    
       UnREGISTER(EVENT:GainFocus,address(self.Gainfocusevent),address(SELF),,self.ControlLocatorId) ! locator control gained focus    
       UnREGISTER(event:displaycontrolist,address(self.DisplayListevent),address(SELF))  ! display the list control
       UnREGISTER(event:displaypreviouscontrol,address(self.SelectLocatorevent),address(SELF)) ! Select the previous control after the list box is sslected on located value
  END

EntryListLocator.Listsearchvaluesize     procedure(long  listsearchvaluelocatorsize) ! set the default locator value size, it defaults to 255
    CODE
    self.locatorvaluesize = listsearchvaluelocatorsize    

EntryListLocator.ListType                procedure(Queue Q)
    Code
    self.Q &= Q    

EntryListLocator.Setlocatorvalue          procedure(string locatorsearchvalue) ! set locator search value
    CODE
    self.SetSearchvalue(locatorsearchvalue)     
    
EntryListLocator.SetSearchvalue          procedure(string locatorsearchvalue) ! set locator search value
lsize LONG
Lvalue  &STRING    
    CODE
    lsize =  len(clip( locatorsearchvalue )) 
    if lsize > self.locatorvaluesize    
       if not self.ControllocatorSearch &= null    
          dispose(self.ControllocatorSearch)    
          self.ControllocatorSearch  &= new(string(self.locatorvaluesize))
       END    
       if not self.Controllocatorvalue &= null    
          dispose(self.Controllocatorvalue)    
          self.Controllocatorvalue  &= new(string(self.locatorvaluesize))
       END    
       if not self.Controllocatorvalue &= NULL
          self.Controllocatorvalue = locatorsearchvalue    
       END    
       if not self.ControllocatorSearch &= NULL 
          self.ControllocatorSearch =  locatorsearchvalue 
       END
    ELSE
       if not self.Controllocatorvalue &= null    
          self.Controllocatorvalue = locatorsearchvalue   
       END
       if not self.ControllocatorSearch &= null    
          self.ControllocatorSearch =  locatorsearchvalue
       END 
    END    
        
EntryListLocator.SetNumericSearchvalue      procedure(long locatorsearchvalue) ! set numeric locator search value
    
    CODE
        
    
EntryListLocator.ListField    procedure(Long FieldNo)

    Code
    self.FieldNo = fieldNo    
   
EntryListLocator.ControlLocator  procedure(Long ControlFieldNo)

    Code
    Self.ControlLocatorId  = ControlFieldNo    
    self.RegistereventsLocator    
    self.ControlLocatorId{Prop:Use} = self.Controllocatorvalue
    
EntryListLocator.ControlList         procedure(long ControlidNo) ! control list id number

    CODE
    self.ListControlId = ControlidNo
    self.UnregistereventsLocator  ! unregister if control id changes
    self.RegistereventsLocator  ! register the locator control
        
EntryListLocator.Newselectionevent          procedure() ! event no, control field no
keychar LONG   
lkeycode  long    
    CODE
        
        lkeycode = Keycode()
       case lkeycode
        of BSKey
         if not (self.locatorvaluelen - 1) <= -1
            self.locatorvaluelen -= 1
            if  self.locatorvaluelen > 0   
                self.ControllocatorSearch = SUB(self.Controllocatorvalue,1,self.locatorvaluelen)  
          !  message('  key Back  space '&keyc#&'  '&Locatoractivityvalue)
                self.Controllocatorvalue = self.ControllocatorSearch
                self.Locateitem
            ELSE
                self.ControllocatorSearch = ''
                self.Controllocatorvalue = ''
            END    
            DISPLAY  
            post(event:displaycontrolist)
          END     
        of SpaceKey
           self.ControllocatorSearch = SUB(self.Controllocatorvalue,1,self.locatorvaluelen) & ' '
           self.locatorvaluelen += 1
          !  message('  key space key '&keyc#&'  '&Locatoractivityvalue)
           self.Controllocatorvalue = self.ControllocatorSearch
           self.Locateitem   
            DISPLAY
           post(event:displaycontrolist)
       
        ELSE
          ! Locatoravtivityvalue =  
        !     message('  key other '&keyc#&'  '&Locatoractivitysearchvalue)
            if lkeycode >= AKey and lkeycode <= ZKey
               self.ControllocatorSearch = SUB(self.Controllocatorvalue,1,self.locatorvaluelen) & CHR(KEYCHAR())
               self.locatorvaluelen += 1
               self.Controllocatorvalue = self.ControllocatorSearch
               self.Locateitem   
               post(event:displaycontrolist)
             END
             DISPLAY
        END
   !    message(lkeycode&'  '&DownKey)
        setkeycode(0)
        
        
EntryListLocator.Gainfocusevent     procedure() ! gain focus event id
    CODE
  !   of EVENT:gainfocus
     self.previouscontrol = self.ControlLocatorId
     select(self.ControlLocatorId,self.locatorvaluelen+1)
                
           
EntryListLocator.DisplayListevent           procedure() ! Display List event
    CODE
    ! of event:displaycontrolist
    select(self.ListControlId,self.ListRecordPtr)
    post(event:displaypreviouscontrol)
     
EntryListLocator.SelectLocatorevent         procedure() ! Select locator control event
    CODE
    ! of event:displaypreviouscontrol
    post(EVENT:GainFocus, self.ControlLocatorId,,self.locatorvaluelen)
     
            
EntryListLocator.Locateitem              procedure() ! locate item           
ctr   LONG 
fld1  ANY

    CODE
    if not self.q &= NULL
       fld1 &= what(self.q,self.FieldNo)    
        loop CTR = 1 to records(self.q)
        get(self.Q,ctr)
        if upper(fld1) >=  upper(self.ControllocatorSearch)
             self.ListRecordPtr = pointer(self.q) 
             BREAK 
         END    
        END 
     END    
     return(self.ListRecordPtr)    
        
        
EntryListLocator.locatenextitem              procedure() ! next item , down arrow key

    CODE
    if not self.q &= NULL
        if self.ListRecordPtr + 1 <= records(self.Q)    
          self.ListRecordPtr += 1
          get(self.q,self.ListRecordPtr)  
        END
    END
    
EntryListLocator.locatorpreviousitem        procedure() ! previous item , up arrow key               
        
    CODE
    if not self.q &= NULL
       if self.ListRecordPtr - 1 > 0     
          self.ListRecordPtr -= 1
          get(self.q,self.ListRecordPtr)  
        END
    END
       