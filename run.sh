
# COLORS

BLUE='\033[0;34m'
GREEN='\033[0;32m'
UNDERLINE='\033[4m'
RESET='\033[0m'

# ARGUMENTS

URLS_FILE=$1
DOWNLOADS_DIR=$2
ARCHIVES_DIR=$3

if [ $# -ne 3 ]; then
  echo "Usage: $0 <urls_file> <downloads_dir> <archives_dir>"
  exit 1
fi


 # DATE

get_formatted_date() {
    
    date=$(date +"%Y-%m-%dT%H:%M:%S.%3N%z")

    echo "$date"
}

echo "> Bash script starting at: $(get_formatted_date)"

# PATH

SCRIPT_PATH=$(realpath "$0")
echo "> Script full path: '$SCRIPT_PATH'"

# TEMPORARY DIRECTORY SETUP

TEMP_DIR="tmp"

if [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
fi

mkdir "$TEMP_DIR"

# READ URLS AND DOWNLOAD FILES

while IFS= read -r url || [ -n "$url" ]; do

  url=$(echo "$url" | tr -d '\r' | xargs)

  if [ -z "$url" ]; then
    continue
  fi

  echo -e "> Downloading '${BLUE}${UNDERLINE}${url}${RESET}'…"

  filename=$(basename "$url")

  #    -s : silent (pas de barre de progression)
  #    -D : dump headers (sauvegarder les headers dans un fichier)
  #    -o : output (sauvegarder le contenu dans un fichier)

    curl -s -D "$TEMP_DIR/${filename}.headers" -o "$TEMP_DIR/${filename}" "$url"

    echo -e "  ${GREEN}Done${RESET}"
  
done < "$URLS_FILE"

# COPY JSON FILES TO DOWNLOADS DIRECTORY

echo -e "> Copying JSON files from '${BLUE}${TEMP_DIR}${RESET}' to '${BLUE}${DOWNLOADS_DIR}${RESET}'…"

if [ -d "$DOWNLOADS_DIR" ]; then
    rm -rf "$DOWNLOADS_DIR"
fi

mkdir "$DOWNLOADS_DIR"

cp "$TEMP_DIR"/*.json "$DOWNLOADS_DIR/"

echo -e "  ${GREEN}Done${RESET}"

# CONCATENATE HEADERS INTO A SINGLE FILE

echo -e "> Concatenating HTTP response headers from '${BLUE}${TEMP_DIR}${RESET}' to '${BLUE}${DOWNLOADS_DIR}${RESET}'…"

> "$DOWNLOADS_DIR/headers.txt"


for header_file in "$TEMP_DIR"/*.headers; do

    header_filename=$(basename "$header_file")

    echo "### $header_filename:" >> "$DOWNLOADS_DIR/headers.txt"
    
    cat "$header_file" >> "$DOWNLOADS_DIR/headers.txt"

    echo "" >> "$DOWNLOADS_DIR/headers.txt"
    done

echo -e "  ${GREEN}Done${RESET}"

# COMPRESS DOWNLOADS DIRECTORY INTO AN ARCHIVE

echo -e "> Compressing all files in '${BLUE}${DOWNLOADS_DIR}${RESET}' to '${BLUE}${ARCHIVES_DIR}${RESET}'…"

if [ -d "$ARCHIVES_DIR" ]; then
    rm -rf "$ARCHIVES_DIR"
fi

mkdir "$ARCHIVES_DIR"

archive_name="D$(get_formatted_date | tr ':' '-').tar.gz"

#  Compresser le dossier downloads avec le maximum de compression

tar -czf "$ARCHIVES_DIR/$archive_name" -C "$DOWNLOADS_DIR" .

echo -e "  ${GREEN}Done${RESET} (archive file name: $archive_name)"

# BASH SCRIPT END
echo "> Bash script ending at: $(get_formatted_date)"
echo "Bye!"

