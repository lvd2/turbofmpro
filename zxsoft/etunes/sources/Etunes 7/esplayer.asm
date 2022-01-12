;--------------------------------------------------------------------
; Описание: Проигрывающий модуль от группы ESI
; портирован  с компьютера Sam Coupe
; Автор порта: Тарасов М.Н.(Mick),2010
;--------------------------------------------------------------------
;-------------------------------------------------------------------
; описание: Инициализация проигрывателя
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
ESIPlayer_Init:
		ld	hl,0
		ld	(loc_0_800D+1),	hl
ESIPlayer_InitS:
		ld	hl,0
		ld	(loc_0_8128+1),	hl
		ld	(loc_0_8184+1),	hl
		ld	(loc_0_81E3+1),	hl
		ld	(loc_0_823D+1),	hl
		ld	(loc_0_829A+1),	hl
		ld	(loc_0_82F4+1),	hl
		ld	(ESIPlayer_loc0+1),hl
		ld	(ESIPlayer_loc1+1),hl
		ld	(ESIPlayer_loc2+1),hl
		ld	(ESIPlayer_loc3+1),hl
		ld	(ESIPlayer_loc4+1),hl
		ld	(ESIPlayer_loc5+1),hl
		ld	hl,ESIPlayer_Play + 1
		ld	(hl),1
		ld	(loc_0_8006+1),	hl
		; ld	bc, 1FFh
		; ld	(hl), b
		ld	bc,0xfffd
		ld	de, 1C02h
		jp outdesaa
		
;-------------------------------------------------------------------
; описание: Проигрывание текущей ноты
; параметры: нет
; возвращаемое  значение: нет
;---------------------------------------------------------------------
ESIPlayer_Play:
		ld	a,1
		dec	a
		jp	nz, loc_0_8123

loc_0_8006:
		ld	hl,0
		ld	a, (hl)
		rrca	
		jr	nc, loc_0_8022
loc_0_800D:
		ld	hl,0
		ld	e, (hl)
		inc	l
		ld	d, (hl)
		ld	(loc_0_800D+1),	de
		inc	l
		ld	a, (hl)
		ld	(loc_0_8126+1),	a
		inc	l
		ld	e, (hl)
		inc	l
		ld	d, (hl)
		ex	de, hl
		ld	a, (hl)
loc_0_8022:
		ld	c, a
		inc	hl
		ld	a, (hl)
		ld	(loc_0_851E+1),	a
		and	40h
		ld	a, 3
		jr	nz, loc_0_802F
		xor	a
loc_0_802F:
		ld	(loc_0_8517+1),	a
		inc	hl
		ld	a, (hl)
		ld	(loc_0_8527+1),	a
		and	40h
		ld	a, 30h
		jr	nz, loc_0_803E
		xor	a
loc_0_803E:
		ld	(loc_0_8519+1),	a
		inc	hl
		rrc	c
		jr	nc, loc_0_8067
		ld	a, (hl)
		ld	(loc_0_8150+1),	a
		inc	hl
		ld	e, (hl)
		inc	hl
		ex	de, hl
		ld	a, c
ESIPlayer_loc0:
		ld	bc,0
		ld	h, c
		add	hl, hl
		add	hl, hl
		add	hl, bc
		ld	c, (hl)
		inc	l
		ld	b, (hl)
		inc	l
		ld	(loc_0_8128+1),	bc
		ld	c, (hl)
		inc	l
		ld	b, (hl)
		ld	(loc_0_813F+1),	bc
		ld	c, a
		ex	de, hl
loc_0_8067:
		rrc	c
		jr	nc, loc_0_808C
		ld	a, (hl)
		ld	(loc_0_81AC+1),	a
		inc	hl
		ld	e, (hl)
		inc	hl
		ex	de, hl
		ld	a, c
ESIPlayer_loc1:
		ld	bc,0
		ld	h, c
		add	hl, hl
		add	hl, hl
		add	hl, bc
		ld	c, (hl)
		inc	l
		ld	b, (hl)
		inc	l
		ld	(loc_0_8184+1),	bc
		ld	c, (hl)
		inc	l
		ld	b, (hl)
		ld	(loc_0_819B+1),	bc
		ld	c, a
		ex	de, hl
