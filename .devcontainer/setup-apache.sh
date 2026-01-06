
#!/usr/bin/env bash
set -euo pipefail

# Update and install Apache + PHP (incl. SQLite)
sudo apt-get update
sudo apt-get install -y \
  apache2 libapache2-mod-php php-cli \
  php-mbstring php-zip php-curl php-xml php-intl php-gd php-sqlite3

# Symlink workspace to Apache docroot
sudo rm -rf /var/www/html || true
sudo ln -s "$PWD" /var/www/html

# Move Apache from 80 -> 8080
sudo sed -i 's/^Listen 80$/Listen 8080/' /etc/apache2/ports.conf
sudo sed -i 's/<VirtualHost \*:80>/<VirtualHost \*:8080>/' /etc/apache2/sites-enabled/000-default.conf

# Avoid FQDN warnings
if ! grep -q '^ServerName 127.0.0.1$' /etc/apache2/apache2.conf; then
  echo 'ServerName 127.0.0.1' | sudo tee -a /etc/apache2/apache2.conf >/dev/null
fi

# Start Apache (non-fatal if already started)
sudo service apache2 start || true

# Install MDK (moodle-sdk) for the vscode user
pip install --user moodle-sdk || true
echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bashrc
