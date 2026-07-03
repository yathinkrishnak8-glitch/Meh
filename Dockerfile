# Use a stable, lightweight Debian base
FROM debian:bookworm-slim

# Prevent interactive prompts during apt installations
ENV DEBIAN_FRONTEND=noninteractive

# Install all necessary dependencies for the virtual display, browser, and VNC server
RUN apt-get update && apt-get install -y \
    xvfb \
    x11vnc \
    chromium \
    novnc \
    websockify \
    fluxbox \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Hugging Face strictly requires the app to run on a non-root user (UID 1000)
RUN useradd -m -u 1000 user
ENV HOME=/home/user
WORKDIR $HOME

# Copy the startup script into the container and set execution permissions
COPY --chown=user:user startup.sh $HOME/startup.sh
RUN chmod +x $HOME/startup.sh

# Switch to the required non-root user
USER user

# Expose port 7860 (Hugging Face Default)
EXPOSE 7860

# Run the startup script
CMD ["./startup.sh"]
