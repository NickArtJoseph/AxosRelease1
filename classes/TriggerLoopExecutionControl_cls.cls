/*******************************************************************************
Description: APEX class that has -as its main objective- to avoid the recursive execution of triggers.

VersionDate       Author                     Descripction
------ ---------- -------------------------- -----------
0.1    06-26-2018 René Ayala Medina RAM      Creation
0.2    06-26-2018 René Ayala Medina RAM      Building
1.0    06-26-2018 René Ayala Medina RAM      Ending and documentation     
*******************************************************************************/
public class TriggerLoopExecutionControl_cls {
    
    /* Set that storages the text charsets related to the specific executed triggers. This in order to be known which trigger has been already executed and which one hasn't */
    
    private static Set<String> setExecutedTrigger = new Set<String>();

    /*
    	Method that validates whether the trigger has already been executed. If not, it returns "true"; otherwise, "false".
    */

    public static Boolean hasAlreadyBeenExecuted(String strTriggerName)
    {
        if(!setExecutedTrigger.isEmpty())
        {
            return setExecutedTrigger.contains(strTriggerName);   /* If set is not empty, "true" or "false" is returned depending on the existence of the text charset in it */
        }
        else
        {
            return false;  /* Set is empty */
        }
    }

    /* 
    	Method that is used to store the text charset regarding to the executed trigger. This in order to be known that such trigger has been already executed.
    */

    public static void setAlreadyBeenExecuted(String strTriggerName)
    {
        setExecutedTrigger.add(strTriggerName);  /* text charset is stored in this set */
    }

    /*
    	Method that is used to erase a text charset regarding to a specific trigger. After executing this method, such trigger can be executed again.
    */
    
    public static void resetStatusExecutionTrigger(String strTriggerName)
    {
        if(setExecutedTrigger.contains(strTriggerName))
        {
            setExecutedTrigger.remove(strTriggerName);  /* The specified text charset is erased from the set */
        }
    }

}