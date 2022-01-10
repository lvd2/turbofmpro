;--------------------------------------------------------------------
; Описание: Модуль отображения анализатора
; Автор порта: Тарасов М.Н.(Mick),2010
;--------------------------------------------------------------------

;-------------------------------------------------------------------
; описание: Бегущие атрибуты
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Attribute_update:
		ld	a,(Attribute_phase)
		and	a
		jr	nz,Attribute_next

		ld	a,(Attribute_count)
		inc	a
		ld	(Attribute_count),a
		ret 	nz

Attribute_next:
		ld	a,(Attribute_pause)
		and	a
		jr	z,Attribute_line_1
		inc	a
		ld	(Attribute_pause),a
		and	3
		ret	nz
		xor	a
		ld	(Attribute_pause),a
		ret

Attribute_line_1:
		inc	a
		ld	(Attribute_pause),a
		ld	a,(Attribute_phase)
		ld	hl,58B2h
		ld	de,58B3h
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		inc	hl
		ld	(hl),71h
		and	a
		jr	nz,Attribute_line_2
		ld	(hl),79h

Attribute_line_2:
		ld	hl,58D2h
		ld	de,58D3h
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		inc	hl
		ld	(hl),71h
		dec	a
		jr	nz,Attribute_line_3
		ld	(hl),79h

Attribute_line_3:
		ld	hl,58F2h
		ld	de,58F3h
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		inc	hl
		ld	(hl),71h
		dec	a
		jr	nz,Attribute_line_4
		ld	(hl),79h

Attribute_line_4:
		ld	hl,5912h
		ld	de,5913h
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		inc	hl
		ld	(hl),71h
		dec	a
		jr	nz,Attribute_line_5
		ld	(hl),79h

Attribute_line_5:
		ld	a,(Attribute_phase)
		inc	a
		ld	(Attribute_phase),a
                cp	22
		ret	c
		xor	a
		ld	(Attribute_phase),a
		ld	(Attribute_pause),a
		ret
;-------------------------------------------------------------------
; описание: Обновление параметров анализатора
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
Attribute_init:
		xor	a
		ld	(Attribute_count),a
		ld	(Attribute_phase),a
		ld	(Attribute_pause),a
		ret

;-------------------------------------------------------------------
; описание:  Переменные правого и левого каналов анализатора
;---------------------------------------------------------------------
Attribute_count:
		db	0	
Attribute_phase:
		db	0	
Attribute_pause:
		db	0	
;		.end