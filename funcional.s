#*******************************************************************************
#        1         2         3         4         5         6         7         8
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
#           M     O                            #
.text
.globl adivinha_letra
.globl le_teclado
.globl tamanho_palavra
.globl compara_palavra
.globl letras_digitadas
.globl guarda_letra_digitada
.globl verifica_letra_digitada

.eqv CR 0x0D

# procedimento para adicionar a letra na palavra. Esse procedimento apenas adiciona a letra
# na memoria. Para imprimir na tela, eh chamado o procedimento "imprime_palavra".
adivinha_letra:
# prologo
            addi  $sp, $sp, -4
            sw    $ra, 0($sp)
# corpo do procedimento
            li    $v0, -1
            la    $t0, palavra
	    la    $t1, palavra_adivinha
	    la    $t2, letra
loop_adivinha_letra:
	    lb    $t3, 0($t1)
	    lb    $t4, 0($t2)
	    beq   $t3, $t4, marca_letra_palavra
	    beq   $t3, 0, encerra_adivinha_letra
	    addi  $t0, $t0, 1
	    addi  $t1, $t1, 1
	    addi  $v0, $v0, 1
	    j     loop_adivinha_letra
marca_letra_palavra:
            sb    $t3, 0($t0)
            addi  $t0, $t0, 1
            addi  $t1, $t1, 1
            j     loop_adivinha_letra
encerra_adivinha_letra:
# epilogo
            lw    $ra, 0($sp)
            addi  $sp, $sp, 4
            jr    $ra
            
le_teclado:
# prologo
            sub   $sp, $sp, 4                  # ajusta a pilha para receber um elemento
            sw    $ra, 0($sp)                  # guarda o valor de $ra na pilha
# corpo do procedimento
            la    $t1, letra
le_teclado_loop:            
            li    $a0, 0xFFFF0000              # a0 <- endereco do receiver control register
            lw    $t0, 0($a0)                  # carrega o dado do endereco
            and   $t0, 0x00000001              # isola o bit menos significativo
            beq   $t0, $zero, le_teclado_loop  # se bit menos significativo = 0 repete
            li    $t2, 0xFFFF0004
            lb    $t0, 0($t2)
            sb    $t0, 0($t1)
# epilogo
            lw    $ra, 0($sp)                  # restaura $ra
            add   $sp, $sp, 4                  # ajusta a pilha
            jr    $ra                          # retorne

# procedimento para calcular o tamanho da palavra. O tamanho da palavra eh usado como
# parametro em outros procedimentos.
tamanho_palavra:
# corpo do procedimento
	    la    $t0, palavra_adivinha
	    li    $t2, 0
tamanho_palavra_loop:
	    lb    $t1, 0($t0)
	    beq   $t1, CR, encerra_tamanho_palavra
	    addi  $t0, $t0, 1
	    addi  $t2, $t2, 1
	    j     tamanho_palavra_loop
# epilogo
encerra_tamanho_palavra:
            move  $v0, $t2
            jr    $ra

# procedimento para comparar a palavra que esta sendo adivinhada e o que ja foi impresso
# na tela. Se o que ja foi impresso na tela coincidir com todos os caracteres da palavra,
# ou seja, as duas palavras forem iguais, o jogo termina.
compara_palavra:
	    la    $t0, palavra
	    la    $t1, palavra_adivinha
	    li    $t4, 0                       # quantidade de caracteres iguais
	    li    $t5, 0                       # contador de caracteres da palavra
	    lw    $t6, 20($sp)
compara_palavra_loop:
	    lb    $t2, 0($t0)
	    lb    $t3, 0($t1)
	    beq   $t2, $t3, caracter_igual
	    addi  $t0, $t0, 1
	    addi  $t1, $t1, 1
	    addi  $t5, $t5, 1
	    beq   $t4, $t6, jogador_ganhou
	    beq   $t5, $t6, encerra_compara_palavra
	    j     compara_palavra_loop
caracter_igual:
            addi  $t4, $t4, 1
            addi  $t5, $t5, 1
	    addi  $t0, $t0, 1
	    addi  $t1, $t1, 1
	    beq   $t4, $t6, jogador_ganhou
	    beq   $t5, $t6, encerra_compara_palavra
	    j     compara_palavra_loop
encerra_compara_palavra:
            jr    $ra

# procedimento para armazenar as letras que foram digitadas e nao pertencem a palavra. Esse
# procedimento soh guarda a letra somente se ela nao estiver na palavra a ser adivinhada, ou
# se nao estiver armazenada no vetor "letras_digitadas". Caso a letra a ser guardada coinci-
# dir com alguma letra, tanto na palavra, quanto no vetor "letras_digitadas", o procedimento
# retorna $v0 = -1 para que a main saiba que aquela letra ja foi digitada e tenha que pedir
# outra letra.
guarda_letra_digitada:
# corpo do procedimento
            la    $t0, letra
            lb    $t1, 0($t0)
            la    $t2, palavra
            li    $t4, 0
            lw    $t5, 20($sp)
loop_guarda_letra_palavra:
            lb    $t3, 0($t2)
            beq   $t1, $t3, encerra_guarda_letra
            addi  $t2, $t2, 1
            addi  $t4, $t4, 1
            beq   $t4, $t5, procura_vetor
            j     loop_guarda_letra_palavra
procura_vetor:
            la    $t2, letras_digitadas
loop_procura_vetor:
            lb    $t3, 0($t2)
            beq   $t3, 0, guarda_letra
            beq   $t3, $t1, encerra_guarda_letra
            addi  $t2, $t2, 1
            j     loop_procura_vetor
guarda_letra:
            sb    $t1, 0($t2)
            j     encerra_guarda_letra
encerra_guarda_letra:
            jr    $ra
            
verifica_letra_digitada:
            la    $t0, letra
            la    $t1, palavra
            lb    $t2, 0($t0)
            li    $t4, 0
            lw    $t5, 20($sp)
loop_verifica_letra:
            lb    $t3, 0($t1)
            beq   $t2, $t3, letra_ja_digitada
            addi  $t1, $t1, 1
            addi  $t4, $t4, 1
            beq   $t4, $t5, verifica_letra_vetor
            j     loop_verifica_letra
verifica_letra_vetor:
            la    $t3, letras_digitadas
loop_verifica_letra_vetor:
            lb    $t4, 0($t3)
            beq   $t4, 0, encerra_verifica_letra
            beq   $t2, $t4, letra_ja_digitada
            addi  $t3, $t3, 1
            j     loop_verifica_letra_vetor
letra_ja_digitada:
            la    $t0, msg_caracter_digitado
            li    $t1, 0xFFFF000C
loop_letra_ja_digitada:
            lb    $t2, 0($t0)
            sb    $t2, 0($t1)
            beq   $t2, 0, encerra_verifica_digitada
            addi  $t0, $t0, 1
            j     loop_letra_ja_digitada
encerra_verifica_digitada:
            li    $v0, -1
encerra_verifica_letra:
# epilogo
            jr    $ra

.data
letras_digitadas:          .space 32
msg_caracter_digitado:     .asciiz "LETRA JA DIGITADA!\n"