loc_0_808C:
		rrc	c
		jr	nc, loc_0_80B1
		ld	a, (hl)
		ld	(loc_0_820B+1),	a
		inc	hl
		ld	e, (hl)
		inc	hl
		ex	de, hl
		ld	a, c
ESIPlayer_loc2:
		ld	bc,0
		ld	h,c
		add	hl,hl
		add	hl,hl
		add	hl,bc
		ld	c,(hl)
		inc	l
		ld	b, (hl)
		inc	l
		ld	(loc_0_81E3+1),	bc
		ld	c, (hl)
		inc	l
		ld	b, (hl)
		ld	(loc_0_81FA+1),	bc
		ld	c, a
		ex	de, hl
loc_0_80B1:
		rrc	c
		jr	nc, loc_0_80D6
		ld	a, (hl)
		ld	(loc_0_8265+1),	a
		inc	hl
		ld	e, (hl)
		inc	hl
		ex	de, hl
		ld	a, c
ESIPlayer_loc3:
		ld	bc,0
		ld	h, c
		add	hl, hl
		add	hl, hl
		add	hl, bc
		ld	c, (hl)
		inc	l
		ld	b, (hl)
		inc	l
		ld	(loc_0_823D+1),	bc
		ld	c, (hl)
		inc	l
		ld	b, (hl)
		ld	(loc_0_8254+1),	bc
		ld	c, a
		ex	de, hl
loc_0_80D6:
		rrc	c
		jr	nc, loc_0_80FB
		ld	a, (hl)
		ld	(loc_0_82C2+1),	a
		inc	hl
		ld	e, (hl)
		inc	hl
		ex	de, hl
		ld	a, c
ESIPlayer_loc4:
		ld	bc,0
		ld	h, c
		add	hl, hl
		add	hl, hl
		add	hl, bc
		ld	c, (hl)
		inc	l
		ld	b, (hl)
		inc	l
		ld	(loc_0_829A+1),	bc
		ld	c, (hl)
		inc	l
		ld	b, (hl)
		ld	(loc_0_82B1+1),	bc
		ld	c, a
		ex	de, hl
loc_0_80FB:
		rrc	c
		jr	nc, loc_0_811E
		ld	a, (hl)
		ld	(loc_0_831C+1),	a
		inc	hl
		ld	e, (hl)
		inc	hl
		ex	de, hl
ESIPlayer_loc5:
		ld	bc,0
		ld	h, c
		add	hl, hl
		add	hl, hl
		add	hl, bc
		ld	c, (hl)
		inc	l
		ld	b, (hl)
		inc	l
		ld	(loc_0_82F4+1),bc
		ld	c, (hl)
		inc	l
		ld	b, (hl)
		ld	(loc_0_830B+1),bc
		ex	de, hl
loc_0_811E:
		ld	a, (hl)
		inc	hl
		ld	(loc_0_8006+1),hl
loc_0_8123:
		ld	(ESIPlayer_Play+1),a
loc_0_8126:
		ld	c,0
loc_0_8128:
		ld	hl,0
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		bit	7,d
		jr	z,loc_0_8136
		ex	de,hl
		ld	e, (hl)
		inc	hl
		ld	d, (hl)
loc_0_8136:
		inc	hl
		ld	a, (hl)
		inc	hl
		ld	(loc_0_8356+1),	a
		ld	(ESIAmplitude_ch0),a
		ld	(loc_0_8128+1),	hl
loc_0_813F:
		ld	hl, 0
		ld	a, (hl)
		cp	80h ; 'А'
		jr	c, loc_0_814B
		inc	hl
		ld	l, (hl)
		ld	h, a
		ld	a, (hl)
loc_0_814B:
		inc	hl
		ld	(loc_0_813F+1),	hl
		add	a, c
