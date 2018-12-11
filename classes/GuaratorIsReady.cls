public class GuaratorIsReady {
    
    @InvocableMethod(label='Get Guarator' description='desc Invocable method')
    public static void  getGuaratorIds(List<Guarantor__c> idG) {
        
        Guarantor__c g = new Guarantor__c();
        g= idG[0]; 
        updateBF(g.Boarding_Form__c);
    }
    
    
    @future 
    public static void updateBF(Id bfId){
        
       Boarding_Form__c bf = new Boarding_Form__c(id=bfId, GuarantorReadyForSubmmit_SFDC2_del__c = true);
        update bf;        
        
    }
    
}