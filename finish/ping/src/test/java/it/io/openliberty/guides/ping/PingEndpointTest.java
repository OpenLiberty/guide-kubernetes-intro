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
package it.io.openliberty.guides.ping;

import static org.junit.Assert.assertEquals;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.core.Response;

import org.junit.After;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

public class PingEndpointTest {

    private static String ingressUrl;

    private Client client;

    @BeforeClass
    public static void oneTimeSetup() {
        String clusterIp = (System.getProperty("cluster.ip") == null) ? "192.168.99.100" : System.getProperty("cluster.ip");
        String ingressPath = (System.getProperty("ping.ingress.path") == null) ? "/name/" : System.getProperty("ping.ingress.path");
        String nodePort = System.getProperty("ping.service.port");
        if (nodePort != null) {
            ingressUrl = "http://" + clusterIp + ":" + nodePort + "/api/ping/";
        } else {
            ingressUrl = "https://" + clusterIp + "/" + ingressPath + "/";
        }
    }

    @Before
    public void setup() {
        client = ClientBuilder.newClient();
    }

    @After
    public void teardown() {
        client.close();
    }
    
//    @Test
//    public void testResponseOk() {
//        Response r = this.getResponse(ingressUrl);
//        this.assertResponse(ingressUrl, r);
//        System.out.println(r.getHeaders());
//    }

//    public void testEmptyInventory() {
//        Response response = this.getResponse(invUrl + INVENTORY_SYSTEMS);
//        this.assertResponse(invUrl, response);
//
//        JsonObject obj = response.readEntity(JsonObject.class);
//
//        int expected = 0;
//        int actual = obj.getInt("total");
//        assertEquals("The inventory should be empty on application start but it wasn't", 
//                     expected, actual);
//
//        response.close();
//    }

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
