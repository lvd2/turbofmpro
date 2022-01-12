;--------------------------------------------------------------------
; Описание: Проигрывающий модуль музыкального редактора E-Tracker
; портирован  с компьютера Sam Coupe
; Автор порта: Тарасов М.Н.(Mick),2010
;--------------------------------------------------------------------
;-------------------------------------------------------------------
; описание: Инициализация проигрывателя
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
EPlayer_Init:
		ld	hl,0           			;адрес музыки
		jp	loc_0_83EC                      ;переход на инициализацию проигрывателя
;-------------------------------------------------------------------
; описание: Проигрывание текущей ноты
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
EPlayer_Play:
		ld	a,1				;текущий канал
		dec	a
		jr	nz,loc_0_802A                  ;вывели информацию во все каналы?
		ld	ix,word_0_833A                 ;да,переходим к подготовки новых значений
		ld	b,6                            ;число каналов

loc_0_8011:
		push	bc
		call	sub_0_81A4
		ld	bc,19h                         ;количество байт для одного канала
		add	ix,bc
		pop	bc
		djnz	loc_0_8011
		ld	hl,(word_0_83EA)
		ld	a,h
		call	sub_0_8157
		or	l
		ld	(loc_0_80E5+1),a

loc_0_8028:
		ld	a,6                           ;установим текущий канал для обновления

loc_0_802A:
		ld	(EPlayer_Play+1),a              ;установим новое значение текущего канала
		ld	ix,word_0_833A                
		call	sub_0_826A
		ld	(EAmplitude_ch0),a               ;Amplitude 0 right/left
		ld	(EFrequency_ch0),hl
		push	hl
		ld	hl,0
		call	sub_0_815C
		ld	(loc_0_8055+1),hl
		ld	(loc_0_80E3+1),a
		ld	ix,word_0_8353
		call	sub_0_826A
		ld	(EAmplitude_ch1),a               ;Amplitude 1 right/left
		ld	(EFrequency_ch0+1),hl
		push	hl

loc_0_8055:
		ld	hl,0
		call	sub_0_815C
		ld	(loc_0_8073+1),hl
		rl	h
		jr	nc,loc_0_8065
		ld	(loc_0_80E3+1),a

loc_0_8065:
		ld	ix,word_0_836C
		call	sub_0_826A
		ld	(EAmplitude_ch2),a		;Amplitude 2 right/left
		ld	(EFrequency_ch2),hl
		push	hl

loc_0_8073:
		ld	hl,0
		call	sub_0_815C
		ld	(loc_0_8091+1),hl
		rl	h
		jr	nc,loc_0_8083
		ld	(loc_0_80E3+1),a

loc_0_8083:
		ld	ix,word_0_8385
		call	sub_0_826A
		ld	(EAmplitude_ch3),a		;Amplitude 3 right/left
		ld	(EFrequency_ch2+1),hl
		push	hl

loc_0_8091:
		ld	hl,0
		call	sub_0_815C
		ld	(loc_0_80AB+1),hl
		ld	(loc_0_80DD+1),a

		ld	ix,word_0_839E
		call	sub_0_826A
		ld	(EAmplitude_ch4),a		;Amplitude 4 right/left
		ld	(EFrequency_ch4),hl
		push	hl

loc_0_80AB:
		ld	hl,0
		call	sub_0_815C
		ld	(loc_0_80C9+1),hl
		rl	h
		jr	nc,loc_0_80BB
		ld	(loc_0_80DD+1),a

loc_0_80BB:
		ld	ix,word_0_83B7
		call	sub_0_826A
		ld	(EAmplitude_ch5),a                ;Amplitude 5 right/left
		ld	(EFrequency_ch4+1),hl
		push	hl

loc_0_80C9:
		ld	hl,0
		call	sub_0_815C
		rr	l
		rr	l
		rr	h
		rr	h
		ld	(EFrequency_en),hl               ;Freqency and Noise enable
		rlca	
		jr	c,loc_0_80E0

loc_0_80DD:
		ld	a,0
		rlca	

