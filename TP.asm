SECTION INTVEC

B main


SECTION CODE

main

;CREE PILE
LDR SP,=PILE1
ADD SP, SP, #0x78


MOV R10, #10;Juste stock 10 pour x10
LDR R1, =calc;Adresse debut calcul


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

CMP R2, #0x20
PUSHEQ {R5}
MOVEQ R5, #0
;Ou alors BEQ whileSep et ADD au lieu de ADDNE

MUL R5, R5, R10
ADDNE R5, R5, R2

ADD R1, R1, #1
B whileSep
;FIN whileSep

executeCalc
LDRB R2, [R1]

CMP R2, #0x2a;*
BLEQ multiplie

CMP R2, #0x2b;+
BLEQ additionne

CMP R2, #0x2d;-
BLEQ soustrait

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

;divise
;POP {R6}
;POP {R7}
;DIV R0, R6, R7
;PUSH {R0}
;BX LR

;Fonction decode chiffres ASCII
decodeChiffreASCII
;PUSH {R0, R1, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14};Sauvegarde contexte
CMP R2, #0x30
BCS sup30
;POP {R0, R1, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14}
BX LR;Sors de la fonction si input < 0x30


sup30
CMP R2, #0x39
BLS valeurOK
;POP {R0, R1, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14}
BX LR;Sors de la fonction si input > 0x39

valeurOK
SUB R2, R2, #0x30
;POP {R0, R1, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14}
BX LR;Sors de la fonction après avoir convertit input
;Fin decodeChiffreASCII

fin

B fin

SECTION DATA

PILE1 ALLOC32 30

;calc ASSIGN8 2, 0x20, 4, 0x20, 3, 0x20, 7, 0x20, 0x2b, 0x2a, 0x2a, 0x20;Ajout de 0x20 pour conclure le truc ?

calc ASSIGN8 0x31, 0x30, 0x20, 0x32, 0x30, 0x20, 0x2b, 0x20
