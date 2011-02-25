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

private class AccountControllerTest
{
    static testMethod void save() 
    {
		Account a = TestHelper.createAccount();
		a = TestHelper.retrieveAccount(a.Id);
		ApexPages.StandardController sc = new ApexPages.StandardController(a);
		AccountController c = new AccountController(sc);
		a = (Account) sc.getRecord();
		a.Name = 'AccountControllerTestModified';
		PageReference pr = c.save();
		System.assertEquals(null,pr);
		a = TestHelper.retrieveAccount(a.Id);
		System.assertEquals(a.Name,'AccountControllerTestModified');
    }

	static testMethod void getHasOpportunitiesFalse()
	{
		Account a = TestHelper.createAccount();
		a = TestHelper.retrieveAccount(a.Id);
		ApexPages.StandardController sc = new ApexPages.StandardController(a);
		AccountController c = new AccountController(sc);
		System.assert(!c.getHasOpportunities());
	}

	static testMethod void getHasOpportunitiesTrue()
	{
		Account a = TestHelper.createAccount();
		TestHelper.createOpportunity(a.Id);
		a = TestHelper.retrieveAccount(a.Id);
		ApexPages.StandardController sc = new ApexPages.StandardController(a);
		AccountController c = new AccountController(sc);
		System.assert(c.getHasOpportunities());
	}

	static testMethod void getHasActivityHistoriesFalse()
	{
		Account a = TestHelper.createAccount();
		a = TestHelper.retrieveAccount(a.Id);
		ApexPages.StandardController sc = new ApexPages.StandardController(a);
		AccountController c = new AccountController(sc);
		System.assert(!c.getHasActivityHistories());
	}

	static testMethod void getHasActivityHistoriesTrue()
	{
		Account a = TestHelper.createAccount();
		TestHelper.createActivityHistory(a.Id);
		a = TestHelper.retrieveAccount(a.Id);
		ApexPages.StandardController sc = new ApexPages.StandardController(a);
		AccountController c = new AccountController(sc);
		System.assert(c.getHasActivityHistories());
	}

	static testMethod void getHasContactsFalse()
	{
		Account a = TestHelper.createAccount();
		a = TestHelper.retrieveAccount(a.Id);
		ApexPages.StandardController sc = new ApexPages.StandardController(a);
		AccountController c = new AccountController(sc);
		System.assert(!c.getHasContacts());
	}

	static testMethod void getHasContactsTrue()
	{
		Account a = TestHelper.createAccount();
		TestHelper.createContact(a.Id);
		a = TestHelper.retrieveAccount(a.Id);
		ApexPages.StandardController sc = new ApexPages.StandardController(a);
		AccountController c = new AccountController(sc);
		System.assert(c.getHasContacts());
	}

	static testMethod void getHasSalesInvoicesFalse()
	{
		Account a = TestHelper.createAccount();
		a = TestHelper.retrieveAccount(a.Id);
		ApexPages.StandardController sc = new ApexPages.StandardController(a);
		AccountController c = new AccountController(sc);
		System.assert(!c.getHasSalesInvoices());
	}

	static testMethod void getHasCashEntriesFalse()
	{
		Account a = TestHelper.createAccount();
		a = TestHelper.retrieveAccount(a.Id);
		ApexPages.StandardController sc = new ApexPages.StandardController(a);
		AccountController c = new AccountController(sc);
		System.assert(!c.getHasCashEntries());
	}

	static testMethod void getHasAccountBalances()
	{
		Account a = TestHelper.createAccount();
		a = TestHelper.retrieveAccount(a.Id);
		ApexPages.StandardController sc = new ApexPages.StandardController(a);
		AccountController c = new AccountController(sc);
		System.assert(!c.getHasAccountBalances());
	}

	static testMethod void getHasTotalAccountBalance()
	{
		Account a = TestHelper.createAccount();
		a = TestHelper.retrieveAccount(a.Id);
		ApexPages.StandardController sc = new ApexPages.StandardController(a);
		AccountController c = new AccountController(sc);
		System.assert(!c.getHasTotalAccountBalance());
	}

	static testMethod void getCurrencyIsoCode()
	{
		Account a = TestHelper.createAccount();
		a = TestHelper.retrieveAccount(a.Id);
		ApexPages.StandardController sc = new ApexPages.StandardController(a);
		AccountController c = new AccountController(sc);
		if (UserInfo.isMultiCurrencyOrganization())
		{
			SObject so = (SObject)a;
			System.assertEquals((String)so.get('CurrencyIsoCode'),c.getCurrencyIsoCode());
		}
		else
		{
			System.assertEquals('',c.getCurrencyIsoCode());
		}
	}
	
	static testMethod void AccountBalanceNull()
	{
		AccountController.AccountBalance ab = new AccountController.AccountBalance();
		System.assertEquals(null, ab.dto);
		System.assertEquals(null, ab.Company);
		System.assertEquals(null, ab.CurrencyIsoCode);
		System.assertEquals(null, ab.Balance);
	}

	static testMethod void AccountBalanceAccessors()
	{
		AccountController.AccountBalance ab = new AccountController.AccountBalance();
		ab.Company = 'MyCo';
		ab.CurrencyIsoCode = 'ZZZ';
		ab.Balance=1250.00;
		System.assertEquals('MyCo', ab.Company);
		System.assertEquals('ZZZ', ab.CurrencyIsoCode);
		System.assertEquals(1250.00, ab.Balance);
	}

	static testMethod void AccountBalanceAccessorsDto()
	{
		AccountController.AccountBalance ab = new AccountController.AccountBalance();
		ab.Balance=123;
		System.assertEquals(123, ab.dto.c2g__AccountOutstandingValue__c);
		ab.dto.c2g__AccountOutstandingValue__c = 456;
		System.assertEquals(456, ab.Balance);
	}

	static testMethod void getTotalAccountBalance()
	{
		AccountController c = new AccountController(new List<AccountController.AccountBalance>());
		AccountController.AccountBalance ab;
		
		Double total = 0;
		Double value;
		String curr = 'USD';
		
		value = 1000;
		ab = new AccountController.AccountBalance();
		ab.Company = 'Co1';
		ab.CurrencyIsoCode = curr;
		ab.Balance = value;
		total += value;
		c.getAccountBalances().add(ab);
		 
		value = 123;
		ab = new AccountController.AccountBalance();
		ab.Company = 'Co2';
		ab.CurrencyIsoCode = curr;
		ab.Balance = value;
		total += value;
		c.getAccountBalances().add(ab);
		
		System.assert(c.getHasTotalAccountBalance());
		System.assertEquals(Label.AccountBalanceTotal,c.getTotalAccountBalance().Company);
		System.assertEquals('USD',c.getTotalAccountBalance().CurrencyIsoCode);
		System.assertEquals(total,c.getTotalAccountBalance().Balance);
	}

	static testMethod void getTotalAccountBalanceMixedCurrency()
	{
		AccountController c = new AccountController(new List<AccountController.AccountBalance>());
		AccountController.AccountBalance ab;
		
		Double value;
		String curr1 = 'USD';
		String curr2 = 'GBP';
		
		value = 1000;
		ab = new AccountController.AccountBalance();
		ab.Company = 'Co1';
		ab.CurrencyIsoCode = curr1;
		ab.Balance = value;
		c.getAccountBalances().add(ab);
		 
		value = 123;
		ab = new AccountController.AccountBalance();
		ab.Company = 'Co2';
		ab.CurrencyIsoCode = curr2;
		ab.Balance = value;
		c.getAccountBalances().add(ab);
		
		System.assert(!c.getHasTotalAccountBalance());
	}
}