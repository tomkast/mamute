package org.mamute.notification;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.ByteBuffer;
import java.util.Properties;

import javax.mail.MessagingException;
import javax.mail.Session;

import org.apache.commons.mail.Email;
import org.apache.commons.mail.EmailException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import br.com.caelum.vraptor.environment.Environment;
import br.com.caelum.vraptor.ioc.ApplicationScoped;
import br.com.caelum.vraptor.simplemail.Mailer;

import com.amazonaws.auth.PropertiesCredentials;
import com.amazonaws.services.simpleemail.AmazonSimpleEmailServiceClient;
import com.amazonaws.services.simpleemail.model.RawMessage;
import com.amazonaws.services.simpleemail.model.SendRawEmailRequest;
import com.amazonaws.regions.Region;
import com.amazonaws.regions.Regions;

@ApplicationScoped
public class AmazonSESMailer implements Mailer {
	private final Environment env;
	private final Session session;
	private final AmazonSimpleEmailServiceClient client;

	public AmazonSESMailer(Environment env) throws IOException {
		this.env = env;
		InputStream resource = AmazonSESMailer.class
				.getResourceAsStream("/AwsCredentials.properties");
		PropertiesCredentials credentials = new PropertiesCredentials(resource);
		this.client = new AmazonSimpleEmailServiceClient(credentials);		
        Region REGION = Region.getRegion(Regions.EU_WEST_1);
        this.client.setRegion(REGION);
        this.client.sendEmail(request); 
        
		Properties props = new Properties();
		props.setProperty("mail.transport.protocol", "aws");
		props.setProperty("mail.aws.user", credentials.getAWSAccessKeyId());
		props.setProperty("mail.aws.password", credentials.getAWSSecretKey());
		this.session = Session.getInstance(props);
	}

	private final static Logger logger = LoggerFactory
			.getLogger(AmazonSESMailer.class);
	private final static String FROM = "vraptor.simplemail.main.from";
	private final static String REPLY_TO = "vraptor.simplemail.main.replyTo";

	RawMessage mail2Content(Email email) throws IOException,
			MessagingException, EmailException {
		email.buildMimeMessage();
		ByteArrayOutputStream out = new ByteArrayOutputStream();
		email.getMimeMessage().writeTo(out);
		return new RawMessage().withData(ByteBuffer.wrap(out.toByteArray()));
	}

	public void send(Email email) throws EmailException{
		if (env.getName().equals("production")) {
			logger.info("REAL MAIL ::: {} ::: {}", email.getSubject(),
					email.getToAddresses());

			if (email.getFromAddress() == null) {
				email.setFrom(env.get(FROM));
			}
			if (env.has(REPLY_TO)) {
				email.addReplyTo(env.get(REPLY_TO));
			}

			email.setMailSession(session);

			try {
				client.sendRawEmail(new SendRawEmailRequest()
						.withRawMessage(mail2Content(email)));
			} catch (Exception e) {
				throw new EmailException(e);
			}
		} else {
			new MockMailer().send(email);
		}
	}
}
/*import java.io.IOException;

import java.util.ArrayList;
import java.util.Properties;
import java.util.Arrays;


import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import com.amazonaws.auth.PropertiesCredentials;
import com.amazonaws.services.simpleemail.AWSJavaMailTransport;
import com.amazonaws.services.simpleemail.AmazonSimpleEmailService;
import com.amazonaws.services.simpleemail.AmazonSimpleEmailServiceClient;
import com.amazonaws.services.simpleemail.model.ListVerifiedEmailAddressesResult;
import com.amazonaws.services.simpleemail.model.VerifyEmailAddressRequest;
//import com.amazonaws.services.ec2.model.Region;
import com.amazonaws.services.simpleemail.*;
import com.amazonaws.services.simpleemail.model.*;
import com.amazonaws.regions.*;

public class AmazonSESSample {
	                            
    static final String FROM = "john@myappsdomain.com";  
    static final String TO = "me@mypersonalaccount.com";                                                       // 
    static final String BODY = "This email was sent through Amazon SES by using the AWS SDK for Java.";
    static final String SUBJECT = "Amazon SES test (AWS SDK for Java)";
  

    public static void main(String[] args) throws IOException {    	
        
        // Construct an object to contain the recipient address.
        Destination destination = new Destination().withToAddresses(new String[]{TO});
        
        // Create the subject and body of the message.
        Content subject = new Content().withData(SUBJECT);
        Content textBody = new Content().withData(BODY); 
        Body body = new Body().withText(textBody);
        
        PropertiesCredentials credentials = new PropertiesCredentials(
                AmazonSESSample.class
                        .getResourceAsStream("AwsCredentials.properties"));
                
        Message message = new Message().withSubject(subject).withBody(body);
        SendEmailRequest request = new SendEmailRequest().withSource(FROM).withDestination(destination).withMessage(message);
        
        try
        {        
 
            AmazonSimpleEmailServiceClient client = new AmazonSimpleEmailServiceClient(credentials);
            Region REGION = Region.getRegion(Regions.EU_WEST_1);
            client.setRegion(REGION);
            client.sendEmail(request);  
            System.out.println("Email sent!");
        }
        catch (Exception ex) 
        {
            System.out.println("The email was not sent.");
            System.out.println("Error message: " + ex.getMessage());
        }
    }
}*/