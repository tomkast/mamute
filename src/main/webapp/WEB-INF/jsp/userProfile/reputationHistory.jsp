<fmt:message key="metas.profile.title" var="title"/>
<fmt:message key="site.name" var="siteName" />

<fmt:message key="metas.generic.title" var="genericTitle" >
	<fmt:param value="${siteName}" />
</fmt:message>

<tags:header title="${genericTitle} - ${title}"/>

<tags:userProfileTab active="reputation">
<h2 class="title page-title"><span class="grey-text">${selectedUser.karma}</span> <span class="highlight"><fmt:message key="user_profile.reputation" /></span></h2>
<section class="advanced-user-data user-data">
	<ul class="karma-history">
		<c:forEach var="historyItem" items="${reputationHistory}">
			<tags:reputationHistoryItem historyItem="${historyItem}">
				<span class="event-time"><tags:prettyTime time="${historyItem.date}"/></span>
			</tags:reputationHistoryItem>
		</c:forEach>
	</ul>
</section>
</tags:userProfileTab>