SECTION INTVEC

B main


SECTION CODE

main

;CREE PILE
LDR SP,=PILE1
ADD SP, SP, #0x78


MOV R10, #10;Juste stock 10 pour x10
LDR R1, =calc;Adresse debut calcul

B whileSep

fin
B fin

;Convertit caractères en int et place dans PILE1 chaque int
whileSep
MOV R0, #0x00;R0 est un registre tampon utilisé dans les différentes fonctions
LDRB R2, [R1];Charge premier octet
BL decodeChiffreASCII

CMP R2, #0x3d;= fin d'opération
POPEQ {R0}
BEQ fin

CMP R2, #0x2a;*
ADDEQ R4, R4, #1
ADDEQ R1, R1, #1
BEQ multiplie

CMP R2, #0x2b;+
ADDEQ R4, R4, #1
ADDEQ R1, R1, #1
BEQ additionne

CMP R2, #0x2d;-
ADDEQ R4, R4, #1
ADDEQ R1, R1, #1
BEQ soustrait

CMP R2, #0x2f;/
POPEQ {R7}
POPEQ {R6}
ADDEQ R4, R4, #1
ADDEQ R1, R1, #1
BEQ divise

CMP R2, #0x5e;puissance
POPEQ {R7}
POPEQ {R6}
MOVEQ R0, R6
ADDEQ R4, R4, #1
ADDEQ R1, R1, #1
BEQ puissance

CMP R2, #0x25;modulo
POPEQ {R7}
POPEQ {R6}
ADDEQ R4, R4, #1
ADDEQ R1, R1, #1
BLEQ modulo

CMP R2, #0x5f;operateur negatif
MOVEQ R12, #0x01;PEUT ETRE UTILISER R0 EN REG TAMPON
ADDEQ R1, R1, #1
BEQ whileSep

CMP R2, #0x20;espace (separateur)

CMPEQ R12, #0x01;Verif si nombre est signalé comme négatif
MOVEQ R12, #-1
MULEQ R5, R5, R12;On passe le nombre en négatif

CMP R2, #0x20;Reverif
CMPEQ R4, #0
PUSHEQ {R5}
MOVEQ R5, #0;Reset R5 pour le prochain calcul
MOVEQ R12, #0x00;Reset R12 pour le prochain nombre

CMP R2, #0x20
MOVEQ R4, #0


ADD R1, R1, #1

BEQ whileSep


MUL R5, R5, R10
ADD R5, R5, R2



B whileSep
;FIN whileSep


additionne
POP {R7}
POP {R6}
ADD R0, R6, R7
PUSH {R0}
B whileSep

soustrait
POP {R7}
POP {R6}
SUB R0, R6, R7
PUSH {R0}
B whileSep

multiplie
POP {R7}
POP {R6}
MUL R0, R6, R7
PUSH {R0}
B whileSep

divise
CMP R6, R7
SUBGE R6, R6, R7
ADDGE R0, R0, #0x01
BGE divise
PUSH {R0}
B whileSep

puissance
CMP R7, #1
PUSHEQ {R0}
BEQ whileSep
SUB R7, R7, #1
MUL R0, R0, R6
B puissance

modulo
CMP R6, R7
SUBGE R6, R6, R7
BGE modulo
PUSH {R6}
B whileSep

;Fonction decode chiffres ASCII
decodeChiffreASCII
;PUSH {R0, R1, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14};Sauvegarde contexte
CMP R2, #0x30
BCS inf39
;POP {R0, R1, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14}
BX LR;Sors de la fonction si input < 0x30


inf39
CMP R2, #0x39
BLS valeurOK
;POP {R0, R1, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14}
BX LR;Sors de la fonction si input > 0x39

valeurOK
SUB R2, R2, #0x30
;POP {R0, R1, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14}
BX LR;Sors de la fonction après avoir convertit input
;Fin decodeChiffreASCII


SECTION DATA

PILE1 ALLOC32 30


;calc ASSIGN8 0x32, 0x20, 0x34, 0x20, 0x33, 0x20, 0x37, 0x20, 0x2b, 0x2a, 0x2a, 0x3d;2 4 3 7  + * *

;calc ASSIGN8 0x31, 0x30, 0x20, 0x32, 0x30, 0x20, 0x2b, 0x3d;1E

;calc ASSIGN8 0x36, 0x20, 0x35, 0x20, 0x5e, 0x3d;1E60

;calc ASSIGN8 0x32, 0x35, 0x20, 0x35, 0x20, 0x2f, 0x3d;0x5


;calc ASSIGN8 6, 0x20, 0x5f, 2, 0, 0x20, 0x2b, 0x3d
;calc ASSIGN8 0x33, 0x20, 0x37, 0x20, 0x2b, 0x20, 0x32, 0x20, 0x2f, 0x3d;(3+7)/2

;calc ASSIGN8 0x36, 0x20, 0x32, 0x20, 0x2f, 0x20, 0x37, 0x20, 0x2b, 0x3d;6 2 / 3 +

;calc ASSIGN8 1, 0, 0, 0x20, 3, 0, 0x20, 2, 0, 0x20, 0x2b, 0x2f, 0x3d;100/(30+20)
