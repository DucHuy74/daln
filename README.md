# NCKH_1_2025_2026_NGUYEN_HUY_QUAN

## IEEE TEMPLATE 

conference /original research template

## Spring boot

https://github.com/spring-guides/gs-serving-web-content

## Test

### Install KeyCloak on Docker

`docker pull quay.io/keycloak/keycloak:25.0.0`

Run keyCloak on port 8180

`docker run -d --name keycloak-25.0.0 -p 8180:8080 -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=admin quay.io/keycloak/keycloak:25.0.0 start-dev`

`docker run -d --name neo4j -p 7474:7474 -p 7687:7687 -e NEO4J_AUTH=neo4j/12345678 neo4j:5`
