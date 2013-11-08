	.file	"exemplo1.c"
	.version	"01.01"
gcc2_compiled.:
.text
	.align 4
.globl funcao
	.type	 funcao,@function
funcao:
	pushl %ebp
	movl %esp,%ebp
	subl $40,%esp
.L2:
	leave
	ret
.Lfe1:
	.size	 funcao,.Lfe1-funcao
	.align 4
.globl main
	.type	 main,@function
main:
	pushl %ebp
	movl %esp,%ebp
	subl $8,%esp
	addl $-4,%esp
	pushl $3
	pushl $2
	pushl $1
	call funcao
	addl $16,%esp
.L3:
	leave
	ret
.Lfe2:
	.size	 main,.Lfe2-main
	.ident	"GCC: (GNU) 2.95.3 20010315 (release)"
