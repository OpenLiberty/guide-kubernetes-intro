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

import java.security.KeyManagementException;
import java.security.NoSuchAlgorithmException;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import java.security.cert.X509Certificate;
import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.core.Response;

import org.junit.After;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

public class PingEndpointTest {

    private static String clusterUrl;
    private static String nameKubeService;
    private static SSLContext sc;

    private Client client;
    private Response response;

    @BeforeClass
    public static void oneTimeSetup() {
        String clusterIp = System.getProperty("cluster.ip");
        String ingressPath = System.getProperty("ping.ingress.path");
        String nodePort = System.getProperty("ping.node.port");
        
        nameKubeService = System.getProperty("name.kube.service");
        
        if (nodePort.isEmpty() || nodePort == null) {
            clusterUrl = "https://" + clusterIp + ingressPath + "/";
        } else {
            clusterUrl = "http://" + clusterIp + ":" + nodePort + "/api/ping/";
        }
        
        // Ignore certificate
        TrustManager[] tm = new TrustManager[] { new X509TrustManager() {
            public X509Certificate[] getAcceptedIssuers() { return null; }
            public void checkClientTrusted(X509Certificate[] certs, String authType) {}
            public void checkServerTrusted(X509Certificate[] certs, String authType) {}
        }};
        try {
            sc = SSLContext.getInstance("SSL");
            sc.init(null, tm, null);
        } catch (NoSuchAlgorithmException | KeyManagementException e) {
            System.err.println(e.getMessage());
            e.printStackTrace();
        }
    }
    
    @Before
    public void setup() {
        response = null;
        client = ClientBuilder.newBuilder()
                    .sslContext(sc)
                    .hostnameVerifier(new HostnameVerifier() { public boolean verify(String hostname, SSLSession session) { return true; } })
                    .build();
    }

    @After
    public void teardown() {
        response.close();
        client.close();
    }
    
    @Test
    public void testPingValidService() {
        response = this.getResponse(clusterUrl + nameKubeService);
        this.assertResponse(clusterUrl, response);
        
        String expected = "pong";
        String actual = response.readEntity(String.class);
        assertEquals("Should have receieved pong", expected, actual);
    }
    
    @Test
    public void testPingInvalidService() {
        String invalidServiceName = "donkey-pong";
        response = this.getResponse(clusterUrl + invalidServiceName);
        this.assertResponse(clusterUrl, response);
        
        String expected = "Bad response from " + invalidServiceName + "\nCheck the console log for more info.";
        String actual = response.readEntity(String.class);
        assertEquals("Should have received a bad response from " + invalidServiceName + ", but didn't. Is " + invalidServiceName + " a running Kuberentes service?", expected, actual);
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
