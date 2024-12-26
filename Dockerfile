# Usa una imagen base de OpenJDK con soporte para Java 21
FROM eclipse-temurin:21-jdk-alpine as builder

# Establece el directorio de trabajo
WORKDIR /app

# Copia el archivo de configuración de Maven
COPY pom.xml .

# Copia los archivos de dependencias necesarios para resolverlas
RUN mkdir -p src/main && touch src/main/java/placeholder.java

# Descarga las dependencias necesarias
RUN ./mvnw dependency:go-offline -B

# Copia el código fuente del proyecto
COPY src ./src

# Compila el proyecto y genera el .jar ejecutable
RUN ./mvnw clean package -DskipTests

# Crea una nueva etapa para un entorno más pequeño
FROM eclipse-temurin:21-jre-alpine

# Establece el directorio de trabajo
WORKDIR /app

# Copia el .jar del builder
COPY --from=builder /app/target/*.jar app.jar

# Expone el puerto que usará la aplicación
EXPOSE 8080

# Comando para ejecutar la aplicación
ENTRYPOINT ["java", "-jar", "app.jar"]
