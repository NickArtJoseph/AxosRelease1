public class CreateLeadFormController {

    public Lead myLead {get; set;}
    public List<SelectOption> listRecordTypeOptions {get; set;}
    private Set<String> setCompanyRequiredValues = new Set<String>();
    public String recordTypeSelected {get; set;}
    public Map<Integer, Attachment> mapAttachments {get; set;}
    @testVisible private Integer numAtt = Integer.valueOf(Label.numOfAttachments_createLeadForm);
    public Boolean hasError { get { return ApexPages.hasMessages(); } }
    public String broker = 'Broker -';

    // Record Types and Fields Mapping
    private Map<String, SharepointFieldMapping__mdt[]> mapRecordTypeSettings;
    public SharepointFieldMapping__mdt[] lstDynamicFields { get; set; }


  

    public CreateLeadFormController(ApexPages.StandardController controller) {


        initAttributes(controller);
        
        //Create picklist values with metadata types
        initRecordTypesAndMappings();                                                                                                                                                    
        //Create attachments inputs on VF                                           
        initAttachments();

     }

     private void initAttributes(ApexPages.StandardController controller) {
        myLead = (Lead) controller.getRecord();
        
     }
     /**
      * The instantiate of metadata, and group it in a map, with the Sub-Branch selected and their respective metadata fields 
      * @param  mapRecordTypeSettings 
      */
     private void initRecordTypesAndMappings() {
            SharepointSetting__mdt[] lstRecordTypeSettings = [
            SELECT SubBranch__c,
                (SELECT Field__c, Value__c, Field__r.Label, Field__r.ValueTypeId, Field__r.QualifiedApiName, Required__c, UIVisible__c FROM SharepointFieldMappings__r)
            FROM SharepointSetting__mdt
            WHERE IsActive__c = true
            ORDER BY SubBranch__c ASC
        ];

        listRecordTypeOptions = new List<SelectOption>();
        mapRecordTypeSettings = new Map<String, SharepointFieldMapping__mdt[]>();

        for (SharepointSetting__mdt recordTypeMtd : lstRecordTypeSettings) {
            // Add Values to Select Options
            listRecordTypeOptions.add(new SelectOption(recordTypeMtd.SubBranch__c, recordTypeMtd.SubBranch__c));

            // Group Mappings by Sub-Branch Name
            if(!mapRecordTypeSettings.containsKey(recordTypeMtd.SubBranch__c)) {
               mapRecordTypeSettings.put(recordTypeMtd.SubBranch__c, new List<SharepointFieldMapping__mdt>());
            }

            for (SharepointFieldMapping__mdt fieldMapping : recordTypeMtd.SharepointFieldMappings__r) {
                mapRecordTypeSettings.get(recordTypeMtd.SubBranch__c).add(fieldMapping);
            }
        }
        


        recordTypeSelected = listRecordTypeOptions[0].getLabel();
        //assignDynamicFields(); Yisus told me
        renderDynamicFields();
    }


    /**
    * Method to create the attachments space on the visualforce depending of the number receive in the Label  
    **/
    private void initAttachments() {
       
        mapAttachments = new Map<Integer, Attachment>();
        for( Integer i = 0; i < numAtt; i++) {
            mapAttachments.put(i, new Attachment());
        }
     }

    /**
     * Duplicate Validation executed before insert the Lead
     * @return Boolean 
     */
    private void validateDuplicate() {
        List<Lead> leadQuery = new List<Lead>();
        String brokerName = broker + myLead.FirstName; 
        leadQuery = [SELECT Id FROM Lead 
                    WHERE FirstName =: myLead.FirstName
                    AND LastName =: myLead.LastName
                    AND Email =: myLead.Email 
                    LIMIT 1];
        System.debug('Query Lista' + leadQuery);
        System.debug('Objeto Lead' + myLead);
        
        if(!leadQuery.isEmpty()) {
            throw new DuplicateException(Label.errorMsgDupe_createLeadForm);
        }
    } 
	
    /**
     * Method that remove the attachments not valid for the object and is executed after the Lead insertion
     */
    public void insertAttachments(){
        for (Integer index : mapAttachments.keySet()) {
            if(mapAttachments.get(index).Body == null) {
                mapAttachments.remove(index);
                continue;
            }
            mapAttachments.get(index).ParentId = myLead.Id;
        }
        if(mapAttachments.size() > 0)
        	insert mapAttachments.values();
    }
    
    /**
     * The render of dynamic fields on the VF page
     */
    public PageReference renderDynamicFields() {
        // Clear current values if needed
        if(lstDynamicFields != null && !lstDynamicFields.isEmpty()) {
            for (SharepointFieldMapping__mdt fieldMapping : lstDynamicFields) {
                myLead.put(fieldMapping.Field__r.QualifiedApiName, null);
            }
        }

        lstDynamicFields = mapRecordTypeSettings.get(recordTypeSelected);
        return null;
    }

    /**
     * Method that assigns the Id to the Lead Record and the mapping of every every metadata fields with the Lead fields
     */
    public PageReference assignDynamicFields() {
        Map<String, RecordTypeInfo> recordTypesMap = Schema.SObjectType.Lead.getRecordTypeInfosByName();
        
        System.debug('*****Subbranch Selected: ' + recordTypeSelected);
        System.debug('*****Field Mappings: ' + mapRecordTypeSettings.get(recordTypeSelected));
        System.debug('***lstDynamicFields ' +lstDynamicFields);
        lstDynamicFields = mapRecordTypeSettings.get(recordTypeSelected);
        
        
        for(SharepointFieldMapping__mdt fieldMapping : lstDynamicFields) {
            if(!fieldMapping.UIVisible__c) {
                // Record Type
                if(fieldMapping.Field__r.QualifiedApiName == 'RecordTypeId') {
                    String recordTypeId = recordTypesMap.get(fieldMapping.Value__c).getRecordTypeId();
                    myLead.put(fieldMapping.Field__r.QualifiedApiName, recordTypeId);
                }

                if(fieldMapping.Field__r.ValueTypeId == 'string') {
                    myLead.put(fieldMapping.Field__r.QualifiedApiName, fieldMapping.Value__c);
                } else if(fieldMapping.Field__r.ValueTypeId == 'double') {
                    myLead.put(fieldMapping.Field__r.QualifiedApiName, Double.valueOf(fieldMapping.Value__c));
                } else if(fieldMapping.Field__r.ValueTypeId == 'boolean') {
                    myLead.put(fieldMapping.Field__r.QualifiedApiName, Boolean.valueOf(fieldMapping.Value__c));
                }
            }
        }

        //System.debug(loggingLevel.DEBUG, '***   myLead: ' +   myLead);
          
        // TODO: Mapear otros campos variables
     
        return null;
    }


    /**
     * Method that validates the dynamic fields on VF are being introduced  
     * 
     */
    private void validateRequiredFieldsDynamic() {
       
        String[] lstErrorMessages = new String[]{};

        for ( SharepointFieldMapping__mdt  fieldMapping: lstDynamicFields) {
                if ( fieldMapping.Required__c == true && fieldMapping.UIVisible__c == true ){
                String leadFieldValue = String.valueOf(myLead.get(fieldMapping.Field__r.QualifiedApiName));
                if ( String.isBlank(leadFieldValue) ) {
                lstErrorMessages.add(fieldMapping.Field__r.Label + ': You must enter a value');
                    }
            }
        }
        if ( String.isBlank(myLead.Lead_Source_Detail_SFDC2__c) ) {
                lstErrorMessages.add( Label.OtherSourceLabel_LeadForm + ': You must enter a value');
        }

        if(!(lstErrorMessages.isEmpty())) {
            throw new FieldsValidationException(lstErrorMessages);
        }
    }

    /**
     * Method that saves the Lead 
     * @return PageReference
     */
    public PageReference saveLead() {

        try {
            
            //Mapping the metadata fields            
            assignDynamicFields();

            // Validate UI Required Fields
            //validateRequiredFieldsStatic();
            validateRequiredFieldsDynamic(); 
            validateDuplicate();
            insertLeadAndAttachments();

        } catch (FieldsValidationException fex) {
            
            System.debug(loggingLevel.Error, '*** VALIDATION ERROR: ' + fex);
            for(String errorMessage: fex.lstErrorMessages) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, errorMessage));
            }
        } catch (DuplicateException dex) {
            System.debug(loggingLevel.Error, '*** DUPLICATE ERROR: ' + dex);
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, dex.getMessage()));
        } catch(Exception e) {

            System.debug(loggingLevel.Error, '*** ERROR: ' + e);
            String errorMessage = Label.errorMsgApex_createLeadForm;
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, errorMessage));
        } finally {
            

            // Clean Attachment List 
            //initAttachments();
        }

        return null;
     } 

    private void insertLeadAndAttachments() {
        
        insert myLead;
        insertAttachments();

     }

    private class DuplicateException extends Exception {}
    private class FieldsValidationException extends Exception {
        public FieldsValidationException(String[] lstErrorMessages) {
            this.lstErrorMessages = lstErrorMessages;
        }

        public String[] lstErrorMessages { get; private set; }
    }
}