package com.magrathea.trustengine.apiadapter.x509;

import io.cucumber.spring.CucumberContextConfiguration;
import org.springframework.context.annotation.Configuration;
import org.springframework.test.context.ContextConfiguration;

@CucumberContextConfiguration
@ContextConfiguration(classes = CucumberSpringContextConfiguration.TestConfiguration.class)
public class CucumberSpringContextConfiguration {
    @Configuration
    static class TestConfiguration {
    }
}
