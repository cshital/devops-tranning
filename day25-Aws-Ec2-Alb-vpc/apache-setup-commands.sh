#!/bin/bash

# Update package lists
sudo apt-get update

# Install Apache
sudo apt-get install apache2 -y

# Create a directory for the website
sudo mkdir -p /var/www/html/web

# Create the index.html file
cat <<EOL | sudo tee /var/www/html/web/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to Application 2</title>
    <style>
    body {
        background: black;
        font-family: Arial, sans-serif;
        text-align: center;
        font-size: 40px;
    }

    h1 {
        padding-top: 100px;
        color: white;
    }

    p {
        color: yellow;
    }

    .container {
        max-width: 800px;
        margin: 0 auto;
        padding: 20px;
        text-align: center;
    }
    </style>
</head>
<body>
    <center>
        <h1>Application 2 Deployed!</h1>
        <p>Page from application 2</p>
    </center>
</body>
</html>
EOL

# Update Apache configuration file
cd /etc/apache2/sites-available
sudo cp 000-default.conf web.conf
sudo sed -i 's|/var/www/html|/var/www/html/web|g' web.conf

# Disable the default site and enable the new site
sudo a2dissite 000-default.conf
sudo a2ensite web.conf

# Restart Apache to apply changes
sudo service apache2 restart

echo "Apache has been installed and configured successfully."
