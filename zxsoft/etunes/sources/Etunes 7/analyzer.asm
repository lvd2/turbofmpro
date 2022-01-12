;--------------------------------------------------------------------
; Описание: Модуль отображения анализатора
; Автор порта: Тарасов М.Н.(Mick),2010
;--------------------------------------------------------------------
		org	0D000h
;-------------------------------------------------------------------
; описание: Обновление параметров анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_update:
		ld	hl,ESIAmplitude_ch0

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
Analyzer_view_0:
		call	Analyzer_view_ch0
		call	Analyzer_view_ch1
		call	Analyzer_view_ch3
		call	Analyzer_view_ch4
		ret
;-------------------------------------------------------------------
; описание: Отображение анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_view_1:
		call	Analyzer_view_ch0
		call	Analyzer_view_ch1
		call	Analyzer_view_ch3
		jp	Analyzer_view_ch5
;-------------------------------------------------------------------
; описание: Отображение анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_view_2:
		call	Analyzer_view_ch6
		call	Analyzer_view_ch2
		call	Analyzer_view_ch3
		jp	Analyzer_view_ch4
;-------------------------------------------------------------------
; описание: Отображение линии
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_no_volume:
		ld 	a,0FFh				;нет уровня,рисует прямую линию
		ld 	(hl),a
		inc 	l
		ld 	(hl),a
		inc 	l
		ld 	(hl),a
		inc 	l
		ld 	(hl),a
		inc 	l
		ld 	(hl),a
		inc 	l
		ld 	(hl),a
		ret
;-------------------------------------------------------------------
; описание: Отрисовка левого канала анализатора
; параметры: HL - адрес экрана
;            C - позиция в индикаторе
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_draw_flash:
		ld	hl,(Analyzer_ch3_vol)		;Analyzer_ch3_vol
		ld	a,(hl)
		inc	hl
		add	(hl)
		inc	hl
		add	(hl)
		and	0Fh
		ld	hl,Analyzer_table
		ld	e,a
		ld	d,0
		add	hl,de
		ld	a,(hl)
		ld	hl,5ADDh
		ld	(hl),a
		inc	l
		ld	(hl),a
		ld	l,0FDh
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
              	ld	b, 6
		ld	hl,Analyzer_ch0_vol

Analyzer_init_loop:
                ld	(hl),0
		inc	hl
		djnz	Analyzer_init_loop
		ret
