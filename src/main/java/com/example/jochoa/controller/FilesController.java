package com.example.jochoa.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

@RestController
@RequestMapping("/api/files")
public class FilesController {

    @PostMapping(consumes = "multipart/form-data")
    public ResponseEntity<String> handleFileUpload(
            @RequestParam("fileName") String name,
            @RequestParam("size") Long size,
            @RequestParam("file") MultipartFile file) {
        try {
            // Información del archivo
            String filename = file.getOriginalFilename();
            String contentType = file.getContentType();
            byte[] fileContent = file.getBytes();

            // Procesar la lógica de negocio
            System.out.println("Name: " + name);
            System.out.println("Size: " + size);
            System.out.println("Filename: " + filename);
            System.out.println("Content-Type: " + contentType);
            System.out.println("File Content (Base64): " + new String(fileContent));

            return ResponseEntity.ok("File uploaded successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("File upload failed!");
        }
    }

        @PostMapping(value="/octet", consumes = "application/octet-stream")
    public ResponseEntity<String> uploadFile(@RequestBody byte[] fileBytes) {
        String tempFileName = "uploaded-file";
        File tempFile = new File(System.getProperty("java.io.tmpdir"), tempFileName);
            System.out.println("------>llegue");

            try (FileOutputStream fos = new FileOutputStream(tempFile)) {
            fos.write(fileBytes);
            return ResponseEntity.ok("File uploaded successfully to: " + tempFile.getAbsolutePath());
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to save file: " + e.getMessage());
        }
    }
}
