/*
asl�nda hepsinin ad�m ad�m buton i�lemini yapm��t�m ama bunlar tek prosed�r �zerinde olaca�� i�in teke indirgemeye �al��t�m
bunu yaparkende durumu bir bir ilerletmeye dikkat ettim
en son a�amada ise sipari� tablosunda teslim al�nd� g�r�ld���nde
stok tablosuna kayd� yap�lm�� olacakt�r. 
*/



CREATE OR REPLACE PROCEDURE siparisi_onayla_ve_stoga_ekle (
    p_siparis_numarasi IN NUMBER
) AS
    v_urun_adi VARCHAR2(255);
    v_miktar NUMBER(10, 2);
    v_olcu_birimi VARCHAR2(10);
BEGIN
/* Sipari�in durumunu kontrol et*/
    DECLARE
        v_durum VARCHAR2(50);
    BEGIN
        SELECT durum INTO v_durum
        FROM SIPARISLER
        WHERE siparis_numarasi = p_siparis_numarasi;
        
        IF v_durum = '1. Onayc�da' THEN
/* Sipari� durumunu 2. onayc�da olarak g�ncelle*/
            UPDATE SIPARISLER
            SET durum = '2. Onayc�da'
            WHERE siparis_numarasi = p_siparis_numarasi;
            DBMS_OUTPUT.PUT_LINE('Sipari� durumu 2. Onayc�da olarak g�ncellendi.');
            
        ELSIF v_durum = '2. Onayc�da' THEN
-- Sipari� durumunu spari� verildi olarak g�ncelle
            UPDATE SIPARISLER
            SET durum = 'Sipari� Verildi'
            WHERE siparis_numarasi = p_siparis_numarasi;
            DBMS_OUTPUT.PUT_LINE('Sipari� durumu Sipari� Verildi olarak g�ncellendi.');
            
        ELSIF v_durum = 'Sipari� Verildi' THEN
-- Sipari� durumunu teslim al�nd� olarak g�ncellee ve stok ekle
            UPDATE SIPARISLER
            SET durum = 'Teslim Al�nd�'
            WHERE siparis_numarasi = p_siparis_numarasi;
            
            SELECT urun_adi, miktar, olcu_birimi
            INTO v_urun_adi, v_miktar, v_olcu_birimi
            FROM SIPARISLER
            WHERE siparis_numarasi = p_siparis_numarasi;
            
-- Stok ekle
            INSERT INTO STOK (urun_adi, miktar, olcu_birimi)
            VALUES (v_urun_adi, v_miktar, v_olcu_birimi);
            DBMS_OUTPUT.PUT_LINE('�r�n sto�a eklendi.');
            
        ELSE
            DBMS_OUTPUT.PUT_LINE('Sipari� durumu uygun de�il.');
        END IF;
    END;
END;
