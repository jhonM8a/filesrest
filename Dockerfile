# Usa una imagen base con Maven y JDK
FROM maven:3.9.5-eclipse-temurin-21 as builder

# Establece el directorio de trabajo
WORKDIR /app

# Copia el archivo POM y las dependencias necesarias
COPY pom.xml .

# Descarga las dependencias
RUN mvn dependency:go-offline -B

# Copia el código fuente del proyecto
COPY src ./src

# Construye el .jar ejecutable
RUN mvn clean package -DskipTests

# Usa una imagen JRE más ligera para la ejecución
FROM eclipse-temurin:21-jre-alpine

# Establece el directorio de trabajo
WORKDIR /app

# Copia el .jar del builder
COPY --from=builder /app/target/*.jar app.jar

# Expone el puerto que usará la aplicación
EXPOSE 8080

# Comando para ejecutar la aplicación
ENTRYPOINT ["java", "-jar", "app.jar"]
