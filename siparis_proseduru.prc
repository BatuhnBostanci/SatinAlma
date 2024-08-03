/*
aslýnda hepsinin adým adým buton iþlemini yapmýþtým ama bunlar tek prosedür üzerinde olacaðý için teke indirgemeye çalýþtým
bunu yaparkende durumu bir bir ilerletmeye dikkat ettim
en son aþamada ise sipariþ tablosunda teslim alýndý görüldüðünde
stok tablosuna kaydý yapýlmýþ olacaktýr. 
*/



CREATE OR REPLACE PROCEDURE siparisi_onayla_ve_stoga_ekle (
    p_siparis_numarasi IN NUMBER
) AS
    v_urun_adi VARCHAR2(255);
    v_miktar NUMBER(10, 2);
    v_olcu_birimi VARCHAR2(10);
BEGIN
/* Sipariþin durumunu kontrol et*/
    DECLARE
        v_durum VARCHAR2(50);
    BEGIN
        SELECT durum INTO v_durum
        FROM SIPARISLER
        WHERE siparis_numarasi = p_siparis_numarasi;
        
        IF v_durum = '1. Onaycýda' THEN
/* Sipariþ durumunu 2. onaycýda olarak güncelle*/
            UPDATE SIPARISLER
            SET durum = '2. Onaycýda'
            WHERE siparis_numarasi = p_siparis_numarasi;
            DBMS_OUTPUT.PUT_LINE('Sipariþ durumu 2. Onaycýda olarak güncellendi.');
            
        ELSIF v_durum = '2. Onaycýda' THEN
-- Sipariþ durumunu spariþ verildi olarak güncelle
            UPDATE SIPARISLER
            SET durum = 'Sipariþ Verildi'
            WHERE siparis_numarasi = p_siparis_numarasi;
            DBMS_OUTPUT.PUT_LINE('Sipariþ durumu Sipariþ Verildi olarak güncellendi.');
            
        ELSIF v_durum = 'Sipariþ Verildi' THEN
-- Sipariþ durumunu teslim alýndý olarak güncellee ve stok ekle
            UPDATE SIPARISLER
            SET durum = 'Teslim Alýndý'
            WHERE siparis_numarasi = p_siparis_numarasi;
            
            SELECT urun_adi, miktar, olcu_birimi
            INTO v_urun_adi, v_miktar, v_olcu_birimi
            FROM SIPARISLER
            WHERE siparis_numarasi = p_siparis_numarasi;
            
-- Stok ekle
            INSERT INTO STOK (urun_adi, miktar, olcu_birimi)
            VALUES (v_urun_adi, v_miktar, v_olcu_birimi);
            DBMS_OUTPUT.PUT_LINE('Ürün stoða eklendi.');
            
        ELSE
            DBMS_OUTPUT.PUT_LINE('Sipariþ durumu uygun deðil.');
        END IF;
    END;
END;
