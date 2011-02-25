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

public with sharing class TestHelper
{
	public static final String IDENTIFIER = '_ApexTestRecord_';
	
	public static Account createAccount()
	{
		Account a = new Account();
		a.name = IDENTIFIER;
		insert a;
		return a;
	}

	public static Opportunity createOpportunity(ID accountId)
	{
		Opportunity o = new Opportunity();
		o.AccountId = accountId;
		o.Name = IDENTIFIER;
		o.StageName = 'Closed Won';
		o.CloseDate = Date.today();
		insert o;
		return o;
	}
	
	public static void createActivityHistory(ID whatId)
	{
		Task t = new Task();
		t.WhatId = whatId;
		t.Subject = IDENTIFIER;
		t.Status = 'Completed';
		insert t;
	}
	
	public static Contact createContact(ID accountId)
	{
		Contact c = new Contact();
		c.AccountId = accountId;
		c.LastName = IDENTIFIER;
		c.Phone = '000111222333';
		c.Email = 'user@domainone.com';
		insert c;
		return c;
	}
	
	public static Lead createLead()
	{
		Lead l = new Lead();
		l.LastName = IDENTIFIER;
		l.Company = IDENTIFIER;
		l.FirstName = 'First';
		l.Phone = '000111222333';
		l.Email = 'user@domainone.com';
		insert l;
		return l;
	}
	
	public static Task createTask(ID whatId)
	{
		return createTask(whatId, null);
	}
	
	public static Task createTask(ID whatId, Id whoId)
	{
		Task t = new Task();
		t.WhatId = whatId;
		t.WhoId = whoId;
		t.Subject = IDENTIFIER;
		insert t;
		return t;
	}
	
	public static Account retrieveAccount(ID accountId)
	{
		String s;
		if (UserInfo.isMultiCurrencyOrganization())
		{
			s = 'Select Name, CurrencyIsoCode';
		}
		else
		{
			s = 'Select Name';
		}
		s += ', (Select Name From Opportunities), (Select Id From ActivityHistories), (Select Id From Contacts), (Select Name From c2g__Invoices__r), (Select Id From c2g__CashEntries__r)';
		s+= ' From Account where id = :accountId';
		return (Account)Database.query(s);
	}	

	public static Opportunity retrieveOpportunity(ID opportunityId)
	{
		String s;
		if (UserInfo.isMultiCurrencyOrganization())
		{
			s = 'Select Name, CurrencyIsoCode';
		}
		else
		{
			s = 'Select Name';
		}
		s += ', (Select Id From ActivityHistories), (Select Id From OpportunityHistories), (Select Name From c2g__Invoices__r)';
		s+= ' From Opportunity where id = :opportunityId';
		return (Opportunity)Database.query(s);
	}	

	public static Task retrieveTask(ID taskId)
	{
		String s = 'Select Subject, Id, WhatId, WhoId From Task where id = :taskId';
		return (Task)Database.query(s);
	}	

}