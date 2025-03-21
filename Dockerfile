FROM python:3.12-slim-bookworm AS builder

# install nodejs 20.x
RUN apt update && apt install -y \
    curl \
    gnupg \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# install dependencies for playwright
RUN apt update && apt install -y \
    libnss3 \
    libnspr4 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libdbus-1-3 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libasound2 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libxcursor1 \
    libgtk-3-0 \
    fonts-noto-color-emoji \
    fonts-noto-cjk \
    && rm -rf /var/lib/apt/lists/*

# install supergateway
RUN npm install -g supergateway

# set working directory
WORKDIR /app

# copy mcp-browser-use source
COPY . /app/

# install uv
RUN pip install uv

# # install playwright and browser
# RUN pip install playwright && \
#     python -m playwright install chromium && \
#     python -m playwright install-deps chromium

# RUN uv sync

# expose port
EXPOSE 8000

# copy start.sh
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# set entrypoint
ENTRYPOINT ["/app/start.sh"] 