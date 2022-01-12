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
		ld	c,15
		ld	hl,5044h
		call	Analyzer_draw_left

		ld	c,13
		ld	hl,5144h
		call	Analyzer_draw_left

		ld	c,11
		ld	hl,5244h
		call	Analyzer_draw_left

		ld	c,10
		ld	hl,5344h
		call	Analyzer_draw_left

		ld	c,8
		ld	hl,5444h
		call	Analyzer_draw_left

		ld	c,7
		ld	hl,5544h
		call	Analyzer_draw_left
                                                        
		ld	c,6
		ld	hl,5644h
		call	Analyzer_draw_left

		ld	c,5
		ld	hl,5744h
		call	Analyzer_draw_left
                                                        
		ld	c,4
		ld	hl,5064h
		call	Analyzer_draw_left

		ld	c,3
		ld	hl,5164h
		call	Analyzer_draw_left

		ld	c,2
		ld	hl,5264h
		call	Analyzer_draw_left

		ld	c,1
		ld	hl,5364h
		call	Analyzer_draw_left

		ld	c,15
		ld	hl,5059h
		call	Analyzer_draw_right

		ld	c,13
		ld	hl,5159h
		call	Analyzer_draw_right

		ld	c,11
		ld	hl,5259h
		call	Analyzer_draw_right

		ld	c,10
		ld	hl,5359h
		call	Analyzer_draw_right

		ld	c,8
		ld	hl,5459h
		call	Analyzer_draw_right

		ld	c,7
		ld	hl,5559h
		call	Analyzer_draw_right
                                                        
		ld	c,6
		ld	hl,5659h
		call	Analyzer_draw_right

		ld	c,5
		ld	hl,5759h
		call	Analyzer_draw_right
                                                        
		ld	c,4
		ld	hl,5079h
		call	Analyzer_draw_right

		ld	c,3
		ld	hl,5179h
		call	Analyzer_draw_right

		ld	c,2
		ld	hl,5279h
		call	Analyzer_draw_right

		ld	c,1
		ld	hl,5379h
		call	Analyzer_draw_right

		ret
;-------------------------------------------------------------------
; описание: Отрисовка правого канала анализатора
; параметры: HL - адрес экрана
;            C - позиция в индикаторе
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_draw_right:
		ld	b,3
		ld	de,Analyzer_ch0_right
Analyzer_rloop:
		ld	(hl),0
		ld	a,(de)
		cp	c
		jr	c,Analyzer_rnext
		ld	(hl),70h

Analyzer_rnext:
		inc	de
		ld	a,(de)
		cp	c
		jr	c,Analyzer_rnext_1
		ld	a,07h
		or	(hl)
		ld	(hl),a

Analyzer_rnext_1:
		inc	l
		inc	de
		djnz	Analyzer_rloop
		ret	
;-------------------------------------------------------------------
; описание: Отрисовка левого канала анализатора
; параметры: HL - адрес экрана
;            C - позиция в индикаторе
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_draw_left:
		ld	b,3
		ld	de,Analyzer_ch0_left
Analyzer_lloop:
		ld	(hl),0
		ld	a,(de)
		cp	c
		jr	c,Analyzer_lnext
		ld	(hl),0E0h

Analyzer_lnext:
		inc	de
		ld	a,(de)
		cp	c
		jr	c,Analyzer_lnext_1
		ld	a,0Eh
		or	(hl)
		ld	(hl),a

Analyzer_lnext_1:
		inc	l
		inc	de
		djnz	Analyzer_lloop
		ret	
;-------------------------------------------------------------------
; описание: Отрисовка левого канала анализатора
; параметры: HL - адрес экрана
;            C - позиция в индикаторе
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_draw_flash:
		ld	a,(Analyzer_ch0_left)
		ld	e,a
		ld	a,(Analyzer_ch0_right)
		add	e
		ld	e,a
		ld	a,(Analyzer_ch1_left)
		add	e
		ld	e,a
		ld	a,(Analyzer_ch1_right)
		add	e
		ld	e,a
		ld	a,(Analyzer_ch2_left)
		add	e
		ld	e,a
		ld	a,(Analyzer_ch2_right)
		add	e
		and	0Fh
		ld	hl,Analyzer_table
		ld	e,a
		ld	d,0
		add	hl,de
		ld	a,(hl)
		ld	hl,5A9Ah
		ld	(hl),a
		inc	l
		ld	(hl),a
		ld	l,0BAh
		ld	(hl),a
		inc	l
		ld	(hl),a

		ld	a,(Analyzer_ch3_left)
		ld	e,a
		ld	a,(Analyzer_ch3_right)
		add	e
		ld	e,a
		ld	a,(Analyzer_ch4_left)
		add	e
		ld	e,a
		ld	a,(Analyzer_ch4_right)
		add	e
		ld	e,a
		ld	a,(Analyzer_ch5_left)
		add	e
		ld	e,a
		ld	a,(Analyzer_ch5_right)
		add	e
		and	0Fh
		ld	hl,Analyzer_table
		ld	e,a
		ld	d,0
		add	hl,de
		ld	a,(hl)
		ld	hl,5A84h
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		ld	l,0A4h
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
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
		db	78h,78h,78h,78h,7Dh,7Dh,7Dh,7Ch,7Ch,7Ch,7Bh,7Bh,7Ah,7Ah,79h,79h	
;-------------------------------------------------------------------
; описание:  Переменные правого и левого каналов анализатора
;---------------------------------------------------------------------
Analyzer_ch0_left:
		db	0	
Analyzer_ch1_left:
		db	0	
Analyzer_ch2_left:
		db	0	
Analyzer_ch3_left:
		db	0	
Analyzer_ch4_left:
		db	0	
Analyzer_ch5_left:
		db	0	
Analyzer_ch0_right:
		db	0	
Analyzer_ch1_right:
		db	0	
Analyzer_ch2_right:
		db	0	
Analyzer_ch3_right:
		db	0	
Analyzer_ch4_right:
		db	0	
Analyzer_ch5_right:
		db	0	
;		.end