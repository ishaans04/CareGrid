FROM node:22-bookworm-slim AS build
WORKDIR /app
COPY caregrid_web/package.json caregrid_web/package-lock.json ./
RUN npm ci
COPY caregrid_web/firebase-auth.js caregrid_web/build.mjs ./
RUN npm run build
RUN npm prune --omit=dev

FROM node:22-bookworm-slim
ENV NODE_ENV=production
WORKDIR /app
COPY --from=build --chown=node:node /app/node_modules ./node_modules
COPY --from=build --chown=node:node /app/assets/generated ./assets/generated
COPY --chown=node:node caregrid_web/package.json caregrid_web/server.mjs caregrid_web/cloud-auth.mjs ./
COPY --chown=node:node caregrid_web/index.html caregrid_web/connected.html caregrid_web/styles.css caregrid_web/connected.css caregrid_web/app.js caregrid_web/connected.js caregrid_web/domain.mjs caregrid_web/connected-domain.mjs ./
COPY --chown=node:node caregrid_web/assets ./assets
USER node
EXPOSE 8080
CMD ["node", "server.mjs"]
