DATA SEGMENT
IO8255_A     EQU 288H
IO8255_B     EQU 289H
IO8255_C     EQU 28AH
IO8255_K       EQU 28BH
IO82540       EQU 280H
IO82541     EQU 281H
IO82542    EQU 282H
IO8254_C       EQU 283H
LED             DB        3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH
DATA ENDS
CODE SEGMENT
        ASSUME CS:CODE,DS:DATA
INIT:
    MOV    AX,DATA		
    MOV    DS,AX
    MOV    DX,IO8254_C
    MOV    AL,36H   
    OUT    DX,AL
    MOV    DX,IO82540
    MOV    AX,2710H
    OUT    DX,AL
    MOV    AL,AH
    OUT    DX,AL
    MOV    DX,IO8254_C
    MOV    AL,78H	
    OUT    DX,AL
    MOV     DX,IO8254_C
    MOV    AL,96H 
    OUT    DX,AL    
    MOV     DX,IO82542
    MOV    AL,64H
    OUT    DX,AL
    MOV     DX,IO8255_K
    MOV     AL,89H 
    OUT    DX,AL
START:
    MOV    DX,IO8255_B
    MOV    AL,0	;熄灭数码管
    OUT    DX,AL
    MOV    DX,IO8255_A
    MOV    AL,24H    ;输出红灯和绿灯
    OUT    DX,AL
    MOV     DX,IO82541 ;计数器1输入计数初值开始计数
    MOV     AL,0BB8H
    OUT    DX,AL
    MOV    AL,AH
    OUT    DX,AL
SCAN1:    
    MOV     DX,IO8255_C
    IN    AL,DX
    CMP    AL,00H	;检测pc0低电平
    JNZ         SCAN1
YELLOW:
    MOV     DX,IO8255_A
    MOV    AL,44H	; 输出黄灯,熄灭绿灯,保持红灯
    OUT    DX,AL
    MOV     CX,5
    MOV    AX,CX
    MOV        BX,OFFSET LED      ;BX获取LED7段码地址
    XLAT                     
    MOV        DX,IO8255_B        ;数码管输出5
    OUT        DX,AL
COUNT1:
    MOV    DX,IO8255_C    ;C口读取黄灯状态
    IN    AL,DX
    CMP    AL,03H    ;检测高电平,黄灯亮
    JNZ    COUNT1
COUNT2:
    MOV     DX,IO8255_C
    IN    AL,DX
    CMP    AL,01H 	;检测低电平,黄灯灭
    JNZ    COUNT2
    DEC    CX    ;计数器减1
    MOV    AX,CX
    MOV        BX,OFFSET LED     
    XLAT                     
    MOV        DX,IO8255_B
    OUT        DX,AL    ;数码管输出倒计时
    CMP    CX,0	;检测5s倒计时是否完毕
    JNZ    COUNT1
REV:    
    MOV        DX,IO8255_B
    MOV    AL,0
    OUT        DX,AL
    MOV    DX,IO8255_A
    MOV    AL,81H
    OUT    DX,AL
    MOV     DX,IO82541
    MOV     AL,0BB8H
    OUT    DX,AL
    MOV    AL,AH
    OUT    DX,AL
SCAN2:    
    MOV     DX,IO8255_C
    IN    AL,DX
    CMP    AL,00H	;检测pc0低电平
    JNZ         SCAN1
YELLOW2:
    MOV     DX,IO8255_A
    MOV    AL,82H
    OUT    DX,AL
    MOV     CX,5	;5s计数器
    MOV    AX,CX
    MOV        BX,OFFSET LED
    XLAT                     
    MOV        DX,IO8255_B      
    OUT        DX,AL
COUNT3:
    MOV    DX,IO8255_C	
    IN    AL,DX
    CMP    AL,05H	;检测高电平
    JNZ    COUNT1
COUNT4:
    MOV     DX,IO8255_C
    IN    AL,DX
    CMP    AL,01H	;检测低电平
    JNZ    COUNT4
    DEC    CX	
    MOV    AX,CX
    MOV        BX,OFFSET LED   
    XLAT                     
    MOV        DX,IO8255_B 
    OUT        DX,AL
    CMP    CX,0
    JNZ    COUNT3
    JMP    START
CODE    ENDS    
    END START
    
