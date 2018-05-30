#############################################################################################
# Equivalencias #
.eqv servico_abre_arquivo 		13
.eqv servico_leia_arquivo 		14
.eqv servico_escreve_arquivo 		15
.eqv servico_fecha_arquivo 		16
.eqv servico_termina_programa 		17

.eqv sinaliza_abre_leitura 		0
.eqv sinaliza_abre_escrita 		1
.eqv sinaliza_abre_anexa_escrita 	9

.eqv LF	0x0A
.eqv CR 0x0D
##############################################################################################
#*******************************************************************************
#        1         2         3         4         5         6         7         8
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
#           M     O                            #
.text
.globl abre_leitura
.globl pega_palavra
.globl aborta_programa
.globl palavra
.globl palavra_adivinha
.globl zera_palavra

pega_palavra:
# corpo do procedimento
valor_aleatorio:
	    li	  $v0, 42                      # carrega em $v0 o codigo para a funcao de gerar um numero aleatorio
	    li	  $a1, 40		       # carrega em $a1 o limite superior do nosso numero aleatorio
	    li	  $a0, 0		
	    syscall			       # $a0 <- valor aleatorio
palavra_aleatoria:
	    la	  $t1, buffer		       # $t1 <- endereco do buffer
	    li	  $t0, 0		       # contador de palavras
	    la	  $t2, palavra		       # endereco da palavra a ser adivinhada (contem apenas UNDERLINES no comeco do jogo)
	    la    $t4, palavra_adivinha        # endereco que contem a palavra
	    li	  $s5, -1		       # contador de caracteres da palavra
palavra_aleatoria_loop:
	    lb	  $t3, 0($t1)		       # carrega caracter do endereco do buffer
	    addi  $t1, $t1, 1		       # acrescenta um no endereco, passando para o proximo caracter
	    beq   $t3, LF, proxima_palavra     # quando acha a quebra de linha, passa para a proxima palavra
	    beq	  $t0, $a0, adiciona_letra     # se o contadoradiciona a letra na palavra
	    j	  palavra_aleatoria_loop

proxima_palavra:
	    beq   $t0, $a0, finaliza_palavra	
	    addi  $t0, $t0, 1		       # incrementa o contador de palavras
	    j     palavra_aleatoria_loop
adiciona_letra: 
	    sb	  $t3, 0($t4)		       # coloca a letra na palavra_adivinha
	    beq   $t3, CR, nao_coloca
	    li    $t5, 0x5F		       # armazena o codigo em hexa do caracter UNDERLINE
	    sb    $t5, 0($t2)
nao_coloca:
	    addi  $t2, $t2, 1		       # proxima letra da palavra
	    addi  $t4, $t4, 1		       # proximo endereco da palavra a ser adivinhada
	    addi  $s5, $s5, 1		       # pega o numero de caracteres
	    j	  palavra_aleatoria_loop

finaliza_palavra:
	    li	  $t3, 0x00
	    sb	  $t3, 0($t2)		       # terminador nulo da palavra selecionada
# epilogo
	    jr	  $ra


abre_leitura:
# corpo do procedimento
	    li 	  $v0, servico_abre_arquivo
	    la    $a0, nome_arquivo	       # nome_arquivo eh o nome do arquivo
	    li 	  $a1, sinaliza_abre_leitura
	    li 	  $a2, 0	   	       # ignora o modo
	    syscall			       # descritor do arquivo retornado em $v0
	    move  $a0, $v0		       # move o descritor do arquivo para $a0
	
le_arquivo:
	    li	  $v0, servico_leia_arquivo
	    la	  $a1, buffer		       # endereco do buffer
	    li	  $a2, 1024		       # nao ler mais que 1024 bytes
	    syscall
	
fecha_arquivo:
	    li	  $v0, servico_fecha_arquivo
	    syscall
# epilogo
	    jr    $ra
	    
aborta_programa:
	    # imprime uma mensagem de erro
	    la	  $a0, msgErroAberturaArquivo
	    li	  $v0, 4
	    syscall
	    # termina o programa. Retorna -1, indicando que a execucao do arquivo teve problemas
	    li	  $a0, -1
	    li	  $v0, servico_termina_programa
	    syscall
	    
zera_palavra:
# prologo
            addi  $sp, $sp, -4
            sw    $ra, 0($sp)
# corpo do procedimento
            la    $t6, palavra
            li    $t8, 0
loop_zera_palavra:
            lb    $t7, 0($t6)
            sb    $zero, 0($t6)
            addi  $t6, $t6, 1
            addi  $t8, $t8, 1
            blt   $t8, 32, loop_zera_palavra
encerra_zera_palavra:
# epilogo
            lw    $ra, 0($sp)
            addi  $sp, $sp, 4
	    jr    $ra

.data
descritorArquivo:	.space 4
nome_arquivo:		.asciiz "palavras.txt"
buffer: 		.space 1024
ptrFimBuffer: 		.word buffer
msgErroAberturaArquivo: .asciiz "O arquivo nao pode ser aberto. O programa sera encerrado\n"
palavra: 	        .space 32	
palavra_adivinha:	.space 32