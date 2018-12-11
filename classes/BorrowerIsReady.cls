public class BorrowerIsReady {
    
    @InvocableMethod(label='Get Borrower' description='desc Invocable method')
    public static void  getBorrowerIds(List<Borrower__c> idB) {
        
        Borrower__c b = new Borrower__c();
        b= idB[0]; 
        updateBF(b.Boarding_Form__c);
        System.debug('Borrower process');
    }
    
    
    @future 
    public static void updateBF(Id bfId){
        
       Boarding_Form__c bf = new Boarding_Form__c(id=bfId, BorrowerReadyForSubmmit_SFDC2_del__c = true);
        update bf;        
        
    }
}