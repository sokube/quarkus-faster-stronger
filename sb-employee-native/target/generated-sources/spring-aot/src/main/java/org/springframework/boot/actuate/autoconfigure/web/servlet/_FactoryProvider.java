package org.springframework.boot.actuate.autoconfigure.web.servlet;

public abstract class _FactoryProvider {
  public static ServletManagementChildContextConfiguration servletManagementChildContextConfiguration(
      ) {
    return new ServletManagementChildContextConfiguration();
  }

  public static WebMvcEndpointChildContextConfiguration webMvcEndpointChildContextConfiguration() {
    return new WebMvcEndpointChildContextConfiguration();
  }
}
