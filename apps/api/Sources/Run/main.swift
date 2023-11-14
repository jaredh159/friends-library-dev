import App
import Vapor

var env = try Vapor.Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }
try Configure.app(app)
try app.run()
