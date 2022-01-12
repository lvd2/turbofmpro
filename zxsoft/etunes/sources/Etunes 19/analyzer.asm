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
		ld	a,(Analyzer_ch0_vol)
		ld	c,a
		ld	a,(Analyzer_ch0_oldvol)
		ld	de,5062h
		call	Analyzer_draw
		ld	(Analyzer_ch0_oldvol),a

		ld	a,(Analyzer_ch1_vol)
		ld	c,a
		ld	a,(Analyzer_ch1_oldvol)
		ld	de,5062h + 5
		call	Analyzer_draw
		ld	(Analyzer_ch1_oldvol),a

		ld	a,(Analyzer_ch2_vol)
		ld	c,a
		ld	a,(Analyzer_ch2_oldvol)
		ld	de,5062h + 10
		call	Analyzer_draw
		ld	(Analyzer_ch2_oldvol),a

		ld	a,(Analyzer_ch3_vol)
		ld	c,a
		ld	a,(Analyzer_ch3_oldvol)
		ld	de,5062h + 15
		call	Analyzer_draw
		ld	(Analyzer_ch3_oldvol),a

		ld	a,(Analyzer_ch4_vol)
		ld	c,a
		ld	a,(Analyzer_ch4_oldvol)
		ld	de,5062h + 20
		call	Analyzer_draw
		ld	(Analyzer_ch4_oldvol),a

		ld	a,(Analyzer_ch5_vol)
		ld	c,a
		ld	a,(Analyzer_ch5_oldvol)
		ld	de,5062h + 25
		call	Analyzer_draw
		ld	(Analyzer_ch5_oldvol),a
		ret
;-------------------------------------------------------------------
; описание: Отрисовка левого канала анализатора
; параметры: HL - адрес экрана
;            C - позиция в индикаторе
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_draw:
		xor	c
		cp	9
		jr	c,Analyzer_draw_view
		sra	a
		ld	c,a
Analyzer_draw_view:
		ld	a,c
		push	af
		ld	l,a
		ld	h,0
		add	hl,hl
		ld	bc,Animation_table_phase
		add	hl,bc
		ld	a,(hl)
		inc	hl
		ld	h,(hl)
		ld	l,a
		ex	de,hl

		ld	b,19				;размерность по Y
Analyzer_loop_Y:
		push	hl
		ex	hl,de
		ldi
		ldi
		ldi
		ex	hl,de
		pop	hl
		inc	h
		ld	a,h
		and 	7
		jr	nz,Analyzer_next_line
		ld	a,l
		add	20h
		ld	l,a
		jr	c,Analyzer_next_line
		ld	a,h
		sub	8
		ld	h,a
Analyzer_next_line:
    		djnz    Analyzer_loop_Y
		pop	af
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
		ld	hl,Analyzer_table_0
		ld	e,a
		ld	d,0
		add	hl,de
		ld	a,(hl)
		ld	hl,5846h
		ld	(hl),a
		inc	l
		ld	(hl),a

		ld	a,(Analyzer_ch1_vol)
		ld	e,a
		ld	a,(Analyzer_ch4_vol)
		add	e
		and	0Fh
		ld	hl,Analyzer_table_0
		ld	e,a
		ld	d,0
		add	hl,de
		ld	a,(hl)
		ld	hl,5804h
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
		ld	hl,Analyzer_table_1
		ld	e,a
		ld	d,0
		add	hl,de
		ld	a,(hl)
		ld	hl,5A06h
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
; описание: Обновление параметров анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Analyzer_init:
              	ld	b, 12
		ld	hl,Analyzer_ch0_vol

Analyzer_init_loop:
                ld	(hl),0
		inc	hl
		djnz	Analyzer_init_loop
		ret
;-------------------------------------------------------------------
; описание:  Переменные правого и левого каналов анализатора
;---------------------------------------------------------------------
Analyzer_table_0:
		db	47h,47h,47h,46h,46h,46h,45h,45h,45h,44h,44h,44h,43h,43h,42h,42h	
Analyzer_table_1:
		db	4Fh,4Fh,4Fh,4Eh,4Eh,4Eh,4Dh,4Dh,4Dh,4Ch,4Ch,4Bh,4Bh,4Ah,4Ah,4Ah	
;-------------------------------------------------------------------
; описание: Таблица адресов на фазы анализатора
;---------------------------------------------------------------------
Animation_table_phase:
		dw	Analyzer_phase_00		;0
		dw	Analyzer_phase_01               ;1
		dw	Analyzer_phase_01               ;2
		dw	Analyzer_phase_02               ;3
		dw	Analyzer_phase_10               ;4
		dw	Analyzer_phase_03               ;5
		dw	Analyzer_phase_12               ;6
		dw	Analyzer_phase_04               ;7
		dw	Analyzer_phase_14               ;8
		dw	Analyzer_phase_05               ;9
		dw	Analyzer_phase_13               ;10
		dw	Analyzer_phase_06               ;11
		dw	Analyzer_phase_11               ;12
		dw	Analyzer_phase_07               ;13
		dw	Analyzer_phase_08               ;14
		dw	Analyzer_phase_09               ;15


