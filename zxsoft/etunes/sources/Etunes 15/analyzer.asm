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
		ld	c,a
		ld	a,(hl)				;+00h - Amplitude 0 right/left				
		and	0F0h
		rrca	
		rrca	
		rrca
		rrca	
		cp	c
		jr	nc,Analyzer_up_ch0
		ld	a,c	
Analyzer_up_ch0:
		ld	(Analyzer_ch0_vol),a          	;Amplitude 0

		inc	hl
		ld	a,(hl)				;+01h - Amplitude 1 right/left
		and	0Fh
		ld	c,a
		ld	a, (hl)				;+01h - Amplitude 1 right/left
		and	0F0h
		rrca	
		rrca	
		rrca	
		rrca	
		cp	c
		jr	nc,Analyzer_up_ch1
		ld	a,c	
Analyzer_up_ch1:
		ld	(Analyzer_ch1_vol),a          	;Amplitude 1 

		inc	hl
		ld	a,(hl) 				;+02h - Amplitude 2 right/left
		and	0Fh
		ld	c,a
		ld	a,(hl)				;+02h - Amplitude 2 right/left
		and	0F0h
		rrca	
		rrca	
		rrca	
		rrca	
		cp	c
		jr	nc,Analyzer_up_ch2
		ld	a,c	
Analyzer_up_ch2:
		ld	(Analyzer_ch2_vol),a         	;Amplitude 2  

		inc	hl
		ld	a, (hl) 			;+03h - Amplitude 3 right/left
		and	0Fh
		ld	c,a
		ld	a, (hl)                         ;+03h - Amplitude 3 right/left
		and	0F0h
		rrca	
		rrca	
		rrca	
		rrca	
		cp	c
		jr	nc,Analyzer_up_ch3
		ld	a,c	
Analyzer_up_ch3:
		ld	(Analyzer_ch3_vol),a         	;Amplitude 3  

		inc	hl
		ld	a, (hl)				;+04h - Amplitude 4 right/left
		and	0Fh
		ld	c,a
		ld	a, (hl)
		and	0F0h
		rrca	
		rrca	
		rrca	
		rrca	
		cp	c
		jr	nc,Analyzer_up_ch4
		ld	a,c	
Analyzer_up_ch4:
		ld	(Analyzer_ch4_vol),a          ;Amplitude 4  

		inc	hl
		ld	a, (hl)				;+05h - Amplitude 5 right/left
		and	0Fh
		ld	c,a
		ld	a, (hl)
		and	0F0h
		rrca	
		rrca	
		rrca	
		rrca	
		cp	c
		jr	nc,Analyzer_up_ch5
		ld	a,c	
Analyzer_up_ch5:
		ld	(Analyzer_ch5_vol),a		;Amplitude 5  
		ret
;-------------------------------------------------------------------
; описание: Отображение анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_view:
		ld	b,06h
		ld	de,Analyzer_ch0_vol

Analyzer_loop_channel:
		push	bc
		ld	a,(de)
		inc	de
		push 	de
		ld	l,a
		ld	h,0
		add	hl,hl
		ld	de,Analyzer_table_addr
		add	hl,de
		ld	a,(hl)
		inc	hl
		ld	h,(hl)
		ld	l,a
		ld	a,6
		sub	b
		ld	c,a
		add	a
		add	l
		ld	l,a
		ld	a,b
		cp	4
		jr	nc,Analyzer_get_data
		inc	l
		inc	l
Analyzer_get_data:
		ex	hl,de
		ld	a,c
		cp	3
		jr	c,Analyzer_view_data
		ld	a,5
		sub	c
Analyzer_view_data:
		ld	l,a
		ld	h,0
		add	hl,hl
		ld	bc,Analyzer_table_data
		add	hl,bc
		ld	a,(hl)
		inc	hl
		ld	h,(hl)
		ld	l,a

		ld	b,13				;размерность по Y
Analyzer_loop_Y:
		ld	c,10
		push	de
		ldi
		ldi
		pop	de
		inc	d
		ld	a,d
		and 	7
		jr	nz,Analyzer_next_line
		ld	a,e
		add	20h
		ld	e,a
		jr	c,Analyzer_next_line
		ld	a,d
		sub	8
		ld	d,a
