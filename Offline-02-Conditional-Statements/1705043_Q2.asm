.MODEL SMALL
.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    input_msg DB CR, LF, 'Enter Password : $'
    valid_msg DB CR, LF, 'Valid Password $'
    invalid_msg DB CR, LF, 'Invalid Password $'
    
    HAS_UPPER DB '?'
    HAS_LOWER DB '?'
    HAS_DIGIT DB '?'

.CODE

MAIN PROC
    
    ; INITIALIZE DS
    MOV AX, @DATA
    MOV DS, AX
          
          
    ; PASSWORD INPUT MESSAGE
    LEA DX, input_msg
    MOV AH, 9
    INT 21H
    
    ; INITIALIZE VALUES
    MOV AL, 0
    MOV HAS_UPPER, AL
    MOV HAS_LOWER, AL
    MOV HAS_DIGIT, AL
    
    
    MOV AH, 1
    INT 21H
    
    WHILE_:
        CMP AL, 21H
        JL END_WHILE   
        CMP AL, 7EH
        JG END_WHILE
        
        DIGIT_CHECK:
        CMP AL, 30H
        JGE GREATER_30H
        JMP HERE
        
        GREATER_30H:
            CMP AL, 39H
            JLE DIGIT_SATISFIED
            JMP UPPER_CHECK
            DIGIT_SATISFIED:
                MOV HAS_DIGIT, 1
        
        UPPER_CHECK:
        CMP AL, 41H
        JGE GREATER_41H
        JMP HERE
        
        GREATER_41H:
            CMP AL, 5AH
            JLE UPPER_SATISFIED
            JMP LOWER_CHECK
            UPPER_SATISFIED:
                MOV HAS_UPPER, 1
        
        
        LOWER_CHECK:
        CMP AL, 61H
        JGE GREATER_61H
        JMP HERE
        
        GREATER_61H:
            CMP AL, 7AH
            JLE LOWER_SATISFIED
            JMP HERE
            LOWER_SATISFIED:
                MOV HAS_LOWER, 1
         
        HERE:
        INT 21H
        JMP WHILE_
    
    END_WHILE:
        MOV AL, HAS_UPPER
        CMP AL, 1
        JE UPPER_DONE
        JMP INVALID_PASSWORD
        
        UPPER_DONE:
            MOV AL, HAS_LOWER
            CMP AL, 1
            JE LOWER_DONE
            JMP INVALID_PASSWORD
            
            LOWER_DONE:
                MOV AL, HAS_DIGIT
                CMP AL, 1
                JE DIGIT_DONE
                JMP INVALID_PASSWORD
            
            DIGIT_DONE:
                JMP VALID_PASSWORD
    
    
    INVALID_PASSWORD:
        LEA DX, invalid_msg
        MOV AH, 9
        INT 21H
        JMP ALL_DONE
        
    VALID_PASSWORD:
        LEA DX, valid_msg
        MOV AH, 9
        INT 21H
        JMP ALL_DONE
    
    ALL_DONE:
    
    ; DOS EXIT
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN