;--------------------------------------------------------------------
; Описание: Модуль отображения анализатора
; Автор порта: Тарасов М.Н.(Mick),2010
;--------------------------------------------------------------------

;-------------------------------------------------------------------
; описание: Обновление параметров анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_update:
		ld	hl,EAmplitude_ch0

		ld	a,(hl)				;+00h - Amplitude 0 right/left
		and	0Fh
		ld	(Analyzer_ch0_left),a           ;Amplitude 0 left 
		ld	a,(hl)				;+00h - Amplitude 0 right/left				
		and	0F0h
		rrca	
		rrca	
		rrca
		rrca	
		ld	(Analyzer_ch0_right),a          ;Amplitude 0 right 

		inc	hl
		ld	a,(hl)				;+01h - Amplitude 1 right/left
		and	0Fh
		ld	(Analyzer_ch1_left),a           ;Amplitude 1 left 
		ld	a, (hl)				;+01h - Amplitude 1 right/left
		and	0F0h
		rrca	
		rrca	
		rrca	
		rrca	
		ld	(Analyzer_ch1_right),a          ;Amplitude 1 right 

		inc	hl
		ld	a,(hl) 				;+02h - Amplitude 2 right/left
		and	0Fh
		ld	(Analyzer_ch2_left),a           ;Amplitude 2 left 
		ld	a,(hl)				;+02h - Amplitude 2 right/left
		and	0F0h
		rrca	
		rrca	
		rrca	
		rrca	
		ld	(Analyzer_ch2_right),a         	;Amplitude 2 right 

		inc	hl
		ld	a, (hl) 			;+03h - Amplitude 3 right/left
		and	0Fh
		ld	(Analyzer_ch3_left),a          	;Amplitude 3 left 
		ld	a, (hl)                         ;+03h - Amplitude 3 right/left
		and	0F0h
		rrca	
		rrca	
		rrca	
		rrca	
		ld	(Analyzer_ch3_right),a         	;Amplitude 3 right 

		inc	hl
		ld	a, (hl)				;+04h - Amplitude 4 right/left
		and	0Fh
		ld	(Analyzer_ch4_left),a           ;Amplitude 4 left 
		ld	a, (hl)
		and	0F0h
		rrca	
		rrca	
		rrca	
		rrca	
		ld	(Analyzer_ch4_right),a          ;Amplitude 4 right 

		inc	hl
		ld	a, (hl)				;+05h - Amplitude 5 right/left
		and	0Fh
		ld	(Analyzer_ch5_left),a           ;Amplitude 5 left 
		ld	a, (hl)
		and	0F0h
		rrca	
		rrca	
		rrca	
		rrca	
		ld	(Analyzer_ch5_right),a		;Amplitude 5 right 
		ret

;-------------------------------------------------------------------
; описание: Отображение анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_view:
		ld	de,0FF0h

		ld	a,(Analyzer_ch0_left)		;Amplitude 0 left 
		ld	hl,4200h
		call	Analyzer_left_draw

		ld	a, (Analyzer_ch1_left)		;Amplitude 1 left 
		ld	hl,4220h
		call	Analyzer_left_draw

		ld	a,(Analyzer_ch2_left)		;Amplitude 2 left 
		ld	hl,4240h
		call	Analyzer_left_draw

		ld	a,(Analyzer_ch3_left)          ;Amplitude 3 left 
		ld	hl,4260h
		call	Analyzer_left_draw
                                                        
		ld	a,(Analyzer_ch4_left)          ;Amplitude 4 left 
		ld	hl,4280h
		call	Analyzer_left_draw

		ld	a,(Analyzer_ch5_left)          ;Amplitude 5 left 
		ld	hl,42A0h
		call	Analyzer_left_draw
                                                        
		ld	a,(Analyzer_ch0_right)         ;Amplitude 0 right 
		ld	hl,421Fh
		call	Analyzer_right_draw

		ld	a,(Analyzer_ch1_right)		;Amplitude 1 right 
		ld	hl,423Fh
		call	Analyzer_right_draw

		ld	a,(Analyzer_ch2_right)		;Amplitude 2 right 
		ld	hl,425Fh
		call	Analyzer_right_draw

		ld	a,(Analyzer_ch3_right)		;Amplitude 3 right 
		ld	hl,427Fh
		call	Analyzer_right_draw

		ld	a,(Analyzer_ch4_right)		;Amplitude 4 right 
		ld	hl,429Fh
		call	Analyzer_right_draw

		ld	a,(Analyzer_ch5_right) 		;Amplitude 5 right 
		ld	hl,42BFh
		call	Analyzer_right_draw
		ret
