# Chuong trinh: Phat 3 so thuc ngau nhien va ghi ket qua vao file SOLE.TXT
#------------------------------------------------------------------------	
# Macro
	# Xuat chuoi khong nhac
	.macro puts(%chuoi)
	la      $a0, %chuoi
	addi    $v0, $zero, 4
	syscall
	.end_macro	
	# Xuat chuoi co nhac
	.macro puts_p(%chuoi1, %chuoi2)
	puts   %chuoi1
	puts   %chuoi2
	.end_macro	
#-------------------------------------------------------------------------
# Data segment
	.data
# Cac dinh nghia bien
filename:	.asciiz "SOLE.TXT"  	# Ten file output
xuat1: 		.asciiz "So thuc 1 (2 so le): "
xuat2: 		.asciiz "So thuc 2 (3 so le): "
xuat3: 		.asciiz "So thuc 3 (4 so le): "
sothuc1:	.asciiz "000.00\n"
sothuc2:	.asciiz "000.000\n"
sothuc3:	.asciiz "000.0000\n"
#-------------------------------------------------------------------------
# Code segment
	.text
main:	
# Nhap (syscall)
# Xu ly 	
	# Set seed theo time
	addi 	$v0, $zero, 30		
	syscall
	addi 	$v0, $zero, 40		
	syscall
	# Syscall 42: tao so nguyen ngau nhien trong khoang tu a0 den a1
	# Sau do dua vao so thuc co bao nhieu chu so thap phan thi chia luy thua 10 tuong ung
 	# Tao so ngau nhien 1
    	addi 	$v0, $zero, 42 		
    	addi 	$a0, $zero, 1
    	addi 	$a1, $zero, 100000         
    	syscall
    	# Bat dau chuyen ve so thuc 
    	divu 	$a0, $a0, 100       # Chia cho 100 de duoc so thuc 1 co 2 so le
    	mflo 	$a2		    # Luu thuong vao $a2 lay lam phan nguyen 
    	mfhi 	$t1		    # Luu du vao $t1 de lam phan thap phan
    	la 	$a0, sothuc1        # Lay dia chi chuoi 
    	la 	$a1, ($a0)          # Gan dia chi cua chuoi vao $a1
        jal 	tostring_3          # Goi ham chuyen doi
    	addi 	$a0, $a0, 4	    # Truyen dia chi sau dau cham de nhap phan thap phan so thuc vao chuoi
    	move 	$a2, $t1 	    # Chuyen gia tri cua so du vao $a2 de chuyen thanh chuoi
    	jal 	tostring_2	    # Goi ham chuyen doi
 	# Tao so ngau nhien 2
    	addi 	$v0, $zero, 42 		
    	addi 	$a0, $zero, 1
    	addi 	$a1, $zero, 1000000         
    	syscall
    	# Bat dau chuyen ve so thuc 
    	divu 	$a0, $a0, 1000      # Chia cho 1000 de duoc so thuc 2 co 3 so le
    	mflo 	$a2		    # Luu thuong vao $a2 lay lam phan nguyen 
    	mfhi 	$t1		    # Luu du vao $t1 de lam phan thap phan
    	la 	$a0, sothuc2        # Lay dia chi chuoi 
    	la 	$a1, ($a0)          # Gan dia chi cua chuoi vao $a1
        jal 	tostring_3          # Goi ham chuyen doi
    	addi 	$a0, $a0, 4	    # Truyen dia chi sau dau cham de nhap phan thap phan so thuc vao chuoi
    	move 	$a2, $t1 	    # Chuyen gia tri cua so du vao $a2 de chuyen thanh chuoi
    	jal 	tostring_3	    # Goi ham chuyen doi
 	# Tao so ngau nhien 3
    	addi 	$v0, $zero, 42 		
    	addi 	$a0, $zero, 1
    	addi 	$a1, $zero, 10000000         
    	syscall
    	# Bat dau chuyen ve so thuc 
    	divu 	$a0, $a0, 10000     # Chia cho 10000 de duoc so thuc 3 co 4 so le
    	mflo 	$a2		    # Luu thuong vao $a2 lay lam phan nguyen 
    	mfhi 	$t1		    # Luu du vao $t1 de lam phan thap phan
    	la 	$a0, sothuc3        # Lay dia chi chuoi 
    	la 	$a1, ($a0)          # Gan dia chi cua chuoi vao $a1
        jal 	tostring_3          # Goi ham chuyen doi
    	addi 	$a0, $a0, 4	    # Truyen dia chi sau dau cham de nhap phan thap phan so thuc vao chuoi
    	move 	$a2, $t1 	    # Chuyen gia tri cua so du vao $a2 de chuyen thanh chuoi
    	jal 	tostring_4	    # Goi ham chuyen doi