;-------------------------------------------------------------------
; описание: Обновление параметров анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_clear:
		ld 	(Analyzer_adr_sp),sp
		ld 	de,0
		ld 	sp,40DFh
		push 	de  				;5 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;3 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;2 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;1 канал
		push 	de
		push 	de

		ld 	sp,41DFh
		push 	de  				;5 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;3 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;2 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;1 канал
		push 	de
		push 	de

		ld 	sp,42DFh
		push 	de  				;5 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;3 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;2 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;1 канал
		push 	de
		push 	de

		ld 	sp,43DFh
		push 	de  				;5 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;3 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;2 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;1 канал
		push 	de
		push 	de

		ld 	sp,44DFh
		push 	de  				;5 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;3 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;2 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;1 канал
		push 	de
		push 	de

		ld 	sp,45DFh
		push 	de  				;5 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;3 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;2 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;1 канал
		push 	de
		push 	de

		ld 	sp,46DFh
		push 	de  				;5 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;3 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;2 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;1 канал
		push 	de
		push 	de

		ld 	sp,47DFh
		push 	de  				;5 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;3 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;2 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;1 канал
		push 	de
		push 	de

		ld 	sp,40FFh
		push 	de  				;5 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;3 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;2 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;1 канал
		push 	de
		push 	de

		ld 	sp,41FFh
		push 	de  				;5 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;3 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;2 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;1 канал
		push 	de
		push 	de

		ld 	sp,42FFh
		push 	de  				;5 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;3 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;2 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;1 канал
		push 	de
		push 	de

		ld 	sp,43FFh
		push 	de  				;5 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;3 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;2 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;1 канал
		push 	de
		push 	de

		ld 	sp,44FFh
		push 	de  				;5 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;3 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;2 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;1 канал
		push 	de
		push 	de

		ld 	sp,45FFh
		push 	de  				;5 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;3 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;2 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;1 канал
		push 	de
		push 	de

		ld 	sp,46FFh
		push 	de  				;5 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;3 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;2 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;1 канал
		push 	de
		push 	de

		ld 	sp,47FFh
		push 	de  				;5 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;3 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;2 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;1 канал
		push 	de
		push 	de

		ld 	sp,481Fh
		push 	de  				;5 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;3 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;2 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;1 канал
		push 	de
		push 	de

		ld 	sp,491Fh
		push 	de  				;5 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;3 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;2 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;1 канал
		push 	de
		push 	de

		ld 	sp,4A1Fh
		push 	de  				;5 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;3 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;2 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;1 канал
		push 	de
		push 	de

		ld 	sp,4B1Fh
		push 	de  				;5 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;3 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;2 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;1 канал
		push 	de
		push 	de

		ld 	sp,4C1Fh
		push 	de  				;5 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;3 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;2 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;1 канал
		push 	de
		push 	de

		ld 	sp,4D1Fh
		push 	de  				;5 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;3 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;2 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;1 канал
		push 	de
		push 	de

		ld 	sp,4E1Fh
		push 	de  				;5 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;3 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;2 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;1 канал
		push 	de
		push 	de

		ld 	sp,4F1Fh
		push 	de  				;5 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;3 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;2 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;1 канал
		push 	de
		push 	de

		ld 	sp,483Fh
		push 	de  				;5 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;3 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;2 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;1 канал
		push 	de
		push 	de

		ld 	sp,493Fh
		push 	de  				;5 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;3 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;2 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;1 канал
		push 	de
		push 	de

		ld 	sp,4A3Fh
		push 	de  				;5 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;3 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;2 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;1 канал
		push 	de
		push 	de

		ld 	sp,4B3Fh
		push 	de  				;5 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;3 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;2 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;1 канал
		push 	de
		push 	de

		ld 	sp,4C3Fh
		push 	de  				;5 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;3 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;2 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;1 канал
		push 	de
		push 	de

		ld 	sp,4D3Fh
		push 	de  				;5 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;3 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;2 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;1 канал
		push 	de
		push 	de

		ld 	sp,4E3Fh
		push 	de  				;5 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;3 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;2 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;1 канал
		push 	de
		push 	de

		ld 	sp,4F3Fh
		push 	de  				;5 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;3 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;2 канал
		push 	de
		push 	de

		dec	sp
		dec	sp

		push 	de                              ;1 канал
		push 	de
		push 	de

		ld 	sp,(Analyzer_adr_sp)
		ret
;-------------------------------------------------------------------
; описание: Отображение анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_view_ch0:
		ld	a,(Analyzer_ch0_vol)
		and 	a
		ld 	hl,4801h
		jp 	z,Analyzer_no_volume
		add 	a,0DFh
		ld 	h,a
		ld 	l,0
		ld 	(Analyzer_draw_0 +1),hl
		ld	a,(ESINoise_enable)
		and	1				;Noise enable 0 ch
		jr 	z,Analyzer_tune_0

		ld 	e,0F8h
		ld 	d,0
		jr 	Analyzer_data_0

Analyzer_tune_0:
		ld	a,(ESIOctave_ch0)
		and	0Fh
		ld 	d,a
		ld	a,(ESIFrequency_ch0)
		ld 	e,a
Analyzer_data_0:
		call 	Analyzer_unpack_data
		ld 	(Analyzer_draw_2 +1),a
		ld 	hl,Analyzer_data_ch0
		ld 	(Analyzer_draw_wave +1),hl
		ld 	a,0EFh
		ld 	(Analyzer_draw_3 +1),a
		jp	Analyzer_draw_wave

;-------------------------------------------------------------------
; описание: Отображение анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_view_ch1:
		ld	a,(Analyzer_ch1_vol)
		and 	a
		ld 	hl,4809h
		jp 	z,Analyzer_no_volume
		add 	a,0DFh
		ld 	h,a
		ld 	l,0
		ld 	(Analyzer_draw_0 +1),hl
		ld	a,(ESINoise_enable)
		and	2				;Noise enable 1 ch
		jr 	z,Analyzer_tune_1

		ld 	e,0F8h
		ld 	d,0
		jr 	Analyzer_data_1

Analyzer_tune_1:
		ld	a,(ESIOctave_ch0)
		and	0F0h
		rrca
		rrca
		rrca	
		rrca
		ld 	d,a
		ld	a,(ESIFrequency_ch1)
		ld 	e,a
