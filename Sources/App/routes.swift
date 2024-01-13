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
    
    app.get("export", "previews", ":languageCode") { req async throws -> [Components.Schemas.ProductPreview] in
        guard app.environment != .production else {
            // The export/previews route is not allowed in the production env due to the potential performance impact.
            // It exists as convenience method if one wants to transform a database dump to product previews.
            throw Abort(.forbidden)
        }
        let languageCode = req.parameters.get("languageCode")!
        return try await handler.exportProductPreviews(languageCode: languageCode)
    }
}

extension Components.Schemas.ProductPreview: Content {}
