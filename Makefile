init:
	COMPOSER_ALLOW_SUPERUSER=1 composer install --no-dev
	COMPOSER_ALLOW_SUPERUSER=1 composer dump-env prod
	COMPOSER_ALLOW_SUPERUSER=1 composer dump-autoload --no-dev --classmap-authoritative
	php bin/console doctrine:migrations:migrate --no-interaction
	php bin/console app:theme:refresh
	php bin/console app:update
	php bin/console app:theme:refresh

ifeq ($(shell id -u), 0)
	chown -R www-data:www-data public/
	chown -R www-data:www-data var/
	chown -R www-data:www-data files/
endif

dkim:
	openssl genrsa -out secret/dkim.pem 2048;
	@echo '';
	@echo -n 'wirhub._domainkey.domain.de. 86400 IN TXT v=DKIM1; k=rsa; p=';
	@openssl rsa -in secret/dkim.pem -pubout -outform der 2>/dev/null | openssl base64 -A;
	@echo '';

update:
	git pull
	COMPOSER_ALLOW_SUPERUSER=1 composer dump-env prod
	COMPOSER_ALLOW_SUPERUSER=1 composer install --no-dev --optimize-autoloader
	php bin/console doctrine:migrations:migrate --no-interaction
	php bin/console app:update
	php bin/console app:theme:refresh
ifeq ($(shell id -u), 0)
	chown -R www-data:www-data public/
	chown -R www-data:www-data var/
	chown -R www-data:www-data files/
endif

test:
	@echo "--------------------------------------"
	@echo "---------- Lint validation -----------"
	@echo "--------------------------------------"
	APP_ENV=test php bin/console lint:twig templates/ vendor/wirdesign-communication-ag/wirhub/
	APP_ENV=test php bin/console lint:yaml config/ vendor/wirdesign-communication-ag/wirhub/Resources/config/
	APP_ENV=test php bin/console lint:container
	@echo ""
	@echo ""
	@echo "--------------------------------------"
	@echo "-------------- PHPStan ---------------"
	@echo "--------------------------------------"
	vendor/bin/phpstan analyse -c phpstan.neon
	@echo ""
	@echo ""
	@echo "--------------------------------------"
	@echo "--------- Custom validation ----------"
	@echo "--------------------------------------"
	APP_ENV=test php bin/console app:test
	@echo ""
	@echo ""
	@echo "--------------------------------------"
	@echo "----------- Create theme -------------"
	@echo "--------------------------------------"
	APP_ENV=test php bin/console app:theme:refresh
	@echo ""
	@echo ""
	@echo "--------------------------------------"
	@echo "------------- PHPUnit ----------------"
	@echo "--------------------------------------"
	php bin/phpunit -c phpunit.xml.dist $(TARGET)
