Laboratorio 1 - Linux
Juan Camilo Pérez y Laura Bravo Sánchez

1. El comando grep busca la coincidencia de una cadena de caracteres con los archivos especificados. 
	Syntaxis: grep 'cadena de caracteres' dir_archivo(s)
		 -r buscar recursivamente
	Output: nombres de archivos que coinciden y ruta [1]
2. La opción -prune del comando find encuentra los archivos indicados, sin buscar en las sub carpetas del directorio [2].
	Ej: find . -name 'ejemplo*' -prune -o -name '*Lab1' -print
	Empieza a buscar el archivo Lab1 en el directorio actual, pero 		excluye los archivos que tengan la palabra ejemplo en el nombre.
	Output: ./vision/Vision17/Lab1
3. El comando cut procesa cadenas de caracteres cortandolas e imprimiendo lo especificado. Las opciones de cut son [3]:
	Syntaxis: cut opciones nombre_de_archivo o cadena_de_caracteres
	-c lista (ej 1-5 o 1,2): selecciona unicamente los caracteres 		indicados en la lista.
	-d delimitador (ej :,;.' '): separa la cadena de caracteres según 		el delimitador especificado, en vez de con TAB (default)
	-f campos (ej 1,2): selecciona unicamente los campos indicados 		(divididos según el delimitador)
	-s no imprime las lineas que tienen un delimitador
4. El comando rsync se utiliza para copiar y sincronizar archivos y directorios tanto remotamente o localmente. Es más rápido que scp puesto que una vez ya han sido copiados los archivos la primera vez, copia únicamente lo que ha sido modificado. Requiere instalarlo para usarlo [4].
	Syntaxis: rsync opciones source destino
	Opciones:
	-v imprime todo lo que va haciendo
	-r copia la información recursivamente
	-z comprime la información en las carpetas
	-h el output es legible para un humano
5. El comando diff compara dos archivos linea a linea y devuelve las diferencias entre ellos. Colordiff es una extensión de diff que hace más legible lo que devuelve la función diff con colores[5][6].
	Syntaxis: diff opciones archivo1 archivo2
	Opciones (algunas):
	-b ignorar cambios que solo sean de espacios
	-y mostrar el output en dos columnas
	-s reporte si son identicos los archivos

6. El comando tail muestra la última parte de un archivo. Por 'default' son las últimas diez lineas del archivo de entrada. [Tomado de 'man tail']

7. La opción '-f' hace que el comando tail no se detenga en el final del archivo, sino que espere para añadir más datos al final (append) para ser procesados po$
 
8. 'link' o 'ln' crea una entrada en el directorio que está asociada con otro archivo (linked). Es decir, permite la creación de un apuntador a un archivo, así no se desperdicia memoria guardando un mismo archivo en varios lugares, sino que solo se guarda un original y el resto son archivos que apuntan al primero. 

