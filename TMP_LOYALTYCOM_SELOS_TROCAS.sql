--Troca de selo
CREATE OR REPLACE VIEW LOYALTYCOM.TMP_LOYALTYCOM_SELOS_TROCAS AS

SELECT A.NROEMPRESA,
       A.NROCHECKOUT,
       A.SEQDOCTO,
       A.SEQITEM,
       A.QUANTIDADE,
       A.QTDSELO,
       A.PRECO,
       B.SEQPRODUTO,
       C.DTAMOVIMENTO,
       D.NRONOTAFISCAL,
       REPLACE(RAWTOHEX(DBMS_OBFUSCATION_TOOLKIT.MD5(INPUT => UTL_RAW.CAST_TO_RAW(NVL(LPAD(E.CNPJCPF,11,0),0)))),
                        'CFCD208495D565EF66E7DFF9F98764DA',
                       '') CPF_CODIFICADO
       
  FROM MONITORPDV.TB_DOCTOSELOTROCA@LINK_C5 A 
                           INNER JOIN MONITORPDV.TB_DOCTOITEM@LINK_C5 B   ON A.NROEMPRESA = B.NROEMPRESA AND A.NROCHECKOUT = B.NROCHECKOUT AND A.SEQDOCTO = B.SEQDOCTO
                           INNER JOIN MONITORPDV.TB_DOCTO@LINK_C5 C       ON A.NROEMPRESA = C.NROEMPRESA AND A.NROCHECKOUT = C.NROCHECKOUT AND A.SEQDOCTO = C.SEQDOCTO
                           INNER JOIN MONITORPDV.TB_DOCTOCUPOM@LINK_C5 D  ON A.NROEMPRESA = D.NROEMPRESA AND A.NROCHECKOUT = D.NROCHECKOUT AND A.SEQDOCTO = D.SEQDOCTO
                           INNER JOIN MONITORPDV.TB_DOCTOPESSOA@LINK_C5 E ON A.NROEMPRESA = E.NROEMPRESA AND A.NROCHECKOUT = E.NROCHECKOUT AND A.SEQDOCTO = E.SEQDOCTO
 WHERE B.STATUS = 'V'
   AND C.ESPECIE = 'CF'
   AND D.CGO = 76
   AND E.SEQDESTINO = 700
   
 GROUP BY A.NROEMPRESA,
          A.NROCHECKOUT,
          A.SEQDOCTO,
          A.SEQITEM,
          A.QUANTIDADE,
          A.QTDSELO,
          A.PRECO,
          B.SEQPRODUTO,
          C.DTAMOVIMENTO,
          D.NRONOTAFISCAL,
          E.CNPJCPF
 ORDER BY 9, 1, 2, 3, 4;
