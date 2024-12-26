# Usa Maven para compilar
FROM maven:3.9.5-eclipse-temurin-21 as builder

WORKDIR /app

# Copia el archivo POM y las dependencias
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copia el código fuente
COPY src ./src

# Compila el proyecto
RUN mvn clean package -DskipTests

# Usa una imagen JRE más ligera
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Copia el .jar y el keystore al contenedor
COPY --from=builder /app/target/*.jar app.jar
COPY keystore.p12 keystore.p12

# Exponer el puerto HTTPS
EXPOSE 8443

# Comando para ejecutar la aplicación
ENTRYPOINT ["java", "-jar", "app.jar"]
