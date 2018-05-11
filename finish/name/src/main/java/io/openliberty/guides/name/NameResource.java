package io.openliberty.guides.name;

import javax.enterprise.context.RequestScoped;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@RequestScoped
@Path("/")
public class NameResource {

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public String getContainerName() {
        return "Hello! I'm container " + System.getenv("HOSTNAME");
    }
    
}
