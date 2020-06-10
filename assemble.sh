mkdir -p build-asm
set -e # exit on error
PYCMD=${PYCMD:-"py -2"} # unix uses python (passed as env), win uses py -2, idk about mac
cd pyiiasmh
for file in ../src-asm/*.asm; do
    [ -f "$file" ] || break                                         # exits if no files
    file=${file##*/}                                                # strips directory
    file=${file%.*}                                                 # strips extension
    [ "${file}" != "_macros" ] || continue                          # skips macros.asm itself
    cat ../build-asm/$1/aliases.asm ../src-asm/_macros.asm ../src-asm/${file}.asm > temp.asm    # prepends region and macrosmacros.asm
    $PYCMD pyiiasmh_cli.py -a -codetype C0 temp.asm > "../build-asm/$1/${file}.gecko"
    echo "- Assembled $1/${file}.asm." >&1
done
rm -f temp.asm
cd ..
