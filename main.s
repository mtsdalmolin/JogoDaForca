#############################################################################################
# Trabalho 1 de Organizacao de Computadores
# Aluno: Matheus Dalmolin da Silva
# Objetivo: Implementar jogo da forca na linguagem Assembly
#
# Historico de atualizacoes:
#  - 23/05/2018 - Comeco do desenvolvimento do trabalho
#  - 23/05/2018 - Funcoes de imprimir o boneco e pegar a palavra do buffer prontas
#  - 24/05/2018 - Esclarecimento de duvidas com o professor
#  - 25/05/2018 - Funcao para imprimir uma palavra no Bitmap Display pronta
#  - 26/05/2018 - Implementacao da logica principal do jogo
#  - 27/05/2018 - Funcoes que desempenham a logica principal do jogo prontas
#  - 28/05/2018 - Funcoes para checar letras repetidas e impressoes das mensagens no Display MMIO
#  - 28/05/2018 - Trabalho concluido
#  - 30/05/2018 - Conclusao do relatorio e entrega do trabalho
#
#############################################################################################
#
#        | 24($sp) | <- quantidade de vidas
#        | 20($sp) | <- tamanho da palavra
#        | 16($sp) | <- cor dos caracteres da palavra
#        | 12($sp) | <- endereco y para imprimir a palavra
#        |  8($sp) | <- endereco x para imprimir a palavra
#        |  4($sp) | <- endereco y para imprimir estrutura da forca
#        |  0($sp) | <- endereco x para imprimir estrutura da forca
#
##############################################################################################
#*******************************************************************************
#        1         2         3         4         5         6         7         8
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
#           M     O                            #
.text
.globl main
.globl encerra_programa
.globl dm
.globl letra
.globl jogador_ganhou
.eqv servico_termina_programa 		17

main:
# prologo
	    addi  $sp, $sp, -28
# corpo do procedimento
	    li    $t0, 20                      # carrega valor inicial de x para impressao dos caracteres da palavra a ser adivinhada
	    li    $t1, 95                      # carrega valor inicial de y para impressao dos caracteres da palavra a ser adivinhada
	    li    $t2, 0x00babaca              # carrega valor da cor para impressao dos caracteres da palavra a ser adivinhada
	    sw    $t0, 8($sp)                  # salva na memoria o valor inicial de x
	    sw    $t1, 12($sp)                 # salva na memoria o valor inicial de y
	    sw    $t2, 16($sp)                 # salva na memoria o valor da cor
            li    $t0, 0                       # carrega o numero inicial de vidas do usuario
            sw    $t0, 24($sp)                 # salva na memoria o numero inicial de vidas do usuario
	    
            jal   zera_palavra                 # chama o procedimento para zerar o espaco da palavra reservado na memoria
	    jal   imprime_info_tela            # chama o procedimento para imprimir o nome do jogo e "PALAVRA:"

	    jal   abre_leitura                 # chama o procedimento para abrir o arquivo e armazenar as palavras no buffer
	    
            jal   zera_palavra                 # zera a palavra de novo antes de colocar outra no mesmo endereco
	    jal   pega_palavra                 # pega uma palavra aleatoria localizada no buffer
	    
	    jal   tamanho_palavra              # chama o procedimento para calcular o tamanho da palavra que foi sorteada
            sw    $v0, 20($sp)                 # guarda o retorno da tamanho_palavra na pilha
            
            # carrega as posicoes da tela para imprimir a palavra
	    lw    $a0, 8($sp)
	    lw    $a1, 12($sp)
	    lw    $a2, 16($sp)
	    jal   imprime_palavra              # chama o procedimento para imprimir a palavra
	    # em primeira instancia, soh serao impressos UNDERLINES, pois o jogador soh sabe
	    # o numero de caracteres que a palavra tem
roda_jogo:
            jal   imprime_informe_letra        # imprime a mensagem no Display MMIO
            li    $v0, 0
	    jal   le_teclado                   # chama o procedimento para ler a entrada do teclado
	    jal   verifica_letra_digitada      # verifica se a letra digitada ja foi digitada anteriormente
	    blt   $v0, 0, roda_jogo            # caso ja tenha sido digitada ($v0 < 0), volta para o roda_jogo
	    jal   adivinha_letra               # marca a letra digitada na palavra nas devidas posicoes
	    jal   guarda_letra_digitada        # guarda a letra digitada
	    jal   imprime_letras_erros         # imprime as letras erradas no Display MMIO
	    # carrega as posicoes da tela para imprimir a palavra
	    lw    $a0, 8($sp)
	    lw    $a1, 12($sp)
	    lw    $a2, 16($sp)
	    jal   imprime_palavra              # imprime a palavra no Bitmap Display
	    jal   compara_palavra              # verifica se a palavra esta completa
	    lw    $a0, 20($sp)                 # carrega $a0 com o tamanho da palavra
	    beq   $v0, $a0, desconta_vida      # se $v0 tiver o mesmo tamanho da palavra, 
	                                       # quer dizer que nenhuma letra da palavra 
	                                       # era igual a digitada
	    j     roda_jogo
