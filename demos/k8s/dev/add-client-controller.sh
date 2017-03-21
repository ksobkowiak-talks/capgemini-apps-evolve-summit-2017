#!/usr/bin/env bash

echo 'spring.application.name=ipclient' > src/main/resources/application.properties

#rm -fr src/test/
mkdir target


cat <<EOF > src/main/java/com/capgemini/demos/k8s/ipclient/IPAddressController.java
package com.capgemini.demos.k8s.ipclient;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
class IPAddressController {
    private int counter;

    private RestTemplate template = new RestTemplate();

    @RequestMapping(value = "/ip", method = RequestMethod.GET)
    public IPAddress ipaddress() throws Exception {
        RestTemplate template = new RestTemplate();
        return template.getForEntity("http://ipservice/ip", IPAddress.class).getBody();
    }
}
EOF

cat <<EOF > src/main/java/com/capgemini/demos/k8s/ipclient/HomeController.java
package com.capgemini.demos.k8s.ipclient;

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

cat <<EOF > src/main/java/com/capgemini/demos/k8s/ipclient/IPAddress.java
package com.capgemini.demos.k8s.ipclient;

class IPAddress {
    private long id;
    private String ipAddress;
    private String message;

    public IPAddress() {
    }

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