# Xuat ket qua (syscall)
 	# In ket qua ra man hinh
    	puts_p	xuat1, sothuc1
    	puts_p	xuat2, sothuc2
    	puts_p  xuat3, sothuc3
 	# Mo file
    	addi 	$v0, $zero, 13    # Syscall 13: mo file
    	la 	$a0, filename     # ten file
    	addi 	$a1, $zero, 1     # write only
    	syscall
    	move $s6, $v0             # Luu file descriptor vao $s6
 	# Ghi du lieu vao file
    	la   $a1, xuat1        # Truyen chuoi xuat de ghi vao file
    	jal  ghi_chuoi	       # Goi ham ghi du lieu
    	la   $a1, sothuc1      # Truyen chuoi so nguyen de ghi vao file     
    	jal  ghi_so1  	       # Goi ham ghi du lieu
    	la   $a1, xuat2        # Truyen chuoi xuat de ghi vao file
    	jal  ghi_chuoi	       # Goi ham ghi du lieu
    	la   $a1, sothuc2      # Truyen chuoi so nguyen de ghi vao file     
    	jal  ghi_so2	       # Goi ham ghi du lieu
    	la   $a1, xuat3        # Truyen chuoi xuat de ghi vao file
    	jal  ghi_chuoi	       # Goi ham ghi du lieu
    	la   $a1, sothuc3      # Truyen chuoi so nguyen de ghi vao file     
    	jal  ghi_so3 	       # Goi ham ghi du lieu
 	# Dong file
    	addi 	$v0, $zero, 16    # Syscall 16: dong file
    	move 	$a0, $s6          # Gan gia tri cho descriptor
    	syscall  
# Ket thuc chuong trinh (syscall)
Kthuc:	addi	$v0, $zero, 10
		syscall
# -------------------------------	
# Cac chuong trinh khac
# -------------------------------
# tostring: chuyen cac so nguyen duoc tao ngau nhieu thanh chuoi de ghi vao file
#-------------------------------------------------------------------------------
# Ham tostring voi 2 chu so
tostring_2:		   
    	la 	$a3, ($a0)       # Lay dia chi chuoi
	addi    $a3, $a3, 1      # Dia chi cuoi cung cua phan tu
	j 	loop		 # Nhay toi vong lap chuyen doi
# -----------------------------------------------------------------
# Ham tostring voi 3 chu so
tostring_3:		   
    	la 	$a3, ($a0)       # Lay dia chi chuoi
	addi    $a3, $a3, 2      # Dia chi cuoi cung cua phan tu
	j 	loop		 # Nhay toi vong lap chuyen doi
# -----------------------------------------------------------------
# Ham tostring voi 4 chu so
tostring_4:		   
    	la 	$a3, ($a0)       # Lay dia chi chuoi
	addi    $a3, $a3, 3      # Dia chi cuoi cung cua phan tu
	j 	loop		 # Nhay toi vong lap chuyen doi
# -----------------------------------------------------------------
# Ham loop
loop: 
    	divu 	$a2, $a2, 10     # Chia 10 de lay so cuoi chung chuyen doi thanh ky tu
    	mfhi 	$t3                     
    	addi 	$t3, $t3, 48     # Chuyen so cuoi cung thanh ky tu (ASCIIZ)
    	sb 	$t3, 0($a3)      # Ghi ky tu vao chuoi
    	addi 	$a3, $a3, -1     # Dich dia chi ve truoc
    	bnez 	$a2, loop        # Thuc hien lai vong lap neu $a2 khac 0
	jr 	$ra
# ghi_du_lieu: ghi du lieu da chuyen doi sang ma ASCIIZ vao  file
# -----------------------------------------------------------------  
ghi_chuoi:
	addi 	$v0,$zero, 15	 # Goi syscall 15 de ghi du lieu
	addi 	$a2, $zero, 21	 # Gan kich thuoc cua chuoi	
	move 	$a0, $s6         # Gan file descriptor
	syscall
	jr 	$ra
#------------------------------------------------------------------
ghi_so1:
	addi 	$v0,$zero, 15	 # Goi syscall 15 de ghi du lieu
	addi 	$a2, $zero, 7	 # Gan kich thuoc cua chuoi	
	move 	$a0, $s6         # Gan file descriptor
	syscall
	jr 	$ra
#------------------------------------------------------------------
ghi_so2:
	addi 	$v0,$zero, 15	 # Goi syscall 15 de ghi du lieu
	addi 	$a2, $zero, 8	 # Gan kich thuoc cua chuoi	
	move 	$a0, $s6         # Gan file descriptor
	syscall
	jr 	$ra
#------------------------------------------------------------------
ghi_so3:
	addi 	$v0,$zero, 15	 # Goi syscall 15 de ghi du lieu
	addi 	$a2, $zero, 9	 # Gan kich thuoc cua chuoi	
	move 	$a0, $s6         # Gan file descriptor
	syscall
	jr 	$ra
# ----------------------------------------------------------------- 
