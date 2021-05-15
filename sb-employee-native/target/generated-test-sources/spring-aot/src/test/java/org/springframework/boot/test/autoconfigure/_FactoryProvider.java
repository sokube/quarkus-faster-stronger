package org.springframework.boot.test.autoconfigure;

public abstract class _FactoryProvider {
  public static OverrideAutoConfigurationContextCustomizerFactory overrideAutoConfigurationContextCustomizerFactory(
      ) {
    return new OverrideAutoConfigurationContextCustomizerFactory();
  }

  public static SpringBootDependencyInjectionTestExecutionListener.PostProcessor springBootDependencyInjectionTestExecutionListenerPostProcessor(
      ) {
    return new SpringBootDependencyInjectionTestExecutionListener.PostProcessor();
  }
}
