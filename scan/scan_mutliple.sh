NUM_PAGES=14
DOC_NAME="doc.pdf"
for i in $(seq 1 $NUM_PAGES); do
    echo "Place page $i on the scanner and press Enter"
    read
    echo "Scanning..."
    scanimage --resolution 300 --format=png > page$i.png
done
convert $(ls page*.png | sort -V) -density 300 "$DOC_NAME"
rm page*.png