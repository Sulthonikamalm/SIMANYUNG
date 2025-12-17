package com.mycompany.manyung.resources;

import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.core.Response;

/**
 * Jakarta EE 10 Resource for Manyung Application
 * 
 * @author Manyung Team
 */
@Path("jakartaee10")
public class JakartaEE10Resource {

    @GET
    public Response ping() {
        return Response
                .ok("ping Jakarta EE - Manyung")
                .build();
    }
}
