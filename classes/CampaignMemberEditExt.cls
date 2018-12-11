public with sharing class CampaignMemberEditExt {

    private CampaignMember record;

    public CampaignMemberEditExt(ApexPages.StandardController stdController) {
        record = (CampaignMember)stdController.getRecord();
        record = [SELECT ContactId, CampaignId, LeadId FROM CampaignMember WHERE Id = :record.Id];
    }
    
    public PageReference redirect() {
        PageReference ref = null;
        if(Apexpages.currentPage().getParameters().get('bofiRedirect') == null) {
            ref = new PageReference('/' + record.Id + '/e?bofiRedirect=true&retURL=%2F' + ((record.ContactId != null) ? record.ContactId : record.LeadId));
            ref.setRedirect(true);
        }
        return ref;
    }

}