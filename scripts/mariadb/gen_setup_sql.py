import sys

def main():
    db_name = "wordpress_db"
    db_user = "wordpress_user"
    db_pass = "admin"
    
    for i in range(1, len(sys.argv), 2):
        if i < len(sys.argv) - 1:
            if sys.argv[i] == "-n":
                db_name = sys.argv[i + 1]
            elif sys.argv[i] == "-u":
                db_user = sys.argv[i + 1]
            elif sys.argv[i] == "-p":
                db_pass = sys.argv[i + 1]
            else:
                print(f"Invalid argument: {sys.argv[i]}")
                sys.exit(1)

    with open("mariadb_wp_setup.sql", "w") as f:
        f.write(f"CREATE USER '{db_user}'@'localhost' IDENTIFIED BY '{db_pass}';\n")
        f.write(f"CREATE DATABASE `{db_name}`;\n")
        f.write(f"GRANT ALL PRIVILEGES ON `{db_name}`.* TO '{db_user}'@'localhost';\n")
        f.write(f"CREATE USER '{db_user}'@'%' IDENTIFIED BY '{db_pass}';\n")
        f.write(f"GRANT ALL PRIVILEGES ON `{db_name}`.* TO '{db_user}'@'%';\n")
        f.write("FLUSH PRIVILEGES;\n")

if __name__ == "__main__":
    main()