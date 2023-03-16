# Build image
FROM ghcr.io/empiricaly/empirica:build-249 AS builder

COPY . /build

# install server dependencies
WORKDIR /build/server
RUN empirica npm install

# install client dependencies
WORKDIR /build/client
RUN empirica npm install

# Bundle the app
WORKDIR /build
RUN empirica bundle



# Final image
FROM ghcr.io/empiricaly/empirica:build-249

# Copy Volta binaries so it doesn't happen at every start.
COPY --from=builder /root/.local/share/empirica/volta /root/.local/share/empirica/volta

# copy the built experiment from the builder container
COPY --from=builder /build/deliberation.tar.zst /app/deliberation.tar.zst
