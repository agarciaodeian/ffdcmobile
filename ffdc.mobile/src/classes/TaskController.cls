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

public with sharing class TaskController
{
    private ApexPages.StandardController m_stdController;
    private Task m_task;
	private Boolean m_isRelatedToAccount;
	private Boolean m_isRelatedToOpportunity;
	private Boolean m_isRelatedToSalesInvoice;
	sObject m_who;
   
    public TaskController(ApexPages.StandardController stdController) 
    {
		m_stdController = stdController;
		m_task = (Task) stdController.getRecord();
    }

	public PageReference save()
	{
		m_stdController.save();
        return null;
    }
    
    public Boolean getIsRelatedToAccount()
    {
		if(m_isRelatedToAccount==null)
		{
			m_isRelatedToAccount = m_task.WhatId != null && ((String)m_task.WhatId).startsWith(Schema.SObjectType.Account.keyPrefix);
		}
    	return m_isRelatedToAccount;
    }

    public Boolean getIsRelatedToOpportunity()
    {
		if(m_isRelatedToOpportunity==null)
		{
			m_isRelatedToOpportunity = m_task.WhatId != null && ((String)m_task.WhatId).startsWith(Schema.SObjectType.Opportunity.keyPrefix);
		}
    	
    	return m_isRelatedToOpportunity;
    }

    public Boolean getIsRelatedToSalesInvoice()
    {
		if(m_isRelatedToSalesInvoice==null)
		{
			m_isRelatedToSalesInvoice = m_task.WhatId != null && ((String)m_task.WhatId).startsWith(Schema.SObjectType.c2g__codaInvoice__c.keyPrefix);
		}
    	return m_isRelatedToSalesInvoice;
    }

    public Boolean getIsRelatedToUnsupported()
    {
    	return !(getIsRelatedToAccount() || getIsRelatedToOpportunity() || getIsRelatedToSalesInvoice());
    }

	public String getPhone()
    {
		return (String) getWho().get('Phone');
    }
    
    public String getEmail()
    {
		return (String) getWho().get('Email');
    }

	private sObject getWho()
	{
		if(m_who==null)
		{
			m_who = new Contact();
			if(m_task.WhoId != null)
			{
				List<SObject> rows;
				if( ((String)m_task.WhoId).startsWith(Schema.SObjectType.Contact.keyPrefix) )
				{
					rows = [select Phone, Email from Contact where Id = :m_task.WhoId];
				}
				else if( ((String)m_task.WhoId).startsWith(Schema.SObjectType.Lead.keyPrefix) )
				{
					rows = [select Phone, Email from Lead where Id = :m_task.WhoId];
				}
				if(rows.size()==1)
				{
					m_who = rows[0];
				}
			}
		}
		return m_who;
	}

}