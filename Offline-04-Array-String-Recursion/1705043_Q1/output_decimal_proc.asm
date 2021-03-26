;DECIMAL output procedure
OUTDEC PROC
    ;push values of registers
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    OR AX, AX           
    JGE @END_IF1        ;if AX>=0 go to @END_IF1
                        ;else
    PUSH AX             
    MOV DL, '-'         ;print '-' sign
    MOV AH, 2
    INT 21H
    POP AX
    NEG AX              ;make 2's completement
    
@END_IF1:
    XOR CX, CX          ;clear CX
    MOV BX, 10D         ;BX = 10
    
@REPEAT1:
    XOR DX, DX          ;clear DX
    DIV BX              ;DX = AX % 10 , AX = AX / 10
    PUSH DX             ;push remainer into stack
    INC CX              ;count digit++
    
    OR AX, AX           
    JNE @REPEAT1        ;if AX!=0, repeat
                        ;else
    MOV AH, 2

@PRINT_LOOP:
    POP DX              ;pop MSB of DECIMAL
    OR DL, 30H          ;DECIMAL to ASCII
    INT 21H             ;print
    LOOP @PRINT_LOOP    ;till CX=0, @PRINT_LOOP continues
    
    ;pop all in reverse order of push
    POP DX
    POP CX
    POP BX
    POP AX                  
    RET                 ;return
OUTDEC ENDP