Analyzer_data_1:
		call 	Analyzer_unpack_data
		ld 	(Analyzer_draw_2 +1),a
		ld 	hl,Analyzer_data_ch1
		ld 	(Analyzer_draw_wave +1),hl
		ld 	a,0F0h
		ld 	(Analyzer_draw_3 +1),a
		jp	Analyzer_draw_wave
;-------------------------------------------------------------------
; описание: Отображение анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_view_ch3:
		ld	a,(Analyzer_ch3_vol)
		and 	a
		ld 	hl,4811h
		jp 	z,Analyzer_no_volume
		add 	a,0DFh
		ld 	h,a
		ld 	l,0
		ld 	(Analyzer_draw_0 +1),hl
		ld	a,(ESINoise_enable)
		and	8				;Noise enable 3 ch
		jr 	z,Analyzer_tune_3

		ld 	e,0F8h
		ld 	d,0
		jr 	Analyzer_data_3

Analyzer_tune_3:
		ld	a,(ESIOctave_ch2)
		and	0F0h
		rrca
		rrca
		rrca	
		rrca
		ld 	d,a
		ld	a,(ESIFrequency_ch3)
		ld 	e,a
Analyzer_data_3:
		call 	Analyzer_unpack_data
		ld 	(Analyzer_draw_2 +1),a
		ld 	hl,Analyzer_data_ch3
		ld 	(Analyzer_draw_wave +1),hl
		ld 	a,0F1h
		ld 	(Analyzer_draw_3 +1),a
		jp	Analyzer_draw_wave
;-------------------------------------------------------------------
; описание: Отображение анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_view_ch4:
		ld	a,(Analyzer_ch4_vol)
		and 	a
		ld 	hl,4819h
		jp 	z,Analyzer_no_volume
		add 	a,0DFh
		ld 	h,a
		ld 	l,0
		ld 	(Analyzer_draw_0 +1),hl
		ld	a,(ESINoise_enable)
		and	10h				;Noise enable 4 ch
		jr 	z,Analyzer_tune_4

		ld 	e,0F8h
		ld 	d,0
		jr 	Analyzer_data_4

Analyzer_tune_4:
		ld	a,(ESIOctave_ch4)
		and	0Fh
		ld 	d,a
		ld	a,(ESIFrequency_ch4)
		ld 	e,a
Analyzer_data_4:
		call 	Analyzer_unpack_data
		ld 	(Analyzer_draw_2 +1),a
		ld 	hl,Analyzer_data_ch4
		ld 	(Analyzer_draw_wave +1),hl
		ld 	a,0F2h
		ld 	(Analyzer_draw_3 +1),a
		jp	Analyzer_draw_wave
;-------------------------------------------------------------------
; описание: Отображение анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_view_ch5:
		ld	a,(Analyzer_ch5_vol)
		and 	a
		ld 	hl,4819h
		jp 	z,Analyzer_no_volume
		add 	a,0DFh
		ld 	h,a
		ld 	l,0
		ld 	(Analyzer_draw_0 +1),hl
		ld	a,(ESINoise_enable)
		and	20h				;Noise enable 4 ch
		jr 	z,Analyzer_tune_5

		ld 	e,0F8h
		ld 	d,0
		jr 	Analyzer_data_5

Analyzer_tune_5:
		ld	a,(ESIOctave_ch4)
		and	0F0h
		rrca
		rrca	
		rrca
		rrca
		ld 	d,a
		ld	a,(ESIFrequency_ch5)
		ld 	e,a
Analyzer_data_5:
		call 	Analyzer_unpack_data
		ld 	(Analyzer_draw_2 +1),a
		ld 	hl,Analyzer_data_ch5
		ld 	(Analyzer_draw_wave +1),hl
		ld 	a,0F2h
		ld 	(Analyzer_draw_3 +1),a
		jp	Analyzer_draw_wave
;-------------------------------------------------------------------
; описание: Отображение анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_view_ch6:
		ld	a,(Analyzer_ch5_vol)
		and 	a
		ld 	hl,4801h
		jp 	z,Analyzer_no_volume
		add 	a,0DFh
		ld 	h,a
		ld 	l,0
		ld 	(Analyzer_draw_0 +1),hl
		ld	a,(ESINoise_enable)
		and	20h				;Noise enable 4 ch
		jr 	z,Analyzer_tune_6

		ld 	e,0F8h
		ld 	d,0
		jr 	Analyzer_data_6

