shops_views <- 'SELECT
    date AS Date,
    ShopsViewed AS ShopID,
    Type_1 AS Visitor_Type,
    COUNT(DISTINCT visitId) AS Sessions_Viewed_Shop,
    SUM(flag) AS Sessions_With_Order
    --- SUM(CASE WHEN C.TransactionShopId IS NULL THEN visitId ELSE 0 END) AS Session_Without_Order
    FROM (
    SELECT
    B.visitId AS visitId,
    (CASE WHEN B.visitNumber=1 THEN "NEW" ELSE "RETURNING" END) AS Type_1,
    B.ShopsViewed AS ShopsViewed,
    C.Type AS Type,
    C.TransactionShopId,
    B.date AS date,
    (CASE
    WHEN C.TransactionShopId!=B.ShopsViewed THEN 0
    ELSE
    (CASE
    WHEN C.TransactionShopId IS NULL THEN 0
    ELSE 1
    END)
    END) AS flag
    --   REGEXP_MATCH(B.ShopsViewed,' * C.TransactionShopId * ') AS flag
    FROM (
    SELECT
    visitId,
    visitNumber,
    hits.eventInfo.eventLabel AS ShopsViewed,
    date,
    --     GROUP_CONCAT(hits.eventInfo.eventLabel,', ') AS ShopsViewed
    FROM
    TABLE_DATE_RANGE([befbcg---efood-clickdelivery:111421313.ga_sessions_],TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-10,"DAY")),TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),0,"DAY")))
    WHERE
    hits.eventInfo.eventAction = 'shop.clicked'
    GROUP BY
    1,
    2,
    3,
    4) B
    LEFT JOIN (
    SELECT
    visitId,
    hits.eventInfo.eventLabel AS Type,
    CASE
    WHEN hits.customDimensions.index = 20 THEN hits.customDimensions.value
    END AS TransactionShopId
    FROM
    TABLE_DATE_RANGE([befbcg---efood-clickdelivery:111421313.ga_sessions_],TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),-10,"DAY")),TIMESTAMP(DATE_ADD(TIMESTAMP(CURRENT_DATE()),0,"DAY"))) AS B
    WHERE
    hits.eventInfo.eventAction = 'transaction'
    GROUP BY
    1,
    2,
    3) C
    ON
    B.visitId = C.visitId
    GROUP BY
    1,
    2,
    3,
    4,
    5,
    6,
    7)
    GROUP BY
    1,
    2,
    3
    ORDER BY
    1,
    4 DESC
    '