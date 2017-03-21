#!/usr/bin/env bash

echo 'spring.application.name=ipservice' > src/main/resources/application.properties
echo 'ipservice.message=Hello from IDE' >> src/main/resources/application.properties
echo 'spring.cloud.kubernetes.reload.enabled=true' >> src/main/resources/application.properties
echo 'spring.cloud.kubernetes.reload.mode=event' >> src/main/resources/application.properties

#rm -fr src/test/
mkdir target

echo "manually add the spring-cloud deps:"
cat << EOF

properties
===========
<spring-cloud.version>Brixton.SR7</spring-cloud.version>
<spring-cloud-kubernetes.version>0.1.6</spring-cloud-kubernetes.version>

dependency management
=====================
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-dependencies</artifactId>
    <version>\${spring-cloud.version}</version>
    <type>pom</type>
    <scope>import</scope>
</dependency>


dependencies
=============
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-context</artifactId>
</dependency>
<dependency>
    <groupId>io.fabric8</groupId>
    <artifactId>spring-cloud-starter-kubernetes</artifactId>
    <version>\${spring-cloud-kubernetes.version}</version>
</dependency>
EOF

cat <<EOF > src/main/java/com/capgemini/demos/k8s/ipservice/IPAddressController.java
package com.capgemini.demos.k8s.ipservice;

import java.net.InetAddress;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
class IPAddressController {
    private int counter;

    @Autowired
    private Config config;

    @RequestMapping(value = "/ip", method = RequestMethod.GET)
    public IPAddress ipaddress() throws Exception {
        return new IPAddress(++counter, InetAddress.getLocalHost().getHostAddress(), config.getMessage());
    }
}
EOF

cat <<EOF > src/main/java/com/capgemini/demos/k8s/ipservice/Config.java
package com.capgemini.demos.k8s.ipservice;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Configuration
@ConfigurationProperties(prefix = "ipservice")
public class Config {
    private String message;

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

}
EOF


cat <<EOF > src/main/java/com/capgemini/demos/k8s/ipservice/HomeController.java
package com.capgemini.demos.k8s.ipservice;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
class HomeController {

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String home() throws Exception {
        return "It works!!!!!!!!";
    }
}
EOF

cat <<EOF > src/main/java/com/capgemini/demos/k8s/ipservice/IPAddress.java
package com.capgemini.demos.k8s.ipservice;

class IPAddress {
    private final long id;
    private final String ipAddress;
    private String message;

    public IPAddress(long id, String ipAddress, String message) {
        this.id = id;
        this.ipAddress = ipAddress;
        this.message = message;
    }

    public long getId() {
        return id;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public String getMessage() {
        return message;
    }
}
EOF

cat <<EOF > ipserviceConfigMap.yml
kind: ConfigMap
apiVersion: v1
metadata:
  name: ipservice
data:
  application.yaml: |-
    ipservice:
      message: hello, spring cloud kubernetes from Wroclaw!
EOF