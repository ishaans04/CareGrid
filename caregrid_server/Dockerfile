# Build from the project root with:
# docker build -f caregrid_server/Dockerfile .

# Build stage
FROM dart:3.12.2 AS build

# Create a minimal workspace that preserves locked server dependency versions.
WORKDIR /app
COPY pubspec.lock .
COPY caregrid_server caregrid_server
RUN printf '%s\n' \
  'name: _' \
  'environment:' \
  '  sdk: ^3.12.2' \
  'workspace:' \
  '  - caregrid_server' \
  > pubspec.yaml
RUN dart pub get

# Compile the server executable.
WORKDIR /app/caregrid_server
RUN dart build cli --target bin/main.dart --output build
RUN mv build/bundle/bin/main build/bundle/bin/server

# Add a fallback for the copy of possibly missing directories.
RUN mkdir -p config web migrations

# Dart's /runtime contains the Linux runtime libraries used by its executable.
# A scratch image avoids mixing the Debian-built binary with Alpine's musl.
FROM scratch
WORKDIR /app
ENV CAREGRID_PROCESS_ROLE=api

# Copy runtime dependencies
COPY --from=build /runtime/ /

# Copy compiled server executable and native libraries
COPY --from=build /app/caregrid_server/build/bundle/ ./

# Copy configuration files and resources
COPY --from=build /app/caregrid_server/config/production.yaml config/production.yaml
COPY --from=build /app/caregrid_server/web/ web/
COPY --from=build /app/caregrid_server/migrations/ migrations/

# This file is required to enable the endpoint log filter in Insights.
COPY --from=build /app/caregrid_server/lib/src/generated/protocol.yaml lib/src/generated/protocol.yaml

USER 10001:10001
EXPOSE 8080
# Exec form forwards SIGTERM to Serverpod. Override args for a migration job.
ENTRYPOINT ["./bin/server"]
CMD ["--mode=production", "--logging=normal"]