9. Es una convención para que el 'shell' sepa cuál interpretador usar al leer el archivo. Esto porque el archivo puede estar escrito en otro lenguaje, como python, perl, ruby, PHP, por lo tanto se podría tener la sintaxis '!/bin/perl'. Si no se especifica, Unix intentará leerlo como 'bash'.
[http://stackoverflow.com/questions/8967902/why-do-you-need-to-put-bin-bash-at-the-beginning-of-a-script-file]

10. Para encontrar los usuarios en el servidor del curso, se necesita estar dentro de este primero. Después se pueden usar los siguientes comandos:
--> cat /etc/passwd | grep '/home' | cut -d: -f1 esta instrucción busca en el archivo de registros del sistema, busca los usuarios que han ingresado desde la carpeta home y muestra únicamente los nombres de estos (están en el primer campo) [7]. 
--> users Retorna los usuarios activos. Este es necesario puesto que los usuarios que la lista anterior no cuenta a los usuarios que ingresan por vision. 
comando_inicial | wc -w cuenta las palabras en las listas que retornan los comandos anteriores.

11. Para organizar en una tabla los usuarios según su bash, se corrió la siguiente instrucción estando ya logeados en el servidor del curso [11][12][13] : 
cut -d: -f1,7 /etc/passwd | sort -t: -k2 | tr -s "/" ":" | awk -F: '{print $1 " "$2}'|column -t

12. Para identificar las imágenes repetidas según su contenido se utilizó el siguiente script:

 #! /bin/bash
echo "Enter the name of the directory in which the images are"
read imageDirectory
imageDirectory=./$imageDirectory

 # Define names to be used
nameSumsFile=sums.txt
nameRepeatedImgs=imgs.txt
nameRepeatedOnesTxt=repeatedones.txt

echo "Enter the type of images (eg: png, jpg, tiff, etc...)"
read fileType

 # Remove .txt's from previous run of the script
if [ -f $nameSumsFile ]; then
	rm $nameSumsFile 
fi
if [ -f $nameRepeatedImgs ]; then
	rm $nameRepeatedImgs
fi
if [ -f $nameRepeatedOnesTxt ]; then
        rm $nameRepeatedOnesTxt
fi

 # Count number of images before creating .txt's
numberOfImages=$(ls -1 $imageDirectory | grep $*.$fileType | wc -l)
echo This is the number of images I found: $numberOfImages

 # Fill file with all the checksums of the files
images=$(ls -1 $imageDirectory | grep $*.$fileType)

echo These are the names of the images I found: $images

for currentim in ${images[*]}; do
	md5 -q $imageDirectory/$currentim >> $nameSumsFile
done

 # INFO: up to this point, there is a file that contains the checksums of all the images

 # Now we look for the lines of that file that arent unique (they are written in $nameRepeatedOnesTxt)
sort $nameSumsFile | uniq -d > $nameRepeatedOnesTxt

 # Now that we have all the repeated checksums in a file, we can go through that file line by line and look which images correspond to that line (checksum)
 # This idea was taken from http://stackoverflow.com/questions/6022384/bash-tool-to-get-nth-line-from-a-file and http://stackoverflow.com/questions/169511/how-do-i-iterate-over-a-range-of-numbers-defined-by-variables-in-bash
numOfRepeatedFiles=$(cat $nameRepeatedOnesTxt | wc -l)
echo There are $numOfRepeatedFiles repeated images

 # Check if there are no repeated files
if [ $numOfRepeatedFiles = 0 ]; then
	echo "There are no repeated files!"
	exit 1
fi

 # Go line by line from the file
for idx in $(seq 1 $numOfRepeatedFiles); do
	# Extract a line
	line=$(sed "${idx}q;d" $nameRepeatedOnesTxt)
	echo Duplicates $idx >> $nameRepeatedImgs
	for jdx in $(seq 1 $numberOfImages); do
		otherline=$(sed "${jdx}q;d" $nameSumsFile)
		if [ $line = $otherline ]; then
			(echo $images | cut -d" " -f$jdx) >> $nameRepeatedImgs
		fi
	done
done

14. La base de datos comprimida ocupa 68M del disco duro, esto lo obtuvimos utilizando el comando du -sh BSR_bsds500.tgz, donde du encuentra el tamaño de un directorio o archivo, y las opciones sh son para que sólo muestre el tamaño total del directorio o archivo y que esta información sea legible[8].

Para encontrar el número de imágenes en el directorio buscamos los archivos con la ruta deseada en su ruta completa, a partir de estos buscamos archivos con la extensión .jpg y del resultado contamos el núemro de líneas. El comando fue:(find .*/BSR/BSDS500/data/images -name *jpg) | wc -l

15. Las imagenes son de 481x321 o de 321x481. Están en un formato de 8-bits y sRGB. Para encontrar esto hicimos un script que contenía los siguientes comandos:

 #!/bin/bash
ims=$(find .*/BSR/BSDS500/data/images -name *jpg)
for im in ${ims[*]}
do 
identify $im | cut -d' ' -f3,5,6
done

16. Para contar la cantidad de imágenes de la base de datos que están en orientación retrato o paisaje se utilizó el siguiente script:

 #!/bin/bash
 # This script uses imagemagick, so the system must have this program for this script to run properly

 # Initialize counters
landscape=0
portrait=0

 # Ask for the image type
echo "Please enter the image format (png, tiff, jpg, etc...)"
read fileType

 # Get images from the specified file type
images=$(find .*/BSR/BSDS500/data/images -name "*.jpg")

 # Iterate through all the images and count
for currentim in ${images[*]}; do
        cols=$(identify $currentim | cut -d" " -f3 | cut -dx -f1)
        rows=$(identify $currentim | cut -d" " -f3 | cut -dx -f2)
        if [ $rows -ge $cols ]; then
                portrait=$(($portrait+1))
        else
                landscape=$(($landscape+1))
        fi
done
echo There are $portrait images whose orientation is portrait
echo There are $landscape images whose orientation is landscape

La respuesta final fue:
There are 152 images whose orientation is portrait
There are 348 images whose orientation is landscape

17. Para cortar todas las imágenes se ejecutó el siguiente script [9][10] :

 #!/bin/bash
 #Find all images w/ a .jpg extension in the path
ims=$(find .*/BSR/BSDS500/data/images -name *jpg)

for im in ${ims[*]}
do 

 # the name of the current image is taken from the command identify $im | cut -d' ' -f1
 # Crop image and replace original w/o duplicates (+repage)
convert $(identify $im | cut -d' ' -f1) -crop 256x256+0+0 +repage $(identify $im | cut -d' ' -f1) 

done

Referencias:
[1] Gite,V. HowTo: Use grep Command In Linux / UNIX – Examples (2007). Recuperado de:https://www.cyberciti.biz/faq/howto-use-grep-command-in-linux-unix/
[2] LinuxCommand. Find (2016). Recuperado de: http://linuxcommand.org/man_pages/find1.html
[3] Using cut on linux terminal. Linuxaria. Recuperado de: https://linuxaria.com/pills/cut-shell-linux
[4] Shrivastava,T. Rsync (Remote Sync): 10 Practical Examples of Rsync Command in Linux (2013). Recuperdo de: http://www.tecmint.com/rsync-local-remote-file-synchronization-commands/
[5] Linux and Unix diff command. Computer Hope. Recuperado de: http://www.computerhope.com/unix/udiff.htm
[6] Gite,V. Diff Command: Colorize Output On The Unix / Linux Command Line. nixCraft. (2012). Recuperdo de: https://www.cyberciti.biz/programming/color-terminal-highlighter-for-diff-files/
[7] Barkeep. Lostsaloon. How to list users in linux?…local, remote, real and all users (2013). Recuperado de: http://www.lostsaloon.com/technology/how-to-list-all-users-in-linux/
[8] The Linux Information Project. The du command (2007). Recuperado de: http://www.linfo.org/du.html
[9] ImageMagick. RE: convert -crop: suppress creation of "extra" image file (2010). Recuperado de: http://www.wizards-toolkit.org/discourse-server/viewtopic.php?t=15471
[10] Thyssen,A. ImageMagick. Crop (2016). Recuperado de: http://www.imagemagick.org/Usage/crop/#crop
[11] Advanced Bash-Scripting Guide: Appendix C. A Sed and Awk Micro-Primer. Recuperado de: http://www.tldp.org/LDP/abs/html/awk.html
[12] Gite, V. How To Use awk In Bash Scripting (2009). Recuperado de: https://www.cyberciti.biz/faq/bash-scripting-using-awk/
[13]Gite, V. Understanding Linux / UNIX tr command (2007). Recuperado de: https://www.cyberciti.biz/faq/how-to-use-linux-unix-tr-command/

