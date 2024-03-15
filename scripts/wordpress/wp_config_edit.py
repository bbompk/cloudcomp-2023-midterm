import sys

conf_path = "/var/www/html/wp-config.php"

if __name__ == '__main__':
    if len(sys.argv) < 5:
        print("Usage: python3 wp_config_edit.py <db_host> <db_name> <db_user> <db_pass>")
        sys.exit(1)
    contents = open(conf_path).read()
    contents = contents.replace('\'DB_NAME\', \'database_name_here\'', f'\'DB_NAME\', \'{sys.argv[2]}\'')
    contents = contents.replace('\'DB_USER\', \'username_here\'', f'\'DB_USER\', \'{sys.argv[3]}\'')
    contents = contents.replace('\'DB_PASSWORD\', \'password_here\'', f'\'DB_PASSWORD\', \'{sys.argv[4]}\'')
    contents = contents.replace('\'DB_HOST\', \'localhost\'', f'\'DB_HOST\', \'{sys.argv[1]}\'')

    with open(conf_path, 'w') as f:
        f.write(contents)