loc_0_8150:
		add	a, 0
		add	a, a
		jr	nc, loc_0_8157
		sub	0C0h ; '└'
loc_0_8157:
		push	de
		ld	d,0
		ld	e,a
		ld	hl,ESIPlayer_table
		add	hl,de
		pop	de		

		ld	a,(hl)
		inc	l
		ld	h,(hl)
		ld	l,a
		add	hl,de
		ld	a,l
		ld	(loc_0_838C+1),	a
		ld	(ESIFrequency_ch0),a
		ld	a,h
		and	7
		ld	(loc_0_83C7+1),	a
		ld	a, d
		and	8
		rrca	
		rrca	
		rrca	
		ld	(loc_0_83E9+1),	a
		xor	a
		bit	4, d
		jr	z, loc_0_8181
		ld	a, d
		and	3
		rlca	
		rlca	
		ld	(loc_0_8513+1),	a
		ld	a, 1
loc_0_8181:
		ld	(loc_0_8500+1),	a
loc_0_8184:
		ld	hl, 0
		ld	e, (hl)
		inc	hl
		ld	d, (hl)
		bit	7, d
		jr	z, loc_0_8192
		ex	de, hl
		ld	e, (hl)
		inc	hl
		ld	d, (hl)
loc_0_8192:
		inc	hl
		ld	a, (hl)
		inc	hl
		ld	(loc_0_835F+1),	a
		ld	(ESIAmplitude_ch1),a
		ld	(loc_0_8184+1),	hl
loc_0_819B:
		ld	hl, 0
		ld	a, (hl)
		cp	80h
		jr	c, loc_0_81A7
		inc	hl
		ld	l, (hl)
		ld	h, a
		ld	a, (hl)
loc_0_81A7:
		inc	hl
		ld	(loc_0_819B+1),	hl
		add	a, c
loc_0_81AC:
		add	a, 0
		add	a, a
		jr	nc, loc_0_81B3
		sub	0C0h 
loc_0_81B3:
		push	de
		ld	d,0
		ld	e,a
		ld	hl,ESIPlayer_table
		add	hl,de
		pop	de		

		ld	a, (hl)
		inc	l
		ld	h, (hl)
		ld	l, a
		add	hl, de
		ld	a, l
		ld	(loc_0_8395+1),	a
		ld	(ESIFrequency_ch1),a
		ld	a, h
		and	7
		add	a, a
		add	a, a
		add	a, a
		add	a, a
		ld	(loc_0_83C9+1),	a
		ld	a, d
		and	8
		rrca	
		rrca	
		ld	(loc_0_83EB+1),	a
		xor	a
		bit	4, d
		jr	z, loc_0_81E0
		ld	a, d
		and	60h ; '`'
		rlca	
		rlca	
		ld	(loc_0_8513+1),	a
		ld	a, 2
loc_0_81E0:
		ld	(loc_0_8502+1),	a
loc_0_81E3:
		ld	hl,0
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		bit	7,d
		jr	z,loc_0_81F1
		ex	de,hl
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
loc_0_81F1:
		inc	hl
		ld	a,(hl)
		inc	hl
		ld	(loc_0_8368+1),	a
		ld	(ESIAmplitude_ch2),a
		ld	(loc_0_81E3+1),	hl
loc_0_81FA:
		ld	hl,0
		ld	a, (hl)
		cp	80h
		jr	c,loc_0_8206
		inc	hl
		ld	l,(hl)
		ld	h,a
		ld	a,(hl)
loc_0_8206:
		inc	hl
		ld	(loc_0_81FA+1),	hl
		add	a,c
loc_0_820B:
		add	a,0
		add	a,a
		jr	nc,loc_0_8212
		sub	0C0h
