# sd-2c2019

[6617/8641] - Sistemas Digitales

# Pre requisitos:

- Usar un sistema en base GNU/Linux. Para este desarrollo se usó inicialmente Ubuntu 14.04 y luego 20.04.
- Instalar `git` y preferentemente `ssh` para descargar este repositorio.
- Instalar `ghdl` VHDL compiler/simulator. En Ubuntu 20.04: 

```bash
sudo apt install ghdl
```

- Instalar la herramienta de visualización `gtkwave` para señales digitales (ejemplos: VCD, LXT, LXT2, VZT, FST, GHW). En Ubuntu 20.04:

```bash
sudo apt install gtkwave
```

- Instalar el software de sintetización e implementación de circuitos digitales *Vivado*. Se descarga desde la web oficial de Xilinx posterior resgistración, es multiplataforma y pesa varios Gigabytes.

# Trabajo práctico final (xx/02/2022):

## Red Pitaya FPGA Project 1 – LED Blinker

Abrir Vivado y dentro de la consola para comandos TCL ejecutar desde la carpeta del proyecto.

```bash
source make_project.tcl
```

Automaticamente se creará el projecto completo en vivado dentro del subdirectorio `tmp/1_led_blink/`.

Si examinamos examinar el diseño en bloques desde *Open Block Desing* en el panel lateral izquierdo de Vivado. Luego hacer click en *Generate Bitstream* en la parte inferior de la barra lateral para generar el *bitstream file*, para ello previamente se debe confirmar tanto la Síntesis (Synthesis) como la Implementación (Implementation). El proceso puede tardar dependiendo del hardware donde se esté desarrollando.

Terminada la síntesis, implementación y generación del bitstream se podrá encontrar el archivo de bits el subdirectorio: `/tmp/1_led_blink/1_led_blink.runs/impl_1/system_wrapper.bit`

Luego se debe copiar el archivo .bit generado en algún directorio del dispositivo RedPitaya. Por ejemplo:

```bash
cd tmp/1_led_blink/1_led_blink.runs/impl_1/
scp system_wrapper.bit root@your_rp_ip:led_blink.bit
```

Finalmente ya podemos programar la FPGA con el bitstream creado, en nuestro ejemplo está ubicado en el directorio `/root/` de RedPitaya. Para ello se debe ejecutar la siguiente línea en la consola de Linux en su Red Pitaya (usar Putty en Windows):

```bash
cat /root/led_blink.bit > /dev/xdevcfg
```

Si se desea volver al programa oficial RedPitaya FPGA, ejecutar el siguiente comando o bien reiniciar (apagando y encendiendo) el dispositivo.

```bash
cat /opt/redpitaya/fpga/fpga_X.XX.bit > /dev/xdevcfg
```


# Trabajo práctico Nº2 (10/12/2019):

Ver informe asociado [**6617_tp2_2c2019_report.pdf**](./tp2/6617_tp2_2c2019_report.pdf).

# Trabajo práctico Nº1 (10/11/2019):

Ver informe asociado [**6617_tp1_2c2019_report.pdf**](./tp1/6617_tp1_2c2019_report.pdf).