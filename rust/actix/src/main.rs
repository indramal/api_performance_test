use actix_web::{get, web, App, HttpResponse, HttpServer, Responder};
use serde::Serialize;
use std::env;

#[derive(Serialize)]
struct ApiResponse {
    message: String,
    timestamp: String,
    framework: String,
    runtime: String,
}

#[get("/api/v1/test")]
async fn test_handler() -> impl Responder {
    let response = ApiResponse {
        message: "success".to_string(),
        timestamp: chrono::Utc::now().to_rfc3339(),
        framework: "Actix-web".to_string(),
        runtime: "Rust".to_string(),
    };
    HttpResponse::Ok().json(response)
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let port = env::var("PORT").unwrap_or_else(|_| "3202".to_string());
    let addr = format!("0.0.0.0:{}", port);

    println!("Actix-web server running on port {}", port);

    HttpServer::new(|| App::new().service(test_handler))
        .bind(&addr)?
        .run()
        .await
}
