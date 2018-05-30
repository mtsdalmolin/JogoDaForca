#*******************************************************************************
#        1         2         3         4         5         6         7         8
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
#           M     O                            #
.text
.globl imprime_palavra

imprime_palavra:
# prologo
            addi $sp, $sp, -8                  # arruma a pilha pra receber um elemento
            sw   $ra, 0($sp)                   # guarda $ra na pilha
# corpo do procedimento
	    li   $t1, 1
	    la   $t0, palavra
tamanho_string:
	    add  $t0, $t0, 1
	    add  $t1, $t1, 1
	    sw   $t1, 4($sp)
	    lb   $t2, 0($t0)
	    beq  $t2, 0, pega_letra_string
	    j    tamanho_string
pega_letra_string:
	    li    $s3, 0
	    la    $s2, palavra
	    lb    $s4, 0($s2)                  # primeiro byte da minha string
	    j     switch_letra

imprime_linha: 
	    andi  $t3, $s5, 0x80000000 	       # faz and com o bit mais significativo
	    beq   $t3, 0x80000000, marca_pixel
flag_return:
	    sll   $s5, $s5, 1                  # desloca o numero binario uma casa pra esquerda
	    add   $s0, $s0, 1
	    add   $a0, $a0, 1
	    blt   $s0, 4, imprime_linha        # enquanto i < 4, imprime na mesma linha
	    add   $a0, $a0, -4                 # volta o carro para imprimir o resto da letra
	    add   $a1, $a1, 1                  # linha de baixo
	    add   $s0, $s0, -4
	    add   $s1, $s1, 1
	    blt   $s1, 8, imprime_linha
	    add   $a0, $a0, 5                  # passa para a proxima letra
	    add   $a1, $a1, -8                 # retorna para imprimir de cima a letra
	    li    $s0, 0                       # zera o contador da linha da matriz 4x7 da letra
	    li    $s1, 0                       # zera o contador da coluna da matriz 4x7 da letra
	    add   $s2, $s2, 1                  # anda um byte do endereco da letra, pegando a proxima letra da palavra
	    lb    $s4, 0($s2)                  # pega a proxima letra no endereco seguinte
	    beq   $s4, 0x0D, encerra_funcao    # verifica se o byte corresponde a voltar o carro para o comeco, se sim, encerra o programa
	    beq   $s4, 0, encerra_funcao
	    j     switch_letra                 # se nao eh, passa para a proxima letra e segue imprimindo
	    add   $s3, $s3, 1                  # $s3 ta armazenando o tamanho da palavra
	    lw    $t0, 4($sp)                  # pega o tamanho da string na pilha
	    blt   $s3, $t0, imprime_linha

encerra_funcao:
# prologo
	    lw    $ra, 0($sp)                  # restaura $ra
	    addi  $sp, $sp, 8                  # restaura a pilha
	    jr    $ra
	    