Analyzer_tune_6:
		ld	a,(ESIOctave_ch4)
		and	0F0h
		rrca
		rrca	
		rrca
		rrca
		ld 	d,a
		ld	a,(ESIFrequency_ch5)
		ld 	e,a
Analyzer_data_6:
		call 	Analyzer_unpack_data
		ld 	(Analyzer_draw_2 +1),a
		ld 	hl,Analyzer_data_ch5
		ld 	(Analyzer_draw_wave +1),hl
		ld 	a,0EFh
		ld 	(Analyzer_draw_3 +1),a
		jp	Analyzer_draw_wave
;-------------------------------------------------------------------
; описание: Отображение анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_view_ch2:
		ld	a,(Analyzer_ch2_vol)
		and 	a
		ld 	hl,4809h
		jp 	z,Analyzer_no_volume
		add 	a,0DFh
		ld 	h,a
		ld 	l,0
		ld 	(Analyzer_draw_0 +1),hl
		ld	a,(ESINoise_enable)
		and	4				;Noise enable 1 ch
		jr 	z,Analyzer_tune_2

		ld 	e,0F8h
		ld 	d,0
		jr 	Analyzer_data_2

Analyzer_tune_2:
		ld	a,(ESIOctave_ch2)
		and	0Fh
		ld 	d,a
		ld	a,(ESIFrequency_ch2)
		ld 	e,a
Analyzer_data_2:
		call 	Analyzer_unpack_data
		ld 	(Analyzer_draw_2 +1),a
		ld 	hl,Analyzer_data_ch2
		ld 	(Analyzer_draw_wave +1),hl
		ld 	a,0F0h
		ld 	(Analyzer_draw_3 +1),a
		jp	Analyzer_draw_wave
;-------------------------------------------------------------------
; описание: Преобразование параметров
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_unpack_data:
		bit 	3,d
		jr 	z,Analyzer_unpack_0
		srl 	d
		ld 	a,8
		sub 	d
		ret

Analyzer_unpack_0:
		bit 	2,d
		jr 	z,Analyzer_unpack_1
		ld 	a,0Ch
		sub 	d
		ret

Analyzer_unpack_1:
		bit 	1,d
		jr 	z,Analyzer_unpack_2
		sla 	e
		rl 	d
		ld 	a,10h
		sub 	d
		ret

Analyzer_unpack_2:
		bit 	0,d
		jr 	z,Analyzer_unpack_3
		sla 	e
		rl 	d
		sla 	e
		rl 	d
		ld 	a,14h
		sub 	d
		ret

Analyzer_unpack_3:
		bit 	7,e
		jr 	z,Analyzer_unpack_4
		ld 	a,e
		rra
		rra
		rra
		rra
		rra
		and 	7
		ld 	e,a
		ld 	a,18h
		sub 	e
		ret

Analyzer_unpack_4:
		bit 	6,e
		jr 	z,Analyzer_unpack_5
		ld 	a,e
		rra
		rra
		rra
		rra
		and 	7
		ld 	e,a
		ld 	a,1Ch
		sub 	e
		ret

Analyzer_unpack_5:
		bit 	5,e
		jr 	z,Analyzer_unpack_6
		ld 	a,e
		rra
		rra
		rra
		and 	7
		ld 	e,a
		ld 	a,20h
		sub 	e
		ret

Analyzer_unpack_6:
		bit 	4,e
		jr 	z,Analyzer_unpack_7
		srl 	e
		srl 	e
		ld 	a,24h
		sub 	e
		ret

Analyzer_unpack_7:
		bit 	3,e
		jr 	z,Analyzer_unpack_8
		srl 	e
		ld 	a,28h
		sub 	e
		ret

Analyzer_unpack_8:
		ld 	a,30h
		sub 	e
		ret
;-------------------------------------------------------------------
; описание: Отображение анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_draw_wave:
		ld 	de,0
Analyzer_draw_0:
		ld 	bc,0				;Tune Volume
		ld 	a,(de)
		ld 	c,a
		add 	a,10h
		ld 	(de),a
Analyzer_draw_2:
		ld 	d,0
