;-----------------------------------------------------------
;ʵ��һ ����2
;���ܣ����Ʋ�ͬ��ɫ��LEDģ�⽻ͨ�źŵ�
;74LS273����8����������ܣ���ַΪ88H or 8AH or 8CH or 8EH
;Designer��MasterofDarkArts
;-----------------------------------------------------------
.MODEL SMALL; �趨8086������ʹ��Small model
.8086 ; �趨����8086���ָ�
;-----------------------------------------------------------
;	���Ŷ���                                               |
;-----------------------------------------------------------
PortOut	EQU 88h	;��������˿ں�
INITIALSTATE EQU 0F6h ;�ƹ��ʼ��, �ϱ���, ������
STATE_1 EQU 0F3h; �ϱ���, ������
STATE_2 EQU 0F7h; �ϱ�����, ������
STATE_3 EQU 0F5h; �ϱ���, ������
STATE_4 EQU 0DEh; �ϱ���, ������
STATE_5 EQU 0FEh; �ϱ���, ��������
STATE_6 EQU 0EEh; �ϱ���, ������
ITERATION_BLINK EQU 6000h; ����˸���
;-----------------------------------------------------------
;	�����ջ��                                             |
;-----------------------------------------------------------
.stack 100h; ����256�ֽ������Ķ�ջ

;-----------------------------------------------------------
;	�������ݶ�                                             |
;-----------------------------------------------------------
.data; �������ݶ�
;MyVar	DB	?					; ����MyVar����   
;-----------------------------------------------------------
;	��������                                             |
;-----------------------------------------------------------
.code; Code segment definition
.startup; ���������ִ����ڵ�
;
;���¿�ʼ�����û�ָ�����
;
;-----------------------------------------------------------
;�����򲿷�, ģ�⽻ͨ�źŵ�                    |
;-----------------------------------------------------------
    MOV AL, INITIALSTATE; �ƹ��ʼ��
    OUT PortOut, AL; ����ʾ
    MOV CX, 0; ѭ���������
Stage1:
    LOOP Stage1
    MOV AL, STATE_1
    OUT PortOut, AL
Stage2:
    LOOP Stage2
    MOV AL, STATE_2
    OUT PortOut, AL
    MOV CX, ITERATION_BLINK
Stage3:
    LOOP Stage3
    MOV AL, STATE_1
    OUT PortOut, AL
    MOV CX, ITERATION_BLINK
Stage4:
    LOOP Stage4
    MOV AL, STATE_2
    OUT PortOut, AL
    MOV CX, ITERATION_BLINK
Stage5:
    LOOP Stage5
    MOV AL, STATE_3
    OUT PortOut, AL
Stage6:
    LOOP Stage6
    MOV AL, STATE_4
    OUT PortOut, AL
Stage7:
    LOOP Stage7
    MOV AL, STATE_5
    OUT PortOut, AL
    MOV CX, ITERATION_BLINK
Stage8:
    LOOP Stage8
    MOV AL, STATE_4
    OUT PortOut, AL
    MOV CX, ITERATION_BLINK
Stage9:
    LOOP Stage9
    MOV AL, STATE_5
    OUT PortOut, AL
    MOV CX, ITERATION_BLINK
Stage10:
    LOOP Stage10
    MOV AL, STATE_6
    OUT PortOut, AL
    JMP Stage1
    END; ָʾ�������������