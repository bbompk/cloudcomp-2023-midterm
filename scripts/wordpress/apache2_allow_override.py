conf_file = "/etc/apache2/sites-enabled/000-default.conf"

def main():
    contents = ""
    addedContents = [
        "    <Directory /var/www/html>\n",
        "        AllowOverride All\n",
        "    </Directory>\n"
    ]
    with open(conf_file, "r") as f:
        lines = f.readlines()
        contents = lines[0] + "".join(addedContents) + "".join(lines[1:])
    
    with open(conf_file, "w") as f:
        f.write(contents)

if __name__ == "__main__":
    main()