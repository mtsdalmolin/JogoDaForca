#*******************************************************************************
#        1         2         3         4         5         6         7         8
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
#           M     O                            #
.text
.globl desenha_forca
.globl desenha_cabeca
.globl desenha_membro_esq
.globl desenha_membro_dir
.globl desenha_corpo
.globl dm_largura
.globl sprite
.globl put_pixel

desenha_forca:
# prologo
	    addi  $sp, $sp, -4
	    sw    $ra, 0($sp)
# corpo do procedimento
	    li    $s0, 0
	    li    $a0, 15                      # posicao x inicial da forca
	    li    $a1, 75                      # posicao y inicial da forca
	    li    $a2, 0x00baba00              # codigo em hexa da cor amarela
haste_vertical:
# desenha haste vertical da forca
	    sub   $a1, $a1, 1                  # subtrai do y ateh que $s0 seja 55
	    jal   put_pixel                    # desenhando uma linha de 55 pixels
	    add   $s0, $s0, 1
	    blt   $s0, 55, haste_vertical
haste_horizontal:
# desenha haste horizontal da forca
	    add   $a0, $a0, 1                  # adiciona no x ateh que $s0 seja > 20
	    jal   put_pixel                    # desenhando uma linha de 35 pixels
	    sub   $s0, $s0, 1
	    bgt   $s0, 20, haste_horizontal
	    li    $s0, 0
segura_boneco:
	    add   $a1, $a1, 1                  # desenha ultima parte da forca
	    jal   put_pixel                    # adiciona no y ateh que $s0 seja 5
	    add   $s0, $s0, 1                  # desenhando uma linha de 5 pixels
	    blt   $s0, 5, segura_boneco
	    move  $v0, $a0                     # retorna os enderecos do final da forca
	    move  $v1, $a1                     # para continuar desenhando em futuras chamadas
	                                       # das funcoes para desenhar os modulos do boneco
# epilogo
	    lw    $ra, 0($sp)
	    addi  $sp, $sp, 4
	    jr    $ra
	    
	    
desenha_cabeca:
# prologo
	    addi  $sp, $sp, -4
	    sw    $ra, 0($sp)
# corpo do procedimento
            # desenha um circulo de raio 3
	    li    $a2, 0x00ffffff              # carrega a cor branca no $a2
	    add   $a1, $a1, 1
	    jal   put_pixel
	    add   $a0, $a0, 1
	    jal   put_pixel
	    add   $a0, $a0, 1
	    add   $a1, $a1, 1
	    jal   put_pixel
	    add   $a0, $a0, 1
	    add   $a1, $a1, 1
	    jal   put_pixel
	    add   $a1, $a1, 1
	    jal   put_pixel
	    add   $a1, $a1, 1
	    jal   put_pixel
	    add   $a1, $a1, 1
	    jal   put_pixel
	    sub   $a0, $a0, 1
	    add   $a1, $a1, 1
	    jal   put_pixel
	    sub   $a0, $a0, 1
	    add   $a1, $a1, 1
	    jal   put_pixel
	    sub   $a0, $a0, 1
	    jal   put_pixel
	    move  $v0, $a0                     # salva os enderecos abaixo do circulo para
	    move  $v1, $a1                     # seguir imprimindo corpo e bracos do boneco
	    sub   $a0, $a0, 1
	    jal   put_pixel
	    sub   $a0, $a0, 1
	    sub   $a1, $a1, 1
	    jal   put_pixel
	    sub   $a0, $a0, 1
	    sub   $a1, $a1, 1
	    jal   put_pixel
	    sub   $a1, $a1, 1
	    jal   put_pixel
	    sub   $a1, $a1, 1
	    jal   put_pixel
	    sub   $a1, $a1, 1
	    jal   put_pixel
	    add   $a0, $a0, 1
	    sub   $a1, $a1, 1
	    jal   put_pixel
	    add   $a0, $a0, 1
	    sub   $a1, $a1, 1
	    jal   put_pixel
# epilogo
	    lw   $ra, 0($sp)
	    addi $sp, $sp, 4
	    jr   $ra
	    
desenha_membro_esq:
# prologo
	    addi $sp, $sp, -4
	    sw   $ra, 0($sp)
# corpo do procedimento
	    li   $s0, 0
	    add  $a1, $a1, 1
mbresq:
	    jal  put_pixel                    # desenha uma linha diagonal para a esquerda
	    sub  $a0, $a0, 1                  # partindo do ponto de onde foi passado por
	    add  $a1, $a1, 1                  # parametro. Uso o mesmo procedimento para 
	    add  $s0, $s0, 1                  # imprimir braco e perna esquerda
	    blt  $s0, 8, mbresq