loc_0_8212:
		push	de
		ld	d,0
		ld	e,a
		ld	hl,ESIPlayer_table
		add	hl,de
		pop	de		

		ld	a,(hl)
		inc	l 
		ld	h,(hl)
		ld	l,a
		add	hl,de
		ld	a,l
		ld	(loc_0_839E+1),a
		ld	(ESIFrequency_ch2),a
		ld	a,h
		and	7
		ld	(loc_0_83D2+1),	a
		ld	a, d
		and	8
		rrca	
		ld	(loc_0_83ED+1),	a
		xor	a
		bit	4, d
		jr	z, loc_0_823A
		ld	a, d
		and	60h ; '`'
		rlca	
		rlca	
		ld	(loc_0_8513+1),	a
		ld	a, 4
loc_0_823A:
		ld	(loc_0_8504+1),	a
loc_0_823D:
		ld	hl,0
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		bit	7,d
		jr	z,loc_0_824B
		ex	de,hl
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
loc_0_824B:
		inc	hl
		ld	a,(hl)
		inc	hl
		ld	(loc_0_8371+1),a
		ld	(ESIAmplitude_ch3),a
		ld	(loc_0_823D+1),hl
loc_0_8254:
		ld	hl,0
		ld	a, (hl)
		cp	80h
		jr	c, loc_0_8260
		inc	hl
		ld	l, (hl)
		ld	h, a
		ld	a, (hl)
loc_0_8260:
		inc	hl
		ld	(loc_0_8254+1),	hl
		add	a, c
loc_0_8265:
		add	a, 0
		add	a, a
		jr	nc, loc_0_826C
		sub	0C0h
loc_0_826C:
		push	de
		ld	d,0
		ld	e,a
		ld	hl,ESIPlayer_table
		add	hl,de
		pop	de		

		ld	a,(hl)
		inc	l
		ld	h,(hl)
		ld	l,a
		add	hl,de
		ld	a,l
		ld	(loc_0_83A7+1),	a
		ld	(ESIFrequency_ch3),a
		ld	a,h
		and	7
		add	a,a
		add	a,a
		add	a,a
		add	a,a
		ld	(loc_0_83D4+1),	a
		ld	a,d
		and	8
		ld	(loc_0_83EF+1),	a
		xor	a 
		bit	4,d
		jr	z,loc_0_8297
		ld	a,d
		and	60h
		rrca	
		rrca	
		ld	(loc_0_8515+1),	a
		ld	a, 8
loc_0_8297:
		ld	(loc_0_8506+1),	a
loc_0_829A:
		ld	hl,0
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		bit	7,d
		jr	z,loc_0_82A8
		ex	de,hl
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
loc_0_82A8:
		inc	hl
		ld	a, (hl)
		inc	hl
		ld	(loc_0_837A+1),	a
		ld	(ESIAmplitude_ch4),a
		ld	(loc_0_829A+1),	hl
loc_0_82B1:
		ld	hl,0
		ld	a,(hl)
		cp	80h
		jr	c,loc_0_82BD
		inc	hl
		ld	l,(hl)
		ld	h,a
		ld	a,(hl)
loc_0_82BD:
		inc	hl
		ld	(loc_0_82B1+1),	hl
		add	a,c
loc_0_82C2:
		add	a,0
		add	a,a
		jr	nc,loc_0_82C9
		sub	0C0h ; '└'
loc_0_82C9:
		push	de
		ld	d,0
		ld	e,a
		ld	hl,ESIPlayer_table
		add	hl,de
		pop	de		

		ld	a,(hl)
		inc	l
		ld	h,(hl)
		ld	l,a
		add	hl,de
		ld	a,l
		ld	(loc_0_83B0+1),a
		ld	(ESIFrequency_ch4),a
		ld	a,h
		and	7
		ld	(loc_0_83DD+1),a
		ld	a,d
		and	8
		rlca	
		ld	(loc_0_83F1+1),	a
		xor	a
		bit	4,d
		jr	z,loc_0_82F1
		ld	a,d
		and	60h
		rrca	
		rrca	
		ld	(loc_0_8515+1),	a
		ld	a, 10h
loc_0_82F1:
		ld	(loc_0_8508+1),	a
loc_0_82F4:
		ld	hl,0
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		bit	7,d
		jr	z,loc_0_8302
		ex	de,hl
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
loc_0_8302:
		inc	hl
		ld	a,(hl)
		inc	hl
		ld	(loc_0_8383+1),a
		ld	(ESIAmplitude_ch5),a
		ld	(loc_0_82F4+1),hl