switch_letra:
	    # valores ASCII
	    li    $t1, 0x41                    # LETRA A
	    beq   $s4, $t1, car_A              # desvia para imprimir A no display
	    li    $t1, 0x42                    # LETRA B
	    beq   $s4, $t1, car_B              # desvia para imprimir B no display
	    li    $t1, 0x43                    # LETRA C
	    beq   $s4, $t1, car_C              # desvia para imprimir C no display
	    li    $t1, 0x44                    # LETRA D
	    beq   $s4, $t1, car_D              # desvia para imprimir D no display
	    li    $t1, 0x45                    # LETRA E
	    beq   $s4, $t1, car_E              # desvia para imprimir E no display
	    li    $t1, 0x46                    # LETRA F
	    beq   $s4, $t1, car_F              # desvia para imprimir F no display
	    li    $t1, 0x47                    # LETRA G
	    beq   $s4, $t1, car_G              # desvia para imprimir G no display
	    li    $t1, 0x48                    # LETRA H
	    beq   $s4, $t1, car_H              # desvia para imprimir H no display
	    li    $t1, 0x49                    # LETRA I
	    beq   $s4, $t1, car_I              # desvia para imprimir I no display
	    li    $t1, 0x4A                    # LETRA J
	    beq   $s4, $t1, car_J              # desvia para imprimir J no display
	    li    $t1, 0x4B                    # LETRA K
	    beq   $s4, $t1, car_K              # desvia para imprimir K no display
	    li    $t1, 0x4C                    # LETRA L
	    beq   $s4, $t1, car_L              # desvia para imprimir L no display
	    li    $t1, 0x4D                    # LETRA M
	    beq   $s4, $t1, car_M              # desvia para imprimir M no display
	    li    $t1, 0x4E                    # LETRA N
	    beq   $s4, $t1, car_N              # desvia para imprimir N no display
	    li    $t1, 0x4F                    # LETRA O
	    beq   $s4, $t1, car_O              # desvia para imprimir O no display
	    li    $t1, 0x50                    # LETRA P
	    beq   $s4, $t1, car_P              # desvia para imprimir P no display
	    li    $t1, 0x51                    # LETRA Q
	    beq   $s4, $t1, car_Q              # desvia para imprimir Q no display
	    li    $t1, 0x52                    # LETRA R
	    beq   $s4, $t1, car_R              # desvia para imprimir R no display
	    li    $t1, 0x53                    # LETRA S
	    beq   $s4, $t1, car_S              # desvia para imprimir S no display
	    li    $t1, 0x54                    # LETRA T
	    beq   $s4, $t1, car_T              # desvia para imprimir T no display
	    li    $t1, 0x55                    # LETRA U
	    beq   $s4, $t1, car_U              # desvia para imprimir U no display
	    li    $t1, 0x56                    # LETRA V
	    beq   $s4, $t1, car_V              # desvia para imprimir V no display
	    li    $t1, 0x57                    # LETRA W
	    beq   $s4, $t1, car_W              # desvia para imprimir W no display
	    li    $t1, 0x58                    # LETRA X
	    beq   $s4, $t1, car_X              # desvia para imprimir X no display
	    li    $t1, 0x59                    # LETRA Y
	    beq   $s4, $t1, car_Y              # desvia para imprimir Y no display
	    li    $t1, 0x5A                    # LETRA Z
	    beq   $s4, $t1, car_Z              # desvia para imprimir Z no display
	    li    $t1, 0x20                    # ESPACO
	    beq   $s4, $t1, car_ESPACO         # desvia para imprimir ESPACO no display
	    li    $t1, 0x5F                    # UNDERLINE
	    beq   $s4, $t1, car_UNDERLINE      # desvia para imprimir UNDERLINE no display
	    li    $t1, 0x3A                    # DOIS PONTOS
	    beq   $s4, $t1, car_DPONTOS	       # desvia para imprimir : no display
	    
car_A:
	    la    $s7, sprite
	    add   $s6, $s7, $zero              # endereco da letra A esta no comeco do sprite
	    # por isso adicionamos 0 ao endereco de "sprite" para obter o seu endereco efetivo
	    li    $s0, 0
	    li    $s1, 0
	    lw    $s5, 0($s6)
	    j     imprime_linha
car_B:
	    la    $s7, sprite
	    add   $s6, $s7, 4                 # endereco efetivo da letra B
	    li    $s0, 0
	    li    $s1, 0
	    lw    $s5, 0($s6)
	    j     imprime_linha
car_C:
	    la    $s7, sprite
	    add   $s6, $s7, 8                 # endereco efetivo da letra C
	    li    $s0, 0
	    li    $s1, 0
	    lw    $s5, 0($s6)
	    j     imprime_linha	    
car_D:
	    la    $s7, sprite
	    add   $s6, $s7, 12                # endereco efetivo da letra D
	    li    $s0, 0
	    li    $s1, 0
	    lw    $s5, 0($s6)
	    j     imprime_linha
car_E:
	    la    $s7, sprite
	    add   $s6, $s7, 16                # endereco efetivo da letra E
	    li    $s0, 0
	    li    $s1, 0
	    lw    $s5, 0($s6)
	    j     imprime_linha
car_F:
	    la    $s7, sprite
	    add   $s6, $s7, 20                # endereco efetivo da letra F
	    li    $s0, 0
	    li    $s1, 0
	    lw    $s5, 0($s6)
	    j     imprime_linha
car_G:
	    la    $s7, sprite
	    add   $s6, $s7, 24                # endereco efetivo da letra G
	    li    $s0, 0
	    li    $s1, 0
	    lw    $s5, 0($s6)
	    j     imprime_linha
car_H:
	    la    $s7, sprite
	    add   $s6, $s7, 28                # endereco efetivo da letra H
	    li    $s0, 0
	    li    $s1, 0
	    lw    $s5, 0($s6)
	    j     imprime_linha
car_I:
	    la    $s7, sprite
	    add   $s6, $s7, 32                # endereco efetivo da letra I
	    li    $s0, 0
	    li    $s1, 0
	    lw    $s5, 0($s6)
	    j     imprime_linha
car_J:
	    la    $s7, sprite
	    add   $s6, $s7, 36                # endereco efetivo da letra J
	    li    $s0, 0
	    li    $s1, 0
	    lw    $s5, 0($s6)
	    j     imprime_linha
