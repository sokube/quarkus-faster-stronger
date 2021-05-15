package org.springframework.boot.test.autoconfigure.web.servlet;

public abstract class _FactoryProvider {
  public static MockMvcPrintOnlyOnFailureTestExecutionListener mockMvcPrintOnlyOnFailureTestExecutionListener(
      ) {
    return new MockMvcPrintOnlyOnFailureTestExecutionListener();
  }

  public static WebDriverTestExecutionListener webDriverTestExecutionListener() {
    return new WebDriverTestExecutionListener();
  }

  public static WebDriverContextCustomizerFactory webDriverContextCustomizerFactory() {
    return new WebDriverContextCustomizerFactory();
  }
}
