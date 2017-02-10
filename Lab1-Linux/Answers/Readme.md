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

6. What does the tail command do?

7. What does the tail -f command do?

8. What does the link command do?

9. What is the meaning of #! /bin/bash at the start of scripts?

10. Para encontrar los usuarios en el servidor del curso, se necesita estar dentro de este primero. Después se pueden usar los siguientes comandos:
--> cat /etc/passwd | grep '/home' | cut -d: -f1 esta instrucción busca en el archivo de registros del sistema, busca los usuarios que han ingresado desde la carpeta home y muestra únicamente los nombres de estos (están en el primer campo) [7]. 
--> users Retorna los usuarios activos. Este es necesario puesto que los usuarios que la lista anterior no cuenta a los usuarios que ingresan por vision. 
comando_inicial | wc -w cuenta las palabras en las listas que retornan los comandos anteriores.

11. Para organizar en una tabla los usuarios según su bash, se corrió la siguiente instrucción estando ya logeados en el servidor del curso [11][12][13] : 
cut -d: -f1,7 /etc/passwd | sort -t: -k2 | tr -s "/" ":" | awk -F: '{print $1 " "$2}'|column -t

12. Create a script for finding duplicate images based on their content (tip: hash or checksum) You may look in the internet for ideas, Do not forget to include the source of any code you use.

14. La base de datos comprimida ocupa 68M del disco duro, esto lo obtuvimos utilizando el comando du -sh BSR_bsds500.tgz, donde du encuentra el tamaño de un directorio o archivo, y las opciones sh son para que sólo muestre el tamaño total del directorio o archivo y que esta información sea legible[8].

Para encontrar el número de imágenes en el directorio buscamos los archivos con la ruta deseada en su ruta completa, a partir de estos buscamos archivos con la extensión .jpg y del resultado contamos el núemro de líneas. El comando fue:(find .*/BSR/BSDS500/data/images -name *jpg) | wc -l

15. Las imagenes son de 481x321 o de 321x481. Están en un formato de 8-bits y sRGB. Para encontrar esto hicimos un script que contenía los siguientes comandos:
 #!/bin/bash
ims=$(find .*/BSR/BSDS500/data/images -name *jpg)
for im in ${ims[*]}
do 
identify $im | cut -d' ' -f3,5,6
done

16. How many of them are in landscape orientation (opposed to portrait)?

17. Para cortar todas las imágenes se ejecutó el siguiente script [9][10] :

 #!/bin/bash
#Find all images w/ a .jpg extension in the path
ims=$(find .*/BSR/BSDS500/data/images -name *jpg)

for im in ${ims[*]}
do 

# the name of the current image is taken from the command identify $im | cut -d' ' -f1
# Crop image and replace original w/o duplicates (+repage)
convert $(identify $im | cut -d' ' -f1) -crop 256x256+0+0 +repage $(identify $im | cut -d' ' -f1) 

#convert $(identify $im | cut -d' ' -f1) -crop 256x256
done

Referencias:
[1] https://www.cyberciti.biz/faq/howto-use-grep-command-in-linux-unix/
[2] http://linuxcommand.org/man_pages/find1.html
[3] https://linuxaria.com/pills/cut-shell-linux
[4] http://www.tecmint.com/rsync-local-remote-file-synchronization-commands/
[5] http://www.computerhope.com/unix/udiff.htm
[6] https://www.cyberciti.biz/programming/color-terminal-highlighter-for-diff-files/
[7] http://www.lostsaloon.com/technology/how-to-list-all-users-in-linux/
[8] http://www.linfo.org/du.html
[9] http://www.wizards-toolkit.org/discourse-server/viewtopic.php?t=15471
[10] http://www.imagemagick.org/Usage/crop/#crop
[11] http://www.tldp.org/LDP/abs/html/awk.html
[12] https://www.cyberciti.biz/faq/bash-scripting-using-awk/
[13] https://www.cyberciti.biz/faq/how-to-use-linux-unix-tr-command/

