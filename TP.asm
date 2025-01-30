;Chiffres EN ASCII


SECTION INTVEC

B main


SECTION CODE

main

;CREE PILE
LDR SP,=PILE1
ADD SP, SP, #0x3c


MOV R10, #10;Juste stock 10 pour x10
LDR R1, =calc;Adresse debut calcul


;Convertit caractères en int et place dans PILE1 chaque int
whileSep
LDRB R2, [R1];Charge premier octet

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

fin

B fin

SECTION DATA

PILE1 ALLOC32 15

calc ASSIGN8 4, 0x20, 3, 0x20, 7, 0x20, 0x2b, 0x2a, 0x20;Ajout de 0x20 pour conclure le truc ?


;Fonction decodeASCII avec R0 = input:

MOV R0, #0x22

BL decodeChiffreASCII;Appel de la fonction
B fin


;Fonction decode chiffres ASCII
decodeChiffreASCII
CMP R0, #0x30
BCS sup30
BX LR;Sors de la fonction si input < 0x30


sup30
CMP R0, #0x39
BLS valeurOK
BX LR;Sors de la fonction si input > 0x39

valeurOK
SUB R0, R0, #0x30
BX LR;Sors de la fonction après avoir convertit input
;Fin decodeChiffreASCII