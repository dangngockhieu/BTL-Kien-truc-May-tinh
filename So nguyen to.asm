# Chuong trinh: Xac dinh so nguyen ni co la so nguyen to hay khong
#------------------------------------------------------------------------	
# Macro
	# Xuat chuoi 
	.macro puts(%chuoi)
	la      $a0, %chuoi
	addi    $v0, $zero, 4
	syscall
	.end_macro	
#-------------------------------------------------------------------------
# Data segment
	.data
# Cac dinh nghia bien
chuoi_dau:		.asciiz "So "
chuoi_ket1:	.asciiz " nguyen to.\n"
chuoi_ket2:	.asciiz " khong nguyen to.\n"  
snt:	.word 0 # Luu snt
not_snt:   .word 0 # Luu so khong phai snt
tmp: .word 0  # Bien tam
# tmp = 0 : chua random
# tmp = 1 : Da co snt, chua co so khong phai snt
# tmp = 2 : Chua co snt, da co so khong phai snt
filename:	.asciiz "NGUYENTO.TXT" 
chuoi_so:   .space 12
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
random:        
    # Tim so ngau nhien tu 1 den 10000
    addi $a0, $zero, 1      
    addi $a1, $zero, 10000    
    addi $v0, $zero, 42       
    syscall       
    move $t0, $a0      # Luu so ngau nhien vao $t0
    
#----------------------------------------------------------------------------------------
# Ham kiem tra co phai so nguyen to hay khong
check_snt:
    move $t1, $t0        # Copy so ngau nhien vao $t1
    addi $t2, $zero, 2   # Bat dau uoc so tu so 2
    # Neu $t1 <= 1 thi khong phai so nguyen to
    blez $t1, not_prime  # Neu $t1 <= 0
    addi $t3, $zero, 1   # neu $t1 = 1
    beq $t1, $t3, not_prime
check:
    div $t1, $t2         # $t0 chia $t2
    mfhi $t3             # Lay phan du
    beqz $t3, not_prime  # Neu phan du = 0 thi khong phai so nguyen to
    addi $t2, $t2, 1     # Tang uoc so len 1
    mul $t3, $t2, $t2    # Kiem tra uoc so binh phuong > $t0
    bgt $t3, $a0, prime
    j check

prime:
    sw $a0, snt         # Luu so random vao bien snt
    # Kiem tra xem da co so khong phai snt chua
    lw $t5, tmp         # Lay gia tri bien tmp hien tai
    addi $t6, $zero, 2
    beq $t5, $t6, print # Neu tmp = 2, da co so khong phai snt, sau do thoat
    addi $t6, $zero, 1  
    sw $t6, tmp         # Neu chua thi cap nhat da co so nguyen to
    j random            # Tiep tuc random

not_prime:
    sw $a0, not_snt     # Luu so random vao bien not_snt
    # Kiem tra xem da co snt chua
    lw $t5, tmp         # Lay gia tri bien tmp hien tai
    addi $t6, $zero, 1
    beq $t5, $t6, print # Neu tmp = 1, da co snt, sau do thoat
    addi $t6, $zero, 2
    sw $t6, tmp         # Neu chua thi cap nhat da co so khong phai la snt
    j random            # Tiep tuc random
# Xuat ket qua (syscall)
 	# In ket qua ra man hinh    
print:
    # In snt
    lw 	$a0, snt 	    # a0 = int_n 
    la 	$a1, chuoi_so 	# a1 = addr(buffer1[])
    jal	tostring
    puts chuoi_dau
    puts chuoi_so
    puts chuoi_ket1
    # In so khong phai snt
    lw 	$a0, not_snt 	# a0 = int_n 
    la 	$a1, chuoi_so 	# a1 = addr(buffer1[])
    jal	tostring
    puts chuoi_dau
    puts chuoi_so
    puts chuoi_ket2
    
    j ghi_file  # Ghi ket qua vao file NGUYENTO.TXT
# Ket thuc chuong trinh (syscall)
Kthuc:	addi	$v0, $zero, 10
		syscall
# -------------------------------
ghi_file:
	# Mo file
    addi 	$v0, $zero, 13    # Syscall 13: mo file
    la 	$a0, filename     # ten file
    addi 	$a1, $zero, 1     # write only
    addi   	$a2, $zero, 0     # mode is ignored
    syscall
    move $s6, $v0             # Luu file descriptor vao $s6
# ghi snt
    lw 	$a0, snt 	# a0 = int_n 
    la 	$a1, chuoi_so 	# a1 = addr(buffer1[])
    jal	tostring        # Chuyen ve chuoi
    la      $a1, chuoi_dau
    jal     fputs
    la      $a1, chuoi_so
    jal     fputs
    la      $a1, chuoi_ket1
    jal     fputs
# ghi so khong phai la snt
    lw 	$a0, not_snt 	# a0 = int_n 
    la 	$a1, chuoi_so 	# a1 = addr(buffer1[])
    jal	tostring        # Chuyen ve chuoi
	la      $a1, chuoi_dau
   	jal     fputs
	la      $a1, chuoi_so
    	jal     fputs
	la      $a1, chuoi_ket2
   	jal     fputs
# Dong file
    addi 	$v0, $zero, 16    # Syscall 16: dong file
    move 	$a0, $s6          # Gan gia tri cho descriptor
    syscall 
	j	Kthuc
# Ham chuyen tu so ve chuoi
tostring:
    move $t0, $a0              # Luu so vao $t0
    la 	$t1, ($a1)             # Lay dia chi luu ket qua
    addi $t2, $zero, 1         # Bien dem bat dau = 1
digit:
    div   $t3, $t0, 10   # Chia $t0 cho 10 lay phan nguyen vao $t3
    mfhi  $t4            # Lay phan du 
    bnez  $t3, prepare   # Neu con so -> prepare
    j 	  write_digit    # Neu khong con so -> ghi ra
prepare:
    mul   $t2, $t2, 10   # Cap nhat bien dem x10
    move  $t0, $t3       # Cap nhat lai gia tri $t0 tu phan du $t3
    j 	  digit		 # Tiep tuc chia

write_digit:
    move $t0, $a0        # Khoi phuc gia tri goc
loop:
    div   $t3, $t0, $t2    # Lay chu so dau tien 
    mflo  $t3
    addi  $t3, $t3, 48     # Chuyen sang ki tu ASCIIZ
    sb 	$t3, 0($t1)        # Luu ki tu vao bo dem
    addi  $t1, $t1, 1      # Di chuyen con tro bo dem sang 1
    rem   $t0, $t0, $t2    # Lay phan du
    div   $t2, $t2, 10     # Giam bien dem xuong
    bnez  $t2, loop        # Lap lai neu van con so

# Ket thuc
    addi $t3, $zero, 0
    sb 	$t3, 0($t1)
    jr 	$ra  
#-------------------------------------------------------------------------

fputs:
   	move    $a2, $a1        # Lay dia chi chuoi can ghi vao
	fputs_loop:
    lb      $t0, 0($a2)      	# Lay ki tu tiep theo vao $t0
    addiu   $a2, $a2, 1      	# Tro toi ki tu tiep theo
    bnez    $t0, fputs_loop  	# Neu chua het chuoi -> tiep tuc lap
    subu    $a2, $a2, $a1       # Lay do dai chuoi
    subiu   $a2, $a2, 1         # Vi tang $a2 them 1 lan nua -> bu lai
   	move    $a0, $s6            # Lay file descriptor
    addi    $v0, $zero, 15      # syscall 15 de viet vao file
    syscall
    jr      $ra                 # Quay ve
