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
private class ListControllerTest {

	static testMethod void getTasks()
	{
		Account a = TestHelper.createAccount();
		TestHelper.createTask(a.id);
		ListController c = new ListController(TestHelper.IDENTIFIER);
		System.assert(c.getTasks().size()>0);		
	}

	static testMethod void getTasksNullSearch()
	{
		Account a = TestHelper.createAccount();
		TestHelper.createTask(a.id);
		ListController c = new ListController(null);
		System.assert(c.getTasks().size()>0);		
	}

	static testMethod void getAccounts()
	{
		Account a = TestHelper.createAccount();
		ListController c = new ListController(TestHelper.IDENTIFIER);
		System.assert(c.getAccounts().size()>0);		
	}

	static testMethod void getAccountsNullSearch()
	{
		Account a = TestHelper.createAccount();
		ListController c = new ListController(null);
		System.assert(c.getAccounts().size()>0);		
	}

	static testMethod void getOpportunities()
	{
		Account a = TestHelper.createAccount();
		Opportunity o = TestHelper.createOpportunity(a.Id);
		ListController c = new ListController(TestHelper.IDENTIFIER);
		System.assert(c.getOpportunities().size()>0);		
	}

	static testMethod void getOpportunitiesNullSearch()
	{
		Account a = TestHelper.createAccount();
		Opportunity o = TestHelper.createOpportunity(a.Id);
		ListController c = new ListController(null);
		System.assert(c.getOpportunities().size()>0);		
	}

	static testMethod void getSize()
	{
		Account a = TestHelper.createAccount();
		ListController c = new ListController(TestHelper.IDENTIFIER);
		c.getAccounts();
		System.assert(c.getSize()>0);		
	}


}