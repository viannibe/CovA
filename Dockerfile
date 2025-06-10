# 1) immagine base
FROM python:3.9-slim

# 2) strumenti di sistema + cleanup APT
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential \
      ca-certificates \
      wget \
      unzip \
    && rm -rf /var/lib/apt/lists/*

# 3) installa plink2 in /usr/local/bin
RUN mkdir /opt/plink2 && \
    cd /opt/plink2 && \
    wget -q https://s3.amazonaws.com/plink2-assets/plink2_linux_x86_64_20240116.zip && \
    unzip -q plink2_linux_x86_64_20240116.zip && \
    mv plink2 /usr/local/bin/ && \
    cd / && rm -rf /opt/plink2

# 4) prepara working dir
WORKDIR /app

# 5) copia e installa requirements
COPY requirements.txt .
RUN pip install --upgrade pip setuptools wheel
RUN pip install --no-cache-dir -r requirements.txt

# 6) altri pacchetti Python se servono
RUN pip install --no-cache-dir bacdiving

# 7) copia il codice
COPY . .

# 8) verifica plink2 eseguibile
RUN plink2 --version

# 9) comando di avvio
CMD ["python", "main.py"]
