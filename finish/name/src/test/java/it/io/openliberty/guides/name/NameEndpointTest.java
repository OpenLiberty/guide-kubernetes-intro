// tag::copyright[]
/*******************************************************************************
 * Copyright (c) 2018 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - Initial implementation
 *******************************************************************************/
// end::copyright[]
package it.io.openliberty.guides.name;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import java.security.KeyManagementException;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLSession;
import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.core.Response;

import org.junit.After;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

public class NameEndpointTest {

    private static String clusterUrl;

    private Client client;
    private Response response;

    @BeforeClass
    public static void oneTimeSetup() {
        String clusterIp = System.getProperty("cluster.ip");
        String nodePort = System.getProperty("name.node.port");
        clusterUrl = "http://" + clusterIp + ":" + nodePort + "/api/name/";
    }
    
    @Before
    public void setup() {
        response = null;
        client = ClientBuilder.newBuilder()
                    .hostnameVerifier(new HostnameVerifier() { public boolean verify(String hostname, SSLSession session) { return true; } })
                    .build();
    }

    @After
    public void teardown() {
        response.close();
        client.close();
    }
    
    @Test
    public void testContainerNameNotNull() {
        response = this.getResponse(clusterUrl);
        this.assertResponse(clusterUrl, response);
        String greeting = response.readEntity(String.class);
        
        String containerName = greeting.substring(greeting.lastIndexOf(" ") + 1);
        containerName = (containerName.equals("null")) ? null : containerName;
        assertNotNull("Container name should not be null but it was. The service is robably not running inside a container", containerName);
    }

    /**
     * <p>
     * Returns response information from the specified URL.
     * </p>
     * 
     * @param url
     *          - target URL.
     * @return Response object with the response from the specified URL.
     */
    private Response getResponse(String url) {
        return client.target(url).request().get();
    }

    /**
     * <p>
     * Asserts that the given URL has the correct response code of 200.
     * </p>
     * 
     * @param url
     *          - target URL.
     * @param response
     *          - response received from the target URL.
     */
    private void assertResponse(String url, Response response) {
        assertEquals("Incorrect response code from " + url, 200, response.getStatus());
    }

}
