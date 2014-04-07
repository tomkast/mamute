<fmt:message key="site.name" var="siteName" />

<fmt:message key="metas.flagged_comments.title" var="title"/>

<fmt:message key="metas.generic.title" var="genericTitle" >
	<fmt:param value="${siteName}" />
</fmt:message>

<tags:header title="${genericTitle} - ${title}"/>

<tags:moderationTabs />

<tags:flaggedQuestionsList list="${questions}" />
<tags:flaggedAnswersList list="${answers}" />
<tags:flaggedCommentsList list="${comments}" links="${commentQuestions}"/>