Analyzer_next_line:
    		djnz    Analyzer_loop_Y
    		pop	de
		pop	bc
    		djnz    Analyzer_loop_channel
		ret	    
;-------------------------------------------------------------------
; описание: Отрисовка левого канала анализатора
; параметры: HL - адрес экрана
;            C - позиция в индикаторе
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_draw_flash:
		ld	a,(Analyzer_ch0_vol)
		ld	e,a
		ld	a,(Analyzer_ch3_vol)
		add	e
		and	0Fh
		ld	hl,Analyzer_table
		ld	e,a
		ld	d,0
		add	hl,de
		ld	a,(hl)
		ld	hl,5AC6h
		ld	(hl),a
		inc	l
		ld	(hl),a

		ld	a,(Analyzer_ch1_vol)
		ld	e,a
		ld	a,(Analyzer_ch4_vol)
		add	e
		and	0Fh
		ld	hl,Analyzer_table
		ld	e,a
		ld	d,0
		add	hl,de
		ld	a,(hl)
		ld	hl,5ADCh
		ld	(hl),a
		inc	l
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a

		ld	a,(Analyzer_ch2_vol)
		ld	e,a
		ld	a,(Analyzer_ch5_vol)
		add	e
		and	0Fh
		ld	hl,Analyzer_table
		ld	e,a
		ld	d,0
		add	hl,de
		ld	a,(hl)
		ld	hl,5AEAh
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a
		inc	l
		ld	(hl),a

		ret

;-------------------------------------------------------------------
; описание: Очистка поля основной строки
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_clear_scr:	
		ld	(Analyzer_addr_sp),sp
		ld	hl,0

		ld	sp,49F7h
		push	hl
		push	hl
		push	hl
		dec	sp
		dec	sp
		push	hl
		push	hl
		push	hl

		ld	sp,4AF7h
		push	hl
		push	hl
		push	hl
		dec	sp
		dec	sp
		push	hl
		push	hl
		push	hl

		ld	sp,4BF7h
		push	hl
		push	hl
		push	hl
		dec	sp
		dec	sp
		push	hl
		push	hl
		push	hl

		ld	sp,4CF7h
		push	hl
		push	hl
		push	hl
		dec	sp
		dec	sp
		push	hl
		push	hl
		push	hl

		ld	sp,4DF7h
		push	hl
		push	hl
		push	hl
		dec	sp
		dec	sp
		push	hl
		push	hl
		push	hl

		ld	sp,4EF7h
		push	hl
		push	hl
		push	hl
		dec	sp
		dec	sp
		push	hl
		push	hl
		push	hl

		ld	sp,4FF7h
		push	hl
		push	hl
		push	hl
		dec	sp
		dec	sp
		push	hl
		push	hl
		push	hl

		ld	sp,5017h
		push	hl
		push	hl
		push	hl
		dec	sp
		dec	sp
		push	hl
		push	hl
		push	hl

		ld	sp,5117h
		push	hl
		push	hl
		push	hl
		dec	sp
		dec	sp
		push	hl
		push	hl
		push	hl

		ld	sp,5217h
		push	hl
		push	hl
		push	hl
		dec	sp
		dec	sp
		push	hl
		push	hl
		push	hl

		ld	sp,5317h
		push	hl
		push	hl
		push	hl
		dec	sp
		dec	sp
		push	hl
		push	hl
		push	hl

		ld	sp,5417h
		push	hl
		push	hl
		push	hl
		dec	sp
		dec	sp
		push	hl
		push	hl
		push	hl

		ld	sp,5517h
		push	hl
		push	hl
		push	hl
		dec	sp
		dec	sp
		push	hl
		push	hl
		push	hl

		ld	sp,5617h
		push	hl
		push	hl
		push	hl
		dec	sp
		dec	sp
		push	hl
		push	hl
		push	hl

		ld	sp,5717h
		push	hl
		push	hl
		push	hl
		dec	sp
		dec	sp
		push	hl
		push	hl
		push	hl

		ld	sp,5037h
		push	hl
		push	hl
		push	hl
		dec	sp
		dec	sp
		push	hl
		push	hl
		push	hl

		ld	sp,5137h
		push	hl
		push	hl
		push	hl
		dec	sp
		dec	sp
		push	hl
		push	hl
		push	hl

		ld	sp,5237h
		push	hl
		push	hl
		push	hl
		dec	sp
		dec	sp
		push	hl
		push	hl
		push	hl

		ld	sp,5337h
		push	hl
		push	hl
		push	hl
		dec	sp
		dec	sp
		push	hl
		push	hl
		push	hl

		ld	sp,5437h
		push	hl
		push	hl
		push	hl
		dec	sp
		dec	sp
		push	hl
		push	hl
		push	hl

		ld	sp,5537h
		push	hl
		push	hl
		push	hl
		dec	sp
		dec	sp
		push	hl
		push	hl
		push	hl

		ld	sp,5637h
		push	hl
		push	hl
		push	hl
		dec	sp
		dec	sp
		push	hl
		push	hl
		push	hl

		ld	sp,5737h
		push	hl
		push	hl
		push	hl
		dec	sp
		dec	sp
		push	hl
		push	hl
		push	hl

		ld	sp,5057h
		push	hl
		push	hl
		push	hl
		dec	sp
		dec	sp
		push	hl
		push	hl
		push	hl

		ld	sp,5157h
		push	hl
		push	hl
		push	hl
		dec	sp
		dec	sp
		push	hl
		push	hl
		push	hl

		ld	sp,5257h
		push	hl
		push	hl
		push	hl
		dec	sp
		dec	sp
		push	hl
		push	hl
		push	hl

		ld	sp,5357h
		push	hl
		push	hl
		push	hl
		dec	sp
		dec	sp
		push	hl
		push	hl
		push	hl

		ld	sp,5457h
		push	hl
		push	hl
		push	hl
		dec	sp
		dec	sp
		push	hl
		push	hl
		push	hl

		ld	sp,(Analyzer_addr_sp)
		ret
