code segment

mov bx, 00h
push bx

read:
 mov ah,01h ;
 int 21h; read a character
 mov dx,00h
 mov dl,al;copy input to access later
 cmp dl,20h;check if it is space 
 je pushStack
 cmp dl,0Dh ; check whether it is endline value
 je tempread
 cmp dl, 30h
 jb operators1 ;check if it is an operator from group 1 
 cmp dl,3ah;check if it is a value represented by a digit
 jb intconv;
 cmp dl,46h;check if it is a value which is represented by a letter
 ja operators2;
 
letterconv:; letter convertion due to ascii
 sub dx,37h;

contdata:
 mov ax,bx 
 mov bx,dx
 mov cx,10h; due to base of number
 mul cx; due to processing data from left to right
 add ax,bx; to update number to true value
 mov bx,ax;
 jmp read

intconv: ;integer convertion due to ascii
sub dx,30h
jmp contdata

pushStack: 
cmp si,01h; to prevent pushing extra zero due to operator sequences
mov si,00h; other part of the precaution 
je read
push bx 
mov bx,00h; to begin with empty register
jmp read 

tempread: ; to jump afterread label due to access limit of assembler
jmp afterread;

operators1:
cmp dl,2ah;
jb andop;
ja operators1a;

mulop:;multiplication operator 
pop cx;
pop ax;
mul cx;
push ax;
mov si,01h; the precautions other part
jmp read;

andop:;and operator
pop ax 
pop cx
and ax,cx;
push ax;
mov si,01h ;the precautions other part
jmp read;

operators1a:
cmp dl,2bh;
ja divop

addop:;addition operator
pop cx
pop ax
add ax,cx;
push ax
mov si,01h ;the precautions other part
jmp read;

divop:;division  operator
mov dx,00h
pop cx
pop ax 
div cx
push ax;
mov si,01h ;the precautions other part
jmp read;

operators2:; second operator group 
cmp dl, 60h; sentinel value to detect type of the operator
ja orop

xorop:;xor operator
pop ax
pop cx
xor ax,cx;
push ax
mov si,01h ;the precautions other part 
jmp read

orop:;or operator
pop ax
pop cx
or ax,cx
push ax
mov si,01h ;the precautions other part
jmp read;

afterread:
 pop ax; the result 
 
myprint:
 mov si,10h; due to base of number
 mov dx,00h
 push 0D ; to prevent coincidence of lines in my computer
 mov cx,1d; to store number of digit wiil be printed
 
nonzero:
 div si;to access the last non-proceessed digit of hexadecimal number
 cmp dx,10d; to detect whether it is letter or not 
 jb convint
 
 convletter:;letter convertion due to ascii value
 add dx,37h;
 jmp nonzero2
 
 convint: ; integer convertion due to ascii value
 add dx,48d
 
 nonzero2:
 push dx
 inc cx; update number of digit 
 mov dx,00h
 cmp ax,0h
 jne nonzero  
 
 push 0Ah; push newline for the output line not to coincide with the input line  
 inc cx;due to empty line
 
 writeloop:
 pop dx 
 mov ah,02h; to print data at dx register 
 int 21h
 dec cx; update number of remainder digits 
 jnz writeloop   
 int 20h ; exit to dos
code ends 