loc_0_80E0:
		rlca	
		rlca	
		rlca	

loc_0_80E3:
		or	0

loc_0_80E5:
		or	0
		ld	(ENoise_gen),a			;Noise generator 0 and 1
		pop	af
		pop	bc
		call	sub_0_8157
		or	b
		ld	h,a
		pop	af
		pop	bc
		call	sub_0_8157
		or	b
		ld	l,a
		ld	(EOctave_ch2),hl		;Octave 2 and 3 and 4 and 5
		pop	af
		pop	bc
		call	sub_0_8157
		or	b
		ld	(EOctave_ch0),a                ;Octave 1 and 0
		ld	bc,0xfffd
		ld	de,1C01h                       ;регистр 1Сh,бит SE=1
		out	(c),d
		ld b,0xbf
		out	(c),e                          ;разрешить все каналы
		ld	hl,EEnvelope_gen1              ;таблица данных звукового канала
		ld	d,19h                          ;размер данных для одного канала

loc_0_8114:
		ld b,0xff
		out	(c),d                          ;загружаем номер регистра
		ld b,0xbf
		ld	a,(hl)                         ;читаем значение из таблицы
		out	(c),a                          ;выводим в порт
		dec	d                               ;следующий байт
		ret	m                               ;выход по окончании записи
		dec	hl                              ;переходим к следующим значениям
		jr	loc_0_8114                      ;продолжим запись в порт

		db    5  
		db  21h 
		db  3Ch 
		db  55h 
		db  6Dh 
		db  84h 
		db  99h 
		db 0ADh 
		db 0C0h 
		db 0D2h 
		db 0E3h 
		db 0F3h 
unk_0_812C:	db 0FEh 
		db    1   
		db    0   
		db    0   
		db 0FCh 
unk_0_8131:	db    0 
		db  96h 
		db  9Eh 
		db  9Ah 
		db  86h 
		db  8Eh 
		db  8Ah 
		db  97h 
		db  9Fh 
		db  9Bh 
		db  87h 
		db  8Fh 
		db  8Bh 
unk_0_813E:	db 0FEh 
		db    0   
unk_0_8140:	db 0FFh 
		db 0D2h 
		db  57h 
		db  72h 
		db    0 
		db  52h 
		db 0ABh 
		db  51h 
		db  61h 
		db  50h 
		db  52h 
		db  30h 
		db 0C2h 
		db  2Eh 
		db  35h 
		db  21h 
		db  29h
		db  11h 
		db  41h
		db  0Fh
		db  46h
		db    0 
		db  3Ah


sub_0_8157:
		rlca	
		rlca	
		rlca	
		rlca	
		ret	

sub_0_815C:
		ex	af,af'
		rrca	
		rr	l
		rrca	
		rr	h
		ret	

sub_0_8164:
		sla	c
		ld	b,0
		add	hl,bc

sub_0_8169:
		ld	c,(hl)				;читаем  младший байт адреса смещения
		inc	hl
		ld	b,(hl)                         ;читаем старший байт адреса смещения
		inc	hl                              ;переходим к следующему адресу
		push	hl

loc_0_816E:
		ld	hl,0                           ;адрес музыки
		add	hl,bc                          ;получим адрес таблицы
		ld	c,l                            ;младший байт адреса
		ld	b,h                            ;старший байт адреса
		pop	hl
		ret	

loc_0_8176:
		ld	hl,0
		call	sub_0_8164
		ld	(ix++0Fh),c
		ld	(ix++10h),b
		ld	hl,unk_0_812C
		ld	(ix++4),l
		ld	(ix++5),h
		jr	loc_0_81D4
loc_0_818D:
		ld	hl,0
		call	sub_0_8164
		ld	(ix++11h),c
		ld	(ix++12h),b
		ld	hl,unk_0_813E
		ld	(ix++8),l
		ld	(ix++9),h
		jr	loc_0_81E0
sub_0_81A4:
		dec	(ix++13h)
		ret	p
		ld	a,b
		cp	3
		ld	hl,EEnvelope_gen0
		jr	nc,loc_0_81B1
		inc	hl
