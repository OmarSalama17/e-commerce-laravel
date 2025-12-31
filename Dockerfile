# هنستخدم نسخة PHP 8.2 مع سيرفر Apache (الأشهر والأسهل)
FROM php:8.2-apache

# 1. تسطيب تعريفات الداتابيز (PostgreSQL) وأدوات فك الضغط
RUN apt-get update && apt-get install -y \
    libpq-dev \
    unzip \
    git \
    && docker-php-ext-install pdo pdo_pgsql

# 2. تفعيل مود Rewrite عشان راوتس Laravel تشتغل صح
RUN a2enmod rewrite

# 3. توجيه السيرفر لفولدر public مباشرة (مهم جداً)
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# 4. نقل ملفات مشروعك جوه السيرفر
COPY . /var/www/html

# 5. تسطيب Composer (مدير الحزم)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 6. تحميل مكتبات Laravel (من غير ملفات الـ dev عشان المساحة)
RUN composer install --no-dev --optimize-autoloader

# 7. إعطاء صلاحيات الكتابة لفولدرات التخزين (عشان اللوجز والصور)
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# 8. فتح بورت 80 للسيرفر
EXPOSE 80
