.MODEL SMALL
.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    input1_msg DB CR, LF,  'Enter value of n : $'
    
    n DW '?'
    ans DW '?'
    arr DW 100 DUP(0)
    i DW '?'

.CODE

MAIN PROC
    
    ; INITIALIZE DS
    MOV AX, @DATA
    MOV DS, AX
    

    LEA DX, input1_msg
    MOV AH, 9
    INT 21H
    

    CALL INDEC
     
    MOV n, AX

    CALL \N 
      
    
    LEA SI, arr
    
    MOV CX, n
    MOV i, 1
    SAVE_FIB:
        MOV AX, i
        PUSH AX
        CALL FIBONACCI
        MOV [SI], AX
        ADD SI, 2
        INC i
        LOOP SAVE_FIB
    
    MOV CX, n
    LEA SI, arr
    PRINT_FIB:
        MOV AX, [SI]
        CALL OUTDEC
        CALL \N
        ADD SI, 2
        LOOP PRINT_FIB
    
    QUIT:
        MOV AH, 4CH
        INT 21H 
                           
MAIN ENDP



;include procedures


INCLUDE input_decimal_proc.asm
INCLUDE output_decimal_proc.asm
INCLUDE newLine_proc.asm
INCLUDE fibonacci_recursive_proc.asm

END MAIN