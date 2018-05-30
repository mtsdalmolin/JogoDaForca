# JogoDaForca
# Trabalho 1 de Organização de Computadores
<b> Descrição do trabalho: </b>
O objetivo principal desse trabalho foi desenvolver o jogo da forca na linguagem assembly para o
MIPS, usando a ferramente MARS. Resumidamente, o programa deverá: <br/>
<b>(A)</b> Ler um arquivo com as palavras que serão utilizadas pelo jogo. Este arquivo deve conter pelo
menos 10 palavras não triviais. Não use todas as palavras com o mesmo número de letras. <br/>
<b>(B)</b> Colocar as palavras em ordem alfabética em uma lista encadeada. <br/>
<b>(C)</b> Sortear uma palavra. <br/>
<b>(D)</b> Solicitar ao jogador que tente adivinhar a palavra sorteada. O jogador deverá fornecer as letras
desta palavra. <br/>
<b>(E)</b> A cada erro será desenhado parte da forca na ferramenta bitmap display do programa MARS. <br/>
<b>(F)</b> Se a forca for desenhada antes da palavra ser completada, o jogador perde o jogo.

# INFORMAÇÕES IMPORTANTES PARA A COMPILAÇÃO E EXECUÇÃO DO JOGO:
- COMPILAR O JOGO SEMPRE DO ARQUIVO "main.s"; <br/>
- ANTES DE COMPILAR, IR EM "Settings" E MARCAR A OPÇÃO "Assemble all files in directory"; <br/>
- NÃO PODE CONTER NENHUM OUTRO ARQUIVO ".s" NA PASTA SEM SER OS ARQUIVOS DO JOGO, PODERÁ RESULTAR EM ALGUM ERRO DE COMPILAÇÃO, OU ATÉ ALGUM ERRO NO DECORRER DO JOGO; <br/>
- SOMENTE USAR LETRAS MAIÚSCULAS ENQUANTO ESTIVER JOGANDO, CASO USE LETRAS MINÚSCULAS, SERÁ CONTABILIZADO UM ERRO NO JOGO; <br/>
- APÓS UMA PARTIDA, RESETAR OS DOIS DISPLAYS, DISCONECTAR E RECONECTAR O KEYBOARD AND DISPLAY MMIO SIMULATOR, PARA QUE NÃO HAJA BUGS NA NOVA EXECUÇÃO DO PROGRAMA; <br/>
- SE ALGUMA TECLA SEM SER LETRAS FOR DIGITADA (EX.: ENTER, BACKSPACE, SPACE, ETC) SERÁ CONTABILIZADO UM ERRO NO JOGO.
