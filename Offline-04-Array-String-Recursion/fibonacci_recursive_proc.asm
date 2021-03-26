FIBONACCI PROC
    PUSH BP
    MOV BP, SP ; STACK POINTER
                          
    MOV BX, [BP+4]   ; get n
    CMP BX, 1        
    JE ONE           ;if n==1
    
    CMP BX, 2
    JE TWO
    JMP NOT_ONE_TWO   ;if n!=1 && n!=2
    
    ONE:
        MOV AX, 0    ;return 0
        JMP RETURN
    
    TWO:
        MOV AX, 1    ;return 1
        JMP RETURN   

    NOT_ONE_TWO:
        SUB BX, 1
        PUSH BX
        CALL FIBONACCI  ; get F(n-1)
        PUSH AX         ; save result F(n-1)
        
        
        MOV BX, [BP+4]
        SUB BX, 2
        PUSH BX
        CALL FIBONACCI  ; get F(n-2)
        
        
        POP BX          ; get F(n-1) 
        ADD AX, BX      ; F(n-1) + F(n-2)
        
        ;CALL OUTDEC
        ;CALL \N        
        
    RETURN:
        POP BP
        RET 2     
    
FIBONACCI ENDP