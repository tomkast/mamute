<#assign questionStyle = 'padding:10px; border-bottom: 1px dotted #ccc;'>
<#assign linkStyle = 'text-decoration: none; color: rgb(0, 119, 204);'>
<#assign titleStyle = 'margin: 15px 0; padding: 0 10px;'>
<#assign mainTitleStyle = 'margin: 0 0 0 20px; vertical-align: bottom; display: inline-block;'>
<#assign tagStyle = 'text-decoration: none; background-color: #f8f8f8; border: 1px solid #adc2d0; color: #3e6d8e; display: inline-block; font-size: .9em; padding: 0 .4em; line-height: 1.45em; border-radius: 5px;'>
<#assign userNameStyle = 'font-size: 0.8em; float: right;'>
<#assign userImgStyle = 'width: 18px; height: 18px;'>

<html>
<body style="font-family:arial, sans-serif; font-size:12px;">
	<table width="600" align="center">
		<tr>
	        <td style="border-bottom: 1px solid #222; padding-bottom: 10px">
	        	<img src="http://www.guj.com.br/imgs/guj-mail-logo.png">
	        	<h1 style="${mainTitleStyle}">${l10n.getMessage("newsletter_mail")}</h1>
        	</td>
		</tr>
	
		<tr>
			<td><h2 style="${titleStyle}">${l10n.getMessage("newsletter_mail.title.week_main_questions")}</h2></td>
		</tr>
		
		<#list hotQuestions as question>
			<tr>
				<td style="${questionStyle}">
					<h3><a style="${linkStyle}" href="${linkToHelper.questionLink(question)}">${question.title}</a></h3>
					<p>
	                    <#list question.getTags() as tag>
							<span><a style="${tagStyle}" href="${linkToHelper.tagLink(tag)}">${tag.name}</a></span>
						</#list>
						<span style="${userNameStyle}">${l10n.getMessage("newsletter_mail.asked_by")} <a style="${linkStyle}" href="${linkToHelper.userLink(question.author)}">${question.author.name}</a></span>
					</p>
				</td>
			</tr>
		</#list>
		<tr>
			<td><h2 style="${titleStyle}">${l10n.getMessage("newsletter_mail.title.unanswered_questions")}</h2></td>
		</tr>
		<#list unansweredQuestions as question>
			<tr>
				<td style="${questionStyle}">
					<h3><a style="${linkStyle}" href="${linkToHelper.questionLink(question)}">${question.title}</a></h3>
					<p>
	                    <#list question.getTags() as tag>
							<span><a style="${tagStyle}" href="${linkToHelper.tagLink(tag)}">${tag.name}</a></span>
						</#list>
						<span style="${userNameStyle}">${l10n.getMessage("newsletter_mail.asked_by")}  <a style="${linkStyle}" href="${linkToHelper.userLink(question.author)}">${question.author.name}</a></span>
					</p>
				</td>
			</tr>
		</#list>
		<tr>
			<td><a href="${unsubscribeLink}" style="display:block; color: #aaa; font-size: 10px;text-decoration:none; text-align: right; margin-top: 5em;">${l10n.getMessage("newsletter_mail.unsubscribe")}</a></td>
		<tr>
	</table>
</body>
</html>
