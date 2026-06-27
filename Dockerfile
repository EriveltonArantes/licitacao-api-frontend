FROM node:20-alpine AS build
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
RUN sed -i 's/listen\s*80;/listen ${PORT:-8080};/' /etc/nginx/conf.d/default.conf || true
EXPOSE 8080
CMD ["sh", "-c", "sed -i \"s/listen .*/listen ${PORT:-8080};/\" /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"]