car_K:
	    la    $s7, sprite
	    add   $s6, $s7, 40                # endereco efetivo da letra K
	    li    $s0, 0
	    li    $s1, 0
	    lw    $s5, 0($s6)
	    j     imprime_linha
car_L:
	    la    $s7, sprite
	    add   $s6, $s7, 44                # endereco efetivo da letra L
	    li    $s0, 0
	    li    $s1, 0
	    lw    $s5, 0($s6)
	    j     imprime_linha
car_M:
	    la    $s7, sprite
	    add   $s6, $s7, 48                # endereco efetivo da letra M
	    li    $s0, 0
	    li    $s1, 0
	    lw    $s5, 0($s6)
	    j     imprime_linha
car_N:
	    la    $s7, sprite
	    add   $s6, $s7, 52                # endereco efetivo da letra N
	    li    $s0, 0
	    li    $s1, 0
	    lw    $s5, 0($s6)
	    j     imprime_linha
car_O:
	    la    $s7, sprite
	    add   $s6, $s7, 56                # endereco efetivo da letra O
	    li    $s0, 0
	    li    $s1, 0
	    lw    $s5, 0($s6)
	    j     imprime_linha
car_P:
	    la    $s7, sprite
	    add   $s6, $s7, 60                # endereco efetivo da letra P
	    li    $s0, 0
	    li    $s1, 0
	    lw    $s5, 0($s6)
	    j     imprime_linha
car_Q:
	    la    $s7, sprite
	    add   $s6, $s7, 64                # endereco efetivo da letra Q
	    li    $s0, 0
	    li    $s1, 0
	    lw    $s5, 0($s6)
	    j     imprime_linha
car_R:
	    la    $s7, sprite
	    add   $s6, $s7, 68                # endereco efetivo da letra R
	    li    $s0, 0
	    li    $s1, 0
	    lw    $s5, 0($s6)
	    j     imprime_linha
car_S:
	    la    $s7, sprite
	    add   $s6, $s7, 72                # endereco efetivo da letra S
	    li    $s0, 0
	    li    $s1, 0
	    lw    $s5, 0($s6)
	    j     imprime_linha
car_T:
	    la    $s7, sprite
	    add   $s6, $s7, 76                # endereco efetivo da letra T
	    li    $s0, 0
	    li    $s1, 0
	    lw    $s5, 0($s6)
	    j     imprime_linha
car_U:
	    la    $s7, sprite
	    add   $s6, $s7, 80                # endereco efetivo da letra U
	    li    $s0, 0
	    li    $s1, 0
	    lw    $s5, 0($s6)
	    j     imprime_linha
car_V:
	    la    $s7, sprite
	    add   $s6, $s7, 84                # endereco efetivo da letra V
	    li    $s0, 0
	    li    $s1, 0
	    lw    $s5, 0($s6)
	    j     imprime_linha
car_W:
	    la    $s7, sprite
	    add   $s6, $s7, 88                # endereco efetivo da letra W
	    li    $s0, 0
	    li    $s1, 0
	    lw    $s5, 0($s6)
	    j     imprime_linha
car_X:
	    la    $s7, sprite
	    add   $s6, $s7, 92                # endereco efetivo da letra X
	    li    $s0, 0
	    li    $s1, 0
	    lw    $s5, 0($s6)
	    j     imprime_linha
car_Y:
	    la    $s7, sprite
	    add   $s6, $s7, 96                # endereco efetivo da letra Y
	    li    $s0, 0
	    li    $s1, 0
	    lw    $s5, 0($s6)
	    j     imprime_linha
car_Z:
	    la    $s7, sprite
	    add   $s6, $s7, 100               # endereco efetivo da letra Z
	    li    $s0, 0
	    li    $s1, 0
	    lw    $s5, 0($s6)
	    j     imprime_linha
car_ESPACO:
	    la    $s7, sprite
	    add   $s6, $s7, 104               # endereco efetivo do ESPACO
	    li    $s0, 0
	    li    $s1, 0
	    lw    $s5, 0($s6)
	    j     imprime_linha	    
car_UNDERLINE:
	    la    $s7, sprite
	    add   $s6, $s7, 108               # endereco efetivo do UNDERLINE
	    li    $s0, 0
	    li    $s1, 0
	    lw    $s5, 0($s6)
	    j     imprime_linha	    
car_DPONTOS:
	    la    $s7, sprite
	    add   $s6, $s7, 112               # endereco efetivo dos :
	    li    $s0, 0
	    li    $s1, 0
	    lw    $s5, 0($s6)
	    j     imprime_linha	

marca_pixel:
	    jal   put_pixel
	    j     flag_return