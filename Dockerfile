# =========================
# Build image
# =========================
FROM swift:5.9-jammy as build

# Install OS Updates
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
  && apt-get -q update \
  && apt-get -q dist-upgrade -y \
  && apt-get install -y libjemalloc-dev

WORKDIR /build

# First just resolve dependencies so a layer can be cached
COPY ./Package.* ./
RUN swift package resolve --skip-update $([ -f ./Package.resolved ] && echo "--force-resolved-versions" || true)

# Copy entire repo into container
COPY . .

# Build everything in release mode
RUN swift build -c release \
  --static-swift-stdlib \
  -Xlinker -ljemalloc

WORKDIR /staging

# copy main executable to staging area
RUN cp "$(swift build --package-path /build -c release --show-bin-path)/App" ./

# copy static swift backtracer binary to staging area
RUN cp "/usr/libexec/swift/linux/swift-backtrace-static" ./

# copy resources bundled by SPM to staging area
RUN find -L "$(swift build --package-path /build -c release --show-bin-path)/" -regex '.*\.resource$' -exec cp -Ra {} ./ \;

# Copy any reosurces from the public directory and any views
RUN [ -d /build/Public ] && { mv /build/Public ./Public && chmod -R a-w ./Public; } || true
RUN [ -d /build/Resources ] && { mv /build/Resources ./Resources && chmod -R a-w ./Resources; } || true

# =========================
# Run image
# =========================

FROM ubuntu:jammy

# Update OS, install essential packages
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
  && apt-get -q update \
  && apt-get -q dist-upgrade -y \
  && apt-get install -y \
    libjemalloc2 \
    ca-certificates \
    tzdata \
    libcurl4 \
    && rm -r /var/lib/apt/lists/*

# Create vapor user and group with /app as home dir
RUN useradd --user-group --create-home --system --skel /dev/null --home-dir /app vapor
WORKDIR /app

# Copy built executable and staged resources from builder
COPY --from=build --chown=vapor:vapor /staging /app

# Copy AWS Lambda Extension
COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.8.1 /lambda-adapter /opt/extensions/lambda-adapter

# Provide configuration needed by the built-in crash reporter and sensible default behaviors
ENV SWIFT_BACKTRACE=enable=yes,sanitize=yes,threads=all,images=all,interactive=no,swift-backtrace=./swift-backtrace-static

# Ensure all further commands are run as vapor
USER vapor:vapor

EXPOSE 8080

ENTRYPOINT ["./App"]
CMD ["serve", "--env production", "--hostname", "0.0.0.0", "--port", "8080"]
