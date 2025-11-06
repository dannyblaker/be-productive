for i in {1..3}; do
    echo "Place page $i on the scanner and press Enter"
    read
    scanimage --resolution 300 --format=png > page$i.png
done
convert $(ls page*.png | sort -V) -density 300 scanned_document.pdf
rm page*.png