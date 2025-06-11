# Chuong trinh: Selection Sort
#-----------------------------------
# Macro in chuoi
.macro puts(%chuoi)
	la   $a0, %chuoi
	addi $v0, $zero, 4
	syscall
.end_macro
# Data segment 
	.data
# Cac dinh nghia bien
array:		.space 40  # Buffer store data from files
flag:		.word 0
fileName: 	.asciiz "INT10.BIN"
space: 		.asciiz " "
newLine: 	.asciiz "\n"

# Cac cau nhac nhap du lieu
xuat_loi: 	.asciiz "Mo file bi loi."
xuat_bd: 	.asciiz "Mang ban dau la: "
xuat_td: 	.asciiz "Mang co su thay doi la: "
xuat_kt: 	.asciiz "Mang sau khi da sap xep la: "
#-----------------------------------
# Code segment
	.text
	.globl	main
#-------------------------------------
# Chuong trinh chinh
#-------------------------------------
main:	
# Nhap (syscall)
    	# Goi ham readFile:
	la   $a0, fileName
  	la   $a3, array
  	jal  readFile

  	# in ra mang ban dau
	puts xuat_bd
	
	# Goi ham printArray
	la   $a1, array
	jal  printArray
	
	# Goi ham selectionSort
	la   $a1, array
	jal  selectionSort

# Xuat ket qua (syscall)
# in du lieu sau khi sap xep
	puts xuat_kt	
	# Goi ham printArray
	la   $a1, array
	jal  printArray
	j    Kthuc
	
bao_loi:	
	puts xuat_loi
# Ket thuc chuong trinh (syscall)
Kthuc:	
	addi $v0, $zero, 10
	syscall
#-----------------------------------

readFile:
# input: $a0 <- fileName, $a3 <- buffer
# output: no return value

# mo file
	addi  $a1, $zero, 0	# flag = 0:read only
	addi  $v0, $zero, 13
	syscall

	bltz  $v0, bao_loi
	sw    $v0, flag
	
    	# doc file
  	lw    $a0, flag
	add   $a1, $a3, $zero
  	addi  $a2, $zero, 40
  	addi  $v0, $zero, 14
  	syscall
  	
  	# dong file
	lw    $a0, flag
        addi  $v0, $zero, 16
	syscall

jr $ra
#-----------------------------------

printArray:
# input: $a1 <- array
# output: no return value
# using for loop to print array
  # for(i = 0; i < 10; i++)
  # $a1 <- address_Of_array, $t0 <- i, $a0 <- array[i]
	# khoi tao
	addi  $t0, $zero, 0  # i = 0
	forLoopPrint:
	# condition
	beq   $t0, 10, endLoopPrint
	# body
	lw    $a0, 0($a1)   # $a0<-array[i]
	addi  $v0, $zero, 1
	syscall

	la    $a0, space   #in khoang cach
	addi  $v0, $zero, 4
	syscall

	#loop
	addi  $t0, $t0, 1   #i++
	addi  $a1, $a1, 4
	j forLoopPrint

	endLoopPrint:
	la    $a0, newLine	# in dong moi
	addi  $v0, $zero, 4
	syscall

jr $ra
#-----------------------------------

# Ham sap xep: Tim gia tri nho nhat cua mang con va dua ve truoc 
selectionSort:
# input: $a1 <- array
# for(i = 0; i < 9; i++) 
  # $t0 <- i, $a0 <- array[i]
  # $s0 <- indexOfMin, $t1 <- j
  	# khoi tao
	addi	$t0, $zero, 0  # i = 0
	forLoopSort:
  	# condition
  	beq 	$t0, 9, endLoopSort

  	# body
	add	$s0, $zero, $t0       # $s0 <- indexOfMin = i: gan dia chi min cua mang tam thoi = i 
  	# for(int j = i + 1; j < 10; j++)
	# $s1 <- address_Of_array (in nested loop2)
	# initialization and preparation
	addi	$t1, $t0, 1     # $t1 <- j = i + 1
	la 	$s1, array      # s1 <- base address of array
	nestedFor:
	# condition
	beq 	$t1, 10, endNestedFor
	# body
	# if(arr[j] < arr[indexOfMin]) indexOfMin = j;
	# $s2 <- arr[j], $s3 <- arr[indexOfMin]
	# $t2 <- offset
	# if: arr[j] >= arr[indexOfMin] -> jump to endIf
				
	# load arr[j]
	mul	$t2, $t1, 4     # $t2 <- offset = 4 * j
	add 	$s1, $s1, $t2
	lw 	$s2, ($s1)	#s2 <- arr[j]
	sub 	$s1, $s1, $t2
				
	# load arr[indexOfMin]
	mul 	$t2, $s0, 4   	# $t2 <- offset = 4 * indexOfMin
	add 	$s1, $s1, $t2
	lw 	$s3, 0($s1)	# s3 <- arr[indexOfMin]
	sub 	$s1, $s1, $t2
				
	# if_condition
	slt 	$t2, $s2, $s3	# $s2 < $s3 -> false -> jump to endIf
	beq 	$t2, $zero, endNestedIf

	# then
	add 	$s0, $zero, $t1 # indexOfMin = j

	# endif
	endNestedIf:
	# loop
	addi 	$t1, $t1, 1  	# j++
	j nestedFor
	# end nested for
	endNestedFor:
			
	# if(indexOfMin != i)
	# $s1 <- address_Of_array, $s2 <- arr[indexOfMin], $s3 <- arr[i]
	# $t1 <- offset
	# if: 
	beq	$s0, $t0, endIf # $s0 = indexOfMin == $t0 = i -> jump to endIf
	# then
	# swaping
	la 	$s1, array
		
	# load arr[indexOfMin] to $s2
	mul 	$t1, $s0, 4		# $t1 <- offset = 4 * indexOfMin
	add 	$s1, $s1, $t1
	lw 	$s2, ($s1)		# $s2 <- arr[indexOfMin]
	sub 	$s1, $s1, $t1
		
	# load arr[i] to $s3
	mul 	$t1, $t0, 4 	# $t1 <- offset = 4 * i
	add 	$s1, $s1, $t1
	lw 	$s3, ($s1)	# $s3 <- arr[i]
	sw 	$s2, ($s1)	# store arr[indexOfMin] at position of arr[i]
	sub 	$s1, $s1, $t1
		
	mul 	$t1, $s0, 4	# $t1 <- offset = 4 * indexOfMin
	add 	$s1, $s1, $t1
	sw 	$s3, ($s1)	# store arr[i] at position of arr[indexOfMin]
		
	# Neu co su thay doi cua mang thi in ra man hinh
	puts xuat_td

	# Goi ham printArray
	addi 	$sp, $sp, -12
	sw 	$ra, 8($sp)	# store $ra to stackPointer - 4
	sw 	$t0, 4($sp)	# store$t0 <- i to stackPointer - 8
	sw 	$a1, 0($sp)	# store $a1 <- array to stackPointer - 12
	la 	$a1, array
	jal 	printArray
	lw 	$ra, 8($sp)	# load $ra from stackPointer - 4
	lw 	$t0, 4($sp) 	# load $t0 <- i from stackPointer - 8
	lw 	$a1, 0($sp)	# load $a1 <- array from stackPointer - 12
	addi 	$sp, $sp, 8
	# end if
	endIf:
		
	# loop
  	addi 	$t0, $t0, 1
	addi 	$a1, $a1, 4
  	j forLoopSort
	# end for
  	endLoopSort:
jr $ra

