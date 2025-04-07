FROM python:3.12-alpine3.19

# Install dependencies
RUN apk add --no-cache \
      xvfb \
      nss \
      freetype \
      freetype-dev \
      harfbuzz \
      ca-certificates \
      ttf-freefont \
      chromium \
      chromium-chromedriver

WORKDIR /app
COPY potoken-generator.py requirements.txt ./
COPY potoken_generator/ ./potoken_generator/

RUN pip install --no-cache-dir -r requirements.txt

COPY docker/scripts/startup.sh ./

RUN sed -i 's/await self.sleep(0.5)/await self.sleep(2)/' /usr/local/lib/python3.12/site-packages/nodriver/core/browser.py

COPY docker/scripts/startup-webserver.sh ./

# Run
CMD [ "./startup-webserver.sh"]
