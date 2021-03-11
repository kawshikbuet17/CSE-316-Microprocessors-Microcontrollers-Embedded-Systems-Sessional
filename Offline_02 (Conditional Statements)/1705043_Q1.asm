.MODEL SMALL
.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    input_1 DB 'Enter Num 1 : $'
    input_2 DB CR, LF,'Enter Num 2 : $'
    input_3 DB CR, LF,'Enter Num 3 : $'
    all_equal_msg DB CR, LF, 'All the numbers are equal $'
    second_highest_msg DB CR, LF, 'Second Highest Number : $' 
    
    X DB '?'
    Y DB '?'
    Z DB '?'
    

.CODE

MAIN PROC
    
    ; INITIALIZE DS
    MOV AX, @DATA
    MOV DS, AX
          
    
    ; NUM1 INPUT MESSAGE
    LEA DX, input_1
    MOV AH, 9
    INT 21H
       
    
    ; NUM1 INPUT
    MOV AH, 1
    INT 21H
    MOV X, AL
    
    
    ; NUM2 INPUT MESSAGE
    LEA DX, input_2
    MOV AH, 9
    INT 21H
       
    
    ; NUM2 INPUT
    MOV AH, 1
    INT 21H
    MOV Y, AL
        
    
    ; NUM3 INPUT MESSAGE
    LEA DX, input_3
    MOV AH, 9
    INT 21H
       
    
    ; NUM3 INPUT
    MOV AH, 1
    INT 21H
    MOV Z, AL
          
    
    COMPARE_X_Y:
        MOV AL, X
        CMP AL, Y
        JL X_LESS_THAN_Y
        JG X_GREATER_THAN_Y
        JE X_EQUALS_Y
        
    
    ;if x < y 
    X_LESS_THAN_Y:
        
        ;if x >= z : ans = x
        MOV AL, X
        CMP AL, Z
        JGE X_IS_SECOND 
        
        ;if y > z : ans = z
        MOV AL, Y
        CMP AL, Z
        JG Z_IS_SECOND
        
        ;if y = z : ans = x
        MOV AL, Y
        CMP AL, Z
        JE X_IS_SECOND
        
        ;if y < z : ans = y
        MOV AL, Y
        CMP AL, Z
        JL Y_IS_SECOND
        
        
    ;if x > y
    X_GREATER_THAN_Y:
        
        ;if y >= z : ans = y
        MOV AL, Y
        CMP AL, Z
        JGE Y_IS_SECOND
        
        ;if z > x : ans = x
        MOV AL, Z
        CMP AL, X
        JG X_IS_SECOND
        
        ;if z = x : ans = y 
        MOV AL, Z
        CMP AL, X
        JE Y_IS_SECOND
        
        ;if z > y : ans = z
        MOV AL, Z
        CMP AL, Y
        JG Z_IS_SECOND
        
        
    ;if x = y
    X_EQUALS_Y:
        MOV AL, X
        CMP AL, Z
        
        ;if x = y = z : all equal
        JE ALL_EQUAL
        
        ;if x,y < z : ans x,y
        JL X_IS_SECOND
        
        ;if x,y > z : ans z
        JG Z_IS_SECOND
        
    
    X_IS_SECOND:
        LEA DX, second_highest_msg
        MOV AH, 9
        INT 21H
        
        MOV DL, X
        JMP PRINT_ANS
        
    Y_IS_SECOND:
        LEA DX, second_highest_msg
        MOV AH, 9
        INT 21H
        
        MOV DL, Y
        JMP PRINT_ANS
        
    Z_IS_SECOND:
        LEA DX, second_highest_msg
        MOV AH, 9
        INT 21H
        
        MOV DL, Z
        JMP PRINT_ANS
    
    ALL_EQUAL:
        LEA DX, all_equal_msg
        MOV AH, 9
        INT 21H
    
    PRINT_ANS:
        MOV AH, 2
        INT 21H
    
    
    ; DOS EXIT
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN