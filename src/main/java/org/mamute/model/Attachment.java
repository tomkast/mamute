package org.mamute.model;

import br.com.caelum.vraptor.observer.upload.UploadedFile;
import org.hibernate.annotations.Type;
import org.joda.time.DateTime;
import org.mamute.providers.SessionFactoryCreator;

import javax.persistence.*;

@Entity
public class Attachment {

	@GeneratedValue
	@Id
	private Long id;

	@ManyToOne
	private Question question;

	@Transient
	private UploadedFile file;

	@Type(type = SessionFactoryCreator.JODA_TIME_TYPE)
	private final DateTime createdAt = new DateTime();

	@ManyToOne
	private User owner;

	private String ip;

	private String mime;

	private String name;

	/**
	 * @deprecated hibernate only
	 */
	Attachment() {
	}

	public Attachment(UploadedFile file, User owner, String ip) {
		this.file = file;
		this.owner = owner;
		this.ip = ip;
		this.mime = file.getContentType();
		this.name =file.getFileName();
	}

	public UploadedFile getUploadedFile() {
		return file;
	}

	public Long getId() {
		return id;
	}

	public void setQuestion(Question question) {
		this.question = question;
	}

	public String fileName() {
		return id.toString();
	}

	public String getMime() {
		return mime;
	}
}
