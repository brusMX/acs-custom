package com.azure.training.eurekaClient;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@EnableEurekaClient
public class EurekaClientApplication {

	public static void main(String[] args) {
		SpringApplication.run(EurekaClientApplication.class, args);
	}

	@RestController
	@RefreshScope
	@RequestMapping("/client1")
	public class HelloResource {

		@Value("${welcome.message:hello default}")
		private String value;

		@Value("${message:hello v1}")
		private String value1;

		@RequestMapping(method = RequestMethod.GET, value = "/v2")
		// @RequestMapping
		public String hello() {
			return value;
		}

		@RequestMapping(method = RequestMethod.GET)
		// @RequestMapping
		public String hello2() {
			return value;
		}

		@GetMapping("/v1")
		public String hello1() {
			return value1;
		}
	}
}
