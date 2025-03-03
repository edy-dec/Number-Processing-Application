.MODEL SMALL
.STACK 100H

.DATA

    linie_noua DB ' ', 0DH,0AH,"$"   ;sirul de caractere ce creaza o linie noua
    mesaj_1  DB 'introduceti un numar de doua caractere:', 0DH, 0AH, '$' 

.CODE
START:

    MOV AX, @DATA       ;se copiaza adresa segementului de date
    MOV DS, AX          ;mutam in DS adresa de date din AX

    MOV BH, 0CH         ; mutam in BH valoarea cea mai mare ce poate fi introdusa
 
CITIRE_NUMERE:
    LEA DX, mesaj_1     ;se muta offset-ul segmentului de date unde se afla mesaj_1
    MOV AH, 9           ;se afiseaza mesaj 1
    INT 21H 

    MOV AH, 01H         ;introducem nr (caracter cod ascii)
    INT 21H
    MOV BL, AL          ;mutam nr din AL in BL 
    AND BL,0FH          ;aducem nr la valoarea numerica 

    MOV CL, 04          ;nr de biti cu care rotim
    ROL BL,CL           ;rotim la stanga pe BL cu 4 biti 

    MOV AH, 01H         ;introducem nr (caracter cod ascii)
    INT 21H

    AND AL, 0FH         ;aducem nr la valoarea numerica 
    ADD BL,AL           ;adunam numarul diN AL la BL

    LEA DX, linie_noua  ;ii dam lui DX offsetul de unde citeste linia noua
    MOV AH, 9H          ;afisam linia noua
    INT 21H

    MOV DL, BL          ; mutam in DL numarul pentru a-l decrementa
    JZ INCHIDERE        ;JUMP IF ZERO - inchide programul
    
    MOV AL,BL           ;copiem numarul in AL
    SUB AL, 10H         ;scadem 10H pentru a verifica daca este mai mic/ mare decat 10
    JNS FORMARE_NUMAR   ;JUMP IF NOT SIGN -> daca dupa scadere nu devine nr negativ sare la - formare nr
    REVENIRE:


    CMP BH , DL         ;il comparam cu nr 12 retinut in BH, iar daca este ai mic decat 12 sarim la bucla2
    JGE BUCLA2          ;JUMP IF GREATER OR EQUAL 

    JMP CITIRE_NUMERE

INCHIDERE:
 MOV AX, 4C00H
 INT 21H

BUCLA2:
 MOV BL, DL                 ;mutam valoare in BL pentru a nu o pierde
 SUB DL, 0AH                ;scadem din DL 10 -> asa afla in ce mod vom afisa nr
 JNS AFISARE_NR             ;JUMP IF NOT SIGN -> daca este mai mare decat 10 sarim la afisare nr
 MOV DL,BL
INAPOI:
 OR DL, 30H               ;formam codul ascii
  
MOV AH, 02H               ;afisam numarul
INT 21H

MOV AH, 02H               ;apelam functia de afisare caracter
MOV DL, 7H                ;caracterul ascii al "BEL"
INT 21h                   

LEA DX, linie_noua        ;ii dam lui DX offsetul de unde citeste linia noua
MOV AH, 9H                ;afisam linia noua
INT 21H    

MOV DL, BL                ;mutam valoarea in DL
DEC DL                    ;decrementam dl cu 1 pentru a emite un sunet la fiecare decrementare
JNZ BUCLA2                ;Jump if not zero
JMP CITIRE_NUMERE

FORMARE_NUMAR:
 MOV CH, BL             ;copiem nr in CH
 MOV BL, 0AH            ;introducem in BL nr 10
 ADD BL,AL              ;adunam in BL pe AL (am scazut 10h din AL, de aceea in AL se afla unitatile numarului)
 MOV DL, BL             ;introducem nr in DL 
 JMP REVENIRE           ; JUMP -> revenire

AFISARE_NR:
 MOV DL,CH              ;copiem nr de afisat in DL
 ROR DL,CL              ; rotim DL la dreapta cu 4 biti

OR DL, 30H              ;formam codul ascii

MOV AH, 02H             ;afisam numarul
INT 21H

MOV DL,CH               ;copiem nr in CH
DEC CH                  ;scadem 1 din CH 
JMP INAPOI              ;jump -> inapoi

END START