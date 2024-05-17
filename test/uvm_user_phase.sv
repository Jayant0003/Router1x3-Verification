class uvm_user_phase extends uvm_task_phase;
protected function new(string name="");
  super.new(name);
  endfunction
  
  static const string type_name="uvm_user_phase";
  
  virtual function string get_type_name();
   return type_name;
   endfunction
   
   virtual task exec_task(uvm_component comp,uvm_phase phase);
     custom_phase test;
     if($cast(test,comp))
       test.user_phase(phase);
       endtask
       
       local static uvm_user_phase m_inst;
       
       static function uvm_user_phase get();
         if(m_inst==null)
           m_inst=new("phase");
           
           return m_inst;
           endfunction
           
   endclass
