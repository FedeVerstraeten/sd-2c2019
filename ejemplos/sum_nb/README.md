# Sumador de N bits en VHDL

- Tener creada la estructura de directorios:
```
# Directorios
src/ --> código funte vhdl
simulation/ --> inicialmente vacía
testbench/ --> código vhdl que ejecuta el testbench

# o bien ejecutar
$ make new
```


- Compilar y ejecutar utilizando el `makefile` adjunto.
```
# Compile
$ make compile TESTBENCH=sum_nb_tb

# Run
$ make run TESTBENCH=sum_nb_tb

# View on GTKWave
$ make view TESTBENCH=sum_nb_tb

# All
$ make TESTBENCH=sum_nb_tb
```
- Testeado con ghdl+GTKWave,funcionando OK.
- El programa en VHDL posee un código sumador de Nbit que llama a otro código sumador de 1bit.
- Por defecto se prueba con N=4 bits.
- Valores cargados para las entradas a=3 y b=5.

```
    -- signal a_tb: std_logic_vector(N_t-1 downto 0) := "0011";
    signal a_tb: std_logic_vector(N_t-1 downto 0) := std_logic_vector(to_unsigned(3, N_t));
    --  signal b_tb: std_logic_vector(N_t-1 downto 0) := "0101";
    signal b_tb: std_logic_vector(N_t-1 downto 0) := std_logic_vector(to_unsigned(5, N_t));
```

- Salida esperada en el GTKWave (se omitieron los Carry):
```
  -- GTKWave signal exit:
  --
  -- Time: 0ns....100ns....200ns....300ns
  -- a_tb: |3.......|6.......|........|
  -- b_tb: |5................|8.......|
  -- s_tb: |8.......|B.......|E.......|
```