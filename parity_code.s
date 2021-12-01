
	.globl	_printNum # tells the assembler that the main symbol
						# will be accessible from outside the current file
	  .def	_printNum;	.scl	2;	.type	32;	.endef # defined getparity 

_printNum: # starting point of the getparity procedure
LFB12:		
	.cfi_startproc
	movl	4(%esp), %edx 		# edx is x
	movl	$1, %eax			# eax is val
	jmp	L2
L3:
	xorl	%edx, %eax			# val=val xor x
	shrl	%edx				# right shift x
L2:
	testl	%edx, %edx			# while (x) 
	jne	L3						# until x is not negative
	andl	$1, %eax			# val & 0x1
	ret
	.cfi_endproc				# end of the procedure
	
	
LFE12:							## start point of the main procedure
	.def	___main;			# defined main 
	.scl	2;					# means storage class 2( external storage class)
	.type	32;					# means this is a fucntion
	.endef  
	.section .rdata,"dr"

	
LC0: # each text has label from LC0 to LC4
	.ascii "num\0"		
	# .ascii "string"
# The .ascii directive places the characters in string into the object module 
# at the current location but does not terminate the string with a null byte (\0). 
# String must be enclosed in double quotes (") (ASCII 0x22). 
# The .ascii directive is not valid for the .bss section.
# https://docs.oracle.com/cd/E26502_01/html/E28388/eoiyg.html#scrolltoc

LC1:  # 
	.ascii "num\0"
LC2:
	.ascii "Enter number: \0"
LC3:
	.ascii "%d\0"
LC4:
	.ascii "%d = %s \12\0"
	.text 				 #The .text directive defines the current section as .text. begins a text section 
	.globl	_main
	.def	_main;
	.scl	2;			# means storage class 2( external storage class)
	.type	32;			# means this is a fucntion
	.endef  			# end of main part
	
_main:
LFB13:
	.cfi_startproc  # The tables that we need the assembler to emit for 
					# us are called Call Frame Information (CFI).
					# Based on that name, all the assembler directives begin with .cfi_
					# Next we need to define the Canonical Frame Address (CFA). 
					# This is the value of the stack pointer %rsp just before the CALL instruction in the parent function. 
					# Our first task will be to define data that allows the CFA to be calculated for any given instruction.
					# The CFI tables allow the CFA to be expressed as a register value plus an offset. 
					# For example, immediately upon function entry the CFA is rsp + 8. 
					# (The eight byte offset is because the CALL instruction will have pushed the previous %ebp on the stack.)
	pushl	%ebp
	.cfi_def_cfa_offset 8 
	.cfi_offset 5, -8  # register 5 
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%ebx
	andl	$-16, %esp
	subl	$32, %esp
	.cfi_offset 3, -12
	
	
	call	___main   			# call main
	movl	$LC2, (%esp)		# move LC2 to stack "Enter number: \0" to print
	call	_printf				# call _printf function
	leal	28(%esp), %eax		# 
	movl	%eax, 4(%esp)		# move eax to stack 
	movl	$LC3, (%esp)		# move LC3 to stack %d\0
	call	_scanf				# call _scanf function
	movl	28(%esp), %ebx		# 
	movl	%ebx, (%esp)		#
	call	_getParity			# call _getParity function
	testw	%ax, %ax			#
	jne	L8
	movl	$LC1, %eax			# move LC1 text to eax  
L5:
	movl	%eax, 8(%esp)		# move val to stack
	movl	%ebx, 4(%esp)		# move ebx to stack
	movl	$LC4, (%esp)		# move LC4 to stack "Parity of no %d = %s \12\0"
	call	_printf				# call _printf function
	movl	$0, %eax			# result =0
	movl	-4(%ebp), %ebx
	leave
	.cfi_remember_state
	.cfi_restore 5				# 
	.cfi_restore 3
	.cfi_def_cfa 4, 4
	ret
L8:
	.cfi_restore_state  
	movl	$LC0, %eax			# move  "even\0" to eax when return 0 
	jmp	L5
	.cfi_endproc  			# end of procedure
LFE13:
	.ident	"GCC: (MinGW.org GCC-6.3.0-1) 6.3.0"
	.def	_printf;		# definition _printf
	.scl	2;
	.type	32;
	.endef

	.def	_scanf;			# definition _printf
	.scl	2;
	.type	32;
	.endef