#!/bin/bash

ARCHIVO_SIM="32X32MATV1_run_msim_rtl_verilog.do"
RUTA_MODELSIM="/home/jhonatang/intelFPGA_lite/20.1/modelsim_ase/bin/"

source ~/Documentos/PYTHON3/env01/bin/activate                  #activamos el AMBIENTE ENV01 de python

NUMBER_OF_TIMES=202
START_SINCE=201

x=$START_SINCE

while [ $x -le $NUMBER_OF_TIMES ]
do
	# Aquí puedes poner las instrucciones que deseas ejecutar en cada iteración
	cd ~/Documentos/PYTHON3/python_programms_env01/DD_proyect       #ir a la carpeta de python del proyecto
	python3 generateMatrixAuto.py                                   #Ejecutamos el programa que genera las matrices
	
	sleep 30

	cd ~/Documentos/PYTHON3/python_programms_env01/DD_proyect
	mv Matrix_AB_PythonOut.txt Matrix_AB_PythonOut_$x.txt           #el archivo .txt del resultado AB se le cambia nombre
	mv Reales_M1.txt /home/jhonatang/Documentos/PROYECTOS_QUARTUS/PROYECTO_32X32MAT/simulation/modelsim     #movemos los archivos a la carpeta de la simulacion
	mv Imagin_M1.txt /home/jhonatang/Documentos/PROYECTOS_QUARTUS/PROYECTO_32X32MAT/simulation/modelsim
	mv Reales_M2.txt /home/jhonatang/Documentos/PROYECTOS_QUARTUS/PROYECTO_32X32MAT/simulation/modelsim
	mv Imagin_M2.txt /home/jhonatang/Documentos/PROYECTOS_QUARTUS/PROYECTO_32X32MAT/simulation/modelsim

	cd ~/Documentos/PROYECTOS_QUARTUS/PROYECTO_32X32MAT/simulation/modelsim         #ir al directorio del archivo .do de simulacion
	${RUTA_MODELSIM}vsim -do ${ARCHIVO_SIM} &                                       #ejecutamos en segundo plano vsim

	sleep 45

	mv outputR.txt /home/jhonatang/Documentos/ALL_CASES     				#movemos los archivos de salida del modulo a la carpeta del proyecto
	mv outputI.txt /home/jhonatang/Documentos/ALL_CASES

	cd ~/Documentos/ALL_CASES              						#nos movemos del directorio de simulación a la del proyecto principal
	mv outputR.txt outputR_$x.txt                                           #cambiamos el nombre de los archivos al 01
	mv outputI.txt outputI_$x.txt

	x=$(( $x + 1 ))
done

sleep 20

x=$START_SINCE
while [ $x -le $NUMBER_OF_TIMES ]
do
	cd ~/Documentos/PYTHON3/python_programms_env01/DD_proyect
	mv Matrix_AB_PythonOut_$x.txt /home/jhonatang/Documentos/ALL_CASES
	x=$(( $x + 1 ))
done

exit 0
