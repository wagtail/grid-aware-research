SRC_DIR="./wagtail_org" # Source folder
DST_DIR="./wagtail_org/wagtail-cleaned" # Destination folder

# Copy everything first
rsync -a "$SRC_DIR"/ "$DST_DIR"/

# Process only HTML files in destination
find "$DST_DIR" -type f -name '*.html' | while read -r FILE; do
  perl -0777 -pe '
    # Remove scripts except ones containing "critical" in src
    s#<script\b(?!(?=[^>]+critical))[^>]*>.*?</script>##sig;

    # Remove iframe, video, img
    s#<iframe\b[^>]*>.*?</iframe>##sig;
    s#<video\b[^>]*>.*?</video>##sig;
    s#<img\b[^>]*\/?>##sig;
  ' "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"

  echo "Processed $FILE"
done
