dir_file = "/etc/apache2/mods-enabled/dir.conf"

def main():
    contents = ""
    with open(dir_file, "r") as f:
        lines = f.readlines()
        for i in range(len(lines)):
            if lines[i].strip().startswith("DirectoryIndex"):
                target = lines[i]
                target = target.replace("index.html", "temp")
                target = target.replace("index.php", "index.html")
                target = target.replace("temp", "index.php")
                lines[i] = target
        contents = "".join(lines)
    
    with open(dir_file, "w") as f:
        f.write(contents)

if __name__ == "__main__":
    main()