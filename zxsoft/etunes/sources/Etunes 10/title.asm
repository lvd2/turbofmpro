;--------------------------------------------------------------------
; Описание: Анимация спрайта цифры 8
; Автор порта: Тарасов М.Н.(Mick),2010
;--------------------------------------------------------------------
Title_init:
		xor	a
		ld	(Title_step),a
		ld	(Title_phase),a
		ld	(Title_count_symbol),a
		ret
Title_view:
		ld	a,(Title_step)
		inc	a
		and	07h
		ld	(Title_step),a
		ret 	nz
		ld	a,(Title_phase)
		inc	a	
		and	1Fh
		ld	(Title_phase),a
		call	z,Title_next_symbol
		ld	hl,(Title_addr_table)

		ld	bc,7ffdh
		ld	e,90h
		out	(c),e

		ld	c,a
		ld	b,(hl)				;число строк
		inc	hl
		ld	e,(hl)				;адрес экрана
		inc	hl
		ld	d,(hl)
		inc	hl
		ld	a,b
		push	hl
		ld	l,c
		ld	h,0
		pop	bc
		add	hl,hl
		add	hl,bc
		ld	b,a
		ld	a,(hl)
		inc	hl
		ld	h,(hl)
		ld	l,a
		ex	hl,de				;HL- адрес экрана, DE - буфер				
Title_loop_Y:
		push	hl
		ex	hl,de
		ldi
		ldi
		ldi
		ldi
		ldi
		ldi
		ex	hl,de
		pop	hl
		inc	h
		ld	a,h
		and 	7
		jr	nz,Title_next_line
		ld	a,l
		add	20h
		ld	l,a
		jr	c,Title_next_line
		ld	a,h
		sub	8
		ld	h,a
Title_next_line:
		dec	b
    		jr	nz,Title_loop_Y
		ret	    

Title_next_symbol:
		ld	c,a
		ld	a,(Title_count_symbol)
		inc	a
		cp	7
		jr	c,Title_update_symbol
		xor	a

Title_update_symbol:	
		ld	(Title_count_symbol),a
		ld	l,a
		ld	h,0
		add	hl,hl
		ld	de,Title_table_phase
		add	hl,de
		ld	a,(hl)
		inc	hl
		ld	h,(hl)
		ld	l,a
		ld	(Title_addr_table),hl
		ld	a,c
		ret

Title_addr_table:
                dw	Title_table_E10	
Title_count_symbol:
		db	0
Title_step:
		db	0
Title_phase:
		db	0

Title_table_phase:
               	dw	Title_table_E10	
               	dw	Title_table_Z10	
               	dw	Title_table_T10	
               	dw	Title_table_U10	
               	dw	Title_table_N10	
               	dw	Title_table_E20	
	        dw	Title_table_S10	
