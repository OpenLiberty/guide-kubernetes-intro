package io.openliberty.guides.ping.client;

public class UnknownUrlException extends Exception {

    private static final long serialVersionUID = 1L;

    public UnknownUrlException() {
        super();
    }

    public UnknownUrlException(String message) {
        super(message);
    }

}
