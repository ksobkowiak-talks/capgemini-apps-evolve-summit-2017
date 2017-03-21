package com.capgemini.demos.k8s.ipclient;

import java.net.InetAddress;
import java.net.UnknownHostException;

import com.netflix.hystrix.contrib.javanica.annotation.HystrixCommand;
import com.netflix.hystrix.contrib.javanica.annotation.HystrixProperty;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
class IPAddressController {
    private int counter;

    @RequestMapping(value = "/ip", method = RequestMethod.GET)
    @HystrixCommand(fallbackMethod = "localIP")
    public IPAddress ipaddress() throws Exception {
        RestTemplate template = new RestTemplate();
        return template.getForEntity("http://ipservice/ip", IPAddress.class).getBody();
    }

    public IPAddress localIP() throws UnknownHostException {
        return new IPAddress(++counter, InetAddress.getLocalHost().getHostAddress(),
                "This is a local response");
    }
}