Analyzer_phase_00:
		db	08h,00h,10h
		db	30h,42h,0Ch
		db	40h,42h,02h
		db	88h,00h,11h
		db	08h,00h,10h
		db	00h,00h,00h
		db	00h,00h,00h
		db	00h,00h,00h
		db	80h,00h,01h
		db	00h,00h,00h
		db	00h,00h,00h
		db	00h,08h,00h
		db	00h,1Ch,00h
		db	00h,78h,00h
		db	01h,0E0h,00h
		db	07h,80h,00h
		db	1Eh,00h,00h
		db	38h,00h,00h
		db	60h,00h,00h

Analyzer_phase_01:
		db	08h,00h,10h
		db	30h,42h,0Ch
		db	40h,42h,02h
		db	88h,00h,11h
		db	08h,00h,10h
		db	00h,00h,00h
		db	00h,00h,00h
		db	00h,00h,00h
		db	80h,00h,01h
		db	00h,00h,00h
		db	00h,00h,00h
		db	00h,04h,00h
		db	3Fh,0F8h,00h
		db	0FFh,0F8h,00h
		db	00h,04h,00h
		db	00h,00h,00h
		db	00h,00h,00h
		db	00h,00h,00h
		db	00h,00h,00h

Analyzer_phase_02:
		db	08h,00h,10h
		db	30h,42h,0Ch
		db	40h,42h,02h
		db	88h,00h,11h
		db	08h,00h,10h
		db	00h,00h,00h
		db	00h,00h,00h
		db	00h,00h,00h
		db	80h,00h,01h
		db	20h,00h,00h
		db	18h,00h,00h
		db	0Eh,00h,00h
		db	03h,80h,00h
		db	00h,0F0h,00h
		db	00h,78h,00h
		db	00h,10h,00h
		db	00h,00h,00h
		db	00h,00h,00h
		db	00h,00h,00h

Analyzer_phase_03:
		db	08h,00h,10h
		db	30h,42h,0Ch
		db	40h,42h,02h
		db	88h,00h,11h
		db	08h,00h,10h
		db	00h,00h,00h
		db	04h,00h,00h
		db	06h,00h,00h
		db	83h,00h,01h
		db	01h,80h,00h
		db	00h,0C0h,00h
		db	00h,60h,00h
		db	00h,38h,00h
		db	00h,1Ch,00h
		db	00h,08h,00h
		db	00h,00h,00h
		db	00h,00h,00h
		db	00h,00h,00h
		db	00h,00h,00h

Analyzer_phase_04:
		db	08h,00h,10h
		db	30h,42h,0Ch
		db	40h,42h,02h
		db	88h,00h,11h
		db	08h,40h,10h
		db	00h,40h,00h
		db	00h,60h,00h
		db	00h,60h,00h
		db	80h,20h,01h
		db	00h,30h,00h
		db	00h,30h,00h
		db	00h,10h,00h
		db	00h,18h,00h
		db	00h,18h,00h
		db	00h,24h,00h
		db	00h,00h,00h
		db	00h,00h,00h
		db	00h,00h,00h
		db	00h,00h,00h

Analyzer_phase_05:
		db	08h,00h,10h
		db	30h,42h,0Ch
		db	40h,42h,02h
		db	88h,00h,11h
		db	08h,02h,10h
		db	00h,02h,00h
		db	00h,06h,00h
		db	00h,06h,00h
		db	80h,04h,01h
		db	00h,0Ch,00h
		db	00h,0Ch,00h
		db	00h,08h,00h
		db	00h,18h,00h
		db	00h,18h,00h
		db	00h,24h,00h
		db	00h,00h,00h
		db	00h,00h,00h
		db	00h,00h,00h
		db	00h,00h,00h

Analyzer_phase_06:
		db	08h,00h,10h
		db	30h,42h,0Ch
		db	40h,42h,02h
		db	88h,00h,11h
		db	08h,00h,10h
		db	00h,00h,00h
		db	00h,00h,20h
		db	00h,00h,60h
		db	80h,00h,0C1h
		db	00h,01h,80h
		db	00h,03h,00h
		db	00h,06h,00h
		db	00h,1Ch,00h
		db	00h,38h,00h
		db	00h,10h,00h
		db	00h,00h,00h
		db	00h,00h,00h
		db	00h,00h,00h
		db	00h,00h,00h

Analyzer_phase_07:
		db	08h,00h,10h
		db	30h,42h,0Ch
		db	40h,42h,02h
		db	88h,00h,11h
		db	08h,00h,10h
		db	00h,00h,00h
		db	00h,00h,00h
		db	00h,00h,00h
		db	80h,00h,01h
		db	00h,00h,04h
		db	00h,00h,18h
		db	00h,00h,70h
		db	00h,01h,0C0h
		db	00h,0Fh,00h
		db	00h,1Eh,00h
		db	00h,08h,00h
		db	00h,00h,00h
		db	00h,00h,00h
		db	00h,00h,00h

