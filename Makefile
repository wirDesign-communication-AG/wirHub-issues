init:
	COMPOSER_ALLOW_SUPERUSER=1 composer install --no-dev --optimize-autoloader
	COMPOSER_ALLOW_SUPERUSER=1 composer dump-env prod
	php bin/console doctrine:migrations:migrate --no-interaction
	php bin/console app:theme:refresh
	php bin/console app:update
ifeq ($(shell id -u), 0)
	chown -R www-data:www-data public/
	chown -R www-data:www-data var/
	chown -R www-data:www-data files/
endif

update:
	git pull
	COMPOSER_ALLOW_SUPERUSER=1 composer install --no-dev --optimize-autoloader
	COMPOSER_ALLOW_SUPERUSER=1 composer dump-env prod
	php bin/console doctrine:migrations:migrate --no-interaction
	php bin/console app:theme:refresh
	php bin/console app:update
ifeq ($(shell id -u), 0)
	chown -R www-data:www-data public/
	chown -R www-data:www-data var/
	chown -R www-data:www-data files/
endif

test:
	google-chrome --version
	chromedriver --version
	php --version
	composer --version
	APP_ENV=test php bin/console lint:twig templates/ vendor/wirdesign-communication-ag/wirhub/
	APP_ENV=test php bin/console lint:yaml config/ vendor/wirdesign-communication-ag/wirhub/Resources/config/
	APP_ENV=test php bin/console lint:container
	vendor/bin/phpstan analyse -c phpstan.neon
	APP_ENV=test php bin/console app:test
	APP_ENV=test php bin/console doctrine:database:create
	APP_ENV=test php bin/console doctrine:schema:update --force --complete
	APP_ENV=test php bin/console app:theme:refresh
	php bin/phpunit