;-------------------------------------------------------------------
; описание: Обновление параметров анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_init:
              	ld	b, 6
		ld	hl,Analyzer_ch0_vol

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
; описание: Таблица адресов на фазы анализатора
;---------------------------------------------------------------------
Analyzer_table_addr:
		dw	5029h				;0
		dw	5709h	               		;1
		dw	5609h            		;2
		dw	5509h               		;3
		dw	5409h               		;4
		dw	5309h               		;5
		dw	5209h               		;6
		dw	5109h               		;7
		dw	5009h              		;8
		dw	4FE9h             		;9
		dw	4EE9h               		;10
		dw	4DE9h               		;11
		dw	4CE9h               		;12
		dw	4BE9h               		;13
		dw	4AE9h               		;14
		dw	49E9h               		;15

Analyzer_table_data:
		dw	Analyzer_snow_data_00		;0
		dw	Analyzer_snow_data_01  		;1
		dw	Analyzer_snow_data_02 		;2

Analyzer_snow_data_00:
		db	14h,50h
		db	12h,90h
		db	71h,1Ch
		db	09h,20h
		db	45h,44h
		db	20h,08h
		db	1Dh,70h
		db	20h,08h
		db	45h,44h
		db	09h,20h
		db	71h,1Ch
		db	12h,90h
		db	14h,50h

Analyzer_snow_data_01:
		db	22h,88h
		db	61h,0Ch
		db	12h,90h
		db	04h,40h
		db	0Ch,60h
		db	52h,94h
		db	21h,08h
		db	52h,94h
		db	0Ch,60h
		db	04h,40h
		db	12h,90h
		db	61h,0Ch
		db	22h,88h

Analyzer_snow_data_02:
		db	22h,88h
		db	61h,0Ch
		db	10h,10h
		db	0Bh,0A0h
		db	04h,40h
		db	4Ah,0A4h
		db	29h,28h
		db	4Ah,0A4h
		db	04h,40h
		db	0Bh,0A0h
		db	10h,10h
		db	61h,0Ch
		db	22h,88h

;-------------------------------------------------------------------
; описание:  Переменные правого и левого каналов анализатора
;---------------------------------------------------------------------
Analyzer_ch0_vol:
		db	0
Analyzer_ch1_vol:
		db	0
Analyzer_ch2_vol:
		db	0
Analyzer_ch3_vol:
		db	0
Analyzer_ch4_vol:
		db	0
Analyzer_ch5_vol:
		db	0

Analyzer_addr_sp:
		dw	0