Analyzer_phase_08:
		db	08h,00h,10h
		db	30h,42h,0Ch
		db	40h,42h,02h
		db	88h,00h,11h
		db	08h,00h,10h
		db	00h,00h,00h
		db	00h,00h,00h
		db	00h,00h,00h
		db	80h,00h,01h
		db	00h,00h,00h
		db	00h,00h,00h
		db	00h,20h,00h
		db	00h,1Fh,0FCh
		db	00h,1Fh,0FFh
		db	00h,20h,00h
		db	00h,00h,00h
		db	00h,00h,00h
		db	00h,00h,00h
		db	00h,00h,00h

Analyzer_phase_09:
		db	08h,00h,10h
		db	30h,42h,0Ch
		db	40h,42h,02h
		db	88h,00h,11h
		db	08h,00h,10h
		db	00h,00h,00h
		db	00h,00h,00h
		db	00h,00h,00h
		db	80h,00h,01h
		db	00h,00h,00h
		db	00h,00h,00h
		db	00h,10h,00h
		db	00h,38h,00h
		db	00h,1Eh,00h
		db	00h,07h,80h
		db	00h,01h,0E0h
		db	00h,00h,78h
		db	00h,00h,1Ch
		db	00h,00h,06h

Analyzer_phase_10:
		db	08h,00h,10h
		db	30h,42h,0Ch
		db	40h,42h,02h
		db	88h,00h,11h
		db	08h,00h,10h
		db	00h,00h,00h
		db	00h,00h,00h
		db	10h,00h,00h
		db	88h,00h,01h
		db	0Ch,00h,00h
		db	07h,00h,00h
		db	01h,80h,00h
		db	00h,0C0h,00h
		db	00h,70h,00h
		db	00h,38h,00h
		db	00h,10h,00h
		db	00h,00h,00h
		db	00h,00h,00h
		db	00h,00h,00h

Analyzer_phase_11:
		db	08h,00h,10h
		db	30h,42h,0Ch
		db	40h,42h,02h
		db	88h,00h,11h
		db	08h,00h,10h
		db	00h,00h,00h
		db	00h,00h,00h
		db	00h,00h,08h
		db	80h,00h,11h
		db	00h,00h,30h
		db	00h,00h,0E0h
		db	00h,01h,80h
		db	00h,03h,00h
		db	00h,0Eh,00h
		db	00h,1Ch,00h
		db	00h,08h,00h
		db	00h,00h,00h
		db	00h,00h,00h
		db	00h,00h,00h

Analyzer_phase_12:
		db	08h,00h,10h
		db	30h,42h,0Ch
		db	40h,42h,02h
		db	88h,00h,11h
		db	09h,00h,10h
		db	00h,80h,00h
		db	00h,80h,00h
		db	00h,0C0h,00h
		db	80h,40h,01h
		db	00h,60h,00h
		db	00h,20h,00h
		db	00h,30h,00h
		db	00h,18h,00h
		db	00h,1Ch,00h
		db	00h,10h,00h
		db	00h,00h,00h
		db	00h,00h,00h
		db	00h,00h,00h
		db	00h,00h,00h

Analyzer_phase_13:
		db	08h,00h,10h
		db	30h,42h,0Ch
		db	40h,42h,02h
		db	88h,00h,11h
		db	08h,00h,90h
		db	00h,01h,00h
		db	00h,01h,00h
		db	00h,03h,00h
		db	80h,02h,01h
		db	00h,06h,00h
		db	00h,04h,00h
		db	00h,0Ch,00h
		db	00h,18h,00h
		db	00h,38h,00h
		db	00h,08h,00h
		db	00h,00h,00h
		db	00h,00h,00h
		db	00h,00h,00h
		db	00h,00h,00h

Analyzer_phase_14:
		db	08h,00h,10h
		db	30h,42h,0Ch
		db	40h,42h,02h
		db	88h,08h,11h
		db	08h,08h,10h
		db	00h,18h,00h
		db	00h,18h,00h
		db	00h,18h,00h
		db	80h,18h,01h
		db	00h,18h,00h
		db	00h,18h,00h
		db	00h,18h,00h
		db	00h,18h,00h
		db	00h,18h,00h
		db	00h,24h,00h
		db	00h,00h,00h
		db	00h,00h,00h
		db	00h,00h,00h
		db	00h,00h,00h
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
Analyzer_ch0_oldvol:
		db	0
Analyzer_ch1_oldvol:
		db	0
Analyzer_ch2_oldvol:
		db	0
Analyzer_ch3_oldvol:
		db	0
Analyzer_ch4_oldvol:
		db	0
Analyzer_ch5_oldvol:
		db	0
