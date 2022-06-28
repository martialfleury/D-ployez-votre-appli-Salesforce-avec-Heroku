@RestResource(urlMapping='/Contract/*')
global with sharing class ContractManager 
{
   @HttpPost
   global static Id createContract(String Name, String Status, Id AccountId, Date StartDate, Integer ContractTerm)
   {  
    // creation d'un contract
    Contract thisContract = new Contract(
              Name = name,
              Status = status,
              AccountId = AccountId,
              StartDate = startDate,  
              ContractTerm = contractTerm );
         insert thisContract;
         return thisContract.Id;
   }

   @HttpPatch
   global static Id updateContract(String Name, String Status, Id AccountId)
   {
      RestRequest request = RestContext.request;
      String contractId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
      Contract res = [SELECT Id FROM Contract WHERE Id = :contractId];
      // Deserialize the JSON string into name-value pairs
      Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
      Contract thisContract = new Contract();
        //thisContract.Id = Id;  
        thisContract.Name = name;
        thisContract.Status = status;
        thisContract.AccountId = AccountId;
        for(String fieldName : params.keySet()) 
        {
         // Set the field and value on the contract sObject
        thisContract.put(fieldName, params.get(fieldName));
        }
        update thisContract;
        return thisContract.Id;
   }
    
}
