;new line procedure
\N PROC
        
        PUSH DX
        PUSH CX
        PUSH BX
        PUSH AX
     
        MOV AH, 2
        MOV DL, 0DH
        INT 21H
        MOV DL, 0AH
        INT 21H
        
        POP AX
        POP BX
        POP CX
        POP DX
        
        RET
\N ENDP