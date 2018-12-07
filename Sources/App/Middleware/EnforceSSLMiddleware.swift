import Vapor

struct EnforceSSLMiddleware : Middleware, ServiceType {
    
    static func makeService(for worker: Container) throws -> EnforceSSLMiddleware {
        return try EnforceSSLMiddleware(logger: worker.make())
    }
    
    private let logger: Logger
    
    init(logger: Logger) {
        self.logger = logger
    }
    
    func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
        guard request.environment == Environment.production else {
            return try next.respond(to: request)
        }
        
        let logger = try request.sharedContainer.make(Logger.self)
        
        let headers = request.http.headers

        // Heroku's router will add this header, which will include the original request's protocol (http or https)
        let scheme = headers.firstValue(name: HTTPHeaderName("X-Forwarded-Proto"))
            ?? request.http.url.scheme
            ?? "http"

        guard scheme == "https" else {
            guard let host = headers.firstValue(name: .host) else {
                throw Abort(.badRequest)
            }
            var components = URLComponents(url: request.http.url, resolvingAgainstBaseURL: true)
            components?.scheme = "https"
            
            if host.contains(":") {
                let parts = host.split(separator: ":")
                components?.host = String(parts.first!)
                if let port = parts.last.flatMap({ String($0) }).flatMap(Int.init) {
                    components?.port = port
                }
            } else {
                components?.host = host
            }
            
            guard let httpsURL = components?.url else {
                logger.error("Unable to construct HTTPS URL out of components: scheme: \(scheme)  host: \(host)  original url: \(request.http.url)")
                throw Abort(.internalServerError)
            }

            logger.info("Redirecting to HTTPS: \(httpsURL)")
            return request.future(
                request.redirect(to: httpsURL.absoluteString, type: .permanent)
            )
        }
        
        return try next.respond(to: request)
    }
}
