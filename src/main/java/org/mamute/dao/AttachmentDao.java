package org.mamute.dao;

import org.hibernate.Session;
import org.mamute.model.Attachment;
import org.mamute.model.Question;

import javax.inject.Inject;
import java.util.Collections;
import java.util.List;

public class AttachmentDao {

	@Inject
	private Session session;

	public void save(Attachment attachment) {
		session.save(attachment);
	}

	public List<Attachment> load(List<Long> attachmentsIds) {
		if (attachmentsIds == null) {
			return Collections.emptyList();
		}
		return session.createQuery("from Attachment where id in (:ids)")
				.setParameterList("ids", attachmentsIds)
				.list();
	}

	public void delete(Attachment attachment) {
		session.delete(attachment);
	}

	public Attachment load(Long attachmentId) {
		return (Attachment) session.get(Attachment.class, attachmentId);
	}
}
