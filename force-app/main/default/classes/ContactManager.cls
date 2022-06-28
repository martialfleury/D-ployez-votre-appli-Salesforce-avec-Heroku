@RestResource(urlMapping='/Contact/*')
global with sharing class ContactManager 
{
    @HttpPost
    global static Id createContact(String FirstName, String LastName, String Email)
    {   
        Contact con = new Contact();
        List<Contact> listContacts = [SELECT Id FROM Contact WHERE Email = : Email];

        
        // Verify if email already exist
            if (listContacts != null) 
            {
                return con.Id;
            }
            else
            {
                Contact newContact = new Contact(
                    FirstName = firstName,
                    LastName = lastName,
                    Email = email );
                insert newContact;
                return newContact.Id;
            }
    }

    @HttpPatch
    global static Id updateContact(String Id, String firstName, String LastName, String Email)
    {
        // Modification du contact 
        RestRequest request = RestContext.request;
        String contactId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Contact res = [SELECT Id FROM Contact WHERE Id = :contactId];
        // Deserialize the JSON string into name-value pairs
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        Contact thisContact = new Contact(); 
        thisContact.Id = id;  
        thisContact.FirstName = firstName;
        thisContact.LastName = lastName ;
        thisContact.Email = email;
        for(String fieldName : params.keySet()) 
        {
         // Set the field and value on the contact sObject
        thisContact.put(fieldName, params.get(fieldName));
        }
        update thisContact;
        return thisContact.Id;
    }

    @HttpDelete
    global static Id deactivateToContact()
    {
        // Desactivation dun contact mais pas le supprimé
        RestRequest request = RestContext.request;
        String contactId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        
        Contact res = [SELECT Id, deactivate__c FROM Contact WHERE Id = :contactId];
        Contact thisContact = new Contact(); 
        // thisContact.Id = Id; A RESOUDRE
        thisContact.deactivate__c = true;  
        update thisContact;
        return thisContact.Id;
    }
}