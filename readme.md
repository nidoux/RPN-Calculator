# Reverse Polish Notation calculator in assembly for ARM7TDMI**

TP : https://github.com/dginhac/esirem-archi/blob/main/tp/tp.md  
Doc simulateur : https://ginhac.com/teaching/archi/manuel-simulateurARM.pdf  

## Utilisation :
- Assigner chaque valeure sur 8 bits
- Séparer chaque valeure par un espace (0x20)
- Terminer le calcul par un caractère égal (0x3d)
- Le symbole pour un nombre négatif est _ (0x5f) car le caractère - (0x2d) est déjà utilisé pour symboliser une soustraction
- Opérateurs : 
    * `* : 0x2a`
    * `+ : 0x2b`
    * `- : 0x2d`
    * `/ : 0x2f`
    * `^ : 0x5e`
    * `% : 0x25`
    * `[space] : 0x20`
    * `= : 0x3d`
    * `_ : 0x5f`

- Exemple :
    * Notation classique : notation polonaise inverse : version hexadécimale
    * (3 + 7) / (-2) : 3 7 + _2 / : `calc ASSIGN8 0x33, 0x20, 0x37, 0x20, 0x2b, 0x20, 0x32, 0x20, 0x2f, 0x3d;`

Implémenter :
- [ ] Rendre le code plus lisible
- [ ] Division par 0
- [ ] Gestion des erreurs
- [ ] Valeur absolue
- [x] Division / Multiplication négative
- [x] Addition / Soustraction négatifs
- [x] Puissances paires / impaires (pas négatives)