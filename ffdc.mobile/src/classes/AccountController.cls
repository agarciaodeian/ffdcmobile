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

public with sharing class AccountController
{
    private ApexPages.StandardController m_stdController;
    private Account m_account;
	List<AccountBalance> m_accountBalances;
	AccountBalance m_totalAccountBalance;

	public Static String TLI_ACCOUNT_LINE = 'Account';
	public Static String TLI_MATCHED = 'Matched';
   
    public AccountController(ApexPages.StandardController stdController) 
    {
          m_stdController = stdController;
          m_account = (Account) stdController.getRecord();
    }

    // Constructor used for unit tests only
    public AccountController(List<AccountBalance> accountBalances) 
    {
		m_accountBalances = accountBalances;
    }

	public PageReference save()
	{
		m_stdController.save();
        return null;
    }

    public Boolean getHasOpportunities()
    {
    	return m_account.Opportunities.size() > 0;
    }

	public Boolean getHasSalesInvoices()
	{
    	return m_account.c2g__Invoices__r.size() > 0;
	}

    public Boolean getHasActivityHistories()
    {
    	return m_account.ActivityHistories.size() > 0;
    }

    public Boolean getHasContacts()
    {
    	return m_account.Contacts.size() > 0;
    }

    public Boolean getHasCashEntries()
    {
    	return m_account.c2g__CashEntries__r.size() > 0;
    }

	public Boolean getHasAccountBalances()
	{
		return getAccountBalances().size()>0;
	}
	
	public List<AccountBalance> getAccountBalances()
	{
		if(m_accountBalances==null)
		{
			loadAccountBalances();
		}
		return m_accountBalances;
	}
	
	private void loadAccountBalances()
	{
		m_accountBalances = new List<AccountBalance>();
		Set<ID> coIDs = Company.getCurrentCompanyMap().keySet();
		List<AggregateResult> items = [SELECT sum(c2g__AccountOutstandingValue__c) val, 
			c2g__Transaction__r.c2g__OwnerCompany__r.Name comp,
			c2g__AccountCurrency__r.Name accCurr 
			FROM c2g__codaTransactionLineItem__c 
			Where c2g__Account__c = :m_account.id 
			and c2g__LineType__c = :TLI_ACCOUNT_LINE 
			and c2g__MatchingStatus__c <> :TLI_MATCHED 
			and c2g__Transaction__r.c2g__OwnerCompany__r.ID in:coIDs
			group by c2g__Transaction__r.c2g__OwnerCompany__r.Name,
			c2g__AccountCurrency__r.Name];
		for(AggregateResult item : items)
		{
			AccountBalance ab = new AccountBalance();
			ab.Company = (String) item.get('comp');
			ab.CurrencyIsoCode = (String) item.get('accCurr');
			ab.Balance = (Double) item.get('val');
			m_accountBalances.add(ab);
		}			
	}

	public Boolean getHasTotalAccountBalance()
	{
		return getTotalAccountBalance().Balance!=null;
	}
	
	public AccountBalance getTotalAccountBalance()
	{
		if(m_totalAccountBalance==null)
		{
			m_totalAccountBalance = calculateTotalAccountBalance();
		}
		return m_totalAccountBalance;
	}
	
	private AccountBalance calculateTotalAccountBalance()
	{
		List<AccountBalance> balances = getAccountBalances();
		if(balances.size()==0)
		{
			return new AccountBalance();
		}
		Decimal total = 0;
		for(AccountBalance balance : balances)
		{
			if(balance.CurrencyIsoCode != balances[0].CurrencyIsoCode)
			{
				return new AccountBalance();
			}
			total += balance.Balance;
		}
		AccountBalance result = new AccountBalance();
		result.Company = Label.AccountBalanceTotal;
		result.CurrencyIsoCode = balances[0].CurrencyIsoCode;
		result.Balance = total;
		return result;
	}

	public class AccountBalance
	{
		// Transient dto to facilitate outputField binding for balance 
		public c2g__codaTransactionLineItem__c dto { get; set; }  

		public String Company { get; set; }

		public String CurrencyIsoCode { get; set; }

		// c2g__AccountOutstandingValue__c is the field aggregated for the account balance
		public double Balance
		{
			get
			{
				return dto==null ? null : dto.c2g__AccountOutstandingValue__c;
			} 
			set
			{
				if(dto==null) dto = new c2g__codaTransactionLineItem__c();
				dto.c2g__AccountOutstandingValue__c = value;
			}
		}

		public void AccountBalance()
		{
			dto = new c2g__codaTransactionLineItem__c();
		}
	}
	
	public String getCurrencyIsoCode()
	{
		String result = '';
		if (UserInfo.isMultiCurrencyOrganization())
		{
			SObject so = (SObject)m_account;
			result = (String)so.get('CurrencyIsoCode');
		}
		return result;
	}
}