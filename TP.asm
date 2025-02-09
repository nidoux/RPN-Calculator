SECTION INTVEC

B main


SECTION CODE

main

;CREE PILE
LDR SP,=PILE
ADD SP, SP, #0x78

MOV R10, #10;Juste stock 10 pour x10
LDR R1, =calc;Adresse debut calcul

B whileSep

fin
B fin

;DEBUT whileSep
whileSep;Lit chaque insctruction du calcul (1 octet), place dans la pile les chiffres concaténés et effectue les calculs
MOV R0, #0x00;R0 est un registre tampon utilisé dans les différentes fonctions
LDRB R2, [R1];Charge premier octet dans R2
BL decodeChiffreASCII;Convertit les chiffres ASCII si besoin

CMP R2, #0x3d;= symbole de fin d'opération
POPEQ {R0};On sors le résultat du calcul complet de la pile vers R0 pour une meilleure lisibilité
BEQ fin

CMP R2, #0x2a;*
ADDEQ R4, R4, #1;Signal qu'une operation a eu lieu
ADDEQ R1, R1, #1;Passe à l'octet suivant du calcul
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
MOVEQ R12, #0x01;R12 signal un nombre négatif pour faire le nécessaire au PUSH dans la pile
ADDEQ R1, R1, #1
BEQ whileSep

;DEBUT ESPACE
CMP R2, #0x20;espace (separateur)

CMPEQ R12, #0x01;Verif si nombre est signalé comme négatif
MOVEQ R12, #-1
MULEQ R5, R5, R12;On passe le nombre en négatif

CMP R2, #0x20;Reverif
CMPEQ R4, #0;Si aucune opération n'a eu lieu avant, R4=0, on peut PUSH le nombre
PUSHEQ {R5}
MOVEQ R5, #0;Reset R5 pour le prochain nombre
MOVEQ R12, #0x00;Reset R12 pour le prochain nombre

CMP R2, #0x20;Reverif
MOVEQ R4, #0;Reset R0 pour 
ADD R1, R1, #1;Passe à l'octet suivant du calcul
BEQ whileSep
;FIN ESPACE

MUL R5, R5, R10;On fait x10 pour passer à la dizaine suivante
ADD R5, R5, R2;On ajoute le chiffre courant

B whileSep
;FIN whileSep


additionne;0x2b
POP {R7}
POP {R6}
ADD R0, R6, R7
PUSH {R0}
B whileSep

soustrait;0x2d
POP {R7}
POP {R6}
SUB R0, R6, R7
PUSH {R0}
B whileSep

multiplie;Ox2a
POP {R7}
POP {R6}
MUL R0, R6, R7
PUSH {R0}
B whileSep

;DEBUT DIVISION
divise;0x2f
CMP R6, #0
BGE numerateurPositif
MOVLT R12, #-1;Registre tampon à -1 dans le cas d'une division negative
MULLT R6, R6, R12
BLT numerateurNegatif

numerateurPositif
CMP R7, #0
BEQ fin;Si on divise par 0, on termine immédiatement le programme
MOVGE R12, #1
MOVLT R12, #-1
MULLT R7, R7, R12;On prend la valeur positive
B executeDivision

numerateurNegatif
CMP R7, #0
BEQ fin;Si on divise par 0, on termine immédiatement le programme
MULLT R7, R7, R12;R12 déjà à -1 car numerateur negatif
MOVLT R12, #1
B executeDivision

executeDivision;Execute la division en valeur absolue
CMP R6, R7
SUBGE R6, R6, R7
ADDGE R0, R0, #0x01
BGE executeDivision
MUL R0, R0, R12;Rétabli le signe négatif si besoin
PUSH {R0}
B whileSep
;FIN DIVISION

puissance;0x5e
CMP R7, #1
PUSHLE {R0}
BLE whileSep
SUB R7, R7, #1
MUL R0, R0, R6
B puissance

modulo;0x25
CMP R6, R7
SUBGE R6, R6, R7
BGE modulo
PUSH {R6}
B whileSep

;DEBUT decodeChiffreASCII
decodeChiffreASCII
CMP R2, #0x30
BGE inf39
BX LR;Sors de la fonction si input < 0x30

inf39
CMP R2, #0x39
BLE valeurOK
BX LR;Sors de la fonction si input > 0x39

valeurOK
SUB R2, R2, #0x30;Décalage de -30 entre chiffre ASCII et décimal
BX LR;Retour à l'instruction suivant l'appel à la fonction
;FIN decodeChiffreASCII


SECTION DATA

PILE ALLOC32 30

calc ASSIGN8 0x5f, 0x32, 0x20, 0x33, 0x20, 0x37, 0x20, 0x2b, 0x20, 0x2a, 0x20, 0x32, 0x20, 0x2f, 0x3d
;calc ASSIGN8 0x5f, 10, 0x20, 4, 0x20, 0x2a, 0x3d
;calc ASSIGN8 0x38, 0x20, 0x5f, 0x32, 0x20, 0x2f, 0x20, 0x5f, 0x37, 0x20, 0x2a, 0x3d;3 -0 /

;calc ASSIGN8 0x5f, 0x31, 0x20, 0x33, 0x20, 0x5e, 0x20, 0x3d

;calc ASSIGN8 0x5f, 0x33, 0x37, 0x20, 0x33, 0x20, 0x2a, 0x20, 0x5f, 0x35, 0x20, 0x2f, 0x3d;(-37*3)/-5
;calc ASSIGN8 0x33, 0x33, 0x20, 0x32, 0x20, 0x2a, 0x20, 0x33, 0x20, 0x2f, 0x3d;33*2/3

;calc ASSIGN8 0x5f, 0x33, 0x33, 0x20, 0x32, 0x20, 0x2a, 0x20, 0x32, 0x20, 0x2a, 0x3d;33*2*2

;calc ASSIGN8 0x5f, 0x34, 0x20, 0x36, 0x20, 0x2d, 0x20, 0x37, 0x20, 0x2a, 0x3d

;calc ASSIGN8 0x32, 0x30, 0x20, 0x36, 0x20, 0x2d, 0x20, 0x32, 0x20, 0x2f, 0x20, 0x33, 0x20, 0x2b, 0x20, 0x34, 0x20, 0x2a, 0x3d

;calc ASSIGN8 0x32, 0x20, 0x34, 0x20, 0x33, 0x20, 0x37, 0x20, 0x2b, 0x2a, 0x2a, 0x3d;2 4 3 7  + * *

;calc ASSIGN8 0x31, 0x30, 0x20, 0x32, 0x30, 0x20, 0x2b, 0x3d;1E

;calc ASSIGN8 0x36, 0x20, 0x35, 0x20, 0x5e, 0x3d;1E60

;calc ASSIGN8 0x32, 0x35, 0x20, 0x35, 0x20, 0x2f, 0x3d;0x5


;calc ASSIGN8 6, 0x20, 0x5f, 2, 0, 0x20, 0x2b, 0x3d
;calc ASSIGN8 0x33, 0x20, 0x37, 0x20, 0x2b, 0x20, 0x5f, 0x32, 0x20, 0x2f, 0x3d;(3+7)/2

;calc ASSIGN8 0x36, 0x20, 0x32, 0x20, 0x2f, 0x20, 0x37, 0x20, 0x2b, 0x3d;6 2 / 3 +

;calc ASSIGN8 1, 0, 0, 0x20, 3, 0, 0x20, 2, 0, 0x20, 0x2b, 0x2f, 0x3d;100/(30+20)
