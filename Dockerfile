FROM python:3.14-slim

# ffmpeg plays the audio file, libopus encodes it for Discord voice
RUN apt-get update \
    && apt-get install -y --no-install-recommends ffmpeg libopus0 \
    && rm -rf /var/lib/apt/lists/*

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY crazyfrog_bot/ crazyfrog_bot/

RUN useradd --create-home --uid 1000 crazyfrog && chown crazyfrog:crazyfrog /app
USER crazyfrog

# settings.conf, audios/ and images/ are mounted at runtime; the token comes from the environment
CMD ["python", "crazyfrog_bot"]
