({
   doInit: function(component, event, helper) {
      component.find("boardingFormRecordCreator").getNewRecord(
         "Boarding_Form__c",
         null,
         true,
         $A.getCallback(function() {
            var rec = component.get("v.newFormRecord");
            var oldRec = component.get("v.oldBoardingForm");
            var newRec = component.get("v.newBoardingForm");
                
            // Form initial data
            newRec.BF_Status__c                                         = oldRec.BF_Status__c;
            newRec.Opportunity__c                                       = oldRec.Opportunity__c;
            newRec.Related_LOQ__c                                       = oldRec.Related_LOQ__c;
            // Borrower Data
            // newRec.BWR_Legal_Name__c                                    = oldRec.BWR_Legal_Name__c;
            // newRec.BWR_Legal_Name_Source_Page__c                        = oldRec.BWR_Legal_Name_Source_Page__c;
            // newRec.Borrower_Mailing_Address_Street__c                   = oldRec.Borrower_Mailing_Address_Street__c;
            // newRec.BWR_Mailing_Address_Street_Source_Page__c            = oldRec.BWR_Mailing_Address_Street_Source_Page__c;
            // newRec.Borrower_Mailing_Address_City__c                     = oldRec.Borrower_Mailing_Address_City__c;
            // newRec.BWR_Mailing_Address_City_Source_Page__c              = oldRec.BWR_Mailing_Address_City_Source_Page__c;
            // newRec.Borrower_Mailing_Address_State__c                    = oldRec.Borrower_Mailing_Address_State__c;
            // newRec.BWR_Mailing_Address_State_Source_Page__c             = oldRec.BWR_Mailing_Address_State_Source_Page__c;
            // newRec.Borrower_Mailing_Address_Postal_Code__c              = oldRec.Borrower_Mailing_Address_Postal_Code__c;
            // newRec.BWR_Mailing_Postal_Code_Source_Page__c               = oldRec.BWR_Mailing_Postal_Code_Source_Page__c;
            // newRec.Borrower_Mailing_Address_Country__c                  = oldRec.Borrower_Mailing_Address_Country__c;
            // newRec.BWR_Mailing_Country_Source_Page__c                   = oldRec.BWR_Mailing_Country_Source_Page__c;
            // newRec.Borrower_Phone_Number__c                             = oldRec.Borrower_Phone_Number__c;
            // newRec.BWR_Phone_Number_Source_Page__c                      = oldRec.BWR_Phone_Number_Source_Page__c;
            // newRec.Borrower_Email_Address__c                            = oldRec.Borrower_Email_Address__c;
            // newRec.BWR_Email_Address_Source_Page__c                     = oldRec.BWR_Email_Address_Source_Page__c;
            // newRec.Borrower_Tax_ID_Number__c                            = oldRec.Borrower_Tax_ID_Number__c;
            // newRec.BWR_Tax_ID_Number_Source_Page__c                     = oldRec.BWR_Tax_ID_Number_Source_Page__c;
            // newRec.Borrower_Tax_ID_Number_Type__c                       = oldRec.Borrower_Tax_ID_Number_Type__c;
            // newRec.BWR_Tax_ID_Number_Type_Source_Page__c                = oldRec.BWR_Tax_ID_Number_Type_Source_Page__c;
            // newRec.Borrower_Class_Code__c                               = oldRec.Borrower_Class_Code__c;
            // newRec.BWR_Class_Code_Source_Page__c                        = oldRec.BWR_Class_Code_Source_Page__c;

                // Borrower 2 Data
            // newRec.BWR_2_Legal_Name__c                                  = oldRec.BWR_2_Legal_Name__c;
            // newRec.BWR_2_Legal_Name_Source_Page__c                      = oldRec.BWR_2_Legal_Name_Source_Page__c;
            // newRec.BWR_2_Mailing_Address_Street__c                      = oldRec.BWR_2_Mailing_Address_Street__c;
            // newRec.BWR_2_Mailing_Street_Source_Page__c                  = oldRec.BWR_2_Mailing_Street_Source_Page__c;
            // newRec.BWR_2_Mailing_Address_City__c                        = oldRec.BWR_2_Mailing_Address_City__c;
            // newRec.BWR_2_Mailing_Address_City_Source_Page__c            = oldRec.BWR_2_Mailing_Address_City_Source_Page__c;
            // newRec.BWR_2_Mailing_Address_State__c                       = oldRec.BWR_2_Mailing_Address_State__c;
            // newRec.BWR_2_Mailing_State_Source_Page__c                   = oldRec.BWR_2_Mailing_State_Source_Page__c;
            // newRec.BWR_2_Mailing_Address_Postal_Code__c                 = oldRec.BWR_2_Mailing_Address_Postal_Code__c;
            // newRec.BWR_2_Mailing_Postal_Code_Source_Page__c             = oldRec.BWR_2_Mailing_Postal_Code_Source_Page__c;
            // newRec.BWR_2_Mailing_Address_Country__c                     = oldRec.BWR_2_Mailing_Address_Country__c;
            // newRec.BWR_2_Mailing_Country_Source_Page__c                 = oldRec.BWR_2_Mailing_Country_Source_Page__c;
            // newRec.BWR_2_Phone_Number__c                                = oldRec.BWR_2_Phone_Number__c;
            // newRec.BWR_2_Phone_Number_Source_Page__c                    = oldRec.BWR_2_Phone_Number_Source_Page__c;
            // newRec.BWR_2_Email_Address__c                               = oldRec.BWR_2_Email_Address__c;
            // newRec.BWR_2_Email_Address_Source_Page__c                   = oldRec.BWR_2_Email_Address_Source_Page__c;
            // newRec.BWR_2_Tax_ID_Number__c                               = oldRec.BWR_2_Tax_ID_Number__c;
            // newRec.BWR_2_Tax_ID_Number_Source_Page__c                   = oldRec.BWR_2_Tax_ID_Number_Source_Page__c;
            // newRec.BWR_2_Tax_ID_Number_Type__c                          = oldRec.BWR_2_Tax_ID_Number_Type__c;
            // newRec.BWR_2_Tax_ID_Number_Type_Source_Page__c              = oldRec.BWR_2_Tax_ID_Number_Type_Source_Page__c;
            // newRec.BWR_2_Class_Code__c                                  = oldRec.BWR_2_Class_Code__c;
            // newRec.BWR_2_Class_Code_Source_Page__c                      = oldRec.BWR_2_Class_Code_Source_Page__c;

            // // Guarantor 1 Data
            // newRec.Guarantor_GTR_1_Name__c                              = oldRec.Guarantor_GTR_1_Name__c;
            // newRec.GTR_1_Name_Source_Page__c                            = oldRec.GTR_1_Name_Source_Page__c;
            // newRec.Guarantor_1_Mailing_Street__c                        = oldRec.Guarantor_1_Mailing_Street__c;
            // newRec.GTR_1_Mailing_Street_Source_Page__c                  = oldRec.GTR_1_Mailing_Street_Source_Page__c;
            // newRec.Guarantor_1_Mailing_City__c                          = oldRec.Guarantor_1_Mailing_City__c;
            // newRec.GTR_1_Mailing_City_Source_Page__c                    = oldRec.GTR_1_Mailing_City_Source_Page__c;
            // newRec.Guarantor_1_Mailing_State__c                         = oldRec.Guarantor_1_Mailing_State__c;
            // newRec.GTR_1_Mailing_State_Source_Page__c                   = oldRec.GTR_1_Mailing_State_Source_Page__c;
            // newRec.Guarantor_1_Mailing_Postal_Code_Zip__c               = oldRec.Guarantor_1_Mailing_Postal_Code_Zip__c;
            // newRec.GTR_1_Postal_Code_Zip_Source_Page__c                 = oldRec.GTR_1_Postal_Code_Zip_Source_Page__c;
            // newRec.Guarantor_1_Mailing_Country__c                       = oldRec.Guarantor_1_Mailing_Country__c;
            // newRec.GTR_1_Mailing_Country_Source_Page__c                 = oldRec.GTR_1_Mailing_Country_Source_Page__c;
            // newRec.Guarantor_1_Phone_Number__c                          = oldRec.Guarantor_1_Phone_Number__c;
            // newRec.GTR_1_Phone_Number_Source_Page__c                    = oldRec.GTR_1_Phone_Number_Source_Page__c;
            // newRec.Guarantor_1_Email__c                                 = oldRec.Guarantor_1_Email__c;
            // newRec.GTR_1_Email_Source_Page__c                           = oldRec.GTR_1_Email_Source_Page__c;
            // newRec.Guarantor_1_Birthdate__c                             = oldRec.Guarantor_1_Birthdate__c;
            // newRec.GTR_1_Birthdate_Source_Page__c                       = oldRec.GTR_1_Birthdate_Source_Page__c;
            // newRec.Guarantor_1_Tax_ID_Number__c                         = oldRec.Guarantor_1_Tax_ID_Number__c;
            // newRec.GTR_1_Tax_ID_Number_Source_Page__c                   = oldRec.GTR_1_Tax_ID_Number_Source_Page__c;
            // newRec.Guarantor_1_Tax_ID_Number_Type__c                    = oldRec.Guarantor_1_Tax_ID_Number_Type__c;
            // newRec.GTR_1_Tax_ID_Number_Type_Source_Page__c              = oldRec.GTR_1_Tax_ID_Number_Type_Source_Page__c;
            // newRec.Guarantor_1_Class_Code__c                            = oldRec.Guarantor_1_Class_Code__c;
            // newRec.GTR_1_Class_Code_Source_Page__c                      = oldRec.GTR_1_Class_Code_Source_Page__c;
            // newRec.Guarantor_1_Contingent__c                            = oldRec.Guarantor_1_Contingent__c;
            // newRec.GTR_1_Contingent_Source_Page__c                      = oldRec.GTR_1_Contingent_Source_Page__c;
            // newRec.Guarantor_1_Gender__c                                = oldRec.Guarantor_1_Gender__c;
            // newRec.GTR_1_Gender_Source_Page__c                          = oldRec.GTR_1_Gender_Source_Page__c;

            // Guarantor 2 Data
            // newRec.Guarantor_GTR_1_Name__c                              = oldRec.Guarantor_GTR_1_Name__c;
            // newRec.GTR_1_Name_Source_Page__c                            = oldRec.GTR_1_Name_Source_Page__c;
            // newRec.Guarantor_1_Mailing_Street__c                        = oldRec.Guarantor_1_Mailing_Street__c;
            // newRec.GTR_1_Mailing_Street_Source_Page__c                  = oldRec.GTR_1_Mailing_Street_Source_Page__c;
            // newRec.Guarantor_1_Mailing_City__c                          = oldRec.Guarantor_1_Mailing_City__c;
            // newRec.GTR_1_Mailing_City_Source_Page__c                    = oldRec.GTR_1_Mailing_City_Source_Page__c;
            // newRec.Guarantor_1_Mailing_State__c                         = oldRec.Guarantor_1_Mailing_State__c;
            // newRec.GTR_1_Mailing_State_Source_Page__c                   = oldRec.GTR_1_Mailing_State_Source_Page__c;
            // newRec.Guarantor_1_Mailing_Postal_Code_Zip__c               = oldRec.Guarantor_1_Mailing_Postal_Code_Zip__c;
            // newRec.GTR_1_Postal_Code_Zip_Source_Page__c                 = oldRec.GTR_1_Postal_Code_Zip_Source_Page__c;
            // newRec.Guarantor_1_Mailing_Country__c                       = oldRec.Guarantor_1_Mailing_Country__c;
            // newRec.GTR_1_Mailing_Country_Source_Page__c                 = oldRec.GTR_1_Mailing_Country_Source_Page__c;
            // newRec.Guarantor_1_Phone_Number__c                          = oldRec.Guarantor_1_Phone_Number__c;
            // newRec.GTR_1_Phone_Number_Source_Page__c                    = oldRec.GTR_1_Phone_Number_Source_Page__c;
            // newRec.Guarantor_1_Email__c                                 = oldRec.Guarantor_1_Email__c;
            // newRec.GTR_1_Email_Source_Page__c                           = oldRec.GTR_1_Email_Source_Page__c;
            // newRec.Guarantor_1_Birthdate__c                             = oldRec.Guarantor_1_Birthdate__c;
            // newRec.GTR_1_Birthdate_Source_Page__c                       = oldRec.GTR_1_Birthdate_Source_Page__c;
            // newRec.Guarantor_1_Tax_ID_Number__c                         = oldRec.Guarantor_1_Tax_ID_Number__c;
            // newRec.GTR_1_Tax_ID_Number_Source_Page__c                   = oldRec.GTR_1_Tax_ID_Number_Source_Page__c;
            // newRec.Guarantor_1_Tax_ID_Number_Type__c                    = oldRec.Guarantor_1_Tax_ID_Number_Type__c;
            // newRec.GTR_1_Tax_ID_Number_Type_Source_Page__c              = oldRec.GTR_1_Tax_ID_Number_Type_Source_Page__c;
            // newRec.Guarantor_1_Class_Code__c                            = oldRec.Guarantor_1_Class_Code__c;
            // newRec.GTR_1_Class_Code_Source_Page__c                      = oldRec.GTR_1_Class_Code_Source_Page__c;
            // newRec.Guarantor_1_Contingent__c                            = oldRec.Guarantor_1_Contingent__c;
            // newRec.GTR_1_Contingent_Source_Page__c                      = oldRec.GTR_1_Contingent_Source_Page__c;
            // newRec.Guarantor_1_Gender__c                                = oldRec.Guarantor_1_Gender__c;
            // newRec.GTR_1_Gender_Source_Page__c                          = oldRec.GTR_1_Gender_Source_Page__c;

            // Guarantor 2 Data
            // newRec.Guarantor_2_Name__c                                  = oldRec.Guarantor_2_Name__c;
            // newRec.GTR_2_Name_Source_Page__c                            = oldRec.GTR_2_Name_Source_Page__c;
            // newRec.Guarantor_2_Mailing_Street__c                        = oldRec.Guarantor_2_Mailing_Street__c;
            // newRec.GTR_2_Mailing_Street_Source_Page__c                  = oldRec.GTR_2_Mailing_Street_Source_Page__c;
            // newRec.Guarantor_2_Mailing_City__c                          = oldRec.Guarantor_2_Mailing_City__c;
            // newRec.GTR_2_Mailing_City_Source_Page__c                    = oldRec.GTR_2_Mailing_City_Source_Page__c;
            // newRec.Guarantor_2_Mailing_State__c                         = oldRec.Guarantor_2_Mailing_State__c;
            // newRec.GTR_2_Mailing_State_Source_Page__c                   = oldRec.GTR_2_Mailing_State_Source_Page__c;
            // newRec.Guarantor_2_Mailing_Postal_Code_Zip__c               = oldRec.Guarantor_2_Mailing_Postal_Code_Zip__c;
            // newRec.GTR_2_Postal_Code_Zip_Source_Page__c                 = oldRec.GTR_2_Postal_Code_Zip_Source_Page__c;
            // newRec.Guarantor_2_Mailing_Country__c                       = oldRec.Guarantor_2_Mailing_Country__c;
            // newRec.GTR_2_Mailing_Country_Source_Page__c                 = oldRec.GTR_2_Mailing_Country_Source_Page__c;
            // newRec.Guarantor_2_Phone_Number__c                          = oldRec.Guarantor_2_Phone_Number__c;
            // newRec.GTR_2_Phone_Number_Source_Page__c                    = oldRec.GTR_2_Phone_Number_Source_Page__c;
            // newRec.Guarantor_2_Email__c                                 = oldRec.Guarantor_2_Email__c;
            // newRec.GTR_2_Email_Source_Page__c                           = oldRec.GTR_2_Email_Source_Page__c;
            // newRec.Guarantor_2_Birthdate__c                             = oldRec.Guarantor_2_Birthdate__c;
            // newRec.GTR_2_Birthdate_Source_Page__c                       = oldRec.GTR_2_Birthdate_Source_Page__c;
            // newRec.Guarantor_2_Tax_ID_Number__c                         = oldRec.Guarantor_2_Tax_ID_Number__c;
            // newRec.GTR_2_Tax_ID_Number_Source_Page__c                   = oldRec.GTR_2_Tax_ID_Number_Source_Page__c;
            // newRec.Guarantor_2_Tax_ID_Number_Type__c                    = oldRec.Guarantor_2_Tax_ID_Number_Type__c;
            // newRec.GTR_2_Tax_ID_Number_Type_Source_Page__c              = oldRec.GTR_2_Tax_ID_Number_Type_Source_Page__c;
            // newRec.Guarantor_2_Class_Code__c                            = oldRec.Guarantor_2_Class_Code__c;
            // newRec.GTR_2_Class_Code_Source_Page__c                      = oldRec.GTR_2_Class_Code_Source_Page__c;
            // newRec.Guarantor_2_Contingent__c                            = oldRec.Guarantor_2_Contingent__c;
            // newRec.GTR_2_Contingent_Source_Page__c                      = oldRec.GTR_2_Contingent_Source_Page__c;
            // newRec.Guarantor_2_Gender__c                                = oldRec.Guarantor_2_Gender__c;
            // newRec.GTR_2_Gender_Source_Page__c                          = oldRec.GTR_2_Gender_Source_Page__c;

            // // Guarantor 3 Data
            // newRec.Guarantor_3_Name__c                      = oldRec.Guarantor_3_Name__c;
            // newRec.GTR_3_Name_Source_Page__c                = oldRec.GTR_3_Name_Source_Page__c;
            // newRec.Guarantor_3_Mailing_Street__c            = oldRec.Guarantor_3_Mailing_Street__c;
            // newRec.GTR_3_Mailing_Street_Source_Page__c      = oldRec.GTR_3_Mailing_Street_Source_Page__c;
            // newRec.Guarantor_3_Mailing_City__c              = oldRec.Guarantor_3_Mailing_City__c;
            // newRec.GTR_3_Mailing_City_Source_Page__c        = oldRec.GTR_3_Mailing_City_Source_Page__c;
            // newRec.Guarantor_3_Mailing_State__c             = oldRec.Guarantor_3_Mailing_State__c;
            // newRec.GTR_3_Mailing_State_Source_Page__c       = oldRec.GTR_3_Mailing_State_Source_Page__c;
            // newRec.Guarantor_3_Mailing_Postal_Code_Zip__c   = oldRec.Guarantor_3_Mailing_Postal_Code_Zip__c;
            // newRec.GTR_3_Postal_Code_Zip_Source_Page__c     = oldRec.GTR_3_Postal_Code_Zip_Source_Page__c;
            // newRec.Guarantor_3_Mailing_Country__c           = oldRec.Guarantor_3_Mailing_Country__c;
            // newRec.GTR_3_Mailing_Country_Source_Page__c     = oldRec.GTR_3_Mailing_Country_Source_Page__c;
            // newRec.Guarantor_3_Phone_Number__c              = oldRec.Guarantor_3_Phone_Number__c;
            // newRec.GTR_3_Phone_Number_Source_Page__c        = oldRec.GTR_3_Phone_Number_Source_Page__c;
            // newRec.Guarantor_3_Email__c                     = oldRec.Guarantor_3_Email__c;
            // newRec.GTR_3_Email_Source_Page__c               = oldRec.GTR_3_Email_Source_Page__c;
            // newRec.Guarantor_3_Birthdate__c                 = oldRec.Guarantor_3_Birthdate__c;
            // newRec.GTR_3_Birthdate_Source_Page__c           = oldRec.GTR_3_Birthdate_Source_Page__c;
            // newRec.Guarantor_3_Tax_ID_Number__c             = oldRec.Guarantor_3_Tax_ID_Number__c;
            // newRec.GTR_3_Tax_ID_Number_Source_Page__c       = oldRec.GTR_3_Tax_ID_Number_Source_Page__c;
            // newRec.Guarantor_3_Tax_ID_Number_Type__c        = oldRec.Guarantor_3_Tax_ID_Number_Type__c;
            // newRec.GTR_3_Tax_ID_Number_Type_Source_Page__c  = oldRec.GTR_3_Tax_ID_Number_Type_Source_Page__c;
            // newRec.Guarantor_3_Class_Code__c                = oldRec.Guarantor_3_Class_Code__c;
            // newRec.GTR_3_Class_Code_Source_Page__c          = oldRec.GTR_3_Class_Code_Source_Page__c;
            // newRec.Guarantor_3_Contingent__c                = oldRec.Guarantor_3_Contingent__c;
            // newRec.GTR_3_Contingent_Source_Page__c          = oldRec.GTR_3_Contingent_Source_Page__c;
            // newRec.Guarantor_3_Gender__c                    = oldRec.Guarantor_3_Gender__c;
            // newRec.GTR_3_Gender_Source_Page__c              = oldRec.GTR_3_Gender_Source_Page__c;

            // // Guarantor 4 Data
            // newRec.Guarantor_4_Name__c                      = oldRec.Guarantor_4_Name__c;
            // newRec.GTR_4_Name_Source_Page__c                = oldRec.GTR_4_Name_Source_Page__c;
            // newRec.Guarantor_4_Mailing_Street__c            = oldRec.Guarantor_4_Mailing_Street__c;
            // newRec.GTR_4_Mailing_Street_Source_Page__c      = oldRec.GTR_4_Mailing_Street_Source_Page__c;
            // newRec.Guarantor_4_Mailing_City__c              = oldRec.Guarantor_4_Mailing_City__c;
            // newRec.GTR_4_Mailing_City_Source_Page__c        = oldRec.GTR_4_Mailing_City_Source_Page__c;
            // newRec.Guarantor_4_Mailing_State__c             = oldRec.Guarantor_4_Mailing_State__c;
            // newRec.GTR_4_Mailing_State_Source_Page__c       = oldRec.GTR_4_Mailing_State_Source_Page__c;
            // newRec.Guarantor_4_Mailing_Postal_Code_Zip__c   = oldRec.Guarantor_4_Mailing_Postal_Code_Zip__c;
            // newRec.GTR_4_Postal_Code_Zip_Source_Page__c     = oldRec.GTR_4_Postal_Code_Zip_Source_Page__c;
            // newRec.Guarantor_4_Mailing_Country__c           = oldRec.Guarantor_4_Mailing_Country__c;
            // newRec.GTR_4_Mailing_Country_Source_Page__c     = oldRec.GTR_4_Mailing_Country_Source_Page__c;
            // newRec.Guarantor_4_Phone_Number__c              = oldRec.Guarantor_4_Phone_Number__c;
            // newRec.GTR_4_Phone_Number_Source_Page__c        = oldRec.GTR_4_Phone_Number_Source_Page__c;
            // newRec.Guarantor_4_Email__c                     = oldRec.Guarantor_4_Email__c;
            // newRec.GTR_4_Email_Source_Page__c               = oldRec.GTR_4_Email_Source_Page__c;
            // newRec.Guarantor_4_Birthdate__c                 = oldRec.Guarantor_4_Birthdate__c;
            // newRec.GTR_4_Birthdate_Source_Page__c           = oldRec.GTR_4_Birthdate_Source_Page__c;
            // newRec.Guarantor_4_Tax_ID_Number__c             = oldRec.Guarantor_4_Tax_ID_Number__c;
            // newRec.GTR_4_Tax_ID_Number_Source_Page__c       = oldRec.GTR_4_Tax_ID_Number_Source_Page__c;
            // newRec.Guarantor_4_Tax_ID_Number_Type__c        = oldRec.Guarantor_4_Tax_ID_Number_Type__c;
            // newRec.GTR_4_Tax_ID_Number_Type_Source_Page__c  = oldRec.GTR_4_Tax_ID_Number_Type_Source_Page__c;
            // newRec.Guarantor_4_Class_Code__c                = oldRec.Guarantor_4_Class_Code__c;
            // newRec.GTR_4_Class_Code_Source_Page__c          = oldRec.GTR_4_Class_Code_Source_Page__c;
            // newRec.Guarantor_4_Contingent__c                = oldRec.Guarantor_4_Contingent__c;
            // newRec.GTR_4_Contingent_Source_Page__c          = oldRec.GTR_4_Contingent_Source_Page__c;
            // newRec.Guarantor_4_Gender__c                    = oldRec.Guarantor_4_Gender__c;
            // newRec.GTR_4_Gender_Source_Page__c              = oldRec.GTR_4_Gender_Source_Page__c;

               // Loan Account Data
            newRec.Loan_Number_Source_Page__c                  = oldRec.Loan_Number_Source_Page__c;
            newRec.DDA_Account_Number_1_Source_Page__c         = oldRec.DDA_Account_Number_1_Source_Page__c;
            newRec.DDA_Account_Number_2_Source_Page__c         = oldRec.DDA_Account_Number_2_Source_Page__c;
            newRec.DDA_Account_Number_3_Source_Page__c         = oldRec.DDA_Account_Number_3_Source_Page__c;
            newRec.Risk_Rating__c                              = oldRec.Risk_Rating__c;
            newRec.Risk_Rating_Source_Page__c                  = oldRec.Risk_Rating_Source_Page__c;
            newRec.Branch_Number__c                            = oldRec.Branch_Number__c;
            newRec.Branch_Number_Source_Page__c                = oldRec.Branch_Number_Source_Page__c;
            newRec.Relationship_Manager__c                     = oldRec.Relationship_Manager__c;
            newRec.Relationship_Manager_Source_Page__c         = oldRec.Relationship_Manager_Source_Page__c;
            newRec.Primary_Analyst__c                          = oldRec.Primary_Analyst__c;
            newRec.Primary_Analyst_Source_Page__c              = oldRec.Primary_Analyst_Source_Page__c;
            newRec.C_I_Loan_Type__c                            = oldRec.C_I_Loan_Type__c;
            newRec.C_I_Loan_Type_Source_Page__c                = oldRec.C_I_Loan_Type_Source_Page__c;
            newRec.Purpose_Code__c                             = oldRec.Purpose_Code__c;
            newRec.Purpose_Code_Source_Page__c                 = oldRec.Purpose_Code_Source_Page__c;
            newRec.Collateral_Code_Description__c              = oldRec.Collateral_Code_Description__c;
            newRec.Coll_Code_Description_Source_Page__c        = oldRec.Coll_Code_Description_Source_Page__c;
            newRec.Call_Report_Code__c                         = oldRec.Call_Report_Code__c;
            newRec.Call_Report_Code_Source_Page__c             = oldRec.Call_Report_Code_Source_Page__c;
            newRec.Loan_Class_Code__c                          = oldRec.Loan_Class_Code__c;
            newRec.Loan_Class_Code_Source_Page__c              = oldRec.Loan_Class_Code_Source_Page__c;
            newRec.NAICS_Code__c                               = oldRec.NAICS_Code__c;
            newRec.NAICS_Code_Source_Page__c                   = oldRec.NAICS_Code_Source_Page__c;
            newRec.Loan_Term_months__c                         = oldRec.Loan_Term_months__c;
            newRec.Loan_Term_months_Source_Page__c             = oldRec.Loan_Term_months_Source_Page__c;
            newRec.Origination_Date_note_date__c               = oldRec.Origination_Date_note_date__c;
            newRec.Origination_Date_Source_Page__c             = oldRec.Origination_Date_Source_Page__c;
            newRec.Maturity_Date__c                            = oldRec.Maturity_Date__c;
            newRec.Maturity_Date_Source_Page__c                = oldRec.Maturity_Date_Source_Page__c;
            newRec.Projected_Initial_Funding_Source_Page__c    = oldRec.Projected_Initial_Funding_Source_Page__c;
            newRec.Date_Entered_Final_Boarding__c              = oldRec.Date_Entered_Final_Boarding__c;
            newRec.Date_Entered_Source_Page__c                 = oldRec.Date_Entered_Source_Page__c;
            newRec.Term_Code__c                                = oldRec.Term_Code__c;
            newRec.Term_Code_Source_Page__c                    = oldRec.Term_Code_Source_Page__c;
            newRec.Funding_Date_Source_Page__c                 = oldRec.Funding_Date_Source_Page__c;
            newRec.Management_Code__c                          = oldRec.Management_Code__c;
            newRec.Management_Code_Source_Page__c              = oldRec.Management_Code_Source_Page__c;
            newRec.CRE_Sub_Property_Type__c                    = oldRec.CRE_Sub_Property_Type__c;
            newRec.CRE_Sub_Property_Type_Source_Page__c        = oldRec.CRE_Sub_Property_Type_Source_Page__c;
            newRec.IBase_SFDC2__c                              = oldRec.IBase_SFDC2__c;

            // Payment Data
            newRec.Payment_Frequency__c                        = oldRec.Payment_Frequency__c;
            newRec.Payment_Frequency_Source_Page__c            = oldRec.Payment_Frequency_Source_Page__c;
            newRec.Payment_Code__c                             = oldRec.Payment_Code__c;
            newRec.Payment_Code_Source_Page__c                 = oldRec.Payment_Code_Source_Page__c;
            newRec.First_Payment_Date__c                       = oldRec.First_Payment_Date__c;
            newRec.First_Payment_Date_Source_Page__c           = oldRec.First_Payment_Date_Source_Page__c;
            newRec.Next_Due_Date__c                            = oldRec.Next_Due_Date__c;
            newRec.Next_Due_Date_Source_Page__c                = oldRec.Next_Due_Date_Source_Page__c;
            newRec.Send_Payment_Billings__c                    = oldRec.Send_Payment_Billings__c;
            newRec.of_Days_Before_Printing_Bills__c            = oldRec.of_Days_Before_Printing_Bills__c;
            newRec.Days_Before_Printing_Source_Page__c         = oldRec.Days_Before_Printing_Source_Page__c;
            newRec.Send_Payment_Billings_Source_Page__c        = oldRec.Send_Payment_Billings_Source_Page__c;

            // Rate Data
            newRec.Rate__c                                     = oldRec.Rate__c;
            newRec.Rate_Source_Page__c                         = oldRec.Rate_Source_Page__c;
            newRec.Rate_Index_Number__c                        = oldRec.Rate_Index_Number__c;
            newRec.Rate_Index_Number_Source_Page__c            = oldRec.Rate_Index_Number_Source_Page__c;
            newRec.Rate_Floor__c                               = oldRec.Rate_Floor__c;
            newRec.Rate_Floor_Source_Page__c                   = oldRec.Rate_Floor_Source_Page__c;
            newRec.Rate_Margin__c                              = oldRec.Rate_Margin__c;
            newRec.Rate_Margin_Source_Page__c                  = oldRec.Rate_Margin_Source_Page__c;
            newRec.Rate_Review_Date__c                         = oldRec.Rate_Review_Date__c;
            newRec.Rate_Review_Date_Source_Page__c             = oldRec.Rate_Review_Date_Source_Page__c;
            newRec.Rate_Review_Term__c                         = oldRec.Rate_Review_Term__c;
            newRec.Rate_Review_Term_Source_Page__c             = oldRec.Rate_Review_Term_Source_Page__c;
            newRec.Rate_Review_Term_Frequency__c               = oldRec.Rate_Review_Term_Frequency__c;
            newRec.Rate_Review_Term_Frequency_Source_Page__c   = oldRec.Rate_Review_Term_Frequency_Source_Page__c;
            newRec.Rate_Review_Day_of_Month__c                 = oldRec.Rate_Review_Day_of_Month__c;
            newRec.Rate_Review_Day_of_Month_Source_Page__c     = oldRec.Rate_Review_Day_of_Month_Source_Page__c;

            // Collateral Data                                      
            newRec.LTV__c                                      = oldRec.LTV__c;
            newRec.LTV_Source_Page__c                          = oldRec.LTV_Source_Page__c;
            newRec.Property_Street__c                          = oldRec.Property_Street__c;
            newRec.Property_Street_Source_Page__c              = oldRec.Property_Street_Source_Page__c;
            newRec.Property_City__c                            = oldRec.Property_City__c;
            newRec.Property_City_Source_Page__c                = oldRec.Property_City_Source_Page__c;
            newRec.Property_State__c                           = oldRec.Property_State__c
            newRec.Property_State_Source_Page__c               = oldRec.Property_State_Source_Page__c;
            newRec.Property_Postal_Code_Zip__c                 = oldRec.Property_Postal_Code_Zip__c;
            newRec.Property_Postal_Code_Zip_Source_Page__c     = oldRec.Property_Postal_Code_Zip_Source_Page__c;
            newRec.Property_Country__c                         = oldRec.Property_Country__c;
            newRec.Property_Country_Source_Page__c             = oldRec.Property_Country_Source_Page__c;
            newRec.Appraised_Value__c                          = oldRec.Appraised_Value__c;
            newRec.Appraised_Value_Source_Page__c              = oldRec.Appraised_Value_Source_Page__c;
            newRec.Appraisal_Review_Date__c                    = oldRec.Appraisal_Review_Date__c;
            newRec.Appraisal_Review_Date_Source_Page__c        = oldRec.Appraisal_Review_Date_Source_Page__c;
            newRec.Year_Built__c                               = oldRec.Year_Built__c;
            newRec.Year_Built_Source_Page__c                   = oldRec.Year_Built_Source_Page__c;
            newRec.Collateral_Insurance_Exp_Date__c            = oldRec.Collateral_Insurance_Exp_Date__c;
            newRec.Coll_Insurance_Exp_Date_Source_Page__c      = oldRec.Coll_Insurance_Exp_Date_Source_Page__c;
            newRec.Flood_Insurance_Required__c                 = oldRec.Flood_Insurance_Required__c;
            newRec.Flood_Insurance_Required_Source_Page__c     = oldRec.Flood_Insurance_Required_Source_Page__c;


            var error = component.get("v.formRecordError");
            if(error || (rec === null)) {
                  console.log("Error initializing record template: " + error);
               return;
            }
         })
      );
   },
   handleSave: function(component, event, helper) {
      var resultToast = $A.get("e.force:showToast");
      component.find("boardingFormRecordCreator").saveRecord(function(saveResult) {
         if(saveResult.state === "SUCCESS") {
            resultToast.setParams({
               "title":"Cloned Form",
               "message":"Form was cloned."
            });
            var oldRec = component.get("v.oldBoardingForm");
            var newRec = component.get("v.newBoardingForm");

            $A.get("e.force:closeQuickAction").fire();
            resultToast.fire();
            $A.get("e.force:refreshView").fire();


            var newFormId = component.get("v.newBoardingForm.Id");
            console.log(newFormId);
            var goToClonedForm = $A.get("e.force:navigateToSObject");
            goToClonedForm.setParams({
               "recordId": newFormId
            });
            goToClonedForm.fire();
         }
         else if(saveResult.state === "INCOMPLETE") {
            console.log("User is offline, device doesn't support drafts.");
         }
         else if(saveResult.state === "ERROR") {
            console.log('Problem saving record, error: ' + JSON.stringify(saveResult.error));
         }
      });
   },
   handleCancel: function(component, event, helper) {
      $A.get("e.force:closeQuickAction").fire();

   },
   handleChangeBFStatus: function(component, event, helper) {
      var changeBFStatus = component.find("BF-Status").get("v.value");
      var updateBFStatus = component.set("v.newBoardingForm.BF_Status__c", changeBFStatus);
   },
   handleChangeOpp: function(component, event, helper) { 
      var changeOpp = component.find("Opportunity").get("v.value");
      var updateOpp = component.set("v.newBoardingForm.Opportunity__c", changeOpp);
   },
   handleChangeRelatedLOQ: function(component, event, helper) {
      var changeRelatedLOQ = component.find("Related-LOQ").get("v.value");
      var updateRelatedLOQ = component.set("v.newBoardingForm.Related_LOQ__c", changeRelatedLOQ);
   },
   // handleChangeBWRName: function(component, event, helper){
   //    var changeBWRLegalName = component.find("BWR-Legal-Name").get("v.value");
   //    var updateBWRLegalName = component.set("v.newBoardingForm.BWR_Legal_Name__c", changeBWRLegalName);
   // },
   // handleChangeBWRNameSP: function(component, event, helper) {
   //    var changeBWRLegalNameSP = component.find("BWR-Legal-Name-SP").get("v.value");
   //    var updateBWRLegalNameSP = component.set("v.newBoardingForm.BWR_Legal_Name_Source_Page__c", changeBWRLegalNameSP);
   // },
   // handleChangeBWRStreet: function(component, event, helper) {
   //    var changeBWRMailingStreet = component.find("BWR-Mailing-Street").get("v.value");
   //    var updateBWRMailingStreet = component.set("v.newBoardingForm.Borrower_Mailing_Address_Street__c", changeBWRMailingStreet);
   // },
   // handleChangeBWRStreetSP: function(component, event, helper) {
   //    var changeBWRMailingStreetSP = component.find("BWR-Mailing-Street-SP").get("v.value");
   //    var updateBWRMailingStreetSP = component.set("v.newBoardingForm.BWR_Mailing_Address_Street_Source_Page__c", changeBWRMailingStreetSP);
   // },
   // handleChangeBWRCity: function(component, event, helper) {
   //    var changeBWRMailingCity = component.find("BWR-Mailing-City").get("v.value");
   //    var updateBWRMailingCity = component.set("v.newBoardingForm.Borrower_Mailing_Address_City__c", changeBWRMailingCity);
   // },
   // handleChangeBWRCitySP: function(component, event, helper) {
   //    var changeBWRMailingCitySP = component.find("BWR-Mailing-City-SP").get("v.value");
   //    var updateBWRMailingCitySP = component.set("v.newBoardingForm.BWR_Mailing_Address_City_Source_Page__c", changeBWRMailingCitySP);
   // },
   // handleChangeBWRState: function(component, event, helper) {
   //    var changeBWRMailingState = component.find("BWR-Mailing-State").get("v.value");
   //    var updateBWRMailingState = component.set("v.newBoardingForm.Borrower_Mailing_Address_State__c", changeBWRMailingState);
   // },
   // handleChangeBWRStateSP: function(component, event, helper) {
   //    var changeBWRMailingStateSP = component.find("BWR-Mailing-State-SP").get("v.value");
   //    var updateBWRMailingStateSP = component.set("v.newBoardingForm.BWR_Mailing_Address_State_Source_Page__c", changeBWRMailingStateSP);
   // },
   // handleChangeBWRPostalCode: function(component, event, helper) {
   //    var changeBWRPostalCode = component.find("BWR-Mailing-Postal-Code").get("v.value");
   //    var updateBWRPostalCode = component.set("v.newBoardingForm.Borrower_Mailing_Address_Postal_Code__c", changeBWRPostalCode);
   // },
   // handleChangeBWRPostalCodeSP: function(component, event, helper) {
   //    var changeBWRPostalCodeSP = component.find("BWR-Mailing-Postal-Code-SP").get("v.value");
   //    var updateBWRPostalCodeSP = component.set("v.newBoardingForm.BWR_Mailing_Postal_Code_Source_Page__c", changeBWRPostalCodeSP);
   // },
   // handleChangeBWRCountry: function(component, event, helper) {
   //    var changeBWRMailingCountry = component.find("BWR-Mailing-Country").get("v.value");
   //    var updateBWRMailingCountry = component.set("v.newBoardingForm.Borrower_Mailing_Address_Country__c", changeBWRMailingCountry);
   // },
   // handleChangeBWRCountrySP: function(component, event, helper) {
   //    var changeBWRMailingCountrySP = component.find("BWR-Mailing-Country-SP").get("v.value");
   //    var updateBWRMailingCountrySP = component.set("v.newBoardingForm.BWR_Mailing_Country_Source_Page__c", changeBWRMailingCountrySP);
   // },
   // handleChangeBWRPhone: function(component, event, helper) {
   //    var changeBWRPhone = component.find("BWR-Phone-Number").get("v.value");
   //    var updateBWRPhone = component.set("v.newBoardingForm.Borrower_Phone_Number__c", changeBWRPhone);
   // },
   // handleChangeBWRPhoneSP: function(component, event, helper) {
   //    var changeBWRPhoneSP = component.find("BWR-Phone-Number-SP").get("v.value");
   //    var updateBWRPhoneSP = component.set("v.newBoardingForm.BWR_Phone_Number_Source_Page__c", changeBWRPhoneSP);
   // },
   // handleChangeBWREmail: function(component, event, helper) {
   //    var changeBWREmailAddress = component.find("BWR-Email-Address").get("v.value");
   //    var updateBWREmailAddress = component.set("v.newBoardingForm.Borrower_Email_Address__c", changeBWREmailAddress);
   // },
   // handleChangeBWREmailSP: function(component, event, helper) {
   //    var changeBWREmailAddressSP = component.find("BWR-Email-Address-SP").get("v.value");
   //    var updateBWREmailAddressSP = component.set("v.newBoardingForm.BWR_Email_Address_Source_Page__c", changeBWREmailAddressSP);
   // },
   // handleChangeBWRTaxNumber: function(component, event, helper) {
   //    var changeBWRTaxIDNumber = component.find("BWR-Tax-ID-Number").get("v.value");
   //    var updateBWRTaxIDNumber = component.set("v.newBoardingForm.Borrower_Tax_ID_Number__c", changeBWRTaxIDNumber);
   // },
   // handleChangeBWRTaxNumberSP: function(component, event,helper) {
   //    var changeBWRTaxIDNumberSP = component.find("BWR-Tax-ID-Number-SP").get("v.value");
   //    var updateBWRTaxIDNumberSP = component.set("v.newBoardingForm.BWR_Tax_ID_Number_Source_Page__c", changeBWRTaxIDNumberSP);
   // },
   // handleChangeBWRTaxNumberType: function(component, event, helper) {
   //    var changeBWRTaxIDNumberType = component.find("BWR-Tax-ID-Number-Type").get("v.value");
   //    var updateBWRTaxIDNumberType = component.set("v.newBoardingForm.Borrower_Tax_ID_Number_Type__c", changeBWRTaxIDNumberType);
   // },
   // handleChangeBWRTaxNumberTypeSP: function(component, event, helper) {
   //    var changeBWRTaxIDNumberTypeSP = component.find("BWR-Tax-ID-Number-Type-SP").get("v.value");
   //    var updateBWRTaxIDNumberTypeSP = component.set("v.newBoardingForm.BWR_Tax_ID_Number_Type_Source_Page__c", changeBWRTaxIDNumberTypeSP);
   // },
   // handleChangeBWRClassCode: function(component, event, helper) {
   //    var changeBWRClassCode = component.find("BWR-Class-Code").get("v.value");
   //    var updateBWRClassCode = component.set("v.newBoardingForm.Borrower_Class_Code__c", changeBWRClassCode);
   // },
   // handleChangeBWRClassCodeSP: function(component, event, helper) {
   //    var changeBWRClassCodeSP = component.find("BWR-Class-Code-SP").get("v.value");
   //    var updateBWRClassCodeSP = component.set("v.newBoardingForm.BWR_Class_Code_Source_Page__c", changeBWRClassCodeSP);
   // },
   //    // Borrower 2
   // handleChangeBWR2Name: function(component, event, helper) {
   //    var changeBWR2LegalName = component.find("BWR-2-Legal-Name").get("v.value");
   //    var updateBWR2RLegalName = component.set("v.newBoardingForm.BWR_2_Legal_Name__c", changeBWR2LegalName);
   // },
   // handleChangeBWR2NameSP: function(component, event, helper) {
   //    var changeBWR2LegalNameSP = component.find("BWR-2-Legal-Name-SP").get("v.value");
   //    var updateBWR2LegalNameSP = component.set("v.newBoardingForm.BWR_2_Legal_Name_Source_Page__c", changeBWR2LegalNameSP);
   // },
   // handleChangeBWR2Street: function(component, event, helper) {
   //    var changeBWR2MailingStreet = component.find("BWR-2-Mailing-Street").get("v.value");
   //    var updateBWR2ailingStreet = component.set("v.newBoardingForm.BWR_2_Mailing_Address_Street__c", changeBWR2MailingStreet);
   // },
   // handleChangeBWR2StreetSP: function(component, event, helper) {
   //    var changeBWR2MailingStreetSP = component.find("BWR-2-Mailing-Street-SP").get("v.value");
   //    var updateBWR2MailingStreetSP = component.set("v.newBoardingForm.BWR_2_Mailing_Street_Source_Page__c", changeBWR2MailingStreetSP);
   // },
   // handleChangeBWR2City: function(component, event, helper) {
   //    var changeBWR2MailingCity = component.find("BWR-2-Mailing-City").get("v.value");
   //    var updateBWR2MailingCity = component.set("v.newBoardingForm.BWR_2_Mailing_Address_City__c", changeBWR2MailingCity);
   // },
   // handleChangeBWR2CitySP: function(component, event, helper) {
   //    var changeBWR2MailingCitySP = component.find("BWR-2-Mailing-City-SP").get("v.value");
   //    var updateBWR2MailingCitySP = component.set("v.newBoardingForm.BWR_2_Mailing_Address_City_Source_Page__c", changeBWR2MailingCitySP);
   // },
   // handleChangeBWR2State: function(component, event, helper) {    
   //    var changeBWR2MailingState = component.find("BWR-2-Mailing-State").get("v.value");
   //    var updateBWR2ailingState = component.set("v.newBoardingForm.BWR_2_Mailing_Address_State__c", changeBWR2MailingState);
   // },
   // handleChangeBWR2StateSP: function(component, event, helper) {
   //    var changeBWR2MailingStateSP = component.find("BWR-2-Mailing-State-SP").get("v.value");
   //    var updateBWR2MailingStateSP = component.set("v.newBoardingForm.BWR_2_Mailing_State_Source_Page__c", changeBWR2MailingStateSP);
   // },
   // handleChangeBWR2PostalCode: function(component, event, helper) {
   //    var changeBWR2PostalCode = component.find("BWR-2-Mailing-Postal-Code").get("v.value");
   //    var updateBWR2PostalCode = component.set("v.newBoardingForm.BWR_2_Mailing_Address_Postal_Code__c", changeBWR2PostalCode);
   // },
   // handleChangeBWR2PostalCodeSP: function(component, event, helper) {
   //    var changeBWR2PostalCodeSP = component.find("BWR-2-Mailing-Postal-Code-SP").get("v.value");
   //    var updateBWR2PostalCodeSP = component.set("v.newBoardingForm.BWR_2_Mailing_Postal_Code_Source_Page__c", changeBWR2PostalCodeSP);
   // },
   // handleChangeBWR2Country: function(component, event, helper) {
   //    var changeBWR2MailingCountry = component.find("BWR-2-Mailing-Country").get("v.value");
   //    var updateBWR2MailingCountry = component.set("v.newBoardingForm.BWR_2_Mailing_Address_Country__c", changeBWR2MailingCountry);
   // },
   // handleChangeBWR2CountrySP: function(component, event, helper) {
   //    var changeBWR2MailingCountrySP = component.find("BWR-2-Mailing-Country-SP").get("v.value");
   //    var updateBWR2MailingCountrySP = component.set("v.newBoardingForm.BWR_2_Mailing_Country_Source_Page__c", changeBWR2MailingCountrySP);
   // },
   // handleChangeBWR2Phone: function(component, event, helper) {
   //    var changeBWR2Phone = component.find("BWR-2-Phone-Number").get("v.value");
   //    var updateBWR2Phone = component.set("v.newBoardingForm.BWR_2_Phone_Number__c", changeBWR2Phone);
   // },
   // handleChangeBWR2PhoneSP: function(component, event, helper) {
   //    var changeBWR2PhoneSP = component.find("BWR-2-Phone-Number-SP").get("v.value");
   //    var updateBWR2PhoneSP = component.set("v.newBoardingForm.BWR_2_Phone_Number_Source_Page__c", changeBWR2PhoneSP);
   // },
   // handleChangeBWR2Email: function(component, event, helper) {
   //    var changeBWR2EmailAddress = component.find("BWR-2-Email-Address").get("v.value");
   //    var updateBWR2EmailAddress = component.set("v.newBoardingForm.BWR_2_Email_Address__c", changeBWR2EmailAddress);
   // },
   // handleChangeBWR2EmailSP: function(component, event, helper) {
   //    var changeBWR2EmailAddressSP = component.find("BWR-2-Email-Address-SP").get("v.value");
   //    var updateBWR2EmailAddressSP = component.set("v.newBoardingForm.BWR_2_Email_Address_Source_Page__c", changeBWR2LegalNameSP);
   // },
   // handleChangeBWR2TaxNumber: function(component, event, helper) {
   //    var changeBWR2TaxIDNumber = component.find("BWR-2-Tax-ID-Number").get("v.value");
   //    var updateBWR2TaxIDNumber = component.set("v.newBoardingForm.BWR_2_Tax_ID_Number__c", changeBWR2TaxIDNumber);
   // },
   // handleChangeBWR2TaxNumberSP: function(component, event, helper) {
   //    var changeBWR2TaxIDNumberSP = component.find("BWR-2-Tax-ID-Number-SP").get("v.value");
   //    var updateBWR2TaxIDNumberSP = component.set("v.newBoardingForm.BWR_2_Tax_ID_Number_Source_Page__c", changeBWR2TaxIDNumberSP);
   // },
   // handleChangeBWR2TaxNumberType: function(component, event, helper) {
   //    var changeBWR2TaxIDNumberType = component.find("BWR-2-Tax-ID-Number-Type").get("v.value");
   //    var updateBWR2TaxIDNumberType = component.set("v.newBoardingForm.BWR_2_Tax_ID_Number_Type__c", changeBWR2TaxIDNumberType);
   // },
   // handleChangeBWR2TaxNumberTypeSP: function(component, event, helper) {
   //    var changeBWR2TaxIDNumberTypeSP = component.find("BWR-2-Tax-ID-Number-Type-SP").get("v.value");
   //    var updateBWR2TaxIDNumberTypeSP = component.set("v.newBoardingForm.BWR_2_Tax_ID_Number_Type_Source_Page__c", changeBWR2TaxIDNumberTypeSP);
   // },
   // handleChangeBWR2ClassCode: function(component, event, helper) {
   //    var changeBWR2ClassCode = component.find("BWR-2-Class-Code").get("v.value");
   //    var updateBWR2ClassCode = component.set("v.newBoardingForm.BWR_2_Class_Code__c", changeBWR2ClassCode);
   // },
   // handleChangeBWR2ClassCodeSP: function(component, event, helper) {
   //    var changeBWR2ClassCodeSP = component.find("BWR-2-Class-Code-SP").get("v.value");
   //    var updateBWR2ClassCodeSP = component.set("v.newBoardingForm.BWR_2_Class_Code_Source_Page__c", changeBWR2ClassCodeSP);
   // },
   //    // // // Guarantor 1
   // handleChangeGTRName: function(component, event, helper) {
   //    var changeGTRName = component.find("GTR-1-Name").get("v.value");
   //    var updateGTRName = component.set("v.newBoardingForm.Guarantor_GTR_1_Name__c", changeGTRName);
   // },
   // handleChangeGTRNameSP: function(component, event, helper) {
   //    var changeGTRNameSP = component.find("GTR-1-Name-SP").get("v.value");
   //    var updateGTRNameSP = component.set("v.newBoardingForm.GTR_1_Name_Source_Page__c", changeGTRNameSP);
   // },
   // handleChangeGTRStreet: function(component, event, helper) {
   //    var changeGTRStreet  = component.find("GTR-1-Mailing-Street").get("v.value");
   //    var updateGTRStreet  = component.set("v.newBoardingForm.Guarantor_1_Mailing_Street__c", changeGTRStreet);
   // },
   // handleChangeGTRStreetSP: function(component, event, helper) {
   //    var changeGTRStreetSP = component.find("GTR-1-Mailing-Street-SP").get("v.value");
   //    var updateGTRStreetSP = component.set("v.newBoardingForm.GTR_1_Mailing_Street_Source_Page__c", changeGTRStreetSP);
   // },
   // handleChangeGTRCity: function(component, event, helper) {
   //    var changeGTRCity = component.find("GTR-1-Mailing-City").get("v.value");
   //    var updateGTRCity = component.set("v.newBoardingForm.Guarantor_1_Mailing_City__c", changeGTRCity);
   // },
   // handleChangeGTRCitySP: function(component, event, helper) {
   //    var changeGTRCitySP = component.find("GTR-1-Mailing-City-SP").get("v.value");
   //    var updateGTRCitySP = component.set("v.newBoardingForm.GTR_1_Mailing_City_Source_Page__c", changeGTRCitySP);
   // },
   // handleChangeGTRState: function(component, event, helper) {
   //    var changeGTRState = component.find("GTR-1-Mailing-State").get("v.value");
   //    var updateGTRState   = component.set("v.newBoardingForm.Guarantor_1_Mailing_State__c", changeGTRState);
   // },
   // handleChangeGTRStateSP: function(component, event, helper) {
   //    var changeGTRStateSP = component.find("GTR-1-Mailing-State-SP").get("v.value");
   //    var updateGTRStateSP = component.set("v.newBoardingForm.GTR_1_Mailing_State_Source_Page__c", changeGTRStateSP);
   // },
   // handleChangeGTRPostalCode: function(component, event, helper) {
   //    var changeGTRPostalCode = component.find("GTR-1-Mailing-Postal-Code").get("v.value");
   //    var updateGTRPostalCode = component.set("v.newBoardingForm.Guarantor_1_Mailing_Postal_Code_Zip__c", changeGTRPostalCode);
   // },
   // handleChangeGTRPostalCodeSP: function(component, event, helper) {
   //    var changeGTRPostalCodeSP = component.find("GTR-1-Mailing-Postal-Code-SP").get("v.value");
   //    var updateGTRPostalCodeSP = component.set("v.newBoardingForm.GTR_1_Postal_Code_Zip_Source_Page__c", changeGTRPostalCodeSP);
   // },
   // handleChangeGTRCountry: function(component, event, helper) {
   //    var changeGTRCountry = component.find("GTR-1-Mailing-Country").get("v.value");
   //    var updateGTRCountry = component.set("v.newBoardingForm.Guarantor_1_Mailing_Country__c", changeGTRCountry);
   // },
   // handleChangeGTRCountrySP: function(component, event, helper) {
   //    var changeGTRCountrySP = component.find("GTR-1-Mailing-Country-SP").get("v.value");
   //    var updateGTRCountrySP = component.set("v.newBoardingForm.Guarantor_1_Mailing_Country_Source_Page__c", changeGTRCountrySP);
   // },
   // handleChangeGTRPhone: function(component, event, helper) {
   //    var changeGTRPhone = component.find("GTR-1-Phone-Number").get("v.value");
   //    var updateGTRPhone = component.set("v.newBoardingForm.Guarantor_1_Phone_Number__c", changeGTRPhone);
   // },
   // handleChangeGTRPhoneSP: function(component, event, helper) {
   //    var changeGTRPhoneSP = component.find("GTR-1-Phone-Number-SP").get("v.value");
   //    var updateGTRPhoneSP = component.set("v.newBoardingForm.GTR_1_Phone_Number_Source_Page__c", changeGTRPhoneSP);
   // },
   // handleChangeGTREmail: function(component, event, helper) {
   //    var changeGTREmail = component.find("GTR-1-Email").get("v.value");
   //    var updateGTREmail = component.set("v.newBoardingForm.Guarantor_1_Email__c", changeGTREmail); 
   // },
   // handleChangeGTREmailSP: function(component, event, helper) {
   //    var changeGTREmailSP = component.find("GTR-1-Email-SP").get("v.value");
   //    var updateGTREmailSP = component.set("v.newBoardingForm.GTR_1_Email_Source_Page__c", changeGTREmailSP);
   // },
   // handleChangeGTRBirthdate: function(component, event, helper) {
   //    var changeGTRBirthdate = component.find("GTR-1-Birthdate").get("v.value");
   //    var updateGTRBirthdate = component.set("v.newBoardingForm.Guarantor_1_Birthdate__c", changeGTRBirthdate);
   // },
   // handleChangeGTRBirthdateSP: function(component, event, helper) {
   //    var changeGTRBirthdateSP = component.find("GTR-1-Birthdate-SP").get("v.value");
   //    var updateGTRBirthdateSP = component.set("v.newBoardingForm.GTR_1_Birthdate_Source_Page__c", changeGTRBirthdateSP);
   // },
   // handleChangeGTRTaxNumber: function(component, event, helper) {
   //    var changeGTRTaxNumber = component.find("GTR-1-Tax-ID-Number").get("v.value");
   //    var updateGTRTaxNumber = component.set("v.newBoardingForm.Guarantor_1_Tax_ID_Number__c", changeGTRTaxNumber);
   // },
   // handleChangeGTRTaxNumberSP: function(component, event, helper) {
   //    var changeGTRTaxNumberSP = component.find("GTR-1-Tax-ID-Number-SP").get("v.value");
   //    var updateGTRTaxNumberSP = component.set("v.newBoardingForm.GTR_1_Tax_ID_Number_Source_Page__c", changeGTRTaxNumberSP);
   // },
   // handleChangeGTRTaxNumberType: function(component, event, helper) {
   //    var changeGTRTaxNumberType = component.find("GTR-1-Tax-ID-Number-Type").get("v.value");
   //    var updateGTRTaxNumberType = component.set("v.newBoardingForm.Guarantor_1_Tax_ID_Number_Type__c", changeGTRTaxNumberType);
   // },
   // handleChangeGTRTaxNumberTypeSP: function(component, event, helper) {
   //    var changeGTRTaxNumberTypeSP = component.find("GTR-1-Tax-ID-Number-Type-SP").get("v.value");
   //    var updateGTRTaxNumberTypeSP = component.set("v.newBoardingForm.GTR_1_Tax_ID_Number_Type_Source_Page__c", changeGTRTaxNumberTypeSP);
   // },
   // handleChangeGTRClassCode: function(component, event, helper) {
   //    var changeGTRClassCode = component.find("GTR-1-Class-Code").get("v.value");
   //    var updateGTRClassCode = component.set("v.newBoardingForm.Guarantor_1_Class_Code__c", changeGTRClassCode);
   // },
   // handleChangeGTRClassCodeSP: function(component, event, helper) {
   //    var changeGTRClassCodeSP = component.find("GTR-1-Class-Code-SP").get("v.value");
   //    var updateGTRClassCodeSP = component.set("v.newBoardingForm.GTR_1_Class_Code_Source_Page__c", changeGTRClassCodeSP);
   // },
   // handleChangeGTRContingent: function(component, event, helper) {
   //    var changeGTRContingent = component.find("GTR-1-Contingent").get("v.value");
   //    var updateGTRContingent = component.set("v.newBoardingForm.Guarantor_1_Contingent__c", changeGTRContingent);
   // },
   // handleChangeGTRContingentSP: function(component, event, helper) {
   //    var changeGTRContingentSP = component.find("GTR-1-Contingent-SP").get("v.value");
   //    var updateGTRContingentSP = component.set("v.newBoardingForm.GTR_1_Contingent_Source_Page__c", changeGTRContingentSP);
   // },
   // handleChangeGTRGender: function(component, event, helper) {
   //    var changeGTRGender = component.find("GTR-1-Gender").get("v.value");
   //    var updateGTRGender = component.set("v.newBoardingForm.Guarantor_1_Gender__c", changeGTRGender);
   // },
   // handleChangeGTRGenderSP: function(component, event, helper) {
   //    var changeGTRGenderSP = component.find("GTR-1-Gender-SP").get("v.value");
   //    var updateGTRGenderSP = component.set("v.newBoardingForm.GTR_1_Gender_Source_Page__c", changeGTRGenderSP);
   // },
   //    // // Guarantor 2
   // handleChangeGTR2Name: function(component, event, helper) {
   //    var changeGTRName = component.find("GTR-2-Name").get("v.value");
   //    var updateGTRName = component.set("v.newBoardingForm.Guarantor_2_Name__c", changeGTRName);
   // },
   // handleChangeGTR2NameSP: function(component, event, helper) {
   //    var changeGTRNameSP = component.find("GTR-2-Name-SP").get("v.value");
   //    var updateGTRNameSP = component.set("v.newBoardingForm.GTR_2_Name_Source_Page__c", changeGTRNameSP);
   // },
   // handleChangeGTR2Street: function(component, event, helper) {
   //    var changeGTRStreet  = component.find("GTR-2-Mailing-Street").get("v.value");
   //    var updateGTRStreet  = component.set("v.newBoardingForm.Guarantor_2_Mailing_Street__c", changeGTRStreet);
   // },
   // handleChangeGTR2StreetSP: function(component, event, helper) {
   //    var changeGTRStreetSP = component.find("GTR-2-Mailing-Street-SP").get("v.value");
   //    var updateGTRStreetSP = component.set("v.newBoardingForm.GTR_2_Mailing_Street_Source_Page__c", changeGTRStreetSP);
   // },
   // handleChangeGTR2City: function(component, event, helper) {
   //    var changeGTRCity = component.find("GTR-2-Mailing-City").get("v.value");
   //    var updateGTRCity = component.set("v.newBoardingForm.Guarantor_2_Mailing_City__c", changeGTRCity);
   // },
   // handleChangeGTR2CitySP: function(component, event, helper) {
   //    var changeGTRCitySP = component.find("GTR-2-Mailing-City-SP").get("v.value");
   //    var updateGTRCitySP = component.set("v.newBoardingForm.GTR_2_Mailing_City_Source_Page__c", changeGTRCitySP);
   // },
   // handleChangeGTR2State: function(component, event, helper) {
   //    var changeGTRState = component.find("GTR-2-Mailing-State").get("v.value");
   //    var updateGTRState   = component.set("v.newBoardingForm.Guarantor_2_Mailing_State__c", changeGTRState);
   // },
   // handleChangeGTR2StateSP: function(component, event, helper) {
   //    changeGTRStateSP = component.find("GTR-2-Mailing-State-SP").get("v.value");
   //    var updateGTRStateSP = component.set("v.newBoardingForm.GTR_2_Mailing_State_Source_Page__c", changeGTRStateSP);
   // },
   // handleChangeGTR2PostalCode: function(component, event, helper) {
   //    var changeGTRPostalCode = component.find("GTR-2-Mailing-Postal-Code").get("v.value");
   //    var updateGTRPostalCode = component.set("v.newBoardingForm.Guarantor_2_Mailing_Postal_Code_Zip__c", changeGTRPostalCode);
   // },
   // handleChangeGTR2PostalCodeSP: function(component, event, helper) {
   //    var changeGTRPostalCodeSP = component.find("GTR-2-Mailing-Postal-Code-SP").get("v.value");
   //    var updateGTRPostalCodeSP = component.set("v.newBoardingForm.GTR_2_Postal_Code_Zip_Source_Page__c", changeGTRPostalCodeSP);
   // },
   // handleChangeGTR2Country: function(component, event, helper) {
   //    var changeGTRCountry = component.find("GTR-2-Mailing-Country").get("v.value");
   //    var updateGTRCountry = component.set("v.newBoardingForm.Guarantor_2_Mailing_Country__c", changeGTRCountry);
   // },
   // handleChangeGTR2CountrySP: function(component, event, helper) {
   //    var changeGTRCountry = component.find("GTR-2-Mailing-Country-SP").get("v.value");
   //    var updateGTRCountry = component.set("v.newBoardingForm.Guarantor_2_Mailing_Country_Source_Page__c", changeGTRCountry);
   // },
   // handleChangeGTR2Phone: function(component, event, helper) {
   //    var changeGTRPhone = component.find("GTR-2-Phone-Number").get("v.value");
   //    var updateGTRPhone = component.set("v.newBoardingForm.Guarantor_2_Phone_Number__c", changeGTRPhone);
   // },
   // handleChangeGTR2Phone: function(component, event, helper){
   //    var changeGTRPhoneSP = component.find("GTR-2-Phone-Number-SP").get("v.value");
   //    var updateGTRPhoneSP = component.set("v.newBoardingForm.GTR_2_Phone_Number_Source_Page__c", changeGTRPhoneSP);
   // },
   // handleChangeGTR2Email: function(component, event, helper) {
   //    var changeGTREmail = component.find("GTR-2-Email").get("v.value");
   //    var updateGTREmail = component.set("v.newBoardingForm.Guarantor_2_Email__c", changeGTREmail); 
   // },
   // handleChangeGTR2EmailSP: function(component, event, helper) {
   //    var changeGTREmailSP = component.find("GTR-2-Email-SP").get("v.value");
   //    var updateGTREmailSP = component.set("v.newBoardingForm.GTR_2_Email_Source_Page__c", changeGTREmailSP);
   // },
   // handleChangeGTR2Birthdate: function(component, event, helper) {
   //    var changeGTRBirthdate = component.find("GTR-2-Birthdate").get("v.value");
   //    var updateGTRBirthdate = component.set("v.newBoardingForm.Guarantor_2_Birthdate__c", changeGTRBirthdate);
   // },
   // handleChangeGTR2BirthdateSP: function(component, event, helper) {
   //    var changeGTRBirthdateSP = component.find("GTR-2-Birthdate-SP").get("v.value");
   //    var updateGTRBirthdateSP = component.set("v.newBoardingForm.GTR_2_Birthdate_Source_Page__c", changeGTRBirthdateSP);
   // },
   // handleChangeGTR2TaxNumber: function(component, event, helper) {
   //    var changeGTRTaxNumber = component.find("GTR-2-Tax-ID-Number").get("v.value");
   //    var updateGTRTaxNumber = component.set("v.newBoardingForm.Guarantor_2_Tax_ID_Number__c", changeGTRTaxNumber);
   // },
   // handleChangeGTR2TaxNumberSP: function(component, event, helper) {
   //    var changeGTRTaxNumberSP = component.find("GTR-2-Tax-ID-Number-SP").get("v.value");
   //    var updateGTRTaxNumberSP = component.set("v.newBoardingForm.GTR_2_Tax_ID_Number_Source_Page__c", changeGTRTaxNumberSP);
   // },
   // handleChangeGTR2TaxNumberType: function(component, event, helper) {
   //    var changeGTRTaxNumberType = component.find("GTR-2-Tax-ID-Number-Type").get("v.value");
   //    var updateGTRTaxNumberType = component.set("v.newBoardingForm.Guarantor_2_Tax_ID_Number_Type__c", changeGTRTaxNumberType);
   // },
   // handleChangeGTR2TaxNumberTypeSP: function(component, event, helper) {
   //    var changeGTRTaxNumberTypeSP = component.find("GTR-2-Tax-ID-Number-Type-SP").get("v.value");
   //    var updateGTRTaxNumberTypeSP = component.set("v.newBoardingForm.GTR_2_Tax_ID_Number_Type_Source_Page__c", changeGTRTaxNumberTypeSP);
   // },
   // handleChangeGTR2ClassCode: function(component, event, helper) {
   //    var changeGTRClassCode = component.find("GTR-2-Class-Code").get("v.value");
   //    var updateGTRClassCode = component.set("v.newBoardingForm.Guarantor_2_Class_Code__c", changeGTRClassCode);
   // },
   // handleChangeGTR2ClassCodeSP: function(component, event, helper) {
   //    var changeGTRClassCodeSP = component.find("GTR-2-Class-Code-SP").get("v.value");
   //    var updateGTRClassCodeSP = component.set("v.newBoardingForm.GTR_2_Class_Code_Source_Page__c", changeGTRClassCodeSP);
   // },
   // handleChangeGTR2Contingent: function(component, event, helper) {
   //    var changeGTRContingent = component.find("GTR-2-Contingent").get("v.value");
   //    var updateGTRContingent = component.set("v.newBoardingForm.Guarantor_2_Contingent__c", changeGTRContingent);
   // },
   // handleChangeGTR2ContingentSP: function(component, event, helper) {
   //    var changeGTRContingentSP = component.find("GTR-2-Contingent-SP").get("v.value");
   //    var updateGTRContingentSP = component.set("v.newBoardingForm.GTR_2_Contingent_Source_Page__c", changeGTRContingentSP);
   // },
   // handleChangeGTR2Gender: function(component, event, helper) {
   //    var changeGTRGender = component.find("GTR-2-Gender").get("v.value");
   //    var updateGTRGender = component.set("v.newBoardingForm.Guarantor_2_Gender__c", changeGTRGender);
   // },
   // handleChangeGTR2GenderSP: function(component, event, helper) {
   //    var changeGTRGenderSP = component.find("GTR-2-Gender-SP").get("v.value");
   //    var updateGTRGenderSP = component.set("v.newBoardingForm.GTR_2_Gender_Source_Page__c", changeGTRGenderSP);
   // },
   //    // // Guarantor 3
   // handleChangeGTR3Name: function(component, event, helper) {
   //    var changeGTRName = component.find("GTR-3-Name").get("v.value");
   //    var updateGTRName = component.set("v.newBoardingForm.Guarantor_3_Name__c", changeGTRName);
   // },
   // handleChangeGTR3NameSP: function(component, event, helper) {
   //    var changeGTRNameSP = component.find("GTR-3-Name-SP").get("v.value");
   //    var updateGTRNameSP = component.set("v.newBoardingForm.GTR_3_Name_Source_Page__c", changeGTRNameSP);
   // },
   // handleChangeGTR3StreetSP: function(component, event, helper) {
   //    var changeGTRStreet  = component.find("GTR-3-Mailing-Street").get("v.value");
   //    var updateGTRStreet  = component.set("v.newBoardingForm.Guarantor_3_Mailing_Street__c", changeGTRStreet);
   // },
   // handleChangeGTR3StreetSP: function(component, event, helper) {
   //    var changeGTRStreetSP = component.find("GTR-3-Mailing-Street-SP").get("v.value");
   //    var updateGTRStreetSP = component.set("v.newBoardingForm.GTR_3_Mailing_Street_Source_Page__c", changeGTRStreetSP);
   // },
   // handleChangeGTR3City: function(component, event, helper) {
   //    var changeGTRCity = component.find("GTR-3-Mailing-City").get("v.value");
   //    var updateGTRCity = component.set("v.newBoardingForm.Guarantor_3_Mailing_City__c", changeGTRCity);
   // },
   // handleChangeGTRCitySP: function(component, event, helper) {
   //    var changeGTRCitySP = component.find("GTR-3-Mailing-City-SP").get("v.value");
   //    var updateGTRCitySP = component.set("v.newBoardingForm.GTR_3_Mailing_City_Source_Page__c", changeGTRCitySP);
   // },
   // handleChangeGTR3State: function(component, event, helper) {
   //    var changeGTRState = component.find("GTR-3-Mailing-State").get("v.value");
   //    var updateGTRState   = component.set("v.newBoardingForm.Guarantor_3_Mailing_State__c", changeGTRState);
   // },
   // handleChangeGTR3StateSP: function(component, event, helper) {
   //    var changeGTRStateSP = component.find("GTR-3-Mailing-State-SP").get("v.value");
   //    var updateGTRStateSP = component.set("v.newBoardingForm.GTR_3_Mailing_State_Source_Page__c", changeGTRStateSP);
   // },
   // handleChangeGTR3PostalCode: function(component, event, helper) {
   //    var changeGTRPostalCode = component.find("GTR-3-Mailing-Postal-Code").get("v.value");
   //    var updateGTRPostalCode = component.set("v.newBoardingForm.Guarantor_3_Mailing_Postal_Code_Zip__c", changeGTRPostalCode);
   // },
   // handleChangeGTR3PostalCodeSP: function(component, event, helper) {
   //    var changeGTRPostalCodeSP = component.find("GTR-3-Mailing-Postal-Code-SP").get("v.value");
   //    var updateGTRPostalCodeSP = component.set("v.newBoardingForm.GTR_3_Postal_Code_Zip_Source_Page__c", changeGTRPostalCodeSP);
   // },
   // handleChangeGTR3Country: function(component, event, helper) {
   //    var changeGTRCountry = component.find("GTR-3-Mailing-Country").get("v.value");
   //    var updateGTRCountry = component.set("v.newBoardingForm.Guarantor_3_Mailing_Country__c", changeGTRCountry);
   // },
   // handleChangeGTR3CountrySP: function(component, event, helper) {
   //    var changeGTRCountry = component.find("GTR-3-Mailing-Country-SP").get("v.value");
   //    var updateGTRCountry = component.set("v.newBoardingForm.Guarantor_3_Mailing_Country_Source_Page__c", changeGTRCountry);
   // },
   // handleChangeGTR3Phone: function(component, event, helper) {
   //    var changeGTRPhone = component.find("GTR-3-Phone-Number").get("v.value");
   //    var updateGTRPhone = component.set("v.newBoardingForm.Guarantor_3_Phone_Number__c", changeGTRPhone);
   // },
   // handleChangeGTR3PhoneSP: function(component, event, helper) {
   //    var changeGTRPhoneSP = component.find("GTR-3-Phone-Number-SP").get("v.value");
   //    var updateGTRPhoneSP = component.set("v.newBoardingForm.GTR_3_Phone_Number_Source_Page__c", changeGTRPhoneSP);
   // },
   // handleChangeGTR3Email: function(component, event, helper) {
   //    var changeGTREmail = component.find("GTR-3-Email").get("v.value");
   //    var updateGTREmail = component.set("v.newBoardingForm.Guarantor_3_Email__c", changeGTREmail); 
   // },
   // handleChangeGTR3EmailSP: function(component, event, helper) {
   //    var changeGTREmailSP = component.find("GTR-3-Email-SP").get("v.value");
   //    var updateGTREmailSP = component.set("v.newBoardingForm.GTR_3_Email_Source_Page__c", changeGTREmailSP);
   // },
   // handleChangeGT3RBirthdate: function(component, event, helper) {
   //    var changeGTRBirthdate = component.find("GTR-3-Birthdate").get("v.value");
   //    var updateGTRBirthdate = component.set("v.newBoardingForm.Guarantor_3_Birthdate__c", changeGTRBirthdate);
   // },
   // handleChangeGTR3BirthdateSP: function(component, event, helper) {
   //    var changeGTRBirthdateSP = component.find("GTR-3-Birthdate-SP").get("v.value");
   //    var updateGTRBirthdateSP = component.set("v.newBoardingForm.GTR_3_Birthdate_Source_Page__c", changeGTRBirthdateSP);
   // },
   // handleChangeGTR3TaxNumber: function(component, event, helper) {
   //    var changeGTRTaxNumber = component.find("GTR-3-Tax-ID-Number").get("v.value");
   //    var updateGTRTaxNumber = component.set("v.newBoardingForm.Guarantor_3_Tax_ID_Number__c", changeGTRTaxNumber);
   // },
   // handleChangeGTR3TaxNumberSP: function(component, event, helper) {
   //    var changeGTRTaxNumberSP = component.find("GTR-3-Tax-ID-Number-SP").get("v.value");
   //    var updateGTRTaxNumberSP = component.set("v.newBoardingForm.GTR_3_Tax_ID_Number_Source_Page__c", changeGTRTaxNumberSP);
   // },
   // handleChangeGTR3TaxNumberType: function(component, event, helper) {
   //    var changeGTRTaxNumberType = component.find("GTR-3-Tax-ID-Number-Type").get("v.value");
   //    var updateGTRTaxNumberType = component.set("v.newBoardingForm.Guarantor_3_Tax_ID_Number_Type__c", changeGTRTaxNumberType);
   // },
   // handleChangeGTR3TaxNumberTypeSP: function(component, event, helper) {
   //    var changeGTRTaxNumberTypeSP = component.find("GTR-3-Tax-ID-Number-Type-SP").get("v.value");
   //    var updateGTRTaxNumberTypeSP = component.set("v.newBoardingForm.GTR_3_Tax_ID_Number_Type_Source_Page__c", changeGTRTaxNumberTypeSP);
   // },
   // handleChangeGTR3ClassCode: function(component, event, helper) {
   //    var changeGTRClassCode = component.find("GTR-3-Class-Code").get("v.value");
   //    var updateGTRClassCode = component.set("v.newBoardingForm.Guarantor_3_Class_Code__c", changeGTRClassCode);
   // },
   // handleChangeGTR3ClassCodeSP: function(component, event, helper) {
   //    var changeGTRClassCodeSP = component.find("GTR-3-Class-Code-SP").get("v.value");
   //    var updateGTRClassCodeSP = component.set("v.newBoardingForm.GTR_3_Class_Code_Source_Page__c", changeGTRClassCodeSP);
   // },
   // handleChangeGTR3Contingent: function(component, event, helper) {
   //    var changeGTRContingent = component.find("GTR-3-Contingent").get("v.value");
   //    var updateGTRContingent = component.set("v.newBoardingForm.Guarantor_1_Contingent__c", changeGTRContingent);
   // },
   // handleChangeGTR3ContingentSP: function(component, event, helper) {
   //    var changeGTRContingentSP = component.find("GTR-33-Contingent-SP").get("v.value");
   //    var updateGTRContingentSP = component.set("v.newBoardingForm.GTR_3_Contingent_Source_Page__c", changeGTRContingentSP);
   // },
   // handleChangeGTR3Gender: function(component, event, helper) {
   //    var changeGTRGender = component.find("GTR-33-Gender").get("v.value");
   //    var updateGTRGender = component.set("v.newBoardingForm.Guarantor_3_Gender__c", changeGTRGender);
   // },
   // handleChangeGTR3GenderSP: function(component, event, helper) {
   //    var changeGTRGenderSP = component.find("GTR-33-Gender-SP").get("v.value");
   //    var updateGTRGenderSP = component.set("v.newBoardingForm.GTR_3_Gender_Source_Page__c", changeGTRGenderSP);
   // },
   //    // Guarantor 4
   // handleChangeGTR4Name: function(component, event, helper) {
   //    var changeGTRName = component.find("GTR-4-Name").get("v.value");
   //    var updateGTRName = component.set("v.newBoardingForm.Guarantor_4_Name__c", changeGTRName);
   // },
   // handleChangeGTR4NameSP: function(component, event, helper) {
   //    var changeGTRNameSP = component.find("GTR-4-Name-SP").get("v.value");
   //    var updateGTRNameSP = component.set("v.newBoardingForm.GTR_4_Name_Source_Page__c", changeGTRNameSP);
   // },
   // handleChangeGTR4Street: function(component, event, helper) {
   //    var changeGTRStreet  = component.find("GTR-4-Mailing-Street").get("v.value");
   //    var updateGTRStreet  = component.set("v.newBoardingForm.Guarantor_4_Mailing_Street__c", changeGTRStreet);
   // },
   // handleChangeGTR4StreetSP: function(component, event, helper) {
   //    var changeGTRStreetSP = component.find("GTR-4-Mailing-Street-SP").get("v.value");
   //    var updateGTRStreetSP = component.set("v.newBoardingForm.GTR_4_Mailing_Street_Source_Page__c", changeGTRStreetSP);
   // },
   // handleChangeGTR4City: function(component, event, helper) {
   //    var changeGTRCity = component.find("GTR-4-Mailing-City").get("v.value");
   //    var updateGTRCity = component.set("v.newBoardingForm.Guarantor_4_Mailing_City__c", changeGTRCity);
   // },
   // handleChangeGTRCitySP: function(component, event, helper) {
   //    var changeGTRCitySP = component.find("GTR-4-Mailing-City-SP").get("v.value");
   //    var updateGTRCitySP = component.set("v.newBoardingForm.GTR_4_Mailing_City_Source_Page__c", changeGTRCitySP);
   // },
   // handleChangeGTR4State: function(component, event, helper) {
   //    var changeGTRState = component.find("GTR-4-Mailing-State").get("v.value");
   //    var updateGTRState   = component.set("v.newBoardingForm.Guarantor_44_Mailing_State__c", changeGTRState);
   // },
   // handleChangeGTR4StateSP: function(component, event, helper) {
   //    var changeGTRStateSP = component.find("GTR-4-Mailing-State-SP").get("v.value");
   //    var updateGTRStateSP = component.set("v.newBoardingForm.GTR_4_Mailing_State_Source_Page__c", changeGTRStateSP);
   // },
   // handleChangeGTR4PostalCode: function(component, event, helper) {
   //    var changeGTRPostalCode = component.find("GTR-4-Mailing-Postal-Code").get("v.value");
   //    var updateGTRPostalCode = component.set("v.newBoardingForm.Guarantor_4_Mailing_Postal_Code_Zip__c", changeGTRPostalCode);
   // },
   // handleChangeGTR4PostalCodeSP: function(component, event, helper) {
   //    var changeGTRPostalCodeSP = component.find("GTR-4-Mailing-Postal-Code-SP").get("v.value");
   //    var updateGTRPostalCodeSP = component.set("v.newBoardingForm.GTR_4_Postal_Code_Zip_Source_Page__c", changeGTRPostalCodeSP);
   // },
   // handleChangeGTR4Country: function(component, event, helper) {
   //    var changeGTRCountry = component.find("GTR-4-Mailing-Country").get("v.value");
   //    var updateGTRCountry = component.set("v.newBoardingForm.Guarantor_4_Mailing_Country__c", changeGTRCountry);
   // },
   // handleChangeGTR4CountrySP: function(component, event, helper) {
   //    var changeGTRCountry = component.find("GTR-4-Mailing-Country-SP").get("v.value");
   //    var updateGTRCountry = component.set("v.newBoardingForm.Guarantor_4_Mailing_Country_Source_Page__c", changeGTRCountry);
   // },
   // handleChangeGTR4Phone: function(component, event, helper) {
   //    var changeGTRPhone = component.find("GTR-4-Phone-Number").get("v.value");
   //    var updateGTRPhone = component.set("v.newBoardingForm.Guarantor_4_Phone_Number__c", changeGTRPhone);
   // },
   // handleChangeGTR4PhoneSP: function(component, event, helper) {
   //    var changeGTRPhoneSP = component.find("GTR-4-Phone-Number-SP").get("v.value");
   //    var updateGTRPhoneSP = component.set("v.newBoardingForm.GTR_4_Phone_Number_Source_Page__c", changeGTRPhoneSP);
   // },
   // handleChangeGTR4Email: function(component, event, helper) {
   //    var changeGTREmail = component.find("GTR-4-Email").get("v.value");
   //    var updateGTREmail = component.set("v.newBoardingForm.Guarantor_4_Email__c", changeGTREmail); 
   // },
   // handleChangeGTR4EmailSP: function(component, event, helper) {
   //    var changeGTREmailSP = component.find("GTR-4-Email-SP").get("v.value");
   //    var updateGTREmailSP = component.set("v.newBoardingForm.GTR_4_Email_Source_Page__c", changeGTREmailSP);
   // },
   // handleChangeGTR4BirthdateSP: function(component, event, helper) {
   //    var changeGTRBirthdate = component.find("GTR-4-Birthdate").get("v.value");
   //    var updateGTRBirthdate = component.set("v.newBoardingForm.Guarantor_4_Birthdate__c", changeGTRBirthdate);
   // },
   // handleChangeGTR4BirthdateSP: function(component, event, helper) {
   //    var changeGTRBirthdateSP = component.find("GTR-4-Birthdate-SP").get("v.value");
   //    var updateGTRBirthdateSP = component.set("v.newBoardingForm.GTR_4_Birthdate_Source_Page__c", changeGTRBirthdateSP);
   // },
   // handleChangeGTR4TaxNumber: function(component, event, helper) {
   //    var changeGTRTaxNumber = component.find("GTR-4-Tax-ID-Number").get("v.value");
   //    var updateGTRTaxNumber = component.set("v.newBoardingForm.Guarantor_4_Tax_ID_Number__c", changeGTRTaxNumber);
   // },
   // handleChangeGTR4TaxNumberSP: function(component, event, helper) {
   //    var changeGTRTaxNumberSP = component.find("GTR-4-Tax-ID-Number-SP").get("v.value");
   //    var updateGTRTaxNumberSP = component.set("v.newBoardingForm.GTR_4_Tax_ID_Number_Source_Page__c", changeGTRTaxNumberSP);
   // },
   // handleChangeGTR4TaxNumberType: function(component, event, helper) {
   //    var changeGTRTaxNumberType = component.find("GTR-4-Tax-ID-Number-Type").get("v.value");
   //    var updateGTRTaxNumberType = component.set("v.newBoardingForm.Guarantor_4_Tax_ID_Number_Type__c", changeGTRTaxNumberType);
   // },
   // handleChangeGTR4TaxNumberTypeSP: function(component, event, helper) {
   //    var changeGTRTaxNumberTypeSP = component.find("GTR-4-Tax-ID-Number-Type-SP").get("v.value");
   //    var updateGTRTaxNumberTypeSP = component.set("v.newBoardingForm.GTR_4_Tax_ID_Number_Type_Source_Page__c", changeGTRTaxNumberTypeSP);
   // },
   // handleChangeGTR4ClassCode: function(component, event, helper) {
   //    var changeGTRClassCode = component.find("GTR-4-Class-Code").get("v.value");
   //    var updateGTRClassCode = component.set("v.newBoardingForm.Guarantor_4_Class_Code__c", changeGTRClassCode);
   // },
   // handleChangeGTR4ClassCodeSP: function(component, event, helper) {
   //    var changeGTRClassCodeSP = component.find("GTR-4-Class-Code-SP").get("v.value");
   //    var updateGTRClassCodeSP = component.set("v.newBoardingForm.GTR_4_Class_Code_Source_Page__c", changeGTRClassCodeSP);
   // },
   // handleChangeGTR4Contingent: function(component, event, helper) {
   //    var changeGTRContingent = component.find("GTR-4-Contingent").get("v.value");
   //    var updateGTRContingent = component.set("v.newBoardingForm.Guarantor_4_Contingent__c", changeGTRContingent);
   // },
   // handleChangeGTR4ContingentSP: function(component, event, helper) {
   //    var changeGTRContingentSP = component.find("GTR-4-Contingent-SP").get("v.value");
   //    var updateGTRContingentSP = component.set("v.newBoardingForm.GTR_4_Contingent_Source_Page__c", changeGTRContingentSP);
   // },
   // handleChangeGTR4Gender: function(component, event, helper) {
   //    var changeGTRGender = component.find("GTR-4-Gender").get("v.value");
   //    var updateGTRGender = component.set("v.newBoardingForm.Guarantor_4_Gender__c", changeGTRGender);
   // },
   // handleChangeGTR4GenderSP: function(component, event, helper) {
   //    var changeGTRGenderSP = component.find("GTR-4-Gender-SP").get("v.value");
   //    var updateGTRGenderSP = component.set("v.newBoardingForm.GTR_4_Gender_Source_Page__c", changeGTRGenderSP);
   // },
   // Loan & Account Info
   handleChangeLoanNumberSP: function(component, event, helper) {
      var changeLoanNumberSP = component.find("Loan-Number-SP").get("v.value");
      var updateLoanNumberSP = component.set("v.newBoardingForm.Loan_Number_Source_Page__c", changeLoanNumberSP);
   },
   handleChangeDDA1: function(component, event, helper) {
      var changeDDA1 = component.find("DDA-Account-1-SP").get("v.value");
      var updateDDA1 = component.set("v.newBoardingForm.DDA_Account_Number_1_Source_Page__c", changeDDA1);
   },
   handleChangeDDA2: function(component, event, helper) {
      var changeDDA2 = component.find("DDA-Account-2-SP").get("v.value");
      var updateDDA2 = component.set("v.newBoardingForm.DDA_Account_Number_2_Source_Page__c", changeDDA2);
   },
   handleChangeDDA3: function(component, event, helper) {
      var changeDDA3 = component.find("DDA-Account-3-SP").get("v.value");
      var updateDDA3 = component.set("v.newBoardingForm.DDA_Account_Number_3_Source_Page__c", changeDDA3);
   },
   handleChangeRiskRating: function(component, event, helper) {
      var changeRiskRating = component.find("Risk-Rating").get("v.value");
      var updateRiskRating = component.set("v.newBoardingForm.Risk_Rating__c", changeRiskRating);
   },
   handleChangeRiskRatingSP: function(component, event, helper) {
      var changeRiskRatingSP = component.find("Risk-Rating-SP").get("v.value");
      var updateRiskRatingSP = component.set("v.newBoardingForm.Risk_Rating_Source_Page__c", changeRiskRatingSP);
   },
   handleChangeBranch: function(component, event, helper) {
      var changeBranchNumber = component.find("Branch-Number").get("v.value");
      var updateBranchNumber = component.set("v.newBoardingForm.Branch_Number__c", changeBranchNumber);
   },
   handleChangeBranchSP: function(component, event, helper) {
      var changeBranchNumberSP = component.find("Branch-Number-SP").get("v.value");
      var updateBranchNumberSP = component.set("v.newBoardingForm.Branch_Number_Source_Page__c", changeBranchNumberSP);
   },
   handleChangeRelMgr: function(component, event, helper){ 
      var changeRelationshipMgr = component.find("Relationship-Manager").get("v.value");
      var updateRelationshipMgr = component.set("v.newBoardingForm.Relationship_Manager__c", changeRelationshipMgr);
   },
   handleChangeRelMgrSP: function(component, event, helper) {
      var changeRelationshipMgrSP = component.find("Relationship-Manager-SP").get("v.value");
      var updateRelationshipMgrSP = component.set("v.newBoardingForm.Relationship_Manager_Source_Page__c", changeRelationshipMgrSP);
   },
   handleChangePrimaryAnalyst: function(component, event, helper) {
      var changePrimaryAnalyst = component.find("Primary-Analyst").get("v.value");
      var updatePrimaryAnaylyst = component.set("v.newBoardingForm.Primary_Analyst__c", changePrimaryAnalyst);
   },
   handleChangePrimaryAnalystSP: function(component, event, helper) {
      var changePrimaryAnalystSP = component.find("Primary-Analyst-SP").get("v.value");
      var updatePrimaryAnlystSP = component.set("v.newBoardingForm.Primary_Analyst_Source_Page__c", changePrimaryAnalystSP);
   },
   handleChangeCILoan: function(component, event, helper) {
      var changeCILoan = component.find("CI-Loan-Type").get("v.value");
      var updateCILoan = component.set("v.newBoardingForm.C_I_Loan_Type__c", changeCILoan);
   },
   handleChangeCILoanSP: function(component, event, helper) {
      var changeCILoanSP = component.find("CI-Loan-Type-SP").get("v.value");
      var updateCILoanSP = component.set("v.newBoardingForm.C_I_Loan_Type_Source_Page__c", changeCILoanSP);
   },
   handleChangePurposeCode: function(component, event, helper) {
      var changePurposeCode = component.find("Purpose-Code").get("v.value");
      var updatePurposeCode = component.set("v.newBoardingForm.Purpose_Code__c", changePurposeCode);
   },
   handleChangePurposeCodeSP: function(component, event, helper) {
      var changePurposeCodeSP = component.find("Purpose-Code-SP").get("v.value");
      var updatePurposeCodeSP = component.set("v.newBoardingForm.Purpose_Code_Source_Page__c", changePurposeCodeSP);
   },
   handleChangeCollCodeDesc: function(component, event, helper) {
      var changeCollCodeDesc = component.find("Collateral-Code-Description").get("v.value");
      var updateCollCodeDesc = component.set("v.newBoardingForm.Collateral_Code_Description__c");
   },
   handleChangeCollCodeDescSP: function(component, event, helper) {
      var changeCollCodeDescSP = component.find("Collateral-Code-Description-SP").get("v.value");
      var updateCollCodeDescSP = component.set("v.newBoardingForm.Coll_Code_Description_Source_Page__c", changeCollCodeDescSP);
   },
   handleChangeCallReport: function(component, event, helper) {
      var changeCallReport = component.find("Call-Report-Code").get("v.value");
      var updateCallReport = component.set("v.newBoardingForm.Call_Report_Code__c", changeCallReport);
   },
   handleChangeCallReportSP: function(component, event, helper) {
      var changeCallReportSP = component.find("Call-Report-Code-SP").get("v.value");
      var updateCallReportSP = component.set("v.newBoardingForm.Call_Report_Code_Source_Page__c", changeCallReportSP);
   },
   handleChangeLoanClassCode: function(component, event, helper) {
      var changeLoanClassCode = component.find("Loan-Class-Code").get("v.value");
      var updateLoanClassCode = component.set("v.newBoardingForm.Loan_Class_Code__c", changeLoanClassCode);
   },
   handleChangeLoanClassCodeSP: function(component, event, helper) {
      var changeLoanClassCodeSP = component.find("Loan-Class-Code-SP").get("v.value");
      var updateLoanClassCodeSP = component.set("v.newBoardingForm.Loan_Class_Code_Source_Page__c", changeLoanClassCodeSP);
   },
   handleChangeNAICS: function(component, event, helper) {
      var changeNAICSCode = component.find("NAICS-Code").get("v.value");
      var updateNAICSCode = component.set("v.newBoardingForm.NAICS_Code__c", changeNAICSCode);
   },
   handleChangeNAICSSP: function(component, event, helper) {
      var changeNAICSCodeSP = component.find("NAICS-Code-SP").get("v.value");
      var updateNAICSCodeSP = component.set("v.newBoardingForm.NAICS_Code__c", changeNAICSCodeSP);
   },
   handleChangeLoanTermMonth: function(component, event, helper) {
      var changeLoanTermMonth = component.find("Loan-Term-Months").get("v.value");
      var updateLoanTermMonth = component.set("v.newBoardingForm.Loan_Term_months__c", changeLoanTermMonth);
   },
   handleChangeLoanTermMonthSP: function(component, event, helper) {
      var changeLoanTermMonthSP = component.find("Loan-Term-Months-SP").get("v.value");
      var updateLoanTermMonthSP = component.set("v.newBoardingForm.Loan_Term_months_Source_Page__c", changeLoanTermMonthSP);
   },
   handleChangeOrigination: function(component, event, helper) {
      var changeOriginationDate = component.find("Origination-Date").get("v.value");
      var updateOriginationDate = component.set("v.newBoardingForm.Origination_Date_note_date__c", changeOriginationDate);
   },
   handleChangeOriginationSP: function(component, event, helper) {
      var changeOriginationDateSP = component.find("Origination-Date-SP").get("v.value");
      var updateOriginationDateSP = component.set("v.newBoardingForm.Origination_Date_Source_Page__c", changeOriginationDateSP);
   },
   handleChangeMaturity: function(component, event, helper) {
      var changeMaturityDate = component.find("Maturity-Date").get("v.value");
      var updateMaturityDate = component.set("v.newBoardingForm.Maturity_Date__c", changeMaturityDate);
   },
   handleChangeMaturitySP: function(component, event, helper) {
      var changeMaturityDateSP = component.find("Maturity-Date-SP").get("v.value");
      var updateMaturityDateSP = component.set("v.newBoardingForm.Maturity_Date_Source_Page__c", changeMaturityDateSP);
   },
   handleChangeProjectedFundingSP: function(component, event, helper) {
      var changeProjectedInitialFundingSP = component.find("Projected-Initial-Funding-SP").get("v.value");
      var updateProjectedInitialFundingSP = component.set("v.newBoardingForm.Projected_Initial_Funding_Source_Page__c", changeProjectedInitialFundingSP);
   },
   handleChangeDateEntered: function(component, event, helper) {
      var changeDateEntered = component.find("Date-Entered").get("v.value");
      var updateDateEntered = component.set("v.newBoardingForm.Date_Entered_Final_Boarding__c", changeDateEntered);
   },
   handleChangeDateEnteredSP: function(component, event, helper) {
      var changeDateEnteredSP = component.find("Date-Entered-SP").get("v.value");
      var updateDateEnteredSP = component.set("v.newBoardingForm.Date_Entered_Source_Page__c", changeDateEnteredSP);
   },
   handleChangeTermCode: function(component, event, helper) {
      var changeTermCode = component.find("Term-Code").get("v.value");
      var updateTermCode = component.set("v.newBoardingForm.Term_Code__c", changeTermCode);
   },
   handleChangeTermCodeSP: function(component, event, helper) {
      var changeTermCodeSP = component.find("Term-Code-SP").get("v.value");
      var updateTermCodeSP = component.set("v.newBoardingForm.Term_Code_Source_Page__c", changeTermCodeSP);
   },
   handleChangeFundingDateSP: function(component, event, helper) {
      var changeFundingDateSP = component.find("Funding-Date-SP").get("v.value");
      var updateFundingDateSP = component.set("v.newBoardingForm.Funding_Date_Source_Page__c", changeFundingDateSP);
   },
   handleChangeManagementCode: function(component, event, helper) {
      var changeManagementCode = component.find("Management-Code").get("v.value");
      var updateManagementCode = component.set("v.newBoardingForm.Management_Code__c", changeManagementCode);
   },
   handleChangeManagementCodeSP: function(component, event, helper) {
      var changeManagementCodeSP = component.find("Management-Code-SP").get("v.value");
      var updateManagementCodeSP = component.set("v.newBoardingForm.Management_Code_Source_Page__c", changeManagementCodeSP);
   },
   handleChangeCRE: function(component, event, helper) {
      var changeCRESubProperty = component.find("CRE-Sub-Property-Type").get("v.value");
      var updateCRESubProperty = component.set("v.newBoardingForm.CRE_Sub_Property_Type__c", changeCRESubProperty);
   },
   handleChangeCRESP: function(component, event, helper) {
      var changeCRESubPropertySP = component.find("CRE-Sub-Property-Type-SP").get("v.value");
      var updateCRESubPropertySP = component.set("v.newBoardingForm.CRE_Sub_Property_Type_Source_Page__c", changeCRESubPropertySP);
   },
   handleChangeIBase: function(component, event, helper) {
      var changeIBase = component.find("IBase").get("v.value");
      var updateIBase = component.set("v.newBoardingForm.IBase_SFDC2__c", changeIBase);
   },
      //  Payment Info
   handleChangePaymentFreq: function(component, event, helper) {
      var changePaymentFrequency = component.find("Payment-Frequency").get("v.value");
      var updatePaymentFrequency = component.set("v.newBoardingForm.Payment_Frequency__c", changePaymentFrequency);
   },
   handleChangePaymentFreqSP: function(component, event, helper) {
      var changePaymentFrequencySP = component.find("Payment-Frequency-SP").get("v.value");
      var updatePaymentFrequencySP = component.set("v.newBoardingForm.Payment_Frequency_Source_Page__c", changePaymentFrequencySP);
   },
   handleChangePaymentCode: function(component, event, helper) {
      var changePaymentCode = component.find("Payment-Code").get("v.value");
      var updatePaymentCode = component.set("v.newBoardingForm.Payment_Code__c", changePaymentCode);
   },
   handleChangePaymentCodeSP: function(component, event, helper) {
      var changePaymentCodeSP = component.find("Payment-Code-SP").get("v.value");
      var updatePaymentCodeSP = component.set("v.newBoardingForm.Payment_Code_Source_Page__c", changePaymentCodeSP);
   },
   handleChangeFirstPayment: function(component, event, helper) {
      var changeFirstPaymentDate = component.find("First-Payment-Date").get("v.value");
      var updateFirstPaymentDate = component.set("v.newBoardingForm.First_Payment_Date__c", changeFirstPaymentDate);
   },
   handleChangeFirstPaymentSP: function(component, event, helper) {
      var changeFirstPaymentDateSP = component.find("First-Payment-Date-SP").get("v.value");
      var updateFirstPaymentDateSP = component.set("v.newBoardingForm.First_Payment_Date_Source_Page__c", changeFirstPaymentDateSP);
   },
   handleChangeNextDueDate: function(component, event, helper) {
      var changeNextDueDate = component.find("Next-Due-Date").get("v.value");
      var updateNextDueDate = component.set("v.newBoardingForm.Next_Due_Date__c", changeNextDueDate);
   },
   handleChangeNextDueDateSP: function(component, event, helper) {
      var changeNextDueDateSP = component.find("Next-Due-Date-SP").get("v.value");
      var updateNextDueDateSP = component.set("v.newBoardingForm.Next_Due_Date_Source_Page__c", changeNextDueDateSP);
   },
   handleChangeSendPayment: function(component, event, helper) {
      var changeSendPaymentBilling = component.find("Send-Payment-Billings").get("v.value");
      var updateSendPaymentBilling = component.set("v.newBoardingForm.Send_Payment_Billings__c", changeSendPaymentBilling);
   },
   handleChangeSendPaymentSP: function(component, event, helper) {
      var changeSendPaymentBillingSP = component.find("Send-Payment-Billings-SP").get("v.value");
      var updateSendPaymentBillingSP = component.set("v.newBoardingForm.Send_Payment_Billings_Source_Page__c", changeSendPaymentBillingSP);
   },
   handleChangeDaysBefore: function(component, event, helper) {
      var changeDaysBefore = component.find("Days-Before-Printing").get("v.value");
      var updateDaysBefore = component.set("v.newBoardingForm.of_Days_Before_Printing_Bills__c", changeDaysBefore);
   },
   handleChangeDaysBeforeP: function(component, event, helper) {
      var changeDayBeforePrintingSP = component.find("Days-Before-Printing-SP").get("v.value");
      var updateDayBeforePrintingSP = component.set("v.newBoardingForm.Days_Before_Printing_Source_Page__c", changeDayBeforePrintingSP);
   },
      // Rate Info
   handleChangeRate: function(component, event, helper) {
      var changeRate = component.find("Rate").get("v.value");
      var updateRate = component.set("v.newBoardingForm.Rate__c", changeRate);
   },
   handleChangeRateSP: function(component, event, helper) {
      var changeRateSP = component.find("Rate-SP").get("v.value");
      var updateRateSP = component.set("v.newBoardingForm.Rate_Source_Page__c", changeRateSP);
   },
   handleChangeRateIndex: function(component, event, helper) {
      var changeRateIndexNumber = component.find("Rate-Index-Number").get("v.value");
      var updateRateIndexNumber = component.set("v.newBoardingForm.Rate_Index_Number__c", changeRateIndexNumber);
   },
   handleChangeRateIndexSP: function(component, event, helper) {
      var changeRateIndexNumberSP = component.find("Rate-Index-Number-SP").get("v.value");
      var updateRateIndexNumberSP = component.set("v.newBoardingForm.Rate_Index_Number_Source_Page__c", changeRateIndexNumberSP);
   },
   handleChangeRateFloor: function(component, event, helper) {
      var changeRateFloor = component.find("Rate-Floor").get("v.value");
      var updateRateFloor = component.set("v.newBoardingForm.Rate_Floor__c", changeRateFloor);
   },
   handleChangeRateFloorSP: function(component, event, helper) {
      var changeRateFloorSP = component.find("Rate-Floor-SP").get("v.value");
      var updateRateFloorSP = component.set("v.newBoardingForm.Rate_Floor_Source_Page__c", changeRateFloorSP);
   },
   handleChangeRateMargin: function(component, event, helper) {
      var changeRateMargin = component.find("Rate-Margin").get("v.value");
      var updateRateMargin = component.set("v.newBoardingForm.Rate_Margin__c", changeRateMargin);
   },
   handleChangeRateMarginSP: function(component, event, helper) {
      var changeRateMarginSP = component.find("Rate-Margin-SP").get("v.value");
      var updateRateMarginSP = component.set("v.newBoardingForm.Rate_Margin_Source_Page__c", changeRateMarginSP);
   },
   handleChangeRateReviewD: function(component, event, helper) {
      var changeRateReviewDate = component.find("Rate-Review-Date").get("v.value");
      var updateRateReviewDate = component.set("v.newBoardingForm.Rate_Review_Date__c");
   },
   handleChangeRateReviewDSP: function(component, event, helper) {
      var changeRateReviewDate = component.find("Rate-Review-Date-SP").get("v.value");
      var updateRateReviewDate = component.set("v.newBoardingForm.Rate_Review_Date_Source_Page__c");
   },
   handleChangeRateReviewT: function(component, event, helper) {
      var changeRateReviewTerm = component.find("Rate-Review-Term").get("v.value");
      var updateRateReviewTerm = component.set("v.newBoardingForm.Rate_Review_Term__c", changeRateReviewTerm);
   },
   handleChangeRateReviewTSP: function(component, event, helper) {   
      var changeRateReviewTermSP = component.find("Rate-Review-Term-SP").get("v.value");
      var updateRateReviewTermSP = component.set("v.newBoardingForm.Rate_Review_Term_Source_Page__c", changeRateReviewTermSP);
   },
   handleChangeRateReviewF: function(component, event, helper) {
      var changeRateReviewTermFreq = component.find("Rate-Review-Term-Frequency").get("v.value");
      var updateRateReviewTermFreq = component.set("v.newBoardingForm.Rate_Review_Term_Frequency__c", changeRateReviewTermFreq);
   },
   handleChangeRateReviewFSP: function(component, event, helper) {
      var changeRateReviewTermFreqSP = component.find("Rate-Review-Term-Frequency-SP").get("v.value");
      var updateRateReviewTermFreqSP = component.set("v.newBoardingForm.Rate_Review_Term_Frequency_Source_Page__c", changeRateReviewTermFreqSP);
   },
   handleChangeRateReviewM: function(component, event, helper) {
      var changeRateReviewDayMonth = component.find("Rate-Review-Day-Month").get("v.value");
      var updateRateReviewDayMonth = component.set("v.newBoardingForm.Rate_Review_Day_of_Month__c", changeRateReviewDayMonth);
   },
   handleChangeRateReviewMSP: function(component, event, helper) {
      var changeRateReviewDayMonthSP = component.find("Rate-Review-Day-Month-SP").get("v.value");
      var updateRateReviewDayMonthSP = component.set("v.newBoardingForm.Rate_Review_Day_of_Month_Source_Page__c", changeRateReviewDayMonthSP);
   },

      // Collateral Informtion
   handleChangeLTV: function(component, event, helper) {
      var changeLTV = component.find("LTV").get("v.value");
      var updateLTV = component.set("v.newBoardingForm.LTV__c", changeLTV);
   },
   handleChangeLTVSP: function(component, event, helper) {
      var changeLTVSP = component.find("LTV-SP").get("v.value");
      var updateLTVSP = component.set("v.newBoardingForm.LTV_Source_Page__c", changeLTVSP);
   },
   handleChangePropertyStreet: function(component, event, helper) {
      var changePropertyStreet = component.find("Property-Street").get("v.value");
      var updatePropertyStreet = component.set("v.newBoardingForm.Property_Street__c", changePropertyStreet);
   },
   handleChangePropertyStreetSP: function(component, event, helper) {
      var changePropertyStreetSP = component.find("Property-Street-SP").get("v.value");
      var updatePropertyStreetSP = component.set("v.newBoardingForm.Property_Street_Source_Page__c", changePropertyStreetSP);
   },
   handleChangePropertyCity: function(component, event, helper) {
      var changePropertyCity = component.find("Property-City").get("v.value");
      var updatePropertyCity = component.set("v.newBoardingForm.Property_City__c", changePropertyCity);
   },
   handleChangePropertyCitySP: function(component, event, helper) {
      var changePropertyCitySP = component.find("Property-City-SP").get("v.value");
      var updatePropertyCitySP = component.set("v.newBoardingForm.Property_City_Source_Page__c", changePropertyCitySP);
   },
   handleChangePropertyState: function(component, event, helper) {
      var changePropertyState = component.find("Property-State").get("v.value");
      var updatePropertyState = component.set("v.newBoardingForm.Property_State__c", changePropertyState);
   },
   handleChangePropertyStateSP: function(component, event, helper) {
      var changePropertyStateSP = component.find("Property-State-SP").get("v.value");
      var updatePropertyStateSP = component.set("v.newBoardingForm.Property_State_Source_Page__c", changePropertyStateSP);
   },
   handleChangePropertyPostalCode: function(component, event, helper) {
      var changePropertyPostalCode = component.find("Property-Postal-Code").get("v.value");
      var updatePropertyPostalCode = component.set("v.newBoardingForm.Property_Postal_Code_Zip__c", changePropertyPostalCode);
   },
   handleChangePropertyPostalCodeSP: function(component, event, helper) {
      var changePropertyPostalCodeSP = component.find("Property-Postal-Code-SP").get("v.value");
      var updatePropertyPostalCodeSP = component.set("v.newBoardingForm.Property_Postal_Code_Zip_Source_Page__c", changePropertyPostalCodeSP);
   },
   handleChangePropertyCountry: function(component, event, helper) {
      var changePropertyCountry = component.find("Property-Country").get("v.value");
      var updatePropertyCountry = component.set("v.newBoardingForm.Property_Country__c", changePropertyCountry);
   },
   handleChangePropertyCountrySP: function(component, event, helper) {
      var changePropertyCountrySP = component.find("Property-Country-SP").get("v.value");
      var updatePropertyCountrySP = component.set("v.newBoardingForm.Property_Country_Source_Page__c", changePropertyCountrySP);
   },
   handleChangeAppraisedV: function(component, event, helper) {
      var changeAppraisedValue = component.find("Appraised-Value").get("v.value");
      var updateAppraisedValue = component.set("v.newBoardingForm.Appraised_Value__c", changeAppraisedValue);
   },
   handleChangeAppraisedVSP: function(component, event, helper) {
      var changeAppraisedValueSP = component.find("Appraised-Value-SP").get("v.value");
      var updateAppraisedValueSP = component.set("v.newBoardingForm.Appraised_Value_Source_Page__c", changeAppraisedValueSP);
   },
   handleChangeAppraisalR: function(component, event, helper) {
      var changeAppraisalReviewDate = component.find("Appraisal-Review-Date").get("v.value");
      var updateAppraisalReviewDate = component.set("v.newBoardingForm.Appraisal_Review_Date__c", changeAppraisalReviewDate);
   },
   handleChangeAppraisalRSP: function(component, event, helper) {
      var changeAppraisalReviewDateSP = component.find("Appraisal-Review-Date-SP").get("v.value");
      var updateAppraisalReviewDateSP = component.set("v.newBoardingForm.Appraisal_Review_Date_Source_Page__c", changeAppraisalReviewDateSP);
   },
   handleChangeYearB: function(component, event, helper) {
      var changeYearBuilt = component.find("Year-Built").get("v.value");
      var updateYearBuilt = component.set("v.newBoardingForm.Year_Built__c", changeYearBuilt);
   },
   handleChangeYearBSP: function(component, event, helper) {
      var changeYearBuiltSP = component.find("Year-Built-SP").get("v.value");
      var updateYearBuiltSP = component.set("v.newBoardingForm.Year_Built_Source_Page__c", changeYearBuiltSP);
   },
   handleChangeCollInsurance: function(component, event, helper) {
      var changeCollInsurance = component.find("Collateral-Insurance-Exp-Date").get("v.value");
      var updateCollInsurance = component.set("v.newBoardingForm.Collateral_Insurance_Exp_Date__c", changeCollInsurance);
   },
   handleChangeCollInsuranceSP: function(component, event, helper) {
      var changeCollInsuranceSP = component.find("Collateral-Insurance-Exp-Date-SP").get("v.value");
      var updateCollInsuranceSP = component.set("v.newBoardingForm.Coll_Insurance_Exp_Date_Source_Page__c", changeCollInsuranceSP);
   },
   handleChangeFloodI: function(component, event, helper) {
      var changeFloodInsurance = component.find("Flood-Insurance-Required").get("v.value");
      var changeFloodInsurance = component.set("v.newBoardingForm.Flood_Insurance_Required__c", changeFloodInsurance);
   },
   handleChangeFloodISP: function(component, event, helper) {
      var changeFloodInsuranceSP = component.find("Flood-Insurance-Required-SP").get("v.value");
      var updateFloodInsuranceSP = component.set("v.newBoardingForm.Flood_Insurance_Required_Source_Page__c", changeFloodInsuranceSP);
   }
})