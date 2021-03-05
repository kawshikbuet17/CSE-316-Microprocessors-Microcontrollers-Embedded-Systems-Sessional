.MODEL SMALL
.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    input_X DB 'ENTER X : $'
    input_Y DB CR, LF,'ENTER Y : $'
    Z1 DB CR, LF, 'X-2Y = $'   
    Z2 DB CR, LF, '25-(X+Y) = $'
    Z3 DB CR, LF, '2X-3Y = $'
    Z4 DB CR, LF, 'Y-X+1 = $'
    X DB '?'
    Y DB '?'
    temp DB '?' 

.CODE

MAIN PROC
    
    ; INITIALIZE DS
    MOV AX, @DATA
    MOV DS, AX
          
          
    ; X INPUT MESSAGE
    LEA DX, input_X
    MOV AH, 9
    INT 21H
    
    ; X INPUT
    MOV AH, 1
    INT 21H
    MOV BL, AL
    MOV X, BL ; backup X
    SUB BL, 48
           
           
           
    ; Y INPUT MESSAGE
    LEA DX, input_Y
    MOV AH, 9
    INT 21H 
    
    ; Y INPUT
    MOV AH, 1
    INT 21H
    MOV Y, AL ; backup Y
    SUB AL, 48 
    
            
            
            
    
    ; CALCULATE X-2Y
    SUB BL, AL
    SUB BL, AL
    ADD BL, 48
    MOV temp, BL
    
    
    ; OUTPUT X-2Y
    LEA DX, Z1
    MOV AH, 9
    INT 21H 
    
    MOV DL, temp
    MOV AH, 2
    INT 21H
    
    
    
    
    
    ; CALCULATE 25-(X+Y)
    MOV AL, X
    SUB AL, 48
    
    MOV BL, Y   
    SUB BL, 48
    
    ADD AL, BL
    NEG AL
    ADD AL, 25
    ADD AL, 48
    MOV temp, AL
    
    ; OUTPUT 25-(X+Y)
    LEA DX, Z2
    MOV AH, 9
    INT 21H 
    
    MOV DL, temp
    MOV AH, 2
    INT 21H
    
    
    
    
    
    
    ; CALCULATE 2X-3Y
    MOV AL, X
    SUB AL, 48
    
    MOV BL, Y   
    SUB BL, 48
    
    ADD AL, AL
    SUB AL, BL
    SUB AL, BL
    SUB AL, BL
    ADD AL, 48
    MOV temp, AL
    
    ; OUTPUT 2X-3Y
    LEA DX, Z3
    MOV AH, 9
    INT 21H 
    
    MOV DL, temp
    MOV AH, 2
    INT 21H
    
    
    
    
    ; CALCULATE Y-X+1
    MOV AL, X
    SUB AL, 48
    
    MOV BL, Y   
    SUB BL, 48
    
    SUB BL, AL
    INC BL
    ADD BL, 48
    MOV temp, BL
    
    ; OUTPUT Y-X+1
    LEA DX, Z4
    MOV AH, 9
    INT 21H 
    
    MOV DL, temp
    MOV AH, 2
    INT 21H
    
    
    
    ; DOS EXIT
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN
    
    
    
    
    