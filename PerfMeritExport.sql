/* Formatted on 2017/12/28 下午 04:16:16 (QP5 v5.252.13127.32847) */
SELECT ROWNUM AS 序號,
       MM.DEPARTMENTNAME AS 處部,
       MM.EMPLOYEENO AS 工號,
       MM.EMPLOYEENAME AS 姓名,
       MM.PERFORMANCEAPPRAISALNAME AS 績效表,
       MM.SALARYLEVEL AS 師位,
       MM.JOBTITLE AS 職稱,
       NN.SELFTOTAL AS 自評總評分,
       MM.DIRECTSUPERVISORNAMEA AS 初核1主管,
       NN.DIRECTTOTALA AS 初核1評分,
       MM.DIRECTSUPERVISORNAMEB AS 初核2主管,
       NN.DIRECTTOTALB AS 初核2評分,
       MM.REVIEWSUPERVISORNAME AS 會評主管,
       MM.REVIEWSUPERVISORTOTALSCORE AS 會評評分,
       MM.REASSESSEDSUPERVISORNAME AS 複評主管,
       MM.REASSESSEDSUPERVISORTOTALSCORE AS 複評評分,
       MM.REASSESSEDSUPERVISORGRADE AS 複評等級,
       MM.APPROVEDSUPERVISORNAME AS 核准主管,
       MM.APPROVEDSUPERVISORTOTALSCORE AS 核准評分,
       MM.APPROVEDSUPERVISORGRADE AS 核准等級
  FROM (SELECT A.ASSESSMENTPROCEDUREID,
               A.EMPLOYEENO,
               A.DEPARTMENTNAME,
               A.EMPLOYEENAME,
               A.PERFORMANCEAPPRAISALNAME,
               B.SALARYLEVEL,
               B.JOBTITLE,
               A.DIRECTSUPERVISORNAMEA,
               A.DIRECTSUPERVISORNAMEB,
               E.REVIEWSUPERVISORNAME,
               D.REVIEWSUPERVISORTOTALSCORE,
               A.REASSESSEDSUPERVISORNAME,
               D.REASSESSEDSUPERVISORTOTALSCORE,
               D.REASSESSEDSUPERVISORGRADE,
               A.APPROVEDSUPERVISORNAME,
               D.APPROVEDSUPERVISORTOTALSCORE,
               D.APPROVEDSUPERVISORGRADE
          FROM ASSESSMENTPROCEDURE A
               LEFT JOIN EMPLOYEEINFORMATION B ON A.EMPLOYEENO = B.EMPLOYEENO
               LEFT JOIN PERFORMANCEAPPRAISAL C
                  ON A.ASSESSMENTPROCEDUREID = C.ASSESSMENTPROCEDUREID
               LEFT JOIN GENERAL D
                  ON C.PERFORMANCEAPPRAISALID = D.PERFORMANCEAPPRAISALID
               LEFT JOIN REVIEWSUPERVISOR E ON A.EMPLOYEENO = E.EMPLOYEENO)
       MM
       LEFT JOIN
       (  SELECT M.ASSESSMENTPROCEDUREID,
                 SUM (
                    CASE M.APPROVETYPE
                       WHEN N'0'
                       THEN
                            M.EXECUTIONTOTALSCORE
                          + M.SUCTOTALSCORE
                          + M.TRAITTOTALSCORE
                       ELSE
                          0
                    END)
                    AS SELFTOTAL,
                 SUM (
                    CASE M.APPROVETYPE
                       WHEN N'10'
                       THEN
                            M.EXECUTIONTOTALSCORE
                          + M.SUCTOTALSCORE
                          + M.TRAITTOTALSCORE
                       ELSE
                          0
                    END)
                    AS DIRECTTOTALA,
                 SUM (
                    CASE M.APPROVETYPE
                       WHEN N'20'
                       THEN
                            M.EXECUTIONTOTALSCORE
                          + M.SUCTOTALSCORE
                          + M.TRAITTOTALSCORE
                       ELSE
                          0
                    END)
                    AS DIRECTTOTALB
            FROM (SELECT AAAA.ASSESSMENTPROCEDUREID,
                         CASE
                            WHEN AAAA.EXECUTIONTOTALSCORE IS NOT NULL
                            THEN
                               AAAA.EXECUTIONTOTALSCORE
                            ELSE
                               0
                         END
                            AS EXECUTIONTOTALSCORE,
                         AAAA.APPROVETYPE,
                         CASE
                            WHEN BBBB.SUCTOTALSCORE IS NOT NULL
                            THEN
                               BBBB.SUCTOTALSCORE
                            ELSE
                               0
                         END
                            AS SUCTOTALSCORE,
                         CASE
                            WHEN CCCC.TRAITTOTALSCORE IS NOT NULL
                            THEN
                               CCCC.TRAITTOTALSCORE
                            ELSE
                               0
                         END
                            AS TRAITTOTALSCORE
                    FROM (  SELECT A.ASSESSMENTPROCEDUREID,
                                   CASE A.PERFORMANCEAPPRAISALNAME
                                      WHEN N'附表A' THEN SUM (G.SCORE) * 0.4
                                      WHEN N'附表B' THEN SUM (I.SCORE) * 0.5
                                      WHEN N'附表C' THEN SUM (K.SCORE) * 0.7
                                      ELSE 0
                                   END
                                      AS EXECUTIONTOTALSCORE,
                                   CASE
                                      WHEN G.APPROVETYPE IS NOT NULL
                                      THEN
                                         G.APPROVETYPE
                                      WHEN I.APPROVETYPE IS NOT NULL
                                      THEN
                                         I.APPROVETYPE
                                      WHEN K.APPROVETYPE IS NOT NULL
                                      THEN
                                         K.APPROVETYPE
                                      ELSE
                                         N''
                                   END
                                      AS APPROVETYPE
                              FROM ASSESSMENTPROCEDURE A
                                   LEFT JOIN EMPLOYEEINFORMATION B
                                      ON A.EMPLOYEENO = B.EMPLOYEENO
                                   LEFT JOIN PERFORMANCEAPPRAISAL C
                                      ON A.ASSESSMENTPROCEDUREID =
                                            C.ASSESSMENTPROCEDUREID
                                   LEFT JOIN EXECUTIONA F
                                      ON C.PERFORMANCEAPPRAISALID =
                                            F.PERFORMANCEAPPRAISALAID
                                   LEFT JOIN EXECUTIONSCOREA G
                                      ON F.EXECUTIONAID = G.EXECUTIONAID
                                   LEFT JOIN EXECUTIONB H
                                      ON C.PERFORMANCEAPPRAISALID =
                                            H.PERFORMANCEAPPRAISALBID
                                   LEFT JOIN EXECUTIONSCOREB I
                                      ON H.EXECUTIONBID = I.EXECUTIONBID
                                   LEFT JOIN EXECUTIONC J
                                      ON C.PERFORMANCEAPPRAISALID =
                                            J.PERFORMANCEAPPRAISALCID
                                   LEFT JOIN EXECUTIONSCOREC K
                                      ON J.EXECUTIONCID = K.EXECUTIONCID
                          GROUP BY A.ASSESSMENTPROCEDUREID,
                                   A.PERFORMANCEAPPRAISALNAME,
                                   G.APPROVETYPE,
                                   I.APPROVETYPE,
                                   K.APPROVETYPE) AAAA
                         LEFT JOIN
                         (  SELECT AA.ASSESSMENTPROCEDUREID,
                                   SUM (CC.SCORE) * 0.2 AS SUCTOTALSCORE,
                                   CC.APPROVETYPE
                              FROM PERFORMANCEAPPRAISAL AA
                                   LEFT JOIN SUCCESSOR BB
                                      ON AA.PERFORMANCEAPPRAISALID =
                                            BB.PERFORMANCEAPPRAISALAID
                                   LEFT JOIN SUCCESSORSCORE CC
                                      ON BB.SUCCESSORID = CC.SUCCESSORID
                          GROUP BY AA.ASSESSMENTPROCEDUREID, CC.APPROVETYPE)
                         BBBB
                            ON     AAAA.ASSESSMENTPROCEDUREID =
                                      BBBB.ASSESSMENTPROCEDUREID
                               AND AAAA.APPROVETYPE = BBBB.APPROVETYPE
                         LEFT JOIN
                         (SELECT AAA.ASSESSMENTPROCEDUREID,
                                 CASE
                                    WHEN BBB.SCORE IS NOT NULL THEN BBB.SCORE
                                    WHEN CCC.SCORE IS NOT NULL THEN CCC.SCORE
                                    WHEN DDD.SCORE IS NOT NULL THEN DDD.SCORE
                                    ELSE 0
                                 END
                                    AS TRAITTOTALSCORE,
                                 CASE
                                    WHEN BBB.APPROVETYPE IS NOT NULL
                                    THEN
                                       BBB.APPROVETYPE
                                    WHEN CCC.APPROVETYPE IS NOT NULL
                                    THEN
                                       CCC.APPROVETYPE
                                    WHEN DDD.APPROVETYPE IS NOT NULL
                                    THEN
                                       DDD.APPROVETYPE
                                    ELSE
                                       N''
                                 END
                                    AS APPROVETYPE
                            FROM PERFORMANCEAPPRAISAL AAA
                                 LEFT JOIN WCTOTALSCOREC BBB
                                    ON AAA.PERFORMANCEAPPRAISALID =
                                          BBB.PERFORMANCEAPPRAISALCID
                                 LEFT JOIN PTTOTALSCOREA CCC
                                    ON AAA.PERFORMANCEAPPRAISALID =
                                          CCC.PERFORMANCEAPPRAISALAID
                                 LEFT JOIN PTTOTALSCOREB DDD
                                    ON AAA.PERFORMANCEAPPRAISALID =
                                          DDD.PERFORMANCEAPPRAISALBID) CCCC
                            ON     AAAA.ASSESSMENTPROCEDUREID =
                                      CCCC.ASSESSMENTPROCEDUREID
                               AND AAAA.APPROVETYPE = CCCC.APPROVETYPE) M
        GROUP BY M.ASSESSMENTPROCEDUREID) NN
          ON MM.ASSESSMENTPROCEDUREID = NN.ASSESSMENTPROCEDUREID
 --WHERE EMPLOYEENO LIKE 'F3234352%'
