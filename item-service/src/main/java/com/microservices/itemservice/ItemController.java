package com.microservices.itemservice;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/items")
public class ItemController {

    private List<Map<String, Object>> items = new ArrayList<>();
    private int idCounter = 1;

    public ItemController() {
        // Initialize with sample items
        items.add(createItem(idCounter++, "Book"));
        items.add(createItem(idCounter++, "Laptop"));
        items.add(createItem(idCounter++, "Phone"));
    }

    private Map<String, Object> createItem(int id, String name) {
        Map<String, Object> item = new HashMap<>();
        item.put("id", id);
        item.put("name", name);
        return item;
    }

    @GetMapping
    public List<Map<String, Object>> getItems() {
        return items;
    }

    @PostMapping
    public ResponseEntity<Map<String, Object>> addItem(@RequestBody Map<String, Object> item) {
        item.put("id", idCounter++);
        items.add(item);
        return ResponseEntity.status(HttpStatus.CREATED).body(item);
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getItem(@PathVariable int id) {
        return items.stream()
                .filter(i -> i.get("id").equals(id))
                .findFirst()
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
}
