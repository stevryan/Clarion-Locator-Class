
! Clarion specific locator control entry class
! Supports a search on a clarion queue.

event:displaycontrolist        equate(5000)
event:displaypreviouscontrol   equate(5001)

EntryListLocator    Class,TYPE ,module('EntryListLocator.clw'),link('EntryListLocator.clw',1)                       
Q                       &QUEUE  ! queue to locate on
FieldNo                 LONG    ! field in queue to locate on 
ControlLocatorId        LONG    ! Control locator Id
LocatorTyoe             byte    ! string or numeric , date or time
ListControlId           long    ! List Control Id
Controllocatorvalue     &string ! Control Locator value, default 255
ControllocatorSearch    &string ! Control Locator search value
Locatedrecordno         long   ! located record number
locatorvaluelen         long   ! lenght of locator value
previouscontrol         LONG   ! previous control 
ListRecordPtr           long   ! List record pointer
locatorvaluesize        long   ! default locator search value size for strings
Construct               procedure
Destruct                procedure
RegistereventsLocator   procedure   ! register object with accept loop
UnregistereventsLocator procedure   ! unregister object
Listsearchvaluesize     procedure(long  listsearchvaluelocatorsize) ! set the default locator value size, it defaults to 255
ListType                procedure(Queue Q)   ! list to locate on
ListField               procedure(Long FieldNo) ! field number in list to locate
SetSearchvalue          procedure(string locatorsearchvalue) ! set locator search value
Setlocatorvalue         procedure(string locatorvalue) ! set locator value
SetNumericSearchvalue   procedure(long locatorsearchvalue) ! set numeric locator search value
ControlLocator          procedure(Long ControlFieldNo) ! Control locator 
ControlList             procedure(long ControlidNo) ! control list id number
Newselectionevent          procedure() ! event no, control field no
Gainfocusevent             procedure() ! gain focus event id
DisplayListevent           procedure() ! Display List event
SelectLocatorevent         procedure() ! Select locator control event
Locateitem                 procedure,LONG ! locate item  
locatenextitem             procedure() ! next item , down arrow key
locatorpreviousitem        procedure() ! previous item , up arrow key
                    END
