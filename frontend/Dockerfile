# Etapa 1: Build da aplicação Flutter
FROM debian:bullseye AS build

# Instalar dependências necessárias
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Instalar Flutter
RUN git clone https://github.com/flutter/flutter.git -b stable /flutter
ENV PATH="/flutter/bin:${PATH}"

# Configurar Flutter
RUN flutter doctor -v
RUN flutter config --enable-web

WORKDIR /app
COPY . .

# Build da aplicação
RUN flutter pub get
RUN flutter build web --release

# Etapa 2: Servir com Nginx
FROM nginx:stable-alpine
COPY --from=build /app/build/web /usr/share/nginx/html

# Configuração opcional do Nginx para SPA
RUN echo 'server { \
    listen 80; \
    location / { \
        root /usr/share/nginx/html; \
        index index.html; \
        try_files $uri $uri/ /index.html; \
    } \
}' > /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]