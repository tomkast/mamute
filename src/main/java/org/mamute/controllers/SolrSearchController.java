package org.mamute.controllers;

import java.util.List;

import javax.inject.Inject;

import org.mamute.dao.QuestionDAO;
import org.mamute.environment.EnvironmentDependent;
import org.mamute.model.Question;
import org.mamute.model.SanitizedText;
import org.mamute.search.QuestionIndex;

import br.com.caelum.vraptor.Controller;
import br.com.caelum.vraptor.Get;
import br.com.caelum.vraptor.Result;

@Controller
@EnvironmentDependent(supports = "feature.solr")
public class SolrSearchController {

	@Inject	private Result result;
	@Inject private QuestionIndex index;
	@Inject private QuestionDAO questions;

	@Get("/search")
	public void search(SanitizedText query) {
		result.include("query", query.getText());
		result.include("results", doSearch(query, 10));
	}

	@Get("/questionSuggestion")
	public void questionSuggestion(SanitizedText query, int limit) {
		result.forwardTo(BrutalTemplatesController.class).questionSuggestion(query, doSearch(query, limit));
	}

	private List<Question> doSearch(SanitizedText query, int limit) {
		List<Long> ids = index.findQuestionsByTitle(query.getText(), limit);
		return questions.getByIds(ids);
	}
}
