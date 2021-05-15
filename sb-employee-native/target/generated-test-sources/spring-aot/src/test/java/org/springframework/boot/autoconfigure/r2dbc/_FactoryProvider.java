package org.springframework.boot.autoconfigure.r2dbc;

public abstract class _FactoryProvider {
  public static ConnectionFactoryBeanCreationFailureAnalyzer connectionFactoryBeanCreationFailureAnalyzer(
      ) {
    return new ConnectionFactoryBeanCreationFailureAnalyzer();
  }
}
