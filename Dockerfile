FROM eclipse-temurin:17-jdk-alpine

#2 working dir for appp

WORKDIR /app

#3 copy code from HOST to Container

COPY src/Main.java /app/Main.java

COPY quotes.txt quotes.txt

RUN javac Main.java

EXPOSE 8000

CMD ["java","Main"]
