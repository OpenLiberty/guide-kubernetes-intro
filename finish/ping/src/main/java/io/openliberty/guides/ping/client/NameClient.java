package io.openliberty.guides.ping.client;

import javax.enterprise.context.Dependent;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.ProcessingException;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import org.eclipse.microprofile.rest.client.annotation.RegisterProvider;
import org.eclipse.microprofile.rest.client.inject.RegisterRestClient;

@Dependent
@RegisterRestClient
@RegisterProvider(UnknownUrlExceptionMapper.class)
@Path("/name")
public interface NameClient {

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public String getContainerName() throws UnknownUrlException, ProcessingException;
    
}
