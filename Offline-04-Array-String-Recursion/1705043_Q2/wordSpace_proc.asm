;make spaces between words
\T PROC
        PUSH DX
        PUSH CX
        PUSH BX
        PUSH AX
        
        MOV AH, 2
        MOV DL, ' '
        INT 21H
        
        POP AX
        POP BX
        POP CX
        POP DX
        
        RET
\T ENDP