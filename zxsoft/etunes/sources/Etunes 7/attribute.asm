;--------------------------------------------------------------------
; ���ᠭ��: ����� �⮡ࠦ���� ���������
; ���� ����: ���ᮢ �.�.(Mick),2010
;--------------------------------------------------------------------

;-------------------------------------------------------------------
; ���ᠭ��: ����騥 ��ਡ���
; ��ࠬ����: ���
; �����頥���  ���祭��: ���
;---------------------------------------------------------------------
Attribute_update:
		ld	a,(Attribute_pause)
		and	a
		jr	z,Attribute_line_1
		inc	a
		ld	(Attribute_pause),a
		and	07h
		ret	nz
		xor	a
		ld	(Attribute_pause),a
		ret

Attribute_line_1:
		inc	a
		ld	(Attribute_pause),a
		ld	hl,5A32h
		ld	de,5A33h
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		ldd
		inc	hl
		ex	hl,de
		ld	hl,(Attribute_work)
		ld	a,(hl)
		and	a
		jr	nz,Attribute_line_2
                ld	hl,Attribute_table
		ld	a,(hl)
Attribute_line_2:
		inc	hl
		ld	(Attribute_work),hl
		ex	hl,de
		ld	(hl),a
		ld	a,(Attribute_phase)
		inc	a
		ld	(Attribute_phase),a
                cp	20
		ret	c
		xor	a
		ld	(Attribute_phase),a
		ld	(Attribute_pause),a
		ret
;-------------------------------------------------------------------
; ���ᠭ��: ���������� ��ࠬ��஢ ���������
; ��ࠬ����: ���
; �����頥���  ���祭��: ���
;---------------------------------------------------------------------
Attribute_init:
		xor	a
		ld	(Attribute_phase),a
		ld	(Attribute_pause),a
                ld	hl,Attribute_table
		ld	(Attribute_work),hl
		ret
;-------------------------------------------------------------------
; ���ᠭ��:  ��६���� �ࠢ��� � ������ ������� ���������
;---------------------------------------------------------------------
Attribute_table:
		db	42h,46h,44h,45h,41h,43h,0
;-------------------------------------------------------------------
; ���ᠭ��:  ��६���� �ࠢ��� � ������ ������� ���������
;---------------------------------------------------------------------
Attribute_phase:
		db	0	
Attribute_pause:
		db	0	
Attribute_work:
		dw	0	
;		.end