Analyzer_draw_3:
		ld 	e,0
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		add 	a,5
		ld 	l,a
		ld 	a,1
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		add 	a,5
		ld 	l,a
		ld 	a,2
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		add 	a,5
		ld 	l,a
		ld 	a,4
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		add 	a,5
		ld 	l,a
		ld 	a,8
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		add 	a,5
		ld 	l,a
		ld 	a,10h
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		add 	a,5
		ld 	l,a
		ld 	a,20h
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		add 	a,5
		ld 	l,a
		ld 	a,40h
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		add 	a,5
		ld 	l,a
		ld 	a,80h
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		add 	a,4
		ld 	l,a
		ld 	a,1
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		add 	a,4
		ld 	l,a
		ld 	a,2
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		add 	a,4
		ld 	l,a
		ld 	a,4
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		add	a,4
		ld 	l,a
		ld 	a,8
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc	l
		ld 	h,(hl)
		add 	a,4
		ld 	l,a
		ld 	a,10h
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		add 	a,4
		ld 	l,a
		ld 	a,20h
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		add 	a,4
		ld 	l,a
		ld 	a,40h
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		add 	a,4
		ld 	l,a
		ld 	a,80h
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		add 	a,3
		ld 	l,a
		ld 	a,1
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		add	a,3
		ld 	l,a
		ld 	a,2
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		add 	a,3
		ld 	l,a
		ld 	a,4
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		add 	a,3
		ld 	l,a
		ld 	a,8
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		add 	a,3
		ld 	l,a
		ld 	a,10h
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		add 	a,3
		ld 	l,a
		ld 	a,20h
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	L
		ld 	h,(hl)
		add 	a,3
		ld 	l,a
		ld 	a,40h
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		add 	a,3
		ld 	l,a
		ld 	a,80h
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		add 	a,2
		ld 	l,a
		ld 	a,1
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc	l
		ld 	h,(hl)
		add 	a,2
		ld 	l,a
		ld 	a,2
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		add 	a,2
		ld 	l,a
		ld 	a,4
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		add 	a,2
		ld 	l,a
		ld 	a,8
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		add 	a,2
		ld 	l,a
		ld 	a,10h
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		add 	a,2
		ld 	l,a
		ld 	a,20h
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		add 	a,2
		ld 	l,a
		ld 	a,40h
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		add 	a,2
		ld 	l,a
		ld 	a,80h
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		inc 	a
		ld 	l,a
		ld 	a,1
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		inc 	a
		ld 	l,a
		ld 	a,2
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		inc 	a
		ld 	l,a
		ld 	a,4
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		inc 	a
		ld 	l,a
		ld 	a,8
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		inc 	a
		ld 	l,a
		ld 	a,10h
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		inc 	a
		ld 	l,a
		ld 	a,20h
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		inc 	a
		ld 	l,a
		ld 	a,40h
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		inc 	a
		ld 	l,a
		ld 	a,80h
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		ld 	l,a
		ld 	a,1
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		ld 	l,a
		ld 	a,2
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		ld 	l,a
		ld 	a,4
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		ld 	l,a
		ld 	a,8
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		ld 	l,a
		ld 	a,10h
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		ld 	l,a
		ld 	a,20h
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		ld 	l,a
		ld 	a,40h
		or 	(hl)
		ld 	(hl),a
		ld 	a,d
		add 	a,c
		ld 	c,a
		ld 	a,(bc)
		ld 	l,a
		ld 	h,e
		ld 	a,(hl)
		inc 	l
		ld 	h,(hl)
		ld 	l,a
		ld 	a,80h
		or 	(hl)
		ld 	(hl),a
		ret
;-------------------------------------------------------------------
; описание:  Переменные правого и левого каналов анализатора
;---------------------------------------------------------------------
Analyzer_table:
		db	47h,47h,47h,47h,46h,46h,45h,45h,44h,44h,43h,43h,42h,42h,41h,41h	
;-------------------------------------------------------------------
; описание:  Переменные правого и левого каналов анализатора
;---------------------------------------------------------------------
Analyzer_data_ch0:
		db	0
Analyzer_data_ch1:
		db	0
Analyzer_data_ch2:
		db	0
Analyzer_data_ch3:
		db	0
Analyzer_data_ch4:
		db	0
Analyzer_data_ch5:
		db	0
Analyzer_adr_sp:
		dw	0
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
Analyzer_end:
