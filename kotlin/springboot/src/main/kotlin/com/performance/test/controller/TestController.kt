package com.performance.test.controller

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import java.time.Instant

data class TestResponse(
    val message: String,
    val timestamp: String,
    val framework: String,
    val runtime: String
)

@RestController
@RequestMapping("/api/v1")
class TestController {

    @GetMapping("/test")
    fun test(): TestResponse {
        return TestResponse(
            message = "success",
            timestamp = Instant.now().toString(),
            framework = "Spring Boot",
            runtime = "JVM (Kotlin)"
        )
    }
}
