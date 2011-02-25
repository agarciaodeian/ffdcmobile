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

@isTest

private class TaskControllerTest {

    static testMethod void save() 
    {
		Account a = TestHelper.createAccount();
		a = TestHelper.retrieveAccount(a.Id);
		Task t = TestHelper.createTask(a.Id);
		ApexPages.StandardController sc = new ApexPages.StandardController(t);
		TaskController c = new TaskController(sc);
		t = (Task) sc.getRecord();
		t.Subject = 'TaskControllerTestModified';
		PageReference pr = c.save();
		System.assertEquals(null,pr);
		t = TestHelper.retrieveTask(t.Id);
		System.assertEquals(t.Subject,'TaskControllerTestModified');
    }

	static testMethod void getIsRelatedToAccountTrue()
	{
		Account a = TestHelper.createAccount();
		Task t = TestHelper.createTask(a.id);
		t = TestHelper.retrieveTask(t.id);
		ApexPages.StandardController sc = new ApexPages.StandardController(t);
		TaskController c = new TaskController(sc);
		System.assert(c.getIsRelatedToAccount());
	}

	static testMethod void getIsRelatedToAccountFalse()
	{
		Account a = TestHelper.createAccount();
		Opportunity o = TestHelper.createOpportunity(a.Id);
		Task t = TestHelper.createTask(o.id);
		t = TestHelper.retrieveTask(t.id);
		ApexPages.StandardController sc = new ApexPages.StandardController(t);
		TaskController c = new TaskController(sc);
		System.assert(!c.getIsRelatedToAccount());
	}

	static testMethod void getIsRelatedToOpportunityTrue()
	{
		Account a = TestHelper.createAccount();
		Opportunity o = TestHelper.createOpportunity(a.Id);
		Task t = TestHelper.createTask(o.id);
		t = TestHelper.retrieveTask(t.id);
		ApexPages.StandardController sc = new ApexPages.StandardController(t);
		TaskController c = new TaskController(sc);
		System.assert(c.getIsRelatedToOpportunity());
	}

	static testMethod void getIsRelatedToOpportunityFalse()
	{
		Account a = TestHelper.createAccount();
		Task t = TestHelper.createTask(a.id);
		t = TestHelper.retrieveTask(t.id);
		ApexPages.StandardController sc = new ApexPages.StandardController(t);
		TaskController c = new TaskController(sc);
		System.assert(!c.getIsRelatedToOpportunity());
	}

	static testMethod void getIsRelatedToSalesInvoiceFalse()
	{
		Account a = TestHelper.createAccount();
		Task t = TestHelper.createTask(a.id);
		t = TestHelper.retrieveTask(t.id);
		ApexPages.StandardController sc = new ApexPages.StandardController(t);
		TaskController c = new TaskController(sc);
		System.assert(!c.getIsRelatedToSalesInvoice());
	}

	static testMethod void getIsRelatedToUnsupportedFalse()
	{
		Account a = TestHelper.createAccount();
		Opportunity o = TestHelper.createOpportunity(a.Id);
		Task t;
		ApexPages.StandardController sc;
		TaskController c;
		
		t = TestHelper.createTask(a.id);
		t = TestHelper.retrieveTask(t.id);
		sc = new ApexPages.StandardController(t);
		c = new TaskController(sc);
		System.assert(!c.getIsRelatedToUnsupported());

		t = TestHelper.createTask(o.id);
		t = TestHelper.retrieveTask(t.id);
		sc = new ApexPages.StandardController(t);
		c = new TaskController(sc);
		System.assert(!c.getIsRelatedToUnsupported());
	}

	static testMethod void getPhone_Contact()
	{
		Account a = TestHelper.createAccount();
		Contact who = TestHelper.createContact(a.id);
		Task t = TestHelper.createTask(a.id, who.id);
		t = TestHelper.retrieveTask(t.id);
		ApexPages.StandardController sc = new ApexPages.StandardController(t);
		TaskController c = new TaskController(sc);
		System.assertEquals(who.Phone,c.getPhone());
	}

	static testMethod void getEmail_Contact()
	{
		Account a = TestHelper.createAccount();
		Contact who = TestHelper.createContact(a.id);
		Task t = TestHelper.createTask(a.id, who.id);
		t = TestHelper.retrieveTask(t.id);
		ApexPages.StandardController sc = new ApexPages.StandardController(t);
		TaskController c = new TaskController(sc);
		System.assertEquals(who.Email,c.getEmail());
	}

	static testMethod void getPhone_Lead()
	{
		Lead who = TestHelper.createLead();
		Task t = TestHelper.createTask(null, who.id);
		t = TestHelper.retrieveTask(t.id);
		ApexPages.StandardController sc = new ApexPages.StandardController(t);
		TaskController c = new TaskController(sc);
		System.assertEquals(who.Phone,c.getPhone());
	}

	static testMethod void getEmail_Lead()
	{
		Lead who = TestHelper.createLead();
		Task t = TestHelper.createTask(null, who.id);
		t = TestHelper.retrieveTask(t.id);
		ApexPages.StandardController sc = new ApexPages.StandardController(t);
		TaskController c = new TaskController(sc);
		System.assertEquals(who.Email,c.getEmail());
	}

}