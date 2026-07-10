package com.magrathea.trustengine.apiadapter.x509;

import static io.cucumber.junit.platform.engine.Constants.FEATURES_PROPERTY_NAME;
import static io.cucumber.junit.platform.engine.Constants.FILTER_TAGS_PROPERTY_NAME;
import static io.cucumber.junit.platform.engine.Constants.GLUE_PROPERTY_NAME;
import static io.cucumber.junit.platform.engine.Constants.PLUGIN_PROPERTY_NAME;

import org.junit.platform.suite.api.ConfigurationParameter;
import org.junit.platform.suite.api.IncludeEngines;
import org.junit.platform.suite.api.Suite;

@Suite
@IncludeEngines("cucumber")
@ConfigurationParameter(key = FEATURES_PROPERTY_NAME, value = "../features/x509/certificate-profile-integrity.feature")
@ConfigurationParameter(key = GLUE_PROPERTY_NAME, value = "com.magrathea.trustengine.apiadapter.x509")
@ConfigurationParameter(key = FILTER_TAGS_PROPERTY_NAME, value = "@req-x509-profile-integrity-001")
@ConfigurationParameter(key = PLUGIN_PROPERTY_NAME, value = "pretty, summary")
public class X509CertificateProfileIntegrityCucumberTest {
}
