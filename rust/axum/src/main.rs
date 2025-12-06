use axum::{routing::get, Json, Router};
use serde::Serialize;
use std::env;

#[derive(Serialize)]
struct ApiResponse {
    message: String,
    timestamp: String,
    framework: String,
    runtime: String,
}

async fn test_handler() -> Json<ApiResponse> {
    Json(ApiResponse {
        message: "success".to_string(),
        timestamp: chrono::Utc::now().to_rfc3339(),
        framework: "Axum".to_string(),
        runtime: "Rust".to_string(),
    })
}

#[tokio::main]
async fn main() {
    let port = env::var("PORT").unwrap_or_else(|_| "3201".to_string());
    let addr = format!("0.0.0.0:{}", port);

    let app = Router::new().route("/api/v1/test", get(test_handler));

    let listener = tokio::net::TcpListener::bind(&addr).await.unwrap();
    println!("Axum server running on port {}", port);
    
    axum::serve(listener, app).await.unwrap();
}
