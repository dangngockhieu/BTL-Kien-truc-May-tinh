# Chuong trinh: Tao file du lieu
#------------------------------------
# Data segment
	.data
# Cac dinh nghia bien
array:		.word 0 2 23 1 -1 15 1 3 5 11
flag:		.word 0
tenfile: 	.asciiz "INT10.BIN"
# Cac cau nhac nhap du lieu
str_tc:		.asciiz	"Thanh cong."
str_loi:	.asciiz	"Mo file bi loi."
#-------------------------------------
#Code segment
	.text
	.globl	main
#-------------------------------------
# Chuong trinh chinh
#-------------------------------------
main:	
# Nhap (syscall)
	move	$t0, $a0
# Xu ly
# mo file
	la	$a0, tenfile
	addi	$a1, $zero, 1	# open with write-only
	li	$v0, 13
	syscall
	bltz	$v0, bao_loi
	sw	$v0, flag
# ghi file	
	la 	$a1, array
	lw 	$a0, flag	#file descriptor
	li 	$a2, 40
  	li 	$v0, 15
  	syscall
  	
# dong file
	li	$v0, 16
	syscall
	la	$a0, str_tc
	li	$v0, 4
	syscall
	
	j	Ket_thuc
# Xuat ket qua (syscall)	
bao_loi:
	la	$a0, str_loi
	li	$v0, 4
	syscall
# Ket thuc chuong trinh (syscall)
Ket_thuc:
	addiu	$v0, $zero, 10
	syscall
#--------------------------------------