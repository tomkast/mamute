<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@attribute name="uri" required="true" type="java.lang.String"%>
<%@attribute name="edit" required="false" type="java.lang.String"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<fmt:message key="site.name" var="siteName"/>

<h2 class="title page-title subheader new-answer-title"><fmt:message key="newanswer.answer.your_answer"/></h2>
<c:set var="sameAuthor" value="${question.author eq currentUser.current}" />
<fmt:message key="answer.form.placeholder" var="placeholder" />
<c:if test="${sameAuthor}">
	<fmt:message key="answer.form.sameauthor.placeholder" var="placeholder" />
	<div class="hidden same-author-confirmation hinted-form answer-form">
		<button class="post-submit big-submit"><fmt:message key="newanswer.answer.add_own_answer"/></button>
	</div>
</c:if>

<form action="${uri}" method="post" class="validated-form ${not empty edit ? 'hinted-form' : '' } answer-form" data-same-author="${sameAuthor}">
	<tags:markDown placeholder="${placeholder}" value="${answer.description}" hintId="newanswer-answer-hint" htmlClass="required description-input" minlength="30"/>
	
	<c:if test='${not empty edit}'>
		<label for="comment"><fmt:message key="edit_form.comment.label" /></label>
		<input type="text" data-hint-id="answer-comment-hint" placeholder="<fmt:message key="edit_form.comment.placeholder" />" class="hintable required text-input" length="5" name="comment" />
	</c:if>
	
	<div id="newanswer-answer-hint" class="hint">
		<c:choose> 
			<c:when test='${sameAuthor}'>
				<p>
					<fmt:message key="newanswer.answer.sameauthor.hint" >
						<fmt:param value="${siteName}" />
					</fmt:message>
				</p>
			</c:when>
			<c:otherwise>
				<p>
					<fmt:message key="newanswer.answer.hint" >
						<fmt:param value="${siteName}" />
					</fmt:message>
				</p>
			</c:otherwise>
		</c:choose>
	</div>
	
	<c:if test='${not empty edit}'>
		<div id="answer-comment-hint" class="hint">
			<p><fmt:message key="edit_form.comment.hint"/></p>
		</div>
	</c:if>
	
	<input class="post-submit big-submit submit" value="<fmt:message key="newanswer.answer.submit"/>" type="submit" />
	<c:if test='${empty edit}'>
		<tags:checkbox-watch/>	
	</c:if>
	
</form>