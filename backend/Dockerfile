# Etapa 1: Build
FROM dart:3.4 AS build
WORKDIR /app

# Copiar apenas pubspec primeiro para aproveitar cache do Docker
COPY pubspec.* ./
RUN dart pub get

# Copiar o restante do código
COPY . .

# Etapa 2: Execução
FROM dart:3.4
WORKDIR /app

# Copiar o código da aplicação
COPY --from=build /app /app

# Copiar as dependências do pub cache
COPY --from=build /root/.pub-cache /root/.pub-cache

# Garantir que as dependências estejam disponíveis
RUN dart pub get

EXPOSE 8080
CMD ["dart", "run", "bin/server.dart"]