package io.openliberty.guides.ping;

import java.net.MalformedURLException;
import java.net.URL;
import java.net.UnknownHostException;

import javax.enterprise.context.RequestScoped;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.ProcessingException;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.apache.commons.lang3.exception.ExceptionUtils;

import org.eclipse.microprofile.rest.client.RestClientBuilder;

import io.openliberty.guides.ping.client.NameClient;
import io.openliberty.guides.ping.client.UnknownUrlException;

@RequestScoped
@Path("")
public class PingResource {

    @GET
    @Path("/{hostname}")
    @Produces(MediaType.TEXT_PLAIN)
    public String getContainerName(@PathParam("hostname") String host) {
        try {
            NameClient nameClient = RestClientBuilder.newBuilder()
                            .baseUrl(new URL("http://" + host + ":9080/api"))
                            .register(UnknownUrlException.class)
                            .build(NameClient.class);
            nameClient.getContainerName();
            return "pong";
        } catch (ProcessingException ex) {
            // Checking if UnknownHostException is nested inside and rethrowing if not.
            Throwable rootEx = ExceptionUtils.getRootCause(ex);
            if (rootEx != null && rootEx instanceof UnknownHostException) {
                System.err.println("The specified host is unknown");
                ex.printStackTrace();
            } else {
                throw ex;
            }
        } catch (UnknownUrlException ex) {
            System.err.println("The given URL is unreachable");
            ex.printStackTrace();
        } catch (MalformedURLException ex) {
            System.err.println("The given URL is not formatted correctly.");
            ex.printStackTrace();
        }
        return "Bad response from " + host + "\nCheck the console log for more info.";
    }
    
}
