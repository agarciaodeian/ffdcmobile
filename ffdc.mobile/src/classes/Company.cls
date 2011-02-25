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

public with sharing class Company
{
	private static Map<ID,c2g__codaCompany__c> m_currentCompanyMap;

	public static Map<ID,c2g__codaCompany__c> getCurrentCompanyMap()
	{
		if(m_currentCompanyMap == null)
		{
			m_currentCompanyMap = new Map<ID,c2g__codaCompany__c>();
			m_currentCompanyMap.putAll([select id,name from c2g__codaCompany__c where OwnerId in:getSubscribedQueueIds()]); 
		}			
		return m_currentCompanyMap;
	}
	
	private static Set<ID> getSubscribedQueueIds()
	{
		ID userId = UserInfo.getUserId();
		Set<Id> queueIds = new Set<Id>();
		for (GroupMember gm : [Select GroupId From GroupMember where Group.Type = 'Queue' and UserOrGroupId = :userId])
		{
			queueIds.add(gm.GroupId);
		}
		return queueIDs;
	}
}