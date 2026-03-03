#!/bin/sh

# Ждем, пока база данных будет готова
echo "Waiting for database to be ready..."
while ! nc -z db 5432; do
  sleep 0.1
done
echo "Database is ready!"

# Ждем, пока Redis будет готов
echo "Waiting for Redis to be ready..."
while ! nc -z redis 6379; do
  sleep 0.1
done
echo "Redis is ready!"

# Применяем миграции
python manage.py migrate --noinput

# Собираем статические файлы (если нужно)
python manage.py collectstatic --noinput

exec "$@"