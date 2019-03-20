package hello;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class DataController {

    private static final String template = "Hello, %s!";

    @RequestMapping("/greeting")
    public Data greeting(@RequestParam(value = "name", defaultValue = "World") String name) {
        return new Data(String.format(template, name));
    }
}