;-------------------------------------------------------------------
; описание: Отрисовка левого канала анализатора
; параметры: HL - адрес экрана
;	     A - размерность анализатора
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_left_draw:
		ld	c,a
		ld	b,1

Analyzer_left_loop:
		push	hl
		ld	a,c
		cp	b
		ld	a,(hl)
		jr	c,Analyzer_left_clr0
		and	d
		or	0C0h
		ld	(hl),a
		inc	h
		ld	a,(hl)
		and	d
		or	0E0h
		ld	(hl),a
		inc	h
		ld	(hl),a
		inc	h
		ld	a,(hl)
		and	d
		or	0C0h
		ld	(hl),a

Analyzer_left_next:
		pop	hl
		inc	b
		push	hl
		ld	a,c
		cp	b
		ld	a,(hl)
		jr	c,Analyzer_left_clr1
		and	e
		or	0Ch
		ld	(hl),a
		inc	h
		ld	a,(hl)
		and	e
		or	0Eh
		ld	(hl),a
		inc	h
		ld	(hl),a
		inc	h
		ld	a,(hl)
		and	e
		or	0Ch
		ld	(hl),a

Analyzer_left_inc:		
		pop	hl
		inc	l
		inc	b
		ld	a,b
		cp	17
		ret	z	
		jr	Analyzer_left_loop
		
Analyzer_left_clr0:
		and	d
		ld	(hl),a
		inc	h
		ld	a,(hl)
		and	d
		ld	(hl),a
		inc	h
		ld	(hl),a
		inc	h
		ld	a,(hl)
		and	d
		ld	(hl),a
		nop
		jr	Analyzer_left_next

Analyzer_left_clr1:
		and	e
		ld	(hl),a
		inc	h
		ld	a,(hl)
		and	e
		ld	(hl),a
		inc	h
		ld	(hl),a
		inc	h
		ld	a,(hl)
		and	e
		ld	(hl),a
		nop
		jr	Analyzer_left_inc
;-------------------------------------------------------------------
; описание: Отрисовка правого канала анализатора
; параметры: HL - адрес экрана
;	     A - размерность анализатора
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_right_draw:
		ld	c,a
		ld	b,1

Analyzer_right_loop:
		push	hl
		ld	a,c
		cp	b
		ld	a,(hl)
		jr	c,Analyzer_right_clr0
		and	e
		or	03h
		ld	(hl),a
		inc	h
		ld	a,(hl)
		and	e
		or	07h
		ld	(hl),a
		inc	h
		ld	(hl),a
		inc	h
		ld	a,(hl)
		and	e
		or	03h
		ld	(hl),a

Analyzer_right_next:
		pop	hl
		inc	b
		push	hl
		ld	a,c
		cp	b
		ld	a,(hl)
		jr	c,Analyzer_right_clr1
		and	d
		or	30h
		ld	(hl),a
		inc	h
		ld	a,(hl)
		and	d
		or	70h
		ld	(hl),a
		inc	h
		ld	(hl),a
		inc	h
		ld	a,(hl)
		and	d
		or	30h
		ld	(hl),a

Analyzer_right_inc:		
		pop	hl
		dec	l
		inc	b
		ld	a,b
		cp	17
		ret	z	
		jr	Analyzer_right_loop
		
