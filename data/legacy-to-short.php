<?php
//Parse legacy.txt wordlist into a list of short words.
// Open the input file (legacy.txt) for reading
$inputFile = fopen("legacy.txt", "r");
if (!$inputFile) {
    die("Unable to open legacy.txt for reading.\n");
}

// Open the output file (new.txt) for writing
$outputFile = fopen("new.txt", "w");
if (!$outputFile) {
    fclose($inputFile);
    die("Unable to open new.txt for writing.\n");
}

// Process each line from legacy.txt
while (($line = fgets($inputFile)) !== false) {
    $word = trim($line); // remove whitespace/newlines
    //if (strlen($word) <= 5 && strlen($word) >= 3 && ctype_alnum($word)) {
    //if (strlen($word) == 4 && ctype_alnum($word)) {
    if (
        $word !== "" &&
        strlen($word) <= 6 &&
        strlen($word) >= 3 &&
        ctype_alnum($word)
        && stripos($word, 'I') === false
        && stripos($word, 'L') === false
        && stripos($word, 'O') === false
        //&& stripos($word, 'S') === false //Looks like 5 Five
        && stripos($word, 'Z') === false //Looks like 2 Two
        && stripos($word, 'B') === false //Looks like 8 Eight
    ) {
  
        fwrite($outputFile, strtolower($word) . PHP_EOL);
    }
}

// Close the files
fclose($inputFile);
fclose($outputFile);

echo "Filtering complete. Words of length 5 or less written to new.txt\n";