loc_0_830B:
		ld	hl,0
		ld	a, (hl)
		cp	80h
		jr	c, loc_0_8317
		inc	hl
		ld	l, (hl)
		ld	h, a
		ld	a, (hl)
loc_0_8317:
		inc	hl
		ld	(loc_0_830B+1),	hl
		add	a, c
loc_0_831C:
		add	a,0
		add	a,a
		jr	nc,loc_0_8323
		sub	0C0h
loc_0_8323:
		push	de
		ld	d,0
		ld	e,a
		ld	hl,ESIPlayer_table
		add	hl,de
		pop	de		

		ld	a,(hl)
		inc	l
		ld	h,(hl)
		ld	l,a
		add	hl,de
		ld	a,l
		ld	(loc_0_83B9+1),	a
		ld	(ESIFrequency_ch5),a
		ld	a,h
		and	7
		add	a,a
		add	a,a
		add	a,a
		add	a,a
		ld	(loc_0_83DF+1),	a
		ld	a,d
		and	8
		rlca	
		rlca	
		ld	(loc_0_83F3+1),	a
		xor	a
		bit	4,d
		jr	z,loc_0_8350
		ld	a,d
		and	60h
		rrca	
		rrca	
		ld	(loc_0_8515+1),	a
		ld	a,20h ; ' '
loc_0_8350:
		ld	(loc_0_850A+1),	a
		ld	bc,0xfffd
loc_0_8356:
		ld	de,0
		call outdesaa
loc_0_835F:
		ld	de,100h
		call outdesaa
loc_0_8368:
		ld	de,200h
		call outdesaa
loc_0_8371:
		ld	de,300h
		call outdesaa
loc_0_837A:
		ld	de,400h
		call outdesaa
loc_0_8383:
		ld	de,500h
		call outdesaa
loc_0_838C:
		ld	de,800h
		call outdesaa
loc_0_8395:
		ld	de,900h
		call outdesaa
loc_0_839E:
		ld	de,0A00h
		call outdesaa
loc_0_83A7:
		ld	de,0B00h
		call outdesaa
loc_0_83B0:
		ld	de,0C00h
		call outdesaa
loc_0_83B9:
		ld	de,0D00h
		call outdesaa
		ld	d,10h
		out	(c),d
		ld b,0xbf
loc_0_83C7:
		ld	a,0
loc_0_83C9:
		or	0
		ld	(ESIOctave_ch0),a
		out	(c),a
		ld b,0xff
		inc	d
		out	(c),d
		ld b,0xbf
loc_0_83D2:
		ld	a,0
loc_0_83D4:
		or	0
		ld	(ESIOctave_ch2),a
		out	(c),a
		ld b,0xff
		inc	d
		out	(c),d
		ld b,0xbf
loc_0_83DD:
		ld	a,0
loc_0_83DF:
		or	0
		ld	(ESIOctave_ch4),a
		out	(c),a
		ld b,0xff
		ld	d, 14h
		out	(c),d
		ld b,0xbf
loc_0_83E9:
		ld	a,0
loc_0_83EB:
		or	0
loc_0_83ED:
		or	0
loc_0_83EF:
		or	0
loc_0_83F1:
		or	0
loc_0_83F3:
		or	0
		out	(c),a
		ld b,0xff
		inc	d
		out	(c),d
		ld b,0xbf
		jp	loc_0_8500