Analyzer_right_clr0:
		and	e
		ld	(hl),a
		inc	h
		ld	a,(hl)
		and	e
		ld	(hl),a
		inc	h
		ld	(hl),a
		inc	h
		ld	a,(hl)
		and	e
		ld	(hl),a
		nop
		jr	Analyzer_right_next

Analyzer_right_clr1:
		and	d
		ld	(hl),a
		inc	h
		ld	a,(hl)
		and	d
		ld	(hl),a
		inc	h
		ld	(hl),a
		inc	h
		ld	a,(hl)
		and	d
		ld	(hl),a
		nop
		jr	Analyzer_right_inc
;-------------------------------------------------------------------
; описание: Отрисовка левого канала анализатора
; параметры: HL - адрес экрана
;            C - позиция в индикаторе
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_draw_flash:
		ld	hl,Analyzer_ch0_left
		ld	a,(hl)				;Analyzer_ch0_left
		inc	hl
		add	a,(hl)                          ;Analyzer_ch0_right
		inc	hl
		add	a,(hl)                          ;Analyzer_ch1_left
		inc	hl
		add	a,(hl)                          ;Analyzer_ch1_right
		inc	hl
		add	a,(hl)                          ;Analyzer_ch2_left
		inc     hl
		add	a,(hl)				;Analyzer_ch2_right
		and	0Fh
		ld	hl,Analyzer_table
		ld	e,a
		ld	d,0
		add	hl,de
		ld	a,(hl)
		ld	hl,5A92h
		ld	(hl),a
		inc	l
		ld	(hl),a
		ld	hl,Analyzer_ch3_left
		ld	a,(hl)				;Analyzer_ch3_left
		inc	hl
		add	a,(hl)                          ;Analyzer_ch3_right
		inc	hl
		add	a,(hl)                          ;Analyzer_ch4_left
		inc	hl
		add	a,(hl)                          ;Analyzer_ch4_right
		inc	hl
		add	a,(hl)                          ;Analyzer_ch5_left
		inc     hl
		add	a,(hl)				;Analyzer_ch5_right
		and	0Fh
		ld	hl,Analyzer_table
		ld	e,a
		ld	d,0
		add	hl,de
		ld	e,(hl)
		ld	d,e
		ld	hl,5AD6h
		ld	(Analyzer_adr_sp),sp
		ld	sp,hl
		push	de
		push	de
		push	de
		push	de
		push	de
		push	de
		ld	hl,5AF6h
		ld	sp,hl
		push	de
		push	de
		push	de
		push	de
		push	de
		push	de
		ld	sp,(Analyzer_adr_sp)
		ret

;-------------------------------------------------------------------
; описание: Обновление параметров анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_init:
              	ld	b, 12
		ld	hl,Analyzer_ch0_left

Analyzer_init_loop:
                ld	(hl),0
		inc	hl
		djnz	Analyzer_init_loop
		ret
;-------------------------------------------------------------------
; описание:  Переменные правого и левого каналов анализатора
;---------------------------------------------------------------------
Analyzer_table:
		db	47h,47h,47h,47h,46h,46h,45h,45h,44h,44h,43h,43h,42h,42h,41h,41h	
;-------------------------------------------------------------------
; описание:  Переменные правого и левого каналов анализатора
;---------------------------------------------------------------------
Analyzer_adr_sp:
		dw	0
Analyzer_ch0_left:
		db	0	
Analyzer_ch0_right:
		db	0	
Analyzer_ch1_left:
		db	0	
Analyzer_ch1_right:
		db	0	
Analyzer_ch2_left:
		db	0	
Analyzer_ch2_right:
		db	0	
Analyzer_ch3_left:
		db	0	
Analyzer_ch3_right:
		db	0	
Analyzer_ch4_left:
		db	0	
Analyzer_ch4_right:
		db	0	
Analyzer_ch5_left:
		db	0	
Analyzer_ch5_right:
		db	0	
;		.end