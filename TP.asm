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
POP {R0}

vraieFin
B vraieFin

;Convertit caractères en int et place dans PILE1 chaque int
whileSep
LDRB R2, [R1];Charge premier octet
BL decodeChiffreASCII

CMP R2, #0x2a;*
BEQ executeCalc
CMP R2, #0x2b;+
BEQ executeCalc
CMP R2, #0x2d;-
BEQ executeCalc
CMP R2, #0x2f;/
BEQ executeCalc
CMP R2, #0x5e;puissance
BEQ executeCalc
CMP R2, #0x5f;negatif
MOVEQ R12, #0x01


CMP R2, #0x20
CMPEQ R12, #0x01
MOVEQ R12, #-1
MULEQ R5, R5, R12
MOVEQ R12, #0x00
CMP R2, #0x20
PUSHEQ {R5}
MOVEQ R5, #0
;Ou alors BEQ whileSep et ADD au lieu de ADDNE

CMPNE R2, #0x5f
MUL R5, R5, R10
ADDNE R5, R5, R2

ADD R1, R1, #1
B whileSep
;FIN whileSep

executeCalc
MOV R0, #0x00;R0 est un registre tampon utilisé dans les différentes fonctions
LDRB R2, [R1]

CMP R2, #0x2a;*
BLEQ multiplie

CMP R2, #0x2b;+
BLEQ additionne

CMP R2, #0x2d;-
BLEQ soustrait

CMP R2, #0x5e;^
POPEQ {R7}
POPEQ {R6}
MOVEQ R0, R6
BLEQ puissance

CMP R2, #0x2f;/
POPEQ {R7}
POPEQ {R6}
BLEQ divise

CMP R2, #0x20
BLEQ fin

ADD R1, R1, #1
B executeCalc
;FIN executeCALC


additionne
POP {R6}
POP {R7}
ADD R0, R6, R7
PUSH {R0}
BX LR

soustrait
POP {R6}
POP {R7}
SUB R0, R7, R6
PUSH {R0}
BX LR

multiplie
POP {R6}
POP {R7}
MUL R0, R6, R7
PUSH {R0}
BX LR

divise
CMP R7, R6
SUBGE R7, R7, R6
ADDGE R0, R0, #0x01
BGE divise
PUSH {R0}
BX LR

puissance
CMP R7, #1
PUSHEQ {R0}
BXEQ LR
SUB R7, R7, #1
MUL R0, R0, R6
B puissance


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


;calc ASSIGN8 0x32, 0x20, 0x34, 0x20, 0x33, 0x20, 0x37, 0x20, 0x2b, 0x2a, 0x2a, 0x20;

;calc ASSIGN8 0x31, 0x30, 0x20, 0x32, 0x30, 0x20, 0x2b, 0x20;1E

;calc ASSIGN8 0x36, 0x20, 0x35, 0x20, 0x5e, 0x20;1E60

;calc ASSIGN8 0x32, 0x20, 0x33, 0x20, 0x37, 0x20, 0x2b, 0x2f, 0x20;0x5

calc ASSIGN8 0x35, 0x20, 0x32, 0x35, 0x20, 0x2f, 0x20;0x5