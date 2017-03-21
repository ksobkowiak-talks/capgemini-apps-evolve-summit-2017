#!/usr/bin/env bash

awk '/<properties>/{x++} x==1{sub(/<properties>/,"&\n    <spring-cloud.version>Brixton.SR7</spring-cloud.version> \
<spring-cloud-kubernetes.version>0.1.6</spring-cloud-kubernetes.version>")}1' pom.xml > tmp && mv tmp pom.xml

awk '/<dependencies>/{x++} x==1{sub(/<dependencies>/,"&\n   \
<dependency>\
    <groupId>org.springframework.cloud</groupId>\
    <artifactId>spring-cloud-starter-hystrix</artifactId>\
</dependency>\
		")}1' pom.xml > tmp && mv tmp pom.xml

awk '/<\/properties>/{x++} x==1{sub(/<\/properties>/,"&\n\n <dependencyManagement> \
<dependencies> \
<dependency> \
    <groupId>org.springframework.cloud</groupId> \
    <artifactId>spring-cloud-dependencies</artifactId> \
    <version>\${spring-cloud.version}</version> \
    <type>pom</type> \
    <scope>import</scope> \
  </dependency> \
  </dependencies>\
</dependencyManagement>")}1' pom.xml > tmp && mv tmp pom.xml