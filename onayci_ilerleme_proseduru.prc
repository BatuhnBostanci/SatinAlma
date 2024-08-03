/*1. onaycý -> 2. onaycý -> sipariþ verildi içeren prosedür*/

CREATE OR REPLACE PROCEDURE siparisi_durumunu_guncelle (
    p_siparis_numarasi IN NUMBER
) AS
    v_durum VARCHAR2(50);
BEGIN
    -- spariþin  durumunu kontrol et
    SELECT durum INTO v_durum
    FROM siparisler
    WHERE siparis_numarasi = p_siparis_numarasi;

    IF v_durum = '1. Onaycýda' THEN
        UPDATE siparisler
        SET durum = '2. Onaycýda'
        WHERE siparis_numarasi = p_siparis_numarasi;
        DBMS_OUTPUT.PUT_LINE('Sipariþ durumu 2. Onaycýda olarak güncellendi.');
        
    ELSIF v_durum = '2. Onaycýda' THEN
        UPDATE siparisler
        SET durum = 'Sipariþ Verildi'
        WHERE siparis_numarasi = p_siparis_numarasi;
        DBMS_OUTPUT.PUT_LINE('Sipariþ durumu Sipariþ Verildi olarak güncellendi.');
        
    ELSE
        DBMS_OUTPUT.PUT_LINE('Sipariþ durumu uygun deðil.');
    END IF;
    
    COMMIT; -- Ýþlemleri veritabanýna kaydet(gpt önerisi)
EXCEPTION
    WHEN OTHERS THEN
        -- Hata durumunda rollback yap (gpt önerisi)
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Bir hata oluþtu: ' || SQLERRM);
END;
/

