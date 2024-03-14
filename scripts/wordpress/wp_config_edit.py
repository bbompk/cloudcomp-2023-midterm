import sys

if __name__ == '__main__':
    fpath = 'wordpress/wp-config.php'
    contents = open(fpath).read()
    contents = contents.replace('\'DB_NAME\', \'database_name_here\'', '\'DB_NAME\', \'wordpress-db\'')
    contents = contents.replace('\'DB_USER\', \'username_here\'', '\'DB_USER\', \'wordpress-user\'')
    contents = contents.replace('\'DB_PASSWORD\', \'password_here\'', '\'DB_PASSWORD\', \'admin\'')
    contents = contents.replace('\'DB_HOST\', \'localhost\'', f'\'DB_HOST\', \'{sys.argv[1]}\'')

    with open(fpath, 'w') as f:
        f.write(contents)

