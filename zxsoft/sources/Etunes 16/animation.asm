;--------------------------------------------------------------------
; Описание: Сдвиг шахматки
; Автор порта: Тарасов М.Н.(Mick),2011
;--------------------------------------------------------------------
Animation_star_init:
		xor	a
		ld	(Animation_step),a
		ld	(Animation_phase),a
		ld	(Animation_count),a

Animation_star_view:
		ld	a,(Animation_step)
		inc	a
		and	07h
		ld	(Animation_step),a
		ret 	nz
		ld	a,(Animation_phase)
		inc	a	
		cp	09h
		jr	c,Animation_next_phase
		ld	a,(Animation_count)
		xor	1
		ld	(Animation_count),a
		xor	a
Animation_next_phase:
		ld	(Animation_phase),a
		ld	l,a
		ld	h,0
		ld	b,h
		add	hl,hl
		ld	bc,Animation_table_phase
		add	hl,bc
		ld	a,(hl)				;адрес фазы
		inc	hl
		ld	h,(hl)				;адрес фазы
		ld	l,a

		ld	a,(Animation_count)
		and	a
		jr	z,Animation_star_right
		ld	de,4040h
		jr	Animation_draw

Animation_star_right:
		ld	de,405Eh
Animation_draw:
		ld	b,16
Animation_loop_Y:
		ld	c,d
		ldi
		ldi
		dec	e
		dec	e
		inc	d
		ld	a,d
		and 	7
		jr	nz,Animation_next_line
		ld	a,e
		add	20h
		ld	e,a
		jr	c,Animation_next_line
		ld	a,d
		sub	8
		ld	d,a
Animation_next_line:
		dec	b
    		jr	nz,Animation_loop_Y
		ret	    

Animation_step:
		db	0
Animation_phase:
		db	0
Animation_count:
		db	0

Animation_table_phase:
                dw	Animation_phase_00	
                dw	Animation_phase_01	
                dw	Animation_phase_02	
                dw	Animation_phase_03	
                dw	Animation_phase_04	
                dw	Animation_phase_03	
                dw	Animation_phase_02	
                dw	Animation_phase_01	
                dw	Animation_phase_00	

Animation_phase_00:
		db 	0,0,0,0,0,0,0,0
		db 	0,0,0,0,0,0,0,0
		db 	0,0,0,0,0,0,0,0
		db 	0,0,0,0,0,0,0,0

Animation_phase_01:
		db 	0,0,0,0,0,0,0,0
		db	0,0,0,0,0,0,0,80h
		db 	1,0C0h,0,80h,0,0,0,0
		db 	0,0,0,0,0,0,0,0

Animation_phase_02:
		db 	0,0,0,0,0,0,0,0
		db 	0,0,0,80h,0,0,0,80h
		db 	5,0D0h,0,80h,0,0,0,80h
		db 	0,0,0,0,0,0,0,0

Animation_phase_03:
		db 	0,0,0,0,0,80h,0,0
		db 	0,80h,0,90h,2,80h,1,0C0h
		db 	47,0F4h,1,0C0h,0,0A0h,4,80h
		db 	0,0,0,80h,0,0,0,0

Animation_phase_04:
		db 	0,80h,0,0,0,80h,10h,8
		db 	0,80h,4,80h,2,0A0h,1,0C0h
		db 	5Fh,0FDh,1,0C0h,2,80h,4,90h
		db 	0,88h,10h,80h,0,0,0,80h

Animation_view:
		ld	de,512Ah
		call	Animation_draw_line		;512Ah
		inc	d
		call	Animation_draw_line             ;522Ah
		inc	d
		call	Animation_draw_line             ;532Ah
		inc	d
		call	Animation_draw_line             ;542Ah
		inc	d
		call	Animation_draw_line             ;552Ah
		inc	d
		call	Animation_draw_line             ;562Ah
		inc	d
		call	Animation_draw_line             ;572Ah
		ld	de,504Ah
		call	Animation_draw_line             ;504Ah
		inc	d
		call	Animation_draw_line             ;514Ah
		inc	d
		call	Animation_draw_line             ;524Ah
		inc	d
		call	Animation_draw_line             ;534Ah
		inc	d
		call	Animation_draw_line             ;544Ah
		inc	d
		call	Animation_draw_line             ;554Ah
		inc	d
		call	Animation_draw_line             ;564Ah
		inc	d
		call	Animation_draw_line             ;574Ah
		ld	de,506Ah
		call	Animation_draw_line             ;506Ah
		inc	d
		call	Animation_draw_line             ;516Ah
		inc	d
		call	Animation_draw_line             ;526Ah
		inc	d
		call	Animation_draw_line             ;536Ah
		inc	d
		call	Animation_draw_line             ;546Ah
		inc	d
		call	Animation_draw_line             ;556Ah
		inc	d
		call	Animation_draw_line             ;566Ah
		inc	d                               ;576Ah

Animation_draw_line:
		ld	h,d
		ld	l,e
		and	a

		rr	(hl)
		inc	l
		rr	(hl)
		inc	l
		rr	(hl)
		inc	l
		rr	(hl)
		inc	l
		rr	(hl)
		inc	l
		rr	(hl)
		inc	l

		rr	(hl)
		inc	l
		rr	(hl)
		inc	l
		rr	(hl)
		inc	l
		rr	(hl)
		inc	l
		rr	(hl)
		inc	l
		rr	(hl)

		ret	nc
		ld	l,e
		set	7,(hl)
		ret	
