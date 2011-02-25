/**
 * Copyright (c) 2010, FinancialForce.com, inc
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, 
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice, 
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, 
 *      this list of conditions and the following disclaimer in the documentation 
 *      and/or other materials provided with the distribution.
 * - Neither the name of the FinancialForce.com, inc nor the names of its contributors 
 *      may be used to endorse or promote products derived from this software without 
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

public with sharing class ListController
{
    Integer m_size = 0;
    String m_search;
    
    public ListController() 
    {
    	m_search = ApexPages.currentPage().getParameters().get('s');
    	if (m_search!=null)
    	{
    		m_search='%'+m_search+'%';
    	}
    }
    
    // Constructor for Apex Tests only
    public ListController(String searchString) 
    {
    	m_search = searchString;
    	if (m_search!=null)
    	{
    		m_search='%'+m_search+'%';
    	}
    }
    
    public List<Task> getTasks()
    {
        Schema.DescribeSObjectResult describeResult = Task.sObjectType.getDescribe();
        if(!describeResult.isAccessible())
        {
			m_size = 0;     	
			return new List<Task>();
        }

    	List<Task> tasks;
        if(m_search==null)
        {
	        tasks = [
	                SELECT  t.id, t.Subject, t.ActivityDate, t.Status, t.isClosed, t.Priority From Task t 
	                where t.IsRecurrence=false and t.isClosed=false 
	                order by t.ActivityDate 
	                limit 251
	                ];
        }
        else
        {
	        tasks = [
	                SELECT  t.id, t.Subject, t.ActivityDate, t.Status, t.isClosed, t.Priority From Task t 
	                where (t.Subject like :m_search or t.Status like :m_search or t.Priority like :m_search) and t.IsRecurrence=false 
	                order by t.ActivityDate 
	                limit 251
	                ];
        }
        m_size = tasks.size();
        return tasks;
    }
    
    public List<Account> getAccounts()
    {
        Schema.DescribeSObjectResult describeResult = Account.sObjectType.getDescribe();
        if(!describeResult.isAccessible())
        {
			m_size = 0;     	
			return new List<Account>();
        }

        List<Account> accounts;
        if(m_search==null)
        {
        	accounts = [
                Select a.Id, a.Name, a.BillingCity, a.Phone From Account a 
                order by a.Name   
                limit 251
                ];
        }
        else
        {
            accounts = [
                Select a.Id, a.Name, a.BillingCity, a.Phone From Account a 
                where a.Name like :m_search or a.BillingCity like :m_search
                order by a.Name   
                limit 251
                ];
        }        
        m_size = accounts.size();
        return accounts;
    }
    
    public List<Opportunity> getOpportunities()
    {
        Schema.DescribeSObjectResult describeResult = Opportunity.sObjectType.getDescribe();
        if(!describeResult.isAccessible())
        {
			m_size = 0;     	
			return new List<Opportunity>();
        }

        List<Opportunity> opportunities;
        if(m_search==null)
        {
	        opportunities = [
	                Select o.Id, o.Name, o.CloseDate, o.Amount, o.Account.Name, o.AccountId From Opportunity o 
	                where StageName <> 'Closed Won'  
	                order by o.CloseDate desc  
	                limit 251
	                ];	
        }
        else
        {
        	
            opportunities = [
                Select o.Id, o.Name, o.CloseDate, o.Amount, o.Account.Name, o.AccountId From Opportunity o 
                where o.Name like :m_search or o.Account.Name like :m_search 
                order by o.CloseDate desc  
                limit 251
                ];
        }
        m_size = opportunities.size();
        return opportunities;
    }
    
    public List<c2g__codaInvoice__c> getInvoices()
    {
        Schema.DescribeSObjectResult describeResult = c2g__codaInvoice__c.sObjectType.getDescribe();
        if(!describeResult.isAccessible())
        {
			m_size = 0;     	
			return new List<c2g__codaInvoice__c>();
        }

        List<c2g__codaInvoice__c> invoices;
        if(m_search==null)
        {
	        invoices = [
	                SELECT  c.id, c.Name,  c.c2g__DueDate__c, c.c2g__InvoiceTotal__c, c.c2g__Account__r.Name, c.c2g__Account__c, c2g__codaInvoice__c.c2g__InvoiceCurrency__r.Name
	                From  c2g__codaInvoice__c c 
	                order by c.c2g__DueDate__c desc  
	                limit 251
	                ];
        }
        else
        {
	        invoices = [
	                SELECT  c.id, c.Name,  c.c2g__DueDate__c, c.c2g__InvoiceTotal__c, c.c2g__Account__r.Name, c.c2g__Account__c, c2g__codaInvoice__c.c2g__InvoiceCurrency__r.Name
	                From  c2g__codaInvoice__c c 
	                where c.c2g__Account__r.Name like :m_search or c.Name like :m_search 
	                order by c.c2g__DueDate__c desc  
	                limit 251
	                ];
        }
        m_size = invoices.size();
        return invoices;
    }
    
    public integer getSize()
    {
        return m_size;
    }
}