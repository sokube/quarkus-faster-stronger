#!/bin/sh
export PG_IP=$(nslookup postgres | grep Address | cut -d ' ' -f2 | grep -v Address)
echo "postgres ip is $PG_IP"
./application -Dquarkus.http.host=0.0.0.0 -Dquarkus.datasource.jdbc.url=jdbc:postgresql://$PG_IP:5432/postgres