ESIPlayer_table:
		dw 	21h
		dw 	3Ch
		dw 	55h
		dw 	6Dh
		dw 	84h
		dw 	99h
		dw 	0ADh
		dw 	0C0h
		dw 	0D2h
		dw 	0E3h
		dw 	0F3h
		dw 	105h
		dw 	121h
		dw 	13Ch
		dw 	155h
		dw 	16Dh
		dw 	184h
		dw 	199h
		dw 	1ADh
		dw 	1C0h
		dw 	1D2h
		dw 	1E3h
		dw 	1F3h
		dw 	205h
		dw 	221h
		dw 	23Ch
		dw 	255h
		dw 	26Dh
		dw 	284h
		dw 	299h
		dw 	2ADh
		dw 	2C0h
		dw 	2D2h
		dw 	2E3h
		dw 	2F3h
		dw 	305h
		dw 	321h
		dw 	33Ch
		dw 	355h
		dw 	36Dh
		dw 	384h
		dw 	399h
		dw 	3ADh
		dw 	3C0h
		dw 	3D2h
		dw 	3E3h
		dw 	3F3h
		dw 	405h
		dw 	421h
		dw 	43Ch
		dw 	455h
		dw 	46Dh
		dw 	484h
		dw 	499h
		dw 	4ADh
		dw 	4C0h
		dw 	4D2h
		dw 	4E3h
		dw 	4F3h
		dw 	505h
		dw 	521h
		dw 	53Ch
		dw 	555h
		dw 	56Dh
		dw 	584h
		dw 	599h
		dw 	5ADh
		dw 	5C0h
		dw 	5D2h
		dw 	5E3h
		dw 	5F3h
		dw 	605h
		dw 	621h
		dw 	63Ch
		dw 	655h
		dw 	66Dh
		dw 	684h
		dw 	699h
		dw 	6ADh
		dw 	6C0h
		dw 	6D2h
		dw 	6E3h
		dw 	6F3h
		dw 	705h
		dw 	721h
		dw 	73Ch
		dw 	755h
		dw 	76Dh
		dw 	784h
		dw 	799h
		dw 	7ADh
		dw 	7C0h
		dw 	7D2h
		dw 	7E3h
		dw 	7F3h
		dw 	7FFh

loc_0_8500:
		ld	a, 0
loc_0_8502:
		or	0
loc_0_8504:
		or	0
loc_0_8506:
		or	0
loc_0_8508:
		or	0
loc_0_850A:
		or	0
		ld	(ESINoise_enable),a
		out	(c), a
		ld b,0xff
		inc	d
		out	(c), d
		ld b,0xbf
loc_0_8513:
		ld	a, 0
loc_0_8515:
		or	0
loc_0_8517:
		or	0
loc_0_8519:
		or	0
		out	(c), a
		ld b,0xff
loc_0_851E:
		ld	de, 1800h
		call outdesaa
loc_0_8527:
		ld	de, 1900h
		call outdesaa
		ld	de, 1C01h
outdesaa:
		out	(c), d
		ld b,0xbf
		out	(c), e
		ld b,0xff
		ret
ESIAmplitude_ch0:
		db 	0				;+00h - Amplitude 0 right/left
ESIAmplitude_ch1:
		db 	0                               ;+01h - Amplitude 1 right/left
ESIAmplitude_ch2:
		db 	0                               ;+02h - Amplitude 2 right/left
ESIAmplitude_ch3:
		db 	0                               ;+03h - Amplitude 3 right/left
ESIAmplitude_ch4:
		db 	0                               ;+04h - Amplitude 4 right/left
ESIAmplitude_ch5:
		db 	0                               ;+05h - Amplitude 5 right/left
ESINoise_enable:
		db	0
ESIFrequency_ch0:
		db 	0                               ;+08h - Frequency of tone 0
ESIFrequency_ch1:
		db	0                               ;+09h - Frequency of tone 1
ESIFrequency_ch2:
		db 	0				;+0Ah - Frequency of tone 2
ESIFrequency_ch3:
		db	0                               ;+0Bh - Frequency of tone 3
ESIFrequency_ch4:
		db 	0                               ;+0Ch - Frequency of tone 4
ESIFrequency_ch5:
		db	0                               ;+0Dh - Frequency of tone 5
ESIOctave_ch0:
		db 	0                               ;+10h - Octave 1 and 0
ESIOctave_ch2:
		db 	0                               ;+11h - Octave 3 and 2
ESIOctave_ch4:
		db	0                               ;+12h - Octave 5 and 4
