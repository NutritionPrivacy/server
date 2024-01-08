import NIOSSL
import Fluent
import FluentPostgresDriver
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    // uncomment to use in memory SQLite database
    //  if app.environment == .testing {
    //    app.databases.use(.sqlite(.memory), as: .sqlite)
    //  } else {
    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST")!,
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME")!,
        password: Environment.get("DATABASE_PASSWORD")!,
        database: Environment.get("DATABASE_NAME")!,
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)

    app.migrations.add(CreateProduct())
    app.migrations.add(CreateProductNutriments())
    app.migrations.add(CreateProductName())
    app.migrations.add(CreateProductBrand())
    app.migrations.add(CreateProductServing())
    try await app.autoMigrate()

    // register routes
    try routes(app)
}
