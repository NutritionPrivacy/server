import Fluent
import Vapor
import OpenAPIVapor

func routes(_ app: Application) throws {
    // Create a VaporTransport using your application.
    let transport = VaporTransport(routesBuilder: app)


    // Create an instance of your handler type that conforms the generated protocol
    // defininig your service API.
    let handler = ProductServiceImpl(logger: app.logger,
                                     databaseProvider: app.databases)


    // Call the generated function on your implementation to add its request
    // handlers to the app.
    try handler.registerHandlers(on: transport, serverURL: Servers.server1())
}