loc_0_81B1:
		ld	(loc_0_81FB+1),hl
loc_0_81B4:
		ld	e,(ix++0)
		ld	d,(ix++1)
loc_0_81BA:
		ld	hl,unk_0_8140
loc_0_81BD:
		ld	a,(de)
		inc	hl
		sub	(hl)
		inc	hl
		jr	c,loc_0_81BD
		inc	de
		ld	c,a
		ld	a,(hl)
		ld	(loc_0_81C9+1),a
loc_0_81C9:
		jr	loc_0_81C9
loc_0_81CB:
		ld	(ix++0Eh),c
		ld	c,(ix++0Fh)
		ld	b,(ix++10h)
loc_0_81D4:
		ld	(ix++2),c
		ld	(ix++3),b
		ld	c,(ix++11h)
		ld	b,(ix++12h)
loc_0_81E0:
		ld	(ix++6),c
		ld	(ix++7),b
		ld	(ix++14h),1
		ld	(ix++15h),1
		ld	(ix++16h),1
		jr	loc_0_81BA
loc_0_81F4:
		ld	b,0
		ld	hl,unk_0_8131
		add	hl,bc
		ld	a,(hl)
loc_0_81FB:
		ld	(0),a
		jr	loc_0_81BA
loc_0_8200:
		ld	(ix++17h),c
		jr	loc_0_81BA
loc_0_8205:
		ld	a,c
		inc	a
		ld	(loc_0_8028+1),a
		jr	loc_0_81BA
loc_0_820C:
		ld	(ix++18h),c
		jr	loc_0_81BA
loc_0_8211:
		jr	z,loc_0_8215
		ld	c,3
loc_0_8215:
		ld	hl,(loc_0_81FB+1)
		inc	hl
		inc	hl
		ld	(hl),c
		jr	loc_0_81BA
loc_0_821D:
		ld	bc,unk_0_812C
		jr	loc_0_81D4
loc_0_8222:
		ld	(ix++13h),c
		ld	(ix++0),e
		ld	(ix++1),d
		ret	
loc_0_822C:
		call	sub_0_8461
		jp	loc_0_81B4
loc_0_8232:
		cp	7Fh ; ''
		jr	z,loc_0_823F
		cp	7Eh ; '~'
		jr	z,loc_0_8247
		add	a,2
		ld	c,a
		jr	loc_0_827D
loc_0_823F:
		ld	(ix++4),l
		ld	(ix++5),h
		jr	loc_0_827D
loc_0_8247:
		ld	l,(ix++4)
		ld	h,(ix++5)
		jr	loc_0_827D
loc_0_824F:
		inc	a
		jr	z,loc_0_825A
		inc	a
		jr	z,loc_0_8262
		sub	60h ; '`'
		ld	c,a
		jr	loc_0_829F
loc_0_825A:
		ld	l,(ix++8)
		ld	h,(ix++9)
		jr	loc_0_829F
loc_0_8262:
		ld	(ix++8),l
		ld	(ix++9),h
		jr	loc_0_829F
sub_0_826A:
		ld	e,(ix++0Ah)
		ld	d,(ix++0Bh)
		dec	(ix++15h)
		ld	l,(ix++2)
		ld	h,(ix++3)
		jr	nz,loc_0_828E
		ld	c,1
loc_0_827D:
		ld	a,(hl)
		inc	hl
		rrca	
		jr	nc,loc_0_8232
		ld	(ix++15h),c
		ld	(ix++0Bh),a
		ld	e,(hl)
		ld	d,a
		ld	(ix++0Ah),e
		inc	hl
loc_0_828E:
		push	hl
		ld	a,(ix++0Dh)
		dec	(ix++14h)
		jr	nz,loc_0_82B1
		ld	c,1
		ld	l,(ix++6)
		ld	h,(ix++7)
loc_0_829F:
		ld	a,(hl)
		inc	hl
		cp	60h ; '`'
		jr	nc,loc_0_824F
		ld	(ix++14h),c
		ld	(ix++0Dh),a
		ld	(ix++6),l
		ld	(ix++7),h
