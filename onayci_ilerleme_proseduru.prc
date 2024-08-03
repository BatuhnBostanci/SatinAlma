/*1. onayc� -> 2. onayc� -> sipari� verildi i�eren prosed�r*/

CREATE OR REPLACE PROCEDURE siparisi_durumunu_guncelle (
    p_siparis_numarasi IN NUMBER
) AS
    v_durum VARCHAR2(50);
BEGIN
    -- spari�in  durumunu kontrol et
    SELECT durum INTO v_durum
    FROM siparisler
    WHERE siparis_numarasi = p_siparis_numarasi;

    IF v_durum = '1. Onayc�da' THEN
        UPDATE siparisler
        SET durum = '2. Onayc�da'
        WHERE siparis_numarasi = p_siparis_numarasi;
        DBMS_OUTPUT.PUT_LINE('Sipari� durumu 2. Onayc�da olarak g�ncellendi.');
        
    ELSIF v_durum = '2. Onayc�da' THEN
        UPDATE siparisler
        SET durum = 'Sipari� Verildi'
        WHERE siparis_numarasi = p_siparis_numarasi;
        DBMS_OUTPUT.PUT_LINE('Sipari� durumu Sipari� Verildi olarak g�ncellendi.');
        
    ELSE
        DBMS_OUTPUT.PUT_LINE('Sipari� durumu uygun de�il.');
    END IF;
    
    COMMIT; -- ��lemleri veritaban�na kaydet(gpt �nerisi)
EXCEPTION
    WHEN OTHERS THEN
        -- Hata durumunda rollback yap (gpt �nerisi)
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Bir hata olu�tu: ' || SQLERRM);
END;
/

