Star_play_one:
		ld	ix, Star_table_cnst0
		push	ix
		call	loc_0_6487
		pop	ix
		jr	loc_0_6487

Star_play:
		ld	ix,Star_table_cnst2

loc_0_6487:
		ld	b,14

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
		inc	h
		ld	a, h
		and	7
		jr	nz, loc_0_64C1
		ld	a, h
		sub	8
		ld	h, a
		ld	a, l
		add	a, 20h ; ' '
		ld	l, a
		and	0E0h
		jr	nz, loc_0_64C1
		ld	a, h
		add	a, 8
		ld	h, a

loc_0_64C1:
		ld	a,h
		cp	50h
		jr	c,loc_0_64C2
		ld	h,40h
		ld	a,l
		and	1Fh
		ld	l,a
loc_0_64C2:
		ld	(ix++0), l
		ld	(ix++1), h
		ld	b, 1
		call	sub_0_6464
		ld	a,(loc_0_64A1+1)
		set	6,a
		ld	(loc_0_64D4+1), a
loc_0_64D4:
		set	0, (hl)
		pop	bc
		djnz	loc_0_6488
		ret	

Star_init:
		ld	ix,Star_table_cnst0
		ld	b,28

sub_0_6464:
		ld	l, (ix++0)
		ld	h, (ix++1)
		ld	a, (ix++4)
		ld	(loc_0_6471+1),a
		xor	a
loc_0_6471:
		bit	6, (hl)
		jr	z, loc_0_6477
		ld	a, 1
loc_0_6477:
		ld	(ix++5), a
		ld	de, 6
		add	ix, de
		djnz	sub_0_6464
		ret	


Star_table_cnst0:

		db 	28h,40h,9Eh,0DEh,5Eh,0   
		db 	0DBh,40h,0BEh,0FEh,7Eh,0  
		db	78h,41h,0A6h,0E6h,66h,0
		db 	0Eh,42h,9Eh,0DEh,5Eh,0  
		db 	0FEh,42h,9Eh,0DEh,5Eh,0  
		db  	82h,43h,9Eh,0DEh,5Eh,0  
		db 	0EAh,43h,0B6h,0F6h,76h,1;  
		db 	0AFh,46h,0A6h,0E6h,66h,0  
		db 	36h,48h,0BEh,0FEh,7Eh,0  
		db 	0F8h,4Ah,0A6h,0E6h,66h,0   
		db 	08h,4Dh,9Eh,0DEh,5Eh,0   
		db  	25h,4Eh,0BEh,0FEh,7Eh,0   
		db  	53h,4Eh,0BEh,0FEh,7Eh,0  
		db 	0FFh,4Fh,9Eh,0DEh,5Eh,0  

Star_table_cnst2:
		db 	0ADh,43h,8Eh,0CEh,4Eh,0  
		db 	0E2h,43h,0A6h,0E6h,66h,1  
		db  	46h,44h,0BEh,0FEh,7Eh,0  
		db  	2Fh,48h,86h,0C6h,46h,0   
		db 	0ACh,47h,0A6h,0E6h,66h,0  
		db 	0A7h,49h,9Eh,0DEh,5Eh,0   
		db 	0EAh,49h,8Eh,0CEh,4Eh,0   
		db 	6Ch,4Ah,0B6h,0F6h,76h,0   
		db 	0B4h,4Bh,8Eh,0CEh,4Eh,0   
		db 	0E3h,4Bh,86h,0C6h,46h,0   
		db  	3Ah,4Dh,0BEh,0FEh,7Eh,0   
		db  	80h,4Dh,96h,0D6h,56h,0  
		db  	9Dh,4Dh,86h,0C6h,46h,0   
		db 	0B0h,4Dh,96h,0D6h,56h,0   