loc_0_82B1:
		add	a,(ix++0Eh)
		cp	5Fh ; '_'
		ld	hl,7FFh
		jr	z,loc_0_82D1
loc_0_82BB:
		add	a,0
		jr	nc,loc_0_82C1
		sub	60h ; '`'
loc_0_82C1:
		ld	hl,0FF0Ch
		ld	b,h
loc_0_82C5:
		inc	h
		sub	l
		jr	nc,loc_0_82C5
		ld	c,a
		ld	a,h
		ld	hl,unk_0_812C
		add	hl,bc
		ld	l,(hl)
		ld	h,a
loc_0_82D1:
		add	hl,de
		ld	a,h
		and	7
		ld	h,a
		ld	a,d
		rrca	
		rrca	
		rrca	
		and	0Fh
		ex	af,af'
		ex	de,hl
		pop	hl
		ld	a,(ix++0Ch)
		dec	(ix++16h)
		jr	nz,loc_0_82F4
		ld	a,(hl)
		inc	hl
loc_0_82E9:
		cp	0
		jr	nz,loc_0_8322
		ld	c,(hl)
		inc	hl
loc_0_82EF:
		ld	a,(hl)
		inc	hl
loc_0_82F1:
		ld	(ix++16h),c
loc_0_82F4:
		ld	(ix++2),l
		ld	(ix++3),h
		ld	(ix++0Ch),a
		ex	de,hl
		ld	b,(ix++18h)
		ld	c,a
		and	0Fh
		sub	b
		jr	nc,loc_0_8308
		xor	a
loc_0_8308:
		ld	e,a
		ld	a,c
		and	0F0h ; 'Ё'
		call	sub_0_8157
		sub	b
		jr	nc,loc_0_8313
		xor	a
loc_0_8313:
		ld	d,a
		ld	a,(ix++17h)
		or	a
		ld	a,e
		jr	nz,loc_0_831D
		ld	a,d
		ld	d,e
loc_0_831D:
		call	sub_0_8157
		or	d
		ret	
loc_0_8322:
		push	hl
		ld	b,a
loc_0_8324:
		ld	hl,0
loc_0_8327:
		ld	a,(hl)
		or	a
		jr	z,loc_0_8334
		inc	hl
		ld	c,(hl)
		inc	hl
		cp	b
		jr	nz,loc_0_8327
		pop	hl
		jr	loc_0_82EF
loc_0_8334:
		pop	hl
		ld	c,1
		ld	a,b
		jr	loc_0_82F1
word_0_833A:	
		ds	25
word_0_8353:	
		ds	25
word_0_836C:	
		ds 	25
word_0_8385:	
		ds	25
word_0_839E:	
		ds	25
word_0_83B7:	
		ds	25

EAmplitude_ch0:	db 	0				;+00h - Amplitude 0 right/left
EAmplitude_ch1:	db 	0                               ;+01h - Amplitude 1 right/left
EAmplitude_ch2:	db 	0                               ;+02h - Amplitude 2 right/left
EAmplitude_ch3:	db 	0                               ;+03h - Amplitude 3 right/left
EAmplitude_ch4:	db 	0                               ;+04h - Amplitude 4 right/left
EAmplitude_ch5:	db 	0                               ;+05h - Amplitude 5 right/left
		db    	0                              	;+06h - XXXX
		db    	0                              	;+07h - XXXX
EFrequency_ch0:	db 	0                               ;+08h - Frequency of tone 0
		db	0                               ;+09h - Frequency of tone 1
EFrequency_ch2:	db 	0				;+0Ah - Frequency of tone 2
		db	0                               ;+0Bh - Frequency of tone 3
EFrequency_ch4:	db 	0                               ;+0Ch - Frequency of tone 4
		db	0                               ;+0Dh - Frequency of tone 5
		db    	0                              	;+OEh - XXXX	
		db    	0                              	;+0Fh - XXXX