# epilogo
	    lw   $ra, 0($sp)
	    addi $sp, $sp, 4
	    jr   $ra
	    
desenha_membro_dir:
# prologo
	    addi $sp, $sp, -4
	    sw   $ra, 0($sp)
# corpo do procedimento
	    li   $s0, 0
	    add  $a1, $a1, 1
mbrdir:
	    jal  put_pixel                    # desenha uma linha diagonal para a direita
	    add  $a0, $a0, 1                  # partindo do ponto em que foi passado por
	    add  $a1, $a1, 1                  # parametro. Uso o mesmo procedimento para
	    add  $s0, $s0, 1                  # imprimir braco e perna destra
	    blt  $s0, 8, mbrdir
#epilogo
	    lw   $ra, 0($sp)
	    addi $sp, $sp, 4
	    jr   $ra
	    
desenha_corpo:
# prologo
	    addi $sp, $sp, -4
	    sw   $ra, 0($sp)
# corpo do procedimento
	    li   $s0, 0
	    add  $a1, $a1, 1
corpo:
	    jal  put_pixel
	    add  $a1, $a1, 1                 # desenha uma linha vertical partindo do ponto
	    add  $s0, $s0, 1                 # abaixo da cabeca do boneco
	    blt  $s0, 10, corpo
	    move $v0, $a0                    # mando para o retorno os enderecos de x e y
	    move $v1, $a1                    # do fim do corpo do boneco, para futuramente
	                                     # imprimir as pernas
# epilogo
	    lw   $ra, 0($sp)
	    addi $sp, $sp, 4
	    jr   $ra

put_pixel:
#
# parametros da funcao:
#           $a0: posicao x do pixel
#           $a1: posicao y do pixel
#           $a2: cor do pixel
#
#  ***PROCEDIMENTO DESENVOLVIDO PELO PROFESSOR GIOVANI BARATTO
#  Acabei usando o mesmo procedimento por falta de tempo para desenvolver um
#  procedimento proprio para marcar o pixel na tela.
#############################################################################################
# corpo do procedimento
            # desenha o pixel
            la    $t1, dm                  # $t1 <- endereço base da memoria de video
            la    $t0, dm_largura          # $t0 <- numero de pixels em uma unidade de pixels
            lw    $t2, 0($t0)              # $t2 <- numero de unidades de pixel na largura
            sll   $t3, $a0, 2              # $t3 <- x * 4, onde 4 eh numero de bytes por cor
            sll   $t4, $a1, 2              # $t4 <- y * 4, onde 4 eh numero de bytes por cor
            mul   $t4, $t4, $t2            # $t4 <- y * 4 * dm_largura
            add   $t4, $t4, $t3            # $t4 <- y * 4 * dm_largura + x*4
            add   $t4, $t4, $t1            # $t4 <- y * 4 * dm_largura + x*4 + dm_base_address
            sw    $a2, 0($t4)              # faz o pixel nas coordenadas (x,y) ter a cor RGB de $a2
# epílogo   
fim_put_pixel:
            jr    $ra

.data
dm_largura: .word 128
dm_altura: .word 128
dm_x_min: .word 0
dm_y_min: .word 0
dm_x_max: .word 127
dm_y_max: .word 127

sprite:
A:	.word 0x699F9900 # LETRA A
B:	.word 0xE9E99E00 # LETRA B
C:	.word 0x78888700 # LETRA C
D:	.word 0xE9999E00 # LETRA D
E:	.word 0xF8E88F00 # LETRA E
F:	.word 0xF8E88800 # LETRA F
G:	.word 0x698B9600 # LETRA G
H:	.word 0x99F99900 # LETRA H
I:	.word 0xE4444E00 # LETRA I
J:	.word 0xE222A400 # LETRA J
K:	.word 0x9ACA9900 # LETRA K
L:	.word 0x88888E00 # LETRA L
M:	.word 0x9FF99900 # LETRA M
N:	.word 0x9DDBB900 # LETRA N
O:	.word 0x69999600 # LETRA O
P:	.word 0xE99E8800 # LETRA P
Q:	.word 0x6999B700 # LETRA Q
R:	.word 0xE9ECA900 # LETRA R
S:	.word 0x78611E00 # LETRA S
T:	.word 0xE4444400 # LETRA T
U:	.word 0x99999F00 # LETRA U
V:	.word 0x99999600 # LETRA V
W:	.word 0x999FF900 # LETRA W
X:	.word 0x99669900 # LETRA X
Y:	.word 0x99966600 # LETRA Y
Z:	.word 0xF1248F00 # LETRA Z
ESPACO:	.word 0x00000000 # ESPACO
UND:    .word 0x0000000F # UNDERLINE
DPONTOS:.word 0x04404400 # DOIS PONTOS