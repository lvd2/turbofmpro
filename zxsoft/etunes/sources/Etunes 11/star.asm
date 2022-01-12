Star_play_middle:
		ld	ix,Star_table_cnst1

loc_1_6487:
		ld	b,16

loc_1_6488:
		push	bc
		ld	l, (ix++0)
		ld	h, (ix++1)
		ld	d, (ix++2)
		ld	e, (ix++3)
		ld	a, (ix++5)
		cp	1
		ld	a, d
		jr	nz, loc_1_649E
		ld	a, e
loc_1_649E:
		ld	(loc_1_64A1+1), a
loc_1_64A1:
		res	0, (hl)
		
		ld	a,d
		sub	10h
		cp	86h
		jr	nc,Star_middle_next1
		ld	d,a
		inc	l
		ld	a,l
		and	1Fh
		jr	nz,Star_middle_next0
		ld	a,l
		sub	20h
		ld	l,a
Star_middle_next0:		
		ld	(ix++0), l
		ld	a,d
		add	40h
Star_middle_next1:
		ld	(ix++2),a
		ld	a,e
		sub	10h
		cp	0C6h
		jr	nc,Star_middle_next2
		add	40h
Star_middle_next2:
		ld	(ix++3),a

		ld	b, 1
		ld	c,a
		call	sub_1_6464
		ld	a,c
		ld	(loc_1_64D4+1), a
loc_1_64D4:
		set	0,(hl)
		pop	bc
		djnz	loc_1_6488
		ret	

Star_init_middle:
		ld	ix,Star_table_cnst1
		ld	b,16

sub_1_6464:
		ld	l, (ix++0)
		ld	h, (ix++1)
		ld	a, (ix++4)
		ld	e,a
		ld	(loc_1_6471+1),a
		xor	a
loc_1_6471:
		bit	6, (hl)
		jr	z, loc_1_6477
		ld	a, 1
loc_1_6477:
		ld	(ix++5), a

		ld	a,e
		sub	10h
		cp	46h
		jr	nc,Star_middle_next3
		add	40h
Star_middle_next3:
		ld	(ix++4),a
		ld	de, 6
		add	ix, de
		djnz	sub_1_6464
		ret	


Star_table_cnst1:

		dw 	42C8h
		db	8Eh,0CEh,4Eh,0  
		dw 	4202h
		db	0A6h,0E6h,66h,1  
		dw  	4220h
		db	0BEh,0FEh,7Eh,0  
		dw  	4241h
		db	86h,0C6h,46h,0   
		dw 	4264h
		db	9Eh,0DEh,5Eh,0   
		dw 	4286h
		db	8Eh,0CEh,4Eh,0   
		dw 	42A7h
		db	0B6h,0F6h,76h,0   
		dw 	46C5h
		db	8Eh,0CEh,4Eh,0   
		dw  	4626h
		db	96h,0D6h,56h,0  
		dw 	4669h
		db	96h,0D6h,56h,0   
		dw 	4684h
		db	86h,0C6h,46h,0   
		dw  	4A29h
		db	0B6h,0F6h,76h,0  
		dw 	4A47h
		db	8Eh,0CEh,4Eh,0  
		dw 	4A79h
		db	0B6h,0F6h,76h,1;  
		dw 	4E38h
		db	0B6h,0F6h,76h,0   
		dw 	4E7Ah
		db	86h,0C6h,46h,0   

Star_play_low:
		ld	ix,Star_table_cnst0

loc_0_6487:
		ld	b,16

loc_0_6488:
		push	bc
		ld	l, (ix++0)
		ld	h, (ix++1)
		ld	d, (ix++2)
		ld	e, (ix++3)
		ld	a, (ix++5)
		cp	1
		ld	a, d
		jr	nz, loc_0_649E
		ld	a, e
loc_0_649E:
		ld	(loc_0_64A1+1), a
loc_0_64A1:
		res	0, (hl)
		
		ld	a,d
		sub	8
		cp	7Eh
		jr	nz,Star_low_next1
		inc	l
		ld	a,l
		and	1Fh
		jr	nz,Star_low_next0
		ld	a,l
		sub	20h
		ld	l,a
Star_low_next0:		
		ld	(ix++0), l
		ld	a,0BEh
Star_low_next1:
		ld	(ix++2),a
		ld	a,e
		sub	8
		cp	0BEh
		jr	nz,Star_low_next2
		ld	a,0FEh
Star_low_next2:
		ld	(ix++3),a

		ld	b, 1
		ld	c,a
		call	sub_0_6464
		ld	a,c
		ld	(loc_0_64D4+1), a
loc_0_64D4:
		set	0,(hl)
		pop	bc
		djnz	loc_0_6488
		ret	

Star_init_low:
		ld	ix,Star_table_cnst0
		ld	b,16

sub_0_6464:
		ld	l, (ix++0)
		ld	h, (ix++1)
		ld	a, (ix++4)
		ld	e,a
		ld	(loc_0_6471+1),a
		xor	a
loc_0_6471:
		bit	6, (hl)
		jr	z, loc_0_6477
		ld	a, 1
loc_0_6477:
		ld	(ix++5), a

		ld	a,e
		sub	8
		cp	3Eh
		jr	nz,Star_low_next3
		ld	a,7Eh
Star_low_next3:
		ld	(ix++4),a
		ld	de, 6
		add	ix, de
		djnz	sub_0_6464
		ret	



Star_table_cnst0:

		dw 	40A1h
		db	9Eh,0DEh,5Eh,0   
 		dw 	4003h
		db	9Eh,0DEh,5Eh,0  
		dw 	402Ch
		db	9Eh,0DEh,5Eh,0  
		dw 	405Bh
		db	0B6h,0F6h,76h,0;  
		dw 	408Ch
		db	0A6h,0E6h,66h,0  
		dw 	44A9h
		db	9Eh,0DEh,5Eh,0   
		dw 	44C8h
		db	0BEh,0FEh,7Eh,0  
		dw 	4429h
		db	9Eh,0DEh,5Eh,0  
		dw  	4441h
		db	9Eh,0DEh,5Eh,0  
		dw 	445Dh
		db	0B6h,0F6h,76h,0  
		dw 	4488h
		db	0A6h,0E6h,66h,0  
		dw  	4840h
		db	9Eh,0DEh,5Eh,0  
		dw 	487Ch
		db	0A6h,0E6h,66h,0  
		dw 	4C2Bh
		db	9Eh,0DEh,5Eh,0  
		dw  	4C41h
		db	9Eh,0DEh,5Eh,0  
		dw 	4C82h
		db	0A6h,0E6h,66h,0  