EOctave_ch0:	db 	0                               ;+10h - Octave 1 and 0
EOctave_ch2:	db 	0                               ;+11h - Octave 3 and 2
		db	0                               ;+12h - Octave 5 and 4
		db    	0                               ;+13h - XXXX
EFrequency_en:	db 	0                               ;+14h - Frequency enable
		db	0                               ;+15h - Noise enable
ENoise_gen:	db 	0                               ;+16h - Noise generator 0 and 1
		db    	0 	                        ;+17h - XXXX
EEnvelope_gen0:	db    	0                               ;+18h - Envelope generator 0 
EEnvelope_gen1:	db    	0                               ;+19h - Envelope generator 1 

word_0_83EA:	dw 	0
	
loc_0_83EC:
		ld	a,6                             ;добавил инициализацию первого канала
		ld	(loc_0_8028+1),a                ;иначе некоректно стратуют некоторые модули

		ld	(loc_0_816E+1),hl		;сохраним адрес музыки
		call	sub_0_8169                      ;получим адрес 1 таблицы
		ld	(sub_0_8461+1),bc               ;сохраним адрес
		call	sub_0_8169                      ;получим адрес 2 таблицы
		ld	(loc_0_8476+1),bc               ;сохраним адрес
		call	sub_0_8169                      ;получим адрес 3 таблицы
		ld	(loc_0_8176+1),bc               ;сохраним адрес
		call	sub_0_8169                      ;получим адрес 4 таблицы
		ld	(loc_0_818D+1),bc               ;сохраним адрес
		call	sub_0_8169                      ;получим адрес 5 таблицы
		ld	a,(bc)
		inc	bc
		ld	(loc_0_82E9+1),a                ;сохраним адрес
		ld	(loc_0_8324+1),bc
		ld	hl,word_0_833A                  ;начальный адрес служебных данных
		ld	b,0B2h                          ;размер области служебных данных
		xor	a                               ;байт заполнения - 00h
loc_0_841D:
		ld	(hl),a                          ;очищаем служебную область
		inc	hl
		djnz	loc_0_841D
		inc	a
		ld	(EPlayer_Play+1),a               ;установим номер текущего канала - 01h
		ld	ix,word_0_833A                 ;адрес служебных данных 1 канала
		ld	de,19h                         ;размер данных для одного канала
		ld	b,6
loc_0_842E:
		ld	(ix++14h),1
		ld	(ix++15h),1
		ld	(ix++16h),1
		ld	hl,unk_0_812C
		ld	(ix++0Fh),l
		ld	(ix++10h),h
		ld	(ix++2),l
		ld	(ix++3),h
		ld	hl,unk_0_813E
		ld	(ix++11h),l
		ld	(ix++12h),h
		add	ix,de  				;переходим к следующему каналу
		djnz	loc_0_842E
		ld	de,1C02h			;регистр 1Сh SAA1099 - выключим звук
		ld	bc,0xfffd
		out	(c),d
		ld b,0xbf
		out	(c),e                          ;иництализация микросхемы
sub_0_8461:
		ld	hl,0				;адрес 1 таблицы
loc_0_8464:
		ld	c,(hl)
		ld	a,c
		inc	hl
		inc	a
		jr	z,loc_0_84A4
		inc	a
		jr	z,loc_0_84A9
		sub	62h ; 'b'
		jr	nc,loc_0_84AE
		ld	(sub_0_8461+1),hl
		sla	c
loc_0_8476:
		ld	hl,0
		call	sub_0_8164
		ld	(word_0_833A),bc
		call	sub_0_8169
		ld	(word_0_8353),bc
		call	sub_0_8169
		ld	(word_0_836C),bc
		call	sub_0_8169
		ld	(word_0_8385),bc
		call	sub_0_8169
		ld	(word_0_839E),bc
		call	sub_0_8169
		ld	(word_0_83B7),bc
		ret	
loc_0_84A4:
		ld	hl,0
		jr	loc_0_8464
loc_0_84A9:
		ld	(loc_0_84A4+1),hl
		jr	loc_0_8464
loc_0_84AE:
		ld	(loc_0_82BB+1),a
		jr	loc_0_8464
;		.end
