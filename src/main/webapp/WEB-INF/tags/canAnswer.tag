<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>

<%@attribute name="uri" required="true" type="java.lang.String"%>
<%@attribute name="question" required="true" type="org.mamute.model.Question"%>

<c:set var="user" value="${currentUser.current}"/>
<c:set var="isAuthor" value="${question.author eq user}"/>

<c:choose>
	<c:when test="${currentUser.loggedIn && isAuthor}">
		<c:if test="${user.hasKarmaToAnswerOwn(question) && !question.alreadyAnsweredBy(user)}">
			<tags:answerForm uri="${uri}" />		
		</c:if>
		<c:if test="${!user.hasKarmaToAnswerOwn(question) && question.alreadyAnsweredBy(user)}">
			<div class="message alert already-answered">
				${t['answer.errors.already_answered']}
			</div>
		</c:if>
		<c:if test="${!user.hasKarmaToAnswerOwn(question) && !question.alreadyAnsweredBy(user)}">
			<div class="message alert not-enough-karma">
				${t['answer.errors.not_enough_karma'].args(linkTo[NavigationController].about, linkTo[QuestionController].newQuestion)}
			</div>
		</c:if>
	</c:when>
	
	<c:when test="${currentUser.loggedIn && !isAuthor}">
		<c:if test="${!question.alreadyAnsweredBy(user)}">
			<tags:answerForm uri="${uri}" />
		</c:if>
		<c:if test="${question.alreadyAnsweredBy(user)}">
			<div class="message alert already-answered">
				${t['answer.errors.already_answered']}
			</div>
		</c:if>
	</c:when>
</c:choose>