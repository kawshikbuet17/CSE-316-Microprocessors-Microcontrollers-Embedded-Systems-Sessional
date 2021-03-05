.MODEL SMALL
.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    INPUT_MSG DB 'ENTER UPPERCASE LETTER : $'
    OUTPUT_MSG1 DB CR, LF, 'PREVIOUS LOWERCASE LETTER : $'
    OUTPUT_MSG2 DB CR, LF, 'ONES COMPLEMENT : $'
    UPPER DB '?'
    LOWER DB '?'
    ONES_COMPLEMENT DB '?'  


.CODE

MAIN PROC
    
    ; INITIALIZE DS
    MOV AX, @DATA
    MOV DS, AX
          
          
    ; INPUT MESSAGE
    LEA DX, INPUT_MSG
    MOV AH, 9
    INT 21H
    
    
    ; TAKE INPUT
    MOV AH, 1
    INT 21H
    MOV UPPER, AL ; backup 
    SUB AL, 48 
    
            
              
    ; GET PREVIOUS LOWERCASE
    MOV AL, UPPER
    SUB AL, 48    
    DEC AL
    ADD AL, 32
    ADD AL, 48
    MOV LOWER, AL
    
    
    ; OUTPUT PREVIOUS LOWERCASE
    LEA DX, OUTPUT_MSG1
    MOV AH, 9
    INT 21H 
    
    MOV DL, LOWER
    MOV AH, 2
    INT 21H



    ; GET ONES COMPLETEMENT
    MOV AL, UPPER
    NEG AL
    DEC AL
    MOV ONES_COMPLEMENT, AL
    
    ; OUTPUT ONES COMPLEMENT
    LEA DX, OUTPUT_MSG2
    MOV AH, 9
    INT 21H 
    
    MOV DL, ONES_COMPLEMENT
    MOV AH, 2
    INT 21H    
    
    
    
    ; DOS EXIT
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN
    
    
    
    
    