# Temel imajı seçin
FROM ubuntu:latest

USER root

# Gerekli paketleri yükleyin
RUN apt-get update && apt-get install -y cron && apt install git -y

# Scriptinizi konteynere kopyalayın
COPY delete-branches.sh /b2m/delete-branches.sh
COPY proje_lists.txt /b2m/proje_lists.txt

# Scriptinizin çalıştırılabilir olduğundan emin olun
RUN chmod 777 /b2m/delete-branches.sh

# Cron job dosyasını oluşturun
RUN echo "*/5 * * * * root /b2m/delete-branches.sh" > /etc/cron.d/my-cron-job

# Cron job dosyasına gerekli izinleri verin
RUN chmod 0644 /etc/cron.d/my-cron-job

# Cron'u arka planda çalıştırmak için giriş noktası betiğini oluşturun
CMD cron -f