return_desconta_vida:
            lw    $t1, 24($sp)
            beq   $t1, 1, vida1
return_vida1:
            beq   $t1, 2, vida2
return_vida2:
            beq   $t1, 3, vida3
return_vida3:
            beq   $t1, 4, vida4
return_vida4:
            beq   $t1, 5, vida5
	    j     roda_jogo
encerra_programa:
# epilogo
	    addi  $sp, $sp, 28
      	    li    $a0, 0
      	    li    $v0, servico_termina_programa
      	    syscall
      	    
desconta_vida:
            lw    $t1, 24($sp)
            addi  $t1, $t1, 1
            sw    $t1, 24($sp)
            j      return_desconta_vida
            
vida1:
            jal   desenha_forca
            sw    $v0, 0($sp)
            sw    $v1, 4($sp)
            j     return_vida1
vida2:
            lw    $a0, 0($sp)
            lw    $a1, 4($sp)
            jal   desenha_cabeca
            sw    $v0, 0($sp)                  # salva endereco x embaixo da cabeca
	    sw    $v1, 4($sp)                  # salva endereco y embaixo da cabeca
            j     return_vida2
vida3:
	    lw    $a0, 0($sp)                  # pega o endereço embaixo da cabeça p/ ter referência
	    lw    $a1, 4($sp)                  # quando for desenhar os bracos e o corpo
	    li    $a2, 0x00ffffff
	    jal   desenha_membro_esq
	    lw    $a0, 0($sp)                  # resgata endereco x embaixo da cabeca p/ imprimir braco direito
	    lw    $a1, 4($sp)                  # resgata endereco y embaixo da cabeca p/ imprimir braco esquerdo
	    jal   desenha_membro_dir           # chama procedimento p/ imprimir braco esquerdo
            j     return_vida3
vida4:
	    lw    $a0, 0($sp)                  # resgata endereco x embaixo da cabeca p/ imprimir corpo
	    lw    $a1, 4($sp)                  # resgata endereco y embaixo da cabeca p/ imprimir corpo
	    li    $a2, 0x00ffffff
	    jal   desenha_corpo                #chama procedimento p/ imprimir corpo
	    sub   $v1, $v1, 1                  # ajusta o endereco de y pra imprimir as pernas
	    sw    $v0, 0($sp)                  # guarda na pilha o endereco de x do final do corpo
	    sw    $v1, 4($sp)                  # guarda na pilha o endereco de y do final do corpo
            j     return_vida4
vida5:
	    lw    $a0, 0($sp)                  # resgata endereco da posicao x do final do corpo
	    lw    $a1, 4($sp)                  # resgata endereco da posicao y do final do corpo
            li    $a2, 0x00ffffff
            jal   desenha_membro_esq           # chama procedimento p/ imprimir perna esquerda
	    lw    $a0, 0($sp)                  # resgata endereco da posicao x do final do corpo
	    lw    $a1, 4($sp)                  # resgata endereco da posicao y do final do corpo
	    jal   desenha_membro_dir           # chama procedimento p/ imprimir perna direita
            j     imprime_resposta
imprime_resposta:
# corpo do procedimento
            la    $t0, palavra
            la    $t1, palavra_adivinha
            lw    $t2, 20($sp)
            li    $t4, 0
loop_imprime_resposta:
            # salva no endereco de palavra os caracteres de palavra_adivinha
            lb    $t3, 0($t1)
            sb    $t3, 0($t0)
            addi  $t0, $t0, 1
            addi  $t1, $t1, 1
            addi  $t4, $t4, 1
            beq   $t4, $t2, encerra_imprime_resposta
            j     loop_imprime_resposta
encerra_imprime_resposta:
# epilogo
            j     mostra_resposta        
            
mostra_resposta:
            # resgata os valores de x e y da tela para imprimir a palavra
            lw    $a0, 8($sp)
            lw    $a1, 12($sp)
            li    $a2, 0x00ff0000                  # armazena em $a2 o codigo em hexa da cor vermelha
            jal   imprime_palavra                  # imprime a resposta em vermelho
            jal   imprime_voce_perdeu              # imprime a mensagem de derrota no Display MMIO
            j     encerra_programa                 # pula para o final do programa
            
jogador_ganhou:
            jal   imprime_voce_ganhou              # imprime no Display MMIO a mensagem de vitoria
            j     encerra_programa                 # pula para o final do programa

.data
dm:                 .space 65536                   # memoria do display 128*128*4 = 65536
letra:              .space 1
