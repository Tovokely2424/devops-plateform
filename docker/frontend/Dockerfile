# ==========================================
# Development
# ==========================================
FROM node:20-alpine AS development

WORKDIR /app

COPY app/frontend/package*.json ./

RUN npm install

COPY app/frontend .

EXPOSE 5173

CMD ["npm", "run", "dev", "--", "--host"]


# ==========================================
# Builder
# ==========================================
FROM node:20-alpine AS builder

WORKDIR /app

COPY app/frontend/package*.json ./

RUN npm ci

COPY app/frontend .

RUN npm run build


# ==========================================
# Production
# ==========================================
FROM nginx:alpine AS production

COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]