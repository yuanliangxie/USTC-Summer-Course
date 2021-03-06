DATA SEGMENT
	BUFFER DB 11 DUP(?)
DATA ENDS
CODE SEGMENT
	ASSUME CS:CODE,DS:DATA	
START: 
	MOV AX,DATA
	MOV DS,AX
	MOV BX,0	  			;BX记录待排序数的数量
	MOV SI,OFFSET BUFFER	;SI记录数据段首址
INPUT:			   			;循环输入两位数，先输入十位再输入个位，BX记录数的数量
	MOV AH,1	  			;输入十位
	INT 21H
	CMP AL,'$'
	JE PRE
	SUB AL,48
	MOV CL,4
	SHL AL,CL
	MOV [SI],AL
	MOV AH,1	            ;输入个位
	INT 21H
	SUB AL,48
	ADD [SI],AL             ;十位与个位相加，这个数输入完成
	INC SI
	INC BX
	MOV DL,32               ;输出一个空格，作为输入数之间的间隔
	MOV AH,2                
	INT 21H
	JMP INPUT	
PRE:
	MOV [SI],AL
	MOV DL,10               ;输出一个换行 
	MOV AH,2
	INT 21H
	DEC BX
	MOV CX,BX               
OUTER:
	MOV SI,OFFSET BUFFER
	MOV BX,CX
	CMP CX,0
	JE PRE2
INNER:
	MOV AL,[SI]       ;(ax)即a[j]
	CMP AL,[SI+1]     ;a[j]与a[j+1]比较
	JBE NEXT          ;小于等于时跳转，即a[j]<=a[j+1]时不交换
	XCHG AL,[SI+1]    ;交换
	MOV [SI],AL       ;交换完成
NEXT: 
	INC SI            ;a[j]<=a[j+1]时，跳到下一个待排序的数
	LOOP INNER
	MOV CX,BX
	DEC CX
	JMP OUTER
PRE2:
	MOV DL,10
	MOV AH,2
	INT 21H
	MOV SI,OFFSET BUFFER
OUTPUT:
	MOV AL,[SI]
	CMP AL,'$'  ;检测，如果输出字符串过程中遇到$，结束输出，退出
	JE EXIT
	MOV AL,[SI]
	AND AL,0F0H           ;读取十位的BCD码，右移4位到低位，并加上48转换成对应字符，输出
	MOV CL,4
	SHR AL,CL
	ADD AL,48
	MOV DL,AL
	MOV AH,2
	INT 21H
	MOV AL,[SI]
	AND AL,0FH            ;;读取个位的BCD码，并加上48转换成对应字符，输出
	ADD AL,48
	MOV DL,AL
	MOV AH,2
	INT 21H
	MOV DL,32             ;输出一个空格，作为输出数之间的间隔
	MOV AH,2                
	INT 21H
	ADD SI,1              ;地址加1，下一个数
	JMP OUTPUT            ;循环输出直到遇到$
EXIT:
	MOV DL,10             ;输出一个换行
	MOV AH,2
	INT 21H
	MOV DL,10             ;输出一个换行
	MOV AH,2
	INT 21H
	MOV AX,4CH            ;退出
    INT 21H
CODE ENDS
	END START
