package org.springframework.boot.autoconfigure.jdbc;

public abstract class _FactoryProvider {
  public static DataSourceBeanCreationFailureAnalyzer dataSourceBeanCreationFailureAnalyzer() {
    return new DataSourceBeanCreationFailureAnalyzer();
  }

  public static HikariDriverConfigurationFailureAnalyzer hikariDriverConfigurationFailureAnalyzer(
      ) {
    return new HikariDriverConfigurationFailureAnalyzer();
  }
}
