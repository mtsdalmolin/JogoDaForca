#*******************************************************************************
#        1         2         3         4         5         6         7         8
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
#           M     O                            #
.text
.globl imprime_info_tela
.globl imprime_informe_letra
.globl imprime_letras_erros
.globl imprime_voce_perdeu
.globl imprime_voce_ganhou

# procedimento para imprimir as informacoes iniciais do jogo no Bitmap Display.
imprime_info_tela:
# prologo
	    addi  $sp, $sp, -4
	    sw    $ra, 0($sp)
# corpo do procedimento
	    la    $t0, string_cabecalho
	    la    $t1, palavra
copia_string_cabecalho:
	    lb    $t2, 0($t0)
	    sb    $t2, ($t1)
	    add   $t0, $t0, 1
	    add   $t1, $t1, 1
	    beq   $t2, 0, imprime_string_cabecalho
	    j     copia_string_cabecalho
imprime_string_cabecalho:   
	    li    $a0, 32
	    li    $a1, 5
	    li    $a2, 0x000a0aff
	    jal   imprime_palavra

	    la    $t0, string_palavra
	    la    $t1, palavra
copia_string_palavra:
	    lb    $t2, 0($t0)
	    sb    $t2, ($t1)
	    add   $t0, $t0, 1
	    add   $t1, $t1, 1
	    beq   $t2, 0, imprime_string_palavra
	    j     copia_string_palavra
imprime_string_palavra:   
	    li    $a0, 15
	    li    $a1, 85
	    li    $a2, 0x00baba00
	    jal   imprime_palavra
# epilogo
	    lw    $ra, 0($sp)
	    addi  $sp, $sp, 4
	    jr    $ra
	    
# procedimento para imprimir no Display MMIO Simulator a mensagem para o usuário digitar
# uma letra.
imprime_informe_letra:
# corpo do procedimento
            la    $t0, msg_informe_letra
            li    $t1, 0xFFFF000C
loop_informe_letra:
            lb    $t2, 0($t0)
            sb    $t2, 0($t1)
            beq   $t2, 0, encerra_informe_letra
            addi  $t0, $t0, 1
            j     loop_informe_letra
# epilogo
encerra_informe_letra:
            jr    $ra
            
# procedimento para imprimir no Display MMIO Simulator a mensagem de quais letras o usuário
# errou durante o jogo.
imprime_letras_erros:
# corpo do procedimento
            la    $t0, msg_letras_erros
            li    $t1, 0xFFFF000C
loop_msg_erros:
            lb    $t2, 0($t0)
            sb    $t2, 0($t1)
            beq   $t2, 0, letras_erros
            addi  $t0, $t0, 1
            j     loop_msg_erros
letras_erros:            
            la    $t0, letras_digitadas        # pega o endereco do vetor "letras_digitadas"
loop_letras_erros:                             # loop para percorrer e imprimir todas as
            lb    $t2, 0($t0)                  # letras contidas no vetor em questao
            beq   $t2, 0, proxima_linha
            sb    $t2, 0($t1)
            addi  $t0, $t0, 1
            j     loop_letras_erros
proxima_linha:
            la    $t3, quebra_de_linha
loop_proxima_linha:
            lb    $t4, 0($t3)
            beq   $t4, 0, encerra_letras_erros
            sb    $t4, 0($t1)
            addi  $t3, $t3, 1
            j     loop_proxima_linha
# epilogo
encerra_letras_erros:
            jr    $ra
            
# procedimento para imprimir a mensagem no Display MMIO Simulator que o usuário perdeu o jogo
imprime_voce_perdeu:
# corpo do procedimento
            la    $t0, msg_voce_perdeu
            li    $t1, 0xFFFF000C
loop_voce_perdeu:
            lb    $t2, 0($t0)
            sb    $t2, 0($t1)
            beq   $t2, 0, encerra_voce_perdeu
            addi  $t0, $t0, 1
            j     loop_voce_perdeu
# epilogo
encerra_voce_perdeu:
            jr    $ra
            
# procedimento para imprimir a mensagem no Dispaly MMIO Simulator que o usuário ganhou o jogo
imprime_voce_ganhou:
# corpo do procedimento
            la    $t0, msg_voce_ganhou
            li    $t1, 0xFFFF000C
loop_voce_ganhou:
            lb    $t2, 0($t0)
            sb    $t2, 0($t1)
            beq   $t2, 0, encerra_voce_ganhou
            addi  $t0, $t0, 1
            j     loop_voce_ganhou
# epilogo
encerra_voce_ganhou:
            jr    $ra
            

.data	    
string_palavra:             .asciiz "PALAVRA:"
string_cabecalho:           .asciiz "JOGO DA FORCA"
msg_informe_letra:          .asciiz "DIGITE UMA LETRA:\n"
msg_letras_erros:           .asciiz "ERROS:\n"
msg_voce_ganhou:            .asciiz "VOCE GANHOU!!!\n"
msg_voce_perdeu:            .asciiz "VOCE PERDEU!!!\n"
quebra_de_linha:            .asciiz "\n"
